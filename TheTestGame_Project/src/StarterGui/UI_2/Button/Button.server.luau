--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local InitializationTracker = require(ReplicatedStorage.Modules.InitializationTracker)
local EventUtilities = require(ReplicatedStorage.Modules.EventUtilities)
local Data = require(ReplicatedStorage.Modules.Data)

local _button: GuiButton = script.Parent

local _events = Data.Events_Button -- [Event] = name

local function CteateEvents()
	for event, name in pairs(_events) do
		EventUtilities.CreateEvent(_button, name)
	end
end

local function ConnectEvents()
	_button.MouseButton1Click:Connect(function()
		EventUtilities.InvokeEvent(_button, _events.Click)
	end)

	_button.MouseEnter:Connect(function()
		EventUtilities.InvokeEvent(_button, _events.Enter)
	end)
	_button.MouseLeave:Connect(function()
		EventUtilities.InvokeEvent(_button, _events.Leave)
	end)

	_button.MouseButton1Down:Connect(function()
		EventUtilities.InvokeEvent(_button, _events.Down)
	end)
	_button.MouseButton1Up:Connect(function()
		EventUtilities.InvokeEvent(_button, _events.Up)
	end)
end

local function Initialize()
	CteateEvents()
	ConnectEvents()
end

Initialize()

InitializationTracker:SetReady(script.Name)

return _button
