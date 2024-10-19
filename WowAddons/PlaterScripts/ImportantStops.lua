-- working ctor before making it its own UI element
function (self, unitId, unitFrame, envTable, scriptTable)
    
    local castBar = unitFrame.castBar
    local castBarHeight = castBar:GetHeight()
    
    
    if (not unitFrame.stopCastingX) then
        unitFrame.stopCastingX = castBar.FrameOverlay:CreateTexture(nil, "overlay", nil, 7)
        --unitFrame.stopCastingX:SetPoint("center", unitFrame.castBar.Spark, "center", 0, 0)
        unitFrame.stopCastingX:SetPoint("CENTER", castBar, "LEFT", 16, 0)
        unitFrame.stopCastingX:SetTexture([[Interface\AddOns\Plater\media\star_full_64]])
        unitFrame.stopCastingX:SetSize(48, 48)
        unitFrame.stopCastingX:SetAlpha(1)
        unitFrame.stopCastingX:SetDrawLayer("OVERLAY", 7)
        unitFrame.stopCastingX:Hide()
    end
    
    
    
    
end
























