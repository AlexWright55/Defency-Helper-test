-- ui/main_menu.lua
local M = {}

M.Window = imgui.new.bool(false)

function M.Draw()
    imgui.SetNextWindowSize(imgui.ImVec2(820 * Defency.settings.general.custom_dpi, 
                                         580 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.FirstUseEver)
    
    imgui.Begin(Defency.Themes.GetHelperIcon() .. " Defency Helper v" .. Defency.version .. 
                " " .. Defency.Themes.GetHelperIcon(), 
                M.Window, imgui.WindowFlags.NoCollapse)

    Defency.UI.Helpers.ChangeDPI()

    if imgui.BeginTabBar("MainTabBar") then

        -- ====================== ВКЛАДКА 1: Главное ======================
        if imgui.BeginTabItem("Главное") then
            imgui.TextColored(imgui.ImVec4(0.4, 0.8, 1.0, 1.0), "Информация о игроке")
            imgui.Separator()

            imgui.Columns(2, nil, false)
            imgui.SetColumnWidth(0, 180 * Defency.settings.general.custom_dpi)

            imgui.Text("Ник:")
            imgui.NextColumn()
            imgui.Text(Defency.settings.player_info.nick or "Не задан")
            imgui.NextColumn()

            imgui.Text("Фракция:")
            imgui.NextColumn()
            imgui.Text(Defency.settings.player_info.fraction or "Не задана")
            imgui.NextColumn()

            imgui.Text("Должность:")
            imgui.NextColumn()
            imgui.Text(Defency.settings.player_info.fraction_rank or "-")
            imgui.Columns(1)

            imgui.Separator()

            if Defency.UI.Helpers.CenterButton("Открыть настройки") then
                -- Можно добавить вызов настроек
            end

            imgui.EndTabItem()
        end

        -- ====================== ВКЛАДКА 2: Команды ======================
        if imgui.BeginTabItem("Команды") then
            if Defency.UI.Binder then
                Defency.UI.Binder.Draw()
            else
                imgui.Text("Модуль Binder не загружен")
            end
            imgui.EndTabItem()
        end

        -- ====================== ВКЛАДКА 3: Отделы ======================
        if imgui.BeginTabItem("Отделы") then
            if Defency.UI.UnitWindow then
                Defency.UI.UnitWindow.Draw()
            end
            imgui.EndTabItem()
        end

        -- ====================== ВКЛАДКА 4: RP Guns ======================
        if imgui.BeginTabItem("RP Оружие") then
            if Defency.RPGuns then
                imgui.Text("Количество оружия: " .. #Defency.RPGuns.guns)
                if imgui.Button("Обновить список") then
                    Defency.RPGuns.Init()
                end
            end
            imgui.EndTabItem()
        end

        -- ====================== ВКЛАДКА 5: Рация ======================
        if imgui.BeginTabItem("Рация") then
            if Defency.Departament then
                Defency.Departament.DrawUI()   -- можно вынести в отдельный ui файл позже
            end
            imgui.EndTabItem()
        end

        -- ====================== ВКЛАДКА 6: Настройки ======================
        if imgui.BeginTabItem("Настройки") then
            imgui.Text("Общие настройки")
            -- Здесь можно добавить основные настройки
            if imgui.Button("Сохранить настройки") then
                Defency.Config.Save()
                sampAddChatMessage("{00FF00}[Defency] {FFFFFF}Настройки сохранены!", -1)
            end
            imgui.EndTabItem()
        end

        imgui.EndTabBar()
    end

    imgui.End()
end

-- Горячие клавиши для открытия главного меню
function M.RegisterHotkeys()
    -- Можно добавить обработку биндов из настроек
end

return M