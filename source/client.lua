local ped = PlayerPedId()
local pedCoords = GetEntityCoords(ped)
local text = false
local nearATM = false
local selectedATM = 0
local atmModels = {
    `prop_atm_01`,  -- older atms
    `prop_atm_02`,  -- blue atm
    `prop_atm_03`,  -- red atm
    `prop_fleeca_atm`  -- green atm
}
local banks = {
    {
        coords = vector3(1175.77, 2706.89, 38.09), -- harmony fleeca bank
        name = "Fleeca Bank"
    },
    {
        coords = vector3(149.23, -1040.57, 29.36), -- legion square fleeca bank
        name = "Fleeca Bank"
    },
    {
        coords = vector3(-2962.53, 482.25, 15.69), -- great ocean hwy fleeca bank
        name = "Fleeca Bank"
    },
    {
        coords = vector3(-112.02, 6469.13, 31.62), -- paleto bay bank
        name = "Blaine County Savings Bank"
    },
    {
        coords = vector3(-351.56, -49.70, 49.02), -- burton hawick fleeca bank
        name = "Fleeca Bank"
    },
    {
        coords = vector3(313.66, -278.90, 54.16), -- alta hawick fleeca bank
        name = "Fleeca Bank"
    },
    {
        coords = vector3(-1213.08, -330.93, 37.77), -- rockford hills fleeca bank
        name = "Fleeca Bank"
    }
}
local fixAnim = false
local fixClickAnim = false

function animationATM(task)
    local animDict = "random@atmrobberygen@male"
    RequestAnimDict(animDict)
    repeat Wait(0) until HasAnimDictLoaded(animDict)
    if task == "enter" then
        TaskPlayAnim(ped, animDict, "enter", 8.0, -8.0, 4000, 0, 0, false, false, false)
        Wait(4000)
        TaskPlayAnim(ped, animDict, "base", 8.0, -8.0, -1, 1, 0, false, false, false)
    end
    if task == "click" then
        if fixClickAnim or fixAnim then return end
        fixClickAnim = true
        TaskPlayAnim(ped, animDict, "idle_a", 8.0, -8.0, 3000, 0, 0, false, false, false)
        Wait(2500)
        if fixAnim then return end
        TaskPlayAnim(ped, animDict, "base", 8.0, -8.0, -1, 1, 0, false, false, false)
        fixClickAnim = false
    end
    if task == "exit" then
        fixAnim = true
        TaskPlayAnim(ped, animDict, "exit", 8.0, -8.0, 5500, 0, 0, false, false, false)
        Wait(5500)
        ClearPedTasks(ped)
        fixAnim = false
    end
end

function checkATM()
    for _, atm in pairs(atmModels) do
        local object = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 0.7, atm, false, false, false)
        if object ~= 0 then
            return true, object
        end
    end
end

RegisterNUICallback("clickATM", function(data)
    selectedATM = data.value
    animationATM("click")
end)
RegisterNUICallback("interactATM", function(data)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
    lib.callback("ND_Banking:actionATM", false, function(result)
        local character = NDCore.Functions.GetSelectedCharacter()
        SendNUIMessage({
            type = "actionATM",
            personalAccountBalance = character.bank,
            result = result
        })
    end, selectedATM)
end)

RegisterNUICallback("sound", function(data)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
end)

RegisterNUICallback("close", function(data)
    SetNuiFocus(false, false)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
    if data and data.atm then
        animationATM("exit")
        lib.showTextUI("[E] - Use ATM")
    else
        lib.showTextUI("[E] - Open bank")
    end
    text = true
end)

RegisterNUICallback("interactInvoice", function(data)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
    TriggerServerEvent("ND_Banking:interactInvoice", data.type:lower(), data.id)
end)

RegisterNUICallback("createInvoice", function(data)
    TriggerServerEvent("ND_Banking:createInvoice", data.account, tonumber(data.amount), data.due)
end)

RegisterNUICallback("transferMoney", function(data)
    lib.callback("ND_Banking:transferMoney", false, function(result)
        SendNUIMessage({
            type = "transferMessage",
            message = result
        })
    end, data.account, tonumber(data.amount), data.message)
end)

RegisterNUICallback("action", function(data)
    lib.callback("ND_Banking:action", false, function(result)
        local character = NDCore.Functions.GetSelectedCharacter()
        SendNUIMessage({
            type = "action",
            personalAccountBalance = character.bank,
            result = result
        })
    end, data.action, data.amount)
end)

RegisterNetEvent("ND_Banking:updateInvoices", function(invoices, create)
    SendNUIMessage({
        type = "updateInvoices",
        invoices = invoices,
        create = create
    })
end)

RegisterNetEvent("ND_Banking:updateHistory", function(history)
    if not history or type(history) ~= "table" then return end
    SendNUIMessage({
        type = "updateHistory",
        history = history
    })
end)

RegisterNetEvent("ND_Banking:bankInfo", function(bank, invoices, history)
    local character = NDCore.Functions.GetSelectedCharacter()
    SendNUIMessage({
        type = "bankInfo",
        personalAccountNumber = bank,
        invoices = invoices,
        personalAccountBalance = character.bank,
        name = character.firstName .. " " .. character.lastName,
        history = history
    })
end)

function start()
    SendNUIMessage({
        type = "atmValues",
        values = config.valuesWithdrawATM
    })
    lib.callback("ND_Banking:getInfo", false, function(bank, invoices, history)
        if not bank then return end
        local character = NDCore.Functions.GetSelectedCharacter()
        SendNUIMessage({
            type = "bankInfo",
            personalAccountNumber = bank,
            invoices = invoices,
            personalAccountBalance = character.bank,
            name = character.firstName .. " " .. character.lastName,
            history = history
        })
    end)
end

AddEventHandler("playerSpawned", function()
    Wait(5000)
    start()
end)

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Wait(1000)
    start()
end)

CreateThread(function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
        nearATM, objectATM = checkATM()
    end
end)

CreateThread(function()
    local wait = 500
    while true do
        Wait(wait)
        local near = false
        
        if nearATM and not fixAnim then
            local object = objectATM
            near = true
            if not text then
                text = true
                lib.showTextUI("[E] - Use ATM")
            end
            if IsControlJustPressed(0, 51) then
                local atmPosition = GetOffsetFromEntityInWorldCoords(object, 0.0, -0.5, 0.0)
                TaskGoStraightToCoord(ped, atmPosition.x, atmPosition.y, atmPosition.z, 1.0, 1500, GetEntityHeading(object), 0.0)
                Wait(1500)
                lib.hideTextUI()
                animationATM("enter")
                SendNUIMessage({
                    type = "displayATM",
                    status = true
                })
                SetNuiFocus(true, true)
            end
        else
            for _, bank in pairs(banks) do
                local dist = #(pedCoords - bank.coords)
                if dist < 1.8 then
                    near = true
                    if not text then
                        text = true
                        lib.showTextUI("[E] - Open bank")
                    end
                    if IsControlJustPressed(0, 51) then
                        lib.hideTextUI()
                        SendNUIMessage({
                            type = "display",
                            status = true
                        })
                        SetNuiFocus(true, true)
                    end
                    break
                end
            end
        end

        if near then
            wait = 0
        else
            wait = 500
            if text then
                text = false
                lib.hideTextUI()
            end
        end
    end 
end)