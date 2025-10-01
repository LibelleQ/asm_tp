section .bss
    buf resb 4096

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 2
    jne .err
    mov rdi, [rsp+16]

    mov rax, 2          ; open(argv[1], O_RDONLY)
    xor rsi, rsi
    xor rdx, rdx
    syscall
    mov r12, rax

.loop:
    mov rax, 0          ; read(fd, buf, 4096)
    mov rdi, r12
    mov rsi, buf
    mov rdx, 4096
    syscall
    test rax, rax
    jle .done
    mov r10, rax
    mov rax, 1          ; write(1, buf, n)
    mov rdi, 1
    mov rsi, buf
    mov rdx, r10
    syscall
    jmp .loop

.done:
    mov rax, 3          ; close(fd)
    mov rdi, r12
    syscall
    mov rax, 60         ; exit(0)
    xor rdi, rdi
    syscall

.err:
    mov rax, 60
    mov rdi, 1
    syscall
