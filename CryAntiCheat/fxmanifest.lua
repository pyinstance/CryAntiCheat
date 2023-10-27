fx_version 'cerulean'

games {
    'gta5'
}

description ' CryAntiCheat ~ Dev Veal <3'
version '1.0.0.0'

client_scripts {
  'client/*.lua'
}

shared_scripts {
  'config.lua',
  'banlist/Bans.json',
  'require/*.lua'
}

server_scripts {
	'server/*.lua',
  '@oxmysql/lib/MySQL.lua' -- credits
}
