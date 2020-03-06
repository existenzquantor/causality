effect(a, [not(p)], [p]).
effect(b, [p], [q]).

contrast(a, [b]).

init([not(p), not(q)]).

goal([p, q]).