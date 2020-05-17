      module commons
      implicit none
      integer,parameter::nt1=2000,nt2=2000,nt3=100
      real(8),dimension(nt1)::x1b
      real(8),dimension(nt2)::x2b
      real(8),dimension(nt3)::x3b
      real(8),dimension(nt1+1)::x1a
      real(8),dimension(nt2+1)::x2a
      real(8),dimension(nt3+1)::x3a

      real(8)::x1min,x1max,dx1
      real(8)::x2min,x2max,dx2
      real(8)::x3min,x3max,dx3

      integer,parameter::nI=100
      real(8),dimension(nI)::In,PIn
      real(8)::Imin,Imax,dI

      integer,parameter::nV=200
      real(8),dimension(nV)::Vn,PVn
      real(8)::Vmin,Vmax,dV

      real(8),parameter:: pi=3.14159265358979323846264338327950288419716939
      end module commons


      program numval
      implicit none

      call MakeGrid
      call EvalIn
      call EvalVn
      call Output

      end program numval
!=====================================
      subroutine MakeGrid
      use commons
      implicit none
      integer i,j,k,l

      x1min=0.0d0
      x1max=6.0d0
      dx1=(x1max-x1min)/nt1
      do i=1,nt1+1
        x1a(i)=x1min+(i-1)*dx1
      enddo
      do i=1,nt1
         x1b(i)=0.5d0*(x1a(i)+x1a(i+1))
      enddo

      x2min=0.0d0
      x2max=6.0d0
      dx2=(x2max-x2min)/nt2
      do j=1,nt2+1
        x2a(j)=x2min+(j-1)*dx2
      enddo

      do j=1,nt2
         x2b(j)=0.5d0*(x2a(j)+x2a(j+1))
      enddo

      x3min=0.0d0
      x3max=2.0d0*pi
      dx3=(x3max-x3min)/nt3
      do k=1,nt3+1
        x3a(k)=x3min+(k-1)*dx3
      enddo

      do k=1,nt3
         x3b(k)=0.5d0*(x3a(k)+x3a(k+1))
      enddo

      return
      end subroutine MakeGrid
!=====================================
      subroutine EvalIn
      use commons
      implicit none
      integer i,j,k,l
      real(8)::Indummy
      real(8)::Ptotal
      integer::index

      Imin=0.0d0
      Imax=6.0d0
      dI=(Imax-Imin)/nI
      do l=1,nI
         In(l)=dI*(l-0.5)
      enddo
        PIn(:)=0.0d0

      do j=1,nt2
      do i=1,nt1
         Indummy=(x1b(i)+x2b(j))/2.0d0
         Index  = floor(Indummy/dI)+1
         Index  =min(max(Index,1),nI)
          PIn(Index)= PIn(Index)
     &              + exp(-x1b(i))*exp(-x2b(j))
     &               *(x1a(i+1)-x1a(i))
     &               *(x2a(j+1)-x2a(j))
      enddo
      enddo

      Ptotal=sum(PIn(:))
      PIn(:)=PIn(:)/Ptotal
      return
      end subroutine EvalIn

!=====================================
      subroutine EvalVn
      use commons
      implicit none
      integer i,j,k,l
      real(8)::Vndummy
      real(8)::Ptotal
      integer::index

      Vmin=-6.0d0
      Vmax= 6.0d0
      dV=(Vmax-Vmin)/nV
      do l=1,nV
         Vn(l)=dV*(l-nV/2-0.5)
      enddo
        PVn(:)=0.0d0

      do k=1,nt3
      do j=1,nt2
      do i=1,nt1
         Vndummy=sqrt(x1b(i)*x2b(j))*cos(x3b(k))
         Index  = floor(Vndummy/dV)+1+nV/2
!         write(6,*) "i,j,k",i,j,k
!         write(6,*) "Vn,dV",Vndummy,dV
!         write(6,*) "Index",Index
         Index  =min(max(Index,1),nV)
          PVn(Index)= PVn(Index)
     &              + exp(-x1b(i))*exp(-x2b(j))
     &               *(x1a(i+1)-x1a(i))
     &               *(x2a(j+1)-x2a(j))
     &               *(x3a(k+1)-x3a(k))
!          stop
      enddo
      enddo
      enddo

      Ptotal=sum(PVn(:))
      PVn(:)=PVn(:)/Ptotal
!      stop
      return
      end subroutine EvalVn


!=====================================
      subroutine Output
      use commons
      implicit none
      integer i,j,k,l
      integer,parameter::unitdmp=102
      character*50::path

      path="In.dat"
      open(unit=unitdmp,file=path,status='replace',form='formatted') 
      do l=1,nI
         write(unitdmp,*) In(l),PIn(l)
      enddo
      close(unitdmp)

      path="Vn.dat"
      open(unit=unitdmp,file=path,status='replace',form='formatted') 
      do l=1,nV
         write(unitdmp,*) Vn(l),PVn(l)
      enddo
      close(unitdmp)

      return
      end subroutine Output
