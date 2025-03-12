--!strict

local CharacterUtilities = {}

--!const
CharacterUtilities.CharacterRootName = "HumanoidRootPart"
local _playersService = game:GetService("Players")

function CharacterUtilities.IsCharacterRoot(object): boolean
	return object.Name == CharacterUtilities.CharacterRootName
end

function CharacterUtilities.GetPlayerByRoot(object: any, shouldBeAlive: boolean?)
	shouldBeAlive = shouldBeAlive or true

	if not CharacterUtilities.IsCharacterRoot(object) then
		return nil
	end

	local character = object.Parent
	local humanoid = character:FindFirstChild("Humanoid")

	if not humanoid then
		return nil
	end

	if shouldBeAlive then
		if humanoid.Health <= 0 then
			return nil
		end
	end

	local player = _playersService:GetPlayerFromCharacter(character)
	return player
end

return CharacterUtilities
