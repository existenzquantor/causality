:- ["../core/causality"].

action(e). % empty action
action(a).
action(b).

effect(a, [not(p)], [p]).
effect(b, [not(p)], [p]).

init([not(p)]).

start :-
    test1,
    writeln(""),
    test2.

test1 :- P = a : b, C = e : b, F = p, cause_contrast(P, C, F) -> write("Yes");write("No").
test2 :- P = a : b, C = e : b, F = p, cause_temporal(P, C, F) -> write("Yes");write("No").