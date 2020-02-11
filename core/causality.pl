:- [interpreter].

/* Check if Fact holds in Program's final state */
finally(Program, Fact) :-   init(S0), 
                            do(Program, S0, S), 
                            satisfied([Fact], S).

/* Compute programs with empty actions */
contrast_program1(A1 : A2, CP1 : CP2) :-    contrast_program1(A1, CP1), 
                                            contrast_program1(A2, CP2).
contrast_program1(A, e) :- action(A).
contrast_program1(A, A) :- action(A).

/* But-For Cause */
but_for_cause(Program, Fact, P) :-      findall(CP, contrast_program1(Program, CP), L), 
                                        member(P, L), 
                                        cause_contrast(Program, P, Fact).

cause_contrast(Program, ContrastProgram, Fact) :-   negate(Fact, ContrastFact), 
                                                    cause_contrast(Program, ContrastProgram, Fact, ContrastFact).
cause_contrast(Program, ContrastProgram, Fact, ContrastFact) :-    finally(Program, Fact),
                                                                    \+ finally(ContrastProgram, Fact),
                                                                    finally(ContrastProgram, ContrastFact).