#!/usr/bin/env osascript
use scripting additions

property currVolume : output volume of (get volume settings)
on run argv
    set the text item delimiters to linefeed
    set msg to argv as text
    set volume output volume 100
    say msg
    set volume output volume currVolume
end run
