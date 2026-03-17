local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

local CoinService = Knit.CreateService({
	Name = "CoinService",
	Client = {
		CoinCollected = Knit.CreateSignal(),
	},
})

function CoinService:KnitInit()
	self._playerCoins = {}
	print("[CoinService] Initialized")
end

function CoinService:KnitStart()
	Players.PlayerAdded:Connect(function(player)
		self._playerCoins[player.UserId] = 0
	end)

	Players.PlayerRemoving:Connect(function(player)
		self._playerCoins[player.UserId] = nil
	end)

	local coinsFolder = game.Workspace.Level.Coins
	for _, coin in ipairs(coinsFolder:GetChildren()) do
		coin.Touched:Connect(function(hit)
			local char = hit.Parent
			local player = Players:GetPlayerFromCharacter(char)
			if not player then
				return
			end
			if coin:GetAttribute("Collected") then
				return
			end

			coin:SetAttribute("Collected", true)
			coin.Transparency = 1
			coin.CanCollide = false

			self._playerCoins[player.UserId] = (self._playerCoins[player.UserId] or 0) + 1
			self.Client.CoinCollected:Fire(player, self._playerCoins[player.UserId])
			print("[CoinService]", player.Name, "collected coin! Total:", self._playerCoins[player.UserId])
		end)
	end

	print("[CoinService] Started, monitoring", #coinsFolder:GetChildren(), "coins")
end

function CoinService.Client:GetCoins(player)
	return self._playerCoins[player.UserId] or 0
end

return CoinService
