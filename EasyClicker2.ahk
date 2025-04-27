
#SingleInstance Force


; 初始化变量
ScriptName := "EasyClicker2"
ScriptVersion := "1.0.0.0"
CopyrightNotice := ""

ConfigDir := A_ScriptDir
ConfigFile := ConfigDir . "\" . ScriptName . ".ini"


; 从配置文件读取设置
cfgHours := IniRead(ConfigFile, "ClickInterval", "Hours", 0)
cfgMinutes := IniRead(ConfigFile, "ClickInterval", "Minutes", 0)
cfgSeconds := IniRead(ConfigFile, "ClickInterval", "Seconds", 0)
cfgMilliSeconds := IniRead(ConfigFile, "ClickInterval", "MilliSeconds", 0)

EnableMouseChecked := IniRead(ConfigFile, "MouseAction", "EnableMouse", 1)
MouseButton := IniRead(ConfigFile, "MouseAction", "MouseButton", 1)
ClickAction := IniRead(ConfigFile, "MouseAction", "ClickAction", 1)

EnableKeyboardChecked := IniRead(ConfigFile, "KeyboardAction", "EnableKeyboard", 1)
cfgKeyStroke := IniRead(ConfigFile, "KeyboardAction", "KeyStroke", "F")

cfgHotkeyStart := IniRead(ConfigFile, "HotKey", "HotkeyStart", "F9")
cfgHotkeyStop := IniRead(ConfigFile, "HotKey", "HotkeyStop", "F10")


; 注册全局热键
if cfgHotkeyStart != ""
    Hotkey(cfgHotkeyStart, HotkeyStart,"On")
if cfgHotkeyStop != ""
    Hotkey(cfgHotkeyStop, HotkeyStop,"On")

; 创建 GUI
ui := Gui("+AlwaysOnTop", ScriptName)
tab:=ui.AddTab3(,["Interval", "Mouse","Keyboard","Hotkey"])

tab.UseTab("Interval")
ui.AddText("Section", "Hours")
ui.AddEdit("Number Limit2 w50")
UpDownHour :=ui.AddUpDown("Range0-24",cfgHours)

ui.AddText("Section ys", "Minutes")
ui.AddEdit("Number Limit2 w50")
UpdownMinute:=ui.AddUpDown("Range0-59",cfgMinutes)

ui.AddText("Section ys", "Seconds")
ui.AddEdit("Number Limit2 w50")
UpDownSecond:=ui.AddUpDown("Range0-59",cfgSeconds)

ui.AddText("Section ys", "MilliSeconds")
ui.AddEdit("Number Limit3 w50 vUpDownMilliSecond")
UpDownMilliSecond:=ui.AddUpDown("Range0-999",cfgMilliSeconds)

tab.UseTab("Mouse")
chbEnableMouse:=ui.AddCheckbox("Checked" EnableMouseChecked, "Enable Mouse")
chbEnableMouse.OnEvent("Click", OnClickEnableMouseCheckbox)
ui.AddText("Section", "Button")
ui.AddText(, "Action")
lstMouseButton:=ui.AddDropDownList("ys AltSubmit Choose" MouseButton, ["LButton", "RButton"])
lstMouseAction:=ui.AddDropDownList("AltSubmit Choose" ClickAction, ["Single Click", "Double Click"])

tab.UseTab("Keyboard")
chbEnableKeyboard   :=ui.AddCheckbox("Checked" EnableKeyboardChecked, "Enable Keyboard")
hkKeystroke:=ui.AddHotkey(,cfgKeyStroke)



tab.UseTab("Hotkey")
ui.AddText("Section", "Start")
ui.AddText(, "Stop")
hkHotkeyStart :=ui.AddHotkey("Limit1 ys", cfgHotkeyStart)
hkHotkeyStop  :=ui.AddHotkey("Limit1", cfgHotkeyStop)

tab.UseTab()
btnStart:=ui.Add("Button", "Default w75 h23", "Start").OnEvent("Click", OnClickStartButton)
btnStop:=ui.Add("Button", "x+m w75 h23", "Stop").OnEvent("Click", OnClickStopButton)
ui.Show()


; Start Button Event
OnClickStartButton(*) {
    ;ui.Submit()
    ;ui.Minimize()

    ; determine mouse action and keyboard action
    interval := UpDownHour.Value * 3600000 + UpDownMinute.Value * 60000 + UpDownSecond.Value * 1000 + UpDownMilliSecond.Value
    if interval > 0 {
        if (chbEnableMouse.Value) {
            SetTimer ClickButton, interval
        }
        if (chbEnableKeyboard.Value) {
            SetTimer SendKeyStroke, interval
        }
    }
}

; Stop Button Event
OnClickStopButton(*) {
    SetTimer ClickButton, 0
    SetTimer SendKeyStroke, 0
}

ClickButton(){
    Click(lstMouseButton.Value,lstMouseAction.Value)
}

SendKeyStroke(){
    Send hkKeystroke.Value
}

; 热键事件
HotkeyStart(*) {
    global cfgHotkeyStart
    Hotkey(cfgHotkeyStart, OnClickStartButton, "on")
}

HotkeyStop(*) {
    global cfgHotkeyStop
    Hotkey(cfgHotkeyStop, OnClickStopButton, "on")
}

; GUI 关闭事件
ui.OnEvent("Close", GuiClose)
GuiClose(*) { 
    global ConfigFile, UpDownHour, UpDownMinute, UpDownSecond, UpDownMilliSecond, lstMouseButton, lstMouseAction, hkHotkeyStart, hkHotkeyStop
    if !FileExist(ConfigDir)
        FileAppend(ConfigFile)
    IniWrite(UpDownHour.Value, ConfigFile, "ClickInterval", "Hours")
    IniWrite(UpDownMinute.Value, ConfigFile, "ClickInterval", "Minutes")
    IniWrite(UpDownSecond.Value, ConfigFile, "ClickInterval", "Seconds")
    IniWrite(UpDownMilliSecond.Value, ConfigFile, "ClickInterval", "MilliSeconds")

    IniWrite(chbEnableMouse.Value, ConfigFile, "MouseAction", "EnableMouse")
    IniWrite(lstMouseButton.Value, ConfigFile, "MouseAction", "MouseButton")
    IniWrite(lstMouseAction.Value, ConfigFile, "MouseAction", "ClickAction")

    IniWrite(chbEnableKeyboard.Value, ConfigFile, "KeyboardAction", "EnableKeyboard")
    IniWrite(hkKeystroke.Value, ConfigFile, "KeyboardAction", "KeyStroke")

    IniWrite(hkHotkeyStart.Value, ConfigFile, "HotKey", "HotkeyStart")
    IniWrite(hkHotkeyStop.Value, ConfigFile, "HotKey", "HotkeyStop")
    ExitApp()
}

; chbEnableMouse Event 
OnClickEnableMouseCheckbox(*) {
    global chbEnableMouse, lstMouseButton, lstMouseAction
    if (chbEnableMouse.Value) {
        cfgEnableMouse := 1
    } else {
        cfgEnableMouse := 0
    }
}