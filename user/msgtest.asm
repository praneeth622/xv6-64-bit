
user/_msgtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#define MSGMAX 128
#define KEY 12345  // Using a fixed key instead of IPC_PRIVATE

int
main(int argc, char *argv[])
{
    1000:	be010113          	addi	sp,sp,-1056
    1004:	40113c23          	sd	ra,1048(sp)
    1008:	40813823          	sd	s0,1040(sp)
    100c:	42010413          	addi	s0,sp,1056
  struct msg_buf msg;  // Message buffer for sending
  
  // Initialize message type
  msg.mtype = 1;
    1010:	4785                	li	a5,1
    1012:	bef43423          	sd	a5,-1048(s0)
  
  // Copy message text (using byte-by-byte copy since we don't have string.h)
  char *text = "Hello from xv6!";
  char *dest = msg.mtext;
  char *src = text;
    1016:	00001717          	auipc	a4,0x1
    101a:	fea70713          	addi	a4,a4,-22 # 2000 <malloc+0x812>
  char *dest = msg.mtext;
    101e:	bf040793          	addi	a5,s0,-1040
  while((*dest++ = *src++) != 0)
    1022:	0705                	addi	a4,a4,1
    1024:	0785                	addi	a5,a5,1
    1026:	fff74683          	lbu	a3,-1(a4)
    102a:	fed78fa3          	sb	a3,-1(a5)
    102e:	faf5                	bnez	a3,1022 <main+0x22>
    ;
  
  // Create a message queue
  int msqid = msgget(KEY, O_CREATE | 0666);
    1030:	3b600593          	li	a1,950
    1034:	650d                	lui	a0,0x3
    1036:	03950513          	addi	a0,a0,57 # 3039 <base+0xfc9>
    103a:	350000ef          	jal	138a <msgget>
  if (msqid < 0) {
    103e:	02054063          	bltz	a0,105e <main+0x5e>
      printf("msgget failed\n");
      exit(1);
  }

  printf("msgget successful!\n");
    1042:	00001517          	auipc	a0,0x1
    1046:	fde50513          	addi	a0,a0,-34 # 2020 <malloc+0x832>
    104a:	6f0000ef          	jal	173a <printf>
  //   exit(1);
  // }

  // printf("msgctl...");
  // exit(0);
    104e:	4501                	li	a0,0
    1050:	41813083          	ld	ra,1048(sp)
    1054:	41013403          	ld	s0,1040(sp)
    1058:	42010113          	addi	sp,sp,1056
    105c:	8082                	ret
      printf("msgget failed\n");
    105e:	00001517          	auipc	a0,0x1
    1062:	fb250513          	addi	a0,a0,-78 # 2010 <malloc+0x822>
    1066:	6d4000ef          	jal	173a <printf>
      exit(1);
    106a:	4505                	li	a0,1
    106c:	26e000ef          	jal	12da <exit>

0000000000001070 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    1070:	1141                	addi	sp,sp,-16
    1072:	e406                	sd	ra,8(sp)
    1074:	e022                	sd	s0,0(sp)
    1076:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1078:	f89ff0ef          	jal	1000 <main>
  exit(0);
    107c:	4501                	li	a0,0
    107e:	25c000ef          	jal	12da <exit>

0000000000001082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    1082:	1141                	addi	sp,sp,-16
    1084:	e422                	sd	s0,8(sp)
    1086:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1088:	87aa                	mv	a5,a0
    108a:	0585                	addi	a1,a1,1
    108c:	0785                	addi	a5,a5,1
    108e:	fff5c703          	lbu	a4,-1(a1)
    1092:	fee78fa3          	sb	a4,-1(a5)
    1096:	fb75                	bnez	a4,108a <strcpy+0x8>
    ;
  return os;
}
    1098:	6422                	ld	s0,8(sp)
    109a:	0141                	addi	sp,sp,16
    109c:	8082                	ret

000000000000109e <strcmp>:

int
strcmp(const char *p, const char *q)
{
    109e:	1141                	addi	sp,sp,-16
    10a0:	e422                	sd	s0,8(sp)
    10a2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    10a4:	00054783          	lbu	a5,0(a0)
    10a8:	cb91                	beqz	a5,10bc <strcmp+0x1e>
    10aa:	0005c703          	lbu	a4,0(a1)
    10ae:	00f71763          	bne	a4,a5,10bc <strcmp+0x1e>
    p++, q++;
    10b2:	0505                	addi	a0,a0,1
    10b4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    10b6:	00054783          	lbu	a5,0(a0)
    10ba:	fbe5                	bnez	a5,10aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    10bc:	0005c503          	lbu	a0,0(a1)
}
    10c0:	40a7853b          	subw	a0,a5,a0
    10c4:	6422                	ld	s0,8(sp)
    10c6:	0141                	addi	sp,sp,16
    10c8:	8082                	ret

00000000000010ca <strlen>:

uint
strlen(const char *s)
{
    10ca:	1141                	addi	sp,sp,-16
    10cc:	e422                	sd	s0,8(sp)
    10ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    10d0:	00054783          	lbu	a5,0(a0)
    10d4:	cf91                	beqz	a5,10f0 <strlen+0x26>
    10d6:	0505                	addi	a0,a0,1
    10d8:	87aa                	mv	a5,a0
    10da:	86be                	mv	a3,a5
    10dc:	0785                	addi	a5,a5,1
    10de:	fff7c703          	lbu	a4,-1(a5)
    10e2:	ff65                	bnez	a4,10da <strlen+0x10>
    10e4:	40a6853b          	subw	a0,a3,a0
    10e8:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    10ea:	6422                	ld	s0,8(sp)
    10ec:	0141                	addi	sp,sp,16
    10ee:	8082                	ret
  for(n = 0; s[n]; n++)
    10f0:	4501                	li	a0,0
    10f2:	bfe5                	j	10ea <strlen+0x20>

00000000000010f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
    10f4:	1141                	addi	sp,sp,-16
    10f6:	e422                	sd	s0,8(sp)
    10f8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    10fa:	ca19                	beqz	a2,1110 <memset+0x1c>
    10fc:	87aa                	mv	a5,a0
    10fe:	1602                	slli	a2,a2,0x20
    1100:	9201                	srli	a2,a2,0x20
    1102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    110a:	0785                	addi	a5,a5,1
    110c:	fee79de3          	bne	a5,a4,1106 <memset+0x12>
  }
  return dst;
}
    1110:	6422                	ld	s0,8(sp)
    1112:	0141                	addi	sp,sp,16
    1114:	8082                	ret

0000000000001116 <strchr>:

char*
strchr(const char *s, char c)
{
    1116:	1141                	addi	sp,sp,-16
    1118:	e422                	sd	s0,8(sp)
    111a:	0800                	addi	s0,sp,16
  for(; *s; s++)
    111c:	00054783          	lbu	a5,0(a0)
    1120:	cb99                	beqz	a5,1136 <strchr+0x20>
    if(*s == c)
    1122:	00f58763          	beq	a1,a5,1130 <strchr+0x1a>
  for(; *s; s++)
    1126:	0505                	addi	a0,a0,1
    1128:	00054783          	lbu	a5,0(a0)
    112c:	fbfd                	bnez	a5,1122 <strchr+0xc>
      return (char*)s;
  return 0;
    112e:	4501                	li	a0,0
}
    1130:	6422                	ld	s0,8(sp)
    1132:	0141                	addi	sp,sp,16
    1134:	8082                	ret
  return 0;
    1136:	4501                	li	a0,0
    1138:	bfe5                	j	1130 <strchr+0x1a>

000000000000113a <gets>:

char*
gets(char *buf, int max)
{
    113a:	711d                	addi	sp,sp,-96
    113c:	ec86                	sd	ra,88(sp)
    113e:	e8a2                	sd	s0,80(sp)
    1140:	e4a6                	sd	s1,72(sp)
    1142:	e0ca                	sd	s2,64(sp)
    1144:	fc4e                	sd	s3,56(sp)
    1146:	f852                	sd	s4,48(sp)
    1148:	f456                	sd	s5,40(sp)
    114a:	f05a                	sd	s6,32(sp)
    114c:	ec5e                	sd	s7,24(sp)
    114e:	1080                	addi	s0,sp,96
    1150:	8baa                	mv	s7,a0
    1152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1154:	892a                	mv	s2,a0
    1156:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1158:	4aa9                	li	s5,10
    115a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    115c:	89a6                	mv	s3,s1
    115e:	2485                	addiw	s1,s1,1
    1160:	0344d663          	bge	s1,s4,118c <gets+0x52>
    cc = read(0, &c, 1);
    1164:	4605                	li	a2,1
    1166:	faf40593          	addi	a1,s0,-81
    116a:	4501                	li	a0,0
    116c:	186000ef          	jal	12f2 <read>
    if(cc < 1)
    1170:	00a05e63          	blez	a0,118c <gets+0x52>
    buf[i++] = c;
    1174:	faf44783          	lbu	a5,-81(s0)
    1178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    117c:	01578763          	beq	a5,s5,118a <gets+0x50>
    1180:	0905                	addi	s2,s2,1
    1182:	fd679de3          	bne	a5,s6,115c <gets+0x22>
    buf[i++] = c;
    1186:	89a6                	mv	s3,s1
    1188:	a011                	j	118c <gets+0x52>
    118a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    118c:	99de                	add	s3,s3,s7
    118e:	00098023          	sb	zero,0(s3)
  return buf;
}
    1192:	855e                	mv	a0,s7
    1194:	60e6                	ld	ra,88(sp)
    1196:	6446                	ld	s0,80(sp)
    1198:	64a6                	ld	s1,72(sp)
    119a:	6906                	ld	s2,64(sp)
    119c:	79e2                	ld	s3,56(sp)
    119e:	7a42                	ld	s4,48(sp)
    11a0:	7aa2                	ld	s5,40(sp)
    11a2:	7b02                	ld	s6,32(sp)
    11a4:	6be2                	ld	s7,24(sp)
    11a6:	6125                	addi	sp,sp,96
    11a8:	8082                	ret

00000000000011aa <stat>:

int
stat(const char *n, struct stat *st)
{
    11aa:	1101                	addi	sp,sp,-32
    11ac:	ec06                	sd	ra,24(sp)
    11ae:	e822                	sd	s0,16(sp)
    11b0:	e04a                	sd	s2,0(sp)
    11b2:	1000                	addi	s0,sp,32
    11b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    11b6:	4581                	li	a1,0
    11b8:	162000ef          	jal	131a <open>
  if(fd < 0)
    11bc:	02054263          	bltz	a0,11e0 <stat+0x36>
    11c0:	e426                	sd	s1,8(sp)
    11c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    11c4:	85ca                	mv	a1,s2
    11c6:	16c000ef          	jal	1332 <fstat>
    11ca:	892a                	mv	s2,a0
  close(fd);
    11cc:	8526                	mv	a0,s1
    11ce:	134000ef          	jal	1302 <close>
  return r;
    11d2:	64a2                	ld	s1,8(sp)
}
    11d4:	854a                	mv	a0,s2
    11d6:	60e2                	ld	ra,24(sp)
    11d8:	6442                	ld	s0,16(sp)
    11da:	6902                	ld	s2,0(sp)
    11dc:	6105                	addi	sp,sp,32
    11de:	8082                	ret
    return -1;
    11e0:	597d                	li	s2,-1
    11e2:	bfcd                	j	11d4 <stat+0x2a>

00000000000011e4 <atoi>:

int
atoi(const char *s)
{
    11e4:	1141                	addi	sp,sp,-16
    11e6:	e422                	sd	s0,8(sp)
    11e8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    11ea:	00054683          	lbu	a3,0(a0)
    11ee:	fd06879b          	addiw	a5,a3,-48
    11f2:	0ff7f793          	zext.b	a5,a5
    11f6:	4625                	li	a2,9
    11f8:	02f66863          	bltu	a2,a5,1228 <atoi+0x44>
    11fc:	872a                	mv	a4,a0
  n = 0;
    11fe:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    1200:	0705                	addi	a4,a4,1
    1202:	0025179b          	slliw	a5,a0,0x2
    1206:	9fa9                	addw	a5,a5,a0
    1208:	0017979b          	slliw	a5,a5,0x1
    120c:	9fb5                	addw	a5,a5,a3
    120e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1212:	00074683          	lbu	a3,0(a4)
    1216:	fd06879b          	addiw	a5,a3,-48
    121a:	0ff7f793          	zext.b	a5,a5
    121e:	fef671e3          	bgeu	a2,a5,1200 <atoi+0x1c>
  return n;
}
    1222:	6422                	ld	s0,8(sp)
    1224:	0141                	addi	sp,sp,16
    1226:	8082                	ret
  n = 0;
    1228:	4501                	li	a0,0
    122a:	bfe5                	j	1222 <atoi+0x3e>

000000000000122c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    122c:	1141                	addi	sp,sp,-16
    122e:	e422                	sd	s0,8(sp)
    1230:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1232:	02b57463          	bgeu	a0,a1,125a <memmove+0x2e>
    while(n-- > 0)
    1236:	00c05f63          	blez	a2,1254 <memmove+0x28>
    123a:	1602                	slli	a2,a2,0x20
    123c:	9201                	srli	a2,a2,0x20
    123e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1242:	872a                	mv	a4,a0
      *dst++ = *src++;
    1244:	0585                	addi	a1,a1,1
    1246:	0705                	addi	a4,a4,1
    1248:	fff5c683          	lbu	a3,-1(a1)
    124c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1250:	fef71ae3          	bne	a4,a5,1244 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1254:	6422                	ld	s0,8(sp)
    1256:	0141                	addi	sp,sp,16
    1258:	8082                	ret
    dst += n;
    125a:	00c50733          	add	a4,a0,a2
    src += n;
    125e:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1260:	fec05ae3          	blez	a2,1254 <memmove+0x28>
    1264:	fff6079b          	addiw	a5,a2,-1
    1268:	1782                	slli	a5,a5,0x20
    126a:	9381                	srli	a5,a5,0x20
    126c:	fff7c793          	not	a5,a5
    1270:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1272:	15fd                	addi	a1,a1,-1
    1274:	177d                	addi	a4,a4,-1
    1276:	0005c683          	lbu	a3,0(a1)
    127a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    127e:	fee79ae3          	bne	a5,a4,1272 <memmove+0x46>
    1282:	bfc9                	j	1254 <memmove+0x28>

0000000000001284 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1284:	1141                	addi	sp,sp,-16
    1286:	e422                	sd	s0,8(sp)
    1288:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    128a:	ca05                	beqz	a2,12ba <memcmp+0x36>
    128c:	fff6069b          	addiw	a3,a2,-1
    1290:	1682                	slli	a3,a3,0x20
    1292:	9281                	srli	a3,a3,0x20
    1294:	0685                	addi	a3,a3,1
    1296:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1298:	00054783          	lbu	a5,0(a0)
    129c:	0005c703          	lbu	a4,0(a1)
    12a0:	00e79863          	bne	a5,a4,12b0 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    12a4:	0505                	addi	a0,a0,1
    p2++;
    12a6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    12a8:	fed518e3          	bne	a0,a3,1298 <memcmp+0x14>
  }
  return 0;
    12ac:	4501                	li	a0,0
    12ae:	a019                	j	12b4 <memcmp+0x30>
      return *p1 - *p2;
    12b0:	40e7853b          	subw	a0,a5,a4
}
    12b4:	6422                	ld	s0,8(sp)
    12b6:	0141                	addi	sp,sp,16
    12b8:	8082                	ret
  return 0;
    12ba:	4501                	li	a0,0
    12bc:	bfe5                	j	12b4 <memcmp+0x30>

00000000000012be <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    12be:	1141                	addi	sp,sp,-16
    12c0:	e406                	sd	ra,8(sp)
    12c2:	e022                	sd	s0,0(sp)
    12c4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    12c6:	f67ff0ef          	jal	122c <memmove>
}
    12ca:	60a2                	ld	ra,8(sp)
    12cc:	6402                	ld	s0,0(sp)
    12ce:	0141                	addi	sp,sp,16
    12d0:	8082                	ret

00000000000012d2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    12d2:	4885                	li	a7,1
 ecall
    12d4:	00000073          	ecall
 ret
    12d8:	8082                	ret

00000000000012da <exit>:
.global exit
exit:
 li a7, SYS_exit
    12da:	4889                	li	a7,2
 ecall
    12dc:	00000073          	ecall
 ret
    12e0:	8082                	ret

00000000000012e2 <wait>:
.global wait
wait:
 li a7, SYS_wait
    12e2:	488d                	li	a7,3
 ecall
    12e4:	00000073          	ecall
 ret
    12e8:	8082                	ret

00000000000012ea <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    12ea:	4891                	li	a7,4
 ecall
    12ec:	00000073          	ecall
 ret
    12f0:	8082                	ret

00000000000012f2 <read>:
.global read
read:
 li a7, SYS_read
    12f2:	4895                	li	a7,5
 ecall
    12f4:	00000073          	ecall
 ret
    12f8:	8082                	ret

00000000000012fa <write>:
.global write
write:
 li a7, SYS_write
    12fa:	48c1                	li	a7,16
 ecall
    12fc:	00000073          	ecall
 ret
    1300:	8082                	ret

0000000000001302 <close>:
.global close
close:
 li a7, SYS_close
    1302:	48d5                	li	a7,21
 ecall
    1304:	00000073          	ecall
 ret
    1308:	8082                	ret

000000000000130a <kill>:
.global kill
kill:
 li a7, SYS_kill
    130a:	4899                	li	a7,6
 ecall
    130c:	00000073          	ecall
 ret
    1310:	8082                	ret

0000000000001312 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1312:	489d                	li	a7,7
 ecall
    1314:	00000073          	ecall
 ret
    1318:	8082                	ret

000000000000131a <open>:
.global open
open:
 li a7, SYS_open
    131a:	48bd                	li	a7,15
 ecall
    131c:	00000073          	ecall
 ret
    1320:	8082                	ret

0000000000001322 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1322:	48c5                	li	a7,17
 ecall
    1324:	00000073          	ecall
 ret
    1328:	8082                	ret

000000000000132a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    132a:	48c9                	li	a7,18
 ecall
    132c:	00000073          	ecall
 ret
    1330:	8082                	ret

0000000000001332 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1332:	48a1                	li	a7,8
 ecall
    1334:	00000073          	ecall
 ret
    1338:	8082                	ret

000000000000133a <link>:
.global link
link:
 li a7, SYS_link
    133a:	48cd                	li	a7,19
 ecall
    133c:	00000073          	ecall
 ret
    1340:	8082                	ret

0000000000001342 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1342:	48d1                	li	a7,20
 ecall
    1344:	00000073          	ecall
 ret
    1348:	8082                	ret

000000000000134a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    134a:	48a5                	li	a7,9
 ecall
    134c:	00000073          	ecall
 ret
    1350:	8082                	ret

0000000000001352 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1352:	48a9                	li	a7,10
 ecall
    1354:	00000073          	ecall
 ret
    1358:	8082                	ret

000000000000135a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    135a:	48ad                	li	a7,11
 ecall
    135c:	00000073          	ecall
 ret
    1360:	8082                	ret

0000000000001362 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1362:	48b1                	li	a7,12
 ecall
    1364:	00000073          	ecall
 ret
    1368:	8082                	ret

000000000000136a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    136a:	48b5                	li	a7,13
 ecall
    136c:	00000073          	ecall
 ret
    1370:	8082                	ret

0000000000001372 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1372:	48b9                	li	a7,14
 ecall
    1374:	00000073          	ecall
 ret
    1378:	8082                	ret

000000000000137a <cps>:
.global cps
cps:
 li a7, SYS_cps
    137a:	48d9                	li	a7,22
 ecall
    137c:	00000073          	ecall
 ret
    1380:	8082                	ret

0000000000001382 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1382:	48dd                	li	a7,23
 ecall
    1384:	00000073          	ecall
 ret
    1388:	8082                	ret

000000000000138a <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    138a:	48e1                	li	a7,24
 ecall
    138c:	00000073          	ecall
 ret
    1390:	8082                	ret

0000000000001392 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1392:	48e5                	li	a7,25
 ecall
    1394:	00000073          	ecall
 ret
    1398:	8082                	ret

000000000000139a <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    139a:	48e9                	li	a7,26
 ecall
    139c:	00000073          	ecall
 ret
    13a0:	8082                	ret

00000000000013a2 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    13a2:	48ed                	li	a7,27
 ecall
    13a4:	00000073          	ecall
 ret
    13a8:	8082                	ret

00000000000013aa <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    13aa:	48f1                	li	a7,28
 ecall
    13ac:	00000073          	ecall
 ret
    13b0:	8082                	ret

00000000000013b2 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    13b2:	48f5                	li	a7,29
 ecall
    13b4:	00000073          	ecall
 ret
    13b8:	8082                	ret

00000000000013ba <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    13ba:	48f9                	li	a7,30
 ecall
    13bc:	00000073          	ecall
 ret
    13c0:	8082                	ret

00000000000013c2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    13c2:	1101                	addi	sp,sp,-32
    13c4:	ec06                	sd	ra,24(sp)
    13c6:	e822                	sd	s0,16(sp)
    13c8:	1000                	addi	s0,sp,32
    13ca:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    13ce:	4605                	li	a2,1
    13d0:	fef40593          	addi	a1,s0,-17
    13d4:	f27ff0ef          	jal	12fa <write>
}
    13d8:	60e2                	ld	ra,24(sp)
    13da:	6442                	ld	s0,16(sp)
    13dc:	6105                	addi	sp,sp,32
    13de:	8082                	ret

00000000000013e0 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    13e0:	7139                	addi	sp,sp,-64
    13e2:	fc06                	sd	ra,56(sp)
    13e4:	f822                	sd	s0,48(sp)
    13e6:	f426                	sd	s1,40(sp)
    13e8:	0080                	addi	s0,sp,64
    13ea:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    13ec:	c299                	beqz	a3,13f2 <printint+0x12>
    13ee:	0805c963          	bltz	a1,1480 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    13f2:	2581                	sext.w	a1,a1
  neg = 0;
    13f4:	4881                	li	a7,0
    13f6:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    13fa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    13fc:	2601                	sext.w	a2,a2
    13fe:	00001517          	auipc	a0,0x1
    1402:	c4250513          	addi	a0,a0,-958 # 2040 <digits>
    1406:	883a                	mv	a6,a4
    1408:	2705                	addiw	a4,a4,1
    140a:	02c5f7bb          	remuw	a5,a1,a2
    140e:	1782                	slli	a5,a5,0x20
    1410:	9381                	srli	a5,a5,0x20
    1412:	97aa                	add	a5,a5,a0
    1414:	0007c783          	lbu	a5,0(a5)
    1418:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    141c:	0005879b          	sext.w	a5,a1
    1420:	02c5d5bb          	divuw	a1,a1,a2
    1424:	0685                	addi	a3,a3,1
    1426:	fec7f0e3          	bgeu	a5,a2,1406 <printint+0x26>
  if(neg)
    142a:	00088c63          	beqz	a7,1442 <printint+0x62>
    buf[i++] = '-';
    142e:	fd070793          	addi	a5,a4,-48
    1432:	00878733          	add	a4,a5,s0
    1436:	02d00793          	li	a5,45
    143a:	fef70823          	sb	a5,-16(a4)
    143e:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1442:	02e05a63          	blez	a4,1476 <printint+0x96>
    1446:	f04a                	sd	s2,32(sp)
    1448:	ec4e                	sd	s3,24(sp)
    144a:	fc040793          	addi	a5,s0,-64
    144e:	00e78933          	add	s2,a5,a4
    1452:	fff78993          	addi	s3,a5,-1
    1456:	99ba                	add	s3,s3,a4
    1458:	377d                	addiw	a4,a4,-1
    145a:	1702                	slli	a4,a4,0x20
    145c:	9301                	srli	a4,a4,0x20
    145e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1462:	fff94583          	lbu	a1,-1(s2)
    1466:	8526                	mv	a0,s1
    1468:	f5bff0ef          	jal	13c2 <putc>
  while(--i >= 0)
    146c:	197d                	addi	s2,s2,-1
    146e:	ff391ae3          	bne	s2,s3,1462 <printint+0x82>
    1472:	7902                	ld	s2,32(sp)
    1474:	69e2                	ld	s3,24(sp)
}
    1476:	70e2                	ld	ra,56(sp)
    1478:	7442                	ld	s0,48(sp)
    147a:	74a2                	ld	s1,40(sp)
    147c:	6121                	addi	sp,sp,64
    147e:	8082                	ret
    x = -xx;
    1480:	40b005bb          	negw	a1,a1
    neg = 1;
    1484:	4885                	li	a7,1
    x = -xx;
    1486:	bf85                	j	13f6 <printint+0x16>

0000000000001488 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1488:	711d                	addi	sp,sp,-96
    148a:	ec86                	sd	ra,88(sp)
    148c:	e8a2                	sd	s0,80(sp)
    148e:	e0ca                	sd	s2,64(sp)
    1490:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1492:	0005c903          	lbu	s2,0(a1)
    1496:	26090863          	beqz	s2,1706 <vprintf+0x27e>
    149a:	e4a6                	sd	s1,72(sp)
    149c:	fc4e                	sd	s3,56(sp)
    149e:	f852                	sd	s4,48(sp)
    14a0:	f456                	sd	s5,40(sp)
    14a2:	f05a                	sd	s6,32(sp)
    14a4:	ec5e                	sd	s7,24(sp)
    14a6:	e862                	sd	s8,16(sp)
    14a8:	e466                	sd	s9,8(sp)
    14aa:	8b2a                	mv	s6,a0
    14ac:	8a2e                	mv	s4,a1
    14ae:	8bb2                	mv	s7,a2
  state = 0;
    14b0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    14b2:	4481                	li	s1,0
    14b4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    14b6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    14ba:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    14be:	06c00c93          	li	s9,108
    14c2:	a005                	j	14e2 <vprintf+0x5a>
        putc(fd, c0);
    14c4:	85ca                	mv	a1,s2
    14c6:	855a                	mv	a0,s6
    14c8:	efbff0ef          	jal	13c2 <putc>
    14cc:	a019                	j	14d2 <vprintf+0x4a>
    } else if(state == '%'){
    14ce:	03598263          	beq	s3,s5,14f2 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    14d2:	2485                	addiw	s1,s1,1
    14d4:	8726                	mv	a4,s1
    14d6:	009a07b3          	add	a5,s4,s1
    14da:	0007c903          	lbu	s2,0(a5)
    14de:	20090c63          	beqz	s2,16f6 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    14e2:	0009079b          	sext.w	a5,s2
    if(state == 0){
    14e6:	fe0994e3          	bnez	s3,14ce <vprintf+0x46>
      if(c0 == '%'){
    14ea:	fd579de3          	bne	a5,s5,14c4 <vprintf+0x3c>
        state = '%';
    14ee:	89be                	mv	s3,a5
    14f0:	b7cd                	j	14d2 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    14f2:	00ea06b3          	add	a3,s4,a4
    14f6:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    14fa:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    14fc:	c681                	beqz	a3,1504 <vprintf+0x7c>
    14fe:	9752                	add	a4,a4,s4
    1500:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1504:	03878f63          	beq	a5,s8,1542 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1508:	05978963          	beq	a5,s9,155a <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    150c:	07500713          	li	a4,117
    1510:	0ee78363          	beq	a5,a4,15f6 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1514:	07800713          	li	a4,120
    1518:	12e78563          	beq	a5,a4,1642 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    151c:	07000713          	li	a4,112
    1520:	14e78a63          	beq	a5,a4,1674 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1524:	07300713          	li	a4,115
    1528:	18e78a63          	beq	a5,a4,16bc <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    152c:	02500713          	li	a4,37
    1530:	04e79563          	bne	a5,a4,157a <vprintf+0xf2>
        putc(fd, '%');
    1534:	02500593          	li	a1,37
    1538:	855a                	mv	a0,s6
    153a:	e89ff0ef          	jal	13c2 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    153e:	4981                	li	s3,0
    1540:	bf49                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1542:	008b8913          	addi	s2,s7,8
    1546:	4685                	li	a3,1
    1548:	4629                	li	a2,10
    154a:	000ba583          	lw	a1,0(s7)
    154e:	855a                	mv	a0,s6
    1550:	e91ff0ef          	jal	13e0 <printint>
    1554:	8bca                	mv	s7,s2
      state = 0;
    1556:	4981                	li	s3,0
    1558:	bfad                	j	14d2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    155a:	06400793          	li	a5,100
    155e:	02f68963          	beq	a3,a5,1590 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1562:	06c00793          	li	a5,108
    1566:	04f68263          	beq	a3,a5,15aa <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    156a:	07500793          	li	a5,117
    156e:	0af68063          	beq	a3,a5,160e <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1572:	07800793          	li	a5,120
    1576:	0ef68263          	beq	a3,a5,165a <vprintf+0x1d2>
        putc(fd, '%');
    157a:	02500593          	li	a1,37
    157e:	855a                	mv	a0,s6
    1580:	e43ff0ef          	jal	13c2 <putc>
        putc(fd, c0);
    1584:	85ca                	mv	a1,s2
    1586:	855a                	mv	a0,s6
    1588:	e3bff0ef          	jal	13c2 <putc>
      state = 0;
    158c:	4981                	li	s3,0
    158e:	b791                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1590:	008b8913          	addi	s2,s7,8
    1594:	4685                	li	a3,1
    1596:	4629                	li	a2,10
    1598:	000ba583          	lw	a1,0(s7)
    159c:	855a                	mv	a0,s6
    159e:	e43ff0ef          	jal	13e0 <printint>
        i += 1;
    15a2:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    15a4:	8bca                	mv	s7,s2
      state = 0;
    15a6:	4981                	li	s3,0
        i += 1;
    15a8:	b72d                	j	14d2 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15aa:	06400793          	li	a5,100
    15ae:	02f60763          	beq	a2,a5,15dc <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    15b2:	07500793          	li	a5,117
    15b6:	06f60963          	beq	a2,a5,1628 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    15ba:	07800793          	li	a5,120
    15be:	faf61ee3          	bne	a2,a5,157a <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    15c2:	008b8913          	addi	s2,s7,8
    15c6:	4681                	li	a3,0
    15c8:	4641                	li	a2,16
    15ca:	000ba583          	lw	a1,0(s7)
    15ce:	855a                	mv	a0,s6
    15d0:	e11ff0ef          	jal	13e0 <printint>
        i += 2;
    15d4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    15d6:	8bca                	mv	s7,s2
      state = 0;
    15d8:	4981                	li	s3,0
        i += 2;
    15da:	bde5                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15dc:	008b8913          	addi	s2,s7,8
    15e0:	4685                	li	a3,1
    15e2:	4629                	li	a2,10
    15e4:	000ba583          	lw	a1,0(s7)
    15e8:	855a                	mv	a0,s6
    15ea:	df7ff0ef          	jal	13e0 <printint>
        i += 2;
    15ee:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    15f0:	8bca                	mv	s7,s2
      state = 0;
    15f2:	4981                	li	s3,0
        i += 2;
    15f4:	bdf9                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    15f6:	008b8913          	addi	s2,s7,8
    15fa:	4681                	li	a3,0
    15fc:	4629                	li	a2,10
    15fe:	000ba583          	lw	a1,0(s7)
    1602:	855a                	mv	a0,s6
    1604:	dddff0ef          	jal	13e0 <printint>
    1608:	8bca                	mv	s7,s2
      state = 0;
    160a:	4981                	li	s3,0
    160c:	b5d9                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    160e:	008b8913          	addi	s2,s7,8
    1612:	4681                	li	a3,0
    1614:	4629                	li	a2,10
    1616:	000ba583          	lw	a1,0(s7)
    161a:	855a                	mv	a0,s6
    161c:	dc5ff0ef          	jal	13e0 <printint>
        i += 1;
    1620:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1622:	8bca                	mv	s7,s2
      state = 0;
    1624:	4981                	li	s3,0
        i += 1;
    1626:	b575                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1628:	008b8913          	addi	s2,s7,8
    162c:	4681                	li	a3,0
    162e:	4629                	li	a2,10
    1630:	000ba583          	lw	a1,0(s7)
    1634:	855a                	mv	a0,s6
    1636:	dabff0ef          	jal	13e0 <printint>
        i += 2;
    163a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    163c:	8bca                	mv	s7,s2
      state = 0;
    163e:	4981                	li	s3,0
        i += 2;
    1640:	bd49                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1642:	008b8913          	addi	s2,s7,8
    1646:	4681                	li	a3,0
    1648:	4641                	li	a2,16
    164a:	000ba583          	lw	a1,0(s7)
    164e:	855a                	mv	a0,s6
    1650:	d91ff0ef          	jal	13e0 <printint>
    1654:	8bca                	mv	s7,s2
      state = 0;
    1656:	4981                	li	s3,0
    1658:	bdad                	j	14d2 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    165a:	008b8913          	addi	s2,s7,8
    165e:	4681                	li	a3,0
    1660:	4641                	li	a2,16
    1662:	000ba583          	lw	a1,0(s7)
    1666:	855a                	mv	a0,s6
    1668:	d79ff0ef          	jal	13e0 <printint>
        i += 1;
    166c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    166e:	8bca                	mv	s7,s2
      state = 0;
    1670:	4981                	li	s3,0
        i += 1;
    1672:	b585                	j	14d2 <vprintf+0x4a>
    1674:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1676:	008b8d13          	addi	s10,s7,8
    167a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    167e:	03000593          	li	a1,48
    1682:	855a                	mv	a0,s6
    1684:	d3fff0ef          	jal	13c2 <putc>
  putc(fd, 'x');
    1688:	07800593          	li	a1,120
    168c:	855a                	mv	a0,s6
    168e:	d35ff0ef          	jal	13c2 <putc>
    1692:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1694:	00001b97          	auipc	s7,0x1
    1698:	9acb8b93          	addi	s7,s7,-1620 # 2040 <digits>
    169c:	03c9d793          	srli	a5,s3,0x3c
    16a0:	97de                	add	a5,a5,s7
    16a2:	0007c583          	lbu	a1,0(a5)
    16a6:	855a                	mv	a0,s6
    16a8:	d1bff0ef          	jal	13c2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    16ac:	0992                	slli	s3,s3,0x4
    16ae:	397d                	addiw	s2,s2,-1
    16b0:	fe0916e3          	bnez	s2,169c <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    16b4:	8bea                	mv	s7,s10
      state = 0;
    16b6:	4981                	li	s3,0
    16b8:	6d02                	ld	s10,0(sp)
    16ba:	bd21                	j	14d2 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    16bc:	008b8993          	addi	s3,s7,8
    16c0:	000bb903          	ld	s2,0(s7)
    16c4:	00090f63          	beqz	s2,16e2 <vprintf+0x25a>
        for(; *s; s++)
    16c8:	00094583          	lbu	a1,0(s2)
    16cc:	c195                	beqz	a1,16f0 <vprintf+0x268>
          putc(fd, *s);
    16ce:	855a                	mv	a0,s6
    16d0:	cf3ff0ef          	jal	13c2 <putc>
        for(; *s; s++)
    16d4:	0905                	addi	s2,s2,1
    16d6:	00094583          	lbu	a1,0(s2)
    16da:	f9f5                	bnez	a1,16ce <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16dc:	8bce                	mv	s7,s3
      state = 0;
    16de:	4981                	li	s3,0
    16e0:	bbcd                	j	14d2 <vprintf+0x4a>
          s = "(null)";
    16e2:	00001917          	auipc	s2,0x1
    16e6:	95690913          	addi	s2,s2,-1706 # 2038 <malloc+0x84a>
        for(; *s; s++)
    16ea:	02800593          	li	a1,40
    16ee:	b7c5                	j	16ce <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    16f0:	8bce                	mv	s7,s3
      state = 0;
    16f2:	4981                	li	s3,0
    16f4:	bbf9                	j	14d2 <vprintf+0x4a>
    16f6:	64a6                	ld	s1,72(sp)
    16f8:	79e2                	ld	s3,56(sp)
    16fa:	7a42                	ld	s4,48(sp)
    16fc:	7aa2                	ld	s5,40(sp)
    16fe:	7b02                	ld	s6,32(sp)
    1700:	6be2                	ld	s7,24(sp)
    1702:	6c42                	ld	s8,16(sp)
    1704:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1706:	60e6                	ld	ra,88(sp)
    1708:	6446                	ld	s0,80(sp)
    170a:	6906                	ld	s2,64(sp)
    170c:	6125                	addi	sp,sp,96
    170e:	8082                	ret

0000000000001710 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1710:	715d                	addi	sp,sp,-80
    1712:	ec06                	sd	ra,24(sp)
    1714:	e822                	sd	s0,16(sp)
    1716:	1000                	addi	s0,sp,32
    1718:	e010                	sd	a2,0(s0)
    171a:	e414                	sd	a3,8(s0)
    171c:	e818                	sd	a4,16(s0)
    171e:	ec1c                	sd	a5,24(s0)
    1720:	03043023          	sd	a6,32(s0)
    1724:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1728:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    172c:	8622                	mv	a2,s0
    172e:	d5bff0ef          	jal	1488 <vprintf>
}
    1732:	60e2                	ld	ra,24(sp)
    1734:	6442                	ld	s0,16(sp)
    1736:	6161                	addi	sp,sp,80
    1738:	8082                	ret

000000000000173a <printf>:

void
printf(const char *fmt, ...)
{
    173a:	711d                	addi	sp,sp,-96
    173c:	ec06                	sd	ra,24(sp)
    173e:	e822                	sd	s0,16(sp)
    1740:	1000                	addi	s0,sp,32
    1742:	e40c                	sd	a1,8(s0)
    1744:	e810                	sd	a2,16(s0)
    1746:	ec14                	sd	a3,24(s0)
    1748:	f018                	sd	a4,32(s0)
    174a:	f41c                	sd	a5,40(s0)
    174c:	03043823          	sd	a6,48(s0)
    1750:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1754:	00840613          	addi	a2,s0,8
    1758:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    175c:	85aa                	mv	a1,a0
    175e:	4505                	li	a0,1
    1760:	d29ff0ef          	jal	1488 <vprintf>
}
    1764:	60e2                	ld	ra,24(sp)
    1766:	6442                	ld	s0,16(sp)
    1768:	6125                	addi	sp,sp,96
    176a:	8082                	ret

000000000000176c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    176c:	1141                	addi	sp,sp,-16
    176e:	e422                	sd	s0,8(sp)
    1770:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1772:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1776:	00001797          	auipc	a5,0x1
    177a:	8ea7b783          	ld	a5,-1814(a5) # 2060 <freep>
    177e:	a02d                	j	17a8 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1780:	4618                	lw	a4,8(a2)
    1782:	9f2d                	addw	a4,a4,a1
    1784:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1788:	6398                	ld	a4,0(a5)
    178a:	6310                	ld	a2,0(a4)
    178c:	a83d                	j	17ca <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    178e:	ff852703          	lw	a4,-8(a0)
    1792:	9f31                	addw	a4,a4,a2
    1794:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1796:	ff053683          	ld	a3,-16(a0)
    179a:	a091                	j	17de <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    179c:	6398                	ld	a4,0(a5)
    179e:	00e7e463          	bltu	a5,a4,17a6 <free+0x3a>
    17a2:	00e6ea63          	bltu	a3,a4,17b6 <free+0x4a>
{
    17a6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17a8:	fed7fae3          	bgeu	a5,a3,179c <free+0x30>
    17ac:	6398                	ld	a4,0(a5)
    17ae:	00e6e463          	bltu	a3,a4,17b6 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17b2:	fee7eae3          	bltu	a5,a4,17a6 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    17b6:	ff852583          	lw	a1,-8(a0)
    17ba:	6390                	ld	a2,0(a5)
    17bc:	02059813          	slli	a6,a1,0x20
    17c0:	01c85713          	srli	a4,a6,0x1c
    17c4:	9736                	add	a4,a4,a3
    17c6:	fae60de3          	beq	a2,a4,1780 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    17ca:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    17ce:	4790                	lw	a2,8(a5)
    17d0:	02061593          	slli	a1,a2,0x20
    17d4:	01c5d713          	srli	a4,a1,0x1c
    17d8:	973e                	add	a4,a4,a5
    17da:	fae68ae3          	beq	a3,a4,178e <free+0x22>
    p->s.ptr = bp->s.ptr;
    17de:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    17e0:	00001717          	auipc	a4,0x1
    17e4:	88f73023          	sd	a5,-1920(a4) # 2060 <freep>
}
    17e8:	6422                	ld	s0,8(sp)
    17ea:	0141                	addi	sp,sp,16
    17ec:	8082                	ret

00000000000017ee <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    17ee:	7139                	addi	sp,sp,-64
    17f0:	fc06                	sd	ra,56(sp)
    17f2:	f822                	sd	s0,48(sp)
    17f4:	f426                	sd	s1,40(sp)
    17f6:	ec4e                	sd	s3,24(sp)
    17f8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    17fa:	02051493          	slli	s1,a0,0x20
    17fe:	9081                	srli	s1,s1,0x20
    1800:	04bd                	addi	s1,s1,15
    1802:	8091                	srli	s1,s1,0x4
    1804:	0014899b          	addiw	s3,s1,1
    1808:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    180a:	00001517          	auipc	a0,0x1
    180e:	85653503          	ld	a0,-1962(a0) # 2060 <freep>
    1812:	c915                	beqz	a0,1846 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1814:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1816:	4798                	lw	a4,8(a5)
    1818:	08977a63          	bgeu	a4,s1,18ac <malloc+0xbe>
    181c:	f04a                	sd	s2,32(sp)
    181e:	e852                	sd	s4,16(sp)
    1820:	e456                	sd	s5,8(sp)
    1822:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1824:	8a4e                	mv	s4,s3
    1826:	0009871b          	sext.w	a4,s3
    182a:	6685                	lui	a3,0x1
    182c:	00d77363          	bgeu	a4,a3,1832 <malloc+0x44>
    1830:	6a05                	lui	s4,0x1
    1832:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1836:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    183a:	00001917          	auipc	s2,0x1
    183e:	82690913          	addi	s2,s2,-2010 # 2060 <freep>
  if(p == (char*)-1)
    1842:	5afd                	li	s5,-1
    1844:	a081                	j	1884 <malloc+0x96>
    1846:	f04a                	sd	s2,32(sp)
    1848:	e852                	sd	s4,16(sp)
    184a:	e456                	sd	s5,8(sp)
    184c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    184e:	00001797          	auipc	a5,0x1
    1852:	82278793          	addi	a5,a5,-2014 # 2070 <base>
    1856:	00001717          	auipc	a4,0x1
    185a:	80f73523          	sd	a5,-2038(a4) # 2060 <freep>
    185e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1860:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1864:	b7c1                	j	1824 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1866:	6398                	ld	a4,0(a5)
    1868:	e118                	sd	a4,0(a0)
    186a:	a8a9                	j	18c4 <malloc+0xd6>
  hp->s.size = nu;
    186c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1870:	0541                	addi	a0,a0,16
    1872:	efbff0ef          	jal	176c <free>
  return freep;
    1876:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    187a:	c12d                	beqz	a0,18dc <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    187c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    187e:	4798                	lw	a4,8(a5)
    1880:	02977263          	bgeu	a4,s1,18a4 <malloc+0xb6>
    if(p == freep)
    1884:	00093703          	ld	a4,0(s2)
    1888:	853e                	mv	a0,a5
    188a:	fef719e3          	bne	a4,a5,187c <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    188e:	8552                	mv	a0,s4
    1890:	ad3ff0ef          	jal	1362 <sbrk>
  if(p == (char*)-1)
    1894:	fd551ce3          	bne	a0,s5,186c <malloc+0x7e>
        return 0;
    1898:	4501                	li	a0,0
    189a:	7902                	ld	s2,32(sp)
    189c:	6a42                	ld	s4,16(sp)
    189e:	6aa2                	ld	s5,8(sp)
    18a0:	6b02                	ld	s6,0(sp)
    18a2:	a03d                	j	18d0 <malloc+0xe2>
    18a4:	7902                	ld	s2,32(sp)
    18a6:	6a42                	ld	s4,16(sp)
    18a8:	6aa2                	ld	s5,8(sp)
    18aa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    18ac:	fae48de3          	beq	s1,a4,1866 <malloc+0x78>
        p->s.size -= nunits;
    18b0:	4137073b          	subw	a4,a4,s3
    18b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
    18b6:	02071693          	slli	a3,a4,0x20
    18ba:	01c6d713          	srli	a4,a3,0x1c
    18be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    18c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    18c4:	00000717          	auipc	a4,0x0
    18c8:	78a73e23          	sd	a0,1948(a4) # 2060 <freep>
      return (void*)(p + 1);
    18cc:	01078513          	addi	a0,a5,16
  }
}
    18d0:	70e2                	ld	ra,56(sp)
    18d2:	7442                	ld	s0,48(sp)
    18d4:	74a2                	ld	s1,40(sp)
    18d6:	69e2                	ld	s3,24(sp)
    18d8:	6121                	addi	sp,sp,64
    18da:	8082                	ret
    18dc:	7902                	ld	s2,32(sp)
    18de:	6a42                	ld	s4,16(sp)
    18e0:	6aa2                	ld	s5,8(sp)
    18e2:	6b02                	ld	s6,0(sp)
    18e4:	b7f5                	j	18d0 <malloc+0xe2>
	...
