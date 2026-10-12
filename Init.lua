---@class ForeverLooter
---@field isRetail boolean
---@field isForever boolean
---@field isClassic boolean
---@field isTBC boolean
---@field isWrath boolean
---@field isCata boolean
---@field isMists boolean
local ForeverLooter = select(2, ...)

if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE then
    ForeverLooter.isRetail = true
elseif WOW_PROJECT_ID == WOW_PROJECT_CLASSIC then
    ForeverLooter.isClassic = true
elseif WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC then
    ForeverLooter.isCata = true
elseif WOW_PROJECT_ID == WOW_PROJECT_WRATH_CLASSIC then
    ForeverLooter.isWrath = true
elseif WOW_PROJECT_ID == WOW_PROJECT_BURNING_CRUSADE_CLASSIC then
    ForeverLooter.isTBC = true
elseif WOW_PROJECT_ID == WOW_PROJECT_MISTS_CLASSIC then
    ForeverLooter.isMists = true
else -- FIXME
    ForeverLooter.isForever = true
end
