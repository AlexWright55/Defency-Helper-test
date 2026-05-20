---@diagnostic disable: undefined-global, lowercase-global
script_name("Defency Helper")
script_description('Хелпер для сотрудников ТСР Arizona & Rodina')
script_author("Flip Anderson")
script_version("v1.2.0")

-- ====================== БИБЛИОТЕКИ ======================
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
local imgui = require('mimgui')

local root_dir = getWorkingDirectory():gsub('\\', '/')
local lib_dir = root_dir .. "/lib/DefencyHelper"           -- код
local data_dir = root_dir .. "/DefencyHelper"              -- пользовательские данные

print(u8("Defency Helper | Запуск v") .. thisScript().version)

-- ====================== GITHUB ======================
local GITHUB_BASE = "http://alexwright55.github.io/Defency-Helper-test/lib/"

-- ====================== ОКНО ОБНОВЛЕНИЯ ======================
local UpdateWindow = {
    Window = imgui.new.bool(false),
    new_version = "",
    changelog = ""
}

-- ====================== ЗАГРУЗКА ======================
local function safe_load(path)
    local ok, mod = pcall(require, path)
    if ok then return mod end
    return nil
end

-- Создаём папки
if not doesDirectoryExist(lib_dir) then
    createDirectory(lib_dir)
    createDirectory(lib_dir .. "/modules")
    createDirectory(lib_dir .. "/ui")
end
if not doesDirectoryExist(data_dir) then
    createDirectory(data_dir)
end

-- Инициализация
Defency = {
    version = thisScript().version,
    lib_dir = lib_dir,
    data_dir = data_dir,
    settings = {},
    UI = {}
}

-- Загрузка модулей из lib
Defency.Config  = safe_load("lib.DefencyHelper.config")
Defency.Utils   = safe_load("lib.DefencyHelper.utils")
Defency.Themes  = safe_load("lib.DefencyHelper.themes")
Defency.Debug   = safe_load("lib.DefencyHelper.debug")

-- Modules
local modules = {"commands", "rp_guns", "departament", "piemenu", "smart_rptp", "unit_management"}
for _, name in ipairs(modules) do
    Defency[name:gsub("^%l", string.upper)] = safe_load("lib.DefencyHelper.modules." .. name)
end

-- UI
local ui_files = {"helpers", "main_menu", "binder", "fastmenu", "leader_fastmenu", "unit_window", 
                  "unit_management_dialog", "unit_playerlist", "departament", "update"}
for _, name in ipairs(ui_files) do
    Defency.UI[name:gsub("^%l", string.upper)] = safe_load("lib.DefencyHelper.ui." .. name)
end

-- ====================== ПРОВЕРКА ОБНОВЛЕНИЙ ======================
local function check_for_update()
    local url = GITHUB_BASE .. "version.json"
    downloadUrlToFile(url, data_dir .. "/version.json", function(success)
        if not success then return end

        local f = io.open(data_dir .. "/version.json", "r")
        if not f then return end
        local content = f:read("*a")
        f:close()

        local ok, data = pcall(decodeJson, content)
        if ok and data and data.version and data.version ~= thisScript().version then
            if Defency.UI.Update then
                Defency.UI.Update.Show(data.version, data.changelog or "Обновление")
            end
        end
    end)
end

-- ====================== MAIN ======================
function main()
    while not isSampAvailable() do wait(100) end

    if Defency.Config then Defency.Config.Load() end
    if Defency.Themes then Defency.Themes.ApplyCurrent() end

    check_for_update()

    print(u8("Defency Helper | Готов к работе!"))

    while true do
        wait(0)
    end
end

-- ====================== ImGui ======================
imgui.OnInitialize(function()
    if Defency.Themes and Defency.Themes.InitFonts then
        Defency.Themes.InitFonts()
    end
end)

-- Регистрация окон
for name, mod in pairs(Defency.UI) do
    if mod and mod.Window and mod.Draw then
        imgui.OnFrame(function() return mod.Window[0] end, mod.Draw)
    end
end