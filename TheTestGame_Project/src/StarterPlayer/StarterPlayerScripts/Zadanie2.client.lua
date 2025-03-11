


--[[ local plr = game.Players.LocalPlayer
local button = plr.PlayerGui:WaitForChild("Zadanie2").Frame.TextButton -- Infinite wait breaks some events
local label = plr.PlayerGui.Zadanie2.Frame.TextLabel
local counter = 0
button.Activated:Connect(function()
	counter += 1
	label.Text = "presses: "..counter
end) *]]

--[[
ТЗ
1)[легко] мы хотим чтобы гуй задание 2 выглядел хоть както красиво(задание на творчество)
2)[сложно] мы хотим, чтобы каждое 20 нажатие убивало нажимающего (серверно)
3)[невозможно] мы хотим чтобы при перезаходе в игру, значение продолжало с того же значения
]]--