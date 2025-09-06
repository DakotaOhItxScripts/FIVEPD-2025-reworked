--Coded by Albo1125

RegisterServerEvent("FireScript:FirePutOut")
AddEventHandler("FireScript:FirePutOut", function(x, y, z)
	TriggerClientEvent('FireScript:StopFireAtPosition', -1, x, y, z)
	print("Fire put out - syncing to all clients."..x..y..z)
end)

--my code
RegisterServerEvent("FireScript:StartFire")
AddEventHandler("FireScript:StartFire", function(source, maxFlames, maxRange, fixedHeight)
	TriggerClientEvent('FireScript:StartFireAtLocation', -1, source, maxFlames, maxRange, fixedHeight)
	print("Fire starting")
end)
RegisterServerEvent("FireScript:StopFire")
AddEventHandler("FireScript:StopFire", function(source)
	TriggerClientEvent('FireScript:StopFiresAtLocation', -1, source)
	print("Fire Stopping")
end)
--end of my code

AddEventHandler('chatMessage', function(source, n, message)
    command = stringsplit(message, " ")

	if command[1] == "/startfire" then
		CancelEvent()
		TriggerClientEvent('FireScript:StartFireAtPlayer', -1, source, tonumber(command[2]), tonumber(command[3]), not not command[4])
		print("starting fire")
	elseif command[1] == "/stopfire" then
		CancelEvent()
		TriggerClientEvent('FireScript:StopFiresAtPlayer', -1, source)
		print("stopping fire")
	elseif command[1] == "/stopallfires" then
		CancelEvent()
		TriggerClientEvent('FireScript:StopAllFires', -1)
		print("stopping all fires")
	end
end)

function stringsplit(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end