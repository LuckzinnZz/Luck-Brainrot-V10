
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local M = {}

local function ownerName(base)
    local config = base:FindFirstChild("Configuration")
    local owner = config and config:FindFirstChild("Player")

    if owner and owner:IsA("ValueBase") then
        return tostring(owner.Value)
    end

    return ""
end

local function findGrab(model)
    for _, object in ipairs(model:GetDescendants()) do
        if object:IsA("ProximityPrompt")
            and string.lower(object.ActionText):find(
                "grab", 1, true
            ) then
            return object
        end
    end

    return nil
end

function M.nearest(radius)
    local root = player.Character
        and player.Character:FindFirstChild("HumanoidRootPart")

    local map = workspace:FindFirstChild("Map")
    local bases = map and map:FindFirstChild("Bases")

    if not root or not bases then
        return nil
    end

    local best = nil
    local bestOwner = nil
    local bestDist = radius or 14
    local bestGrab = nil

    for _, base in ipairs(bases:GetChildren()) do
        local owner = ownerName(base)

        if owner ~= ""
            and owner ~= player.Name
            and owner ~= player.DisplayName
            and owner ~= tostring(player.UserId) then

            local slots = base:FindFirstChild("Slots")

            if slots then
                for _, slot in ipairs(slots:GetChildren()) do
                    for _, model in ipairs(slot:GetChildren()) do
                        if model:IsA("Model") then
                            local ok, pivot = pcall(function()
                                return model:GetPivot()
                            end)

                            if ok then
                                local dist =
                                    (root.Position - pivot.Position).Magnitude

                                if dist < bestDist then
                                    best = model
                                    bestOwner = owner
                                    bestDist = dist
                                    bestGrab = findGrab(model)
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return best, bestOwner, bestDist, bestGrab
end

return M
