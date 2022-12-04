#!/bin/bash

set -e

day=$1

(cd day${day};
 printf "day ${day}:\n"
 for test in 1 2; do
     printf "  test $test:\n"
     for input in input_sample input; do
         if [ ! -f "data/${input}.txt" ] || [ ! -f "expect/${test}/${input}.txt" ]; then
             color="\e[1;35m"
             res="not run"
         else
             if [ "$(${test}.escript data/${input}.txt 2> /dev/null)" = "$(cat expect/${test}/${input}.txt)" ]; then
                 color="\e[1;32m"
                 res="ok"
             else
                 color="\e[1;31m"
                 res="failed"
             fi
         fi
         printf "    $input: $color%s\e[1;0m\n" "$res"
     done
 done
)
