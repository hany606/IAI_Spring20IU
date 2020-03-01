/*
    Author: Hany Hamed
    Description: File for Rules for Assignment 1 in Intro to AI Spring 2020 Innopolis University
    Resources:
    - https://stackoverflow.com/questions/4805601/read-a-file-line-by-line-in-prolog
    - https://www.swi-prolog.org/pldoc/doc_for?object=re_split/3
    - https://stackoverflow.com/questions/22747147/swi-prolog-write-to-file
    - https://www.swi-prolog.org/pldoc/ 
*/
read_file(X):-
    open('input.txt', read, Str),
    read_file_util(Str,X),
    % write(X), nl.
    close(Str).

read_file_util(Stream,[]) :-
    at_end_of_stream(Stream).

read_file_util(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read(Stream,X),
    read_file_util(Stream,L).



writefacts(Type,XX,YY) :-
    % write("--\t"), write(X),write("\t"), write(Y),  write("\t--\n"),
    atom_number(XX,X),
    atom_number(YY,Y),
    open('facts.txt',append,Out),
    format(atom(Tmp_out), '~s(~D,~D).\n', [Type,X,Y]),
    write(Out,Tmp_out),
    % write("finish\n"),
    close(Out). 

% object(h,X,Y) :-
%     human(3,4).

% object(t,X,Y) :-
%     touchdown(5,6).

% parse2([_(X,Y)_|T]) :-
parse([]).
parse([Z|T]) :-
    re_split('[oth]', Z, [_,Type,Rest], []),
    re_split('\\(', Rest, [_,_,Rest1], []),
    re_split('\\)', Rest1, [Num|_], []),
    re_split('\\s', Num, [X,_,Y], []),

    % write(Type), write('\t'), 
    % write(Rest), write('\t'), 
    % write(Rest1), write('\t'), 
    % write(Num), write('\t'), 
    % write(X), write('\t'),
    % write(Y), nl,
    % upper_lower(Type, TType),
    % write(Type),
    writefacts(Type, X,Y),
    parse(T).

% , nl, write(Y).
% re_split("  ", "O(12,3)", Split, []).

main :-
    open('facts.txt',write,Out),
    write(Out,""),
    close(Out),
    read_file(Input),
    parse(Input),
    consult("facts.txt").

% empty (X,Y):-
%     \+ o(X,Y),
%     \+ h(X,Y).
