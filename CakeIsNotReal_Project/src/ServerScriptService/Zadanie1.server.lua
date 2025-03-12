--[[ local counters = {}

local textLabel = workspace.zadanie1.SurfaceGui.Frame.TextLabel2

workspace.zadanie1.platform.Touched:Connect(function(hit)
	local plr = game.Players:GetPlayerFromCharacter(hit.Parent)
	if plr then
		if counters[plr] then
			counters[plr] = counters[plr] + 1
			textLabel.Text = "touches: " .. counters[plr]
		else
			counters[plr] = 1
		end
		
	end
end) *]]

--[[
ТЗ
1)[легко] мы хотим чтобы счетчик увеличивался каждый раз когда игрок заходит на плиту, и пока он там ходит счетчик увеличиваться не должен
2)[сложно]мы хотим чтобы если игрок 2 секунды стоит на платформе его телепортировало на SpawnLocation
3)[невозможно] мы хотим чтобы каждый 5 раз когда игрока телепортирует на SpawnLocation его не телепортировало а убивало
]]--