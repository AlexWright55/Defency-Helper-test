-- ui/unit_window.lua
local M = {}

M.Window = imgui.new.bool(false)
M.auto_update = imgui.new.bool(false)
M.update_timer = 0
M.update_interval = 5  -- секунд

function M.Draw()
    imgui.SetNextWindowSize(imgui.ImVec2(920 * Defency.settings.general.custom_dpi, 
                                         520 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.FirstUseEver)

    imgui.Begin(fa.USERS .. " Управление отделами " .. fa.USERS, 
                M.Window, imgui.WindowFlags.NoCollapse)

    Defency.UI.Helpers.ChangeDPI()

    if not Defency.UnitManagement then
        imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Модуль UnitManagement не загружен!")
        imgui.End()
        return
    end

    -- Верхняя панель
    if M.auto_update[0] then
        local time_left = M.update_interval - (os.clock() - M.update_timer)
        if time_left < 0 then time_left = 0 end
        
        imgui.TextColored(imgui.ImVec4(0.3, 1.0, 0.3, 1.0), fa.ROTATE .. " АВТООБНОВЛЕНИЕ")
        imgui.SameLine()
        imgui.Text(string.format("(%.1fс)", time_left))
    else
        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1.0), fa.ROTATE .. " Автообновление выключено")
    end

    imgui.SameLine(imgui.GetWindowWidth() - 280)
    if imgui.Button(fa.SYNC .. " Обновить (/unit)", imgui.ImVec2(180, 28)) then
        sampSendChat("/unit")
        M.update_timer = os.clock()
    end

    imgui.SameLine()
    imgui.Checkbox("Авто (" .. M.update_interval .. " сек)", M.auto_update)

    imgui.Separator()

    -- Таблица подразделений
    if #Defency.UnitManagement.divisions == 0 then
        imgui.SetCursorPosY(imgui.GetCursorPosY() + 60)
        Defency.UI.Helpers.CenterText("Нет данных. Нажмите «Обновить»")
    else
        if imgui.BeginChild("##divisions_table", imgui.ImVec2(0, -45), true) then
            for i, div in ipairs(Defency.UnitManagement.divisions) do
                local is_yours = div.your_division == "Вы тут"
                
                if is_yours then
                    imgui.PushStyleColor(imgui.Col.Header, imgui.ImVec4(0.2, 0.4, 0.8, 0.3))
                end

                if imgui.CollapsingHeader(u8(div.name) .. (is_yours and "   [ВЫ ЗДЕСЬ]" or "")) then
                    imgui.Columns(2, nil, false)
                    imgui.SetColumnWidth(0, 180)

                    imgui.Text("Начальник:")
                    imgui.NextColumn()
                    local leader_color = div.leader_status:find("ON") and imgui.ImVec4(0.3,1,0.3,1) or 
                                       (div.leader_status:find("OFF") and imgui.ImVec4(1,0.3,0.3,1) or nil)
                    if leader_color then
                        imgui.TextColored(leader_color, u8(div.leader))
                    else
                        imgui.Text(u8(div.leader))
                    end
                    imgui.NextColumn()

                    imgui.Text("Задание:")
                    imgui.NextColumn()
                    imgui.TextWrapped(u8(div.task))

                    imgui.Columns(1)

                    imgui.Separator()

                    if imgui.Button(fa.GEAR .. " Управлять отделом##" .. i, imgui.ImVec2(-1, 32)) then
                        Defency.UI.UnitManagementDialog.Open(div, i)
                    end
                end

                if is_yours then
                    imgui.PopStyleColor()
                end
            end
            imgui.EndChild()
        end
    end

    imgui.End()
end

-- Автообновление
function M.Update()
    if M.auto_update[0] and (os.clock() - M.update_timer > M.update_interval) then
        sampSendChat("/unit")
        M.update_timer = os.clock()
    end
end

return M