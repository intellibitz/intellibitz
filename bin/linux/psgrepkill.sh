#!/bin/bash
if [ -n "$1" ]; then
	ps aux | grep -ie "$1" | grep -v grep | awk '{print $2}' | xargs kill -9
fi
