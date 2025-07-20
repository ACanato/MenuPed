local savedPedStates = {}

ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) 
            ESX = obj 
        end)
        Citizen.Wait(0)
    end

    TriggerEvent('chat:addSuggestion', '/changeped', 'Mudar o Ped de um jogador', {
        { name="ped", help="Nome do ped" },
        { name="id", help="ID" }
    })

    TriggerEvent('chat:addSuggestion', '/cancelarped', 'Voltar ao normal (Ped)', {
        { name="id", help="ID" }
    })
end)

function saveCurrentPedState()
    local playerId = GetPlayerServerId(PlayerId())
    local ped = PlayerPedId()
    local pedModel = GetEntityModel(ped)

    local components = {}

    for i = 0, 11 do
        components[i] = {
            drawable = GetPedDrawableVariation(ped, i),
            texture = GetPedTextureVariation(ped, i),
            palette = GetPedPaletteVariation(ped, i)
        }
    end

    savedPedStates[playerId] = { 
        model = pedModel,
        components = components
    }
end

RegisterNetEvent('my_ped_changer:applyPed')
AddEventHandler('my_ped_changer:applyPed', function(pedModel)
    saveCurrentPedState()

    local model = GetHashKey(pedModel)
    if IsModelInCdimage(model) and IsModelValid(model) then
        RequestModel(model)

        while not HasModelLoaded(model) do
            Citizen.Wait(10)
        end

        SetPlayerModel(PlayerId(), model)
        SetModelAsNoLongerNeeded(model)
        SetPedDefaultComponentVariation(PlayerPedId())

        ESX.ShowNotification('~g~O ped foi alterado!~w~')
    else
        ESX.ShowNotification('~r~Ped inválido!~w~')
    end
end)

RegisterNetEvent('my_ped_changer:revertPed')
AddEventHandler('my_ped_changer:revertPed', function()
    local playerId = GetPlayerServerId(PlayerId())
    local pedState = savedPedStates[playerId]

    if not pedState then
        ESX.ShowNotification('Não foi possivel salvar o personagem!')
        return
    end

    local model = pedState.model

    RequestModel(model)

    while not HasModelLoaded(model) do
        Citizen.Wait(10)
    end

    SetPlayerModel(PlayerId(), model)
    SetModelAsNoLongerNeeded(model)

    local ped = PlayerPedId()
    for componentId, componentData in pairs(pedState.components) do
        SetPedComponentVariation(ped, componentId, componentData.drawable, componentData.texture, componentData.palette)
    end
end)