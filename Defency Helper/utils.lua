-- utils.lua
local M = {}

-- ====================== JSON ======================
function M.EncodeJson(tbl)
    if dkok then
        local ok, encoded = pcall(dkjson.encode, tbl, {indent = true})
        if ok then return encoded end
    end
    local ok, encoded = pcall(encodeJson, tbl)
    if ok then return encoded end
    return nil
end

function M.DecodeJson(str)
    if type(str) == "table" then return str end
    if not str or str == "" then return {} end
    
    local trimmed = str:match("^%s*(.-)%s*$")
    if trimmed == "" then return {} end
    
    local ok, result = pcall(decodeJson, trimmed)
    if ok and type(result) == "table" then
        return result
    end
    return {}
end

-- ====================== ‘¿…ÀŒ¬€≈ Œœ≈–¿÷»» ======================
function M.ReadFile(path)
    if not doesFileExist(path) then return nil end
    local file = io.open(path, "r")
    if not file then return nil end
    local content = file:read("*a")
    file:close()
    return content
end

function M.WriteFile(path, content)
    local file = io.open(path, "w")
    if file then
        file:write(content)
        file:close()
        return true
    end
    return false
end

function M.ReadJson(path)
    local content = M.ReadFile(path)
    if content then
        return M.DecodeJson(content)
    end
    return nil
end

function M.WriteJson(path, tbl)
    local content = M.EncodeJson(tbl)
    if content then
        return M.WriteFile(path, content)
    end
    return false
end

-- ====================== “¿¡À»÷€ ======================
function M.MergeTables(default, current)
    for k, v in pairs(default) do
        if type(v) == "table" and type(current[k]) == "table" then
            M.MergeTables(v, current[k])
        elseif current[k] == nil then
            current[k] = v
        end
    end
end

function M.GetByPath(tbl, path)
    local keys = {}
    for key in path:gmatch("[^%.]+") do
        table.insert(keys, key)
    end
    local current = tbl
    for _, key in ipairs(keys) do
        if type(current) ~= "table" then return nil end
        current = current[key]
    end
    return current
end

function M.SetByPath(tbl, path, value)
    local keys = {}
    for key in path:gmatch("[^%.]+") do
        table.insert(keys, key)
    end
    local current = tbl
    for i = 1, #keys - 1 do
        local key = keys[i]
        if current[key] == nil then current[key] = {} end
        current = current[key]
    end
    current[keys[#keys]] = value
end

-- ====================== RP ‘”Õ ÷»» ======================
function M.ReplaceTags(text)
    if not text then return "" end
    
    local replacements = {
        ["{sex}"] = (Defency.settings.player_info.sex == "∆ÂÌ˘ËÌ‡") and "‡" or "",
        ["{my_nick}"] = Defency.settings.player_info.nick or "",
        ["{my_ru_nick}"] = Defency.settings.player_info.name_surname or "",
        ["{my_rp_nick}"] = (Defency.settings.player_info.nick or ""):gsub("_", " "),
        ["{fraction_tag}"] = Defency.settings.player_info.fraction_tag or "",
        ["{fraction_rank}"] = Defency.settings.player_info.fraction_rank or "",
        ["{get_time}"] = os.date("%H:%M:%S"),
        ["{get_date}"] = os.date("%d.%m.%Y"),
    }
    
    for tag, value in pairs(replacements) do
        text = text:gsub(tag, value)
    end
    
    return text
end

function M.ProcessRPCommand(text, args)
    text = M.ReplaceTags(text)
    -- «‰ÂÒ¸ ÏÓÊÌÓ ‰Ó·‡‚ËÚ¸ Ó·‡·ÓÚÍÛ {arg}, {arg_id} Ë Ú.‰.
    
    for line in text:gmatch("([^\n&]+)") do
        line = line:gsub("^%s+", ""):gsub("%s+$", "")
        if line:sub(1,1) == "/" then
            sampSendChat(line)
        else
            sampSendChat(line)
        end
        wait(300)
    end
end

-- ====================== ƒ–”√Œ≈ ======================
function M.GetPlayerIDByNickname(nick)
    if IS_MOBILE then
        return sampGetPlayerIdByNickname(nick)
    else
        return select(2, sampGetPlayerIdByCharHandle(PLAYER_PED))
    end
end

function M.CenterText(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((width - calc.x) / 2)
    imgui.Text(text)
end

function M.CenterButton(text)
    local width = imgui.GetWindowWidth()
    local calc = imgui.CalcTextSize(text)
    imgui.SetCursorPosX((width - calc.x) / 2)
    return imgui.Button(text)
end

function M.RemoveColorCodes(text)
    return text:gsub("{[%x%a]+}", "")
end

return M