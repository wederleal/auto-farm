print("AUTO REJOIN PRIVATE SERVER - INICIADO")

local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local PLACE_ID = game.PlaceId

-- CAPTURA DADOS DE ENTRADA
local joinData = player:GetJoinData()
local teleportData = joinData and joinData.TeleportData

local ACCESS_CODE = nil

if teleportData then
    ACCESS_CODE = teleportData.PrivateServerId
end

if not ACCESS_CODE then
    warn("ACCESS CODE NÃO ENCONTRADO.")
    warn("Entre pelo link do servidor privado e execute o script APÓS carregar o jogo.")
    return
end

print("AccessCode capturado com sucesso:", ACCESS_CODE)

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

-- SE DESCONECTAR / ERRO
GuiService.ErrorMessageChanged:Connect(function()
    rejoin()
end)
