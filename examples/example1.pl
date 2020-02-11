:- ["../core/causality"].

action(a).
action(e). % Empty Action

eff(a, [not(p)], [p]).
eff(a, [p], [not(p)]).

init([not(p)]).

start :- test1,
        write("\n"),
        test2,
        write("\n").

test1 :- Program = a : a, butForCause(Program, not(p), Witness) -> write("YES "), write(Witness);write("NO").
test2 :- Program = a, butForCause(Program, not(p), Witness) -> write("YES "), write(Witness);write("NO").