
user/_cps:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/types.h"
#include "user.h"
// #include "fcntl.h"

int
main(int argc, char *argv[]){
    1000:	1141                	addi	sp,sp,-16
    1002:	e406                	sd	ra,8(sp)
    1004:	e022                	sd	s0,0(sp)
    1006:	0800                	addi	s0,sp,16
    int k = cps();
    1008:	322000ef          	jal	132a <cps>
    100c:	85aa                	mv	a1,a0
    printf("%d\n", k);
    100e:	00001517          	auipc	a0,0x1
    1012:	ff250513          	addi	a0,a0,-14 # 2000 <malloc+0x862>
    1016:	6d4000ef          	jal	16ea <printf>
    exit(0);
    101a:	4501                	li	a0,0
    101c:	26e000ef          	jal	128a <exit>

0000000000001020 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    1020:	1141                	addi	sp,sp,-16
    1022:	e406                	sd	ra,8(sp)
    1024:	e022                	sd	s0,0(sp)
    1026:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1028:	fd9ff0ef          	jal	1000 <main>
  exit(0);
    102c:	4501                	li	a0,0
    102e:	25c000ef          	jal	128a <exit>

0000000000001032 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1032:	1141                	addi	sp,sp,-16
    1034:	e422                	sd	s0,8(sp)
    1036:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1038:	87aa                	mv	a5,a0
    103a:	0585                	addi	a1,a1,1
    103c:	0785                	addi	a5,a5,1
    103e:	fff5c703          	lbu	a4,-1(a1)
    1042:	fee78fa3          	sb	a4,-1(a5)
    1046:	fb75                	bnez	a4,103a <strcpy+0x8>
    ;
  return os;
}
    1048:	6422                	ld	s0,8(sp)
    104a:	0141                	addi	sp,sp,16
    104c:	8082                	ret

000000000000104e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    104e:	1141                	addi	sp,sp,-16
    1050:	e422                	sd	s0,8(sp)
    1052:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1054:	00054783          	lbu	a5,0(a0)
    1058:	cb91                	beqz	a5,106c <strcmp+0x1e>
    105a:	0005c703          	lbu	a4,0(a1)
    105e:	00f71763          	bne	a4,a5,106c <strcmp+0x1e>
    p++, q++;
    1062:	0505                	addi	a0,a0,1
    1064:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1066:	00054783          	lbu	a5,0(a0)
    106a:	fbe5                	bnez	a5,105a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    106c:	0005c503          	lbu	a0,0(a1)
}
    1070:	40a7853b          	subw	a0,a5,a0
    1074:	6422                	ld	s0,8(sp)
    1076:	0141                	addi	sp,sp,16
    1078:	8082                	ret

000000000000107a <strlen>:

uint
strlen(const char *s)
{
    107a:	1141                	addi	sp,sp,-16
    107c:	e422                	sd	s0,8(sp)
    107e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1080:	00054783          	lbu	a5,0(a0)
    1084:	cf91                	beqz	a5,10a0 <strlen+0x26>
    1086:	0505                	addi	a0,a0,1
    1088:	87aa                	mv	a5,a0
    108a:	86be                	mv	a3,a5
    108c:	0785                	addi	a5,a5,1
    108e:	fff7c703          	lbu	a4,-1(a5)
    1092:	ff65                	bnez	a4,108a <strlen+0x10>
    1094:	40a6853b          	subw	a0,a3,a0
    1098:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    109a:	6422                	ld	s0,8(sp)
    109c:	0141                	addi	sp,sp,16
    109e:	8082                	ret
  for(n = 0; s[n]; n++)
    10a0:	4501                	li	a0,0
    10a2:	bfe5                	j	109a <strlen+0x20>

00000000000010a4 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10a4:	1141                	addi	sp,sp,-16
    10a6:	e422                	sd	s0,8(sp)
    10a8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10aa:	ca19                	beqz	a2,10c0 <memset+0x1c>
    10ac:	87aa                	mv	a5,a0
    10ae:	1602                	slli	a2,a2,0x20
    10b0:	9201                	srli	a2,a2,0x20
    10b2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    10b6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10ba:	0785                	addi	a5,a5,1
    10bc:	fee79de3          	bne	a5,a4,10b6 <memset+0x12>
  }
  return dst;
}
    10c0:	6422                	ld	s0,8(sp)
    10c2:	0141                	addi	sp,sp,16
    10c4:	8082                	ret

00000000000010c6 <strchr>:

char*
strchr(const char *s, char c)
{
    10c6:	1141                	addi	sp,sp,-16
    10c8:	e422                	sd	s0,8(sp)
    10ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
    10cc:	00054783          	lbu	a5,0(a0)
    10d0:	cb99                	beqz	a5,10e6 <strchr+0x20>
    if(*s == c)
    10d2:	00f58763          	beq	a1,a5,10e0 <strchr+0x1a>
  for(; *s; s++)
    10d6:	0505                	addi	a0,a0,1
    10d8:	00054783          	lbu	a5,0(a0)
    10dc:	fbfd                	bnez	a5,10d2 <strchr+0xc>
      return (char*)s;
  return 0;
    10de:	4501                	li	a0,0
}
    10e0:	6422                	ld	s0,8(sp)
    10e2:	0141                	addi	sp,sp,16
    10e4:	8082                	ret
  return 0;
    10e6:	4501                	li	a0,0
    10e8:	bfe5                	j	10e0 <strchr+0x1a>

00000000000010ea <gets>:

char*
gets(char *buf, int max)
{
    10ea:	711d                	addi	sp,sp,-96
    10ec:	ec86                	sd	ra,88(sp)
    10ee:	e8a2                	sd	s0,80(sp)
    10f0:	e4a6                	sd	s1,72(sp)
    10f2:	e0ca                	sd	s2,64(sp)
    10f4:	fc4e                	sd	s3,56(sp)
    10f6:	f852                	sd	s4,48(sp)
    10f8:	f456                	sd	s5,40(sp)
    10fa:	f05a                	sd	s6,32(sp)
    10fc:	ec5e                	sd	s7,24(sp)
    10fe:	1080                	addi	s0,sp,96
    1100:	8baa                	mv	s7,a0
    1102:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1104:	892a                	mv	s2,a0
    1106:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1108:	4aa9                	li	s5,10
    110a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    110c:	89a6                	mv	s3,s1
    110e:	2485                	addiw	s1,s1,1
    1110:	0344d663          	bge	s1,s4,113c <gets+0x52>
    cc = read(0, &c, 1);
    1114:	4605                	li	a2,1
    1116:	faf40593          	addi	a1,s0,-81
    111a:	4501                	li	a0,0
    111c:	186000ef          	jal	12a2 <read>
    if(cc < 1)
    1120:	00a05e63          	blez	a0,113c <gets+0x52>
    buf[i++] = c;
    1124:	faf44783          	lbu	a5,-81(s0)
    1128:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    112c:	01578763          	beq	a5,s5,113a <gets+0x50>
    1130:	0905                	addi	s2,s2,1
    1132:	fd679de3          	bne	a5,s6,110c <gets+0x22>
    buf[i++] = c;
    1136:	89a6                	mv	s3,s1
    1138:	a011                	j	113c <gets+0x52>
    113a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    113c:	99de                	add	s3,s3,s7
    113e:	00098023          	sb	zero,0(s3)
  return buf;
}
    1142:	855e                	mv	a0,s7
    1144:	60e6                	ld	ra,88(sp)
    1146:	6446                	ld	s0,80(sp)
    1148:	64a6                	ld	s1,72(sp)
    114a:	6906                	ld	s2,64(sp)
    114c:	79e2                	ld	s3,56(sp)
    114e:	7a42                	ld	s4,48(sp)
    1150:	7aa2                	ld	s5,40(sp)
    1152:	7b02                	ld	s6,32(sp)
    1154:	6be2                	ld	s7,24(sp)
    1156:	6125                	addi	sp,sp,96
    1158:	8082                	ret

000000000000115a <stat>:

int
stat(const char *n, struct stat *st)
{
    115a:	1101                	addi	sp,sp,-32
    115c:	ec06                	sd	ra,24(sp)
    115e:	e822                	sd	s0,16(sp)
    1160:	e04a                	sd	s2,0(sp)
    1162:	1000                	addi	s0,sp,32
    1164:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1166:	4581                	li	a1,0
    1168:	162000ef          	jal	12ca <open>
  if(fd < 0)
    116c:	02054263          	bltz	a0,1190 <stat+0x36>
    1170:	e426                	sd	s1,8(sp)
    1172:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1174:	85ca                	mv	a1,s2
    1176:	16c000ef          	jal	12e2 <fstat>
    117a:	892a                	mv	s2,a0
  close(fd);
    117c:	8526                	mv	a0,s1
    117e:	134000ef          	jal	12b2 <close>
  return r;
    1182:	64a2                	ld	s1,8(sp)
}
    1184:	854a                	mv	a0,s2
    1186:	60e2                	ld	ra,24(sp)
    1188:	6442                	ld	s0,16(sp)
    118a:	6902                	ld	s2,0(sp)
    118c:	6105                	addi	sp,sp,32
    118e:	8082                	ret
    return -1;
    1190:	597d                	li	s2,-1
    1192:	bfcd                	j	1184 <stat+0x2a>

0000000000001194 <atoi>:

int
atoi(const char *s)
{
    1194:	1141                	addi	sp,sp,-16
    1196:	e422                	sd	s0,8(sp)
    1198:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    119a:	00054683          	lbu	a3,0(a0)
    119e:	fd06879b          	addiw	a5,a3,-48
    11a2:	0ff7f793          	zext.b	a5,a5
    11a6:	4625                	li	a2,9
    11a8:	02f66863          	bltu	a2,a5,11d8 <atoi+0x44>
    11ac:	872a                	mv	a4,a0
  n = 0;
    11ae:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    11b0:	0705                	addi	a4,a4,1
    11b2:	0025179b          	slliw	a5,a0,0x2
    11b6:	9fa9                	addw	a5,a5,a0
    11b8:	0017979b          	slliw	a5,a5,0x1
    11bc:	9fb5                	addw	a5,a5,a3
    11be:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    11c2:	00074683          	lbu	a3,0(a4)
    11c6:	fd06879b          	addiw	a5,a3,-48
    11ca:	0ff7f793          	zext.b	a5,a5
    11ce:	fef671e3          	bgeu	a2,a5,11b0 <atoi+0x1c>
  return n;
}
    11d2:	6422                	ld	s0,8(sp)
    11d4:	0141                	addi	sp,sp,16
    11d6:	8082                	ret
  n = 0;
    11d8:	4501                	li	a0,0
    11da:	bfe5                	j	11d2 <atoi+0x3e>

00000000000011dc <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11dc:	1141                	addi	sp,sp,-16
    11de:	e422                	sd	s0,8(sp)
    11e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    11e2:	02b57463          	bgeu	a0,a1,120a <memmove+0x2e>
    while(n-- > 0)
    11e6:	00c05f63          	blez	a2,1204 <memmove+0x28>
    11ea:	1602                	slli	a2,a2,0x20
    11ec:	9201                	srli	a2,a2,0x20
    11ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    11f2:	872a                	mv	a4,a0
      *dst++ = *src++;
    11f4:	0585                	addi	a1,a1,1
    11f6:	0705                	addi	a4,a4,1
    11f8:	fff5c683          	lbu	a3,-1(a1)
    11fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1200:	fef71ae3          	bne	a4,a5,11f4 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1204:	6422                	ld	s0,8(sp)
    1206:	0141                	addi	sp,sp,16
    1208:	8082                	ret
    dst += n;
    120a:	00c50733          	add	a4,a0,a2
    src += n;
    120e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1210:	fec05ae3          	blez	a2,1204 <memmove+0x28>
    1214:	fff6079b          	addiw	a5,a2,-1
    1218:	1782                	slli	a5,a5,0x20
    121a:	9381                	srli	a5,a5,0x20
    121c:	fff7c793          	not	a5,a5
    1220:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1222:	15fd                	addi	a1,a1,-1
    1224:	177d                	addi	a4,a4,-1
    1226:	0005c683          	lbu	a3,0(a1)
    122a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    122e:	fee79ae3          	bne	a5,a4,1222 <memmove+0x46>
    1232:	bfc9                	j	1204 <memmove+0x28>

0000000000001234 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1234:	1141                	addi	sp,sp,-16
    1236:	e422                	sd	s0,8(sp)
    1238:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    123a:	ca05                	beqz	a2,126a <memcmp+0x36>
    123c:	fff6069b          	addiw	a3,a2,-1
    1240:	1682                	slli	a3,a3,0x20
    1242:	9281                	srli	a3,a3,0x20
    1244:	0685                	addi	a3,a3,1
    1246:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1248:	00054783          	lbu	a5,0(a0)
    124c:	0005c703          	lbu	a4,0(a1)
    1250:	00e79863          	bne	a5,a4,1260 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1254:	0505                	addi	a0,a0,1
    p2++;
    1256:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1258:	fed518e3          	bne	a0,a3,1248 <memcmp+0x14>
  }
  return 0;
    125c:	4501                	li	a0,0
    125e:	a019                	j	1264 <memcmp+0x30>
      return *p1 - *p2;
    1260:	40e7853b          	subw	a0,a5,a4
}
    1264:	6422                	ld	s0,8(sp)
    1266:	0141                	addi	sp,sp,16
    1268:	8082                	ret
  return 0;
    126a:	4501                	li	a0,0
    126c:	bfe5                	j	1264 <memcmp+0x30>

000000000000126e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    126e:	1141                	addi	sp,sp,-16
    1270:	e406                	sd	ra,8(sp)
    1272:	e022                	sd	s0,0(sp)
    1274:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1276:	f67ff0ef          	jal	11dc <memmove>
}
    127a:	60a2                	ld	ra,8(sp)
    127c:	6402                	ld	s0,0(sp)
    127e:	0141                	addi	sp,sp,16
    1280:	8082                	ret

0000000000001282 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1282:	4885                	li	a7,1
 ecall
    1284:	00000073          	ecall
 ret
    1288:	8082                	ret

000000000000128a <exit>:
.global exit
exit:
 li a7, SYS_exit
    128a:	4889                	li	a7,2
 ecall
    128c:	00000073          	ecall
 ret
    1290:	8082                	ret

0000000000001292 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1292:	488d                	li	a7,3
 ecall
    1294:	00000073          	ecall
 ret
    1298:	8082                	ret

000000000000129a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    129a:	4891                	li	a7,4
 ecall
    129c:	00000073          	ecall
 ret
    12a0:	8082                	ret

00000000000012a2 <read>:
.global read
read:
 li a7, SYS_read
    12a2:	4895                	li	a7,5
 ecall
    12a4:	00000073          	ecall
 ret
    12a8:	8082                	ret

00000000000012aa <write>:
.global write
write:
 li a7, SYS_write
    12aa:	48c1                	li	a7,16
 ecall
    12ac:	00000073          	ecall
 ret
    12b0:	8082                	ret

00000000000012b2 <close>:
.global close
close:
 li a7, SYS_close
    12b2:	48d5                	li	a7,21
 ecall
    12b4:	00000073          	ecall
 ret
    12b8:	8082                	ret

00000000000012ba <kill>:
.global kill
kill:
 li a7, SYS_kill
    12ba:	4899                	li	a7,6
 ecall
    12bc:	00000073          	ecall
 ret
    12c0:	8082                	ret

00000000000012c2 <exec>:
.global exec
exec:
 li a7, SYS_exec
    12c2:	489d                	li	a7,7
 ecall
    12c4:	00000073          	ecall
 ret
    12c8:	8082                	ret

00000000000012ca <open>:
.global open
open:
 li a7, SYS_open
    12ca:	48bd                	li	a7,15
 ecall
    12cc:	00000073          	ecall
 ret
    12d0:	8082                	ret

00000000000012d2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    12d2:	48c5                	li	a7,17
 ecall
    12d4:	00000073          	ecall
 ret
    12d8:	8082                	ret

00000000000012da <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    12da:	48c9                	li	a7,18
 ecall
    12dc:	00000073          	ecall
 ret
    12e0:	8082                	ret

00000000000012e2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    12e2:	48a1                	li	a7,8
 ecall
    12e4:	00000073          	ecall
 ret
    12e8:	8082                	ret

00000000000012ea <link>:
.global link
link:
 li a7, SYS_link
    12ea:	48cd                	li	a7,19
 ecall
    12ec:	00000073          	ecall
 ret
    12f0:	8082                	ret

00000000000012f2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    12f2:	48d1                	li	a7,20
 ecall
    12f4:	00000073          	ecall
 ret
    12f8:	8082                	ret

00000000000012fa <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    12fa:	48a5                	li	a7,9
 ecall
    12fc:	00000073          	ecall
 ret
    1300:	8082                	ret

0000000000001302 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1302:	48a9                	li	a7,10
 ecall
    1304:	00000073          	ecall
 ret
    1308:	8082                	ret

000000000000130a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    130a:	48ad                	li	a7,11
 ecall
    130c:	00000073          	ecall
 ret
    1310:	8082                	ret

0000000000001312 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1312:	48b1                	li	a7,12
 ecall
    1314:	00000073          	ecall
 ret
    1318:	8082                	ret

000000000000131a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    131a:	48b5                	li	a7,13
 ecall
    131c:	00000073          	ecall
 ret
    1320:	8082                	ret

0000000000001322 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1322:	48b9                	li	a7,14
 ecall
    1324:	00000073          	ecall
 ret
    1328:	8082                	ret

000000000000132a <cps>:
.global cps
cps:
 li a7, SYS_cps
    132a:	48d9                	li	a7,22
 ecall
    132c:	00000073          	ecall
 ret
    1330:	8082                	ret

0000000000001332 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1332:	48dd                	li	a7,23
 ecall
    1334:	00000073          	ecall
 ret
    1338:	8082                	ret

000000000000133a <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    133a:	48e1                	li	a7,24
 ecall
    133c:	00000073          	ecall
 ret
    1340:	8082                	ret

0000000000001342 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1342:	48e5                	li	a7,25
 ecall
    1344:	00000073          	ecall
 ret
    1348:	8082                	ret

000000000000134a <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    134a:	48e9                	li	a7,26
 ecall
    134c:	00000073          	ecall
 ret
    1350:	8082                	ret

0000000000001352 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    1352:	48ed                	li	a7,27
 ecall
    1354:	00000073          	ecall
 ret
    1358:	8082                	ret

000000000000135a <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    135a:	48f1                	li	a7,28
 ecall
    135c:	00000073          	ecall
 ret
    1360:	8082                	ret

0000000000001362 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    1362:	48f5                	li	a7,29
 ecall
    1364:	00000073          	ecall
 ret
    1368:	8082                	ret

000000000000136a <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    136a:	48f9                	li	a7,30
 ecall
    136c:	00000073          	ecall
 ret
    1370:	8082                	ret

0000000000001372 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1372:	1101                	addi	sp,sp,-32
    1374:	ec06                	sd	ra,24(sp)
    1376:	e822                	sd	s0,16(sp)
    1378:	1000                	addi	s0,sp,32
    137a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    137e:	4605                	li	a2,1
    1380:	fef40593          	addi	a1,s0,-17
    1384:	f27ff0ef          	jal	12aa <write>
}
    1388:	60e2                	ld	ra,24(sp)
    138a:	6442                	ld	s0,16(sp)
    138c:	6105                	addi	sp,sp,32
    138e:	8082                	ret

0000000000001390 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1390:	7139                	addi	sp,sp,-64
    1392:	fc06                	sd	ra,56(sp)
    1394:	f822                	sd	s0,48(sp)
    1396:	f426                	sd	s1,40(sp)
    1398:	0080                	addi	s0,sp,64
    139a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    139c:	c299                	beqz	a3,13a2 <printint+0x12>
    139e:	0805c963          	bltz	a1,1430 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13a2:	2581                	sext.w	a1,a1
  neg = 0;
    13a4:	4881                	li	a7,0
    13a6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13ac:	2601                	sext.w	a2,a2
    13ae:	00001517          	auipc	a0,0x1
    13b2:	c6250513          	addi	a0,a0,-926 # 2010 <digits>
    13b6:	883a                	mv	a6,a4
    13b8:	2705                	addiw	a4,a4,1
    13ba:	02c5f7bb          	remuw	a5,a1,a2
    13be:	1782                	slli	a5,a5,0x20
    13c0:	9381                	srli	a5,a5,0x20
    13c2:	97aa                	add	a5,a5,a0
    13c4:	0007c783          	lbu	a5,0(a5)
    13c8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    13cc:	0005879b          	sext.w	a5,a1
    13d0:	02c5d5bb          	divuw	a1,a1,a2
    13d4:	0685                	addi	a3,a3,1
    13d6:	fec7f0e3          	bgeu	a5,a2,13b6 <printint+0x26>
  if(neg)
    13da:	00088c63          	beqz	a7,13f2 <printint+0x62>
    buf[i++] = '-';
    13de:	fd070793          	addi	a5,a4,-48
    13e2:	00878733          	add	a4,a5,s0
    13e6:	02d00793          	li	a5,45
    13ea:	fef70823          	sb	a5,-16(a4)
    13ee:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    13f2:	02e05a63          	blez	a4,1426 <printint+0x96>
    13f6:	f04a                	sd	s2,32(sp)
    13f8:	ec4e                	sd	s3,24(sp)
    13fa:	fc040793          	addi	a5,s0,-64
    13fe:	00e78933          	add	s2,a5,a4
    1402:	fff78993          	addi	s3,a5,-1
    1406:	99ba                	add	s3,s3,a4
    1408:	377d                	addiw	a4,a4,-1
    140a:	1702                	slli	a4,a4,0x20
    140c:	9301                	srli	a4,a4,0x20
    140e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1412:	fff94583          	lbu	a1,-1(s2)
    1416:	8526                	mv	a0,s1
    1418:	f5bff0ef          	jal	1372 <putc>
  while(--i >= 0)
    141c:	197d                	addi	s2,s2,-1
    141e:	ff391ae3          	bne	s2,s3,1412 <printint+0x82>
    1422:	7902                	ld	s2,32(sp)
    1424:	69e2                	ld	s3,24(sp)
}
    1426:	70e2                	ld	ra,56(sp)
    1428:	7442                	ld	s0,48(sp)
    142a:	74a2                	ld	s1,40(sp)
    142c:	6121                	addi	sp,sp,64
    142e:	8082                	ret
    x = -xx;
    1430:	40b005bb          	negw	a1,a1
    neg = 1;
    1434:	4885                	li	a7,1
    x = -xx;
    1436:	bf85                	j	13a6 <printint+0x16>

0000000000001438 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1438:	711d                	addi	sp,sp,-96
    143a:	ec86                	sd	ra,88(sp)
    143c:	e8a2                	sd	s0,80(sp)
    143e:	e0ca                	sd	s2,64(sp)
    1440:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1442:	0005c903          	lbu	s2,0(a1)
    1446:	26090863          	beqz	s2,16b6 <vprintf+0x27e>
    144a:	e4a6                	sd	s1,72(sp)
    144c:	fc4e                	sd	s3,56(sp)
    144e:	f852                	sd	s4,48(sp)
    1450:	f456                	sd	s5,40(sp)
    1452:	f05a                	sd	s6,32(sp)
    1454:	ec5e                	sd	s7,24(sp)
    1456:	e862                	sd	s8,16(sp)
    1458:	e466                	sd	s9,8(sp)
    145a:	8b2a                	mv	s6,a0
    145c:	8a2e                	mv	s4,a1
    145e:	8bb2                	mv	s7,a2
  state = 0;
    1460:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1462:	4481                	li	s1,0
    1464:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1466:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    146a:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    146e:	06c00c93          	li	s9,108
    1472:	a005                	j	1492 <vprintf+0x5a>
        putc(fd, c0);
    1474:	85ca                	mv	a1,s2
    1476:	855a                	mv	a0,s6
    1478:	efbff0ef          	jal	1372 <putc>
    147c:	a019                	j	1482 <vprintf+0x4a>
    } else if(state == '%'){
    147e:	03598263          	beq	s3,s5,14a2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    1482:	2485                	addiw	s1,s1,1
    1484:	8726                	mv	a4,s1
    1486:	009a07b3          	add	a5,s4,s1
    148a:	0007c903          	lbu	s2,0(a5)
    148e:	20090c63          	beqz	s2,16a6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    1492:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1496:	fe0994e3          	bnez	s3,147e <vprintf+0x46>
      if(c0 == '%'){
    149a:	fd579de3          	bne	a5,s5,1474 <vprintf+0x3c>
        state = '%';
    149e:	89be                	mv	s3,a5
    14a0:	b7cd                	j	1482 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14a2:	00ea06b3          	add	a3,s4,a4
    14a6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    14aa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    14ac:	c681                	beqz	a3,14b4 <vprintf+0x7c>
    14ae:	9752                	add	a4,a4,s4
    14b0:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    14b4:	03878f63          	beq	a5,s8,14f2 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    14b8:	05978963          	beq	a5,s9,150a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    14bc:	07500713          	li	a4,117
    14c0:	0ee78363          	beq	a5,a4,15a6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    14c4:	07800713          	li	a4,120
    14c8:	12e78563          	beq	a5,a4,15f2 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    14cc:	07000713          	li	a4,112
    14d0:	14e78a63          	beq	a5,a4,1624 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    14d4:	07300713          	li	a4,115
    14d8:	18e78a63          	beq	a5,a4,166c <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    14dc:	02500713          	li	a4,37
    14e0:	04e79563          	bne	a5,a4,152a <vprintf+0xf2>
        putc(fd, '%');
    14e4:	02500593          	li	a1,37
    14e8:	855a                	mv	a0,s6
    14ea:	e89ff0ef          	jal	1372 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    14ee:	4981                	li	s3,0
    14f0:	bf49                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    14f2:	008b8913          	addi	s2,s7,8
    14f6:	4685                	li	a3,1
    14f8:	4629                	li	a2,10
    14fa:	000ba583          	lw	a1,0(s7)
    14fe:	855a                	mv	a0,s6
    1500:	e91ff0ef          	jal	1390 <printint>
    1504:	8bca                	mv	s7,s2
      state = 0;
    1506:	4981                	li	s3,0
    1508:	bfad                	j	1482 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    150a:	06400793          	li	a5,100
    150e:	02f68963          	beq	a3,a5,1540 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1512:	06c00793          	li	a5,108
    1516:	04f68263          	beq	a3,a5,155a <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    151a:	07500793          	li	a5,117
    151e:	0af68063          	beq	a3,a5,15be <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1522:	07800793          	li	a5,120
    1526:	0ef68263          	beq	a3,a5,160a <vprintf+0x1d2>
        putc(fd, '%');
    152a:	02500593          	li	a1,37
    152e:	855a                	mv	a0,s6
    1530:	e43ff0ef          	jal	1372 <putc>
        putc(fd, c0);
    1534:	85ca                	mv	a1,s2
    1536:	855a                	mv	a0,s6
    1538:	e3bff0ef          	jal	1372 <putc>
      state = 0;
    153c:	4981                	li	s3,0
    153e:	b791                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1540:	008b8913          	addi	s2,s7,8
    1544:	4685                	li	a3,1
    1546:	4629                	li	a2,10
    1548:	000ba583          	lw	a1,0(s7)
    154c:	855a                	mv	a0,s6
    154e:	e43ff0ef          	jal	1390 <printint>
        i += 1;
    1552:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1554:	8bca                	mv	s7,s2
      state = 0;
    1556:	4981                	li	s3,0
        i += 1;
    1558:	b72d                	j	1482 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    155a:	06400793          	li	a5,100
    155e:	02f60763          	beq	a2,a5,158c <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1562:	07500793          	li	a5,117
    1566:	06f60963          	beq	a2,a5,15d8 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    156a:	07800793          	li	a5,120
    156e:	faf61ee3          	bne	a2,a5,152a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1572:	008b8913          	addi	s2,s7,8
    1576:	4681                	li	a3,0
    1578:	4641                	li	a2,16
    157a:	000ba583          	lw	a1,0(s7)
    157e:	855a                	mv	a0,s6
    1580:	e11ff0ef          	jal	1390 <printint>
        i += 2;
    1584:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1586:	8bca                	mv	s7,s2
      state = 0;
    1588:	4981                	li	s3,0
        i += 2;
    158a:	bde5                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    158c:	008b8913          	addi	s2,s7,8
    1590:	4685                	li	a3,1
    1592:	4629                	li	a2,10
    1594:	000ba583          	lw	a1,0(s7)
    1598:	855a                	mv	a0,s6
    159a:	df7ff0ef          	jal	1390 <printint>
        i += 2;
    159e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15a0:	8bca                	mv	s7,s2
      state = 0;
    15a2:	4981                	li	s3,0
        i += 2;
    15a4:	bdf9                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    15a6:	008b8913          	addi	s2,s7,8
    15aa:	4681                	li	a3,0
    15ac:	4629                	li	a2,10
    15ae:	000ba583          	lw	a1,0(s7)
    15b2:	855a                	mv	a0,s6
    15b4:	dddff0ef          	jal	1390 <printint>
    15b8:	8bca                	mv	s7,s2
      state = 0;
    15ba:	4981                	li	s3,0
    15bc:	b5d9                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15be:	008b8913          	addi	s2,s7,8
    15c2:	4681                	li	a3,0
    15c4:	4629                	li	a2,10
    15c6:	000ba583          	lw	a1,0(s7)
    15ca:	855a                	mv	a0,s6
    15cc:	dc5ff0ef          	jal	1390 <printint>
        i += 1;
    15d0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    15d2:	8bca                	mv	s7,s2
      state = 0;
    15d4:	4981                	li	s3,0
        i += 1;
    15d6:	b575                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15d8:	008b8913          	addi	s2,s7,8
    15dc:	4681                	li	a3,0
    15de:	4629                	li	a2,10
    15e0:	000ba583          	lw	a1,0(s7)
    15e4:	855a                	mv	a0,s6
    15e6:	dabff0ef          	jal	1390 <printint>
        i += 2;
    15ea:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    15ec:	8bca                	mv	s7,s2
      state = 0;
    15ee:	4981                	li	s3,0
        i += 2;
    15f0:	bd49                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    15f2:	008b8913          	addi	s2,s7,8
    15f6:	4681                	li	a3,0
    15f8:	4641                	li	a2,16
    15fa:	000ba583          	lw	a1,0(s7)
    15fe:	855a                	mv	a0,s6
    1600:	d91ff0ef          	jal	1390 <printint>
    1604:	8bca                	mv	s7,s2
      state = 0;
    1606:	4981                	li	s3,0
    1608:	bdad                	j	1482 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    160a:	008b8913          	addi	s2,s7,8
    160e:	4681                	li	a3,0
    1610:	4641                	li	a2,16
    1612:	000ba583          	lw	a1,0(s7)
    1616:	855a                	mv	a0,s6
    1618:	d79ff0ef          	jal	1390 <printint>
        i += 1;
    161c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    161e:	8bca                	mv	s7,s2
      state = 0;
    1620:	4981                	li	s3,0
        i += 1;
    1622:	b585                	j	1482 <vprintf+0x4a>
    1624:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1626:	008b8d13          	addi	s10,s7,8
    162a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    162e:	03000593          	li	a1,48
    1632:	855a                	mv	a0,s6
    1634:	d3fff0ef          	jal	1372 <putc>
  putc(fd, 'x');
    1638:	07800593          	li	a1,120
    163c:	855a                	mv	a0,s6
    163e:	d35ff0ef          	jal	1372 <putc>
    1642:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1644:	00001b97          	auipc	s7,0x1
    1648:	9ccb8b93          	addi	s7,s7,-1588 # 2010 <digits>
    164c:	03c9d793          	srli	a5,s3,0x3c
    1650:	97de                	add	a5,a5,s7
    1652:	0007c583          	lbu	a1,0(a5)
    1656:	855a                	mv	a0,s6
    1658:	d1bff0ef          	jal	1372 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    165c:	0992                	slli	s3,s3,0x4
    165e:	397d                	addiw	s2,s2,-1
    1660:	fe0916e3          	bnez	s2,164c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1664:	8bea                	mv	s7,s10
      state = 0;
    1666:	4981                	li	s3,0
    1668:	6d02                	ld	s10,0(sp)
    166a:	bd21                	j	1482 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    166c:	008b8993          	addi	s3,s7,8
    1670:	000bb903          	ld	s2,0(s7)
    1674:	00090f63          	beqz	s2,1692 <vprintf+0x25a>
        for(; *s; s++)
    1678:	00094583          	lbu	a1,0(s2)
    167c:	c195                	beqz	a1,16a0 <vprintf+0x268>
          putc(fd, *s);
    167e:	855a                	mv	a0,s6
    1680:	cf3ff0ef          	jal	1372 <putc>
        for(; *s; s++)
    1684:	0905                	addi	s2,s2,1
    1686:	00094583          	lbu	a1,0(s2)
    168a:	f9f5                	bnez	a1,167e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    168c:	8bce                	mv	s7,s3
      state = 0;
    168e:	4981                	li	s3,0
    1690:	bbcd                	j	1482 <vprintf+0x4a>
          s = "(null)";
    1692:	00001917          	auipc	s2,0x1
    1696:	97690913          	addi	s2,s2,-1674 # 2008 <malloc+0x86a>
        for(; *s; s++)
    169a:	02800593          	li	a1,40
    169e:	b7c5                	j	167e <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16a0:	8bce                	mv	s7,s3
      state = 0;
    16a2:	4981                	li	s3,0
    16a4:	bbf9                	j	1482 <vprintf+0x4a>
    16a6:	64a6                	ld	s1,72(sp)
    16a8:	79e2                	ld	s3,56(sp)
    16aa:	7a42                	ld	s4,48(sp)
    16ac:	7aa2                	ld	s5,40(sp)
    16ae:	7b02                	ld	s6,32(sp)
    16b0:	6be2                	ld	s7,24(sp)
    16b2:	6c42                	ld	s8,16(sp)
    16b4:	6ca2                	ld	s9,8(sp)
    }
  }
}
    16b6:	60e6                	ld	ra,88(sp)
    16b8:	6446                	ld	s0,80(sp)
    16ba:	6906                	ld	s2,64(sp)
    16bc:	6125                	addi	sp,sp,96
    16be:	8082                	ret

00000000000016c0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    16c0:	715d                	addi	sp,sp,-80
    16c2:	ec06                	sd	ra,24(sp)
    16c4:	e822                	sd	s0,16(sp)
    16c6:	1000                	addi	s0,sp,32
    16c8:	e010                	sd	a2,0(s0)
    16ca:	e414                	sd	a3,8(s0)
    16cc:	e818                	sd	a4,16(s0)
    16ce:	ec1c                	sd	a5,24(s0)
    16d0:	03043023          	sd	a6,32(s0)
    16d4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    16d8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    16dc:	8622                	mv	a2,s0
    16de:	d5bff0ef          	jal	1438 <vprintf>
}
    16e2:	60e2                	ld	ra,24(sp)
    16e4:	6442                	ld	s0,16(sp)
    16e6:	6161                	addi	sp,sp,80
    16e8:	8082                	ret

00000000000016ea <printf>:

void
printf(const char *fmt, ...)
{
    16ea:	711d                	addi	sp,sp,-96
    16ec:	ec06                	sd	ra,24(sp)
    16ee:	e822                	sd	s0,16(sp)
    16f0:	1000                	addi	s0,sp,32
    16f2:	e40c                	sd	a1,8(s0)
    16f4:	e810                	sd	a2,16(s0)
    16f6:	ec14                	sd	a3,24(s0)
    16f8:	f018                	sd	a4,32(s0)
    16fa:	f41c                	sd	a5,40(s0)
    16fc:	03043823          	sd	a6,48(s0)
    1700:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1704:	00840613          	addi	a2,s0,8
    1708:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    170c:	85aa                	mv	a1,a0
    170e:	4505                	li	a0,1
    1710:	d29ff0ef          	jal	1438 <vprintf>
}
    1714:	60e2                	ld	ra,24(sp)
    1716:	6442                	ld	s0,16(sp)
    1718:	6125                	addi	sp,sp,96
    171a:	8082                	ret

000000000000171c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    171c:	1141                	addi	sp,sp,-16
    171e:	e422                	sd	s0,8(sp)
    1720:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1722:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1726:	00001797          	auipc	a5,0x1
    172a:	90a7b783          	ld	a5,-1782(a5) # 2030 <freep>
    172e:	a02d                	j	1758 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1730:	4618                	lw	a4,8(a2)
    1732:	9f2d                	addw	a4,a4,a1
    1734:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1738:	6398                	ld	a4,0(a5)
    173a:	6310                	ld	a2,0(a4)
    173c:	a83d                	j	177a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    173e:	ff852703          	lw	a4,-8(a0)
    1742:	9f31                	addw	a4,a4,a2
    1744:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1746:	ff053683          	ld	a3,-16(a0)
    174a:	a091                	j	178e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    174c:	6398                	ld	a4,0(a5)
    174e:	00e7e463          	bltu	a5,a4,1756 <free+0x3a>
    1752:	00e6ea63          	bltu	a3,a4,1766 <free+0x4a>
{
    1756:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1758:	fed7fae3          	bgeu	a5,a3,174c <free+0x30>
    175c:	6398                	ld	a4,0(a5)
    175e:	00e6e463          	bltu	a3,a4,1766 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1762:	fee7eae3          	bltu	a5,a4,1756 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1766:	ff852583          	lw	a1,-8(a0)
    176a:	6390                	ld	a2,0(a5)
    176c:	02059813          	slli	a6,a1,0x20
    1770:	01c85713          	srli	a4,a6,0x1c
    1774:	9736                	add	a4,a4,a3
    1776:	fae60de3          	beq	a2,a4,1730 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    177a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    177e:	4790                	lw	a2,8(a5)
    1780:	02061593          	slli	a1,a2,0x20
    1784:	01c5d713          	srli	a4,a1,0x1c
    1788:	973e                	add	a4,a4,a5
    178a:	fae68ae3          	beq	a3,a4,173e <free+0x22>
    p->s.ptr = bp->s.ptr;
    178e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1790:	00001717          	auipc	a4,0x1
    1794:	8af73023          	sd	a5,-1888(a4) # 2030 <freep>
}
    1798:	6422                	ld	s0,8(sp)
    179a:	0141                	addi	sp,sp,16
    179c:	8082                	ret

000000000000179e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    179e:	7139                	addi	sp,sp,-64
    17a0:	fc06                	sd	ra,56(sp)
    17a2:	f822                	sd	s0,48(sp)
    17a4:	f426                	sd	s1,40(sp)
    17a6:	ec4e                	sd	s3,24(sp)
    17a8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17aa:	02051493          	slli	s1,a0,0x20
    17ae:	9081                	srli	s1,s1,0x20
    17b0:	04bd                	addi	s1,s1,15
    17b2:	8091                	srli	s1,s1,0x4
    17b4:	0014899b          	addiw	s3,s1,1
    17b8:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    17ba:	00001517          	auipc	a0,0x1
    17be:	87653503          	ld	a0,-1930(a0) # 2030 <freep>
    17c2:	c915                	beqz	a0,17f6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17c4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    17c6:	4798                	lw	a4,8(a5)
    17c8:	08977a63          	bgeu	a4,s1,185c <malloc+0xbe>
    17cc:	f04a                	sd	s2,32(sp)
    17ce:	e852                	sd	s4,16(sp)
    17d0:	e456                	sd	s5,8(sp)
    17d2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    17d4:	8a4e                	mv	s4,s3
    17d6:	0009871b          	sext.w	a4,s3
    17da:	6685                	lui	a3,0x1
    17dc:	00d77363          	bgeu	a4,a3,17e2 <malloc+0x44>
    17e0:	6a05                	lui	s4,0x1
    17e2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    17e6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    17ea:	00001917          	auipc	s2,0x1
    17ee:	84690913          	addi	s2,s2,-1978 # 2030 <freep>
  if(p == (char*)-1)
    17f2:	5afd                	li	s5,-1
    17f4:	a081                	j	1834 <malloc+0x96>
    17f6:	f04a                	sd	s2,32(sp)
    17f8:	e852                	sd	s4,16(sp)
    17fa:	e456                	sd	s5,8(sp)
    17fc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    17fe:	00001797          	auipc	a5,0x1
    1802:	84278793          	addi	a5,a5,-1982 # 2040 <base>
    1806:	00001717          	auipc	a4,0x1
    180a:	82f73523          	sd	a5,-2006(a4) # 2030 <freep>
    180e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1810:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1814:	b7c1                	j	17d4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1816:	6398                	ld	a4,0(a5)
    1818:	e118                	sd	a4,0(a0)
    181a:	a8a9                	j	1874 <malloc+0xd6>
  hp->s.size = nu;
    181c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1820:	0541                	addi	a0,a0,16
    1822:	efbff0ef          	jal	171c <free>
  return freep;
    1826:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    182a:	c12d                	beqz	a0,188c <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    182c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    182e:	4798                	lw	a4,8(a5)
    1830:	02977263          	bgeu	a4,s1,1854 <malloc+0xb6>
    if(p == freep)
    1834:	00093703          	ld	a4,0(s2)
    1838:	853e                	mv	a0,a5
    183a:	fef719e3          	bne	a4,a5,182c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    183e:	8552                	mv	a0,s4
    1840:	ad3ff0ef          	jal	1312 <sbrk>
  if(p == (char*)-1)
    1844:	fd551ce3          	bne	a0,s5,181c <malloc+0x7e>
        return 0;
    1848:	4501                	li	a0,0
    184a:	7902                	ld	s2,32(sp)
    184c:	6a42                	ld	s4,16(sp)
    184e:	6aa2                	ld	s5,8(sp)
    1850:	6b02                	ld	s6,0(sp)
    1852:	a03d                	j	1880 <malloc+0xe2>
    1854:	7902                	ld	s2,32(sp)
    1856:	6a42                	ld	s4,16(sp)
    1858:	6aa2                	ld	s5,8(sp)
    185a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    185c:	fae48de3          	beq	s1,a4,1816 <malloc+0x78>
        p->s.size -= nunits;
    1860:	4137073b          	subw	a4,a4,s3
    1864:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1866:	02071693          	slli	a3,a4,0x20
    186a:	01c6d713          	srli	a4,a3,0x1c
    186e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1870:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1874:	00000717          	auipc	a4,0x0
    1878:	7aa73e23          	sd	a0,1980(a4) # 2030 <freep>
      return (void*)(p + 1);
    187c:	01078513          	addi	a0,a5,16
  }
}
    1880:	70e2                	ld	ra,56(sp)
    1882:	7442                	ld	s0,48(sp)
    1884:	74a2                	ld	s1,40(sp)
    1886:	69e2                	ld	s3,24(sp)
    1888:	6121                	addi	sp,sp,64
    188a:	8082                	ret
    188c:	7902                	ld	s2,32(sp)
    188e:	6a42                	ld	s4,16(sp)
    1890:	6aa2                	ld	s5,8(sp)
    1892:	6b02                	ld	s6,0(sp)
    1894:	b7f5                	j	1880 <malloc+0xe2>
	...
