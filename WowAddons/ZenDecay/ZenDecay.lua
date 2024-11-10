-- Use the _G table to define a global variable
--_G["ZenBridge"] = _G[addon] or {}
--ns.KeybindUpNext = ""
local addon, ns = ...

local debugPrint = false
local lastUpdate = 0
local updateInterval = 0.1 -- 1/10th of a second





local frame = CreateFrame("Frame", "ZenDecayFrame", UIParent)
--frame:SetSize(40, 40)
--frame:SetPoint("CENTER")
--frame:SetFrameStrata("FULLSCREEN_DIALOG")

--local texture = frame:CreateTexture(nil, "OVERLAY")
--texture:SetBlendMode("DISABLE")
--texture:SetAllPoints(frame)
--texture:SetColorTexture(0, 0, 0)
--texture:SetAlpha(1.0)

local lastPrintTime = 0


local Options = {
    OpenWithDeathsCaress = true,
    OpenWithDnD = true,
    
}

local Abilities = {
    DeathsCaress = {
        id = 433895,
        aura = "Deaths Caress",
    },
    DnD = {
        id = 43265,
        aura = "Death and Decay",
    },
}

local CombatStates = {
    OutOfCombat = "OUT_OF_COMBAT",
    Opener = "OPENER",
    Primary = "PRIMARY"
}

local State = {
    CombatState = CombatStates.OutOfCombat,
    AbilityToGlow = nil,
    Cooldowns = {
        DeathsCaress = 0,
        DnD = 0,
    }
}

local function UpdateState()
    State.Cooldowns.DnD = math.max(0, ns.GetSpellCD(Abilities.DnD.id))
    if State.Cooldowns.DnD > 0 then
        --State.AbilityToGlow = Abilities.DnD
        print("DnD CD: " .. tostring(State.Cooldowns.DnD))
    end
    
end

local function Opener()
    --TODO: CheckOpener()
    if Options.OpenWithDeathsCaress then
        Highlight(Abilities.DeathsCaress)
    end
end

local function UpdateInterval(elapsed)
    local currentTime = GetTime()
    if currentTime - lastUpdate >= updateInterval then
        -- Do your updates here
        UpdateState()
        lastUpdate = currentTime
    end
end

local function OnUpdate(self, elapsed)
    UpdateInterval(elapsed)
    -- Accumulate elapsed time
    lastPrintTime = lastPrintTime + elapsed
    local region = WeakAuras.GetRegion("Soul Reaper")
    if region and region.icon then
        --print("Showing overlay glow")
        region:SetGlow(true, {
            type = "Button",        -- Can be "Pixel", "ACShine", "Proc", or "Button"
            -- Pixel glow options
            color = { 1, 0, 0, 1 }, -- Red color (r,g,b,a)
            lines = 8,              -- Number of lines
            frequency = 0.25,       -- Animation speed (lower = faster)
            length = 10,            -- Line length
            thickness = 2,          -- Line thickness
            -- Button glow options (if type = "Button")
            -- color = {0, 1, 0, 1}, -- Green color
        })
    end
end

frame:SetScript("OnUpdate", OnUpdate)
