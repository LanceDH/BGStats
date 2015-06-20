--------------------------------------------------------------------------------
-- Achievement Frame
--- Kills needed until next achievement
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

local _type = "Achievement"
local info = "Amount of kills until next account wide achievment"
table.insert(BGS_TrackerClasses, {fType = _type, class = TrackerClass, info = info })

--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------

local function eventHandle(class, event)
	
	if event == "PLAYER_PVP_KILLS_CHANGED"then
		class:UpdateAchInfo()
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
	self.icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
	self.info = "Amount of kills until next account wide achievment"
	self.options = {}
	self.frameNr = id
	self.visipos = -1
	self.colSpan = 1
	self.justify = "left"
	self.type = _type
	
	if save ~= nil then
		self:LoadSave(save)
	end
	--print("creating".. self.detail.." "..self.visipos)
	
	self.frame = BGS_TrackerClasses:CreateTrackerFrame(self)
	--print("after frame "..self.visipos)
	self.optionFrame = BGS_TrackerClasses:createSmallFrame(self)
	
	self._defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions(self)
	
	CreateUpdateFrame(self)
	
	table.insert(self.options, CreateSpecificOptions(self))
	
	self:UpdateAchInfo()
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
	
function TrackerClass:UpdateAchInfo()
	local AchFrame = self.frame
	
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
