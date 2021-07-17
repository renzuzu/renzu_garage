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
	'client/client.lua',
	'threads.lua',
	'scaleform.lua',
}

files {
	'html/design.css',
	'html/index.html',
	'html/script.js',
	'html/fonts/*',	
	'html/images/text-color.png',
	'imgs/*.png',
	'imgs/uploads/*.jpg',
	'imgs/brands/*.png'
}

data_file 'DLC_ITYP_REQUEST' 'stream/garage.ytyp'
files {
    'stream/garage.ytyp'
}