# causality

## Installation

Make sure SWI Prolog is installed on your machine. SWI Prolog is available in common Linux package repositories, and Mac users can easily install it via brew. Start a terminal and write _swipl_. If the command successfully starts the Prolog shell, everything is fine. 

Then clone or download this github repository. Make sure the file _causality_ is executable, viz., run _chmod +x causality_. That's it.

## Using the program

### Example: Suzy and Billy

#### Causes

*Suzy throws a rock at the bottle. Billy throws his rock only if Suzy's does not hit. Suzy hits the bottle. The bottle shatters.* The narrative can be represented by the program <code>throwsuzy:throwbilly</code> under the domain description shown below:

```prolog
init([not(shattered)]).
goal([shattered]).

effect(throwsuzy, [not(shattered)], [shattered]).
effect(throwbilly, [not(shattered)], [shattered]).
```

This domain description is written in the file *./examples/suzybilly.pl*. The causal reasoner can be queried to answer what  caused *shattered*, or why *throwsuzy* was performed to begin with.

First, ask what caused the shattering under the but-for definition of causality:
```
./causality ./examples/suzybilly1.pl throwsuzy:throwbilly shattered but_for
```

The answer is the empty set: Leaving out *throwsuzy* would still result in *shattered* due to *throwbilly*; and also leaving out *throwbilly* would not prevent *shattered*. Thus, none of the actions is a but-for cause. However, if Suzy hadn't thrown, then *shattered* would have happened later. Therefore, *throwsuzy* is a cause according to the temporal-fragility definition of causality called *temporal_empty* (why it is called *empty* will be explained later):
```
  ./causality ./examples/suzybilly1.pl throwsuzy:throwbilly shattered temporal_empty
```

The output is a singleton list of pairs of actions and justifications <code>[(throwsuzy,empty:throwbilly)]</code>. Particularly, this tells us that *throwsuzy* is a cause. And it gives additional information: This judgment is true, because if *throwsuzy* were substituted by the empty action, the plan *empty:throwbilly* would be performed instead, and then *shattered* would become true later (viz., due to the later action *throwbilly*).


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

