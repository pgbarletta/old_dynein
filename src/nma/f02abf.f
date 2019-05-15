c######Subroutina para el anmh.f##############3
      SUBROUTINE f02abf(A, IA, N, R, V, IV, E, IFAIL)
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
C
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
