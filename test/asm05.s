section .data
	nl db 10
section .text
	global _start

_start:
	mov rax, [rsp]

	cmp rax, 1
	je .no_args

	mov rsi, [rsp+16]
	mov rdi, rsi
	xor rcx, rcx

.len_loop:
	cmp byte [rdi+rcx], 0
	je .got_len
	inc rcx
	jmp .len_loop

.got_len:
	mov rdx, rcx

	mov rax, 1
	mov rdi, 1
	syscall

	mov rax, 1
	mov rdi, 1
	mov rsi, nl
	mov rdx, 1
	syscall

	mov rax, 60
	xor rdi, rdi
	syscall

.no_args:
	mov rax, 60
	mov rdi, 1
	syscall
