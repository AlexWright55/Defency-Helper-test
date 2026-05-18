---@diagnostic disable: undefined-global, lowercase-global
script_name("Defency Helper")
script_description('Хелпер для сотрудников ТСР Arizona & Rodina')
script_author("Flip Anderson")
script_version("v1.2.0")

local worked_dir = getWorkingDirectory():gsub('\\', '/')
local IS_MOBILE = MONET_VERSION ~= nil

-- ====================== GITHUB (обновление) ======================
local GITHUB = {
    user = "ТВОЙ_НИК_НА_GITHUB",        -- ? ИЗМЕНИ!
    repo = "Defency-Helper",
    branch = "main",
    base_url = "https://raw.githubusercontent.com/ТВОЙ_НИК_НА_GITHUB/Defency-Helper/main/"
}

print('Defency Helper | Запуск v' .. thisScript().version)

-- ====================== ГЛОБАЛЬНЫЙ ОБЪЕКТ ======================
Defency = {
    version = thisScript().version,
    worked_dir = worked_dir,
    IS_MOBILE = IS_MOBILE,
    sizeX, sizeY = getScreenResolution(),
    settings = {},
    UI = {},
    state = { reload_script = false }
}

-- ====================== ДИНАМИЧЕСКАЯ ЗАГРУЗКА ======================
local function load(name)
    local ok, mod = pcall(require, name)
    if ok then
        print("[LOAD] " .. name)
        return mod
    else
        print("[ERROR] " .. name)
        return nil
    end
end

-- Базовые модули
Defency.Config  = load("config")
Defency.Utils   = load("utils")
Defency.Themes  = load("themes")
Defency.Debug   = load("debug")

-- Автозагрузка modules/
for _, file in ipairs(listFiles(worked_dir .. "/Defency Helper/modules")) do
    if file:match("%.lua$") then
        local mod_name = file:gsub("%.lua$", "")
        Defency[mod_name:gsub("^%l", string.upper)] = load("modules." .. mod_name)
    end
end

-- Автозагрузка ui/
for _, file in ipairs(listFiles(worked_dir .. "/Defency Helper/ui")) do
    if file:match("%.lua$") then
        local mod_name = file:gsub("%.lua$", "")
        local ui_name = mod_name:gsub("^%l", string.upper)
        Defency.UI[ui_name] = load("ui." .. mod_name)
    end
end

print('Defency Helper | Все модули загружены автоматически!')

-- ====================== MAIN ======================
function main()
    while not isSampAvailable() do wait(100) end

    if Defency.Config then Defency.Config.Load() end
    if Defency.Themes then Defency.Themes.ApplyCurrent() end

    -- Инициализация
    for _, mod in pairs(Defency) do
        if type(mod) == "table" and mod.Init then mod.Init() end
    end
    for _, mod in pairs(Defency.UI) do
        if type(mod) == "table" and mod.Init then mod.Init() end
    end

    print('Defency Helper | Полностью готов к работе!')

    while true do
        wait(0)
        if Defency.UI.UnitWindow and Defency.UI.UnitWindow.Update then
            Defency.UI.UnitWindow.Update()
        end
    end
end

-- ====================== ImGui ======================
imgui.OnInitialize(function()
    if Defency.Themes and Defency.Themes.InitFonts then
        Defency.Themes.InitFonts()
    end
end)

-- Авторегистрация всех окон
for name, ui_mod in pairs(Defency.UI) do
    if ui_mod and ui_mod.Window and ui_mod.Draw then
        imgui.OnFrame(function() return ui_mod.Window[0] end, ui_mod.Draw)
    end
end

-- ====================== СОБЫТИЯ ======================
function onServerMessage(color, text)
    if Defency.UnitManagement and Defency.UnitManagement.OnServerMessage then
        Defency.UnitManagement.OnServerMessage(color, text)
    end
end

function onScriptTerminate(script, game_quit)
    if script == thisScript() and not game_quit then
        if Defency.Config then Defency.Config.Save() end
        if Defency.Debug then Defency.Debug.Shutdown() end
        print('Defency Helper | Выгружен.')
    end
end