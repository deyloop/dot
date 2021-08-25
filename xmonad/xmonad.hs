import XMonad

import qualified XMonad.StackSet as W

-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

-- Hooks
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops

-- Layouts
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed

-- Actions
import XMonad.Actions.WithAll

import Data.Maybe
import Data.Monoid
import qualified Data.Map as M

main :: IO ()
main = xmonad . ewmh
  =<< statusBar "xmobar" myXmobarPP toggleStrutsKey myConfig
  where
    toggleStrutsKey :: XConfig Layout -> (KeyMask, KeySym)
    toggleStrutsKey XConfig{ modMask = m } = (m, xK_b)

myTerminal = "alacritty"
myWorkSpaces = ["work","extra","relax","4","5","6","7","8","aside"]
myWorkspaceIndices =  M.fromList $ zipWith (,) myWorkSpaces [1..]

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
  where i = fromJust $ M.lookup ws myWorkspaceIndices

myBorderWidth = 2

myConfig = def 
  { modMask             = mod4Mask
  , terminal            = myTerminal
  , layoutHook          = myLayout
  , startupHook         = myStartupHook
  , focusedBorderColor  = "#585858"
  , normalBorderColor   = "#1b1e21"
  , workspaces          = myWorkSpaces
  , borderWidth         = myBorderWidth
  , manageHook          = myManageHook
  }
  `additionalKeysP` myKeys

myKeys =
  -- application shortcuts
  [ ("M-w", spawn "firefox &")
  , ("M-f", spawn "thunar &")
  , ("M-<Return>", spawn $ myTerminal ++ " &")
  , ("M-S-p", spawn "~/.local/bin/scripts/pscircle-draw")

  -- rofi menus
  , ("M-z d", spawn "rofi -show drun &")
  , ("M-z z", spawn "rofi -show run &")
  , ("M-z w", spawn "rofi -show window &")

  -- window management
  , ("M-q", kill)

  -- volume controls
  , ("<XF86AudioMute>", spawn "~/.local/bin/scripts/vol mute")
  , ("<XF86AudioLowerVolume>", spawn "~/.local/bin/scripts/vol down")
  , ("<XF86AudioRaiseVolume>", spawn "~/.local/bin/scripts/vol up")

  -- brightness controls
  , ("<XF86MonBrightnessUp>", spawn "CHANGE_AMOUNT=10 ~/.local/bin/scripts/brightness up")
  , ("<XF86MonBrightnessDown>", spawn "CHANGE_AMOUNT=10 ~/.local/bin/scripts/brightness down")
  , ("S-<XF86MonBrightnessUp>", spawn "~/.local/bin/scripts/brightness up")
  , ("S-<XF86MonBrightnessDown>", spawn "~/.local/bin/scripts/brightness down")

  -- screenshot
  , ("<Print>", spawn "~/.local/bin/scripts/screenshot")
  
  -- restart in place
  , ("M-r", spawn "xmonad --recompile; killall xmobar; xmonad --restart")

  -- Power Menu
  , ("M-<Delete>", spawn "~/.local/bin/scripts/powermenu")
  ]
  ++
  -- Move all windows in the current workspace to target workspace
  -- M-C-S-[workspace key]
  [("M-C-S-"++ show k, withAll' $ W.shiftWin i)
    | (i,k) <- zip myWorkSpaces [1 .. 9]]

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ className =? "Pavucontrol" --> doFloat
  , className =? "feh" --> doFloat 
  ]

myLayout = tiled ||| tabs ||| threeCol
  where
    threeCol  = ThreeColMid nmaster delta ratio
    tiled     = Tall nmaster delta ratio
    tabs      = tabbedBottom shrinkText myTabTheme
    nmaster   = 1
    ratio     = 1/2
    delta     = 3/100

-- setting colors for tabs layout and tabs sublayout.
myTabTheme = def { fontName            = "xft:Hack:size=9"
                 , activeColor         = "#00afaf"
                 , inactiveColor       = "#313846"
                 , activeBorderColor   = "#46d9ff"
                 , inactiveBorderColor = "#282c34"
                 , activeTextColor     = "#282c34"
                 , inactiveTextColor   = "#d0d0d0"
                 }

myXmobarPP :: PP
myXmobarPP = def
  { ppSep               = magenta " • "
  , ppTitle             = green . shorten 65
  , ppLayout            = lowWhite
  , ppCurrent           = wrap (blue "[") (blue "]") . yellow
  , ppHidden            = white . wrap " " "" . clickable
  , ppHiddenNoWindows   = lowWhite . wrap " " "" . clickable
  , ppUrgent            = red . wrap (yellow "!") (yellow "!")
  , ppOrder             = \[ws, l, t]-> [ws, l, t]
  }
  where
    formatFocused   = wrap (white     "[") (white     "]") . magenta . ppWindow
    formatUnFocused = wrap (lowWhite  "[") (lowWhite  "]") . blue . ppWindow
    ppWindow :: String -> String
    ppWindow = xmobarRaw . (\w -> if null w then "untitled" else w) . shorten 30

    blue, lowWhite, magenta, red, white, yellow :: String -> String
    magenta  = xmobarColor "#ff5faf" ""
    blue     = xmobarColor "#00afaf" ""
    lowWhite = xmobarColor "#5f8787" ""
    yellow   = xmobarColor "#d7af5f" ""
    red      = xmobarColor "#af005f" ""
    green    = xmobarColor "#5faf5f" ""
    white    = xmobarColor "#bbbbbb" ""

myStartupHook = do
  -- Important system processes

  -- get auth to work with polkit-gnome
  spawnOnce "/usr/lib/polkit-gnome/polkit-gnome/polkit-gonem-authentication-agent-1 &"

  -- dex to execute .desktop files in autostart.
  spawnOnce "dex -a -s /etc/xdg/autostart/:~/.config/autostart/ &"

  -- compositor
  spawnOnce "picom -CGb &"

  -- set power savings for display
  spawnOnce "xset s 480 dpms 600 600 600 &"

  -- desktop notifications
  spawnOnce "dbus-launch dunst --config ~/.config/dunst/dunstrc &"


  -- keyboard and mouse settings
  spawnOnce "setxkbmap -option \"ctrl:nocaps\"" -- map capslock to ctrl
  spawnOnce "xcape -e 'Shift_L=Escape'"         -- map shift to esc
  spawnOnce "xset r rate 200 50"                -- increase key repeat
  -- touchpad tap to click
  spawnOnce "xinput set-prop \"$(xinput list --name-only | grep Touchpad)\" 'libinput Tapping Enabled' 1"
  spawnOnce "xsetroot -cursor_name left_ptr"    -- no cross cursor on desktop


  -- system tray and icons
  spawnOnce "trayer --edge top --align right --SetDockType true --SetPartialStrut true --expand true --widthtype request --transparent true --alpha 0 --padding 6 --tint 0xff1b1e22 --height 18 --distancefrom right --distance 10 &"
  -- spawnOnce "nm-applet --sm-disable &" -- network manager
  -- spawnOnce "blueberry-tray &"         -- bluetooth
