:- ["../core/causality"].

action(a).
action(b).
action(c).
action(e).

eff(a, [not(p)], [p]).
eff(a, [p], [not(p)]).

init([not(p)]).

start :- Program = a : a, butForCause(Program, not(p), Witness) -> write("YES "), write(Witness);write("NO").