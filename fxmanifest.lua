fx_version 'cerulean'
game 'gta5'

author 'Atiya'
description 'Atiya Developer Tools'
version '1.0.1'

client_scripts {
    'client/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/*.lua',
}

shared_scripts {
    -- '@ox_lib/init.lua', -- uncomment to enable esx
    'shared/*.lua',
    'shared/db/*.lua',
    'shared/config/config_commands.lua',
    'shared/config/config.lua',
    'shared/config/*.lua',
}

files {
    'html/*.html',
    'html/js/*.js',
    'html/css/*.css',
    'html/jsondb/*.json',
}

ui_page 'html/index.html'

dependencies {
    'qb-core', -- comment to enable esx
    -- 'es_extended', -- uncomment to enable esx
    -- 'ox_lib' -- uncomment to enable esx
}

lua54 'yes'
