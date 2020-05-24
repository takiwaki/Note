reset

pdfflag=1
if(pdfflag==1)set terminal push
if(pdfflag==1)set terminal pdfcairo dash enhanced
if(pdfflag==1)set encoding utf8

set style line 11 lt 1 lw 6 lc rgb "#ff2800" # universal design red 
set style line 12 lt 2 lw 6 lc rgb "#ff2800" # universal design red 
set style line 13 lt 3 lw 6 lc rgb "#ff2800" # universal design red 

set style line 21 lt 1 lw 6 lc rgb "#0041ff" # universal design blue
set style line 22 lt 2 lw 6 lc rgb "#0041ff" # universal design blue
set style line 23 lt 3 lw 6 lc rgb "#0041ff" # universal design blue

set style line 31 lt 3 lw 2 lc rgb "#35a16B" # universal design green
set style line 32 lt 2 lw 2 lc rgb "#35a16B" # universal design green
set style line 33 lt 1 lw 2 lc rgb "#35a16B" # universal design green
set style line 34 lt 4 lw 2 lc rgb "#35a16B" # universal design green

set style line 91 lt 1 lw 6 lc rgb "black" # 
set style line 92 lt 2 lw 6 lc rgb "black" # 
set style line 93 lt 3 lw 6 lc rgb "black" #

inpROC1="ROC01.dat"
inpROC2="ROC02.dat"
inpROC3="ROC03.dat"
inpROC4="ROC04.dat"
inpROC5="ROC05.dat"
inpROC6="ROC06.dat"


set xlabel "False alarm probability"
unset log x

set xrange [1e-6:0.05]

set ylabel "Detection Efficiency"

unset log y

set yrange [0.3:1]
if(pdfflag==1)set output "ROC.pdf"
set key right bottom

plot NaN notitle \
, inpROC3 u 2:3 w l ls 13 notitle "I_{s+n},s=3"\
, inpROC3 u 4:5 w l ls 23 notitle "V_{s+n},s=3"\
, inpROC4 u 2:3 w l ls 12 notitle "I_{s+n},s=4"\
, inpROC4 u 4:5 w l ls 22 notitle "V_{s+n},s=4"\
, inpROC5 u 2:3 w l ls 11 title "I_{s+n}"\
, inpROC5 u 4:5 w l ls 21 title "V_{s+n}"\
, NaN w l ls 91 title "s=5" \
, NaN w l ls 92 title "s=4" \
, NaN w l ls 93 title "s=3" \


if(pdfflag==1)set output "ROCcolor.pdf"
set log x
unset log y
set cbrange [3:7]

set palette define (3.0 "black",4.0 "blue", 4.5 "cyan", 5.0 "green", 6.0 "red", 7.0 "yellow")

set label 6 "s=6" at first 1.0e-5,first 0.6
set label 5 "s=5" at first 1.0e-4,first 0.6
set label 4 "s=4" at first 3.0e-3,first 0.6
set label 3 "s=3" at first 2.5e-2,first 0.6

plot NaN notitle \
, inpROC3 u 2:3:1 w l lt 1 lw 8 lc palette notitle "I_{s+n},s=3"\
, inpROC3 u 4:5:1 w l lt 2 lw 8 lc palette notitle "V_{s+n},s=3"\
, inpROC4 u 2:3:1 w l lt 1 lw 8 lc palette notitle "I_{s+n},s=4"\
, inpROC4 u 4:5:1 w l lt 2 lw 8 lc palette notitle "V_{s+n},s=4"\
, inpROC5 u 2:3:1 w l lt 1 lw 8 lc palette notitle "I_{s+n}"\
, inpROC5 u 4:5:1 w l lt 2 lw 8 lc palette notitle "V_{s+n}"\
, inpROC6 u 2:3:1 w l lt 1 lw 8 lc palette notitle "I_{s+n}"\
, inpROC6 u 4:5:1 w l lt 2 lw 8 lc palette notitle "V_{s+n}"\
, NaN w l lw 8 lt 1 lc rgb "black" title "I_{s+n}"  \
, NaN w l lw 8 lt 2 lc rgb "black" title "V_{s+n}"  \

reset
if(pdfflag==1)set terminal pop



