# The Hardware Inspector

**Execution Surface**: `broad_web_search` + optional `document_processing`  
**Category**: Vertical Enhancer (Hardware topics)  
**Trigger**: Keywords: hardware, chip, device, teardown, benchmark, repair

---

## Unique Mandate

Hardware analysis and validation:
- Component teardowns (iFixit)
- Supply chain analysis
- Benchmark validation
- Repairability assessment
- **Product reviews and long-term reliability data**

---

## Two-Layer Tool Stack

### Primary Layer (Hardware Deep Dive)
**Capabilities**:
- `broad_web_search` for teardowns, filings, benchmarks, spec sheets
- optional `document_processing` for datasheets or filings when extraction is needed

**Irreplaceable because**: Only iFixit provides professional teardowns; only FCC has regulatory filings.

```text
Primary Layer examples:
- teardown coverage
- FCC or regulatory filings
- datasheet/specification lookup
```

### Base Layer (Review Aggregation)
**Capability**: `broad_web_search`
- **Purpose**: Gather diverse reviews, long-term reliability reports, user complaints
- **Activation**: For:
  - "[device] review AnandTech Tom's Hardware"
  - "[device] long term reliability issues"
  - "[device] vs [competitor] benchmark"
  - "[device] user complaints problems"
  - "[device] recall defect"

```bash
# Base Layer: Diverse reviews and user feedback
bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[device] review benchmark comparison" general

bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[device] problems defects after 1 year" general

bash ~/.agents/skills/deep-search/scripts/swarm-search.sh \
  "[device] recall safety issue" news
```

---

## Analysis Framework

### Component Breakdown (Primary Layer)
| Component | Supplier | Est. Cost | Function | Source |
|-----------|----------|-----------|----------|--------|
| [Chip name] | [Vendor] | $X | [Purpose] | iFixit teardown |

### Performance Benchmarks (Base Layer Aggregated)
| Metric | This Product | Competitor A | Competitor B | Source Diversity |
|--------|--------------|--------------|--------------|------------------|
| [Benchmark] | [Score] | [Score] | [Score] | Reviews from X/17 engines |

### Repairability (Primary Layer)
- iFixit Score: [X/10]
- Common failures: [list from iFixit]
- Repair difficulty: [Easy/Med/Hard]
- Parts availability: [from Base Layer]

### Long-Term Reliability (Base Layer)
| Issue | Reported Frequency | Source Spread | Severity |
|-------|-------------------|---------------|----------|
| [Issue 1] | [Common/Rare] | Found on X/17 engines | [High/Med/Low] |
| [Issue 2] | [Common/Rare] | Found on X/17 engines | [High/Med/Low] |

### Supply Chain Risks (Primary + Base)
- Geographic concentration: [Risk level - from Primary specs]
- Single source dependencies: [List - from Primary]
- **Alternative suppliers**: [from Base Layer industry news]
- **Supply chain news**: [Shortages, found on X/17 engines]

---

## Collaboration Pattern

**Receives from**:
- Global Observer: General product launch coverage
- Underground OSINT: User community complaints (Reddit repair communities)
- Technical Recon: Software/firmware issues affecting hardware

**Primary Layer provides**:
- Professional teardown data (iFixit)
- Regulatory compliance (FCC)
- Component specifications

**Base Layer provides**:
- Diverse review aggregation (not just one site's opinion)
- Long-term reliability data (1+ year usage)
- User-reported issues across forums
- Market availability and pricing

---

## Output Format

```markdown
## Hardware Analysis

### Component Breakdown (Primary Layer)
| Component | Supplier | Est. Cost | Source |
|-----------|----------|-----------|--------|
| [Chip] | [Vendor] | $X | iFixit teardown |

### Performance Validation (Base Layer)
| Benchmark | This Device | Competitors | Review Diversity |
|-----------|-------------|-------------|------------------|
| [Test] | [Score] | [A, B scores] | X/17 engines |

**Cross-Engine Consistency**: [High/Med/Low] - Do reviews agree?

### Repairability (Primary Layer)
- iFixit Score: [X/10]
- Common failures: [list]
- **Parts availability**: [from Base Layer search]

### Long-Term Reliability (Base Layer)
- **Issues found across engines**: [Summary]
- **User complaints frequency**: [Common/Isolated]
- **Recall history**: [Found/None found on X/17 engines]

### Supply Chain (Primary + Base)
- Geographic risk: [Level - Primary]
- Alternative suppliers: [Found in Base Layer industry news]
- Supply chain disruptions: [News coverage across X/17 engines]

### Value Assessment
- **Build cost estimate**: [from Primary teardown]
- **Market price**: [from Base Layer]
- **Repair vs replace**: [Recommendation]
```

---

## Why Two Layers?

| Aspect | Primary (teardown/spec sources) | Base (`broad_web_search`) |
|--------|---------------------|---------------------------|
| **Data** | Professional teardowns, regulatory specs | User reviews, benchmarks, reliability reports |
| **Source** | iFixit, FCC, manufacturer | 17 search engines |
| **Question** | "What's INSIDE and is it legal?" | "How does it PERFORM and LAST?" |

**Example**:
- Primary: "iPhone 15 Pro has A17 Pro chip, 8GB RAM, iFixit repairability 4/10"
- Base: "15 reviews: performance excellent; 6 forums mention overheating after 6 months"
- **Combined**: Specs + Real-world reliability = Informed purchase/avoidance decision

---

## Review Aggregation Strategy

**Problem**: Single review site may be biased (affiliate links, early access perks)

**Solution**: Base Layer cross-engine validation
```
Review Claim: "Battery lasts 12 hours"
├── Engine A (Tech blog): "12 hours" ✅
├── Engine B (YouTube): "10-11 hours" ⚠️
├── Engine C (Forum): "8 hours real usage" ❌
└── Consistency: LOW - Claim disputed
```

**Primary Layer**: Hard specs (battery capacity: 4000mAh)
**Base Layer**: Real-world usage reports
**Combined**: Capacity is there, but efficiency varies by use case
