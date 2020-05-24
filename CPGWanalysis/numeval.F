      module commons
      implicit none
      real(8),parameter:: pi=3.14159265358979323846264338327950288419716939
      real(8),parameter:: pi2=2.0d0*pi

      integer,parameter::nt1=2000,nt2=2000,nt3=100,nt4=100
      real(8),dimension(nt1)::x1b
      real(8),dimension(nt2)::x2b
      real(8),dimension(nt3)::x3b
      real(8),dimension(nt4)::x4b
      real(8),dimension(nt1+1)::x1a
      real(8),dimension(nt2+1)::x2a
      real(8),dimension(nt3+1)::x3a
      real(8),dimension(nt4+1)::x4a

      real(8)::x1min,x1max,dx1
      real(8)::x2min,x2max,dx2
      real(8)::x3min,x3max,dx3
      real(8)::x4min,x4max,dx4
      data x1min /  0.0d0 /
      data x1max / 10.0d0 /
      data x2min /  0.0d0 /
      data x2max / 10.0d0 /
      data x3min / 0.0d0    /
      data x3max / pi2 /
      data x4min / 0.0d0    /
      data x4max / pi2 /

      integer,parameter::nI=1000
      real(8),dimension(nI)::In,PIn
      real(8)::Imin,Imax,dI
      data Imin /  0.0d0 /
      data Imax / 100.0d0 /

      integer,parameter::nV=2*nI
      real(8),dimension(nV)::Vn,PVn
      real(8)::Vmin,Vmax,dV
      data Vmin / -100.0d0 /
      data Vmax /  100.0d0 /

      end module commons

      program numval
      implicit none
      integer:: is
      real(8)::s

      call MakeGrid
      do is=0,10
         s=dble(is)
         call EvalIsn(s)
         call EvalVsn(s)
         call Output(is)
      enddo

      end program numval
!=====================================
      subroutine MakeGrid
      use commons
      implicit none
      integer:: i,j,k,l
      real(8):: P
      dx1=(x1max-x1min)/nt1
      do i=1,nt1+1
        x1a(i)=x1min+(i-1)*dx1
      enddo
      do i=1,nt1
         x1b(i)=0.5d0*(x1a(i)+x1a(i+1))
      enddo

      dx2=(x2max-x2min)/nt2
      do j=1,nt2+1
        x2a(j)=x2min+(j-1)*dx2
      enddo

      do j=1,nt2
         x2b(j)=0.5d0*(x2a(j)+x2a(j+1))
      enddo

      dx3=(x3max-x3min)/nt3
      do k=1,nt3+1
        x3a(k)=x3min+(k-1)*dx3
      enddo

      do k=1,nt3
         x3b(k)=0.5d0*(x3a(k)+x3a(k+1))
      enddo

      dx4=(x4max-x4min)/nt4
      do l=1,nt4+1
        x4a(l)=x4min+(l-1)*dx4
      enddo

      do l=1,nt4
         x4b(l)=0.5d0*(x4a(l)+x4a(l+1))
      enddo

      do l=1,nt4
      do k=1,nt3
      do j=1,nt2
      do i=1,nt1
          P= P
     &              + exp(-x1b(i))*exp(-x2b(j))
     &               *(x1a(i+1)-x1a(i))
     &               *(x2a(j+1)-x2a(j))
     &               *(x3a(k+1)-x3a(k))/(2.0*pi)
     &               *(x4a(l+1)-x4a(l))/(2.0*pi)
      enddo
      enddo
      enddo
      enddo

      write(6,*) "Total P=",P

      return
      end subroutine MakeGrid
!=====================================
      subroutine EvalIsn(s)
      use commons
      implicit none
      real(8),intent(in)::s
      integer:: i,j,k,l,m
      real(8)::Indummy
      real(8)::Ptotal
      integer::index
      
      write(6,'(a11,1x,F4.0)') "EvalIsn s=",s

      dI=(Imax-Imin)/nI
      do m=1,nI
         In(m)=dI*(m-0.5)
      enddo
        PIn(:)=0.0d0

      do l=1,nt4
      do k=1,nt3
      do j=1,nt2
      do i=1,nt1
         Indummy= s + (x1b(i)+x2b(j))/2.0d0
     &     + sqrt(s * x1b(i))*cos(x3b(k))
     &     + sqrt(s * x2b(j))*sin(x4b(l))
         Index  = floor(Indummy/dI)+1
         Index  =min(max(Index,1),nI)
          PIn(Index)= PIn(Index)
     &              + exp(-x1b(i))*exp(-x2b(j))
     &               *(x1a(i+1)-x1a(i))
     &               *(x2a(j+1)-x2a(j))
     &               *(x3a(k+1)-x3a(k))/(2.0*pi)
     &               *(x4a(l+1)-x4a(l))/(2.0*pi)
      enddo
      enddo
      enddo
      enddo

      PIn(:)=PIn(:)/dI

!      Ptotal=sum(PIn(:))
!      PIn(:)=PIn(:)/Ptotal
      return
      end subroutine EvalIsn

!=====================================
      subroutine EvalVsn(s)
      use commons
      implicit none
      real(8),intent(in)::s
      integer:: i,j,k,l,m
      real(8)::Vndummy
      real(8)::Ptotal
      integer::index
      real(8),dimension(nV)::PVnhalf

      write(6,'(a11,1x,F4.0)') "EvalVsn s=",s

      dV=(Vmax-Vmin)/nV
      do m=1,nV
         Vn(m)=dV*(m-nV/2-0.5)
      enddo
        PVn(:)=0.0d0

      do l=1,nt4
      do k=1,nt3
      do j=1,nt2
      do i=1,nt1
         Vndummy= s
     & + sqrt(x1b(i)*x2b(j))*(cos(x3b(k))*sin(x4b(l))-sin(x3b(k))*cos(x4b(l)))
     & + sqrt(s * x1b(i))*cos(x3b(k))
     & + sqrt(s * x2b(j))*sin(x4b(l))
         Index  = floor(Vndummy/dV)+1+nV/2
!         write(6,*) "i,j,k",i,j,k
!         write(6,*) "Vn,dV",Vndummy,dV
!         write(6,*) "Index",Index
         Index  =min(max(Index,1),nV)
          PVn(Index)= PVn(Index)
     &              + exp(-x1b(i))*exp(-x2b(j))
     &               *(x1a(i+1)-x1a(i))
     &               *(x2a(j+1)-x2a(j))
     &               *(x3a(k+1)-x3a(k))/(2.0*pi)
     &               *(x4a(l+1)-x4a(l))/(2.0*pi)
!          stop
      enddo
      enddo
      enddo
      enddo

!      Ptotal=sum(PVn(:))
!      PVnhalf(:)=PVn(:)/Ptotal*0.5d0
      PVnhalf(:)=PVn(:)*0.5d0

      PVn(:)=0.0d0
      do m=1,nV
         PVn(m)=PVnhalf(m)+PVnhalf(nV-m+1)
      enddo

      PVn(:)=PVn(:)/dV

!      stop
      return
      end subroutine EvalVsn


!=====================================
      subroutine Output(is)
      use commons
      implicit none
      integer,intent(in)::is
      integer i,j,k,l,m
      integer,parameter::unitdmp=102
      character*50::path

      write(6,*) "Output s=",is

      write(path,'(a3,i2.2,a4)')"Isn,",is,".dat"
      open(unit=unitdmp,file=path,status='replace',form='formatted') 
      write(unitdmp,'(a1,1x,i10.0)')"#",nI
      do m=1,nI
         write(unitdmp,'(2(1x,E15.6e3))') In(m),PIn(m)
      enddo
      close(unitdmp)

      write(path,'(a3,i2.2,a4)')"Vsn,",is,".dat"
      open(unit=unitdmp,file=path,status='replace',form='formatted')
      write(unitdmp,'(a1,1x,i10.0)')"#",nV 
      do m=1,nV
         write(unitdmp,'(2(1x,E15.6e3))') Vn(m),PVn(m)
      enddo
      close(unitdmp)

      return
      end subroutine Output
