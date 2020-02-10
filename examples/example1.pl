:- ["../causality"].

action(a).
action(b).
action(c).
action(e).

eff(a, [], p).
eff(b, [], q).
eff(c, [p, q], t).

init([not(p), not(q), not(t)]).

start :- Program = a : b : c, butForCause(Program, t, Witness) -> write("YES "), write(Witness);write("NO").