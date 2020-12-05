#!/bin/bash

# do the differnt runs

multiplied=1

result="$(./bash-3a.sh ./input-3.txt 1 1)"
echo "$result"
multiplied=$(($multiplied*${result##* }))
result="$(./bash-3a.sh ./input-3.txt 3 1)"
echo "$result"
multiplied=$(($multiplied*${result##* }))
result="$(./bash-3a.sh ./input-3.txt 5 1)"
echo "$result"
multiplied=$(($multiplied*${result##* }))
result="$(./bash-3a.sh ./input-3.txt 7 1)"
echo "$result"
multiplied=$(($multiplied*${result##* }))
result="$(./bash-3a.sh ./input-3.txt 1 2)"
echo "$result"
multiplied=$(($multiplied*${result##* }))
echo "Result is: $multiplied"


