#!/bin/bash
# Claude Code status line: model | context% | 5h% | 7d% (pace%)
#  - ctx: neutral
#  - 5h : neutral < 60, yellow >= 60, red >= 80
#  - 7d : used% colored by pace (RED if used% > % of the 7-day window elapsed
#         since reset, GREEN if on/under pace), followed by that elapsed
#         (time-proportional) baseline in dim brackets for comparison.
in=$(cat)
get() { printf '%s' "$in" | jq -r "$1 // empty" 2>/dev/null; }

model=$(get '.model.display_name'); model=${model:-Claude}
ctx=$(get '.context_window.used_percentage')
h5=$(get '.rate_limits.five_hour.used_percentage')
d7=$(get '.rate_limits.seven_day.used_percentage')
d7reset=$(get '.rate_limits.seven_day.resets_at')

RESET='\033[0m'; DIM='\033[2m'
neutral() { if [ -z "$1" ]; then printf -- '--'; else printf '%.0f%%' "$1"; fi; }

# threshold-colored percent: $1=value  $2=warn(yellow>=)  $3=crit(red>=)
thresh() {
  local v=$1 warn=$2 crit=$3 col
  [ -z "$v" ] && { printf -- '--'; return; }
  if   awk "BEGIN{exit !($v>=$crit)}"; then col='\033[1;31m'
  elif awk "BEGIN{exit !($v>=$warn)}"; then col='\033[33m'
  else printf '%.0f%%' "$v"; return; fi
  printf '%b%.0f%%%b' "$col" "$v" "$RESET"
}

week() {
  [ -z "$d7" ] && { printf -- '--'; return; }
  [ -z "$d7reset" ] && { printf '%.0f%%' "$d7"; return; }
  local now elapsed col
  now=$(date +%s)
  elapsed=$(awk "BEGIN{e=(604800-($d7reset-$now))/604800*100; if(e<0)e=0; if(e>100)e=100; print e}")
  if awk "BEGIN{exit !($d7 > $elapsed)}"; then col='\033[1;31m'; else col='\033[32m'; fi
  printf '%b%.0f%%%b %b(%.0f%%)%b' "$col" "$d7" "$RESET" "$DIM" "$elapsed" "$RESET"
}

printf '%s │ ctx %s │ 5h %s │ 7d %s' \
  "$model" "$(neutral "$ctx")" "$(thresh "$h5" 60 80)" "$(week)"
