import { App, Astal, Gtk, Gdk } from "astal/gtk4";
import { useHyprland } from "../../composables/useHyprland";
import config from "../../config.json";

export default function Frame(gdkmonitor: Gdk.Monitor) {
  const { currWorkspaceHasWindows } = useHyprland();
  const { TOP, BOTTOM, LEFT, RIGHT } = Astal.WindowAnchor;
  const { BACKGROUND } = Astal.Layer;

  return (
    <window
      anchor={TOP | BOTTOM | LEFT | RIGHT}
      application={App}
      cssClasses={currWorkspaceHasWindows.as((hasWindows) => {
        const classes = ["Frame"];

        if (hasWindows || config.autoCloseFrame === false) {
          // if autoCloseFrame is false the frame is always open
          classes.push("Frame--has-windows");
        } else {
          classes.push("Frame--no-windows");
        }

        return classes;
      })}
      exclusivity={Astal.Exclusivity.IGNORE}
      focusable={false}
      gdkmonitor={gdkmonitor}
      layer={BACKGROUND}
      visible
    />
  );
}
