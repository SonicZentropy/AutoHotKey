-- Cataclysm/Items.lua

local addon, ns = ...
local Zekili = _G[ addon ]

local class, state = Zekili.Class, Zekili.State
local all = Zekili.Class.specs[ 0 ]

all:RegisterAbility( "skardyns_grace", {
    cast = 0,
    cooldown = 120,
    gcd = "off",

    item = 133282,
    toggle = "cooldowns",

    handler = function ()
        applyBuff( "speed_of_thought" )
    end,

    auras = {
        speed_of_thought = {
            id = 92099,
            duration = 35,
            max_stack = 1
        }
    }
} )
