import { Gtk, Gdk } from "astal/gtk4";

export type Component = (gdkMonitor: Gdk.Monitor) => Gtk.Widget;
