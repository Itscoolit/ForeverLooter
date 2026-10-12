---@class ForeverLooter
local ForeverLooter = select(2, ...)

---@class FL_LootedItem
local LootedItem = {}
ForeverLooter.LootedItem = LootedItem

---@param entryId integer|nil
---@param id integer
---@param itemLink string
---@param value integer
---@param quantity integer
---@param action string|nil
---@return FL_Item
function LootedItem.New(entryId, id, itemLink, value, quantity, action)
    local self = {}
    self.entryId = entryId
    self.id = id
    self.itemLink = itemLink
    self.value = value
    self.quantity = quantity
    self.action = action

    return self
end

---@class FL_Item
---@field entryId integer|nil
---@field id integer
---@field itemLink string
---@field value integer
---@field quantity integer
---@field action string|nil
