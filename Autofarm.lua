print("AUTO FARM - TideVex INICIADO")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local ClientMonsters = workspace:WaitForChild("ClientMonsters")

-- CONFIG
local TARGET_NAME = "TideVex"
local TWEEN_SPEED = 120 -- quanto maior, mais rápido

-- pega o nome visível (BillboardGui)
local function getVisibleMonsterName(monster)
    local gui = monster:FindFirstChildWhichIsA("BillboardGui", true)
    if gui then
        local label = gui:FindFirstChildWhichIsA("TextLabel", true)
        if label and label.Text ~= "" then
            return label.Text
        end
    end
    return nil
end

-- verifica se o monster está vivo
local function isAlive(monster)
    local hum = monster:FindFirstChildOfClass("Humanoid")
    return hum and hum.Health > 0
end

-- pega a posição do monster
local function getRoot(monster)
    return monster:FindFirstChild("HumanoidRootPart")
        or monster.PrimaryPart
end

-- encontra o TideVex mais próximo
local function getNearestTideVex()
    local closest, closestDist = nil, math.huge

    for _, monster in ipairs(ClientMonsters:GetChildren()) do
        if monster:IsA("Model") then
            local name = getVisibleMonsterName(monster)
            if name == TARGET_NAME and isAlive(monster) then
                local root = getRoot(monster)
                if root then
                    local dist = (hrp.Position - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closest = monster
                    end
                end
            end
        end
    end

    return closest
end

-- move até o monster com Tween
local function tweenTo(cf)
    local distance = (hrp.Position - cf.Position).Magnitude
    local time = distance / TWEEN_SPEED

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        { CFrame = cf }
    )
    tween:Play()
    tween.Completed:Wait()
end

-- LOOP PRINCIPAL
task.spawn(function()
    while task.wait(0.5) do
        local target = getNearestTideVex()
        if target then
            local root = getRoot(target)
            if root then
                tweenTo(root.CFrame * CFrame.new(0, 0, -4)) -- para um pouco atrás
                -- aqui seus PETS atacam automaticamente
                repeat task.wait(0.3) until not isAlive(target)
            end
        end
    end
end)
