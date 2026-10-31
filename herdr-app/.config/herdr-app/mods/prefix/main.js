// The ctrl-a prefix: a which-key popup that runs the next key's action from map.js.
import { View, div } from "gpui-kit";
import { h_flex, v_flex } from "gpui-base";
import { appHome, closeOverlay, commands, exec, props, readTextFile, run, settings, theme } from "herdr";
import { GROUPS, MAP, MODS, mapOf } from "./map.js";

// Groups from installed mods' prefix.json, kept across opens (every popup copy shares globalThis).
const extra = (globalThis.__prefixExtra ??= { groups: [], map: {} });

const keyText = (k) => (k.startsWith("shift-") ? `⇧${k.slice(6).toUpperCase()}` : k);

/** A mod's group with MODS' overrides applied: keys rebound or hidden, items left without a key dropped. */
function override(g, o) {
  const map = mapOf([g]);
  for (const [k, v] of Object.entries(o)) {
    if (v !== null) for (const [k2, v2] of Object.entries(map)) if (v2 === v) delete map[k2];
    if (v === null) delete map[k];
    else map[k] = v;
  }
  const items = g.items.map((i) => {
    const acts = new Set([...(i.run ? [i.run] : []), ...Object.values(i.bind ?? {})]);
    const keys = Object.keys(map).filter((k) => acts.has(map[k]));
    return keys.length ? { label: i.label, show: keys.map(keyText).join(" "), bind: Object.fromEntries(keys.map((k) => [k, map[k]])) } : null;
  }).filter(Boolean);
  return { ...g, items };
}

// Rereads every installed mod's prefix.json.
async function loadExtra() {
  const r = await exec("sh", ["-c", 'for f in "$1"/mods/*/prefix.json; do [ -f "$f" ] && printf "%s\\n" "$f"; done', "sh", appHome()]);
  const groups = [];
  for (const f of (r.stdout ?? "").split("\n").filter(Boolean)) {
    try {
      const g = JSON.parse((await readTextFile(f)) ?? "null");
      const mod = f.split("/").slice(-2)[0];
      if (g?.title && Array.isArray(g.items)) groups.push(MODS[mod] ? override(g, MODS[mod]) : g);
    } catch {}
  }
  extra.groups = groups;
  extra.map = mapOf(groups);
}

const MODIFIERS = new Set(["shift", "control", "ctrl", "alt", "super", "cmd", "platform", "function", "fn"]);

/** Runs a keys.json-style action: `name` or `name:value` (value fills the first argument). */
function dispatch(action) {
  const i = action.indexOf(":");
  if (i < 0) return run(action, {});
  const name = action.slice(0, i);
  const raw = action.slice(i + 1);
  const arg = commands().find((c) => c.name === name)?.args[0]?.name;
  const value = /^\d+$/.test(raw) ? Number(raw) : raw;
  return run(name, arg ? { [arg]: value } : {});
}

/** A key drawn as a keycap. */
function keycap(text, t, mono) {
  return div().flex_none().min_w(22).h(20).px(6).rounded(5).bg(t.raised).border(1).border_color(t.border)
    .flex().items_center().justify_center()
    .font_family(mono).text_size(11.5).font_semibold().text_color(t.foreground).child(text);
}

export default class Prefix extends View {
  init(_props, cx) {
    this.handle = cx.focus_handle();
    this.handle.focus();
    cx.spawn(async (cx) => { await loadExtra().catch(() => null); cx.notify(); });
  }

  key(e, cx) {
    if (MODIFIERS.has(e.key)) return;
    cx.stop_propagation();
    const map = { ...extra.map, ...MAP };
    const action = map[e.keystroke] ?? (e.key_char ? map[e.key_char] : undefined);
    closeOverlay(props().overlay);
    if (action) dispatch(action);
  }

  header(t, mono) {
    return h_flex().w_full().items_center().gap(10).pb(10).border_b(1).border_color(t.border)
      .child(div().px(8).py(2).rounded(5).bg(t.accent).text_color(t.accent_foreground)
        .font_family(mono).text_size(12).font_bold().child("ctrl-a"))
      .child(div().flex_1().text_size(13).font_medium().text_color(t.foreground).child("Prefix"))
      .child(h_flex().items_center().gap(6).text_size(11.5).text_color(t.dim)
        .child(keycap("esc", t, mono)).child("cancel"));
  }

  group(g, t, mono) {
    return v_flex().flex_1().min_w(0).gap(6)
      .child(div().pb(2).text_size(11).font_semibold().text_color(t.accent).child(g.title.toUpperCase()))
      .children(g.items.map((i) =>
        h_flex().items_center().gap(8)
          .child(h_flex().w(54).flex_none().child(keycap(i.show, t, mono)))
          .child(div().truncate().text_size(12.5).text_color(t.muted).child(i.label))));
  }

  render() {
    const t = theme();
    const mono = settings().font_family ?? "JetBrains Mono";
    return v_flex()
      .id("prefix")
      .size_full()
      .px(16)
      .pt(12)
      .pb(14)
      .gap(12)
      .track_focus(this.handle)
      .on_key_down((e, cx) => this.key(e, cx))
      .child(this.header(t, mono))
      .child(h_flex().w_full().items_start().gap(18).children([...GROUPS, ...extra.groups].map((g) => this.group(g, t, mono))));
  }
}
