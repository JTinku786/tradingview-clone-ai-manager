@echo off
setlocal
cd /d "%~dp0..\vendor\tradingview-mcp"
call scripts\launch_tv_debug.bat 9222
