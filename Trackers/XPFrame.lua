--------------------------------------------------------------------------------
-- Experience Frame
--- Experience gained during current battleground
--------------------------------------------------------------------------------

-- General Tracker variables
local AceGUI = LibStub("AceGUI-3.0")
local addonName, BGS_TrackerClasses = ...
local TrackerClass = {}
TrackerClass.name = "XPFrame"
TrackerClass.detail = "BG Experience"
TrackerClass.icon = "Interface\\ICONS\\Spell_Holy_SurgeOfLight"
TrackerClass.info = "Experience gained in the current or last battleground"
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
	--_OptionTable.txt_colSpan:SetText(TrackerClass.colSpan)
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



--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

local function eventHandle(self, event, addon)
	local frame = BGS_TrackerClasses:GetFrameByName(TrackerClass.name)
	if not (frame) then
		return
	end
	local isInstance, instanceType = IsInInstance()
	if event == "PLAYER_ENTERING_BATTLEGROUND" and instanceType == "pvp" then
		frame.text:SetText("0")
	return
	end
	if event == "CHAT_MSG_COMBAT_XP_GAIN" and instanceType == "pvp" then
		local gained = tonumber(string.match(addon, '%d+'))
		local frame = BGS_TrackerClasses:GetFrameByName("XPFrame")
		local current = tonumber(frame.text:GetText())
		if current == nil then
			current = 0
		end
		frame.text:SetText(current + gained)
	end
	
	if event == "PLAYER_LOGIN" then
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
		
		--createOptions()
		frame.text:SetText("0")
		return
		
	end
	
	if event == "PLAYER_LOGOUT" then
		table.insert(BGstats_ExtraFrameDataList, {frame = TrackerClass.name, colSpan = TrackerClass.colSpan, justify = TrackerClass.justify})
	end
end

local _eventsFrame = CreateFrame("FRAME", "BGS_"..TrackerClass.name.."Events");
_eventsFrame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
_eventsFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
_eventsFrame:RegisterEvent("ADDON_LOADED");
_eventsFrame:RegisterEvent("PLAYER_LOGIN");
_eventsFrame:RegisterEvent("PLAYER_LOGOUT");
_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(self, event, ...) end)