
	--

local frame = CreateFrame("FRAME")
frame:RegisterEvent("GROUP_ROSTER_UPDATE")
frame:RegisterEvent("PLAYER_TARGET_CHANGED")
frame:RegisterEvent("UNIT_FACTION")

local function eventHandler(self, event, ...)
if UnitIsPlayer("target") then
c = RAID_CLASS_COLORS[select(2, UnitClass("target"))]
TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b)
end
end

frame:SetScript("OnEvent", eventHandler)

for _, BarTextures in pairs({TargetFrameNameBackground}) do
BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
end

	-- Class color names
--[[hooksecurefunc("UnitFrame_Update", function(self) 
        if UnitClass(self.unit) then 
        local c = (CUSTOM_CLASS_COLORS or RAID_CLASS_COLORS)[select(2,UnitClass(self.unit))] 
              --self.name:SetTextColor(c.r,c.g,c.b,1) --玩家及目标名字按职业染色
			  self.name:SetFont("Fonts\\Arial.ttf", 14, "OUTLINE")	--玩家及目标名字字体，大小
			  --self.name:SetPoint("CENTER", TargetFrameHealthBar, "CENTER", 0, 27)
		end
end)--]]

	zd = CreateFrame("Frame")
	zd:SetParent(TargetFrame)
	zd:SetPoint("BOTTOMLEFT",TargetFrame,-22,-27)
	zd:SetSize(253,125)
	zd:SetFrameLevel(0)
	zd.t = zd:CreateTexture(nil,"BACKGROUND")
	zd.t:SetAllPoints()
	zd.t:SetTexture("Interface\\AddOns\\defaultframeimproved\\dfi_textures\\UI-TargetingFrame-Minus-Flash")
	zd:Hide() 
	
	local function FrameOnUpdate(self) 
	if UnitAffectingCombat("target") then 
		self:Show() 
		else
		self:Hide() 
		end 
	end
	local g = CreateFrame("Frame") 
	g:SetScript("OnUpdate", function(self)
		if (UnitIsUnit("targettarget", "player")) then
			 zd.t:SetVertexColor(1,0,0,1)
		else
			 zd.t:SetVertexColor(0.8,0.8,0.8,1)
		end
	FrameOnUpdate(zd)
	end) 

function CreateStatusBarText(name, parentName, parent, point, x, y)
	local fontString = parent:CreateFontString(parentName..name, nil, "TextStatusBarText")
	fontString:SetPoint(point, parent, point, x, y)
	fontString:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")

	return fontString
end

	-- Add TargetFrame status text for classic
if (not FocusFrame) then
		TargetFrameHealthBar.TextString = CreateStatusBarText("Text", "TargetFrameHealthBar", TargetFrameTextureFrame, "CENTER", -50, 3)
		TargetFrameHealthBar.LeftText = CreateStatusBarText("TextLeft", "TargetFrameHealthBar", TargetFrameTextureFrame, "LEFT", 8, 8)
		TargetFrameHealthBar.RightText = CreateStatusBarText("TextRight", "TargetFrameHealthBar", TargetFrameTextureFrame, "RIGHT", -110, 8)
		
		TargetFrameManaBar.TextString = CreateStatusBarText("Text", "TargetFrameManaBar", TargetFrameTextureFrame, "CENTER", -50, -8)
		TargetFrameManaBar.LeftText = CreateStatusBarText("TextLeft", "TargetFrameManaBar", TargetFrameTextureFrame, "LEFT", 8, -8)
		TargetFrameManaBar.RightText = CreateStatusBarText("TextRight", "TargetFrameManaBar", TargetFrameTextureFrame, "RIGHT", -110, -8)
end
		
local function UpdatePlayerFrame()
		
		PlayerLevelText:SetFont("Fonts\\Arial.ttf", 14, "OUTLINE")
		TargetFrameTextureFrameLevelText:SetFont("Fonts\\Arial.ttf", 14, "OUTLINE")
		
		PlayerFrameHealthBarTextLeft:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
		PlayerFrameHealthBarTextRight:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
		
		PlayerFrameManaBarTextLeft:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
		PlayerFrameManaBarTextRight:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
		
		PlayerFrameHealthBarText:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
		PlayerFrameManaBarText:SetFont("Fonts\\FRIZQT__.ttf", 13, "OUTLINE")
		
	-- Name Color
		PlayerName:SetTextColor(1, 1, 1)
		TargetFrameTextureFrameName:SetTextColor(1, 1, 1)
		TargetFrameToTTextureFrameName:SetTextColor(1, 1, 1)
		
		PlayerName:SetFont("Fonts\\MORPHEUS_CYR.ttf", 14, "OUTLINE")
		TargetFrameTextureFrameName:SetFont("Fonts\\MORPHEUS_CYR.ttf", 14, "OUTLINE")
end
	
hooksecurefunc("PlayerFrame_UpdateArt", UpdatePlayerFrame)
PlayerFrame:HookScript("OnEvent", function(self, event)
    if event=="PLAYER_ENTERING_WORLD" then
        UpdatePlayerFrame()
    end
end)

hooksecurefunc("PlayerFrame_UpdateStatus", function() 
if IsResting("player") then 
	PlayerStatusTexture:Hide()
--	PlayerRestIcon:Hide()
	PlayerRestGlow:Hide()
--	PlayerStatusGlow:Hide() 
elseif PlayerFrame.inCombat then 
	PlayerStatusTexture:Hide()
--	PlayerAttackIcon:Hide()
--	PlayerRestIcon:Hide()
	PlayerAttackGlow:Hide()
	PlayerRestGlow:Hide()
	PlayerStatusGlow:Hide()
	PlayerAttackBackground:Hide() 
	end 
end)

hooksecurefunc("HealthBar_OnValueChanged",function(self,value)
  local min,max = self:GetMinMaxValues()
  if not value or value<min or value>max then
    return
  end
  -- change value to a percentage
  value = (max-min)>0 and (value-min)/(max-min) or 0
  -- recolor based on percentage
  if value>0.5 then
     self:SetStatusBarColor((1-value)*2,1,0)
  else
    self:SetStatusBarColor(1,value*2,0)
  end
end)

--	  Party Frames.
function whoaPartyFrames()
	if IsInGroup(player) and (not IsInRaid(player)) then 
		for i = 1, 4 do
			--_G["PartyMemberFrame"..i.."Name"]:SetSize(75,10);
			_G["PartyMemberFrame"..i]:SetScale(1.0)
		end
	end
end
--PartyMemberBuffTooltip:Kill() -- I personally hate this shit.
hooksecurefunc("UnitFrame_Update", whoaPartyFrames)
hooksecurefunc("PartyMemberFrame_ToPlayerArt", whoaPartyFrames)

--	Player class colors.
function whoaUnitClass(healthbar, unit)
	if UnitIsPlayer(unit) and UnitIsConnected(unit) and UnitClass(unit) and (classColor) then
		_, class = UnitClass(unit);
		local c = CUSTOM_CLASS_COLORS and CUSTOM_CLASS_COLORS[class] or RAID_CLASS_COLORS[class];
		healthbar:SetStatusBarColor(c.r, c.g, c.b);
	elseif UnitIsPlayer(unit) and (not UnitIsConnected(unit)) then
		healthbar:SetStatusBarColor(0.5,0.5,0.5);
	else
		healthbar:SetStatusBarColor(0,0.9,0);
	end
end
hooksecurefunc("UnitFrameHealthBar_Update", whoaUnitClass)

	-- Class Icons
hooksecurefunc("UnitFramePortrait_Update",function(self)
	if self.unit == "player" or self.unit == "pet" then
	SetPortraitToTexture("PlayerPortrait")
		return
	end
	if self.portrait then
		if UnitIsPlayer(self.unit) then
			local t = CLASS_ICON_TCOORDS[select(2,UnitClass(self.unit))]
			if t then
				self.portrait:SetTexture("Interface\\TargetingFrame\\UI-Classes-Circles")
				self.portrait:SetTexCoord(unpack(t))
			end
		else
			self.portrait:SetTexCoord(0,1,0,1)
		end
	end
end);

    --

--[[local f = CreateFrame("Frame")

local function CreateCombatIndicator(parentFrame, x, unitName)
  local CombatInicator = CreateFrame("Frame", nil, parentFrame)
  CombatInicator:SetPoint("CENTER", x, 10)
  CombatInicator:SetSize(28, 28)
  CombatInicator.t = CombatInicator:CreateTexture(nil, BORDER)
  CombatInicator.t:SetAllPoints()
  CombatInicator.t:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
  CombatInicator:SetAlpha(0)
  CombatInicator:SetScript(
    "OnUpdate",
    function(self)
      if UnitAffectingCombat(unitName) then
        self:SetAlpha(1)
      else
        self:SetAlpha(0)
      end
    end
  )
end

if (ScriptsDB.UNITFRAMES.COMBAT_INDICATORS) then
      CreateCombatIndicator(PlayerFrame, -112, "player")
      CreateCombatIndicator(TargetFrame, 112, "target")
end--]]