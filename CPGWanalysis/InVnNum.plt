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

inpIn0="Isn00.dat"
inpIn1="Isn01.dat"
inpIn2="Isn02.dat"
inpIn3="Isn03.dat"
inpIn4="Isn04.dat"
inpIn5="Isn05.dat"

inpVn0="Vsn00.dat"
inpVn1="Vsn01.dat"
inpVn2="Vsn02.dat"
inpVn3="Vsn03.dat"
inpVn4="Vsn04.dat"
inpVn5="Vsn05.dat"


set xlabel "x"

set ylabel "probability"

set log y
if(pdfflag==1)set output "InNum.pdf"

plot NaN notitle \
, inpIn0 w l lw 2 \
, inpIn1 w l lw 2 \
, inpIn2 w l lw 2 \
, inpIn3 w l lw 2 \
, inpIn4 w l lw 2 \
, inpIn5 w l lw 2 \

if(pdfflag==1)set output "VnNum.pdf"

plot NaN notitle \
, inpVn0 w l lw 2 \
, inpVn1 w l lw 2 \
, inpVn2 w l lw 2 \
, inpVn3 w l lw 2 \
, inpVn4 w l lw 2 \
, inpVn5 w l lw 2 \


if(pdfflag==1)set output "InVnNum.pdf"
set xrange [-6:6]

plot NaN notitle \
, inpIn0 w l lw 2 \
, inpIn1 w l lw 2 \
, inpIn2 w l lw 2 \
, inpVn0 w l lw 2 \
, inpVn1 w l lw 2 \
, inpVn2 w l lw 2 \



if(pdfflag==1)set output "InVnNumS4.pdf"
unset log y
set xrange [-8:8]

set key left top

set yrange [1e-5:1]

plot NaN notitle \
, inpIn4 w l ls 12 title "I_{s+n},s=4"\
, inpVn4 w l ls 22 title "V_{s+n},s=4"\
, inpIn0 w l ls 13 title "I_{n}"\
, inpVn0 w l ls 23 title "V_{n}"\


if(pdfflag==1)set output "InVnNumS4zoom.pdf"
set format y "10^{%L}"
set log y
set xrange [-12:12]
rep

reset
if(pdfflag==1)set terminal pop


reset

