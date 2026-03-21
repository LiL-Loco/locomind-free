local apiKey = GetConvar('locomind_api_key', '')

if apiKey == '' then
    print('^1[LocoMind] ERROR: locomind_api_key not set in server.cfg^0')
    print('^3[LocoMind] Add: set locomind_api_key "sk-your-key-here"^0')
end

RegisterNetEvent('locomind:askNPC', function(data)
    local src = source
    if apiKey == '' then
        TriggerClientEvent('locomind:npcResponse', src, {
            npcName = data.npcName,
            message = "I can't talk right now. (API key not configured)"
        })
        return
    end

    -- Build OpenAI request
    local body = json.encode({
        model = Config.Model,
        max_tokens = Config.MaxTokens,
        temperature = Config.Temperature,
        messages = {
            {
                role = "system",
                content = data.persona .. " Keep your response under 2 sentences. Stay in character at all times."
            },
            {
                role = "user",
                content = data.message
            }
        }
    })

    PerformHttpRequest(
        'https://api.openai.com/v1/chat/completions',
        function(statusCode, responseBody, headers)
            if statusCode == 200 then
                local response = json.decode(responseBody)
                local reply = response.choices[1].message.content

                TriggerClientEvent('locomind:npcResponse', src, {
                    npcName = data.npcName,
                    message = reply
                })
            else
                print('^1[LocoMind] OpenAI API error: ' .. tostring(statusCode) .. '^0')
                print('^1[LocoMind] Response: ' .. tostring(responseBody) .. '^0')

                TriggerClientEvent('locomind:npcResponse', src, {
                    npcName = data.npcName,
                    message = "I don't have anything to say right now."
                })
            end
        end,
        'POST',
        body,
        {
            ['Content-Type'] = 'application/json',
            ['Authorization'] = 'Bearer ' .. apiKey
        }
    )
end)
