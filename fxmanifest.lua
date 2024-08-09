fx_version 'cerulean'
game 'gta5'

author 'Atiya'
description 'Atiya DevTools'
version '0.0.1'

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

shared_scripts {
    'shared/*.lua',
    'shared/db/*.lua',
    'shared/config/*.lua',
}

files {
    'html/index.html',
    'html/js/script.js'
}

ui_page 'html/index.html'

dependencies {
    'qb-core'
}

lua54 'yes'
