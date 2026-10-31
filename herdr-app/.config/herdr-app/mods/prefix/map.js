// Keys after ctrl-a, grouped for the popup. `show` is the keycap text, `bind` maps keys to
// actions (as in keys.json); a lone `run` binds `show` itself.
export const GROUPS = [
  { title: "Tabs", items: [
    { show: "c", label: "New tab", run: "tab.new" },
    { show: "n", label: "Next tab", run: "tab.next" },
    { show: "p", label: "Previous tab", run: "tab.prev" },
    { show: ",", label: "Rename tab", run: "tab.rename" },
    { show: "1-9", label: "Go to tab", bind: Object.fromEntries([1, 2, 3, 4, 5, 6, 7, 8, 9].map((n) => [`${n}`, `tab.select:${n}`])) },
    { show: "⇧X", label: "Close tab", bind: { "shift-x": "tab.close" } },
  ] },
  { title: "Panes", items: [
    { show: ";", label: "Split right", run: "pane.split:right" },
    { show: "\"", label: "Split down", bind: { "\"": "pane.split:down", "shift-'": "pane.split:down" } },
    { show: "hjkl", label: "Focus pane", bind: { h: "pane.go:left", j: "pane.go:down", k: "pane.go:up", l: "pane.go:right" } },
    { show: "⇧←↓↑→", label: "Swap pane", bind: { "shift-left": "pane.swap:left", "shift-down": "pane.swap:down", "shift-up": "pane.swap:up", "shift-right": "pane.swap:right" } },
    { show: "z", label: "Zoom pane", run: "pane.zoom" },
    { show: "x", label: "Close pane", run: "pane.close" },
  ] },
  { title: "Spaces", items: [
    { show: "o", label: "Picker", bind: { o: "mod.open:picker", i: "mod.open:picker", w: "mod.open:picker" } },
    { show: "⇧N", label: "New space", bind: { "shift-n": "space.new" } },
    { show: "⇧W", label: "Rename space", bind: { "shift-w": "space.rename" } },
    { show: "g", label: "New worktree", run: "projects.worktree" },
    { show: "⇧A", label: "New agent", bind: { "shift-a": "projects.compose" } },
    { show: "⇧D", label: "Close space", bind: { "shift-d": "space.close" } },
  ] },
  { title: "Popups", items: [
    { show: "⇧G", label: "lazygit", bind: { "shift-g": "mod.open:popup-lazygit" } },
    { show: "⇧P", label: "ports", bind: { "shift-p": "mod.open:popup-ports" } },
    { show: "⇧K", label: "kate", bind: { "shift-k": "mod.open:popup-kate" } },
    { show: "t", label: "Scratch shell", run: "mod.open:popup-shell" },
    { show: "⇧O", label: "Projects", bind: { "shift-o": "projects.pick" } },
    { show: "⇧S", label: "Save layout", bind: { "shift-s": "projects.save" } },
  ] },
  { title: "App", items: [
    { show: "b", label: "Sidebar", run: "layout.toggle:sidebar" },
    { show: "⇧H", label: "Side panel", bind: { "shift-h": "layout.toggle:panel" } },
    { show: "s", label: "Settings", run: "app.settings" },
    { show: "?", label: "All keys", bind: { "?": "app.help", "shift-/": "app.help" } },
    { show: "d", label: "Detach", run: "window.close" },
  ] },
];

export const MAP = Object.assign(
  {},
  ...GROUPS.flatMap((g) => g.items).map((i) => ({ ...(i.run ? { [i.show]: i.run } : {}), ...i.bind })),
);
