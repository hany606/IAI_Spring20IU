printlst([]).

printlst([X,Y|T]) :-
    format('(~d,~d), ', [X,Y]),
    printlst(T).

% Source: Lab(intro to prolog2) slides
lengthlst([],0).

lengthlst([_|T],N) :-
    lengthlst(T,Nsub),
    succ(Nsub,N).

% Based on (Source): https://stackoverflow.com/questions/9088062/count-the-number-of-occurrences-of-a-number-in-a-list
count([],_,_,0).
count([X,Y|T],X,Y,Znew):- count(T,X,Y,Z), Znew is 1+Z.
count([X1,Y1|T],X,Y,Z):- (X1\=X;Y1\=Y),count(T,X,Y,Z).

% lst(X,Y,0,P) :-
%     printlst(P,0).

% lst(X,Y,N,P) :-
%     succ(Nnew, N),
%     lst(X,Y,Nnew,[X,Y|P]).

