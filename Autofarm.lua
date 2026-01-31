local ClientMonsters = workspace:GetService("Workspace"):WaitForChild("ClientMonsters")
local nomeAlvo = "Undine"

print("🔍 Script de detecção iniciado...")

local function destacarMonstro(modelo)
    -- Cria um brilho ao redor do monstro para você ver através das paredes
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.fromRGB(255, 0, 0) -- Vermelho
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.Parent = modelo
    print("🎯 UNDINE DETECTADA: " .. modelo.Name)
end

local function checarTudo(objeto)
    -- 1. Checa o nome do próprio objeto
    if string.find(objeto.Name, nomeAlvo) then
        destacarMonstro(objeto)
        return
    end

    -- 2. Procura dentro de tudo (Humanoid, Labels, Partes)
    for _, descendente in ipairs(objeto:GetDescendants()) do
        if descendente:IsA("Humanoid") and descendente.DisplayName == nomeAlvo then
            destacarMonstro(objeto)
            break
        elseif descendente:IsA("TextLabel") and descendente.Text == nomeAlvo then
            destacarMonstro(objeto)
            break
        end
    end
end

-- Monitorar novos monstros
ClientMonsters.ChildAdded:Connect(function(child)
    -- Pequeno delay porque o Roblox as vezes spawna o modelo vazio e carrega os filhos depois
    task.wait(0.5)
    checarTudo(child)
end)

-- Checar quem já está lá
for _, atual in ipairs(ClientMonsters:GetChildren()) do
    checarTudo(atual)
end
