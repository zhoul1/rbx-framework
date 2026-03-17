local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

local PerfController = Knit.CreateController({ Name = "PerfController" })

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

function PerfController:KnitInit()
	-- 创建 UI 容器
	self._gui = Instance.new("ScreenGui")
	self._gui.Name = "PerfHUD"
	self._gui.ResetOnSpawn = false
	self._gui.Parent = playerGui

	-- 性能信息面板
	local perfFrame = Instance.new("Frame")
	perfFrame.Size = UDim2.new(0, 160, 0, 30)
	perfFrame.Position = UDim2.new(1, -180, 0, 20) -- 屏幕右上角
	perfFrame.BackgroundTransparency = 0.5
	perfFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	perfFrame.BorderSizePixel = 0
	perfFrame.Parent = self._gui
	Instance.new("UICorner", perfFrame).CornerRadius = UDim.new(0, 6)

	self._perfLabel = Instance.new("TextLabel")
	self._perfLabel.Size = UDim2.new(1, -10, 1, 0)
	self._perfLabel.Position = UDim2.new(0, 5, 0, 0)
	self._perfLabel.BackgroundTransparency = 1
	self._perfLabel.Text = "FPS: -- | Ping: -- ms"
	self._perfLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	self._perfLabel.TextXAlignment = Enum.TextXAlignment.Right
	self._perfLabel.Font = Enum.Font.Code
	self._perfLabel.TextSize = 14
	self._perfLabel.Parent = perfFrame

	print("[PerfController] Initialized")
end

function PerfController:KnitStart()
	local lastUpdate = 0
	local frameCount = 0
	local updateInterval = 1 -- 每秒更新一次

	RunService.RenderStepped:Connect(function(dt)
		frameCount += 1
		lastUpdate += dt

		if lastUpdate >= updateInterval then
			local fps = math.round(frameCount / lastUpdate)
			local ping = math.round(player:GetNetworkPing() * 1000) -- GetNetworkPing returns seconds
			
			self._perfLabel.Text = string.format("FPS: %d | Ping: %d ms", fps, ping)
			
			-- 简单的颜色反馈
			if fps < 30 then
				self._perfLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
			elseif fps < 50 then
				self._perfLabel.TextColor3 = Color3.fromRGB(255, 255, 100)
			else
				self._perfLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
			end

			frameCount = 0
			lastUpdate = 0
		end
	end)

	print("[PerfController] Started monitoring")
end

return PerfController
