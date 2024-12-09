https://clojure.org/guides/learn/syntax

#Numeric types
42        ; integer
-1.5      ; floating point
22/7      ; ratio

#Character types
"hello"         ; string
\e              ; character
#"[0-9]+"       ; regular expression

#Symbols and idents
map             ;# symbol
+               ;# symbol - most punctuation allowed
clojure.core/+  ;# namespaced symbol
nil             ;# null value
true false      ;# booleans
:alpha          ;# keyword
:release/alpha  ;# keyword with namespace

#Literal collections
#Clojure also includes literal syntax for four collection types:

'(1 2 3)     ;# list
[1 2 3]      ;# vector
#{1 2 3}     ;# set
{:a 1, :b 2} ;# map

'#Evaluation
#In Clojure, source code is read as characters by the Reader. The Reader may read the source either from .clj files or
# be given a series of expressions interactively. The Reader produces Clojure data. The Clojure compiler then produces the
# bytecode for the JVM.

#There are two important points here:
#The unit of source code is a Clojure expression, not a Clojure source file. Source files are read as a series of
# expressions, just as if you typed those expressions interactively at the REPL.
#Separating the Reader and the Compiler is a key separation that makes room for macros. Macros are
# special functions that take code (as data), and emit code (as data). Can you see where a loop for macro expansion
# could be inserted in the evaluation model?

Delaying evaluation with quoting
#Sometimes it’s useful to suspend evaluation, in particular for symbols and lists. Sometimes a symbol should just be a
# symbol without looking up what it refers to:

user=> 'x
x
'#And sometimes a list should just be a list of data values (not code to evaluate):

user=> '(1 2 3)
(1 2 3)
'#One confusing error you might see is the result of accidentally trying to evaluate a list of data as if it were code:
user=> (+ 3 4)
7
#The box above demonstrates evaluating an expression (+ 3 4) and receiving a result.

user=> (1 2 3)
Execution error (ClassCastException) at user/eval156 (REPL:1).
class java.lang.Long cannot be cast to class clojure.lang.IFn
#For now, don’t worry too much about quote but you will see it occasionally in these materials to
# avoid evaluation of symbols or lists.

REPL
#Most of the time when you are using Clojure, you will do so in an editor or a REPL (Read-Eval-Print-Loop).
# The REPL has the following parts:
Read an expression (a string of characters) to produce Clojure data.
Evaluate the data returned from #1 to yield a result (also Clojure data).
Print the result by converting it from data back to characters.
Loop back to the beginning.
#One important aspect of #2 is that Clojure always compiles the expression before executing it;
 Clojure is always compiled to JVM bytecode. There is no Clojure interpreter.

#there is a namespace clojure.repl that is included in the standard Clojure library that
# provides a number of helpful functions. To load that library and make its functions available in
# our current context, call:
(require '[clojure.repl :refer :all])
'#We now have access to some additional functions that are useful at the REPL: doc, find-doc, apropos, source, and dir.

Clojure basics
def
#When you are evaluating things at a REPL, it can be useful to save a piece of data for later. We can do this with def:
user=> (def x 7)
#'user/x

Printing
#One of the most common things you do when learning a language is to print out values. Clojure provides several
# functions for printing values:

#For humans
With newline
println
Without newline
print

#Readable as data
With newline
prn
Without newline
pr

#The human-readable forms will translate special print characters (like newlines and tabs) to their printed form and
# omit quotes in strings. We often use println to debug functions or print a value at the REPL. println takes any
#  number of arguments and interposes a space between each argument’s printed value:

user=> (println "What is this:" (+ 1 2))
What is this: 3
#The println function has side-effects (printing) and returns nil as a result.
#Note that "What is this:" above did not print the surrounding quotes and is not a string that the Reader could read again as data.
#For that purpose, use prn to print as data:

user=> (prn "one\n\ttwo")
"one\n\ttwo"
#Now the printed result is a valid form that the Reader could read again. Depending on context, you may prefer either
# the human form or the data form.

