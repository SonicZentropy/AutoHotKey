-- Zekili.lua
-- July 2024

local addon, ns = ...
Zekili = LibStub("AceAddon-3.0"):NewAddon( "Zekili", "AceConsole-3.0", "AceSerializer-3.0" )
Zekili.Version = C_AddOns.GetAddOnMetadata( "Zekili", "Version" )
Zekili.Flavor = C_AddOns.GetAddOnMetadata( "Zekili", "X-Flavor" ) or "Retail"

local format = string.format
local insert, concat = table.insert, table.concat

local GetBuffDataByIndex, GetDebuffDataByIndex = C_UnitAuras.GetBuffDataByIndex, C_UnitAuras.GetDebuffDataByIndex
local UnpackAuraData = AuraUtil.UnpackAuraData

local buildStr, _, _, buildNum = GetBuildInfo()

Zekili.CurrentBuild = buildNum

if Zekili.Version == ( "@" .. "project-version" .. "@" ) then
    Zekili.Version = format( "Dev-%s (%s)", buildStr, date( "%Y%m%d" ) )
    Zekili.IsDev = true
end

Zekili.AllowSimCImports = true

Zekili.IsRetail = function()
    return Zekili.Flavor == "Retail"
end

Zekili.IsWrath = function()
    return Zekili.Flavor == "Wrath"
end

Zekili.IsClassic = function()
    return Zekili.IsWrath()
end

Zekili.IsDragonflight = function()
    return buildNum >= 100000
end

Zekili.BuiltFor = 110000
Zekili.GameBuild = buildStr

ns.PTR = buildNum > 110000

ns.Patrons = "|cFFFFD100Current Status|r\n\n"
    .. "All existing specializations are currently supported, though healer priorities are experimental and focused on rotational DPS only.\n\n"
    .. "If you find odd recommendations or other issues, please follow the |cFFFFD100Issue Reports|r link below and submit all the necessary information to have your issue investigated.\n\n"
    .. "Please do not submit tickets for routine priority updates (i.e., from SimulationCraft).  I will routinely update those when they are published.  Thanks!"

do
    local cpuProfileDB = {}

    function Zekili:ProfileCPU( name, func )
        cpuProfileDB[ name ] = func
    end

	ns.cpuProfile = cpuProfileDB


	local frameProfileDB = {}

	function Zekili:ProfileFrame( name, f )
		frameProfileDB[ name ] = f
	end

	ns.frameProfile = frameProfileDB
end


ns.lib = {
    Format = {}
}


-- 04072017:  Let's go ahead and cache aura information to reduce overhead.
ns.auras = {
    target = {
        buff = {},
        debuff = {}
    },
    player = {
        buff = {},
        debuff = {}
    }
}

Zekili.Class = {
    specs = {},
    num = 0,

    file = "NONE",
    initialized = false,

	resources = {},
	resourceAuras = {},
    talents = {},
    pvptalents = {},
	auras = {},
	auraList = {},
    powers = {},
	gear = {},
    setBonuses = {},

	knownAuraAttributes = {},

    stateExprs = {},
    stateFuncs = {},
    stateTables = {},

	abilities = {},
	abilityByName = {},
    abilityList = {},
    itemList = {},
    itemMap = {},
    itemPack = {
        lists = {
            items = {}
        }
    },

    packs = {},

    pets = {},
    totems = {},

    potions = {},
    potionList = {},

	hooks = {},
    range = 8,
	settings = {},
    stances = {},
	toggles = {},
	variables = {},
}

Zekili.Scripts = {
    DB = {},
    Channels = {},
    PackInfo = {},
}

Zekili.State = {}

ns.hotkeys = {}
ns.keys = {}
ns.queue = {}
ns.targets = {}
ns.TTD = {}

ns.UI = {
    Displays = {},
    Buttons = {}
}

ns.debug = {}
ns.snapshots = {}


function Zekili:Query( ... )
	local output = ns

	for i = 1, select( '#', ... ) do
		output = output[ select( i, ... ) ]
    end

    return output
end


function Zekili:Run( ... )
	local n = select( "#", ... )
	local fn = select( n, ... )

	local func = ns

	for i = 1, fn - 1 do
		func = func[ select( i, ... ) ]
    end

    return func( select( fn, ... ) )
end


local debug = ns.debug
local active_debug
local current_display

local lastIndent = 0

function Zekili:SetupDebug( display )
    if not self.ActiveDebug then return end
    if not display then return end

    current_display = display

    debug[ current_display ] = debug[ current_display ] or {
        log = {},
        index = 1
    }
    active_debug = debug[ current_display ]
	active_debug.index = 1

	lastIndent = 0

	local pack = self.State.system.packName

    if not pack then return end

	self:Debug( "New Recommendations for [ %s ] requested at %s ( %.2f ); using %s( %s ) priority.", display, date( "%H:%M:%S"), GetTime(), self.DB.profile.packs[ pack ].builtIn and "built-in " or "", pack )
end


function Zekili:Debug( ... )
    if not self.ActiveDebug then return end
	if not active_debug then return end

	local indent, text = ...
	local start

	if type( indent ) ~= "number" then
		indent = lastIndent
		text = ...
		start = 2
	else
		lastIndent = indent
		start = 3
	end

	local prepend = format( indent > 0 and ( "%" .. ( indent * 4 ) .. "s" ) or "%s", "" )
	text = text:gsub("\n", "\n" .. prepend )
    text = format( "%" .. ( indent > 0 and ( 4 * indent ) or "" ) .. "s", "" ) .. text

    if select( start, ... ) ~= nil then
	    active_debug.log[ active_debug.index ] = format( text, select( start, ... ) )
    else
        active_debug.log[ active_debug.index ] = text
    end
    active_debug.index = active_debug.index + 1
end


local snapshots = ns.snapshots
local hasScreenshotted = false

function Zekili:SaveDebugSnapshot( dispName )
    local snapped = false
    local formatKey = ns.formatKey
    local state = Zekili.State

	for k, v in pairs( debug ) do
		if not dispName or dispName == k then
			for i = #v.log, v.index, -1 do
				v.log[ i ] = nil
			end

            -- Store previous spell data.
            local prevString = "\nprevious_spells:"

            -- Skip over the actions in the "prev" table that were added to computed the next recommended ability in the queue.
            local i, j = ( #state.predictions + 1 ), 1
            local spell = state.prev[i].spell or "no_action"

            if spell == "no_action" then
                prevString = prevString .. "  no history available"
            else
                local numHistory = #state.prev.history
                while i <= numHistory and spell ~= "no_action" do
                    prevString = format( "%s\n   %d - %s", prevString, j, spell )
                    i, j = i + 1, j + 1
                    spell = state.prev[i].spell or "no_action"
                end
            end
            prevString = prevString .. "\n\n"

            insert( v.log, 1, prevString )

            -- Store aura data.
            local auraString = "\nplayer_buffs:"
            local now = GetTime()

            local class = Zekili.Class

            for i = 1, 40 do
                local name, _, count, debuffType, duration, expirationTime, source, _, _, spellId, canApplyAura, isBossDebuff, castByPlayer = UnpackAuraData( GetBuffDataByIndex( "player", i ) )

                if not name then break end

                local aura = class.auras[ spellId ]
                local key = aura and aura.key
                if key and not state.auras.player.buff[ key ] then key = key .. " [MISSING]" end

                auraString = format( "%s\n   %6d - %-40s - %3d - %-6.2f", auraString, spellId, key or ( "*" .. formatKey( name ) ), count > 0 and count or 1, expirationTime > 0 and ( expirationTime - now ) or 3600 )
            end

            auraString = auraString .. "\n\nplayer_debuffs:"

            for i = 1, 40 do
                local name, _, count, debuffType, duration, expirationTime, source, _, _, spellId, canApplyAura, isBossDebuff, castByPlayer = UnpackAuraData( GetDebuffDataByIndex( "player", i ) )

                if not name then break end

                local aura = class.auras[ spellId ]
                local key = aura and aura.key
                if key and not state.auras.player.debuff[ key ] then key = key .. " [MISSING]" end

                auraString = format( "%s\n   %6d - %-40s - %3d - %-6.2f", auraString, spellId, key or ( "*" .. formatKey( name ) ), count > 0 and count or 1, expirationTime > 0 and ( expirationTime - now ) or 3600 )
            end

            if not UnitExists( "target" ) then
                auraString = auraString .. "\n\ntarget_auras:  target does not exist"
            else
                auraString = auraString .. "\n\ntarget_buffs:"

                for i = 1, 40 do
                    local name, _, count, debuffType, duration, expirationTime, source, _, _, spellId, canApplyAura, isBossDebuff, castByPlayer = UnpackAuraData( GetBuffDataByIndex( "target", i ) )

                    if not name then break end

                    local aura = class.auras[ spellId ]
                    local key = aura and aura.key
                    if key and not state.auras.target.buff[ key ] then key = key .. " [MISSING]" end

                    auraString = format( "%s\n   %6d - %-40s - %3d - %-6.2f", auraString, spellId, key or ( "*" .. formatKey( name ) ), count > 0 and count or 1, expirationTime > 0 and ( expirationTime - now ) or 3600 )
                end

                auraString = auraString .. "\n\ntarget_debuffs:"

                for i = 1, 40 do
                    local name, _, count, debuffType, duration, expirationTime, source, _, _, spellId, canApplyAura, isBossDebuff, castByPlayer = UnpackAuraData( GetDebuffDataByIndex( "target", i, "PLAYER" ) )

                    if not name then break end

                    local aura = class.auras[ spellId ]
                    local key = aura and aura.key
                    if key and not state.auras.target.debuff[ key ] then key = key .. " [MISSING]" end

                    auraString = format( "%s\n   %6d - %-40s - %3d - %-6.2f", auraString, spellId, key or ( "*" .. formatKey( name ) ), count > 0 and count or 1, expirationTime > 0 and ( expirationTime - now ) or 3600 )
                end
            end

            insert( v.log, 1, auraString )
            insert( v.log, 1, "targets:  " .. ( Zekili.TargetDebug or "no data" ) )
            insert( v.log, 1, self:GenerateProfile() )


            local performance
            local pInfo = ZekiliEngine.threadUpdates

            -- TODO: Include # of active displays, number of icons displayed.

            if pInfo then
                performance = string.format( "\n\nPerformance\n"
                    .. "|| Updates || Updates / sec || Avg. Work || Avg. Time || Avg. Frames || Peak Work || Peak Time || Peak Frames || FPS || Work Cap ||\n"
                    .. "|| %7d || %13.2f || %9.2f || %9.2f || %11.2f || %9.2f || %9.2f || %11.2f || %3d || %8.2f ||",
                    pInfo.updates, pInfo.updatesPerSec, pInfo.meanWorkTime, pInfo.meanClockTime, pInfo.meanFrames, pInfo.peakWorkTime, pInfo.peakClockTime, pInfo.peakFrames, GetFramerate() or 0, Zekili.maxFrameTime or 0 )
            end

            if performance then insert( v.log, performance ) end

            local custom = ""

            local pack = self.DB.profile.packs[ state.system.packName ]
            if not pack.builtIn then
                custom = format( " |cFFFFA700(*%s[%d])|r", state.spec.name, state.spec.id )
            end

            local overview = format( "%s%s; %s|r", state.system.packName, custom, dispName or state.display )
            local recs = Zekili.DisplayPool[ dispName or state.display ].Recommendations

            for i, rec in ipairs( recs ) do
                if not rec.actionName then
                    if i == 1 then
                        overview = format( "%s - |cFF666666N/A|r", overview )
                    end
                    break
                end
                overview = format( "%s%s%s|cFFFFD100(%0.2f)|r", overview, ( i == 1 and " - " or ", " ), class.abilities[ rec.actionName ].name, rec.time )
            end

            insert( v.log, 1, overview )

            local snap = {
                header = "|cFFFFD100[" .. date( "%H:%M:%S" ) .. "]|r " .. overview,
                log = concat( v.log, "\n" ),
                data = ns.tableCopy( v.log ),
                recs = {}
            }

            insert( snapshots, snap )
            snapped = true
		end
    end

    -- Limit screenshot to once per login.
    if snapped then
        if Zekili.DB.profile.screenshot and ( not hasScreenshotted or Zekili.ManualSnapshot ) then
            Screenshot()
            hasScreenshotted = true
        end
        return true
    end

    return false
end

Zekili.Snapshots = ns.snapshots



ns.Tooltip = CreateFrame( "GameTooltip", "ZekiliTooltip", UIParent, "GameTooltipTemplate" )
Zekili:ProfileFrame( "ZekiliTooltip", ns.Tooltip )
