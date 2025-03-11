--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ConfigUtilities = require(ReplicatedStorage.Modules.ConfigUtilities)
local FeedbackScale = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackUIScale)
local FeedbackRotation = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackRotation)

--!const
local CountTextObjectValueName = "Text_Count"
--!const
local ButtonAddObjectValueName = "Button_Add"

--!const
local UpdateCountEventName = "UpdateRouletteCount"

local _parent = script.Parent
local _countText = ConfigUtilities.GetSceneValue(_parent, CountTextObjectValueName, ConfigUtilities.VlueType.Object)

local _closeTask = nil

local function UpdateView(text, count)
	if text then
		text.Text = count
	end
end

UpdateView(_countText, 0)

local function StartAnimations(object: Instance, configName: string)
	local config = object:FindFirstChild(configName)

	if not config then
		return
	end

	local configText = config:FindFirstChild("Text")

	FeedbackScale.new(object, configText):Play()
	FeedbackRotation.new(object, configText):Play()
end

local function CancelCurrentTask()
	if _closeTask then
		task.cancel(_closeTask)
		_closeTask = nil
	end
end

local function OnAdd(count: number)
	UpdateView(_countText, count)

	CancelCurrentTask()
	StartAnimations(_countText, "Feedback_Add_1")

	_closeTask = task.delay(0.1, function() -- TODO combined durations of previus feedback
		StartAnimations(_countText, "Feedback_Add_2")
		_closeTask = nil
	end)
end

local updateCountEvent = ReplicatedStorage:WaitForChild(UpdateCountEventName)
updateCountEvent.OnClientEvent:Connect(function(count: number)
	OnAdd(count)
end)
