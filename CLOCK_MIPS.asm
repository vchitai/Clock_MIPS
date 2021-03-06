main:
.data
TIME: .space 100
TIME_1: .space 100
TIME_2: .space 100

INPUT_ERROR: .asciiz "Chuoi ngay thang nam tren khong hop le, moi ban nhap lai.\n"
TABLE: .asciiz "----------Ban hay chon 1 trong cac thao tac duoi day----------\n"

C1: .asciiz "1. Xuat chuoi TIME theo dinh dang DD/MM/YYYY.\n"
C2: .asciiz "2. Chuyen doi chuoi TIME thanh mot trong dinh dang sau:\n"
C2A: .asciiz "     A. MM/DD/YYYY.\n"
C2B: .asciiz "     B. Month DD, YYYY.\n"
C2C: .asciiz "     C. DD Month, YYYY.\n"
C3: .asciiz "3. Cho biet ngay vua nhap la ngay thu may.\n"
C4: .asciiz "4. Kiem tra nam trong chuoi TIME co phai la nam nhuan khong.\n"
C5: .asciiz "5. Cho biet khoang thoi gian giua 2 chuoi TIME_1 va TIME_2.\n"
C6: .asciiz "6. Cho biet hai nam nhuan gan nhat.\n"
C7: .asciiz "7. Kiem tra du lieu dau vao.\n"
C8: .asciiz "8. Nhap vao Ngay Thang Nam moi.\n"
C9: .asciiz "9. Thoat.\n"
C10: .asciiz "--------------------------------------------------------------\n"

LUA_CHON: .asciiz "Lua chon: "
KET_QUA: .asciiz "Ket qua: "
KIEU_DINH_DANG: .asciiz "Nhap kieu dinh dang: "

LA_NAM_NHUAN: .asciiz " la nam nhuan\n"
KO_LA_NAM_NHUAN: .asciiz " khong la nam nhuan\n"

INPUT_ERROR_5: .asciiz "1 trong 2 chuoi nhap vao sai cu phap\n"
HAI_NAM_NHUAN: .asciiz "Hai nam nhuan gan nhat la "
VA: .asciiz " va "
ENDL: .asciiz "\n"
HOP_LE: .asciiz " la chuoi ngay thang nam hop le"
NHAP_LAI: .asciiz "Moi ban nhap lai lua chon tu 1-9 trong bang lua chon\n"

.text

	la $s0, TIME
	la $s1, TIME_1
	la $s2, TIME_2

loop_main:
	
	loop_input:
		add $a0, $s0, $0
		jal input

		slt $t0, $v0, $0
		beq $t0 $0 end_loop_input
		
		li $v0, 4
		la $a0, INPUT_ERROR
		syscall
		j loop_input
		
	end_loop_input:

	li $v0, 4
	
	la $a0, TABLE
	syscall
	la $a0, C1
	syscall
	la $a0, C2
	syscall
	la $a0, C2A
	syscall
	la $a0, C2B
	syscall
	la $a0, C2C
	syscall
	la $a0, C3
	syscall
	la $a0, C4
	syscall
	la $a0, C5
	syscall
	la $a0, C6
	syscall
	la $a0, C7
	syscall
	la $a0, C8
	syscall
	la $a0, C9
	syscall
	la $a0, C10
	syscall

	add $t0, $0, $0
	add $t1, $0, $0
	add $t2, $0, $0
	add $t3, $0, $0
	add $t4, $0, $0

	loop_lua_chon:
		
		li $v0, 4
		la $a0, LUA_CHON
		syscall

		li $v0, 5
		syscall
		add $t0, $v0, $0

		bne $t0 1 not_id_1
		#id == 1		
		
		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		li $v0, 4
		la $a0, KET_QUA
		syscall

		add $a0, $s0, $0
		jal output

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		li $v0, 4
		la $a0, ENDL
		syscall

		j loop_lua_chon
	
		not_id_1:

		bne $t0 2 not_id_2
		#id == 2

		li $v0, 4
		la $a0, KIEU_DINH_DANG
		syscall

		li $v0, 12
		syscall
		#lb $t1, 0($v0)
		move $t1, $v0

		li $v0, 4
		la $a0, ENDL
		syscall

		li $v0, 4
		la $a0, KET_QUA
		syscall
	
		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		add $a0, $s0, $0
		add $a1, $t1, $0
		jal convert

		add $a0, $v0, $0
		jal output

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		li $v0, 4
		la $a0, ENDL
		syscall

		j loop_lua_chon
			
		not_id_2:
		
		bne $t0 3 not_id_3

		#id == 3
		li $v0, 4
		la $a0, KET_QUA
		syscall

		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		add $a0, $s0, $0
		jal weekDay

		move $a0, $v0
		li $v0, 4
		syscall

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		li $v0, 4
		la $a0, ENDL
		syscall

		j loop_lua_chon
	
		not_id_3:

		bne $t0 4 not_id_4
		
		#id == 4
		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		add $a0, $s0, $0
		jal year		

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		add $t2, $v0, $0

		li $v0, 4
		la $a0, KET_QUA
		syscall

		li $v0, 1
		
		#lw $a0, 0($t2)
		move $a0, $t2
		syscall

		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		jal leapYearY

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		beq $v0, $0, not_leap_year
		li $v0, 4
		la $a0, LA_NAM_NHUAN		
		syscall			
		j end_if_not_leap_year

		not_leap_year:
		li $v0, 4
		la $a0, KO_LA_NAM_NHUAN		
		syscall

		end_if_not_leap_year:

		j loop_lua_chon
	
		not_id_4:

		bne $t0, 5, not_id_5

		#id == 5

		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		add $a0, $s1, $0
		jal input

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		add $t3, $v0, $0

		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		add $a0, $s2, $0
		jal input

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		add $t4, $v0, $0

		slt $t5, $t3, $0
		slt $t6, $t4, $0

		bne $t5, 0, print_input_error
		bne $t6, 0, print_input_error
	
		li $v0, 4
		la $a0, KET_QUA
		syscall

		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		add $a0, $s1, $0
		add $a1, $s2, $0
		jal getTime

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		add $t5, $v0, $0

		slt $t6, $t5, $0
		bne $t6, $0, get_abs
		j not_get_abs
		get_abs:
		sub $t5, $0, $t5
		not_get_abs:

		li $v0, 1
		#lw $a0, 0($t5)
		move $a0, $t5
		syscall								

		j no_input_error
		print_input_error:
			li $v0, 4
			la $a0, INPUT_ERROR_5
			syscall

		no_input_error:

		li $v0, 4
		la $a0, ENDL
		syscall

		j loop_lua_chon	
		
		not_id_5:

		bne $t0, 6, not_id_6

		#id == 6
		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		add $a0, $s0, $0
		jal findTwoLeapYear

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		add $t5, $v0, $0
		add $t6, $v1, $0

		li $v0, 4
		la $a0, HAI_NAM_NHUAN
		syscall

		li $v0, 1
		#lw $a0, 0($t5)
		move $a0, $t5
		syscall

		li $v0, 4
		la $a0, VA
		syscall

		li $v0, 1
		#lw $a0, 0($t6)
		move $a0, $t6
		syscall

		li $v0, 4
		la $a0, ENDL
		syscall

		j loop_lua_chon
	
		not_id_6:

		bne $t0, 7, not_id_7

		#id == 7
		#push stack
		addi $sp, $sp, -20
		sw $t0, 0($sp)
		sw $t1, 4($sp)
		sw $t2, 8($sp)
		sw $t3, 12($sp)
		sw $t4, 16($sp)

		li $v0, 4
		la $a0, KET_QUA
		syscall

		add $a0, $s0, $0
		jal output	

		li $v0, 4
		la $a0, HOP_LE
		syscall	

		#pop stack	
		lw $t0, 0($sp)
		lw $t1, 4($sp)
		lw $t2, 8($sp)
		lw $t3, 12($sp)
		lw $t4, 16($sp)
		addi $sp, $sp, 20

		li $v0, 4
		la $a0, ENDL
		syscall
		
		j loop_lua_chon

		not_id_7:

		bne $t0, 8, not_id_8

		j loop_main

		not_id_8:

		bne $t0, 9, not_id_9
		
		j end_loop_main

		not_id_9:

		li $v0, 4
		la $a0, NHAP_LAI
		syscall

		j loop_lua_chon

	end_loop_lua_chon:
	
		
end_loop_main:	

	li $v0, 10
	syscall



day:	# Lay ngay trong chuoi TIME DD/MM/YYYY, bat dau tu $a0, tra ve gia tri so nguyen
	lb $t0, 0($a0)	# t0 la ky tu dau
	addi $t0, $t0, -48	# tru 48 ra so
	li $t1, 10
	mul $t0, $t0, $t1	# nhan them 10 ra hang chuc
	move $v0, $t0
	lb $t0, 1($a0)	# t0 la ky tu a[1]
	addi $t0, $t0, -48	# tru 48 ra so
	add $v0, $v0, $t0	# Cong vo v0
	jr $ra

month:	# Lay thang trong chuoi TIME DD/MM/YYYY, bat dau tu $a0
	lb $t0, 3($a0)	# t0 la ky tu a[3]
	addi $t0, $t0, -48	# tru 48 ra so
	li $t1, 10
	mul $t0, $t0, $t1	# nhan them 10 ra hang chuc
	move $v0, $t0
	lb $t0, 4($a0)	# t0 la ky tu a[4]
	addi $t0, $t0, -48	# tru 48 ra so
	add $v0, $v0, $t0	# Cong vo v0
	jr $ra

year:	# Lay nam trong chuoi TIME DD/MM/YYYY, bat dau tu $a0
	lb $t0, 6($a0)	# t0 la ky tu a[6]
	addi $t0, $t0, -48	# tru 48 ra so
	li $t1, 1000
	mul $t0, $t0, $t1	# nhan them 1000 ra hang ngan
	move $v0, $t0
	lb $t0, 7($a0)	# t0 la ky tu a[7]
	addi $t0, $t0, -48	# tru 48 ra so
	li $t1, 100
	mul $t0, $t0, $t1	# nhan them 100 ra hang tram
	add $v0, $v0, $t0	# Cong vo v0
	lb $t0, 8($a0)	# t0 la ky tu a[8]
	addi $t0, $t0, -48	# tru 48 ra so
	li $t1, 10
	mul $t0, $t0, $t1	# nhan them 10 ra hang chuc
	add $v0, $v0, $t0	# Cong vo v0
	lb $t0, 9($a0)	# t0 la ky tu a[9]
	addi $t0, $t0, -48	# tru 48 ra so
	add $v0, $v0, $t0	# Cong vo v0
	jr $ra

leapYearY:	# Nam a0 la nam nhuan thi v0 = 1, nguoc lai v0 = 0
	# Neu chia het cho 400 thi nhuan
	li $t1, 400
	rem $t0, $a0, $t1
	beqz $t0, Leap11
	# Neu chia het cho 4 va khong chia het cho 100 thi nhuan
	li $t1, 4
	rem $t0, $a0, $t1
	bnez $t0, NotLeap11	# Neu khong chia het cho 4 thi khong nhuan
	li $t1, 100	# Nguoc lai, da chia het cho 4, kiem tra chia het cho 100
	rem $t0, $a0, $t1
	bnez $t0, Leap11	# Neu cung khong chia het cho 100 thi nhuan
	# Con lai khong nhuan
	NotLeap11:
	li $v0, 0
	jr $ra
	Leap11:
	li $v0, 1
	jr $ra

leapYearC:	# Nam DD/MM/YYYY la nam nhuan thi v0 = 1, nguoc lai v0 = 0
	addi $sp, $sp, -8
	sw $ra, 4($sp)	# luu $ra vao stack
	sw $a0, 0($sp)	# luu $a0 vao stack
	jal year	# v0 = year
	move $a0, $v0
	jal leapYearY	# v0 = leapYearY
	lw $a0, 0($sp)	# tra lai $a0
	lw $ra, 4($sp)	# tra lai $ra
	addi $sp, $sp, 8
	jr $ra

findTwoLeapYear:	# Tim 2 nam nhuan $v0=lien duoi va $v1=lien tren nam trong chuoi TIME bat dau tu $a0
	addi $sp, $sp, -8
	sw $ra, 4($sp)	# luu $ra vao stack
	sw $a0, 0($sp)	# luu $a0 vao stack
	jal year	# v0 = year
	addi $t0, $v0, 0	# t0 = year
	addi $t1, $v0, 0	# t1 = year
	Loop12:
	addi $t0, $t0, -1
	move $a0, $t0
	addi $sp, $sp, -8
	sw $t0, 4($sp)	# luu t0 vao stack
	sw $t1, 0($sp)	# luu t1 vao stack
	jal leapYearY	# v0 = leapYearY(year - 1)
	lw $t1, 0($sp)	# tra lai t1
	lw $t0, 4($sp)	# tra lai t0
	addi $sp, $sp, 8
	beqz $v0, Loop12	# Neu chua gap nam nhuan thi lap lai
	Loop13:
	addi $t1, $t1, 1
	move $a0, $t1
	addi $sp, $sp, -8
	sw $t0, 4($sp)	# luu t0 vao stack
	sw $t1, 0($sp)	# luu t1 vao stack
	jal leapYearY	# v0 = leapYearY(year + 1)
	lw $t1, 0($sp)	# tra lai t1
	lw $t0, 4($sp)	# tra lai t0
	addi $sp, $sp, 8
	beqz $v0, Loop13	# Neu chua gap nam nhuan thi lap lai
	move $v0, $t0
	move $v1, $t1
	lw $a0, 0($sp)	#tra lai $a0
	lw $ra, 4($sp)	# tra lai $ra
	addi $sp, $sp, 8
	jr $ra
	
strlen:	# Tinh do dai chuoi, bat dau tu $a0, ket thuc bang '\0' (int==0)
	li $v0, -1	# res = 0
	move $t0, $a0	# bien chay tu vi tri cua ky tu dau tien
	Loop11:
	addi $v0, $v0, 1
	lb $t1, 0($t0)	#doc ky tu vao t1
	addi $t0, $t0, 1
	bnez $t1, Loop11	#ky tu != 0 thi Loop
	jr $ra

strcpy:
	lb $t0, 0($a0)
	beqz $t0, End7
	sb $t0, 0($a1)
	addi $a0, $a0, 1
	addi $a1, $a1, 1
	j strcpy
	End7:
	jr $ra

date:
	li $t1, 10
	div  $a0, $t1
	mflo  $t0
	addi  $t0, $t0, 48
	sb  $t0, 0($a3) #TIME[0] = day / 10
	mfhi $t0
	addi  $t0, $t0, 48
	sb  $t0, 1($a3) #TIME[1] = day % 10
	li $t0, 47
	sb  $t0, 2($a3) #TIME[2] = '/'
	div  $a1, $t1
	mflo  $t0
	addi  $t0, $t0, 48
	sb  $t0, 3($a3) #TIME[3] = month / 10
	mfhi $t0
	addi  $t0, $t0, 48
	sb  $t0, 4($a3) #TIME[4] = month % 10
	li $t0, 47
	sb  $t0, 5($a3) #TIME[5] = '/'
	li $t1, 1000
	div  $a2, $t1
	mflo  $t0
	addi  $t0, $t0, 48
	sb  $t0, 6($a3) #TIME[6] = year / 1000
	mfhi $t0
	li $t1, 100
	div  $t0, $t1
	mflo $t0
	addi  $t0, $t0, 48
	sb  $t0, 7($a3) #TIME[7] = year % 1000 / 100
	mfhi $t0
	li $t1, 10
	div  $t0, $t1
	mflo $t0
	addi  $t0, $t0, 48
	sb  $t0, 8($a3) #TIME[8] = year % 1000 % 100 / 10
	mfhi $t0
	addi  $t0, $t0, 48
	sb $t0, 9($a3) #TIME[9] = year % 1000 % 100 % 10
	sb $0, 10($a3) #TIME[10] = '\0'
	add $v0, $a3, $0
	jr $ra
	
getMonthName :
.data
	Jan : .asciiz "Jan"
	Feb : .asciiz "Feb"
	Mar : .asciiz "Mar"
	Apr : .asciiz "Apr"
	May : .asciiz "May"
	Jun : .asciiz "Jun"
	Jul : .asciiz "Jul"
	Aug : .asciiz "Aug"
	Sep : .asciiz "Sep"
	Oct : .asciiz "Oct"
	Nov : .asciiz "Nov"
	Dec : .asciiz "Dec"
	NoA : .asciiz "N/A"
.text
	bne $a0, 1, nJan
	la $v0, Jan
	j End1
	nJan :
	bne $a0, 2, nFeb
	la $v0, Feb
	j End1
	nFeb :
	bne $a0, 3, nMar
	la $v0, Mar
	j End1
	nMar :
	bne $a0, 4, nApr
	la $v0, Apr
	j End1
	nApr :
	bne $a0, 5, nMay
	la $v0, May
	j End1
	nMay :
	bne $a0, 6, nJun
	la $v0, Jun
	j End1
	nJun :
	bne $a0, 7, nJul
	la $v0, Jul
	j End1
	nJul :
	bne $a0, 8, nAug
	la $v0, Aug
	j End1
	nAug :
	bne $a0, 9, nSep
	la $v0, Sep
	j End1
	nSep :
	bne $a0, 10, nOct
	la $v0, Oct
	j End1
	nOct :
	bne $a0, 11, nNov
	la $v0, Nov
	j End1
	nNov :
	bne $a0, 12, nDec
	la $v0, Dec
	j End1
	nDec :
	la $v0, NoA
	End1:
	jr $ra

convert:
.data
	error1: .asciiz "Sai cu phap, xin vui long nhap lai!"
.text
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $a0, 15
	li $v0, 9
	syscall
	
	move $t0, $v0
	sw $t0, 12($sp)
	lw $a0, 0($sp)
	move $a1, $t0
	jal strcpy
	
	lw $t0, 12($sp)
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	beq $a1, 97, Branch3
	bne $a1, 65, Next1
	Branch3:
	lb $t1, 0($t0)
	lb $t2, 1($t0)
	lb $t3, 3($t0)
	sb $t3, 0($t0)
	lb $t3, 4($t0)
	sb $t3, 1($t0)
	sb $t1, 3($t0)
	sb $t2, 4($t0)
	j End8

	Next1: 
	beq $a1, 98, Branch4
	bne $a1, 66, Next2
	Branch4:
	lb $t1, 0($t0)
	lb $t2, 1($t0)
	lb $t3, 3($t0)
	sb $t3, 0($t0)
	lb $t3, 4($t0)
	sb $t3, 1($t0)
	sb $t1, 3($t0)
	sb $t2, 4($t0) #Convert A
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	move $a0, $t0
	jal strlen
	lw $t0, 0($sp)
	add $sp, $sp, 4
	move $t1, $v0
	addi $t1, $t1, 1
	add $t0, $t0, $t1
	Loop5:	#res[i+1] = res[i]
	ble $t1, 0, End9
	lb $t2, 0($t0)
	sb $t2, 1($t0)	
	addi $t1, $t1, -1
	addi $t0, $t0, -1
	j Loop5
	End9:
	lw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal month #handle character
	move $a0, $v0
	jal getMonthName
	lw $t0, 0($sp)
	add $sp, $sp, 4
	move $t1, $v0
	lb $t2, 0($t1)
	lb $t3, 1($t1)
	lb $t4, 2($t1)
	sb $t2, 0($t0)
	sb $t3, 1($t0)
	sb $t4, 2($t0)
	li $t2, 32
	sb $t2, 3($t0)
	li $t2, 44
	sb $t2, 6($t0)
	lb $t2, 10($t0)
	sb $t2, 11($t0)
	lb $t2, 9($t0)
	sb $t2, 10($t0)
	lb $t2, 8($t0)
	sb $t2, 9($t0)
	lb $t2, 7($t0)
	sb $t2, 8($t0)
	li $t2, 32
	sb $t2, 7($t0)
	sb $0, 12($t0)
	j End8

	Next2: 
	beq $a1, 99, Branch5
	bne $a1, 67, Next3
	Branch5:
	move $a0, $t0
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal strlen
	lw $t0, 0($sp)
	add $sp, $sp, 4
	move $t1, $v0
	addi $t1, $t1, 1
	add $t0, $t0, $t1
	Loop6:	#res[i+1] = res[i]
	blt $t1, 3, End10
	lb $t2, 0($t0)
	sb $t2, 1($t0)	
	addi $t1, $t1, -1
	addi $t0, $t0, -1
	j Loop6
	End10:
	addi $t0, $t0, -2
	lw $a0, 0($sp)
	addi $sp, $sp, -4
	sw $t0, 0($sp)
	jal month #handle character
	move $a0, $v0
	jal getMonthName
	lw $t0, 0($sp)
	add $sp, $sp, 4
	move $t1, $v0
	lb $t2, 0($t1)
	lb $t3, 1($t1)
	lb $t4, 2($t1)
	sb $t2, 3($t0)
	sb $t3, 4($t0)
	sb $t4, 5($t0)
	li $t2, 32
	sb $t2, 2($t0)
	li $t2, 44
	sb $t2, 6($t0)
	lb $t2, 10($t0)
	sb $t2, 11($t0)
	lb $t2, 9($t0)
	sb $t2, 10($t0)
	lb $t2, 8($t0)
	sb $t2, 9($t0)
	lb $t2, 7($t0)
	sb $t2, 8($t0)
	li $t2, 32
	sb $t2, 7($t0)
	sb $0, 12($t0)
	j End8
	
	
	Next3:
	la $v0, error1
	j errorInform
	End8:
	move $v0, $t0
	errorInform:
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
numberOfDaysInMonth:	# v0 = so ngay cua thang a0 nam a1
	li $t0, 1
	beq $a0, $t0, Thang31ngay
	li $t0, 3
	beq $a0, $t0, Thang31ngay
	li $t0, 5
	beq $a0, $t0, Thang31ngay
	li $t0, 7
	beq $a0, $t0, Thang31ngay
	li $t0, 8
	beq $a0, $t0, Thang31ngay
	li $t0, 10
	beq $a0, $t0, Thang31ngay
	li $t0, 12
	beq $a0, $t0, Thang31ngay
	li $t0, 4
	beq $a0, $t0, Thang30ngay
	li $t0, 6
	beq $a0, $t0, Thang30ngay
	li $t0, 9
	beq $a0, $t0, Thang30ngay
	li $t0, 11
	beq $a0, $t0, Thang30ngay
	# con lai thang 2, xet tiep nam a1
	addi $sp, $sp, -8
	sw $ra, 4($sp)	# luu ra vao stack
	sw $a0, 0($sp)	# luu a0 vao stack
	move $a0, $a1
	jal leapYearY
	lw $a0, 0($sp)	# tra lai a0
	lw $ra, 4($sp)	# tra lai $ra
	addi $sp, $sp, 8
	beqz $v0, Thang28ngay
	li $v0, 29	# Thang 29 ngay
	jr $ra
	Thang28ngay:
	li $v0, 28
	jr $ra
	Thang30ngay:
	li $v0, 30
	jr $ra
	Thang31ngay:
	li $v0, 31
	jr $ra

getStandardDay:
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	addi $sp, $sp, -8
	jal day
	sw $v0, 0($sp) #day
	jal month
	sw $v0, 4($sp) #month
	jal year
	move $t2, $v0 #year
	addi $t2, $t2, -1
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	li $t3, 4
	div $t4, $t2, $t3
	li $t3, 100
	div $t5, $t2, $t3
	sub $t4, $t4, $t5
	li $t3, 400
	div $t5, $t2, $t3
	add $t4, $t4, $t5 #bonus = year/4-year/100+year/400

	addi $t2, $t2, 1
	move $t3, $t0 #sDay = day
	add $t3, $t3, $t4 #sDay += bonus
	li $t4, 365
	mul $t4, $t4, $t2
	add $t3, $t3, $t4 #sDay += 365*year
	li $t4, 1
	Loop1:
	bge $t4, $t1, End2
	move $a0, $t4
	move $a1, $t2
	addi $sp, $sp, -16
	sw $t3, 0($sp)
	sw $t4, 4($sp)
	sw $t1, 8($sp)
	sw $t2, 12($sp)
	jal numberOfDaysInMonth
	lw $t3, 0($sp)
	lw $t4, 4($sp)
	lw $t1, 8($sp)
	lw $t2, 12($sp)
	addi $sp, $sp, 16
	add $t3, $t3, $v0 #sDay += nODIM
	addi $t4, $t4, 1
	j Loop1

	End2:
	move $v0, $t3 #return sDay
	lw $ra, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	addi $sp, $sp, 12
	jr $ra
		
getTime:	# v0 = khoang cach tu TIME_1(a0) toi TIME_2(a1) (don vi ngay)
	addi $sp, $sp, -12
	sw $ra, 8($sp)	# luu ra vao stack
	sw $a0, 4($sp)	# luu a0 vao stack
	jal getStandardDay
	sw $v0, 0($sp)	# luu getStandardDay(TIME_1) vao stack
	move $a0, $a1
	jal getStandardDay	# v0 = getStandardDay(TIME_2)
	lw $t0, 0($sp)	# t0 = getStandardDay(TIME_1), duoc tra lai tu stack
	sub $v0, $v0, $t0	# v0 = getStandardDay(TIME_2) - getStandardDay(TIME_1);
	lw $a0, 4($sp)	# tra lai a0
	lw $ra, 8($sp)	# tra lai ra
	addi $sp, $sp, 12
	jr $ra

getDayName:	# a0 == 1.v0=Sun  2.v0=Mon  3.v0=Tues  4.v0=Wed  5.v0=Thurs  6.v0=Fri  7.v0=Sat
.data
	Sun : .asciiz "Sun"
	Mon : .asciiz "Mon"
	Tue : .asciiz "Tues"
	Wed : .asciiz "Wed"
	Thu : .asciiz "Thurs"
	Fri : .asciiz "Fri"
	Sat : .asciiz "Sat"
	NoA11 : .asciiz "N/A"
.text
	bne $a0, 1, nSun
	la $v0, Sun
	j End11
	nSun :
	bne $a0, 2, nMon
	la $v0, Mon
	j End11
	nMon :
	bne $a0, 3, nTue
	la $v0, Tue
	j End11
	nTue :
	bne $a0, 4, nWed
	la $v0, Wed
	j End11
	nWed :
	bne $a0, 5, nThu
	la $v0, Thu
	j End11
	nThu :
	bne $a0, 6, nFri
	la $v0, Fri
	j End11
	nFri :
	bne $a0, 7, nSat
	la $v0, Sat
	j End11
	nSat :
	la $v0, NoA11
	End11:
	jr $ra

weekDay:	# Cho biet TIME(a0) la thu v0 trong tuan, v0={Sun, Mon, Tues,...}
.data
	chuan11: .byte 0:11
.text
	addi $sp, $sp, -8
	sw $ra, 4($sp)	# luu ra vao stack
	sw $a0, 0($sp)	# luu a0 vao stack
	# Ngay 10 thang 12 nam 2015 la thu 5. Lay day lam chuan
	li $a0, 10
	li $a1, 12
	li $a2, 2015
	la $a3, chuan11
	jal date
	move $a0, $v0	# a0 = date(10, 12, 2015) = chuan
	lw $a1, 0($sp)	# a1 = TIME
	jal getTime
	move $a0, $v0	# a0 = GetTime(chuan, TIME)
	# a0 = (5 + 7 + (a0 % 7)) % 7;	//5 la thu nam
	li $t0, 7
	rem $a0, $a0, $t0 	# a0 = a0 % 7
	addi $a0, $a0, 7	# () + 7
	addi $a0, $a0, 5	# () + 5	//5 la thu nam
	rem $a0, $a0, $t0 	# () % 7
	bnez $a0, End14	# if (a0 == 0) a0 = 7;
	li $a0, 7
	End14:
	jal getDayName	# v0 = getDayName(a0)
	lw $a0, 0($sp)	# tra lai a0
	lw $ra, 4($sp)	# tra lai ra
	addi $sp, $sp, 8
	jr $ra

convertToNumber:
	move $t0, $a0
	Loop2:
	lb $t1, 0($t0)
	beqz $t1, End3
	bne $t1, 48, End3
	beq $t1, 10, End3
	addi $t0, $t0, 1
	j Loop2
	
	End3:
	move $t1, $a0
	Loop3:
	lb $t2, 0($t1)
	beqz $t2, End4
	beq $t2, 10, End4
	addi $t1, $t1, 1
	j Loop3

	End4:
	li $t3, 10
	move $t2, $0
	Loop4:
	beq $t0, $t1, End5
	lb $t4, 0($t0)
	mul $t2, $t2, $t3
	addi $t4, $t4, -48
	add $t2, $t2, $t4
	addi $t0, $t0, 1
	j Loop4
	
	End5:
	bge $t2, $a1, Branch1 #if >= lower_bound
	li $v0, -1
	j End6
	Branch1:
	ble $t2, $a2, Branch2 #if <= upper_bound
	li $v0, -1
	j End6
	Branch2:
	move $v0, $t2
	End6:
	jr $ra


input:
.data
	buffer2: .space 100
	buffer3: .space 100
	buffer4: .space 100
   	str1:  .asciiz "Nhap ngay DAY: "
   	str2:  .asciiz "Nhap thang MONTH: "
   	str3:  .asciiz "Nhap nam YEAR: "
.text
	addi $sp, $sp, -8
	sw $a0, 0($sp)
	sw $ra, 4($sp)
	#day
   	la $a0, str1 
   	li $v0, 4
   	syscall

   	li $v0, 8 
 	la $a0, buffer2 
  	li $a1, 100      
   	move $t0, $a0   
   	syscall
	#month
	la $a0, str2 
   	li $v0, 4
   	syscall

   	li $v0, 8 
 	la $a0, buffer3 
  	li $a1, 100      
   	move $t1, $a0   
   	syscall
	#year
	la $a0, str3 
   	li $v0, 4
   	syscall

   	li $v0, 8 
 	la $a0, buffer4 
  	li $a1, 100      
   	move $t2, $a0   
   	syscall
	#convert
	#year
	move $a0, $t2
	li $a1, 0
	li $a2, 9999
	addi $sp, $sp, -16
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	jal convertToNumber
	sw $v0, 12($sp)
	#month
	lw $t1, 4($sp)
	move $a0, $t1
	li $a1, 1
	li $a2, 12
	jal convertToNumber
	move $t4, $v0
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	addi $sp, $sp, 16
	beq $t3, -1, End101
	beq $t4, -1, End101
	#day
	move $a0, $t4
	move $a1, $t3
	addi $sp, $sp, -20
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	jal numberOfDaysInMonth
	lw $t0, 0($sp)
	move $a2, $v0
	move $a0, $t0
	li $a1, 1
	jal convertToNumber
	move $t5, $v0
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 12($sp)
	lw $t4, 16($sp)
	addi $sp, $sp, 20
	beq $t5, -1, End101
	move $a0, $t5
	move $a1, $t4
	move $a2, $t3
	lw $a3, 0($sp)
	jal date
	move $a0, $v0
	j End102
	End101:
	li $v0, -1
	End102:
	lw $ra, 4($sp)
	addi $sp, $sp, 8
	jr $ra

output:
.data
	buffer1: .space 20
.text
	move $t0, $a0
	la $a0, buffer1
	move $a0, $t0
	li $v0, 4
	syscall
	jr $ra
