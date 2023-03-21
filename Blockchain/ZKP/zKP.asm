section .data
    x dd 42
    n dq 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000023
    zero dq 0
    one dq 1

section .text
    global _start

_start:
    ; Initialize random number generator
    mov eax, 40h
    xor edx, edx
    mov esi, [time]
    mov [state+8], esi
    call srand

    ; Generate two random numbers r1 and r2
    call generate_random
    mov [r1], rax
    call generate_random
    mov [r2], rax

    ; Compute y1 and y2
    mov rax, [r1]
    mul rax
    mov [y1], rax
    mov rax, [r2]
    mul rax
    mov rbx, [x]
    mul rbx
    mov [y2], rdx

    ; Send y1 and y2 to the verifier
    mov rdi, format
    mov rsi, y1
    xor rax, rax
    call printf
    mov rdi, format
    mov rsi, y2
    xor rax, rax
    call printf

    ; Verifier generates a random bit b
    call rand
    and eax, 1
    mov [b], eax

    ; Send b to the prover
    mov rdi, format
    mov rsi, b
    xor rax, rax
    call printf

    ; Compute s
    mov rax, [r2]
    xor rcx, rcx
    mov cl, [b]
    shl rcx, 3
    mov rdx, [n]
    and rdx, [mask+rcx]
    mov rsi, rdx
    call powmod
    mov rbx, [r1]
    mul rbx
    mov [s], rax

    ; Send s to the verifier
    mov rdi, format
    mov rsi, s
    xor rax, rax
    call printf

    ; Verify the proof
    mov rax, [s]
    mul rax
    mov rsi, [n]
    call powmod
    mov [lhs], rax
    mov rax, [r1]
    mov rbx, [r2]
    mul rax
    mov rcx, [b]
    mov rdx, [n]
    xor rsi, rsi
    mov al, byte [b]
    and rsi, [mask+rsi*8]
    mov rsi, [y2+rsi]
    mul rbx
    mov rdx, [n]
    mov rbx, rax
    xor rax, rax
    mov rdi, lhs
    mov rsi, rbx
    mov rdx, [n]
    call cmp

    ; Exit the program
    mov eax, 1
    xor ebx, ebx
    int 80h

generate_random:
    ; Generate a random number between 0 and n-1
    push rbp
    mov rbp, rsp
    sub rsp, 8
    mov rdi, n
    call mpz_sizeinbase
    shr rax, 3
    add rax, 1
    mov [size], rax
