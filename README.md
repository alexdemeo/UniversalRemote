#  My attempt at a universal remote program for split _Roku TV + RaspberryPi HDMI-CEC_ setup

## WIP

Roku commands send over Roku over built-in External Control Protocol:\
&nbsp;&nbsp;&nbsp;&nbsp;https://developer.roku.com/docs/developer-program/debugging/external-control-api.md

CEC commands sent to Rasperry Pi over network running:\
&nbsp;&nbsp;&nbsp;&nbsp;https://robbie.io/cec-web/

Requires hardcoding Roku and Pi IP address into the program.

TODO: Rather than hardcoding local devices, query Roku TV for devices on network
            & do this for CEC too, even though Roku is just doing the same thing under the hood
