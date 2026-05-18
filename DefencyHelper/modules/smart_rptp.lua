-- modules/smart_rptp.lua
local M = {}

M.data = {
    enabled = true,
    auto_calculate = true,
    default_term = 15,           -- минут по умолчанию
    min_term = 5,
    max_term = 60,
    custom_terms = {}
}

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    local path = Defency.Config.GetModulePath("smart_rptp")
    
    if doesFileExist(path) then
        local loaded = Defency.Utils.ReadJson(path)
        if loaded then
            M.data = loaded
            print("[Smart RPTP] Умный срок загружен")
        end
    else
        print("[Smart RPTP] Создан новый файл умного срока")
        M.Save()
    end
end

function M.Save()
    local path = Defency.Config.GetModulePath("smart_rptp")
    Defency.Utils.WriteJson(path, M.data)
end

-- ====================== ОСНОВНАЯ ЛОГИКА ======================
function M.CalculateTerm(reason, player_id)
    if not M.data.enabled then
        return M.data.default_term
    end

    local term = M.data.default_term

    -- Здесь можно добавить умную логику в будущем:
    -- - По типу нарушения
    -- - По количеству предыдущих нарушений
    -- - По рангу сотрудника и т.д.

    if reason then
        reason = reason:lower()
        if reason:find("лёгкое") or reason:find("minor") then
            term = math.max(M.data.min_term, 8)
        elseif reason:find("тяжкое") or reason:find("serious") then
            term = math.min(M.data.max_term, 45)
        end
    end

    return math.clamp(term, M.data.min_term, M.data.max_term)
end

function M.GetSuggestedCommand(player_id, reason, minutes)
    minutes = minutes or M.CalculateTerm(reason, player_id)
    
    return string.format("/su %d %d %s", 
        player_id or 0, 
        minutes, 
        reason or "Нарушение RP"
    )
end

-- ====================== УДОБНЫЕ ФУНКЦИИ ======================
function M.IsEnabled()
    return M.data.enabled
end

function M.SetDefaultTerm(minutes)
    M.data.default_term = math.clamp(minutes, M.data.min_term, M.data.max_term)
    M.Save()
end

function M.AddCustomTerm(name, minutes)
    table.insert(M.data.custom_terms, {
        name = name,
        minutes = minutes
    })
    M.Save()
end

return M