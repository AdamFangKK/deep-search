# Deep-Search Report Format v3.2

**Standard 8-section report structure for comprehensive research deliverables.**

This document defines the complete report format. SKILL.md provides the execution protocol; this file provides the output specification.

---

## Report Overview

```markdown
# ⚡ Deep-Search: [Topic] 全景分析报告
**生成时间**: [Timestamp] | **数据点**: [N] | **来源域**: [N] | **整体置信度**: [HIGH/MEDIUM/LOW]
```

---

## Anti-Convergence Principle

**This report format assumes wide source diversity. Do NOT converge prematurely.**

### The Trap
❌ **Wrong**: "I have 3 sources with 8-9 points each = 25 points. Done!"

✅ **Correct**: "I have 15 sources with 1-3 points each = 25 points. Comprehensive!"

### Source Distribution Requirements

| Metric | Minimum | Target | Maximum Per Source |
|--------|---------|--------|-------------------|
| Total data points | 15 | 20-25 | — |
| Distinct sources | 10 | 12+ | — |
| Points per source | 1 | 2-3 | 5 |

### Warning Signs of Premature Convergence

Check your source list. If you see:
- [ ] 3-4 sources dominating (>70% of points)
- [ ] Any single source with >5 points
- [ ] All sources from same domain (e.g., only tech blogs)

**Action**: Expand search immediately. Launch additional agents.

### Quality Check for This Report

Before finalizing, verify in Section 4 (Empirical Evidence):
```markdown
### 4.1 关键引用
| 序号 | 引用内容 | 来源 | 时间 | 置信度 |
|------|---------|------|------|--------|
| 1 | [...] | A | [...] | HIGH |
| 2 | [...] | B | [...] | HIGH |
| 3 | [...] | C | [...] | MEDIUM |
| ...| [...] | D | [...] | HIGH |
| 25 | [...] | M | [...] | MEDIUM |

Source diversity: A, B, C, D, E, F, G, H, I, J, K, L, M (13 sources) ✅
Max per source: 3 points ✅
```

---

## Section 1: 执行摘要 (Executive Summary)

**Purpose**: Provide decision-makers with immediate actionable insights (BLUF principle).

### Structure
```markdown
### 核心结论
[一句话概括最关键的发现，不超过100字]

### 关键证据
- [证据1，带超链接]
- [证据2，带超链接]

### 多视角评估
| 视角 | 评估 | 依据 |
|------|------|------|
| 官方立场 | [立场描述] | [来源] |
| 市场反馈 | [反馈描述] | [来源] |
| 技术层面 | [技术评估] | [来源] |
| 合规状况 | [合规评估] | [来源] |

### 建议措施
[P0优先级建议，最多3条]
```

### Data Sources
- **Global Observer**: Official stance, timeline
- **Oracle**: Incentive analysis, risk assessment
- **Synthesizer**: Aggregated recommendations

---

## Section 2: 研究方法 (Methodology)

**Purpose**: Document scope, approach, and limitations for transparency and reproducibility.

### Structure
```markdown
### 搜索范围
- **数据层**: Universal (17引擎) + Community (Reddit/HN) + Academic + Code + Document
- **时间范围**: [起始] - [结束]
- **语言范围**: 中文/英文/[其他]

### 数据质量指标
| 指标 | 数值 | 标准 |
|------|------|------|
| 原始数据点 | [N] | ≥15 |
| 去重后数据点 | [N] | — |
| 来源域多样性 | [N] | ≥3 |
| 跨引擎验证率 | [N%] | — |
| 时效性(近2年) | [N%] | ≥70% |

### 局限性声明
- [数据盲区1]
- [数据盲区2]
- [潜在偏见来源]
```

### Data Sources
- **Orchestrator**: Tool deployment log, scope decisions
- All Agents: Coverage gaps reported

---

## Section 3: 全景分析 (Universal Analysis)

**Purpose**: Cross-perspective synthesis of institutional vs. grassroots narratives.

### Structure
```markdown
### 3.1 时间线与架构
[事件发展时间线或系统架构描述]

### 3.2 多源信息对比
| 维度 | 官方/机构叙述 | 社区/市场反馈 | 差异分析 |
|------|--------------|--------------|----------|
| 核心主张 | [内容] | [内容] | [对比] |
| 关键数据 | [数据] | [数据] | [对比] |
| 风险评估 | [评估] | [评估] | [对比] |

### 3.3 利益相关方分析
| 相关方 | 利益诉求 | 信息立场 | 可信度评估 |
|--------|---------|----------|-----------|
| [方1] | [诉求] | [立场] | [HIGH/MED/LOW] |
| [方2] | [诉求] | [立场] | [HIGH/MED/LOW] |
```

### Data Sources
- **Global Observer**: Official sources, timeline
- **Underground OSINT**: Community narratives
- **Oracle**: Stakeholder analysis, bias detection

---

## Section 4: 实证数据 (Empirical Evidence)

**Purpose**: Present raw evidence with full provenance for verification.

### Structure
```markdown
### 4.1 关键引用
| 序号 | 引用内容 | 来源 | 时间 | 置信度 |
|------|---------|------|------|--------|
| 1 | [内容] | [URL] | [时间] | [HIGH/MED/LOW] |
| 2 | [内容] | [URL] | [时间] | [HIGH/MED/LOW] |

### 4.2 验证记录
| 验证项 | 方法 | 结果 | 输出 |
|--------|------|------|------|
| [测试1] | [方法] | ✅/❌ | [stdout/stderr] |
```

### Data Sources
- **All Agents**: Data points collected
- **Technical Recon**: Empirical validation results
- **Synthesizer**: Confidence assessment

---

## Section 5: 垂直分析 (Domain Analysis)

**Purpose**: Domain-specific deep dive based on topic type.

Select ONE framework based on primary intent:

### 5A. 技术类主题 (Technical)

**Source**: Technical Recon Agent

```markdown
#### 技术实现评估
- 架构设计: [评估]
- 代码质量: [评估]
- 维护状态: [评估]

#### 生产环境考量
- 已知问题: [列表]
- 性能特征: [数据]
- 替代方案: [对比]

#### 采用建议
- 适用场景: [描述]
- 风险评估: [等级]
- 实施建议: [步骤]
```

### 5B. 商业类主题 (Business)

**Source**: Compliance Auditor Agent

```markdown
#### 商业模式分析
- 盈利逻辑: [描述]
- 成本结构: [分析]
- 可持续性: [评估]

#### 合规与风险
- 监管合规: [状态]
- 财务健康: [指标]
- 重大风险: [列表]

#### 市场定位
- 竞争格局: [分析]
- 差异化因素: [识别]
- 前景评估: [判断]
```

### 5C. 新闻/事件类主题 (News/Event)

**Source**: Fact Assassin Agent

```markdown
#### 事实核查
- 核心主张: [验证]
- 时间线核实: [结果]
- 信息来源: [评估]

#### 多方叙述对比
- 官方版本: [内容]
- 独立报道: [内容]
- 社区反应: [内容]

#### 影响评估
- 直接影响: [范围]
- 次生效应: [预测]
- 长期意义: [判断]
```

### 5D. 学术类主题 (Academic)

**Source**: The Scholar Agent

```markdown
#### 文献综述
- 核心论文: [列表]
- 研究趋势: [分析]
- 争议焦点: [识别]

#### 方法论评估
- 研究设计: [评估]
- 数据来源: [分析]
- 结论可靠性: [判断]

#### 研究缺口
- [待验证的假设]
- [未覆盖的视角]
```

### 5E. 法律类主题 (Legal)

**Source**: Legal Decoder Agent

```markdown
#### 法规适用性
- 适用法规: [列表]
- 条款解读: [分析]
- 合规要求: [清单]

#### 案例参考
- 类似案例: [列表]
- 判决结果: [摘要]
- 对本主题的影响: [分析]

#### 风险与建议
- 法律风险: [评估]
- 合规建议: [措施]
```

### 5F. 硬件类主题 (Hardware)

**Source**: Hardware Inspector Agent

```markdown
#### 技术规格
- 组件分析: [列表]
- 性能指标: [数据]
- 可维修性: [评估]

#### 长期使用评估
- 可靠性数据: [分析]
- 常见问题: [列表]
- 用户反馈: [摘要]

#### 采购建议
- 适用场景: [描述]
- 性价比分析: [评估]
- 替代方案: [对比]
```

---

## Section 6: 综合评估 (Synthesis)

**Purpose**: Higher-level analysis with confidence assessment and alternative explanations.

### Structure
```markdown
### 6.1 关键判断
| 判断 | 置信度 | 依据 | 备选解释 |
|------|--------|------|----------|
| [判断1] | [HIGH/MED/LOW] | [N个数据点] | [其他可能] |
| [判断2] | [HIGH/MED/LOW] | [N个数据点] | [其他可能] |

### 6.2 信息缺口
- [无法验证的声明1]
- [待进一步调查的问题2]
```

### Data Sources
- **Oracle**: Key judgments, bias analysis
- **All Agents**: Information gaps reported

---

## Section 7: 行动建议 (Recommendations)

**Purpose**: Specific, prioritized, actionable guidance.

### Structure
```markdown
| 优先级 | 行动项 | 责任方 | 时间线 | 预期结果 |
|--------|--------|--------|--------|----------|
| P0 | [行动] | [责任方] | [时间] | [结果] |
| P1 | [行动] | [责任方] | [时间] | [结果] |
| P2 | [行动] | [责任方] | [时间] | [结果] |
```

### Priority Definitions
- **P0**: Immediate action required (high risk/urgency)
- **P1**: Important but not urgent (address within 30 days)
- **P2**: Nice to have (address when resources permit)

---

## Section 8: 附录 (Appendices)

### 8.1 数据来源清单
```markdown
### Global Observer
- [URL1] | [Timestamp] | [Summary]
- [URL2] | [Timestamp] | [Summary]

### Underground OSINT
- [URL3] | [Timestamp] | [Summary]

### [Other Agents...]
```

### 8.2 置信度评估标准
- **HIGH**: ≥5个独立来源验证，或官方文件证实
- **MEDIUM**: 2-4个来源，或单一权威来源
- **LOW**: 单一来源，或间接证据

### 8.3 术语表
- [术语1]: [定义]
- [术语2]: [定义]

### 8.4 工具与版本
- [工具1]: [版本]
- [工具2]: [版本]

---

## Report Generation Workflow

```
Orchestrator
    ├─ Dispatch 5 Agents with mandates
    ├─ Collect outputs from each Agent
    ├─ Apply this format schema
    └─ Generate final report with 8 sections
```

Each Agent's output (defined in their reference file) feeds into specific sections of this report format.

---

## Version

- v3.2.0 - Initial professional format specification
