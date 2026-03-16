local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local Knit = require(ReplicatedStorage.Packages.Knit)

-- 载入服务端微服务容器
Knit.AddServices(script:WaitForChild("Services"))

-- 启动单例框架
Knit.Start():andThen(function()
    print("[Knit] Server instance initialized and ready.")
end):catch(warn)
