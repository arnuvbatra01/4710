
uppercase.bin:     file format elf32-littleriscv


Disassembly of section .text:

00010074 <_start>:
   10074:	ffff2397          	auipc	t2,0xffff2
   10078:	f8c38393          	addi	t2,t2,-116 # 2000 <__DATA_BEGIN__>

0001007c <loop>:
   1007c:	00038303          	lb	t1,0(t2)
   10080:	02030463          	beqz	t1,100a8 <end_program>
   10084:	06100413          	li	s0,97
   10088:	07a00493          	li	s1,122
   1008c:	00834a63          	blt	t1,s0,100a0 <done>
   10090:	0064c863          	blt	s1,t1,100a0 <done>
   10094:	02000093          	li	ra,32
   10098:	40130333          	sub	t1,t1,ra
   1009c:	00638023          	sb	t1,0(t2)

000100a0 <done>:
   100a0:	00138393          	addi	t2,t2,1
   100a4:	fd9ff06f          	j	1007c <loop>

000100a8 <end_program>:
   100a8:	0000006f          	j	100a8 <end_program>
