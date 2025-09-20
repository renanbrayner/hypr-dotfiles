import { App, Astal, Gtk } from "astal/gtk4";
import Battery from "gi://AstalBattery?version=0.1";
import { getBatteryIcon } from "../../utils/getBatteryIcon";
import { Variable, bind } from "astal";

// Componente do ícone da bateria
export const BatteryIcon = ({ onClick }: { onClick: () => void }) => {
  const { START } = Gtk.Align;
  const battery = Battery.get_default();

  // Criar variável reativa que observa múltiplas propriedades da bateria
  const batteryVar = Variable.derive([
    bind(battery, "percentage"),
    bind(battery, "state"),
    bind(battery, "timeToFull"),
    bind(battery, "timeToEmpty"),
    bind(battery, "charging"),
  ]);

  const percentage = () => Math.round(battery.percentage * 100);

  const getBatteryClass = (level: number) => {
    if (level <= 0.25) return "battery-critical";
    if (level <= 0.5) return "battery-low";
    if (level <= 0.75) return "battery-medium";
    return "battery-good";
  };

  const getTooltip = () => {
    if (battery.charging && battery.timeToFull > 0) {
      // charging
      const hours = Math.floor(battery.timeToFull / 3600);
      const minutes = Math.floor((battery.timeToFull % 3600) / 60);
      return `Nível da bateria: ${percentage()}%\nTempo para carregar: ${hours
        .toString()
        .padStart(2, "0")}h${minutes.toString().padStart(2, "0")}`;
    }
    if (!battery.charging && battery.timeToEmpty > 0) {
      // discharging
      const hours = Math.floor(battery.timeToEmpty / 3600);
      const minutes = Math.floor((battery.timeToEmpty % 3600) / 60);
      return `Nível da bateria: ${percentage()}%\nTempo para descarregar: ${hours
        .toString()
        .padStart(2, "0")}h${minutes.toString().padStart(2, "0")}`;
    }

    // fallback
    return `Nível da bateria: ${percentage()}%`;
  };

  return (
    <box
      halign={START}
      tooltipText={batteryVar(() => getTooltip())}
      cssClasses={["BatteryIcon"]}
    >
      <label
        cssClasses={batteryVar(() => [
          getBatteryClass(battery.percentage),
          battery.charging ? "charging" : "",
        ])}
        label={batteryVar(() => getBatteryIcon(battery))}
      />
    </box>
  );
};
