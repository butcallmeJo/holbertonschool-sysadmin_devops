#!/bin/bash

while read -u10 line; do
    echo $line
done 10< $1
