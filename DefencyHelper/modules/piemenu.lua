-- modules/piemenu.lua
local M = {}

M.data = {
    my = {}  -- сюда будут сохраняться пункты кругового меню
}

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    local path = Defency.Config.GetModulePath("piemenu")
    
    if doesFileExist(path) then
        local loaded = Defency.Utils.ReadJson(path)
        if loaded and loaded.my then
            M.data.my = loaded.my
            print("[PieMenu] Загружено " .. #M.data.my .. " пунктов")
        end
    else
        print("[PieMenu] Создан новый файл кругового меню")
        M.Save()
    end
end

function M.Save()
    local path = Defency.Config.GetModulePath("piemenu")
    Defency.Utils.WriteJson(path, M.data)
end

-- ====================== РАБОТА С ПУНКТАМИ ======================
function M.AddItem(icon, name, action, waiting)
    table.insert(M.data.my, {
        icon = icon or fa.CIRCLE,
        name = name or "Новый пункт",
        action = action or "/me новое действие",
        waiting = waiting or 2.0,
        enable = true
    })
    M.Save()
end

function M.RemoveItem(index)
    if M.data.my[index] then
        table.remove(M.data.my, index)
        M.Save()
        return true
    end
    return false
end

function M.GetAllItems()
    return M.data.my
end

-- ====================== ВЫПОЛНЕНИЕ ======================
function M.ExecuteItem(item)
    if not item or not item.enable then return end
    
    local text = Defency.Utils.ReplaceTags(item.action)
    
    for line in text:gmatch("([^&]+)") do
        line = line:gsub("^%s+", ""):gsub("%s+$", "")
        if line ~= "" then
            sampSendChat(line)
            wait(math.floor((item.waiting or 2) * 1000))
        end
    end
end

return M