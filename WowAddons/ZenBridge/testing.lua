

function(allstates, event, ...)
    print("Event is: ")
    print(event)
    
    local AuraNames = {
        BloodBoil = "Blood Boil",
        DeathAndDecay = "Death and Decay",
        Marrowrend = "Marrowrend",
        DeathCaress = "Death Caress",
        ReapersMark = "Reaper Mark",
        DancingRuneWeapon = "Dancing Rune Weapon",
        Bonestorm = "Bonestorm",
        Tombstone = "Tombstone",
        Consumption = "Consumption",
        SoulReaper = "Soul Reaper"
    }
    -- Check Bone Shield stacks
    local name, _, count = AuraUtil.FindAuraByName("Bone Shield", "player", "HELPFUL")
    local boneShieldStacks = count or 0
    local currentAura = ""
    
    -- Example: Glow WeakAuraName1 if Bone Shield is below 5 stacks
    
    
    -- Apply or remove glows based on state
    for _, auraName in pairs(AuraNames) do
        
        local region = WeakAuras.GetRegion(auraName)
        if region and auraName ~= currentAura then --and region.icon then
            --WeakAuras.HideOverlayGlow(region.icon)
            region:SetGlow(false)
        end
    end
    
    if boneShieldStacks < 5 then
        print("Low bone shield")
        local region = WeakAuras.GetRegion(AuraNames.Marrowrend)
        if region then
            print("Region found")
            region:SetGlow(true, {
                    type = "Button", -- Can be "Pixel", "ACShine", "Proc", or "Button"
                    -- Pixel glow options
                    color = {1, 0, 0, 1}, -- Red color (r,g,b,a)
                    lines = 8, -- Number of lines
                    frequency = 0.15, -- Animation speed (lower = faster)
                    length = 10, -- Line length
                    thickness = 3, -- Line thickness
                    -- Button glow options (if type = "Button")
                    -- color = {0, 1, 0, 1}, -- Green color
            })
            print("Set glow")
            currentAura = AuraNames.Marrowrend
        end
    end
    
    return false
end

m

actions.precombat=flask
actions.precombat+=/food
actions.precombat+=/augmentation
actions.precombat+=/snapshot_stats

