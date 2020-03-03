/*
    Author: Hany Hamed
    Description: File for Rules for Assignment 1 in Intro to AI Spring 2020 Innopolis University
    Resources:
    - https://stackoverflow.com/questions/4805601/read-a-file-line-by-line-in-prolog
    - https://www.swi-prolog.org/pldoc/doc_for?object=re_split/3
    - https://stackoverflow.com/questions/22747147/swi-prolog-write-to-file
    - https://www.swi-prolog.org/pldoc/ 
    - https://stackoverflow.com/questions/32691313/counter-in-prolog (Counter part)
    - https://stackoverflow.com/questions/42466637/decrement-the-same-variable-in-prolog
    - http://rigaux.org/language-study/syntax-across-languages-per-language/Prolog.html
*/

/*
    Assumptions:
        - Walls surrounded the playground, from each side there is a wall (Extra row/column).
*/

param(5,mapSize).

:- dynamic mapBoarders/2.
:- dynamic mapOrcs/2.
:- dynamic mapHumans/2.
:- dynamic mapTouchDown/2.
:- dynamic mapStart/2.
:- dynamic ballPos/2.
:- dynamic visited/2.
:- dynamic path/2.
:- dynamic optimalPathCount/2.

:- dynamic stepscounter/1.

initsteps :-
    retractall(stepscounter(_)),
    assertz(stepscounter(0)).

incrsteps :-
    stepscounter(V),
    retractall(stepscounter(_)),
    succ(V, V1),
    assertz(stepscounter(V1)).

decrsteps :-
    stepscounter(V),
    retractall(stepscounter(_)),
    succ(V0, V),
    assertz(stepscounter(V0)).


ballPos(0,0).


resetMap :-
    retractall(mapBoarders(_,_)),
    retractall(mapHumans(_,_)),
    retractall(mapOrcs(_,_)),
    retractall(mapTouchDown(_,_)),
    retractall(mapStart(_,_)).
    
initBoarders(0) :- 
    asserta(mapBoarders(0,0)),
    param(Z, mapSize),
    Znew is Z +1,
    asserta(mapBoarders(Znew,0)),
    asserta(mapBoarders(0,Znew)),
    asserta(mapBoarders(Znew,Znew)), !.

initBoarders(N) :-
    asserta(mapBoarders(0,N)),
    asserta(mapBoarders(N,0)),
    param(Z,mapSize),
    succ(Z,Znew),
    asserta(mapBoarders(Znew,N)),
    asserta(mapBoarders(N,Znew)),
    succ(Nnew, N),
    initBoarders(Nnew).

initMap :-
    param(Z,mapSize),
    succ(Z, Znew),
    initBoarders(Znew),
    o(Xo,Yo),
    asserta(mapOrcs(Xo,Yo)),
    h(Xh,Yh),
    asserta(mapHumans(Xh,Yh)),
    t(Xt,Yt),
    asserta(mapTouchDown(Xt,Yt)),
    s(Xs,Ys),
    asserta(mapStart(Xs,Ys)),
    changeBallPos(Xs,Ys),
    asserta(visited(Xs,Ys)),
    PathLimitCount is Z*Z,
    asserta(optimalPathCount(PathLimitCount,0)),
    initsteps.

restartMap :-
    resetMap,
    initMap.



% valid(X,Y) :-
%     param(Z,mapSize),
%     X > 0, X =< Z,
%     Y > 0, Y =< Z.
    
valid(X,Y) :-
    not(mapBoarders(X,Y)),
    not(mapOrcs(X,Y)),
    not(visited(X,Y)).

reached(X,Y) :-
    mapTouchDown(X,Y),
    visited(Xv,Yv),
    asserta(path(Xv,Yv)),
    write("\n----------Reached!!!----------\n").


% This only will make it search once
% backtrackSearch(X,Y) :-
%     asserta(visited(X,Y)),
%     reached(X,Y);
%     move(X,Y),
%     pass(X,Y).


% Save the path
great(X,Y) :-
    stepscounter(N),
    format("Great !!! ~d ~d in ~d steps", [X,Y,N]),
    write("\n----------Reached!!!----------\n"),
    optimalPathCount(Best,C),
    retractall(optimalPathCount(_,_)),
    ((N < Best) -> (assertz(optimalPathCount(N,0))); 
    (N == Best) -> (succ(C, Cnew), assertz(optimalPathCount(N,Cnew))))
    ,
    optimalPathCount(Nnew,_),
    format("\n Great new optimal path count: ~d", [Nnew]).



% This to limit the backtrack to the best result we have till now or not
checkOptimalPath :-
    optimalPathCount(Best,_),
    stepscounter(N),
    format("\n Steps for now ~d, optimal path count: ~d", [N, Best]),
    not(N > Best).
    % true.

backtrackSearch(X,Y) :-
    reached(X,Y) -> (asserta(visited(X,Y)), great(X,Y)); 
    not(reached(X,Y)) ->  
    (   asserta(visited(X,Y)),
        not(checkOptimalPath) -> (write("\n Not optimal path, discarded"));
        checkOptimalPath -> (move(X,Y), pass(X,Y))
    ).

randomSearch(X,Y) :-
    true.

aStarSearch(X,Y) :-
    true.

hillClimberSearch(X,Y) :-
    true.

qTableRL(X,Y) :-
    true.

pass(X,Y) :-
    true.

move(X,Y) :-
    stepscounter(N),
    format('\n ----Step---- ~d', [N]),
    format('\n#Current in ~d ~d and deciding', [X,Y]),
    incrsteps,
    nextUp(X,Y,Xu,Yu),
    format('\nUp to ~d ~d', [Xu, Yu]),
    backtrackSearch(Xu,Yu),
    retract(visited(Xu,Yu));
    nextDown(X,Y,Xd,Yd),
    format('\nDown to ~d ~d', [Xd, Yd]),
    backtrackSearch(Xd,Yd),
    retract(visited(Xd,Yd));
    nextRight(X,Y,Xr,Yr),
    format('\nRight to ~d ~d', [Xr, Yr]),
    backtrackSearch(Xr,Yr),
    retract(visited(Xr,Yr));
    nextLeft(X,Y,Xl,Yl),
    format('\nLeft to ~d ~d', [Xl, Yl]),
    backtrackSearch(Xl,Yl),
    retract(visited(Xl,Yl)),
    decrsteps.


nextRight(X,Y, Xr, Yr) :-
    Yr is Y,
    Xnew is X +1,
    valid(Xnew,Y),
    Xr is Xnew.

nextLeft(X,Y, Xl, Yl) :-
    Yl is Y,
    Xnew is X -1,
    valid(Xnew,Y),
    Xl is Xnew.

nextUp(X,Y, Xu, Yu) :-
    Xu is X,
    Ynew is Y +1,
    valid(X,Ynew),
    Yu is Ynew.

nextDown(X,Y, Xd, Yd) :-
    Xd is X,
    Ynew is Y -1,
    valid(X,Ynew),
    Yd is Ynew.

changeBallPos(X,Y) :-
    retractall(ballPos(_,_)),
    assert(ballPos(X,Y)).


main :-
    consult("input.pl"),
    s(Xs,Ys),
    resetMap,
    initMap,
    Ns is 0,
    backtrackSearch(Xs,Ys),
    randomSearch(Xs,Ys),
    aStarSearch(Xs,Ys),
    hillClimberSearch(Xs,Ys),
    qTableRL(Xs,Ys).

% empty (X,Y):-
%     \+ o(X,Y),
%     \+ h(X,Y).
