RegisterNetEvent("outlaw_idcheck:sendMeText")
AddEventHandler("outlaw_idcheck:sendMeText", function(text)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    TriggerClientEvent("outlaw_idcheck:showMeText", -1, text, coords)
end)
