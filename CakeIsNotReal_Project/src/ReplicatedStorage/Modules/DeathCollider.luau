local Players = game:GetService("Players")

local _part = script.Parent

local function onTouch(collision: Part)
	local humanoid = collision.Parent:FindFirstChild("Humanoid")

	if not humanoid then
		return
	end

	local player = Players:GetPlayerFromCharacter(collision.Parent)

	if not player then
		return
	end

	humanoid.Health = 0
end

_part.Touched:Connect(onTouch)
