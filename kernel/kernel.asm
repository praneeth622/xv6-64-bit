
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	a8010113          	addi	sp,sp,-1408 # 80008a80 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	04a000ef          	jal	80000060 <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000022:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80000026:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    8000002a:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    8000002e:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80000032:	577d                	li	a4,-1
    80000034:	177e                	slli	a4,a4,0x3f
    80000036:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80000038:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    8000003c:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000040:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80000044:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80000048:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    8000004c:	000f4737          	lui	a4,0xf4
    80000050:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000054:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80000056:	14d79073          	csrw	stimecmp,a5
}
    8000005a:	6422                	ld	s0,8(sp)
    8000005c:	0141                	addi	sp,sp,16
    8000005e:	8082                	ret

0000000080000060 <start>:
{
    80000060:	1141                	addi	sp,sp,-16
    80000062:	e406                	sd	ra,8(sp)
    80000064:	e022                	sd	s0,0(sp)
    80000066:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000006c:	7779                	lui	a4,0xffffe
    8000006e:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fe4471f>
    80000072:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80000074:	6705                	lui	a4,0x1
    80000076:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000007a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000007c:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80000080:	00001797          	auipc	a5,0x1
    80000084:	e4678793          	addi	a5,a5,-442 # 80000ec6 <main>
    80000088:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000008c:	4781                	li	a5,0
    8000008e:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80000092:	67c1                	lui	a5,0x10
    80000094:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80000096:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000009a:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    8000009e:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000a2:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000a6:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000aa:	57fd                	li	a5,-1
    800000ac:	83a9                	srli	a5,a5,0xa
    800000ae:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000b2:	47bd                	li	a5,15
    800000b4:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000b8:	f65ff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000bc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000c2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000c4:	30200073          	mret
}
    800000c8:	60a2                	ld	ra,8(sp)
    800000ca:	6402                	ld	s0,0(sp)
    800000cc:	0141                	addi	sp,sp,16
    800000ce:	8082                	ret

00000000800000d0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d0:	715d                	addi	sp,sp,-80
    800000d2:	e486                	sd	ra,72(sp)
    800000d4:	e0a2                	sd	s0,64(sp)
    800000d6:	f84a                	sd	s2,48(sp)
    800000d8:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    800000da:	04c05263          	blez	a2,8000011e <consolewrite+0x4e>
    800000de:	fc26                	sd	s1,56(sp)
    800000e0:	f44e                	sd	s3,40(sp)
    800000e2:	f052                	sd	s4,32(sp)
    800000e4:	ec56                	sd	s5,24(sp)
    800000e6:	8a2a                	mv	s4,a0
    800000e8:	84ae                	mv	s1,a1
    800000ea:	89b2                	mv	s3,a2
    800000ec:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    800000ee:	5afd                	li	s5,-1
    800000f0:	4685                	li	a3,1
    800000f2:	8626                	mv	a2,s1
    800000f4:	85d2                	mv	a1,s4
    800000f6:	fbf40513          	addi	a0,s0,-65
    800000fa:	0c5020ef          	jal	800029be <either_copyin>
    800000fe:	03550263          	beq	a0,s5,80000122 <consolewrite+0x52>
      break;
    uartputc(c);
    80000102:	fbf44503          	lbu	a0,-65(s0)
    80000106:	099000ef          	jal	8000099e <uartputc>
  for(i = 0; i < n; i++){
    8000010a:	2905                	addiw	s2,s2,1
    8000010c:	0485                	addi	s1,s1,1
    8000010e:	ff2991e3          	bne	s3,s2,800000f0 <consolewrite+0x20>
    80000112:	894e                	mv	s2,s3
    80000114:	74e2                	ld	s1,56(sp)
    80000116:	79a2                	ld	s3,40(sp)
    80000118:	7a02                	ld	s4,32(sp)
    8000011a:	6ae2                	ld	s5,24(sp)
    8000011c:	a039                	j	8000012a <consolewrite+0x5a>
    8000011e:	4901                	li	s2,0
    80000120:	a029                	j	8000012a <consolewrite+0x5a>
    80000122:	74e2                	ld	s1,56(sp)
    80000124:	79a2                	ld	s3,40(sp)
    80000126:	7a02                	ld	s4,32(sp)
    80000128:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    8000012a:	854a                	mv	a0,s2
    8000012c:	60a6                	ld	ra,72(sp)
    8000012e:	6406                	ld	s0,64(sp)
    80000130:	7942                	ld	s2,48(sp)
    80000132:	6161                	addi	sp,sp,80
    80000134:	8082                	ret

0000000080000136 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000136:	711d                	addi	sp,sp,-96
    80000138:	ec86                	sd	ra,88(sp)
    8000013a:	e8a2                	sd	s0,80(sp)
    8000013c:	e4a6                	sd	s1,72(sp)
    8000013e:	e0ca                	sd	s2,64(sp)
    80000140:	fc4e                	sd	s3,56(sp)
    80000142:	f852                	sd	s4,48(sp)
    80000144:	f456                	sd	s5,40(sp)
    80000146:	f05a                	sd	s6,32(sp)
    80000148:	1080                	addi	s0,sp,96
    8000014a:	8aaa                	mv	s5,a0
    8000014c:	8a2e                	mv	s4,a1
    8000014e:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000150:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    80000154:	00011517          	auipc	a0,0x11
    80000158:	92c50513          	addi	a0,a0,-1748 # 80010a80 <cons>
    8000015c:	2fd000ef          	jal	80000c58 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000160:	00011497          	auipc	s1,0x11
    80000164:	92048493          	addi	s1,s1,-1760 # 80010a80 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80000168:	00011917          	auipc	s2,0x11
    8000016c:	9b090913          	addi	s2,s2,-1616 # 80010b18 <cons+0x98>
  while(n > 0){
    80000170:	0b305d63          	blez	s3,8000022a <consoleread+0xf4>
    while(cons.r == cons.w){
    80000174:	0984a783          	lw	a5,152(s1)
    80000178:	09c4a703          	lw	a4,156(s1)
    8000017c:	0af71263          	bne	a4,a5,80000220 <consoleread+0xea>
      if(killed(myproc())){
    80000180:	6af010ef          	jal	8000202e <myproc>
    80000184:	6cc020ef          	jal	80002850 <killed>
    80000188:	e12d                	bnez	a0,800001ea <consoleread+0xb4>
      sleep(&cons.r, &cons.lock);
    8000018a:	85a6                	mv	a1,s1
    8000018c:	854a                	mv	a0,s2
    8000018e:	48a020ef          	jal	80002618 <sleep>
    while(cons.r == cons.w){
    80000192:	0984a783          	lw	a5,152(s1)
    80000196:	09c4a703          	lw	a4,156(s1)
    8000019a:	fef703e3          	beq	a4,a5,80000180 <consoleread+0x4a>
    8000019e:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001a0:	00011717          	auipc	a4,0x11
    800001a4:	8e070713          	addi	a4,a4,-1824 # 80010a80 <cons>
    800001a8:	0017869b          	addiw	a3,a5,1
    800001ac:	08d72c23          	sw	a3,152(a4)
    800001b0:	07f7f693          	andi	a3,a5,127
    800001b4:	9736                	add	a4,a4,a3
    800001b6:	01874703          	lbu	a4,24(a4)
    800001ba:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    800001be:	4691                	li	a3,4
    800001c0:	04db8663          	beq	s7,a3,8000020c <consoleread+0xd6>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800001c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800001c8:	4685                	li	a3,1
    800001ca:	faf40613          	addi	a2,s0,-81
    800001ce:	85d2                	mv	a1,s4
    800001d0:	8556                	mv	a0,s5
    800001d2:	7a2020ef          	jal	80002974 <either_copyout>
    800001d6:	57fd                	li	a5,-1
    800001d8:	04f50863          	beq	a0,a5,80000228 <consoleread+0xf2>
      break;

    dst++;
    800001dc:	0a05                	addi	s4,s4,1
    --n;
    800001de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800001e0:	47a9                	li	a5,10
    800001e2:	04fb8d63          	beq	s7,a5,8000023c <consoleread+0x106>
    800001e6:	6be2                	ld	s7,24(sp)
    800001e8:	b761                	j	80000170 <consoleread+0x3a>
        release(&cons.lock);
    800001ea:	00011517          	auipc	a0,0x11
    800001ee:	89650513          	addi	a0,a0,-1898 # 80010a80 <cons>
    800001f2:	2ff000ef          	jal	80000cf0 <release>
        return -1;
    800001f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800001f8:	60e6                	ld	ra,88(sp)
    800001fa:	6446                	ld	s0,80(sp)
    800001fc:	64a6                	ld	s1,72(sp)
    800001fe:	6906                	ld	s2,64(sp)
    80000200:	79e2                	ld	s3,56(sp)
    80000202:	7a42                	ld	s4,48(sp)
    80000204:	7aa2                	ld	s5,40(sp)
    80000206:	7b02                	ld	s6,32(sp)
    80000208:	6125                	addi	sp,sp,96
    8000020a:	8082                	ret
      if(n < target){
    8000020c:	0009871b          	sext.w	a4,s3
    80000210:	01677a63          	bgeu	a4,s6,80000224 <consoleread+0xee>
        cons.r--;
    80000214:	00011717          	auipc	a4,0x11
    80000218:	90f72223          	sw	a5,-1788(a4) # 80010b18 <cons+0x98>
    8000021c:	6be2                	ld	s7,24(sp)
    8000021e:	a031                	j	8000022a <consoleread+0xf4>
    80000220:	ec5e                	sd	s7,24(sp)
    80000222:	bfbd                	j	800001a0 <consoleread+0x6a>
    80000224:	6be2                	ld	s7,24(sp)
    80000226:	a011                	j	8000022a <consoleread+0xf4>
    80000228:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000022a:	00011517          	auipc	a0,0x11
    8000022e:	85650513          	addi	a0,a0,-1962 # 80010a80 <cons>
    80000232:	2bf000ef          	jal	80000cf0 <release>
  return target - n;
    80000236:	413b053b          	subw	a0,s6,s3
    8000023a:	bf7d                	j	800001f8 <consoleread+0xc2>
    8000023c:	6be2                	ld	s7,24(sp)
    8000023e:	b7f5                	j	8000022a <consoleread+0xf4>

0000000080000240 <consputc>:
{
    80000240:	1141                	addi	sp,sp,-16
    80000242:	e406                	sd	ra,8(sp)
    80000244:	e022                	sd	s0,0(sp)
    80000246:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000248:	10000793          	li	a5,256
    8000024c:	00f50863          	beq	a0,a5,8000025c <consputc+0x1c>
    uartputc_sync(c);
    80000250:	668000ef          	jal	800008b8 <uartputc_sync>
}
    80000254:	60a2                	ld	ra,8(sp)
    80000256:	6402                	ld	s0,0(sp)
    80000258:	0141                	addi	sp,sp,16
    8000025a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000025c:	4521                	li	a0,8
    8000025e:	65a000ef          	jal	800008b8 <uartputc_sync>
    80000262:	02000513          	li	a0,32
    80000266:	652000ef          	jal	800008b8 <uartputc_sync>
    8000026a:	4521                	li	a0,8
    8000026c:	64c000ef          	jal	800008b8 <uartputc_sync>
    80000270:	b7d5                	j	80000254 <consputc+0x14>

0000000080000272 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80000272:	1101                	addi	sp,sp,-32
    80000274:	ec06                	sd	ra,24(sp)
    80000276:	e822                	sd	s0,16(sp)
    80000278:	e426                	sd	s1,8(sp)
    8000027a:	1000                	addi	s0,sp,32
    8000027c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000027e:	00011517          	auipc	a0,0x11
    80000282:	80250513          	addi	a0,a0,-2046 # 80010a80 <cons>
    80000286:	1d3000ef          	jal	80000c58 <acquire>

  switch(c){
    8000028a:	47c1                	li	a5,16
    8000028c:	0cf48163          	beq	s1,a5,8000034e <consoleintr+0xdc>
    80000290:	0297dd63          	bge	a5,s1,800002ca <consoleintr+0x58>
    80000294:	47d5                	li	a5,21
    80000296:	06f48463          	beq	s1,a5,800002fe <consoleintr+0x8c>
    8000029a:	07f00793          	li	a5,127
    8000029e:	10f49563          	bne	s1,a5,800003a8 <consoleintr+0x136>
        // Optionally: You can also trigger a signal handler in user space if defined
      }
    }
    break;
  case '\x7f': // Delete key (Backspace)
    if(cons.e != cons.w){
    800002a2:	00010717          	auipc	a4,0x10
    800002a6:	7de70713          	addi	a4,a4,2014 # 80010a80 <cons>
    800002aa:	0a072783          	lw	a5,160(a4)
    800002ae:	09c72703          	lw	a4,156(a4)
    800002b2:	0af70063          	beq	a4,a5,80000352 <consoleintr+0xe0>
      cons.e--;
    800002b6:	37fd                	addiw	a5,a5,-1
    800002b8:	00011717          	auipc	a4,0x11
    800002bc:	86f72423          	sw	a5,-1944(a4) # 80010b20 <cons+0xa0>
      consputc(BACKSPACE);
    800002c0:	10000513          	li	a0,256
    800002c4:	f7dff0ef          	jal	80000240 <consputc>
    800002c8:	a069                	j	80000352 <consoleintr+0xe0>
  switch(c){
    800002ca:	478d                	li	a5,3
    800002cc:	0af48063          	beq	s1,a5,8000036c <consoleintr+0xfa>
    800002d0:	47a1                	li	a5,8
    800002d2:	0cf49a63          	bne	s1,a5,800003a6 <consoleintr+0x134>
    if(cons.e != cons.w){
    800002d6:	00010717          	auipc	a4,0x10
    800002da:	7aa70713          	addi	a4,a4,1962 # 80010a80 <cons>
    800002de:	0a072783          	lw	a5,160(a4)
    800002e2:	09c72703          	lw	a4,156(a4)
    800002e6:	06f70663          	beq	a4,a5,80000352 <consoleintr+0xe0>
      cons.e--;
    800002ea:	37fd                	addiw	a5,a5,-1
    800002ec:	00011717          	auipc	a4,0x11
    800002f0:	82f72a23          	sw	a5,-1996(a4) # 80010b20 <cons+0xa0>
      consputc(BACKSPACE);
    800002f4:	10000513          	li	a0,256
    800002f8:	f49ff0ef          	jal	80000240 <consputc>
    800002fc:	a899                	j	80000352 <consoleintr+0xe0>
    800002fe:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000300:	00010717          	auipc	a4,0x10
    80000304:	78070713          	addi	a4,a4,1920 # 80010a80 <cons>
    80000308:	0a072783          	lw	a5,160(a4)
    8000030c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000310:	00010497          	auipc	s1,0x10
    80000314:	77048493          	addi	s1,s1,1904 # 80010a80 <cons>
    while(cons.e != cons.w &&
    80000318:	4929                	li	s2,10
    8000031a:	02f70863          	beq	a4,a5,8000034a <consoleintr+0xd8>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000031e:	37fd                	addiw	a5,a5,-1
    80000320:	07f7f713          	andi	a4,a5,127
    80000324:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80000326:	01874703          	lbu	a4,24(a4)
    8000032a:	03270f63          	beq	a4,s2,80000368 <consoleintr+0xf6>
      cons.e--;
    8000032e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80000332:	10000513          	li	a0,256
    80000336:	f0bff0ef          	jal	80000240 <consputc>
    while(cons.e != cons.w &&
    8000033a:	0a04a783          	lw	a5,160(s1)
    8000033e:	09c4a703          	lw	a4,156(s1)
    80000342:	fcf71ee3          	bne	a4,a5,8000031e <consoleintr+0xac>
    80000346:	6902                	ld	s2,0(sp)
    80000348:	a029                	j	80000352 <consoleintr+0xe0>
    8000034a:	6902                	ld	s2,0(sp)
    8000034c:	a019                	j	80000352 <consoleintr+0xe0>
    procdump();
    8000034e:	6ba020ef          	jal	80002a08 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    80000352:	00010517          	auipc	a0,0x10
    80000356:	72e50513          	addi	a0,a0,1838 # 80010a80 <cons>
    8000035a:	197000ef          	jal	80000cf0 <release>
}
    8000035e:	60e2                	ld	ra,24(sp)
    80000360:	6442                	ld	s0,16(sp)
    80000362:	64a2                	ld	s1,8(sp)
    80000364:	6105                	addi	sp,sp,32
    80000366:	8082                	ret
    80000368:	6902                	ld	s2,0(sp)
    8000036a:	b7e5                	j	80000352 <consoleintr+0xe0>
      struct proc *p = myproc();  // Get the current process
    8000036c:	4c3010ef          	jal	8000202e <myproc>
    80000370:	84aa                	mv	s1,a0
      if (p != 0) {  // Ensure the process is valid
    80000372:	d165                	beqz	a0,80000352 <consoleintr+0xe0>
        printf("\nDetected Ctrl+C\n");
    80000374:	00008517          	auipc	a0,0x8
    80000378:	c8c50513          	addi	a0,a0,-884 # 80008000 <etext>
    8000037c:	1aa000ef          	jal	80000526 <printf>
        if(p->sig_handlers[2] != 0){
    80000380:	1884b783          	ld	a5,392(s1)
    80000384:	cf91                	beqz	a5,800003a0 <consoleintr+0x12e>
          printf("Calling custom SIGINT handler\n");
    80000386:	00008517          	auipc	a0,0x8
    8000038a:	c9250513          	addi	a0,a0,-878 # 80008018 <etext+0x18>
    8000038e:	198000ef          	jal	80000526 <printf>
          p->sig_handlers[2](SIGINT);
    80000392:	1884b783          	ld	a5,392(s1)
    80000396:	4509                	li	a0,2
    80000398:	9782                	jalr	a5
        p->killed = 1;  // Set the killed flag to terminate the process
    8000039a:	4785                	li	a5,1
    8000039c:	d49c                	sw	a5,40(s1)
    8000039e:	bf55                	j	80000352 <consoleintr+0xe0>
          sigint_default_handler();
    800003a0:	74e020ef          	jal	80002aee <sigint_default_handler>
    800003a4:	bfdd                	j	8000039a <consoleintr+0x128>
    if(c != 0 && cons.e - cons.r < INPUT_BUF_SIZE){
    800003a6:	d4d5                	beqz	s1,80000352 <consoleintr+0xe0>
    800003a8:	00010717          	auipc	a4,0x10
    800003ac:	6d870713          	addi	a4,a4,1752 # 80010a80 <cons>
    800003b0:	0a072783          	lw	a5,160(a4)
    800003b4:	09872703          	lw	a4,152(a4)
    800003b8:	9f99                	subw	a5,a5,a4
    800003ba:	07f00713          	li	a4,127
    800003be:	f8f76ae3          	bltu	a4,a5,80000352 <consoleintr+0xe0>
      c = (c == '\r') ? '\n' : c;  // Convert carriage return to newline
    800003c2:	47b5                	li	a5,13
    800003c4:	04f48663          	beq	s1,a5,80000410 <consoleintr+0x19e>
      consputc(c);
    800003c8:	8526                	mv	a0,s1
    800003ca:	e77ff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003ce:	00010797          	auipc	a5,0x10
    800003d2:	6b278793          	addi	a5,a5,1714 # 80010a80 <cons>
    800003d6:	0a07a683          	lw	a3,160(a5)
    800003da:	0016871b          	addiw	a4,a3,1
    800003de:	0007061b          	sext.w	a2,a4
    800003e2:	0ae7a023          	sw	a4,160(a5)
    800003e6:	07f6f693          	andi	a3,a3,127
    800003ea:	97b6                	add	a5,a5,a3
    800003ec:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE){
    800003f0:	47a9                	li	a5,10
    800003f2:	04f48463          	beq	s1,a5,8000043a <consoleintr+0x1c8>
    800003f6:	4791                	li	a5,4
    800003f8:	04f48163          	beq	s1,a5,8000043a <consoleintr+0x1c8>
    800003fc:	00010797          	auipc	a5,0x10
    80000400:	71c7a783          	lw	a5,1820(a5) # 80010b18 <cons+0x98>
    80000404:	9f1d                	subw	a4,a4,a5
    80000406:	08000793          	li	a5,128
    8000040a:	f4f714e3          	bne	a4,a5,80000352 <consoleintr+0xe0>
    8000040e:	a035                	j	8000043a <consoleintr+0x1c8>
      consputc(c);
    80000410:	4529                	li	a0,10
    80000412:	e2fff0ef          	jal	80000240 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000416:	00010797          	auipc	a5,0x10
    8000041a:	66a78793          	addi	a5,a5,1642 # 80010a80 <cons>
    8000041e:	0a07a703          	lw	a4,160(a5)
    80000422:	0017069b          	addiw	a3,a4,1
    80000426:	0006861b          	sext.w	a2,a3
    8000042a:	0ad7a023          	sw	a3,160(a5)
    8000042e:	07f77713          	andi	a4,a4,127
    80000432:	97ba                	add	a5,a5,a4
    80000434:	4729                	li	a4,10
    80000436:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000043a:	00010797          	auipc	a5,0x10
    8000043e:	6ec7a123          	sw	a2,1762(a5) # 80010b1c <cons+0x9c>
        wakeup(&cons.r);
    80000442:	00010517          	auipc	a0,0x10
    80000446:	6d650513          	addi	a0,a0,1750 # 80010b18 <cons+0x98>
    8000044a:	21a020ef          	jal	80002664 <wakeup>
    8000044e:	b711                	j	80000352 <consoleintr+0xe0>

0000000080000450 <consoleinit>:



void
consoleinit(void)
{
    80000450:	1141                	addi	sp,sp,-16
    80000452:	e406                	sd	ra,8(sp)
    80000454:	e022                	sd	s0,0(sp)
    80000456:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000458:	00008597          	auipc	a1,0x8
    8000045c:	be058593          	addi	a1,a1,-1056 # 80008038 <etext+0x38>
    80000460:	00010517          	auipc	a0,0x10
    80000464:	62050513          	addi	a0,a0,1568 # 80010a80 <cons>
    80000468:	770000ef          	jal	80000bd8 <initlock>

  uartinit();
    8000046c:	3f4000ef          	jal	80000860 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000470:	001b9797          	auipc	a5,0x1b9
    80000474:	ad878793          	addi	a5,a5,-1320 # 801b8f48 <devsw>
    80000478:	00000717          	auipc	a4,0x0
    8000047c:	cbe70713          	addi	a4,a4,-834 # 80000136 <consoleread>
    80000480:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80000482:	00000717          	auipc	a4,0x0
    80000486:	c4e70713          	addi	a4,a4,-946 # 800000d0 <consolewrite>
    8000048a:	ef98                	sd	a4,24(a5)
}
    8000048c:	60a2                	ld	ra,8(sp)
    8000048e:	6402                	ld	s0,0(sp)
    80000490:	0141                	addi	sp,sp,16
    80000492:	8082                	ret

0000000080000494 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80000494:	7179                	addi	sp,sp,-48
    80000496:	f406                	sd	ra,40(sp)
    80000498:	f022                	sd	s0,32(sp)
    8000049a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000049c:	c219                	beqz	a2,800004a2 <printint+0xe>
    8000049e:	08054063          	bltz	a0,8000051e <printint+0x8a>
    x = -xx;
  else
    x = xx;
    800004a2:	4881                	li	a7,0
    800004a4:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004a8:	4781                	li	a5,0
  do {
    buf[i++] = digits[x % base];
    800004aa:	00008617          	auipc	a2,0x8
    800004ae:	3e660613          	addi	a2,a2,998 # 80008890 <digits>
    800004b2:	883e                	mv	a6,a5
    800004b4:	2785                	addiw	a5,a5,1
    800004b6:	02b57733          	remu	a4,a0,a1
    800004ba:	9732                	add	a4,a4,a2
    800004bc:	00074703          	lbu	a4,0(a4)
    800004c0:	00e68023          	sb	a4,0(a3)
  } while((x /= base) != 0);
    800004c4:	872a                	mv	a4,a0
    800004c6:	02b55533          	divu	a0,a0,a1
    800004ca:	0685                	addi	a3,a3,1
    800004cc:	feb773e3          	bgeu	a4,a1,800004b2 <printint+0x1e>

  if(sign)
    800004d0:	00088a63          	beqz	a7,800004e4 <printint+0x50>
    buf[i++] = '-';
    800004d4:	1781                	addi	a5,a5,-32
    800004d6:	97a2                	add	a5,a5,s0
    800004d8:	02d00713          	li	a4,45
    800004dc:	fee78823          	sb	a4,-16(a5)
    800004e0:	0028079b          	addiw	a5,a6,2

  while(--i >= 0)
    800004e4:	02f05963          	blez	a5,80000516 <printint+0x82>
    800004e8:	ec26                	sd	s1,24(sp)
    800004ea:	e84a                	sd	s2,16(sp)
    800004ec:	fd040713          	addi	a4,s0,-48
    800004f0:	00f704b3          	add	s1,a4,a5
    800004f4:	fff70913          	addi	s2,a4,-1
    800004f8:	993e                	add	s2,s2,a5
    800004fa:	37fd                	addiw	a5,a5,-1
    800004fc:	1782                	slli	a5,a5,0x20
    800004fe:	9381                	srli	a5,a5,0x20
    80000500:	40f90933          	sub	s2,s2,a5
    consputc(buf[i]);
    80000504:	fff4c503          	lbu	a0,-1(s1)
    80000508:	d39ff0ef          	jal	80000240 <consputc>
  while(--i >= 0)
    8000050c:	14fd                	addi	s1,s1,-1
    8000050e:	ff249be3          	bne	s1,s2,80000504 <printint+0x70>
    80000512:	64e2                	ld	s1,24(sp)
    80000514:	6942                	ld	s2,16(sp)
}
    80000516:	70a2                	ld	ra,40(sp)
    80000518:	7402                	ld	s0,32(sp)
    8000051a:	6145                	addi	sp,sp,48
    8000051c:	8082                	ret
    x = -xx;
    8000051e:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80000522:	4885                	li	a7,1
    x = -xx;
    80000524:	b741                	j	800004a4 <printint+0x10>

0000000080000526 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    80000526:	7155                	addi	sp,sp,-208
    80000528:	e506                	sd	ra,136(sp)
    8000052a:	e122                	sd	s0,128(sp)
    8000052c:	f0d2                	sd	s4,96(sp)
    8000052e:	0900                	addi	s0,sp,144
    80000530:	8a2a                	mv	s4,a0
    80000532:	e40c                	sd	a1,8(s0)
    80000534:	e810                	sd	a2,16(s0)
    80000536:	ec14                	sd	a3,24(s0)
    80000538:	f018                	sd	a4,32(s0)
    8000053a:	f41c                	sd	a5,40(s0)
    8000053c:	03043823          	sd	a6,48(s0)
    80000540:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2, locking;
  char *s;

  locking = pr.locking;
    80000544:	00010797          	auipc	a5,0x10
    80000548:	5fc7a783          	lw	a5,1532(a5) # 80010b40 <pr+0x18>
    8000054c:	f6f43c23          	sd	a5,-136(s0)
  if(locking)
    80000550:	e3a1                	bnez	a5,80000590 <printf+0x6a>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80000552:	00840793          	addi	a5,s0,8
    80000556:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000055a:	00054503          	lbu	a0,0(a0)
    8000055e:	26050763          	beqz	a0,800007cc <printf+0x2a6>
    80000562:	fca6                	sd	s1,120(sp)
    80000564:	f8ca                	sd	s2,112(sp)
    80000566:	f4ce                	sd	s3,104(sp)
    80000568:	ecd6                	sd	s5,88(sp)
    8000056a:	e8da                	sd	s6,80(sp)
    8000056c:	e0e2                	sd	s8,64(sp)
    8000056e:	fc66                	sd	s9,56(sp)
    80000570:	f86a                	sd	s10,48(sp)
    80000572:	f46e                	sd	s11,40(sp)
    80000574:	4981                	li	s3,0
    if(cx != '%'){
    80000576:	02500a93          	li	s5,37
    i++;
    c0 = fmt[i+0] & 0xff;
    c1 = c2 = 0;
    if(c0) c1 = fmt[i+1] & 0xff;
    if(c1) c2 = fmt[i+2] & 0xff;
    if(c0 == 'd'){
    8000057a:	06400b13          	li	s6,100
      printint(va_arg(ap, int), 10, 1);
    } else if(c0 == 'l' && c1 == 'd'){
    8000057e:	06c00c13          	li	s8,108
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80000582:	07500c93          	li	s9,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80000586:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    8000058a:	07000d93          	li	s11,112
    8000058e:	a815                	j	800005c2 <printf+0x9c>
    acquire(&pr.lock);
    80000590:	00010517          	auipc	a0,0x10
    80000594:	59850513          	addi	a0,a0,1432 # 80010b28 <pr>
    80000598:	6c0000ef          	jal	80000c58 <acquire>
  va_start(ap, fmt);
    8000059c:	00840793          	addi	a5,s0,8
    800005a0:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800005a4:	000a4503          	lbu	a0,0(s4)
    800005a8:	fd4d                	bnez	a0,80000562 <printf+0x3c>
    800005aa:	a481                	j	800007ea <printf+0x2c4>
      consputc(cx);
    800005ac:	c95ff0ef          	jal	80000240 <consputc>
      continue;
    800005b0:	84ce                	mv	s1,s3
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800005b2:	0014899b          	addiw	s3,s1,1
    800005b6:	013a07b3          	add	a5,s4,s3
    800005ba:	0007c503          	lbu	a0,0(a5)
    800005be:	1e050b63          	beqz	a0,800007b4 <printf+0x28e>
    if(cx != '%'){
    800005c2:	ff5515e3          	bne	a0,s5,800005ac <printf+0x86>
    i++;
    800005c6:	0019849b          	addiw	s1,s3,1
    c0 = fmt[i+0] & 0xff;
    800005ca:	009a07b3          	add	a5,s4,s1
    800005ce:	0007c903          	lbu	s2,0(a5)
    if(c0) c1 = fmt[i+1] & 0xff;
    800005d2:	1e090163          	beqz	s2,800007b4 <printf+0x28e>
    800005d6:	0017c783          	lbu	a5,1(a5)
    c1 = c2 = 0;
    800005da:	86be                	mv	a3,a5
    if(c1) c2 = fmt[i+2] & 0xff;
    800005dc:	c789                	beqz	a5,800005e6 <printf+0xc0>
    800005de:	009a0733          	add	a4,s4,s1
    800005e2:	00274683          	lbu	a3,2(a4)
    if(c0 == 'd'){
    800005e6:	03690763          	beq	s2,s6,80000614 <printf+0xee>
    } else if(c0 == 'l' && c1 == 'd'){
    800005ea:	05890163          	beq	s2,s8,8000062c <printf+0x106>
    } else if(c0 == 'u'){
    800005ee:	0d990b63          	beq	s2,s9,800006c4 <printf+0x19e>
    } else if(c0 == 'x'){
    800005f2:	13a90163          	beq	s2,s10,80000714 <printf+0x1ee>
    } else if(c0 == 'p'){
    800005f6:	13b90b63          	beq	s2,s11,8000072c <printf+0x206>
      printptr(va_arg(ap, uint64));
    } else if(c0 == 's'){
    800005fa:	07300793          	li	a5,115
    800005fe:	16f90a63          	beq	s2,a5,80000772 <printf+0x24c>
      if((s = va_arg(ap, char*)) == 0)
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
    } else if(c0 == '%'){
    80000602:	1b590463          	beq	s2,s5,800007aa <printf+0x284>
      consputc('%');
    } else if(c0 == 0){
      break;
    } else {
      // Print unknown % sequence to draw attention.
      consputc('%');
    80000606:	8556                	mv	a0,s5
    80000608:	c39ff0ef          	jal	80000240 <consputc>
      consputc(c0);
    8000060c:	854a                	mv	a0,s2
    8000060e:	c33ff0ef          	jal	80000240 <consputc>
    80000612:	b745                	j	800005b2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 1);
    80000614:	f8843783          	ld	a5,-120(s0)
    80000618:	00878713          	addi	a4,a5,8
    8000061c:	f8e43423          	sd	a4,-120(s0)
    80000620:	4605                	li	a2,1
    80000622:	45a9                	li	a1,10
    80000624:	4388                	lw	a0,0(a5)
    80000626:	e6fff0ef          	jal	80000494 <printint>
    8000062a:	b761                	j	800005b2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'd'){
    8000062c:	03678663          	beq	a5,s6,80000658 <printf+0x132>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000630:	05878263          	beq	a5,s8,80000674 <printf+0x14e>
    } else if(c0 == 'l' && c1 == 'u'){
    80000634:	0b978463          	beq	a5,s9,800006dc <printf+0x1b6>
    } else if(c0 == 'l' && c1 == 'x'){
    80000638:	fda797e3          	bne	a5,s10,80000606 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    8000063c:	f8843783          	ld	a5,-120(s0)
    80000640:	00878713          	addi	a4,a5,8
    80000644:	f8e43423          	sd	a4,-120(s0)
    80000648:	4601                	li	a2,0
    8000064a:	45c1                	li	a1,16
    8000064c:	6388                	ld	a0,0(a5)
    8000064e:	e47ff0ef          	jal	80000494 <printint>
      i += 1;
    80000652:	0029849b          	addiw	s1,s3,2
    80000656:	bfb1                	j	800005b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    80000658:	f8843783          	ld	a5,-120(s0)
    8000065c:	00878713          	addi	a4,a5,8
    80000660:	f8e43423          	sd	a4,-120(s0)
    80000664:	4605                	li	a2,1
    80000666:	45a9                	li	a1,10
    80000668:	6388                	ld	a0,0(a5)
    8000066a:	e2bff0ef          	jal	80000494 <printint>
      i += 1;
    8000066e:	0029849b          	addiw	s1,s3,2
    80000672:	b781                	j	800005b2 <printf+0x8c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80000674:	06400793          	li	a5,100
    80000678:	02f68863          	beq	a3,a5,800006a8 <printf+0x182>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    8000067c:	07500793          	li	a5,117
    80000680:	06f68c63          	beq	a3,a5,800006f8 <printf+0x1d2>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80000684:	07800793          	li	a5,120
    80000688:	f6f69fe3          	bne	a3,a5,80000606 <printf+0xe0>
      printint(va_arg(ap, uint64), 16, 0);
    8000068c:	f8843783          	ld	a5,-120(s0)
    80000690:	00878713          	addi	a4,a5,8
    80000694:	f8e43423          	sd	a4,-120(s0)
    80000698:	4601                	li	a2,0
    8000069a:	45c1                	li	a1,16
    8000069c:	6388                	ld	a0,0(a5)
    8000069e:	df7ff0ef          	jal	80000494 <printint>
      i += 2;
    800006a2:	0039849b          	addiw	s1,s3,3
    800006a6:	b731                	j	800005b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 1);
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	4605                	li	a2,1
    800006b6:	45a9                	li	a1,10
    800006b8:	6388                	ld	a0,0(a5)
    800006ba:	ddbff0ef          	jal	80000494 <printint>
      i += 2;
    800006be:	0039849b          	addiw	s1,s3,3
    800006c2:	bdc5                	j	800005b2 <printf+0x8c>
      printint(va_arg(ap, int), 10, 0);
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	addi	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	4601                	li	a2,0
    800006d2:	45a9                	li	a1,10
    800006d4:	4388                	lw	a0,0(a5)
    800006d6:	dbfff0ef          	jal	80000494 <printint>
    800006da:	bde1                	j	800005b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800006dc:	f8843783          	ld	a5,-120(s0)
    800006e0:	00878713          	addi	a4,a5,8
    800006e4:	f8e43423          	sd	a4,-120(s0)
    800006e8:	4601                	li	a2,0
    800006ea:	45a9                	li	a1,10
    800006ec:	6388                	ld	a0,0(a5)
    800006ee:	da7ff0ef          	jal	80000494 <printint>
      i += 1;
    800006f2:	0029849b          	addiw	s1,s3,2
    800006f6:	bd75                	j	800005b2 <printf+0x8c>
      printint(va_arg(ap, uint64), 10, 0);
    800006f8:	f8843783          	ld	a5,-120(s0)
    800006fc:	00878713          	addi	a4,a5,8
    80000700:	f8e43423          	sd	a4,-120(s0)
    80000704:	4601                	li	a2,0
    80000706:	45a9                	li	a1,10
    80000708:	6388                	ld	a0,0(a5)
    8000070a:	d8bff0ef          	jal	80000494 <printint>
      i += 2;
    8000070e:	0039849b          	addiw	s1,s3,3
    80000712:	b545                	j	800005b2 <printf+0x8c>
      printint(va_arg(ap, int), 16, 0);
    80000714:	f8843783          	ld	a5,-120(s0)
    80000718:	00878713          	addi	a4,a5,8
    8000071c:	f8e43423          	sd	a4,-120(s0)
    80000720:	4601                	li	a2,0
    80000722:	45c1                	li	a1,16
    80000724:	4388                	lw	a0,0(a5)
    80000726:	d6fff0ef          	jal	80000494 <printint>
    8000072a:	b561                	j	800005b2 <printf+0x8c>
    8000072c:	e4de                	sd	s7,72(sp)
      printptr(va_arg(ap, uint64));
    8000072e:	f8843783          	ld	a5,-120(s0)
    80000732:	00878713          	addi	a4,a5,8
    80000736:	f8e43423          	sd	a4,-120(s0)
    8000073a:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000073e:	03000513          	li	a0,48
    80000742:	affff0ef          	jal	80000240 <consputc>
  consputc('x');
    80000746:	07800513          	li	a0,120
    8000074a:	af7ff0ef          	jal	80000240 <consputc>
    8000074e:	4941                	li	s2,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000750:	00008b97          	auipc	s7,0x8
    80000754:	140b8b93          	addi	s7,s7,320 # 80008890 <digits>
    80000758:	03c9d793          	srli	a5,s3,0x3c
    8000075c:	97de                	add	a5,a5,s7
    8000075e:	0007c503          	lbu	a0,0(a5)
    80000762:	adfff0ef          	jal	80000240 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000766:	0992                	slli	s3,s3,0x4
    80000768:	397d                	addiw	s2,s2,-1
    8000076a:	fe0917e3          	bnez	s2,80000758 <printf+0x232>
    8000076e:	6ba6                	ld	s7,72(sp)
    80000770:	b589                	j	800005b2 <printf+0x8c>
      if((s = va_arg(ap, char*)) == 0)
    80000772:	f8843783          	ld	a5,-120(s0)
    80000776:	00878713          	addi	a4,a5,8
    8000077a:	f8e43423          	sd	a4,-120(s0)
    8000077e:	0007b903          	ld	s2,0(a5)
    80000782:	00090d63          	beqz	s2,8000079c <printf+0x276>
      for(; *s; s++)
    80000786:	00094503          	lbu	a0,0(s2)
    8000078a:	e20504e3          	beqz	a0,800005b2 <printf+0x8c>
        consputc(*s);
    8000078e:	ab3ff0ef          	jal	80000240 <consputc>
      for(; *s; s++)
    80000792:	0905                	addi	s2,s2,1
    80000794:	00094503          	lbu	a0,0(s2)
    80000798:	f97d                	bnez	a0,8000078e <printf+0x268>
    8000079a:	bd21                	j	800005b2 <printf+0x8c>
        s = "(null)";
    8000079c:	00008917          	auipc	s2,0x8
    800007a0:	8a490913          	addi	s2,s2,-1884 # 80008040 <etext+0x40>
      for(; *s; s++)
    800007a4:	02800513          	li	a0,40
    800007a8:	b7dd                	j	8000078e <printf+0x268>
      consputc('%');
    800007aa:	02500513          	li	a0,37
    800007ae:	a93ff0ef          	jal	80000240 <consputc>
    800007b2:	b501                	j	800005b2 <printf+0x8c>
    }
#endif
  }
  va_end(ap);

  if(locking)
    800007b4:	f7843783          	ld	a5,-136(s0)
    800007b8:	e385                	bnez	a5,800007d8 <printf+0x2b2>
    800007ba:	74e6                	ld	s1,120(sp)
    800007bc:	7946                	ld	s2,112(sp)
    800007be:	79a6                	ld	s3,104(sp)
    800007c0:	6ae6                	ld	s5,88(sp)
    800007c2:	6b46                	ld	s6,80(sp)
    800007c4:	6c06                	ld	s8,64(sp)
    800007c6:	7ce2                	ld	s9,56(sp)
    800007c8:	7d42                	ld	s10,48(sp)
    800007ca:	7da2                	ld	s11,40(sp)
    release(&pr.lock);

  return 0;
}
    800007cc:	4501                	li	a0,0
    800007ce:	60aa                	ld	ra,136(sp)
    800007d0:	640a                	ld	s0,128(sp)
    800007d2:	7a06                	ld	s4,96(sp)
    800007d4:	6169                	addi	sp,sp,208
    800007d6:	8082                	ret
    800007d8:	74e6                	ld	s1,120(sp)
    800007da:	7946                	ld	s2,112(sp)
    800007dc:	79a6                	ld	s3,104(sp)
    800007de:	6ae6                	ld	s5,88(sp)
    800007e0:	6b46                	ld	s6,80(sp)
    800007e2:	6c06                	ld	s8,64(sp)
    800007e4:	7ce2                	ld	s9,56(sp)
    800007e6:	7d42                	ld	s10,48(sp)
    800007e8:	7da2                	ld	s11,40(sp)
    release(&pr.lock);
    800007ea:	00010517          	auipc	a0,0x10
    800007ee:	33e50513          	addi	a0,a0,830 # 80010b28 <pr>
    800007f2:	4fe000ef          	jal	80000cf0 <release>
    800007f6:	bfd9                	j	800007cc <printf+0x2a6>

00000000800007f8 <panic>:

void
panic(char *s)
{
    800007f8:	1101                	addi	sp,sp,-32
    800007fa:	ec06                	sd	ra,24(sp)
    800007fc:	e822                	sd	s0,16(sp)
    800007fe:	e426                	sd	s1,8(sp)
    80000800:	1000                	addi	s0,sp,32
    80000802:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000804:	00010797          	auipc	a5,0x10
    80000808:	3207ae23          	sw	zero,828(a5) # 80010b40 <pr+0x18>
  printf("panic: ");
    8000080c:	00008517          	auipc	a0,0x8
    80000810:	83c50513          	addi	a0,a0,-1988 # 80008048 <etext+0x48>
    80000814:	d13ff0ef          	jal	80000526 <printf>
  printf("%s\n", s);
    80000818:	85a6                	mv	a1,s1
    8000081a:	00008517          	auipc	a0,0x8
    8000081e:	83650513          	addi	a0,a0,-1994 # 80008050 <etext+0x50>
    80000822:	d05ff0ef          	jal	80000526 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80000826:	4785                	li	a5,1
    80000828:	00008717          	auipc	a4,0x8
    8000082c:	20f72c23          	sw	a5,536(a4) # 80008a40 <panicked>
  for(;;)
    80000830:	a001                	j	80000830 <panic+0x38>

0000000080000832 <printfinit>:
    ;
}

void
printfinit(void)
{
    80000832:	1101                	addi	sp,sp,-32
    80000834:	ec06                	sd	ra,24(sp)
    80000836:	e822                	sd	s0,16(sp)
    80000838:	e426                	sd	s1,8(sp)
    8000083a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000083c:	00010497          	auipc	s1,0x10
    80000840:	2ec48493          	addi	s1,s1,748 # 80010b28 <pr>
    80000844:	00008597          	auipc	a1,0x8
    80000848:	81458593          	addi	a1,a1,-2028 # 80008058 <etext+0x58>
    8000084c:	8526                	mv	a0,s1
    8000084e:	38a000ef          	jal	80000bd8 <initlock>
  pr.locking = 1;
    80000852:	4785                	li	a5,1
    80000854:	cc9c                	sw	a5,24(s1)
}
    80000856:	60e2                	ld	ra,24(sp)
    80000858:	6442                	ld	s0,16(sp)
    8000085a:	64a2                	ld	s1,8(sp)
    8000085c:	6105                	addi	sp,sp,32
    8000085e:	8082                	ret

0000000080000860 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80000860:	1141                	addi	sp,sp,-16
    80000862:	e406                	sd	ra,8(sp)
    80000864:	e022                	sd	s0,0(sp)
    80000866:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000868:	100007b7          	lui	a5,0x10000
    8000086c:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80000870:	10000737          	lui	a4,0x10000
    80000874:	f8000693          	li	a3,-128
    80000878:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000087c:	468d                	li	a3,3
    8000087e:	10000637          	lui	a2,0x10000
    80000882:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000886:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    8000088a:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000088e:	10000737          	lui	a4,0x10000
    80000892:	461d                	li	a2,7
    80000894:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000898:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    8000089c:	00007597          	auipc	a1,0x7
    800008a0:	7c458593          	addi	a1,a1,1988 # 80008060 <etext+0x60>
    800008a4:	00010517          	auipc	a0,0x10
    800008a8:	2a450513          	addi	a0,a0,676 # 80010b48 <uart_tx_lock>
    800008ac:	32c000ef          	jal	80000bd8 <initlock>
}
    800008b0:	60a2                	ld	ra,8(sp)
    800008b2:	6402                	ld	s0,0(sp)
    800008b4:	0141                	addi	sp,sp,16
    800008b6:	8082                	ret

00000000800008b8 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800008b8:	1101                	addi	sp,sp,-32
    800008ba:	ec06                	sd	ra,24(sp)
    800008bc:	e822                	sd	s0,16(sp)
    800008be:	e426                	sd	s1,8(sp)
    800008c0:	1000                	addi	s0,sp,32
    800008c2:	84aa                	mv	s1,a0
  push_off();
    800008c4:	354000ef          	jal	80000c18 <push_off>

  if(panicked){
    800008c8:	00008797          	auipc	a5,0x8
    800008cc:	1787a783          	lw	a5,376(a5) # 80008a40 <panicked>
    800008d0:	e795                	bnez	a5,800008fc <uartputc_sync+0x44>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800008d2:	10000737          	lui	a4,0x10000
    800008d6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800008d8:	00074783          	lbu	a5,0(a4)
    800008dc:	0207f793          	andi	a5,a5,32
    800008e0:	dfe5                	beqz	a5,800008d8 <uartputc_sync+0x20>
    ;
  WriteReg(THR, c);
    800008e2:	0ff4f513          	zext.b	a0,s1
    800008e6:	100007b7          	lui	a5,0x10000
    800008ea:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800008ee:	3ae000ef          	jal	80000c9c <pop_off>
}
    800008f2:	60e2                	ld	ra,24(sp)
    800008f4:	6442                	ld	s0,16(sp)
    800008f6:	64a2                	ld	s1,8(sp)
    800008f8:	6105                	addi	sp,sp,32
    800008fa:	8082                	ret
    for(;;)
    800008fc:	a001                	j	800008fc <uartputc_sync+0x44>

00000000800008fe <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008fe:	00008797          	auipc	a5,0x8
    80000902:	14a7b783          	ld	a5,330(a5) # 80008a48 <uart_tx_r>
    80000906:	00008717          	auipc	a4,0x8
    8000090a:	14a73703          	ld	a4,330(a4) # 80008a50 <uart_tx_w>
    8000090e:	08f70263          	beq	a4,a5,80000992 <uartstart+0x94>
{
    80000912:	7139                	addi	sp,sp,-64
    80000914:	fc06                	sd	ra,56(sp)
    80000916:	f822                	sd	s0,48(sp)
    80000918:	f426                	sd	s1,40(sp)
    8000091a:	f04a                	sd	s2,32(sp)
    8000091c:	ec4e                	sd	s3,24(sp)
    8000091e:	e852                	sd	s4,16(sp)
    80000920:	e456                	sd	s5,8(sp)
    80000922:	e05a                	sd	s6,0(sp)
    80000924:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      ReadReg(ISR);
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000926:	10000937          	lui	s2,0x10000
    8000092a:	0915                	addi	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000092c:	00010a97          	auipc	s5,0x10
    80000930:	21ca8a93          	addi	s5,s5,540 # 80010b48 <uart_tx_lock>
    uart_tx_r += 1;
    80000934:	00008497          	auipc	s1,0x8
    80000938:	11448493          	addi	s1,s1,276 # 80008a48 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    8000093c:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80000940:	00008997          	auipc	s3,0x8
    80000944:	11098993          	addi	s3,s3,272 # 80008a50 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80000948:	00094703          	lbu	a4,0(s2)
    8000094c:	02077713          	andi	a4,a4,32
    80000950:	c71d                	beqz	a4,8000097e <uartstart+0x80>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000952:	01f7f713          	andi	a4,a5,31
    80000956:	9756                	add	a4,a4,s5
    80000958:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    8000095c:	0785                	addi	a5,a5,1
    8000095e:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000960:	8526                	mv	a0,s1
    80000962:	503010ef          	jal	80002664 <wakeup>
    WriteReg(THR, c);
    80000966:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    8000096a:	609c                	ld	a5,0(s1)
    8000096c:	0009b703          	ld	a4,0(s3)
    80000970:	fcf71ce3          	bne	a4,a5,80000948 <uartstart+0x4a>
      ReadReg(ISR);
    80000974:	100007b7          	lui	a5,0x10000
    80000978:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    8000097a:	0007c783          	lbu	a5,0(a5)
  }
}
    8000097e:	70e2                	ld	ra,56(sp)
    80000980:	7442                	ld	s0,48(sp)
    80000982:	74a2                	ld	s1,40(sp)
    80000984:	7902                	ld	s2,32(sp)
    80000986:	69e2                	ld	s3,24(sp)
    80000988:	6a42                	ld	s4,16(sp)
    8000098a:	6aa2                	ld	s5,8(sp)
    8000098c:	6b02                	ld	s6,0(sp)
    8000098e:	6121                	addi	sp,sp,64
    80000990:	8082                	ret
      ReadReg(ISR);
    80000992:	100007b7          	lui	a5,0x10000
    80000996:	0789                	addi	a5,a5,2 # 10000002 <_entry-0x6ffffffe>
    80000998:	0007c783          	lbu	a5,0(a5)
      return;
    8000099c:	8082                	ret

000000008000099e <uartputc>:
{
    8000099e:	7179                	addi	sp,sp,-48
    800009a0:	f406                	sd	ra,40(sp)
    800009a2:	f022                	sd	s0,32(sp)
    800009a4:	ec26                	sd	s1,24(sp)
    800009a6:	e84a                	sd	s2,16(sp)
    800009a8:	e44e                	sd	s3,8(sp)
    800009aa:	e052                	sd	s4,0(sp)
    800009ac:	1800                	addi	s0,sp,48
    800009ae:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    800009b0:	00010517          	auipc	a0,0x10
    800009b4:	19850513          	addi	a0,a0,408 # 80010b48 <uart_tx_lock>
    800009b8:	2a0000ef          	jal	80000c58 <acquire>
  if(panicked){
    800009bc:	00008797          	auipc	a5,0x8
    800009c0:	0847a783          	lw	a5,132(a5) # 80008a40 <panicked>
    800009c4:	efbd                	bnez	a5,80000a42 <uartputc+0xa4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009c6:	00008717          	auipc	a4,0x8
    800009ca:	08a73703          	ld	a4,138(a4) # 80008a50 <uart_tx_w>
    800009ce:	00008797          	auipc	a5,0x8
    800009d2:	07a7b783          	ld	a5,122(a5) # 80008a48 <uart_tx_r>
    800009d6:	02078793          	addi	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800009da:	00010997          	auipc	s3,0x10
    800009de:	16e98993          	addi	s3,s3,366 # 80010b48 <uart_tx_lock>
    800009e2:	00008497          	auipc	s1,0x8
    800009e6:	06648493          	addi	s1,s1,102 # 80008a48 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009ea:	00008917          	auipc	s2,0x8
    800009ee:	06690913          	addi	s2,s2,102 # 80008a50 <uart_tx_w>
    800009f2:	00e79d63          	bne	a5,a4,80000a0c <uartputc+0x6e>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009f6:	85ce                	mv	a1,s3
    800009f8:	8526                	mv	a0,s1
    800009fa:	41f010ef          	jal	80002618 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009fe:	00093703          	ld	a4,0(s2)
    80000a02:	609c                	ld	a5,0(s1)
    80000a04:	02078793          	addi	a5,a5,32
    80000a08:	fee787e3          	beq	a5,a4,800009f6 <uartputc+0x58>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80000a0c:	00010497          	auipc	s1,0x10
    80000a10:	13c48493          	addi	s1,s1,316 # 80010b48 <uart_tx_lock>
    80000a14:	01f77793          	andi	a5,a4,31
    80000a18:	97a6                	add	a5,a5,s1
    80000a1a:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    80000a1e:	0705                	addi	a4,a4,1
    80000a20:	00008797          	auipc	a5,0x8
    80000a24:	02e7b823          	sd	a4,48(a5) # 80008a50 <uart_tx_w>
  uartstart();
    80000a28:	ed7ff0ef          	jal	800008fe <uartstart>
  release(&uart_tx_lock);
    80000a2c:	8526                	mv	a0,s1
    80000a2e:	2c2000ef          	jal	80000cf0 <release>
}
    80000a32:	70a2                	ld	ra,40(sp)
    80000a34:	7402                	ld	s0,32(sp)
    80000a36:	64e2                	ld	s1,24(sp)
    80000a38:	6942                	ld	s2,16(sp)
    80000a3a:	69a2                	ld	s3,8(sp)
    80000a3c:	6a02                	ld	s4,0(sp)
    80000a3e:	6145                	addi	sp,sp,48
    80000a40:	8082                	ret
    for(;;)
    80000a42:	a001                	j	80000a42 <uartputc+0xa4>

0000000080000a44 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000a44:	1141                	addi	sp,sp,-16
    80000a46:	e422                	sd	s0,8(sp)
    80000a48:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a4a:	100007b7          	lui	a5,0x10000
    80000a4e:	0795                	addi	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000a50:	0007c783          	lbu	a5,0(a5)
    80000a54:	8b85                	andi	a5,a5,1
    80000a56:	cb81                	beqz	a5,80000a66 <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80000a58:	100007b7          	lui	a5,0x10000
    80000a5c:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a60:	6422                	ld	s0,8(sp)
    80000a62:	0141                	addi	sp,sp,16
    80000a64:	8082                	ret
    return -1;
    80000a66:	557d                	li	a0,-1
    80000a68:	bfe5                	j	80000a60 <uartgetc+0x1c>

0000000080000a6a <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a6a:	1101                	addi	sp,sp,-32
    80000a6c:	ec06                	sd	ra,24(sp)
    80000a6e:	e822                	sd	s0,16(sp)
    80000a70:	e426                	sd	s1,8(sp)
    80000a72:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a74:	54fd                	li	s1,-1
    80000a76:	a019                	j	80000a7c <uartintr+0x12>
      break;
    consoleintr(c);
    80000a78:	ffaff0ef          	jal	80000272 <consoleintr>
    int c = uartgetc();
    80000a7c:	fc9ff0ef          	jal	80000a44 <uartgetc>
    if(c == -1)
    80000a80:	fe951ce3          	bne	a0,s1,80000a78 <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a84:	00010497          	auipc	s1,0x10
    80000a88:	0c448493          	addi	s1,s1,196 # 80010b48 <uart_tx_lock>
    80000a8c:	8526                	mv	a0,s1
    80000a8e:	1ca000ef          	jal	80000c58 <acquire>
  uartstart();
    80000a92:	e6dff0ef          	jal	800008fe <uartstart>
  release(&uart_tx_lock);
    80000a96:	8526                	mv	a0,s1
    80000a98:	258000ef          	jal	80000cf0 <release>
}
    80000a9c:	60e2                	ld	ra,24(sp)
    80000a9e:	6442                	ld	s0,16(sp)
    80000aa0:	64a2                	ld	s1,8(sp)
    80000aa2:	6105                	addi	sp,sp,32
    80000aa4:	8082                	ret

0000000080000aa6 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000aa6:	1101                	addi	sp,sp,-32
    80000aa8:	ec06                	sd	ra,24(sp)
    80000aaa:	e822                	sd	s0,16(sp)
    80000aac:	e426                	sd	s1,8(sp)
    80000aae:	e04a                	sd	s2,0(sp)
    80000ab0:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000ab2:	03451793          	slli	a5,a0,0x34
    80000ab6:	e7a9                	bnez	a5,80000b00 <kfree+0x5a>
    80000ab8:	84aa                	mv	s1,a0
    80000aba:	001b9797          	auipc	a5,0x1b9
    80000abe:	62678793          	addi	a5,a5,1574 # 801ba0e0 <end>
    80000ac2:	02f56f63          	bltu	a0,a5,80000b00 <kfree+0x5a>
    80000ac6:	47c5                	li	a5,17
    80000ac8:	07ee                	slli	a5,a5,0x1b
    80000aca:	02f57b63          	bgeu	a0,a5,80000b00 <kfree+0x5a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000ace:	6605                	lui	a2,0x1
    80000ad0:	4585                	li	a1,1
    80000ad2:	25a000ef          	jal	80000d2c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000ad6:	00010917          	auipc	s2,0x10
    80000ada:	0aa90913          	addi	s2,s2,170 # 80010b80 <kmem>
    80000ade:	854a                	mv	a0,s2
    80000ae0:	178000ef          	jal	80000c58 <acquire>
  r->next = kmem.freelist;
    80000ae4:	01893783          	ld	a5,24(s2)
    80000ae8:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aea:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aee:	854a                	mv	a0,s2
    80000af0:	200000ef          	jal	80000cf0 <release>
}
    80000af4:	60e2                	ld	ra,24(sp)
    80000af6:	6442                	ld	s0,16(sp)
    80000af8:	64a2                	ld	s1,8(sp)
    80000afa:	6902                	ld	s2,0(sp)
    80000afc:	6105                	addi	sp,sp,32
    80000afe:	8082                	ret
    panic("kfree");
    80000b00:	00007517          	auipc	a0,0x7
    80000b04:	56850513          	addi	a0,a0,1384 # 80008068 <etext+0x68>
    80000b08:	cf1ff0ef          	jal	800007f8 <panic>

0000000080000b0c <freerange>:
{
    80000b0c:	7179                	addi	sp,sp,-48
    80000b0e:	f406                	sd	ra,40(sp)
    80000b10:	f022                	sd	s0,32(sp)
    80000b12:	ec26                	sd	s1,24(sp)
    80000b14:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000b16:	6785                	lui	a5,0x1
    80000b18:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000b1c:	00e504b3          	add	s1,a0,a4
    80000b20:	777d                	lui	a4,0xfffff
    80000b22:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b24:	94be                	add	s1,s1,a5
    80000b26:	0295e263          	bltu	a1,s1,80000b4a <freerange+0x3e>
    80000b2a:	e84a                	sd	s2,16(sp)
    80000b2c:	e44e                	sd	s3,8(sp)
    80000b2e:	e052                	sd	s4,0(sp)
    80000b30:	892e                	mv	s2,a1
    kfree(p);
    80000b32:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b34:	6985                	lui	s3,0x1
    kfree(p);
    80000b36:	01448533          	add	a0,s1,s4
    80000b3a:	f6dff0ef          	jal	80000aa6 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000b3e:	94ce                	add	s1,s1,s3
    80000b40:	fe997be3          	bgeu	s2,s1,80000b36 <freerange+0x2a>
    80000b44:	6942                	ld	s2,16(sp)
    80000b46:	69a2                	ld	s3,8(sp)
    80000b48:	6a02                	ld	s4,0(sp)
}
    80000b4a:	70a2                	ld	ra,40(sp)
    80000b4c:	7402                	ld	s0,32(sp)
    80000b4e:	64e2                	ld	s1,24(sp)
    80000b50:	6145                	addi	sp,sp,48
    80000b52:	8082                	ret

0000000080000b54 <kinit>:
{
    80000b54:	1141                	addi	sp,sp,-16
    80000b56:	e406                	sd	ra,8(sp)
    80000b58:	e022                	sd	s0,0(sp)
    80000b5a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b5c:	00007597          	auipc	a1,0x7
    80000b60:	51458593          	addi	a1,a1,1300 # 80008070 <etext+0x70>
    80000b64:	00010517          	auipc	a0,0x10
    80000b68:	01c50513          	addi	a0,a0,28 # 80010b80 <kmem>
    80000b6c:	06c000ef          	jal	80000bd8 <initlock>
  freerange(end, (void*)PHYSTOP);
    80000b70:	45c5                	li	a1,17
    80000b72:	05ee                	slli	a1,a1,0x1b
    80000b74:	001b9517          	auipc	a0,0x1b9
    80000b78:	56c50513          	addi	a0,a0,1388 # 801ba0e0 <end>
    80000b7c:	f91ff0ef          	jal	80000b0c <freerange>
}
    80000b80:	60a2                	ld	ra,8(sp)
    80000b82:	6402                	ld	s0,0(sp)
    80000b84:	0141                	addi	sp,sp,16
    80000b86:	8082                	ret

0000000080000b88 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b88:	1101                	addi	sp,sp,-32
    80000b8a:	ec06                	sd	ra,24(sp)
    80000b8c:	e822                	sd	s0,16(sp)
    80000b8e:	e426                	sd	s1,8(sp)
    80000b90:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b92:	00010497          	auipc	s1,0x10
    80000b96:	fee48493          	addi	s1,s1,-18 # 80010b80 <kmem>
    80000b9a:	8526                	mv	a0,s1
    80000b9c:	0bc000ef          	jal	80000c58 <acquire>
  r = kmem.freelist;
    80000ba0:	6c84                	ld	s1,24(s1)
  if(r)
    80000ba2:	c485                	beqz	s1,80000bca <kalloc+0x42>
    kmem.freelist = r->next;
    80000ba4:	609c                	ld	a5,0(s1)
    80000ba6:	00010517          	auipc	a0,0x10
    80000baa:	fda50513          	addi	a0,a0,-38 # 80010b80 <kmem>
    80000bae:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000bb0:	140000ef          	jal	80000cf0 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000bb4:	6605                	lui	a2,0x1
    80000bb6:	4595                	li	a1,5
    80000bb8:	8526                	mv	a0,s1
    80000bba:	172000ef          	jal	80000d2c <memset>
  return (void*)r;
}
    80000bbe:	8526                	mv	a0,s1
    80000bc0:	60e2                	ld	ra,24(sp)
    80000bc2:	6442                	ld	s0,16(sp)
    80000bc4:	64a2                	ld	s1,8(sp)
    80000bc6:	6105                	addi	sp,sp,32
    80000bc8:	8082                	ret
  release(&kmem.lock);
    80000bca:	00010517          	auipc	a0,0x10
    80000bce:	fb650513          	addi	a0,a0,-74 # 80010b80 <kmem>
    80000bd2:	11e000ef          	jal	80000cf0 <release>
  if(r)
    80000bd6:	b7e5                	j	80000bbe <kalloc+0x36>

0000000080000bd8 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000bd8:	1141                	addi	sp,sp,-16
    80000bda:	e422                	sd	s0,8(sp)
    80000bdc:	0800                	addi	s0,sp,16
  lk->name = name;
    80000bde:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000be0:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000be4:	00053823          	sd	zero,16(a0)
}
    80000be8:	6422                	ld	s0,8(sp)
    80000bea:	0141                	addi	sp,sp,16
    80000bec:	8082                	ret

0000000080000bee <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bee:	411c                	lw	a5,0(a0)
    80000bf0:	e399                	bnez	a5,80000bf6 <holding+0x8>
    80000bf2:	4501                	li	a0,0
  return r;
}
    80000bf4:	8082                	ret
{
    80000bf6:	1101                	addi	sp,sp,-32
    80000bf8:	ec06                	sd	ra,24(sp)
    80000bfa:	e822                	sd	s0,16(sp)
    80000bfc:	e426                	sd	s1,8(sp)
    80000bfe:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000c00:	6904                	ld	s1,16(a0)
    80000c02:	410010ef          	jal	80002012 <mycpu>
    80000c06:	40a48533          	sub	a0,s1,a0
    80000c0a:	00153513          	seqz	a0,a0
}
    80000c0e:	60e2                	ld	ra,24(sp)
    80000c10:	6442                	ld	s0,16(sp)
    80000c12:	64a2                	ld	s1,8(sp)
    80000c14:	6105                	addi	sp,sp,32
    80000c16:	8082                	ret

0000000080000c18 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000c18:	1101                	addi	sp,sp,-32
    80000c1a:	ec06                	sd	ra,24(sp)
    80000c1c:	e822                	sd	s0,16(sp)
    80000c1e:	e426                	sd	s1,8(sp)
    80000c20:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000c22:	100024f3          	csrr	s1,sstatus
    80000c26:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000c2a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000c2c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80000c30:	3e2010ef          	jal	80002012 <mycpu>
    80000c34:	5d3c                	lw	a5,120(a0)
    80000c36:	cb99                	beqz	a5,80000c4c <push_off+0x34>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000c38:	3da010ef          	jal	80002012 <mycpu>
    80000c3c:	5d3c                	lw	a5,120(a0)
    80000c3e:	2785                	addiw	a5,a5,1
    80000c40:	dd3c                	sw	a5,120(a0)
}
    80000c42:	60e2                	ld	ra,24(sp)
    80000c44:	6442                	ld	s0,16(sp)
    80000c46:	64a2                	ld	s1,8(sp)
    80000c48:	6105                	addi	sp,sp,32
    80000c4a:	8082                	ret
    mycpu()->intena = old;
    80000c4c:	3c6010ef          	jal	80002012 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000c50:	8085                	srli	s1,s1,0x1
    80000c52:	8885                	andi	s1,s1,1
    80000c54:	dd64                	sw	s1,124(a0)
    80000c56:	b7cd                	j	80000c38 <push_off+0x20>

0000000080000c58 <acquire>:
{
    80000c58:	1101                	addi	sp,sp,-32
    80000c5a:	ec06                	sd	ra,24(sp)
    80000c5c:	e822                	sd	s0,16(sp)
    80000c5e:	e426                	sd	s1,8(sp)
    80000c60:	1000                	addi	s0,sp,32
    80000c62:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c64:	fb5ff0ef          	jal	80000c18 <push_off>
  if(holding(lk))
    80000c68:	8526                	mv	a0,s1
    80000c6a:	f85ff0ef          	jal	80000bee <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c6e:	4705                	li	a4,1
  if(holding(lk))
    80000c70:	e105                	bnez	a0,80000c90 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80000c72:	87ba                	mv	a5,a4
    80000c74:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000c78:	2781                	sext.w	a5,a5
    80000c7a:	ffe5                	bnez	a5,80000c72 <acquire+0x1a>
  __sync_synchronize();
    80000c7c:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000c80:	392010ef          	jal	80002012 <mycpu>
    80000c84:	e888                	sd	a0,16(s1)
}
    80000c86:	60e2                	ld	ra,24(sp)
    80000c88:	6442                	ld	s0,16(sp)
    80000c8a:	64a2                	ld	s1,8(sp)
    80000c8c:	6105                	addi	sp,sp,32
    80000c8e:	8082                	ret
    panic("acquire");
    80000c90:	00007517          	auipc	a0,0x7
    80000c94:	3e850513          	addi	a0,a0,1000 # 80008078 <etext+0x78>
    80000c98:	b61ff0ef          	jal	800007f8 <panic>

0000000080000c9c <pop_off>:

void
pop_off(void)
{
    80000c9c:	1141                	addi	sp,sp,-16
    80000c9e:	e406                	sd	ra,8(sp)
    80000ca0:	e022                	sd	s0,0(sp)
    80000ca2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000ca4:	36e010ef          	jal	80002012 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000ca8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000cac:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000cae:	e78d                	bnez	a5,80000cd8 <pop_off+0x3c>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80000cb0:	5d3c                	lw	a5,120(a0)
    80000cb2:	02f05963          	blez	a5,80000ce4 <pop_off+0x48>
    panic("pop_off");
  c->noff -= 1;
    80000cb6:	37fd                	addiw	a5,a5,-1
    80000cb8:	0007871b          	sext.w	a4,a5
    80000cbc:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000cbe:	eb09                	bnez	a4,80000cd0 <pop_off+0x34>
    80000cc0:	5d7c                	lw	a5,124(a0)
    80000cc2:	c799                	beqz	a5,80000cd0 <pop_off+0x34>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000cc4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000cc8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000ccc:	10079073          	csrw	sstatus,a5
    intr_on();
    80000cd0:	60a2                	ld	ra,8(sp)
    80000cd2:	6402                	ld	s0,0(sp)
    80000cd4:	0141                	addi	sp,sp,16
    80000cd6:	8082                	ret
    panic("pop_off - interruptible");
    80000cd8:	00007517          	auipc	a0,0x7
    80000cdc:	3a850513          	addi	a0,a0,936 # 80008080 <etext+0x80>
    80000ce0:	b19ff0ef          	jal	800007f8 <panic>
    panic("pop_off");
    80000ce4:	00007517          	auipc	a0,0x7
    80000ce8:	3b450513          	addi	a0,a0,948 # 80008098 <etext+0x98>
    80000cec:	b0dff0ef          	jal	800007f8 <panic>

0000000080000cf0 <release>:
{
    80000cf0:	1101                	addi	sp,sp,-32
    80000cf2:	ec06                	sd	ra,24(sp)
    80000cf4:	e822                	sd	s0,16(sp)
    80000cf6:	e426                	sd	s1,8(sp)
    80000cf8:	1000                	addi	s0,sp,32
    80000cfa:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000cfc:	ef3ff0ef          	jal	80000bee <holding>
    80000d00:	c105                	beqz	a0,80000d20 <release+0x30>
  lk->cpu = 0;
    80000d02:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000d06:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000d0a:	0f50000f          	fence	iorw,ow
    80000d0e:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000d12:	f8bff0ef          	jal	80000c9c <pop_off>
}
    80000d16:	60e2                	ld	ra,24(sp)
    80000d18:	6442                	ld	s0,16(sp)
    80000d1a:	64a2                	ld	s1,8(sp)
    80000d1c:	6105                	addi	sp,sp,32
    80000d1e:	8082                	ret
    panic("release");
    80000d20:	00007517          	auipc	a0,0x7
    80000d24:	38050513          	addi	a0,a0,896 # 800080a0 <etext+0xa0>
    80000d28:	ad1ff0ef          	jal	800007f8 <panic>

0000000080000d2c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d2c:	1141                	addi	sp,sp,-16
    80000d2e:	e422                	sd	s0,8(sp)
    80000d30:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d32:	ca19                	beqz	a2,80000d48 <memset+0x1c>
    80000d34:	87aa                	mv	a5,a0
    80000d36:	1602                	slli	a2,a2,0x20
    80000d38:	9201                	srli	a2,a2,0x20
    80000d3a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000d3e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d42:	0785                	addi	a5,a5,1
    80000d44:	fee79de3          	bne	a5,a4,80000d3e <memset+0x12>
  }
  return dst;
}
    80000d48:	6422                	ld	s0,8(sp)
    80000d4a:	0141                	addi	sp,sp,16
    80000d4c:	8082                	ret

0000000080000d4e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000d4e:	1141                	addi	sp,sp,-16
    80000d50:	e422                	sd	s0,8(sp)
    80000d52:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000d54:	ca05                	beqz	a2,80000d84 <memcmp+0x36>
    80000d56:	fff6069b          	addiw	a3,a2,-1 # fff <_entry-0x7ffff001>
    80000d5a:	1682                	slli	a3,a3,0x20
    80000d5c:	9281                	srli	a3,a3,0x20
    80000d5e:	0685                	addi	a3,a3,1
    80000d60:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000d62:	00054783          	lbu	a5,0(a0)
    80000d66:	0005c703          	lbu	a4,0(a1)
    80000d6a:	00e79863          	bne	a5,a4,80000d7a <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000d6e:	0505                	addi	a0,a0,1
    80000d70:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000d72:	fed518e3          	bne	a0,a3,80000d62 <memcmp+0x14>
  }

  return 0;
    80000d76:	4501                	li	a0,0
    80000d78:	a019                	j	80000d7e <memcmp+0x30>
      return *s1 - *s2;
    80000d7a:	40e7853b          	subw	a0,a5,a4
}
    80000d7e:	6422                	ld	s0,8(sp)
    80000d80:	0141                	addi	sp,sp,16
    80000d82:	8082                	ret
  return 0;
    80000d84:	4501                	li	a0,0
    80000d86:	bfe5                	j	80000d7e <memcmp+0x30>

0000000080000d88 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000d88:	1141                	addi	sp,sp,-16
    80000d8a:	e422                	sd	s0,8(sp)
    80000d8c:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000d8e:	c205                	beqz	a2,80000dae <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000d90:	02a5e263          	bltu	a1,a0,80000db4 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000d94:	1602                	slli	a2,a2,0x20
    80000d96:	9201                	srli	a2,a2,0x20
    80000d98:	00c587b3          	add	a5,a1,a2
{
    80000d9c:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d9e:	0585                	addi	a1,a1,1
    80000da0:	0705                	addi	a4,a4,1 # fffffffffffff001 <end+0xffffffff7fe44f21>
    80000da2:	fff5c683          	lbu	a3,-1(a1)
    80000da6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000daa:	feb79ae3          	bne	a5,a1,80000d9e <memmove+0x16>

  return dst;
}
    80000dae:	6422                	ld	s0,8(sp)
    80000db0:	0141                	addi	sp,sp,16
    80000db2:	8082                	ret
  if(s < d && s + n > d){
    80000db4:	02061693          	slli	a3,a2,0x20
    80000db8:	9281                	srli	a3,a3,0x20
    80000dba:	00d58733          	add	a4,a1,a3
    80000dbe:	fce57be3          	bgeu	a0,a4,80000d94 <memmove+0xc>
    d += n;
    80000dc2:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000dc4:	fff6079b          	addiw	a5,a2,-1
    80000dc8:	1782                	slli	a5,a5,0x20
    80000dca:	9381                	srli	a5,a5,0x20
    80000dcc:	fff7c793          	not	a5,a5
    80000dd0:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000dd2:	177d                	addi	a4,a4,-1
    80000dd4:	16fd                	addi	a3,a3,-1
    80000dd6:	00074603          	lbu	a2,0(a4)
    80000dda:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000dde:	fef71ae3          	bne	a4,a5,80000dd2 <memmove+0x4a>
    80000de2:	b7f1                	j	80000dae <memmove+0x26>

0000000080000de4 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000de4:	1141                	addi	sp,sp,-16
    80000de6:	e406                	sd	ra,8(sp)
    80000de8:	e022                	sd	s0,0(sp)
    80000dea:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000dec:	f9dff0ef          	jal	80000d88 <memmove>
}
    80000df0:	60a2                	ld	ra,8(sp)
    80000df2:	6402                	ld	s0,0(sp)
    80000df4:	0141                	addi	sp,sp,16
    80000df6:	8082                	ret

0000000080000df8 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000df8:	1141                	addi	sp,sp,-16
    80000dfa:	e422                	sd	s0,8(sp)
    80000dfc:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000dfe:	ce11                	beqz	a2,80000e1a <strncmp+0x22>
    80000e00:	00054783          	lbu	a5,0(a0)
    80000e04:	cf89                	beqz	a5,80000e1e <strncmp+0x26>
    80000e06:	0005c703          	lbu	a4,0(a1)
    80000e0a:	00f71a63          	bne	a4,a5,80000e1e <strncmp+0x26>
    n--, p++, q++;
    80000e0e:	367d                	addiw	a2,a2,-1
    80000e10:	0505                	addi	a0,a0,1
    80000e12:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e14:	f675                	bnez	a2,80000e00 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e16:	4501                	li	a0,0
    80000e18:	a801                	j	80000e28 <strncmp+0x30>
    80000e1a:	4501                	li	a0,0
    80000e1c:	a031                	j	80000e28 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    80000e1e:	00054503          	lbu	a0,0(a0)
    80000e22:	0005c783          	lbu	a5,0(a1)
    80000e26:	9d1d                	subw	a0,a0,a5
}
    80000e28:	6422                	ld	s0,8(sp)
    80000e2a:	0141                	addi	sp,sp,16
    80000e2c:	8082                	ret

0000000080000e2e <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e2e:	1141                	addi	sp,sp,-16
    80000e30:	e422                	sd	s0,8(sp)
    80000e32:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e34:	87aa                	mv	a5,a0
    80000e36:	86b2                	mv	a3,a2
    80000e38:	367d                	addiw	a2,a2,-1
    80000e3a:	02d05563          	blez	a3,80000e64 <strncpy+0x36>
    80000e3e:	0785                	addi	a5,a5,1
    80000e40:	0005c703          	lbu	a4,0(a1)
    80000e44:	fee78fa3          	sb	a4,-1(a5)
    80000e48:	0585                	addi	a1,a1,1
    80000e4a:	f775                	bnez	a4,80000e36 <strncpy+0x8>
    ;
  while(n-- > 0)
    80000e4c:	873e                	mv	a4,a5
    80000e4e:	9fb5                	addw	a5,a5,a3
    80000e50:	37fd                	addiw	a5,a5,-1
    80000e52:	00c05963          	blez	a2,80000e64 <strncpy+0x36>
    *s++ = 0;
    80000e56:	0705                	addi	a4,a4,1
    80000e58:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000e5c:	40e786bb          	subw	a3,a5,a4
    80000e60:	fed04be3          	bgtz	a3,80000e56 <strncpy+0x28>
  return os;
}
    80000e64:	6422                	ld	s0,8(sp)
    80000e66:	0141                	addi	sp,sp,16
    80000e68:	8082                	ret

0000000080000e6a <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000e6a:	1141                	addi	sp,sp,-16
    80000e6c:	e422                	sd	s0,8(sp)
    80000e6e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000e70:	02c05363          	blez	a2,80000e96 <safestrcpy+0x2c>
    80000e74:	fff6069b          	addiw	a3,a2,-1
    80000e78:	1682                	slli	a3,a3,0x20
    80000e7a:	9281                	srli	a3,a3,0x20
    80000e7c:	96ae                	add	a3,a3,a1
    80000e7e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000e80:	00d58963          	beq	a1,a3,80000e92 <safestrcpy+0x28>
    80000e84:	0585                	addi	a1,a1,1
    80000e86:	0785                	addi	a5,a5,1
    80000e88:	fff5c703          	lbu	a4,-1(a1)
    80000e8c:	fee78fa3          	sb	a4,-1(a5)
    80000e90:	fb65                	bnez	a4,80000e80 <safestrcpy+0x16>
    ;
  *s = 0;
    80000e92:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e96:	6422                	ld	s0,8(sp)
    80000e98:	0141                	addi	sp,sp,16
    80000e9a:	8082                	ret

0000000080000e9c <strlen>:

int
strlen(const char *s)
{
    80000e9c:	1141                	addi	sp,sp,-16
    80000e9e:	e422                	sd	s0,8(sp)
    80000ea0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000ea2:	00054783          	lbu	a5,0(a0)
    80000ea6:	cf91                	beqz	a5,80000ec2 <strlen+0x26>
    80000ea8:	0505                	addi	a0,a0,1
    80000eaa:	87aa                	mv	a5,a0
    80000eac:	86be                	mv	a3,a5
    80000eae:	0785                	addi	a5,a5,1
    80000eb0:	fff7c703          	lbu	a4,-1(a5)
    80000eb4:	ff65                	bnez	a4,80000eac <strlen+0x10>
    80000eb6:	40a6853b          	subw	a0,a3,a0
    80000eba:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    80000ebc:	6422                	ld	s0,8(sp)
    80000ebe:	0141                	addi	sp,sp,16
    80000ec0:	8082                	ret
  for(n = 0; s[n]; n++)
    80000ec2:	4501                	li	a0,0
    80000ec4:	bfe5                	j	80000ebc <strlen+0x20>

0000000080000ec6 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000ec6:	1141                	addi	sp,sp,-16
    80000ec8:	e406                	sd	ra,8(sp)
    80000eca:	e022                	sd	s0,0(sp)
    80000ecc:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000ece:	134010ef          	jal	80002002 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000ed2:	00008717          	auipc	a4,0x8
    80000ed6:	b8670713          	addi	a4,a4,-1146 # 80008a58 <started>
  if(cpuid() == 0){
    80000eda:	c51d                	beqz	a0,80000f08 <main+0x42>
    while(started == 0)
    80000edc:	431c                	lw	a5,0(a4)
    80000ede:	2781                	sext.w	a5,a5
    80000ee0:	dff5                	beqz	a5,80000edc <main+0x16>
      ;
    __sync_synchronize();
    80000ee2:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000ee6:	11c010ef          	jal	80002002 <cpuid>
    80000eea:	85aa                	mv	a1,a0
    80000eec:	00007517          	auipc	a0,0x7
    80000ef0:	1dc50513          	addi	a0,a0,476 # 800080c8 <etext+0xc8>
    80000ef4:	e32ff0ef          	jal	80000526 <printf>
    kvminithart();    // turn on paging
    80000ef8:	746000ef          	jal	8000163e <kvminithart>
    trapinithart();   // install kernel trap vector
    80000efc:	6c5010ef          	jal	80002dc0 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f00:	709040ef          	jal	80005e08 <plicinithart>
  }

  scheduler();        
    80000f04:	57a010ef          	jal	8000247e <scheduler>
    consoleinit();
    80000f08:	d48ff0ef          	jal	80000450 <consoleinit>
    printfinit();
    80000f0c:	927ff0ef          	jal	80000832 <printfinit>
    printf("\n");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	19850513          	addi	a0,a0,408 # 800080a8 <etext+0xa8>
    80000f18:	e0eff0ef          	jal	80000526 <printf>
    printf("xv6 kernel is booting\n");
    80000f1c:	00007517          	auipc	a0,0x7
    80000f20:	19450513          	addi	a0,a0,404 # 800080b0 <etext+0xb0>
    80000f24:	e02ff0ef          	jal	80000526 <printf>
    printf("\n");
    80000f28:	00007517          	auipc	a0,0x7
    80000f2c:	18050513          	addi	a0,a0,384 # 800080a8 <etext+0xa8>
    80000f30:	df6ff0ef          	jal	80000526 <printf>
    kinit();         // physical page allocator
    80000f34:	c21ff0ef          	jal	80000b54 <kinit>
    kvminit();       // create kernel page table
    80000f38:	191000ef          	jal	800018c8 <kvminit>
    kvminithart();   // turn on paging
    80000f3c:	702000ef          	jal	8000163e <kvminithart>
    procinit();      // process table
    80000f40:	7e9000ef          	jal	80001f28 <procinit>
    trapinit();      // trap vectors
    80000f44:	659010ef          	jal	80002d9c <trapinit>
    trapinithart();  // install kernel trap vector
    80000f48:	679010ef          	jal	80002dc0 <trapinithart>
    plicinit();      // set up interrupt controller
    80000f4c:	6a3040ef          	jal	80005dee <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000f50:	6b9040ef          	jal	80005e08 <plicinithart>
    binit();         // buffer cache
    80000f54:	65c020ef          	jal	800035b0 <binit>
    iinit();         // inode table
    80000f58:	44f020ef          	jal	80003ba6 <iinit>
    fileinit();      // file table
    80000f5c:	1fb030ef          	jal	80004956 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f60:	799040ef          	jal	80005ef8 <virtio_disk_init>
    userinit();      // first user process
    80000f64:	34e010ef          	jal	800022b2 <userinit>
    __sync_synchronize();
    80000f68:	0ff0000f          	fence
    started = 1;
    80000f6c:	4785                	li	a5,1
    80000f6e:	00008717          	auipc	a4,0x8
    80000f72:	aef72523          	sw	a5,-1302(a4) # 80008a58 <started>
    80000f76:	b779                	j	80000f04 <main+0x3e>

0000000080000f78 <msginit>:
    kds->queue_size = uds->msg_qbytes;
}

void
msginit(void)
{
    80000f78:	7179                	addi	sp,sp,-48
    80000f7a:	f406                	sd	ra,40(sp)
    80000f7c:	f022                	sd	s0,32(sp)
    80000f7e:	ec26                	sd	s1,24(sp)
    80000f80:	e84a                	sd	s2,16(sp)
    80000f82:	e44e                	sd	s3,8(sp)
    80000f84:	e052                	sd	s4,0(sp)
    80000f86:	1800                	addi	s0,sp,48
    initlock(&msgtable.lock, "msgtable");
    80000f88:	00007597          	auipc	a1,0x7
    80000f8c:	15858593          	addi	a1,a1,344 # 800080e0 <etext+0xe0>
    80000f90:	00010517          	auipc	a0,0x10
    80000f94:	c1050513          	addi	a0,a0,-1008 # 80010ba0 <msgtable>
    80000f98:	c41ff0ef          	jal	80000bd8 <initlock>
    for(int i = 0; i < MSG_MAX_QUEUES; i++) {
    80000f9c:	00010497          	auipc	s1,0x10
    80000fa0:	c3448493          	addi	s1,s1,-972 # 80010bd0 <msgtable+0x30>
    80000fa4:	00010a17          	auipc	s4,0x10
    80000fa8:	f2ca0a13          	addi	s4,s4,-212 # 80010ed0 <msgtable+0x330>
        initlock(&msgtable.queues[i].lock, "msgqueue");
    80000fac:	00007997          	auipc	s3,0x7
    80000fb0:	14498993          	addi	s3,s3,324 # 800080f0 <etext+0xf0>
        msgtable.queues[i].in_use = 0;
        msgtable.queues[i].msg_count = 0;
        msgtable.queues[i].first_msg = 0;
        msgtable.queues[i].last_msg = 0;
        msgtable.queues[i].queue_size = MSG_MAX_SIZE;
    80000fb4:	40000913          	li	s2,1024
        initlock(&msgtable.queues[i].lock, "msgqueue");
    80000fb8:	85ce                	mv	a1,s3
    80000fba:	8526                	mv	a0,s1
    80000fbc:	c1dff0ef          	jal	80000bd8 <initlock>
        msgtable.queues[i].in_use = 0;
    80000fc0:	fe04a423          	sw	zero,-24(s1)
        msgtable.queues[i].msg_count = 0;
    80000fc4:	fe04a623          	sw	zero,-20(s1)
        msgtable.queues[i].first_msg = 0;
    80000fc8:	fe04a823          	sw	zero,-16(s1)
        msgtable.queues[i].last_msg = 0;
    80000fcc:	fe04aa23          	sw	zero,-12(s1)
        msgtable.queues[i].queue_size = MSG_MAX_SIZE;
    80000fd0:	ff24ac23          	sw	s2,-8(s1)
    for(int i = 0; i < MSG_MAX_QUEUES; i++) {
    80000fd4:	03048493          	addi	s1,s1,48
    80000fd8:	ff4490e3          	bne	s1,s4,80000fb8 <msginit+0x40>
    }
}
    80000fdc:	70a2                	ld	ra,40(sp)
    80000fde:	7402                	ld	s0,32(sp)
    80000fe0:	64e2                	ld	s1,24(sp)
    80000fe2:	6942                	ld	s2,16(sp)
    80000fe4:	69a2                	ld	s3,8(sp)
    80000fe6:	6a02                	ld	s4,0(sp)
    80000fe8:	6145                	addi	sp,sp,48
    80000fea:	8082                	ret

0000000080000fec <sys_msgget>:

uint64
sys_msgget(void)
{
    80000fec:	7179                	addi	sp,sp,-48
    80000fee:	f406                	sd	ra,40(sp)
    80000ff0:	f022                	sd	s0,32(sp)
    80000ff2:	ec26                	sd	s1,24(sp)
    80000ff4:	1800                	addi	s0,sp,48
  int key, flags;
  if(argint(0, &key) < 0 || argint(1, &flags) < 0)
    80000ff6:	fdc40593          	addi	a1,s0,-36
    80000ffa:	4501                	li	a0,0
    80000ffc:	198020ef          	jal	80003194 <argint>
    return -1;
    80001000:	54fd                	li	s1,-1
  if(argint(0, &key) < 0 || argint(1, &flags) < 0)
    80001002:	04054363          	bltz	a0,80001048 <sys_msgget+0x5c>
    80001006:	fd840593          	addi	a1,s0,-40
    8000100a:	4505                	li	a0,1
    8000100c:	188020ef          	jal	80003194 <argint>
    80001010:	02054c63          	bltz	a0,80001048 <sys_msgget+0x5c>

  acquire(&msgtable.lock);
    80001014:	00010517          	auipc	a0,0x10
    80001018:	b8c50513          	addi	a0,a0,-1140 # 80010ba0 <msgtable>
    8000101c:	c3dff0ef          	jal	80000c58 <acquire>
  for(int i = 0; i < MSG_MAX_QUEUES; i++) {
    80001020:	00010797          	auipc	a5,0x10
    80001024:	b9878793          	addi	a5,a5,-1128 # 80010bb8 <msgtable+0x18>
    80001028:	4481                	li	s1,0
    8000102a:	46c1                	li	a3,16
    if(!msgtable.queues[i].in_use) {
    8000102c:	4398                	lw	a4,0(a5)
    8000102e:	c31d                	beqz	a4,80001054 <sys_msgget+0x68>
  for(int i = 0; i < MSG_MAX_QUEUES; i++) {
    80001030:	2485                	addiw	s1,s1,1
    80001032:	03078793          	addi	a5,a5,48
    80001036:	fed49be3          	bne	s1,a3,8000102c <sys_msgget+0x40>
      msgtable.queues[i].in_use = 1;
      release(&msgtable.lock);
      return i;
    }
  }
  release(&msgtable.lock);
    8000103a:	00010517          	auipc	a0,0x10
    8000103e:	b6650513          	addi	a0,a0,-1178 # 80010ba0 <msgtable>
    80001042:	cafff0ef          	jal	80000cf0 <release>
  return -1;
    80001046:	54fd                	li	s1,-1
}
    80001048:	8526                	mv	a0,s1
    8000104a:	70a2                	ld	ra,40(sp)
    8000104c:	7402                	ld	s0,32(sp)
    8000104e:	64e2                	ld	s1,24(sp)
    80001050:	6145                	addi	sp,sp,48
    80001052:	8082                	ret
      msgtable.queues[i].in_use = 1;
    80001054:	00010517          	auipc	a0,0x10
    80001058:	b4c50513          	addi	a0,a0,-1204 # 80010ba0 <msgtable>
    8000105c:	00149793          	slli	a5,s1,0x1
    80001060:	97a6                	add	a5,a5,s1
    80001062:	0792                	slli	a5,a5,0x4
    80001064:	97aa                	add	a5,a5,a0
    80001066:	4705                	li	a4,1
    80001068:	cf98                	sw	a4,24(a5)
      release(&msgtable.lock);
    8000106a:	c87ff0ef          	jal	80000cf0 <release>
      return i;
    8000106e:	bfe9                	j	80001048 <sys_msgget+0x5c>

0000000080001070 <sys_msgsnd>:

uint64
sys_msgsnd(void)
{
    80001070:	bc010113          	addi	sp,sp,-1088
    80001074:	42113c23          	sd	ra,1080(sp)
    80001078:	42813823          	sd	s0,1072(sp)
    8000107c:	44010413          	addi	s0,sp,1088
  int msqid;
  uint64 msgp;
  int msgsz, flags;

  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    80001080:	fdc40593          	addi	a1,s0,-36
    80001084:	4501                	li	a0,0
    80001086:	10e020ef          	jal	80003194 <argint>
     argint(2, &msgsz) < 0 || argint(3, &flags) < 0)
    return -1;
    8000108a:	57fd                	li	a5,-1
  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    8000108c:	1a054763          	bltz	a0,8000123a <sys_msgsnd+0x1ca>
    80001090:	fd040593          	addi	a1,s0,-48
    80001094:	4505                	li	a0,1
    80001096:	11c020ef          	jal	800031b2 <argaddr>
    return -1;
    8000109a:	57fd                	li	a5,-1
  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    8000109c:	18054f63          	bltz	a0,8000123a <sys_msgsnd+0x1ca>
     argint(2, &msgsz) < 0 || argint(3, &flags) < 0)
    800010a0:	fcc40593          	addi	a1,s0,-52
    800010a4:	4509                	li	a0,2
    800010a6:	0ee020ef          	jal	80003194 <argint>
    return -1;
    800010aa:	57fd                	li	a5,-1
  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    800010ac:	18054763          	bltz	a0,8000123a <sys_msgsnd+0x1ca>
     argint(2, &msgsz) < 0 || argint(3, &flags) < 0)
    800010b0:	fc840593          	addi	a1,s0,-56
    800010b4:	450d                	li	a0,3
    800010b6:	0de020ef          	jal	80003194 <argint>
    800010ba:	1a054563          	bltz	a0,80001264 <sys_msgsnd+0x1f4>

  if(msqid < 0 || msqid >= MSG_MAX_QUEUES || !msgtable.queues[msqid].in_use)
    800010be:	fdc42703          	lw	a4,-36(s0)
    800010c2:	0007061b          	sext.w	a2,a4
    800010c6:	46bd                	li	a3,15
    return -1;
    800010c8:	57fd                	li	a5,-1
  if(msqid < 0 || msqid >= MSG_MAX_QUEUES || !msgtable.queues[msqid].in_use)
    800010ca:	16c6e863          	bltu	a3,a2,8000123a <sys_msgsnd+0x1ca>
    800010ce:	00171793          	slli	a5,a4,0x1
    800010d2:	97ba                	add	a5,a5,a4
    800010d4:	0792                	slli	a5,a5,0x4
    800010d6:	00010717          	auipc	a4,0x10
    800010da:	aca70713          	addi	a4,a4,-1334 # 80010ba0 <msgtable>
    800010de:	97ba                	add	a5,a5,a4
    800010e0:	4f98                	lw	a4,24(a5)
    return -1;
    800010e2:	57fd                	li	a5,-1
  if(msqid < 0 || msqid >= MSG_MAX_QUEUES || !msgtable.queues[msqid].in_use)
    800010e4:	14070b63          	beqz	a4,8000123a <sys_msgsnd+0x1ca>

  struct msg_buf msg;
  if(copyin(myproc()->pagetable, (char*)&msg, msgp, sizeof(struct msg_buf)) < 0)
    800010e8:	747000ef          	jal	8000202e <myproc>
    800010ec:	40800693          	li	a3,1032
    800010f0:	fd043603          	ld	a2,-48(s0)
    800010f4:	bc040593          	addi	a1,s0,-1088
    800010f8:	6d28                	ld	a0,88(a0)
    800010fa:	459000ef          	jal	80001d52 <copyin>
    800010fe:	16054563          	bltz	a0,80001268 <sys_msgsnd+0x1f8>
    return -1;

  if(msgsz < 0 || msgsz > MSG_MAX_SIZE)
    80001102:	fcc42683          	lw	a3,-52(s0)
    80001106:	40000713          	li	a4,1024
    return -1;
    8000110a:	57fd                	li	a5,-1
  if(msgsz < 0 || msgsz > MSG_MAX_SIZE)
    8000110c:	12d76763          	bltu	a4,a3,8000123a <sys_msgsnd+0x1ca>
    80001110:	42913423          	sd	s1,1064(sp)

  acquire(&msgtable.queues[msqid].lock);
    80001114:	fdc42783          	lw	a5,-36(s0)
    80001118:	0785                	addi	a5,a5,1
    8000111a:	00179513          	slli	a0,a5,0x1
    8000111e:	953e                	add	a0,a0,a5
    80001120:	0512                	slli	a0,a0,0x4
    80001122:	00010497          	auipc	s1,0x10
    80001126:	a7e48493          	addi	s1,s1,-1410 # 80010ba0 <msgtable>
    8000112a:	9526                	add	a0,a0,s1
    8000112c:	b2dff0ef          	jal	80000c58 <acquire>
  
  if(msgtable.queues[msqid].msg_count >= msgtable.queues[msqid].queue_size) {
    80001130:	fdc42703          	lw	a4,-36(s0)
    80001134:	00171793          	slli	a5,a4,0x1
    80001138:	97ba                	add	a5,a5,a4
    8000113a:	0792                	slli	a5,a5,0x4
    8000113c:	94be                	add	s1,s1,a5
    8000113e:	4cd4                	lw	a3,28(s1)
    80001140:	549c                	lw	a5,40(s1)
    80001142:	04f6c263          	blt	a3,a5,80001186 <sys_msgsnd+0x116>
    if(flags & IPC_NOWAIT) {
    80001146:	fc842783          	lw	a5,-56(s0)
      release(&msgtable.queues[msqid].lock);
      return -1;
    }
    // Implement sleeping wait
    while(msgtable.queues[msqid].msg_count >= msgtable.queues[msqid].queue_size) {
      sleep(&msgtable.queues[msqid], &msgtable.queues[msqid].lock);
    8000114a:	00010497          	auipc	s1,0x10
    8000114e:	a5648493          	addi	s1,s1,-1450 # 80010ba0 <msgtable>
    if(flags & IPC_NOWAIT) {
    80001152:	03479693          	slli	a3,a5,0x34
    80001156:	0e06ca63          	bltz	a3,8000124a <sys_msgsnd+0x1da>
      sleep(&msgtable.queues[msqid], &msgtable.queues[msqid].lock);
    8000115a:	00171513          	slli	a0,a4,0x1
    8000115e:	953a                	add	a0,a0,a4
    80001160:	0512                	slli	a0,a0,0x4
    80001162:	03050593          	addi	a1,a0,48
    80001166:	0561                	addi	a0,a0,24
    80001168:	95a6                	add	a1,a1,s1
    8000116a:	9526                	add	a0,a0,s1
    8000116c:	4ac010ef          	jal	80002618 <sleep>
    while(msgtable.queues[msqid].msg_count >= msgtable.queues[msqid].queue_size) {
    80001170:	fdc42703          	lw	a4,-36(s0)
    80001174:	00171793          	slli	a5,a4,0x1
    80001178:	97ba                	add	a5,a5,a4
    8000117a:	0792                	slli	a5,a5,0x4
    8000117c:	97a6                	add	a5,a5,s1
    8000117e:	4fd4                	lw	a3,28(a5)
    80001180:	579c                	lw	a5,40(a5)
    80001182:	fcf6dce3          	bge	a3,a5,8000115a <sys_msgsnd+0xea>
    }
  }

  int msg_index = msqid * MSG_MAX_SIZE + msgtable.queues[msqid].last_msg;
    80001186:	fdc42583          	lw	a1,-36(s0)
    8000118a:	00010797          	auipc	a5,0x10
    8000118e:	a1678793          	addi	a5,a5,-1514 # 80010ba0 <msgtable>
    80001192:	00159713          	slli	a4,a1,0x1
    80001196:	972e                	add	a4,a4,a1
    80001198:	0712                	slli	a4,a4,0x4
    8000119a:	973e                	add	a4,a4,a5
    8000119c:	5354                	lw	a3,36(a4)
    8000119e:	00a5961b          	slliw	a2,a1,0xa
  msgtable.messages[msg_index] = msg;
    800011a2:	9e35                	addw	a2,a2,a3
    800011a4:	00761713          	slli	a4,a2,0x7
    800011a8:	9732                	add	a4,a4,a2
    800011aa:	070e                	slli	a4,a4,0x3
    800011ac:	97ba                	add	a5,a5,a4
    800011ae:	bc040713          	addi	a4,s0,-1088
    800011b2:	31878793          	addi	a5,a5,792
    800011b6:	fc040313          	addi	t1,s0,-64
    800011ba:	00073883          	ld	a7,0(a4)
    800011be:	00873803          	ld	a6,8(a4)
    800011c2:	6b08                	ld	a0,16(a4)
    800011c4:	6f10                	ld	a2,24(a4)
    800011c6:	0117b023          	sd	a7,0(a5)
    800011ca:	0107b423          	sd	a6,8(a5)
    800011ce:	eb88                	sd	a0,16(a5)
    800011d0:	ef90                	sd	a2,24(a5)
    800011d2:	02070713          	addi	a4,a4,32
    800011d6:	02078793          	addi	a5,a5,32
    800011da:	fe6710e3          	bne	a4,t1,800011ba <sys_msgsnd+0x14a>
    800011de:	6318                	ld	a4,0(a4)
    800011e0:	e398                	sd	a4,0(a5)

  msgtable.queues[msqid].last_msg = (msgtable.queues[msqid].last_msg + 1) % MSG_MAX_SIZE;
    800011e2:	00010497          	auipc	s1,0x10
    800011e6:	9be48493          	addi	s1,s1,-1602 # 80010ba0 <msgtable>
    800011ea:	00159713          	slli	a4,a1,0x1
    800011ee:	00b70633          	add	a2,a4,a1
    800011f2:	0612                	slli	a2,a2,0x4
    800011f4:	9626                	add	a2,a2,s1
    800011f6:	0016879b          	addiw	a5,a3,1
    800011fa:	41f7d69b          	sraiw	a3,a5,0x1f
    800011fe:	0166d69b          	srliw	a3,a3,0x16
    80001202:	9fb5                	addw	a5,a5,a3
    80001204:	3ff7f793          	andi	a5,a5,1023
    80001208:	9f95                	subw	a5,a5,a3
    8000120a:	d25c                	sw	a5,36(a2)
  msgtable.queues[msqid].msg_count++;
    8000120c:	4e5c                	lw	a5,28(a2)
    8000120e:	2785                	addiw	a5,a5,1
    80001210:	ce5c                	sw	a5,28(a2)

  wakeup(&msgtable.queues[msqid]);
    80001212:	00b70533          	add	a0,a4,a1
    80001216:	0512                	slli	a0,a0,0x4
    80001218:	0561                	addi	a0,a0,24
    8000121a:	9526                	add	a0,a0,s1
    8000121c:	448010ef          	jal	80002664 <wakeup>
  release(&msgtable.queues[msqid].lock);
    80001220:	fdc42783          	lw	a5,-36(s0)
    80001224:	0785                	addi	a5,a5,1
    80001226:	00179513          	slli	a0,a5,0x1
    8000122a:	953e                	add	a0,a0,a5
    8000122c:	0512                	slli	a0,a0,0x4
    8000122e:	9526                	add	a0,a0,s1
    80001230:	ac1ff0ef          	jal	80000cf0 <release>
  return 0;
    80001234:	4781                	li	a5,0
    80001236:	42813483          	ld	s1,1064(sp)
}
    8000123a:	853e                	mv	a0,a5
    8000123c:	43813083          	ld	ra,1080(sp)
    80001240:	43013403          	ld	s0,1072(sp)
    80001244:	44010113          	addi	sp,sp,1088
    80001248:	8082                	ret
      release(&msgtable.queues[msqid].lock);
    8000124a:	0705                	addi	a4,a4,1
    8000124c:	00171793          	slli	a5,a4,0x1
    80001250:	97ba                	add	a5,a5,a4
    80001252:	0792                	slli	a5,a5,0x4
    80001254:	00f48533          	add	a0,s1,a5
    80001258:	a99ff0ef          	jal	80000cf0 <release>
      return -1;
    8000125c:	57fd                	li	a5,-1
    8000125e:	42813483          	ld	s1,1064(sp)
    80001262:	bfe1                	j	8000123a <sys_msgsnd+0x1ca>
    return -1;
    80001264:	57fd                	li	a5,-1
    80001266:	bfd1                	j	8000123a <sys_msgsnd+0x1ca>
    return -1;
    80001268:	57fd                	li	a5,-1
    8000126a:	bfc1                	j	8000123a <sys_msgsnd+0x1ca>

000000008000126c <sys_msgrcv>:

uint64
sys_msgrcv(void)
{
    8000126c:	7139                	addi	sp,sp,-64
    8000126e:	fc06                	sd	ra,56(sp)
    80001270:	f822                	sd	s0,48(sp)
    80001272:	0080                	addi	s0,sp,64
  int msqid;
  uint64 msgp;
  int msgsz, flags;
  long msgtyp;

  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    80001274:	fdc40593          	addi	a1,s0,-36
    80001278:	4501                	li	a0,0
    8000127a:	71b010ef          	jal	80003194 <argint>
     argint(2, &msgsz) < 0 || argint(3, (int*)&msgtyp) < 0 || 
     argint(4, &flags) < 0)
    return -1;
    8000127e:	57fd                	li	a5,-1
  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    80001280:	1c054b63          	bltz	a0,80001456 <sys_msgrcv+0x1ea>
    80001284:	fd040593          	addi	a1,s0,-48
    80001288:	4505                	li	a0,1
    8000128a:	729010ef          	jal	800031b2 <argaddr>
    return -1;
    8000128e:	57fd                	li	a5,-1
  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    80001290:	1c054363          	bltz	a0,80001456 <sys_msgrcv+0x1ea>
     argint(2, &msgsz) < 0 || argint(3, (int*)&msgtyp) < 0 || 
    80001294:	fcc40593          	addi	a1,s0,-52
    80001298:	4509                	li	a0,2
    8000129a:	6fb010ef          	jal	80003194 <argint>
    return -1;
    8000129e:	57fd                	li	a5,-1
  if(argint(0, &msqid) < 0 || argaddr(1, &msgp) < 0 ||
    800012a0:	1a054b63          	bltz	a0,80001456 <sys_msgrcv+0x1ea>
     argint(2, &msgsz) < 0 || argint(3, (int*)&msgtyp) < 0 || 
    800012a4:	fc040593          	addi	a1,s0,-64
    800012a8:	450d                	li	a0,3
    800012aa:	6eb010ef          	jal	80003194 <argint>
    return -1;
    800012ae:	57fd                	li	a5,-1
     argint(2, &msgsz) < 0 || argint(3, (int*)&msgtyp) < 0 || 
    800012b0:	1a054363          	bltz	a0,80001456 <sys_msgrcv+0x1ea>
     argint(4, &flags) < 0)
    800012b4:	fc840593          	addi	a1,s0,-56
    800012b8:	4511                	li	a0,4
    800012ba:	6db010ef          	jal	80003194 <argint>
     argint(2, &msgsz) < 0 || argint(3, (int*)&msgtyp) < 0 || 
    800012be:	18054b63          	bltz	a0,80001454 <sys_msgrcv+0x1e8>

  if(msqid < 0 || msqid >= MSG_MAX_QUEUES || !msgtable.queues[msqid].in_use)
    800012c2:	fdc42703          	lw	a4,-36(s0)
    800012c6:	0007061b          	sext.w	a2,a4
    800012ca:	46bd                	li	a3,15
    return -1;
    800012cc:	57fd                	li	a5,-1
  if(msqid < 0 || msqid >= MSG_MAX_QUEUES || !msgtable.queues[msqid].in_use)
    800012ce:	18c6e463          	bltu	a3,a2,80001456 <sys_msgrcv+0x1ea>
    800012d2:	00171793          	slli	a5,a4,0x1
    800012d6:	97ba                	add	a5,a5,a4
    800012d8:	0792                	slli	a5,a5,0x4
    800012da:	00010697          	auipc	a3,0x10
    800012de:	8c668693          	addi	a3,a3,-1850 # 80010ba0 <msgtable>
    800012e2:	97b6                	add	a5,a5,a3
    800012e4:	4f94                	lw	a3,24(a5)
    return -1;
    800012e6:	57fd                	li	a5,-1
  if(msqid < 0 || msqid >= MSG_MAX_QUEUES || !msgtable.queues[msqid].in_use)
    800012e8:	16068763          	beqz	a3,80001456 <sys_msgrcv+0x1ea>

  if(msgsz < 0 || msgsz > MSG_MAX_SIZE)
    800012ec:	fcc42603          	lw	a2,-52(s0)
    800012f0:	40000693          	li	a3,1024
    800012f4:	16c6e163          	bltu	a3,a2,80001456 <sys_msgrcv+0x1ea>
    800012f8:	f426                	sd	s1,40(sp)
    return -1;

  acquire(&msgtable.queues[msqid].lock);
    800012fa:	0705                	addi	a4,a4,1
    800012fc:	00171513          	slli	a0,a4,0x1
    80001300:	953a                	add	a0,a0,a4
    80001302:	0512                	slli	a0,a0,0x4
    80001304:	00010497          	auipc	s1,0x10
    80001308:	89c48493          	addi	s1,s1,-1892 # 80010ba0 <msgtable>
    8000130c:	9526                	add	a0,a0,s1
    8000130e:	94bff0ef          	jal	80000c58 <acquire>

  if(msgtable.queues[msqid].msg_count == 0) {
    80001312:	fdc42783          	lw	a5,-36(s0)
    80001316:	00179713          	slli	a4,a5,0x1
    8000131a:	973e                	add	a4,a4,a5
    8000131c:	0712                	slli	a4,a4,0x4
    8000131e:	94ba                	add	s1,s1,a4
    80001320:	4cd8                	lw	a4,28(s1)
    80001322:	e739                	bnez	a4,80001370 <sys_msgrcv+0x104>
    if(flags & IPC_NOWAIT) {
    80001324:	fc842703          	lw	a4,-56(s0)
    80001328:	03471693          	slli	a3,a4,0x34
    8000132c:	0206d263          	bgez	a3,80001350 <sys_msgrcv+0xe4>
      release(&msgtable.queues[msqid].lock);
    80001330:	00178713          	addi	a4,a5,1
    80001334:	00171793          	slli	a5,a4,0x1
    80001338:	97ba                	add	a5,a5,a4
    8000133a:	0792                	slli	a5,a5,0x4
    8000133c:	00010517          	auipc	a0,0x10
    80001340:	86450513          	addi	a0,a0,-1948 # 80010ba0 <msgtable>
    80001344:	953e                	add	a0,a0,a5
    80001346:	9abff0ef          	jal	80000cf0 <release>
      return -1;
    8000134a:	57fd                	li	a5,-1
    8000134c:	74a2                	ld	s1,40(sp)
    8000134e:	a221                	j	80001456 <sys_msgrcv+0x1ea>
    }
    // Could implement sleeping wait here
    release(&msgtable.queues[msqid].lock);
    80001350:	00178713          	addi	a4,a5,1
    80001354:	00171793          	slli	a5,a4,0x1
    80001358:	97ba                	add	a5,a5,a4
    8000135a:	0792                	slli	a5,a5,0x4
    8000135c:	00010517          	auipc	a0,0x10
    80001360:	84450513          	addi	a0,a0,-1980 # 80010ba0 <msgtable>
    80001364:	953e                	add	a0,a0,a5
    80001366:	98bff0ef          	jal	80000cf0 <release>
    return -1;
    8000136a:	57fd                	li	a5,-1
    8000136c:	74a2                	ld	s1,40(sp)
    8000136e:	a0e5                	j	80001456 <sys_msgrcv+0x1ea>
  }

  int msg_index = msqid * 100 + msgtable.queues[msqid].first_msg;
    80001370:	06400693          	li	a3,100
    80001374:	02f686bb          	mulw	a3,a3,a5
    80001378:	00010617          	auipc	a2,0x10
    8000137c:	82860613          	addi	a2,a2,-2008 # 80010ba0 <msgtable>
    80001380:	00179713          	slli	a4,a5,0x1
    80001384:	973e                	add	a4,a4,a5
    80001386:	0712                	slli	a4,a4,0x4
    80001388:	9732                	add	a4,a4,a2
    8000138a:	5318                	lw	a4,32(a4)
    8000138c:	9eb9                	addw	a3,a3,a4
  struct msg_buf *msg = &msgtable.messages[msg_index];
    8000138e:	00769713          	slli	a4,a3,0x7
    80001392:	9736                	add	a4,a4,a3
    80001394:	070e                	slli	a4,a4,0x3
    80001396:	31870713          	addi	a4,a4,792
    8000139a:	00c704b3          	add	s1,a4,a2

  // Type matching logic
  if(msgtyp > 0 && msg->mtype != msgtyp) {
    8000139e:	fc043603          	ld	a2,-64(s0)
    800013a2:	00c05f63          	blez	a2,800013c0 <sys_msgrcv+0x154>
    800013a6:	00769713          	slli	a4,a3,0x7
    800013aa:	9736                	add	a4,a4,a3
    800013ac:	070e                	slli	a4,a4,0x3
    800013ae:	0000f697          	auipc	a3,0xf
    800013b2:	7f268693          	addi	a3,a3,2034 # 80010ba0 <msgtable>
    800013b6:	9736                	add	a4,a4,a3
    800013b8:	31873703          	ld	a4,792(a4)
    800013bc:	04e61f63          	bne	a2,a4,8000141a <sys_msgrcv+0x1ae>
    release(&msgtable.queues[msqid].lock);
    return -1;
  }
  
  if(copyout(myproc()->pagetable, msgp, (char*)msg, sizeof(struct msg_buf)) < 0) {
    800013c0:	46f000ef          	jal	8000202e <myproc>
    800013c4:	40800693          	li	a3,1032
    800013c8:	8626                	mv	a2,s1
    800013ca:	fd043583          	ld	a1,-48(s0)
    800013ce:	6d28                	ld	a0,88(a0)
    800013d0:	0ad000ef          	jal	80001c7c <copyout>
    800013d4:	04054f63          	bltz	a0,80001432 <sys_msgrcv+0x1c6>
    release(&msgtable.queues[msqid].lock);
    return -1;
  }

  msgtable.queues[msqid].first_msg = (msgtable.queues[msqid].first_msg + 1) % 100;
    800013d8:	fdc42703          	lw	a4,-36(s0)
    800013dc:	0000f517          	auipc	a0,0xf
    800013e0:	7c450513          	addi	a0,a0,1988 # 80010ba0 <msgtable>
    800013e4:	00171793          	slli	a5,a4,0x1
    800013e8:	97ba                	add	a5,a5,a4
    800013ea:	0792                	slli	a5,a5,0x4
    800013ec:	97aa                	add	a5,a5,a0
    800013ee:	5394                	lw	a3,32(a5)
    800013f0:	2685                	addiw	a3,a3,1
    800013f2:	06400613          	li	a2,100
    800013f6:	02c6e6bb          	remw	a3,a3,a2
    800013fa:	d394                	sw	a3,32(a5)
  msgtable.queues[msqid].msg_count--;
    800013fc:	4fd4                	lw	a3,28(a5)
    800013fe:	36fd                	addiw	a3,a3,-1
    80001400:	cfd4                	sw	a3,28(a5)

  release(&msgtable.queues[msqid].lock);
    80001402:	0705                	addi	a4,a4,1
    80001404:	00171793          	slli	a5,a4,0x1
    80001408:	97ba                	add	a5,a5,a4
    8000140a:	0792                	slli	a5,a5,0x4
    8000140c:	953e                	add	a0,a0,a5
    8000140e:	8e3ff0ef          	jal	80000cf0 <release>
  return msgsz;
    80001412:	fcc42783          	lw	a5,-52(s0)
    80001416:	74a2                	ld	s1,40(sp)
    80001418:	a83d                	j	80001456 <sys_msgrcv+0x1ea>
    release(&msgtable.queues[msqid].lock);
    8000141a:	0785                	addi	a5,a5,1
    8000141c:	00179713          	slli	a4,a5,0x1
    80001420:	97ba                	add	a5,a5,a4
    80001422:	0792                	slli	a5,a5,0x4
    80001424:	00f68533          	add	a0,a3,a5
    80001428:	8c9ff0ef          	jal	80000cf0 <release>
    return -1;
    8000142c:	57fd                	li	a5,-1
    8000142e:	74a2                	ld	s1,40(sp)
    80001430:	a01d                	j	80001456 <sys_msgrcv+0x1ea>
    release(&msgtable.queues[msqid].lock);
    80001432:	fdc42703          	lw	a4,-36(s0)
    80001436:	0705                	addi	a4,a4,1
    80001438:	00171793          	slli	a5,a4,0x1
    8000143c:	97ba                	add	a5,a5,a4
    8000143e:	0792                	slli	a5,a5,0x4
    80001440:	0000f517          	auipc	a0,0xf
    80001444:	76050513          	addi	a0,a0,1888 # 80010ba0 <msgtable>
    80001448:	953e                	add	a0,a0,a5
    8000144a:	8a7ff0ef          	jal	80000cf0 <release>
    return -1;
    8000144e:	57fd                	li	a5,-1
    80001450:	74a2                	ld	s1,40(sp)
    80001452:	a011                	j	80001456 <sys_msgrcv+0x1ea>
    return -1;
    80001454:	57fd                	li	a5,-1
}
    80001456:	853e                	mv	a0,a5
    80001458:	70e2                	ld	ra,56(sp)
    8000145a:	7442                	ld	s0,48(sp)
    8000145c:	6121                	addi	sp,sp,64
    8000145e:	8082                	ret

0000000080001460 <sys_msgctl>:

uint64
sys_msgctl(void)
{
    80001460:	715d                	addi	sp,sp,-80
    80001462:	e486                	sd	ra,72(sp)
    80001464:	e0a2                	sd	s0,64(sp)
    80001466:	0880                	addi	s0,sp,80
    int msqid, cmd;
    uint64 buf_addr;
    struct msg_queue *queue;
    struct msqid_ds buf;

    if(argint(0, &msqid) < 0 || argint(1, &cmd) < 0 || argaddr(2, &buf_addr) < 0)
    80001468:	fdc40593          	addi	a1,s0,-36
    8000146c:	4501                	li	a0,0
    8000146e:	527010ef          	jal	80003194 <argint>
        return -1;
    80001472:	57fd                	li	a5,-1
    if(argint(0, &msqid) < 0 || argint(1, &cmd) < 0 || argaddr(2, &buf_addr) < 0)
    80001474:	1c054063          	bltz	a0,80001634 <sys_msgctl+0x1d4>
    80001478:	fd840593          	addi	a1,s0,-40
    8000147c:	4505                	li	a0,1
    8000147e:	517010ef          	jal	80003194 <argint>
        return -1;
    80001482:	57fd                	li	a5,-1
    if(argint(0, &msqid) < 0 || argint(1, &cmd) < 0 || argaddr(2, &buf_addr) < 0)
    80001484:	1a054863          	bltz	a0,80001634 <sys_msgctl+0x1d4>
    80001488:	fd040593          	addi	a1,s0,-48
    8000148c:	4509                	li	a0,2
    8000148e:	525010ef          	jal	800031b2 <argaddr>
    80001492:	18054e63          	bltz	a0,8000162e <sys_msgctl+0x1ce>
    80001496:	f84a                	sd	s2,48(sp)

    // Check if msqid is valid
    if(msqid < 0 || msqid >= MSG_MAX_QUEUES)
    80001498:	fdc42903          	lw	s2,-36(s0)
    8000149c:	0009069b          	sext.w	a3,s2
    800014a0:	473d                	li	a4,15
        return -1;
    800014a2:	57fd                	li	a5,-1
    if(msqid < 0 || msqid >= MSG_MAX_QUEUES)
    800014a4:	18d76763          	bltu	a4,a3,80001632 <sys_msgctl+0x1d2>
    800014a8:	fc26                	sd	s1,56(sp)

    queue = &msgtable.queues[msqid];

    acquire(&queue->lock);
    800014aa:	00190793          	addi	a5,s2,1
    800014ae:	00179493          	slli	s1,a5,0x1
    800014b2:	94be                	add	s1,s1,a5
    800014b4:	0492                	slli	s1,s1,0x4
    800014b6:	0000f797          	auipc	a5,0xf
    800014ba:	6ea78793          	addi	a5,a5,1770 # 80010ba0 <msgtable>
    800014be:	94be                	add	s1,s1,a5
    800014c0:	8526                	mv	a0,s1
    800014c2:	f96ff0ef          	jal	80000c58 <acquire>

    switch(cmd) {
    800014c6:	fd842783          	lw	a5,-40(s0)
    800014ca:	4705                	li	a4,1
    800014cc:	0ae78363          	beq	a5,a4,80001572 <sys_msgctl+0x112>
    800014d0:	4709                	li	a4,2
    800014d2:	00e78b63          	beq	a5,a4,800014e8 <sys_msgctl+0x88>
    800014d6:	10078163          	beqz	a5,800015d8 <sys_msgctl+0x178>
            queue->first_msg = 0;
            queue->last_msg = 0;
            break;

        default:
            release(&queue->lock);
    800014da:	8526                	mv	a0,s1
    800014dc:	815ff0ef          	jal	80000cf0 <release>
            return -1;
    800014e0:	57fd                	li	a5,-1
    800014e2:	74e2                	ld	s1,56(sp)
    800014e4:	7942                	ld	s2,48(sp)
    800014e6:	a2b9                	j	80001634 <sys_msgctl+0x1d4>
            if(!queue->in_use) {
    800014e8:	00191793          	slli	a5,s2,0x1
    800014ec:	97ca                	add	a5,a5,s2
    800014ee:	0792                	slli	a5,a5,0x4
    800014f0:	0000f717          	auipc	a4,0xf
    800014f4:	6b070713          	addi	a4,a4,1712 # 80010ba0 <msgtable>
    800014f8:	97ba                	add	a5,a5,a4
    800014fa:	4f9c                	lw	a5,24(a5)
    800014fc:	c7a5                	beqz	a5,80001564 <sys_msgctl+0x104>
    uds->msg_perm = 0; 
    800014fe:	fa042823          	sw	zero,-80(s0)
    uds->msg_qnum = kds->msg_count;
    80001502:	0000f697          	auipc	a3,0xf
    80001506:	69e68693          	addi	a3,a3,1694 # 80010ba0 <msgtable>
    8000150a:	00191793          	slli	a5,s2,0x1
    8000150e:	01278733          	add	a4,a5,s2
    80001512:	0712                	slli	a4,a4,0x4
    80001514:	9736                	add	a4,a4,a3
    80001516:	4f58                	lw	a4,28(a4)
    80001518:	fae42a23          	sw	a4,-76(s0)
    uds->msg_qbytes = kds->queue_size;
    8000151c:	97ca                	add	a5,a5,s2
    8000151e:	0792                	slli	a5,a5,0x4
    80001520:	96be                	add	a3,a3,a5
    80001522:	569c                	lw	a5,40(a3)
    80001524:	faf42c23          	sw	a5,-72(s0)
    uds->msg_lspid = 0;
    80001528:	fa042e23          	sw	zero,-68(s0)
    uds->msg_lrpid = 0;
    8000152c:	fc042023          	sw	zero,-64(s0)
    uds->msg_stime = 0;
    80001530:	fc042223          	sw	zero,-60(s0)
    uds->msg_rtime = 0;
    80001534:	fc042423          	sw	zero,-56(s0)
    uds->msg_ctime = 0;
    80001538:	fc042623          	sw	zero,-52(s0)
            if(copyout(myproc()->pagetable, buf_addr, (char*)&buf, sizeof(buf)) < 0) {
    8000153c:	2f3000ef          	jal	8000202e <myproc>
    80001540:	02000693          	li	a3,32
    80001544:	fb040613          	addi	a2,s0,-80
    80001548:	fd043583          	ld	a1,-48(s0)
    8000154c:	6d28                	ld	a0,88(a0)
    8000154e:	72e000ef          	jal	80001c7c <copyout>
    80001552:	0c055063          	bgez	a0,80001612 <sys_msgctl+0x1b2>
                release(&queue->lock);
    80001556:	8526                	mv	a0,s1
    80001558:	f98ff0ef          	jal	80000cf0 <release>
                return -1;
    8000155c:	57fd                	li	a5,-1
    8000155e:	74e2                	ld	s1,56(sp)
    80001560:	7942                	ld	s2,48(sp)
    80001562:	a8c9                	j	80001634 <sys_msgctl+0x1d4>
                release(&queue->lock);
    80001564:	8526                	mv	a0,s1
    80001566:	f8aff0ef          	jal	80000cf0 <release>
                return -1;
    8000156a:	57fd                	li	a5,-1
    8000156c:	74e2                	ld	s1,56(sp)
    8000156e:	7942                	ld	s2,48(sp)
    80001570:	a0d1                	j	80001634 <sys_msgctl+0x1d4>
            if(!queue->in_use) {
    80001572:	00191793          	slli	a5,s2,0x1
    80001576:	97ca                	add	a5,a5,s2
    80001578:	0792                	slli	a5,a5,0x4
    8000157a:	0000f717          	auipc	a4,0xf
    8000157e:	62670713          	addi	a4,a4,1574 # 80010ba0 <msgtable>
    80001582:	97ba                	add	a5,a5,a4
    80001584:	4f9c                	lw	a5,24(a5)
    80001586:	cb9d                	beqz	a5,800015bc <sys_msgctl+0x15c>
            if(copyin(myproc()->pagetable, (char*)&buf, buf_addr, sizeof(buf)) < 0) {
    80001588:	2a7000ef          	jal	8000202e <myproc>
    8000158c:	02000693          	li	a3,32
    80001590:	fd043603          	ld	a2,-48(s0)
    80001594:	fb040593          	addi	a1,s0,-80
    80001598:	6d28                	ld	a0,88(a0)
    8000159a:	7b8000ef          	jal	80001d52 <copyin>
    8000159e:	02054663          	bltz	a0,800015ca <sys_msgctl+0x16a>
    kds->queue_size = uds->msg_qbytes;
    800015a2:	00191793          	slli	a5,s2,0x1
    800015a6:	97ca                	add	a5,a5,s2
    800015a8:	0792                	slli	a5,a5,0x4
    800015aa:	0000f717          	auipc	a4,0xf
    800015ae:	5f670713          	addi	a4,a4,1526 # 80010ba0 <msgtable>
    800015b2:	97ba                	add	a5,a5,a4
    800015b4:	fb842703          	lw	a4,-72(s0)
    800015b8:	d798                	sw	a4,40(a5)
}
    800015ba:	a8a1                	j	80001612 <sys_msgctl+0x1b2>
                release(&queue->lock);
    800015bc:	8526                	mv	a0,s1
    800015be:	f32ff0ef          	jal	80000cf0 <release>
                return -1;
    800015c2:	57fd                	li	a5,-1
    800015c4:	74e2                	ld	s1,56(sp)
    800015c6:	7942                	ld	s2,48(sp)
    800015c8:	a0b5                	j	80001634 <sys_msgctl+0x1d4>
                release(&queue->lock);
    800015ca:	8526                	mv	a0,s1
    800015cc:	f24ff0ef          	jal	80000cf0 <release>
                return -1;
    800015d0:	57fd                	li	a5,-1
    800015d2:	74e2                	ld	s1,56(sp)
    800015d4:	7942                	ld	s2,48(sp)
    800015d6:	a8b9                	j	80001634 <sys_msgctl+0x1d4>
            if(!queue->in_use) {
    800015d8:	00191793          	slli	a5,s2,0x1
    800015dc:	97ca                	add	a5,a5,s2
    800015de:	0792                	slli	a5,a5,0x4
    800015e0:	0000f717          	auipc	a4,0xf
    800015e4:	5c070713          	addi	a4,a4,1472 # 80010ba0 <msgtable>
    800015e8:	97ba                	add	a5,a5,a4
    800015ea:	4f9c                	lw	a5,24(a5)
    800015ec:	cb95                	beqz	a5,80001620 <sys_msgctl+0x1c0>
            queue->in_use = 0;
    800015ee:	0000f697          	auipc	a3,0xf
    800015f2:	5b268693          	addi	a3,a3,1458 # 80010ba0 <msgtable>
    800015f6:	00191713          	slli	a4,s2,0x1
    800015fa:	012707b3          	add	a5,a4,s2
    800015fe:	0792                	slli	a5,a5,0x4
    80001600:	97b6                	add	a5,a5,a3
    80001602:	0007ac23          	sw	zero,24(a5)
            queue->msg_count = 0;
    80001606:	0007ae23          	sw	zero,28(a5)
            queue->first_msg = 0;
    8000160a:	0207a023          	sw	zero,32(a5)
            queue->last_msg = 0;
    8000160e:	0207a223          	sw	zero,36(a5)
    }

    release(&queue->lock);
    80001612:	8526                	mv	a0,s1
    80001614:	edcff0ef          	jal	80000cf0 <release>
    return 0;
    80001618:	4781                	li	a5,0
    8000161a:	74e2                	ld	s1,56(sp)
    8000161c:	7942                	ld	s2,48(sp)
    8000161e:	a819                	j	80001634 <sys_msgctl+0x1d4>
                release(&queue->lock);
    80001620:	8526                	mv	a0,s1
    80001622:	eceff0ef          	jal	80000cf0 <release>
                return -1;
    80001626:	57fd                	li	a5,-1
    80001628:	74e2                	ld	s1,56(sp)
    8000162a:	7942                	ld	s2,48(sp)
    8000162c:	a021                	j	80001634 <sys_msgctl+0x1d4>
        return -1;
    8000162e:	57fd                	li	a5,-1
    80001630:	a011                	j	80001634 <sys_msgctl+0x1d4>
    80001632:	7942                	ld	s2,48(sp)
    80001634:	853e                	mv	a0,a5
    80001636:	60a6                	ld	ra,72(sp)
    80001638:	6406                	ld	s0,64(sp)
    8000163a:	6161                	addi	sp,sp,80
    8000163c:	8082                	ret

000000008000163e <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    8000163e:	1141                	addi	sp,sp,-16
    80001640:	e422                	sd	s0,8(sp)
    80001642:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001644:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80001648:	00007797          	auipc	a5,0x7
    8000164c:	4187b783          	ld	a5,1048(a5) # 80008a60 <kernel_pagetable>
    80001650:	83b1                	srli	a5,a5,0xc
    80001652:	577d                	li	a4,-1
    80001654:	177e                	slli	a4,a4,0x3f
    80001656:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80001658:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000165c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001660:	6422                	ld	s0,8(sp)
    80001662:	0141                	addi	sp,sp,16
    80001664:	8082                	ret

0000000080001666 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001666:	7139                	addi	sp,sp,-64
    80001668:	fc06                	sd	ra,56(sp)
    8000166a:	f822                	sd	s0,48(sp)
    8000166c:	f426                	sd	s1,40(sp)
    8000166e:	f04a                	sd	s2,32(sp)
    80001670:	ec4e                	sd	s3,24(sp)
    80001672:	e852                	sd	s4,16(sp)
    80001674:	e456                	sd	s5,8(sp)
    80001676:	e05a                	sd	s6,0(sp)
    80001678:	0080                	addi	s0,sp,64
    8000167a:	84aa                	mv	s1,a0
    8000167c:	89ae                	mv	s3,a1
    8000167e:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    80001680:	57fd                	li	a5,-1
    80001682:	83e9                	srli	a5,a5,0x1a
    80001684:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80001686:	4b31                	li	s6,12
  if(va >= MAXVA)
    80001688:	02b7fc63          	bgeu	a5,a1,800016c0 <walk+0x5a>
    panic("walk");
    8000168c:	00007517          	auipc	a0,0x7
    80001690:	a7450513          	addi	a0,a0,-1420 # 80008100 <etext+0x100>
    80001694:	964ff0ef          	jal	800007f8 <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if(*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80001698:	060a8263          	beqz	s5,800016fc <walk+0x96>
    8000169c:	cecff0ef          	jal	80000b88 <kalloc>
    800016a0:	84aa                	mv	s1,a0
    800016a2:	c139                	beqz	a0,800016e8 <walk+0x82>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800016a4:	6605                	lui	a2,0x1
    800016a6:	4581                	li	a1,0
    800016a8:	e84ff0ef          	jal	80000d2c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800016ac:	00c4d793          	srli	a5,s1,0xc
    800016b0:	07aa                	slli	a5,a5,0xa
    800016b2:	0017e793          	ori	a5,a5,1
    800016b6:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800016ba:	3a5d                	addiw	s4,s4,-9
    800016bc:	036a0063          	beq	s4,s6,800016dc <walk+0x76>
    pte_t *pte = &pagetable[PX(level, va)];
    800016c0:	0149d933          	srl	s2,s3,s4
    800016c4:	1ff97913          	andi	s2,s2,511
    800016c8:	090e                	slli	s2,s2,0x3
    800016ca:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800016cc:	00093483          	ld	s1,0(s2)
    800016d0:	0014f793          	andi	a5,s1,1
    800016d4:	d3f1                	beqz	a5,80001698 <walk+0x32>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800016d6:	80a9                	srli	s1,s1,0xa
    800016d8:	04b2                	slli	s1,s1,0xc
    800016da:	b7c5                	j	800016ba <walk+0x54>
    }
  }
  return &pagetable[PX(0, va)];
    800016dc:	00c9d513          	srli	a0,s3,0xc
    800016e0:	1ff57513          	andi	a0,a0,511
    800016e4:	050e                	slli	a0,a0,0x3
    800016e6:	9526                	add	a0,a0,s1
}
    800016e8:	70e2                	ld	ra,56(sp)
    800016ea:	7442                	ld	s0,48(sp)
    800016ec:	74a2                	ld	s1,40(sp)
    800016ee:	7902                	ld	s2,32(sp)
    800016f0:	69e2                	ld	s3,24(sp)
    800016f2:	6a42                	ld	s4,16(sp)
    800016f4:	6aa2                	ld	s5,8(sp)
    800016f6:	6b02                	ld	s6,0(sp)
    800016f8:	6121                	addi	sp,sp,64
    800016fa:	8082                	ret
        return 0;
    800016fc:	4501                	li	a0,0
    800016fe:	b7ed                	j	800016e8 <walk+0x82>

0000000080001700 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80001700:	57fd                	li	a5,-1
    80001702:	83e9                	srli	a5,a5,0x1a
    80001704:	00b7f463          	bgeu	a5,a1,8000170c <walkaddr+0xc>
    return 0;
    80001708:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000170a:	8082                	ret
{
    8000170c:	1141                	addi	sp,sp,-16
    8000170e:	e406                	sd	ra,8(sp)
    80001710:	e022                	sd	s0,0(sp)
    80001712:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001714:	4601                	li	a2,0
    80001716:	f51ff0ef          	jal	80001666 <walk>
  if(pte == 0)
    8000171a:	c105                	beqz	a0,8000173a <walkaddr+0x3a>
  if((*pte & PTE_V) == 0)
    8000171c:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000171e:	0117f693          	andi	a3,a5,17
    80001722:	4745                	li	a4,17
    return 0;
    80001724:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001726:	00e68663          	beq	a3,a4,80001732 <walkaddr+0x32>
}
    8000172a:	60a2                	ld	ra,8(sp)
    8000172c:	6402                	ld	s0,0(sp)
    8000172e:	0141                	addi	sp,sp,16
    80001730:	8082                	ret
  pa = PTE2PA(*pte);
    80001732:	83a9                	srli	a5,a5,0xa
    80001734:	00c79513          	slli	a0,a5,0xc
  return pa;
    80001738:	bfcd                	j	8000172a <walkaddr+0x2a>
    return 0;
    8000173a:	4501                	li	a0,0
    8000173c:	b7fd                	j	8000172a <walkaddr+0x2a>

000000008000173e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000173e:	715d                	addi	sp,sp,-80
    80001740:	e486                	sd	ra,72(sp)
    80001742:	e0a2                	sd	s0,64(sp)
    80001744:	fc26                	sd	s1,56(sp)
    80001746:	f84a                	sd	s2,48(sp)
    80001748:	f44e                	sd	s3,40(sp)
    8000174a:	f052                	sd	s4,32(sp)
    8000174c:	ec56                	sd	s5,24(sp)
    8000174e:	e85a                	sd	s6,16(sp)
    80001750:	e45e                	sd	s7,8(sp)
    80001752:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001754:	03459793          	slli	a5,a1,0x34
    80001758:	e7a9                	bnez	a5,800017a2 <mappages+0x64>
    8000175a:	8aaa                	mv	s5,a0
    8000175c:	8b3a                	mv	s6,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000175e:	03461793          	slli	a5,a2,0x34
    80001762:	e7b1                	bnez	a5,800017ae <mappages+0x70>
    panic("mappages: size not aligned");

  if(size == 0)
    80001764:	ca39                	beqz	a2,800017ba <mappages+0x7c>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80001766:	77fd                	lui	a5,0xfffff
    80001768:	963e                	add	a2,a2,a5
    8000176a:	00b609b3          	add	s3,a2,a1
  a = va;
    8000176e:	892e                	mv	s2,a1
    80001770:	40b68a33          	sub	s4,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001774:	6b85                	lui	s7,0x1
    80001776:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    8000177a:	4605                	li	a2,1
    8000177c:	85ca                	mv	a1,s2
    8000177e:	8556                	mv	a0,s5
    80001780:	ee7ff0ef          	jal	80001666 <walk>
    80001784:	c539                	beqz	a0,800017d2 <mappages+0x94>
    if(*pte & PTE_V)
    80001786:	611c                	ld	a5,0(a0)
    80001788:	8b85                	andi	a5,a5,1
    8000178a:	ef95                	bnez	a5,800017c6 <mappages+0x88>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000178c:	80b1                	srli	s1,s1,0xc
    8000178e:	04aa                	slli	s1,s1,0xa
    80001790:	0164e4b3          	or	s1,s1,s6
    80001794:	0014e493          	ori	s1,s1,1
    80001798:	e104                	sd	s1,0(a0)
    if(a == last)
    8000179a:	05390863          	beq	s2,s3,800017ea <mappages+0xac>
    a += PGSIZE;
    8000179e:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800017a0:	bfd9                	j	80001776 <mappages+0x38>
    panic("mappages: va not aligned");
    800017a2:	00007517          	auipc	a0,0x7
    800017a6:	96650513          	addi	a0,a0,-1690 # 80008108 <etext+0x108>
    800017aa:	84eff0ef          	jal	800007f8 <panic>
    panic("mappages: size not aligned");
    800017ae:	00007517          	auipc	a0,0x7
    800017b2:	97a50513          	addi	a0,a0,-1670 # 80008128 <etext+0x128>
    800017b6:	842ff0ef          	jal	800007f8 <panic>
    panic("mappages: size");
    800017ba:	00007517          	auipc	a0,0x7
    800017be:	98e50513          	addi	a0,a0,-1650 # 80008148 <etext+0x148>
    800017c2:	836ff0ef          	jal	800007f8 <panic>
      panic("mappages: remap");
    800017c6:	00007517          	auipc	a0,0x7
    800017ca:	99250513          	addi	a0,a0,-1646 # 80008158 <etext+0x158>
    800017ce:	82aff0ef          	jal	800007f8 <panic>
      return -1;
    800017d2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800017d4:	60a6                	ld	ra,72(sp)
    800017d6:	6406                	ld	s0,64(sp)
    800017d8:	74e2                	ld	s1,56(sp)
    800017da:	7942                	ld	s2,48(sp)
    800017dc:	79a2                	ld	s3,40(sp)
    800017de:	7a02                	ld	s4,32(sp)
    800017e0:	6ae2                	ld	s5,24(sp)
    800017e2:	6b42                	ld	s6,16(sp)
    800017e4:	6ba2                	ld	s7,8(sp)
    800017e6:	6161                	addi	sp,sp,80
    800017e8:	8082                	ret
  return 0;
    800017ea:	4501                	li	a0,0
    800017ec:	b7e5                	j	800017d4 <mappages+0x96>

00000000800017ee <kvmmap>:
{
    800017ee:	1141                	addi	sp,sp,-16
    800017f0:	e406                	sd	ra,8(sp)
    800017f2:	e022                	sd	s0,0(sp)
    800017f4:	0800                	addi	s0,sp,16
    800017f6:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800017f8:	86b2                	mv	a3,a2
    800017fa:	863e                	mv	a2,a5
    800017fc:	f43ff0ef          	jal	8000173e <mappages>
    80001800:	e509                	bnez	a0,8000180a <kvmmap+0x1c>
}
    80001802:	60a2                	ld	ra,8(sp)
    80001804:	6402                	ld	s0,0(sp)
    80001806:	0141                	addi	sp,sp,16
    80001808:	8082                	ret
    panic("kvmmap");
    8000180a:	00007517          	auipc	a0,0x7
    8000180e:	95e50513          	addi	a0,a0,-1698 # 80008168 <etext+0x168>
    80001812:	fe7fe0ef          	jal	800007f8 <panic>

0000000080001816 <kvmmake>:
{
    80001816:	1101                	addi	sp,sp,-32
    80001818:	ec06                	sd	ra,24(sp)
    8000181a:	e822                	sd	s0,16(sp)
    8000181c:	e426                	sd	s1,8(sp)
    8000181e:	e04a                	sd	s2,0(sp)
    80001820:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001822:	b66ff0ef          	jal	80000b88 <kalloc>
    80001826:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001828:	6605                	lui	a2,0x1
    8000182a:	4581                	li	a1,0
    8000182c:	d00ff0ef          	jal	80000d2c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001830:	4719                	li	a4,6
    80001832:	6685                	lui	a3,0x1
    80001834:	10000637          	lui	a2,0x10000
    80001838:	100005b7          	lui	a1,0x10000
    8000183c:	8526                	mv	a0,s1
    8000183e:	fb1ff0ef          	jal	800017ee <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001842:	4719                	li	a4,6
    80001844:	6685                	lui	a3,0x1
    80001846:	10001637          	lui	a2,0x10001
    8000184a:	100015b7          	lui	a1,0x10001
    8000184e:	8526                	mv	a0,s1
    80001850:	f9fff0ef          	jal	800017ee <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001854:	4719                	li	a4,6
    80001856:	040006b7          	lui	a3,0x4000
    8000185a:	0c000637          	lui	a2,0xc000
    8000185e:	0c0005b7          	lui	a1,0xc000
    80001862:	8526                	mv	a0,s1
    80001864:	f8bff0ef          	jal	800017ee <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001868:	00006917          	auipc	s2,0x6
    8000186c:	79890913          	addi	s2,s2,1944 # 80008000 <etext>
    80001870:	4729                	li	a4,10
    80001872:	80006697          	auipc	a3,0x80006
    80001876:	78e68693          	addi	a3,a3,1934 # 8000 <_entry-0x7fff8000>
    8000187a:	4605                	li	a2,1
    8000187c:	067e                	slli	a2,a2,0x1f
    8000187e:	85b2                	mv	a1,a2
    80001880:	8526                	mv	a0,s1
    80001882:	f6dff0ef          	jal	800017ee <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001886:	46c5                	li	a3,17
    80001888:	06ee                	slli	a3,a3,0x1b
    8000188a:	4719                	li	a4,6
    8000188c:	412686b3          	sub	a3,a3,s2
    80001890:	864a                	mv	a2,s2
    80001892:	85ca                	mv	a1,s2
    80001894:	8526                	mv	a0,s1
    80001896:	f59ff0ef          	jal	800017ee <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000189a:	4729                	li	a4,10
    8000189c:	6685                	lui	a3,0x1
    8000189e:	00005617          	auipc	a2,0x5
    800018a2:	76260613          	addi	a2,a2,1890 # 80007000 <_trampoline>
    800018a6:	040005b7          	lui	a1,0x4000
    800018aa:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800018ac:	05b2                	slli	a1,a1,0xc
    800018ae:	8526                	mv	a0,s1
    800018b0:	f3fff0ef          	jal	800017ee <kvmmap>
  proc_mapstacks(kpgtbl);
    800018b4:	8526                	mv	a0,s1
    800018b6:	5da000ef          	jal	80001e90 <proc_mapstacks>
}
    800018ba:	8526                	mv	a0,s1
    800018bc:	60e2                	ld	ra,24(sp)
    800018be:	6442                	ld	s0,16(sp)
    800018c0:	64a2                	ld	s1,8(sp)
    800018c2:	6902                	ld	s2,0(sp)
    800018c4:	6105                	addi	sp,sp,32
    800018c6:	8082                	ret

00000000800018c8 <kvminit>:
{
    800018c8:	1141                	addi	sp,sp,-16
    800018ca:	e406                	sd	ra,8(sp)
    800018cc:	e022                	sd	s0,0(sp)
    800018ce:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800018d0:	f47ff0ef          	jal	80001816 <kvmmake>
    800018d4:	00007797          	auipc	a5,0x7
    800018d8:	18a7b623          	sd	a0,396(a5) # 80008a60 <kernel_pagetable>
}
    800018dc:	60a2                	ld	ra,8(sp)
    800018de:	6402                	ld	s0,0(sp)
    800018e0:	0141                	addi	sp,sp,16
    800018e2:	8082                	ret

00000000800018e4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800018e4:	715d                	addi	sp,sp,-80
    800018e6:	e486                	sd	ra,72(sp)
    800018e8:	e0a2                	sd	s0,64(sp)
    800018ea:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800018ec:	03459793          	slli	a5,a1,0x34
    800018f0:	e39d                	bnez	a5,80001916 <uvmunmap+0x32>
    800018f2:	f84a                	sd	s2,48(sp)
    800018f4:	f44e                	sd	s3,40(sp)
    800018f6:	f052                	sd	s4,32(sp)
    800018f8:	ec56                	sd	s5,24(sp)
    800018fa:	e85a                	sd	s6,16(sp)
    800018fc:	e45e                	sd	s7,8(sp)
    800018fe:	8a2a                	mv	s4,a0
    80001900:	892e                	mv	s2,a1
    80001902:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001904:	0632                	slli	a2,a2,0xc
    80001906:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    8000190a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000190c:	6b05                	lui	s6,0x1
    8000190e:	0735ff63          	bgeu	a1,s3,8000198c <uvmunmap+0xa8>
    80001912:	fc26                	sd	s1,56(sp)
    80001914:	a0a9                	j	8000195e <uvmunmap+0x7a>
    80001916:	fc26                	sd	s1,56(sp)
    80001918:	f84a                	sd	s2,48(sp)
    8000191a:	f44e                	sd	s3,40(sp)
    8000191c:	f052                	sd	s4,32(sp)
    8000191e:	ec56                	sd	s5,24(sp)
    80001920:	e85a                	sd	s6,16(sp)
    80001922:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001924:	00007517          	auipc	a0,0x7
    80001928:	84c50513          	addi	a0,a0,-1972 # 80008170 <etext+0x170>
    8000192c:	ecdfe0ef          	jal	800007f8 <panic>
      panic("uvmunmap: walk");
    80001930:	00007517          	auipc	a0,0x7
    80001934:	85850513          	addi	a0,a0,-1960 # 80008188 <etext+0x188>
    80001938:	ec1fe0ef          	jal	800007f8 <panic>
      panic("uvmunmap: not mapped");
    8000193c:	00007517          	auipc	a0,0x7
    80001940:	85c50513          	addi	a0,a0,-1956 # 80008198 <etext+0x198>
    80001944:	eb5fe0ef          	jal	800007f8 <panic>
      panic("uvmunmap: not a leaf");
    80001948:	00007517          	auipc	a0,0x7
    8000194c:	86850513          	addi	a0,a0,-1944 # 800081b0 <etext+0x1b0>
    80001950:	ea9fe0ef          	jal	800007f8 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80001954:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001958:	995a                	add	s2,s2,s6
    8000195a:	03397863          	bgeu	s2,s3,8000198a <uvmunmap+0xa6>
    if((pte = walk(pagetable, a, 0)) == 0)
    8000195e:	4601                	li	a2,0
    80001960:	85ca                	mv	a1,s2
    80001962:	8552                	mv	a0,s4
    80001964:	d03ff0ef          	jal	80001666 <walk>
    80001968:	84aa                	mv	s1,a0
    8000196a:	d179                	beqz	a0,80001930 <uvmunmap+0x4c>
    if((*pte & PTE_V) == 0)
    8000196c:	6108                	ld	a0,0(a0)
    8000196e:	00157793          	andi	a5,a0,1
    80001972:	d7e9                	beqz	a5,8000193c <uvmunmap+0x58>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001974:	3ff57793          	andi	a5,a0,1023
    80001978:	fd7788e3          	beq	a5,s7,80001948 <uvmunmap+0x64>
    if(do_free){
    8000197c:	fc0a8ce3          	beqz	s5,80001954 <uvmunmap+0x70>
      uint64 pa = PTE2PA(*pte);
    80001980:	8129                	srli	a0,a0,0xa
      kfree((void*)pa);
    80001982:	0532                	slli	a0,a0,0xc
    80001984:	922ff0ef          	jal	80000aa6 <kfree>
    80001988:	b7f1                	j	80001954 <uvmunmap+0x70>
    8000198a:	74e2                	ld	s1,56(sp)
    8000198c:	7942                	ld	s2,48(sp)
    8000198e:	79a2                	ld	s3,40(sp)
    80001990:	7a02                	ld	s4,32(sp)
    80001992:	6ae2                	ld	s5,24(sp)
    80001994:	6b42                	ld	s6,16(sp)
    80001996:	6ba2                	ld	s7,8(sp)
  }
}
    80001998:	60a6                	ld	ra,72(sp)
    8000199a:	6406                	ld	s0,64(sp)
    8000199c:	6161                	addi	sp,sp,80
    8000199e:	8082                	ret

00000000800019a0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800019a0:	1101                	addi	sp,sp,-32
    800019a2:	ec06                	sd	ra,24(sp)
    800019a4:	e822                	sd	s0,16(sp)
    800019a6:	e426                	sd	s1,8(sp)
    800019a8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800019aa:	9deff0ef          	jal	80000b88 <kalloc>
    800019ae:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800019b0:	c509                	beqz	a0,800019ba <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800019b2:	6605                	lui	a2,0x1
    800019b4:	4581                	li	a1,0
    800019b6:	b76ff0ef          	jal	80000d2c <memset>
  return pagetable;
}
    800019ba:	8526                	mv	a0,s1
    800019bc:	60e2                	ld	ra,24(sp)
    800019be:	6442                	ld	s0,16(sp)
    800019c0:	64a2                	ld	s1,8(sp)
    800019c2:	6105                	addi	sp,sp,32
    800019c4:	8082                	ret

00000000800019c6 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800019c6:	7179                	addi	sp,sp,-48
    800019c8:	f406                	sd	ra,40(sp)
    800019ca:	f022                	sd	s0,32(sp)
    800019cc:	ec26                	sd	s1,24(sp)
    800019ce:	e84a                	sd	s2,16(sp)
    800019d0:	e44e                	sd	s3,8(sp)
    800019d2:	e052                	sd	s4,0(sp)
    800019d4:	1800                	addi	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    800019d6:	6785                	lui	a5,0x1
    800019d8:	04f67063          	bgeu	a2,a5,80001a18 <uvmfirst+0x52>
    800019dc:	8a2a                	mv	s4,a0
    800019de:	89ae                	mv	s3,a1
    800019e0:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    800019e2:	9a6ff0ef          	jal	80000b88 <kalloc>
    800019e6:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800019e8:	6605                	lui	a2,0x1
    800019ea:	4581                	li	a1,0
    800019ec:	b40ff0ef          	jal	80000d2c <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    800019f0:	4779                	li	a4,30
    800019f2:	86ca                	mv	a3,s2
    800019f4:	6605                	lui	a2,0x1
    800019f6:	4581                	li	a1,0
    800019f8:	8552                	mv	a0,s4
    800019fa:	d45ff0ef          	jal	8000173e <mappages>
  memmove(mem, src, sz);
    800019fe:	8626                	mv	a2,s1
    80001a00:	85ce                	mv	a1,s3
    80001a02:	854a                	mv	a0,s2
    80001a04:	b84ff0ef          	jal	80000d88 <memmove>
}
    80001a08:	70a2                	ld	ra,40(sp)
    80001a0a:	7402                	ld	s0,32(sp)
    80001a0c:	64e2                	ld	s1,24(sp)
    80001a0e:	6942                	ld	s2,16(sp)
    80001a10:	69a2                	ld	s3,8(sp)
    80001a12:	6a02                	ld	s4,0(sp)
    80001a14:	6145                	addi	sp,sp,48
    80001a16:	8082                	ret
    panic("uvmfirst: more than a page");
    80001a18:	00006517          	auipc	a0,0x6
    80001a1c:	7b050513          	addi	a0,a0,1968 # 800081c8 <etext+0x1c8>
    80001a20:	dd9fe0ef          	jal	800007f8 <panic>

0000000080001a24 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001a24:	1101                	addi	sp,sp,-32
    80001a26:	ec06                	sd	ra,24(sp)
    80001a28:	e822                	sd	s0,16(sp)
    80001a2a:	e426                	sd	s1,8(sp)
    80001a2c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001a2e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001a30:	00b67d63          	bgeu	a2,a1,80001a4a <uvmdealloc+0x26>
    80001a34:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001a36:	6785                	lui	a5,0x1
    80001a38:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001a3a:	00f60733          	add	a4,a2,a5
    80001a3e:	76fd                	lui	a3,0xfffff
    80001a40:	8f75                	and	a4,a4,a3
    80001a42:	97ae                	add	a5,a5,a1
    80001a44:	8ff5                	and	a5,a5,a3
    80001a46:	00f76863          	bltu	a4,a5,80001a56 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001a4a:	8526                	mv	a0,s1
    80001a4c:	60e2                	ld	ra,24(sp)
    80001a4e:	6442                	ld	s0,16(sp)
    80001a50:	64a2                	ld	s1,8(sp)
    80001a52:	6105                	addi	sp,sp,32
    80001a54:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001a56:	8f99                	sub	a5,a5,a4
    80001a58:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001a5a:	4685                	li	a3,1
    80001a5c:	0007861b          	sext.w	a2,a5
    80001a60:	85ba                	mv	a1,a4
    80001a62:	e83ff0ef          	jal	800018e4 <uvmunmap>
    80001a66:	b7d5                	j	80001a4a <uvmdealloc+0x26>

0000000080001a68 <uvmalloc>:
  if(newsz < oldsz)
    80001a68:	08b66f63          	bltu	a2,a1,80001b06 <uvmalloc+0x9e>
{
    80001a6c:	7139                	addi	sp,sp,-64
    80001a6e:	fc06                	sd	ra,56(sp)
    80001a70:	f822                	sd	s0,48(sp)
    80001a72:	ec4e                	sd	s3,24(sp)
    80001a74:	e852                	sd	s4,16(sp)
    80001a76:	e456                	sd	s5,8(sp)
    80001a78:	0080                	addi	s0,sp,64
    80001a7a:	8aaa                	mv	s5,a0
    80001a7c:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001a7e:	6785                	lui	a5,0x1
    80001a80:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001a82:	95be                	add	a1,a1,a5
    80001a84:	77fd                	lui	a5,0xfffff
    80001a86:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001a8a:	08c9f063          	bgeu	s3,a2,80001b0a <uvmalloc+0xa2>
    80001a8e:	f426                	sd	s1,40(sp)
    80001a90:	f04a                	sd	s2,32(sp)
    80001a92:	e05a                	sd	s6,0(sp)
    80001a94:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001a96:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80001a9a:	8eeff0ef          	jal	80000b88 <kalloc>
    80001a9e:	84aa                	mv	s1,a0
    if(mem == 0){
    80001aa0:	c515                	beqz	a0,80001acc <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    80001aa2:	6605                	lui	a2,0x1
    80001aa4:	4581                	li	a1,0
    80001aa6:	a86ff0ef          	jal	80000d2c <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001aaa:	875a                	mv	a4,s6
    80001aac:	86a6                	mv	a3,s1
    80001aae:	6605                	lui	a2,0x1
    80001ab0:	85ca                	mv	a1,s2
    80001ab2:	8556                	mv	a0,s5
    80001ab4:	c8bff0ef          	jal	8000173e <mappages>
    80001ab8:	e915                	bnez	a0,80001aec <uvmalloc+0x84>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001aba:	6785                	lui	a5,0x1
    80001abc:	993e                	add	s2,s2,a5
    80001abe:	fd496ee3          	bltu	s2,s4,80001a9a <uvmalloc+0x32>
  return newsz;
    80001ac2:	8552                	mv	a0,s4
    80001ac4:	74a2                	ld	s1,40(sp)
    80001ac6:	7902                	ld	s2,32(sp)
    80001ac8:	6b02                	ld	s6,0(sp)
    80001aca:	a811                	j	80001ade <uvmalloc+0x76>
      uvmdealloc(pagetable, a, oldsz);
    80001acc:	864e                	mv	a2,s3
    80001ace:	85ca                	mv	a1,s2
    80001ad0:	8556                	mv	a0,s5
    80001ad2:	f53ff0ef          	jal	80001a24 <uvmdealloc>
      return 0;
    80001ad6:	4501                	li	a0,0
    80001ad8:	74a2                	ld	s1,40(sp)
    80001ada:	7902                	ld	s2,32(sp)
    80001adc:	6b02                	ld	s6,0(sp)
}
    80001ade:	70e2                	ld	ra,56(sp)
    80001ae0:	7442                	ld	s0,48(sp)
    80001ae2:	69e2                	ld	s3,24(sp)
    80001ae4:	6a42                	ld	s4,16(sp)
    80001ae6:	6aa2                	ld	s5,8(sp)
    80001ae8:	6121                	addi	sp,sp,64
    80001aea:	8082                	ret
      kfree(mem);
    80001aec:	8526                	mv	a0,s1
    80001aee:	fb9fe0ef          	jal	80000aa6 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001af2:	864e                	mv	a2,s3
    80001af4:	85ca                	mv	a1,s2
    80001af6:	8556                	mv	a0,s5
    80001af8:	f2dff0ef          	jal	80001a24 <uvmdealloc>
      return 0;
    80001afc:	4501                	li	a0,0
    80001afe:	74a2                	ld	s1,40(sp)
    80001b00:	7902                	ld	s2,32(sp)
    80001b02:	6b02                	ld	s6,0(sp)
    80001b04:	bfe9                	j	80001ade <uvmalloc+0x76>
    return oldsz;
    80001b06:	852e                	mv	a0,a1
}
    80001b08:	8082                	ret
  return newsz;
    80001b0a:	8532                	mv	a0,a2
    80001b0c:	bfc9                	j	80001ade <uvmalloc+0x76>

0000000080001b0e <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001b0e:	7179                	addi	sp,sp,-48
    80001b10:	f406                	sd	ra,40(sp)
    80001b12:	f022                	sd	s0,32(sp)
    80001b14:	ec26                	sd	s1,24(sp)
    80001b16:	e84a                	sd	s2,16(sp)
    80001b18:	e44e                	sd	s3,8(sp)
    80001b1a:	e052                	sd	s4,0(sp)
    80001b1c:	1800                	addi	s0,sp,48
    80001b1e:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001b20:	84aa                	mv	s1,a0
    80001b22:	6905                	lui	s2,0x1
    80001b24:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001b26:	4985                	li	s3,1
    80001b28:	a819                	j	80001b3e <freewalk+0x30>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001b2a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80001b2c:	00c79513          	slli	a0,a5,0xc
    80001b30:	fdfff0ef          	jal	80001b0e <freewalk>
      pagetable[i] = 0;
    80001b34:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001b38:	04a1                	addi	s1,s1,8
    80001b3a:	01248f63          	beq	s1,s2,80001b58 <freewalk+0x4a>
    pte_t pte = pagetable[i];
    80001b3e:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001b40:	00f7f713          	andi	a4,a5,15
    80001b44:	ff3703e3          	beq	a4,s3,80001b2a <freewalk+0x1c>
    } else if(pte & PTE_V){
    80001b48:	8b85                	andi	a5,a5,1
    80001b4a:	d7fd                	beqz	a5,80001b38 <freewalk+0x2a>
      panic("freewalk: leaf");
    80001b4c:	00006517          	auipc	a0,0x6
    80001b50:	69c50513          	addi	a0,a0,1692 # 800081e8 <etext+0x1e8>
    80001b54:	ca5fe0ef          	jal	800007f8 <panic>
    }
  }
  kfree((void*)pagetable);
    80001b58:	8552                	mv	a0,s4
    80001b5a:	f4dfe0ef          	jal	80000aa6 <kfree>
}
    80001b5e:	70a2                	ld	ra,40(sp)
    80001b60:	7402                	ld	s0,32(sp)
    80001b62:	64e2                	ld	s1,24(sp)
    80001b64:	6942                	ld	s2,16(sp)
    80001b66:	69a2                	ld	s3,8(sp)
    80001b68:	6a02                	ld	s4,0(sp)
    80001b6a:	6145                	addi	sp,sp,48
    80001b6c:	8082                	ret

0000000080001b6e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001b6e:	1101                	addi	sp,sp,-32
    80001b70:	ec06                	sd	ra,24(sp)
    80001b72:	e822                	sd	s0,16(sp)
    80001b74:	e426                	sd	s1,8(sp)
    80001b76:	1000                	addi	s0,sp,32
    80001b78:	84aa                	mv	s1,a0
  if(sz > 0)
    80001b7a:	e989                	bnez	a1,80001b8c <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	f91ff0ef          	jal	80001b0e <freewalk>
}
    80001b82:	60e2                	ld	ra,24(sp)
    80001b84:	6442                	ld	s0,16(sp)
    80001b86:	64a2                	ld	s1,8(sp)
    80001b88:	6105                	addi	sp,sp,32
    80001b8a:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001b8c:	6785                	lui	a5,0x1
    80001b8e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001b90:	95be                	add	a1,a1,a5
    80001b92:	4685                	li	a3,1
    80001b94:	00c5d613          	srli	a2,a1,0xc
    80001b98:	4581                	li	a1,0
    80001b9a:	d4bff0ef          	jal	800018e4 <uvmunmap>
    80001b9e:	bff9                	j	80001b7c <uvmfree+0xe>

0000000080001ba0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001ba0:	c65d                	beqz	a2,80001c4e <uvmcopy+0xae>
{
    80001ba2:	715d                	addi	sp,sp,-80
    80001ba4:	e486                	sd	ra,72(sp)
    80001ba6:	e0a2                	sd	s0,64(sp)
    80001ba8:	fc26                	sd	s1,56(sp)
    80001baa:	f84a                	sd	s2,48(sp)
    80001bac:	f44e                	sd	s3,40(sp)
    80001bae:	f052                	sd	s4,32(sp)
    80001bb0:	ec56                	sd	s5,24(sp)
    80001bb2:	e85a                	sd	s6,16(sp)
    80001bb4:	e45e                	sd	s7,8(sp)
    80001bb6:	0880                	addi	s0,sp,80
    80001bb8:	8b2a                	mv	s6,a0
    80001bba:	8aae                	mv	s5,a1
    80001bbc:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001bbe:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001bc0:	4601                	li	a2,0
    80001bc2:	85ce                	mv	a1,s3
    80001bc4:	855a                	mv	a0,s6
    80001bc6:	aa1ff0ef          	jal	80001666 <walk>
    80001bca:	c121                	beqz	a0,80001c0a <uvmcopy+0x6a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001bcc:	6118                	ld	a4,0(a0)
    80001bce:	00177793          	andi	a5,a4,1
    80001bd2:	c3b1                	beqz	a5,80001c16 <uvmcopy+0x76>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001bd4:	00a75593          	srli	a1,a4,0xa
    80001bd8:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001bdc:	3ff77493          	andi	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001be0:	fa9fe0ef          	jal	80000b88 <kalloc>
    80001be4:	892a                	mv	s2,a0
    80001be6:	c129                	beqz	a0,80001c28 <uvmcopy+0x88>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001be8:	6605                	lui	a2,0x1
    80001bea:	85de                	mv	a1,s7
    80001bec:	99cff0ef          	jal	80000d88 <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001bf0:	8726                	mv	a4,s1
    80001bf2:	86ca                	mv	a3,s2
    80001bf4:	6605                	lui	a2,0x1
    80001bf6:	85ce                	mv	a1,s3
    80001bf8:	8556                	mv	a0,s5
    80001bfa:	b45ff0ef          	jal	8000173e <mappages>
    80001bfe:	e115                	bnez	a0,80001c22 <uvmcopy+0x82>
  for(i = 0; i < sz; i += PGSIZE){
    80001c00:	6785                	lui	a5,0x1
    80001c02:	99be                	add	s3,s3,a5
    80001c04:	fb49eee3          	bltu	s3,s4,80001bc0 <uvmcopy+0x20>
    80001c08:	a805                	j	80001c38 <uvmcopy+0x98>
      panic("uvmcopy: pte should exist");
    80001c0a:	00006517          	auipc	a0,0x6
    80001c0e:	5ee50513          	addi	a0,a0,1518 # 800081f8 <etext+0x1f8>
    80001c12:	be7fe0ef          	jal	800007f8 <panic>
      panic("uvmcopy: page not present");
    80001c16:	00006517          	auipc	a0,0x6
    80001c1a:	60250513          	addi	a0,a0,1538 # 80008218 <etext+0x218>
    80001c1e:	bdbfe0ef          	jal	800007f8 <panic>
      kfree(mem);
    80001c22:	854a                	mv	a0,s2
    80001c24:	e83fe0ef          	jal	80000aa6 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001c28:	4685                	li	a3,1
    80001c2a:	00c9d613          	srli	a2,s3,0xc
    80001c2e:	4581                	li	a1,0
    80001c30:	8556                	mv	a0,s5
    80001c32:	cb3ff0ef          	jal	800018e4 <uvmunmap>
  return -1;
    80001c36:	557d                	li	a0,-1
}
    80001c38:	60a6                	ld	ra,72(sp)
    80001c3a:	6406                	ld	s0,64(sp)
    80001c3c:	74e2                	ld	s1,56(sp)
    80001c3e:	7942                	ld	s2,48(sp)
    80001c40:	79a2                	ld	s3,40(sp)
    80001c42:	7a02                	ld	s4,32(sp)
    80001c44:	6ae2                	ld	s5,24(sp)
    80001c46:	6b42                	ld	s6,16(sp)
    80001c48:	6ba2                	ld	s7,8(sp)
    80001c4a:	6161                	addi	sp,sp,80
    80001c4c:	8082                	ret
  return 0;
    80001c4e:	4501                	li	a0,0
}
    80001c50:	8082                	ret

0000000080001c52 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001c52:	1141                	addi	sp,sp,-16
    80001c54:	e406                	sd	ra,8(sp)
    80001c56:	e022                	sd	s0,0(sp)
    80001c58:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001c5a:	4601                	li	a2,0
    80001c5c:	a0bff0ef          	jal	80001666 <walk>
  if(pte == 0)
    80001c60:	c901                	beqz	a0,80001c70 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001c62:	611c                	ld	a5,0(a0)
    80001c64:	9bbd                	andi	a5,a5,-17
    80001c66:	e11c                	sd	a5,0(a0)
}
    80001c68:	60a2                	ld	ra,8(sp)
    80001c6a:	6402                	ld	s0,0(sp)
    80001c6c:	0141                	addi	sp,sp,16
    80001c6e:	8082                	ret
    panic("uvmclear");
    80001c70:	00006517          	auipc	a0,0x6
    80001c74:	5c850513          	addi	a0,a0,1480 # 80008238 <etext+0x238>
    80001c78:	b81fe0ef          	jal	800007f8 <panic>

0000000080001c7c <copyout>:
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;
  pte_t *pte;

  while(len > 0){
    80001c7c:	cad1                	beqz	a3,80001d10 <copyout+0x94>
{
    80001c7e:	711d                	addi	sp,sp,-96
    80001c80:	ec86                	sd	ra,88(sp)
    80001c82:	e8a2                	sd	s0,80(sp)
    80001c84:	e4a6                	sd	s1,72(sp)
    80001c86:	fc4e                	sd	s3,56(sp)
    80001c88:	f456                	sd	s5,40(sp)
    80001c8a:	f05a                	sd	s6,32(sp)
    80001c8c:	ec5e                	sd	s7,24(sp)
    80001c8e:	1080                	addi	s0,sp,96
    80001c90:	8baa                	mv	s7,a0
    80001c92:	8aae                	mv	s5,a1
    80001c94:	8b32                	mv	s6,a2
    80001c96:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    80001c98:	74fd                	lui	s1,0xfffff
    80001c9a:	8ced                	and	s1,s1,a1
    if(va0 >= MAXVA)
    80001c9c:	57fd                	li	a5,-1
    80001c9e:	83e9                	srli	a5,a5,0x1a
    80001ca0:	0697ea63          	bltu	a5,s1,80001d14 <copyout+0x98>
    80001ca4:	e0ca                	sd	s2,64(sp)
    80001ca6:	f852                	sd	s4,48(sp)
    80001ca8:	e862                	sd	s8,16(sp)
    80001caa:	e466                	sd	s9,8(sp)
    80001cac:	e06a                	sd	s10,0(sp)
      return -1;
    pte = walk(pagetable, va0, 0);
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001cae:	4cd5                	li	s9,21
    80001cb0:	6d05                	lui	s10,0x1
    if(va0 >= MAXVA)
    80001cb2:	8c3e                	mv	s8,a5
    80001cb4:	a025                	j	80001cdc <copyout+0x60>
       (*pte & PTE_W) == 0)
      return -1;
    pa0 = PTE2PA(*pte);
    80001cb6:	83a9                	srli	a5,a5,0xa
    80001cb8:	07b2                	slli	a5,a5,0xc
    n = PGSIZE - (dstva - va0);
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001cba:	409a8533          	sub	a0,s5,s1
    80001cbe:	0009061b          	sext.w	a2,s2
    80001cc2:	85da                	mv	a1,s6
    80001cc4:	953e                	add	a0,a0,a5
    80001cc6:	8c2ff0ef          	jal	80000d88 <memmove>

    len -= n;
    80001cca:	412989b3          	sub	s3,s3,s2
    src += n;
    80001cce:	9b4a                	add	s6,s6,s2
  while(len > 0){
    80001cd0:	02098963          	beqz	s3,80001d02 <copyout+0x86>
    if(va0 >= MAXVA)
    80001cd4:	054c6263          	bltu	s8,s4,80001d18 <copyout+0x9c>
    80001cd8:	84d2                	mv	s1,s4
    80001cda:	8ad2                	mv	s5,s4
    pte = walk(pagetable, va0, 0);
    80001cdc:	4601                	li	a2,0
    80001cde:	85a6                	mv	a1,s1
    80001ce0:	855e                	mv	a0,s7
    80001ce2:	985ff0ef          	jal	80001666 <walk>
    if(pte == 0 || (*pte & PTE_V) == 0 || (*pte & PTE_U) == 0 ||
    80001ce6:	c121                	beqz	a0,80001d26 <copyout+0xaa>
    80001ce8:	611c                	ld	a5,0(a0)
    80001cea:	0157f713          	andi	a4,a5,21
    80001cee:	05971b63          	bne	a4,s9,80001d44 <copyout+0xc8>
    n = PGSIZE - (dstva - va0);
    80001cf2:	01a48a33          	add	s4,s1,s10
    80001cf6:	415a0933          	sub	s2,s4,s5
    if(n > len)
    80001cfa:	fb29fee3          	bgeu	s3,s2,80001cb6 <copyout+0x3a>
    80001cfe:	894e                	mv	s2,s3
    80001d00:	bf5d                	j	80001cb6 <copyout+0x3a>
    dstva = va0 + PGSIZE;
  }
  return 0;
    80001d02:	4501                	li	a0,0
    80001d04:	6906                	ld	s2,64(sp)
    80001d06:	7a42                	ld	s4,48(sp)
    80001d08:	6c42                	ld	s8,16(sp)
    80001d0a:	6ca2                	ld	s9,8(sp)
    80001d0c:	6d02                	ld	s10,0(sp)
    80001d0e:	a015                	j	80001d32 <copyout+0xb6>
    80001d10:	4501                	li	a0,0
}
    80001d12:	8082                	ret
      return -1;
    80001d14:	557d                	li	a0,-1
    80001d16:	a831                	j	80001d32 <copyout+0xb6>
    80001d18:	557d                	li	a0,-1
    80001d1a:	6906                	ld	s2,64(sp)
    80001d1c:	7a42                	ld	s4,48(sp)
    80001d1e:	6c42                	ld	s8,16(sp)
    80001d20:	6ca2                	ld	s9,8(sp)
    80001d22:	6d02                	ld	s10,0(sp)
    80001d24:	a039                	j	80001d32 <copyout+0xb6>
      return -1;
    80001d26:	557d                	li	a0,-1
    80001d28:	6906                	ld	s2,64(sp)
    80001d2a:	7a42                	ld	s4,48(sp)
    80001d2c:	6c42                	ld	s8,16(sp)
    80001d2e:	6ca2                	ld	s9,8(sp)
    80001d30:	6d02                	ld	s10,0(sp)
}
    80001d32:	60e6                	ld	ra,88(sp)
    80001d34:	6446                	ld	s0,80(sp)
    80001d36:	64a6                	ld	s1,72(sp)
    80001d38:	79e2                	ld	s3,56(sp)
    80001d3a:	7aa2                	ld	s5,40(sp)
    80001d3c:	7b02                	ld	s6,32(sp)
    80001d3e:	6be2                	ld	s7,24(sp)
    80001d40:	6125                	addi	sp,sp,96
    80001d42:	8082                	ret
      return -1;
    80001d44:	557d                	li	a0,-1
    80001d46:	6906                	ld	s2,64(sp)
    80001d48:	7a42                	ld	s4,48(sp)
    80001d4a:	6c42                	ld	s8,16(sp)
    80001d4c:	6ca2                	ld	s9,8(sp)
    80001d4e:	6d02                	ld	s10,0(sp)
    80001d50:	b7cd                	j	80001d32 <copyout+0xb6>

0000000080001d52 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    80001d52:	c6a5                	beqz	a3,80001dba <copyin+0x68>
{
    80001d54:	715d                	addi	sp,sp,-80
    80001d56:	e486                	sd	ra,72(sp)
    80001d58:	e0a2                	sd	s0,64(sp)
    80001d5a:	fc26                	sd	s1,56(sp)
    80001d5c:	f84a                	sd	s2,48(sp)
    80001d5e:	f44e                	sd	s3,40(sp)
    80001d60:	f052                	sd	s4,32(sp)
    80001d62:	ec56                	sd	s5,24(sp)
    80001d64:	e85a                	sd	s6,16(sp)
    80001d66:	e45e                	sd	s7,8(sp)
    80001d68:	e062                	sd	s8,0(sp)
    80001d6a:	0880                	addi	s0,sp,80
    80001d6c:	8b2a                	mv	s6,a0
    80001d6e:	8a2e                	mv	s4,a1
    80001d70:	8c32                	mv	s8,a2
    80001d72:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80001d74:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001d76:	6a85                	lui	s5,0x1
    80001d78:	a00d                	j	80001d9a <copyin+0x48>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001d7a:	018505b3          	add	a1,a0,s8
    80001d7e:	0004861b          	sext.w	a2,s1
    80001d82:	412585b3          	sub	a1,a1,s2
    80001d86:	8552                	mv	a0,s4
    80001d88:	800ff0ef          	jal	80000d88 <memmove>

    len -= n;
    80001d8c:	409989b3          	sub	s3,s3,s1
    dst += n;
    80001d90:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    80001d92:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80001d96:	02098063          	beqz	s3,80001db6 <copyin+0x64>
    va0 = PGROUNDDOWN(srcva);
    80001d9a:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001d9e:	85ca                	mv	a1,s2
    80001da0:	855a                	mv	a0,s6
    80001da2:	95fff0ef          	jal	80001700 <walkaddr>
    if(pa0 == 0)
    80001da6:	cd01                	beqz	a0,80001dbe <copyin+0x6c>
    n = PGSIZE - (srcva - va0);
    80001da8:	418904b3          	sub	s1,s2,s8
    80001dac:	94d6                	add	s1,s1,s5
    if(n > len)
    80001dae:	fc99f6e3          	bgeu	s3,s1,80001d7a <copyin+0x28>
    80001db2:	84ce                	mv	s1,s3
    80001db4:	b7d9                	j	80001d7a <copyin+0x28>
  }
  return 0;
    80001db6:	4501                	li	a0,0
    80001db8:	a021                	j	80001dc0 <copyin+0x6e>
    80001dba:	4501                	li	a0,0
}
    80001dbc:	8082                	ret
      return -1;
    80001dbe:	557d                	li	a0,-1
}
    80001dc0:	60a6                	ld	ra,72(sp)
    80001dc2:	6406                	ld	s0,64(sp)
    80001dc4:	74e2                	ld	s1,56(sp)
    80001dc6:	7942                	ld	s2,48(sp)
    80001dc8:	79a2                	ld	s3,40(sp)
    80001dca:	7a02                	ld	s4,32(sp)
    80001dcc:	6ae2                	ld	s5,24(sp)
    80001dce:	6b42                	ld	s6,16(sp)
    80001dd0:	6ba2                	ld	s7,8(sp)
    80001dd2:	6c02                	ld	s8,0(sp)
    80001dd4:	6161                	addi	sp,sp,80
    80001dd6:	8082                	ret

0000000080001dd8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80001dd8:	c6dd                	beqz	a3,80001e86 <copyinstr+0xae>
{
    80001dda:	715d                	addi	sp,sp,-80
    80001ddc:	e486                	sd	ra,72(sp)
    80001dde:	e0a2                	sd	s0,64(sp)
    80001de0:	fc26                	sd	s1,56(sp)
    80001de2:	f84a                	sd	s2,48(sp)
    80001de4:	f44e                	sd	s3,40(sp)
    80001de6:	f052                	sd	s4,32(sp)
    80001de8:	ec56                	sd	s5,24(sp)
    80001dea:	e85a                	sd	s6,16(sp)
    80001dec:	e45e                	sd	s7,8(sp)
    80001dee:	0880                	addi	s0,sp,80
    80001df0:	8a2a                	mv	s4,a0
    80001df2:	8b2e                	mv	s6,a1
    80001df4:	8bb2                	mv	s7,a2
    80001df6:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80001df8:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001dfa:	6985                	lui	s3,0x1
    80001dfc:	a825                	j	80001e34 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80001dfe:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80001e02:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80001e04:	37fd                	addiw	a5,a5,-1
    80001e06:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001e0a:	60a6                	ld	ra,72(sp)
    80001e0c:	6406                	ld	s0,64(sp)
    80001e0e:	74e2                	ld	s1,56(sp)
    80001e10:	7942                	ld	s2,48(sp)
    80001e12:	79a2                	ld	s3,40(sp)
    80001e14:	7a02                	ld	s4,32(sp)
    80001e16:	6ae2                	ld	s5,24(sp)
    80001e18:	6b42                	ld	s6,16(sp)
    80001e1a:	6ba2                	ld	s7,8(sp)
    80001e1c:	6161                	addi	sp,sp,80
    80001e1e:	8082                	ret
    80001e20:	fff90713          	addi	a4,s2,-1 # fff <_entry-0x7ffff001>
    80001e24:	9742                	add	a4,a4,a6
      --max;
    80001e26:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80001e2a:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    80001e2e:	04e58463          	beq	a1,a4,80001e76 <copyinstr+0x9e>
{
    80001e32:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80001e34:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001e38:	85a6                	mv	a1,s1
    80001e3a:	8552                	mv	a0,s4
    80001e3c:	8c5ff0ef          	jal	80001700 <walkaddr>
    if(pa0 == 0)
    80001e40:	cd0d                	beqz	a0,80001e7a <copyinstr+0xa2>
    n = PGSIZE - (srcva - va0);
    80001e42:	417486b3          	sub	a3,s1,s7
    80001e46:	96ce                	add	a3,a3,s3
    if(n > max)
    80001e48:	00d97363          	bgeu	s2,a3,80001e4e <copyinstr+0x76>
    80001e4c:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    80001e4e:	955e                	add	a0,a0,s7
    80001e50:	8d05                	sub	a0,a0,s1
    while(n > 0){
    80001e52:	c695                	beqz	a3,80001e7e <copyinstr+0xa6>
    80001e54:	87da                	mv	a5,s6
    80001e56:	885a                	mv	a6,s6
      if(*p == '\0'){
    80001e58:	41650633          	sub	a2,a0,s6
    while(n > 0){
    80001e5c:	96da                	add	a3,a3,s6
    80001e5e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80001e60:	00f60733          	add	a4,a2,a5
    80001e64:	00074703          	lbu	a4,0(a4)
    80001e68:	db59                	beqz	a4,80001dfe <copyinstr+0x26>
        *dst = *p;
    80001e6a:	00e78023          	sb	a4,0(a5)
      dst++;
    80001e6e:	0785                	addi	a5,a5,1
    while(n > 0){
    80001e70:	fed797e3          	bne	a5,a3,80001e5e <copyinstr+0x86>
    80001e74:	b775                	j	80001e20 <copyinstr+0x48>
    80001e76:	4781                	li	a5,0
    80001e78:	b771                	j	80001e04 <copyinstr+0x2c>
      return -1;
    80001e7a:	557d                	li	a0,-1
    80001e7c:	b779                	j	80001e0a <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    80001e7e:	6b85                	lui	s7,0x1
    80001e80:	9ba6                	add	s7,s7,s1
    80001e82:	87da                	mv	a5,s6
    80001e84:	b77d                	j	80001e32 <copyinstr+0x5a>
  int got_null = 0;
    80001e86:	4781                	li	a5,0
  if(got_null){
    80001e88:	37fd                	addiw	a5,a5,-1
    80001e8a:	0007851b          	sext.w	a0,a5
}
    80001e8e:	8082                	ret

0000000080001e90 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80001e90:	7139                	addi	sp,sp,-64
    80001e92:	fc06                	sd	ra,56(sp)
    80001e94:	f822                	sd	s0,48(sp)
    80001e96:	f426                	sd	s1,40(sp)
    80001e98:	f04a                	sd	s2,32(sp)
    80001e9a:	ec4e                	sd	s3,24(sp)
    80001e9c:	e852                	sd	s4,16(sp)
    80001e9e:	e456                	sd	s5,8(sp)
    80001ea0:	e05a                	sd	s6,0(sp)
    80001ea2:	0080                	addi	s0,sp,64
    80001ea4:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ea6:	001a2497          	auipc	s1,0x1a2
    80001eaa:	64248493          	addi	s1,s1,1602 # 801a44e8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80001eae:	8b26                	mv	s6,s1
    80001eb0:	fcf3d937          	lui	s2,0xfcf3d
    80001eb4:	f3d90913          	addi	s2,s2,-195 # fffffffffcf3cf3d <end+0xffffffff7cd82e5d>
    80001eb8:	0932                	slli	s2,s2,0xc
    80001eba:	f3d90913          	addi	s2,s2,-195
    80001ebe:	0932                	slli	s2,s2,0xc
    80001ec0:	f3d90913          	addi	s2,s2,-195
    80001ec4:	0932                	slli	s2,s2,0xc
    80001ec6:	f3d90913          	addi	s2,s2,-195
    80001eca:	040009b7          	lui	s3,0x4000
    80001ece:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001ed0:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ed2:	001ada97          	auipc	s5,0x1ad
    80001ed6:	e16a8a93          	addi	s5,s5,-490 # 801aece8 <proc_lock>
    char *pa = kalloc();
    80001eda:	caffe0ef          	jal	80000b88 <kalloc>
    80001ede:	862a                	mv	a2,a0
    if(pa == 0)
    80001ee0:	cd15                	beqz	a0,80001f1c <proc_mapstacks+0x8c>
    uint64 va = KSTACK((int) (p - proc));
    80001ee2:	416485b3          	sub	a1,s1,s6
    80001ee6:	8595                	srai	a1,a1,0x5
    80001ee8:	032585b3          	mul	a1,a1,s2
    80001eec:	2585                	addiw	a1,a1,1
    80001eee:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ef2:	4719                	li	a4,6
    80001ef4:	6685                	lui	a3,0x1
    80001ef6:	40b985b3          	sub	a1,s3,a1
    80001efa:	8552                	mv	a0,s4
    80001efc:	8f3ff0ef          	jal	800017ee <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f00:	2a048493          	addi	s1,s1,672
    80001f04:	fd549be3          	bne	s1,s5,80001eda <proc_mapstacks+0x4a>
  }
}
    80001f08:	70e2                	ld	ra,56(sp)
    80001f0a:	7442                	ld	s0,48(sp)
    80001f0c:	74a2                	ld	s1,40(sp)
    80001f0e:	7902                	ld	s2,32(sp)
    80001f10:	69e2                	ld	s3,24(sp)
    80001f12:	6a42                	ld	s4,16(sp)
    80001f14:	6aa2                	ld	s5,8(sp)
    80001f16:	6b02                	ld	s6,0(sp)
    80001f18:	6121                	addi	sp,sp,64
    80001f1a:	8082                	ret
      panic("kalloc");
    80001f1c:	00006517          	auipc	a0,0x6
    80001f20:	32c50513          	addi	a0,a0,812 # 80008248 <etext+0x248>
    80001f24:	8d5fe0ef          	jal	800007f8 <panic>

0000000080001f28 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001f28:	715d                	addi	sp,sp,-80
    80001f2a:	e486                	sd	ra,72(sp)
    80001f2c:	e0a2                	sd	s0,64(sp)
    80001f2e:	fc26                	sd	s1,56(sp)
    80001f30:	f84a                	sd	s2,48(sp)
    80001f32:	f44e                	sd	s3,40(sp)
    80001f34:	f052                	sd	s4,32(sp)
    80001f36:	ec56                	sd	s5,24(sp)
    80001f38:	e85a                	sd	s6,16(sp)
    80001f3a:	e45e                	sd	s7,8(sp)
    80001f3c:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001f3e:	00006597          	auipc	a1,0x6
    80001f42:	31258593          	addi	a1,a1,786 # 80008250 <etext+0x250>
    80001f46:	001a2517          	auipc	a0,0x1a2
    80001f4a:	17250513          	addi	a0,a0,370 # 801a40b8 <pid_lock>
    80001f4e:	c8bfe0ef          	jal	80000bd8 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001f52:	00006597          	auipc	a1,0x6
    80001f56:	30658593          	addi	a1,a1,774 # 80008258 <etext+0x258>
    80001f5a:	001a2517          	auipc	a0,0x1a2
    80001f5e:	17650513          	addi	a0,a0,374 # 801a40d0 <wait_lock>
    80001f62:	c77fe0ef          	jal	80000bd8 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001f66:	001a2497          	auipc	s1,0x1a2
    80001f6a:	7fa48493          	addi	s1,s1,2042 # 801a4760 <proc+0x278>
    80001f6e:	001a2917          	auipc	s2,0x1a2
    80001f72:	57a90913          	addi	s2,s2,1402 # 801a44e8 <proc>
      initlock(&p->lock, "proc");
    80001f76:	00006b97          	auipc	s7,0x6
    80001f7a:	2f2b8b93          	addi	s7,s7,754 # 80008268 <etext+0x268>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001f7e:	8b4a                	mv	s6,s2
    80001f80:	fcf3d9b7          	lui	s3,0xfcf3d
    80001f84:	f3d98993          	addi	s3,s3,-195 # fffffffffcf3cf3d <end+0xffffffff7cd82e5d>
    80001f88:	09b2                	slli	s3,s3,0xc
    80001f8a:	f3d98993          	addi	s3,s3,-195
    80001f8e:	09b2                	slli	s3,s3,0xc
    80001f90:	f3d98993          	addi	s3,s3,-195
    80001f94:	09b2                	slli	s3,s3,0xc
    80001f96:	f3d98993          	addi	s3,s3,-195
    80001f9a:	04000a37          	lui	s4,0x4000
    80001f9e:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    80001fa0:	0a32                	slli	s4,s4,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001fa2:	001ada97          	auipc	s5,0x1ad
    80001fa6:	d46a8a93          	addi	s5,s5,-698 # 801aece8 <proc_lock>
    80001faa:	a039                	j	80001fb8 <procinit+0x90>
    80001fac:	2a090913          	addi	s2,s2,672
    80001fb0:	2a048493          	addi	s1,s1,672
    80001fb4:	03590c63          	beq	s2,s5,80001fec <procinit+0xc4>
      initlock(&p->lock, "proc");
    80001fb8:	85de                	mv	a1,s7
    80001fba:	854a                	mv	a0,s2
    80001fbc:	c1dfe0ef          	jal	80000bd8 <initlock>
      p->state = UNUSED;
    80001fc0:	00092c23          	sw	zero,24(s2)
      p->kstack = KSTACK((int) (p - proc));
    80001fc4:	416907b3          	sub	a5,s2,s6
    80001fc8:	8795                	srai	a5,a5,0x5
    80001fca:	033787b3          	mul	a5,a5,s3
    80001fce:	2785                	addiw	a5,a5,1
    80001fd0:	00d7979b          	slliw	a5,a5,0xd
    80001fd4:	40fa07b3          	sub	a5,s4,a5
    80001fd8:	04f93023          	sd	a5,64(s2)
      // printf("\nInit sighandlers to NULL\n");
      for (int i = 0; i < 32; i++) {
    80001fdc:	17890793          	addi	a5,s2,376
        p->sig_handlers[i] = 0;  // Initialize handlers to NULL
    80001fe0:	0007b023          	sd	zero,0(a5)
      for (int i = 0; i < 32; i++) {
    80001fe4:	07a1                	addi	a5,a5,8
    80001fe6:	fe979de3          	bne	a5,s1,80001fe0 <procinit+0xb8>
    80001fea:	b7c9                	j	80001fac <procinit+0x84>
      }
  }
}
    80001fec:	60a6                	ld	ra,72(sp)
    80001fee:	6406                	ld	s0,64(sp)
    80001ff0:	74e2                	ld	s1,56(sp)
    80001ff2:	7942                	ld	s2,48(sp)
    80001ff4:	79a2                	ld	s3,40(sp)
    80001ff6:	7a02                	ld	s4,32(sp)
    80001ff8:	6ae2                	ld	s5,24(sp)
    80001ffa:	6b42                	ld	s6,16(sp)
    80001ffc:	6ba2                	ld	s7,8(sp)
    80001ffe:	6161                	addi	sp,sp,80
    80002000:	8082                	ret

0000000080002002 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80002002:	1141                	addi	sp,sp,-16
    80002004:	e422                	sd	s0,8(sp)
    80002006:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80002008:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    8000200a:	2501                	sext.w	a0,a0
    8000200c:	6422                	ld	s0,8(sp)
    8000200e:	0141                	addi	sp,sp,16
    80002010:	8082                	ret

0000000080002012 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80002012:	1141                	addi	sp,sp,-16
    80002014:	e422                	sd	s0,8(sp)
    80002016:	0800                	addi	s0,sp,16
    80002018:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000201a:	2781                	sext.w	a5,a5
    8000201c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000201e:	001a2517          	auipc	a0,0x1a2
    80002022:	0ca50513          	addi	a0,a0,202 # 801a40e8 <cpus>
    80002026:	953e                	add	a0,a0,a5
    80002028:	6422                	ld	s0,8(sp)
    8000202a:	0141                	addi	sp,sp,16
    8000202c:	8082                	ret

000000008000202e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000202e:	1101                	addi	sp,sp,-32
    80002030:	ec06                	sd	ra,24(sp)
    80002032:	e822                	sd	s0,16(sp)
    80002034:	e426                	sd	s1,8(sp)
    80002036:	1000                	addi	s0,sp,32
  push_off();
    80002038:	be1fe0ef          	jal	80000c18 <push_off>
    8000203c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000203e:	2781                	sext.w	a5,a5
    80002040:	079e                	slli	a5,a5,0x7
    80002042:	001a2717          	auipc	a4,0x1a2
    80002046:	07670713          	addi	a4,a4,118 # 801a40b8 <pid_lock>
    8000204a:	97ba                	add	a5,a5,a4
    8000204c:	7b84                	ld	s1,48(a5)
  pop_off();
    8000204e:	c4ffe0ef          	jal	80000c9c <pop_off>
  return p;
}
    80002052:	8526                	mv	a0,s1
    80002054:	60e2                	ld	ra,24(sp)
    80002056:	6442                	ld	s0,16(sp)
    80002058:	64a2                	ld	s1,8(sp)
    8000205a:	6105                	addi	sp,sp,32
    8000205c:	8082                	ret

000000008000205e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000205e:	1141                	addi	sp,sp,-16
    80002060:	e406                	sd	ra,8(sp)
    80002062:	e022                	sd	s0,0(sp)
    80002064:	0800                	addi	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    80002066:	fc9ff0ef          	jal	8000202e <myproc>
    8000206a:	c87fe0ef          	jal	80000cf0 <release>

  if (first) {
    8000206e:	00007797          	auipc	a5,0x7
    80002072:	9827a783          	lw	a5,-1662(a5) # 800089f0 <first.1>
    80002076:	e799                	bnez	a5,80002084 <forkret+0x26>
    first = 0;
    // ensure other cores see first=0.
    __sync_synchronize();
  }

  usertrapret();
    80002078:	561000ef          	jal	80002dd8 <usertrapret>
}
    8000207c:	60a2                	ld	ra,8(sp)
    8000207e:	6402                	ld	s0,0(sp)
    80002080:	0141                	addi	sp,sp,16
    80002082:	8082                	ret
    fsinit(ROOTDEV);
    80002084:	4505                	li	a0,1
    80002086:	2b5010ef          	jal	80003b3a <fsinit>
    first = 0;
    8000208a:	00007797          	auipc	a5,0x7
    8000208e:	9607a323          	sw	zero,-1690(a5) # 800089f0 <first.1>
    __sync_synchronize();
    80002092:	0ff0000f          	fence
    80002096:	b7cd                	j	80002078 <forkret+0x1a>

0000000080002098 <allocpid>:
{
    80002098:	1101                	addi	sp,sp,-32
    8000209a:	ec06                	sd	ra,24(sp)
    8000209c:	e822                	sd	s0,16(sp)
    8000209e:	e426                	sd	s1,8(sp)
    800020a0:	e04a                	sd	s2,0(sp)
    800020a2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800020a4:	001a2917          	auipc	s2,0x1a2
    800020a8:	01490913          	addi	s2,s2,20 # 801a40b8 <pid_lock>
    800020ac:	854a                	mv	a0,s2
    800020ae:	babfe0ef          	jal	80000c58 <acquire>
  pid = nextpid;
    800020b2:	00007797          	auipc	a5,0x7
    800020b6:	94278793          	addi	a5,a5,-1726 # 800089f4 <nextpid>
    800020ba:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800020bc:	0014871b          	addiw	a4,s1,1
    800020c0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800020c2:	854a                	mv	a0,s2
    800020c4:	c2dfe0ef          	jal	80000cf0 <release>
}
    800020c8:	8526                	mv	a0,s1
    800020ca:	60e2                	ld	ra,24(sp)
    800020cc:	6442                	ld	s0,16(sp)
    800020ce:	64a2                	ld	s1,8(sp)
    800020d0:	6902                	ld	s2,0(sp)
    800020d2:	6105                	addi	sp,sp,32
    800020d4:	8082                	ret

00000000800020d6 <proc_pagetable>:
{
    800020d6:	1101                	addi	sp,sp,-32
    800020d8:	ec06                	sd	ra,24(sp)
    800020da:	e822                	sd	s0,16(sp)
    800020dc:	e426                	sd	s1,8(sp)
    800020de:	e04a                	sd	s2,0(sp)
    800020e0:	1000                	addi	s0,sp,32
    800020e2:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800020e4:	8bdff0ef          	jal	800019a0 <uvmcreate>
    800020e8:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800020ea:	cd05                	beqz	a0,80002122 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    800020ec:	4729                	li	a4,10
    800020ee:	00005697          	auipc	a3,0x5
    800020f2:	f1268693          	addi	a3,a3,-238 # 80007000 <_trampoline>
    800020f6:	6605                	lui	a2,0x1
    800020f8:	040005b7          	lui	a1,0x4000
    800020fc:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800020fe:	05b2                	slli	a1,a1,0xc
    80002100:	e3eff0ef          	jal	8000173e <mappages>
    80002104:	02054663          	bltz	a0,80002130 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002108:	4719                	li	a4,6
    8000210a:	06093683          	ld	a3,96(s2)
    8000210e:	6605                	lui	a2,0x1
    80002110:	020005b7          	lui	a1,0x2000
    80002114:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002116:	05b6                	slli	a1,a1,0xd
    80002118:	8526                	mv	a0,s1
    8000211a:	e24ff0ef          	jal	8000173e <mappages>
    8000211e:	00054f63          	bltz	a0,8000213c <proc_pagetable+0x66>
}
    80002122:	8526                	mv	a0,s1
    80002124:	60e2                	ld	ra,24(sp)
    80002126:	6442                	ld	s0,16(sp)
    80002128:	64a2                	ld	s1,8(sp)
    8000212a:	6902                	ld	s2,0(sp)
    8000212c:	6105                	addi	sp,sp,32
    8000212e:	8082                	ret
    uvmfree(pagetable, 0);
    80002130:	4581                	li	a1,0
    80002132:	8526                	mv	a0,s1
    80002134:	a3bff0ef          	jal	80001b6e <uvmfree>
    return 0;
    80002138:	4481                	li	s1,0
    8000213a:	b7e5                	j	80002122 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000213c:	4681                	li	a3,0
    8000213e:	4605                	li	a2,1
    80002140:	040005b7          	lui	a1,0x4000
    80002144:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002146:	05b2                	slli	a1,a1,0xc
    80002148:	8526                	mv	a0,s1
    8000214a:	f9aff0ef          	jal	800018e4 <uvmunmap>
    uvmfree(pagetable, 0);
    8000214e:	4581                	li	a1,0
    80002150:	8526                	mv	a0,s1
    80002152:	a1dff0ef          	jal	80001b6e <uvmfree>
    return 0;
    80002156:	4481                	li	s1,0
    80002158:	b7e9                	j	80002122 <proc_pagetable+0x4c>

000000008000215a <proc_freepagetable>:
{
    8000215a:	1101                	addi	sp,sp,-32
    8000215c:	ec06                	sd	ra,24(sp)
    8000215e:	e822                	sd	s0,16(sp)
    80002160:	e426                	sd	s1,8(sp)
    80002162:	e04a                	sd	s2,0(sp)
    80002164:	1000                	addi	s0,sp,32
    80002166:	84aa                	mv	s1,a0
    80002168:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000216a:	4681                	li	a3,0
    8000216c:	4605                	li	a2,1
    8000216e:	040005b7          	lui	a1,0x4000
    80002172:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002174:	05b2                	slli	a1,a1,0xc
    80002176:	f6eff0ef          	jal	800018e4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000217a:	4681                	li	a3,0
    8000217c:	4605                	li	a2,1
    8000217e:	020005b7          	lui	a1,0x2000
    80002182:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002184:	05b6                	slli	a1,a1,0xd
    80002186:	8526                	mv	a0,s1
    80002188:	f5cff0ef          	jal	800018e4 <uvmunmap>
  uvmfree(pagetable, sz);
    8000218c:	85ca                	mv	a1,s2
    8000218e:	8526                	mv	a0,s1
    80002190:	9dfff0ef          	jal	80001b6e <uvmfree>
}
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	64a2                	ld	s1,8(sp)
    8000219a:	6902                	ld	s2,0(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret

00000000800021a0 <freeproc>:
{
    800021a0:	1101                	addi	sp,sp,-32
    800021a2:	ec06                	sd	ra,24(sp)
    800021a4:	e822                	sd	s0,16(sp)
    800021a6:	e426                	sd	s1,8(sp)
    800021a8:	1000                	addi	s0,sp,32
    800021aa:	84aa                	mv	s1,a0
  if(p->trapframe)
    800021ac:	7128                	ld	a0,96(a0)
    800021ae:	c119                	beqz	a0,800021b4 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800021b0:	8f7fe0ef          	jal	80000aa6 <kfree>
  p->trapframe = 0;
    800021b4:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    800021b8:	6ca8                	ld	a0,88(s1)
    800021ba:	c501                	beqz	a0,800021c2 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800021bc:	68ac                	ld	a1,80(s1)
    800021be:	f9dff0ef          	jal	8000215a <proc_freepagetable>
  p->pagetable = 0;
    800021c2:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    800021c6:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    800021ca:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800021ce:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800021d2:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800021d6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800021da:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800021de:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800021e2:	0004ac23          	sw	zero,24(s1)
  if(p->is_thread && p->stack) {
    800021e6:	2784a783          	lw	a5,632(s1)
    800021ea:	cb81                	beqz	a5,800021fa <freeproc+0x5a>
    800021ec:	2804b503          	ld	a0,640(s1)
    800021f0:	c509                	beqz	a0,800021fa <freeproc+0x5a>
    kfree(p->stack);
    800021f2:	8b5fe0ef          	jal	80000aa6 <kfree>
    p->stack = 0;
    800021f6:	2804b023          	sd	zero,640(s1)
  p->is_thread = 0;
    800021fa:	2604ac23          	sw	zero,632(s1)
  p->thread_parent = 0;
    800021fe:	2804b423          	sd	zero,648(s1)
}
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6105                	addi	sp,sp,32
    8000220a:	8082                	ret

000000008000220c <allocproc>:
{
    8000220c:	1101                	addi	sp,sp,-32
    8000220e:	ec06                	sd	ra,24(sp)
    80002210:	e822                	sd	s0,16(sp)
    80002212:	e426                	sd	s1,8(sp)
    80002214:	e04a                	sd	s2,0(sp)
    80002216:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80002218:	001a2497          	auipc	s1,0x1a2
    8000221c:	2d048493          	addi	s1,s1,720 # 801a44e8 <proc>
    80002220:	001ad917          	auipc	s2,0x1ad
    80002224:	ac890913          	addi	s2,s2,-1336 # 801aece8 <proc_lock>
    acquire(&p->lock);
    80002228:	8526                	mv	a0,s1
    8000222a:	a2ffe0ef          	jal	80000c58 <acquire>
    if(p->state == UNUSED) {
    8000222e:	4c9c                	lw	a5,24(s1)
    80002230:	cb91                	beqz	a5,80002244 <allocproc+0x38>
      release(&p->lock);
    80002232:	8526                	mv	a0,s1
    80002234:	abdfe0ef          	jal	80000cf0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002238:	2a048493          	addi	s1,s1,672
    8000223c:	ff2496e3          	bne	s1,s2,80002228 <allocproc+0x1c>
  return 0;
    80002240:	4481                	li	s1,0
    80002242:	a089                	j	80002284 <allocproc+0x78>
  p->pid = allocpid();
    80002244:	e55ff0ef          	jal	80002098 <allocpid>
    80002248:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000224a:	4785                	li	a5,1
    8000224c:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000224e:	93bfe0ef          	jal	80000b88 <kalloc>
    80002252:	892a                	mv	s2,a0
    80002254:	f0a8                	sd	a0,96(s1)
    80002256:	cd15                	beqz	a0,80002292 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80002258:	8526                	mv	a0,s1
    8000225a:	e7dff0ef          	jal	800020d6 <proc_pagetable>
    8000225e:	892a                	mv	s2,a0
    80002260:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    80002262:	c121                	beqz	a0,800022a2 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80002264:	07000613          	li	a2,112
    80002268:	4581                	li	a1,0
    8000226a:	06848513          	addi	a0,s1,104
    8000226e:	abffe0ef          	jal	80000d2c <memset>
  p->context.ra = (uint64)forkret;
    80002272:	00000797          	auipc	a5,0x0
    80002276:	dec78793          	addi	a5,a5,-532 # 8000205e <forkret>
    8000227a:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000227c:	60bc                	ld	a5,64(s1)
    8000227e:	6705                	lui	a4,0x1
    80002280:	97ba                	add	a5,a5,a4
    80002282:	f8bc                	sd	a5,112(s1)
}
    80002284:	8526                	mv	a0,s1
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	64a2                	ld	s1,8(sp)
    8000228c:	6902                	ld	s2,0(sp)
    8000228e:	6105                	addi	sp,sp,32
    80002290:	8082                	ret
    freeproc(p);
    80002292:	8526                	mv	a0,s1
    80002294:	f0dff0ef          	jal	800021a0 <freeproc>
    release(&p->lock);
    80002298:	8526                	mv	a0,s1
    8000229a:	a57fe0ef          	jal	80000cf0 <release>
    return 0;
    8000229e:	84ca                	mv	s1,s2
    800022a0:	b7d5                	j	80002284 <allocproc+0x78>
    freeproc(p);
    800022a2:	8526                	mv	a0,s1
    800022a4:	efdff0ef          	jal	800021a0 <freeproc>
    release(&p->lock);
    800022a8:	8526                	mv	a0,s1
    800022aa:	a47fe0ef          	jal	80000cf0 <release>
    return 0;
    800022ae:	84ca                	mv	s1,s2
    800022b0:	bfd1                	j	80002284 <allocproc+0x78>

00000000800022b2 <userinit>:
{
    800022b2:	1101                	addi	sp,sp,-32
    800022b4:	ec06                	sd	ra,24(sp)
    800022b6:	e822                	sd	s0,16(sp)
    800022b8:	e426                	sd	s1,8(sp)
    800022ba:	1000                	addi	s0,sp,32
  p = allocproc();
    800022bc:	f51ff0ef          	jal	8000220c <allocproc>
    800022c0:	84aa                	mv	s1,a0
  initproc = p;
    800022c2:	00006797          	auipc	a5,0x6
    800022c6:	7aa7b323          	sd	a0,1958(a5) # 80008a68 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    800022ca:	03400613          	li	a2,52
    800022ce:	00006597          	auipc	a1,0x6
    800022d2:	73258593          	addi	a1,a1,1842 # 80008a00 <initcode>
    800022d6:	6d28                	ld	a0,88(a0)
    800022d8:	eeeff0ef          	jal	800019c6 <uvmfirst>
  p->sz = PGSIZE;
    800022dc:	6785                	lui	a5,0x1
    800022de:	e8bc                	sd	a5,80(s1)
  p->trapframe->epc = 0;      // user program counter
    800022e0:	70b8                	ld	a4,96(s1)
    800022e2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    800022e6:	70b8                	ld	a4,96(s1)
    800022e8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    800022ea:	4641                	li	a2,16
    800022ec:	00006597          	auipc	a1,0x6
    800022f0:	f8458593          	addi	a1,a1,-124 # 80008270 <etext+0x270>
    800022f4:	16048513          	addi	a0,s1,352
    800022f8:	b73fe0ef          	jal	80000e6a <safestrcpy>
  p->cwd = namei("/");
    800022fc:	00006517          	auipc	a0,0x6
    80002300:	f8450513          	addi	a0,a0,-124 # 80008280 <etext+0x280>
    80002304:	144020ef          	jal	80004448 <namei>
    80002308:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000230c:	478d                	li	a5,3
    8000230e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80002310:	8526                	mv	a0,s1
    80002312:	9dffe0ef          	jal	80000cf0 <release>
}
    80002316:	60e2                	ld	ra,24(sp)
    80002318:	6442                	ld	s0,16(sp)
    8000231a:	64a2                	ld	s1,8(sp)
    8000231c:	6105                	addi	sp,sp,32
    8000231e:	8082                	ret

0000000080002320 <growproc>:
{
    80002320:	1101                	addi	sp,sp,-32
    80002322:	ec06                	sd	ra,24(sp)
    80002324:	e822                	sd	s0,16(sp)
    80002326:	e426                	sd	s1,8(sp)
    80002328:	e04a                	sd	s2,0(sp)
    8000232a:	1000                	addi	s0,sp,32
    8000232c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000232e:	d01ff0ef          	jal	8000202e <myproc>
    80002332:	84aa                	mv	s1,a0
  sz = p->sz;
    80002334:	692c                	ld	a1,80(a0)
  if(n > 0){
    80002336:	01204c63          	bgtz	s2,8000234e <growproc+0x2e>
  } else if(n < 0){
    8000233a:	02094463          	bltz	s2,80002362 <growproc+0x42>
  p->sz = sz;
    8000233e:	e8ac                	sd	a1,80(s1)
  return 0;
    80002340:	4501                	li	a0,0
}
    80002342:	60e2                	ld	ra,24(sp)
    80002344:	6442                	ld	s0,16(sp)
    80002346:	64a2                	ld	s1,8(sp)
    80002348:	6902                	ld	s2,0(sp)
    8000234a:	6105                	addi	sp,sp,32
    8000234c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000234e:	4691                	li	a3,4
    80002350:	00b90633          	add	a2,s2,a1
    80002354:	6d28                	ld	a0,88(a0)
    80002356:	f12ff0ef          	jal	80001a68 <uvmalloc>
    8000235a:	85aa                	mv	a1,a0
    8000235c:	f16d                	bnez	a0,8000233e <growproc+0x1e>
      return -1;
    8000235e:	557d                	li	a0,-1
    80002360:	b7cd                	j	80002342 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80002362:	00b90633          	add	a2,s2,a1
    80002366:	6d28                	ld	a0,88(a0)
    80002368:	ebcff0ef          	jal	80001a24 <uvmdealloc>
    8000236c:	85aa                	mv	a1,a0
    8000236e:	bfc1                	j	8000233e <growproc+0x1e>

0000000080002370 <fork>:
{
    80002370:	7139                	addi	sp,sp,-64
    80002372:	fc06                	sd	ra,56(sp)
    80002374:	f822                	sd	s0,48(sp)
    80002376:	f04a                	sd	s2,32(sp)
    80002378:	e456                	sd	s5,8(sp)
    8000237a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000237c:	cb3ff0ef          	jal	8000202e <myproc>
    80002380:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80002382:	e8bff0ef          	jal	8000220c <allocproc>
    80002386:	0e050a63          	beqz	a0,8000247a <fork+0x10a>
    8000238a:	e852                	sd	s4,16(sp)
    8000238c:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000238e:	050ab603          	ld	a2,80(s5)
    80002392:	6d2c                	ld	a1,88(a0)
    80002394:	058ab503          	ld	a0,88(s5)
    80002398:	809ff0ef          	jal	80001ba0 <uvmcopy>
    8000239c:	04054a63          	bltz	a0,800023f0 <fork+0x80>
    800023a0:	f426                	sd	s1,40(sp)
    800023a2:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800023a4:	050ab783          	ld	a5,80(s5)
    800023a8:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    800023ac:	060ab683          	ld	a3,96(s5)
    800023b0:	87b6                	mv	a5,a3
    800023b2:	060a3703          	ld	a4,96(s4)
    800023b6:	12068693          	addi	a3,a3,288
    800023ba:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800023be:	6788                	ld	a0,8(a5)
    800023c0:	6b8c                	ld	a1,16(a5)
    800023c2:	6f90                	ld	a2,24(a5)
    800023c4:	01073023          	sd	a6,0(a4)
    800023c8:	e708                	sd	a0,8(a4)
    800023ca:	eb0c                	sd	a1,16(a4)
    800023cc:	ef10                	sd	a2,24(a4)
    800023ce:	02078793          	addi	a5,a5,32
    800023d2:	02070713          	addi	a4,a4,32
    800023d6:	fed792e3          	bne	a5,a3,800023ba <fork+0x4a>
  np->trapframe->a0 = 0;
    800023da:	060a3783          	ld	a5,96(s4)
    800023de:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800023e2:	0d8a8493          	addi	s1,s5,216
    800023e6:	0d8a0913          	addi	s2,s4,216
    800023ea:	158a8993          	addi	s3,s5,344
    800023ee:	a831                	j	8000240a <fork+0x9a>
    freeproc(np);
    800023f0:	8552                	mv	a0,s4
    800023f2:	dafff0ef          	jal	800021a0 <freeproc>
    release(&np->lock);
    800023f6:	8552                	mv	a0,s4
    800023f8:	8f9fe0ef          	jal	80000cf0 <release>
    return -1;
    800023fc:	597d                	li	s2,-1
    800023fe:	6a42                	ld	s4,16(sp)
    80002400:	a0b5                	j	8000246c <fork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80002402:	04a1                	addi	s1,s1,8
    80002404:	0921                	addi	s2,s2,8
    80002406:	01348963          	beq	s1,s3,80002418 <fork+0xa8>
    if(p->ofile[i])
    8000240a:	6088                	ld	a0,0(s1)
    8000240c:	d97d                	beqz	a0,80002402 <fork+0x92>
      np->ofile[i] = filedup(p->ofile[i]);
    8000240e:	5ca020ef          	jal	800049d8 <filedup>
    80002412:	00a93023          	sd	a0,0(s2)
    80002416:	b7f5                	j	80002402 <fork+0x92>
  np->cwd = idup(p->cwd);
    80002418:	158ab503          	ld	a0,344(s5)
    8000241c:	11d010ef          	jal	80003d38 <idup>
    80002420:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002424:	4641                	li	a2,16
    80002426:	160a8593          	addi	a1,s5,352
    8000242a:	160a0513          	addi	a0,s4,352
    8000242e:	a3dfe0ef          	jal	80000e6a <safestrcpy>
  pid = np->pid;
    80002432:	030a2903          	lw	s2,48(s4)
  release(&np->lock);
    80002436:	8552                	mv	a0,s4
    80002438:	8b9fe0ef          	jal	80000cf0 <release>
  acquire(&wait_lock);
    8000243c:	001a2497          	auipc	s1,0x1a2
    80002440:	c9448493          	addi	s1,s1,-876 # 801a40d0 <wait_lock>
    80002444:	8526                	mv	a0,s1
    80002446:	813fe0ef          	jal	80000c58 <acquire>
  np->parent = p;
    8000244a:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000244e:	8526                	mv	a0,s1
    80002450:	8a1fe0ef          	jal	80000cf0 <release>
  acquire(&np->lock);
    80002454:	8552                	mv	a0,s4
    80002456:	803fe0ef          	jal	80000c58 <acquire>
  np->state = RUNNABLE;
    8000245a:	478d                	li	a5,3
    8000245c:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80002460:	8552                	mv	a0,s4
    80002462:	88ffe0ef          	jal	80000cf0 <release>
  return pid;
    80002466:	74a2                	ld	s1,40(sp)
    80002468:	69e2                	ld	s3,24(sp)
    8000246a:	6a42                	ld	s4,16(sp)
}
    8000246c:	854a                	mv	a0,s2
    8000246e:	70e2                	ld	ra,56(sp)
    80002470:	7442                	ld	s0,48(sp)
    80002472:	7902                	ld	s2,32(sp)
    80002474:	6aa2                	ld	s5,8(sp)
    80002476:	6121                	addi	sp,sp,64
    80002478:	8082                	ret
    return -1;
    8000247a:	597d                	li	s2,-1
    8000247c:	bfc5                	j	8000246c <fork+0xfc>

000000008000247e <scheduler>:
{
    8000247e:	715d                	addi	sp,sp,-80
    80002480:	e486                	sd	ra,72(sp)
    80002482:	e0a2                	sd	s0,64(sp)
    80002484:	fc26                	sd	s1,56(sp)
    80002486:	f84a                	sd	s2,48(sp)
    80002488:	f44e                	sd	s3,40(sp)
    8000248a:	f052                	sd	s4,32(sp)
    8000248c:	ec56                	sd	s5,24(sp)
    8000248e:	e85a                	sd	s6,16(sp)
    80002490:	e45e                	sd	s7,8(sp)
    80002492:	e062                	sd	s8,0(sp)
    80002494:	0880                	addi	s0,sp,80
    80002496:	8792                	mv	a5,tp
  int id = r_tp();
    80002498:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000249a:	00779b13          	slli	s6,a5,0x7
    8000249e:	001a2717          	auipc	a4,0x1a2
    800024a2:	c1a70713          	addi	a4,a4,-998 # 801a40b8 <pid_lock>
    800024a6:	975a                	add	a4,a4,s6
    800024a8:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800024ac:	001a2717          	auipc	a4,0x1a2
    800024b0:	c4470713          	addi	a4,a4,-956 # 801a40f0 <cpus+0x8>
    800024b4:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800024b6:	4c11                	li	s8,4
        c->proc = p;
    800024b8:	079e                	slli	a5,a5,0x7
    800024ba:	001a2a17          	auipc	s4,0x1a2
    800024be:	bfea0a13          	addi	s4,s4,-1026 # 801a40b8 <pid_lock>
    800024c2:	9a3e                	add	s4,s4,a5
        found = 1;
    800024c4:	4b85                	li	s7,1
    for(p = proc; p < &proc[NPROC]; p++) {
    800024c6:	001ad997          	auipc	s3,0x1ad
    800024ca:	82298993          	addi	s3,s3,-2014 # 801aece8 <proc_lock>
    800024ce:	a0a9                	j	80002518 <scheduler+0x9a>
      release(&p->lock);
    800024d0:	8526                	mv	a0,s1
    800024d2:	81ffe0ef          	jal	80000cf0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800024d6:	2a048493          	addi	s1,s1,672
    800024da:	03348563          	beq	s1,s3,80002504 <scheduler+0x86>
      acquire(&p->lock);
    800024de:	8526                	mv	a0,s1
    800024e0:	f78fe0ef          	jal	80000c58 <acquire>
      if(p->state == RUNNABLE) {
    800024e4:	4c9c                	lw	a5,24(s1)
    800024e6:	ff2795e3          	bne	a5,s2,800024d0 <scheduler+0x52>
        p->state = RUNNING;
    800024ea:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800024ee:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800024f2:	06848593          	addi	a1,s1,104
    800024f6:	855a                	mv	a0,s6
    800024f8:	03b000ef          	jal	80002d32 <swtch>
        c->proc = 0;
    800024fc:	020a3823          	sd	zero,48(s4)
        found = 1;
    80002500:	8ade                	mv	s5,s7
    80002502:	b7f9                	j	800024d0 <scheduler+0x52>
    if(found == 0) {
    80002504:	000a9a63          	bnez	s5,80002518 <scheduler+0x9a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002508:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000250c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002510:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80002514:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002518:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000251c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002520:	10079073          	csrw	sstatus,a5
    int found = 0;
    80002524:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80002526:	001a2497          	auipc	s1,0x1a2
    8000252a:	fc248493          	addi	s1,s1,-62 # 801a44e8 <proc>
      if(p->state == RUNNABLE) {
    8000252e:	490d                	li	s2,3
    80002530:	b77d                	j	800024de <scheduler+0x60>

0000000080002532 <sched>:
{
    80002532:	7179                	addi	sp,sp,-48
    80002534:	f406                	sd	ra,40(sp)
    80002536:	f022                	sd	s0,32(sp)
    80002538:	ec26                	sd	s1,24(sp)
    8000253a:	e84a                	sd	s2,16(sp)
    8000253c:	e44e                	sd	s3,8(sp)
    8000253e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002540:	aefff0ef          	jal	8000202e <myproc>
    80002544:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002546:	ea8fe0ef          	jal	80000bee <holding>
    8000254a:	c92d                	beqz	a0,800025bc <sched+0x8a>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000254c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000254e:	2781                	sext.w	a5,a5
    80002550:	079e                	slli	a5,a5,0x7
    80002552:	001a2717          	auipc	a4,0x1a2
    80002556:	b6670713          	addi	a4,a4,-1178 # 801a40b8 <pid_lock>
    8000255a:	97ba                	add	a5,a5,a4
    8000255c:	0a87a703          	lw	a4,168(a5)
    80002560:	4785                	li	a5,1
    80002562:	06f71363          	bne	a4,a5,800025c8 <sched+0x96>
  if(p->state == RUNNING)
    80002566:	4c98                	lw	a4,24(s1)
    80002568:	4791                	li	a5,4
    8000256a:	06f70563          	beq	a4,a5,800025d4 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000256e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002572:	8b89                	andi	a5,a5,2
  if(intr_get())
    80002574:	e7b5                	bnez	a5,800025e0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002576:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002578:	001a2917          	auipc	s2,0x1a2
    8000257c:	b4090913          	addi	s2,s2,-1216 # 801a40b8 <pid_lock>
    80002580:	2781                	sext.w	a5,a5
    80002582:	079e                	slli	a5,a5,0x7
    80002584:	97ca                	add	a5,a5,s2
    80002586:	0ac7a983          	lw	s3,172(a5)
    8000258a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000258c:	2781                	sext.w	a5,a5
    8000258e:	079e                	slli	a5,a5,0x7
    80002590:	001a2597          	auipc	a1,0x1a2
    80002594:	b6058593          	addi	a1,a1,-1184 # 801a40f0 <cpus+0x8>
    80002598:	95be                	add	a1,a1,a5
    8000259a:	06848513          	addi	a0,s1,104
    8000259e:	794000ef          	jal	80002d32 <swtch>
    800025a2:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800025a4:	2781                	sext.w	a5,a5
    800025a6:	079e                	slli	a5,a5,0x7
    800025a8:	993e                	add	s2,s2,a5
    800025aa:	0b392623          	sw	s3,172(s2)
}
    800025ae:	70a2                	ld	ra,40(sp)
    800025b0:	7402                	ld	s0,32(sp)
    800025b2:	64e2                	ld	s1,24(sp)
    800025b4:	6942                	ld	s2,16(sp)
    800025b6:	69a2                	ld	s3,8(sp)
    800025b8:	6145                	addi	sp,sp,48
    800025ba:	8082                	ret
    panic("sched p->lock");
    800025bc:	00006517          	auipc	a0,0x6
    800025c0:	ccc50513          	addi	a0,a0,-820 # 80008288 <etext+0x288>
    800025c4:	a34fe0ef          	jal	800007f8 <panic>
    panic("sched locks");
    800025c8:	00006517          	auipc	a0,0x6
    800025cc:	cd050513          	addi	a0,a0,-816 # 80008298 <etext+0x298>
    800025d0:	a28fe0ef          	jal	800007f8 <panic>
    panic("sched running");
    800025d4:	00006517          	auipc	a0,0x6
    800025d8:	cd450513          	addi	a0,a0,-812 # 800082a8 <etext+0x2a8>
    800025dc:	a1cfe0ef          	jal	800007f8 <panic>
    panic("sched interruptible");
    800025e0:	00006517          	auipc	a0,0x6
    800025e4:	cd850513          	addi	a0,a0,-808 # 800082b8 <etext+0x2b8>
    800025e8:	a10fe0ef          	jal	800007f8 <panic>

00000000800025ec <yield>:
{
    800025ec:	1101                	addi	sp,sp,-32
    800025ee:	ec06                	sd	ra,24(sp)
    800025f0:	e822                	sd	s0,16(sp)
    800025f2:	e426                	sd	s1,8(sp)
    800025f4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800025f6:	a39ff0ef          	jal	8000202e <myproc>
    800025fa:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800025fc:	e5cfe0ef          	jal	80000c58 <acquire>
  p->state = RUNNABLE;
    80002600:	478d                	li	a5,3
    80002602:	cc9c                	sw	a5,24(s1)
  sched();
    80002604:	f2fff0ef          	jal	80002532 <sched>
  release(&p->lock);
    80002608:	8526                	mv	a0,s1
    8000260a:	ee6fe0ef          	jal	80000cf0 <release>
}
    8000260e:	60e2                	ld	ra,24(sp)
    80002610:	6442                	ld	s0,16(sp)
    80002612:	64a2                	ld	s1,8(sp)
    80002614:	6105                	addi	sp,sp,32
    80002616:	8082                	ret

0000000080002618 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002618:	7179                	addi	sp,sp,-48
    8000261a:	f406                	sd	ra,40(sp)
    8000261c:	f022                	sd	s0,32(sp)
    8000261e:	ec26                	sd	s1,24(sp)
    80002620:	e84a                	sd	s2,16(sp)
    80002622:	e44e                	sd	s3,8(sp)
    80002624:	1800                	addi	s0,sp,48
    80002626:	89aa                	mv	s3,a0
    80002628:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000262a:	a05ff0ef          	jal	8000202e <myproc>
    8000262e:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80002630:	e28fe0ef          	jal	80000c58 <acquire>
  release(lk);
    80002634:	854a                	mv	a0,s2
    80002636:	ebafe0ef          	jal	80000cf0 <release>

  // Go to sleep.
  p->chan = chan;
    8000263a:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000263e:	4789                	li	a5,2
    80002640:	cc9c                	sw	a5,24(s1)

  sched();
    80002642:	ef1ff0ef          	jal	80002532 <sched>

  // Tidy up.
  p->chan = 0;
    80002646:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000264a:	8526                	mv	a0,s1
    8000264c:	ea4fe0ef          	jal	80000cf0 <release>
  acquire(lk);
    80002650:	854a                	mv	a0,s2
    80002652:	e06fe0ef          	jal	80000c58 <acquire>
}
    80002656:	70a2                	ld	ra,40(sp)
    80002658:	7402                	ld	s0,32(sp)
    8000265a:	64e2                	ld	s1,24(sp)
    8000265c:	6942                	ld	s2,16(sp)
    8000265e:	69a2                	ld	s3,8(sp)
    80002660:	6145                	addi	sp,sp,48
    80002662:	8082                	ret

0000000080002664 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    80002664:	7139                	addi	sp,sp,-64
    80002666:	fc06                	sd	ra,56(sp)
    80002668:	f822                	sd	s0,48(sp)
    8000266a:	f426                	sd	s1,40(sp)
    8000266c:	f04a                	sd	s2,32(sp)
    8000266e:	ec4e                	sd	s3,24(sp)
    80002670:	e852                	sd	s4,16(sp)
    80002672:	e456                	sd	s5,8(sp)
    80002674:	0080                	addi	s0,sp,64
    80002676:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80002678:	001a2497          	auipc	s1,0x1a2
    8000267c:	e7048493          	addi	s1,s1,-400 # 801a44e8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80002680:	4989                	li	s3,2
        p->state = RUNNABLE;
    80002682:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80002684:	001ac917          	auipc	s2,0x1ac
    80002688:	66490913          	addi	s2,s2,1636 # 801aece8 <proc_lock>
    8000268c:	a801                	j	8000269c <wakeup+0x38>
      }
      release(&p->lock);
    8000268e:	8526                	mv	a0,s1
    80002690:	e60fe0ef          	jal	80000cf0 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002694:	2a048493          	addi	s1,s1,672
    80002698:	03248263          	beq	s1,s2,800026bc <wakeup+0x58>
    if(p != myproc()){
    8000269c:	993ff0ef          	jal	8000202e <myproc>
    800026a0:	fea48ae3          	beq	s1,a0,80002694 <wakeup+0x30>
      acquire(&p->lock);
    800026a4:	8526                	mv	a0,s1
    800026a6:	db2fe0ef          	jal	80000c58 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800026aa:	4c9c                	lw	a5,24(s1)
    800026ac:	ff3791e3          	bne	a5,s3,8000268e <wakeup+0x2a>
    800026b0:	709c                	ld	a5,32(s1)
    800026b2:	fd479ee3          	bne	a5,s4,8000268e <wakeup+0x2a>
        p->state = RUNNABLE;
    800026b6:	0154ac23          	sw	s5,24(s1)
    800026ba:	bfd1                	j	8000268e <wakeup+0x2a>
    }
  }
}
    800026bc:	70e2                	ld	ra,56(sp)
    800026be:	7442                	ld	s0,48(sp)
    800026c0:	74a2                	ld	s1,40(sp)
    800026c2:	7902                	ld	s2,32(sp)
    800026c4:	69e2                	ld	s3,24(sp)
    800026c6:	6a42                	ld	s4,16(sp)
    800026c8:	6aa2                	ld	s5,8(sp)
    800026ca:	6121                	addi	sp,sp,64
    800026cc:	8082                	ret

00000000800026ce <reparent>:
{
    800026ce:	7179                	addi	sp,sp,-48
    800026d0:	f406                	sd	ra,40(sp)
    800026d2:	f022                	sd	s0,32(sp)
    800026d4:	ec26                	sd	s1,24(sp)
    800026d6:	e84a                	sd	s2,16(sp)
    800026d8:	e44e                	sd	s3,8(sp)
    800026da:	e052                	sd	s4,0(sp)
    800026dc:	1800                	addi	s0,sp,48
    800026de:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800026e0:	001a2497          	auipc	s1,0x1a2
    800026e4:	e0848493          	addi	s1,s1,-504 # 801a44e8 <proc>
      pp->parent = initproc;
    800026e8:	00006a17          	auipc	s4,0x6
    800026ec:	380a0a13          	addi	s4,s4,896 # 80008a68 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800026f0:	001ac997          	auipc	s3,0x1ac
    800026f4:	5f898993          	addi	s3,s3,1528 # 801aece8 <proc_lock>
    800026f8:	a029                	j	80002702 <reparent+0x34>
    800026fa:	2a048493          	addi	s1,s1,672
    800026fe:	01348b63          	beq	s1,s3,80002714 <reparent+0x46>
    if(pp->parent == p){
    80002702:	7c9c                	ld	a5,56(s1)
    80002704:	ff279be3          	bne	a5,s2,800026fa <reparent+0x2c>
      pp->parent = initproc;
    80002708:	000a3503          	ld	a0,0(s4)
    8000270c:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000270e:	f57ff0ef          	jal	80002664 <wakeup>
    80002712:	b7e5                	j	800026fa <reparent+0x2c>
}
    80002714:	70a2                	ld	ra,40(sp)
    80002716:	7402                	ld	s0,32(sp)
    80002718:	64e2                	ld	s1,24(sp)
    8000271a:	6942                	ld	s2,16(sp)
    8000271c:	69a2                	ld	s3,8(sp)
    8000271e:	6a02                	ld	s4,0(sp)
    80002720:	6145                	addi	sp,sp,48
    80002722:	8082                	ret

0000000080002724 <exit>:
{
    80002724:	7179                	addi	sp,sp,-48
    80002726:	f406                	sd	ra,40(sp)
    80002728:	f022                	sd	s0,32(sp)
    8000272a:	ec26                	sd	s1,24(sp)
    8000272c:	e84a                	sd	s2,16(sp)
    8000272e:	e44e                	sd	s3,8(sp)
    80002730:	e052                	sd	s4,0(sp)
    80002732:	1800                	addi	s0,sp,48
    80002734:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80002736:	8f9ff0ef          	jal	8000202e <myproc>
    8000273a:	89aa                	mv	s3,a0
  if(p == initproc)
    8000273c:	00006797          	auipc	a5,0x6
    80002740:	32c7b783          	ld	a5,812(a5) # 80008a68 <initproc>
    80002744:	0d850493          	addi	s1,a0,216
    80002748:	15850913          	addi	s2,a0,344
    8000274c:	00a79f63          	bne	a5,a0,8000276a <exit+0x46>
    panic("init exiting");
    80002750:	00006517          	auipc	a0,0x6
    80002754:	b8050513          	addi	a0,a0,-1152 # 800082d0 <etext+0x2d0>
    80002758:	8a0fe0ef          	jal	800007f8 <panic>
      fileclose(f);
    8000275c:	2c2020ef          	jal	80004a1e <fileclose>
      p->ofile[fd] = 0;
    80002760:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80002764:	04a1                	addi	s1,s1,8
    80002766:	01248563          	beq	s1,s2,80002770 <exit+0x4c>
    if(p->ofile[fd]){
    8000276a:	6088                	ld	a0,0(s1)
    8000276c:	f965                	bnez	a0,8000275c <exit+0x38>
    8000276e:	bfdd                	j	80002764 <exit+0x40>
  begin_op();
    80002770:	695010ef          	jal	80004604 <begin_op>
  iput(p->cwd);
    80002774:	1589b503          	ld	a0,344(s3)
    80002778:	778010ef          	jal	80003ef0 <iput>
  end_op();
    8000277c:	6f3010ef          	jal	8000466e <end_op>
  p->cwd = 0;
    80002780:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80002784:	001a2497          	auipc	s1,0x1a2
    80002788:	94c48493          	addi	s1,s1,-1716 # 801a40d0 <wait_lock>
    8000278c:	8526                	mv	a0,s1
    8000278e:	ccafe0ef          	jal	80000c58 <acquire>
  reparent(p);
    80002792:	854e                	mv	a0,s3
    80002794:	f3bff0ef          	jal	800026ce <reparent>
  wakeup(p->parent);
    80002798:	0389b503          	ld	a0,56(s3)
    8000279c:	ec9ff0ef          	jal	80002664 <wakeup>
  acquire(&p->lock);
    800027a0:	854e                	mv	a0,s3
    800027a2:	cb6fe0ef          	jal	80000c58 <acquire>
  p->xstate = status;
    800027a6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800027aa:	4795                	li	a5,5
    800027ac:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800027b0:	8526                	mv	a0,s1
    800027b2:	d3efe0ef          	jal	80000cf0 <release>
  sched();
    800027b6:	d7dff0ef          	jal	80002532 <sched>
  panic("zombie exit");
    800027ba:	00006517          	auipc	a0,0x6
    800027be:	b2650513          	addi	a0,a0,-1242 # 800082e0 <etext+0x2e0>
    800027c2:	836fe0ef          	jal	800007f8 <panic>

00000000800027c6 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800027c6:	7179                	addi	sp,sp,-48
    800027c8:	f406                	sd	ra,40(sp)
    800027ca:	f022                	sd	s0,32(sp)
    800027cc:	ec26                	sd	s1,24(sp)
    800027ce:	e84a                	sd	s2,16(sp)
    800027d0:	e44e                	sd	s3,8(sp)
    800027d2:	1800                	addi	s0,sp,48
    800027d4:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800027d6:	001a2497          	auipc	s1,0x1a2
    800027da:	d1248493          	addi	s1,s1,-750 # 801a44e8 <proc>
    800027de:	001ac997          	auipc	s3,0x1ac
    800027e2:	50a98993          	addi	s3,s3,1290 # 801aece8 <proc_lock>
    acquire(&p->lock);
    800027e6:	8526                	mv	a0,s1
    800027e8:	c70fe0ef          	jal	80000c58 <acquire>
    if(p->pid == pid){
    800027ec:	589c                	lw	a5,48(s1)
    800027ee:	01278b63          	beq	a5,s2,80002804 <kill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800027f2:	8526                	mv	a0,s1
    800027f4:	cfcfe0ef          	jal	80000cf0 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800027f8:	2a048493          	addi	s1,s1,672
    800027fc:	ff3495e3          	bne	s1,s3,800027e6 <kill+0x20>
  }
  return -1;
    80002800:	557d                	li	a0,-1
    80002802:	a819                	j	80002818 <kill+0x52>
      p->killed = 1;
    80002804:	4785                	li	a5,1
    80002806:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80002808:	4c98                	lw	a4,24(s1)
    8000280a:	4789                	li	a5,2
    8000280c:	00f70d63          	beq	a4,a5,80002826 <kill+0x60>
      release(&p->lock);
    80002810:	8526                	mv	a0,s1
    80002812:	cdefe0ef          	jal	80000cf0 <release>
      return 0;
    80002816:	4501                	li	a0,0
}
    80002818:	70a2                	ld	ra,40(sp)
    8000281a:	7402                	ld	s0,32(sp)
    8000281c:	64e2                	ld	s1,24(sp)
    8000281e:	6942                	ld	s2,16(sp)
    80002820:	69a2                	ld	s3,8(sp)
    80002822:	6145                	addi	sp,sp,48
    80002824:	8082                	ret
        p->state = RUNNABLE;
    80002826:	478d                	li	a5,3
    80002828:	cc9c                	sw	a5,24(s1)
    8000282a:	b7dd                	j	80002810 <kill+0x4a>

000000008000282c <setkilled>:

void
setkilled(struct proc *p)
{
    8000282c:	1101                	addi	sp,sp,-32
    8000282e:	ec06                	sd	ra,24(sp)
    80002830:	e822                	sd	s0,16(sp)
    80002832:	e426                	sd	s1,8(sp)
    80002834:	1000                	addi	s0,sp,32
    80002836:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002838:	c20fe0ef          	jal	80000c58 <acquire>
  p->killed = 1;
    8000283c:	4785                	li	a5,1
    8000283e:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002840:	8526                	mv	a0,s1
    80002842:	caefe0ef          	jal	80000cf0 <release>
}
    80002846:	60e2                	ld	ra,24(sp)
    80002848:	6442                	ld	s0,16(sp)
    8000284a:	64a2                	ld	s1,8(sp)
    8000284c:	6105                	addi	sp,sp,32
    8000284e:	8082                	ret

0000000080002850 <killed>:

int
killed(struct proc *p)
{
    80002850:	1101                	addi	sp,sp,-32
    80002852:	ec06                	sd	ra,24(sp)
    80002854:	e822                	sd	s0,16(sp)
    80002856:	e426                	sd	s1,8(sp)
    80002858:	e04a                	sd	s2,0(sp)
    8000285a:	1000                	addi	s0,sp,32
    8000285c:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000285e:	bfafe0ef          	jal	80000c58 <acquire>
  k = p->killed;
    80002862:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    80002866:	8526                	mv	a0,s1
    80002868:	c88fe0ef          	jal	80000cf0 <release>
  return k;
}
    8000286c:	854a                	mv	a0,s2
    8000286e:	60e2                	ld	ra,24(sp)
    80002870:	6442                	ld	s0,16(sp)
    80002872:	64a2                	ld	s1,8(sp)
    80002874:	6902                	ld	s2,0(sp)
    80002876:	6105                	addi	sp,sp,32
    80002878:	8082                	ret

000000008000287a <wait>:
{
    8000287a:	715d                	addi	sp,sp,-80
    8000287c:	e486                	sd	ra,72(sp)
    8000287e:	e0a2                	sd	s0,64(sp)
    80002880:	fc26                	sd	s1,56(sp)
    80002882:	f84a                	sd	s2,48(sp)
    80002884:	f44e                	sd	s3,40(sp)
    80002886:	f052                	sd	s4,32(sp)
    80002888:	ec56                	sd	s5,24(sp)
    8000288a:	e85a                	sd	s6,16(sp)
    8000288c:	e45e                	sd	s7,8(sp)
    8000288e:	e062                	sd	s8,0(sp)
    80002890:	0880                	addi	s0,sp,80
    80002892:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    80002894:	f9aff0ef          	jal	8000202e <myproc>
    80002898:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000289a:	001a2517          	auipc	a0,0x1a2
    8000289e:	83650513          	addi	a0,a0,-1994 # 801a40d0 <wait_lock>
    800028a2:	bb6fe0ef          	jal	80000c58 <acquire>
    havekids = 0;
    800028a6:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800028a8:	4a15                	li	s4,5
        havekids = 1;
    800028aa:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800028ac:	001ac997          	auipc	s3,0x1ac
    800028b0:	43c98993          	addi	s3,s3,1084 # 801aece8 <proc_lock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800028b4:	001a2c17          	auipc	s8,0x1a2
    800028b8:	81cc0c13          	addi	s8,s8,-2020 # 801a40d0 <wait_lock>
    800028bc:	a871                	j	80002958 <wait+0xde>
          pid = pp->pid;
    800028be:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800028c2:	000b0c63          	beqz	s6,800028da <wait+0x60>
    800028c6:	4691                	li	a3,4
    800028c8:	02c48613          	addi	a2,s1,44
    800028cc:	85da                	mv	a1,s6
    800028ce:	05893503          	ld	a0,88(s2)
    800028d2:	baaff0ef          	jal	80001c7c <copyout>
    800028d6:	02054b63          	bltz	a0,8000290c <wait+0x92>
          freeproc(pp);
    800028da:	8526                	mv	a0,s1
    800028dc:	8c5ff0ef          	jal	800021a0 <freeproc>
          release(&pp->lock);
    800028e0:	8526                	mv	a0,s1
    800028e2:	c0efe0ef          	jal	80000cf0 <release>
          release(&wait_lock);
    800028e6:	001a1517          	auipc	a0,0x1a1
    800028ea:	7ea50513          	addi	a0,a0,2026 # 801a40d0 <wait_lock>
    800028ee:	c02fe0ef          	jal	80000cf0 <release>
}
    800028f2:	854e                	mv	a0,s3
    800028f4:	60a6                	ld	ra,72(sp)
    800028f6:	6406                	ld	s0,64(sp)
    800028f8:	74e2                	ld	s1,56(sp)
    800028fa:	7942                	ld	s2,48(sp)
    800028fc:	79a2                	ld	s3,40(sp)
    800028fe:	7a02                	ld	s4,32(sp)
    80002900:	6ae2                	ld	s5,24(sp)
    80002902:	6b42                	ld	s6,16(sp)
    80002904:	6ba2                	ld	s7,8(sp)
    80002906:	6c02                	ld	s8,0(sp)
    80002908:	6161                	addi	sp,sp,80
    8000290a:	8082                	ret
            release(&pp->lock);
    8000290c:	8526                	mv	a0,s1
    8000290e:	be2fe0ef          	jal	80000cf0 <release>
            release(&wait_lock);
    80002912:	001a1517          	auipc	a0,0x1a1
    80002916:	7be50513          	addi	a0,a0,1982 # 801a40d0 <wait_lock>
    8000291a:	bd6fe0ef          	jal	80000cf0 <release>
            return -1;
    8000291e:	59fd                	li	s3,-1
    80002920:	bfc9                	j	800028f2 <wait+0x78>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80002922:	2a048493          	addi	s1,s1,672
    80002926:	03348063          	beq	s1,s3,80002946 <wait+0xcc>
      if(pp->parent == p){
    8000292a:	7c9c                	ld	a5,56(s1)
    8000292c:	ff279be3          	bne	a5,s2,80002922 <wait+0xa8>
        acquire(&pp->lock);
    80002930:	8526                	mv	a0,s1
    80002932:	b26fe0ef          	jal	80000c58 <acquire>
        if(pp->state == ZOMBIE){
    80002936:	4c9c                	lw	a5,24(s1)
    80002938:	f94783e3          	beq	a5,s4,800028be <wait+0x44>
        release(&pp->lock);
    8000293c:	8526                	mv	a0,s1
    8000293e:	bb2fe0ef          	jal	80000cf0 <release>
        havekids = 1;
    80002942:	8756                	mv	a4,s5
    80002944:	bff9                	j	80002922 <wait+0xa8>
    if(!havekids || killed(p)){
    80002946:	cf19                	beqz	a4,80002964 <wait+0xea>
    80002948:	854a                	mv	a0,s2
    8000294a:	f07ff0ef          	jal	80002850 <killed>
    8000294e:	e919                	bnez	a0,80002964 <wait+0xea>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80002950:	85e2                	mv	a1,s8
    80002952:	854a                	mv	a0,s2
    80002954:	cc5ff0ef          	jal	80002618 <sleep>
    havekids = 0;
    80002958:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000295a:	001a2497          	auipc	s1,0x1a2
    8000295e:	b8e48493          	addi	s1,s1,-1138 # 801a44e8 <proc>
    80002962:	b7e1                	j	8000292a <wait+0xb0>
      release(&wait_lock);
    80002964:	001a1517          	auipc	a0,0x1a1
    80002968:	76c50513          	addi	a0,a0,1900 # 801a40d0 <wait_lock>
    8000296c:	b84fe0ef          	jal	80000cf0 <release>
      return -1;
    80002970:	59fd                	li	s3,-1
    80002972:	b741                	j	800028f2 <wait+0x78>

0000000080002974 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002974:	7179                	addi	sp,sp,-48
    80002976:	f406                	sd	ra,40(sp)
    80002978:	f022                	sd	s0,32(sp)
    8000297a:	ec26                	sd	s1,24(sp)
    8000297c:	e84a                	sd	s2,16(sp)
    8000297e:	e44e                	sd	s3,8(sp)
    80002980:	e052                	sd	s4,0(sp)
    80002982:	1800                	addi	s0,sp,48
    80002984:	84aa                	mv	s1,a0
    80002986:	892e                	mv	s2,a1
    80002988:	89b2                	mv	s3,a2
    8000298a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000298c:	ea2ff0ef          	jal	8000202e <myproc>
  if(user_dst){
    80002990:	cc99                	beqz	s1,800029ae <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80002992:	86d2                	mv	a3,s4
    80002994:	864e                	mv	a2,s3
    80002996:	85ca                	mv	a1,s2
    80002998:	6d28                	ld	a0,88(a0)
    8000299a:	ae2ff0ef          	jal	80001c7c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000299e:	70a2                	ld	ra,40(sp)
    800029a0:	7402                	ld	s0,32(sp)
    800029a2:	64e2                	ld	s1,24(sp)
    800029a4:	6942                	ld	s2,16(sp)
    800029a6:	69a2                	ld	s3,8(sp)
    800029a8:	6a02                	ld	s4,0(sp)
    800029aa:	6145                	addi	sp,sp,48
    800029ac:	8082                	ret
    memmove((char *)dst, src, len);
    800029ae:	000a061b          	sext.w	a2,s4
    800029b2:	85ce                	mv	a1,s3
    800029b4:	854a                	mv	a0,s2
    800029b6:	bd2fe0ef          	jal	80000d88 <memmove>
    return 0;
    800029ba:	8526                	mv	a0,s1
    800029bc:	b7cd                	j	8000299e <either_copyout+0x2a>

00000000800029be <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800029be:	7179                	addi	sp,sp,-48
    800029c0:	f406                	sd	ra,40(sp)
    800029c2:	f022                	sd	s0,32(sp)
    800029c4:	ec26                	sd	s1,24(sp)
    800029c6:	e84a                	sd	s2,16(sp)
    800029c8:	e44e                	sd	s3,8(sp)
    800029ca:	e052                	sd	s4,0(sp)
    800029cc:	1800                	addi	s0,sp,48
    800029ce:	892a                	mv	s2,a0
    800029d0:	84ae                	mv	s1,a1
    800029d2:	89b2                	mv	s3,a2
    800029d4:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800029d6:	e58ff0ef          	jal	8000202e <myproc>
  if(user_src){
    800029da:	cc99                	beqz	s1,800029f8 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800029dc:	86d2                	mv	a3,s4
    800029de:	864e                	mv	a2,s3
    800029e0:	85ca                	mv	a1,s2
    800029e2:	6d28                	ld	a0,88(a0)
    800029e4:	b6eff0ef          	jal	80001d52 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800029e8:	70a2                	ld	ra,40(sp)
    800029ea:	7402                	ld	s0,32(sp)
    800029ec:	64e2                	ld	s1,24(sp)
    800029ee:	6942                	ld	s2,16(sp)
    800029f0:	69a2                	ld	s3,8(sp)
    800029f2:	6a02                	ld	s4,0(sp)
    800029f4:	6145                	addi	sp,sp,48
    800029f6:	8082                	ret
    memmove(dst, (char*)src, len);
    800029f8:	000a061b          	sext.w	a2,s4
    800029fc:	85ce                	mv	a1,s3
    800029fe:	854a                	mv	a0,s2
    80002a00:	b88fe0ef          	jal	80000d88 <memmove>
    return 0;
    80002a04:	8526                	mv	a0,s1
    80002a06:	b7cd                	j	800029e8 <either_copyin+0x2a>

0000000080002a08 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80002a08:	715d                	addi	sp,sp,-80
    80002a0a:	e486                	sd	ra,72(sp)
    80002a0c:	e0a2                	sd	s0,64(sp)
    80002a0e:	fc26                	sd	s1,56(sp)
    80002a10:	f84a                	sd	s2,48(sp)
    80002a12:	f44e                	sd	s3,40(sp)
    80002a14:	f052                	sd	s4,32(sp)
    80002a16:	ec56                	sd	s5,24(sp)
    80002a18:	e85a                	sd	s6,16(sp)
    80002a1a:	e45e                	sd	s7,8(sp)
    80002a1c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002a1e:	00005517          	auipc	a0,0x5
    80002a22:	68a50513          	addi	a0,a0,1674 # 800080a8 <etext+0xa8>
    80002a26:	b01fd0ef          	jal	80000526 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a2a:	001a2497          	auipc	s1,0x1a2
    80002a2e:	c1e48493          	addi	s1,s1,-994 # 801a4648 <proc+0x160>
    80002a32:	001ac917          	auipc	s2,0x1ac
    80002a36:	41690913          	addi	s2,s2,1046 # 801aee48 <bcache+0x130>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a3a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80002a3c:	00006997          	auipc	s3,0x6
    80002a40:	8b498993          	addi	s3,s3,-1868 # 800082f0 <etext+0x2f0>
    printf("%d %s %s", p->pid, state, p->name);
    80002a44:	00006a97          	auipc	s5,0x6
    80002a48:	8b4a8a93          	addi	s5,s5,-1868 # 800082f8 <etext+0x2f8>
    printf("\n");
    80002a4c:	00005a17          	auipc	s4,0x5
    80002a50:	65ca0a13          	addi	s4,s4,1628 # 800080a8 <etext+0xa8>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a54:	00006b97          	auipc	s7,0x6
    80002a58:	e54b8b93          	addi	s7,s7,-428 # 800088a8 <states.0>
    80002a5c:	a829                	j	80002a76 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80002a5e:	ed06a583          	lw	a1,-304(a3)
    80002a62:	8556                	mv	a0,s5
    80002a64:	ac3fd0ef          	jal	80000526 <printf>
    printf("\n");
    80002a68:	8552                	mv	a0,s4
    80002a6a:	abdfd0ef          	jal	80000526 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002a6e:	2a048493          	addi	s1,s1,672
    80002a72:	03248263          	beq	s1,s2,80002a96 <procdump+0x8e>
    if(p->state == UNUSED)
    80002a76:	86a6                	mv	a3,s1
    80002a78:	eb84a783          	lw	a5,-328(s1)
    80002a7c:	dbed                	beqz	a5,80002a6e <procdump+0x66>
      state = "???";
    80002a7e:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002a80:	fcfb6fe3          	bltu	s6,a5,80002a5e <procdump+0x56>
    80002a84:	02079713          	slli	a4,a5,0x20
    80002a88:	01d75793          	srli	a5,a4,0x1d
    80002a8c:	97de                	add	a5,a5,s7
    80002a8e:	6390                	ld	a2,0(a5)
    80002a90:	f679                	bnez	a2,80002a5e <procdump+0x56>
      state = "???";
    80002a92:	864e                	mv	a2,s3
    80002a94:	b7e9                	j	80002a5e <procdump+0x56>
  }
}
    80002a96:	60a6                	ld	ra,72(sp)
    80002a98:	6406                	ld	s0,64(sp)
    80002a9a:	74e2                	ld	s1,56(sp)
    80002a9c:	7942                	ld	s2,48(sp)
    80002a9e:	79a2                	ld	s3,40(sp)
    80002aa0:	7a02                	ld	s4,32(sp)
    80002aa2:	6ae2                	ld	s5,24(sp)
    80002aa4:	6b42                	ld	s6,16(sp)
    80002aa6:	6ba2                	ld	s7,8(sp)
    80002aa8:	6161                	addi	sp,sp,80
    80002aaa:	8082                	ret

0000000080002aac <thread_exit>:
void thread_exit(void *retval) {
    80002aac:	1141                	addi	sp,sp,-16
    80002aae:	e406                	sd	ra,8(sp)
    80002ab0:	e022                	sd	s0,0(sp)
    80002ab2:	0800                	addi	s0,sp,16
    exit((uint64)retval);
    80002ab4:	2501                	sext.w	a0,a0
    80002ab6:	c6fff0ef          	jal	80002724 <exit>

0000000080002aba <handle_signals>:
    return pid;
}
// __attribute__((used))
void
handle_signals(void)
{
    80002aba:	1141                	addi	sp,sp,-16
    80002abc:	e406                	sd	ra,8(sp)
    80002abe:	e022                	sd	s0,0(sp)
    80002ac0:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002ac2:	d6cff0ef          	jal	8000202e <myproc>

  // Check if SIGINT is pending
  if (p->pending_signals & (1 << SIGINT)) {
    80002ac6:	17052783          	lw	a5,368(a0)
    80002aca:	0047f713          	andi	a4,a5,4
    80002ace:	cb09                	beqz	a4,80002ae0 <handle_signals+0x26>
    p->pending_signals &= ~(1 << SIGINT);  // Clear the signal
    80002ad0:	9bed                	andi	a5,a5,-5
    80002ad2:	16f52823          	sw	a5,368(a0)

    // Check if a custom handler is set
    if (p->sig_handlers[SIGINT]) {
    80002ad6:	18853783          	ld	a5,392(a0)
    80002ada:	c799                	beqz	a5,80002ae8 <handle_signals+0x2e>
      p->trapframe->epc = (uint64)p->sig_handlers[SIGINT];
    80002adc:	7138                	ld	a4,96(a0)
    80002ade:	ef1c                	sd	a5,24(a4)
    } else {
      // Default action if no handler: terminate the process
      p->killed = 1;
    }
  }
}
    80002ae0:	60a2                	ld	ra,8(sp)
    80002ae2:	6402                	ld	s0,0(sp)
    80002ae4:	0141                	addi	sp,sp,16
    80002ae6:	8082                	ret
      p->killed = 1;
    80002ae8:	4785                	li	a5,1
    80002aea:	d51c                	sw	a5,40(a0)
}
    80002aec:	bfd5                	j	80002ae0 <handle_signals+0x26>

0000000080002aee <sigint_default_handler>:

// Default handler for SIGINT (terminates the process)
// __attribute__((used))
void
sigint_default_handler(void)
{
    80002aee:	1141                	addi	sp,sp,-16
    80002af0:	e406                	sd	ra,8(sp)
    80002af2:	e022                	sd	s0,0(sp)
    80002af4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002af6:	d38ff0ef          	jal	8000202e <myproc>
  p->killed = 1;  // Mark the process for termination
    80002afa:	4785                	li	a5,1
    80002afc:	d51c                	sw	a5,40(a0)
  printf("Entered sigint default handler\n");
    80002afe:	00006517          	auipc	a0,0x6
    80002b02:	80a50513          	addi	a0,a0,-2038 # 80008308 <etext+0x308>
    80002b06:	a21fd0ef          	jal	80000526 <printf>

    // Copy parent trapframe
}   
    80002b0a:	60a2                	ld	ra,8(sp)
    80002b0c:	6402                	ld	s0,0(sp)
    80002b0e:	0141                	addi	sp,sp,16
    80002b10:	8082                	ret

0000000080002b12 <thread_join>:
    

int thread_join(uint64 *retval) {
    80002b12:	7139                	addi	sp,sp,-64
    80002b14:	fc06                	sd	ra,56(sp)
    80002b16:	f822                	sd	s0,48(sp)
    80002b18:	f426                	sd	s1,40(sp)
    80002b1a:	f04a                	sd	s2,32(sp)
    80002b1c:	ec4e                	sd	s3,24(sp)
    80002b1e:	e852                	sd	s4,16(sp)
    80002b20:	e456                	sd	s5,8(sp)
    80002b22:	0080                	addi	s0,sp,64
    80002b24:	8aaa                	mv	s5,a0
    struct proc *p = myproc();
    80002b26:	d08ff0ef          	jal	8000202e <myproc>
    80002b2a:	892a                	mv	s2,a0
    struct proc *pp;

    for(pp = proc; pp < &proc[NPROC]; pp++) {
    80002b2c:	001a2497          	auipc	s1,0x1a2
    80002b30:	9bc48493          	addi	s1,s1,-1604 # 801a44e8 <proc>
        // Look for a thread that belongs to the current process
        if(pp->thread_parent == p && pp->state != UNUSED) {
            acquire(&pp->lock);
            if(pp->state == ZOMBIE) {
    80002b34:	4a15                	li	s4,5
    for(pp = proc; pp < &proc[NPROC]; pp++) {
    80002b36:	001ac997          	auipc	s3,0x1ac
    80002b3a:	1b298993          	addi	s3,s3,434 # 801aece8 <proc_lock>
    80002b3e:	a829                	j	80002b58 <thread_join+0x46>
                // If retval pointer is provided, copy the thread's exit status
                if(retval != 0) {
                    if(copyout(p->pagetable, (uint64)retval, (char*)&pp->xstate, sizeof(uint64)) < 0) {
                        release(&pp->lock);
    80002b40:	8526                	mv	a0,s1
    80002b42:	9aefe0ef          	jal	80000cf0 <release>
                        return -1;
    80002b46:	557d                	li	a0,-1
    80002b48:	a889                	j	80002b9a <thread_join+0x88>
                // Clean up the thread
                freeproc(pp);
                release(&pp->lock);
                return pp->pid;
            }
            release(&pp->lock);
    80002b4a:	8526                	mv	a0,s1
    80002b4c:	9a4fe0ef          	jal	80000cf0 <release>
    for(pp = proc; pp < &proc[NPROC]; pp++) {
    80002b50:	2a048493          	addi	s1,s1,672
    80002b54:	05348263          	beq	s1,s3,80002b98 <thread_join+0x86>
        if(pp->thread_parent == p && pp->state != UNUSED) {
    80002b58:	2884b783          	ld	a5,648(s1)
    80002b5c:	ff279ae3          	bne	a5,s2,80002b50 <thread_join+0x3e>
    80002b60:	4c9c                	lw	a5,24(s1)
    80002b62:	d7fd                	beqz	a5,80002b50 <thread_join+0x3e>
            acquire(&pp->lock);
    80002b64:	8526                	mv	a0,s1
    80002b66:	8f2fe0ef          	jal	80000c58 <acquire>
            if(pp->state == ZOMBIE) {
    80002b6a:	4c9c                	lw	a5,24(s1)
    80002b6c:	fd479fe3          	bne	a5,s4,80002b4a <thread_join+0x38>
                if(retval != 0) {
    80002b70:	000a8c63          	beqz	s5,80002b88 <thread_join+0x76>
                    if(copyout(p->pagetable, (uint64)retval, (char*)&pp->xstate, sizeof(uint64)) < 0) {
    80002b74:	46a1                	li	a3,8
    80002b76:	02c48613          	addi	a2,s1,44
    80002b7a:	85d6                	mv	a1,s5
    80002b7c:	05893503          	ld	a0,88(s2)
    80002b80:	8fcff0ef          	jal	80001c7c <copyout>
    80002b84:	fa054ee3          	bltz	a0,80002b40 <thread_join+0x2e>
                freeproc(pp);
    80002b88:	8526                	mv	a0,s1
    80002b8a:	e16ff0ef          	jal	800021a0 <freeproc>
                release(&pp->lock);
    80002b8e:	8526                	mv	a0,s1
    80002b90:	960fe0ef          	jal	80000cf0 <release>
                return pp->pid;
    80002b94:	5888                	lw	a0,48(s1)
    80002b96:	a011                	j	80002b9a <thread_join+0x88>
        }
    }
    return -1;
    80002b98:	557d                	li	a0,-1
}
    80002b9a:	70e2                	ld	ra,56(sp)
    80002b9c:	7442                	ld	s0,48(sp)
    80002b9e:	74a2                	ld	s1,40(sp)
    80002ba0:	7902                	ld	s2,32(sp)
    80002ba2:	69e2                	ld	s3,24(sp)
    80002ba4:	6a42                	ld	s4,16(sp)
    80002ba6:	6aa2                	ld	s5,8(sp)
    80002ba8:	6121                	addi	sp,sp,64
    80002baa:	8082                	ret

0000000080002bac <allocthread>:

struct proc* allocthread(struct proc* parent) {
    80002bac:	7179                	addi	sp,sp,-48
    80002bae:	f406                	sd	ra,40(sp)
    80002bb0:	f022                	sd	s0,32(sp)
    80002bb2:	ec26                	sd	s1,24(sp)
    80002bb4:	e84a                	sd	s2,16(sp)
    80002bb6:	e44e                	sd	s3,8(sp)
    80002bb8:	1800                	addi	s0,sp,48
    80002bba:	89aa                	mv	s3,a0
    struct proc *p;

    for(p = proc; p < &proc[NPROC]; p++) {
    80002bbc:	001a2497          	auipc	s1,0x1a2
    80002bc0:	92c48493          	addi	s1,s1,-1748 # 801a44e8 <proc>
    80002bc4:	001ac917          	auipc	s2,0x1ac
    80002bc8:	12490913          	addi	s2,s2,292 # 801aece8 <proc_lock>
        acquire(&p->lock);
    80002bcc:	8526                	mv	a0,s1
    80002bce:	88afe0ef          	jal	80000c58 <acquire>
        if(p->state == UNUSED)
    80002bd2:	4c9c                	lw	a5,24(s1)
    80002bd4:	cb91                	beqz	a5,80002be8 <allocthread+0x3c>
            goto found;
        release(&p->lock);
    80002bd6:	8526                	mv	a0,s1
    80002bd8:	918fe0ef          	jal	80000cf0 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002bdc:	2a048493          	addi	s1,s1,672
    80002be0:	ff2496e3          	bne	s1,s2,80002bcc <allocthread+0x20>
    }
    return 0;
    80002be4:	4481                	li	s1,0
    80002be6:	a0bd                	j	80002c54 <allocthread+0xa8>

found:
    p->pid = allocpid();
    80002be8:	cb0ff0ef          	jal	80002098 <allocpid>
    80002bec:	d888                	sw	a0,48(s1)
    p->state = USED;
    80002bee:	4785                	li	a5,1
    80002bf0:	cc9c                	sw	a5,24(s1)
    p->parent = parent;
    80002bf2:	0334bc23          	sd	s3,56(s1)

    // Allocate kernel stack (required for kernel operations)
    if((p->kstack = (uint64)kalloc()) == 0){
    80002bf6:	f93fd0ef          	jal	80000b88 <kalloc>
    80002bfa:	892a                	mv	s2,a0
    80002bfc:	e0a8                	sd	a0,64(s1)
    80002bfe:	c13d                	beqz	a0,80002c64 <allocthread+0xb8>
        release(&p->lock);
        return 0;
    }

    // Allocate trapframe
    if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80002c00:	f89fd0ef          	jal	80000b88 <kalloc>
    80002c04:	892a                	mv	s2,a0
    80002c06:	f0a8                	sd	a0,96(s1)
    80002c08:	c535                	beqz	a0,80002c74 <allocthread+0xc8>
        release(&p->lock);
        return 0;
    }

    // Share address space with parent
    p->pagetable = parent->pagetable;
    80002c0a:	0589b783          	ld	a5,88(s3)
    80002c0e:	ecbc                	sd	a5,88(s1)
    p->sz = parent->sz;
    80002c10:	0509b783          	ld	a5,80(s3)
    80002c14:	e8bc                	sd	a5,80(s1)

    // Thread-specific initialization
    p->is_thread = 1;
    80002c16:	4785                	li	a5,1
    80002c18:	26f4ac23          	sw	a5,632(s1)
    p->thread_parent = parent;
    80002c1c:	2934b423          	sd	s3,648(s1)
    p->killed = 0;
    80002c20:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80002c24:	0204a623          	sw	zero,44(s1)
    p->cwd = idup(parent->cwd);
    80002c28:	1589b503          	ld	a0,344(s3)
    80002c2c:	10c010ef          	jal	80003d38 <idup>
    80002c30:	14a4bc23          	sd	a0,344(s1)

    // Initialize context
    memset(&p->context, 0, sizeof(p->context));
    80002c34:	07000613          	li	a2,112
    80002c38:	4581                	li	a1,0
    80002c3a:	06848513          	addi	a0,s1,104
    80002c3e:	8eefe0ef          	jal	80000d2c <memset>
    p->context.ra = (uint64)forkret;
    80002c42:	fffff797          	auipc	a5,0xfffff
    80002c46:	41c78793          	addi	a5,a5,1052 # 8000205e <forkret>
    80002c4a:	f4bc                	sd	a5,104(s1)
    p->context.sp = p->kstack + PGSIZE;
    80002c4c:	60bc                	ld	a5,64(s1)
    80002c4e:	6705                	lui	a4,0x1
    80002c50:	97ba                	add	a5,a5,a4
    80002c52:	f8bc                	sd	a5,112(s1)

    return p;
}
    80002c54:	8526                	mv	a0,s1
    80002c56:	70a2                	ld	ra,40(sp)
    80002c58:	7402                	ld	s0,32(sp)
    80002c5a:	64e2                	ld	s1,24(sp)
    80002c5c:	6942                	ld	s2,16(sp)
    80002c5e:	69a2                	ld	s3,8(sp)
    80002c60:	6145                	addi	sp,sp,48
    80002c62:	8082                	ret
        freeproc(p);
    80002c64:	8526                	mv	a0,s1
    80002c66:	d3aff0ef          	jal	800021a0 <freeproc>
        release(&p->lock);
    80002c6a:	8526                	mv	a0,s1
    80002c6c:	884fe0ef          	jal	80000cf0 <release>
        return 0;
    80002c70:	84ca                	mv	s1,s2
    80002c72:	b7cd                	j	80002c54 <allocthread+0xa8>
        freeproc(p);
    80002c74:	8526                	mv	a0,s1
    80002c76:	d2aff0ef          	jal	800021a0 <freeproc>
        release(&p->lock);
    80002c7a:	8526                	mv	a0,s1
    80002c7c:	874fe0ef          	jal	80000cf0 <release>
        return 0;
    80002c80:	84ca                	mv	s1,s2
    80002c82:	bfc9                	j	80002c54 <allocthread+0xa8>

0000000080002c84 <thread_create>:
int thread_create(uint64 fn, uint64 arg, uint64 stack) {
    80002c84:	7139                	addi	sp,sp,-64
    80002c86:	fc06                	sd	ra,56(sp)
    80002c88:	f822                	sd	s0,48(sp)
    80002c8a:	f04a                	sd	s2,32(sp)
    80002c8c:	ec4e                	sd	s3,24(sp)
    80002c8e:	e456                	sd	s5,8(sp)
    80002c90:	0080                	addi	s0,sp,64
    80002c92:	892a                	mv	s2,a0
    80002c94:	8aae                	mv	s5,a1
    80002c96:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002c98:	b96ff0ef          	jal	8000202e <myproc>
    if(fn == 0 || stack == 0) {
    80002c9c:	08090263          	beqz	s2,80002d20 <thread_create+0x9c>
    80002ca0:	e852                	sd	s4,16(sp)
    80002ca2:	8a2a                	mv	s4,a0
    80002ca4:	08098063          	beqz	s3,80002d24 <thread_create+0xa0>
    80002ca8:	f426                	sd	s1,40(sp)
    if((np = allocthread(p)) == 0) {
    80002caa:	f03ff0ef          	jal	80002bac <allocthread>
    80002cae:	84aa                	mv	s1,a0
    80002cb0:	cd2d                	beqz	a0,80002d2a <thread_create+0xa6>
     if(np->trapframe == 0) {
    80002cb2:	713c                	ld	a5,96(a0)
    80002cb4:	cfa9                	beqz	a5,80002d0e <thread_create+0x8a>
  *(np->trapframe) = *(p->trapframe);
    80002cb6:	060a3703          	ld	a4,96(s4)
    80002cba:	12070813          	addi	a6,a4,288 # 1120 <_entry-0x7fffeee0>
    80002cbe:	6308                	ld	a0,0(a4)
    80002cc0:	670c                	ld	a1,8(a4)
    80002cc2:	6b10                	ld	a2,16(a4)
    80002cc4:	6f14                	ld	a3,24(a4)
    80002cc6:	e388                	sd	a0,0(a5)
    80002cc8:	e78c                	sd	a1,8(a5)
    80002cca:	eb90                	sd	a2,16(a5)
    80002ccc:	ef94                	sd	a3,24(a5)
    80002cce:	02070713          	addi	a4,a4,32
    80002cd2:	02078793          	addi	a5,a5,32
    80002cd6:	ff0714e3          	bne	a4,a6,80002cbe <thread_create+0x3a>
    np->trapframe->a0 = arg;        // First argument
    80002cda:	70bc                	ld	a5,96(s1)
    80002cdc:	0757b823          	sd	s5,112(a5)
    np->trapframe->sp = stack;      // Stack pointer
    80002ce0:	70bc                	ld	a5,96(s1)
    80002ce2:	0337b823          	sd	s3,48(a5)
    np->trapframe->epc = fn;        // Program counter
    80002ce6:	70bc                	ld	a5,96(s1)
    80002ce8:	0127bc23          	sd	s2,24(a5)
    np->state = RUNNABLE;
    80002cec:	478d                	li	a5,3
    80002cee:	cc9c                	sw	a5,24(s1)
    int pid = np->pid;
    80002cf0:	0304a903          	lw	s2,48(s1)
    release(&np->lock);
    80002cf4:	8526                	mv	a0,s1
    80002cf6:	ffbfd0ef          	jal	80000cf0 <release>
    return pid;
    80002cfa:	74a2                	ld	s1,40(sp)
    80002cfc:	6a42                	ld	s4,16(sp)
}
    80002cfe:	854a                	mv	a0,s2
    80002d00:	70e2                	ld	ra,56(sp)
    80002d02:	7442                	ld	s0,48(sp)
    80002d04:	7902                	ld	s2,32(sp)
    80002d06:	69e2                	ld	s3,24(sp)
    80002d08:	6aa2                	ld	s5,8(sp)
    80002d0a:	6121                	addi	sp,sp,64
    80002d0c:	8082                	ret
        freeproc(np);
    80002d0e:	c92ff0ef          	jal	800021a0 <freeproc>
        release(&np->lock);
    80002d12:	8526                	mv	a0,s1
    80002d14:	fddfd0ef          	jal	80000cf0 <release>
        return -1;
    80002d18:	597d                	li	s2,-1
    80002d1a:	74a2                	ld	s1,40(sp)
    80002d1c:	6a42                	ld	s4,16(sp)
    80002d1e:	b7c5                	j	80002cfe <thread_create+0x7a>
        return -1;
    80002d20:	597d                	li	s2,-1
    80002d22:	bff1                	j	80002cfe <thread_create+0x7a>
    80002d24:	597d                	li	s2,-1
    80002d26:	6a42                	ld	s4,16(sp)
    80002d28:	bfd9                	j	80002cfe <thread_create+0x7a>
        return -1;
    80002d2a:	597d                	li	s2,-1
    80002d2c:	74a2                	ld	s1,40(sp)
    80002d2e:	6a42                	ld	s4,16(sp)
    80002d30:	b7f9                	j	80002cfe <thread_create+0x7a>

0000000080002d32 <swtch>:
    80002d32:	00153023          	sd	ra,0(a0)
    80002d36:	00253423          	sd	sp,8(a0)
    80002d3a:	e900                	sd	s0,16(a0)
    80002d3c:	ed04                	sd	s1,24(a0)
    80002d3e:	03253023          	sd	s2,32(a0)
    80002d42:	03353423          	sd	s3,40(a0)
    80002d46:	03453823          	sd	s4,48(a0)
    80002d4a:	03553c23          	sd	s5,56(a0)
    80002d4e:	05653023          	sd	s6,64(a0)
    80002d52:	05753423          	sd	s7,72(a0)
    80002d56:	05853823          	sd	s8,80(a0)
    80002d5a:	05953c23          	sd	s9,88(a0)
    80002d5e:	07a53023          	sd	s10,96(a0)
    80002d62:	07b53423          	sd	s11,104(a0)
    80002d66:	0005b083          	ld	ra,0(a1)
    80002d6a:	0085b103          	ld	sp,8(a1)
    80002d6e:	6980                	ld	s0,16(a1)
    80002d70:	6d84                	ld	s1,24(a1)
    80002d72:	0205b903          	ld	s2,32(a1)
    80002d76:	0285b983          	ld	s3,40(a1)
    80002d7a:	0305ba03          	ld	s4,48(a1)
    80002d7e:	0385ba83          	ld	s5,56(a1)
    80002d82:	0405bb03          	ld	s6,64(a1)
    80002d86:	0485bb83          	ld	s7,72(a1)
    80002d8a:	0505bc03          	ld	s8,80(a1)
    80002d8e:	0585bc83          	ld	s9,88(a1)
    80002d92:	0605bd03          	ld	s10,96(a1)
    80002d96:	0685bd83          	ld	s11,104(a1)
    80002d9a:	8082                	ret

0000000080002d9c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80002d9c:	1141                	addi	sp,sp,-16
    80002d9e:	e406                	sd	ra,8(sp)
    80002da0:	e022                	sd	s0,0(sp)
    80002da2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80002da4:	00005597          	auipc	a1,0x5
    80002da8:	5b458593          	addi	a1,a1,1460 # 80008358 <etext+0x358>
    80002dac:	001ac517          	auipc	a0,0x1ac
    80002db0:	f5450513          	addi	a0,a0,-172 # 801aed00 <tickslock>
    80002db4:	e25fd0ef          	jal	80000bd8 <initlock>
}
    80002db8:	60a2                	ld	ra,8(sp)
    80002dba:	6402                	ld	s0,0(sp)
    80002dbc:	0141                	addi	sp,sp,16
    80002dbe:	8082                	ret

0000000080002dc0 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80002dc0:	1141                	addi	sp,sp,-16
    80002dc2:	e422                	sd	s0,8(sp)
    80002dc4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002dc6:	00003797          	auipc	a5,0x3
    80002dca:	fca78793          	addi	a5,a5,-54 # 80005d90 <kernelvec>
    80002dce:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002dd2:	6422                	ld	s0,8(sp)
    80002dd4:	0141                	addi	sp,sp,16
    80002dd6:	8082                	ret

0000000080002dd8 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80002dd8:	1141                	addi	sp,sp,-16
    80002dda:	e406                	sd	ra,8(sp)
    80002ddc:	e022                	sd	s0,0(sp)
    80002dde:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002de0:	a4eff0ef          	jal	8000202e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002de4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002de8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002dea:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80002dee:	00004697          	auipc	a3,0x4
    80002df2:	21268693          	addi	a3,a3,530 # 80007000 <_trampoline>
    80002df6:	00004717          	auipc	a4,0x4
    80002dfa:	20a70713          	addi	a4,a4,522 # 80007000 <_trampoline>
    80002dfe:	8f15                	sub	a4,a4,a3
    80002e00:	040007b7          	lui	a5,0x4000
    80002e04:	17fd                	addi	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80002e06:	07b2                	slli	a5,a5,0xc
    80002e08:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002e0a:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80002e0e:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80002e10:	18002673          	csrr	a2,satp
    80002e14:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002e16:	7130                	ld	a2,96(a0)
    80002e18:	6138                	ld	a4,64(a0)
    80002e1a:	6585                	lui	a1,0x1
    80002e1c:	972e                	add	a4,a4,a1
    80002e1e:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002e20:	7138                	ld	a4,96(a0)
    80002e22:	00000617          	auipc	a2,0x0
    80002e26:	11060613          	addi	a2,a2,272 # 80002f32 <usertrap>
    80002e2a:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80002e2c:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80002e2e:	8612                	mv	a2,tp
    80002e30:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e32:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002e36:	eff77713          	andi	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002e3a:	02076713          	ori	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e3e:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002e42:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002e44:	6f18                	ld	a4,24(a4)
    80002e46:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80002e4a:	6d28                	ld	a0,88(a0)
    80002e4c:	8131                	srli	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80002e4e:	00004717          	auipc	a4,0x4
    80002e52:	24e70713          	addi	a4,a4,590 # 8000709c <userret>
    80002e56:	8f15                	sub	a4,a4,a3
    80002e58:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80002e5a:	577d                	li	a4,-1
    80002e5c:	177e                	slli	a4,a4,0x3f
    80002e5e:	8d59                	or	a0,a0,a4
    80002e60:	9782                	jalr	a5
}
    80002e62:	60a2                	ld	ra,8(sp)
    80002e64:	6402                	ld	s0,0(sp)
    80002e66:	0141                	addi	sp,sp,16
    80002e68:	8082                	ret

0000000080002e6a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002e6a:	1101                	addi	sp,sp,-32
    80002e6c:	ec06                	sd	ra,24(sp)
    80002e6e:	e822                	sd	s0,16(sp)
    80002e70:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    80002e72:	990ff0ef          	jal	80002002 <cpuid>
    80002e76:	cd11                	beqz	a0,80002e92 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80002e78:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002e7c:	000f4737          	lui	a4,0xf4
    80002e80:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002e84:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80002e86:	14d79073          	csrw	stimecmp,a5
}
    80002e8a:	60e2                	ld	ra,24(sp)
    80002e8c:	6442                	ld	s0,16(sp)
    80002e8e:	6105                	addi	sp,sp,32
    80002e90:	8082                	ret
    80002e92:	e426                	sd	s1,8(sp)
    acquire(&tickslock);
    80002e94:	001ac497          	auipc	s1,0x1ac
    80002e98:	e6c48493          	addi	s1,s1,-404 # 801aed00 <tickslock>
    80002e9c:	8526                	mv	a0,s1
    80002e9e:	dbbfd0ef          	jal	80000c58 <acquire>
    ticks++;
    80002ea2:	00006517          	auipc	a0,0x6
    80002ea6:	bce50513          	addi	a0,a0,-1074 # 80008a70 <ticks>
    80002eaa:	411c                	lw	a5,0(a0)
    80002eac:	2785                	addiw	a5,a5,1
    80002eae:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80002eb0:	fb4ff0ef          	jal	80002664 <wakeup>
    release(&tickslock);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	e3bfd0ef          	jal	80000cf0 <release>
    80002eba:	64a2                	ld	s1,8(sp)
    80002ebc:	bf75                	j	80002e78 <clockintr+0xe>

0000000080002ebe <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80002ebe:	1101                	addi	sp,sp,-32
    80002ec0:	ec06                	sd	ra,24(sp)
    80002ec2:	e822                	sd	s0,16(sp)
    80002ec4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002ec6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80002eca:	57fd                	li	a5,-1
    80002ecc:	17fe                	slli	a5,a5,0x3f
    80002ece:	07a5                	addi	a5,a5,9
    80002ed0:	00f70c63          	beq	a4,a5,80002ee8 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80002ed4:	57fd                	li	a5,-1
    80002ed6:	17fe                	slli	a5,a5,0x3f
    80002ed8:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80002eda:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80002edc:	04f70763          	beq	a4,a5,80002f2a <devintr+0x6c>
  }
}
    80002ee0:	60e2                	ld	ra,24(sp)
    80002ee2:	6442                	ld	s0,16(sp)
    80002ee4:	6105                	addi	sp,sp,32
    80002ee6:	8082                	ret
    80002ee8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002eea:	753020ef          	jal	80005e3c <plic_claim>
    80002eee:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80002ef0:	47a9                	li	a5,10
    80002ef2:	00f50963          	beq	a0,a5,80002f04 <devintr+0x46>
    } else if(irq == VIRTIO0_IRQ){
    80002ef6:	4785                	li	a5,1
    80002ef8:	00f50963          	beq	a0,a5,80002f0a <devintr+0x4c>
    return 1;
    80002efc:	4505                	li	a0,1
    } else if(irq){
    80002efe:	e889                	bnez	s1,80002f10 <devintr+0x52>
    80002f00:	64a2                	ld	s1,8(sp)
    80002f02:	bff9                	j	80002ee0 <devintr+0x22>
      uartintr();
    80002f04:	b67fd0ef          	jal	80000a6a <uartintr>
    if(irq)
    80002f08:	a819                	j	80002f1e <devintr+0x60>
      virtio_disk_intr();
    80002f0a:	3f8030ef          	jal	80006302 <virtio_disk_intr>
    if(irq)
    80002f0e:	a801                	j	80002f1e <devintr+0x60>
      printf("unexpected interrupt irq=%d\n", irq);
    80002f10:	85a6                	mv	a1,s1
    80002f12:	00005517          	auipc	a0,0x5
    80002f16:	44e50513          	addi	a0,a0,1102 # 80008360 <etext+0x360>
    80002f1a:	e0cfd0ef          	jal	80000526 <printf>
      plic_complete(irq);
    80002f1e:	8526                	mv	a0,s1
    80002f20:	73d020ef          	jal	80005e5c <plic_complete>
    return 1;
    80002f24:	4505                	li	a0,1
    80002f26:	64a2                	ld	s1,8(sp)
    80002f28:	bf65                	j	80002ee0 <devintr+0x22>
    clockintr();
    80002f2a:	f41ff0ef          	jal	80002e6a <clockintr>
    return 2;
    80002f2e:	4509                	li	a0,2
    80002f30:	bf45                	j	80002ee0 <devintr+0x22>

0000000080002f32 <usertrap>:
{
    80002f32:	1101                	addi	sp,sp,-32
    80002f34:	ec06                	sd	ra,24(sp)
    80002f36:	e822                	sd	s0,16(sp)
    80002f38:	e426                	sd	s1,8(sp)
    80002f3a:	e04a                	sd	s2,0(sp)
    80002f3c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f3e:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002f42:	1007f793          	andi	a5,a5,256
    80002f46:	e3bd                	bnez	a5,80002fac <usertrap+0x7a>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002f48:	00003797          	auipc	a5,0x3
    80002f4c:	e4878793          	addi	a5,a5,-440 # 80005d90 <kernelvec>
    80002f50:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002f54:	8daff0ef          	jal	8000202e <myproc>
    80002f58:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80002f5a:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002f5c:	14102773          	csrr	a4,sepc
    80002f60:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002f62:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80002f66:	47a1                	li	a5,8
    80002f68:	04f71f63          	bne	a4,a5,80002fc6 <usertrap+0x94>
    if(p != 0 && p->state == RUNNING){
    80002f6c:	4d18                	lw	a4,24(a0)
    80002f6e:	4791                	li	a5,4
    80002f70:	04f70463          	beq	a4,a5,80002fb8 <usertrap+0x86>
    if(killed(p))
    80002f74:	8526                	mv	a0,s1
    80002f76:	8dbff0ef          	jal	80002850 <killed>
    80002f7a:	e131                	bnez	a0,80002fbe <usertrap+0x8c>
    p->trapframe->epc += 4;
    80002f7c:	70b8                	ld	a4,96(s1)
    80002f7e:	6f1c                	ld	a5,24(a4)
    80002f80:	0791                	addi	a5,a5,4
    80002f82:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f84:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002f88:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002f8c:	10079073          	csrw	sstatus,a5
    syscall();
    80002f90:	270000ef          	jal	80003200 <syscall>
  if(killed(p))
    80002f94:	8526                	mv	a0,s1
    80002f96:	8bbff0ef          	jal	80002850 <killed>
    80002f9a:	e535                	bnez	a0,80003006 <usertrap+0xd4>
  usertrapret();
    80002f9c:	e3dff0ef          	jal	80002dd8 <usertrapret>
}
    80002fa0:	60e2                	ld	ra,24(sp)
    80002fa2:	6442                	ld	s0,16(sp)
    80002fa4:	64a2                	ld	s1,8(sp)
    80002fa6:	6902                	ld	s2,0(sp)
    80002fa8:	6105                	addi	sp,sp,32
    80002faa:	8082                	ret
    panic("usertrap: not from user mode");
    80002fac:	00005517          	auipc	a0,0x5
    80002fb0:	3d450513          	addi	a0,a0,980 # 80008380 <etext+0x380>
    80002fb4:	845fd0ef          	jal	800007f8 <panic>
      handle_signals();
    80002fb8:	b03ff0ef          	jal	80002aba <handle_signals>
    80002fbc:	bf65                	j	80002f74 <usertrap+0x42>
      exit(-1);
    80002fbe:	557d                	li	a0,-1
    80002fc0:	f64ff0ef          	jal	80002724 <exit>
    80002fc4:	bf65                	j	80002f7c <usertrap+0x4a>
  } else if((which_dev = devintr()) != 0){
    80002fc6:	ef9ff0ef          	jal	80002ebe <devintr>
    80002fca:	892a                	mv	s2,a0
    80002fcc:	c511                	beqz	a0,80002fd8 <usertrap+0xa6>
  if(killed(p))
    80002fce:	8526                	mv	a0,s1
    80002fd0:	881ff0ef          	jal	80002850 <killed>
    80002fd4:	cd0d                	beqz	a0,8000300e <usertrap+0xdc>
    80002fd6:	a80d                	j	80003008 <usertrap+0xd6>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002fd8:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002fdc:	5890                	lw	a2,48(s1)
    80002fde:	00005517          	auipc	a0,0x5
    80002fe2:	3c250513          	addi	a0,a0,962 # 800083a0 <etext+0x3a0>
    80002fe6:	d40fd0ef          	jal	80000526 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002fea:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002fee:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80002ff2:	00005517          	auipc	a0,0x5
    80002ff6:	3de50513          	addi	a0,a0,990 # 800083d0 <etext+0x3d0>
    80002ffa:	d2cfd0ef          	jal	80000526 <printf>
    setkilled(p);
    80002ffe:	8526                	mv	a0,s1
    80003000:	82dff0ef          	jal	8000282c <setkilled>
    80003004:	bf41                	j	80002f94 <usertrap+0x62>
  if(killed(p))
    80003006:	4901                	li	s2,0
    exit(-1);
    80003008:	557d                	li	a0,-1
    8000300a:	f1aff0ef          	jal	80002724 <exit>
  if(which_dev == 2)
    8000300e:	4789                	li	a5,2
    80003010:	f8f916e3          	bne	s2,a5,80002f9c <usertrap+0x6a>
    yield();
    80003014:	dd8ff0ef          	jal	800025ec <yield>
    80003018:	b751                	j	80002f9c <usertrap+0x6a>

000000008000301a <kerneltrap>:
{
    8000301a:	7179                	addi	sp,sp,-48
    8000301c:	f406                	sd	ra,40(sp)
    8000301e:	f022                	sd	s0,32(sp)
    80003020:	ec26                	sd	s1,24(sp)
    80003022:	e84a                	sd	s2,16(sp)
    80003024:	e44e                	sd	s3,8(sp)
    80003026:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003028:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000302c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003030:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003034:	1004f793          	andi	a5,s1,256
    80003038:	c795                	beqz	a5,80003064 <kerneltrap+0x4a>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000303a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000303e:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80003040:	eb85                	bnez	a5,80003070 <kerneltrap+0x56>
  if((which_dev = devintr()) == 0){
    80003042:	e7dff0ef          	jal	80002ebe <devintr>
    80003046:	c91d                	beqz	a0,8000307c <kerneltrap+0x62>
  if(which_dev == 2 && myproc() != 0)
    80003048:	4789                	li	a5,2
    8000304a:	04f50a63          	beq	a0,a5,8000309e <kerneltrap+0x84>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000304e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003052:	10049073          	csrw	sstatus,s1
}
    80003056:	70a2                	ld	ra,40(sp)
    80003058:	7402                	ld	s0,32(sp)
    8000305a:	64e2                	ld	s1,24(sp)
    8000305c:	6942                	ld	s2,16(sp)
    8000305e:	69a2                	ld	s3,8(sp)
    80003060:	6145                	addi	sp,sp,48
    80003062:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003064:	00005517          	auipc	a0,0x5
    80003068:	39450513          	addi	a0,a0,916 # 800083f8 <etext+0x3f8>
    8000306c:	f8cfd0ef          	jal	800007f8 <panic>
    panic("kerneltrap: interrupts enabled");
    80003070:	00005517          	auipc	a0,0x5
    80003074:	3b050513          	addi	a0,a0,944 # 80008420 <etext+0x420>
    80003078:	f80fd0ef          	jal	800007f8 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000307c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003080:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80003084:	85ce                	mv	a1,s3
    80003086:	00005517          	auipc	a0,0x5
    8000308a:	3ba50513          	addi	a0,a0,954 # 80008440 <etext+0x440>
    8000308e:	c98fd0ef          	jal	80000526 <printf>
    panic("kerneltrap");
    80003092:	00005517          	auipc	a0,0x5
    80003096:	3d650513          	addi	a0,a0,982 # 80008468 <etext+0x468>
    8000309a:	f5efd0ef          	jal	800007f8 <panic>
  if(which_dev == 2 && myproc() != 0)
    8000309e:	f91fe0ef          	jal	8000202e <myproc>
    800030a2:	d555                	beqz	a0,8000304e <kerneltrap+0x34>
    yield();
    800030a4:	d48ff0ef          	jal	800025ec <yield>
    800030a8:	b75d                	j	8000304e <kerneltrap+0x34>

00000000800030aa <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800030aa:	1101                	addi	sp,sp,-32
    800030ac:	ec06                	sd	ra,24(sp)
    800030ae:	e822                	sd	s0,16(sp)
    800030b0:	e426                	sd	s1,8(sp)
    800030b2:	1000                	addi	s0,sp,32
    800030b4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800030b6:	f79fe0ef          	jal	8000202e <myproc>
  switch (n) {
    800030ba:	4795                	li	a5,5
    800030bc:	0497e163          	bltu	a5,s1,800030fe <argraw+0x54>
    800030c0:	048a                	slli	s1,s1,0x2
    800030c2:	00006717          	auipc	a4,0x6
    800030c6:	81670713          	addi	a4,a4,-2026 # 800088d8 <states.0+0x30>
    800030ca:	94ba                	add	s1,s1,a4
    800030cc:	409c                	lw	a5,0(s1)
    800030ce:	97ba                	add	a5,a5,a4
    800030d0:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800030d2:	713c                	ld	a5,96(a0)
    800030d4:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    800030d6:	60e2                	ld	ra,24(sp)
    800030d8:	6442                	ld	s0,16(sp)
    800030da:	64a2                	ld	s1,8(sp)
    800030dc:	6105                	addi	sp,sp,32
    800030de:	8082                	ret
    return p->trapframe->a1;
    800030e0:	713c                	ld	a5,96(a0)
    800030e2:	7fa8                	ld	a0,120(a5)
    800030e4:	bfcd                	j	800030d6 <argraw+0x2c>
    return p->trapframe->a2;
    800030e6:	713c                	ld	a5,96(a0)
    800030e8:	63c8                	ld	a0,128(a5)
    800030ea:	b7f5                	j	800030d6 <argraw+0x2c>
    return p->trapframe->a3;
    800030ec:	713c                	ld	a5,96(a0)
    800030ee:	67c8                	ld	a0,136(a5)
    800030f0:	b7dd                	j	800030d6 <argraw+0x2c>
    return p->trapframe->a4;
    800030f2:	713c                	ld	a5,96(a0)
    800030f4:	6bc8                	ld	a0,144(a5)
    800030f6:	b7c5                	j	800030d6 <argraw+0x2c>
    return p->trapframe->a5;
    800030f8:	713c                	ld	a5,96(a0)
    800030fa:	6fc8                	ld	a0,152(a5)
    800030fc:	bfe9                	j	800030d6 <argraw+0x2c>
  panic("argraw");
    800030fe:	00005517          	auipc	a0,0x5
    80003102:	37a50513          	addi	a0,a0,890 # 80008478 <etext+0x478>
    80003106:	ef2fd0ef          	jal	800007f8 <panic>

000000008000310a <fetchaddr>:
{
    8000310a:	1101                	addi	sp,sp,-32
    8000310c:	ec06                	sd	ra,24(sp)
    8000310e:	e822                	sd	s0,16(sp)
    80003110:	e426                	sd	s1,8(sp)
    80003112:	e04a                	sd	s2,0(sp)
    80003114:	1000                	addi	s0,sp,32
    80003116:	84aa                	mv	s1,a0
    80003118:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000311a:	f15fe0ef          	jal	8000202e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000311e:	693c                	ld	a5,80(a0)
    80003120:	02f4f663          	bgeu	s1,a5,8000314c <fetchaddr+0x42>
    80003124:	00848713          	addi	a4,s1,8
    80003128:	02e7e463          	bltu	a5,a4,80003150 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000312c:	46a1                	li	a3,8
    8000312e:	8626                	mv	a2,s1
    80003130:	85ca                	mv	a1,s2
    80003132:	6d28                	ld	a0,88(a0)
    80003134:	c1ffe0ef          	jal	80001d52 <copyin>
    80003138:	00a03533          	snez	a0,a0
    8000313c:	40a00533          	neg	a0,a0
}
    80003140:	60e2                	ld	ra,24(sp)
    80003142:	6442                	ld	s0,16(sp)
    80003144:	64a2                	ld	s1,8(sp)
    80003146:	6902                	ld	s2,0(sp)
    80003148:	6105                	addi	sp,sp,32
    8000314a:	8082                	ret
    return -1;
    8000314c:	557d                	li	a0,-1
    8000314e:	bfcd                	j	80003140 <fetchaddr+0x36>
    80003150:	557d                	li	a0,-1
    80003152:	b7fd                	j	80003140 <fetchaddr+0x36>

0000000080003154 <fetchstr>:
{
    80003154:	7179                	addi	sp,sp,-48
    80003156:	f406                	sd	ra,40(sp)
    80003158:	f022                	sd	s0,32(sp)
    8000315a:	ec26                	sd	s1,24(sp)
    8000315c:	e84a                	sd	s2,16(sp)
    8000315e:	e44e                	sd	s3,8(sp)
    80003160:	1800                	addi	s0,sp,48
    80003162:	892a                	mv	s2,a0
    80003164:	84ae                	mv	s1,a1
    80003166:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003168:	ec7fe0ef          	jal	8000202e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000316c:	86ce                	mv	a3,s3
    8000316e:	864a                	mv	a2,s2
    80003170:	85a6                	mv	a1,s1
    80003172:	6d28                	ld	a0,88(a0)
    80003174:	c65fe0ef          	jal	80001dd8 <copyinstr>
    80003178:	00054c63          	bltz	a0,80003190 <fetchstr+0x3c>
  return strlen(buf);
    8000317c:	8526                	mv	a0,s1
    8000317e:	d1ffd0ef          	jal	80000e9c <strlen>
}
    80003182:	70a2                	ld	ra,40(sp)
    80003184:	7402                	ld	s0,32(sp)
    80003186:	64e2                	ld	s1,24(sp)
    80003188:	6942                	ld	s2,16(sp)
    8000318a:	69a2                	ld	s3,8(sp)
    8000318c:	6145                	addi	sp,sp,48
    8000318e:	8082                	ret
    return -1;
    80003190:	557d                	li	a0,-1
    80003192:	bfc5                	j	80003182 <fetchstr+0x2e>

0000000080003194 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80003194:	1101                	addi	sp,sp,-32
    80003196:	ec06                	sd	ra,24(sp)
    80003198:	e822                	sd	s0,16(sp)
    8000319a:	e426                	sd	s1,8(sp)
    8000319c:	1000                	addi	s0,sp,32
    8000319e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031a0:	f0bff0ef          	jal	800030aa <argraw>
    800031a4:	c088                	sw	a0,0(s1)
  return 0;
}
    800031a6:	4501                	li	a0,0
    800031a8:	60e2                	ld	ra,24(sp)
    800031aa:	6442                	ld	s0,16(sp)
    800031ac:	64a2                	ld	s1,8(sp)
    800031ae:	6105                	addi	sp,sp,32
    800031b0:	8082                	ret

00000000800031b2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    800031b2:	1101                	addi	sp,sp,-32
    800031b4:	ec06                	sd	ra,24(sp)
    800031b6:	e822                	sd	s0,16(sp)
    800031b8:	e426                	sd	s1,8(sp)
    800031ba:	1000                	addi	s0,sp,32
    800031bc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800031be:	eedff0ef          	jal	800030aa <argraw>
    800031c2:	e088                	sd	a0,0(s1)
  return 0;
}
    800031c4:	4501                	li	a0,0
    800031c6:	60e2                	ld	ra,24(sp)
    800031c8:	6442                	ld	s0,16(sp)
    800031ca:	64a2                	ld	s1,8(sp)
    800031cc:	6105                	addi	sp,sp,32
    800031ce:	8082                	ret

00000000800031d0 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800031d0:	7179                	addi	sp,sp,-48
    800031d2:	f406                	sd	ra,40(sp)
    800031d4:	f022                	sd	s0,32(sp)
    800031d6:	ec26                	sd	s1,24(sp)
    800031d8:	e84a                	sd	s2,16(sp)
    800031da:	1800                	addi	s0,sp,48
    800031dc:	84ae                	mv	s1,a1
    800031de:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    800031e0:	fd840593          	addi	a1,s0,-40
    800031e4:	fcfff0ef          	jal	800031b2 <argaddr>
  return fetchstr(addr, buf, max);
    800031e8:	864a                	mv	a2,s2
    800031ea:	85a6                	mv	a1,s1
    800031ec:	fd843503          	ld	a0,-40(s0)
    800031f0:	f65ff0ef          	jal	80003154 <fetchstr>
}
    800031f4:	70a2                	ld	ra,40(sp)
    800031f6:	7402                	ld	s0,32(sp)
    800031f8:	64e2                	ld	s1,24(sp)
    800031fa:	6942                	ld	s2,16(sp)
    800031fc:	6145                	addi	sp,sp,48
    800031fe:	8082                	ret

0000000080003200 <syscall>:
[SYS_thread_join] sys_thread_join,
};

void
syscall(void)
{
    80003200:	1101                	addi	sp,sp,-32
    80003202:	ec06                	sd	ra,24(sp)
    80003204:	e822                	sd	s0,16(sp)
    80003206:	e426                	sd	s1,8(sp)
    80003208:	e04a                	sd	s2,0(sp)
    8000320a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000320c:	e23fe0ef          	jal	8000202e <myproc>
    80003210:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003212:	06053903          	ld	s2,96(a0)
    80003216:	0a893783          	ld	a5,168(s2)
    8000321a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000321e:	37fd                	addiw	a5,a5,-1
    80003220:	4775                	li	a4,29
    80003222:	00f76f63          	bltu	a4,a5,80003240 <syscall+0x40>
    80003226:	00369713          	slli	a4,a3,0x3
    8000322a:	00005797          	auipc	a5,0x5
    8000322e:	6c678793          	addi	a5,a5,1734 # 800088f0 <syscalls>
    80003232:	97ba                	add	a5,a5,a4
    80003234:	639c                	ld	a5,0(a5)
    80003236:	c789                	beqz	a5,80003240 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003238:	9782                	jalr	a5
    8000323a:	06a93823          	sd	a0,112(s2)
    8000323e:	a829                	j	80003258 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003240:	16048613          	addi	a2,s1,352
    80003244:	588c                	lw	a1,48(s1)
    80003246:	00005517          	auipc	a0,0x5
    8000324a:	23a50513          	addi	a0,a0,570 # 80008480 <etext+0x480>
    8000324e:	ad8fd0ef          	jal	80000526 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80003252:	70bc                	ld	a5,96(s1)
    80003254:	577d                	li	a4,-1
    80003256:	fbb8                	sd	a4,112(a5)
  }
}
    80003258:	60e2                	ld	ra,24(sp)
    8000325a:	6442                	ld	s0,16(sp)
    8000325c:	64a2                	ld	s1,8(sp)
    8000325e:	6902                	ld	s2,0(sp)
    80003260:	6105                	addi	sp,sp,32
    80003262:	8082                	ret

0000000080003264 <sys_exit>:
#include "proc.h"
#include "syscall.h"

uint64
sys_exit(void)
{
    80003264:	1101                	addi	sp,sp,-32
    80003266:	ec06                	sd	ra,24(sp)
    80003268:	e822                	sd	s0,16(sp)
    8000326a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000326c:	fec40593          	addi	a1,s0,-20
    80003270:	4501                	li	a0,0
    80003272:	f23ff0ef          	jal	80003194 <argint>
  exit(n);
    80003276:	fec42503          	lw	a0,-20(s0)
    8000327a:	caaff0ef          	jal	80002724 <exit>
  return 0;  // not reached
}
    8000327e:	4501                	li	a0,0
    80003280:	60e2                	ld	ra,24(sp)
    80003282:	6442                	ld	s0,16(sp)
    80003284:	6105                	addi	sp,sp,32
    80003286:	8082                	ret

0000000080003288 <sys_getpid>:

uint64
sys_getpid(void)
{
    80003288:	1141                	addi	sp,sp,-16
    8000328a:	e406                	sd	ra,8(sp)
    8000328c:	e022                	sd	s0,0(sp)
    8000328e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80003290:	d9ffe0ef          	jal	8000202e <myproc>
}
    80003294:	5908                	lw	a0,48(a0)
    80003296:	60a2                	ld	ra,8(sp)
    80003298:	6402                	ld	s0,0(sp)
    8000329a:	0141                	addi	sp,sp,16
    8000329c:	8082                	ret

000000008000329e <sys_fork>:

uint64
sys_fork(void)
{
    8000329e:	1141                	addi	sp,sp,-16
    800032a0:	e406                	sd	ra,8(sp)
    800032a2:	e022                	sd	s0,0(sp)
    800032a4:	0800                	addi	s0,sp,16
  return fork();
    800032a6:	8caff0ef          	jal	80002370 <fork>
}
    800032aa:	60a2                	ld	ra,8(sp)
    800032ac:	6402                	ld	s0,0(sp)
    800032ae:	0141                	addi	sp,sp,16
    800032b0:	8082                	ret

00000000800032b2 <sys_wait>:

uint64
sys_wait(void)
{
    800032b2:	1101                	addi	sp,sp,-32
    800032b4:	ec06                	sd	ra,24(sp)
    800032b6:	e822                	sd	s0,16(sp)
    800032b8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800032ba:	fe840593          	addi	a1,s0,-24
    800032be:	4501                	li	a0,0
    800032c0:	ef3ff0ef          	jal	800031b2 <argaddr>
  return wait(p);
    800032c4:	fe843503          	ld	a0,-24(s0)
    800032c8:	db2ff0ef          	jal	8000287a <wait>
}
    800032cc:	60e2                	ld	ra,24(sp)
    800032ce:	6442                	ld	s0,16(sp)
    800032d0:	6105                	addi	sp,sp,32
    800032d2:	8082                	ret

00000000800032d4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800032d4:	7179                	addi	sp,sp,-48
    800032d6:	f406                	sd	ra,40(sp)
    800032d8:	f022                	sd	s0,32(sp)
    800032da:	ec26                	sd	s1,24(sp)
    800032dc:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800032de:	fdc40593          	addi	a1,s0,-36
    800032e2:	4501                	li	a0,0
    800032e4:	eb1ff0ef          	jal	80003194 <argint>
  addr = myproc()->sz;
    800032e8:	d47fe0ef          	jal	8000202e <myproc>
    800032ec:	6924                	ld	s1,80(a0)
  if(growproc(n) < 0)
    800032ee:	fdc42503          	lw	a0,-36(s0)
    800032f2:	82eff0ef          	jal	80002320 <growproc>
    800032f6:	00054863          	bltz	a0,80003306 <sys_sbrk+0x32>
    return -1;
  return addr;
}
    800032fa:	8526                	mv	a0,s1
    800032fc:	70a2                	ld	ra,40(sp)
    800032fe:	7402                	ld	s0,32(sp)
    80003300:	64e2                	ld	s1,24(sp)
    80003302:	6145                	addi	sp,sp,48
    80003304:	8082                	ret
    return -1;
    80003306:	54fd                	li	s1,-1
    80003308:	bfcd                	j	800032fa <sys_sbrk+0x26>

000000008000330a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000330a:	7139                	addi	sp,sp,-64
    8000330c:	fc06                	sd	ra,56(sp)
    8000330e:	f822                	sd	s0,48(sp)
    80003310:	f04a                	sd	s2,32(sp)
    80003312:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80003314:	fcc40593          	addi	a1,s0,-52
    80003318:	4501                	li	a0,0
    8000331a:	e7bff0ef          	jal	80003194 <argint>
  if(n < 0)
    8000331e:	fcc42783          	lw	a5,-52(s0)
    80003322:	0607c763          	bltz	a5,80003390 <sys_sleep+0x86>
    n = 0;
  acquire(&tickslock);
    80003326:	001ac517          	auipc	a0,0x1ac
    8000332a:	9da50513          	addi	a0,a0,-1574 # 801aed00 <tickslock>
    8000332e:	92bfd0ef          	jal	80000c58 <acquire>
  ticks0 = ticks;
    80003332:	00005917          	auipc	s2,0x5
    80003336:	73e92903          	lw	s2,1854(s2) # 80008a70 <ticks>
  while(ticks - ticks0 < n){
    8000333a:	fcc42783          	lw	a5,-52(s0)
    8000333e:	cf8d                	beqz	a5,80003378 <sys_sleep+0x6e>
    80003340:	f426                	sd	s1,40(sp)
    80003342:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80003344:	001ac997          	auipc	s3,0x1ac
    80003348:	9bc98993          	addi	s3,s3,-1604 # 801aed00 <tickslock>
    8000334c:	00005497          	auipc	s1,0x5
    80003350:	72448493          	addi	s1,s1,1828 # 80008a70 <ticks>
    if(killed(myproc())){
    80003354:	cdbfe0ef          	jal	8000202e <myproc>
    80003358:	cf8ff0ef          	jal	80002850 <killed>
    8000335c:	ed0d                	bnez	a0,80003396 <sys_sleep+0x8c>
    sleep(&ticks, &tickslock);
    8000335e:	85ce                	mv	a1,s3
    80003360:	8526                	mv	a0,s1
    80003362:	ab6ff0ef          	jal	80002618 <sleep>
  while(ticks - ticks0 < n){
    80003366:	409c                	lw	a5,0(s1)
    80003368:	412787bb          	subw	a5,a5,s2
    8000336c:	fcc42703          	lw	a4,-52(s0)
    80003370:	fee7e2e3          	bltu	a5,a4,80003354 <sys_sleep+0x4a>
    80003374:	74a2                	ld	s1,40(sp)
    80003376:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80003378:	001ac517          	auipc	a0,0x1ac
    8000337c:	98850513          	addi	a0,a0,-1656 # 801aed00 <tickslock>
    80003380:	971fd0ef          	jal	80000cf0 <release>
  return 0;
    80003384:	4501                	li	a0,0
}
    80003386:	70e2                	ld	ra,56(sp)
    80003388:	7442                	ld	s0,48(sp)
    8000338a:	7902                	ld	s2,32(sp)
    8000338c:	6121                	addi	sp,sp,64
    8000338e:	8082                	ret
    n = 0;
    80003390:	fc042623          	sw	zero,-52(s0)
    80003394:	bf49                	j	80003326 <sys_sleep+0x1c>
      release(&tickslock);
    80003396:	001ac517          	auipc	a0,0x1ac
    8000339a:	96a50513          	addi	a0,a0,-1686 # 801aed00 <tickslock>
    8000339e:	953fd0ef          	jal	80000cf0 <release>
      return -1;
    800033a2:	557d                	li	a0,-1
    800033a4:	74a2                	ld	s1,40(sp)
    800033a6:	69e2                	ld	s3,24(sp)
    800033a8:	bff9                	j	80003386 <sys_sleep+0x7c>

00000000800033aa <sys_kill>:

uint64
sys_kill(void)
{
    800033aa:	1101                	addi	sp,sp,-32
    800033ac:	ec06                	sd	ra,24(sp)
    800033ae:	e822                	sd	s0,16(sp)
    800033b0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800033b2:	fec40593          	addi	a1,s0,-20
    800033b6:	4501                	li	a0,0
    800033b8:	dddff0ef          	jal	80003194 <argint>
  return kill(pid);
    800033bc:	fec42503          	lw	a0,-20(s0)
    800033c0:	c06ff0ef          	jal	800027c6 <kill>
}
    800033c4:	60e2                	ld	ra,24(sp)
    800033c6:	6442                	ld	s0,16(sp)
    800033c8:	6105                	addi	sp,sp,32
    800033ca:	8082                	ret

00000000800033cc <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800033cc:	1101                	addi	sp,sp,-32
    800033ce:	ec06                	sd	ra,24(sp)
    800033d0:	e822                	sd	s0,16(sp)
    800033d2:	e426                	sd	s1,8(sp)
    800033d4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800033d6:	001ac517          	auipc	a0,0x1ac
    800033da:	92a50513          	addi	a0,a0,-1750 # 801aed00 <tickslock>
    800033de:	87bfd0ef          	jal	80000c58 <acquire>
  xticks = ticks;
    800033e2:	00005497          	auipc	s1,0x5
    800033e6:	68e4a483          	lw	s1,1678(s1) # 80008a70 <ticks>
  release(&tickslock);
    800033ea:	001ac517          	auipc	a0,0x1ac
    800033ee:	91650513          	addi	a0,a0,-1770 # 801aed00 <tickslock>
    800033f2:	8fffd0ef          	jal	80000cf0 <release>
  return xticks;
}
    800033f6:	02049513          	slli	a0,s1,0x20
    800033fa:	9101                	srli	a0,a0,0x20
    800033fc:	60e2                	ld	ra,24(sp)
    800033fe:	6442                	ld	s0,16(sp)
    80003400:	64a2                	ld	s1,8(sp)
    80003402:	6105                	addi	sp,sp,32
    80003404:	8082                	ret

0000000080003406 <sys_cps>:

int
sys_cps(void)
{
    80003406:	715d                	addi	sp,sp,-80
    80003408:	e486                	sd	ra,72(sp)
    8000340a:	e0a2                	sd	s0,64(sp)
    8000340c:	fc26                	sd	s1,56(sp)
    8000340e:	f84a                	sd	s2,48(sp)
    80003410:	f44e                	sd	s3,40(sp)
    80003412:	f052                	sd	s4,32(sp)
    80003414:	ec56                	sd	s5,24(sp)
    80003416:	e85a                	sd	s6,16(sp)
    80003418:	e45e                	sd	s7,8(sp)
    8000341a:	e062                	sd	s8,0(sp)
    8000341c:	0880                	addi	s0,sp,80
    struct proc *p;

    printf("name \t pid \t state \t \n");
    8000341e:	00005517          	auipc	a0,0x5
    80003422:	08250513          	addi	a0,a0,130 # 800084a0 <etext+0x4a0>
    80003426:	900fd0ef          	jal	80000526 <printf>
    for(p = &proc[0]; p < &proc[NPROC]; p++)
    8000342a:	001a1497          	auipc	s1,0x1a1
    8000342e:	21e48493          	addi	s1,s1,542 # 801a4648 <proc+0x160>
    80003432:	001ac997          	auipc	s3,0x1ac
    80003436:	a1698993          	addi	s3,s3,-1514 # 801aee48 <bcache+0x130>
    {
        if(p->state == SLEEPING)
    8000343a:	4909                	li	s2,2
            printf("%s \t %d  \t SLEEPING \t \n ", p->name, p->pid);
        else if(p->state == RUNNING)
    8000343c:	4a11                	li	s4,4
            printf("%s \t %d  \t RUNNING \t \n ", p->name, p->pid);
        else if(p->state == RUNNABLE)
    8000343e:	4a8d                	li	s5,3
            printf("%s \t %d  \t RUNNABLE \t \n ", p->name, p->pid);
    80003440:	00005c17          	auipc	s8,0x5
    80003444:	0b0c0c13          	addi	s8,s8,176 # 800084f0 <etext+0x4f0>
            printf("%s \t %d  \t RUNNING \t \n ", p->name, p->pid);
    80003448:	00005b97          	auipc	s7,0x5
    8000344c:	090b8b93          	addi	s7,s7,144 # 800084d8 <etext+0x4d8>
            printf("%s \t %d  \t SLEEPING \t \n ", p->name, p->pid);
    80003450:	00005b17          	auipc	s6,0x5
    80003454:	068b0b13          	addi	s6,s6,104 # 800084b8 <etext+0x4b8>
    80003458:	a811                	j	8000346c <sys_cps+0x66>
    8000345a:	ed04a603          	lw	a2,-304(s1)
    8000345e:	855a                	mv	a0,s6
    80003460:	8c6fd0ef          	jal	80000526 <printf>
    for(p = &proc[0]; p < &proc[NPROC]; p++)
    80003464:	2a048493          	addi	s1,s1,672
    80003468:	03348763          	beq	s1,s3,80003496 <sys_cps+0x90>
        if(p->state == SLEEPING)
    8000346c:	85a6                	mv	a1,s1
    8000346e:	eb84a783          	lw	a5,-328(s1)
    80003472:	ff2784e3          	beq	a5,s2,8000345a <sys_cps+0x54>
        else if(p->state == RUNNING)
    80003476:	01478a63          	beq	a5,s4,8000348a <sys_cps+0x84>
        else if(p->state == RUNNABLE)
    8000347a:	ff5795e3          	bne	a5,s5,80003464 <sys_cps+0x5e>
            printf("%s \t %d  \t RUNNABLE \t \n ", p->name, p->pid);
    8000347e:	ed04a603          	lw	a2,-304(s1)
    80003482:	8562                	mv	a0,s8
    80003484:	8a2fd0ef          	jal	80000526 <printf>
    80003488:	bff1                	j	80003464 <sys_cps+0x5e>
            printf("%s \t %d  \t RUNNING \t \n ", p->name, p->pid);
    8000348a:	ed04a603          	lw	a2,-304(s1)
    8000348e:	855e                	mv	a0,s7
    80003490:	896fd0ef          	jal	80000526 <printf>
    80003494:	bfc1                	j	80003464 <sys_cps+0x5e>
    }
    return 22;
}
    80003496:	4559                	li	a0,22
    80003498:	60a6                	ld	ra,72(sp)
    8000349a:	6406                	ld	s0,64(sp)
    8000349c:	74e2                	ld	s1,56(sp)
    8000349e:	7942                	ld	s2,48(sp)
    800034a0:	79a2                	ld	s3,40(sp)
    800034a2:	7a02                	ld	s4,32(sp)
    800034a4:	6ae2                	ld	s5,24(sp)
    800034a6:	6b42                	ld	s6,16(sp)
    800034a8:	6ba2                	ld	s7,8(sp)
    800034aa:	6c02                	ld	s8,0(sp)
    800034ac:	6161                	addi	sp,sp,80
    800034ae:	8082                	ret

00000000800034b0 <sys_signal>:

uint64
sys_signal(void) {
    800034b0:	1101                	addi	sp,sp,-32
    800034b2:	ec06                	sd	ra,24(sp)
    800034b4:	e822                	sd	s0,16(sp)
    800034b6:	1000                	addi	s0,sp,32
    int signum;
    uint64 handler;
  
    // Retrieve the signal number and the handler address
    argint(0, &signum);
    800034b8:	fec40593          	addi	a1,s0,-20
    800034bc:	4501                	li	a0,0
    800034be:	cd7ff0ef          	jal	80003194 <argint>
    argaddr(1, &handler);
    800034c2:	fe040593          	addi	a1,s0,-32
    800034c6:	4505                	li	a0,1
    800034c8:	cebff0ef          	jal	800031b2 <argaddr>

    printf("\nIn sys_signal function value of signum : %d\n", signum);
    800034cc:	fec42583          	lw	a1,-20(s0)
    800034d0:	00005517          	auipc	a0,0x5
    800034d4:	04050513          	addi	a0,a0,64 # 80008510 <etext+0x510>
    800034d8:	84efd0ef          	jal	80000526 <printf>
    // Only handle SIGINT for now
    if (signum != SIGINT)
    800034dc:	fec42703          	lw	a4,-20(s0)
    800034e0:	4789                	li	a5,2
        return -1;
    800034e2:	557d                	li	a0,-1
    if (signum != SIGINT)
    800034e4:	00f71c63          	bne	a4,a5,800034fc <sys_signal+0x4c>
    
    if(handler == 0){
    800034e8:	fe043783          	ld	a5,-32(s0)
    800034ec:	cf81                	beqz	a5,80003504 <sys_signal+0x54>
      printf("NULL Handler\n");
    }
    // Set the signal handler for the process
    struct proc *p = myproc();
    800034ee:	b41fe0ef          	jal	8000202e <myproc>
    p->sig_handlers[SIGINT] = (void (*)(int))handler;
    800034f2:	fe043783          	ld	a5,-32(s0)
    800034f6:	18f53423          	sd	a5,392(a0)

    return 0;
    800034fa:	4501                	li	a0,0
}
    800034fc:	60e2                	ld	ra,24(sp)
    800034fe:	6442                	ld	s0,16(sp)
    80003500:	6105                	addi	sp,sp,32
    80003502:	8082                	ret
      printf("NULL Handler\n");
    80003504:	00005517          	auipc	a0,0x5
    80003508:	03c50513          	addi	a0,a0,60 # 80008540 <etext+0x540>
    8000350c:	81afd0ef          	jal	80000526 <printf>
    80003510:	bff9                	j	800034ee <sys_signal+0x3e>

0000000080003512 <sys_thread_create>:
uint64 sys_thread_create(void)
{
    80003512:	7179                	addi	sp,sp,-48
    80003514:	f406                	sd	ra,40(sp)
    80003516:	f022                	sd	s0,32(sp)
    80003518:	1800                	addi	s0,sp,48
    uint64 fn, arg, stack;
    argaddr(0, &fn);
    8000351a:	fe840593          	addi	a1,s0,-24
    8000351e:	4501                	li	a0,0
    80003520:	c93ff0ef          	jal	800031b2 <argaddr>
    argaddr(1, &arg);
    80003524:	fe040593          	addi	a1,s0,-32
    80003528:	4505                	li	a0,1
    8000352a:	c89ff0ef          	jal	800031b2 <argaddr>
    argaddr(2, &stack);
    8000352e:	fd840593          	addi	a1,s0,-40
    80003532:	4509                	li	a0,2
    80003534:	c7fff0ef          	jal	800031b2 <argaddr>

    if(fn == 0 || arg == 0) 
    80003538:	fe843783          	ld	a5,-24(s0)
        return -1;
    8000353c:	557d                	li	a0,-1
    if(fn == 0 || arg == 0) 
    8000353e:	c395                	beqz	a5,80003562 <sys_thread_create+0x50>
    80003540:	fe043783          	ld	a5,-32(s0)
    80003544:	cf99                	beqz	a5,80003562 <sys_thread_create+0x50>
    printf("\n");
    80003546:	00005517          	auipc	a0,0x5
    8000354a:	b6250513          	addi	a0,a0,-1182 # 800080a8 <etext+0xa8>
    8000354e:	fd9fc0ef          	jal	80000526 <printf>
    return thread_create(fn, arg, stack);
    80003552:	fd843603          	ld	a2,-40(s0)
    80003556:	fe043583          	ld	a1,-32(s0)
    8000355a:	fe843503          	ld	a0,-24(s0)
    8000355e:	f26ff0ef          	jal	80002c84 <thread_create>
}
    80003562:	70a2                	ld	ra,40(sp)
    80003564:	7402                	ld	s0,32(sp)
    80003566:	6145                	addi	sp,sp,48
    80003568:	8082                	ret

000000008000356a <sys_thread_exit>:


uint64 sys_thread_exit(void)
{
    8000356a:	1101                	addi	sp,sp,-32
    8000356c:	ec06                	sd	ra,24(sp)
    8000356e:	e822                	sd	s0,16(sp)
    80003570:	1000                	addi	s0,sp,32
    uint64 retval;
    argaddr(0, &retval);  // Get return value from user space
    80003572:	fe840593          	addi	a1,s0,-24
    80003576:	4501                	li	a0,0
    80003578:	c3bff0ef          	jal	800031b2 <argaddr>
    exit((int)retval);    // Cast to int as exit expects an int
    8000357c:	fe842503          	lw	a0,-24(s0)
    80003580:	9a4ff0ef          	jal	80002724 <exit>
    return 0;             // Never reaches here
}
    80003584:	4501                	li	a0,0
    80003586:	60e2                	ld	ra,24(sp)
    80003588:	6442                	ld	s0,16(sp)
    8000358a:	6105                	addi	sp,sp,32
    8000358c:	8082                	ret

000000008000358e <sys_thread_join>:

uint64 sys_thread_join(void)
{
    8000358e:	1101                	addi	sp,sp,-32
    80003590:	ec06                	sd	ra,24(sp)
    80003592:	e822                	sd	s0,16(sp)
    80003594:	1000                	addi	s0,sp,32
    uint64 addr;
    argaddr(0, &addr);  // addr is pointer to where return value should be stored
    80003596:	fe840593          	addi	a1,s0,-24
    8000359a:	4501                	li	a0,0
    8000359c:	c17ff0ef          	jal	800031b2 <argaddr>
    return thread_join((uint64*)addr);
    800035a0:	fe843503          	ld	a0,-24(s0)
    800035a4:	d6eff0ef          	jal	80002b12 <thread_join>
}
    800035a8:	60e2                	ld	ra,24(sp)
    800035aa:	6442                	ld	s0,16(sp)
    800035ac:	6105                	addi	sp,sp,32
    800035ae:	8082                	ret

00000000800035b0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800035b0:	7179                	addi	sp,sp,-48
    800035b2:	f406                	sd	ra,40(sp)
    800035b4:	f022                	sd	s0,32(sp)
    800035b6:	ec26                	sd	s1,24(sp)
    800035b8:	e84a                	sd	s2,16(sp)
    800035ba:	e44e                	sd	s3,8(sp)
    800035bc:	e052                	sd	s4,0(sp)
    800035be:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800035c0:	00005597          	auipc	a1,0x5
    800035c4:	f9058593          	addi	a1,a1,-112 # 80008550 <etext+0x550>
    800035c8:	001ab517          	auipc	a0,0x1ab
    800035cc:	75050513          	addi	a0,a0,1872 # 801aed18 <bcache>
    800035d0:	e08fd0ef          	jal	80000bd8 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800035d4:	001b3797          	auipc	a5,0x1b3
    800035d8:	74478793          	addi	a5,a5,1860 # 801b6d18 <bcache+0x8000>
    800035dc:	001b4717          	auipc	a4,0x1b4
    800035e0:	9a470713          	addi	a4,a4,-1628 # 801b6f80 <bcache+0x8268>
    800035e4:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800035e8:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800035ec:	001ab497          	auipc	s1,0x1ab
    800035f0:	74448493          	addi	s1,s1,1860 # 801aed30 <bcache+0x18>
    b->next = bcache.head.next;
    800035f4:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800035f6:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800035f8:	00005a17          	auipc	s4,0x5
    800035fc:	f60a0a13          	addi	s4,s4,-160 # 80008558 <etext+0x558>
    b->next = bcache.head.next;
    80003600:	2b893783          	ld	a5,696(s2)
    80003604:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80003606:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000360a:	85d2                	mv	a1,s4
    8000360c:	01048513          	addi	a0,s1,16
    80003610:	248010ef          	jal	80004858 <initsleeplock>
    bcache.head.next->prev = b;
    80003614:	2b893783          	ld	a5,696(s2)
    80003618:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000361a:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000361e:	45848493          	addi	s1,s1,1112
    80003622:	fd349fe3          	bne	s1,s3,80003600 <binit+0x50>
  }
}
    80003626:	70a2                	ld	ra,40(sp)
    80003628:	7402                	ld	s0,32(sp)
    8000362a:	64e2                	ld	s1,24(sp)
    8000362c:	6942                	ld	s2,16(sp)
    8000362e:	69a2                	ld	s3,8(sp)
    80003630:	6a02                	ld	s4,0(sp)
    80003632:	6145                	addi	sp,sp,48
    80003634:	8082                	ret

0000000080003636 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80003636:	7179                	addi	sp,sp,-48
    80003638:	f406                	sd	ra,40(sp)
    8000363a:	f022                	sd	s0,32(sp)
    8000363c:	ec26                	sd	s1,24(sp)
    8000363e:	e84a                	sd	s2,16(sp)
    80003640:	e44e                	sd	s3,8(sp)
    80003642:	1800                	addi	s0,sp,48
    80003644:	892a                	mv	s2,a0
    80003646:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80003648:	001ab517          	auipc	a0,0x1ab
    8000364c:	6d050513          	addi	a0,a0,1744 # 801aed18 <bcache>
    80003650:	e08fd0ef          	jal	80000c58 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80003654:	001b4497          	auipc	s1,0x1b4
    80003658:	97c4b483          	ld	s1,-1668(s1) # 801b6fd0 <bcache+0x82b8>
    8000365c:	001b4797          	auipc	a5,0x1b4
    80003660:	92478793          	addi	a5,a5,-1756 # 801b6f80 <bcache+0x8268>
    80003664:	02f48b63          	beq	s1,a5,8000369a <bread+0x64>
    80003668:	873e                	mv	a4,a5
    8000366a:	a021                	j	80003672 <bread+0x3c>
    8000366c:	68a4                	ld	s1,80(s1)
    8000366e:	02e48663          	beq	s1,a4,8000369a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80003672:	449c                	lw	a5,8(s1)
    80003674:	ff279ce3          	bne	a5,s2,8000366c <bread+0x36>
    80003678:	44dc                	lw	a5,12(s1)
    8000367a:	ff3799e3          	bne	a5,s3,8000366c <bread+0x36>
      b->refcnt++;
    8000367e:	40bc                	lw	a5,64(s1)
    80003680:	2785                	addiw	a5,a5,1
    80003682:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80003684:	001ab517          	auipc	a0,0x1ab
    80003688:	69450513          	addi	a0,a0,1684 # 801aed18 <bcache>
    8000368c:	e64fd0ef          	jal	80000cf0 <release>
      acquiresleep(&b->lock);
    80003690:	01048513          	addi	a0,s1,16
    80003694:	1fa010ef          	jal	8000488e <acquiresleep>
      return b;
    80003698:	a889                	j	800036ea <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000369a:	001b4497          	auipc	s1,0x1b4
    8000369e:	92e4b483          	ld	s1,-1746(s1) # 801b6fc8 <bcache+0x82b0>
    800036a2:	001b4797          	auipc	a5,0x1b4
    800036a6:	8de78793          	addi	a5,a5,-1826 # 801b6f80 <bcache+0x8268>
    800036aa:	00f48863          	beq	s1,a5,800036ba <bread+0x84>
    800036ae:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800036b0:	40bc                	lw	a5,64(s1)
    800036b2:	cb91                	beqz	a5,800036c6 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800036b4:	64a4                	ld	s1,72(s1)
    800036b6:	fee49de3          	bne	s1,a4,800036b0 <bread+0x7a>
  panic("bget: no buffers");
    800036ba:	00005517          	auipc	a0,0x5
    800036be:	ea650513          	addi	a0,a0,-346 # 80008560 <etext+0x560>
    800036c2:	936fd0ef          	jal	800007f8 <panic>
      b->dev = dev;
    800036c6:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800036ca:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800036ce:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800036d2:	4785                	li	a5,1
    800036d4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800036d6:	001ab517          	auipc	a0,0x1ab
    800036da:	64250513          	addi	a0,a0,1602 # 801aed18 <bcache>
    800036de:	e12fd0ef          	jal	80000cf0 <release>
      acquiresleep(&b->lock);
    800036e2:	01048513          	addi	a0,s1,16
    800036e6:	1a8010ef          	jal	8000488e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800036ea:	409c                	lw	a5,0(s1)
    800036ec:	cb89                	beqz	a5,800036fe <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800036ee:	8526                	mv	a0,s1
    800036f0:	70a2                	ld	ra,40(sp)
    800036f2:	7402                	ld	s0,32(sp)
    800036f4:	64e2                	ld	s1,24(sp)
    800036f6:	6942                	ld	s2,16(sp)
    800036f8:	69a2                	ld	s3,8(sp)
    800036fa:	6145                	addi	sp,sp,48
    800036fc:	8082                	ret
    virtio_disk_rw(b, 0);
    800036fe:	4581                	li	a1,0
    80003700:	8526                	mv	a0,s1
    80003702:	1ef020ef          	jal	800060f0 <virtio_disk_rw>
    b->valid = 1;
    80003706:	4785                	li	a5,1
    80003708:	c09c                	sw	a5,0(s1)
  return b;
    8000370a:	b7d5                	j	800036ee <bread+0xb8>

000000008000370c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000370c:	1101                	addi	sp,sp,-32
    8000370e:	ec06                	sd	ra,24(sp)
    80003710:	e822                	sd	s0,16(sp)
    80003712:	e426                	sd	s1,8(sp)
    80003714:	1000                	addi	s0,sp,32
    80003716:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80003718:	0541                	addi	a0,a0,16
    8000371a:	1f2010ef          	jal	8000490c <holdingsleep>
    8000371e:	c911                	beqz	a0,80003732 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80003720:	4585                	li	a1,1
    80003722:	8526                	mv	a0,s1
    80003724:	1cd020ef          	jal	800060f0 <virtio_disk_rw>
}
    80003728:	60e2                	ld	ra,24(sp)
    8000372a:	6442                	ld	s0,16(sp)
    8000372c:	64a2                	ld	s1,8(sp)
    8000372e:	6105                	addi	sp,sp,32
    80003730:	8082                	ret
    panic("bwrite");
    80003732:	00005517          	auipc	a0,0x5
    80003736:	e4650513          	addi	a0,a0,-442 # 80008578 <etext+0x578>
    8000373a:	8befd0ef          	jal	800007f8 <panic>

000000008000373e <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    8000373e:	1101                	addi	sp,sp,-32
    80003740:	ec06                	sd	ra,24(sp)
    80003742:	e822                	sd	s0,16(sp)
    80003744:	e426                	sd	s1,8(sp)
    80003746:	e04a                	sd	s2,0(sp)
    80003748:	1000                	addi	s0,sp,32
    8000374a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000374c:	01050913          	addi	s2,a0,16
    80003750:	854a                	mv	a0,s2
    80003752:	1ba010ef          	jal	8000490c <holdingsleep>
    80003756:	c135                	beqz	a0,800037ba <brelse+0x7c>
    panic("brelse");

  releasesleep(&b->lock);
    80003758:	854a                	mv	a0,s2
    8000375a:	17a010ef          	jal	800048d4 <releasesleep>

  acquire(&bcache.lock);
    8000375e:	001ab517          	auipc	a0,0x1ab
    80003762:	5ba50513          	addi	a0,a0,1466 # 801aed18 <bcache>
    80003766:	cf2fd0ef          	jal	80000c58 <acquire>
  b->refcnt--;
    8000376a:	40bc                	lw	a5,64(s1)
    8000376c:	37fd                	addiw	a5,a5,-1
    8000376e:	0007871b          	sext.w	a4,a5
    80003772:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80003774:	e71d                	bnez	a4,800037a2 <brelse+0x64>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80003776:	68b8                	ld	a4,80(s1)
    80003778:	64bc                	ld	a5,72(s1)
    8000377a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000377c:	68b8                	ld	a4,80(s1)
    8000377e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80003780:	001b3797          	auipc	a5,0x1b3
    80003784:	59878793          	addi	a5,a5,1432 # 801b6d18 <bcache+0x8000>
    80003788:	2b87b703          	ld	a4,696(a5)
    8000378c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000378e:	001b3717          	auipc	a4,0x1b3
    80003792:	7f270713          	addi	a4,a4,2034 # 801b6f80 <bcache+0x8268>
    80003796:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80003798:	2b87b703          	ld	a4,696(a5)
    8000379c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000379e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800037a2:	001ab517          	auipc	a0,0x1ab
    800037a6:	57650513          	addi	a0,a0,1398 # 801aed18 <bcache>
    800037aa:	d46fd0ef          	jal	80000cf0 <release>
}
    800037ae:	60e2                	ld	ra,24(sp)
    800037b0:	6442                	ld	s0,16(sp)
    800037b2:	64a2                	ld	s1,8(sp)
    800037b4:	6902                	ld	s2,0(sp)
    800037b6:	6105                	addi	sp,sp,32
    800037b8:	8082                	ret
    panic("brelse");
    800037ba:	00005517          	auipc	a0,0x5
    800037be:	dc650513          	addi	a0,a0,-570 # 80008580 <etext+0x580>
    800037c2:	836fd0ef          	jal	800007f8 <panic>

00000000800037c6 <bpin>:

void
bpin(struct buf *b) {
    800037c6:	1101                	addi	sp,sp,-32
    800037c8:	ec06                	sd	ra,24(sp)
    800037ca:	e822                	sd	s0,16(sp)
    800037cc:	e426                	sd	s1,8(sp)
    800037ce:	1000                	addi	s0,sp,32
    800037d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800037d2:	001ab517          	auipc	a0,0x1ab
    800037d6:	54650513          	addi	a0,a0,1350 # 801aed18 <bcache>
    800037da:	c7efd0ef          	jal	80000c58 <acquire>
  b->refcnt++;
    800037de:	40bc                	lw	a5,64(s1)
    800037e0:	2785                	addiw	a5,a5,1
    800037e2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800037e4:	001ab517          	auipc	a0,0x1ab
    800037e8:	53450513          	addi	a0,a0,1332 # 801aed18 <bcache>
    800037ec:	d04fd0ef          	jal	80000cf0 <release>
}
    800037f0:	60e2                	ld	ra,24(sp)
    800037f2:	6442                	ld	s0,16(sp)
    800037f4:	64a2                	ld	s1,8(sp)
    800037f6:	6105                	addi	sp,sp,32
    800037f8:	8082                	ret

00000000800037fa <bunpin>:

void
bunpin(struct buf *b) {
    800037fa:	1101                	addi	sp,sp,-32
    800037fc:	ec06                	sd	ra,24(sp)
    800037fe:	e822                	sd	s0,16(sp)
    80003800:	e426                	sd	s1,8(sp)
    80003802:	1000                	addi	s0,sp,32
    80003804:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003806:	001ab517          	auipc	a0,0x1ab
    8000380a:	51250513          	addi	a0,a0,1298 # 801aed18 <bcache>
    8000380e:	c4afd0ef          	jal	80000c58 <acquire>
  b->refcnt--;
    80003812:	40bc                	lw	a5,64(s1)
    80003814:	37fd                	addiw	a5,a5,-1
    80003816:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80003818:	001ab517          	auipc	a0,0x1ab
    8000381c:	50050513          	addi	a0,a0,1280 # 801aed18 <bcache>
    80003820:	cd0fd0ef          	jal	80000cf0 <release>
}
    80003824:	60e2                	ld	ra,24(sp)
    80003826:	6442                	ld	s0,16(sp)
    80003828:	64a2                	ld	s1,8(sp)
    8000382a:	6105                	addi	sp,sp,32
    8000382c:	8082                	ret

000000008000382e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000382e:	1101                	addi	sp,sp,-32
    80003830:	ec06                	sd	ra,24(sp)
    80003832:	e822                	sd	s0,16(sp)
    80003834:	e426                	sd	s1,8(sp)
    80003836:	e04a                	sd	s2,0(sp)
    80003838:	1000                	addi	s0,sp,32
    8000383a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000383c:	00d5d59b          	srliw	a1,a1,0xd
    80003840:	001b4797          	auipc	a5,0x1b4
    80003844:	bb47a783          	lw	a5,-1100(a5) # 801b73f4 <sb+0x1c>
    80003848:	9dbd                	addw	a1,a1,a5
    8000384a:	dedff0ef          	jal	80003636 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000384e:	0074f713          	andi	a4,s1,7
    80003852:	4785                	li	a5,1
    80003854:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80003858:	14ce                	slli	s1,s1,0x33
    8000385a:	90d9                	srli	s1,s1,0x36
    8000385c:	00950733          	add	a4,a0,s1
    80003860:	05874703          	lbu	a4,88(a4)
    80003864:	00e7f6b3          	and	a3,a5,a4
    80003868:	c29d                	beqz	a3,8000388e <bfree+0x60>
    8000386a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000386c:	94aa                	add	s1,s1,a0
    8000386e:	fff7c793          	not	a5,a5
    80003872:	8f7d                	and	a4,a4,a5
    80003874:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80003878:	711000ef          	jal	80004788 <log_write>
  brelse(bp);
    8000387c:	854a                	mv	a0,s2
    8000387e:	ec1ff0ef          	jal	8000373e <brelse>
}
    80003882:	60e2                	ld	ra,24(sp)
    80003884:	6442                	ld	s0,16(sp)
    80003886:	64a2                	ld	s1,8(sp)
    80003888:	6902                	ld	s2,0(sp)
    8000388a:	6105                	addi	sp,sp,32
    8000388c:	8082                	ret
    panic("freeing free block");
    8000388e:	00005517          	auipc	a0,0x5
    80003892:	cfa50513          	addi	a0,a0,-774 # 80008588 <etext+0x588>
    80003896:	f63fc0ef          	jal	800007f8 <panic>

000000008000389a <balloc>:
{
    8000389a:	711d                	addi	sp,sp,-96
    8000389c:	ec86                	sd	ra,88(sp)
    8000389e:	e8a2                	sd	s0,80(sp)
    800038a0:	e4a6                	sd	s1,72(sp)
    800038a2:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800038a4:	001b4797          	auipc	a5,0x1b4
    800038a8:	b387a783          	lw	a5,-1224(a5) # 801b73dc <sb+0x4>
    800038ac:	0e078f63          	beqz	a5,800039aa <balloc+0x110>
    800038b0:	e0ca                	sd	s2,64(sp)
    800038b2:	fc4e                	sd	s3,56(sp)
    800038b4:	f852                	sd	s4,48(sp)
    800038b6:	f456                	sd	s5,40(sp)
    800038b8:	f05a                	sd	s6,32(sp)
    800038ba:	ec5e                	sd	s7,24(sp)
    800038bc:	e862                	sd	s8,16(sp)
    800038be:	e466                	sd	s9,8(sp)
    800038c0:	8baa                	mv	s7,a0
    800038c2:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800038c4:	001b4b17          	auipc	s6,0x1b4
    800038c8:	b14b0b13          	addi	s6,s6,-1260 # 801b73d8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038cc:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800038ce:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800038d0:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800038d2:	6c89                	lui	s9,0x2
    800038d4:	a0b5                	j	80003940 <balloc+0xa6>
        bp->data[bi/8] |= m;  // Mark block in use.
    800038d6:	97ca                	add	a5,a5,s2
    800038d8:	8e55                	or	a2,a2,a3
    800038da:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800038de:	854a                	mv	a0,s2
    800038e0:	6a9000ef          	jal	80004788 <log_write>
        brelse(bp);
    800038e4:	854a                	mv	a0,s2
    800038e6:	e59ff0ef          	jal	8000373e <brelse>
  bp = bread(dev, bno);
    800038ea:	85a6                	mv	a1,s1
    800038ec:	855e                	mv	a0,s7
    800038ee:	d49ff0ef          	jal	80003636 <bread>
    800038f2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800038f4:	40000613          	li	a2,1024
    800038f8:	4581                	li	a1,0
    800038fa:	05850513          	addi	a0,a0,88
    800038fe:	c2efd0ef          	jal	80000d2c <memset>
  log_write(bp);
    80003902:	854a                	mv	a0,s2
    80003904:	685000ef          	jal	80004788 <log_write>
  brelse(bp);
    80003908:	854a                	mv	a0,s2
    8000390a:	e35ff0ef          	jal	8000373e <brelse>
}
    8000390e:	6906                	ld	s2,64(sp)
    80003910:	79e2                	ld	s3,56(sp)
    80003912:	7a42                	ld	s4,48(sp)
    80003914:	7aa2                	ld	s5,40(sp)
    80003916:	7b02                	ld	s6,32(sp)
    80003918:	6be2                	ld	s7,24(sp)
    8000391a:	6c42                	ld	s8,16(sp)
    8000391c:	6ca2                	ld	s9,8(sp)
}
    8000391e:	8526                	mv	a0,s1
    80003920:	60e6                	ld	ra,88(sp)
    80003922:	6446                	ld	s0,80(sp)
    80003924:	64a6                	ld	s1,72(sp)
    80003926:	6125                	addi	sp,sp,96
    80003928:	8082                	ret
    brelse(bp);
    8000392a:	854a                	mv	a0,s2
    8000392c:	e13ff0ef          	jal	8000373e <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003930:	015c87bb          	addw	a5,s9,s5
    80003934:	00078a9b          	sext.w	s5,a5
    80003938:	004b2703          	lw	a4,4(s6)
    8000393c:	04eaff63          	bgeu	s5,a4,8000399a <balloc+0x100>
    bp = bread(dev, BBLOCK(b, sb));
    80003940:	41fad79b          	sraiw	a5,s5,0x1f
    80003944:	0137d79b          	srliw	a5,a5,0x13
    80003948:	015787bb          	addw	a5,a5,s5
    8000394c:	40d7d79b          	sraiw	a5,a5,0xd
    80003950:	01cb2583          	lw	a1,28(s6)
    80003954:	9dbd                	addw	a1,a1,a5
    80003956:	855e                	mv	a0,s7
    80003958:	cdfff0ef          	jal	80003636 <bread>
    8000395c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000395e:	004b2503          	lw	a0,4(s6)
    80003962:	000a849b          	sext.w	s1,s5
    80003966:	8762                	mv	a4,s8
    80003968:	fca4f1e3          	bgeu	s1,a0,8000392a <balloc+0x90>
      m = 1 << (bi % 8);
    8000396c:	00777693          	andi	a3,a4,7
    80003970:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80003974:	41f7579b          	sraiw	a5,a4,0x1f
    80003978:	01d7d79b          	srliw	a5,a5,0x1d
    8000397c:	9fb9                	addw	a5,a5,a4
    8000397e:	4037d79b          	sraiw	a5,a5,0x3
    80003982:	00f90633          	add	a2,s2,a5
    80003986:	05864603          	lbu	a2,88(a2)
    8000398a:	00c6f5b3          	and	a1,a3,a2
    8000398e:	d5a1                	beqz	a1,800038d6 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003990:	2705                	addiw	a4,a4,1
    80003992:	2485                	addiw	s1,s1,1
    80003994:	fd471ae3          	bne	a4,s4,80003968 <balloc+0xce>
    80003998:	bf49                	j	8000392a <balloc+0x90>
    8000399a:	6906                	ld	s2,64(sp)
    8000399c:	79e2                	ld	s3,56(sp)
    8000399e:	7a42                	ld	s4,48(sp)
    800039a0:	7aa2                	ld	s5,40(sp)
    800039a2:	7b02                	ld	s6,32(sp)
    800039a4:	6be2                	ld	s7,24(sp)
    800039a6:	6c42                	ld	s8,16(sp)
    800039a8:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800039aa:	00005517          	auipc	a0,0x5
    800039ae:	bf650513          	addi	a0,a0,-1034 # 800085a0 <etext+0x5a0>
    800039b2:	b75fc0ef          	jal	80000526 <printf>
  return 0;
    800039b6:	4481                	li	s1,0
    800039b8:	b79d                	j	8000391e <balloc+0x84>

00000000800039ba <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800039ba:	7179                	addi	sp,sp,-48
    800039bc:	f406                	sd	ra,40(sp)
    800039be:	f022                	sd	s0,32(sp)
    800039c0:	ec26                	sd	s1,24(sp)
    800039c2:	e84a                	sd	s2,16(sp)
    800039c4:	e44e                	sd	s3,8(sp)
    800039c6:	1800                	addi	s0,sp,48
    800039c8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800039ca:	47ad                	li	a5,11
    800039cc:	02b7e663          	bltu	a5,a1,800039f8 <bmap+0x3e>
    if((addr = ip->addrs[bn]) == 0){
    800039d0:	02059793          	slli	a5,a1,0x20
    800039d4:	01e7d593          	srli	a1,a5,0x1e
    800039d8:	00b504b3          	add	s1,a0,a1
    800039dc:	0504a903          	lw	s2,80(s1)
    800039e0:	06091a63          	bnez	s2,80003a54 <bmap+0x9a>
      addr = balloc(ip->dev);
    800039e4:	4108                	lw	a0,0(a0)
    800039e6:	eb5ff0ef          	jal	8000389a <balloc>
    800039ea:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    800039ee:	06090363          	beqz	s2,80003a54 <bmap+0x9a>
        return 0;
      ip->addrs[bn] = addr;
    800039f2:	0524a823          	sw	s2,80(s1)
    800039f6:	a8b9                	j	80003a54 <bmap+0x9a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800039f8:	ff45849b          	addiw	s1,a1,-12
    800039fc:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003a00:	0ff00793          	li	a5,255
    80003a04:	06e7ee63          	bltu	a5,a4,80003a80 <bmap+0xc6>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80003a08:	08052903          	lw	s2,128(a0)
    80003a0c:	00091d63          	bnez	s2,80003a26 <bmap+0x6c>
      addr = balloc(ip->dev);
    80003a10:	4108                	lw	a0,0(a0)
    80003a12:	e89ff0ef          	jal	8000389a <balloc>
    80003a16:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80003a1a:	02090d63          	beqz	s2,80003a54 <bmap+0x9a>
    80003a1e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80003a20:	0929a023          	sw	s2,128(s3)
    80003a24:	a011                	j	80003a28 <bmap+0x6e>
    80003a26:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80003a28:	85ca                	mv	a1,s2
    80003a2a:	0009a503          	lw	a0,0(s3)
    80003a2e:	c09ff0ef          	jal	80003636 <bread>
    80003a32:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80003a34:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80003a38:	02049713          	slli	a4,s1,0x20
    80003a3c:	01e75593          	srli	a1,a4,0x1e
    80003a40:	00b784b3          	add	s1,a5,a1
    80003a44:	0004a903          	lw	s2,0(s1)
    80003a48:	00090e63          	beqz	s2,80003a64 <bmap+0xaa>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80003a4c:	8552                	mv	a0,s4
    80003a4e:	cf1ff0ef          	jal	8000373e <brelse>
    return addr;
    80003a52:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80003a54:	854a                	mv	a0,s2
    80003a56:	70a2                	ld	ra,40(sp)
    80003a58:	7402                	ld	s0,32(sp)
    80003a5a:	64e2                	ld	s1,24(sp)
    80003a5c:	6942                	ld	s2,16(sp)
    80003a5e:	69a2                	ld	s3,8(sp)
    80003a60:	6145                	addi	sp,sp,48
    80003a62:	8082                	ret
      addr = balloc(ip->dev);
    80003a64:	0009a503          	lw	a0,0(s3)
    80003a68:	e33ff0ef          	jal	8000389a <balloc>
    80003a6c:	0005091b          	sext.w	s2,a0
      if(addr){
    80003a70:	fc090ee3          	beqz	s2,80003a4c <bmap+0x92>
        a[bn] = addr;
    80003a74:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80003a78:	8552                	mv	a0,s4
    80003a7a:	50f000ef          	jal	80004788 <log_write>
    80003a7e:	b7f9                	j	80003a4c <bmap+0x92>
    80003a80:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003a82:	00005517          	auipc	a0,0x5
    80003a86:	b3650513          	addi	a0,a0,-1226 # 800085b8 <etext+0x5b8>
    80003a8a:	d6ffc0ef          	jal	800007f8 <panic>

0000000080003a8e <iget>:
{
    80003a8e:	7179                	addi	sp,sp,-48
    80003a90:	f406                	sd	ra,40(sp)
    80003a92:	f022                	sd	s0,32(sp)
    80003a94:	ec26                	sd	s1,24(sp)
    80003a96:	e84a                	sd	s2,16(sp)
    80003a98:	e44e                	sd	s3,8(sp)
    80003a9a:	e052                	sd	s4,0(sp)
    80003a9c:	1800                	addi	s0,sp,48
    80003a9e:	89aa                	mv	s3,a0
    80003aa0:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003aa2:	001b4517          	auipc	a0,0x1b4
    80003aa6:	95650513          	addi	a0,a0,-1706 # 801b73f8 <itable>
    80003aaa:	9aefd0ef          	jal	80000c58 <acquire>
  empty = 0;
    80003aae:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ab0:	001b4497          	auipc	s1,0x1b4
    80003ab4:	96048493          	addi	s1,s1,-1696 # 801b7410 <itable+0x18>
    80003ab8:	001b5697          	auipc	a3,0x1b5
    80003abc:	3e868693          	addi	a3,a3,1000 # 801b8ea0 <log>
    80003ac0:	a039                	j	80003ace <iget+0x40>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003ac2:	02090963          	beqz	s2,80003af4 <iget+0x66>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80003ac6:	08848493          	addi	s1,s1,136
    80003aca:	02d48863          	beq	s1,a3,80003afa <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003ace:	449c                	lw	a5,8(s1)
    80003ad0:	fef059e3          	blez	a5,80003ac2 <iget+0x34>
    80003ad4:	4098                	lw	a4,0(s1)
    80003ad6:	ff3716e3          	bne	a4,s3,80003ac2 <iget+0x34>
    80003ada:	40d8                	lw	a4,4(s1)
    80003adc:	ff4713e3          	bne	a4,s4,80003ac2 <iget+0x34>
      ip->ref++;
    80003ae0:	2785                	addiw	a5,a5,1
    80003ae2:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003ae4:	001b4517          	auipc	a0,0x1b4
    80003ae8:	91450513          	addi	a0,a0,-1772 # 801b73f8 <itable>
    80003aec:	a04fd0ef          	jal	80000cf0 <release>
      return ip;
    80003af0:	8926                	mv	s2,s1
    80003af2:	a02d                	j	80003b1c <iget+0x8e>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003af4:	fbe9                	bnez	a5,80003ac6 <iget+0x38>
      empty = ip;
    80003af6:	8926                	mv	s2,s1
    80003af8:	b7f9                	j	80003ac6 <iget+0x38>
  if(empty == 0)
    80003afa:	02090a63          	beqz	s2,80003b2e <iget+0xa0>
  ip->dev = dev;
    80003afe:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80003b02:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003b06:	4785                	li	a5,1
    80003b08:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003b0c:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003b10:	001b4517          	auipc	a0,0x1b4
    80003b14:	8e850513          	addi	a0,a0,-1816 # 801b73f8 <itable>
    80003b18:	9d8fd0ef          	jal	80000cf0 <release>
}
    80003b1c:	854a                	mv	a0,s2
    80003b1e:	70a2                	ld	ra,40(sp)
    80003b20:	7402                	ld	s0,32(sp)
    80003b22:	64e2                	ld	s1,24(sp)
    80003b24:	6942                	ld	s2,16(sp)
    80003b26:	69a2                	ld	s3,8(sp)
    80003b28:	6a02                	ld	s4,0(sp)
    80003b2a:	6145                	addi	sp,sp,48
    80003b2c:	8082                	ret
    panic("iget: no inodes");
    80003b2e:	00005517          	auipc	a0,0x5
    80003b32:	aa250513          	addi	a0,a0,-1374 # 800085d0 <etext+0x5d0>
    80003b36:	cc3fc0ef          	jal	800007f8 <panic>

0000000080003b3a <fsinit>:
fsinit(int dev) {
    80003b3a:	7179                	addi	sp,sp,-48
    80003b3c:	f406                	sd	ra,40(sp)
    80003b3e:	f022                	sd	s0,32(sp)
    80003b40:	ec26                	sd	s1,24(sp)
    80003b42:	e84a                	sd	s2,16(sp)
    80003b44:	e44e                	sd	s3,8(sp)
    80003b46:	1800                	addi	s0,sp,48
    80003b48:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003b4a:	4585                	li	a1,1
    80003b4c:	aebff0ef          	jal	80003636 <bread>
    80003b50:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003b52:	001b4997          	auipc	s3,0x1b4
    80003b56:	88698993          	addi	s3,s3,-1914 # 801b73d8 <sb>
    80003b5a:	02000613          	li	a2,32
    80003b5e:	05850593          	addi	a1,a0,88
    80003b62:	854e                	mv	a0,s3
    80003b64:	a24fd0ef          	jal	80000d88 <memmove>
  brelse(bp);
    80003b68:	8526                	mv	a0,s1
    80003b6a:	bd5ff0ef          	jal	8000373e <brelse>
  if(sb.magic != FSMAGIC)
    80003b6e:	0009a703          	lw	a4,0(s3)
    80003b72:	102037b7          	lui	a5,0x10203
    80003b76:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003b7a:	02f71063          	bne	a4,a5,80003b9a <fsinit+0x60>
  initlog(dev, &sb);
    80003b7e:	001b4597          	auipc	a1,0x1b4
    80003b82:	85a58593          	addi	a1,a1,-1958 # 801b73d8 <sb>
    80003b86:	854a                	mv	a0,s2
    80003b88:	1f9000ef          	jal	80004580 <initlog>
}
    80003b8c:	70a2                	ld	ra,40(sp)
    80003b8e:	7402                	ld	s0,32(sp)
    80003b90:	64e2                	ld	s1,24(sp)
    80003b92:	6942                	ld	s2,16(sp)
    80003b94:	69a2                	ld	s3,8(sp)
    80003b96:	6145                	addi	sp,sp,48
    80003b98:	8082                	ret
    panic("invalid file system");
    80003b9a:	00005517          	auipc	a0,0x5
    80003b9e:	a4650513          	addi	a0,a0,-1466 # 800085e0 <etext+0x5e0>
    80003ba2:	c57fc0ef          	jal	800007f8 <panic>

0000000080003ba6 <iinit>:
{
    80003ba6:	7179                	addi	sp,sp,-48
    80003ba8:	f406                	sd	ra,40(sp)
    80003baa:	f022                	sd	s0,32(sp)
    80003bac:	ec26                	sd	s1,24(sp)
    80003bae:	e84a                	sd	s2,16(sp)
    80003bb0:	e44e                	sd	s3,8(sp)
    80003bb2:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003bb4:	00005597          	auipc	a1,0x5
    80003bb8:	a4458593          	addi	a1,a1,-1468 # 800085f8 <etext+0x5f8>
    80003bbc:	001b4517          	auipc	a0,0x1b4
    80003bc0:	83c50513          	addi	a0,a0,-1988 # 801b73f8 <itable>
    80003bc4:	814fd0ef          	jal	80000bd8 <initlock>
  for(i = 0; i < NINODE; i++) {
    80003bc8:	001b4497          	auipc	s1,0x1b4
    80003bcc:	85848493          	addi	s1,s1,-1960 # 801b7420 <itable+0x28>
    80003bd0:	001b5997          	auipc	s3,0x1b5
    80003bd4:	2e098993          	addi	s3,s3,736 # 801b8eb0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003bd8:	00005917          	auipc	s2,0x5
    80003bdc:	a2890913          	addi	s2,s2,-1496 # 80008600 <etext+0x600>
    80003be0:	85ca                	mv	a1,s2
    80003be2:	8526                	mv	a0,s1
    80003be4:	475000ef          	jal	80004858 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80003be8:	08848493          	addi	s1,s1,136
    80003bec:	ff349ae3          	bne	s1,s3,80003be0 <iinit+0x3a>
}
    80003bf0:	70a2                	ld	ra,40(sp)
    80003bf2:	7402                	ld	s0,32(sp)
    80003bf4:	64e2                	ld	s1,24(sp)
    80003bf6:	6942                	ld	s2,16(sp)
    80003bf8:	69a2                	ld	s3,8(sp)
    80003bfa:	6145                	addi	sp,sp,48
    80003bfc:	8082                	ret

0000000080003bfe <ialloc>:
{
    80003bfe:	7139                	addi	sp,sp,-64
    80003c00:	fc06                	sd	ra,56(sp)
    80003c02:	f822                	sd	s0,48(sp)
    80003c04:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c06:	001b3717          	auipc	a4,0x1b3
    80003c0a:	7de72703          	lw	a4,2014(a4) # 801b73e4 <sb+0xc>
    80003c0e:	4785                	li	a5,1
    80003c10:	06e7f063          	bgeu	a5,a4,80003c70 <ialloc+0x72>
    80003c14:	f426                	sd	s1,40(sp)
    80003c16:	f04a                	sd	s2,32(sp)
    80003c18:	ec4e                	sd	s3,24(sp)
    80003c1a:	e852                	sd	s4,16(sp)
    80003c1c:	e456                	sd	s5,8(sp)
    80003c1e:	e05a                	sd	s6,0(sp)
    80003c20:	8aaa                	mv	s5,a0
    80003c22:	8b2e                	mv	s6,a1
    80003c24:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003c26:	001b3a17          	auipc	s4,0x1b3
    80003c2a:	7b2a0a13          	addi	s4,s4,1970 # 801b73d8 <sb>
    80003c2e:	00495593          	srli	a1,s2,0x4
    80003c32:	018a2783          	lw	a5,24(s4)
    80003c36:	9dbd                	addw	a1,a1,a5
    80003c38:	8556                	mv	a0,s5
    80003c3a:	9fdff0ef          	jal	80003636 <bread>
    80003c3e:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003c40:	05850993          	addi	s3,a0,88
    80003c44:	00f97793          	andi	a5,s2,15
    80003c48:	079a                	slli	a5,a5,0x6
    80003c4a:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003c4c:	00099783          	lh	a5,0(s3)
    80003c50:	cb9d                	beqz	a5,80003c86 <ialloc+0x88>
    brelse(bp);
    80003c52:	aedff0ef          	jal	8000373e <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003c56:	0905                	addi	s2,s2,1
    80003c58:	00ca2703          	lw	a4,12(s4)
    80003c5c:	0009079b          	sext.w	a5,s2
    80003c60:	fce7e7e3          	bltu	a5,a4,80003c2e <ialloc+0x30>
    80003c64:	74a2                	ld	s1,40(sp)
    80003c66:	7902                	ld	s2,32(sp)
    80003c68:	69e2                	ld	s3,24(sp)
    80003c6a:	6a42                	ld	s4,16(sp)
    80003c6c:	6aa2                	ld	s5,8(sp)
    80003c6e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80003c70:	00005517          	auipc	a0,0x5
    80003c74:	99850513          	addi	a0,a0,-1640 # 80008608 <etext+0x608>
    80003c78:	8affc0ef          	jal	80000526 <printf>
  return 0;
    80003c7c:	4501                	li	a0,0
}
    80003c7e:	70e2                	ld	ra,56(sp)
    80003c80:	7442                	ld	s0,48(sp)
    80003c82:	6121                	addi	sp,sp,64
    80003c84:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003c86:	04000613          	li	a2,64
    80003c8a:	4581                	li	a1,0
    80003c8c:	854e                	mv	a0,s3
    80003c8e:	89efd0ef          	jal	80000d2c <memset>
      dip->type = type;
    80003c92:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003c96:	8526                	mv	a0,s1
    80003c98:	2f1000ef          	jal	80004788 <log_write>
      brelse(bp);
    80003c9c:	8526                	mv	a0,s1
    80003c9e:	aa1ff0ef          	jal	8000373e <brelse>
      return iget(dev, inum);
    80003ca2:	0009059b          	sext.w	a1,s2
    80003ca6:	8556                	mv	a0,s5
    80003ca8:	de7ff0ef          	jal	80003a8e <iget>
    80003cac:	74a2                	ld	s1,40(sp)
    80003cae:	7902                	ld	s2,32(sp)
    80003cb0:	69e2                	ld	s3,24(sp)
    80003cb2:	6a42                	ld	s4,16(sp)
    80003cb4:	6aa2                	ld	s5,8(sp)
    80003cb6:	6b02                	ld	s6,0(sp)
    80003cb8:	b7d9                	j	80003c7e <ialloc+0x80>

0000000080003cba <iupdate>:
{
    80003cba:	1101                	addi	sp,sp,-32
    80003cbc:	ec06                	sd	ra,24(sp)
    80003cbe:	e822                	sd	s0,16(sp)
    80003cc0:	e426                	sd	s1,8(sp)
    80003cc2:	e04a                	sd	s2,0(sp)
    80003cc4:	1000                	addi	s0,sp,32
    80003cc6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003cc8:	415c                	lw	a5,4(a0)
    80003cca:	0047d79b          	srliw	a5,a5,0x4
    80003cce:	001b3597          	auipc	a1,0x1b3
    80003cd2:	7225a583          	lw	a1,1826(a1) # 801b73f0 <sb+0x18>
    80003cd6:	9dbd                	addw	a1,a1,a5
    80003cd8:	4108                	lw	a0,0(a0)
    80003cda:	95dff0ef          	jal	80003636 <bread>
    80003cde:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003ce0:	05850793          	addi	a5,a0,88
    80003ce4:	40d8                	lw	a4,4(s1)
    80003ce6:	8b3d                	andi	a4,a4,15
    80003ce8:	071a                	slli	a4,a4,0x6
    80003cea:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003cec:	04449703          	lh	a4,68(s1)
    80003cf0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003cf4:	04649703          	lh	a4,70(s1)
    80003cf8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003cfc:	04849703          	lh	a4,72(s1)
    80003d00:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003d04:	04a49703          	lh	a4,74(s1)
    80003d08:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003d0c:	44f8                	lw	a4,76(s1)
    80003d0e:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003d10:	03400613          	li	a2,52
    80003d14:	05048593          	addi	a1,s1,80
    80003d18:	00c78513          	addi	a0,a5,12
    80003d1c:	86cfd0ef          	jal	80000d88 <memmove>
  log_write(bp);
    80003d20:	854a                	mv	a0,s2
    80003d22:	267000ef          	jal	80004788 <log_write>
  brelse(bp);
    80003d26:	854a                	mv	a0,s2
    80003d28:	a17ff0ef          	jal	8000373e <brelse>
}
    80003d2c:	60e2                	ld	ra,24(sp)
    80003d2e:	6442                	ld	s0,16(sp)
    80003d30:	64a2                	ld	s1,8(sp)
    80003d32:	6902                	ld	s2,0(sp)
    80003d34:	6105                	addi	sp,sp,32
    80003d36:	8082                	ret

0000000080003d38 <idup>:
{
    80003d38:	1101                	addi	sp,sp,-32
    80003d3a:	ec06                	sd	ra,24(sp)
    80003d3c:	e822                	sd	s0,16(sp)
    80003d3e:	e426                	sd	s1,8(sp)
    80003d40:	1000                	addi	s0,sp,32
    80003d42:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003d44:	001b3517          	auipc	a0,0x1b3
    80003d48:	6b450513          	addi	a0,a0,1716 # 801b73f8 <itable>
    80003d4c:	f0dfc0ef          	jal	80000c58 <acquire>
  ip->ref++;
    80003d50:	449c                	lw	a5,8(s1)
    80003d52:	2785                	addiw	a5,a5,1
    80003d54:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003d56:	001b3517          	auipc	a0,0x1b3
    80003d5a:	6a250513          	addi	a0,a0,1698 # 801b73f8 <itable>
    80003d5e:	f93fc0ef          	jal	80000cf0 <release>
}
    80003d62:	8526                	mv	a0,s1
    80003d64:	60e2                	ld	ra,24(sp)
    80003d66:	6442                	ld	s0,16(sp)
    80003d68:	64a2                	ld	s1,8(sp)
    80003d6a:	6105                	addi	sp,sp,32
    80003d6c:	8082                	ret

0000000080003d6e <ilock>:
{
    80003d6e:	1101                	addi	sp,sp,-32
    80003d70:	ec06                	sd	ra,24(sp)
    80003d72:	e822                	sd	s0,16(sp)
    80003d74:	e426                	sd	s1,8(sp)
    80003d76:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003d78:	cd19                	beqz	a0,80003d96 <ilock+0x28>
    80003d7a:	84aa                	mv	s1,a0
    80003d7c:	451c                	lw	a5,8(a0)
    80003d7e:	00f05c63          	blez	a5,80003d96 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003d82:	0541                	addi	a0,a0,16
    80003d84:	30b000ef          	jal	8000488e <acquiresleep>
  if(ip->valid == 0){
    80003d88:	40bc                	lw	a5,64(s1)
    80003d8a:	cf89                	beqz	a5,80003da4 <ilock+0x36>
}
    80003d8c:	60e2                	ld	ra,24(sp)
    80003d8e:	6442                	ld	s0,16(sp)
    80003d90:	64a2                	ld	s1,8(sp)
    80003d92:	6105                	addi	sp,sp,32
    80003d94:	8082                	ret
    80003d96:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003d98:	00005517          	auipc	a0,0x5
    80003d9c:	88850513          	addi	a0,a0,-1912 # 80008620 <etext+0x620>
    80003da0:	a59fc0ef          	jal	800007f8 <panic>
    80003da4:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003da6:	40dc                	lw	a5,4(s1)
    80003da8:	0047d79b          	srliw	a5,a5,0x4
    80003dac:	001b3597          	auipc	a1,0x1b3
    80003db0:	6445a583          	lw	a1,1604(a1) # 801b73f0 <sb+0x18>
    80003db4:	9dbd                	addw	a1,a1,a5
    80003db6:	4088                	lw	a0,0(s1)
    80003db8:	87fff0ef          	jal	80003636 <bread>
    80003dbc:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80003dbe:	05850593          	addi	a1,a0,88
    80003dc2:	40dc                	lw	a5,4(s1)
    80003dc4:	8bbd                	andi	a5,a5,15
    80003dc6:	079a                	slli	a5,a5,0x6
    80003dc8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80003dca:	00059783          	lh	a5,0(a1)
    80003dce:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003dd2:	00259783          	lh	a5,2(a1)
    80003dd6:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80003dda:	00459783          	lh	a5,4(a1)
    80003dde:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80003de2:	00659783          	lh	a5,6(a1)
    80003de6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003dea:	459c                	lw	a5,8(a1)
    80003dec:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003dee:	03400613          	li	a2,52
    80003df2:	05b1                	addi	a1,a1,12
    80003df4:	05048513          	addi	a0,s1,80
    80003df8:	f91fc0ef          	jal	80000d88 <memmove>
    brelse(bp);
    80003dfc:	854a                	mv	a0,s2
    80003dfe:	941ff0ef          	jal	8000373e <brelse>
    ip->valid = 1;
    80003e02:	4785                	li	a5,1
    80003e04:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80003e06:	04449783          	lh	a5,68(s1)
    80003e0a:	c399                	beqz	a5,80003e10 <ilock+0xa2>
    80003e0c:	6902                	ld	s2,0(sp)
    80003e0e:	bfbd                	j	80003d8c <ilock+0x1e>
      panic("ilock: no type");
    80003e10:	00005517          	auipc	a0,0x5
    80003e14:	81850513          	addi	a0,a0,-2024 # 80008628 <etext+0x628>
    80003e18:	9e1fc0ef          	jal	800007f8 <panic>

0000000080003e1c <iunlock>:
{
    80003e1c:	1101                	addi	sp,sp,-32
    80003e1e:	ec06                	sd	ra,24(sp)
    80003e20:	e822                	sd	s0,16(sp)
    80003e22:	e426                	sd	s1,8(sp)
    80003e24:	e04a                	sd	s2,0(sp)
    80003e26:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003e28:	c505                	beqz	a0,80003e50 <iunlock+0x34>
    80003e2a:	84aa                	mv	s1,a0
    80003e2c:	01050913          	addi	s2,a0,16
    80003e30:	854a                	mv	a0,s2
    80003e32:	2db000ef          	jal	8000490c <holdingsleep>
    80003e36:	cd09                	beqz	a0,80003e50 <iunlock+0x34>
    80003e38:	449c                	lw	a5,8(s1)
    80003e3a:	00f05b63          	blez	a5,80003e50 <iunlock+0x34>
  releasesleep(&ip->lock);
    80003e3e:	854a                	mv	a0,s2
    80003e40:	295000ef          	jal	800048d4 <releasesleep>
}
    80003e44:	60e2                	ld	ra,24(sp)
    80003e46:	6442                	ld	s0,16(sp)
    80003e48:	64a2                	ld	s1,8(sp)
    80003e4a:	6902                	ld	s2,0(sp)
    80003e4c:	6105                	addi	sp,sp,32
    80003e4e:	8082                	ret
    panic("iunlock");
    80003e50:	00004517          	auipc	a0,0x4
    80003e54:	7e850513          	addi	a0,a0,2024 # 80008638 <etext+0x638>
    80003e58:	9a1fc0ef          	jal	800007f8 <panic>

0000000080003e5c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003e5c:	7179                	addi	sp,sp,-48
    80003e5e:	f406                	sd	ra,40(sp)
    80003e60:	f022                	sd	s0,32(sp)
    80003e62:	ec26                	sd	s1,24(sp)
    80003e64:	e84a                	sd	s2,16(sp)
    80003e66:	e44e                	sd	s3,8(sp)
    80003e68:	1800                	addi	s0,sp,48
    80003e6a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003e6c:	05050493          	addi	s1,a0,80
    80003e70:	08050913          	addi	s2,a0,128
    80003e74:	a021                	j	80003e7c <itrunc+0x20>
    80003e76:	0491                	addi	s1,s1,4
    80003e78:	01248b63          	beq	s1,s2,80003e8e <itrunc+0x32>
    if(ip->addrs[i]){
    80003e7c:	408c                	lw	a1,0(s1)
    80003e7e:	dde5                	beqz	a1,80003e76 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003e80:	0009a503          	lw	a0,0(s3)
    80003e84:	9abff0ef          	jal	8000382e <bfree>
      ip->addrs[i] = 0;
    80003e88:	0004a023          	sw	zero,0(s1)
    80003e8c:	b7ed                	j	80003e76 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003e8e:	0809a583          	lw	a1,128(s3)
    80003e92:	ed89                	bnez	a1,80003eac <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003e94:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003e98:	854e                	mv	a0,s3
    80003e9a:	e21ff0ef          	jal	80003cba <iupdate>
}
    80003e9e:	70a2                	ld	ra,40(sp)
    80003ea0:	7402                	ld	s0,32(sp)
    80003ea2:	64e2                	ld	s1,24(sp)
    80003ea4:	6942                	ld	s2,16(sp)
    80003ea6:	69a2                	ld	s3,8(sp)
    80003ea8:	6145                	addi	sp,sp,48
    80003eaa:	8082                	ret
    80003eac:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003eae:	0009a503          	lw	a0,0(s3)
    80003eb2:	f84ff0ef          	jal	80003636 <bread>
    80003eb6:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80003eb8:	05850493          	addi	s1,a0,88
    80003ebc:	45850913          	addi	s2,a0,1112
    80003ec0:	a021                	j	80003ec8 <itrunc+0x6c>
    80003ec2:	0491                	addi	s1,s1,4
    80003ec4:	01248963          	beq	s1,s2,80003ed6 <itrunc+0x7a>
      if(a[j])
    80003ec8:	408c                	lw	a1,0(s1)
    80003eca:	dde5                	beqz	a1,80003ec2 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80003ecc:	0009a503          	lw	a0,0(s3)
    80003ed0:	95fff0ef          	jal	8000382e <bfree>
    80003ed4:	b7fd                	j	80003ec2 <itrunc+0x66>
    brelse(bp);
    80003ed6:	8552                	mv	a0,s4
    80003ed8:	867ff0ef          	jal	8000373e <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003edc:	0809a583          	lw	a1,128(s3)
    80003ee0:	0009a503          	lw	a0,0(s3)
    80003ee4:	94bff0ef          	jal	8000382e <bfree>
    ip->addrs[NDIRECT] = 0;
    80003ee8:	0809a023          	sw	zero,128(s3)
    80003eec:	6a02                	ld	s4,0(sp)
    80003eee:	b75d                	j	80003e94 <itrunc+0x38>

0000000080003ef0 <iput>:
{
    80003ef0:	1101                	addi	sp,sp,-32
    80003ef2:	ec06                	sd	ra,24(sp)
    80003ef4:	e822                	sd	s0,16(sp)
    80003ef6:	e426                	sd	s1,8(sp)
    80003ef8:	1000                	addi	s0,sp,32
    80003efa:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003efc:	001b3517          	auipc	a0,0x1b3
    80003f00:	4fc50513          	addi	a0,a0,1276 # 801b73f8 <itable>
    80003f04:	d55fc0ef          	jal	80000c58 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f08:	4498                	lw	a4,8(s1)
    80003f0a:	4785                	li	a5,1
    80003f0c:	02f70063          	beq	a4,a5,80003f2c <iput+0x3c>
  ip->ref--;
    80003f10:	449c                	lw	a5,8(s1)
    80003f12:	37fd                	addiw	a5,a5,-1
    80003f14:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003f16:	001b3517          	auipc	a0,0x1b3
    80003f1a:	4e250513          	addi	a0,a0,1250 # 801b73f8 <itable>
    80003f1e:	dd3fc0ef          	jal	80000cf0 <release>
}
    80003f22:	60e2                	ld	ra,24(sp)
    80003f24:	6442                	ld	s0,16(sp)
    80003f26:	64a2                	ld	s1,8(sp)
    80003f28:	6105                	addi	sp,sp,32
    80003f2a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80003f2c:	40bc                	lw	a5,64(s1)
    80003f2e:	d3ed                	beqz	a5,80003f10 <iput+0x20>
    80003f30:	04a49783          	lh	a5,74(s1)
    80003f34:	fff1                	bnez	a5,80003f10 <iput+0x20>
    80003f36:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003f38:	01048913          	addi	s2,s1,16
    80003f3c:	854a                	mv	a0,s2
    80003f3e:	151000ef          	jal	8000488e <acquiresleep>
    release(&itable.lock);
    80003f42:	001b3517          	auipc	a0,0x1b3
    80003f46:	4b650513          	addi	a0,a0,1206 # 801b73f8 <itable>
    80003f4a:	da7fc0ef          	jal	80000cf0 <release>
    itrunc(ip);
    80003f4e:	8526                	mv	a0,s1
    80003f50:	f0dff0ef          	jal	80003e5c <itrunc>
    ip->type = 0;
    80003f54:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	d61ff0ef          	jal	80003cba <iupdate>
    ip->valid = 0;
    80003f5e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003f62:	854a                	mv	a0,s2
    80003f64:	171000ef          	jal	800048d4 <releasesleep>
    acquire(&itable.lock);
    80003f68:	001b3517          	auipc	a0,0x1b3
    80003f6c:	49050513          	addi	a0,a0,1168 # 801b73f8 <itable>
    80003f70:	ce9fc0ef          	jal	80000c58 <acquire>
    80003f74:	6902                	ld	s2,0(sp)
    80003f76:	bf69                	j	80003f10 <iput+0x20>

0000000080003f78 <iunlockput>:
{
    80003f78:	1101                	addi	sp,sp,-32
    80003f7a:	ec06                	sd	ra,24(sp)
    80003f7c:	e822                	sd	s0,16(sp)
    80003f7e:	e426                	sd	s1,8(sp)
    80003f80:	1000                	addi	s0,sp,32
    80003f82:	84aa                	mv	s1,a0
  iunlock(ip);
    80003f84:	e99ff0ef          	jal	80003e1c <iunlock>
  iput(ip);
    80003f88:	8526                	mv	a0,s1
    80003f8a:	f67ff0ef          	jal	80003ef0 <iput>
}
    80003f8e:	60e2                	ld	ra,24(sp)
    80003f90:	6442                	ld	s0,16(sp)
    80003f92:	64a2                	ld	s1,8(sp)
    80003f94:	6105                	addi	sp,sp,32
    80003f96:	8082                	ret

0000000080003f98 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003f98:	1141                	addi	sp,sp,-16
    80003f9a:	e422                	sd	s0,8(sp)
    80003f9c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003f9e:	411c                	lw	a5,0(a0)
    80003fa0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003fa2:	415c                	lw	a5,4(a0)
    80003fa4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003fa6:	04451783          	lh	a5,68(a0)
    80003faa:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003fae:	04a51783          	lh	a5,74(a0)
    80003fb2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003fb6:	04c56783          	lwu	a5,76(a0)
    80003fba:	e99c                	sd	a5,16(a1)
}
    80003fbc:	6422                	ld	s0,8(sp)
    80003fbe:	0141                	addi	sp,sp,16
    80003fc0:	8082                	ret

0000000080003fc2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003fc2:	457c                	lw	a5,76(a0)
    80003fc4:	0ed7eb63          	bltu	a5,a3,800040ba <readi+0xf8>
{
    80003fc8:	7159                	addi	sp,sp,-112
    80003fca:	f486                	sd	ra,104(sp)
    80003fcc:	f0a2                	sd	s0,96(sp)
    80003fce:	eca6                	sd	s1,88(sp)
    80003fd0:	e0d2                	sd	s4,64(sp)
    80003fd2:	fc56                	sd	s5,56(sp)
    80003fd4:	f85a                	sd	s6,48(sp)
    80003fd6:	f45e                	sd	s7,40(sp)
    80003fd8:	1880                	addi	s0,sp,112
    80003fda:	8b2a                	mv	s6,a0
    80003fdc:	8bae                	mv	s7,a1
    80003fde:	8a32                	mv	s4,a2
    80003fe0:	84b6                	mv	s1,a3
    80003fe2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003fe4:	9f35                	addw	a4,a4,a3
    return 0;
    80003fe6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003fe8:	0cd76063          	bltu	a4,a3,800040a8 <readi+0xe6>
    80003fec:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003fee:	00e7f463          	bgeu	a5,a4,80003ff6 <readi+0x34>
    n = ip->size - off;
    80003ff2:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003ff6:	080a8f63          	beqz	s5,80004094 <readi+0xd2>
    80003ffa:	e8ca                	sd	s2,80(sp)
    80003ffc:	f062                	sd	s8,32(sp)
    80003ffe:	ec66                	sd	s9,24(sp)
    80004000:	e86a                	sd	s10,16(sp)
    80004002:	e46e                	sd	s11,8(sp)
    80004004:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004006:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000400a:	5c7d                	li	s8,-1
    8000400c:	a80d                	j	8000403e <readi+0x7c>
    8000400e:	020d1d93          	slli	s11,s10,0x20
    80004012:	020ddd93          	srli	s11,s11,0x20
    80004016:	05890613          	addi	a2,s2,88
    8000401a:	86ee                	mv	a3,s11
    8000401c:	963a                	add	a2,a2,a4
    8000401e:	85d2                	mv	a1,s4
    80004020:	855e                	mv	a0,s7
    80004022:	953fe0ef          	jal	80002974 <either_copyout>
    80004026:	05850763          	beq	a0,s8,80004074 <readi+0xb2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000402a:	854a                	mv	a0,s2
    8000402c:	f12ff0ef          	jal	8000373e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004030:	013d09bb          	addw	s3,s10,s3
    80004034:	009d04bb          	addw	s1,s10,s1
    80004038:	9a6e                	add	s4,s4,s11
    8000403a:	0559f763          	bgeu	s3,s5,80004088 <readi+0xc6>
    uint addr = bmap(ip, off/BSIZE);
    8000403e:	00a4d59b          	srliw	a1,s1,0xa
    80004042:	855a                	mv	a0,s6
    80004044:	977ff0ef          	jal	800039ba <bmap>
    80004048:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000404c:	c5b1                	beqz	a1,80004098 <readi+0xd6>
    bp = bread(ip->dev, addr);
    8000404e:	000b2503          	lw	a0,0(s6)
    80004052:	de4ff0ef          	jal	80003636 <bread>
    80004056:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80004058:	3ff4f713          	andi	a4,s1,1023
    8000405c:	40ec87bb          	subw	a5,s9,a4
    80004060:	413a86bb          	subw	a3,s5,s3
    80004064:	8d3e                	mv	s10,a5
    80004066:	2781                	sext.w	a5,a5
    80004068:	0006861b          	sext.w	a2,a3
    8000406c:	faf671e3          	bgeu	a2,a5,8000400e <readi+0x4c>
    80004070:	8d36                	mv	s10,a3
    80004072:	bf71                	j	8000400e <readi+0x4c>
      brelse(bp);
    80004074:	854a                	mv	a0,s2
    80004076:	ec8ff0ef          	jal	8000373e <brelse>
      tot = -1;
    8000407a:	59fd                	li	s3,-1
      break;
    8000407c:	6946                	ld	s2,80(sp)
    8000407e:	7c02                	ld	s8,32(sp)
    80004080:	6ce2                	ld	s9,24(sp)
    80004082:	6d42                	ld	s10,16(sp)
    80004084:	6da2                	ld	s11,8(sp)
    80004086:	a831                	j	800040a2 <readi+0xe0>
    80004088:	6946                	ld	s2,80(sp)
    8000408a:	7c02                	ld	s8,32(sp)
    8000408c:	6ce2                	ld	s9,24(sp)
    8000408e:	6d42                	ld	s10,16(sp)
    80004090:	6da2                	ld	s11,8(sp)
    80004092:	a801                	j	800040a2 <readi+0xe0>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80004094:	89d6                	mv	s3,s5
    80004096:	a031                	j	800040a2 <readi+0xe0>
    80004098:	6946                	ld	s2,80(sp)
    8000409a:	7c02                	ld	s8,32(sp)
    8000409c:	6ce2                	ld	s9,24(sp)
    8000409e:	6d42                	ld	s10,16(sp)
    800040a0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800040a2:	0009851b          	sext.w	a0,s3
    800040a6:	69a6                	ld	s3,72(sp)
}
    800040a8:	70a6                	ld	ra,104(sp)
    800040aa:	7406                	ld	s0,96(sp)
    800040ac:	64e6                	ld	s1,88(sp)
    800040ae:	6a06                	ld	s4,64(sp)
    800040b0:	7ae2                	ld	s5,56(sp)
    800040b2:	7b42                	ld	s6,48(sp)
    800040b4:	7ba2                	ld	s7,40(sp)
    800040b6:	6165                	addi	sp,sp,112
    800040b8:	8082                	ret
    return 0;
    800040ba:	4501                	li	a0,0
}
    800040bc:	8082                	ret

00000000800040be <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800040be:	457c                	lw	a5,76(a0)
    800040c0:	10d7e063          	bltu	a5,a3,800041c0 <writei+0x102>
{
    800040c4:	7159                	addi	sp,sp,-112
    800040c6:	f486                	sd	ra,104(sp)
    800040c8:	f0a2                	sd	s0,96(sp)
    800040ca:	e8ca                	sd	s2,80(sp)
    800040cc:	e0d2                	sd	s4,64(sp)
    800040ce:	fc56                	sd	s5,56(sp)
    800040d0:	f85a                	sd	s6,48(sp)
    800040d2:	f45e                	sd	s7,40(sp)
    800040d4:	1880                	addi	s0,sp,112
    800040d6:	8aaa                	mv	s5,a0
    800040d8:	8bae                	mv	s7,a1
    800040da:	8a32                	mv	s4,a2
    800040dc:	8936                	mv	s2,a3
    800040de:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    800040e0:	00e687bb          	addw	a5,a3,a4
    800040e4:	0ed7e063          	bltu	a5,a3,800041c4 <writei+0x106>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    800040e8:	00043737          	lui	a4,0x43
    800040ec:	0cf76e63          	bltu	a4,a5,800041c8 <writei+0x10a>
    800040f0:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800040f2:	0a0b0f63          	beqz	s6,800041b0 <writei+0xf2>
    800040f6:	eca6                	sd	s1,88(sp)
    800040f8:	f062                	sd	s8,32(sp)
    800040fa:	ec66                	sd	s9,24(sp)
    800040fc:	e86a                	sd	s10,16(sp)
    800040fe:	e46e                	sd	s11,8(sp)
    80004100:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80004102:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80004106:	5c7d                	li	s8,-1
    80004108:	a825                	j	80004140 <writei+0x82>
    8000410a:	020d1d93          	slli	s11,s10,0x20
    8000410e:	020ddd93          	srli	s11,s11,0x20
    80004112:	05848513          	addi	a0,s1,88
    80004116:	86ee                	mv	a3,s11
    80004118:	8652                	mv	a2,s4
    8000411a:	85de                	mv	a1,s7
    8000411c:	953a                	add	a0,a0,a4
    8000411e:	8a1fe0ef          	jal	800029be <either_copyin>
    80004122:	05850a63          	beq	a0,s8,80004176 <writei+0xb8>
      brelse(bp);
      break;
    }
    log_write(bp);
    80004126:	8526                	mv	a0,s1
    80004128:	660000ef          	jal	80004788 <log_write>
    brelse(bp);
    8000412c:	8526                	mv	a0,s1
    8000412e:	e10ff0ef          	jal	8000373e <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80004132:	013d09bb          	addw	s3,s10,s3
    80004136:	012d093b          	addw	s2,s10,s2
    8000413a:	9a6e                	add	s4,s4,s11
    8000413c:	0569f063          	bgeu	s3,s6,8000417c <writei+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80004140:	00a9559b          	srliw	a1,s2,0xa
    80004144:	8556                	mv	a0,s5
    80004146:	875ff0ef          	jal	800039ba <bmap>
    8000414a:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    8000414e:	c59d                	beqz	a1,8000417c <writei+0xbe>
    bp = bread(ip->dev, addr);
    80004150:	000aa503          	lw	a0,0(s5)
    80004154:	ce2ff0ef          	jal	80003636 <bread>
    80004158:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    8000415a:	3ff97713          	andi	a4,s2,1023
    8000415e:	40ec87bb          	subw	a5,s9,a4
    80004162:	413b06bb          	subw	a3,s6,s3
    80004166:	8d3e                	mv	s10,a5
    80004168:	2781                	sext.w	a5,a5
    8000416a:	0006861b          	sext.w	a2,a3
    8000416e:	f8f67ee3          	bgeu	a2,a5,8000410a <writei+0x4c>
    80004172:	8d36                	mv	s10,a3
    80004174:	bf59                	j	8000410a <writei+0x4c>
      brelse(bp);
    80004176:	8526                	mv	a0,s1
    80004178:	dc6ff0ef          	jal	8000373e <brelse>
  }

  if(off > ip->size)
    8000417c:	04caa783          	lw	a5,76(s5)
    80004180:	0327fa63          	bgeu	a5,s2,800041b4 <writei+0xf6>
    ip->size = off;
    80004184:	052aa623          	sw	s2,76(s5)
    80004188:	64e6                	ld	s1,88(sp)
    8000418a:	7c02                	ld	s8,32(sp)
    8000418c:	6ce2                	ld	s9,24(sp)
    8000418e:	6d42                	ld	s10,16(sp)
    80004190:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80004192:	8556                	mv	a0,s5
    80004194:	b27ff0ef          	jal	80003cba <iupdate>

  return tot;
    80004198:	0009851b          	sext.w	a0,s3
    8000419c:	69a6                	ld	s3,72(sp)
}
    8000419e:	70a6                	ld	ra,104(sp)
    800041a0:	7406                	ld	s0,96(sp)
    800041a2:	6946                	ld	s2,80(sp)
    800041a4:	6a06                	ld	s4,64(sp)
    800041a6:	7ae2                	ld	s5,56(sp)
    800041a8:	7b42                	ld	s6,48(sp)
    800041aa:	7ba2                	ld	s7,40(sp)
    800041ac:	6165                	addi	sp,sp,112
    800041ae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800041b0:	89da                	mv	s3,s6
    800041b2:	b7c5                	j	80004192 <writei+0xd4>
    800041b4:	64e6                	ld	s1,88(sp)
    800041b6:	7c02                	ld	s8,32(sp)
    800041b8:	6ce2                	ld	s9,24(sp)
    800041ba:	6d42                	ld	s10,16(sp)
    800041bc:	6da2                	ld	s11,8(sp)
    800041be:	bfd1                	j	80004192 <writei+0xd4>
    return -1;
    800041c0:	557d                	li	a0,-1
}
    800041c2:	8082                	ret
    return -1;
    800041c4:	557d                	li	a0,-1
    800041c6:	bfe1                	j	8000419e <writei+0xe0>
    return -1;
    800041c8:	557d                	li	a0,-1
    800041ca:	bfd1                	j	8000419e <writei+0xe0>

00000000800041cc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800041cc:	1141                	addi	sp,sp,-16
    800041ce:	e406                	sd	ra,8(sp)
    800041d0:	e022                	sd	s0,0(sp)
    800041d2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800041d4:	4639                	li	a2,14
    800041d6:	c23fc0ef          	jal	80000df8 <strncmp>
}
    800041da:	60a2                	ld	ra,8(sp)
    800041dc:	6402                	ld	s0,0(sp)
    800041de:	0141                	addi	sp,sp,16
    800041e0:	8082                	ret

00000000800041e2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800041e2:	7139                	addi	sp,sp,-64
    800041e4:	fc06                	sd	ra,56(sp)
    800041e6:	f822                	sd	s0,48(sp)
    800041e8:	f426                	sd	s1,40(sp)
    800041ea:	f04a                	sd	s2,32(sp)
    800041ec:	ec4e                	sd	s3,24(sp)
    800041ee:	e852                	sd	s4,16(sp)
    800041f0:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    800041f2:	04451703          	lh	a4,68(a0)
    800041f6:	4785                	li	a5,1
    800041f8:	00f71a63          	bne	a4,a5,8000420c <dirlookup+0x2a>
    800041fc:	892a                	mv	s2,a0
    800041fe:	89ae                	mv	s3,a1
    80004200:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80004202:	457c                	lw	a5,76(a0)
    80004204:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80004206:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004208:	e39d                	bnez	a5,8000422e <dirlookup+0x4c>
    8000420a:	a095                	j	8000426e <dirlookup+0x8c>
    panic("dirlookup not DIR");
    8000420c:	00004517          	auipc	a0,0x4
    80004210:	43450513          	addi	a0,a0,1076 # 80008640 <etext+0x640>
    80004214:	de4fc0ef          	jal	800007f8 <panic>
      panic("dirlookup read");
    80004218:	00004517          	auipc	a0,0x4
    8000421c:	44050513          	addi	a0,a0,1088 # 80008658 <etext+0x658>
    80004220:	dd8fc0ef          	jal	800007f8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80004224:	24c1                	addiw	s1,s1,16
    80004226:	04c92783          	lw	a5,76(s2)
    8000422a:	04f4f163          	bgeu	s1,a5,8000426c <dirlookup+0x8a>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000422e:	4741                	li	a4,16
    80004230:	86a6                	mv	a3,s1
    80004232:	fc040613          	addi	a2,s0,-64
    80004236:	4581                	li	a1,0
    80004238:	854a                	mv	a0,s2
    8000423a:	d89ff0ef          	jal	80003fc2 <readi>
    8000423e:	47c1                	li	a5,16
    80004240:	fcf51ce3          	bne	a0,a5,80004218 <dirlookup+0x36>
    if(de.inum == 0)
    80004244:	fc045783          	lhu	a5,-64(s0)
    80004248:	dff1                	beqz	a5,80004224 <dirlookup+0x42>
    if(namecmp(name, de.name) == 0){
    8000424a:	fc240593          	addi	a1,s0,-62
    8000424e:	854e                	mv	a0,s3
    80004250:	f7dff0ef          	jal	800041cc <namecmp>
    80004254:	f961                	bnez	a0,80004224 <dirlookup+0x42>
      if(poff)
    80004256:	000a0463          	beqz	s4,8000425e <dirlookup+0x7c>
        *poff = off;
    8000425a:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000425e:	fc045583          	lhu	a1,-64(s0)
    80004262:	00092503          	lw	a0,0(s2)
    80004266:	829ff0ef          	jal	80003a8e <iget>
    8000426a:	a011                	j	8000426e <dirlookup+0x8c>
  return 0;
    8000426c:	4501                	li	a0,0
}
    8000426e:	70e2                	ld	ra,56(sp)
    80004270:	7442                	ld	s0,48(sp)
    80004272:	74a2                	ld	s1,40(sp)
    80004274:	7902                	ld	s2,32(sp)
    80004276:	69e2                	ld	s3,24(sp)
    80004278:	6a42                	ld	s4,16(sp)
    8000427a:	6121                	addi	sp,sp,64
    8000427c:	8082                	ret

000000008000427e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    8000427e:	711d                	addi	sp,sp,-96
    80004280:	ec86                	sd	ra,88(sp)
    80004282:	e8a2                	sd	s0,80(sp)
    80004284:	e4a6                	sd	s1,72(sp)
    80004286:	e0ca                	sd	s2,64(sp)
    80004288:	fc4e                	sd	s3,56(sp)
    8000428a:	f852                	sd	s4,48(sp)
    8000428c:	f456                	sd	s5,40(sp)
    8000428e:	f05a                	sd	s6,32(sp)
    80004290:	ec5e                	sd	s7,24(sp)
    80004292:	e862                	sd	s8,16(sp)
    80004294:	e466                	sd	s9,8(sp)
    80004296:	1080                	addi	s0,sp,96
    80004298:	84aa                	mv	s1,a0
    8000429a:	8b2e                	mv	s6,a1
    8000429c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000429e:	00054703          	lbu	a4,0(a0)
    800042a2:	02f00793          	li	a5,47
    800042a6:	00f70e63          	beq	a4,a5,800042c2 <namex+0x44>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800042aa:	d85fd0ef          	jal	8000202e <myproc>
    800042ae:	15853503          	ld	a0,344(a0)
    800042b2:	a87ff0ef          	jal	80003d38 <idup>
    800042b6:	8a2a                	mv	s4,a0
  while(*path == '/')
    800042b8:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    800042bc:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800042be:	4b85                	li	s7,1
    800042c0:	a871                	j	8000435c <namex+0xde>
    ip = iget(ROOTDEV, ROOTINO);
    800042c2:	4585                	li	a1,1
    800042c4:	4505                	li	a0,1
    800042c6:	fc8ff0ef          	jal	80003a8e <iget>
    800042ca:	8a2a                	mv	s4,a0
    800042cc:	b7f5                	j	800042b8 <namex+0x3a>
      iunlockput(ip);
    800042ce:	8552                	mv	a0,s4
    800042d0:	ca9ff0ef          	jal	80003f78 <iunlockput>
      return 0;
    800042d4:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800042d6:	8552                	mv	a0,s4
    800042d8:	60e6                	ld	ra,88(sp)
    800042da:	6446                	ld	s0,80(sp)
    800042dc:	64a6                	ld	s1,72(sp)
    800042de:	6906                	ld	s2,64(sp)
    800042e0:	79e2                	ld	s3,56(sp)
    800042e2:	7a42                	ld	s4,48(sp)
    800042e4:	7aa2                	ld	s5,40(sp)
    800042e6:	7b02                	ld	s6,32(sp)
    800042e8:	6be2                	ld	s7,24(sp)
    800042ea:	6c42                	ld	s8,16(sp)
    800042ec:	6ca2                	ld	s9,8(sp)
    800042ee:	6125                	addi	sp,sp,96
    800042f0:	8082                	ret
      iunlock(ip);
    800042f2:	8552                	mv	a0,s4
    800042f4:	b29ff0ef          	jal	80003e1c <iunlock>
      return ip;
    800042f8:	bff9                	j	800042d6 <namex+0x58>
      iunlockput(ip);
    800042fa:	8552                	mv	a0,s4
    800042fc:	c7dff0ef          	jal	80003f78 <iunlockput>
      return 0;
    80004300:	8a4e                	mv	s4,s3
    80004302:	bfd1                	j	800042d6 <namex+0x58>
  len = path - s;
    80004304:	40998633          	sub	a2,s3,s1
    80004308:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000430c:	099c5063          	bge	s8,s9,8000438c <namex+0x10e>
    memmove(name, s, DIRSIZ);
    80004310:	4639                	li	a2,14
    80004312:	85a6                	mv	a1,s1
    80004314:	8556                	mv	a0,s5
    80004316:	a73fc0ef          	jal	80000d88 <memmove>
    8000431a:	84ce                	mv	s1,s3
  while(*path == '/')
    8000431c:	0004c783          	lbu	a5,0(s1)
    80004320:	01279763          	bne	a5,s2,8000432e <namex+0xb0>
    path++;
    80004324:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004326:	0004c783          	lbu	a5,0(s1)
    8000432a:	ff278de3          	beq	a5,s2,80004324 <namex+0xa6>
    ilock(ip);
    8000432e:	8552                	mv	a0,s4
    80004330:	a3fff0ef          	jal	80003d6e <ilock>
    if(ip->type != T_DIR){
    80004334:	044a1783          	lh	a5,68(s4)
    80004338:	f9779be3          	bne	a5,s7,800042ce <namex+0x50>
    if(nameiparent && *path == '\0'){
    8000433c:	000b0563          	beqz	s6,80004346 <namex+0xc8>
    80004340:	0004c783          	lbu	a5,0(s1)
    80004344:	d7dd                	beqz	a5,800042f2 <namex+0x74>
    if((next = dirlookup(ip, name, 0)) == 0){
    80004346:	4601                	li	a2,0
    80004348:	85d6                	mv	a1,s5
    8000434a:	8552                	mv	a0,s4
    8000434c:	e97ff0ef          	jal	800041e2 <dirlookup>
    80004350:	89aa                	mv	s3,a0
    80004352:	d545                	beqz	a0,800042fa <namex+0x7c>
    iunlockput(ip);
    80004354:	8552                	mv	a0,s4
    80004356:	c23ff0ef          	jal	80003f78 <iunlockput>
    ip = next;
    8000435a:	8a4e                	mv	s4,s3
  while(*path == '/')
    8000435c:	0004c783          	lbu	a5,0(s1)
    80004360:	01279763          	bne	a5,s2,8000436e <namex+0xf0>
    path++;
    80004364:	0485                	addi	s1,s1,1
  while(*path == '/')
    80004366:	0004c783          	lbu	a5,0(s1)
    8000436a:	ff278de3          	beq	a5,s2,80004364 <namex+0xe6>
  if(*path == 0)
    8000436e:	cb8d                	beqz	a5,800043a0 <namex+0x122>
  while(*path != '/' && *path != 0)
    80004370:	0004c783          	lbu	a5,0(s1)
    80004374:	89a6                	mv	s3,s1
  len = path - s;
    80004376:	4c81                	li	s9,0
    80004378:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    8000437a:	01278963          	beq	a5,s2,8000438c <namex+0x10e>
    8000437e:	d3d9                	beqz	a5,80004304 <namex+0x86>
    path++;
    80004380:	0985                	addi	s3,s3,1
  while(*path != '/' && *path != 0)
    80004382:	0009c783          	lbu	a5,0(s3)
    80004386:	ff279ce3          	bne	a5,s2,8000437e <namex+0x100>
    8000438a:	bfad                	j	80004304 <namex+0x86>
    memmove(name, s, len);
    8000438c:	2601                	sext.w	a2,a2
    8000438e:	85a6                	mv	a1,s1
    80004390:	8556                	mv	a0,s5
    80004392:	9f7fc0ef          	jal	80000d88 <memmove>
    name[len] = 0;
    80004396:	9cd6                	add	s9,s9,s5
    80004398:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    8000439c:	84ce                	mv	s1,s3
    8000439e:	bfbd                	j	8000431c <namex+0x9e>
  if(nameiparent){
    800043a0:	f20b0be3          	beqz	s6,800042d6 <namex+0x58>
    iput(ip);
    800043a4:	8552                	mv	a0,s4
    800043a6:	b4bff0ef          	jal	80003ef0 <iput>
    return 0;
    800043aa:	4a01                	li	s4,0
    800043ac:	b72d                	j	800042d6 <namex+0x58>

00000000800043ae <dirlink>:
{
    800043ae:	7139                	addi	sp,sp,-64
    800043b0:	fc06                	sd	ra,56(sp)
    800043b2:	f822                	sd	s0,48(sp)
    800043b4:	f04a                	sd	s2,32(sp)
    800043b6:	ec4e                	sd	s3,24(sp)
    800043b8:	e852                	sd	s4,16(sp)
    800043ba:	0080                	addi	s0,sp,64
    800043bc:	892a                	mv	s2,a0
    800043be:	8a2e                	mv	s4,a1
    800043c0:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800043c2:	4601                	li	a2,0
    800043c4:	e1fff0ef          	jal	800041e2 <dirlookup>
    800043c8:	e535                	bnez	a0,80004434 <dirlink+0x86>
    800043ca:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043cc:	04c92483          	lw	s1,76(s2)
    800043d0:	c48d                	beqz	s1,800043fa <dirlink+0x4c>
    800043d2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043d4:	4741                	li	a4,16
    800043d6:	86a6                	mv	a3,s1
    800043d8:	fc040613          	addi	a2,s0,-64
    800043dc:	4581                	li	a1,0
    800043de:	854a                	mv	a0,s2
    800043e0:	be3ff0ef          	jal	80003fc2 <readi>
    800043e4:	47c1                	li	a5,16
    800043e6:	04f51b63          	bne	a0,a5,8000443c <dirlink+0x8e>
    if(de.inum == 0)
    800043ea:	fc045783          	lhu	a5,-64(s0)
    800043ee:	c791                	beqz	a5,800043fa <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800043f0:	24c1                	addiw	s1,s1,16
    800043f2:	04c92783          	lw	a5,76(s2)
    800043f6:	fcf4efe3          	bltu	s1,a5,800043d4 <dirlink+0x26>
  strncpy(de.name, name, DIRSIZ);
    800043fa:	4639                	li	a2,14
    800043fc:	85d2                	mv	a1,s4
    800043fe:	fc240513          	addi	a0,s0,-62
    80004402:	a2dfc0ef          	jal	80000e2e <strncpy>
  de.inum = inum;
    80004406:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000440a:	4741                	li	a4,16
    8000440c:	86a6                	mv	a3,s1
    8000440e:	fc040613          	addi	a2,s0,-64
    80004412:	4581                	li	a1,0
    80004414:	854a                	mv	a0,s2
    80004416:	ca9ff0ef          	jal	800040be <writei>
    8000441a:	1541                	addi	a0,a0,-16
    8000441c:	00a03533          	snez	a0,a0
    80004420:	40a00533          	neg	a0,a0
    80004424:	74a2                	ld	s1,40(sp)
}
    80004426:	70e2                	ld	ra,56(sp)
    80004428:	7442                	ld	s0,48(sp)
    8000442a:	7902                	ld	s2,32(sp)
    8000442c:	69e2                	ld	s3,24(sp)
    8000442e:	6a42                	ld	s4,16(sp)
    80004430:	6121                	addi	sp,sp,64
    80004432:	8082                	ret
    iput(ip);
    80004434:	abdff0ef          	jal	80003ef0 <iput>
    return -1;
    80004438:	557d                	li	a0,-1
    8000443a:	b7f5                	j	80004426 <dirlink+0x78>
      panic("dirlink read");
    8000443c:	00004517          	auipc	a0,0x4
    80004440:	22c50513          	addi	a0,a0,556 # 80008668 <etext+0x668>
    80004444:	bb4fc0ef          	jal	800007f8 <panic>

0000000080004448 <namei>:

struct inode*
namei(char *path)
{
    80004448:	1101                	addi	sp,sp,-32
    8000444a:	ec06                	sd	ra,24(sp)
    8000444c:	e822                	sd	s0,16(sp)
    8000444e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004450:	fe040613          	addi	a2,s0,-32
    80004454:	4581                	li	a1,0
    80004456:	e29ff0ef          	jal	8000427e <namex>
}
    8000445a:	60e2                	ld	ra,24(sp)
    8000445c:	6442                	ld	s0,16(sp)
    8000445e:	6105                	addi	sp,sp,32
    80004460:	8082                	ret

0000000080004462 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80004462:	1141                	addi	sp,sp,-16
    80004464:	e406                	sd	ra,8(sp)
    80004466:	e022                	sd	s0,0(sp)
    80004468:	0800                	addi	s0,sp,16
    8000446a:	862e                	mv	a2,a1
  return namex(path, 1, name);
    8000446c:	4585                	li	a1,1
    8000446e:	e11ff0ef          	jal	8000427e <namex>
}
    80004472:	60a2                	ld	ra,8(sp)
    80004474:	6402                	ld	s0,0(sp)
    80004476:	0141                	addi	sp,sp,16
    80004478:	8082                	ret

000000008000447a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000447a:	1101                	addi	sp,sp,-32
    8000447c:	ec06                	sd	ra,24(sp)
    8000447e:	e822                	sd	s0,16(sp)
    80004480:	e426                	sd	s1,8(sp)
    80004482:	e04a                	sd	s2,0(sp)
    80004484:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80004486:	001b5917          	auipc	s2,0x1b5
    8000448a:	a1a90913          	addi	s2,s2,-1510 # 801b8ea0 <log>
    8000448e:	01892583          	lw	a1,24(s2)
    80004492:	02892503          	lw	a0,40(s2)
    80004496:	9a0ff0ef          	jal	80003636 <bread>
    8000449a:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    8000449c:	02c92603          	lw	a2,44(s2)
    800044a0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800044a2:	00c05f63          	blez	a2,800044c0 <write_head+0x46>
    800044a6:	001b5717          	auipc	a4,0x1b5
    800044aa:	a2a70713          	addi	a4,a4,-1494 # 801b8ed0 <log+0x30>
    800044ae:	87aa                	mv	a5,a0
    800044b0:	060a                	slli	a2,a2,0x2
    800044b2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800044b4:	4314                	lw	a3,0(a4)
    800044b6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800044b8:	0711                	addi	a4,a4,4
    800044ba:	0791                	addi	a5,a5,4
    800044bc:	fec79ce3          	bne	a5,a2,800044b4 <write_head+0x3a>
  }
  bwrite(buf);
    800044c0:	8526                	mv	a0,s1
    800044c2:	a4aff0ef          	jal	8000370c <bwrite>
  brelse(buf);
    800044c6:	8526                	mv	a0,s1
    800044c8:	a76ff0ef          	jal	8000373e <brelse>
}
    800044cc:	60e2                	ld	ra,24(sp)
    800044ce:	6442                	ld	s0,16(sp)
    800044d0:	64a2                	ld	s1,8(sp)
    800044d2:	6902                	ld	s2,0(sp)
    800044d4:	6105                	addi	sp,sp,32
    800044d6:	8082                	ret

00000000800044d8 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800044d8:	001b5797          	auipc	a5,0x1b5
    800044dc:	9f47a783          	lw	a5,-1548(a5) # 801b8ecc <log+0x2c>
    800044e0:	08f05f63          	blez	a5,8000457e <install_trans+0xa6>
{
    800044e4:	7139                	addi	sp,sp,-64
    800044e6:	fc06                	sd	ra,56(sp)
    800044e8:	f822                	sd	s0,48(sp)
    800044ea:	f426                	sd	s1,40(sp)
    800044ec:	f04a                	sd	s2,32(sp)
    800044ee:	ec4e                	sd	s3,24(sp)
    800044f0:	e852                	sd	s4,16(sp)
    800044f2:	e456                	sd	s5,8(sp)
    800044f4:	e05a                	sd	s6,0(sp)
    800044f6:	0080                	addi	s0,sp,64
    800044f8:	8b2a                	mv	s6,a0
    800044fa:	001b5a97          	auipc	s5,0x1b5
    800044fe:	9d6a8a93          	addi	s5,s5,-1578 # 801b8ed0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80004502:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004504:	001b5997          	auipc	s3,0x1b5
    80004508:	99c98993          	addi	s3,s3,-1636 # 801b8ea0 <log>
    8000450c:	a829                	j	80004526 <install_trans+0x4e>
    brelse(lbuf);
    8000450e:	854a                	mv	a0,s2
    80004510:	a2eff0ef          	jal	8000373e <brelse>
    brelse(dbuf);
    80004514:	8526                	mv	a0,s1
    80004516:	a28ff0ef          	jal	8000373e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000451a:	2a05                	addiw	s4,s4,1
    8000451c:	0a91                	addi	s5,s5,4
    8000451e:	02c9a783          	lw	a5,44(s3)
    80004522:	04fa5463          	bge	s4,a5,8000456a <install_trans+0x92>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80004526:	0189a583          	lw	a1,24(s3)
    8000452a:	014585bb          	addw	a1,a1,s4
    8000452e:	2585                	addiw	a1,a1,1
    80004530:	0289a503          	lw	a0,40(s3)
    80004534:	902ff0ef          	jal	80003636 <bread>
    80004538:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000453a:	000aa583          	lw	a1,0(s5)
    8000453e:	0289a503          	lw	a0,40(s3)
    80004542:	8f4ff0ef          	jal	80003636 <bread>
    80004546:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004548:	40000613          	li	a2,1024
    8000454c:	05890593          	addi	a1,s2,88
    80004550:	05850513          	addi	a0,a0,88
    80004554:	835fc0ef          	jal	80000d88 <memmove>
    bwrite(dbuf);  // write dst to disk
    80004558:	8526                	mv	a0,s1
    8000455a:	9b2ff0ef          	jal	8000370c <bwrite>
    if(recovering == 0)
    8000455e:	fa0b18e3          	bnez	s6,8000450e <install_trans+0x36>
      bunpin(dbuf);
    80004562:	8526                	mv	a0,s1
    80004564:	a96ff0ef          	jal	800037fa <bunpin>
    80004568:	b75d                	j	8000450e <install_trans+0x36>
}
    8000456a:	70e2                	ld	ra,56(sp)
    8000456c:	7442                	ld	s0,48(sp)
    8000456e:	74a2                	ld	s1,40(sp)
    80004570:	7902                	ld	s2,32(sp)
    80004572:	69e2                	ld	s3,24(sp)
    80004574:	6a42                	ld	s4,16(sp)
    80004576:	6aa2                	ld	s5,8(sp)
    80004578:	6b02                	ld	s6,0(sp)
    8000457a:	6121                	addi	sp,sp,64
    8000457c:	8082                	ret
    8000457e:	8082                	ret

0000000080004580 <initlog>:
{
    80004580:	7179                	addi	sp,sp,-48
    80004582:	f406                	sd	ra,40(sp)
    80004584:	f022                	sd	s0,32(sp)
    80004586:	ec26                	sd	s1,24(sp)
    80004588:	e84a                	sd	s2,16(sp)
    8000458a:	e44e                	sd	s3,8(sp)
    8000458c:	1800                	addi	s0,sp,48
    8000458e:	892a                	mv	s2,a0
    80004590:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80004592:	001b5497          	auipc	s1,0x1b5
    80004596:	90e48493          	addi	s1,s1,-1778 # 801b8ea0 <log>
    8000459a:	00004597          	auipc	a1,0x4
    8000459e:	0de58593          	addi	a1,a1,222 # 80008678 <etext+0x678>
    800045a2:	8526                	mv	a0,s1
    800045a4:	e34fc0ef          	jal	80000bd8 <initlock>
  log.start = sb->logstart;
    800045a8:	0149a583          	lw	a1,20(s3)
    800045ac:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800045ae:	0109a783          	lw	a5,16(s3)
    800045b2:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800045b4:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800045b8:	854a                	mv	a0,s2
    800045ba:	87cff0ef          	jal	80003636 <bread>
  log.lh.n = lh->n;
    800045be:	4d30                	lw	a2,88(a0)
    800045c0:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800045c2:	00c05f63          	blez	a2,800045e0 <initlog+0x60>
    800045c6:	87aa                	mv	a5,a0
    800045c8:	001b5717          	auipc	a4,0x1b5
    800045cc:	90870713          	addi	a4,a4,-1784 # 801b8ed0 <log+0x30>
    800045d0:	060a                	slli	a2,a2,0x2
    800045d2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800045d4:	4ff4                	lw	a3,92(a5)
    800045d6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800045d8:	0791                	addi	a5,a5,4
    800045da:	0711                	addi	a4,a4,4
    800045dc:	fec79ce3          	bne	a5,a2,800045d4 <initlog+0x54>
  brelse(buf);
    800045e0:	95eff0ef          	jal	8000373e <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800045e4:	4505                	li	a0,1
    800045e6:	ef3ff0ef          	jal	800044d8 <install_trans>
  log.lh.n = 0;
    800045ea:	001b5797          	auipc	a5,0x1b5
    800045ee:	8e07a123          	sw	zero,-1822(a5) # 801b8ecc <log+0x2c>
  write_head(); // clear the log
    800045f2:	e89ff0ef          	jal	8000447a <write_head>
}
    800045f6:	70a2                	ld	ra,40(sp)
    800045f8:	7402                	ld	s0,32(sp)
    800045fa:	64e2                	ld	s1,24(sp)
    800045fc:	6942                	ld	s2,16(sp)
    800045fe:	69a2                	ld	s3,8(sp)
    80004600:	6145                	addi	sp,sp,48
    80004602:	8082                	ret

0000000080004604 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80004604:	1101                	addi	sp,sp,-32
    80004606:	ec06                	sd	ra,24(sp)
    80004608:	e822                	sd	s0,16(sp)
    8000460a:	e426                	sd	s1,8(sp)
    8000460c:	e04a                	sd	s2,0(sp)
    8000460e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80004610:	001b5517          	auipc	a0,0x1b5
    80004614:	89050513          	addi	a0,a0,-1904 # 801b8ea0 <log>
    80004618:	e40fc0ef          	jal	80000c58 <acquire>
  while(1){
    if(log.committing){
    8000461c:	001b5497          	auipc	s1,0x1b5
    80004620:	88448493          	addi	s1,s1,-1916 # 801b8ea0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004624:	4979                	li	s2,30
    80004626:	a029                	j	80004630 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80004628:	85a6                	mv	a1,s1
    8000462a:	8526                	mv	a0,s1
    8000462c:	fedfd0ef          	jal	80002618 <sleep>
    if(log.committing){
    80004630:	50dc                	lw	a5,36(s1)
    80004632:	fbfd                	bnez	a5,80004628 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80004634:	5098                	lw	a4,32(s1)
    80004636:	2705                	addiw	a4,a4,1
    80004638:	0027179b          	slliw	a5,a4,0x2
    8000463c:	9fb9                	addw	a5,a5,a4
    8000463e:	0017979b          	slliw	a5,a5,0x1
    80004642:	54d4                	lw	a3,44(s1)
    80004644:	9fb5                	addw	a5,a5,a3
    80004646:	00f95763          	bge	s2,a5,80004654 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000464a:	85a6                	mv	a1,s1
    8000464c:	8526                	mv	a0,s1
    8000464e:	fcbfd0ef          	jal	80002618 <sleep>
    80004652:	bff9                	j	80004630 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80004654:	001b5517          	auipc	a0,0x1b5
    80004658:	84c50513          	addi	a0,a0,-1972 # 801b8ea0 <log>
    8000465c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000465e:	e92fc0ef          	jal	80000cf0 <release>
      break;
    }
  }
}
    80004662:	60e2                	ld	ra,24(sp)
    80004664:	6442                	ld	s0,16(sp)
    80004666:	64a2                	ld	s1,8(sp)
    80004668:	6902                	ld	s2,0(sp)
    8000466a:	6105                	addi	sp,sp,32
    8000466c:	8082                	ret

000000008000466e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000466e:	7139                	addi	sp,sp,-64
    80004670:	fc06                	sd	ra,56(sp)
    80004672:	f822                	sd	s0,48(sp)
    80004674:	f426                	sd	s1,40(sp)
    80004676:	f04a                	sd	s2,32(sp)
    80004678:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000467a:	001b5497          	auipc	s1,0x1b5
    8000467e:	82648493          	addi	s1,s1,-2010 # 801b8ea0 <log>
    80004682:	8526                	mv	a0,s1
    80004684:	dd4fc0ef          	jal	80000c58 <acquire>
  log.outstanding -= 1;
    80004688:	509c                	lw	a5,32(s1)
    8000468a:	37fd                	addiw	a5,a5,-1
    8000468c:	0007891b          	sext.w	s2,a5
    80004690:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80004692:	50dc                	lw	a5,36(s1)
    80004694:	ef9d                	bnez	a5,800046d2 <end_op+0x64>
    panic("log.committing");
  if(log.outstanding == 0){
    80004696:	04091763          	bnez	s2,800046e4 <end_op+0x76>
    do_commit = 1;
    log.committing = 1;
    8000469a:	001b5497          	auipc	s1,0x1b5
    8000469e:	80648493          	addi	s1,s1,-2042 # 801b8ea0 <log>
    800046a2:	4785                	li	a5,1
    800046a4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800046a6:	8526                	mv	a0,s1
    800046a8:	e48fc0ef          	jal	80000cf0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800046ac:	54dc                	lw	a5,44(s1)
    800046ae:	04f04b63          	bgtz	a5,80004704 <end_op+0x96>
    acquire(&log.lock);
    800046b2:	001b4497          	auipc	s1,0x1b4
    800046b6:	7ee48493          	addi	s1,s1,2030 # 801b8ea0 <log>
    800046ba:	8526                	mv	a0,s1
    800046bc:	d9cfc0ef          	jal	80000c58 <acquire>
    log.committing = 0;
    800046c0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800046c4:	8526                	mv	a0,s1
    800046c6:	f9ffd0ef          	jal	80002664 <wakeup>
    release(&log.lock);
    800046ca:	8526                	mv	a0,s1
    800046cc:	e24fc0ef          	jal	80000cf0 <release>
}
    800046d0:	a025                	j	800046f8 <end_op+0x8a>
    800046d2:	ec4e                	sd	s3,24(sp)
    800046d4:	e852                	sd	s4,16(sp)
    800046d6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800046d8:	00004517          	auipc	a0,0x4
    800046dc:	fa850513          	addi	a0,a0,-88 # 80008680 <etext+0x680>
    800046e0:	918fc0ef          	jal	800007f8 <panic>
    wakeup(&log);
    800046e4:	001b4497          	auipc	s1,0x1b4
    800046e8:	7bc48493          	addi	s1,s1,1980 # 801b8ea0 <log>
    800046ec:	8526                	mv	a0,s1
    800046ee:	f77fd0ef          	jal	80002664 <wakeup>
  release(&log.lock);
    800046f2:	8526                	mv	a0,s1
    800046f4:	dfcfc0ef          	jal	80000cf0 <release>
}
    800046f8:	70e2                	ld	ra,56(sp)
    800046fa:	7442                	ld	s0,48(sp)
    800046fc:	74a2                	ld	s1,40(sp)
    800046fe:	7902                	ld	s2,32(sp)
    80004700:	6121                	addi	sp,sp,64
    80004702:	8082                	ret
    80004704:	ec4e                	sd	s3,24(sp)
    80004706:	e852                	sd	s4,16(sp)
    80004708:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000470a:	001b4a97          	auipc	s5,0x1b4
    8000470e:	7c6a8a93          	addi	s5,s5,1990 # 801b8ed0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80004712:	001b4a17          	auipc	s4,0x1b4
    80004716:	78ea0a13          	addi	s4,s4,1934 # 801b8ea0 <log>
    8000471a:	018a2583          	lw	a1,24(s4)
    8000471e:	012585bb          	addw	a1,a1,s2
    80004722:	2585                	addiw	a1,a1,1
    80004724:	028a2503          	lw	a0,40(s4)
    80004728:	f0ffe0ef          	jal	80003636 <bread>
    8000472c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000472e:	000aa583          	lw	a1,0(s5)
    80004732:	028a2503          	lw	a0,40(s4)
    80004736:	f01fe0ef          	jal	80003636 <bread>
    8000473a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000473c:	40000613          	li	a2,1024
    80004740:	05850593          	addi	a1,a0,88
    80004744:	05848513          	addi	a0,s1,88
    80004748:	e40fc0ef          	jal	80000d88 <memmove>
    bwrite(to);  // write the log
    8000474c:	8526                	mv	a0,s1
    8000474e:	fbffe0ef          	jal	8000370c <bwrite>
    brelse(from);
    80004752:	854e                	mv	a0,s3
    80004754:	febfe0ef          	jal	8000373e <brelse>
    brelse(to);
    80004758:	8526                	mv	a0,s1
    8000475a:	fe5fe0ef          	jal	8000373e <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000475e:	2905                	addiw	s2,s2,1
    80004760:	0a91                	addi	s5,s5,4
    80004762:	02ca2783          	lw	a5,44(s4)
    80004766:	faf94ae3          	blt	s2,a5,8000471a <end_op+0xac>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000476a:	d11ff0ef          	jal	8000447a <write_head>
    install_trans(0); // Now install writes to home locations
    8000476e:	4501                	li	a0,0
    80004770:	d69ff0ef          	jal	800044d8 <install_trans>
    log.lh.n = 0;
    80004774:	001b4797          	auipc	a5,0x1b4
    80004778:	7407ac23          	sw	zero,1880(a5) # 801b8ecc <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000477c:	cffff0ef          	jal	8000447a <write_head>
    80004780:	69e2                	ld	s3,24(sp)
    80004782:	6a42                	ld	s4,16(sp)
    80004784:	6aa2                	ld	s5,8(sp)
    80004786:	b735                	j	800046b2 <end_op+0x44>

0000000080004788 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80004788:	1101                	addi	sp,sp,-32
    8000478a:	ec06                	sd	ra,24(sp)
    8000478c:	e822                	sd	s0,16(sp)
    8000478e:	e426                	sd	s1,8(sp)
    80004790:	e04a                	sd	s2,0(sp)
    80004792:	1000                	addi	s0,sp,32
    80004794:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80004796:	001b4917          	auipc	s2,0x1b4
    8000479a:	70a90913          	addi	s2,s2,1802 # 801b8ea0 <log>
    8000479e:	854a                	mv	a0,s2
    800047a0:	cb8fc0ef          	jal	80000c58 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800047a4:	02c92603          	lw	a2,44(s2)
    800047a8:	47f5                	li	a5,29
    800047aa:	06c7c363          	blt	a5,a2,80004810 <log_write+0x88>
    800047ae:	001b4797          	auipc	a5,0x1b4
    800047b2:	70e7a783          	lw	a5,1806(a5) # 801b8ebc <log+0x1c>
    800047b6:	37fd                	addiw	a5,a5,-1
    800047b8:	04f65c63          	bge	a2,a5,80004810 <log_write+0x88>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800047bc:	001b4797          	auipc	a5,0x1b4
    800047c0:	7047a783          	lw	a5,1796(a5) # 801b8ec0 <log+0x20>
    800047c4:	04f05c63          	blez	a5,8000481c <log_write+0x94>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800047c8:	4781                	li	a5,0
    800047ca:	04c05f63          	blez	a2,80004828 <log_write+0xa0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800047ce:	44cc                	lw	a1,12(s1)
    800047d0:	001b4717          	auipc	a4,0x1b4
    800047d4:	70070713          	addi	a4,a4,1792 # 801b8ed0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800047d8:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800047da:	4314                	lw	a3,0(a4)
    800047dc:	04b68663          	beq	a3,a1,80004828 <log_write+0xa0>
  for (i = 0; i < log.lh.n; i++) {
    800047e0:	2785                	addiw	a5,a5,1
    800047e2:	0711                	addi	a4,a4,4
    800047e4:	fef61be3          	bne	a2,a5,800047da <log_write+0x52>
      break;
  }
  log.lh.block[i] = b->blockno;
    800047e8:	0621                	addi	a2,a2,8
    800047ea:	060a                	slli	a2,a2,0x2
    800047ec:	001b4797          	auipc	a5,0x1b4
    800047f0:	6b478793          	addi	a5,a5,1716 # 801b8ea0 <log>
    800047f4:	97b2                	add	a5,a5,a2
    800047f6:	44d8                	lw	a4,12(s1)
    800047f8:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800047fa:	8526                	mv	a0,s1
    800047fc:	fcbfe0ef          	jal	800037c6 <bpin>
    log.lh.n++;
    80004800:	001b4717          	auipc	a4,0x1b4
    80004804:	6a070713          	addi	a4,a4,1696 # 801b8ea0 <log>
    80004808:	575c                	lw	a5,44(a4)
    8000480a:	2785                	addiw	a5,a5,1
    8000480c:	d75c                	sw	a5,44(a4)
    8000480e:	a80d                	j	80004840 <log_write+0xb8>
    panic("too big a transaction");
    80004810:	00004517          	auipc	a0,0x4
    80004814:	e8050513          	addi	a0,a0,-384 # 80008690 <etext+0x690>
    80004818:	fe1fb0ef          	jal	800007f8 <panic>
    panic("log_write outside of trans");
    8000481c:	00004517          	auipc	a0,0x4
    80004820:	e8c50513          	addi	a0,a0,-372 # 800086a8 <etext+0x6a8>
    80004824:	fd5fb0ef          	jal	800007f8 <panic>
  log.lh.block[i] = b->blockno;
    80004828:	00878693          	addi	a3,a5,8
    8000482c:	068a                	slli	a3,a3,0x2
    8000482e:	001b4717          	auipc	a4,0x1b4
    80004832:	67270713          	addi	a4,a4,1650 # 801b8ea0 <log>
    80004836:	9736                	add	a4,a4,a3
    80004838:	44d4                	lw	a3,12(s1)
    8000483a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000483c:	faf60fe3          	beq	a2,a5,800047fa <log_write+0x72>
  }
  release(&log.lock);
    80004840:	001b4517          	auipc	a0,0x1b4
    80004844:	66050513          	addi	a0,a0,1632 # 801b8ea0 <log>
    80004848:	ca8fc0ef          	jal	80000cf0 <release>
}
    8000484c:	60e2                	ld	ra,24(sp)
    8000484e:	6442                	ld	s0,16(sp)
    80004850:	64a2                	ld	s1,8(sp)
    80004852:	6902                	ld	s2,0(sp)
    80004854:	6105                	addi	sp,sp,32
    80004856:	8082                	ret

0000000080004858 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80004858:	1101                	addi	sp,sp,-32
    8000485a:	ec06                	sd	ra,24(sp)
    8000485c:	e822                	sd	s0,16(sp)
    8000485e:	e426                	sd	s1,8(sp)
    80004860:	e04a                	sd	s2,0(sp)
    80004862:	1000                	addi	s0,sp,32
    80004864:	84aa                	mv	s1,a0
    80004866:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004868:	00004597          	auipc	a1,0x4
    8000486c:	e6058593          	addi	a1,a1,-416 # 800086c8 <etext+0x6c8>
    80004870:	0521                	addi	a0,a0,8
    80004872:	b66fc0ef          	jal	80000bd8 <initlock>
  lk->name = name;
    80004876:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000487a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000487e:	0204a423          	sw	zero,40(s1)
}
    80004882:	60e2                	ld	ra,24(sp)
    80004884:	6442                	ld	s0,16(sp)
    80004886:	64a2                	ld	s1,8(sp)
    80004888:	6902                	ld	s2,0(sp)
    8000488a:	6105                	addi	sp,sp,32
    8000488c:	8082                	ret

000000008000488e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000488e:	1101                	addi	sp,sp,-32
    80004890:	ec06                	sd	ra,24(sp)
    80004892:	e822                	sd	s0,16(sp)
    80004894:	e426                	sd	s1,8(sp)
    80004896:	e04a                	sd	s2,0(sp)
    80004898:	1000                	addi	s0,sp,32
    8000489a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000489c:	00850913          	addi	s2,a0,8
    800048a0:	854a                	mv	a0,s2
    800048a2:	bb6fc0ef          	jal	80000c58 <acquire>
  while (lk->locked) {
    800048a6:	409c                	lw	a5,0(s1)
    800048a8:	c799                	beqz	a5,800048b6 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800048aa:	85ca                	mv	a1,s2
    800048ac:	8526                	mv	a0,s1
    800048ae:	d6bfd0ef          	jal	80002618 <sleep>
  while (lk->locked) {
    800048b2:	409c                	lw	a5,0(s1)
    800048b4:	fbfd                	bnez	a5,800048aa <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800048b6:	4785                	li	a5,1
    800048b8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800048ba:	f74fd0ef          	jal	8000202e <myproc>
    800048be:	591c                	lw	a5,48(a0)
    800048c0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800048c2:	854a                	mv	a0,s2
    800048c4:	c2cfc0ef          	jal	80000cf0 <release>
}
    800048c8:	60e2                	ld	ra,24(sp)
    800048ca:	6442                	ld	s0,16(sp)
    800048cc:	64a2                	ld	s1,8(sp)
    800048ce:	6902                	ld	s2,0(sp)
    800048d0:	6105                	addi	sp,sp,32
    800048d2:	8082                	ret

00000000800048d4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800048d4:	1101                	addi	sp,sp,-32
    800048d6:	ec06                	sd	ra,24(sp)
    800048d8:	e822                	sd	s0,16(sp)
    800048da:	e426                	sd	s1,8(sp)
    800048dc:	e04a                	sd	s2,0(sp)
    800048de:	1000                	addi	s0,sp,32
    800048e0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800048e2:	00850913          	addi	s2,a0,8
    800048e6:	854a                	mv	a0,s2
    800048e8:	b70fc0ef          	jal	80000c58 <acquire>
  lk->locked = 0;
    800048ec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800048f0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800048f4:	8526                	mv	a0,s1
    800048f6:	d6ffd0ef          	jal	80002664 <wakeup>
  release(&lk->lk);
    800048fa:	854a                	mv	a0,s2
    800048fc:	bf4fc0ef          	jal	80000cf0 <release>
}
    80004900:	60e2                	ld	ra,24(sp)
    80004902:	6442                	ld	s0,16(sp)
    80004904:	64a2                	ld	s1,8(sp)
    80004906:	6902                	ld	s2,0(sp)
    80004908:	6105                	addi	sp,sp,32
    8000490a:	8082                	ret

000000008000490c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000490c:	7179                	addi	sp,sp,-48
    8000490e:	f406                	sd	ra,40(sp)
    80004910:	f022                	sd	s0,32(sp)
    80004912:	ec26                	sd	s1,24(sp)
    80004914:	e84a                	sd	s2,16(sp)
    80004916:	1800                	addi	s0,sp,48
    80004918:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000491a:	00850913          	addi	s2,a0,8
    8000491e:	854a                	mv	a0,s2
    80004920:	b38fc0ef          	jal	80000c58 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004924:	409c                	lw	a5,0(s1)
    80004926:	ef81                	bnez	a5,8000493e <holdingsleep+0x32>
    80004928:	4481                	li	s1,0
  release(&lk->lk);
    8000492a:	854a                	mv	a0,s2
    8000492c:	bc4fc0ef          	jal	80000cf0 <release>
  return r;
}
    80004930:	8526                	mv	a0,s1
    80004932:	70a2                	ld	ra,40(sp)
    80004934:	7402                	ld	s0,32(sp)
    80004936:	64e2                	ld	s1,24(sp)
    80004938:	6942                	ld	s2,16(sp)
    8000493a:	6145                	addi	sp,sp,48
    8000493c:	8082                	ret
    8000493e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004940:	0284a983          	lw	s3,40(s1)
    80004944:	eeafd0ef          	jal	8000202e <myproc>
    80004948:	5904                	lw	s1,48(a0)
    8000494a:	413484b3          	sub	s1,s1,s3
    8000494e:	0014b493          	seqz	s1,s1
    80004952:	69a2                	ld	s3,8(sp)
    80004954:	bfd9                	j	8000492a <holdingsleep+0x1e>

0000000080004956 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004956:	1141                	addi	sp,sp,-16
    80004958:	e406                	sd	ra,8(sp)
    8000495a:	e022                	sd	s0,0(sp)
    8000495c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000495e:	00004597          	auipc	a1,0x4
    80004962:	d7a58593          	addi	a1,a1,-646 # 800086d8 <etext+0x6d8>
    80004966:	001b4517          	auipc	a0,0x1b4
    8000496a:	68250513          	addi	a0,a0,1666 # 801b8fe8 <ftable>
    8000496e:	a6afc0ef          	jal	80000bd8 <initlock>
}
    80004972:	60a2                	ld	ra,8(sp)
    80004974:	6402                	ld	s0,0(sp)
    80004976:	0141                	addi	sp,sp,16
    80004978:	8082                	ret

000000008000497a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000497a:	1101                	addi	sp,sp,-32
    8000497c:	ec06                	sd	ra,24(sp)
    8000497e:	e822                	sd	s0,16(sp)
    80004980:	e426                	sd	s1,8(sp)
    80004982:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004984:	001b4517          	auipc	a0,0x1b4
    80004988:	66450513          	addi	a0,a0,1636 # 801b8fe8 <ftable>
    8000498c:	accfc0ef          	jal	80000c58 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004990:	001b4497          	auipc	s1,0x1b4
    80004994:	67048493          	addi	s1,s1,1648 # 801b9000 <ftable+0x18>
    80004998:	001b5717          	auipc	a4,0x1b5
    8000499c:	60870713          	addi	a4,a4,1544 # 801b9fa0 <disk>
    if(f->ref == 0){
    800049a0:	40dc                	lw	a5,4(s1)
    800049a2:	cf89                	beqz	a5,800049bc <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800049a4:	02848493          	addi	s1,s1,40
    800049a8:	fee49ce3          	bne	s1,a4,800049a0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800049ac:	001b4517          	auipc	a0,0x1b4
    800049b0:	63c50513          	addi	a0,a0,1596 # 801b8fe8 <ftable>
    800049b4:	b3cfc0ef          	jal	80000cf0 <release>
  return 0;
    800049b8:	4481                	li	s1,0
    800049ba:	a809                	j	800049cc <filealloc+0x52>
      f->ref = 1;
    800049bc:	4785                	li	a5,1
    800049be:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800049c0:	001b4517          	auipc	a0,0x1b4
    800049c4:	62850513          	addi	a0,a0,1576 # 801b8fe8 <ftable>
    800049c8:	b28fc0ef          	jal	80000cf0 <release>
}
    800049cc:	8526                	mv	a0,s1
    800049ce:	60e2                	ld	ra,24(sp)
    800049d0:	6442                	ld	s0,16(sp)
    800049d2:	64a2                	ld	s1,8(sp)
    800049d4:	6105                	addi	sp,sp,32
    800049d6:	8082                	ret

00000000800049d8 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800049d8:	1101                	addi	sp,sp,-32
    800049da:	ec06                	sd	ra,24(sp)
    800049dc:	e822                	sd	s0,16(sp)
    800049de:	e426                	sd	s1,8(sp)
    800049e0:	1000                	addi	s0,sp,32
    800049e2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800049e4:	001b4517          	auipc	a0,0x1b4
    800049e8:	60450513          	addi	a0,a0,1540 # 801b8fe8 <ftable>
    800049ec:	a6cfc0ef          	jal	80000c58 <acquire>
  if(f->ref < 1)
    800049f0:	40dc                	lw	a5,4(s1)
    800049f2:	02f05063          	blez	a5,80004a12 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800049f6:	2785                	addiw	a5,a5,1
    800049f8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800049fa:	001b4517          	auipc	a0,0x1b4
    800049fe:	5ee50513          	addi	a0,a0,1518 # 801b8fe8 <ftable>
    80004a02:	aeefc0ef          	jal	80000cf0 <release>
  return f;
}
    80004a06:	8526                	mv	a0,s1
    80004a08:	60e2                	ld	ra,24(sp)
    80004a0a:	6442                	ld	s0,16(sp)
    80004a0c:	64a2                	ld	s1,8(sp)
    80004a0e:	6105                	addi	sp,sp,32
    80004a10:	8082                	ret
    panic("filedup");
    80004a12:	00004517          	auipc	a0,0x4
    80004a16:	cce50513          	addi	a0,a0,-818 # 800086e0 <etext+0x6e0>
    80004a1a:	ddffb0ef          	jal	800007f8 <panic>

0000000080004a1e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004a1e:	7139                	addi	sp,sp,-64
    80004a20:	fc06                	sd	ra,56(sp)
    80004a22:	f822                	sd	s0,48(sp)
    80004a24:	f426                	sd	s1,40(sp)
    80004a26:	0080                	addi	s0,sp,64
    80004a28:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004a2a:	001b4517          	auipc	a0,0x1b4
    80004a2e:	5be50513          	addi	a0,a0,1470 # 801b8fe8 <ftable>
    80004a32:	a26fc0ef          	jal	80000c58 <acquire>
  if(f->ref < 1)
    80004a36:	40dc                	lw	a5,4(s1)
    80004a38:	04f05a63          	blez	a5,80004a8c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80004a3c:	37fd                	addiw	a5,a5,-1
    80004a3e:	0007871b          	sext.w	a4,a5
    80004a42:	c0dc                	sw	a5,4(s1)
    80004a44:	04e04e63          	bgtz	a4,80004aa0 <fileclose+0x82>
    80004a48:	f04a                	sd	s2,32(sp)
    80004a4a:	ec4e                	sd	s3,24(sp)
    80004a4c:	e852                	sd	s4,16(sp)
    80004a4e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004a50:	0004a903          	lw	s2,0(s1)
    80004a54:	0094ca83          	lbu	s5,9(s1)
    80004a58:	0104ba03          	ld	s4,16(s1)
    80004a5c:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004a60:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004a64:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004a68:	001b4517          	auipc	a0,0x1b4
    80004a6c:	58050513          	addi	a0,a0,1408 # 801b8fe8 <ftable>
    80004a70:	a80fc0ef          	jal	80000cf0 <release>

  if(ff.type == FD_PIPE){
    80004a74:	4785                	li	a5,1
    80004a76:	04f90063          	beq	s2,a5,80004ab6 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004a7a:	3979                	addiw	s2,s2,-2
    80004a7c:	4785                	li	a5,1
    80004a7e:	0527f563          	bgeu	a5,s2,80004ac8 <fileclose+0xaa>
    80004a82:	7902                	ld	s2,32(sp)
    80004a84:	69e2                	ld	s3,24(sp)
    80004a86:	6a42                	ld	s4,16(sp)
    80004a88:	6aa2                	ld	s5,8(sp)
    80004a8a:	a00d                	j	80004aac <fileclose+0x8e>
    80004a8c:	f04a                	sd	s2,32(sp)
    80004a8e:	ec4e                	sd	s3,24(sp)
    80004a90:	e852                	sd	s4,16(sp)
    80004a92:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004a94:	00004517          	auipc	a0,0x4
    80004a98:	c5450513          	addi	a0,a0,-940 # 800086e8 <etext+0x6e8>
    80004a9c:	d5dfb0ef          	jal	800007f8 <panic>
    release(&ftable.lock);
    80004aa0:	001b4517          	auipc	a0,0x1b4
    80004aa4:	54850513          	addi	a0,a0,1352 # 801b8fe8 <ftable>
    80004aa8:	a48fc0ef          	jal	80000cf0 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004aac:	70e2                	ld	ra,56(sp)
    80004aae:	7442                	ld	s0,48(sp)
    80004ab0:	74a2                	ld	s1,40(sp)
    80004ab2:	6121                	addi	sp,sp,64
    80004ab4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80004ab6:	85d6                	mv	a1,s5
    80004ab8:	8552                	mv	a0,s4
    80004aba:	336000ef          	jal	80004df0 <pipeclose>
    80004abe:	7902                	ld	s2,32(sp)
    80004ac0:	69e2                	ld	s3,24(sp)
    80004ac2:	6a42                	ld	s4,16(sp)
    80004ac4:	6aa2                	ld	s5,8(sp)
    80004ac6:	b7dd                	j	80004aac <fileclose+0x8e>
    begin_op();
    80004ac8:	b3dff0ef          	jal	80004604 <begin_op>
    iput(ff.ip);
    80004acc:	854e                	mv	a0,s3
    80004ace:	c22ff0ef          	jal	80003ef0 <iput>
    end_op();
    80004ad2:	b9dff0ef          	jal	8000466e <end_op>
    80004ad6:	7902                	ld	s2,32(sp)
    80004ad8:	69e2                	ld	s3,24(sp)
    80004ada:	6a42                	ld	s4,16(sp)
    80004adc:	6aa2                	ld	s5,8(sp)
    80004ade:	b7f9                	j	80004aac <fileclose+0x8e>

0000000080004ae0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004ae0:	715d                	addi	sp,sp,-80
    80004ae2:	e486                	sd	ra,72(sp)
    80004ae4:	e0a2                	sd	s0,64(sp)
    80004ae6:	fc26                	sd	s1,56(sp)
    80004ae8:	f44e                	sd	s3,40(sp)
    80004aea:	0880                	addi	s0,sp,80
    80004aec:	84aa                	mv	s1,a0
    80004aee:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80004af0:	d3efd0ef          	jal	8000202e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80004af4:	409c                	lw	a5,0(s1)
    80004af6:	37f9                	addiw	a5,a5,-2
    80004af8:	4705                	li	a4,1
    80004afa:	04f76063          	bltu	a4,a5,80004b3a <filestat+0x5a>
    80004afe:	f84a                	sd	s2,48(sp)
    80004b00:	892a                	mv	s2,a0
    ilock(f->ip);
    80004b02:	6c88                	ld	a0,24(s1)
    80004b04:	a6aff0ef          	jal	80003d6e <ilock>
    stati(f->ip, &st);
    80004b08:	fb840593          	addi	a1,s0,-72
    80004b0c:	6c88                	ld	a0,24(s1)
    80004b0e:	c8aff0ef          	jal	80003f98 <stati>
    iunlock(f->ip);
    80004b12:	6c88                	ld	a0,24(s1)
    80004b14:	b08ff0ef          	jal	80003e1c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80004b18:	46e1                	li	a3,24
    80004b1a:	fb840613          	addi	a2,s0,-72
    80004b1e:	85ce                	mv	a1,s3
    80004b20:	05893503          	ld	a0,88(s2)
    80004b24:	958fd0ef          	jal	80001c7c <copyout>
    80004b28:	41f5551b          	sraiw	a0,a0,0x1f
    80004b2c:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004b2e:	60a6                	ld	ra,72(sp)
    80004b30:	6406                	ld	s0,64(sp)
    80004b32:	74e2                	ld	s1,56(sp)
    80004b34:	79a2                	ld	s3,40(sp)
    80004b36:	6161                	addi	sp,sp,80
    80004b38:	8082                	ret
  return -1;
    80004b3a:	557d                	li	a0,-1
    80004b3c:	bfcd                	j	80004b2e <filestat+0x4e>

0000000080004b3e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004b3e:	7179                	addi	sp,sp,-48
    80004b40:	f406                	sd	ra,40(sp)
    80004b42:	f022                	sd	s0,32(sp)
    80004b44:	e84a                	sd	s2,16(sp)
    80004b46:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004b48:	00854783          	lbu	a5,8(a0)
    80004b4c:	cfd1                	beqz	a5,80004be8 <fileread+0xaa>
    80004b4e:	ec26                	sd	s1,24(sp)
    80004b50:	e44e                	sd	s3,8(sp)
    80004b52:	84aa                	mv	s1,a0
    80004b54:	89ae                	mv	s3,a1
    80004b56:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80004b58:	411c                	lw	a5,0(a0)
    80004b5a:	4705                	li	a4,1
    80004b5c:	04e78363          	beq	a5,a4,80004ba2 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004b60:	470d                	li	a4,3
    80004b62:	04e78763          	beq	a5,a4,80004bb0 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80004b66:	4709                	li	a4,2
    80004b68:	06e79a63          	bne	a5,a4,80004bdc <fileread+0x9e>
    ilock(f->ip);
    80004b6c:	6d08                	ld	a0,24(a0)
    80004b6e:	a00ff0ef          	jal	80003d6e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004b72:	874a                	mv	a4,s2
    80004b74:	5094                	lw	a3,32(s1)
    80004b76:	864e                	mv	a2,s3
    80004b78:	4585                	li	a1,1
    80004b7a:	6c88                	ld	a0,24(s1)
    80004b7c:	c46ff0ef          	jal	80003fc2 <readi>
    80004b80:	892a                	mv	s2,a0
    80004b82:	00a05563          	blez	a0,80004b8c <fileread+0x4e>
      f->off += r;
    80004b86:	509c                	lw	a5,32(s1)
    80004b88:	9fa9                	addw	a5,a5,a0
    80004b8a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004b8c:	6c88                	ld	a0,24(s1)
    80004b8e:	a8eff0ef          	jal	80003e1c <iunlock>
    80004b92:	64e2                	ld	s1,24(sp)
    80004b94:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80004b96:	854a                	mv	a0,s2
    80004b98:	70a2                	ld	ra,40(sp)
    80004b9a:	7402                	ld	s0,32(sp)
    80004b9c:	6942                	ld	s2,16(sp)
    80004b9e:	6145                	addi	sp,sp,48
    80004ba0:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80004ba2:	6908                	ld	a0,16(a0)
    80004ba4:	388000ef          	jal	80004f2c <piperead>
    80004ba8:	892a                	mv	s2,a0
    80004baa:	64e2                	ld	s1,24(sp)
    80004bac:	69a2                	ld	s3,8(sp)
    80004bae:	b7e5                	j	80004b96 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004bb0:	02451783          	lh	a5,36(a0)
    80004bb4:	03079693          	slli	a3,a5,0x30
    80004bb8:	92c1                	srli	a3,a3,0x30
    80004bba:	4725                	li	a4,9
    80004bbc:	02d76863          	bltu	a4,a3,80004bec <fileread+0xae>
    80004bc0:	0792                	slli	a5,a5,0x4
    80004bc2:	001b4717          	auipc	a4,0x1b4
    80004bc6:	38670713          	addi	a4,a4,902 # 801b8f48 <devsw>
    80004bca:	97ba                	add	a5,a5,a4
    80004bcc:	639c                	ld	a5,0(a5)
    80004bce:	c39d                	beqz	a5,80004bf4 <fileread+0xb6>
    r = devsw[f->major].read(1, addr, n);
    80004bd0:	4505                	li	a0,1
    80004bd2:	9782                	jalr	a5
    80004bd4:	892a                	mv	s2,a0
    80004bd6:	64e2                	ld	s1,24(sp)
    80004bd8:	69a2                	ld	s3,8(sp)
    80004bda:	bf75                	j	80004b96 <fileread+0x58>
    panic("fileread");
    80004bdc:	00004517          	auipc	a0,0x4
    80004be0:	b1c50513          	addi	a0,a0,-1252 # 800086f8 <etext+0x6f8>
    80004be4:	c15fb0ef          	jal	800007f8 <panic>
    return -1;
    80004be8:	597d                	li	s2,-1
    80004bea:	b775                	j	80004b96 <fileread+0x58>
      return -1;
    80004bec:	597d                	li	s2,-1
    80004bee:	64e2                	ld	s1,24(sp)
    80004bf0:	69a2                	ld	s3,8(sp)
    80004bf2:	b755                	j	80004b96 <fileread+0x58>
    80004bf4:	597d                	li	s2,-1
    80004bf6:	64e2                	ld	s1,24(sp)
    80004bf8:	69a2                	ld	s3,8(sp)
    80004bfa:	bf71                	j	80004b96 <fileread+0x58>

0000000080004bfc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004bfc:	00954783          	lbu	a5,9(a0)
    80004c00:	10078b63          	beqz	a5,80004d16 <filewrite+0x11a>
{
    80004c04:	715d                	addi	sp,sp,-80
    80004c06:	e486                	sd	ra,72(sp)
    80004c08:	e0a2                	sd	s0,64(sp)
    80004c0a:	f84a                	sd	s2,48(sp)
    80004c0c:	f052                	sd	s4,32(sp)
    80004c0e:	e85a                	sd	s6,16(sp)
    80004c10:	0880                	addi	s0,sp,80
    80004c12:	892a                	mv	s2,a0
    80004c14:	8b2e                	mv	s6,a1
    80004c16:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004c18:	411c                	lw	a5,0(a0)
    80004c1a:	4705                	li	a4,1
    80004c1c:	02e78763          	beq	a5,a4,80004c4a <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004c20:	470d                	li	a4,3
    80004c22:	02e78863          	beq	a5,a4,80004c52 <filewrite+0x56>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80004c26:	4709                	li	a4,2
    80004c28:	0ce79c63          	bne	a5,a4,80004d00 <filewrite+0x104>
    80004c2c:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004c2e:	0ac05863          	blez	a2,80004cde <filewrite+0xe2>
    80004c32:	fc26                	sd	s1,56(sp)
    80004c34:	ec56                	sd	s5,24(sp)
    80004c36:	e45e                	sd	s7,8(sp)
    80004c38:	e062                	sd	s8,0(sp)
    int i = 0;
    80004c3a:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80004c3c:	6b85                	lui	s7,0x1
    80004c3e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004c42:	6c05                	lui	s8,0x1
    80004c44:	c00c0c1b          	addiw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80004c48:	a8b5                	j	80004cc4 <filewrite+0xc8>
    ret = pipewrite(f->pipe, addr, n);
    80004c4a:	6908                	ld	a0,16(a0)
    80004c4c:	1fc000ef          	jal	80004e48 <pipewrite>
    80004c50:	a04d                	j	80004cf2 <filewrite+0xf6>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004c52:	02451783          	lh	a5,36(a0)
    80004c56:	03079693          	slli	a3,a5,0x30
    80004c5a:	92c1                	srli	a3,a3,0x30
    80004c5c:	4725                	li	a4,9
    80004c5e:	0ad76e63          	bltu	a4,a3,80004d1a <filewrite+0x11e>
    80004c62:	0792                	slli	a5,a5,0x4
    80004c64:	001b4717          	auipc	a4,0x1b4
    80004c68:	2e470713          	addi	a4,a4,740 # 801b8f48 <devsw>
    80004c6c:	97ba                	add	a5,a5,a4
    80004c6e:	679c                	ld	a5,8(a5)
    80004c70:	c7dd                	beqz	a5,80004d1e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004c72:	4505                	li	a0,1
    80004c74:	9782                	jalr	a5
    80004c76:	a8b5                	j	80004cf2 <filewrite+0xf6>
      if(n1 > max)
    80004c78:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80004c7c:	989ff0ef          	jal	80004604 <begin_op>
      ilock(f->ip);
    80004c80:	01893503          	ld	a0,24(s2)
    80004c84:	8eaff0ef          	jal	80003d6e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004c88:	8756                	mv	a4,s5
    80004c8a:	02092683          	lw	a3,32(s2)
    80004c8e:	01698633          	add	a2,s3,s6
    80004c92:	4585                	li	a1,1
    80004c94:	01893503          	ld	a0,24(s2)
    80004c98:	c26ff0ef          	jal	800040be <writei>
    80004c9c:	84aa                	mv	s1,a0
    80004c9e:	00a05763          	blez	a0,80004cac <filewrite+0xb0>
        f->off += r;
    80004ca2:	02092783          	lw	a5,32(s2)
    80004ca6:	9fa9                	addw	a5,a5,a0
    80004ca8:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004cac:	01893503          	ld	a0,24(s2)
    80004cb0:	96cff0ef          	jal	80003e1c <iunlock>
      end_op();
    80004cb4:	9bbff0ef          	jal	8000466e <end_op>

      if(r != n1){
    80004cb8:	029a9563          	bne	s5,s1,80004ce2 <filewrite+0xe6>
        // error from writei
        break;
      }
      i += r;
    80004cbc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80004cc0:	0149da63          	bge	s3,s4,80004cd4 <filewrite+0xd8>
      int n1 = n - i;
    80004cc4:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80004cc8:	0004879b          	sext.w	a5,s1
    80004ccc:	fafbd6e3          	bge	s7,a5,80004c78 <filewrite+0x7c>
    80004cd0:	84e2                	mv	s1,s8
    80004cd2:	b75d                	j	80004c78 <filewrite+0x7c>
    80004cd4:	74e2                	ld	s1,56(sp)
    80004cd6:	6ae2                	ld	s5,24(sp)
    80004cd8:	6ba2                	ld	s7,8(sp)
    80004cda:	6c02                	ld	s8,0(sp)
    80004cdc:	a039                	j	80004cea <filewrite+0xee>
    int i = 0;
    80004cde:	4981                	li	s3,0
    80004ce0:	a029                	j	80004cea <filewrite+0xee>
    80004ce2:	74e2                	ld	s1,56(sp)
    80004ce4:	6ae2                	ld	s5,24(sp)
    80004ce6:	6ba2                	ld	s7,8(sp)
    80004ce8:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80004cea:	033a1c63          	bne	s4,s3,80004d22 <filewrite+0x126>
    80004cee:	8552                	mv	a0,s4
    80004cf0:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004cf2:	60a6                	ld	ra,72(sp)
    80004cf4:	6406                	ld	s0,64(sp)
    80004cf6:	7942                	ld	s2,48(sp)
    80004cf8:	7a02                	ld	s4,32(sp)
    80004cfa:	6b42                	ld	s6,16(sp)
    80004cfc:	6161                	addi	sp,sp,80
    80004cfe:	8082                	ret
    80004d00:	fc26                	sd	s1,56(sp)
    80004d02:	f44e                	sd	s3,40(sp)
    80004d04:	ec56                	sd	s5,24(sp)
    80004d06:	e45e                	sd	s7,8(sp)
    80004d08:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80004d0a:	00004517          	auipc	a0,0x4
    80004d0e:	9fe50513          	addi	a0,a0,-1538 # 80008708 <etext+0x708>
    80004d12:	ae7fb0ef          	jal	800007f8 <panic>
    return -1;
    80004d16:	557d                	li	a0,-1
}
    80004d18:	8082                	ret
      return -1;
    80004d1a:	557d                	li	a0,-1
    80004d1c:	bfd9                	j	80004cf2 <filewrite+0xf6>
    80004d1e:	557d                	li	a0,-1
    80004d20:	bfc9                	j	80004cf2 <filewrite+0xf6>
    ret = (i == n ? n : -1);
    80004d22:	557d                	li	a0,-1
    80004d24:	79a2                	ld	s3,40(sp)
    80004d26:	b7f1                	j	80004cf2 <filewrite+0xf6>

0000000080004d28 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004d28:	7179                	addi	sp,sp,-48
    80004d2a:	f406                	sd	ra,40(sp)
    80004d2c:	f022                	sd	s0,32(sp)
    80004d2e:	ec26                	sd	s1,24(sp)
    80004d30:	e052                	sd	s4,0(sp)
    80004d32:	1800                	addi	s0,sp,48
    80004d34:	84aa                	mv	s1,a0
    80004d36:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004d38:	0005b023          	sd	zero,0(a1)
    80004d3c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004d40:	c3bff0ef          	jal	8000497a <filealloc>
    80004d44:	e088                	sd	a0,0(s1)
    80004d46:	c549                	beqz	a0,80004dd0 <pipealloc+0xa8>
    80004d48:	c33ff0ef          	jal	8000497a <filealloc>
    80004d4c:	00aa3023          	sd	a0,0(s4)
    80004d50:	cd25                	beqz	a0,80004dc8 <pipealloc+0xa0>
    80004d52:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004d54:	e35fb0ef          	jal	80000b88 <kalloc>
    80004d58:	892a                	mv	s2,a0
    80004d5a:	c12d                	beqz	a0,80004dbc <pipealloc+0x94>
    80004d5c:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004d5e:	4985                	li	s3,1
    80004d60:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004d64:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004d68:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004d6c:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004d70:	00004597          	auipc	a1,0x4
    80004d74:	9a858593          	addi	a1,a1,-1624 # 80008718 <etext+0x718>
    80004d78:	e61fb0ef          	jal	80000bd8 <initlock>
  (*f0)->type = FD_PIPE;
    80004d7c:	609c                	ld	a5,0(s1)
    80004d7e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004d82:	609c                	ld	a5,0(s1)
    80004d84:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004d88:	609c                	ld	a5,0(s1)
    80004d8a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004d8e:	609c                	ld	a5,0(s1)
    80004d90:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004d94:	000a3783          	ld	a5,0(s4)
    80004d98:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004d9c:	000a3783          	ld	a5,0(s4)
    80004da0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004da4:	000a3783          	ld	a5,0(s4)
    80004da8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004dac:	000a3783          	ld	a5,0(s4)
    80004db0:	0127b823          	sd	s2,16(a5)
  return 0;
    80004db4:	4501                	li	a0,0
    80004db6:	6942                	ld	s2,16(sp)
    80004db8:	69a2                	ld	s3,8(sp)
    80004dba:	a01d                	j	80004de0 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004dbc:	6088                	ld	a0,0(s1)
    80004dbe:	c119                	beqz	a0,80004dc4 <pipealloc+0x9c>
    80004dc0:	6942                	ld	s2,16(sp)
    80004dc2:	a029                	j	80004dcc <pipealloc+0xa4>
    80004dc4:	6942                	ld	s2,16(sp)
    80004dc6:	a029                	j	80004dd0 <pipealloc+0xa8>
    80004dc8:	6088                	ld	a0,0(s1)
    80004dca:	c10d                	beqz	a0,80004dec <pipealloc+0xc4>
    fileclose(*f0);
    80004dcc:	c53ff0ef          	jal	80004a1e <fileclose>
  if(*f1)
    80004dd0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004dd4:	557d                	li	a0,-1
  if(*f1)
    80004dd6:	c789                	beqz	a5,80004de0 <pipealloc+0xb8>
    fileclose(*f1);
    80004dd8:	853e                	mv	a0,a5
    80004dda:	c45ff0ef          	jal	80004a1e <fileclose>
  return -1;
    80004dde:	557d                	li	a0,-1
}
    80004de0:	70a2                	ld	ra,40(sp)
    80004de2:	7402                	ld	s0,32(sp)
    80004de4:	64e2                	ld	s1,24(sp)
    80004de6:	6a02                	ld	s4,0(sp)
    80004de8:	6145                	addi	sp,sp,48
    80004dea:	8082                	ret
  return -1;
    80004dec:	557d                	li	a0,-1
    80004dee:	bfcd                	j	80004de0 <pipealloc+0xb8>

0000000080004df0 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004df0:	1101                	addi	sp,sp,-32
    80004df2:	ec06                	sd	ra,24(sp)
    80004df4:	e822                	sd	s0,16(sp)
    80004df6:	e426                	sd	s1,8(sp)
    80004df8:	e04a                	sd	s2,0(sp)
    80004dfa:	1000                	addi	s0,sp,32
    80004dfc:	84aa                	mv	s1,a0
    80004dfe:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004e00:	e59fb0ef          	jal	80000c58 <acquire>
  if(writable){
    80004e04:	02090763          	beqz	s2,80004e32 <pipeclose+0x42>
    pi->writeopen = 0;
    80004e08:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004e0c:	21848513          	addi	a0,s1,536
    80004e10:	855fd0ef          	jal	80002664 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004e14:	2204b783          	ld	a5,544(s1)
    80004e18:	e785                	bnez	a5,80004e40 <pipeclose+0x50>
    release(&pi->lock);
    80004e1a:	8526                	mv	a0,s1
    80004e1c:	ed5fb0ef          	jal	80000cf0 <release>
    kfree((char*)pi);
    80004e20:	8526                	mv	a0,s1
    80004e22:	c85fb0ef          	jal	80000aa6 <kfree>
  } else
    release(&pi->lock);
}
    80004e26:	60e2                	ld	ra,24(sp)
    80004e28:	6442                	ld	s0,16(sp)
    80004e2a:	64a2                	ld	s1,8(sp)
    80004e2c:	6902                	ld	s2,0(sp)
    80004e2e:	6105                	addi	sp,sp,32
    80004e30:	8082                	ret
    pi->readopen = 0;
    80004e32:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004e36:	21c48513          	addi	a0,s1,540
    80004e3a:	82bfd0ef          	jal	80002664 <wakeup>
    80004e3e:	bfd9                	j	80004e14 <pipeclose+0x24>
    release(&pi->lock);
    80004e40:	8526                	mv	a0,s1
    80004e42:	eaffb0ef          	jal	80000cf0 <release>
}
    80004e46:	b7c5                	j	80004e26 <pipeclose+0x36>

0000000080004e48 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004e48:	711d                	addi	sp,sp,-96
    80004e4a:	ec86                	sd	ra,88(sp)
    80004e4c:	e8a2                	sd	s0,80(sp)
    80004e4e:	e4a6                	sd	s1,72(sp)
    80004e50:	e0ca                	sd	s2,64(sp)
    80004e52:	fc4e                	sd	s3,56(sp)
    80004e54:	f852                	sd	s4,48(sp)
    80004e56:	f456                	sd	s5,40(sp)
    80004e58:	1080                	addi	s0,sp,96
    80004e5a:	84aa                	mv	s1,a0
    80004e5c:	8aae                	mv	s5,a1
    80004e5e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004e60:	9cefd0ef          	jal	8000202e <myproc>
    80004e64:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004e66:	8526                	mv	a0,s1
    80004e68:	df1fb0ef          	jal	80000c58 <acquire>
  while(i < n){
    80004e6c:	0b405a63          	blez	s4,80004f20 <pipewrite+0xd8>
    80004e70:	f05a                	sd	s6,32(sp)
    80004e72:	ec5e                	sd	s7,24(sp)
    80004e74:	e862                	sd	s8,16(sp)
  int i = 0;
    80004e76:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004e78:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004e7a:	21848c13          	addi	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004e7e:	21c48b93          	addi	s7,s1,540
    80004e82:	a81d                	j	80004eb8 <pipewrite+0x70>
      release(&pi->lock);
    80004e84:	8526                	mv	a0,s1
    80004e86:	e6bfb0ef          	jal	80000cf0 <release>
      return -1;
    80004e8a:	597d                	li	s2,-1
    80004e8c:	7b02                	ld	s6,32(sp)
    80004e8e:	6be2                	ld	s7,24(sp)
    80004e90:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004e92:	854a                	mv	a0,s2
    80004e94:	60e6                	ld	ra,88(sp)
    80004e96:	6446                	ld	s0,80(sp)
    80004e98:	64a6                	ld	s1,72(sp)
    80004e9a:	6906                	ld	s2,64(sp)
    80004e9c:	79e2                	ld	s3,56(sp)
    80004e9e:	7a42                	ld	s4,48(sp)
    80004ea0:	7aa2                	ld	s5,40(sp)
    80004ea2:	6125                	addi	sp,sp,96
    80004ea4:	8082                	ret
      wakeup(&pi->nread);
    80004ea6:	8562                	mv	a0,s8
    80004ea8:	fbcfd0ef          	jal	80002664 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004eac:	85a6                	mv	a1,s1
    80004eae:	855e                	mv	a0,s7
    80004eb0:	f68fd0ef          	jal	80002618 <sleep>
  while(i < n){
    80004eb4:	05495b63          	bge	s2,s4,80004f0a <pipewrite+0xc2>
    if(pi->readopen == 0 || killed(pr)){
    80004eb8:	2204a783          	lw	a5,544(s1)
    80004ebc:	d7e1                	beqz	a5,80004e84 <pipewrite+0x3c>
    80004ebe:	854e                	mv	a0,s3
    80004ec0:	991fd0ef          	jal	80002850 <killed>
    80004ec4:	f161                	bnez	a0,80004e84 <pipewrite+0x3c>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004ec6:	2184a783          	lw	a5,536(s1)
    80004eca:	21c4a703          	lw	a4,540(s1)
    80004ece:	2007879b          	addiw	a5,a5,512
    80004ed2:	fcf70ae3          	beq	a4,a5,80004ea6 <pipewrite+0x5e>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004ed6:	4685                	li	a3,1
    80004ed8:	01590633          	add	a2,s2,s5
    80004edc:	faf40593          	addi	a1,s0,-81
    80004ee0:	0589b503          	ld	a0,88(s3)
    80004ee4:	e6ffc0ef          	jal	80001d52 <copyin>
    80004ee8:	03650e63          	beq	a0,s6,80004f24 <pipewrite+0xdc>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004eec:	21c4a783          	lw	a5,540(s1)
    80004ef0:	0017871b          	addiw	a4,a5,1
    80004ef4:	20e4ae23          	sw	a4,540(s1)
    80004ef8:	1ff7f793          	andi	a5,a5,511
    80004efc:	97a6                	add	a5,a5,s1
    80004efe:	faf44703          	lbu	a4,-81(s0)
    80004f02:	00e78c23          	sb	a4,24(a5)
      i++;
    80004f06:	2905                	addiw	s2,s2,1
    80004f08:	b775                	j	80004eb4 <pipewrite+0x6c>
    80004f0a:	7b02                	ld	s6,32(sp)
    80004f0c:	6be2                	ld	s7,24(sp)
    80004f0e:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80004f10:	21848513          	addi	a0,s1,536
    80004f14:	f50fd0ef          	jal	80002664 <wakeup>
  release(&pi->lock);
    80004f18:	8526                	mv	a0,s1
    80004f1a:	dd7fb0ef          	jal	80000cf0 <release>
  return i;
    80004f1e:	bf95                	j	80004e92 <pipewrite+0x4a>
  int i = 0;
    80004f20:	4901                	li	s2,0
    80004f22:	b7fd                	j	80004f10 <pipewrite+0xc8>
    80004f24:	7b02                	ld	s6,32(sp)
    80004f26:	6be2                	ld	s7,24(sp)
    80004f28:	6c42                	ld	s8,16(sp)
    80004f2a:	b7dd                	j	80004f10 <pipewrite+0xc8>

0000000080004f2c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004f2c:	715d                	addi	sp,sp,-80
    80004f2e:	e486                	sd	ra,72(sp)
    80004f30:	e0a2                	sd	s0,64(sp)
    80004f32:	fc26                	sd	s1,56(sp)
    80004f34:	f84a                	sd	s2,48(sp)
    80004f36:	f44e                	sd	s3,40(sp)
    80004f38:	f052                	sd	s4,32(sp)
    80004f3a:	ec56                	sd	s5,24(sp)
    80004f3c:	0880                	addi	s0,sp,80
    80004f3e:	84aa                	mv	s1,a0
    80004f40:	892e                	mv	s2,a1
    80004f42:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004f44:	8eafd0ef          	jal	8000202e <myproc>
    80004f48:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004f4a:	8526                	mv	a0,s1
    80004f4c:	d0dfb0ef          	jal	80000c58 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f50:	2184a703          	lw	a4,536(s1)
    80004f54:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f58:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f5c:	02f71563          	bne	a4,a5,80004f86 <piperead+0x5a>
    80004f60:	2244a783          	lw	a5,548(s1)
    80004f64:	cb85                	beqz	a5,80004f94 <piperead+0x68>
    if(killed(pr)){
    80004f66:	8552                	mv	a0,s4
    80004f68:	8e9fd0ef          	jal	80002850 <killed>
    80004f6c:	ed19                	bnez	a0,80004f8a <piperead+0x5e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004f6e:	85a6                	mv	a1,s1
    80004f70:	854e                	mv	a0,s3
    80004f72:	ea6fd0ef          	jal	80002618 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004f76:	2184a703          	lw	a4,536(s1)
    80004f7a:	21c4a783          	lw	a5,540(s1)
    80004f7e:	fef701e3          	beq	a4,a5,80004f60 <piperead+0x34>
    80004f82:	e85a                	sd	s6,16(sp)
    80004f84:	a809                	j	80004f96 <piperead+0x6a>
    80004f86:	e85a                	sd	s6,16(sp)
    80004f88:	a039                	j	80004f96 <piperead+0x6a>
      release(&pi->lock);
    80004f8a:	8526                	mv	a0,s1
    80004f8c:	d65fb0ef          	jal	80000cf0 <release>
      return -1;
    80004f90:	59fd                	li	s3,-1
    80004f92:	a8b1                	j	80004fee <piperead+0xc2>
    80004f94:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f96:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004f98:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004f9a:	05505263          	blez	s5,80004fde <piperead+0xb2>
    if(pi->nread == pi->nwrite)
    80004f9e:	2184a783          	lw	a5,536(s1)
    80004fa2:	21c4a703          	lw	a4,540(s1)
    80004fa6:	02f70c63          	beq	a4,a5,80004fde <piperead+0xb2>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004faa:	0017871b          	addiw	a4,a5,1
    80004fae:	20e4ac23          	sw	a4,536(s1)
    80004fb2:	1ff7f793          	andi	a5,a5,511
    80004fb6:	97a6                	add	a5,a5,s1
    80004fb8:	0187c783          	lbu	a5,24(a5)
    80004fbc:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004fc0:	4685                	li	a3,1
    80004fc2:	fbf40613          	addi	a2,s0,-65
    80004fc6:	85ca                	mv	a1,s2
    80004fc8:	058a3503          	ld	a0,88(s4)
    80004fcc:	cb1fc0ef          	jal	80001c7c <copyout>
    80004fd0:	01650763          	beq	a0,s6,80004fde <piperead+0xb2>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004fd4:	2985                	addiw	s3,s3,1
    80004fd6:	0905                	addi	s2,s2,1
    80004fd8:	fd3a93e3          	bne	s5,s3,80004f9e <piperead+0x72>
    80004fdc:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004fde:	21c48513          	addi	a0,s1,540
    80004fe2:	e82fd0ef          	jal	80002664 <wakeup>
  release(&pi->lock);
    80004fe6:	8526                	mv	a0,s1
    80004fe8:	d09fb0ef          	jal	80000cf0 <release>
    80004fec:	6b42                	ld	s6,16(sp)
  return i;
}
    80004fee:	854e                	mv	a0,s3
    80004ff0:	60a6                	ld	ra,72(sp)
    80004ff2:	6406                	ld	s0,64(sp)
    80004ff4:	74e2                	ld	s1,56(sp)
    80004ff6:	7942                	ld	s2,48(sp)
    80004ff8:	79a2                	ld	s3,40(sp)
    80004ffa:	7a02                	ld	s4,32(sp)
    80004ffc:	6ae2                	ld	s5,24(sp)
    80004ffe:	6161                	addi	sp,sp,80
    80005000:	8082                	ret

0000000080005002 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80005002:	1141                	addi	sp,sp,-16
    80005004:	e422                	sd	s0,8(sp)
    80005006:	0800                	addi	s0,sp,16
    80005008:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000500a:	8905                	andi	a0,a0,1
    8000500c:	050e                	slli	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000500e:	8b89                	andi	a5,a5,2
    80005010:	c399                	beqz	a5,80005016 <flags2perm+0x14>
      perm |= PTE_W;
    80005012:	00456513          	ori	a0,a0,4
    return perm;
}
    80005016:	6422                	ld	s0,8(sp)
    80005018:	0141                	addi	sp,sp,16
    8000501a:	8082                	ret

000000008000501c <exec>:

int
exec(char *path, char **argv)
{
    8000501c:	df010113          	addi	sp,sp,-528
    80005020:	20113423          	sd	ra,520(sp)
    80005024:	20813023          	sd	s0,512(sp)
    80005028:	ffa6                	sd	s1,504(sp)
    8000502a:	fbca                	sd	s2,496(sp)
    8000502c:	0c00                	addi	s0,sp,528
    8000502e:	892a                	mv	s2,a0
    80005030:	dea43c23          	sd	a0,-520(s0)
    80005034:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80005038:	ff7fc0ef          	jal	8000202e <myproc>
    8000503c:	84aa                	mv	s1,a0

  begin_op();
    8000503e:	dc6ff0ef          	jal	80004604 <begin_op>

  if((ip = namei(path)) == 0){
    80005042:	854a                	mv	a0,s2
    80005044:	c04ff0ef          	jal	80004448 <namei>
    80005048:	c931                	beqz	a0,8000509c <exec+0x80>
    8000504a:	f3d2                	sd	s4,480(sp)
    8000504c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000504e:	d21fe0ef          	jal	80003d6e <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80005052:	04000713          	li	a4,64
    80005056:	4681                	li	a3,0
    80005058:	e5040613          	addi	a2,s0,-432
    8000505c:	4581                	li	a1,0
    8000505e:	8552                	mv	a0,s4
    80005060:	f63fe0ef          	jal	80003fc2 <readi>
    80005064:	04000793          	li	a5,64
    80005068:	00f51a63          	bne	a0,a5,8000507c <exec+0x60>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000506c:	e5042703          	lw	a4,-432(s0)
    80005070:	464c47b7          	lui	a5,0x464c4
    80005074:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80005078:	02f70663          	beq	a4,a5,800050a4 <exec+0x88>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000507c:	8552                	mv	a0,s4
    8000507e:	efbfe0ef          	jal	80003f78 <iunlockput>
    end_op();
    80005082:	decff0ef          	jal	8000466e <end_op>
  }
  return -1;
    80005086:	557d                	li	a0,-1
    80005088:	7a1e                	ld	s4,480(sp)
}
    8000508a:	20813083          	ld	ra,520(sp)
    8000508e:	20013403          	ld	s0,512(sp)
    80005092:	74fe                	ld	s1,504(sp)
    80005094:	795e                	ld	s2,496(sp)
    80005096:	21010113          	addi	sp,sp,528
    8000509a:	8082                	ret
    end_op();
    8000509c:	dd2ff0ef          	jal	8000466e <end_op>
    return -1;
    800050a0:	557d                	li	a0,-1
    800050a2:	b7e5                	j	8000508a <exec+0x6e>
    800050a4:	ebda                	sd	s6,464(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800050a6:	8526                	mv	a0,s1
    800050a8:	82efd0ef          	jal	800020d6 <proc_pagetable>
    800050ac:	8b2a                	mv	s6,a0
    800050ae:	2c050b63          	beqz	a0,80005384 <exec+0x368>
    800050b2:	f7ce                	sd	s3,488(sp)
    800050b4:	efd6                	sd	s5,472(sp)
    800050b6:	e7de                	sd	s7,456(sp)
    800050b8:	e3e2                	sd	s8,448(sp)
    800050ba:	ff66                	sd	s9,440(sp)
    800050bc:	fb6a                	sd	s10,432(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800050be:	e7042d03          	lw	s10,-400(s0)
    800050c2:	e8845783          	lhu	a5,-376(s0)
    800050c6:	12078963          	beqz	a5,800051f8 <exec+0x1dc>
    800050ca:	f76e                	sd	s11,424(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800050cc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800050ce:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    800050d0:	6c85                	lui	s9,0x1
    800050d2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800050d6:	def43823          	sd	a5,-528(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800050da:	6a85                	lui	s5,0x1
    800050dc:	a085                	j	8000513c <exec+0x120>
      panic("loadseg: address should exist");
    800050de:	00003517          	auipc	a0,0x3
    800050e2:	64250513          	addi	a0,a0,1602 # 80008720 <etext+0x720>
    800050e6:	f12fb0ef          	jal	800007f8 <panic>
    if(sz - i < PGSIZE)
    800050ea:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800050ec:	8726                	mv	a4,s1
    800050ee:	012c06bb          	addw	a3,s8,s2
    800050f2:	4581                	li	a1,0
    800050f4:	8552                	mv	a0,s4
    800050f6:	ecdfe0ef          	jal	80003fc2 <readi>
    800050fa:	2501                	sext.w	a0,a0
    800050fc:	24a49a63          	bne	s1,a0,80005350 <exec+0x334>
  for(i = 0; i < sz; i += PGSIZE){
    80005100:	012a893b          	addw	s2,s5,s2
    80005104:	03397363          	bgeu	s2,s3,8000512a <exec+0x10e>
    pa = walkaddr(pagetable, va + i);
    80005108:	02091593          	slli	a1,s2,0x20
    8000510c:	9181                	srli	a1,a1,0x20
    8000510e:	95de                	add	a1,a1,s7
    80005110:	855a                	mv	a0,s6
    80005112:	deefc0ef          	jal	80001700 <walkaddr>
    80005116:	862a                	mv	a2,a0
    if(pa == 0)
    80005118:	d179                	beqz	a0,800050de <exec+0xc2>
    if(sz - i < PGSIZE)
    8000511a:	412984bb          	subw	s1,s3,s2
    8000511e:	0004879b          	sext.w	a5,s1
    80005122:	fcfcf4e3          	bgeu	s9,a5,800050ea <exec+0xce>
    80005126:	84d6                	mv	s1,s5
    80005128:	b7c9                	j	800050ea <exec+0xce>
    sz = sz1;
    8000512a:	e0843903          	ld	s2,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000512e:	2d85                	addiw	s11,s11,1
    80005130:	038d0d1b          	addiw	s10,s10,56 # 1038 <_entry-0x7fffefc8>
    80005134:	e8845783          	lhu	a5,-376(s0)
    80005138:	08fdd063          	bge	s11,a5,800051b8 <exec+0x19c>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000513c:	2d01                	sext.w	s10,s10
    8000513e:	03800713          	li	a4,56
    80005142:	86ea                	mv	a3,s10
    80005144:	e1840613          	addi	a2,s0,-488
    80005148:	4581                	li	a1,0
    8000514a:	8552                	mv	a0,s4
    8000514c:	e77fe0ef          	jal	80003fc2 <readi>
    80005150:	03800793          	li	a5,56
    80005154:	1cf51663          	bne	a0,a5,80005320 <exec+0x304>
    if(ph.type != ELF_PROG_LOAD)
    80005158:	e1842783          	lw	a5,-488(s0)
    8000515c:	4705                	li	a4,1
    8000515e:	fce798e3          	bne	a5,a4,8000512e <exec+0x112>
    if(ph.memsz < ph.filesz)
    80005162:	e4043483          	ld	s1,-448(s0)
    80005166:	e3843783          	ld	a5,-456(s0)
    8000516a:	1af4ef63          	bltu	s1,a5,80005328 <exec+0x30c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000516e:	e2843783          	ld	a5,-472(s0)
    80005172:	94be                	add	s1,s1,a5
    80005174:	1af4ee63          	bltu	s1,a5,80005330 <exec+0x314>
    if(ph.vaddr % PGSIZE != 0)
    80005178:	df043703          	ld	a4,-528(s0)
    8000517c:	8ff9                	and	a5,a5,a4
    8000517e:	1a079d63          	bnez	a5,80005338 <exec+0x31c>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80005182:	e1c42503          	lw	a0,-484(s0)
    80005186:	e7dff0ef          	jal	80005002 <flags2perm>
    8000518a:	86aa                	mv	a3,a0
    8000518c:	8626                	mv	a2,s1
    8000518e:	85ca                	mv	a1,s2
    80005190:	855a                	mv	a0,s6
    80005192:	8d7fc0ef          	jal	80001a68 <uvmalloc>
    80005196:	e0a43423          	sd	a0,-504(s0)
    8000519a:	1a050363          	beqz	a0,80005340 <exec+0x324>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000519e:	e2843b83          	ld	s7,-472(s0)
    800051a2:	e2042c03          	lw	s8,-480(s0)
    800051a6:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800051aa:	00098463          	beqz	s3,800051b2 <exec+0x196>
    800051ae:	4901                	li	s2,0
    800051b0:	bfa1                	j	80005108 <exec+0xec>
    sz = sz1;
    800051b2:	e0843903          	ld	s2,-504(s0)
    800051b6:	bfa5                	j	8000512e <exec+0x112>
    800051b8:	7dba                	ld	s11,424(sp)
  iunlockput(ip);
    800051ba:	8552                	mv	a0,s4
    800051bc:	dbdfe0ef          	jal	80003f78 <iunlockput>
  end_op();
    800051c0:	caeff0ef          	jal	8000466e <end_op>
  p = myproc();
    800051c4:	e6bfc0ef          	jal	8000202e <myproc>
    800051c8:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800051ca:	05053c83          	ld	s9,80(a0)
  sz = PGROUNDUP(sz);
    800051ce:	6985                	lui	s3,0x1
    800051d0:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800051d2:	99ca                	add	s3,s3,s2
    800051d4:	77fd                	lui	a5,0xfffff
    800051d6:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800051da:	4691                	li	a3,4
    800051dc:	6609                	lui	a2,0x2
    800051de:	964e                	add	a2,a2,s3
    800051e0:	85ce                	mv	a1,s3
    800051e2:	855a                	mv	a0,s6
    800051e4:	885fc0ef          	jal	80001a68 <uvmalloc>
    800051e8:	892a                	mv	s2,a0
    800051ea:	e0a43423          	sd	a0,-504(s0)
    800051ee:	e519                	bnez	a0,800051fc <exec+0x1e0>
  if(pagetable)
    800051f0:	e1343423          	sd	s3,-504(s0)
    800051f4:	4a01                	li	s4,0
    800051f6:	aab1                	j	80005352 <exec+0x336>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800051f8:	4901                	li	s2,0
    800051fa:	b7c1                	j	800051ba <exec+0x19e>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800051fc:	75f9                	lui	a1,0xffffe
    800051fe:	95aa                	add	a1,a1,a0
    80005200:	855a                	mv	a0,s6
    80005202:	a51fc0ef          	jal	80001c52 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80005206:	7bfd                	lui	s7,0xfffff
    80005208:	9bca                	add	s7,s7,s2
  for(argc = 0; argv[argc]; argc++) {
    8000520a:	e0043783          	ld	a5,-512(s0)
    8000520e:	6388                	ld	a0,0(a5)
    80005210:	cd39                	beqz	a0,8000526e <exec+0x252>
    80005212:	e9040993          	addi	s3,s0,-368
    80005216:	f9040c13          	addi	s8,s0,-112
    8000521a:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    8000521c:	c81fb0ef          	jal	80000e9c <strlen>
    80005220:	0015079b          	addiw	a5,a0,1
    80005224:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005228:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000522c:	11796e63          	bltu	s2,s7,80005348 <exec+0x32c>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80005230:	e0043d03          	ld	s10,-512(s0)
    80005234:	000d3a03          	ld	s4,0(s10)
    80005238:	8552                	mv	a0,s4
    8000523a:	c63fb0ef          	jal	80000e9c <strlen>
    8000523e:	0015069b          	addiw	a3,a0,1
    80005242:	8652                	mv	a2,s4
    80005244:	85ca                	mv	a1,s2
    80005246:	855a                	mv	a0,s6
    80005248:	a35fc0ef          	jal	80001c7c <copyout>
    8000524c:	10054063          	bltz	a0,8000534c <exec+0x330>
    ustack[argc] = sp;
    80005250:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80005254:	0485                	addi	s1,s1,1
    80005256:	008d0793          	addi	a5,s10,8
    8000525a:	e0f43023          	sd	a5,-512(s0)
    8000525e:	008d3503          	ld	a0,8(s10)
    80005262:	c909                	beqz	a0,80005274 <exec+0x258>
    if(argc >= MAXARG)
    80005264:	09a1                	addi	s3,s3,8
    80005266:	fb899be3          	bne	s3,s8,8000521c <exec+0x200>
  ip = 0;
    8000526a:	4a01                	li	s4,0
    8000526c:	a0dd                	j	80005352 <exec+0x336>
  sp = sz;
    8000526e:	e0843903          	ld	s2,-504(s0)
  for(argc = 0; argv[argc]; argc++) {
    80005272:	4481                	li	s1,0
  ustack[argc] = 0;
    80005274:	00349793          	slli	a5,s1,0x3
    80005278:	f9078793          	addi	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7fe44eb0>
    8000527c:	97a2                	add	a5,a5,s0
    8000527e:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80005282:	00148693          	addi	a3,s1,1
    80005286:	068e                	slli	a3,a3,0x3
    80005288:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000528c:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80005290:	e0843983          	ld	s3,-504(s0)
  if(sp < stackbase)
    80005294:	f5796ee3          	bltu	s2,s7,800051f0 <exec+0x1d4>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80005298:	e9040613          	addi	a2,s0,-368
    8000529c:	85ca                	mv	a1,s2
    8000529e:	855a                	mv	a0,s6
    800052a0:	9ddfc0ef          	jal	80001c7c <copyout>
    800052a4:	0e054263          	bltz	a0,80005388 <exec+0x36c>
  p->trapframe->a1 = sp;
    800052a8:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    800052ac:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800052b0:	df843783          	ld	a5,-520(s0)
    800052b4:	0007c703          	lbu	a4,0(a5)
    800052b8:	cf11                	beqz	a4,800052d4 <exec+0x2b8>
    800052ba:	0785                	addi	a5,a5,1
    if(*s == '/')
    800052bc:	02f00693          	li	a3,47
    800052c0:	a039                	j	800052ce <exec+0x2b2>
      last = s+1;
    800052c2:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800052c6:	0785                	addi	a5,a5,1
    800052c8:	fff7c703          	lbu	a4,-1(a5)
    800052cc:	c701                	beqz	a4,800052d4 <exec+0x2b8>
    if(*s == '/')
    800052ce:	fed71ce3          	bne	a4,a3,800052c6 <exec+0x2aa>
    800052d2:	bfc5                	j	800052c2 <exec+0x2a6>
  safestrcpy(p->name, last, sizeof(p->name));
    800052d4:	4641                	li	a2,16
    800052d6:	df843583          	ld	a1,-520(s0)
    800052da:	160a8513          	addi	a0,s5,352
    800052de:	b8dfb0ef          	jal	80000e6a <safestrcpy>
  oldpagetable = p->pagetable;
    800052e2:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    800052e6:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    800052ea:	e0843783          	ld	a5,-504(s0)
    800052ee:	04fab823          	sd	a5,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800052f2:	060ab783          	ld	a5,96(s5)
    800052f6:	e6843703          	ld	a4,-408(s0)
    800052fa:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800052fc:	060ab783          	ld	a5,96(s5)
    80005300:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80005304:	85e6                	mv	a1,s9
    80005306:	e55fc0ef          	jal	8000215a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000530a:	0004851b          	sext.w	a0,s1
    8000530e:	79be                	ld	s3,488(sp)
    80005310:	7a1e                	ld	s4,480(sp)
    80005312:	6afe                	ld	s5,472(sp)
    80005314:	6b5e                	ld	s6,464(sp)
    80005316:	6bbe                	ld	s7,456(sp)
    80005318:	6c1e                	ld	s8,448(sp)
    8000531a:	7cfa                	ld	s9,440(sp)
    8000531c:	7d5a                	ld	s10,432(sp)
    8000531e:	b3b5                	j	8000508a <exec+0x6e>
    80005320:	e1243423          	sd	s2,-504(s0)
    80005324:	7dba                	ld	s11,424(sp)
    80005326:	a035                	j	80005352 <exec+0x336>
    80005328:	e1243423          	sd	s2,-504(s0)
    8000532c:	7dba                	ld	s11,424(sp)
    8000532e:	a015                	j	80005352 <exec+0x336>
    80005330:	e1243423          	sd	s2,-504(s0)
    80005334:	7dba                	ld	s11,424(sp)
    80005336:	a831                	j	80005352 <exec+0x336>
    80005338:	e1243423          	sd	s2,-504(s0)
    8000533c:	7dba                	ld	s11,424(sp)
    8000533e:	a811                	j	80005352 <exec+0x336>
    80005340:	e1243423          	sd	s2,-504(s0)
    80005344:	7dba                	ld	s11,424(sp)
    80005346:	a031                	j	80005352 <exec+0x336>
  ip = 0;
    80005348:	4a01                	li	s4,0
    8000534a:	a021                	j	80005352 <exec+0x336>
    8000534c:	4a01                	li	s4,0
  if(pagetable)
    8000534e:	a011                	j	80005352 <exec+0x336>
    80005350:	7dba                	ld	s11,424(sp)
    proc_freepagetable(pagetable, sz);
    80005352:	e0843583          	ld	a1,-504(s0)
    80005356:	855a                	mv	a0,s6
    80005358:	e03fc0ef          	jal	8000215a <proc_freepagetable>
  return -1;
    8000535c:	557d                	li	a0,-1
  if(ip){
    8000535e:	000a1b63          	bnez	s4,80005374 <exec+0x358>
    80005362:	79be                	ld	s3,488(sp)
    80005364:	7a1e                	ld	s4,480(sp)
    80005366:	6afe                	ld	s5,472(sp)
    80005368:	6b5e                	ld	s6,464(sp)
    8000536a:	6bbe                	ld	s7,456(sp)
    8000536c:	6c1e                	ld	s8,448(sp)
    8000536e:	7cfa                	ld	s9,440(sp)
    80005370:	7d5a                	ld	s10,432(sp)
    80005372:	bb21                	j	8000508a <exec+0x6e>
    80005374:	79be                	ld	s3,488(sp)
    80005376:	6afe                	ld	s5,472(sp)
    80005378:	6b5e                	ld	s6,464(sp)
    8000537a:	6bbe                	ld	s7,456(sp)
    8000537c:	6c1e                	ld	s8,448(sp)
    8000537e:	7cfa                	ld	s9,440(sp)
    80005380:	7d5a                	ld	s10,432(sp)
    80005382:	b9ed                	j	8000507c <exec+0x60>
    80005384:	6b5e                	ld	s6,464(sp)
    80005386:	b9dd                	j	8000507c <exec+0x60>
  sz = sz1;
    80005388:	e0843983          	ld	s3,-504(s0)
    8000538c:	b595                	j	800051f0 <exec+0x1d4>

000000008000538e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000538e:	7179                	addi	sp,sp,-48
    80005390:	f406                	sd	ra,40(sp)
    80005392:	f022                	sd	s0,32(sp)
    80005394:	ec26                	sd	s1,24(sp)
    80005396:	e84a                	sd	s2,16(sp)
    80005398:	1800                	addi	s0,sp,48
    8000539a:	892e                	mv	s2,a1
    8000539c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    8000539e:	fdc40593          	addi	a1,s0,-36
    800053a2:	df3fd0ef          	jal	80003194 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800053a6:	fdc42703          	lw	a4,-36(s0)
    800053aa:	47bd                	li	a5,15
    800053ac:	02e7e963          	bltu	a5,a4,800053de <argfd+0x50>
    800053b0:	c7ffc0ef          	jal	8000202e <myproc>
    800053b4:	fdc42703          	lw	a4,-36(s0)
    800053b8:	01a70793          	addi	a5,a4,26
    800053bc:	078e                	slli	a5,a5,0x3
    800053be:	953e                	add	a0,a0,a5
    800053c0:	651c                	ld	a5,8(a0)
    800053c2:	c385                	beqz	a5,800053e2 <argfd+0x54>
    return -1;
  if(pfd)
    800053c4:	00090463          	beqz	s2,800053cc <argfd+0x3e>
    *pfd = fd;
    800053c8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800053cc:	4501                	li	a0,0
  if(pf)
    800053ce:	c091                	beqz	s1,800053d2 <argfd+0x44>
    *pf = f;
    800053d0:	e09c                	sd	a5,0(s1)
}
    800053d2:	70a2                	ld	ra,40(sp)
    800053d4:	7402                	ld	s0,32(sp)
    800053d6:	64e2                	ld	s1,24(sp)
    800053d8:	6942                	ld	s2,16(sp)
    800053da:	6145                	addi	sp,sp,48
    800053dc:	8082                	ret
    return -1;
    800053de:	557d                	li	a0,-1
    800053e0:	bfcd                	j	800053d2 <argfd+0x44>
    800053e2:	557d                	li	a0,-1
    800053e4:	b7fd                	j	800053d2 <argfd+0x44>

00000000800053e6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800053e6:	1101                	addi	sp,sp,-32
    800053e8:	ec06                	sd	ra,24(sp)
    800053ea:	e822                	sd	s0,16(sp)
    800053ec:	e426                	sd	s1,8(sp)
    800053ee:	1000                	addi	s0,sp,32
    800053f0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800053f2:	c3dfc0ef          	jal	8000202e <myproc>
    800053f6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800053f8:	0d850793          	addi	a5,a0,216
    800053fc:	4501                	li	a0,0
    800053fe:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80005400:	6398                	ld	a4,0(a5)
    80005402:	cb19                	beqz	a4,80005418 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80005404:	2505                	addiw	a0,a0,1
    80005406:	07a1                	addi	a5,a5,8
    80005408:	fed51ce3          	bne	a0,a3,80005400 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    8000540c:	557d                	li	a0,-1
}
    8000540e:	60e2                	ld	ra,24(sp)
    80005410:	6442                	ld	s0,16(sp)
    80005412:	64a2                	ld	s1,8(sp)
    80005414:	6105                	addi	sp,sp,32
    80005416:	8082                	ret
      p->ofile[fd] = f;
    80005418:	01a50793          	addi	a5,a0,26
    8000541c:	078e                	slli	a5,a5,0x3
    8000541e:	963e                	add	a2,a2,a5
    80005420:	e604                	sd	s1,8(a2)
      return fd;
    80005422:	b7f5                	j	8000540e <fdalloc+0x28>

0000000080005424 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80005424:	715d                	addi	sp,sp,-80
    80005426:	e486                	sd	ra,72(sp)
    80005428:	e0a2                	sd	s0,64(sp)
    8000542a:	fc26                	sd	s1,56(sp)
    8000542c:	f84a                	sd	s2,48(sp)
    8000542e:	f44e                	sd	s3,40(sp)
    80005430:	ec56                	sd	s5,24(sp)
    80005432:	e85a                	sd	s6,16(sp)
    80005434:	0880                	addi	s0,sp,80
    80005436:	8b2e                	mv	s6,a1
    80005438:	89b2                	mv	s3,a2
    8000543a:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000543c:	fb040593          	addi	a1,s0,-80
    80005440:	822ff0ef          	jal	80004462 <nameiparent>
    80005444:	84aa                	mv	s1,a0
    80005446:	10050a63          	beqz	a0,8000555a <create+0x136>
    return 0;

  ilock(dp);
    8000544a:	925fe0ef          	jal	80003d6e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000544e:	4601                	li	a2,0
    80005450:	fb040593          	addi	a1,s0,-80
    80005454:	8526                	mv	a0,s1
    80005456:	d8dfe0ef          	jal	800041e2 <dirlookup>
    8000545a:	8aaa                	mv	s5,a0
    8000545c:	c129                	beqz	a0,8000549e <create+0x7a>
    iunlockput(dp);
    8000545e:	8526                	mv	a0,s1
    80005460:	b19fe0ef          	jal	80003f78 <iunlockput>
    ilock(ip);
    80005464:	8556                	mv	a0,s5
    80005466:	909fe0ef          	jal	80003d6e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000546a:	4789                	li	a5,2
    8000546c:	02fb1463          	bne	s6,a5,80005494 <create+0x70>
    80005470:	044ad783          	lhu	a5,68(s5)
    80005474:	37f9                	addiw	a5,a5,-2
    80005476:	17c2                	slli	a5,a5,0x30
    80005478:	93c1                	srli	a5,a5,0x30
    8000547a:	4705                	li	a4,1
    8000547c:	00f76c63          	bltu	a4,a5,80005494 <create+0x70>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80005480:	8556                	mv	a0,s5
    80005482:	60a6                	ld	ra,72(sp)
    80005484:	6406                	ld	s0,64(sp)
    80005486:	74e2                	ld	s1,56(sp)
    80005488:	7942                	ld	s2,48(sp)
    8000548a:	79a2                	ld	s3,40(sp)
    8000548c:	6ae2                	ld	s5,24(sp)
    8000548e:	6b42                	ld	s6,16(sp)
    80005490:	6161                	addi	sp,sp,80
    80005492:	8082                	ret
    iunlockput(ip);
    80005494:	8556                	mv	a0,s5
    80005496:	ae3fe0ef          	jal	80003f78 <iunlockput>
    return 0;
    8000549a:	4a81                	li	s5,0
    8000549c:	b7d5                	j	80005480 <create+0x5c>
    8000549e:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800054a0:	85da                	mv	a1,s6
    800054a2:	4088                	lw	a0,0(s1)
    800054a4:	f5afe0ef          	jal	80003bfe <ialloc>
    800054a8:	8a2a                	mv	s4,a0
    800054aa:	cd15                	beqz	a0,800054e6 <create+0xc2>
  ilock(ip);
    800054ac:	8c3fe0ef          	jal	80003d6e <ilock>
  ip->major = major;
    800054b0:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800054b4:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800054b8:	4905                	li	s2,1
    800054ba:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800054be:	8552                	mv	a0,s4
    800054c0:	ffafe0ef          	jal	80003cba <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800054c4:	032b0763          	beq	s6,s2,800054f2 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800054c8:	004a2603          	lw	a2,4(s4)
    800054cc:	fb040593          	addi	a1,s0,-80
    800054d0:	8526                	mv	a0,s1
    800054d2:	eddfe0ef          	jal	800043ae <dirlink>
    800054d6:	06054563          	bltz	a0,80005540 <create+0x11c>
  iunlockput(dp);
    800054da:	8526                	mv	a0,s1
    800054dc:	a9dfe0ef          	jal	80003f78 <iunlockput>
  return ip;
    800054e0:	8ad2                	mv	s5,s4
    800054e2:	7a02                	ld	s4,32(sp)
    800054e4:	bf71                	j	80005480 <create+0x5c>
    iunlockput(dp);
    800054e6:	8526                	mv	a0,s1
    800054e8:	a91fe0ef          	jal	80003f78 <iunlockput>
    return 0;
    800054ec:	8ad2                	mv	s5,s4
    800054ee:	7a02                	ld	s4,32(sp)
    800054f0:	bf41                	j	80005480 <create+0x5c>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800054f2:	004a2603          	lw	a2,4(s4)
    800054f6:	00003597          	auipc	a1,0x3
    800054fa:	24a58593          	addi	a1,a1,586 # 80008740 <etext+0x740>
    800054fe:	8552                	mv	a0,s4
    80005500:	eaffe0ef          	jal	800043ae <dirlink>
    80005504:	02054e63          	bltz	a0,80005540 <create+0x11c>
    80005508:	40d0                	lw	a2,4(s1)
    8000550a:	00003597          	auipc	a1,0x3
    8000550e:	23e58593          	addi	a1,a1,574 # 80008748 <etext+0x748>
    80005512:	8552                	mv	a0,s4
    80005514:	e9bfe0ef          	jal	800043ae <dirlink>
    80005518:	02054463          	bltz	a0,80005540 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000551c:	004a2603          	lw	a2,4(s4)
    80005520:	fb040593          	addi	a1,s0,-80
    80005524:	8526                	mv	a0,s1
    80005526:	e89fe0ef          	jal	800043ae <dirlink>
    8000552a:	00054b63          	bltz	a0,80005540 <create+0x11c>
    dp->nlink++;  // for ".."
    8000552e:	04a4d783          	lhu	a5,74(s1)
    80005532:	2785                	addiw	a5,a5,1
    80005534:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80005538:	8526                	mv	a0,s1
    8000553a:	f80fe0ef          	jal	80003cba <iupdate>
    8000553e:	bf71                	j	800054da <create+0xb6>
  ip->nlink = 0;
    80005540:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    80005544:	8552                	mv	a0,s4
    80005546:	f74fe0ef          	jal	80003cba <iupdate>
  iunlockput(ip);
    8000554a:	8552                	mv	a0,s4
    8000554c:	a2dfe0ef          	jal	80003f78 <iunlockput>
  iunlockput(dp);
    80005550:	8526                	mv	a0,s1
    80005552:	a27fe0ef          	jal	80003f78 <iunlockput>
  return 0;
    80005556:	7a02                	ld	s4,32(sp)
    80005558:	b725                	j	80005480 <create+0x5c>
    return 0;
    8000555a:	8aaa                	mv	s5,a0
    8000555c:	b715                	j	80005480 <create+0x5c>

000000008000555e <sys_dup>:
{
    8000555e:	7179                	addi	sp,sp,-48
    80005560:	f406                	sd	ra,40(sp)
    80005562:	f022                	sd	s0,32(sp)
    80005564:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005566:	fd840613          	addi	a2,s0,-40
    8000556a:	4581                	li	a1,0
    8000556c:	4501                	li	a0,0
    8000556e:	e21ff0ef          	jal	8000538e <argfd>
    return -1;
    80005572:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005574:	02054363          	bltz	a0,8000559a <sys_dup+0x3c>
    80005578:	ec26                	sd	s1,24(sp)
    8000557a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000557c:	fd843903          	ld	s2,-40(s0)
    80005580:	854a                	mv	a0,s2
    80005582:	e65ff0ef          	jal	800053e6 <fdalloc>
    80005586:	84aa                	mv	s1,a0
    return -1;
    80005588:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000558a:	00054d63          	bltz	a0,800055a4 <sys_dup+0x46>
  filedup(f);
    8000558e:	854a                	mv	a0,s2
    80005590:	c48ff0ef          	jal	800049d8 <filedup>
  return fd;
    80005594:	87a6                	mv	a5,s1
    80005596:	64e2                	ld	s1,24(sp)
    80005598:	6942                	ld	s2,16(sp)
}
    8000559a:	853e                	mv	a0,a5
    8000559c:	70a2                	ld	ra,40(sp)
    8000559e:	7402                	ld	s0,32(sp)
    800055a0:	6145                	addi	sp,sp,48
    800055a2:	8082                	ret
    800055a4:	64e2                	ld	s1,24(sp)
    800055a6:	6942                	ld	s2,16(sp)
    800055a8:	bfcd                	j	8000559a <sys_dup+0x3c>

00000000800055aa <sys_read>:
{
    800055aa:	7179                	addi	sp,sp,-48
    800055ac:	f406                	sd	ra,40(sp)
    800055ae:	f022                	sd	s0,32(sp)
    800055b0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800055b2:	fd840593          	addi	a1,s0,-40
    800055b6:	4505                	li	a0,1
    800055b8:	bfbfd0ef          	jal	800031b2 <argaddr>
  argint(2, &n);
    800055bc:	fe440593          	addi	a1,s0,-28
    800055c0:	4509                	li	a0,2
    800055c2:	bd3fd0ef          	jal	80003194 <argint>
  if(argfd(0, 0, &f) < 0)
    800055c6:	fe840613          	addi	a2,s0,-24
    800055ca:	4581                	li	a1,0
    800055cc:	4501                	li	a0,0
    800055ce:	dc1ff0ef          	jal	8000538e <argfd>
    800055d2:	87aa                	mv	a5,a0
    return -1;
    800055d4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800055d6:	0007ca63          	bltz	a5,800055ea <sys_read+0x40>
  return fileread(f, p, n);
    800055da:	fe442603          	lw	a2,-28(s0)
    800055de:	fd843583          	ld	a1,-40(s0)
    800055e2:	fe843503          	ld	a0,-24(s0)
    800055e6:	d58ff0ef          	jal	80004b3e <fileread>
}
    800055ea:	70a2                	ld	ra,40(sp)
    800055ec:	7402                	ld	s0,32(sp)
    800055ee:	6145                	addi	sp,sp,48
    800055f0:	8082                	ret

00000000800055f2 <sys_write>:
{
    800055f2:	7179                	addi	sp,sp,-48
    800055f4:	f406                	sd	ra,40(sp)
    800055f6:	f022                	sd	s0,32(sp)
    800055f8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800055fa:	fd840593          	addi	a1,s0,-40
    800055fe:	4505                	li	a0,1
    80005600:	bb3fd0ef          	jal	800031b2 <argaddr>
  argint(2, &n);
    80005604:	fe440593          	addi	a1,s0,-28
    80005608:	4509                	li	a0,2
    8000560a:	b8bfd0ef          	jal	80003194 <argint>
  if(argfd(0, 0, &f) < 0)
    8000560e:	fe840613          	addi	a2,s0,-24
    80005612:	4581                	li	a1,0
    80005614:	4501                	li	a0,0
    80005616:	d79ff0ef          	jal	8000538e <argfd>
    8000561a:	87aa                	mv	a5,a0
    return -1;
    8000561c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000561e:	0007ca63          	bltz	a5,80005632 <sys_write+0x40>
  return filewrite(f, p, n);
    80005622:	fe442603          	lw	a2,-28(s0)
    80005626:	fd843583          	ld	a1,-40(s0)
    8000562a:	fe843503          	ld	a0,-24(s0)
    8000562e:	dceff0ef          	jal	80004bfc <filewrite>
}
    80005632:	70a2                	ld	ra,40(sp)
    80005634:	7402                	ld	s0,32(sp)
    80005636:	6145                	addi	sp,sp,48
    80005638:	8082                	ret

000000008000563a <sys_close>:
{
    8000563a:	1101                	addi	sp,sp,-32
    8000563c:	ec06                	sd	ra,24(sp)
    8000563e:	e822                	sd	s0,16(sp)
    80005640:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80005642:	fe040613          	addi	a2,s0,-32
    80005646:	fec40593          	addi	a1,s0,-20
    8000564a:	4501                	li	a0,0
    8000564c:	d43ff0ef          	jal	8000538e <argfd>
    return -1;
    80005650:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005652:	02054063          	bltz	a0,80005672 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80005656:	9d9fc0ef          	jal	8000202e <myproc>
    8000565a:	fec42783          	lw	a5,-20(s0)
    8000565e:	07e9                	addi	a5,a5,26
    80005660:	078e                	slli	a5,a5,0x3
    80005662:	953e                	add	a0,a0,a5
    80005664:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80005668:	fe043503          	ld	a0,-32(s0)
    8000566c:	bb2ff0ef          	jal	80004a1e <fileclose>
  return 0;
    80005670:	4781                	li	a5,0
}
    80005672:	853e                	mv	a0,a5
    80005674:	60e2                	ld	ra,24(sp)
    80005676:	6442                	ld	s0,16(sp)
    80005678:	6105                	addi	sp,sp,32
    8000567a:	8082                	ret

000000008000567c <sys_fstat>:
{
    8000567c:	1101                	addi	sp,sp,-32
    8000567e:	ec06                	sd	ra,24(sp)
    80005680:	e822                	sd	s0,16(sp)
    80005682:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80005684:	fe040593          	addi	a1,s0,-32
    80005688:	4505                	li	a0,1
    8000568a:	b29fd0ef          	jal	800031b2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000568e:	fe840613          	addi	a2,s0,-24
    80005692:	4581                	li	a1,0
    80005694:	4501                	li	a0,0
    80005696:	cf9ff0ef          	jal	8000538e <argfd>
    8000569a:	87aa                	mv	a5,a0
    return -1;
    8000569c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000569e:	0007c863          	bltz	a5,800056ae <sys_fstat+0x32>
  return filestat(f, st);
    800056a2:	fe043583          	ld	a1,-32(s0)
    800056a6:	fe843503          	ld	a0,-24(s0)
    800056aa:	c36ff0ef          	jal	80004ae0 <filestat>
}
    800056ae:	60e2                	ld	ra,24(sp)
    800056b0:	6442                	ld	s0,16(sp)
    800056b2:	6105                	addi	sp,sp,32
    800056b4:	8082                	ret

00000000800056b6 <sys_link>:
{
    800056b6:	7169                	addi	sp,sp,-304
    800056b8:	f606                	sd	ra,296(sp)
    800056ba:	f222                	sd	s0,288(sp)
    800056bc:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056be:	08000613          	li	a2,128
    800056c2:	ed040593          	addi	a1,s0,-304
    800056c6:	4501                	li	a0,0
    800056c8:	b09fd0ef          	jal	800031d0 <argstr>
    return -1;
    800056cc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056ce:	0c054e63          	bltz	a0,800057aa <sys_link+0xf4>
    800056d2:	08000613          	li	a2,128
    800056d6:	f5040593          	addi	a1,s0,-176
    800056da:	4505                	li	a0,1
    800056dc:	af5fd0ef          	jal	800031d0 <argstr>
    return -1;
    800056e0:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800056e2:	0c054463          	bltz	a0,800057aa <sys_link+0xf4>
    800056e6:	ee26                	sd	s1,280(sp)
  begin_op();
    800056e8:	f1dfe0ef          	jal	80004604 <begin_op>
  if((ip = namei(old)) == 0){
    800056ec:	ed040513          	addi	a0,s0,-304
    800056f0:	d59fe0ef          	jal	80004448 <namei>
    800056f4:	84aa                	mv	s1,a0
    800056f6:	c53d                	beqz	a0,80005764 <sys_link+0xae>
  ilock(ip);
    800056f8:	e76fe0ef          	jal	80003d6e <ilock>
  if(ip->type == T_DIR){
    800056fc:	04449703          	lh	a4,68(s1)
    80005700:	4785                	li	a5,1
    80005702:	06f70663          	beq	a4,a5,8000576e <sys_link+0xb8>
    80005706:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80005708:	04a4d783          	lhu	a5,74(s1)
    8000570c:	2785                	addiw	a5,a5,1
    8000570e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005712:	8526                	mv	a0,s1
    80005714:	da6fe0ef          	jal	80003cba <iupdate>
  iunlock(ip);
    80005718:	8526                	mv	a0,s1
    8000571a:	f02fe0ef          	jal	80003e1c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000571e:	fd040593          	addi	a1,s0,-48
    80005722:	f5040513          	addi	a0,s0,-176
    80005726:	d3dfe0ef          	jal	80004462 <nameiparent>
    8000572a:	892a                	mv	s2,a0
    8000572c:	cd21                	beqz	a0,80005784 <sys_link+0xce>
  ilock(dp);
    8000572e:	e40fe0ef          	jal	80003d6e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005732:	00092703          	lw	a4,0(s2)
    80005736:	409c                	lw	a5,0(s1)
    80005738:	04f71363          	bne	a4,a5,8000577e <sys_link+0xc8>
    8000573c:	40d0                	lw	a2,4(s1)
    8000573e:	fd040593          	addi	a1,s0,-48
    80005742:	854a                	mv	a0,s2
    80005744:	c6bfe0ef          	jal	800043ae <dirlink>
    80005748:	02054b63          	bltz	a0,8000577e <sys_link+0xc8>
  iunlockput(dp);
    8000574c:	854a                	mv	a0,s2
    8000574e:	82bfe0ef          	jal	80003f78 <iunlockput>
  iput(ip);
    80005752:	8526                	mv	a0,s1
    80005754:	f9cfe0ef          	jal	80003ef0 <iput>
  end_op();
    80005758:	f17fe0ef          	jal	8000466e <end_op>
  return 0;
    8000575c:	4781                	li	a5,0
    8000575e:	64f2                	ld	s1,280(sp)
    80005760:	6952                	ld	s2,272(sp)
    80005762:	a0a1                	j	800057aa <sys_link+0xf4>
    end_op();
    80005764:	f0bfe0ef          	jal	8000466e <end_op>
    return -1;
    80005768:	57fd                	li	a5,-1
    8000576a:	64f2                	ld	s1,280(sp)
    8000576c:	a83d                	j	800057aa <sys_link+0xf4>
    iunlockput(ip);
    8000576e:	8526                	mv	a0,s1
    80005770:	809fe0ef          	jal	80003f78 <iunlockput>
    end_op();
    80005774:	efbfe0ef          	jal	8000466e <end_op>
    return -1;
    80005778:	57fd                	li	a5,-1
    8000577a:	64f2                	ld	s1,280(sp)
    8000577c:	a03d                	j	800057aa <sys_link+0xf4>
    iunlockput(dp);
    8000577e:	854a                	mv	a0,s2
    80005780:	ff8fe0ef          	jal	80003f78 <iunlockput>
  ilock(ip);
    80005784:	8526                	mv	a0,s1
    80005786:	de8fe0ef          	jal	80003d6e <ilock>
  ip->nlink--;
    8000578a:	04a4d783          	lhu	a5,74(s1)
    8000578e:	37fd                	addiw	a5,a5,-1
    80005790:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80005794:	8526                	mv	a0,s1
    80005796:	d24fe0ef          	jal	80003cba <iupdate>
  iunlockput(ip);
    8000579a:	8526                	mv	a0,s1
    8000579c:	fdcfe0ef          	jal	80003f78 <iunlockput>
  end_op();
    800057a0:	ecffe0ef          	jal	8000466e <end_op>
  return -1;
    800057a4:	57fd                	li	a5,-1
    800057a6:	64f2                	ld	s1,280(sp)
    800057a8:	6952                	ld	s2,272(sp)
}
    800057aa:	853e                	mv	a0,a5
    800057ac:	70b2                	ld	ra,296(sp)
    800057ae:	7412                	ld	s0,288(sp)
    800057b0:	6155                	addi	sp,sp,304
    800057b2:	8082                	ret

00000000800057b4 <sys_unlink>:
{
    800057b4:	7151                	addi	sp,sp,-240
    800057b6:	f586                	sd	ra,232(sp)
    800057b8:	f1a2                	sd	s0,224(sp)
    800057ba:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800057bc:	08000613          	li	a2,128
    800057c0:	f3040593          	addi	a1,s0,-208
    800057c4:	4501                	li	a0,0
    800057c6:	a0bfd0ef          	jal	800031d0 <argstr>
    800057ca:	16054063          	bltz	a0,8000592a <sys_unlink+0x176>
    800057ce:	eda6                	sd	s1,216(sp)
  begin_op();
    800057d0:	e35fe0ef          	jal	80004604 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800057d4:	fb040593          	addi	a1,s0,-80
    800057d8:	f3040513          	addi	a0,s0,-208
    800057dc:	c87fe0ef          	jal	80004462 <nameiparent>
    800057e0:	84aa                	mv	s1,a0
    800057e2:	c945                	beqz	a0,80005892 <sys_unlink+0xde>
  ilock(dp);
    800057e4:	d8afe0ef          	jal	80003d6e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800057e8:	00003597          	auipc	a1,0x3
    800057ec:	f5858593          	addi	a1,a1,-168 # 80008740 <etext+0x740>
    800057f0:	fb040513          	addi	a0,s0,-80
    800057f4:	9d9fe0ef          	jal	800041cc <namecmp>
    800057f8:	10050e63          	beqz	a0,80005914 <sys_unlink+0x160>
    800057fc:	00003597          	auipc	a1,0x3
    80005800:	f4c58593          	addi	a1,a1,-180 # 80008748 <etext+0x748>
    80005804:	fb040513          	addi	a0,s0,-80
    80005808:	9c5fe0ef          	jal	800041cc <namecmp>
    8000580c:	10050463          	beqz	a0,80005914 <sys_unlink+0x160>
    80005810:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80005812:	f2c40613          	addi	a2,s0,-212
    80005816:	fb040593          	addi	a1,s0,-80
    8000581a:	8526                	mv	a0,s1
    8000581c:	9c7fe0ef          	jal	800041e2 <dirlookup>
    80005820:	892a                	mv	s2,a0
    80005822:	0e050863          	beqz	a0,80005912 <sys_unlink+0x15e>
  ilock(ip);
    80005826:	d48fe0ef          	jal	80003d6e <ilock>
  if(ip->nlink < 1)
    8000582a:	04a91783          	lh	a5,74(s2)
    8000582e:	06f05763          	blez	a5,8000589c <sys_unlink+0xe8>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80005832:	04491703          	lh	a4,68(s2)
    80005836:	4785                	li	a5,1
    80005838:	06f70963          	beq	a4,a5,800058aa <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    8000583c:	4641                	li	a2,16
    8000583e:	4581                	li	a1,0
    80005840:	fc040513          	addi	a0,s0,-64
    80005844:	ce8fb0ef          	jal	80000d2c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005848:	4741                	li	a4,16
    8000584a:	f2c42683          	lw	a3,-212(s0)
    8000584e:	fc040613          	addi	a2,s0,-64
    80005852:	4581                	li	a1,0
    80005854:	8526                	mv	a0,s1
    80005856:	869fe0ef          	jal	800040be <writei>
    8000585a:	47c1                	li	a5,16
    8000585c:	08f51b63          	bne	a0,a5,800058f2 <sys_unlink+0x13e>
  if(ip->type == T_DIR){
    80005860:	04491703          	lh	a4,68(s2)
    80005864:	4785                	li	a5,1
    80005866:	08f70d63          	beq	a4,a5,80005900 <sys_unlink+0x14c>
  iunlockput(dp);
    8000586a:	8526                	mv	a0,s1
    8000586c:	f0cfe0ef          	jal	80003f78 <iunlockput>
  ip->nlink--;
    80005870:	04a95783          	lhu	a5,74(s2)
    80005874:	37fd                	addiw	a5,a5,-1
    80005876:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000587a:	854a                	mv	a0,s2
    8000587c:	c3efe0ef          	jal	80003cba <iupdate>
  iunlockput(ip);
    80005880:	854a                	mv	a0,s2
    80005882:	ef6fe0ef          	jal	80003f78 <iunlockput>
  end_op();
    80005886:	de9fe0ef          	jal	8000466e <end_op>
  return 0;
    8000588a:	4501                	li	a0,0
    8000588c:	64ee                	ld	s1,216(sp)
    8000588e:	694e                	ld	s2,208(sp)
    80005890:	a849                	j	80005922 <sys_unlink+0x16e>
    end_op();
    80005892:	dddfe0ef          	jal	8000466e <end_op>
    return -1;
    80005896:	557d                	li	a0,-1
    80005898:	64ee                	ld	s1,216(sp)
    8000589a:	a061                	j	80005922 <sys_unlink+0x16e>
    8000589c:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    8000589e:	00003517          	auipc	a0,0x3
    800058a2:	eb250513          	addi	a0,a0,-334 # 80008750 <etext+0x750>
    800058a6:	f53fa0ef          	jal	800007f8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058aa:	04c92703          	lw	a4,76(s2)
    800058ae:	02000793          	li	a5,32
    800058b2:	f8e7f5e3          	bgeu	a5,a4,8000583c <sys_unlink+0x88>
    800058b6:	e5ce                	sd	s3,200(sp)
    800058b8:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800058bc:	4741                	li	a4,16
    800058be:	86ce                	mv	a3,s3
    800058c0:	f1840613          	addi	a2,s0,-232
    800058c4:	4581                	li	a1,0
    800058c6:	854a                	mv	a0,s2
    800058c8:	efafe0ef          	jal	80003fc2 <readi>
    800058cc:	47c1                	li	a5,16
    800058ce:	00f51c63          	bne	a0,a5,800058e6 <sys_unlink+0x132>
    if(de.inum != 0)
    800058d2:	f1845783          	lhu	a5,-232(s0)
    800058d6:	efa1                	bnez	a5,8000592e <sys_unlink+0x17a>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800058d8:	29c1                	addiw	s3,s3,16
    800058da:	04c92783          	lw	a5,76(s2)
    800058de:	fcf9efe3          	bltu	s3,a5,800058bc <sys_unlink+0x108>
    800058e2:	69ae                	ld	s3,200(sp)
    800058e4:	bfa1                	j	8000583c <sys_unlink+0x88>
      panic("isdirempty: readi");
    800058e6:	00003517          	auipc	a0,0x3
    800058ea:	e8250513          	addi	a0,a0,-382 # 80008768 <etext+0x768>
    800058ee:	f0bfa0ef          	jal	800007f8 <panic>
    800058f2:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    800058f4:	00003517          	auipc	a0,0x3
    800058f8:	e8c50513          	addi	a0,a0,-372 # 80008780 <etext+0x780>
    800058fc:	efdfa0ef          	jal	800007f8 <panic>
    dp->nlink--;
    80005900:	04a4d783          	lhu	a5,74(s1)
    80005904:	37fd                	addiw	a5,a5,-1
    80005906:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000590a:	8526                	mv	a0,s1
    8000590c:	baefe0ef          	jal	80003cba <iupdate>
    80005910:	bfa9                	j	8000586a <sys_unlink+0xb6>
    80005912:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80005914:	8526                	mv	a0,s1
    80005916:	e62fe0ef          	jal	80003f78 <iunlockput>
  end_op();
    8000591a:	d55fe0ef          	jal	8000466e <end_op>
  return -1;
    8000591e:	557d                	li	a0,-1
    80005920:	64ee                	ld	s1,216(sp)
}
    80005922:	70ae                	ld	ra,232(sp)
    80005924:	740e                	ld	s0,224(sp)
    80005926:	616d                	addi	sp,sp,240
    80005928:	8082                	ret
    return -1;
    8000592a:	557d                	li	a0,-1
    8000592c:	bfdd                	j	80005922 <sys_unlink+0x16e>
    iunlockput(ip);
    8000592e:	854a                	mv	a0,s2
    80005930:	e48fe0ef          	jal	80003f78 <iunlockput>
    goto bad;
    80005934:	694e                	ld	s2,208(sp)
    80005936:	69ae                	ld	s3,200(sp)
    80005938:	bff1                	j	80005914 <sys_unlink+0x160>

000000008000593a <sys_open>:

uint64
sys_open(void)
{
    8000593a:	7131                	addi	sp,sp,-192
    8000593c:	fd06                	sd	ra,184(sp)
    8000593e:	f922                	sd	s0,176(sp)
    80005940:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005942:	f4c40593          	addi	a1,s0,-180
    80005946:	4505                	li	a0,1
    80005948:	84dfd0ef          	jal	80003194 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000594c:	08000613          	li	a2,128
    80005950:	f5040593          	addi	a1,s0,-176
    80005954:	4501                	li	a0,0
    80005956:	87bfd0ef          	jal	800031d0 <argstr>
    8000595a:	87aa                	mv	a5,a0
    return -1;
    8000595c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000595e:	0a07c263          	bltz	a5,80005a02 <sys_open+0xc8>
    80005962:	f526                	sd	s1,168(sp)

  begin_op();
    80005964:	ca1fe0ef          	jal	80004604 <begin_op>

  if(omode & O_CREATE){
    80005968:	f4c42783          	lw	a5,-180(s0)
    8000596c:	2007f793          	andi	a5,a5,512
    80005970:	c3d5                	beqz	a5,80005a14 <sys_open+0xda>
    ip = create(path, T_FILE, 0, 0);
    80005972:	4681                	li	a3,0
    80005974:	4601                	li	a2,0
    80005976:	4589                	li	a1,2
    80005978:	f5040513          	addi	a0,s0,-176
    8000597c:	aa9ff0ef          	jal	80005424 <create>
    80005980:	84aa                	mv	s1,a0
    if(ip == 0){
    80005982:	c541                	beqz	a0,80005a0a <sys_open+0xd0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005984:	04449703          	lh	a4,68(s1)
    80005988:	478d                	li	a5,3
    8000598a:	00f71763          	bne	a4,a5,80005998 <sys_open+0x5e>
    8000598e:	0464d703          	lhu	a4,70(s1)
    80005992:	47a5                	li	a5,9
    80005994:	0ae7ed63          	bltu	a5,a4,80005a4e <sys_open+0x114>
    80005998:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    8000599a:	fe1fe0ef          	jal	8000497a <filealloc>
    8000599e:	892a                	mv	s2,a0
    800059a0:	c179                	beqz	a0,80005a66 <sys_open+0x12c>
    800059a2:	ed4e                	sd	s3,152(sp)
    800059a4:	a43ff0ef          	jal	800053e6 <fdalloc>
    800059a8:	89aa                	mv	s3,a0
    800059aa:	0a054a63          	bltz	a0,80005a5e <sys_open+0x124>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800059ae:	04449703          	lh	a4,68(s1)
    800059b2:	478d                	li	a5,3
    800059b4:	0cf70263          	beq	a4,a5,80005a78 <sys_open+0x13e>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800059b8:	4789                	li	a5,2
    800059ba:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800059be:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800059c2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800059c6:	f4c42783          	lw	a5,-180(s0)
    800059ca:	0017c713          	xori	a4,a5,1
    800059ce:	8b05                	andi	a4,a4,1
    800059d0:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059d4:	0037f713          	andi	a4,a5,3
    800059d8:	00e03733          	snez	a4,a4
    800059dc:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800059e0:	4007f793          	andi	a5,a5,1024
    800059e4:	c791                	beqz	a5,800059f0 <sys_open+0xb6>
    800059e6:	04449703          	lh	a4,68(s1)
    800059ea:	4789                	li	a5,2
    800059ec:	08f70d63          	beq	a4,a5,80005a86 <sys_open+0x14c>
    itrunc(ip);
  }

  iunlock(ip);
    800059f0:	8526                	mv	a0,s1
    800059f2:	c2afe0ef          	jal	80003e1c <iunlock>
  end_op();
    800059f6:	c79fe0ef          	jal	8000466e <end_op>

  return fd;
    800059fa:	854e                	mv	a0,s3
    800059fc:	74aa                	ld	s1,168(sp)
    800059fe:	790a                	ld	s2,160(sp)
    80005a00:	69ea                	ld	s3,152(sp)
}
    80005a02:	70ea                	ld	ra,184(sp)
    80005a04:	744a                	ld	s0,176(sp)
    80005a06:	6129                	addi	sp,sp,192
    80005a08:	8082                	ret
      end_op();
    80005a0a:	c65fe0ef          	jal	8000466e <end_op>
      return -1;
    80005a0e:	557d                	li	a0,-1
    80005a10:	74aa                	ld	s1,168(sp)
    80005a12:	bfc5                	j	80005a02 <sys_open+0xc8>
    if((ip = namei(path)) == 0){
    80005a14:	f5040513          	addi	a0,s0,-176
    80005a18:	a31fe0ef          	jal	80004448 <namei>
    80005a1c:	84aa                	mv	s1,a0
    80005a1e:	c11d                	beqz	a0,80005a44 <sys_open+0x10a>
    ilock(ip);
    80005a20:	b4efe0ef          	jal	80003d6e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a24:	04449703          	lh	a4,68(s1)
    80005a28:	4785                	li	a5,1
    80005a2a:	f4f71de3          	bne	a4,a5,80005984 <sys_open+0x4a>
    80005a2e:	f4c42783          	lw	a5,-180(s0)
    80005a32:	d3bd                	beqz	a5,80005998 <sys_open+0x5e>
      iunlockput(ip);
    80005a34:	8526                	mv	a0,s1
    80005a36:	d42fe0ef          	jal	80003f78 <iunlockput>
      end_op();
    80005a3a:	c35fe0ef          	jal	8000466e <end_op>
      return -1;
    80005a3e:	557d                	li	a0,-1
    80005a40:	74aa                	ld	s1,168(sp)
    80005a42:	b7c1                	j	80005a02 <sys_open+0xc8>
      end_op();
    80005a44:	c2bfe0ef          	jal	8000466e <end_op>
      return -1;
    80005a48:	557d                	li	a0,-1
    80005a4a:	74aa                	ld	s1,168(sp)
    80005a4c:	bf5d                	j	80005a02 <sys_open+0xc8>
    iunlockput(ip);
    80005a4e:	8526                	mv	a0,s1
    80005a50:	d28fe0ef          	jal	80003f78 <iunlockput>
    end_op();
    80005a54:	c1bfe0ef          	jal	8000466e <end_op>
    return -1;
    80005a58:	557d                	li	a0,-1
    80005a5a:	74aa                	ld	s1,168(sp)
    80005a5c:	b75d                	j	80005a02 <sys_open+0xc8>
      fileclose(f);
    80005a5e:	854a                	mv	a0,s2
    80005a60:	fbffe0ef          	jal	80004a1e <fileclose>
    80005a64:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005a66:	8526                	mv	a0,s1
    80005a68:	d10fe0ef          	jal	80003f78 <iunlockput>
    end_op();
    80005a6c:	c03fe0ef          	jal	8000466e <end_op>
    return -1;
    80005a70:	557d                	li	a0,-1
    80005a72:	74aa                	ld	s1,168(sp)
    80005a74:	790a                	ld	s2,160(sp)
    80005a76:	b771                	j	80005a02 <sys_open+0xc8>
    f->type = FD_DEVICE;
    80005a78:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80005a7c:	04649783          	lh	a5,70(s1)
    80005a80:	02f91223          	sh	a5,36(s2)
    80005a84:	bf3d                	j	800059c2 <sys_open+0x88>
    itrunc(ip);
    80005a86:	8526                	mv	a0,s1
    80005a88:	bd4fe0ef          	jal	80003e5c <itrunc>
    80005a8c:	b795                	j	800059f0 <sys_open+0xb6>

0000000080005a8e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005a8e:	7175                	addi	sp,sp,-144
    80005a90:	e506                	sd	ra,136(sp)
    80005a92:	e122                	sd	s0,128(sp)
    80005a94:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80005a96:	b6ffe0ef          	jal	80004604 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005a9a:	08000613          	li	a2,128
    80005a9e:	f7040593          	addi	a1,s0,-144
    80005aa2:	4501                	li	a0,0
    80005aa4:	f2cfd0ef          	jal	800031d0 <argstr>
    80005aa8:	02054363          	bltz	a0,80005ace <sys_mkdir+0x40>
    80005aac:	4681                	li	a3,0
    80005aae:	4601                	li	a2,0
    80005ab0:	4585                	li	a1,1
    80005ab2:	f7040513          	addi	a0,s0,-144
    80005ab6:	96fff0ef          	jal	80005424 <create>
    80005aba:	c911                	beqz	a0,80005ace <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005abc:	cbcfe0ef          	jal	80003f78 <iunlockput>
  end_op();
    80005ac0:	baffe0ef          	jal	8000466e <end_op>
  return 0;
    80005ac4:	4501                	li	a0,0
}
    80005ac6:	60aa                	ld	ra,136(sp)
    80005ac8:	640a                	ld	s0,128(sp)
    80005aca:	6149                	addi	sp,sp,144
    80005acc:	8082                	ret
    end_op();
    80005ace:	ba1fe0ef          	jal	8000466e <end_op>
    return -1;
    80005ad2:	557d                	li	a0,-1
    80005ad4:	bfcd                	j	80005ac6 <sys_mkdir+0x38>

0000000080005ad6 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005ad6:	7135                	addi	sp,sp,-160
    80005ad8:	ed06                	sd	ra,152(sp)
    80005ada:	e922                	sd	s0,144(sp)
    80005adc:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005ade:	b27fe0ef          	jal	80004604 <begin_op>
  argint(1, &major);
    80005ae2:	f6c40593          	addi	a1,s0,-148
    80005ae6:	4505                	li	a0,1
    80005ae8:	eacfd0ef          	jal	80003194 <argint>
  argint(2, &minor);
    80005aec:	f6840593          	addi	a1,s0,-152
    80005af0:	4509                	li	a0,2
    80005af2:	ea2fd0ef          	jal	80003194 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005af6:	08000613          	li	a2,128
    80005afa:	f7040593          	addi	a1,s0,-144
    80005afe:	4501                	li	a0,0
    80005b00:	ed0fd0ef          	jal	800031d0 <argstr>
    80005b04:	02054563          	bltz	a0,80005b2e <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b08:	f6841683          	lh	a3,-152(s0)
    80005b0c:	f6c41603          	lh	a2,-148(s0)
    80005b10:	458d                	li	a1,3
    80005b12:	f7040513          	addi	a0,s0,-144
    80005b16:	90fff0ef          	jal	80005424 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b1a:	c911                	beqz	a0,80005b2e <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005b1c:	c5cfe0ef          	jal	80003f78 <iunlockput>
  end_op();
    80005b20:	b4ffe0ef          	jal	8000466e <end_op>
  return 0;
    80005b24:	4501                	li	a0,0
}
    80005b26:	60ea                	ld	ra,152(sp)
    80005b28:	644a                	ld	s0,144(sp)
    80005b2a:	610d                	addi	sp,sp,160
    80005b2c:	8082                	ret
    end_op();
    80005b2e:	b41fe0ef          	jal	8000466e <end_op>
    return -1;
    80005b32:	557d                	li	a0,-1
    80005b34:	bfcd                	j	80005b26 <sys_mknod+0x50>

0000000080005b36 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005b36:	7135                	addi	sp,sp,-160
    80005b38:	ed06                	sd	ra,152(sp)
    80005b3a:	e922                	sd	s0,144(sp)
    80005b3c:	e14a                	sd	s2,128(sp)
    80005b3e:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005b40:	ceefc0ef          	jal	8000202e <myproc>
    80005b44:	892a                	mv	s2,a0
  
  begin_op();
    80005b46:	abffe0ef          	jal	80004604 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005b4a:	08000613          	li	a2,128
    80005b4e:	f6040593          	addi	a1,s0,-160
    80005b52:	4501                	li	a0,0
    80005b54:	e7cfd0ef          	jal	800031d0 <argstr>
    80005b58:	04054363          	bltz	a0,80005b9e <sys_chdir+0x68>
    80005b5c:	e526                	sd	s1,136(sp)
    80005b5e:	f6040513          	addi	a0,s0,-160
    80005b62:	8e7fe0ef          	jal	80004448 <namei>
    80005b66:	84aa                	mv	s1,a0
    80005b68:	c915                	beqz	a0,80005b9c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80005b6a:	a04fe0ef          	jal	80003d6e <ilock>
  if(ip->type != T_DIR){
    80005b6e:	04449703          	lh	a4,68(s1)
    80005b72:	4785                	li	a5,1
    80005b74:	02f71963          	bne	a4,a5,80005ba6 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80005b78:	8526                	mv	a0,s1
    80005b7a:	aa2fe0ef          	jal	80003e1c <iunlock>
  iput(p->cwd);
    80005b7e:	15893503          	ld	a0,344(s2)
    80005b82:	b6efe0ef          	jal	80003ef0 <iput>
  end_op();
    80005b86:	ae9fe0ef          	jal	8000466e <end_op>
  p->cwd = ip;
    80005b8a:	14993c23          	sd	s1,344(s2)
  return 0;
    80005b8e:	4501                	li	a0,0
    80005b90:	64aa                	ld	s1,136(sp)
}
    80005b92:	60ea                	ld	ra,152(sp)
    80005b94:	644a                	ld	s0,144(sp)
    80005b96:	690a                	ld	s2,128(sp)
    80005b98:	610d                	addi	sp,sp,160
    80005b9a:	8082                	ret
    80005b9c:	64aa                	ld	s1,136(sp)
    end_op();
    80005b9e:	ad1fe0ef          	jal	8000466e <end_op>
    return -1;
    80005ba2:	557d                	li	a0,-1
    80005ba4:	b7fd                	j	80005b92 <sys_chdir+0x5c>
    iunlockput(ip);
    80005ba6:	8526                	mv	a0,s1
    80005ba8:	bd0fe0ef          	jal	80003f78 <iunlockput>
    end_op();
    80005bac:	ac3fe0ef          	jal	8000466e <end_op>
    return -1;
    80005bb0:	557d                	li	a0,-1
    80005bb2:	64aa                	ld	s1,136(sp)
    80005bb4:	bff9                	j	80005b92 <sys_chdir+0x5c>

0000000080005bb6 <sys_exec>:

uint64
sys_exec(void)
{
    80005bb6:	7121                	addi	sp,sp,-448
    80005bb8:	ff06                	sd	ra,440(sp)
    80005bba:	fb22                	sd	s0,432(sp)
    80005bbc:	0380                	addi	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005bbe:	e4840593          	addi	a1,s0,-440
    80005bc2:	4505                	li	a0,1
    80005bc4:	deefd0ef          	jal	800031b2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80005bc8:	08000613          	li	a2,128
    80005bcc:	f5040593          	addi	a1,s0,-176
    80005bd0:	4501                	li	a0,0
    80005bd2:	dfefd0ef          	jal	800031d0 <argstr>
    80005bd6:	87aa                	mv	a5,a0
    return -1;
    80005bd8:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80005bda:	0c07c463          	bltz	a5,80005ca2 <sys_exec+0xec>
    80005bde:	f726                	sd	s1,424(sp)
    80005be0:	f34a                	sd	s2,416(sp)
    80005be2:	ef4e                	sd	s3,408(sp)
    80005be4:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    80005be6:	10000613          	li	a2,256
    80005bea:	4581                	li	a1,0
    80005bec:	e5040513          	addi	a0,s0,-432
    80005bf0:	93cfb0ef          	jal	80000d2c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005bf4:	e5040493          	addi	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80005bf8:	89a6                	mv	s3,s1
    80005bfa:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80005bfc:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005c00:	00391513          	slli	a0,s2,0x3
    80005c04:	e4040593          	addi	a1,s0,-448
    80005c08:	e4843783          	ld	a5,-440(s0)
    80005c0c:	953e                	add	a0,a0,a5
    80005c0e:	cfcfd0ef          	jal	8000310a <fetchaddr>
    80005c12:	02054663          	bltz	a0,80005c3e <sys_exec+0x88>
      goto bad;
    }
    if(uarg == 0){
    80005c16:	e4043783          	ld	a5,-448(s0)
    80005c1a:	c3a9                	beqz	a5,80005c5c <sys_exec+0xa6>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005c1c:	f6dfa0ef          	jal	80000b88 <kalloc>
    80005c20:	85aa                	mv	a1,a0
    80005c22:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005c26:	cd01                	beqz	a0,80005c3e <sys_exec+0x88>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005c28:	6605                	lui	a2,0x1
    80005c2a:	e4043503          	ld	a0,-448(s0)
    80005c2e:	d26fd0ef          	jal	80003154 <fetchstr>
    80005c32:	00054663          	bltz	a0,80005c3e <sys_exec+0x88>
    if(i >= NELEM(argv)){
    80005c36:	0905                	addi	s2,s2,1
    80005c38:	09a1                	addi	s3,s3,8
    80005c3a:	fd4913e3          	bne	s2,s4,80005c00 <sys_exec+0x4a>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c3e:	f5040913          	addi	s2,s0,-176
    80005c42:	6088                	ld	a0,0(s1)
    80005c44:	c931                	beqz	a0,80005c98 <sys_exec+0xe2>
    kfree(argv[i]);
    80005c46:	e61fa0ef          	jal	80000aa6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c4a:	04a1                	addi	s1,s1,8
    80005c4c:	ff249be3          	bne	s1,s2,80005c42 <sys_exec+0x8c>
  return -1;
    80005c50:	557d                	li	a0,-1
    80005c52:	74ba                	ld	s1,424(sp)
    80005c54:	791a                	ld	s2,416(sp)
    80005c56:	69fa                	ld	s3,408(sp)
    80005c58:	6a5a                	ld	s4,400(sp)
    80005c5a:	a0a1                	j	80005ca2 <sys_exec+0xec>
      argv[i] = 0;
    80005c5c:	0009079b          	sext.w	a5,s2
    80005c60:	078e                	slli	a5,a5,0x3
    80005c62:	fd078793          	addi	a5,a5,-48
    80005c66:	97a2                	add	a5,a5,s0
    80005c68:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80005c6c:	e5040593          	addi	a1,s0,-432
    80005c70:	f5040513          	addi	a0,s0,-176
    80005c74:	ba8ff0ef          	jal	8000501c <exec>
    80005c78:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c7a:	f5040993          	addi	s3,s0,-176
    80005c7e:	6088                	ld	a0,0(s1)
    80005c80:	c511                	beqz	a0,80005c8c <sys_exec+0xd6>
    kfree(argv[i]);
    80005c82:	e25fa0ef          	jal	80000aa6 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005c86:	04a1                	addi	s1,s1,8
    80005c88:	ff349be3          	bne	s1,s3,80005c7e <sys_exec+0xc8>
  return ret;
    80005c8c:	854a                	mv	a0,s2
    80005c8e:	74ba                	ld	s1,424(sp)
    80005c90:	791a                	ld	s2,416(sp)
    80005c92:	69fa                	ld	s3,408(sp)
    80005c94:	6a5a                	ld	s4,400(sp)
    80005c96:	a031                	j	80005ca2 <sys_exec+0xec>
  return -1;
    80005c98:	557d                	li	a0,-1
    80005c9a:	74ba                	ld	s1,424(sp)
    80005c9c:	791a                	ld	s2,416(sp)
    80005c9e:	69fa                	ld	s3,408(sp)
    80005ca0:	6a5a                	ld	s4,400(sp)
}
    80005ca2:	70fa                	ld	ra,440(sp)
    80005ca4:	745a                	ld	s0,432(sp)
    80005ca6:	6139                	addi	sp,sp,448
    80005ca8:	8082                	ret

0000000080005caa <sys_pipe>:

uint64
sys_pipe(void)
{
    80005caa:	7139                	addi	sp,sp,-64
    80005cac:	fc06                	sd	ra,56(sp)
    80005cae:	f822                	sd	s0,48(sp)
    80005cb0:	f426                	sd	s1,40(sp)
    80005cb2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005cb4:	b7afc0ef          	jal	8000202e <myproc>
    80005cb8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005cba:	fd840593          	addi	a1,s0,-40
    80005cbe:	4501                	li	a0,0
    80005cc0:	cf2fd0ef          	jal	800031b2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80005cc4:	fc840593          	addi	a1,s0,-56
    80005cc8:	fd040513          	addi	a0,s0,-48
    80005ccc:	85cff0ef          	jal	80004d28 <pipealloc>
    return -1;
    80005cd0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005cd2:	0a054463          	bltz	a0,80005d7a <sys_pipe+0xd0>
  fd0 = -1;
    80005cd6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005cda:	fd043503          	ld	a0,-48(s0)
    80005cde:	f08ff0ef          	jal	800053e6 <fdalloc>
    80005ce2:	fca42223          	sw	a0,-60(s0)
    80005ce6:	08054163          	bltz	a0,80005d68 <sys_pipe+0xbe>
    80005cea:	fc843503          	ld	a0,-56(s0)
    80005cee:	ef8ff0ef          	jal	800053e6 <fdalloc>
    80005cf2:	fca42023          	sw	a0,-64(s0)
    80005cf6:	06054063          	bltz	a0,80005d56 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005cfa:	4691                	li	a3,4
    80005cfc:	fc440613          	addi	a2,s0,-60
    80005d00:	fd843583          	ld	a1,-40(s0)
    80005d04:	6ca8                	ld	a0,88(s1)
    80005d06:	f77fb0ef          	jal	80001c7c <copyout>
    80005d0a:	00054e63          	bltz	a0,80005d26 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005d0e:	4691                	li	a3,4
    80005d10:	fc040613          	addi	a2,s0,-64
    80005d14:	fd843583          	ld	a1,-40(s0)
    80005d18:	0591                	addi	a1,a1,4
    80005d1a:	6ca8                	ld	a0,88(s1)
    80005d1c:	f61fb0ef          	jal	80001c7c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005d20:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005d22:	04055c63          	bgez	a0,80005d7a <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005d26:	fc442783          	lw	a5,-60(s0)
    80005d2a:	07e9                	addi	a5,a5,26
    80005d2c:	078e                	slli	a5,a5,0x3
    80005d2e:	97a6                	add	a5,a5,s1
    80005d30:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005d34:	fc042783          	lw	a5,-64(s0)
    80005d38:	07e9                	addi	a5,a5,26
    80005d3a:	078e                	slli	a5,a5,0x3
    80005d3c:	94be                	add	s1,s1,a5
    80005d3e:	0004b423          	sd	zero,8(s1)
    fileclose(rf);
    80005d42:	fd043503          	ld	a0,-48(s0)
    80005d46:	cd9fe0ef          	jal	80004a1e <fileclose>
    fileclose(wf);
    80005d4a:	fc843503          	ld	a0,-56(s0)
    80005d4e:	cd1fe0ef          	jal	80004a1e <fileclose>
    return -1;
    80005d52:	57fd                	li	a5,-1
    80005d54:	a01d                	j	80005d7a <sys_pipe+0xd0>
    if(fd0 >= 0)
    80005d56:	fc442783          	lw	a5,-60(s0)
    80005d5a:	0007c763          	bltz	a5,80005d68 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005d5e:	07e9                	addi	a5,a5,26
    80005d60:	078e                	slli	a5,a5,0x3
    80005d62:	97a6                	add	a5,a5,s1
    80005d64:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80005d68:	fd043503          	ld	a0,-48(s0)
    80005d6c:	cb3fe0ef          	jal	80004a1e <fileclose>
    fileclose(wf);
    80005d70:	fc843503          	ld	a0,-56(s0)
    80005d74:	cabfe0ef          	jal	80004a1e <fileclose>
    return -1;
    80005d78:	57fd                	li	a5,-1
}
    80005d7a:	853e                	mv	a0,a5
    80005d7c:	70e2                	ld	ra,56(sp)
    80005d7e:	7442                	ld	s0,48(sp)
    80005d80:	74a2                	ld	s1,40(sp)
    80005d82:	6121                	addi	sp,sp,64
    80005d84:	8082                	ret
	...

0000000080005d90 <kernelvec>:
    80005d90:	7111                	addi	sp,sp,-256
    80005d92:	e006                	sd	ra,0(sp)
    80005d94:	e40a                	sd	sp,8(sp)
    80005d96:	e80e                	sd	gp,16(sp)
    80005d98:	ec12                	sd	tp,24(sp)
    80005d9a:	f016                	sd	t0,32(sp)
    80005d9c:	f41a                	sd	t1,40(sp)
    80005d9e:	f81e                	sd	t2,48(sp)
    80005da0:	e4aa                	sd	a0,72(sp)
    80005da2:	e8ae                	sd	a1,80(sp)
    80005da4:	ecb2                	sd	a2,88(sp)
    80005da6:	f0b6                	sd	a3,96(sp)
    80005da8:	f4ba                	sd	a4,104(sp)
    80005daa:	f8be                	sd	a5,112(sp)
    80005dac:	fcc2                	sd	a6,120(sp)
    80005dae:	e146                	sd	a7,128(sp)
    80005db0:	edf2                	sd	t3,216(sp)
    80005db2:	f1f6                	sd	t4,224(sp)
    80005db4:	f5fa                	sd	t5,232(sp)
    80005db6:	f9fe                	sd	t6,240(sp)
    80005db8:	a62fd0ef          	jal	8000301a <kerneltrap>
    80005dbc:	6082                	ld	ra,0(sp)
    80005dbe:	6122                	ld	sp,8(sp)
    80005dc0:	61c2                	ld	gp,16(sp)
    80005dc2:	7282                	ld	t0,32(sp)
    80005dc4:	7322                	ld	t1,40(sp)
    80005dc6:	73c2                	ld	t2,48(sp)
    80005dc8:	6526                	ld	a0,72(sp)
    80005dca:	65c6                	ld	a1,80(sp)
    80005dcc:	6666                	ld	a2,88(sp)
    80005dce:	7686                	ld	a3,96(sp)
    80005dd0:	7726                	ld	a4,104(sp)
    80005dd2:	77c6                	ld	a5,112(sp)
    80005dd4:	7866                	ld	a6,120(sp)
    80005dd6:	688a                	ld	a7,128(sp)
    80005dd8:	6e6e                	ld	t3,216(sp)
    80005dda:	7e8e                	ld	t4,224(sp)
    80005ddc:	7f2e                	ld	t5,232(sp)
    80005dde:	7fce                	ld	t6,240(sp)
    80005de0:	6111                	addi	sp,sp,256
    80005de2:	10200073          	sret
	...

0000000080005dee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005dee:	1141                	addi	sp,sp,-16
    80005df0:	e422                	sd	s0,8(sp)
    80005df2:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005df4:	0c0007b7          	lui	a5,0xc000
    80005df8:	4705                	li	a4,1
    80005dfa:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005dfc:	0c0007b7          	lui	a5,0xc000
    80005e00:	c3d8                	sw	a4,4(a5)
}
    80005e02:	6422                	ld	s0,8(sp)
    80005e04:	0141                	addi	sp,sp,16
    80005e06:	8082                	ret

0000000080005e08 <plicinithart>:

void
plicinithart(void)
{
    80005e08:	1141                	addi	sp,sp,-16
    80005e0a:	e406                	sd	ra,8(sp)
    80005e0c:	e022                	sd	s0,0(sp)
    80005e0e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e10:	9f2fc0ef          	jal	80002002 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005e14:	0085171b          	slliw	a4,a0,0x8
    80005e18:	0c0027b7          	lui	a5,0xc002
    80005e1c:	97ba                	add	a5,a5,a4
    80005e1e:	40200713          	li	a4,1026
    80005e22:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005e26:	00d5151b          	slliw	a0,a0,0xd
    80005e2a:	0c2017b7          	lui	a5,0xc201
    80005e2e:	97aa                	add	a5,a5,a0
    80005e30:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005e34:	60a2                	ld	ra,8(sp)
    80005e36:	6402                	ld	s0,0(sp)
    80005e38:	0141                	addi	sp,sp,16
    80005e3a:	8082                	ret

0000000080005e3c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005e3c:	1141                	addi	sp,sp,-16
    80005e3e:	e406                	sd	ra,8(sp)
    80005e40:	e022                	sd	s0,0(sp)
    80005e42:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005e44:	9befc0ef          	jal	80002002 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005e48:	00d5151b          	slliw	a0,a0,0xd
    80005e4c:	0c2017b7          	lui	a5,0xc201
    80005e50:	97aa                	add	a5,a5,a0
  return irq;
}
    80005e52:	43c8                	lw	a0,4(a5)
    80005e54:	60a2                	ld	ra,8(sp)
    80005e56:	6402                	ld	s0,0(sp)
    80005e58:	0141                	addi	sp,sp,16
    80005e5a:	8082                	ret

0000000080005e5c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005e5c:	1101                	addi	sp,sp,-32
    80005e5e:	ec06                	sd	ra,24(sp)
    80005e60:	e822                	sd	s0,16(sp)
    80005e62:	e426                	sd	s1,8(sp)
    80005e64:	1000                	addi	s0,sp,32
    80005e66:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005e68:	99afc0ef          	jal	80002002 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005e6c:	00d5151b          	slliw	a0,a0,0xd
    80005e70:	0c2017b7          	lui	a5,0xc201
    80005e74:	97aa                	add	a5,a5,a0
    80005e76:	c3c4                	sw	s1,4(a5)
}
    80005e78:	60e2                	ld	ra,24(sp)
    80005e7a:	6442                	ld	s0,16(sp)
    80005e7c:	64a2                	ld	s1,8(sp)
    80005e7e:	6105                	addi	sp,sp,32
    80005e80:	8082                	ret

0000000080005e82 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005e82:	1141                	addi	sp,sp,-16
    80005e84:	e406                	sd	ra,8(sp)
    80005e86:	e022                	sd	s0,0(sp)
    80005e88:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005e8a:	479d                	li	a5,7
    80005e8c:	04a7ca63          	blt	a5,a0,80005ee0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80005e90:	001b4797          	auipc	a5,0x1b4
    80005e94:	11078793          	addi	a5,a5,272 # 801b9fa0 <disk>
    80005e98:	97aa                	add	a5,a5,a0
    80005e9a:	0187c783          	lbu	a5,24(a5)
    80005e9e:	e7b9                	bnez	a5,80005eec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005ea0:	00451693          	slli	a3,a0,0x4
    80005ea4:	001b4797          	auipc	a5,0x1b4
    80005ea8:	0fc78793          	addi	a5,a5,252 # 801b9fa0 <disk>
    80005eac:	6398                	ld	a4,0(a5)
    80005eae:	9736                	add	a4,a4,a3
    80005eb0:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    80005eb4:	6398                	ld	a4,0(a5)
    80005eb6:	9736                	add	a4,a4,a3
    80005eb8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005ebc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005ec0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005ec4:	97aa                	add	a5,a5,a0
    80005ec6:	4705                	li	a4,1
    80005ec8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80005ecc:	001b4517          	auipc	a0,0x1b4
    80005ed0:	0ec50513          	addi	a0,a0,236 # 801b9fb8 <disk+0x18>
    80005ed4:	f90fc0ef          	jal	80002664 <wakeup>
}
    80005ed8:	60a2                	ld	ra,8(sp)
    80005eda:	6402                	ld	s0,0(sp)
    80005edc:	0141                	addi	sp,sp,16
    80005ede:	8082                	ret
    panic("free_desc 1");
    80005ee0:	00003517          	auipc	a0,0x3
    80005ee4:	8b050513          	addi	a0,a0,-1872 # 80008790 <etext+0x790>
    80005ee8:	911fa0ef          	jal	800007f8 <panic>
    panic("free_desc 2");
    80005eec:	00003517          	auipc	a0,0x3
    80005ef0:	8b450513          	addi	a0,a0,-1868 # 800087a0 <etext+0x7a0>
    80005ef4:	905fa0ef          	jal	800007f8 <panic>

0000000080005ef8 <virtio_disk_init>:
{
    80005ef8:	1101                	addi	sp,sp,-32
    80005efa:	ec06                	sd	ra,24(sp)
    80005efc:	e822                	sd	s0,16(sp)
    80005efe:	e426                	sd	s1,8(sp)
    80005f00:	e04a                	sd	s2,0(sp)
    80005f02:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005f04:	00003597          	auipc	a1,0x3
    80005f08:	8ac58593          	addi	a1,a1,-1876 # 800087b0 <etext+0x7b0>
    80005f0c:	001b4517          	auipc	a0,0x1b4
    80005f10:	1bc50513          	addi	a0,a0,444 # 801ba0c8 <disk+0x128>
    80005f14:	cc5fa0ef          	jal	80000bd8 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f18:	100017b7          	lui	a5,0x10001
    80005f1c:	4398                	lw	a4,0(a5)
    80005f1e:	2701                	sext.w	a4,a4
    80005f20:	747277b7          	lui	a5,0x74727
    80005f24:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005f28:	18f71063          	bne	a4,a5,800060a8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f2c:	100017b7          	lui	a5,0x10001
    80005f30:	0791                	addi	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    80005f32:	439c                	lw	a5,0(a5)
    80005f34:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005f36:	4709                	li	a4,2
    80005f38:	16e79863          	bne	a5,a4,800060a8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f3c:	100017b7          	lui	a5,0x10001
    80005f40:	07a1                	addi	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    80005f42:	439c                	lw	a5,0(a5)
    80005f44:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005f46:	16e79163          	bne	a5,a4,800060a8 <virtio_disk_init+0x1b0>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005f4a:	100017b7          	lui	a5,0x10001
    80005f4e:	47d8                	lw	a4,12(a5)
    80005f50:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005f52:	554d47b7          	lui	a5,0x554d4
    80005f56:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005f5a:	14f71763          	bne	a4,a5,800060a8 <virtio_disk_init+0x1b0>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f5e:	100017b7          	lui	a5,0x10001
    80005f62:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f66:	4705                	li	a4,1
    80005f68:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f6a:	470d                	li	a4,3
    80005f6c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005f6e:	10001737          	lui	a4,0x10001
    80005f72:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005f74:	c7ffe737          	lui	a4,0xc7ffe
    80005f78:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47e4467f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005f7c:	8ef9                	and	a3,a3,a4
    80005f7e:	10001737          	lui	a4,0x10001
    80005f82:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f84:	472d                	li	a4,11
    80005f86:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005f88:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005f8c:	439c                	lw	a5,0(a5)
    80005f8e:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005f92:	8ba1                	andi	a5,a5,8
    80005f94:	12078063          	beqz	a5,800060b4 <virtio_disk_init+0x1bc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005f98:	100017b7          	lui	a5,0x10001
    80005f9c:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005fa0:	100017b7          	lui	a5,0x10001
    80005fa4:	04478793          	addi	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80005fa8:	439c                	lw	a5,0(a5)
    80005faa:	2781                	sext.w	a5,a5
    80005fac:	10079a63          	bnez	a5,800060c0 <virtio_disk_init+0x1c8>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005fb0:	100017b7          	lui	a5,0x10001
    80005fb4:	03478793          	addi	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80005fb8:	439c                	lw	a5,0(a5)
    80005fba:	2781                	sext.w	a5,a5
  if(max == 0)
    80005fbc:	10078863          	beqz	a5,800060cc <virtio_disk_init+0x1d4>
  if(max < NUM)
    80005fc0:	471d                	li	a4,7
    80005fc2:	10f77b63          	bgeu	a4,a5,800060d8 <virtio_disk_init+0x1e0>
  disk.desc = kalloc();
    80005fc6:	bc3fa0ef          	jal	80000b88 <kalloc>
    80005fca:	001b4497          	auipc	s1,0x1b4
    80005fce:	fd648493          	addi	s1,s1,-42 # 801b9fa0 <disk>
    80005fd2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005fd4:	bb5fa0ef          	jal	80000b88 <kalloc>
    80005fd8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80005fda:	baffa0ef          	jal	80000b88 <kalloc>
    80005fde:	87aa                	mv	a5,a0
    80005fe0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005fe2:	6088                	ld	a0,0(s1)
    80005fe4:	10050063          	beqz	a0,800060e4 <virtio_disk_init+0x1ec>
    80005fe8:	001b4717          	auipc	a4,0x1b4
    80005fec:	fc073703          	ld	a4,-64(a4) # 801b9fa8 <disk+0x8>
    80005ff0:	0e070a63          	beqz	a4,800060e4 <virtio_disk_init+0x1ec>
    80005ff4:	0e078863          	beqz	a5,800060e4 <virtio_disk_init+0x1ec>
  memset(disk.desc, 0, PGSIZE);
    80005ff8:	6605                	lui	a2,0x1
    80005ffa:	4581                	li	a1,0
    80005ffc:	d31fa0ef          	jal	80000d2c <memset>
  memset(disk.avail, 0, PGSIZE);
    80006000:	001b4497          	auipc	s1,0x1b4
    80006004:	fa048493          	addi	s1,s1,-96 # 801b9fa0 <disk>
    80006008:	6605                	lui	a2,0x1
    8000600a:	4581                	li	a1,0
    8000600c:	6488                	ld	a0,8(s1)
    8000600e:	d1ffa0ef          	jal	80000d2c <memset>
  memset(disk.used, 0, PGSIZE);
    80006012:	6605                	lui	a2,0x1
    80006014:	4581                	li	a1,0
    80006016:	6888                	ld	a0,16(s1)
    80006018:	d15fa0ef          	jal	80000d2c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000601c:	100017b7          	lui	a5,0x10001
    80006020:	4721                	li	a4,8
    80006022:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80006024:	4098                	lw	a4,0(s1)
    80006026:	100017b7          	lui	a5,0x10001
    8000602a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000602e:	40d8                	lw	a4,4(s1)
    80006030:	100017b7          	lui	a5,0x10001
    80006034:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80006038:	649c                	ld	a5,8(s1)
    8000603a:	0007869b          	sext.w	a3,a5
    8000603e:	10001737          	lui	a4,0x10001
    80006042:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80006046:	9781                	srai	a5,a5,0x20
    80006048:	10001737          	lui	a4,0x10001
    8000604c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80006050:	689c                	ld	a5,16(s1)
    80006052:	0007869b          	sext.w	a3,a5
    80006056:	10001737          	lui	a4,0x10001
    8000605a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000605e:	9781                	srai	a5,a5,0x20
    80006060:	10001737          	lui	a4,0x10001
    80006064:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80006068:	10001737          	lui	a4,0x10001
    8000606c:	4785                	li	a5,1
    8000606e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80006070:	00f48c23          	sb	a5,24(s1)
    80006074:	00f48ca3          	sb	a5,25(s1)
    80006078:	00f48d23          	sb	a5,26(s1)
    8000607c:	00f48da3          	sb	a5,27(s1)
    80006080:	00f48e23          	sb	a5,28(s1)
    80006084:	00f48ea3          	sb	a5,29(s1)
    80006088:	00f48f23          	sb	a5,30(s1)
    8000608c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80006090:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80006094:	100017b7          	lui	a5,0x10001
    80006098:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000609c:	60e2                	ld	ra,24(sp)
    8000609e:	6442                	ld	s0,16(sp)
    800060a0:	64a2                	ld	s1,8(sp)
    800060a2:	6902                	ld	s2,0(sp)
    800060a4:	6105                	addi	sp,sp,32
    800060a6:	8082                	ret
    panic("could not find virtio disk");
    800060a8:	00002517          	auipc	a0,0x2
    800060ac:	71850513          	addi	a0,a0,1816 # 800087c0 <etext+0x7c0>
    800060b0:	f48fa0ef          	jal	800007f8 <panic>
    panic("virtio disk FEATURES_OK unset");
    800060b4:	00002517          	auipc	a0,0x2
    800060b8:	72c50513          	addi	a0,a0,1836 # 800087e0 <etext+0x7e0>
    800060bc:	f3cfa0ef          	jal	800007f8 <panic>
    panic("virtio disk should not be ready");
    800060c0:	00002517          	auipc	a0,0x2
    800060c4:	74050513          	addi	a0,a0,1856 # 80008800 <etext+0x800>
    800060c8:	f30fa0ef          	jal	800007f8 <panic>
    panic("virtio disk has no queue 0");
    800060cc:	00002517          	auipc	a0,0x2
    800060d0:	75450513          	addi	a0,a0,1876 # 80008820 <etext+0x820>
    800060d4:	f24fa0ef          	jal	800007f8 <panic>
    panic("virtio disk max queue too short");
    800060d8:	00002517          	auipc	a0,0x2
    800060dc:	76850513          	addi	a0,a0,1896 # 80008840 <etext+0x840>
    800060e0:	f18fa0ef          	jal	800007f8 <panic>
    panic("virtio disk kalloc");
    800060e4:	00002517          	auipc	a0,0x2
    800060e8:	77c50513          	addi	a0,a0,1916 # 80008860 <etext+0x860>
    800060ec:	f0cfa0ef          	jal	800007f8 <panic>

00000000800060f0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800060f0:	7159                	addi	sp,sp,-112
    800060f2:	f486                	sd	ra,104(sp)
    800060f4:	f0a2                	sd	s0,96(sp)
    800060f6:	eca6                	sd	s1,88(sp)
    800060f8:	e8ca                	sd	s2,80(sp)
    800060fa:	e4ce                	sd	s3,72(sp)
    800060fc:	e0d2                	sd	s4,64(sp)
    800060fe:	fc56                	sd	s5,56(sp)
    80006100:	f85a                	sd	s6,48(sp)
    80006102:	f45e                	sd	s7,40(sp)
    80006104:	f062                	sd	s8,32(sp)
    80006106:	ec66                	sd	s9,24(sp)
    80006108:	1880                	addi	s0,sp,112
    8000610a:	8a2a                	mv	s4,a0
    8000610c:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000610e:	00c52c83          	lw	s9,12(a0)
    80006112:	001c9c9b          	slliw	s9,s9,0x1
    80006116:	1c82                	slli	s9,s9,0x20
    80006118:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    8000611c:	001b4517          	auipc	a0,0x1b4
    80006120:	fac50513          	addi	a0,a0,-84 # 801ba0c8 <disk+0x128>
    80006124:	b35fa0ef          	jal	80000c58 <acquire>
  for(int i = 0; i < 3; i++){
    80006128:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    8000612a:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000612c:	001b4b17          	auipc	s6,0x1b4
    80006130:	e74b0b13          	addi	s6,s6,-396 # 801b9fa0 <disk>
  for(int i = 0; i < 3; i++){
    80006134:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80006136:	001b4c17          	auipc	s8,0x1b4
    8000613a:	f92c0c13          	addi	s8,s8,-110 # 801ba0c8 <disk+0x128>
    8000613e:	a8b9                	j	8000619c <virtio_disk_rw+0xac>
      disk.free[i] = 0;
    80006140:	00fb0733          	add	a4,s6,a5
    80006144:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80006148:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    8000614a:	0207c563          	bltz	a5,80006174 <virtio_disk_rw+0x84>
  for(int i = 0; i < 3; i++){
    8000614e:	2905                	addiw	s2,s2,1
    80006150:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80006152:	05590963          	beq	s2,s5,800061a4 <virtio_disk_rw+0xb4>
    idx[i] = alloc_desc();
    80006156:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80006158:	001b4717          	auipc	a4,0x1b4
    8000615c:	e4870713          	addi	a4,a4,-440 # 801b9fa0 <disk>
    80006160:	87ce                	mv	a5,s3
    if(disk.free[i]){
    80006162:	01874683          	lbu	a3,24(a4)
    80006166:	fee9                	bnez	a3,80006140 <virtio_disk_rw+0x50>
  for(int i = 0; i < NUM; i++){
    80006168:	2785                	addiw	a5,a5,1
    8000616a:	0705                	addi	a4,a4,1
    8000616c:	fe979be3          	bne	a5,s1,80006162 <virtio_disk_rw+0x72>
    idx[i] = alloc_desc();
    80006170:	57fd                	li	a5,-1
    80006172:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80006174:	01205d63          	blez	s2,8000618e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80006178:	f9042503          	lw	a0,-112(s0)
    8000617c:	d07ff0ef          	jal	80005e82 <free_desc>
      for(int j = 0; j < i; j++)
    80006180:	4785                	li	a5,1
    80006182:	0127d663          	bge	a5,s2,8000618e <virtio_disk_rw+0x9e>
        free_desc(idx[j]);
    80006186:	f9442503          	lw	a0,-108(s0)
    8000618a:	cf9ff0ef          	jal	80005e82 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    8000618e:	85e2                	mv	a1,s8
    80006190:	001b4517          	auipc	a0,0x1b4
    80006194:	e2850513          	addi	a0,a0,-472 # 801b9fb8 <disk+0x18>
    80006198:	c80fc0ef          	jal	80002618 <sleep>
  for(int i = 0; i < 3; i++){
    8000619c:	f9040613          	addi	a2,s0,-112
    800061a0:	894e                	mv	s2,s3
    800061a2:	bf55                	j	80006156 <virtio_disk_rw+0x66>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800061a4:	f9042503          	lw	a0,-112(s0)
    800061a8:	00451693          	slli	a3,a0,0x4

  if(write)
    800061ac:	001b4797          	auipc	a5,0x1b4
    800061b0:	df478793          	addi	a5,a5,-524 # 801b9fa0 <disk>
    800061b4:	00a50713          	addi	a4,a0,10
    800061b8:	0712                	slli	a4,a4,0x4
    800061ba:	973e                	add	a4,a4,a5
    800061bc:	01703633          	snez	a2,s7
    800061c0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800061c2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800061c6:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800061ca:	6398                	ld	a4,0(a5)
    800061cc:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800061ce:	0a868613          	addi	a2,a3,168
    800061d2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800061d4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800061d6:	6390                	ld	a2,0(a5)
    800061d8:	00d605b3          	add	a1,a2,a3
    800061dc:	4741                	li	a4,16
    800061de:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800061e0:	4805                	li	a6,1
    800061e2:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800061e6:	f9442703          	lw	a4,-108(s0)
    800061ea:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800061ee:	0712                	slli	a4,a4,0x4
    800061f0:	963a                	add	a2,a2,a4
    800061f2:	058a0593          	addi	a1,s4,88
    800061f6:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800061f8:	0007b883          	ld	a7,0(a5)
    800061fc:	9746                	add	a4,a4,a7
    800061fe:	40000613          	li	a2,1024
    80006202:	c710                	sw	a2,8(a4)
  if(write)
    80006204:	001bb613          	seqz	a2,s7
    80006208:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000620c:	00166613          	ori	a2,a2,1
    80006210:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80006214:	f9842583          	lw	a1,-104(s0)
    80006218:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000621c:	00250613          	addi	a2,a0,2
    80006220:	0612                	slli	a2,a2,0x4
    80006222:	963e                	add	a2,a2,a5
    80006224:	577d                	li	a4,-1
    80006226:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000622a:	0592                	slli	a1,a1,0x4
    8000622c:	98ae                	add	a7,a7,a1
    8000622e:	03068713          	addi	a4,a3,48
    80006232:	973e                	add	a4,a4,a5
    80006234:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80006238:	6398                	ld	a4,0(a5)
    8000623a:	972e                	add	a4,a4,a1
    8000623c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80006240:	4689                	li	a3,2
    80006242:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80006246:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000624a:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    8000624e:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80006252:	6794                	ld	a3,8(a5)
    80006254:	0026d703          	lhu	a4,2(a3)
    80006258:	8b1d                	andi	a4,a4,7
    8000625a:	0706                	slli	a4,a4,0x1
    8000625c:	96ba                	add	a3,a3,a4
    8000625e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80006262:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80006266:	6798                	ld	a4,8(a5)
    80006268:	00275783          	lhu	a5,2(a4)
    8000626c:	2785                	addiw	a5,a5,1
    8000626e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80006272:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006276:	100017b7          	lui	a5,0x10001
    8000627a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000627e:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    80006282:	001b4917          	auipc	s2,0x1b4
    80006286:	e4690913          	addi	s2,s2,-442 # 801ba0c8 <disk+0x128>
  while(b->disk == 1) {
    8000628a:	4485                	li	s1,1
    8000628c:	01079a63          	bne	a5,a6,800062a0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80006290:	85ca                	mv	a1,s2
    80006292:	8552                	mv	a0,s4
    80006294:	b84fc0ef          	jal	80002618 <sleep>
  while(b->disk == 1) {
    80006298:	004a2783          	lw	a5,4(s4)
    8000629c:	fe978ae3          	beq	a5,s1,80006290 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800062a0:	f9042903          	lw	s2,-112(s0)
    800062a4:	00290713          	addi	a4,s2,2
    800062a8:	0712                	slli	a4,a4,0x4
    800062aa:	001b4797          	auipc	a5,0x1b4
    800062ae:	cf678793          	addi	a5,a5,-778 # 801b9fa0 <disk>
    800062b2:	97ba                	add	a5,a5,a4
    800062b4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800062b8:	001b4997          	auipc	s3,0x1b4
    800062bc:	ce898993          	addi	s3,s3,-792 # 801b9fa0 <disk>
    800062c0:	00491713          	slli	a4,s2,0x4
    800062c4:	0009b783          	ld	a5,0(s3)
    800062c8:	97ba                	add	a5,a5,a4
    800062ca:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800062ce:	854a                	mv	a0,s2
    800062d0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800062d4:	bafff0ef          	jal	80005e82 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800062d8:	8885                	andi	s1,s1,1
    800062da:	f0fd                	bnez	s1,800062c0 <virtio_disk_rw+0x1d0>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800062dc:	001b4517          	auipc	a0,0x1b4
    800062e0:	dec50513          	addi	a0,a0,-532 # 801ba0c8 <disk+0x128>
    800062e4:	a0dfa0ef          	jal	80000cf0 <release>
}
    800062e8:	70a6                	ld	ra,104(sp)
    800062ea:	7406                	ld	s0,96(sp)
    800062ec:	64e6                	ld	s1,88(sp)
    800062ee:	6946                	ld	s2,80(sp)
    800062f0:	69a6                	ld	s3,72(sp)
    800062f2:	6a06                	ld	s4,64(sp)
    800062f4:	7ae2                	ld	s5,56(sp)
    800062f6:	7b42                	ld	s6,48(sp)
    800062f8:	7ba2                	ld	s7,40(sp)
    800062fa:	7c02                	ld	s8,32(sp)
    800062fc:	6ce2                	ld	s9,24(sp)
    800062fe:	6165                	addi	sp,sp,112
    80006300:	8082                	ret

0000000080006302 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80006302:	1101                	addi	sp,sp,-32
    80006304:	ec06                	sd	ra,24(sp)
    80006306:	e822                	sd	s0,16(sp)
    80006308:	e426                	sd	s1,8(sp)
    8000630a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000630c:	001b4497          	auipc	s1,0x1b4
    80006310:	c9448493          	addi	s1,s1,-876 # 801b9fa0 <disk>
    80006314:	001b4517          	auipc	a0,0x1b4
    80006318:	db450513          	addi	a0,a0,-588 # 801ba0c8 <disk+0x128>
    8000631c:	93dfa0ef          	jal	80000c58 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80006320:	100017b7          	lui	a5,0x10001
    80006324:	53b8                	lw	a4,96(a5)
    80006326:	8b0d                	andi	a4,a4,3
    80006328:	100017b7          	lui	a5,0x10001
    8000632c:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    8000632e:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80006332:	689c                	ld	a5,16(s1)
    80006334:	0204d703          	lhu	a4,32(s1)
    80006338:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000633c:	04f70663          	beq	a4,a5,80006388 <virtio_disk_intr+0x86>
    __sync_synchronize();
    80006340:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80006344:	6898                	ld	a4,16(s1)
    80006346:	0204d783          	lhu	a5,32(s1)
    8000634a:	8b9d                	andi	a5,a5,7
    8000634c:	078e                	slli	a5,a5,0x3
    8000634e:	97ba                	add	a5,a5,a4
    80006350:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80006352:	00278713          	addi	a4,a5,2
    80006356:	0712                	slli	a4,a4,0x4
    80006358:	9726                	add	a4,a4,s1
    8000635a:	01074703          	lbu	a4,16(a4)
    8000635e:	e321                	bnez	a4,8000639e <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80006360:	0789                	addi	a5,a5,2
    80006362:	0792                	slli	a5,a5,0x4
    80006364:	97a6                	add	a5,a5,s1
    80006366:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80006368:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000636c:	af8fc0ef          	jal	80002664 <wakeup>

    disk.used_idx += 1;
    80006370:	0204d783          	lhu	a5,32(s1)
    80006374:	2785                	addiw	a5,a5,1
    80006376:	17c2                	slli	a5,a5,0x30
    80006378:	93c1                	srli	a5,a5,0x30
    8000637a:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    8000637e:	6898                	ld	a4,16(s1)
    80006380:	00275703          	lhu	a4,2(a4)
    80006384:	faf71ee3          	bne	a4,a5,80006340 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80006388:	001b4517          	auipc	a0,0x1b4
    8000638c:	d4050513          	addi	a0,a0,-704 # 801ba0c8 <disk+0x128>
    80006390:	961fa0ef          	jal	80000cf0 <release>
}
    80006394:	60e2                	ld	ra,24(sp)
    80006396:	6442                	ld	s0,16(sp)
    80006398:	64a2                	ld	s1,8(sp)
    8000639a:	6105                	addi	sp,sp,32
    8000639c:	8082                	ret
      panic("virtio_disk_intr status");
    8000639e:	00002517          	auipc	a0,0x2
    800063a2:	4da50513          	addi	a0,a0,1242 # 80008878 <etext+0x878>
    800063a6:	c52fa0ef          	jal	800007f8 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
