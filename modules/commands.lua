-- modules/commands.lua
local M = {}

M.data = {
    my = {},
    senior_staff = {},
    manage = {},
    goss = {},
    goss_prison = {}
}

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    local path = Defency.Config.GetModulePath("commands")
    
    if doesFileExist(path) then
        local loaded = Defency.Utils.ReadJson(path)
        if loaded then
            M.data = loaded
            print("[Commands] Загружены пользовательские команды")
        end
    else
        print("[Commands] Файл команд не найден — будут использоваться стандартные")
        M.ResetToDefault()
    end
end

function M.Save()
    local path = Defency.Config.GetModulePath("commands")
    Defency.Utils.WriteJson(path, M.data)
end

function M.ResetToDefault()
    -- Здесь можно добавить базовые команды по умолчанию
    M.data.my = {} -- заполни при необходимости
    M.Save()
end

-- ====================== ВЫПОЛНЕНИЕ КОМАНД ======================
function M.Execute(cmd_name, args_str)
    -- Поиск команды по всем категориям
    local command = nil
    local categories = {"my", "senior_staff", "manage", "goss", "goss_prison"}

    for _, cat in ipairs(categories) do
        for _, cmd in ipairs(M.data[cat] or {}) do
            if cmd.cmd == cmd_name and cmd.enable then
                command = cmd
                break
            end
        end
        if command then break end
    end

    if not command then
        sampAddChatMessage("{FF0000}[Defency] {FFFFFF}Команда не найдена или отключена.", -1)
        return
    end

    local text = Defency.Utils.ReplaceTags(command.text)
    
    -- Простая замена аргументов
    if args_str then
        text = text:gsub("{arg}", args_str)
    end

    -- Выполнение по строкам
    for line in text:gmatch("([^&]+)") do
        line = line:gsub("^%s+", ""):gsub("%s+$", "")
        if line ~= "" then
            sampSendChat(line)
            wait(280)
        end
    end
end

-- Получить все команды для Binder / FastMenu
function M.GetAllCommands()
    local all = {}
    for cat, cmds in pairs(M.data) do
        for _, cmd in ipairs(cmds) do
            table.insert(all, {
                category = cat,
                cmd = cmd
            })
        end
    end
    return all
end

return M