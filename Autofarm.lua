local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ClientMonsters = workspace:WaitForChild("ClientMonsters")

local player = Players.LocalPlayer
local velocidade = 50 -- Ajuste a velocidade aqui (maior = mais rápido)

local function getTweenTime(distancia)
    return distancia / velocidade
end

local function irAteOMonstro()
    while true do
        -- Busca o primeiro monstro disponível na pasta
        local monstro = ClientMonsters:FindFirstChildOfClass("Model") or ClientMonsters:FindFirstChildOfClass("Part")

        if monstro then
            local rootPart = monstro:FindFirstChild("HumanoidRootPart") or monstro.PrimaryPart or monstro:FindFirstChildOfClass("Part")
            local myRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

            if rootPart and myRoot then
                -- Calcula distância e tempo
                local distancia = (myRoot.Position - rootPart.Position).Magnitude
                local info = TweenInfo.new(getTweenTime(distancia), Enum.EasingStyle.Linear)
                
                -- Cria e executa o movimento
                local tween = TweenService:Create(myRoot, info, {CFrame = rootPart.CFrame * CFrame.new(0, 0, 3)})
                tween:Play()

                -- Espera o monstro morrer/sumir ou o tween acabar
                repeat 
                    task.wait(0.1) 
                until not monstro:IsDescendantOf(ClientMonsters) or not monstro.Parent
                
                tween:Cancel() -- Para o movimento se o monstro sumir antes de chegar
                print("Monstro derrotado ou sumiu, buscando próximo...")
            end
        else
            -- Se não houver monstro, espera um pouco antes de checar de novo
            task.wait(1)
        end
    end
end

-- Inicia o loop em uma thread separada
task.spawn(irAteOMonstro)

print("🚀 Script de Auto-Tween ativado!")
