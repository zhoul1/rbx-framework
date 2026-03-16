# Roblox 标准化项目交付验证与使用指南

基于 Knit、Wally（包管理）以及 Rojo（节点映射）的底层基础设施架构已经部署完毕并成功推演运行。当前开发模式已切换为 **完全解耦的文件系统协作模式 (Full Mode)**，无需强依赖 Roblox Studio 的本地脚本编辑器即可构建高稳健类库架构。

## 阶段核验与基础状态

### 1. 挂钩成功节点
- **Rojo 服务器已在后台挂钩**，当前它正监听 `localhost` 端口，它会将位于本地 `d:\github\skill\roblox_project` 的逻辑文件夹投射进游戏的 DataModel 中。 
- **Sourcemap (类型映射地图)** 已生成。支持使用 VS Code 自带的 `Luau LSP` 对 Wally 控制的第三方包进行静态自动补全。
- **环境安全锁**：`ProfileService` 作为服务端级别单例，已下沉至依赖区。

### 2. 双端入口与依赖链
代码库预置了标准的解耦拓扑逻辑框架入口：
- 🟢 **服务端** (对应 `ServerScriptService/Server`) 挂载于：[src/server/init.server.luau](file:///d:/github/skill/roblox_project/src/server/init.server.luau)
- 🔵 **客户端** (对应 `StarterPlayerScripts/Client`) 挂载于：[src/client/init.client.luau](file:///d:/github/skill/roblox_project/src/client/init.client.luau)
- 🟡 **双端通信与数据只读层** 挂载于：`src/shared`

## 验证流程与后续行动指南

### 1. 建立双向联结
由于 Rojo Server 已在后端唤起（Command_ID: `3fa30635`）。请打开你当前的 Roblox Studio 原型项目（如有需要，将空白模板载入）并按照以下机制对接联结：
1. 确保在 Studio 中安装了官方的 **Rojo 插件**。
2. 打开插件面板点击 **Rojo** -> 点击界面内 `Connect` (通常无需配置，默认端口为自动匹配)。
3. 你将看到控制台直接出现 `[Knit] Server instance initialized and ready.` (位于 Studio `Output` 窗口)。

此现象说明本地计算机资源管理器级别的 [init.server.luau](file:///d:/github/skill/roblox_project/src/server/init.server.luau) 文件已经被单线程接管投射进入 `ServerScriptService` 并由 `Knit` 底层框架进行了预引导热机。

### 2. 具体业务派送点
目前工程基床已经极其稳健，你可以直接宣告任意的“开发系统诉求”（这会被对应引流到对应的工作流中）。例如：
* "部署基础的战斗防作弊机制和 Hitbox 控制"
* "编写一个基础的数据模型用作保存玩家的金币与生命值"
* "帮我构建一个 Simulator（模拟器游戏）核心的增量循环控制机制"
* "增加商城 UI 面板并连接服务端"
