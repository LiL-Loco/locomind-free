# LocoMind TTS Sidecar

A tiny local server that converts text to speech using **edge-tts** (free Microsoft voices) and returns base64-encoded MP3 audio to the FiveM server.

## Requirements

- Python 3.8+
- Node.js 18+
- edge-tts: `pip install edge-tts`

## Setup

```bash
# 1. Install edge-tts
pip install edge-tts

# 2. Start the sidecar
node index.js

# Or on a custom port:
node index.js 3211
```

## server.cfg

```
set locomind_tts_url "http://localhost:3210"
```

## Enable TTS in config.lua

```lua
Config.TTS = {
    Provider = "edge-tts",
    Enabled  = true,
}
```

## Available Voices

| Voice | Language | Style |
|---|---|---|
| en-US-GuyNeural | English US | Casual male |
| en-US-ChristopherNeural | English US | Deep male |
| en-US-JennyNeural | English US | Female |
| en-US-AriaNeural | English US | Female warm |
| en-GB-RyanNeural | English UK | British male |
| de-DE-ConradNeural | German | Male |
| de-DE-KatjaNeural | German | Female |
| fr-FR-HenriNeural | French | Male |
| es-ES-AlvaroNeural | Spanish | Male |

Full list: `edge-tts --list-voices`

## API Endpoints

- `POST /tts` — `{ "text": "Hello", "voice": "en-US-GuyNeural" }` → base64 MP3
- `GET /voices` — list available voices
- `GET /health` — health check
