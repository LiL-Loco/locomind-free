Config = {}

-- Interaction
Config.InteractKey = 38           -- E key (38 = INPUT_PICKUP)
Config.InteractDistance = 2.5     -- meters to trigger interaction
Config.ChatTimeout = 30           -- seconds before chat closes automatically

-- AI
Config.Model = "gpt-4o-mini"      -- OpenAI model to use
Config.MaxTokens = 150            -- keep responses short and snappy
Config.Temperature = 0.85         -- creativity level (0.0-1.0)

-- UI
Config.ChatPrefix = "💬"          -- prefix shown in chat
Config.NpcColor = {r=0, g=180, b=255, a=255}    -- NPC text color (blue)
Config.PlayerColor = {r=255, g=255, b=255, a=255} -- Player text color (white)

-- NPCs
-- Add as many NPCs as you want.
-- persona: short character description for the AI. Keep it under 3 sentences.
Config.NPCs = {
    {
        name = "Tommy",
        coords = vector3(123.4, 456.7, 78.9),
        model = "a_m_m_skater_01",
        heading = 180.0,
        persona = "You are Tommy, a shady used car dealer on the east side of Los Santos. You speak in short, casual sentences. You're always nervous and looking over your shoulder.",
    },
    {
        name = "Officer Martinez",
        coords = vector3(-456.1, 234.5, 45.2),
        model = "s_m_y_cop_01",
        heading = 90.0,
        persona = "You are Officer Martinez, a tired but honest LSPD cop who has seen too much. You speak professionally but with a hint of world-weariness. You don't tolerate disrespect.",
    },
    -- Add your own NPCs here
    -- {
    --     name = "YourNPC",
    --     coords = vector3(x, y, z),
    --     model = "ped_model_name",
    --     heading = 0.0,
    --     persona = "Your character description here.",
    -- },
}
