# LocoMind Free — AI NPCs for FiveM

> Give your NPCs a voice. Powered by OpenAI.

LocoMind Free is an open-source FiveM script that lets players have real conversations with NPCs using ChatGPT. No memory, no cloud dependency — just your OpenAI API key and a config file.

**Want persistent NPC memory, server-context awareness, and a full admin dashboard?**
→ Check out **[LocoMind Pro](https://locomind.dev)** — the SaaS backend for serious RP servers.

---

## Features

- 💬 Text-based chat with any NPC
- 🤖 GPT-4o mini powered responses
- 🎭 Custom NPC personas via config
- ⚡ Standalone — works with ESX, QBCore, or any framework
- 🔒 Your OpenAI key stays on your server
- 0.0ms idle resource usage

## Requirements

- FiveM server (artifact 6683+)
- OpenAI API Key → [platform.openai.com](https://platform.openai.com)
- ox_target or qb-target (optional, for interaction)

## Installation

1. Download and place `locomind-free` in your `resources` folder
2. Add `ensure locomind-free` to your `server.cfg`
3. Set your OpenAI API key in `server.cfg`:
   ```
   set locomind_api_key "sk-your-key-here"
   ```
4. Configure NPCs in `config.lua`
5. Restart server

## Usage

Walk up to a configured NPC and press `E` to talk.
Type your message — the NPC responds in character.

## Configuration

```lua
-- config.lua
Config = {}

Config.InteractKey = 38        -- E key
Config.InteractDistance = 2.5  -- meters
Config.Model = "gpt-4o-mini"   -- OpenAI model

Config.NPCs = {
    {
        name = "Tommy",
        coords = vector3(123.4, 456.7, 78.9),
        model = "a_m_m_skater_01",
        persona = "You are Tommy, a shady car dealer in Los Santos. You speak casually, are slightly nervous, and always trying to make a deal. Keep responses under 2 sentences.",
        heading = 180.0,
    },
    -- Add more NPCs here
}
```

## Comparison

| Feature | LocoMind Free | LocoMind Pro |
|---|---|---|
| NPC Chat (GPT) | ✅ | ✅ |
| Custom Personas | ✅ | ✅ |
| Persistent NPC Memory | ❌ | ✅ |
| Server-Context Awareness | ❌ | ✅ |
| Player-NPC Relationships | ❌ | ✅ |
| Admin Dashboard | ❌ | ✅ |
| Multi-NPC Communication | ❌ | ✅ |
| Support | Community | Priority |
| Price | Free | From €19/mo |

## Credits

Built by **[ThaLoco0ne](https://locomind.dev)** — FiveM developer & creator of LocoMind.

## License

MIT — free to use, modify, and distribute. Attribution appreciated.
