import json
import tempfile
import unittest
from pathlib import Path
import importlib.util


MODULE_PATH = Path(__file__).resolve().parents[1] / "scripts" / "strict-run.py"
SPEC = importlib.util.spec_from_file_location("strict_run", MODULE_PATH)
strict_run = importlib.util.module_from_spec(SPEC)
assert SPEC.loader is not None
SPEC.loader.exec_module(strict_run)


class StrictRunTests(unittest.TestCase):
    def test_report_template_contains_required_sections(self) -> None:
        plan = {"query": "test query"}
        run_summary = {"generated_at": "2026-04-17T00:00:00Z"}
        template = strict_run.build_report_template(plan, run_summary, 3)
        self.assertIn("执行摘要 / Executive Summary", template)
        self.assertIn("附录 / Appendices", template)

    def test_parse_news_output_extracts_json_array(self) -> None:
        stdout = "/Users/example/warn\n[{\"source\":\"Hacker News\",\"url\":\"https://example.com\"}]"
        parsed = strict_run.parse_news_output(stdout)
        self.assertEqual(parsed[0]["source"], "Hacker News")

    def test_write_json_round_trip(self) -> None:
        with tempfile.TemporaryDirectory() as tmp:
            path = Path(tmp) / "artifact.json"
            payload = {"strict": True, "artifacts": ["plan.json"]}
            strict_run.write_json(path, payload)
            self.assertEqual(json.loads(path.read_text()), payload)

    def test_build_final_report_derives_metadata(self) -> None:
        plan = {"query": "test query", "intent": "universal", "primary_agent": "Global Observer", "platform": "codex", "strict": True}
        run_summary = {"generated_at": "2026-04-17T00:00:00Z", "artifacts": {"plan": "/tmp/plan.json"}}
        sources_payload = {
            "broad_web_search": {"engines_success": 2, "engines_total": 5, "results_dir": "/tmp/results"},
            "community_discussion": [{"source": "Hacker News", "title": "Example"}],
        }
        deviations_payload = {"deviations": []}
        report = strict_run.build_final_report(plan, run_summary, sources_payload, deviations_payload)
        self.assertEqual(report["data_points"], 3)
        self.assertEqual(report["source_domains"], 2)
        self.assertIn("执行摘要 / Executive Summary", report["sections"])

    def test_render_final_report_markdown_includes_metadata(self) -> None:
        report = {
            "title": "⚡ Deep-Search: test",
            "generated_at": "2026-04-17T00:00:00Z",
            "data_points": 3,
            "source_domains": 2,
            "overall_confidence": "MEDIUM",
            "sections": {
                "执行摘要 / Executive Summary": "summary",
                "研究方法 / Methodology": "method",
                "全景分析 / Universal Analysis": "analysis",
                "实证数据 / Empirical Evidence": "evidence",
                "垂直分析 / Domain Analysis": "domain",
                "综合评估 / Synthesis": "synthesis",
                "行动建议 / Recommendations": "recommendations",
                "附录 / Appendices": "appendix",
            },
        }
        markdown = strict_run.render_final_report_markdown(report)
        self.assertIn("整体置信度", markdown)
        self.assertIn("## 8. 附录 / Appendices", markdown)


if __name__ == "__main__":
    unittest.main()
