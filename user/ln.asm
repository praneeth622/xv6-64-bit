
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	1000                	addi	s0,sp,32
  if(argc != 3){
    1008:	478d                	li	a5,3
    100a:	00f50d63          	beq	a0,a5,1024 <main+0x24>
    100e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
    1010:	00001597          	auipc	a1,0x1
    1014:	ff058593          	addi	a1,a1,-16 # 2000 <malloc+0x834>
    1018:	4509                	li	a0,2
    101a:	6d4000ef          	jal	16ee <fprintf>
    exit(1);
    101e:	4505                	li	a0,1
    1020:	298000ef          	jal	12b8 <exit>
    1024:	e426                	sd	s1,8(sp)
    1026:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
    1028:	698c                	ld	a1,16(a1)
    102a:	6488                	ld	a0,8(s1)
    102c:	2ec000ef          	jal	1318 <link>
    1030:	00054563          	bltz	a0,103a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
    1034:	4501                	li	a0,0
    1036:	282000ef          	jal	12b8 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
    103a:	6894                	ld	a3,16(s1)
    103c:	6490                	ld	a2,8(s1)
    103e:	00001597          	auipc	a1,0x1
    1042:	fda58593          	addi	a1,a1,-38 # 2018 <malloc+0x84c>
    1046:	4509                	li	a0,2
    1048:	6a6000ef          	jal	16ee <fprintf>
    104c:	b7e5                	j	1034 <main+0x34>

000000000000104e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    104e:	1141                	addi	sp,sp,-16
    1050:	e406                	sd	ra,8(sp)
    1052:	e022                	sd	s0,0(sp)
    1054:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1056:	fabff0ef          	jal	1000 <main>
  exit(0);
    105a:	4501                	li	a0,0
    105c:	25c000ef          	jal	12b8 <exit>

0000000000001060 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1060:	1141                	addi	sp,sp,-16
    1062:	e422                	sd	s0,8(sp)
    1064:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1066:	87aa                	mv	a5,a0
    1068:	0585                	addi	a1,a1,1
    106a:	0785                	addi	a5,a5,1
    106c:	fff5c703          	lbu	a4,-1(a1)
    1070:	fee78fa3          	sb	a4,-1(a5)
    1074:	fb75                	bnez	a4,1068 <strcpy+0x8>
    ;
  return os;
}
    1076:	6422                	ld	s0,8(sp)
    1078:	0141                	addi	sp,sp,16
    107a:	8082                	ret

000000000000107c <strcmp>:

int
strcmp(const char *p, const char *q)
{
    107c:	1141                	addi	sp,sp,-16
    107e:	e422                	sd	s0,8(sp)
    1080:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1082:	00054783          	lbu	a5,0(a0)
    1086:	cb91                	beqz	a5,109a <strcmp+0x1e>
    1088:	0005c703          	lbu	a4,0(a1)
    108c:	00f71763          	bne	a4,a5,109a <strcmp+0x1e>
    p++, q++;
    1090:	0505                	addi	a0,a0,1
    1092:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1094:	00054783          	lbu	a5,0(a0)
    1098:	fbe5                	bnez	a5,1088 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    109a:	0005c503          	lbu	a0,0(a1)
}
    109e:	40a7853b          	subw	a0,a5,a0
    10a2:	6422                	ld	s0,8(sp)
    10a4:	0141                	addi	sp,sp,16
    10a6:	8082                	ret

00000000000010a8 <strlen>:

uint
strlen(const char *s)
{
    10a8:	1141                	addi	sp,sp,-16
    10aa:	e422                	sd	s0,8(sp)
    10ac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10ae:	00054783          	lbu	a5,0(a0)
    10b2:	cf91                	beqz	a5,10ce <strlen+0x26>
    10b4:	0505                	addi	a0,a0,1
    10b6:	87aa                	mv	a5,a0
    10b8:	86be                	mv	a3,a5
    10ba:	0785                	addi	a5,a5,1
    10bc:	fff7c703          	lbu	a4,-1(a5)
    10c0:	ff65                	bnez	a4,10b8 <strlen+0x10>
    10c2:	40a6853b          	subw	a0,a3,a0
    10c6:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    10c8:	6422                	ld	s0,8(sp)
    10ca:	0141                	addi	sp,sp,16
    10cc:	8082                	ret
  for(n = 0; s[n]; n++)
    10ce:	4501                	li	a0,0
    10d0:	bfe5                	j	10c8 <strlen+0x20>

00000000000010d2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10d2:	1141                	addi	sp,sp,-16
    10d4:	e422                	sd	s0,8(sp)
    10d6:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10d8:	ca19                	beqz	a2,10ee <memset+0x1c>
    10da:	87aa                	mv	a5,a0
    10dc:	1602                	slli	a2,a2,0x20
    10de:	9201                	srli	a2,a2,0x20
    10e0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    10e4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    10e8:	0785                	addi	a5,a5,1
    10ea:	fee79de3          	bne	a5,a4,10e4 <memset+0x12>
  }
  return dst;
}
    10ee:	6422                	ld	s0,8(sp)
    10f0:	0141                	addi	sp,sp,16
    10f2:	8082                	ret

00000000000010f4 <strchr>:

char*
strchr(const char *s, char c)
{
    10f4:	1141                	addi	sp,sp,-16
    10f6:	e422                	sd	s0,8(sp)
    10f8:	0800                	addi	s0,sp,16
  for(; *s; s++)
    10fa:	00054783          	lbu	a5,0(a0)
    10fe:	cb99                	beqz	a5,1114 <strchr+0x20>
    if(*s == c)
    1100:	00f58763          	beq	a1,a5,110e <strchr+0x1a>
  for(; *s; s++)
    1104:	0505                	addi	a0,a0,1
    1106:	00054783          	lbu	a5,0(a0)
    110a:	fbfd                	bnez	a5,1100 <strchr+0xc>
      return (char*)s;
  return 0;
    110c:	4501                	li	a0,0
}
    110e:	6422                	ld	s0,8(sp)
    1110:	0141                	addi	sp,sp,16
    1112:	8082                	ret
  return 0;
    1114:	4501                	li	a0,0
    1116:	bfe5                	j	110e <strchr+0x1a>

0000000000001118 <gets>:

char*
gets(char *buf, int max)
{
    1118:	711d                	addi	sp,sp,-96
    111a:	ec86                	sd	ra,88(sp)
    111c:	e8a2                	sd	s0,80(sp)
    111e:	e4a6                	sd	s1,72(sp)
    1120:	e0ca                	sd	s2,64(sp)
    1122:	fc4e                	sd	s3,56(sp)
    1124:	f852                	sd	s4,48(sp)
    1126:	f456                	sd	s5,40(sp)
    1128:	f05a                	sd	s6,32(sp)
    112a:	ec5e                	sd	s7,24(sp)
    112c:	1080                	addi	s0,sp,96
    112e:	8baa                	mv	s7,a0
    1130:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1132:	892a                	mv	s2,a0
    1134:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1136:	4aa9                	li	s5,10
    1138:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    113a:	89a6                	mv	s3,s1
    113c:	2485                	addiw	s1,s1,1
    113e:	0344d663          	bge	s1,s4,116a <gets+0x52>
    cc = read(0, &c, 1);
    1142:	4605                	li	a2,1
    1144:	faf40593          	addi	a1,s0,-81
    1148:	4501                	li	a0,0
    114a:	186000ef          	jal	12d0 <read>
    if(cc < 1)
    114e:	00a05e63          	blez	a0,116a <gets+0x52>
    buf[i++] = c;
    1152:	faf44783          	lbu	a5,-81(s0)
    1156:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    115a:	01578763          	beq	a5,s5,1168 <gets+0x50>
    115e:	0905                	addi	s2,s2,1
    1160:	fd679de3          	bne	a5,s6,113a <gets+0x22>
    buf[i++] = c;
    1164:	89a6                	mv	s3,s1
    1166:	a011                	j	116a <gets+0x52>
    1168:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    116a:	99de                	add	s3,s3,s7
    116c:	00098023          	sb	zero,0(s3)
  return buf;
}
    1170:	855e                	mv	a0,s7
    1172:	60e6                	ld	ra,88(sp)
    1174:	6446                	ld	s0,80(sp)
    1176:	64a6                	ld	s1,72(sp)
    1178:	6906                	ld	s2,64(sp)
    117a:	79e2                	ld	s3,56(sp)
    117c:	7a42                	ld	s4,48(sp)
    117e:	7aa2                	ld	s5,40(sp)
    1180:	7b02                	ld	s6,32(sp)
    1182:	6be2                	ld	s7,24(sp)
    1184:	6125                	addi	sp,sp,96
    1186:	8082                	ret

0000000000001188 <stat>:

int
stat(const char *n, struct stat *st)
{
    1188:	1101                	addi	sp,sp,-32
    118a:	ec06                	sd	ra,24(sp)
    118c:	e822                	sd	s0,16(sp)
    118e:	e04a                	sd	s2,0(sp)
    1190:	1000                	addi	s0,sp,32
    1192:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1194:	4581                	li	a1,0
    1196:	162000ef          	jal	12f8 <open>
  if(fd < 0)
    119a:	02054263          	bltz	a0,11be <stat+0x36>
    119e:	e426                	sd	s1,8(sp)
    11a0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11a2:	85ca                	mv	a1,s2
    11a4:	16c000ef          	jal	1310 <fstat>
    11a8:	892a                	mv	s2,a0
  close(fd);
    11aa:	8526                	mv	a0,s1
    11ac:	134000ef          	jal	12e0 <close>
  return r;
    11b0:	64a2                	ld	s1,8(sp)
}
    11b2:	854a                	mv	a0,s2
    11b4:	60e2                	ld	ra,24(sp)
    11b6:	6442                	ld	s0,16(sp)
    11b8:	6902                	ld	s2,0(sp)
    11ba:	6105                	addi	sp,sp,32
    11bc:	8082                	ret
    return -1;
    11be:	597d                	li	s2,-1
    11c0:	bfcd                	j	11b2 <stat+0x2a>

00000000000011c2 <atoi>:

int
atoi(const char *s)
{
    11c2:	1141                	addi	sp,sp,-16
    11c4:	e422                	sd	s0,8(sp)
    11c6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11c8:	00054683          	lbu	a3,0(a0)
    11cc:	fd06879b          	addiw	a5,a3,-48
    11d0:	0ff7f793          	zext.b	a5,a5
    11d4:	4625                	li	a2,9
    11d6:	02f66863          	bltu	a2,a5,1206 <atoi+0x44>
    11da:	872a                	mv	a4,a0
  n = 0;
    11dc:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    11de:	0705                	addi	a4,a4,1
    11e0:	0025179b          	slliw	a5,a0,0x2
    11e4:	9fa9                	addw	a5,a5,a0
    11e6:	0017979b          	slliw	a5,a5,0x1
    11ea:	9fb5                	addw	a5,a5,a3
    11ec:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    11f0:	00074683          	lbu	a3,0(a4)
    11f4:	fd06879b          	addiw	a5,a3,-48
    11f8:	0ff7f793          	zext.b	a5,a5
    11fc:	fef671e3          	bgeu	a2,a5,11de <atoi+0x1c>
  return n;
}
    1200:	6422                	ld	s0,8(sp)
    1202:	0141                	addi	sp,sp,16
    1204:	8082                	ret
  n = 0;
    1206:	4501                	li	a0,0
    1208:	bfe5                	j	1200 <atoi+0x3e>

000000000000120a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    120a:	1141                	addi	sp,sp,-16
    120c:	e422                	sd	s0,8(sp)
    120e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1210:	02b57463          	bgeu	a0,a1,1238 <memmove+0x2e>
    while(n-- > 0)
    1214:	00c05f63          	blez	a2,1232 <memmove+0x28>
    1218:	1602                	slli	a2,a2,0x20
    121a:	9201                	srli	a2,a2,0x20
    121c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1220:	872a                	mv	a4,a0
      *dst++ = *src++;
    1222:	0585                	addi	a1,a1,1
    1224:	0705                	addi	a4,a4,1
    1226:	fff5c683          	lbu	a3,-1(a1)
    122a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    122e:	fef71ae3          	bne	a4,a5,1222 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1232:	6422                	ld	s0,8(sp)
    1234:	0141                	addi	sp,sp,16
    1236:	8082                	ret
    dst += n;
    1238:	00c50733          	add	a4,a0,a2
    src += n;
    123c:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    123e:	fec05ae3          	blez	a2,1232 <memmove+0x28>
    1242:	fff6079b          	addiw	a5,a2,-1
    1246:	1782                	slli	a5,a5,0x20
    1248:	9381                	srli	a5,a5,0x20
    124a:	fff7c793          	not	a5,a5
    124e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1250:	15fd                	addi	a1,a1,-1
    1252:	177d                	addi	a4,a4,-1
    1254:	0005c683          	lbu	a3,0(a1)
    1258:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    125c:	fee79ae3          	bne	a5,a4,1250 <memmove+0x46>
    1260:	bfc9                	j	1232 <memmove+0x28>

0000000000001262 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1262:	1141                	addi	sp,sp,-16
    1264:	e422                	sd	s0,8(sp)
    1266:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1268:	ca05                	beqz	a2,1298 <memcmp+0x36>
    126a:	fff6069b          	addiw	a3,a2,-1
    126e:	1682                	slli	a3,a3,0x20
    1270:	9281                	srli	a3,a3,0x20
    1272:	0685                	addi	a3,a3,1
    1274:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1276:	00054783          	lbu	a5,0(a0)
    127a:	0005c703          	lbu	a4,0(a1)
    127e:	00e79863          	bne	a5,a4,128e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1282:	0505                	addi	a0,a0,1
    p2++;
    1284:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1286:	fed518e3          	bne	a0,a3,1276 <memcmp+0x14>
  }
  return 0;
    128a:	4501                	li	a0,0
    128c:	a019                	j	1292 <memcmp+0x30>
      return *p1 - *p2;
    128e:	40e7853b          	subw	a0,a5,a4
}
    1292:	6422                	ld	s0,8(sp)
    1294:	0141                	addi	sp,sp,16
    1296:	8082                	ret
  return 0;
    1298:	4501                	li	a0,0
    129a:	bfe5                	j	1292 <memcmp+0x30>

000000000000129c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    129c:	1141                	addi	sp,sp,-16
    129e:	e406                	sd	ra,8(sp)
    12a0:	e022                	sd	s0,0(sp)
    12a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    12a4:	f67ff0ef          	jal	120a <memmove>
}
    12a8:	60a2                	ld	ra,8(sp)
    12aa:	6402                	ld	s0,0(sp)
    12ac:	0141                	addi	sp,sp,16
    12ae:	8082                	ret

00000000000012b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12b0:	4885                	li	a7,1
 ecall
    12b2:	00000073          	ecall
 ret
    12b6:	8082                	ret

00000000000012b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
    12b8:	4889                	li	a7,2
 ecall
    12ba:	00000073          	ecall
 ret
    12be:	8082                	ret

00000000000012c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
    12c0:	488d                	li	a7,3
 ecall
    12c2:	00000073          	ecall
 ret
    12c6:	8082                	ret

00000000000012c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    12c8:	4891                	li	a7,4
 ecall
    12ca:	00000073          	ecall
 ret
    12ce:	8082                	ret

00000000000012d0 <read>:
.global read
read:
 li a7, SYS_read
    12d0:	4895                	li	a7,5
 ecall
    12d2:	00000073          	ecall
 ret
    12d6:	8082                	ret

00000000000012d8 <write>:
.global write
write:
 li a7, SYS_write
    12d8:	48c1                	li	a7,16
 ecall
    12da:	00000073          	ecall
 ret
    12de:	8082                	ret

00000000000012e0 <close>:
.global close
close:
 li a7, SYS_close
    12e0:	48d5                	li	a7,21
 ecall
    12e2:	00000073          	ecall
 ret
    12e6:	8082                	ret

00000000000012e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
    12e8:	4899                	li	a7,6
 ecall
    12ea:	00000073          	ecall
 ret
    12ee:	8082                	ret

00000000000012f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
    12f0:	489d                	li	a7,7
 ecall
    12f2:	00000073          	ecall
 ret
    12f6:	8082                	ret

00000000000012f8 <open>:
.global open
open:
 li a7, SYS_open
    12f8:	48bd                	li	a7,15
 ecall
    12fa:	00000073          	ecall
 ret
    12fe:	8082                	ret

0000000000001300 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1300:	48c5                	li	a7,17
 ecall
    1302:	00000073          	ecall
 ret
    1306:	8082                	ret

0000000000001308 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1308:	48c9                	li	a7,18
 ecall
    130a:	00000073          	ecall
 ret
    130e:	8082                	ret

0000000000001310 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1310:	48a1                	li	a7,8
 ecall
    1312:	00000073          	ecall
 ret
    1316:	8082                	ret

0000000000001318 <link>:
.global link
link:
 li a7, SYS_link
    1318:	48cd                	li	a7,19
 ecall
    131a:	00000073          	ecall
 ret
    131e:	8082                	ret

0000000000001320 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1320:	48d1                	li	a7,20
 ecall
    1322:	00000073          	ecall
 ret
    1326:	8082                	ret

0000000000001328 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1328:	48a5                	li	a7,9
 ecall
    132a:	00000073          	ecall
 ret
    132e:	8082                	ret

0000000000001330 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1330:	48a9                	li	a7,10
 ecall
    1332:	00000073          	ecall
 ret
    1336:	8082                	ret

0000000000001338 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1338:	48ad                	li	a7,11
 ecall
    133a:	00000073          	ecall
 ret
    133e:	8082                	ret

0000000000001340 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1340:	48b1                	li	a7,12
 ecall
    1342:	00000073          	ecall
 ret
    1346:	8082                	ret

0000000000001348 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1348:	48b5                	li	a7,13
 ecall
    134a:	00000073          	ecall
 ret
    134e:	8082                	ret

0000000000001350 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1350:	48b9                	li	a7,14
 ecall
    1352:	00000073          	ecall
 ret
    1356:	8082                	ret

0000000000001358 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1358:	48d9                	li	a7,22
 ecall
    135a:	00000073          	ecall
 ret
    135e:	8082                	ret

0000000000001360 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1360:	48dd                	li	a7,23
 ecall
    1362:	00000073          	ecall
 ret
    1366:	8082                	ret

0000000000001368 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1368:	48e1                	li	a7,24
 ecall
    136a:	00000073          	ecall
 ret
    136e:	8082                	ret

0000000000001370 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1370:	48e5                	li	a7,25
 ecall
    1372:	00000073          	ecall
 ret
    1376:	8082                	ret

0000000000001378 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1378:	48e9                	li	a7,26
 ecall
    137a:	00000073          	ecall
 ret
    137e:	8082                	ret

0000000000001380 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    1380:	48ed                	li	a7,27
 ecall
    1382:	00000073          	ecall
 ret
    1386:	8082                	ret

0000000000001388 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1388:	48f1                	li	a7,28
 ecall
    138a:	00000073          	ecall
 ret
    138e:	8082                	ret

0000000000001390 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    1390:	48f5                	li	a7,29
 ecall
    1392:	00000073          	ecall
 ret
    1396:	8082                	ret

0000000000001398 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1398:	48f9                	li	a7,30
 ecall
    139a:	00000073          	ecall
 ret
    139e:	8082                	ret

00000000000013a0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    13a0:	1101                	addi	sp,sp,-32
    13a2:	ec06                	sd	ra,24(sp)
    13a4:	e822                	sd	s0,16(sp)
    13a6:	1000                	addi	s0,sp,32
    13a8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13ac:	4605                	li	a2,1
    13ae:	fef40593          	addi	a1,s0,-17
    13b2:	f27ff0ef          	jal	12d8 <write>
}
    13b6:	60e2                	ld	ra,24(sp)
    13b8:	6442                	ld	s0,16(sp)
    13ba:	6105                	addi	sp,sp,32
    13bc:	8082                	ret

00000000000013be <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13be:	7139                	addi	sp,sp,-64
    13c0:	fc06                	sd	ra,56(sp)
    13c2:	f822                	sd	s0,48(sp)
    13c4:	f426                	sd	s1,40(sp)
    13c6:	0080                	addi	s0,sp,64
    13c8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13ca:	c299                	beqz	a3,13d0 <printint+0x12>
    13cc:	0805c963          	bltz	a1,145e <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13d0:	2581                	sext.w	a1,a1
  neg = 0;
    13d2:	4881                	li	a7,0
    13d4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13d8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13da:	2601                	sext.w	a2,a2
    13dc:	00001517          	auipc	a0,0x1
    13e0:	c5c50513          	addi	a0,a0,-932 # 2038 <digits>
    13e4:	883a                	mv	a6,a4
    13e6:	2705                	addiw	a4,a4,1
    13e8:	02c5f7bb          	remuw	a5,a1,a2
    13ec:	1782                	slli	a5,a5,0x20
    13ee:	9381                	srli	a5,a5,0x20
    13f0:	97aa                	add	a5,a5,a0
    13f2:	0007c783          	lbu	a5,0(a5)
    13f6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    13fa:	0005879b          	sext.w	a5,a1
    13fe:	02c5d5bb          	divuw	a1,a1,a2
    1402:	0685                	addi	a3,a3,1
    1404:	fec7f0e3          	bgeu	a5,a2,13e4 <printint+0x26>
  if(neg)
    1408:	00088c63          	beqz	a7,1420 <printint+0x62>
    buf[i++] = '-';
    140c:	fd070793          	addi	a5,a4,-48
    1410:	00878733          	add	a4,a5,s0
    1414:	02d00793          	li	a5,45
    1418:	fef70823          	sb	a5,-16(a4)
    141c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1420:	02e05a63          	blez	a4,1454 <printint+0x96>
    1424:	f04a                	sd	s2,32(sp)
    1426:	ec4e                	sd	s3,24(sp)
    1428:	fc040793          	addi	a5,s0,-64
    142c:	00e78933          	add	s2,a5,a4
    1430:	fff78993          	addi	s3,a5,-1
    1434:	99ba                	add	s3,s3,a4
    1436:	377d                	addiw	a4,a4,-1
    1438:	1702                	slli	a4,a4,0x20
    143a:	9301                	srli	a4,a4,0x20
    143c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1440:	fff94583          	lbu	a1,-1(s2)
    1444:	8526                	mv	a0,s1
    1446:	f5bff0ef          	jal	13a0 <putc>
  while(--i >= 0)
    144a:	197d                	addi	s2,s2,-1
    144c:	ff391ae3          	bne	s2,s3,1440 <printint+0x82>
    1450:	7902                	ld	s2,32(sp)
    1452:	69e2                	ld	s3,24(sp)
}
    1454:	70e2                	ld	ra,56(sp)
    1456:	7442                	ld	s0,48(sp)
    1458:	74a2                	ld	s1,40(sp)
    145a:	6121                	addi	sp,sp,64
    145c:	8082                	ret
    x = -xx;
    145e:	40b005bb          	negw	a1,a1
    neg = 1;
    1462:	4885                	li	a7,1
    x = -xx;
    1464:	bf85                	j	13d4 <printint+0x16>

0000000000001466 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1466:	711d                	addi	sp,sp,-96
    1468:	ec86                	sd	ra,88(sp)
    146a:	e8a2                	sd	s0,80(sp)
    146c:	e0ca                	sd	s2,64(sp)
    146e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1470:	0005c903          	lbu	s2,0(a1)
    1474:	26090863          	beqz	s2,16e4 <vprintf+0x27e>
    1478:	e4a6                	sd	s1,72(sp)
    147a:	fc4e                	sd	s3,56(sp)
    147c:	f852                	sd	s4,48(sp)
    147e:	f456                	sd	s5,40(sp)
    1480:	f05a                	sd	s6,32(sp)
    1482:	ec5e                	sd	s7,24(sp)
    1484:	e862                	sd	s8,16(sp)
    1486:	e466                	sd	s9,8(sp)
    1488:	8b2a                	mv	s6,a0
    148a:	8a2e                	mv	s4,a1
    148c:	8bb2                	mv	s7,a2
  state = 0;
    148e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1490:	4481                	li	s1,0
    1492:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1494:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1498:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    149c:	06c00c93          	li	s9,108
    14a0:	a005                	j	14c0 <vprintf+0x5a>
        putc(fd, c0);
    14a2:	85ca                	mv	a1,s2
    14a4:	855a                	mv	a0,s6
    14a6:	efbff0ef          	jal	13a0 <putc>
    14aa:	a019                	j	14b0 <vprintf+0x4a>
    } else if(state == '%'){
    14ac:	03598263          	beq	s3,s5,14d0 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    14b0:	2485                	addiw	s1,s1,1
    14b2:	8726                	mv	a4,s1
    14b4:	009a07b3          	add	a5,s4,s1
    14b8:	0007c903          	lbu	s2,0(a5)
    14bc:	20090c63          	beqz	s2,16d4 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    14c0:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14c4:	fe0994e3          	bnez	s3,14ac <vprintf+0x46>
      if(c0 == '%'){
    14c8:	fd579de3          	bne	a5,s5,14a2 <vprintf+0x3c>
        state = '%';
    14cc:	89be                	mv	s3,a5
    14ce:	b7cd                	j	14b0 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14d0:	00ea06b3          	add	a3,s4,a4
    14d4:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    14d8:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    14da:	c681                	beqz	a3,14e2 <vprintf+0x7c>
    14dc:	9752                	add	a4,a4,s4
    14de:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    14e2:	03878f63          	beq	a5,s8,1520 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    14e6:	05978963          	beq	a5,s9,1538 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    14ea:	07500713          	li	a4,117
    14ee:	0ee78363          	beq	a5,a4,15d4 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    14f2:	07800713          	li	a4,120
    14f6:	12e78563          	beq	a5,a4,1620 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    14fa:	07000713          	li	a4,112
    14fe:	14e78a63          	beq	a5,a4,1652 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1502:	07300713          	li	a4,115
    1506:	18e78a63          	beq	a5,a4,169a <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    150a:	02500713          	li	a4,37
    150e:	04e79563          	bne	a5,a4,1558 <vprintf+0xf2>
        putc(fd, '%');
    1512:	02500593          	li	a1,37
    1516:	855a                	mv	a0,s6
    1518:	e89ff0ef          	jal	13a0 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    151c:	4981                	li	s3,0
    151e:	bf49                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1520:	008b8913          	addi	s2,s7,8
    1524:	4685                	li	a3,1
    1526:	4629                	li	a2,10
    1528:	000ba583          	lw	a1,0(s7)
    152c:	855a                	mv	a0,s6
    152e:	e91ff0ef          	jal	13be <printint>
    1532:	8bca                	mv	s7,s2
      state = 0;
    1534:	4981                	li	s3,0
    1536:	bfad                	j	14b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1538:	06400793          	li	a5,100
    153c:	02f68963          	beq	a3,a5,156e <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1540:	06c00793          	li	a5,108
    1544:	04f68263          	beq	a3,a5,1588 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1548:	07500793          	li	a5,117
    154c:	0af68063          	beq	a3,a5,15ec <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1550:	07800793          	li	a5,120
    1554:	0ef68263          	beq	a3,a5,1638 <vprintf+0x1d2>
        putc(fd, '%');
    1558:	02500593          	li	a1,37
    155c:	855a                	mv	a0,s6
    155e:	e43ff0ef          	jal	13a0 <putc>
        putc(fd, c0);
    1562:	85ca                	mv	a1,s2
    1564:	855a                	mv	a0,s6
    1566:	e3bff0ef          	jal	13a0 <putc>
      state = 0;
    156a:	4981                	li	s3,0
    156c:	b791                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    156e:	008b8913          	addi	s2,s7,8
    1572:	4685                	li	a3,1
    1574:	4629                	li	a2,10
    1576:	000ba583          	lw	a1,0(s7)
    157a:	855a                	mv	a0,s6
    157c:	e43ff0ef          	jal	13be <printint>
        i += 1;
    1580:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1582:	8bca                	mv	s7,s2
      state = 0;
    1584:	4981                	li	s3,0
        i += 1;
    1586:	b72d                	j	14b0 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1588:	06400793          	li	a5,100
    158c:	02f60763          	beq	a2,a5,15ba <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1590:	07500793          	li	a5,117
    1594:	06f60963          	beq	a2,a5,1606 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1598:	07800793          	li	a5,120
    159c:	faf61ee3          	bne	a2,a5,1558 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    15a0:	008b8913          	addi	s2,s7,8
    15a4:	4681                	li	a3,0
    15a6:	4641                	li	a2,16
    15a8:	000ba583          	lw	a1,0(s7)
    15ac:	855a                	mv	a0,s6
    15ae:	e11ff0ef          	jal	13be <printint>
        i += 2;
    15b2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    15b4:	8bca                	mv	s7,s2
      state = 0;
    15b6:	4981                	li	s3,0
        i += 2;
    15b8:	bde5                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15ba:	008b8913          	addi	s2,s7,8
    15be:	4685                	li	a3,1
    15c0:	4629                	li	a2,10
    15c2:	000ba583          	lw	a1,0(s7)
    15c6:	855a                	mv	a0,s6
    15c8:	df7ff0ef          	jal	13be <printint>
        i += 2;
    15cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15ce:	8bca                	mv	s7,s2
      state = 0;
    15d0:	4981                	li	s3,0
        i += 2;
    15d2:	bdf9                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    15d4:	008b8913          	addi	s2,s7,8
    15d8:	4681                	li	a3,0
    15da:	4629                	li	a2,10
    15dc:	000ba583          	lw	a1,0(s7)
    15e0:	855a                	mv	a0,s6
    15e2:	dddff0ef          	jal	13be <printint>
    15e6:	8bca                	mv	s7,s2
      state = 0;
    15e8:	4981                	li	s3,0
    15ea:	b5d9                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    15ec:	008b8913          	addi	s2,s7,8
    15f0:	4681                	li	a3,0
    15f2:	4629                	li	a2,10
    15f4:	000ba583          	lw	a1,0(s7)
    15f8:	855a                	mv	a0,s6
    15fa:	dc5ff0ef          	jal	13be <printint>
        i += 1;
    15fe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1600:	8bca                	mv	s7,s2
      state = 0;
    1602:	4981                	li	s3,0
        i += 1;
    1604:	b575                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1606:	008b8913          	addi	s2,s7,8
    160a:	4681                	li	a3,0
    160c:	4629                	li	a2,10
    160e:	000ba583          	lw	a1,0(s7)
    1612:	855a                	mv	a0,s6
    1614:	dabff0ef          	jal	13be <printint>
        i += 2;
    1618:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    161a:	8bca                	mv	s7,s2
      state = 0;
    161c:	4981                	li	s3,0
        i += 2;
    161e:	bd49                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1620:	008b8913          	addi	s2,s7,8
    1624:	4681                	li	a3,0
    1626:	4641                	li	a2,16
    1628:	000ba583          	lw	a1,0(s7)
    162c:	855a                	mv	a0,s6
    162e:	d91ff0ef          	jal	13be <printint>
    1632:	8bca                	mv	s7,s2
      state = 0;
    1634:	4981                	li	s3,0
    1636:	bdad                	j	14b0 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1638:	008b8913          	addi	s2,s7,8
    163c:	4681                	li	a3,0
    163e:	4641                	li	a2,16
    1640:	000ba583          	lw	a1,0(s7)
    1644:	855a                	mv	a0,s6
    1646:	d79ff0ef          	jal	13be <printint>
        i += 1;
    164a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    164c:	8bca                	mv	s7,s2
      state = 0;
    164e:	4981                	li	s3,0
        i += 1;
    1650:	b585                	j	14b0 <vprintf+0x4a>
    1652:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1654:	008b8d13          	addi	s10,s7,8
    1658:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    165c:	03000593          	li	a1,48
    1660:	855a                	mv	a0,s6
    1662:	d3fff0ef          	jal	13a0 <putc>
  putc(fd, 'x');
    1666:	07800593          	li	a1,120
    166a:	855a                	mv	a0,s6
    166c:	d35ff0ef          	jal	13a0 <putc>
    1670:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1672:	00001b97          	auipc	s7,0x1
    1676:	9c6b8b93          	addi	s7,s7,-1594 # 2038 <digits>
    167a:	03c9d793          	srli	a5,s3,0x3c
    167e:	97de                	add	a5,a5,s7
    1680:	0007c583          	lbu	a1,0(a5)
    1684:	855a                	mv	a0,s6
    1686:	d1bff0ef          	jal	13a0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    168a:	0992                	slli	s3,s3,0x4
    168c:	397d                	addiw	s2,s2,-1
    168e:	fe0916e3          	bnez	s2,167a <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1692:	8bea                	mv	s7,s10
      state = 0;
    1694:	4981                	li	s3,0
    1696:	6d02                	ld	s10,0(sp)
    1698:	bd21                	j	14b0 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    169a:	008b8993          	addi	s3,s7,8
    169e:	000bb903          	ld	s2,0(s7)
    16a2:	00090f63          	beqz	s2,16c0 <vprintf+0x25a>
        for(; *s; s++)
    16a6:	00094583          	lbu	a1,0(s2)
    16aa:	c195                	beqz	a1,16ce <vprintf+0x268>
          putc(fd, *s);
    16ac:	855a                	mv	a0,s6
    16ae:	cf3ff0ef          	jal	13a0 <putc>
        for(; *s; s++)
    16b2:	0905                	addi	s2,s2,1
    16b4:	00094583          	lbu	a1,0(s2)
    16b8:	f9f5                	bnez	a1,16ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16ba:	8bce                	mv	s7,s3
      state = 0;
    16bc:	4981                	li	s3,0
    16be:	bbcd                	j	14b0 <vprintf+0x4a>
          s = "(null)";
    16c0:	00001917          	auipc	s2,0x1
    16c4:	97090913          	addi	s2,s2,-1680 # 2030 <malloc+0x864>
        for(; *s; s++)
    16c8:	02800593          	li	a1,40
    16cc:	b7c5                	j	16ac <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16ce:	8bce                	mv	s7,s3
      state = 0;
    16d0:	4981                	li	s3,0
    16d2:	bbf9                	j	14b0 <vprintf+0x4a>
    16d4:	64a6                	ld	s1,72(sp)
    16d6:	79e2                	ld	s3,56(sp)
    16d8:	7a42                	ld	s4,48(sp)
    16da:	7aa2                	ld	s5,40(sp)
    16dc:	7b02                	ld	s6,32(sp)
    16de:	6be2                	ld	s7,24(sp)
    16e0:	6c42                	ld	s8,16(sp)
    16e2:	6ca2                	ld	s9,8(sp)
    }
  }
}
    16e4:	60e6                	ld	ra,88(sp)
    16e6:	6446                	ld	s0,80(sp)
    16e8:	6906                	ld	s2,64(sp)
    16ea:	6125                	addi	sp,sp,96
    16ec:	8082                	ret

00000000000016ee <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    16ee:	715d                	addi	sp,sp,-80
    16f0:	ec06                	sd	ra,24(sp)
    16f2:	e822                	sd	s0,16(sp)
    16f4:	1000                	addi	s0,sp,32
    16f6:	e010                	sd	a2,0(s0)
    16f8:	e414                	sd	a3,8(s0)
    16fa:	e818                	sd	a4,16(s0)
    16fc:	ec1c                	sd	a5,24(s0)
    16fe:	03043023          	sd	a6,32(s0)
    1702:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1706:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    170a:	8622                	mv	a2,s0
    170c:	d5bff0ef          	jal	1466 <vprintf>
}
    1710:	60e2                	ld	ra,24(sp)
    1712:	6442                	ld	s0,16(sp)
    1714:	6161                	addi	sp,sp,80
    1716:	8082                	ret

0000000000001718 <printf>:

void
printf(const char *fmt, ...)
{
    1718:	711d                	addi	sp,sp,-96
    171a:	ec06                	sd	ra,24(sp)
    171c:	e822                	sd	s0,16(sp)
    171e:	1000                	addi	s0,sp,32
    1720:	e40c                	sd	a1,8(s0)
    1722:	e810                	sd	a2,16(s0)
    1724:	ec14                	sd	a3,24(s0)
    1726:	f018                	sd	a4,32(s0)
    1728:	f41c                	sd	a5,40(s0)
    172a:	03043823          	sd	a6,48(s0)
    172e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1732:	00840613          	addi	a2,s0,8
    1736:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    173a:	85aa                	mv	a1,a0
    173c:	4505                	li	a0,1
    173e:	d29ff0ef          	jal	1466 <vprintf>
}
    1742:	60e2                	ld	ra,24(sp)
    1744:	6442                	ld	s0,16(sp)
    1746:	6125                	addi	sp,sp,96
    1748:	8082                	ret

000000000000174a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    174a:	1141                	addi	sp,sp,-16
    174c:	e422                	sd	s0,8(sp)
    174e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1750:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1754:	00001797          	auipc	a5,0x1
    1758:	8fc7b783          	ld	a5,-1796(a5) # 2050 <freep>
    175c:	a02d                	j	1786 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    175e:	4618                	lw	a4,8(a2)
    1760:	9f2d                	addw	a4,a4,a1
    1762:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1766:	6398                	ld	a4,0(a5)
    1768:	6310                	ld	a2,0(a4)
    176a:	a83d                	j	17a8 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    176c:	ff852703          	lw	a4,-8(a0)
    1770:	9f31                	addw	a4,a4,a2
    1772:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1774:	ff053683          	ld	a3,-16(a0)
    1778:	a091                	j	17bc <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    177a:	6398                	ld	a4,0(a5)
    177c:	00e7e463          	bltu	a5,a4,1784 <free+0x3a>
    1780:	00e6ea63          	bltu	a3,a4,1794 <free+0x4a>
{
    1784:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1786:	fed7fae3          	bgeu	a5,a3,177a <free+0x30>
    178a:	6398                	ld	a4,0(a5)
    178c:	00e6e463          	bltu	a3,a4,1794 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1790:	fee7eae3          	bltu	a5,a4,1784 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1794:	ff852583          	lw	a1,-8(a0)
    1798:	6390                	ld	a2,0(a5)
    179a:	02059813          	slli	a6,a1,0x20
    179e:	01c85713          	srli	a4,a6,0x1c
    17a2:	9736                	add	a4,a4,a3
    17a4:	fae60de3          	beq	a2,a4,175e <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    17a8:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    17ac:	4790                	lw	a2,8(a5)
    17ae:	02061593          	slli	a1,a2,0x20
    17b2:	01c5d713          	srli	a4,a1,0x1c
    17b6:	973e                	add	a4,a4,a5
    17b8:	fae68ae3          	beq	a3,a4,176c <free+0x22>
    p->s.ptr = bp->s.ptr;
    17bc:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    17be:	00001717          	auipc	a4,0x1
    17c2:	88f73923          	sd	a5,-1902(a4) # 2050 <freep>
}
    17c6:	6422                	ld	s0,8(sp)
    17c8:	0141                	addi	sp,sp,16
    17ca:	8082                	ret

00000000000017cc <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17cc:	7139                	addi	sp,sp,-64
    17ce:	fc06                	sd	ra,56(sp)
    17d0:	f822                	sd	s0,48(sp)
    17d2:	f426                	sd	s1,40(sp)
    17d4:	ec4e                	sd	s3,24(sp)
    17d6:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17d8:	02051493          	slli	s1,a0,0x20
    17dc:	9081                	srli	s1,s1,0x20
    17de:	04bd                	addi	s1,s1,15
    17e0:	8091                	srli	s1,s1,0x4
    17e2:	0014899b          	addiw	s3,s1,1
    17e6:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    17e8:	00001517          	auipc	a0,0x1
    17ec:	86853503          	ld	a0,-1944(a0) # 2050 <freep>
    17f0:	c915                	beqz	a0,1824 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    17f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    17f4:	4798                	lw	a4,8(a5)
    17f6:	08977a63          	bgeu	a4,s1,188a <malloc+0xbe>
    17fa:	f04a                	sd	s2,32(sp)
    17fc:	e852                	sd	s4,16(sp)
    17fe:	e456                	sd	s5,8(sp)
    1800:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1802:	8a4e                	mv	s4,s3
    1804:	0009871b          	sext.w	a4,s3
    1808:	6685                	lui	a3,0x1
    180a:	00d77363          	bgeu	a4,a3,1810 <malloc+0x44>
    180e:	6a05                	lui	s4,0x1
    1810:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1814:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1818:	00001917          	auipc	s2,0x1
    181c:	83890913          	addi	s2,s2,-1992 # 2050 <freep>
  if(p == (char*)-1)
    1820:	5afd                	li	s5,-1
    1822:	a081                	j	1862 <malloc+0x96>
    1824:	f04a                	sd	s2,32(sp)
    1826:	e852                	sd	s4,16(sp)
    1828:	e456                	sd	s5,8(sp)
    182a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    182c:	00001797          	auipc	a5,0x1
    1830:	83478793          	addi	a5,a5,-1996 # 2060 <base>
    1834:	00001717          	auipc	a4,0x1
    1838:	80f73e23          	sd	a5,-2020(a4) # 2050 <freep>
    183c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    183e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1842:	b7c1                	j	1802 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1844:	6398                	ld	a4,0(a5)
    1846:	e118                	sd	a4,0(a0)
    1848:	a8a9                	j	18a2 <malloc+0xd6>
  hp->s.size = nu;
    184a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    184e:	0541                	addi	a0,a0,16
    1850:	efbff0ef          	jal	174a <free>
  return freep;
    1854:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1858:	c12d                	beqz	a0,18ba <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    185a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    185c:	4798                	lw	a4,8(a5)
    185e:	02977263          	bgeu	a4,s1,1882 <malloc+0xb6>
    if(p == freep)
    1862:	00093703          	ld	a4,0(s2)
    1866:	853e                	mv	a0,a5
    1868:	fef719e3          	bne	a4,a5,185a <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    186c:	8552                	mv	a0,s4
    186e:	ad3ff0ef          	jal	1340 <sbrk>
  if(p == (char*)-1)
    1872:	fd551ce3          	bne	a0,s5,184a <malloc+0x7e>
        return 0;
    1876:	4501                	li	a0,0
    1878:	7902                	ld	s2,32(sp)
    187a:	6a42                	ld	s4,16(sp)
    187c:	6aa2                	ld	s5,8(sp)
    187e:	6b02                	ld	s6,0(sp)
    1880:	a03d                	j	18ae <malloc+0xe2>
    1882:	7902                	ld	s2,32(sp)
    1884:	6a42                	ld	s4,16(sp)
    1886:	6aa2                	ld	s5,8(sp)
    1888:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    188a:	fae48de3          	beq	s1,a4,1844 <malloc+0x78>
        p->s.size -= nunits;
    188e:	4137073b          	subw	a4,a4,s3
    1892:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1894:	02071693          	slli	a3,a4,0x20
    1898:	01c6d713          	srli	a4,a3,0x1c
    189c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    189e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    18a2:	00000717          	auipc	a4,0x0
    18a6:	7aa73723          	sd	a0,1966(a4) # 2050 <freep>
      return (void*)(p + 1);
    18aa:	01078513          	addi	a0,a5,16
  }
}
    18ae:	70e2                	ld	ra,56(sp)
    18b0:	7442                	ld	s0,48(sp)
    18b2:	74a2                	ld	s1,40(sp)
    18b4:	69e2                	ld	s3,24(sp)
    18b6:	6121                	addi	sp,sp,64
    18b8:	8082                	ret
    18ba:	7902                	ld	s2,32(sp)
    18bc:	6a42                	ld	s4,16(sp)
    18be:	6aa2                	ld	s5,8(sp)
    18c0:	6b02                	ld	s6,0(sp)
    18c2:	b7f5                	j	18ae <malloc+0xe2>
	...
