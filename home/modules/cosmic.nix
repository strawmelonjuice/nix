# Okay. Since flakes and stuff work shitty here, linking files from this module.
#
# God this is a lot of pain lol
# AND SO INCONSISTENT!
#
# But doable.
#
# ... Okay I wrote https://tangled.org/strawmelonjuice.com/cosmic-to-nixxdgfilewrites/blob/main/src/convert_cosmic.gleam LOL
{ ... }:
{

  # com.system76.CosmicPanel.Panel -----------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/anchor".text = "Top";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/plugins_wings".text = ''
    Some(([
        "com.system76.CosmicPanelWorkspacesButton",
        "com.system76.CosmicPanelAppButton",
    ], [
        "com.system76.CosmicAppletInputSources",
        "com.system76.CosmicAppletStatusArea",
        "com.system76.CosmicAppletA11y",
        "com.system76.CosmicAppletTiling",
        "com.system76.CosmicAppletAudio",
        "com.system76.CosmicAppletBluetooth",
        "com.system76.CosmicAppletNetwork",
        "com.system76.CosmicAppletBattery",
        "com.system76.CosmicAppletNotifications",
        "com.system76.CosmicAppletPower",
    ]))
  '';
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/spacing".text = "0";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/margin".text = "0";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/autohover_delay_ms".text = "Some(500)";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/expand_to_edges".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/layer".text = "Top";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/exclusive_zone".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/border_radius".text = "0";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/background".text = "ThemeDefault";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/output".text = "All";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/name".text = "\"Panel\"";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/size_wings".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/opacity".text = "1.0";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/size".text = "XS";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/anchor_gap".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/autohide".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/plugins_center".text = ''
    Some([
        "com.system76.CosmicAppletTime",
    ])
  '';
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/size_center".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/keyboard_interactivity".text = "OnDemand";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Panel/v1/padding".text = "0";

  # com.system76.CosmicTheme.Dark ------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicTheme.Dark/v1/primary".text = ''
    (
        base: (
            red: 0.15292811,
            green: 0.15292811,
            blue: 0.15292808,
            alpha: 1.0,
        ),
        component: (
            base: (
                red: 0.21220893,
                green: 0.21220893,
                blue: 0.21220881,
                alpha: 1.0,
            ),
            hover: (
                red: 0.29098803,
                green: 0.29098803,
                blue: 0.2909879,
                alpha: 1.0,
            ),
            pressed: (
                red: 0.36976713,
                green: 0.36976713,
                blue: 0.36976704,
                alpha: 1.0,
            ),
            selected: (
                red: 0.29098803,
                green: 0.29098803,
                blue: 0.2909879,
                alpha: 1.0,
            ),
            selected_text: (
                red: 0.3882353,
                green: 0.8156863,
                blue: 0.8745098,
                alpha: 1.0,
            ),
            focus: (
                red: 0.3882353,
                green: 0.8156863,
                blue: 0.8745098,
                alpha: 1.0,
            ),
            divider: (
                red: 0.7913618,
                green: 0.7913618,
                blue: 0.7913618,
                alpha: 0.2,
            ),
            on: (
                red: 0.7913618,
                green: 0.7913618,
                blue: 0.7913618,
                alpha: 1.0,
            ),
            disabled: (
                red: 0.21220893,
                green: 0.21220893,
                blue: 0.21220881,
                alpha: 0.5,
            ),
            on_disabled: (
                red: 0.7913618,
                green: 0.7913618,
                blue: 0.7913618,
                alpha: 0.65,
            ),
            border: (
                red: 0.743206,
                green: 0.74320585,
                blue: 0.74320585,
                alpha: 1.0,
            ),
            disabled_border: (
                red: 0.743206,
                green: 0.74320585,
                blue: 0.74320585,
                alpha: 0.5,
            ),
        ),
        divider: (
            red: 0.31702772,
            green: 0.31702772,
            blue: 0.3170277,
            alpha: 1.0,
        ),
        on: (
            red: 0.97342616,
            green: 0.97342616,
            blue: 0.97342604,
            alpha: 1.0,
        ),
        small_widget: (
            red: 0.20212594,
            green: 0.20212597,
            blue: 0.20212597,
            alpha: 0.25,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Dark/v1/spacing".text = ''
    (
        space_none: 0,
        space_xxxs: 4,
        space_xxs: 4,
        space_xs: 8,
        space_s: 8,
        space_m: 16,
        space_l: 24,
        space_xl: 32,
        space_xxl: 48,
        space_xxxl: 64,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Dark/v1/corner_radii".text = ''
    (
        radius_0: (0.0, 0.0, 0.0, 0.0),
        radius_xs: (4.0, 4.0, 4.0, 4.0),
        radius_s: (8.0, 8.0, 8.0, 8.0),
        radius_m: (16.0, 16.0, 16.0, 16.0),
        radius_l: (32.0, 32.0, 32.0, 32.0),
        radius_xl: (160.0, 160.0, 160.0, 160.0),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Dark/v1/secondary".text = ''
    (
        base: (
            red: 0.20212594,
            green: 0.20212597,
            blue: 0.20212597,
            alpha: 1.0,
        ),
        component: (
            base: (
                red: 0.23260304,
                green: 0.2326031,
                blue: 0.23260301,
                alpha: 1.0,
            ),
            hover: (
                red: 0.30934274,
                green: 0.3093428,
                blue: 0.30934268,
                alpha: 1.0,
            ),
            pressed: (
                red: 0.3860824,
                green: 0.38608247,
                blue: 0.3860824,
                alpha: 1.0,
            ),
            selected: (
                red: 0.30934274,
                green: 0.3093428,
                blue: 0.30934268,
                alpha: 1.0,
            ),
            selected_text: (
                red: 0.3882353,
                green: 0.8156863,
                blue: 0.8745098,
                alpha: 1.0,
            ),
            focus: (
                red: 0.3882353,
                green: 0.8156863,
                blue: 0.8745098,
                alpha: 1.0,
            ),
            divider: (
                red: 0.81693083,
                green: 0.8169309,
                blue: 0.8169309,
                alpha: 0.2,
            ),
            on: (
                red: 0.81693083,
                green: 0.8169309,
                blue: 0.8169309,
                alpha: 1.0,
            ),
            disabled: (
                red: 0.23260304,
                green: 0.2326031,
                blue: 0.23260301,
                alpha: 0.5,
            ),
            on_disabled: (
                red: 0.81693083,
                green: 0.8169309,
                blue: 0.8169309,
                alpha: 0.65,
            ),
            border: (
                red: 0.743206,
                green: 0.74320585,
                blue: 0.74320585,
                alpha: 1.0,
            ),
            disabled_border: (
                red: 0.743206,
                green: 0.74320585,
                blue: 0.74320585,
                alpha: 0.5,
            ),
        ),
        divider: (
            red: 0.3174277,
            green: 0.31742772,
            blue: 0.3174277,
            alpha: 1.0,
        ),
        on: (
            red: 0.7786347,
            green: 0.7786347,
            blue: 0.77863467,
            alpha: 1.0,
        ),
        small_widget: (
            red: 0.2532908,
            green: 0.25329086,
            blue: 0.2532908,
            alpha: 0.25,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Dark/v1/palette".text = ''
    (
        name: "cosmic-dark",
        bright_red: (
            red: 1.0,
            green: 0.627451,
            blue: 0.5647059,
            alpha: 1.0,
        ),
        bright_green: (
            red: 0.36862746,
            green: 0.85882354,
            blue: 0.54901963,
            alpha: 1.0,
        ),
        bright_orange: (
            red: 1.0,
            green: 0.6392157,
            blue: 0.49019608,
            alpha: 1.0,
        ),
        gray_1: (
            red: 0.105882354,
            green: 0.105882354,
            blue: 0.105882354,
            alpha: 1.0,
        ),
        gray_2: (
            red: 0.14901961,
            green: 0.14901961,
            blue: 0.14901961,
            alpha: 1.0,
        ),
        neutral_0: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 1.0,
        ),
        neutral_1: (
            red: 0.105882354,
            green: 0.105882354,
            blue: 0.105882354,
            alpha: 1.0,
        ),
        neutral_2: (
            red: 0.1882353,
            green: 0.1882353,
            blue: 0.1882353,
            alpha: 1.0,
        ),
        neutral_3: (
            red: 0.2784314,
            green: 0.2784314,
            blue: 0.2784314,
            alpha: 1.0,
        ),
        neutral_4: (
            red: 0.36862746,
            green: 0.36862746,
            blue: 0.36862746,
            alpha: 1.0,
        ),
        neutral_5: (
            red: 0.46666667,
            green: 0.46666667,
            blue: 0.46666667,
            alpha: 1.0,
        ),
        neutral_6: (
            red: 0.5686275,
            green: 0.5686275,
            blue: 0.5686275,
            alpha: 1.0,
        ),
        neutral_7: (
            red: 0.67058825,
            green: 0.67058825,
            blue: 0.67058825,
            alpha: 1.0,
        ),
        neutral_8: (
            red: 0.7764706,
            green: 0.7764706,
            blue: 0.7764706,
            alpha: 1.0,
        ),
        neutral_9: (
            red: 0.8862745,
            green: 0.8862745,
            blue: 0.8862745,
            alpha: 1.0,
        ),
        neutral_10: (
            red: 1.0,
            green: 1.0,
            blue: 1.0,
            alpha: 1.0,
        ),
        accent_blue: (
            red: 0.3882353,
            green: 0.8156863,
            blue: 0.8745098,
            alpha: 1.0,
        ),
        accent_indigo: (
            red: 0.6313726,
            green: 0.7529412,
            blue: 0.92156863,
            alpha: 1.0,
        ),
        accent_purple: (
            red: 0.90588236,
            green: 0.6117647,
            blue: 0.99607843,
            alpha: 1.0,
        ),
        accent_pink: (
            red: 1.0,
            green: 0.6117647,
            blue: 0.69411767,
            alpha: 1.0,
        ),
        accent_red: (
            red: 0.99215686,
            green: 0.6313726,
            blue: 0.627451,
            alpha: 1.0,
        ),
        accent_orange: (
            red: 1.0,
            green: 0.6784314,
            blue: 0.0,
            alpha: 1.0,
        ),
        accent_yellow: (
            red: 0.96862745,
            green: 0.8784314,
            blue: 0.38431373,
            alpha: 1.0,
        ),
        accent_green: (
            red: 0.57254905,
            green: 0.8117647,
            blue: 0.6117647,
            alpha: 1.0,
        ),
        accent_warm_grey: (
            red: 0.7921569,
            green: 0.7294118,
            blue: 0.7058824,
            alpha: 1.0,
        ),
        ext_warm_grey: (
            red: 0.60784316,
            green: 0.5568628,
            blue: 0.5411765,
            alpha: 1.0,
        ),
        ext_orange: (
            red: 1.0,
            green: 0.6784314,
            blue: 0.0,
            alpha: 1.0,
        ),
        ext_yellow: (
            red: 0.99607843,
            green: 0.85882354,
            blue: 0.2509804,
            alpha: 1.0,
        ),
        ext_blue: (
            red: 0.28235295,
            green: 0.7254902,
            blue: 0.78039217,
            alpha: 1.0,
        ),
        ext_purple: (
            red: 0.8117647,
            green: 0.49019608,
            blue: 1.0,
            alpha: 1.0,
        ),
        ext_pink: (
            red: 0.9764706,
            green: 0.22745098,
            blue: 0.5137255,
            alpha: 1.0,
        ),
        ext_indigo: (
            red: 0.24313726,
            green: 0.53333336,
            blue: 1.0,
            alpha: 1.0,
        ),
    )
  '';

  # com.system76.CosmicIdle ------------------------------------------------------------------------------------------------

  # com.system76.CosmicTk --------------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicTk/v1/show_minimize".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicTk/v1/interface_density".text = "Compact";
  xdg.configFile."cosmic/com.system76.CosmicTk/v1/header_size".text = "Compact";
  xdg.configFile."cosmic/com.system76.CosmicTk/v1/interface_font".text = ''
    (
        family: "Lotion",
        weight: Normal,
        stretch: Normal,
        style: Normal,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTk/v1/monospace_font".text = ''
    (
        family: "Hermit",
        weight: Normal,
        stretch: Normal,
        style: Normal,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTk/v1/show_maximize".text = "false";

  # com.system76.CosmicPanel.Dock ------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/anchor".text = "Bottom";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/plugins_wings".text = "Some(([], []))";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/spacing".text = "0";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/margin".text = "4";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/autohover_delay_ms".text = "Some(500)";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/expand_to_edges".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/layer".text = "Top";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/exclusive_zone".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/border_radius".text = "160";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/background".text = "ThemeDefault";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/output".text = "All";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/name".text = "\"Dock\"";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/size_wings".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/opacity".text = "1.0";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/size".text = "L";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/anchor_gap".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/autohide".text = ''
    Some((
        wait_time: 1000,
        transition_time: 200,
        handle_size: 4,
        unhide_delay: 200,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/plugins_center".text = ''
    Some([
        "com.system76.CosmicPanelLauncherButton",
        "com.system76.CosmicPanelWorkspacesButton",
        "com.system76.CosmicPanelAppButton",
        "com.system76.CosmicAppList",
        "com.system76.CosmicAppletMinimize",
    ])
  '';
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/size_center".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/keyboard_interactivity".text = "OnDemand";
  xdg.configFile."cosmic/com.system76.CosmicPanel.Dock/v1/padding".text = "4";

  # com.system76.CosmicPanel -----------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicPanel/v1/entries".text = ''
    [
        "Panel",
        "Dock",
    ]
  '';

  # com.system76.CosmicTheme.Light.Builder ---------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/primary_container_bg".text =
    "None";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/bg_color".text = ''
    Some((
        red: 0.8901961,
        green: 0.8352941,
        blue: 0.77254903,
        alpha: 1.0,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/text_tint".text = ''
    Some((
        red: 0.12941177,
        green: 0.22352941,
        blue: 0.22352941,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/destructive".text = ''
    Some((
        red: 0.47058824,
        green: 0.16078432,
        blue: 0.18039216,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/spacing".text = ''
    (
        space_none: 0,
        space_xxxs: 4,
        space_xxs: 4,
        space_xs: 8,
        space_s: 8,
        space_m: 16,
        space_l: 24,
        space_xl: 32,
        space_xxl: 48,
        space_xxxl: 64,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/gaps".text = "(0, 8)";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/corner_radii".text = ''
    (
        radius_0: (0.0, 0.0, 0.0, 0.0),
        radius_xs: (4.0, 4.0, 4.0, 4.0),
        radius_s: (8.0, 8.0, 8.0, 8.0),
        radius_m: (16.0, 16.0, 16.0, 16.0),
        radius_l: (32.0, 32.0, 32.0, 32.0),
        radius_xl: (160.0, 160.0, 160.0, 160.0),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/warning".text = ''
    Some((
        red: 0.3254902,
        green: 0.28235295,
        blue: 0.0,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/success".text = ''
    Some((
        red: 0.09411765,
        green: 0.33333334,
        blue: 0.16078432,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/neutral_tint".text = ''
    Some((
        red: 0.46666667,
        green: 0.46666667,
        blue: 0.46666667,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/active_hint".text = "3";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/accent".text = ''
    Some((
        red: 0.09411765,
        green: 0.33333334,
        blue: 0.16078432,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/is_frosted".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/secondary_container_bg".text =
    "None";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/palette".text = ''
    Light((
        name: "cosmic-light",
        bright_red: (
            red: 0.5372549,
            green: 0.015686275,
            blue: 0.09411765,
            alpha: 1.0,
        ),
        bright_green: (
            red: 0.0,
            green: 0.34117648,
            blue: 0.17254902,
            alpha: 1.0,
        ),
        bright_orange: (
            red: 0.4745098,
            green: 0.17254902,
            blue: 0.0,
            alpha: 1.0,
        ),
        gray_1: (
            red: 0.8666667,
            green: 0.8666667,
            blue: 0.8666667,
            alpha: 1.0,
        ),
        gray_2: (
            red: 0.9098039,
            green: 0.9098039,
            blue: 0.9098039,
            alpha: 1.0,
        ),
        neutral_0: (
            red: 1.0,
            green: 1.0,
            blue: 1.0,
            alpha: 1.0,
        ),
        neutral_1: (
            red: 0.8862745,
            green: 0.8862745,
            blue: 0.8862745,
            alpha: 1.0,
        ),
        neutral_2: (
            red: 0.7764706,
            green: 0.7764706,
            blue: 0.7764706,
            alpha: 1.0,
        ),
        neutral_3: (
            red: 0.67058825,
            green: 0.67058825,
            blue: 0.67058825,
            alpha: 1.0,
        ),
        neutral_4: (
            red: 0.5686275,
            green: 0.5686275,
            blue: 0.5686275,
            alpha: 1.0,
        ),
        neutral_5: (
            red: 0.46666667,
            green: 0.46666667,
            blue: 0.46666667,
            alpha: 1.0,
        ),
        neutral_6: (
            red: 0.36862746,
            green: 0.36862746,
            blue: 0.36862746,
            alpha: 1.0,
        ),
        neutral_7: (
            red: 0.2784314,
            green: 0.2784314,
            blue: 0.2784314,
            alpha: 1.0,
        ),
        neutral_8: (
            red: 0.1882353,
            green: 0.1882353,
            blue: 0.1882353,
            alpha: 1.0,
        ),
        neutral_9: (
            red: 0.105882354,
            green: 0.105882354,
            blue: 0.105882354,
            alpha: 1.0,
        ),
        neutral_10: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 1.0,
        ),
        accent_blue: (
            red: 0.0,
            green: 0.32156864,
            blue: 0.3529412,
            alpha: 1.0,
        ),
        accent_indigo: (
            red: 0.18039216,
            green: 0.28627452,
            blue: 0.42745098,
            alpha: 1.0,
        ),
        accent_purple: (
            red: 0.40784314,
            green: 0.12941177,
            blue: 0.4862745,
            alpha: 1.0,
        ),
        accent_pink: (
            red: 0.5254902,
            green: 0.015686275,
            blue: 0.22745098,
            alpha: 1.0,
        ),
        accent_red: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        accent_orange: (
            red: 0.38431373,
            green: 0.2509804,
            blue: 0.0,
            alpha: 1.0,
        ),
        accent_yellow: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        accent_green: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        accent_warm_grey: (
            red: 0.33333334,
            green: 0.2784314,
            blue: 0.25882354,
            alpha: 1.0,
        ),
        ext_warm_grey: (
            red: 0.60784316,
            green: 0.5568628,
            blue: 0.5411765,
            alpha: 1.0,
        ),
        ext_orange: (
            red: 0.9843137,
            green: 0.72156864,
            blue: 0.42352942,
            alpha: 1.0,
        ),
        ext_yellow: (
            red: 0.96862745,
            green: 0.8784314,
            blue: 0.38431373,
            alpha: 1.0,
        ),
        ext_blue: (
            red: 0.41568628,
            green: 0.7921569,
            blue: 0.84705883,
            alpha: 1.0,
        ),
        ext_purple: (
            red: 0.8352941,
            green: 0.54901963,
            blue: 1.0,
            alpha: 1.0,
        ),
        ext_pink: (
            red: 1.0,
            green: 0.6117647,
            blue: 0.8666667,
            alpha: 1.0,
        ),
        ext_indigo: (
            red: 0.58431375,
            green: 0.76862746,
            blue: 0.9882353,
            alpha: 1.0,
        ),
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light.Builder/v1/window_hint".text = "None";

  # com.system76.CosmicTheme.Mode ------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicTheme.Mode/v1/auto_switch".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Mode/v1/is_dark".text = "false";

  # com.system76.CosmicTheme.Light -----------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/is_high_contrast".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/accent_text".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/destructive_button".text = ''
    (
        base: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        hover: (
            red: 0.45418516,
            green: 0.20634204,
            blue: 0.22202829,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.60689706,
            green: 0.4519951,
            blue: 0.46179894,
            alpha: 1.0,
        ),
        selected: (
            red: 0.45418516,
            green: 0.20634204,
            blue: 0.22202829,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.8698165,
            green: 0.8698165,
            blue: 0.8698163,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 0.5,
        ),
        border: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/accent_button".text = ''
    (
        base: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        hover: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.41866177,
            green: 0.53826964,
            blue: 0.45199502,
            alpha: 1.0,
        ),
        selected: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.8698165,
            green: 0.8698165,
            blue: 0.8698163,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 0.5,
        ),
        border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/text_tint".text = ''
    Some((
        red: 0.12941177,
        green: 0.22352941,
        blue: 0.22352941,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/primary".text = ''
    (
        base: (
            red: 0.9674849,
            green: 0.91167367,
            blue: 0.8479379,
            alpha: 1.0,
        ),
        component: (
            base: (
                red: 0.90167594,
                green: 0.84663445,
                blue: 0.7837384,
                alpha: 1.0,
            ),
            hover: (
                red: 0.9115083,
                green: 0.861971,
                blue: 0.8053645,
                alpha: 1.0,
            ),
            pressed: (
                red: 0.92134076,
                green: 0.87730753,
                blue: 0.82699066,
                alpha: 1.0,
            ),
            selected: (
                red: 0.9115083,
                green: 0.861971,
                blue: 0.8053645,
                alpha: 1.0,
            ),
            selected_text: (
                red: 0.09411765,
                green: 0.33333334,
                blue: 0.16078432,
                alpha: 1.0,
            ),
            focus: (
                red: 0.09411765,
                green: 0.33333334,
                blue: 0.16078432,
                alpha: 1.0,
            ),
            divider: (
                red: 0.0072667296,
                green: 0.095307834,
                blue: 0.09614996,
                alpha: 0.2,
            ),
            on: (
                red: 0.0072667296,
                green: 0.095307834,
                blue: 0.09614996,
                alpha: 1.0,
            ),
            disabled: (
                red: 0.90167594,
                green: 0.84663445,
                blue: 0.7837384,
                alpha: 0.5,
            ),
            on_disabled: (
                red: 0.0072667296,
                green: 0.095307834,
                blue: 0.09614996,
                alpha: 0.65,
            ),
            border: (
                red: 0.08610416,
                green: 0.08610424,
                blue: 0.08610415,
                alpha: 1.0,
            ),
            disabled_border: (
                red: 0.08610416,
                green: 0.08610424,
                blue: 0.08610415,
                alpha: 0.5,
            ),
        ),
        divider: (
            red: 0.7835364,
            green: 0.7577835,
            blue: 0.7068852,
            alpha: 1.0,
        ),
        on: (
            red: 0.047742233,
            green: 0.14222258,
            blue: 0.14267439,
            alpha: 1.0,
        ),
        small_widget: (
            red: 0.8685193,
            green: 0.86851937,
            blue: 0.8685192,
            alpha: 0.25,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/success_button".text = ''
    (
        base: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        hover: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.41866177,
            green: 0.53826964,
            blue: 0.45199502,
            alpha: 1.0,
        ),
        selected: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.7137255,
            green: 0.09019607,
            blue: 0.29411763,
            alpha: 1.0,
        ),
        focus: (
            red: 0.7137255,
            green: 0.09019607,
            blue: 0.29411763,
            alpha: 1.0,
        ),
        divider: (
            red: 0.8698165,
            green: 0.8698165,
            blue: 0.8698163,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 0.5,
        ),
        border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/destructive".text = ''
    (
        base: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        hover: (
            red: 0.45418516,
            green: 0.20634204,
            blue: 0.22202829,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.60689706,
            green: 0.4519951,
            blue: 0.46179894,
            alpha: 1.0,
        ),
        selected: (
            red: 0.45418516,
            green: 0.20634204,
            blue: 0.22202829,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.7352941,
            green: 0.5803921,
            blue: 0.59019595,
            alpha: 1.0,
        ),
        border: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/spacing".text = ''
    (
        space_none: 0,
        space_xxxs: 4,
        space_xxs: 4,
        space_xs: 8,
        space_s: 8,
        space_m: 16,
        space_l: 24,
        space_xl: 32,
        space_xxl: 48,
        space_xxxl: 64,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/button".text = ''
    (
        base: (
            red: 0.1792362,
            green: 0.1792362,
            blue: 0.17923617,
            alpha: 0.25,
        ),
        hover: (
            red: 0.16733268,
            green: 0.16733268,
            blue: 0.16733265,
            alpha: 0.4,
        ),
        pressed: (
            red: 0.4074502,
            green: 0.4074502,
            blue: 0.4074501,
            alpha: 0.625,
        ),
        selected: (
            red: 0.16733268,
            green: 0.16733268,
            blue: 0.16733265,
            alpha: 0.4,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.0777692,
            green: 0.17144057,
            blue: 0.17170575,
            alpha: 0.2,
        ),
        on: (
            red: 0.0777692,
            green: 0.17144057,
            blue: 0.17170575,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.1792362,
            green: 0.1792362,
            blue: 0.17923617,
            alpha: 0.125,
        ),
        on_disabled: (
            red: 0.0777692,
            green: 0.17144057,
            blue: 0.17170575,
            alpha: 0.65,
        ),
        border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/gaps".text = "(0, 8)";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/corner_radii".text = ''
    (
        radius_0: (0.0, 0.0, 0.0, 0.0),
        radius_xs: (4.0, 4.0, 4.0, 4.0),
        radius_s: (8.0, 8.0, 8.0, 8.0),
        radius_m: (16.0, 16.0, 16.0, 16.0),
        radius_l: (32.0, 32.0, 32.0, 32.0),
        radius_xl: (160.0, 160.0, 160.0, 160.0),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/shade".text = ''
    (
        red: 0.0,
        green: 0.0,
        blue: 0.0,
        alpha: 0.08,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/text_button".text = ''
    (
        base: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        hover: (
            red: 0.38857284,
            green: 0.38857287,
            blue: 0.38857278,
            alpha: 0.2,
        ),
        pressed: (
            red: 0.7432059,
            green: 0.7432059,
            blue: 0.7432057,
            alpha: 0.5,
        ),
        selected: (
            red: 0.38857284,
            green: 0.38857287,
            blue: 0.38857278,
            alpha: 0.2,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 0.2,
        ),
        on: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        on_disabled: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 0.65,
        ),
        border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/icon_button".text = ''
    (
        base: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        hover: (
            red: 0.38857284,
            green: 0.38857287,
            blue: 0.38857278,
            alpha: 0.2,
        ),
        pressed: (
            red: 0.7432059,
            green: 0.7432059,
            blue: 0.7432057,
            alpha: 0.5,
        ),
        selected: (
            red: 0.38857284,
            green: 0.38857287,
            blue: 0.38857278,
            alpha: 0.2,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 0.2,
        ),
        on: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        on_disabled: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 0.65,
        ),
        border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/background".text = ''
    (
        base: (
            red: 0.8901961,
            green: 0.8352941,
            blue: 0.77254903,
            alpha: 1.0,
        ),
        component: (
            base: (
                red: 1.0,
                green: 0.952581,
                blue: 0.8981411,
                alpha: 1.0,
            ),
            hover: (
                red: 1.0,
                green: 0.95732284,
                blue: 0.9083269,
                alpha: 1.0,
            ),
            pressed: (
                red: 1.0,
                green: 0.9620648,
                blue: 0.9185128,
                alpha: 1.0,
            ),
            selected: (
                red: 1.0,
                green: 0.95732284,
                blue: 0.9083269,
                alpha: 1.0,
            ),
            selected_text: (
                red: 0.09411765,
                green: 0.33333334,
                blue: 0.16078432,
                alpha: 1.0,
            ),
            focus: (
                red: 0.09411765,
                green: 0.33333334,
                blue: 0.16078432,
                alpha: 1.0,
            ),
            divider: (
                red: 0.0777692,
                green: 0.17144057,
                blue: 0.17170575,
                alpha: 0.2,
            ),
            on: (
                red: 0.0777692,
                green: 0.17144057,
                blue: 0.17170575,
                alpha: 1.0,
            ),
            disabled: (
                red: 1.0,
                green: 0.952581,
                blue: 0.8981411,
                alpha: 0.5,
            ),
            on_disabled: (
                red: 0.0777692,
                green: 0.17144057,
                blue: 0.17170575,
                alpha: 0.65,
            ),
            border: (
                red: 0.08610416,
                green: 0.08610424,
                blue: 0.08610415,
                alpha: 1.0,
            ),
            disabled_border: (
                red: 0.08610416,
                green: 0.08610424,
                blue: 0.08610415,
                alpha: 0.5,
            ),
        ),
        divider: (
            red: 0.7126484,
            green: 0.68547827,
            blue: 0.6354695,
            alpha: 1.0,
        ),
        on: (
            red: 0.0024575396,
            green: 0.0862148,
            blue: 0.08715112,
            alpha: 1.0,
        ),
        small_widget: (
            red: 0.7913618,
            green: 0.79136187,
            blue: 0.79136163,
            alpha: 0.25,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/name".text = "\"cosmic-light\"";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/warning".text = ''
    (
        base: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        hover: (
            red: 0.33810672,
            green: 0.30359694,
            blue: 0.077714555,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.5343481,
            green: 0.5127794,
            blue: 0.37160286,
            alpha: 1.0,
        ),
        selected: (
            red: 0.33810672,
            green: 0.30359694,
            blue: 0.077714555,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.66274506,
            green: 0.64117646,
            blue: 0.49999985,
            alpha: 1.0,
        ),
        border: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/secondary".text = ''
    (
        base: (
            red: 1.0,
            green: 0.9842438,
            blue: 0.9659938,
            alpha: 1.0,
        ),
        component: (
            base: (
                red: 0.9735144,
                green: 0.9578385,
                blue: 0.93968135,
                alpha: 1.0,
            ),
            hover: (
                red: 0.9761629,
                green: 0.9620546,
                blue: 0.94571316,
                alpha: 1.0,
            ),
            pressed: (
                red: 0.9788115,
                green: 0.9662708,
                blue: 0.95174503,
                alpha: 1.0,
            ),
            selected: (
                red: 0.9761629,
                green: 0.9620546,
                blue: 0.94571316,
                alpha: 1.0,
            ),
            selected_text: (
                red: 0.09411765,
                green: 0.33333334,
                blue: 0.16078432,
                alpha: 1.0,
            ),
            focus: (
                red: 0.09411765,
                green: 0.33333334,
                blue: 0.16078432,
                alpha: 1.0,
            ),
            divider: (
                red: 0.0777692,
                green: 0.17144057,
                blue: 0.17170575,
                alpha: 0.2,
            ),
            on: (
                red: 0.0777692,
                green: 0.17144057,
                blue: 0.17170575,
                alpha: 1.0,
            ),
            disabled: (
                red: 0.9735144,
                green: 0.9578385,
                blue: 0.93968135,
                alpha: 0.5,
            ),
            on_disabled: (
                red: 0.0777692,
                green: 0.17144057,
                blue: 0.17170575,
                alpha: 0.65,
            ),
            border: (
                red: 0.08610416,
                green: 0.08610424,
                blue: 0.08610415,
                alpha: 1.0,
            ),
            disabled_border: (
                red: 0.08610416,
                green: 0.08610424,
                blue: 0.08610415,
                alpha: 0.5,
            ),
        ),
        divider: (
            red: 0.81953174,
            green: 0.8256608,
            blue: 0.8110919,
            alpha: 1.0,
        ),
        on: (
            red: 0.09765857,
            green: 0.1913287,
            blue: 0.19148403,
            alpha: 1.0,
        ),
        small_widget: (
            red: 0.9338223,
            green: 0.9338224,
            blue: 0.93382215,
            alpha: 0.25,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/control_tint".text = ''
    Some((
        red: 0.46666667,
        green: 0.46666667,
        blue: 0.46666667,
    ))
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/success".text = ''
    (
        base: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        hover: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.41866177,
            green: 0.53826964,
            blue: 0.45199502,
            alpha: 1.0,
        ),
        selected: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.5470588,
            green: 0.6666666,
            blue: 0.580392,
            alpha: 1.0,
        ),
        border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/active_hint".text = "3";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/accent".text = ''
    (
        base: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        hover: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.41866177,
            green: 0.53826964,
            blue: 0.45199502,
            alpha: 1.0,
        ),
        selected: (
            red: 0.1530087,
            green: 0.34438127,
            blue: 0.20634201,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.5470588,
            green: 0.6666666,
            blue: 0.580392,
            alpha: 1.0,
        ),
        border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/is_frosted".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/is_dark".text = "false";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/palette".text = ''
    (
        name: "cosmic-light",
        bright_red: (
            red: 0.5372549,
            green: 0.015686275,
            blue: 0.09411765,
            alpha: 1.0,
        ),
        bright_green: (
            red: 0.0,
            green: 0.34117648,
            blue: 0.17254902,
            alpha: 1.0,
        ),
        bright_orange: (
            red: 0.4745098,
            green: 0.17254902,
            blue: 0.0,
            alpha: 1.0,
        ),
        gray_1: (
            red: 0.8666667,
            green: 0.8666667,
            blue: 0.8666667,
            alpha: 1.0,
        ),
        gray_2: (
            red: 0.9098039,
            green: 0.9098039,
            blue: 0.9098039,
            alpha: 1.0,
        ),
        neutral_0: (
            red: 1.0,
            green: 1.0,
            blue: 1.0,
            alpha: 1.0,
        ),
        neutral_1: (
            red: 0.8862745,
            green: 0.8862745,
            blue: 0.8862745,
            alpha: 1.0,
        ),
        neutral_2: (
            red: 0.7764706,
            green: 0.7764706,
            blue: 0.7764706,
            alpha: 1.0,
        ),
        neutral_3: (
            red: 0.67058825,
            green: 0.67058825,
            blue: 0.67058825,
            alpha: 1.0,
        ),
        neutral_4: (
            red: 0.5686275,
            green: 0.5686275,
            blue: 0.5686275,
            alpha: 1.0,
        ),
        neutral_5: (
            red: 0.46666667,
            green: 0.46666667,
            blue: 0.46666667,
            alpha: 1.0,
        ),
        neutral_6: (
            red: 0.36862746,
            green: 0.36862746,
            blue: 0.36862746,
            alpha: 1.0,
        ),
        neutral_7: (
            red: 0.2784314,
            green: 0.2784314,
            blue: 0.2784314,
            alpha: 1.0,
        ),
        neutral_8: (
            red: 0.1882353,
            green: 0.1882353,
            blue: 0.1882353,
            alpha: 1.0,
        ),
        neutral_9: (
            red: 0.105882354,
            green: 0.105882354,
            blue: 0.105882354,
            alpha: 1.0,
        ),
        neutral_10: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 1.0,
        ),
        accent_blue: (
            red: 0.0,
            green: 0.32156864,
            blue: 0.3529412,
            alpha: 1.0,
        ),
        accent_indigo: (
            red: 0.18039216,
            green: 0.28627452,
            blue: 0.42745098,
            alpha: 1.0,
        ),
        accent_purple: (
            red: 0.40784314,
            green: 0.12941177,
            blue: 0.4862745,
            alpha: 1.0,
        ),
        accent_pink: (
            red: 0.5254902,
            green: 0.015686275,
            blue: 0.22745098,
            alpha: 1.0,
        ),
        accent_red: (
            red: 0.47058824,
            green: 0.16078432,
            blue: 0.18039216,
            alpha: 1.0,
        ),
        accent_orange: (
            red: 0.38431373,
            green: 0.2509804,
            blue: 0.0,
            alpha: 1.0,
        ),
        accent_yellow: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        accent_green: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        accent_warm_grey: (
            red: 0.33333334,
            green: 0.2784314,
            blue: 0.25882354,
            alpha: 1.0,
        ),
        ext_warm_grey: (
            red: 0.60784316,
            green: 0.5568628,
            blue: 0.5411765,
            alpha: 1.0,
        ),
        ext_orange: (
            red: 0.9843137,
            green: 0.72156864,
            blue: 0.42352942,
            alpha: 1.0,
        ),
        ext_yellow: (
            red: 0.96862745,
            green: 0.8784314,
            blue: 0.38431373,
            alpha: 1.0,
        ),
        ext_blue: (
            red: 0.41568628,
            green: 0.7921569,
            blue: 0.84705883,
            alpha: 1.0,
        ),
        ext_purple: (
            red: 0.8352941,
            green: 0.54901963,
            blue: 1.0,
            alpha: 1.0,
        ),
        ext_pink: (
            red: 1.0,
            green: 0.6117647,
            blue: 0.8666667,
            alpha: 1.0,
        ),
        ext_indigo: (
            red: 0.58431375,
            green: 0.76862746,
            blue: 0.9882353,
            alpha: 1.0,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/warning_button".text = ''
    (
        base: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        hover: (
            red: 0.33810672,
            green: 0.30359694,
            blue: 0.077714555,
            alpha: 1.0,
        ),
        pressed: (
            red: 0.5343481,
            green: 0.5127794,
            blue: 0.37160286,
            alpha: 1.0,
        ),
        selected: (
            red: 0.33810672,
            green: 0.30359694,
            blue: 0.077714555,
            alpha: 1.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: -0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 1.0,
        ),
        on: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        on_disabled: (
            red: 0.99999994,
            green: 0.99999994,
            blue: 0.9999997,
            alpha: 0.5,
        ),
        border: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.3254902,
            green: 0.28235295,
            blue: 0.0,
            alpha: 0.5,
        ),
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/window_hint".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicTheme.Light/v1/link_button".text = ''
    (
        base: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        hover: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        pressed: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        selected: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        selected_text: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        focus: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        divider: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 0.2,
        ),
        on: (
            red: 0.09411765,
            green: 0.33333334,
            blue: 0.16078432,
            alpha: 1.0,
        ),
        disabled: (
            red: 0.0,
            green: 0.0,
            blue: 0.0,
            alpha: 0.0,
        ),
        on_disabled: (
            red: 0.047058824,
            green: 0.16666667,
            blue: 0.08039216,
            alpha: 0.5,
        ),
        border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 1.0,
        ),
        disabled_border: (
            red: 0.08610416,
            green: 0.08610424,
            blue: 0.08610415,
            alpha: 0.5,
        ),
    )
  '';

  # com.system76.CosmicTheme.Dark.Builder ----------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicTheme.Dark.Builder/v1/spacing".text = ''
    (
        space_none: 0,
        space_xxxs: 4,
        space_xxs: 4,
        space_xs: 8,
        space_s: 8,
        space_m: 16,
        space_l: 24,
        space_xl: 32,
        space_xxl: 48,
        space_xxxl: 64,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicTheme.Dark.Builder/v1/corner_radii".text = ''
    (
        radius_0: (0.0, 0.0, 0.0, 0.0),
        radius_xs: (4.0, 4.0, 4.0, 4.0),
        radius_s: (8.0, 8.0, 8.0, 8.0),
        radius_m: (16.0, 16.0, 16.0, 16.0),
        radius_l: (32.0, 32.0, 32.0, 32.0),
        radius_xl: (160.0, 160.0, 160.0, 160.0),
    )
  '';

  # com.system76.CosmicTerm ------------------------------------------------------------------------------------------------

  # com.system76.CosmicSettings.Shortcuts ----------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicSettings.Shortcuts/v1/system_actions".text = ''
    {
        Terminal: "wezterm start --cwd .",
    }
  '';

  # com.system76.CosmicSettings.WindowRules --------------------------------------------------------------------------------

  # com.system76.CosmicBackground ------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicBackground/v1/same-on-all".text = "true";
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

  # com.system76.CosmicFiles -----------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicFiles/v1/desktop".text = ''
    (
        grid_spacing: 100,
        icon_size: 100,
        show_content: false,
        show_mounted_drives: false,
        show_trash: false,
    )
  '';

  # com.system76.CosmicAppList ---------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicAppList/v1/filter_top_levels".text = "None";
  xdg.configFile."cosmic/com.system76.CosmicAppList/v1/enable_drag_source".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicAppList/v1/favorites".text = ''
    [
        "vivaldi-stable",
        "org.wezfurlong.wezterm",
        "obsidian",
        "fluffychat",
        "com.system76.CosmicFiles",
        "com.system76.CosmicSettings",
    ]
  '';

  # com.system76.CosmicAppLibrary ------------------------------------------------------------------------------------------

  # com.system76.CosmicPortal ----------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicPortal/v1/screenshot".text = "";

  # com.system76.CosmicSettingsDaemon --------------------------------------------------------------------------------------

  # com.system76.CosmicAppletTime ------------------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicAppletTime/v1/military_time".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicAppletTime/v1/first_day_of_week".text = "0";

  # com.system76.CosmicAudio -----------------------------------------------------------------------------------------------

  # com.system76.CosmicNotifications ---------------------------------------------------------------------------------------

  # com.system76.CosmicAppletBattery ---------------------------------------------------------------------------------------

  # com.system76.CosmicComp ------------------------------------------------------------------------------------------------
  # ignored: cosmic/com.system76.CosmicComp/v1/xkb_config, since this is auto-setup and per-device I feel.

  xdg.configFile."cosmic/com.system76.CosmicComp/v1/autotile".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/autotile_behavior".text = "PerWorkspace";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/cursor_follows_focus".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/focus_follows_cursor".text = "true";
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/keyboard_config".text = ''
    (
        numlock_state: BootOn,
    )
  '';
  xdg.configFile."cosmic/com.system76.CosmicComp/v1/workspaces".text = ''
    (
        workspace_mode: OutputBound,
        workspace_layout: Horizontal,
        action_on_typing: OpenLauncher,
    )
  '';
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

  # com.system76.CosmicSettings.Wallpaper ----------------------------------------------------------------------------------
  xdg.configFile."cosmic/com.system76.CosmicSettings.Wallpaper/v1/custom-images".text = ''
    [
        "/home/mar/.local/share/wallpapers/current_wallpaper.png",
    ]
  '';

}
