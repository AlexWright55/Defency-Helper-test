-- modules/unit_management.lua
local M = {}

M.divisions = {}                    -- список подразделений
M.pending_action = nil
M.action_stage = 0
M.temp_data = {}

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    print("[Unit Management] Модуль управления отделами инициализирован")
end

-- ====================== ПАРСИНГ ДИАЛОГА /unit ======================
function M.ParseDivisionDialog(text)
    if not text then return {} end
    
    local clean = Defency.Utils.RemoveColorCodes(text)
    local divisions = {}
    
    for line in clean:gmatch("[^\r\n]+") do
        line = line:match("^%s*(.-)%s*$")
        if line and line ~= "" and not line:find("УПРАВЛЕНИЕ ПОДРАЗДЕЛЕНИЕМ") then
            
            local parts = {}
            for part in line:gmatch("[^\t]+") do
                table.insert(parts, part:match("^%s*(.-)%s*$") or "")
            end
            
            if #parts >= 3 then
                local name = parts[1] or "Не установлено"
                local leader_info = parts[2] or "Не установлен"
                local task = parts[3] or "Не установлено"
                local your_div = (#parts >= 4) and parts[4] or ""
                
                -- Извлечение статуса лидера ([ON], [OFF], [ID:123])
                local leader, leader_status = M.ParseLeaderInfo(leader_info)
                
                table.insert(divisions, {
                    name = name,
                    leader = leader,
                    leader_status = leader_status,
                    task = task,
                    your_division = your_div:find("Вы тут") and "Вы тут" or ""
                })
            end
        end
    end
    
    M.divisions = divisions
    return divisions
end

function M.ParseLeaderInfo(info)
    local leader = info
    local status = ""
    
    -- Ищем [ON], [OFF], [ID:xxx]
    local bracket = info:match("%[([^%]]+)%]")
    if bracket then
        status = bracket
        leader = info:gsub("%[" .. bracket .. "%]", ""):match("^%s*(.-)%s*$")
    end
    
    if leader == "" then leader = "Не установлен" end
    return leader, status
end

-- ====================== ДЕЙСТВИЯ ======================
function M.StartAction(action_type, data)
    M.pending_action = action_type
    M.action_stage = 0
    M.temp_data = data or {}
    sampSendChat("/unit")
end

function M.OnServerMessage(color, text)
    if not M.pending_action then return end
    
    -- Здесь можно добавить логику обработки ответа сервера
    -- для многоэтапных действий (переименование, смена лидера и т.д.)
end

-- ====================== ГЕТТЕРЫ ======================
function M.GetDivisions()
    return M.divisions
end

function M.GetDivisionByIndex(index)
    return M.divisions[index]
end

return M