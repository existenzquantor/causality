effect(steal_cake, [], [have_cake]).
effect(buy_cake, [], [have_cake]).
effect(steal_banana, [], [have_banana]).
effect(eat, [have_cake], [pain]).

contrast(steal_cake, [buy_cake]).

init([not(have_cake), not(have_banana), not(pain)]).