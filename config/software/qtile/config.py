from os import path

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.log_utils import logger
from qtile_extras import widget as widget_extra
from Xlib import display as xdisplay

# constants
mod = "mod4"
terminal = "alacritty"
date_format = "%T|%Y-%m-%d"


def get_num_monitors():
    num_monitors = 0
    try:
        display = xdisplay.Display()
        screen = display.screen()
        resources = screen.root.xrandr_get_screen_resources()

        for output in resources.outputs:
            monitor = display.xrandr_get_output_info(output, resources.config_timestamp)
            preferred = False
            if hasattr(monitor, "preferred"):
                preferred = monitor.preferred
            elif hasattr(monitor, "num_preferred"):
                preferred = monitor.num_preferred
            if preferred:
                num_monitors += 1
    except Exception as _:
        # always setup at least one monitor
        return 1
    else:
        return num_monitors

# Workspaces
groups = [Group(name) for name in ["www", "emacs", "media"]]
# TODO: configure scratchpad dropdown group for emacs agenda in alacritty

def switch_to_nth_group(n):
    @lazy.function
    def __inner(qtile):
        if 0 < n <= len(qtile.groups):
            qtile.groups[n - 1].toscreen()
    return __inner

# Layouts
## TODO: layout_themes
layout_theme = {
    "border_width": 2,
    # blabla
}
# layout.MonadTall(**layout_theme)
layouts = [layout.MonadTall(), layout.MonadWide(), layout.Max(), layout.Matrix()]
## Floating windows
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(wm_class="zoom"),
    ]
)

# Bar
widget_defaults = {"font": "Source Code Pro", "fontsize": 14, "padding": 3}
bar_height = 24
## Primary bar
primary_bar = bar.Bar(
    [
        widget.GroupBox(),
        widget.Sep(),
        widget.CurrentLayout(foreground="ffff00"),
        widget.Sep(),
        widget.WindowName(),
        # widget.Spacer(),
        # MAYBE: hide system info in a WidgetBox
        widget.Prompt(),
        widget.CPU(format='CPU:{load_percent}%'),
        widget.Sep(),
        widget.Memory(format='RAM:{MemUsed:.0f}{mm}/{MemTotal:.0f}{mm}',measure_mem='G'),
        widget.Sep(),
        widget.ThermalZone(
            zone="/sys/class/thermal/thermal_zone2/temp",
            format_crit="{temp}°C !!",
            high=80,
        ),
        widget.Sep(),
        widget.Battery(format='BAT: {char} {percent:2.0%} {hour:d}:{min:02d}'),
        widget.Sep(),
        widget.Clock(format=date_format),
        widget.Sep(),
        widget.Systray(),
    ],
    size=bar_height,
)
secondary_bar = bar.Bar(
    [
        widget.CurrentLayout(foreground="ffff00"),
        widget.Sep(),
        widget.AGroupBox(borderwidth=0),
        widget.Sep(),
        widget.WindowName(),
        widget.Spacer(),
        widget.Clock(format=date_format),
    ],
    size=bar_height,
)

# Screens
screens = [Screen(top=primary_bar)]

num_monitors = get_num_monitors()
if num_monitors > 1:
    for m in range(num_monitors - 1):
        screens.append(Screen(top=secondary_bar))

# Keybindings
# TODO: change window keybindings to those I have in xmonad
keys = [
    Key([mod], "Tab", lazy.switchgroup(), desc="View group"),
    Key([mod, "shift"], "Tab", lazy.togroup(), desc="Move window to group"),
    Key([mod], "space", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating status"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod, "shift"], "q", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "shift"], "r", lazy.reload_config(), desc="Reload the config"),
    Key(
        [mod],
        "d",
        lazy.spawn("rofi -show run"),
        desc="Spawn an application using rofi",
    ),
    Key([mod], "9", lazy.spawn("betterlockscreen -l"), desc="Lock screen"),
    Key(
        [mod],
        "0",
        # TODO: move scripts here, use lazy.run_extension(extension.CommandSet https://github.com/zordsdavini/qtile-config/blob/eacda219cebe357c46c3708f419f86bb585d4397/config.py#L274
        lazy.spawn(path.expanduser("~/.config/mastermenu/main.sh")),
        desc="Master menu",
    ),
    Key(
        [],
        "XF86AudioRaiseVolume",
        lazy.spawn("amixer -q sset Master 5%+ unmute"),
        desc="Volume up",
    ),
    Key(
        [],
        "XF86AudioLowerVolume",
        lazy.spawn("amixer -q sset Master 5%- unmute"),
        desc="Volume down",
    ),
    Key(
        [],
        "XF86AudioPlay",
        lazy.spawn("playerctl play-pause"),
        desc="Play/pause",
    ),
    Key(
        [],
        "XF86AudioNext",
        lazy.spawn("playerctl next"),
        desc="Next track",
    ),
    Key(
        [],
        "XF86AudioPrev",
        lazy.spawn("playerctl previous"),
        desc="Previous track",
    ),
]

for i in range(1, 10):
    keys.append(Key([mod], str(i), switch_to_nth_group(i)))


# Drag floating layouts.
mouse = [
    Drag(
        [mod],
        "Button1",
        lazy.window.set_position_floating(),
        start=lazy.window.get_position(),
    ),
    Drag(
        [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
    ),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


# Directional bindings, sorry Python gods for the eval
directions = [("left", "h"), ("right", "l"), ("down", "j"), ("up", "k")]
for direction, vim_key in directions:
    keys.extend(
        [
            Key(
                [mod],
                vim_key,
                eval(f"lazy.layout.{direction}()"),
                desc=f"Move focus to {direction}",
            ),
            Key(
                [mod, "shift"],
                vim_key,
                eval(f"lazy.layout.shuffle_{direction}()"),
                desc=f"Move window to the {direction}",
            ),
            Key(
                [mod, "control"],
                vim_key,
                eval(f"lazy.layout.grow_{direction}()"),
                desc=f"Grow window to the {direction}",
            ),
            Key(
                [mod],
                direction.capitalize(),
                eval(f"lazy.layout.{direction}()"),
                desc=f"Move focus to {direction}",
            ),
            Key(
                [mod, "shift"],
                direction.capitalize(),
                eval(f"lazy.layout.shuffle_{direction}()"),
                desc=f"Move window to the {direction}",
            ),
            Key(
                [mod, "control"],
                direction.capitalize(),
                eval(f"lazy.layout.grow_{direction}()"),
                desc=f"Grow window to the {direction}",
            ),
        ]
    )

# General configs
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
follow_mouse_focus = True
bring_front_click = False
cursor_warp = True

# Fsck Java
wmname = "LG3D"
