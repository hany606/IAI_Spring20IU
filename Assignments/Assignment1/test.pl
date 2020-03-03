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