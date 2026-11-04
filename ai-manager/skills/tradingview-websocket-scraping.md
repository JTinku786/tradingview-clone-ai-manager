# Skill: TradingView WebSocket Scraping Reference

## Source

Reference notebook:

`C:\Users\saite\Desktop\Tradingview_AI_Agentic\tardingview_web_scrapping.ipynb`

## Earlier Workflow

The notebook used Selenium with Chrome, not the installed TradingView desktop app.

Main setup:

- `selenium`
- `webdriver-manager`
- `ChromeDriverManager`
- Chrome performance logging through `goog:loggingPrefs`
- TradingView web chart URLs such as `https://in.tradingview.com/chart/n2kZoeH7/?symbol=NYSE%3ADD`

## Capture Method

The scraper enabled Chrome performance logs:

```python
chrome_options.set_capability("goog:loggingPrefs", {"performance": "ALL"})
```

It then read:

```python
driver.get_log("performance")
```

and searched for:

```python
method == "Network.webSocketFrameReceived"
```

Inside each WebSocket frame, it inspected:

```python
response["payloadData"]
```

The target payload was detected when the payload contained all of:

- `footprint`
- `buyVolume`
- `extendTo`

## Extraction Method

After a matching frame was found, the notebook:

1. Saved the full WebSocket message to `volume_footprint_raw_data.txt`.
2. Removed backslash escape characters.
3. Wrote the cleaned text to `subset_volume.txt`.
4. Found the JSON-like payload by slicing from near `footprintLevels` to before the first `erase`.
5. Loaded the sliced payload with `json.loads`.
6. Converted `footprintLevels[0]["data"]` into a pandas DataFrame.
7. Converted `footprints[0]["data"]` into a second pandas DataFrame.

## Multi-Ticker Loop

The notebook later read:

```python
tradingview_df = pd.read_csv("tradingview_links.csv")
```

Expected columns:

- `Symbol`
- `TradingView Link`

For each row, it opened the chart URL, collected performance logs, found the first matching footprint WebSocket frame, extracted the payload, and printed the resulting footprint DataFrame head.

## Known Weak Points

- The notebook uses fixed sleeps instead of explicit waits.
- It uses brittle XPath selectors for login.
- Credentials are hardcoded in the notebook and should be moved to environment variables or a local ignored secrets file before any further automation work.
- The payload extraction uses string slicing and backslash removal; a more robust parser should decode the WebSocket protocol message directly.
- It reads performance logs immediately after page navigation in some cells, which can miss frames if the chart has not fully loaded.
- The ticker loop currently prints results but does not clearly save one output file per ticker.

## Preferred Next Refactor

Turn the notebook flow into a reusable script with:

- A config file for ticker links.
- Environment-based credentials.
- Explicit waits for page and chart readiness.
- A function that captures matching WebSocket frames.
- A parser function for `footprintLevels` and `footprints`.
- Structured outputs under a local `data` folder.
