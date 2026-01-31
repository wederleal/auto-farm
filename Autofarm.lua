-- ===============================
-- AUTO UNDINE FIND + TWEEN
-- ===============================

print("🔥 Autofarm Undine iniciado")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

-- pasta correta dos monstros (onde você confirmou)
local Monsters = workspace:WaitForChild("Monsters")

-- ===============================
-- IDENTIFICAÇÃO DO UNDINE (POR FAIXA)
-- ===============================
local function isUndine(monster)
    if not monster:IsA("Model") then return false end

    local success, cf, size = pcall(function()
        local c, s = monster:GetBoundingBox()
        return true, c, s
    end)

    if not success then return false end

    return
        size.X > 3.0 and size.X < 3.5 and
        size.Y > 9.2 and size.Y < 9.8 and
        size.Z > 10.2 and size.Z < 10.8
end

-- ===============================
-- TWEEN ATÉ O UNDINE
-- ===============================
local function tweenToUndine(monster)
    local cf, _ = monster:GetBoundingBox()
    local targetPos = cf.Position + Vector3.new(0, 0, -6)

    local distance = (hrp.Position - targetPos).Magnitude
    local time = distance / 70

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(targetPos)}
    )

    tween:Play()
end

-- ===============================
-- PROCURA UNDINE JÁ SPAWNADO
-- ===============================
local function findExistingUndine()
    for _, monster in ipairs(Monsters:GetChildren()) do
        if isUndine(monster) then
            print("🔥 UNDINE ENCONTRADO:", monster.Name)
            tweenToUndine(monster)
            return true
        end
    end
    return false
end

-- tenta achar imediatamente
if not findExistingUndine() then
    print("⏳ Undine não está no mapa, aguardando spawn...")
end

-- ===============================
-- DETECTA QUANDO O UNDINE SPAWNAR
-- ===============================
Monsters.ChildAdded:Connect(function(monster)
    task.wait(0.4) -- deixa estabilizar o BoundingBox

    if isUndine(monster) then
        print("🔥 UNDINE SPAWNOU:", monster.Name)
        tweenToUndine(monster)
    end
end)
