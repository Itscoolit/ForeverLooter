---@class ForeverLooter
local ForeverLooter = select(2, ...)
---@class FL_Constants
local Constants = ForeverLooter.Constants
---@class FL_Utils
local Utils = ForeverLooter.Utils
---@class FL_DataProvider
local DataProvider = ForeverLooter.DataProvider
---@class FL_Data
local Data = ForeverLooter.Data
---@class FL_CBFunctions
local CBFunctions = ForeverLooter.CBFunctions
---@class FL_SMFunctions
local SMFunctions = ForeverLooter.SMFunctions
---@class FL_Profiler
local Profiler = ForeverLooter.Profiler

---@class FL_UI
local UI = {}
ForeverLooter.UI = UI

------------------------------------------------------------------------------
local CreateFrame = CreateFrame
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata or GetAddOnMetadata
local GetMoney = GetMoney
------------------------------------------------------------------------------
local tostring, date, print, tonumber = tostring, date, print, tonumber
local strlenutf8, ipairs, unpack = strlenutf8, ipairs, unpack
------------------------------------------------------------------------------

---@param itemId number
---@return string
local function CreateTextureFromItemID(itemId)
    return ("|T%s:0|t"):format(tostring(C_Item.GetItemIconByID(itemId)))
end

local ActionIcons = {
    [Constants.ItemAction.Sell] = "Interface\\Icons\\inv_misc_coin_02",
    [Constants.ItemAction.Auction] = "Interface\\Icons\\inv_hammer_15",
    [Constants.ItemAction.Disenchant] = "Interface\\Icons\\inv_enchant_disenchant"
}

---@class FL_ItemScrollMixin
FL_ItemScrollMixin = {}

function FL_ItemScrollMixin:OnEnter()
    local elementData = self:GetElementData()
    if not elementData then return end
    GameTooltip:SetOwner(self, "ANCHOR_BOTTOMRIGHT")
    GameTooltip:SetHyperlink(elementData.itemLink)
    GameTooltip:Show()
end

function FL_ItemScrollMixin:OnLeave()
    GameTooltip:Hide()
end

function FL_ItemScrollMixin:OnClick()
    local elementData = self:GetElementData()
    if not elementData then return end
    GameTooltip:Hide()
    SetItemRef(elementData.itemLink, elementData.itemLink, "LeftButton")
end

function FL_ItemScrollMixin:OnRemoveClick()
    local elementData = self:GetElementData()
    if not elementData then return end
    if not Data.IsSummaryMode() and elementData.entryId == nil then return end

    local confirmText = ""
    if Data.IsSummaryMode() then
        confirmText = string.format(_G.FOREVERLOOTER_L_REMOVE_CONFIRM,
            "|cffff0000" .. _G.FOREVERLOOTER_L_ALL .. "|r " .. elementData.itemLink)
    else
        confirmText = string.format(_G.FOREVERLOOTER_L_REMOVE_CONFIRM, elementData.itemLink)
    end

    StaticPopupDialogs["FOREVERLOOTER_REMOVE_ITEM"] = {
        text = confirmText,
        button1 = _G.YES,
        button2 = _G.NO,
        OnAccept = function()
            if Data.IsSummaryMode() then
                self:RemoveItemsFromSession(elementData)
            else
                self:RemoveItemFromSession(elementData)
            end
        end,
        timeout = 0,
        whileDead = true,
        hideOnEscape = true,
        preferredIndex = 3,
    }
    StaticPopup_Show("FOREVERLOOTER_REMOVE_ITEM")
end

function FL_ItemScrollMixin:RemoveItemsFromSession(elementData)
    if not elementData then return end
    Data.RemoveAllLootedItemsByID(elementData)
end

function FL_ItemScrollMixin:RemoveItemFromSession(elementData)
    if not elementData then return end
    Data.RemoveLootedItem(elementData)
end

function FL_ItemScrollMixin:Init()
    ---@class FL_Item
    local elementData = self:GetElementData()
    self:SetRightText(elementData.value * elementData.quantity, elementData.action)
    self:SetLeftText(elementData.id, elementData.quantity, elementData.itemLink)
    self.RemoveButton:SetShown(Data.IsSummaryMode() or elementData.entryId ~= nil)
    self:TrimDataProvider()
end

---@param alternate boolean
function FL_ItemScrollMixin:SetAlternateOverlayShown(alternate)
    self.Alternate:SetShown(alternate)
end

---@param id number
---@param quantity number
---@param itemLink string
function FL_ItemScrollMixin:SetLeftText(id, quantity, itemLink)
    self.LeftLabel:SetText(DARKYELLOW_FONT_COLOR:WrapTextInColorCode(("%dx %s%s"):format(quantity,
        CreateTextureFromItemID(id), itemLink)))
end

---@param value number
---@param action string|nil
function FL_ItemScrollMixin:SetRightText(value, action)
    local text = Utils.GetCoinTextString(value)
    if action and ActionIcons[action] then
        text = text .. " " .. ("|T%s:0|t"):format(ActionIcons[action])
    end
    self.RightLabel:SetText(text)
end

function FL_ItemScrollMixin:TrimDataProvider()
    local dataProvider = self:GetParent().DataProvider
    if not dataProvider then return end

    local maxCapacity = ForeverLooter.Data.CBCapacity
    local dataProviderSize = dataProvider:GetSize()

    if dataProviderSize > maxCapacity then
        local extra = math.floor(maxCapacity * 0.25)
        local overflow = dataProviderSize - maxCapacity
        dataProvider:RemoveIndexRange(1, overflow + extra)
    end
end

---@param seconds number
---@return string
local function FormatTime(seconds)
    local h = math.floor(seconds / 3600)
    local m = math.floor((seconds % 3600) / 60)
    local s = seconds % 60

    return string.format("%02d:%02d:%02d", h, m, s)
end

---@param time integer
---@param rawGold integer
---@param itemsGold integer
---@param gph integer
---@param priciest integer
local function UpdateAllTexts(time, rawGold, itemsGold, gph, priciest)
    Data.SetOldMoney(GetMoney())
    UI.FLMainFrame.StartButton:SetText(Data.GetCurrentStartText())
    UI.FLMainFrame.TimeFS:SetText(tostring(FormatTime(time)))
    UI.FLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(rawGold))
    UI.FLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(itemsGold))
    UI.FLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(gph))
    UI.FLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(priciest))
end

local function UpdateTexts()
    UI.FLMainFrame.TimeFS:SetText(tostring(FormatTime(Data.AddOneToTimer())))
    UI.FLMainFrame.GPHFS:SetText(Utils.GetCoinTextString(Data.CalcGPH()))
end

---@param visible boolean
local function SetMainVisible(visible)
    Data.SetVisible(visible)
    if visible then
        UI.FLMainFrame:Show()
    else
        UI.FLMainFrame:Hide()
    end
end

---@param visible boolean
local function SetScrollVisible(visible)
    Data.SetScrollLootFrameVisible(visible)
    if visible then
        UI.FLMainFrame.ScrollBoxLoot.Inset:Show()
        UI.FLMainFrame.ScrollBoxLoot:Show()
    else
        UI.FLMainFrame.ScrollBoxLoot:Hide()
        UI.FLMainFrame.ScrollBoxLoot.Inset:Hide()
    end
    UI.FLMainFrame.MinimizeButton.Icon:SetAtlas(visible and "RedButton-Condense" or "RedButton-Expand")
end

local function RebuildSummary()
    Profiler.Start("RebuildSummary")
    Data.ResetSummary()
    CBFunctions.Iterate(Data.GetListLootedItems(), Data.InsertSummaryItem)
    Profiler.Stop("RebuildSummary")
end

local function PopulateSummary()
    RebuildSummary()
    Profiler.Start("PopulateSummary")
    UI.FLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    local topItems = SMFunctions.GetTopItems(Data.GetSummary())
    Profiler.Start("PopulateSummary.BulkInsert")
    UI.FLMainFrame.ScrollBoxLoot.DataProvider:BulkInsert(unpack(topItems))
    Profiler.Stop("PopulateSummary.BulkInsert")
    Profiler.Stop("PopulateSummary")
end

local function PopulateLoot()
    Profiler.Start("PopulateLoot")
    Data.InitListLootedItems()
    UI.FLMainFrame.ScrollBoxLoot.DataProvider:Flush()
    if Data.GetListLootedItemsCount() > 0 then
        local lootedItems = CBFunctions.ToTable(Data.GetListLootedItems())
        Profiler.Start("PopulateLoot.BulkInsert")
        UI.FLMainFrame.ScrollBoxLoot.DataProvider:BulkInsert(unpack(lootedItems))
        Profiler.Stop("PopulateLoot.BulkInsert")
    end
    UI.FLMainFrame.ScrollBoxLoot:ScrollToEnd()
    Profiler.Stop("PopulateLoot")
end

local ForeverLooterLootEvents = CreateFrame("Frame")

---@type FunctionContainer
local timer

local EVENTS = {
    Constants.Events.ChatMsgMoney,
    Constants.Events.ChatMsgLoot,
    Constants.Events.QuestTurnedIn,
    Constants.Events.PInteractionManagerShow,
    Constants.Events.PInteractionManagerHide,
    Constants.Events.ChatMsgSystem,
}

local function RegisterStartEvents()
    for _, ev in ipairs(EVENTS) do
        ForeverLooterLootEvents:RegisterEvent(ev)
    end
    ForeverLooterLootEvents:SetScript("OnEvent", ForeverLooter.Core.OnEvent)

    timer = C_Timer.NewTicker(1, UpdateTexts)
end

local function UnregisterStartEvents()
    ForeverLooterLootEvents:UnregisterAllEvents()
    ForeverLooterLootEvents:SetScript("OnEvent", nil)

    if not timer:IsCancelled() then timer:Cancel() end
end

local function PopulateData()
    Constants.Strings.AddonVersion = GetAddOnMetadata(Constants.Strings.AddonName, "Version")
    ForeverLooter.Config.ApplyScale()

    UpdateAllTexts(Data.GetTimer(), Data.GetRawMoney(), Data.GetItemsMoney(), Data.CalcGPH(), Data.GetPriciest())

    SetScrollVisible(Data.IsScrollLootFrameVisible())
    SetMainVisible(Data.IsVisible())

    if Data.IsRunning() then RegisterStartEvents() end
end

function UI.UpdateRawMoney()
    UI.FLMainFrame.RawGoldFS:SetText(Utils.GetCoinTextString(Data.GetRawMoney()))
end

---@param item FL_Item
function UI.UpdateLoot(item)
    if not Data.IsSummaryMode() then
        Profiler.Start("UpdateLoot.SingleInsert")
        UI.FLMainFrame.ScrollBoxLoot.DataProvider:SingleInsert(item)
        Profiler.Stop("UpdateLoot.SingleInsert")
        UI.FLMainFrame.ScrollBoxLoot:ScrollToEnd()
    else
        PopulateSummary()
    end
    UI.FLMainFrame.PriciestFS:SetText(Utils.GetCoinTextString(Data.GetPriciest()))
    UI.FLMainFrame.ItemsGoldFS:SetText(Utils.GetCoinTextString(Data.GetItemsMoney()))
end

---@param parent FL_MainFrame
---@return table|Frame
local function CreateTitleBar(parent)
    local titleBar = parent.TitleContainer
    titleBar.Label = titleBar.TitleText
    titleBar.Label:SetText(Constants.Strings.Title)
    return titleBar
end

---@param parent FL_MainFrame
---@return table|Button
local function CreateCloseButton(parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(20, 20)
    btn:SetPoint("TOPRIGHT", parent, "TOPRIGHT", -4, -1)
    btn:SetFrameLevel(parent.TitleContainer:GetFrameLevel() + 1)

    btn.Icon = btn:CreateTexture(nil, "ARTWORK")
    btn.Icon:SetAllPoints()
    btn.Icon:SetAtlas("RedButton-Exit")

    btn:SetScript(Constants.Events.OnClick, function()
        SetMainVisible(false)
        print(_G.FOREVERLOOTER_L_CLOSE)
    end)

    return btn
end

---@param parent FL_MainFrame
---@return table|Button
local function CreateMinimizeButton(parent)
    local button = CreateFrame("Button", nil, parent)
    button:SetSize(20, 20)
    button:RegisterForClicks("AnyUp")

    button.Icon = button:CreateTexture(nil, "ARTWORK")
    button.Icon:SetAllPoints()
    button.Icon:SetAtlas("RedButton-Condense")

    button:SetScript(Constants.Events.OnClick, function(_, mouseButton)
        if mouseButton == Constants.Inputs.RightButton then
            local mode = not Data.IsSummaryMode()
            Data.SetSummaryMode(mode)
            if mode then
                PopulateSummary()
            else
                PopulateLoot()
            end
        else
            SetScrollVisible(not Data.IsScrollLootFrameVisible())
        end
    end)
    button:SetScript(Constants.Events.OnEnter, function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        local visible = Data.IsScrollLootFrameVisible()
        GameTooltip:SetText(visible
            and (_G.FOREVERLOOTER_L_HIDE_LOOT_LOG or "Hide loot log")
            or (_G.FOREVERLOOTER_L_SHOW_LOOT_LOG or "Show loot log"))
        GameTooltip:AddLine(_G.FOREVERLOOTER_L_SUMMARY_MODE_HELP or "Right-click to toggle summary", 1, 1, 1)
        GameTooltip:Show()
    end)
    button:SetScript(Constants.Events.OnLeave, function(self)
        if GameTooltip:IsOwned(self) then GameTooltip:Hide() end
    end)

    return button
end

---@param parent FL_MainFrame
---@return table|Button
local function CreateStartButton(parent)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(65, 20)
    button:SetText(_G.FOREVERLOOTER_L_START)

    button:SetScript(Constants.Events.OnClick, function()
        if Data.IsRunning() then
            Data.SetRunning(false)
            button:SetText(Data.SetCurrentStartText(_G.FOREVERLOOTER_L_CONTINUE))
            UnregisterStartEvents()
        else
            Data.SetRunning(true)
            Data.SetOldMoney(GetMoney())
            button:SetText(Data.SetCurrentStartText(_G.FOREVERLOOTER_L_PAUSE))
            RegisterStartEvents()
        end
    end)

    return button
end

---@param parent FL_MainFrame
---@return table|Button
local function CreateResetButton(parent)
    local button = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
    button:SetSize(52, 20)
    button:SetText(_G.FOREVERLOOTER_L_RESET)

    button:SetScript(Constants.Events.OnClick, function()
        if Data.IsRunning() then UnregisterStartEvents() end

        local forceVendor = Data.GetForceVendorPrice()
        local disenchant = Data.GetUseDisenchantValue()
        local forceDisenchant = Data.GetForceUseDisenchantValue()
        local scrollVisible = Data.IsScrollLootFrameVisible()
        Data.ResetForeverLooterDB()
        ForeverLooter.Core.ClearPriceCache()
        UpdateAllTexts(0, 0, 0, 0, 0)
        UI.FLMainFrame.ScrollBoxLoot.DataProvider:Flush()
        Data.SetScrollLootFrameVisible(scrollVisible)
        Data.SetForceVendorPrice(forceVendor)
        Data.SetUseDisenchantValue(disenchant)
        Data.SetForceUseDisenchantValue(forceDisenchant)
    end)

    return button
end

---@param parent FL_MainFrame
---@return table|Button
local function CreateConfigButton(parent)
    local btn = CreateFrame("Button", nil, parent)
    btn:SetSize(20, 20)

    btn:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
    btn:GetNormalTexture():SetDesaturated(true)

    btn:SetHighlightTexture("Interface\\Buttons\\UI-OptionsButton")
    btn:GetHighlightTexture():SetDesaturated(true)
    btn:GetHighlightTexture():SetVertexColor(1.4, 1.4, 1.4, 1)

    btn:SetPushedTexture("Interface\\Buttons\\UI-OptionsButton")
    btn:GetPushedTexture():SetDesaturated(true)
    btn:GetPushedTexture():SetVertexColor(0.6, 0.6, 0.6, 1)

    btn:SetScript(Constants.Events.OnClick, function()
        ForeverLooter.Config.Toggle()
    end)

    return btn
end

---@param parent FL_MainFrame
---@return table
local function CreateStatisticLabels(parent)
    ---@param stat table
    ---@return FontString, FontString
    local function createLabelPair(stat)
        local label = parent:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
        label:SetPoint("TOPLEFT", 16, stat[3])
        label:SetText(stat[1])
        label:SetTextColor(0.82, 0.75, 0.59)

        local value = parent:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        value:SetPoint("TOPRIGHT", -8, stat[3])
        value:SetJustifyH("RIGHT")
        if stat[2] then value:SetText(stat[2]) end

        return label, value
    end

    local yOffset = -40
    local yStep = -20
    local stats = {
        { _G.FOREVERLOOTER_L_TIME_LABEL,     tostring(date("!%X", 0)), yOffset },
        { _G.FOREVERLOOTER_L_GOLD_LABEL,     nil,                      yOffset + yStep },
        { _G.FOREVERLOOTER_L_ITEMS_LABEL,    nil,                      yOffset + yStep * 2 },
        { _G.FOREVERLOOTER_L_GPH_LABEL,      nil,                      yOffset + yStep * 3 },
        { _G.FOREVERLOOTER_L_PRICIEST_LABEL, nil,                      yOffset + yStep * 4 }
    }

    local labels = {}
    labels.TimeLabel, labels.Time = createLabelPair(stats[1])
    labels.RawGoldLabel, labels.RawGold = createLabelPair(stats[2])
    labels.ItemsGoldLabel, labels.ItemsGold = createLabelPair(stats[3])
    labels.GPHLabel, labels.GPH = createLabelPair(stats[4])
    labels.PriciestLabel, labels.Priciest = createLabelPair(stats[5])

    labels.Priciest:SetScript(Constants.Events.OnEnter, function()
        local priciestLink = Data.GetPriciestLink()
        if priciestLink == nil or priciestLink == "" then return end
        GameTooltip:SetOwner(labels.Priciest, "ANCHOR_BOTTOMRIGHT")
        GameTooltip:SetHyperlink(priciestLink)
        GameTooltip:Show()
    end)
    labels.Priciest:SetScript(Constants.Events.OnLeave, function()
        GameTooltip:Hide()
    end)

    return labels
end

---@param parent FL_MainFrame
---@return table|Frame
local function CreateLootScrollBox(parent)
    local scrollBox = CreateFrame("Frame", nil, parent, "FL_WowScrollBoxList")
    scrollBox:SetResizable(true)
    scrollBox.Inset = CreateFrame("Frame", nil, parent, "InsetFrameTemplate")
    scrollBox.Inset:SetPoint("TOPLEFT", scrollBox, "TOPLEFT", -4, 4)
    scrollBox.Inset:SetPoint("BOTTOMRIGHT", scrollBox, "BOTTOMRIGHT", 4, 0)
    scrollBox.Inset:SetFrameLevel(math.max(0, scrollBox:GetFrameLevel() - 1))

    scrollBox.ScrollBar = CreateFrame("EventFrame", nil, scrollBox, "MinimalScrollBar")
    scrollBox.ElementFactory = function(factory)
        factory("FL_ItemScroll", function(button, elementData)
            button:Init(elementData)
        end)
    end
    -- scrollBox.ElementFactory = {}
    scrollBox.DataProvider = DataProvider.CreateDataProvider()
    scrollBox.ScrollView = CreateScrollBoxListLinearView()
    scrollBox.ScrollView:SetElementFactory(scrollBox.ElementFactory)
    scrollBox.ScrollView:SetDataProvider(scrollBox.DataProvider)

    ---@param frame Frame
    ---@param alternate boolean
    local function ApplyAlternateState(frame, alternate)
        frame:SetAlternateOverlayShown(alternate)
    end

    ---@param button Button
    local function Initializer(button)
        button:Init()
    end

    ScrollUtil.InitScrollBoxListWithScrollBar(scrollBox, scrollBox.ScrollBar, scrollBox.ScrollView)
    ScrollUtil.RegisterAlternateRowBehavior(scrollBox, ApplyAlternateState)
    scrollBox.ScrollView:SetElementInitializer("FL_ItemScroll", Initializer)

    return scrollBox
end

---@param parent FL_MainFrame
---@return table|Button
local function CreateResizeGrip(parent)
    local grip = CreateFrame("Button", nil, parent)
    grip:SetPoint("BOTTOMRIGHT", 0, 0)
    grip:SetSize(16, 16)
    grip:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
    grip:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
    grip:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")

    grip:SetScript(Constants.Events.OnMouseDown, function(self)
        self:GetParent():StartSizing("BOTTOMRIGHT")
    end)
    grip:SetScript(Constants.Events.OnMouseUp, function(self)
        self:GetParent():StopMovingOrSizing()
    end)
    return grip
end

---@return table|Frame|FL_MainFrame
local function CreateMainFrame()
    local mainFrame = CreateFrame("Frame", "FOREVERLOOTER_MAIN_FRAME", UIParent, "FL_MainFrame")
    mainFrame:SetPoint("CENTER")
    mainFrame:EnableMouse(true)
    mainFrame:SetMovable(true)
    mainFrame:RegisterForDrag(Constants.Inputs.LeftButton)

    mainFrame:SetResizable(true)

    mainFrame.TitleBar = CreateTitleBar(mainFrame)
    mainFrame.CloseButton = CreateCloseButton(mainFrame)
    mainFrame.StartButton = CreateStartButton(mainFrame)
    mainFrame.ResetButton = CreateResetButton(mainFrame)
    mainFrame.ConfigButton = CreateConfigButton(mainFrame)
    mainFrame.MinimizeButton = CreateMinimizeButton(mainFrame)

    local stats = CreateStatisticLabels(mainFrame)
    mainFrame.TimeLabelFS = stats.TimeLabel
    mainFrame.TimeFS = stats.Time
    mainFrame.RawGoldLabelFS = stats.RawGoldLabel
    mainFrame.RawGoldFS = stats.RawGold
    mainFrame.ItemsGoldLabelFS = stats.ItemsGoldLabel
    mainFrame.ItemsGoldFS = stats.ItemsGold
    mainFrame.GPHLabelFS = stats.GPHLabel
    mainFrame.GPHFS = stats.GPH
    mainFrame.PriciestLabelFS = stats.PriciestLabel
    mainFrame.PriciestFS = stats.Priciest

    mainFrame.StatsDivider = mainFrame:CreateTexture(nil, "BORDER")
    mainFrame.StatsDivider:SetColorTexture(0.65, 0.55, 0.35, 0.35)
    mainFrame.StatsDivider:SetHeight(1)
    mainFrame.StatsDivider:SetPoint("TOPLEFT", 8, -137)
    mainFrame.StatsDivider:SetPoint("TOPRIGHT", -8, -137)

    mainFrame.ScrollBoxLoot = CreateLootScrollBox(mainFrame)
    mainFrame.ScrollLootBar = mainFrame.ScrollBoxLoot.ScrollBar

    mainFrame.ResizeGrip = CreateResizeGrip(mainFrame)

    function mainFrame:UpdateLayout(width, height)
        local MIN_WIDTH, MIN_HEIGHT = 198, 170
        local MAX_WIDTH, MAX_HEIGHT = 300, 400

        if width < MIN_WIDTH then
            width = MIN_WIDTH
        end
        if width > MAX_WIDTH then
            width = MAX_WIDTH
        end
        if height < MIN_HEIGHT then
            height = MIN_HEIGHT
        end
        if height > MAX_HEIGHT then
            height = MAX_HEIGHT
        end

        self.StartButton:ClearAllPoints()
        self.StartButton:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT", 9, 5)
        self.MinimizeButton:ClearAllPoints()
        self.MinimizeButton:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT", -4, 5)
        local controlWidth = self.StartButton:GetWidth() + self.ResetButton:GetWidth()
            + self.ConfigButton:GetWidth() + self.MinimizeButton:GetWidth()
        local controlGap = math.max(4, (width - 9 - 20 - controlWidth) / 3)
        self.ConfigButton:ClearAllPoints()
        self.ConfigButton:SetPoint("BOTTOMRIGHT", self.MinimizeButton, "BOTTOMLEFT", -controlGap, 0)
        self.ResetButton:ClearAllPoints()
        self.ResetButton:SetPoint("BOTTOMLEFT", self.StartButton, "BOTTOMRIGHT", controlGap, 0)

        self.TitleBar:SetWidth(width)

        self.ScrollBoxLoot:ClearAllPoints()
        self.ScrollBoxLoot:SetPoint("TOPLEFT", width, 0)

        self.ScrollBoxLoot:SetSize(width * 1.5, height)
        self:SetSize(width, height)
    end

    mainFrame:SetScript("OnSizeChanged", function(frame, width, height)
        frame:UpdateLayout(width, height)
    end)

    mainFrame:SetScript(Constants.Events.OnDragStart, mainFrame.StartMoving)
    mainFrame:SetScript(Constants.Events.OnDragStop, mainFrame.StopMovingOrSizing)
    mainFrame:SetScript(Constants.Events.OnHide, mainFrame.StopMovingOrSizing)

    local initialWidth, initialHeight = mainFrame:GetSize()
    mainFrame:UpdateLayout(initialWidth, initialHeight)

    return mainFrame
end

---@class FL_MainFrame : Frame
UI.FLMainFrame = CreateMainFrame()

Data.RegisterCallback("FL_OnItemRemoved", function()
    UpdateAllTexts(Data.GetTimer(), Data.GetRawMoney(), Data.GetItemsMoney(), Data.CalcGPH(), Data.GetPriciest())

    if not Data.IsSummaryMode() then
        PopulateLoot()
    else
        PopulateSummary()
    end
end)

SLASH_FOREVERLOOTER1 = "/flo"
SLASH_FOREVERLOOTER2 = "/foreverlooter"

local function ParseCustomString(msg)
    local _, tsmString = string.split(" ", msg, 2)
    if tsmString == nil or tsmString == "" then
        print(_G.FOREVERLOOTER_L_TSM_CUSTOM_STRING .. "|cFF36e8e6" .. Data.GetCurrentTSMString() .. "|r")
        return
    end
    Data.SetTSMString(tsmString)
end

local function ParseMinPrice(msg)
    local mprice, value, coin = string.split(" ", msg, 3)
    if strlenutf8(mprice) < 7 then
        print(_G.FOREVERLOOTER_L_MPRICE_ERROR)
        return
    end
    local coinValue
    if coin == nil or coin == "g" then
        coinValue = 10000
        coin = "G"
    elseif coin == "s" then
        coinValue = 100
        coin = "S"
    elseif coin == "c" then
        coinValue = 1
        coin = "C"
    else
        print(_G.FOREVERLOOTER_L_MPRICE_UNRECOGNIZED_COIN)
        return
    end
    local qualifier = string.sub(mprice, 7, 8)
    local copper = tonumber(value) * coinValue
    local quality
    if qualifier == "x" then
        quality = 99
        Data.SetAllMinPrices(copper)
    else
        quality = tonumber(qualifier)
        if quality == nil or quality < Constants.ItemQuality.Min or quality > Constants.ItemQuality.Max then
            print(_G.FOREVERLOOTER_L_MPRICE_ERROR)
            return
        end
        Data.SetMinPrice(quality, copper)
    end
    print(string.format("%s |cFF36e8e6%s %s|r - %s [%s]", _G.FOREVERLOOTER_L_MPRICE_VALID, tostring(value),
        _G["FOREVERLOOTER_L_MPRICE_COIN_" .. coin], Utils.GetQualityName(quality), tostring(qualifier)))
end

local function ParseTime(msg)
    local _, time = string.split(" ", msg, 2)
    if time == nil or strlenutf8(time) < 1 then
        print(_G.FOREVERLOOTER_L_TIME_ERROR)
        return 0
    end
    local hours = nil
    local minutes = nil
    local seconds = nil
    if string.find(time, "h") then
        hours, time = string.split("h", time, 2)
    end
    if string.find(time, "m") then
        minutes, time = string.split("m", time, 2)
    end
    if string.find(time, "s") then
        seconds = string.split("s", time, 2)
    end
    local total = tonumber(0)
    if seconds ~= nil then
        total = total + tonumber(seconds)
    end
    if minutes ~= nil then
        total = total + (tonumber(minutes) * 60)
    end
    if hours ~= nil then
        total = total + (tonumber(hours) * 60 * 60)
    end
    return total
end

local function slash(msg, _)
    local mainVisible = Data.IsVisible()
    if msg == "show" or (msg == "" and not mainVisible) then
        SetMainVisible(true)
    elseif msg == "hide" or (msg == "" and mainVisible) then
        SetMainVisible(false)
    elseif msg == "info" then
        print(_G.FOREVERLOOTER_L_INFO)
    elseif msg == "forcevendorprice" then
        local state = Data.ToggleForceVendorPrice()
        if state then
            print(_G.FOREVERLOOTER_L_FORCE_VENDOR_PRICE_ENABLED)
        else
            print(_G.FOREVERLOOTER_L_FORCE_VENDOR_PRICE_DISABLED)
        end
    elseif string.sub(msg, 1, 6) == "custom" then
        ParseCustomString(msg)
    elseif string.sub(msg, 1, 6) == "mprice" then
        ParseMinPrice(msg)
    elseif string.sub(msg, 1, 10) == "disenchant" then
        local enable = not Data.GetUseDisenchantValue()
        Data.SetUseDisenchantValue(enable)
        if enable then
            print(_G.FOREVERLOOTER_L_USE_DISENCHANT_VALUE_ENABLED)
        else
            print(_G.FOREVERLOOTER_L_USE_DISENCHANT_VALUE_DISABLED)
        end
    elseif string.sub(msg, 1, 7) == "addtime" then
        local time = ParseTime(msg)
        if time > 0 then
            Data.AddXToTimer(time)
        end
    elseif string.sub(msg, 1, 7) == "subtime" then
        local time = ParseTime(msg)
        if time > 0 then
            Data.SubXFromTimer(time)
        end
    elseif msg == "profiler" then
        Profiler.ToggleProfiler()
    else
        print(_G.FOREVERLOOTER_L_USAGE .. Constants.Strings.AddonVersion)
    end
end
SlashCmdList["FOREVERLOOTER"] = slash

local watcher = CreateFrame("Frame")

local addonLoaded = false
local function WatcherOnEvent(_, event, arg1)
    if event == Constants.Events.AddonLoaded and arg1 == Constants.Strings.AddonName then
        addonLoaded = true
        watcher:UnregisterEvent(Constants.Events.AddonLoaded)
    elseif event == Constants.Events.PlayerEnteringWorld and addonLoaded then
        Data.UpdateMLDB()
        Data.UpdateMLXDB()
        PopulateData()
        PopulateLoot()
        watcher:UnregisterEvent(Constants.Events.PlayerEnteringWorld)
    end
end

watcher:RegisterEvent(Constants.Events.AddonLoaded)
watcher:RegisterEvent(Constants.Events.PlayerEnteringWorld)
watcher:SetScript(Constants.Events.OnEvent, WatcherOnEvent)
