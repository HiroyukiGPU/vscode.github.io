; Assembly Example - 基本的な算術演算と文字列操作
; x86-64 Linux システムコール用

section .data
  ; 文字列定数
  msg_hello db '=== Assembly Program ===', 0xA, 0
  msg_hello_len equ $ - msg_hello
  
  msg_add db 'Addition: ', 0
  msg_add_len equ $ - msg_add
  
  msg_sub db 'Subtraction: ', 0
  msg_sub_len equ $ - msg_sub
  
  msg_mul db 'Multiplication: ', 0
  msg_mul_len equ $ - msg_mul
  
  msg_result db ' = ', 0
  msg_result_len equ $ - msg_result
  
  msg_newline db 0xA, 0
  msg_newline_len equ $ - msg_newline
  
  msg_done db 'Program completed.', 0xA, 0
  msg_done_len equ $ - msg_done
  
  ; 数値データ
  num1 dq 42        ; 64ビット整数
  num2 dq 15        ; 64ビット整数
  result dq 0       ; 結果格納用

section .bss
  ; 未初期化データ領域
  buffer resb 32    ; 数値→文字列変換用バッファ

section .text
  global _start

_start:
  ; プログラム開始メッセージを表示
  mov rax, 1              ; sys_write
  mov rdi, 1              ; stdout
  mov rsi, msg_hello      ; メッセージのアドレス
  mov rdx, msg_hello_len  ; メッセージの長さ
  syscall
  
  ; 加算処理
  call do_addition
  
  ; 減算処理
  call do_subtraction
  
  ; 乗算処理
  call do_multiplication
  
  ; プログラム終了メッセージ
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_done
  mov rdx, msg_done_len
  syscall
  
  ; プログラム終了
  mov rax, 60           ; sys_exit
  xor rdi, rdi          ; 戻り値 0
  syscall

; 加算処理
do_addition:
  push rbp
  mov rbp, rsp
  
  ; "Addition: " を表示
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_add
  mov rdx, msg_add_len
  syscall
  
  ; 加算: num1 + num2
  mov rax, [num1]
  add rax, [num2]
  mov [result], rax
  
  ; 結果を表示
  mov rax, [num1]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, plus_sign
  mov rdx, 3
  syscall
  
  mov rax, [num2]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_result
  mov rdx, msg_result_len
  syscall
  
  mov rax, [result]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_newline
  mov rdx, msg_newline_len
  syscall
  
  pop rbp
  ret

; 減算処理
do_subtraction:
  push rbp
  mov rbp, rsp
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_sub
  mov rdx, msg_sub_len
  syscall
  
  ; 減算: num1 - num2
  mov rax, [num1]
  sub rax, [num2]
  mov [result], rax
  
  ; 結果を表示
  mov rax, [num1]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, minus_sign
  mov rdx, 3
  syscall
  
  mov rax, [num2]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_result
  mov rdx, msg_result_len
  syscall
  
  mov rax, [result]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_newline
  mov rdx, msg_newline_len
  syscall
  
  pop rbp
  ret

; 乗算処理
do_multiplication:
  push rbp
  mov rbp, rsp
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_mul
  mov rdx, msg_mul_len
  syscall
  
  ; 乗算: num1 * num2
  mov rax, [num1]
  imul rax, [num2]
  mov [result], rax
  
  ; 結果を表示
  mov rax, [num1]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, mul_sign
  mov rdx, 3
  syscall
  
  mov rax, [num2]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_result
  mov rdx, msg_result_len
  syscall
  
  mov rax, [result]
  call print_number
  
  mov rax, 1
  mov rdi, 1
  mov rsi, msg_newline
  mov rdx, msg_newline_len
  syscall
  
  pop rbp
  ret

; 数値を文字列に変換して表示
print_number:
  push rbp
  mov rbp, rsp
  push rbx
  push rcx
  push rdx
  
  mov rbx, 10           ; 基数10
  mov rcx, 0            ; カウンタ
  mov rsi, buffer + 31  ; バッファの最後尾
  mov byte [rsi], 0     ; NULL終端
  
.convert_loop:
  xor rdx, rdx          ; rdxをクリア
  div rbx               ; rax / 10, 商→rax, 余り→rdx
  add dl, '0'           ; 数字を文字に変換
  dec rsi               ; バッファのポインタを戻す
  mov [rsi], dl         ; 文字を格納
  inc rcx               ; カウンタ増加
  test rax, rax         ; raxが0か確認
  jnz .convert_loop     ; 0でなければ継続
  
  ; 文字列を表示
  mov rax, 1            ; sys_write
  mov rdi, 1            ; stdout
  mov rdx, rcx          ; 文字列の長さ
  syscall
  
  pop rdx
  pop rcx
  pop rbx
  pop rbp
  ret

section .data
  plus_sign db ' + ', 0
  minus_sign db ' - ', 0
  mul_sign db ' * ', 0

; コメント:
; このプログラムは基本的な算術演算を実行します
; - レジスタ操作
; - システムコール
; - 数値から文字列への変換
; - スタック操作
;
; アセンブリ言語の特徴:
; - 低レベルなハードウェア制御
; - 高速な実行
; - メモリ管理の完全なコントロール
; - CPUレジスタの直接操作
;
; 主なレジスタ:
; rax - 汎用レジスタ、システムコール番号、戻り値
; rbx - 汎用レジスタ
; rcx - カウンタ
; rdx - データレジスタ
; rsi - ソースインデックス
; rdi - ディスティネーションインデックス
; rbp - ベースポインタ
; rsp - スタックポインタ

