:- ["../../core/causality"].

effect(a, [not(p)], [p]).
effect(a, [p], [not(p)]).

init([not(p)]).

start :-
    test1,
    write("\n"),
    test2.

test1 :- Program = a : a, but_for_cause(Program, not(p), Witness) -> write("YES "), write(Witness);write("NO").
test2 :- Program = a, but_for_cause(Program, not(p), Witness) -> write("YES "), write(Witness);write("NO").