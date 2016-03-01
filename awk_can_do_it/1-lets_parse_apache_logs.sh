#!/bin/bash
cat $1 | grep *.*.*.* | awk '{print $1, $9}'
