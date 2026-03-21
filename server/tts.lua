local ttsApiKey = GetConvar('locomind_tts_key', '')
local ttsBaseUrl = GetConvar('locomind_tts_url', '')

-- Resolve TTS endpoint and build request
local function buildTTSRequest(text, voiceName)
    local provider = Config.TTS.Provider
    local key = ttsApiKey ~= '' and ttsApiKey or Config.TTS.ApiKey or ''

    if provider == "edge-tts" then
        -- edge-tts runs as local Python process, called via shell
        return { kind = "edge-tts", text = text, voice = voiceName }

    elseif provider == "openai" then
        return {
            kind    = "http",
            url     = "https://api.openai.com/v1/audio/speech",
            headers = {
                ['Content-Type']  = 'application/json',
                ['Authorization'] = 'Bearer ' .. key,
            },
            body = json.encode({
                model  = "tts-1",
                input  = text,
                voice  = voiceName or "onyx",
            }),
        }

    elseif provider == "elevenlabs" then
        local voiceId = voiceName or "pNInz6obpgDQGcFmaJgB" -- default: Adam
        return {
            kind    = "http",
            url     = "https://api.elevenlabs.io/v1/text-to-speech/" .. voiceId,
            headers = {
                ['Content-Type'] = 'application/json',
                ['xi-api-key']   = key,
            },
            body = json.encode({
                text          = text,
                model_id      = "eleven_multilingual_v2",
                voice_settings = { stability = 0.5, similarity_boost = 0.75 },
            }),
        }

    elseif provider == "nvidia-riva" then
        local base = ttsBaseUrl ~= '' and ttsBaseUrl or "http://localhost:8080"
        return {
            kind    = "http",
            url     = base .. "/v1/audio/speech",
            headers = {
                ['Content-Type']  = 'application/json',
                ['Authorization'] = key ~= '' and ('Bearer ' .. key) or nil,
            },
            body = json.encode({
                model = "magpie-tts-multilingual",
                input = text,
                voice = voiceName or "English-US.Male-1",
            }),
        }

    elseif provider == "none" or provider == nil then
        return { kind = "none" }
    end

    return { kind = "none" }
end

-- Main TTS function — returns base64 audio to client
function SynthesizeSpeech(src, text, voiceName, cb)
    if not Config.TTS or Config.TTS.Provider == "none" then
        cb(nil)
        return
    end

    -- Truncate very long responses for TTS
    if #text > 300 then
        text = text:sub(1, 297) .. "..."
    end

    local req = buildTTSRequest(text, voiceName)

    if req.kind == "none" then
        cb(nil)

    elseif req.kind == "edge-tts" then
        -- edge-tts via shell: outputs mp3 to temp file, we read it back as base64
        local tmpFile = "/tmp/locomind_tts_" .. src .. "_" .. os.time() .. ".mp3"
        local voice = req.voice or "en-US-GuyNeural"
        local cmd = string.format(
            'edge-tts --voice "%s" --text "%s" --write-media "%s" 2>/dev/null && base64 -w 0 "%s" && rm -f "%s"',
            voice,
            text:gsub('"', '\\"'):gsub('\n', ' '),
            tmpFile, tmpFile, tmpFile
        )

        -- FiveM doesn't allow os.execute directly in server scripts.
        -- We use a Node.js sidecar approach via HTTP to localhost.
        -- If locomind_tts_url is set, use it as the edge-tts sidecar endpoint.
        local sidecarUrl = ttsBaseUrl ~= '' and ttsBaseUrl or "http://localhost:3210"
        PerformHttpRequest(
            sidecarUrl .. "/tts",
            function(status, body, _)
                if status == 200 and body and #body > 10 then
                    cb(body) -- base64 mp3
                else
                    print('^3[LocoMind TTS] edge-tts sidecar error: ' .. tostring(status) .. '^0')
                    cb(nil)
                end
            end,
            'POST',
            json.encode({ text = text, voice = voice }),
            { ['Content-Type'] = 'application/json' }
        )

    elseif req.kind == "http" then
        PerformHttpRequest(req.url, function(status, body, _)
            if status == 200 and body and #body > 10 then
                -- body is raw binary audio, encode to base64
                local encoded = body -- PerformHttpRequest returns binary as string
                cb(encoded)
            else
                print('^3[LocoMind TTS] HTTP error: ' .. tostring(status) .. '^0')
                cb(nil)
            end
        end, 'POST', req.body, req.headers)
    end
end
