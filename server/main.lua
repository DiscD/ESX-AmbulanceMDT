ESX              = nil
local PlayerData = {}

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
end)



function GrabData(data, callback) 
    MySQL.Async.fetchAll('SELECT * FROM `patients` WHERE `firstName` = @firstName AND `lastName` = @lastName',
    {
        ['@firstName'] = data.firstName,
        ['@lastName'] = data.lastName
    }, function(patient_info)
        if patient_info ~= nil then
            callback(patient_info[1])
        end
    end)	
end

RegisterServerEvent('SavePtInfo') 
AddEventHandler('SavePtInfo', function(data)
    _source = source
    GrabData(data, function(info)
        if info == nil then
            MySQL.Async.execute('INSERT INTO `patients` VALUES (@firstName, @lastName, @dob, @allergies, @injuries)',
            {
                ['@firstName'] = data.firstName,
                ['@lastName'] = data.lastName,
                ['@dob']  = data.dob,
                ['@allergies'] = data.allergies,
                ['@injuries'] = data.injuries
            }, function(cb)
            end)
        else
            TriggerClientEvent('Response', _source, "המטופל כבר קיים במערכת") 
        end

    end)
end)

RegisterServerEvent('UpdatePtInfo')
AddEventHandler('UpdatePtInfo', function(ptInfo)
    if ptInfo.injuries == nil then
        return
    end
    GrabData(ptInfo, function(info)
        if info ~= nil then
            MySQL.Async.execute('UPDATE `patients` SET `injuries` = CONCAT(@injuries, @pastInjuries), `allergies` = @allergies WHERE `firstName` = @firstName AND `lastName` = @lastName',
            {
                ['@firstName'] = ptInfo.firstName,
                ['@lastName'] = ptInfo.lastName,
                ['@injuries'] = ptInfo.injuries,
                ['@pastInjuries'] = info.injuries,
                ['@allergies'] = ptInfo.allergies
            })
        end
    end)
end)

RegisterServerEvent('GetPtInfo')
AddEventHandler('GetPtInfo', function(data)
    _source = source
    GrabData(data, function(patientInfo)
        if patientInfo ~= nil then
            TriggerClientEvent('passInfo', _source, patientInfo)
        else
            TriggerClientEvent('Response', _source, "טופס אינו נמצא")
        end
    end)		
end)

RegisterServerEvent('DeletePtInfo')
AddEventHandler('DeletePtInfo', function(data)
    MySQL.Async.execute('DELETE FROM `patients` WHERE `firstName` = @firstName AND `lastName` = @lastName',
    {
        ['@firstName'] = data.firstName,
        ['@lastName'] = data.lastName
    }, function()
        TriggerClientEvent('Response', _source, "הטופס נמחק בהצלחה")
    end)
end)
