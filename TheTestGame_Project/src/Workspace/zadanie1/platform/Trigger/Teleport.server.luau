--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local PlayersService = game:GetService("Players")

local InitializationTracker = require(ReplicatedStorage.Modules.InitializationTracker)
local EventUtilities = require(ReplicatedStorage.Modules.EventUtilities)
local CharacterUtilities = require(ReplicatedStorage.Modules.CharacterUtilities)
local ConfigUtilities = require(ReplicatedStorage.Modules.ConfigUtilities)

--!const
local TargetLocationObjectValueName = "TargetLocation"
--!const
local TeleportDelayNumberValueName = "TeleportDelay"

--!const
local OnTriggerEnterEventName = "OnTriggerEnter"
--!const
local OnTriggerExitEventName = "OnTriggerExit"

--!const
local OnTeleportEventName = "OnTeleport"

local _parent = script.Parent
local _queuePlayers = {} -- [Player] = startTime

local _defaltTeleportDelay: number = 2
local _delay: number

InitializationTracker:WaitUntilReady("Triggers")

function GetValue(object: Instance, name: string): any?
	local sceneValue = object:FindFirstChild(name)
	local value

	if sceneValue and sceneValue.Value then
		value = sceneValue.Value
	end

	return value
end

local function GetDelay(): number
	local delay = ConfigUtilities.GetSceneValue(_parent, TeleportDelayNumberValueName, ConfigUtilities.VlueType.Number)

	if not delay then
		print("Default delay")
		delay = _defaltTeleportDelay
	end

	_delay = delay
	return delay
end

local function GetTargetCFrameFromAttribute(object, sceneValueName)
	local target = ConfigUtilities.GetSceneValue(object, sceneValueName, ConfigUtilities.VlueType.Object)

	if not typeof(target) == "Instance" and not target:IsA("BasePart") then
		warn("TargetLocation not set for", object.Name)
		return nil
	end

	local cFrame = target.CFrame
	return cFrame
end

local function Teleport(player)
	if not player then
		return
	end

	local character = player.Character

	if not character then
		warn("Teleport fail for ", player.name)
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid or humanoid.Health <= 0 then
		return
	end

	EventUtilities.InvokeEvent(_parent, OnTeleportEventName, player)
	task.wait()

	if humanoid.Health <= 0 then
		return
	end

	local targetCFrame = GetTargetCFrameFromAttribute(_parent, TargetLocationObjectValueName)

	if targetCFrame then
		character:SetPrimaryPartCFrame(targetCFrame)
	end
end

local function AddToQueue(player)
	-- print(player.Name, "added to queue")
	_queuePlayers[player] = os.clock()
end

local function RemoveFromQueue(player)
	-- print(player.Name, "removed from queue")
	_queuePlayers[player] = nil
end

local function CheckPlayersTimeAndTeleport()
	local currentTime = os.clock()

	local playersToCheck = {}

	for player, enterTime in pairs(_queuePlayers) do
		playersToCheck[player] = enterTime
	end

	for player, enterTime in pairs(playersToCheck) do
		if not player or not player.Parent then
			RemoveFromQueue(player)
			continue
		end

		if type(enterTime) ~= "number" then
			warn("Wrong time foe player", player.Name)
			RemoveFromQueue(player)
			continue
		end

		local elapsedTime: number = currentTime - enterTime

		if elapsedTime >= GetDelay() then
			Teleport(player)
			RemoveFromQueue(player)
		end
	end
end

local function Update(deltaTime)
	CheckPlayersTimeAndTeleport()
end

RunService.Heartbeat:Connect(function(deltaTime)
	Update(deltaTime)
end)

local function ConnectStartTimer()
	local event = EventUtilities.GetEvent(_parent, OnTriggerEnterEventName)
	if event then
		event.Event:Connect(function(collision)
			local player = CharacterUtilities.GetPlayerByRoot(collision)
			AddToQueue(player)
		end)
	end
end

local function ConnectStopTimer()
	local event = EventUtilities.GetEvent(_parent, OnTriggerExitEventName)
	if event then
		event.Event:Connect(function(collision)
			local player = CharacterUtilities.GetPlayerByRoot(collision)
			RemoveFromQueue(player)
		end)
	end
end

ConnectStartTimer()
ConnectStopTimer()

PlayersService.PlayerRemoving:Connect(function(player)
	RemoveFromQueue(player)
end)

EventUtilities.CreateEvent(_parent, OnTeleportEventName)

InitializationTracker:SetReady(script.Name)
