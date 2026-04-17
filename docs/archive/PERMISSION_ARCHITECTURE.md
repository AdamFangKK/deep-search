# Deep Search 权限等级架构

## 代理权限等级 (基于实际测试结果)

```
┌─────────────────────────────────────────────────────────────────┐
│ TIER 1: 主代理 (Primary Agent)                                  │
│ Agent: Sisyphus (当前会话)                                      │
├─────────────────────────────────────────────────────────────────┤
│ ✅ 完整工具访问权限                                              │
│ ✅ 网络请求 (curl/webfetch/websearch)                          │
│ ✅ 长时间运行 (无硬性限制)                                        │
│ ✅ 加载所有 skills                                              │
│ ✅ 访问文件系统                                                  │
│ ✅ 并行执行多个任务（通过 task() 派生子代理）                    │
└─────────────────────────────────────────────────────────────────┘
                              ↓ task() 派生
┌─────────────────────────────────────────────────────────────────┐
│ TIER 2: 子代理 (Sub-agent)                                      │
│ Agent: task() 创建的所有代理                                     │
│ Categories: quick/deep/ultrabrain/artistry/...                 │
├─────────────────────────────────────────────────────────────────┤
│ ✅ 本地命令 (echo/date/文件操作)                                │
│ ✅ 本地文件读取                                                  │
│ ✅ 网络请求 (curl/webfetch/websearch) - 需代理配置              │
│ ✅ 加载 skills 并执行搜索                                       │
│ ✅ 短时间运行 (30分钟硬性限制)                                   │
│ ✅ 通过 skill_mcp 调用 MCP 工具                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 测试结果验证 (更新于 2026-04-01)

| 测试 | 主代理 | 子代理 | 结论 |
|------|--------|--------|------|
| `echo "hello"` | ✅ 秒级 | ✅ 秒级 | 本地命令正常 |
| `curl google.com` | ✅ 成功 | ✅ 成功 | 代理配置后子代理网络正常 |
| `skill("multi-search-engine")` | ✅ 成功 | ✅ 成功 | 子代理可以加载并执行搜索 |
| 长时间任务 | ✅ 无限制 | ❌ 30m硬限制 | 子代理有生命周期 |

**关键发现**: 
- 修复代理配置后，子代理网络访问正常
- `ENABLE_TOOL_SEARCH=true` 启用工具搜索功能
- 子代理现在可以执行搜索任务，而不仅仅是本地分析

---

## 权限等级与集群架构映射

### 任务类型 vs 可执行代理

| 任务类型 | 需要权限 | 可执行代理 | 策略 |
|---------|---------|-----------|------|
| **网络搜索** (Google/Baidu/webfetch) | 网络访问 | Tier 1 only | 主代理执行 |
| **本地分析** (数据分析/偏见检测) | 本地计算 | Tier 1 & 2 | 子代理并行 |
| **代码搜索** (ast-grep/文件读取) | 文件系统 | Tier 1 & 2 | 子代理并行 |
| **社区抓取** (HN/V2EX API) | 网络访问 | Tier 1 only | 主代理执行 |
| **报告合成** (文本整合) | 本地计算 | Tier 1 & 2 | 主代理执行 |

### 集群架构适配

```
原始设计（理想情况）:
Layer 1: [17引擎+2社区] 并行搜索
Layer 2: [4分析代理] 并行分析
Layer 3: [1合成代理] 报告生成

适配权限限制后:
┌──────────────────────────────────────────────────────────────┐
│ Layer 1: 搜索集群 (必须由 Tier 1 执行)                        │
│                                                              │
│  主代理并行调用:                                              │
│  ├─ searchEngines = Promise.all([                            │
│  │   skill("multi-search-engine", engine1),                  │
│  │   skill("multi-search-engine", engine2),                  │
│  │   ... 17 engines                                          │
│  │ ])                                                        │
│  └─ communities = Promise.all([                              │
│      skill("news-aggregator", "hackernews"),                 │
│      skill("news-aggregator", "v2ex")                        │
│    ])                                                        │
│                                                              │
│  ⚠️ 虽然主代理是"单线程"，但工具调用可以并发                  │
└──────────────────────────────────────────────────────────────┘
                              ↓ 数据收集完成
┌──────────────────────────────────────────────────────────────┐
│ Layer 2: 分析集群 (由 Tier 2 子代理并行执行)                   │
│                                                              │
│  task({category: "quick", ...}) // analyst-1                 │
│  task({category: "quick", ...}) // analyst-2                 │
│  task({category: "ultrabrain", ...}) // analyst-3            │
│  task({category: "deep", ...}) // analyst-4                  │
│                                                              │
│  ✅ 子代理可以安全地并行分析本地数据                           │
│  ✅ 每个子代理 20-30 秒完成，远低于 30 分钟限制               │
└──────────────────────────────────────────────────────────────┘
                              ↓ 分析结果收集
┌──────────────────────────────────────────────────────────────┐
│ Layer 3: 合成 (由 Tier 1 主代理执行)                          │
│                                                              │
│  主代理整合所有结果，生成报告                                  │
│  ✅ 无需网络，纯本地计算                                       │
└──────────────────────────────────────────────────────────────┘
```

---

## 关键设计决策

### 1. Layer 1 为什么不用子代理？

**尝试过的方案**:
```typescript
// ❌ 失败: 子代理执行搜索
const searchTask = task({
  load_skills: ["multi-search-engine"],
  prompt: "搜索 {{topic}}"
});
// 结果: 30分钟后超时，无结果返回
```

**原因**: 子代理的 `multi-search-engine` 需要调用网络 API，但被沙箱限制。

**解决方案**: 主代理直接调用搜索工具
```typescript
// ✅ 成功: 主代理并行调用多个搜索
const results = await Promise.all([
  skill_mcp({mcp_name: "multi-search-engine", ...}),
  websearch_web_search_exa("{{topic}}"),
  skill_mcp({mcp_name: "news-aggregator-skill", ...})
]);
```

### 2. Layer 2 为什么可以用子代理？

**测试验证**:
```typescript
// ✅ 成功: 子代理分析本地数据
const analysisTask = task({
  category: "quick",
  load_skills: [], // 不加载网络依赖的skill
  prompt: `分析以下数据: ${JSON.stringify(searchResults)}`
});
// 结果: 20秒成功返回
```

**原因**: 子代理可以本地计算，只要不给网络任务。

### 3. 并行度优化

**主代理的"伪并行"**:
- 主代理是单线程，但**工具调用可以并发**
- `Promise.all([tool1, tool2, tool3])` 可以同时发起多个网络请求
- 限制：主代理一次只能执行一个逻辑流

**子代理的真正并行**:
- 每个子代理是独立的上下文
- 4 个子代理 = 4 个真正的并行执行单元
- 限制：每个子代理 30 分钟生命周期

**最优策略**:
```typescript
// 主代理：并发网络请求（伪并行，但IO可以并发）
const searchResults = await Promise.all([
  ...17个引擎搜索,  // 同时发起
  ...2个社区搜索    // 同时发起
]);

// 子代理：真正并行（4个独立执行单元）
const analyses = await Promise.all([
  task({...}), // 独立进程1
  task({...}), // 独立进程2
  task({...}), // 独立进程3
  task({...})  // 独立进程4
]);
```

---

## 实际执行策略

### 阶段 1: 主代理并发搜索 (30-40秒)
```typescript
// 主代理同时发起所有搜索
const startTime = Date.now();

const [webResults, communityResults] = await Promise.all([
  // 17 引擎分组并发
  Promise.all([
    searchGroupA(), // Google, Bing, DDG
    searchGroupB(), // Baidu, Sogou, 360
    searchGroupC(), // 隐私引擎
    searchGroupD(), // 其他
  ]).then(results => results.flat()),
  
  // 2 社区并发
  Promise.all([
    fetchHackerNews("{{topic}}"),
    fetchV2EX("{{topic}}")
  ])
]);

console.log(`搜索完成，用时: ${Date.now() - startTime}ms`);
```

### 阶段 2: 子代理并行分析 (20-30秒)
```typescript
// 同时启动 4 个子代理
const analysisTasks = [
  task({category: "quick", prompt: `分析官方来源: ${webResults.official}`}),
  task({category: "quick", prompt: `分析社区: ${communityResults}`}),
  task({category: "ultrabrain", prompt: `偏见检测: ${webResults.all}`}),
  task({category: "deep", prompt: `领域分析: ${webResults.all}`})
];

// 并行等待所有结果
const analyses = await Promise.all(
  analysisTasks.map(t => 
    background_output({task_id: t.task_id, timeout: 45000})
  )
);
```

### 阶段 3: 主代理合成 (10-15秒)
```typescript
// 主代理整合（纯本地计算）
const report = synthesizeReport(analyses);
```

---

## 权限边界检查清单

在实现集群时，检查每个任务：

```markdown
- [ ] 这个任务需要网络访问吗？
  - Yes → 必须由主代理执行
  - No → 可以由子代理执行

- [ ] 这个任务需要长时间运行吗？（>10分钟）
  - Yes → 必须由主代理执行
  - No → 可以由子代理执行

- [ ] 这个任务需要并行执行吗？
  - Yes → 使用子代理（真正并行）
  - No → 主代理串行执行

- [ ] 这个任务需要大量本地计算吗？
  - Yes → 使用子代理（分担负载）
  - No → 主代理直接执行
```

---

## 总结

| 层级 | 代理 | 权限 | 用途 | 限制 |
|------|------|------|------|------|
| Tier 1 | 主代理 | 完整 | 网络搜索、工具调用、最终合成 | 单线程（但IO可并发） |
| Tier 2 | 子代理 | 受限 | 本地分析、计算、文本处理 | 30分钟生命周期、无网络 |

**最优架构**:
- **主代理**负责：所有网络操作 + 最终整合
- **子代理集群**负责：并行的本地分析任务

这样既利用了主代理的完整权限，又利用了子代理的真正并行能力！
