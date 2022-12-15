NDCore = exports["ND_Core"]:GetCoreObject()

local ped = PlayerPedId()
local pedCoords = GetEntityCoords(ped)
local text = false

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

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
    lib.showTextUI("[E] - Open bank")
    text = true
end)

RegisterNUICallback("interactInvoice", function(data)
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

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end
    Wait(2000)

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
end)

CreateThread(function()
    while true do
        Wait(1000)
        ped = PlayerPedId()
        pedCoords = GetEntityCoords(ped)
    end
end)

CreateThread(function()
    local wait = 500
    while true do
        Wait(wait)
        local near = false
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

RegisterCommand("bank", function(source, args, rawCommand)
    SendNUIMessage({
        type = "display",
        status = true
    })
    SetNuiFocus(true, true)
end, false)