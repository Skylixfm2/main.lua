-- AUTO QUEST ŒUF v50 - Rayfield UI + Speed Hack
print("=== AUTO QUEST ŒUF v50 - Rayfield UI + Speed Hack ===")

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

-- === SPEED HACK ===
local speedValue = 100
local speedConnection = nil

local SpeedToggle = Tab:CreateToggle({
    Name = "Speed Hack",
    CurrentValue = false,
    Flag = "SpeedHack",
    Callback = function(Value)
        if Value then
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = speedValue
            end
            speedConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = speedValue
                end
            end)
            Rayfield:Notify("Speed Hack", "Activé ("..speedValue..")", 4483362458)
        else
            if speedConnection then
                speedConnection:Disconnect()
                speedConnection = nil
            end
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
            Rayfield:Notify("Speed Hack", "Désactivé", 4483362458)
        end
    end,
})

Tab:CreateInput({
    Name = "Vitesse (WalkSpeed)",
    PlaceholderText = "Ex: 100",
    CurrentValue = "100",
    Flag = "SpeedValue",
    Callback = function(Text)
        local num = tonumber(Text)
        if num then
            speedValue = num
            Rayfield:Notify("Vitesse mise à jour", "Nouvelle vitesse : " .. num, 4483362458)
            -- Si le speed hack est activé, on applique immédiatement
            if SpeedToggle.CurrentValue and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = speedValue
            end
        end
    end,
})

-- === Boutons Nourriture ===
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

Rayfield:Notify("Panel Chargé", "v50 + Speed Hack prêt !", 4483362458)
print("v50 chargé avec succès")
