# TradingView AI manager

Use Codex conventions and the vendored MCP bridge in `vendor/tradingview-mcp`.
Register its `src/server.js` using an absolute path for your checkout.
Launch TradingView Desktop with local CDP port 9222, then verify health and chart state.
Prefer MCP chart tools for reading chart data. Keep CDP local only.
Never commit credentials, session data or private exports.
Do not execute broker orders without explicit user authorization and a verified broker path.
The browser terminal is a separate application; this bridge controls TradingView Desktop.
