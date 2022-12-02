#!/bin/bash

set -e

day=$1

(cd day${day};
 printf "day ${day}:\n"
 for test in 1 2; do
     if [ "$(${test}.escript)" = "$(cat expect/${test})" ]; then
         color="\e[1;32m"
         res="ok"
     else
         color="\e[1;31m"
         res="failed"
     fi
     printf "  test $test: $color%s\e[1;0m\n" "$res"
 done
)
