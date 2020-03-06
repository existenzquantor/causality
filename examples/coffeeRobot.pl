init([
    not(coff1), 
    not(coff2), 
    not(coff3), 
    not(coffMrSmith), 
    not(coffMrsSmith), 
    not(coffMrsBrown), 
    locKitchen, 
    not(locHall), 
    not(locDining), 
    not(locBalcony)
]).

goal([
    coffMrSmith,
    coffMrsSmith,
    coffMrsBrown
]).

effect(brew, [not(coff1)], [coff1]).
effect(brew, [not(coff2)], [coff2]).
effect(brew, [not(coff3)], [coff3]).
effect(serve, [coff3], [not(coff3)]).
effect(serve, [coff2], [not(coff2)]).
effect(serve, [coff1], [not(coff1)]).