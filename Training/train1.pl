% Source: https://www.doc.gold.ac.uk/~mas02gw/prolog_tutorial/prologpages/

% Rules and Facts should be provided through files using consult or -s parameters
% to run a file: swipl -s file_name.pl
% to add data from the file, enter the swipl, then type consult("<file_name.pl>"). or run the file directly with the knowledge base that defined in the file itself

% The only thing that affect by running the file is the definition of the knowledge base for the facts and the rules

% Care that every line should be ended with dot .

% Define rule & fact

eats(fred, mango).


% Query

% True
eats(fred,mango).

% False
eats(fred, apple).

% Unification with variable

%eats(fred, What).

% Now What is variable and it is equale to mango, variables are identified with Capital letters in the begining, otherwise, it will be query

eats(fred, what).


tape(1,van_morrison,astral_weeks,madam_george).

tape(2,beatles,sgt_pepper,a_day_in_the_life).


tape(3,beatles,abbey_road,something).


tape(4,rolling_stones,sticky_fingers,brown_sugar).


tape(5,eagles,hotel_california,new_kid_in_town).

% tape(5,Artist,Album,Fave_Song).	% Get the song of 5th tape and get the artist and the album and the favourite song

% tape(4,rolling_stones,sticky_fingers,Song).  /* find just  song */



% Rules ----------------------
blue(my_bike).
bike(my_bike).

red(tim_bike).
bike(tim_bike).


mine(X) :-
	blue(X),
	bike(X).


/*
mine(my_bike).
mine(X).		will get my_bike as query on which one is mine
red(X).		will get tim_bike as query on which one is red
*/

% Operations
% ; is or 
% , is and
% @> sorted list

% To return something from the query

teacher(nikita, networks)
teacher(nikita, ai)

% pair(T1, T2) :-
	teacher(T1, Course),
	teacher(T2, Course),
	T1 @> T2.
