:- ["../core/causality"].

action(steal_cake).
action(buy_cake).
action(steal_banana).
action(eat).
action(e). % Empty Action

eff(steal_cake, [], [have_cake]).
eff(buy_cake, [], [have_cake]).
eff(steal_banana, [], [have_banana]).
eff(eat, [have_cake], [pain]).

init([not(have_cake), not(have_banana), not(pain)]).

start :-    test1,
            write("\n"),
            test2,
            write("\n"),
            test3,
            write("\n"),
            test4.

test1 :- Program = steal_cake : eat, init(S0), do(Program, S0, S), write(S).
test2 :- Program = steal_cake : eat, butForCause(Program, pain, Witness) -> write("YES "), write(Witness);write("NO").
test3 :- Program = steal_cake : eat, butForCauseContrast(Program, buy_cake : eat, pain) -> write("YES ");write("NO").
test4 :- Program = steal_cake : eat, butForCauseContrast(Program, steal_banana : eat, pain) -> write("YES ");write("NO").
