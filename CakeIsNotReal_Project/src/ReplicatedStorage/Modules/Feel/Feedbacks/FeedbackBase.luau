--!strict
local TweenService = game:GetService("TweenService")

local FeedbackBase = {}

-- local function ValidateType(targetObject: Instance, propertyName: string, value: any): boolean
-- 	local currentValue = targetObject[propertyName]
-- 	local expectedType = typeof(currentValue)

-- 	if not typeof(value) == expectedType then
-- 		error(`Invalid type «{typeof(value)}» for property «{propertyName}». Expected «{expectedType}»`)
-- 		return false
-- 	end

-- 	return true
-- end

function FeedbackBase:GetTweenInfo(config: Instance): TweenInfo
	local time = config:GetAttribute("Duration") or 0
	local easingStyle = Enum.EasingStyle[config:GetAttribute("EasingStyle") or "Elastic"]
	local easingDirection = Enum.EasingDirection[config:GetAttribute("EasingDirection") or "Out"]
	local repeatCount = config:GetAttribute("RepeatCount") or 0
	local reverses = config:GetAttribute("IsReverses") or false
	local delayTime = config:GetAttribute("Delay") or 0

	-- stylua: ignore
	local tweenInfo = TweenInfo.new(
		time,
		easingStyle,
		easingDirection,
		repeatCount,
		reverses,
		delayTime
	)

	return tweenInfo
end

function FeedbackBase:GetTween(
	targetObject: Instance,
	tweenInfo: TweenInfo,
	propertyName: string,
	propertyValue: any
): Tween
	-- if not ValidateType(targetObject, propertyName, propertyValue) then
	-- 	return nil
	-- end

	local isPropertyExist, _ = pcall(function()
		return targetObject[propertyName]
	end)

	if not isPropertyExist then
		warn(`Property «{propertyName}» does not exist in {targetObject.Name} ({targetObject.ClassName})`)
		return nil
	end

	local currentValue = targetObject[propertyName]

	if typeof(currentValue) ~= typeof(propertyValue) then
		local ofText = `«{string.upper(typeof(propertyValue))}»`
		local forText = `({propertyName}({string.upper(typeof(currentValue))})`
		local inText = `({targetObject.Name}{targetObject.ClassName})`

		error(`Incompatible type of {ofText} for {forText} in {inText}`)

		return nil
	end

	local propertyValues = { [propertyName] = propertyValue }
	local tween = TweenService:Create(targetObject, tweenInfo, propertyValues)

	return tween
end

return FeedbackBase
