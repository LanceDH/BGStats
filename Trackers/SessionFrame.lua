--------------------------------------------------------------------------------
-- Session Frame
--- Tracks wins and losses during the current session
--------------------------------------------------------------------------------

-- General Tracker variables
local AceGUI = LibStub("AceGUI-3.0")
local addonName, BGS_TrackerClasses = ...
local TrackerClass = {}
TrackerClass.name = "SessionFrame"
TrackerClass.detail = "Current Session"
TrackerClass.icon = "Interface\\ICONS\\INV_Misc_PocketWatch_01"
TrackerClass.info = "Battleground wins and losses on this character this session \n(auto resets after buffer)"
TrackerClass.options = {}
TrackerClass.colSpan = 1
TrackerClass.justify = "left"
TrackerClass.frame = nil
local _defaultOPtions = BGS_TrackerClasses:CreateDefaultTrackerOptions()
table.insert(BGS_TrackerClasses, {class = TrackerClass})
-- Tracker Specific variables
local _logoutTime = 600;

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
	
	
	local txt_BufferTime = AceGUI:Create("EditBox")
	txt_BufferTime.frame:Hide()
	txt_BufferTime:SetRelativeWidth(0.5)
	txt_BufferTime:SetLabel("Buffer time after logout (sec)")
	txt_BufferTime:SetText(_logoutTime)
	--txt_BufferTime:SetWidth(180)
	txt_BufferTime:SetPoint("topleft", optionFrame, "topleft", 0, 0)
	txt_BufferTime:SetCallback("OnEnterPressed", function()
		local input = tonumber(txt_BufferTime:GetText())
		if input == nil then
			txt_BufferTime:SetText(_logoutTime)
		else
			_logoutTime = input
		end
	end)
	TrackerClass.options.txt_BufferTime = txt_BufferTime
	scroll:AddChild(txt_BufferTime)
	
	local cbx_enable = AceGUI:Create("CheckBox")

	cbx_enable:SetLabel("Enable auto reset")
	cbx_enable:SetRelativeWidth(0.5)
	--cbx_enable:SetFullWidth(true)
	cbx_enable:SetValue(true)

	TrackerClass.options.cbx_enable = cbx_enable
	scroll:AddChild(cbx_enable)

	local btn_Reset = AceGUI:Create("Button")
	btn_Reset.frame:Hide()
	btn_Reset:SetText("Reset session")
	btn_Reset:SetRelativeWidth(0.5)
	--btn_Reset:SetWidth(180)
	btn_Reset:SetCallback("OnClick", function() 
		local frame = BGS_TrackerClasses:GetFrameByName(TrackerClass.name);
		frame.text:SetText("0 : 0") 
	end)
	scroll:AddChild(btn_Reset)
end

function TrackerClass:Create()
	TrackerClass.frame = BGS_TrackerClasses:CreateTrackerFrame(TrackerClass)
	CreateSpecificOptions()
end

--------------------------------------------------------------------------------
-- Tracker Specific Methods
--------------------------------------------------------------------------------

local function UpdateSessionInfo(win)
	--print("updatesession")
	local frame = BGS_TrackerClasses:GetFrameByName(TrackerClass.name);
	if win == nil then
		frame.text:SetText("0 : 0")
		return
	end
	
	local wins, losses = string.match(frame.text:GetText(), "(%d+) : (%d+)")
	if win then
		wins = wins + 1;
	elseif not win then
		losses = losses + 1;
	end
	frame.text:SetText(wins .. " : " .. losses)

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
	
local function _SessionInfos()
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
	
	UpdateSessionInfo(playerWon)
end

--------------------------------------------------------------------------------
-- Event Handling
--------------------------------------------------------------------------------

local function eventHandle(self, event, addon)
	if not (BGS_TrackerClasses:GetFrameByName(TrackerClass.name)) then
		return
	end
	
	if event == "UPDATE_BATTLEFIELD_STATUS"then
		_SessionInfos()
	return
	end
	if event == "ADDON_LOADED" then
		if addon ~= addonName then return end
		self:UnregisterEvent("ADDON_LOADED")
		
		
		local frame = BGS_TrackerClasses:GetFrameByName(TrackerClass.name);
		TrackerClass.frame.text:SetText("0 : 0")
		
		local infoList = BGS_TrackerClasses:GetInfoList(TrackerClass.name)
		
		if not (infoList)then
			return
		end
		
		TrackerClass.options.cbx_enable:Value(infoList.autoReset)
		
		if infoList.logTime ~= nill then
			_logoutTime = infoList.logTime
			TrackerClass.options.txt_BufferTime:SetText(_logoutTime)
		end
		
		--if not infoList.autoReset then -- always reuse if disbaled
		--	TrackerClass.frame.text:SetText(infoList.text)
		--else
			if (time() - infoList.timestamp) < _logoutTime then -- reuse if time not passed
				TrackerClass.frame.text:SetText(infoList.text)
			end
		--end
		return
	end
	
	if event == "PLAYER_LOGIN" then
		local infoList = BGS_TrackerClasses:GetInfoList(TrackerClass.name)
		
		
		
		if infoList then
			--default
			if (infoList.colSpan) then
				TrackerClass.colSpan = infoList.colSpan
			end
			TrackerClass.frame.colSpan = TrackerClass.colSpan
			_defaultOPtions.sl_ColSpan:SetValue(TrackerClass.colSpan)
			BGS_TrackerClasses:TrackFramePos()
			if(infoList.justify) then
				TrackerClass.justify = infoList.justify
			end
			_defaultOPtions.ddwn_Align:SetValue(TrackerClass.justify)
			TrackerClass.frame.text:SetJustifyH(TrackerClass.justify)
			
			
			if not (infoList)then
			return
		end
		
		TrackerClass.options.cbx_enable:SetValue(infoList.autoReset)
		
		if infoList.logTime ~= nill then
			_logoutTime = infoList.logTime
			TrackerClass.options.txt_BufferTime:SetText(_logoutTime)
		end
		
		if not infoList.autoReset then -- always reuse if disbaled
			TrackerClass.frame.text:SetText(infoList.text)
		else
			if (time() - infoList.timestamp) < _logoutTime then -- reuse if time not passed
				TrackerClass.frame.text:SetText(infoList.text)
			end
			end
		end
	end
	
	if event == "PLAYER_LOGOUT" then
		--local tempSaveData = {}
		--tempSaveData.frame = TrackerClass.name
		--tempSaveData.timestamp = time()
		--tempSaveData.logTime = _logoutTime
		--tempSaveData.text = TrackerClass.frame.text:GetText()
		--tempSaveData.autoReset = TrackerClass.options.cbx_enable:GetValue()
		--tempSaveData.colSpan = TrackerClass.colSpan
		--tempSaveData.justify = TrackerClass.justify
		--table.insert(BGstats_ExtraFrameDataList, tempSaveData)
		table.insert(BGstats_ExtraFrameDataList, {frame = TrackerClass.name, timestamp = time(), logTime = _logoutTime, text = TrackerClass.frame.text:GetText(), autoReset = TrackerClass.options.cbx_enable:GetValue(), colSpan = TrackerClass.colSpan, justify = TrackerClass.justify})
		--table.insert(BGstats_ExtraFrameDataList, {frame = TrackerClass.name})
	end
end

local _eventsFrame = CreateFrame("FRAME", "BGS_"..TrackerClass.name.."Events");
_eventsFrame:RegisterEvent("PLAYER_LOGIN");
_eventsFrame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS");
_eventsFrame:RegisterEvent("ADDON_LOADED");
_eventsFrame:RegisterEvent("PLAYER_LOGOUT");
_eventsFrame:SetScript("OnEvent", function(self, event, ...) eventHandle(self, event, ...) end)