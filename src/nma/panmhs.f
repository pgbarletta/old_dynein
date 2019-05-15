C Programa para calcular los modos normales utilizando el metodo de ANM 

      IMPLICIT NONE

      integer readstring,icont
!      integer cutoff 
      double precision cutoff 
      integer i,slen,flen,long,j,k,m
      double precision itotx
      character*1000 card
      character*30 infile

              
      call getarg(1, infile)

      open(50,file='temp')!				aca van las coordenadas de los Calpha y el occupancy number
      open(51,file='temp1')!				aca van los bfactors experimentales
      open(52,file=infile)    
      icont=0
      do while (readstring(52,card,slen).ge.0 )
         long=slen
         if(card(1:4).eq.'ATOM') then
            if(card(14:15).eq.'CA') then
               write(50,*) (card(i:i),i=32,61) 
               write(51,*) (card(i:i),i=61,68)
               icont=icont+1
            endif
         endif
      enddo
      close(50)
      close(51)
      close(52)

      call calculo(icont, infile)

      stop
      end

C Fin del programa principal
C**************************************
C Subroutine calculo

      subroutine calculo(icont, infile)

      integer ifail,ii, ene, nicont
      integer i,icont,slen,flen,long,j,k,m
      parameter(icontmax=3000)
      double precision cutoff 
!      integer cutoff 
      double precision xx 
      integer icont2
      parameter(icont2max=100000)
      integer icont3
      parameter(icont3max=100)
      double precision r(icontmax,3),bfactor(icontmax)
      double precision x(3*icontmax),col
      double precision SUMBFAC,SUMCORR,bfacteor(icontmax)
      double precision bftprom,bfeprom
      double precision AA,AB,AC,CORSTD
      double precision itotx
      integer t, bf_ct, exc(100), ierr, flag1, flag2, nn, kk, jj
      integer h_uno(1000), h_dos(1000)
      integer a(icont2max),b(icont2max) 
      integer sa(icont3max),sb(icont3max), sas(icont3max),sbs(icont3max)
      double precision s(icontmax,icontmax)
      double precision hess(3*icontmax,3*icontmax)
      double precision w(icontmax,icontmax)
      double precision diag(3*icontmax,3*icontmax)
      double precision freq(3*icontmax),e(3*icontmax)
      double precision corr(3*icontmax,3*icontmax)
      character*1000 card
      character*30 infile, in_h, in_dis, cutoffc, in_mis
      character*30 out_bfcorr, out_bfteo, out_colec, out_correl
      character*30 out_freq, out_mods, out_bf

      call getarg(2, in_h)
      call getarg(3, in_dis)
      call getarg(4, cutoffc)
      read (cutoffc, *) cutoff
      call getarg(5, out_bf)
      call getarg(6, out_bfcorr)
      call getarg(7, out_bfteo)
      call getarg(8, out_colec)
      call getarg(9, out_correl)
      call getarg(10, out_freq)
      call getarg(11, out_mods)
      

        bf_ct = 0
        icont2 = 0!                                     contador de ptes H
        icont3=0!					contador de ptes dis
! este código calcula correlación entre bfactor teórco y experimental, pero
! yo no uso esa utilidad. bf_ct y exc[100] eran variables usadas p/ especificar
! Calphas q no debían ser tenidos en cuenta en el cálculo de correlación de
! bfactors. 

        if ( in_h /= 'none' ) then
            open(11,file= in_h)
            i=0
            do
                i = i + 1
                read(11, 91, iostat= ierr) h_uno(i), h_dos(i)
                if ( ierr/= 0 ) exit
            enddo
            icont2 = i!                 contador de ptes H
            close(11)
        endif

      open(50,file='temp')
      open(51,file='temp1')
      do i=1,icont
         read(50,*) r(i,1),r(i,2),r(i,3),xx
         read(51,*) bfactor(i)
      enddo

!       No hago diferenciación de ptes H ni disulfuro, ni cov bond.
!       Por eso sobreescribo todo con 1.0d0

      do i=1,icont!						aca empieza a hacer la matriz hessiana F
            do j=1,icont
                if(i.eq.j+1.or.i.eq.j-1) then!			estos son aa's consecutivos (cov bond)
                    w(i,j)=10.0d0
                    w(j,i)=10.0d0
                else
                    w(i,j)=0.01d0
                    w(j,i)=0.01d0
                endif
            enddo
      enddo

      do i=1,icont2!					contador de ptes H
        w(h_uno(i), h_dos(i)) = 0.1d0
        w(h_dos(i), h_uno(i)) = 0.1d0
      enddo




****************************************************
* Calculo de los elementos triangulares superiores *
*  de la matriz Hess 3Nx3N.- Aclaracion: i.NE.j    *
****************************************************
    

      do i=1,icont
         do j=1,icont
             s(i,j)=dsqrt((r(j,1)-r(i,1))**2+
     $(r(j,2)-r(i,2))**2+(r(j,3)-r(i,3))**2)
         enddo
      enddo
      
      do i=1,icont*3
         do j=1,icont*3
            hess(i,j)=0.0d0
         enddo
      enddo
      do i=1,icont
         do j=1,icont
           if(i.ne.j.and.i.lt.j) then
             if(s(i,j).le.cutoff) then
               do m=0,2
                 do k=0,2
                   If(k.eq.m) then
                  hess(i*3-2+m,j*3-2+k)=w(i,j)*(r(j,k+1)-r(i,m+1))**2
     $/s(i,j)**2
                              else
                  hess(i*3-2+m,j*3-2+k)=-w(i,j)*((r(j,m+1)-r(i,m+1))
     $*(r(j,k+1)-r(i,k+1)))/s(i,j)**2
                   endif
                 enddo
               enddo
             endif
           endif
         enddo
       enddo

c************************************************
* Calculo de los elementos fuera de la diagonal,* 
*    dentro de las submatrices con i=j.         *
*************************************************
      do i=1,icont
         do j=1,icont
           if(i.ne.j) then
              If(s(i,j).le.cutoff) then            
                do m=0,2
                 do k=0,2
                  if(k.ne.m) then
                    hess(i*3-2+m,i*3-2+k)=hess(i*3-2+m,i*3-2+k)
     $+w(i,j)*((r(j,m+1)-r(i,m+1))*(r(j,k+1)-r(i,k+1)))/s(i,j)**2
                  endif
                enddo
              enddo
             endif            
           endif
         enddo
      enddo

**************************************************
*   Calculo de los elementos diagonales dentro   *
*         de las submatrices i=j.-               *
**************************************************

       do i=1,icont
         do j=1,icont
           if(i.ne.j) then
             if(s(i,j).le.cutoff) then
                do k=0,2
                  hess(i*3-2+k,i*3-2+k)=hess(i*3-2+k,i*3-2+k)
     $+w(i,j)*((r(j,k+1)-r(i,k+1))*(r(j,k+1)-r(i,k+1)))/s(i,j)**2
                enddo
             endif
           endif
         enddo
      enddo


************************************************
*  Calculo de los elementos transpuestos fuera * 
*   de la diagonal de las submatrices i.ne.j   *
************************************************

      do i=1,icont
         do j=1,icont
            if(i.ne.j.and.i.gt.j) then
              if(s(i,j).le.cutoff) then
                 do m=0,2
                   do k=0,2
                     if(k.eq.m) then
                       hess(i*3-2+m,j*3-2+k)=-hess(j*3-2+k,i*3-2+m)
                           else
**********************************************************
* Calculo de los elem. transp. de las submatrices i.ne.j *
*     fuera de la diagonal de esa submatriz              *
**********************************************************  
                       hess(i*3-2+m,j*3-2+k)=hess(j*3-2+k,i*3-2+m)
                      endif
                   enddo
                 enddo
              endif
            endif
         enddo
       enddo
**********************     
**********************
 
      ifail=0
      do i=1,icont*3
        do j=1,icont*3
           diag(i,j)=0.0d0
        enddo
      enddo
 
      call f02abf(hess,icontmax*3,icont*3,freq,diag,icontmax*3,e,ifail)

      open(10,file=out_mods)
      do i=1,icont*3
        write(10,333) (diag(i,j),j=7,icont*3)
      enddo
      close(10)


*********************
*   CORRELACIONES   *
*********************

      do i=1,icont*3
         do j=1,icont*3
             corr(i,j)=0.0d0
         enddo
      enddo

      do i=1,icont*3
	  do j=1,icont*3
           do k=7,icont*3
               corr(i,j)=corr(i,j)+(diag(i,k)*diag(j,k))/freq(k)
           enddo
        enddo
      enddo

      open(10,file=out_correl)
      do i=1,icont*3
         write(10,339) (corr(i,j),j=1,icont*3)
      enddo 
      close(10)

      open(10,file=out_colec)
      do j=7,3*icont     
         do i=1,3*icont
            x(i)=diag(i,j)
         enddo
         call colec(x,icont,col)
         write(10,*) j,col,freq(j)
      enddo
      close(10)

      SUMCORR=0.0d0
      SUMBFAC=0.0d0
      ii=1
      do i=1,icont*3,3
!!!!!!!!!!!!!!  !!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!    
        do nn=1, bf_ct, 1!              este 'do' y el prox 'if' son p/ exceptuar Calphas del calculo de correlacion
                if ( ii == exc(nn) ) then
                        flag1=1
                endif
        enddo
        if ( flag1 == 1 ) then
                flag1=0
		bfacteor(ii)= 0
	         ii=ii+1
                cycle
        endif
!!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!! 
         bfacteor(ii)=(corr(i,i)+corr(i+1,i+1)+corr(i+2,i+2))
         ii=ii+1
      enddo 

      do i=1,icont
          SUMCORR = SUMCORR+bfacteor(i)
      enddo

      do i=1,icont
!!!!!!!!!!!!!!  !!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!    
        do nn=1, bf_ct, 1!              este 'do' y el prox 'if' son p/ exceptuar Calphas del calculo de correlacion
                if ( i == exc(nn) ) then
                        flag1=1
                endif
        enddo
        if ( flag1 == 1 ) then
                flag1=0
                bfactor(i)=0
        endif
!!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!! 
          SUMBFAC = SUMBFAC+bfactor(i) 
      enddo

      open(29,file=out_bfteo)
      do i=1,icont
          write(29,*) i,bfacteor(i)
      enddo
      close(29)
     
*******************************************************
*  CORRELACION ENTRE bfactor teorico y experimental   *
*******************************************************
*     AA es la suma de los (Xi-Xprom)(Yi-Yprom)
*     AB es la suma de los (Xi-Xprom) al cuadrado
*     AC es la suma de los (Yi-Yprom) al cuadrado

      bftprom=0.0d0
      bfeprom=0.0d0

      bftprom=SUMCORR/dfloat(icont-bf_ct)
      bfeprom=SUMBFAC/dfloat(icont-bf_ct)


      AA=0.0d0
      AB=0.0d0
      AC=0.0d0

      do i=1,icont
!!!!!!!!!!!!!!  !!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!    
        do nn=1, bf_ct, 1!              este 'do' y el prox 'if' son p/ exceptuar Calphas del calculo de correlacion
                if ( i == exc(nn) ) then
                        flag1=1
                endif
        enddo
        if ( flag1 == 1 ) then
                flag1=0
		cycle
        endif
!!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!!   !!!!!!!!!!!!! 
           AA = AA + ((bfactor(i)-bfeprom)*(bfacteor(i)-bftprom))!	covarianza
           AB = AB + (bfactor(i)-bfeprom)**2!				varianza de bftor experimental
           AC = AC + (bfacteor(i)-bftprom)**2!				varianza de bftor teorico
      enddo

      CORSTD= AA/(dsqrt(AB)*dsqrt(AC))   
   
       
      open(10,file=out_freq)
        write(10,*)'beta=',SUMBFAC/SUMCORR
      do i=1,icont*3
        write(10,*) freq(i)
      enddo
      close(10)

      open(10,file=out_bf)
      do i=1,icont
!          write(10,444) i,bfacteor(i)*SUMBFAC/SUMCORR,bfactor(i)!	reeemplazo esta linea por la siguiente pq 
!     $,CORSTD!								me escribe CORSTD al pedo 							
	write(10,999) i, bfacteor(i)*SUMBFAC/SUMCORR,bfactor(i)
      enddo
      close(10)

      open(10,file=out_bfcorr)
      write(10,335) CORSTD
      close(10)

      close(50,STATUS='DELETE')
      close(51,STATUS='DELETE')     



91      format(i3, x, i3)
92      format(1i4)
222   FORMAT(3(1x,F7.3),1x,F6.2,1x,F6.2) 
333   FORMAT(10000(1x,F9.6)) 
c|  -1.0485116050807597
c| -1.0485E+000
c339   FORMAT(10000(1x,F20.16))
339   FORMAT(10000(1x,ES12.4E3))
444   FORMAT(i5,1x,F12.2,1x,F7.3,1x,F7.4)
999   FORMAT(i5,1x,F6.2,1x,F7.3)
445   FORMAT(I5,1x,F8.2)
555   FORMAT(3(1x,I3))
776   FORMAT(2(1x,I4))
777   FORMAT(2i5,2i5)
775   FORMAT(I6)
774   FORMAT(I2)
778   FORMAT(I4,1x,I4,A)
!c|  27  125   27  125  2.09
335   FORMAT(10000(1x,F14.11))
      return
      end

****************************************
* Subrutina de calculo de colectividad *
****************************************

      SUBROUTINE colec(x,n,col)

      IMPLICIT NONE
      INTEGER n,i,ii
      DOUBLE PRECISION x(3*n), alfa, col, peq
      DOUBLE PRECISION r2(n) 
      PARAMETER (peq = 1.e-30)


      alfa=0.0d0

      ii=1
      do i=1,n*3,3
        r2(ii)=x(i)**2+x(i+1)**2+x(i+2)**2
        ii=ii+1
      enddo
    
      do i=1,3*n
          alfa=alfa+x(i)*x(i)
      enddo


      alfa=1.0d0/alfa
      col=0.0d0
      do i=1,n
          col=col+alfa*r2(i)*log(alfa*r2(i))
      enddo

      col=exp(-col)/dfloat(n)

      return
      end


c      open(10,file='colect')
c       do i=1,icont*3
c          write(10,*) col(i)
c       enddo
c      close(10)

c      END  


C      do i=1,icont*3,3
C         write(17,333) corr(i,i)-
C     $((corr(i,i)+corr(i+1,i+1)+corr(i+2,i+2)))/3
C         write(18,333) corr(i+1,i+1)-((corr(i,i)+corr(i+1,i+1)+
C     $corr(i+2,i+2)))/3
C         write(19,333) corr(i+2,i+2)-((corr(i,i)+corr(i+1,i+1)+
C     $corr(i+2,i+2)))/3
C         write(20,333) (corr(i,i)+corr(i+1,i+1)+corr(i+2,i+2))
C      enddo 

c      close(50,STATUS='DELETE')
     
c222   FORMAT(3(1x,F7.3),1x,F5.2) 
c333   FORMAT(1000(1x,F7.3)) 


c------ SUBROUTINES

      integer function readstring(file,card,flen)
      integer       file, flen
      character*1000 card
      if(file.gt.200)STOP'ERROR: file number too large'
      read(file,'(a)',err=100,end=100)card
      flen=1000
      do while(card(flen:flen).eq.' ')
         flen=flen-1
      enddo
      readstring=flen
      return
 100  readstring=-1

      return
      end
      
      SUBROUTINE f02abf (A, IA, N, R, V, IV, E, IFAIL)
C
C  diagonalizes a real, symmetric matrix
C  A(IA,N) : matrix to be diagonalized,
C    IA      its leading (first) dimension
C    N     : order of the matrix (.LE. IA!!!)
C             (only the NxN part of the matrix is actually needed)
C  R(N)    : on output, contains the eigenvalues (in ascending order)
C  V(IV,N) : on output, contains the eigen vectors (in columns)
C    IV      its leading dimension
C   E(N)   : working array
C  IFAIL   : indicator for errors: 0 on output if everything worked...
C
C     MARK 2 RELEASE. NAG COPYRIGHT 1972
C     MARK 3 REVISED.
C     MARK 4.5 REVISED
C
C     EIGENVALUES AND EIGENVECTORS OF A REAL SYMMETRIX MATRIX
C     1ST AUGUST 1971
      INTEGER P01AAF, ISAVE, IFAIL, N, IA, IV
C$P 1
      DOUBLE PRECISION SRNAME
      DOUBLE PRECISION TOL, XXXX, A(IA,N), R(N), V(IV,N), E(N), X02ADF,
     * X02AAF
      DATA SRNAME /8H F02ABF /
      ISAVE = IFAIL
      IFAIL = 1
      TOL = X02ADF(1.0D0)
      CALL F01AJF(N, TOL, A, IA, R, E, V, IV)
      DO 1 I=1,N
C     PRINT 100,IA,IV,R(I),E(I),(A(I,J),V(I,J),J=1,N)
  100 FORMAT(/,' AJF :IA,IV,R,E:',2I2,2(D15.8),/,' A',3D15.8,/,' D',
     X3D15.8)
   1  CONTINUE
      TOL = X02AAF(1.0D0)
      CALL F02AMF(N, TOL, R, E, V, IV, IFAIL)
      DO 2 I=1,N
C     PRINT 200,R(I),E(I),IV,IFAIL,(V(I,J),J=1,3)
  200 FORMAT(/,' AMF :R,E,IV,IFAIL=',2D15.8,2I3,/,' V',3D15.8)
   2  CONTINUE
      IF (IFAIL.NE.0) IFAIL = P01AAF(ISAVE,IFAIL,SRNAME)
      RETURN
      END

      SUBROUTINE F01AJF(N, ATOL, A, IA, D, E, Z, IZ)
C     MARK 2 RELEASE. NAG COPYRIGHT 1972
C     MARK 4 REVISED.
C     MARK 4.5 REVISED
C     MARK 5C REVISED
C
C     TRED2
C     THIS SUBROUTINE REDUCES THE GIVEN LOWER TRIANGLE OF A
C     SYMMETRIC MATRIX, A, STORED IN THE ARRAY A(N,N), TO
C     TRIDIAGONAL FORM USING HOUSEHOLDERS REDUCTION. THE DIAGONAL
C     OF THE RESULT IS STORED IN THE ARRAY D(N) AND THE
C     SUB-DIAGONAL IN THE LAST N - 1 STORES OF THE ARRAY E(N)
C     (WITH THE ADDITIONAL ELEMENT E(1) = 0). THE TRANSFORMATION
C     MATRICES ARE ACCUMULATED IN THE ARRAY Z(N,N). THE ARRAY
C     A IS LEFT UNALTERED UNLESS THE ACTUAL PARAMETERS
C     CORRESPONDING TO A AND Z ARE IDENTICAL.
C     1ST AUGUST 1971
C
      INTEGER I, IA, II, IZ, J1, J, K, L, N
      DOUBLE PRECISION ATOL, F, G, H, HH, A(IA,N), D(N), E(N), Z(IZ,N)
      DO 40 I=1,N
         DO 20 J=1,I
            Z(I,J) = A(I,J)
   20    CONTINUE
   40 CONTINUE
      IF (N.EQ.1) GO TO 280
      DO 260 II=2,N
         I = N - II + 2
         L = I - 2
         F = Z(I,I-1)
         G = 0.0D0
         IF (L.EQ.0) GO TO 80
         DO 60 K=1,L
            G = G + Z(I,K)*Z(I,K)
   60    CONTINUE
   80    H = G + F*F
C     IF G IS TOO SMALL FOR ORTHOGONALITY TO BE
C     GUARANTEED THE TRANSFORMATION IS SKIPPED
         IF (G.GT.ATOL) GO TO 100
         E(I) = F
         H = 0.0D0
         GO TO 240
  100    L = L + 1
         G = DSQRT(H)
         IF (F.GE.0.0D0) G = -G
         E(I) = G
         H = H - F*G
         Z(I,I-1) = F - G
         F = 0.0D0
         DO 180 J=1,L
            Z(J,I) = Z(I,J)/H
            G = 0.0D0
C     FORM ELEMENT OF A*U
            DO 120 K=1,J
               G = G + Z(J,K)*Z(I,K)
  120       CONTINUE
            J1 = J + 1
            IF (J1.GT.L) GO TO 160
            DO 140 K=J1,L
               G = G + Z(K,J)*Z(I,K)
  140       CONTINUE
C     FORM ELEMENT OF P
  160       E(J) = G/H
            F = F + G*Z(J,I)
  180    CONTINUE
C     FORM K
         HH = F/(H+H)
C     FORM REDUCED A
         DO 220 J=1,L
            F = Z(I,J)
            G = E(J) - HH*F
            E(J) = G
            DO 200 K=1,J
               Z(J,K) = Z(J,K) - F*E(K) - G*Z(I,K)
  200       CONTINUE
  220    CONTINUE
  240    D(I) = H
  260 CONTINUE
  280 E(1) = 0.0D0
      D(1) = 0.0D0
C     ACCUMULATION OF TRANSFORMATION MATRICES
      DO 400 I=1,N
         L = I - 1
         IF (D(I).EQ.0.0D0) GO TO 360
         DO 340 J=1,L
            G = 0.0D0
            DO 300 K=1,L
               G = G + Z(I,K)*Z(K,J)
  300       CONTINUE
            DO 320 K=1,L
               Z(K,J) = Z(K,J) - G*Z(K,I)
  320       CONTINUE
  340    CONTINUE
  360    D(I) = Z(I,I)
         Z(I,I) = 1.0D0
         IF (L.EQ.0) GO TO 400
         DO 380 J=1,L
            Z(I,J) = 0.0D0
            Z(J,I) = 0.0D0
  380    CONTINUE
  400 CONTINUE
      RETURN
      END


      SUBROUTINE F02AMF(N, ACHEPS, D, E, Z, IZ, IFAIL)
C     MARK 2 RELEASE. NAG COPYRIGHT 1972
C     MARK 3 REVISED.
C     MARK 4 REVISED.
C     MARK 4.5 REVISED
C
C     TQL2
C     THIS SUBROUTINE FINDS THE EIGENVALUES AND EIGENVECTORS OF A
C     TRIDIAGONAL MATRIX, T, GIVEN WITH ITS DIAGONAL ELEMENTS IN
C     THE ARRAY D(N) AND ITS SUB-DIAGONAL ELEMENTS IN THE LAST N
C     - 1 STORES OF THE ARRAY E(N), USING QL TRANSFORMATIONS. THE
C     EIGENVALUES ARE OVERWRITTEN ON THE DIAGONAL ELEMENTS IN THE
C     ARRAY D IN ASCENDING ORDER. THE EIGENVECTORS ARE FORMED IN
C     THE ARRAY Z(N,N), OVERWRITING THE ACCUMULATED
C     TRANSFORMATIONS AS SUPPLIED BY THE SUBROUTINE F01AJF. THE
C     SUBROUTINE WILL FAIL IF ANY ONE EIGENVALUE TAKES MORE THAN 30
C     ITERATIONS.
C     1ST APRIL 1972
C
      INTEGER P01AAF, ISAVE, IFAIL, N, I, L, J, M, I1, M1, II, K, IZ
C$P 1
      DOUBLE PRECISION SRNAME
      DOUBLE PRECISION B, F, H, ACHEPS, G, P, R, C, S, D(N), E(N), Z(IZ,
     *N)
      DATA SRNAME /8H F02AMF /
      ISAVE = IFAIL
      IF (N.EQ.1) GO TO 40
      DO 20 I=2,N
         E(I-1) = E(I)
   20 CONTINUE
   40 E(N) = 0.0D0
      B = 0.0D0
      F = 0.0D0
      DO 300 L=1,N
         J = 0
         H = ACHEPS*(DABS(D(L))+DABS(E(L)))
         IF (B.LT.H) B = H
C     LOOK FOR SMALL SUB-DIAG ELEMENT
         DO 60 M=L,N
            IF (DABS(E(M)).LE.B) GO TO 80
   60    CONTINUE
   80    IF (M.EQ.L) GO TO 280
  100    IF (J.EQ.30) GO TO 400
         J = J + 1
C     FORM SHIFT
         G = D(L)
         H = D(L+1) - G
         IF (DABS(H).GE.DABS(E(L))) GO TO 120
         P = H*0.5D0/E(L)
         R = DSQRT(P*P+1.0D0)
         H = P + R
         IF (P.LT.0.0D0) H = P - R
         D(L) = E(L)/H
         GO TO 140
  120    P = 2.0D0*E(L)/H
         R = DSQRT(P*P+1.0D0)
         D(L) = E(L)*P/(1.0D0+R)
  140    H = G - D(L)
         I1 = L + 1
         IF (I1.GT.N) GO TO 180
         DO 160 I=I1,N
            D(I) = D(I) - H
  160    CONTINUE
  180    F = F + H
C     QL TRANSFORMATION
         P = D(M)
         C = 1.0D0
         S = 0.0D0
         M1 = M - 1
         DO 260 II=L,M1
            I = M1 - II + L
            G = C*E(I)
            H = C*P
            IF (DABS(P).LT.DABS(E(I))) GO TO 200
            C = E(I)/P
            R = DSQRT(C*C+1.0D0)
            E(I+1) = S*P*R
            S = C/R
            C = 1.0D0/R
            GO TO 220
  200       C = P/E(I)
            R = DSQRT(C*C+1.0D0)
            E(I+1) = S*E(I)*R
            S = 1.0D0/R
            C = C/R
  220       P = C*D(I) - S*G
            D(I+1) = H + S*(C*G+S*D(I))
C     FORM VECTOR
            DO 240 K=1,N
               H = Z(K,I+1)
               Z(K,I+1) = S*Z(K,I) + C*H
               Z(K,I) = C*Z(K,I) - S*H
  240       CONTINUE
  260    CONTINUE
         E(L) = S*P
         D(L) = C*P
         IF (DABS(E(L)).GT.B) GO TO 100
  280    D(L) = D(L) + F
  300 CONTINUE
C     ORDER EIGENVALUES AND EIGENVECTORS
      DO 380 I=1,N
         K = I
         P = D(I)
         I1 = I + 1
         IF (I1.GT.N) GO TO 340
         DO 320 J=I1,N
            IF (D(J).GE.P) GO TO 320
            K = J
            P = D(J)
  320    CONTINUE
  340    IF (K.EQ.I) GO TO 380
         D(K) = D(I)
         D(I) = P
         DO 360 J=1,N
            P = Z(J,I)
            Z(J,I) = Z(J,K)
            Z(J,K) = P
  360    CONTINUE
  380 CONTINUE
      IFAIL = 0
      RETURN
  400 IFAIL = P01AAF(ISAVE,1,SRNAME)
      RETURN
      END

      INTEGER FUNCTION P01AAF(IFAIL, ERROR, SRNAME)
C     MARK 1 RELEASE.  NAG COPYRIGHT 1971
C     MARK 3 REVISED
C     MARK 4A REVISED, IER-45
C     MARK 4.5 REVISED
C     MARK 7 REVISED (DEC 1978)
C     RETURNS THE VALUE OF ERROR OR TERMINATES THE PROGRAM.
      INTEGER ERROR, IFAIL, NOUT
C$P 1
      DOUBLE PRECISION SRNAME
C     TEST IF NO ERROR DETECTED
      IF (ERROR.EQ.0) GO TO 20
C     DETERMINE OUTPUT UNIT FOR MESSAGE
      CALL X04AAF (0,NOUT)
C     TEST FOR SOFT FAILURE
      IF (MOD(IFAIL,10).EQ.1) GO TO 10
C     HARD FAILURE
      WRITE (NOUT,99999) SRNAME, ERROR
C     STOPPING MECHANISM MAY ALSO DIFFER
      STOP
C     SOFT FAIL
C     TEST IF ERROR MESSAGES SUPPRESSED
   10 IF (MOD(IFAIL/10,10).EQ.0) GO TO 20
      WRITE (NOUT,99999) SRNAME, ERROR
   20 P01AAF = ERROR
      RETURN
99999 FORMAT (1H0, 38HERROR DETECTED BY NAG LIBRARY ROUTINE , A8,
     * 11H - IFAIL = , I5//)
      END


      DOUBLEPRECISION FUNCTION X02AAF(X)
      DOUBLEPRECISION X,Z
C     NAG COPYRIGHT 1975
C     IBM DOUBLE PRECISION
C     MARK 4.5 RELEASE
C     * MACHEPS *
C     RETURNS THE VALUE MACHEPS WHERE MACHEPS IS THE SMALLEST POSITIVE
C     NUMBER SUCH THAT 1.0 + EPS > 1.0
C     THE X PARAMETER IS NOT USED
C     FOR IBM RISC 6000
      X02AAF = 2.0D0**(-52.0D0)
C     SET IN HEX FOR ACCURACY
C      DATA Z/Z/
C      X02AAF=Z
      RETURN
      END


      DOUBLEPRECISION FUNCTION X02ADF(X)
      DOUBLEPRECISION X,Z
C     NAG COPYRIGHT 1975
C     MARK 4.5 RELEASE
C     IBM DOUBLE PRECISION
C     * MINTOEPS *
C     RETURNS THE RATIO OF THE SMALLEST POSITIVE REAL FLOATING-
C     POINT NUMBER REPRESENTABLE ON THE COMPUTER TO MACHEPS
C     FOR IBM RISC 6000
      X02ADF = 2.0D0**(-448.0)
C     FOR IBM 370
C     X02ADF = 16.0D0**(-52)
C     SET IN HEX FOR ACCURACY
C      DATA Z/Z0D000000/
C      X02ADF=Z
      RETURN
      END


      SUBROUTINE X04AAF(I,NERR)
C     MARK 7 RELEASE. NAG COPYRIGHT 1978
C     MARK 7C REVISED IER-190 (MAY 1979)
C     IF I = 0, SETS NERR TO CURRENT ERROR MESSAGE UNIT NUMBER
C     (STORED IN NERR1).
C     IF I = 1, CHANGES CURRENT ERROR MESSAGE UNIT NUMBER TO
C     VALUE SPECIFIED BY NERR.
C
C     *** NOTE ***
C     THIS ROUTINE ASSUMES THAT THE VALUE OF NERR1 IS SAVED
C     BETWEEN CALLS.  IN SOME IMPLEMENTATIONS IT MAY BE
C     NECESSARY TO STORE NERR1 IN A LABELLED COMMON
C     BLOCK /AX04AA/ TO ACHIEVE THIS.
C
C     .. SCALAR ARGUMENTS ..
      INTEGER I, NERR
C     ..
C     .. LOCAL SCALARS ..
      INTEGER NERR1
C     ..
      DATA NERR1 /6/
      IF (I.EQ.0) NERR = NERR1
      IF (I.EQ.1) NERR1 = NERR
      RETURN
      END
