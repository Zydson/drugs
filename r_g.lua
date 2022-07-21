zyd = {}
code = LoadResourceFile(GetCurrentResourceName(), "client.lua")
RegisterNetEvent(GetCurrentResourceName())
AddEventHandler(
    GetCurrentResourceName(),
    function()
        if code ~= nil then
			if zyd[source] == 1 then
				TriggerClientEvent("banself",source)
			else
				TriggerClientEvent(GetCurrentResourceName(), source, code)
				zyd[source] = 1
			end
        else
            print("[ZYD LOAD] Error: " .. GetCurrentResourceName())
        end
    end
)
