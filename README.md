# LocoMind Free — AI NPC Conversations for FiveM

> Your NPCs now talk back. Powered by AI. Free forever.

LocoMind Free is an open-source FiveM script that gives NPCs a real voice — players can have dynamic conversations with any NPC on your server. No static menus. No scripted dialogues. Just real AI responses, in character.

**Free providers supported out of the box — no forced subscriptions.**

![LocoMind Banner](https://raw.githubusercontent.com/LiL-Loco/locomind-free/main/locomind-banner-2k.png)

---

## Features

- 💬 **Dynamic NPC conversations** — NPCs respond naturally, in character
- 🔊 **Voice responses** — NPCs can speak aloud via edge-tts (free), ElevenLabs, or OpenAI TTS
- ⚡ **Free AI providers** — Groq, OpenRouter, NVIDIA NIM, Ollama — no OpenAI required
- 🎭 **Custom personas** — unique personality per NPC
- 🗺 **Map blips** — configurable per NPC (sprite, color, scale, label)
- 🧩 **Any framework** — ESX, QBCore, standalone
- 🔒 **Your keys stay on your server** — no cloud dependency
- 0.0ms idle resource usage

---

## Supported AI Providers

| Provider | Cost | Speed | Setup |
|---|---|---|---|
| **Groq** ⭐ | 🟢 Free tier | Blazing fast | [console.groq.com](https://console.groq.com) |
| **OpenRouter** | 🟢 Free models | Fast | [openrouter.ai](https://openrouter.ai) |
| **NVIDIA NIM** | 🟢 Free credits | Fast | [build.nvidia.com](https://build.nvidia.com) |
| **Ollama** | 🟢 Local, free | Depends on HW | Self-hosted |
| **OpenAI** | 💛 Paid | Fast | [platform.openai.com](https://platform.openai.com) |
| **Custom** | — | — | Any OpenAI-compatible API |

## Supported TTS Providers

| Provider | Cost | Quality | Setup |
|---|---|---|---|
| **edge-tts** ⭐ | 🟢 Free | ⭐⭐⭐⭐ | `pip install edge-tts` + sidecar |
| **ElevenLabs** | 🟡 Free tier / Paid | ⭐⭐⭐⭐⭐ | [elevenlabs.io](https://elevenlabs.io) |
| **OpenAI TTS** | 💛 Paid | ⭐⭐⭐⭐⭐ | OpenAI API key |
| **NVIDIA Riva** | 🟢 Self-hosted | ⭐⭐⭐⭐ | NVIDIA GPU server |
| **None** | — | Text only | Default |

---

## Installation

1. Drop `locomind-free` into your `resources` folder
2. Add to `server.cfg`:
   ```
   ensure locomind-free
   ```
3. Set your AI provider key in `server.cfg`:
   ```
   # Groq (recommended — free)
   set locomind_api_key "gsk_your-groq-key"
   set locomind_provider "groq"

   # Optional: TTS voice (edge-tts sidecar)
   set locomind_tts_url "http://localhost:3210"
   ```
4. Configure your NPCs in `config.lua`
5. Restart server — done

---

## Voice Setup (Optional)

To enable voice responses (NPCs speak aloud):

```bash
# 1. Install edge-tts
pip install edge-tts

# 2. Start the sidecar (in your server directory or as a service)
node resources/locomind-free/sidecar/index.js
```

Then in `config.lua`:
```lua
Config.TTS = {
    Provider = "edge-tts",
    Enabled  = true,
}
```

400+ voices available — British, American, German, French, Spanish and more.
Full voice list: `edge-tts --list-voices`

---

## Configuration

```lua
Config.Provider    = "groq"           -- groq | openrouter | nvidia | ollama | openai | custom
Config.Model       = "llama-3.1-8b-instant"
Config.InteractKey = 38               -- E key
Config.InteractDistance = 2.5         -- meters

Config.TTS = {
    Provider = "none",                -- none | edge-tts | openai | elevenlabs | nvidia-riva
    Enabled  = false,
}

Config.NPCs = {
    {
        name    = "Tommy",
        model   = "a_m_m_skater_01",
        coords  = vector3(195.17, -933.77, 30.69),
        heading = 250.0,
        persona = "You are Tommy, a shady used car dealer in Legion Square. Nervous, always looking over your shoulder. Keep responses under 2 sentences.",
        voice   = "en-US-GuyNeural",
        blip = {
            sprite = 1, color = 5, scale = 0.7,
            label  = "Tommy",
        },
    },
}
```

---

## How It Works

```
Player presses E near NPC
        ↓
Chat UI opens (dark, sleek)
        ↓
Player types message
        ↓
Server sends to AI provider (Groq / OpenRouter / etc.)
        ↓
NPC responds dynamically, in character
        ↓
[If TTS enabled] NPC speaks the response aloud
        ↓
Text always shown as fallback
```

---

## Credits

Built by **[ThaLoco0ne](https://github.com/LiL-Loco)** — FiveM developer.

## License

MIT — free to use, modify, and distribute. Attribution appreciated.
