---@diagnostic disable: undefined-global, lowercase-global
script_name("Defency Helper")
script_description('Õåëïåð äëÿ ñîòðóäíèêîâ ÒÑÐ Arizona & Rodina')
script_author("Flip Anderson")
script_version("v1.2.0")

-- ====================== ÁÈÁËÈÎÒÅÊÈ ======================
require('encoding').default = 'CP1251'
local u8 = require('encoding').UTF8
_G.imgui = require('mimgui')

local root_dir = getWorkingDirectory():gsub('\\', '/')
local lib_dir = root_dir .. "/lib/DefencyHelper"
local data_dir = root_dir .. "/DefencyHelper"

print(("Defency Helper | Çàïóñê v") .. thisScript().version)

-- ====================== GITHUB ======================
local GITHUB_BASE = "https://alexwright55.github.io/Defency-Helper-test/lib/"

-- ====================== ÔÓÍÊÖÈÈ ÇÀÃÐÓÇÊÈ ======================
-- Ôóíêöèÿ äëÿ ïîëó÷åíèÿ èíôîðìàöèè î ôàéëå
local function file_info(path)
    local f = io.open(path, "rb")
    if not f then return nil end
    local size = f:seek("end")
    f:close()
    return {size = size}
end

-- Ôóíêöèÿ ïðîâåðêè ñóùåñòâîâàíèÿ ôàéëà
local function file_exists(path)
    local f = io.open(path, "r")
    if f then
        f:close()
        return true
    end
    return false
end

-- Ôóíêöèÿ ïðîâåðêè ñóùåñòâîâàíèÿ äèðåêòîðèè
local function directory_exists(dir)
    return doesDirectoryExist(dir)
end

-- Ôóíêöèÿ ñîçäàíèÿ äèðåêòîðèè
local function ensure_directory(dir)
    if not directory_exists(dir) then
        createDirectory(dir)
    end
end

-- Ôóíêöèÿ çàãðóçêè ôàéëà (ñèíõðîííàÿ, áåç wait)
local function download_file(url, path)
    -- Ñîçäà¸ì äèðåêòîðèþ åñëè íóæíî
    local dir = path:match("(.*)[/\\]")
    if dir then
        ensure_directory(dir)
    end
    
    local file = io.open(path, "wb")
    if not file then 
        print("Íå óäàëîñü ñîçäàòü ôàéë: " .. path)
        return false 
    end
    
    -- Èñïîëüçóåì downloadUrlToFile
    local download_complete = false
    local download_success = false
    
    downloadUrlToFile(url, path, function(id, status, downloaded, totalSize)
        if status == 6 then -- Çàâåðøåíî
            download_complete = true
            download_success = true
        elseif status == 4 then -- Îøèáêà
            download_complete = true
            download_success = false
        end
    end)
    
    -- Æä¸ì çàâåðøåíèÿ çàãðóçêè (ïðîñòîé öèêë áåç wait)
    local timeout = 0
    while not download_complete and timeout < 300 do
        -- Íå èñïîëüçóåì wait, ïðîñòî äà¸ì âðåìÿ íà çàãðóçêó
        local start = os.clock()
        while os.clock() - start < 0.05 do end -- íåáîëüøîå îæèäàíèå
        timeout = timeout + 1
    end
    
    file:close()
    
    if not download_success then
        os.remove(path)
        return false
    end
    
    -- Ïðîâåðÿåì, ÷òî ôàéë ñîçäàí è íå ïóñòîé
    local info = file_info(path)
    if not info or info.size == 0 then
        os.remove(path)
        return false
    end
    
    return true
end

-- Ôóíêöèÿ çàãðóçêè ôàéëà ñ GitHub
local function load_file_from_github(file_path, local_path)
    -- Åñëè ôàéë óæå ñóùåñòâóåò, ïðîïóñêàåì
    if file_exists(local_path) then
        return true
    end
    
    local github_url = GITHUB_BASE .. file_path:gsub("\\", "/")
    print(("Çàãðóçêà: ") .. github_url)
    
    if download_file(github_url, local_path) then
        print(("Óñïåøíî: ") .. file_path)
        return true
    else
        print(("Îøèáêà çàãðóçêè: ") .. file_path)
        return false
    end
end

-- Ôóíêöèÿ ïðîâåðêè è çàãðóçêè îòñóòñòâóþùèõ ôàéëîâ (ñèíõðîííàÿ)
local function check_and_download_missing_files()
    print("Ïðîâåðêà íàëè÷èÿ ôàéëîâ...")
    
    -- Ñïèñîê ôàéëîâ äëÿ ïðîâåðêè
    local files_to_check = {
        -- Îñíîâíûå ôàéëû
        {github = "config.lua", local_path = lib_dir .. "/config.lua"},
        {github = "utils.lua", local_path = lib_dir .. "/utils.lua"},
        {github = "themes.lua", local_path = lib_dir .. "/themes.lua"},
        {github = "debug.lua", local_path = lib_dir .. "/debug.lua"},
        
        -- Ìîäóëè
        {github = "modules/commands.lua", local_path = lib_dir .. "/modules/commands.lua"},
        {github = "modules/rp_guns.lua", local_path = lib_dir .. "/modules/rp_guns.lua"},
        {github = "modules/departament.lua", local_path = lib_dir .. "/modules/departament.lua"},
        {github = "modules/piemenu.lua", local_path = lib_dir .. "/modules/piemenu.lua"},
        {github = "modules/smart_rptp.lua", local_path = lib_dir .. "/modules/smart_rptp.lua"},
        {github = "modules/unit_management.lua", local_path = lib_dir .. "/modules/unit_management.lua"},
        
        -- UI ôàéëû
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
    
    -- Ñîçäà¸ì íåîáõîäèìûå ïàïêè
    ensure_directory(lib_dir)
    ensure_directory(lib_dir .. "/modules")
    ensure_directory(lib_dir .. "/ui")
    ensure_directory(data_dir)
    
    -- Ñíà÷àëà ïðîñòî ïðîâåðÿåì, êàêèå ôàéëû îòñóòñòâóþò
    local missing_files = {}
    for _, file in ipairs(files_to_check) do
        if not file_exists(file.local_path) then
            table.insert(missing_files, file)
        end
    end
    
    if #missing_files == 0 then
        print("Âñå ôàéëû ïðèñóòñòâóþò. Çàãðóçêà íå òðåáóåòñÿ.")
        return true
    end
    
    print(string.format("Îòñóòñòâóåò %d ôàéëîâ. Íà÷èíàþ çàãðóçêó...", #missing_files))
    
    -- Çàãðóæàåì îòñóòñòâóþùèå ôàéëû
    local downloaded_count = 0
    for _, file in ipairs(missing_files) do
        if load_file_from_github(file.github, file.local_path) then
            downloaded_count = downloaded_count + 1
        end
        -- Íåáîëüøàÿ ïàóçà ìåæäó çàãðóçêàìè
        local start = os.clock()
        while os.clock() - start < 0.1 do end
    end
    
    print(string.format("Çàãðóæåíî %d/%d ôàéëîâ", downloaded_count, #missing_files))
    return downloaded_count == #missing_files
end

-- ====================== ËÎÊÀËÜÍÀß ÇÀÃÐÓÇÊÀ ÌÎÄÓËÅÉ ======================
local function safe_load(path)
    local ok, mod = pcall(require, path)
    if ok then 
        return mod 
    else
        print(("Îøèáêà çàãðóçêè ìîäóëÿ: ") .. path)
        return nil
    end
end

-- ====================== ÈÍÈÖÈÀËÈÇÀÖÈß ======================
-- Ñîçäà¸ì áàçîâóþ ñòðóêòóðó Defency
Defency = {
    version = thisScript().version,
    lib_dir = lib_dir,
    data_dir = data_dir,
    settings = {},
    UI = {}
}

-- Ïðîâåðÿåì è çàãðóæàåì îòñóòñòâóþùèå ôàéëû
if not check_and_download_missing_files() then
    print("Âíèìàíèå: íå âñå ôàéëû áûëè çàãðóæåíû. Íåêîòîðûå ôóíêöèè ìîãóò íå ðàáîòàòü.")
end

-- Çàãðóæàåì ìîäóëè èç ïîëüçîâàòåëüñêîé ïàïêè
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

    -- Çàãðóæàåì íàñòðîéêè
    if Defency.Config and Defency.Config.Load then
        Defency.Config.Load()
    else
        -- Ñîçäà¸ì äåôîëòíûå íàñòðîéêè åñëè êîíôèã íå çàãðóçèëñÿ
        print("Âíèìàíèå: èñïîëüçóåòñÿ êîíôèã ïî óìîë÷àíèþ")
        Defency.settings = {
            general = {
                custom_dpi = 1.0,
                helper_theme = 1,
                moonmonet_theme_color = 0x5A7DA8,
                fraction_mode = "none"
            }
        }
    end

    -- Ïðèìåíÿåì òåìó
    if Defency.Themes and Defency.Themes.ApplyCurrent then 
        Defency.Themes.ApplyCurrent() 
    end

    -- Èíèöèàëèçèðóåì øðèôòû
    if Defency.Themes and Defency.Themes.InitFonts then
        Defency.Themes.InitFonts()
    end

    print("Defency Helper | Ãîòîâ ê ðàáîòå!")

    while true do
        wait(0)
    end
end

-- ====================== ImGui Ðåãèñòðàöèÿ îêîí ======================
-- Ðåãèñòðèðóåì âñå UI îêíà äëÿ îòîáðàæåíèÿ
for name, mod in pairs(Defency.UI) do
    if type(mod) == "table" and mod.Window and mod.Draw then
        local m = mod
        local draw = mod.Draw
        imgui.OnFrame(function() 
            if m and type(m) == "table" and m.Window and m.Window[0] then
                return m.Window[0]
            end
            return false
        end, draw)
    end
end
