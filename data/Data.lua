---@class ForeverLooter
local ForeverLooter = select(2, ...)

---@class FL_Utils
local Utils = ForeverLooter.Utils
---@class FL_Constants
local Constants = ForeverLooter.Constants
---@class FL_CircularBuffer
local CircularBuffer = ForeverLooter.CircularBuffer
---@class FL_CBFunctions
local CBFunctions = ForeverLooter.CBFunctions
---@class FL_Summary
local Summary = ForeverLooter.Summary
---@class FL_SMFunctions
local SMFunctions = ForeverLooter.SMFunctions
---@class FL_Profiler
local Profiler = ForeverLooter.Profiler

---@class FL_Data
local Data = {}
ForeverLooter.Data = Data

local CBCapacity = 200
Data.CBCapacity = CBCapacity

Data.callbacks = {}

---@param eventName string
---@param callback function
function Data.RegisterCallback(eventName, callback)
    if not Data.callbacks[eventName] then
        Data.callbacks[eventName] = {}
    end
    table.insert(Data.callbacks[eventName], callback)
end

---@param eventName string
---@param ... any
function Data.TriggerEvent(eventName, ...)
    if Data.callbacks[eventName] then
        for _, cb in ipairs(Data.callbacks[eventName]) do
            Profiler.Measure("MLEvent." .. eventName, cb, ...)
        end
    end
end

Data.DB = {}

---@class FL_DB
---@field CurrentStartText string
Data.DB.prototype = {
    Visible = true,
    ScrollLootFrameVisible = true,
    ----------------------------------------------
    Running = false,
    ----------------------------------------------
    OldMoney = 0,
    RawMoney = 0,
    ItemsMoney = 0,
    TotalMoney = 0,
    EMA_GPH = 0,
    Priciest = 0,
    PriciestLink = "",
    ListLootedItems = CircularBuffer,
    Summary = Summary,
    NextEntryId = 1,
    ----------------------------------------------
    Timer = 0,
    ----------------------------------------------
    CurrentStartText = _G.FOREVERLOOTER_L_START,
    ----------------------------------------------
    ForceVendorPrice = false,
    UseDisenchantValue = false,
    ForceUseDisenchantValue = { false, false, false, false }
}

Data.DB.mt = {}

Data.DB.mt.__index = function(_, key)
    return Data.DB.prototype[key]
end

local function initialize_db()
    if not ForeverLooterDB then
        ---@class FL_DB
        ForeverLooterDB = {}
    end
    if getmetatable(ForeverLooterDB) then
        setmetatable(ForeverLooterDB, nil)
    end
    setmetatable(ForeverLooterDB, Data.DB.mt)
end

Data.XDB = {}

---@class FL_CrossDB
Data.XDB.prototype = {
    CurrentTSMString = Constants.Strings.TSMString,
    CurrentTSMDisenchantString = Constants.Strings.TSMDisenchantString,
    PriceSource = Constants.PriceSources.TradeSkillMaster,
    ------------------------------
    MinPrices = { [0] = 0, 0, 0, 0, 0 },
    UIScale = 1
}

Data.XDB.mt = {}

Data.XDB.mt.__index = function(_, key)
    return Data.XDB.prototype[key]
end

local function initialize_xdb()
    if not ForeverLooterXDB then
        ForeverLooterXDB = {}
    end
    if getmetatable(ForeverLooterXDB) then
        setmetatable(ForeverLooterXDB, nil)
    end
    setmetatable(ForeverLooterXDB, Data.XDB.mt)

    if ForeverLooterXDB.MinPrices == nil then
        ForeverLooterXDB.MinPrices = {}
    end
    for quality = 1, 4 do
        local legacyKey = "MinPrice" .. quality
        if ForeverLooterXDB[legacyKey] ~= nil then
            ForeverLooterXDB.MinPrices[quality] = ForeverLooterXDB[legacyKey]
            ForeverLooterXDB[legacyKey] = nil
        end
    end
end

---@class FL_TempData
local ForeverLooterTempData = {
    InteractionPaused = false,
    SummaryMode = false
}

---@return boolean
function Data.IsVisible()
    return ForeverLooterDB.Visible
end

---@param visible boolean
function Data.SetVisible(visible)
    if visible ~= nil then
        ForeverLooterDB.Visible = visible
    end
end

---@return boolean
function Data.IsRunning()
    return ForeverLooterDB.Running
end

---@param running boolean
function Data.SetRunning(running)
    if running ~= nil then
        ForeverLooterDB.Running = running
    end
end

---@return integer
function Data.GetRawMoney()
    return ForeverLooterDB.RawMoney
end

---@param money integer
function Data.AddRawMoney(money)
    if money ~= nil then
        ForeverLooterDB.RawMoney = ForeverLooterDB.RawMoney + money
    end
end

---@return integer
function Data.GetItemsMoney()
    return ForeverLooterDB.ItemsMoney
end

---@param money integer
function Data.AddItemsMoney(money)
    if money ~= nil then
        ForeverLooterDB.ItemsMoney = ForeverLooterDB.ItemsMoney + money
    end
end

---@param money integer
function Data.SubItemsMoney(money)
    if money ~= nil then
        ForeverLooterDB.ItemsMoney = ForeverLooterDB.ItemsMoney - money
        if ForeverLooterDB.ItemsMoney < 0 then
            ForeverLooterDB.ItemsMoney = 0
        end
    end
end

---@param money integer
function Data.AddTotalMoney(money)
    if money ~= nil then
        ForeverLooterDB.TotalMoney = ForeverLooterDB.TotalMoney + money
    end
end

---@param money integer
function Data.SubTotalMoney(money)
    if money ~= nil then
        ForeverLooterDB.TotalMoney = ForeverLooterDB.TotalMoney - money
        if ForeverLooterDB.TotalMoney < 0 then
            ForeverLooterDB.TotalMoney = 0
        end
    end
end

---@return integer
function Data.GetPriciest()
    return ForeverLooterDB.Priciest
end

---@param itemLink string
---@param money integer
function Data.SetPriciest(money, itemLink)
    if money ~= nil and money > ForeverLooterDB.Priciest then
        ForeverLooterDB.Priciest = money
        ForeverLooterDB.PriciestLink = itemLink
    end
end

---@return string
function Data.GetPriciestLink()
    return ForeverLooterDB.PriciestLink
end

function Data.InitListLootedItems()
    if ForeverLooterDB.ListLootedItems == nil or ForeverLooterDB.ListLootedItems.buffer == nil then
        ForeverLooterDB.ListLootedItems = CBFunctions.New(ForeverLooterDB.ListLootedItems, Data.CBCapacity)
    end
end

---@return FL_CircularBuffer
function Data.GetListLootedItems()
    return ForeverLooterDB.ListLootedItems
end

---@return integer
function Data.NextLootEntryId()
    local nextId = ForeverLooterDB.NextEntryId or 1
    ForeverLooterDB.NextEntryId = nextId + 1
    return nextId
end

---@param lootedItem FL_Item
function Data.InsertLootedItem(lootedItem)
    if lootedItem == nil then return end
    CBFunctions.Push(ForeverLooterDB.ListLootedItems, lootedItem)
end

---@param lootedItem FL_Item
---@return boolean
function Data.RemoveLootedItem(lootedItem)
    if lootedItem == nil or lootedItem.entryId == nil or ForeverLooterDB.ListLootedItems == nil then return false end
    local removed = CBFunctions.RemoveItem(ForeverLooterDB.ListLootedItems, lootedItem)
    if not removed then return false end

    local itemTotal = lootedItem.value * lootedItem.quantity
    Data.SubItemsMoney(itemTotal)
    Data.SubTotalMoney(itemTotal)

    Data.TriggerEvent("FL_OnItemRemoved")
    return true
end

---@param lootedItem FL_Item
function Data.RemoveAllLootedItemsByID(lootedItem)
    if lootedItem == nil or lootedItem.id == nil or ForeverLooterDB.ListLootedItems == nil then return false end
    local removed = CBFunctions.RemoveAllItemsByID(ForeverLooterDB.ListLootedItems, lootedItem)
    print(removed)
    if not removed then return end

    local itemTotal = lootedItem.value * lootedItem.quantity
    Data.SubItemsMoney(itemTotal)
    Data.SubTotalMoney(itemTotal)

    Data.TriggerEvent("FL_OnItemRemoved")
end

---@return integer
function Data.GetListLootedItemsCount()
    return CBFunctions.GetSize(ForeverLooterDB.ListLootedItems)
end

---@return integer
function Data.GetOldMoney()
    return ForeverLooterDB.OldMoney
end

---@param money integer
function Data.SetOldMoney(money)
    if money ~= nil then
        ForeverLooterDB.OldMoney = money
    end
end

---@return integer
function Data.GetTimer()
    return ForeverLooterDB.Timer
end

---@return integer
function Data.AddOneToTimer()
    ForeverLooterDB.Timer = ForeverLooterDB.Timer + 1
    return ForeverLooterDB.Timer
end

---@param time integer
function Data.AddXToTimer(time)
    ForeverLooterDB.Timer = ForeverLooterDB.Timer + time
end

---@param time integer
function Data.SubXFromTimer(time)
    if ForeverLooterDB.Timer - time >= 0 then
        ForeverLooterDB.Timer = ForeverLooterDB.Timer - time
    else
        ForeverLooterDB.Timer = 0
    end
end

---@return string
function Data.GetCurrentStartText()
    return ForeverLooterDB.CurrentStartText
end

---@param text string
---@return string
function Data.SetCurrentStartText(text)
    if text ~= nil then
        ForeverLooterDB.CurrentStartText = text
    end
    return ForeverLooterDB.CurrentStartText
end

---@param quality integer
---@return integer
function Data.GetMinPrice(quality)
    return ForeverLooterXDB.MinPrices[quality] or 0
end

---@param quality integer
---@param money integer
function Data.SetMinPrice(quality, money)
    ForeverLooterXDB.MinPrices[quality] = money
end

---@return table
function Data.GetMinPrices()
    return ForeverLooterXDB.MinPrices
end

---@param value table
function Data.SetMinPrices(value)
    ForeverLooterXDB.MinPrices = value
end

---@param money integer
function Data.SetAllMinPrices(money)
    for quality = Constants.ItemQuality.Min, Constants.ItemQuality.Max do
        ForeverLooterXDB.MinPrices[quality] = money
    end
end

---@param class integer
---@return boolean
function Data.IsArmorOrWeapon(class)
    return class == Constants.ItemClass.Weapon or class == Constants.ItemClass.Armor
end

---@param quality integer
---@param class integer
---@return boolean
function Data.IsLowQAndWorthIt(quality, class)
    if quality == Constants.ItemQuality.Poor and (class == Constants.ItemClass.Reagent or
            class == Constants.ItemClass.Quest or class == Constants.ItemClass.Tradegoods) then
        return true
    elseif quality == Constants.ItemQuality.Common and (class == Constants.ItemClass.Reagent or
            class == Constants.ItemClass.Quest or class == Constants.ItemClass.Tradegoods or
            class == Constants.ItemClass.Recipe or class == Constants.ItemClass.Miscellaneous or
            class == Constants.ItemClass.Key or class == Constants.ItemClass.Consumable)
    then
        return true
    end

    return false
end

---@param class integer
---@return boolean
function Data.IsDisenchantableClass(class)
    if Data.IsArmorOrWeapon(class) then
        return true
    end
    -- retail only, profession items, keep? can you loot them?
    return ForeverLooter.isRetail and (class == Constants.ItemClass.Profession)
end

---@param quality integer
---@param class integer
---@param equipLoc string|nil
---@return boolean
function Data.IsDisenchantable(quality, class, equipLoc)
    if quality < Constants.ItemQuality.DisenchantableMin
        or quality > Constants.ItemQuality.DisenchantableMax then
        return false
    end
    if equipLoc == Constants.NotDisenchantable.BodyType or equipLoc == Constants.NotDisenchantable.TabardType then
        return false
    end
    return Data.IsDisenchantableClass(class)
end

---@param quality integer
---@param class integer
---@return boolean
function Data.IsQualityManaged(quality, class)
    if quality < Constants.ItemQuality.Min or quality > Constants.ItemQuality.Max then return false end
    -- retail only for transmogs
    if quality == Constants.ItemQuality.Poor or quality == Constants.ItemQuality.Common then
        return (ForeverLooter.isRetail == true) and Data.IsArmorOrWeapon(class)
    end
    return true
end

---@return string
function Data.GetPriceSource()
    return ForeverLooterXDB.PriceSource
end

---@param source string
function Data.SetPriceSource(source)
    ForeverLooterXDB.PriceSource = source
end

---@return string
function Data.GetCurrentTSMString()
    return ForeverLooterXDB.CurrentTSMString
end

---@param tsmString string
function Data.SetTSMString(tsmString)
    local TSM_API = TSM_API
    if TSM_API == nil then
        print(_G.FOREVERLOOTER_L_TSM_NOT_AVAILABLE)
        return
    end
    if not TSM_API.IsCustomPriceValid(tsmString) then
        print(_G.FOREVERLOOTER_L_TSM_CUSTOM_STRING_NOT_VALID .. "|cFF36e8e6" .. tsmString .. "|r")
        return
    end
    ForeverLooterXDB.CurrentTSMString = tsmString
    print(_G.FOREVERLOOTER_L_TSM_CUSTOM_STRING_VALID .. "|cFF36e8e6" .. tsmString .. "|r")
end

---@return string
function Data.GetCurrentTSMDisenchantString()
    return ForeverLooterXDB.CurrentTSMDisenchantString
end

---@param tsmString string
function Data.SetTSMDisenchantString(tsmString)
    local TSM_API = TSM_API
    if TSM_API == nil then
        print(_G.FOREVERLOOTER_L_TSM_NOT_AVAILABLE)
        return
    end
    if not TSM_API.IsCustomPriceValid(tsmString) then
        print(_G.FOREVERLOOTER_L_TSM_CUSTOM_STRING_NOT_VALID .. "|cFF36e8e6" .. tsmString .. "|r")
        return
    end
    ForeverLooterXDB.CurrentTSMDisenchantString = tsmString
    print(_G.FOREVERLOOTER_L_TSM_CUSTOM_STRING_VALID .. "|cFF36e8e6" .. tsmString .. "|r")
end

---@return boolean
function Data.IsScrollLootFrameVisible()
    return ForeverLooterDB.ScrollLootFrameVisible
end

---@param visible boolean
function Data.SetScrollLootFrameVisible(visible)
    if visible ~= nil then
        ForeverLooterDB.ScrollLootFrameVisible = visible
    end
end

---@return integer
function Data.CalcGPH()
    local total = ForeverLooterDB.TotalMoney
    local timer = ForeverLooterDB.Timer

    local baseAlpha = 0.1
    local warmupSeconds = 30
    local alpha = baseAlpha * math.min(1, timer / warmupSeconds)

    local currentRate = 0
    if total > 0 and timer > 0 then
        currentRate = (total / timer) * 3600
    end

    if not ForeverLooterDB.EMA_GPH then
        ForeverLooterDB.EMA_GPH = 0
    end

    ForeverLooterDB.EMA_GPH = alpha * currentRate + (1 - alpha) * ForeverLooterDB.EMA_GPH
    return math.floor(ForeverLooterDB.EMA_GPH)
end

function Data.ResetForeverLooterDB()
    if ForeverLooterDB == nil then
        ForeverLooterDB = {}
    else
        table.wipe(ForeverLooterDB)
    end
    initialize_db()
    ForeverLooterDB.ListLootedItems = CBFunctions.New(ForeverLooterDB.ListLootedItems, Data.CBCapacity)
end

function Data.UpdateMLDB()
    initialize_db()
end

function Data.UpdateMLXDB()
    initialize_xdb()
end

---@return boolean
function Data.IsInteractionPaused()
    return ForeverLooterTempData.InteractionPaused
end

---@param paused boolean
function Data.SetInteractionPaused(paused)
    if paused == nil then return end
    ForeverLooterTempData.InteractionPaused = paused
end

function Data.IsSummaryMode()
    return ForeverLooterTempData.SummaryMode
end

function Data.SetSummaryMode(summaryMode)
    if summaryMode == nil then return end
    ForeverLooterTempData.SummaryMode = summaryMode
end

---@param lootedItem FL_Item
function Data.InsertSummaryItem(lootedItem)
    if ForeverLooterDB.Summary == nil then ForeverLooterDB.Summary = {} end
    if lootedItem == nil then return end
    ForeverLooterDB.Summary = SMFunctions.InsertLootedItem(ForeverLooterDB.Summary, lootedItem)
end

function Data.ResetSummary()
    if ForeverLooterDB.Summary ~= nil then
        table.wipe(ForeverLooterDB.Summary)
    end
    ForeverLooterDB.Summary = {}
end

function Data.GetSummary()
    if ForeverLooterDB.Summary == nil then
        ForeverLooterDB.Summary = {}
    end
    return ForeverLooterDB.Summary
end

---@return boolean State_ForceVendorPrice
function Data.ToggleForceVendorPrice()
    ForeverLooterDB.ForceVendorPrice = not ForeverLooterDB.ForceVendorPrice
    return ForeverLooterDB.ForceVendorPrice
end

---@return boolean ForceVendorPrice
function Data.GetForceVendorPrice()
    return ForeverLooterDB.ForceVendorPrice
end

---@param force boolean
function Data.SetForceVendorPrice(force)
    ForeverLooterDB.ForceVendorPrice = force
end

function Data.GetUseDisenchantValue()
    return ForeverLooterDB.UseDisenchantValue
end

---@param value boolean
function Data.SetUseDisenchantValue(value)
    ForeverLooterDB.UseDisenchantValue = value
end

function Data.GetForceUseDisenchantValue()
    return ForeverLooterDB.ForceUseDisenchantValue
end

---@param value table
function Data.SetForceUseDisenchantValue(value)
    ForeverLooterDB.ForceUseDisenchantValue = value
end

function Data.GetForceUseDisenchantValueIndex(index)
    return ForeverLooterDB.ForceUseDisenchantValue[index]
end

---@param value boolean
function Data.SetForceUseDisenchantValueIndex(value, index)
    ForeverLooterDB.ForceUseDisenchantValue[index] = value
end

---@return number
function Data.GetUIScale()
    return ForeverLooterXDB.UIScale
end

---@param scale number
function Data.SetUIScale(scale)
    if scale == nil then return end
    if scale < Constants.UIScale.Min then
        scale = Constants.UIScale.Min
    elseif scale > Constants.UIScale.Max then
        scale = Constants.UIScale.Max
    end
    ForeverLooterXDB.UIScale = scale
end
