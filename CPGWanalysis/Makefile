
FC=ifort -extend-source
#FOPT=-g -O0 -check all
FOPT=-g -O2


EXE1=numeval.x
EXE2=roc.x

all: $(EXE1) $(EXE2)


$(EXE1): numeval.F
	${FC} ${FOPT} numeval.F -o $(EXE1)


$(EXE2): ROC.F
	${FC} ${FOPT} ROC.F -o $(EXE2)


clean:
	rm -fr ${EXE1} ${EXE2}
