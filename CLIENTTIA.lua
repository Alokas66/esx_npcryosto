ESX = nil

local robbedRecently = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(5)

        if IsControlJustPressed(0, 38) then
            local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(PlayerId(-1))

            if aiming then
                local playerPed = GetPlayerPed(-1)
                local pCoords = GetEntityCoords(playerPed, true)
                local tCoords = GetEntityCoords(targetPed, true)
				if not IsPedInAnyVehicle(playerPed, false) and IsPedArmed(playerPed, 6) then
					if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not IsPedAPlayer(targetPed) and targetPed ~= oldped then
						if IsPedInAnyVehicle(targetPed, false) then
							if GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) < 25 then
								if GetEntitySpeed(targetPed)*3.6 > 20 then
									TaskLeaveVehicle(targetPed, GetVehiclePedIsUsing(targetPed), 4160)
								else
									TaskLeaveVehicle(targetPed, GetVehiclePedIsUsing(targetPed), 1)
								end
								Citizen.Wait(2500)
								if not IsPedInAnyVehicle(targetPed, false) then
									local luck3 = math.random(1, 100)
									if luck3 <= Config.ChangeForPoliceAlert then
										TriggerServerEvent('esx_rikosilmotukset:aseellinencarrob', pCoords.x, pCoords.y, pCoords.z)
										TriggerServerEvent('esx_rikosilmotukset:ilmoitus', "~r~Aseellinen ajoneuvovarkaus")
									end
								end
								TaskSmartFleePed(targetPed, GetPlayerPed(-1), 1000.0, -1, true, true)
								SetPedAsNoLongerNeeded(targetPed)
							end
						else						
							if robbedRecently then
								ESX.ShowNotification("Ryöstö kesken")
							elseif IsPedDeadOrDying(targetPed, true) then
								ESX.ShowNotification("Ryöstettävä on kuollut")
							elseif GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) >= Config.RobDistance then
								ESX.ShowNotification("Kohde on liian kaukana")
							else
								oldped = targetPed
								local luck2 = math.random(1, 100)
								if luck2 <= Config.ChangeForPoliceAlert then
									TriggerServerEvent('esx_rikosilmotukset:aseellinenrob', pCoords.x, pCoords.y, pCoords.z)
									TriggerServerEvent('esx_rikosilmotukset:ilmoitus', "~r~Aseellinen ryöstö")
								end
								if luck2 <= Config.ChangePedWillFightBack then
									fightBack(targetPed)
								else
									if IsPedCuffed(targetPed) or IsPedArmed(targetPed, 7) then
										ESX.ShowNotification("Tyyppi on jo ryöstetty")
									else
										robNpc(targetPed)
									end
								end
							end
						end
					end
				end
            end
        end
    end
end)

function fightBack(targetPed)
    robbedRecently = true
	
    Citizen.CreateThread(function()
		GiveWeaponToPed(targetPed, GetHashKey("weapon_pistol"), 250, false)
		SetAiWeaponDamageModifier(1.0)
		SetPedAccuracy(targetPed, 100)
		SetPedShootRate(targetPed, 1000)
		TaskShootAtEntity(targetPed, GetPlayerPed(-1), 30000, 0xC6EE6B4C)
		SetPedAsNoLongerNeeded(targetPed)
		Citizen.Wait(10000)
        robbedRecently = false
    end)
end

function robNpc(targetPed)
    robbedRecently = true

    Citizen.CreateThread(function()
		ClearPedTasks(targetPed)
		SetEnableHandcuffs(targetPed, true)
        ESX.ShowNotification("Ryöstö aloitettu")
		for xd=1, Config.RobAnimationSeconds*100 do
			Citizen.Wait(0)
			TaskHandsUp(targetPed, 100, GetPlayerPed(-1), 5000, 1)
		end
		RequestAnimDict("mp_common")
		while not HasAnimDictLoaded("mp_common") do 
			Citizen.Wait(0)
		end
		TaskPlayAnim(targetPed, "mp_common", "givetake1_b", 1.0, -1.0, 2000, 0, 1, 0, 0, 0)
		Citizen.Wait(2000)
		TaskSmartFleePed(targetPed, GetPlayerPed(-1), 1000.0, -1, true, true)
		SetPedAsNoLongerNeeded(targetPed)
		local pCoords = GetEntityCoords(GetPlayerPed(-1), true)
		local tCoords = GetEntityCoords(targetPed, true)
		if	IsPedDeadOrDying(targetPed) then
			ESX.ShowNotification("Ryöstettävä on kuollut")
		elseif GetDistanceBetweenCoords(pCoords.x, pCoords.y, pCoords.z, tCoords.x, tCoords.y, tCoords.z, true) >= Config.RobDistance then
			ESX.ShowNotification("Kohde on liian kaukana")
		else
			if not IsPedInAnyVehicle(playerPed, false) then
				local luck = math.random(1, 100)
				if luck <= Config.Chancerobbedhavemoney then
					local kkmanok = math.random(Config.MinMoney, Config.MaxMoney)
					TriggerServerEvent('esx_npcpaskagiveMoney', kkmanok)
				else
					ESX.ShowNotification("Tyypillä ei ole rahaa")
				end
			end
		end

        if Config.ShouldWaitBetweenRobbing then
            Citizen.Wait(math.random(Config.MinWaitSeconds, Config.MaxWaitSeconds) * 1000)
            ESX.ShowNotification("Voit ryöstää uudelleen")
        end
        robbedRecently = false
    end)
end


RegisterNetEvent('satijuuvihhutallasta')
AddEventHandler('satijuuvihhutallasta', function(rahamaara)
	ESX.ShowNotification("Sait ~g~" ..rahamaara.." ~s~€")	
end)