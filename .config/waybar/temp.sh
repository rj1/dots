#!/bin/sh
cpu=$(sensors | grep "Tctl" | awk '{print $2}' | sed 's/+//;s/\.0//;s/°C/°/')
gpu=$(sensors | grep "edge" | awk '{print $2}' | sed 's/+//;s/\.0//;s/°C/°/')
echo "cpu: ${cpu} gpu: ${gpu} |"
