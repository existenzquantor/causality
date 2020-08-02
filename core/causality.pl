:- dynamic
    effect/3,
    init/1,
    goal/1,
    contrast/2.
:- [interpreter].
:- [programs].

/* Check if Fact holds in Program's final state */
finally(Program, Fact) :-
    init(S0), 
    do(Program, S0, S), 
    satisfied([Fact], S).
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

/* Helper Predicates for Temporal Reasoning */
holds_since(Program, Fact, 0) :- 
    finally(Program, Fact).
holds_since(Program, Fact, N) :-
    N > 0,
    prefix_n_times(Program, N, Pnew),
    finally(Pnew, Fact),
    Nnew is N - 1,
    holds_since(Program, Fact, Nnew).
maximum_holds_since(Program, Fact, Max) :-
    finally(Program, Fact),
    program_length(Program, Nprog),
    max_holds_since(Program, Fact, Nprog, Max).
max_holds_since(Program, Fact, MaxCur, MaxCur) :- 
    holds_since(Program, Fact, MaxCur), !.
max_holds_since(Program, Fact, MaxCur, Max) :-
    MaxCurnew is MaxCur - 1, 
    max_holds_since(Program, Fact, MaxCurnew, Max). 

/* Compute programs with empty actions */
contrast_program1(A1 : A2, CP1 : CP2) :- 
    contrast_program1(A1, CP1), 
    contrast_program1(A2, CP2).
contrast_program1(A, empty) :- action(A).
contrast_program1(A, A) :- action(A), !.

/* Compute programs with action-specific substitution by empty actions */
contrast_program1(A1 : A2, CP1 : CP2, Act) :- 
    action(Act),
    contrast_program1(A1, CP1, Act),
    contrast_program1(A2, CP2, Act).
contrast_program1(Act, empty, Act) :- action(Act).
contrast_program1(A, A, _) :- action(A), !.

/* Compute programs with contrast actions */
contrast_program2(A1 : A2, CP1 : CP2) :- 
    contrast_program2(A1, CP1), 
    contrast_program2(A2, CP2).
contrast_program2(A, C) :-
    action(A), 
    contrast(A, CL), 
    member(C, CL).
contrast_program2(A, A) :- action(A), !.

/* Compute programs with with action-specific substitution contrast actions */
contrast_program2(A1 : A2, CP1 : CP2, Act) :-
    action(Act),
    contrast_program2(A1, CP1, Act), 
    contrast_program2(A2, CP2, Act).
contrast_program2(A, C, Act) :- 
    A == Act,
    contrast(A, CL), 
    member(C, CL).
contrast_program2(A, A, _) :- action(A), !.

/* Compute programs with empty or contrast actions */
contrast_program3(A1 : A2, CP1 : CP2) :- 
    contrast_program3(A1, CP1), 
    contrast_program3(A2, CP2).
contrast_program3(A, empty) :- action(A).
contrast_program3(A, C) :- 
    action(A), 
    contrast(A, CL), 
    member(C, CL).
contrast_program3(A, A) :- action(A), !.

/* Compute programs with action-specific substitution by empty or contrast actions */
contrast_program3(A1 : A2, CP1 : CP2, Act) :- 
    action(Act),
    contrast_program3(A1, CP1, Act), 
    contrast_program3(A2, CP2, Act).
contrast_program3(A, empty, Act) :- 
    A == Act.
contrast_program3(A, C, Act) :- 
    A == Act, 
    contrast(A, CL), 
    member(C, CL).
contrast_program3(A, A, _) :- action(A), !.

/* But-For Cause */
but_for_cause(Program, Action, Fact, CP) :-
    contrast_program1(Program, CP, Action),
    cause_contrast(Program, CP, Fact).
but_for_cause(Program, Fact, CP) :- 
    contrast_program1(Program, CP), 
    cause_contrast(Program, CP, Fact).

/* Contrastive Cause */
cause_empty_contrast(Program, Action, Fact, CP) :-
    contrast_program1(Program, CP, Action),
    cause_contrast(Program, CP, Fact).
cause_empty_contrast(Program, Fact, CP) :-
    contrast_program1(Program, CP),
    cause_contrast(Program, CP, Fact).
cause_nonempty_contrast(Program, Action, Fact, CP) :-
    contrast_program2(Program, CP, Action),
    cause_contrast(Program, CP, Fact).
cause_nonempty_contrast(Program, Fact, CP) :-
    contrast_program2(Program, CP),
    cause_contrast(Program, CP, Fact).
cause_empty_nonempty_contrast(Program, Action, Fact, CP) :-
    contrast_program3(Program, CP, Action),
    cause_contrast(Program, CP, Fact).
cause_empty_nonempty_contrast(Program, Fact, CP) :-
    contrast_program3(Program, CP),
    cause_contrast(Program, CP, Fact).
cause_contrast(Program, ContrastProgram, Fact) :-
    negate(Fact, ContrastFact), 
    cause_contrast(Program, ContrastProgram, Fact, ContrastFact).
cause_contrast(Program, ContrastProgram, Fact, ContrastFact) :-    
    finally(Program, Fact),
    \+ finally(ContrastProgram, Fact),
    finally(ContrastProgram, ContrastFact).

/* Cause due to Temporal Shift or Non-Occurrence in Final State */
cause_empty_temporal(Program, Action, Fact, CP) :-
    contrast_program1(Program, CP, Action),
    cause_temporal(Program, CP, Fact).
cause_empty_temporal(Program, Fact, CP) :-
    contrast_program1(Program, CP),
    cause_temporal(Program, CP, Fact).
cause_nonempty_temporal(Program, Action, Fact, CP) :-
    contrast_program2(Program, CP, Action),
    cause_temporal(Program, CP, Fact).
cause_nonempty_temporal(Program, Fact, CP) :-
    contrast_program2(Program, CP),
    cause_temporal(Program, CP, Fact).
cause_empty_nonempty_temporal(Program, Action, Fact, CP) :-
    contrast_program3(Program, CP, Action),
    cause_temporal(Program, CP, Fact).
cause_empty_nonempty_temporal(Program, Fact, CP) :-
    contrast_program3(Program, CP),
    cause_temporal(Program, CP, Fact).
cause_temporal(Program, ContrastProgram, Fact) :-
    cause_contrast(Program, ContrastProgram, Fact).
cause_temporal(Program, ContrastProgram, Fact) :-
    maximum_holds_since(Program, Fact, ProgMax), 
    maximum_holds_since(ContrastProgram, Fact, CProgMax),
    CProgMax < ProgMax. % Fact stabilizes later


/* From Causes to Reasons */
reason_but_for_cause(Fact, Action, Program, CP) :-
    is_goal(Fact),
    but_for_cause(Program, Action, Fact, CP).
reason_empty_temporal(Fact, Action, Program, CP) :-
    is_goal(Fact),
    cause_empty_temporal(Program, Action, Fact, CP).
reason_nonempty_contrast(Fact, Action, Program, CP) :-
    is_goal(Fact),
    cause_nonempty_contrast(Program, Action, Fact, CP).
reason_nonempty_temporal(Fact, Action, Program, CP) :-
    is_goal(Fact),
    cause_nonempty_temporal(Program, Action, Fact, CP).

/* Weaker Reasons, viz., without a goal */
reason_but_for_cause_nogoal(Fact, Action, Program, CP) :-
    is_fact(Fact),
    but_for_cause(Program, Action, Fact, CP).
reason_empty_temporal_nogoal(Fact, Action, Program, CP) :-
    is_fact(Fact),
    cause_empty_temporal(Program, Action, Fact, CP).
reason_nonempty_contrast_nogoal(Fact, Action, Program, CP) :-
    is_fact(Fact),
    cause_nonempty_contrast(Program, Action, Fact, CP).
reason_nonempty_temporal_nogoal(Fact, Action, Program, CP) :-
    is_fact(Fact),
    cause_nonempty_temporal_nogoal(Program, Action, Fact, CP).