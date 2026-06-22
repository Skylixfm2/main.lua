print("=== AUTO QUEST ŒUF v51.8 - Rayfield UI + Auto Shower Stable ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Cheat Adopt Me | by SkylixFM",
    LoadingTitle = "Auto Quest Œuf",
    LoadingSubtitle = "v51.8 - by SkylixFM",
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

-- === AUTO SHOWER PET (Version Ultra Stable) ===
Tab:CreateButton({
    Name = "🛁 Auto Shower Pet (Ta Maison)",
    Callback = function()
        local EquippedPets = nil
        pcall(function()
            EquippedPets = require(ReplicatedStorage:WaitForChild("Fsys")).load("EquippedPets")
        end)

        local pet = EquippedPets and EquippedPets.choose_wrapper()
        if not pet or not pet.char then
            Rayfield:Notify("Erreur", "Équipe un pet d'abord !", 4483362458)
            return
        end

        local petRoot = pet.char:FindFirstChild("HumanoidRootPart")
        if not petRoot then
            Rayfield:Notify("Erreur", "PetRoot introuvable", 4483362458)
            return
        end

        -- Recherche propre de la douche dans ta maison
        local shower = nil
        local houseInteriors = Workspace:FindFirstChild("HouseInteriors")
        
        if houseInteriors then
            for _, house in ipairs(houseInteriors:GetChildren()) do
                for _, obj in ipairs(house:GetDescendants()) do
                    local name = obj.Name:lower()
                    if (name:find("shower") or name:find("modernshower") or name:find("stylishshower")) and
                       (obj:FindFirstChild("Center") or obj:FindFirstChild("PrimaryPart")) then
                        shower = obj
                        break
                    end
                end
                if shower then break end
            end
        end

        if not shower then
            Rayfield:Notify("Erreur", "Douche non trouvée dans ta maison", 4483362458)
            return
        end

        local showerPart = shower.PrimaryPart or shower.Center
        if showerPart then
            petRoot.CFrame = showerPart.CFrame * CFrame.new(0, 3.5, -4) -- Devant la douche
            Rayfield:Notify("Auto Shower", "Pet téléporté devant ta douche ✅", 4483362458)
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
    Tab:CreateButton({Name = "TP " .. name, Callback = function()
        local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if root then root.CFrame = cf end
        Rayfield:Notify("TP", name, 4483362458)
    end})
end

-- === FOOD ===
Tab:CreateButton({ Name = "Équiper Sandwich (Hungry)", Callback = function()
    local food = findItem("hungry")
    if food then
        pcall(function()
            local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
            if ctm then ctm.backpack_equip(food) end
        end)
        Rayfield:Notify("Succès", "Sandwich équipé", 4483362458)
    else
        Rayfield:Notify("Erreur", "Aucun sandwich", 4483362458)
    end
end})

Tab:CreateButton({ Name = "Équiper Boisson (Thirsty)", Callback = function()
    local drink = findItem("thirsty")
    if drink then
        pcall(function()
            local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
            if ctm then ctm.backpack_equip(drink) end
        end)
        Rayfield:Notify("Succès", "Boisson équipée", 4483362458)
    else
        Rayfield:Notify("Erreur", "Aucune boisson", 4483362458)
    end
end})

-- Auto Hungry / Thirsty
local AilmentsClient
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name == "AilmentsClient" then
        AilmentsClient = require(v)
        break
    end
end

if AilmentsClient then
    AilmentsClient.get_ailment_created_signal():Connect(function(ailment)
        if not ailment then return end
        if ailment.id == "hungry" then
            local food = findItem("hungry")
            if food then pcall(function() local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)) if ctm then ctm.backpack_equip(food) end end) end
        elseif ailment.id == "thirsty" then
            local drink = findItem("thirsty")
            if drink then pcall(function() local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)) if ctm then ctm.backpack_equip(drink) end end) end
        end
    end)
end

Rayfield:Notify("Panel Chargé", "v51.8 - Stable", 4483362458)
print("v51.8 chargé avec succès")
