:- ["../../core/causality"].

effect(a, [not(p)], [p]).
effect(b, [p], [q]).

contrast(a, [b]).

init([not(p), not(q)]).

goal([p, q]).

start :-
    test1,
    test2,
    test3.

test1 :- reason_but_for_cause(Reason, a, a:b, Witness) -> write(Reason), write(" "), writeln(Witness); writeln("No").
test2 :- reason_empty_temporal(Reason, a, a:b, Witness) -> write(Reason), write(" "), writeln(Witness); writeln("Nope").
test3 :- reason_nonempty_contrast(Reason, a, a:b, Witness) -> write(Reason), write(" "),writeln(Witness); writeln("Nope").