#!/bin/bash
cat $1 | awk '{print $1, $9}' | sort | uniq -c | sort -n
