--------------------------------------------------------------------------------
-- Score Frame
--- Kills, assists and deaths in current battleground
--------------------------------------------------------------------------------

-- General Tracker variables
local AceGUI = LibStub("AceGUI-3.0")
local addonName, BGS_TrackerClasses = ...
local TrackerClass = {}
TrackerClass.name = "ScoreFrame"
TrackerClass.detail = "Battleground Stats"
TrackerClass.icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
TrackerClass.info = "Kills, killing blows and deaths in the current battleground"
TrackerClass.options = {}
TrackerClass.colSpan = 1
TrackerClass.justify = "left"
TrackerClass.frame = nil
local _defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions()
table.insert(BGS_TrackerClasses, {class = TrackerClass})
-- Tracker Specific variables

--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------

function TrackerClass:SetColspan(cols, maxCols)
	TrackerClass.colSpan = cols
	_defaultOPtions.sl_ColSpan:SetSliderValues(1, maxCols, 1)
	_defaultOPtions.sl_ColSpan:SetValue(TrackerClass.colSpan)
end

local function CreateSpecificOptions()

	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetWidth(185)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetHeight(170)
	scrollcontainer:SetLayout("Fill")

	table.insert(TrackerClass.options, scrollcontainer)

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)

	-- Tracker Info
	_defaultOPtions.frameDetail.text:SetText(TrackerClass.info)
	scroll:AddChild(_defaultOPtions.frameDetail)
	
	-- Tracker Slider
	_defaultOPtions.sl_ColSpan:SetCallback("OnValueChanged", function(__,__,value)
		local frame = BGS_TrackerClasses:GetFrameByName(TrackerClass.name)
		frame.colSpan = tonumber(value)
		BGS_TrackerClasses:TrackFramePos()
	end)
	scroll:AddChild(_defaultOPtions.sl_ColSpan)
	
	-- Tracker Text Alignment
	_defaultOPtions.ddwn_Align:SetCallback("OnValueChanged", function(_,_, choise)
		TrackerClass.justify = choise
		TrackerClass.frame.text:SetJustifyH(TrackerClass.justify)
	end)
	scroll:AddChild(_defaultOPtions.ddwn_Align)
end

function TrackerClass:Create()
	TrackerClass.frame = BGS_TrackerClasses:CreateTrackerFrame(TrackerClass)
	CreateSpecificOptions()
end

--------------------------------------------------------------------------------
-- Tracker Specific Methods
--------------------------------------------------------------------------------

local function BGScoreIcon()
   local EnglishFaction, localizedFaction = UnitFactionGroup("player")
   local bg = nill
   if EnglishFaction == "Horde" then
		bg = "Interface\\ICONS\\Achievement_PVP_H_H"
   elseif EnglishFaction == "Alliance" then
		bg = "Interface\\ICONS\\Achievement_PVP_A_A"
	else
		bg = "Interface\\ICONS\\Ability_Monk_ZenMeditation"
   end
	TrackerClass.frame.icon:SetTexture(bg)
end
	
local function UpdateBGScoreInfo()
	local isInstance, instanceType = IsInInstance()
	
	if instanceType == "pvp" then
		RequestBattlefieldScoreData()
		for i = 1, GetNumBattlefieldScores() do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(i)
			if name == GetUnitName("player", false) then
				TrackerClass.frame.text:SetText("" .. honorableKills .. "(" .. killingBlows .. ") / " .. deaths)
				return --no need to count more
			end
		end
	end
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

local function eventHandle(self, event, addon)

	UpdateBGScoreInfo()
	-- if event == "CURRENCY_DISPLAY_UPDATE" or event == "PLAYER_LOGIN" then
		
	-- return
	-- end
	if event == "PLAYER_LOGIN" then
		BGScoreIcon()
		TrackerClass.frame.text:SetText("" .. 0 .. "(" .. 0 .. ") / " .. 0)

		local extra = BGS_TrackerClasses:GetInfoList(TrackerClass.name)
		if extra then
			if (extra.colSpan) then
				TrackerClass.colSpan = extra.colSpan
			end
			TrackerClass.frame.colSpan = TrackerClass.colSpan
			_defaultOPtions.sl_ColSpan:SetValue(TrackerClass.colSpan)
			BGS_TrackerClasses:TrackFramePos()
			if(extra.justify) then
				TrackerClass.justify = extra.justify
			end
			_defaultOPtions.ddwn_Align:SetValue(TrackerClass.justify)
			TrackerClass.frame.text:SetJustifyH(TrackerClass.justify)
		end
		return
	end
	
	
	
	if event == "ADDON_LOADED" then
		if addon ~= addonName then return end
		self:UnregisterEvent("ADDON_LOADED")
		
		--BGScoreIcon()
		--TrackerClass.frame.text:SetText("" .. 0 .. "(" .. 0 .. ") / " .. 0)
		return
	end
	
	if event == "PLAYER_LOGOUT" then
		table.insert(BGstats_ExtraFrameDataList, {frame = TrackerClass.name, colSpan = TrackerClass.colSpan, justify = TrackerClass.justify})
	end
	
	if event == "NEUTRAL_FACTION_SELECT_RESULT" then
		BGScoreIcon()
	end
end

local _eventsFrame = CreateFrame("FRAME", "BGS_"..TrackerClass.name.."Events");
_eventsFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
_eventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
_eventsFrame:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
_eventsFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
_eventsFrame:RegisterEvent("PLAYER_LOGIN");
_eventsFrame:RegisterEvent("PLAYER_DEAD");
_eventsFrame:RegisterEvent("ADDON_LOADED");
_eventsFrame:RegisterEvent("PLAYER_LOGOUT");
_eventsFrame:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT");
_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(self, event, ...) end)

