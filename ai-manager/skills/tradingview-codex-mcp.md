# Skill: TradingView + Codex MCP

## Goal

Connect Codex to the local TradingView Desktop app through the `tradingview-mcp` bridge.

## Video Reference

User-provided videos:

- `https://www.youtube.com/watch?v=PBXV9uZrsug`
- `https://www.youtube.com/watch?v=44ydkl1KS70`

Useful Codex-specific takeaways from the direct Codex video:

- Use Codex, not Claude Code.
- Add a TradingView MCP connector to Codex configuration.
- Restart Codex after adding the MCP connector because tools load at process startup.
- Launch TradingView with Chrome DevTools Protocol enabled.
- Verify the connection with `tv_health_check`.

## Installed Local Bridge

Repository:

`C:\Users\saite\Desktop\Tradingview_AI_Agentic\vendor\tradingview-mcp`

Codex MCP config:

```powershell
cmd /c codex mcp get tradingview
```

Expected server:

```text
command: node
args: C:\Users\saite\Desktop\Tradingview_AI_Agentic\vendor\tradingview-mcp\src\server.js
```

## Launch TradingView With CDP

Use:

```powershell
cmd /c scripts\launch-tradingview-debug.bat
```

or from the vendor folder:

```powershell
cmd /c scripts\launch_tv_debug.bat 9222
```

Verify CDP directly:

```powershell
Invoke-RestMethod -Uri "http://127.0.0.1:9222/json/version" -TimeoutSec 5
```

## Verify MCP Without Waiting For A New Chat

From project root:

```powershell
cmd /c node vendor\tradingview-mcp\src\cli\index.js status
cmd /c node vendor\tradingview-mcp\src\cli\index.js state
cmd /c node vendor\tradingview-mcp\src\cli\index.js quote
```

Known-good setup result on 2026-05-16:

- `cdp_connected: true`
- `api_available: true`
- symbol: `BATS:NKE`
- resolution: `240`

## Set Chart Symbol And Timeframe

From project root:

```powershell
cmd /c node vendor\tradingview-mcp\src\cli\index.js symbol NYSE:MCD
cmd /c node vendor\tradingview-mcp\src\cli\index.js timeframe 5
cmd /c node vendor\tradingview-mcp\src\cli\index.js state
```

Test result on 2026-05-16:

- Requested symbol: `NYSE:MCD`
- Loaded symbol reported by TradingView: `BATS:MCD`
- Resolution: `5`
- Window title updated to `MCD ... / MSS, BOS and Choch`

## Verify MCP Through Fresh Codex

Use a new Codex process because the current session may have started before the MCP server was registered:

```powershell
cmd /c codex exec --cd "C:\Users\saite\Desktop\Tradingview_AI_Agentic" --sandbox danger-full-access --dangerously-bypass-approvals-and-sandbox --skip-git-repo-check "Use the tradingview MCP tool tv_health_check. Return only the tool result JSON or a concise error."
```

## Local Patch

The upstream Windows launcher did not initially detect this Microsoft Store/MSIX package:

`31178TradingViewInc.TradingView_3.1.0.0_x64__q4jpyh43s5mv6`

The local vendor copy was patched in:

- `vendor\tradingview-mcp\scripts\launch_tv_debug.bat`
- `vendor\tradingview-mcp\src\core\health.js`

The patch adds broader `WindowsApps` matching and a `Get-AppxPackage` fallback.

## Caveat

`npm run test:unit` mostly passed, but two Pine compile CLI tests crashed under local Node `v24.11.1` with a Windows async assertion. The MCP health path, chart state, and quote checks worked.
