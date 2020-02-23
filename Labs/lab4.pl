mother(my_mother_name, me).
father(my_father_name, me).
%parents(my_father_name me).
%parents(my_mother_name, me).
brother(my_brother1,me).
sister(my_sister1,me).

father(my_grand_father_name, my_father_name).
mother(my_grand_mother_name, my_father_name).

%children(my_child1,me).

who_parents(X) :-
	father(F,X),
	mother(M,X),
	writeln(F),
	writeln(M).

%who_children(my_father_name, my_mother_name).
who_children(F,M) :-
	father(F,X), 
	mother(M,X),
	writeln(X).

who_siblings(X) :-
	brother(B,X),
	sister(S,X),
	writeln(B),
	writeln(S).

		




