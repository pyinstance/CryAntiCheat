local QBCore = exports[Config.Core]:GetCoreObject()
local Players = {}
local bessy   = false
local ScreenShot = nil
local AllowedMention = ""
local RandomColor = math.random(0,9)
local Bans = {}
local Kicks = {}
local Warns = {}

RegisterServerEvent('ReturnScreenShotHome')
AddEventHandler('ReturnScreenShotHome', function(image)
    Players[source].ScreenShot = image
end)


RegisterCommand(Config.AdminConfig.AdminMenu, function(source)
    TriggerClientEvent(Config.AntiCheatSystemName..':client:OpenUi', source)
end)

RegisterServerEvent(Config.AntiCheatSystemName..':server:SetPlayersSettings')
AddEventHandler(Config.AntiCheatSystemName..':server:SetPlayersSettings', function(Ip)
    local src          = source
    local Player       = QBCore.Functions.GetPlayer(src)
    local STEAM        = "Not Found"
    local DISCORD      = "Not Found"
    local FIVEML       = "Not Found"
    local LIVE         = "Not Found"
    local XBL          = "Not Found"
    local SteamProfile = "Not Found"
    local License      = "Not Found"
    local ISP          = "Not Found"
    local CITY         = "Not Found"
    local COUNTRY      = "Not Found"
    local PROXY        = "Not Found"
    local LON          = "Not Found"
    local LAT          = "Not Found"
    local asname       = "Not Found"
    local HOSTING      = "Not Found"

    for _, DATA in pairs(GetPlayerIdentifiers(src)) do
        if DATA:match("steam") then
            STEAM = DATA
            SteamProfile = tonumber(string.gsub(DATA,"steam:", ""),16)
        elseif DATA:match("discord") then
            DISCORD = "<@"..string.gsub(DATA,"discord:", "")..">"
        elseif DATA:match("license:") then
            License = DATA
        elseif DATA:match("live") then
            LIVE = DATA
        elseif DATA:match("xbl") then
            XBL = DATA
        end
    end

    PerformHttpRequest("http://ip-api.com/json/"..Ip.."?fields=66846719", function(ERROR, DATA, RESULT)
        if DATA ~= nil then
            local TABLE = json.decode(DATA)
            if TABLE ~= nil then
                ISP     = TABLE["isp"] or "Not Found"
                CITY    = TABLE["city"] or "Not Found"
                COUNTRY = TABLE["country"] or "Not Found"
                if TABLE["proxy"] == true then
                    PROXY   =  "ON" or "Not Found"
                else
                    PROXY   = "OFF" or "Not Found"
                end
                LON     = TABLE["lon"] or "Not Found"
                LAT     = TABLE["lat"] or "Not Found"
                asname  = TABLE["asname"] or "Not Found"
                if TABLE["hosting"] == true then
                    HOSTING   =  "ON" or "Not Found"
                else
                    HOSTING   = "OFF" or "Not Found"
                end
            end
        else
        end             
    end)
    Wait(2000)
    Players[src] = {
        name = GetPlayerName(src) or "Not Found",
        ip = Ip or "Not Found",
        STEAM = STEAM or "Not Found",
        License = License or "Not Found",
        citizend = Player.PlayerData.citizend or "Not Found",
        DISCORD = DISCORD or "Not Found",
        LIVE = LIVE or "Not Found",
        SteamProfile = SteamProfile or "Not Found",
        XBL = XBL or "Not Found",
        ScreenShot = nil,
        Token = {
            [0] =  GetPlayerToken(src, 0),
            [1] =  GetPlayerToken(src, 1),
            [2] =  GetPlayerToken(src, 2),
            [3] =  GetPlayerToken(src, 3),
            [4] =  GetPlayerToken(src, 4),
        },
        ISP = ISP or "Not Found",
        CITY = CITY or "Not Found",
        COUNTRY = COUNTRY or "Not Found",
        PROXY = PROXY or "Not Found",
        LON = LON or "Not Found",
        LAT = LAT or "Not Found",
        asname = asname or "Not Found",
        HOSTING = HOSTING or "Not Found",
        IsAdmin = false
    } 
    if #Config.Admins ~= 0 then
        for k,v in pairs(Config.Admins) do
            if v.steam == Player.PlayerData.steam or v.license == Player.PlayerData.license or v.citizend == Player.PlayerData.citizend then
                Players[src].IsAdmin = true
                TriggerClientEvent('IsAdmin:server:Checked', src)
            end 
        end
    end
    if Players[src].name == nil then Players[src].name = "Not Found" end
    if Players[src].ip == nil then Players[src].ip = "Not Found" end
    if Players[src].STEAM == nil then Players[src].STEAM = "Not Found" end
    if Players[src].License == nil then Players[src].License = "Not Found" end
    if Players[src].citizend == nil then Players[src].citizend = "Not Found" end
    if Players[src].DISCORD == nil then Players[src].DISCORD = "Not Found" end
    if Players[src].LIVE == nil then Players[src].LIVE = "Not Found" end
    if Players[src].SteamProfile == nil then Players[src].SteamProfile = "Not Found" end
    if Players[src].ScreenShot == nil then Players[src].ScreenShot = "Not Found" end
    if Players[src].Token == nil then Players[src].Token = "Not Found" end
    if Players[src].ISP == nil then Players[src].ISP = "Not Found" end
    if Players[src].CITY == nil then Players[src].CITY = "Not Found" end
    if Players[src].COUNTRY == nil then Players[src].COUNTRY = "Not Found" end
    if Players[src].PROXY == nil then Players[src].PROXY = "Not Found" end
    if Players[src].LON == nil then Players[src].LON = "Not Found" end
    if Players[src].LAT == nil then Players[src].LAT = "Not Found" end
    if Players[src].asname == nil then Players[src].asname = "Not Found" end
    if Players[src].HOSTING == nil then Players[src].HOSTING = "Not Found" end
    if Players[src].IsAdmin == nil then Players[src].IsAdmin = "Not Found" end
    if Players[src].Token[0] == nil then Players[src].Token[0] = "Not Found" end
    if Players[src].Token[1] == nil then Players[src].Token[1] = "Not Found" end
    if Players[src].Token[2] == nil then Players[src].Token[2] = "Not Found" end
    if Players[src].Token[3] == nil then Players[src].Token[3] = "Not Found" end
    if Players[src].Token[4] == nil then Players[src].Token[4] = "Not Found" end
end)

RegisterNetEvent(Config.AntiCheatSystemName..'server:JoinWebhook')
AddEventHandler(Config.AntiCheatSystemName..'server:JoinWebhook', function()
    WebHookSender(source, Config.WebHooks.Join, ""..Emoji.Connect.." Connected "..Emoji.Connect.."", true)

end)


function IsHeBan(SRC)
    local BANFILE = LoadResourceFile(GetCurrentResourceName(), "BanList/Bans.json")
    if BANFILE ~= nil then
        local TABLE = json.decode(BANFILE)
        if TABLE ~= nil and type(TABLE) == "table" then
            if SRC ~= nil then
                if TABLE[1] ~= nil then
                    for k,v in pairs(TABLE) do
                        if v.Steam == QBCore.Functions.GetIdentifier(SRC, 'steam') or v.License == QBCore.Functions.GetIdentifier(SRC, 'license') or v.Discord == QBCore.Functions.GetIdentifier(SRC, 'discord') then
                           return true
                        else
                            return false
                        end
                    end
                else
                    return false
                end
            else
                return false
            end
        else
            return false
        end
    else
        return false
    end
end

function WebHookSender(SRC, webhook, Type, fulldata, IsBan)
    local NAME    = GetPlayerName(SRC)
    local id = tonumber(SRC)
    local COORDS  = GetEntityCoords(GetPlayerPed(SRC))
    local STEAM   = Players[SRC].STEAM
    local DISCORD = Players[SRC].DISCORD
    local License = Players[SRC].License
    local citizend = Players[SRC].citizend
    local LIVE    = Players[SRC].LIVE
    local XBL     = Players[SRC].XBL
    local SteamProfile = Players[SRC].SteamProfile
    local Token   = Players[SRC].Token
    local IPAddress = Players[SRC].ip
    local PING    = GetPlayerPing(SRC) or "Not Found"

    if Config.ScreenShot.Enabled then
        TriggerClientEvent(Config.AntiCheatSystemName..':client:requestScreenShot', SRC)
    end
    Wait(2000)
    if IsBan == true then
        local BANFILE = LoadResourceFile(GetCurrentResourceName(), "BanList/Bans.json")
        if BANFILE ~= nil then
            local TABLE = json.decode(BANFILE)
            if TABLE and type(TABLE) == "table" then
                local BanList = {
                    ["Name"] = GetPlayerName(SRC),
                    ["Steam"]   = STEAM,
                    ["Discord"] = DISCORD,  
                    ["License"] = License,
                    ["citizend"] = citizend,
                    ["Xbox"]    = LIVE,
                    ["Xbl"]     = XBL,
                    ["Ip"]      = IPAddress,
                    ["Token"]   = {
                        [0] = Token[0],
                        [1] = Token[1],
                        [2] = Token[2],
                        [3] = Token[3],
                        [4] = Token[4]
                    },
                    ["BanId"] = math.random(tonumber(1111), tonumber(9999)).."-"..math.random(tonumber(1111), tonumber(9999)).."-"..math.random(tonumber(1111), tonumber(9999)),
                    ["ScreenShot"] = Players[SRC].ScreenShot,
                    ["Reason"] = Type,
                    ["Date"] = os.date("%c")
                    }
                table.insert(TABLE, BanList)
                if IsHeBan(SRC) == false then
                    SaveResourceFile(GetCurrentResourceName(), "BanList/Bans.json", json.encode(TABLE, {indent = true}), tonumber("-1"))
                end
            end
        end
    end
    if Players[SRC].ScreenShot == nil then Players[SRC].ScreenShot = "https://img.freepik.com/free-vector/oops-404-error-with-broken-robot-concept-illustration_114360-1932.jpg?w=2000" end
    if Players[SRC].asnam == nil then Players[SRC].asnam = "Not Found" end
    local discordlogimage = Config.WebHooksSettings.Img
    local loginfo = {["color"] = Config.WebHooksSettings.color, ["type"] = "rich", ["title"] = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", ['image'] = {
        ['url'] = Players[SRC].ScreenShot
    },
    ["description"] =  "**" ..Type .. "\n------------- Player Info -------------\n Name : ||" ..NAME .. "||\n ID : ||" ..id .. "||\n Steam ID: ||" .. STEAM .. "||\n Live ID: ||" .. LIVE .. "||\n License : ||" .. License .. "||\n Citizend : ||" .. citizend .. "||\n Discord : ||" .. DISCORD .. "||\n Xbox Live : ||" .. XBL .. "||\n Steam Profile : ||https://steamcommunity.com/profiles/" .. SteamProfile .. "||\n  Coords : ||" ..COORDS.. "||\n Token: ||" ..Token[0].. "||\n||" ..Token[1].. "||\n||" ..Token[2].. "||\n||" ..Token[3].. "||\n||" ..Token[4].. "||\n------------- Player Network Info -------------\n  IP : ||" ..IPAddress.. "||\n Player Ping : ||" .. PING .. "||\n ISP : ||" .. Players[SRC].ISP .. "||\n COUNTRY : ||" .. Players[SRC].COUNTRY .. "||\n CITY : ||" .. Players[SRC].CITY .. "||\n PROXY : ||" .. Players[SRC].PROXY .. "||\n LON : ||" .. Players[SRC].LON .. "||\n LAT : ||" .. Players[SRC].LAT .. "||\n HOSTING : ||" .. Players[SRC].HOSTING .. "||\n Asname : ||" .. Players[SRC].asname .. "||**", ["footer"] = { ["text"] = " © "..Config.ServerConfig.ServerName.." | The Armor AntiCheat System | "..os.date("%c").."" }}
    PerformHttpRequest(webhook, function(err, text, headers) end, "POST", json.encode({username = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", avatar_url = discordlogimage, embeds = {loginfo}, content = AllowedMention}), {["Content-Type"] = "application/json"})
    PerformHttpRequest(Config.WebHooks.All, function(err, text, headers) end, "POST", json.encode({username = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", avatar_url = discordlogimage, embeds = {loginfo}, content = AllowedMention}), {["Content-Type"] = "application/json"})
end

Citizen.CreateThread(function()
    while true do
        if Config.AntiBlackListVehicle then                    
            for kk, vv in pairs(GetAllVehicles()) do
                for k,v in pairs(Vehicle) do
                    local PedsOwner = NetworkGetEntityOwner(vv)
                    if GetEntityModel(vv) == GetHashKey(v) and PedsOwner ~= nil and PedsOwner ~= 128 and PedsOwner ~= -1 then
                        TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlackListVehiclePunishment, "Anti Black List Vehicle Spawn "..v.." Detected", PedsOwner)
                        DeleteEntity(vv)
                    end
                end
            end
        end
        Wait(1000)
    end
end)

Citizen.CreateThread(function()
    print("^"..RandomColor)
    print([[                          
        
        ::::::::  :::::::::  :::   :::                  :::     ::::    ::: ::::::::::: ::::::::::: ::::::::  :::    ::: ::::::::::     ::: ::::::::::: 
      :+:    :+: :+:    :+: :+:   :+:                :+: :+:   :+:+:   :+:     :+:         :+:    :+:    :+: :+:    :+: :+:          :+: :+:   :+:      
     +:+        +:+    +:+  +:+ +:+                +:+   +:+  :+:+:+  +:+     +:+         +:+    +:+        +:+    +:+ +:+         +:+   +:+  +:+       
    +#+        +#++:++#:    +#++:  +#++:++#++:++ +#++:++#++: +#+ +:+ +#+     +#+         +#+    +#+        +#++:++#++ +#++:++#   +#++:++#++: +#+        
   +#+        +#+    +#+    +#+                 +#+     +#+ +#+  +#+#+#     +#+         +#+    +#+        +#+    +#+ +#+        +#+     +#+ +#+         
  #+#    #+# #+#    #+#    #+#                 #+#     #+# #+#   #+#+#     #+#         #+#    #+#    #+# #+#    #+# #+#        #+#     #+# #+#          
  ########  ###    ###    ###                 ###     ### ###    ####     ###     ########### ########  ###    ### ########## ###     ### ###           
  
]])  
                                                                                
      print("^"..RandomColor.."[+] ["..Config.ServerConfig.ServerName.." CryAntiCheat System] : CryAntiCheat Created by vealloll")
      if Config.WebHooksSettings.mention then AllowedMention = "||@everyone @here||" end
      PerformHttpRequest("http://"..Config.ServerConfig.ServerIp.."/info.json", function(ERROR, DATA, RESULT)
          if DATA ~= nil then
              local json = json.decode(DATA)
              print("^"..RandomColor.."[+] ["..Config.ServerConfig.ServerName.." CryAntiCheat System] : Server Build : "..string.gsub(string.gsub(string.gsub(json.server, "FXServer", ""), "win32", ""), "-master SERVER v1.0.0.", "").."".."^0")
          end
      end)
      PerformHttpRequest("http://"..Config.ServerConfig.ServerIp.."/info.json", function(ERROR, DATA, RESULT)
        if DATA ~= nil then
            local JSON = json.decode(DATA)
            local discordlogimage = Config.WebHooksSettings.Img
            local loginfo = {["color"] = Config.WebHooksSettings.color, ["type"] = "rich", ["title"] = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", ['image'] = {['url'] = Config.WebHooks.ServerStatus.OnlineImg}, ["description"] =  "**"..Emoji.Tick.." "..JSON.vars.sv_projectName.." is Runing You Can Join Now "..Emoji.Tick.."\nIP Link : ||"..Config.ServerConfig.JoinLink.."||\nMax Players : ||"..JSON.vars.sv_maxClients.."||\nResources Count : ||"..#JSON.resources.."||**", ["footer"] = { ["text"] = " © "..Config.ServerConfig.ServerName.." | The Armor AntiCheat System | "..os.date("%c").."" }}
            PerformHttpRequest(Config.WebHooks.All, function(err, text, headers) end, "POST", json.encode({username = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", avatar_url = discordlogimage, embeds = {loginfo}, content = AllowedMention}), {["Content-Type"] = "application/json"})
            PerformHttpRequest(Config.WebHooks.ServerStatus.webhook, function(err, text, headers) end, "POST", json.encode({username = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", avatar_url = discordlogimage, embeds = {loginfo}, content = AllowedMention}), {["Content-Type"] = "application/json"})
           
            local loginfo = {["color"] = Config.WebHooksSettings.color, ["type"] = "rich", ["title"] = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", ['image'] = {['url'] = Config.WebHooks.ServerStatus.OnlineImg}, ["description"] =  "**"..Emoji.Tick.." The Armor AntiCheat System Working With Out Any issues "..Emoji.Tick.."\nServer Name : ||"..JSON.vars.sv_projectName.."||\nOneSync State : ||"..JSON.vars.onesync_enabled.."||\nGame Build : ||"..string.gsub(string.gsub(string.gsub(JSON.server, "FXServer", ""), "win32", ""), "-master SERVER v1.0.0.", "").."||\nMax Players : ||"..JSON.vars.sv_maxClients.."||\nResources Count : ||"..#JSON.resources.."||\nVersion : ||"..Config.Version.."||**", ["footer"] = { ["text"] = " © "..Config.ServerConfig.ServerName.." | The Armor AntiCheat System | "..os.date("%c").."" }}
            PerformHttpRequest(Config.WebHooks.All, function(err, text, headers) end, "POST", json.encode({username = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", avatar_url = discordlogimage, embeds = {loginfo}, content = AllowedMention}), {["Content-Type"] = "application/json"})
            PerformHttpRequest(Config.WebHooks.AntiCheatStatus, function(err, text, headers) end, "POST", json.encode({username = Config.ServerConfig.ServerName.." | The Armor AntiCheat System", avatar_url = discordlogimage, embeds = {loginfo}, content = AllowedMention}), {["Content-Type"] = "application/json"})
      
        end
    end)
end)


local ResServerStart = nil
local ResServerStop = nil


AddEventHandler("onResourceStop", function(resourcename)
    ResServerStop = resourcename
end)
AddEventHandler('onResourceStart', function(resourcename)
    ResServerStart = resourcename
end)

QBCore.Functions.CreateCallback('GetInject', function(source, cb)
    cb(ResServerStart)
end)
QBCore.Functions.CreateCallback('GetStoping', function(source, cb)
    cb(ResServerStop)
end)

QBCore.Functions.CreateCallback('GetAllPlayers', function(source, cb)
    local new = ''
    for k,v in pairs(QBCore.Functions.GetPlayers()) do
        local xPlayer = QBCore.Functions.GetPlayer(v)
        new = new .. '<div class="Players"><span class="span">' .. xPlayer.PlayerData.charinfo.firstname .."  ".. xPlayer.PlayerData.charinfo.lastname .. ' ( '..v..' ) </div>'
    end
    cb(new)
end)

local BanCount = 0
local KickCount = 0
local WarnCount = 0

RegisterServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler')
AddEventHandler(Config.AntiCheatSystemName..':server:ActionsHandler', function(Type, reason, src)
    if bessy == true then return end
    local SRC = src or source
    if Players[SRC] == nil then return end
    local Player = QBCore.Functions.GetPlayer(SRC)
    

    if Players[SRC].IsAdmin then return end
    
    if Type == "Ban" then
        bessy = true
        WebHookSender(SRC,Config.WebHooks.Ban,""..Emoji.Ban.." BANNED Reason : " ..reason.." "..Emoji.Ban.."", true, true)
        Wait(1000)
        DropPlayer(SRC, Config.Message.Ban.." Reason : "..reason)
        for k,v in pairs(QBCore.Functions.GetPlayers()) do
            if Players[v].IsAdmin and Config.AdminConfig.ChatNotify.Ban then
                TriggerClientEvent('chat:addMessage', v, {
                    template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778789537419284/red.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.Ban..' '..Config.ServerConfig.ServerName..' The Armor AntiCheat System '..Emoji.Ban..' :<br>  {1}</div>',
                    args = {"Console", ""..Emoji.Warn.." Ban | Player ^1".. GetPlayerName(SRC) .."(".. SRC ..")^0 Reason : ^5".. reason .. " " }
                })
            end
        end
        bessy = false
    elseif Type == "Kick" then
        bessy = true
        WebHookSender(SRC,Config.WebHooks.Kick,""..Emoji.Kick.." KICK Reason : " ..reason.." "..Emoji.Kick.."", true)
        Wait(1000)
        DropPlayer(SRC, Config.Message.Kick.." Reason : "..reason)
        for k,v in pairs(QBCore.Functions.GetPlayers()) do
            if Players[v].IsAdmin and Config.AdminConfig.ChatNotify.Kick then
                TriggerClientEvent('chat:addMessage', v, {
                    template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778789537419284/red.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.Kick..' '..Config.ServerConfig.ServerName..' The Armor AntiCheat System '..Emoji.Kick..' :<br>  {1}</div>',
                    args = {"Console", ""..Emoji.Warn.." kick | Player ^1".. GetPlayerName(SRC) .."(".. SRC ..")^0 Reason : ^5".. reason .. " " }
                })
            end
        end
        bessy = false
    elseif Type == "Warn" then
        bessy = true
        WebHookSender(SRC,Config.WebHooks.Warn,""..Emoji.Warn.." WARN Reason : " ..reason.." "..Emoji.Warn.."", true)
        for k,v in pairs(QBCore.Functions.GetPlayers()) do
            if Players[v].IsAdmin and Config.AdminConfig.ChatNotify.Warn then
                TriggerClientEvent('chat:addMessage', v, {
                    template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778789537419284/red.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.TFJ..' '..Config.ServerConfig.ServerName..' The Armor AntiCheat System '..Emoji.TFJ..' :<br>  {1}</div>',
                    args = {"Console", ""..Emoji.Warn.." Warning | Player ^1".. GetPlayerName(SRC) .."(".. SRC ..")^0 Reason : ^5".. reason .. " " }
                })
            end
        end
        TriggerClientEvent('chat:addMessage', SRC, {
            template = '<div style="padding: 0.5vw; margiDATA: 0.5vw; background-image: url(https://cdn.discordapp.com/attachments/905814226118008923/1045778789537419284/red.png); border-radius: 13px;"><i class="far fa-newspaper"></i> '..Emoji.TFJ..' '..Config.ServerConfig.ServerName..' The Armor AntiCheat System '..Emoji.TFJ..' :<br>  {1}</div>',
            args = {"Console", ""..Emoji.Warn.." You have been Warned ^1".. GetPlayerName(SRC) .."(".. SRC ..")^0 Reason : ^5".. reason .. " " }
        })
        bessy = false
        Wait(2000)
    end
    
end)

RegisterNetEvent(Config.AntiCheatSystemName..":CheckJumping")
AddEventHandler(Config.AntiCheatSystemName..":CheckJumping", function (reason)
    local SRC = source
    if IsPlayerUsingSuperJump(SRC) and tonumber(SRC) then
        if admin == nil then
            TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiSuperJumpPunishment, reason, SRC)
        end
    end
end)

local SERVER_CMDS = {}
for index, bcmd in pairs(Commands) do
    RegisterCommand(bcmd, function (SRC, ARGS)
        if Config.AntiBlackListCommands then
            TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlackListCommandsPunishment, "Anti Bad Word "..bcmd.." Detected", SRC)
            return
        end
    end)
end



if Config.AntiBlackListTrigger then
    for k,v in pairs(Events) do
        RegisterServerEvent(v)
        AddEventHandler(v, function()
			local SRC = source
			local EVENT = v
            TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlackListTriggerPunishment, "Anti Black List Event "..EVENT.." Detected", SRC)
            CancelEvent()
		end)
    end
end

AddEventHandler("entityCreated",function(object)
    if Config.AntiSpawnBlackListObject then
        for k,vv in pairs(Objects) do
            for k,v in pairs(GetAllObjects()) do
                local j = GetEntityModel(v)
                local k = NetworkGetEntityOwner(v)
                if j == GetHashKey(vv) and k ~= nil then
                    DeleteEntity(v)
                    TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiSpawnBlackListObjectPunishment, "Anti Black List Object "..vv.." Detected", k)
                end
            end
        end
    end
end)



local EXPLOSION = {}
AddEventHandler("explosionEvent", function(SRC, DATA)
    if Players[SRC].ip == nil then return end
    if DATA == nil then return end
    if Explosion[DATA.explosionType] == nil then return end
    WebHookSender(SRC, Config.WebHooks.Explosion,""..Emoji.Heal.." Anti Explosion Detected Explosion Type : "..DATA.explosionType.." "..Emoji.Heal.."", true)

    local Token = GetPlayerToken(SRC, 0)
    local TABLE = Explosion[DATA.explosionType]

    if Config.AntiExplosion then
        if EXPLOSION[Token] ~= nil then
            EXPLOSION[Token].COUNT = EXPLOSION[Token].COUNT + 1
            if os.time() - EXPLOSION[Token].TIME <= 3 then
                EXPLOSION[Token] = nil
            else
                if EXPLOSION[Token].COUNT >= Config.AntiExplosionMax then
                    TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiExplosionPunishment, "Anti Spam Explosion Detected", SRC)
                    WebHookSender(SRC,Config.WebHooks.Explosion,""..Emoji.Heal.." Anti Spam Explosion Detected"..Emoji.Heal.."", true)

                end
            end
         else
            EXPLOSION[Token] = {
                COUNT = 1,
                TIME  = os.time()
            }
         end
     end
end)


AddEventHandler("RemoveWeaponEvent", function(SRC, DATA)
    if Config.AntiRemoveWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiRemoveWeaponPunishment, "Anti Remove Weapon Detected", SRC)
            CancelEvent()
        end
    end
end)

AddEventHandler("RemoveAllWeaponsEvent",function(SRC, DATA)
    if Config.AntiRemoveWeapon then
        if tonumber(SRC) ~= nil and GetPlayerName(SRC) ~= nil then
            TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiRemoveWeaponPunishment, "Anti Remove All Weapon Detected", SRC)
            CancelEvent()
        end
    end
end)

local TAZE = {}
AddEventHandler("weaponDamageEvent", function(SRC, DATA)
    if Config.AntiTazePlayers then
        local Token = GetPlayerToken(SRC, 0)
        if DATA.weaponType == 911657153 then
            if TAZE[Token] ~= nil then
                TAZE[Token].COUNT = TAZE[Token].COUNT + 1
                if os.time() - TAZE[Token].TIME <= 1 then
                    TAZE[Token] = nil
                else
                    if TAZE[Token].COUNT >= Config.AntiTazeMaxTazeSpam then
                        TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiTazePlayersPunishment, "Anti Spam Tazer Detected", SRC)
                    end
                end
            else
                TAZE[Token] = {
                    COUNT = 1,
                    TIME  = os.time()
                }
            end
        end
    end
end)

RegisterNetEvent(""..Config.CoreObj.."_ambulancejob:syncDeadBody")
AddEventHandler(""..Config.CoreObj.."_ambulancejob:syncDeadBody", function(PED, TARGET)
	if Config.AntiBringAll then
        TriggerEvent(Config.AntiCheatSystemName..':server:ActionsHandler', Config.AntiBringAllPunishment, "Anti Bring All Players Detected", source)
        CancelEvent()
	end
end)

AddEventHandler("playerDropped", function(REASON)
    local SRC = source
    if SRC == nil then return end
    
    print("^"..RandomColor.."[+] ["..Config.ServerConfig.ServerName.." CryAntiCheat System] : Player "..GetPlayerName(SRC).." Disconnected From The Server  |  Reason : ("..REASON..")^0")
    if GetPlayerName(SRC) and REASON ~= nil then
        WebHookSender(SRC, Config.WebHooks.leave, ""..Emoji.Disconnect.." Disconnect Reason : "..REASON.." "..Emoji.Disconnect.."", true)
    end
    Players[SRC] = nil

end)


AddEventHandler("playerConnecting", function (name, setKickReason, deferrals)
    local SRC      = source
    local BANFILE = LoadResourceFile(GetCurrentResourceName(), "BanList/Bans.json")
    print("^"..RandomColor.."[+] ["..Config.ServerConfig.ServerName.." CryAntiCheat System] : Player "..name.." Connecting ...^0")

        if BANFILE ~= nil then
            local TABLE = json.decode(BANFILE)
            if TABLE ~= nil and type(TABLE) == "table" then
                if tonumber(SRC) ~= nil then
                    for k,v in pairs(TABLE) do
                        if v.Steam == QBCore.Functions.GetIdentifier(SRC, 'steam') or v.License == QBCore.Functions.GetIdentifier(SRC, 'license') or v.Discord == QBCore.Functions.GetIdentifier(SRC, 'discord') or v.Token[0] == GetPlayerToken(SRC, 0) or v.Token[1] == GetPlayerToken(SRC, 1) or v.Token[2] == GetPlayerToken(SRC, 2) or v.Token[3] == GetPlayerToken(SRC, 3) or v.Token[4] == GetPlayerToken(SRC, 4) then
                            setKickReason('Your Info\n'..v.Steam..'\n'..v.License..'\n'..v.Discord..'\n'..v.Xbl..'\n'..v.Xbox..'\n'..v.Discord..'\n Your Ban ScreentShot img :'..v.ScreenShot..'\n ip:'..v.Ip..'\n'..Emoji.Ban..' Your ban from this server Reason : '..v.Reason..'\nBanId : '..v.BanId..' '..Emoji.Ban..'\nYou can find more info in our discord : '..Config.ServerConfig.Discord)
                            CancelEvent()        
                            print("^"..RandomColor.."[+] ["..Config.ServerConfig.ServerName.." CryAntiCheat System] : Ban Player Try To Join "..name.."^0")
        
                        end
                    end
                end
            end
        end
end)


