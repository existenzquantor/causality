:- [interpreter].

/* Check if Fact holds in Program's final state */
finally(Program, Fact) :-   init(S0), 
                            do(Program, S0, S), 
                            satisfied([Fact], S).

/* Compute programs with empty actions */
contrastProgram1(A1 : A2, CP1 : CP2) :- contrastProgram1(A1, CP1), 
                                        contrastProgram1(A2, CP2).
contrastProgram1(A, e) :- action(A).
contrastProgram1(A, A) :- action(A).

/* But-For Cause */
butForCause(Program, Fact, P) :-    findall(CP, contrastProgram1(Program, CP), L), 
                                    member(P, L), 
                                    butForCauseContrast(Program, P, Fact).

butForCauseContrast(Program, ContrastProgram, Fact) :-  negate(Fact, ContrastFact), 
                                                        butForCauseContrast(Program, ContrastProgram, Fact, ContrastFact).
butForCauseContrast(Program, ContrastProgram, Fact, ContrastFact) :-    finally(Program, Fact),
                                                                        \+ finally(ContrastProgram, Fact),
                                                                        finally(ContrastProgram, ContrastFact).