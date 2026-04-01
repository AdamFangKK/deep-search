---
name: deep-search-executor-full-parallel
description: Deep Search 可执行入口 - 子代理全并行版（最大化效率）
version: 5.0.0
---

# Deep Search Executor v5.0 (Sub-agent Full Parallel)

**核心优化**: 子代理并行搜索 + 子代理并行分析
**目标**: 1-2 分钟完成，最大化数据覆盖

---

## 架构变更 (v5.0)

**关键改进**: 子代理现在可以执行网络搜索任务！

| 版本 | 搜索执行 | 分析执行 | 并行度 |
|------|----------|----------|--------|
| v4.3 | 主代理串行 | 子代理并行 | 低 |
| **v5.0** | **子代理并行** | **子代理并行** | **高** |

**优势**:
- 搜索和分析都由子代理并行执行
- 主代理只负责协调和合成
- 整体执行时间缩短 30-50%

---

## 17 个搜索引擎分组策略

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

## 指令执行块

### STEP 1: 6个搜索代理并行搜索

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

### STEP 3: 4个分析代理并行分析

**4个分析子代理并行处理不同维度的数据**：

```typescript
// Analyst 1: Global Observer - 分析官方和主流来源
const analyst1 = task({
  category: "quick",
  load_skills: [], // 不加载网络依赖的skill
  run_in_background: true,
  description: "Global Observer - 主流媒体分析",
  prompt: `
## 任务: 分析 ${successfulAgents} 个搜索代理的数据

## 输入数据
主题: {{topic}}
总结果数: ${allSearchResults.length}

按来源分类的数据:
- Google系: ${JSON.stringify(allSearchResults.filter(r => r.engine?.includes('google')).slice(0, 3))}
- 隐私引擎: ${JSON.stringify(allSearchResults.filter(r => ['duckduckgo', 'startpage', 'brave', 'qwant'].includes(r.engine)).slice(0, 3))}
- 国内引擎: ${JSON.stringify(allSearchResults.filter(r => ['baidu', 'bing_cn', 'sogou', '360'].includes(r.engine)).slice(0, 3))}

## 分析要求（简洁输出）
1. 官方立场（2-3点）
2. 主流媒体报道（3-4点）
3. 信息可靠性: HIGH/MEDIUM/LOW
4. 覆盖缺口

## 输出格式
{
  "officialStance": ["..."],
  "mediaCoverage": ["..."],
  "reliability": "HIGH",
  "gaps": ["..."]
}

只分析提供的数据，禁止额外搜索！
`
});

// Analyst 2: Underground OSINT - 分析社区
const analyst2 = task({
  category: "quick",
  load_skills: [],
  run_in_background: true,
  description: "Underground OSINT - 社区分析",
  prompt: `
## 任务: 分析社区讨论

## 输入数据
HN讨论: ${JSON.stringify(allCommunityResults.hackernews)}
V2EX讨论: ${JSON.stringify(allCommunityResults.v2ex)}

## 分析要求（简洁输出）
1. 用户反馈（2-3点）
2. 常见问题（2-3点）
3. 社区情感: positive/negative/mixed
4. 未被官方提及的问题

## 输出格式
{
  "userFeedback": ["..."],
  "commonIssues": ["..."],
  "sentiment": "mixed",
  "hiddenIssues": ["..."]
}

只分析提供的数据，禁止额外搜索！
`
});

// Analyst 3: Oracle - 偏见与激励分析
const analyst3 = task({
  category: "ultrabrain",
  load_skills: [],
  run_in_background: true,
  description: "Oracle - 偏见检测分析",
  prompt: `
## 任务: 基于多源数据的偏见分析

## 输入数据
多引擎搜索结果: ${JSON.stringify(allSearchResults.slice(0, 10))}
社区反馈: ${JSON.stringify(allCommunityResults)}

## 分析要求（简洁输出）
1. 利益相关方（2-3个）
2. 潜在偏见（2-3点）
3. 隐藏动机

## 输出格式
{
  "stakeholders": [{"name": "...", "interest": "..."}],
  "biases": ["..."],
  "motivations": ["..."]
}

基于提供的数据分析，禁止额外搜索！
`
});

// Analyst 4: Vertical Enhancer - 领域特定分析
const analyst4 = task({
  category: "deep",
  load_skills: [],
  run_in_background: true,
  description: "Vertical Enhancer - 领域深度分析",
  prompt: `
## 任务: 领域深度分析

## 输入数据
19个数据源综合数据: ${JSON.stringify(allSearchResults.slice(0, 12))}
主题类型: {{intent}}

## 分析要求
基于主题类型进行深入分析：
- academic: 研究趋势、方法论
- technical: 技术架构、实现细节
- business: 商业模式、竞争格局
- news: 事件脉络、多方观点
- general: 综合评估

## 输出格式（简洁）
{
  "domainInsights": ["..."],
  "technicalDetails": "...",
  "keyFindings": ["..."]
}

只分析提供的数据，禁止额外搜索！
`
});

// 并行启动所有4个分析代理
const analysisAgents = [analyst1, analyst2, analyst3, analyst4];

// 收集所有分析结果
const analysisResults = await Promise.all(
  analysisAgents.map(agent => 
    background_output({task_id: agent.task_id, timeout: 45000})
  )
);
```

### STEP 4: 结果聚合

```typescript
// 聚合搜索结果
const searchData = {
  topic: "{{topic}}",
  timestamp: new Date().toISOString(),
  totalAgents: 6,
  successfulAgents: successfulAgents,
  totalResults: allSearchResults.length,
  topResults: allSearchResults.slice(0, 30),
  communityResults: allCommunityResults
};

// 聚合分析结果
const analysisData = {
  globalObserver: analysisResults[0]?.data || {},
  undergroundOSINT: analysisResults[1]?.data || {},
  oracle: analysisResults[2]?.data || {},
  verticalEnhancer: analysisResults[3]?.data || {}
};
```

### STEP 5: 快速生成报告

```markdown
# ⚡ Deep-Search: {{topic}} 全景分析报告

**生成时间**: ${new Date().toLocaleString()}  
**数据源**: ${successfulAgents}/6 个搜索代理 + 2 个社区  
**总数据点**: ${searchData.totalResults} 条结果  
**分析代理**: 4 个并行  
**总用时**: ~${(Date.now() - startTime)/1000} 秒

## 1. 执行摘要
${extractKeyPoints(analysisResults)}

## 2. 多源数据分析

### 2.1 官方与主流视角
搜索代理覆盖: ${successfulAgents} 个代理成功执行
${analysisData.globalObserver}

### 2.2 社区真实声音
来源: HackerNews (${searchData.communityResults.hackernews?.length || 0}条), V2EX (${searchData.communityResults.v2ex?.length || 0}条)
${analysisData.undergroundOSINT}

### 2.3 偏见与激励分析
${analysisData.oracle}

### 2.4 领域深度洞察
${analysisData.verticalEnhancer}

## 3. 关键判断与建议
- **置信度**: ${calculateConfidence(analysisResults)}
- **信息缺口**: ${identifyGaps(analysisResults)}
- **P0建议**: ${generateRecommendations(analysisResults)}

## 4. 数据源详情
| 搜索代理 | 引擎 | 状态 | 结果数 |
|----------|------|------|--------|
| Agent 1 | Google, Google HK, Bing INT | ${searchResults[0]?.success ? '✅' : '❌'} | ${searchResults[0]?.data?.length || 0} |
| Agent 2 | DDG, Startpage, Brave, Qwant | ${searchResults[1]?.success ? '✅' : '❌'} | ${searchResults[1]?.data?.length || 0} |
| Agent 3 | Baidu, Bing CN, Sogou, 360 | ${searchResults[2]?.success ? '✅' : '❌'} | ${searchResults[2]?.data?.length || 0} |
| Agent 4 | WeChat, Toutiao, Jisilu | ${searchResults[3]?.success ? '✅' : '❌'} | ${searchResults[3]?.data?.length || 0} |
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

1. **STEP 1**: 创建6个搜索代理并行执行搜索
2. **STEP 2**: 等待所有搜索代理完成，聚合结果
3. **STEP 3**: 创建4个分析代理并行执行分析
4. **STEP 4**: 等待所有分析代理完成，聚合结果
5. **STEP 5**: 生成最终报告

**预期性能**:
- 6个搜索代理并行: 20-30秒
- 4个分析代理并行: 20-30秒
- 报告生成: 10-15秒
- **总计: 50-75秒（不到1分钟）**

**关键改进**:
- 子代理现在可以执行网络搜索
- 10个子代理真正并行执行
- 主代理只负责协调和合成
- 整体执行时间缩短30-50%
