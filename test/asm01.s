section .data
	msg db '1337', 0xa

section .text
	global _start

_start:
	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, 4

	syscall

	mov rax, 60
	mov rdi, 0
	syscall 
