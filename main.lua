print("=== AUTO QUEST ŒUF v51.3 - Rayfield UI + Auto Shower ===")
print("=== AUTO QUEST ŒUF v51.4 - Rayfield UI + Auto Shower Fix ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Cheat Adopt Me | by SkylixFM",
    LoadingTitle = "Auto Quest Œuf",
    LoadingSubtitle = "v51.3 - by SkylixFM",
    LoadingSubtitle = "v51.4 - by SkylixFM",
    ConfigurationSaving = { Enabled = true, FolderName = "AutoQuestOeuf", FileName = "Config" },
    KeySystem = false
})
@@ -73,31 +74,44 @@ Tab:CreateToggle({
    end,
})

-- === AUTO SHOWER PET (Version Améliorée) ===
-- === AUTO SHOWER PET (Version Améliorée pour ModernShower) ===
Tab:CreateButton({
    Name = "🛁 Auto Shower Pet",
    Callback = function()
        local EquippedPets = require(ReplicatedStorage:WaitForChild("Fsys")).load("EquippedPets")
        -- Récupération du pet équipé
        local success, EquippedPets = pcall(function()
            return require(ReplicatedStorage:WaitForChild("Fsys")).load("EquippedPets")
        end)
        if not success or not EquippedPets then
            Rayfield:Notify("Erreur", "Impossible de charger EquippedPets", 4483362458)
            return
        end

        local pet = EquippedPets.choose_wrapper()
        
        if not pet or not pet.char then
            Rayfield:Notify("Erreur", "Équipe un pet d'abord !", 4483362458)
            return
        end

        local petRoot = pet.char:FindFirstChild("HumanoidRootPart")
        if not petRoot then return end
        if not petRoot then
            Rayfield:Notify("Erreur", "PetRoot non trouvé", 4483362458)
            return
        end

        -- Trouver la douche la plus proche
        -- Détection améliorée des douches (inclut ModernShower)
        local shower = nil
        local minDist = math.huge

        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("UseBlocks") and (obj.Name:lower():find("shower") or obj:FindFirstChild("Smoke")) then
                local part = obj.PrimaryPart or obj.Center or obj:FindFirstChild("Center")
        for _, obj in ipairs(Workspace:GetDescendants()) do
            local name = obj.Name:lower()
            if name:find("shower") or name:find("modernshower") or obj:FindFirstChild("Smoke") or 
               (obj:FindFirstChild("Center") and name:find("shower")) then
                
                local part = obj.PrimaryPart or obj.Center or obj:FindFirstChild("Center") or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local dist = (part.Position - player.Character.HumanoidRootPart.Position).Magnitude
                    if dist < minDist and dist < 120 then
                    local dist = (part.Position - (player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character.HumanoidRootPart.Position or Vector3.new())).Magnitude
                    if dist < minDist and dist < 150 then
                        minDist = dist
                        shower = obj
                    end
@@ -106,21 +120,18 @@ Tab:CreateButton({
        end

        if not shower then
            Rayfield:Notify("Erreur", "Aucune douche trouvée près de toi", 4483362458)
            Rayfield:Notify("Erreur", "Aucune douche (ModernShower) trouvée", 4483362458)
            return
        end

        local showerPart = shower.PrimaryPart or shower.Center
        petRoot.CFrame = showerPart.CFrame * CFrame.new(0, 2.5, 0)

        task.wait(0.6)

        -- Simulation d'utilisation de la douche (plus proche du vrai système)
        pcall(function()
            local Interactions = ReplicatedStorage:FindFirstChild("InteractionsEngine", true) or workspace
            -- On force un peu l'interaction
            Rayfield:Notify("Auto Shower", "Pet dans la douche ! (Attends qu'il soit propre)", 4483362458)
        end)
        local showerPart = shower.PrimaryPart or shower.Center or shower:FindFirstChildWhichIsA("BasePart")
        if showerPart then
            petRoot.CFrame = showerPart.CFrame * CFrame.new(0, 3, 0)
            Rayfield:Notify("Auto Shower", "Pet téléporté dans la douche !", 4483362458)
            
            task.wait(1)
            Rayfield:Notify("Auto Shower", "Le pet devrait commencer à se laver...", 4483362458)
        end
    end,
})

@@ -151,7 +162,7 @@ Tab:CreateButton({ Name = "Équiper Sandwich (Hungry)", Callback = function()
    if food then
        pcall(function()
            local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
            if ctm then ctm.backpack_equip(food) end
            if ctm and ctm.backpack_equip then ctm.backpack_equip(food) end
        end)
        Rayfield:Notify("Succès", "Sandwich équipé", 4483362458)
    else
@@ -164,15 +175,15 @@ Tab:CreateButton({ Name = "Équiper Boisson (Thirsty)", Callback = function()
    if drink then
        pcall(function()
            local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
            if ctm then ctm.backpack_equip(drink) end
            if ctm and ctm.backpack_equip then ctm.backpack_equip(drink) end
        end)
        Rayfield:Notify("Succès", "Boisson équipée", 4483362458)
    else
        Rayfield:Notify("Erreur", "Aucune boisson", 4483362458)
    end
end})

-- Auto Hungry/Thirsty
-- Auto Hungry / Thirsty
local AilmentsClient
for _, v in ipairs(game:GetDescendants()) do
    if v:IsA("ModuleScript") and v.Name == "AilmentsClient" then
@@ -183,15 +194,16 @@ end

if AilmentsClient then
    AilmentsClient.get_ailment_created_signal():Connect(function(ailment)
        if not ailment then return end
        if ailment.id == "hungry" then
            local food = findItem("hungry")
            if food then pcall(function() require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)).backpack_equip(food) end) end
            if food then pcall(function() local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)) if ctm then ctm.backpack_equip(food) end end) end
        elseif ailment.id == "thirsty" then
            local drink = findItem("thirsty")
            if drink then pcall(function() require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)).backpack_equip(drink) end) end
            if drink then pcall(function() local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true)) if ctm then ctm.backpack_equip(drink) end end) end
        end
    end)
end

Rayfield:Notify("Panel Chargé", "v51.3 prêt - Cheat Adopt Me", 4483362458)
print("v51.3 chargé avec succès")
Rayfield:Notify("Panel Chargé", "v51.4 prêt - Auto Shower amélioré", 4483362458)
print("v51.4 chargé avec succès")
