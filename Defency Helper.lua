---@diagnostic disable: undefined-global, lowercase-global
script_name("Defency Helper")
script_description('Хелпер для сотрудников ТСР Arizona & Rodina')
script_author("Flip Anderson")
script_version("v1.2.0")

local root_dir = getWorkingDirectory():gsub('\\', '/')
local script_dir = root_dir .. "/DefencyHelper"

print('Defency Helper | Запуск v' .. thisScript().version)

-- ====================== GITHUB PAGES ======================
local GITHUB_USER = "AlexWright55"
local REPO_NAME = "Defency-Helper-Test"

-- GitHub Pages URL (работает через HTTP!)
local GITHUB_PAGES = {
    base_url = "http://" .. GITHUB_USER .. ".github.io/" .. REPO_NAME .. "/"
}

-- ====================== СКАЧИВАНИЕ ЧЕРЕЗ LUA SOCKET ======================
local function download_file(url, path)
    local http = require("socket.http")
    local ltn12 = require("ltn12")
    
    local response_body = {}
    local res, code, headers = http.request{
        url = url,
        sink = ltn12.sink.table(response_body)
    }
    
    if code == 200 then
        local f = io.open(path, "wb")
        if f then
            f:write(table.concat(response_body))
            f:close()
            return true
        end
    end
    return false
end

-- ====================== ЗАГРУЗКА ВЕРСИИ ======================
local function check_version()
    local version_url = GITHUB_PAGES.base_url .. "version.json"
    print("Проверка версии: " .. version_url)
    
    local success = download_file(version_url, script_dir .. "/version_cache.json")
    
    if success then
        local f = io.open(script_dir .. "/version_cache.json", "r")
        if f then
            local content = f:read("*a")
            f:close()
            print("? Получена версия: " .. content)
            return true
        end
    else
        print("? Не удалось проверить версию")
    end
    return false
end

-- ====================== ЗАГРУЗКА МОДУЛЯ ======================
local function download_module(module_name)
    local module_url = GITHUB_PAGES.base_url .. "modules/" .. module_name .. ".lua"
    local module_path = script_dir .. "/modules/" .. module_name .. ".lua"
    
    print("Загрузка модуля: " .. module_name)
    return download_file(module_url, module_path)
end

-- ====================== MAIN ======================
function main()
    while not isSampAvailable() do wait(100) end

    -- Создаём папки
    if not doesDirectoryExist(script_dir) then
        createDirectory(script_dir)
        createDirectory(script_dir .. "/modules")
        createDirectory(script_dir .. "/ui")
    end

    -- Проверяем наличие socket.http
    local socket_ok, http = pcall(require, "socket.http")
    
    if not socket_ok then
        print("?? Lua Socket не установлен!")
        print("Скачай: https://github.com/diegonehab/luasocket")
        return
    end
    
    require("ltn12")
    
    -- Проверяем версию
    check_version()
    
    -- Пример загрузки модулей
    -- download_module("admin_commands")
    -- download_module("teleport_menu")
    
    print('Defency Helper | Готов к работе!')
    print('GitHub Pages URL: ' .. GITHUB_PAGES.base_url)

    while true do
        wait(0)
    end
end