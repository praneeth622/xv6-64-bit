
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
    1000:	1141                	addi	sp,sp,-16
    1002:	e406                	sd	ra,8(sp)
    1004:	e022                	sd	s0,0(sp)
    1006:	0800                	addi	s0,sp,16
  if(fork() > 0)
    1008:	278000ef          	jal	1280 <fork>
    100c:	00a04563          	bgtz	a0,1016 <main+0x16>
    sleep(5);  // Let child exit before parent.
  exit(0);
    1010:	4501                	li	a0,0
    1012:	276000ef          	jal	1288 <exit>
    sleep(5);  // Let child exit before parent.
    1016:	4515                	li	a0,5
    1018:	300000ef          	jal	1318 <sleep>
    101c:	bfd5                	j	1010 <main+0x10>

000000000000101e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    101e:	1141                	addi	sp,sp,-16
    1020:	e406                	sd	ra,8(sp)
    1022:	e022                	sd	s0,0(sp)
    1024:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1026:	fdbff0ef          	jal	1000 <main>
  exit(0);
    102a:	4501                	li	a0,0
    102c:	25c000ef          	jal	1288 <exit>

0000000000001030 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1030:	1141                	addi	sp,sp,-16
    1032:	e422                	sd	s0,8(sp)
    1034:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1036:	87aa                	mv	a5,a0
    1038:	0585                	addi	a1,a1,1
    103a:	0785                	addi	a5,a5,1
    103c:	fff5c703          	lbu	a4,-1(a1)
    1040:	fee78fa3          	sb	a4,-1(a5)
    1044:	fb75                	bnez	a4,1038 <strcpy+0x8>
    ;
  return os;
}
    1046:	6422                	ld	s0,8(sp)
    1048:	0141                	addi	sp,sp,16
    104a:	8082                	ret

000000000000104c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    104c:	1141                	addi	sp,sp,-16
    104e:	e422                	sd	s0,8(sp)
    1050:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1052:	00054783          	lbu	a5,0(a0)
    1056:	cb91                	beqz	a5,106a <strcmp+0x1e>
    1058:	0005c703          	lbu	a4,0(a1)
    105c:	00f71763          	bne	a4,a5,106a <strcmp+0x1e>
    p++, q++;
    1060:	0505                	addi	a0,a0,1
    1062:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1064:	00054783          	lbu	a5,0(a0)
    1068:	fbe5                	bnez	a5,1058 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    106a:	0005c503          	lbu	a0,0(a1)
}
    106e:	40a7853b          	subw	a0,a5,a0
    1072:	6422                	ld	s0,8(sp)
    1074:	0141                	addi	sp,sp,16
    1076:	8082                	ret

0000000000001078 <strlen>:

uint
strlen(const char *s)
{
    1078:	1141                	addi	sp,sp,-16
    107a:	e422                	sd	s0,8(sp)
    107c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    107e:	00054783          	lbu	a5,0(a0)
    1082:	cf91                	beqz	a5,109e <strlen+0x26>
    1084:	0505                	addi	a0,a0,1
    1086:	87aa                	mv	a5,a0
    1088:	86be                	mv	a3,a5
    108a:	0785                	addi	a5,a5,1
    108c:	fff7c703          	lbu	a4,-1(a5)
    1090:	ff65                	bnez	a4,1088 <strlen+0x10>
    1092:	40a6853b          	subw	a0,a3,a0
    1096:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    1098:	6422                	ld	s0,8(sp)
    109a:	0141                	addi	sp,sp,16
    109c:	8082                	ret
  for(n = 0; s[n]; n++)
    109e:	4501                	li	a0,0
    10a0:	bfe5                	j	1098 <strlen+0x20>

00000000000010a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10a2:	1141                	addi	sp,sp,-16
    10a4:	e422                	sd	s0,8(sp)
    10a6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10a8:	ca19                	beqz	a2,10be <memset+0x1c>
    10aa:	87aa                	mv	a5,a0
    10ac:	1602                	slli	a2,a2,0x20
    10ae:	9201                	srli	a2,a2,0x20
    10b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    10b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10b8:	0785                	addi	a5,a5,1
    10ba:	fee79de3          	bne	a5,a4,10b4 <memset+0x12>
  }
  return dst;
}
    10be:	6422                	ld	s0,8(sp)
    10c0:	0141                	addi	sp,sp,16
    10c2:	8082                	ret

00000000000010c4 <strchr>:

char*
strchr(const char *s, char c)
{
    10c4:	1141                	addi	sp,sp,-16
    10c6:	e422                	sd	s0,8(sp)
    10c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
    10ca:	00054783          	lbu	a5,0(a0)
    10ce:	cb99                	beqz	a5,10e4 <strchr+0x20>
    if(*s == c)
    10d0:	00f58763          	beq	a1,a5,10de <strchr+0x1a>
  for(; *s; s++)
    10d4:	0505                	addi	a0,a0,1
    10d6:	00054783          	lbu	a5,0(a0)
    10da:	fbfd                	bnez	a5,10d0 <strchr+0xc>
      return (char*)s;
  return 0;
    10dc:	4501                	li	a0,0
}
    10de:	6422                	ld	s0,8(sp)
    10e0:	0141                	addi	sp,sp,16
    10e2:	8082                	ret
  return 0;
    10e4:	4501                	li	a0,0
    10e6:	bfe5                	j	10de <strchr+0x1a>

00000000000010e8 <gets>:

char*
gets(char *buf, int max)
{
    10e8:	711d                	addi	sp,sp,-96
    10ea:	ec86                	sd	ra,88(sp)
    10ec:	e8a2                	sd	s0,80(sp)
    10ee:	e4a6                	sd	s1,72(sp)
    10f0:	e0ca                	sd	s2,64(sp)
    10f2:	fc4e                	sd	s3,56(sp)
    10f4:	f852                	sd	s4,48(sp)
    10f6:	f456                	sd	s5,40(sp)
    10f8:	f05a                	sd	s6,32(sp)
    10fa:	ec5e                	sd	s7,24(sp)
    10fc:	1080                	addi	s0,sp,96
    10fe:	8baa                	mv	s7,a0
    1100:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1102:	892a                	mv	s2,a0
    1104:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1106:	4aa9                	li	s5,10
    1108:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    110a:	89a6                	mv	s3,s1
    110c:	2485                	addiw	s1,s1,1
    110e:	0344d663          	bge	s1,s4,113a <gets+0x52>
    cc = read(0, &c, 1);
    1112:	4605                	li	a2,1
    1114:	faf40593          	addi	a1,s0,-81
    1118:	4501                	li	a0,0
    111a:	186000ef          	jal	12a0 <read>
    if(cc < 1)
    111e:	00a05e63          	blez	a0,113a <gets+0x52>
    buf[i++] = c;
    1122:	faf44783          	lbu	a5,-81(s0)
    1126:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    112a:	01578763          	beq	a5,s5,1138 <gets+0x50>
    112e:	0905                	addi	s2,s2,1
    1130:	fd679de3          	bne	a5,s6,110a <gets+0x22>
    buf[i++] = c;
    1134:	89a6                	mv	s3,s1
    1136:	a011                	j	113a <gets+0x52>
    1138:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    113a:	99de                	add	s3,s3,s7
    113c:	00098023          	sb	zero,0(s3)
  return buf;
}
    1140:	855e                	mv	a0,s7
    1142:	60e6                	ld	ra,88(sp)
    1144:	6446                	ld	s0,80(sp)
    1146:	64a6                	ld	s1,72(sp)
    1148:	6906                	ld	s2,64(sp)
    114a:	79e2                	ld	s3,56(sp)
    114c:	7a42                	ld	s4,48(sp)
    114e:	7aa2                	ld	s5,40(sp)
    1150:	7b02                	ld	s6,32(sp)
    1152:	6be2                	ld	s7,24(sp)
    1154:	6125                	addi	sp,sp,96
    1156:	8082                	ret

0000000000001158 <stat>:

int
stat(const char *n, struct stat *st)
{
    1158:	1101                	addi	sp,sp,-32
    115a:	ec06                	sd	ra,24(sp)
    115c:	e822                	sd	s0,16(sp)
    115e:	e04a                	sd	s2,0(sp)
    1160:	1000                	addi	s0,sp,32
    1162:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1164:	4581                	li	a1,0
    1166:	162000ef          	jal	12c8 <open>
  if(fd < 0)
    116a:	02054263          	bltz	a0,118e <stat+0x36>
    116e:	e426                	sd	s1,8(sp)
    1170:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1172:	85ca                	mv	a1,s2
    1174:	16c000ef          	jal	12e0 <fstat>
    1178:	892a                	mv	s2,a0
  close(fd);
    117a:	8526                	mv	a0,s1
    117c:	134000ef          	jal	12b0 <close>
  return r;
    1180:	64a2                	ld	s1,8(sp)
}
    1182:	854a                	mv	a0,s2
    1184:	60e2                	ld	ra,24(sp)
    1186:	6442                	ld	s0,16(sp)
    1188:	6902                	ld	s2,0(sp)
    118a:	6105                	addi	sp,sp,32
    118c:	8082                	ret
    return -1;
    118e:	597d                	li	s2,-1
    1190:	bfcd                	j	1182 <stat+0x2a>

0000000000001192 <atoi>:

int
atoi(const char *s)
{
    1192:	1141                	addi	sp,sp,-16
    1194:	e422                	sd	s0,8(sp)
    1196:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1198:	00054683          	lbu	a3,0(a0)
    119c:	fd06879b          	addiw	a5,a3,-48
    11a0:	0ff7f793          	zext.b	a5,a5
    11a4:	4625                	li	a2,9
    11a6:	02f66863          	bltu	a2,a5,11d6 <atoi+0x44>
    11aa:	872a                	mv	a4,a0
  n = 0;
    11ac:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    11ae:	0705                	addi	a4,a4,1
    11b0:	0025179b          	slliw	a5,a0,0x2
    11b4:	9fa9                	addw	a5,a5,a0
    11b6:	0017979b          	slliw	a5,a5,0x1
    11ba:	9fb5                	addw	a5,a5,a3
    11bc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    11c0:	00074683          	lbu	a3,0(a4)
    11c4:	fd06879b          	addiw	a5,a3,-48
    11c8:	0ff7f793          	zext.b	a5,a5
    11cc:	fef671e3          	bgeu	a2,a5,11ae <atoi+0x1c>
  return n;
}
    11d0:	6422                	ld	s0,8(sp)
    11d2:	0141                	addi	sp,sp,16
    11d4:	8082                	ret
  n = 0;
    11d6:	4501                	li	a0,0
    11d8:	bfe5                	j	11d0 <atoi+0x3e>

00000000000011da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11da:	1141                	addi	sp,sp,-16
    11dc:	e422                	sd	s0,8(sp)
    11de:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    11e0:	02b57463          	bgeu	a0,a1,1208 <memmove+0x2e>
    while(n-- > 0)
    11e4:	00c05f63          	blez	a2,1202 <memmove+0x28>
    11e8:	1602                	slli	a2,a2,0x20
    11ea:	9201                	srli	a2,a2,0x20
    11ec:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    11f0:	872a                	mv	a4,a0
      *dst++ = *src++;
    11f2:	0585                	addi	a1,a1,1
    11f4:	0705                	addi	a4,a4,1
    11f6:	fff5c683          	lbu	a3,-1(a1)
    11fa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    11fe:	fef71ae3          	bne	a4,a5,11f2 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1202:	6422                	ld	s0,8(sp)
    1204:	0141                	addi	sp,sp,16
    1206:	8082                	ret
    dst += n;
    1208:	00c50733          	add	a4,a0,a2
    src += n;
    120c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    120e:	fec05ae3          	blez	a2,1202 <memmove+0x28>
    1212:	fff6079b          	addiw	a5,a2,-1
    1216:	1782                	slli	a5,a5,0x20
    1218:	9381                	srli	a5,a5,0x20
    121a:	fff7c793          	not	a5,a5
    121e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1220:	15fd                	addi	a1,a1,-1
    1222:	177d                	addi	a4,a4,-1
    1224:	0005c683          	lbu	a3,0(a1)
    1228:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    122c:	fee79ae3          	bne	a5,a4,1220 <memmove+0x46>
    1230:	bfc9                	j	1202 <memmove+0x28>

0000000000001232 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1232:	1141                	addi	sp,sp,-16
    1234:	e422                	sd	s0,8(sp)
    1236:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1238:	ca05                	beqz	a2,1268 <memcmp+0x36>
    123a:	fff6069b          	addiw	a3,a2,-1
    123e:	1682                	slli	a3,a3,0x20
    1240:	9281                	srli	a3,a3,0x20
    1242:	0685                	addi	a3,a3,1
    1244:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1246:	00054783          	lbu	a5,0(a0)
    124a:	0005c703          	lbu	a4,0(a1)
    124e:	00e79863          	bne	a5,a4,125e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1252:	0505                	addi	a0,a0,1
    p2++;
    1254:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1256:	fed518e3          	bne	a0,a3,1246 <memcmp+0x14>
  }
  return 0;
    125a:	4501                	li	a0,0
    125c:	a019                	j	1262 <memcmp+0x30>
      return *p1 - *p2;
    125e:	40e7853b          	subw	a0,a5,a4
}
    1262:	6422                	ld	s0,8(sp)
    1264:	0141                	addi	sp,sp,16
    1266:	8082                	ret
  return 0;
    1268:	4501                	li	a0,0
    126a:	bfe5                	j	1262 <memcmp+0x30>

000000000000126c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    126c:	1141                	addi	sp,sp,-16
    126e:	e406                	sd	ra,8(sp)
    1270:	e022                	sd	s0,0(sp)
    1272:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1274:	f67ff0ef          	jal	11da <memmove>
}
    1278:	60a2                	ld	ra,8(sp)
    127a:	6402                	ld	s0,0(sp)
    127c:	0141                	addi	sp,sp,16
    127e:	8082                	ret

0000000000001280 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1280:	4885                	li	a7,1
 ecall
    1282:	00000073          	ecall
 ret
    1286:	8082                	ret

0000000000001288 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1288:	4889                	li	a7,2
 ecall
    128a:	00000073          	ecall
 ret
    128e:	8082                	ret

0000000000001290 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1290:	488d                	li	a7,3
 ecall
    1292:	00000073          	ecall
 ret
    1296:	8082                	ret

0000000000001298 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1298:	4891                	li	a7,4
 ecall
    129a:	00000073          	ecall
 ret
    129e:	8082                	ret

00000000000012a0 <read>:
.global read
read:
 li a7, SYS_read
    12a0:	4895                	li	a7,5
 ecall
    12a2:	00000073          	ecall
 ret
    12a6:	8082                	ret

00000000000012a8 <write>:
.global write
write:
 li a7, SYS_write
    12a8:	48c1                	li	a7,16
 ecall
    12aa:	00000073          	ecall
 ret
    12ae:	8082                	ret

00000000000012b0 <close>:
.global close
close:
 li a7, SYS_close
    12b0:	48d5                	li	a7,21
 ecall
    12b2:	00000073          	ecall
 ret
    12b6:	8082                	ret

00000000000012b8 <kill>:
.global kill
kill:
 li a7, SYS_kill
    12b8:	4899                	li	a7,6
 ecall
    12ba:	00000073          	ecall
 ret
    12be:	8082                	ret

00000000000012c0 <exec>:
.global exec
exec:
 li a7, SYS_exec
    12c0:	489d                	li	a7,7
 ecall
    12c2:	00000073          	ecall
 ret
    12c6:	8082                	ret

00000000000012c8 <open>:
.global open
open:
 li a7, SYS_open
    12c8:	48bd                	li	a7,15
 ecall
    12ca:	00000073          	ecall
 ret
    12ce:	8082                	ret

00000000000012d0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    12d0:	48c5                	li	a7,17
 ecall
    12d2:	00000073          	ecall
 ret
    12d6:	8082                	ret

00000000000012d8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    12d8:	48c9                	li	a7,18
 ecall
    12da:	00000073          	ecall
 ret
    12de:	8082                	ret

00000000000012e0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    12e0:	48a1                	li	a7,8
 ecall
    12e2:	00000073          	ecall
 ret
    12e6:	8082                	ret

00000000000012e8 <link>:
.global link
link:
 li a7, SYS_link
    12e8:	48cd                	li	a7,19
 ecall
    12ea:	00000073          	ecall
 ret
    12ee:	8082                	ret

00000000000012f0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    12f0:	48d1                	li	a7,20
 ecall
    12f2:	00000073          	ecall
 ret
    12f6:	8082                	ret

00000000000012f8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    12f8:	48a5                	li	a7,9
 ecall
    12fa:	00000073          	ecall
 ret
    12fe:	8082                	ret

0000000000001300 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1300:	48a9                	li	a7,10
 ecall
    1302:	00000073          	ecall
 ret
    1306:	8082                	ret

0000000000001308 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1308:	48ad                	li	a7,11
 ecall
    130a:	00000073          	ecall
 ret
    130e:	8082                	ret

0000000000001310 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1310:	48b1                	li	a7,12
 ecall
    1312:	00000073          	ecall
 ret
    1316:	8082                	ret

0000000000001318 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1318:	48b5                	li	a7,13
 ecall
    131a:	00000073          	ecall
 ret
    131e:	8082                	ret

0000000000001320 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1320:	48b9                	li	a7,14
 ecall
    1322:	00000073          	ecall
 ret
    1326:	8082                	ret

0000000000001328 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1328:	48d9                	li	a7,22
 ecall
    132a:	00000073          	ecall
 ret
    132e:	8082                	ret

0000000000001330 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1330:	48dd                	li	a7,23
 ecall
    1332:	00000073          	ecall
 ret
    1336:	8082                	ret

0000000000001338 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1338:	48e1                	li	a7,24
 ecall
    133a:	00000073          	ecall
 ret
    133e:	8082                	ret

0000000000001340 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1340:	48e5                	li	a7,25
 ecall
    1342:	00000073          	ecall
 ret
    1346:	8082                	ret

0000000000001348 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1348:	48e9                	li	a7,26
 ecall
    134a:	00000073          	ecall
 ret
    134e:	8082                	ret

0000000000001350 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    1350:	48ed                	li	a7,27
 ecall
    1352:	00000073          	ecall
 ret
    1356:	8082                	ret

0000000000001358 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1358:	48f1                	li	a7,28
 ecall
    135a:	00000073          	ecall
 ret
    135e:	8082                	ret

0000000000001360 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    1360:	48f5                	li	a7,29
 ecall
    1362:	00000073          	ecall
 ret
    1366:	8082                	ret

0000000000001368 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1368:	48f9                	li	a7,30
 ecall
    136a:	00000073          	ecall
 ret
    136e:	8082                	ret

0000000000001370 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1370:	1101                	addi	sp,sp,-32
    1372:	ec06                	sd	ra,24(sp)
    1374:	e822                	sd	s0,16(sp)
    1376:	1000                	addi	s0,sp,32
    1378:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    137c:	4605                	li	a2,1
    137e:	fef40593          	addi	a1,s0,-17
    1382:	f27ff0ef          	jal	12a8 <write>
}
    1386:	60e2                	ld	ra,24(sp)
    1388:	6442                	ld	s0,16(sp)
    138a:	6105                	addi	sp,sp,32
    138c:	8082                	ret

000000000000138e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    138e:	7139                	addi	sp,sp,-64
    1390:	fc06                	sd	ra,56(sp)
    1392:	f822                	sd	s0,48(sp)
    1394:	f426                	sd	s1,40(sp)
    1396:	0080                	addi	s0,sp,64
    1398:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    139a:	c299                	beqz	a3,13a0 <printint+0x12>
    139c:	0805c963          	bltz	a1,142e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13a0:	2581                	sext.w	a1,a1
  neg = 0;
    13a2:	4881                	li	a7,0
    13a4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13a8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13aa:	2601                	sext.w	a2,a2
    13ac:	00001517          	auipc	a0,0x1
    13b0:	c5c50513          	addi	a0,a0,-932 # 2008 <digits>
    13b4:	883a                	mv	a6,a4
    13b6:	2705                	addiw	a4,a4,1
    13b8:	02c5f7bb          	remuw	a5,a1,a2
    13bc:	1782                	slli	a5,a5,0x20
    13be:	9381                	srli	a5,a5,0x20
    13c0:	97aa                	add	a5,a5,a0
    13c2:	0007c783          	lbu	a5,0(a5)
    13c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    13ca:	0005879b          	sext.w	a5,a1
    13ce:	02c5d5bb          	divuw	a1,a1,a2
    13d2:	0685                	addi	a3,a3,1
    13d4:	fec7f0e3          	bgeu	a5,a2,13b4 <printint+0x26>
  if(neg)
    13d8:	00088c63          	beqz	a7,13f0 <printint+0x62>
    buf[i++] = '-';
    13dc:	fd070793          	addi	a5,a4,-48
    13e0:	00878733          	add	a4,a5,s0
    13e4:	02d00793          	li	a5,45
    13e8:	fef70823          	sb	a5,-16(a4)
    13ec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    13f0:	02e05a63          	blez	a4,1424 <printint+0x96>
    13f4:	f04a                	sd	s2,32(sp)
    13f6:	ec4e                	sd	s3,24(sp)
    13f8:	fc040793          	addi	a5,s0,-64
    13fc:	00e78933          	add	s2,a5,a4
    1400:	fff78993          	addi	s3,a5,-1
    1404:	99ba                	add	s3,s3,a4
    1406:	377d                	addiw	a4,a4,-1
    1408:	1702                	slli	a4,a4,0x20
    140a:	9301                	srli	a4,a4,0x20
    140c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1410:	fff94583          	lbu	a1,-1(s2)
    1414:	8526                	mv	a0,s1
    1416:	f5bff0ef          	jal	1370 <putc>
  while(--i >= 0)
    141a:	197d                	addi	s2,s2,-1
    141c:	ff391ae3          	bne	s2,s3,1410 <printint+0x82>
    1420:	7902                	ld	s2,32(sp)
    1422:	69e2                	ld	s3,24(sp)
}
    1424:	70e2                	ld	ra,56(sp)
    1426:	7442                	ld	s0,48(sp)
    1428:	74a2                	ld	s1,40(sp)
    142a:	6121                	addi	sp,sp,64
    142c:	8082                	ret
    x = -xx;
    142e:	40b005bb          	negw	a1,a1
    neg = 1;
    1432:	4885                	li	a7,1
    x = -xx;
    1434:	bf85                	j	13a4 <printint+0x16>

0000000000001436 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1436:	711d                	addi	sp,sp,-96
    1438:	ec86                	sd	ra,88(sp)
    143a:	e8a2                	sd	s0,80(sp)
    143c:	e0ca                	sd	s2,64(sp)
    143e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1440:	0005c903          	lbu	s2,0(a1)
    1444:	26090863          	beqz	s2,16b4 <vprintf+0x27e>
    1448:	e4a6                	sd	s1,72(sp)
    144a:	fc4e                	sd	s3,56(sp)
    144c:	f852                	sd	s4,48(sp)
    144e:	f456                	sd	s5,40(sp)
    1450:	f05a                	sd	s6,32(sp)
    1452:	ec5e                	sd	s7,24(sp)
    1454:	e862                	sd	s8,16(sp)
    1456:	e466                	sd	s9,8(sp)
    1458:	8b2a                	mv	s6,a0
    145a:	8a2e                	mv	s4,a1
    145c:	8bb2                	mv	s7,a2
  state = 0;
    145e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1460:	4481                	li	s1,0
    1462:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1464:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1468:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    146c:	06c00c93          	li	s9,108
    1470:	a005                	j	1490 <vprintf+0x5a>
        putc(fd, c0);
    1472:	85ca                	mv	a1,s2
    1474:	855a                	mv	a0,s6
    1476:	efbff0ef          	jal	1370 <putc>
    147a:	a019                	j	1480 <vprintf+0x4a>
    } else if(state == '%'){
    147c:	03598263          	beq	s3,s5,14a0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    1480:	2485                	addiw	s1,s1,1
    1482:	8726                	mv	a4,s1
    1484:	009a07b3          	add	a5,s4,s1
    1488:	0007c903          	lbu	s2,0(a5)
    148c:	20090c63          	beqz	s2,16a4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    1490:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1494:	fe0994e3          	bnez	s3,147c <vprintf+0x46>
      if(c0 == '%'){
    1498:	fd579de3          	bne	a5,s5,1472 <vprintf+0x3c>
        state = '%';
    149c:	89be                	mv	s3,a5
    149e:	b7cd                	j	1480 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14a0:	00ea06b3          	add	a3,s4,a4
    14a4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    14a8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    14aa:	c681                	beqz	a3,14b2 <vprintf+0x7c>
    14ac:	9752                	add	a4,a4,s4
    14ae:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    14b2:	03878f63          	beq	a5,s8,14f0 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    14b6:	05978963          	beq	a5,s9,1508 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    14ba:	07500713          	li	a4,117
    14be:	0ee78363          	beq	a5,a4,15a4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    14c2:	07800713          	li	a4,120
    14c6:	12e78563          	beq	a5,a4,15f0 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    14ca:	07000713          	li	a4,112
    14ce:	14e78a63          	beq	a5,a4,1622 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    14d2:	07300713          	li	a4,115
    14d6:	18e78a63          	beq	a5,a4,166a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    14da:	02500713          	li	a4,37
    14de:	04e79563          	bne	a5,a4,1528 <vprintf+0xf2>
        putc(fd, '%');
    14e2:	02500593          	li	a1,37
    14e6:	855a                	mv	a0,s6
    14e8:	e89ff0ef          	jal	1370 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    14ec:	4981                	li	s3,0
    14ee:	bf49                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    14f0:	008b8913          	addi	s2,s7,8
    14f4:	4685                	li	a3,1
    14f6:	4629                	li	a2,10
    14f8:	000ba583          	lw	a1,0(s7)
    14fc:	855a                	mv	a0,s6
    14fe:	e91ff0ef          	jal	138e <printint>
    1502:	8bca                	mv	s7,s2
      state = 0;
    1504:	4981                	li	s3,0
    1506:	bfad                	j	1480 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1508:	06400793          	li	a5,100
    150c:	02f68963          	beq	a3,a5,153e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1510:	06c00793          	li	a5,108
    1514:	04f68263          	beq	a3,a5,1558 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1518:	07500793          	li	a5,117
    151c:	0af68063          	beq	a3,a5,15bc <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1520:	07800793          	li	a5,120
    1524:	0ef68263          	beq	a3,a5,1608 <vprintf+0x1d2>
        putc(fd, '%');
    1528:	02500593          	li	a1,37
    152c:	855a                	mv	a0,s6
    152e:	e43ff0ef          	jal	1370 <putc>
        putc(fd, c0);
    1532:	85ca                	mv	a1,s2
    1534:	855a                	mv	a0,s6
    1536:	e3bff0ef          	jal	1370 <putc>
      state = 0;
    153a:	4981                	li	s3,0
    153c:	b791                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    153e:	008b8913          	addi	s2,s7,8
    1542:	4685                	li	a3,1
    1544:	4629                	li	a2,10
    1546:	000ba583          	lw	a1,0(s7)
    154a:	855a                	mv	a0,s6
    154c:	e43ff0ef          	jal	138e <printint>
        i += 1;
    1550:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1552:	8bca                	mv	s7,s2
      state = 0;
    1554:	4981                	li	s3,0
        i += 1;
    1556:	b72d                	j	1480 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1558:	06400793          	li	a5,100
    155c:	02f60763          	beq	a2,a5,158a <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1560:	07500793          	li	a5,117
    1564:	06f60963          	beq	a2,a5,15d6 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1568:	07800793          	li	a5,120
    156c:	faf61ee3          	bne	a2,a5,1528 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1570:	008b8913          	addi	s2,s7,8
    1574:	4681                	li	a3,0
    1576:	4641                	li	a2,16
    1578:	000ba583          	lw	a1,0(s7)
    157c:	855a                	mv	a0,s6
    157e:	e11ff0ef          	jal	138e <printint>
        i += 2;
    1582:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1584:	8bca                	mv	s7,s2
      state = 0;
    1586:	4981                	li	s3,0
        i += 2;
    1588:	bde5                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    158a:	008b8913          	addi	s2,s7,8
    158e:	4685                	li	a3,1
    1590:	4629                	li	a2,10
    1592:	000ba583          	lw	a1,0(s7)
    1596:	855a                	mv	a0,s6
    1598:	df7ff0ef          	jal	138e <printint>
        i += 2;
    159c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    159e:	8bca                	mv	s7,s2
      state = 0;
    15a0:	4981                	li	s3,0
        i += 2;
    15a2:	bdf9                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    15a4:	008b8913          	addi	s2,s7,8
    15a8:	4681                	li	a3,0
    15aa:	4629                	li	a2,10
    15ac:	000ba583          	lw	a1,0(s7)
    15b0:	855a                	mv	a0,s6
    15b2:	dddff0ef          	jal	138e <printint>
    15b6:	8bca                	mv	s7,s2
      state = 0;
    15b8:	4981                	li	s3,0
    15ba:	b5d9                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15bc:	008b8913          	addi	s2,s7,8
    15c0:	4681                	li	a3,0
    15c2:	4629                	li	a2,10
    15c4:	000ba583          	lw	a1,0(s7)
    15c8:	855a                	mv	a0,s6
    15ca:	dc5ff0ef          	jal	138e <printint>
        i += 1;
    15ce:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    15d0:	8bca                	mv	s7,s2
      state = 0;
    15d2:	4981                	li	s3,0
        i += 1;
    15d4:	b575                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15d6:	008b8913          	addi	s2,s7,8
    15da:	4681                	li	a3,0
    15dc:	4629                	li	a2,10
    15de:	000ba583          	lw	a1,0(s7)
    15e2:	855a                	mv	a0,s6
    15e4:	dabff0ef          	jal	138e <printint>
        i += 2;
    15e8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    15ea:	8bca                	mv	s7,s2
      state = 0;
    15ec:	4981                	li	s3,0
        i += 2;
    15ee:	bd49                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    15f0:	008b8913          	addi	s2,s7,8
    15f4:	4681                	li	a3,0
    15f6:	4641                	li	a2,16
    15f8:	000ba583          	lw	a1,0(s7)
    15fc:	855a                	mv	a0,s6
    15fe:	d91ff0ef          	jal	138e <printint>
    1602:	8bca                	mv	s7,s2
      state = 0;
    1604:	4981                	li	s3,0
    1606:	bdad                	j	1480 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1608:	008b8913          	addi	s2,s7,8
    160c:	4681                	li	a3,0
    160e:	4641                	li	a2,16
    1610:	000ba583          	lw	a1,0(s7)
    1614:	855a                	mv	a0,s6
    1616:	d79ff0ef          	jal	138e <printint>
        i += 1;
    161a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    161c:	8bca                	mv	s7,s2
      state = 0;
    161e:	4981                	li	s3,0
        i += 1;
    1620:	b585                	j	1480 <vprintf+0x4a>
    1622:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1624:	008b8d13          	addi	s10,s7,8
    1628:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    162c:	03000593          	li	a1,48
    1630:	855a                	mv	a0,s6
    1632:	d3fff0ef          	jal	1370 <putc>
  putc(fd, 'x');
    1636:	07800593          	li	a1,120
    163a:	855a                	mv	a0,s6
    163c:	d35ff0ef          	jal	1370 <putc>
    1640:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1642:	00001b97          	auipc	s7,0x1
    1646:	9c6b8b93          	addi	s7,s7,-1594 # 2008 <digits>
    164a:	03c9d793          	srli	a5,s3,0x3c
    164e:	97de                	add	a5,a5,s7
    1650:	0007c583          	lbu	a1,0(a5)
    1654:	855a                	mv	a0,s6
    1656:	d1bff0ef          	jal	1370 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    165a:	0992                	slli	s3,s3,0x4
    165c:	397d                	addiw	s2,s2,-1
    165e:	fe0916e3          	bnez	s2,164a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1662:	8bea                	mv	s7,s10
      state = 0;
    1664:	4981                	li	s3,0
    1666:	6d02                	ld	s10,0(sp)
    1668:	bd21                	j	1480 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    166a:	008b8993          	addi	s3,s7,8
    166e:	000bb903          	ld	s2,0(s7)
    1672:	00090f63          	beqz	s2,1690 <vprintf+0x25a>
        for(; *s; s++)
    1676:	00094583          	lbu	a1,0(s2)
    167a:	c195                	beqz	a1,169e <vprintf+0x268>
          putc(fd, *s);
    167c:	855a                	mv	a0,s6
    167e:	cf3ff0ef          	jal	1370 <putc>
        for(; *s; s++)
    1682:	0905                	addi	s2,s2,1
    1684:	00094583          	lbu	a1,0(s2)
    1688:	f9f5                	bnez	a1,167c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    168a:	8bce                	mv	s7,s3
      state = 0;
    168c:	4981                	li	s3,0
    168e:	bbcd                	j	1480 <vprintf+0x4a>
          s = "(null)";
    1690:	00001917          	auipc	s2,0x1
    1694:	97090913          	addi	s2,s2,-1680 # 2000 <malloc+0x864>
        for(; *s; s++)
    1698:	02800593          	li	a1,40
    169c:	b7c5                	j	167c <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    169e:	8bce                	mv	s7,s3
      state = 0;
    16a0:	4981                	li	s3,0
    16a2:	bbf9                	j	1480 <vprintf+0x4a>
    16a4:	64a6                	ld	s1,72(sp)
    16a6:	79e2                	ld	s3,56(sp)
    16a8:	7a42                	ld	s4,48(sp)
    16aa:	7aa2                	ld	s5,40(sp)
    16ac:	7b02                	ld	s6,32(sp)
    16ae:	6be2                	ld	s7,24(sp)
    16b0:	6c42                	ld	s8,16(sp)
    16b2:	6ca2                	ld	s9,8(sp)
    }
  }
}
    16b4:	60e6                	ld	ra,88(sp)
    16b6:	6446                	ld	s0,80(sp)
    16b8:	6906                	ld	s2,64(sp)
    16ba:	6125                	addi	sp,sp,96
    16bc:	8082                	ret

00000000000016be <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    16be:	715d                	addi	sp,sp,-80
    16c0:	ec06                	sd	ra,24(sp)
    16c2:	e822                	sd	s0,16(sp)
    16c4:	1000                	addi	s0,sp,32
    16c6:	e010                	sd	a2,0(s0)
    16c8:	e414                	sd	a3,8(s0)
    16ca:	e818                	sd	a4,16(s0)
    16cc:	ec1c                	sd	a5,24(s0)
    16ce:	03043023          	sd	a6,32(s0)
    16d2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    16d6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    16da:	8622                	mv	a2,s0
    16dc:	d5bff0ef          	jal	1436 <vprintf>
}
    16e0:	60e2                	ld	ra,24(sp)
    16e2:	6442                	ld	s0,16(sp)
    16e4:	6161                	addi	sp,sp,80
    16e6:	8082                	ret

00000000000016e8 <printf>:

void
printf(const char *fmt, ...)
{
    16e8:	711d                	addi	sp,sp,-96
    16ea:	ec06                	sd	ra,24(sp)
    16ec:	e822                	sd	s0,16(sp)
    16ee:	1000                	addi	s0,sp,32
    16f0:	e40c                	sd	a1,8(s0)
    16f2:	e810                	sd	a2,16(s0)
    16f4:	ec14                	sd	a3,24(s0)
    16f6:	f018                	sd	a4,32(s0)
    16f8:	f41c                	sd	a5,40(s0)
    16fa:	03043823          	sd	a6,48(s0)
    16fe:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1702:	00840613          	addi	a2,s0,8
    1706:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    170a:	85aa                	mv	a1,a0
    170c:	4505                	li	a0,1
    170e:	d29ff0ef          	jal	1436 <vprintf>
}
    1712:	60e2                	ld	ra,24(sp)
    1714:	6442                	ld	s0,16(sp)
    1716:	6125                	addi	sp,sp,96
    1718:	8082                	ret

000000000000171a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    171a:	1141                	addi	sp,sp,-16
    171c:	e422                	sd	s0,8(sp)
    171e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1720:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1724:	00001797          	auipc	a5,0x1
    1728:	8fc7b783          	ld	a5,-1796(a5) # 2020 <freep>
    172c:	a02d                	j	1756 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    172e:	4618                	lw	a4,8(a2)
    1730:	9f2d                	addw	a4,a4,a1
    1732:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1736:	6398                	ld	a4,0(a5)
    1738:	6310                	ld	a2,0(a4)
    173a:	a83d                	j	1778 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    173c:	ff852703          	lw	a4,-8(a0)
    1740:	9f31                	addw	a4,a4,a2
    1742:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1744:	ff053683          	ld	a3,-16(a0)
    1748:	a091                	j	178c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    174a:	6398                	ld	a4,0(a5)
    174c:	00e7e463          	bltu	a5,a4,1754 <free+0x3a>
    1750:	00e6ea63          	bltu	a3,a4,1764 <free+0x4a>
{
    1754:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1756:	fed7fae3          	bgeu	a5,a3,174a <free+0x30>
    175a:	6398                	ld	a4,0(a5)
    175c:	00e6e463          	bltu	a3,a4,1764 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1760:	fee7eae3          	bltu	a5,a4,1754 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1764:	ff852583          	lw	a1,-8(a0)
    1768:	6390                	ld	a2,0(a5)
    176a:	02059813          	slli	a6,a1,0x20
    176e:	01c85713          	srli	a4,a6,0x1c
    1772:	9736                	add	a4,a4,a3
    1774:	fae60de3          	beq	a2,a4,172e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1778:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    177c:	4790                	lw	a2,8(a5)
    177e:	02061593          	slli	a1,a2,0x20
    1782:	01c5d713          	srli	a4,a1,0x1c
    1786:	973e                	add	a4,a4,a5
    1788:	fae68ae3          	beq	a3,a4,173c <free+0x22>
    p->s.ptr = bp->s.ptr;
    178c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    178e:	00001717          	auipc	a4,0x1
    1792:	88f73923          	sd	a5,-1902(a4) # 2020 <freep>
}
    1796:	6422                	ld	s0,8(sp)
    1798:	0141                	addi	sp,sp,16
    179a:	8082                	ret

000000000000179c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    179c:	7139                	addi	sp,sp,-64
    179e:	fc06                	sd	ra,56(sp)
    17a0:	f822                	sd	s0,48(sp)
    17a2:	f426                	sd	s1,40(sp)
    17a4:	ec4e                	sd	s3,24(sp)
    17a6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17a8:	02051493          	slli	s1,a0,0x20
    17ac:	9081                	srli	s1,s1,0x20
    17ae:	04bd                	addi	s1,s1,15
    17b0:	8091                	srli	s1,s1,0x4
    17b2:	0014899b          	addiw	s3,s1,1
    17b6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    17b8:	00001517          	auipc	a0,0x1
    17bc:	86853503          	ld	a0,-1944(a0) # 2020 <freep>
    17c0:	c915                	beqz	a0,17f4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    17c4:	4798                	lw	a4,8(a5)
    17c6:	08977a63          	bgeu	a4,s1,185a <malloc+0xbe>
    17ca:	f04a                	sd	s2,32(sp)
    17cc:	e852                	sd	s4,16(sp)
    17ce:	e456                	sd	s5,8(sp)
    17d0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    17d2:	8a4e                	mv	s4,s3
    17d4:	0009871b          	sext.w	a4,s3
    17d8:	6685                	lui	a3,0x1
    17da:	00d77363          	bgeu	a4,a3,17e0 <malloc+0x44>
    17de:	6a05                	lui	s4,0x1
    17e0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    17e4:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17e8:	00001917          	auipc	s2,0x1
    17ec:	83890913          	addi	s2,s2,-1992 # 2020 <freep>
  if(p == (char*)-1)
    17f0:	5afd                	li	s5,-1
    17f2:	a081                	j	1832 <malloc+0x96>
    17f4:	f04a                	sd	s2,32(sp)
    17f6:	e852                	sd	s4,16(sp)
    17f8:	e456                	sd	s5,8(sp)
    17fa:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    17fc:	00001797          	auipc	a5,0x1
    1800:	83478793          	addi	a5,a5,-1996 # 2030 <base>
    1804:	00001717          	auipc	a4,0x1
    1808:	80f73e23          	sd	a5,-2020(a4) # 2020 <freep>
    180c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    180e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1812:	b7c1                	j	17d2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1814:	6398                	ld	a4,0(a5)
    1816:	e118                	sd	a4,0(a0)
    1818:	a8a9                	j	1872 <malloc+0xd6>
  hp->s.size = nu;
    181a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    181e:	0541                	addi	a0,a0,16
    1820:	efbff0ef          	jal	171a <free>
  return freep;
    1824:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1828:	c12d                	beqz	a0,188a <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    182a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    182c:	4798                	lw	a4,8(a5)
    182e:	02977263          	bgeu	a4,s1,1852 <malloc+0xb6>
    if(p == freep)
    1832:	00093703          	ld	a4,0(s2)
    1836:	853e                	mv	a0,a5
    1838:	fef719e3          	bne	a4,a5,182a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    183c:	8552                	mv	a0,s4
    183e:	ad3ff0ef          	jal	1310 <sbrk>
  if(p == (char*)-1)
    1842:	fd551ce3          	bne	a0,s5,181a <malloc+0x7e>
        return 0;
    1846:	4501                	li	a0,0
    1848:	7902                	ld	s2,32(sp)
    184a:	6a42                	ld	s4,16(sp)
    184c:	6aa2                	ld	s5,8(sp)
    184e:	6b02                	ld	s6,0(sp)
    1850:	a03d                	j	187e <malloc+0xe2>
    1852:	7902                	ld	s2,32(sp)
    1854:	6a42                	ld	s4,16(sp)
    1856:	6aa2                	ld	s5,8(sp)
    1858:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    185a:	fae48de3          	beq	s1,a4,1814 <malloc+0x78>
        p->s.size -= nunits;
    185e:	4137073b          	subw	a4,a4,s3
    1862:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1864:	02071693          	slli	a3,a4,0x20
    1868:	01c6d713          	srli	a4,a3,0x1c
    186c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    186e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1872:	00000717          	auipc	a4,0x0
    1876:	7aa73723          	sd	a0,1966(a4) # 2020 <freep>
      return (void*)(p + 1);
    187a:	01078513          	addi	a0,a5,16
  }
}
    187e:	70e2                	ld	ra,56(sp)
    1880:	7442                	ld	s0,48(sp)
    1882:	74a2                	ld	s1,40(sp)
    1884:	69e2                	ld	s3,24(sp)
    1886:	6121                	addi	sp,sp,64
    1888:	8082                	ret
    188a:	7902                	ld	s2,32(sp)
    188c:	6a42                	ld	s4,16(sp)
    188e:	6aa2                	ld	s5,8(sp)
    1890:	6b02                	ld	s6,0(sp)
    1892:	b7f5                	j	187e <malloc+0xe2>
	...
