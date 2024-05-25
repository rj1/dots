#!/bin/bash

sources=$(pactl list sources | grep -E 'Name:' | awk -F ': ' '{print $2}')

for source in $sources; do
    echo "Toggling mute for source: $source"
    pactl set-source-mute "$source" toggle
done
