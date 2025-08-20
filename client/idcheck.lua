local showIDs = false
local lastMeTime = 0
local meCooldown = 5000
local displayRadius = 9.0

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        showIDs = IsControlPressed(0, 121)

        if showIDs then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local players = GetActivePlayers()

            for _, player in ipairs(players) do
                local ped = GetPlayerPed(player)
                if DoesEntityExist(ped) then
                    local targetCoords = GetEntityCoords(ped)
                    local dist = #(playerCoords - targetCoords)

                    if dist <= displayRadius then
                        local playerId = GetPlayerServerId(player)
                        local isTalking = NetworkIsPlayerTalking(player)
                        local color = isTalking and {38, 95, 186, 217} or {255, 255, 255, 215}
                        local textCoords = vector3(targetCoords.x, targetCoords.y, targetCoords.z + 1.0)

                        DrawText3D(textCoords.x, textCoords.y, textCoords.z, "" .. playerId, color)
                    end
                end
            end

            local currentTime = GetGameTimer()
            if currentTime - lastMeTime > meCooldown then
                ExecuteCommand('me Uurib pingsalt ümbrust')
                lastMeTime = currentTime
            end
        end
    end
end)

function DrawText3D(x, y, z, text, rgba, options)
    local opts = options or {}
    local displayRadius = opts.displayRadius or 20.0
    local scaleMultiplier = opts.scaleMultiplier or 4.5 
    local font = opts.font or 4 

    if not text or type(text) ~= "string" then
        return
    end
    if not rgba or type(rgba) ~= "table" or #rgba < 4 then
        return
    end
    local r, g, b, a = math.floor(rgba[1] or 255), math.floor(rgba[2] or 255), math.floor(rgba[3] or 255), math.floor(rgba[4] or 255)

    local onScreen, screenX, screenY = GetScreenCoordFromWorldCoord(x, y, z)
    local camCoords = GetGameplayCamCoords()
    local dist = #(camCoords - vector3(x, y, z))

    if onScreen and dist < displayRadius then
        local scale = (1 / dist) * scaleMultiplier
        scale = scale * (GetGameplayCamFov() / 100)
        SetTextScale(0.9 * scale, 0.9 * scale)
        SetTextFont(font)
        SetTextProportional(1)
        SetTextColour(r, g, b, a)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextCentre(true)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentString(text)
        EndTextCommandDisplayText(screenX, screenY)
    end
end