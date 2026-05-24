-- themes.lua
local M = {}

M.FONT = nil

local function apply_dark_theme()
    -- Убираем imgui.SwitchContext() - он не нужен здесь
    local style = imgui.GetStyle()
    local dpi = Defency.settings.general.custom_dpi or 1.0

    style.WindowPadding = imgui.ImVec2(8 * dpi, 8 * dpi)
    style.FramePadding = imgui.ImVec2(6 * dpi, 5 * dpi)
    style.ItemSpacing = imgui.ImVec2(6 * dpi, 6 * dpi)
    style.ItemInnerSpacing = imgui.ImVec2(4 * dpi, 4 * dpi)
    style.ScrollbarSize = (Defency.IS_MOBILE and 16 or 12) * dpi
    style.GrabMinSize = 10 * dpi
    style.WindowRounding = 8 * dpi
    style.ChildRounding = 8 * dpi
    style.FrameRounding = 6 * dpi
    style.PopupRounding = 8 * dpi
    style.ScrollbarRounding = 8 * dpi
    style.GrabRounding = 6 * dpi

    local colors = style.Colors
    colors[imgui.Col.Text]              = imgui.ImVec4(1.00, 1.00, 1.00, 1.00)
    colors[imgui.Col.TextDisabled]      = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[imgui.Col.WindowBg]          = imgui.ImVec4(0.07, 0.07, 0.07, 0.98)
    colors[imgui.Col.ChildBg]           = imgui.ImVec4(0.10, 0.10, 0.10, 1.00)
    colors[imgui.Col.PopupBg]           = imgui.ImVec4(0.08, 0.08, 0.08, 0.98)
    colors[imgui.Col.Border]            = imgui.ImVec4(0.25, 0.25, 0.28, 0.60)
    colors[imgui.Col.FrameBg]           = imgui.ImVec4(0.15, 0.15, 0.18, 1.00)
    colors[imgui.Col.FrameBgHovered]    = imgui.ImVec4(0.22, 0.22, 0.25, 1.00)
    colors[imgui.Col.FrameBgActive]     = imgui.ImVec4(0.28, 0.28, 0.32, 1.00)
    colors[imgui.Col.TitleBg]           = imgui.ImVec4(0.10, 0.10, 0.12, 1.00)
    colors[imgui.Col.TitleBgActive]     = imgui.ImVec4(0.18, 0.18, 0.22, 1.00)
    colors[imgui.Col.Button]            = imgui.ImVec4(0.18, 0.18, 0.22, 1.00)
    colors[imgui.Col.ButtonHovered]     = imgui.ImVec4(0.28, 0.28, 0.32, 1.00)
    colors[imgui.Col.ButtonActive]      = imgui.ImVec4(0.35, 0.35, 0.40, 1.00)
    colors[imgui.Col.Header]            = imgui.ImVec4(0.25, 0.55, 0.95, 0.40)
    colors[imgui.Col.HeaderHovered]     = imgui.ImVec4(0.25, 0.55, 0.95, 0.70)
    colors[imgui.Col.HeaderActive]      = imgui.ImVec4(0.25, 0.55, 0.95, 1.00)
    colors[imgui.Col.CheckMark]         = imgui.ImVec4(0.25, 0.65, 0.95, 1.00)
    colors[imgui.Col.SliderGrab]        = imgui.ImVec4(0.25, 0.65, 0.95, 1.00)
end

local function apply_white_theme()
    local style = imgui.GetStyle()
    local dpi = Defency.settings.general.custom_dpi or 1.0

    style.WindowPadding = imgui.ImVec2(8 * dpi, 8 * dpi)
    style.FramePadding = imgui.ImVec2(6 * dpi, 5 * dpi)
    style.ItemSpacing = imgui.ImVec2(6 * dpi, 6 * dpi)
    style.ItemInnerSpacing = imgui.ImVec2(4 * dpi, 4 * dpi)
    style.ScrollbarSize = (Defency.IS_MOBILE and 16 or 12) * dpi
    style.GrabMinSize = 10 * dpi
    style.WindowRounding = 8 * dpi
    style.ChildRounding = 8 * dpi
    style.FrameRounding = 6 * dpi
    style.PopupRounding = 8 * dpi
    style.ScrollbarRounding = 8 * dpi
    style.GrabRounding = 6 * dpi

    local colors = style.Colors
    colors[imgui.Col.Text]              = imgui.ImVec4(0.00, 0.00, 0.00, 1.00)
    colors[imgui.Col.TextDisabled]      = imgui.ImVec4(0.50, 0.50, 0.50, 1.00)
    colors[imgui.Col.WindowBg]          = imgui.ImVec4(0.94, 0.94, 0.94, 1.00)
    colors[imgui.Col.ChildBg]           = imgui.ImVec4(0.98, 0.98, 0.98, 1.00)
    colors[imgui.Col.PopupBg]           = imgui.ImVec4(0.96, 0.96, 0.96, 0.98)
    colors[imgui.Col.Border]            = imgui.ImVec4(0.43, 0.43, 0.50, 0.50)
    colors[imgui.Col.FrameBg]           = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
    colors[imgui.Col.FrameBgHovered]    = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
    colors[imgui.Col.FrameBgActive]     = imgui.ImVec4(0.70, 0.70, 0.70, 1.00)
    colors[imgui.Col.TitleBg]           = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
    colors[imgui.Col.TitleBgActive]     = imgui.ImVec4(0.78, 0.78, 0.78, 1.00)
    colors[imgui.Col.Button]            = imgui.ImVec4(0.85, 0.85, 0.85, 1.00)
    colors[imgui.Col.ButtonHovered]     = imgui.ImVec4(0.75, 0.85, 0.95, 1.00)
    colors[imgui.Col.ButtonActive]      = imgui.ImVec4(0.65, 0.75, 0.85, 1.00)
    colors[imgui.Col.Header]            = imgui.ImVec4(0.25, 0.55, 0.95, 0.40)
    colors[imgui.Col.HeaderHovered]     = imgui.ImVec4(0.25, 0.55, 0.95, 0.70)
    colors[imgui.Col.HeaderActive]      = imgui.ImVec4(0.25, 0.55, 0.95, 1.00)
    colors[imgui.Col.CheckMark]         = imgui.ImVec4(0.25, 0.65, 0.95, 1.00)
    colors[imgui.Col.SliderGrab]        = imgui.ImVec4(0.25, 0.65, 0.95, 1.00)
end

-- MoonMonet (динамическая тема)
local function apply_moonmonet_theme()
    if not moon_monet then 
        apply_dark_theme()
        return 
    end
    local generated = moon_monet.buildColors(Defency.settings.general.moonmonet_theme_color, 1.0, true)
    -- Здесь нужно адаптировать generated цвета под ImGui
    -- Пока используем dark тему как fallback
    apply_dark_theme()
end

function M.ApplyCurrent()
    -- Проверяем, что ImGui инициализирован
    if not imgui or not imgui.GetStyle then
        return
    end
    
    local theme = Defency.settings.general.helper_theme

    if theme == 0 and moon_monet then
        apply_moonmonet_theme()
    elseif theme == 1 then
        apply_dark_theme()
    elseif theme == 2 then
        apply_white_theme()
    else
        apply_dark_theme() -- дефолт
    end
end

function M.InitFonts()
    if not imgui or not imgui.GetIO then
        return
    end
    
    local io = imgui.GetIO()
    if io and io.Fonts then
        M.FONT = io.Fonts:AddFontFromFileTTF(
            getWorkingDirectory() .. '\\fonts\\Trebuchet MS.ttf', 
            14 * (Defency.settings.general.custom_dpi or 1.0)
        )
        if not M.FONT then
            M.FONT = io.Fonts:AddFontDefault()
        end
    end
end

function M.GetHelperIcon()
    local icons = {
        police = fa.BUILDING_SHIELD,
        army   = fa.BUILDING_SHIELD,
        prison = fa.BUILDING_SHIELD,
        hospital = fa.HOSPITAL,
        gov    = fa.BUILDING_COLUMNS,
        none   = fa.BUILDING
    }
    return icons[Defency.settings.general.fraction_mode] or fa.BUILDING
end

return M