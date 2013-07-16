-module( physics ).

-compile( export_all ).

-define(EPSILON,0).

collide( Ball1, Ball2 ) ->
	{state,VX1,VY1,X1,Y1,R1,M1,G1}  = gen_server:call(Ball1,get_state),
	{state,VX2,VY2,X2,Y2,R2,M2,G2}  = gen_server:call(Ball2,get_state),
	DeltaX = X2-X1,
	DeltaY = Y2-Y1,
	Dist = math:sqrt(math:pow(DeltaX,2) + math:pow(DeltaY,2)),
	case (Dist >= R1 + R2 + ?EPSILON) of 
	   true  -> false;
	   false -> 
		    Masses = M1+M2,
 	            NewVX1 = (VX1*(M1-M2)+(2*M2*VX2))/Masses,
	            NewVY1 = (VY1*(M1-M2)+(2*M2*VY2))/Masses,
	            NewVX2 = (VX2*(M2-M1)+(2*M1*VX1))/Masses,
	            NewVY2 = (VY2*(M2-M1)+(2*M1*VY1))/Masses,

	            gen_server:call(Ball1,{set_state,{state,NewVX1,NewVY1,X1,Y1,R1,M1,G1}}),
	            gen_server:call(Ball2,{set_state,{state,NewVX2,-1*NewVY2,X2,Y2,R2,M2,G2}}),
		    gen_event:notify(event_manager,{collision})
		    		    	    	    	    	
        end
.








