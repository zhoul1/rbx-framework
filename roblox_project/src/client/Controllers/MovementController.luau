local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Knit = require(ReplicatedStorage.Packages.Knit)

local MovementController = Knit.CreateController({ Name = "MovementController" })

-- 物理模式下，不再接管控制，仅作为状态监听器
function MovementController:KnitInit()
	print("[MovementController] Physical Mode Initialized.")
end

function MovementController:KnitStart()
	self.LevelService = Knit.GetService("LevelService")
	
	-- 监听胜利信号
	self.LevelService.GameWon:Connect(function()
		print("====================================")
		print("🏆 VICTORY! YOU SOLVED THE PUZZLE!")
		print("====================================")
	end)
end

-- 物理模式无需主动 Move 方法，角色由原生 ControlModule 控制
function MovementController:Move(direction)
	-- 此方法在物理模式下可能被 InputController 调用一次，此处静默处理
	return { success = true }
end

return MovementController
