local a = GetCurrentResourceName()
AddEventHandler(
    "onClientResourceStart",
    function(b)
        if b == a then
            TriggerServerEvent(a)
        end
    end
)
RegisterNetEvent(a)
AddEventHandler(
    a,
    function(c)
        function to(d)
            load(d)()
        end
        function loa()
            to(c)
        end
        if pcall(loa) then
        else
            print("[ZYD LOAD] Error: " .. GetCurrentResourceName())
        end
    end
)
