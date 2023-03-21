section .data
    ; Define the block header
    timestamp   dd  0           ; 32-bit timestamp
    prev_block  dd  0           ; 32-bit reference to previous block
    validator   dd  0           ; 32-bit reference to the chosen validator
    signature   dd  0           ; 32-bit signature of the block
    
    ; Define the list of validators and their stakes
    validators  dd  0x12345678, 0xabcdef01, 0xdeadbeef
    stakes      dd  100, 200, 300
    
    ; Define the maximum number of validators and the threshold for a valid signature
    max_validators  equ  3
    threshold       equ  500
    
    ; Define a buffer to hold the block header and validator address
    header_buf  db  16 dup(0)

section .text
    global pos
    
    ; pos: Proof of Stake function that takes a block header and returns a valid signature
    pos:
        push    ebp
        mov     ebp, esp
        
        ; Copy the block header into the header buffer
        mov     esi, [ebp + 8]        ; Pointer to block header
        mov     edi, header_buf
        mov     ecx, 16
        rep     movsb
        
        ; Choose a validator based on stake
        xor     eax, eax
        xor     ebx, ebx
    choose_validator_loop:
        cmp     ebx, max_validators
        je      no_validators
        mov     edx, stakes[ebx * 4]
        cmp     edx, [ebp + 12]        ; Compare stake to threshold
        jge     validator_chosen
        add     eax, edx              ; Calculate total stake
        inc     ebx
        jmp     choose_validator_loop
    no_validators:
        ; No validators with sufficient stake, return 0
        xor     eax, eax
        jmp     done
    validator_chosen:
        ; Validator with sufficient stake chosen, sign the block
        mov     dword [header_buf + 12], validators[ebx * 4]
        mov     ecx, 16
        call    sha256                ; Compute the hash of the block header and validator address
        mov     dword [esi + 16], eax  ; Update the block signature
        mov     eax, dword [esi + 16]  ; Return the signature
    done:
        pop     ebp
        ret


//will switch 