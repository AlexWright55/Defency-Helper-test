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
local script_dir = root_dir .. "/DefencyHelper"

print(u8("Defency Helper | Запуск v") .. thisScript().version)

-- ====================== GITHUB ======================
local GITHUB_BASE = "http://alexwright55.github.io/Defency-Helper-test/DefencyHelper/"

-- ====================== ГЛОБАЛЬНЫЙ ОБЪЕКТ ======================
Defency = {
    version = thisScript().version,
    script_dir = script_dir,
    settings = {},
    UI = {},
    Update = nil  -- будет заполнен ниже
}

-- ====================== ЗАГРУЗКА МОДУЛЕЙ ======================
local function safe_load(path)
    local ok, mod = pcall(require, path)
    if ok then
        print("[OK] " .. path)
        return mod
    else
        print("[ERROR] " .. path)
        return nil
    end
end

-- Создаём папки
if not doesDirectoryExist(script_dir) then
    createDirectory(script_dir)
    createDirectory(script_dir .. "/modules")
    createDirectory(script_dir .. "/ui")
end

-- Базовые и UI модули
Defency.Config  = safe_load("DefencyHelper.config")
Defency.Utils   = safe_load("DefencyHelper.utils")
Defency.Themes  = safe_load("DefencyHelper.themes")
Defency.Debug   = safe_load("DefencyHelper.debug")

-- UI модули
local ui_files = {"helpers", "main_menu", "binder", "fastmenu", "leader_fastmenu", "unit_window", 
                  "unit_management_dialog", "unit_playerlist", "departament", "update"}
for _, name in ipairs(ui_files) do
    local ui_name = name:gsub("^%l", string.upper)
    Defency.UI[ui_name] = safe_load("DefencyHelper.ui." .. name)
end

-- ====================== ОБНОВЛЕНИЕ ======================
Defency.Update = {
    StartFullUpdate = function()
        local files = { ... } -- тот же список, что был раньше
        -- (можно скопировать из предыдущего сообщения)
        for _, f in ipairs(files) do
            local url = GITHUB_BASE .. (f.folder or "") .. f.name
            local path = script_dir .. "/" .. (f.folder or "") .. f.name
            downloadUrlToFile(url, path, function() end)
            wait(120)
        end
        wait(3000)
        sampAddChatMessage("{00FF00}[Defency] {FFFFFF}Обновление завершено!", -1)
    end
}

-- ====================== ПРОВЕРКА ОБНОВЛЕНИЙ ======================
local function check_for_update()
    local url = GITHUB_BASE .. "version.json"
    downloadUrlToFile(url, script_dir .. "/version.json", function(success)
        if not success then return end

        local f = io.open(script_dir .. "/version.json", "r")
        if not f then return end
        local content = f:read("*a")
        f:close()

        local ok, data = pcall(decodeJson, content)
        if ok and data and data.version and data.version ~= thisScript().version then
            if Defency.UI.Update then
                Defency.UI.Update.Show(data.version, data.changelog)
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

-- Регистрация всех окон
for name, mod in pairs(Defency.UI) do
    if mod and mod.Window and mod.Draw then
        imgui.OnFrame(function() return mod.Window[0] end, mod.Draw)
    end
end