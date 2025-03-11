--!strict

local _parent = script.Parent
local _patationAxis = Vector3.new(0, 1, 0)
local _rotationSpeed = 0.3

local _isRotating = true

while _isRotating do
	_parent:SetPrimaryPartCFrame(_parent.PrimaryPart.CFrame * CFrame.fromAxisAngle(_patationAxis, _rotationSpeed))
	wait()
end
