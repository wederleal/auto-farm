local Players = game:GetService("Players")
local vim = game:GetService("VirtualInputManager")
local lp = Players.LocalPlayer
local pasta = workspace:WaitForChild("ClientMonsters")

-- Configurações
local velocidade = 90 
local distanciaDeAtaque = 5

print("🏇 Script de Montaria e Perseguição Ativado!")

local function pressM()
    vim:SendKeyEvent(true, Enum.KeyCode.M, false, game)
    task.wait(0.1)
    vim:SendKeyEvent(false, Enum.KeyCode.M, false, game)
end

local function getRoot(char)
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
end

task.spawn(function()
    while task.wait() do
        local monstro = pasta:FindFirstChildOfClass("Model") or pasta:FindFirstChildOfClass("Part")
        
        if monstro then
            local targetPart = monstro:FindFirstChild("HumanoidRootPart") or monstro:FindFirstChildOfClass("Part")
            local char = lp.Character
            local root = char and getRoot(char)
            
            if root and targetPart then
                -- 1. ACABOU DE SPAWNAR/MUDAR: Monta para viajar rápido e trazer pets
                print("🐎 Subindo na montaria...")
                pressM()
                
                -- 2. Perseguição até o monstro
                while monstro and monstro.Parent == pasta and targetPart.Parent do
                    local distancia = (root.Position - targetPart.Position).Magnitude
                    
                    if distancia > distanciaDeAtaque then
                        root.Velocity = Vector3.new(0,0,0)
                        root.CFrame = CFrame.new(root.Position + (targetPart.Position - root.Position).Unit * (velocidade * task.wait()), targetPart.Position)
                    else
                        -- 3. CHEGOU NO MONSTRO: Desce da montaria para os pets aparecerem
                        print("⚔️ Chegou! Descendo para atacar...")
                        pressM()
                        
                        -- Fica parado no monstro até ele morrer
                        repeat
                            root.CFrame = targetPart.CFrame * CFrame.new(0, 4, 0)
                            game:GetService("VirtualUser"):ClickButton1(Vector2.new(0,0))
                            task.wait(0.1)
                        until not monstro or not monstro.Parent or not targetPart.Parent
                        
                        break -- Sai do loop de perseguição para buscar o próximo
                    end
                    task.wait()
                end
            end
        end
    end
end)
