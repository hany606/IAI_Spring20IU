printlst([]).

printlst([X,Y,Ty|T]) :-
    format('~w(~d,~d), ', [Ty,X,Y]),
    printlst(T).


% Source: Lab(intro to prolog2) slides
lengthlst([],0).

lengthlst([X,Y,Ty|T],N) :-
    lengthlst(T,Nsub),
    succ(Nsub,N).

% Based on (Source): https://stackoverflow.com/questions/9088062/count-the-number-of-occurrences-of-a-number-in-a-list
% Counnt number of times that X,Y exists in a list
count([],_,_,_,0).
count([X,Y,Ty|T],X,Y,Ty,Znew):- count(T,X,Y,Ty,Z), Znew is 1+Z.
count([X1,Y1,Ty1|T],X,Y,Ty,Z):- (X1\=X;Y1\=Y),count(T,X,Y,Ty,Z).

% lst(X,Y,0,P) :-
%     printlst(P,0).

% lst(X,Y,N,P) :-
%     succ(Nnew, N),
%     lst(X,Y,Nnew,[X,Y|P]).

