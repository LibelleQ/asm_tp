section.bss

section.data

section.text
	global _start
_start:
	mov rbx, [rsp]


.no_args:
	mov rax, 60
	mov rdi, 1
	syscall
