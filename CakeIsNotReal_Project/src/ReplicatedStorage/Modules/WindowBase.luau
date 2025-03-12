--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local EventUtilities = require(ReplicatedStorage.Modules.EventUtilities)
local Data = require(ReplicatedStorage.Modules.Data)

local _events = Data.Events_Window -- [Event] = name

local WindowBase = {}
WindowBase.__index = WindowBase

function WindowBase.new(object: CanvasGroup)
	local self = setmetatable({}, WindowBase)
	self.Object = object
	self.IsOpen = false
	self.IsInteractible = false
	self.Object.GroupTransparency = 1
	self.SholdChangeTransparency = true
	self:Initialize()
	return self
end

local function SetChildrenInteractible(parent: Instance, isInteractible: boolean)
	for _, child in ipairs(parent:GetDescendants()) do
		if child:IsA("GuiButton") then
			child.Active = isInteractible
			child.Interactable = isInteractible
		end
	end
end

function WindowBase:SetState(isOpen: boolean)
	if isOpen then
		self:Open()
	else
		self:Close()
	end

	EventUtilities.InvokeEvent(self.Object, _events.Change, isOpen)
end

function WindowBase:Open()
	self.IsOpen = true
	self.IsInteractible = true
	SetChildrenInteractible(self.Object, self.IsInteractible)

	if self.SholdChangeTransparency then
		self.Object.GroupTransparency = 0
	end

	EventUtilities.InvokeEvent(self.Object, _events.Open)
end

function WindowBase:Close()
	self.IsOpen = false
	self.IsInteractible = false
	SetChildrenInteractible(self.Object, self.IsInteractible)

	if self.SholdChangeTransparency then
		self.Object.GroupTransparency = 1
	end

	EventUtilities.InvokeEvent(self.Object, _events.Close)
end

local function CreateEvents(window: CanvasGroup)
	for event, name in pairs(_events) do
		EventUtilities.CreateEvent(window, name)
	end
end

function WindowBase:Initialize()
	CreateEvents(self.Object)
end

return WindowBase
