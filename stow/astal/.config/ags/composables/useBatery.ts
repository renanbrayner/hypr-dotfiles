import { bind, Variable } from "astal";
import Battery from "gi://AstalBattery?version=0.1";
import { getBatteryIcon } from "../utils/getBatteryIcon";

export const useBattery = () => {
  // Obtém a instância padrão da bateria
  const battery = Battery.get_default();

  // Variáveis reativas básicas
  const percentage = bind(battery, "percentage");
  const state = bind(battery, "state");
  const timeToFull = bind(battery, "timeToFull");
  const timeToEmpty = bind(battery, "timeToEmpty");
  const charging = bind(battery, "charging");

  // Variáveis derivadas úteis
  const percentageValue = percentage.as((p) => Math.round(p * 100));

  // Variável reativa para a classe CSS
  const batteryClassVar = Variable("");
  const batteryClass = bind(batteryClassVar);

  // Variável reativa para o tooltip
  const tooltipTextVar = Variable("");
  const tooltipText = bind(tooltipTextVar);

  // Variável reativa para o ícone da bateria
  const batteryIconVar = Variable("");
  const batteryIcon = bind(batteryIconVar);

  // Função para determinar a classe CSS com base no nível da bateria
  const getBatteryClass = (level: number, isCharging: boolean) => {
    let className = "";

    if (level <= 0.25) className = "battery-critical";
    else if (level <= 0.5) className = "battery-low";
    else if (level <= 0.75) className = "battery-medium";
    else className = "battery-good";

    if (isCharging) className += " charging";

    return className;
  };

  // Função para atualizar a classe CSS
  const updateBatteryClass = () => {
    const level = percentage.get();
    const isCharging = charging.get();
    const className = getBatteryClass(level, isCharging);
    batteryClassVar.set(className);
  };

  // Função para atualizar o tooltip
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

  // Função para atualizar o ícone
  const updateBatteryIcon = () => {
    batteryIconVar.set(getBatteryIcon(battery));
  };

  // Inscreve-se para atualizações
  percentage.subscribe(updateBatteryClass);
  charging.subscribe(updateBatteryClass);
  percentage.subscribe(updateTooltip);
  charging.subscribe(updateTooltip);
  state.subscribe(updateBatteryIcon);

  // Inicializa os valores
  updateBatteryClass();
  updateTooltip();
  updateBatteryIcon();

  return {
    // Propriedades básicas
    percentage,
    percentageValue,
    state,
    timeToFull,
    timeToEmpty,
    charging,

    // Propriedades derivadas
    batteryClass,
    tooltipText,
    batteryIcon,

    // Métodos úteis (opcional)
    getBatteryClass: (level: number, isCharging: boolean) =>
      getBatteryClass(level, isCharging),
    formatTimeRemaining: (seconds: number) => {
      const hours = Math.floor(seconds / 3600);
      const minutes = Math.floor((seconds % 3600) / 60);
      return `${hours.toString().padStart(2, "0")}h${minutes.toString().padStart(2, "0")}`;
    },
  };
};
