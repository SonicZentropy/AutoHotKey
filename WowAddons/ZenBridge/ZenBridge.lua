-- Creating the main frame
local addon, ns = ...

local Zekili = _G["Zekili"]

local debugPrint = false

-- Use the _G table to define a global variable
--_G["ZenBridge"] = _G[addon] or {}
--ns.KeybindUpNext = ""


-- Improved hash function to convert a string to a unique and fairly distributed RGB color
local function StringToRGB(str)
    if str == "1" then
        --print("1 - Dark Gray")
        return 0.3, 0.3, 0.3 -- Dark Gray
    elseif str == "2" then
        --print("2 - Blue")
        return 0, 0, 1 -- Blue
    elseif str == "3" then
        --print("3 - Green")
        return 0, 1, 0 -- Green
    elseif str == "4" then
        --print("4 - White")
        return 1, 1, 1 -- White
    elseif str == "5" then
        --print("5 - Cyan")
        return 0, 1, 1 -- Cyan
    elseif str == "6" then
        --print("6 - Yellow")
        return 1, 1, 0 -- Yellow
    elseif str == "7" then
        --print("7 - Something")
        return 1, 0.7, 0.3 -- Something
    elseif str == "8" then
        --print("8 - Gray")
        return 0.5, 0.5, 0.5 -- Gray
    elseif str == "9" then
        --print("9 - Pinkish")
        return 0.75, 0.3, 0.5 -- Pinkish
    elseif str == "0" then
        --print("0 - Mint")
        return 0.3, 0.9, 0.7 -- Mint
    elseif str == "-" then
        --print("- - Dark Red")
        return 0.6, 0.1, 0.1 -- Dark Red
    elseif str == "=" then
        --print("= - Dark Green")
        return 0.1, 0.6, 0.1 -- Dark Green
    elseif str == "Q" then
        --print("Q - Dark Blue")
        return 0.1, 0.1, 0.6 -- Dark Blue
    elseif str == "E" then
        --print("E - Olive")
        return 0.6, 0.6, 0.2 -- Olive
    elseif str == "R" then
        --print("R - Purple")
        return 0.6, 0.2, 0.6 -- Purple
    elseif str == "F" then
        --print("F - Teal")
        return 0.2, 0.6, 0.6 -- Teal
    elseif str == "Z" then
        --print("Z - Orange Brownish")
        return 0.8, 0.4, 0.2 -- Orange Brownish
    elseif str == "X" then
        --print("X - Dark Purple")
        return 0.4, 0.2, 0.8 -- Dark Purple
    elseif str == "C" then
        --print("C - Light Green")
        return 0.2, 0.8, 0.4 -- Light Green
    elseif str == "V" then
        --print("V - Light Yellow")
        return 0.8, 0.8, 0.4 -- Light Yellow
    elseif str == "S1" then
        --print("S1 - Bright Orange")
        return 1, 0.5, 0 -- Bright Orange
    elseif str == "S2" then
        --print("S2 - Light Green")
        return 0.5, 1, 0 -- Light Green
    elseif str == "S3" then
        --print("S3 - Light Blue")
        return 0, 0.5, 1 -- Light Blue
    elseif str == "S4" then
        --print("S4 - Light Purple")
        return 0.5, 0, 1 -- Purple
    elseif str == "S5" then
        --print("S5 - Reddish Purple")
        return 1, 0, 0.5 -- Reddish Purple
    elseif str == "S6" then
        --print("S6 - Olive Drab")
        return 0.1, 0.4, 0 -- Olive Drab
    elseif str == "S7" then
        --print("S7 - Burnt Orange")
        return 0.4, 0.1, 0 -- Burnt Orange
    elseif str == "S8" then
        --print("S8 - Dark Blue Violet")
        return 0.1, 0, 0.4 -- Dark Blue Violet
    elseif str == "S9" then
        --print("S9 - Very Dark Blue")
        return 0, 0.1, 0.4 -- Very Dark Blue
    elseif str == "S0" then
        --print("S0 - Dark Magenta")
        return 0.4, 0.1, 0.4 -- Dark Magenta
    elseif str == "S-" then
        --print("S- - Mustard Yellow")
        return 0.4, 0.4, 0.1 -- Mustard Yellow
    elseif str == "S=" then
        --print("S= - Sea Green")
        return 0.1, 0.4, 0.4 -- Sea Green
    elseif str == "NONE" then
        return 0.0, 0.0, 0.0 -- Black - for do nothing
        -- AI Generated Below
    elseif str == "SZ" then
        --print("SZ - Bright Green")
        return 0, 1, 0.5 -- Bright Green
    elseif str == "SX" then
        --print("SX - Dark Yellow")
        return 0.5, 0.5, 0 -- Dark Yellow
    elseif str == "SC" then
        --print("SC - Bright Purple")
        return 0.5, 0, 0.5 -- Bright Purple
    elseif str == "SV" then
        --print("SV - Bright Cyan")
        return 0, 0.5, 0.5 -- Bright Cyan
    elseif str == "C1" then
        --print("C1 - Dark Mint")
        return 0, 0.5, 0.4 -- Dark Mint
    elseif str == "C2" then
        --print("C2 - Bright Blue")
        return 0, 0.5, 0.75 -- Bright Blue
    elseif str == "C3" then
        --print("C3 - Olive Green")
        return 0.5, 0.75, 0 -- Olive Green
    elseif str == "C4" then
        --print("C4 - Light Olive")
        return 0.75, 0.75, 0.25 -- Light Olive
    elseif str == "C5" then
        --print("C5 - Dark Red")
        return 0.5, 0, 0 -- Darker Red
    elseif str == "C6" then
        --print("C6 - Light Brown")
        return 0.5, 0.25, 0 -- Light Brown
    elseif str == "C7" then
        --print("C7 - Dark Cyan")
        return 0, 0.25, 0.5 -- Dark Cyan
    elseif str == "C8" then
        --print("C8 - Light Pink")
        return 1, 0.75, 0.75 -- Light Pink
    elseif str == "C9" then
        --print("C9 - Bright Mint")
        return 0, 1, 0.75 -- Bright Mint
    elseif str == "C0" then
        --print("C0 - Light Orange")
        return 1, 0.5, 0.25 -- Light Orange
    elseif str == "C-" then
        --print("C- - Dark Black")
        return 0.25, 0.25, 0.25 -- Dark Black
    elseif str == "C=" then
        --print("C= - Light Blue Green")
        return 0.25, 1, 0.75 -- Light Blue Green
    end

    return 0.0, 0.0, 0.0 -- Black - for do nothing
end

local function IsPlayerCastingOrChanneling()
    local isCasting = UnitCastingInfo("player") ~= nil
    local isChanneling = UnitChannelInfo("player") ~= nil

    return isCasting or isChanneling
end


if Zekili == nil then
    print("Zekili not loaded!")
else
    print("Zekili loaded!")
end


local frame = CreateFrame("Frame", "TutSquareFrame", UIParent)
frame:SetSize(20, 20)
frame:SetPoint("BOTTOMLEFT")
frame:SetFrameStrata("FULLSCREEN_DIALOG")

local texture = frame:CreateTexture(nil, "ARTWORK")
texture:SetBlendMode("DISABLE")
texture:SetAllPoints(frame)
texture:SetColorTexture(0, 0, 0)
texture:SetAlpha(1.0)

local lastPrintTime = 0
local function OnUpdate(self, elapsed)
    -- Accumulate elapsed time
    lastPrintTime = lastPrintTime + elapsed

    if Zekili == nil then return end

    -- Do nothing if we're currently casting, so we don't clip fists of fury type things
    if IsPlayerCastingOrChanneling() then
        texture:SetColorTexture(0, 0, 0)
        return
    end
    
    local keybindUpNext = Zekili.KeybindUpNext
    --local keybindUpNext = addon.KeybindUpNext

    local r, g, b = StringToRGB(keybindUpNext or "NONE")

    if debugPrint and lastPrintTime > 1 then
        print("Key: >" ..
            tostring(keybindUpNext) .. "< RGB: " .. tostring(r) .. ", " .. tostring(g) .. ", " .. tostring(b))
        lastPrintTime = 0
    end
    texture:SetColorTexture(r, g, b, 1)
end

frame:SetScript("OnUpdate", OnUpdate)
