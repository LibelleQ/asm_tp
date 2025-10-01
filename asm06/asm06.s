global _start

section .text
_start:
    mov rax, [rsp]
    cmp rax, 3
    jne .error

    mov rsi, [rsp+16]
    call atoi
    mov rbx, rax

    mov rsi, [rsp+24]
    call atoi
    add rax, rbx

    mov rsi, buf+20
    mov rcx, 0
.convert_loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    inc rcx
    test rax, rax
    jnz .convert_loop

    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

.error:
    mov rax, 60
    mov rdi, 1
    syscall

atoi:
    xor rax, rax
.next_char:
    mov dl, [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    cmp dl, 9
    ja .done
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .next_char
.done:
    ret

section .data
nl db 10

section .bss
buf resb 32
