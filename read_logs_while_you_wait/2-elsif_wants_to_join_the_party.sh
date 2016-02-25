#!/bin/bash

countHEAD=0
countGET=0
while read line; do
    if [[ $line == *'HEAD'* ]]; then
	countHEAD=$((countHEAD+1))
    elif [[ $line == *'GET'* ]]; then
	countGET=$((countGET+1))
    fi
done < $1

echo $countHEAD
echo $countGET
