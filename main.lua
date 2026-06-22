print("=== AUTO QUEST ŒUF v51.2 - Rayfield UI + Auto Shower ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Cheat Adopt Me | by SkylixFM",
    LoadingTitle = "Auto Quest Œuf",
    LoadingSubtitle = "v51.2 - by SkylixFM",
    ConfigurationSaving = { Enabled = true, FolderName = "AutoQuestOeuf", FileName = "Config" },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

local ClientData = nil
local InventoryDB = nil

pcall(function()
    local fsys = ReplicatedStorage:WaitForChild("Fsys", 5)
    if fsys then
        local load = require(fsys).load
        ClientData = load("ClientData")
        InventoryDB = load("InventoryDB")
    end
end)

local function findItem(ailmentType)
    if not ClientData or not InventoryDB then return nil end
    local inv = ClientData.get("inventory")
    if not (inv and inv.food) then return nil end

    for _, item in pairs(inv.food) do
        if item and item.kind then
            local db = InventoryDB.food[item.kind]
            if db and db.ailment_to_boost == ailmentType then
                return item
            end
        end
    end
    return nil
end

-- === SPEED HACK ===
local speedValue = 100
local speedConnection = nil

Tab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Callback = function(Value)
        if Value then
            if speedConnection then speedConnection:Disconnect() end
            speedConnection = RunService.Heartbeat:Connect(function()
                local char = player.Character
                if char and char:FindFirstChild("Humanoid") then
                    char.Humanoid.WalkSpeed = speedValue
                end
            end)
            Rayfield:Notify("Speed Hack", "Activé (" .. speedValue .. ")", 4483362458)
        else
            if speedConnection then speedConnection:Disconnect() end
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                char.Humanoid.WalkSpeed = 16
            end
            Rayfield:Notify("Speed Hack", "Désactivé", 4483362458)
        end
    end,
})

Tab:CreateInput({
    Name = "Vitesse (WalkSpeed)",
    PlaceholderText = "100",
    CurrentValue = "100",
    Callback = function(Text)
        local num = tonumber(Text)
        if num and num > 0 then
            speedValue = num
            Rayfield:Notify("Vitesse", "Mise à jour → " .. num, 4483362458)
        end
    end,
})

-- === AUTO SHOWER PET ===
Tab:CreateButton({
    Name = "🛁 Auto Shower Pet",
    Callback = function()
        local EquippedPets = nil
        pcall(function()
            EquippedPets = require(ReplicatedStorage:WaitForChild("Fsys")).load("EquippedPets")
        end)

        local pet = EquippedPets and EquippedPets.choose_wrapper()
        if not pet or not pet.char then
            Rayfield:Notify("Erreur", "Aucun pet équipé !", 4483362458)
            return
        end

        local petRoot = pet.char:FindFirstChild("HumanoidRootPart")
        if not petRoot then
            Rayfield:Notify("Erreur", "Pet non trouvé", 4483362458)
            return
        end

        -- Détection de la douche la plus proche
        local closest, dist = nil, math.huge
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:FindFirstChild("Center") or v:FindFirstChild("PrimaryPart") then
                if v.Name:lower():find("shower") or v:FindFirstChild("Smoke") or v:GetAttribute("ShowerFurniture") then
                    local part = v.PrimaryPart or v.Center
                    if part then
                        local d = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist and d < 150 then
                            dist = d
                            closest = v
                        end
                    end
                end
            end
        end

        if closest then
            local showerPart = closest.PrimaryPart or closest.Center
            petRoot.CFrame = showerPart.CFrame * CFrame.new(0, 3, 0)
            Rayfield:Notify("Auto Shower", "Pet mis dans la douche ! ✅", 4483362458)
        else
            Rayfield:Notify("Erreur", "Aucune douche détectée", 4483362458)
        end
    end,
})

-- === TELEPORTS ===
local tps = {
    ["Buy Water"] = CFrame.new(3020.41, 6960.26, -3002.70),
    ["Buy Food"]  = CFrame.new(3020.41, 6960.26, -3042.36),
    ["Camping"]   = CFrame.new(-18.79, 31.93, -1053.97),
    ["Aire de Jeu"] = CFrame.new(-353.36, 30.89, -1759.09),
}

for name, cf in pairs(tps) do
    Tab:CreateButton({ Name = "TP " .. name, Callback = function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = cf end
        Rayfield:Notify("TP", name, 4483362458)
    end})
end

-- === FOOD SYSTEM ===
Tab:CreateButton({
    Name = "Équiper Sandwich (Hungry)",
    Callback = function() 
        local food = findItem("hungry")
        if food then
            pcall(function()
                local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
                if ctm then ctm.backpack_equip(food) end
            end)
            Rayfield:Notify("Succès", "Sandwich équipé", 4483362458)
        else
            Rayfield:Notify("Erreur", "Pas de sandwich", 4483362458)
        end
    end
})

Tab:CreateButton({
    Name = "Équiper Boisson (Thirsty)",
    Callback = function()
        local drink = findItem("thirsty")
        if drink then
            pcall(function()
                local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
                if ctm then ctm.backpack_equip(drink) end
            end)
            Rayfield:Notify("Succès", "Boisson équipée", 4483362458)
        else
            Rayfield:Notify("Erreur", "Pas de boisson", 4483362458)
        end
    end
})

-- Auto Hungry / Thirsty
local AilmentsClient
for _, v in game:GetDescendants() do
    if v:IsA("ModuleScript") and v.Name == "AilmentsClient" then
        AilmentsClient = require(v) break
    end
end

if AilmentsClient then
    AilmentsClient.get_ailment_created_signal():Connect(function(ailment)
        if ailment and ailment.id == "hungry" then
            local food = findItem("hungry")
            if food then pcall(function() require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)).backpack_equip(food) end) end
        elseif ailment and ailment.id == "thirsty" then
            local drink = findItem("thirsty")
            if drink then pcall(function() require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)).backpack_equip(drink) end) end
        end
    end)
end

Rayfield:Notify("Panel Chargé", "Auto Quest Œuf v51.2 | Cheat Adopt Me", 4483362458)
print("v51.2 chargé avec succès")
