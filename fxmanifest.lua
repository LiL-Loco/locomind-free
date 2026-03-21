fx_version 'cerulean'
game 'gta5'

name 'locomind-free'
description 'LocoMind Free — AI-powered NPC conversations for FiveM'
version '1.0.0'
url 'https://locomind.dev'
author 'ThaLoco0ne'

shared_scripts {
    'config.lua'
}

client_scripts {
    'client/main.lua',
    'client/ui.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua', -- optional, only needed for future logging
    'server/tts.lua',
    'server/main.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
}

lua54 'yes'
