; Bài t?p 4. Vi?t chuong trình nh?p s? nguyên n. Ki?m tra n có là s? d?i xung hay không ?
; Problem: Write a x86 NASM program take an integer N as an input then check if N were a Palindromic / symmetrical number ?
; Cach tach 1 so thanh cac so hop thanh con so do / How to separate a number into numbers that combine into that number:
; div 2453, 10 -> quotient 245 + remainder 3 => Luu / Store remainder to array[0] -> vi tri / location n - 4  =  0
; div 245, 10 -> quotient 24 + remainder 5 => Luu / Store remainder to array[1] -> vi tri / location n - 3    =  1
; div 24, 10 -> quotient 2 + remainder 4 => Luu / Store remainder to array[2] -> vi tri / location n - 2      =  2
; div 2, 10 -> quotient 0 + remainder 2 => Luu / Store remainder to array[3] -> vi tri / location n - 1       =  3
; if (quotient == 0) -> stop looping
; So length of the array is: (address location n - based address of array) / 4 --> as 4 bytes is a word
; Calculate the value of n/2 for looping and compare array[i] and array[n - i - 1] --> If all of them matched then the Palindromic number
;
; Pseudo-code:
; (User input an integer N)
;
; isPalindromicNumber = true;
; ; if (N < 0) 
; {
; 	isPalindromicNumber = false;
; 	goto Exit
; }
; if (N >= 0 && N < 10) 
; {
; 	goto Exit
; }
; int[] numArray;
; int counter = 0
; int temp = N
; do {
; 	[hi (remainder), lo (quotient)] = temp div 10
;	numArray[counter] = hi;
;	++counter
;	temp = quotient
; } while(quotient != 0)
; int numArrayLength = counter + 1;
; [hi (remainder), lo (quotient)] = numArrayLength div 2
; for(int i = 0; i <= quotient; i++)
; {
; 	if (numArray[i] != numArray[counter - i])
; 	{
;		isPalindromicNumber = false;
; 		goto Exit
;	}
; }
; Exit: return isPalindromicNumber

%include "io.inc"
extern _getch

section .data
    tb1 db "Nhap n: ",0
    tb2 db "%d la so doi xung / is a palindromic number",0
    tb3 db "%d KHONG la so doi xung / is NOT a palindromic number",0
    fmt db "%d", 0
    
section .bss
    n resd 1
    numArray resd 1
    temp resd 1
    numberTen resd 1
    zero resd 1
    numberTwo resd 1
    counter resd 1
    numArrayLength resd 1
    lastElementAddress resd 1
    numArrayLengthDiv2 resd 1
    a resd 1
    b resd 1

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
    
    mov edx, 0
    cmp [n], edx
    jl NOT_PALINDROMIC_NUMBER
    
    mov edx, 10
    cmp [n], edx
    jl PALINDROMIC_NUMBER
    
    
    ; load address of the array into ebx 
    mov ebx, numArray
    
    ; Init counter = 0
    mov edx, 0
    mov [counter], edx
    
    ; Init temp = N
    mov edx, [n]
    mov [temp], edx
    
    ; Assign numberTen = 10
    mov edx, 10
    mov [numberTen], edx
    
    ; Assign zero = 0
    mov edx, 0
    mov [zero], edx
    
    
BREAKDOWN_ELEMENTS_LOOP:
    mov edx, 0
    mov eax, [temp]
    mov ecx, [numberTen]
    idiv ecx
    
    mov [temp], eax
    ; numArr[i] = remainder
    mov ebx, edx
    
    
    ; Move to the address of the next element
    add ebx, 4
    
    ; Increase counter
    mov edx,[counter]
    inc edx
    mov [counter],edx
    
    mov eax, [temp]
    
    cmp eax, [zero]
    jne BREAKDOWN_ELEMENTS_LOOP
    
    ; counter is array's length
    
    ; load address of the array into ebx 
    mov ebx, numArray
    
    ; lastElementAddress
    mov eax,[counter]
    mov ecx,4
    imul ecx

    add eax,ebx
    mov [lastElementAddress], eax
    
    ; Number of time for the next loop: numArrayLength / 2
    mov edx, 0
    mov eax, [counter]
    mov ecx, 2
    idiv ecx
    
    mov [numArrayLengthDiv2], eax
    
    ; Init i = 0
    mov esi, 0
    
    
LOOP:

    


    ;numArray[i] != numArray[counter - i]
    ; Calculate the difference of position. Store the difference into temp
    mov edx, 0
    mov eax, esi
    mov ecx, 4
    imul ecx
    
    mov [temp], eax
    
    
    ; numArray[i] = numArray [ based address + difference ] store into a
    add eax, ebx
    
    
    
    ; eax holds the address of numArray[i]
    
    
    ; numArray[n - i - 1] = numArray [  lastElementAddress - difference - 1 ] and store in edx
    mov ecx, [temp]
    dec ecx
    mov edx, [lastElementAddress]
    
    
    sub edx, ecx
    
    
    
    ;edx holds the address of numArray[n - i - 1]
    
    mov eax, [eax]
    mov edx, [edx]
    
    cmp eax, edx
    jne NOT_PALINDROMIC_NUMBER
    
    inc esi

    cmp esi, [numArrayLengthDiv2]
    jle LOOP
    jmp PALINDROMIC_NUMBER

NOT_PALINDROMIC_NUMBER:
; Not a square number: printf("%d KHONG la doi xung / is NOT a PALINDROMIC number", &n)
    push dword[n]
    push tb3
    call _printf
    add esp, 8
    jmp END_PROGRAM
    
PALINDROMIC_NUMBER:
    ; printf("%d la so doi xung / is a PALINDROMIC number", &n)
    push dword[n]
    push tb2
    call _printf
    add esp, 8

END_PROGRAM:
    call _getch
    xor eax, eax
    ret