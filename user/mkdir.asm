
user/_mkdir:     file format elf64-littleriscv


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
  int i;

  if(argc < 2){
    1008:	4785                	li	a5,1
    100a:	02a7d763          	bge	a5,a0,1038 <main+0x38>
    100e:	e426                	sd	s1,8(sp)
    1010:	e04a                	sd	s2,0(sp)
    1012:	00858493          	addi	s1,a1,8
    1016:	ffe5091b          	addiw	s2,a0,-2
    101a:	02091793          	slli	a5,s2,0x20
    101e:	01d7d913          	srli	s2,a5,0x1d
    1022:	05c1                	addi	a1,a1,16
    1024:	992e                	add	s2,s2,a1
    fprintf(2, "Usage: mkdir files...\n");
    exit(1);
  }

  for(i = 1; i < argc; i++){
    if(mkdir(argv[i]) < 0){
    1026:	6088                	ld	a0,0(s1)
    1028:	310000ef          	jal	1338 <mkdir>
    102c:	02054263          	bltz	a0,1050 <main+0x50>
  for(i = 1; i < argc; i++){
    1030:	04a1                	addi	s1,s1,8
    1032:	ff249ae3          	bne	s1,s2,1026 <main+0x26>
    1036:	a02d                	j	1060 <main+0x60>
    1038:	e426                	sd	s1,8(sp)
    103a:	e04a                	sd	s2,0(sp)
    fprintf(2, "Usage: mkdir files...\n");
    103c:	00001597          	auipc	a1,0x1
    1040:	fc458593          	addi	a1,a1,-60 # 2000 <malloc+0x81c>
    1044:	4509                	li	a0,2
    1046:	6c0000ef          	jal	1706 <fprintf>
    exit(1);
    104a:	4505                	li	a0,1
    104c:	284000ef          	jal	12d0 <exit>
      fprintf(2, "mkdir: %s failed to create\n", argv[i]);
    1050:	6090                	ld	a2,0(s1)
    1052:	00001597          	auipc	a1,0x1
    1056:	fc658593          	addi	a1,a1,-58 # 2018 <malloc+0x834>
    105a:	4509                	li	a0,2
    105c:	6aa000ef          	jal	1706 <fprintf>
      break;
    }
  }

  exit(0);
    1060:	4501                	li	a0,0
    1062:	26e000ef          	jal	12d0 <exit>

0000000000001066 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    1066:	1141                	addi	sp,sp,-16
    1068:	e406                	sd	ra,8(sp)
    106a:	e022                	sd	s0,0(sp)
    106c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    106e:	f93ff0ef          	jal	1000 <main>
  exit(0);
    1072:	4501                	li	a0,0
    1074:	25c000ef          	jal	12d0 <exit>

0000000000001078 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1078:	1141                	addi	sp,sp,-16
    107a:	e422                	sd	s0,8(sp)
    107c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    107e:	87aa                	mv	a5,a0
    1080:	0585                	addi	a1,a1,1
    1082:	0785                	addi	a5,a5,1
    1084:	fff5c703          	lbu	a4,-1(a1)
    1088:	fee78fa3          	sb	a4,-1(a5)
    108c:	fb75                	bnez	a4,1080 <strcpy+0x8>
    ;
  return os;
}
    108e:	6422                	ld	s0,8(sp)
    1090:	0141                	addi	sp,sp,16
    1092:	8082                	ret

0000000000001094 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1094:	1141                	addi	sp,sp,-16
    1096:	e422                	sd	s0,8(sp)
    1098:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    109a:	00054783          	lbu	a5,0(a0)
    109e:	cb91                	beqz	a5,10b2 <strcmp+0x1e>
    10a0:	0005c703          	lbu	a4,0(a1)
    10a4:	00f71763          	bne	a4,a5,10b2 <strcmp+0x1e>
    p++, q++;
    10a8:	0505                	addi	a0,a0,1
    10aa:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    10ac:	00054783          	lbu	a5,0(a0)
    10b0:	fbe5                	bnez	a5,10a0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    10b2:	0005c503          	lbu	a0,0(a1)
}
    10b6:	40a7853b          	subw	a0,a5,a0
    10ba:	6422                	ld	s0,8(sp)
    10bc:	0141                	addi	sp,sp,16
    10be:	8082                	ret

00000000000010c0 <strlen>:

uint
strlen(const char *s)
{
    10c0:	1141                	addi	sp,sp,-16
    10c2:	e422                	sd	s0,8(sp)
    10c4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10c6:	00054783          	lbu	a5,0(a0)
    10ca:	cf91                	beqz	a5,10e6 <strlen+0x26>
    10cc:	0505                	addi	a0,a0,1
    10ce:	87aa                	mv	a5,a0
    10d0:	86be                	mv	a3,a5
    10d2:	0785                	addi	a5,a5,1
    10d4:	fff7c703          	lbu	a4,-1(a5)
    10d8:	ff65                	bnez	a4,10d0 <strlen+0x10>
    10da:	40a6853b          	subw	a0,a3,a0
    10de:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    10e0:	6422                	ld	s0,8(sp)
    10e2:	0141                	addi	sp,sp,16
    10e4:	8082                	ret
  for(n = 0; s[n]; n++)
    10e6:	4501                	li	a0,0
    10e8:	bfe5                	j	10e0 <strlen+0x20>

00000000000010ea <memset>:

void*
memset(void *dst, int c, uint n)
{
    10ea:	1141                	addi	sp,sp,-16
    10ec:	e422                	sd	s0,8(sp)
    10ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10f0:	ca19                	beqz	a2,1106 <memset+0x1c>
    10f2:	87aa                	mv	a5,a0
    10f4:	1602                	slli	a2,a2,0x20
    10f6:	9201                	srli	a2,a2,0x20
    10f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    10fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1100:	0785                	addi	a5,a5,1
    1102:	fee79de3          	bne	a5,a4,10fc <memset+0x12>
  }
  return dst;
}
    1106:	6422                	ld	s0,8(sp)
    1108:	0141                	addi	sp,sp,16
    110a:	8082                	ret

000000000000110c <strchr>:

char*
strchr(const char *s, char c)
{
    110c:	1141                	addi	sp,sp,-16
    110e:	e422                	sd	s0,8(sp)
    1110:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1112:	00054783          	lbu	a5,0(a0)
    1116:	cb99                	beqz	a5,112c <strchr+0x20>
    if(*s == c)
    1118:	00f58763          	beq	a1,a5,1126 <strchr+0x1a>
  for(; *s; s++)
    111c:	0505                	addi	a0,a0,1
    111e:	00054783          	lbu	a5,0(a0)
    1122:	fbfd                	bnez	a5,1118 <strchr+0xc>
      return (char*)s;
  return 0;
    1124:	4501                	li	a0,0
}
    1126:	6422                	ld	s0,8(sp)
    1128:	0141                	addi	sp,sp,16
    112a:	8082                	ret
  return 0;
    112c:	4501                	li	a0,0
    112e:	bfe5                	j	1126 <strchr+0x1a>

0000000000001130 <gets>:

char*
gets(char *buf, int max)
{
    1130:	711d                	addi	sp,sp,-96
    1132:	ec86                	sd	ra,88(sp)
    1134:	e8a2                	sd	s0,80(sp)
    1136:	e4a6                	sd	s1,72(sp)
    1138:	e0ca                	sd	s2,64(sp)
    113a:	fc4e                	sd	s3,56(sp)
    113c:	f852                	sd	s4,48(sp)
    113e:	f456                	sd	s5,40(sp)
    1140:	f05a                	sd	s6,32(sp)
    1142:	ec5e                	sd	s7,24(sp)
    1144:	1080                	addi	s0,sp,96
    1146:	8baa                	mv	s7,a0
    1148:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    114a:	892a                	mv	s2,a0
    114c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    114e:	4aa9                	li	s5,10
    1150:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1152:	89a6                	mv	s3,s1
    1154:	2485                	addiw	s1,s1,1
    1156:	0344d663          	bge	s1,s4,1182 <gets+0x52>
    cc = read(0, &c, 1);
    115a:	4605                	li	a2,1
    115c:	faf40593          	addi	a1,s0,-81
    1160:	4501                	li	a0,0
    1162:	186000ef          	jal	12e8 <read>
    if(cc < 1)
    1166:	00a05e63          	blez	a0,1182 <gets+0x52>
    buf[i++] = c;
    116a:	faf44783          	lbu	a5,-81(s0)
    116e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1172:	01578763          	beq	a5,s5,1180 <gets+0x50>
    1176:	0905                	addi	s2,s2,1
    1178:	fd679de3          	bne	a5,s6,1152 <gets+0x22>
    buf[i++] = c;
    117c:	89a6                	mv	s3,s1
    117e:	a011                	j	1182 <gets+0x52>
    1180:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1182:	99de                	add	s3,s3,s7
    1184:	00098023          	sb	zero,0(s3)
  return buf;
}
    1188:	855e                	mv	a0,s7
    118a:	60e6                	ld	ra,88(sp)
    118c:	6446                	ld	s0,80(sp)
    118e:	64a6                	ld	s1,72(sp)
    1190:	6906                	ld	s2,64(sp)
    1192:	79e2                	ld	s3,56(sp)
    1194:	7a42                	ld	s4,48(sp)
    1196:	7aa2                	ld	s5,40(sp)
    1198:	7b02                	ld	s6,32(sp)
    119a:	6be2                	ld	s7,24(sp)
    119c:	6125                	addi	sp,sp,96
    119e:	8082                	ret

00000000000011a0 <stat>:

int
stat(const char *n, struct stat *st)
{
    11a0:	1101                	addi	sp,sp,-32
    11a2:	ec06                	sd	ra,24(sp)
    11a4:	e822                	sd	s0,16(sp)
    11a6:	e04a                	sd	s2,0(sp)
    11a8:	1000                	addi	s0,sp,32
    11aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11ac:	4581                	li	a1,0
    11ae:	162000ef          	jal	1310 <open>
  if(fd < 0)
    11b2:	02054263          	bltz	a0,11d6 <stat+0x36>
    11b6:	e426                	sd	s1,8(sp)
    11b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11ba:	85ca                	mv	a1,s2
    11bc:	16c000ef          	jal	1328 <fstat>
    11c0:	892a                	mv	s2,a0
  close(fd);
    11c2:	8526                	mv	a0,s1
    11c4:	134000ef          	jal	12f8 <close>
  return r;
    11c8:	64a2                	ld	s1,8(sp)
}
    11ca:	854a                	mv	a0,s2
    11cc:	60e2                	ld	ra,24(sp)
    11ce:	6442                	ld	s0,16(sp)
    11d0:	6902                	ld	s2,0(sp)
    11d2:	6105                	addi	sp,sp,32
    11d4:	8082                	ret
    return -1;
    11d6:	597d                	li	s2,-1
    11d8:	bfcd                	j	11ca <stat+0x2a>

00000000000011da <atoi>:

int
atoi(const char *s)
{
    11da:	1141                	addi	sp,sp,-16
    11dc:	e422                	sd	s0,8(sp)
    11de:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11e0:	00054683          	lbu	a3,0(a0)
    11e4:	fd06879b          	addiw	a5,a3,-48
    11e8:	0ff7f793          	zext.b	a5,a5
    11ec:	4625                	li	a2,9
    11ee:	02f66863          	bltu	a2,a5,121e <atoi+0x44>
    11f2:	872a                	mv	a4,a0
  n = 0;
    11f4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    11f6:	0705                	addi	a4,a4,1
    11f8:	0025179b          	slliw	a5,a0,0x2
    11fc:	9fa9                	addw	a5,a5,a0
    11fe:	0017979b          	slliw	a5,a5,0x1
    1202:	9fb5                	addw	a5,a5,a3
    1204:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1208:	00074683          	lbu	a3,0(a4)
    120c:	fd06879b          	addiw	a5,a3,-48
    1210:	0ff7f793          	zext.b	a5,a5
    1214:	fef671e3          	bgeu	a2,a5,11f6 <atoi+0x1c>
  return n;
}
    1218:	6422                	ld	s0,8(sp)
    121a:	0141                	addi	sp,sp,16
    121c:	8082                	ret
  n = 0;
    121e:	4501                	li	a0,0
    1220:	bfe5                	j	1218 <atoi+0x3e>

0000000000001222 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1222:	1141                	addi	sp,sp,-16
    1224:	e422                	sd	s0,8(sp)
    1226:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1228:	02b57463          	bgeu	a0,a1,1250 <memmove+0x2e>
    while(n-- > 0)
    122c:	00c05f63          	blez	a2,124a <memmove+0x28>
    1230:	1602                	slli	a2,a2,0x20
    1232:	9201                	srli	a2,a2,0x20
    1234:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1238:	872a                	mv	a4,a0
      *dst++ = *src++;
    123a:	0585                	addi	a1,a1,1
    123c:	0705                	addi	a4,a4,1
    123e:	fff5c683          	lbu	a3,-1(a1)
    1242:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1246:	fef71ae3          	bne	a4,a5,123a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    124a:	6422                	ld	s0,8(sp)
    124c:	0141                	addi	sp,sp,16
    124e:	8082                	ret
    dst += n;
    1250:	00c50733          	add	a4,a0,a2
    src += n;
    1254:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1256:	fec05ae3          	blez	a2,124a <memmove+0x28>
    125a:	fff6079b          	addiw	a5,a2,-1
    125e:	1782                	slli	a5,a5,0x20
    1260:	9381                	srli	a5,a5,0x20
    1262:	fff7c793          	not	a5,a5
    1266:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1268:	15fd                	addi	a1,a1,-1
    126a:	177d                	addi	a4,a4,-1
    126c:	0005c683          	lbu	a3,0(a1)
    1270:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1274:	fee79ae3          	bne	a5,a4,1268 <memmove+0x46>
    1278:	bfc9                	j	124a <memmove+0x28>

000000000000127a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    127a:	1141                	addi	sp,sp,-16
    127c:	e422                	sd	s0,8(sp)
    127e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1280:	ca05                	beqz	a2,12b0 <memcmp+0x36>
    1282:	fff6069b          	addiw	a3,a2,-1
    1286:	1682                	slli	a3,a3,0x20
    1288:	9281                	srli	a3,a3,0x20
    128a:	0685                	addi	a3,a3,1
    128c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    128e:	00054783          	lbu	a5,0(a0)
    1292:	0005c703          	lbu	a4,0(a1)
    1296:	00e79863          	bne	a5,a4,12a6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    129a:	0505                	addi	a0,a0,1
    p2++;
    129c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    129e:	fed518e3          	bne	a0,a3,128e <memcmp+0x14>
  }
  return 0;
    12a2:	4501                	li	a0,0
    12a4:	a019                	j	12aa <memcmp+0x30>
      return *p1 - *p2;
    12a6:	40e7853b          	subw	a0,a5,a4
}
    12aa:	6422                	ld	s0,8(sp)
    12ac:	0141                	addi	sp,sp,16
    12ae:	8082                	ret
  return 0;
    12b0:	4501                	li	a0,0
    12b2:	bfe5                	j	12aa <memcmp+0x30>

00000000000012b4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    12b4:	1141                	addi	sp,sp,-16
    12b6:	e406                	sd	ra,8(sp)
    12b8:	e022                	sd	s0,0(sp)
    12ba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    12bc:	f67ff0ef          	jal	1222 <memmove>
}
    12c0:	60a2                	ld	ra,8(sp)
    12c2:	6402                	ld	s0,0(sp)
    12c4:	0141                	addi	sp,sp,16
    12c6:	8082                	ret

00000000000012c8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12c8:	4885                	li	a7,1
 ecall
    12ca:	00000073          	ecall
 ret
    12ce:	8082                	ret

00000000000012d0 <exit>:
.global exit
exit:
 li a7, SYS_exit
    12d0:	4889                	li	a7,2
 ecall
    12d2:	00000073          	ecall
 ret
    12d6:	8082                	ret

00000000000012d8 <wait>:
.global wait
wait:
 li a7, SYS_wait
    12d8:	488d                	li	a7,3
 ecall
    12da:	00000073          	ecall
 ret
    12de:	8082                	ret

00000000000012e0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    12e0:	4891                	li	a7,4
 ecall
    12e2:	00000073          	ecall
 ret
    12e6:	8082                	ret

00000000000012e8 <read>:
.global read
read:
 li a7, SYS_read
    12e8:	4895                	li	a7,5
 ecall
    12ea:	00000073          	ecall
 ret
    12ee:	8082                	ret

00000000000012f0 <write>:
.global write
write:
 li a7, SYS_write
    12f0:	48c1                	li	a7,16
 ecall
    12f2:	00000073          	ecall
 ret
    12f6:	8082                	ret

00000000000012f8 <close>:
.global close
close:
 li a7, SYS_close
    12f8:	48d5                	li	a7,21
 ecall
    12fa:	00000073          	ecall
 ret
    12fe:	8082                	ret

0000000000001300 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1300:	4899                	li	a7,6
 ecall
    1302:	00000073          	ecall
 ret
    1306:	8082                	ret

0000000000001308 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1308:	489d                	li	a7,7
 ecall
    130a:	00000073          	ecall
 ret
    130e:	8082                	ret

0000000000001310 <open>:
.global open
open:
 li a7, SYS_open
    1310:	48bd                	li	a7,15
 ecall
    1312:	00000073          	ecall
 ret
    1316:	8082                	ret

0000000000001318 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1318:	48c5                	li	a7,17
 ecall
    131a:	00000073          	ecall
 ret
    131e:	8082                	ret

0000000000001320 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1320:	48c9                	li	a7,18
 ecall
    1322:	00000073          	ecall
 ret
    1326:	8082                	ret

0000000000001328 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1328:	48a1                	li	a7,8
 ecall
    132a:	00000073          	ecall
 ret
    132e:	8082                	ret

0000000000001330 <link>:
.global link
link:
 li a7, SYS_link
    1330:	48cd                	li	a7,19
 ecall
    1332:	00000073          	ecall
 ret
    1336:	8082                	ret

0000000000001338 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1338:	48d1                	li	a7,20
 ecall
    133a:	00000073          	ecall
 ret
    133e:	8082                	ret

0000000000001340 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1340:	48a5                	li	a7,9
 ecall
    1342:	00000073          	ecall
 ret
    1346:	8082                	ret

0000000000001348 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1348:	48a9                	li	a7,10
 ecall
    134a:	00000073          	ecall
 ret
    134e:	8082                	ret

0000000000001350 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1350:	48ad                	li	a7,11
 ecall
    1352:	00000073          	ecall
 ret
    1356:	8082                	ret

0000000000001358 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1358:	48b1                	li	a7,12
 ecall
    135a:	00000073          	ecall
 ret
    135e:	8082                	ret

0000000000001360 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1360:	48b5                	li	a7,13
 ecall
    1362:	00000073          	ecall
 ret
    1366:	8082                	ret

0000000000001368 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1368:	48b9                	li	a7,14
 ecall
    136a:	00000073          	ecall
 ret
    136e:	8082                	ret

0000000000001370 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1370:	48d9                	li	a7,22
 ecall
    1372:	00000073          	ecall
 ret
    1376:	8082                	ret

0000000000001378 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1378:	48dd                	li	a7,23
 ecall
    137a:	00000073          	ecall
 ret
    137e:	8082                	ret

0000000000001380 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1380:	48e1                	li	a7,24
 ecall
    1382:	00000073          	ecall
 ret
    1386:	8082                	ret

0000000000001388 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1388:	48e5                	li	a7,25
 ecall
    138a:	00000073          	ecall
 ret
    138e:	8082                	ret

0000000000001390 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1390:	48e9                	li	a7,26
 ecall
    1392:	00000073          	ecall
 ret
    1396:	8082                	ret

0000000000001398 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    1398:	48ed                	li	a7,27
 ecall
    139a:	00000073          	ecall
 ret
    139e:	8082                	ret

00000000000013a0 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    13a0:	48f1                	li	a7,28
 ecall
    13a2:	00000073          	ecall
 ret
    13a6:	8082                	ret

00000000000013a8 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    13a8:	48f5                	li	a7,29
 ecall
    13aa:	00000073          	ecall
 ret
    13ae:	8082                	ret

00000000000013b0 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    13b0:	48f9                	li	a7,30
 ecall
    13b2:	00000073          	ecall
 ret
    13b6:	8082                	ret

00000000000013b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    13b8:	1101                	addi	sp,sp,-32
    13ba:	ec06                	sd	ra,24(sp)
    13bc:	e822                	sd	s0,16(sp)
    13be:	1000                	addi	s0,sp,32
    13c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13c4:	4605                	li	a2,1
    13c6:	fef40593          	addi	a1,s0,-17
    13ca:	f27ff0ef          	jal	12f0 <write>
}
    13ce:	60e2                	ld	ra,24(sp)
    13d0:	6442                	ld	s0,16(sp)
    13d2:	6105                	addi	sp,sp,32
    13d4:	8082                	ret

00000000000013d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13d6:	7139                	addi	sp,sp,-64
    13d8:	fc06                	sd	ra,56(sp)
    13da:	f822                	sd	s0,48(sp)
    13dc:	f426                	sd	s1,40(sp)
    13de:	0080                	addi	s0,sp,64
    13e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13e2:	c299                	beqz	a3,13e8 <printint+0x12>
    13e4:	0805c963          	bltz	a1,1476 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13e8:	2581                	sext.w	a1,a1
  neg = 0;
    13ea:	4881                	li	a7,0
    13ec:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13f2:	2601                	sext.w	a2,a2
    13f4:	00001517          	auipc	a0,0x1
    13f8:	c4c50513          	addi	a0,a0,-948 # 2040 <digits>
    13fc:	883a                	mv	a6,a4
    13fe:	2705                	addiw	a4,a4,1
    1400:	02c5f7bb          	remuw	a5,a1,a2
    1404:	1782                	slli	a5,a5,0x20
    1406:	9381                	srli	a5,a5,0x20
    1408:	97aa                	add	a5,a5,a0
    140a:	0007c783          	lbu	a5,0(a5)
    140e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1412:	0005879b          	sext.w	a5,a1
    1416:	02c5d5bb          	divuw	a1,a1,a2
    141a:	0685                	addi	a3,a3,1
    141c:	fec7f0e3          	bgeu	a5,a2,13fc <printint+0x26>
  if(neg)
    1420:	00088c63          	beqz	a7,1438 <printint+0x62>
    buf[i++] = '-';
    1424:	fd070793          	addi	a5,a4,-48
    1428:	00878733          	add	a4,a5,s0
    142c:	02d00793          	li	a5,45
    1430:	fef70823          	sb	a5,-16(a4)
    1434:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1438:	02e05a63          	blez	a4,146c <printint+0x96>
    143c:	f04a                	sd	s2,32(sp)
    143e:	ec4e                	sd	s3,24(sp)
    1440:	fc040793          	addi	a5,s0,-64
    1444:	00e78933          	add	s2,a5,a4
    1448:	fff78993          	addi	s3,a5,-1
    144c:	99ba                	add	s3,s3,a4
    144e:	377d                	addiw	a4,a4,-1
    1450:	1702                	slli	a4,a4,0x20
    1452:	9301                	srli	a4,a4,0x20
    1454:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1458:	fff94583          	lbu	a1,-1(s2)
    145c:	8526                	mv	a0,s1
    145e:	f5bff0ef          	jal	13b8 <putc>
  while(--i >= 0)
    1462:	197d                	addi	s2,s2,-1
    1464:	ff391ae3          	bne	s2,s3,1458 <printint+0x82>
    1468:	7902                	ld	s2,32(sp)
    146a:	69e2                	ld	s3,24(sp)
}
    146c:	70e2                	ld	ra,56(sp)
    146e:	7442                	ld	s0,48(sp)
    1470:	74a2                	ld	s1,40(sp)
    1472:	6121                	addi	sp,sp,64
    1474:	8082                	ret
    x = -xx;
    1476:	40b005bb          	negw	a1,a1
    neg = 1;
    147a:	4885                	li	a7,1
    x = -xx;
    147c:	bf85                	j	13ec <printint+0x16>

000000000000147e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    147e:	711d                	addi	sp,sp,-96
    1480:	ec86                	sd	ra,88(sp)
    1482:	e8a2                	sd	s0,80(sp)
    1484:	e0ca                	sd	s2,64(sp)
    1486:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1488:	0005c903          	lbu	s2,0(a1)
    148c:	26090863          	beqz	s2,16fc <vprintf+0x27e>
    1490:	e4a6                	sd	s1,72(sp)
    1492:	fc4e                	sd	s3,56(sp)
    1494:	f852                	sd	s4,48(sp)
    1496:	f456                	sd	s5,40(sp)
    1498:	f05a                	sd	s6,32(sp)
    149a:	ec5e                	sd	s7,24(sp)
    149c:	e862                	sd	s8,16(sp)
    149e:	e466                	sd	s9,8(sp)
    14a0:	8b2a                	mv	s6,a0
    14a2:	8a2e                	mv	s4,a1
    14a4:	8bb2                	mv	s7,a2
  state = 0;
    14a6:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    14a8:	4481                	li	s1,0
    14aa:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    14ac:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    14b0:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    14b4:	06c00c93          	li	s9,108
    14b8:	a005                	j	14d8 <vprintf+0x5a>
        putc(fd, c0);
    14ba:	85ca                	mv	a1,s2
    14bc:	855a                	mv	a0,s6
    14be:	efbff0ef          	jal	13b8 <putc>
    14c2:	a019                	j	14c8 <vprintf+0x4a>
    } else if(state == '%'){
    14c4:	03598263          	beq	s3,s5,14e8 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    14c8:	2485                	addiw	s1,s1,1
    14ca:	8726                	mv	a4,s1
    14cc:	009a07b3          	add	a5,s4,s1
    14d0:	0007c903          	lbu	s2,0(a5)
    14d4:	20090c63          	beqz	s2,16ec <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    14d8:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14dc:	fe0994e3          	bnez	s3,14c4 <vprintf+0x46>
      if(c0 == '%'){
    14e0:	fd579de3          	bne	a5,s5,14ba <vprintf+0x3c>
        state = '%';
    14e4:	89be                	mv	s3,a5
    14e6:	b7cd                	j	14c8 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14e8:	00ea06b3          	add	a3,s4,a4
    14ec:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    14f0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    14f2:	c681                	beqz	a3,14fa <vprintf+0x7c>
    14f4:	9752                	add	a4,a4,s4
    14f6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    14fa:	03878f63          	beq	a5,s8,1538 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    14fe:	05978963          	beq	a5,s9,1550 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1502:	07500713          	li	a4,117
    1506:	0ee78363          	beq	a5,a4,15ec <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    150a:	07800713          	li	a4,120
    150e:	12e78563          	beq	a5,a4,1638 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1512:	07000713          	li	a4,112
    1516:	14e78a63          	beq	a5,a4,166a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    151a:	07300713          	li	a4,115
    151e:	18e78a63          	beq	a5,a4,16b2 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1522:	02500713          	li	a4,37
    1526:	04e79563          	bne	a5,a4,1570 <vprintf+0xf2>
        putc(fd, '%');
    152a:	02500593          	li	a1,37
    152e:	855a                	mv	a0,s6
    1530:	e89ff0ef          	jal	13b8 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1534:	4981                	li	s3,0
    1536:	bf49                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1538:	008b8913          	addi	s2,s7,8
    153c:	4685                	li	a3,1
    153e:	4629                	li	a2,10
    1540:	000ba583          	lw	a1,0(s7)
    1544:	855a                	mv	a0,s6
    1546:	e91ff0ef          	jal	13d6 <printint>
    154a:	8bca                	mv	s7,s2
      state = 0;
    154c:	4981                	li	s3,0
    154e:	bfad                	j	14c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1550:	06400793          	li	a5,100
    1554:	02f68963          	beq	a3,a5,1586 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1558:	06c00793          	li	a5,108
    155c:	04f68263          	beq	a3,a5,15a0 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1560:	07500793          	li	a5,117
    1564:	0af68063          	beq	a3,a5,1604 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1568:	07800793          	li	a5,120
    156c:	0ef68263          	beq	a3,a5,1650 <vprintf+0x1d2>
        putc(fd, '%');
    1570:	02500593          	li	a1,37
    1574:	855a                	mv	a0,s6
    1576:	e43ff0ef          	jal	13b8 <putc>
        putc(fd, c0);
    157a:	85ca                	mv	a1,s2
    157c:	855a                	mv	a0,s6
    157e:	e3bff0ef          	jal	13b8 <putc>
      state = 0;
    1582:	4981                	li	s3,0
    1584:	b791                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1586:	008b8913          	addi	s2,s7,8
    158a:	4685                	li	a3,1
    158c:	4629                	li	a2,10
    158e:	000ba583          	lw	a1,0(s7)
    1592:	855a                	mv	a0,s6
    1594:	e43ff0ef          	jal	13d6 <printint>
        i += 1;
    1598:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    159a:	8bca                	mv	s7,s2
      state = 0;
    159c:	4981                	li	s3,0
        i += 1;
    159e:	b72d                	j	14c8 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15a0:	06400793          	li	a5,100
    15a4:	02f60763          	beq	a2,a5,15d2 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    15a8:	07500793          	li	a5,117
    15ac:	06f60963          	beq	a2,a5,161e <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    15b0:	07800793          	li	a5,120
    15b4:	faf61ee3          	bne	a2,a5,1570 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    15b8:	008b8913          	addi	s2,s7,8
    15bc:	4681                	li	a3,0
    15be:	4641                	li	a2,16
    15c0:	000ba583          	lw	a1,0(s7)
    15c4:	855a                	mv	a0,s6
    15c6:	e11ff0ef          	jal	13d6 <printint>
        i += 2;
    15ca:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    15cc:	8bca                	mv	s7,s2
      state = 0;
    15ce:	4981                	li	s3,0
        i += 2;
    15d0:	bde5                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15d2:	008b8913          	addi	s2,s7,8
    15d6:	4685                	li	a3,1
    15d8:	4629                	li	a2,10
    15da:	000ba583          	lw	a1,0(s7)
    15de:	855a                	mv	a0,s6
    15e0:	df7ff0ef          	jal	13d6 <printint>
        i += 2;
    15e4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15e6:	8bca                	mv	s7,s2
      state = 0;
    15e8:	4981                	li	s3,0
        i += 2;
    15ea:	bdf9                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    15ec:	008b8913          	addi	s2,s7,8
    15f0:	4681                	li	a3,0
    15f2:	4629                	li	a2,10
    15f4:	000ba583          	lw	a1,0(s7)
    15f8:	855a                	mv	a0,s6
    15fa:	dddff0ef          	jal	13d6 <printint>
    15fe:	8bca                	mv	s7,s2
      state = 0;
    1600:	4981                	li	s3,0
    1602:	b5d9                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1604:	008b8913          	addi	s2,s7,8
    1608:	4681                	li	a3,0
    160a:	4629                	li	a2,10
    160c:	000ba583          	lw	a1,0(s7)
    1610:	855a                	mv	a0,s6
    1612:	dc5ff0ef          	jal	13d6 <printint>
        i += 1;
    1616:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1618:	8bca                	mv	s7,s2
      state = 0;
    161a:	4981                	li	s3,0
        i += 1;
    161c:	b575                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    161e:	008b8913          	addi	s2,s7,8
    1622:	4681                	li	a3,0
    1624:	4629                	li	a2,10
    1626:	000ba583          	lw	a1,0(s7)
    162a:	855a                	mv	a0,s6
    162c:	dabff0ef          	jal	13d6 <printint>
        i += 2;
    1630:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1632:	8bca                	mv	s7,s2
      state = 0;
    1634:	4981                	li	s3,0
        i += 2;
    1636:	bd49                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1638:	008b8913          	addi	s2,s7,8
    163c:	4681                	li	a3,0
    163e:	4641                	li	a2,16
    1640:	000ba583          	lw	a1,0(s7)
    1644:	855a                	mv	a0,s6
    1646:	d91ff0ef          	jal	13d6 <printint>
    164a:	8bca                	mv	s7,s2
      state = 0;
    164c:	4981                	li	s3,0
    164e:	bdad                	j	14c8 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1650:	008b8913          	addi	s2,s7,8
    1654:	4681                	li	a3,0
    1656:	4641                	li	a2,16
    1658:	000ba583          	lw	a1,0(s7)
    165c:	855a                	mv	a0,s6
    165e:	d79ff0ef          	jal	13d6 <printint>
        i += 1;
    1662:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1664:	8bca                	mv	s7,s2
      state = 0;
    1666:	4981                	li	s3,0
        i += 1;
    1668:	b585                	j	14c8 <vprintf+0x4a>
    166a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    166c:	008b8d13          	addi	s10,s7,8
    1670:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1674:	03000593          	li	a1,48
    1678:	855a                	mv	a0,s6
    167a:	d3fff0ef          	jal	13b8 <putc>
  putc(fd, 'x');
    167e:	07800593          	li	a1,120
    1682:	855a                	mv	a0,s6
    1684:	d35ff0ef          	jal	13b8 <putc>
    1688:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    168a:	00001b97          	auipc	s7,0x1
    168e:	9b6b8b93          	addi	s7,s7,-1610 # 2040 <digits>
    1692:	03c9d793          	srli	a5,s3,0x3c
    1696:	97de                	add	a5,a5,s7
    1698:	0007c583          	lbu	a1,0(a5)
    169c:	855a                	mv	a0,s6
    169e:	d1bff0ef          	jal	13b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    16a2:	0992                	slli	s3,s3,0x4
    16a4:	397d                	addiw	s2,s2,-1
    16a6:	fe0916e3          	bnez	s2,1692 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    16aa:	8bea                	mv	s7,s10
      state = 0;
    16ac:	4981                	li	s3,0
    16ae:	6d02                	ld	s10,0(sp)
    16b0:	bd21                	j	14c8 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    16b2:	008b8993          	addi	s3,s7,8
    16b6:	000bb903          	ld	s2,0(s7)
    16ba:	00090f63          	beqz	s2,16d8 <vprintf+0x25a>
        for(; *s; s++)
    16be:	00094583          	lbu	a1,0(s2)
    16c2:	c195                	beqz	a1,16e6 <vprintf+0x268>
          putc(fd, *s);
    16c4:	855a                	mv	a0,s6
    16c6:	cf3ff0ef          	jal	13b8 <putc>
        for(; *s; s++)
    16ca:	0905                	addi	s2,s2,1
    16cc:	00094583          	lbu	a1,0(s2)
    16d0:	f9f5                	bnez	a1,16c4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16d2:	8bce                	mv	s7,s3
      state = 0;
    16d4:	4981                	li	s3,0
    16d6:	bbcd                	j	14c8 <vprintf+0x4a>
          s = "(null)";
    16d8:	00001917          	auipc	s2,0x1
    16dc:	96090913          	addi	s2,s2,-1696 # 2038 <malloc+0x854>
        for(; *s; s++)
    16e0:	02800593          	li	a1,40
    16e4:	b7c5                	j	16c4 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16e6:	8bce                	mv	s7,s3
      state = 0;
    16e8:	4981                	li	s3,0
    16ea:	bbf9                	j	14c8 <vprintf+0x4a>
    16ec:	64a6                	ld	s1,72(sp)
    16ee:	79e2                	ld	s3,56(sp)
    16f0:	7a42                	ld	s4,48(sp)
    16f2:	7aa2                	ld	s5,40(sp)
    16f4:	7b02                	ld	s6,32(sp)
    16f6:	6be2                	ld	s7,24(sp)
    16f8:	6c42                	ld	s8,16(sp)
    16fa:	6ca2                	ld	s9,8(sp)
    }
  }
}
    16fc:	60e6                	ld	ra,88(sp)
    16fe:	6446                	ld	s0,80(sp)
    1700:	6906                	ld	s2,64(sp)
    1702:	6125                	addi	sp,sp,96
    1704:	8082                	ret

0000000000001706 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1706:	715d                	addi	sp,sp,-80
    1708:	ec06                	sd	ra,24(sp)
    170a:	e822                	sd	s0,16(sp)
    170c:	1000                	addi	s0,sp,32
    170e:	e010                	sd	a2,0(s0)
    1710:	e414                	sd	a3,8(s0)
    1712:	e818                	sd	a4,16(s0)
    1714:	ec1c                	sd	a5,24(s0)
    1716:	03043023          	sd	a6,32(s0)
    171a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    171e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1722:	8622                	mv	a2,s0
    1724:	d5bff0ef          	jal	147e <vprintf>
}
    1728:	60e2                	ld	ra,24(sp)
    172a:	6442                	ld	s0,16(sp)
    172c:	6161                	addi	sp,sp,80
    172e:	8082                	ret

0000000000001730 <printf>:

void
printf(const char *fmt, ...)
{
    1730:	711d                	addi	sp,sp,-96
    1732:	ec06                	sd	ra,24(sp)
    1734:	e822                	sd	s0,16(sp)
    1736:	1000                	addi	s0,sp,32
    1738:	e40c                	sd	a1,8(s0)
    173a:	e810                	sd	a2,16(s0)
    173c:	ec14                	sd	a3,24(s0)
    173e:	f018                	sd	a4,32(s0)
    1740:	f41c                	sd	a5,40(s0)
    1742:	03043823          	sd	a6,48(s0)
    1746:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    174a:	00840613          	addi	a2,s0,8
    174e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1752:	85aa                	mv	a1,a0
    1754:	4505                	li	a0,1
    1756:	d29ff0ef          	jal	147e <vprintf>
}
    175a:	60e2                	ld	ra,24(sp)
    175c:	6442                	ld	s0,16(sp)
    175e:	6125                	addi	sp,sp,96
    1760:	8082                	ret

0000000000001762 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1762:	1141                	addi	sp,sp,-16
    1764:	e422                	sd	s0,8(sp)
    1766:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1768:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    176c:	00001797          	auipc	a5,0x1
    1770:	8f47b783          	ld	a5,-1804(a5) # 2060 <freep>
    1774:	a02d                	j	179e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1776:	4618                	lw	a4,8(a2)
    1778:	9f2d                	addw	a4,a4,a1
    177a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    177e:	6398                	ld	a4,0(a5)
    1780:	6310                	ld	a2,0(a4)
    1782:	a83d                	j	17c0 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1784:	ff852703          	lw	a4,-8(a0)
    1788:	9f31                	addw	a4,a4,a2
    178a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    178c:	ff053683          	ld	a3,-16(a0)
    1790:	a091                	j	17d4 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1792:	6398                	ld	a4,0(a5)
    1794:	00e7e463          	bltu	a5,a4,179c <free+0x3a>
    1798:	00e6ea63          	bltu	a3,a4,17ac <free+0x4a>
{
    179c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    179e:	fed7fae3          	bgeu	a5,a3,1792 <free+0x30>
    17a2:	6398                	ld	a4,0(a5)
    17a4:	00e6e463          	bltu	a3,a4,17ac <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17a8:	fee7eae3          	bltu	a5,a4,179c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    17ac:	ff852583          	lw	a1,-8(a0)
    17b0:	6390                	ld	a2,0(a5)
    17b2:	02059813          	slli	a6,a1,0x20
    17b6:	01c85713          	srli	a4,a6,0x1c
    17ba:	9736                	add	a4,a4,a3
    17bc:	fae60de3          	beq	a2,a4,1776 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    17c0:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    17c4:	4790                	lw	a2,8(a5)
    17c6:	02061593          	slli	a1,a2,0x20
    17ca:	01c5d713          	srli	a4,a1,0x1c
    17ce:	973e                	add	a4,a4,a5
    17d0:	fae68ae3          	beq	a3,a4,1784 <free+0x22>
    p->s.ptr = bp->s.ptr;
    17d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    17d6:	00001717          	auipc	a4,0x1
    17da:	88f73523          	sd	a5,-1910(a4) # 2060 <freep>
}
    17de:	6422                	ld	s0,8(sp)
    17e0:	0141                	addi	sp,sp,16
    17e2:	8082                	ret

00000000000017e4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17e4:	7139                	addi	sp,sp,-64
    17e6:	fc06                	sd	ra,56(sp)
    17e8:	f822                	sd	s0,48(sp)
    17ea:	f426                	sd	s1,40(sp)
    17ec:	ec4e                	sd	s3,24(sp)
    17ee:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17f0:	02051493          	slli	s1,a0,0x20
    17f4:	9081                	srli	s1,s1,0x20
    17f6:	04bd                	addi	s1,s1,15
    17f8:	8091                	srli	s1,s1,0x4
    17fa:	0014899b          	addiw	s3,s1,1
    17fe:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1800:	00001517          	auipc	a0,0x1
    1804:	86053503          	ld	a0,-1952(a0) # 2060 <freep>
    1808:	c915                	beqz	a0,183c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    180a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    180c:	4798                	lw	a4,8(a5)
    180e:	08977a63          	bgeu	a4,s1,18a2 <malloc+0xbe>
    1812:	f04a                	sd	s2,32(sp)
    1814:	e852                	sd	s4,16(sp)
    1816:	e456                	sd	s5,8(sp)
    1818:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    181a:	8a4e                	mv	s4,s3
    181c:	0009871b          	sext.w	a4,s3
    1820:	6685                	lui	a3,0x1
    1822:	00d77363          	bgeu	a4,a3,1828 <malloc+0x44>
    1826:	6a05                	lui	s4,0x1
    1828:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    182c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1830:	00001917          	auipc	s2,0x1
    1834:	83090913          	addi	s2,s2,-2000 # 2060 <freep>
  if(p == (char*)-1)
    1838:	5afd                	li	s5,-1
    183a:	a081                	j	187a <malloc+0x96>
    183c:	f04a                	sd	s2,32(sp)
    183e:	e852                	sd	s4,16(sp)
    1840:	e456                	sd	s5,8(sp)
    1842:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1844:	00001797          	auipc	a5,0x1
    1848:	82c78793          	addi	a5,a5,-2004 # 2070 <base>
    184c:	00001717          	auipc	a4,0x1
    1850:	80f73a23          	sd	a5,-2028(a4) # 2060 <freep>
    1854:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1856:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    185a:	b7c1                	j	181a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    185c:	6398                	ld	a4,0(a5)
    185e:	e118                	sd	a4,0(a0)
    1860:	a8a9                	j	18ba <malloc+0xd6>
  hp->s.size = nu;
    1862:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1866:	0541                	addi	a0,a0,16
    1868:	efbff0ef          	jal	1762 <free>
  return freep;
    186c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1870:	c12d                	beqz	a0,18d2 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1872:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1874:	4798                	lw	a4,8(a5)
    1876:	02977263          	bgeu	a4,s1,189a <malloc+0xb6>
    if(p == freep)
    187a:	00093703          	ld	a4,0(s2)
    187e:	853e                	mv	a0,a5
    1880:	fef719e3          	bne	a4,a5,1872 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1884:	8552                	mv	a0,s4
    1886:	ad3ff0ef          	jal	1358 <sbrk>
  if(p == (char*)-1)
    188a:	fd551ce3          	bne	a0,s5,1862 <malloc+0x7e>
        return 0;
    188e:	4501                	li	a0,0
    1890:	7902                	ld	s2,32(sp)
    1892:	6a42                	ld	s4,16(sp)
    1894:	6aa2                	ld	s5,8(sp)
    1896:	6b02                	ld	s6,0(sp)
    1898:	a03d                	j	18c6 <malloc+0xe2>
    189a:	7902                	ld	s2,32(sp)
    189c:	6a42                	ld	s4,16(sp)
    189e:	6aa2                	ld	s5,8(sp)
    18a0:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    18a2:	fae48de3          	beq	s1,a4,185c <malloc+0x78>
        p->s.size -= nunits;
    18a6:	4137073b          	subw	a4,a4,s3
    18aa:	c798                	sw	a4,8(a5)
        p += p->s.size;
    18ac:	02071693          	slli	a3,a4,0x20
    18b0:	01c6d713          	srli	a4,a3,0x1c
    18b4:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    18b6:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    18ba:	00000717          	auipc	a4,0x0
    18be:	7aa73323          	sd	a0,1958(a4) # 2060 <freep>
      return (void*)(p + 1);
    18c2:	01078513          	addi	a0,a5,16
  }
}
    18c6:	70e2                	ld	ra,56(sp)
    18c8:	7442                	ld	s0,48(sp)
    18ca:	74a2                	ld	s1,40(sp)
    18cc:	69e2                	ld	s3,24(sp)
    18ce:	6121                	addi	sp,sp,64
    18d0:	8082                	ret
    18d2:	7902                	ld	s2,32(sp)
    18d4:	6a42                	ld	s4,16(sp)
    18d6:	6aa2                	ld	s5,8(sp)
    18d8:	6b02                	ld	s6,0(sp)
    18da:	b7f5                	j	18c6 <malloc+0xe2>
	...
