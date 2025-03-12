--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InitializationTracker = require(ReplicatedStorage.Modules.InitializationTracker)
local EventUtilities = require(ReplicatedStorage.Modules.EventUtilities)
local Data = require(ReplicatedStorage.Modules.Data)
local WindowBase = require(ReplicatedStorage.Modules.WindowBase)

local ConfigUtilities = require(ReplicatedStorage.Modules.ConfigUtilities)
local FeedbackScale = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackUIScale)
local FeedbackRotation = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackRotation)
local FeedbackGroupTransparency = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackGroupTransparency)

--!const
local SecondaryObjectValueName = "SecondaryObject"

--!const
local ButtonCloseObjectValueName = "Button_Close"
--!const
local ButtonToggleObjectValueName = "Button_Toggle"

local _secondaryObject: Instance?

local _window = WindowBase.new(script.Parent)
_window.SholdChangeTransparency = false

local _events = Data.Events_Window

InitializationTracker:SetReady("Button")
InitializationTracker:SetReady("Button_Open")

local function AnimateWindow(object: Instance, config: Instance?)
	if not object or not config then
		return
	end

	local scaleFeedback = FeedbackScale.new(object, config)
	scaleFeedback:Play()

	local rotationFeedback = FeedbackRotation.new(object, config)
	rotationFeedback:Play()

	local transparencyFeedback = FeedbackGroupTransparency.new(object, config)
	transparencyFeedback:Play()
end

local function AnimateSecondary(object: Instance, config: Instance?)
	if not object or not config then
		return
	end

	local scaleFeedback = FeedbackScale.new(object, config)
	scaleFeedback:Play()

	local rotationFeedback = FeedbackRotation.new(object, config)
	rotationFeedback:Play()
end

local function StartAnimations(object: Instance, configName: string)
	local config: Instance = object:FindFirstChild(configName)

	if not config then
		return
	end

	local configWindow: Instance = config:FindFirstChild("Window")
	local configSecondary: Instance = config:FindFirstChild("Secondary")

	AnimateWindow(_window.Object, configWindow)
	AnimateSecondary(_secondaryObject, configSecondary)
end

local closeTask = nil

local function CancelCurrentTask()
	if closeTask then
		task.cancel(closeTask)
		closeTask = nil
	end
end

local function OnOpen()
	CancelCurrentTask()
	StartAnimations(_window.Object, Data.Config_Window.Open)
end

local function OnClose()
	CancelCurrentTask()

	StartAnimations(_window.Object, Data.Config_Window.Close)

	closeTask = task.delay(0.65, function() -- TODO combined durations of previus feedback
		StartAnimations(_window.Object, "Feedback_AfterClose")
		closeTask = nil
	end)
end

local function OnToggle()
	if _window.IsOpen then
		_window:Close()
	else
		_window:Open()
	end
end

local function ConnectWindow(window)
	local event = EventUtilities.GetEvent(window, _events.Open)
	if event then
		event.Event:Connect(function()
			OnOpen()
		end)
	end

	local event = EventUtilities.GetEvent(window, _events.Close)
	if event then
		event.Event:Connect(function()
			OnClose()
		end)
	end
end

local function ConnectButtons()
	local clickEventName = Data.Events_Button.Click
	local objectType = ConfigUtilities.VlueType.Object

	local buttonClose = ConfigUtilities.GetSceneValue(_window.Object, ButtonCloseObjectValueName, objectType)
	local buttonToggle = ConfigUtilities.GetSceneValue(_window.Object, ButtonToggleObjectValueName, objectType)

	local event = EventUtilities.GetEvent(buttonClose, clickEventName)
	if event then
		event.Event:Connect(function()
			_window:Close()
		end)
	end

	local event = EventUtilities.GetEvent(buttonToggle, clickEventName)
	if event then
		event.Event:Connect(function()
			OnToggle()
		end)
	end
end

local function Initialize()
	_secondaryObject =
		ConfigUtilities.GetSceneValue(_window.Object, SecondaryObjectValueName, ConfigUtilities.VlueType.Object)
	ConnectWindow(_window.Object)
	ConnectButtons()

	_window:Close()
	StartAnimations(_window.Object, "Feedback_AfterClose")
end

task.wait() -- TODO Button toggle initialized after this script without this wait
Initialize()
