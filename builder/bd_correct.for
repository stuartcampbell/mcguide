        SUBROUTINE BENDER(KNT)

*	Calc. of coeffs. of eqns. with circular "XY"-plane cross-section.

*	This bender is based on a the actual physical shape.	

	IMPLICIT  DOUBLE PRECISION(A-H,O-Z)
        LOGICAL ANSWER,YES,REFL_ANSWER
	integer*2 IGEOM(100,6000),IREFL(100,6000),SUM(100000)  
	INTEGER*2 SURFLAG(10000), NODIV
	INTEGER LIMIT
	REAL SEPDIV, INT_COEF,GAMMB_BEND,POL_EFF, ORIENT
	REAL HW, STRAIGHT, LOS, ETA, RESULT1, RESULT2,A1,B1,C1
	REAL XM, YM, CONST1, GRAD1,XROOT1,XROOT2,YROOT1,YROOT2
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
	OPEN(UNIT=11,FILE='BEND_EQU.DAT',STATUS='NEW')	



*	converting ORIENTATION ANGLE into radians
	ORIENT = ORIENT * 0.017453293


      	PHI = RLENG/RADIUS
*      	ALPHA = SLENG/RADIUS

	THETA = THETA + ORIENT        

	phi = -phi
	radius = -radius
*	alpha=-alpha

	RESULT2 = THETA - (PHI/2)

     	PRINT*,'RESULT2 =',RESULT2
     	
       	HW = WIDTH/2     
	
        STRAIGHT = 2*RADIUS*DSIN(PHI/2)

	X2 = X1 + STRAIGHT*DSIN(THETA)
        Y2 = Y1 + STRAIGHT*DCOS(THETA)

	PRINT*,'X1: ',X1,' Y1: ',Y1
   	PRINT*,'X2: ',X2,' Y2: ',Y2
   
	X3 = SLENG*DSIN(THETA)
	Y3 = SLENG*DCOS(THETA)

101   	CONTINUE
                                  
	SEPDIV = WIDTH/(NODIV + 1)
	
	LOS = SQRT(8*SEPDIV*DABS(RADIUS))
	                          
	print*,'The straight length of the bender is:',straight
        print*,'The line-of-sight is',LOS                          

*	Entrance

        B(KNT) = WIDTH*DSIN(THETA) 
        D(KNT) = WIDTH*DCOS(THETA) 
        G(KNT) = -WIDTH*(Y1*DCOS(THETA) + X1*DSIN(THETA))
                        
*	Calculating (XR,YR) for the right side of the guide
                                                              
        XR = (X1 + (HW*DCOS(THETA))) + RADIUS*DCOS(RESULT2)
	YR = (Y1 - (HW*DSIN(THETA))) - RADIUS*DSIN(RESULT2)

	PRINT*,'XR:', XR,' YR:',YR               
	print*,'for surface ',knt+1,'xr= ',xr,' yr= ',yr                    
                       
*	Right side

        A(KNT+1) = 1.0
        B(KNT+1) = -2.0*XR
        C(KNT+1) = 1.0
        D(KNT+1) = -2.0*YR
        G(KNT+1) = (YR*YR) + (XR*XR) - (RADIUS*RADIUS)
                        

*	Exit

        B(KNT+2) = B(KNT)
        D(KNT+2) = D(KNT)
        G(KNT+2) = -WIDTH*(Y2*DCOS(THETA) + X2*DSIN(THETA))

*	Calculating XR,YR for the left side of the polarizer
                                                              
*	XR = X1-(HW*DCOS(THETA)) + RADIUS*DCOS(THETA) 	
*        YR = Y1+(HW*DSIN(THETA)) - RADIUS*DSIN(THETA)
      
    	XR = (X1 - (HW*DCOS(THETA))) + RADIUS*DCOS(RESULT2)
	YR = (Y1 + (HW*DSIN(THETA))) - RADIUS*DSIN(RESULT2)
                                                              
	print*,'for surface ',knt+3,'xr= ',xr,' yr= ',yr                    
*	Left side

        A(KNT+3) = 1.0
        B(KNT+3) = -2.0*XR
        C(KNT+3) = 1.0
        D(KNT+3) = -2.0*YR
        G(KNT+3) = (YR*YR) + (XR*XR) - (RADIUS*RADIUS)

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
                         

*	Internal surfaces

        DO I = 1, NODIV

*	Need to calculate XR,YR for each internal surface.
                                                                  
	XR = (X1 - (HW*DCOS(THETA)) + (I*SEPDIV)*DCOS(THETA))
     $		+ RADIUS*DCOS(RESULT2)
	YR = (Y1 + (HW*DSIN(THETA)) - (I*SEPDIV)*DSIN(THETA))
     $		- RADIUS*DSIN(RESULT2)
                                 
*	PRINT*,'XR =',XR,'YR =',YR

        A(KNT+5+I) = 1.0
        B(KNT+5+I) = -2.0*XR
        C(KNT+5+I) = 1.0
        D(KNT+5+I) = -2.0*YR
	G(KNT+5+I) = (YR*YR) + (XR*XR) - (RADIUS*RADIUS)
 
        SURFLAG(KNT+5+I) = 1

	ENDDO

	DO I = 1, 4
        WRITE(11,*) A(KNT+I-1), B(KNT+I-1), C(KNT+I-1), D(KNT+I-1)
	WRITE(11,*) G(KNT+I-1), P(KNT+I-1)
	ENDDO

	WRITE(11,*) A(KNT+6), B(KNT+6), C(KNT+6), D(KNT+6)
	WRITE(11,*) G(KNT+6), P(KNT+6)
	

*	Sample plane with respect to exit

        SA = A(1)
        SB = B(KNT)
        SC = C(1)
        SD = D(KNT)
        SE = E(1)
        SF = F(1)
        SG = -WIDTH*(Y3*DCOS(THETA)+X3*DSIN(THETA))
        SP = P(1)
        SQ = Q(1)
        SR = R(1)

        THETA2 = THETA


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

	REWIND(11)
	CLOSE(11)


        RETURN

273	FORMAT(4F10.6)
1030	FORMAT(' CENTRE POSITION ',/,' XR = ', D15.8,/,
     $	       'YR = ',D15.8)
1035    FORMAT(A1)

	END

                                                                                                                                                                                                                                                                                                                                  