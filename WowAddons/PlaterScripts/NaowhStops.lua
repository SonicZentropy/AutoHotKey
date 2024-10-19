-------- CTOR
function (self, unitId, unitFrame, envTable, scriptTable)
    
    envTable.CastBarHeightAdd = scriptTable.config.castBarHeight
    envTable.Glow = scriptTable.config.glow
    envTable.UpdateColor = function(self)
        self:SetStatusBarColor (Plater:ParseColors (scriptTable.config.castbarColor))
    end    
    
    envTable.options = {
        color = "white", -- all plater color types accepted, from lib: {r,g,b,a}, color of lines and opacity, from 0 to 1.
        N = 8, -- number of lines. Defaul value is 8;
        frequency = 0.4, -- frequency, set to negative to inverse direction of rotation. Default value is 0.25;
        length = 12, -- length of lines. Default value depends on region size and number of lines;
        th = 1, -- thickness of lines. Default value is 2;
        xOffset = 1,
        yOffset = 1, -- offset of glow relative to region border;
        border = false, -- set to true to create border under lines;
        key = "pandemicGlow",
    }
end
--Made for NaowhUI





--------- Show
function (self, unitId, unitFrame, envTable, scriptTable)
    
    if (Plater.ZoneInstanceType == "arena" or Plater.ZoneInstanceType == "pvp" or Plater.ZoneInstanceType == "none") then
        return
    end
    if envTable.Glow then        
        Plater.StartPixelGlow(self, nil, envTable.options, envTable.options.key)
    end
    if envTable.castBarHeightAdd ~= 0 then
        local height = self:GetHeight()
        
        self:SetHeight (height + envTable.CastBarHeightAdd)
    end
    envTable.UpdateColor(self)
end

--------- Update

function (self, unitId, unitFrame, envTable, scriptTable)
    if (Plater.ZoneInstanceType == "arena" or Plater.ZoneInstanceType == "pvp" or Plater.ZoneInstanceType == "none") then
        return
    end    
    
    if envTable.Glow then       
        if not self.glowStarted then
            self.glowStarted = true
            Plater.StartPixelGlow(self, nil, envTable.options, envTable.options.key)
        end
    end
    envTable.UpdateColor(self)
end




---------- Hide 
function (self, unitId, unitFrame, envTable, scriptTable)
    if (Plater.ZoneInstanceType == "arena" or Plater.ZoneInstanceType == "pvp" or Plater.ZoneInstanceType == "none") then
        return
    end    
    
    unitFrame.castBar:SetHeight (envTable._DefaultHeight)
    if envTable.Glow then
        Plater.StopPixelGlow(self, envTable.options.key)
        self.glowStarted = false
    end
end

























