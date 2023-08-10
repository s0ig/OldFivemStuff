-- Usable campfire item.. Only 1 campfire can be active by player.
-- It will destory itself in 10minutes
ESX.RegisterUsableItem('campfire', function(source)
  if not playercampfires[source] then
	local _source = source
	local xPlayer  = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('campfire', 1)
	TriggerClientEvent("sm_crafting:campfire",source)
  end
end)

-- This item rolls for random formula
ESX.RegisterUsableItem('formula_tube', function(source)
 	rollForFormula(source)
end)

--This is just an example how to create formula 
ESX.RegisterUsableItem('formula_campfire', function(source)
	local xPlayer = ESX.GetPlayerFromId(source)
	xPlayer.removeInventoryItem('formula_campfire', 1)
	TriggerEvent("sm_crafting:newFormula", source, 'formula_campfire')
end)

ESX.RegisterUsableItem('craftingbook', function(source)
	local xPlayer  = ESX.GetPlayerFromId(source)
	TriggerClientEvent("sm_crafting:openCrafting",source)
end)

-- Molotov
ESX.RegisterUsableItem('formula_molotov', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_molotov', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_molotov')
end)

-- Pistoolin runko
ESX.RegisterUsableItem('formula_pistol_hull', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_pistol_hull', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_pistol_hull')
end)

-- Hammeri
ESX.RegisterUsableItem('formula_weapon_hammer', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_hammer', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_hammer')
end)

-- Bandage
ESX.RegisterUsableItem('formula_bandage', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_bandage', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_bandage')
end)

-- Stun Gun
ESX.RegisterUsableItem('formula_stungun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_stungun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_stungun')
end)

-- Ruuti
ESX.RegisterUsableItem('formula_gunpowder', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_gunpowder', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_gunpowder')
end)

-- -- Pistoolin lipas
-- ESX.RegisterUsableItem('formula_pistolclip', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_pistolclip', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_pistolclip')
-- end)

-- -- Konepistoolin lipas
-- ESX.RegisterUsableItem('formula_kpclip', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_kpclip', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_kpclip')
-- end)

-- -- Rynnäkkökiväärin lipas
-- ESX.RegisterUsableItem('formula_rkclip', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_rkclip', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_rkclip')
-- end)

-- -- Haulikon hauleja
-- ESX.RegisterUsableItem('formula_shotgunclip', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_shotgunclip', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_shotgunclip')
-- end)

-- Jointti
ESX.RegisterUsableItem('formula_joint', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_joint', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_joint')
end)

-- Puhelimen purkaminen
ESX.RegisterUsableItem('formula_electric_scrap_1', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_electric_scrap_1', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_electric_scrap_1')
end)

-- Radion purkaminen
ESX.RegisterUsableItem('formula_electric_scrap_2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_electric_scrap_2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_electric_scrap_2')
end)

-- Sukelluspuvun purkaminen
ESX.RegisterUsableItem('formula_plastic_scrap', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_plastic_scrap', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_plastic_scrap')
end)

-- RFID Spoofer
ESX.RegisterUsableItem('formula_hackingtool', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_hackingtool', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_hackingtool')
end)

-- Cirquit Board
ESX.RegisterUsableItem('formula_circuit_board', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_circuit_board', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_circuit_board')
end)

-- -- Rubber Ducky
ESX.RegisterUsableItem('formula_rubberducky', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_rubberducky', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_rubberducky')
end)

-- -- Beretta 92 9mm clip
ESX.RegisterUsableItem('formula_weapon_pistol_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pistol_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pistol_clip')
end)

-- -- P2000 9mm clip
ESX.RegisterUsableItem('formula_weapon_combatpistol_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatpistol_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatpistol_clip')
end)

-- -- Scamp .22 clip
ESX.RegisterUsableItem('formula_weapon_appistol_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_appistol_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_appistol_clip')
end)

-- -- Desert Eagle 50 clip
ESX.RegisterUsableItem('formula_weapon_pistol50_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pistol50_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pistol50_clip')
end)

-- -- P7M13 9mm clip
ESX.RegisterUsableItem('formula_weapon_snspistol_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_snspistol_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_snspistol_clip')
end)

-- -- 1911 R1 .45 ACP clip
ESX.RegisterUsableItem('formula_weapon_vintagepistol_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_vintagepistol_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_vintagepistol_clip')
end)

-- -- M9A3 9mm clip
ESX.RegisterUsableItem('formula_weapon_pistol_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pistol_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pistol_mk2_clip')
end)

-- -- AMT .380 ACP clip
ESX.RegisterUsableItem('formula_weapon_snspistol_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_snspistol_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_snspistol_mk2_clip')
end)

-- -- .308 clip
ESX.RegisterUsableItem('formula_weapon_marksmanpistol_bullet', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_marksmanpistol_bullet', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_marksmanpistol_bullet')
end)

-- -- .44 clip
ESX.RegisterUsableItem('formula_weapon_revolver_bullet', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_revolver_bullet', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_revolver_bullet')
end)

-- -- .357 clip
ESX.RegisterUsableItem('formula_weapon_revolver_mk2_bullet', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_revolver_mk2_bullet', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_revolver_mk2_bullet')
end)

-- -- .38 LC clip
ESX.RegisterUsableItem('formula_weapon_doubleaction_bullet', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_doubleaction_bullet', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_doubleaction_bullet')
end)

-- -- UZI 9mm clip
ESX.RegisterUsableItem('formula_weapon_microsmg_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_microsmg_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_microsmg_clip')
end)

-- -- .MP5 9mm clip
ESX.RegisterUsableItem('formula_weapon_smg_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_smg_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_smg_clip')
end)

-- -- P90 5.56mm clip
ESX.RegisterUsableItem('formula_weapon_assaultsmg_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_assaultsmg_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_assaultsmg_clip')
end)

-- -- Thompson .45 ACP clip
ESX.RegisterUsableItem('formula_weapon_gusenberg_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_gusenberg_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_gusenberg_clip')
end)

-- -- MPX-SD 9mm clip
ESX.RegisterUsableItem('formula_weapon_combatpdw_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatpdw_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatpdw_clip')
end)

-- -- TEC-9 9mm clip
ESX.RegisterUsableItem('formula_weapon_machinepistol_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_machinepistol_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_machinepistol_clip')
end)

-- -- vz 61 .380 ACP clip
ESX.RegisterUsableItem('formula_weapon_minismg_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_minismg_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_minismg_clip')
end)

-- -- MPX-K 9mm clip
ESX.RegisterUsableItem('formula_weapon_smg_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_smg_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_smg_mk2_clip')
end)

-- -- AK-47 7.62mm clip
ESX.RegisterUsableItem('formula_weapon_assaultrifle_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_assaultrifle_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_assaultrifle_clip')
end)

-- -- AR-15 5.56mm clip
ESX.RegisterUsableItem('formula_weapon_carbinerifle_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_carbinerifle_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_carbinerifle_clip')
end)

-- -- TAR-21 5.56mm clip
ESX.RegisterUsableItem('formula_weapon_advancedrifle_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_advancedrifle_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_advancedrifle_clip')
end)

-- -- G36 5.56mm clip
ESX.RegisterUsableItem('formula_weapon_specialcarbine_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_specialcarbine_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_specialcarbine_clip')
end)

-- -- QBZ-95 5.56mm clip
ESX.RegisterUsableItem('formula_weapon_bullpuprifle_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_bullpuprifle_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_bullpuprifle_clip')
end)

-- -- AKS-74U 5.45mm clip
ESX.RegisterUsableItem('formula_weapon_compactrifle_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_compactrifle_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_compactrifle_clip')
end)

-- -- G36 5.56mm clip
ESX.RegisterUsableItem('formula_weapon_specialcarabine_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_specialcarabine_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_specialcarabine_mk2_clip')
end)

-- -- Kel-Tec RFB .308 clip
ESX.RegisterUsableItem('formula_weapon_bullpruprifle_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_bullpruprifle_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_bullpruprifle_mk2_clip')
end)

-- -- AK-12 5.45mm clip
ESX.RegisterUsableItem('formula_weapon_assaultrifle_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_assaultrifle_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_assaultrifle_mk2_clip')
end)

-- -- MPX-C 9mm clip
ESX.RegisterUsableItem('formula_weapon_carbinerifle_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_carbinerifle_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_carbinerifle_mk2_clip')
end)

-- -- L96A1 .308 clip
ESX.RegisterUsableItem('formula_weapon_sniperrifle_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_sniperrifle_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_sniperrifle_clip')
end)

-- -- M82A1 .50 clip
ESX.RegisterUsableItem('formula_weapon_heavysniper_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_heavysniper_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_heavysniper_clip')
end)

-- -- M39 .308 clip
ESX.RegisterUsableItem('formula_weapon_marksmanpistol_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_marksmanpistol_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_marksmanpistol_clip')
end)

-- -- Ruger Mini 7.62mm clip
ESX.RegisterUsableItem('formula_weapon_marksmanrifle_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_marksmanrifle_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_marksmanrifle_mk2_clip')
end)

-- -- XM500 .50 clip
ESX.RegisterUsableItem('formula_weapon_heavysniper_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_heavysniper_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_heavysniper_mk2_clip')
end)

-- -- PKM 7.62mm clip
ESX.RegisterUsableItem('formula_weapon_mg_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_mg_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_mg_clip')
end)

-- -- M249 5.56mm clip
ESX.RegisterUsableItem('formula_weapon_combatmg_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatmg_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatmg_clip')
end)

-- -- MK 48 .308  clip
ESX.RegisterUsableItem('formula_weapon_combatmg_mk2_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatmg_mk2_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatmg_mk2_clip')
end)

-- -- 12/76 clip
ESX.RegisterUsableItem('formula_weapon_shotgun_shell', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_shotgun_shell', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_shotgun_shell')
end)

-- -- Saiga-12 12/76
ESX.RegisterUsableItem('formula_weapon_heavyshotgun_clip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_heavyshotgun_clip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_heavyshotgun_clip')
end)

-- -- Beretta 92 9mm 
ESX.RegisterUsableItem('formula_weapon_pistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pistol')
end)

-- -- P2000 9mm 
ESX.RegisterUsableItem('formula_weapon_combatpistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatpistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatpistol')
end)

-- -- Scamp .22 
ESX.RegisterUsableItem('formula_weapon_appistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_appistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_appistol')
end)

-- -- Desert Eagle 50 
ESX.RegisterUsableItem('formula_weapon_pistol50', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pistol50', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pistol50')
end)

-- -- P7M13 9mm 
ESX.RegisterUsableItem('formula_weapon_snspistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_snspistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_snspistol')
end)

-- -- 1911 R1 .45 ACP 
ESX.RegisterUsableItem('formula_weapon_vintagepistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_vintagepistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_vintagepistol')
end)

-- -- M9A3 9mm 
ESX.RegisterUsableItem('formula_weapon_pistol_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pistol_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pistol_mk2')
end)

-- -- AMT .380 ACP 
ESX.RegisterUsableItem('formula_weapon_snspistol_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_snspistol_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_snspistol_mk2')
end)

-- -- .308 
ESX.RegisterUsableItem('formula_weapon_marksmanpistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_marksmanpistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_marksmanpistol')
end)

-- -- .44 
ESX.RegisterUsableItem('formula_weapon_revolver', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_revolver', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_revolver')
end)

-- -- .357 
ESX.RegisterUsableItem('formula_weapon_revolver_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_revolver_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_revolver_mk2')
end)

-- -- .38 LC 
ESX.RegisterUsableItem('formula_weapon_doubleaction', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_doubleaction', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_doubleaction')
end)

-- -- UZI 9mm 
ESX.RegisterUsableItem('formula_weapon_microsmg', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_microsmg', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_microsmg')
end)

-- -- .MP5 9mm 
ESX.RegisterUsableItem('formula_weapon_smg', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_smg', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_smg')
end)

-- -- P90 5.56mm 
ESX.RegisterUsableItem('formula_weapon_assaultsmg', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_assaultsmg', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_assaultsmg')
end)

-- -- Thompson .45 ACP 
ESX.RegisterUsableItem('formula_weapon_gusenberg', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_gusenberg', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_gusenberg')
end)

-- -- MPX-SD 9mm 
ESX.RegisterUsableItem('formula_weapon_combatpdw', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatpdw', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatpdw')
end)

-- -- TEC-9 9mm 
ESX.RegisterUsableItem('formula_weapon_machinepistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_machinepistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_machinepistol')
end)

-- -- vz 61 .380 ACP 
ESX.RegisterUsableItem('formula_weapon_minismg', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_minismg', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_minismg')
end)

-- -- MPX-K 9mm 
ESX.RegisterUsableItem('formula_weapon_smg_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_smg_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_smg_mk2')
end)

-- -- AK-47 7.62mm 
ESX.RegisterUsableItem('formula_weapon_assaultrifle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_assaultrifle', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_assaultrifle')
end)

-- -- AR-15 5.56mm 
ESX.RegisterUsableItem('formula_weapon_carbinerifle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_carbinerifle', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_carbinerifle')
end)

-- -- TAR-21 5.56mm 
ESX.RegisterUsableItem('formula_weapon_advancedrifle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_advancedrifle', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_advancedrifle')
end)

-- -- G36 5.56mm 
ESX.RegisterUsableItem('formula_weapon_specialcarbine', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_specialcarbine', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_specialcarbine')
end)

-- -- QBZ-95 5.56mm 
ESX.RegisterUsableItem('formula_weapon_bullpuprifle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_bullpuprifle', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_bullpuprifle')
end)

-- -- AKS-74U 5.45mm 
ESX.RegisterUsableItem('formula_weapon_compactrifle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_compactrifle', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_compactrifle')
end)

-- -- G36 5.56mm 
ESX.RegisterUsableItem('formula_weapon_specialcarabine_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_specialcarabine_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_specialcarabine_mk2')
end)

-- -- Kel-Tec RFB .308 
ESX.RegisterUsableItem('formula_weapon_bullpruprifle_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_bullpruprifle_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_bullpruprifle_mk2')
end)

-- -- AK-12 5.45mm 
ESX.RegisterUsableItem('formula_weapon_assaultrifle_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_assaultrifle_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_assaultrifle_mk2')
end)

-- -- MPX-C 9mm 
ESX.RegisterUsableItem('formula_weapon_carbinerifle_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_carbinerifle_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_carbinerifle_mk2')
end)

-- -- L96A1 .308 
ESX.RegisterUsableItem('formula_weapon_sniperrifle', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_sniperrifle', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_sniperrifle')
end)

-- -- M82A1 .50 
ESX.RegisterUsableItem('formula_weapon_heavysniper', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_heavysniper', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_heavysniper')
end)

-- -- M39 .308 
ESX.RegisterUsableItem('formula_weapon_marksmanpistol', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_marksmanpistol', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_marksmanpistol')
end)

-- -- Ruger Mini 7.62mm 
ESX.RegisterUsableItem('formula_weapon_marksmanrifle_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_marksmanrifle_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_marksmanrifle_mk2')
end)

-- -- XM500 .50 
ESX.RegisterUsableItem('formula_weapon_heavysniper_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_heavysniper_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_heavysniper_mk2')
end)

-- -- PKM 7.62mm 
ESX.RegisterUsableItem('formula_weapon_mg', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_mg', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_mg')
end)

-- -- M249 5.56mm 
ESX.RegisterUsableItem('formula_weapon_combatmg', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatmg', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatmg')
end)

-- -- MK 48 .308  
ESX.RegisterUsableItem('formula_weapon_combatmg_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_combatmg_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_combatmg_mk2')
end)

-- -- Saiga-12 12/76
ESX.RegisterUsableItem('formula_weapon_heavyshotgun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_heavyshotgun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_heavyshotgun')
end)

-- -- Heavy shotgun
ESX.RegisterUsableItem('formula_weapon_heavyshotgun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_heavyshotgun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_heavyshotgun')
end)

-- -- pumpshotgun
ESX.RegisterUsableItem('formula_weapon_pumpshotgun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pumpshotgun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pumpshotgun')
end)

-- -- pumpshotgun mk2
ESX.RegisterUsableItem('formula_weapon_pumpshotgun_mk2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_pumpshotgun_mk2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_pumpshotgun_mk2')
end)

-- -- sawnoffshotgun
ESX.RegisterUsableItem('formula_weapon_sawnoffshotgun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_sawnoffshotgun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_sawnoffshotgun')
end)

-- -- bullpupshotgun
ESX.RegisterUsableItem('formula_weapon_bullpupshotgun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_bullpupshotgun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_bullpupshotgun')
end)

-- -- dbshotgun
ESX.RegisterUsableItem('formula_weapon_dbshotgun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_dbshotgun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_dbshotgun')
end)

-- -- musket
ESX.RegisterUsableItem('formula_weapon_musket', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_musket', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_musket')
end)

-- -- assautl shotgun
ESX.RegisterUsableItem('formula_weapon_assaultshotgun', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_weapon_assaultshotgun', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_assaultshotgun')
end)

-- -- speed drill
ESX.RegisterUsableItem('formula_speeddrill_machine', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_speeddrill_machine', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_speeddrill_machine')
end)

-- -- CNC machine
ESX.RegisterUsableItem('formula_cnc', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_cnc', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_cnc')
end)

-- -- Gun table big
ESX.RegisterUsableItem('formula_gun_table_big', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_gun_table_big', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_gun_table_big')
end)

-- -- Gun table small
ESX.RegisterUsableItem('formula_gun_table_small', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_gun_table_small', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_gun_table_small')
end)

-- -- Lathe machine
ESX.RegisterUsableItem('formula_lathe', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_lathe', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_lathe')
end)

-- -- Submachine hull
ESX.RegisterUsableItem('formula_smg_hull', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_smg_hull', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_smg_hull')
end)

-- -- Submachine barrel
ESX.RegisterUsableItem('formula_smg_barrel', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_smg_barrel', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_smg_barrel')
end)

-- -- Riffle hull
ESX.RegisterUsableItem('formula_rifle_hull', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_rifle_hull', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_rifle_hull')
end)

-- -- Riffle barrel
ESX.RegisterUsableItem('formula_rifle_barrel', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_rifle_barrel', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_rifle_barrel')
end)

-- -- Riffle grip
ESX.RegisterUsableItem('formula_rifle_grip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_rifle_grip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_rifle_grip')
end)

-- -- Riffle butstock
ESX.RegisterUsableItem('formula_rifle_butstock', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_rifle_butstock', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_rifle_butstock')
end)

-- -- Shotgun hull
ESX.RegisterUsableItem('formula_shotgun_hull', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_shotgun_hull', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_shotgun_hull')
end)

-- -- Shotgun barrel
ESX.RegisterUsableItem('formula_shotgun_barrel', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_shotgun_barrel', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_shotgun_barrel')
end)

-- -- Shotgun butstock
ESX.RegisterUsableItem('formula_shotgun_butstock', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_shotgun_butstock', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_shotgun_butstock')
end)

-- -- Sniper hull
ESX.RegisterUsableItem('formula_sniper_hull', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_sniper_hull', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_sniper_hull')
end)

-- -- Sniper barrel
ESX.RegisterUsableItem('formula_sniper_barrel', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_sniper_barrel', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_sniper_barrel')
end)

-- -- Sniper grip
ESX.RegisterUsableItem('formula_sniper_grip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_sniper_grip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_sniper_grip')
end)

-- -- Sniper butstock
ESX.RegisterUsableItem('formula_sniper_butstock', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_sniper_butstock', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_sniper_butstock')
end)

-- -- LMG hull
ESX.RegisterUsableItem('formula_lmg_hull', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_lmg_hull', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_lmg_hull')
end)

-- -- LMG barrel
ESX.RegisterUsableItem('formula_lmg_barrel', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_lmg_barrel', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_lmg_barrel')
end)

-- -- LMG grip
ESX.RegisterUsableItem('formula_lmg_grip', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_lmg_grip', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_lmg_grip')
end)

-- -- LMG butstock
ESX.RegisterUsableItem('formula_lmg_butstock', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_lmg_butstock', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_lmg_butstock')
end)

-- -- Potion 1 Kasvintunnistusuute
ESX.RegisterUsableItem('formula_potion_1', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_potion_1', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_potion_1')
end)

-- -- Potion 2 Kuntoeliksiiri
ESX.RegisterUsableItem('formula_potion_2', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_potion_2', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_potion_2')
end)

-- -- Potion 3 Vauhtieliksiiri
ESX.RegisterUsableItem('formula_potion_3', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_potion_3', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_potion_3')
end)

-- -- Potion 4 Elvytyseliksiiri
ESX.RegisterUsableItem('formula_potion_4', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('formula_potion_4', 1)
    TriggerEvent("sm_crafting:newFormula", source, 'formula_potion_4')
end)

-- -- -- Metalpipe
-- ESX.RegisterUsableItem('formula_metalpipe', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_metalpipe', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_metalpipe')
-- end)

-- -- -- Spring
-- ESX.RegisterUsableItem('formula_spring', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_spring', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_spring')
-- end)

-- -- -- Metal file
-- ESX.RegisterUsableItem('formula_metalfile', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_metalfile', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_metalfile')
-- end)

-- -- -- Toolbox
-- ESX.RegisterUsableItem('formula_toolbox', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_toolbox', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_toolbox')
-- end)

-- -- -- Hammer
-- ESX.RegisterUsableItem('formula_weapon_hammer', function(source)
--     local xPlayer = ESX.GetPlayerFromId(source)
--     xPlayer.removeInventoryItem('formula_weapon_hammer', 1)
--     TriggerEvent("sm_crafting:newFormula", source, 'formula_weapon_hammer')
-- end)

-- CNC machine
ESX.RegisterUsableItem('cnc_machine', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('cnc_machine', 1)
    TriggerEvent("talot:addFurnitureForPlayer", source, {
    name = "CNC kone",
    hash = "gr_prop_gr_cnc_01c",
    },"Askartelu")
end)

-- Big gun table (tier 3)
ESX.RegisterUsableItem('gun_table_big', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('gun_table_big', 1)
    TriggerEvent("talot:addFurnitureForPlayer", source, {
    name = "Suurempi työpöytä",
    hash = "gr_prop_gr_bench_01a",
    },"Askartelu")
end)

-- Small gun table (tier 2)
ESX.RegisterUsableItem('gun_table_small', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('gun_table_small', 1)
    TriggerEvent("talot:addFurnitureForPlayer", source, {
    name = "Pienempi työpöytä",
    hash = "gr_prop_gr_bench_02a",
    },"Askartelu")
end)

-- Lathe machine
ESX.RegisterUsableItem('lathe_machine', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('lathe_machine', 1)
    TriggerEvent("talot:addFurnitureForPlayer", source, {
    name = "Sorvi",
    hash = "gr_prop_gr_lathe_01c",
    },"Askartelu")
end)

-- Speeddrill machine
ESX.RegisterUsableItem('speeddrill_machine', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem('speeddrill_machine', 1)
    TriggerEvent("talot:addFurnitureForPlayer", source, {
    name = "Pylväsporakone",
    hash = "gr_prop_gr_speeddrill_01c",
    },"Askartelu")
end)