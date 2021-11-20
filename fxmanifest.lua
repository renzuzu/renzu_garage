fx_version 'cerulean'
games {'common'}
ui_page 'html/index.html'

shared_scripts {
	'conf/locale/*.lua',
	'conf/main.lua',
	'conf/*.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',	
	'server/server.lua'
}

client_scripts {
	'client/*.lua'
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