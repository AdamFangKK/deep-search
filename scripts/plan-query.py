#!/usr/bin/env python3
"""Build a config-driven execution plan for deep-search."""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path


def load_json(path: Path) -> dict:
    with path.open() as fh:
        return json.load(fh)


def normalize(text: str) -> str:
    return re.sub(r"\s+", " ", text.strip().lower())


def score_route(route: dict, query: str) -> tuple[int, list[str]]:
    matched = []
    score = 0
    lowered = normalize(query)
    for keyword in route.get("keywords", []):
        if keyword.lower() in lowered:
            matched.append(keyword)
            score += 1
    return score, matched


def choose_route(query: str, routing: dict) -> tuple[dict, list[str]]:
    best_route = routing["default_route"]
    best_score = -1
    best_matches: list[str] = []
    for route in routing.get("routes", []):
        score, matches = score_route(route, query)
        if score > best_score:
            best_route = route
            best_score = score
            best_matches = matches
    if best_score <= 0:
        return routing["default_route"], []
    return best_route, best_matches


def choose_profile(query: str, profiles: dict) -> str:
    lowered = normalize(query)
    deep_markers = ["deep", "comprehensive", "详细", "全面", "彻底", "deep search", "due diligence"]
    fast_markers = ["quick", "brief", "summary", "fast"]
    if any(marker in lowered for marker in deep_markers):
        return "deep"
    if any(marker in lowered for marker in fast_markers):
        return "fast"
    return "default"


def provider_installed(provider: str, home_skills: Path, workspace_skills: Path) -> bool:
    return (home_skills / provider).exists() or (workspace_skills / provider).exists()


def resolve_capabilities(
    required_names: list[str],
    capability_registry: dict,
    home_skills: Path,
    workspace_skills: Path,
    allow_fallbacks: bool,
) -> list[dict]:
    capability_map = {item["name"]: item for item in capability_registry.get("capabilities", [])}
    resolved = []
    for name in required_names:
        capability = capability_map.get(name)
        if not capability:
            resolved.append(
                {
                    "name": name,
                    "status": "UNDEFINED",
                    "provider": None,
                    "fallback_used": False,
                    "required": False,
                }
            )
            continue
        provider = capability["primary_provider"]
        fallback_used = False
        status = "READY" if provider_installed(provider, home_skills, workspace_skills) else "MISSING"
        if status == "MISSING" and allow_fallbacks:
            for fallback in capability.get("fallback_providers", []):
                if provider_installed(fallback, home_skills, workspace_skills):
                    provider = fallback
                    status = "FALLBACK"
                    fallback_used = True
                    break
        resolved.append(
            {
                "name": name,
                "status": status,
                "provider": provider if status in {"READY", "FALLBACK"} else capability["primary_provider"],
                "fallback_used": fallback_used,
                "required": capability.get("required", False),
                "used_for": capability.get("used_for", []),
            }
        )
    return resolved


def choose_search_mode(intent: str, capabilities: list[dict]) -> str:
    capability_names = {item["name"] for item in capabilities if item["status"] in {"READY", "FALLBACK"}}
    if intent in {"news_drama", "community"} and "community_discussion" in capability_names:
        return "news"
    if intent in {"business", "legal", "hardware"}:
        return "cn"
    return "general"


def build_plan(query: str, repo_root: Path) -> dict:
    config_dir = repo_root / "config"
    routing = load_json(config_dir / "query-routing.json")
    profiles = load_json(config_dir / "execution-profiles.json")
    capability_registry = load_json(config_dir / "capability-registry.json")
    evidence_policy = load_json(config_dir / "evidence-policy.json")

    route, matched_keywords = choose_route(query, routing)
    profile_name = choose_profile(query, profiles)
    profile = profiles["profiles"][profile_name]

    home_skills = Path.home() / ".agents" / "skills"
    workspace_skills = repo_root / "skills"
    required_capabilities = list(route.get("primary_capabilities", [])) + list(route.get("secondary_capabilities", []))
    resolved_capabilities = resolve_capabilities(
        required_capabilities,
        capability_registry,
        home_skills,
        workspace_skills,
        bool(profile.get("allow_fallbacks", True)),
    )

    min_sources = max(profile.get("min_sources", 5), route.get("min_sources", 5))
    min_domains = max(profile.get("min_domains", 3), route.get("min_domains", 3))

    return {
        "query": query,
        "intent": route["intent"],
        "matched_keywords": matched_keywords,
        "primary_agent": route["primary_agent"],
        "profile": profile_name,
        "min_sources": min_sources,
        "min_domains": min_domains,
        "search_mode": choose_search_mode(route["intent"], resolved_capabilities),
        "capabilities": resolved_capabilities,
        "evidence_policy": {
            "dedupe_keys": evidence_policy["dedupe"]["primary_keys"],
            "community_requires_supporting_source": evidence_policy["confidence_rules"]["community_requires_supporting_source"],
            "record_unresolved_conflicts_in_appendix": evidence_policy["conflict_rules"]["record_unresolved_conflicts_in_appendix"],
            "require_confidence_annotation": evidence_policy["synthesis_rules"]["require_confidence_annotation"],
        },
        "report_contract": profile["report_contract"],
    }


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build a config-driven execution plan for deep-search")
    parser.add_argument("query", help="User query to route and plan")
    parser.add_argument("--pretty", action="store_true", help="Pretty-print JSON output")
    return parser.parse_args()


def main() -> int:
    args = parse_args()
    repo_root = Path(__file__).resolve().parent.parent
    plan = build_plan(args.query, repo_root)
    if args.pretty:
        print(json.dumps(plan, indent=2, ensure_ascii=False))
    else:
        print(json.dumps(plan, ensure_ascii=False))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
