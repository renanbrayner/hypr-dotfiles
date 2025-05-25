import { Gdk } from "astal/gtk4";
import Bar from "../../components/Bar";
import Frame from "../../components/Frame";

const Dracul = (gdkmonitor: Gdk.Monitor) => {
  const FrameMonitor = Frame(gdkmonitor);
  const BottomMonitor = Bar(gdkmonitor);
  return (
    <window>
      <FrameMonitor />
      <BottomMonitor />
    </window>
  );
};

export default Dracul;
