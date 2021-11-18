import XMonad

import qualified XMonad.StackSet as W

-- Utils
import XMonad.Util.EZConfig
import XMonad.Util.Ungrab
import XMonad.Util.Loggers
import XMonad.Util.SpawnOnce

-- Hooks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.Place

-- Layouts
import XMonad.Layout.Renamed as R
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowNavigation
import XMonad.Layout.BoringWindows
import XMonad.Layout.ThreeColumns
import XMonad.Layout.Tabbed
import XMonad.Layout.NoBorders
import XMonad.Layout.Column
import XMonad.Layout.Simplest
import XMonad.Layout.ResizableTile

-- Actions
import XMonad.Actions.WithAll
import XMonad.Actions.FloatKeys
import XMonad.Actions.CycleWS

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
myWorkSpaces = ["\xf121","\xf0b1","\xf11b","\xf086","\xf001","\xf26c","7","8","\xf2d2"]
myWorkspaceIndices =  M.fromList $ zip myWorkSpaces [1..]

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
  [ ("M-w"        , spawn "firefox &")
  , ("M-f"        , spawn "pcmanfm &")
  , ("M-<Return>" , spawn $ myTerminal ++ " -e tmux new -As 'base' &")
  , ("M-S-p"      , spawn "pscircle-draw")

  -- clear primary clipboard
  , ("M-a", spawn "clear-primary")

  -- rofi menus
  , ("M-z d", spawn "rofi -show drun")
  , ("M-z z", spawn "rofi -show run")
  , ("M-z w", spawn "rofi -show window")
  , ("M-z e", spawn "emoji")
  , ("M-c"  , spawn "dunstctl context")   -- dunst context menu

  -- window management
  , ("M-q", kill)

  -- window movement
  , ("M-l", sendMessage $ Go R)
  , ("M-h", sendMessage $ Go L)
  , ("M-k", sendMessage $ Go U)
  , ("M-j", sendMessage $ Go D)

  -- sublayouts
  , ("M-S-a h", sendMessage $ pullGroup L)
  , ("M-S-a l", sendMessage $ pullGroup R)
  , ("M-S-a k", sendMessage $ pullGroup U)
  , ("M-S-a j", sendMessage $ pullGroup D)
  
  , ("M-C-u", withFocused (sendMessage . UnMerge))

  , ("M-C-a h", onGroup W.focusUp')
  , ("M-C-a l", onGroup W.focusDown')

  -- moving windows
  , ("M-C-l", sendMessage $ Swap R)
  , ("M-C-h", sendMessage $ Swap L)
  , ("M-C-k", sendMessage $ Swap U)
  , ("M-C-j", sendMessage $ Swap D)
  -- manage floating windows
  -- move around
  , ("M-C-S-h", withFocused (keysMoveWindow (-10,0)))
  , ("M-C-S-l", withFocused (keysMoveWindow (10,0)))
  , ("M-C-S-k", withFocused (keysMoveWindow (0,-10)))
  , ("M-C-S-j", withFocused (keysMoveWindow (0,10)))
  -- resize
  , ("M-C-S-<Right>", withFocused (keysResizeWindow (10,0) (0,0)))
  , ("M-C-S-<Left>", withFocused (keysResizeWindow (-10,0) (0,0)))
  , ("M-C-S-<Up>", withFocused (keysResizeWindow (0,-10) (0,0)))
  , ("M-C-S-<Down>", withFocused (keysResizeWindow (0,10) (0,0)))

  -- resize tiled windows
  , ("M-=", sendMessage Expand)
  , ("M--", sendMessage Shrink)
  , ("M-S-=", sendMessage MirrorExpand)
  , ("M-S--", sendMessage MirrorShrink)

  -- switching workspaces
  , ("M-s l", nextWS)
  , ("M-s h", prevWS)

  -- volume controls
  , ("<XF86AudioMute>"        , spawn "vol mute")
  , ("<XF86AudioLowerVolume>" , spawn "vol down")
  , ("<XF86AudioRaiseVolume>" , spawn "vol up")

  -- brightness controls
  , ("<XF86MonBrightnessUp>"    , spawn "CHANGE_AMOUNT=10 brightness up")
  , ("<XF86MonBrightnessDown>"  , spawn "CHANGE_AMOUNT=10 brightness down")
  , ("S-<XF86MonBrightnessUp>"  , spawn "brightness up")
  , ("S-<XF86MonBrightnessDown>", spawn "brightness down")

  -- screenshot
  , ("<Print>", spawn "screenshot full")
  , ("M-<Print>", spawn "screenshot")

  
  -- restart in place
  , ("M-r", spawn "xmonad --recompile; killall xmobar; xmonad --restart")

  -- Power Menu
  , ("M-<Delete>", spawn "powermenu")
  ]
  ++
  -- Move all windows in the current workspace to target workspace
  -- M-C-S-[workspace key]
  [("M-C-S-"++ show k, withAll' $ W.shiftWin i)
    | (i,k) <- zip myWorkSpaces [1 .. 9]]

myManageHook :: Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  [ className =? "Pavucontrol"        --> doCenterFloat
  , className =? "feh"                --> doFloat 
  , className =? "Gcolor3"            --> doCenterFloat 
  , title     =? "Picture-in-Picture" --> doFloat
  , className =? "Blueman-manager"    --> doFloat
  , className =? "Xmessage"           --> doCenterFloat
  , isFullscreen                      --> doFullFloat
  , isDialog                          --> doFloat
  ]

myLayout = windowNavigation $ boringWindows $ smartBorders . avoidStruts $ (tiled ||| cols ||| tabs ||| zen)  
  where
    zen          = renamed [ R.Replace "zen" ] 
                   $ Full

    cols         = renamed [ R.Replace "col" ] 
                   $ Mirror 
                   $ Column colsRatio
    colsRatio    = 1.0

    tiled        = renamed [ R.Replace "mst"] 
                   $ addTabs shrinkText myTabTheme
                   $ subLayout [] Simplest
                   $ ResizableTall nmaster delta ratio []
    nmaster      = 1
    delta        = 3/100
    ratio        = 1/2

    tabs         = renamed [ R.Replace "tab" ]
                   $ tabbedBottom shrinkText myTabTheme

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
  , ppTitle             = green . ppWindow
  , ppLayout            = lowWhite
  , ppCurrent           = wrap (blue "[") (blue "]") . yellow
  , ppHidden            = white . wrap " " " " . clickable
  , ppHiddenNoWindows   = lowWhite . wrap " " " " . clickable
  , ppUrgent            = red . wrap (yellow "!") (yellow "!")
  , ppOrder             = \[ws, l, t]-> [ws, l, t]
  }
  where
    ppWindow :: String -> String
    ppWindow =  shorten 65

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
  -- dex to execute .desktop files in autostart.
  spawnOnce "dex -a -s /etc/xdg/autostart/:~/.config/autostart/"
