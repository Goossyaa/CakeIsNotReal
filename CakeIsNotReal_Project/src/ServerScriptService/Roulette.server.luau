--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")

local InitializationTracker = require(ReplicatedStorage.Modules.InitializationTracker)

--!const
local UpdateCountEventName = "UpdateRouletteCount"

--!const
local CountNumberToKill = 20

local _playersRouletteCount = {} -- [Player] = rouletteCount
local rouletteData = DataStoreService:GetDataStore("RouletteCount")

local function LoadPlayerData(player: Player)
	local success, data = pcall(function()
		return rouletteData:GetAsync(player.UserId)
	end)

	if success then
		if type(data) == "number" then
			_playersRouletteCount[player] = data
		else
			_playersRouletteCount[player] = 0
		end
	else
		_playersRouletteCount[player] = 0
	end

	local event = ReplicatedStorage:FindFirstChild(UpdateCountEventName)
	if event then
		event:FireClient(player, _playersRouletteCount[player])
	else
		warn(`{UpdateCountEventName} event is nil`)
	end
end

local function SavePlayerData(player: Player)
	local count = _playersRouletteCount[player] or 0
	pcall(function()
		rouletteData:SetAsync(player.UserId, count)
		-- print(`Saved data for {player.Name} count: {count}`)
	end)
end

local function Kill(player)
	local character = player.Character

	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then
		return
	end

	humanoid.Health = 0

	SavePlayerData(player)

	player.CharacterAdded:Once(function()
		task.wait(1)
		LoadPlayerData(player)
	end)
end

local function OnAdd(player: Player)
	local character = player.Character
	local humanoid = character:FindFirstChildOfClass("Humanoid")

	if not humanoid or humanoid.Health <= 0 then
		return
	end

	local currentCount = _playersRouletteCount[player] or 0
	_playersRouletteCount[player] = currentCount + 1

	local updateCountEvent = ReplicatedStorage:FindFirstChild(UpdateCountEventName)
	if updateCountEvent then
		updateCountEvent:FireClient(player, _playersRouletteCount[player])
	end

	if _playersRouletteCount[player] % CountNumberToKill == 0 then
		Kill(player)
	end
end

local function ConnectButton()
	local remoteEvent = ReplicatedStorage:FindFirstChild("ButtonAdd_OnClick") or Instance.new("RemoteEvent")
	remoteEvent.Name = "ButtonAdd_OnClick"
	remoteEvent.Parent = ReplicatedStorage

	remoteEvent.OnServerEvent:Connect(function(player: Player)
		OnAdd(player)
	end)
end

local function Initialize()
	ConnectButton()

	local updateEvent = ReplicatedStorage:FindFirstChild(UpdateCountEventName)
	if not updateEvent then
		updateEvent = Instance.new("RemoteEvent")
		updateEvent.Name = UpdateCountEventName
		updateEvent.Parent = ReplicatedStorage
	end

	game:GetService("Players").PlayerAdded:Connect(function(player)
		LoadPlayerData(player)

		player.CharacterAdded:Connect(function(character)
			LoadPlayerData(player)
		end)
	end)

	game:GetService("Players").PlayerRemoving:Connect(function(player)
		SavePlayerData(player)
	end)
end

Initialize()

InitializationTracker:SetReady(script.Name)
