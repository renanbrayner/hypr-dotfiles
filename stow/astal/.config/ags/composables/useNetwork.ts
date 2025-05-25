import { bind, Variable } from "astal";
import Network from "gi://AstalNetwork?version=0.1";

export const useNetwork = () => {
  // Obtém a instância padrão do Network
  const network = Network.get_default();

  // Variáveis reativas básicas
  const primary = bind(network, "primary");
  const connectivity = bind(network, "connectivity");
  const state = bind(network, "state");

  // Wifi
  const wifi = bind(network, "wifi");
  const wifiEnabled = wifi.as((w) => w?.enabled ?? false);
  const wifiSsid = wifi.as((w) => w?.ssid ?? "");
  const wifiStrength = wifi.as((w) => w?.strength ?? 0);
  const wifiState = wifi.as((w) => w?.state ?? 0);
  const wifiIconName = wifi.as((w) => w?.icon_name ?? "");
  const wifiIsHotspot = wifi.as((w) => w?.is_hotspot ?? false);
  const wifiInternet = wifi.as((w) => w?.internet ?? 0);

  // Wired
  const wired = bind(network, "wired");
  const wiredSpeed = wired.as((w) => w?.speed ?? 0);
  const wiredState = wired.as((w) => w?.state ?? 0);
  const wiredIconName = wired.as((w) => w?.icon_name ?? "");
  const wiredInternet = wired.as((w) => w?.internet ?? 0);

  // Variáveis derivadas úteis
  const isConnected = state.as((s) => s === Network.State.CONNECTED_GLOBAL);
  const activeConnectionType = primary.as((p) => {
    switch (p) {
      case Network.Primary.WIFI:
        return "wifi";
      case Network.Primary.WIRED:
        return "wired";
      default:
        return "unknown";
    }
  });

  // Variável reativa combinada para o nome da conexão atual
  const activeConnectionNameVar = Variable("");
  const activeConnectionName = bind(activeConnectionNameVar);

  // Atualiza o nome da conexão com base no tipo primário
  const updateActiveConnectionName = () => {
    const p = primary.get();
    if (p === Network.Primary.WIFI) {
      activeConnectionNameVar.set(wifi.get()?.ssid ?? "");
    } else if (p === Network.Primary.WIRED) {
      activeConnectionNameVar.set("Ethernet");
    } else {
      activeConnectionNameVar.set("");
    }
  };

  // Inscreve-se para atualizações
  primary.subscribe(updateActiveConnectionName);
  wifi.subscribe(updateActiveConnectionName);

  // Variável reativa combinada para o ícone da conexão atual
  const activeConnectionIconVar = Variable("");
  const activeConnectionIcon = bind(activeConnectionIconVar);

  // Atualiza o ícone da conexão com base no tipo primário
  const updateActiveConnectionIcon = () => {
    const p = primary.get();
    if (p === Network.Primary.WIFI) {
      activeConnectionIconVar.set(wifi.get()?.icon_name ?? "");
    } else if (p === Network.Primary.WIRED) {
      activeConnectionIconVar.set(wired.get()?.icon_name ?? "");
    } else {
      activeConnectionIconVar.set("network-offline-symbolic");
    }
  };

  // Inscreve-se para atualizações de ícone
  primary.subscribe(updateActiveConnectionIcon);
  wifi.subscribe(updateActiveConnectionIcon);
  wired.subscribe(updateActiveConnectionIcon);

  // Função para escanear redes WiFi
  const scanWifiNetworks = () => {
    const w = wifi.get();
    if (w) {
      w.scan();
    }
  };

  // Função para ativar/desativar WiFi
  const toggleWifi = () => {
    const w = wifi.get();
    if (w) {
      w.set_enabled(!w.enabled);
    }
  };

  return {
    // Propriedades básicas
    primary,
    connectivity,
    state,
    wifi,
    wired,

    // Propriedades derivadas do WiFi
    wifiEnabled,
    wifiSsid,
    wifiStrength,
    wifiState,
    wifiIconName,
    wifiIsHotspot,
    wifiInternet,

    // Propriedades derivadas do Wired
    wiredSpeed,
    wiredState,
    wiredIconName,
    wiredInternet,

    // Propriedades combinadas úteis
    isConnected,
    activeConnectionType,
    activeConnectionName,
    activeConnectionIcon,

    // Métodos
    scanWifiNetworks,
    toggleWifi,
  };
};
