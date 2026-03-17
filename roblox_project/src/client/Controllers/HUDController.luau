local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

local HUDController = Knit.CreateController({ Name = "HUDController" })

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function HUDController:KnitInit()
	self._gui = Instance.new("ScreenGui")
	self._gui.Name = "SokobanHUD"
	self._gui.ResetOnSpawn = false
	self._gui.Parent = playerGui

	-- 金币显示框
	local coinFrame = Instance.new("Frame")
	coinFrame.Size = UDim2.new(0, 200, 0, 60)
	coinFrame.Position = UDim2.new(0, 20, 0, 20)
	coinFrame.BackgroundTransparency = 0.4
	coinFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	coinFrame.BorderSizePixel = 0
	coinFrame.Parent = self._gui
	Instance.new("UICorner", coinFrame).CornerRadius = UDim.new(0, 10)

	self._coinLabel = Instance.new("TextLabel")
	self._coinLabel.Size = UDim2.new(1, 0, 1, 0)
	self._coinLabel.BackgroundTransparency = 1
	self._coinLabel.Text = "🪙 Coins: 0"
	self._coinLabel.TextColor3 = Color3.fromRGB(255, 220, 50)
	self._coinLabel.TextScaled = true
	self._coinLabel.Font = Enum.Font.GothamBold
	self._coinLabel.Parent = coinFrame

	-- 操作提示
	local hint = Instance.new("TextLabel")
	hint.Size = UDim2.new(0, 300, 0, 40)
	hint.Position = UDim2.new(0.5, -150, 1, -60)
	hint.BackgroundTransparency = 0.4
	hint.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	hint.BorderSizePixel = 0
	hint.Text = "WASD / ↑↓←→ 推箱子到黄色目标格"
	hint.TextColor3 = Color3.fromRGB(200, 200, 200)
	hint.TextScaled = true
	hint.Font = Enum.Font.Gotham
	hint.Parent = self._gui
	Instance.new("UICorner", hint).CornerRadius = UDim.new(0, 8)

	-- 胜利界面（默认隐藏）
	self._winFrame = Instance.new("Frame")
	self._winFrame.Size = UDim2.new(0, 400, 0, 200)
	self._winFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
	self._winFrame.BackgroundColor3 = Color3.fromRGB(20, 120, 20)
	self._winFrame.BorderSizePixel = 0
	self._winFrame.Visible = false
	self._winFrame.Parent = self._gui
	Instance.new("UICorner", self._winFrame).CornerRadius = UDim.new(0, 16)

	local winLabel = Instance.new("TextLabel")
	winLabel.Size = UDim2.new(1, 0, 1, 0)
	winLabel.BackgroundTransparency = 1
	winLabel.Text = "🎉 YOU WIN!"
	winLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
	winLabel.TextScaled = true
	winLabel.Font = Enum.Font.GothamBold
	winLabel.Parent = self._winFrame

	print("[HUDController] Initialized")
end

function HUDController:KnitStart()
	local CoinService = Knit.GetService("CoinService")

	CoinService.CoinCollected:Connect(function(count)
		self._coinLabel.Text = "🪙 Coins: " .. count
	end)

	print("[HUDController] Started")
end

function HUDController:ShowWin()
	self._winFrame.Visible = true
end

return HUDController
