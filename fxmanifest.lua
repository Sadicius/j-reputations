fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'j-reputations'

client_scripts {
    'client/functions.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

shared_scripts {
	'config.lua',
    '@ox_lib/init.lua',
}

lua54 'yes'
