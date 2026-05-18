---@diagnostic disable: undefined-global, lowercase-global
script_name("Defency Helper")
script_description('Хелпер для сотрудников ТСР Arizona & Rodina')
script_author("Flip Anderson")
script_version("v1.2.0")

local root_dir = getWorkingDirectory():gsub('\\', '/')
local script_dir = root_dir .. "/DefencyHelper"   -- ? БЕЗ ПРОБЕЛА

print('Defency Helper | Запуск v' .. thisScript().version)

-- ====================== GITHUB ======================
local GITHUB = {
    user = "ТВОЙ_НИК_НА_GITHUB",
    repo = "Defency-Helper",
    branch = "main",
    base_url = "https://raw.githubusercontent.com/ТВОЙ_НИК_НА_GITHUB/Defency-Helper/main/"
}

-- ====================== ГЛОБАЛЬНЫЙ ОБЪЕКТ ======================
Defency = {
    version = thisScript().version,
    script_dir = script_dir,
    settings = {},
    UI = {}
}

-- ====================== ЗАГРУЗКА ======================
local function safe_load(path)
    local ok, result = pcall(require, path)
    if ok then
        print("[OK] " .. path)
        return result
    else
        print("[ERROR] " .. path)
        return nil
    end
end

-- Создаём папку
if not doesDirectoryExist(script_dir) then
    createDirectory(script_dir)
    createDirectory(script_dir .. "/modules")
    createDirectory(script_dir .. "/ui")
end

-- Базовые
Defency.Config  = safe_load("DefencyHelper.config")
Defency.Utils   = safe_load("DefencyHelper.utils")
Defency.Themes  = safe_load("DefencyHelper.themes")
Defency.Debug   = safe_load("DefencyHelper.debug")

-- Modules
local modules = {"commands", "rp_guns", "departament", "piemenu", "smart_rptp", "unit_management"}
for _, m in ipairs(modules) do
    local name = m:gsub("^%l", string.upper)
    Defency[name] = safe_load("DefencyHelper.modules." .. m)
end

-- UI
local ui_files = {"helpers", "main_menu", "binder", "fastmenu", "leader_fastmenu", "unit_window", 
                  "unit_management_dialog", "unit_playerlist", "departament"}
for _, f in ipairs(ui_files) do
    local name = f:gsub("^%l", string.upper)
    Defency.UI[name] = safe_load("DefencyHelper.ui." .. f)
end

print('Defency Helper | Загрузка завершена')

-- ====================== MAIN ======================
function main()
    while not isSampAvailable() do wait(100) end

    if Defency.Config then Defency.Config.Load() end
    if Defency.Themes then Defency.Themes.ApplyCurrent() end

    print('Defency Helper | Готов к работе!')

    while true do
        wait(0)
    end
end

-- ====================== ImGui ======================
local imgui = require 'mimgui'

imgui.OnInitialize(function()
    if Defency.Themes and Defency.Themes.InitFonts then
        Defency.Themes.InitFonts()
    end
end)

for name, mod in pairs(Defency.UI) do
    if mod and mod.Window and mod.Draw then
        imgui.OnFrame(function() return mod.Window[0] end, mod.Draw)
    end
end