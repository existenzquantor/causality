/* Check if facts F are satisfied in State S */
satisfied(F, S) :- 
    subset(F, S).

/* Negating Facts and Lists of Facts */
negate(F, Fneg) :- 
    remove_double_negAtom(not(F), Fneg).
remove_double_negAtom(not(not(A)), Anew) :- 
    remove_double_negAtom(A, Anew), !.
remove_double_negAtom(A, A).

negate_all(L, Lnew) :- 
    negate_all(L, [], Lnew).
negate_all([], L, L).
negate_all([X | R], L, Erg) :- 
    negate(X, Xneg),
    negate_all(R, [Xneg | L], Erg).

remove_double_neg(L1, L2) :- 
    remove_double_neg(L1, [], L2).
remove_double_neg([], L, L).
remove_double_neg([not(not(X)) | R], L, Result) :-
    remove_double_negAtom(X, Xnew),
    remove_double_neg(R, [Xnew | L], Result), !.
remove_double_neg([X | R], L, Result) :-
    remove_double_neg(R, [X | L], Result), !.