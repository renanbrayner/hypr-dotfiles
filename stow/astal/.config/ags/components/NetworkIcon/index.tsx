import { useNetwork } from "../../composables/useNetwork";

export const NetworkIcon = () => {
  const { isConnected, activeConnectionType } = useNetwork();

  return <label label={isConnected.as((v) => (v === true ? "" : "󰤭"))}></label>;
};
