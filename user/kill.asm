
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
    1008:	4785                	li	a5,1
    100a:	02a7d963          	bge	a5,a0,103c <main+0x3c>
    100e:	e426                	sd	s1,8(sp)
    1010:	e04a                	sd	s2,0(sp)
    1012:	00858493          	addi	s1,a1,8
    1016:	ffe5091b          	addiw	s2,a0,-2
    101a:	02091793          	slli	a5,s2,0x20
    101e:	01d7d913          	srli	s2,a5,0x1d
    1022:	05c1                	addi	a1,a1,16
    1024:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
    1026:	6088                	ld	a0,0(s1)
    1028:	1a0000ef          	jal	11c8 <atoi>
    102c:	2c2000ef          	jal	12ee <kill>
  for(i=1; i<argc; i++)
    1030:	04a1                	addi	s1,s1,8
    1032:	ff249ae3          	bne	s1,s2,1026 <main+0x26>
  exit(0);
    1036:	4501                	li	a0,0
    1038:	286000ef          	jal	12be <exit>
    103c:	e426                	sd	s1,8(sp)
    103e:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
    1040:	00001597          	auipc	a1,0x1
    1044:	fc058593          	addi	a1,a1,-64 # 2000 <malloc+0x82e>
    1048:	4509                	li	a0,2
    104a:	6aa000ef          	jal	16f4 <fprintf>
    exit(1);
    104e:	4505                	li	a0,1
    1050:	26e000ef          	jal	12be <exit>

0000000000001054 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    1054:	1141                	addi	sp,sp,-16
    1056:	e406                	sd	ra,8(sp)
    1058:	e022                	sd	s0,0(sp)
    105a:	0800                	addi	s0,sp,16
  extern int main();
  main();
    105c:	fa5ff0ef          	jal	1000 <main>
  exit(0);
    1060:	4501                	li	a0,0
    1062:	25c000ef          	jal	12be <exit>

0000000000001066 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1066:	1141                	addi	sp,sp,-16
    1068:	e422                	sd	s0,8(sp)
    106a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    106c:	87aa                	mv	a5,a0
    106e:	0585                	addi	a1,a1,1
    1070:	0785                	addi	a5,a5,1
    1072:	fff5c703          	lbu	a4,-1(a1)
    1076:	fee78fa3          	sb	a4,-1(a5)
    107a:	fb75                	bnez	a4,106e <strcpy+0x8>
    ;
  return os;
}
    107c:	6422                	ld	s0,8(sp)
    107e:	0141                	addi	sp,sp,16
    1080:	8082                	ret

0000000000001082 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1082:	1141                	addi	sp,sp,-16
    1084:	e422                	sd	s0,8(sp)
    1086:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1088:	00054783          	lbu	a5,0(a0)
    108c:	cb91                	beqz	a5,10a0 <strcmp+0x1e>
    108e:	0005c703          	lbu	a4,0(a1)
    1092:	00f71763          	bne	a4,a5,10a0 <strcmp+0x1e>
    p++, q++;
    1096:	0505                	addi	a0,a0,1
    1098:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    109a:	00054783          	lbu	a5,0(a0)
    109e:	fbe5                	bnez	a5,108e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    10a0:	0005c503          	lbu	a0,0(a1)
}
    10a4:	40a7853b          	subw	a0,a5,a0
    10a8:	6422                	ld	s0,8(sp)
    10aa:	0141                	addi	sp,sp,16
    10ac:	8082                	ret

00000000000010ae <strlen>:

uint
strlen(const char *s)
{
    10ae:	1141                	addi	sp,sp,-16
    10b0:	e422                	sd	s0,8(sp)
    10b2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10b4:	00054783          	lbu	a5,0(a0)
    10b8:	cf91                	beqz	a5,10d4 <strlen+0x26>
    10ba:	0505                	addi	a0,a0,1
    10bc:	87aa                	mv	a5,a0
    10be:	86be                	mv	a3,a5
    10c0:	0785                	addi	a5,a5,1
    10c2:	fff7c703          	lbu	a4,-1(a5)
    10c6:	ff65                	bnez	a4,10be <strlen+0x10>
    10c8:	40a6853b          	subw	a0,a3,a0
    10cc:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    10ce:	6422                	ld	s0,8(sp)
    10d0:	0141                	addi	sp,sp,16
    10d2:	8082                	ret
  for(n = 0; s[n]; n++)
    10d4:	4501                	li	a0,0
    10d6:	bfe5                	j	10ce <strlen+0x20>

00000000000010d8 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10d8:	1141                	addi	sp,sp,-16
    10da:	e422                	sd	s0,8(sp)
    10dc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10de:	ca19                	beqz	a2,10f4 <memset+0x1c>
    10e0:	87aa                	mv	a5,a0
    10e2:	1602                	slli	a2,a2,0x20
    10e4:	9201                	srli	a2,a2,0x20
    10e6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    10ea:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10ee:	0785                	addi	a5,a5,1
    10f0:	fee79de3          	bne	a5,a4,10ea <memset+0x12>
  }
  return dst;
}
    10f4:	6422                	ld	s0,8(sp)
    10f6:	0141                	addi	sp,sp,16
    10f8:	8082                	ret

00000000000010fa <strchr>:

char*
strchr(const char *s, char c)
{
    10fa:	1141                	addi	sp,sp,-16
    10fc:	e422                	sd	s0,8(sp)
    10fe:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1100:	00054783          	lbu	a5,0(a0)
    1104:	cb99                	beqz	a5,111a <strchr+0x20>
    if(*s == c)
    1106:	00f58763          	beq	a1,a5,1114 <strchr+0x1a>
  for(; *s; s++)
    110a:	0505                	addi	a0,a0,1
    110c:	00054783          	lbu	a5,0(a0)
    1110:	fbfd                	bnez	a5,1106 <strchr+0xc>
      return (char*)s;
  return 0;
    1112:	4501                	li	a0,0
}
    1114:	6422                	ld	s0,8(sp)
    1116:	0141                	addi	sp,sp,16
    1118:	8082                	ret
  return 0;
    111a:	4501                	li	a0,0
    111c:	bfe5                	j	1114 <strchr+0x1a>

000000000000111e <gets>:

char*
gets(char *buf, int max)
{
    111e:	711d                	addi	sp,sp,-96
    1120:	ec86                	sd	ra,88(sp)
    1122:	e8a2                	sd	s0,80(sp)
    1124:	e4a6                	sd	s1,72(sp)
    1126:	e0ca                	sd	s2,64(sp)
    1128:	fc4e                	sd	s3,56(sp)
    112a:	f852                	sd	s4,48(sp)
    112c:	f456                	sd	s5,40(sp)
    112e:	f05a                	sd	s6,32(sp)
    1130:	ec5e                	sd	s7,24(sp)
    1132:	1080                	addi	s0,sp,96
    1134:	8baa                	mv	s7,a0
    1136:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1138:	892a                	mv	s2,a0
    113a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    113c:	4aa9                	li	s5,10
    113e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1140:	89a6                	mv	s3,s1
    1142:	2485                	addiw	s1,s1,1
    1144:	0344d663          	bge	s1,s4,1170 <gets+0x52>
    cc = read(0, &c, 1);
    1148:	4605                	li	a2,1
    114a:	faf40593          	addi	a1,s0,-81
    114e:	4501                	li	a0,0
    1150:	186000ef          	jal	12d6 <read>
    if(cc < 1)
    1154:	00a05e63          	blez	a0,1170 <gets+0x52>
    buf[i++] = c;
    1158:	faf44783          	lbu	a5,-81(s0)
    115c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1160:	01578763          	beq	a5,s5,116e <gets+0x50>
    1164:	0905                	addi	s2,s2,1
    1166:	fd679de3          	bne	a5,s6,1140 <gets+0x22>
    buf[i++] = c;
    116a:	89a6                	mv	s3,s1
    116c:	a011                	j	1170 <gets+0x52>
    116e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1170:	99de                	add	s3,s3,s7
    1172:	00098023          	sb	zero,0(s3)
  return buf;
}
    1176:	855e                	mv	a0,s7
    1178:	60e6                	ld	ra,88(sp)
    117a:	6446                	ld	s0,80(sp)
    117c:	64a6                	ld	s1,72(sp)
    117e:	6906                	ld	s2,64(sp)
    1180:	79e2                	ld	s3,56(sp)
    1182:	7a42                	ld	s4,48(sp)
    1184:	7aa2                	ld	s5,40(sp)
    1186:	7b02                	ld	s6,32(sp)
    1188:	6be2                	ld	s7,24(sp)
    118a:	6125                	addi	sp,sp,96
    118c:	8082                	ret

000000000000118e <stat>:

int
stat(const char *n, struct stat *st)
{
    118e:	1101                	addi	sp,sp,-32
    1190:	ec06                	sd	ra,24(sp)
    1192:	e822                	sd	s0,16(sp)
    1194:	e04a                	sd	s2,0(sp)
    1196:	1000                	addi	s0,sp,32
    1198:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    119a:	4581                	li	a1,0
    119c:	162000ef          	jal	12fe <open>
  if(fd < 0)
    11a0:	02054263          	bltz	a0,11c4 <stat+0x36>
    11a4:	e426                	sd	s1,8(sp)
    11a6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11a8:	85ca                	mv	a1,s2
    11aa:	16c000ef          	jal	1316 <fstat>
    11ae:	892a                	mv	s2,a0
  close(fd);
    11b0:	8526                	mv	a0,s1
    11b2:	134000ef          	jal	12e6 <close>
  return r;
    11b6:	64a2                	ld	s1,8(sp)
}
    11b8:	854a                	mv	a0,s2
    11ba:	60e2                	ld	ra,24(sp)
    11bc:	6442                	ld	s0,16(sp)
    11be:	6902                	ld	s2,0(sp)
    11c0:	6105                	addi	sp,sp,32
    11c2:	8082                	ret
    return -1;
    11c4:	597d                	li	s2,-1
    11c6:	bfcd                	j	11b8 <stat+0x2a>

00000000000011c8 <atoi>:

int
atoi(const char *s)
{
    11c8:	1141                	addi	sp,sp,-16
    11ca:	e422                	sd	s0,8(sp)
    11cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11ce:	00054683          	lbu	a3,0(a0)
    11d2:	fd06879b          	addiw	a5,a3,-48
    11d6:	0ff7f793          	zext.b	a5,a5
    11da:	4625                	li	a2,9
    11dc:	02f66863          	bltu	a2,a5,120c <atoi+0x44>
    11e0:	872a                	mv	a4,a0
  n = 0;
    11e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    11e4:	0705                	addi	a4,a4,1
    11e6:	0025179b          	slliw	a5,a0,0x2
    11ea:	9fa9                	addw	a5,a5,a0
    11ec:	0017979b          	slliw	a5,a5,0x1
    11f0:	9fb5                	addw	a5,a5,a3
    11f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    11f6:	00074683          	lbu	a3,0(a4)
    11fa:	fd06879b          	addiw	a5,a3,-48
    11fe:	0ff7f793          	zext.b	a5,a5
    1202:	fef671e3          	bgeu	a2,a5,11e4 <atoi+0x1c>
  return n;
}
    1206:	6422                	ld	s0,8(sp)
    1208:	0141                	addi	sp,sp,16
    120a:	8082                	ret
  n = 0;
    120c:	4501                	li	a0,0
    120e:	bfe5                	j	1206 <atoi+0x3e>

0000000000001210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1210:	1141                	addi	sp,sp,-16
    1212:	e422                	sd	s0,8(sp)
    1214:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1216:	02b57463          	bgeu	a0,a1,123e <memmove+0x2e>
    while(n-- > 0)
    121a:	00c05f63          	blez	a2,1238 <memmove+0x28>
    121e:	1602                	slli	a2,a2,0x20
    1220:	9201                	srli	a2,a2,0x20
    1222:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1226:	872a                	mv	a4,a0
      *dst++ = *src++;
    1228:	0585                	addi	a1,a1,1
    122a:	0705                	addi	a4,a4,1
    122c:	fff5c683          	lbu	a3,-1(a1)
    1230:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1234:	fef71ae3          	bne	a4,a5,1228 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1238:	6422                	ld	s0,8(sp)
    123a:	0141                	addi	sp,sp,16
    123c:	8082                	ret
    dst += n;
    123e:	00c50733          	add	a4,a0,a2
    src += n;
    1242:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1244:	fec05ae3          	blez	a2,1238 <memmove+0x28>
    1248:	fff6079b          	addiw	a5,a2,-1
    124c:	1782                	slli	a5,a5,0x20
    124e:	9381                	srli	a5,a5,0x20
    1250:	fff7c793          	not	a5,a5
    1254:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1256:	15fd                	addi	a1,a1,-1
    1258:	177d                	addi	a4,a4,-1
    125a:	0005c683          	lbu	a3,0(a1)
    125e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1262:	fee79ae3          	bne	a5,a4,1256 <memmove+0x46>
    1266:	bfc9                	j	1238 <memmove+0x28>

0000000000001268 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1268:	1141                	addi	sp,sp,-16
    126a:	e422                	sd	s0,8(sp)
    126c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    126e:	ca05                	beqz	a2,129e <memcmp+0x36>
    1270:	fff6069b          	addiw	a3,a2,-1
    1274:	1682                	slli	a3,a3,0x20
    1276:	9281                	srli	a3,a3,0x20
    1278:	0685                	addi	a3,a3,1
    127a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    127c:	00054783          	lbu	a5,0(a0)
    1280:	0005c703          	lbu	a4,0(a1)
    1284:	00e79863          	bne	a5,a4,1294 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1288:	0505                	addi	a0,a0,1
    p2++;
    128a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    128c:	fed518e3          	bne	a0,a3,127c <memcmp+0x14>
  }
  return 0;
    1290:	4501                	li	a0,0
    1292:	a019                	j	1298 <memcmp+0x30>
      return *p1 - *p2;
    1294:	40e7853b          	subw	a0,a5,a4
}
    1298:	6422                	ld	s0,8(sp)
    129a:	0141                	addi	sp,sp,16
    129c:	8082                	ret
  return 0;
    129e:	4501                	li	a0,0
    12a0:	bfe5                	j	1298 <memcmp+0x30>

00000000000012a2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    12a2:	1141                	addi	sp,sp,-16
    12a4:	e406                	sd	ra,8(sp)
    12a6:	e022                	sd	s0,0(sp)
    12a8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    12aa:	f67ff0ef          	jal	1210 <memmove>
}
    12ae:	60a2                	ld	ra,8(sp)
    12b0:	6402                	ld	s0,0(sp)
    12b2:	0141                	addi	sp,sp,16
    12b4:	8082                	ret

00000000000012b6 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12b6:	4885                	li	a7,1
 ecall
    12b8:	00000073          	ecall
 ret
    12bc:	8082                	ret

00000000000012be <exit>:
.global exit
exit:
 li a7, SYS_exit
    12be:	4889                	li	a7,2
 ecall
    12c0:	00000073          	ecall
 ret
    12c4:	8082                	ret

00000000000012c6 <wait>:
.global wait
wait:
 li a7, SYS_wait
    12c6:	488d                	li	a7,3
 ecall
    12c8:	00000073          	ecall
 ret
    12cc:	8082                	ret

00000000000012ce <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    12ce:	4891                	li	a7,4
 ecall
    12d0:	00000073          	ecall
 ret
    12d4:	8082                	ret

00000000000012d6 <read>:
.global read
read:
 li a7, SYS_read
    12d6:	4895                	li	a7,5
 ecall
    12d8:	00000073          	ecall
 ret
    12dc:	8082                	ret

00000000000012de <write>:
.global write
write:
 li a7, SYS_write
    12de:	48c1                	li	a7,16
 ecall
    12e0:	00000073          	ecall
 ret
    12e4:	8082                	ret

00000000000012e6 <close>:
.global close
close:
 li a7, SYS_close
    12e6:	48d5                	li	a7,21
 ecall
    12e8:	00000073          	ecall
 ret
    12ec:	8082                	ret

00000000000012ee <kill>:
.global kill
kill:
 li a7, SYS_kill
    12ee:	4899                	li	a7,6
 ecall
    12f0:	00000073          	ecall
 ret
    12f4:	8082                	ret

00000000000012f6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    12f6:	489d                	li	a7,7
 ecall
    12f8:	00000073          	ecall
 ret
    12fc:	8082                	ret

00000000000012fe <open>:
.global open
open:
 li a7, SYS_open
    12fe:	48bd                	li	a7,15
 ecall
    1300:	00000073          	ecall
 ret
    1304:	8082                	ret

0000000000001306 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1306:	48c5                	li	a7,17
 ecall
    1308:	00000073          	ecall
 ret
    130c:	8082                	ret

000000000000130e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    130e:	48c9                	li	a7,18
 ecall
    1310:	00000073          	ecall
 ret
    1314:	8082                	ret

0000000000001316 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1316:	48a1                	li	a7,8
 ecall
    1318:	00000073          	ecall
 ret
    131c:	8082                	ret

000000000000131e <link>:
.global link
link:
 li a7, SYS_link
    131e:	48cd                	li	a7,19
 ecall
    1320:	00000073          	ecall
 ret
    1324:	8082                	ret

0000000000001326 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1326:	48d1                	li	a7,20
 ecall
    1328:	00000073          	ecall
 ret
    132c:	8082                	ret

000000000000132e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    132e:	48a5                	li	a7,9
 ecall
    1330:	00000073          	ecall
 ret
    1334:	8082                	ret

0000000000001336 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1336:	48a9                	li	a7,10
 ecall
    1338:	00000073          	ecall
 ret
    133c:	8082                	ret

000000000000133e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    133e:	48ad                	li	a7,11
 ecall
    1340:	00000073          	ecall
 ret
    1344:	8082                	ret

0000000000001346 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1346:	48b1                	li	a7,12
 ecall
    1348:	00000073          	ecall
 ret
    134c:	8082                	ret

000000000000134e <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    134e:	48b5                	li	a7,13
 ecall
    1350:	00000073          	ecall
 ret
    1354:	8082                	ret

0000000000001356 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1356:	48b9                	li	a7,14
 ecall
    1358:	00000073          	ecall
 ret
    135c:	8082                	ret

000000000000135e <cps>:
.global cps
cps:
 li a7, SYS_cps
    135e:	48d9                	li	a7,22
 ecall
    1360:	00000073          	ecall
 ret
    1364:	8082                	ret

0000000000001366 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1366:	48dd                	li	a7,23
 ecall
    1368:	00000073          	ecall
 ret
    136c:	8082                	ret

000000000000136e <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    136e:	48e1                	li	a7,24
 ecall
    1370:	00000073          	ecall
 ret
    1374:	8082                	ret

0000000000001376 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1376:	48e5                	li	a7,25
 ecall
    1378:	00000073          	ecall
 ret
    137c:	8082                	ret

000000000000137e <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    137e:	48e9                	li	a7,26
 ecall
    1380:	00000073          	ecall
 ret
    1384:	8082                	ret

0000000000001386 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    1386:	48ed                	li	a7,27
 ecall
    1388:	00000073          	ecall
 ret
    138c:	8082                	ret

000000000000138e <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    138e:	48f1                	li	a7,28
 ecall
    1390:	00000073          	ecall
 ret
    1394:	8082                	ret

0000000000001396 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    1396:	48f5                	li	a7,29
 ecall
    1398:	00000073          	ecall
 ret
    139c:	8082                	ret

000000000000139e <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    139e:	48f9                	li	a7,30
 ecall
    13a0:	00000073          	ecall
 ret
    13a4:	8082                	ret

00000000000013a6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    13a6:	1101                	addi	sp,sp,-32
    13a8:	ec06                	sd	ra,24(sp)
    13aa:	e822                	sd	s0,16(sp)
    13ac:	1000                	addi	s0,sp,32
    13ae:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13b2:	4605                	li	a2,1
    13b4:	fef40593          	addi	a1,s0,-17
    13b8:	f27ff0ef          	jal	12de <write>
}
    13bc:	60e2                	ld	ra,24(sp)
    13be:	6442                	ld	s0,16(sp)
    13c0:	6105                	addi	sp,sp,32
    13c2:	8082                	ret

00000000000013c4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13c4:	7139                	addi	sp,sp,-64
    13c6:	fc06                	sd	ra,56(sp)
    13c8:	f822                	sd	s0,48(sp)
    13ca:	f426                	sd	s1,40(sp)
    13cc:	0080                	addi	s0,sp,64
    13ce:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13d0:	c299                	beqz	a3,13d6 <printint+0x12>
    13d2:	0805c963          	bltz	a1,1464 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13d6:	2581                	sext.w	a1,a1
  neg = 0;
    13d8:	4881                	li	a7,0
    13da:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13de:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13e0:	2601                	sext.w	a2,a2
    13e2:	00001517          	auipc	a0,0x1
    13e6:	c3e50513          	addi	a0,a0,-962 # 2020 <digits>
    13ea:	883a                	mv	a6,a4
    13ec:	2705                	addiw	a4,a4,1
    13ee:	02c5f7bb          	remuw	a5,a1,a2
    13f2:	1782                	slli	a5,a5,0x20
    13f4:	9381                	srli	a5,a5,0x20
    13f6:	97aa                	add	a5,a5,a0
    13f8:	0007c783          	lbu	a5,0(a5)
    13fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1400:	0005879b          	sext.w	a5,a1
    1404:	02c5d5bb          	divuw	a1,a1,a2
    1408:	0685                	addi	a3,a3,1
    140a:	fec7f0e3          	bgeu	a5,a2,13ea <printint+0x26>
  if(neg)
    140e:	00088c63          	beqz	a7,1426 <printint+0x62>
    buf[i++] = '-';
    1412:	fd070793          	addi	a5,a4,-48
    1416:	00878733          	add	a4,a5,s0
    141a:	02d00793          	li	a5,45
    141e:	fef70823          	sb	a5,-16(a4)
    1422:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1426:	02e05a63          	blez	a4,145a <printint+0x96>
    142a:	f04a                	sd	s2,32(sp)
    142c:	ec4e                	sd	s3,24(sp)
    142e:	fc040793          	addi	a5,s0,-64
    1432:	00e78933          	add	s2,a5,a4
    1436:	fff78993          	addi	s3,a5,-1
    143a:	99ba                	add	s3,s3,a4
    143c:	377d                	addiw	a4,a4,-1
    143e:	1702                	slli	a4,a4,0x20
    1440:	9301                	srli	a4,a4,0x20
    1442:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1446:	fff94583          	lbu	a1,-1(s2)
    144a:	8526                	mv	a0,s1
    144c:	f5bff0ef          	jal	13a6 <putc>
  while(--i >= 0)
    1450:	197d                	addi	s2,s2,-1
    1452:	ff391ae3          	bne	s2,s3,1446 <printint+0x82>
    1456:	7902                	ld	s2,32(sp)
    1458:	69e2                	ld	s3,24(sp)
}
    145a:	70e2                	ld	ra,56(sp)
    145c:	7442                	ld	s0,48(sp)
    145e:	74a2                	ld	s1,40(sp)
    1460:	6121                	addi	sp,sp,64
    1462:	8082                	ret
    x = -xx;
    1464:	40b005bb          	negw	a1,a1
    neg = 1;
    1468:	4885                	li	a7,1
    x = -xx;
    146a:	bf85                	j	13da <printint+0x16>

000000000000146c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    146c:	711d                	addi	sp,sp,-96
    146e:	ec86                	sd	ra,88(sp)
    1470:	e8a2                	sd	s0,80(sp)
    1472:	e0ca                	sd	s2,64(sp)
    1474:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1476:	0005c903          	lbu	s2,0(a1)
    147a:	26090863          	beqz	s2,16ea <vprintf+0x27e>
    147e:	e4a6                	sd	s1,72(sp)
    1480:	fc4e                	sd	s3,56(sp)
    1482:	f852                	sd	s4,48(sp)
    1484:	f456                	sd	s5,40(sp)
    1486:	f05a                	sd	s6,32(sp)
    1488:	ec5e                	sd	s7,24(sp)
    148a:	e862                	sd	s8,16(sp)
    148c:	e466                	sd	s9,8(sp)
    148e:	8b2a                	mv	s6,a0
    1490:	8a2e                	mv	s4,a1
    1492:	8bb2                	mv	s7,a2
  state = 0;
    1494:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1496:	4481                	li	s1,0
    1498:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    149a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    149e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    14a2:	06c00c93          	li	s9,108
    14a6:	a005                	j	14c6 <vprintf+0x5a>
        putc(fd, c0);
    14a8:	85ca                	mv	a1,s2
    14aa:	855a                	mv	a0,s6
    14ac:	efbff0ef          	jal	13a6 <putc>
    14b0:	a019                	j	14b6 <vprintf+0x4a>
    } else if(state == '%'){
    14b2:	03598263          	beq	s3,s5,14d6 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    14b6:	2485                	addiw	s1,s1,1
    14b8:	8726                	mv	a4,s1
    14ba:	009a07b3          	add	a5,s4,s1
    14be:	0007c903          	lbu	s2,0(a5)
    14c2:	20090c63          	beqz	s2,16da <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    14c6:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14ca:	fe0994e3          	bnez	s3,14b2 <vprintf+0x46>
      if(c0 == '%'){
    14ce:	fd579de3          	bne	a5,s5,14a8 <vprintf+0x3c>
        state = '%';
    14d2:	89be                	mv	s3,a5
    14d4:	b7cd                	j	14b6 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14d6:	00ea06b3          	add	a3,s4,a4
    14da:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    14de:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    14e0:	c681                	beqz	a3,14e8 <vprintf+0x7c>
    14e2:	9752                	add	a4,a4,s4
    14e4:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    14e8:	03878f63          	beq	a5,s8,1526 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    14ec:	05978963          	beq	a5,s9,153e <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    14f0:	07500713          	li	a4,117
    14f4:	0ee78363          	beq	a5,a4,15da <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    14f8:	07800713          	li	a4,120
    14fc:	12e78563          	beq	a5,a4,1626 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1500:	07000713          	li	a4,112
    1504:	14e78a63          	beq	a5,a4,1658 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1508:	07300713          	li	a4,115
    150c:	18e78a63          	beq	a5,a4,16a0 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1510:	02500713          	li	a4,37
    1514:	04e79563          	bne	a5,a4,155e <vprintf+0xf2>
        putc(fd, '%');
    1518:	02500593          	li	a1,37
    151c:	855a                	mv	a0,s6
    151e:	e89ff0ef          	jal	13a6 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1522:	4981                	li	s3,0
    1524:	bf49                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1526:	008b8913          	addi	s2,s7,8
    152a:	4685                	li	a3,1
    152c:	4629                	li	a2,10
    152e:	000ba583          	lw	a1,0(s7)
    1532:	855a                	mv	a0,s6
    1534:	e91ff0ef          	jal	13c4 <printint>
    1538:	8bca                	mv	s7,s2
      state = 0;
    153a:	4981                	li	s3,0
    153c:	bfad                	j	14b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    153e:	06400793          	li	a5,100
    1542:	02f68963          	beq	a3,a5,1574 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1546:	06c00793          	li	a5,108
    154a:	04f68263          	beq	a3,a5,158e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    154e:	07500793          	li	a5,117
    1552:	0af68063          	beq	a3,a5,15f2 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1556:	07800793          	li	a5,120
    155a:	0ef68263          	beq	a3,a5,163e <vprintf+0x1d2>
        putc(fd, '%');
    155e:	02500593          	li	a1,37
    1562:	855a                	mv	a0,s6
    1564:	e43ff0ef          	jal	13a6 <putc>
        putc(fd, c0);
    1568:	85ca                	mv	a1,s2
    156a:	855a                	mv	a0,s6
    156c:	e3bff0ef          	jal	13a6 <putc>
      state = 0;
    1570:	4981                	li	s3,0
    1572:	b791                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1574:	008b8913          	addi	s2,s7,8
    1578:	4685                	li	a3,1
    157a:	4629                	li	a2,10
    157c:	000ba583          	lw	a1,0(s7)
    1580:	855a                	mv	a0,s6
    1582:	e43ff0ef          	jal	13c4 <printint>
        i += 1;
    1586:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1588:	8bca                	mv	s7,s2
      state = 0;
    158a:	4981                	li	s3,0
        i += 1;
    158c:	b72d                	j	14b6 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    158e:	06400793          	li	a5,100
    1592:	02f60763          	beq	a2,a5,15c0 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1596:	07500793          	li	a5,117
    159a:	06f60963          	beq	a2,a5,160c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    159e:	07800793          	li	a5,120
    15a2:	faf61ee3          	bne	a2,a5,155e <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    15a6:	008b8913          	addi	s2,s7,8
    15aa:	4681                	li	a3,0
    15ac:	4641                	li	a2,16
    15ae:	000ba583          	lw	a1,0(s7)
    15b2:	855a                	mv	a0,s6
    15b4:	e11ff0ef          	jal	13c4 <printint>
        i += 2;
    15b8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    15ba:	8bca                	mv	s7,s2
      state = 0;
    15bc:	4981                	li	s3,0
        i += 2;
    15be:	bde5                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15c0:	008b8913          	addi	s2,s7,8
    15c4:	4685                	li	a3,1
    15c6:	4629                	li	a2,10
    15c8:	000ba583          	lw	a1,0(s7)
    15cc:	855a                	mv	a0,s6
    15ce:	df7ff0ef          	jal	13c4 <printint>
        i += 2;
    15d2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15d4:	8bca                	mv	s7,s2
      state = 0;
    15d6:	4981                	li	s3,0
        i += 2;
    15d8:	bdf9                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    15da:	008b8913          	addi	s2,s7,8
    15de:	4681                	li	a3,0
    15e0:	4629                	li	a2,10
    15e2:	000ba583          	lw	a1,0(s7)
    15e6:	855a                	mv	a0,s6
    15e8:	dddff0ef          	jal	13c4 <printint>
    15ec:	8bca                	mv	s7,s2
      state = 0;
    15ee:	4981                	li	s3,0
    15f0:	b5d9                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15f2:	008b8913          	addi	s2,s7,8
    15f6:	4681                	li	a3,0
    15f8:	4629                	li	a2,10
    15fa:	000ba583          	lw	a1,0(s7)
    15fe:	855a                	mv	a0,s6
    1600:	dc5ff0ef          	jal	13c4 <printint>
        i += 1;
    1604:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1606:	8bca                	mv	s7,s2
      state = 0;
    1608:	4981                	li	s3,0
        i += 1;
    160a:	b575                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    160c:	008b8913          	addi	s2,s7,8
    1610:	4681                	li	a3,0
    1612:	4629                	li	a2,10
    1614:	000ba583          	lw	a1,0(s7)
    1618:	855a                	mv	a0,s6
    161a:	dabff0ef          	jal	13c4 <printint>
        i += 2;
    161e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1620:	8bca                	mv	s7,s2
      state = 0;
    1622:	4981                	li	s3,0
        i += 2;
    1624:	bd49                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1626:	008b8913          	addi	s2,s7,8
    162a:	4681                	li	a3,0
    162c:	4641                	li	a2,16
    162e:	000ba583          	lw	a1,0(s7)
    1632:	855a                	mv	a0,s6
    1634:	d91ff0ef          	jal	13c4 <printint>
    1638:	8bca                	mv	s7,s2
      state = 0;
    163a:	4981                	li	s3,0
    163c:	bdad                	j	14b6 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    163e:	008b8913          	addi	s2,s7,8
    1642:	4681                	li	a3,0
    1644:	4641                	li	a2,16
    1646:	000ba583          	lw	a1,0(s7)
    164a:	855a                	mv	a0,s6
    164c:	d79ff0ef          	jal	13c4 <printint>
        i += 1;
    1650:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1652:	8bca                	mv	s7,s2
      state = 0;
    1654:	4981                	li	s3,0
        i += 1;
    1656:	b585                	j	14b6 <vprintf+0x4a>
    1658:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    165a:	008b8d13          	addi	s10,s7,8
    165e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1662:	03000593          	li	a1,48
    1666:	855a                	mv	a0,s6
    1668:	d3fff0ef          	jal	13a6 <putc>
  putc(fd, 'x');
    166c:	07800593          	li	a1,120
    1670:	855a                	mv	a0,s6
    1672:	d35ff0ef          	jal	13a6 <putc>
    1676:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1678:	00001b97          	auipc	s7,0x1
    167c:	9a8b8b93          	addi	s7,s7,-1624 # 2020 <digits>
    1680:	03c9d793          	srli	a5,s3,0x3c
    1684:	97de                	add	a5,a5,s7
    1686:	0007c583          	lbu	a1,0(a5)
    168a:	855a                	mv	a0,s6
    168c:	d1bff0ef          	jal	13a6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1690:	0992                	slli	s3,s3,0x4
    1692:	397d                	addiw	s2,s2,-1
    1694:	fe0916e3          	bnez	s2,1680 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1698:	8bea                	mv	s7,s10
      state = 0;
    169a:	4981                	li	s3,0
    169c:	6d02                	ld	s10,0(sp)
    169e:	bd21                	j	14b6 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    16a0:	008b8993          	addi	s3,s7,8
    16a4:	000bb903          	ld	s2,0(s7)
    16a8:	00090f63          	beqz	s2,16c6 <vprintf+0x25a>
        for(; *s; s++)
    16ac:	00094583          	lbu	a1,0(s2)
    16b0:	c195                	beqz	a1,16d4 <vprintf+0x268>
          putc(fd, *s);
    16b2:	855a                	mv	a0,s6
    16b4:	cf3ff0ef          	jal	13a6 <putc>
        for(; *s; s++)
    16b8:	0905                	addi	s2,s2,1
    16ba:	00094583          	lbu	a1,0(s2)
    16be:	f9f5                	bnez	a1,16b2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16c0:	8bce                	mv	s7,s3
      state = 0;
    16c2:	4981                	li	s3,0
    16c4:	bbcd                	j	14b6 <vprintf+0x4a>
          s = "(null)";
    16c6:	00001917          	auipc	s2,0x1
    16ca:	95290913          	addi	s2,s2,-1710 # 2018 <malloc+0x846>
        for(; *s; s++)
    16ce:	02800593          	li	a1,40
    16d2:	b7c5                	j	16b2 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16d4:	8bce                	mv	s7,s3
      state = 0;
    16d6:	4981                	li	s3,0
    16d8:	bbf9                	j	14b6 <vprintf+0x4a>
    16da:	64a6                	ld	s1,72(sp)
    16dc:	79e2                	ld	s3,56(sp)
    16de:	7a42                	ld	s4,48(sp)
    16e0:	7aa2                	ld	s5,40(sp)
    16e2:	7b02                	ld	s6,32(sp)
    16e4:	6be2                	ld	s7,24(sp)
    16e6:	6c42                	ld	s8,16(sp)
    16e8:	6ca2                	ld	s9,8(sp)
    }
  }
}
    16ea:	60e6                	ld	ra,88(sp)
    16ec:	6446                	ld	s0,80(sp)
    16ee:	6906                	ld	s2,64(sp)
    16f0:	6125                	addi	sp,sp,96
    16f2:	8082                	ret

00000000000016f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    16f4:	715d                	addi	sp,sp,-80
    16f6:	ec06                	sd	ra,24(sp)
    16f8:	e822                	sd	s0,16(sp)
    16fa:	1000                	addi	s0,sp,32
    16fc:	e010                	sd	a2,0(s0)
    16fe:	e414                	sd	a3,8(s0)
    1700:	e818                	sd	a4,16(s0)
    1702:	ec1c                	sd	a5,24(s0)
    1704:	03043023          	sd	a6,32(s0)
    1708:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    170c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1710:	8622                	mv	a2,s0
    1712:	d5bff0ef          	jal	146c <vprintf>
}
    1716:	60e2                	ld	ra,24(sp)
    1718:	6442                	ld	s0,16(sp)
    171a:	6161                	addi	sp,sp,80
    171c:	8082                	ret

000000000000171e <printf>:

void
printf(const char *fmt, ...)
{
    171e:	711d                	addi	sp,sp,-96
    1720:	ec06                	sd	ra,24(sp)
    1722:	e822                	sd	s0,16(sp)
    1724:	1000                	addi	s0,sp,32
    1726:	e40c                	sd	a1,8(s0)
    1728:	e810                	sd	a2,16(s0)
    172a:	ec14                	sd	a3,24(s0)
    172c:	f018                	sd	a4,32(s0)
    172e:	f41c                	sd	a5,40(s0)
    1730:	03043823          	sd	a6,48(s0)
    1734:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1738:	00840613          	addi	a2,s0,8
    173c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1740:	85aa                	mv	a1,a0
    1742:	4505                	li	a0,1
    1744:	d29ff0ef          	jal	146c <vprintf>
}
    1748:	60e2                	ld	ra,24(sp)
    174a:	6442                	ld	s0,16(sp)
    174c:	6125                	addi	sp,sp,96
    174e:	8082                	ret

0000000000001750 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1750:	1141                	addi	sp,sp,-16
    1752:	e422                	sd	s0,8(sp)
    1754:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1756:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    175a:	00001797          	auipc	a5,0x1
    175e:	8e67b783          	ld	a5,-1818(a5) # 2040 <freep>
    1762:	a02d                	j	178c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1764:	4618                	lw	a4,8(a2)
    1766:	9f2d                	addw	a4,a4,a1
    1768:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    176c:	6398                	ld	a4,0(a5)
    176e:	6310                	ld	a2,0(a4)
    1770:	a83d                	j	17ae <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1772:	ff852703          	lw	a4,-8(a0)
    1776:	9f31                	addw	a4,a4,a2
    1778:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    177a:	ff053683          	ld	a3,-16(a0)
    177e:	a091                	j	17c2 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1780:	6398                	ld	a4,0(a5)
    1782:	00e7e463          	bltu	a5,a4,178a <free+0x3a>
    1786:	00e6ea63          	bltu	a3,a4,179a <free+0x4a>
{
    178a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    178c:	fed7fae3          	bgeu	a5,a3,1780 <free+0x30>
    1790:	6398                	ld	a4,0(a5)
    1792:	00e6e463          	bltu	a3,a4,179a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1796:	fee7eae3          	bltu	a5,a4,178a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    179a:	ff852583          	lw	a1,-8(a0)
    179e:	6390                	ld	a2,0(a5)
    17a0:	02059813          	slli	a6,a1,0x20
    17a4:	01c85713          	srli	a4,a6,0x1c
    17a8:	9736                	add	a4,a4,a3
    17aa:	fae60de3          	beq	a2,a4,1764 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    17ae:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    17b2:	4790                	lw	a2,8(a5)
    17b4:	02061593          	slli	a1,a2,0x20
    17b8:	01c5d713          	srli	a4,a1,0x1c
    17bc:	973e                	add	a4,a4,a5
    17be:	fae68ae3          	beq	a3,a4,1772 <free+0x22>
    p->s.ptr = bp->s.ptr;
    17c2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    17c4:	00001717          	auipc	a4,0x1
    17c8:	86f73e23          	sd	a5,-1924(a4) # 2040 <freep>
}
    17cc:	6422                	ld	s0,8(sp)
    17ce:	0141                	addi	sp,sp,16
    17d0:	8082                	ret

00000000000017d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17d2:	7139                	addi	sp,sp,-64
    17d4:	fc06                	sd	ra,56(sp)
    17d6:	f822                	sd	s0,48(sp)
    17d8:	f426                	sd	s1,40(sp)
    17da:	ec4e                	sd	s3,24(sp)
    17dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17de:	02051493          	slli	s1,a0,0x20
    17e2:	9081                	srli	s1,s1,0x20
    17e4:	04bd                	addi	s1,s1,15
    17e6:	8091                	srli	s1,s1,0x4
    17e8:	0014899b          	addiw	s3,s1,1
    17ec:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    17ee:	00001517          	auipc	a0,0x1
    17f2:	85253503          	ld	a0,-1966(a0) # 2040 <freep>
    17f6:	c915                	beqz	a0,182a <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17f8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    17fa:	4798                	lw	a4,8(a5)
    17fc:	08977a63          	bgeu	a4,s1,1890 <malloc+0xbe>
    1800:	f04a                	sd	s2,32(sp)
    1802:	e852                	sd	s4,16(sp)
    1804:	e456                	sd	s5,8(sp)
    1806:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1808:	8a4e                	mv	s4,s3
    180a:	0009871b          	sext.w	a4,s3
    180e:	6685                	lui	a3,0x1
    1810:	00d77363          	bgeu	a4,a3,1816 <malloc+0x44>
    1814:	6a05                	lui	s4,0x1
    1816:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    181a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    181e:	00001917          	auipc	s2,0x1
    1822:	82290913          	addi	s2,s2,-2014 # 2040 <freep>
  if(p == (char*)-1)
    1826:	5afd                	li	s5,-1
    1828:	a081                	j	1868 <malloc+0x96>
    182a:	f04a                	sd	s2,32(sp)
    182c:	e852                	sd	s4,16(sp)
    182e:	e456                	sd	s5,8(sp)
    1830:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1832:	00001797          	auipc	a5,0x1
    1836:	81e78793          	addi	a5,a5,-2018 # 2050 <base>
    183a:	00001717          	auipc	a4,0x1
    183e:	80f73323          	sd	a5,-2042(a4) # 2040 <freep>
    1842:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1844:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1848:	b7c1                	j	1808 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    184a:	6398                	ld	a4,0(a5)
    184c:	e118                	sd	a4,0(a0)
    184e:	a8a9                	j	18a8 <malloc+0xd6>
  hp->s.size = nu;
    1850:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1854:	0541                	addi	a0,a0,16
    1856:	efbff0ef          	jal	1750 <free>
  return freep;
    185a:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    185e:	c12d                	beqz	a0,18c0 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1862:	4798                	lw	a4,8(a5)
    1864:	02977263          	bgeu	a4,s1,1888 <malloc+0xb6>
    if(p == freep)
    1868:	00093703          	ld	a4,0(s2)
    186c:	853e                	mv	a0,a5
    186e:	fef719e3          	bne	a4,a5,1860 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1872:	8552                	mv	a0,s4
    1874:	ad3ff0ef          	jal	1346 <sbrk>
  if(p == (char*)-1)
    1878:	fd551ce3          	bne	a0,s5,1850 <malloc+0x7e>
        return 0;
    187c:	4501                	li	a0,0
    187e:	7902                	ld	s2,32(sp)
    1880:	6a42                	ld	s4,16(sp)
    1882:	6aa2                	ld	s5,8(sp)
    1884:	6b02                	ld	s6,0(sp)
    1886:	a03d                	j	18b4 <malloc+0xe2>
    1888:	7902                	ld	s2,32(sp)
    188a:	6a42                	ld	s4,16(sp)
    188c:	6aa2                	ld	s5,8(sp)
    188e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1890:	fae48de3          	beq	s1,a4,184a <malloc+0x78>
        p->s.size -= nunits;
    1894:	4137073b          	subw	a4,a4,s3
    1898:	c798                	sw	a4,8(a5)
        p += p->s.size;
    189a:	02071693          	slli	a3,a4,0x20
    189e:	01c6d713          	srli	a4,a3,0x1c
    18a2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    18a4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    18a8:	00000717          	auipc	a4,0x0
    18ac:	78a73c23          	sd	a0,1944(a4) # 2040 <freep>
      return (void*)(p + 1);
    18b0:	01078513          	addi	a0,a5,16
  }
}
    18b4:	70e2                	ld	ra,56(sp)
    18b6:	7442                	ld	s0,48(sp)
    18b8:	74a2                	ld	s1,40(sp)
    18ba:	69e2                	ld	s3,24(sp)
    18bc:	6121                	addi	sp,sp,64
    18be:	8082                	ret
    18c0:	7902                	ld	s2,32(sp)
    18c2:	6a42                	ld	s4,16(sp)
    18c4:	6aa2                	ld	s5,8(sp)
    18c6:	6b02                	ld	s6,0(sp)
    18c8:	b7f5                	j	18b4 <malloc+0xe2>
	...
