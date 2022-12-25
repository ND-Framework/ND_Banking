-- For support join my discord: https://discord.gg/Z9Mxu72zZ6

author "Andyyy#7666"
description "ND Banking resource for ND Framework"
version "1.0.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

files {
    "ui/index.html",
    "ui/img/**",
    "ui/style.css",
    "ui/script.js"
}
ui_page "ui/index.html"

shared_scripts {
    "@ox_lib/init.lua",
    "@ND_Core/shared/import.lua",
    "config.lua"
}
server_scripts {
    "@oxmysql/lib/MySQL.lua",
    "server/main.lua"
}
client_scripts {
    "client/main.lua"
}