--------------------------------------------------------------------------------
-- Custom Frame
--- Customisable tracker
--------------------------------------------------------------------------------

-- General Tracker variables
local AceGUI = LibStub("AceGUI-3.0")
local addonName, BGS_TrackerClasses = ...
local TestClass = {}
TestClass.__index = TestClass
setmetatable(TestClass, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

local _type = "Custom"

local TrackerClass = {}
TrackerClass.name = "Custom"
TrackerClass.detail = "Custom"
TrackerClass.icon = "Interface\\ICONS\\INV_Scroll_07"
TrackerClass.info = "Customise your own tracker using given options"
TrackerClass.options = {}
TrackerClass.colSpan = 1
TrackerClass.justify = "left"
TrackerClass.frame = nil
--local _defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions()
table.insert(BGS_TrackerClasses, {fType = _type, class = TestClass })
--table.insert(BGS_TrackerClasses, {class = TrackerClass})
-- Tracker Specific variables

local _replaceKeys = { {key ="Misc", value = "", header = true, info="Misc options"}
						,{key ="$hk1", value = function() return BGS_TrackerClasses:GetHKills()end, info="Character honorable kills"}--BGS_TrackerClasses:GetHKills()
						,{key ="$hk2", value = function() return BGS_TrackerClasses:GetAccHKills() end, info="Account honorable kills"}
						,{key ="$cur1", value = function() return BGS_TrackerClasses:GetHonor() end, info="Honor points"}
						,{key ="$cur2", value = function() return BGS_TrackerClasses:GetConquest() end, info="Conquest points"}
						,{key ="$cur3", value = function() return BGS_TrackerClasses:GetGarrisonResources() end, info="Garrison Resources"}
						,{key ="$cur4", value = function() return BGS_TrackerClasses:GetArtifactFragments() end, info="Artifact Fragments"}
						,{key ="$cap1", value = function() return BGS_TrackerClasses:GetConquestcap("all") end, info="Weekly overall conquest points gained"}
						,{key ="$cap2", value = function() return BGS_TrackerClasses:GetConquestcap("all", true) end, info="Weekly overall conquest point cap"}
						,{key ="$cap3", value = function() return BGS_TrackerClasses:GetConquestcap("rbg") end, info="Weekly rated BG conquest points gained"}
						,{key ="$cap4", value = function() return BGS_TrackerClasses:GetConquestcap("rbg", true) end, info="Weekly rated BG conquest point cap"}
						,{key ="$cap5", value = function() return BGS_TrackerClasses:GetConquestcap("arena") end, info="Weekly arena conquest points gained"}
						,{key ="$cap6", value = function() return BGS_TrackerClasses:GetConquestcap("arena", true) end, info="Weekly arena conquest point cap"}
						,{key ="$cap7", value = function() return BGS_TrackerClasses:GetConquestcap("random") end, info="Weekly random BG conquest points gained"}
						,{key ="$cap8", value = function() return BGS_TrackerClasses:GetConquestcap("random", true) end, info="Weekly random BG conquest point cap"}
						--,{key ="$cur(#)", value = function(input) print("you used:" ..input); return BGS_TrackerClasses:GetConquest() end, info="Custom currency where # = currency id"}
						,{key ="WinRates", value = "", header = true, info="Winrate options"}
						,{key = "$wrbf1", value = function() return BGS_TrackerClasses:BGS_GetWinrateString(_currentBG, "full", IsRatedBattleground()) end, info="Current Battlefield shown as w : l (%)"}
						,{key = "$wrbf2", value = function() return BGS_TrackerClasses:BGS_GetWinrateString(_currentBG, "games", IsRatedBattleground()) end, info="Current Battlefield shown as w : l"}
						,{key = "$wrbf3", value = function() return BGS_TrackerClasses:BGS_GetWinrateString(_currentBG, "rate", IsRatedBattleground()) end, info="Current Battlefield shown as %"}
						,{key = "$wrbg1", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Random Battlegrounds", "full") end, info="Total random BG shown as w : l (%)"}
						,{key = "$wrbg2", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Random Battlegrounds", "games") end, info="Total random BG shown as w : l"}
						,{key = "$wrbg3", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Random Battlegrounds", "rate") end, info="Total random BG shown as %"}
						,{key = "$wra1", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Arenas", "full") end, info="Total arena shown as w : l (%)"}
						,{key = "$wra2", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Arenas", "games") end, info="Total arena shown as w : l"}
						,{key = "$wra3", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Arenas", "rate") end, info="Total arena shown as %"}
						,{key = "$wrr1", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Rated Battlegrounds", "full", true) end, info="Total rated BG shown as w : l (%)"}
						,{key = "$wrr2", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Rated Battlegrounds", "games", true) end, info="Total rated BG shown as w : l"}
						,{key = "$wrr3", value = function() return BGS_TrackerClasses:BGS_GetWinrateString("Rated Battlegrounds", "rate", true) end, info="Total rated BG shown as %"}
						,{key ="Score", value = "", header = true, info="Scoreboard options"}
						,{key = "$sb1", value = function() return BGS_TrackerClasses:GetBGInfo("KillingBlows") end, info="Killing blows"}
						,{key = "$sb2", value = function() return BGS_TrackerClasses:GetBGInfo("HonorableKills") end, info="Honorable kills"}
						,{key = "$sb3", value = function() return BGS_TrackerClasses:GetBGInfo("Deaths") end, info="Deaths"}
						,{key = "$sb4", value = function() return BGS_TrackerClasses:GetBGInfo("DamageDone") end, info="Damage done"}
						,{key = "$sb5", value = function() return BGS_TrackerClasses:GetBGInfo("HealingDone") end, info="Healing done"}
						,{key = "$sbr1", value = function() return BGS_TrackerClasses:GetBGScoreRank("kills") end, info="Killing blows rank"}
						,{key = "$sbr2", value = function() return BGS_TrackerClasses:GetBGScoreRank("hk") end, info="Honorable kills rank"}
						,{key = "$sbr3", value = function() return BGS_TrackerClasses:GetBGScoreRank("deaths") end, info="Deaths rank"}
						,{key = "$sbr4", value = function() return BGS_TrackerClasses:GetBGScoreRank("damage") end, info="Damage rank"}
						,{key = "$sbr5", value = function() return BGS_TrackerClasses:GetBGScoreRank("healing") end, info="Healing rank"}
						,{key ="Rated", value = "", header = true, info="Rated options"}
						,{key = "$r21", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 1) end, info="2v2 rating"}
						,{key = "$r22", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 2) end, info="2v2 season best rating"}
						,{key = "$r23", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 3) end, info="2v2 weekly best rating"}
						,{key = "$r24", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 4) end, info="2v2 games played this week"}
						,{key = "$r25", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 5) end, info="2v2 games won this season"}
						,{key = "$r26", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 6) end, info="2v2 games played this week"}
						,{key = "$r27", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 7) end, info="2v2 games won this week"}
						,{key = "$r28", value = function() return BGS_TrackerClasses:GetRatedInfo(1, 8) end, info="2v2 projected conquest cap"}
						,{key = "$r31", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 1) end, info="3v3 rating"}
						,{key = "$r32", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 2) end, info="3v3 season best rating"}
						,{key = "$r33", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 3) end, info="3v3 weekly best rating"}
						,{key = "$r34", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 4) end, info="3v3 games played this week"}
						,{key = "$r35", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 5) end, info="3v3 games won this season"}
						,{key = "$r36", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 6) end, info="3v3 games played this week"}
						,{key = "$r37", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 7) end, info="3v3 games won this week"}
						,{key = "$r38", value = function() return BGS_TrackerClasses:GetRatedInfo(2, 8) end, info="3v3 projected conquest cap"}
						,{key = "$r51", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 1) end, info="5v5 rating"}
						,{key = "$r52", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 2) end, info="5v5 season best rating"}
						,{key = "$r53", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 3) end, info="5v5 weekly best rating"}
						,{key = "$r54", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 4) end, info="5v5 games played this week"}
						,{key = "$r55", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 5) end, info="5v5 games won this season"}
						,{key = "$r56", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 6) end, info="5v5 games played this week"}
						,{key = "$r57", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 7) end, info="5v5 games won this week"}
						,{key = "$r58", value = function() return BGS_TrackerClasses:GetRatedInfo(3, 8) end, info="5v5 projected conquest cap"}
						,{key = "$rbg1", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 1) end, info="Battleground rating"}
						,{key = "$rbg2", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 2) end, info="Battleground season best rating"}
						,{key = "$rbg3", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 3) end, info="Battleground weekly best rating"}
						,{key = "$rbg4", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 4) end, info="Battleground games played this week"}
						,{key = "$rbg5", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 5) end, info="Battleground games won this season"}
						,{key = "$rbg6", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 6) end, info="Battleground games played this week"}
						,{key = "$rbg7", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 7) end, info="Battleground games won this week"}
						,{key = "$rbg8", value = function() return BGS_TrackerClasses:GetRatedInfo(4, 8) end, info="Battleground projected conquest cap"}
						}

--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------							

local function eventHandle(class, self, event, addon)
	
	if event == "UPDATE_BATTLEFIELD_SCORE" then
		-- only update when actually shown to save memory in battlegrounds
		if TrackerClass.frame:IsShown() then
			class:updateKeyString()
		end
	end
	
	if event == "PLAYER_ENTERING_WORLD" or event == "UPDATE_BATTLEFIELD_STATUS"  then
		class._currentBG = ""
		local isInstance, instanceType = IsInInstance()
		if instanceType == "pvp" then
			local name = GetInstanceInfo()
			class._currentBG = name
			
		end
		class:updateKeyString()
		return
	end

	if event == "PLAYER_PVP_KILLS_CHANGED" then
		class:updateKeyString()
		return
	end
	
	if event == "CURRENCY_DISPLAY_UPDATE" then
		class:updateKeyString()
	end
end

local function CreateUpdateFrame(class)
	local _eventsFrame = CreateFrame("FRAME", "BGS_"..class.detail.."Events");
	_eventsFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	_eventsFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
	_eventsFrame:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	_eventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	_eventsFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
	_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(class, self, event, ...) end)
end

local function CreateSpecificOptions(class)
						
	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetWidth(185)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetHeight(170)
	scrollcontainer:SetLayout("Fill")

	--TrackerClass.options[#TrackerClass.options + 1] = scrollcontainer
	--table.insert(TrackerClass.options, scrollcontainer)

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)
	
	scroll:AddChild(class._defaultOPtions.txt_Name)
	scroll:AddChild(class._defaultOPtions.frameDetail)
	scroll:AddChild(class._defaultOPtions.sl_ColSpan)
	scroll:AddChild(class._defaultOPtions.ddwn_Align)

	local txt_Input = AceGUI:Create("EditBox")
	txt_Input:SetLabel("Custom text")
	txt_Input:SetText(class._baseString)
	txt_Input:SetFullWidth(true)
	txt_Input:SetCallback("OnTextChanged", function(__,__, value)
		class._baseString = value
		--print(value)
		class:updateKeyString()
	end)
	--self.options.txt_Input = txt_Input
	scroll:AddChild(txt_Input)
	
	local countForBg = 0
	
	local testcontainer = nil
	
	for k, v in ipairs(_replaceKeys) do
	
		local info_KeyDiscriptions = AceGUI:Create("Label")
		info_KeyDiscriptions:SetFullWidth(true)
		info_KeyDiscriptions:SetFontObject(GameFontWhite)
		info_KeyDiscriptions:SetImage("Interface\\Buttons\\UI-PassiveHighlight")
		info_KeyDiscriptions:SetImageSize(1, 16)
		info_KeyDiscriptions.bg = info_KeyDiscriptions.frame:CreateTexture(v.key.."_bg", "BACKGROUND")
		
		local presetDetail = ""
		if not v.header then
			--presetDetail = string.format(_keyFormat, v.key, v.info) -- presetDetail .. "|cFFFFCC00".. v.key .. "|r: " .. v.info
			
			if countForBg%2 == 0 then
				--info_KeyDiscriptions.bg:SetTexture("Interface\\CHARACTERFRAME\\UI-Party-Background")
				info_KeyDiscriptions.bg:SetTexture("Interface\\CHATFRAME\\CHATFRAMEBACKGROUND")
				info_KeyDiscriptions.bg:SetAlpha(0.05)
			end
			
			info_KeyDiscriptions:SetText("|cFFFFCC00"..v.key.."|r : "..v.info)
			
			info_KeyDiscriptions.bg:SetPoint("topleft", info_KeyDiscriptions.frame, "topleft", 0,0)
			info_KeyDiscriptions.bg:SetPoint("bottomright", info_KeyDiscriptions.frame, "bottomright", 0,0)
	
			testcontainer:AddChild(info_KeyDiscriptions)
			
			countForBg = countForBg + 1
		else
			
			--info_KeyDiscriptions.bg:SetTexture("Interface\\PVPFrame\\PvPMegaQueue")
			--info_KeyDiscriptions.bg:SetTexCoord(6/512, 296/512, 898/1024, 945/1024)
			--info_KeyDiscriptions.bg:SetTexCoord(0/512, 328/512, 590/1024, 634/1024)
			info_KeyDiscriptions.bg:SetTexture("Interface\\PLAYERACTIONBARALT\\STONE")
			info_KeyDiscriptions.bg:SetTexCoord(0, 1, 89/512, 183/512)
			countForBg = 0
			presetDetail = presetDetail .. "   |cFFFFCC00".. v.info .. "|r"
			info_KeyDiscriptions:SetText(presetDetail)
			info_KeyDiscriptions.bg:SetPoint("topleft", info_KeyDiscriptions.frame, "topleft", 0,0)
			info_KeyDiscriptions.bg:SetPoint("bottomright", info_KeyDiscriptions.frame, "bottomright", 0,0)
	
			scroll:AddChild(info_KeyDiscriptions)
			
			testcontainer = AceGUI:Create("SimpleGroup")
			testcontainer:SetFullWidth(true)

			
			scroll:AddChild(testcontainer)
			
			--testcontainer:SetHeight(170)
			--testcontainer:SetAutoAdjustHeight(false)
		end
	end
	
	return scrollcontainer
	
end


function TestClass.new(name, id, save)
  local self = setmetatable({}, TestClass)
	self.name = name
	self.detail = "frame_"..id
	self.icon = "Interface\\ICONS\\INV_Scroll_07"
	self.info = "Customise your own tracker using given options"
	self.options = {}
	self.frameNr = id
	self.visipos = -1
	self.colSpan = 1
	self.justify = "left"
	self._updateTimer = 0
	self._keyFormat = "|cFFFFCC00%s|r : %s"
	self._baseString = "$sb2 ($sb1) / $sb3   D: $sb4 ($sbr4)   H: $sb5 ($sbr5)"
	self._currentBG = ""
	self.type = _type
	
	if save ~= nil then
		self:LoadSave(save)
	end
	print("creating".. self.detail.." "..self.visipos)
	
	self.frame = BGS_TrackerClasses:CreateTrackerFrame(self)
	print("after frame "..self.visipos)
	self.optionFrame = BGS_TrackerClasses:createSmallFrame(self)
	
	self._defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions(self)
	
	CreateUpdateFrame(self)
	
	table.insert(self.options, CreateSpecificOptions(self))
	
	self:updateKeyString()
  return self
end

function TestClass:GetSave()
	local save = {}
	save.name = self.name
	save.visipos = self.visipos
	save.colSpan = self.colSpan
	save.justify = self.justify
	save.type = self.type
	save.baseString = self._baseString

	return save
end

function TestClass:LoadSave(save)
	self.name = save.name
	self.visipos = save.visipos
	self.colSpan = save.colSpan
	self.justify = save.justify
	self._baseString = save.baseString
end

function TestClass:SetColspan(cols, maxCols)
	self.colSpan = cols
	self._defaultOPtions.sl_ColSpan:SetSliderValues(1, maxCols, 1)
	self._defaultOPtions.sl_ColSpan:SetValue(self.colSpan)
end



function TestClass:updateKeyString()

	local tempString = self._baseString
	--print(self.name .. ": " .. tempString)
	local strgsub = string.gsub
	local strfind = string.find
	
	for i=1, #_replaceKeys do
		local value = _replaceKeys[i]
		if not value.header and strfind(tempString, value.key) then
		tempString = strgsub(tempString, value.key, value.value)
		end
	end
	
	self.frame.text:SetText(tempString)
	tempString = nil
end	


--------------------------------------------------------------------------------
-- Tracker Specific Methods
--------------------------------------------------------------------------------



local function SetKey(key, data)
	for k, v in ipairs(_replaceKeys) do
		if v.key == key then
			_replaceKeys[k].value = data
			return
		end
	end
end
	
--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------


