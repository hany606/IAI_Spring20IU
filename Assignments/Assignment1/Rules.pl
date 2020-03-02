/*
    Author: Hany Hamed
    Description: File for Rules for Assignment 1 in Intro to AI Spring 2020 Innopolis University
    Resources:
    - https://stackoverflow.com/questions/4805601/read-a-file-line-by-line-in-prolog
    - https://www.swi-prolog.org/pldoc/doc_for?object=re_split/3
    - https://stackoverflow.com/questions/22747147/swi-prolog-write-to-file
    - https://www.swi-prolog.org/pldoc/ 
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
    Znew is Z +1,
    asserta(mapBoarders(Znew,N)),
    asserta(mapBoarders(N,Znew)),
    Nnew is N -1,
    initBoarders(Nnew).

initMap :-
    param(Z,mapSize),
    initBoarders(Z),
    o(Xo,Yo),
    asserta(mapOrcs(Xo,Yo)),
    h(Xh,Yh),
    asserta(mapHumans(Xh,Yh)),
    t(Xt,Yt),
    asserta(mapTouchDown(Xt,Yt)),
    s(Xs,Ys),
    asserta(mapStart(Xs,Ys)),
    changeBallPos(Xs,Ys),
    asserta(visited(Xs,Ys)).


restartMap :-
    clearMap,
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
    write(Xv), write(Yv),
    write("\n----------Reached!!!----------\n").

search(X,Y) :-
    % search(X+1,Y).
    asserta(visited(X,Y)),
    reached(X,Y);
    move(X,Y),
    pass(X,Y).



pass(X,Y) :-
    true.


move(X,Y) :-
    format('\n#Current ~d ~d', [X,Y]),
    nextUp(X,Y,Xu,Yu),
    format('\nUp ~d ~d', [Xu, Yu]),
    search(Xu,Yu),
    retract(visited(Xu,Yu));
    nextDown(X,Y,Xd,Yd),
    format('\nDown ~d ~d', [Xd, Yd]),
    search(Xd,Yd),
    retract(visited(Xd,Yd));
    nextRight(X,Y,Xr,Yr),
    format('\nRight ~d ~d', [Xr, Yr]),
    search(Xr,Yr),
    retract(visited(Xr,Yr));
    nextLeft(X,Y,Xl,Yl),
    format('\nLeft ~d ~d', [Xl, Yl]),
    search(Xl,Yl),
    retract(visited(Xl,Yl)).
    

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
    consult("input.txt"),
    s(Xs,Ys),
    initMap ,
    search(Xs,Ys).

% empty (X,Y):-
%     \+ o(X,Y),
%     \+ h(X,Y).
