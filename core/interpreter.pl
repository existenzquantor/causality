/* Interpreter */
do(A1 : A2, S, Snext) :- do(A1, S, S2), do(A2, S2, Snext).
do(A, S, Snext) :- action(A), apply(A, S, Snext).

satisfied(P, S) :- subset(P, S).

removeDoubleNeg([], L, L) :- !.
removeDoubleNeg([not(not(X)) | R], L, Result) :-
    removeDoubleNeg(R, [X | L], Result), !.
removeDoubleNeg([X | R], L, Result) :-
    removeDoubleNeg(R, [X | L], Result), !.

apply(A, S, Snext) :- findall(not(E), (eff(A, C, E), satisfied(C, S)), Lneg), 
                        removeDoubleNeg(Lneg, [], Lneg2),
                        findall(E, (eff(A, C, E), satisfied(C, S)), Lpos),
                        subtract(S, Lneg2, S2),
                        union(S2, Lpos, Snext).