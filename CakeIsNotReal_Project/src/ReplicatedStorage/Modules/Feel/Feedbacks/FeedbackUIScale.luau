--!strict

---
--- This feedback will animate the scale of UIScale over time
---

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FeedbackBase = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackBase)

--!const
local AnimatedParameterName = "Scale"
--!const
local AnimatedClassName = "UIScale"

local FeedbackScale = {}
FeedbackScale.__index = FeedbackScale

--- @param object UIScale Object that have UIScale as child
--- @param config Configuration Object that have attributes
function FeedbackScale.new(object: UIScale, config: Configuration)
	local self = setmetatable({}, FeedbackScale)
	self.Object = object
	self.Config = config
    self.ParameterName = AnimatedParameterName
    self.ClassName = AnimatedClassName
	return self
end

function FeedbackScale:Play()
	local uiScale = self.Object:FindFirstChildOfClass(self.ClassName)

	if not uiScale then
		warn("UIScale not set in", self.Object:GetFullName())
		return nil
	end

	local tweenInfo = FeedbackBase:GetTweenInfo(self.Config)
	local targetScale = self.Config:GetAttribute(self.ParameterName) or 1

	local scaleTween = FeedbackBase:GetTween(uiScale, tweenInfo, self.ParameterName, targetScale)

	scaleTween:Play()
	return scaleTween
end

return FeedbackScale
