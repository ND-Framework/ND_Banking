NDCore = exports["ND_Core"]:GetCoreObject()

RegisterCommand("bank", function(source, args, rawCommand)
    SendNUIMessage({
        type = "display",
        status = true
    })
    SetNuiFocus(true, true)
end, false)

RegisterNUICallback("close", function()
    SetNuiFocus(false, false)
    PlaySoundFrontend(-1, "PIN_BUTTON", "ATM_SOUNDS", 1)
end)

RegisterNUICallback("interactInvoice", function(data)
    TriggerServerEvent("ND_Banking:interactInvoice", data.type:lower(), data.id)
end)

RegisterNUICallback("createInvoice", function(data)
    TriggerServerEvent("ND_Banking:createInvoice", data.account, tonumber(data.amount), data.due)
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