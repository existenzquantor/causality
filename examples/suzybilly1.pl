:- ["../core/causality"].

init([not(shattered)]).
goal([shattered]).

effect(throwsuzy, [not(shattered)], [shattered]).
effect(throwbilly, [not(shattered)], [shattered]).