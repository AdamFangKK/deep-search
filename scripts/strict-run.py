#!/usr/bin/env python3
"""Execute an auditable strict deep-search run."""

from __future__ import annotations

import argparse
import importlib.util
import json
import subprocess
import sys
import time
from pathlib import Path
from typing import Any


ROOT = Path(__file__).resolve().parent.parent
PLAN_QUERY_PATH = ROOT / "scripts" / "plan-query.py"
SWARM_SEARCH_PATH = ROOT / "scripts" / "swarm-search.sh"
NEWS_FETCH_PATH = ROOT / "skills" / "news-aggregator-skill" / "scripts" / "fetch_news.py"
VERIFY_PATH = ROOT / "scripts" / "verify-contracts.sh"


def load_plan_module():
    spec = importlib.util.spec_from_file_location("plan_query", PLAN_QUERY_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def run_command(command: list[str], cwd: Path) -> subprocess.CompletedProcess[str]:
    return subprocess.run(command, cwd=cwd, text=True, capture_output=True)


def write_json(path: Path, payload: Any) -> None:
    path.write_text(json.dumps(payload, ensure_ascii=False, indent=2) + "\n")


def build_report_template(plan: dict[str, Any], run_summary: dict[str, Any], source_count: int) -> str:
    generated_at = run_summary["generated_at"]
    confidence = "PENDING"
    return f"""# ⚡ Deep-Search: {plan['query']} 全景分析报告
**生成时间**: {generated_at} | **数据点**: PENDING | **来源域**: {source_count} | **整体置信度**: {confidence}

## 1. 执行摘要 / Executive Summary

## 2. 研究方法 / Methodology

## 3. 全景分析 / Universal Analysis

## 4. 实证数据 / Empirical Evidence

## 5. 垂直分析 / Domain Analysis

## 6. 综合评估 / Synthesis

## 7. 行动建议 / Recommendations

## 8. 附录 / Appendices
"""


def section_text(title: str, body: str) -> str:
    return f"## {title}\n{body.strip()}\n"


def collect_source_domains(sources_payload: dict[str, Any]) -> set[str]:
    domains: set[str] = set()
    broad = sources_payload.get("broad_web_search", {})
    if isinstance(broad, dict) and broad.get("results_dir"):
        domains.add("broad_web_search")
    for item in sources_payload.get("community_discussion", []):
        if not isinstance(item, dict):
            continue
        source = item.get("source")
        if source:
            domains.add(str(source))
    return domains


def collect_data_point_count(sources_payload: dict[str, Any]) -> int:
    points = 0
    broad = sources_payload.get("broad_web_search", {})
    if isinstance(broad, dict):
        points += int(broad.get("engines_success", 0))
    points += len([item for item in sources_payload.get("community_discussion", []) if isinstance(item, dict)])
    return points


def derive_confidence(plan: dict[str, Any], sources_payload: dict[str, Any], deviations_payload: dict[str, Any]) -> str:
    broad = sources_payload.get("broad_web_search", {})
    community = sources_payload.get("community_discussion", [])
    deviations = deviations_payload.get("deviations", [])
    broad_success = int(broad.get("engines_success", 0)) if isinstance(broad, dict) else 0
    community_count = len([item for item in community if isinstance(item, dict)])
    if broad_success >= plan.get("min_domains", 3) and community_count > 0 and not deviations:
        return "HIGH"
    if broad_success > 0 or community_count > 0:
        return "MEDIUM"
    return "LOW"


def build_final_report(plan: dict[str, Any], run_summary: dict[str, Any], sources_payload: dict[str, Any], deviations_payload: dict[str, Any]) -> dict[str, Any]:
    source_domains = collect_source_domains(sources_payload)
    data_points = collect_data_point_count(sources_payload)
    overall_confidence = derive_confidence(plan, sources_payload, deviations_payload)
    deviations = deviations_payload.get("deviations", [])
    broad = sources_payload.get("broad_web_search", {})
    community = sources_payload.get("community_discussion", [])
    community_titles = [item.get("title", "") for item in community[:5] if isinstance(item, dict)]

    sections = {
        "执行摘要 / Executive Summary": (
            f"本次 strict run 针对查询“{plan['query']}”执行了 planner、broad web search、community discussion 和 artifact synthesis。"
            f"当前收集到 {data_points} 个数据点，来源域 {len(source_domains)}，整体置信度为 {overall_confidence}。"
        ),
        "研究方法 / Methodology": (
            f"执行平台为 {plan['platform']}，strict 模式为 {plan['strict']}。"
            f" planner 将查询路由为 intent={plan['intent']}，primary_agent={plan['primary_agent']}，search_mode={plan.get('search_mode', 'unknown')}。"
            f" broad_web_search 与 community_discussion 均按 artifacts 记录结果。"
        ),
        "全景分析 / Universal Analysis": (
            f"broad_web_search 概览：成功引擎 {broad.get('engines_success', 0)} / {broad.get('engines_total', 0)}，"
            f" community_discussion 命中 {len(community)} 条。"
        ),
        "实证数据 / Empirical Evidence": (
            "community_discussion 样本标题：\n"
            + ("\n".join(f"- {title}" for title in community_titles) if community_titles else "- 无可解析 community 样本")
        ),
        "垂直分析 / Domain Analysis": (
            f"当前 primary_agent 为 {plan['primary_agent']}，说明本次查询被视为 {plan['intent']} 类研究任务。"
            "严格模式下只基于 artifact 已记录结果合成，不额外引入未记录搜索。"
        ),
        "综合评估 / Synthesis": (
            f"整体置信度 {overall_confidence}。"
            + (" 存在执行偏差，需要结合 deviations.json 审核。" if deviations else " 当前未记录执行偏差。")
        ),
        "行动建议 / Recommendations": (
            "1. 若 broad_web_search 失败较多，优先检查网络与 provider 健康。\n"
            "2. 若 community_discussion 为空，调整关键词或增加社区源。\n"
            "3. 在人工复核后再将此 strict run 作为最终对外研究结论。"
        ),
        "附录 / Appendices": (
            "Artifacts:\n"
            + "\n".join(f"- {name}: {path}" for name, path in run_summary.get("artifacts", {}).items())
        ),
    }
    return {
        "title": f"⚡ Deep-Search: {plan['query']} 全景分析报告",
        "generated_at": run_summary["generated_at"],
        "data_points": data_points,
        "source_domains": len(source_domains),
        "overall_confidence": overall_confidence,
        "sections": sections,
    }


def render_final_report_markdown(report: dict[str, Any]) -> str:
    ordered_titles = [
        "执行摘要 / Executive Summary",
        "研究方法 / Methodology",
        "全景分析 / Universal Analysis",
        "实证数据 / Empirical Evidence",
        "垂直分析 / Domain Analysis",
        "综合评估 / Synthesis",
        "行动建议 / Recommendations",
        "附录 / Appendices",
    ]
    header = (
        f"# {report['title']}\n"
        f"**生成时间**: {report['generated_at']} | **数据点**: {report['data_points']} | "
        f"**来源域**: {report['source_domains']} | **整体置信度**: {report['overall_confidence']}\n\n"
    )
    body_parts = []
    for index, title in enumerate(ordered_titles, start=1):
        body_parts.append(f"## {index}. {title}\n{report['sections'][title].strip()}\n")
    body = "\n".join(body_parts)
    return header + body


def parse_news_output(stdout: str) -> list[dict[str, Any]]:
    lines = [line for line in stdout.splitlines() if not line.startswith("/Users/")]
    content = "\n".join(lines).strip()
    if not content:
        return []
    start = content.find("[")
    end = content.rfind("]")
    if start == -1 or end == -1:
        return []
    return json.loads(content[start : end + 1])


def collect_deviation(deviations: list[dict[str, str]], stage: str, summary: str, detail: str) -> None:
    deviations.append({"stage": stage, "summary": summary, "detail": detail})


def default_output_dir() -> Path:
    return Path("/tmp/omo-deep-search") / f"strict-run-{int(time.time())}"


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="Run deep-search in strict auditable mode")
    parser.add_argument("query", help="Research query")
    parser.add_argument(
        "--platform",
        default="codex",
        choices=["opencode", "codex", "claude-code", "hermes", "openclaw"],
        help="Target host platform",
    )
    parser.add_argument("--output-dir", help="Directory for strict-run artifacts")
    parser.add_argument("--community-limit", type=int, default=10, help="Per-source community fetch limit")
    return parser


def main() -> int:
    args = build_parser().parse_args()
    output_dir = Path(args.output_dir) if args.output_dir else default_output_dir()
    output_dir.mkdir(parents=True, exist_ok=True)

    plan_module = load_plan_module()
    plan = plan_module.build_plan(args.query, ROOT, args.platform, strict=True)
    plan_path = output_dir / "plan.json"
    write_json(plan_path, plan)

    run_summary: dict[str, Any] = {
        "query": args.query,
        "platform": args.platform,
        "strict": True,
        "generated_at": time.strftime("%Y-%m-%dT%H:%M:%SZ", time.gmtime()),
        "report_contract": plan["report_contract"],
        "artifact_contract": plan["artifact_contract"],
        "artifacts": {},
        "stages": {},
    }
    deviations: list[dict[str, str]] = []
    sources_payload: dict[str, Any] = {"broad_web_search": {}, "community_discussion": []}

    verify = run_command(["bash", str(VERIFY_PATH)], ROOT)
    run_summary["stages"]["verify_contracts"] = {
        "status": "completed" if verify.returncode == 0 else "failed",
        "returncode": verify.returncode,
    }
    (output_dir / "verify-contracts.stdout.txt").write_text(verify.stdout)
    (output_dir / "verify-contracts.stderr.txt").write_text(verify.stderr)
    if verify.returncode != 0:
        collect_deviation(deviations, "verify_contracts", "Contract verification failed", verify.stderr.strip() or verify.stdout.strip())

    search = run_command(["bash", str(SWARM_SEARCH_PATH), "--plan", str(plan_path)], ROOT)
    run_summary["stages"]["broad_web_search"] = {
        "status": "completed" if search.returncode == 0 else "failed",
        "returncode": search.returncode,
    }
    (output_dir / "swarm-search.stdout.txt").write_text(search.stdout)
    (output_dir / "swarm-search.stderr.txt").write_text(search.stderr)

    search_results_dir = None
    for line in search.stdout.splitlines():
        if line.startswith("📁 Results: "):
            search_results_dir = Path(line.split("📁 Results: ", 1)[1].strip())
            break
    if search_results_dir and (search_results_dir / "summary.json").exists():
        search_summary = json.loads((search_results_dir / "summary.json").read_text())
        sources_payload["broad_web_search"] = search_summary
        if search_summary.get("engines_fail", 0) > 0:
            collect_deviation(
                deviations,
                "broad_web_search",
                "Some search engines failed during strict run",
                json.dumps(
                    {
                        "engines_total": search_summary.get("engines_total"),
                        "engines_success": search_summary.get("engines_success"),
                        "engines_fail": search_summary.get("engines_fail"),
                        "results_dir": search_summary.get("results_dir"),
                    },
                    ensure_ascii=False,
                ),
            )
    else:
        collect_deviation(deviations, "broad_web_search", "No search summary produced", search.stderr.strip() or search.stdout.strip())

    community_ready = any(
        item["name"] == "community_discussion" and item["status"] in {"READY", "FALLBACK"} for item in plan["capabilities"]
    )
    if community_ready:
        community = run_command(
            [
                sys.executable,
                str(NEWS_FETCH_PATH),
                "--source",
                "hackernews,v2ex",
                "--limit",
                str(args.community_limit),
                "--keyword",
                args.query,
                "--deep",
            ],
            ROOT,
        )
        run_summary["stages"]["community_discussion"] = {
            "status": "completed" if community.returncode == 0 else "failed",
            "returncode": community.returncode,
        }
        (output_dir / "community.stdout.txt").write_text(community.stdout)
        (output_dir / "community.stderr.txt").write_text(community.stderr)
        if community.returncode == 0:
            community_items = parse_news_output(community.stdout)
            sources_payload["community_discussion"] = community_items
            if not community_items:
                collect_deviation(deviations, "community_discussion", "Community layer returned no parsed items", community.stdout.strip())
        else:
            collect_deviation(deviations, "community_discussion", "Community layer failed", community.stderr.strip() or community.stdout.strip())
    else:
        run_summary["stages"]["community_discussion"] = {"status": "skipped", "reason": "capability unavailable"}
        collect_deviation(deviations, "community_discussion", "Community capability unavailable", "Planner did not resolve a READY/FALLBACK provider")

    write_json(output_dir / "sources.json", sources_payload)
    deviations_payload = {"deviations": deviations}
    write_json(output_dir / "deviations.json", deviations_payload)

    source_count = len(
        {
            "broad_web_search" if sources_payload["broad_web_search"] else None,
            *{
                item.get("source", "")
                for item in sources_payload["community_discussion"]
                if isinstance(item, dict) and item.get("source")
            },
        }
        - {None, ""}
    )
    report_template = build_report_template(plan, run_summary, source_count)
    (output_dir / "report-template.md").write_text(report_template)

    final_report = build_final_report(plan, run_summary, sources_payload, deviations_payload)
    final_report_markdown = render_final_report_markdown(final_report)
    write_json(output_dir / "final-report.json", final_report)
    (output_dir / "final-report.md").write_text(final_report_markdown)

    run_summary["stages"]["synthesis"] = {
        "status": "completed",
        "returncode": 0,
    }

    run_summary["artifacts"] = {
        "plan": str(plan_path),
        "sources": str(output_dir / "sources.json"),
        "deviations": str(output_dir / "deviations.json"),
        "report_template": str(output_dir / "report-template.md"),
        "final_report_json": str(output_dir / "final-report.json"),
        "final_report_markdown": str(output_dir / "final-report.md"),
    }
    write_json(output_dir / "run-summary.json", run_summary)

    print(str(output_dir))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
