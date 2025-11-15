local localPlayer = localPlayer
local drivingSchoolCorrectQuestions = 0
local drivingSchoolCurQuestion = 1

local examWindow
local questionLabel
local questionNumberLabel
local answerButtons = {}
local sendButton
local selectedAnswer = nil


local drivingLicenses = {}
drivingLicenses["question"] = {
    [1]="Was ist bei Aquaplaning zu tun?",
    [2]="Welche Vorfahrt gilt an einem Kreisverkehr?",
    [3]="Was bedeutet dieses Verkehrszeichen? (Dreieck mit rotem Rand und Ausrufezeichen)",
    [4]="Wann musst du beim Abbiegen blinken?",
    [5]="Wie verhältst du dich an einem Fußgängerüberweg (Zebrastreifen)?",
    [6]="Was ist der richtige Abstand zum vorausfahrenden Fahrzeug?",
    [7]="Wann darfst du eine durchgezogene Linie überfahren?"
}
drivingLicenses["answereA"] = {
    [1]="Stark bremsen und das Lenkrad festhalten",
    [2]="Rechts vor Links",
    [3]="Vorsicht, Steinschlag!",
    [4]="Immer, wenn du die Fahrtrichtung änderst",
    [5]="Du hast Vorrang und darfst ungehindert fahren",
    [6]="Mindestens eine Fahrzeuglänge",
    [7]="Nur in Notfällen"
}
drivingLicenses["answereB"] = {
    [1]="Gas wegnehmen und nicht lenken",
    [2]="Wer zuerst in den Kreisverkehr einfährt, hat Vorfahrt",
    [3]="Achtung, Gegenverkehr",
    [4]="Nur beim Abbiegen an einer Kreuzung",
    [5]="Du musst anhalten und Fußgänger überqueren lassen",
    [6]="Der halbe Tacho in Metern (bei 100 km/h = 50 Meter)",
    [7]="Niemals"
}
drivingLicenses["answereC"] = {
    [1]="Weiter beschleunigen",
    [2]="Der Verkehr im Kreisverkehr hat Vorfahrt, außer es ist anders beschildert",
    [3]="Gefahrstelle",
    [4]="Nur, wenn du eine andere Straße befährst",
    [5]="Nur Kinder und Senioren haben Vorrang",
    [6]="Eine Sekunde Abstand",
    [7]="Nur, um ein Hindernis zu umfahren"
}
drivingLicenses["answereD"] = {
    [1]="Motor abstellen und ausrollen lassen",
    [2]="Der Verkehr, der aus dem Kreisverkehr herausfährt, hat Vorfahrt",
    [3]="Achtung, Baustelle",
    [4]="Das Blinken ist optional",
    [5]="Du fährst langsam weiter, wenn keine Fußgänger da sind",
    [6]="Zwei Sekunden Abstand",
    [7]="Nur in der Stadt"
}

drivingLicenses["correct"] = {
    [1]=2,
    [2]=3,
    [3]=3,
    [4]=4,
    [5]=2,
    [6]=2,
    [7]=2
}



local function highlightSelection(clickedButton)
    local defaultColor = "FFFFFFFF" 
    local selectedColor = "FF00FFFF" 

  
    for _, btn in ipairs(answerButtons) do
        guiSetProperty(btn, "NormalTextColour", defaultColor)
    end
    guiSetProperty(clickedButton, "NormalTextColour", selectedColor)
end



function startDrivingLicenseTheory_func()
    drivingSchoolCorrectQuestions = 0
    drivingSchoolCurQuestion = 1
    showExamWindow(drivingSchoolCurQuestion)
    showCursor(true)
end

function showExamWindow(questionNR)
    drivingSchoolCurQuestion = questionNR
    
    if isElement(examWindow) then destroyElement(examWindow) end
    
    if not drivingLicenses["question"][questionNR] then
        showCursor(false)
        return
    end

    local screenWidth, screenHeight = guiGetScreenSize()
    local windowWidth, windowHeight = 550, 400
    local windowX, windowY = screenWidth / 2 - windowWidth / 2, screenHeight / 2 - windowHeight / 2

    examWindow = guiCreateWindow(windowX, windowY, windowWidth, windowHeight, "Führerscheinprüfung", false)
    guiWindowSetMovable(examWindow, false)
    guiWindowSetSizable(examWindow, false)
    
    selectedAnswer = nil 

    questionNumberLabel = guiCreateLabel(10, 20, windowWidth - 20, 30, "Frage "..tostring(questionNR).." / 7", false, examWindow)
    guiLabelSetColor(questionNumberLabel, 255, 255, 100) 

    questionLabel = guiCreateLabel(20, 60, windowWidth - 40, 100, drivingLicenses["question"][questionNR], false, examWindow)
    
    guiLabelSetHorizontalAlign(questionLabel, "center")
    guiLabelSetVerticalAlign(questionLabel, "center")

    local answerOptions = {"A", "B", "C", "D"}
    local answerTexts = {
        drivingLicenses["answereA"][questionNR],
        drivingLicenses["answereB"][questionNR],
        drivingLicenses["answereC"][questionNR],
        drivingLicenses["answereD"][questionNR]
    }

    local buttonWidth = 240
    local buttonHeight = 50
    local startY = 180
    local padding = 10

    answerButtons = {}
    for i=1, 4 do
        local x = (i % 2 == 1) and padding or (padding + buttonWidth + padding)
        local y = (math.ceil(i/2) == 1) and startY or (startY + buttonHeight + padding)
        
        local text = answerOptions[i]..": "..answerTexts[i]
        
        answerButtons[i] = guiCreateButton(x, y, buttonWidth, buttonHeight, text, false, examWindow)
        
        addEventHandler("onClientGUIClick", answerButtons[i], function(button)
            if button == "left" then
                selectedAnswer = i
                highlightSelection(source) 
            end
        end, false)
    end
    

    sendButton = guiCreateButton(windowWidth/2 - 120/2, windowHeight - 60, 120, 40, "Absenden", false, examWindow)
    

    addEventHandler("onClientGUIClick", sendButton, function(button)
        if button == "left" then
            local currentSelection = selectedAnswer or 0
            
            if currentSelection == 0 then
                outputChatBox("Bitte wähle eine Antwort aus, bevor du absendest.", 255, 255, 0)
                return
            end

            if drivingLicenses["correct"][drivingSchoolCurQuestion] == currentSelection then
                drivingSchoolCorrectQuestions = drivingSchoolCorrectQuestions + 1
            end

            destroyElement(examWindow)
            
            if drivingSchoolCurQuestion < 7 then
                showExamWindow(drivingSchoolCurQuestion + 1)
            else
                triggerServerEvent("pruefungErgebnis", localPlayer, drivingSchoolCorrectQuestions)
                showCursor(false)
            end
        end
    end, false)
end
addEvent("startDrivingLicenseTheory", true)
addEventHandler("startDrivingLicenseTheory", root, startDrivingLicenseTheory_func)