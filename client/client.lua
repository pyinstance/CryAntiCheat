local IsAdmin = false
local LoggedIn = false
local TRACK = 0
local Check = true
local QBCore = exports[Config.Core]:GetCoreObject()
local IP = nil

RegisterNetEvent(Config.CoreObj..':Client:OnPlayerLoaded', function()
    Wait(25000)
    TriggerServerEvent(Config.AntiCheatSystemName..':server:SetPlayersSettings',IP)
    Wait(5000)
    TriggerServerEvent(Config.AntiCheatSystemName..'server:JoinWebhook')
    LoggedIn = true
end)

RegisterNetEvent(Config.CoreObj..':Client:OnPlayerUnLoad', function()
    LoggedIn = false
end)

RegisterNUICallback('GetSettings', function(ip)
    IP = ip
end)

local display = false

RegisterNetEvent(Config.AntiCheatSystemName..':client:OpenUi')
AddEventHandler(Config.AntiCheatSystemName..':client:OpenUi', function()
    if display then display = false else display = true end
    QBCore.Functions.TriggerCallback('GetAllPlayers', function(html)
        
        OpenNui(display)
        SendNUIMessage({
            type = "SetPlayers",
            html = html
        })
    end)
end)

function OpenNui(bool)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        display = bool
    })
end

RegisterNUICallback('Close', function()
    if display then display = false else display = true end
    OpenNui(display)
end)

if Config.AntiBlackListTrigger then
    for k,v in pairs(Events) do
        RegisterNetEvent(v)
        AddEventHandler(v, function()
			local ENAME = v
            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlackListTriggerPunishment, "Anti Black List Trigger "..EVENT.." Detected")
            CancelEvent()
		end)
    end
end

RegisterNetEvent('CheckifHeStopResource')
AddEventHandler('CheckifHeStopResource', function(resourcename)
    Check = false
end)

local ResClientStop = nil
local ResClientStart = nil

AddEventHandler("onClientResourceStop", function(resourcename)
    while LoggedIn == false do
        Wait(100)
    end
    ResClientStop = resourcename
    CheckStopingRes()
end)
AddEventHandler("onClientResourceStart", function(resourcename)
    while LoggedIn == false do
        Wait(100)
    end
    ResClientStart = resourcename
    CheckInject()
end)

function CheckStopingRes()
    if Config.AntiResourceStop then
        QBCore.Functions.TriggerCallback('GetStoping', function(ResServer)
            if ResClientStop ~= ResServer then
                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler', Config.AntiResourceStopPunishment, "Try To Stop Resource "..ResClientStop.." Detected")
            end
        end)
    end
end

function CheckInject()
    if Config.AntiInjectionAndExecutor then
        QBCore.Functions.TriggerCallback('GetInject', function(ResServer)
            if ResClientStart ~= ResServer then
                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler', Config.AntiInjectionPunishment, "Injection or Executor Detected")
            end
        end)
    end
end

RegisterNetEvent('IsAdmin:client:Checked')
AddEventHandler('IsAdmin:client:Checked', function()
IsAdmin = true
end)

local ObjectsOwners = {}

Citizen.CreateThread(function()
    while false do
        if LoggedIn then 
            if IsAdmin == false then
                if Config.AntiAttackPeds then                    
                    for k,v in pairs(QBCore.Functions.GetPeds()) do
                        if HasPedGotWeapon(v) then 
                            local PedsOwner = NetworkGetEntityOwner(v)
                            if PedsOwner ~= nil and PedsOwner ~= 128 and PedsOwner ~= -1 and IsPedShooting(v) then
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiAttackPedsPunishment,"Anti Spawn Attack NPCs Detected", PedsOwner)
                                DeleteEntity(v)
                            end
                        end
                    end
                end
                if Config.AntiSpawnPed then                    
                    for k,v in pairs(QBCore.Functions.GetPeds()) do
                        local PedsOwner = NetworkGetEntityOwner(v)
                        if PedsOwner ~= nil and PedsOwner ~= 128 and PedsOwner ~= -1 then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiAttackPedsPunishment,"Anti Spawn NPCs Detected", PedsOwner)
                            DeleteEntity(v)
                        end
                    end
                end
                if Config.AntiSpamObject then                    
                    for k,v in pairs(QBCore.Functions.GetObjects()) do
                        local ObjectsOwner = NetworkGetEntityOwner(v)
                        if ObjectsOwner ~= nil  then 
                            if ObjectsOwners[ObjectsOwner] ~= nil then
                                ObjectsOwners[ObjectsOwner].count = ObjectsOwners[ObjectsOwner].count + 1       
                                if ObjectsOwners[ObjectsOwner] ~= nil and ObjectsOwners[ObjectsOwner] ~= 128 and ObjectsOwners[ObjectsOwner] ~= -1 then
                                    if ObjectsOwners[ObjectsOwner].count > 20 then
                                        TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiAttackPedsPunishment,"Anti Spawn Objects Detected", ObjectsOwners[ObjectsOwner])
                                        DeleteEntity(v)
                                    end
                                end
                            else
                                ObjectsOwners[ObjectsOwner] = {
                                    count = 0
                                }
                            end
                        end
                    end
                end
                if Config.AntiTeleport then
                    if not IsPedInAnyVehicle(PED, false) and LoggedIn and not IsPlayerSwitchInProgress() and not IsPlayerCamControlDisabled() then
                        local _pos = GetEntityCoords(PED)
                        Citizen.Wait(3000)
                        local _newped = PlayerPedId()
                        local _newpos = GetEntityCoords(_newped)
                        local _distance = #(vector3(_pos) - vector3(_newpos))
                        if _distance > 200 and not IsEntityDead(PED) and not IsPedInParachuteFreeFall(PED) and not IsPedJumpingOutOfVehicle(PED) and PED == _newped and SPAWN == true and not IsPlayerSwitchInProgress() and not IsPlayerCamControlDisabled() then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiTeleportPunishment, "Anti Teleport Detected")
                        end
                    end
                end
                Wait(100)
            end
        end
        Wait(100)
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(100)
        local PLAYER    = PlayerId()
        local PED       = PlayerPedId()
        local COORDS    = GetEntityCoords(PED)
        local PLS       = GetActivePlayers()
        local HEALTH    = GetEntityHealth(PED)
        local ARMOR     = GetPedArmour(PED)
        local VEH     = nil
        local PLATE   = nil
        local VEHHASH = nil
        if LoggedIn then 
            if IsAdmin == false then
                if not IsPlayerSwitchInProgress() then
                    if IsPedInAnyVehicle(PED, false) then
                        VEH     = GetVehiclePedIsIn(PED, false)
                        PLATE   = GetVehicleNumberPlateText(VEH)
                        VEHHASH = GetHashKey(VEH)
                    end
                    if Config.AntiSpactate then
                        if NetworkIsInSpectatorMode() then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiSpactatePunishment,"Spactate on other player Detected" )   
                            Wait(0)
                        end
                    end                  
                    if Config.AntiBlackListWeapon ==false then                    
                        for _, weapon in pairs(WeaponsBlackList) do
                            if HasPedGotWeapon(PED, GetHashKey(weapon), false) == 1 then
                                RemoveAllPedWeapons(PED, true)
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlackListWeaponPunishment, "Black List Weapon "..weapon.." Detected")
                                Wait(0)
                            end
                        end
                    end
                    if Config.AntiInvisible then
                        while IsPlayerSwitchInProgress() do
                            Wait(10)
                        end
                        if ( not IsEntityVisible(PED) and not IsEntityVisibleToScript(PED) ) or (GetEntityAlpha(PED) <= 150 and GetEntityAlpha(PED) ~= 0 and SPAWN and not IsPlayerSwitchInProgress()) then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiInvisiblePunishment, "Anti Invisble Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiGodMode then
                        if GetPlayerInvincible(PLAYER) and not IsPlayerDead(PLAYER) then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiGodModePunishment,"God Mode Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiBoomDamage then
                        SetEntityProofs(PED, false, true, true, false, false, false, false, false)
                    end
                    if Config.AntiHealth then
                        if HEALTH > Config.HealthValue then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiHealthPunishment,"Anti Healing He is Fucking Cheater")
                            Wait(0)
                        end
                    end
                    if Config.AntiPlayerBlips then
                        Citizen.Wait(1000)
                        local IsBlip = 0
                        local OnlinePlayers = GetActivePlayers()
                        for i = 1, #OnlinePlayers do
                            if i ~= PlayerId() then
                                if DoesBlipExist(GetBlipFromEntity(GetPlayerPed(i))) then
                                    IsBlip = IsBlip + tonumber("1")
                                end
                            end
                            if IsBlip > 0 then
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiPlayerBlipsPunishment,"Anti Blips Detected")
                            end
                        end
                    end
                    if Config.AntiArmor then
                        if ARMOR > Config.ArmorValue then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiArmorPunishment,"Armor Refull Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiSuperJump then
                        if DoesEntityExist(PED) and LoggedIn and not IsPlayerSwitchInProgress() then
                            local JUPING = IsPedJumping(PED)
                            if JUPING then
                                TriggerServerEvent(Config.AntiCheatSystemName..':CheckJumping', "SuperJump Detected")
                                Wait(0)
                            end
                        end
                    end  
                    if Config.AntiInfiniteStamina then
                        if GetEntitySpeed(PED) > 7 and not IsPedInAnyVehicle(PED, true) and not IsPedFalling(PED) and not IsPedInParachuteFreeFall(PED) and not IsPedJumpingOutOfVehicle(PED) and not IsPedRagdoll(PED) then
                            local stamina = GetPlayerSprintStaminaRemaining(PLAYER)
                            if tonumber(stamina) == tonumber(0.0) then
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiInfiniteStaminaPunishment, "Anti Infinite Stamina Detected")
                                Wait(0)
                            end
                        end
                    end
                    if Config.AntiSpeedHack then
                        local PED = PlayerPedId()
                        if not IsPedInAnyVehicle(PlayerPedId(), 1) then
                            if GetEntitySpeed(PlayerPedId()) > Config.SpeedHackValue then
                                if not IsPedInAnyVehicle(PED, true) and not IsPedFalling(PED) and not IsPedInParachuteFreeFall(PED) and not IsPedJumpingOutOfVehicle(PED) and not IsPedRagdoll(PED) and not IsEntityAttached(PED) then
                                    TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiSpeedHackPunishment, "Anti Speed hack Detected")
                                end
                                Wait(300)
                            end
                        end
                    end
                    if Config.AntiRagdoll then
                        if not CanPedRagdoll(PED) and not IsPedInAnyVehicle(PED, true) and not IsEntityDead(PED) and not IsPedJumpingOutOfVehicle(PED) and not IsPedJacking(PED) and IsPedRagdoll(PED) then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiRagdollPunishment, "Enable Ragdoll Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiBlackListPlate then
                        if IsPedInAnyVehicle(PED, false) then
                            for _, plate in pairs(Plate) do
                                 NPLATE = GetVehicleNumberPlateText(GetVehiclePedIsIn(PED, false), false)
                                if NPLATE == plate then
                                   TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlackListPlatePunishment, "Anti Black List Plate Detected Plate Text : "..NPLATE)
                                   Wait(0)
                                end
                            end
                        end
                    end
                    
                    if Config.SilentAim then
                        local model = GetEntityModel(PlayerPedId())
                        local min, max 	= GetModelDimensions(model)
                        if min.y < -0.29 or max.z > 0.98 then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.SilentAimPunishment, "Silent Aim Detected")
                        end
                    end
                    if Config.AntiRainbowVehicle then
                        if IsPedInAnyVehicle(PED, false) then
                            local VEH = GetVehiclePedIsIn(PED, false)
                            if DoesEntityExist(VEH) then
                                local C1r, C1g, C1b = GetVehicleCustomPrimaryColour(VEH)
                                Wait(0)
                                local C2r, C2g, C2b = GetVehicleCustomPrimaryColour(VEH)
                                Wait(0)
                                local C3r, C3g, C3b = GetVehicleCustomPrimaryColour(VEH)
                                if C1r ~= nil then
                                    if C1r ~= C2r and C2r ~= C3r and C1g ~= C2g and C3g ~= C2g and C1b ~= C2b and C3b ~= C2b then
                                        TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiRainbowVehiclePunishment, "Anti Rainbow Detected")
                                        Wait(0)
                                    end 
                                end
                            end
                        else
                            Wait(0)
                        end
                    end
                    if Config.AntiFreeCam then
                        local x, y, z = table.unpack(GetEntityCoords(PED) - GetFinalRenderedCamCoord())
                        if (x > 50) or (y > 50) or (z > 50) or (x < -50) or (y < -50) or (z < -50) and not IsEntityVisible(PED) then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiFreeCamPunishment, "Anti Free Cam Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiMenu then
                        if IsPlayerCamControlDisabled() ~= false then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiMenuPunishment, "Anti Menu Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiAimAssist then
                        local aimassiststatus = GetLocalPlayerAimState()
                        if aimassiststatus ~= 3 then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiAimAssistPunishment, "Anti Aim Assist Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiWeaponDamageChanger then
                        local WEAPON    = GetSelectedPedWeapon(PED)
                        local WEPDAMAGE = math.floor(GetWeaponDamage(WEAPON))
                        if WEPDAMAGE > Config.AntiWeaponDamageChangerMaxDamage then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiWeaponDamageChangerPunishment, "Anti Weapon Damage Changer Detected Weapon Name : "..DAMAGE[WEAPON].NAME)
                            Wait(0)
                        end
                    end
                    if Config.AntiWeaponsExplosive then
                        local WEAPON    = GetSelectedPedWeapon(PED)
                        local WEAPON_DAMAEG = GetWeaponDamageType(WEAPON)
                        N_0x4757f00bc6323cfe(GetHashKey("WEAPON_EXPLOSION"), 0.0) 
                        if WEAPON_DAMAEG == 4 or WEAPON_DAMAEG == 5 or WEAPON_DAMAEG == 6 or WEAPON_DAMAEG == 13 then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiWeaponsExplosivePunishment, "Anti Weapon Explosive Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiPedChanger then
                        local ENMODEL = GetEntityModel(PED)
                        for i, value in pairs(Peds) do
                            if ENMODEL == GetHashKey(value) then
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiPedChangerPunishment, "Anti Ped Changer Detected")
                                Wait(0)
                            end
                        end
                    end
                    if Config.AntiFlyandNoclip then
                        local aboveground =  GetEntityHeightAboveGround(PED)
                        if tonumber(aboveground) > 10 then
                            if not IsPedInAnyVehicle(PED) and not IsPedInParachuteFreeFall(PED) and not IsPedFalling(PED) and not IsEntityAttached(PED) and not IsPedSwimming(PED) and not IsPedSwimmingUnderWater(PED) and not IsPlayerDead(PED) then
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiFlyandNoclipPunishment, "Anti Fly Detected")
                            end
                        end
                        Wait(0)
                    end
                    if Config.AntiBlacklistTasks then
                        for _,task in pairs(Tasks) do
                            if GetIsTaskActive(PED, task) then
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlacklistTasksPunishment, "Anti Black List Tasks "..task.." Detected")
                                Wait(0)
                            end
                        end
                    end
                    if Config.AntiBlacklistAnims then
                        for _,anim in pairs(Anims) do
                            if IsEntityPlayingAnim(PED, anim[1], anim[2], 3) then
                                TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiBlacklistAnimsPunishment, "Anti Black List Animation "..anim[1]" and "..anim[2].." Detected")
                                Wait(0)
                                ClearPedTasksImmediately(PED)
                                ClearPedTasks(PED)
                                ClearPedSecondaryTask(PED)
                            end
                        end
                        Wait(0)
                    end
                    if Config.AntiTinyPed then
                        local Tiny = GetPedConfigFlag(PED, 223, true)
                        if Tiny then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiTinyPedPunishment, "Anti Tiny Ped Detected")
                            Wait(0)
                        end
                        Wait(0)
                    end
                    if Config.AntiNightVision then
                        if IsNightvisionActive() and not IsPedInAnyHeli(PlayerPedId()) then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiNightVisionPunishment, "Anti Night Vision Detected")
                            Wait(0)
                        end
                        if IsSeethroughActive(true) and not IsPedInAnyHeli(PlayerPedId()) then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiNightVisionPunishment, "Anti Termal Vision Detected")
                            Wait(0)
                        end
                    end
                    if Config.AntiTrackPlayer then
                        for i = 1, #PLS do
                            local TPED = GetPlayerPed(PLS[i])
                            if TPED ~= PED then
                                if DoesBlipExist(TPED) then
                                    TRACK = TRACK + 1
                                end
                            end
                        end
                        if TRACK >= Config.AntiTrackMaxTrack then
                            TriggerServerEvent(Config.AntiCheatSystemName..':server:ActionsHandler',Config.AntiTrackPlayerPunishment, "Anti Track Player Detected")
                            Wait(0)
                        end
                    end
                    Wait(100)
                end
            end
        end
    end
end)

RegisterNetEvent(Config.AntiCheatSystemName..':client:requestScreenShot')
AddEventHandler(Config.AntiCheatSystemName..':client:requestScreenShot', function(name, title, color, message, tagEveryone)
    exports['screenshot-basic']:requestScreenshotUpload(Config.ScreenShot.WebHook, "files[]", function(uploadData)
        local image = json.decode(uploadData).attachments[1].proxy_url
        TriggerServerEvent('ReturnScreenShotHome',image)
    end)
end)
