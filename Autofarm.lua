local Players = game:GetService("Players")
local ClientMonsters = workspace:GetService("Workspace"):WaitForChild("ClientMonsters")

local player = Players.LocalPlayer
local velocidade = 70 -- Aumentei para 70 para ser mais eficiente
local distanciaDeParada = 3 -- Distância para os pets atacarem

local function irAteOMonstro()
    while true do
        -- Busca o monstro mais próximo ou o primeiro da lista
        local monstro = ClientMonsters:FindFirstChildOfClass("Model") or ClientMonsters:FindFirstChildOfClass("Part")

        if monstro then
            local rootPart = monstro:FindFirstChild("HumanoidRootPart") or monstro.PrimaryPart or monstro:FindFirstChildOfClass("Part")
            
            -- Loop de perseguição enquanto o monstro existir na pasta
            while monstro and monstro.Parent == ClientMonsters do
                local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not myRoot or not rootPart then break end

                local alvoPos = rootPart.Position
                local minhaPos = myRoot.Position
                local direcao = (alvoPos - minhaPos)
                local distancia = direcao.Magnitude

                -- Se ainda estiver longe, continua movendo
                if distancia > distanciaDeParada then
                    -- Move o CFrame suavemente na direção do monstro
                    myRoot.CFrame = CFrame.new(minhaPos + (direcao.Unit * (velocidade * task.wait())), alvoPos)
                else
                    -- Se chegou perto, apenas encara o monstro e espera ele morrer
                    myRoot.CFrame = CFrame.new(minhaPos, alvoPos)
                    task.wait() 
                end
                
                -- Se o monstro sumir durante o trajeto, sai deste loop interno
                if not monstro:IsDescendantOf(ClientMonsters) then break end
            end
            print("🎯 Alvo eliminado ou sumiu, procurando próximo...")
        else
            task.wait(0.5) -- Espera rápida se a pasta estiver vazia
        end
    end
end

-- Inicia a perseguição
task.spawn(irAteOMonstro)

print("🚀 Perseguição em Tempo Real Ativada!")
