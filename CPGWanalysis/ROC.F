      module rocmod
      implicit none
      real(8),parameter:: pi=3.14159265358979323846264338327950288419716939

      integer::nI
      real(8),dimension(:),allocatable::In,PIn
      real(8),dimension(:),allocatable::Isn,PIsn
      real(8)::Imin,Imax,dI

      integer::nV
      real(8),dimension(:),allocatable::Vn,PVn
      real(8),dimension(:),allocatable::Vsn,PVsn
      real(8)::Vmin,Vmax,dV

      integer::nT
      real(8),dimension(:),allocatable::TH
      real(8),dimension(:),allocatable::IFA,IDE
      real(8),dimension(:),allocatable::VFA,VDE

      end module rocmod

      program roc
      implicit none
      integer:: is
      real(8)::s

         call NoiseDataRead
      do is=1,10
         call DataRead(is)
         call EvalROC
         call Output(is)
      enddo

      end program roc

      subroutine NoiseDataRead
      use rocmod
      implicit none
      character:: dummy
      character(50):: path
      integer::is
      integer,parameter::unitdmp=102
      integer:: m
      logical,save:: is_initd
      data is_initd /.false./

      is=0

      write(path,'(a3,i2.2,a4)')"Isn,",is,".dat"
      open(unit=unitdmp,file=path,status='old',form='formatted') 
      read(unitdmp,'(a1,1x,i10.0)')dummy,nI
      if(.not. is_initd) allocate(In(nI),PIn(nI))
      do m=1,nI
         read(unitdmp,*) In(m),PIn(m)
      enddo
      close(unitdmp)
      dI=In(2)-In(1)
      Imin=0.0d0
      Imax=In(nI)+0.5d0*dI

      write(path,'(a3,i2.2,a4)')"Vsn,",is,".dat"
      open(unit=unitdmp,file=path,status='old',form='formatted')
      read(unitdmp,'(a1,1x,i10.0)')dummy,nV
      if(.not. is_initd) allocate(Vn(nV),PVn(nV)) 
      do m=1,nV
         read(unitdmp,*) Vn(m),PVn(m)
      enddo
      close(unitdmp)

      dV=Vn(2)-Vn(1)
      Vmin=Vn(1)-0.5d0*dI
      Vmax=Vn(nV)+0.5d0*dI
      is_initd =.true.
      return
      end subroutine NoiseDataRead


      subroutine DataRead(is)
      use rocmod
      implicit none
      integer,intent(in)::is
      character:: dummy
      character(50):: path
      integer,parameter::unitdmp=102
      integer:: m
      logical,save:: is_initd
      data is_initd /.false./

      write(path,'(a3,i2.2,a4)')"Isn,",is,".dat"
      open(unit=unitdmp,file=path,status='old',form='formatted') 
      read(unitdmp,'(a1,1x,i10.0)')dummy,nI
      if(.not. is_initd)allocate(Isn(nI),PIsn(nI))
      do m=1,nI
         read(unitdmp,*) Isn(m),PIsn(m)
      enddo
      close(unitdmp)
      Imin=Isn(1)
      Imax=Isn(nI)

      write(path,'(a3,i2.2,a4)')"Vsn,",is,".dat"
      open(unit=unitdmp,file=path,status='old',form='formatted')
      read(unitdmp,'(a1,1x,i10.0)')dummy,nV
      if(.not. is_initd)allocate(Vsn(nV),PVsn(nV)) 
      do m=1,nV
         read(unitdmp,*) Vsn(m),PVsn(m)
      enddo
      close(unitdmp)

      Vmin=Vsn(1)
      Vmax=Vsn(nV)
      is_initd =.true.
      return
      end subroutine DataRead

      subroutine EvalRoc
      use rocmod
      implicit none
      integer::m
      logical,save:: is_initd
      data is_initd /.false./

      nT=nI
      if(.not. is_initd)allocate( TH(0:nT))
      if(.not. is_initd)allocate(IFA(0:nT),IDE(0:nT))
      if(.not. is_initd)allocate(VFA(0:nT),VDE(0:nT))

       TH(0)=In(nI)
      IFA(0)=0.0d0
      VFA(0)=0.0d0
      IDE(0)=0.0d0
      VDE(0)=0.0d0
      do m=1,nT
          TH(m) = In(nI-m+1)
         IFA(m) = IFA(m-1) +  PIn (nI-m+1)          *dI
         VFA(m) = VFA(m-1) + (PVn (nV-m+1)+ PVn (m))*dV
         IDE(m) = IDE(m-1) +  PIsn(nI-m+1)          *dI
         VDE(m) = VDE(m-1) + (PVsn(nV-m+1)+ PVsn(m))*dV
      enddo

      is_initd =.true.

      return
      end subroutine EvalRoc

      subroutine Output(is)
      use rocmod
      implicit none
      integer,intent(in)::is
      character(50):: path
      integer,parameter::unitdmp=102
      integer::m

      write(path,'(a3,i2.2,a4)')"ROC,",is,".dat"
      open(unit=unitdmp,file=path,status='replace',form='formatted') 
      write(unitdmp,'(a1,1x,i10.0)')"#",nT
      do m=1,nT
         write(unitdmp,'(5(1x,E15.6e3))') TH(m),IFA(m),IDE(m),VFA(m),VDE(m)
      enddo
      close(unitdmp)

      return
      end subroutine Output
