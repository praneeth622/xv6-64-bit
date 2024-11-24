
user/_signal:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <sigint_handler>:
#include "user.h"
#include "kernel/types.h"

void sigint_handler(int signum);

void sigint_handler(int signum) {
    1000:	1141                	addi	sp,sp,-16
    1002:	e406                	sd	ra,8(sp)
    1004:	e022                	sd	s0,0(sp)
    1006:	0800                	addi	s0,sp,16
    printf("Custom SIGINT handler triggered\n");
    1008:	00001517          	auipc	a0,0x1
    100c:	ff850513          	addi	a0,a0,-8 # 2000 <malloc+0x83a>
    1010:	702000ef          	jal	1712 <printf>
    // Custom handling logic here
}
    1014:	60a2                	ld	ra,8(sp)
    1016:	6402                	ld	s0,0(sp)
    1018:	0141                	addi	sp,sp,16
    101a:	8082                	ret

000000000000101c <main>:

int main(void) {
    101c:	1141                	addi	sp,sp,-16
    101e:	e406                	sd	ra,8(sp)
    1020:	e022                	sd	s0,0(sp)
    1022:	0800                	addi	s0,sp,16
    // Register the SIGINT signal handler
    signal(SIGINT, &sigint_handler);
    1024:	00000597          	auipc	a1,0x0
    1028:	fdc58593          	addi	a1,a1,-36 # 1000 <sigint_handler>
    102c:	4509                	li	a0,2
    102e:	32c000ef          	jal	135a <signal>


    // Printing address of handler using a direct variable
    printf("Address of the signal handler : %p\n", &sigint_handler);
    1032:	00000597          	auipc	a1,0x0
    1036:	fce58593          	addi	a1,a1,-50 # 1000 <sigint_handler>
    103a:	00001517          	auipc	a0,0x1
    103e:	fee50513          	addi	a0,a0,-18 # 2028 <malloc+0x862>
    1042:	6d0000ef          	jal	1712 <printf>
    // Simulate running some process that waits for signals
    int i = 0;
    while (1) {
    1046:	a001                	j	1046 <main+0x2a>

0000000000001048 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    1048:	1141                	addi	sp,sp,-16
    104a:	e406                	sd	ra,8(sp)
    104c:	e022                	sd	s0,0(sp)
    104e:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1050:	fcdff0ef          	jal	101c <main>
  exit(0);
    1054:	4501                	li	a0,0
    1056:	25c000ef          	jal	12b2 <exit>

000000000000105a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    105a:	1141                	addi	sp,sp,-16
    105c:	e422                	sd	s0,8(sp)
    105e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1060:	87aa                	mv	a5,a0
    1062:	0585                	addi	a1,a1,1
    1064:	0785                	addi	a5,a5,1
    1066:	fff5c703          	lbu	a4,-1(a1)
    106a:	fee78fa3          	sb	a4,-1(a5)
    106e:	fb75                	bnez	a4,1062 <strcpy+0x8>
    ;
  return os;
}
    1070:	6422                	ld	s0,8(sp)
    1072:	0141                	addi	sp,sp,16
    1074:	8082                	ret

0000000000001076 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1076:	1141                	addi	sp,sp,-16
    1078:	e422                	sd	s0,8(sp)
    107a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    107c:	00054783          	lbu	a5,0(a0)
    1080:	cb91                	beqz	a5,1094 <strcmp+0x1e>
    1082:	0005c703          	lbu	a4,0(a1)
    1086:	00f71763          	bne	a4,a5,1094 <strcmp+0x1e>
    p++, q++;
    108a:	0505                	addi	a0,a0,1
    108c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    108e:	00054783          	lbu	a5,0(a0)
    1092:	fbe5                	bnez	a5,1082 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1094:	0005c503          	lbu	a0,0(a1)
}
    1098:	40a7853b          	subw	a0,a5,a0
    109c:	6422                	ld	s0,8(sp)
    109e:	0141                	addi	sp,sp,16
    10a0:	8082                	ret

00000000000010a2 <strlen>:

uint
strlen(const char *s)
{
    10a2:	1141                	addi	sp,sp,-16
    10a4:	e422                	sd	s0,8(sp)
    10a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10a8:	00054783          	lbu	a5,0(a0)
    10ac:	cf91                	beqz	a5,10c8 <strlen+0x26>
    10ae:	0505                	addi	a0,a0,1
    10b0:	87aa                	mv	a5,a0
    10b2:	86be                	mv	a3,a5
    10b4:	0785                	addi	a5,a5,1
    10b6:	fff7c703          	lbu	a4,-1(a5)
    10ba:	ff65                	bnez	a4,10b2 <strlen+0x10>
    10bc:	40a6853b          	subw	a0,a3,a0
    10c0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    10c2:	6422                	ld	s0,8(sp)
    10c4:	0141                	addi	sp,sp,16
    10c6:	8082                	ret
  for(n = 0; s[n]; n++)
    10c8:	4501                	li	a0,0
    10ca:	bfe5                	j	10c2 <strlen+0x20>

00000000000010cc <memset>:

void*
memset(void *dst, int c, uint n)
{
    10cc:	1141                	addi	sp,sp,-16
    10ce:	e422                	sd	s0,8(sp)
    10d0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10d2:	ca19                	beqz	a2,10e8 <memset+0x1c>
    10d4:	87aa                	mv	a5,a0
    10d6:	1602                	slli	a2,a2,0x20
    10d8:	9201                	srli	a2,a2,0x20
    10da:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    10de:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10e2:	0785                	addi	a5,a5,1
    10e4:	fee79de3          	bne	a5,a4,10de <memset+0x12>
  }
  return dst;
}
    10e8:	6422                	ld	s0,8(sp)
    10ea:	0141                	addi	sp,sp,16
    10ec:	8082                	ret

00000000000010ee <strchr>:

char*
strchr(const char *s, char c)
{
    10ee:	1141                	addi	sp,sp,-16
    10f0:	e422                	sd	s0,8(sp)
    10f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
    10f4:	00054783          	lbu	a5,0(a0)
    10f8:	cb99                	beqz	a5,110e <strchr+0x20>
    if(*s == c)
    10fa:	00f58763          	beq	a1,a5,1108 <strchr+0x1a>
  for(; *s; s++)
    10fe:	0505                	addi	a0,a0,1
    1100:	00054783          	lbu	a5,0(a0)
    1104:	fbfd                	bnez	a5,10fa <strchr+0xc>
      return (char*)s;
  return 0;
    1106:	4501                	li	a0,0
}
    1108:	6422                	ld	s0,8(sp)
    110a:	0141                	addi	sp,sp,16
    110c:	8082                	ret
  return 0;
    110e:	4501                	li	a0,0
    1110:	bfe5                	j	1108 <strchr+0x1a>

0000000000001112 <gets>:

char*
gets(char *buf, int max)
{
    1112:	711d                	addi	sp,sp,-96
    1114:	ec86                	sd	ra,88(sp)
    1116:	e8a2                	sd	s0,80(sp)
    1118:	e4a6                	sd	s1,72(sp)
    111a:	e0ca                	sd	s2,64(sp)
    111c:	fc4e                	sd	s3,56(sp)
    111e:	f852                	sd	s4,48(sp)
    1120:	f456                	sd	s5,40(sp)
    1122:	f05a                	sd	s6,32(sp)
    1124:	ec5e                	sd	s7,24(sp)
    1126:	1080                	addi	s0,sp,96
    1128:	8baa                	mv	s7,a0
    112a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    112c:	892a                	mv	s2,a0
    112e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1130:	4aa9                	li	s5,10
    1132:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1134:	89a6                	mv	s3,s1
    1136:	2485                	addiw	s1,s1,1
    1138:	0344d663          	bge	s1,s4,1164 <gets+0x52>
    cc = read(0, &c, 1);
    113c:	4605                	li	a2,1
    113e:	faf40593          	addi	a1,s0,-81
    1142:	4501                	li	a0,0
    1144:	186000ef          	jal	12ca <read>
    if(cc < 1)
    1148:	00a05e63          	blez	a0,1164 <gets+0x52>
    buf[i++] = c;
    114c:	faf44783          	lbu	a5,-81(s0)
    1150:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1154:	01578763          	beq	a5,s5,1162 <gets+0x50>
    1158:	0905                	addi	s2,s2,1
    115a:	fd679de3          	bne	a5,s6,1134 <gets+0x22>
    buf[i++] = c;
    115e:	89a6                	mv	s3,s1
    1160:	a011                	j	1164 <gets+0x52>
    1162:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1164:	99de                	add	s3,s3,s7
    1166:	00098023          	sb	zero,0(s3)
  return buf;
}
    116a:	855e                	mv	a0,s7
    116c:	60e6                	ld	ra,88(sp)
    116e:	6446                	ld	s0,80(sp)
    1170:	64a6                	ld	s1,72(sp)
    1172:	6906                	ld	s2,64(sp)
    1174:	79e2                	ld	s3,56(sp)
    1176:	7a42                	ld	s4,48(sp)
    1178:	7aa2                	ld	s5,40(sp)
    117a:	7b02                	ld	s6,32(sp)
    117c:	6be2                	ld	s7,24(sp)
    117e:	6125                	addi	sp,sp,96
    1180:	8082                	ret

0000000000001182 <stat>:

int
stat(const char *n, struct stat *st)
{
    1182:	1101                	addi	sp,sp,-32
    1184:	ec06                	sd	ra,24(sp)
    1186:	e822                	sd	s0,16(sp)
    1188:	e04a                	sd	s2,0(sp)
    118a:	1000                	addi	s0,sp,32
    118c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    118e:	4581                	li	a1,0
    1190:	162000ef          	jal	12f2 <open>
  if(fd < 0)
    1194:	02054263          	bltz	a0,11b8 <stat+0x36>
    1198:	e426                	sd	s1,8(sp)
    119a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    119c:	85ca                	mv	a1,s2
    119e:	16c000ef          	jal	130a <fstat>
    11a2:	892a                	mv	s2,a0
  close(fd);
    11a4:	8526                	mv	a0,s1
    11a6:	134000ef          	jal	12da <close>
  return r;
    11aa:	64a2                	ld	s1,8(sp)
}
    11ac:	854a                	mv	a0,s2
    11ae:	60e2                	ld	ra,24(sp)
    11b0:	6442                	ld	s0,16(sp)
    11b2:	6902                	ld	s2,0(sp)
    11b4:	6105                	addi	sp,sp,32
    11b6:	8082                	ret
    return -1;
    11b8:	597d                	li	s2,-1
    11ba:	bfcd                	j	11ac <stat+0x2a>

00000000000011bc <atoi>:

int
atoi(const char *s)
{
    11bc:	1141                	addi	sp,sp,-16
    11be:	e422                	sd	s0,8(sp)
    11c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11c2:	00054683          	lbu	a3,0(a0)
    11c6:	fd06879b          	addiw	a5,a3,-48
    11ca:	0ff7f793          	zext.b	a5,a5
    11ce:	4625                	li	a2,9
    11d0:	02f66863          	bltu	a2,a5,1200 <atoi+0x44>
    11d4:	872a                	mv	a4,a0
  n = 0;
    11d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    11d8:	0705                	addi	a4,a4,1
    11da:	0025179b          	slliw	a5,a0,0x2
    11de:	9fa9                	addw	a5,a5,a0
    11e0:	0017979b          	slliw	a5,a5,0x1
    11e4:	9fb5                	addw	a5,a5,a3
    11e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    11ea:	00074683          	lbu	a3,0(a4)
    11ee:	fd06879b          	addiw	a5,a3,-48
    11f2:	0ff7f793          	zext.b	a5,a5
    11f6:	fef671e3          	bgeu	a2,a5,11d8 <atoi+0x1c>
  return n;
}
    11fa:	6422                	ld	s0,8(sp)
    11fc:	0141                	addi	sp,sp,16
    11fe:	8082                	ret
  n = 0;
    1200:	4501                	li	a0,0
    1202:	bfe5                	j	11fa <atoi+0x3e>

0000000000001204 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1204:	1141                	addi	sp,sp,-16
    1206:	e422                	sd	s0,8(sp)
    1208:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    120a:	02b57463          	bgeu	a0,a1,1232 <memmove+0x2e>
    while(n-- > 0)
    120e:	00c05f63          	blez	a2,122c <memmove+0x28>
    1212:	1602                	slli	a2,a2,0x20
    1214:	9201                	srli	a2,a2,0x20
    1216:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    121a:	872a                	mv	a4,a0
      *dst++ = *src++;
    121c:	0585                	addi	a1,a1,1
    121e:	0705                	addi	a4,a4,1
    1220:	fff5c683          	lbu	a3,-1(a1)
    1224:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1228:	fef71ae3          	bne	a4,a5,121c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    122c:	6422                	ld	s0,8(sp)
    122e:	0141                	addi	sp,sp,16
    1230:	8082                	ret
    dst += n;
    1232:	00c50733          	add	a4,a0,a2
    src += n;
    1236:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1238:	fec05ae3          	blez	a2,122c <memmove+0x28>
    123c:	fff6079b          	addiw	a5,a2,-1
    1240:	1782                	slli	a5,a5,0x20
    1242:	9381                	srli	a5,a5,0x20
    1244:	fff7c793          	not	a5,a5
    1248:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    124a:	15fd                	addi	a1,a1,-1
    124c:	177d                	addi	a4,a4,-1
    124e:	0005c683          	lbu	a3,0(a1)
    1252:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1256:	fee79ae3          	bne	a5,a4,124a <memmove+0x46>
    125a:	bfc9                	j	122c <memmove+0x28>

000000000000125c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    125c:	1141                	addi	sp,sp,-16
    125e:	e422                	sd	s0,8(sp)
    1260:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1262:	ca05                	beqz	a2,1292 <memcmp+0x36>
    1264:	fff6069b          	addiw	a3,a2,-1
    1268:	1682                	slli	a3,a3,0x20
    126a:	9281                	srli	a3,a3,0x20
    126c:	0685                	addi	a3,a3,1
    126e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1270:	00054783          	lbu	a5,0(a0)
    1274:	0005c703          	lbu	a4,0(a1)
    1278:	00e79863          	bne	a5,a4,1288 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    127c:	0505                	addi	a0,a0,1
    p2++;
    127e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1280:	fed518e3          	bne	a0,a3,1270 <memcmp+0x14>
  }
  return 0;
    1284:	4501                	li	a0,0
    1286:	a019                	j	128c <memcmp+0x30>
      return *p1 - *p2;
    1288:	40e7853b          	subw	a0,a5,a4
}
    128c:	6422                	ld	s0,8(sp)
    128e:	0141                	addi	sp,sp,16
    1290:	8082                	ret
  return 0;
    1292:	4501                	li	a0,0
    1294:	bfe5                	j	128c <memcmp+0x30>

0000000000001296 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1296:	1141                	addi	sp,sp,-16
    1298:	e406                	sd	ra,8(sp)
    129a:	e022                	sd	s0,0(sp)
    129c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    129e:	f67ff0ef          	jal	1204 <memmove>
}
    12a2:	60a2                	ld	ra,8(sp)
    12a4:	6402                	ld	s0,0(sp)
    12a6:	0141                	addi	sp,sp,16
    12a8:	8082                	ret

00000000000012aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12aa:	4885                	li	a7,1
 ecall
    12ac:	00000073          	ecall
 ret
    12b0:	8082                	ret

00000000000012b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    12b2:	4889                	li	a7,2
 ecall
    12b4:	00000073          	ecall
 ret
    12b8:	8082                	ret

00000000000012ba <wait>:
.global wait
wait:
 li a7, SYS_wait
    12ba:	488d                	li	a7,3
 ecall
    12bc:	00000073          	ecall
 ret
    12c0:	8082                	ret

00000000000012c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    12c2:	4891                	li	a7,4
 ecall
    12c4:	00000073          	ecall
 ret
    12c8:	8082                	ret

00000000000012ca <read>:
.global read
read:
 li a7, SYS_read
    12ca:	4895                	li	a7,5
 ecall
    12cc:	00000073          	ecall
 ret
    12d0:	8082                	ret

00000000000012d2 <write>:
.global write
write:
 li a7, SYS_write
    12d2:	48c1                	li	a7,16
 ecall
    12d4:	00000073          	ecall
 ret
    12d8:	8082                	ret

00000000000012da <close>:
.global close
close:
 li a7, SYS_close
    12da:	48d5                	li	a7,21
 ecall
    12dc:	00000073          	ecall
 ret
    12e0:	8082                	ret

00000000000012e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
    12e2:	4899                	li	a7,6
 ecall
    12e4:	00000073          	ecall
 ret
    12e8:	8082                	ret

00000000000012ea <exec>:
.global exec
exec:
 li a7, SYS_exec
    12ea:	489d                	li	a7,7
 ecall
    12ec:	00000073          	ecall
 ret
    12f0:	8082                	ret

00000000000012f2 <open>:
.global open
open:
 li a7, SYS_open
    12f2:	48bd                	li	a7,15
 ecall
    12f4:	00000073          	ecall
 ret
    12f8:	8082                	ret

00000000000012fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    12fa:	48c5                	li	a7,17
 ecall
    12fc:	00000073          	ecall
 ret
    1300:	8082                	ret

0000000000001302 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1302:	48c9                	li	a7,18
 ecall
    1304:	00000073          	ecall
 ret
    1308:	8082                	ret

000000000000130a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    130a:	48a1                	li	a7,8
 ecall
    130c:	00000073          	ecall
 ret
    1310:	8082                	ret

0000000000001312 <link>:
.global link
link:
 li a7, SYS_link
    1312:	48cd                	li	a7,19
 ecall
    1314:	00000073          	ecall
 ret
    1318:	8082                	ret

000000000000131a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    131a:	48d1                	li	a7,20
 ecall
    131c:	00000073          	ecall
 ret
    1320:	8082                	ret

0000000000001322 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1322:	48a5                	li	a7,9
 ecall
    1324:	00000073          	ecall
 ret
    1328:	8082                	ret

000000000000132a <dup>:
.global dup
dup:
 li a7, SYS_dup
    132a:	48a9                	li	a7,10
 ecall
    132c:	00000073          	ecall
 ret
    1330:	8082                	ret

0000000000001332 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1332:	48ad                	li	a7,11
 ecall
    1334:	00000073          	ecall
 ret
    1338:	8082                	ret

000000000000133a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    133a:	48b1                	li	a7,12
 ecall
    133c:	00000073          	ecall
 ret
    1340:	8082                	ret

0000000000001342 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1342:	48b5                	li	a7,13
 ecall
    1344:	00000073          	ecall
 ret
    1348:	8082                	ret

000000000000134a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    134a:	48b9                	li	a7,14
 ecall
    134c:	00000073          	ecall
 ret
    1350:	8082                	ret

0000000000001352 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1352:	48d9                	li	a7,22
 ecall
    1354:	00000073          	ecall
 ret
    1358:	8082                	ret

000000000000135a <signal>:
.global signal
signal:
 li a7, SYS_signal
    135a:	48dd                	li	a7,23
 ecall
    135c:	00000073          	ecall
 ret
    1360:	8082                	ret

0000000000001362 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1362:	48e1                	li	a7,24
 ecall
    1364:	00000073          	ecall
 ret
    1368:	8082                	ret

000000000000136a <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    136a:	48e5                	li	a7,25
 ecall
    136c:	00000073          	ecall
 ret
    1370:	8082                	ret

0000000000001372 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1372:	48e9                	li	a7,26
 ecall
    1374:	00000073          	ecall
 ret
    1378:	8082                	ret

000000000000137a <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    137a:	48ed                	li	a7,27
 ecall
    137c:	00000073          	ecall
 ret
    1380:	8082                	ret

0000000000001382 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1382:	48f1                	li	a7,28
 ecall
    1384:	00000073          	ecall
 ret
    1388:	8082                	ret

000000000000138a <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    138a:	48f5                	li	a7,29
 ecall
    138c:	00000073          	ecall
 ret
    1390:	8082                	ret

0000000000001392 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1392:	48f9                	li	a7,30
 ecall
    1394:	00000073          	ecall
 ret
    1398:	8082                	ret

000000000000139a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    139a:	1101                	addi	sp,sp,-32
    139c:	ec06                	sd	ra,24(sp)
    139e:	e822                	sd	s0,16(sp)
    13a0:	1000                	addi	s0,sp,32
    13a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13a6:	4605                	li	a2,1
    13a8:	fef40593          	addi	a1,s0,-17
    13ac:	f27ff0ef          	jal	12d2 <write>
}
    13b0:	60e2                	ld	ra,24(sp)
    13b2:	6442                	ld	s0,16(sp)
    13b4:	6105                	addi	sp,sp,32
    13b6:	8082                	ret

00000000000013b8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13b8:	7139                	addi	sp,sp,-64
    13ba:	fc06                	sd	ra,56(sp)
    13bc:	f822                	sd	s0,48(sp)
    13be:	f426                	sd	s1,40(sp)
    13c0:	0080                	addi	s0,sp,64
    13c2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13c4:	c299                	beqz	a3,13ca <printint+0x12>
    13c6:	0805c963          	bltz	a1,1458 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13ca:	2581                	sext.w	a1,a1
  neg = 0;
    13cc:	4881                	li	a7,0
    13ce:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13d2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13d4:	2601                	sext.w	a2,a2
    13d6:	00001517          	auipc	a0,0x1
    13da:	c8250513          	addi	a0,a0,-894 # 2058 <digits>
    13de:	883a                	mv	a6,a4
    13e0:	2705                	addiw	a4,a4,1
    13e2:	02c5f7bb          	remuw	a5,a1,a2
    13e6:	1782                	slli	a5,a5,0x20
    13e8:	9381                	srli	a5,a5,0x20
    13ea:	97aa                	add	a5,a5,a0
    13ec:	0007c783          	lbu	a5,0(a5)
    13f0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    13f4:	0005879b          	sext.w	a5,a1
    13f8:	02c5d5bb          	divuw	a1,a1,a2
    13fc:	0685                	addi	a3,a3,1
    13fe:	fec7f0e3          	bgeu	a5,a2,13de <printint+0x26>
  if(neg)
    1402:	00088c63          	beqz	a7,141a <printint+0x62>
    buf[i++] = '-';
    1406:	fd070793          	addi	a5,a4,-48
    140a:	00878733          	add	a4,a5,s0
    140e:	02d00793          	li	a5,45
    1412:	fef70823          	sb	a5,-16(a4)
    1416:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    141a:	02e05a63          	blez	a4,144e <printint+0x96>
    141e:	f04a                	sd	s2,32(sp)
    1420:	ec4e                	sd	s3,24(sp)
    1422:	fc040793          	addi	a5,s0,-64
    1426:	00e78933          	add	s2,a5,a4
    142a:	fff78993          	addi	s3,a5,-1
    142e:	99ba                	add	s3,s3,a4
    1430:	377d                	addiw	a4,a4,-1
    1432:	1702                	slli	a4,a4,0x20
    1434:	9301                	srli	a4,a4,0x20
    1436:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    143a:	fff94583          	lbu	a1,-1(s2)
    143e:	8526                	mv	a0,s1
    1440:	f5bff0ef          	jal	139a <putc>
  while(--i >= 0)
    1444:	197d                	addi	s2,s2,-1
    1446:	ff391ae3          	bne	s2,s3,143a <printint+0x82>
    144a:	7902                	ld	s2,32(sp)
    144c:	69e2                	ld	s3,24(sp)
}
    144e:	70e2                	ld	ra,56(sp)
    1450:	7442                	ld	s0,48(sp)
    1452:	74a2                	ld	s1,40(sp)
    1454:	6121                	addi	sp,sp,64
    1456:	8082                	ret
    x = -xx;
    1458:	40b005bb          	negw	a1,a1
    neg = 1;
    145c:	4885                	li	a7,1
    x = -xx;
    145e:	bf85                	j	13ce <printint+0x16>

0000000000001460 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1460:	711d                	addi	sp,sp,-96
    1462:	ec86                	sd	ra,88(sp)
    1464:	e8a2                	sd	s0,80(sp)
    1466:	e0ca                	sd	s2,64(sp)
    1468:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    146a:	0005c903          	lbu	s2,0(a1)
    146e:	26090863          	beqz	s2,16de <vprintf+0x27e>
    1472:	e4a6                	sd	s1,72(sp)
    1474:	fc4e                	sd	s3,56(sp)
    1476:	f852                	sd	s4,48(sp)
    1478:	f456                	sd	s5,40(sp)
    147a:	f05a                	sd	s6,32(sp)
    147c:	ec5e                	sd	s7,24(sp)
    147e:	e862                	sd	s8,16(sp)
    1480:	e466                	sd	s9,8(sp)
    1482:	8b2a                	mv	s6,a0
    1484:	8a2e                	mv	s4,a1
    1486:	8bb2                	mv	s7,a2
  state = 0;
    1488:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    148a:	4481                	li	s1,0
    148c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    148e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1492:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1496:	06c00c93          	li	s9,108
    149a:	a005                	j	14ba <vprintf+0x5a>
        putc(fd, c0);
    149c:	85ca                	mv	a1,s2
    149e:	855a                	mv	a0,s6
    14a0:	efbff0ef          	jal	139a <putc>
    14a4:	a019                	j	14aa <vprintf+0x4a>
    } else if(state == '%'){
    14a6:	03598263          	beq	s3,s5,14ca <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    14aa:	2485                	addiw	s1,s1,1
    14ac:	8726                	mv	a4,s1
    14ae:	009a07b3          	add	a5,s4,s1
    14b2:	0007c903          	lbu	s2,0(a5)
    14b6:	20090c63          	beqz	s2,16ce <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    14ba:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14be:	fe0994e3          	bnez	s3,14a6 <vprintf+0x46>
      if(c0 == '%'){
    14c2:	fd579de3          	bne	a5,s5,149c <vprintf+0x3c>
        state = '%';
    14c6:	89be                	mv	s3,a5
    14c8:	b7cd                	j	14aa <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14ca:	00ea06b3          	add	a3,s4,a4
    14ce:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    14d2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    14d4:	c681                	beqz	a3,14dc <vprintf+0x7c>
    14d6:	9752                	add	a4,a4,s4
    14d8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    14dc:	03878f63          	beq	a5,s8,151a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    14e0:	05978963          	beq	a5,s9,1532 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    14e4:	07500713          	li	a4,117
    14e8:	0ee78363          	beq	a5,a4,15ce <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    14ec:	07800713          	li	a4,120
    14f0:	12e78563          	beq	a5,a4,161a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    14f4:	07000713          	li	a4,112
    14f8:	14e78a63          	beq	a5,a4,164c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    14fc:	07300713          	li	a4,115
    1500:	18e78a63          	beq	a5,a4,1694 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1504:	02500713          	li	a4,37
    1508:	04e79563          	bne	a5,a4,1552 <vprintf+0xf2>
        putc(fd, '%');
    150c:	02500593          	li	a1,37
    1510:	855a                	mv	a0,s6
    1512:	e89ff0ef          	jal	139a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1516:	4981                	li	s3,0
    1518:	bf49                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    151a:	008b8913          	addi	s2,s7,8
    151e:	4685                	li	a3,1
    1520:	4629                	li	a2,10
    1522:	000ba583          	lw	a1,0(s7)
    1526:	855a                	mv	a0,s6
    1528:	e91ff0ef          	jal	13b8 <printint>
    152c:	8bca                	mv	s7,s2
      state = 0;
    152e:	4981                	li	s3,0
    1530:	bfad                	j	14aa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1532:	06400793          	li	a5,100
    1536:	02f68963          	beq	a3,a5,1568 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    153a:	06c00793          	li	a5,108
    153e:	04f68263          	beq	a3,a5,1582 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1542:	07500793          	li	a5,117
    1546:	0af68063          	beq	a3,a5,15e6 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    154a:	07800793          	li	a5,120
    154e:	0ef68263          	beq	a3,a5,1632 <vprintf+0x1d2>
        putc(fd, '%');
    1552:	02500593          	li	a1,37
    1556:	855a                	mv	a0,s6
    1558:	e43ff0ef          	jal	139a <putc>
        putc(fd, c0);
    155c:	85ca                	mv	a1,s2
    155e:	855a                	mv	a0,s6
    1560:	e3bff0ef          	jal	139a <putc>
      state = 0;
    1564:	4981                	li	s3,0
    1566:	b791                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1568:	008b8913          	addi	s2,s7,8
    156c:	4685                	li	a3,1
    156e:	4629                	li	a2,10
    1570:	000ba583          	lw	a1,0(s7)
    1574:	855a                	mv	a0,s6
    1576:	e43ff0ef          	jal	13b8 <printint>
        i += 1;
    157a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    157c:	8bca                	mv	s7,s2
      state = 0;
    157e:	4981                	li	s3,0
        i += 1;
    1580:	b72d                	j	14aa <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1582:	06400793          	li	a5,100
    1586:	02f60763          	beq	a2,a5,15b4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    158a:	07500793          	li	a5,117
    158e:	06f60963          	beq	a2,a5,1600 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1592:	07800793          	li	a5,120
    1596:	faf61ee3          	bne	a2,a5,1552 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    159a:	008b8913          	addi	s2,s7,8
    159e:	4681                	li	a3,0
    15a0:	4641                	li	a2,16
    15a2:	000ba583          	lw	a1,0(s7)
    15a6:	855a                	mv	a0,s6
    15a8:	e11ff0ef          	jal	13b8 <printint>
        i += 2;
    15ac:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    15ae:	8bca                	mv	s7,s2
      state = 0;
    15b0:	4981                	li	s3,0
        i += 2;
    15b2:	bde5                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15b4:	008b8913          	addi	s2,s7,8
    15b8:	4685                	li	a3,1
    15ba:	4629                	li	a2,10
    15bc:	000ba583          	lw	a1,0(s7)
    15c0:	855a                	mv	a0,s6
    15c2:	df7ff0ef          	jal	13b8 <printint>
        i += 2;
    15c6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15c8:	8bca                	mv	s7,s2
      state = 0;
    15ca:	4981                	li	s3,0
        i += 2;
    15cc:	bdf9                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    15ce:	008b8913          	addi	s2,s7,8
    15d2:	4681                	li	a3,0
    15d4:	4629                	li	a2,10
    15d6:	000ba583          	lw	a1,0(s7)
    15da:	855a                	mv	a0,s6
    15dc:	dddff0ef          	jal	13b8 <printint>
    15e0:	8bca                	mv	s7,s2
      state = 0;
    15e2:	4981                	li	s3,0
    15e4:	b5d9                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15e6:	008b8913          	addi	s2,s7,8
    15ea:	4681                	li	a3,0
    15ec:	4629                	li	a2,10
    15ee:	000ba583          	lw	a1,0(s7)
    15f2:	855a                	mv	a0,s6
    15f4:	dc5ff0ef          	jal	13b8 <printint>
        i += 1;
    15f8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    15fa:	8bca                	mv	s7,s2
      state = 0;
    15fc:	4981                	li	s3,0
        i += 1;
    15fe:	b575                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1600:	008b8913          	addi	s2,s7,8
    1604:	4681                	li	a3,0
    1606:	4629                	li	a2,10
    1608:	000ba583          	lw	a1,0(s7)
    160c:	855a                	mv	a0,s6
    160e:	dabff0ef          	jal	13b8 <printint>
        i += 2;
    1612:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1614:	8bca                	mv	s7,s2
      state = 0;
    1616:	4981                	li	s3,0
        i += 2;
    1618:	bd49                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    161a:	008b8913          	addi	s2,s7,8
    161e:	4681                	li	a3,0
    1620:	4641                	li	a2,16
    1622:	000ba583          	lw	a1,0(s7)
    1626:	855a                	mv	a0,s6
    1628:	d91ff0ef          	jal	13b8 <printint>
    162c:	8bca                	mv	s7,s2
      state = 0;
    162e:	4981                	li	s3,0
    1630:	bdad                	j	14aa <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1632:	008b8913          	addi	s2,s7,8
    1636:	4681                	li	a3,0
    1638:	4641                	li	a2,16
    163a:	000ba583          	lw	a1,0(s7)
    163e:	855a                	mv	a0,s6
    1640:	d79ff0ef          	jal	13b8 <printint>
        i += 1;
    1644:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1646:	8bca                	mv	s7,s2
      state = 0;
    1648:	4981                	li	s3,0
        i += 1;
    164a:	b585                	j	14aa <vprintf+0x4a>
    164c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    164e:	008b8d13          	addi	s10,s7,8
    1652:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1656:	03000593          	li	a1,48
    165a:	855a                	mv	a0,s6
    165c:	d3fff0ef          	jal	139a <putc>
  putc(fd, 'x');
    1660:	07800593          	li	a1,120
    1664:	855a                	mv	a0,s6
    1666:	d35ff0ef          	jal	139a <putc>
    166a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    166c:	00001b97          	auipc	s7,0x1
    1670:	9ecb8b93          	addi	s7,s7,-1556 # 2058 <digits>
    1674:	03c9d793          	srli	a5,s3,0x3c
    1678:	97de                	add	a5,a5,s7
    167a:	0007c583          	lbu	a1,0(a5)
    167e:	855a                	mv	a0,s6
    1680:	d1bff0ef          	jal	139a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1684:	0992                	slli	s3,s3,0x4
    1686:	397d                	addiw	s2,s2,-1
    1688:	fe0916e3          	bnez	s2,1674 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    168c:	8bea                	mv	s7,s10
      state = 0;
    168e:	4981                	li	s3,0
    1690:	6d02                	ld	s10,0(sp)
    1692:	bd21                	j	14aa <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1694:	008b8993          	addi	s3,s7,8
    1698:	000bb903          	ld	s2,0(s7)
    169c:	00090f63          	beqz	s2,16ba <vprintf+0x25a>
        for(; *s; s++)
    16a0:	00094583          	lbu	a1,0(s2)
    16a4:	c195                	beqz	a1,16c8 <vprintf+0x268>
          putc(fd, *s);
    16a6:	855a                	mv	a0,s6
    16a8:	cf3ff0ef          	jal	139a <putc>
        for(; *s; s++)
    16ac:	0905                	addi	s2,s2,1
    16ae:	00094583          	lbu	a1,0(s2)
    16b2:	f9f5                	bnez	a1,16a6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16b4:	8bce                	mv	s7,s3
      state = 0;
    16b6:	4981                	li	s3,0
    16b8:	bbcd                	j	14aa <vprintf+0x4a>
          s = "(null)";
    16ba:	00001917          	auipc	s2,0x1
    16be:	99690913          	addi	s2,s2,-1642 # 2050 <malloc+0x88a>
        for(; *s; s++)
    16c2:	02800593          	li	a1,40
    16c6:	b7c5                	j	16a6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16c8:	8bce                	mv	s7,s3
      state = 0;
    16ca:	4981                	li	s3,0
    16cc:	bbf9                	j	14aa <vprintf+0x4a>
    16ce:	64a6                	ld	s1,72(sp)
    16d0:	79e2                	ld	s3,56(sp)
    16d2:	7a42                	ld	s4,48(sp)
    16d4:	7aa2                	ld	s5,40(sp)
    16d6:	7b02                	ld	s6,32(sp)
    16d8:	6be2                	ld	s7,24(sp)
    16da:	6c42                	ld	s8,16(sp)
    16dc:	6ca2                	ld	s9,8(sp)
    }
  }
}
    16de:	60e6                	ld	ra,88(sp)
    16e0:	6446                	ld	s0,80(sp)
    16e2:	6906                	ld	s2,64(sp)
    16e4:	6125                	addi	sp,sp,96
    16e6:	8082                	ret

00000000000016e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    16e8:	715d                	addi	sp,sp,-80
    16ea:	ec06                	sd	ra,24(sp)
    16ec:	e822                	sd	s0,16(sp)
    16ee:	1000                	addi	s0,sp,32
    16f0:	e010                	sd	a2,0(s0)
    16f2:	e414                	sd	a3,8(s0)
    16f4:	e818                	sd	a4,16(s0)
    16f6:	ec1c                	sd	a5,24(s0)
    16f8:	03043023          	sd	a6,32(s0)
    16fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1700:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1704:	8622                	mv	a2,s0
    1706:	d5bff0ef          	jal	1460 <vprintf>
}
    170a:	60e2                	ld	ra,24(sp)
    170c:	6442                	ld	s0,16(sp)
    170e:	6161                	addi	sp,sp,80
    1710:	8082                	ret

0000000000001712 <printf>:

void
printf(const char *fmt, ...)
{
    1712:	711d                	addi	sp,sp,-96
    1714:	ec06                	sd	ra,24(sp)
    1716:	e822                	sd	s0,16(sp)
    1718:	1000                	addi	s0,sp,32
    171a:	e40c                	sd	a1,8(s0)
    171c:	e810                	sd	a2,16(s0)
    171e:	ec14                	sd	a3,24(s0)
    1720:	f018                	sd	a4,32(s0)
    1722:	f41c                	sd	a5,40(s0)
    1724:	03043823          	sd	a6,48(s0)
    1728:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    172c:	00840613          	addi	a2,s0,8
    1730:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1734:	85aa                	mv	a1,a0
    1736:	4505                	li	a0,1
    1738:	d29ff0ef          	jal	1460 <vprintf>
}
    173c:	60e2                	ld	ra,24(sp)
    173e:	6442                	ld	s0,16(sp)
    1740:	6125                	addi	sp,sp,96
    1742:	8082                	ret

0000000000001744 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1744:	1141                	addi	sp,sp,-16
    1746:	e422                	sd	s0,8(sp)
    1748:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    174a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    174e:	00001797          	auipc	a5,0x1
    1752:	9227b783          	ld	a5,-1758(a5) # 2070 <freep>
    1756:	a02d                	j	1780 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1758:	4618                	lw	a4,8(a2)
    175a:	9f2d                	addw	a4,a4,a1
    175c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1760:	6398                	ld	a4,0(a5)
    1762:	6310                	ld	a2,0(a4)
    1764:	a83d                	j	17a2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1766:	ff852703          	lw	a4,-8(a0)
    176a:	9f31                	addw	a4,a4,a2
    176c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    176e:	ff053683          	ld	a3,-16(a0)
    1772:	a091                	j	17b6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1774:	6398                	ld	a4,0(a5)
    1776:	00e7e463          	bltu	a5,a4,177e <free+0x3a>
    177a:	00e6ea63          	bltu	a3,a4,178e <free+0x4a>
{
    177e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1780:	fed7fae3          	bgeu	a5,a3,1774 <free+0x30>
    1784:	6398                	ld	a4,0(a5)
    1786:	00e6e463          	bltu	a3,a4,178e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    178a:	fee7eae3          	bltu	a5,a4,177e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    178e:	ff852583          	lw	a1,-8(a0)
    1792:	6390                	ld	a2,0(a5)
    1794:	02059813          	slli	a6,a1,0x20
    1798:	01c85713          	srli	a4,a6,0x1c
    179c:	9736                	add	a4,a4,a3
    179e:	fae60de3          	beq	a2,a4,1758 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    17a2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    17a6:	4790                	lw	a2,8(a5)
    17a8:	02061593          	slli	a1,a2,0x20
    17ac:	01c5d713          	srli	a4,a1,0x1c
    17b0:	973e                	add	a4,a4,a5
    17b2:	fae68ae3          	beq	a3,a4,1766 <free+0x22>
    p->s.ptr = bp->s.ptr;
    17b6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    17b8:	00001717          	auipc	a4,0x1
    17bc:	8af73c23          	sd	a5,-1864(a4) # 2070 <freep>
}
    17c0:	6422                	ld	s0,8(sp)
    17c2:	0141                	addi	sp,sp,16
    17c4:	8082                	ret

00000000000017c6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17c6:	7139                	addi	sp,sp,-64
    17c8:	fc06                	sd	ra,56(sp)
    17ca:	f822                	sd	s0,48(sp)
    17cc:	f426                	sd	s1,40(sp)
    17ce:	ec4e                	sd	s3,24(sp)
    17d0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17d2:	02051493          	slli	s1,a0,0x20
    17d6:	9081                	srli	s1,s1,0x20
    17d8:	04bd                	addi	s1,s1,15
    17da:	8091                	srli	s1,s1,0x4
    17dc:	0014899b          	addiw	s3,s1,1
    17e0:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    17e2:	00001517          	auipc	a0,0x1
    17e6:	88e53503          	ld	a0,-1906(a0) # 2070 <freep>
    17ea:	c915                	beqz	a0,181e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17ec:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    17ee:	4798                	lw	a4,8(a5)
    17f0:	08977a63          	bgeu	a4,s1,1884 <malloc+0xbe>
    17f4:	f04a                	sd	s2,32(sp)
    17f6:	e852                	sd	s4,16(sp)
    17f8:	e456                	sd	s5,8(sp)
    17fa:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    17fc:	8a4e                	mv	s4,s3
    17fe:	0009871b          	sext.w	a4,s3
    1802:	6685                	lui	a3,0x1
    1804:	00d77363          	bgeu	a4,a3,180a <malloc+0x44>
    1808:	6a05                	lui	s4,0x1
    180a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    180e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1812:	00001917          	auipc	s2,0x1
    1816:	85e90913          	addi	s2,s2,-1954 # 2070 <freep>
  if(p == (char*)-1)
    181a:	5afd                	li	s5,-1
    181c:	a081                	j	185c <malloc+0x96>
    181e:	f04a                	sd	s2,32(sp)
    1820:	e852                	sd	s4,16(sp)
    1822:	e456                	sd	s5,8(sp)
    1824:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1826:	00001797          	auipc	a5,0x1
    182a:	85a78793          	addi	a5,a5,-1958 # 2080 <base>
    182e:	00001717          	auipc	a4,0x1
    1832:	84f73123          	sd	a5,-1982(a4) # 2070 <freep>
    1836:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1838:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    183c:	b7c1                	j	17fc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    183e:	6398                	ld	a4,0(a5)
    1840:	e118                	sd	a4,0(a0)
    1842:	a8a9                	j	189c <malloc+0xd6>
  hp->s.size = nu;
    1844:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1848:	0541                	addi	a0,a0,16
    184a:	efbff0ef          	jal	1744 <free>
  return freep;
    184e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1852:	c12d                	beqz	a0,18b4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1854:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1856:	4798                	lw	a4,8(a5)
    1858:	02977263          	bgeu	a4,s1,187c <malloc+0xb6>
    if(p == freep)
    185c:	00093703          	ld	a4,0(s2)
    1860:	853e                	mv	a0,a5
    1862:	fef719e3          	bne	a4,a5,1854 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1866:	8552                	mv	a0,s4
    1868:	ad3ff0ef          	jal	133a <sbrk>
  if(p == (char*)-1)
    186c:	fd551ce3          	bne	a0,s5,1844 <malloc+0x7e>
        return 0;
    1870:	4501                	li	a0,0
    1872:	7902                	ld	s2,32(sp)
    1874:	6a42                	ld	s4,16(sp)
    1876:	6aa2                	ld	s5,8(sp)
    1878:	6b02                	ld	s6,0(sp)
    187a:	a03d                	j	18a8 <malloc+0xe2>
    187c:	7902                	ld	s2,32(sp)
    187e:	6a42                	ld	s4,16(sp)
    1880:	6aa2                	ld	s5,8(sp)
    1882:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1884:	fae48de3          	beq	s1,a4,183e <malloc+0x78>
        p->s.size -= nunits;
    1888:	4137073b          	subw	a4,a4,s3
    188c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    188e:	02071693          	slli	a3,a4,0x20
    1892:	01c6d713          	srli	a4,a3,0x1c
    1896:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1898:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    189c:	00000717          	auipc	a4,0x0
    18a0:	7ca73a23          	sd	a0,2004(a4) # 2070 <freep>
      return (void*)(p + 1);
    18a4:	01078513          	addi	a0,a5,16
  }
}
    18a8:	70e2                	ld	ra,56(sp)
    18aa:	7442                	ld	s0,48(sp)
    18ac:	74a2                	ld	s1,40(sp)
    18ae:	69e2                	ld	s3,24(sp)
    18b0:	6121                	addi	sp,sp,64
    18b2:	8082                	ret
    18b4:	7902                	ld	s2,32(sp)
    18b6:	6a42                	ld	s4,16(sp)
    18b8:	6aa2                	ld	s5,8(sp)
    18ba:	6b02                	ld	s6,0(sp)
    18bc:	b7f5                	j	18a8 <malloc+0xe2>
	...
