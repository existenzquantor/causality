# causality

## Installation

Make sure SWI Prolog is installed on your machine. SWI Prolog is available in common Linux package repositories, and Mac users can easily install it via brew. Start a terminal and write _swipl_. If the command successfully starts the Prolog shell, everything is fine. 

Then clone or download this github repository. Make sure the file _causality_ is executable, viz., run _chmod +x causality_. That's it.

## Using the program

### Example: Suzy and Billy

#### Domain Description

*Suzy throws a rock at the bottle. Billy throws his rock only if Suzy's does not hit. Suzy hits the bottle. The bottle shatters.* The narrative can be represented by the program <code>throwsuzy:throwbilly</code> under the domain description shown below:

```prolog
init([not(shattered)]).
goal([shattered]).

effect(throwsuzy, [not(shattered)], [shattered]).
effect(throwbilly, [not(shattered)], [shattered]).
```

This domain description is written in the file *./examples/suzybilly.pl*. States are generally represented as lists of literals. The first line means that initially the bottle is not shattered. The goal is to make *shattered* true. The effect of throwing the rock at the bottle is that the bottle shatters in case it is not yet shattered. This is represented by the *effect* predictates: First argument is the action name, second argument a set of preconditions that must hold for the action to take effect, and the effect is represented by the list of literals at the third argument. For every action name, several such *effect* assertions may be present. This way, the effects under various conditions can be modeled.

The causal reasoner can be queried to answer two types of questions: 

1. Why does *Literal* finally hold? E.g., why does *shattered* finally hold? The answer will be in terms of the actions that caused *Literal*.
1. Why was *Action* performed? E.g., why was *throwsuzy* performed? The answer will be in terms of the caused goal literals (reasons) of *Action*.

#### Causes

First, ask what caused the shattering under the but-for definition of causality:
```
./causality ./examples/suzybilly1.pl throwsuzy:throwbilly shattered but_for
```

The answer is the empty set: Leaving out *throwsuzy* would still result in *shattered* due to *throwbilly*; and also leaving out *throwbilly* would not prevent *shattered*. Thus, none of the actions is a but-for cause. However, if Suzy hadn't thrown, then *shattered* would have happened later. Therefore, *throwsuzy* is a cause according to the temporal-fragility definition of causality called *temporal_empty* (why it is called *empty* will be explained later):
```
./causality ./examples/suzybilly1.pl throwsuzy:throwbilly shattered temporal_empty
```

The output is a singleton list of pairs of actions and justifications <code>[(throwsuzy,empty:throwbilly)]</code>. Particularly, this tells us that *throwsuzy* is a cause. And it gives additional information: This judgment is true, because if *throwsuzy* was substituted by the empty action, the plan *empty:throwbilly* would be performed instead, and then *shattered* would become true later (viz., due to the later action *throwbilly*).


#### Reasons

One can also ask about the reasons for an action. Here, we ask what's the reason for *throwsuzy*:
```
./causality ./examples/suzybilly1.pl throwsuzy:throwbilly throwsuzy reason_temporal_empty
```

The answer is <code>[(shattered,empty:throwbilly)]</code>. This means that the reason for *throwsuzy* is to make the bottle shatter. Conversely, asking for the reason for *throwbilly* ...
```
./causality ./examples/suzybilly1.pl throwsuzy:throwbilly throwbilly reason_temporal_empty
```

... we get the empty set, viz., *throwbilly* was performed for no reason.

### Example: Stealing Cake

Suzy steals a cake. She eats the cake. The cake causes pain. 

#### Does Suzy have pain, because she *stole* the cake? - The answer is no.

```prolog
% File: ex_cake_con1.pl
effect(steal_cake, [], [have_cake]).
effect(buy_cake, [], [have_cake]).
effect(steal_banana, [], [have_banana]).
effect(eat, [have_cake], [pain]).

contrast(steal_cake, [buy_cake]).

init([not(have_cake), not(have_banana), not(pain)]).
```

```
./causality ./examples/ex_cake_con1.pl steal_cake:eat pain temporal_nonempty
```

<code>[]</code>


#### Does Suzy have pain, because she stole *the cake*? - The answer is yes. 

```prolog
% File: ex_cake_con2.pl
effect(steal_cake, [], [have_cake]).
effect(buy_cake, [], [have_cake]).
effect(steal_banana, [], [have_banana]).
effect(eat, [have_cake], [pain]).

contrast(steal_cake, [steal_banana]).

init([not(have_cake), not(have_banana), not(pain)]).
```

```
./causality ./examples/ex_cake_con2.pl steal_cake:eat pain temporal_nonempty
```

<code>[(steal_cake,steal_banana:eat)]</code>

### A more complex Example: Service Robot

```prolog
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
````


```
./causality ./examples/coffeeRobot.pl brew:brew:brew:leaveKitchen:enterDining:serve:serve:leaveDining:enterBalcony:serve enterDining reason_but_for
```
<code>[(coffMrSmith,brew:brew:brew:leaveKitchen:empty:serve:serve:leaveDining:enterBalcony:serve),(coffMrsSmith,brew:brew:brew:leaveKitchen:empty:serve:serve:leaveDining:enterBalcony:serve)]</code>

```
./causality ./examples/coffeeRobot.pl brew:brew:brew:leaveKitchen:enterDining:serve:serve:leaveDining:enterBalcony:serve enterBalcony reason_but_for
```

<code>[(coffMrsBrown,brew:brew:brew:leaveKitchen:enterDining:serve:serve:leaveDining:empty:serve)]</code>
