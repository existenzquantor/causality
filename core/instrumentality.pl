:- module(instrumentality, [instrumental/3]).
:- use_module(interpreter, [finally/2, finally/3]).
:- use_module(logic, [negate/2]).

instrumental(Program, InstrumentalFact, TargetFact) :-
    finally(Program, TargetFact),
    negate(TargetFact, TargetFactNeg),
    finally(Program, TargetFactNeg, InstrumentalFact).