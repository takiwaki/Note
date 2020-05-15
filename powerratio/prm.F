      module commons
      implicit none
      integer,parameter:: in=100
      integer,parameter:: jn=100
      real(8),parameter:: R0=100.0d0
      real(8),dimension(in+1):: rada
      real(8),dimension(in)  :: radb
      real(8):: dr

      real(8),parameter:: pi=3.14159265358979323846264338327950288419716939
      real(8),dimension(jn+1):: phia
      real(8),dimension(jn)  :: phib
      real(8):: dphi

      real(8),parameter::sigma0=1.0d0
      real(8),dimension(in,jn)  :: sigma
      integer,parameter::mmax=3

      real(8),dimension(0:mmax)  :: acoff,bcoff,pratio
      real(8),dimension(0:mmax)  :: aphase
      real(8),dimension(0:mmax)  :: aamp

      end module commons

      program prm
      implicit none

      call MakingGrid
      call SetDensity
      call GetHarmonics
      call CompareP

      stop
      end program prm

      subroutine MakingGrid
      use commons
      implicit none
      integer::i,j

      dr  =R0/in
      rada(1)=0.0d0
      do i=2,in+1
         rada(i) = rada(i-1)+dr
      enddo
      do i=1,in
         radb(i) = (rada(i)+rada(i+1))/2.0d0
      enddo
      
      dphi=2.0*pi/jn
      phia(1)=-pi
      do j=2,jn+1
         phia(j) = phia(j-1)+dphi
      enddo
      do j=1,jn
         phib(j) = (phia(j)+phia(j+1))/2.0d0
      enddo
      
!      write(6,*)rada(:)
!      write(6,*)radb(:)
!      write(6,*)phia(:)
!      write(6,*)phib(:)

      return
      end subroutine MakingGrid

      subroutine SetDensity
      use commons
      implicit none
      integer:: i,j,m

      sigma(:,:) = 0.0d0

      do j=1,jn
      do i=1,in
            sigma(i,j) = sigma0 
     & * (1+cos(phib(j))+cos(2*phib(j))+cos(3*phib(j))
     &     +sin(phib(j))+sin(2*phib(j))+sin(3*phib(j))
     &   )
      enddo
      enddo

!      write(6,*)sigma(:,:)
      
      return
      end subroutine SetDensity

      subroutine GetHarmonics
      use commons
      implicit none
      integer:: i,j,m
      real(8)::phase

      acoff(:)=0.0d0
      bcoff(:)=0.0d0

      aphase(:)=0.0d0
        aamp(:)=0.0d0

      do m=0,mmax

!      do i=1,in
!      aamp(m)= aamp(m) + radb(i)**m
!     & *(rada(i+1)**2-rada(i)**2)/2.0d0
!      enddo
!      do j=1,jn
!         i=1
!         write(6,*)"test",cos(m*phib(j))
!         phase = (m*phib(j) - (2.0*pi)*floor(m*phib(j)/(2.0*pi)))
!      aphase(m)= aphase(m) + sigma(i,j)*cos(phase)
!     & *(phia(j+1)   -phia(j))
!      enddo
      do j=1,jn
      do i=1,in
!         phase = (m*phib(j) - (2.0*pi)*floor(m*phib(j)/(2.0*pi)))
         phase = m*phib(j)
         acoff(m) = acoff(m) + sigma(i,j)*radb(i)**m*cos(phase)
     & *(rada(i+1)**2-rada(i)**2)/2.0d0
     & *(phia(j+1)   -phia(j))

         bcoff(m) = bcoff(m) + sigma(i,j)*radb(i)**m*sin(phase)
     & *(rada(i+1)**2-rada(i)**2)/2.0d0
     & *(phia(j+1)   -phia(j)) 
      enddo
      enddo
      enddo

         pratio(0)=(acoff(0)*log(R0))**2
      do m=1,mmax
         pratio(m)=1.0d0/(2*m**2*R0**(2*m))*(acoff(m)**2+bcoff(m)**2)
      enddo
      
      return
      end subroutine GetHarmonics

      subroutine CompareP
      use commons
      implicit none
      real(8),dimension(0:mmax)  :: aana,bana,pana
      real(8),dimension(0:mmax)  :: apana,aaana
      integer:: m

         aaana(0)=R0**(2)/(2)
         apana(0)=2*pi
          aana(0)=aaana(0)*apana(0)
          bana(0)=R0**(2)/(2) *2*pi
          pana(0)=(aana(0)*log(R0))**2

      do m=1,mmax
         aaana(m)=R0**(2+m)/(m+2)
         apana(m)=pi
          aana(m)=aaana(m)*apana(m)

         bana(m)=R0**(2+m)/(m+2)*pi
         pana(m)=1.0d0/(2.0d0*m**2*R0**(2*m))
     &                 *(aana(m)**2+bana(m)**2)
      enddo

      write(6,*)"        analytic                "
     &          ,"numerical             ratio"
      write(6,*)"a0",aana(0),acoff(0),acoff(0)/aana(0)
      write(6,*)"a1",aana(1),acoff(1),acoff(1)/aana(1)
      write(6,*)"a2",aana(2),acoff(2),acoff(2)/aana(2)
      write(6,*)"a3",aana(3),acoff(3),acoff(3)/aana(3)
      write(6,*)
      
      write(6,*)"b0",bana(0),bcoff(0),bcoff(0)/bana(0)
      write(6,*)"b1",bana(1),bcoff(1),bcoff(1)/bana(1)
      write(6,*)"b2",bana(2),bcoff(2),bcoff(2)/bana(2)
      write(6,*)"b3",bana(3),bcoff(3),bcoff(3)/bana(3)
      write(6,*)
      
      write(6,*)"p0",pana(0),pratio(0),pratio(0)/pana(0)
      write(6,*)"p1",pana(1),pratio(1),pratio(1)/pana(1)
      write(6,*)"p2",pana(2),pratio(2),pratio(2)/pana(2)
      write(6,*)"p3",pana(3),pratio(3),pratio(3)/pana(3)

      return
      end subroutine CompareP
