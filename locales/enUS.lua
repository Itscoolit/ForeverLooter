---@class ForeverLooter
local ForeverLooter = select(2, ...)

---@class FL_Locales
local Locales = ForeverLooter.Locales

Locales.enUS = function()
    local L = {}
    L["START"] = "Start"
    L["CONTINUE"] = "Continue"
    L["PAUSE"] = "Pause"
    L["RESET"] = "Reset"
    L["HIDE_LOOT_LOG"] = "Hide loot log"
    L["SHOW_LOOT_LOG"] = "Show loot log"
    L["SUMMARY_MODE_HELP"] = "Right-click to toggle summary"
    L["CONFIG_TITLE"] = "ForeverLooter Configuration"
    L["CONFIG_UI_SCALE"] = "UI Scale"
    L["CONFIG_FORCE_VENDOR_PRICE"] = "Force vendor price"
    L["CONFIG_USE_DISENCHANT_VALUE"] = "Use disenchant value"
    L["CONFIG_PRICE_SOURCE"] = "Price source"
    L["CONFIG_FORCE_USE_DISENCHANT_VALUE"] = "Force disenchant"
    L["CONFIG_TSM_STRING"] = "TSM custom string"
    L["CONFIG_TSM_DISENCHANT_STRING"] = "TSM disenchant string"
    L["CONFIG_MIN_PRICES"] = "Minimum prices"
    L["CONFIG_VALIDATE"] = "Validate"
    L["CONFIG_RESET"] = "Reset"
    L["CONFIG_SAVE"] = "Save"
    L["CONFIG_TSM_VALID"] = "Valid TSM string"
    L["CONFIG_TSM_INVALID"] = "Invalid TSM string"
    L["CONFIG_TSM_EMPTY"] = "TSM string is empty"
    L["CONFIG_TSM_NOT_AVAILABLE"] = "TSM is not available"
    L["CONFIG_SAVE_ERROR_TSM"] = "Cannot save: TSM string is invalid"
    L["CONFIG_SAVED"] = "Configuration saved"
    L["TIME_LABEL"] = "Time:"
    L["GOLD_LABEL"] = "Gold:"
    L["ITEMS_LABEL"] = "Items:"
    L["GPH_LABEL"] = "GPH:"
    L["PRICIEST_LABEL"] = "Priciest:"
    L["USAGE"] = [[====== |cFFd8de35ForeverLooter Usage Info|r ======
  |cFF36e8e6/flo|r: Toggle Show/Hide
  |cFF36e8e6/flo|r |cFFf1f488help|r: Show the help
  |cFF36e8e6/flo|r |cFFf1f488show|r: Show ForeverLooter
  |cFF36e8e6/flo|r |cFFf1f488hide|r: Hide ForeverLooter
  |cFF36e8e6/flo|r |cFFf1f488info|r: Shows info about the addon.
  |cFF36e8e6/flo|r |cFFf1f488custom 'custom TSM string'|r: Sets a custom TSM string to be used in the price calculation. If empty, returns the custom TSM string it's currently using.
    Examples: /flo custom dbmarket
              /flo custom
  |cFF36e8e6/flo|r |cFFf1f488mprice 'value'|r: Sets the minimum price threshold for a given quality.
            mpricex: All available qualities.
            mprice0: Quality 0 - Poor - Grey
            mprice1: Quality 1 - Common - White
            mprice2: Quality 2 - Uncommon - Green
            mprice3: Quality 3 - Rare - Blue
            mprice4: Quality 4 - Epic - Purple
    Examples: /flo mprice0 50 s
              /flo mprice1 50 s
              /flo mprice2 5000
              /flo mprice3 500 g
              /flo mprice4 5 c
      The price format for mprice is a number followed by g(old), s(ilver) or c(opper). If you only specify the number, gold will be used by default.
      |cFF36e8e6/flo|r |cFFf1f488disenchant|r: Enable/disable the use of the disenchantment value for looted items (if it's higher than the direct auction value).
  |cFF36e8e6Addon version:|r ]]
    L["WELCOME"] = "Welcome to |cFFd8de35ForeverLooter|r! Use |cFF36e8e6/flo|r |cFFf1f488help|r for addon options."
    L["CLOSE"] = "|cFF36e8e6/flo|r |cFFf1f488show|r: Show again |cFFd8de35ForeverLooter|r"
    L["INFO"] = "|cFFd8de35ForeverLooter|r lightweight and fast loot tracker addon created by Will0w7."
    L["TSM_NOT_AVAILABLE"] = "|cFFd8de35ForeverLooter:|r TSM is not available."
    L["TSM_CUSTOM_STRING_NOT_VALID"] =
    "|cFFd8de35ForeverLooter:|r The next TSM custom string is not valid and was not set: "
    L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35ForeverLooter:|r The next TSM custom string is valid and was set: "
    L["TSM_CUSTOM_STRING"] = "|cFFd8de35ForeverLooter:|r Using the next TSM custom string: "
    L["NEW_DB_VERSION"] = "|cFFd8de35ForeverLooter:|r A new version of the database has been detected, updating..."
    L["DB_UPDATED"] = "|cFFd8de35ForeverLooter:|r The database has been updated successfully!"
    L["MPRICE_ERROR"] = "|cFFd8de35ForeverLooter:|r The next minimum price is invalid: "
    L["MPRICE_VALID"] = "|cFFd8de35ForeverLooter:|r The next minimum price is valid and was set:"
    L["MPRICE_QUALITY_1"] = "Common"
    L["MPRICE_QUALITY_2"] = "Uncommon"
    L["MPRICE_QUALITY_3"] = "Rare"
    L["MPRICE_QUALITY_4"] = "Epic"
    L["MPRICE_QUALITY_99"] = "All qualities"
    L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35ForeverLooter:|r Unrecognized coin, check input."
    L["MPRICE_COIN_G"] = "Gold"
    L["MPRICE_COIN_S"] = "Silver"
    L["MPRICE_COIN_C"] = "Copper"
    L["FORCE_VENDOR_PRICE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Force vendor price enabled. Using only vendor sell price."
    L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35ForeverLooter:|r Force vendor price disabled."
    L["TIME_ERROR"] =
    "|cFFd8de35ForeverLooter:|r The format is incorrect, it must be: 00h00m00s or any time combination (5m30s)"
    L["REMOVE_CONFIRM"] = "Remove %s from session total?"
    L["ALL"] = "ALL"
    L["USE_DISENCHANT_VALUE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Using disenchantment value when it is higher than the direct auction price."
    L["USE_DISENCHANT_VALUE_DISABLED"] =
    "|cFFd8de35ForeverLooter:|r Disenchantment value is no longer used. The direct auction price will always be used."
    return L
end
