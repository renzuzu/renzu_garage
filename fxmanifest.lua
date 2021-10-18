fx_version 'cerulean'
games {'common'}
ui_page 'html/index.html'

server_scripts {
	'@mysql-async/lib/MySQL.lua',	
	'conf/main.lua',
	'conf/*.lua',
	'server/server.lua'
}

client_scripts {
	'conf/main.lua',
	'conf/*.lua',
	'client/client.lua'
}

files {
	'html/design.css',
	'html/uikit.css',
	'html/forms.css',
	'html/index.html',
	'html/img/*.png',
	'html/script.js',
	'html/fonts/*',	
	'imgs/**.png',
	'imgs/uploads/*.jpg',
}

data_file 'DLC_ITYP_REQUEST' 'stream/garage.ytyp'
files {
    'stream/garage.ytyp'
}