// Opens ["zsh", "-lc", "exec ports"] in a new pane zoomed over the tab; it has the keyboard and closes when the program exits.
import { View, div } from "gpui-kit";
import { closeOverlay, exec, focused, props, run } from "herdr";

const ARGV = ["zsh", "-lc", "exec ports"];

/** Waits (up to ~2 s) until focus leaves `pane`: the split has landed. */
async function moved(pane) {
  for (let i = 0; i < 40; i++) {
    if (focused()?.pane !== pane) return true;
    await exec("sleep", ["0.05"]);
  }
  return false;
}

export default class Popup extends View {
  init(_props, cx) {
    cx.spawn(async () => {
      const from = focused()?.pane;
      if (from) {
        run("pane.split", { direction: "down", pane: from, argv: ARGV });
        if (await moved(from)) run("pane.zoom", {});
      }
      closeOverlay(props().overlay);
    });
  }

  render() {
    return div();
  }
}
