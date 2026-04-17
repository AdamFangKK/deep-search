---
name: deep-search-executor-adaptive
description: Deep Search 可执行入口 - 智能动态调整版（自适应代理数量）
version: 6.0.0
---

# Deep Search Executor v6.0 (Adaptive Agent Scaling)

## Stable Contract References

The following files are the stable non-breaking contract layer:

- `contracts/output-contract.md`
- `contracts/evidence-schema.json`
- `config/capability-registry.json`
- `config/execution-profiles.json`
- `config/query-routing.json`

This file owns the execution contract. It should not silently redefine the report shape or provider semantics without updating those contract files.

**核心优化**: 根据查询复杂度智能调整代理数量
**目标**: 简单查询30秒，复杂查询2分钟，资源利用最优

---

## 架构变更 (v6.0)

**关键改进**: 代理数量不再是固定的，而是根据查询复杂度动态调整！

| 版本 | 搜索代理 | 分析代理 | 总代理数 | 适用场景 |
|------|----------|----------|----------|----------|
| v5.0 | 6 (固定) | 4 (固定) | 10 | 所有查询 |
| **v6.0** | **3-12** | **2-8** | **5-20** | **自适应** |

**智能分级**:
| 复杂度 | 搜索代理 | 分析代理 | 总代理 | 预估用时 | 适用场景 |
|--------|----------|----------|--------|----------|----------|
| **Simple** | 4 | 3 | 7 | 30-45秒 | 简单事实查询 |
| **Medium** | 6 | 4 | 10 | 45-60秒 | 标准新闻查询 |
| **Complex** | 9 | 6 | 15 | 60-90秒 | 深度研究报告 |
| **Extreme** | 12 | 8 | 20 | 90-120秒 | 全面行业分析 |

---

## 查询复杂度分析模块

### 分组逻辑（由6个子代理并行执行）

```
Search Agent 1: Google 系 (3个)
├─ Google
├─ Google HK
└─ Bing INT (Google 结果补充)

Search Agent 2: 隐私引擎 (4个)
├─ DuckDuckGo
├─ Startpage
├─ Brave
└─ Qwant

Search Agent 3: 国内主流 (4个)
├─ Baidu
├─ Bing CN
├─ Sogou
└─ 360

Search Agent 4: 国内垂直 (3个)
├─ WeChat (公众号)
├─ Toutiao (今日头条)
└─ Jisilu (集思录，金融)

Search Agent 5: 其他国际 (3个)
├─ Yahoo
├─ Ecosia
└─ WolframAlpha (知识计算)

Search Agent 6: 社区讨论 (2个)
├─ HackerNews
└─ V2EX
```

**总并行代理**: 6 个搜索代理 + 4 个分析代理 = 10 个子代理
**总数据源**: 17 个搜索 + 2 个社区 = 19 个数据源

---

## 执行流程 (全子代理并行)

```
PHASE 1: 6个搜索代理并行搜索 - 目标: 20-30 秒
├─ Search Agent 1: Google系 (3引擎)    ═══════════ 子代理并行
├─ Search Agent 2: 隐私引擎 (4引擎)     ═══════════ 子代理并行
├─ Search Agent 3: 国内主流 (4引擎)     ═══════════ 子代理并行
├─ Search Agent 4: 国内垂直 (3引擎)     ═══════════ 子代理并行
├─ Search Agent 5: 其他国际 (3引擎)     ═══════════ 子代理并行
└─ Search Agent 6: HN + V2EX (2社区)  ═══════════ 子代理并行

用时: 20-30 秒 (最慢的一组决定)

PHASE 2: 4个分析代理并行分析 - 目标: 20-30 秒
├─ Global Observer Analyst       ═══════════ 子代理并行
├─ Underground OSINT Analyst     ═══════════ 子代理并行
├─ Oracle Analyst                ═══════════ 子代理并行
└─ Vertical Enhancer Analyst     ═══════════ 子代理并行

用时: 20-30 秒

PHASE 3: 快速合成 - 目标: 10-15 秒
└─ 整合19个数据源 + 4个分析结果

总用时: 50-75 秒（不到1分钟，19个数据源）
```

---

## 查询复杂度分析模块

### 复杂度评估算法

```typescript
/**
 * 查询复杂度评估器
 * 输入: 用户查询
 * 输出: 复杂度等级 + 推荐代理数量
 */
function analyzeQueryComplexity(query: string): ComplexityConfig {
  // 1. 计算各项指标
  const metrics = {
    // 关键词数量 (多关键词 = 更复杂)
    keywordCount: query.split(/\s+/).length,
    
    // 是否包含比较类词汇 (对比分析更复杂)
    hasComparison: /对比|比较|vs|versus|区别|差异/i.test(query),
    
    // 是否包含时间范围 (时间跨度大 = 更复杂)
    hasTimeRange: /年度|年度|历史|趋势|回顾|发展/i.test(query),
    
    // 是否包含行业/领域词汇 (专业领域 = 更复杂)
    hasIndustryTerms: /行业|产业|市场|投资|融资|IPO|估值/i.test(query),
    
    // 是否要求深度分析 (深度 = 更复杂)
    requiresDepth: /深度|详细|全面|完整|彻底|透彻/i.test(query),
    
    // 查询长度 (越长越具体或越复杂)
    queryLength: query.length
  };
  
  // 2. 计算复杂度分数
  const score = 
    metrics.keywordCount * 2 +
    (metrics.hasComparison ? 15 : 0) +
    (metrics.hasTimeRange ? 10 : 0) +
    (metrics.hasIndustryTerms ? 12 : 0) +
    (metrics.requiresDepth ? 20 : 0) +
    Math.min(metrics.queryLength / 5, 10);
  
  // 3. 映射到复杂度等级
  if (score < 20) {
    return {
      level: 'simple',
      searchAgents: 4,
      analysisAgents: 3,
      totalAgents: 7,
      timeout: { search: 30000, analysis: 30000 },
      description: '简单事实查询'
    };
  } else if (score < 40) {
    return {
      level: 'medium',
      searchAgents: 6,
      analysisAgents: 4,
      totalAgents: 10,
      timeout: { search: 40000, analysis: 45000 },
      description: '标准新闻查询'
    };
  } else if (score < 60) {
    return {
      level: 'complex',
      searchAgents: 9,
      analysisAgents: 6,
      totalAgents: 15,
      timeout: { search: 50000, analysis: 60000 },
      description: '深度研究报告'
    };
  } else {
    return {
      level: 'extreme',
      searchAgents: 12,
      analysisAgents: 8,
      totalAgents: 20,
      timeout: { search: 60000, analysis: 90000 },
      description: '全面行业分析'
    };
  }
}

// 复杂度配置接口
interface ComplexityConfig {
  level: 'simple' | 'medium' | 'complex' | 'extreme';
  searchAgents: number;
  analysisAgents: number;
  totalAgents: number;
  timeout: { search: number; analysis: number };
  description: string;
}
```

### 复杂度等级对照表

| 复杂度 | 分数范围 | 搜索代理 | 分析代理 | 搜索引擎 | 数据源数 | 适用场景 |
|--------|----------|----------|----------|----------|----------|----------|
| **Simple** | 0-20 | 4 | 3 | 8-10 | 5-8 | 事实查询、简单问题 |
| **Medium** | 20-40 | 6 | 4 | 14-16 | 8-12 | 新闻查询、标准研究 |
| **Complex** | 40-60 | 9 | 6 | 18-20 | 12-16 | 深度分析、行业研究 |
| **Extreme** | 60+ | 12 | 8 | 21+ | 16-20 | 全面回顾、竞争分析 |

### 示例评估

```
查询: "今日硅谷圈新闻"
- keywordCount: 4
- hasComparison: false
- hasTimeRange: false (无年度/趋势)
- hasIndustryTerms: false
- requiresDepth: false
- queryLength: 8

分数 = 4*2 + 0 + 0 + 0 + 0 + 1.6 = 9.6
等级: Simple (4搜索 + 3分析 = 7代理)

---

查询: "AI行业2026年度回顾与2027预测"
- keywordCount: 8
- hasComparison: false
- hasTimeRange: true (年度、回顾、预测)
- hasIndustryTerms: true (行业)
- requiresDepth: false
- queryLength: 16

分数 = 8*2 + 0 + 10 + 12 + 0 + 3.2 = 39.2
等级: Medium (6搜索 + 4分析 = 10代理)

---

查询: "深度对比分析OpenAI vs Anthropic vs Google在大模型领域的技术路线、商业模式与估值差异"
- keywordCount: 15
- hasComparison: true (对比、vs、差异)
- hasTimeRange: false
- hasIndustryTerms: true (估值、商业模式)
- requiresDepth: true (深度)
- queryLength: 38

分数 = 15*2 + 15 + 0 + 12 + 20 + 7.6 = 84.6
等级: Extreme (12搜索 + 8分析 = 20代理)
```

---

## 指令执行块

### STEP 0: 复杂度分析

**在启动任何代理之前，先分析查询复杂度**：

```typescript
// STEP 0: 分析查询复杂度，决定代理数量
const complexityConfig = analyzeQueryComplexity("{{topic}}");

console.log(`📊 查询复杂度: ${complexityConfig.level}`);
console.log(`📊 推荐配置: ${complexityConfig.searchAgents}搜索 + ${complexityConfig.analysisAgents}分析 = ${complexityConfig.totalAgents}代理`);
console.log(`📊 预估用时: ${complexityConfig.timeout.search/1000}秒搜索 + ${complexityConfig.timeout.analysis/1000}秒分析`);
```

### STEP 1: 动态启动搜索代理

**根据复杂度配置，动态启动搜索代理**：

```typescript
// 定义所有可能的搜索代理配置
const allSearchAgentConfigs = [
  { name: "Google系", engines: ["google", "google_hk", "bing_int"], skill: "multi-search-engine", priority: 1 },
  { name: "隐私引擎", engines: ["duckduckgo", "startpage", "brave", "qwant"], skill: "multi-search-engine", priority: 2 },
  { name: "国内主流", engines: ["baidu", "bing_cn", "sogou", "360"], skill: "multi-search-engine", priority: 2 },
  { name: "国内垂直", engines: ["wechat", "toutiao", "jisilu"], skill: "multi-search-engine", priority: 3 },
  { name: "其他国际", engines: ["yahoo", "ecosia", "wolframalpha"], skill: "multi-search-engine", priority: 3 },
  { name: "社区讨论", engines: ["hackernews", "v2ex"], skill: "news-aggregator-skill", priority: 2 },
  { name: "GitHub", engines: ["github"], skill: "github", priority: 4 },
  { name: "StackOverflow", engines: ["stackoverflow"], skill: "multi-search-engine", priority: 4 },
  { name: "Reddit", engines: ["reddit"], skill: "websearch-exa", priority: 4 },
  { name: "Twitter/X", engines: ["twitter"], skill: "websearch-exa", priority: 4 },
  { name: "学术论文", engines: ["arxiv", "scholar"], skill: "academic-deep-research", priority: 5 },
  { name: "新闻聚合", engines: ["newsapi"], skill: "news-aggregator-skill", priority: 5 }
];

// 根据复杂度选择代理
function selectSearchAgents(config: ComplexityConfig): SearchAgentConfig[] {
  // Simple: 只选优先级1-2的代理 (4个)
  // Medium: 选优先级1-3的代理 (6个)
  // Complex: 选优先级1-4的代理 (9个)
  // Extreme: 选全部代理 (12个)
  
  const maxPriority = {
    'simple': 2,
    'medium': 3,
    'complex': 4,
    'extreme': 5
  }[config.level];
  
  return allSearchAgentConfigs
    .filter(agent => agent.priority <= maxPriority)
    .slice(0, config.searchAgents);
}

// 动态创建搜索代理
const selectedAgents = selectSearchAgents(complexityConfig);

const searchAgents = selectedAgents.map(agentConfig => 
  task({
    category: "quick",
    load_skills: [agentConfig.skill],
    run_in_background: true,
    description: `Search Agent - ${agentConfig.name}`,
    prompt: `
## 任务: 搜索 ${agentConfig.name}

搜索关键词: "{{topic}}"
负责引擎: ${agentConfig.engines.join(", ")}

使用 ${agentConfig.skill} 搜索以上引擎，每个引擎返回5条结果。

## 输出格式
返回 JSON 格式的搜索结果数组。

## 要求
- 每个引擎返回5条结果
- 包含标题、URL、摘要
- 按相关性排序
`
  })
);

console.log(`🚀 启动 ${searchAgents.length} 个搜索代理...`);
```

**使用 task() 创建6个子代理并行执行搜索**：

```typescript
// Search Agent 1: Google系 (3引擎)
const searchAgent1 = task({
  category: "quick",
  load_skills: ["multi-search-engine"],
  run_in_background: true,
  description: "Search Agent 1 - Google系",
  prompt: `
## 任务: 搜索 Google 系引擎

使用 multi-search-engine skill 搜索以下引擎：
1. Google: query="{{topic}}", engine="google", numResults=5
2. Google HK: query="{{topic}}", engine="google_hk", numResults=5
3. Bing INT: query="{{topic}}", engine="bing_int", numResults=5

## 输出格式
返回 JSON 格式的搜索结果数组：
[
  {"engine": "google", "title": "...", "url": "...", "snippet": "..."},
  ...
]

## 要求
- 每个引擎返回5条结果
- 包含标题、URL、摘要
- 按相关性排序
`
});

// Search Agent 2: 隐私引擎 (4引擎)
const searchAgent2 = task({
  category: "quick",
  load_skills: ["multi-search-engine"],
  run_in_background: true,
  description: "Search Agent 2 - 隐私引擎",
  prompt: `
## 任务: 搜索隐私引擎

使用 multi-search-engine skill 搜索以下引擎：
1. DuckDuckGo: query="{{topic}}", engine="duckduckgo", numResults=5
2. Startpage: query="{{topic}}", engine="startpage", numResults=5
3. Brave: query="{{topic}}", engine="brave", numResults=5
4. Qwant: query="{{topic}}", engine="qwant", numResults=5

## 输出格式
返回 JSON 格式的搜索结果数组。

## 要求
- 每个引擎返回5条结果
- 包含标题、URL、摘要
- 按相关性排序
`
});

// Search Agent 3: 国内主流 (4引擎)
const searchAgent3 = task({
  category: "quick",
  load_skills: ["multi-search-engine"],
  run_in_background: true,
  description: "Search Agent 3 - 国内主流",
  prompt: `
## 任务: 搜索国内主流引擎

使用 multi-search-engine skill 搜索以下引擎：
1. Baidu: query="{{topic}}", engine="baidu", numResults=5
2. Bing CN: query="{{topic}}", engine="bing_cn", numResults=5
3. Sogou: query="{{topic}}", engine="sogou", numResults=5
4. 360: query="{{topic}}", engine="360", numResults=5

## 输出格式
返回 JSON 格式的搜索结果数组。

## 要求
- 每个引擎返回5条结果
- 包含标题、URL、摘要
- 按相关性排序
`
});

// Search Agent 4: 国内垂直 (3引擎)
const searchAgent4 = task({
  category: "quick",
  load_skills: ["multi-search-engine"],
  run_in_background: true,
  description: "Search Agent 4 - 国内垂直",
  prompt: `
## 任务: 搜索国内垂直引擎

使用 multi-search-engine skill 搜索以下引擎：
1. WeChat (公众号): query="{{topic}}", engine="wechat", numResults=5
2. Toutiao (今日头条): query="{{topic}}", engine="toutiao", numResults=5
3. Jisilu (集思录): query="{{topic}}", engine="jisilu", numResults=5

## 输出格式
返回 JSON 格式的搜索结果数组。

## 要求
- 每个引擎返回5条结果
- 包含标题、URL、摘要
- 按相关性排序
`
});

// Search Agent 5: 其他国际 (3引擎)
const searchAgent5 = task({
  category: "quick",
  load_skills: ["multi-search-engine"],
  run_in_background: true,
  description: "Search Agent 5 - 其他国际",
  prompt: `
## 任务: 搜索其他国际引擎

使用 multi-search-engine skill 搜索以下引擎：
1. Yahoo: query="{{topic}}", engine="yahoo", numResults=5
2. Ecosia: query="{{topic}}", engine="ecosia", numResults=5
3. WolframAlpha: query="{{topic}}", engine="wolframalpha", numResults=3

## 输出格式
返回 JSON 格式的搜索结果数组。

## 要求
- Yahoo/Ecosia 各返回5条结果
- WolframAlpha 返回3条结果（计算型搜索）
- 包含标题、URL、摘要
`
});

// Search Agent 6: 社区搜索 (2个)
const searchAgent6 = task({
  category: "quick",
  load_skills: ["news-aggregator-skill"],
  run_in_background: true,
  description: "Search Agent 6 - 社区讨论",
  prompt: `
## 任务: 搜索社区讨论

使用 news-aggregator-skill 搜索以下社区：
1. HackerNews: source="hackernews", limit=10, keyword="{{topic}}"
2. V2EX: source="v2ex", limit=10, keyword="{{topic}}"

## 输出格式
返回 JSON 格式：
{
  "hackernews": [...],
  "v2ex": [...]
}

## 要求
- 每个社区返回10条相关讨论
- 包含标题、URL、发布时间
- 按相关性排序
`
});

// 并行启动所有6个搜索代理
const searchAgents = [searchAgent1, searchAgent2, searchAgent3, 
                      searchAgent4, searchAgent5, searchAgent6];

// 收集所有搜索结果
const searchResults = await Promise.all(
  searchAgents.map(agent => 
    background_output({task_id: agent.task_id, timeout: 40000})
  )
);

// 聚合所有搜索结果
const allSearchResults = searchResults.flatMap(result => 
  result.success ? result.data : []
);

const allCommunityResults = {
  hackernews: searchResults[5]?.data?.hackernews || [],
  v2ex: searchResults[5]?.data?.v2ex || []
};

const successfulAgents = searchResults.filter(r => r.success).length;
```

### STEP 2: 数据预处理和去重

```typescript
// 去重和排序（按相关性/时间）
const uniqueResults = deduplicateByUrl(allSearchResults);
const topResults = uniqueResults.slice(0, 30); // 取前30个最相关的

// 按来源分类
const resultsBySource = {
  google: filterByEngine(topResults, "google"),
  baidu: filterByEngine(topResults, "baidu"),
  duckduckgo: filterByEngine(topResults, "duckduckgo"),
  // ... 其他引擎
};

const searchData = {
  topic: "{{topic}}",
  timestamp: new Date().toISOString(),
  totalEngines: 17,
  successfulEngines: successfulEngines,
  totalResults: uniqueResults.length,
  topResults: topResults,
  resultsBySource: resultsBySource,
  communityResults: allCommunityResults
};
```

### STEP 3: 动态启动分析代理

**根据复杂度配置，动态启动分析代理**：

```typescript
// 定义所有可能的分析代理配置
const allAnalystConfigs = [
  { name: "Global Observer", category: "quick", priority: 1, 
    description: "分析官方立场和主流媒体报道", 
    promptTemplate: "分析官方立场(2-3点)、主流媒体报道(3-4点)、信息可靠性、覆盖缺口" },
  { name: "Underground OSINT", category: "quick", priority: 1, 
    description: "分析社区讨论和用户反馈", 
    promptTemplate: "分析用户反馈(2-3点)、常见问题(2-3点)、社区情感、未被官方提及的问题" },
  { name: "Oracle", category: "ultrabrain", priority: 2, 
    description: "偏见检测和利益相关方分析", 
    promptTemplate: "识别利益相关方(2-3个)、潜在偏见(2-3点)、隐藏动机" },
  { name: "Vertical Enhancer", category: "deep", priority: 2, 
    description: "领域深度分析", 
    promptTemplate: "基于主题类型进行深入分析：研究趋势、技术架构、商业模式、事件脉络" },
  { name: "Fact Checker", category: "quick", priority: 3, 
    description: "事实核查和交叉验证", 
    promptTemplate: "验证关键事实、交叉比对多个来源、识别矛盾信息" },
  { name: "Trend Analyzer", category: "quick", priority: 3, 
    description: "趋势分析和预测", 
    promptTemplate: "分析发展趋势、预测未来走向、识别转折点" },
  { name: "Competitor Analyst", category: "deep", priority: 4, 
    description: "竞争格局分析", 
    promptTemplate: "分析竞争格局、市场份额、竞争优势、战略动向" },
  { name: "Risk Assessor", category: "ultrabrain", priority: 4, 
    description: "风险评估", 
    promptTemplate: "识别潜在风险、评估影响程度、提出应对建议" }
];

// 根据复杂度选择分析代理
function selectAnalysisAgents(config: ComplexityConfig): AnalystConfig[] {
  // Simple: 只选优先级1的代理 (2个)
  // Medium: 选优先级1-2的代理 (4个)
  // Complex: 选优先级1-3的代理 (6个)
  // Extreme: 选全部代理 (8个)
  
  const maxPriority = {
    'simple': 1,
    'medium': 2,
    'complex': 3,
    'extreme': 4
  }[config.level];
  
  return allAnalystConfigs
    .filter(analyst => analyst.priority <= maxPriority)
    .slice(0, config.analysisAgents);
}

// 动态创建分析代理
const selectedAnalysts = selectAnalysisAgents(complexityConfig);

const analysisAgents = selectedAnalysts.map(analystConfig => 
  task({
    category: analystConfig.category,
    load_skills: [],
    run_in_background: true,
    description: `${analystConfig.name} - ${analystConfig.description}`,
    prompt: `
## 任务: ${analystConfig.description}

## 输入数据
主题: {{topic}}
总结果数: ${allSearchResults.length}
搜索代理数: ${successfulAgents} 个

按来源分类的数据:
- 国际引擎: ${JSON.stringify(allSearchResults.filter(r => r.engine?.includes('google') || r.engine?.includes('bing')).slice(0, 3))}
- 国内引擎: ${JSON.stringify(allSearchResults.filter(r => ['baidu', 'sogou', '360'].includes(r.engine)).slice(0, 3))}
- 社区讨论: ${JSON.stringify(allCommunityResults)}

## 分析要求
${analystConfig.promptTemplate}

## 输出格式
返回 JSON 格式的分析结果。

只分析提供的数据，禁止额外搜索！
`
  })
);

console.log(`🧠 启动 ${analysisAgents.length} 个分析代理...`);

// 收集所有分析结果
const analysisResults = await Promise.all(
  analysisAgents.map(agent => 
    background_output({task_id: agent.task_id, timeout: complexityConfig.timeout.analysis})
  )
);
```

### STEP 4: 结果聚合

```typescript
// 聚合搜索结果
const searchData = {
  topic: "{{topic}}",
  timestamp: new Date().toISOString(),
  complexity: complexityConfig.level,
  totalSearchAgents: complexityConfig.searchAgents,
  successfulSearchAgents: successfulAgents,
  totalResults: allSearchResults.length,
  topResults: allSearchResults.slice(0, 30),
  communityResults: allCommunityResults
};

// 聚合分析结果
const analysisData = {};
selectedAnalysts.forEach((analyst, index) => {
  analysisData[analyst.name.toLowerCase().replace(/\s+/g, '_')] = 
    analysisResults[index]?.data || {};
});
```

### STEP 5: 快速生成报告

```markdown
# ⚡ Deep-Search: {{topic}} 全景分析报告

**生成时间**: ${new Date().toLocaleString()}  
**查询复杂度**: ${complexityConfig.level} (${complexityConfig.description})
**数据源**: ${successfulAgents}/${complexityConfig.searchAgents} 个搜索代理  
**分析维度**: ${analysisAgents.length} 个分析代理  
**总数据点**: ${searchData.totalResults} 条结果  
**总用时**: ~${(Date.now() - startTime)/1000} 秒

---

## 1. 执行摘要
${extractKeyPoints(analysisResults)}

## 2. 多源数据分析

${selectedAnalysts.map((analyst, index) => `
### 2.${index + 1} ${analyst.name}
${analyst.description}
${analysisData[analyst.name.toLowerCase().replace(/\s+/g, '_')]}
`).join('\n')}

## 3. 关键判断与建议
- **置信度**: ${calculateConfidence(analysisResults)}
- **信息缺口**: ${identifyGaps(analysisResults)}
- **P0建议**: ${generateRecommendations(analysisResults)}

## 4. 数据源详情
| 搜索代理 | 引擎 | 状态 | 结果数 |
|----------|------|------|--------|
${selectedAgents.map((agent, index) => 
  `| ${agent.name} | ${agent.engines.join(', ')} | ${searchResults[index]?.success ? '✅' : '❌'} | ${searchResults[index]?.data?.length || 0} |`
).join('\n')}

## 5. 资源使用统计
| 指标 | 数值 |
|------|------|
| 搜索代理 | ${complexityConfig.searchAgents} 个 |
| 分析代理 | ${complexityConfig.analysisAgents} 个 |
| 总代理数 | ${complexityConfig.totalAgents} 个 |
| 搜索超时 | ${complexityConfig.timeout.search/1000} 秒 |
| 分析超时 | ${complexityConfig.timeout.analysis/1000} 秒 |
```
| Agent 5 | Yahoo, Ecosia, WolframAlpha | ${searchResults[4]?.success ? '✅' : '❌'} | ${searchResults[4]?.data?.length || 0} |
| Agent 6 | HackerNews, V2EX | ${searchResults[5]?.success ? '✅' : '❌'} | ${(searchResults[5]?.data?.hackernews?.length || 0) + (searchResults[5]?.data?.v2ex?.length || 0)} |
```

---

## 性能优化策略

### 1. 全子代理并行
- **6个搜索代理并行**: 每个代理负责3-4个引擎
- **4个分析代理并行**: 每个代理负责不同维度
- **总计10个子代理**: 最大化并行度

### 2. 故障容错
- **Promise.allSettled**: 部分代理失败不影响整体
- **成功代理计数**: 报告实际工作的代理数
- **最小覆盖保证**: 即使部分失败，仍有足够数据

### 3. 数据质量控制
- **去重**: 基于URL去重
- **相关性排序**: 取前30条最相关
- **来源分布**: 确保各代理都有代表

### 4. 超时策略
| 阶段 | 超时 | 说明 |
|------|------|------|
| 搜索代理 | 40秒/代理 | 最慢代理决定Phase 1用时 |
| 分析代理 | 45秒/代理 | 并行，取最慢 |
| 总超时 | 90秒 | 硬性上限 |

### 5. 子代理优势
- **真正并行**: 10个独立执行单元
- **网络访问**: 子代理可以执行搜索（代理配置后）
- **负载分担**: 主代理只负责协调和合成

---

## 17引擎完整列表

| 组 | 引擎 | 类型 | 特点 |
|----|------|------|------|
| A | Google | 国际主流 | 全球最大索引 |
| A | Google HK | 国际主流 | 备用入口 |
| A | Bing INT | 国际主流 | 微软引擎 |
| B | DuckDuckGo | 隐私 | 无追踪 |
| B | Startpage | 隐私 | Google结果+隐私 |
| B | Brave | 隐私 | 独立索引 |
| B | Qwant | 隐私 | 欧盟GDPR合规 |
| C | Baidu | 国内主流 | 最大中文索引 |
| C | Bing CN | 国内主流 | 微软中国 |
| C | Sogou | 国内主流 | 搜狗搜索 |
| C | 360 | 国内主流 | 360搜索 |
| D | WeChat | 国内垂直 | 公众号内容 |
| D | Toutiao | 国内垂直 | 头条新闻 |
| D | Jisilu | 国内垂直 | 金融投资 |
| E | Yahoo | 国际 | 老牌引擎 |
| E | Ecosia | 国际 | 环保搜索 |
| E | WolframAlpha | 知识 | 计算型搜索 |
| - | HackerNews | 社区 | 技术讨论 |
| - | V2EX | 社区 | 中文开发者 |

---

## 执行指令

当此文件被加载时，按顺序执行以下步骤：

1. **STEP 0**: 分析查询复杂度，决定代理数量配置
2. **STEP 1**: 根据配置动态创建搜索代理并行执行搜索
3. **STEP 2**: 等待所有搜索代理完成，聚合结果
4. **STEP 3**: 根据配置动态创建分析代理并行执行分析
5. **STEP 4**: 等待所有分析代理完成，聚合结果
6. **STEP 5**: 生成最终报告（包含资源使用统计）

**预期性能**:

| 复杂度 | 搜索代理 | 分析代理 | 总代理 | 预估用时 | 适用场景 |
|--------|----------|----------|--------|----------|----------|
| **Simple** | 4 | 3 | 7 | 30-45秒 | 简单事实查询 |
| **Medium** | 6 | 4 | 10 | 45-60秒 | 标准新闻查询 |
| **Complex** | 9 | 6 | 15 | 60-90秒 | 深度研究报告 |
| **Extreme** | 12 | 8 | 20 | 90-120秒 | 全面行业分析 |

**关键改进 (v6.0)**:
- 智能动态调整代理数量（不再是固定10个）
- 简单查询只用7个代理，快速完成
- 复杂查询最多20个代理，全面覆盖
- 资源利用率最优，避免浪费
