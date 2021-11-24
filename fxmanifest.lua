fx_version 'cerulean'
games {'common'}
ui_page 'html/index.html'
lua54 'yes'
use_fxv2_oal 'yes'

shared_scripts {
	'conf/locale/*.lua',
	'conf/main.lua',
	'conf/*.lua',
	'vehicles.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'framework/sv_wrapper.lua',
	'server/server.lua'
}

client_scripts {
	'framework/cl_wrapper.lua',
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