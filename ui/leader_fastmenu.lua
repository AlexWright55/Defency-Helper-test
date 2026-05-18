-- ui/leader_fastmenu.lua
local M = {}

M.Window = imgui.new.bool(false)

function M.Draw()
    imgui.SetNextWindowSize(imgui.ImVec2(600 * Defency.settings.general.custom_dpi, 
                                         720 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.FirstUseEver)

    imgui.Begin(fa.CROWN .. " Leader Fast Menu " .. fa.CROWN, 
                M.Window, imgui.WindowFlags.NoCollapse)

    Defency.UI.Helpers.ChangeDPI()

    if not Defency.Commands then
        imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Модуль команд не загружен!")
        imgui.End()
        return
    end

    local fraction = Defency.Commands.GetCommandsForCurrentFraction()
    if not fraction then
        imgui.TextColored(imgui.ImVec4(1, 0.4, 0.4, 1), "Нет данных для текущей фракции")
        imgui.End()
        return
    end

    -- Для лидера показываем все три категории
    local categories = {
        { key = "general", name = "Общие команды" },
        { key = "senior",  name = "Старший состав" },
        { key = "leader",  name = "Для зама / лидера" }
    }

    for _, cat in ipairs(categories) do
        local commands = fraction[cat.key] or {}
        local visible = {}

        for _, cmd in ipairs(commands) do
            if cmd.enable then
                table.insert(visible, cmd)
            end
        end

        if #visible > 0 then
            imgui.TextColored(imgui.ImVec4(1.0, 0.75, 0.3, 1.0), "? " .. cat.name)
            imgui.Separator()

            for _, cmd in ipairs(visible) do
                if imgui.Button(u8(cmd.description or cmd.cmd), imgui.ImVec2(-1, 38)) then
                    Defency.Commands.Execute(cmd.cmd)
                end
            end

            imgui.Dummy(imgui.ImVec2(0, 12))
        end
    end

    imgui.Separator()

    if Defency.UI.Helpers.CenterButton(fa.TIMES .. " Закрыть меню") then
        M.Window[0] = false
    end

    imgui.End()
end

-- ====================== УДОБНЫЕ МЕТОДЫ ======================
function M.Open()
    M.Window[0] = true
end

return M