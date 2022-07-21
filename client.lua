CreateThread(function()
Token = {}
local a = GetCurrentResourceName()..":token"
TriggerServerEvent(a)
RegisterNetEvent(a)
AddEventHandler(a,function(b)
	_G["setToken"](b)
end)
_G["setToken"] = function(c)
	Token = c
end
end)
ESX = exports["es_extended"]:getSharedObject()

Config = {}
Config.Language = "PL" -- ENG/PL

Config.Drugs = { -- TYPES: Pick/Transform
	WeedP = {
		Coords = vector3(-615,-886,24.5),
		Type = "Pick",
		Item = "weed",
		Quantity = 2,
		Time = 5000, -- Ms
	},
	WeedT = {
		Coords = vector3(-624, -895, 23.5),
		Type = "Transform",
		Item = "weed",
		TransormC = "weedpack",
		Quantity = 5,
		Time = 7500,
	}
}

CreateThread(function()
	while true do
		Pid = PlayerPedId()
		Pcoords = GetEntityCoords(Pid)
		Wait(1500)
	end
end)

Working = false
AntiBug = false
CreateThread(function()
	while true do
		Wait(1)
		Can = false
		inMarker = nil
		for a,b in pairs(Config.Drugs) do
			local dist = #(Pcoords-b.Coords)
			if dist < 12.0 then
				DrawMarker(1, b.Coords, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 3.5, 3.5, 0.5, 255, 128, 0, 50, false, true, 2, nil, nil, false)
				inMarker = b
				if dist < 2.5 then
					if not Working then
						if inMarker.Type == "Pick" then
							ESX.ShowHelpNotification(Translation[Config.Language].Pick)
						elseif inMarker.Type == "Transform" then
							ESX.ShowHelpNotification(Translation[Config.Language].Transform)
						end
					else
						if inMarker.Type == "Pick" then
							ESX.ShowHelpNotification(Translation[Config.Language].PickStop)
						elseif inMarker.Type == "Transform" then
							ESX.ShowHelpNotification(Translation[Config.Language].TransformStop)
						end
					end
					Can = true
				else
					Can = false
				end
			end
		end
		if inMarker == nil then
			Wait(2000)
		end
	end
end)

RegisterCommand("+--+drugs",function()
	if Can and not Working and not AntiBug then
		TriggerServerEvent("zyd:drugs", inMarker, Token)
		Working = true
		FreezeEntityPosition(PlayerPedId(),true)
	elseif Working then
		Working = false
		TriggerServerEvent("zyd:drugs", "stop", Token)
		FreezeEntityPosition(PlayerPedId(),false)
		AntiBug = true
		Wait(7500)
		AntiBug = false
	end
end)
RegisterKeyMapping("+--+drugs", "ZYD-Drugs", 'keyboard', "E")

RegisterNetEvent("zyd:drugs")
AddEventHandler("zyd:drugs",function(state)
	Working = false
	TriggerServerEvent("zyd:drugs", "stop", Token)
	FreezeEntityPosition(PlayerPedId(),false)
end)