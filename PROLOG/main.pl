/**
* MI-FLP - FitBreak 
* Vojtech Krakora, krakovoj@fit.cvut.cz
*/
numberOfNodes(3).

task1(_):-
	assert(distance(1,2,999)),
	assert(distance(2,1,999)).

task2(_):-
	assert(distance(1,3,10)),
	assert(distance(3,1,10)),
	assert(distance(2,1,20)),
	assert(distance(1,2,20)),
	assert(distance(3,2,50)),
	assert(distance(2,3,50)).

task3(_):-
	assert(distance(1,2,10)),
   assert(distance(1,3,10)),
   assert(distance(1,4,10)),
	assert(distance(2,5,10)),
	assert(distance(3,5,10)),
	assert(distance(4,5,10)),
	assert(distance(5,7,10)),
	assert(distance(6,7,10)),
	assert(distance(7,8,10)),
	assert(distance(6,9,10)),
	assert(distance(7,9,10)),
	assert(distance(8,9,10)),
	assert(distance(2,1,10)),
	assert(distance(3,1,10)),
	assert(distance(4,1,10)),
	assert(distance(5,2,10)),
	assert(distance(5,3,10)),
	assert(distance(5,4,10)),
	assert(distance(7,5,10)),
	assert(distance(7,6,10)),
	assert(distance(8,7,10)),
	assert(distance(9,6,10)),
	assert(distance(9,7,10)),
	assert(distance(9,8,10)).

task4(_):-
	assert(distance(1,2,1)),
	assert(distance(2,3,1)),
	assert(distance(3,6,1)),
	assert(distance(1,4,100)),
	assert(distance(4,5,100)),
	assert(distance(5,6,100)),
	assert(distance(1,3,10)),
	assert(distance(2,6,10)),
	assert(distance(2,1,1)),
	assert(distance(3,2,1)),
	assert(distance(6,3,1)),
	assert(distance(4,1,100)),
	assert(distance(4,5,100)),
	assert(distance(6,5,100)),
	assert(distance(3,1,10)),
	assert(distance(6,2,10)).

/* Solve */
solve(From,To,TotalDist):-
	selectPath(From,To,Path,Dist),
	revers(Path),
	selectPath(From,To,_,Dist2),
	TotalDist is Dist+Dist2,
	(TotalDist >9998 -> writef("Back to jail!");
		write(TotalDist)).
	

/*Second element from list*/	
secondElem(Elem,[Elem|_]).

/* Reverse edges */
revers([]).
revers([_]).
revers([First|Rest]):-
	secondElem(Second,Rest),
	distance(First,Second,Distance),
	NewDist is -Distance,
	retract(distance(First,Second,Distance)),
	retract(distance(Second,First,Distance)),
	assert(distance(Second,First,NewDist)),
	revers(Rest).

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
