---@diagnostic disable: undefined-global, lowercase-global
script_name("Defency Helper")
script_description('Хелпер для сотрудников ТСР Arizona & Rodina')
script_author("Flip Anderson")
script_version("v1.2.0")

local root_dir = getWorkingDirectory():gsub('\\', '/')
local script_dir = root_dir .. "/Defency Helper"   -- ? Все файлы здесь

local IS_MOBILE = MONET_VERSION ~= nil

-- ====================== GITHUB ======================
local GITHUB = {
    user = "AlexWright55",        -- ? ИЗМЕНИ!
    repo = "Defency-Helper-Test",
    branch = "main",
    base_url = "https://raw.githubusercontent.com/AlexWright55/Defency-Helper-Test/main/"
}

print('Defency Helper | Запуск v' .. thisScript().version)

-- ====================== ГЛОБАЛЬНЫЙ ОБЪЕКТ ======================
Defency = {
    version = thisScript().version,
    root_dir = root_dir,
    script_dir = script_dir,
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

-- Создаём папку, если её нет
if not doesDirectoryExist(script_dir) then
    createDirectory(script_dir)
    createDirectory(script_dir .. "/modules")
    createDirectory(script_dir .. "/ui")
end

-- Базовые модули
Defency.Config  = load("Defency Helper.config")
Defency.Utils   = load("Defency Helper.utils")
Defency.Themes  = load("Defency Helper.themes")
Defency.Debug   = load("Defency Helper.debug")

-- Автозагрузка modules/
for _, file in ipairs(listFiles(script_dir .. "/modules") or {}) do
    if file:match("%.lua$") then
        local name = file:gsub("%.lua$", "")
        Defency[name:gsub("^%l", string.upper)] = load("Defency Helper.modules." .. name)
    end
end

-- Автозагрузка ui/
for _, file in ipairs(listFiles(script_dir .. "/ui") or {}) do
    if file:match("%.lua$") then
        local name = file:gsub("%.lua$", "")
        Defency.UI[name:gsub("^%l", string.upper)] = load("Defency Helper.ui." .. name)
    end
end

print('Defency Helper | Автозагрузка завершена!')

-- ====================== ПРОВЕРКА ОБНОВЛЕНИЙ ======================
local function check_for_update()
    local url = GITHUB.base_url .. "version.json"
    downloadUrlToFile(url, script_dir .. "/temp_version.json", function(success)
        if not success then return end

        local f = io.open(script_dir .. "/temp_version.json", "r")
        if not f then return end
        local content = f:read("*a")
        f:close()

        local ok, data = pcall(decodeJson, content)
        if ok and data and data.version and data.version ~= thisScript().version then
            UpdateWindow.new_version = data.version
            UpdateWindow.changelog = data.changelog or "Нет описания"
            UpdateWindow.Window[0] = true
        end
    end)
end

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

    check_for_update()

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

-- Окно обновления (оставляем как было)
local UpdateWindow = { Window = imgui.new.bool(false), new_version = "", changelog = "" }

imgui.OnFrame(function() return UpdateWindow.Window[0] end, function()
    imgui.SetNextWindowSize(imgui.ImVec2(520, 340), imgui.Cond.Always)
    imgui.Begin("?? Доступно обновление", UpdateWindow.Window, imgui.WindowFlags.NoResize)

    imgui.TextColored(imgui.ImVec4(0.3, 1.0, 0.3, 1.0), "Новая версия: " .. UpdateWindow.new_version)
    imgui.Separator()
    imgui.Text("Что изменилось:")
    imgui.TextWrapped(UpdateWindow.changelog)

    imgui.Separator()

    if imgui.Button("Обновить сейчас", imgui.ImVec2(240, 45)) then
        UpdateWindow.Window[0] = false
        -- update_script() можно добавить позже
    end

    imgui.SameLine()

    if imgui.Button("Позже", imgui.ImVec2(240, 45)) then
        UpdateWindow.Window[0] = false
    end

    imgui.End()
end)

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