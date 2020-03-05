import argparse
parser = argparse.ArgumentParser(description='Utilizations for automatic coding for prolog')
parser.add_argument(
    '--counter-name',
    default=None, 
    type=str, 
    help='Name of the counter to be created')

def create_counter(name):
    with open("tmp_py_gen.txt",'w') as file:
        file.write('''%--------------------------------
:- dynamic {name}/1.

init{name} :-
    retractall({name}(_)),
    assertz({name}(0)).

incr{name} :-
    {name}(V),
    retractall({name}(_)),
    succ(V, V1),
    assertz({name}(V1)).

decr{name} :-
    {name}(V),
    retractall({name}(_)),
    succ(V0, V),
    assertz({name}(V0)).
                    '''.format(name=name)
                    )

if __name__ == "__main__":
    args = parser.parse_args()
    if(args.counter_name is not None):
        create_counter(args.counter_name)
    
    