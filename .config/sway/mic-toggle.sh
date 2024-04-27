#!/bin/bash

sources=$(pactl list sources | grep -E 'Name:' | awk -F ': ' '{print $2}')
echo "${sources}"


for source in "NoiseTorch Microphone for Blue Microphones" "alsa_input.usb-Generic_Blue_Microphones_LT_201028234628D70F0609_111000-00.analog-stereo"
do
    echo "$source"
    pactl set-source-mute "${source}" toggle
done
