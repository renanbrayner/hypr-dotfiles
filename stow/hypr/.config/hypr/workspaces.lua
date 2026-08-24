-- Hand-maintained: binds workspaces to the primary (leftmost) monitor by
-- EDID description, discovered at config-load time. Resilient across
-- reboots and across different output names (eDP-1, DP-1, HDMI-A-1, ...).
-- https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

local function monitorRef(m)
    if m and m.description and m.description ~= "" then
        return "desc:" .. m.description
    end
    return m and m.name
end

local monitors = hl.get_monitors() or {}
table.sort(monitors, function(a, b) return (a.x or 0) < (b.x or 0) end)
local leftMon = monitors[1]

if leftMon then
    local ref = monitorRef(leftMon)
    for i = 1, 5 do
        hl.workspace_rule({ workspace = tostring(i), monitor = ref, default = (i == 1) })
    end
end
