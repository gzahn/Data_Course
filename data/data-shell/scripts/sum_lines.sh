echo $1
awk '{s+=$1} END {print s}' $1
