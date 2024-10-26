#!/bin/bash

COMPILERS=("gcc" "clang")
FEATURES=("gil" "jit" "normal")

for COMPILER in ${COMPILERS[@]}; do
    for FEATURE in ${FEATURES[@]}; do
        echo "Running ${COMPILER}-${FEATURE} python"
        hyperfine -w 1 "./build/${COMPILER}-${FEATURE}/bin/python3 $1"
    done
done
