# Hyprland scrolling notes

This is the setup that currently gives you Niri-like infinite scrolling in Hyprland, including the maximize case and two-monitor edge handoff.

## Working files

- `~/.config/hypr/conf/custom.conf`
- `~/.config/hypr/conf/keybindings/default.conf`
- `~/.config/hypr/scripts/scroll-focus.sh`

## Current working config

### `custom.conf`

```ini
general {
    layout = scrolling
}

gestures {
    workspace_swipe_distance = 500
    workspace_swipe_invert = true
    workspace_swipe_min_speed_to_force = 30
    workspace_swipe_cancel_ratio = 0.5
    workspace_swipe_create_new = true
    workspace_swipe_forever = true
}

scrolling {
    fullscreen_on_one_column = false
    follow_focus = true
    wrap_focus = false
    wrap_swapcol = false
}

binds {
    window_direction_monitor_fallback = true
}
```

### `default.conf`

```ini
bind = $mainMod, left, exec, /home/hoi4/.config/hypr/scripts/scroll-focus.sh l
bind = $mainMod, right, exec, /home/hoi4/.config/hypr/scripts/scroll-focus.sh r
bind = $mainMod, M, fullscreen, 1
bind = $mainMod, F, fullscreen, 0
```

## Why this works

- `layout = scrolling` enables Hyprland's native scrolling layout.
- `fullscreen_on_one_column = false` keeps maximized columns from turning into the one-column fullscreen behavior that breaks the scroll feel.
- `wrap_focus = false` and `wrap_swapcol = false` stop looping back to the first tile.
- `window_direction_monitor_fallback = true` lets focus cross to the next monitor at the edge.
- `layoutmsg focus l/r` is the scrolling-layout command Hyprland expects for moving the scroll view.

## The helper script

`~/.config/hypr/scripts/scroll-focus.sh` does two things:

1. Tries `hyprctl dispatch layoutmsg "focus l"` or `focus r` first.
2. If the focused window position did not change, it falls back to `hyprctl dispatch movefocus l/r`.

That hybrid behavior is what makes:

- the scroll strip move normally inside the workspace
- the edge still hand off to the next monitor when needed

## What broke during the update

After the Hyprland update, plain `movefocus` no longer drove the scrolling view the way it used to.

The working command became:

```ini
layoutmsg, focus l
layoutmsg, focus r
```

But that alone stopped the monitor-edge transfer, so the script was added to fall back to `movefocus`.

## If this ever breaks again

Check these first:

1. `~/.config/hypr/conf/custom.conf` still has `layout = scrolling`
2. `scrolling { fullscreen_on_one_column = false }` is still set
3. `~/.config/hypr/conf/keybindings/default.conf` still calls `scroll-focus.sh`
4. `~/.config/hypr/scripts/scroll-focus.sh` is still executable
5. Reload Hyprland after edits
