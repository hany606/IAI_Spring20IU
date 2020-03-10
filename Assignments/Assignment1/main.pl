/*
    Author: Hany Hamed
    Description: File for Rules for Assignment 1 in Intro to AI Spring 2020 Innopolis University
    Resources & References:
    - https://stackoverflow.com/questions/4805601/read-a-file-line-by-line-in-prolog
    - https://www.swi-prolog.org/pldoc/doc_for?object=re_split/3
    - https://stackoverflow.com/questions/22747147/swi-prolog-write-to-file
    - https://www.swi-prolog.org/pldoc/ 
    - https://stackoverflow.com/questions/32691313/counter-in-prolog (Counter part)
    - https://stackoverflow.com/questions/42466637/decrement-the-same-variable-in-prolog
    - http://rigaux.org/language-study/syntax-across-languages-per-language/Prolog.html
    - http://theory.stanford.edu/~amitp/GameProgramming/Heuristics.html
    - https://qiao.github.io/PathFinding.js/visual/
    - http://www.sfu.ca/~arashr/warren.pdf
    - https://www.wikiwand.com/en/Admissible_heuristic
    - https://cs.stanford.edu/people/eroberts/courses/soco/projects/2003-04/intelligent-search/astar.html
*/

/*
    Assumptions & Info to declare:
        - BT => Backtrack, RS => Random Search, HC => HillClimber, AS => A*, QT => Q-Table.
        - utils.pl has some auxilary functions (e.g. printing list, ....etc).
        - Cost in Backtrack is the number of steps in the path.
        - Walls surrounded the playground, from each side there is a wall (Extra row/column).
        - Steps in RS are considered with passing and movements.
        - There is another file called counters.pl that is used to modularity of the code to write there only the counters rules
            These counters is used for counting number of steps, counting number of trials for RS.
            To ease for generation of the counters for me instead of copying and past, there has been made a python script to generate it.
*/
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
param(5,mapSize).
param(15,maxStepsRS).
param(1, numEpisodesRS).
param(1, numStepsAhead).
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:- dynamic mapBoarders/2.
:- dynamic mapTouchDown/2.
:- dynamic mapStart/2.
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:- dynamic optimalPath/1.
:- dynamic optimalPathCount/2.
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% X,Y,Val
:- dynamic aStarOpenList/5.
:- dynamic aStarClosedList/5.


:- dynamic minOpenList/1.

:- dynamic aStarShortestPath/2.

% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

resetMap :-
    retractall(mapBoarders(_,_)),
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
    t(Xt,Yt),
    asserta(mapTouchDown(Xt,Yt)),
    s(Xs,Ys),
    asserta(mapStart(Xs,Ys)),
    PathLimitCount is Z*Z,
    asserta(optimalPathCount(PathLimitCount,0)),
    retractall(optimalPath(_)),
    initpasscounter.

restartMap :-
    resetMap,
    initMap.


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
inPath(X,Y,T,P,R) :-
    count(P,X,Y,T,C),
    (C =< 1) -> R is 0;     % as the visited cell is in the path is two times in the path at most (in, out)
    R is 1.

valid(X,Y,T,V,P) :-
(
    ((mapBoarders(X,Y)) ->
    (
        succ(0,V),
        format('\n(~d, ~d) is a boarder cell', [X,Y])
    ));
    ((o(X,Y)) ->
    (
        succ(1,V),
        format('\n(~d, ~d) is an Orc cell', [X,Y])
    ));
    (inPath(X,Y,T,P,R),
    (R == 1) ->
    (
        succ(2,V),
        format('\n(~d, ~d) is a visited cell', [X,Y])
    ));
    succ(V,1)
    
).

reached(X,Y) :-
    mapTouchDown(X,Y),
    write('\n----------Reached!!!----------\n').


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
actBackTrack(X,Y,P,N) :-
(
    format('\n ----Step---- ~d', [N]),
    format('\n#Current in ~d ~d and deciding, Check Up', [X,Y]),
    nextUp(X,Y,Xu,Yu,Vu,P),
    ((Vu == 0) ->
        Nnew is N +1,
        format('\nUp to ~d ~d in step ~d', [Xu, Yu, Nnew]),
        backtrackSearch(Xu,Yu, [Xu,Yu,m|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Down', [X,Y]),
    nextDown(X,Y,Xd,Yd,Vd,P),
    ((Vd == 0) ->
        Nnew is N +1,
        format('\nDown to ~d ~d in step ~d', [Xd, Yd, Nnew]),
        backtrackSearch(Xd,Yd, [Xd,Yd,m|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Right', [X,Y]),
    nextRight(X,Y,Xr,Yr,Vr,P),
    ((Vr == 0) ->
        Nnew is N +1,
        format('\nRight to ~d ~d in step ~d', [Xr, Yr, Nnew]),
        backtrackSearch(Xr,Yr, [Xr,Yr,m|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Left', [X,Y]),
    nextLeft(X,Y,Xl,Yl,Vl,P),
    ((Vl == 0) ->
        Nnew is N +1,
        format('\nLeft to ~d ~d in step ~d', [Xl, Yl, Nnew]),
        backtrackSearch(Xl,Yl, [Xl,Yl,m|P])
    );
    pass(X,Y,[X,Y,p|P],N)

). 

nextUp(X,Y,Xu,Yu,V,P) :-
(
    succ(Y, Ynew), Xu is X,
    (
        valid(X,Ynew,m,Vv,P)->
        (Vv == 0) -> (Yu is Ynew, V is 0);
        (Vv > 0) -> (Yu is Y, V is Vv)
    )
).
    
nextDown(X,Y,Xd,Yd,V,P) :-
(
    succ(Ynew, Y), Xd is X,
    (
        valid(X,Ynew,m,Vv,P)->
        (Vv == 0)  -> Yd is Ynew, V is 0; 
        (Vv > 0) -> (Yd is Y, V is Vv)
    )
).


nextRight(X,Y,Xr,Yr,V,P) :-
(
    succ(X, Xnew), Yr is Y,
    (
        valid(Xnew,Y,m,Vv,P)->
        (Vv == 0) -> ( Xr is Xnew, V is 0);
        (Vv > 0) -> (Xr is X, V is Vv)
    )
).
nextLeft(X,Y,Xl,Yl,V,P) :-
(
    succ(Xnew, X), Yl is Y,
    (
        valid(Xnew,Y,m,Vv,P)->
        (Vv == 0) -> Xl is Xnew, V is 0; 
        (Vv > 0) -> (Xl is X, V is Vv)
    )
).


pass(X,Y,P,N) :-
(
    format('\n ----Step---- ~d', [N]),
    format('\n#Current in ~d ~d and deciding, Check Passing Up', [X,Y]),
    passU(X,Y,Xu,Yu,Vu,P),
    ((Vu == 0) ->
        succ(X,XT),succ(Y,YT),
        ((Yu > YT) -> (incrpasscounter);true),
        format('\nPass Up to ~d ~d in step ~d (Number of steps did not change)', [Xu, Yu, N]),
        backtrackSearch(Xu,Yu, [Xu,Yu,p|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Passing Down', [X,Y]),
    passD(X,Y,Xd,Yd,Vd,P),
    ((Vd == 0) ->
        succ(YT,Y), % Long pass detection
        ((Yd < YT) -> (incrpasscounter);true),
        format('\nPass Down to ~d ~d in step ~d (Number of steps did not change)', [Xd, Yd, N]),
        backtrackSearch(Xd,Yd, [Xd,Yd,p|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Passing Right', [X,Y]),
    passR(X,Y,Xr,Yr,Vr,P),
    ((Vr == 0) ->
        succ(X,XT),
        ((Xr > XT) -> (incrpasscounter);true),
        format('\nPass Right to ~d ~d in step ~d (Number of steps did not change)', [Xr, Yr, N]),
        backtrackSearch(Xr,Yr, [Xr,Yr,p|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Passing Left', [X,Y]),
    passL(X,Y,Xl,Yl,Vl,P),
    ((Vl == 0) ->
        succ(XT,X),
        ((Xl < XT) -> (incrpasscounter);true),
        format('\nPass Left to ~d ~d in step ~d (Number of steps did not change)', [Xl, Yl, N]),
        backtrackSearch(Xl,Yl, [Xl,Yl,p|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Passing Up Right (Diagonal)', [X,Y]),
    passUR(X,Y,Xur,Yur,Vur,P),
    ((Vur == 0) ->
        succ(X,XT),succ(Y,YT),
        ((Yur > YT, Xur > XT) -> (incrpasscounter);true),
        format('\nPass Up to ~d ~d in step ~d (Number of steps did not change)', [Xur, Yur, N]),
        backtrackSearch(Xur,Yur, [Xur,Yur,p|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Passing Up Left (Diagonal)', [X,Y]),
    passUL(X,Y,Xul,Yul,Vul,P),
    ((Vul == 0) ->
        succ(XT,X),succ(Y,YT),
        ((Yul > YT, Xul < XT) -> (incrpasscounter);true),
        format('\nPass Up to ~d ~d in step ~d (Number of steps did not change)', [Xul, Yul, N]),
        backtrackSearch(Xul,Yul, [Xul,Yul,p|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Passing Down Right (Diagonal)', [X,Y]),
    passDR(X,Y,Xdr,Ydr,Vdr,P),
    ((Vdr == 0) ->
        succ(X,XT),succ(YT,Y),
        ((Ydr < YT, Xdr > XT) -> (incrpasscounter);true),
        format('\nPass Down to ~d ~d in step ~d (Number of steps did not change)', [Xdr, Ydr, N]),
        backtrackSearch(Xdr,Ydr, [Xdr,Ydr,p|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Passing Down Left (Diagonal)', [X,Y]),
    passDL(X,Y,Xdl,Ydl,Vdl,P),
    ((Vdl == 0) ->
        succ(XT,X),succ(YT,Y),
        ((Ydl < YT, Xdl < XT) -> (incrpasscounter);true),
        format('\nPass Down to ~d ~d in step ~d (Number of steps did not change)', [Xdl, Ydl, N]),
        backtrackSearch(Xdl,Ydl, [Xdl,Ydl,p|P])
    )
). 


validPass :-
    (passcounter(C),
    (C == 0),
    format('\nValid Pass if applicable; not execeeding the number of the valid passes during the gameplay'));
    (C > 0) -> (format('\n Not Valid Pass\n'), false).

testPass :-
    passUR(1,1,X,Y,V,[]),
    format('\nValue ~d Pass ~d ,~d\n', [V,X,Y]),
    (V == 0)->(
        format('\nValue ~d Pass ~d ,~d\n', [V,X,Y]),
        incrpasscounter,
        passR(X,Y,Xn,Yn,Vv,[]),
        (Vv == 0)->(
        % passR(X,Y,Xn,Yn,Vu,[]),
        format('\n~d ,~d\n', [Xn,Yn]))
    ).

passU(X,Y,Xu,Yu,V,P) :-
    succ(Y, Ynew), Xu is X,
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xu,Ynew]),
    (validPass, (valid(X,Ynew,p,Vv,P)))->
    (
            ((Vv == 0), h(X,Ynew)) -> 
            (
                format('\n Found Human'),
                Yu is Ynew, V is 0
            );
            ((Vv == 0), not(h(X,Ynew))) -> 
            (
                format('\n Valid cell but did not find human, searching forward'),
                passU(Xu,Ynew,_,Yuu,Vu,P),Yu is Yuu, V is Vu
            );
            format('\n Validation Value:~d Not applicable pass due to the false validation of the cell',Vv),
            Yu is Y, V is Vv
    );V is 4,Yu is Y, Xu is X.

passD(X,Y,Xu,Yu,V,P) :-
    succ(Ynew, Y), Xu is X,
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xu,Ynew]),
    (validPass, (valid(X,Ynew,p,Vv,P)))->
    (
            ((Vv == 0), h(X,Ynew)) -> 
            (
                format('\n Found Human'),
                Yu is Ynew, V is 0
            );
            ((Vv == 0; Vv == 3), not(h(X,Ynew))) -> 
            (
                format('\n Valid cell but did not find human, searching forward'),
                passU(Xu,Ynew,_,Yuu,Vu,P),Yu is Yuu, V is Vu
            );
            format('\n Validation Value:~d Not applicable pass due to the false validation of the cell',Vv),
            Yu is Y, V is Vv
    );V is 4,Yu is Y, Xu is X.


passR(X,Y,Xr,Yr,V,P) :-
    succ(X, Xnew), Yr is Y,
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xnew,Yr]),
    (validPass, (valid(Xnew,Y,p,Vv,P))) ->
    (
        ((Vv == 0; Vv == 3), h(Xnew,Y)) -> 
        (
            format('\n Found Human'),
            Xr is Xnew, V is 0
        );
        ((Vv == 0; Vv == 3), not(h(Xnew,Y))) -> 
        (
            format('\n Valid cell but did not find human, searching forward'),
            passR(Xnew,Yr,Xrr,_,Vr,P),Xr is Xrr, V is Vr
        );
        format('\n Validation Value:~d Not applicable pass due to the false validation of the cell',Vv),
        Xr is X, V is Vv
    ); V is 4,Yu is Y, Xu is X.

passL(X,Y,Xl,Yl,V,P) :-
    succ(Xnew,X), Yl is Y,
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xnew,Yl]),
    (validPass, (valid(Xnew,Y,p,Vv,P))) ->
    (
        ((Vv == 0; Vv == 3), h(Xnew,Y)) -> 
        (
            format('\n Found Human'),
            Xl is Xnew, V is 0
        );
        ((Vv == 0; Vv == 3), not(h(Xnew,Y))) -> 
        (
            format('\n Valid cell but did not find human, searching forward'),
            passL(Xnew,Yl,Xll,_,Vl,P),Xl is Xll, V is Vl
        );
        format('\n Validation Value:~d Not applicable pass due to the false validation of the cell',Vv),
        Xl is X, V is Vv
    ); V is 4,Yu is Y, Xu is X.

passUR(X,Y,Xu,Yu,V,P) :-
    succ(Y, Ynew), succ(X, Xnew),
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xnew,Ynew]),
    (validPass, (valid(Xnew,Ynew,p,Vv,P)))->
    (
            ((Vv == 0; Vv == 3), h(Xnew,Ynew)) -> 
            (
                format('\n Found Human'),
                Yu is Ynew, Xu is Xnew, V is 0
            );
            ((Vv == 0; Vv == 3), not(h(Xnew,Ynew))) -> 
            (
                format('\n Valid cell but did not find human, searching forward'),
                passUR(Xnew,Ynew,Xuu,Yuu,Vu,P),Yu is Yuu, Xu is Xuu, V is Vu
            );
            format('\n Validation Value: ~d \nNot applicable pass due to the false validation of the cell (Border or has orc)',Vv),
            Yu is Y, Xu is X, V is Vv
    );V is 4,Yu is Y, Xu is X.

passUL(X,Y,Xu,Yu,V,P) :-
    succ(Y, Ynew), succ(Xnew, X),
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xnew,Ynew]),
    (validPass, (valid(Xnew,Ynew,p,Vv,P)))->
    (
            ((Vv == 0; Vv == 3), h(Xnew,Ynew)) -> 
            (
                format('\n Found Human'),
                Yu is Ynew, Xu is Xnew, V is 0
            );
            ((Vv == 0; Vv == 3), not(h(Xnew,Ynew))) -> 
            (
                format('\n Valid cell but did not find human, searching forward'),
                passUL(Xnew,Ynew,Xuu,Yuu,Vu,P),Yu is Yuu, Xu is Xuu, V is Vu
            );
            format('\n Validation Value:~d Not applicable pass due to the false validation of the cell',Vv),
            Yu is Y, Xu is X, V is Vv
    );V is 4,Yu is Y, Xu is X.

passDR(X,Y,Xu,Yu,V,P) :-
    succ(Ynew, Y), succ(X, Xnew),
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xnew,Ynew]),
    (validPass, (valid(Xnew,Ynew,p,Vv,P)))->
    (
            ((Vv == 0; Vv == 3), h(Xnew,Ynew)) -> 
            (
                format('\n Found Human'),
                Yu is Ynew, Xu is Xnew, V is 0
            );
            ((Vv == 0; Vv == 3), not(h(Xnew,Ynew))) -> 
            (
                format('\n Valid cell but did not find human, searching forward'),
                passDR(Xnew,Ynew,Xuu,Yuu,Vu,P),Yu is Yuu, Xu is Xuu, V is Vu
            );
            format('\n Validation Value:~d Not applicable pass due to the false validation of the cell',Vv),
            Yu is Y, Xu is X, V is Vv
    );V is 4,Yu is Y, Xu is X.

passDL(X,Y,Xu,Yu,V,P) :-
    succ(Ynew, Y), succ(Xnew, X),
    format('\nCurrent cell is (~d,~d), Searching on (~d,~d)', [X,Y,Xnew,Ynew]),
    (validPass, (valid(Xnew,Ynew,p,Vv,P)))->
    (
            ((Vv == 0; Vv == 3), h(Xnew,Ynew)) -> 
            (
                format('\n Found Human'),
                Yu is Ynew, Xu is Xnew, V is 0
            );
            ((Vv == 0; Vv == 3), not(h(Xnew,Ynew))) -> 
            (
                format('\n Valid cell but did not find human, searching forward'),
                passDL(Xnew,Ynew,Xuu,Yuu,Vu,P),Yu is Yuu, Xu is Xuu, V is Vu
            );
            format('\n Validation Value:~d Not applicable pass due to the false validation of the cell',Vv),
            Yu is Y, Xu is X, V is Vv
    );V is 4,Yu is Y, Xu is X.

% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% Save the path
saveOptimalPath(X,Y,P,N) :-
    format('\nGreat !!! (~d, ~d) in ~d steps', [X,Y,N]),
    format('\nPrinting all the path in a reverse order from the end to the start\n'),
    printlst(P),
    format('\n----------Reached!!!----------\n'),
    optimalPathCount(Best,C),
    retractall(optimalPathCount(_,_)),
    (
        (N < Best) -> 
        (
            retractall(optimalPath(_)),
            assertz(optimalPath(P)),
            assertz(optimalPathCount(N,0)),
            format("\n Great! New optimal path with less path cost : ~d with muliplicity ~d", [N, 0])
        ); 
        (N == Best) -> (
            assertz(optimalPath(P)),
            succ(C, Cnew), 
            assertz(optimalPathCount(N,Cnew)),
            format("\n Great! New optimal path count with the same old cost: ~d with muliplicity ~d", [N, Cnew])
        )
    )
    ,optimalPathCount(Nnew,Cm).



% This to limit the backtrack to the best result we have till now or not
isOptimalPath(N) :-
    optimalPathCount(Best,_),
    format('\n Steps for now ~d, optimal path count: ~d', [N, Best]),
    not(N > Best).


backtrackSearch(X,Y,P) :-
(
    lengthlst(P,Nn),
    N is (div(Nn,4)),
    (
        reached(X,Y) -> 
        (
            saveOptimalPath(X,Y,P,N)
        ); 
        (
            not(isOptimalPath(N)) -> (
                format('\n \t XXXXXXXXXX Not optimal path, discarded XXXXXXXXXX \n Reason: Number of current steps: ~d',[N])
            );
            (actBackTrack(X,Y,[X,Y,m|P],N))
        )
    )    
).

% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

randomSearch(_,_,0,P) :-
    format('\n \n\t########## Iterations has been finished ##########\t\n')
    ,!.

randomSearch(X,Y,N,P) :-
    param(M,numEpisodesRS),
    format('\n\t########## Random Search iteration #~d ##########\t\n', [M-N+1]),
    randomSearch(X,Y,[]),
    succ(Nnew, N),
    randomSearch(X,Y,Nnew,[]).

% Ranges are made as the step is 1/12 ~= 0.0833 and the random variable is from std normal distribution ~ [0,1]
% Generation of the ranges was pretty made easily using python :)
randomSearch(X,Y,P) :-
(
    param(MRS,maxStepsRS),
    lengthlst(P,Nn),
    N is (div(Nn,4)),
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
        (
            (R >= 0, R < 0.083) ->
            % (R >= 0, R < 0.25) ->
            (
                nextUp(X,Y,Xnew,Ynew,_,[]),     % We don't want to check if it was visited before or not as it is random search
                format('\nUp to ~d ~d', [Xnew, Ynew])
            );  
            (R >= 0.083, R < 0.1666) ->
            % (R >= 0.25, R < 0.5) ->
            (
                nextDown(X,Y,Xnew,Ynew,_,[]),
                format('\nDown to ~d ~d', [Xnew, Ynew])

            );
            (R >= 0.1666, R < 0.2499) ->
            % (R >= 0.50, R < 0.75) ->
            (
                nextRight(X,Y,Xnew,Ynew,_,[]),
                format('\nRight to ~d ~d', [Xnew, Ynew])
            );
            %0.3332
            (R >= 0.2499, R < 0.3332) -> 
            % (R >= 0.75, R =< 1) -> 
            (
                nextLeft(X,Y,Xnew,Ynew,_,[]),
                format('\nLeft to ~d ~d', [Xnew, Ynew])
            );
            (R >= 0.3332, R < 0.4165) ->
            (passU(X,Y,Xnew,Ynew,_,[]));
            (R >= 0.4165, R < 0.4998) ->
            (passD(X,Y,Xnew,Ynew,_,[]));
            (R >= 0.4998, R < 0.5831) ->
            (passR(X,Y,Xnew,Ynew,_,[]));
            (R >= 0.5831, R < 0.6664) ->
            (passL(X,Y,Xnew,Ynew,_,[]));
            (R >= 0.6664, R < 0.7497) ->
            (passUR(X,Y,Xnew,Ynew,_,[]));
            (R >= 0.7497, R < 0.833) ->
            (passUL(X,Y,Xnew,Ynew,_,[]));
            (R >= 0.833, R < 0.9163) ->
            (passDR(X,Y,Xnew,Ynew,_,[]));
            (R >= 0.9163, R =< 1) ->
            (passDL(X,Y,Xnew,Ynew,_,[]))
        ),
        randomSearch(Xnew,Ynew,[Xnew,Ynew|P])
    )
).


rsStatistics :-
    rscounter(N),
    param(Nall, numEpisodesRS),
    format('\n##########################################################\n\t##### Random Search Statistics ##### \n \t ~d/~d trials successfully reached the target\n##########################################################', [N,Nall]).


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
addNeighbourhood(X,Y,N,P) :-
(
    succ(N,Ntmp),
    param(NL, numStepsAhead),
    format('\n Adding Neighbours of (~d,~d) as step ahead ~d/~d', [X,Y,Ntmp,NL]),
    (
        nextUp(X,Y,Xu,Yu,Vu,[u|P]),
        (
            (Vu == 0) -> (
            format('\nAdd Up to ~d ~d in Open List', [Xu, Yu]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xu,Yu) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xu,Yu,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xu,Yu,Gcost_new,X,Y)) 
                    )
                );
                % There is no human and valid then it is an empty cell, then it is move, cost 2
                (not(h(Xu,Yu))) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xu,Yu,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xu,Yu,Gcost_new,X,Y))
                    )
                )
                ;
                % It is Touchdown -> then there is heuristic cost with negative value of Euclidian distance to work as lower bound for the cost which will enable us to get an optimal solution
                % , otherwise the heuristic cost is zero as in the above predicates
                (t(Xu,Yu)) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xu,Yu,_, _, _)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xu,Yu,Gcost_new,X,Y))
                    )
                )
                
            )),
        param(NStepsAhead, numStepsAhead),
        succ(N,Nnew),
        (Nnew < NStepsAhead) ->
        (
            aStarOpenList(Xu,Yu,C,X,Y),
            asserta(aStarClosedList(Xu,Yu,C,X,Y)),
            addNeighbourhood(Xu,Yu,Nnew,[Xu,Yu,m|P]),
            retract(aStarClosedList(Xu,Yu,C,X,Y))
        )
            
        );
        nextDown(X,Y,Xd,Yd,Vd,[u|P]),
        ((Vd == 0) ->
            format('\nAdd down to ~d ~d in Open List', [Xd, Yd]),
            (
                % There is a human, then it is a handover with cost 1
                h(Xd,Yd) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xd,Yd,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xd,Yd,Gcost_new,X,Y))
                    )
                );
                (not(h(Xd,Yd))) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xd,Yd,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xd,Yd,Gcost_new,X,Y))
                    )
                )
                
                ;
                (t(Xd,Yd)) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xd,Yd,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xd,Yd,Gcost_new,X,Y))   
                    )
                )
                
            ),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (   
                aStarOpenList(Xd,Yd,C,X,Y),
                asserta(aStarClosedList(Xd,Yd,C,X,Y)),
                addNeighbourhood(Xd,Yd,Nnew,[Xd,Yd,m|P]),
                retract(aStarClosedList(Xd,Yd,C,X,Y))

            )
        );
        nextRight(X,Y,Xr,Yr,Vr,[u|P]),
        ((Vr == 0) -> (
            format('\nAdd Right to ~d ~d in Open List', [Xr, Yr]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xr,Yr) ->
                (   

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xr,Yr,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xr,Yr,Gcost_new,X,Y)) 
                    )
                );
                (not(h(Xr,Yr))) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xr,Yr,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xr,Yr,Gcost_new,X,Y))
                    )
                )
                
                ;
                (t(Xr,Yr)) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xr,Yr,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xr,Yr,Gcost_new,X,Y))
                    )
                )
            )),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (
                aStarOpenList(Xr,Yr,C,X,Y),
                asserta(aStarClosedList(Xr,Yr,C,X,Y)),
                addNeighbourhood(Xr,Yr,Nnew,[Xr,Yr,m|P]),
                retract(aStarClosedList(Xr,Yr,C,X,Y))

            )
        );
        nextLeft(X,Y,Xl,Yl,Vl,[u|P]),
        ((Vl == 0) ->
            format('\nAdd Left to ~d ~d in Open List', [Xl, Yl]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xl,Yl) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xl,Yl,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xl,Yl,Gcost_new,X,Y))
                    )
                );
                (not(h(Xl,Yl))) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xl,Yl,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xl,Yl,Gcost_new,X,Y))
                    )
                )
                
                ;
                (t(Xl,Yl)) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xl,Yl,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xl,Yl,Gcost_new,X,Y))   
                    )
                )
            ),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (
                aStarOpenList(Xl,Yl,C,X,Y),
                asserta(aStarClosedList(Xl,Yl,C,X,Y)),
                addNeighbourhood(Xl,Yl,Nnew,[Xl,Yl,u|P]),
                retract(aStarClosedList(Xl,Yl,C,X,Y))

            )
        );
        passUR(X,Y,Xur,Yur,Vur,[u|P]),
        (
            (Vur == 0) -> (
            format('\nAdd Up Right to ~d ~d in Open List', [Xur, Yur]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xur,Yur) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xur,Yur,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xur,Yur,Gcost_new,X,Y)) 
                    )
                )
                
            )
            ),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (
                aStarOpenList(Xur,Yur,C,X,Y),
                asserta(aStarClosedList(Xur,Yur,C,X,Y)),
                addNeighbourhood(Xur,Yur,Nnew,[Xur,Yur,m|P]),
                retract(aStarClosedList(Xur,Yur,C,X,Y))
            )
            
        );
        passUL(X,Y,Xul,Yul,Vul,[u|P]),
        (
            (Vul == 0) -> (
            format('\nAdd Up Left to ~d ~d in Open List', [Xul, Yul]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xul,Yul) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xul,Yul,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xul,Yul,Gcost_new,X,Y)) 
                    )
                )
                
            )),
        param(NStepsAhead, numStepsAhead),
        succ(N,Nnew),
        (Nnew < NStepsAhead) ->
        (
            aStarOpenList(Xul,Yul,C,X,Y),
            asserta(aStarClosedList(Xul,Yul,C,X,Y)),
            addNeighbourhood(Xul,Yul,Nnew,[Xul,Yul,m|P]),
            retract(aStarClosedList(Xul,Yul,C,X,Y))
        )
            
        );
        passDR(X,Y,Xdr,Ydr,Vdr,[u|P]),
        (
            (Vdr == 0) -> (
            format('\nAdd Down Right to ~d ~d in Open List', [Xdr, Ydr]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xdr,Ydr) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xdr,Ydr,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xdr,Ydr,Gcost_new,X,Y)) 
                    )
                )
                
            )),
        param(NStepsAhead, numStepsAhead),
        succ(N,Nnew),
        (Nnew < NStepsAhead) ->
        (
            aStarOpenList(Xdr,Ydr,C,X,Y),
            asserta(aStarClosedList(Xdr,Ydr,C,X,Y)),
            addNeighbourhood(Xdr,Ydr,Nnew,[Xdr,Ydr,m|P]),
            retract(aStarClosedList(Xdr,Ydr,C,X,Y))
        )
            
        );
        passDL(X,Y,Xdl,Ydl,Vdl,[u|P]),
        (
            (Vdl == 0) -> (
            format('\nAdd Down Left to ~d ~d in Open List', [Xdl, Ydl]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xdl,Ydl) ->
                (

                    aStarClosedList(X,Y,Gcost_old,_,_),
                    not(aStarClosedList(Xdl,Ydl,_,_,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(' with cost ~d',[Gcost_new]),
                        asserta(aStarOpenList(Xdl,Ydl,Gcost_new,X,Y)) 
                    )
                )
                
            )),
        param(NStepsAhead, numStepsAhead),
        succ(N,Nnew),
        (Nnew < NStepsAhead) ->
        (
            aStarOpenList(Xdl,Ydl,C,X,Y),
            asserta(aStarClosedList(Xdl,Ydl,C,X,Y)),
            addNeighbourhood(Xdl,Ydl,Nnew,[Xdl,Ydl,m|P]),
            retract(aStarClosedList(Xdl,Ydl,C,X,Y))
        )
            
        )
    )
). 

% Source: https://stackoverflow.com/questions/36411848/how-to-use-tranpose-and-findall-to-print-all-the-variables-in-a-predicate
getOpenList(List) :- findall([X,Y,V,Xp,Yp], aStarOpenList(X,Y,V,Xp,Yp), List).
printOpenList([]) :- !.
printOpenList([[X,Y,V,Xp,Yp]|T]) :- format('\n! X: ~d,Y: ~d,V: ~d   , Xp: ~d, Yp:~d', [X,Y,V,Xp,Yp]),printOpenList(T).

getClosedList(List) :- findall([X,Y,V,Xp,Yp], aStarClosedList(X,Y,V,Xp,Yp), List).
printClosedList([]) :- !.
printClosedList([[X,Y,V,Xp,Yp]|T]) :- format('\n! X: ~d,Y: ~d,V: ~d    , Xp: ~d, Yp:~d', [X,Y,V,Xp,Yp]),printClosedList(T).

getShortestPathList(List) :- findall([X,Y], aStarShortestPath(X,Y), List).
printShortestPathList([]) :- !.
printShortestPathList([[X,Y]|T]) :- format('\n! X: ~d,Y: ~d', [X,Y]),printShortestPathList(T).


newList([]) :- !.
newList([[X,Y,V,Xp,Yp]|T]) :- 
    minOpenList(VV),
    (V < VV) -> 
    (
        retractall(minOpenList(_)),
        asserta(minOpenList(V)),
        newList(T)
    );
    newList(T).

selectMinNode(Xn,Yn) :-
    getOpenList(List),
    retractall(minOpenList(_)),
    asserta(minOpenList(50000)),
    newList(List),
    minOpenList(C),
    format('\n final minimum cost ~d', C),
    aStarOpenList(Xn,Yn,C,_,_),
    inPath(Xn,Yn,u,P,R).

getPath(P,X,Y) :-
    aStarClosedList(X,Y,_,Xp,Yp),
    format(' (~d,~d)', [Xp,Yp]),
    asserta(aStarShortestPath(Xp,Yp)),
    mapStart(Xs,Ys),
    not((X == Xs, Y == Ys)) ->
        getPath([X,Y,Ty|P],Xp,Yp),
    true.

aStarSearch(X,Y,NStepsAhead,P) :-
    aStarOpenList(X,Y,V,Xp,Yp), 
    retractall(aStarOpenList(X,Y,_,_,_)),
    asserta(aStarClosedList(X,Y,V,Xp,Yp)),
    format('\nCurrent in (~d,~d) from (~d,~d)', [X,Y,Xp,Yp]),
    
    getOpenList(OList),
    format('\n -------------------------- Open List ---------------------------\n'),
    printOpenList(OList),
    format('\n -----------------------------------------------------\n'),
    getClosedList(CList),
    format('\n -------------------------- Closed List ---------------------------\n'),
    printClosedList(CList),
    format('\n -----------------------------------------------------\n'),

    (mapTouchDown(Xt,Yt), 
    (reached(X,Y); aStarOpenList(Xt,Yt,Vt,_,_);aStarClosedList(Xt,Yt,Vt,_,_))) -> 
    (
        retractall(aStarOpenList(Xt,Yt,_,_,_)),
        asserta(aStarClosedList(Xt,Yt,Vt,X,Y)),
        Pp = [Xt,Yt,u|P],
        format('\n ---------- Nodes that has been visited -----------\n'),
        printlst(Pp),
        format('\n ----------- Shortest Path ------------\n'),
        format(' (~d,~d)', [Xt,Yt]),
        retractall(aStarShortestPath(_,_)),
        assert(aStarShortestPath(Xt,Yt)),
        getPath(P,Xt,Yt),
        format('\n----------------------------\n'),
        true
        
    );
    addNeighbourhood(X,Y,0,[X,Y|P]);
    selectMinNode(Xnew, Ynew),
    format('\n\n------------------ Selected (~d,~d) -------------------------\n\n', [Xnew, Ynew]),
    aStarSearch(Xnew,Ynew, NStepsAhead, [X,Y,u|P]).


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

initMain :-
    consult("input.pl"),
    consult("counters.pl"),
    consult("utils.pl"),
    resetMap,
    initMap,
    initrscounter.


mainBacktrack :-
    initMain
    ,s(Xs,Ys)
    ,get_time(T1)    
    ,(backtrackSearch(Xs,Ys,[]);true)
    -> (format('\n--------------------------------------------------------------\n--------------------------------------------------------------\n--------------------------------------------------------------\n')
    ,format('\n\tCurrent Optimal Paths\t\n')
    ,optimalPath(P)
    ,printlst(P)
    ,format('\n--------------------------------------------------------------\n--------------------------------------------------------------\n--------------------------------------------------------------\n')
    ,get_time(T2)
    , T3 = T2 - T1
    ,format(' \nTime elapsed: ~f msec', [(T3)*1000]))
    . 

mainRandomSearch :-
    initMain
    ,s(Xs,Ys)
    ,param(NRS_episodes, numEpisodesRS)
    ,get_time(T1)
    ,randomSearch(Xs,Ys,NRS_episodes, [])
    ,rsStatistics
    ,get_time(T2)
    , T3 = T2 - T1
    ,format(' \nTime elapsed: ~f msec', [(T3)*1000])
    .  


mainAStarSearch :-
    initMain
    ,retractall(aStarShortestPath(_,_))
    ,retractall(aStarClosedList(_,_,_,_,_))
    ,retractall(aStarOpenList(_,_,_,_,_))
    ,mapStart(Xs,Ys)
    ,param(S_ahead, numStepsAhead)
    ,param(N,mapSize)
    ,asserta(aStarOpenList(Xs,Ys,0,Xs,Ys))
    ,get_time(T1)
    ,(aStarSearch(Xs,Ys,S_ahead, []);true)->
    (
        mapTouchDown(Xt,Yt),
        format('\n ----------- Shortest Path ------------\n'),
        format(' (~d,~d)', [Xt,Yt]),
        getShortestPathList(P),
        printShortestPathList(P),
        % getPath(P,Xt,Yt),
        format('\n----------------------------\n')
        ,get_time(T2)
        , T3 = T2 - T1
        ,format(' \nTime elapsed: ~f',[T3*1000])
    )
    .  