print("AUTO REJOIN PRIVATE SERVER - INICIADO")

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local PLACE_ID = game.PlaceId

-- CAPTURA O ACCESS CODE DO TELEPORT DATA
local teleportData = TeleportService:GetLocalPlayerTeleportData()
local ACCESS_CODE = nil

if teleportData then
    ACCESS_CODE = teleportData.PrivateServerId or teleportData.accessCode
end

if not ACCESS_CODE then
    warn("ACCESS CODE NÃO ENCONTRADO! Entre pelo link do servidor privado primeiro.")
    return
end

print("AccessCode capturado:", ACCESS_CODE)

local function rejoin()
    task.wait(2)
    print("Reentrando no servidor privado...")
    TeleportService:TeleportToPrivateServer(
        PLACE_ID,
        ACCESS_CODE,
        { player }
    )
end

-- SE TELEPORT FALHAR
player.OnTeleport:Connect(function(state)
    if state == Enum.TeleportState.Failed then
        rejoin()
    end
end)

-- SE DER ERRO / DESCONECTAR
GuiService.ErrorMessageChanged:Connect(function()
    rejoin()
end)
