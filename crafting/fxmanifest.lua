resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

fx_version 'adamant'
game 'gta5'


version '1.0.6'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
   'config.lua',
	'server/*.lua',
}
client_scripts {
   'config.lua',
   'lang.lua',
	'client/*.lua',
}
ui_page 'ui/index.html'
files {
   'ui/img/book/*.png',
   'ui/img/book/*.jpg',
   'ui/img/items/*.png',
   'ui/img/items/*.jpg',
   'ui/*.jpg',
   'ui/*.png',
   'ui/*.html',
   'ui/*.js',
   'ui/*.css',
}





