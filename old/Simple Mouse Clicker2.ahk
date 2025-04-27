
#SingleInstance Force


; 初始化变量
ScriptName := "Easy Clicker2"
ScriptVersion := "1.0.0.0"
CopyrightNotice := ""

ConfigDir := A_AppData . "\" . ScriptName
ConfigFile := ConfigDir . "\" . ScriptName . ".ini"

; 设置文本
TEXT_ClickInterval := "Click Interval"
TEXT_Hours := "Hours"
TEXT_Minutes := "Minutes"
TEXT_Seconds := "Seconds"
TEXT_MilliSeconds := "MilliSeconds"

TEXT_MouseAction := "Action"
TEXT_Button := "Button"
TEXT_Action := "Action"
TEXT_NoButton := "No Button"
TEXT_PrimaryButton := "Primary Button"
TEXT_SecondaryButton := "Secondary Button"
TEXT_SingleClick := "Single Click"
TEXT_DoubleClick := "Double Click"

TEXT_Key := "Key"
TEXT_EnableMouse := "Enable Mouse"
TEXT_EnableKeyboard := "Enable Keyboard"

TEXT_HotKey := "Hot Key"
TEXT_Start := "Start"
TEXT_Stop := "Stop"

; 从配置文件读取设置
Hours := IniRead(ConfigFile, "ClickInterval", "Hours", 0)
Minutes := IniRead(ConfigFile, "ClickInterval", "Minutes", 0)
Seconds := IniRead(ConfigFile, "ClickInterval", "Seconds", 1)
MilliSeconds := IniRead(ConfigFile, "ClickInterval", "MilliSeconds", 0)

MouseButton := IniRead(ConfigFile, "MouseAction", "MouseButton", 1)
ClickAction := IniRead(ConfigFile, "MouseAction", "ClickAction", 1)

HkStart := IniRead(ConfigFile, "HotKey", "HotkeyStart", "F9")
HkStop := IniRead(ConfigFile, "HotKey", "HotkeyStop", "F10")

CurrentHotkeyStart := HkStart
CurrentHotkeyStop := HkStop

; 注册热键
;if CurrentHotkeyStart != ""
;    Hotkey(CurrentHotkeyStart, "On")
;if CurrentHotkeyStop != ""
;    Hotkey(CurrentHotkeyStop, "On")

; 创建 GUI
myGui := Gui("+AlwaysOnTop", ScriptName)
myTab:=myGui.AddTab3(,[TEXT_ClickInterval, TEXT_Action,TEXT_HotKey])

myTab.UseTab(1)
myGui.Add("Text", "Section", TEXT_Hours)
myGui.Add("Edit", "Number Limit2 w50 vUpDownHour", Hours)
UpdownHour:=myGui.Add("UpDown", "Range0-24")

myGui.Add("Text", "Section ys", TEXT_Minutes)
myGui.Add("Edit", "Number Limit2 w50 vUpDownMinute", Minutes)
UpdownMinute:=myGui.Add("UpDown", "Range0-59")

myGui.Add("Text", "Section ys", TEXT_Seconds)
myGui.Add("Edit", "Number Limit2 w50 vUpDownSecond", Seconds)
UpDownSecond:=myGui.Add("UpDown", "Range0-59")

myGui.Add("Text", "Section ys", TEXT_MilliSeconds)
myGui.Add("Edit", "Number Limit3 w50 vUpDownMilliSecond", MilliSeconds)
UpDownMilliSecond:=myGui.Add("UpDown", "Range0-999")

myTab.UseTab(2)
myGui.Add("Text", "Section", TEXT_Button)
myGui.Add("Text", , TEXT_Action)
ChoiceButton:=myGui.Add("DropDownList", "AltSubmit Choose" MouseButton " ys vChoiceButton", [TEXT_NoButton, TEXT_PrimaryButton,TEXT_SecondaryButton])
ChoiceAction:=myGui.Add("DropDownList", "AltSubmit Choose" ClickAction " vChoiceAction", [TEXT_SingleClick, TEXT_DoubleClick])
myGui.Add("CheckBox", "AltSubmit vEnableMouse", TEXT_EnableMouse)

myTab.UseTab(3)
myGui.Add("Text", "Section", TEXT_Start)
myGui.Add("Text", , TEXT_Stop)
myGui.Add("Hotkey", "Limit1 ys vHotkeyStart", CurrentHotkeyStart)
myGui.Add("Hotkey", "Limit1 vHotkeyStop", CurrentHotkeyStop)

myTab.UseTab()
myGui.Add("Button", "Default w75 h23 vButtonStart", TEXT_Start).OnEvent("Click", ButtonStart)
myGui.Add("Button", "x+m w75 h23 vButtonStop", TEXT_Stop).OnEvent("Click", ButtonStop)
myGui.Show()

; 按钮事件
ButtonStart(*) {
    global myGui
    myGui.Submit()
    myGui.Minimize()
    interval := UpDownHour * 3600000 + UpDownMinute * 60000 + UpDownSecond * 1000 + UpDownMilliSecond
    if interval > 0 {
        SetTimer(() => ClickPrimaryButton(), interval)
    }
}

ButtonStop(*) {
    SetTimer(() => ClickPrimaryButton(), "Off")
    SetTimer(() => ClickSecondaryButton(), "Off")
}

ClickPrimaryButton() {
    global ChoiceAction
    Click(ChoiceAction)
}

ClickSecondaryButton() {
    global ChoiceAction
    Click(ChoiceAction, "Right")
}

; 热键事件
HotkeyStart(*) {
    global CurrentHotkeyStart
    Hotkey(CurrentHotkeyStart, ButtonStart, "Off")
    CurrentHotkeyStart := HotkeyStart
    Hotkey(CurrentHotkeyStart, ButtonStart, "On")
}

HotkeyStop(*) {
    global CurrentHotkeyStop
    Hotkey(CurrentHotkeyStop, ButtonStop, "Off")
    CurrentHotkeyStop := HotkeyStop
    Hotkey(CurrentHotkeyStop, ButtonStop, "On")
}

; GUI 关闭事件
myGui.OnEvent("Close", GuiClose)
GuiClose(*) { 
    global ConfigFile, UpDownHour, UpDownMinute, UpDownSecond, UpDownMilliSecond, ChoiceButton, ChoiceAction, HkStart, HkStop
    if !FileExist(ConfigDir)
        DirCreate(ConfigDir)
    IniWrite(UpDownHour.Value, ConfigFile, "ClickInterval", "Hours")
    IniWrite(UpDownMinute.Value, ConfigFile, "ClickInterval", "Minutes")
    IniWrite(UpDownSecond.Value, ConfigFile, "ClickInterval", "Seconds")
    IniWrite(UpDownMilliSecond.Value, ConfigFile, "ClickInterval", "MilliSeconds")
    IniWrite(ChoiceButton.Value, ConfigFile, "MouseAction", "MouseButton")
    IniWrite(ChoiceAction.Value, ConfigFile, "MouseAction", "ClickAction")
    IniWrite(HkStart, ConfigFile, "HotKey", "HotkeyStart")
    IniWrite(HkStop, ConfigFile, "HotKey", "HotkeyStop")
    ExitApp()
}