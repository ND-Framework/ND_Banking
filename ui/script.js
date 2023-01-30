const formatter = new Intl.RelativeTimeFormat("en", {
    numeric: "auto"
})

const DIVISIONS = [
    { amount: 60, name: "seconds" },
    { amount: 60, name: "minutes" },
    { amount: 24, name: "hours" },
    { amount: 7, name: "days" },
    { amount: 4.34524, name: "weeks" },
    { amount: 12, name: "months" },
    { amount: Number.POSITIVE_INFINITY, name: "years" }
]

function formatTimeAgo(date) {
    let duration = (date - new Date()) / 1000

    for (let i = 0; i <= DIVISIONS.length; i++) {
        const division = DIVISIONS[i]
        if (Math.abs(duration) < division.amount) {
            return formatter.format(Math.round(duration), division.name).replace("seconds", "sec").replace("second", "sec").replace("minutes", "min").replace("minute", "min").replace("hours", "hr").replace("hour", "hr");
        }
        duration /= division.amount
    }
}

function closePage() {
    $(".bank").fadeOut("fast");
    $.post(`https://${GetParentResourceName()}/close`);
    $(".bank-nav > button").css({
        "background-color": "rgba(0, 0, 0, 0)",
        "color": "var(--color-theme-2)",
        "box-shadow": "none"
    });
    $(".bank-home, .bank-invoice, bank-transfer").hide();
}

document.onkeyup = function(data) { 
    if (data.which == 27) {
        const atm = $(".atm");
        if (atm.css("display") != "none") {
            atm.fadeOut("fast");
            atm.css("scale", "0");
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({
                atm: true
            }));
        }
        if ($(".bank").css("display") != "none") {
            closePage();
        }
        return;
    };
};

let invoicesViewing = "pending"
let invoices = {}

function showInvoices(invoiceType) {
    invoicesViewing = invoiceType
    const invoice = invoices[invoiceType]
    $(".bank-invoice-box").empty();
    const currentDate = new Date()
    if (invoiceType == "requests") {
        for (let i = 0; i < invoice.length; i++) {
            $(".bank-invoice-box").append(`
                <div>
                    <div>
                        <h4>From:</h4>
                        <p>${invoice[i].sender_name}</p>
                    </div>
                    <div>
                        <h4>Amount:</h4>
                        <p>$${invoice[i].amount}</p>
                    </div>
                    <div>
                        <h4>Due in:</h4>
                        <p>${formatTimeAgo(currentDate.setTime(invoice[i].due_in*1000))}</p>
                    </div>
                    <div>
                        <button data-invoice="${invoice[i].invoice_id}">Accept</button>
                        <button data-invoice="${invoice[i].invoice_id}">Reject</button>
                    </div>
                </div>
            `);
        }
        $(".bank-invoice-box > div").css("grid-template-columns", "40% 25% 20% 1fr");
    } else if (invoiceType == "unpaid") {
        for (let i = 0; i < invoice.length; i++) {
            $(".bank-invoice-box").append(`
                <div>
                    <div>
                        <h4>From:</h4>
                        <p>${invoice[i].sender_name}</p>
                    </div>
                    <div>
                        <h4>Amount:</h4>
                        <p>$${invoice[i].amount}</p>
                    </div>
                    <div>
                        <h4>Due in:</h4>
                        <p>${formatTimeAgo(currentDate.setTime(invoice[i].due_in*1000))}</p>
                    </div>
                    <div>
                        <button style="margin: 25% auto" data-invoice="${invoice[i].invoice_id}">Pay</button>
                    </div>
                </div>
            `);
        }
        $(".bank-invoice-box > div").css("grid-template-columns", "40% 25% 20% 1fr");
    } else if (invoiceType == "paid") {
        for (let i = 0; i < invoice.length; i++) {
            $(".bank-invoice-box").append(`
                <div>
                    <div>
                        <h4>From:</h4>
                        <p>${invoice[i].sender_name}</p>
                    </div>
                    <div>
                        <h4>Amount:</h4>
                        <p>$${invoice[i].amount}</p>
                    </div>
                    <div>
                        <h4>Due in:</h4>
                        <p>${formatTimeAgo(currentDate.setTime(invoice[i].due_in*1000))}</p>
                    </div>
                </div>
            `);
        }
        $(".bank-invoice-box > div").css("grid-template-columns", "40% 30% 30%");
    } else if (invoiceType == "sent") {
        for (let i = 0; i < invoice.length; i++) {
            $(".bank-invoice-box").append(`
                <div>
                    <div>
                        <h4>To:</h4>
                        <p>${invoice[i].receiver_name}</p>
                    </div>
                    <div>
                        <h4>Amount:</h4>
                        <p>$${invoice[i].amount}</p>
                    </div>
                    <div>
                        <h4>Due in:</h4>
                        <p>${formatTimeAgo(currentDate.setTime(invoice[i].due_in*1000))}</p>
                    </div>
                    <div>
                        <h4>Status:</h4>
                        <p>${invoice[i].status}</p>
                    </div>
                </div>
            `);
        }
        $(".bank-invoice-box > div").css("grid-template-columns", "40% 20% 20% 20%");
    }

};

function getStyle(action) {
    if (action === "set") {
        return '<i class="fa-regular fa-circle-question" style="color: rgb(0, 100, 250);"></i>'
    } else if (action === "add") {
        return '<i class="fa-solid fa-chevron-up" style="color: rgb(100, 250, 0);"></i>'
    } else if (action === "remove") {
        return '<i class="fa-solid fa-chevron-down" style="color: rgb(250, 50, 50);"></i>'
    }
}
function getAction(action, amount) {
    if (action === "add") {
        return `<i style="color: rgb(100, 250, 0);">+</i> $${amount}`
    } else if (action === "remove") {
        return `<i style="color: rgb(250, 50, 50);">-</i> $${amount}`
    }
}
function updateHistory(history) {
    $(".bank-home-boxContent").empty();
    const currentDate = new Date()
    for (let i = 0; i < history.length; i++) {
        const item = history[i]
        $(".bank-home-boxContent").prepend(`
            <div>
                <div>
                    <h4>${getAction(item.action, item.amount)}</h4>
                    <p>${item.description || ""}</p>
                </div>
                <p>${formatTimeAgo(currentDate.setTime(item.time*1000))}</p>
            </div>
        `);
    }
}

const notifications = {
    "invoice":"#createInvoiceNitification",
    "transaction":"#transactionNotification",
    "transfer":"#transferNotification",
    "atm":"#atm-transactionNotification"
}
function createNotification(type, txt) {
    const notification = $(notifications[type]);
    notification.text(txt);
    notification.fadeIn();
    setTimeout(() => {
        notification.fadeOut();
    }, 2500);   
}

window.addEventListener("message", function(event) {
    const item = event.data;

    if (item.type === "display") {
        if (item.status) {
            $("#homeButton").css({
                "background-color": "var(--color-main-4)",
                "color": "var(--color-theme-3)",
                "box-shadow": "rgba(0, 0, 0, 0.1) 0px 4px 12px"
            });
            $(".bank-home").show();
            $(".bank").fadeIn();
        } else {
            $(".bank").fadeOut();
        }
    }

    if (item.type === "bankInfo") {
        $(".bank-home-card-name").text(item.name);
        $(".bank-home-card-balance").text(`$${item.personalAccountBalance}`);
        $(".bank-home-card-number").empty();
        $(".bank-home-card-number").append(`<span class="tooltiptext">Copy</span>${item.personalAccountNumber.match(/.{1,4}/g).join(' ')}`);
        invoices = item.invoices;
        showInvoices("requests");
        updateHistory(item.history);
    }

    if (item.type === "action") {
        $(".bank-home-card-balance").text(`$${item.personalAccountBalance}`);
        if (!item.result) {
            createNotification("transaction", "Error: unable to complete action.");
        } else if (typeof item.result == "string") {
            createNotification("transaction", item.result);
        }
    }

    if (item.type === "actionATM") {
        $(".bank-home-card-balance").text(`$${item.personalAccountBalance}`);
        if (!item.result) {
            createNotification("atm", "Error: unable to complete action.")
        } else {
            const atm = $(".atm");
            if (atm.css("display") != "none") {
                atm.fadeOut("fast");
                atm.css("scale", "0");
                $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({
                    atm: true
                }));
            }
        }
    }

    if (item.type === "updateHistory") {
        updateHistory(item.history);
    }

    if (item.type === "updateInvoices") {
        invoices = item.invoices;
        showInvoices(invoicesViewing);
        if (item.create) {
            $("#createInvoice-amount").val("");
            $("#createInvoice-account").val("");
            $(".bank-invoice-creator > input").val("");
        }
    }

    if (item.type === "transferMessage") {
        createNotification("transfer", item.message);
    }

    if (item.type === "atmValues") {
        item.values.forEach(function (value, i) {
            $(".atm-transactionValues").append(`<button data-id="${i+1}">${value}</button>`)
        });
    }

    if (item.type === "displayATM") {
        const atm = $(".atm");
        if (item.status) {
            atm.fadeIn("fast");
            atm.css("scale", "1");
        } else {
            atm.fadeOut("fast");
            atm.css("scale", "0");
        }
    }

});

$(".bank, .atm, .bank-invoice, .bank-transfer").hide();

$(".bank-home-card-number").click(function() {
    const copyFrom = $("<textarea/>");
    copyFrom.text($(this).text().replace("Copy", ""));
    $("body").append(copyFrom);
    copyFrom.select();
    document.execCommand("copy");
    copyFrom.remove();

    // navigator.clipboard.writeText($(this).text().replace("Copy", ""));
    $(".bank-home-card-number > span").text("Copied!");
});
$(".bank-home-card-number").mouseout(function() {
    $(".bank-home-card-number > span").text("Copy");
});

$(".bank-nav > button").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    const thisElement = $(this);
    const page = thisElement.data("page");
    if (page === "close") {
        closePage();
        return;
    }
    const thisPage = $(`.bank-${page}`);
    if (thisPage.css("display") != "none") {return};
    $(".bank-nav > button").css({
        "background-color": "rgba(0, 0, 0, 0)",
        "color": "var(--color-theme-2)",
        "box-shadow": "none"
    });
    thisElement.css({
        "background-color": "var(--color-main-4)",
        "color": "var(--color-theme-3)",
        "box-shadow": "rgba(0, 0, 0, 0.1) 0px 4px 12px"
    });
    $(".bank-home, .bank-invoice, .bank-transfer").hide();
    thisPage.fadeIn();
});

$(".bank-invoice-button-requests").css("opacity", "1");
$(".bank-invoice-button-requests").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    showInvoices("requests");
    $(".bank-invoice-button-requests, .bank-invoice-button-unpaid, .bank-invoice-button-paid, .bank-invoice-button-sent").css("opacity", "0.6");
    $(this).css("opacity", "1");
});
$(".bank-invoice-button-unpaid").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    showInvoices("unpaid");
    $(".bank-invoice-button-requests, .bank-invoice-button-unpaid, .bank-invoice-button-paid, .bank-invoice-button-sent").css("opacity", "0.6");
    $(this).css("opacity", "1");
});
$(".bank-invoice-button-paid").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    showInvoices("paid");
    $(".bank-invoice-button-requests, .bank-invoice-button-unpaid, .bank-invoice-button-paid, .bank-invoice-button-sent").css("opacity", "0.6");
    $(this).css("opacity", "1");
});
$(".bank-invoice-button-sent").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    showInvoices("sent");
    $(".bank-invoice-button-requests, .bank-invoice-button-unpaid, .bank-invoice-button-paid, .bank-invoice-button-sent").css("opacity", "0.6");
    $(this).css("opacity", "1");
});

$(".bank-home-transaction > div > button").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    const amount = $(".bank-home-transaction > input").val()
    if (!amount || amount == "") {
        createNotification("transaction", "Error: no value found!")
        return;
    };
    $.post(`https://${GetParentResourceName()}/action`, JSON.stringify({
        action: $(this).text(),
        amount: amount
    }));
    $(".bank-home-transaction > input").val("")
});

$(".bank-invoice-creator > button").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    const amount = $("#createInvoice-amount").val();
    const account = $("#createInvoice-account").val();
    const due = $(".bank-invoice-creator > input").val();
    if (!amount || amount == "" || !account || account == "" || !due || due == "") {
        createNotification("invoice", "Error: all fields required!")
        return
    };
    $.post(`https://${GetParentResourceName()}/createInvoice`, JSON.stringify({
        amount: amount,
        account: account,
        due: due
    }));
});

$(".bank-transfer > button").click(function() {
    $.post(`https://${GetParentResourceName()}/sound`);
    const account = $("#transferAccount").val();
    const amount = $("#transferAmount").val();
    const message = $("#transferMessage").val();
    if (!account || account == "") {
        createNotification("transfer", "Error: account number missing!")
        return
    } else if (!amount || amount == "") {
        createNotification("transfer", "Error: amount missing!")
    };
    $.post(`https://${GetParentResourceName()}/transferMoney`, JSON.stringify({
        account: account,
        amount: amount,
        message: message
    }));
});

$(document).on("click", ".bank-invoice-box > div > div > button", function() {
    $.post(`https://${GetParentResourceName()}/interactInvoice`, JSON.stringify({
        type: $(this).text(),
        id: $(this).data("invoice")
    }));
});

$(".atm > button").click(function() {
    $.post(`https://${GetParentResourceName()}/interactATM`);
});

$(document).on("click", ".atm-transactionValues > button", function() {
    const click = $(this)
    $.post(`https://${GetParentResourceName()}/clickATM`, JSON.stringify({
        value: click.data("id")
    }));
    $(".atm-transactionValues > button").css({
        "background-color": "rgba(0, 0, 0, 0)",
        "color": "var(--color-theme-2)",
        "border": "var(--color-theme-2) 1px solid",
        "box-shadow": "rgba(0, 0, 0, 0.2) 0px 0px 12px",
        "opacity": "0.6"
    });
    click.css({
        "background-color": "var(--color-main-3)",
        "color": "var(--color-theme-3)",
        "border": "var(--color-theme-3) 1px solid",
        "box-shadow": "rgba(0, 0, 0, 0.3) 0px 0px 12px",
        "opacity": "1"
    });
});