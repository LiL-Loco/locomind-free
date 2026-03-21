Config = {}

-- Interaction
Config.InteractKey = 38           -- E key (38 = INPUT_PICKUP)
Config.InteractDistance = 2.5     -- meters to trigger interaction
Config.ChatTimeout = 30           -- seconds before chat closes automatically

-- ============================================================
--  AI PROVIDER CONFIGURATION
--  Pick ONE provider by setting Config.Provider below.
--  Then set the matching API key / base URL in server.cfg.
-- ============================================================

--[[
    AVAILABLE PROVIDERS:
    
    "openai"      → OpenAI (paid)
                    server.cfg: set locomind_api_key "sk-..."
                    Models: gpt-4o-mini, gpt-3.5-turbo, gpt-4o

    "groq"        → Groq (FREE tier available — recommended!)
                    Get key: https://console.groq.com
                    server.cfg: set locomind_api_key "gsk_..."
                    Models: llama-3.1-8b-instant, mixtral-8x7b-32768, gemma2-9b-it

    "openrouter"  → OpenRouter (FREE models available)
                    Get key: https://openrouter.ai
                    server.cfg: set locomind_api_key "sk-or-..."
                    Models: meta-llama/llama-3.1-8b-instruct:free
                            mistralai/mistral-7b-instruct:free
                            google/gemma-2-9b-it:free

    "nvidia"      → NVIDIA NIM (FREE with NVIDIA account)
                    Get key: https://build.nvidia.com
                    server.cfg: set locomind_api_key "nvapi-..."
                    Models: meta/llama-3.1-8b-instruct
                            mistralai/mistral-7b-instruct-v0.3

    "ollama"      → Ollama (100% FREE, runs locally on your server)
                    No API key needed. Install ollama + pull a model.
                    server.cfg: set locomind_base_url "http://localhost:11434"
                    Models: llama3.1, mistral, gemma2, phi3

    "custom"      → Any OpenAI-compatible API
                    server.cfg: set locomind_base_url "https://your-api.com"
                                set locomind_api_key "your-key"
]]--

Config.Provider = "groq"          -- Change this to your preferred provider

-- Model to use (must match your chosen provider)
Config.Model = "llama-3.1-8b-instant"   -- Fast & free on Groq

-- Response settings
Config.MaxTokens = 150            -- Keep NPC responses short
Config.Temperature = 0.85         -- Creativity (0.0-1.0)

-- Provider base URLs (you normally don't need to change these)
Config.ProviderURLs = {
    openai     = "https://api.openai.com",
    groq       = "https://api.groq.com/openai",
    openrouter = "https://openrouter.ai/api",
    nvidia     = "https://integrate.api.nvidia.com",
    ollama     = nil,   -- read from locomind_base_url convar
    custom     = nil,   -- read from locomind_base_url convar
}

-- ============================================================
--  TTS (TEXT-TO-SPEECH) CONFIGURATION
--  NPCs can speak their responses aloud. Pick a provider below.
-- ============================================================

--[[
    AVAILABLE TTS PROVIDERS:

    "none"          → No voice. Text chat only. (default, zero cost)

    "edge-tts"      → Microsoft Edge TTS — FREE, 400+ voices, no API key needed
                      Requires: locomind-tts-sidecar running on the server
                      (Node.js helper, included in /sidecar/)
                      server.cfg: set locomind_tts_url "http://localhost:3210"
                      Voices: "en-US-GuyNeural", "en-US-JennyNeural",
                              "de-DE-ConradNeural", "fr-FR-HenriNeural" etc.
                      Full list: https://bit.ly/edge-tts-voices

    "openai"        → OpenAI TTS — Paid (~$15/1M characters)
                      server.cfg: set locomind_tts_key "sk-..."
                      Voices: alloy, echo, fable, onyx, nova, shimmer

    "elevenlabs"    → ElevenLabs — FREE tier (10,000 chars/month), Paid for more
                      Get key: https://elevenlabs.io
                      server.cfg: set locomind_tts_key "your-key"
                      Voices: use voice ID from ElevenLabs dashboard

    "nvidia-riva"   → NVIDIA Riva TTS — Self-hosted, FREE
                      Requires: NVIDIA GPU + Riva NIM running locally
                      server.cfg: set locomind_tts_url "http://localhost:8080"
                      Voices: "English-US.Male-1", "English-US.Female-1" etc.
]]--

Config.TTS = {
    Provider = "none",             -- Set to "edge-tts", "openai", "elevenlabs", "nvidia-riva", or "none"
    Enabled  = false,              -- Set to true to enable voice
}

-- Per-NPC voice assignment (optional)
-- If not set, the NPC will use the default voice for the provider.
-- edge-tts voices: https://bit.ly/edge-tts-voices
Config.DefaultVoice = "en-US-GuyNeural"    -- Male English (edge-tts default)

-- UI
Config.NpcColor    = {r=0,   g=180, b=255, a=255}
Config.PlayerColor = {r=255, g=255, b=255, a=255}

-- ============================================================
--  NPC DEFINITIONS
-- ============================================================

-- Blip sprites: https://docs.fivem.net/game-references/blips/
-- Blip colors:  https://docs.fivem.net/game-references/blips/#blip-colors
Config.NPCs = {
    {
        name    = "Tommy",
        -- Legion Square — well-known RP hotspot in Los Santos
        coords  = vector3(195.17, -933.77, 30.69),
        model   = "a_m_m_skater_01",
        heading = 250.0,
        persona = "You are Tommy, a shady used car dealer hanging around Legion Square. You speak in short, casual sentences, always nervous and looking over your shoulder. You hint at knowing where to get cheap cars.",
        voice   = "en-US-GuyNeural",     -- edge-tts voice for this NPC
        blip = {
            sprite = 280,  -- info icon
            color  = 5,    -- yellow
            scale  = 0.7,
            label  = "Tommy",
        },
    },
    {
        name    = "Officer Martinez",
        -- Outside LSPD Pillbox area
        coords  = vector3(428.52, -979.43, 30.71),
        model   = "s_m_y_cop_01",
        heading = 180.0,
        persona = "You are Officer Martinez, a tired but honest LSPD cop outside the Pillbox precinct. You speak professionally with world-weary undertones. You don't tolerate disrespect but appreciate honesty.",
        voice   = "en-US-ChristopherNeural",  -- deeper male voice for cop
        blip = {
            sprite = 280,
            color  = 3,    -- blue
            scale  = 0.7,
            label  = "Officer Martinez",
        },
    },
    -- -------------------------------------------------------
    -- Add your own NPCs here.
    -- Tip: use the F8 console command "coord" in-game to get
    -- your current position as a vector3.
    -- -------------------------------------------------------
    -- {
    --     name    = "YourNPC",
    --     coords  = vector3(x, y, z),
    --     model   = "ped_model_name",
    --     heading = 0.0,
    --     persona = "Your character description here.",
    --     blip = {
    --         sprite = 280,
    --         color  = 2,   -- green
    --         scale  = 0.7,
    --         label  = "YourNPC",
    --     },
    --     -- blip = false,  -- uncomment to hide this NPC from the map
    -- },
}
