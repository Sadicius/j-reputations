fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'j-reputations'

shared_scripts {
    '@ox_lib/init.lua',
	'config.lua',
}

client_scripts {
    'client/functions.lua',
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'locales/*.json'
  }

lua54 'yes'
