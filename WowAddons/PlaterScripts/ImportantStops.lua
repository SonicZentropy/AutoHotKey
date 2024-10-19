--ctor
function (self, unitId, unitFrame, envTable, scriptTable)
    
    local castBar = unitFrame.castBar
    local castBarPortion = castBar:GetWidth()/scriptTable.config.segmentsAmount
    local castBarHeight = castBar:GetHeight()
    
    unitFrame.felAnimation = unitFrame.felAnimation or {}
    
    if (not unitFrame.felAnimation.textureStretched) then
        unitFrame.felAnimation.textureStretched = castBar:CreateTexture(nil, "overlay", nil, 5)
    end
    
    if (not unitFrame.stopCastingX) then
        unitFrame.stopCastingX = castBar.FrameOverlay:CreateTexture(nil, "overlay", nil, 7)
        unitFrame.stopCastingX:SetPoint("center", unitFrame.castBar.Spark, "center", 0, 0)
        unitFrame.stopCastingX:SetTexture([[Interface\AddOns\Plater\Media\stop_64]])
        unitFrame.stopCastingX:SetSize(16, 16)
        unitFrame.stopCastingX:Hide()
    end
    
    if (not unitFrame.felAnimation.Textures) then
        unitFrame.felAnimation.Textures = {}
        
        for i = 1, 20 do
            local texture = castBar:CreateTexture(nil, "overlay", nil, 6)
            unitFrame.felAnimation.Textures[i] = texture            
            
            texture.animGroup = texture.animGroup or texture:CreateAnimationGroup()
            local animationGroup = texture.animGroup
            animationGroup:SetToFinalAlpha(true)            
            animationGroup:SetLooping("NONE")
            
            texture:SetTexture([[Interface\COMMON\XPBarAnim]])
            texture:SetTexCoord(0.2990, 0.0010, 0.0010, 0.4159)
            texture:SetBlendMode("ADD")
            
            texture.scale = animationGroup:CreateAnimation("SCALE")
            texture.scale:SetTarget(texture)
            
            texture.alpha = animationGroup:CreateAnimation("ALPHA")
            texture.alpha:SetTarget(texture)
            
            texture.alpha2 = animationGroup:CreateAnimation("ALPHA")
            texture.alpha2:SetTarget(texture)
        end
    end
    
    
    
end

----------------------------------------------------------------------------
--- On Show

function (self, unitId, unitFrame, envTable, scriptTable)
    local castBar = unitFrame.castBar
    envTable.castBarWidth = castBar:GetWidth()
    castBar.Spark:SetVertexColor(DetailsFramework:ParseColors(scriptTable.config.sparkColor))
    
    local textureStretched = unitFrame.felAnimation.textureStretched
    textureStretched:Show()
    textureStretched:SetVertexColor(DetailsFramework:ParseColors(scriptTable.config.glowColor))
    textureStretched:SetAtlas("XPBarAnim-OrangeTrail")
    textureStretched:ClearAllPoints()
    textureStretched:SetPoint("right", castBar.Spark, "center", 0, 0)
    textureStretched:SetHeight(castBar:GetHeight())
    textureStretched:SetBlendMode("ADD") 
    textureStretched:SetAlpha(0.5)
    textureStretched:SetDrawLayer("overlay", 7)
    
    for i = 1, scriptTable.config.segmentsAmount  do
        local texture = unitFrame.felAnimation.Textures[i]
        texture:SetVertexColor(1, 1, 1, 1)
        texture:SetDesaturated(true)
        
        local castBarPortion = castBar:GetWidth()/scriptTable.config.segmentsAmount
        
        texture:SetSize(castBarPortion+5, castBar:GetHeight())
        texture:SetDrawLayer("overlay", 6)
        
        texture:ClearAllPoints()
        if (i == scriptTable.config.segmentsAmount) then
            texture:SetPoint("right", castBar, "right", 0, 0)
        else
            texture:SetPoint("left", castBar, "left", (i-1)*castBarPortion, 2)
        end
        
        texture:SetAlpha(0)
        texture:Hide()
        
        texture.scale:SetOrder(1)
        texture.scale:SetDuration(0.5)
        texture.scale:SetScaleFrom(0.2, 1)
        texture.scale:SetScaleTo(1, 1.5)
        texture.scale:SetOrigin("right", 0, 0)
        
        local durationTime = DetailsFramework:GetBezierPoint(i / scriptTable.config.segmentsAmount, 0.2, 0.01, 0.6)
        local duration = abs(durationTime-0.6)
        --local duration = 0.6 --debug
        
        texture.alpha:SetOrder(1)
        texture.alpha:SetDuration(0.05)
        texture.alpha:SetFromAlpha(0)
        texture.alpha:SetToAlpha(0.4)
        
        texture.alpha2:SetOrder(1)
        texture.alpha2:SetDuration(duration) --0.6
        texture.alpha2:SetStartDelay(duration)
        texture.alpha2:SetFromAlpha(0.5)
        texture.alpha2:SetToAlpha(0)
    end
    
    unitFrame.stopCastingX:Show()
    
    envTable.CurrentTexture = 1
    envTable.NextPercent  = 100  / scriptTable.config.segmentsAmount
    
    self.Text:SetDrawLayer("artwork", 7)
    self.Spark:SetDrawLayer("artwork", 7)
    self.Spark:Hide()
end



-----------------------
--- On Update

function (self, unitId, unitFrame, envTable, scriptTable)
    
    local castBar = unitFrame.castBar
    local textures = unitFrame.felAnimation.Textures
    
    if (envTable._CastPercent > envTable.NextPercent) then
        local nextPercent = 100 / scriptTable.config.segmentsAmount
        
        textures[envTable.CurrentTexture]:Show()
        textures[envTable.CurrentTexture].animGroup:Play()
        
        envTable.NextPercent = envTable.NextPercent + nextPercent 
        envTable.CurrentTexture = envTable.CurrentTexture + 1
        
        --print(envTable.NextPercent, envTable.CurrentTexture)
        
        if (envTable.CurrentTexture == #textures) then
            envTable.NextPercent = 98
        elseif (envTable.CurrentTexture > #textures) then
            envTable.NextPercent = 999
        end
    end
    
    local normalizedPercent = envTable._CastPercent / 100
    local textureStretched = unitFrame.felAnimation.textureStretched
    local point = DetailsFramework:GetBezierPoint(normalizedPercent, 0, 0.001, 1)
    textureStretched:SetPoint("left", castBar, "left", point * envTable.castBarWidth, 0)
    
    self.ThrottleUpdate = 0
end

------------- On Hide


function (self, unitId, unitFrame, envTable, scriptTable)
    
    for i = 1, scriptTable.config.segmentsAmount  do
        local texture = unitFrame.felAnimation.Textures[i]
        texture:Hide()
    end
    
    local textureStretched = unitFrame.felAnimation.textureStretched
    textureStretched:Hide()    
    unitFrame.stopCastingX:Hide()
    
    self.Text:SetDrawLayer("overlay", 0)
    self.Spark:SetDrawLayer("overlay", 3)
    self.Spark:Show()
    
end




































