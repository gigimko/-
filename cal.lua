local PFS = game:GetService("PathfindingService")
local KVD = workspace.RaisingCanes.Systems["easyPOS | CafePOS"]["Kitchen Visual Displays"]:GetChildren()[4].Display.GUI.Main.Ready.Content
local currentOrderNum = nil
local ordersDone = 0
local Fire_Server
local toby = false
local Players = game:GetService('Players')
local Local_Player = Players.LocalPlayer

for Index, Value in next, getgc(false) do
    if
        typeof(Value) == 'function'
        and debug.info(Value, 'n') == 'fireServer'
    then
        Fire_Server = Value
        break
    end
end


task.spawn(function()
	while wait(3600) do
		
		local servers = {}
    	local req = game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true")
    	local body = game.HttpService:JSONDecode(req)
	
    	if body and body.data then
    	    for i, v in next, body.data do
    	        if type(v) == "table" and tonumber(v.playing) and tonumber(v.maxPlayers) and v.playing < v.maxPlayers and v.id ~= JobId then
    	            table.insert(servers, 1, v.id)
    	        end
    	    end
    	end
	
    	if #servers > 0 then
    	    game["Teleport Service"]:TeleportToPlaceInstance(game.PlaceId, servers[math.random(1, #servers)], game.Players.LocalPlayer)
		end
	end
end)

local function claimOrderAndReturnDetails(orderNum)
	if currentOrderNum then return end
	currentOrderNum = orderNum
	Fire_Server("Execute", "claim " .. orderNum)

	local startTime = os.clock()
	toby = true
	repeat
    
    
	
    	task.wait()
	until os.clock() - startTime >= 5 or game.Players.LocalPlayer.PlayerGui:FindFirstChild("Claim")
	toby = false
	if not game.Players.LocalPlayer.PlayerGui:FindFirstChild("Claim") then return {} end
	
	local items = {}
	for _, item in game.Players.LocalPlayer.PlayerGui.Claim.Main.ScrollingFrame:GetChildren() do
		if item:IsA("Frame") and item:FindFirstChild("Quantity") then
			local b = item.Quantity.Text:gsub("x", "")
			warn(b)
			local suc, res = pcall(tonumber, b)
			if not suc then return {} end
			items[item.Item.Text] = tonumber(b)
		end
	end
	return items
end

local agent = PFS:CreatePath({
	AgentHeight = 5,
	AgentRadius = 1,
	AgentCanJump = false,
})

for _, seat in workspace:GetDescendants() do
	if seat:IsA("Seat") then
		seat.Disabled = true
	end
end

pcall(function()
	workspace.Welcomer:Destroy()
	workspace.Welcomer:Destroy()
end)

local posPoints = {
	drinks = Vector3.new(60.577945709228516, 55.6203498840332, 147.25643920898438),
	fries = Vector3.new(24.9127197265625, 55.62035369873047, 158.22659301757812),
	food = Vector3.new(45.56735610961914, 55.6203498840332, 134.9107208251953),
}

local itemToPoints = {
	Coke = "drinks",
	["Dr Pepper"] = "drinks",
	["Sweet Tea"] = "drinks",
	Lemonade = "drinks",
	Sprite = "drinks",
	["Unsweet Tea"] = "drinks",
	["Fanta"] = "drinks",
	["Water"] = "drinks",

	["THE BOX COMBO"] = "food",
	["THE SANDWICH COMBO"] = "food",
	["THE KIDS COMBO"] = "food",
	["THE CANIAC COMBO"] = "food",
	["25-FINGER TAILGATE"] = "food",
	["Canes Sauce"] = "food",

	["Fries"] = "fries",

}

local function getItem(itemName, quantity)
	quantity = quantity or 1
	local character = game.Players.LocalPlayer.Character
	local itemCategory = itemToPoints[itemName]
	local itemPos = posPoints[itemCategory]
	local path = agent:ComputeAsync(character.HumanoidRootPart.Position, itemPos)
	warn(agent.Status)
	if agent.Status == Enum.PathStatus.Success then
		local waypoints = agent:GetWaypoints()
		for _, waypoint in waypoints do
			character.Humanoid:MoveTo(waypoint.Position)
			character.Humanoid.MoveToFinished:Wait()
		end

		for i = 1, quantity do
			wait(.3)
			if itemCategory == "fries" then
				fireproximityprompt(workspace.RaisingCanesMap.Fries1.ProximityPrompt)
			end

			if itemCategory == "drinks" then
				game.ReplicatedStorage.FridgeEvent:FireServer(workspace.RaisingCanes.Systems.Fridges:GetChildren()[2], itemName)
			end

			if itemCategory == "food" and itemName ~= 'Canes Sauce' then
				fireclickdetector(workspace.RaisingCanes.Systems["Rackify V1.0.0"].Folder:FindFirstChild(itemName):FindFirstChild("ClickDetector", true))
			end

			if itemCategory == "food" and itemName == 'Canes Sauce' then
				for _, sauce in workspace.RaisingCanesMap.CanesSauces:GetDescendants() do
					if sauce:IsA("ProximityPrompt") then
						fireproximityprompt(sauce)
					end
				end
			end
		end

		warn("Done")
	end
end
warn("init")
local function doOrder(item)
	if not item:IsA("Frame") then return end
	warn('try tk')
	if currentOrderNum ~= nil or not item:WaitForChild("Footer").Order.Text:find("Unclaimed") then warn("Return ):") return end
	local details = claimOrderAndReturnDetails(tonumber(item.Name))
	if details == {} then 
		Fire_Server("Execute", "unclaim " .. currentOrderNum)
		currentOrderNum = nil
		wait(0.1)
		for _, s in KVD:GetChildren() do
			doOrder(s)
		end
		return
	end	
	for item, quantity in details do
		getItem(item, quantity)
	end
	wait(1)
	Fire_Server("Execute", "complete " .. currentOrderNum)
	currentOrderNum = nil
	ordersDone = ordersDone + 1
	warn('orders done:', ordersDone)
	delay(.15, function()
		game.TextChatService.TextChannels.RBXGeneral:SendAsync( "I have completed " .. tostring(ordersDone) .. ' orders so far!!')
	end)
	wait(0.1)
	for _, s in KVD:GetChildren() do
		doOrder(s)
	end
end

KVD.ChildAdded:Connect(doOrder)

for _, s in KVD:GetChildren() do
	doOrder(s)
end
