// TODO: fix and use this
import { bind, Variable } from "astal";
import Battery from "gi://AstalBattery?version=0.1";
import { getBatteryIcon } from "../utils/getBatteryIcon";

export const useBattery = () => {
  const battery = Battery.get_default();

  const percentage = bind(battery, "percentage");
  const state = bind(battery, "state");
  const timeToFull = bind(battery, "timeToFull");
  const timeToEmpty = bind(battery, "timeToEmpty");
  const charging = bind(battery, "charging");

  const percentageValue = percentage.as((p) => Math.round(p * 100));

  const batteryClassVar = Variable("");
  const batteryClass = bind(batteryClassVar);

  const tooltipTextVar = Variable("");
  const tooltipText = bind(tooltipTextVar);

  const batteryIconVar = Variable("");
  const batteryIcon = bind(batteryIconVar);

  const getBatteryClass = (level: number, isCharging: boolean) => {
    let className = "";

    if (level <= 0.25) className = "battery-critical";
    else if (level <= 0.5) className = "battery-low";
    else if (level <= 0.75) className = "battery-medium";
    else className = "battery-good";

    if (isCharging) className += " charging";

    return className;
  };

  const updateBatteryClass = () => {
    const level = percentage.get();
    const isCharging = charging.get();
    const className = getBatteryClass(level, isCharging);
    batteryClassVar.set(className);
  };

  const updateTooltip = () => {
    const isCharging = charging.get();
    const percent = percentageValue.get();
    let tooltip = `Nível da bateria: ${percent}%`;

    if (isCharging && timeToFull.get() > 0) {
      const hours = Math.floor(timeToFull.get() / 3600);
      const minutes = Math.floor((timeToFull.get() % 3600) / 60);
      tooltip += `\nTempo para carregar: ${hours.toString().padStart(2, "0")}h${minutes.toString().padStart(2, "0")}`;
    } else if (!isCharging && timeToEmpty.get() > 0) {
      const hours = Math.floor(timeToEmpty.get() / 3600);
      const minutes = Math.floor((timeToEmpty.get() % 3600) / 60);
      tooltip += `\nTempo para descarregar: ${hours.toString().padStart(2, "0")}h${minutes.toString().padStart(2, "0")}`;
    }

    tooltipTextVar.set(tooltip);
  };

  const updateBatteryIcon = () => {
    batteryIconVar.set(getBatteryIcon(battery));
  };

  percentage.subscribe(updateBatteryClass);
  charging.subscribe(updateBatteryClass);
  percentage.subscribe(updateTooltip);
  charging.subscribe(updateTooltip);
  state.subscribe(updateBatteryIcon);

  updateBatteryClass();
  updateTooltip();
  updateBatteryIcon();

  return {
    percentage,
    percentageValue,
    state,
    timeToFull,
    timeToEmpty,
    charging,

    batteryClass,
    tooltipText,
    batteryIcon,

    getBatteryClass: (level: number, isCharging: boolean) =>
      getBatteryClass(level, isCharging),
    formatTimeRemaining: (seconds: number) => {
      const hours = Math.floor(seconds / 3600);
      const minutes = Math.floor((seconds % 3600) / 60);
      return `${hours.toString().padStart(2, "0")}h${minutes.toString().padStart(2, "0")}`;
    },
  };
};
