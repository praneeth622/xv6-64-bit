
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    1000:	7139                	addi	sp,sp,-64
    1002:	fc06                	sd	ra,56(sp)
    1004:	f822                	sd	s0,48(sp)
    1006:	f426                	sd	s1,40(sp)
    1008:	f04a                	sd	s2,32(sp)
    100a:	ec4e                	sd	s3,24(sp)
    100c:	e852                	sd	s4,16(sp)
    100e:	e456                	sd	s5,8(sp)
    1010:	0080                	addi	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
    1012:	4785                	li	a5,1
    1014:	06a7d063          	bge	a5,a0,1074 <main+0x74>
    1018:	00858493          	addi	s1,a1,8
    101c:	3579                	addiw	a0,a0,-2
    101e:	02051793          	slli	a5,a0,0x20
    1022:	01d7d513          	srli	a0,a5,0x1d
    1026:	00a48a33          	add	s4,s1,a0
    102a:	05c1                	addi	a1,a1,16
    102c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
    1030:	00001a97          	auipc	s5,0x1
    1034:	fd0a8a93          	addi	s5,s5,-48 # 2000 <malloc+0x808>
    1038:	a809                	j	104a <main+0x4a>
    103a:	4605                	li	a2,1
    103c:	85d6                	mv	a1,s5
    103e:	4505                	li	a0,1
    1040:	2c4000ef          	jal	1304 <write>
  for(i = 1; i < argc; i++){
    1044:	04a1                	addi	s1,s1,8
    1046:	03348763          	beq	s1,s3,1074 <main+0x74>
    write(1, argv[i], strlen(argv[i]));
    104a:	0004b903          	ld	s2,0(s1)
    104e:	854a                	mv	a0,s2
    1050:	084000ef          	jal	10d4 <strlen>
    1054:	0005061b          	sext.w	a2,a0
    1058:	85ca                	mv	a1,s2
    105a:	4505                	li	a0,1
    105c:	2a8000ef          	jal	1304 <write>
    if(i + 1 < argc){
    1060:	fd449de3          	bne	s1,s4,103a <main+0x3a>
    } else {
      write(1, "\n", 1);
    1064:	4605                	li	a2,1
    1066:	00001597          	auipc	a1,0x1
    106a:	fa258593          	addi	a1,a1,-94 # 2008 <malloc+0x810>
    106e:	4505                	li	a0,1
    1070:	294000ef          	jal	1304 <write>
    }
  }
  exit(0);
    1074:	4501                	li	a0,0
    1076:	26e000ef          	jal	12e4 <exit>

000000000000107a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    107a:	1141                	addi	sp,sp,-16
    107c:	e406                	sd	ra,8(sp)
    107e:	e022                	sd	s0,0(sp)
    1080:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1082:	f7fff0ef          	jal	1000 <main>
  exit(0);
    1086:	4501                	li	a0,0
    1088:	25c000ef          	jal	12e4 <exit>

000000000000108c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    108c:	1141                	addi	sp,sp,-16
    108e:	e422                	sd	s0,8(sp)
    1090:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1092:	87aa                	mv	a5,a0
    1094:	0585                	addi	a1,a1,1
    1096:	0785                	addi	a5,a5,1
    1098:	fff5c703          	lbu	a4,-1(a1)
    109c:	fee78fa3          	sb	a4,-1(a5)
    10a0:	fb75                	bnez	a4,1094 <strcpy+0x8>
    ;
  return os;
}
    10a2:	6422                	ld	s0,8(sp)
    10a4:	0141                	addi	sp,sp,16
    10a6:	8082                	ret

00000000000010a8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10a8:	1141                	addi	sp,sp,-16
    10aa:	e422                	sd	s0,8(sp)
    10ac:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    10ae:	00054783          	lbu	a5,0(a0)
    10b2:	cb91                	beqz	a5,10c6 <strcmp+0x1e>
    10b4:	0005c703          	lbu	a4,0(a1)
    10b8:	00f71763          	bne	a4,a5,10c6 <strcmp+0x1e>
    p++, q++;
    10bc:	0505                	addi	a0,a0,1
    10be:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    10c0:	00054783          	lbu	a5,0(a0)
    10c4:	fbe5                	bnez	a5,10b4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    10c6:	0005c503          	lbu	a0,0(a1)
}
    10ca:	40a7853b          	subw	a0,a5,a0
    10ce:	6422                	ld	s0,8(sp)
    10d0:	0141                	addi	sp,sp,16
    10d2:	8082                	ret

00000000000010d4 <strlen>:

uint
strlen(const char *s)
{
    10d4:	1141                	addi	sp,sp,-16
    10d6:	e422                	sd	s0,8(sp)
    10d8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10da:	00054783          	lbu	a5,0(a0)
    10de:	cf91                	beqz	a5,10fa <strlen+0x26>
    10e0:	0505                	addi	a0,a0,1
    10e2:	87aa                	mv	a5,a0
    10e4:	86be                	mv	a3,a5
    10e6:	0785                	addi	a5,a5,1
    10e8:	fff7c703          	lbu	a4,-1(a5)
    10ec:	ff65                	bnez	a4,10e4 <strlen+0x10>
    10ee:	40a6853b          	subw	a0,a3,a0
    10f2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    10f4:	6422                	ld	s0,8(sp)
    10f6:	0141                	addi	sp,sp,16
    10f8:	8082                	ret
  for(n = 0; s[n]; n++)
    10fa:	4501                	li	a0,0
    10fc:	bfe5                	j	10f4 <strlen+0x20>

00000000000010fe <memset>:

void*
memset(void *dst, int c, uint n)
{
    10fe:	1141                	addi	sp,sp,-16
    1100:	e422                	sd	s0,8(sp)
    1102:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1104:	ca19                	beqz	a2,111a <memset+0x1c>
    1106:	87aa                	mv	a5,a0
    1108:	1602                	slli	a2,a2,0x20
    110a:	9201                	srli	a2,a2,0x20
    110c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1110:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1114:	0785                	addi	a5,a5,1
    1116:	fee79de3          	bne	a5,a4,1110 <memset+0x12>
  }
  return dst;
}
    111a:	6422                	ld	s0,8(sp)
    111c:	0141                	addi	sp,sp,16
    111e:	8082                	ret

0000000000001120 <strchr>:

char*
strchr(const char *s, char c)
{
    1120:	1141                	addi	sp,sp,-16
    1122:	e422                	sd	s0,8(sp)
    1124:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1126:	00054783          	lbu	a5,0(a0)
    112a:	cb99                	beqz	a5,1140 <strchr+0x20>
    if(*s == c)
    112c:	00f58763          	beq	a1,a5,113a <strchr+0x1a>
  for(; *s; s++)
    1130:	0505                	addi	a0,a0,1
    1132:	00054783          	lbu	a5,0(a0)
    1136:	fbfd                	bnez	a5,112c <strchr+0xc>
      return (char*)s;
  return 0;
    1138:	4501                	li	a0,0
}
    113a:	6422                	ld	s0,8(sp)
    113c:	0141                	addi	sp,sp,16
    113e:	8082                	ret
  return 0;
    1140:	4501                	li	a0,0
    1142:	bfe5                	j	113a <strchr+0x1a>

0000000000001144 <gets>:

char*
gets(char *buf, int max)
{
    1144:	711d                	addi	sp,sp,-96
    1146:	ec86                	sd	ra,88(sp)
    1148:	e8a2                	sd	s0,80(sp)
    114a:	e4a6                	sd	s1,72(sp)
    114c:	e0ca                	sd	s2,64(sp)
    114e:	fc4e                	sd	s3,56(sp)
    1150:	f852                	sd	s4,48(sp)
    1152:	f456                	sd	s5,40(sp)
    1154:	f05a                	sd	s6,32(sp)
    1156:	ec5e                	sd	s7,24(sp)
    1158:	1080                	addi	s0,sp,96
    115a:	8baa                	mv	s7,a0
    115c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    115e:	892a                	mv	s2,a0
    1160:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1162:	4aa9                	li	s5,10
    1164:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1166:	89a6                	mv	s3,s1
    1168:	2485                	addiw	s1,s1,1
    116a:	0344d663          	bge	s1,s4,1196 <gets+0x52>
    cc = read(0, &c, 1);
    116e:	4605                	li	a2,1
    1170:	faf40593          	addi	a1,s0,-81
    1174:	4501                	li	a0,0
    1176:	186000ef          	jal	12fc <read>
    if(cc < 1)
    117a:	00a05e63          	blez	a0,1196 <gets+0x52>
    buf[i++] = c;
    117e:	faf44783          	lbu	a5,-81(s0)
    1182:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1186:	01578763          	beq	a5,s5,1194 <gets+0x50>
    118a:	0905                	addi	s2,s2,1
    118c:	fd679de3          	bne	a5,s6,1166 <gets+0x22>
    buf[i++] = c;
    1190:	89a6                	mv	s3,s1
    1192:	a011                	j	1196 <gets+0x52>
    1194:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1196:	99de                	add	s3,s3,s7
    1198:	00098023          	sb	zero,0(s3)
  return buf;
}
    119c:	855e                	mv	a0,s7
    119e:	60e6                	ld	ra,88(sp)
    11a0:	6446                	ld	s0,80(sp)
    11a2:	64a6                	ld	s1,72(sp)
    11a4:	6906                	ld	s2,64(sp)
    11a6:	79e2                	ld	s3,56(sp)
    11a8:	7a42                	ld	s4,48(sp)
    11aa:	7aa2                	ld	s5,40(sp)
    11ac:	7b02                	ld	s6,32(sp)
    11ae:	6be2                	ld	s7,24(sp)
    11b0:	6125                	addi	sp,sp,96
    11b2:	8082                	ret

00000000000011b4 <stat>:

int
stat(const char *n, struct stat *st)
{
    11b4:	1101                	addi	sp,sp,-32
    11b6:	ec06                	sd	ra,24(sp)
    11b8:	e822                	sd	s0,16(sp)
    11ba:	e04a                	sd	s2,0(sp)
    11bc:	1000                	addi	s0,sp,32
    11be:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11c0:	4581                	li	a1,0
    11c2:	162000ef          	jal	1324 <open>
  if(fd < 0)
    11c6:	02054263          	bltz	a0,11ea <stat+0x36>
    11ca:	e426                	sd	s1,8(sp)
    11cc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11ce:	85ca                	mv	a1,s2
    11d0:	16c000ef          	jal	133c <fstat>
    11d4:	892a                	mv	s2,a0
  close(fd);
    11d6:	8526                	mv	a0,s1
    11d8:	134000ef          	jal	130c <close>
  return r;
    11dc:	64a2                	ld	s1,8(sp)
}
    11de:	854a                	mv	a0,s2
    11e0:	60e2                	ld	ra,24(sp)
    11e2:	6442                	ld	s0,16(sp)
    11e4:	6902                	ld	s2,0(sp)
    11e6:	6105                	addi	sp,sp,32
    11e8:	8082                	ret
    return -1;
    11ea:	597d                	li	s2,-1
    11ec:	bfcd                	j	11de <stat+0x2a>

00000000000011ee <atoi>:

int
atoi(const char *s)
{
    11ee:	1141                	addi	sp,sp,-16
    11f0:	e422                	sd	s0,8(sp)
    11f2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11f4:	00054683          	lbu	a3,0(a0)
    11f8:	fd06879b          	addiw	a5,a3,-48
    11fc:	0ff7f793          	zext.b	a5,a5
    1200:	4625                	li	a2,9
    1202:	02f66863          	bltu	a2,a5,1232 <atoi+0x44>
    1206:	872a                	mv	a4,a0
  n = 0;
    1208:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    120a:	0705                	addi	a4,a4,1
    120c:	0025179b          	slliw	a5,a0,0x2
    1210:	9fa9                	addw	a5,a5,a0
    1212:	0017979b          	slliw	a5,a5,0x1
    1216:	9fb5                	addw	a5,a5,a3
    1218:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    121c:	00074683          	lbu	a3,0(a4)
    1220:	fd06879b          	addiw	a5,a3,-48
    1224:	0ff7f793          	zext.b	a5,a5
    1228:	fef671e3          	bgeu	a2,a5,120a <atoi+0x1c>
  return n;
}
    122c:	6422                	ld	s0,8(sp)
    122e:	0141                	addi	sp,sp,16
    1230:	8082                	ret
  n = 0;
    1232:	4501                	li	a0,0
    1234:	bfe5                	j	122c <atoi+0x3e>

0000000000001236 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1236:	1141                	addi	sp,sp,-16
    1238:	e422                	sd	s0,8(sp)
    123a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    123c:	02b57463          	bgeu	a0,a1,1264 <memmove+0x2e>
    while(n-- > 0)
    1240:	00c05f63          	blez	a2,125e <memmove+0x28>
    1244:	1602                	slli	a2,a2,0x20
    1246:	9201                	srli	a2,a2,0x20
    1248:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    124c:	872a                	mv	a4,a0
      *dst++ = *src++;
    124e:	0585                	addi	a1,a1,1
    1250:	0705                	addi	a4,a4,1
    1252:	fff5c683          	lbu	a3,-1(a1)
    1256:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    125a:	fef71ae3          	bne	a4,a5,124e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    125e:	6422                	ld	s0,8(sp)
    1260:	0141                	addi	sp,sp,16
    1262:	8082                	ret
    dst += n;
    1264:	00c50733          	add	a4,a0,a2
    src += n;
    1268:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    126a:	fec05ae3          	blez	a2,125e <memmove+0x28>
    126e:	fff6079b          	addiw	a5,a2,-1
    1272:	1782                	slli	a5,a5,0x20
    1274:	9381                	srli	a5,a5,0x20
    1276:	fff7c793          	not	a5,a5
    127a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    127c:	15fd                	addi	a1,a1,-1
    127e:	177d                	addi	a4,a4,-1
    1280:	0005c683          	lbu	a3,0(a1)
    1284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1288:	fee79ae3          	bne	a5,a4,127c <memmove+0x46>
    128c:	bfc9                	j	125e <memmove+0x28>

000000000000128e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    128e:	1141                	addi	sp,sp,-16
    1290:	e422                	sd	s0,8(sp)
    1292:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1294:	ca05                	beqz	a2,12c4 <memcmp+0x36>
    1296:	fff6069b          	addiw	a3,a2,-1
    129a:	1682                	slli	a3,a3,0x20
    129c:	9281                	srli	a3,a3,0x20
    129e:	0685                	addi	a3,a3,1
    12a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    12a2:	00054783          	lbu	a5,0(a0)
    12a6:	0005c703          	lbu	a4,0(a1)
    12aa:	00e79863          	bne	a5,a4,12ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    12ae:	0505                	addi	a0,a0,1
    p2++;
    12b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    12b2:	fed518e3          	bne	a0,a3,12a2 <memcmp+0x14>
  }
  return 0;
    12b6:	4501                	li	a0,0
    12b8:	a019                	j	12be <memcmp+0x30>
      return *p1 - *p2;
    12ba:	40e7853b          	subw	a0,a5,a4
}
    12be:	6422                	ld	s0,8(sp)
    12c0:	0141                	addi	sp,sp,16
    12c2:	8082                	ret
  return 0;
    12c4:	4501                	li	a0,0
    12c6:	bfe5                	j	12be <memcmp+0x30>

00000000000012c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    12c8:	1141                	addi	sp,sp,-16
    12ca:	e406                	sd	ra,8(sp)
    12cc:	e022                	sd	s0,0(sp)
    12ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    12d0:	f67ff0ef          	jal	1236 <memmove>
}
    12d4:	60a2                	ld	ra,8(sp)
    12d6:	6402                	ld	s0,0(sp)
    12d8:	0141                	addi	sp,sp,16
    12da:	8082                	ret

00000000000012dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12dc:	4885                	li	a7,1
 ecall
    12de:	00000073          	ecall
 ret
    12e2:	8082                	ret

00000000000012e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    12e4:	4889                	li	a7,2
 ecall
    12e6:	00000073          	ecall
 ret
    12ea:	8082                	ret

00000000000012ec <wait>:
.global wait
wait:
 li a7, SYS_wait
    12ec:	488d                	li	a7,3
 ecall
    12ee:	00000073          	ecall
 ret
    12f2:	8082                	ret

00000000000012f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    12f4:	4891                	li	a7,4
 ecall
    12f6:	00000073          	ecall
 ret
    12fa:	8082                	ret

00000000000012fc <read>:
.global read
read:
 li a7, SYS_read
    12fc:	4895                	li	a7,5
 ecall
    12fe:	00000073          	ecall
 ret
    1302:	8082                	ret

0000000000001304 <write>:
.global write
write:
 li a7, SYS_write
    1304:	48c1                	li	a7,16
 ecall
    1306:	00000073          	ecall
 ret
    130a:	8082                	ret

000000000000130c <close>:
.global close
close:
 li a7, SYS_close
    130c:	48d5                	li	a7,21
 ecall
    130e:	00000073          	ecall
 ret
    1312:	8082                	ret

0000000000001314 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1314:	4899                	li	a7,6
 ecall
    1316:	00000073          	ecall
 ret
    131a:	8082                	ret

000000000000131c <exec>:
.global exec
exec:
 li a7, SYS_exec
    131c:	489d                	li	a7,7
 ecall
    131e:	00000073          	ecall
 ret
    1322:	8082                	ret

0000000000001324 <open>:
.global open
open:
 li a7, SYS_open
    1324:	48bd                	li	a7,15
 ecall
    1326:	00000073          	ecall
 ret
    132a:	8082                	ret

000000000000132c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    132c:	48c5                	li	a7,17
 ecall
    132e:	00000073          	ecall
 ret
    1332:	8082                	ret

0000000000001334 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1334:	48c9                	li	a7,18
 ecall
    1336:	00000073          	ecall
 ret
    133a:	8082                	ret

000000000000133c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    133c:	48a1                	li	a7,8
 ecall
    133e:	00000073          	ecall
 ret
    1342:	8082                	ret

0000000000001344 <link>:
.global link
link:
 li a7, SYS_link
    1344:	48cd                	li	a7,19
 ecall
    1346:	00000073          	ecall
 ret
    134a:	8082                	ret

000000000000134c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    134c:	48d1                	li	a7,20
 ecall
    134e:	00000073          	ecall
 ret
    1352:	8082                	ret

0000000000001354 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1354:	48a5                	li	a7,9
 ecall
    1356:	00000073          	ecall
 ret
    135a:	8082                	ret

000000000000135c <dup>:
.global dup
dup:
 li a7, SYS_dup
    135c:	48a9                	li	a7,10
 ecall
    135e:	00000073          	ecall
 ret
    1362:	8082                	ret

0000000000001364 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1364:	48ad                	li	a7,11
 ecall
    1366:	00000073          	ecall
 ret
    136a:	8082                	ret

000000000000136c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    136c:	48b1                	li	a7,12
 ecall
    136e:	00000073          	ecall
 ret
    1372:	8082                	ret

0000000000001374 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1374:	48b5                	li	a7,13
 ecall
    1376:	00000073          	ecall
 ret
    137a:	8082                	ret

000000000000137c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    137c:	48b9                	li	a7,14
 ecall
    137e:	00000073          	ecall
 ret
    1382:	8082                	ret

0000000000001384 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1384:	48d9                	li	a7,22
 ecall
    1386:	00000073          	ecall
 ret
    138a:	8082                	ret

000000000000138c <signal>:
.global signal
signal:
 li a7, SYS_signal
    138c:	48dd                	li	a7,23
 ecall
    138e:	00000073          	ecall
 ret
    1392:	8082                	ret

0000000000001394 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1394:	48e1                	li	a7,24
 ecall
    1396:	00000073          	ecall
 ret
    139a:	8082                	ret

000000000000139c <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    139c:	48e5                	li	a7,25
 ecall
    139e:	00000073          	ecall
 ret
    13a2:	8082                	ret

00000000000013a4 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    13a4:	48e9                	li	a7,26
 ecall
    13a6:	00000073          	ecall
 ret
    13aa:	8082                	ret

00000000000013ac <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    13ac:	48ed                	li	a7,27
 ecall
    13ae:	00000073          	ecall
 ret
    13b2:	8082                	ret

00000000000013b4 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    13b4:	48f1                	li	a7,28
 ecall
    13b6:	00000073          	ecall
 ret
    13ba:	8082                	ret

00000000000013bc <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    13bc:	48f5                	li	a7,29
 ecall
    13be:	00000073          	ecall
 ret
    13c2:	8082                	ret

00000000000013c4 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    13c4:	48f9                	li	a7,30
 ecall
    13c6:	00000073          	ecall
 ret
    13ca:	8082                	ret

00000000000013cc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    13cc:	1101                	addi	sp,sp,-32
    13ce:	ec06                	sd	ra,24(sp)
    13d0:	e822                	sd	s0,16(sp)
    13d2:	1000                	addi	s0,sp,32
    13d4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13d8:	4605                	li	a2,1
    13da:	fef40593          	addi	a1,s0,-17
    13de:	f27ff0ef          	jal	1304 <write>
}
    13e2:	60e2                	ld	ra,24(sp)
    13e4:	6442                	ld	s0,16(sp)
    13e6:	6105                	addi	sp,sp,32
    13e8:	8082                	ret

00000000000013ea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13ea:	7139                	addi	sp,sp,-64
    13ec:	fc06                	sd	ra,56(sp)
    13ee:	f822                	sd	s0,48(sp)
    13f0:	f426                	sd	s1,40(sp)
    13f2:	0080                	addi	s0,sp,64
    13f4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13f6:	c299                	beqz	a3,13fc <printint+0x12>
    13f8:	0805c963          	bltz	a1,148a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13fc:	2581                	sext.w	a1,a1
  neg = 0;
    13fe:	4881                	li	a7,0
    1400:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1404:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1406:	2601                	sext.w	a2,a2
    1408:	00001517          	auipc	a0,0x1
    140c:	c1050513          	addi	a0,a0,-1008 # 2018 <digits>
    1410:	883a                	mv	a6,a4
    1412:	2705                	addiw	a4,a4,1
    1414:	02c5f7bb          	remuw	a5,a1,a2
    1418:	1782                	slli	a5,a5,0x20
    141a:	9381                	srli	a5,a5,0x20
    141c:	97aa                	add	a5,a5,a0
    141e:	0007c783          	lbu	a5,0(a5)
    1422:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1426:	0005879b          	sext.w	a5,a1
    142a:	02c5d5bb          	divuw	a1,a1,a2
    142e:	0685                	addi	a3,a3,1
    1430:	fec7f0e3          	bgeu	a5,a2,1410 <printint+0x26>
  if(neg)
    1434:	00088c63          	beqz	a7,144c <printint+0x62>
    buf[i++] = '-';
    1438:	fd070793          	addi	a5,a4,-48
    143c:	00878733          	add	a4,a5,s0
    1440:	02d00793          	li	a5,45
    1444:	fef70823          	sb	a5,-16(a4)
    1448:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    144c:	02e05a63          	blez	a4,1480 <printint+0x96>
    1450:	f04a                	sd	s2,32(sp)
    1452:	ec4e                	sd	s3,24(sp)
    1454:	fc040793          	addi	a5,s0,-64
    1458:	00e78933          	add	s2,a5,a4
    145c:	fff78993          	addi	s3,a5,-1
    1460:	99ba                	add	s3,s3,a4
    1462:	377d                	addiw	a4,a4,-1
    1464:	1702                	slli	a4,a4,0x20
    1466:	9301                	srli	a4,a4,0x20
    1468:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    146c:	fff94583          	lbu	a1,-1(s2)
    1470:	8526                	mv	a0,s1
    1472:	f5bff0ef          	jal	13cc <putc>
  while(--i >= 0)
    1476:	197d                	addi	s2,s2,-1
    1478:	ff391ae3          	bne	s2,s3,146c <printint+0x82>
    147c:	7902                	ld	s2,32(sp)
    147e:	69e2                	ld	s3,24(sp)
}
    1480:	70e2                	ld	ra,56(sp)
    1482:	7442                	ld	s0,48(sp)
    1484:	74a2                	ld	s1,40(sp)
    1486:	6121                	addi	sp,sp,64
    1488:	8082                	ret
    x = -xx;
    148a:	40b005bb          	negw	a1,a1
    neg = 1;
    148e:	4885                	li	a7,1
    x = -xx;
    1490:	bf85                	j	1400 <printint+0x16>

0000000000001492 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1492:	711d                	addi	sp,sp,-96
    1494:	ec86                	sd	ra,88(sp)
    1496:	e8a2                	sd	s0,80(sp)
    1498:	e0ca                	sd	s2,64(sp)
    149a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    149c:	0005c903          	lbu	s2,0(a1)
    14a0:	26090863          	beqz	s2,1710 <vprintf+0x27e>
    14a4:	e4a6                	sd	s1,72(sp)
    14a6:	fc4e                	sd	s3,56(sp)
    14a8:	f852                	sd	s4,48(sp)
    14aa:	f456                	sd	s5,40(sp)
    14ac:	f05a                	sd	s6,32(sp)
    14ae:	ec5e                	sd	s7,24(sp)
    14b0:	e862                	sd	s8,16(sp)
    14b2:	e466                	sd	s9,8(sp)
    14b4:	8b2a                	mv	s6,a0
    14b6:	8a2e                	mv	s4,a1
    14b8:	8bb2                	mv	s7,a2
  state = 0;
    14ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    14bc:	4481                	li	s1,0
    14be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    14c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    14c4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    14c8:	06c00c93          	li	s9,108
    14cc:	a005                	j	14ec <vprintf+0x5a>
        putc(fd, c0);
    14ce:	85ca                	mv	a1,s2
    14d0:	855a                	mv	a0,s6
    14d2:	efbff0ef          	jal	13cc <putc>
    14d6:	a019                	j	14dc <vprintf+0x4a>
    } else if(state == '%'){
    14d8:	03598263          	beq	s3,s5,14fc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    14dc:	2485                	addiw	s1,s1,1
    14de:	8726                	mv	a4,s1
    14e0:	009a07b3          	add	a5,s4,s1
    14e4:	0007c903          	lbu	s2,0(a5)
    14e8:	20090c63          	beqz	s2,1700 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    14ec:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14f0:	fe0994e3          	bnez	s3,14d8 <vprintf+0x46>
      if(c0 == '%'){
    14f4:	fd579de3          	bne	a5,s5,14ce <vprintf+0x3c>
        state = '%';
    14f8:	89be                	mv	s3,a5
    14fa:	b7cd                	j	14dc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14fc:	00ea06b3          	add	a3,s4,a4
    1500:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1504:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1506:	c681                	beqz	a3,150e <vprintf+0x7c>
    1508:	9752                	add	a4,a4,s4
    150a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    150e:	03878f63          	beq	a5,s8,154c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1512:	05978963          	beq	a5,s9,1564 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1516:	07500713          	li	a4,117
    151a:	0ee78363          	beq	a5,a4,1600 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    151e:	07800713          	li	a4,120
    1522:	12e78563          	beq	a5,a4,164c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1526:	07000713          	li	a4,112
    152a:	14e78a63          	beq	a5,a4,167e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    152e:	07300713          	li	a4,115
    1532:	18e78a63          	beq	a5,a4,16c6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1536:	02500713          	li	a4,37
    153a:	04e79563          	bne	a5,a4,1584 <vprintf+0xf2>
        putc(fd, '%');
    153e:	02500593          	li	a1,37
    1542:	855a                	mv	a0,s6
    1544:	e89ff0ef          	jal	13cc <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1548:	4981                	li	s3,0
    154a:	bf49                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    154c:	008b8913          	addi	s2,s7,8
    1550:	4685                	li	a3,1
    1552:	4629                	li	a2,10
    1554:	000ba583          	lw	a1,0(s7)
    1558:	855a                	mv	a0,s6
    155a:	e91ff0ef          	jal	13ea <printint>
    155e:	8bca                	mv	s7,s2
      state = 0;
    1560:	4981                	li	s3,0
    1562:	bfad                	j	14dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1564:	06400793          	li	a5,100
    1568:	02f68963          	beq	a3,a5,159a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    156c:	06c00793          	li	a5,108
    1570:	04f68263          	beq	a3,a5,15b4 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1574:	07500793          	li	a5,117
    1578:	0af68063          	beq	a3,a5,1618 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    157c:	07800793          	li	a5,120
    1580:	0ef68263          	beq	a3,a5,1664 <vprintf+0x1d2>
        putc(fd, '%');
    1584:	02500593          	li	a1,37
    1588:	855a                	mv	a0,s6
    158a:	e43ff0ef          	jal	13cc <putc>
        putc(fd, c0);
    158e:	85ca                	mv	a1,s2
    1590:	855a                	mv	a0,s6
    1592:	e3bff0ef          	jal	13cc <putc>
      state = 0;
    1596:	4981                	li	s3,0
    1598:	b791                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    159a:	008b8913          	addi	s2,s7,8
    159e:	4685                	li	a3,1
    15a0:	4629                	li	a2,10
    15a2:	000ba583          	lw	a1,0(s7)
    15a6:	855a                	mv	a0,s6
    15a8:	e43ff0ef          	jal	13ea <printint>
        i += 1;
    15ac:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    15ae:	8bca                	mv	s7,s2
      state = 0;
    15b0:	4981                	li	s3,0
        i += 1;
    15b2:	b72d                	j	14dc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15b4:	06400793          	li	a5,100
    15b8:	02f60763          	beq	a2,a5,15e6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    15bc:	07500793          	li	a5,117
    15c0:	06f60963          	beq	a2,a5,1632 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    15c4:	07800793          	li	a5,120
    15c8:	faf61ee3          	bne	a2,a5,1584 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    15cc:	008b8913          	addi	s2,s7,8
    15d0:	4681                	li	a3,0
    15d2:	4641                	li	a2,16
    15d4:	000ba583          	lw	a1,0(s7)
    15d8:	855a                	mv	a0,s6
    15da:	e11ff0ef          	jal	13ea <printint>
        i += 2;
    15de:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    15e0:	8bca                	mv	s7,s2
      state = 0;
    15e2:	4981                	li	s3,0
        i += 2;
    15e4:	bde5                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15e6:	008b8913          	addi	s2,s7,8
    15ea:	4685                	li	a3,1
    15ec:	4629                	li	a2,10
    15ee:	000ba583          	lw	a1,0(s7)
    15f2:	855a                	mv	a0,s6
    15f4:	df7ff0ef          	jal	13ea <printint>
        i += 2;
    15f8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15fa:	8bca                	mv	s7,s2
      state = 0;
    15fc:	4981                	li	s3,0
        i += 2;
    15fe:	bdf9                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1600:	008b8913          	addi	s2,s7,8
    1604:	4681                	li	a3,0
    1606:	4629                	li	a2,10
    1608:	000ba583          	lw	a1,0(s7)
    160c:	855a                	mv	a0,s6
    160e:	dddff0ef          	jal	13ea <printint>
    1612:	8bca                	mv	s7,s2
      state = 0;
    1614:	4981                	li	s3,0
    1616:	b5d9                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1618:	008b8913          	addi	s2,s7,8
    161c:	4681                	li	a3,0
    161e:	4629                	li	a2,10
    1620:	000ba583          	lw	a1,0(s7)
    1624:	855a                	mv	a0,s6
    1626:	dc5ff0ef          	jal	13ea <printint>
        i += 1;
    162a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    162c:	8bca                	mv	s7,s2
      state = 0;
    162e:	4981                	li	s3,0
        i += 1;
    1630:	b575                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1632:	008b8913          	addi	s2,s7,8
    1636:	4681                	li	a3,0
    1638:	4629                	li	a2,10
    163a:	000ba583          	lw	a1,0(s7)
    163e:	855a                	mv	a0,s6
    1640:	dabff0ef          	jal	13ea <printint>
        i += 2;
    1644:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1646:	8bca                	mv	s7,s2
      state = 0;
    1648:	4981                	li	s3,0
        i += 2;
    164a:	bd49                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    164c:	008b8913          	addi	s2,s7,8
    1650:	4681                	li	a3,0
    1652:	4641                	li	a2,16
    1654:	000ba583          	lw	a1,0(s7)
    1658:	855a                	mv	a0,s6
    165a:	d91ff0ef          	jal	13ea <printint>
    165e:	8bca                	mv	s7,s2
      state = 0;
    1660:	4981                	li	s3,0
    1662:	bdad                	j	14dc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1664:	008b8913          	addi	s2,s7,8
    1668:	4681                	li	a3,0
    166a:	4641                	li	a2,16
    166c:	000ba583          	lw	a1,0(s7)
    1670:	855a                	mv	a0,s6
    1672:	d79ff0ef          	jal	13ea <printint>
        i += 1;
    1676:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1678:	8bca                	mv	s7,s2
      state = 0;
    167a:	4981                	li	s3,0
        i += 1;
    167c:	b585                	j	14dc <vprintf+0x4a>
    167e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1680:	008b8d13          	addi	s10,s7,8
    1684:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1688:	03000593          	li	a1,48
    168c:	855a                	mv	a0,s6
    168e:	d3fff0ef          	jal	13cc <putc>
  putc(fd, 'x');
    1692:	07800593          	li	a1,120
    1696:	855a                	mv	a0,s6
    1698:	d35ff0ef          	jal	13cc <putc>
    169c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    169e:	00001b97          	auipc	s7,0x1
    16a2:	97ab8b93          	addi	s7,s7,-1670 # 2018 <digits>
    16a6:	03c9d793          	srli	a5,s3,0x3c
    16aa:	97de                	add	a5,a5,s7
    16ac:	0007c583          	lbu	a1,0(a5)
    16b0:	855a                	mv	a0,s6
    16b2:	d1bff0ef          	jal	13cc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    16b6:	0992                	slli	s3,s3,0x4
    16b8:	397d                	addiw	s2,s2,-1
    16ba:	fe0916e3          	bnez	s2,16a6 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    16be:	8bea                	mv	s7,s10
      state = 0;
    16c0:	4981                	li	s3,0
    16c2:	6d02                	ld	s10,0(sp)
    16c4:	bd21                	j	14dc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    16c6:	008b8993          	addi	s3,s7,8
    16ca:	000bb903          	ld	s2,0(s7)
    16ce:	00090f63          	beqz	s2,16ec <vprintf+0x25a>
        for(; *s; s++)
    16d2:	00094583          	lbu	a1,0(s2)
    16d6:	c195                	beqz	a1,16fa <vprintf+0x268>
          putc(fd, *s);
    16d8:	855a                	mv	a0,s6
    16da:	cf3ff0ef          	jal	13cc <putc>
        for(; *s; s++)
    16de:	0905                	addi	s2,s2,1
    16e0:	00094583          	lbu	a1,0(s2)
    16e4:	f9f5                	bnez	a1,16d8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16e6:	8bce                	mv	s7,s3
      state = 0;
    16e8:	4981                	li	s3,0
    16ea:	bbcd                	j	14dc <vprintf+0x4a>
          s = "(null)";
    16ec:	00001917          	auipc	s2,0x1
    16f0:	92490913          	addi	s2,s2,-1756 # 2010 <malloc+0x818>
        for(; *s; s++)
    16f4:	02800593          	li	a1,40
    16f8:	b7c5                	j	16d8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16fa:	8bce                	mv	s7,s3
      state = 0;
    16fc:	4981                	li	s3,0
    16fe:	bbf9                	j	14dc <vprintf+0x4a>
    1700:	64a6                	ld	s1,72(sp)
    1702:	79e2                	ld	s3,56(sp)
    1704:	7a42                	ld	s4,48(sp)
    1706:	7aa2                	ld	s5,40(sp)
    1708:	7b02                	ld	s6,32(sp)
    170a:	6be2                	ld	s7,24(sp)
    170c:	6c42                	ld	s8,16(sp)
    170e:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1710:	60e6                	ld	ra,88(sp)
    1712:	6446                	ld	s0,80(sp)
    1714:	6906                	ld	s2,64(sp)
    1716:	6125                	addi	sp,sp,96
    1718:	8082                	ret

000000000000171a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    171a:	715d                	addi	sp,sp,-80
    171c:	ec06                	sd	ra,24(sp)
    171e:	e822                	sd	s0,16(sp)
    1720:	1000                	addi	s0,sp,32
    1722:	e010                	sd	a2,0(s0)
    1724:	e414                	sd	a3,8(s0)
    1726:	e818                	sd	a4,16(s0)
    1728:	ec1c                	sd	a5,24(s0)
    172a:	03043023          	sd	a6,32(s0)
    172e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1732:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1736:	8622                	mv	a2,s0
    1738:	d5bff0ef          	jal	1492 <vprintf>
}
    173c:	60e2                	ld	ra,24(sp)
    173e:	6442                	ld	s0,16(sp)
    1740:	6161                	addi	sp,sp,80
    1742:	8082                	ret

0000000000001744 <printf>:

void
printf(const char *fmt, ...)
{
    1744:	711d                	addi	sp,sp,-96
    1746:	ec06                	sd	ra,24(sp)
    1748:	e822                	sd	s0,16(sp)
    174a:	1000                	addi	s0,sp,32
    174c:	e40c                	sd	a1,8(s0)
    174e:	e810                	sd	a2,16(s0)
    1750:	ec14                	sd	a3,24(s0)
    1752:	f018                	sd	a4,32(s0)
    1754:	f41c                	sd	a5,40(s0)
    1756:	03043823          	sd	a6,48(s0)
    175a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    175e:	00840613          	addi	a2,s0,8
    1762:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1766:	85aa                	mv	a1,a0
    1768:	4505                	li	a0,1
    176a:	d29ff0ef          	jal	1492 <vprintf>
}
    176e:	60e2                	ld	ra,24(sp)
    1770:	6442                	ld	s0,16(sp)
    1772:	6125                	addi	sp,sp,96
    1774:	8082                	ret

0000000000001776 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1776:	1141                	addi	sp,sp,-16
    1778:	e422                	sd	s0,8(sp)
    177a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    177c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1780:	00001797          	auipc	a5,0x1
    1784:	8b07b783          	ld	a5,-1872(a5) # 2030 <freep>
    1788:	a02d                	j	17b2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    178a:	4618                	lw	a4,8(a2)
    178c:	9f2d                	addw	a4,a4,a1
    178e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1792:	6398                	ld	a4,0(a5)
    1794:	6310                	ld	a2,0(a4)
    1796:	a83d                	j	17d4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1798:	ff852703          	lw	a4,-8(a0)
    179c:	9f31                	addw	a4,a4,a2
    179e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    17a0:	ff053683          	ld	a3,-16(a0)
    17a4:	a091                	j	17e8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17a6:	6398                	ld	a4,0(a5)
    17a8:	00e7e463          	bltu	a5,a4,17b0 <free+0x3a>
    17ac:	00e6ea63          	bltu	a3,a4,17c0 <free+0x4a>
{
    17b0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17b2:	fed7fae3          	bgeu	a5,a3,17a6 <free+0x30>
    17b6:	6398                	ld	a4,0(a5)
    17b8:	00e6e463          	bltu	a3,a4,17c0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17bc:	fee7eae3          	bltu	a5,a4,17b0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    17c0:	ff852583          	lw	a1,-8(a0)
    17c4:	6390                	ld	a2,0(a5)
    17c6:	02059813          	slli	a6,a1,0x20
    17ca:	01c85713          	srli	a4,a6,0x1c
    17ce:	9736                	add	a4,a4,a3
    17d0:	fae60de3          	beq	a2,a4,178a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    17d4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    17d8:	4790                	lw	a2,8(a5)
    17da:	02061593          	slli	a1,a2,0x20
    17de:	01c5d713          	srli	a4,a1,0x1c
    17e2:	973e                	add	a4,a4,a5
    17e4:	fae68ae3          	beq	a3,a4,1798 <free+0x22>
    p->s.ptr = bp->s.ptr;
    17e8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    17ea:	00001717          	auipc	a4,0x1
    17ee:	84f73323          	sd	a5,-1978(a4) # 2030 <freep>
}
    17f2:	6422                	ld	s0,8(sp)
    17f4:	0141                	addi	sp,sp,16
    17f6:	8082                	ret

00000000000017f8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17f8:	7139                	addi	sp,sp,-64
    17fa:	fc06                	sd	ra,56(sp)
    17fc:	f822                	sd	s0,48(sp)
    17fe:	f426                	sd	s1,40(sp)
    1800:	ec4e                	sd	s3,24(sp)
    1802:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1804:	02051493          	slli	s1,a0,0x20
    1808:	9081                	srli	s1,s1,0x20
    180a:	04bd                	addi	s1,s1,15
    180c:	8091                	srli	s1,s1,0x4
    180e:	0014899b          	addiw	s3,s1,1
    1812:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1814:	00001517          	auipc	a0,0x1
    1818:	81c53503          	ld	a0,-2020(a0) # 2030 <freep>
    181c:	c915                	beqz	a0,1850 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    181e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1820:	4798                	lw	a4,8(a5)
    1822:	08977a63          	bgeu	a4,s1,18b6 <malloc+0xbe>
    1826:	f04a                	sd	s2,32(sp)
    1828:	e852                	sd	s4,16(sp)
    182a:	e456                	sd	s5,8(sp)
    182c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    182e:	8a4e                	mv	s4,s3
    1830:	0009871b          	sext.w	a4,s3
    1834:	6685                	lui	a3,0x1
    1836:	00d77363          	bgeu	a4,a3,183c <malloc+0x44>
    183a:	6a05                	lui	s4,0x1
    183c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1840:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1844:	00000917          	auipc	s2,0x0
    1848:	7ec90913          	addi	s2,s2,2028 # 2030 <freep>
  if(p == (char*)-1)
    184c:	5afd                	li	s5,-1
    184e:	a081                	j	188e <malloc+0x96>
    1850:	f04a                	sd	s2,32(sp)
    1852:	e852                	sd	s4,16(sp)
    1854:	e456                	sd	s5,8(sp)
    1856:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1858:	00000797          	auipc	a5,0x0
    185c:	7e878793          	addi	a5,a5,2024 # 2040 <base>
    1860:	00000717          	auipc	a4,0x0
    1864:	7cf73823          	sd	a5,2000(a4) # 2030 <freep>
    1868:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    186a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    186e:	b7c1                	j	182e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1870:	6398                	ld	a4,0(a5)
    1872:	e118                	sd	a4,0(a0)
    1874:	a8a9                	j	18ce <malloc+0xd6>
  hp->s.size = nu;
    1876:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    187a:	0541                	addi	a0,a0,16
    187c:	efbff0ef          	jal	1776 <free>
  return freep;
    1880:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1884:	c12d                	beqz	a0,18e6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1886:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1888:	4798                	lw	a4,8(a5)
    188a:	02977263          	bgeu	a4,s1,18ae <malloc+0xb6>
    if(p == freep)
    188e:	00093703          	ld	a4,0(s2)
    1892:	853e                	mv	a0,a5
    1894:	fef719e3          	bne	a4,a5,1886 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1898:	8552                	mv	a0,s4
    189a:	ad3ff0ef          	jal	136c <sbrk>
  if(p == (char*)-1)
    189e:	fd551ce3          	bne	a0,s5,1876 <malloc+0x7e>
        return 0;
    18a2:	4501                	li	a0,0
    18a4:	7902                	ld	s2,32(sp)
    18a6:	6a42                	ld	s4,16(sp)
    18a8:	6aa2                	ld	s5,8(sp)
    18aa:	6b02                	ld	s6,0(sp)
    18ac:	a03d                	j	18da <malloc+0xe2>
    18ae:	7902                	ld	s2,32(sp)
    18b0:	6a42                	ld	s4,16(sp)
    18b2:	6aa2                	ld	s5,8(sp)
    18b4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    18b6:	fae48de3          	beq	s1,a4,1870 <malloc+0x78>
        p->s.size -= nunits;
    18ba:	4137073b          	subw	a4,a4,s3
    18be:	c798                	sw	a4,8(a5)
        p += p->s.size;
    18c0:	02071693          	slli	a3,a4,0x20
    18c4:	01c6d713          	srli	a4,a3,0x1c
    18c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    18ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    18ce:	00000717          	auipc	a4,0x0
    18d2:	76a73123          	sd	a0,1890(a4) # 2030 <freep>
      return (void*)(p + 1);
    18d6:	01078513          	addi	a0,a5,16
  }
}
    18da:	70e2                	ld	ra,56(sp)
    18dc:	7442                	ld	s0,48(sp)
    18de:	74a2                	ld	s1,40(sp)
    18e0:	69e2                	ld	s3,24(sp)
    18e2:	6121                	addi	sp,sp,64
    18e4:	8082                	ret
    18e6:	7902                	ld	s2,32(sp)
    18e8:	6a42                	ld	s4,16(sp)
    18ea:	6aa2                	ld	s5,8(sp)
    18ec:	6b02                	ld	s6,0(sp)
    18ee:	b7f5                	j	18da <malloc+0xe2>
	...
