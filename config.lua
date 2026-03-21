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

-- UI
Config.NpcColor    = {r=0,   g=180, b=255, a=255}
Config.PlayerColor = {r=255, g=255, b=255, a=255}

-- ============================================================
--  NPC DEFINITIONS
-- ============================================================

Config.NPCs = {
    {
        name    = "Tommy",
        coords  = vector3(123.4, 456.7, 78.9),
        model   = "a_m_m_skater_01",
        heading = 180.0,
        persona = "You are Tommy, a shady used car dealer on the east side of Los Santos. You speak in short, casual sentences. You're always nervous and looking over your shoulder.",
    },
    {
        name    = "Officer Martinez",
        coords  = vector3(-456.1, 234.5, 45.2),
        model   = "s_m_y_cop_01",
        heading = 90.0,
        persona = "You are Officer Martinez, a tired but honest LSPD cop who has seen too much. You speak professionally but with a hint of world-weariness. You don't tolerate disrespect.",
    },
    -- Add your own NPCs here:
    -- {
    --     name    = "YourNPC",
    --     coords  = vector3(x, y, z),
    --     model   = "ped_model_name",
    --     heading = 0.0,
    --     persona = "Your character description here.",
    -- },
}
