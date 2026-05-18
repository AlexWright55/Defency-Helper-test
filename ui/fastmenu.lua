-- ui/fastmenu.lua
local M = {}

M.Window = imgui.new.bool(false)
M.is_leader_mode = imgui.new.bool(false)   -- true = Leader Fast Menu

function M.Draw()
    local title = M.is_leader_mode[0] and "Leader Fast Menu" or "Fast Menu"
    
    imgui.SetNextWindowSize(imgui.ImVec2(580 * Defency.settings.general.custom_dpi, 
                                         680 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.FirstUseEver)

    imgui.Begin(fa.BOLT .. " " .. title .. " " .. fa.BOLT, 
                M.Window, imgui.WindowFlags.NoCollapse)

    Defency.UI.Helpers.ChangeDPI()

    if not Defency.Commands then
        imgui.TextColored(imgui.ImVec4(1, 0.3, 0.3, 1), "Модуль команд не загружен!")
        imgui.End()
        return
    end

    local fraction = Defency.Commands.GetCommandsForCurrentFraction()
    if not fraction then
        imgui.Text("Нет команд для текущей фракции")
        imgui.End()
        return
    end

    -- Определяем, какие категории показывать
    local cats = M.is_leader_mode[0] 
        and {"general", "senior", "leader"} 
        or {"general"}

    for _, cat_key in ipairs(cats) do
        local commands = fraction[cat_key] or {}
        local visible_cmds = {}

        -- Фильтруем только включённые и предназначенные для FastMenu
        for _, cmd in ipairs(commands) do
            if cmd.enable and (cmd.in_fastmenu or M.is_leader_mode[0]) then
                table.insert(visible_cmds, cmd)
            end
        end

        if #visible_cmds > 0 then
            local cat_name = ({
                general = "Общие команды",
                senior  = "Старший состав",
                leader  = "Зам / Лидер"
            })[cat_key]

            imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1.0, 1.0), "? " .. cat_name)
            imgui.Separator()

            for _, cmd in ipairs(visible_cmds) do
                if imgui.Button(u8(cmd.description or cmd.cmd), imgui.ImVec2(-1, 36)) then
                    Defency.Commands.Execute(cmd.cmd)
                end
            end

            imgui.Dummy(imgui.ImVec2(0, 10))
        end
    end

    if #visible_cmds == 0 and not M.is_leader_mode[0] then
        imgui.TextColored(imgui.ImVec4(0.6, 0.6, 0.6, 1.0), 
            "В FastMenu нет команд.\nВключите нужные в Binder (галочка \"в FastMenu\").")
    end

    imgui.End()
end

-- ====================== УДОБНЫЕ ВЫЗОВЫ ======================
function M.Open()
    M.is_leader_mode[0] = false
    M.Window[0] = true
end

function M.OpenLeader()
    M.is_leader_mode[0] = true
    M.Window[0] = true
end

return M