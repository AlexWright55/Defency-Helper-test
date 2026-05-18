-- modules/vehicles.lua
local M = {}

M.cache = {}        -- кэш транспорта (номера, модели и т.д.)
M.byId = {}         -- для быстрого поиска

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    local path = Defency.Config.GetModulePath("vehicles")
    
    if doesFileExist(path) then
        local data = Defency.Utils.ReadJson(path)
        if data then
            M.cache = data.cache or {}
            print("[Vehicles] Загружен кэш транспорта (" .. #M.cache .. " записей)")
        end
    end
end

function M.Save()
    local path = Defency.Config.GetModulePath("vehicles")
    Defency.Utils.WriteJson(path, { cache = M.cache })
end

-- ====================== ОСНОВНЫЕ ФУНКЦИИ ======================
function M.AddVehicleToCache(sampVehicleId, number, model)
    table.insert(M.cache, {
        carID = sampVehicleId,
        number = number,
        model = model or getCarModel(storeCarCharIsInNoSave(PLAYER_PED)),
        timestamp = os.time()
    })
    M.Save()
end

function M.GetVehiclePlateByHandle(carHandle)
    for _, veh in ipairs(M.cache) do
        local success, handle = sampGetCarHandleBySampVehicleId(veh.carID)
        if success and handle == carHandle then
            return veh.number
        end
    end
    return ""
end

function M.GetNearestVehicleInfo()
    local closest = nil
    local minDist = 9999
    local myX, myY, myZ = getCharCoordinates(PLAYER_PED)
    
    for _, veh in ipairs(getAllVehicles()) do
        if doesVehicleExist(veh) then
            local x, y, z = getCarCoordinates(veh)
            local dist = getDistanceBetweenCoords3d(myX, myY, myZ, x, y, z)
            
            if dist < minDist and dist < 50 then
                minDist = dist
                closest = veh
            end
        end
    end
    
    if closest then
        local model = getCarModel(closest)
        local plate = M.GetVehiclePlateByHandle(closest)
        local color1, color2 = getCarColours(closest)
        
        return {
            handle = closest,
            model = model,
            modelName = getNameOfARZVehicleModel(model) or "Неизвестно",
            plate = plate,
            distance = minDist,
            color1 = color1
        }
    end
    return nil
end

-- ====================== ВСПОМОГАТЕЛЬНЫЕ ======================
function M.ClearOldCache(days)
    local now = os.time()
    local limit = days * 86400
    
    local newCache = {}
    for _, veh in ipairs(M.cache) do
        if (now - (veh.timestamp or 0)) < limit then
            table.insert(newCache, veh)
        end
    end
    M.cache = newCache
    M.Save()
end

return M