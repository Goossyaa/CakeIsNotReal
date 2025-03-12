--!strict

local InitializationTracker = {}
InitializationTracker.__index = InitializationTracker

local _readyStates = {}

function InitializationTracker:SetReady(key: string)
	_readyStates[key] = true
end

function InitializationTracker:WaitUntilReady(key: string)
	while not _readyStates[key] do
		task.wait()
	end
end

return InitializationTracker
