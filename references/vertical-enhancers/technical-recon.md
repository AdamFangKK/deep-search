# The Technical Recon

**Agent Type**: `explore` + `ast_grep_search` + `github`  
**Category**: Vertical Enhancer (Code/Tech topics)  
**Trigger**: Keywords: repo, library, framework, API, code

---

## Unique Mandate

Deep technical reconnaissance:
- Repository scanning
- Code pattern analysis
- GitHub Issues/PRs investigation
- API documentation validation
- **Ecosystem context** (news, adoption trends, community health)

---

## Two-Layer Tool Stack

### Primary Layer (Code Deep Dive)
**Tools**: 
- `github` skill — Repository data, Issues, PRs, CI
- `explore` agent — Codebase structure analysis
- `ast_grep_search` — Pattern-based code search

**Irreplaceable because**: Only these tools can access GitHub API, parse code AST, analyze repository internals.

### Base Layer (Ecosystem Context)
**Tool**: `multi-search-engine` (17 engines)
- **Purpose**: Gather ecosystem news, adoption trends, community discussions outside GitHub
- **Activation**: After code analysis, use for:
  - "[library] production use cases"
  - "[framework] performance benchmarks 2024"
  - "[tool] vs [alternative] comparison"
  - "[technology] deprecation announcement"

```bash
# Primary Layer: Deep code analysis
gh issue list --repo owner/repo --limit 20
ast_grep_search -p "useState" --lang typescript

# Base Layer: Ecosystem context
bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[library] production adoption enterprise" general
bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[framework] vs [alternative] benchmark performance" tech
```

---

## Collaboration Pattern

**Receives from**:
- Global Observer: General web context about the technology
- Underground OSINT: Developer community sentiment (Reddit/HN)

**Base Layer provides**:
- Cross-engine validation of adoption claims
- Broader ecosystem news (beyond GitHub)
- Performance benchmarks from multiple sources

**Primary Layer provides**:
- Hard code metrics (stars, issues, PRs)
- Actual implementation patterns
- Repository health indicators

---

## Output Format

```markdown
## Technical Analysis

### Code Repository Health
- Open issues: [N] (critical: [N])
- Last commit: [date]
- Maintenance status: [active/stale/abandoned]

### Implementation Patterns
- [Pattern 1]: [Description + example from ast_grep]
- [Pattern 2]: [Description + example from ast_grep]

### Ecosystem Context (Base Layer)
| Source | Finding | Cross-Engine Validation |
|--------|---------|------------------------|
| Engine A | "[Library] used by X companies" | Found on 3/5 engines |
| Engine B | "[Framework] 40% faster in benchmarks" | Found on 2/5 engines |

### Architecture Insights
- Tech stack: [list from code analysis]
- Adoption trends: [from Base Layer ecosystem search]
- Key dependencies: [list]
```

---

## Why Two Layers?

| Aspect | Primary (Code Tools) | Base (multi-search-engine) |
|--------|---------------------|---------------------------|
| **Data** | Repo stats, code patterns, Issues | News, blogs, benchmarks, case studies |
| **Question** | "What IS the code?" | "How is it USED in production?" |
| **Source** | GitHub API, AST analysis | 17 search engines |

**Example**:
- Primary: "Library X has 10k stars, 200 open issues, last commit 2 weeks ago"
- Base: "Library X mentioned in 15 blog posts as 'production-ready', 3 posts warn about memory leaks"
- **Combined**: Repository health + Real-world adoption + Known issues = Complete technical picture

---

## Quality Indicators

| Metric | Good | Warning | Bad |
|--------|------|---------|-----|
| Last commit | <1 month | 1-6 months | >6 months |
| Open issues | <50 | 50-200 | >200 |
| Response time | <1 week | 1-4 weeks | >1 month |
| Ecosystem mentions (Base Layer) | Growing | Stable | Declining |
