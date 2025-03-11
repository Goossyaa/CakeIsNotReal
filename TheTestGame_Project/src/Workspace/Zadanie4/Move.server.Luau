--!strict

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local ConfigUtilities = require(ReplicatedStorage.Modules.ConfigUtilities)
local FeedbackCFrame = require(ReplicatedStorage.Modules.Feel.Feedbacks.FeedbackCFrame)

--!const
local ObjectToMoveObjectValueName = "ObjectToMove"
--!const
local Position1ObjectValueName = "Position1"
local Position2ObjectValueName = "Position2"

local _parent = script.Parent

local _objectType = ConfigUtilities.VlueType.Object

local _objectToMove: Instance = ConfigUtilities.GetSceneValue(_parent, ObjectToMoveObjectValueName, _objectType)

local _positionObject1: Instance = ConfigUtilities.GetSceneValue(_parent, Position1ObjectValueName, _objectType)
local _positionObject2: Instance = ConfigUtilities.GetSceneValue(_parent, Position2ObjectValueName, _objectType)

local function StartAnimations(object: Instance, configName: string, positionObject): Tween
	local config = object:FindFirstChild(configName)

	if not config then
		warn(`Config is nil`)
		return
	end

	local configPosition: Instance = config:FindFirstChild("Part")

	local position: CFrame = positionObject.CFrame
	configPosition:SetAttribute("CFrame", position)

	local tween: Tween = FeedbackCFrame.new(object, configPosition):Play()
	return tween
end

local function Animate(object: Instance)
	local tween: Tween = StartAnimations(object, "Feedback_Position1", _positionObject1)
	tween.Completed:Wait()

	tween = StartAnimations(object, "Feedback_Position2", _positionObject2)
	tween.Completed:Wait()

	Animate(object)
end

Animate(_objectToMove)
