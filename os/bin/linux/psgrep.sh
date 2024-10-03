#!/bin/bash
if [ -n "$1" ]; then
	ps aux | grep "$1" | awk '{print $2}' | wc ; pgrep "$1" | wc ; ps -elf | grep "$1" | wc
	ps aux | grep -ie "$1" | grep -v ps | awk '{print $2}'
fi
