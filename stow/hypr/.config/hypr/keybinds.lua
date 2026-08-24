-- Keybindings
-- https://wiki.hypr.land/Configuring/Basics/Binds/
-- https://wiki.hypr.land/Configuring/Basics/Dispatchers/

require("programs")

local mainMod = "SUPER"

-- Monitor identity: esquerda = primary (1-5 / Super+,),
-- direita = secondary (6-10 / Super+.). Estável através de reboots
-- enquanto a ordem física não mudar. Usa desc: (EDID) em vez do
-- nome do output, então funciona com qualquer nomenclatura
-- (eDP-1, DP-1, HDMI-A-1, ...).
local monitorsList = hl.get_monitors() or {}
table.sort(monitorsList, function(a, b) return (a.x or 0) < (b.x or 0) end)
local leftMon  = monitorsList[1]
local rightMon = monitorsList[2]

local function monitorRef(m)
    if not m then return nil end
    if m.description and m.description ~= "" then
        return "desc:" .. m.description
    end
    return m.name
end

-- Workspace offset: primary usa 1..5, qualquer outro usa 6..10.
local function wsNum(num, offset)
    local m = hl.get_active_monitor()
    if leftMon and m and m.id == leftMon.id then
        return num
    end
    return num + offset
end

-- Apps
hl.bind(mainMod .. " + RETURN",     hl.dsp.exec_cmd(terminal .. " -e tmux new-session -A -s 1"))
hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + E",          hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W",          hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + W",  hl.dsp.exec_cmd(secbrowser))
hl.bind(mainMod .. " + D",          hl.dsp.global("caelestia:launcher"))

-- Launcher interrupt on mouse buttons (was `bindin` in hyprlang)
hl.bind(mainMod .. " + mouse:272",  hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })
hl.bind(mainMod .. " + mouse:274",  hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })
hl.bind(mainMod .. " + mouse:275",  hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })
hl.bind(mainMod .. " + mouse:276",  hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })
hl.bind(mainMod .. " + mouse:277",  hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })
hl.bind(mainMod .. " + mouse_down", hl.dsp.global("caelestia:launcherInterrupt"), { mouse = true })

hl.bind(mainMod .. " + Z",          hl.dsp.exec_cmd(editor))
-- Print key — preserved `bindel` semantics (long_press)
hl.bind("Print",                    hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'), { long_press = true })
hl.bind(mainMod .. " + A",          hl.dsp.exec_cmd("~/.local/bin/restart_ags.sh"))
hl.bind(mainMod .. " + C",          hl.dsp.exec_cmd("hyprpicker -a -f hex"))

-- Hyprland
hl.bind(mainMod .. " + SHIFT + Escape", hl.dsp.global("caelestia:session"))
hl.bind(mainMod .. " + L",          hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(mainMod .. " + A",          hl.dsp.global("caelestia:showall"))

-- Windows
hl.bind(mainMod .. " + F",          hl.dsp.window.fullscreen({}))
hl.bind(mainMod .. " + SHIFT + Q",  hl.dsp.window.close({}))
hl.bind(mainMod .. " + SHIFT + F",  hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P",          hl.dsp.window.pin({}))

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",       hl.dsp.focus({ direction = "left"  }))
hl.bind(mainMod .. " + right",      hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",         hl.dsp.focus({ direction = "up"    }))
hl.bind(mainMod .. " + down",       hl.dsp.focus({ direction = "down"  }))

-- Cycle/swap stack (XMonad-like)
hl.bind(mainMod .. " + J",          hl.dsp.window.cycle_next({}))
hl.bind(mainMod .. " + K",          hl.dsp.window.cycle_next({ next = false }))
hl.bind(mainMod .. " + SHIFT + J",  hl.dsp.window.swap({ next = true }))
hl.bind(mainMod .. " + SHIFT + K",  hl.dsp.window.swap({ prev = true }))

-- Workspace switch (workspaces 1-5)
hl.bind(mainMod .. " + 1",  function() hl.dispatch(hl.dsp.focus({ workspace = wsNum(1,  5) })) end)
hl.bind(mainMod .. " + 2",  function() hl.dispatch(hl.dsp.focus({ workspace = wsNum(2,  5) })) end)
hl.bind(mainMod .. " + 3",  function() hl.dispatch(hl.dsp.focus({ workspace = wsNum(3,  5) })) end)
hl.bind(mainMod .. " + 4",  function() hl.dispatch(hl.dsp.focus({ workspace = wsNum(4,  5) })) end)
hl.bind(mainMod .. " + 5",  function() hl.dispatch(hl.dsp.focus({ workspace = wsNum(5,  5) })) end)

-- Move window to workspace
hl.bind(mainMod .. " + SHIFT + 1",  function() hl.dispatch(hl.dsp.window.move({ workspace = wsNum(1,  5) })) end)
hl.bind(mainMod .. " + SHIFT + 2",  function() hl.dispatch(hl.dsp.window.move({ workspace = wsNum(2,  5) })) end)
hl.bind(mainMod .. " + SHIFT + 3",  function() hl.dispatch(hl.dsp.window.move({ workspace = wsNum(3,  5) })) end)
hl.bind(mainMod .. " + SHIFT + 4",  function() hl.dispatch(hl.dsp.window.move({ workspace = wsNum(4,  5) })) end)
hl.bind(mainMod .. " + SHIFT + 5",  function() hl.dispatch(hl.dsp.window.move({ workspace = wsNum(5,  5) })) end)

-- Focus / move window to monitor (left = primary, right = secondary)
hl.bind(mainMod .. " + period", function()
    if rightMon then hl.dispatch(hl.dsp.focus({ monitor = monitorRef(rightMon) })) end
end)
hl.bind(mainMod .. " + comma", function()
    if leftMon then hl.dispatch(hl.dsp.focus({ monitor = monitorRef(leftMon) })) end
end)
hl.bind(mainMod .. " + SHIFT + period", function()
    if rightMon then hl.dispatch(hl.dsp.window.move({ monitor = monitorRef(rightMon) })) end
end)
hl.bind(mainMod .. " + SHIFT + comma", function()
    if leftMon then hl.dispatch(hl.dsp.window.move({ monitor = monitorRef(leftMon) })) end
end)

-- Scratchpad
hl.bind(mainMod .. " + M",          hl.dsp.exec_cmd("caelestia toggle specialws"))
hl.bind(mainMod .. " + SHIFT + M",  hl.dsp.window.move({ workspace = "special:special" }))

-- Screenshot
hl.bind(mainMod .. " + SHIFT + S",  hl.dsp.global("caelestia:screenshotFreeze"))

-- Scroll through workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }), { mouse = true })
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }), { mouse = true })

-- Move/resize windows
hl.bind(mainMod .. " + mouse:272",  hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273",  hl.dsp.window.resize(), { mouse = true })

-- Multimedia keys (lock-aware = bindl in hyprlang)
hl.bind("XF86MonBrightnessUp",    hl.dsp.global("caelestia:brightnessUp"),   { locked = true })
hl.bind("XF86MonBrightnessDown",  hl.dsp.global("caelestia:brightnessDown"), { locked = true })
hl.bind("XF86AudioPlay",          hl.dsp.global("caelestia:mediaToggle"),    { locked = true })
hl.bind("XF86AudioPause",         hl.dsp.global("caelestia:mediaToggle"),    { locked = true })
hl.bind("XF86AudioNext",          hl.dsp.global("caelestia:mediaNext"),      { locked = true })
hl.bind("XF86AudioPrev",          hl.dsp.global("caelestia:mediaPrev"),      { locked = true })
hl.bind("XF86AudioStop",          hl.dsp.global("caelestia:mediaStop"),      { locked = true })
hl.bind("XF86AudioMute",          hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })

-- AudioRaiseVolume / AudioLowerVolume were `bindle` (submap_universal) in hyprlang.
-- `volumeStep` was undefined; substituted with literal 5.
hl.bind("XF86AudioRaiseVolume",   hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { submap_universal = true })
hl.bind("XF86AudioLowerVolume",   hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ 0; wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { submap_universal = true })

-- Clipboard and emoji picker
hl.bind(mainMod .. " + V",          hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard"))
hl.bind(mainMod .. " + ALT + V",    hl.dsp.exec_cmd("pkill fuzzel || caelestia clipboard -d"))
hl.bind("CTRL + SHIFT + ALT + V",   hl.dsp.exec_cmd('sleep 0.5s && ydotool type -d 1 "$(cliphist list | head -1 | cliphist decode)"'), { locked = true })

-- Reload / restart caelestia (was `bindr` = release in hyprlang)
hl.bind("CTRL + " .. mainMod .. " + SHIFT + R", hl.dsp.exec_cmd("qs -c caelestia kill"))
hl.bind("CTRL + " .. mainMod .. " + ALT + R",   hl.dsp.exec_cmd("qs -c caelestia kill; caelestia shell -d"))