--------------------------------------------------------------------------------
-- Session Frame
--- Tracks wins and losses during the current session
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

local _type = "Current Session"
local info = "Battleground wins and losses on this character this session \n(auto resets after buffer)"
table.insert(BGS_TrackerClasses, {fType = _type, class = TrackerClass, info = info})

--------------------------------------------------------------------------------
-- General Tracker Methods
--------------------------------------------------------------------------------
local function eventHandle(class, self, event, addon)
	if event == "UPDATE_BATTLEFIELD_STATUS"then
		class:_SessionInfos()
	return
	end

end

local function CreateUpdateFrame(class)
	local _eventsFrame = CreateFrame("FRAME", "BGS_"..class.detail.."Events");
	_eventsFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
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
	scroll:AddChild(class._defaultOPtions.frameDetail)
	scroll:AddChild(class._defaultOPtions.sl_ColSpan)
	scroll:AddChild(class._defaultOPtions.ddwn_Align)
	class._defaultOPtions.ddwn_Align:SetText(class.justify)

	
	local txt_BufferTime = AceGUI:Create("EditBox")
	txt_BufferTime.frame:Hide()
	txt_BufferTime:SetRelativeWidth(0.5)
	txt_BufferTime:SetLabel("Buffer time after logout (sec)")
	txt_BufferTime:SetText(class._logoutTime)

	txt_BufferTime:SetPoint("topleft", optionFrame, "topleft", 0, 0)
	txt_BufferTime:SetCallback("OnEnterPressed", function()
		local input = tonumber(txt_BufferTime:GetText())
		if input == nil then
			txt_BufferTime:SetText(class._logoutTime)
		else
			class._logoutTime = input
		end
	end)

	scroll:AddChild(txt_BufferTime)
	
	local cbx_enable = AceGUI:Create("CheckBox")

	cbx_enable:SetLabel("Enable auto reset")
	cbx_enable:SetRelativeWidth(0.5)

	cbx_enable:SetValue(class.autoReset)
	cbx_enable:SetCallback("OnValueChanged", function(_, _, value)
		class.autoReset = value
	end)
	cbx_enable:SetCallback("OnEnter", function(self, _, value)
		BGS_TrackerClasses.tooltip:ShowTooltip(self.frame, "Enabling this will cause the session to auto reset when the character is logged out longer than the buffer time.")
	end)
	cbx_enable:SetCallback("OnLeave", function(_, _, value)
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)

	scroll:AddChild(cbx_enable)

	local btn_Reset = AceGUI:Create("Button")
	btn_Reset.frame:Hide()
	btn_Reset:SetText("Reset session")
	btn_Reset:SetRelativeWidth(0.5)
	btn_Reset:SetCallback("OnClick", function() 
		class.frame.text:SetText("0 : 0") 
	end)
	scroll:AddChild(btn_Reset)

	return scrollcontainer
	
end


function TrackerClass.new(name, id, save)
  local self = setmetatable({}, TrackerClass)
	self.name = name
	self.detail = "frame_"..id
	self.icon = "Interface\\ICONS\\INV_Misc_PocketWatch_01"
	self.info = "Battleground wins and losses on this character this session \n(auto resets after buffer)"
	self.options = {}
	self.frameNr = id
	self.visipos = -1
	self.colSpan = 1
	self.justify = "left"
	self._logoutTime = 600;
	self.autoReset = true;
	self.type = _type
	self.score = "0 : 0"
	self.wins = 0;
	self.losses = 0;
	
	if save ~= nil then
		self:LoadSave(save)
	end

	
	self.frame = BGS_TrackerClasses:CreateTrackerFrame(self)

	self.optionFrame = BGS_TrackerClasses:createSmallFrame(self)
	
	self._defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions(self)
	
	self:UpdateSessionInfo()

	
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
	save.logoutTime = self._logoutTime
	save.autoReset = self.autoReset
	save.wins = self.wins;
	save.losses = self.losses;
	save.timestamp = time()

	return save
end

function TrackerClass:LoadSave(save)
	self.name = save.name
	self.visipos = save.visipos
	self.colSpan = save.colSpan
	self.justify = save.justify
	self._logoutTime = save.logoutTime
	self.autoReset = save.autoReset
	if save.timestamp == nil then
		save.timestamp = 0
	end
		if not self.autoReset or (time() - save.timestamp) < self._logoutTime then -- reuse if time not passed
			if save.wins ~= nil then
				self.wins = save.wins;
			end
			if save.losses ~= nil then
				self.losses = save.losses;
			end
		end

end

function TrackerClass:SetColspan(cols, maxCols)
	self.colSpan = cols
	self._defaultOPtions.sl_ColSpan:SetSliderValues(1, maxCols, 1)
	self._defaultOPtions.sl_ColSpan:SetValue(self.colSpan)
end

--------------------------------------------------------------------------------
-- Tracker Specific Methods
--------------------------------------------------------------------------------

function TrackerClass:UpdateSessionInfo(win)
	if win == nil then
		self.wins = 0;
		self.losses = 0;
		self.frame.text:SetText("0 : 0")
		return
	end

	if win then
		self.wins = self.wins + 1;
	elseif not win then
		self.losses = self.losses + 1
	end
	self.frame.text:SetText(self.wins .. " : " .. self.losses)

end
	
local function getBgFaction()
	for i=1,40 do 
		local name = UnitBuff("player",i);
		if name == "Horde" then
			return 0
		elseif name == "Alliance" then
			return 1
		end
	end
	
	local pFaction = UnitFactionGroup("player")
	if pFaction == "Horde" then
		return 0
	elseif pFaction == "Alliance" then
		return 1
	end
	return nil
end
	
function TrackerClass:_SessionInfos()
	local _, itype = IsInInstance()
	if itype ~= "pvp" or GetBattlefieldInstanceExpiration() == 0 then
		return
	end

	
	local wFaction = GetBattlefieldWinner()
	
	if wFaction == nil then
		return
	end
	
	local playerWon = false
	if wFaction == getBgFaction() then
		playerWon = true
	end
	
	self:UpdateSessionInfo(playerWon)
end

