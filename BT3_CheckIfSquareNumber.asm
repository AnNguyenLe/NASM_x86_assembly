; Bài t?p 3. Vi?t chuong trình nh?p vào s? nguyên n. Ki?m tra n có là s? chính phuong hay không ?
; Problem: Write a x86 NASM program take an integer N as an input then check if N were a square number ?
; isSquareNumber = false;
; for (int i = 1; i < N; i++){
;	const squareNumber  = i * i;
;	if (squareNumber > N){
;		break;
;	}
;	if (squareNumber === N){
;		isSquareNumber = true
;		break;
;	} 
; }
; return isSquareNumber;

%include "io.inc"
extern _getch

section .data
    tb1 db "Nhap n: ",0
    tb2 db "%d la so chinh phuong / is a square number",0
    tb3 db "%d KHONG la so chinh phuong / is NOT a square number",0
    fmt db "%d", 0
    
section .bss
    n resd 1
    squaredNum resd 1

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

    ; Init i = 1
    mov esi, 1
    
LOOP:
    ;Calculate squaredNum = i * i
    mov edx, 0
    mov eax, esi
    mov ecx, esi
    imul ecx
    
    cmp eax, [n]
    jg NOT_SQUARE_NUMBER
    
    je SQUARE_NUMBER

    inc esi

    cmp esi, [n]
    jle LOOP

NOT_SQUARE_NUMBER:
; Not a square number: printf("%d KHONG la chinh phuong / is NOT a square number", &n)
    push dword[n]
    push tb3
    call _printf
    add esp, 8
    jmp END_PROGRAM
    
SQUARE_NUMBER:
    ; printf("%d la so chinh phuong / is a square number", &n)
    push dword[n]
    push tb2
    call _printf
    add esp, 8

END_PROGRAM:
    call _getch
    xor eax, eax
    ret