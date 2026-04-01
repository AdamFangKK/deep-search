# Deep Search 集群架构 v6.0

## 核心理念

**阶段 = 数据依赖的流水线**  
**集群 = 每个阶段的全员并行执行**  
**关键改进 = 子代理现在可以执行网络搜索**

```
数据流（阶段）:
Layer 1 (Foundation) → Layer 2 (Analysis) → Layer 3 (Synthesis)
     ↓                      ↓                      ↓
执行（集群）:            执行（集群）:           执行（集群）:
[6个搜索代理并行]         [4个分析代理并行]         [主代理合成]
[子代理执行搜索]          [子代理执行分析]          [最终输出]
```

---

## 架构变更 (v6.0)

**关键改进**: 子代理现在可以执行网络搜索任务！

| 版本 | 搜索执行 | 分析执行 | 并行度 |
|------|----------|----------|--------|
| v5.0 | 主代理串行 | 子代理并行 | 低 |
| **v6.0** | **子代理并行** | **子代理并行** | **高** |

**优势**:
- 搜索和分析都由子代理并行执行
- 主代理只负责协调和合成
- 整体执行时间缩短 30-50%

---

## 集群调度器 (Cluster Orchestrator)

### 角色
- **主调度器**: 当前 Sisyphus 会话
- **工作节点**: task() 派生的子代理
- **协调协议**: 共享内存 + 状态广播

### 执行模式: 全子代理并行 (Full Sub-agent Parallel)

```
时间 →

Wave 1: 6个搜索代理并行启动
├─ [Search-Agent-1: Google系] ════════════════╗
├─ [Search-Agent-2: 隐私引擎] ════════════════╬── 数据汇入共享池
├─ [Search-Agent-3: 国内主流] ════════════════╝     ↓
├─ [Search-Agent-4: 国内垂直] ════════════════      ↓ 触发条件：60%数据到达
├─ [Search-Agent-5: 其他国际] ═══════════════╗      ↓
└─ [Search-Agent-6: 社区讨论] ═══════════════╝ 触发 Wave 2

Wave 2: 4个分析代理并行启动（无需等待Wave 1 100%）
├─ [Analyst-1: Global Observer] ═════════════╗
├─ [Analyst-2: Underground OSINT] ═══════════╬── 并行分析
├─ [Analyst-3: Oracle] ══════════════════════╝     ↓
└─ [Analyst-4: Vertical Enhancer] ═══════════ 触发条件：分析饱和
                                      ↓
Wave 3: 主代理合成                  最终输出
└─ [Synthesizer] ══════════════ 报告
```

**关键创新**: 
- Wave 1 由6个子代理并行执行搜索
- Wave 2 不需要等待 Wave 1 完全结束，达到阈值（如60%数据）即可启动
- 实现**真正的全并行**（10个子代理同时工作）

---

## 集群通信协议

### 共享状态存储
```typescript
// 全局共享状态（所有代理可读写）
interface ClusterState {
  layer1: {
    status: 'running' | 'saturated' | 'completed',
    data: SearchResult[],
    progress: number,  // 0-100%
    engines: { [engineName: string]: 'pending' | 'running' | 'done' | 'failed' }
  },
  layer2: {
    status: 'waiting' | 'running' | 'completed',
    analyses: AnalysisResult[],
    crossValidations: ValidationResult[]
  },
  layer3: {
    status: 'waiting' | 'running' | 'completed',
    report: Report | null
  }
}
```

### 代理间通信
```typescript
// 代理可以广播消息给其他代理
interface AgentMessage {
  from: string,      // 代理ID
  to: 'broadcast' | string[],  // 广播或指定接收者
  type: 'data' | 'request' | 'validation' | 'alert',
  payload: any
}

// 示例：一个分析代理发现数据缺口，可以广播请求补充
{
  from: 'analyst-1',
  to: 'broadcast',
  type: 'request',
  payload: {
    action: 'need_more_data',
    topic: 'specific_subtopic',
    urgency: 'high'
  }
}
```

---

## Layer 1: 搜索集群 (6 个搜索代理 + 2 个社区)

### 节点列表
| 代理ID | 类型 | 负责引擎 | 输出 |
|--------|------|----------|------|
| Search-Agent-1 | 搜索代理 | Google, Google HK, Bing INT | 结果集A |
| Search-Agent-2 | 搜索代理 | DuckDuckGo, Startpage, Brave, Qwant | 结果集B |
| Search-Agent-3 | 搜索代理 | Baidu, Bing CN, Sogou, 360 | 结果集C |
| Search-Agent-4 | 搜索代理 | WeChat, Toutiao, Jisilu | 结果集D |
| Search-Agent-5 | 搜索代理 | Yahoo, Ecosia, WolframAlpha | 结果集E |
| Search-Agent-6 | 社区代理 | HackerNews, V2EX | 社区数据 |

### 集群行为
1. **6个搜索代理同时启动**（波次1）
2. **每个代理负责3-4个引擎**（子代理并行执行）
3. **增量写入共享池**（每有一个代理完成就写入）
4. **自动去重**（基于URL的分布式去重）
5. **动态饱和度检测**（达到阈值触发波次2）

### 触发波次2的条件
```typescript
// 以下任一条件满足即触发
if (
  completedAgents >= 4 ||             // 4个搜索代理完成
  totalResults >= 50 ||               // 50条结果
  uniqueDomains >= 8 ||               // 8个不同域名
  timeElapsed >= 25                   // 或25秒超时
) {
  triggerWave2();
}
```

---

## Layer 2: 分析集群 (4 + N 节点)

### 核心分析节点（固定4个）
| 节点ID | 角色 | 输入 | 输出 |
|--------|------|------|------|
| analyst-official | 官方分析 | Google/Bing/官方源 | 官方视角分析 |
| analyst-community | 社区分析 | HN/V2EX/社交源 | 社区视角分析 |
| analyst-bias | 偏见检测 | 全数据源 | 偏见与激励分析 |
| analyst-domain | 领域专家 | 全数据源 | 领域深度分析 |

### 动态扩展节点（根据需要启动）
```typescript
// 当某个分析节点发现数据不足时，可以请求启动辅助节点
if (analyst-community.findGaps()) {
  spawnAuxiliaryAgent({
    role: 'gap-filler',
    task: 'search_specific_subtopic',
    parent: 'analyst-community'
  });
}
```

### 交叉验证机制
```typescript
// 分析节点之间可以互相验证
analyst-official.validateWith(analyst-community);
analyst-bias.crossCheck(analyst-domain);

// 如果发现矛盾，启动仲裁节点
if (conflictsDetected) {
  spawnArbitrationAgent(conflicts);
}
```

---

## Layer 3: 合成集群 (1 + N 节点)

### 主合成节点
- **输入**: Layer 2 的所有分析结果
- **任务**: 整合为最终报告
- **输出**: 8-section 报告

### 辅助验证节点（动态启动）
```typescript
// 合成过程中发现缺失，可以回退补充
if (report.hasGaps()) {
  // 启动快速补充搜索
  spawnQuickSearchAgent(gaps);
  
  // 或启动补充分析
  spawnSupplementaryAnalysisAgent(gaps);
}
```

---

## 集群调度算法

### 动态负载均衡
```typescript
// 监控各节点负载，动态调整
function scheduleTask(task, clusterState) {
  // 选择负载最轻的节点
  const availableNodes = clusterState.nodes.filter(n => n.load < 80);
  const selectedNode = availableNodes.sort((a, b) => a.load - b.load)[0];
  
  // 如果所有节点都忙，启动新节点
  if (!selectedNode) {
    return spawnNewNode(task);
  }
  
  return assignToNode(task, selectedNode);
}
```

### 故障转移
```typescript
// 节点故障时自动迁移任务
node.on('failed', (nodeId) => {
  const failedTasks = getNodeTasks(nodeId);
  failedTasks.forEach(task => {
    const newNode = spawnReplacementNode();
    migrateTask(task, newNode);
  });
});
```

---

## 实际执行流程

### 启动命令
```typescript
// 一键启动整个集群
const deepSearchCluster = {
  topic: "{{topic}}",
  intent: "{{intent}}",
  
  // Layer 1: 19个搜索节点
  layer1: {
    nodes: [
      ...getAll17Engines().map(e => ({type: 'engine', engine: e})),
      {type: 'community', source: 'hackernews'},
      {type: 'community', source: 'v2ex'}
    ],
    trigger: {minResults: 50, minEngines: 10, timeout: 30}
  },
  
  // Layer 2: 4个核心分析节点 + 动态扩展
  layer2: {
    coreNodes: ['official', 'community', 'bias', 'domain'],
    dynamicScaling: true,  // 允许动态扩展
    crossValidation: true,  // 启用交叉验证
    trigger: {minAnalyses: 3, saturation: 0.8, timeout: 45}
  },
  
  // Layer 3: 合成节点 + 补充机制
  layer3: {
    synthesizer: 'main',
    allowBacktrack: true,  // 允许回退补充
    timeout: 30
  }
};

// 启动集群
const cluster = await startCluster(deepSearchCluster);

// 实时监控
cluster.on('waveComplete', (wave, results) => {
  console.log(`Wave ${wave} completed with ${results.length} results`);
});

cluster.on('finalReport', (report) => {
  console.log('Final report generated');
});
```

---

## 性能指标

### 理论性能
| 指标 | 传统串行 | 简单并行 | 集群架构 |
|------|---------|---------|---------|
| Layer 1 | 17×5s=85s | 30s | 30s (全并行) |
| Layer 2 | 4×20s=80s | 25s | 25s (流水线重叠) |
| Layer 3 | 20s | 15s | 15s |
| **总计** | **185s** | **70s** | **55s** |
| 加速比 | 1× | 2.6× | 3.4× |

### 集群优势
1. **流水线重叠**: Layer 2 不需要等待 Layer 1 100%
2. **动态扩展**: 发现缺口时自动补充
3. **故障自愈**: 节点失败自动迁移
4. **交叉验证**: 多节点互相验证提高质量

---

## 集群状态监控

```
实时监控面板:

Layer 1 (搜索集群) [████████░░] 80%
├─ Google        [██████████] DONE - 5 results
├─ Baidu         [██████████] DONE - 5 results
├─ DuckDuckGo    [██████░░░░] RUNNING
├─ ... (17 total)
└─ HN/V2EX       [████████░░] 80%

Layer 2 (分析集群) [░░░░░░░░░░] WAITING
├─ official      [░░░░░░░░░░] QUEUED
├─ community     [░░░░░░░░░░] QUEUED
├─ bias          [░░░░░░░░░░] QUEUED
└─ domain        [░░░░░░░░░░] QUEUED

Layer 3 (合成)     [░░░░░░░░░░] WAITING
```

---

## 总结

**阶段** = 数据的逻辑流向（Foundation → Analysis → Synthesis）  
**集群** = 每个阶段的全员并行执行 + 智能协作

**核心优势**:
- ✅ 17引擎 + 2社区 = 19个节点同时搜索
- ✅ 4个分析节点同时运行，交叉验证
- ✅ 流水线重叠，无需等待100%
- ✅ 动态扩展，缺口自动补充
- ✅ 故障自愈，节点失败自动迁移

**目标**: 55秒内完成19数据源的全方位深度搜索！
