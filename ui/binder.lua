-- ui/binder.lua
local M = {}

M.Window = imgui.new.bool(false)

-- Переменные редактора
M.current_cmd = {
    cmd = imgui.new.char[64](""),
    description = imgui.new.char[128](""),
    text = imgui.new.char[4096](""),
    waiting = imgui.new.float(2.0),
    enable = imgui.new.bool(true),
    in_fastmenu = imgui.new.bool(false)
}

M.edit_index = -1
M.selected_fraction = imgui.new.int(0)   -- 0 = ТСР, 1 = Армия
M.selected_category = imgui.new.int(0)   -- 0 = general, 1 = senior, 2 = leader

local fractions = {"ТСР", "Армия"}
local categories = {"Общие команды", "Для старшего состава", "Для зама/лидера"}

function M.Draw()
    imgui.SetNextWindowSize(imgui.ImVec2(1000 * Defency.settings.general.custom_dpi, 
                                         680 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.FirstUseEver)

    imgui.Begin(fa.BOOK .. " Редактор команд (Binder) " .. fa.BOOK, 
                M.Window, imgui.WindowFlags.NoCollapse)

    Defency.UI.Helpers.ChangeDPI()

    if not Defency.Commands then
        imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Модуль Commands не загружен!")
        imgui.End()
        return
    end

    -- Выбор фракции и категории
    imgui.Columns(2, nil, false)
    imgui.SetColumnWidth(0, 200 * Defency.settings.general.custom_dpi)

    imgui.Text("Фракция:")
    imgui.Combo("##fraction", M.selected_fraction, fractions)

    imgui.NextColumn()
    imgui.Text("Категория:")
    imgui.Combo("##category", M.selected_category, categories)
    imgui.Columns(1)

    imgui.Separator()

    -- Кнопка добавления
    if imgui.Button(fa.PLUS .. " Добавить новую команду", imgui.ImVec2(280, 32)) then
        M.ResetCurrentCommand()
        M.edit_index = -1
    end

    imgui.SameLine()
    if imgui.Button(fa.SAVE .. " Сохранить все", imgui.ImVec2(180, 32)) then
        Defency.Commands.Save()
        sampAddChatMessage("{00FF00}[Binder] {FFFFFF}Все команды сохранены!", -1)
    end

    imgui.Separator()

    -- Список команд
    if imgui.BeginChild("##commands_list", imgui.ImVec2(0, -140), true) then
        local frac_key = (M.selected_fraction[0] == 0) and "tsr" or "army"
        local cat_key = ({general = "general", senior = "senior", leader = "leader"})[ 
            ({[0]="general",[1]="senior",[2]="leader"})[M.selected_category[0]] 
        ]

        local commands = Defency.Commands.data[frac_key][cat_key] or {}

        for i, cmd in ipairs(commands) do
            imgui.PushID(i)

            local color = cmd.enable and imgui.ImVec4(0.6, 1.0, 0.6, 1.0) or imgui.ImVec4(0.6, 0.6, 0.6, 1.0)

            if imgui.Selectable(u8(cmd.description or cmd.cmd), M.edit_index == i) then
                M.LoadCommandForEdit(frac_key, cat_key, i)
            end

            imgui.SameLine(380)
            imgui.TextColored(color, "/" .. cmd.cmd)

            if cmd.in_fastmenu then
                imgui.SameLine(580)
                imgui.TextColored(imgui.ImVec4(0.3, 1.0, 0.8, 1.0), "[FastMenu]")
            end

            imgui.PopID()
        end

        imgui.EndChild()
    end

    -- Редактор команды
    if M.edit_index ~= -1 then
        imgui.Separator()
        M.DrawCommandEditor(frac_key, cat_key)
    end

    imgui.End()
end

function M.DrawCommandEditor(frac_key, cat_key)
    imgui.Text("Редактирование команды:")
    imgui.Separator()

    imgui.InputText("Команда", M.current_cmd.cmd, 64)
    imgui.InputText("Описание", M.current_cmd.description, 128)

    imgui.Text("Текст выполнения (строки разделяются символом &):")
    imgui.InputTextMultiline("##cmd_text", M.current_cmd.text, 4096, imgui.ImVec2(-1, 150))

    imgui.SliderFloat("Задержка между строками (сек)", M.current_cmd.waiting, 0.3, 10.0)

    imgui.Checkbox("Команда включена", M.current_cmd.enable)
    imgui.SameLine(300)
    imgui.Checkbox("Показывать в FastMenu", M.current_cmd.in_fastmenu)

    imgui.Separator()

    if Defency.UI.Helpers.CenterButton(fa.SAVE .. " Сохранить команду") then
        M.SaveCurrentCommand(frac_key, cat_key)
    end

    imgui.SameLine()

    if imgui.Button("Отмена") then
        M.edit_index = -1
    end
end

function M.ResetCurrentCommand()
    imgui.StrCopy(M.current_cmd.cmd, "")
    imgui.StrCopy(M.current_cmd.description, "Новая команда")
    imgui.StrCopy(M.current_cmd.text, "/me ")
    M.current_cmd.waiting[0] = 2.0
    M.current_cmd.enable[0] = true
    M.current_cmd.in_fastmenu[0] = false
end

function M.LoadCommandForEdit(frac_key, cat_key, index)
    local cmd = Defency.Commands.data[frac_key][cat_key][index]
    if not cmd then return end

    M.edit_index = index

    imgui.StrCopy(M.current_cmd.cmd, cmd.cmd or "")
    imgui.StrCopy(M.current_cmd.description, cmd.description or "")
    imgui.StrCopy(M.current_cmd.text, cmd.text or "")
    M.current_cmd.waiting[0] = tonumber(cmd.waiting) or 2.0
    M.current_cmd.enable[0] = cmd.enable or true
    M.current_cmd.in_fastmenu[0] = cmd.in_fastmenu or false
end

function M.SaveCurrentCommand(frac_key, cat_key)
    local cmd_table = Defency.Commands.data[frac_key][cat_key]

    local new_cmd = {
        cmd = u8:decode(ffi.string(M.current_cmd.cmd)),
        description = u8:decode(ffi.string(M.current_cmd.description)),
        text = u8:decode(ffi.string(M.current_cmd.text)),
        waiting = tostring(M.current_cmd.waiting[0]),
        enable = M.current_cmd.enable[0],
        in_fastmenu = M.current_cmd.in_fastmenu[0]
    }

    if M.edit_index == -1 then
        table.insert(cmd_table, new_cmd)
    else
        cmd_table[M.edit_index] = new_cmd
    end

    Defency.Commands.Save()
    M.edit_index = -1

    sampAddChatMessage("{00FF00}[Binder] {FFFFFF}Команда успешно сохранена!", -1)
end

return M