/*
    Author: Hany Hamed
    Description: File for Rules for Assignment 1 in Intro to AI Spring 2020 Innopolis University
    Resources:
    - https://stackoverflow.com/questions/4805601/read-a-file-line-by-line-in-prolog
    - https://www.swi-prolog.org/pldoc/doc_for?object=re_split/3
    - https://stackoverflow.com/questions/22747147/swi-prolog-write-to-file
    - https://www.swi-prolog.org/pldoc/ 
*/

param(5,gridSize).

:- dynamic ball/2.


valid(X,Y) :-
    param(Z,gridSize),
    X >= 0, X < Z,
    Y >= 0, Y < Z.

searh(X,Y, false) :-
    false

searh(X,Y, true) :-
    true.

searh(X,Y) :-
    % searh(X+1,Y).
    nextUp(X,Y),
    writeln(X).

nextUp(X,Y) :-
    valid(X+1,Y),
    X+1.

nextDown(X,Y) :-
    valid(X-1,Y).


main :-
    consult("input.txt"),
    s(SX,SY),
    ball(SX,SY),
    searh(SX,SY).

% empty (X,Y):-
%     \+ o(X,Y),
%     \+ h(X,Y).
