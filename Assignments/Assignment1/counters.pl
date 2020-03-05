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

%--------------------------------
:- dynamic rscounter/1.

initrscounter :-
    retractall(rscounter(_)),
    assertz(rscounter(0)).

incrrscounter :-
    rscounter(V),
    retractall(rscounter(_)),
    succ(V, V1),
    assertz(rscounter(V1)).

decrrscounter :-
    rscounter(V),
    retractall(rscounter(_)),
    succ(V0, V),
    assertz(rscounter(V0)).
                    