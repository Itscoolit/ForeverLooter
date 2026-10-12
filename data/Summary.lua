---@class ForeverLooter
local ForeverLooter = select(2, ...)
---@class FL_LootedItem
local LootedItem = ForeverLooter.LootedItem

---@class FL_Summary
local Summary = {}
ForeverLooter.Summary = Summary

---@class FL_SMFunctions
local SMFunctions = {}
ForeverLooter.SMFunctions = SMFunctions

---------------------------------------------------------
local GetItemInfoFromHyperlink = GetItemInfoFromHyperlink
local pairs = pairs
---------------------------------------------------------

---@param summary table
---@param itemLink string
---@param quantity integer
---@param value integer
function SMFunctions.Insert(summary, itemLink, quantity, value)
    if summary == nil then
        summary = {}
    end

    if summary[itemLink] == nil then
        summary[itemLink] = { [1] = quantity, [2] = value }
        return summary
    end
    summary[itemLink][1] = summary[itemLink][1] + quantity
    summary[itemLink][2] = value
    return summary
end

---@param summary table
---@param lootedItem FL_LootedItem
function SMFunctions.InsertLootedItem(summary, lootedItem)
    return SMFunctions.Insert(summary, lootedItem.itemLink, lootedItem.quantity, lootedItem.value)
end

---@param summary table
---@return table
function SMFunctions.GetTopItems(summary)
    local topItems = {}
    for itemLink, item in pairs(summary) do
        local itemID = GetItemInfoFromHyperlink(itemLink)
        local quantity = item[1]
        local value = item[2]
        local lootedItem = LootedItem.New(nil, itemID, itemLink, value, quantity)
        table.insert(topItems, lootedItem)
    end
    table.sort(topItems, function(a, b)
        return a.value * a.quantity > b.value * b.quantity
    end)

    return topItems
end
