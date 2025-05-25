import { bind, Variable } from "astal";

const sidebarVar = Variable(true);
const isSidebarOpen = bind(sidebarVar);

export const useUi = () => {
  const toggleSidebar = () => {
    sidebarVar.set(!sidebarVar.get());
  };

  return {
    toggleSidebar,
    isSidebarOpen,
  };
};
