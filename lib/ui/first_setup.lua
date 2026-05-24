-- ui/first_setup.lua
local M = {}

M.Window = nil
M.step = 1
M.fraction = nil
M.nick = nil
M.name_surname = nil
M.sex = nil

local fractions = nil

local function EnsureInit()
    if M.Window then return end
    M.Window = imgui.new.bool(false)
    M.fraction = imgui.new.int(0)
    M.nick = imgui.new.char[64]("")
    M.name_surname = imgui.new.char[64]("")
    M.sex = imgui.new.int(0)
    fractions = { u8("ФПС"), u8("Армия"), u8("Другое") }
end

function M.Show()
    EnsureInit()
    M.Window[0] = true
    M.step = 1
end

function M.Draw()
    EnsureInit()
    imgui.SetNextWindowSize(imgui.ImVec2(520, 400), imgui.Cond.Always)
    imgui.Begin(u8("Первоначальная настройка Defency Helper"), M.Window, imgui.WindowFlags.NoResize)

    imgui.TextColored(imgui.ImVec4(0.3, 0.8, 1.0, 1.0), u8("Добро пожаловать! Давайте настроим скрипт под вас."))
    imgui.Separator()

    if M.step == 1 then
        imgui.Text(u8("1. Выберите вашу фракцию:"))
        imgui.Combo("##frac", M.fraction, fractions)

        if imgui.Button(u8("Далее"), imgui.ImVec2(-1, 40)) then
            M.step = 2
        end

    elseif M.step == 2 then
        imgui.Text(u8("2. Ваши данные:"))
        imgui.InputText(u8("Ник"), M.nick, 64)
        imgui.InputText(u8("Имя Фамилия (RP)"), M.name_surname, 64)

        imgui.RadioButton(u8("Мужской персонаж"), M.sex, 0)
        imgui.SameLine()
        imgui.RadioButton(u8("Женский персонаж"), M.sex, 1)

        if imgui.Button(u8("Назад"), imgui.ImVec2(150, 40)) then
            M.step = 1
        end
        imgui.SameLine()
        if imgui.Button(u8("Сохранить настройки"), imgui.ImVec2(-1, 40)) then
            if Defency.Config then
                local nick = u8:decode(ffi.string(M.nick))
                local name = u8:decode(ffi.string(M.name_surname))

                Defency.Config.settings.player_info.nick = nick
                Defency.Config.settings.player_info.name_surname = name
                Defency.Config.settings.player_info.sex = (M.sex[0] == 0) and "Мужской" or "Женский"

                if M.fraction[0] == 0 then
                    Defency.Config.settings.general.fraction_mode = "prison"
                elseif M.fraction[0] == 1 then
                    Defency.Config.settings.general.fraction_mode = "army"
                else
                    Defency.Config.settings.general.fraction_mode = "none"
                end

                Defency.Config.Save()
            end

            M.Window[0] = false
            sampAddChatMessage("{00FF00}[Defency] {FFFFFF}Настройки сохранены! Скрипт готов к работе.", -1)
        end
    end

    imgui.End()
end

return M
