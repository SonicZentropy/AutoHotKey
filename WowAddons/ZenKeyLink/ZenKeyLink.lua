--[[ZenKeyLinkDB = {
    ["keyResult"] = {
        ["party2Spec"] = "havoc",
        ["didComplete"] = true,
        ["party4Spec"] = "elemental",
        ["party1Spec"] = "resto",
        ["keystoneLevel"] = 10,
        ["finalTime"] = "30:03",
        ["selfSpec"] = "blood",
        ["timestamp"] = "11/02/24 04:42:35",
        ["dungeonID"] = 1234,
        ["party3Spec"] = "arcane",
    },
}]]
local addon, ns = ...

local ZenKeyLink = {}
ZenKeyLinkDB = ZenKeyLinkDB or {} -- Initialize the SavedVariables table


local debugPrint = false
local lastUpdate = 0
local lastPrintTime = 0
local updateInterval = 0.1 -- 1/10th of a second

-- Function to save data
function ZenKeyLink:SaveData(key, value)
    ZenKeyLinkDB[key] = value
end

-- Function to load data
function ZenKeyLink:LoadData(key)
    return ZenKeyLinkDB[key]
end

function ZenKeyLink:WriteMythicKeyResult(selfSpec, party1Spec, party2Spec, party3Spec, party4Spec, dungeonID, keystoneLevel, didComplete, finalTime)
    local keyResult = {
        selfSpec = selfSpec,
        party1Spec = party1Spec,
        party2Spec = party2Spec,
        party3Spec = party3Spec,
        party4Spec = party4Spec,
        dungeonID = dungeonID,
        keystoneLevel = keystoneLevel,
        didComplete = didComplete,
        finalTime = finalTime,
        timestamp = date("%m/%d/%y %H:%M:%S")
    }
    
    print("Key result:")
    print(keyResult)
    DevTools_Dump(keyResult)
    ZenKeyLink:SaveData("keyResult", keyResult)
end


local frame = CreateFrame("Frame", "ZenKeyLinkFrame", UIParent)
--frame:SetSize(40, 40)
--frame:SetPoint("CENTER")
--frame:SetFrameStrata("FULLSCREEN_DIALOG")

--local texture = frame:CreateTexture(nil, "OVERLAY")
--texture:SetBlendMode("DISABLE")
--texture:SetAllPoints(frame)
--texture:SetColorTexture(0, 0, 0)
--texture:SetAlpha(1.0)

local function PerformUpdate(elapsed)
    --TODO: Perform update
    ZenKeyLink:WriteMythicKeyResult("blood", "resto", "havoc", "arcane", "elemental", 1234, 10, true, "30:03")
end

local function OnUpdate(self, elapsed)
    lastPrintTime = lastPrintTime + elapsed
    if lastPrintTime >= updateInterval then
        PerformUpdate(elapsed)
        lastPrintTime = 0 -- Reset the timer
    end
end

frame:SetScript("OnUpdate", OnUpdate)
