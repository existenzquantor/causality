/* Interpreter */
:- [logic].

/* Execute Program */
do(A1 : A2, S, Snext) :- 
    do(A1, S, S2), 
    do(A2, S2, Snext).
do(A, S, Snext) :- 
    atom(A), 
    apply(A, S, Snext).

/* Apply Action to State */
apply(A, S, Snext) :- 
    findall(E, (effect(A, C, E), satisfied(C, S)), L1),
    flatten(L1, L2),
    list_to_set(L2, L3),
    negate_all(L3, L4),
    subtract(S, L4, S2),
    union(S2, L3, Snext).