:- module(interpreter, [do/3, 
                        do/4, 
                        finally/2, 
                        finally/3, 
                        is_goal/1, 
                        is_fact/1, 
                        action/1,
                        generate_plan/3]).
:- use_module(logic, [negate_all/2, satisfied/2]).
:- use_module(programs, [list_to_program/2]).

/* Planning */
generate_program(Length, P) :-
    generate_program(Length, [], Pr),
    list_to_program(Pr, P).
generate_program(0, P, P).
generate_program(Length, T, P) :-
    Length > 0,
    L2 is Length - 1,
    effect(A, _, _),
    \+number(A),
    generate_program(L2, [A | T], P).
generate_program(Length, T, P) :-
    Length > 0,
    L2 is Length - 1,
    generate_program(L2, [empty | T], P).

generate_plan(Length, Goal, P) :-
    generate_program(Length, P),
    findall(X, finally(P, X), Fin),
    subset(Goal, Fin).

/* Execute Program */
do(A, S, Snext) :-
    do(A, S, Snext, 0).
do(A1 : A2, S, Snext, T) :- 
    do(A1, S, S2, T), 
    T2 is T + 1,
    do(A2, S2, Snext, T2).
do(A, S, Snextnext, T) :- 
    action(A),
    apply(A, S, Snext),
    apply(T, Snext, Snextnext).

/* Execute Program (Instrumentality) */
do(A, S, Snext, Instrumental) :-
    do(A, S, Snext, 0, Instrumental).
do(A1 : A2, S, Snext, T, Instrumental) :- 
    do(A1, S, S2, T, Instrumental), 
    T2 is T + 1,
    do(A2, S2, Snext, T2, Instrumental).
do(A, S, Snextnext, T, Instrumental) :- 
    action(A), 
    apply(A, S, Snext, Instrumental),
    (apply(T, Snext, Snextnext, Instrumental) -> true; true).

/* Apply Action to State */
apply(A, S, Snext) :- 
    findall(E, (effect(A, C, E), satisfied(C, S)), L1),
    flatten(L1, L2),
    list_to_set(L2, L3),
    negate_all(L3, L4),
    subtract(S, L4, S2),
    union(S2, L3, Snext).

/* Apply Action and leaving out potentially instrumental effect */
apply(A, S, Snext, Instrumental) :- 
    findall(E, (effect(A, C, E), satisfied(C, S)), L1),
    flatten(L1, L2),
    list_to_set(L2, L3),
    subtract(L3, [Instrumental], L3b), % Instrumental
    negate_all(L3b, L4),
    subtract(S, L4, S2),
    union(S2, L3b, Snext).
apply(A, S, Snext, _) :-
    apply(A, S, Snext).

/* Check if Fact holds in Program's final state */
finally(Program, Fact) :-
    init(S0), 
    do(Program, S0, S), !, 
    member(Fact, S).

/* Check if Fact holds in Program's final state (Instrumentality) */
finally(Program, Fact, Instrumental) :-
    init(S0), 
    do(Program, S0, S, Instrumental) *-> member(Fact, S), ! ; fail.

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

action(empty).
action(A) :- effect(A, _, _).