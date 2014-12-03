--------------------------------------------------------------------------------
-- Tol Barad Frame
--- Amount of Tol Barad tokens
--------------------------------------------------------------------------------

-- General Tracker variables
local AceGUI = LibStub("AceGUI-3.0")
local addonName, BGS_TrackerClasses = ...
local TrackerClass = {}
TrackerClass.name = "GarrisonFrame"
TrackerClass.detail = "Garrison Resources"
TrackerClass.icon = "Interface\\ICONS\\inv_garrison_resource"
TrackerClass.info = "Amount of garrison resources on this character"
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
	
local function UpdateGarrisonInfo()
	local ScoreFrame = BGS_TrackerClasses:GetFrameByName(TrackerClass.name)
	ScoreFrame.text:SetText(BGS_TrackerClasses:GetGarrisonResources())
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

local function eventHandle(self, event, addon)
	if not (BGS_TrackerClasses:GetFrameByName(TrackerClass.name)) then
		return
	end
	
	if event == "CURRENCY_DISPLAY_UPDATE" then
		UpdateGarrisonInfo()
	return
	end
	
	if event == "PLAYER_LOGIN" then
		UpdateGarrisonInfo()
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
_eventsFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
_eventsFrame:RegisterEvent("ADDON_LOADED");
_eventsFrame:RegisterEvent("PLAYER_LOGOUT");
_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(self, event, ...) end)