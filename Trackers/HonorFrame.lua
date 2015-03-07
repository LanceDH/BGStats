--------------------------------------------------------------------------------
-- Honor Frame
--- Shows Honor Points
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

local _type = "HonorFrame"

local TrackerClass = {}
TrackerClass.name = "HonorFrame"
TrackerClass.detail = "Honor Points"
TrackerClass.icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
TrackerClass.info = "Amount of honor points on this character"
--TrackerClass.options = {}
TrackerClass.colSpan = 1
TrackerClass.justify = "left"
TrackerClass.frame = nil
--local _defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions()
table.insert(BGS_TrackerClasses, {fType = _type, class = TestClass })
-- Tracker Specific variables

--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------

local function UpdateHonorInfo(frame)
	--local frame = BGS_TrackerClasses:GetFrameByName(TrackerClass.name)
	frame.text:SetText(BGS_TrackerClasses:GetHonor())
end

local function HonorIcon(frame)
	local EnglishFaction, localizedFaction = UnitFactionGroup("player")
	local bg = nill
	if EnglishFaction == "Horde" then
		bg = "Interface\\ICONS\\PVPCurrency-Honor-Horde"
	elseif EnglishFaction == "Alliance" then
	
        bg = "Interface\\ICONS\\PVPCurrency-Honor-Alliance"
	else
		bg = "Interface\\ICONS\\Ability_Monk_ZenMeditation"
	end
	frame.icon:SetTexture(bg)
end

local function eventHandle(class, self, event, addon)
	--if not (BGS_TrackerClasses:GetFrameByName(TrackerClass.name)) then
	--	return
	--end
	
	if event == "CURRENCY_DISPLAY_UPDATE" then
		UpdateHonorInfo(class.frame)
	return
	end
	
	if event == "NEUTRAL_FACTION_SELECT_RESULT" then
		HonorIcon(class.frame)
	end
end

local function CreateUpdateFrame(class)
	local _eventsFrame = CreateFrame("FRAME", "BGS_"..class.detail.."Events");
	_eventsFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
	_eventsFrame:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT");
	_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(class, self, event, ...) end)
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
	self.icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
	self.info = "Amount of honor points on this character"
	self.options = {}
	self.frameNr = id
	self.visipos = -1
	self.colSpan = 1
	self.justify = "left"
	self.type = _type
	
	if save ~= nil then
		self:LoadSave(save)
	end
	
	print("creating".. self.detail.." "..self.visipos)
	
	self.frame = BGS_TrackerClasses:CreateTrackerFrame(self)
	print("after frame "..self.visipos)
	self.optionFrame = BGS_TrackerClasses:createSmallFrame(self)
	
	UpdateHonorInfo(self.frame)
	HonorIcon(self.frame)
	
	self._defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions(self)
	--CreateSpecificOptions(self)
	
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


--------------------------------------------------------------------------------
-- Tracker Specific Methods
--------------------------------------------------------------------------------
		




--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

