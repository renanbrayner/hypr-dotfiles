import { App, Astal, Gtk, Gdk } from "astal/gtk4";
import { BatteryIcon } from "../BatteryIcon";
import config from "../../config.json";
import { HasWindow } from "../HasWindows";
import { Time } from "../Time";
import { NetworkIcon } from "../NetworkIcon";

export default function Bar(gdkmonitor: Gdk.Monitor) {
  const { BOTTOM, LEFT, RIGHT, TOP } = Astal.WindowAnchor;
  const { END } = Gtk.Align;
  const { BACKGROUND } = Astal.Layer;

  type BarPlacement = (typeof config)["barPlacement"];
  const barPlacementLookupTable: Record<BarPlacement, number> = {
    bottom: BOTTOM | LEFT | RIGHT,
    top: TOP | LEFT | RIGHT,
  };

  return (
    <window
      anchor={barPlacementLookupTable[config.barPlacement]}
      application={App}
      cssClasses={["Bar"]}
      exclusivity={Astal.Exclusivity.EXCLUSIVE}
      gdkmonitor={gdkmonitor}
      layer={BACKGROUND}
      visible
    >
      <centerbox cssName="centerbox">
        <box hexpand>
          <label label="foo" />
        </box>
        <box>
          <HasWindow />
        </box>
        <box halign={END}>
          <NetworkIcon />
          <Time />
          <BatteryIcon />
        </box>
      </centerbox>
    </window>
  );
}
