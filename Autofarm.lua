local ClientMonsters = workspace:WaitForChild("ClientMonsters")
local nomeAlvo = "Undine"

local function verificarSeEhUndine(objeto)
    -- Espera um pouco para garantir que as propriedades internas carregaram
    local humanoid = objeto:WaitForChild("Humanoid", 2)
    
    if humanoid then
        -- Verifica o DisplayName (o nome que aparece no jogo)
        if humanoid.DisplayName == nomeAlvo then
            print("🚨 A Undine apareceu! Identificada como: " .. objeto.Name)
            return true
        end
    end
    
    -- Caso o nome esteja em um BillboardGui (outro método comum)
    local billboard = objeto:FindFirstChildOfClass("BillboardGui", true)
    if billboard then
        local textLabel = billboard:FindFirstChildOfClass("TextLabel", true)
        if textLabel and textLabel.Text == nomeAlvo then
            print("🚨 A Undine apareceu (detectada via BillboardGui)!")
            return true
        end
    end
end

-- Monitora novos monstros na pasta
ClientMonsters.ChildAdded:Connect(function(child)
    -- Primeiro filtramos se é um "Monster_..."
    if string.find(child.Name, "Monster_") then
        verificarSeEhUndine(child)
    end
end)

-- Verifica se ela já está lá quando o script inicia
for _, atual in ipairs(ClientMonsters:GetChildren()) do
    if string.find(atual.Name, "Monster_") then
        verificarSeEhUndine(atual)
    end
end
