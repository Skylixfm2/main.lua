-- AUTO QUEST ŒUF - Version Manuelle (v42)
print("=== AUTO QUEST ŒUF v42 - Mode MANUEL ===")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

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
                    print("✅ Sandwich trouvé :", item.kind)
                    return
                end
            end
        end
    end)
    return food
end

local function equipFood()
    local food = findFood()
    if not food then
        print("❌ Aucun sandwich trouvé dans ton inventaire")
        return
    end

    print("🍔 Équipement du sandwich...")

    pcall(function()
        local ctm = require(ReplicatedStorage:FindFirstChild("ClientToolManager", true))
        if ctm and ctm.backpack_equip then
            ctm.backpack_equip(food)
            print("✅ Sandwich équipé !")
        end
    end)

    task.wait(0.6)
    print("=====================================")
    print("✅ PRÊT ! Clique maintenant sur le bouton FEED")
    print("=====================================")
end

-- Détection automatique quand la quête hungry apparaît
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
            print("🐾 Quête hungry détectée !")
            task.spawn(equipFood)
        end
    end)
end

print("v42 chargé - Mode Manuel")
task.wait(0.5)
equipFood()
