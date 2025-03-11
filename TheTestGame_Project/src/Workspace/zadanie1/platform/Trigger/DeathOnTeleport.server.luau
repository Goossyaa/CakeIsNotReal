--!strict

local InitializationTracker = require(game.ReplicatedStorage.Modules.InitializationTracker)
local EventUtilities = require(game.ReplicatedStorage.Modules.EventUtilities)

--!const
local OnTeleportEventName = "OnTeleport"
--!const
local TeleportedNumberToKill = 5

local _parent = script.Parent
local _teleportedPlayers = {} -- [Player] = teleportedCount

InitializationTracker:WaitUntilReady("Teleport")

local function Kill(player)
	local character = player.Character
	if not character then
		return
	end

	local humanoid = character:FindFirstChild("Humanoid")
	if humanoid then
		humanoid.Health = 0
		print(player.Name, "was killed instead of teleporting.")
	else
		warn("No Humanoid found for player:", player.Name)
	end
end

local function OnTeleport(player: Player)
	local teleportedCount = _teleportedPlayers[player]

	if not player or not player.Parent then
		return
	end

	if not _teleportedPlayers[player] then
		_teleportedPlayers[player] = 0
	end

	_teleportedPlayers[player] += 1
	-- print(player.Name, "teleported", _teleportedPlayers[player], "times")

	if _teleportedPlayers[player] % TeleportedNumberToKill == 0 then
		Kill(player)
	end
end

local function ConnectOnTeleport()
	local event = EventUtilities.GetEvent(_parent, OnTeleportEventName)
	if event then
		event.Event:Connect(function(player)
			OnTeleport(player)
		end)
	end
end

ConnectOnTeleport()

game:GetService("Players").PlayerRemoving:Connect(function(player)
	_teleportedPlayers[player] = nil
end)
