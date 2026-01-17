-- LocalScript
-- Put this in StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local flowerZones = workspace:WaitForChild("FlowerZones")
local itemEvent = ReplicatedStorage:WaitForChild("Events"):WaitForChild("ItemPackageEvent")

-- FIELD → MASK MAP
local FieldMasks = {
	-- Diamond Mask
	["Bamboo Field"] = "Diamond Mask",
	["Blue Flower Field"] = "Diamond Mask",
	["Stump Field"] = "Diamond Mask",
	["Pine Tree Forest"] = "Diamond Mask",

	-- Demon Mask
	["Pepper Patch"] = "Demon Mask",
	["Mushroom Field"] = "Demon Mask",
	["Rose Field"] = "Demon Mask",
	["Strawberry Field"] = "Demon Mask",

	-- Gummy Mask
	["Spider Field"] = "Gummy Mask",
	["Pineapple Patch"] = "Gummy Mask",
	["Pumpkin Patch"] = "Gummy Mask",
	["Dandelion Field"] = "Gummy Mask",
	["Sunflower Field"] = "Gummy Mask"
}

local currentMask = nil
local currentField = nil
local equipTimer = nil
local EQUIP_DELAY = 5 -- seconds

-- Function to equip mask
local function equipMask(maskName)
	if currentMask == maskName then return end
	currentMask = maskName

	local args = {
		"Equip",
		{
			Category = "Accessory",
			Type = maskName
		}
	}
	itemEvent:InvokeServer(unpack(args))
end

-- Function to handle field entry
local function enterField(fieldName)
	-- Reset timer if changing field
	if currentField ~= fieldName then
		currentField = fieldName
		if equipTimer then
			equipTimer:Disconnect()
			equipTimer = nil
		end

		-- Start new 5-second timer
		equipTimer = game:GetService("RunService").Heartbeat:Connect(function(step)
			EQUIP_DELAY = EQUIP_DELAY - step
			if EQUIP_DELAY <= 0 then
				equipMask(FieldMasks[currentField])
				equipTimer:Disconnect()
				equipTimer = nil
				EQUIP_DELAY = 5
			end
		end)
	end
end

-- Function to handle field exit (optional: reset current field)
local function leaveField(fieldName)
	if currentField == fieldName then
		currentField = nil
		if equipTimer then
			equipTimer:Disconnect()
			equipTimer = nil
		end
		EQUIP_DELAY = 5
	end
end

-- Connect all field Touched events
for fieldName, maskName in pairs(FieldMasks) do
	local field = flowerZones:FindFirstChild(fieldName)
	if field and field:IsA("BasePart") then
		field.Touched:Connect(function(hit)
			if hit:IsDescendantOf(player.Character) then
				enterField(fieldName)
			end
		end)
		field.TouchEnded:Connect(function(hit)
			if hit:IsDescendantOf(player.Character) then
				leaveField(fieldName)
			end
		end)
	end
end
