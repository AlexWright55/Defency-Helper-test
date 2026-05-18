-- config.lua
local M = {}

local config_dir = getWorkingDirectory():gsub('\\', '/') .. '/Defency Helper'
local settings_path = config_dir .. "/Settings.json"

M.default_settings = {
    general = {
        version = "v1.2.0",
        author = 'Flip Anderson',
        uid = 0,
        custom_dpi = 1.0,
        autofind_dpi = false,
        helper_theme = 0,                    -- 0 = MoonMonet, 1 = Dark, 2 = White è ò.ä.
        message_color = 40703,
        moonmonet_theme_color = 12434877,
        fraction_mode = '',
        bind_mainmenu = '[113]',             -- F2
        bind_fastmenu = '[69]',              -- E
        bind_leader_fastmenu = '[71]',       -- G
        bind_action = '[13]',                -- Enter
        bind_command_stop = '[123]',         -- F12
        piemenu = true,
        mobile_fastmenu_button = true,
        mobile_stop_button = true,
        cruise_control = true,
        auto_uninvite = false,
        ping = true,
        rp_guns = true,
        auto_accept_docs = true,
        clear_chat = true,
        use_info_menu = false
    },
    player_info = {
        nick = '',
        name_surname = '',
        fraction = 'none',
        fraction_tag = '',
        fraction_rank = '',
        fraction_rank_number = 0,
        sex = 'Ìóæ÷èíà',
        accent_enable = true,
        accent = '[Èíîñòğàííûé àêöåíò]:',
        rp_chat = true
    },
    windows_pos = {
        pie = {x = 0, y = 0},
        patrool_menu = {x = 0, y = 0},
        post_menu = {x = 0, y = 0},
        mobile_fastmenu_button = {x = 0, y = 0},
        taser = {x = 0, y = 0},
        help = {x = 0, y = 0}
    },
    time_hud = false,
    display_map_distance = {user = false, server = false},
    systems_settings = {
        new_windows = {
            enabled = {
                dialog_unit = false,
                dialog_unit_playerlist = false
            }
        }
    }
}

M.settings = {}

-- ====================== ÂÑÏÎÌÎÃÀÒÅËÜÍÛÅ ÔÓÍÊÖÈÈ ======================
function M.GetModulePath(module_name)
    return config_dir .. "/" .. module_name:gsub("^%l", string.upper) .. ".json"
end

local function ensure_directory()
    if not doesDirectoryExist(config_dir) then
        createDirectory(config_dir)
    end
end

-- ====================== ÎÑÍÎÂÍÛÅ ÔÓÍÊÖÈÈ ======================
function M.Load()