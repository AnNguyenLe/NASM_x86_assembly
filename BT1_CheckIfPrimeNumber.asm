;Bài t?p 1. Vi?t chuong trình nh?p s? nguyên n. Ki?m tra n có là s? nguyên t? hay không ?

; Problem: Write a x86 NASM program take an integer N as an input then check if N were a prime number ?
; Pseudo-code
; isPrimeNumber = false;
; for (int i = 2; i <= N/2; i++){
; 	if(N % i && i != N (case N = 2)){
;		isPrimeNumber = true;
;		break;
;	}
; }
; return isPrimeNumber

%include "io.inc"
extern _getch

section .data
    tb1 db "Nhap n: ",0
    tb2 db "%d la so nguyen to / is a prime number",0
    tb3 db "%d KHONG la so nguyen to / is NOT a prime number",0
    fmt db "%d", 0
    
section .bss
    n resd 1
    nDiv2 resd 1

section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    
    ;Print tb1
    push tb1
    call _printf
    add esp,4
    
    ;Input n: scanf("%d", &n)
    push n
    push fmt
    call _scanf
    add esp,8
    
    
    ;Calculate nDiv2 = n / 2
    mov edx, 0
    mov eax, [n]
    mov ecx, 2
    
    ; In case of, n = 2, then Prime Number
    cmp [n], ecx
    je PRIME_NUMBER
    
    idiv ecx

    mov [nDiv2], eax

    ; Init i = 2
    mov esi, 2
    
LOOP:
    ;Calculate remainder = n % i
    mov edx, 0
    mov eax, [n]
    mov ecx, esi
    idiv ecx
    
    mov ecx, 0
    cmp edx, ecx
    je NOT_PRIME_NUMBER
    
    inc esi

    cmp esi, [nDiv2]
    jle LOOP
    jmp PRIME_NUMBER

NOT_PRIME_NUMBER:    ; Not a prime number: printf("%d KHONG la so nguyen to / is NOT a prime number", &n)
    push dword[n]
    push tb3
    call _printf
    add esp, 8
    jmp END_PROGRAM
    
PRIME_NUMBER:
    ; printf("%d la so nguyen to / is a prime number", &n)
    push dword[n]
    push tb2
    call _printf
    add esp, 8

END_PROGRAM:
    call _getch
    xor eax, eax
    ret