-- modules/smart_charter.lua
local M = {}

M.data = {} -- массив глав и статей устава

-- ====================== ИНИЦИАЛИЗАЦИЯ ======================
function M.Init()
    local path = Defency.Config.GetModulePath("smart_charter")

    if doesFileExist(path) then
        local loaded = Defency.Utils.ReadJson(path)
        if loaded then
            M.data = loaded
            print("[Smart Charter] Устав загружен (" .. #M.data ..
                      " глав)")
        end
    else
        print("[Smart Charter] Файл устава не найден")
        M.CreateDefaultStructure()
    end
end

function M.Save()
    local path = Defency.Config.GetModulePath("smart_charter")
    Defency.Utils.WriteJson(path, M.data)
end

function M.CreateDefaultStructure()
    M.data = {
        {
            name = "Общие положения",
            item = {
                {
                    number = "1.1",
                    text = "Настоящий устав регулирует деятельность организации..."
                }, {
                    number = "1.2",
                    text = "Сотрудники обязаны соблюдать RP-режим..."
                }
            }
        }, {
            name = "Права и обязанности",
            item = {
                {
                    number = "2.1",
                    text = "Сотрудник имеет право на..."
                }
            }
        }
    }
    M.Save()
end

-- ====================== ПОИСК И ОТОБРАЖЕНИЕ ======================
function M.Search(query)
    if not query or query == "" then return M.data end

    local result = {}
    local q = query:lower()

    for _, chapter in ipairs(M.data) do
        local chapter_match = chapter.name:lower():find(q)
        local items = {}

        if chapter.item then
            for _, article in ipairs(chapter.item) do
                local title = (article.number or "") .. " " ..
                                  (article.text or "")
                if title:lower():find(q) then
                    table.insert(items, article)
                end
            end
        end

        if chapter_match or #items > 0 then
            table.insert(result, {name = chapter.name, item = items})
        end
    end

    return result
end

function M.GetAll() return M.data end

return M
