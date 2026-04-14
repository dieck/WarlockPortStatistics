local L = LibStub("AceLocale-3.0"):GetLocale("WarlockPortStatistics", true)

local defaults = {
  factionrealm = {
    enabled = true,
    debug = false,
	trackpayment = true,
	guildforfree = true,
	partyforfree = true,
	paymentreminderSelf = true,
	paymentreminderSelfSec = 60,
	paymentreminderCustomer = false,
	paymentreminderCustomerSec = 60,
	paymentreminderCustomerText = "The ritual is complete and your passage through the shadows is secured. If not settled already, kindly trade the fee once you have arrived. Appreciate it!",
	debugSpellId = 5740,
  }
}

WarlockPortStatistics.wpsOptionsTable = {
  type = "group",
  args = {
    hdr_settings = { name="Settings", type="header", order=9 },

	enable = {
      name = "Enabled",
      desc = "Enables tracking of ports",
      type = "toggle",
	  order = 10,
      set = function(info,val) WarlockPortStatistics.db.factionrealm.enabled = val end,
      get = function(info) return WarlockPortStatistics.db.factionrealm.enabled end,
    },
	newline11 = { name="", type="description", order=11 },

    hdr_settings = { name="Payment tracking", type="header", order=19 },

    trackpayment = {
      name = "Track Payments",
      desc = "Enables tracking of payments (trades)",
      type = "toggle",
	  order = 20,
      set = function(info,val) WarlockPortStatistics.db.factionrealm.trackpayment = val end,
      get = function(info) return WarlockPortStatistics.db.factionrealm.trackpayment end,
    },
	newline22 = { name="", type="description", order=22 },
    guildforfree = {
      name = "Free for Guild",
      desc = "Consider ports for Guild as paid",
      type = "toggle",
	  order = 23,
      set = function(info,val) WarlockPortStatistics.db.factionrealm.guildforfree = val end,
      get = function(info) return WarlockPortStatistics.db.factionrealm.guildforfree end,
    },
    partyforfree = {
      name = "Party for free",
      desc = "Consider ports for Parties (not Raid) as paid",
      type = "toggle",
	  order = 24,
      set = function(info,val) WarlockPortStatistics.db.factionrealm.partyforfree = val end,
      get = function(info) return WarlockPortStatistics.db.factionrealm.partyforfree end,
    },
	newline25 = { name="", type="description", order=25 },

    paymentreminderSelf = {
      name = "Collect Reminder",
      desc = "Reminds you to collect payment",
      type = "toggle",
	  order = 30,
      set = function(info,val) WarlockPortStatistics.db.factionrealm.paymentreminderSelf = val end,
      get = function(info) return WarlockPortStatistics.db.factionrealm.paymentreminderSelf end,
    },
	paymentreminderSelfSec = {
		name = "Reminder sec",
		type = "range",
		min = 0,
		max = 120,
		step = 1,
		bigStep = 15,
		order = 31,
		set = function(info,val) WarlockPortStatistics.db.factionrealm.paymentreminderSelfSec = val end,
		get = function(info) return WarlockPortStatistics.db.factionrealm.paymentreminderSelfSec end
	},
	newline32 = { name="", type="description", order=32 },

    paymentreminderCustomer = {
      name = "Remind Customer",
      desc = "Whisper reminder to customer:",
      type = "toggle",
	  order = 35,
      set = function(info,val) WarlockPortStatistics.db.factionrealm.paymentreminderCustomer = val end,
      get = function(info) return WarlockPortStatistics.db.factionrealm.paymentreminderCustomer end,
    },
	paymentreminderCustomerSec = {
		name = "Reminder sec",
		type = "range",
		min = 0,
		max = 120,
		step = 1,
		bigStep = 15,
		order = 36,
		set = function(info,val) WarlockPortStatistics.db.factionrealm.paymentreminderCustomerSec = val end,
		get = function(info) return WarlockPortStatistics.db.factionrealm.paymentreminderCustomerSec end
	},
	newline37 = { name="", type="description", order=37 },
	paymentreminderCustomerText = {
		name = "Customer Reminder whisper text",
		type = "input",
		order = 38,
		confirm = true,
		width = 3.0,
		set = function(info, val) WarlockPortStatistics.db.factionrealm.paymentreminderCustomerText = val end,
		get = function(info) return WarlockPortStatistics.db.factionrealm.paymentreminderCustomerText end,
	},
	newline39 = { name="", type="description", order=39 },

	hdr_cleanups = { name="Cleansing", type="header", order=40 },

	excCleanseOld = {
		name = "Cleanse old",
		type = "execute",
		order = 50,
		func = function(info) WarlockPortStatistics:cleanseOldEntries() end,
	},
	newline51 = { name="", type="description", order=51 },

	excCleanseOtherChars = {
		name = "Cleanse other chars",
		type = "execute",
		order = 60,
		func = function(info) WarlockPortStatistics:cleanseOtherChars() end,
	},
	newline61 = { name="", type="description", order=61 },

	tglCleanseAllEntries = {
      name = "Confirm to ...",
      desc = "Confirm cleansing all",
      type = "toggle",
	  order = 70,
      set = function(info,val) WarlockPortStatistics.confirmCleansAllEntries = val end,
      get = function(info) return WarlockPortStatistics.confirmCleansAllEntries end,
    },
	excCleanseAllEntries = {
		name = "Cleanse ALL entries",
		type = "execute",
		order = 71,
		func = function(info)
			if WarlockPortStatistics.confirmCleansAllEntries then
				WarlockPortStatistics:cleanseAllEntries()
				WarlockPortStatistics.confirmCleansAllEntries = false
			end
		 end,
	},
	newline72 = { name="", type="description", order=72 },

    hdr_settings = { name="Debug", type="header", order=97 },
    debugging = {
      name = "Debug",
      desc = "Enters Debug mode. Addon will have advanced output",
      type = "toggle",
      order = 98,
      set = function(info,val)
		WarlockPortStatistics.db.factionrealm.debug = val
		if WarlockPortStatistics.db.factionrealm.debug then
			WarlockPortStatistics.spellId = tonumber(WarlockPortStatistics.db.factionrealm.debugSpellId)
		else
			WarlockPortStatistics.spellId = 698 -- Ritual of Summoning
		end
	  end,
      get = function(info) return WarlockPortStatistics.db.factionrealm.debug end
    },
	debugSpellId = {
	  name = "Debug spell",
	  desc = "Addon reacts to different spell if debug is enabled and spell is selected",
	  type = "select",
	  style = "dropdown",
	  order = 99,
	  values = {["698"] = "Ritual of Summoning", ["5740"] = "Rain of Fire (Rank 1)", ["755"] = "Health Funnel (Rank 1)"},
	  set = function(info,val)
		WarlockPortStatistics.db.factionrealm.debugSpellId = val
		if WarlockPortStatistics.db.factionrealm.debug then
			WarlockPortStatistics.spellId = tonumber(WarlockPortStatistics.db.factionrealm.debugSpellId)
		else
			WarlockPortStatistics.spellId = 698 -- Ritual of Summoning
		end
	  end,
	  get = function(info) return WarlockPortStatistics.db.factionrealm.debugSpellId end,
	},
  }
}
function WarlockPortStatistics:OnInitialize()
  -- Code that you want to run when the addon is first loaded goes here.
  self.db = LibStub("AceDB-3.0"):New("WarlockPortStatisticsDB", defaults)

  self.db.factionrealm.lastChannel = 0

  if (self.db.factionrealm.portstats == nil) then
	self.db.factionrealm.portstats = {}
  end

  -- 698 = Ritual of Summoning
  self.spellId = 698

  self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_START")
  self:RegisterEvent("UNIT_SPELLCAST_CHANNEL_STOP")

  self:RegisterChatCommand('wps', 'handleChatCommand');
  self:RegisterChatCommand('warlockportstatistics', 'handleChatCommand');

  LibStub("AceConfig-3.0"):RegisterOptionsTable("WarlockPortStatistics", self.wpsOptionsTable)
  self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("WarlockPortStatistics", "Warlock Port Statistics")

  self:ResetTradeTracking()
  self:RegisterEvent("TRADE_SHOW")
  self:RegisterEvent("TRADE_ACCEPT_UPDATE")
  self:RegisterEvent("TRADE_MONEY_CHANGED")
  self:RegisterEvent("TRADE_CLOSED")

end

function WarlockPortStatistics:OnEnable()
end

function WarlockPortStatistics:OnDisable()
end

function WarlockPortStatistics:FormatMoney(copper)
  local gold = math.floor(copper / 10000)
  local silver = math.floor((copper % 10000) / 100)
  local copperOnly = copper % 100
  return string.format("%dg %ds %dc", gold, silver, copperOnly)
end

function WarlockPortStatistics:cleanseOldEntries()
	local weekago = time() - 7*24*60*60

	-- never change dict you are iterating on :)
	local pstats = {}
	local removed = 0

	for key,value in pairs(self.db.factionrealm.portstats) do
		if key >= weekago then
			pstats[key] = value
		else
			removed = removed + 1
		end
	end

	self.db.factionrealm.portstats = pstats

	if (removed > 0) then
		self:Print("Tidied " .. tostring(removed) .. " entries.")
	else
		self:Print("No entries needed tidying up.")
	end
end

function WarlockPortStatistics:cleanseOtherChars()
	local player,realm = UnitName("player")

	-- never change dict you are iterating on :)
	local pstats = {}
	local removed = 0

	for key,value in pairs(self.db.factionrealm.portstats) do
		if value["player"] == player then
			pstats[key] = value
		else
			removed = removed + 1
		end
	end

	self.db.factionrealm.portstats = pstats

	if (removed > 0) then
		self:Print("Removed " .. tostring(removed) .. " entries from different chars.")
	else
		self:Print("No entries from other chars found.")
	end
end

function WarlockPortStatistics:cleanseAllEntries()
	self.db.factionrealm.portstats = {}
	self:Print("Cleared all entries.")
end

function WarlockPortStatistics:handleChatCommand(cmd)
	self:CreatePortStatisticsFrame()
end

function WarlockPortStatistics:encounterChannel(atTime)
	local tname = "-unknown-"
	local portedFrom = "-unknown-"
	local tguild = "-unknown-"

	local pname, prealm = UnitName("player")
	local portedTo = GetSubZoneText() .. ", " .. GetZoneText()
	local pguild, _, _= GetGuildInfo("player")

	if UnitExists("target") then
		tname, _ = UnitName("target")
		tguild, _, _= GetGuildInfo("target")

		local portedFromMapID = C_Map.GetBestMapForUnit("target")
		if portedFromMapID then
			portedFrom = C_Map.GetMapInfo(portedFromMapID).name
		end
	end

	local ts = date("%Y-%m-%d %H:%M", atTime)

	self.db.factionrealm.portstats[self.db.factionrealm.lastChannel] = {
		player = pname, playerLocation = portedTo, playerGuild = pguild,
		target = tname, targetLocation = portedFrom, targetGuild = tguild,
		timestamp = ts,
		started = self.db.factionrealm.lastChannel,
		stopped = nil
	}

	if self.db.factionrealm.trackpayment and self.db.factionrealm.guildforfree and tguild == pguild and pguild ~= nil then
		self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["paid"] = "Guild"
	end

	if self.db.factionrealm.trackpayment and self.db.factionrealm.partyforfree and UnitInParty("player") and not UnitInRaid("player") then
		-- and UnitInParty("player") technically not needed, you need to be in party of raid to port anyway... but for Debug it might be
		self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["paid"] = "Party"
	end

end

function WarlockPortStatistics:UNIT_SPELLCAST_CHANNEL_START(event, unit, dummy, spellID, dummy2)
	if not self.db.factionrealm.enabled then
		return nil
	end
    if unit == "player" and spellID == self.spellId then
		self.db.factionrealm.lastChannel = time()
		self:encounterChannel(self.db.factionrealm.lastChannel)
	end

end

function WarlockPortStatistics:UNIT_SPELLCAST_CHANNEL_STOP(event, unit, dummy, spellID, dummy2)
	if not self.db.factionrealm.enabled then
		return nil
	end

    if unit == "player" and spellID == self.spellId then
		if (self.db.factionrealm.portstats[self.db.factionrealm.lastChannel] == nil) then
			self:encounterChannel(self.db.factionrealm.lastChannel)
		end

		self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["stopped"] = time()

		self:Print("You ported " .. self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["target"] .. " <" .. tostring(self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["targetGuild"]) .. "> from " .. tostring(self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["targetLocation"]) .. " to " .. self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["playerLocation"])

		if self.db.factionrealm.paymentreminderSelf
		  and self.db.factionrealm.paymentreminderSelfSec > 0
		  and not self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["paid"]
		  then
			self:ScheduleTimer("RemindSelf", self.db.factionrealm.paymentreminderSelfSec, self.db.factionrealm.lastChannel)
			WarlockPortStatistics:Debug("RemindSelf starting in " .. tostring(self.db.factionrealm.paymentreminderSelfSec) .. "sec")
		end

		if self.db.factionrealm.paymentreminderCustomer
		  and self.db.factionrealm.paymentreminderCustomerSec > 0
		  and not self.db.factionrealm.portstats[self.db.factionrealm.lastChannel]["paid"]
		  then
			self:ScheduleTimer("RemindCustomer", self.db.factionrealm.paymentreminderCustomerSec, self.db.factionrealm.lastChannel)
			WarlockPortStatistics:Debug("RemindCustomer starting in " .. tostring(self.db.factionrealm.paymentreminderCustomerSec) .. "sec")
		end

	end

end

function WarlockPortStatistics:RemindSelf(channelId)
	-- might have been disabled in the meantime
	if not self.db.factionrealm.paymentreminderSelf then return nil end
	-- might have been cleansed in the meantime
	if not self.db.factionrealm.portstats[channelId] then return nil end

	-- might have been paid in the meantime
	if self.db.factionrealm.portstats[channelId]["paid"] then return nil end

	RaidNotice_AddMessage(RaidWarningFrame, "Payment from " .. self.db.factionrealm.portstats[channelId]["target"] .. "\nnot received yet!", ChatTypeInfo["RAID_WARNING"])
	self:Print("Payment from " .. self.db.factionrealm.portstats[channelId]["target"] .. " not received yet!")
end

function WarlockPortStatistics:RemindCustomer(channelId)
	-- might have been disabled in the meantime
	if not self.db.factionrealm.paymentreminderCustomer then return nil end
	-- might have been cleansed in the meantime
	if not self.db.factionrealm.portstats[channelId] then return nil end

	-- might have been paid in the meantime
	if self.db.factionrealm.portstats[channelId]["paid"] then return nil end

	if UnitExists(self.db.factionrealm.portstats[channelId]["target"]) then
		SendChatMessage(self.db.factionrealm.paymentreminderCustomerText, "WHISPER", nil, self.db.factionrealm.portstats[channelId]["target"])
	end
end

function WarlockPortStatistics:ResetTradeTracking()
  self.tradeTracking = { tradePartner = "", acceptedMe = false, acceptedThem = false, myMoney = 0, theirMoney = 0 }
end

function WarlockPortStatistics:TRADE_SHOW()
  self.tradeTracking["tradePartner"] = UnitName("NPC") or "-no trade partner found-"
end

function WarlockPortStatistics:TRADE_ACCEPT_UPDATE(me, them)
  self.tradeTracking["acceptedMe"] = (me == 1)
  self.tradeTracking["acceptedThem"] = (them == 1)
end

function WarlockPortStatistics:TRADE_MONEY_CHANGED()
  self.tradeTracking["myMoney"] = GetPlayerTradeMoney() or 0
  self.tradeTracking["theirMoney"] = GetTargetTradeMoney() or 0
end

function WarlockPortStatistics:TRADE_CLOSED()
  if self.tradeTracking["acceptedMe"] and self.tradeTracking["acceptedThem"] and self.tradeTracking["theirMoney"] > 0 and self.tradeTracking["myMoney"] == 0 then
    self:Debug("Received " .. self:FormatMoney(self.tradeTracking["theirMoney"]) .. " from " .. self.tradeTracking["tradePartner"])

	-- find latest self.db.factionrealm.portstats for tradePartner, not later as X min ago (5min?) and mark paid
	local fiveMinAgo = time() - 5*60
	for ts,ps in pairs(self.db.factionrealm.portstats) do
		if (ts >= fiveMinAgo) and (ps["target"] == self.tradeTracking["tradePartner"]) then
			self.db.factionrealm.portstats[ts]["paid"] = self:FormatMoney(self.tradeTracking["theirMoney"])
		end
	end

  end
  self:ResetTradeTracking()
end

function WarlockPortStatistics:CreatePortStatisticsFrame()
	local ST = LibStub("ScrollingTable")

	local cols = {
		{ name = "Timestamp", width = 110, align = "LEFT", field = "timestamp", sort = "asc", defaultsort = "asc"},
		{ name = "Customer", width = 90, align = "LEFT", field = "target"},
		{ name = "Guild", width = 80, align = "LEFT", field = "targetGuild"},
		{ name = "ported from", width = 120, align = "LEFT", field = "targetLocation"},
	}
	if self.db.factionrealm.trackpayment then
		tinsert(cols, { name = "paid", width = 50, align = "LEFT", field = "paid"})
	end
	tinsert(cols, { name = "Warlock", width = 100, align = "LEFT", field = "player"})
	tinsert(cols, { name = "ported to", width = 120, align = "LEFT", field = "playerLocation"})

	local colors = {
		{["r"] = 1.0, ["g"] = 1.0, ["b"] = 1.0, ["a"] = 1.0 },
		{["r"] = 0.8, ["g"] = 0.8, ["b"] = 0.8, ["a"] = 1.0 },
	}
	local colorcounter = 0

	local data = {}

	-- prepare data
	for _,ps in pairs(self.db.factionrealm.portstats) do

		local row = {
			-- default color
			["color"] = colors[(colorcounter % table.getn(colors))+1],
			["colorargs"] = nil,
			["DoCellUpdate"] = nil,
		}
		colorcounter = colorcounter+1

		-- override
		if ps["color"] then
			row["color"] = ps["color"]
		end

		local rowcols = {}

		for _,col in ipairs(cols) do
			local colfield = col["field"]

			local rowcolumn = {
				["value"] = ps[colfield] or '-'
			}

			table.insert(rowcols, rowcolumn)
		end

		row["cols"] = rowcols

		table.insert(data, row)
	end

	local frame = CreateFrame("Frame", "WPS_PortStatisticsFrame", UIParent, _G.BackdropTemplateMixin and "BackdropTemplate")
	frame:SetBackdrop({
		bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
		edgeFile = [[Interface\Tooltips\UI-Tooltip-Border]],
		tile = true, tileSize = 16, edgeSize = 16,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
    })

	local plannedwidth = 50
	for _,c in ipairs(cols) do
		plannedwidth = plannedwidth + c["width"]
	end

	local plannedheight = 240
	if not self.db.factionrealm.enabled then
		plannedheight = 260
	end
	frame:SetSize(plannedwidth, plannedheight)
	frame:SetPoint("CENTER")

	frame:SetBackdropColor(0, 0, 0, 0.85)
	frame:EnableMouse(true)
	frame:SetMovable(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", frame.StartMoving)
	frame:SetScript("OnDragStop", frame.StopMovingOrSizing)

	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", 0, -5)
	title:SetText("Warlock Port Statistics")

	if not self.db.factionrealm.enabled then
		local warningNote = frame:CreateFontString(nil, "OVERLAY", "GameFontRed")
		warningNote:SetPoint("BOTTOM", 0, 12)
		warningNote:SetText("Note: Further tracking is disabled in configuration!")
		--warningNote:SetTextColor(1,0,0,1)
	end

	local st = ST:CreateST(cols, 10, 18, nil, frame)
	st.frame:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -38)
	st.frame:SetBackdropColor(0.1, 0.1, 0.1, 0.25)
	
	st:SetData(data)

	function frame:ShowParent(parent)
		self:SetParent(parent)
		self:ClearAllPoints()
		self:SetPoint("TOPLEFT",parent,"TOPRIGHT")
		self:Show()
	end

	function frame:HideParent()
		self:SetParent(UIParent)
		self:Hide()
	end

	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", -4, -4)

	tinsert(UISpecialFrames, "WPS_PortStatisticsFrame")

	return frame
end

-- for debug outputs
function tprint (tbl, indent)
	if not indent then indent = 0 end
	local toprint = string.rep(" ", indent) .. "{\r\n"
	indent = indent + 2
	for k, v in pairs(tbl) do
	  toprint = toprint .. string.rep(" ", indent)
	  if (type(k) == "number") then
		toprint = toprint .. "[" .. k .. "] = "
	  elseif (type(k) == "string") then
		toprint = toprint  .. k ..  "= "
	  end
	  if (type(v) == "number") then
		toprint = toprint .. v .. ",\r\n"
	  elseif (type(v) == "string") then
		toprint = toprint .. "\"" .. v .. "\",\r\n"
	  elseif (type(v) == "table") then
		toprint = toprint .. tprint(v, indent + 2) .. ",\r\n"
	  else
		toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
	  end
	end
	toprint = toprint .. string.rep(" ", indent-2) .. "}"
	return toprint
end

function WarlockPortStatistics:Debug(t, lvl)
	if self.db.factionrealm.debug then
		if lvl == nil then
			lvl = "DEBUG"
		end
		if (type(t) == "table") then
			self:Print(lvl .. ": " .. tprint(t))
		else
			self:Print(lvl .. ": " .. t)
		end
	end
end
