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

---

## Primary Tools

### GitHub CLI (SkillHub github)
```bash
# List issues
gh issue list --repo owner/repo --limit 20 --json number,title,state

# List PRs
gh pr list --repo owner/repo --limit 10

# Get specific PR details
gh api repos/owner/repo/pulls/55

# List CI runs
gh run list --repo owner/repo --limit 10

# View failed logs
gh run view <run-id> --repo owner/repo --log-failed
```

### Code Search
```bash
# Pattern-based code search
ast_grep_search -p "[pattern]" --lang [language]

# GitHub code search
grep_app_searchGitHub -q "[query]"
```

### Documentation
```bash
# Context7 for API docs (if available)
context7_query "[library] [api]"

# Fallback: official docs
webfetch "https://docs.[library].com/api"
```

---

## Output Format

```markdown
## Technical Analysis

### Code Patterns
- [Pattern 1]: [Description + example]
- [Pattern 2]: [Description + example]

### Issues Analysis
- Open issues: [N] (critical: [N])
- Common bugs: [list]
- Maintenance status: [active/stale/abandoned]

### Architecture Insights
- Tech stack: [list]
- Key dependencies: [list]
- Design patterns: [list]
```

---

## Quality Indicators

| Metric | Good | Warning | Bad |
|--------|------|---------|-----|
| Last commit | <1 month | 1-6 months | >6 months |
| Open issues | <50 | 50-200 | >200 |
| Response time | <1 week | 1-4 weeks | >1 month |
