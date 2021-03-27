menuOpened, menuCat, menus = false, "drugsbuilder", {}

local builder = {
    -- Valeur de base
    name = nil,
    rawItem = nil,
    treatedItem = nil,

    -- Valeur numériques
    harvestCount = nil,
    treatmentCount = nil,
    treatmentReward = nil,
    sellCount = nil,
    sellRewardPerCount = nil,

    -- Potisions
    harvest = nil,
    treatement = nil,
    vendor = nil,
}

local function input(TextEntry, ExampleText, MaxStringLenght, isValueInt)
    
	AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
	DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght) 
	blockinput = true

	while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
		Citizen.Wait(0)
	end
		
	if UpdateOnscreenKeyboard() ~= 2 then
		local result = GetOnscreenKeyboardResult() 
		Citizen.Wait(500) 
		blockinput = false 
        if isValueInt then 
            local isNumber = tonumber(result)
            if isNumber then return result else return nil end
        end

		return result
	else
		Citizen.Wait(500)
		blockinput = false 
		return nil
	end
end

local function canCreateDrug()
    return name ~= nil and name ~= "" and harvestCount ~= nil and harvestCount >= 1 and treatmentCount ~= nil and treatmentCount >= 1 and treatmentReward ~= nil and treatmentReward >= 1 and sellCount ~= nil and sellCount >= 1 and sellRewardPerCount ~= nil and sellRewardPerCount >= 1 and harvest ~= nil and treatement ~= nil and vendor ~= nil
end

local function subCat(string)
    return menuCat.."_"..string
end

local function addMenu(name)
    RMenu.Add(menuCat, subCat(name), RageUI.CreateMenu("DrugsBuilder","~r~Gestion des drogues"))
    RMenu:Get(menuCat, subCat(name)).Closed = function()end
    table.insert(menus, name)
end

local function addSubMenu(name, depend)
    RMenu.Add(menuCat, subCat(name), RageUI.CreateSubMenu(RMenu:Get(menuCat, subCat(depend)), "DrugsBuilder", "~r~Gestion des drogues"))
    RMenu:Get(menuCat, subCat(name)).Closed = function()end
    table.insert(menus, name)
end

local function valueNotDefault(value)
    if not value or value == "" then return "" else return "~s~: ~g~"..tostring(value) end
end

local function okIfDef(value)
    if not value or value == "" then return "" else return "~s~: ~g~Défini" end
end

local function delMenus()
    for k,v in pairs(menus) do 
        RMenu:Delete(menuCat, v)
    end
end

function openMenu(drugs) 
    local colorVar = "~s~"
    local actualColor = 1
    local colors = {"~p~", "~r~","~o~","~y~","~c~","~g~","~b~"}

    menuOpened = true
    addMenu("main")
    addSubMenu("builder", "main")
    RageUI.Visible(RMenu:Get(menuCat, subCat("main")), true)

    Citizen.CreateThread(function()
        while menuOpened do
            Wait(800)
            if colorVar == "~s~" then colorVar = "~r~" else colorVar = "~s~" end
        end
    end)

    Citizen.CreateThread(function()
        while menuOpened do 
            Wait(500)
            actualColor = actualColor + 1
            if actualColor > #colors then actualColor = 1 end
        end
    end)

    Citizen.CreateThread(function()
        while menuOpened do
            local shouldClose = true
            RageUI.IsVisible(RMenu:Get(menuCat,subCat("main")),true,true,true,function()
                shouldClose = false
                RageUI.Separator("↓ ~o~Gestion des drogues ~s~↓")
                local total = 0
                for _,_ in pairs(drugs) do
                    total = total + 1
                end
                if total <= 0 then
                    RageUI.ButtonWithStyle(colorVar.."Aucune drogue active", nil, {}, true, function() end)
                else
                    for drugID, drugsInfos in pairs(drugs) do
                        RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~"..drugsInfos.name, nil, {RightLabel = "~r~Supprimer ~s~→→"}, true, function(_,_,s)
                            if s then
                                shouldClose = true
                                TriggerServerEvent("drugsbuilder_deletedrug", drugID)
                            end
                        end)
                    end
                end
                RageUI.Separator("↓ ~y~Création d'une drogue ~s~↓")
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Créer une drogue", nil, {}, true, function(_,_,s)

                end, RMenu:Get(menuCat, subCat("builder")))
            end, function()    
            end, 1)

            RageUI.IsVisible(RMenu:Get(menuCat,subCat("builder")),true,true,true,function()
                shouldClose = false
                -- Informations de base
                RageUI.Separator("↓ ~g~Informations de base ~s~↓")
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Nom de la drogue"..valueNotDefault(builder.name), "~y~Description: ~s~vous permets de définir le nom de votre drogue", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, false)
                        if result ~= nil then builder.name = result end
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Item non traité"..valueNotDefault(builder.rawItem), "~y~Description: ~s~vous permets de définir l'item non traité", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, false)
                        if result ~= nil then builder.rawItem = result end
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Item traité"..valueNotDefault(builder.treatedItem), "~y~Description: ~s~vous permets de définir l'item traité", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, false)
                        if result ~= nil then builder.treatedItem = result end
                    end
                end)
                -- Valeur numériques
                RageUI.Separator("↓ ~y~Valeur numériques ~s~↓")
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Récompense récolte"..valueNotDefault(builder.harvestCount), "~y~Description: ~s~vous permets de définir la récompense (x items) pour une récolte", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, true)
                        if result ~= nil then builder.harvestCount = result end
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Nécéssaire traitement"..valueNotDefault(builder.treatmentCount), "~y~Description: ~s~vous permets de définir combien de votre drogue sont nécéssaire pour la transformer", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, true)
                        if result ~= nil then builder.treatmentCount = result end
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Récompense traitement"..valueNotDefault(builder.treatmentReward), "~y~Description: ~s~vous permets de définir la récompense (x items) pour un traitement", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, true)
                        if result ~= nil then builder.treatmentReward = result end
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Nécéssaire revente"..valueNotDefault(builder.sellCount), "~y~Description: ~s~vous permets de définir combien de votre drogue sont nécéssaire pour la vendre", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, true)
                        if result ~= nil then builder.sellCount = result end
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Récompense revente"..valueNotDefault(builder.sellRewardPerCount), "~y~Description: ~s~vous permets de définir la récompense (x items) pour une revente", {}, true, function(_,_,s)
                    if s then
                        local result = input("Drugs builder", "", 20, true)
                        if result ~= nil then builder.sellRewardPerCount = result end
                    end
                end)
                -- Positions et points
                RageUI.Separator("↓ ~o~Configuration des points ~s~↓")
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Position récolte"..okIfDef(builder.harvest), "~y~Description: ~s~vous permets de définir la position de la récolte", {RightLabel = "~b~Définir ~s~→→"}, true, function(_,_,s)
                    if s then
                        local pos = GetEntityCoords(PlayerPedId())
                        builder.harvest = {x = pos.x, y = pos.y, z = pos.z}
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Position traitement"..okIfDef(builder.treatement), "~y~Description: ~s~vous permets de définir la position du traitement", {RightLabel = "~b~Définir ~s~→→"}, true, function(_,_,s)
                    if s then
                        local pos = GetEntityCoords(PlayerPedId())
                        builder.treatement = {x = pos.x, y = pos.y, z = pos.z}
                    end
                end)
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~s~Position revente"..okIfDef(builder.vendor), "~y~Description: ~s~vous permets de définir la position de la revente", {RightLabel = "~b~Définir ~s~→→"}, true, function(_,_,s)
                    if s then
                        local pos = GetEntityCoords(PlayerPedId())
                        builder.vendor = {x = pos.x, y = pos.y, z = pos.z}
                    end
                end)
                -- Interactions
                RageUI.Separator("↓ ~r~ Actions ~s~↓")
                RageUI.ButtonWithStyle(colors[actualColor].."→ ~g~Sauvegarder et appliquer", "~y~Description: ~s~une fois toutes les étapes effectuées, sauvegardez votre drogue", {RightLabel = "→→"}, true, function(_,_,s)
                    if s then
                        shouldClose = true
                        ESX.ShowNotification("~o~Création de la drogue en cours...")
                        TriggerServerEvent("drugsbuilder_create", builder)
                    end
                end)
            end, function()    
            end, 1)


            if shouldClose and menuOpened then
                menuOpened = false
            end

            Wait(0)
        end

        delMenus()
    end)
end