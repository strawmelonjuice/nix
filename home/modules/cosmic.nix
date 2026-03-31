# Okay. Since flakes and stuff work shitty here, linking files from this module.
#
# God this is a lot of pain lol
# AND SO INCONSISTENT!
#
# But doable.
# I'll add more when I can, we so far had the modules:
# - com.system76.CosmicBackground
# - com.system76.CosmicComp
#
# Current source of initial config: Ponyta
{ ... }:
{
  # com.system76.CosmicBackground -------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicBackground/v1/all".text = ''
    (
        output: "all",
        source: Path("/home/mar/.local/share/wallpapers/current_wallpaper.png"),
        filter_by_theme: true,
        rotation_frequency: 300,
        filter_method: Lanczos,
        scaling_mode: Zoom,
        sampling_method: Alphanumeric,
    )
  '';

  xdg.configFile."cosmic/com.system76.CosmicBackground/v1/same-on-all".text = "true";

  # com.system76.CosmicComp -------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/autotile".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/autotile_behavior".text = "PerWorkspace";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/cursor_follows_focus".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/focus_follows_cursor".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/edge_snap_threshold".text = "10";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/input_touchpad".text = ''
    (
        state: Enabled,
        click_method: Some(Clickfinger),
        scroll_config: Some((
            method: Some(TwoFinger),
            natural_scroll: Some(true),
            scroll_button: None,
            scroll_factor: None,
        )),
        tap_config: Some((
            enabled: true,
            button_map: Some(LeftRightMiddle),
            drag: true,
            drag_lock: false,
        )),
    )
  '';

  xdg.configFile."cosmic/com.system76.CosmicComp/v1/workspaces".text = ''
    (
        workspace_mode: OutputBound,
        workspace_layout: Vertical,
        action_on_typing: OpenLauncher,
    )
  '';
  # ignored: cosmic/com.system76.CosmicComp/v1/xkb_config, since this is auto-setup and per-device I feel.
}
