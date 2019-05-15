      implicit none
      
      integer, parameter :: ikind=selected_real_kind(p=6)! p= 6, 15 o 18 (nro de figuras)
      integer, parameter :: jkind=selected_real_kind(p=15)! p= 6, 15 o 18 (nro de figuras)
      character*20 infile_1, infile_2, infile_3, infile_4, infile_6
      character*20 infile_5, outfile_1, outfile_2, outfile_3, tresnc
      character*20 outfile_4, pnumc, pnumberc, pnumber2c
      integer i, j, k, t, m, flag, flag2, ierr, site(100)
      integer bfx, bfy, bfz, tresn, pnum, ndatmax, max_mod
      parameter(ndatmax=3000)
      parameter(max_mod=3000)

      integer pmod(max_mod), pmod2(max_mod)
      integer nsub(ndatmax)
      integer repe(max_mod)
      double precision mods(max_mod, max_mod)
      double precision frequ(max_mod), frequ2(max_mod)
      double precision temp(max_mod), norm(max_mod), norm_pond(max_mod)
      double precision bf(max_mod), adj_pond(max_mod)
      double precision bf_tot(max_mod)
      double precision bf_frac(max_mod, max_mod)
      double precision tempx(max_mod)
      double precision tempy(max_mod)
      double precision tempz(max_mod)
      double precision bf_mode(max_mod), mode_pond(max_mod)
      double precision mods2(max_mod, max_mod)
      double precision bf_mode_tot
      double precision bf_mode_sort(max_mod), mode_pond2(max_mod)
      ! variables del gramiano:
      
      integer ndat,pnumber, nmod,iflag,ldx,iexp, pnumber2
      double precision getdet, cerdo
      double precision idet, new
      double precision modos(ndatmax,ndatmax)
      double precision WKSPCE(ndatmax)
      double precision modosp(ndatmax,ndatmax)
      double precision modos2(ndatmax,ndatmax)
      double precision modosp2(ndatmax,ndatmax)
      double precision modos3(ndatmax,ndatmax)
	double precision modos3_pond(ndatmax,ndatmax)
      double precision vol,vol2,vol3, vol4
      double precision modostemp(ndatmax,ndatmax)
      double precision scpr(ndatmax,ndatmax),scpr2(ndatmax,ndatmax) 
	double precision scpr_pond(ndatmax,ndatmax)
      double precision proy(ndatmax)         
      double precision pint
      integer ascpr(ndatmax,ndatmax),z
      integer iorden(ndatmax)
      integer ifail 
      double precision diag(ndatmax,ndatmax)
      double precision freq(ndatmax),e(ndatmax)
      character*50 infile_a, infile_b, di, outfile 
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
      ! Calculo de valor zeta entre 2 subespacios, ponderando por aporte al bfactor
      ! de un cjto de aa's. 
      ! Asume q los modos ya están ordenados.
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!      
      i=0
      j=0
      k=0
      t=0
      m=0
      pnum=1
      pnumber=1
      pnumber2=1
      ifail=0
      call getarg (1, infile_1)!	los modos 
      call getarg (2, infile_2)! 	el archivo con los otros modos a comparar
      call getarg (3, infile_3)!	los aportes a bftors de los modos del 1er subspace
      call getarg (4, infile_4)!	los aportes a bftors de los modos del 2do subspace
      call getarg (5, tresnc)!		Nro de elementos de los modos.
      read(tresnc, *) tresn
      ndat=tresn+6
      call getarg (6, pnumberc)!         Nro de de modos. Si se especifican Bfactors, este valor se sobreescribe 
      read(pnumberc, *) pnumber 
      call getarg (7, pnumber2c)!         Nro de de modos. Si se especifican Bfactors, este valor se sobreescribe
      read(pnumber2c, *) pnumber2

      call getarg (8, outfile_1)!	rtdo del zeta value 
      call getarg (9, outfile_2)!	rtdo del nd value 
      call getarg (10, outfile_3)!	eigenvalues del grammiano
      call getarg (11, outfile_4)!	eigenvectors del grammiano
     
      open (11, file=infile_1)
      open (12, file=infile_2)
      !!!!!!!!!!!!!!!!!!!!!!!!!!!! lee archivos !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 

      if ( infile_3 /= 'none' ) then
          open (13, file=infile_3)
          do                                  
    	    read(13,96, iostat=ierr) pmod(pnumber), mode_pond(pnumber) 
    	    if ( ierr/= 0 ) exit
    	    pnumber= pnumber + 1
          enddo
          pnumber= pnumber - 1
      endif

      if ( infile_4 /= 'none' ) then
          open (14, file=infile_4)
          do
    	    read(14,96, iostat=ierr) pmod(pnumber2), mode_pond2(pnumber2) 
    	    if ( ierr/= 0 ) exit
        	pnumber2= pnumber2 + 1
          enddo
          pnumber2= pnumber2 - 1
      endif

      do i=1, tresn+6!				leo el archivo de modos
      	read(11,91) (modos2(i,j),j=1, pnumber)
      enddo
      do i=1, tresn+6!				leo el archivo de modos
      	read(12,91) (modosp2(i,j),j=1, pnumber2)
      enddo
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
      !!!!!!!!!!!!!!!!!!!!!!!!!!!! grammiano !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
      !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! 
      do i=1,pnumber
         do j=1,pnumber
            scpr2(i,j)=0.0d0
            do k=1,ndat
               scpr2(i,j)=scpr2(i,j)+modos2(k,i)*modos2(k,j)
	! c/ fila 'n' de scpr2 tiene el modo 'n' no perturbado, multiplicado por todos los modos no perturbados, incluido el mismo
            enddo
         enddo
      enddo
      do i=1,pnumber
         write(72,91) (scpr2(i,j),j=1,pnumber)
      enddo
	!!!!!!!!!!!!!!! acomoda los sentidos de los vectores !!!!!!!!!!!!!!!!!!!!!
      do i=1,pnumber
         scpr2(i,i)=0.0d0!					la diagonal tiene los pdtos entre 1 mismo modo
         do k=1,ndat
            scpr2(i,i)=scpr2(i,i)+modosp2(k,i)*modos2(k,i)!	
         enddo
         if(scpr2(i,i).lt.0.0d0) then
            do k=1,ndat
               modosp2(k,i)=-1.0d0*modosp2(k,i)
	! si habia vectores con sentidos opuestos, acomoda sus pdtos p/ q den el mismo signo
            enddo
         endif
      enddo

!			------------------ 	ACA EMPIEZA A ARMAR LA MTZ PROYECCION    -------------

      do i=1,pnumber2
         do j=1,pnumber
            scpr2(i,j)=0.0d0
            do k=1,ndat
               scpr2(i,j)=scpr2(i,j)+modosp2(k,i)*modos2(k,j)!	c/ fila 'n' de scpr2 es el pdto escalar entre el modo perturbado 
            enddo!						'n' y todos los modos no perturbados.

!      write(99,*) scpr2(i,j)
!      scpr_pond(i,j)= scpr2(i,j) * dsqrt(mode_pond(j)) 
!      scpr2(i,j)=scpr_pond(i,j) * dsqrt(mode_pond(j)) &
!                               &* dsqrt(mode_pond2(i))    ! pondero segun ambos subespacios

	write(99,*) scpr2(i,j)
         enddo!							
      enddo

      do i=1,pnumber2
         do k=1,ndat
            modos3(k,i)=0.0d0
	    modos3_pond(k,i)=0.0d0
         enddo
      enddo

       do i=1,pnumber2!				mtx de coeficientes de proyeccion
         write(44,91) (scpr2(i,j),j=1,pnumber)
       enddo

      do i=1,pnumber2
         do j=1,pnumber
            do k=1,ndat
               modos3(k,i)=modos3(k,i)+scpr2(i,j)*modos2(k,j)
            enddo					      
         enddo					     
      enddo						     
!Lo q acaba de hacer el ultimo ciclo:
! c/ elemento 'n' de una columna de modos3 tiene la suma de pdtos escalares entre todos los 'q(n)' MNs y los etos de la fila 'n' de
!scpr2 Este es el ultimo paso p/ el calculo de la pycion. Aca se le da la direccion de los MNs a los pdtos escalares, o sea, aca se 

       do k=1,ndat!				mtx de proyeccion
         write(55,91) (modos3(k,i),i=1,pnumber2)
       enddo

!		ahora obtengo la norma de los vectores proyeccion, ponderados y sin ponderar, p/ checkear algo nomas
!
!         do i=1,pnumber
!	    norm(i)=0
!	    norm_pond(i)=0
!           do k=1,ndat
!               norm(i)= norm(i) + modos3(k,i)**2!
!		norm_pond(i)= norm_pond(i) + modos3_pond(k,i)**2
!            enddo!                  
!		norm(i)= dsqrt(norm(i))               
!		norm_pond(i)= dsqrt(norm_pond(i))
!		adj_pond(i)= norm(i)/norm_pond(i)!		uso este coeficiente p/ normalizar los vectores proyeccion
!         enddo! 						
!
!       do i=1, pnumber!			
!	write(37,259) norm(i), norm_pond(i), mode_pond(i), mode_pond2(i)
!       enddo
      do i=1,pnumber2
         do j=1,pnumber2
            scpr2(i,j)=0.0d0
            do k=1,ndat
               scpr2(i,j)=scpr2(i,j)+modos3(k,i)*modos3(k,j)
            enddo!					    
         enddo!						    
      enddo

! c/ fila 'n' de scpr2 tiene la col 'n' de modos 3, multiplicada por todas las columnas de modos 3. 
! Este seria el calculo de gramiana. scpr2 pasa a ser la matriz grammiana de la mtz de proyeccion modos3
        do k=1,ndat!    					mtx grammiana 
         write(66,91) (scpr2(k,j),j=1,pnumber2)
       enddo

      call f02abf(scpr2,ndatmax,pnumber2,freq,diag,ndatmax,e,ifail)!	diagonaliza la mtz gramiana scpr2

      open(24,file=outfile_4)
      do i=1, tresn
        write(24,91) (diag(i,j),j=1, tresn)
      enddo


      open (23, file=outfile_3)
      do i=1,pnumber2
       write(23,*) freq(i)!					freq tiene los eigenvalues de la gramiana	
      enddo

      vol=0.0d0
      do i=1,pnumber2
         vol=vol+scpr2(i,i)
      enddo
      vol=vol/dfloat(pnumber2)

      vol3=0.0d0
      do i=1,pnumber2
        vol3=vol3+freq(i) 
      enddo
      new=vol3/freq(pnumber2)!
      vol3=vol3/dfloat(pnumber2)
      
!el promedio de los eigenvalues indica la similtud de los espacios vibracionales (de 0 a 1, sin ponderar). 
! vol3 es el valor original de gramiano. "new": numero de dimensiones principales del mov en comun
!	vol4=vol3/cerdo
!	new=vol3/freq(pnumber2)!	

      open(21, file=outfile_1)
      write(21,*) vol3
      open(22, file=outfile_2)
      write(22,*) new

      close(11)
      close(12)
      close(13)
      close(14)
      close(21)
      close(22)
      close(23)
      close(24)

448   FORMAT (1x,F11.9,1x,F11.9,1x,F11.9)
449   FORMAT(1x,F11.9)      
91	format(10000(1x,F9.6))
92	format(1x,E24.15)
93	format(1i3)
94	format(500(i10))
95      format(1i3,1x,1x,1x,1i6)
96      format(1i3,1x,1x,1x,F9.6)
      end 
