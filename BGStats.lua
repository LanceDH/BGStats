
----------------------------------------
-- Variables
----------------------------------------

local addonName, BGS_TrackerClasses = ...
local versionNr = GetAddOnMetadata(addonName, "Version")
BGS_TrackerClasses.ExtraInfoFunctions = {functions ={}, lists = {}}

local _PlayerName = UnitName("player")

local AceGUI = LibStub("AceGUI-3.0")

local _
local ExtraDataList = {}
local DefaultFrames = {}
local OptionsFrame = {}

local DEFAULT_OPTIONS_COLUMN_WIDTH = 182
local DEFAULT_TRACKOFFSET_WITH = 25
local DEFAULT_TRACKOFFSET_WITHOUT = 8
local DEFAULT_LOCKVERTEX_OFF = 0.5
local DEFAULT_LOCKVERTEX_ON = 0.8
local OPTIONS_TINYBTN_SIZE = 20
local DEFAULT_TRACKER_WIDTH = 105
local DEFAULT_TRACKER_HEIGHT = 20
local MAXFRAMES = 15;
local _TrackColumns = 1
local _CreatedFrameCounter = 0

local DEFAULT_BG = "Interface\\DialogFrame\\UI-DialogBox-Background"
local DEFAULT_EDGEFILE = "Interface\\DialogFrame\\UI-DialogBox-Border"
local TEX_TOOLTIPBORDER = "Interface\\GLUES\\COMMON\\Glue-Tooltip-Border"
local TEX_TOOLTIPBG = "Interface\\GLUES\\COMMON\\Glue-Tooltip-Background"

local mainBGBack = "Interface\\DialogFrame\\UI-DialogBox-Background"
local mainEdgefile = nill
local mainInset = 3

local _BGPlayerList = {}

local TestClasses = {}

local AnchorTable = {options = {["other"] = "Other"
						,["UIParent"] = "Screen"

						}
				, order = {"none"
						,"UIParent"

						}
}

local AnchorLocationTable = {options = {["Bottom"] = "Bottom"
						,["Bottom left"] = "Bottom left"
						,["Bottom right"] = "Bottom right"
						,["Center"] = "Center"
						,["Left"] = "Left"
						,["Right"] = "Right"
						,["Top"] = "Top"
						,["Top left"] = "Top left"
						,["Top right"] = "Top right"

						}
				, order = {"Bottom"
						,"Bottom left"
						,"Bottom right"
						,"Center"
						,"Left"
						,"Right"
						,"Top"
						,"Top left"
						,"Top right"

						}
}

local BGTable = {options = {["none"] = "None"
						,["Interface\\COMMON\\ShadowOverlay-Top"] = "Fade Top"
						,["Interface\\COMMON\\ShadowOverlay-Right"] = "Fade Right"
						,["Interface\\COMMON\\ShadowOverlay-Bottom"] = "Fade Bottom"
						,["Interface\\COMMON\\ShadowOverlay-Left"] = "Fade Left"
						,["Interface\\DialogFrame\\UI-DialogBox-Background"] = "Full Light"
						,["Interface\\DialogFrame\\UI-DialogBox-Background-Dark"] = "Full Dark"
						,["Interface\\DialogFrame\\UI-DialogBox-Gold-Background"] = "Full Gold"
						,["Interface\\Glues\\CHARACTERCREATE\\UI-CHARACTERCREATE-BACKGROUND"] = "Full Border"
						,["Interface\\BankFrame\\Bank-Background"] = "Stone Light"
						,["Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg"] = "Stone Dark"
						,["Interface\\GuildBankFrame\\GuildVaultBG"] = "Stone Red"
						,["Interface\\Glues\\Models\\UI_NIGHTELF\\AA_NE_SKY"] = "Sky Night"
						,["Interface\\Glues\\Models\\UI_Orc\\MM_ORC_SKY_01"] = "Sky Dawn"
						,["Interface\\Glues\\Models\\UI_Orc\\MM_ORC_S_01"] = "Test"
						}
				, order = {"none"
						,"Interface\\COMMON\\ShadowOverlay-Top"
						,"Interface\\COMMON\\ShadowOverlay-Right"
						,"Interface\\COMMON\\ShadowOverlay-Bottom"
						,"Interface\\COMMON\\ShadowOverlay-Left"
						,"Interface\\DialogFrame\\UI-DialogBox-Background"
						,"Interface\\DialogFrame\\UI-DialogBox-Background-Dark"
						,"Interface\\DialogFrame\\UI-DialogBox-Gold-Background"
						,"Interface\\Glues\\CHARACTERCREATE\\UI-CHARACTERCREATE-BACKGROUND"
						,"Interface\\BankFrame\\Bank-Background"
						,"Interface\\RAIDFRAME\\UI-RaidFrame-GroupBg"
						,"Interface\\GuildBankFrame\\GuildVaultBG"
						,"Interface\\Glues\\Models\\UI_NIGHTELF\\AA_NE_SKY"
						,"Interface\\Glues\\Models\\UI_Orc\\MM_ORC_SKY_01"
						}
				}

local DEFAULT_ALIGNMENTS = {options = {["left"] = "Left"
								,["center"] = "Center"
								,["right"] = "Right"	
								}
						,order = {"left"
								,"center"
								,"right"	
								}			
						}

local TrackerTypeList = {}
						
local _battlefieldInfo = {{name="Random Battlegrounds", isRated=false, isHeader = true, instanceType="battleground", totalID=839, winID=840, icon = "Interface\\ICONS\\Achievement_BG_KillFlagCarriers_grabFlag_CapIt"}
				,{name="Warsong Gulch", isRated=false, instanceType="battleground", totalID=52, winID=105, icon = "Interface\\ICONS\\INV_Misc_Rune_07"}
				,{name="Arathi Basin", isRated=false, instanceType="battleground", totalID=55, winID=51, icon = "Interface\\ICONS\\INV_Jewelry_Amulet_07"}
				,{name="Eye of the Storm", isRated=false, instanceType="battleground", totalID=54, winID=50, icon = "Interface\\ICONS\\Spell_Nature_EyeOfTheStorm"}
				,{name="Alterac Valley", isRated=false, instanceType="battleground", totalID=53, winID=49, icon = "Interface\\ICONS\\INV_Jewelry_Necklace_21"}
				,{name="Strand of the Ancients", isRated=false, instanceType="battleground", totalID=1549, winID=1550, icon = "Interface\\ICONS\\Achievement_BG_winSOA"}
				,{name="Isle of Conquest", isRated=false, instanceType="battleground", totalID=4096, winID=4097, icon = "Interface\\ICONS\\Achievement_BG_winWSG"}
				,{name="Twin Peaks", isRated=false, instanceType="battleground", totalID=5232, winID=5233, icon = "Interface\\ICONS\\spell_nature_earthshock"}
				,{name="The Battle for Gilneas", isRated=false, instanceType="battleground", totalID=5236, winID=5237, icon = "Interface\\ICONS\\Achievement_Battleground_BattleForGilneas"}
				,{name="Temple of Kotmogu", isRated=false, instanceType="battleground", totalID=7825, winID=7826, icon = "Interface\\ICONS\\Achievement_Battleground_TempleOfKotmogu_02"}
				,{name="Silvershard Mines", isRated=false, instanceType="battleground", totalID=7829, winID=7830, icon = "Interface\\ICONS\\INV_Crate_07"}
				,{name="Deepwind Gorge", isRated=false, instanceType="battleground", totalID=8374, winID=8373, icon = "Interface\\ICONS\\achievement_zone_valleyoffourwinds"}
				,{name="Arenas", isRated=false, isHeader = true, instanceType="arena", totalID=838, winID=837, icon = "Interface\\ICONS\\achievement_bg_winwsg"}
				,{name="2v2", isRated=false, instanceType="arena", totalID=367, winID=366, icon = "Interface\\ICONS\\Achievement_Arena_2v2_7"}
				,{name="3v3", isRated=false, instanceType="arena", totalID=365, winID=364, icon = "Interface\\ICONS\\Achievement_Arena_3v3_7"}
				,{name="5v5", isRated=false, instanceType="arena", totalID=363, winID=362, icon = "Interface\\ICONS\\Achievement_Arena_5v5_7"}
				,{name="Blade's Edge Arena", isRated=false, instanceType="arena", totalID=103, winID=104, icon = "Interface\\ICONS\\Achievement_Reputation_Ogre"}
				,{name="Dalaran Sewers", isRated=false, instanceType="arena", totalID=1547, winID=1548, icon = "Interface\\ICONS\\Spell_Arcane_TeleportDalaran"}
				,{name="Nagrand Arena", isRated=false, instanceType="arena", totalID=101, winID=100, icon = "Interface\\ICONS\\Achievement_Zone_Nagrand_01"}
				--,{name="Ring of Valor", isRated=false, instanceType="arena", totalID=1545, winID=1546, icon = "Interface\\ICONS\\Achievement_Raid_SoO_Orgrimmar_outdoors"}
				,{name="Ruins of Lordaeron", isRated=false, instanceType="arena", totalID=99, winID=102, icon = "Interface\\ICONS\\Achievement_Zone_TirisfalGlades_01"}
				,{name="Tol'viron Arena", isRated=false, instanceType="arena", totalID=7823, winID=7824, icon = "Interface\\ICONS\\Achievement_Battleground_TolvirArena"}
				,{name="The Tiger's Peak", isRated=false, instanceType="arena", totalID=8370, winID=8369, icon = "Interface\\ICONS\\Ability_Monk_SummonTigerStatue"}
				,{name="Rated Battlegrounds", isRated=true, isHeader = true, instanceType="battleground", totalID=5692, winID=5694, icon = "Interface\\ICONS\\Achievement_BG_KillFlagCarriers_grabFlag_CapIt"}
				,{name="Warsong Gulch", isRated=true, instanceType="battleground", totalID=5706, winID=5707, icon = "Interface\\ICONS\\INV_Misc_Rune_07"}
				,{name="Arathi Basin", isRated=true, instanceType="battleground", totalID=5696, winID=5697, icon = "Interface\\ICONS\\Spell_Nature_EyeOfTheStorm"}
				,{name="Eye of the Storm", isRated=true, instanceType="battleground", totalID=5700, winID=5701, icon = "Interface\\ICONS\\INV_Jewelry_Necklace_21"}
				,{name="Strand of the Ancients", isRated=true, instanceType="battleground", totalID=5702, winID=5703, icon = "Interface\\ICONS\\Achievement_BG_winSOA"}
				,{name="Twin Peaks", isRated=true, instanceType="battleground", totalID=5704, winID=5705, icon = "Interface\\ICONS\\spell_nature_earthshock"}
				,{name="The Battle for Gilneas", isRated=true, instanceType="battleground", totalID=5698, winID=5699, icon = "Interface\\ICONS\\Achievement_Battleground_BattleForGilneas"}
				,{name="Temple of Kotmogu", isRated=true, instanceType="battleground", totalID=7827, winID=7828, icon = "Interface\\ICONS\\Achievement_Battleground_TempleOfKotmogu_02"}
				,{name="Silvershard Mines", isRated=true, instanceType="battleground", totalID=7831, winID=7832, icon = "Interface\\ICONS\\INV_Crate_07"}
				,{name="Deepwind Gorge", isRated=true, instanceType="battleground", totalID=8371, winID=8372, icon = "Interface\\ICONS\\achievement_zone_valleyoffourwinds"}
				}

local WinrateOptionsTable = {}		
local FontCheckBox = "GameFontWhite"
local FontTracker = "GameFontNormal"

local BGOptions = { }
local ActiveBG = DEFAULT_BG

local TrackingFrames = {}


BGS_FrameEventFunctions = {}

local ddwn_Background =nil
local _Winrateframe =nil
local _WinrateScroller = nil

local L_BGS_CBHideIcons = nil
local L_BGS_CBHideTitle = nil
local L_BGS_SLColumns = nil

BGS_TrackerClasses.tooltip = CreateFrame("frame", "BGS_Tooltip", UIParent)
 
BGS_TrackerClasses.tooltip:SetBackdrop({bgFile = TEX_TOOLTIPBG,
      edgeFile = TEX_TOOLTIPBORDER,
	  tileSize = 0, edgeSize = 16,
      insets = { left = 8, right = 5, top = 5, bottom = 8 }
	  })

BGS_TrackerClasses.tooltip:SetFrameStrata("high")
BGS_TrackerClasses.tooltip:SetFrameLevel(60)
BGS_TrackerClasses.tooltip:SetPoint("center", UIParent)
BGS_TrackerClasses.tooltip:SetWidth(160)
BGS_TrackerClasses.tooltip:SetHeight(38)
BGS_TrackerClasses.tooltip:Hide()

BGS_TrackerClasses.tooltip.text = BGS_TrackerClasses.tooltip:CreateFontString(nil, nil, "GameFontHighlight")
BGS_TrackerClasses.tooltip.text:SetPoint("topleft", 15, -10)
BGS_TrackerClasses.tooltip.text:SetJustifyH("left")
BGS_TrackerClasses.tooltip.text:SetJustifyV("top")
BGS_TrackerClasses.tooltip.text:SetText("Information goes here")

function BGS_TrackerClasses.tooltip:ShowTooltip(parent, text)
	if parent == nil then
		return
	end
	self.text:SetWidth(0)
	self.text:SetHeight(0)
	self.text:SetWordWrap(false)
	--self:SetPoint("bottomleft", parent, "topright", 0, -5)
	--self:SetPoint("left", parent, "right", 0, 5)
	self:SetPoint("topleft", parent, "bottomleft", 0, -10)
	self:SetFrameLevel(60)
	self:Show()
	self.text:SetText(text)
	if self.text:GetWidth() > 200 then
		self.text:SetWidth(200)
		self.text:SetWordWrap(true)
	end
	BGS_TrackerClasses.tooltip:SetWidth(self.text:GetWidth() + 40)
	BGS_TrackerClasses.tooltip:SetHeight(self.text:GetHeight() + 25)
end

function BGS_TrackerClasses.tooltip:HideTooltip()
	self:Hide()
	self.text:SetText("")
	BGS_TrackerClasses.tooltip:SetWidth(40)
end

BGS_TrackerClasses.tooltip:ShowTooltip(nil, "Some text larger than the last one")

local function CreateOptionsContainer(name, parent, height, title)
	
	local L_BGS_ContainerBG = CreateFrame("frame", "BGS_"..name.."ContainerBG", parent.frame)
	L_BGS_ContainerBG:SetPoint("topleft", parent.frame, "topleft", 0, 0)
	L_BGS_ContainerBG:SetHeight(height)
	L_BGS_ContainerBG:SetWidth(578)
	
	L_BGS_ContainerBG.topleft = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_TL", "BACKGROUND")
	L_BGS_ContainerBG.topleft:SetTexture("Interface\\HELPFRAME\\HelpFrame-TopLeft")
	L_BGS_ContainerBG.topleft:SetTexCoord(0, 1, 0, 0.25)
	L_BGS_ContainerBG.topleft:SetWidth(128)
	L_BGS_ContainerBG.topleft:SetHeight(32)
	L_BGS_ContainerBG.topleft:SetPoint("topleft", L_BGS_ContainerBG)
	
	L_BGS_ContainerBG.bottomleft = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_BL", "BACKGROUND")
	L_BGS_ContainerBG.bottomleft:SetTexture("Interface\\HELPFRAME\\HELPFRAME-BOTLEFT")
	L_BGS_ContainerBG.bottomleft:SetTexCoord(0, 1, 0.75, 1)
	L_BGS_ContainerBG.bottomleft:SetWidth(128)
	L_BGS_ContainerBG.bottomleft:SetHeight(32)
	L_BGS_ContainerBG.bottomleft:SetPoint("bottomleft", L_BGS_ContainerBG)
	
	L_BGS_ContainerBG.topright = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_TR", "BACKGROUND")
	L_BGS_ContainerBG.topright:SetTexture("Interface\\HELPFRAME\\HelpFrame-TopRight")
	L_BGS_ContainerBG.topright:SetTexCoord(0, 1, 0, 0.25)
	L_BGS_ContainerBG.topright:SetWidth(64)
	L_BGS_ContainerBG.topright:SetHeight(32)
	L_BGS_ContainerBG.topright:SetPoint("topright", L_BGS_ContainerBG)
	
	L_BGS_ContainerBG.bottomright = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_BR", "BACKGROUND")
	L_BGS_ContainerBG.bottomright:SetTexture("Interface\\HELPFRAME\\HELPFRAME-BOTRIGHT")
	L_BGS_ContainerBG.bottomright:SetTexCoord(0, 1, 0.75, 1)
	L_BGS_ContainerBG.bottomright:SetWidth(64)
	L_BGS_ContainerBG.bottomright:SetHeight(32)
	L_BGS_ContainerBG.bottomright:SetPoint("bottomright", L_BGS_ContainerBG)
	
	L_BGS_ContainerBG.top = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_T", "BACKGROUND")
	L_BGS_ContainerBG.top:SetTexture("Interface\\HELPFRAME\\HelpFrame-Top", true)
	L_BGS_ContainerBG.top:SetTexCoord(0, 3, 0, 0.25)
	L_BGS_ContainerBG.top:SetPoint("topleft", L_BGS_ContainerBG.topleft, "topright")
	L_BGS_ContainerBG.top:SetPoint("bottomright", L_BGS_ContainerBG.topright, "bottomleft")
	
	L_BGS_ContainerBG.bottom = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_B", "BACKGROUND")
	L_BGS_ContainerBG.bottom:SetTexture("Interface\\HELPFRAME\\HELPFRAME-BOTTOM", true)
	L_BGS_ContainerBG.bottom:SetTexCoord(0, 3, 0.75, 1)
	L_BGS_ContainerBG.bottom:SetPoint("topleft", L_BGS_ContainerBG.bottomleft, "topright")
	L_BGS_ContainerBG.bottom:SetPoint("bottomright", L_BGS_ContainerBG.bottomright, "bottomleft")
	
	L_BGS_ContainerBG.left = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_L", "BACKGROUND")
	L_BGS_ContainerBG.left:SetTexture("Interface\\HELPFRAME\\HelpFrame-TopLeft")
	L_BGS_ContainerBG.left:SetTexCoord(0, 1, 0.5, 1)
	L_BGS_ContainerBG.left:SetPoint("topleft", L_BGS_ContainerBG.topleft, "bottomleft")
	L_BGS_ContainerBG.left:SetPoint("bottomright", L_BGS_ContainerBG.bottomleft, "topright")
	
	L_BGS_ContainerBG.right = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_R", "BACKGROUND")
	L_BGS_ContainerBG.right:SetTexture("Interface\\HELPFRAME\\HelpFrame-TopRight")
	L_BGS_ContainerBG.right:SetTexCoord(0, 1, 0.5, 1)
	L_BGS_ContainerBG.right:SetPoint("topleft", L_BGS_ContainerBG.topright, "bottomleft")
	L_BGS_ContainerBG.right:SetPoint("bottomright", L_BGS_ContainerBG.bottomright, "topright")
	
	L_BGS_ContainerBG.center = L_BGS_ContainerBG:CreateTexture("BGS_"..name.."_C", "BACKGROUND")
	L_BGS_ContainerBG.center:SetTexture("Interface\\HELPFRAME\\HelpFrame-TopLeft")
	L_BGS_ContainerBG.center:SetTexCoord(0.5, 1, 0.5, 1)
	L_BGS_ContainerBG.center:SetPoint("topleft", L_BGS_ContainerBG.topleft, "bottomright")
	L_BGS_ContainerBG.center:SetPoint("bottomright", L_BGS_ContainerBG.bottomright, "topleft")
	
	L_BGS_ContainerBG.title = L_BGS_ContainerBG:CreateFontString(nil, nil, FontCheckBox)
	L_BGS_ContainerBG.title:SetPoint("top",L_BGS_ContainerBG,"top", -17, -10)
	L_BGS_ContainerBG.title:SetJustifyH("center")
	L_BGS_ContainerBG.title:SetText(title)
	
	return L_BGS_ContainerBG
end

local function round(num, idp)
	--local ret = 0
	if num >= 0 then
		return tonumber(string.format("%." .. (idp or 0) .. "f", num))
	end
	return -1
	--return ret
end

local function ShortenNumber(number)
	local returnString = ""
	if number > 1000000 then
		return round(number/1000000, 2).. "M"
	elseif number > 1000 then
		return round(number/1000, 1).. "K"
	end
	
	return number
end

function BGS_TrackerClasses:GetAccHKills()

   return select(4, GetAchievementCriteriaInfo(5363, 1))--HKills
end

function BGS_TrackerClasses:GetHKills()
   return GetPVPLifetimeStats()
end

function BGS_TrackerClasses:GetConquestcap(bracked, limit)
	local pointsThisWeek, maxPointsThisWeek, tier2Quantity, tier2Limit, tier1Quantity, tier1Limit, randomPointsThisWeek, maxRandomPointsThisWeek, arenaReward, ratedBGReward = GetPVPRewards();
	if bracked == "all" then
		if limit then
			return maxPointsThisWeek
		else
			return pointsThisWeek
		end
	elseif bracked == "rbg" then
		if limit then
			return tier2Limit
		else
			return tier2Quantity 
		end
	elseif bracked == "arena" then
		if limit then
			return tier1Limit
		else
			return tier1Quantity 
		end
	elseif bracked == "random" then
		if limit then
			return maxRandomPointsThisWeek
		else
			return randomPointsThisWeek 
		end
	end
	
	return -1
end

function BGS_TrackerClasses:CountVisibleTrackers()
	local count = 0
	for k, v in ipairs(TestClasses) do
		if v.visipos > 0 then
			count = count + 1
		end
	end
	
   return count
end

function BGS_TrackerClasses:GetRatedInfo(bracket, option)
	local options = {GetPersonalRatedInfo(bracket)}
	if #options >= option and option > 0 then
		--options = nil
		return options[option]
	end
	options = nil
   return -1
end

function BGS_TrackerClasses:GetBGScoreRank(sort)
	local playerCount = GetNumBattlefieldScores()
	if playerCount == 0 or WorldStateScoreFrame:IsShown() then 
		return "--"
	end
	
	SortBattlefieldScoreData(sort)
	--resort frames if is wrong order
	local test = {{GetBattlefieldScore(1)}, {GetBattlefieldScore(2)}}
	if sort == "kills" then --3
		if test[1][2] == 0 or test[1][2] < test[2][2] then
			SortBattlefieldScoreData(sort)
		end
	elseif sort == "hk" then
		if test[1][3] == 0 or test[1][3] < test[2][3] then
			SortBattlefieldScoreData(sort)
		end
	elseif sort == "deaths" then
		if test[1][4] == 0 or test[1][4] < test[2][4] then
			SortBattlefieldScoreData(sort)
		end
	elseif sort == "damage" then
		if test[1][10] == 0 or test[1][10] < test[2][10] then
			SortBattlefieldScoreData(sort)
		end
	elseif sort == "healing" then
		if test[1][11] == 0 or test[1][11] < test[2][11] then
			SortBattlefieldScoreData(sort)
		end
	end

	for i=1, playerCount do 
		if GetBattlefieldScore(i) == _PlayerName then
			return i
		end
	end
	
   return 0
end

function BGS_TrackerClasses:GetBGInfo(option, sort)
	if GetNumBattlefieldScores() == 0 then 
		return "--"
	end
	
	if sort then
		SortBattlefieldScoreData(sort)
	end
	
	for i=1, GetNumBattlefieldScores() do 
		local name, killingBlows, honorableKills, deaths, honorGained, faction, race, class, classToken, damageDone, healingDone, bgRating, ratingChange, preMatchMMR, mmrChange, talentSpec = GetBattlefieldScore(i)
		if name == _PlayerName then
		
			if option =="KillingBlows" then
				return killingBlows
			elseif option =="HonorableKills" then
				return honorableKills
			elseif option =="Deaths" then
				return deaths
			elseif option =="DamageDone" then
				return ShortenNumber(damageDone)
			elseif option =="HealingDone" then
				return ShortenNumber(healingDone)
			end
			
		
		end
	end

   return -1
end

function BGS_TrackerClasses:GetCurrency(id)
   return select(2,GetCurrencyInfo(id))
end

function BGS_TrackerClasses:GetHonor()
   return BGS_TrackerClasses:GetCurrency(392)
end

function BGS_TrackerClasses:GetConquest()
   return BGS_TrackerClasses:GetCurrency(390)
end

function BGS_TrackerClasses:GetTB()
   return BGS_TrackerClasses:GetCurrency(391)
end

function BGS_TrackerClasses:GetGarrisonResources()
   return BGS_TrackerClasses:GetCurrency(824)
end

function BGS_TrackerClasses:GetArtifactFragments()
   return BGS_TrackerClasses:GetCurrency(944)
end

function BGS_TrackerClasses:GetBGHoliday()
	local _, _, bgName, _, bgWon, _, _, _, _, _ = GetHolidayBGInfo();
	if bgName ~= nil then
		return bgName
	end
	return "Unknown BG"
end

function BGS_TrackerClasses:GetBGHolidayWon()
	return select(4, GetHolidayBGInfo())
end

function BGS_TrackerClasses:GetFrameByName(name)
	for k, v in ipairs(DefaultFrames) do
		if string.lower(v:GetName()) == string.lower("BGS_"..name) then
			return v
		end
	end
	
	return nil
end



local function TempOETSWinLossFix(list)

	--table.remove(list, 4)-- remove EotS

	local wins = GetStatistic(list[1].winID) --total wins
	local total = GetStatistic(list[1].totalID) --total losses
	local loss = 0
	
	if total == "--" or total == 0 or wins == "--" then
		wins = 0
		loss = 0
	else
		loss = total - wins
	end
	
	local v = nil
	
	for i=2, #list do
		v=list[i]
		
		if v.name ~= "Eye of the Storm" and v.instanceType == "battleground"  and not v.isRated then --don't count EotS, duh
			local bgw = GetStatistic(v.winID)
			local bgt = GetStatistic(v.totalID)
			local bgl = 0
			
			if bgt == "--" or bgt == 0 or bgw == "--" then
				bgw = 0
				bgl = 0
			else
				bgl = bgt - bgw
			end
			
			wins = wins - bgw
			loss = loss - bgl
		end
	end
	
	return wins, loss
end

function BGS_TrackerClasses:BGS_GetWinrateString(name, display, rated)
	if rated == nil then rated = false end
	local bg, total, win, loss
	local list = _battlefieldInfo

	--general
	local v = nil
	for i=1, #list do
		v = list[i]
		if v.name == name and v.isRated == rated then
				bg = v.name
				
				if v.name == "Eye of the Storm" and not rated then 
					-- sure blizz fixes it soon(tm)
					win, loss = TempOETSWinLossFix(list)
					total = win + loss
					if total == 0 then
						winrate = 0
					else
						winrate =  (win/total)*100
					end

				else
					win = GetStatistic(v.winID)
					total = GetStatistic(v.totalID)
					
					if win == "--" then
						win = 0
					end
					
					if total == "--" or total == 0 then
						--win = 0
						winrate = 0
						loss = 0
					else
						winrate =  (win/total)*100
						loss = total - win
					end
				end
				
				
			end
		end
		
		if (bg) then
			if display == "full" or display == nil then
				return string.format("%d : %d (%.1f %%)", win, loss, winrate)
			end
			if display == "games" then
				return string.format("%d : %d", win, loss)
			end
			if display == "rate" then
				return string.format("%.1f %%", winrate)
			end
			if display == "wins" then
				return string.format("%.1d", win)
			end
			if display == "losses" then
				return string.format("%.1d", loss)
			end
		else
			if display == "full" or display == nil then
				return "-- : -- (--%)"
			end
			if display == "games" then
				return "-- : --"
			end
			if display == "rate" then
				return "--%"
			end
			if display == "wins" then
				return "--"
			end
			if display == "losses" then
				return "--"
			end
		end

	return -1
end

local function UpdateWinrate()
	for i=1, #WinrateOptionsTable do
		local bg = _battlefieldInfo[i]
		if bg.isHeader then
			WinrateOptionsTable[i].text:SetText("|cFFFFD100".. bg.name ..":|r " ..BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "full", bg.isRated))
		else
			WinrateOptionsTable[i].text:SetText("|cFFFFD100".. bg.name ..":|r\n " ..BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "full", bg.isRated))
		end
	end
end

local function GetOptionsFrameByInfo(info)
	for k, v in ipairs(OptionsFrame) do
		if string.lower(v.text:GetText()) == string.lower(info) then
			return v
		end
	end
	
	return -1
end

local function SetShowMainframe(show) 
	if show then
		IsShown = true
		BGStatFrame:Show()
		BGS_VisibleButton.tex:SetTexture("Interface\\LFGFRAME\\BattlenetWorking9")
	else
		IsShown = false
		BGStatFrame:Hide()
		BGS_VisibleButton.tex:SetTexture("Interface\\LFGFRAME\\BattlenetWorking4")
	end
end

local function UpdateFactionIcon()
	local faction = UnitFactionGroup("player")
	local factionIcon = "Interface\\PVPFrame\\PVP-Currency-"..faction
	BGS_Icon:SetWidth(24)
	BGS_Icon:SetHeight(24)
	BGS_Icon:SetPoint("right", BGS_FrameTitle.text, "left", -3, 0)
	if faction == "Neutral" then
		BGS_Icon:SetWidth(20)
		BGS_Icon:SetHeight(20)
		factionIcon = "Interface\\Timer\\Panda-Logo"
		BGS_Icon:SetPoint("right", BGS_FrameTitle.text, "left", -3, 0)
	end
	
	BGS_Icon:SetBackdrop({  
            bgFile = factionIcon,
            edgeFile = nil,
            tileSize = 32, edgeSize = 0,
      })
end

local function UpdateMainFrameBG()
	if BGStatFrame:IsMouseEnabled() then
		mainEdgefile = DEFAULT_EDGEFILE
		mainInset = 3
	else
		mainEdgefile = nill
		mainInset = 0
	end
	BGStatFrame:SetBackdrop({bgFile = mainBGBack,
      edgeFile = mainEdgefile,
	  tileSize = 0, edgeSize = 16,
      insets = { left = mainInset, right = mainInset, top = mainInset, bottom = mainInset }
	  })
end

local function ToggleLockbutton() 
	if BGStatFrame:IsMouseEnabled() then
		BGS_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF )
		PlaySound("igMainMenuOptionCheckBoxOff");
		BGStatFrame:EnableMouse(false)
		BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF )
			
	else	
		BGS_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
		PlaySound("igMainMenuOptionCheckBoxOn");
		BGStatFrame:EnableMouse(true)
		BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
			
	end
		UpdateMainFrameBG()
end



local function _CreateBaseFrame()
-- Mainframe
------------------------------------------------------------------------------------------------------------------------
	local L_BGStatFrame = CreateFrame("frame", "BGStatFrame", UIParent)
		UpdateMainFrameBG()
	BGStatFrame:SetWidth(DEFAULT_TRACKER_WIDTH * _TrackColumns)
	BGStatFrame:SetHeight(300)
	BGStatFrame:SetMovable(true)
	BGStatFrame:RegisterForDrag("LeftButton")
	BGStatFrame:SetScript("OnDragStart", BGStatFrame.StartMoving )
	BGStatFrame:SetScript("OnDragStop", BGStatFrame.StopMovingOrSizing)
	BGStatFrame:SetClampedToScreen(true)
	BGStatFrame:Show()

-- Mainframe Title
------------------------------------------------------------------------------------------------------------------------
	local L_FrameTitle = CreateFrame("Frame", "BGS_FrameTitle", BGStatFrame)
	--BGS_FrameTitle:SetPoint("top", BGStatFrame, "top", 0, 0)
	BGS_FrameTitle:SetPoint("topleft", 0, 0)
	BGS_FrameTitle:SetPoint("topright", 0, 0)
	BGS_FrameTitle:SetWidth(BGStatFrame:GetWidth())
	BGS_FrameTitle.text = BGS_FrameTitle:CreateFontString(nil, nil, "QuestFont_Shadow_Small")
	BGS_FrameTitle.text:SetPoint("center", 3, 0)
	BGS_FrameTitle.text:SetText("BG Stats")
	BGS_FrameTitle:SetHeight(22)
	BGS_FrameTitle:Show()

-- Mainframe Faction Icon
------------------------------------------------------------------------------------------------------------------------
	local L_Icon = CreateFrame("Frame", "BGS_Icon", BGS_FrameTitle)

	UpdateFactionIcon()
	
	--BGS_Icon:SetPoint("top", BGS_FrameTitle, "top", -38, 0)
	BGS_Icon:SetFrameLevel(L_FrameTitle:GetFrameLevel())
	BGS_Icon:Show()

-- Mainframe Close Button	
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_CloseButton = CreateFrame("Button", "BGS_CloseButton", BGS_FrameTitle)
	BGS_CloseButton:SetWidth(16)
	BGS_CloseButton:SetHeight(16)
	BGS_CloseButton:SetHitRectInsets(4, 4, 4, 4)
	BGS_CloseButton:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up")
	BGS_CloseButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Highlight")
	BGS_CloseButton:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Down")
	BGS_CloseButton:SetPoint("topright", BGS_FrameTitle, "topright", 0, -1)
	BGS_CloseButton:Show()
	BGS_CloseButton:SetScript("OnClick",  function() 
		PlaySound("igQuestLogClose");
		SetShowMainframe(false) 
	end)

-- Mainframe Config Button
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_ConfigButton = CreateFrame("Button", "BGS_ConfigButton", BGS_FrameTitle)
	BGS_ConfigButton:SetWidth(8)
	BGS_ConfigButton:SetHeight(8)
	BGS_ConfigButton:SetNormalTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
	BGS_ConfigButton:SetHighlightTexture("Interface\\BUTTONS\\UI-GuildButton-PublicNote-Up")
	BGS_ConfigButton:SetPushedTexture("Interface\\BUTTONS\\UI-GuildButton-OfficerNote-Up")
	BGS_ConfigButton:SetPoint("topright", BGS_FrameTitle, "topright", -4, -15)
	BGS_ConfigButton:Show()
	BGS_ConfigButton:SetScript("OnClick",  function() 
		if ( not InterfaceOptionsFramePanelContainer.displayedPanel ) then
			InterfaceOptionsFrame_OpenToCategory(CONTROLS_LABEL);
		end
		InterfaceOptionsFrame_OpenToCategory(addonName)
	end)

-- Mainframe Move Button
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_MoveButton = CreateFrame("Button", "BGS_MoveButton", BGS_FrameTitle)
	BGS_MoveButton:SetWidth(8)
	BGS_MoveButton:SetHeight(8)
	BGS_MoveButton.tex = BGS_MoveButton:CreateTexture("BGS_MoveButton_Tex")
	BGS_MoveButton.tex:SetTexture("Interface\\COMMON\\UI-ModelControlPanel")
	BGS_MoveButton.tex:SetPoint("topright", BGS_FrameTitle, "topright", -13, -15)
	BGS_MoveButton.tex:SetTexCoord(18/64, 36/64, 37/128, 53/128)
	BGS_MoveButton.tex:SetSize(8,8)
	BGS_MoveButton.tex:SetVertexColor(.8, .8, .8 ) 
	BGS_MoveButton:SetPoint("topright", BGS_FrameTitle, "topright", -13, -15)
	BGS_MoveButton:Show()
	BGS_MoveButton:SetScript("OnClick",  function() 
		ToggleLockbutton()
	end)
	BGS_MoveButton:SetScript("OnEnter",  function() 
		BGS_MoveButton.tex:SetVertexColor(1, 1, 1 )
	end)
	BGS_MoveButton:SetScript("OnLeave",  function() 
		if BGStatFrame:IsMouseEnabled() then
			BGS_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
		else	
			BGS_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF )
		end
	end)

-- Mainframe First Run Info
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_firstrunInfo = CreateFrame("frame", "BGS_firstrunInfo", BGStatFrame)
	BGS_firstrunInfo:SetPoint("left", BGStatFrame, "left", 0, 0)
	BGS_firstrunInfo:SetPoint("right", BGStatFrame, "right", 0, 0)
	BGS_firstrunInfo:SetPoint("bottom", BGStatFrame, "bottom", 0, 0)
	BGS_firstrunInfo:SetHeight(50)
	BGS_firstrunInfo:Hide()
	-- text
	BGS_firstrunInfo.text = BGS_firstrunInfo:CreateFontString(nil, nil, "GameFontNormal")	
	BGS_firstrunInfo.text:SetPoint("topleft", BGS_firstrunInfo, "topleft", 0, 0)
	BGS_firstrunInfo.text:SetPoint("bottomright", BGS_firstrunInfo, "bottomright", 0, 5)
	BGS_firstrunInfo.text:SetJustifyH("center")
	BGS_firstrunInfo.text:SetWordWrap(true)
	BGS_firstrunInfo.text:SetText("Open the\noptions to\nget started!")

end




----------------------------------------
-- Functions
----------------------------------------

local function ChangeBG(bg)
	if bg == "none" then
		ActiveBG = nil
	else
		ActiveBG = bg
	end
	mainBGBack = ActiveBG
	UpdateMainFrameBG()
end

local function ResizeBG(totalHeight, cols)
	local BGSize = 4--10
	if cols < 1 then
		cols = 1
	end
	
	if BGS_FrameTitle:IsShown() then
		BGSize = BGSize + BGS_FrameTitle:GetHeight()
	end
	
	if BGS_firstrunInfo:IsShown() then
		BGSize = BGSize + BGS_firstrunInfo:GetHeight()
	end
	
	if totalHeight == nil then
		local count = 0
		for  id, frame in ipairs(DefaultFrames) do
			if frame.visipos > 0 then
			--	count = count + 1
			BGSize = BGSize + frame:GetHeight()
			end
			BGSize = BGSize + math.ceil((count)/_TrackColumns) * DEFAULT_TRACKER_HEIGHT
		end
	else
		BGSize = BGSize + totalHeight
	end
	BGStatFrame:SetHeight(BGSize)
	BGStatFrame:SetWidth(DEFAULT_TRACKER_WIDTH * cols+2)
	return true
end

function BGS_TrackerClasses:TrackFramePos()
	local spacing = -2---6
	local usedColsMax = 1;
	local usedColsCount = 0;
	local maxRows = L_BGS_SLColumns:GetValue()
	if BGS_FrameTitle:IsShown() then
		spacing = spacing - BGS_FrameTitle:GetHeight()
	end
	
	-- create array with only shown frames ordered by visipos
	local shownArr = {}
	for k, class in ipairs(TestClasses) do
		if class.visipos > 0 then
			shownArr[class.visipos] = class.frame
		end
		if class ~= nil then
			class:SetColspan(class.frame.colSpan, _TrackColumns);
		end
	end
	
	-- place frames at their position
	local count = 0;
	for  k, frame in ipairs(shownArr) do
		--failsafe
		if frame.colSpan == nil then
			frame.colSpan = 1
		end
		--resize trackers bigger than frame
		if frame.colSpan > maxRows then
			frame.colSpan = maxRows
		end
		
		
		
		--count for trackers pushed to new line
		local freeSpace = maxRows - count % maxRows
		if frame.colSpan > freeSpace then
			count = count + freeSpace
			usedColsCount =  0
			
		end
		
		--count used rows
		usedColsCount = usedColsCount + frame.colSpan
		if usedColsCount > maxRows then
			usedColsCount = 0
		end
		
		if usedColsMax < usedColsCount then
			usedColsMax = usedColsCount
		end
		
		--change sliders max for trackers
		local TempFrame = frame
		
		--resize trackers to their columns
		frame:SetWidth(DEFAULT_TRACKER_WIDTH * frame.colSpan)
		--place frames
		local yPos = ((count)%maxRows) * DEFAULT_TRACKER_WIDTH
		local xPos = math.floor((count)/maxRows) * -TempFrame:GetHeight()
		count = count + frame.colSpan
		TempFrame:SetPoint("topleft", BGStatFrame, "topleft", yPos, spacing + xPos)
		--spacing = spacing - TempFrame:GetHeight()
		TempFrame:Show()
	end
	
	
	ResizeBG(math.ceil((count)/maxRows) * DEFAULT_TRACKER_HEIGHT, usedColsMax)
end



local function ShowVisibleTrackers()
-- Show every frame and their icons if chosen.
	for k, v in ipairs(TestClasses) do
		v.frame:Show()
		if L_BGS_CBHideIcons:GetValue() then
			v.frame.icon:Show()
		end
	end
end

local function HideHiddenTrackers()
-- Hide All frames that shouldn't be shown
	for k, v in ipairs(TestClasses) do
		if v.visipos == 0 then
			v.frame:Hide()
			v.frame.icon:Hide()
		end
	end
end


local function Options_PlaceShownFrames()
	local ypos = 5
	local step = 20
	-- place the shown frames in order
	local count = 1
	local VisibleArr = {}
	local HiddenArr = {}
	
	for k, v in ipairs(TestClasses) do	
		local frame = v.optionFrame
		if frame == -1 then
			return
		end
		if v.visipos > 0 then
			--frame.visible = true
			VisibleArr[v.visipos] = frame
		else
			HiddenArr[#HiddenArr+1] = frame
			--table.insert(HiddenArr, frame)
		end
	end

	
	if table.getn(VisibleArr) == 0 then
		BGS_OptionFramesContainer_Green:Hide()
	else
		BGS_OptionFramesContainer_Green:Show()
	end
	
	for k, v in ipairs(VisibleArr) do
		--v.visible = true
		local btnUp, btnDown, move = v:GetChildren()
		btnDown:Show()
		btnUp:Show()
		move:SetNormalTexture("Interface\\LFGFRAME\\BattlenetWorking9")
		v:SetPoint("topleft", v:GetParent(), "topleft", 5, -ypos)
		
		-- Color every other frame
		if (count%2 ~= 1) then
			v.bg:SetTexture(0,0,0)
		else
			v.bg:SetTexture(0.4,0.4,0.4)
		end
		
		ypos = ypos + step
		if count == 1 then
			btnUp:Hide()
			BGS_OptionFramesContainer_Green:SetPoint("topleft", v, "topleft", 0, 0)
		end
		if count == table.getn(VisibleArr) then
			btnDown:Hide()
			BGS_OptionFramesContainer_Green:SetPoint("bottomright", v, "bottomright", 0, 0)
		end
		count = count + 1
	end
	
	if table.getn(HiddenArr) == 0 then
		BGS_OptionFramesContainer_Red:Hide()
	else
		BGS_OptionFramesContainer_Red:Show()
	end
	
	for k, v in ipairs(HiddenArr) do
		--v.visible = true
		local btnUp, btnDown, move = v:GetChildren()
		local btnUp, btnDown, move = v:GetChildren()
		btnDown:Hide()
		btnUp:Hide()
		move:SetNormalTexture("Interface\\LFGFRAME\\BattlenetWorking4")
		v:SetPoint("topleft", v:GetParent(), "topleft", 5, -ypos)

		-- Color every other frame
		if (count%2 ~= 1) then
			v.bg:SetTexture(0,0,0)
		else
			v.bg:SetTexture(0.4,0.4,0.4)
		end
		if k == 1 then
			BGS_OptionFramesContainer_Red:SetPoint("topleft", v, "topleft", 0, 0)
		end
		if k == table.getn(HiddenArr) then

			BGS_OptionFramesContainer_Red:SetPoint("bottomright", v, "bottomright", 0, 0)
		end
		ypos = ypos + step
		count = count + 1
	end
	
end

local function GetNumShownFrames()
	local count = 0
	for k, v in ipairs(TestClasses) do	
		if v.visipos > 0 then
			count = count + 1
		end
	end
	return count
end

local function ShowFrame(frameNr)

	local key = 1
	for k, v in ipairs(TestClasses) do
		if v.frameNr == frameNr then
			key = k
		end
	end

	local frame = TestClasses[key]
	if (frame) then
		-- Get current highest pos and add the current frame after than
		local highestPos = 0
		for k, v in ipairs(TestClasses) do
			if v.visipos > highestPos then
				highestPos = v.visipos
			end
		end
		frame.visipos = highestPos + 1
	end
end

local function HideFrame(frameNr)
	local key = 1
	for k, v in ipairs(TestClasses) do
		if v.frameNr == frameNr then
			key = k
		end
	end

	local frame = TestClasses[key]
	--local class = Testclasses[key]
	if (frame) then
		-- change pos of hidden to 0
		local removedPos = frame.visipos
		--class.visipos = 0
		frame.visipos = 0
		-- move frames after hidden one 1 position down.
		for k, v in ipairs(TestClasses) do
			if v.visipos > removedPos then
				v.visipos = v.visipos - 1
			end
		end
	end
end

local function GetPositionInDefault(id)
	for k, v in ipairs(DefaultFrames) do	
		if v == id then
			return k
		end
	end
	return -1
end

local function GetPositionInDefaultName(s)
	for k, v in ipairs(DefaultFrames) do	
		if v[2] == s then
			return k
		end
	end
	return -1
end

local function GetPositionInShown(key)
	for k, v in ipairs(ShownFrames) do	
		if v == DefaultFrames[key] then
			return k
		end
	end
	return 0
end

local function MoveUpInShown(frameNr)

	local key = 1
	for k, v in ipairs(TestClasses) do
		if v.frameNr == frameNr then
			key = k
		end
	end


	local temp = TestClasses[key].visipos
	local otherFrame
	for k, v in ipairs(TestClasses) do
		if v.visipos == temp -1 then
			otherFrame = v
		end
	end
	local pos = otherFrame.visipos 
	otherFrame.visipos = TestClasses[key].visipos
	TestClasses[key].visipos = pos
end

local function MoveDownInShown(frameNr)

	local key = 1
	for k, v in ipairs(TestClasses) do
		if v.frameNr == frameNr then
			key = k
		end
	end

	-- Find other frame to switch places
	local temp = TestClasses[key].visipos
	local otherFrame
	for k, v in ipairs(TestClasses) do
		if v.visipos == temp +1 then
			otherFrame = v
		end
	end
	local pos = otherFrame.visipos 
	otherFrame.visipos = TestClasses[key].visipos
	TestClasses[key].visipos = pos
end

local function SetMaxColums(maxNr, frameWasRemoved)
	if maxNr <= 1 then
		maxNr = 1
	end

	maxNr = MAXFRAMES

	local current = L_BGS_SLColumns:GetValue()
	L_BGS_SLColumns:SetSliderValues(1, maxNr, 1)
	if frameWasRemoved and current > maxNr then
		current = maxNr
		_TrackColumns = maxNr
	end
	L_BGS_SLColumns:SetValue(current)
	
	
	
	for k, class in ipairs(TestClasses) do
		if class ~= nil then
			if frameWasRemoved and class.colSpan > current then
				class:SetColspan(current, current);
			end
			
			class:SetColspan(class.colSpan, current);
		end
	end
end

local function FixOptionFrames()
	SetMaxColums(BGS_TrackerClasses:CountVisibleTrackers())
	ShowVisibleTrackers()
	HideHiddenTrackers()
	Options_PlaceShownFrames()
	BGS_TrackerClasses:TrackFramePos()
	
	--ResizeBG()
end

function BGS_TrackerClasses:createSmallFrame(v)
	local k = v.frameNr
	local trackName = "BGS_Optframe_"..v.detail
		-- Create a small frame
		local BGS_OptframeDefault = CreateFrame("Button", trackName, BGS_OptionFramesContainer)
		BGS_OptframeDefault.tracker = v
		BGS_OptframeDefault:SetPoint("left", BGS_OptionFramesContainer, 0, 0)
		BGS_OptframeDefault:SetPoint("right", BGS_OptionFramesContainer, 0, 0)
		BGS_OptframeDefault:SetHeight(20)
		-- Default Background
		BGS_OptframeDefault.bg = BGS_OptframeDefault:CreateTexture(trackName.."_BG")
		BGS_OptframeDefault.bg:SetTexture("Interface\\CHATFRAME\\CHATFRAMEBACKGROUND")
		BGS_OptframeDefault.bg:SetDrawLayer("background", 0)
		BGS_OptframeDefault.bg:SetParent(BGS_OptframeDefault)
		BGS_OptframeDefault.bg:SetPoint("topleft",BGS_OptframeDefault,  0, 0)
		BGS_OptframeDefault.bg:SetPoint("bottomright",BGS_OptframeDefault, 0, 0)
		BGS_OptframeDefault.bg:SetVertexColor(.2, .2, .2)
		BGS_OptframeDefault.bg:SetAlpha(0.6)
		--BGS_OptframeDefault.bg:SetPoint("left", BGS_OptframeDefault, "left", 0, 0)
		BGS_OptframeDefault.bg:SetSize(BGS_OptframeDefault:GetWidth(),BGS_OptframeDefault:GetHeight()) 
		BGS_OptframeDefault.bg:Show()
		-- Selected frame Background
		BGS_OptframeDefault.hl = BGS_OptframeDefault:CreateTexture(trackName.."_Highlight")
		BGS_OptframeDefault.hl:SetTexture(nil)
		BGS_OptframeDefault.hl:SetDrawLayer("background", 1)
		BGS_OptframeDefault.hl:SetAlpha(1)
		BGS_OptframeDefault.hl:SetParent(BGS_OptframeDefault)
		BGS_OptframeDefault.hl:SetPoint("topleft", 0, 0)
		BGS_OptframeDefault.hl:SetPoint("bottomright", 0, 0)
		BGS_OptframeDefault.hl:SetSize(BGS_OptframeDefault:GetWidth(),BGS_OptframeDefault:GetHeight()) 
		BGS_OptframeDefault.hl:Show()
		--BGS_OptframeDefault:SetWidth(BGS_OptframeDefault:GetParent():GetWidth()-10)
		BGS_OptframeDefault:SetHighlightTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar-Blue")
		-- Face Text
		BGS_OptframeDefault.text = BGS_OptframeDefault:CreateFontString(nil, nil, FontCheckBox)
		BGS_OptframeDefault.text:SetPoint("left", 5, 0)
		BGS_OptframeDefault.text:SetWidth(120)
		BGS_OptframeDefault.text:SetJustifyH("left") 
		BGS_OptframeDefault.text:SetText(v.name)
		BGS_OptframeDefault:SetScript("OnClick",  function(self)
			PlaySound("igMainMenuOptionCheckBoxOn");
			local info = v.info
			FixOptionFrames()
			-- Reset all frames
			for k, v in ipairs(OptionsFrame) do
				v.bg:SetVertexColor(.2, .2, .2)
				v.bg:SetTexCoord(0,1,0,1)
				v.hl:SetTexture(nil)
			end
			
			-- Give highlight to clicked frame
			BGS_OptframeDefault.hl:SetTexture("Interface\\FriendsFrame\\UI-FriendsFrame-HighlightBar")
			-- Change label of info box
			BGS_FramesortBG_Info.text:SetText(BGS_OptframeDefault.text:GetText())
			
			-- Hide all children in info box
			if {BGS_FramesortBG_Info:GetChildren()} ~= nill	then
				for k, child in ipairs({BGS_FramesortBG_Info:GetChildren()}) do
					child:Hide()
				end
			end
			
			-- Place the info/options of the frame in the info box
			if v.options ~= nill then
				for k, f in ipairs(v.options) do
					f.frame:SetParent(BGS_FramesortBG_Info)
					f.frame:SetPoint("topleft", BGS_FramesortBG_Info, "topleft", 0, 0)
					f.frame:SetPoint("bottomright", BGS_FramesortBG_Info, "bottomright", 0, 0)
					f.frame:Show()
				end
			else
				--print("Options are nill")
			end
			
		end)-- end of frame onclick function

		OptionsFrame[#OptionsFrame+1] = BGS_OptframeDefault
		--table.insert(OptionsFrame, BGS_OptframeDefault)

		-- create up button
		local moveUp = CreateFrame("Button", trackName.."_moveUp", BGS_OptframeDefault)
		moveUp:SetWidth(OPTIONS_TINYBTN_SIZE)
		moveUp:SetHeight(OPTIONS_TINYBTN_SIZE)
		moveUp:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Up")
		moveUp:SetHighlightTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Down")
		moveUp:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Down")
		moveUp:SetPoint("left", trackName, "left", 122 +(15+1)*1, 0)
		moveUp.classRef = v
		moveUp:SetScript("OnClick",  function(self)
			PlaySound("igMainMenuOptionCheckBoxOn");
			MoveUpInShown(moveUp.classRef.frameNr)
			FixOptionFrames()
		end)
		moveUp:Hide()
		moveUp:SetScript("OnEnter",  function(self) 
			BGS_TrackerClasses.tooltip:ShowTooltip(self, "Move this tracker up in the list.")
		end)
		moveUp:SetScript("OnLeave",  function() 
			BGS_TrackerClasses.tooltip:HideTooltip()
		end)

		-- create down button
		local moveDown = CreateFrame("Button", trackName.."_moveDown", BGS_OptframeDefault)
		moveDown:SetWidth(OPTIONS_TINYBTN_SIZE)
		moveDown:SetHeight(OPTIONS_TINYBTN_SIZE)
		moveDown:SetNormalTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollDown-Up")
		moveDown:SetHighlightTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollDown-Down")
		moveDown:SetPushedTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollDown-Down")
		moveDown:SetPoint("left", trackName, "left", 122 +(15+1)*2, 0)
		moveDown.classRef = v
		moveDown:SetScript("OnClick",  function(self)
			PlaySound("igMainMenuOptionCheckBoxOn");
			MoveDownInShown(moveDown.classRef.frameNr)
			FixOptionFrames()
		end)
		moveDown:Hide()
		
		moveDown:SetScript("OnEnter",  function(self) 
			BGS_TrackerClasses.tooltip:ShowTooltip(self, "Move this tracker down in the list.")
		end)
		moveDown:SetScript("OnLeave",  function() 
			BGS_TrackerClasses.tooltip:HideTooltip()
		end)

		-- create move button 
		local move = CreateFrame("Button", trackName.."_move", BGS_OptframeDefault)
		move:SetWidth(OPTIONS_TINYBTN_SIZE)
		move:SetHeight(OPTIONS_TINYBTN_SIZE)
		--move:SetNormalTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Up")
		move:SetHighlightTexture("Interface\\LFGFRAME\\BattlenetWorking2")
		--move:SetPushedTexture("Interface\\BUTTONS\\UI-SpellbookIcon-NextPage-Down")
		move:SetPoint("left", trackName, "left", 122, 0)
		move:Show()
		move.classRef = v
		move:SetScript("OnClick",  function(self)
			BGS_firstrunInfo:Hide()
			PlaySound("igMainMenuOptionCheckBoxOn");
			local parent = self:GetParent()
			local btnUp, btnDown = parent:GetChildren()
			-- swap frame between boxes
			if (v.visipos > 0) then
				HideFrame(move.classRef.frameNr)
				btnUp:Hide()
				btnDown:Hide()
			else
				btnUp:Show()
				btnDown:Show()
				ShowFrame(move.classRef.frameNr)
			end
			parent:SetPoint("left", 0, 0)
			parent:SetPoint("right", 0, 0)
			FixOptionFrames()
		end)
		
		move:SetScript("OnEnter",  function(self) 
			BGS_TrackerClasses.tooltip:ShowTooltip(self, "Enable or disable this tracker.")
		end)
		move:SetScript("OnLeave",  function() 
			BGS_TrackerClasses.tooltip:HideTooltip()
		end)
		
		
		return BGS_OptframeDefault
end

function BGS_TrackerClasses:CreateTrackerFrame(class)
	
	if #TestClasses >= MAXFRAMES then
		return
	end
	
	local frame = CreateFrame("frame", "BGS_"..class.detail, BGStatFrame)
	-- text
	frame.text = frame:CreateFontString(nil, nil, "GameFontNormal")	
	frame.text:SetPoint("left", DEFAULT_TRACKOFFSET_WITH, 0)
	frame.text:SetPoint("right", -2, 0)
	frame.text:SetJustifyH(class.justify)
	frame.text:SetWordWrap(false)
	-- icon
	frame.icon = frame:CreateTexture(class.name.."_Icon")
	frame.icon:SetTexture(class.icon)
	frame.icon:SetPoint("left", frame, "left", 3, -1)
	frame.icon:SetSize(18,18) 
	frame.icon:Show()
	frame.detail = class.detail
	frame.info = class.info
	frame.options = class.options
	if class.colSpan == nil then
		class.colSpan = 1
	end
	frame.colSpan = class.colSpan
	--class.visipos = #DefaultFrames + 1
	--frame.visipos = class.visipos
	frame.class = class
	frame:SetPoint("topleft", BGStatFrame, "topleft", 0, -25)
	frame:SetWidth(DEFAULT_TRACKER_WIDTH * class.colSpan)
	--frame.text:SetWidth(DEFAULT_TRACKER_WIDTH * v.colSpan -30)
	frame:SetHeight(DEFAULT_TRACKER_HEIGHT)
	frame:Hide()
	DefaultFrames[#DefaultFrames+1] = frame
	--table.insert(DefaultFrames, frame)
	table.sort(DefaultFrames, function(a, b) if a.detail < b.detail then return true end end)
	

	return frame
	
end


local function RemoveFrame(pos)
	TestClasses[pos].frame:Hide()
	TestClasses[pos].optionFrame:Hide()
	
	if TestClasses[pos].visipos ~= 0 then -- don't change things if deleted frame is hidden
		for i=1,#TestClasses do 
			if TestClasses[i].visipos > TestClasses[pos].visipos then -- change frames that are higher than this one
				TestClasses[i].visipos = TestClasses[i].visipos -1
			end
		end
	end
	
	table.remove(TestClasses, pos)
	
	for i=pos,#TestClasses do 
		TestClasses[i].frameNr = TestClasses[i].frameNr -1
	end
	
	
	
	
	if {BGS_FramesortBG_Info:GetChildren()} ~= nill	then
		for k, child in ipairs({BGS_FramesortBG_Info:GetChildren()}) do
			child:Hide()
		end
	end
			
			-- Place the info/options of the frame in the info box
		BGS_OptionDefaultInfo.frame:SetParent(BGS_FramesortBG_Info)
		BGS_OptionDefaultInfo.frame:SetPoint("topleft", BGS_FramesortBG_Info, "topleft", 0, 0)
		BGS_OptionDefaultInfo.frame:SetPoint("bottomright", BGS_FramesortBG_Info, "bottomright", 0, 0)
		BGS_OptionDefaultInfo.frame:Show()
		BGS_FramesortBG_Info.text:SetText("Track Options")
	
	FixOptionFrames()
end

local function CreateTrackerOfType(frameType, name ,save)

	if #TestClasses >= MAXFRAMES then
		return
	end

	for k, v in ipairs(BGS_TrackerClasses) do
		if(v.fType == frameType) then
			_CreatedFrameCounter = _CreatedFrameCounter + 1
			local count = _CreatedFrameCounter
			
			if name == nil then
				name = v.fType..count
			end
			
			tracker = v.class(name, count, save)
			--if save ~= nil then
			--	tracker:LoadSave(save)
			--end
			if tracker.visipos == -1 then
				tracker.visipos = GetNumShownFrames() + 1
			end
			table.insert(TestClasses, tracker)
			
			SetMaxColums(#TestClasses)
			FixOptionFrames()
			
			return
		end
	end
	
end

function BGS_TrackerClasses:CreateDefaultTrackerOptions(class)
	local DEFAULT_TRACKER_OPTIONS = {}
	
	local txt_Name = AceGUI:Create("EditBox")
	txt_Name:SetLabel("Tracker Name")
	txt_Name:SetText(class.name)
	txt_Name:SetRelativeWidth(0.5)
	txt_Name:SetCallback("OnTextChanged", function(__,__, value)
		class.name = value
		class.optionFrame.text:SetText(value)
	end)
	DEFAULT_TRACKER_OPTIONS.txt_Name = txt_Name
	
	local frameDetail = AceGUI:Create("SimpleGroup")
	frameDetail:SetRelativeWidth(0.5)
	frameDetail:SetHeight(25)
	frameDetail:SetLayout("Fill")
	--frameDetail.bg = frameDetail.frame:CreateTexture("frameDetail_Tex")
	--frameDetail.bg:SetTexture("Interface\\LFGFRAME\\UI-LFG-SEPARATOR")
	--frameDetail.bg:SetHeight(frameDetail.frame:GetHeight()/2)
	--frameDetail.bg:SetTexCoord(0, 168/256, 0, 34/128)
	--frameDetail.bg:SetPoint("bottom", 0, -2)
	frameDetail.text = frameDetail.frame:CreateFontString(nil, nil, "GameFontHighlightSmall")
	frameDetail.text:SetHeight(frameDetail.frame:GetHeight())
	frameDetail.text:SetText("Tracker type:\n"..class.type)
	frameDetail.text:SetPoint("topleft", 0, 0)
	frameDetail.text:SetPoint("topright", 0, 0)
	frameDetail.text:SetPoint("topright", 0, 0)
	DEFAULT_TRACKER_OPTIONS.frameDetail = frameDetail
	
	local RemoveButton = CreateFrame("Button", "BGS_Options_"..class.detail.."remove", frameDetail.frame)
	RemoveButton:SetWidth(32)
	RemoveButton:SetHeight(32)
	RemoveButton:SetHitRectInsets(4, 4, 4, 4)
	RemoveButton:SetNormalTexture("Interface\\BUTTONS\\CancelButton-Up")
	RemoveButton:SetHighlightTexture("Interface\\BUTTONS\\CancelButton-Highlight")
	RemoveButton:SetPushedTexture("Interface\\BUTTONS\\CancelButton-Down")
	RemoveButton:SetPoint("bottomright", frameDetail.frame, "bottomright", -5, 5)
	--FPS_CloseButton:Show()
	RemoveButton:SetScript("OnClick",  function() 
		
		
		local pos = -1;
		
		for k, v in ipairs(TestClasses) do
			if v.detail == class.detail then
				pos = k
			end
		end
		
		if pos ~= -1 then
			RemoveFrame(pos)
			SetMaxColums(BGS_TrackerClasses:CountVisibleTrackers(), true)
			FixOptionFrames()
		end
		
	end)
	
	RemoveButton:SetScript("OnEnter",  function(self) 
		BGS_TrackerClasses.tooltip:ShowTooltip(self, "Remove this tracker.")
	end)
	RemoveButton:SetScript("OnLeave",  function() 
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)
	
	local sl_ColSpan = AceGUI:Create("Slider")
	--sl_ColSpan:SetFullWidth(true)
	sl_ColSpan:SetRelativeWidth(0.5)
	sl_ColSpan:SetLabel("Column Span")
	sl_ColSpan:SetSliderValues(1, 1 , 1)
	sl_ColSpan:SetValue(1)
	sl_ColSpan:SetCallback("OnValueChanged", function(__,__,value)
		--local frame = BGS_TrackerClasses:GetFrameByName(class.name)
		class.frame.colSpan = tonumber(value)
		BGS_TrackerClasses:TrackFramePos()
	end)
	DEFAULT_TRACKER_OPTIONS.sl_ColSpan = sl_ColSpan
	
	sl_ColSpan:SetCallback("OnEnter", function(self, _, value)
		BGS_TrackerClasses.tooltip:ShowTooltip(self.frame, "Choose the amount of colums the tracker spans.\nThe max size is determined by the number of colums chosen in the misc options slider.")
	end)
	sl_ColSpan:SetCallback("OnLeave", function(_, _, value)
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)

	ddwn_Align = AceGUI:Create("Dropdown")
	ddwn_Align:SetRelativeWidth(0.4)
	ddwn_Align:SetList(DEFAULT_ALIGNMENTS.options, DEFAULT_ALIGNMENTS.order)
	ddwn_Align:SetLabel("Text Alignment")
	ddwn_Align:SetCallback("OnValueChanged", function(_,_, choise)
		class.justify = choise
		class.frame.text:SetJustifyH(class.justify)
	end)
	
	DEFAULT_TRACKER_OPTIONS.ddwn_Align = ddwn_Align
	--ddwn_Background_Container:AddChild(ddwn_Background)
	
	return DEFAULT_TRACKER_OPTIONS
end

----------------------------------------
-- Options Frame
----------------------------------------
local function Options_ChangeListstHeights()
	local step = 20
	local size = 10 + table.getn(DefaultFrames) * step
	if size < 110 then
		size = 110
	end
	BGS_OptionFramesContainer:SetHeight(size)
	--BGS_OptionFramesContainer.bg:SetHeight(size-12)
end

local function ShowTrackerBorders(show)
	local frameEdge = nil
	if (show) and (BGOptions.CBBorders:GetValue()) then
		frameEdge = "Interface\\Tooltips\\UI-Tooltip-Border"
	end
	
	for k, frame in ipairs(DefaultFrames) do
	frame:SetBackdrop({edgeFile = frameEdge, edgeSize = 7})
	end
end

local function _CreateOptionsFrames()

	local ypos = 16
	local step = 20

-- Base Frame
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_Option = CreateFrame("Frame", "BGS_Option", InterfaceOptionsFramePanelContainer)
	BGS_Option:SetPoint("topleft", 0, 0)
	BGS_Option:Hide()
	BGS_Option:SetPoint("bottomright", 0, 0)
	BGS_Option.name = addonName
	BGS_Option:SetScript("OnShow", function() ShowTrackerBorders(true) end)
	BGS_Option:SetScript("OnHide", function() ShowTrackerBorders(false) end)
	
-- Options Title
------------------------------------------------------------------------------------------------------------------------
	local BGS_Option_Title = BGS_Option:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	BGS_Option_Title:SetPoint("TOPLEFT", 16, -ypos)
	BGS_Option_Title:SetText(addonName .. " v" .. versionNr)

-- Move button
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_LockButton = CreateFrame("Button", "BGS_LockButton", BGS_Option)
	BGS_LockButton:SetWidth(16)
	BGS_LockButton:SetHeight(16)
	BGS_LockButton:SetPoint("left", BGS_Option_Title, "right", 10, 0)
	BGS_LockButton.text = BGS_LockButton:CreateFontString(nil, nil, "GameFontNormal")
	BGS_LockButton.text:SetPoint("top", 0, -3)
	BGS_LockButton:Show()
	BGS_LockButton:SetScript("ONCLICK", ToggleLockbutton)
	BGS_LockButton.tex = BGS_LockButton:CreateTexture("BGS_LockButton_Tex")
	BGS_LockButton.tex:SetTexture("Interface\\COMMON\\UI-ModelControlPanel")
	BGS_LockButton.tex:SetPoint("center", BGS_LockButton, "center", 0, 0)
	BGS_LockButton.tex:SetTexCoord(18/64, 36/64, 37/128, 53/128)
	BGS_LockButton.tex:SetSize(17,17)
	BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON ) 
	BGS_LockButton:SetScript("OnEnter",  function(self) 
		BGS_LockButton.tex:SetVertexColor(1, 1, 1 )
		BGS_TrackerClasses.tooltip:ShowTooltip(self, "Enable/disable frame movement.")
	end)
	BGS_LockButton:SetScript("OnLeave",  function() 
		if BGStatFrame:IsMouseEnabled() then
			BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
		else	
			BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF )
		end
		Text_OptionInfo.text:SetText("")
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)

-- Show/Hide Button
------------------------------------------------------------------------------------------------------------------------

	local L_BGS_VisibleButton = CreateFrame("Button", "BGS_VisibleButton", BGS_Option)
	BGS_VisibleButton:SetWidth(16)
	BGS_VisibleButton:SetHeight(16)
	BGS_VisibleButton:SetPoint("left", BGS_LockButton, "right", 10, 0)
	BGS_VisibleButton.text = BGS_VisibleButton:CreateFontString(nil, nil, "GameFontNormal")
	BGS_VisibleButton.text:SetPoint("top", 0, -3)
	BGS_VisibleButton:Show()
	BGS_VisibleButton:SetScript("ONCLICK", function() SetShowMainframe((not BGStatFrame:IsShown())) end)
	BGS_VisibleButton.tex = BGS_VisibleButton:CreateTexture("BGS_VisibleButton_Tex")
	BGS_VisibleButton.tex:SetTexture("Interface\\LFGFRAME\\BattlenetWorking9")
	BGS_VisibleButton.tex:SetPoint("center", BGS_VisibleButton, "center", 0, 0)
	BGS_VisibleButton.tex:SetSize(25,25)
	BGS_VisibleButton:SetScript("OnEnter",  function(self) 
		BGS_VisibleButton.tex:SetTexture("Interface\\LFGFRAME\\BattlenetWorking2")
		BGS_TrackerClasses.tooltip:ShowTooltip(self, "Show/hide tracking frame.")
	end)
	BGS_VisibleButton:SetScript("OnLeave",  function() 
		if BGStatFrame:IsShown() then
			BGS_VisibleButton.tex:SetTexture("Interface\\LFGFRAME\\BattlenetWorking9")
		else	
			BGS_VisibleButton.tex:SetTexture("Interface\\LFGFRAME\\BattlenetWorking4")
		end
		Text_OptionInfo.text:SetText("")
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)

-- Button Mouseover Text
------------------------------------------------------------------------------------------------------------------------
	local L_Text_OptionInfo = CreateFrame("FRAME", "Text_OptionInfo", BGS_Option)
	Text_OptionInfo:SetHeight(15);
	Text_OptionInfo:SetWidth(100);
	Text_OptionInfo:SetPoint("left", L_BGS_VisibleButton, "right", 20, 0)
	Text_OptionInfo.text = Text_OptionInfo:CreateFontString(nil, nil, FontCheckBox)
	Text_OptionInfo.text:SetPoint("left", 0, 0)
	Text_OptionInfo.text:SetText("")
	Text_OptionInfo:Show()

-- Main Scrollcontainer
------------------------------------------------------------------------------------------------------------------------
	local Options_MainScrollContainer = AceGUI:Create("SimpleGroup")
	Options_MainScrollContainer:SetFullWidth(true)
	Options_MainScrollContainer:SetWidth(185)
	Options_MainScrollContainer:SetFullHeight(true)
	Options_MainScrollContainer:SetLayout("Fill")
	Options_MainScrollContainer.frame:SetParent(BGS_Option)
	Options_MainScrollContainer.frame:SetPoint("topleft", 20, -40)
	Options_MainScrollContainer.frame:SetPoint("bottomright", -5, 5)

	local Options_MainScroller = AceGUI:Create("ScrollFrame")
	Options_MainScroller:SetLayout("Flow")
	Options_MainScrollContainer:AddChild(Options_MainScroller)
	

-- Options Lists Container
------------------------------------------------------------------------------------------------------------------------

	local L_BGS_ListsGroup = AceGUI:Create("SimpleGroup")
	L_BGS_ListsGroup:SetFullWidth(true)
	L_BGS_ListsGroup:SetHeight(35)
	L_BGS_ListsGroup:SetLayout("Fill")
	Options_MainScroller:AddChild(L_BGS_ListsGroup)

	local OptionFramesBG = CreateOptionsContainer("OptionFrames", L_BGS_ListsGroup, 375, "Tracker Customisation")
	
	OptionFramesBG.divide = OptionFramesBG:CreateTexture("BGS_OptionFrames_D", "BORDER")
	OptionFramesBG.divide:SetTexture("Interface\\FriendsFrame\\UI-ChannelFrame-VerticalBar", true)
	OptionFramesBG.divide:SetWidth(6)
	OptionFramesBG.divide:SetTexCoord(0.46, 0.52, 0, 3)
	OptionFramesBG.divide:SetPoint("topleft", OptionFramesBG.top, "topleft",65,-25)
	OptionFramesBG.divide:SetPoint("bottomleft", OptionFramesBG.bottom, "bottomleft", 65,24)

	
	
-- Visible Frame Box
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_OptionFramesContainer = CreateFrame("frame", "BGS_OptionFramesContainer", L_BGS_ListsGroup.frame)
	BGS_OptionFramesContainer:SetPoint("topleft", OptionFramesBG.topleft, "topleft", 5, -22)
	BGS_OptionFramesContainer:SetPoint("bottomright", OptionFramesBG.divide, "bottomleft", 0, 0)
	
	BGS_OptionFramesContainer.green = BGS_OptionFramesContainer:CreateTexture("BGS_OptionFramesContainer_Green")
	BGS_OptionFramesContainer.green:SetTexture(0,0.2,0)
	BGS_OptionFramesContainer.green:SetPoint("topleft", BGS_OptionFramesContainer,0, 0)
	BGS_OptionFramesContainer.green:SetPoint("bottomright", BGS_OptionFramesContainer,0, 0)
	BGS_OptionFramesContainer.green:Show()
	
	BGS_OptionFramesContainer.red = BGS_OptionFramesContainer:CreateTexture("BGS_OptionFramesContainer_Red")
	BGS_OptionFramesContainer.red:SetTexture(0.2,0,0)
	BGS_OptionFramesContainer.red:SetPoint("topleft", BGS_OptionFramesContainer,0, 0)
	BGS_OptionFramesContainer.red:SetPoint("bottomright", BGS_OptionFramesContainer,0, 0)
	BGS_OptionFramesContainer.red:Show()
	L_BGS_ListsGroup:SetHeight(OptionFramesBG:GetHeight())

-- Frame Info Box
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_FramesortBG_Info = CreateFrame("frame", "BGS_FramesortBG_Info", L_BGS_ListsGroup.frame)
	BGS_FramesortBG_Info:SetPoint("bottomleft", OptionFramesBG.divide, "bottomright", 5, 1)
	BGS_FramesortBG_Info:SetPoint("topright", OptionFramesBG.topright, "topright", -27, -25)
	
	BGS_FramesortBG_Info.text = BGS_FramesortBG_Info:CreateFontString(nil, nil, FontCheckBox)
	BGS_FramesortBG_Info.text:Hide()
	BGS_FramesortBG_Info.text:SetPoint("top", 0, 15)
	BGS_FramesortBG_Info.text:SetText("Track Options")

-- New tracker options
	BGS_NewTrackerOptions = AceGUI:Create("SimpleGroup")
	BGS_NewTrackerOptions:SetFullWidth(true)
	BGS_NewTrackerOptions:SetWidth(185)
	BGS_NewTrackerOptions:SetFullHeight(true)
	BGS_NewTrackerOptions:SetHeight(170)
	BGS_NewTrackerOptions:SetLayout("Flow")
	BGS_NewTrackerOptions.frame:SetParent(BGS_FramesortBG_Info)
	BGS_NewTrackerOptions.frame:SetPoint("topleft", BGS_FramesortBG_Info, "topleft", 0, 0)
	BGS_NewTrackerOptions.frame:SetPoint("bottomright", BGS_FramesortBG_Info, "bottomright", 0, 0)
	BGS_NewTrackerOptions.frame:Hide()

	local infoEmpty2 = AceGUI:Create("SimpleGroup")
	
	infoEmpty2:SetFullWidth(true)
	infoEmpty2:SetHeight(20);
	BGS_NewTrackerOptions:AddChild(infoEmpty2)
	
	local txt_Name = AceGUI:Create("EditBox")
	txt_Name:SetLabel("Name")
	txt_Name:SetRelativeWidth(0.45)
	
	local lbl_CreateNewInfo = AceGUI:Create("SimpleGroup")
	lbl_CreateNewInfo:SetRelativeWidth(1)
	lbl_CreateNewInfo:SetHeight(45)
	lbl_CreateNewInfo:SetLayout("fill")
	lbl_CreateNewInfo.text = lbl_CreateNewInfo.frame:CreateFontString(nil, nil, "GameFontHighlightSmall")
	lbl_CreateNewInfo.text:SetText("Create a new tracker for the type of your choise.\nSelect which type of tracker your would like to create.\nIf you'd like you can give the tracker a custom name.")
	lbl_CreateNewInfo.text:SetJustifyH("left")
	lbl_CreateNewInfo.text:SetJustifyV("top")
	lbl_CreateNewInfo.text:SetPoint("topleft", 10, -5)
	lbl_CreateNewInfo.text:SetPoint("bottomright")
	BGS_NewTrackerOptions:AddChild(lbl_CreateNewInfo)

	local lbl_frameInfo = AceGUI:Create("SimpleGroup")
	lbl_frameInfo:SetRelativeWidth(1)
	lbl_frameInfo:SetHeight(50)
	lbl_frameInfo:SetLayout("fill")
	lbl_frameInfo.text = lbl_frameInfo.frame:CreateFontString(nil, nil, "GameFontHighlightSmall")
	lbl_CreateNewInfo.text:SetJustifyV("top")
	lbl_frameInfo.text:SetText("")
	lbl_frameInfo.text:SetPoint("topleft")
	lbl_frameInfo.text:SetPoint("bottomright")
	
	
	local ddwn_TrackerType_Container = AceGUI:Create("SimpleGroup")
	--ddwn_Background_Container:SetRelativeWidth(1)
	ddwn_TrackerType_Container:SetRelativeWidth(0.5)
	BGS_NewTrackerOptions:AddChild(ddwn_TrackerType_Container)
	-- put name to the right
	BGS_NewTrackerOptions:AddChild(txt_Name)
	
	
	for k, v in ipairs(BGS_TrackerClasses)do
		TrackerTypeList[v.fType] = v.fType
	end
	
	ddwn_TrackerType = AceGUI:Create("Dropdown")
	ddwn_TrackerType:SetWidth(150)
	ddwn_TrackerType:SetList(TrackerTypeList)
	ddwn_TrackerType:SetLabel("Type")
	ddwn_TrackerType:SetCallback("OnValueChanged", function(_,_, choise)
		ddwn_TrackerType.choise = choise
		txt_Name:SetText(choise)
		for k, v in ipairs(BGS_TrackerClasses) do
			if v.fType == choise then
				lbl_frameInfo.text:SetText(v.info)
				break
			end
		end
		--ChangeBG(choise)
	end)
	--ddwn_TrackerType:SetValue(TrackerTypeList[0])
	ddwn_TrackerType_Container:AddChild(ddwn_TrackerType)
	
	local txt_Create = AceGUI:Create("Button")
	txt_Create:SetText("Create")
	txt_Create:SetRelativeWidth(0.45)
	txt_Create:SetCallback("OnClick", function(__,__,value)
		--local frame = BGS_TrackerClasses:GetFrameByName(class.name)
		CreateTrackerOfType(ddwn_TrackerType.choise, txt_Name:GetText())
		ShowTrackerBorders(L_BGS_CBBorders:GetValue())
		--CreateTrackerOfType(txt_Name:GetText())
	end)
	BGS_NewTrackerOptions:AddChild(txt_Create)
	BGS_NewTrackerOptions:AddChild(lbl_frameInfo)
	
	
	
	local ShowCreateNewButton = CreateFrame("Button", "BGS_Options_CreateNewTracker", BGS_OptionFramesContainer)
	ShowCreateNewButton:SetHitRectInsets(0, 0, 0, 9)
	ShowCreateNewButton:SetNormalTexture("Interface\\BUTTONS\\UI-DialogBox-Button-Up")
	ShowCreateNewButton:SetHighlightTexture("Interface\\BUTTONS\\UI-DialogBox-Button-Highlight")
	ShowCreateNewButton:SetPushedTexture("Interface\\BUTTONS\\UI-DialogBox-Button-Down")
	ShowCreateNewButton:SetHighlightFontObject(GameFontHighlight)
	ShowCreateNewButton:SetPoint("bottomleft", BGS_OptionFramesContainer, "bottomleft", 2, -9)
	ShowCreateNewButton:SetPoint("topright", BGS_OptionFramesContainer, "bottomright", 2, 24)
	-- Something is off with the text
	-- ShowCreateNewButton:SetText("Add New")
	ShowCreateNewButton.text = ShowCreateNewButton:CreateFontString(nil, nil, "GameFontNormal")
	ShowCreateNewButton.text:SetPoint("topleft")
	ShowCreateNewButton.text:SetPoint("bottomright",0, 10)
	ShowCreateNewButton.text:SetText("Add new")
	ShowCreateNewButton:SetScript("OnClick",  function() 
		if {BGS_FramesortBG_Info:GetChildren()} ~= nill	then
				for k, child in ipairs({BGS_FramesortBG_Info:GetChildren()}) do
					child:Hide()
				end
			end
			
			-- Place the info/options of the frame in the info box
					BGS_NewTrackerOptions.frame:SetParent(BGS_FramesortBG_Info)
					BGS_NewTrackerOptions.frame:SetPoint("topleft", BGS_FramesortBG_Info, "topleft", 0, 0)
					BGS_NewTrackerOptions.frame:SetPoint("bottomright", BGS_FramesortBG_Info, "bottomright", 0, 0)
					BGS_NewTrackerOptions.frame:Show()
	end)
	
	
-- Main Scrollcontainer
------------------------------------------------------------------------------------------------------------------------
	
	BGS_OptionDefaultInfo = AceGUI:Create("SimpleGroup")
	BGS_OptionDefaultInfo:SetFullWidth(true)
	BGS_OptionDefaultInfo:SetWidth(185)
	BGS_OptionDefaultInfo:SetFullHeight(true)
	BGS_OptionDefaultInfo:SetHeight(170)
	BGS_OptionDefaultInfo.frame:SetParent(BGS_FramesortBG_Info)
	BGS_OptionDefaultInfo.frame:SetPoint("topleft", BGS_FramesortBG_Info, "topleft", 0, 0)
	BGS_OptionDefaultInfo.frame:SetPoint("bottomright", BGS_FramesortBG_Info, "bottomright", 0, 0)

	local infoEmpty = AceGUI:Create("SimpleGroup")
	infoEmpty:SetLayout("Fill")
	infoEmpty:SetRelativeWidth(0.28)
	infoEmpty:SetHeight(20);
	BGS_OptionDefaultInfo:AddChild(infoEmpty)
	
	local infoShowHide = AceGUI:Create("SimpleGroup")
	infoShowHide:SetLayout("Fill")
	infoShowHide:SetRelativeWidth(0.28)
	infoShowHide.icon1 = infoShowHide.frame:CreateTexture("BGS_Infotext1_Icon1")
	BGS_Infotext1_Icon1:SetTexture("Interface\\LFGFRAME\\BattlenetWorking0")
	BGS_Infotext1_Icon1:SetPoint("topleft", infoShowHide.frame , "topleft",0, 0)
	BGS_Infotext1_Icon1:SetPoint("bottomright", infoShowHide.frame , "topleft",20, -20)
	BGS_Infotext1_Icon1:Show()
	infoShowHide.icon2 = infoShowHide.frame:CreateTexture("BGS_Infotext1_Icon2")
	BGS_Infotext1_Icon2:SetTexture("Interface\\LFGFRAME\\BattlenetWorking4")
	BGS_Infotext1_Icon2:SetPoint("topleft", BGS_Infotext1_Icon1 , "topright",0, 0)
	BGS_Infotext1_Icon2:SetPoint("bottomright", BGS_Infotext1_Icon1 , "topright",20, -20)
	BGS_Infotext1_Icon2:Show()
	infoShowHide.text = infoShowHide.frame:CreateFontString(nil, nil, FontCheckBox)
	infoShowHide.text:SetText("Show or hide track options by clicking the\n eye icon.")
	infoShowHide:SetHeight(infoShowHide.text:GetHeight()+10);
	infoShowHide.text:SetJustifyH("left")
	infoShowHide.text:SetPoint("left", BGS_Infotext1_Icon2,"right", 5, 0)
	BGS_OptionDefaultInfo:AddChild(infoShowHide)
	
	local infoOrder = AceGUI:Create("SimpleGroup")
	infoOrder:SetLayout("Fill")
	infoOrder:SetRelativeWidth(0.28)
	infoOrder.icon1 = infoOrder.frame:CreateTexture("BGS_Infotext2_Icon1")
	BGS_Infotext2_Icon1:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollUp-Up")
	BGS_Infotext2_Icon1:SetPoint("topleft", infoOrder.frame , "topleft",0, 0)
	BGS_Infotext2_Icon1:SetPoint("bottomright", infoOrder.frame , "topleft",20, -20)
	BGS_Infotext2_Icon1:Show()
	infoOrder.icon2 = infoOrder.frame:CreateTexture("BGS_Infotext2_Icon2")
	BGS_Infotext2_Icon2:SetTexture("Interface\\CHATFRAME\\UI-ChatIcon-ScrollDown-Up")
	BGS_Infotext2_Icon2:SetPoint("topleft", BGS_Infotext2_Icon1 , "topright",0, 0)
	BGS_Infotext2_Icon2:SetPoint("bottomright", BGS_Infotext2_Icon1 , "topright",20, -20)
	BGS_Infotext2_Icon2:Show()
	infoOrder.text = infoOrder.frame:CreateFontString(nil, nil, FontCheckBox)
	infoOrder.text:SetText("Change the order of visible track options by\n clicking the arrow buttons.")
	infoOrder:SetHeight(infoOrder.text:GetHeight()+10);
	infoOrder.text:SetJustifyH("left")
	infoOrder.text:SetPoint("left", BGS_Infotext2_Icon2,"right", 5, 0)
	BGS_OptionDefaultInfo:AddChild(infoOrder)
	
	local infoDetail = AceGUI:Create("SimpleGroup")
	infoDetail:SetLayout("Fill")
	infoDetail:SetRelativeWidth(0.28)
	infoDetail.icon1 = infoDetail.frame:CreateTexture("BGS_Infotext3_Icon1")
	BGS_Infotext3_Icon1:SetTexture(0,0,0,0)
	BGS_Infotext3_Icon1:SetPoint("topleft", infoDetail.frame , "topleft",0, 0)
	BGS_Infotext3_Icon1:SetPoint("bottomright", infoDetail.frame , "topleft",20, -20)
	BGS_Infotext3_Icon1:Show()
	infoDetail.icon2 = infoDetail.frame:CreateTexture("BGS_Infotext3_Icon2")
	BGS_Infotext3_Icon2:SetTexture(0,0,0,0)
	BGS_Infotext3_Icon2:SetPoint("topleft", BGS_Infotext3_Icon1 , "topright",0, 0)
	BGS_Infotext3_Icon2:SetPoint("bottomright", BGS_Infotext3_Icon1 , "topright",20, -20)
	BGS_Infotext3_Icon2:Show()
	infoDetail.text = infoDetail.frame:CreateFontString(nil, nil, FontCheckBox)
	infoDetail.text:SetText("Click a track option for options specific to\n that tracker.")
	infoDetail:SetHeight(infoDetail.text:GetHeight()+10);
	infoDetail.text:SetJustifyH("left")
	infoDetail.text:SetPoint("left", BGS_Infotext3_Icon2,"right", 5, 0)
	BGS_OptionDefaultInfo:AddChild(infoDetail)
	
	local infoDelete = AceGUI:Create("SimpleGroup")
	infoDelete:SetLayout("Fill")
	infoDelete:SetRelativeWidth(0.28)
	infoDelete.icon1 = infoDelete.frame:CreateTexture("BGS_InfoDelete_Icon1")
	BGS_InfoDelete_Icon1:SetPoint("topleft", infoDelete.frame , "topleft",0, 0)
	BGS_InfoDelete_Icon1:SetPoint("bottomright", infoDelete.frame , "topleft",20, -20)
	BGS_InfoDelete_Icon1:Show()
	infoDetail.icon2 = infoDetail.frame:CreateTexture("BGS_InfoDelete_Icon2")
	BGS_InfoDelete_Icon2:SetTexture("Interface\\BUTTONS\\CancelButton-Up")
	BGS_InfoDelete_Icon2:SetTexCoord(1/5, 4/5, 1/5, 4/5)
	BGS_InfoDelete_Icon2:SetPoint("topleft", BGS_InfoDelete_Icon1 , "topright",0, 0)
	BGS_InfoDelete_Icon2:SetPoint("bottomright", BGS_InfoDelete_Icon1 , "topright",20, -20)
	BGS_InfoDelete_Icon2:Show()
	infoDelete.text = infoDelete.frame:CreateFontString(nil, nil, FontCheckBox)
	infoDelete.text:SetText("Remove a tracker from the list by going into\n its options and clicking the remove button.")
	infoDelete:SetHeight(infoDelete.text:GetHeight()+10);
	infoDelete.text:SetJustifyH("left")
	infoDelete.text:SetPoint("left", BGS_InfoDelete_Icon2,"right", 5, 0)
	BGS_OptionDefaultInfo:AddChild(infoDelete)
	
	local infoReset = AceGUI:Create("SimpleGroup")
	infoReset:SetLayout("Fill")
	infoReset:SetRelativeWidth(0.28)
	infoReset.icon1 = infoReset.frame:CreateTexture("BGS_Infotext4_Icon1")
	BGS_Infotext4_Icon1:SetTexture(0,0,0,0)
	BGS_Infotext4_Icon1:SetPoint("topleft", infoReset.frame , "topleft",0, 0)
	BGS_Infotext4_Icon1:SetPoint("bottomright", infoReset.frame , "topleft",20, -20)
	BGS_Infotext4_Icon1:Show()
	infoReset.icon2 = infoReset.frame:CreateTexture("BGS_Infotext4_Icon2")
	BGS_Infotext4_Icon2:SetTexture(0,0,0,0)
	BGS_Infotext4_Icon2:SetPoint("topleft", BGS_Infotext4_Icon1 , "topright",0, 0)
	BGS_Infotext4_Icon2:SetPoint("bottomright", BGS_Infotext4_Icon1 , "topright",20, -20)
	BGS_Infotext4_Icon2:Show()
	infoReset.text = infoReset.frame:CreateFontString(nil, nil, FontCheckBox)
	infoReset.text:SetText("Click the button on the top right to go back\n to this information.")
	infoReset:SetHeight(infoReset.text:GetHeight()+10);
	infoReset.text:SetJustifyH("left")
	infoReset.text:SetPoint("left", BGS_Infotext4_Icon2,"right", 5, 0)
	BGS_OptionDefaultInfo:AddChild(infoReset)
	
	local L_trackerInfoInfoButton = CreateFrame("Button", "BGS_trackerInfoInfoButton", BGS_OptionFramesContainerBG)
	BGS_trackerInfoInfoButton:SetWidth(20)
	BGS_trackerInfoInfoButton:SetHeight(20)
	BGS_trackerInfoInfoButton:SetHitRectInsets(4, 4, 4, 4)
	BGS_trackerInfoInfoButton:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Up")
	BGS_trackerInfoInfoButton:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Highlight")
	BGS_trackerInfoInfoButton:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Down")
	BGS_trackerInfoInfoButton:SetPoint("topright", OptionFramesBG.topright, "topright", -20, -1)
	BGS_trackerInfoInfoButton:Show()
	BGS_trackerInfoInfoButton:SetScript("OnClick",  function() 
		if {BGS_FramesortBG_Info:GetChildren()} ~= nill	then
				for k, child in ipairs({BGS_FramesortBG_Info:GetChildren()}) do
					child:Hide()
				end
			end
			
			-- Place the info/options of the frame in the info box
					BGS_OptionDefaultInfo.frame:SetParent(BGS_FramesortBG_Info)
					BGS_OptionDefaultInfo.frame:SetPoint("topleft", BGS_FramesortBG_Info, "topleft", 0, 0)
					BGS_OptionDefaultInfo.frame:SetPoint("bottomright", BGS_FramesortBG_Info, "bottomright", 0, 0)
					BGS_OptionDefaultInfo.frame:Show()
					BGS_FramesortBG_Info.text:SetText("Track Options")
			
	end)
	
	BGS_trackerInfoInfoButton:SetScript("OnEnter",  function(self) 
		BGS_TrackerClasses.tooltip:ShowTooltip(self, "Display information.")
	end)
	BGS_trackerInfoInfoButton:SetScript("OnLeave",  function() 
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)
	
	
	
	
	
	--[[
	local infoShowHide = AceGUI:Create("SimpleGroup")
	infoShowHide:SetLayout("Fill")
	infoShowHide:SetRelativeWidth(0.28)
	infoShowHide.icon1 = infoShowHide.frame:CreateTexture("BGS_Infotext1_Icon1")
	BGS_Infotext1_Icon1:SetTexture("Interface\\LFGFRAME\\BattlenetWorking0")
	BGS_Infotext1_Icon1:SetPoint("topleft", infoShowHide.frame , "topleft",0, 0)
	BGS_Infotext1_Icon1:SetPoint("bottomright", infoShowHide.frame , "topleft",20, -20)
	BGS_Infotext1_Icon1:Show()
	infoShowHide.icon2 = infoShowHide.frame:CreateTexture("BGS_Infotext1_Icon2")
	BGS_Infotext1_Icon2:SetTexture("Interface\\LFGFRAME\\BattlenetWorking4")
	BGS_Infotext1_Icon2:SetPoint("topleft", BGS_Infotext1_Icon1 , "topright",0, 0)
	BGS_Infotext1_Icon2:SetPoint("bottomright", BGS_Infotext1_Icon1 , "topright",20, -20)
	BGS_Infotext1_Icon2:Show()
	infoShowHide.text = infoShowHide.frame:CreateFontString(nil, nil, FontCheckBox)
	infoShowHide.text:SetText("Show or hide track options by clicking the\n eye icon.")
	infoShowHide:SetHeight(infoShowHide.text:GetHeight()+10);
	infoShowHide.text:SetJustifyH("left")
	infoShowHide.text:SetPoint("left", BGS_Infotext1_Icon2,"right", 5, 0)
	BGS_NewTrackerOptions:AddChild(infoShowHide)
	]]--
	--[[
	
	Want to add at some point in the future.
	Need a way to change the size of ACEGUI scrollframes.
	
	local L_BGS_OptionFramesContainerBtn = CreateFrame("Button", "BGS_OptionFramesContainerBtn", BGS_OptionFramesContainerBG)
	BGS_OptionFramesContainerBtn:SetWidth(25)
	BGS_OptionFramesContainerBtn:SetHeight(25)
	BGS_OptionFramesContainerBtn:SetHitRectInsets(4, 4, 4, 4)
	BGS_OptionFramesContainerBtn:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Up")
	BGS_OptionFramesContainerBtn:SetHighlightTexture("Interface\\BUTTONS\\UI-Panel-MinimizeButton-Highlight")
	BGS_OptionFramesContainerBtn:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Down")
	BGS_OptionFramesContainerBtn:SetPoint("left", BGS_OptionFramesContainerBG.title, "right", 0, 0)
	BGS_OptionFramesContainerBtn:Show()
	BGS_OptionFramesContainerBtn:SetScript("OnClick",  function() 
		if L_BGS_OptionFramesContainer:IsShown() then
			BGS_OptionFramesContainerBtn:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-ExpandButton-Up")
			BGS_OptionFramesContainerBtn:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-ExpandButton-Down")
			BGS_OptionFramesContainer:Hide()
			BGS_FramesortBG_Info:Hide()
			BGS_OptionFramesContainerBG:SetHeight(64)
		else
			BGS_OptionFramesContainerBtn:SetNormalTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Up")
			BGS_OptionFramesContainerBtn:SetPushedTexture("Interface\\BUTTONS\\UI-Panel-CollapseButton-Down")
			BGS_OptionFramesContainer:Show()
			BGS_FramesortBG_Info:Show()
			BGS_OptionFramesContainerBG:SetHeight(340)
		end
		L_BGS_ListsGroup:SetHeight(BGS_OptionFramesContainerBG:GetHeight())
	end)
]]--



local L_BGS_MiscGroup = AceGUI:Create("SimpleGroup")
	L_BGS_MiscGroup:SetFullWidth(true)
	L_BGS_MiscGroup:SetHeight(35)
	L_BGS_MiscGroup:SetLayout("Fill")
	Options_MainScroller:AddChild(L_BGS_MiscGroup)
	
	local MiscOptionBG = CreateOptionsContainer("MiscContainer", L_BGS_MiscGroup, 150, "Misc Options")

	L_BGS_MiscGroup:SetHeight(MiscOptionBG:GetHeight())
	
	local BGS_MiscContainerInner = AceGUI:Create("SimpleGroup")
	BGS_MiscContainerInner:SetFullWidth(true)
	BGS_MiscContainerInner:SetWidth(185)
	BGS_MiscContainerInner:SetFullHeight(true)
	BGS_MiscContainerInner:SetHeight(170)
	BGS_MiscContainerInner:SetLayout("Flow")
	BGS_MiscContainerInner.frame:SetParent(MiscOptionBG)
	BGS_MiscContainerInner.frame:SetPoint("topleft", MiscOptionBG.topleft, "topleft", 20, -27)
	BGS_MiscContainerInner.frame:SetPoint("bottomright", MiscOptionBG.bottomright, "bottomright", -28, 25)


-- Background Dropdown
------------------------------------------------------------------------------------------------------------------------
	local ddwn_Background_Container = AceGUI:Create("SimpleGroup")
	--ddwn_Background_Container:SetRelativeWidth(1)
	ddwn_Background_Container:SetRelativeWidth(0.35)
	BGS_MiscContainerInner:AddChild(ddwn_Background_Container)
	
	ddwn_Background = AceGUI:Create("Dropdown")
	ddwn_Background:SetWidth(150)
	ddwn_Background:SetList(BGTable.options, BGTable.order)
	ddwn_Background:SetLabel("Background")
	ddwn_Background:SetCallback("OnValueChanged", function(_,_, choise)
		ChangeBG(choise)
	end)
	ddwn_Background_Container:AddChild(ddwn_Background)

-- Column Slider
------------------------------------------------------------------------------------------------------------------------

	L_BGS_SLColumns = AceGUI:Create("Slider")
	--L_BGS_CBHideTitle:SetFullWidth(true)
	L_BGS_SLColumns:SetRelativeWidth(0.35)
	L_BGS_SLColumns:SetLabel("Number of columns")
	L_BGS_SLColumns:SetSliderValues(1, table.getn(BGS_TrackerClasses) , 1)
	L_BGS_SLColumns:SetValue(_TrackColumns)
	L_BGS_SLColumns:SetCallback("OnValueChanged", function(value)
		_TrackColumns = L_BGS_SLColumns:GetValue()
		BGS_TrackerClasses:TrackFramePos()
	end)
	BGS_MiscContainerInner:AddChild(L_BGS_SLColumns)
	
	L_BGS_SLColumns:SetCallback("OnEnter", function(self, _, value)
		BGS_TrackerClasses.tooltip:ShowTooltip(self.frame, "Choose the amount of colums the stacker frame has.\nThe max size is determined by the amount of visible trackers.")
	end)
	L_BGS_SLColumns:SetCallback("OnLeave", function(_, _, value)
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)
	
	
	local cont_CHrow = AceGUI:Create("SimpleGroup")
	--ddwn_Background_Container:SetRelativeWidth(1)
	cont_CHrow:SetLayout("Flow")
	cont_CHrow:SetFullWidth(true)
	BGS_MiscContainerInner:AddChild(cont_CHrow)
	
-- Show Borders Checkbox
------------------------------------------------------------------------------------------------------------------------
	L_BGS_CBBorders = AceGUI:Create("CheckBox")
	--L_BGS_CBHideTitle:SetFullWidth(true)
	L_BGS_CBBorders:SetRelativeWidth(0.3)
	L_BGS_CBBorders:SetValue(true)
	L_BGS_CBBorders:SetLabel("Borders in options")
	L_BGS_CBBorders:SetCallback("OnValueChanged", function(_, _, value)
		ShowTrackerBorders(value)
	end)
	L_BGS_CBBorders:SetCallback("OnEnter", function(self, _, value)
		BGS_TrackerClasses.tooltip:ShowTooltip(self.frame, "While the options are open, show borders around the trackers to see their sizes.")
	end)
	L_BGS_CBBorders:SetCallback("OnLeave", function(_, _, value)
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)
	
	
	
	BGOptions.CBBorders = L_BGS_CBBorders
	cont_CHrow:AddChild(L_BGS_CBBorders)

	
-- Hide Icons Checkbox
------------------------------------------------------------------------------------------------------------------------
	L_BGS_CBHideIcons = AceGUI:Create("CheckBox")
	--L_BGS_CBHideIcons:SetFullWidth(true)
	--L_BGS_CBHideIcons:SetRelativeWidth(1)
	cont_CHrow:AddChild(L_BGS_CBHideIcons)
	L_BGS_CBHideIcons:SetRelativeWidth(0.25)
	L_BGS_CBHideIcons:SetLabel("Show Icons")
	L_BGS_CBHideIcons:SetCallback("OnValueChanged", function(value)
		if L_BGS_CBHideIcons:GetValue() then
			PlaySound("igMainMenuOptionCheckBoxOn");
			for k, v in ipairs(TestClasses) do 
				v.frame.text:SetPoint("left", DEFAULT_TRACKOFFSET_WITH, 0)
				if v.visipos > 0 then
					v.frame.icon:Show()
				end
			end
		else
			PlaySound("igMainMenuOptionCheckBoxOff");
			for k, v in ipairs(TestClasses) do 
				v.frame.text:SetPoint("left", DEFAULT_TRACKOFFSET_WITHOUT, 0)
				v.frame.icon:Hide()
			end
		end
	end)
	
	L_BGS_CBHideIcons:SetCallback("OnEnter", function(self, _, value)
		BGS_TrackerClasses.tooltip:ShowTooltip(self.frame, "Show or hide the icons on the trackers.")
	end)
	L_BGS_CBHideIcons:SetCallback("OnLeave", function(_, _, value)
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)
	
	

-- Hide Title Checkbox
------------------------------------------------------------------------------------------------------------------------
	L_BGS_CBHideTitle = AceGUI:Create("CheckBox")
	--L_BGS_CBHideTitle:SetFullWidth(true)
	--L_BGS_CBHideTitle:SetRelativeWidth(1)
	cont_CHrow:AddChild(L_BGS_CBHideTitle)
	L_BGS_CBHideTitle:SetRelativeWidth(0.4)
	L_BGS_CBHideTitle:SetLabel("Show title and buttons")
	L_BGS_CBHideTitle:SetCallback("OnValueChanged", function(_,_,value)
		if  (value) then
			BGS_FrameTitle:Show()
		else
			BGS_FrameTitle:Hide()
		end
		BGS_TrackerClasses:TrackFramePos()
	end)
	
	L_BGS_CBHideTitle:SetCallback("OnEnter", function(self, _, value)
		BGS_TrackerClasses.tooltip:ShowTooltip(self.frame, "Show or hide the title and buttons on the top of the tracker frame.")
	end)
	L_BGS_CBHideTitle:SetCallback("OnLeave", function(_, _, value)
		BGS_TrackerClasses.tooltip:HideTooltip()
	end)
	
	
-- Anchor checkbox
------------------------------------------------------------------------------------------------------------------------
	--[[
	
	L_BGS_CBAnchor = AceGUI:Create("CheckBox")
	--L_BGS_CBHideTitle:SetFullWidth(true)
	--L_BGS_CBHideTitle:SetRelativeWidth(1)
	BGS_MiscContainerInner:AddChild(L_BGS_CBAnchor)
	L_BGS_CBAnchor:SetRelativeWidth(0.3)
	L_BGS_CBAnchor:SetLabel("Anchor to frame")
	L_BGS_CBAnchor:SetCallback("OnValueChanged", function(_,_,value)
		--if  (value) then
		--	BGS_FrameTitle:Show()
		--else
		--	BGS_FrameTitle:Hide()
		--end
		--BGS_TrackerClasses:TrackFramePos()
	end)
		


	

-- Anchor target textbox
------------------------------------------------------------------------------------------------------------------------
	L_BGS_TXTAnchorto = AceGUI:Create("EditBox")
	BGS_MiscContainerInner:AddChild(L_BGS_TXTAnchorto)
	L_BGS_TXTAnchorto:SetLabel("Other")
	L_BGS_TXTAnchorto:SetText("")
	--txt_Input:SetFullWidth(true)
	L_BGS_TXTAnchorto:SetRelativeWidth(0.3)
	L_BGS_TXTAnchorto:SetCallback("OnTextChanged", function(__,__, value)
		--_baseString = value
		--print(value)
		--updateKeyString()
	end)
	
	
	]]--
	
-- Frame Info Box
------------------------------------------------------------------------------------------------------------------------
	local L_BGS_WinrateGroup = AceGUI:Create("SimpleGroup")
	L_BGS_WinrateGroup:SetFullWidth(true)
	L_BGS_WinrateGroup:SetHeight(35)
	L_BGS_WinrateGroup:SetLayout("Fill")
	Options_MainScroller:AddChild(L_BGS_WinrateGroup)
	
	local WinRatesBG = CreateOptionsContainer("MiscContainer", L_BGS_WinrateGroup, 500, "Win Rates")

	L_BGS_WinrateGroup:SetHeight(WinRatesBG:GetHeight())

	local WinrateScrollContainer = AceGUI:Create("SimpleGroup")
	WinrateScrollContainer:SetFullWidth(true)
	WinrateScrollContainer:SetFullHeight(true)
	WinrateScrollContainer:SetLayout("Fill")
	WinrateScrollContainer.frame:SetParent(L_BGS_WinrateBox)
	WinrateScrollContainer.frame:SetPoint("topleft", 10, -6)
	WinrateScrollContainer.frame:SetPoint("bottomright", -6, 5)
	WinrateScrollContainer.frame:SetParent(WinRatesBG)
	WinrateScrollContainer.frame:SetPoint("topleft", WinRatesBG.topleft, "topleft", 20, -27)
	WinrateScrollContainer.frame:SetPoint("bottomright", WinRatesBG.bottomright, "bottomright", -28, 25)

	_WinrateScroller = AceGUI:Create("SimpleGroup")
	_WinrateScroller:SetLayout("Flow")
	WinrateScrollContainer:AddChild(_WinrateScroller)
	
	for k, bg in ipairs(_battlefieldInfo) do
		local WinrateTextContainer = AceGUI:Create("SimpleGroup")
		
		
		if bg.isHeader then 
		WinrateTextContainer:SetLayout("Fill")
		WinrateTextContainer.text = WinrateTextContainer.frame:CreateFontString(nil, nil, FontCheckBox)
			WinrateTextContainer:SetRelativeWidth(1)
			WinrateTextContainer.text:SetText("|cFFFFD100".. bg.name ..":|r " ..BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "full", bg.isRated))
			WinrateTextContainer.text:SetJustifyH("center")
			WinrateTextContainer:SetHeight(WinrateTextContainer.text:GetHeight()*2);
			--WinrateTextContainer.text:SetJustifyH("left")
			WinrateTextContainer.text:SetPoint("topleft", 5, 0)
			WinrateTextContainer.text:SetPoint("bottomright", -5, 0)
			WinrateTextContainer.bg = WinrateTextContainer.frame:CreateTexture(bg.name.."_bg", "BACKGROUND")
			
			WinrateTextContainer.bg:SetTexture("Interface\\PLAYERACTIONBARALT\\STONE")
			WinrateTextContainer.bg:SetTexCoord(0, 1, 89/512, 183/512)
			WinrateTextContainer.bg:SetPoint("topleft", WinrateTextContainer.frame, "topleft", 100,0)
			WinrateTextContainer.bg:SetPoint("bottomright", WinrateTextContainer.frame, "bottomright", -100,0)
			WinrateTextContainer.left = WinrateTextContainer.frame:CreateTexture(bg.name.."_bg_left", "BACKGROUND")
			
			WinrateTextContainer.left:SetTexture("Interface\\PLAYERACTIONBARALT\\STONE")
			WinrateTextContainer.left:SetTexCoord(0, 155/512, 408/512, 510/512)
			WinrateTextContainer.left:SetWidth(75)
			local layer, sublayer = WinrateTextContainer.bg:GetDrawLayer()
			WinrateTextContainer.left:SetDrawLayer(layer, sublayer + 1)
			WinrateTextContainer.left:SetHeight(WinrateTextContainer.frame:GetHeight())
			WinrateTextContainer.left:SetPoint("right", WinrateTextContainer.bg, "left", 15,0)
			
			WinrateTextContainer.right = WinrateTextContainer.frame:CreateTexture(bg.name.."_bg_right", "BACKGROUND")
			WinrateTextContainer.right:SetTexture("Interface\\PLAYERACTIONBARALT\\STONE")
			WinrateTextContainer.right:SetTexCoord(155/512, 0, 408/512, 510/512)
			WinrateTextContainer.right:SetWidth(75)
			WinrateTextContainer.right:SetDrawLayer(layer, sublayer + 1)
			WinrateTextContainer.right:SetHeight(WinrateTextContainer.frame:GetHeight())
			WinrateTextContainer.right:SetPoint("left", WinrateTextContainer.bg, "right", -15,0)
			
			WinrateTextContainer.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
			WinrateTextContainer.frame:SetScript("OnEvent", function() WinrateTextContainer.text:SetText("|cFFFFD100".. bg.name ..":|r " ..BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "full", bg.isRated)) end)
			
			_WinrateScroller:AddChild(WinrateTextContainer)
		else
			
		WinrateTextContainer:SetLayout("Fill")
		WinrateTextContainer.text = WinrateTextContainer.frame:CreateFontString(nil, nil, FontCheckBox)
			WinrateTextContainer:SetRelativeWidth(0.28)
		WinrateTextContainer.text:SetText("|cFFFFD100".. bg.name ..":|r\n " ..BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "full", bg.isRated))
			WinrateTextContainer:SetHeight(WinrateTextContainer.text:GetHeight()+5);
			WinrateTextContainer.text:SetJustifyH("left")
			WinrateTextContainer.text:SetPoint("topleft", 5, 0)
			bg.frame = WinrateTextContainer
			
			WinrateTextContainer.frame:RegisterEvent("PLAYER_ENTERING_WORLD");
			WinrateTextContainer.frame:SetScript("OnEvent", function() WinrateTextContainer.text:SetText("|cFFFFD100".. bg.name ..":|r\n " ..BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "full", bg.isRated)) end)
		
			local WinrateIcon = AceGUI:Create("Icon")
			WinrateIcon:SetImage(bg.icon)
			WinrateIcon:SetImageSize(23, 23)
			WinrateIcon:SetWidth(23)
			_WinrateScroller:AddChild(WinrateIcon)
			_WinrateScroller:AddChild(WinrateTextContainer)
		end
		
		
		WinrateOptionsTable[#WinrateOptionsTable+1] = WinrateTextContainer --save for updating
	end

	
end

local function Firstrun()
	for k, v in ipairs(BGS_TrackerClasses)do
		CreateTrackerOfType(v.fType, v.fType)
	end
	
	for k, v in ipairs(TestClasses) do
		v.visipos = 0
	end
	
	BGS_firstrunInfo:Show()
	
	-- Movable
	SetShowMainframe(true)
	BGStatFrame:EnableMouse(true)
	BGStatFrame:SetPoint("center", UIParent, "center", 200, 0)
	BGStatFrame:Show()
	
	BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
	BGStatFrame:SetBackdrop({
		bgFile = mainBGBack,
		edgeFile = "Interface//DialogFrame//UI-DialogBox-Border",
		tileSize = 0, edgeSize = 16,
		insets = { left = 3, right = 3, top = 3, bottom = 3 }
	})

	ChangeBG(mainBGBack)
	ddwn_Background:SetValue(mainBGBack)

	L_BGS_CBHideIcons:SetValue(true)
	L_BGS_CBHideTitle:SetValue(true)
end

local function RenameOldSave(name)
	
	for k, v in ipairs(BGS_TrackerClasses) do
		if v[2] == name then
			return v[1]
		end
	end
	
	return "error"
end

function BGS_TrackerClasses:GetInfoList(name)
	for k,v in ipairs(ExtraDataList) do
		if v.frame == name then
			return v
		end
	end
	return nil
end

local function GetOldVisipos(name, save)
	for k, v in pairs(save.ShownFrames) do
		if v.name == name then
			return v.pos
		end
	end
	
	return 0
end

local function OldPerFrame(save, extra)
	local visipos = GetOldVisipos(extra.frame, save)
	local newTable = {}

	local name = ""
	if extra.frame == "AccKillsFrame" then
		name = "Account Kills"
	elseif extra.frame == "AchFrame" then
		name = "Achievement"
	elseif extra.frame == "FragmentFrame" then
		name = "Atrifact Fragments"
	elseif extra.frame == "XPFrame" then
		name = "BG Experience"
	elseif extra.frame == "ScoreFrame" then
		name = "Scoreboard"
	elseif extra.frame == "KillsFrame" then
		name = "Honorable Kills"
	elseif extra.frame == "TBFrame" then
		name = "Tol Barad"
	elseif extra.frame == "ConquestFrame" then
		name = "Conquest Points"
	elseif extra.frame == "SessionFrame" then
		name = "Current Session"
		newTable.wins, newTable.losses = string.match(extra.text, '(%d+) : (%d+)')
		newTable.logoutTime = extra.logTime
		newTable.timestamp = extra.timestamp
		newTable.autoReset = extra.autoReset
	elseif extra.frame == "Custom" then
		name = "Custom"
		newTable.baseString = extra.baseString
	elseif extra.frame == "GarrisonFrame" then
		name = "Garrison Resources"
	elseif extra.frame == "HonorFrame" then
		name = "Honor Points"
	end
	newTable.name = name
	newTable.type = name
	newTable.visipos = visipos
	newTable.colSpan = extra.colSpan
	newTable.justify = extra.justify
	return newTable
end

local function ConvertOldSave(savedata, extra)
	local tempTable = {}
	
	-- Add trackers actually visible
	for k, v in ipairs(extra) do
		table.insert(tempTable, OldPerFrame(savedata, v))
	end

	
	return tempTable
end

local function CommonRun(savedata, extra)

	local tempSavedData = savedata
	ChangeBG(tempSavedData.MainframeBackground) 
	SetShowMainframe(tempSavedData.MainframeIsShown)
	
	_TrackColumns = tempSavedData.TrackColumns
	if _TrackColumns == nil then
		_TrackColumns = 1
	end
	L_BGS_SLColumns:SetValue(_TrackColumns)
	
	for  id, save in ipairs(extra) do 
		CreateTrackerOfType(save.type, nil, save)
	end
	
	if tempSavedData.MainframeIsMoveable then
		BGStatFrame:EnableMouse(true)
		BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
		BGS_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
	else
		BGStatFrame:EnableMouse(false)
		BGS_LockButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF )
		BGS_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF )
	end
	UpdateMainFrameBG()
	if tempSavedData.TitleHidden ~= nil and tempSavedData.TitleHidden == true then
		L_BGS_CBHideTitle:SetValue(true)
		BGS_FrameTitle:Show()
	else
		L_BGS_CBHideTitle:SetValue(false)
		BGS_FrameTitle:Hide()
	end
	
	if tempSavedData.IconsHidden ~= nil and tempSavedData.IconsHidden == true then
		L_BGS_CBHideIcons:SetValue(true)
		for k, v in ipairs(TestClasses) do 
			v.frame.icon:Show()
			v.frame.text:SetPoint("left", DEFAULT_TRACKOFFSET_WITH, 0)
		end
	else
		L_BGS_CBHideIcons:SetValue(false)
		for k, v in ipairs(TestClasses) do 
			v.frame.icon:Hide()
			v.frame.text:SetPoint("left", DEFAULT_TRACKOFFSET_WITHOUT, 0)
		end	
		
	end

	ddwn_Background:SetValue(tempSavedData.MainframeBackground)
	
	if extra ~= nil then
	ExtraDataList = extra
	
	
	end
	
end


	
local L_BGS_LoadFrame = CreateFrame("FRAME", "BGS_LoadFrame"); 
BGS_LoadFrame:RegisterEvent("PLAYER_ENTERING_WORLD");
BGS_LoadFrame:RegisterEvent("ADDON_LOADED");
BGS_LoadFrame:RegisterEvent("PLAYER_LOGOUT");
BGS_LoadFrame:RegisterEvent("PLAYER_LOGIN");
BGS_LoadFrame:RegisterEvent("NEUTRAL_FACTION_SELECT_RESULT");
BGS_LoadFrame:SetScript("OnEvent", function(self, event, ...) self[event](self, ...) end)

function BGS_LoadFrame:NEUTRAL_FACTION_SELECT_RESULT(loadedAddon)
	UpdateFactionIcon()
end

function BGS_LoadFrame:PLAYER_ENTERING_WORLD(loadedAddon)
	UpdateWinrate()
end

function BGS_LoadFrame:ADDON_LOADED(loadedAddon)
	if loadedAddon ~= addonName then return end
	self:UnregisterEvent("ADDON_LOADED")
	_CreateBaseFrame()

	self.ADDON_LOADED = nil
end


function BGS_LoadFrame:PLAYER_LOGIN(loadedAddon)

	_CreateOptionsFrames()

	for i=0, table.getn(DefaultFrames) do
		--HideFrame(i+1)
	end
	
	local savedata = BGstats_BaseDataList
	local extra = BGstats_ExtraFrameDataList
	
	if savedata == nil or savedata == {} then -- either no data or old data
		Firstrun()                                                                                                                             
	else
		if savedata.Version < "6.1.02" then
			extra = ConvertOldSave(savedata, extra)  
		end
		-- for k1, v1 in pairs(tempTable) do
		-- for k, v in pairs(v1) do
			-- if	type(v) == "boolean" then
				-- print(k .. " - " .. (v and 1 or 0))
			-- else
				-- print(k .. " - " .. v)
			-- end
			
		-- end		
	-- end
		CommonRun(savedata, extra)
	end
	
	FixOptionFrames()
	InterfaceOptions_AddCategory(BGS_Option)
	
	BGstats_ExtraFrameDataList = {}
	
end

function BGS_LoadFrame:PLAYER_LOGOUT(loadedAddon)
    
	local tempSaveData = {}
	tempSaveData.MainframeIsShown = BGStatFrame:IsShown()
	tempSaveData.MainframeIsMoveable = BGStatFrame:IsMouseEnabled()
	tempSaveData.MainframeBackground = ActiveBG
	tempSaveData.TitleHidden = L_BGS_CBHideTitle:GetValue()
	tempSaveData.IconsHidden = L_BGS_CBHideIcons:GetValue()
	tempSaveData.TrackColumns = _TrackColumns
	tempSaveData.Version = versionNr
	
	-- Saving winrates
	local winrates = {}
	winrates.battleground = {}
	winrates.arena = {}
	winrates.ratedbattleground = {}
	for k, bg in ipairs(_battlefieldInfo) do
		local winrate = {}
		if bg.isHeader then
			winrate.name = "total"
		else
			winrate.name = bg.name
		end
			winrate.wins = BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "wins", bg.isRated)
			winrate.losses = BGS_TrackerClasses:BGS_GetWinrateString(bg.name, "losses", bg.isRated)
		
		if bg.instanceType == "arena"then
			table.insert(winrates.arena, winrate)
		else
			if bg.isRated then
				table.insert(winrates.ratedbattleground, winrate)
			else
				table.insert(winrates.battleground, winrate)
			end
		end
	end
	tempSaveData.winrates = winrates
	
	
	
	local tempTable = {}
	
	for id, tracker in ipairs(TestClasses) do 
		table.insert(tempTable, tracker:GetSave())
	end
	
	BGstats_ExtraFrameDataList = tempTable
	
	BGstats_BaseDataList = tempSaveData
	
end


----------------------------------------
-- Slash Commands
----------------------------------------

SLASH_PVPSTATS1 = '/bgstats';
local function slashcmd(msg, editbox)
	if msg == 'hide' then
		SetShowMainframe(false)
	elseif msg == 'show' then
		SetShowMainframe(true)
	elseif msg == 'lock' then
		ToggleLockbutton()
	else
		if ( not InterfaceOptionsFramePanelContainer.displayedPanel ) then
			InterfaceOptionsFrame_OpenToCategory(CONTROLS_LABEL);
		end
		InterfaceOptionsFrame_OpenToCategory(addonName) 
		
	  
   end
end
SlashCmdList["PVPSTATS"] = slashcmd





-- Debug help
----------------------------------------------
--[[
local _updateTimer = 0

function debug_updatext()
	local text = ""
	
	--counters
	text = text .. "created: " .. _CreatedFrameCounter .. " alive " .. #TestClasses .. "\n"
	
	--trackers
	for k, v in ipairs(TestClasses)do
		text = text .. v.detail .. " " .. v.visipos .. " " .. v.frameNr .. "\n"
		text = text .. v.name .. "\n" .. "\n"
		
	end
	
	BGS_DEBUG.text:SetText(text)
end

local L_BGS_DEBUG = CreateFrame("frame", "BGS_DEBUG", UIParent)
local function UpdateMainFrameBG()
	if BGS_DEBUG:IsMouseEnabled() then
		mainEdgefile = DEFAULT_EDGEFILE
	else
		mainEdgefile = nill
	end
	BGS_DEBUG:SetBackdrop({bgFile = DEFAULT_BG,
      edgeFile = mainEdgefile,
	  tileSize = 0, edgeSize = 16,
      insets = { left = 3, right = 3, top = 3, bottom = 3 }
	  })
end
	 UpdateMainFrameBG()

BGS_DEBUG:SetFrameLevel(5)
BGS_DEBUG:SetMovable(true)
BGS_DEBUG:SetPoint("Center", 250, 0)
BGS_DEBUG:RegisterForDrag("LeftButton")
BGS_DEBUG:SetScript("OnDragStart", BGS_DEBUG.StartMoving )
BGS_DEBUG:SetScript("OnDragStop", BGS_DEBUG.StopMovingOrSizing)
BGS_DEBUG.text = BGS_DEBUG:CreateFontString(nil, nil, "GameFontNormal")
BGS_DEBUG.text:SetPoint("topleft", 10, -10)
BGS_DEBUG.text:SetJustifyH("left")
BGS_DEBUG:SetWidth(65)
BGS_DEBUG:SetHeight(BGS_DEBUG.text:GetStringHeight()+20)
BGS_DEBUG:SetClampedToScreen(true)
BGS_DEBUG:SetScript("OnUpdate", function(self,elapsed) 
	_updateTimer = _updateTimer + elapsed
	if _updateTimer >= 0.5 then
		debug_updatext()
		_updateTimer = 0
	end
	end)
BGS_DEBUG:Show()

local function DebugToggleLockbutton() 
	if BGS_DEBUG:IsMouseEnabled() then
		BGS_DEBUG_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF, DEFAULT_LOCKVERTEX_OFF )
		PlaySound("igMainMenuOptionCheckBoxOff");
		BGS_DEBUG:EnableMouse(false)
			
	else	
		BGS_DEBUG_MoveButton.tex:SetVertexColor(DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON, DEFAULT_LOCKVERTEX_ON )
		PlaySound("igMainMenuOptionCheckBoxOn");
		BGS_DEBUG:EnableMouse(true)
			
	end
		UpdateMainFrameBG()
end

local L_BGS_DEBUG_MoveButton = CreateFrame("Button", "BGS_DEBUG_MoveButton", BGS_DEBUG)
BGS_DEBUG_MoveButton:SetWidth(8)
BGS_DEBUG_MoveButton:SetHeight(8)
BGS_DEBUG_MoveButton.tex = BGS_DEBUG_MoveButton:CreateTexture("BGS_DEBUG_MoveButton_Tex")
BGS_DEBUG_MoveButton.tex:SetTexture("Interface\\COMMON\\UI-ModelControlPanel")
BGS_DEBUG_MoveButton.tex:SetPoint("topleft", BGS_DEBUG, "topleft", 5, -5)
BGS_DEBUG_MoveButton.tex:SetTexCoord(18/64, 36/64, 37/128, 53/128)
BGS_DEBUG_MoveButton.tex:SetSize(8,8)
BGS_DEBUG_MoveButton.tex:SetVertexColor(.8, .8, .8 ) 

BGS_DEBUG_MoveButton:SetPoint("topleft", BGS_DEBUG, "topleft", 5, -5)
BGS_DEBUG_MoveButton:Show()

BGS_DEBUG_MoveButton:SetScript("OnClick",  function() 
	DebugToggleLockbutton()
	
end)
BGS_DEBUG_MoveButton:SetScript("OnEnter",  function() 
	BGS_DEBUG_MoveButton.tex:SetVertexColor(1, 1, 1 )
	
end)
]]--