ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(0)
	end
	TriggerServerEvent("drugsbuilder_requestDrugs")
	startMakerLoop()
end)

RegisterNetEvent("drugsbuilder_openMenu")
AddEventHandler("drugsbuilder_openMenu", function(drugs)
	if not menuOpened then openMenu(drugs) end
end)

RegisterNetEvent("drugsbuilder_updateDrugs")
AddEventHandler("drugsbuilder_updateDrugs", function(drugs)
	updateDrugs(drugs)
end)

