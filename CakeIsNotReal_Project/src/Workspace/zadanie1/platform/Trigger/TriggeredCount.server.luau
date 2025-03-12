--!strict

local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InitializationTracker = require(ReplicatedStorage.Modules.InitializationTracker)
local EventUtilities = require(ReplicatedStorage.Modules.EventUtilities)
local ConfigUtilities = require(ReplicatedStorage.Modules.ConfigUtilities)

--!const
local TextLabelObjectName: string = "TextLabelObject"
--!const
local TriggerTagName: string = "Trigger"
--!const
local TriggeredCountAttributeName: string = "TriggeredCount"

--!const
local OnCountChangeEventName = "OnCountChange"

local _triggers = CollectionService:GetTagged(TriggerTagName)

InitializationTracker:WaitUntilReady("Triggers")

local function SetView(trigger)
	local count = 0

	local textLabel = ConfigUtilities.GetSceneValue(trigger, TextLabelObjectName, ConfigUtilities.VlueType.Object)

	if textLabel then
		textLabel.Text = count
	end
end

local function UpdateView(trigger, count)
	local count = count or trigger:GetAttribute(TriggeredCountAttributeName)

	local textLabel = ConfigUtilities.GetSceneValue(trigger, TextLabelObjectName, ConfigUtilities.VlueType.Object)

	if textLabel then
		textLabel.Text = count
	end
end

for _, trigger in _triggers do
	SetView(trigger)

	task.spawn(function()
		SetView(trigger)

		local event = EventUtilities.GetEvent(trigger, OnCountChangeEventName)

		if event then
			event.Event:Connect(function(triggeredCount)
				UpdateView(trigger)
			end)
		else
			warn("Event not connected", OnCountChangeEventName)
		end
	end)
end
