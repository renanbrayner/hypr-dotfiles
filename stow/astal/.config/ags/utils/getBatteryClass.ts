import Battery from "gi://AstalBattery";

const getBatteryClass = (battery: Battery.Device) => {
  const percent = battery.percentage;

  if (percent <= 0.2) return "battery-critical";
  if (percent <= 0.4) return "battery-low";
  if (percent <= 0.6) return "battery-medium";
  return "battery-good";
};
