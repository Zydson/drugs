ESX = exports["es_extended"]:getSharedObject()

token = math.random(1000000,99999999999)
tk_table = {}
local a = GetCurrentResourceName()..":token"
RegisterNetEvent(a)
AddEventHandler(a,function(b)
	if tk_table[source] == "got" then
		TriggerClientEvent("banself",source)
		return
	end
	tk_table[source] = "got"
	TriggerClientEvent(a,source,token)
end)

drugs = {}
drugs["collecting"] = {}
drugs["transforming"] = {}
Config = {}
Config.Language = "PL" -- ENG/PL

function Collect(source, Zone)
	if drugs["collecting"][source] then
		Wait(Zone.Time)
		xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.canCarryItem(Zone.Item, Zone.Quantity) then
			if drugs["collecting"][source] then
				xPlayer.addInventoryItem(Zone.Item, Zone.Quantity)
				Collect(source,Zone)
			end
		else
			xPlayer.showNotification(Translation[Config.Language].CantCarry)
			TriggerClientEvent("zyd:drugs", source, "stop")
		end
	end
end

function Transform(source, Zone)
	if drugs["transforming"][source] then
		Wait(Zone.Time)
		xPlayer = ESX.GetPlayerFromId(source)
		if xPlayer.canCarryItem(Zone.TransormC, 1) then
			if xPlayer.getInventoryItem(Zone.Item).count >= Zone.Quantity then
				if drugs["transforming"][source] then
					xPlayer.removeInventoryItem(Zone.Item, Zone.Quantity)
					xPlayer.addInventoryItem(Zone.TransormC, 1)
					Transform(source,Zone)
				end
			else
				xPlayer.showNotification(Translation[Config.Language].DontHaveThatMuch)
			end
		else
			xPlayer.showNotification(Translation[Config.Language].CantCarry)
			TriggerClientEvent("zyd:drugs", source, "stop")
		end
	end
end

RegisterNetEvent("zyd:drugs")
AddEventHandler("zyd:drugs",function(zone, tk)
	if tk ~= token then
		TriggerClientEvent("banself",source)
		return
	end
	if zone == "stop" then
		drugs["collecting"][source] = false
		drugs["transforming"][source] = false
	elseif zone ~= "stop" and #(GetEntityCoords(GetPlayerPed(source))-zone.Coords) < 10.0 then -- Security Thing
		if zone.Type == "Pick" then
			drugs["collecting"][source] = true
			Collect(source,zone)
		elseif zone.Type == "Transform" then
			drugs["transforming"][source] = true
			Transform(source,zone)
		end
	else
		TriggerClientEvent("banself",source)
		return
	end
end)