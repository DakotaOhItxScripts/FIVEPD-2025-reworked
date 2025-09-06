local targetVeh = nil
local stoppedDriver = nil
local stoppedDriver2 = nil
local stoppedDriver3 = nil
local stoppedDriver4 = nil
pitting = false
request = false
local distance = 20.0

function Notify(Text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(Text)
    DrawNotification(false, false)
end

function pit()  
	player = GetPlayerPed(-1)
	playerVeh = GetVehiclePedIsIn(player, false)
	if GetVehicleClass(playerVeh) == 18 then
		local pvPos = GetEntityCoords(playerVeh)
		local inFrontOfPlayerVeh = GetOffsetFromEntityInWorldCoords(playerVeh, 0.0, distance, 0.0 )
		targetVeh = GetVehicleInDirection(pvPos, inFrontOfPlayerVeh)
		stoppedVeh = targetVeh
		stoppedDriver = GetPedInVehicleSeat(stoppedVeh, -1)
		stoppedDriver2 = GetPedInVehicleSeat(stoppedVeh, 0)
		stoppedDriver3 = GetPedInVehicleSeat(stoppedVeh, 1)
		stoppedDriver4 = GetPedInVehicleSeat(stoppedVeh, 2)				
		if (targetVeh == NULL) then
			Notify("~b~Dispatch: ~w~Get Closer to the Suspect")					
		else
			pitting = false
			request = true
			local vehicleHash = GetEntityModel(targetVeh)
			pitblip = AddBlipForEntity(targetVeh)
			SetBlipColour(pitblip, 29)
			SetBlipFlashes(pitblip, true)
			Notify("~b~Officer:~w~ Requesting permission to pit the ~y~"..GetLabelText(GetDisplayNameFromVehicleModel(vehicleHash)).."~w~.")
			pitWait = math.random(3,10)
			Wait(pitWait * 1000)
			if(request==true)then
				Notify("~b~Dispatch: ~w~Permission to pit ~g~GRANTED~w~.")
				pitting = true
				while (pitting==true)do
					Citizen.Wait(0)
					if GetEntitySpeed(targetVeh) < 5 then --Sets the min speed for drive to stop
					Citizen.Wait(1000)
					Notify("~b~Officer: ~w~Pit ~g~SUCCESSFUL~w~.")
					TaskVehicleTempAction(stoppedDriver,stoppedVeh,24, 10000)
					SetBlockingOfNonTemporaryEvents(stoppedDriver, true)
					SetBlockingOfNonTemporaryEvents(stoppedDriver2, true)
					SetBlockingOfNonTemporaryEvents(stoppedDriver3, true)
					SetBlockingOfNonTemporaryEvents(stoppedDriver4, true)
					pitting = false
					request = false
					pitblip = RemoveBlip(pitblip)
					end
				end
				else
				end
			end
		end
	end


function GetVehicleInDirection( coordFrom, coordTo )
    local rayHandle = CastRayPointToPoint( coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z, 30, player, 0 )
    local _, _, _, _, targetVeh = GetRaycastResult( rayHandle )
    
	if ( IsEntityAVehicle( targetVeh ) ) then 
        return targetVeh
    end 
end

RegisterCommand( "pit", function()
	if(request == false and pitting==false) then
		pit()
	elseif(request==true and pitting==false)then
		Notify("~b~Dispatch: ~w~Pit request ~r~CANCELLED~w~.")
		request=false
		pitblip = RemoveBlip(pitblip)
	elseif(request==true and pitting==true)then
		Notify("~b~Dispatch: ~w~Pit request ~r~CANCELLED~w~.")
		pitting=false
		request=false
		pitblip = RemoveBlip(pitblip)
	end
end )
RegisterKeyMapping('pit', 'pit', 'keyboard', 'RMENU')