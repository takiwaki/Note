
FC=ifort -extend-source
#FOPT=-g -O0 -check all
FOPT=-g -O2

EXE1=numeval.x
EXE2=roc.x

all: ROC.pdf InVnNumS4.pdf

ROC.pdf: ROC01.dat ROC.plt
	gnuplot ROC.plt

InVnNumS4.pdf: Isn04.dat InVnNum.plt
	gnuplot InVnNum.plt

ROC01.dat: Isn01.dat $(EXE2) Isn00.dat
	./$(EXE2)

Isn01.dat: $(EXE1)
	./$(EXE1)

Isn00.dat: $(EXE1)
	./$(EXE1)

$(EXE1): numeval.F
	${FC} ${FOPT} numeval.F -o $(EXE1)


$(EXE2): ROC.F
	${FC} ${FOPT} ROC.F -o $(EXE2)

clean:
	rm -fr ${EXE1} ${EXE2}
