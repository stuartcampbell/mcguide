
        SUBROUTINE CIRC(KNT)

*	Calc. of coeffs. of eqns. with circular "XY"-plane cross-section.
	
	IMPLICIT  DOUBLE PRECISION(A-H,O-Z)
	INTEGER NUMBER_OF_REGIONS
 	integer*2 IGEOM(100,6000),IREFL(100,6000),SUM(100000)
 
        LOGICAL ANSWER,YES,REFL_ANSWER
        COMMON /COEF/ A(6000),B(6000),C(6000),D(6000),E(6000)
     $             ,F(6000),G(6000),P(6000),Q(6000),R(6000)
     $       ,SA,SB,SC,SD,SE,SF,SG,SP,SQ,SR,NREG,NSURF,SLENG
         COMMON /PARA/ X1,Y1,THETA,RLENG,RADIUS,HEIGHT,WIDTH,
     $		       X2,Y2,THETA2,REFL_ANSWER
         DATA YES/'Y'/
*	DIMENSION IGEOM(100,6000),IREFL(100,6000),SUM(100000)
 	COMMON/GEOM/IREFL,NUMBER_OF_REGIONS

* 	OPEN(UNIT=3,FILE='BR.IN',STATUS='OLD')	

      	PHI = RLENG/RADIUS
      	ALPHA = SLENG/RADIUS

	RADIUS = -RADIUS
      	PHI = -PHI
      	ALPHA = -ALPHA

102  	XR=X1 + RADIUS*DCOS(THETA)
      	YR=Y1 - RADIUS*DSIN(THETA)
      	X2=XR - RADIUS*DCOS(THETA+PHI)
      	Y2=YR + RADIUS*DSIN(THETA+PHI)
      	X3=XR - RADIUS*DCOS(THETA+PHI+ALPHA)-X2
      	Y3=YR + RADIUS*DSIN(THETA+PHI+ALPHA)-Y2
*      	WRITE(6,1030) XR,YR

*	PRINT*,X2,Y2,X3,Y3

*	READ(3,*)
*       READ(3,1035) ANSWER
*      	WRITE(6,1035) ANSWER
*      	IF (ANSWER.EQ.YES) GOTO 101
	      	
*       	GOTO 102

	read(3,*)
	read(3,*)
	read(3,*)
	read(3,*)


101   	CONTINUE

*	Entrance

        B(KNT)=(Y1-YR)
        D(KNT)=XR-X1
        G(KNT)=-Y1*(XR-X1) + X1*(YR-Y1)

*	Right side

        A(KNT+1)=1.0
        B(KNT+1)=-2.0*XR
        C(KNT+1)=1.0
        D(KNT+1)=-2.0*YR
        G(KNT+1)=YR*YR + XR*XR - (RADIUS-WIDTH/2.0)*(RADIUS-WIDTH/2.0)

*	Exit

        B(KNT+2)=(Y2-YR)
        D(KNT+2)=XR-X2
        G(KNT+2)=-Y2*(XR-X2) + X2*(YR-Y2)

*	Left side

        A(KNT+3)=A(KNT+1)
        B(KNT+3)=B(KNT+1)
        C(KNT+3)=C(KNT+1)
        D(KNT+3)=D(KNT+1)
        G(KNT+3)=YR*YR + XR*XR - (RADIUS+WIDTH/2.0)*(RADIUS+WIDTH/2.0)

*	Top

        B(KNT+4)=0.0
        D(KNT+4)=0.0
        F(KNT+4)=1.0
        G(KNT+4)=-HEIGHT/2.0

*	Bottom

        B(KNT+5)=0.0
        D(KNT+5)=0.0
        F(KNT+5)=1.0
        G(KNT+5)=HEIGHT/2.0

*	Sample plane with respect to exit

        SA=A(1)
        SB=Y3-YR
        SC=C(1)
        SD=XR-X3
        SE=E(1)
        SF=F(1)
        SG=-Y3*(XR-X3)+X3*(YR-Y3)
        SP=P(1)
        SQ=Q(1)
        SR=R(1)

        THETA2 = THETA+PHI


	IF(REFL_ANSWER.EQ.YES.OR.REFL_ANSWER.EQ.yes) THEN
	DO I = 1,NUMBER_OF_REGIONS
   		IREFL(I,KNT) = 0
   		IREFL(I,KNT+1) = 1
       		IREFL(I,KNT+2) = 0
      		IREFL(I,KNT+3) = 1
      		IREFL(I,KNT+4) = 1
		IREFL(I,KNT+5) = 1
	ENDDO
	ELSE
	DO I = 1,NUMBER_OF_REGIONS
		IREFL(I,KNT) = 0
		IREFL(I,KNT+1) = 0
		IREFL(I,KNT+2) = 0
		IREFL(I,KNT+3) = 0
		IREFL(I,KNT+4) = 0
		IREFL(I,KNT+5) = 0
	ENDDO
	ENDIF


        RETURN

1030	FORMAT(' CENTRE POSITION ',/,' XR = ', D15.8,/,
     $	       'YR = ',D15.8)
1035    FORMAT(A1)

	END

                                                                                                                                                                                            