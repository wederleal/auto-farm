local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local ClientMonsters = workspace:WaitForChild("ClientMonsters")

-- tolerância para comparação de size (IMPORTANTÍSSIMO)
local TOLERANCE = 0.1

local TARGET_SIZE = Vector3.new(
    3.758700370788574,
    4.6298980712890625,
    4.722216606140137
)

local function sizeEquals(a, b)
    return math.abs(a.X - b.X) <= TOLERANCE
       and math.abs(a.Y - b.Y) <= TOLERANCE
       and math.abs(a.Z - b.Z) <= TOLERANCE
end

-- encontra o monstro mais próximo com esse size
local function findNearestMonster()
    local closestMonster = nil
    local shortestDistance = math.huge

    for _, monster in ipairs(ClientMonsters:GetChildren()) do
        if monster:IsA("Model") then
            local cf, size = monster:GetBoundingBox()

            if sizeEquals(size, TARGET_SIZE) then
                local distance = (hrp.Position - cf.Position).Magnitude

                if distance < shortestDistance then
                    shortestDistance = distance
                    closestMonster = monster
                end
            end
        end
    end

    return closestMonster
end

-- tween até o monstro
local function tweenToMonster(monster)
    local cf, _ = monster:GetBoundingBox()
    local targetPosition = cf.Position + Vector3.new(0, 0, -3)

    local distance = (hrp.Position - targetPosition).Magnitude
    local time = distance / 60 -- velocidade ajustável

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(targetPosition)}
    )

    tween:Play()
end

-- execução
local monster = findNearestMonster()

if monster then
    print("✅ Monstro encontrado:", monster.Name)
    tweenToMonster(monster)
else
    print("❌ Nenhum monstro com esse size encontrado")
end
