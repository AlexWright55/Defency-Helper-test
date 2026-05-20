-- ui/update.lua
local M = {}

M.Window = imgui.new.bool(false)
M.new_version = ""
M.changelog = ""

function M.Show(new_ver, changes)
    M.new_version = new_ver or "Неизвестно"
    M.changelog = changes or "Нет описания изменений"
    M.Window[0] = true
end

function M.Draw()
    imgui.SetNextWindowSize(imgui.ImVec2(520, 360), imgui.Cond.Always)
    imgui.Begin(u8("?? Доступно обновление Defency Helper"), M.Window, imgui.WindowFlags.NoResize)

    imgui.TextColored(imgui.ImVec4(0.3, 1.0, 0.3, 1.0), u8("Новая версия: ") .. M.new_version)
    imgui.Separator()
    imgui.Text(u8("Что изменилось:"))
    imgui.TextWrapped(M.changelog)

    imgui.Separator()

    if imgui.Button(u8("Обновить сейчас"), imgui.ImVec2(240, 45)) then
        M.Window[0] = false
        if Defency and Defency.Update then
            Defency.Update.StartFullUpdate()
        end
    end

    imgui.SameLine()

    if imgui.Button(u8("Позже"), imgui.ImVec2(240, 45)) then
        M.Window[0] = false
    end

    imgui.End()
end

return M