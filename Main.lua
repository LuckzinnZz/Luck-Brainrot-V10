
local base = "https://raw.githubusercontent.com/LuckzinnZz/Luck-Brainrot-V10/main/"

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local env = (type(getgenv) == "function" and getgenv()) or _G

if env.LuckBrainrotV11Stop then
    pcall(env.LuckBrainrotV11Stop)
end

local function loadModule(name)
    local source = game:HttpGet(base .. name)
    local fn, err = loadstring(source)
    assert(fn, err)
    return fn()
end

local Brainrot = loadModule("Brainrot.lua")
local ui = loadModule("UI.lua").create()

local running = true
local enabled = false
local target = nil
local prompt = nil
local distance = nil
local connections = {}
local statusUntil = 0

local function showStatus(message, seconds)
    ui.status.Text = message
    statusUntil = os.clock() + (seconds or 3)
end

local function getPromptState(grab)
    if not grab then
        return "Grab nao encontrado"
    end

    if not grab:IsA("ProximityPrompt") then
        return "Interacao invalida"
    end

    if not grab.Enabled then
        return "Grab desativado"
    end

    return "Grab disponivel"
end

table.insert(connections,
    ui.toggle.MouseButton1Click:Connect(function()
        enabled = not enabled

        ui.toggle.Text = enabled
            and "DETECTAR: ON"
            or "DETECTAR: OFF"

        if not enabled then
            target = nil
            prompt = nil
            ui.action.Visible = false
            showStatus("Detector desligado", 2)
        else
            showStatus("Procurando Brainrots...", 1)
        end
    end)
)

table.insert(connections,
    ui.action.MouseButton1Click:Connect(function()
        if not enabled then
            showStatus("Ative o detector primeiro")
            return
        end

        if not target or not target.Parent then
            showStatus("Nenhum Brainrot selecionado")
            return
        end

        if not prompt then
            showStatus(
                "STEAL indisponivel:\nGrab nao encontrado",
                4
            )
            return
        end

        if not prompt.Enabled then
            showStatus(
                "STEAL bloqueado:\nGrab desativado pelo jogo",
                4
            )
            return
        end

        local root = player.Character
            and player.Character:FindFirstChild("HumanoidRootPart")

        local part = prompt.Parent

        if not root or not part then
            showStatus("Personagem ou interacao indisponivel")
            return
        end

        local position

        if part:IsA("BasePart") then
            position = part.Position
        elseif part:IsA("Attachment") then
            position = part.WorldPosition
        end

        if not position then
            showStatus("Posicao do Grab desconhecida")
            return
        end

        local actualDistance =
            (root.Position - position).Magnitude

        if actualDistance > prompt.MaxActivationDistance then
            showStatus(
                "Aproxime-se para usar o Grab.\nDistancia: "
                .. math.floor(actualDistance),
                4
            )
            return
        end

        showStatus(
            "Grab disponivel!\nUse a interacao original do jogo.",
            4
        )
    end)
)

task.spawn(function()
    while running do
        if enabled then
            local model, owner, dist, grab =
                Brainrot.nearest(14)

            target = model
            prompt = grab
            distance = dist

            ui.action.Visible = model ~= nil

            if model and os.clock() >= statusUntil then
                ui.status.Text = string.format(
                    "Brainrot: %s\nDono: %s\nDistancia: %.1f\n%s",
                    model.Name,
                    tostring(owner),
                    dist or 0,
                    getPromptState(grab)
                )
            elseif not model and os.clock() >= statusUntil then
                ui.status.Text =
                    "Nenhum Brainrot proximo de outra base"
            end
        end

        task.wait(0.3)
    end
end)

env.LuckBrainrotV11Stop = function()
    running = false

    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end

    ui.cleanup()
    env.LuckBrainrotV11Stop = nil
end

print("[LUCK V11.1] Detector e verificacao STEAL carregados")
