guess_num :- loop(start).

loop(15) :- write('You Guessed it').

loop(X) :-
	X \= 15,
	write('Guess Number '),
	read(Guess),
	write(Guess),
	write(' is not the number'), nl,
	loop(Guess).
