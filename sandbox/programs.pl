

last(A, A) :- atom(A).
last(_ : B, C) :- last(B, C).

list_to_program(L, P) :- reverse(L, Lr),
                         list_to_program(Lr, empty-program, P).
list_to_program([], P, P).
list_to_program([A | R], P, Erg) :- P \= empty-program, list_to_program(R, A : P, Erg).
list_to_program([A | R], P, Erg) :- P == empty-program, list_to_program(R, A, Erg).

program_to_list(P, L) :- program_to_list(P, [], L).
program_to_list(P, L, L2) :- atom(P), append(L, [P], L2).
program_to_list(P : Q, L, Erg) :- append(L, [P], L2), program_to_list(Q, L2, Erg).

prefix(A, S, P) :- atom(A), list_to_program(S, P).
prefix(A : B, R, L) :- append(R, [A], List), prefix(B, List, L).

start :- list_to_program([a, b, c, d], L), write(L).
%start :- program_to_list(a:b:c:d, L), write(L).