-- AUTO QUEST ŒUF v47 - Rayfield UI
print("=== AUTO QUEST ŒUF v47 - Rayfield UI ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Auto Quest Œuf | by Starfall",
    LoadingTitle = "Connecting to GitHub...",
    LoadingSubtitle = "by Starfall",
    ConfigurationSaving = { Enabled = true, FolderName = "AutoQuestOeuf", FileName = "Config" },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458)

local ClientData = nil
local InventoryDB = nil
pcall(function()
    local load = require(ReplicatedStorage:WaitForChild("Fsys")).load
    ClientData = load("ClientData")
    InventoryDB = load("InventoryDB")
end)

local function findItem(ailmentType)
    local item = nil
    pcall(function()
        local inv = ClientData and ClientData.get("inventory")
        if inv and inv.food then
            for _, v in pairs(inv.food) do
                if v and v.kind then
                    local db = InventoryDB and InventoryDB.food[v.kind]
                    if db and db.ailment_to_boost == ailmentType then
                        item = v
                        return
                    end
                end
            end
        end
    end)
    return item
end

-- Boutons
Tab:CreateButton({
    Name = "Équiper Sandwich (Hungry)",
    Callback = function()
        local food = findItem("hungry")
        if food then
            pcall(function()
                local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
                if ctm then ctm.backpack_equip(food) end
            end)
            Rayfield:Notify("Succès", "Sandwich équipé !", 4483362458)
        else
            Rayfield:Notify("Erreur", "Aucun sandwich trouvé", 4483362458)
        end
    end,
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
            Rayfield:Notify("Succès", "Boisson équipée !", 4483362458)
        else
            Rayfield:Notify("Erreur", "Aucune boisson trouvée", 4483362458)
        end
    end,
})

Tab:CreateButton({
    Name = "Force Feed (Manual)",
    Callback = function()
        Rayfield:Notify("Info", "Clique maintenant sur FEED", 4483362458)
    end,
})

Tab:CreateButton({
    Name = "Sortir de l'Eau (Amélioré)",
    Callback = function()
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("HumanoidRootPart") and char:FindFirstChild("Humanoid") then
                local root = char.HumanoidRootPart
                local hum = char.Humanoid
                
                -- Boost puissant pour sortir de l'eau
                root.Velocity = Vector3.new(0, 80, 0)
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.2)
                root.Velocity = Vector3.new(0, 60, 0)
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
                task.wait(0.4)
                hum:ChangeState(Enum.HumanoidStateType.Landed)
            end

            -- Pour le pet aussi
            for _, obj in ipairs(game.Workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and (obj:FindFirstChild("PetUnique") or obj.Name == "Char") then
                    obj.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        Rayfield:Notify("Sortir de l'Eau", "Boost appliqué !", 4483362458)
    end,
})

-- Détection Auto Hungry / Thirsty
local AilmentsClient
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name == "AilmentsClient" then
        AilmentsClient = require(v)
        break
    end
end

if AilmentsClient then
    AilmentsClient.get_ailment_created_signal():Connect(function(ailment)
        if ailment then
            if ailment.id == "hungry" then
                Rayfield:Notify("Hungry Détecté", "Équipement du sandwich...", 4483362458)
                local food = findItem("hungry")
                if food then
                    pcall(function()
                        local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
                        if ctm then ctm.backpack_equip(food) end
                    end)
                end
            elseif ailment.id == "thirsty" then
                Rayfield:Notify("Thirsty Détecté", "Équipement de la boisson...", 4483362458)
                local drink = findItem("thirsty")
                if drink then
                    pcall(function()
                        local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
                        if ctm then ctm.backpack_equip(drink) end
                    end)
                end
            end
        end
    end)
end

Rayfield:Notify("Panel Chargé", "Auto Quest Œuf v47 prêt !", 4483362458)
print("v47 chargé")
