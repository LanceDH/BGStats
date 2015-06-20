--------------------------------------------------------------------------------
-- Conquest Frame
--- Shows Conquest Points
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

local _type = "Conquest Points"
local info = "Amount of conquest points on this character"
table.insert(BGS_TrackerClasses, {fType = _type, class = TestClass, info = info })


--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------

local function eventHandle(class, self, event, addon)
	
	if event == "CURRENCY_DISPLAY_UPDATE" then
		class:UpdateConquestInfo()
	return
	end
	
	if event == "NEUTRAL_FACTION_SELECT_RESULT" then
		class:ConquestIcon()
	end
end

local function CreateUpdateFrame(class)
	local _eventsFrame = CreateFrame("FRAME", "BGS_"..class.detail.."Events");
	_eventsFrame:RegisterEvent("CURRENCY_DISPLAY_UPDATE");
	_eventsFrame:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT");
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
	scroll:AddChild(class._defaultOPtions.frameDetail)
	scroll:AddChild(class._defaultOPtions.sl_ColSpan)
	scroll:AddChild(class._defaultOPtions.ddwn_Align)
	class._defaultOPtions.ddwn_Align:SetText(class.justify)
	
	return scrollcontainer
end

function TestClass.new(name, id, save)
  local self = setmetatable({}, TestClass)
	self.name = name
	self.detail = "frame_"..id
	self.icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
	self.info = "Amount of conquest points on this character"
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
	self:ConquestIcon()
	self:UpdateConquestInfo()
	
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
		
function TestClass:UpdateConquestInfo()
	self.frame.text:SetText(BGS_TrackerClasses:GetConquest())
end

function TestClass:ConquestIcon()
	local EnglishFaction, localizedFaction = UnitFactionGroup("player")
	local bg = nil
	if EnglishFaction == "Horde" then
        bg = "Interface\\ICONS\\PVPCurrency-Conquest-Horde"
	elseif EnglishFaction == "Alliance" then
        bg = "Interface\\ICONS\\PVPCurrency-Conquest-Alliance"
	else
		bg = "Interface\\ICONS\\Ability_Monk_ZenMeditation"
	end
	self.frame.icon:SetTexture(bg)
	
end