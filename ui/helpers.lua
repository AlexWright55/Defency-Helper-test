-- ui/helpers.lua
local M = {}

-- ====================== ÷≈Õ“–»–Œ¬¿Õ»≈ ======================
function M.CenterText(text)
    local width = imgui.GetWindowWidth()
    local text_size = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((width - text_size.x) / 2)
    imgui.Text(text)
end

function M.CenterTextColored(color, text)
    local width = imgui.GetWindowWidth()
    local text_size = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((width - text_size.x) / 2)
    imgui.TextColored(color, text)
end

function M.CenterButton(text)
    local width = imgui.GetWindowWidth()
    local text_size = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((width - text_size.x) / 2)
    return imgui.Button(text)
end

function M.CenterSmallButton(text)
    local width = imgui.GetWindowWidth()
    local text_size = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((width - text_size.x) / 2)
    return imgui.SmallButton(text)
end

-- ====================== “Œ√√À ======================
function M.ToggleButton(str_id, bool_val)
    local rBool = false
    local p = imgui.GetCursorScreenPos()
    local dl = imgui.GetWindowDrawList()

    local height = imgui.GetTextLineHeightWithSpacing()
    local width = height * 1.75
    local radius = height * 0.5

    if imgui.InvisibleButton(str_id, imgui.ImVec2(width, height)) then
        bool_val[0] = not bool_val[0]
        rBool = true
    end

    imgui.SameLine()
    imgui.Text(str_id:gsub("##.+", ""))

    local t = bool_val[0] and 1.0 or 0.0
    local col_bg = imgui.GetStyle().Colors[imgui.Col.FrameBg]
    local col_circle = bool_val[0] and imgui.GetStyle().Colors[imgui.Col.ButtonActive] 
                               or imgui.GetStyle().Colors[imgui.Col.TextDisabled]

    dl:AddRectFilled(p, imgui.ImVec2(p.x + width, p.y + height), 
                     imgui.GetColorU32Vec4(col_bg), height * 0.6)

    dl:AddCircleFilled(imgui.ImVec2(p.x + radius + t * (width - radius * 2), p.y + radius), 
                       radius - 1.5, imgui.GetColorU32Vec4(col_circle))

    return rBool
end

-- ====================== ƒ–”√Œ≈ ======================
function M.TextQuestion(text)
    imgui.SameLine()
    imgui.TextDisabled("(?)")
    if imgui.IsItemHovered() then
        imgui.BeginTooltip()
        imgui.Text(text)
        imgui.EndTooltip()
    end
end

function M.GetMiddleButtonX(count)
    local width = imgui.GetWindowContentRegionWidth()
    local spacing = imgui.GetStyle().ItemSpacing.x
    return count == 1 and width or (width / count) - ((spacing * (count - 1)) / count)
end

function M.ChangeDPI()
    imgui.PushFont(Defency.Themes.FONT)
end

return M