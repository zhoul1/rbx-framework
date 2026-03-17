local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Knit = require(ReplicatedStorage.Packages.Knit)

local LevelService = Knit.CreateService({
	Name = "LevelService",
	Client = {
		GameWon = Knit.CreateSignal(),
	},
})

-- 服务端私有状态
LevelService._boxes = {}    -- { part = BasePart, onTarget = bool }
LevelService._targets = {}  -- { pos = Vector3 }
LevelService._winNotified = false

function LevelService:KnitInit()
	local levelFolder = game.Workspace:WaitForChild("Level")
	
	-- 1. 初始化箱子：取消锚定，开启物理碰撞
	local boxesFolder = levelFolder:FindFirstChild("Boxes")
	if boxesFolder then
		for _, box in ipairs(boxesFolder:GetChildren()) do
			if box:IsA("BasePart") then
				box.Anchored = false
				box.CanCollide = true
				-- 大幅降低密度和摩擦力，让推感变轻快
				local customPhysicalProperties = PhysicalProperties.new(
					0.1,   -- 密度 (Density) - 越小越轻
					0.05,   -- 摩擦力 (Friction) - 越小越滑
					0.1,   -- 弹性 (Elasticity) - 防止乱跳
					1,     -- 摩擦权重
					1      -- 弹性权重
				)
				box.CustomPhysicalProperties = customPhysicalProperties
				
				table.insert(self._boxes, { part = box, onTarget = false })
			end
		end
	end

	-- 2. 扫描目标点位置
	local targetsFolder = levelFolder:FindFirstChild("Targets")
	if targetsFolder then
		for _, target in ipairs(targetsFolder:GetChildren()) do
			if target:IsA("BasePart") then
				target.Anchored = true
				target.CanCollide = false -- 目标点不阻拦物理运动
				table.insert(self._targets, { pos = target.Position })
			end
		end
	end

	print("[LevelService] Physical Mode Initialized. Boxes:", #self._boxes)
end

function LevelService:KnitStart()
	-- 心跳检测箱子状态（物理驱动下箱子随时可能移动）
	RunService.Heartbeat:Connect(function()
		self:_updateGameStatus()
	end)
end

function LevelService:_updateGameStatus()
	local allOnTarget = true
	local anyBoxFound = #self._boxes > 0
	
	for _, boxData in ipairs(self._boxes) do
		local boxPos = boxData.part.Position
		local onAnyTarget = false
		
		for _, target in ipairs(self._targets) do
			-- 如果箱子中心距离目标点中心水平距离小于 4（TILE_SIZE 是 6），判定为推入
			local dist = (Vector2.new(boxPos.X, boxPos.Z) - Vector2.new(target.pos.X, target.pos.Z)).Magnitude
			if dist < 4 then
				onAnyTarget = true
				break
			end
		end
		
		-- 视觉反馈
		if boxData.onTarget ~= onAnyTarget then
			boxData.onTarget = onAnyTarget
			boxData.part.BrickColor = onAnyTarget and BrickColor.new("Bright green") or BrickColor.new("Bright orange")
		end
		
		if not onAnyTarget then
			allOnTarget = false
		end
	end

	-- 胜利判定
	if anyBoxFound and allOnTarget and not self._winNotified then
		self._winNotified = true
		print("[LevelService] VICTORY! All boxes on targets.")
		self.Client.GameWon:FireAll()
	elseif not allOnTarget then
		self._winNotified = false
	end
end

return LevelService
