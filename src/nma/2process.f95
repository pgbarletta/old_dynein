program processer
implicit none

integer, parameter :: ikind=selected_real_kind(p=6)! p= 6, 15 o 18 (nro de figuras)
integer, parameter :: jkind=selected_real_kind(p=15)! p= 6, 15 o 18 (nro de figuras)
character*20 infile_1, infile_2, outfile
character*6 donor(400), acceptor(400)
character*80  file1(3000)
integer i, j, k, t, n, m, flag, ierr
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! este codigo copia los Bfactors de un .pdb a otro, siempre q este otro tenga 0.00
! en donde deberia estar su Bftor
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

i=0
j=0
k=0
t=0
n=0
m=0
call getarg (1, infile_1)! este tiene los bftors
call getarg (2, outfile)! esta es el infile_2 luego de agregar los bftors
open (11, file=infile_1)	
open (21, file=outfile)	
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!! extrae del alineamiento !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
do
	n= n +1
	read (11, 91, iostat= ierr) file1(n)
	if ( ierr/= 0 ) exit
enddo

do i=9, n-1, 1
	donor(i)=file1(i)(3:5)
	acceptor(i)=file1(i)(17:19)
enddo

do i=9, n-1, 1
                write(21,92) donor(i), acceptor(i)
enddo

close(11)
close(12)
close(21)
91	format(1a75)
92	format(2a4)
93	format(2a80)

end program processer 


