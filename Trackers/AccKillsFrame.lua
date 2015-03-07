--------------------------------------------------------------------------------
-- Account Kills Frame
--- Honorable kills across the account
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

local _type = "Account Kills"

table.insert(BGS_TrackerClasses, {fType = _type, class = TestClass })
-- Tracker Specific variables


--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------

local function eventHandle(class, event)
	
	if event == "PLAYER_PVP_KILLS_CHANGED"then
		class:UpdateAccKillsInfo()
	return
	end

end

local function CreateUpdateFrame(class)
	local _eventsFrame = CreateFrame("FRAME", "BGS_"..class.detail.."Events");
	_eventsFrame:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(class, event) end)
end

local function CreateSpecificOptions(class)

	local scrollcontainer = AceGUI:Create("SimpleGroup")
	scrollcontainer:SetFullWidth(true)
	scrollcontainer:SetWidth(185)
	scrollcontainer:SetFullHeight(true)
	scrollcontainer:SetHeight(170)
	scrollcontainer:SetLayout("Fill")

	

	local scroll = AceGUI:Create("ScrollFrame")
	scroll:SetLayout("Flow")
	scrollcontainer:AddChild(scroll)
	
	
	scroll:AddChild(class._defaultOPtions.txt_Name)

	-- Tracker Info
	--class._defaultOPtions.frameDetail.text:SetText(class.info)
	scroll:AddChild(class._defaultOPtions.frameDetail)
	
	-- Tracker Slider
	
	scroll:AddChild(class._defaultOPtions.sl_ColSpan)
	
	-- Tracker Text Alignment
	
	scroll:AddChild(class._defaultOPtions.ddwn_Align)
	
	return scrollcontainer
end

function TestClass.new(name, id, save)
  local self = setmetatable({}, TestClass)
	self.name = name
	self.detail = "frame_"..id
	self.icon = "Interface\\ICONS\\warrior_skullbanner"
	self.info = "Honorable kills across your account (250k limit)"
	self.options = {}
	self.frameNr = id
	self.visipos = -1
	self.colSpan = 1
	self.justify = "left"
	self.type = _type
	
	if save ~= nil then
		self:LoadSave(save)
	end
	
	self.frame = BGS_TrackerClasses:CreateTrackerFrame(self)
	self.optionFrame = BGS_TrackerClasses:createSmallFrame(self)
	
	self._defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions(self)
	self:UpdateAccKillsInfo()
	
	table.insert(self.options, CreateSpecificOptions(self))
	
	CreateUpdateFrame(self)
	
  return self
end

function TestClass:GetSave()
	local save = {}
	save.name = self.name
	save.visipos = self.visipos
	save.colSpan = self.colSpan
	save.justify = self.justify
	save.type = self.type

	return save
end

function TestClass:LoadSave(save)
	self.name = save.name
	self.visipos = save.visipos
	self.colSpan = save.colSpan
	self.justify = save.justify
end

function TestClass:SetColspan(cols, maxCols)
	self.colSpan = cols
	self._defaultOPtions.sl_ColSpan:SetSliderValues(1, maxCols, 1)
	self._defaultOPtions.sl_ColSpan:SetValue(self.colSpan)
end

--[[
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
]]--


--------------------------------------------------------------------------------
-- Tracker Specific Methods
--------------------------------------------------------------------------------

function TestClass:UpdateAccKillsInfo()
	self.frame.text:SetText(BGS_TrackerClasses:GetAccHKills())
end	
	
--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

