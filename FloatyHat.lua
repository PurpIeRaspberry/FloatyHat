-- LocalScript (StarterPlayerScripts)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")
local ItemEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ItemPackageEvent")

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PixelEquipUI"
ScreenGui.Parent = PlayerGui

-- Main Frame
local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 420, 0, 520)
Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame.AnchorPoint = Vector2.new(0.5, 0.5)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BorderSizePixel = 0
Frame.Visible = false
Frame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 15)
FrameCorner.Parent = Frame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Thickness = 2
FrameStroke.Color = Color3.fromRGB(80,80,80)
FrameStroke.Parent = Frame

-- Title bar
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 45)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
Title.Text = "Digital Bee Panel"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Parent = Frame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 15)
TitleCorner.Parent = Title

-- Pixel screen
local ScreenArea = Instance.new("Frame")
ScreenArea.Size = UDim2.new(1, -20, 0, 300)
ScreenArea.Position = UDim2.new(0, 10, 0, 60)
ScreenArea.BackgroundColor3 = Color3.fromRGB(25, 70, 35)
ScreenArea.BorderSizePixel = 0
ScreenArea.Parent = Frame

local ScreenCorner = Instance.new("UICorner")
ScreenCorner.CornerRadius = UDim.new(0, 10)
ScreenCorner.Parent = ScreenArea

-- Pixel smiley
local pixelSize = 16
local spacing = 20
local offsetX = 12
local offsetY = 10

local smiley = {
    -- Left eye
    {5,2},{6,2},{4,3},{5,3},{6,3},{7,3},
    {4,4},{5,4},{6,4},{7,4},{5,5},{6,5},

    -- Right eye
    {12,2},{13,2},{11,3},{12,3},{13,3},{14,3},
    {11,4},{12,4},{13,4},{14,4},{12,5},{13,5},

    -- Mouth
    {4,8},{5,8},{4,9},{5,9},{6,9},{5,10},
    {6,10},{7,10},{8,10},{9,10},{10,10},{11,10},{12,10},
    {6,11},{7,11},{8,11},{9,11},{10,11},{11,11},{12,11},
    {13,10},{12,9},{13,9},{14,9},{13,8},{14,8}
}

local pixelFrames = {}

for _, pos in ipairs(smiley) do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, 0, 0, 0) -- start hidden
    p.Position = UDim2.new(0, offsetX + pos[1]*spacing, 0, offsetY + pos[2]*spacing)
    p.BackgroundColor3 = Color3.fromRGB(170,255,120)
    p.BorderSizePixel = 0
    p.Parent = ScreenArea
    table.insert(pixelFrames, p)
end

-- Buttons container
local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Size = UDim2.new(1, -40, 0, 120)
ButtonsFrame.Position = UDim2.new(0, 20, 0, 370)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Visible = false
ButtonsFrame.Parent = Frame

-- Dragging
local dragging, dragStart, startPos

Title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = Frame.Position
        dragging = true
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                   startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- Toggle ;
UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.Semicolon then
        if Frame.Visible == false then
            Frame.Visible = true
            ButtonsFrame.Visible = false
            task.spawn(function()
                local delayTime = 0.02
                for _, pixel in ipairs(pixelFrames) do
                    pixel.Size = UDim2.new(0, pixelSize, 0, pixelSize)
                    wait(delayTime)
                end
                ButtonsFrame.Visible = true
            end)
        else
            Frame.Visible = false
            ButtonsFrame.Visible = false
            for _, pixel in ipairs(pixelFrames) do
                pixel.Size = UDim2.new(0, 0, 0, 0)
            end
        end
    end
end)

-- Gradient text function
local function createEquipButton(name, args, xPos, yPos, gradientColors)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 150, 0, 28)
    button.Position = UDim2.new(0, xPos, 0, yPos)
    button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    button.BorderSizePixel = 0
    button.Text = name
    button.TextColor3 = gradientColors[1]
    button.Font = Enum.Font.GothamBold
    button.TextSize = 15
    button.Parent = ButtonsFrame

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = button

    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(60,60,60)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(40,40,40)
    end)

    button.MouseButton1Click:Connect(function()
        button.Text = name .. "..."
        button.Active = false

        task.delay(5, function()
            if typeof(args[1]) == "table" then
                for _, item in ipairs(args) do
                    ItemEvent:InvokeServer(unpack(item))
                end
            else
                ItemEvent:InvokeServer(unpack(args))
            end
            button.Text = name
            button.Active = true
        end)
    end)

    -- Animate text color
    task.spawn(function()
        local index = 1
        while button.Parent do
            button.TextColor3 = gradientColors[index]
            index = index + 1
            if index > #gradientColors then index = 1 end
            wait(0.15)
        end
    end)
end

-- Gradient definitions
local warmGradient = {
    Color3.fromRGB(255, 100, 50),
    Color3.fromRGB(255, 150, 0),
    Color3.fromRGB(255, 220, 50)
}

local coolGradient = {
    Color3.fromRGB(50, 150, 255),
    Color3.fromRGB(0, 200, 180),
    Color3.fromRGB(0, 255, 200)
}

local warmGradientDark = {
    Color3.fromRGB(200, 80, 40),
    Color3.fromRGB(200, 120, 0),
    Color3.fromRGB(200, 180, 40)
}

local coolGradientDark = {
    Color3.fromRGB(40, 120, 200),
    Color3.fromRGB(0, 160, 140),
    Color3.fromRGB(0, 200, 160)
}

local pinkTurquoiseGradient = {
    Color3.fromRGB(255, 150, 200),
    Color3.fromRGB(150, 255, 255)
}

-- Items
local items = {
    ["Tide Popper"] = {"Equip", {Type = "Tide Popper", Category = "Collector", Amount = 1}},
    ["Dark Scythe"] = {"Equip", {Type = "Dark Scythe", Category = "Collector", Amount = 1}},
    ["Diamond Mask"] = {"Equip", {Category = "Accessory", Type = "Diamond Mask"}},
    ["Demon Mask"] = {"Equip", {Category = "Accessory", Type = "Demon Mask"}}
}

-- Create individual buttons
createEquipButton("Tide Popper", items["Tide Popper"], 20, 0, coolGradient)
createEquipButton("Dark Scythe", items["Dark Scythe"], 200, 0, warmGradient)
createEquipButton("Diamond Mask", items["Diamond Mask"], 20, 40, coolGradient)
createEquipButton("Demon Mask", items["Demon Mask"], 200, 40, warmGradient)

-- Create combo buttons
createEquipButton("Blue Hive", {
    {"Equip", {Category="Accessory", Type="Diamond Mask"}},
    {"Equip",{Type="Tide Popper",Category="Collector",Amount=1}}
}, 20, 80, coolGradientDark)

createEquipButton("Red Hive", {
    {"Equip", {Category="Accessory", Type="Demon Mask"}},
    {"Equip",{Type="Dark Scythe",Category="Collector",Amount=1}}
}, 200, 80, warmGradientDark)

-- White Hive combo button
createEquipButton("White Hive", {
    {"Equip", {Category = "Accessory", Type = "Gummy Mask"}},
    {"Equip", {Type = "Gummyballer", Category = "Collector", Amount = 1}}
}, 110, 115, pinkTurquoiseGradient)
