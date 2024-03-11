!Author: Gustavo Bravo
!How to compile: gfortran atoms2dst.f90 -o atoms2dst.exec
!How to call: ./atoms2dst.exec fileName distStep
!   fileName: name of the file to measure distance between atoms
!   distStep: integer steps to take between atoms to measure
! This program takes as input either position files, PDB files
! The output of this program is fileName.dst, with the last four
!  character elemnts replaced by .dst
PROGRAM DRIVER
 IMPLICIT REAL*8(A-H,O-Z)
 ALLOCATABLE  Atoms(:,:)
 CHARACTER(LEN=80), ALLOCATABLE :: argValue(:)
 CHARACTER(80) fName 
!Argument retriever block:
 nArgCount = COMMAND_ARGUMENT_COUNT()        ! Get the number of arguments
 ALLOCATE(argValue(nArgCount))               ! Allocate memory for storing arguments
 DO i = 1, nArgCount
  CALL GET_COMMAND_ARGUMENT(i, argValue(i))  ! Retrieve command line arguments
  END DO
 IF(nArgCount.NE.2)STOP 'PROGRAM NEEDS EXACTLY 2 ARGUMENTS'
 
 READ(argValue(1),"(A)") fName
 READ(argValue(2),*) nStep
 CALL sizeRet(nAtm,fName,nFlag)
 ALLOCATE(Atoms(3,nAtm))
 CALL posRet(nAtm,Atoms,fName,nFlag)      !Position Retriever
 CALL length(nAtm,Atoms,fName,nStep)      !Measures distances between atoms
 STOP
END PROGRAM

SUBROUTINE sizeRet(nAtm,fName,nFlag)      ! Size Retriever
 IMPLICIT REAL*8(A-H,O-Z)
 CHARACTER*80 fName, comm

 nAtm =0
 nFlag=0
!For PDB files this block will count the amount of atoms:
 WRITE(comm,"(3A)") 'grep -c ATOM ', TRIM(fName) ,'> numb'
 CALL SYSTEM(comm)
 OPEN(UNIT=1,FILE='numb',STATUS='OLD')
 inquire(unit=1, SIZE=nSize) 
 IF(nSize.EQ.0) GOTO 2020 !If numb is empty -> file is not pdb
 REWIND(1)
 READ(1,*) nAtm
 2020 CONTINUE
 CLOSE(1)
 CALL SYSTEM('rm -fr numb')
!For coordinates-only files, this block will count the amount of atoms
 IF(nAtm.EQ.0)THEN
  nFlag=1
  print "(A)", fName
  OPEN(UNIT=2,FILE=trim(fName),STATUS='OLD')
  DO WHILE(1.EQ.1)
   READ(2,*,END=200)comm
   nAtm=nAtm+1
  END DO
  200 CONTINUE
 END IF
CLOSE(2)
END SUBROUTINE

SUBROUTINE posRet(nAtm,Atoms,fName,nFlag)  !Position Retriever
 IMPLICIT REAL*8(A-H,O-Z)
 CHARACTER*80 fName
 CHARACTER*4 row,cDumb
 DIMENSION Atoms(3,nAtm)
 
 IF(nFlag.EQ.0)THEN
  OPEN(UNIT=10,FILE=fName,STATUS='OLD')    
  REWIND(10)
  DO I=1,nAtm
   100   CONTINUE      
   READ(10,*) row
   IF(row.NE.'ATOM')GOTO 100                !Check if line has data
   BACKSPACE(10)
   READ(10,700) (Atoms(J,I),J=1,3)          !Read positions
  END DO
 ELSE IF(nFlag.EQ.1)THEN
  OPEN(UNIT=10,FILE=fName,STATUS='OLD')    
  REWIND(10)
  DO I=1,nAtm
   READ(10,800) (Atoms(J,I),J=1,3)          !Read positions
   END DO
 ELSE 
  STOP 'nFlag is corrupted'
 END IF

 700  FORMAT (31X,3(F7.3,1X))
 800  FORMAT (2(E24.18,1X),E24.18)
END SUBROUTINE

SUBROUTINE length(nAtm,Atoms,fName,nStep) !Measures distances between atoms
IMPLICIT REAL*8(A-H,O-Z)                  
DIMENSION Atoms(3,nAtm)
CHARACTER*80 fName

CALL denamer(fName) 
OPEN(UNIT=11,FILE=trim(fName)//'.dst',STATUS='REPLACE')

DO I=1,nAtm-nStep
 dist= SQRT( ( ATOMS(1,I)-ATOMS(1,I+nStep) )**2 + &
             ( ATOMS(2,I)-ATOMS(2,I+nStep) )**2 + &
             ( ATOMS(3,I)-ATOMS(3,I+nStep) )**2 )
!WRITE(11,900)I,I+nStep,dist 
 WRITE(11,"(f7.3)")dist 
END DO 
CLOSE(11)

900 FORMAT(2(I5,','),F7.3)
END SUBROUTINE

SUBROUTINE denamer(fName) !takes out the last for characters of the file's name
IMPLICIT REAL*8(A-H,O-Z)
CHARACTER*80 fName
l=LEN(trim(fName))
fName = TRIM(fName(1:l-4))

END SUBROUTINE
