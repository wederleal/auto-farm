print("AUTO PETS FOLLOW OVERRIDE INICIADO")

local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local PET_FOLDER = Workspace:WaitForChild("ClientPets")
local MONSTER_FOLDER = Workspace:WaitForChild("ClientMonsters")

local ATTACK_OFFSET = 5

-- pega qualquer BasePart (inclusive dentro de Model)
local function getAnyPart(obj)
    if obj:IsA("BasePart") then
        return obj
    end
    for _, v in ipairs(obj:GetDescendants()) do
        if v:IsA("BasePart") then
            return v
        end
    end
end

-- monster mais próximo de uma posição
local function getClosestMonster(pos)
    local closest, shortest = nil, math.huge

    for _, monster in ipairs(MONSTER_FOLDER:GetChildren()) do
        local part = getAnyPart(monster)
        if part then
            local dist = (pos - part.Position).Magnitude
            if dist < shortest then
                shortest = dist
                closest = monster
            end
        end
    end

    return closest
end

-- LOOP EM ALTA FREQUÊNCIA (vence o follow)
RunService.Heartbeat:Connect(function()
    for _, pet in ipairs(PET_FOLDER:GetChildren()) do
        local petPart = getAnyPart(pet)
        if not petPart then continue end

        local monster = getClosestMonster(petPart.Position)
        if not monster then continue end

        local monsterPart = getAnyPart(monster)
        if not monsterPart then continue end

        petPart.CFrame = monsterPart.CFrame * CFrame.new(0, 0, -ATTACK_OFFSET)
    end
end)
