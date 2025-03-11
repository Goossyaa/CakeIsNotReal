--!strict

---
--- This feedback will animate the rotation of GuiObject over time
---

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FeedbackBase = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackBase)

--!const
local AnimatedParameterName = "Rotation"
--!const
local AnimatedClassName = "GuiObject"

local FeedbackRotation = {}
FeedbackRotation.__index = FeedbackRotation

--- @param object GuiObject GuiObject to animate with rotation parameter
--- @param config Configuration Object with attributes
function FeedbackRotation.new(object: GuiObject, config: Configuration)
	local self = setmetatable({}, FeedbackRotation)
	self.Object = object
	self.Config = config
	self.ParameterName = AnimatedParameterName
	self.ClassName = AnimatedClassName
	return self
end

function FeedbackRotation:Play()
	local guiObject = self.Object

	if not guiObject:IsA(self.ClassName) then
		warn(`{guiObject:GetFullName()}({guiObject.ClassName}) not compatable. Shold be ({self.ClassName})`)
		return nil
	end


	local tweenInfo = FeedbackBase:GetTweenInfo(self.Config)
	local targetRotation = self.Config:GetAttribute(self.ParameterName) or guiObject.Rotation

	local rotationTween = FeedbackBase:GetTween(guiObject, tweenInfo, self.ParameterName, targetRotation)

	rotationTween:Play()
	return rotationTween
end

return FeedbackRotation
