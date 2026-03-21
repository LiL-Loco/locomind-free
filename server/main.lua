local apiKey  = GetConvar('locomind_api_key', '')
local baseUrl = GetConvar('locomind_base_url', '')

-- Resolve base URL from provider config or convar override
local function getBaseUrl()
    -- convar override always wins (for ollama / custom)
    if baseUrl ~= '' then return baseUrl end

    local urls = {
        openai     = "https://api.openai.com",
        groq       = "https://api.groq.com/openai",
        openrouter = "https://openrouter.ai/api",
        nvidia     = "https://integrate.api.nvidia.com",
    }
    return urls[Config.Provider] or "https://api.openai.com"
end

-- Startup check
CreateThread(function()
    local provider = Config.Provider or "openai"
    local needsKey = (provider ~= "ollama")

    if needsKey and apiKey == '' then
        print('^1[LocoMind] ERROR: locomind_api_key not set in server.cfg^0')
        print('^3[LocoMind] Provider: ' .. provider .. '^0')
        print('^3[LocoMind] Add this to server.cfg:  set locomind_api_key "your-key-here"^0')
    else
        print('^2[LocoMind] Loaded. Provider: ' .. provider .. ' | Model: ' .. Config.Model .. '^0')
    end
end)

RegisterNetEvent('locomind:askNPC', function(data)
    local src = source
    local provider = Config.Provider or "openai"
    local needsKey = (provider ~= "ollama")

    if needsKey and apiKey == '' then
        TriggerClientEvent('locomind:npcResponse', src, {
            npcName = data.npcName,
            message = "I can't talk right now. (API key not configured — check server.cfg)"
        })
        return
    end

    local endpoint = getBaseUrl() .. "/v1/chat/completions"

    local body = json.encode({
        model       = Config.Model,
        max_tokens  = Config.MaxTokens,
        temperature = Config.Temperature,
        messages    = {
            {
                role    = "system",
                content = data.persona .. " Keep your response under 2 sentences. Stay in character at all times."
            },
            {
                role    = "user",
                content = data.message
            }
        }
    })
    -- Build headers
    local headers = { ['Content-Type'] = 'application/json' }

    if apiKey ~= '' then
        headers['Authorization'] = 'Bearer ' .. apiKey
    end

    -- OpenRouter requires extra headers (recommended)
    if provider == "openrouter" then
        headers['HTTP-Referer'] = 'https://locomind.dev'
        headers['X-Title']     = 'LocoMind Free'
    end

    PerformHttpRequest(endpoint, function(statusCode, responseBody, _headers)
        if statusCode == 200 then
            local ok, response = pcall(json.decode, responseBody)
            if ok and response and response.choices and response.choices[1] then
                local reply = response.choices[1].message.content

                -- Synthesize speech if TTS enabled
                if Config.TTS and Config.TTS.Enabled and Config.TTS.Provider ~= "none" then
                    local voice = data.voice or Config.DefaultVoice
                    SynthesizeSpeech(src, reply, voice, function(audioB64)
                        TriggerClientEvent('locomind:npcResponse', src, {
                            npcName  = data.npcName,
                            message  = reply,
                            audioB64 = audioB64,  -- nil if TTS failed, chat-only fallback
                        })
                    end)
                else
                    TriggerClientEvent('locomind:npcResponse', src, {
                        npcName = data.npcName,
                        message = reply,
                    })
                end
            else
                print('^1[LocoMind] Failed to parse API response^0')
                TriggerClientEvent('locomind:npcResponse', src, {
                    npcName = data.npcName,
                    message = "..."
                })
            end
        else
            print('^1[LocoMind] API error ' .. tostring(statusCode) .. ' (' .. provider .. ')^0')
            print('^1[LocoMind] ' .. tostring(responseBody) .. '^0')
            TriggerClientEvent('locomind:npcResponse', src, {
                npcName = data.npcName,
                message = "I don't have anything to say right now."
            })
        end
    end, 'POST', body, headers)
end)
