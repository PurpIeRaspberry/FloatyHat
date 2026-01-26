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
Title.Size = UDim2.new(1, 0, 0, 50)
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

-- Pixel smiley (shifted right)
local pixelSize = 16
local spacing = 20
local offsetX = 12
local offsetY = 13

local smiley = {
    -- Left eye
    {5,2},{6,2},{4,3},{5,3},{6,3},{7,3},
    {4,4},{5,4},{6,4},{7,4},{5,5},{6,5},

    -- Right eye (moved 1 square right)
    {12,2},{13,2},{11,3},{12,3},{13,3},{14,3},
    {11,4},{12,4},{13,4},{14,4},{12,5},{13,5},

    -- Mouth
    {4,8},{5,8},{4,9},{5,9},{6,9},{5,10},
    {6,10},{7,10},{8,10},{9,10},{10,10},{11,10},{12,10},
    {6,11},{7,11},{8,11},{9,11},{10,11},{11,11},{12,11},
    {13,10},{12,9},{13,9},{14,9},{13,8},{14,8}
}


for _, pos in ipairs(smiley) do
    local p = Instance.new("Frame")
    p.Size = UDim2.new(0, pixelSize, 0, pixelSize)
    p.Position = UDim2.new(
        0, offsetX + pos[1]*spacing,  -- X position
        0, offsetY + pos[2]*spacing   -- Y position with offsetY
    )
    p.BackgroundColor3 = Color3.fromRGB(170,255,120)
    p.BorderSizePixel = 0
    p.Parent = ScreenArea
end

-- Buttons container
local ButtonsFrame = Instance.new("Frame")
ButtonsFrame.Size = UDim2.new(1, -40, 0, 120)
ButtonsFrame.Position = UDim2.new(0, 20, 0, 370)
ButtonsFrame.BackgroundTransparency = 1
ButtonsFrame.Parent = Frame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 8)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.Parent = ButtonsFrame

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
		Frame.Visible = not Frame.Visible
	end
end)

-- Equip button
local function createEquipButton(name, args)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(1, 0, 0, 28)
	button.BackgroundColor3 = Color3.fromRGB(40,40,40)
	button.BorderSizePixel = 0
	button.Text = name
	button.TextColor3 = Color3.fromRGB(255,255,255)
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
			ItemEvent:InvokeServer(unpack(args))
			button.Text = name
			button.Active = true
		end)
	end)
end

-- Items
local items = {
	["Tide Popper"] = {"Equip", {Type = "Tide Popper", Category = "Collector", Amount = 1}},
	["Dark Scythe"] = {"Equip", {Type = "Dark Scythe", Category = "Collector", Amount = 1}},
	["Diamond Mask"] = {"Equip", {Category = "Accessory", Type = "Diamond Mask"}},
	["Demon Mask"] = {"Equip", {Category = "Accessory", Type = "Demon Mask"}}
}

for name, args in pairs(items) do
	createEquipButton(name, args)
end
