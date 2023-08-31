local pedCoords
local usingTarget = false
local text = false
local nearATM = false
local selectedATM = 0
local bankPeds = {}
local atmModels = {
    `prop_atm_01`,  -- older atms
    `prop_atm_02`,  -- blue atm
    `prop_atm_03`,  -- red atm
    `prop_fleeca_atm`  -- green atm
}
local banks = {
    {
        coords = vec4(1174.95, 2708.23, 38.08, 179.02), -- route 68 fleeca bank
        name = "Fleeca Bank",
        model = `a_m_y_busicas_01`,
        clothing = {
            badge = {
                drawable = 0,
                texture = 0
            },
            leg = {
                drawable = 0,
                texture = 1
            },
            bag = {
                drawable = 0,
                texture = 0
            },
            mask = {
                drawable = 0,
                texture = 0
            },
            face = {
                drawable = 0,
                texture = 0
            },
            hair = {
                drawable = 0,
                texture = 2
            },
            undershirt = {
                drawable = 0,
                texture = 0
            },
            kevlar = {
                drawable = 0,
                texture = 0
            },
            accessory = {
                drawable = 0,
                texture = 0
            },
            torso2 = {
                drawable = 0,
                texture = 0
            },
            torso = {
                drawable = 0,
                texture = 2
            },
            shoes = {
                drawable = 0,
                texture = 0
            },
            ears = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            bracelets = {
                drawable = -1,
                texture = -1
            },
            hat = {
                drawable = -1,
                texture = -1
            },
        }
    },
    {
        coords = vec4(149.46, -1042.06, 29.36, 339.52), -- legion square fleeca bank
        name = "Fleeca Bank",
        model = `a_m_y_business_01`,
        clothing = {
            torso = {
                drawable = 0,
                texture = 1
            },
            shoes = {
                drawable = 0,
                texture = 0
            },
            accessory = {
                drawable = 0,
                texture = 0
            },
            face = {
                drawable = 0,
                texture = 0
            },
            torso2 = {
                drawable = 1,
                texture = 2
            },
            mask = {
                drawable = 0,
                texture = 0
            },
            badge = {
                drawable = 0,
                texture = 0
            },
            undershirt = {
                drawable = 0,
                texture = 0
            },
            bag = {
                drawable = 0,
                texture = 0
            },
            kevlar = {
                drawable = 0,
                texture = 0
            },
            hair = {
                drawable = 0,
                texture = 0
            },
            leg = {
                drawable = 0,
                texture = 1
            },
            ears = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = 1,
                texture = 1
            },
            bracelets = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            hat = {
                drawable = -1,
                texture = -1
            },
        }
    },
    {
        coords = vec4(-2961.14, 482.90, 15.69, 88.35), -- great ocean hwy fleeca bank
        name = "Fleeca Bank",
        model = `a_f_y_business_04`,
        clothing = {
            torso = {
                drawable = 1,
                texture = 1
            },
            shoes = {
                drawable = 0,
                texture = 0
            },
            accessory = {
                drawable = 0,
                texture = 0
            },
            face = {
                drawable = 0,
                texture = 0
            },
            torso2 = {
                drawable = 0,
                texture = 0
            },
            mask = {
                drawable = 0,
                texture = 0
            },
            badge = {
                drawable = 0,
                texture = 0
            },
            undershirt = {
                drawable = 0,
                texture = 0
            },
            bag = {
                drawable = 0,
                texture = 0
            },
            kevlar = {
                drawable = 0,
                texture = 0
            },
            hair = {
                drawable = 1,
                texture = 2
            },
            leg = {
                drawable = 1,
                texture = 2
            },
            ears = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = 0,
                texture = 0
            },
            bracelets = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            hat = {
                drawable = -1,
                texture = -1
            },
        }
    },
    {
        coords = vec4(-111.20, 6470.07, 31.62, 134.92), -- paleto bay bank
        name = "Blaine County Savings Bank",
        model = `a_m_y_business_03`,
        clothing = {
            torso = {
                drawable = 1,
                texture = 0
            },
            shoes = {
                drawable = 0,
                texture = 0
            },
            accessory = {
                drawable = 0,
                texture = 0
            },
            face = {
                drawable = 0,
                texture = 1
            },
            torso2 = {
                drawable = 0,
                texture = 0
            },
            mask = {
                drawable = 0,
                texture = 0
            },
            badge = {
                drawable = 0,
                texture = 0
            },
            undershirt = {
                drawable = 0,
                texture = 0
            },
            bag = {
                drawable = 0,
                texture = 0
            },
            kevlar = {
                drawable = 0,
                texture = 0
            },
            hair = {
                drawable = 0,
                texture = 0
            },
            leg = {
                drawable = 0,
                texture = 2
            },
            ears = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = 0,
                texture = 0
            },
            bracelets = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            hat = {
                drawable = -1,
                texture = -1
            },
        }
    },
    {
        coords = vec4(-351.35, -51.24, 49.03, 344.95), -- burton hawick fleeca bank
        name = "Fleeca Bank",
        model = `a_m_y_business_02`,
        clothing = {
            torso = {
                drawable = 0,
                texture = 1
            },
            shoes = {
                drawable = 0,
                texture = 0
            },
            accessory = {
                drawable = 0,
                texture = 0
            },
            face = {
                drawable = 1,
                texture = 1
            },
            torso2 = {
                drawable = 0,
                texture = 0
            },
            mask = {
                drawable = 0,
                texture = 0
            },
            badge = {
                drawable = 0,
                texture = 0
            },
            undershirt = {
                drawable = 0,
                texture = 0
            },
            bag = {
                drawable = 0,
                texture = 0
            },
            kevlar = {
                drawable = 0,
                texture = 0
            },
            hair = {
                drawable = 2,
                texture = 0
            },
            leg = {
                drawable = 0,
                texture = 2
            },
            ears = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = -1,
                texture = -1
            },
            bracelets = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            hat = {
                drawable = -1,
                texture = -1
            },
        }
    },
    {
        coords = vec4(313.78, -280.42, 54.16, 342.14), -- alta hawick fleeca bank
        name = "Fleeca Bank",
        model = `a_f_y_business_01`,
        clothing = {
            torso = {
                drawable = 1,
                texture = 1
            },
            shoes = {
                drawable = 0,
                texture = 0
            },
            accessory = {
                drawable = 0,
                texture = 0
            },
            face = {
                drawable = 1,
                texture = 0
            },
            torso2 = {
                drawable = 0,
                texture = 0
            },
            mask = {
                drawable = 0,
                texture = 0
            },
            badge = {
                drawable = 0,
                texture = 0
            },
            undershirt = {
                drawable = 0,
                texture = 0
            },
            bag = {
                drawable = 0,
                texture = 0
            },
            kevlar = {
                drawable = 0,
                texture = 0
            },
            hair = {
                drawable = 1,
                texture = 0
            },
            leg = {
                drawable = 1,
                texture = 2
            },
            ears = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = 1,
                texture = 0
            },
            bracelets = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            hat = {
                drawable = -1,
                texture = -1
            },
        }
    },
    {
        coords = vec4(-1211.98, -331.94, 37.78, 29.13), -- rockford hills fleeca bank
        name = "Fleeca Bank",
        model = `a_f_y_business_02`,
        clothing = {
            torso = {
                drawable = 1,
                texture = 0
            },
            shoes = {
                drawable = 0,
                texture = 0
            },
            accessory = {
                drawable = 0,
                texture = 0
            },
            face = {
                drawable = 0,
                texture = 0
            },
            torso2 = {
                drawable = 0,
                texture = 0
            },
            mask = {
                drawable = 0,
                texture = 0
            },
            badge = {
                drawable = 0,
                texture = 0
            },
            undershirt = {
                drawable = 0,
                texture = 0
            },
            bag = {
                drawable = 0,
                texture = 0
            },
            kevlar = {
                drawable = 0,
                texture = 0
            },
            hair = {
                drawable = 0,
                texture = 2
            },
            leg = {
                drawable = 1,
                texture = 0
            },
            ears = {
                drawable = -1,
                texture = -1
            },
            glasses = {
                drawable = 0,
                texture = 0
            },
            bracelets = {
                drawable = -1,
                texture = -1
            },
            watch = {
                drawable = -1,
                texture = -1
            },
            hat = {
                drawable = -1,
                texture = -1
            },
        }
    }
}
local fixAnim = false
local fixClickAnim = false

function animationATM(task)
    local animDict = "random@atmrobberygen@male"
    RequestAnimDict(animDict)
    repeat Wait(0) until HasAnimDictLoaded(animDict)
    if task == "enter" then
        TaskPlayAnim(cache.ped, animDict, "enter", 8.0, -8.0, 4000, 0, 0, true, true, true)
        Wait(4000)
        TaskPlayAnim(cache.ped, animDict, "base", 8.0, -8.0, -1, 1, 0, true, true, true)
    end
    if task == "click" then
        if fixClickAnim or fixAnim then return end
        fixClickAnim = true
        TaskPlayAnim(cache.ped, animDict, "idle_a", 8.0, -8.0, 3000, 0, 0, true, true, true)
        Wait(2500)
        if fixAnim then return end
        TaskPlayAnim(cache.ped, animDict, "base", 8.0, -8.0, -1, 1, 0, true, true, true)
        fixClickAnim = false
    end
    if task == "exit" then
        fixAnim = true
        TaskPlayAnim(cache.ped, animDict, "exit", 8.0, 8.0, 5500, 0, 0, true, true, true)
        Wait(5500)
        ClearPedTasks(cache.ped)
        fixAnim = false
    end
end

function checkATM()
    for _, atm in pairs(atmModels) do
        local object = GetClosestObjectOfType(pedCoords.x, pedCoords.y, pedCoords.z, 0.7, atm, false, false, false)
        if object ~= 0 and GetEntityHealth(object) > 0 then
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
        local player = NDCore.getPlayer()
        SendNUIMessage({
            type = "actionATM",
            personalAccountBalance = player.bank,
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
        if not usingTarget then
            lib.showTextUI("[E] - Use ATM")
        end
    elseif not usingTarget then
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
        local player = NDCore.getPlayer()
        SendNUIMessage({
            type = "action",
            personalAccountBalance = player.bank,
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
    local player = NDCore.getPlayer()
    SendNUIMessage({
        type = "bankInfo",
        personalAccountNumber = bank,
        invoices = invoices,
        personalAccountBalance = player.bank,
        name = player.fullname,
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
        local player = NDCore.getPlayer()
        SendNUIMessage({
            type = "bankInfo",
            personalAccountNumber = bank,
            invoices = invoices,
            personalAccountBalance = player.bank,
            name = player.fullname,
            history = history
        })
    end)
end

AddEventHandler("playerSpawned", function()
    Wait(5000)
    start()
end)

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then return end
    Wait(1000)
    start()
end)

local function createBankPeds(options)
    for i=1, #bankPeds do
        NDCore.removeAiPed(bankPeds[i])
    end
    bankPeds = {}

    for i=1, #banks do
        local bank = banks[i]
        bankPeds[#bankPeds+1] = NDCore.createAiPed({
            model = bank.model,
            coords = bank.coords,
            options = options,
            distance = 20.0,
            clothing = bank.clothing,
            blip = {
                label = bank.name,
                sprite = 272,
                scale = 0.8,
                color = 43
            },
            anim = {
                dict = "anim@amb@casino@valet_scenario@pose_d@",
                clip = "base_a_m_y_vinewood_01"
            }
        })
    end
end

local function noTarget()
    CreateThread(function()
        while not usingTarget do
            pedCoords = GetEntityCoords(cache.ped)
            nearATM, objectATM = checkATM()
            Wait(1000)
        end
    end)
    
    CreateThread(function()
        local wait = 500
        while not usingTarget do
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
                    TaskGoStraightToCoord(cache.ped, atmPosition.x, atmPosition.y, atmPosition.z, 1.0, 1500, GetEntityHeading(object), 0.0)
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
                    local dist = #(pedCoords - vec3(bank.coords.x, bank.coords.y, bank.coords.z))
                    if dist < 2.0 then
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

    createBankPeds()
end

NDCore.isResourceStarted("ox_target", function(started)
    usingTarget = started
    if not usingTarget then return noTarget() end
    exports.ox_target:addModel(atmModels, {
        {
            name = "nd_banking:atm",
            icon = "fa-solid fa-money-bill-wave",
            label = "Use ATM",
            distance = 0.7,
            canInteract = function(entity, distance, coords, name, boneId)
                return GetEntityHealth(entity) > 0
            end,
            onSelect = function(data)
                local atmPosition = GetOffsetFromEntityInWorldCoords(data.entity, 0.0, -0.6, 0.0)
                local heading = GetEntityHeading(data.entity)
                TaskGoStraightToCoord(cache.ped, atmPosition.x, atmPosition.y, atmPosition.z, 0.5, 500, heading, 0.0)
                Wait(500)
                TaskGoStraightToCoord(cache.ped, atmPosition.x, atmPosition.y, atmPosition.z, 0.5, -1, heading, 1.5)
                Wait(500)
                TaskTurnPedToFaceCoord(cache.ped, data.coords.x, data.coords.y, data.coords.z, 600)
                Wait(700)
                animationATM("enter")
                SendNUIMessage({
                    type = "displayATM",
                    status = true
                })
                SetNuiFocus(true, true)
            end
        }
    })

    Wait(1000)
    if not usingTarget then return end
    createBankPeds({
        {
            name = "nd_banking:bank",
            icon = "fa-solid fa-building-columns",
            label = "Bank",
            distance = 2.0,
            onSelect = function(data)
                SendNUIMessage({
                    type = "display",
                    status = true
                })
                SetNuiFocus(true, true)
            end
        }
    })
end)
