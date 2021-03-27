local drugs = {}
local cooldown = false

local function help(str)
    AddTextEntry("DRUGS", str)
    DisplayHelpTextThisFrame("DRUGS", 0)
end

local function onInteract()
    cooldown = true
    Citizen.SetTimeout(200, function() cooldown = false end)
end

function updateDrugs(infos)
    drugs = infos
end

function startMakerLoop()
    local interval = 1
    Citizen.CreateThread(function()
        while true do
            local pCords = GetEntityCoords(PlayerPedId())
            local closeToMarker = false
            for drugID, drugInfos in pairs(drugs) do
                local type = "Harvest"
                local distance = GetDistanceBetweenCoords(drugInfos.harvest.x, drugInfos.harvest.y, drugInfos.harvest.z, pCords, true)
                if distance <= 2.0 then
                    closeToMarker = true
                    DrawMarker(22, drugInfos.harvest.x, drugInfos.harvest.y, drugInfos.harvest.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255,0,0, 255, 55555, false, true, 2, false, false, false, false)
                    if distance <= 1.0 then
                        help("Appuyez sur ~INPUT_CONTEXT~ pour récolter: ~b~"..drugInfos.name)
                        if IsControlJustPressed(0, 51) then
                            if not cooldown then
                                onInteract()
                                print(drugID)
                                TriggerServerEvent("drugsbuilder_on"..type, drugID)
                            end
                        end
                    end
                end

                type = "Transform"
                distance = GetDistanceBetweenCoords(drugInfos.treatement.x, drugInfos.treatement.y, drugInfos.treatement.z, pCords, true)
                if distance <= 2.0 then
                    closeToMarker = true
                    DrawMarker(22, drugInfos.treatement.x, drugInfos.treatement.y, drugInfos.treatement.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255,0,0, 255, 55555, false, true, 2, false, false, false, false)
                    if distance <= 1.0 then
                        help("Appuyez sur ~INPUT_CONTEXT~ pour traiter: ~b~"..drugInfos.name)
                        if IsControlJustPressed(0, 51) then
                            if not cooldown then
                                onInteract()
                                TriggerServerEvent("drugsbuilder_on"..type, drugID)
                            end
                        end
                    end
                end

                type = "Sell"
                distance = GetDistanceBetweenCoords(drugInfos.vendor.x, drugInfos.vendor.y, drugInfos.vendor.z, pCords, true)
                if distance <= 2.0 then
                    closeToMarker = true
                    DrawMarker(22, drugInfos.vendor.x, drugInfos.vendor.y, drugInfos.vendor.z, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255,0,0, 255, 55555, false, true, 2, false, false, false, false)
                    if distance <= 1.0 then
                        help("Appuyez sur ~INPUT_CONTEXT~ pour vendre: ~b~"..drugInfos.name)
                        if IsControlJustPressed(0, 51) then
                            if not cooldown then
                                onInteract()
                                TriggerServerEvent("drugsbuilder_on"..type, drugID)
                            end
                        end
                    end
                end
            end
            if closeToMarker then interval = 1 else interval = 500 end
            Wait(interval)
        end
    end)
end