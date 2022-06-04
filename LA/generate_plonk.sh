#!/bin/sh

function throw_err {
    printf "Err!\n"
    exit 1
}

sed '6 i \\\usepackage[fontsize=5pt]{fontsize}' la.tex > ./plonk/la-plonk.tex || throw_err
sed -i '14s/3/4/' ./plonk/la-plonk.tex || throw_err

printf "Success!\n"
