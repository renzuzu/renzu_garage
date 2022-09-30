function Framework()
	if Config.framework == 'ESX' then
		ESX = exports['es_extended']:getSharedObject()
		PlayerData = ESX.GetPlayerData()
	elseif Config.framework == 'QBCORE' then
		QBCore = exports['qb-core']:GetCoreObject()
		QBCore.Functions.GetPlayerData(function(p)
			PlayerData = p
			if PlayerData.job ~= nil then
				PlayerData.job.grade = PlayerData.job.grade.level
			end
			if PlayerData.identifier == nil then
				PlayerData.identifier = PlayerData.license
			end
        end)
		vehicletable = 'player_vehicles'
		vehiclemod = 'mods'
		owner = 'license'
		stored = 'state'
		garage__id = 'garage'
		type_ = 'vehicle'
	end
end

function Playerloaded()
	if Config.framework == 'ESX' then
		RegisterNetEvent('esx:playerLoaded')
		AddEventHandler('esx:playerLoaded', function(xPlayer)
			playerloaded = true
			PlayerData = xPlayer
			LocalPlayer.state:set( 'loaded', true, true)
			LocalPlayer.state.loaded = true
			if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
				for k, v in pairs (helispawn[PlayerData.job.name]) do
					local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
					SetBlipSprite (blip, v.Blip.sprite)
					SetBlipDisplay(blip, 4)
					SetBlipScale  (blip, v.Blip.scale)
					SetBlipColour (blip, v.Blip.color)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName('STRING')
					AddTextComponentSubstringPlayerName(""..v.garage.."")
					EndTextCommandSetBlipName(blip)
				end
			end
			if Config.Realistic_Parking then
				TriggerServerEvent('renzu_garage:GetParkedVehicles')
			end
		end)
	elseif Config.framework == 'QBCORE' then
		RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
		AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
			playerloaded = true
			QBCore.Functions.GetPlayerData(function(p)
				PlayerData = p
				if PlayerData.job ~= nil then
					PlayerData.job.grade = PlayerData.job.grade.level
				end
				if PlayerData.identifier == nil then
					PlayerData.identifier = PlayerData.license
				end
			end)
			LocalPlayer.state:set( 'loaded', true, true)
			LocalPlayer.state.loaded = true
			if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
				for k, v in pairs (helispawn[PlayerData.job.name]) do
					local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
					SetBlipSprite (blip, v.Blip.sprite)
					SetBlipDisplay(blip, 4)
					SetBlipScale  (blip, v.Blip.scale)
					SetBlipColour (blip, v.Blip.color)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName('STRING')
					AddTextComponentSubstringPlayerName(""..v.garage.."")
					EndTextCommandSetBlipName(blip)
				end
			end
			if Config.Realistic_Parking then
				TriggerServerEvent('renzu_garage:GetParkedVehicles')
			end
		end)
	end
	while not PlayerData.job do Wait(100) end
end

function SetJob()
	if Config.framework == 'ESX' then
		RegisterNetEvent('esx:setJob')
		AddEventHandler('esx:setJob', function(job)
			PlayerData.job = job
			playerjob = PlayerData.job.name
			inmark = false
			cancel = true
			markers = {}
			if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
				for k, v in pairs (helispawn[PlayerData.job.name]) do
					local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
					SetBlipSprite (blip, v.Blip.sprite)
					SetBlipDisplay(blip, 4)
					SetBlipScale  (blip, v.Blip.scale)
					SetBlipColour (blip, v.Blip.color)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName('STRING')
					AddTextComponentSubstringPlayerName(Message[2]..": "..v.garage.."")
					EndTextCommandSetBlipName(blip)
				end
			end
		end)
	elseif Config.framework == 'QBCORE' then
		RegisterNetEvent('QBCore:Client:OnJobUpdate')
		AddEventHandler('QBCore:Client:OnJobUpdate', function(job)
			PlayerData.job = job
			PlayerData.job.grade = PlayerData.job.grade.level
			playerjob = PlayerData.job.name
			inmark = false
			cancel = true
			markers = {}
			if Config.EnableHeliGarage and PlayerData.job ~= nil and helispawn[PlayerData.job.name] ~= nil then
				for k, v in pairs (helispawn[PlayerData.job.name]) do
					local blip = AddBlipForCoord(v.coords.x, v.coords.y, v.coords.z)
					SetBlipSprite (blip, v.Blip.sprite)
					SetBlipDisplay(blip, 4)
					SetBlipScale  (blip, v.Blip.scale)
					SetBlipColour (blip, v.Blip.color)
					SetBlipAsShortRange(blip, true)
					BeginTextCommandSetBlipName('STRING')
					AddTextComponentSubstringPlayerName(Message[2]..": "..v.garage.."")
					EndTextCommandSetBlipName(blip)
				end
			end
		end)
	end
end

CreateThread(function()
    Wait(500)
	if Config.framework == 'ESX' then
		while ESX == nil do Wait(1) end
		TriggerServerCallback_ = function(...)
			ESX.TriggerServerCallback(...)
		end
	elseif Config.framework == 'QBCORE' then
		while QBCore == nil do Wait(1) end
		TriggerServerCallback_ =  function(...)
			QBCore.Functions.TriggerCallback(...)
		end
	end
end)

MathRound = function(value, numDecimalPlaces)
	if numDecimalPlaces then
		local power = 10^numDecimalPlaces
		return math.floor((value * power) + 0.5) / (power)
	else
		return math.floor(value + 0.5)
	end
end

ShowNotification = function(msg)
	if Config.framework == 'ESX' then
		ESX.ShowNotification(msg)
	elseif Config.framework == 'QBCORE' then
		TriggerEvent('QBCore:Notify', msg)
	end
end