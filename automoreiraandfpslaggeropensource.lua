-- === MOREIRA TOOLS: FPS LAGGER + AUTO MOREIRA (ОТДЕЛЬНО!) ===

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Player = LocalPlayer
local Backpack = Player:WaitForChild("Backpack")

-- === [1] МЕНЮ С ДВУМЯ КНОПКАМИ ===
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MoreiraMenu"
ScreenGui.Parent = Player.PlayerGui

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 240, 0, 140)
Frame.Position = UDim2.new(0, 10, 0, 10)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.1
Frame.BorderSizePixel = 0
Frame.Parent = ScreenGui
Frame.Visible = true

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 30)
Title.BackgroundTransparency = 1
Title.Text = "Moreira Tools"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.SourceSansBold
Title.Parent = Frame

-- Кнопка 1: FPS Lagger
local FpsButton = Instance.new("TextButton")
FpsButton.Size = UDim2.new(1, -20, 0, 35)
FpsButton.Position = UDim2.new(0, 10, 0, 35)
FpsButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
FpsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FpsButton.Text = "FPS Lagger: OFF"
FpsButton.Font = Enum.Font.SourceSansBold
FpsButton.Parent = Frame

local FpsIndicator = Instance.new("Frame")
FpsIndicator.Size = UDim2.new(0, 10, 0, 10)
FpsIndicator.Position = UDim2.new(0, 5, 0, 5)
FpsIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
FpsIndicator.Parent = FpsButton

-- Кнопка 2: Auto Moreira (ТОЛЬКО Anti-Lag)
local AutoButton = Instance.new("TextButton")
AutoButton.Size = UDim2.new(1, -20, 0, 35)
AutoButton.Position = UDim2.new(0, 10, 0, 75)
AutoButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
AutoButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AutoButton.Text = "Auto Moreira: OFF"
AutoButton.Font = Enum.Font.SourceSansBold
AutoButton.Parent = Frame

local AutoIndicator = Instance.new("Frame")
AutoIndicator.Size = UDim2.new(0, 10, 0, 10)
AutoIndicator.Position = UDim2.new(0, 5, 0, 5)
AutoIndicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AutoIndicator.Parent = AutoButton

-- === Перетаскивание ===
local isDragging = false
local dragStart, startPos
local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

Frame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = Frame.Position
    end
end)

Frame.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local newPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(Frame, tweenInfo, {Position = newPos}):Play()
    end
end)

Frame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- === Клавиша M — скрыть/показать ===
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.M then
        Frame.Visible = not Frame.Visible
    end
end)

-- === [2] ФУНКЦИЯ: FPS LAGGER (ТОЛЬКО ЛАГ) ===
local isFpsLagging = false
local switchDelay = 0.04

local function FpsLaggerToggle()
    isFpsLagging = not isFpsLagging
    FpsIndicator.BackgroundColor3 = isFpsLagging and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    FpsButton.Text = isFpsLagging and "FPS Lagger: ON" or "FPS Lagger: OFF"

    if isFpsLagging then
        spawn(function()
            while isFpsLagging do
                if not Player.Character or not Player.Character:FindFirstChild("Humanoid") or Player.Character.Humanoid.Health <= 0 then
                    task.wait(0.1)
                    continue
                end

                local humanoid = Player.Character.Humanoid
                for _, tool in pairs(Backpack:GetChildren()) do
                    if not isFpsLagging then break end
                    if tool:IsA("Tool") and tool.Parent == Backpack then
                        humanoid:EquipTool(tool)
                        task.wait(switchDelay)
                        humanoid:UnequipTools()
                        task.wait(switchDelay)
                    end
                end
                task.wait(0.01)
            end
        end)
    end
end

FpsButton.MouseButton1Click:Connect(FpsLaggerToggle)

-- === [3] ФУНКЦИЯ: Auto Moreira (ТОЛЬКО ANTI-LAG) ===
local isAutoMoreira = false

local function applyAntiLag()
    for _, player in pairs(Players:GetPlayers()) do
        if player.Character then
            for _, child in pairs(player.Character:GetChildren()) do
                if child:IsA("Accessory") or child:IsA("ShirtGraphic") or 
                   child:IsA("Shirt") or child:IsA("Pants") or 
                   child:IsA("CharacterMesh") or child:IsA("SpecialMesh") then
                    child:Destroy()
                end
            end
            if player.Character:FindFirstChild("Head") then
                for _, effect in pairs(player.Character.Head:GetChildren()) do
                    if effect:IsA("ParticleEmitter") or effect:IsA("Trail") then
                        effect:Destroy()
                    end
                end
            end
        end
    end
end

local function AutoMoreiraToggle()
    isAutoMoreira = not isAutoMoreira
    AutoIndicator.BackgroundColor3 = isAutoMoreira and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    AutoButton.Text = isAutoMoreira and "Auto Moreira: ON" or "Auto Moreira: OFF"

    if isAutoMoreira then
        -- Запуск Anti-Lag сразу
        applyAntiLag()

        -- При спавне новых игроков
        Players.PlayerAdded:Connect(function(player)
            player.CharacterAdded:Connect(applyAntiLag)
        end)

        -- Каждые 5 секунд — проверка
        task.spawn(function()
            while isAutoMoreira do
                task.wait(5)
                applyAntiLag()
            end
        end)
    end
end

AutoButton.MouseButton1Click:Connect(AutoMoreiraToggle)

-- === [4] АВТО-БЛОК (E → BLOCK ALL) ===
local function autoClickBlockButton()
    local prompt = CoreGui:FindFirstChild("PlayerListPrompt")
    if not prompt then return false end
    local blockBtn = prompt:FindFirstChild("Block", true)
    if not blockBtn or not blockBtn:IsA("TextButton") then return false end

    local attempts = 0
    repeat
        attempts += 1
        if blockBtn.Visible and blockBtn.Active and blockBtn.AbsoluteSize.X > 10 then
            spawn(function()
                wait(0.02)
                if blockBtn.MouseButton1Click then firesignal(blockBtn.MouseButton1Click) end
                pcall(function() fireclick(blockBtn) end)
                blockBtn:Click()
            end)
            return true
        end
        wait(0.03)
    until attempts >= 15
    return false
end

local function blockPlayer(plr)
    StarterGui:SetCore("PromptBlockPlayer", plr)
    spawn(function()
        local attempts = 0
        repeat
            wait(0.05)
            if CoreGui:FindFirstChild("PlayerListPrompt") then
                autoClickBlockButton()
                break
            end
            attempts += 1
        until attempts >= 10
    end)
end

local function blockAllPlayers()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            task.spawn(blockPlayer, plr)
        end
    end
end

local function onPromptTriggered(plr)
    if plr ~= LocalPlayer then return end
    task.delay(0.1, blockAllPlayers)
end

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("ProximityPrompt") then
        obj.Triggered:Connect(onPromptTriggered)
    end
end)

for _, obj in pairs(Workspace:GetDescendants()) do
    if obj:IsA("ProximityPrompt") then
        obj.Triggered:Connect(onPromptTriggered)
    end
end

-- === УВЕДОМЛЕНИЕ ===
StarterGui:SetCore("SendNotification", {
    Title = "Moreira Tools";
    Text = "Auto Moreira = Anti-Lag | FPS Lagger = Лаг | E = BLOCK ALL";
    Duration = 5;
})

print("Moreira Tools: Готово! Auto Moreira = ТОЛЬКО Anti-Lag | FPS Lagger = ТОЛЬКО Лаг")
