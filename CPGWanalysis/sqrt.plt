reset

pdfflag=1
if(pdfflag==1)set terminal push
if(pdfflag==1)set terminal pdfcairo dash enhanced
if(pdfflag==1)set encoding utf8

set style line 11 lt 1 lw 6 lc rgb "#ff2800" # universal design red 
set style line 12 lt 2 lw 6 lc rgb "#ff2800" # universal design red 

set style line 21 lt 1 lw 6 lc rgb "#0041ff" # universal design blue
set style line 22 lt 2 lw 6 lc rgb "#0041ff" # universal design blue

set style line 31 lt 3 lw 2 lc rgb "#35a16B" # universal design green
set style line 32 lt 2 lw 2 lc rgb "#35a16B" # universal design green
set style line 33 lt 1 lw 2 lc rgb "#35a16B" # universal design green
set style line 34 lt 4 lw 2 lc rgb "#35a16B" # universal design green

set style line 91 lt 1 lw 6 lc rgb "black" # 
set style line 92 lt 2 lw 6 lc rgb "black" #

if(pdfflag==1)set output "sqrtInVn.pdf"

f(x)=abs(x)**3*exp(-2.0*x**2)*8  # 被積分関数
g(x)=abs(x)   *exp(-2.0*x**2)*2  # 被積分関数

x0=0   # 積分区間の下限
x1=4   # 積分区間の上限
N=1000   # 積分区間の分割数

set xlabel "x"
set xrange [x0:x1]
set samples N+1

set ylabel "probability"
set yrange [0:1.3]
set key right bottom

set grid

y1=(1.0-(1.0-0.682689492137086)/2.0)
y2=(1.0-(1.0-0.954499736103642)/2.0)
y3=(1.0-(1.0-0.997300203936740)/2.0)
y4=(1.0-(1.0-0.999936657516334)/2.0)

plot lastx=0.0,lasty=0.5,integ = 0.0,\
     "+" using 1:(f($1)) w l ls 12 title "I_n^{1/2}", \
     "+" using 1:(dx=$1-lastx, \
     integ = ($0==0 ? 0.0 : integ+dx*(f($1)+lasty)*0.5), \
     lastx=$1, \
     lasty=f($1), \
     integ) w l ls 11 notitle "integral"\
    ,lastx=0.0,lasty=0.0,integ = 0.0,\
     "+" using 1:(g($1)) w l ls 22 title "V_n^{1/2}", \
     "+" using 1:(dx=$1-lastx, \
     integ = ($0==0 ? 0.0 : integ+dx*(g($1)+lasty)*0.5), \
     lastx=$1, \
     lasty=g($1), \
     integ+0.5) w l ls 21 notitle "integral"\
    , NaN title "distribution" w l ls 92 \
    , NaN title "cumulative" w l ls 91 \
    , y1 title "1-sigma" w l ls 31

if(pdfflag==1)set output "sqrtInVnzoom.pdf"

x0=0   # 積分区間の下限
x1=5   # 積分区間の上限
N=1000   # 積分区間の分割数

set key left bottom

set xrange [x0:3]

set log y
set yrange [1e-5:1]
set format y "10^{%L}"

plot lastx=0.0,lasty=0.5,integ = 0.0,\
     "+" using 1:(f($1)) w l ls 12 title "I_n^{1/2}", \
     "+" using 1:(dx=$1-lastx, \
     integ = ($0==0 ? 0.0 : integ+dx*(f($1)+lasty)*0.5), \
     lastx=$1, \
     lasty=f($1), \
     1.0-integ) w l ls 11 notitle "integral"\
    ,lastx=0.0,lasty=0.0,integ = 0.0,\
     "+" using 1:(g($1)) w l ls 22 title "V_n^{1/2}", \
     "+" using 1:(dx=$1-lastx, \
     integ = ($0==0 ? 0.0 : integ+dx*(g($1)+lasty)*0.5), \
     lastx=$1, \
     lasty=g($1), \
     0.5-integ) w l ls 21 notitle "integral"\
    , NaN title "distribution" w l ls 92 \
    , NaN title "1-cumulative" w l ls 91 \
    , 1.0-y1 title "1{/Symbol s}" w l ls 31 \
    , 1.0-y2 title "2{/Symbol s}" w l ls 32 \
    , 1.0-y3 title "3{/Symbol s}" w l ls 33 \

reset
if(pdfflag==1)set terminal pop
