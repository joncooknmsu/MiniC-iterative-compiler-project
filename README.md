# MiniC-iterative-compiler-project

An iterative approach to a course compiler project, using a small
subset of the C programming language as the input language.

The main branch contains assignments, documentation, and a small
example of using _lex_ and _yacc_. The example is structured so that
it is analogous to a syntax-directed translator, which is the method
used in the first three iterations.

Other branches capture the iterative solutions, with each iteration 
having its own branch, and a set of branches for each output language.
The current output languages are X86-64 and RISC-V assembly code.

## Iteration 1

Iteration 1 is simple and is intended to be able to compile a
Hello World program; its grammar can take multiple statements and
so it can compile programs with multiple print calls.


