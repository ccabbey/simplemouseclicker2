
#SingleInstance Force


; 初始化变量
ScriptName := "Easy Clicker2"
ScriptVersion := "1.0.0.0"
CopyrightNotice := ""

ConfigDir := A_ScriptDir
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
TEXT_PrimaryButton := "LButton"
TEXT_SecondaryButton := "RButton"
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

EnableMouseChecked := IniRead(ConfigFile, "MouseAction", "EnableMouse", 1)
MouseButton := IniRead(ConfigFile, "MouseAction", "MouseButton", 1)
ClickAction := IniRead(ConfigFile, "MouseAction", "ClickAction", 1)

EnableKeyboardChecked := IniRead(ConfigFile, "KeyboardAction", "EnableKeyboard", 1)
cfgKeyStroke := IniRead(ConfigFile, "KeyboardAction", "KeyStroke", "F")

cfgHotkeyStart := IniRead(ConfigFile, "HotKey", "HotkeyStart", "F9")
cfgHotkeyStop := IniRead(ConfigFile, "HotKey", "HotkeyStop", "F10")


; 注册热键
;if CurrentHotkeyStart != ""
;    Hotkey(CurrentHotkeyStart, "On")
;if CurrentHotkeyStop != ""
;    Hotkey(CurrentHotkeyStop, "On")

; 创建 GUI
ui := Gui("+AlwaysOnTop", ScriptName)
tab:=ui.AddTab3(,["Interval", "Mouse","Keyboard","Hotkey"])

tab.UseTab("Interval")
ui.AddText("Section", TEXT_Hours)
ui.AddEdit("Number Limit2 w50", Hours)
UpDownHour :=ui.AddUpDown("Range0-24")

ui.AddText("Section ys", TEXT_Minutes)
ui.AddEdit("Number Limit2 w50", Minutes)
UpdownMinute:=ui.AddUpDown("Range0-59")

ui.AddText("Section ys", TEXT_Seconds)
ui.AddEdit("Number Limit2 w50", Seconds)
UpDownSecond:=ui.AddUpDown("Range0-59")

ui.AddText("Section ys", TEXT_MilliSeconds)
ui.AddEdit("Number Limit3 w50 vUpDownMilliSecond", MilliSeconds)
UpDownMilliSecond:=ui.AddUpDown("Range0-999",200)

tab.UseTab("Mouse")
chbEnableMouse:=ui.AddCheckbox("Checked" EnableMouseChecked, "Enable Mouse")
ui.AddText("Section", "Button")
ui.AddText(, "Action")
lstMouseButton:=ui.AddDropDownList("ys AltSubmit Choose" MouseButton, ["LButton", "RButton"])
lstMouseAction:=ui.AddDropDownList("AltSubmit Choose" ClickAction, ["Single Click", "Double Click"])

tab.UseTab("Keyboard")
chbEnableKeyboard   :=ui.AddCheckbox("Checked" EnableKeyboardChecked, "Enable Keyboard")
hkKeystroke:=ui.AddHotkey(,cfgKeyStroke)



tab.UseTab("Hotkey")
ui.AddText("Section", TEXT_Start)
ui.AddText(, TEXT_Stop)
hkHotkeyStart :=ui.AddHotkey("Limit1 ys", cfgHotkeyStart)
hkHotkeyStop  :=ui.AddHotkey("Limit1", cfgHotkeyStop)

tab.UseTab()
btnStart:=ui.Add("Button", "Default w75 h23", "Start").OnEvent("Click", ButtonStart)
btnStop:=ui.Add("Button", "x+m w75 h23", "Stop").OnEvent("Click", ButtonStop)
ui.Show()

; 按钮事件
ButtonStart(*) {
    global ui
    ui.Submit()
    ui.Minimize()
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
    global lstMouseAction
    Click(lstMouseAction)
}

ClickSecondaryButton() {
    global lstMouseAction
    Click(lstMouseAction, "Right")
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
ui.OnEvent("Close", GuiClose)
GuiClose(*) { 
    global ConfigFile, UpDownHour, UpDownMinute, UpDownSecond, UpDownMilliSecond, lstMouseButton, lstMouseAction, hkHotkeyStart, hkHotkeyStop
    if !FileExist(ConfigDir)
        DirCreate(ConfigDir)
    IniWrite(UpDownHour.Value, ConfigFile, "ClickInterval", "Hours")
    IniWrite(UpDownMinute.Value, ConfigFile, "ClickInterval", "Minutes")
    IniWrite(UpDownSecond.Value, ConfigFile, "ClickInterval", "Seconds")
    IniWrite(UpDownMilliSecond.Value, ConfigFile, "ClickInterval", "MilliSeconds")

    IniWrite(chbEnableMouse.Value, ConfigFile, "MouseAction", "EnableMouse")
    IniWrite(lstMouseButton.Value, ConfigFile, "MouseAction", "MouseButton")
    IniWrite(lstMouseAction.Value, ConfigFile, "MouseAction", "ClickAction")

    IniWrite(chbEnableKeyboard.Value, ConfigFile, "KeyboardAction", "EnableKeyboard")
    IniWrite(hkKeystroke.Value, ConfigFile, "KeyboardAction", "KeyStroke")

    IniWrite(hkHotkeyStart, ConfigFile, "HotKey", "HotkeyStart")
    IniWrite(hkHotkeyStop, ConfigFile, "HotKey", "HotkeyStop")
    ExitApp()
}