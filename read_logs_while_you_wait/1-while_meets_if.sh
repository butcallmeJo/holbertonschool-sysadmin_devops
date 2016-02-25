#!/bin/bash

while read -u10 line; do
    if grep -q HEAD "$1"; then
	echo $line | grep HEAD
    fi
done 10< $1
