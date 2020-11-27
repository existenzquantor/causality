:- module(interpreter, [do/3, finally/2, is_goal/1, is_fact/1, action/1]).
:- use_module(logic, [negate_all/2, satisfied/2]).

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

/* Check if Fact holds in Program's final state */
finally(Program, Fact) :-
    init(S0), 
    do(Program, S0, S), 
    member(Fact, S).
/* Check if Fact is a Goal */
is_goal(Fact) :-
    goal(G),
    member(Fact, G).
is_fact(Fact) :- 
    init(I),
    member(Fact, I).
is_fact(Fact) :- 
    init(I),
    negate_all(I, IN),
    member(Fact, IN).
action(A) :- effect(A, _, _).