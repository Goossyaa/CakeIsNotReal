--!strict

local CollectionService = game:GetService("CollectionService")
local PlayersService = game:GetService("Players")

local InitializationTracker = require(game.ReplicatedStorage.Modules.InitializationTracker)
local EventUtilities = require(game.ReplicatedStorage.Modules.EventUtilities)
local CharacterUtilities = require(game.ReplicatedStorage.Modules.CharacterUtilities)

--!const
local OnTriggerEnterEventName = "OnTriggerEnter"
--!const
local OnTriggerExitEventName = "OnTriggerExit"
--!const
local OnCountChangeEventName = "OnCountChange"

--!const
local TriggerTagName: string = "Trigger"
--!const
local TriggeredCountAttributeName: string = "TriggeredCount"


local triggers = CollectionService:GetTagged(TriggerTagName)

local _playersInTrigger = {}

local function CountSet(trigger)
	if not trigger:GetAttribute(TriggeredCountAttributeName) then
		trigger:SetAttribute(TriggeredCountAttributeName, 0)
	end
end

local function CountAdd(trigger)
	CountSet(trigger)
	local currentCount: number = trigger:GetAttribute(TriggeredCountAttributeName)
	local count: number = currentCount + 1

	trigger:SetAttribute(TriggeredCountAttributeName, count)

	EventUtilities.InvokeEvent(trigger, OnCountChangeEventName, trigger:GetAttribute(TriggeredCountAttributeName))
end

local function OnEnter(trigger, player)
	if player and not _playersInTrigger[player] then
		_playersInTrigger[player] = true
		CountAdd(trigger)
	end
end

local function OnExit(trigger, player)
	if player and _playersInTrigger[player] then
		_playersInTrigger[player] = nil
	end
end

local function OnDeath(player: Player)
	local teleport = nil
	OnExit(teleport, player)
end

local function OnTriggerEnter(trigger, collision)
	local player = CharacterUtilities.GetPlayerByRoot(collision)

	if player == nil then
		return
	end

	OnEnter(trigger, player)
	EventUtilities.InvokeEvent(trigger, OnTriggerEnterEventName, collision)
end

local function OnTriggerExit(trigger, collision)
	local player = CharacterUtilities.GetPlayerByRoot(collision)

	if player == nil then
		return
	end

	EventUtilities.InvokeEvent(trigger, OnTriggerExitEventName, collision)
	OnExit(trigger, player)
end

for _, trigger in triggers do
	if trigger.CanTouch == false then
		warn("CanTouch of part " .. trigger.Name .. " is false")
		continue
	end

	EventUtilities.CreateEvent(trigger, OnTriggerEnterEventName)
	EventUtilities.CreateEvent(trigger, OnTriggerExitEventName)

	EventUtilities.CreateEvent(trigger, OnCountChangeEventName)

	CountSet(trigger)

	trigger.Touched:Connect(function(collision)
		OnTriggerEnter(trigger, collision)
	end)

	trigger.TouchEnded:Connect(function(collision)
		OnTriggerExit(trigger, collision)
	end)
end
PlayersService.PlayerAdded:Connect(function(player: Player)
	player.CharacterAdded:Connect(function(character: Model)
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				OnDeath(player)
			end)
		end
	end)
end)

for _, player in ipairs(PlayersService:GetPlayers()) do
	if player.Character then
		local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.Died:Connect(function()
				OnDeath(player)
			end)
		end
	end
end

InitializationTracker:SetReady(script.Name)
