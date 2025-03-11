--!strict

---
--- This feedback will animate the orientation of BasePart over time
---

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FeedbackBase = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackBase)

--!const
local AnimatedParameterName = "Orientation"
--!const
local AnimatedClassName = "BasePart"

local FeedbackOrientation = {}
FeedbackOrientation.__index = FeedbackOrientation

--- @param object Part Part to animate with rotation parameter
--- @param config Configuration Object with attributes
function FeedbackOrientation.new(object: Part, config: Configuration)
	local self = setmetatable({}, FeedbackOrientation)
	self.Object = object
	self.Config = config
	self.ParameterName = AnimatedParameterName
	self.ClassName = AnimatedClassName
	return self
end

function FeedbackOrientation:Play()
	local part = self.Object

	if not part:IsA(self.ClassName) then
		warn(`{part:GetFullName()}({part.ClassName}) not compatable. Shold be ({self.ClassName})`)
		return nil
	end

	local tweenInfo = FeedbackBase:GetTweenInfo(self.Config)
	local targetOrientation: Vector3 = self.Config:GetAttribute(self.ParameterName) or part.Orientation

	if not typeof(targetOrientation) == "Vector3" then
		warn("Target orientation must be Vector3")
		return nil
	end

	local orientationTween: Tween = FeedbackBase:GetTween(part, tweenInfo, self.ParameterName, targetOrientation)

	orientationTween:Play()
	return orientationTween
end

return FeedbackOrientation
