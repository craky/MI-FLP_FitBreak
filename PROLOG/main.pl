/**
* MI-FLP - FitBreak 
* Vojtech Krakora, krakovoj@fit.cvut.cz
*/
numberOfNodes(3).

distance(1,3,10).
distance(3,1,10).
distance(2,1,20).
distance(1,2,20).
distance(3,2,50).
distance(2,3,50).
/* Testing distances */
distance(3,4,70).
distance(4,3,70).
distance(4,5,2).
distance(5,4,2).
distance(0,2,15).
distance(2,0,15).

/* Minimum */
minimum([Front|Back],Min):- minimum(Back,Front,Min).
minimum([],Min,Min).
minimum([[Path,Length]|Rest],[M1,M2],Min):-
	(Length < M2 -> minimum(Rest,[Path,Length],Min);
		minimum(Rest,[M1,M2],Min)).
		
/* Invert list L and store it to the result R */
invert(L,R):- invert(L,[],R).

invert([],R,R).
invert([X|L],L2,R):- invert(L,[X|L2],R).
/* Finds path P from U to V. Returns distance D. */
path(U,V,P,D):- path(U,V,P,[],D).

path(U,V,P,R,D):- distance(U,V,D),invert([V,U|R],P).
path(U,V,P,R,D):- distance(U,Y,L), Y \== V,
						\+member(Y,R),
						path(Y,V,P,[U|R],D2),
						D is L+D2.
/* Select the shortest path from all */
/* (Source, Destination, Path, Length) */
selectPath(S,D,P,L):-
	bagof([P2,L2],path(S,D,P2,L2),R)->
		minimum(R,[P,L]);L is 9999.%9999 is infinity
