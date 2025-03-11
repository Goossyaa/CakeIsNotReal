--!strict

---
--- This feedback will animate the CFrame of BasePart over time
---

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local FeedbackBase = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackBase)

--!const
local AnimatedParameterName = "CFrame"
--!const
local AnimatedClassName = "BasePart"

local FeedbackCFrame = {}
FeedbackCFrame.__index = FeedbackCFrame

--- @param object Part Part to animate with rotation parameter
--- @param config Configuration Object with attributes
function FeedbackCFrame.new(object: Part, config: Configuration)
	local self = setmetatable({}, FeedbackCFrame)
	self.Object = object
	self.Config = config
	self.ParameterName = AnimatedParameterName
	self.ClassName = AnimatedClassName
	return self
end

function FeedbackCFrame:Play(): Tween
	local object = self.Object

	if not object:IsA(self.ClassName) then
		warn(`{object:GetFullName()}({object.ClassName}) not compatable. Shold be ({self.ClassName})`)
		return nil
	end

	local tweenInfo = FeedbackBase:GetTweenInfo(self.Config)
	local targetCFrame: CFrame = self.Config:GetAttribute(self.ParameterName)

	if typeof(targetCFrame) ~= "CFrame" then
		warn("Target must be CFrame")
		return nil
	end

	local tween: Tween = FeedbackBase:GetTween(object, tweenInfo, self.ParameterName, targetCFrame)

	tween:Play()
	return tween
end

return FeedbackCFrame
