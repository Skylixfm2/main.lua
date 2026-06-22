-- AUTO QUEST ŒUF v44 - Rayfield UI
print("=== AUTO QUEST ŒUF v44 - Rayfield UI ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

-- Chargement de Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Auto Quest Œuf | by Starfall",
    LoadingTitle = "Connecting to GitHub...",
    LoadingSubtitle = "by Starfall",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "AutoQuestOeuf",
        FileName = "Config"
    },
    Discord = {
        Enabled = false
    },
    KeySystem = false
})

local Tab = Window:CreateTab("Main", 4483362458) -- Icône sac à dos

-- Variables
local ClientData = nil
pcall(function()
    local load = require(ReplicatedStorage:WaitForChild("Fsys")).load
    ClientData = load("ClientData")
end)

local function findFood()
    local food = nil
    pcall(function()
        local inv = ClientData and ClientData.get("inventory")
        if inv and inv.food then
            for _, item in pairs(inv.food) do
                if item and item.kind and (item.kind:find("sandwich") or item.kind:find("food")) then
                    food = item
                    return
                end
            end
        end
    end)
    return food
end

-- Toggles
Tab:CreateToggle({
    Name = "Auto Équiper Sandwich",
    CurrentValue = true,
    Flag = "AutoEquip",
    Callback = function(Value)
        print("Auto Équiper Sandwich:", Value and "ON" or "OFF")
    end,
})

Tab:CreateToggle({
    Name = "Auto Feed (GrabPetObject)",
    CurrentValue = true,
    Flag = "AutoFeed",
    Callback = function(Value)
        print("Auto Feed:", Value and "ON" or "OFF")
    end,
})

Tab:CreateButton({
    Name = "Équiper Sandwich Maintenant",
    Callback = function()
        local food = findFood()
        if food then
            pcall(function()
                local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
                if ctm then
                    ctm.backpack_equip(food)
                    Rayfield:Notify("Succès", "Sandwich équipé !", 4483362458)
                end
            end)
        else
            Rayfield:Notify("Erreur", "Aucun sandwich trouvé", 4483362458)
        end
    end,
})

Tab:CreateButton({
    Name = "Force Feed (Manual)",
    Callback = function()
        Rayfield:Notify("Info", "Clique manuellement sur FEED maintenant", 4483362458)
    end,
})

-- Auto Hungry Detection
local AilmentsClient
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name == "AilmentsClient" then
        AilmentsClient = require(v)
        break
    end
end

if AilmentsClient then
    AilmentsClient.get_ailment_created_signal():Connect(function(ailment)
        if ailment and ailment.id == "hungry" then
            Rayfield:Notify("Quête Détectée", "Hungry détecté ! Sandwich en cours d'équipement...", 4483362458)
            local food = findFood()
            if food then
                pcall(function()
                    local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
                    if ctm then ctm.backpack_equip(food) end
                end)
            end
        end
    end)
end

Rayfield:Notify("Chargé avec succès", "Panel Rayfield ouvert !", 4483362458)
print("v44 Rayfield UI chargé")
