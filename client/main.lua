local spawnedNPCs = {}
local activeNPC = nil
local chatOpen = false

-- Spawn all configured NPCs + blips
CreateThread(function()
    for _, npc in ipairs(Config.NPCs) do
        RequestModel(GetHashKey(npc.model))
        while not HasModelLoaded(GetHashKey(npc.model)) do
            Wait(100)
        end

        local ped = CreatePed(4, GetHashKey(npc.model), npc.coords.x, npc.coords.y, npc.coords.z - 1.0, npc.heading, false, true)
        SetEntityInvincible(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
        SetPedFleeAttributes(ped, 0, false)
        SetPedCombatAttributes(ped, 46, true)
        SetModelAsNoLongerNeeded(GetHashKey(npc.model))

        -- Spawn map blip (unless blip = false)
        local blip = nil
        if npc.blip ~= false and type(npc.blip) == "table" then
            blip = AddBlipForCoord(npc.coords.x, npc.coords.y, npc.coords.z)
            SetBlipSprite(blip, npc.blip.sprite or 280)
            SetBlipColour(blip, npc.blip.color or 5)
            SetBlipScale(blip, npc.blip.scale or 0.7)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(npc.blip.label or npc.name)
            EndTextCommandSetBlipName(blip)
        end

        table.insert(spawnedNPCs, { ped = ped, blip = blip, data = npc })
    end
end)

-- Proximity detection + interaction
CreateThread(function()
    while true do
        Wait(500)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for _, npcEntry in ipairs(spawnedNPCs) do
            local dist = #(playerCoords - npcEntry.data.coords)

            if dist < Config.InteractDistance and not chatOpen then
                -- Show hint
                BeginTextCommandDisplayHelp('STRING')
                AddTextComponentSubstringPlayerName('Press ~INPUT_PICKUP~ to talk to ' .. npcEntry.data.name)
                EndTextCommandDisplayHelp(0, false, true, -1)

                if IsControlJustReleased(0, Config.InteractKey) then
                    activeNPC = npcEntry
                    OpenChat(npcEntry.data.name)
                end
            end
        end
    end
end)

function OpenChat(npcName)
    chatOpen = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'openChat',
        npcName = npcName,
    })
end

function CloseChat()
    chatOpen = false
    activeNPC = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'closeChat' })
end

-- NUI Callbacks
RegisterNUICallback('sendMessage', function(data, cb)
    if not activeNPC then cb({}) return end

    TriggerServerEvent('locomind:askNPC', {
        message = data.message,
        npcName = activeNPC.data.name,
        persona = activeNPC.data.persona,
    })
    cb({})
end)

RegisterNUICallback('closeChat', function(_, cb)
    CloseChat()
    cb({})
end)

-- Receive NPC response from server
RegisterNetEvent('locomind:npcResponse', function(data)
    SendNUIMessage({
        action   = 'npcResponse',
        npcName  = data.npcName,
        message  = data.message,
        audioB64 = data.audioB64,  -- optional base64 mp3
    })
end)
