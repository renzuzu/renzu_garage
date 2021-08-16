fx_version 'cerulean'
games {'common'}
ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',	
	'config.lua',
	'server/server.lua'
}

client_scripts {
	'config.lua',
	'client/client.lua'
}

files {
	'html/design.css',
	'html/index.html',
	'html/img/*.png',
	'html/script.js',
	'html/fonts/*',	
	'imgs/*.png',
	'imgs/uploads/*.jpg',
}

data_file 'DLC_ITYP_REQUEST' 'stream/garage.ytyp'
files {
    'stream/garage.ytyp'
}