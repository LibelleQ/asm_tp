section .data
    msg_even    db "0", 10
    msg_even_len equ $ - msg_even
    msg_odd     db "1", 10
    msg_odd_len  equ $ - msg_odd

section .bss
    buffer      resb 256

section .text
    global _start

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buffer
    mov     rdx, 256
    syscall
    cmp     rax, 1
    jl      exit_fail1

    mov     rcx, 0
    mov     rbx, rax
    xor     r8, r8
    mov     r9, 0

skip_ws:
    cmp     rcx, rbx
    jge     check_digit
    mov     al, [rsi+rcx]
    cmp     al, ' '
    je      inc_rcx
    cmp     al, 9
    je      inc_rcx
    cmp     al, 10
    je      inc_rcx
    jmp     check_sign

inc_rcx:
    inc     rcx
    jmp     skip_ws

check_sign:
    cmp     al, '+'
    je      after_sign
    cmp     al, '-'
    je      after_sign
    jmp     check_digit

after_sign:
    inc     rcx
    jmp     check_digit

check_digit:
    cmp     rcx, rbx
    jge     no_digit
    mov     al, [rsi+rcx]
    cmp     al, '0'
    jb      exit_fail2
    cmp     al, '9'
    ja      exit_fail2
    mov     r9b, al
    inc     r8
    inc     rcx
    jmp     consume_digits

consume_digits:
    cmp     rcx, rbx
    jge     after_number
    mov     al, [rsi+rcx]
    cmp     al, '0'
    jb      check_trailing
    cmp     al, '9'
    ja      check_trailing
    mov     r9b, al
    inc     rcx
    jmp     consume_digits

check_trailing:
    cmp     al, 10
    je      after_number
    cmp     al, ' '
    je      after_number
    cmp     al, 9
    je      after_number
    jmp     exit_fail2

after_number:
    inc     rcx
    cmp     rcx, rbx
    jge     have_digit
    mov     al, [rsi+rcx]
    cmp     al, 10
    je      after_number
    cmp     al, ' '
    je      after_number
    cmp     al, 9
    je      after_number
    jmp     exit_fail2

have_digit:
    cmp     r8, 0
    je      exit_fail1
    sub     r9b, '0'
    and     r9b, 1
    jnz     print_odd

print_even:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg_even
    mov     rdx, msg_even_len
    syscall
    jmp     exit_ok

print_odd:
    mov     rax, 1
    mov     rdi, 1
    mov     rsi, msg_odd
    mov     rdx, msg_odd_len
    syscall
    jmp     exit_ok

no_digit:
    jmp     exit_fail1

exit_fail1:
    mov     rax, 60
    mov     rdi, 1
    syscall

exit_fail2:
    mov     rax, 60
    mov     rdi, 2
    syscall

exit_ok:
    mov     rax, 60
    xor     rdi, rdi
    syscall
