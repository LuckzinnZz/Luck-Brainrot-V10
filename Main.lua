
local base = "https://raw.githubusercontent.com/LuckzinnZz/Luck-Brainrot-V10/main/"
local env = (type(getgenv) == "function" and getgenv()) or _G

if env.LuckBrainrotV11Stop then
    pcall(env.LuckBrainrotV11Stop)
end

if env.LuckBrainrotV12Stop then
    pcall(env.LuckBrainrotV12Stop)
end

local function module(name)
    local source = game:HttpGet(base .. name)
    local fn, err = loadstring(source)
    assert(fn, err)
    return fn()
end

local Brainrot = module("Brainrot.lua")
local ui = module("UI.lua").create()

local running = true
local enabled = false
local target = nil
local prompt = nil
local connections = {}
local statusUntil = 0

local function message(text, seconds)
    ui.status.Text = text
    statusUntil = os.clock() + (seconds or 4)
end

connections[#connections + 1] =
    ui.toggle.MouseButton1Click:Connect(function()
        enabled = not enabled

        ui.toggle.Text = enabled
            and "DETECTAR: ON"
            or "DETECTAR: OFF"

        if not enabled then
            target = nil
            prompt = nil
            ui.action.Visible = false
            message("Detector desligado", 1)
        else
            message("Procurando Brainrots...", 1)
        end
    end)

connections[#connections + 1] =
    ui.action.MouseButton1Click:Connect(function()
        if not enabled or not target or not target.Parent then
            message("Nenhum Brainrot selecionado")
            return
        end

        if not prompt or not prompt.Parent then
            message("STEAL: Grab nao encontrado neste Brainrot")
        elseif not prompt.Enabled then
            message("STEAL indisponivel: Grab desativado pelo jogo")
        else
            message("Grab disponivel. Use a interacao original do jogo.")
        end
    end)

task.spawn(function()
    while running do
        if enabled then
            local model, owner, dist, grab =
                Brainrot.nearest(14)

            target = model
            prompt = grab
            ui.action.Visible = model ~= nil

            if os.clock() >= statusUntil then
                if model then
                    ui.status.Text = string.format(
                        "Brainrot: %s\nDono: %s\nDistancia: %.1f\nGrab: %s",
                        model.Name,
                        tostring(owner),
                        dist or 0,
                        grab and tostring(grab.Enabled) or "ausente"
                    )
                else
                    ui.status.Text = "Aproxime-se de outra base."
                end
            end
        end

        task.wait(0.3)
    end
end)

env.LuckBrainrotV12Stop = function()
    running = false

    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end

    ui.cleanup()
    env.LuckBrainrotV12Stop = nil
end

print("[LUCK V12] Painel e detector carregados; nao transfere propriedade.")
