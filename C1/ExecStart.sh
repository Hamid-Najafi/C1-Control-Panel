amixer -c 1 sset 'Speaker' 100 > /dev/null 2>&1
amixer -c 1 sset 'Mic' 68 > /dev/null 2>&1

amixer -c 2 sset 'Speaker' 100 > /dev/null 2>&1
amixer -c 2 sset 'Mic' 68 > /dev/null 2>&1

/home/c1tech/C1-Control-Panel/Panel/panel -platform eglfs