
local _, addon = ...;

-- UI
ZenConf = {}
--local ACD = LibStub("MSA-AceConfigDialog-3.0")

local function RGBToHex(r, g, b)
	r = r <= 1 and r >= 0 and r or 0
	g = g <= 1 and g >= 0 and g or 0
	b = b <= 1 and b >= 0 and b or 0
	return string.format("%02x%02x%02x", r*255, g*255, b*255)
end

-- Saved Variables
ZenConfig = {	
	["Important"] = true,
	["PriorityTargets"] = true,
	["Defensives"] = true,
	["Interrupts"] = true,
	["Fluff"] = false,
	["Advanced"] = true,
	["Dodge"] = true,
	["RoleChoice"] = "Show my role only",
	["ClassChoice"] = "Show my class only",
	["ShowFrame"] = "Show in separate frame",
	["TargetTrigger"] = "Show targeted mob",
	
	["RaidToggle"] = true,
	["MythicPlusToggle"] = true,
	["FrameWidth"] = 450,
	["FrameHeight"] = 175,
	["FontSize"] = 12,
	["FrameOpacity"] = 0.55
}

ZenHallOfFameRR = {"== Rolls Royce ==", "Jaycob-Saurfang",
"Lightwrath-Whisperwind",
"Zikihra-Blackmoore",
"Splenduus",
"Meddah-Proudmoore",
"Csinál-Dragonmaw",
"Hastefreak-TwistingNether",
"Vicnoia-Icewind Point",
"Tízoc EU-Mal´Ganis",
"Cuddlybruce Argent Dawn",
"Katurn - Frostmourne",
"chewbaccas-Drakkari",
"Ðumplings Norgannon"}
ZenHallOfFameDiamond = {"== Diamond ==", 
"Eluminati-Hyjal",
"Zaalía-Area52",
"Arkadas-Proudmoore",
"Nollysham-Stormrage",
"Knowledge-Sargeras",
"Alloxa-Kazzak",
"Surrge-Stonemaul",
"Squishses-Proudmoore",
"Alfyhar-Zuljin",
"Nesuni",
"Amnyth",
"Prucewayne-Illidan",
"Zenashi",
"Aristeia-Eredar",
"Jinzhra-Draenor",
"Herbalsjr-stormrage",
"Bejeweled",
"Manatide-TheMaelstrom",
"Janae-Stormrage",
"Ådelyn-TwistingNether",
"Tizianah",
"Seedmoon-Silvermoon",
"Gingersnapmd Area52",
"Affrodite-Argent Dawn",
"Baradeth-Stormreaver",
"Moonrabbit-Sargeras",
"Squidkid",
"Nyrde-Draenor"}

ZenHallOfFameGold = {"== Gold ==", 
"Treeahje-Stormrage",
"Divinitee-Argent Dawn",
"Оссуми-Гордунни"
}

local function addPatronSet(array, color, frame)
	local arraySize = 0
	for i, patron in ipairs(array) do
		local lineHex = color
		local tipBase = frame:GetText()
		local endOfLine = "        "
		if i % 3 == 0 then
			--endOfLine = "\n"
		end
		frame:SetText(tipBase .. "|cff" .. lineHex .. " " .. patron .. "|r" .. endOfLine .. "\n")
		arraySize = arraySize + 1
		
	end
	if arraySize % 3 ~= 0 then
		frame:SetText(frame:GetText() .. "\n")
	end
		
end
	

-- Create Checkboxes
local function createCheck(label, description, frame, onClick)
	local check = CreateFrame("CheckButton", "ZenCheck" .. label, frame, "InterfaceOptionsCheckButtonTemplate")
	check:SetScript("OnClick", function(self)
		onClick(self)
	end)
	
	getglobal(check:GetName() .. 'Text'):SetText(description)
	
	return check
	
end


local function createString(frame, text, font, size)
	local fontString = frame:CreateFontString()
	fontString:SetFont(font, size)
	fontString:SetText(text)
	fontString:SetWidth(215)
	fontString:SetJustifyH("LEFT")
	fontString:SetJustifyV("TOP")
	
	return fontString
end

local function updateTextSize(size)
	local p,_,_ = Zen_TipText:GetFont();
	--print("Resetting Font Size" .. ZenConfig.FontSize)
	Zen_TipText:SetFont(p, ZenConfig.FontSize, nil)

end


--[[
function createDropdown(frame, label, option1, option2, changingVar)

	local dd = CreateFrame("Frame", label, frame, "UIDropDownMenuTemplate")
	
	local function dd_OnClick(self, arg1, arg2, checked)
		UIDropDownMenu_SetText(dd, arg1)
		ZenConfig[changingVar] = arg1
		setEnabled() -- This just clears the addons frame.
		setDropdownEnabled() -- This shows / hides a second dropdown based on the current selection.
	end
	
	function ddMenu(frame, level, menuList)
		local info = UIDropDownMenu_CreateInfo()
		info.func = dd_OnClick
		info.text, info.arg1, info.checked = option1, option1, ZenConfig[changingVar] == option1
		UIDropDownMenu_AddButton(info)
		info.text, info.arg1, info.checked = option2, option2, ZenConfig[changingVar] == option2
		UIDropDownMenu_AddButton(info)
	
	end
		
	UIDropDownMenu_Initialize(dd, ddMenu)
	UIDropDownMenu_SetWidth(dd, 180, 0);
	
	return dd
end
]]--


local function createNewConfigMenu()
	local frame = CreateFrame("Frame", "ZenConfiguration", UIParent)
	local background = frame:CreateTexture()
	background:SetAllPoints(frame)
	background:SetColorTexture(0.1, 0.1, 0.1, 0.5)
	
	-- Set up Title --
	local ddTitleString = frame:CreateFontString()
	ddTitleString:SetPoint("TOPLEFT", 10, -10)
	ddTitleString:SetFont("Fonts\\MORPHEUS.ttf", 22, "OUTLINE")
	ddTitleString:SetTextColor(0.9, 0.68, 0.22, 1)
	ddTitleString:SetText("Zen Mythic+ Dungeon Tips - Config")
	
	local chkGeneral = createCheck("General", "Show Important General Information", frame, function(self, value) end)
	chkGeneral:SetPoint("TOPLEFT", ddTitleString, "BOTTOMLEFT", 0, -10)
	chkGeneral:SetEnabled(false)
	chkGeneral:SetChecked(true)
	
	local chkPriority = createCheck("PriorityTargets", "Show Priority Targets", frame, function(self, value) ZenConfig.PriorityTargets = self:GetChecked() end)
	chkPriority:SetPoint("TOPLEFT", chkGeneral, "BOTTOMLEFT", 0, -8)
	
	local chkInterrupts = createCheck("Interrupts", "Show Priority Interrupts", frame, function(self, value) ZenConfig.Interrupts = self:GetChecked() end)
	chkInterrupts:SetPoint("TOPLEFT", chkPriority, "BOTTOMLEFT", 0, -8)
	
	local chkDefensives = createCheck("Defensives", "Show Defensive Recommendations", frame, function(self, value) ZenConfig.Defensives = self:GetChecked() end)
	chkDefensives:SetPoint("TOPLEFT", chkInterrupts, "BOTTOMLEFT", 0, -8)
	
	local chkFluff = createCheck("Fluff", "Show Fluff", frame, function(self, value) ZenConfig.Fluff = self:GetChecked() end)
	chkFluff:SetPoint("TOPLEFT", chkDefensives, "BOTTOMLEFT", 0, -8)
	
	local chkAdvanced = createCheck("Advanced", "Show advanced tips for high level keys", frame, function(self, value) ZenConfig.Advanced = self:GetChecked() end)
	chkAdvanced:SetPoint("TOPLEFT", chkFluff, "BOTTOMLEFT", 0, -8)
	
	----------------------------
	-- Setup "Dropdown" boxes --
	----------------------------
	-- Dropdown Taint Sucks
	local headerFont = "Fonts\\MORPHEUS.ttf"
	local headerSize = 16
	
	-- Tip Location Selector --
	local locFS = createString(frame, "Tip Location", headerFont, headerSize)
	locFS:SetPoint("TOPLEFT", chkAdvanced, "BOTTOMLEFT", 0, -30)
	
	--locDD = createDropdown(addon.configPanel, "TipLocation", "Show in separate frame", "Show in mob tooltips", "ShowFrame")
	--locDD:SetPoint("TOPLEFT", locFS, "BOTTOMLEFT", 0, -8)
	local locCB = createCheck("Location", "Show tips in separate frame", frame, 
			function(self, value)
				if self:GetChecked() then
					ZenConfig.ShowFrame = "Show in separate frame"
				else
					ZenConfig.ShowFrame = "Show in mob tooltips"
				end
				addon:setEnabled() -- This just clears the addons frame.
				--addon:setMinimized(true) -- Ensures the tip frame is showing.
				addon:setDropdownEnabled() -- This shows / hides a second dropdown based on the current selection.
			end)
	locCB.tooltip = "Uncheck to have tips appear in mob tooltips instead"
	locCB:SetPoint("TOPLEFT", locFS, "BOTTOMLEFT", 0, -8)

		-- Target / Mouseover Selector --
	addon.targetFS = createString(frame, "Show Target or Mouseover", headerFont, headerSize)
	addon.targetFS:SetPoint("TOPLEFT", locFS, "TOPRIGHT", 70, 0)
	
	--targetDD = createDropdown(addon.configPanel, "TargetMouseover", "Show targeted mob", "Show mouseover", "TargetTrigger")
	--targetDD:SetPoint("TOPLEFT", targetFS, "BOTTOMLEFT", 0, -8)
	addon.chkTarget = createCheck("Target", "Show Targeted Mob", frame,
			function(self, value)
				if self:GetChecked() then
					ZenConfig.TargetTrigger = "Show targeted mob"
				else
					ZenConfig.TargetTrigger = "Show mouseover"
				end
			end)
	addon.chkTarget:SetPoint("TOPLEFT", addon.targetFS, "BOTTOMLEFT", 0, -8)
	
	
	-- Role Selector --
	local roleFS = createString(frame, "Role Specific Tips", headerFont, headerSize)
	roleFS:SetPoint("TOPLEFT", locCB, "BOTTOMLEFT", 0, -14)
	
	--roleDD = createDropdown(addon.configPanel, "RoleSelector", "Show my role only", "Show all roles", "RoleChoice")
	--roleDD:SetPoint("TOPLEFT", roleFS, "BOTTOMLEFT", 0, -8)
	local chkRole = createCheck("Role", "Show all roles", frame, 
			function(self, value)
				if self:GetChecked() then
					ZenConfig.RoleChoice = "Show all roles"
				else
					ZenConfig.RoleChoice = "Show my role only"
				end
			end)
	chkRole:SetPoint("TOPLEFT", roleFS, "BOTTOMLEFT", 0, -8)
	
	-- Class Selector --
	local classFS = createString(frame, "Class Specific Tips", headerFont, headerSize)
	classFS:SetPoint("TOPLEFT", roleFS, "TOPRIGHT", 70, 0)
	
	--classDD = createDropdown(addon.configPanel, "ClassSelector", "Show my class only", "Show all classes", "ClassChoice")
	--classDD:SetPoint("TOPLEFT", classFS, "BOTTOMLEFT", 0, -8)
	local chkClass = createCheck("Class", "Show all classes", frame, 
			function(self, value)
				if self:GetChecked() then
					ZenConfig.ClassChoice = "Show all classes"
				else
					ZenConfig.ClassChoice = "Show my class only"
				end
			end)	
	chkClass:SetPoint("TOPLEFT", classFS, "BOTTOMLEFT", 0, -8)


	-- Other Stuff
	local OtherFS = createString(frame, "Font Size", headerFont, headerSize)
	OtherFS:SetPoint("TOPLEFT", classFS, "BOTTOMLEFT", 0, -54)
	
	--local deleteme = createString(addon.configPanel, "Delete me after", headerFont, headerSize)
	--deleteme:SetPoint("TOPLEFT", OtherFS, "BOTTOMLEFT", 0, -16)
	
	local sliderName = "FontSizeS"
	local fontEdit = CreateFrame("Slider", sliderName, frame, "OptionsSliderTemplate")
	
	fontEdit:SetWidth(120)
	fontEdit:SetHeight(20)
	fontEdit:SetOrientation('HORIZONTAL')
	fontEdit:SetMinMaxValues(8, 18)
	fontEdit:SetValue(ZenConfig.FontSize)
	fontEdit:SetValueStep(1)
	
	fontEdit.textLow = _G[sliderName.."Low"]
	fontEdit.textHigh = _G[sliderName.."High"]
	fontEdit.text = _G[sliderName.."Text"]
	fontEdit.minValue, fontEdit.maxValue = fontEdit:GetMinMaxValues() 
	fontEdit.textLow:SetText(fontEdit.minValue)
	fontEdit.textHigh:SetText(fontEdit.maxValue)
	fontEdit.text:SetText(ZenConfig.FontSize)
	
	fontEdit.textLow = 8
	fontEdit.textHigh = 14
	--fontEdit.text = "Font Size"
	
	
	fontEdit:SetPoint("TOPLEFT", OtherFS, "BOTTOMLEFT", 0, -22)
	fontEdit:Enable()
	fontEdit:SetScript("OnValueChanged", function(self,event,arg1) 
		
		ZenConfig.FontSize = math.floor(event + 0.5)
		updateTextSize()
		--print(ZenConfig.FontSize)
		self.text:SetText(ZenConfig.FontSize)
			end)
			
	--------------------
	---- Hall of Fame --
	--------------------
	--local hofFrame = CreateFrame("Frame", "HoFFrame", UIParent)
	--hofFrame:SetHeight(580)
	--hofFrame:SetWidth(580)
	--hofFrame:SetPoint("CENTER")
	
	--hofFrame.tex = hofFrame:CreateTexture()
	--hofFrame.tex:SetAllPoints(hofFrame)
	--hofFrame.tex:SetColorTexture(62/255, 59/255, 55/255, 0.75)
	--hofFrame:SetFrameLevel(8)
	--hofFrame:Hide()
	
	--local hofClose = CreateFrame("Button", "HoFClose", hofFrame, "UIPanelButtonTemplate")
	--hofClose:SetSize(25, 25)
	--hofClose:SetFrameLevel(9)
	--hofClose:ClearAllPoints()
	--hofClose:SetNormalTexture("Interface\\Buttons\\CancelButton-Up")
	----hofClose:SetHighlightTexture("Interface\\Buttons\\CancelButton-Up", 1.0)
	--hofClose:SetAlpha(0.85)
	--hofClose:SetPoint("TOPRIGHT", hofFrame, "TOPRIGHT", 0, 0)
	--hofClose:SetScript("OnClick", function()
	--	hofFrame:Raise()
	--	hofFrame:Hide()
		
	--end)
	
	---- Config Header Text
	--headerHof = hofFrame:CreateFontString("Zen_HeaderText", nil, nil)
	--headerHof:SetPoint("TOPLEFT", 5, -4)
	--headerHof:SetPoint("TOPRIGHT", 5, -4)
	--headerHof:SetFont("Fonts\\SKURRI.TTF", 16, "OUTLINE")
	----headerHof:SetTextColor(239/255, 191/255, 90/255)
	--headerHof:SetJustifyH("CENTER")
	--headerHof:SetJustifyV("MIDDLE")
	--headerHof:SetText("Questionably Epic Hall of Fame")
	--headerHof:SetWordWrap(true)
	
	
	--local hofButton = CreateFrame("Button", "HoFBtn", frame, "UIPanelButtonTemplate")
	--hofButton:SetSize(140, 27)
	--hofButton:SetText("Zen Hall of Fame")
	--hofButton:SetPoint("TopLeft", chkRole, "BOTTOMLEFT", 2, -22)
	--hofButton:SetScript("OnClick", function() 
	--	hofFrame:Show()
	--	--InterfaceOptionsFrame:Hide()
	--	--SettingsPanel:Hide()
	--	--HideUIPanel(GameMenuFrame)
	--end)
	
	--local RRText = hofFrame:CreateFontString("RRText", nil, nil)
	--RRText:SetPoint("TOPLEFT", 5, -44)
	--RRText:SetPoint("TOPRIGHT", 5, -44)
	--RRText:SetWordWrap(true)
	--RRText:SetFont("Fonts\\SKURRI.TTF", 18, "OUTLINE")
	--RRText:SetJustifyH("CENTER")
	--RRText:SetJustifyV("TOP")
	--RRText:SetText("Zen Patrons")
	
	--local thankyou = hofFrame:CreateFontString("RRThanks", nil, nil)
	--thankyou:SetPoint("TOPLEFT", 5, -65)
	--thankyou:SetPoint("TOPRIGHT", 5, -65)
	--thankyou:SetWordWrap(true)
	--thankyou:SetFont("Fonts\\SKURRI.TTF", 18, "OUTLINE")
	--thankyou:SetJustifyH("CENTER")
	--thankyou:SetJustifyV("TOP")
	--thankyou:SetText("Thank you so much for your support!")
	
	--local Zen_hofText = hofFrame:CreateFontString("RRPatrons", nil, nil)
	--Zen_hofText:SetPoint("TOPLEFT", "RRText", "BOTTOMLEFT", 5, -25)
	--Zen_hofText:SetPoint("TOPRIGHT", "RRText", "BOTTOMRIGHT", 5, -25)
	--Zen_hofText:SetWordWrap(true)
	--Zen_hofText:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	----Zen_hofText:SetTextColor(1, 0, 0)
	--Zen_hofText:SetJustifyH("LEFT")
	--Zen_hofText:SetJustifyV("TOP")
	--Zen_hofText:SetText(" ")
	
	--local Zen_hofText2 = hofFrame:CreateFontString("RRPatrons", nil, nil)
	--Zen_hofText2:SetPoint("TOPLEFT", "RRText", "BOTTOMLEFT", 5, -25)
	--Zen_hofText2:SetPoint("TOPRIGHT", "RRText", "BOTTOMRIGHT", 5, -25)
	--Zen_hofText2:SetWordWrap(true)
	--Zen_hofText2:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	----Zen_hofText2:SetTextColor(255, 0, 0, 255)
	--Zen_hofText2:SetJustifyH("CENTER")
	--Zen_hofText2:SetJustifyV("TOP")
	--Zen_hofText2:SetText(" ")
	
	--local Zen_hofText3 = hofFrame:CreateFontString("RRPatrons", nil, nil)
	--Zen_hofText3:SetPoint("TOPLEFT", "RRText", "BOTTOMLEFT", 5, -25)
	--Zen_hofText3:SetPoint("TOPRIGHT", "RRText", "BOTTOMRIGHT", 5, -25)
	--Zen_hofText3:SetWordWrap(true)
	--Zen_hofText3:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	----Zen_hofText3:SetTextColor(255, 0, 0, 255)
	--Zen_hofText3:SetJustifyH("RIGHT")
	--Zen_hofText3:SetJustifyV("TOP")
	--Zen_hofText3:SetText(" ")
	
	--addPatronSet(ZenHallOfFameRR, RGBToHex(0, 1, 150/255), Zen_hofText)
	--addPatronSet(ZenHallOfFameDiamond, RGBToHex(228/255, 35/255, 157/255), Zen_hofText2)
	--addPatronSet(ZenHallOfFameGold, RGBToHex(207/255, 181/255, 59/255), Zen_hofText3)
	
	-- Load in SavedVariables on ADDON_LOADED
	frame:RegisterEvent("ADDON_LOADED")
	frame:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" then
			-- Check for new variables added in a later release
			ZenConfig.ShowFrame = ZenConfig.ShowFrame or "Show in separate frame"
			ZenConfig.TargetTrigger = ZenConfig.TargetTrigger or "Show targeted mob"
			
			-- More variables added in a later release
			if ZenConfig.RaidToggle == nil then ZenConfig.RaidToggle = true end
			if ZenConfig.MythicPlusToggle == nil then ZenConfig.MythicPlusToggle = true end
			ZenConfig.FrameOpacity = ZenConfig.FrameOpacity or 0.55
			ZenConfig.FrameWidth = ZenConfig.FrameWidth or 450
			ZenConfig.FrameHeight = ZenConfig.FrameHeight or 175
			ZenConfig.FontSize = ZenConfig.FontSize or 14
			--print(ZenConfig.FontSize)
			
			-- Set default checkbox behaviour
			chkPriority:SetChecked(ZenConfig.PriorityTargets)
			chkInterrupts:SetChecked(ZenConfig.Interrupts)
			chkDefensives:SetChecked(ZenConfig.Defensives)
			chkFluff:SetChecked(ZenConfig.Fluff)
			chkAdvanced:SetChecked(ZenConfig.Advanced)
			--chkMythicPlus:SetChecked(ZenConfig.MythicPlusToggle)
			
			--chkRaid:SetChecked(ZenConfig.RaidToggle)
			
			-- Set default Drop Down text
			--UIDropDownMenu_SetText(locDD, ZenConfig.ShowFrame)
			--UIDropDownMenu_SetText(targetDD, ZenConfig.TargetTrigger)
			--UIDropDownMenu_SetText(roleDD, ZenConfig.RoleChoice)
			--UIDropDownMenu_SetText(classDD, ZenConfig.ClassChoice)
			-- "Drop downs"
			locCB:SetChecked(ZenConfig.ShowFrame == "Show in separate frame")
			addon.chkTarget:SetChecked(ZenConfig.TargetTrigger == "Show targeted mob")		
			chkRole:SetChecked(ZenConfig.RoleChoice == "Show all roles")
			chkClass:SetChecked(ZenConfig.ClassChoice == "Show all classes")
			
			updateTextSize()
			fontEdit.text:SetText(ZenConfig.FontSize)
			fontEdit:SetValue(ZenConfig.FontSize)
			
			addon:setEnabled()
			addon:setDropdownEnabled()
		end
	end);
	
	
	-- Proceed
	createZenFrame()
	

	--
	local category = Settings.RegisterCanvasLayoutCategory(frame, "Zen Dungeon Tips")
	Settings.RegisterAddOnCategory(category)
	

end


-- Create Panels
local function createConfigMenu()



	-- Setup Panel --
	addon.configPanel = CreateFrame("Frame", "ZenConfiguration", UIParent)
	addon.configPanel.name = "Zen Mythic+ Dungeon Tips";
	addon.configPanel.okay = function (self) return end
	addon.configPanel.cancel = function (self) return end
	
	-- Set up Title --
	local ddTitleString = addon.configPanel:CreateFontString()
	ddTitleString:SetPoint("TOPLEFT", 10, -10)
	ddTitleString:SetFont("Fonts\\MORPHEUS.ttf", 22, "OUTLINE")
	ddTitleString:SetTextColor(0.9, 0.68, 0.22, 1)
	ddTitleString:SetText("Zen Mythic+ Dungeon Tips - Config")

	
	
	-----------------------
	-- Set up Checkboxes --
	-----------------------
	local chkGeneral = createCheck("General", "Show Important General Information", addon.configPanel, function(self, value) end)
	chkGeneral:SetPoint("TOPLEFT", ddTitleString, "BOTTOMLEFT", 0, -10)
	chkGeneral:SetEnabled(false)
	chkGeneral:SetChecked(true)
	print(ZenConfig)
	
	local chkPriority = createCheck("PriorityTargets", "Show Priority Targets", addon.configPanel, function(self, value) ZenConfig.PriorityTargets = self:GetChecked() end)
	chkPriority:SetPoint("TOPLEFT", chkGeneral, "BOTTOMLEFT", 0, -8)
	
	local chkInterrupts = createCheck("Interrupts", "Show Priority Interrupts", addon.configPanel, function(self, value) ZenConfig.Interrupts = self:GetChecked() end)
	chkInterrupts:SetPoint("TOPLEFT", chkPriority, "BOTTOMLEFT", 0, -8)
	
	local chkDefensives = createCheck("Defensives", "Show Defensive Recommendations", addon.configPanel, function(self, value) ZenConfig.Defensives = self:GetChecked() end)
	chkDefensives:SetPoint("TOPLEFT", chkInterrupts, "BOTTOMLEFT", 0, -8)
	
	local chkFluff = createCheck("Fluff", "Show Fluff", addon.configPanel, function(self, value) ZenConfig.Fluff = self:GetChecked() end)
	chkFluff:SetPoint("TOPLEFT", chkDefensives, "BOTTOMLEFT", 0, -8)
	
	local chkAdvanced = createCheck("Advanced", "Show advanced tips for high level keys", addon.configPanel, function(self, value) ZenConfig.Advanced = self:GetChecked() end)
	chkAdvanced:SetPoint("TOPLEFT", chkFluff, "BOTTOMLEFT", 0, -8)
	
	
	----------------------------
	-- Setup "Dropdown" boxes --
	----------------------------
	-- Dropdown Taint Sucks
	local headerFont = "Fonts\\MORPHEUS.ttf"
	local headerSize = 16
	
	-- Tip Location Selector --
	local locFS = createString(addon.configPanel, "Tip Location", headerFont, headerSize)
	locFS:SetPoint("TOPLEFT", chkAdvanced, "BOTTOMLEFT", 0, -30)
	
	--locDD = createDropdown(addon.configPanel, "TipLocation", "Show in separate frame", "Show in mob tooltips", "ShowFrame")
	--locDD:SetPoint("TOPLEFT", locFS, "BOTTOMLEFT", 0, -8)
	local locCB = createCheck("Location", "Show tips in separate frame", addon.configPanel, 
			function(self, value)
				if self:GetChecked() then
					ZenConfig.ShowFrame = "Show in separate frame"
				else
					ZenConfig.ShowFrame = "Show in mob tooltips"
				end
				addon:setEnabled() -- This just clears the addons frame.
				--addon:setMinimized(true) -- Ensures the tip frame is showing.
				addon:setDropdownEnabled() -- This shows / hides a second dropdown based on the current selection.
			end)
	locCB.tooltip = "Uncheck to have tips appear in mob tooltips instead"
	locCB:SetPoint("TOPLEFT", locFS, "BOTTOMLEFT", 0, -8)
	
	
	-- Target / Mouseover Selector --
	addon.targetFS = createString(addon.configPanel, "Show Target or Mouseover", headerFont, headerSize)
	addon.targetFS:SetPoint("TOPLEFT", locFS, "TOPRIGHT", 70, 0)
	
	--targetDD = createDropdown(addon.configPanel, "TargetMouseover", "Show targeted mob", "Show mouseover", "TargetTrigger")
	--targetDD:SetPoint("TOPLEFT", targetFS, "BOTTOMLEFT", 0, -8)
	addon.chkTarget = createCheck("Target", "Show Targeted Mob", addon.configPanel, 
			function(self, value)
				if self:GetChecked() then
					ZenConfig.TargetTrigger = "Show targeted mob"
				else
					ZenConfig.TargetTrigger = "Show mouseover"
				end
			end)
	addon.chkTarget:SetPoint("TOPLEFT", addon.targetFS, "BOTTOMLEFT", 0, -8)
	
	
	-- Role Selector --
	local roleFS = createString(addon.configPanel, "Role Specific Tips", headerFont, headerSize)
	roleFS:SetPoint("TOPLEFT", locCB, "BOTTOMLEFT", 0, -14)
	
	--roleDD = createDropdown(addon.configPanel, "RoleSelector", "Show my role only", "Show all roles", "RoleChoice")
	--roleDD:SetPoint("TOPLEFT", roleFS, "BOTTOMLEFT", 0, -8)
	local chkRole = createCheck("Role", "Show all roles", addon.configPanel, 
			function(self, value)
				if self:GetChecked() then
					ZenConfig.RoleChoice = "Show all roles"
				else
					ZenConfig.RoleChoice = "Show my role only"
				end
			end)
	chkRole:SetPoint("TOPLEFT", roleFS, "BOTTOMLEFT", 0, -8)
	
	-- Class Selector --
	local classFS = createString(addon.configPanel, "Class Specific Tips", headerFont, headerSize)
	classFS:SetPoint("TOPLEFT", roleFS, "TOPRIGHT", 70, 0)
	
	--classDD = createDropdown(addon.configPanel, "ClassSelector", "Show my class only", "Show all classes", "ClassChoice")
	--classDD:SetPoint("TOPLEFT", classFS, "BOTTOMLEFT", 0, -8)
	local chkClass = createCheck("Class", "Show all classes", addon.configPanel, 
			function(self, value)
				if self:GetChecked() then
					ZenConfig.ClassChoice = "Show all classes"
				else
					ZenConfig.ClassChoice = "Show my class only"
				end
			end)	
	chkClass:SetPoint("TOPLEFT", classFS, "BOTTOMLEFT", 0, -8)
	
	-- Activate in
	-- Tip Location Selector --
	local showinFS = createString(addon.configPanel, "Content", headerFont, headerSize)
	showinFS:SetPoint("TOPLEFT", roleFS, "BOTTOMLEFT", 0, -54)
	
	local chkRegDungeons = createCheck("RegDungeons", "Show Tips in Dungeons", addon.configPanel, function(self, value) end)
	chkRegDungeons:SetPoint("TOPLEFT", showinFS, "BOTTOMLEFT", 0, -8)
	chkRegDungeons:SetEnabled(false)
	chkRegDungeons:SetChecked(true)
	
	--[[local chkMythicPlus = createCheck("MythicPlus", "Show Tips in Mythic+", addon.configPanel, function(self, value) 
		ZenConfig.MythicPlusToggle = self:GetChecked() 
		addon:setEnabled()
		end)
	chkMythicPlus:SetPoint("TOPLEFT", chkRegDungeons, "BOTTOMLEFT", 0, -8)]]--
	
	local chkRaid = createCheck("Raid", "Show Tips in Raid", addon.configPanel, function(self, value) 
		ZenConfig.RaidToggle = self:GetChecked() 
		addon:setEnabled()
	end)
	chkRaid:SetPoint("TOPLEFT", chkRegDungeons, "BOTTOMLEFT", 0, -8)
	

	-- Other Stuff
	local OtherFS = createString(addon.configPanel, "Font Size", headerFont, headerSize)
	OtherFS:SetPoint("TOPLEFT", classFS, "BOTTOMLEFT", 0, -54)
	
	--local deleteme = createString(addon.configPanel, "Delete me after", headerFont, headerSize)
	--deleteme:SetPoint("TOPLEFT", OtherFS, "BOTTOMLEFT", 0, -16)
	
	local sliderName = "FontSizeS"
	local fontEdit = CreateFrame("Slider", sliderName, addon.configPanel, "OptionsSliderTemplate")
	
	fontEdit:SetWidth(120)
	fontEdit:SetHeight(20)
	fontEdit:SetOrientation('HORIZONTAL')
	fontEdit:SetMinMaxValues(8, 18)
	fontEdit:SetValue(ZenConfig.FontSize)
	fontEdit:SetValueStep(1)
	
	fontEdit.textLow = _G[sliderName.."Low"]
	fontEdit.textHigh = _G[sliderName.."High"]
	fontEdit.text = _G[sliderName.."Text"]
	fontEdit.minValue, fontEdit.maxValue = fontEdit:GetMinMaxValues() 
	fontEdit.textLow:SetText(fontEdit.minValue)
	fontEdit.textHigh:SetText(fontEdit.maxValue)
	fontEdit.text:SetText(ZenConfig.FontSize)
	
	fontEdit.textLow = 8
	fontEdit.textHigh = 14
	--fontEdit.text = "Font Size"
	
	
	fontEdit:SetPoint("TOPLEFT", OtherFS, "BOTTOMLEFT", 0, -22)
	fontEdit:Enable()
	fontEdit:SetScript("OnValueChanged", function(self,event,arg1) 
		
		ZenConfig.FontSize = math.floor(event + 0.5)
		updateTextSize()
		--print(ZenConfig.FontSize)
		self.text:SetText(ZenConfig.FontSize)
			end)
	

	-- Hall of Fame --
	local hofFrame = CreateFrame("Frame", "HoFFrame", UIParent)
	hofFrame:SetHeight(580)
	hofFrame:SetWidth(580)
	hofFrame:SetPoint("CENTER")
	
	hofFrame.tex = hofFrame:CreateTexture()
	hofFrame.tex:SetAllPoints(hofFrame)
	hofFrame.tex:SetColorTexture(62/255, 59/255, 55/255, 0.75)
	hofFrame:SetFrameLevel(8)
	hofFrame:Hide()
	
	local hofClose = CreateFrame("Button", "HoFClose", hofFrame, "UIPanelButtonTemplate")
	hofClose:SetSize(25, 25)
	hofClose:SetFrameLevel(9)
	hofClose:ClearAllPoints()
	hofClose:SetNormalTexture("Interface\\Buttons\\CancelButton-Up")
	--hofClose:SetHighlightTexture("Interface\\Buttons\\CancelButton-Up", 1.0)
	hofClose:SetAlpha(0.85)
	hofClose:SetPoint("TOPRIGHT", hofFrame, "TOPRIGHT", 0, 0)
	hofClose:SetScript("OnClick", function()
		hofFrame:Hide()
		
	end)
	
	-- Config Header Text
	headerHof = hofFrame:CreateFontString("Zen_HeaderText", nil, nil)
	headerHof:SetPoint("TOPLEFT", 5, -4)
	headerHof:SetPoint("TOPRIGHT", 5, -4)
	headerHof:SetFont("Fonts\\SKURRI.TTF", 16, "OUTLINE")
	headerHof:SetTextColor(239/255, 191/255, 90/255)
	headerHof:SetJustifyH("CENTER")
	headerHof:SetJustifyV("CENTER")
	headerHof:SetText("Questionably Epic Hall of Fame")
	headerHof:SetWordWrap(true)
	
	
	local hofButton = CreateFrame("Button", "HoFBtn", addon.configPanel, "UIPanelButtonTemplate")
	hofButton:SetSize(140, 27)
	hofButton:SetText("Zen Hall of Fame")
	hofButton:SetPoint("TopLeft", chkRaid, "BOTTOMLEFT", 2, -22)
	hofButton:SetScript("OnClick", function() 
		hofFrame:Show()
		InterfaceOptionsFrame:Hide()
		HideUIPanel(GameMenuFrame)
	end)
	
	local RRText = hofFrame:CreateFontString("RRText", nil, nil)
	RRText:SetPoint("TOPLEFT", 5, -44)
	RRText:SetPoint("TOPRIGHT", 5, -44)
	RRText:SetWordWrap(true)
	RRText:SetFont("Fonts\\SKURRI.TTF", 18, "OUTLINE")
	RRText:SetJustifyH("CENTER")
	RRText:SetJustifyV("TOP")
	RRText:SetText("Zen Patrons")
	
	local thankyou = hofFrame:CreateFontString("RRThanks", nil, nil)
	thankyou:SetPoint("TOPLEFT", 5, -65)
	thankyou:SetPoint("TOPRIGHT", 5, -65)
	thankyou:SetWordWrap(true)
	thankyou:SetFont("Fonts\\SKURRI.TTF", 18, "OUTLINE")
	thankyou:SetJustifyH("CENTER")
	thankyou:SetJustifyV("TOP")
	thankyou:SetText("Thank you so much for your support!")
	
	local Zen_hofText = hofFrame:CreateFontString("RRPatrons", nil, nil)
	Zen_hofText:SetPoint("TOPLEFT", "RRText", "BOTTOMLEFT", 5, -25)
	Zen_hofText:SetPoint("TOPRIGHT", "RRText", "BOTTOMRIGHT", 5, -25)
	Zen_hofText:SetWordWrap(true)
	Zen_hofText:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	Zen_hofText:SetTextColor(1, 0, 0)
	Zen_hofText:SetJustifyH("LEFT")
	Zen_hofText:SetJustifyV("TOP")
	Zen_hofText:SetText(" ")
	
	local Zen_hofText2 = hofFrame:CreateFontString("RRPatrons", nil, nil)
	Zen_hofText2:SetPoint("TOPLEFT", "RRText", "BOTTOMLEFT", 5, -25)
	Zen_hofText2:SetPoint("TOPRIGHT", "RRText", "BOTTOMRIGHT", 5, -25)
	Zen_hofText2:SetWordWrap(true)
	Zen_hofText2:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	Zen_hofText2:SetTextColor(255, 0, 0, 255)
	Zen_hofText2:SetJustifyH("CENTER")
	Zen_hofText2:SetJustifyV("TOP")
	Zen_hofText2:SetText(" ")
	
	local Zen_hofText3 = hofFrame:CreateFontString("RRPatrons", nil, nil)
	Zen_hofText3:SetPoint("TOPLEFT", "RRText", "BOTTOMLEFT", 5, -25)
	Zen_hofText3:SetPoint("TOPRIGHT", "RRText", "BOTTOMRIGHT", 5, -25)
	Zen_hofText3:SetWordWrap(true)
	Zen_hofText3:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	Zen_hofText3:SetTextColor(255, 0, 0, 255)
	Zen_hofText3:SetJustifyH("RIGHT")
	Zen_hofText3:SetJustifyV("TOP")
	Zen_hofText3:SetText(" ")
	
	addPatronSet(ZenHallOfFameRR, RGBToHex(0, 1, 150/255), Zen_hofText)
	addPatronSet(ZenHallOfFameDiamond, RGBToHex(228/255, 35/255, 157/255), Zen_hofText2)
	addPatronSet(ZenHallOfFameGold, RGBToHex(207/255, 181/255, 59/255), Zen_hofText3)

	
	--[[
	local fontEdit = CreateFrame("EditBox", nil, addon.configPanel)
	fontEdit:SetMultiLine(false)
	fontEdit:SetWidth(40)
	fontEdit:SetText(12)
	fontEdit:SetFontObject(ChatFontNormal)
	fontEdit:SetPoint("TOPLEFT", OtherFS, "BOTTOMLEFT", 0, -8)
	fontEdit:SetEnabled(true) ]]--
	--chkRegDungeons:SetChecked(true)
	
	
	
	-- Load in SavedVariables on ADDON_LOADED
	addon.configPanel:RegisterEvent("ADDON_LOADED")
	addon.configPanel:SetScript("OnEvent", function(self, event, arg1)
		if event == "ADDON_LOADED" then
			-- Check for new variables added in a later release
			ZenConfig.ShowFrame = ZenConfig.ShowFrame or "Show in separate frame"
			ZenConfig.TargetTrigger = ZenConfig.TargetTrigger or "Show targeted mob"
			
			-- More variables added in a later release
			if ZenConfig.RaidToggle == nil then ZenConfig.RaidToggle = true end
			if ZenConfig.MythicPlusToggle == nil then ZenConfig.MythicPlusToggle = true end
			ZenConfig.FrameOpacity = ZenConfig.FrameOpacity or 0.55
			ZenConfig.FrameWidth = ZenConfig.FrameWidth or 450
			ZenConfig.FrameHeight = ZenConfig.FrameHeight or 175
			ZenConfig.FontSize = ZenConfig.FontSize or 14
			--print(ZenConfig.FontSize)
			
			-- Set default checkbox behaviour
			chkPriority:SetChecked(ZenConfig.PriorityTargets)
			chkInterrupts:SetChecked(ZenConfig.Interrupts)
			chkDefensives:SetChecked(ZenConfig.Defensives)
			chkFluff:SetChecked(ZenConfig.Fluff)
			chkAdvanced:SetChecked(ZenConfig.Advanced)
			--chkMythicPlus:SetChecked(ZenConfig.MythicPlusToggle)
			
			chkRaid:SetChecked(ZenConfig.RaidToggle)
			
			-- Set default Drop Down text
			--UIDropDownMenu_SetText(locDD, ZenConfig.ShowFrame)
			--UIDropDownMenu_SetText(targetDD, ZenConfig.TargetTrigger)
			--UIDropDownMenu_SetText(roleDD, ZenConfig.RoleChoice)
			--UIDropDownMenu_SetText(classDD, ZenConfig.ClassChoice)
			-- "Drop downs"
			locCB:SetChecked(ZenConfig.ShowFrame == "Show in separate frame")
			addon.chkTarget:SetChecked(ZenConfig.TargetTrigger == "Show targeted mob")		
			chkRole:SetChecked(ZenConfig.RoleChoice == "Show all roles")
			chkClass:SetChecked(ZenConfig.ClassChoice == "Show all classes")
			
			updateTextSize()
			fontEdit.text:SetText(ZenConfig.FontSize)
			fontEdit:SetValue(ZenConfig.FontSize)
			
			addon:setEnabled()
			addon:setDropdownEnabled()
		end
	end);
	
	-- Add panel to config options
	InterfaceOptions_AddCategory(addon.configPanel)
	
	-- Proceed
	createZenFrame()
end

createNewConfigMenu()


