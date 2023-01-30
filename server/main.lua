local activePlayersAccounts = {}

function isAccountNumberAvailable(number)
    local available = not MySQL.scalar.await("SELECT 1 FROM nd_banking_accounts WHERE account_number = ?", {number})
    -- local available2 = not MySQL.scalar.await("SELECT 1 FROM nd_banking_shared_accounts WHERE account_number = ?", {number})
    -- return (available and available2)
    return available
end

function createPersonalAccount(characterId)
    local number = tostring(math.random(4000, 4999) .. math.random(3000, 3999) .. math.random(1000, 9999) .. math.random(5000, 5999))
    while not isAccountNumberAvailable(number) do
        number = tostring(math.random(4000, 4999) .. math.random(3000, 3999) .. math.random(1000, 9999) .. math.random(5000, 5999))
    end
    MySQL.query.await("INSERT INTO `nd_banking_accounts` (`owner`, `account_number`) VALUES (?, ?)", {characterId, number})
    return number
end

function getInvoices(number)
    local invoices = {
        requests = {},
        unpaid = {},
        paid = {},
        sent = {}
    }

    local received = MySQL.query.await("SELECT * FROM `nd_banking_invoices` WHERE `receiver_account` = ?", {number})
    if received and received[1] then
        for i=1, #received do
            if received[i].status == "paid" then
                invoices.paid[#invoices.paid+1] = received[i]
            elseif received[i].status == "unpaid" then
                invoices.unpaid[#invoices.unpaid+1] = received[i]
            elseif received[i].status == "pending" then
                invoices.requests[#invoices.requests+1] = received[i]
            end
        end
    end

    local sent = MySQL.query.await("SELECT * FROM `nd_banking_invoices` WHERE `sender_account` = ?", {number})
    if sent and sent[1] then
        for i=1, #sent do
            invoices.sent[#invoices.sent+1] = sent[i]
        end
    end

    local expiredInvoices = {}
    local time = os.time()
    for _, invoice in pairs(invoices.unpaid) do
        local dueIn = tonumber(invoice.due_in)
        if dueIn and dueIn < time then
            expiredInvoices[#expiredInvoices+1] = invoice
        end
    end

    return invoices, expiredInvoices
end

function isAccountLocked(number)
    local _, expiredInvoices = getInvoices(number)
    return #expiredInvoices > 0
end

function payInvoice(invoice, source)
    local character = NDCore.Functions.GetPlayer(source)
    if character.bank < invoice.amount then return end

    NDCore.Functions.DeductMoney(invoice.amount, source, "bank", "Invoice paid to " .. invoice.sender_name .. ".")
    MySQL.query.await("UPDATE `nd_banking_invoices` SET `status` = 'paid' WHERE `invoice_id` = ?", {invoice.invoice_id})
    TriggerClientEvent("ND_Banking:updateInvoices", source, getInvoices(activePlayersAccounts[source] and activePlayersAccounts[source].number))

    local senderCharacter, senderSource = refreshInvoiceSender(invoice.invoice_id)
    if senderSource then
        NDCore.Functions.AddMoney(invoice.amount, senderSource, "bank", "Invoice paid by " .. invoice.receiver_name .. ".")
    else
        MySQL.query.await("UPDATE characters SET bank = bank + ? WHERE character_id = ? LIMIT 1", {invoice.amount, senderCharacter})
    end
end

-- function sortHistory(...)  
--     local history = {}
--     for _, chosenHistory in ipairs(arg) do
--         for _, hist in pairs(chosenHistory) do
--             history[#history+1] = hist
--         end
--     end
--     for j=1, #history do
--         for i=1, #history do
--             local item = history[i]
--             if history[i+1] then
--                 if item.time > history[i+1].time then
--                     history[i] = history[i+1]
--                     history[i+1] = item
--                 end
--             end
--         end
--     end
--     return history
-- end

function transactionHistory(account, update)
    local table = "nd_banking_accounts"
    local history = MySQL.scalar.await("SELECT `history` FROM `nd_banking_accounts` WHERE `account_number` = ?", {account})
    -- if not history then 
    --     table = "nd_banking_shared_accounts"
    --     history = MySQL.scalar.await("SELECT `history` FROM `nd_banking_shared_accounts` WHERE `account_number` = ?", {account})
    -- end

    if not history then return {} end
    local accountHisory = json.decode(history)

    if update then
        accountHisory[#accountHisory+1] = update
        MySQL.query.await(("UPDATE %s SET `history` = ? WHERE `account_number` = ?"):format(table), {json.encode(accountHisory), account})
    end
    
    return accountHisory
end

function refreshInvoiceSender(invoiceId)
    local invoiceSender = MySQL.scalar.await("SELECT `sender_account` FROM `nd_banking_invoices` WHERE `invoice_id` = ?", {invoiceId})
    local invoiceCharacter = MySQL.scalar.await("SELECT `owner` FROM `nd_banking_accounts` WHERE `account_number` = ?", {invoiceSender})
    for accountSource, accountInfo in pairs(activePlayersAccounts) do
        if accountInfo.number == invoiceSender then
            TriggerClientEvent("ND_Banking:updateInvoices", accountSource, getInvoices(accountInfo.number))
            return invoiceCharacter, accountSource
        end
    end
    return invoiceCharacter
end

function getInvoiceReceiverName(account)
    for accountSource, accountInfo in pairs(activePlayersAccounts) do
        if accountInfo.number == account then
            local character = NDCore.Functions.GetPlayer(accountSource)
            if not character then break end
            return ("%s %s"):format(character.firstName, character.lastName), accountSource
        end
    end

    local receiver = MySQL.scalar.await("SELECT `owner` FROM `nd_banking_accounts` WHERE `account_number` = ?", {account})
    if not receiver then return end
    local receiverNames = MySQL.query.await("SELECT `first_name`, `last_name` FROM `characters` WHERE `character_id` = ?", {receiver})
    if not receiverNames or not receiverNames[1] then return end 
    return ("%s %s"):format(receiverNames[1].first_name, receiverNames[1].last_name)
end

RegisterNetEvent("ND:moneyChange", function(player, moneyType, amount, action, description)
    if moneyType ~= "bank" then return end
    if action == "set" then return end
    local history = transactionHistory(activePlayersAccounts[player] and activePlayersAccounts[player].number, {
        amount = amount,
        description = description,
        action = action,
        time = os.time()
    })
    TriggerClientEvent("ND_Banking:updateHistory", player, history)
end)

RegisterNetEvent("ND:characterLoaded", function(character)
    local bank = MySQL.scalar.await("SELECT `account_number` FROM `nd_banking_accounts` WHERE `owner` = ?", {character.id})
    if not bank then
        bank = createPersonalAccount(character.id)
    end
    activePlayersAccounts[character.source] = {
        number = bank
    }
    TriggerClientEvent("ND_Banking:bankInfo", character.source, bank, getInvoices(bank), transactionHistory(bank))
end)

RegisterNetEvent("ND_Banking:interactInvoice", function(interaction, id)
    local src = source
    local account = activePlayersAccounts[src] and activePlayersAccounts[src].number
    if not account then return end
    if not interaction or not id then return end
    local invoices = getInvoices(account)

    if interaction == "pay" then
        for _, invoice in pairs(invoices.unpaid) do
            if invoice.invoice_id == id then
                local character = NDCore.Functions.GetPlayer(src)
                if character.bank < invoice.amount then return end
                payInvoice(invoice, src)
                break
            end
        end
        return
    end

    if interaction == "reject" then
        for _, invoice in pairs(invoices.requests) do
            if invoice.invoice_id == id then
                MySQL.query.await("DELETE FROM `nd_banking_invoices` WHERE `invoice_id` = ?", {invoice.invoice_id})
                TriggerClientEvent("ND_Banking:updateInvoices", src, getInvoices(account))
                refreshInvoiceSender(invoice.invoice_id)
                break
            end
        end
        return
    end

    if interaction ~= "accept" then return end
    for _, invoice in pairs(invoices.requests) do
        if invoice.invoice_id == id then
            MySQL.query.await("UPDATE `nd_banking_invoices` SET `status` = 'unpaid' WHERE `invoice_id` = ?", {invoice.invoice_id})
            TriggerClientEvent("ND_Banking:updateInvoices", src, getInvoices(account))
            refreshInvoiceSender(invoice.invoice_id)
            break
        end
    end
end)

RegisterNetEvent("ND_Banking:createInvoice", function(account, amount, due)
    local src = source

    local sender = activePlayersAccounts[src] and activePlayersAccounts[src].number
    if not sender then return end

    local receiverName, receiverSource = getInvoiceReceiverName(account)
    if not receiverName then return end

    local dueIn = tonumber(due)
    if not dueIn or dueIn < 1 then return end

    local time = os.time()
    dueIn = time + (dueIn*86400)

    local character = NDCore.Functions.GetPlayer(src)
    MySQL.query.await("INSERT INTO `nd_banking_invoices` (`sender_name`, `receiver_name`, `sender_account`, `receiver_account`, `amount`, `created`, `due_in`, `status`) VALUES (?, ?, ?, ?, ?, ?, ?, ?)", {
        ("%s %s"):format(character.firstName, character.lastName),
        receiverName,
        sender,
        account,
        amount,
        time,
        dueIn,
        "pending"
    })

    TriggerClientEvent("ND_Banking:updateInvoices", src, getInvoices(sender), true)
    if not receiverSource then return end
    TriggerClientEvent("ND_Banking:updateInvoices", receiverSource, getInvoices(account))
end)

lib.callback.register("ND_Banking:getInfo", function(source)
    if not activePlayersAccounts[source] then
        local character = NDCore.Functions.GetPlayer(source)
        if not character then return end
        local bank = MySQL.scalar.await("SELECT `account_number` FROM `nd_banking_accounts` WHERE `owner` = ?", {character.id})
        if not bank then
            bank = createPersonalAccount(character.id)
        end
        activePlayersAccounts[source] = {
            number = bank
        }
    end
    local account = activePlayersAccounts[source] and activePlayersAccounts[source].number
    return account, getInvoices(account), transactionHistory(account)
end)

lib.callback.register("ND_Banking:action", function(source, action, amount)
    local amount = tonumber(amount)
    if not action or not amount or not (action == "Deposit" or action == "Withdraw") then return end
    if amount > config.maxWithdrawDepositBank then
        return ("Error: max amount $%s"):format(config.maxWithdrawDepositBank)
    elseif amount < config.minWithdrawDepositBank then
        return ("Error: min amount $%s"):format(config.minWithdrawDepositBank)
    end

    if action == "Withdraw" and isAccountLocked(activePlayersAccounts[source] and activePlayersAccounts[source].number) then return "Error: account is locked, pay your invoices." end

    local success = NDCore.Functions[action == "Deposit" and "DepositMoney" or action == "Withdraw" and "WithdrawMoney"](amount, source)
    return success
end)

lib.callback.register("ND_Banking:actionATM", function(source, amount)
    local amount = tonumber(config.valuesWithdrawATM[amount])
    if not amount then return end
    if isAccountLocked(activePlayersAccounts[source] and activePlayersAccounts[source].number) then return end
    local success = NDCore.Functions.WithdrawMoney(amount, source)
    return success
end)

lib.callback.register("ND_Banking:transferMoney", function(source, account, amount, message)
    local playerAccount = activePlayersAccounts[source] and activePlayersAccounts[source].number
    if not playerAccount or not amount then return "Error: an issue occurred, try again later." end
    if isAccountLocked(playerAccount) then return "Error: account is locked, pay your invoices." end
    
    for receiver, accountInfo in pairs(activePlayersAccounts) do
        if accountInfo.number == account then
            local character = NDCore.Functions.GetPlayer(source)
            local receiverCharacter = NDCore.Functions.GetPlayer(receiver)

            local senderMessage = ("Bank transfer to %s %s (%s)%s"):format(receiverCharacter.firstName, receiverCharacter.lastName, accountInfo.number, (message and message ~= "") and ": " .. message or "")
            local receiverMessage = ("Bank transfer from %s %s (%s)%s"):format(character.firstName, character.lastName, playerAccount, (message and message ~= "") and ": " .. message or "")

            local success = NDCore.Functions.TransferBank(amount, source, receiver, senderMessage, receiverMessage)
            if not success then
                return "Error: an issue occurred, try again later."
            end
            return ("Success: transfer of $%s sent to %s %s"):format(amount, receiverCharacter.firstName, receiverCharacter.lastName)
        end
    end
    return "Error: no active account with this number not found."
end)