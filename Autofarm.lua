local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local v3 = Vector3.new

-- Configurações
local velocidade = 80 -- Aumente se quiser ir mais rápido
local pasta = workspace:WaitForChild("ClientMonsters")

print("🔥 Script de Auto-Farm Total Iniciado")

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
end

task.spawn(function()
    while task.wait() do
        -- 1. Tenta achar qualquer monstro na pasta
        local monstro = pasta:FindFirstChildOfClass("Model") or pasta:FindFirstChildOfClass("Part")
        
        if monstro then
            local targetPart = monstro:FindFirstChild("HumanoidRootPart") or monstro:FindFirstChildOfClass("Part")
            local char = lp.Character
            local root = char and getRoot(char)
            
            if root and targetPart then
                -- 2. Enquanto o monstro existir, ele vai te levar até ele
                while monstro and monstro.Parent == pasta and targetPart.Parent do
                    local distancia = (root.Position - targetPart.Position).Magnitude
                    
                    -- Se estiver longe, move suavemente
                    if distancia > 4 then
                        root.Velocity = v3(0,0,0) -- Evita gravidade atrapalhar
                        root.CFrame = CFrame.new(root.Position + (targetPart.Position - root.Position).Unit * (velocidade * task.wait()), targetPart.Position)
                    else
                        -- Se chegou perto, fica em cima dele para os pets atacarem
                        root.CFrame = targetPart.CFrame * CFrame.new(0, 5, 0)
                        
                        -- Simula um clique para ativar os pets/ataque
                        game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                    end
                    task.wait()
                end
            end
        end
    end
end)
