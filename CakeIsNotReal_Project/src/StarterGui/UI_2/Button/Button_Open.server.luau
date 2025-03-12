--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InitializationTracker = require(ReplicatedStorage.Modules.InitializationTracker)
local EventUtilities = require(ReplicatedStorage.Modules.EventUtilities)
local Data = require(ReplicatedStorage.Modules.Data)
local ConfigUtilities = require(ReplicatedStorage.Modules.ConfigUtilities)
local FeedbackScale = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackUIScale)
local FeedbackRotation = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackRotation)

--!const
local ImageObjectValueName = "ImageObject"

local _button: GuiButton
local _imageObject: Instance?

InitializationTracker:WaitUntilReady("Button")

local function Animate(object: Instance, config: Instance?)
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

	local configButton: Instance = config:FindFirstChild("Button")
	local configImage: Instance = config:FindFirstChild("Image")

	Animate(_button, configButton)
	Animate(_imageObject, configImage)
end

local function OnClick()
	--
end

local function OnEnter()
	StartAnimations(_button, Data.Config_Button.Enter)
end

local function OnLeave()
	StartAnimations(_button, Data.Config_Button.Leave)
end

local function OnDown()
	StartAnimations(_button, Data.Config_Button.Down)
end

local function OnUp()
	StartAnimations(_button, Data.Config_Button.Up)
end

local function ConnectButton(button: GuiButton)
	local event = EventUtilities.GetEvent(button, Data.Events_Button.Click)
	if event then
		event.Event:Connect(function()
			OnClick()
		end)
	end

	event = EventUtilities.GetEvent(button, Data.Events_Button.Enter)
	if event then
		event.Event:Connect(function()
			OnEnter()
		end)
	end

	event = EventUtilities.GetEvent(button, Data.Events_Button.Leave)
	if event then
		event.Event:Connect(function()
			OnLeave()
		end)
	end

	event = EventUtilities.GetEvent(button, Data.Events_Button.Down)
	if event then
		event.Event:Connect(function()
			OnDown()
		end)
	end

	event = EventUtilities.GetEvent(button, Data.Events_Button.Up)
	if event then
		event.Event:Connect(function()
			OnUp()
		end)
	end
end

local function Initialize()
	_button = script.Parent
	_imageObject = ConfigUtilities.GetSceneValue(_button, ImageObjectValueName, ConfigUtilities.VlueType.Object)

	ConnectButton(_button)
end

Initialize()

InitializationTracker:SetReady(script.Name)
