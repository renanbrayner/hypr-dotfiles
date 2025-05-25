import { bind, Variable } from "astal";
import Hyprland from "gi://AstalHyprland?version=0.1";

export const useHyprland = () => {
  const hypr = Hyprland.get_default();
  const focusedClient = bind(hypr, "focused_client");
  const focusedWorkspace = bind(hypr, "focused_workspace");
  const clients = bind(hypr, "clients");

  // Variável reativa combinada
  const currWorkspaceHasWindowsVar = Variable(false);
  const currWorkspaceHasWindows = bind(currWorkspaceHasWindowsVar);

  const activeWindowTitleVar = Variable("");
  const activeWindowTitle = bind(activeWindowTitleVar);
  const updateHasWindowVar = () => {
    const workspace = focusedWorkspace.get();
    const clientList = clients.get();
    if (!workspace) {
      currWorkspaceHasWindowsVar.set(false);
      return;
    }
    currWorkspaceHasWindowsVar.set(
      clientList.some((client) => client.workspace.id === workspace.id),
    );
  };

  // Para guardar a conexão do sinal do cliente em foco
  let focusedClientTitleHandler: number | null = null;

  const updateActiveWindowTitle = () => {
    const focused = focusedClient.get();

    // Remove conexão anterior, se houver
    if (focusedClientTitleHandler && focusedClientTitleHandler > 0) {
      // O método disconnect existe em GObject
      try {
        // @ts-ignore
        focusedClient.get()?.disconnect(focusedClientTitleHandler);
      } catch {}
      focusedClientTitleHandler = null;
    }

    if (!focused) {
      activeWindowTitleVar.set("");
      return;
    }

    // Atualiza o título imediatamente
    activeWindowTitleVar.set(focused.title);

    // Conecta para atualizar sempre que o título mudar
    // @ts-ignore
    focusedClientTitleHandler = focused.connect("notify::title", () => {
      activeWindowTitleVar.set(focused.title);
    });
  };

  focusedClient.subscribe(updateActiveWindowTitle);
  focusedWorkspace.subscribe(updateHasWindowVar);
  clients.subscribe(updateHasWindowVar);
  clients.subscribe(updateActiveWindowTitle);

  const currWorkspace = focusedWorkspace.as((workspace) => workspace?.id ?? 0);

  return {
    activeWindowTitle,
    focusedClient,
    currWorkspace,
    currWorkspaceHasWindows,
  };
};
