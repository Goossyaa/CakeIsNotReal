--!strict

---
--- This feedback will animate the orientation of all parts in Model over time
---

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FeedbackBase = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackBase)

--!const
local AnimatedParameterName = "Orientation"
--!const
local AnimatedClassName = "BasePart"

local FeedbackModelOrientation = {}
FeedbackModelOrientation.__index = FeedbackModelOrientation

--- @param object Part Part to animate with rotation parameter
--- @param config Configuration Object with attributes
function FeedbackModelOrientation.new(object: Model, config: Configuration)
	local self = setmetatable({}, FeedbackModelOrientation)
	self.Object = object
	self.Config = config
	self.ParameterName = AnimatedParameterName
	self.ClassName = AnimatedClassName
	return self
end

function FeedbackModelOrientation:Play()
	local part: BasePart = self.Object.PrimaryPart

	if not part:IsA(self.ClassName) then
		warn(`{part:GetFullName()}({part.ClassName}) not compatable. Shold be ({self.ClassName})`)
		return nil
	end

	local tweenInfo = FeedbackBase:GetTweenInfo(self.Config)
	local targetVector3: Vector3 = self.Config:GetAttribute(self.ParameterName)

	local orientationTween: Tween = FeedbackBase:GetTween(part, tweenInfo, "Rotation", targetVector3)
	orientationTween:Play()
	return orientationTween
end

return FeedbackModelOrientation
