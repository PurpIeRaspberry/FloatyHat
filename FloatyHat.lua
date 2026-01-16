-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local flowerZones = workspace:WaitForChild("FlowerZones")

local itemEvent = ReplicatedStorage
	:WaitForChild("Events")
	:WaitForChild("ItemPackageEvent")

-- FIELD → MASK MAP
local FieldMasks = {
	-- DIAMOND MASK
	["Bamboo Field"] = "Diamond Mask",
	["Blue Flower Field"] = "Diamond Mask",
	["Stump Field"] = "Diamond Mask",
	["Pine Tree Forest"] = "Diamond Mask",

	-- DEMON MASK
	["Pepper Patch"] = "Demon Mask",
	["Mushroom Field"] = "Demon Mask",
	["Rose Field"] = "Demon Mask",
	["Strawberry Field"] = "Demon Mask",

	-- GUMMY MASK
	["Spider Field"] = "Gummy Mask",
	["Pineapple Patch"] = "Gummy Mask",
	["Pumpkin Patch"] = "Gummy Mask",
	["Dandelion Field"] = "Gummy Mask",
	["Sunflower Field"] = "Gummy Mask"
}

local currentMask = nil

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

-- CONNECT FIELD TOUCHES
for fieldName, maskName in pairs(FieldMasks) do
	local field = flowerZones:FindFirstChild(fieldName)
	if field then
		field.Touched:Connect(function(hit)
			local character = player.Character
			if not character then return end

			if hit:IsDescendantOf(character) then
				equipMask(maskName)
			end
		end)
	end
end
