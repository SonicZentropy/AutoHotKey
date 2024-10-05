local _, addon = ...;

-- Create a frame
function createZenFrame() 
	--addon.isShowing = true

	Zen_ParentFrame = CreateFrame("Frame", "Zen_ParentFrame", UIParent)
	Zen_ParentFrame:SetResizable(true)
	Zen_ParentFrame:SetMovable(true)
	Zen_ParentFrame:EnableMouse(true)
	Zen_ParentFrame:SetWidth(420)
	Zen_ParentFrame:SetHeight(120)
	--Zen_ParentFrame:SetMinResize(300, 90) -- Real, change back to this
	Zen_ParentFrame:SetResizeBounds(300, 90, 500, 200)
	--Zen_ParentFrame:SetMaxResize(500, 200)
	Zen_ParentFrame:RegisterForDrag("LeftButton")
	Zen_ParentFrame:SetScript("OnDragStart", function(self) self:StartMoving() end)
	Zen_ParentFrame:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)
	
	
	-- Texture
	Zen_ParentFrameTexture = Zen_ParentFrame:CreateTexture(nil, "Background")
	Zen_ParentFrameTexture:ClearAllPoints()
	--Zen_ParentFrameTexture:SetColorTexture(35/255, 35/255, 35/255, 0.0)
	--Zen_ParentFrameTexture:SetAllPoints(Zen_ParentFrame)
	------
	
	-- Resize Button
	local resizeButton = CreateFrame("Button", nil, Zen_ParentFrame)
	resizeButton:SetSize(16, 16)
	resizeButton:SetPoint("BOTTOMRIGHT")
	resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
	resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
	resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
 
	resizeButton:SetScript("OnMouseDown", function(self, button)
    Zen_ParentFrame:StartSizing("BOTTOMRIGHT")
    Zen_ParentFrame:SetUserPlaced(true)
end)
 
	resizeButton:SetScript("OnMouseUp", function(self, button)
    Zen_ParentFrame:StopMovingOrSizing()
end)
	--
	

	-- Header Panel
	Zen_HeaderPanel = CreateFrame("Frame", "Zen_HeaderFrame", Zen_ParentFrame)	
	Zen_HeaderPanel:SetFrameStrata("Background")
	--Zen_HeaderPanel:SetAllPoints(Zen_ParentFrame)
	

	
	-- Header Texture
	Zen_HeaderPanelTexture = Zen_HeaderPanel:CreateTexture(nil, "Background")

	Zen_HeaderPanelTexture:ClearAllPoints()
	Zen_HeaderPanelTexture:SetColorTexture(62/255, 59/255, 55/255, 0.75)
	Zen_HeaderPanelTexture:SetAllPoints(Zen_HeaderPanel)
	
	-- Header Text
	headerZen = Zen_HeaderPanel:CreateFontString("Zen_HeaderText", "ARTWORK", "GameFontNormal")
	headerZen:SetPoint("TOPLEFT", 5, -4)
	headerZen:SetPoint("TOPRIGHT", 5, -4)
	headerZen:SetFont("Fonts\\SKURRI.TTF", 16, "OUTLINE")
	headerZen:SetTextColor(239/255, 191/255, 90/255)
	headerZen:SetJustifyH("LEFT")
	headerZen:SetJustifyV("MIDDLE")
	headerZen:SetText("Nerubar Palace Cliffs Notes")
	headerZen:SetWordWrap(true)
	
	Zen_HeaderPanel:SetPoint("TOPLEFT", Zen_ParentFrame, "TOPLEFT", 0, 0)
	Zen_HeaderPanel:SetPoint("TOPRIGHT", Zen_ParentFrame, "TOPRIGHT", 0, 0)
	Zen_HeaderPanel:SetHeight(22)
	Zen_HeaderPanel:SetWidth(450)
	Zen_HeaderPanel:Show()
	
	
	-----------------
	-- TIPS PANEL ---
	-----------------
	Zen_TipPanel = CreateFrame("Frame", "Zen_TipFrame", Zen_ParentFrame)
	
	Zen_TipPanel:SetFrameStrata("Background")
	Zen_TipPanel:SetWidth(450)
	--Zen_TipPanel:SetHeight(98)
	Zen_TipPanel:SetPoint("TOPLEFT", Zen_HeaderPanel, "BOTTOMLEFT", 0, 0)
	Zen_TipPanel:SetPoint("TOPRIGHT", Zen_HeaderPanel, "BOTTOMRIGHT", 0, 0)
	Zen_TipPanel:SetPoint("BOTTOMLEFT", Zen_ParentFrame, "BOTTOMLEFT", 0, 0)
	Zen_TipPanel:SetPoint("BOTTOMRIGHT", Zen_ParentFrame, "BOTTOMRIGHT", 0, 0)
	
	-- Tip Texture
	Zen_TipPanelTexture = Zen_TipPanel:CreateTexture(nil, "Background")
	--Zen_TipPanelTexture:SetWidth(128)
	--Zen_TipPanelTexture:SetHeight(64)
	Zen_TipPanelTexture:ClearAllPoints()
	Zen_TipPanelTexture:SetColorTexture(55/255, 55/255, 55/255, 0.45)
	Zen_TipPanelTexture:SetAllPoints(Zen_TipPanel)
	
	
	Zen_TipPanel:Show()
	
	

	Zen_MobName = Zen_TipPanel:CreateFontString("Zen_MobName", "OVERLAY", "GameFontNormal")
	Zen_MobName:SetPoint("TOPLEFT", 5, -5)
	Zen_MobName:SetPoint("TOPRIGHT", 5, -5)
	Zen_MobName:SetWordWrap(true)
	Zen_MobName:SetFont("Fonts\\ARIALN.ttf", 16, "OUTLINE")
	Zen_MobName:SetJustifyH("LEFT")
	Zen_MobName:SetJustifyV("TOP")
	Zen_MobName:SetText(" ")

	-- Frame Tip Text
	Zen_TipText = Zen_TipPanel:CreateFontString(nil, "OVERLAY", "GameFontNormal") -- "Zen_TipText"
	Zen_TipText:SetPoint("TOPLEFT", Zen_MobName, "BOTTOMLEFT", 0, -3)
	Zen_TipText:SetPoint("TOPRIGHT", Zen_MobName, "BOTTOMRIGHT", -3, -3)
	Zen_TipText:SetPoint("BOTTOMLEFT", Zen_ParentFrame, "BOTTOMLEFT", 0, 0)
	Zen_TipText:SetPoint("BOTTOMRIGHT", Zen_ParentFrame, "BOTTOMRIGHT", 0, 0)
	--Zen_TipText:SetFont("Fonts\\ARIALN.ttf", 14, nil)
	Zen_TipText:SetFontObject(GameFontWhite);
	local p,_,_ = Zen_TipText:GetFont();
	--print("Creating Frame" .. ZenConfig.FontSize)
	Zen_TipText:SetFont(p, ZenConfig.FontSize, nil)
	Zen_TipText:SetWidth(445)
	Zen_TipText:SetJustifyH("LEFT")
	Zen_TipText:SetJustifyV("TOP")
	Zen_TipText:SetText(" ")
	-----------------------
	
	
	-- Show Frame
	Zen_ParentFrame:SetPoint("CENTER", UIParent)
	Zen_ParentFrame:Show()	
	
	
	Zen_ParentFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
	Zen_ParentFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
	Zen_ParentFrame:RegisterEvent("ENCOUNTER_START")
	Zen_ParentFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	Zen_ParentFrame:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")
	Zen_ParentFrame:SetScript("OnEvent", function(self, event, ...)

		if event == "PLAYER_ENTERING_WORLD" then
			C_Timer.After(2, function() addon:setEnabled() end)
			--addon:setEnabled()
		elseif event == "PLAYER_TARGET_CHANGED" then
			--print("Player target changed" .. ZenConfig.TargetTrigger .. Zen_onBoss)
			if ZenConfig.TargetTrigger == "Show targeted mob" and not Zen_onBoss then addon:getTarget("target") end	
			
		elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" and UnitExists("boss1") then
			--Zen_onBoss = true
			
			if ZenConfig.ShowFrame == "Show in separate frame" then 
				addon:colorFrame(Zen_onBoss)
				addon:getTarget("boss1") 
			end
			
		elseif event == "PLAYER_REGEN_ENABLED" then
			Zen_onBoss = false
			addon:colorFrame(Zen_onBoss)
		end
		
		
		
		
	end)
	
	
	--Zen_ParentFrame:SetClampedToScreen(true)
	
	--[[
	


	

	-- Create slim header panel to hold title.
	
	Zen_HeaderPanel:SetFrameStrata("Background")
	Zen_HeaderPanel:SetWidth(450)
	Zen_HeaderPanel:SetHeight(22)
	Zen_HeaderPanel:EnableMouse(true)
	Zen_HeaderPanel:SetMovable(true)
	Zen_HeaderPanel:RegisterForDrag("LeftButton")
	Zen_HeaderPanel:SetScript("OnDragStart", function(self) self:StartMoving() end)
	Zen_HeaderPanel:SetScript("OnDragStop", function(self) self:StopMovingOrSizing() end)

	Zen_ParentFrameTexture = Zen_HeaderPanel:CreateTexture(nil, "Background")
	--Zen_TipPanelTexture:SetWidth(128)
	--Zen_TipPanelTexture:SetHeight(64)
	Zen_ParentFrameTexture:ClearAllPoints()
	Zen_ParentFrameTexture:SetColorTexture(35/255, 35/255, 35/255, 0.55)
	Zen_ParentFrameTexture:SetAllPoints(Zen_HeaderPanel)

	Zen_HeaderPanel:SetPoint("CENTER", UIParent)
	Zen_HeaderPanel:Show()
	Zen_HeaderPanel:SetClampedToScreen(true)


	
	
	





	Zen_ConfigBtn = CreateFrame("Button", "Zen_ConfigButton", Zen_HeaderPanel)
	Zen_ConfigBtn:SetFrameLevel(5)
	Zen_ConfigBtn:ClearAllPoints()
	Zen_ConfigBtn:SetHeight(16)
	Zen_ConfigBtn:SetWidth(16)
	Zen_ConfigBtn:SetNormalTexture("Interface\\Buttons\\UI-OptionsButton")
	Zen_ConfigBtn:SetHighlightTexture("Interface\\Buttons\\UI-OptionsButton", 1.0)
	Zen_ConfigBtn:SetAlpha(0.45)
	Zen_ConfigBtn:SetPoint("TOPRIGHT", Zen_HeaderPanel, "TOPRIGHT", -4, -2)

	Zen_ConfigBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
	Zen_ConfigBtn:SetScript("OnClick", function()
		InterfaceOptionsFrame_OpenToCategory(addon.configPanel)
		InterfaceOptionsFrame_OpenToCategory(addon.configPanel)
		
	end)
	Zen_ConfigBtn:Show()
	
	-- Minimize Button
	minimizeBtn = CreateFrame("Button", "minimize", Zen_HeaderPanel)
	minimizeBtn:SetFrameLevel(5)
	minimizeBtn:ClearAllPoints()
	minimizeBtn:SetHeight(30)
	minimizeBtn:SetWidth(30)
	minimizeBtn:SetNormalTexture("Interface\\Buttons\\UI-MultiCheck-Up")
	minimizeBtn:SetHighlightTexture("Interface\\Buttons\\UI-MultiCheck-Up", 1.0)
	minimizeBtn:SetAlpha(0.45)
	minimizeBtn:SetPoint("TOPRIGHT", Zen_HeaderPanel, "TOPRIGHT", -17, 5)
	minimizeBtn:SetScript("OnClick", function()
		addon:setMinimized()
		
	end)
	
	minimizeBtn:Show()
	
 --]]
end



--[[
lockBtn = CreateFrame("Button", "lock", Zen_HeaderPanel)
lockBtn:SetFrameLevel(5)
lockBtn:ClearAllPoints()
lockBtn:SetHeight(25)
lockBtn:SetWidth(25)
lockBtn:SetNormalTexture("Interface\\Buttons\\LockButton-Unlocked-Up")
lockBtn:SetHighlightTexture("Interface\\Buttons\\LockButton-Unlocked-Up", 1.0)
lockBtn:SetAlpha(0.35)
lockBtn:SetPoint("TOPRIGHT", Zen_HeaderPanel, "TOPRIGHT", -17, 0)

lockBtn:RegisterForClicks("LeftButtonUp", "RightButtonUp")
lockBtn:SetScript("OnClick", function()
	InterfaceOptionsFrame_OpenToCategory(configPanel)
	InterfaceOptionsFrame_OpenToCategory(configPanel)
	
end)
lockBtn:Show()
]]--

-- Returns true or false depending on if the user wants the addon on in the current instance.
function addon:checkInstance()
		-- Check if in raid or Mythic+
	local inInstance, instanceType = IsInInstance()
	local _, _, difficultyID = GetInstanceInfo()	
	
	local instanceAllowed = true
	if difficultyID == 8 then 
		if ZenConfig.MythicPlusToggle then
			instanceAllowed = true
		else
			instanceAllowed = false
		end
	elseif instanceType == "raid" then
		if ZenConfig.RaidToggle then
			instanceAllowed = true
		else
			instanceAllowed = false
		end	
	end
	return instanceAllowed

end

function addon:setEnabled()
	local inInstance, instanceType = IsInInstance()
	local mapID = C_Map.GetBestMapForUnit("player")
	
	--Zen_MobName:SetText("")
	--Zen_TipText:SetText("")
	

	if inInstance and ZenConfig.ShowFrame == "Show in separate frame" and (
		addon.acceptedDungeons[mapID] or (mapID and mapID ~= nil and
		((mapID > 1833 and mapID < 1911) or -- Torghast Maps
		(mapID > 1756 and mapID < 1812)))) -- Torghast Maps
		 then
		if addon:checkInstance() then
			--Zen_HeaderPanel:Show()
			Zen_ParentFrame:Show()
		else
			Zen_ParentFrame:Hide()
		end
	
		--elseif difficultyID == 
			
		--local mapID = C_Map.GetBestMapForUnit("player")
		--if not acceptedDungeons[mapID] then return end	
		--local isShown = Zen_TipPanel:IsVisible()
		--print(isShown)
		
		
		--if not isShown then
		--	Zen_TipPanel:Hide()
		--end
	else
		Zen_ParentFrame:Hide()
	end
end


function addon:setMinimized(forceShow)
	--if not Zen_TipText:IsVisible() or forceShow then
	if Zen_TipPanel:GetHeight() <= 26 then
		Zen_TipPanel:SetHeight(175)
		Zen_TipText:Show()
		
	else
		--Zen_TipPanel:Hide()
		Zen_TipPanel:SetHeight(25)
		Zen_TipText:Hide()
	end
end
		
		
function addon:setDropdownEnabled()
	if ZenConfig.ShowFrame == "Show in separate frame" then
		--targetDD:Show()
		addon.targetFS:Show()
		addon.chkTarget:Show()
		
	else
		--targetDD:Hide()
		addon.targetFS:Hide()
		addon.chkTarget:Hide()
	end

end


function addon:colorFrame(Zen_onBoss) 
	if Zen_onBoss then		
		Zen_TipPanelTexture:SetColorTexture(100/255, 80/255, 0/255, 0.55)	
		Zen_ParentFrameTexture:SetColorTexture(70/255, 50/255, 0/255, 0.55)		
	else
		Zen_TipPanelTexture:SetColorTexture(55/255, 55/255, 55/255, 0.55)	
		Zen_ParentFrameTexture:SetColorTexture(35/255, 35/255, 35/255, 0.55)
	end
end



Zen_onBoss = false



