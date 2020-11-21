/* Interpreter */
:- [logic].

/* Execute Program */
do(A, S, Snext) :-
    do(A, S, Snext, 0).
do(A1 : A2, S, Snext, T) :- 
    do(A1, S, S2, T), 
    T2 is T + 1,
    do(A2, S2, Snext, T2).
do(A, S, Snextnext, T) :- 
    atom(A), 
    apply(A, S, Snext),
    apply(T, Snext, Snextnext).

/* Apply Action to State */
apply(A, S, Snext) :- 
    findall(E, (effect(A, C, E), satisfied(C, S)), L1),
    flatten(L1, L2),
    list_to_set(L2, L3),
    negate_all(L3, L4),
    subtract(S, L4, S2),
    union(S2, L3, Snext).