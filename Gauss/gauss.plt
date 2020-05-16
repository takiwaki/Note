reset

pdfflag=1
if(pdfflag==1)set terminal push
if(pdfflag==1)set terminal pdfcairo enhanced
if(pdfflag==1)set encoding utf8

set style line 11 lt 1 lw 6 lc rgb "#ff2800" # universal design red 
set style line 12 lt 2 lw 6 lc rgb "#ff2800" # universal design red 

set style line 21 lt 1 lw 6 lc rgb "#0041ff" # universal design blue
set style line 21 lt 2 lw 6 lc rgb "#0041ff" # universal design blue

set style line 3 lt 1 lw 2 lc rgb "#35a16B" # universal design green

set style line 91 lt 1 lw 6 lc rgb "black" # 
set style line 92 lt 2 lw 6 lc rgb "black" #

if(pdfflag==1)set output "gauss.pdf"

f(x)=exp(-0.5*x**2)/sqrt(2.0*pi)  # 被積分関数
g(x)=abs(x)*exp(-(x)**2)/1.0  # 被積分関数

x0=0   # 積分区間の下限
x1= 4   # 積分区間の上限
N=1000   # 積分区間の分割数

set xlabel "x"
set xrange [x0:x1]
set samples N+1

set ylabel "probability"
set yrange [0:1]
set key right bottom

set grid

y1=1.0-15.865/100.0

plot lastx=0.0,lasty=0.5,integ = 0.0,\
     "+" using 1:(f($1)) w l ls 12 title "exp(-x^2/2)", \
     "+" using 1:(dx=$1-lastx, \
     integ = ($0==0 ? 0.0 : integ+dx*(f($1)+lasty)*0.5), \
     lastx=$1, \
     lasty=f($1), \
     integ+0.5) w l ls 11 notitle "integral"\
    ,lastx=0.0,lasty=0.0,integ = 0.0,\
     "+" using 1:(g($1)) w l ls 21 title "x*exp(-x^2)", \
     "+" using 1:(dx=$1-lastx, \
     integ = ($0==0 ? 0.0 : integ+dx*(g($1)+lasty)*0.5), \
     lastx=$1, \
     lasty=g($1), \
     integ+0.5) w l ls 21 notitle "integral"\
    , NaN title "distribution" w l ls 92 \
    , NaN title "Cumulative distribution" w l ls 91 \
    , y1 title "1-sigma" w l ls 3


reset
if(pdfflag==1)set terminal pop