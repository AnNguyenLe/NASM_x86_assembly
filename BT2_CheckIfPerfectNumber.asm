; Bài t?p 2. Vi?t chuong trình nh?p s? nguyên n. Ki?m tra n có là s? nguyên hoàn thi?n hay không ?
; Problem: Write a x86 NASM program take an integer N as an input then check if N were a perfect number ?
; Pseudo-code
; isPerfectNumber = false;
; sum = 0;
; for (int = 1; i <= N/2; i++){
; 	if(N % i){
;		sum = sum + i;
;	}
; }
; return sum === N

%include "io.inc"
extern _getch

section .data
    tb1 db "Nhap n: ",0
    tb2 db "%d la so hoan thien / is a perfect number",0
    tb3 db "%d KHONG la so hoan thien / is NOT a perfect number",0
    fmt db "%d", 0
    
section .bss
    n resd 1
    nDiv2 resd 1
    sum resd 1

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
    
    idiv ecx

    mov [nDiv2], eax

    ; Init sum = 0
    ; Init i = 1
    mov esi, 1
    
LOOP:
    ;Calculate remainder = n % i
    mov edx, 0
    mov eax, [n]
    mov ecx, esi
    idiv ecx
    
    mov ecx, 0
    cmp edx, ecx
    jne SKIP_ADD_TO_SUM
    add [sum], esi
    
SKIP_ADD_TO_SUM:
    
    inc esi

    cmp esi, [nDiv2]
    jle LOOP
    
    mov eax, [sum]
    cmp eax, [n]
    je PERFECT_NUMBER

; Not a perfect number: printf("%d KHONG la hoan thien / is NOT a perfect number", &n)
    push dword[n]
    push tb3
    call _printf
    add esp, 8
    jmp END_PROGRAM
    
PERFECT_NUMBER:
    ; printf("%d la so hoan thien / is a perfect number", &n)
    push dword[n]
    push tb2
    call _printf
    add esp, 8

END_PROGRAM:
    call _getch
    xor eax, eax
    ret