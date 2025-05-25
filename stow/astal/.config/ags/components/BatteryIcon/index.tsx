import { App, Astal, Gtk } from "astal/gtk4";
import { useBattery } from "../../composables/useBatery";

// Componente do ícone da bateria
export const BatteryIcon = () => {
  const { START } = Gtk.Align;
  const { batteryIcon, tooltipText, batteryClass } = useBattery();

  return (
    <box halign={START} tooltipText={tooltipText} cssClasses={["BatteryIcon"]}>
      <label cssClasses={batteryClass} label={batteryIcon} />
    </box>
  );
};
