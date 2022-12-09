#!/bin/bash

set -e

day=$1

(cd day${day};
 printf "day ${day}:\n"
 for test in 1 2; do
     printf "  test $test:\n"
     for input in input_sample input; do
         if [ ! -f "expect/${test}/${input}.txt" ]; then
             color="\e[1;35m"
             res="not run"
         else
             if [ -f "data/${input}.txt" ]; then
                 input_file="${input}"
             fi
             if [ -f "data/${input}_${test}.txt" ]; then
                 input_file="${input}_${test}"
             fi
             if [ -z "$input_file" ]; then
                color="\e[1;35m"
                res="not run"
             else
                 if [ "$(${test}.escript data/${input_file}.txt 2> /dev/null)" = "$(cat expect/${test}/${input}.txt)" ]; then
                     color="\e[1;32m"
                     res="ok"
                 else
                     color="\e[1;31m"
                     res="failed"
                 fi
             fi
         fi
         printf "    $input: $color%s\e[1;0m\n" "$res"
     done
 done
)
