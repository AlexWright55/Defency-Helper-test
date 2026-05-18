-- modules/rp_guns.lua
local M = {}

M.guns = {}
M.byId = {}
M.rpTakeNames = {
    {"из-за спины", "за спину"},
    {"из кармана", "в карман"},
    {"из по€са", "на по€с"},
    {"из кобуры", "в кобуру"}
}

-- ====================== »Ќ»÷»јЋ»«ј÷»я ======================
function M.Init()
    local path = Defency.Config.GetModulePath("rpgun")
    
    if doesFileExist(path) then
        local data = Defency.Utils.ReadJson(path)
        if data and data.rp_guns then
            M.guns = data.rp_guns
            print("[RP Guns] «агружено " .. #M.guns .. " единиц оружи€")
        end
    else
        print("[RP Guns] ‘айл Guns.json не найден Ч используем встроенный список")
        M.LoadDefaultGuns()
    end

    M.RebuildIndex()
end

function M.Save()
    local path = Defency.Config.GetModulePath("rpgun")
    local data = { rp_guns = M.guns }
    Defency.Utils.WriteJson(path, data)
end

function M.LoadDefaultGuns()
    -- ћожно оставить минимальный дефолтный набор или полностью убрать
    M.guns = {} -- заполн€етс€ пользователем через интерфейс
end

function M.RebuildIndex()
    M.byId = {}
    for _, gun in ipairs(M.guns) do
        if gun.id then
            M.byId[gun.id] = gun
        end
    end
end

-- ====================== ќ—Ќќ¬Ќџ≈ ‘”Ќ ÷»» ======================
function M.TakeWeapon(gun_id)
    local gun = M.byId[gun_id]
    if not gun or not gun.enable then 
        sampAddChatMessage("{FF9900}[RP Guns] {FFFFFF}Ёто оружие отключено в настройках.", -1)
        return false 
    end

    local action = M.GetRandomTakeAction()
    local text = string.format("/me %s %s", action, gun.name)
    
    sampSendChat(text)
    wait(tonumber(gun.waiting or 3) * 1000)
    
    return true
end

function M.GetRandomTakeAction()
    local group = M.rpTakeNames[math.random(#M.rpTakeNames)]
    return group[math.random(#group)]
end

function M.IsEnabled(gun_id)
    local gun = M.byId[gun_id]
    return gun and gun.enable
end

-- ƒл€ интерфейса
function M.GetGunById(id)
    return M.byId[id]
end

function M.GetAllGuns()
    return M.guns
end

return M