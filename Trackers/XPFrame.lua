--------------------------------------------------------------------------------
-- Experience Frame
--- Experience gained during current battleground
--------------------------------------------------------------------------------

-- General Tracker variables
local AceGUI = LibStub("AceGUI-3.0")
local addonName, BGS_TrackerClasses = ...

local TrackerClass = {}
TrackerClass.__index = TrackerClass
setmetatable(TrackerClass, {
  __call = function (cls, ...)
    return cls.new(...)
  end,
})

local _type = "BG Experience"
local info = "Experience gained in the current or last battleground"
table.insert(BGS_TrackerClasses, {fType = _type, class = TrackerClass, info = info})

--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------
local function eventHandle(class, event, xpText)
	
	local isInstance, instanceType = IsInInstance()
	if event == "PLAYER_ENTERING_BATTLEGROUND" and instanceType == "pvp" then
		class.frame.text:SetText("0")
	return
	end
	if event == "CHAT_MSG_COMBAT_XP_GAIN" and instanceType == "pvp" then
		local gained = tonumber(string.match(xpText, '%d+'))
		local frame = BGS_TrackerClasses:GetFrameByName("XPFrame")
		local current = tonumber(class.frame.text:GetText())
		if current == nil then
			current = 0
		end
		class.frame.text:SetText(current + gained)
	end

end

local function CreateUpdateFrame(class)
	local _eventsFrame = CreateFrame("FRAME", "BGS_"..class.detail.."Events");
	_eventsFrame:RegisterEvent("CHAT_MSG_COMBAT_XP_GAIN");
	_eventsFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(class, event, ...) end)
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

function TrackerClass.new(name, id, save)
  local self = setmetatable({}, TrackerClass)
	self.name = name
	self.detail = "frame_"..id
	self.icon = "Interface\\ICONS\\Spell_Holy_SurgeOfLight"
	self.info = "Experience gained in the current or last battleground"
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
	self:UpdateExperience(0)
	
	table.insert(self.options, CreateSpecificOptions(self))
	
	CreateUpdateFrame(self)
	
  return self
end

function TrackerClass:GetSave()
	local save = {}
	save.name = self.name
	save.visipos = self.visipos
	save.colSpan = self.colSpan
	save.justify = self.justify
	save.type = self.type

	return save
end

function TrackerClass:LoadSave(save)
	self.name = save.name
	self.visipos = save.visipos
	self.colSpan = save.colSpan
	self.justify = save.justify
end

function TrackerClass:SetColspan(cols, maxCols)
	self.colSpan = cols
	self._defaultOPtions.sl_ColSpan:SetSliderValues(1, maxCols, 1)
	
	self._defaultOPtions.sl_ColSpan:SetValue(self.colSpan)
end

--------------------------------------------------------------------------------
-- Tracker Specific Methods
--------------------------------------------------------------------------------

function TrackerClass:UpdateExperience(gained)
	local frame = BGS_TrackerClasses:GetFrameByName("XPFrame")
	local current = tonumber(self.frame.text:GetText())
	if current == nil then
		current = 0
	end
	self.frame.text:SetText(current + gained)
end