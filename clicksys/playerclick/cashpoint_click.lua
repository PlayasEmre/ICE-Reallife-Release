--//                                                  \\
--||   Project: MTA - German ICE Reallife Gamemode    ||
--||   Developers: PlayasEmre                         ||
--||   Version: 5.0                                   ||
--\\                                                  //

gGridList = {}
gLabel = {}

local clientStatements = {}

function showCashPoint_func ()
	if gWindow["cashPoint"] then
		dgsSetVisible(gWindow["cashPoint"], true)
		dgsSetInputMode("no_binds_when_editing")
	else
		dgsSetInputMode("no_binds_when_editing")
		gWindow["cashPoint"] = dgsCreateWindow(screenwidth/2-352/2, screenheight/2-500/2, 357, 450, "Geldautomat", false, tocolor(255,255,255), nil, nil, guimaincolor, nil, nil, nil, true)
		dgsSetAlpha(gWindow["cashPoint"], 1)
		
		gButton["cashPointClose"] = dgsCreateButton(0.345, 0.83, 0.26, 0.106, "Schließen", true, gWindow["cashPoint"])
		dgsSetFont(gButton["cashPointClose"], "clear")
		addEventHandler("onDgsMouseClickUp", gButton["cashPointClose"],
			function (button)
				if button == "left" then
					dgsSetVisible(gWindow["cashPoint"], false)
					setElementClicked(false)
					showCursor(false)
					dgsSetInputMode("allow_binds")
				end
			end,
		false)

		gTabPanel["cashPoint"] = dgsCreateTabPanel(0.022, 0.15, 0.943, 0.65, true, gWindow["cashPoint"])

		gTab["cashPointPayOut"] = dgsCreateTab("Ein/Auszahlen", gTabPanel["cashPoint"])
		gButton["cashPointPayOut"] = dgsCreateButton(41, 173, 94, 45, "Auszahlen", false, gTab["cashPointPayOut"])
		gButton["cashPointPayIn"] = dgsCreateButton(191, 171, 94, 45, "Einzahlen", false, gTab["cashPointPayOut"])
		gEdit["cashPointPayAmount"] = dgsCreateEdit(102, 88, 130, 33, "0", false, gTab["cashPointPayOut"])
		gLabel[1] = dgsCreateLabel(143, 71, 45, 19, "Betrag", false, gTab["cashPointPayOut"])
		dgsLabelSetColor(gLabel[1], 255, 255, 255)
		dgsLabelSetVerticalAlign(gLabel[1], "top")
		dgsLabelSetHorizontalAlign(gLabel[1], "left", false)
		dgsSetFont(gLabel[1], "clear")
		gLabel[2] = dgsCreateLabel(236, 97, 14, 23, "€", false, gTab["cashPointPayOut"])
		dgsLabelSetColor(gLabel[2], 0, 125, 0)
		dgsLabelSetVerticalAlign(gLabel[2], "top")
		dgsLabelSetHorizontalAlign(gLabel[2], "left", false)
		dgsSetFont(gLabel[2], "clear")

		addEventHandler("onDgsMouseClickUp", gButton["cashPointPayIn"],
			function (button)
				if button == "left" then
					local amount = tonumber(dgsGetText(gEdit["cashPointPayAmount"]))
					triggerServerEvent("cashPointPayIn", lp, amount)
					setTimer(function() triggerServerEvent("requestRecentStatements", localPlayer) end, 2000, 1)
				end
			end,
		false)
		addEventHandler("onDgsMouseClickUp", gButton["cashPointPayOut"],
			function (button)
				if button == "left" then
					local amount = tonumber(dgsGetText(gEdit["cashPointPayAmount"]))
					triggerServerEvent("cashPointPayOut", lp, amount)
					setTimer(function() triggerServerEvent("requestRecentStatements", localPlayer) end, 2000, 1)
				end
			end,
		false)

		gTab["cashPointTransfer"] = dgsCreateTab("Ueberweisung", gTabPanel["cashPoint"])
		gImage["cashPointTransferBG"] = dgsCreateImage(4, 10, 325, 211, ":"..getResourceName(getThisResource()).."/images/colors/c_white.jpg", false, gTab["cashPointTransfer"])
		gImage["cashPointTransferBGHead"] = dgsCreateImage(0, 0, 325, 19, ":"..getResourceName(getThisResource()).."/images/colors/c_red.jpg", false, gImage["cashPointTransferBG"])
		gLabel[3] = dgsCreateLabel(102, 1, 127, 14, "Ueberweisungsformular", false, gImage["cashPointTransferBGHead"])
		dgsLabelSetColor(gLabel[3], 255, 255, 255)
		dgsLabelSetVerticalAlign(gLabel[3], "top")
		dgsLabelSetHorizontalAlign(gLabel[3], "left", false)
		dgsCreateImage(0, 192, 325, 19, ":"..getResourceName(getThisResource()).."/images/colors/c_red.jpg", false, gImage["cashPointTransferBG"])
		gLabel[4] = dgsCreateLabel(2, 32, 150, 20, "Name des Beguenstigten", false, gImage["cashPointTransferBG"])
		dgsLabelSetColor(gLabel[4], 0, 0, 0)
		dgsLabelSetVerticalAlign(gLabel[4], "top")
		dgsLabelSetHorizontalAlign(gLabel[4], "left", false)
		gLabel[5] = dgsCreateLabel(2, 81, 148, 34, "Summe, die Überwiesen\nwerden soll", false, gImage["cashPointTransferBG"])
		dgsLabelSetColor(gLabel[5], 0, 0, 0)
		dgsLabelSetVerticalAlign(gLabel[5], "top")
		dgsLabelSetHorizontalAlign(gLabel[5], "left", false)
		gLabel[6] = dgsCreateLabel(306, 91, 12, 22, "€", false, gImage["cashPointTransferBG"])
		dgsLabelSetColor(gLabel[6], 0, 200, 0)
		dgsLabelSetVerticalAlign(gLabel[6], "top")
		dgsLabelSetHorizontalAlign(gLabel[6], "left", false)
		gLabel[7] = dgsCreateLabel(1, 144, 124, 39, "Verwendungszweck \n/ Betreff", false, gImage["cashPointTransferBG"])
		dgsLabelSetColor(gLabel[7], 0, 0, 0)
		dgsLabelSetVerticalAlign(gLabel[7], "top")
		dgsLabelSetHorizontalAlign(gLabel[7], "left", false)
		gEdit["cashPointTransferTo"] = dgsCreateEdit(165, 23, 153, 35, "Name", false, gImage["cashPointTransferBG"])
		gEdit["cashPointTransferAmount"] = dgsCreateEdit(165, 83, 135, 35, "0", false, gImage["cashPointTransferBG"])
		gMemo["cashPointTransferReason"] = dgsCreateMemo(146, 124, 174, 62, "Grund", false, gImage["cashPointTransferBG"])
		gButton["cashPointTransferSend"] = dgsCreateButton(129, 224, 66, 35, "Senden", false, gTab["cashPointTransfer"])
		dgsSetFont(gButton["cashPointTransferSend"], "clear")
		addEventHandler("onDgsMouseClickUp", gButton["cashPointTransferSend"],
			function (button)
				if button == "left" then
					local amount = tonumber(dgsGetText(gEdit["cashPointTransferAmount"]))
					local target = dgsGetText(gEdit["cashPointTransferTo"])
					local reason = dgsGetText(gMemo["cashPointTransferReason"])
					triggerServerEvent("cashPointTransfer", lp, amount, target, false, reason)
					setTimer(function() triggerServerEvent("requestRecentStatements", localPlayer) end, 2000, 1)
				end	
			end,
		false)

		gTab["cashPointPrint"] = dgsCreateTab("Kontoauszug", gTabPanel["cashPoint"])
		createStatementTab()
	end
	

	triggerServerEvent("requestRecentStatements", localPlayer)
end
addEvent("showCashPoint", true)
addEventHandler("showCashPoint", getRootElement(), showCashPoint_func)


function createStatementTab()
	gImage["cashPointPrintBG"] = dgsCreateImage(4, 5, 325, 220, ":"..getResourceName(getThisResource()).."/images/colors/c_white.jpg", false, gTab["cashPointPrint"])
	gImage["cashPointPrintBGHead"] = dgsCreateImage(0, 1, 325, 19, ":"..getResourceName(getThisResource()).."/images/colors/c_red.jpg", false, gImage["cashPointPrintBG"])
	
	local dgsLabel = dgsCreateLabel(0, 0, 325, 19, "Kontoauszug", false, gImage["cashPointPrintBGHead"])
	dgsLabelSetColor(dgsLabel, 255, 255, 255)
    dgsLabelSetHorizontalAlign(dgsLabel, "center", false)
    dgsLabelSetVerticalAlign(dgsLabel, "center")

	local dgsLabel = dgsCreateLabel(220, 2, 80, 12, getDateAsOneString(), false, gImage["cashPointPrintBGHead"])
	dgsLabelSetColor(dgsLabel, 255, 255, 255)

	dgsCreateImage(0, 200, 325, 19, ":"..getResourceName(getThisResource()).."/images/colors/c_red.jpg", false, gImage["cashPointPrintBG"])
	dgsCreateImage(101, 170, 210, 2, ":"..getResourceName(getThisResource()).."/images/colors/c_black.jpg", false, gImage["cashPointPrintBG"])


	local dgsLabel = dgsCreateLabel(16, 30, 73, 19, "Grund", false, gImage["cashPointPrintBG"])
	dgsLabelSetColor(dgsLabel, 0, 187, 0)
	local dgsLabel = dgsCreateLabel(130, 30, 73, 19, "Betrag", false, gImage["cashPointPrintBG"])
	dgsLabelSetColor(dgsLabel, 0, 187, 0)
	local dgsLabel = dgsCreateLabel(235, 30, 73, 19, "Sonstiges", false, gImage["cashPointPrintBG"])
	dgsLabelSetColor(dgsLabel, 0, 187, 0)


	gGridList["statementEntries"] = dgsCreateGridList(10, 55, 305, 110, false, gImage["cashPointPrintBG"])
	dgsGridListAddColumn(gGridList["statementEntries"], "Grund", 0.4)
	dgsGridListAddColumn(gGridList["statementEntries"], "Betrag", 0.25)
	dgsGridListAddColumn(gGridList["statementEntries"], "Sonstiges", 0.35)


	local dgsLabel = dgsCreateLabel(17, 177, 69, 17, "Total", false, gImage["cashPointPrintBG"])
	dgsLabelSetColor(dgsLabel, 200, 0, 0)
	gLabel["cashPointTotal"] = dgsCreateLabel(99, 176, 101, 16, "", false, gImage["cashPointPrintBG"])
end


addEvent("receiveRecentStatements", true)
addEventHandler("receiveRecentStatements", root, function(statements)
	clientStatements = statements
	refreshStatementLabels()
end)


function refreshStatementLabels ()
	dgsGridListClear(gGridList["statementEntries"])
	
	for _, entry in ipairs(clientStatements) do
		local row = dgsGridListAddRow(gGridList["statementEntries"])
		dgsGridListSetItemText(gGridList["statementEntries"], row, 1, entry.grund)
		dgsGridListSetItemText(gGridList["statementEntries"], row, 2, entry.betrag .. " €")
		dgsGridListSetItemText(gGridList["statementEntries"], row, 3, entry.sonstiges)
	end
	
	local money = vioClientGetElementData("bankmoney")
	local sign = ""
	if money > 0 then
		sign = "+"
	end
	dgsSetText(gLabel["cashPointTotal"], sign .. money .. " " .. Tables.waehrung)
end


function getDateAsOneString ()
	local time = getRealTime()
	local day = time.monthday
	local month = time.month + 1
	local year = time.year + 1900
	local hour = time.hour
	local minute = time.minute


	local formattedDay = (day < 10) and "0" .. day or day
	local formattedMonth = (month < 10) and "0" .. month or month
	local formattedHour = (hour < 10) and "0" .. hour or hour
	local formattedMinute = (minute < 10) and "0" .. minute or minute
	
	return formattedDay .. "." .. formattedMonth .. "." .. year .. ", " .. formattedHour .. ":" .. formattedMinute
end