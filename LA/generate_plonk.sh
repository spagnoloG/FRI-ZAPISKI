#!/bin/sh
sed '6 i \\\usepackage[fontsize=5pt]{fontsize}' la.tex > ./plonk/la-plonk.tex && printf "Success!\n" && exit
printf "Err!\n"
