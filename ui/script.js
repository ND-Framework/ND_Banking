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
$(".bank").hide();
$(".bank-invoice, .bank-transfer").hide();
$(".bank-nav > button").click(function() {
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
