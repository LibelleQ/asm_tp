section .data
	msg db '1337'
	buffer times 3 db 0
section .text

	global _start

_start:

	mov rax, 0
	mov rdi, 0
	mov rsi, buffer
	mov rdx, 3
	syscall

	mov al, [buffer]
	cmp al, '4'
	jne _exit

	mov al, [buffer+1]
	cmp al, '2'
	jne _exit

	mov rax, 1
	mov rdi, 1
	mov rsi, msg
	mov rdx, 4
	syscall

_exit:
	mov rax, 60
	mov rdi, 1
	syscall

