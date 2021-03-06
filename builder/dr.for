       	SUBROUTINE DEFLECT(KNT)

*	Calc. of coeffs. of eqns. of DEFLECTOR

      	IMPLICIT DOUBLE PRECISION(A-H,O-Z)
	REAL X4,X5,X6,X7,Y4,Y5,Y6,Y7,BL,BR,BT,ML,MR,MT,L2,L1,L
	REAL GAMMA, SINGAMMA, COSGAMMA, X2, Y2, THETA2
	integer*2 IGEOM(100,6000),IREFL(100,6000),SUM(100000)
      	LOGICAL ANSWER,YES
      	COMMON /COEF/  A(6000),B(6000),C(6000),D(6000),E(6000)
     $      ,F(6000),G(6000),P(6000),Q(6000),R(6000),SA,SB,SC,
     $       SD,SE,SF,SG,SP,SQ,SR,
     $       NREG,NSURF,SLENGTH
      	COMMON /PARA/ X1,Y1,THETA,RLENGTH,RADIUS,HEIGHT,WIDTH,
     $		      X2,Y2,THETA2,REFL_ANSWER
*	DIMENSION IGEOM(100,6000),IREFL(100,6000),SUM(100000)
	DATA YES/'Y'/
	COMMON/GEOM/IREFL,NUMBER_OF_REGIONS

*	Calculations

	READ(3,*)
	READ(3,*) GAMMA

	SINGAMMA = DSIN(GAMMA)
	COSGAMMA = DCOS(GAMMA)

	L2 = WIDTH / SINGAMMA
	L1 = L2 - 2.*WIDTH*SINGAMMA
	L  = L2 - WIDTH*SINGAMMA

	X2 = X1 + L*SINGAMMA
	Y2 = Y1 + L*COSGAMMA
	
      	X3 = SLENGTH
      	Y3 = SLENGTH

	X4 = X1 - WIDTH/2.
	Y4 = Y1

	X5 = X4 + L2*SINGAMMA
	Y5 = Y4 + L2*COSGAMMA

	X7 = X1 + WIDTH/2.
	Y7 = Y1

	X6 = X7 + L1*SINGAMMA
	Y6 = Y7 + L1*COSGAMMA	

	BL = (Y6*X7-Y7*X6) / (X7-X6)
	ML = (Y6-Y7) / (X6-X7)
	BR = (Y5*X4-Y4*X5) / (X4-X5)
	MR = (Y5-Y4) / (X5-X4)
	BT = (Y6*X5-Y5*X6) / (X5-X6)
	MT = (Y6-Y5) / (X6-X5)

*	Entrance

	A(KNT) = 0.0
      	B(KNT) = 0.0
      	C(KNT) = 0.0
      	D(KNT) = 1.0
	E(KNT) = 0.0
      	F(KNT) = 0.0
      	G(KNT) = - Y1
      	P(KNT) = 0.0
	Q(KNT) = 0.0
      	R(KNT) = 0.0

*	Right Side

	A(KNT+1) = 0.0
      	B(KNT+1) = - MR
      	C(KNT+1) = 0.0
      	D(KNT+1) = 1.0
	E(KNT+1) = 0.0
      	F(KNT+1) = 0.0
      	G(KNT+1) = - BR
      	P(KNT+1) = 0.0
	Q(KNT+1) = 0.0
      	R(KNT+1) = 0.0

*	Exit

	A(KNT+2) = 0.0
      	B(KNT+2) = - MT
      	C(KNT+2) = 0.0
      	D(KNT+2) = 1.0
	E(KNT+2) = 0.0
      	F(KNT+2) = 0.0
      	G(KNT+2) = - BT
      	P(KNT+2) = 0.0
	Q(KNT+2) = 0.0
      	R(KNT+2) = 0.0

*	Left side

	A(KNT+3) = 0.0
      	B(KNT+3) = - ML
      	C(KNT+3) = 0.0
      	D(KNT+3) = 1.0
	E(KNT+3) = 0.0
      	F(KNT+3) = 0.0
      	G(KNT+3) = - BL
      	P(KNT+3) = 0.0
	Q(KNT+3) = 0.0
      	R(KNT+3) = 0.0

*	Top

        A(KNT+4) = 0.0
      	B(KNT+4) = 0.0
        C(KNT+4) = 0.0
      	D(KNT+4) = 0.0
      	E(KNT+4) = 0.0
      	F(KNT+4) = 1.0
      	G(KNT+4) = - HEIGHT/2.0
      	P(KNT+4) = 0.0
      	Q(KNT+4) = 0.0
      	R(KNT+4) = 0.0
	

*	Bottom

        A(KNT+5) = 0.0
      	B(KNT+5) = 0.0
        C(KNT+5) = 0.0
      	D(KNT+5) = 0.0
      	E(KNT+5) = 0.0
      	F(KNT+5) = 1.0
      	G(KNT+5) = HEIGHT/2.0
      	P(KNT+5) = 0.0
      	Q(KNT+5) = 0.0
      	R(KNT+5) = 0.0

      	THETA2 = 2.*GAMMA


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
      	
	END

                                                                                                                                                                                                                                                     