## DISK
hdd() {
  hdd="$(df -h | awk 'NR==4{print $3, $5}')"
  echo -e "$hdd"
}
## RAM
mem() {
  mem=`free | awk '/Mem/ {printf "%dM/%dM\n", $3 / 1024.0, $2 / 1024.0 }'`
  echo -e "$mem"
}
## CPU
cpu() {
  read cpu a b c previdle rest < /proc/stat
  prevtotal=$((a+b+c+previdle))
  sleep 0.5
  read cpu a b c idle rest < /proc/stat
  total=$((a+b+c+idle))
  cpu=$((100*( (total-prevtotal) - (idle-previdle) ) / (total-prevtotal) ))
  echo -e "$cpu%"
}
## VOLUME
vol() {
    vol=`pactl list sinks | grep Volume | head -n1 | awk '{print $5}'`
    echo -e "$vol"
}

## BATTERY
battery_status() {
    cap=`cat /sys/class/power_supply/BAT0/capacity`
    stat=`cat /sys/class/power_supply/BAT0/status`
	echo -e "$cap% - $stat"
}
SLEEP_SEC=3
#loops forever outputting a line every SLEEP_SEC secs
while :; do
    echo -n "+@fg=1; +@fn=1;💻+@fn=0; $(cpu) +@fg=0; | "
	echo -n "+@fg=2; +@fn=1;💾+@fn=0; $(mem) +@fg=0; | "
	echo -n "+@fg=3; +@fn=1;💿+@fn=0; $(hdd) +@fg=0; | "
	echo -n "+@fg=4; +@fn=1;+@fn=0; $(battery_status) +@fg=0; | "
	echo "+@fg=5; +@fn=1;🔈+@fn=0; $(vol) +@fg=0; |"
	sleep $SLEEP_SEC
done
