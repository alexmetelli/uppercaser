# uppercaser
Assembly program to convert a lower case text file into uppercase
; Executable name	: uppercaser
; Created date		: 25/02/2020
; Author 		: Alex Metelli (Freely taken from Jeff Duntemann book: "Assembly language step ;			  by step
; Description		: A program that reads  an input file to a buffer in blocks, forcing lower case
;			  characters into uppercase, and writes the modified buffer into an output file
;
; Runthis way:
;	./uppercaser > (output file) < (input file)
;
; Works on Linux and AMD64 
;
; Build with:
;	nasm -f elf64 -g -F dwarf uppercaser.asm
;	ld -g -o uppercaser uppercaser.o
