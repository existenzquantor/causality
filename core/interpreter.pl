/* Interpreter */
do(A1 : A2, S, Snext) :- do(A1, S, S2), do(A2, S2, Snext).
do(A, S, Snext) :- action(A), apply(A, S, Snext).

satisfied(P, S) :- subset(P, S).

apply(A, S, Snext) :- findall(E, (eff(A, C, E), satisfied(C, S)), L1),
                        flatten(L1, L2),
                        list_to_set(L2, L3),
                        negate_all(L3, L4),
                        removeDoubleNeg(L4, L5),
                        subtract(S, L5, S2),
                        union(S2, L3, Snext).

negate(F, Fneg) :- removeDoubleNegAtom(not(F), Fneg).
removeDoubleNegAtom(not(not(A)), Anew) :- removeDoubleNegAtom(A, Anew), !.
removeDoubleNegAtom(A, A).

negate_all(L, Lnew) :- negate_all(L, [], Lnew).
negate_all([], L, L).
negate_all([X | R], L, Erg) :- negate_all(R, [not(X) | L], Erg).

removeDoubleNeg(L1, L2) :- removeDoubleNeg(L1, [], L2).
removeDoubleNeg([], L, L).
removeDoubleNeg([not(not(X)) | R], L, Result) :-
    removeDoubleNeg(R, [X | L], Result), !.
removeDoubleNeg([X | R], L, Result) :-
    removeDoubleNeg(R, [X | L], Result), !.


start :- removeDoubleNegAtom(not(not(not(not(a)))), B), write(B).