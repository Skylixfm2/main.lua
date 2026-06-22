-- AUTO QUEST ŒUF v49 - Rayfield UI (Propre)
print("=== AUTO QUEST ŒUF v49 - Rayfield UI ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Cheat quete Adopte me | by SkylixFM",
    LoadingTitle = "Connecting to GitHub...",
    LoadingSubtitle = "by SkylixFM",
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

-- Boutons principaux
Tab:CreateButton({
    Name = "Equipe Sandwich",
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
    Name = "Equipe Water",
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
    Name = "TP Buy Water",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(3020.41, 6960.26, -3002.70)
            Rayfield:Notify("Téléportation", "TP Buy Water effectué", 4483362458)
        end
    end,
})

Tab:CreateButton({
    Name = "TP Buy Food",
    Callback = function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(3020.41, 6960.26, -3042.36)
            Rayfield:Notify("Téléportation", "TP Buy Food effectué", 4483362458)
        end
    end,
})

-- Détection Auto
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

Rayfield:Notify("Panel Chargé", "Auto Quest Œuf v49 prêt !", 4483362458)
print("v49 chargé avec succès")
