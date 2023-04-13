;Bài t?p 5. vi?t chuong trình th?c hi?n các ch?c nang sau:
;1. Nh?p m?ng 1 chi?u n ph?n t? s? nguyên
;2. Xu?t m?ng
;3. Li?t kê các s? nguyên t?
;4. Tìm giá tr? l?n nh?t trong m?ng
;5. Tính trung bình m?ng

%include "io.inc"
extern _getch

section .data
    tb1 db "Nhap kich thuoc cua mang / Size of the array: ", 0
    tb2 db "A[%d]: ", 0
    tb3 db "Cac phan tu cua mang / Elements of the array:", 0
    fmt1 db "%d", 0
    fmt2 db " %d", 0
    tb4 db 10,"Cac so nguyen to co trong mang / Prime numbers: ", 0
    tb5 db 10,"Gia tri lon nhat trong mang / Max value: ", 0
    tb6 db 10,"Trung binh mang / Average: "

section .bss
    arr resd 100 ; reserved for 100 elements, each will occupies 1 d ( as defined in resD)
    n resd 1
    elDiv2 resd 1
    temp resd 1
    counter resd 1
    
section .text
global CMAIN
CMAIN:
    mov ebp, esp; for correct debugging
    ;write your code here
    
    ; print tb1
    push tb1
    call _printf
    add esp,4
    
    ; input the size of the array (n): _scanf("%d", &n)
    push n
    push fmt1
    call _scanf
    add esp,8
    
    ; load address of the array into ebx 
    mov ebx, arr
    
    ; Init i = 0
    mov esi, 0
    
InputLoop:
    ; printf tb2: printf("A[%d]: ", &i)
    push esi
    push tb2
    call _printf
    add esp,8
    
    ; input A[i]
    push ebx
    push fmt1
    call _scanf
    add esp,8
    
    ; Move to the address of the next element
    add ebx, 4
    
    ; Increase index
    inc esi
    
    ; Check if i < n then LoopInput
    cmp esi, [n]
    jl InputLoop
    
    add ebx,4
    
    inc esi
    
    cmp esi, [n]
    jl PrintPrimeElements.Loop
    
    
    ; ========= Print Array's Elements ========
    
    push tb3
    call _printf
    add esp,4
    
    mov ebx, arr
    mov esi, 0
    
 PrintArrayElements.Loop:
    ; print(" %d", &arr[i])
    push dword[ebx]
    push fmt2
    call _printf
    add esp,8
    
    add ebx,4
    
    inc esi
    
    cmp esi, [n]
    jl PrintArrayElements.Loop
    
    
    ; ========= List out Element(s) that is/are prime number ========
    
    push tb4
    call _printf
    add esp,4
    
    mov ebx, arr
    mov esi, 0
    
    
 PrintPrimeElements.Loop:
    mov [counter], esi
    
    ; passing param into stack as a mean of calling function CheckPrimeNumber(a).
    push dword[ebx]
    call _CheckPrimeNumber
    add esp,8
    
    ; eax holds the resullt of function CheckPrimeNumber(a)
    
    
    add ebx,4
    
    mov esi, [counter]
    inc esi
    
    cmp esi, [n]
    jl PrintPrimeElements.Loop
    
    
    ; ========= Max value of the array ========
    
    
    
    mov ebx, arr
    mov esi, 0
    
    mov eax, dword[ebx]
    mov [temp], eax
    
 FindMax.Loop:
    
    mov edx, dword[ebx]
    
    cmp edx, [temp]
    
    jle SKIP_ASSIGN_NEW_MAX
    mov [temp], edx
    
    SKIP_ASSIGN_NEW_MAX:
    add ebx,4
    
    inc esi
    
    cmp esi, [n]
    jl FindMax.Loop
    
    push tb5
    call _printf
    add esp,4
    
    push dword[temp]
    push fmt2
    call _printf
    add esp,8
    
    
    
    ; ========= Average value of the array ========
    
    
    
    mov ebx, arr
    mov esi, 0
    
    mov eax, 0
    mov [temp], eax
    
 Sum.Loop:
    
    mov edx, dword[ebx]
    
    add [temp], edx
    
    add ebx,4
    
    inc esi
    
    cmp esi, [n]
    jl Sum.Loop
    
    push tb6
    call _printf
    add esp,4
    
    mov edx, 0
    mov eax, [temp]
    mov ecx, [n]
    
    div ecx
    
    push eax
    push fmt2
    call _printf
    add esp,8
   
    
    call _getch
    
    xor eax, eax
    ret
    
    
    
    
global _CheckPrimeNumber
_CheckPrimeNumber:
; backup ebp, where ebp is the base address of function main
    push ebp;
    mov ebp, esp ; replace ebp by the new address of the current stack
    ; Init stack
    sub esp, 64
    
    ; Address of params
    ; a = [ebp+8]
    
; Body of subroutine
    mov eax, [ebp+8] ; param a
    mov [temp], eax

    ;Calculate elDiv2 = arr[i] / 2
    mov edx, 0
    mov ecx, 2
    
    ; In case of, arr[i] = 2, then Prime Number
    cmp [temp], ecx
    je PRIME_NUMBER
    
    idiv ecx

    mov [elDiv2], eax

    ; Init i = 2
    mov esi, 2
    
CheckPrimeNumber.Loop:
    ;Calculate remainder = n % i
    mov edx, 0
    mov eax, dword[temp]
    mov ecx, esi
    idiv ecx
    
    mov ecx, 0
    cmp edx, ecx
    je NOT_PRIME_NUMBER
    
    inc esi

    cmp esi, [elDiv2]
    jle CheckPrimeNumber.Loop
    jmp PRIME_NUMBER

NOT_PRIME_NUMBER:
    jmp EndCheckPrimeNumber
    
PRIME_NUMBER:
    push dword[temp]
    push fmt2
    call _printf
    add esp, 8

EndCheckPrimeNumber:
    xor eax, eax
; End of subroutine
    ; Delete stack
    add esp,64
    ; reverse backup
    mov esp, ebp
    pop ebp
    ret   
    
    