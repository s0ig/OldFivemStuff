fx_version "cerulean"
game "gta5"
lua54 'yes'

mod 'smodsk-farming'
version '1.0.0'

client_scripts {
    "shared/*.lua",
    "language.lua",
    "config.lua",
    "client/*.lua",
    

}

server_scripts {
    "shared/*.lua",
    "config.lua",
    '@mysql-async/lib/MySQL.lua',
    "server/*.lua",
}

server_exports {
    "AddOwner",
    "RemoveOwner"
}