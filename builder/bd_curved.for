        SUBROUTINE BENDER(KNT)

*	Calc. of coeffs. of eqns. with circular "XY"-plane cross-section.

*	This bender is based on a curved guide.	

	IMPLICIT  DOUBLE PRECISION(A-H,O-Z)
        LOGICAL ANSWER,YES,REFL_ANSWER
	integer*2 IGEOM(100,6000),IREFL(100,6000),SUM(100000)  
	INTEGER*2 SURFLAG(10000), NODIV
	REAL SEPDIV, INT_COEF,GAMMB_BEND,POL_EFF, ORIENT
	REAL HW
	COMMON /BEND/SURFLAG,NODIV,INT_COEF,POL_EFF,GAMMB_BEND,ORIENT
        COMMON /COEF/ A(6000),B(6000),C(6000),D(6000),E(6000)
     $             ,F(6000),G(6000),P(6000),Q(6000),R(6000)
     $       ,SA,SB,SC,SD,SE,SF,SG,SP,SQ,SR,NREG,NSURF,SLENG
         COMMON /PARA/ X1,Y1,THETA,RLENG,RADIUS,HEIGHT,WIDTH,
     $		       X2,Y2,THETA2,REFL_ANSWER
         DATA YES/'Y'/
*	DIMENSION IGEOM(100,6000),IREFL(100,6000),SUM(100000)  
	COMMON/GEOM/IREFL,NUMBER_OF_REGIONS


*	Reading in number of internal surfaces
	READ(3,*)
	READ(3,*) NODIV
*	Reading in reflection coefficient of internal surfaces
	READ(3,*)                              
	READ(3,*) GAMMB_BEND,INT_COEF,POL_EFF,ORIENT
* 	READ(3,*) GAMMB_BEND
 

*	OPEN(UNIT=3,FILE='BR3.INPUT',STATUS='OLD')	

*	converting TOR into radians
	ORIENT = ORIENT * 0.017453293

      	PHI = RLENG/RADIUS
      	ALPHA = SLENG/RADIUS

	THETA = THETA + ORIENT

	phi = -phi
	radius=-radius
	alpha=-alpha


102  	XR=X1 + RADIUS*DCOS(THETA)
      	YR=Y1 - RADIUS*DSIN(THETA)
      	X2=XR - RADIUS*DCOS(THETA+PHI)
      	Y2=YR + RADIUS*DSIN(THETA+PHI)
      	X3=XR - RADIUS*DCOS(THETA+PHI+ALPHA)-X2
      	Y3=YR + RADIUS*DSIN(THETA+PHI+ALPHA)-Y2
*      	WRITE(6,1030) XR,YR

	PRINT*,'The centre is at x:',xr,' y:',yr

101   	CONTINUE

	WRITE(6,1030) XR,YR


	SEPDIV = WIDTH/(NODIV + 1)

	

*	Entrance

        B(KNT)=(Y1-YR)
        D(KNT)=XR-X1
        G(KNT)=-Y1*(XR-X1) + X1*(YR-Y1)

*	Right side

        A(KNT+1) = 1.0
        B(KNT+1) = -2.0*XR
        C(KNT+1) = 1.0
        D(KNT+1) = -2.0*YR
        G(KNT+1) = (YR*YR) + (XR*XR) 
     +         - ((RADIUS-WIDTH/2.0)*(RADIUS-WIDTH/2.0))
                                             
*	Exit

        B(KNT+2)=(Y2-YR)
        D(KNT+2)=(XR-X2)
        G(KNT+2)=(-Y2*(XR-X2)) + (X2*(YR-Y2))

*	Left side

        A(KNT+3)=A(KNT+1)
        B(KNT+3)=B(KNT+1)
        C(KNT+3)=C(KNT+1)
        D(KNT+3)=D(KNT+1)
        G(KNT+3)=(YR*YR) + (XR*XR) 
     +       - ((RADIUS+WIDTH/2.0)*(RADIUS+WIDTH/2.0))

*	Top

        B(KNT+4)=0.0
        D(KNT+4)=0.0
        F(KNT+4)=1.0
        G(KNT+4)=(-HEIGHT)/2.0

*	Bottom

        B(KNT+5)=0.0
        D(KNT+5)=0.0
        F(KNT+5)=1.0
        G(KNT+5)=(HEIGHT)/2.0

*	DO I = 1, 6
*	SURFLAG(KNT-1+I)=0
*	ENDDO

	SURFLAG(KNT) = 0
	SURFLAG(KNT+1) = 1
        SURFLAG(KNT+2) = 0
	SURFLAG(KNT+3) = 1
	SURFLAG(KNT+4) = 0
	SURFLAG(KNT+5) = 0

	HW = WIDTH/2

*	Internal surfaces

        DO I = 1, NODIV
        A(KNT+5+I)=A(KNT+1)
        B(KNT+5+I)=B(KNT+1)
        C(KNT+5+I)=C(KNT+1)
        D(KNT+5+I)=D(KNT+1)
        G(KNT+5+I)=(YR*YR) + (XR*XR) 
     +     - (((RADIUS + HW - (I*SEPDIV)))*((RADIUS+HW-(I*SEPDIV))))
 
        SURFLAG(KNT+5+I) = 1

	ENDDO

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
                IREFL(I,KNT+4) = 0
                IREFL(I,KNT+5) = 0
        
        	DO J=1,NODIV
			IREFL(I,KNT+5+J) = 1
		ENDDO  
	ENDDO
        ELSE
        DO I = 1,NUMBER_OF_REGIONS
                IREFL(I,KNT) = 0
                IREFL(I,KNT+1) = 0
                IREFL(I,KNT+2) = 0
                IREFL(I,KNT+3) = 0
                IREFL(I,KNT+4) = 0
                IREFL(I,KNT+5) = 0
        
        	DO J=1,NODIV
			IREFL(I,KNT+5+J) = 0
		ENDDO  
	ENDDO
        ENDIF


        RETURN

273	FORMAT(4F10.6)
1030	FORMAT(' CENTRE POSITION ',/,' XR = ', D15.8,/,
     $	       'YR = ',D15.8)
1035    FORMAT(A1)

	END

                                                                                                                                                                                                                                                                     