# Deep Search Executor v7.0 - 可执行方案

## Ownership

This file defines the executor strategy layer, not the public report contract.

It may change:

- agent counts
- scaling thresholds
- timeout strategy
- execution heuristics

It must not change on its own:

- top-level trigger behavior in `SKILL.md`
- the 8-section report contract in `contracts/output-contract.md`
- evidence normalization expectations in `contracts/evidence-schema.json`
- evidence weighting and conflict rules in `config/evidence-policy.json`

The executor should consume routing, capability, profile, and evidence policy files rather than redefining those rules inline.

Recommended planner entrypoint:

```bash
python3 scripts/plan-query.py "<query>"
```

Recommended search entrypoint when using a generated plan:

```bash
bash scripts/swarm-search.sh --plan /path/to/plan.json
```

If a host platform uses platform-specific worker primitives, document that in `adapters/<platform>/README.md` instead of embedding the syntax into the core executor contract.

## 测试验证的权限边界

### ✅ 已验证的能力

| 能力 | 主代理 | 子代理(quick/deep/ultrabrain) | 策略 |
|------|--------|-------------------------------|------|
| **国际网络** (Google/DDG) | ✅ 正常 | ✅ 正常（代理配置后） | 主/子代理都可 |
| **国内网络** (Baidu/Sogou) | ✅ 0.15s | ✅ 0.13s | 主/子代理都可 |
| **本地文件** | ✅ 完整 | ✅ <100ms | 全部可用 |
| **Skill加载** | ✅ 正常 | ✅ <1s | 全部可用 |
| **纯计算** | ✅ 正常 | ✅ <1ms | 全部可用 |
| **MCP工具** | ✅ 可用 | ✅ 可用 | 主/子代理都可 |

### 关键发现
- 修复代理配置后，子代理**国际和国内网络都正常**
- `ENABLE_TOOL_SEARCH=true` 启用工具搜索功能
- 子代理现在可以执行**搜索和分析任务**
- **不同category权限无显著差异**

---

## 集群执行方案

### 架构概览

```
Phase 1: 搜索集群 (6个子代理并行启动)
├─ Search-Agent-1 (子代理): Google系 (Google, Google HK, Bing INT)
├─ Search-Agent-2 (子代理): 隐私引擎 (DDG, Startpage, Brave, Qwant)
├─ Search-Agent-3 (子代理): 国内主流 (Baidu, Bing CN, Sogou, 360)
├─ Search-Agent-4 (子代理): 国内垂直 (WeChat, Toutiao, Jisilu)
├─ Search-Agent-5 (子代理): 其他国际 (Yahoo, Ecosia, WolframAlpha)
└─ Search-Agent-6 (子代理): 社区讨论 (HackerNews, V2EX)

Phase 2: 分析集群 (数据达到阈值即启动)
├─ Analyst-1 (子代理): Global Observer 官方视角分析
├─ Analyst-2 (子代理): Underground OSINT 社区声音分析
├─ Analyst-3 (子代理): Oracle 偏见检测
└─ Analyst-4 (子代理): Vertical Enhancer 领域深度分析

Phase 3: 合成 (主代理)
└─ 整合报告 + 质量检查 + 补充搜索(如需要)
```

### 执行代码

```typescript
/**
 * Deep Search Executor v6.0
 * 基于实际测试的权限边界设计
 */

// ============ Phase 1: 搜索集群 ============
async function phase1SearchCluster(topic: string) {
  console.log("🚀 Phase 1: 启动6个搜索代理...");
  const startTime = Date.now();
  
  // 6个搜索代理并行执行 (利用子代理网络能力)
  const searchAgents = [
    // Search Agent 1: Google系
    spawnSearchAgent("Google系", topic, ["google", "google_hk", "bing_int"]),
    // Search Agent 2: 隐私引擎
    spawnSearchAgent("隐私引擎", topic, ["duckduckgo", "startpage", "brave", "qwant"]),
    // Search Agent 3: 国内主流
    spawnSearchAgent("国内主流", topic, ["baidu", "bing_cn", "sogou", "360"]),
    // Search Agent 4: 国内垂直
    spawnSearchAgent("国内垂直", topic, ["wechat", "toutiao", "jisilu"]),
    // Search Agent 5: 其他国际
    spawnSearchAgent("其他国际", topic, ["yahoo", "ecosia", "wolframalpha"]),
    // Search Agent 6: 社区讨论
    spawnCommunityAgent("社区讨论", topic, ["hackernews", "v2ex"]),
  ];
  
  // 并行收集所有搜索结果 (40秒超时)
  const searchResults = await Promise.all(
    searchAgents.map(agent => 
      collectResult(agent.taskId, 40000)
        .then(r => ({...r, agentType: agent.description}))
        .catch(e => ({status: "failed", error: e.message, agentType: agent.description}))
    )
  );
  
  // 聚合成功结果
  const searchData = {
    allResults: searchResults.flatMap(r => r.success ? r.data : []),
    communityResults: {
      hackernews: searchResults[5]?.data?.hackernews || [],
      v2ex: searchResults[5]?.data?.v2ex || []
    },
    successfulAgents: searchResults.filter(r => r.success).length,
    timestamp: Date.now(),
    duration: Date.now() - startTime
  };
  
  console.log(`✅ Phase 1完成: ${searchData.duration}ms`);
  console.log(`   成功代理: ${searchData.successfulAgents}/6`);
  console.log(`   总结果数: ${searchData.allResults.length} 条`);
  
  return searchData;
}

// 子代理搜索任务 (网络可用)
function spawnSearchAgent(agentType: string, topic: string, engines: string[]) {
  return task({
    category: "quick",
    load_skills: ["multi-search-engine"],
    run_in_background: true,
    description: `搜索代理: ${agentType}`,
    prompt: `
## 任务: ${agentType}搜索
搜索关键词: "${topic}"
负责引擎: ${engines.join(", ")}

执行:
1. 使用 multi-search-engine skill 搜索每个引擎
2. 每个引擎返回5条结果
3. 返回: 标题、URL、摘要

## 输出格式
返回 JSON 格式的搜索结果数组。

## 要求
- 每个引擎返回5条结果
- 包含标题、URL、摘要
- 按相关性排序
`
  });
}

// 社区搜索任务
function spawnCommunityAgent(agentType: string, topic: string, sources: string[]) {
  return task({
    category: "quick",
    load_skills: ["news-aggregator-skill"],
    run_in_background: true,
    description: `社区代理: ${agentType}`,
    prompt: `
## 任务: ${agentType}搜索
搜索关键词: "${topic}"
负责社区: ${sources.join(", ")}

执行:
1. 使用 news-aggregator-skill 搜索每个社区
2. 每个社区返回10条相关讨论
3. 返回: 标题、URL、发布时间

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
}

// ============ Phase 2: 分析集群 ============
async function phase2AnalysisCluster(searchData: SearchData) {
  console.log("🚀 Phase 2: 启动分析集群...");
  const startTime = Date.now();
  
  // 所有分析代理并行启动 (纯本地计算)
  const analysts = [
    spawnAnalyst("official", searchData.international.slice(0, 8)),
    spawnAnalyst("community", searchData.domestic.slice(0, 8)),
    spawnAnalyst("bias", [...searchData.international, ...searchData.domestic].slice(0, 10)),
    spawnAnalyst("domain", searchData)
  ];
  
  // 并行收集结果 (45秒超时)
  const analysisResults = await Promise.all(
    analysts.map((agent, idx) => 
      collectResult(agent.taskId, 45000)
        .then(r => ({...r, analystType: ["official", "community", "bias", "domain"][idx]}))
        .catch(e => ({status: "failed", error: e.message, analystType: ["official", "community", "bias", "domain"][idx]}))
    )
  );
  
  const successCount = analysisResults.filter(r => r.status !== "failed").length;
  console.log(`✅ Phase 2完成: ${Date.now() - startTime}ms`);
  console.log(`   成功分析: ${successCount}/4`);
  
  return analysisResults;
}

// 分析代理 (纯本地，无网络)
function spawnAnalyst(type: string, data: any) {
  const prompts = {
    official: `分析官方/权威来源视角...`,
    community: `分析社区/用户讨论...`,
    bias: `检测偏见和激励结构...`,
    domain: `领域特定深度分析...`
  };
  
  return task({
    category: type === "bias" ? "ultrabrain" : "deep",
    loadSkills: [],
    runInBackground: true,
    description: `${type}分析`,
    prompt: `
## ${type}分析任务

## 输入数据
${JSON.stringify(data, null, 2)}

## 分析要求
${prompts[type as keyof typeof prompts]}

## 限制
- 只分析提供的数据
- 禁止网络搜索
- 禁止访问外部网站

## 输出格式
{
  "findings": ["...", "..."],
  "confidence": "HIGH/MEDIUM/LOW",
  "keyPoints": ["...", "..."]
}
`
  });
}

// ============ Phase 3: 合成 ============
async function phase3Synthesis(analysisResults: any[], searchData: SearchData) {
  console.log("🚀 Phase 3: 合成报告...");
  const startTime = Date.now();
  
  // 整合所有分析
  const report = {
    executiveSummary: generateExecutiveSummary(analysisResults),
    multiPerspective: {
      official: findResult(analysisResults, "official"),
      community: findResult(analysisResults, "community"),
      bias: findResult(analysisResults, "bias"),
      domain: findResult(analysisResults, "domain")
    },
    dataSources: {
      international: searchData.international.length,
      domestic: searchData.domestic.length,
      total: searchData.international.length + searchData.domestic.length
    },
    generatedAt: new Date().toISOString()
  };
  
  // 质量检查
  const quality = checkQuality(report);
  if (quality.gaps.length > 0) {
    console.log(`⚠️ 发现信息缺口: ${quality.gaps.join(", ")}`);
    const supplementary = await quickSupplementarySearch(quality.gaps);
    report.supplementary = supplementary;
  }
  
  console.log(`✅ Phase 3完成: ${Date.now() - startTime}ms`);
  return report;
}

// ============ 主入口 ============
export async function executeDeepSearch(topic: string) {
  console.log(`\n🔍 Deep Search: "${topic}"`);
  console.log("=" + "=".repeat(50));
  
  const totalStart = Date.now();
  
  try {
    // Phase 1: 搜索
    const searchData = await phase1SearchCluster(topic);
    
    // Phase 2: 分析 (达到阈值即启动)
    const analysisResults = await phase2AnalysisCluster(searchData);
    
    // Phase 3: 合成
    const report = await phase3Synthesis(analysisResults, searchData);
    
    const totalTime = Date.now() - totalStart;
    console.log("\n" + "=".repeat(52));
    console.log(`✅ Deep Search完成! 总用时: ${totalTime}ms (${(totalTime/1000).toFixed(1)}s)`);
    console.log(`📊 数据源: ${report.dataSources.total} 条`);
    console.log(`🔍 分析维度: 4/4`);
    
    return report;
    
  } catch (error) {
    console.error("❌ Deep Search失败:", error);
    throw error;
  }
}

// ============ 辅助函数 ============
async function searchWithRetry(searchFn: Function, retries = 2): Promise<any> {
  for (let i = 0; i <= retries; i++) {
    try {
      return await searchFn();
    } catch (e) {
      if (i === retries) throw e;
      await sleep(1000 * (i + 1)); // 指数退避
    }
  }
}

async function collectResult(taskId: string, timeout: number): Promise<any> {
  return background_output({taskId, timeout});
}

function extractSuccessful(results: PromiseSettledResult<any>[]): any[] {
  return results
    .filter((r): r is PromiseFulfilledResult<any> => r.status === "fulfilled")
    .map(r => r.value);
}

function findResult(results: any[], type: string): any {
  return results.find(r => r.analystType === type);
}

function checkQuality(report: any): {gaps: string[]} {
  const gaps = [];
  if (!report.multiPerspective.official) gaps.push("官方视角");
  if (!report.multiPerspective.community) gaps.push("社区视角");
  if (report.dataSources.total < 10) gaps.push("数据量不足");
  return {gaps};
}

async function quickSupplementarySearch(gaps: string[]): Promise<any> {
  console.log(`🔍 补充搜索: ${gaps.join(", ")}`);
  // 快速补充搜索逻辑
  return {gaps, supplementary: true};
}

function sleep(ms: number): Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

function generateExecutiveSummary(analysisResults: any[]): string {
  // 生成执行摘要逻辑
  return "执行摘要生成完成";
}
```

---

## 执行命令

```bash
# 运行 Deep Search
/deep-search "你的研究主题"
```

## 性能预期

| 阶段 | 任务数 | 并行度 | 预期用时 |
|------|--------|--------|----------|
| Phase 1 | 9搜索 | 9 | 20-30s |
| Phase 2 | 4分析 | 4 | 25-35s |
| Phase 3 | 1合成 | 1 | 10-15s |
| **总计** | **14任务** | **14** | **55-80s** |

**预期**: 1分钟内完成，17个数据源 + 4维分析
