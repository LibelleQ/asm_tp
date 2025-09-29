section .bss
	buffer resb 64

section .data
	msg db '1337'
	msglen equ $-msg
section .text

	global _start

_start:
	mov rax, 0
	mov rdi, 0
	mov rsi, buffer
	mov rdx, 64
	syscall

	test rax, rax
	jle _exit_fail

	cmp rax, 2
	je _check2
	cmp rax, 3
	je _check3
	jmp _exit_fail

_check2:
	mov al,[buffer]
	mov al, '4'
	jne _exit_fail
	mov al, [buffer+1]
	mov al, '2'
	jne _exit_fail

_check3:
	mov al, [buffer]
	mov al, '4'
	jne _exit_fail
	mov al, [buffer+1]
	mov al, '2'
	jne _exit_fail
	cmp byte [buffer+2],10
	jne _exit_fail
	jmp sucess

sucess:
	mov rax, 0
	mov rdi, 0
	mov rsi, msg
	mov rdx, msglen
	syscall

	mov rax, 60
	mov rdi, rdi
	syscall

_exit_fail:
	mov rax, 60
	mov rdi, 1
	syscall

