# Project Title

Intermediate code generator receives input from its predecessor phase, semantic analyzer, in the form of an annotated syntax tree. That syntax tree then can be converted into a linear representation, e.g., postfix notation. Intermediate code tends to be machine independent code. Therefore, code generator assumes to have unlimited number of memory storage (register) to generate code.

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
