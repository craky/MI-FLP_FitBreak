/**
* MI-FLP - FitBreak 
* Vojtech Krakora, krakovoj@fit.cvut.cz
*/
/* Start */
start(_):-
	loadNum(NumberOfNodes),
	NumberOfNodes > 0,
	NumberOfNodes < 999,
	loadNum(NumberOfEdges),
	NumberOfEdges > 0,
	loadAllEdges(NumberOfEdges),
	solve(1,NumberOfNodes,_).

/* Load number */
/* Reads whole line and converts it to a number*/
loadNum(Num):-
	read_line_to_codes(user_input,Line),
	number_codes(Num,Line).

/* Assert edge*/
assertEdge([From, To, Dist]):-
	assert(distance(From,To,Dist)),
	assert(distance(To,From,Dist)).

/* Load all edges */
loadAllEdges(0).
loadAllEdges(Remain):-
	loadEdge(_),
	Remain2 is Remain -1,
	loadAllEdges(Remain2).
	
/* Load edge */
loadEdge(_):-
	read_line_to_codes(user_input,Line),
	atom_codes(Atoms,Line),
	atomic_list_concat(Separated,' ',Atoms),
	maplist(atom_number,Separated,Numbers),
	assertEdge(Numbers).

/* Solve */
solve(From,To,TotalDist):-
	selectPath(From,To,Path,Dist),
	revers(Path),
	selectPath(From,To,_,Dist2),
	TotalDist is Dist+Dist2,
	(TotalDist >9998 -> writef("Back to jail!");
		write(TotalDist)).
	

/* Second element from list */	
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
