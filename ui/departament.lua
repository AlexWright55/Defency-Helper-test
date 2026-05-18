-- ui/departament.lua
local M = {}

M.Window = imgui.new.bool(false)

local input_text = imgui.new.char[512]("")
local selected_tag = imgui.new.int(0)
local selected_fm = imgui.new.int(0)

function M.Draw()
    imgui.SetNextWindowSize(imgui.ImVec2(680 * Defency.settings.general.custom_dpi, 
                                         520 * Defency.settings.general.custom_dpi), 
                            imgui.Cond.FirstUseEver)

    imgui.Begin(fa.RADIO .. " Департаментская рация " .. fa.RADIO, 
                M.Window, imgui.WindowFlags.NoCollapse)

    Defency.UI.Helpers.ChangeDPI()

    local dep = Defency.Departament.data

    imgui.Text("Настройки рации")
    imgui.Separator()

    imgui.Columns(2, nil, false)
    imgui.SetColumnWidth(0, 160 * Defency.settings.general.custom_dpi)

    imgui.Text("FM:")
    imgui.NextColumn()
    imgui.PushItemWidth(-1)
    imgui.InputText("##fm", imgui.new.char[32](u8(dep.dep_fm or "-")), 32)
    imgui.PopItemWidth()
    imgui.NextColumn()

    imgui.Text("Дополнительный тег:")
    imgui.NextColumn()
    imgui.PushItemWidth(-1)
    imgui.InputText("##tag1", imgui.new.char[64](u8(dep.dep_tag1 or "")), 64)
    imgui.PopItemWidth()
    imgui.NextColumn()

    imgui.Text("Основной тег:")
    imgui.NextColumn()
    imgui.PushItemWidth(-1)
    imgui.Combo("##main_tag", selected_tag, dep.dep_tags)
    imgui.PopItemWidth()
    imgui.Columns(1)

    imgui.Checkbox("Удалять квадратные скобки при отправке", dep.anti_skobki and imgui.new.bool(true) or imgui.new.bool(false))

    imgui.Separator()

    -- Отправка сообщения
    imgui.Text("Сообщение в рацию:")
    imgui.PushItemWidth(-1)
    imgui.InputTextMultiline("##radio_input", input_text, 512, imgui.ImVec2(-1, 90 * Defency.settings.general.custom_dpi))
    imgui.PopItemWidth()

    if imgui.Button(fa.PAPER_PLANE .. " Отправить в рацию", imgui.ImVec2(-1, 40)) then
        local msg = u8:decode(ffi.string(input_text))
        if msg and msg:len() > 0 then
            Defency.Departament.SendRadio(msg)
            imgui.StrCopy(input_text, "")  -- очистка
        else
            sampAddChatMessage("{FF9900}[Рация] {FFFFFF}Введите текст!", -1)
        end
    end

    imgui.Separator()

    -- Быстрые теги
    imgui.Text("Быстрые теги:")
    local cols = 5
    for i, tag in ipairs(dep.dep_tags) do
        if (i-1) % cols ~= 0 then imgui.SameLine() end
        if imgui.Button(u8(tag), imgui.ImVec2(110 * Defency.settings.general.custom_dpi, 0)) then
            dep.dep_tag2 = tag
            sampAddChatMessage("{00AAFF}[Рация] {FFFFFF}Тег изменён на: " .. tag, -1)
        end
    end

    imgui.End()
end

return M