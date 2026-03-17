local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddServices(script:WaitForChild("Services"))

Knit.Start():andThen(function()
	print("[Knit] Server started - Sokoban Game ready!")
	print("[Version Check] Build Time: 2026-03-17 08:52:00 - YELLOW TARGETS")
end):catch(warn)
