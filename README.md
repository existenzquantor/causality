# causality

## Installation

Make sure SWI Prolog is installed on your machine. SWI Prolog is available in common Linux package repositories, and Mac users can easily install it via brew. Start a terminal and write _swipl_. If the command successfully starts the Prolog shell, everything is fine. 

Then clone or download this github repository. Make sure the file _causality_ is executable, viz., run _chmod +x causality_. That's it.

## Using the program

To query if, given some domain description *D*, action *A* in program *P* is a cause of *F* according to causality definition *C*, you call:
<code>
./causality "*D*" "*P*" "*A*" "*F*" "*C*"
</code>

Example call: 
<code>
./causality "./examples/ex_butfor.pl" "a:a" "a" "not(p)" "but_for"
</code>

More explanation soon to come.
