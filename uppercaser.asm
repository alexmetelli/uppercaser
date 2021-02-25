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
;

SECTION	.bss

	BUFFLEN equ 1024		
	Buff 	resb BUFFLEN
	
SECTION .data

SECTION .text

global _start

_start:
	nop
	
; Read a text buffer from stdin:
Read:
	mov rax, 3		; sys_read call
	mov rbx, 0		; file descriptor stdin
	mov rcx, Buff		; pass offset of the buffer to read to
	mov rdx, BUFFLEN	; number of bytes to read in one pass
	int 80h			; call sys_read
	mov rsi, rax		; copy sys_read ret value for safe keeping
	cmp rax, 0		; if rax=0 sys_read reached EOF on stdin
	je Done			; jump if equal (to 0, from compare)
	
; Set up registers for the process buffer step:
	mov rcx, rsi		; place number of bytes read into rcx
	mov rbp, Buff		; Place address of buffer into rbp
	dec rbp			; Adjust count to offset to read next bytes
	
; Go through the buffer and convert lowercase to uppercase characters
Scan:
	cmp byte [rbp+rcx], 61h	; test input char against lowercase ''a'
	jb Next			; if below 'a' ASCII, not lowercase
	cmp byte [rbp+rcx], 7Ah ; test input char against lowercase 'z'
	ja Next			; if above 'z' ASCII, not lowercase
				; at this point we have a lowercase char
	sub byte [rbp+rcx], 20h	; substract 20h to give uppecase

Next:
	dec rcx			; decrement counter
	jnz Scan		; if characters remain loop back
	
	
; Write the buffer full of processed text to stdout
Write:
	mov rax, 4		; specify sys_write call
	mov rbx, 1		; stdout file descriptor
	mov rcx, Buff		; Pass the offset of the buffer
	mov rdx, rsi		; pass the # of bytes in rdx
	int 80h			; call sys_write
	jmp Read		; loop back and load another buffer full
	
; Exit the program
Done:
	mov rax, 1		; code for exit sys_call
	mov rbx, 0		; return 0 code
	int 80h			; sys_exit kernel call
	
