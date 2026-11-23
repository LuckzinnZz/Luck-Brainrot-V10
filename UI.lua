
local M = {}

function M.create()
    local player = game:GetService("Players").LocalPlayer
    local old = player.PlayerGui:FindFirstChild("LuckBrainrotV12")

    if old then
        old:Destroy()
    end

    local gui = Instance.new("ScreenGui")
    gui.Name = "LuckBrainrotV12"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 400
    gui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.fromOffset(290, 190)
    frame.Position = UDim2.new(.5, -145, .2, 0)
    frame.BackgroundColor3 = Color3.fromRGB(12, 31, 20)
    frame.Active = true
    frame.Parent = gui

    Instance.new("UICorner", frame).CornerRadius =
        UDim.new(0, 12)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(65, 255, 125)
    stroke.Thickness = 2

    local function make(text, y, height, clickable)
        local obj = Instance.new(
            clickable and "TextButton" or "TextLabel"
        )

        obj.Size = UDim2.new(1, -20, 0, height)
        obj.Position = UDim2.fromOffset(10, y)
        obj.BackgroundTransparency = clickable and 0 or 1
        obj.BackgroundColor3 = Color3.fromRGB(25, 125, 65)
        obj.TextColor3 = Color3.fromRGB(235, 255, 235)
        obj.Font = Enum.Font.GothamBold
        obj.TextSize = clickable and 16 or 13
        obj.TextWrapped = true
        obj.Text = text
        obj.Parent = frame

        if clickable then
            Instance.new("UICorner", obj).CornerRadius =
                UDim.new(0, 8)
        end

        return obj
    end

    local title = make("LUCK BRAINROT V12", 5, 32, false)
    local toggle = make("DETECTAR: OFF", 42, 40, true)
    local status = make("Aguardando ativacao...", 88, 92, false)

    local action = Instance.new("TextButton")
    action.Size = UDim2.fromOffset(190, 48)
    action.AnchorPoint = Vector2.new(.5, 1)
    action.Position = UDim2.new(.5, 0, .87, 0)
    action.BackgroundColor3 = Color3.fromRGB(25, 175, 75)
    action.Text = "STEAL"
    action.TextColor3 = Color3.new(1, 1, 1)
    action.Font = Enum.Font.GothamBlack
    action.TextSize = 18
    action.Visible = false
    action.Parent = gui

    Instance.new("UICorner", action).CornerRadius =
        UDim.new(0, 10)

    local UIS = game:GetService("UserInputService")
    local dragging = false
    local active = nil
    local startInput = nil
    local startPos = nil

    local c1 = title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            active = input
            startInput = input.Position
            startPos = frame.Position
        end
    end)

    local c2 = UIS.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input == active or (
            active
            and active.UserInputType == Enum.UserInputType.MouseButton1
            and input.UserInputType == Enum.UserInputType.MouseMovement
        ) then
            local delta = input.Position - startInput

            frame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)

    local c3 = UIS.InputEnded:Connect(function(input)
        if input == active then
            dragging = false
            active = nil
        end
    end)

    return {
        toggle = toggle,
        status = status,
        action = action,

        cleanup = function()
            c1:Disconnect()
            c2:Disconnect()
            c3:Disconnect()
            gui:Destroy()
        end
    }
end

return M
