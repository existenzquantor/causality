/* Interpreter */
do(A1 : A2, S, Snext) :- do(A1, S, S2), do(A2, S2, Snext).
do(A, S, Snext) :- action(A), apply(A, S, Snext).

satisfied(P, S) :- subset(P, S).

apply(A, S, Snext) :- findall(E, (effect(A, C, E), satisfied(C, S)), L1),
                        flatten(L1, L2),
                        list_to_set(L2, L3),
                        negate_all(L3, L4),
                        remove_double_neg(L4, L5),
                        subtract(S, L5, S2),
                        union(S2, L3, Snext).

negate(F, Fneg) :- remove_double_negAtom(not(F), Fneg).
remove_double_negAtom(not(not(A)), Anew) :- remove_double_negAtom(A, Anew), !.
remove_double_negAtom(A, A).

negate_all(L, Lnew) :- negate_all(L, [], Lnew).
negate_all([], L, L).
negate_all([X | R], L, Erg) :- negate_all(R, [not(X) | L], Erg).

remove_double_neg(L1, L2) :- remove_double_neg(L1, [], L2).
remove_double_neg([], L, L).
remove_double_neg([not(not(X)) | R], L, Result) :-
    remove_double_negAtom(X, Xnew),
    remove_double_neg(R, [Xnew | L], Result), !.
remove_double_neg([X | R], L, Result) :-
    remove_double_neg(R, [X | L], Result), !.