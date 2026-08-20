-- Autostart
-- https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function()
    hl.exec_cmd("wl-paste --watch cliphist store")
    hl.exec_cmd("caelestia shell -d")
    hl.exec_cmd("hypridle")
end)