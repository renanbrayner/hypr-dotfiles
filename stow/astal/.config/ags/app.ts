import { App } from "astal/gtk4";
import draculStyles from "./apps/dracul/styles.scss";
import Dracul from "./apps/dracul/Dracul";
import config from "./config.json";
import { Component } from "./types/Component";

const appLookupTable: Record<string, { app: Component; styles: string }> = {
  dracul: {
    app: Dracul,
    styles: draculStyles,
  },
};

App.start({
  css: appLookupTable[config.app].styles,
  main() {
    App.get_monitors().map(appLookupTable[config.app].app);
  },
});
