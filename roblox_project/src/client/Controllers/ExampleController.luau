local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ExampleController = Knit.CreateController {
    Name = "ExampleController",
}

function ExampleController:KnitStart()
    print("ExampleController [Start] execution phase.")
end

function ExampleController:KnitInit()
    print("ExampleController [Init] execution phase.")
end

return ExampleController
