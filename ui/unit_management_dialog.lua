-- ui/unit_management_dialog.lua
local M = {}

M.Window = imgui.new.bool(false)

M.selected_division = nil
M.selected_name = ""
M.selected_leader = ""
M.selected_task = ""

-- Для popup-окон
M.show_rename_popup = false
M.show_task_popup = false

M.edit_name = imgui.new.char[256]("")
M.edit_task = imgui.new.char[512]("")

function M.Open(division, index)
    M.selected_division = division
    M.selected_name = division.name or ""
    M.selected_leader = division.leader or ""
    M.selected_task = division.task or ""

    imgui.StrCopy(M.edit_name, u8(M.selected_name))
    imgui.StrCopy(M.edit_task, u8(M.selected_task))

    M.Window[0] = true
end

function M.Draw()
    imgui.SetNextWindowSize(imgui.ImVec2(560 * Defency.settings.general.custom_dpi, 
                                         520 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.FirstUseEver)

    imgui.Begin(fa.CROWN .. " Управление подразделением " .. fa.CROWN, 
                M.Window, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoResize)

    Defency.UI.Helpers.ChangeDPI()

    if not M.selected_division then
        imgui.Text("Нет выбранного подразделения")
        imgui.End()
        return
    end

    imgui.TextColored(imgui.ImVec4(0.4, 0.7, 1.0, 1.0), "Отдел: " .. u8(M.selected_name))
    imgui.Separator()

    if imgui.BeginChild("##actions", imgui.ImVec2(0, -50), true) then

        if imgui.Button(fa.USER_EDIT .. " 1. Сменить начальника отдела", imgui.ImVec2(-1, 38)) then
            sampAddChatMessage("{FFAA00}[Unit] {FFFFFF}Функция в разработке...", -1)
        end

        if imgui.Button(fa.PENCIL .. " 2. Переименовать подразделение", imgui.ImVec2(-1, 38)) then
            M.show_rename_popup = true
        end

        if imgui.Button(fa.TASKS .. " 3. Изменить задание", imgui.ImVec2(-1, 38)) then
            M.show_task_popup = true
        end

        if imgui.Button(fa.USER_PLUS .. " 4. Назначить игрока в отдел", imgui.ImVec2(-1, 38)) then
            sampAddChatMessage("{FFAA00}[Unit] {FFFFFF}Отправьте ID игрока в чат после нажатия...", -1)
        end

        if imgui.Button(fa.USER_MINUS .. " 5. Убрать игрока из отдела", imgui.ImVec2(-1, 38)) then
            sampAddChatMessage("{FFAA00}[Unit] {FFFFFF}Функция в разработке...", -1)
        end

        if imgui.Button(fa.USERS .. " 6. Показать участников отдела", imgui.ImVec2(-1, 38)) then
            sampAddChatMessage("{FFAA00}[Unit] {FFFFFF}Функция в разработке...", -1)
        end

        imgui.EndChild()
    end

    -- Popup: Переименовать
    if M.show_rename_popup then
        imgui.OpenPopup("Переименовать подразделение")
        M.show_rename_popup = false
    end

    if imgui.BeginPopupModal("Переименовать подразделение", nil, imgui.WindowFlags.AlwaysAutoResize) then
        imgui.Text("Новое название:")
        imgui.InputText("##newname", M.edit_name, 256)

        if imgui.Button("Сохранить", imgui.ImVec2(120, 0)) then
            local new_name = u8:decode(ffi.string(M.edit_name))
            if new_name ~= "" then
                sampAddChatMessage("{00FF00}[Unit] {FFFFFF}Переименование: " .. new_name, -1)
                -- Здесь будет логика отправки команды
            end
            imgui.CloseCurrentPopup()
        end

        imgui.SameLine()
        if imgui.Button("Отмена", imgui.ImVec2(120, 0)) then
            imgui.CloseCurrentPopup()
        end

        imgui.EndPopup()
    end

    -- Popup: Изменить задание
    if M.show_task_popup then
        imgui.OpenPopup("Изменить задание")
        M.show_task_popup = false
    end

    if imgui.BeginPopupModal("Изменить задание", nil, imgui.WindowFlags.AlwaysAutoResize) then
        imgui.Text("Новое задание:")
        imgui.InputTextMultiline("##newtask", M.edit_task, 512, imgui.ImVec2(400, 100))

        if imgui.Button("Сохранить", imgui.ImVec2(120, 0)) then
            local new_task = u8:decode(ffi.string(M.edit_task))
            if new_task ~= "" then
                sampAddChatMessage("{00FF00}[Unit] {FFFFFF}Задание обновлено", -1)
            end
            imgui.CloseCurrentPopup()
        end

        imgui.SameLine()
        if imgui.Button("Отмена", imgui.ImVec2(120, 0)) then
            imgui.CloseCurrentPopup()
        end

        imgui.EndPopup()
    end

    imgui.End()
end

return M