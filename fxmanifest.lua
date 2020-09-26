fx_version 'adamant'

games {'gta5'}

client_scripts {
	"server/main.lua"
	"config.lua"
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"client/main.lua"
}

ui_page 'html/index.html'

files {
    "html/index.html",
    "html/style.css",
    "html/script.js"
}