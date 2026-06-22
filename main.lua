-- AUTO QUEST ŒUF v46 - Rayfield UI
print("=== AUTO QUEST ŒUF v46 - Rayfield UI ===")

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

-- Boutons
Tab:CreateButton({
    Name = "Équiper Sandwich Maintenant",
    Callback = function()
        local food = findFood()
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
    Name = "Force Feed (Manual)",
    Callback = function()
        Rayfield:Notify("Info", "Clique maintenant sur FEED", 4483362458)
    end,
})

Tab:CreateButton({
    Name = "Sortir de l'Eau (Fix)",
    Callback = function()
        pcall(function()
            local char = player.Character
            if char and char:FindFirstChild("Humanoid") then
                local hum = char.Humanoid
                
                -- Meilleure méthode pour sortir de l'eau
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
                task.wait(0.15)
                hum:ChangeState(Enum.HumanoidStateType.Freefall)
                task.wait(0.3)
                hum:ChangeState(Enum.HumanoidStateType.Landed)
                
                -- Reset velocity
                if char:FindFirstChild("HumanoidRootPart") then
                    char.HumanoidRootPart.Velocity = Vector3.new(0, 50, 0) -- Petit boost vers le haut
                end
            end

            -- Pour le pet aussi
            for _, obj in ipairs(game.Workspace:GetDescendants()) do
                if obj:FindFirstChild("Humanoid") and (obj.Name == "Char" or obj:FindFirstChild("PetUnique")) then
                    obj.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end
        end)
        Rayfield:Notify("Sortir de l'Eau", "Tentative améliorée effectuée", 4483362458)
    end,
})

-- Détection Hungry
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
            Rayfield:Notify("Quête Hungry", "Équipement du sandwich...", 4483362458)
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

Rayfield:Notify("Panel Chargé", "v46 prêt !", 4483362458)
print("v46 chargé")
