- module(programs, [prefix_n_times/3, program_length/2, program_to_list/2]).

list_to_program(L, P) :- 
    reverse(L, Lr),
    list_to_program(Lr, empty-program, P).
list_to_program([], P, P).
list_to_program([A | R], P, Erg) :- 
    P \= empty-program, 
    list_to_program(R, A : P, Erg).
list_to_program([A | R], P, Erg) :- 
    P == empty-program, 
    list_to_program(R, A, Erg).

program_to_list(P, L) :- 
    program_to_list(P, [], L).
program_to_list(P, L, L2) :- 
    atom(P), 
    append(L, [P], L2).
program_to_list(P : Q, L, Erg) :- 
    append(L, [P], L2), 
    program_to_list(Q, L2, Erg).

prefix_n_times(P, 0, P).
prefix_n_times(P, N, Erg) :- 
    prefix(P, [], Pnew),
    Nnew is N - 1,
    prefix_n_times(Pnew, Nnew, Erg).
prefix(A, S, P) :-  
    atom(A), 
    list_to_program(S, P).
prefix(A : B, R, L) :- 
    append(R, [A], List), 
    prefix(B, List, L).

program_length(A, 1) :- 
    atom(A).
program_length(A : B, N) :- 
    program_length(A, N1),
    program_length(B, N2),
    N is N1 + N2.