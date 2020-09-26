ESX = nil
local tabletObject = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end

	while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

	ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('passInfo')
AddEventHandler('passInfo', function(info)
	SetNuiFocus(true, true)
	local data = {
		type = "result",
		firstName = info.firstName,
		lastName = info.lastName,
		dob = info.dob,
		allergies = info.allergies,
		injuries = info.injuries
	}
	SendNUIMessage(data)
end)

RegisterNetEvent('Response')
AddEventHandler('Response', function(message)
	SendNUIMessage({
		type = "response",
		message = message
	})
end)

function openCad()
	SendNUIMessage({
		type = "enableGUI"
	})
	SetNuiFocus(true, true)
end

function disableMenu()
	SendNUIMessage({
		type = "close"
	})
	SetNuiFocus(false, false)
end

function newForm()
	SendNUIMessage({
		type = "new"
	})
	SetNuiFocus(true, true)
end

RegisterNUICallback('close', function()
    print("Close LUA")
	disableMenu()
	local playerPed = PlayerPedId()
	DeleteEntity(tabletObject)
	ClearPedTasks(playerPed)
	tabletObject = nil
end)


RegisterNUICallback('new', function()
	newForm()
end)

RegisterNUICallback('search', function(data, cb)
	TriggerServerEvent('GetPtInfo', data)
end)

RegisterNUICallback('save', function(data, cb)
	if data.form == "newForm" then
		TriggerServerEvent('SavePtInfo', data)
	elseif data.form == "updateForm" then
		TriggerServerEvent('UpdatePtInfo', data)
	end
end)

RegisterNUICallback('delete', function(data, cb)
	TriggerServerEvent('DeletePtInfo', data)	
end)

RegisterCommand('ems-cad', function()
	if ESX.GetPlayerData().job and ESX.GetPlayerData().job.name == 'ambulance' then
		print('bilo')
		local playerPed = PlayerPedId()
			local dict = "amb@world_human_seat_wall_tablet@female@base"
			RequestAnimDict(dict)
			if tabletObject == nil then
				tabletObject = CreateObject(GetHashKey('prop_cs_tablet'), GetEntityCoords(playerPed), 1, 1, 1)
				AttachEntityToEntity(tabletObject, playerPed, GetPedBoneIndex(playerPed, 28422), 0.0, 0.0, 0.03, 0.0, 0.0, 0.0, 1, 1, 0, 1, 0, 1)
			end
			while not HasAnimDictLoaded(dict) do Citizen.Wait(100) end
			if not IsEntityPlayingAnim(playerPed, dict, 'base', 3) then
				TaskPlayAnim(playerPed, dict, "base", 8.0, 1.0, -1, 49, 1.0, 0, 0, 0)
			end
		openCad()
	end
end)
