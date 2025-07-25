local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

local TARGET_PLACE_ID = 96342491571673

local function JoinPlace()
    local success, errorMsg = pcall(function()
        TeleportService:Teleport(TARGET_PLACE_ID, game.Players.LocalPlayer)
    end)
    if not success then
        warn("Failed to teleport: " .. tostring(errorMsg))
    end
end

JoinPlace()
