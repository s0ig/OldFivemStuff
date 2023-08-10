fx_version 'adamant'
game 'gta5'

client_scripts {
	"job_config.lua",
	"config.lua",
	'client/*.lua'
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	"job_config.lua",
	"config.lua",
	'server/*.lua'
}








