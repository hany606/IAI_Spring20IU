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
            To ease for generation of the counters for me instead of copying and past, there has been mad a python script to generate it.
*/
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
param(5,mapSize).
param(10,maxStepsRS).
param(10, numEpisodesRS).
param(1, numStepsAhead).
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:- dynamic mapBoarders/2.
:- dynamic mapOrcs/2.
:- dynamic mapHumans/2.
:- dynamic mapTouchDown/2.
:- dynamic mapStart/2.
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
:- dynamic optimalPath/1.
:- dynamic optimalPathCount/2.
% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
% X,Y,Val
:- dynamic aStarOpenList/3.
:- dynamic aStarClosedList/3.


:- dynamic minOpenList/1.

% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

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
    PathLimitCount is Z*Z,
    asserta(optimalPathCount(PathLimitCount,0)),
    retractall(optimalPath(_)),
    initsteps.

restartMap :-
    resetMap,
    initMap.


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
inPath(X,Y,P,R) :-
    count(P,X,Y,C),
    (C =< 1) -> R is 0;     % as the visited cell is in the path is two times in the path at most (in, out)
    R is 1.

valid(X,Y,V,P) :-
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
    inPath(X,Y,P,R),
    (R == 1) ->
    (
        succ(2,V),
        format('\n(~d, ~d) is a visited cell', [X,Y])
    );
    succ(V,1)
    
).

reached(X,Y) :-
    mapTouchDown(X,Y),
    write('\n----------Reached!!!----------\n').


% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
move(X,Y,P,N) :-
(
    format('\n ----Step---- ~d', [N]),
    format('\n#Current in ~d ~d and deciding, Check Up', [X,Y]),
    nextUp(X,Y,Xu,Yu,Vu,P),
    ((Vu == 1) ->
        Nnew is N +1,
        format('\nUp to ~d ~d in step ~d', [Xu, Yu, Nnew]),
        backtrackSearch(Xu,Yu, [Xu,Yu|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Down', [X,Y]),
    nextDown(X,Y,Xd,Yd,Vd,P),
    ((Vd == 1) ->
        Nnew is N +1,
        format('\nDown to ~d ~d in step ~d', [Xd, Yd, Nnew]),
        backtrackSearch(Xd,Yd, [Xd,Yd|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Right', [X,Y]),
    nextRight(X,Y,Xr,Yr,Vr,P),
    ((Vr == 1) ->
        Nnew is N +1,
        format('\nRight to ~d ~d in step ~d', [Xr, Yr, Nnew]),
        backtrackSearch(Xr,Yr, [Xr,Yr|P])
    );
    format('\n#Current in ~d ~d and deciding, Check Left', [X,Y]),
    nextLeft(X,Y,Xl,Yl,Vl,P),
    ((Vl == 1) ->
        Nnew is N +1,
        format('\nLeft to ~d ~d in step ~d', [Xl, Yl, Nnew]),
        backtrackSearch(Xl,Yl, [Xl,Yl|P])
    )
). 

nextUp(X,Y,Xu,Yu,V,P) :-
(
    succ(Y, Ynew), Xu is X,
    (
        valid(X,Ynew,Vv,P),
        (Vv == 0) -> Yu is Ynew, V is 1;
        Yu is Y, V is 0
    )
).
    
nextDown(X,Y,Xd,Yd,V,P) :-
(
    succ(Ynew, Y), Xd is X,
    (
        valid(X,Ynew,Vv,P),
        (Vv == 0)  -> Yd is Ynew, V is 1; 
        Yd is Y
    )
).


nextRight(X,Y,Xr,Yr,V,P) :-
(
    succ(X, Xnew), Yr is Y,
    (
        valid(Xnew,Y,Vv,P),
        (Vv == 0) -> Xr is Xnew, V is 1;
        Xr is X
    )
).
nextLeft(X,Y,Xl,Yl,V,P) :-
(
    succ(Xnew, X), Yl is Y,
    (
        valid(Xnew,Y,Vv,P),
        (Vv == 0) -> Xl is Xnew, V is 1; 
        Xl is X
    )
).


pass(X,Y) :-
    true.

% passU(X,Y,Xu,Yu) :-
    % validation,
    % pass to the human on that line,
    % change the y to the coordinate.



% --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

% Save the path
saveOptimalPath(X,Y,P,N) :-
    format('\nGreat !!! ~d ~d in ~d steps', [X,Y,N]),
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
            (move(X,Y,[X,Y|P],N), pass(X,Y))
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
            % (R >= 0, R < 0.083) ->
            (R >= 0, R < 0.25) ->
            (
                nextUp(X,Y,Xnew,Ynew,_,[]),     % We don't want to check if it was visited before or not as it is random search
                format('\nUp to ~d ~d', [Xnew, Ynew])
            );  
            % (R >= 0.083, R < 0.1666) ->
            (R >= 0.25, R < 0.5) ->
            (
                nextDown(X,Y,Xnew,Ynew,_,[]),
                format('\nDown to ~d ~d', [Xnew, Ynew])

            );
            % (R >= 0.1666, R < 0.2499) ->
            (R >= 0.50, R < 0.75) ->
            (
                nextRight(X,Y,Xnew,Ynew,_,[]),
                format('\nRight to ~d ~d', [Xnew, Ynew])
            );
            %0.3332
            % (R >= 0.2499, R =< 1) -> 
            (R >= 0.75, R =< 1) -> 
            (
                nextLeft(X,Y,Xnew,Ynew,_,[]),
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
    (
        nextUp(X,Y,Xu,Yu,Vu,P),
        ((Vu == 1) ->
            format('\nAdd Up to ~d ~d in Open List', [Xu, Yu]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xu,Yu) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xu,Yu,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xu,Yu,Gcost_new)) 
                    )
                );
                % There is no human and valid then it is an empty cell, then it is move, cost 2
                (not(h(Xu,Yu))) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xu,Yu,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xu,Yu,Gcost_new))
                    )
                )
                % It is possible to make long pass, then its cost = 1
                % long_pass
                % ();
                ;
                % It is Touchdown -> then there is heuristic cost with negative value of Euclidian distance to work as lower bound for the cost which will enable us to get an optimal solution
                % , otherwise the heuristic cost is zero as in the above predicates
                (t(Xu,Yu)) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xu,Yu,_)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xu,Yu,Gcost_new))
                    )
                )
                
            ),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (
                addNeighbourhood(Xu,Yu,Nnew,[Xu,Yu|P])
            )
        );
        nextDown(X,Y,Xd,Yd,Vd,P),
        ((Vd == 1) ->
            format('\nAdd down to ~d ~d in Open List', [Xd, Yd]),
            (
                % There is a human, then it is a handover with cost 1
                h(Xd,Yd) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xd,Yd,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xd,Yd,Gcost_new))
                    )
                );
                (not(h(Xd,Yd))) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xd,Yd,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xd,Yd,Gcost_new))
                    )
                )
                % long_pass
                ;
                (t(Xd,Yd)) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xd,Yd,_)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xd,Yd,Gcost_new))   
                    )
                )
                
            ),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (
                addNeighbourhood(Xd,Yd,Nnew,[Xd,Yd|P])
            )
        );
        nextRight(X,Y,Xr,Yr,Vr,P),
        ((Vr == 1) ->
            format('\nAdd Right to ~d ~d in Open List', [Xr, Yr]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xr,Yr) ->
                (   
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xr,Yr,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xr,Yr,Gcost_new)) 
                    )
                );
                (not(h(Xr,Yr))) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xr,Yr,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xr,Yr,Gcost_new))
                    )
                )
                % long_pass
                ;
                (t(Xr,Yr)) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xr,Yr,_)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xr,Yr,Gcost_new))
                    )
                )
            ),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (
                addNeighbourhood(Xr,Yr,Nnew,[Xr,Yr|P])
            )
        );
        nextLeft(X,Y,Xl,Yl,Vl,P),
        ((Vl == 1) ->
            format('\nAdd Left to ~d ~d in Open List', [Xl, Yl]),
            (
                
                % There is a human, then it is a handover with cost 1
                h(Xl,Yl) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xl,Yl,_)) ->
                    (
                        Gcost_new is Gcost_old +1,
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xl,Yl,Gcost_new))
                    )
                );
                (not(h(Xl,Yl))) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xl,Yl,_)) ->
                    (
                        Gcost_new is Gcost_old +2,
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xl,Yl,Gcost_new))
                    )
                )
                % long_pass
                ;
                (t(Xl,Yl)) ->
                (
                    % bagof(GC,aStarOpenList(X,Y,GC),List),
                    % min(List,Gcost_old),
                    aStarClosedList(X,Y,Gcost_old),
                    not(aStarClosedList(Xl,Yl,_)) ->
                    (
                        Gcost_new is Gcost_old - 1,
                        format(" with cost ~d",[Gcost_new]),
                        asserta(aStarOpenList(Xl,Yl,Gcost_new))   
                    )
                )
            ),
            param(NStepsAhead, numStepsAhead),
            succ(N,Nnew),
            (Nnew < NStepsAhead) ->
            (
                addNeighbourhood(Xl,Yl,Nnew,[Xl,Yl|P])
            )
        )
    )
). 

% Source: https://stackoverflow.com/questions/36411848/how-to-use-tranpose-and-findall-to-print-all-the-variables-in-a-predicate
getOpenList(List) :- findall([X,Y,V], aStarOpenList(X,Y,V), List).
printOpenList([]) :- !.
printOpenList([[X,Y,V]|T]) :- format('\n! X: ~d,Y: ~d,V: ~d', [X,Y,V]),printOpenList(T).

getClosedList(List) :- findall([X,Y,V], aStarClosedList(X,Y,V), List).
printClosedList([]) :- !.
printClosedList([[X,Y,V]|T]) :- format('\n! X: ~d,Y: ~d,V: ~d', [X,Y,V]),printClosedList(T).


newList([]) :- !.
newList([[X,Y,V]|T]) :- 
    minOpenList(VV),
    (V < VV) -> 
    (
        retractall(minOpenList(_)),
        asserta(minOpenList(V)),
        newList(T)
    );
    newList(T).

% getMinOpenList([]) :- !.
% getMinOpenList(V,Vnew,[[_,_,Vi]|T]) :- (Vi < V) -> Vnew is Vi, V is Vi, getMinOpenList(V,Vnewnew).

selectMinNode(Xn,Yn) :-
    getOpenList(List),
    % format('\n -------------------------- Open List ---------------------------\n'),
    % printOpenList(List),
    % format('\n -----------------------------------------------------\n'),
    % getClosedList(CList),
    % format('\n -------------------------- Closed List ---------------------------\n'),
    % printClosedList(CList),
    % format('\n -----------------------------------------------------\n'),
    retractall(minOpenList(_)),
    asserta(minOpenList(50000)),
    newList(List),
    minOpenList(C),
    format('\n final minimum cost ~d', C),
    aStarOpenList(Xn,Yn,C),
    inPath(Xn,Yn,P,R).



% getPath([], _) :- !.

% getPath(P,Pp) :-
%     Pp is P.


aStarSearch(X,Y,NStepsAhead,P) :-
    aStarOpenList(X,Y,V), 
    retractall(aStarOpenList(X,Y,_)),
    asserta(aStarClosedList(X,Y,V)),
    format('\nCurrent in (~d,~d)', [X,Y]),
    
    getOpenList(OList),
    format('\n -------------------------- Open List ---------------------------\n'),
    printOpenList(OList),
    format('\n -----------------------------------------------------\n'),
    getClosedList(CList),
    format('\n -------------------------- Closed List ---------------------------\n'),
    printClosedList(CList),
    format('\n -----------------------------------------------------\n'),

    t(Xt,Yt), 
    (reached(X,Y); aStarOpenList(Xt,Yt,Vt)) -> 
    (
        retractall(aStarOpenList(Xt,Yt,_)),
        asserta(aClosedList(Xt,Yt,Vt)),
        Pp = [Xt,Yt|P],
        % getPath(P,Pp),
        printlst(Pp),true);
    addNeighbourhood(X,Y,0,[X,Y|P]);
    selectMinNode(Xnew, Ynew),
    format('\n\n------------------ Selected (~d,~d) -------------------------\n\n', [Xnew, Ynew]),
    aStarOpenList(Xw,Yw,Vw),
    aStarSearch(Xnew,Ynew, NStepsAhead, [X,Y|P]).

qTableRL(X,Y) :-
    true.



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
    ,backtrackSearch(Xs,Ys,[])
    ,format('\n--------------------------------------------------------------\n--------------------------------------------------------------\n--------------------------------------------------------------\n')
    ,format('\n\tCurrent Optimal Paths\t\n')
    ,optimalPath(P)
    ,writeln(P)
    ,format('\n--------------------------------------------------------------\n--------------------------------------------------------------\n--------------------------------------------------------------\n')
    . 

mainRandomSearch :-
    initMain
    ,s(Xs,Ys)
    ,param(NRS_episodes, numEpisodesRS)
    ,randomSearch(Xs,Ys,NRS_episodes, [])
    ,rsStatistics
    .  


mainAStartSearch :-
    initMain
    ,s(Xs,Ys)
    ,param(S_ahead, numStepsAhead)
    ,param(N,mapSize)
    ,asserta(aStarOpenList(2,3,0))
    ,aStarSearch(Xs,Ys,S_ahead, [])
    .  