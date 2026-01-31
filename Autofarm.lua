print("AUTO FARM LOADSTRING INICIADO")

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
if not player then return end

local character = player.Character or player.CharacterAdded:Wait()
local hrp = character:WaitForChild("HumanoidRootPart")

local monsterFolder
repeat
    monsterFolder = Workspace:FindFirstChild("ClientMonsters")
    task.wait(1)
until monsterFolder

print("ClientMonsters encontrado")

local SPEED = 100

local function getMonsterPart(monster)
    if monster:IsA("Model") then
        return monster:FindFirstChildWhichIsA("BasePart", true)
    elseif monster:IsA("BasePart") then
        return monster
    end
end

local function getClosestMonster()
    local closest = nil
    local shortest = math.huge

    for _, monster in ipairs(monsterFolder:GetChildren()) do
        local part = getMonsterPart(monster)
        if part then
            local dist = (hrp.Position - part.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = monster
            end
        end
    end

    return closest
end

local function tweenToMonster(monster)
    local part = getMonsterPart(monster)
    if not part then return end

    local distance = (hrp.Position - part.Position).Magnitude
    local time = distance / SPEED

    print("Indo para:", monster.Name)

    local tween = TweenService:Create(
        hrp,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        { CFrame = part.CFrame }
    )

    tween:Play()
    tween.Completed:Wait()
end

while task.wait(0.5) do
    local monster = getClosestMonster()
    if monster then
        tweenToMonster(monster)
        while monster.Parent do
            task.wait(0.1)
        end
    end
end
