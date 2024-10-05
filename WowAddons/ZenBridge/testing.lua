aura_env.mapping = {};

if not aura_env.frame_pool then
    aura_env.frame_pool = CreateFramePool("Frame", UIParent);
end

if not aura_env.font_string_pool then
    aura_env.font_string_pool = CreateFontStringPool(UIParent, "OVERLAY");
end

local function object_assign(t1, t2)
    for key, value in pairs(t2) do
        t1[key] = value
    end

    return t1
end
local function all_trim(s)
    return s:match("^%s*(.-)%s*$")
end


local string_split = function(inString, delimiter)
    local result               = {}
    local from                 = 1
    local inStringCleaned      = all_trim(inString)
    local delim_from, delim_to = string.find(inStringCleaned, delimiter, from)
    while delim_from do
        if all_trim(string.sub(inStringCleaned, from, delim_from - 1)) ~= "" then
            table.insert(result, all_trim(string.sub(inStringCleaned, from, delim_from - 1)))
        end
        from                 = delim_to + 1
        delim_from, delim_to = string.find(inStringCleaned, delimiter, from)
    end
    if all_trim(string.sub(inStringCleaned, from)) ~= "" then
        table.insert(result, all_trim(string.sub(inStringCleaned, from)))
    end
    return result
end

local table_has_key = function(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end


aura_env.FramePoolAcquire = function(parent_frame)
    local created_frame = aura_env.frame_pool:Acquire()
    created_frame:SetParent(parent_frame);
    created_frame:SetAllPoints(parent_frame);
    created_frame:Show();
    return created_frame
end

aura_env.FontStringPoolAcquire = function(parent_frame)
    local created_font_string = aura_env.font_string_pool:Acquire()
    created_font_string:SetParent(parent_frame);
    return created_font_string
end

aura_env.ReleaseAll = function()
    aura_env.font_string_pool:ReleaseAll();
    aura_env.frame_pool:ReleaseAll();
    aura_env.mapping = {};
end

local max_font_size = 22;

aura_env.region_func = function(aura_id, aura_bundle)
    local aura_type = aura_bundle.regionType
    local aura_region = aura_bundle.region
    if aura_type == "icon" then
        local spellid, isSpell, isItem
        local data = WeakAuras.GetData(aura_id)
        -- if aura_env.config["group_enable"] then
        --     local groups = string_split(aura_env.config["groups"], "\n")
        --     if not table_has_key(groups, data.parent) then
        --         return
        --     end
        -- end

        for _, v in pairs(data.triggers) do
            -- DevTool:AddData(v, aura_id)
            if type(v) == "table" and v.trigger and v.trigger.event == "Cooldown Progress (Spell)" then
                isSpell = true
                spellid = v.trigger.spellName
                break
            elseif type(v) == "table" and v.trigger and v.trigger.auraspellids and v.trigger.useExactSpellId and #v.trigger.auraspellids > 0 then
                isSpell = true
                if v.trigger.spellName then
                    spellid = tonumber(v.trigger.spellName)
                else
                    spellid = tonumber(v.trigger.auraspellids[1])
                end
                break
            elseif type(v) == "table" and v.trigger and v.trigger.event == "Cooldown Progress (Item)" and not (v.trigger.itemName == 183650 and v.trigger.type == "aura2") then
                isItem = true
                spellid = v.trigger.itemName
                break
            end
        end
        if isSpell or isItem then
            local isNumber = type(spellid) == "number"

            local function GetActionSpell(slot)
                local actionType, id, subType = GetActionInfo(slot)
                if isSpell then
                    if actionType == "spell" then
                        return id
                    elseif actionType == "macro" then
                        return GetMacroSpell(id)
                    end
                elseif isItem then
                    if actionType == "item" then
                        return id
                    end
                end
                return nil
            end

            local bindingSubs = {
                { "CTRL%-",         "C" },
                { "ALT%-",          "A" },
                { "SHIFT%-",        "S" },
                { "STRG%-",         "ST" },
                { "%s+",            "" },
                { "NUMPAD",         "N" },
                { "PLUS",           "+" },
                { "MINUS",          "-" },
                { "MULTIPLY",       "*" },
                { "DIVIDE",         "/" },
                { "BUTTON",         "M" },
                { "MOUSEWHEELUP",   "MwU" },
                { "MOUSEWHEELDOWN", "MwD" },
                { "MOUSEWHEEL",     "Mw" },
                { "DOWN",           "Dn" },
                { "UP",             "Up" },
                { "PAGE",           "Pg" },
                { "BACKSPACE",      "BkSp" },
                { "DECIMAL",        "." },
                { "CAPSLOCK",       "CAPS" },
            }

            local improvedGetBindingText = function(binding)
                if not binding then return "" end

                for i, rep in ipairs(bindingSubs) do
                    binding = binding:gsub(rep[1], rep[2])
                end

                return string.lower(binding)
            end

            local function NewFindBindings(spellid)
                local keys = {}
                local slotsUsed = {}
                local itemCache = {}
                local lastRefresh = 0
                local queuedRefresh = false

                local CachedGetItemInfo = function(id)
                    if itemCache[id] then
                        return unpack(itemCache[id])
                    end

                    local item = { GetItemInfo(id) }
                    if item and item[1] then
                        itemCache[id] = item
                        return unpack(item)
                    end
                end

                local StoreKeybindInfo = function(key, aType, id, idType)
                    if not key or not aType or not id then return end

                    local action, ability
                    if aType == "spell" or idType == "spell" then
                        ability = id
                        action = C_Spell.GetSpellInfo(id) ~= nil
                    elseif aType == "item" then
                        local item = CachedGetItemInfo(id)
                        ability = id
                        action = item ~= nil
                    elseif aType == "macro" then
                        local sID = GetMacroSpell(id) or GetMacroItem(id);
                        if sID ~= nil then
                            ability = sID
                            action = C_Spell.GetSpellInfo(sID) ~= nil
                        end
                    end

                    if action then
                        keys[ability] = improvedGetBindingText(key)
                    end
                end

                local ReadKeybindings = function()
                    local now = GetTime()

                    if now - lastRefresh < 0.25 then
                        if queuedRefresh then return end

                        queuedRefresh = true
                        C_Timer.After(0.3 - (now - lastRefresh), ReadKeybindings)

                        return
                    end

                    lastRefresh = now
                    queuedRefresh = false

                    local done = false

                    for k, v in pairs(keys) do
                        wipe(v.console)
                        wipe(v.upper)
                        wipe(v.lower)
                    end

                    if not done then
                        for i = 1, 12 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("ACTIONBUTTON" .. i), GetActionInfo(i))
                            end
                        end

                        for i = 13, 24 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("ACTIONBUTTON" .. i - 12), GetActionInfo(i))
                            end
                        end

                        for i = 25, 36 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("MULTIACTIONBAR3BUTTON" .. i - 24), GetActionInfo(i))
                            end
                        end

                        for i = 37, 48 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("MULTIACTIONBAR4BUTTON" .. i - 36), GetActionInfo(i))
                            end
                        end

                        for i = 49, 60 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("MULTIACTIONBAR2BUTTON" .. i - 48), GetActionInfo(i))
                            end
                        end

                        for i = 61, 72 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("MULTIACTIONBAR1BUTTON" .. i - 60), GetActionInfo(i))
                            end
                        end
                        for i = 72, 143 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("ACTIONBUTTON" .. 1 + (i - 72) % 12),
                                    GetActionInfo(i + 1))
                            end
                        end

                        for i = 145, 156 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("MULTIACTIONBAR5BUTTON" .. i - 144), GetActionInfo(i))
                            end
                        end

                        for i = 157, 168 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("MULTIACTIONBAR6BUTTON" .. i - 156), GetActionInfo(i))
                            end
                        end

                        for i = 169, 180 do
                            if not slotsUsed[i] then
                                StoreKeybindInfo(GetBindingKey("MULTIACTIONBAR7BUTTON" .. i - 168), GetActionInfo(i))
                            end
                        end
                    end
                end


                ReadKeybindings()
                -- ViragDevTool:AddData(keys, spellid)
                return keys[spellid]
            end

            local function FindBindings(spell, frame)
                if not frame then frame = UIParent end
                local results = {}

                if type(frame) == "table" and not frame:IsForbidden() then
                    local type = frame:GetObjectType()
                    if type == "Frame" or type == "Button" then
                        for _, child in ipairs({ frame:GetChildren() }) do
                            for _, v in pairs(FindBindings(spell, child)) do
                                tinsert(results, v)
                            end
                        end
                    end
                    if type == "CheckButton" and frame.action then
                        local spellid = GetActionSpell(frame.action)
                        --print("frame.action", frame.action)
                        if frame.config and frame.config.keyBoundTarget then
                            print("config:", frame.config.keyBoundTarget)
                        end
                        --for k,v in pairs(frame) do
                        --    print(k,v)
                        --end

                        if spellid then
                            --print(spellid)
                            print("-----")
                            print(spellid)
                            local spellInfo = C_Spell.GetSpellInfo(spellid)
                            print(spellInfo)
                            if (isNumber and spellid == spell)
                                or (not isNumber
                                    and (isSpell and spellInfo.spell == spell) or (isItem and GetItemInfo(spellid) == spell))
                            then
                                --print("1bouton trouvé", frame.action)
                                local slot = frame.action % 12
                                if slot == 0 then slot = 12 end
                                local bind1, bind2 = GetBindingKey(frame.buttonType and frame.buttonType .. slot or
                                "ACTIONBUTTON" .. slot)
                                --print(bind1, bind2, frame.buttonType, slot, frame:GetName())
                                if bind1 then
                                    --print("bouton trouvé", frame.action, slot, bind1)
                                    tinsert(results, { frame = frame, bind1 = bind1, bind2 = bind2 })
                                end
                            end
                        end
                    end
                end
                return results
            end

            local bind
            if aura_env.config["use_new_logic"] then
                bind = NewFindBindings(spellid)
                if not bind then
                    if isSpell and spellid then
                        local spell_info = C_Spell.GetSpellInfo(spellid)
                        if spell_info and spell_info.spellName then
                            local current_rank_spellid = C_Spell.GetSpellIDForSpellIdentifier(spell_info.spellName)
                            bind = NewFindBindings(current_rank_spellid)
                        end
                    end
                end
            else
                for k, v in pairs(FindBindings(spellid)) do
                    if v.bind1 then
                        bind = v.bind1
                    end
                end
            end

            if bind then
                if not aura_env.mapping[aura_id] then aura_env.mapping[aura_id] = {} end

                local short = ((bind:gsub("SHIFT.", "S")):gsub("CTRL.", "C")):gsub("ALT.", "A")
                
                if not aura_env.mapping[aura_id].bind_frame then
                    aura_env.mapping[aura_id].bind_frame = aura_env.FramePoolAcquire(aura_region);
                    aura_env.mapping[aura_id].bind_text = aura_env.FontStringPoolAcquire(aura_env.mapping[aura_id]
                    .bind_frame)
                end

                local width = aura_region:GetWidth()
                local font_size = math.min(math.floor(width / 3), max_font_size)
                local y_offset = math.floor(width / font_size) * -1
                aura_env.mapping[aura_id].bind_text:GetParent():SetFrameLevel(aura_region:GetFrameLevel() + 1)
                aura_env.mapping[aura_id].bind_text:ClearAllPoints()
                aura_env.mapping[aura_id].bind_text:SetPoint("TOPRIGHT", aura_region, "TOPRIGHT", 0, y_offset);
                aura_env.mapping[aura_id].bind_text:SetFont(STANDARD_TEXT_FONT, font_size, "OUTLINE")
                aura_env.mapping[aura_id].bind_text:SetTextColor(1, 1, 1, aura_region:GetAlpha())
                aura_env.mapping[aura_id].bind_text:SetJustifyH("RIGHT")
                aura_env.mapping[aura_id].bind_text:SetJustifyV("TOP")
                aura_env.mapping[aura_id].bind_text:SetWordWrap(true)
                aura_env.mapping[aura_id].bind_text:SetSize(0, 0)
                aura_env.mapping[aura_id].bind_text:SetText(short)
                aura_env.mapping[aura_id].bind_text:Show();

                -- keypress overlay
                local modifier = {}
                local red, green, blue, alpha
                if not aura_env.mapping[aura_id].kp_overlay then
                    aura_env.mapping[aura_id].kp_overlay = aura_env.FramePoolAcquire(aura_region);
                end
                aura_env.mapping[aura_id].kp_overlay:SetScript("OnKeyDown", function(self, key)
                    local mod
                    if modifier then
                        for k, _ in pairs(modifier) do
                            mod = k:match("^.(.*)")
                        end
                    end
                    key = mod and mod .. "-" .. key or key
                    if improvedGetBindingText(key) == bind then
                        aura_region:Color(0.5, 0.5, 0.5, 1)
                        C_Timer.After(0.1, function()
                            aura_region:Color(1, 1, 1, 1)
                        end)
                    end
                end)
                aura_env.mapping[aura_id].kp_overlay:SetScript("OnEvent", function(self, event, key, state)
                    if event == "MODIFIER_STATE_CHANGED" then
                        modifier = modifier or {}
                        modifier[key] = (state == 1) or nil
                    end
                end);
                aura_env.mapping[aura_id].kp_overlay:RegisterEvent("MODIFIER_STATE_CHANGED")
                aura_env.mapping[aura_id].kp_overlay:SetPropagateKeyboardInput(true)
            end
        end
    end
end

aura_env.overlay_func = function()
    aura_env.ReleaseAll();
    if WeakAuras.IsOptionsOpen() then return end
    if not aura_env.config["aura_enable"] then return end
    if aura_env.config["group_enable"] then
        local groups = string_split(aura_env.config["groups"], "\n")
        if #groups == 0 then
            print(
            "[|cffffff00Bind / Button Watcher|r] |cffff0000Error:|r Aura enabled but no auras / aura groups were defined to scan over.")
        end
        for _, aura_parent_id in ipairs(groups) do
            local function UnnestGroups(aura_parent_id, regions)
                local data = WeakAuras.GetData(aura_parent_id)
                if data then
                    for _, aura_id in pairs(data.controlledChildren) do
                        local aura_bundle = WeakAuras.regions[aura_id]

                        if aura_bundle then
                            if string.find(aura_bundle.regionType, "group") then
                                object_assign(UnnestGroups(aura_bundle.region.id, regions), regions)
                            else
                                regions[aura_id] = aura_bundle
                            end
                        end
                    end
                elseif #regions == 0 then
                    print("[|cffffff00Bind / Button Watcher|r] |cffff0000Error:|r The aura group \"", aura_parent_id,
                        "\" does not exist. Please ensure you've typed the right aura name and are using proper capitalization / punctuation as well!")
                end
                return regions
            end
            local unnested_groups = UnnestGroups(aura_parent_id, {})
            for aura_id, aura_bundle in pairs(unnested_groups) do
                aura_env.region_func(aura_id, aura_bundle)
            end
        end
    else
        for aura_id, aura_bundle in pairs(WeakAuras.regions) do
            aura_env.region_func(aura_id, aura_bundle)
        end
    end
end
aura_env.overlay_func();
