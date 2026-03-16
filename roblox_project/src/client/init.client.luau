local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterPlayer = game:GetService("StarterPlayer")
local StarterPlayerScripts = StarterPlayer:WaitForChild("StarterPlayerScripts")

local Knit = require(ReplicatedStorage.Packages.Knit)

-- 载入客户端生命周期控制器
Knit.AddControllers(script:WaitForChild("Controllers"))

-- 启动单例框架并同步远端服务引脚
Knit.Start():andThen(function()
    print("[Knit] Client controllers initialized and synced.")
end):catch(warn)
