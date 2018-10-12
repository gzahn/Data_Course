#!/bin/bash

x=`echo $1`
y=`awk '{s+=$1} END {print s}' $1`

paste <(echo "$x") <(echo "$y")
