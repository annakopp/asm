;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .data          ; Already initialized data
  insertmesg     db  'Insert a number: '
  outputmesg     db  'You have choosed: '
  vowels         db  'aeiou'
  timeval:
    tv_sec       dq 0
    tv_usec      dq 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .bss           ; Data to be initialized
  myvariable  resb  140  ; reserve 4 bytes to put the pressed
                       ; key. "myvariable" is a label
                       ; representing memory location
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
section .text
  global start        ; for the linker

start:             
  ; STEP 1: writing the message
  mov  rax, 0x02000004           ; sys_write
  mov  rdi, 1           ; file descriptor: stdout
  mov  rsi, insertmesg  ; message to be print
  mov  rdx, 17          ; message length
  syscall              ; perform system call 
                        ; (same as int 0x80)

  ; STEP 2: read from keyboard
  mov  rax, 0x02000003            ; sys_read
  mov  rdi, 2            ; file descriptor: stdin
  mov  rsi, myvariable   ; destination (memory address)
  mov  rdx, 140            ; size of the the memory location
                         ; in bytes
  syscall               ; perform system call


  xor r11,r11   ; r11-register is the counter, set to 0
loop1:

    mov  rbx, r11 ; set rbx to cx 
    mov  r10, myvariable 
    add  rbx, r10 ; add rbx and myvariable and save to rbx
    mov  rsi, rbx ; char of myvariable to print

    cmp byte [rsi], 'a' ; check if char is vowel a
    je random_letter
    cmp byte [rsi], 'e' ; check if char is vowel e
    je random_letter
    cmp byte [rsi], 'i' ; check if char is vowel i
    je random_letter
    cmp byte [rsi], 'o' ; check if char is vowel o
    je random_letter
    cmp byte [rsi], 'u' ; check if char is vowel u
    je random_letter
    jmp print_char
  
random_letter:
    ;mov r12, rsi ; hold the address to the current char in r12
    mov         rax, 0x2000074
    mov         rdi, timeval
    mov         rsi, 0          
    syscall
    mov         rax, [rel tv_usec]
    mov  rcx, 5 ; divide by 5
    div rcx    ; rax/rcx => remainder in rdx (dl)
    mov r12, vowels
    add r12, rdx
    mov rsi, r12

print_char:
    mov  rax, 0x02000004 ; sys_write
    mov  rdi, 1 ; stdout
    mov  rdx, 1 ; length of printed result
    syscall
    inc r11      ; Increment
    cmp r11,140    ; Compare cx to the limit
    jle loop1


  ; STEP 4: exit with error status 0
  mov  rax, 0x02000001
  mov  rdi, 0
  syscall