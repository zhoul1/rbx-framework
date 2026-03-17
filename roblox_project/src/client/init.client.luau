local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

Knit.AddControllers(script:WaitForChild("Controllers"))

Knit.Start():andThen(function()
	print("[Knit] Client started - Sokoban Game ready!")
end):catch(warn)
