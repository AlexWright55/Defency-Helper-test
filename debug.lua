-- debug.lua
local M = {}

M.config = {
    enabled = false,
    log_to_file = true,
    log_to_chat = false,
    log_to_console = true,
    file_path = getWorkingDirectory():gsub('\\', '/') .. "/Defency Helper/Debug/debug_log.txt",
    max_file_size_mb = 10,
    auto_clean_on_start = true,
    use_tabs = true
}

local debug_buffer = {}
local buffer_size = 0
local max_buffer_size = 30

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    local debug_dir = getWorkingDirectory():gsub('\\', '/') .. "/Defency Helper/Debug"
    if not doesDirectoryExist(debug_dir) then
        createDirectory(debug_dir)
    end

    if M.config.auto_clean_on_start and doesFileExist(M.config.file_path) then
        os.remove(M.config.file_path)
        print("[DEBUG] Лог-файл очищен при старте")
    end

    M.WriteHeader()
end

function M.WriteHeader()
    if not M.config.log_to_file then return end
    
    local file = io.open(M.config.file_path, "w")
    if file then
        file:write("\xEF\xBB\xBF") -- UTF-8 BOM
        local header = string.rep("=", 90) .. "\n"
        header = header .. "          Defency Helper Debug Log\n"
        header = header .. "          Started: " .. os.date("%d.%m.%Y %H:%M:%S") .. "\n"
        header = header .. string.rep("=", 90) .. "\n\n"
        file:write(u8:encode(header))
        file:close()
    end
end

-- ====================== ОСНОВНАЯ ФУНКЦИЯ ======================
local function format_log(timestamp, category, details, player_id, value1, value2)
    local parts = {}
    table.insert(parts, string.format("[%s]", timestamp))
    table.insert(parts, string.format("[%-12s]", category or "INFO"))
    
    if player_id then
        table.insert(parts, string.format(" ID:%-4d", player_id))
    end
    
    if details then
        table.insert(parts, " | " .. tostring(details))
    end
    
    if value1 then table.insert(parts, string.format(" [V1: %s]", tostring(value1))) end
    if value2 then table.insert(parts, string.format(" [V2: %s]", tostring(value2))) end
    
    return table.concat(parts, "")
end

function M.Log(category, details, player_id, value1, value2)
    if not M.config.enabled then return end

    local timestamp = os.date("%H:%M:%S")
    local log_line = format_log(timestamp, category, details, player_id, value1, value2)

    -- Буферизация в файл
    if M.config.log_to_file then
        table.insert(debug_buffer, log_line)
        buffer_size = buffer_size + 1

        if buffer_size >= max_buffer_size then
            M.Flush()
        end
    end

    -- В консоль
    if M.config.log_to_console then
        print(string.format("[DEBUG][%s] %s", category, details or ""))
    end

    -- В чат
    if M.config.log_to_chat and sampIsLocalPlayerSpawned() then
        sampAddChatMessage("{BDBDBD}[DEBUG] {FFFFFF}" .. (details or ""), -1)
    end
end

function M.Flush()
    if #debug_buffer == 0 then return end

    local file = io.open(M.config.file_path, "a")
    if file then
        local content = table.concat(debug_buffer, "\n") .. "\n"
        file:write(u8:encode(content))
        file:close()
        
        debug_buffer = {}
        buffer_size = 0
    end
end

-- ====================== УДОБНЫЕ МЕТОДЫ ======================
function M.Packet(id, cmd, info)
    M.Log("PACKET", info or cmd, nil, id)
end

function M.Command(player_id, command, args)
    M.Log("COMMAND", command .. (args and " " .. args or ""), player_id)
end

function M.Chat(player_id, text, chat_type)
    M.Log("CHAT", (chat_type and "["..chat_type.."] " or "") .. text, player_id)
end

function M.Damage(player_id, damage, weapon, bodypart)
    M.Log("DAMAGE", string.format("DMG:%d WPN:%d BP:%d", damage or 0, weapon or 0, bodypart or -1), player_id)
end

function M.Error(err, location)
    M.Log("ERROR", err .. (location and " | " .. location or ""))
end

function M.System(msg)
    M.Log("SYSTEM", msg)
end

function M.Server(text)
    M.Log("SERVER", text)
end

-- Автоматический сброс буфера при выгрузке скрипта
function M.Shutdown()
    M.Flush()
end

return M