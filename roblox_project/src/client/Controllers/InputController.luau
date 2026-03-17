local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local InputController = Knit.CreateController({ Name = "InputController" })

local KEY_TO_DIR = {
	[Enum.KeyCode.W] = "up",
	[Enum.KeyCode.S] = "down",
	[Enum.KeyCode.A] = "left",
	[Enum.KeyCode.D] = "right",
	[Enum.KeyCode.Up] = "up",
	[Enum.KeyCode.Down] = "down",
	[Enum.KeyCode.Left] = "left",
	[Enum.KeyCode.Right] = "right",
}

function InputController:KnitInit()
	print("[InputController] Initialized")
end

function InputController:KnitStart()
	local MovementController = Knit.GetController("MovementController")

	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then return end
		local dir = KEY_TO_DIR[input.KeyCode]
		if not dir then return end

		local result = MovementController:Move(dir)
		
		if result and result.won then
			local HUDController = Knit.GetController("HUDController")
			if HUDController then
				HUDController:ShowWin()
			end
		end
	end)

	print("[InputController] Started (Redirected to MovementController)")
end

return InputController
