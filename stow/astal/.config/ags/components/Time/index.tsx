import { Gtk } from "astal/gtk4";
import { Variable } from "astal";
import config from "../../config.json";

const time = Variable("").poll(
  1000,
  `env LC_TIME=${config.locale} date "+%H:%M"`,
);

const date = Variable("").poll(
  1000 * 60,
  `env LC_TIME=${config.locale} date "+%A, %d de %B"`,
);

export const Time = () => {
  const { END, CENTER } = Gtk.Align;
  const { VERTICAL } = Gtk.Orientation;
  const { SLIDE_DOWN } = Gtk.RevealerTransitionType;
  const isHovered = Variable(false);

  return (
    <box
      cssClasses={["Time"]}
      orientation={VERTICAL}
      hexpand
      valign={CENTER}
      halign={END}
      setup={(widget) => {
        // Configurar o detector de movimento do mouse
        const motion = new Gtk.EventControllerMotion();
        motion.connect("enter", () => {
          isHovered.set(true);
          // Atualizar manualmente o revealer quando o mouse entrar
          const revealer = widget.get_last_child();
          if (revealer instanceof Gtk.Revealer) {
            revealer.set_reveal_child(true);
          }
        });
        motion.connect("leave", () => {
          isHovered.set(false);
          // Atualizar manualmente o revealer quando o mouse sair
          const revealer = widget.get_last_child();
          if (revealer instanceof Gtk.Revealer) {
            revealer.set_reveal_child(false);
          }
        });
        widget.add_controller(motion);
        return widget;
      }}
    >
      <label
        cssClasses={["time-label", "color_blueberry_300", "mono"]}
        label={time()}
        halign={END}
      />
      <Gtk.Revealer
        transition_type={SLIDE_DOWN}
        transition_duration={300}
        reveal_child={false}
      >
        <label cssClasses={["date-label"]} label={date()} halign={END} />
      </Gtk.Revealer>
    </box>
  );
};
