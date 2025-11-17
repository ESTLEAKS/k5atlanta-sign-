-- ATLANTA Hollywood Sign Replacement for FiveM
-- Client-side script

local atlantaLetters = {
    {x = 1429.0, y = 1137.0, z = 120.0, heading = 16.0}, -- A
    {x = 1434.0, y = 1138.0, z = 120.0, heading = 16.0}, -- T
    {x = 1439.0, y = 1139.0, z = 120.0, heading = 16.0}, -- L
    {x = 1444.0, y = 1140.0, z = 120.0, heading = 16.0}, -- A
    {x = 1449.0, y = 1141.0, z = 120.0, heading = 16.0}, -- N
    {x = 1454.0, y = 1142.0, z = 120.0, heading = 16.0}, -- T
    {x = 1459.0, y = 1143.0, z = 120.0, heading = 16.0}  -- A
}

local letters = {"A", "T", "L", "A", "N", "T", "A"}
local spawnedObjects = {}

Citizen.CreateThread(function()
    -- Remove original Hollywood sign props
    local hollywoodProps = {
        `prop_sign_hollywood_01`,
        `prop_sign_hollywood_02`,
        `prop_sign_hollywood_03`
    }
    
    for _, model in ipairs(hollywoodProps) do
        local obj = GetClosestObjectOfType(1440.0, 1140.0, 120.0, 500.0, model, false, false, false)
        if obj ~= 0 then
            SetEntityAsMissionEntity(obj, true, true)
            DeleteObject(obj)
        end
    end

    -- Create ATLANTA letters with red neon effect
    for i, pos in ipairs(atlantaLetters) do
        local model = `prop_sub_letter_` .. string.lower(letters[i])
        
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(0)
        end

        local obj = CreateObject(model, pos.x, pos.y, pos.z, false, false, false)
        SetEntityHeading(obj, pos.heading)
        FreezeEntityPosition(obj, true)
        
        -- Set red neon glow
        SetEntityProofs(obj, false, false, false, false, false, false, false, false)
        
        -- Add to tracking table
        table.insert(spawnedObjects, obj)
    end

    print("^2[ATLANTA Sign] ^7Sign installed successfully!")
end)

-- Add red neon lighting effect
Citizen.CreateThread(function()
    while true do
        Wait(0)
        
        for _, obj in ipairs(spawnedObjects) do
            if DoesEntityExist(obj) then
                DrawLightWithRange(
                    GetEntityCoords(obj).x,
                    GetEntityCoords(obj).y,
                    GetEntityCoords(obj).z,
                    255, 0, 0, -- Red color
                    15.0,      -- Range
                    5.0        -- Intensity
                )
            end
        end
    end
end)

-- Cleanup on resource stop
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for _, obj in ipairs(spawnedObjects) do
            if DoesEntityExist(obj) then
                DeleteObject(obj)
            end
        end
        print("^1[ATLANTA Sign] ^7Sign removed!")
    end
end)
