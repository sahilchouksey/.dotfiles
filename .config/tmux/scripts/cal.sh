#!/bin/bash

ALERT_IF_IN_NEXT_MINUTES=10
ALERT_POPUP_BEFORE_SECONDS=10
NERD_FONT_FREE="󱁕 "
NERD_FONT_MEETING="󰤙"

get_next_meeting() {
    next_meeting=$(khal list --format "{start-time} {end-time} {title}" --day-format "" now eod --exclude-calendar "training,sahilchouksey185@gmail.com" | head -n 1)
}

parse_result() {
    IFS=' ' read -r start_time end_time title <<< "$1"
    time=$start_time
    end_time=$end_time
}

calculate_times(){
    epoc_meeting=$(date -d "$time" +%s)
    epoc_now=$(date +%s)
    epoc_diff=$((epoc_meeting - epoc_now))
    minutes_till_meeting=$((epoc_diff/60))
}

display_popup() {
    tmux display-popup \
        -S "fg=#eba0ac" \
        -w50% \
        -h50% \
        -d '#{pane_current_path}' \
        -T meeting \
        khal list --format "{start-time} {end-time} {title}\n{description}\nAttendees: {attendees}" --day-format "" now eod --exclude-calendar "training"
}

print_tmux_status() {
    if [[ $minutes_till_meeting -lt $ALERT_IF_IN_NEXT_MINUTES \
        && $minutes_till_meeting -gt -60 ]]; then
        echo "$NERD_FONT_MEETING $time $title ($minutes_till_meeting minutes)"
    else
        echo "$NERD_FONT_FREE"
    fi
    if [[ $epoc_diff -gt $ALERT_POPUP_BEFORE_SECONDS && $epoc_diff -lt $((ALERT_POPUP_BEFORE_SECONDS+10)) ]]; then
        display_popup
    fi
}

main() {
    get_next_meeting
    parse_result "$next_meeting"
    calculate_times
    print_tmux_status
}

