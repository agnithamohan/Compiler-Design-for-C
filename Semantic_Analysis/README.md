# Project Title

Semantics of a language provide meaning to its constructs, like tokens and syntax structure. Semantics help interpret symbols, their types, and their relations with each other. Semantic analysis judges whether the syntax structure constructed in the source program derives any meaning or not.

## Getting Started-Steps to compile and run
1. lex scanner.l
2. yacc parser.y
3. gcc lex.yy.c y.tab.c -lm -ll
4. ./a.out<test.c

## Prerequisites

To run this on your computer, you will need Lex and Yacc. 

## Installing

Steps to install Lex in Ubuntu:
sudo apt-get install byacc flex

Steps to install Yacc in Ubuntu:
sudo apt-get install bison

## Running the tests

Run tests by adding the test file's name in the last step of compiling and running. 
eg: ./a.out<test.c

## Authors

* **Agnitha Mohan** - *15co201*
* **Vasudha Boddukuri** - *15co211*

## Acknowledgments

We would like to thank the institute for giving us an opportunity to do this project. A special thanks to the course instructors Ms.Santhi Thilagam, Ms.Sushmita, Ms.Umapriya and the teaching assistants for their constant help and support. 
