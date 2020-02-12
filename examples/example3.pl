:- ["../core/causality"].

effect(a, [not(p)], [p]).
effect(b, [not(p)], [p]).

contrast(a, [b]).
contrast(b, [a]).

init([not(p)]).

start :-
    test1,
    writeln(""),
    test2,
    writeln(""),
    test3,
    writeln(""),
    test4,
    writeln(""),
    test5.

test1 :- P = a : b, C = empty : b, F = p, cause_contrast(P, C, F) -> write("Yes");write("No").
test2 :- P = a : b, C = eempty : b, F = p, cause_temporal(P, C, F) -> write("Yes");write("No").
test3 :- P = a : b, F = p, cause_empty_temporal(P, F, CP) -> write("Yes "), write(CP);write("No").
test4 :- P = a : b, F = p, cause_nonempty_temporal(P, F, CP) -> write("Yes "), write(CP);write("No").
test5 :- P = a : b, F = p, cause_empty_nonempty_temporal(P, F, CP) -> write("Yes "), write(CP);write("No").