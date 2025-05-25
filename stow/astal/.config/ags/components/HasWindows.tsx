import Hyprland from "gi://AstalHyprland?version=0.1";
import { bind } from "astal";
import { useHyprland } from "../composables/useHyprland";

export const HasWindow = () => {
  const { activeWindowTitle } = useHyprland();

  return (
    <box>
      {/* Mostra se tem janelas */}
      <label label={activeWindowTitle} />
    </box>
  );
};
