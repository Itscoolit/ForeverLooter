---@class ForeverLooter
local ForeverLooter = select(2, ...)

---@class FL_Locales
local Locales = ForeverLooter.Locales

Locales.deDE = function()
    local L = {}
    L["START"] = "Starten"
    L["CONTINUE"] = "Fortsetzen"
    L["PAUSE"] = "Pause"
    L["RESET"] = "Zurücksetzen"
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
    L["TIME_LABEL"] = "Zeit:"
    L["GOLD_LABEL"] = "Gold:"
    L["ITEMS_LABEL"] = "Items:"
    L["GPH_LABEL"] = "GPH:"
    L["PRICIEST_LABEL"] = "Teuerster:"
    L["USAGE"] = [[====== |cFFd8de35ForeverLooter Nutzungsinfo|r ======
  |cFF36e8e6/flo|r: Anzeigen/Ausblenden umschalten
  |cFF36e8e6/flo|r |cFFf1f488help|r: Hilfe anzeigen
  |cFF36e8e6/flo|r |cFFf1f488show|r: ForeverLooter anzeigen
  |cFF36e8e6/flo|r |cFFf1f488hide|r: ForeverLooter ausblenden
  |cFF36e8e6/flo|r |cFFf1f488info|r: Infos über das Addon zeigen.
  |cFF36e8e6/flo|r |cFFf1f488custom 'eigene TSM-Zeichenkette'|r: Legt die eigene TSM-Zeichenkette fest, die für die Preisberechnung verwendet wird. Falls leer, wird die aktuelle Zeichenkette angezeigt.
    Beispiele: /flo custom dbmarket
              /flo custom
  |cFF36e8e6/flo|r |cFFf1f488mprice 'wert'|r: Legt den Mindestpreis für eine Qualität fest.
            mpricex: Alle Qualitätsstufen.
            mprice1: Qualität 1 - Normal - Weiß
            mprice2: Qualität 2 - Ungewöhnlich - Grün
            mprice3: Qualität 3 - Selten - Blau
            mprice4: Qualität 4 - Episch - Lila
      Die restlichen Qualitäten nutzen den Händlerpreis, falls vorhanden.
    Beispiele: /flo mprice1 50 s
              /flo mprice2 5000
              /flo mprice3 500 g
              /flo mprice4 5 c
      Das Preisformat für mprice ist eine Zahl gefolgt von g (Gold), s (Silber) oder c (Kupfer). Wird nur die Zahl angegeben, gilt Gold als Standard.
      |cFF36e8e6/flo|r |cFFf1f488disenchant|r: Enable/disable the use of the disenchantment value for looted items (if it's higher than the direct auction value).
  |cFF36e8e6Addon Version:|r ]]
    L["WELCOME"] =
    "Willkommen bei |cFFd8de35ForeverLooter|r! Benutze |cFF36e8e6/flo|r |cFFf1f488help|r für Addon-Optionen."
    L["CLOSE"] = "|cFF36e8e6/flo|r |cFFf1f488show|r: Noch einmal anzeigen |cFFd8de35ForeverLooter|r"
    L["INFO"] =
    "|cFFd8de35ForeverLooter|r ist ein leichtgewichtiges und schnelles Loot-Tracker-Addon, erstellt von Will0w7."
    L["TSM_NOT_AVAILABLE"] = "|cFFd8de35ForeverLooter:|r TSM ist nicht verfügbar."
    L["TSM_CUSTOM_STRING_NOT_VALID"] =
    "|cFFd8de35ForeverLooter:|r Die angegebene TSM-Zeichenkette ist ungültig und wurde nicht gesetzt: "
    L["TSM_CUSTOM_STRING_VALID"] =
    "|cFFd8de35ForeverLooter:|r Die angegebene TSM-Zeichenkette ist gültig und wurde gesetzt: "
    L["TSM_CUSTOM_STRING"] = "|cFFd8de35ForeverLooter:|r Verwende die folgende TSM-Zeichenkette: "
    L["NEW_DB_VERSION"] = "|cFFd8de35ForeverLooter:|r Es wurde eine neue Datenbankversion erkannt, aktualisiere…"
    L["DB_UPDATED"] = "|cFFd8de35ForeverLooter:|r Die Datenbank wurde erfolgreich aktualisiert!"
    L["MPRICE_ERROR"] = "|cFFd8de35ForeverLooter:|r Der angegebene Mindestpreis ist ungültig: "
    L["MPRICE_VALID"] = "|cFFd8de35ForeverLooter:|r Der neue Mindestpreis ist gültig und wurde gesetzt:"
    L["MPRICE_QUALITY_1"] = "Normal"
    L["MPRICE_QUALITY_2"] = "Ungewöhnlich"
    L["MPRICE_QUALITY_3"] = "Selten"
    L["MPRICE_QUALITY_4"] = "Episch"
    L["MPRICE_QUALITY_99"] = "Alle Qualitäten"
    L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35ForeverLooter:|r Unbekannte Währung, bitte prüfen."
    L["MPRICE_COIN_G"] = "Gold"
    L["MPRICE_COIN_S"] = "Silber"
    L["MPRICE_COIN_C"] = "Kupfer"
    L["FORCE_VENDOR_PRICE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Händlerpreis zwingend aktiviert. Nur Händlerverkaufspreise werden benutzt."
    L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35ForeverLooter:|r Händlerpreis zwingend deaktiviert."
    L["TIME_ERROR"] =
    "|cFFd8de35ForeverLooter:|r Das Format ist falsch, es muss sein: 00h00m00s oder eine beliebige Zeitkombination (5m30s)"
    L["ALL"] = "ALLE"
    L["USE_DISENCHANT_VALUE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Using disenchantment value when it is higher than the direct auction price."
    L["USE_DISENCHANT_VALUE_DISABLED"] =
    "|cFFd8de35ForeverLooter:|r Disenchantment value is no longer used. The direct auction price will always be used."
    return L
end
