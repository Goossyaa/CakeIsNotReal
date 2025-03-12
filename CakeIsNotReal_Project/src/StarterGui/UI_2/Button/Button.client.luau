--!strict
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local button = script.Parent
local remoteEvent = ReplicatedStorage:WaitForChild("ButtonAdd_OnClick")
local localPlayer = Players.LocalPlayer

button.MouseButton1Click:Connect(function()
    remoteEvent:FireServer(localPlayer)
end)