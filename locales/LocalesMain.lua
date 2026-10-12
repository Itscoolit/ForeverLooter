---@class ForeverLooter
local ForeverLooter = select(2, ...)

---@class FL_Locales
local Locales = ForeverLooter.Locales

-- Based on Auctionator implementation, thanks <3
local currentLocale
if Locales[GetLocale()] then
    currentLocale = Locales[GetLocale()]()
else
    currentLocale = Locales["enUS"]()
end

for key, value in pairs(currentLocale) do
    _G["FOREVERLOOTER_L_" .. key] = value
end
