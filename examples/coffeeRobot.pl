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
effect(brew, [coff1, not(coff2)], [coff2]).
effect(brew, [coff2, not(coff3)], [coff3]).
effect(serve, [coff3], [not(coff3)]).
effect(serve, [coff2, not(coff3)], [not(coff2)]).
effect(serve, [coff1, not(coff2)], [not(coff1)]).
effect(serve, [locDining, not(coffMrSmith), coffMrsSmith], [coffMrSmith]).
effect(serve, [locDining, not(coffMrsSmith)], [coffMrsSmith]).
effect(serve, [locBalcony, not(coffMrsBrown)], [coffMrsBrown]).
effect(enterKitchen, [locHall], [not(locHall), locKitchen]).
effect(leaveKitchen, [locKitchen], [not(locKitchen), locHall]).
effect(enterDining, [locHall], [not(locHall), locDining]).
effect(leaveDining, [locDining], [not(locDining), locHall]).
effect(enterBalcony, [locHall], [not(locHall), locBalcony]).
effect(leaveBalcony, [locBalcony], [not(locBalcony), locHall]).