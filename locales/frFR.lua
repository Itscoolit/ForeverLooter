---@class ForeverLooter
local ForeverLooter = select(2, ...)

---@class FL_Locales
local Locales = ForeverLooter.Locales

Locales.frFR = function()
    local L = {}
    L["START"] = "Démarrer"
    L["CONTINUE"] = "Continuer"
    L["PAUSE"] = "Pause"
    L["RESET"] = "Réinitialiser"
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
    L["TIME_LABEL"] = "Temps:"
    L["GOLD_LABEL"] = "Or:"
    L["ITEMS_LABEL"] = "Objets:"
    L["GPH_LABEL"] = "GPH:"
    L["PRICIEST_LABEL"] = "Le plus cher:"
    L["USAGE"] = [[====== |cFFd8de35Informations d'utilisation de ForeverLooter|r ======
  |cFF36e8e6/flo|r : Activer/Désactiver l'affichage
  |cFF36e8e6/flo|r |cFFf1f488help|r : Afficher l'aide
  |cFF36e8e6/flo|r |cFFf1f488show|r : Afficher ForeverLooter
  |cFF36e8e6/flo|r |cFFf1f488hide|r : Masquer ForeverLooter
  |cFF36e8e6/flo|r |cFFf1f488info|r : Afficher les informations sur l'addon.
  |cFF36e8e6/flo|r |cFFf1f488custom 'chaîne TSM personnalisée'|r : Définit la chaîne TSM utilisée pour le calcul du prix. Si vide, renvoie la chaîne TSM actuelle.
    Exemples: /flo custom dbmarket
              /flo custom
  |cFF36e8e6/flo|r |cFFf1f488mprice 'valeur'|r : Définit le seuil minimal de prix pour une qualité.
            mpricex : Toutes les qualités disponibles.
            mprice1 : Qualité 1 - Normale - Blanche
            mprice2 : Qualité 2 - Peu courante - Verte
            mprice3 : Qualité 3 - Rare - Bleue
            mprice4 : Qualité 4 - Épique - Pourpre
      Les autres qualités utiliseront le prix du vendeur, s'il est disponible.
    Exemples: /flo mprice1 50 s
              /flo mprice2 5000
              /flo mprice3 500 g
              /flo mprice4 5 c
      Le format de prix pour mprice est un nombre suivi de g (or), s (argent) ou c (cuivre). Si seul le nombre est fourni, l'or est utilisé par défaut.
      |cFF36e8e6/flo|r |cFFf1f488disenchant|r: Enable/disable the use of the disenchantment value for looted items (if it's higher than the direct auction value).
  |cFF36e8e6Version de l'addon:|r ]]
    L["WELCOME"] =
    "Bienvenue dans |cFFd8de35ForeverLooter|r! Utilisez |cFF36e8e6/flo|r |cFFf1f488help|r pour les options de l'addon."
    L["CLOSE"] = "|cFF36e8e6/flo|r |cFFf1f488show|r : Afficher à nouveau |cFFd8de35ForeverLooter|r"
    L["INFO"] = "|cFFd8de35ForeverLooter|r est un addon léger et rapide pour le suivi de butin, créé par Will0w7."
    L["TSM_NOT_AVAILABLE"] = "|cFFd8de35ForeverLooter:|r TSM n'est pas disponible."
    L["TSM_CUSTOM_STRING_NOT_VALID"] =
    "|cFFd8de35ForeverLooter:|r La chaîne TSM indiquée est invalide et n'a pas été définie: "
    L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35ForeverLooter:|r La chaîne TSM indiquée est valide et a été définie: "
    L["TSM_CUSTOM_STRING"] = "|cFFd8de35ForeverLooter:|r Utilisation de la chaîne TSM suivante: "
    L["NEW_DB_VERSION"] =
    "|cFFd8de35ForeverLooter:|r Une nouvelle version de la base de données a été détectée, mise à jour en cours…"
    L["DB_UPDATED"] = "|cFFd8de35ForeverLooter:|r La base de données a été mise à jour avec succès!"
    L["MPRICE_ERROR"] = "|cFFd8de35ForeverLooter:|r Le seuil minimal de prix indiqué est invalide: "
    L["MPRICE_VALID"] = "|cFFd8de35ForeverLooter:|r Le seuil minimal de prix indiqué est valide et a été défini:"
    L["MPRICE_QUALITY_1"] = "Normale"
    L["MPRICE_QUALITY_2"] = "Peu courante"
    L["MPRICE_QUALITY_3"] = "Rare"
    L["MPRICE_QUALITY_4"] = "Épique"
    L["MPRICE_QUALITY_99"] = "Toutes les qualités"
    L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35ForeverLooter:|r Monnaie non reconnue, vérifiez l'entrée."
    L["MPRICE_COIN_G"] = "Or"
    L["MPRICE_COIN_S"] = "Argent"
    L["MPRICE_COIN_C"] = "Cuivre"
    L["FORCE_VENDOR_PRICE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Prix vendeur forcé activé. Seuls les prix de vente du vendeur seront utilisés."
    L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35ForeverLooter:|r Prix vendeur forcé désactivé."
    L["TIME_ERROR"] =
    "|cFFd8de35ForeverLooter:|r Le format est incorrect, il doit être: 00h00m00s ou n'importe quelle combinaison de temps (5m30s)"
    L["REMOVE_CONFIRM"] = "Retirer %s du total de la session ?"
    L["ALL"] = "TOUS"
    L["USE_DISENCHANT_VALUE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Using disenchantment value when it is higher than the direct auction price."
    L["USE_DISENCHANT_VALUE_DISABLED"] =
    "|cFFd8de35ForeverLooter:|r Disenchantment value is no longer used. The direct auction price will always be used."
    return L
end
