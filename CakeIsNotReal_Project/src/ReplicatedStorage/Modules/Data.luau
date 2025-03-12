--!strict

local Data = {}

--- [EventType] = name
Data.Events_Button = {
	Click = "OnClick",
	Enter = "OnEnter",
	Leave = "OnLeave",
	Down = "OnDown",
	Up = "OnUp",
}

Data.Config_Button = {
	Click = "Feedback_OnClick",
	Enter = "Feedback_OnEnter",
	Leave = "Feedback_OnLeave",
	Down = "Feedback_OnDown",
	Up = "Feedback_OnUp",
}

--- [EventType] = name
Data.Events_Window = {
	Open = "OnOpen",
	Close = "OnClose",
	Change = "OnChangeState",
}

Data.Config_Window = {
	Open = "Feedback_OnOpen",
	Close = "Feedback_OnClose",
}

Data.Events_Trigger = {
	TriggerEnter = "OnTriggerEnter",
	TriggerExit = "OnTriggerExit",
}

return Data
