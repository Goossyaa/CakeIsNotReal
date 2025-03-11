--!strict

---
--- This feedback will animate the GroupTransparency of CanvasGroup over time
---

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FeedbackBase = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackBase)

--!const
local AnimatedParameterName = "GroupTransparency"
--!const
local AnimatedClassName = "CanvasGroup"

local FeedbackGroupTransparency = {}
FeedbackGroupTransparency.__index = FeedbackGroupTransparency

--- @param object CanvasGroup — Object that contains CanvasGroup as child
--- @param config Configuration — Object with attributes
function FeedbackGroupTransparency.new(object: CanvasGroup, config: Configuration)
	local self = setmetatable({}, FeedbackGroupTransparency)
	self.Object = object
	self.Config = config
	self.ParameterName = AnimatedParameterName
	self.ClassName = AnimatedClassName
	return self
end

function FeedbackGroupTransparency:Play()
	local canvasGroup = self.Object

	if not canvasGroup then
		warn("CanvasGroup not found in", self.Object:GetFullName())
		return nil
	end

	if not canvasGroup:IsA(self.ClassName) then
		warn(`{canvasGroup:GetFullName()}({canvasGroup.ClassName}) not compatible. Should be ({self.ClassName})`)
		return nil
	end

	local tweenInfo = FeedbackBase:GetTweenInfo(self.Config)
	local targetTransparency = self.Config:GetAttribute(self.ParameterName) or 0

	local transparencyTween = FeedbackBase:GetTween(canvasGroup, tweenInfo, self.ParameterName, targetTransparency)

	transparencyTween:Play()
	return transparencyTween
end

return FeedbackGroupTransparency