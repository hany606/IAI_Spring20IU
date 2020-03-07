comp :-
    random(R),(
    format("~f", [R]),
    (R > 0, R =< 0.5)->
    (
        write("\nLess than 0.5")
    );
    (R > 0.5, R =< 1)->
    (
        write("\nGreater than 0.5")
    )).

valid :-
    false.

test :-
(
    (valid) ->
    (
        write("\n It is valid")  
    );
    write("\n It is not valid")
).

nextUp(X,Y, Xu, Yu) :-
(
    succ(Y, Ynew), Xu is X,
    (
        valid(X,Ynew) -> Yu is Ynew;
        Yu is Y
    )
).

nextDown(X,Y, Xd, Yd) :-
(
    succ(Ynew, Y), Xd is X,
    (
        valid(X,Ynew) -> Yd is Ynew; 
        Yd is Y
    )
).


nextRight(X,Y, Xr, Yr) :-
(
    succ(X, Xnew), Yr is Y,
    (
        valid(Xnew,Y) -> Xr is Xnew;
        Xr is X
    )
).
nextLeft(X,Y, Xl, Yl) :-
(
    succ(Xnew, X), Yl is Y,
    (
        valid(Xnew,Y) -> Xl is Xnew; 
        Xl is X
    )
).

printlst([],N) :-
    format('\n Finish the list!! with length ~d', [N]).

printlst([X,Y|T], N) :-
    write("\n"),
    write(X),
    write(','),
    write(Y),
    succ(N,Nnew),
    printlst(T,Nnew).
    
lengthlst([],0).

lengthlst([_|T],N) :-
    lengthlst(T,Nsub),
    succ(Nsub,N).

lst(X,Y,0,P) :-
    lengthlst(P,N),
    Npath is div(N,2),
    format('Length of the list ~d', [Npath]),
    printlst(P,0).

lst(X,Y,N,P) :-
    succ(Nnew, N),
    lst(X,Y,Nnew,[X,Y|P]).



% Source: https://stackoverflow.com/questions/9088062/count-the-number-of-occurrences-of-a-number-in-a-list
count([],X,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

count([],X,Y,0).
count([X,Y|T],X,Y,Znew):- count(T,X,Y,Z), Znew is 1+Z.
count([X1,Y1|T],X,Y,Z):- (X1\=X;Y1\=Y),count(T,X,Y,Z).

% count([1,2,1,2,1,3,4,5], 1,3,Z).

:- dynamic paths/1.

func :-
    assertz(paths([1,2,3,4,3,4,4,4])),
    assertz(paths([1,2,5,4,5,4,6,4])).


:- dynamic lssst/3.

try :-
    asserta(lsst(1,2,1)),
    asserta(lsst(1,2,2)),
    asserta(lsst(1,2,0)).

min_mod :-
    bagof(V,lsst(1,2,V),List),
    write(List),
    min(List,L),
    write(L).

:- [library(aggregate)].
min(L,M) :- order_by([asc(M)], member(M,L)), !.
