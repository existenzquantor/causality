:- ["../core/causality"].

effect(a, [not(p)], [p]).
effect(b, [p], [q]).

init([not(p), not(q)]).

goal([p, q]).

start :-
    test1.

test1 :- reason_but_for_cause(Reason, empty, a:b:empty, Witness) -> writeln(Reason),writeln(Witness); writeln("No").