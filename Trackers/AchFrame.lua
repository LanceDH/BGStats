--------------------------------------------------------------------------------
-- Achievement Frame
--- Kills needed until next achievement
--------------------------------------------------------------------------------

-- General Tracker variables
local AceGUI = LibStub("AceGUI-3.0")
local addonName, BGS_TrackerClasses = ...
local TrackerClass = {}
TrackerClass.name = "AchFrame"
TrackerClass.detail = "Achievement"
TrackerClass.icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
TrackerClass.info = "Amount of kills until next account wide achievment"
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
	
local function UpdateAchInfo()
	local AchFrame = TrackerClass.frame
	
	local HKills = BGS_TrackerClasses:GetAccHKills()
	local AchRankPath = [[]]
	local KillsLeft = 0
	if HKills < 1 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_01"
		KillsLeft = 1 - HKills
	elseif 1 <= HKills and HKills < 100 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_02"
		KillsLeft = 100 - HKills
	elseif 100 <= HKills and HKills < 500 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_03"
		KillsLeft = 500 - HKills
	elseif 500 <= HKills and HKills < 1000 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_04"
		KillsLeft = 1000 - HKills
	elseif 1000 <= HKills and HKills < 5000 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_06"
		KillsLeft = 5000 - HKills
	elseif 5000 <= HKills and HKills < 10000 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_09"
		KillsLeft = 10000 - HKills
	elseif 10000 <= HKills and HKills < 25000 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_11"
		KillsLeft = 25000 - HKills
	elseif 25000 <= HKills and HKills < 50000 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_14"
		KillsLeft = 50000 - HKills
	elseif 50000 <= HKills and HKills < 100000 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_15"
		KillsLeft = 100000 - HKills
	elseif 100000 <= HKills and HKills < 250000 then
		AchRankPath = "Interface\\ICONS\\Achievement_PVP_P_250K"
		KillsLeft = 250000 - HKills
	elseif 250000 <= HKills then
		AchRankPath = "Interface\\ICONS\\Achievement_BG_KillFlagCarriers_grabFlag_CapIt"
		KillsLeft = "Max Rank"
	end
	AchFrame.icon:SetTexture(AchRankPath)
	AchFrame.text:SetText(KillsLeft)
   
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

local function eventHandle(event)
	if not (BGS_TrackerClasses:GetFrameByName(TrackerClass.name)) then
		return
	end
	
	if event == "PLAYER_PVP_KILLS_CHANGED"then
		UpdateAchInfo()
	return
	end
	
	if event == "PLAYER_LOGIN" then
		UpdateAchInfo()
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
	end
	
	if event == "ADDON_LOADED" then
		if addon ~= addonName then return end
		self:UnregisterEvent("ADDON_LOADED")
		return
	end
	
	if event == "PLAYER_LOGOUT" then
		table.insert(BGstats_ExtraFrameDataList, {frame = TrackerClass.name, colSpan = TrackerClass.colSpan, justify = TrackerClass.justify})
	end
end

local _eventsFrame = CreateFrame("FRAME", "BGS_"..TrackerClass.name.."Events");
_eventsFrame:RegisterEvent("PLAYER_LOGIN");
_eventsFrame:RegisterEvent("ADDON_LOADED");
_eventsFrame:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
_eventsFrame:RegisterEvent("PLAYER_LOGOUT");
_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(event) end)