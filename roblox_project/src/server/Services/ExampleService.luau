local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local ExampleService = Knit.CreateService {
    Name = "ExampleService",
    Client = {},
}

function ExampleService:KnitStart()
    print("ExampleService [Start] execution phase.")
end

function ExampleService:KnitInit()
    print("ExampleService [Init] execution phase.")
end

return ExampleService
