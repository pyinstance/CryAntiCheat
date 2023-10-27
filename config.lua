Config = {}

Config.Version = "1.0.0.0" 

Config.AntiCheatSystemName = "CryAntiCheat" 
Config.CoreObj = "QBCore" 
Config.Core = "qb-core" 
Config.FilesShortCut = "qb-" 

Config.ServerConfig = {
    ServerIp = "1.1.1.1:10101", 
    Discord = "https://discord.gg/botnet", 
    JoinLink = "", 
    ServerName = "Testername"
}

Config.Admins = {
    [0] = {steam = "", license = "", citizend = ""}, -- 
    [1] = {steam = "", license = "", citizend = ""}, -- 
    [2] = {steam = "", license = "", citizend = ""}, -- 
    [3] = {steam = "", license = "", citizend = ""}, -- 
    [4] = {steam = "", license = "", citizend = ""}, -- 
    [5] = {steam = "", license = "", citizend = ""}, -- 
    [6] = {steam = "", license = "", citizend = ""}, -- 
}
Config.AdminConfig = {
    ChatNotify = { 
        Ban = true,
        Kick = true,
        Warn = true
    },
    AdminMenu = "CryAntiCheat" 
}

Config.WebHooks = {
    ServerStatus = {
        webhook = "webhookhere",  -- please make sure all of these that say "webhookhere" are the same webhook
        OnlineImg = "https://cdn.discordapp.com/attachments/1166460514931585057/1167252832492200046/image.png?ex=654d73e9&is=653afee9&hm=2e8932b84997444530ea6fa622cc8efd228be8c84a1948c2c8ce6cac51c42830&" 
    },
    AntiCheatStatus = "webhookhere", 
    Expolosin = "webhookhere", 
    Kick = "webhookhere", 
    Ban = "webhookhere", 
    Warn = "webhookhere", 
    Join = "webhookhere", 
    leave = "webhookhere", 
    All = "webhookhere" 
}

Config.WebHooksSettings = {
    Img = "https://cdn.discordapp.com/attachments/906304685344968775/906304877985144882/gANGLEAKS.png", 
    color = tonumber("0FFF7C", 16), 
    mention = true 
}

Config.Message = {
    Kick = "["..Config.ServerConfig.ServerName.."] | 🗣️ You have been Kick from this server ", 
    Ban = "["..Config.ServerConfig.ServerName.."] | 🗣️  You have been permanently banned from this server "
}

Config.ScreenShot = {
    Enabled = true, 
    WebHook = "webhookhere"  CryAntiCheat System]
}

------------- local Player Anti Cheats ----------------

Config.AntiGodMode  = true  
Config.AntiGodModePunishment = "Warn"

Config.AntiHealth = true     
Config.HealthValue = 200
Config.AntiHealthPunishment = "Ban"

Config.AntiArmor = true     
Config.ArmorValue = 100
Config.AntiArmorPunishment = "Ban"

Config.AntiTeleport = true     
Config.AntiTeleportPunishment = "Warn"

Config.AntiSuperJump = true 
Config.AntiSuperJumpPunishment = "Ban"

Config.AntiSpactate = true 
Config.AntiSpactatePunishment = "Ban"

Config.SilentAim = true 
Config.SilentAimPunishment = "Ban"

Config.AntiInvisible = true 
Config.AntiInvisiblePunishment = "Ban"

Config.AntiInfiniteStamina = true 
Config.AntiInfiniteStaminaPunishment = "Ban"

Config.AntiRagdoll = true 
Config.AntiRagdollPunishment = "Ban"

Config.AntiFreeCam = true 
Config.AntiFreeCamPunishment = "Warn"

Config.AntiMenu = true 
Config.AntiMenuPunishment = "Ban"

Config.AntiPedChanger = true 
Config.AntiPedChangerPunishment = "Kick"

Config.AntiBlacklistTasks = true --    
Config.AntiBlacklistTasksPunishment = "Ban"

Config.AntiBlacklistAnims = true --    
Config.AntiBlacklistAnimsPunishment = true

Config.AntiTinyPed = true --    
Config.AntiTinyPedPunishment = "Ban"

Config.AntiNightVision = true --    
Config.AntiNightVisionPunishment = "Ban"

Config.AntiTrackPlayer = true --    
Config.AntiTrackMaxTrack = 5
Config.AntiTrackPlayerPunishment = "Ban"


Config.AntiTazePlayers = true --   
Config.AntiTazeMaxTazeSpam = 6
Config.AntiTazePlayersPunishment = "Warn"

Config.AntiBlackListName = true --    

Config.AntiSpeedHack = true --   
Config.SpeedHackValue = 8
Config.AntiSpeedHackPunishment = "Ban"

Config.AntiPlayerBlips = true --   
Config.AntiPlayerBlipsPunishment = "Ban"

Config.AntiVPN = true --   
Config.AntiFlyandNoclip = true --   
Config.AntiFlyandNoclipPunishment = "Ban"

Config.AntiBlackListWord = true --  
Config.AntiBlackListWordPunishment = "Warn"

Config.AntiSpamChat = true --  
Config.AntiSpamChatPunishment = "Kick"
Config.CoolDownSec = 10
Config.MaxMessage = 5

Config.AntiBlackListCommands = true --
Config.AntiBlackListCommandsPunishment = "Warn"

------------- local Player End ----------------

------------- Weapons Anti Cheats ----------------

Config.AntiBlackListWeapon  = true --   
Config.AntiBlackListWeaponPunishment = "Ban"

Config.AntiWeaponDamageChanger = false --   
Config.AntiWeaponDamageChangerPunishment = "Warn"
Config.AntiWeaponDamageChangerMaxDamage = 250

Config.AntiWeaponsExplosive = true --   
Config.AntiWeaponsExplosivePunishment = "Ban"

Config.AntiRemoveWeapon = true
Config.AntiRemoveWeaponPunishment = "Ban"

Config.AntiAimAssist = true --   
Config.AntiAimAssistPunishment = "Ban"

Config.AntiUnlimitedAmmo = true --   
Config.AntiUnlimitedAmmoPunishment = "Ban"

------------- Weapons End ----------------

------------- Vehicles Anti Cheats ----------------

Config.AntiRainbowVehicle = true --   
Config.AntiRainbowVehiclePunishment = "Ban"

Config.AntiBlackListPlate = true --   
Config.AntiBlackListPlatePunishment = "Ban"

------------- Vehicles End ----------------

------------- Server Anti Cheats ----------------

Config.AntiInjectionAndExecutor = false -- 
Config.AntiInjectionPunishment = "Ban"

Config.AntiExplosion = true --  
Config.AntiExplosionMax = 4
Config.AntiExplosionPunishment = "Ban"

Config.AntiBoomDamage = true --  

Config.AntiBringAll = true --  
Config.AntiBringAllPunishment = "Ban"

Config.AntiBlackListTrigger = true
Config.AntiBlackListTriggerPunishment = "Ban"

Config.AntiResourceStop     = true --     
Config.AntiResourceStopPunishment = "Ban"

Config.AntiSpawnBlackListObject = true --     
Config.AntiSpawnBlackListObjectPunishment = "Ban"

Config.AntiBlackListPed = true --     
Config.AntiBlackListPedPunishment = "Ban"

Config.AntiBlackListVehicle = true --    
Config.AntiBlackListVehiclePunishment = "Ban"

Config.AntiSpamVehicle = true --    
Config.AntiSpamMaxVehicle = 5
Config.AntiSpamVehiclePunishment = "Ban"

Config.AntiSpawnPed = true --    
Config.MaxPed = 5
Config.AntiSpawnPedPunishment = "Ban"

Config.AntiAttackPeds = true --      
Config.AntiAttackPedsPunishment = "Ban"

Config.AntiSpamObject = true --    
Config.MaxObject = 9
Config.AntiSpamObjectPunishment = "Ban"

Config.AntiBlackListVehicle = true 
Config.AntiBlackListVehiclePunishment = "Ban"

------------- Server End ----------------