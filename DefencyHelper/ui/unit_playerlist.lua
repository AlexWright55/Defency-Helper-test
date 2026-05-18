-- ui/unit_playerlist.lua
local M = {}

M.Window = imgui.new.bool(false)
M.title = "Участники подразделения"

M.data = {}                    -- массив игроков
M.filter = imgui.new.char[256]("")
M.sort_column = imgui.new.int(1)   -- 1 = Ник, 2 = Ранг, 3 = Локация
M.sort_desc = imgui.new.bool(false)

function M.Open(title, players_data)
    if title then M.title = title end
    M.data = players_data or {}
    M.Window[0] = true
end

function M.Draw()
    imgui.SetNextWindowPos(imgui.ImVec2(Defency.sizeX / 2, Defency.sizeY / 2), 
                           imgui.Cond.Always, imgui.ImVec2(0.5, 0.5))
    imgui.SetNextWindowSize(imgui.ImVec2(780 * Defency.settings.general.custom_dpi, 
                                         560 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.Always)

    imgui.Begin(fa.USERS .. " " .. M.title .. " " .. fa.USERS, 
                M.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)

    Defency.UI.Helpers.ChangeDPI()

    -- Поиск
    imgui.PushItemWidth(320 * Defency.settings.general.custom_dpi)
    imgui.InputTextWithHint("##filter", "Поиск по нику...", M.filter, 256)
    imgui.PopItemWidth()

    imgui.SameLine()
    imgui.Text("Всего: " .. #M.data)

    imgui.Separator()

    -- Заголовки таблицы
    imgui.Columns(3, "##playerlist", true)
    imgui.SetColumnWidth(0, 280 * Defency.settings.general.custom_dpi)
    imgui.SetColumnWidth(1, 160 * Defency.settings.general.custom_dpi)
    imgui.SetColumnWidth(2, 280 * Defency.settings.general.custom_dpi)

    local sort_symbol = function(col)
        if M.sort_column[0] == col then
            return M.sort_desc[0] and " ?" or " ?"
        end
        return ""
    end

    if imgui.Selectable("Ник" .. sort_symbol(1)) then
        if M.sort_column[0] == 1 then
            M.sort_desc[0] = not M.sort_desc[0]
        else
            M.sort_column[0] = 1
            M.sort_desc[0] = false
        end
    end
    imgui.NextColumn()

    if imgui.Selectable("Ранг" .. sort_symbol(2)) then
        if M.sort_column[0] == 2 then
            M.sort_desc[0] = not M.sort_desc[0]
        else
            M.sort_column[0] = 2
            M.sort_desc[0] = false
        end
    end
    imgui.NextColumn()

    if imgui.Selectable("Местоположение" .. sort_symbol(3)) then
        if M.sort_column[0] == 3 then
            M.sort_desc[0] = not M.sort_desc[0]
        else
            M.sort_column[0] = 3
            M.sort_desc[0] = false
        end
    end
    imgui.Columns(1)

    imgui.Separator()

    -- Содержимое
    if imgui.BeginChild("##player_content", imgui.ImVec2(0, -45), true) then
        local filter_text = u8:decode(ffi.string(M.filter)):lower()

        -- Копируем и сортируем
        local sorted = {}
        for _, p in ipairs(M.data) do
            table.insert(sorted, p)
        end

        table.sort(sorted, function(a, b)
            local col = M.sort_column[0]
            if col == 1 then
                local na = (a.nick or ""):lower()
                local nb = (b.nick or ""):lower()
                return M.sort_desc[0] and na > nb or na < nb
            elseif col == 2 then
                local ra = tonumber(a.rank) or 0
                local rb = tonumber(b.rank) or 0
                return M.sort_desc[0] and ra > rb or ra < rb
            else
                local la = (a.location or ""):lower()
                local lb = (b.location or ""):lower()
                return M.sort_desc[0] and la > lb or la < lb
            end
        end)

        for _, player in ipairs(sorted) do
            local nick = Defency.Utils.RemoveColorCodes(player.nick or "")
            if filter_text == "" or nick:lower():find(filter_text, 1, true) then
                imgui.Columns(3, "##row_" .. nick, false)

                imgui.Text(u8(nick))
                imgui.NextColumn()
                imgui.Text(u8(player.rank or "-"))
                imgui.NextColumn()
                imgui.Text(u8(player.location or "Неизвестно"))

                imgui.Columns(1)
                imgui.Separator()
            end
        end

        if #sorted == 0 then
            Defency.UI.Helpers.CenterText("Нет данных")
        end

        imgui.EndChild()
    end

    -- Нижняя кнопка
    if Defency.UI.Helpers.CenterButton(fa.TIMES .. " Закрыть") then
        M.Window[0] = false
    end

    imgui.End()
end

return M