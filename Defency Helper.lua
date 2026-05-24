---@diagnostic disable: undefined-global, lowercase-global
script_name("Defency Helper")
script_description('Хелпер для сотрудников ТСР Arizona & Rodina')
script_author("Flip Anderson")
script_version("v1.2.0")

-- ====================== БИБЛИОТЕКИ ======================
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
_G.imgui = require('mimgui')

local root_dir = getWorkingDirectory():gsub('\\', '/')
local lib_dir = root_dir .. "/lib/DefencyHelper"
local data_dir = root_dir .. "/DefencyHelper"

print(("Defency Helper | Запуск v") .. thisScript().version)

-- ====================== GITHUB ======================
local GITHUB_BASE = "https://alexwright55.github.io/Defency-Helper-test/lib/"

-- ====================== ФУНКЦИИ ЗАГРУЗКИ ======================
-- Функция для получения информации о файле
local function file_info(path)
    local f = io.open(path, "rb")
    if not f then return nil end
    local size = f:seek("end")
    f:close()
    return {size = size}
end

-- Функция проверки существования файла
local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
end

-- Функция проверки существования директории
local function directory_exists(dir)
    return doesDirectoryExist(dir)
end

-- Функция создания директории
local function ensure_directory(dir)
    if not directory_exists(dir) then
        createDirectory(dir)
    end
end

-- Функция загрузки файла (синхронная, без wait)
local function download_file(url, path)
    -- Создаём директорию если нужно
    local dir = path:match("(.*)[/\\]")
    if dir then
        ensure_directory(dir)
    end
    
    local file = io.open(path, "wb")
    if not file then 
        print("Не удалось создать файл: " .. path)
        return false 
    end
    
    -- Используем downloadUrlToFile
    local download_complete = false
    local download_success = false
    
    downloadUrlToFile(url, path, function(id, status, downloaded, totalSize)
        if status == 6 then -- Завершено
            download_complete = true
            download_success = true
        elseif status == 4 then -- Ошибка
            download_complete = true
            download_success = false
        end
    end)
    
    -- Ждём завершения загрузки (простой цикл без wait)
    local timeout = 0
    while not download_complete and timeout < 300 do
        -- Не используем wait, просто даём время на загрузку
        local start = os.clock()
        while os.clock() - start < 0.05 do end -- небольшое ожидание
        timeout = timeout + 1
    end
    
    file:close()
    
    if not download_success then
        os.remove(path)
        return false
    end
    
    -- Проверяем, что файл создан и не пустой
    local info = file_info(path)
    if not info or info.size == 0 then
        os.remove(path)
        return false
    end
    
    return true
end

-- Функция загрузки файла с GitHub
local function load_file_from_github(file_path, local_path)
    -- Если файл уже существует, пропускаем
    if file_exists(local_path) then
        return true
    end
    
    local github_url = GITHUB_BASE .. file_path:gsub("\\", "/")
    print(("Загрузка: ") .. github_url)
    
    if download_file(github_url, local_path) then
        print(("Успешно: ") .. file_path)
        return true
    else
        print(("Ошибка загрузки: ") .. file_path)
        return false
    end
end

-- Функция проверки и загрузки отсутствующих файлов (синхронная)
local function check_and_download_missing_files()
    print("Проверка наличия файлов...")
    
    -- Список файлов для проверки
    local files_to_check = {
        -- Основные файлы
        {github = "config.lua", local_path = lib_dir .. "/config.lua"},
        {github = "utils.lua", local_path = lib_dir .. "/utils.lua"},
        {github = "themes.lua", local_path = lib_dir .. "/themes.lua"},
        {github = "debug.lua", local_path = lib_dir .. "/debug.lua"},
        
        -- Модули
        {github = "modules/commands.lua", local_path = lib_dir .. "/modules/commands.lua"},
        {github = "modules/rp_guns.lua", local_path = lib_dir .. "/modules/rp_guns.lua"},
        {github = "modules/departament.lua", local_path = lib_dir .. "/modules/departament.lua"},
        {github = "modules/piemenu.lua", local_path = lib_dir .. "/modules/piemenu.lua"},
        {github = "modules/smart_rptp.lua", local_path = lib_dir .. "/modules/smart_rptp.lua"},
        {github = "modules/unit_management.lua", local_path = lib_dir .. "/modules/unit_management.lua"},
        
        -- UI файлы
        {github = "ui/helpers.lua", local_path = lib_dir .. "/ui/helpers.lua"},
        {github = "ui/main_menu.lua", local_path = lib_dir .. "/ui/main_menu.lua"},
        {github = "ui/binder.lua", local_path = lib_dir .. "/ui/binder.lua"},
        {github = "ui/fastmenu.lua", local_path = lib_dir .. "/ui/fastmenu.lua"},
        {github = "ui/leader_fastmenu.lua", local_path = lib_dir .. "/ui/leader_fastmenu.lua"},
        {github = "ui/unit_window.lua", local_path = lib_dir .. "/ui/unit_window.lua"},
        {github = "ui/unit_management_dialog.lua", local_path = lib_dir .. "/ui/unit_management_dialog.lua"},
        {github = "ui/unit_playerlist.lua", local_path = lib_dir .. "/ui/unit_playerlist.lua"},
        {github = "ui/departament.lua", local_path = lib_dir .. "/ui/departament.lua"},
        {github = "ui/update.lua", local_path = lib_dir .. "/ui/update.lua"},
        {github = "ui/first_setup.lua", local_path = lib_dir .. "/ui/first_setup.lua"},
    }
    
    -- Создаём необходимые папки
    ensure_directory(lib_dir)
    ensure_directory(lib_dir .. "/modules")
    ensure_directory(lib_dir .. "/ui")
    ensure_directory(data_dir)
    
    -- Сначала просто проверяем, какие файлы отсутствуют
    local missing_files = {}
    for _, file in ipairs(files_to_check) do
        if not file_exists(file.local_path) then
            table.insert(missing_files, file)
        end
    end
    
    if #missing_files == 0 then
        print("Все файлы присутствуют. Загрузка не требуется.")
        return true
    end
    
    print(string.format("Отсутствует %d файлов. Начинаю загрузку...", #missing_files))
    
    -- Загружаем отсутствующие файлы
    local downloaded_count = 0
    for _, file in ipairs(missing_files) do
        if load_file_from_github(file.github, file.local_path) then
            downloaded_count = downloaded_count + 1
        end
        -- Небольшая пауза между загрузками
        local start = os.clock()
        while os.clock() - start < 0.1 do end
    end
    
    print(string.format("Загружено %d/%d файлов", downloaded_count, #missing_files))
    return downloaded_count == #missing_files
end

-- ====================== ЛОКАЛЬНАЯ ЗАГРУЗКА МОДУЛЕЙ ======================
local function safe_load(path)
    local ok, mod = pcall(require, path)
    if ok then 
        return mod 
    else
        print(("Ошибка загрузки модуля: ") .. path)
        return nil
    end
end

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
-- Создаём базовую структуру Defency
Defency = {
    version = thisScript().version,
    lib_dir = lib_dir,
    data_dir = data_dir,
    settings = {},
    UI = {}
}

-- Проверяем и загружаем отсутствующие файлы
if not check_and_download_missing_files() then
    print("Внимание: не все файлы были загружены. Некоторые функции могут не работать.")
end

-- Загружаем модули из пользовательской папки
Defency.Config  = safe_load("lib.DefencyHelper.config")
Defency.Utils   = safe_load("lib.DefencyHelper.utils")
Defency.Themes  = safe_load("lib.DefencyHelper.themes")
Defency.Debug   = safe_load("lib.DefencyHelper.debug")

local modules_list = {"commands", "rp_guns", "departament", "piemenu", "smart_rptp", "unit_management"}
for _, name in ipairs(modules_list) do
    local module_name = name:gsub("^%l", string.upper)
    Defency[module_name] = safe_load("lib.DefencyHelper.modules." .. name)
end

local ui_files_list = {"helpers", "main_menu", "binder", "fastmenu", "leader_fastmenu", "unit_window", 
                  "unit_management_dialog", "unit_playerlist", "departament", "update", "first_setup"}
for _, name in ipairs(ui_files_list) do
    local ui_name = name:gsub("^%l", string.upper)
    Defency.UI[ui_name] = safe_load("lib.DefencyHelper.ui." .. name)
end

-- ====================== MAIN ======================
function main()
    while not isSampAvailable() do wait(100) end

    -- Загружаем настройки
    if Defency.Config and Defency.Config.Load then
        Defency.Config.Load()
    else
        -- Создаём дефолтные настройки если конфиг не загрузился
        print("Внимание: используется конфиг по умолчанию")
        Defency.settings = {
            general = {
                custom_dpi = 1.0,
                helper_theme = 1,
                moonmonet_theme_color = 0x5A7DA8,
                fraction_mode = "none"
            }
        }
    end

    -- Применяем тему
    if Defency.Themes and Defency.Themes.ApplyCurrent then 
        Defency.Themes.ApplyCurrent() 
    end

    -- Инициализируем шрифты
    if Defency.Themes and Defency.Themes.InitFonts then
        Defency.Themes.InitFonts()
    end

    print("Defency Helper | Готов к работе!")

    while true do
        wait(0)
    end
end

-- ====================== ImGui Регистрация окон ======================
-- Регистрируем все UI окна для отображения
for name, mod in pairs(Defency.UI) do
    if mod and mod.Window and mod.Draw then
        imgui.OnFrame(function() 
            if mod.Window and mod.Window[0] then
                return mod.Window[0]
            end
            return false
        end, mod.Draw)
    end
end