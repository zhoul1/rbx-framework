# 目标描述

建立基于代码优先的工程标准模式（Full Mode）Roblox 开发工作流。以 Rojo、Wally、Aftman 为核心构建确定性的本地工具链。由于需要高稳健、适合团队并行协作的特性，底层依赖选取围绕“单例与事件总线管理”所衍生的 Knit 框架，屏蔽 Roblox 原生弱隔离性质的网络调用样板代码，提升生命周期可控性。

## Proposed Changes

结构将布设于 `d:\github\skill\roblox_project`：

### 1. 核心映射拓扑 (`default.project.json`)
定义编译源到 DataModel 的映射准则：
- `ServerScriptService/Server` -> `src/server` (后端微服务运行域)
- `ReplicatedStorage/Shared` -> `src/shared` (常量、类型定义及端对端模型存放点)
- `StarterPlayer/StarterPlayerScripts/Client` -> `src/client` (客户端生命周期切入点)
- `ReplicatedStorage/Packages` -> `Packages` (第三方依赖闭环容器)

### 2. 工具链配置 (`aftman.toml`)
强制固定环境二进制文件版本：
- `rojo-rbx/rojo@7.4.4`
- `UpliftGames/wally@0.3.2`
- `Kampfkarren/selene@0.27.1`
- `JohnnyMorganz/StyLua@0.20.0`
- `lune-org/lune@0.8.9`

### 3. 应用框架与拓展依赖 (`wally.toml`)
- `sleitnick/knit@1.6.0`: 单例与事件总线核心底层
- `evaera/promise@4.0.0`: 异步流式运算控制
- `sleitnick/signal@2.0.0`: 低耦合内存级事件分派
- `sleitnick/trove@1.1.0`: 生命周期级联垃圾回收器（防御内存泄漏）
- `madstudioroblox/profileservice@1.2.0`: 会话级分布式会话强制内存锁管理器

### 4. 源码控制参数
配置 Linter (`selene.toml`) 及静态格式化 (`stylua.toml`)，确保不出现未定义变量溢出与缩进差异。

### 5. 源码入口接驳口
- [NEW] `src/server/init.server.luau`: Knit 服务端启动载体。
- [NEW] `src/client/init.client.luau`: Knit 客户端启动载体并进行远端同步。
- [NEW] `src/shared/Constants.luau`: 类型安全的只读定义。

## Verification Plan

### Manual Verification
1. 控制台输入 `aftman install` 和 `wally install`，检查网络层面是否成功将对应模块拉入 `Packages` 子目录及 `.aftman` 以构建二进制文件。
2. 运行 `rojo serve` 返回进程挂起状态且不在报错退出。
3. 如果系统引导无误，即确认项目处于稳态基线。
