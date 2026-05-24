-- =============================================
-- config.lua — Работа с пользовательскими настройками
-- =============================================

local M = {}

local config_dir = nil
local settings_path = nil

M.needs_first_setup = false

local function EnsurePaths()
    if config_dir then return end
    config_dir = Defency.data_dir or (getWorkingDirectory():gsub('\\', '/') .. "/DefencyHelper")
    settings_path = config_dir .. "/Settings.json"
end

M.default_settings = {
    general = {
        version = "1.2.0",
        helper_theme = 0,
        custom_dpi = 1.0,
        autofind_dpi = true,
        message_color = 40703,
        fraction_mode = "none",
        bind_mainmenu = '[113]',        -- F2
        bind_fastmenu = '[69]',         -- E
        bind_leader_fastmenu = '[71]',  -- G
        piemenu = true,
        cruise_control = true,
        rp_guns = true,
        moonmonet_theme_color = 12434877,
    },
    player_info = {
        nick = '',
        name_surname = '',
        fraction = 'none',
        fraction_tag = '',
        fraction_rank = '',
        fraction_rank_number = 0,
        sex = 'Мужчина',
        accent_enable = true,
        accent = '[Иностранный акцент]:',
    },
    md = {
        auto_doklad_damage = false,
        auto_door = false,
        auto_doklad_post = false,
        auto_mask = false,
    },
    windows_pos = {
        pie = {x = 800, y = 400},
    }
}

M.settings = {}

function M.Load()
    EnsurePaths()

    if not doesDirectoryExist(config_dir) then
        createDirectory(config_dir)
    end

    if not doesFileExist(settings_path) then
        print("Defency Helper | Первый запуск. Создаём настройки...")
        M.settings = M.default_settings
        M.Save()
        -- Ставим флаг — главный скрипт вызовет FirstSetup после загрузки всех модулей
        M.needs_first_setup = true
        return
    end

    -- Загрузка существующего конфига
    local f = io.open(settings_path, "r")
    if f then
        local content = f:read("*a")
        f:close()

        local ok, loaded = pcall(decodeJson, content)
        if ok and loaded then
            M.settings = loaded
            print("Defency Helper | Настройки загружены")
        else
            print("Defency Helper | Ошибка чтения настроек. Используем стандартные.")
            M.settings = M.default_settings
        end
    else
        M.settings = M.default_settings
    end

    -- Merge с дефолтными настройками (на случай обновления)
    M.MergeDefaults()
end

function M.Save()
    EnsurePaths()

    if not M.settings then return end

    local f = io.open(settings_path, "w")
    if f then
        local content = encodeJson(M.settings)
        if content then
            f:write(content)
            f:close()
        else
            f:close()
            print("Defency Helper | Ошибка кодирования JSON при сохранении настроек")
        end
    else
        print("Defency Helper | Не удалось сохранить Settings.json")
    end
end

-- Объединение с дефолтными настройками (при обновлении скрипта)
function M.MergeDefaults()
    local function merge(src, dst)
        for k, v in pairs(src) do
            if type(v) == "table" and type(dst[k]) == "table" then
                merge(v, dst[k])
            elseif dst[k] == nil then
                dst[k] = v
            end
        end
    end
    merge(M.default_settings, M.settings)
end

return M