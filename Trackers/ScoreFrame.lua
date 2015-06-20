--------------------------------------------------------------------------------
-- Score Frame
--- Kills, assists and deaths in current battleground
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

local _type = "Scoreboard"
local info = "Kills, killing blows and deaths in the current battleground"
table.insert(BGS_TrackerClasses, {fType = _type, class = TrackerClass, info = info})

--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------

local function eventHandle(class, event)
	
	class:UpdateBGScoreInfo()
	
	if event == "NEUTRAL_FACTION_SELECT_RESULT"then
		class:BGScoreIcon()
	return
	end

end

local function CreateUpdateFrame(class)
	local _eventsFrame = CreateFrame("FRAME", "BGS_"..class.detail.."Events");
	_eventsFrame:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	_eventsFrame:RegisterEvent("PLAYER_ENTERING_BATTLEGROUND");
	_eventsFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
	_eventsFrame:RegisterEvent("PLAYER_PVP_KILLS_CHANGED");
	_eventsFrame:RegisterEvent("UPDATE_BATTLEFIELD_SCORE");
	_eventsFrame:RegisterEvent("PLAYER_DEAD");
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

function TrackerClass.new(name, id, save)
  local self = setmetatable({}, TrackerClass)
	self.name = name
	self.detail = "frame_"..id
	self.icon = "Interface\\ICONS\\INV_Misc_QuestionMark"
	self.info = "Kills, killing blows and deaths in the current battleground"
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
	self:UpdateBGScoreInfo()
	self:BGScoreIcon()
	
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

function TrackerClass:BGScoreIcon()
   local EnglishFaction, localizedFaction = UnitFactionGroup("player")
   local bg = nill
   if EnglishFaction == "Horde" then
		bg = "Interface\\ICONS\\Achievement_PVP_H_H"
   elseif EnglishFaction == "Alliance" then
		bg = "Interface\\ICONS\\Achievement_PVP_A_A"
	else
		bg = "Interface\\ICONS\\Ability_Monk_ZenMeditation"
   end
	self.frame.icon:SetTexture(bg)
end
	
function TrackerClass:UpdateBGScoreInfo()
	local isInstance, instanceType = IsInInstance()
	
	if instanceType == "pvp" then
		RequestBattlefieldScoreData()
		for i = 1, GetNumBattlefieldScores() do
			local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone = GetBattlefieldScore(i)
			if name == GetUnitName("player", false) then
				self.frame.text:SetText("" .. honorableKills .. " (" .. killingBlows .. ") / " .. deaths)
				return --no need to count more
			end
		end
	else
		self.frame.text:SetText("-- (--) / --")
	end
end