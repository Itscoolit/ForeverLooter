---@class ForeverLooter
local ForeverLooter = select(2, ...)

---@class FL_Locales
local Locales = ForeverLooter.Locales

Locales.ptBR = function()
    local L = {}
    L["START"] = "Iniciar"
    L["CONTINUE"] = "Continuar"
    L["PAUSE"] = "Pausar"
    L["RESET"] = "Reiniciar"
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
    L["TIME_LABEL"] = "Tempo:"
    L["GOLD_LABEL"] = "Ouro:"
    L["ITEMS_LABEL"] = "Itens:"
    L["GPH_LABEL"] = "GPH:"
    L["PRICIEST_LABEL"] = "Mais caro:"
    L["USAGE"] = [[====== |cFFd8de35Informações de uso do ForeverLooter|r ======
  |cFF36e8e6/flo|r: Ativar/Desativar exibição
  |cFF36e8e6/flo|r |cFFf1f488help|r: Mostrar ajuda
  |cFF36e8e6/flo|r |cFFf1f488show|r: Exibir ForeverLooter
  |cFF36e8e6/flo|r |cFFf1f488hide|r: Ocultar ForeverLooter
  |cFF36e8e6/flo|r |cFFf1f488info|r: Mostrar informações sobre o addon.
  |cFF36e8e6/flo|r |cFFf1f488custom 'stringa TSM personalizada'|r: Define a string TSM usada para calcular preços. Se vazia, retorna a string atual.
    Exemplos: /flo custom dbmarket
              /flo custom
  |cFF36e8e6/flo|r |cFFf1f488mprice 'valor'|r: Define o preço mínimo de qualidade.
            mpricex: Todas as qualidades disponíveis.
            mprice1: Qualidade 1 - Normal - Branco
            mprice2: Qualidade 2 - Pouco comum - Verde
            mprice3: Qualidade 3 - Raro - Azul
            mprice4: Qualidade 4 - Épico - Roxo
      As demais qualidades usarão o preço do vendedor, se houver.
    Exemplos: /flo mprice1 50 s
              /flo mprice2 5000
              /flo mprice3 500 g
              /flo mprice4 5 c
      O formato de preço para mprice é um número seguido por g (ouro), s (prata) ou c (cobre). Se apenas o número for informado, será usado ouro por padrão.
      |cFF36e8e6/flo|r |cFFf1f488disenchant|r: Enable/disable the use of the disenchantment value for looted items (if it's higher than the direct auction value).
  |cFF36e8e6Versão do addon:|r ]]
    L["WELCOME"] = "Bem-vindo ao |cFFd8de35ForeverLooter|r! Use |cFF36e8e6/flo|r |cFFf1f488help|r para opções de addon."
    L["CLOSE"] = "|cFF36e8e6/flo|r |cFFf1f488show|r: Mostrar novamente |cFFd8de35ForeverLooter|r"
    L["INFO"] = "|cFFd8de35ForeverLooter|r é um addon leve e rápido para rastrear loot, criado por Will0w7."
    L["TSM_NOT_AVAILABLE"] = "|cFFd8de35ForeverLooter:|r TSM não está disponível."
    L["TSM_CUSTOM_STRING_NOT_VALID"] =
    "|cFFd8de35ForeverLooter:|r A string de TSM indicada é inválida e não foi configurada: "
    L["TSM_CUSTOM_STRING_VALID"] = "|cFFd8de35ForeverLooter:|r A string de TSM indicada é válida e foi configurada: "
    L["TSM_CUSTOM_STRING"] = "|cFFd8de35ForeverLooter:|r Usando a seguinte string de TSM: "
    L["NEW_DB_VERSION"] = "|cFFd8de35ForeverLooter:|r Foi detectada uma nova versão do banco de dados, atualizando..."
    L["DB_UPDATED"] = "|cFFd8de35ForeverLooter:|r O banco de dados foi atualizado com sucesso!"
    L["MPRICE_ERROR"] = "|cFFd8de35ForeverLooter:|r O próximo preço mínimo é inválido: "
    L["MPRICE_VALID"] = "|cFFd8de35ForeverLooter:|r O próximo preço mínimo é válido e foi configurado:"
    L["MPRICE_QUALITY_1"] = "Normal"
    L["MPRICE_QUALITY_2"] = "Pouco comum"
    L["MPRICE_QUALITY_3"] = "Raro"
    L["MPRICE_QUALITY_4"] = "Épico"
    L["MPRICE_QUALITY_99"] = "Todas as qualidades"
    L["MPRICE_UNRECOGNIZED_COIN"] = "|cFFd8de35ForeverLooter:|r Moeda não reconhecida, verifique a entrada."
    L["MPRICE_COIN_G"] = "Ouro"
    L["MPRICE_COIN_S"] = "Prata"
    L["MPRICE_COIN_C"] = "Cobre"
    L["FORCE_VENDOR_PRICE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Preço do vendedor forçado ativado. Apenas preços de venda serão usados."
    L["FORCE_VENDOR_PRICE_DISABLED"] = "|cFFd8de35ForeverLooter:|r Preço do vendedor forçado desativado."
    L["TIME_ERROR"] =
    "|cFFd8de35ForeverLooter:|r O formato está incorreto, deve ser: 00h00m00s ou qualquer combinação de tempo (5m30s)"
    L["ALL"] = "TODOS"
    L["USE_DISENCHANT_VALUE_ENABLED"] =
    "|cFFd8de35ForeverLooter:|r Using disenchantment value when it is higher than the direct auction price."
    L["USE_DISENCHANT_VALUE_DISABLED"] =
    "|cFFd8de35ForeverLooter:|r Disenchantment value is no longer used. The direct auction price will always be used."
    return L
end
