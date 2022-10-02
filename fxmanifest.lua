fx_version   'cerulean'
use_experimental_fxv2_oal 'yes'
lua54        'yes'
game         'gta5'
use_fxv2_oal 'yes'

ui_page 'html/index.html'

shared_scripts {
	'@ox_lib/init.lua',	
	'conf/locale/*.lua',
	'conf/main.lua',
	'conf/*.lua',
	'vehicles.lua',
}

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'framework/sv_wrapper.lua',
	'server/*.lua'
}

client_scripts {
	'framework/cl_wrapper.lua',
	'client/*.lua'
}

dependencies {
    '/onesync',
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