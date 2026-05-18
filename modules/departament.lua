-- modules/departament.lua
local M = {}

M.data = {
    anti_skobki = false,
    dep_fm = '-',
    dep_tag1 = '',
    dep_tag2 = '[Всем]',
    dep_tags = {
        "[Всем]", "[Похитители]", "[Террористы]", "[Диспетчер]", "[МЮ]", 
        "[Мин.Юст.]", "[ЛСПД]", "[СФПД]", "[ЛВПД]", "[РКШД]", "[СВАТ]", 
        "[ФБР]", "[МО]", "[Мин.Обороны]", "[ТСР]", "[МЗ]", "[Мин.Здрав.]", 
        "[ЦА]", "[Пра-во]", "[Губернатор]", "[СМИ]"
    },
    dep_tags_en = {
        "[ALL]", "[MJ]", "[LSPD]", "[SFPD]", "[FBI]", "[MD]", "[GOV]", "[CNN]"
    },
    dep_fms = {'-', '- з.к. -'},
    dep_tags_custom = {}
}

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    local path = Defency.Config.GetModulePath("departament")
    
    if doesFileExist(path) then
        local loaded = Defency.Utils.ReadJson(path)
        if loaded then
            M.data = loaded
            print("[Departament] Рация департамента загружена")
        end
    else
        print("[Departament] Создан новый файл рации")
        M.Save()
    end
end

function M.Save()
    local path = Defency.Config.GetModulePath("departament")
    Defency.Utils.WriteJson(path, M.data)
end

-- ====================== ОСНОВНЫЕ ФУНКЦИИ ======================
function M.GetFullTag()
    local tag = ""
    if M.data.dep_tag1 and M.data.dep_tag1 ~= "" then
        tag = M.data.dep_tag1 .. " "
    end
    tag = tag .. (M.data.dep_tag2 or "[Всем]")
    return tag
end

function M.SendRadio(text)
    if not text or text == "" then return end
    
    local fm = M.data.dep_fm or "-"
    local full_tag = M.GetFullTag()
    
    local message = string.format("r %s %s: %s", fm, full_tag, text)
    
    if M.data.anti_skobki then
        message = message:gsub("%[", ""):gsub("%]", "")
    end
    
    sampSendChat(message)
end

-- Для интерфейса
function M.GetTags()
    return M.data.dep_tags
end

function M.GetFMs()
    return M.data.dep_fms
end

return M