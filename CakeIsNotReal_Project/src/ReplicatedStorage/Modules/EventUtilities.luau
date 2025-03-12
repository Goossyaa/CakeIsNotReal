--!strict

local EventUtilities = {}

--- @param object Instance where bindable event will be created
--- @param eventName string name of created event
function EventUtilities.CreateEvent(object: Instance, eventName: string)
	if not object:FindFirstChild(eventName) then
		local event = Instance.new("BindableEvent")
		event.Name = eventName
		event.Parent = object
	end
end

--- @param object Instance where event will be found and fired
--- @param eventName string event name to find and fire
--- @param value any value to send on fire
function EventUtilities.InvokeEvent(object: Instance, eventName: string, value: any)
	local event = object:FindFirstChild(eventName)
	if event then
		event:Fire(value)
	end
end

--- @param object Instance where event will be found
--- @param eventName string event name to find
function EventUtilities.GetEvent(object: Instance, eventName: string): Instance?
	local event = object:FindFirstChild(eventName)
	return event
end

return EventUtilities
