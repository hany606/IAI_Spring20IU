:- dynamic passcounter/1.

initpasscounter :-
    retractall(passcounter(_)),
    assertz(passcounter(0)).

incrpasscounter :-
    passcounter(V),
    retractall(passcounter(_)),
    succ(V, V1),
    assertz(passcounter(V1)).

decrpasscounter :-
    passcounter(V),
    retractall(passcounter(_)),
    succ(V0, V),
    assertz(passcounter(V0)).

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
                    