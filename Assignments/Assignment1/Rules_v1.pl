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
        - BT => Backtrack, RS => Random Search, HC => HillClimber, AS => A*, QT => Q-Table.
        - Walls surrounded the playground, from each side there is a wall (Extra row/column).
        - Steps in RS are considered with passing and movements.
        - There is another file called counters.pl that is used to modularity of the code to write there only the counters rules
            These counters is used for counting number of steps, counting number of trials for RS.
            To ease for generation of the counters for me instead of copying and past, there has been mad a python script to generate it.
*/

param(5,mapSize).
param(10,maxStepsRS).
param(10, numEpisodesRS).

:- dynamic mapBoarders/2.
:- dynamic mapOrcs/2.
:- dynamic mapHumans/2.
:- dynamic mapTouchDown/2.
:- dynamic mapStart/2.

:- dynamic ballPos/2.
:- dynamic visited/2.
:- dynamic path/2.
:- dynamic optimalPathCount/2.



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
    
valid(X,Y,V) :-
(
    (mapBoarders(X,Y)) ->
    (
        succ(0,V),
        format('\n(~d, ~d) is a boarder cell', [X,Y])
    );
    (mapOrcs(X,Y)) ->
    (
        succ(1,V),
        format('\n(~d, ~d) is an Orc cell', [X,Y])
    );
    (visited(X,Y)) ->
    (
        succ(2,V),
        format('\n(~d, ~d) is a visited cell', [X,Y])
    );
    succ(V,1)
    
).

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
saveOptimalPath(X,Y) :-
    stepscounter(N),
    format("Great !!! ~d ~d in ~d steps", [X,Y,N]),
    write("\n----------Reached!!!----------\n"),
    optimalPathCount(Best,C),
    retractall(optimalPathCount(_,_)),
    (
        (N < Best) -> (assertz(optimalPathCount(N,0))); 
        (N == Best) -> (succ(C, Cnew), assertz(optimalPathCount(N,Cnew)))
    )
    ,optimalPathCount(Nnew,_),
    format("\n Great new optimal path count: ~d", [Nnew]).



% This to limit the backtrack to the best result we have till now or not
checkOptimalPath :-
    optimalPathCount(Best,_),
    stepscounter(N),
    format("\n Steps for now ~d, optimal path count: ~d", [N, Best]),
    not(N > Best).
    % true.

backtrackSearch(X,Y) :-
(
    incrsteps,
    asserta(visited(X,Y)),
    reached(X,Y) -> 
    (
            saveOptimalPath(X,Y)
    ); 
    not(reached(X,Y)) ->  
    (
        not(checkOptimalPath) -> (write("\n \t XXXXXXXXXX Not optimal path, discarded XXXXXXXXXX \n"));
        checkOptimalPath -> (move(X,Y), pass(X,Y))
    )
    ,decrsteps
).


% This was working on the last version of the actions. Commit: https://github.com/hany606/IAI_Spring20IU/commit/f6f9bc1164db8080f18a658b62c91c6e1f70c76b
% move(X,Y) :-
%     stepscounter(N),
%     format('\n ----Step---- ~d', [N]),
%     format('\n#Current in ~d ~d and deciding', [X,Y]),
%     incrsteps,
%     nextUp(X,Y,Xu,Yu),
%     format('\nUp to ~d ~d', [Xu, Yu]),
%     backtrackSearch(Xu,Yu),
%     retract(visited(Xu,Yu));
%     nextDown(X,Y,Xd,Yd),
%     format('\nDown to ~d ~d', [Xd, Yd]),
%     backtrackSearch(Xd,Yd),
%     retract(visited(Xd,Yd));
%     nextRight(X,Y,Xr,Yr),
%     format('\nRight to ~d ~d', [Xr, Yr]),
%     backtrackSearch(Xr,Yr),
%     retract(visited(Xr,Yr));
%     nextLeft(X,Y,Xl,Yl),
%     format('\nLeft to ~d ~d', [Xl, Yl]),
%     backtrackSearch(Xl,Yl),
%     retract(visited(Xl,Yl)); %,
%     decrsteps.

move(X,Y) :-
    stepscounter(N),
    format('\n ----Step---- ~d', [N]),
    format('\n#Current in ~d ~d and deciding, Check Up', [X,Y]),
    nextUp(X,Y,Xu,Yu,Vu),
    ((Vu == 1) ->
        % incrsteps,
        stepscounter(Nnew),
        format('\nUp to ~d ~d in step ~d', [Xu, Yu, Nnew]),
        backtrackSearch(Xu,Yu),
        retract(visited(Xu,Yu))
        % ,decrsteps
    );
    format('\n#Current in ~d ~d and deciding, Check Down', [X,Y]),
    nextDown(X,Y,Xd,Yd,Vd),
    ((Vd == 1) ->
        % incrsteps,
        stepscounter(Nnew),
        format('\nDown to ~d ~d in step ~d', [Xd, Yd, Nnew]),
        backtrackSearch(Xd,Yd),
        retract(visited(Xd,Yd))
        % ,decrsteps
    );
    format('\n#Current in ~d ~d and deciding, Check Right', [X,Y]),
    nextRight(X,Y,Xr,Yr,Vr),
    ((Vr == 1) ->
        % incrsteps,
        stepscounter(Nnew),
        format('\nRight to ~d ~d in step ~d', [Xr, Yr, Nnew]),
        backtrackSearch(Xr,Yr),
        retract(visited(Xr,Yr))
        % ,decrsteps
    );
    format('\n#Current in ~d ~d and deciding, Check Left', [X,Y]),
    nextLeft(X,Y,Xl,Yl,Vl),
    ((Vl == 1) ->
        % incrsteps,
        stepscounter(Nnew),
        format('\nLeft to ~d ~d in step ~d', [Xl, Yl, Nnew]),
        backtrackSearch(Xl,Yl),
        retract(visited(Xl,Yl))
        % ,decrsteps
    )
    % ,decrsteps
    . 
nextUp(X,Y,Xu,Yu,V) :-
(
    succ(Y, Ynew), Xu is X,
    (
        valid(X,Ynew,Vv),
        (Vv == 0) -> Yu is Ynew, V is 1;
        Yu is Y, V is 0
    )
).
    
nextDown(X,Y,Xd,Yd,V) :-
(
    succ(Ynew, Y), Xd is X,
    (
        valid(X,Ynew,Vv),
        (Vv == 0)  -> Yd is Ynew, V is 1; 
        Yd is Y
    )
).


nextRight(X,Y,Xr,Yr,V) :-
(
    succ(X, Xnew), Yr is Y,
    (
        valid(Xnew,Y,Vv),
        (Vv == 0) -> Xr is Xnew, V is 1;
        Xr is X
    )
).
nextLeft(X,Y,Xl,Yl,V) :-
(
    succ(Xnew, X), Yl is Y,
    (
        valid(Xnew,Y,Vv),
        (Vv == 0) -> Xl is Xnew, V is 1; 
        Xl is X
    )
).

% passU(X,Y,Xu,Yu) :-
    % validation,
    % pass to the human on that line,
    % change the y to the coordinate.

changeBallPos(X,Y) :-
    retractall(ballPos(_,_)),
    assert(ballPos(X,Y)).


randomSearch(_,_,0) :-
    format('\nReached the last iteration\n')
    ,!.

randomSearch(X,Y,N) :-
    param(M,numEpisodesRS),
    format(" \n\t########## Random Search iteration #~d ##########\t\n ", [M-N+1]),
    initsteps,
    randomSearch(X,Y),
    succ(Nnew, N),
    randomSearch(X,Y,Nnew).

% Ranges are made as the step is 1/12 ~= 0.0833 and the random variable is from std normal distribution ~ [0,1]
% Generation of the ranges was pretty made easily using python :)
randomSearch(X,Y) :-
(
    asserta(visited(X,Y)),
    param(MRS,maxStepsRS),
    stepscounter(N),
    format('\n ----Step---- ~d', [N]),
    (reached(X,Y); MRS == N)-> 
    (
        (MRS == N)->
        (
            format('\n Reached Maximum number of steps')    
        );
        (
            incrrscounter,
            format('\n Reached the goal')    
        )
    ); 
    not(reached(X,Y)) ->  
    (
        random(R),
        format('\n#Current in ~d ~d and deciding', [X,Y]),
        incrsteps,
        (
            % (R >= 0, R < 0.083) ->
            (R >= 0, R < 0.25) ->
            (
                nextUp(X,Y,Xnew,Ynew,_),
                format('\nUp to ~d ~d', [Xnew, Ynew])
            );  
            % (R >= 0.083, R < 0.1666) ->
            (R >= 0.25, R < 0.5) ->
            (
                nextDown(X,Y,Xnew,Ynew,_),
                format('\nDown to ~d ~d', [Xnew, Ynew])

            );
            % (R >= 0.1666, R < 0.2499) ->
            (R >= 0.50, R < 0.75) ->
            (
                nextRight(X,Y,Xnew,Ynew,_),
                format('\nRight to ~d ~d', [Xnew, Ynew])
            );
            %0.3332
            % (R >= 0.2499, R =< 1) -> 
            (R >= 0.75, R =< 1) -> 
            (
                nextLeft(X,Y,Xnew,Ynew,_),
                format('\nLeft to ~d ~d', [Xnew, Ynew])
            )%;
            % (R >= 0.3332, R < 0.4165) ->
            % (pass(X,Y));
            % (R >= 0.4165, R < 0.4998) ->
            % (pass(X,Y));
            % (R >= 0.4998, R < 0.5831) ->
            % (pass(X,Y));
            % (R >= 0.5831, R < 0.6664) ->
            % (pass(X,Y));
            % (R >= 0.6664, R < 0.7497) ->
            % (pass(X,Y));
            % (R >= 0.7497, R < 0.833) ->
            % (pass(X,Y));
            % (R >= 0.833, R < 0.9163) ->
            % (pass(X,Y));
            % (R >= 0.9163, R =< 1) ->
            % (pass(X,Y)),
        ),
        randomSearch(Xnew,Ynew),
        retract(visited(Xnew,Ynew))
    )
).

aStarSearch(X,Y) :-
    true.

hillClimberSearch(X,Y) :-
    true.

qTableRL(X,Y) :-
    true.

pass(X,Y) :-
    true.


rsStatistics :-
    rscounter(N),
    param(Nall, numEpisodesRS),
    format('\n##########################################################\n\t##### Random Search Statistics ##### \n \t ~d/~d trials successfully reached the target\n##########################################################', [N,Nall]).

initMain :-
    consult("input.pl"),
    consult("counters.pl"),
    resetMap,
    initMap,
    initrscounter.


main :-
    initMain
    ,s(Xs,Ys)
    ,Ns is 0
    ,backtrackSearch(Xs,Ys)
    ,stepscounter(S)
    ,format('Counter steps: ~d', [S])
    % param(NRS_episodes, numEpisodesRS)
    % ,randomSearch(Xs,Ys,NRS_episodes)
    % ,rsStatistics
    % ,aStarSearch(Xs,Ys)
    % ,hillClimberSearch(Xs,Ys)
    % ,qTableRL(Xs,Ys)
    .

% empty (X,Y):-
%     \+ o(X,Y),
%     \+ h(X,Y).
