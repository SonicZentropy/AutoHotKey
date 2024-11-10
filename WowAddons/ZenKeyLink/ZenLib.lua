local addonName, ns = ...

function ns.OnLoad()
    print("ZenLib loaded!")
end

function ns.AnotherFunction()
    print("Another function from ZenLib")
end

function ns.IsPlayerCastingOrChanneling()
    local isCasting = UnitCastingInfo("player") ~= nil
    local isChanneling = UnitChannelInfo("player") ~= nil

    return isCasting or isChanneling
end

function ns.IsSpellReady(spellID)
    
end

function ns.GetSpellCD(spellId)
    local spellCDInfo = C_Spell.GetSpellCooldown(spellId)
    local remainingCD = (spellCDInfo.startTime + spellCDInfo.duration - GetTime())
    return remainingCD
end

-- working weakaura for practicing count that shows count of individual kill
--function()
--    -- Get NPC ID to find count from
--    local unitGUID = WeakAuras.GetTriggerStateForTrigger(aura_env.id, 1)
--    if unitGUID and unitGUID[""] then
--        --            DevTools_Dump(unitGUID)
--        --          print("unit")
--        DevTools_Dump(unitGUID[""].destNpcId)
        
        
--        -- Find Count
--        local mob_id = tonumber(unitGUID[""].destNpcId)
--        if not mob_id then return("NONE") end
        
--        if not MDT then return("No MDT") end
        
--        local value, max, maxteeming, teemingCount = MDT:GetEnemyForces(mob_id)
--        local count_val = tostring(value) or "NONE"
--        print("value " .. count_val)
--        --print("max " .. (max or "NONE"))
--        --print("maxteeming" .. (maxteeming or "NONE"))
--        --print("teemingCount" .. (teemingCount or "NONE"))
        
--        return count_val
        
--    end
--    return "GUID Missing"
--end


