:- [interpreter].
:- [programs].

/* Check if Fact holds in Program's final state */
finally(Program, Fact) :-
    init(S0), 
    do(Program, S0, S), 
    satisfied([Fact], S).

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
contrast_program1(A, e) :- action(A).
contrast_program1(A, A) :- action(A).

/* But-For Cause */
but_for_cause(Program, Fact, CP) :- 
    contrast_program1(Program, CP), 
    cause_contrast(Program, CP, Fact).

/* Contrastive Cause */
cause_contrast(Program, ContrastProgram, Fact) :-
    negate(Fact, ContrastFact), 
    cause_contrast(Program, ContrastProgram, Fact, ContrastFact).
cause_contrast(Program, ContrastProgram, Fact, ContrastFact) :-    
    finally(Program, Fact),
    \+ finally(ContrastProgram, Fact),
    finally(ContrastProgram, ContrastFact).

/* Cause due to Temporal Shift or Non-Occurrence in Final State */
cause_temporal(Program, ContrastProgram, Fact) :-
    cause_contrast(Program, ContrastProgram, Fact).
cause_temporal(Program, ContrastProgram, Fact) :-
    maximum_holds_since(Program, Fact, ProgMax), 
    maximum_holds_since(ContrastProgram, Fact, CProgMax),
    CProgMax < ProgMax. % Fact stabilizes later