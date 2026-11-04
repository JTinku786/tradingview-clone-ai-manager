@echo off
setlocal
cd /d "%~dp0.."
echo === Codex MCP config ===
cmd /c codex mcp get tradingview
echo.
echo === TradingView CDP health ===
cmd /c node vendor\tradingview-mcp\src\cli\index.js status
echo.
echo === TradingView chart state ===
cmd /c node vendor\tradingview-mcp\src\cli\index.js state
