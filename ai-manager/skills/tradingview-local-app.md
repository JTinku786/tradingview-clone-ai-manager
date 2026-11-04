# Skill: TradingView Local Desktop Access

## Goal

Interact with the locally installed TradingView desktop app on Windows.

## Launch

Use this PowerShell command to launch TradingView:

```powershell
Start-Process "shell:AppsFolder\31178TradingViewInc.TradingView_q4jpyh43s5mv6!TradingView.Desktop"
```

## Detect Running App

Use this PowerShell command to confirm TradingView is running:

```powershell
Get-Process | Where-Object {
  $_.ProcessName -like '*TradingView*' -or $_.Path -like '*TradingView*'
} | Select-Object ProcessName, Id, MainWindowTitle, Path
```

## Inspect Main Window

TradingView can be inspected through Windows UI Automation:

```powershell
Add-Type -AssemblyName UIAutomationClient
Add-Type -AssemblyName UIAutomationTypes

$p = Get-Process TradingView | Where-Object { $_.MainWindowHandle -ne 0 } | Select-Object -First 1
$el = [System.Windows.Automation.AutomationElement]::FromHandle($p.MainWindowHandle)

[PSCustomObject]@{
  ProcessName = $p.ProcessName
  Id = $p.Id
  WindowTitle = $p.MainWindowTitle
  Handle = $p.MainWindowHandle
  AutomationName = $el.Current.Name
  ClassName = $el.Current.ClassName
  ControlType = $el.Current.ControlType.ProgrammaticName
}
```

## Known UI Details

- Main window class: `Chrome_WidgetWin_1`
- Child render panes may appear as `Chrome_RenderWidgetHostHWND`
- Some content may be rendered inside Chromium panes, so direct element-level automation may be limited.

## Update Rule

When new TradingView automation techniques are discovered, add them here with:

- What was attempted
- Exact command or script used
- Result
- Any limitation or next step
