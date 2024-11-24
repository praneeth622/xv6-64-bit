
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	e426                	sd	s1,8(sp)
    1008:	e04a                	sd	s2,0(sp)
    100a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    100c:	4589                	li	a1,2
    100e:	00001517          	auipc	a0,0x1
    1012:	ff250513          	addi	a0,a0,-14 # 2000 <malloc+0x7c6>
    1016:	350000ef          	jal	1366 <open>
    101a:	04054563          	bltz	a0,1064 <main+0x64>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
    101e:	4501                	li	a0,0
    1020:	37e000ef          	jal	139e <dup>
  dup(0);  // stderr
    1024:	4501                	li	a0,0
    1026:	378000ef          	jal	139e <dup>

  for(;;){
    printf("init: starting sh\n");
    102a:	00001917          	auipc	s2,0x1
    102e:	fde90913          	addi	s2,s2,-34 # 2008 <malloc+0x7ce>
    1032:	854a                	mv	a0,s2
    1034:	752000ef          	jal	1786 <printf>
    pid = fork();
    1038:	2e6000ef          	jal	131e <fork>
    103c:	84aa                	mv	s1,a0
    if(pid < 0){
    103e:	04054363          	bltz	a0,1084 <main+0x84>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
    1042:	c931                	beqz	a0,1096 <main+0x96>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
    1044:	4501                	li	a0,0
    1046:	2e8000ef          	jal	132e <wait>
      if(wpid == pid){
    104a:	fea484e3          	beq	s1,a0,1032 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
    104e:	fe055be3          	bgez	a0,1044 <main+0x44>
        printf("init: wait returned an error\n");
    1052:	00001517          	auipc	a0,0x1
    1056:	00650513          	addi	a0,a0,6 # 2058 <malloc+0x81e>
    105a:	72c000ef          	jal	1786 <printf>
        exit(1);
    105e:	4505                	li	a0,1
    1060:	2c6000ef          	jal	1326 <exit>
    mknod("console", CONSOLE, 0);
    1064:	4601                	li	a2,0
    1066:	4585                	li	a1,1
    1068:	00001517          	auipc	a0,0x1
    106c:	f9850513          	addi	a0,a0,-104 # 2000 <malloc+0x7c6>
    1070:	2fe000ef          	jal	136e <mknod>
    open("console", O_RDWR);
    1074:	4589                	li	a1,2
    1076:	00001517          	auipc	a0,0x1
    107a:	f8a50513          	addi	a0,a0,-118 # 2000 <malloc+0x7c6>
    107e:	2e8000ef          	jal	1366 <open>
    1082:	bf71                	j	101e <main+0x1e>
      printf("init: fork failed\n");
    1084:	00001517          	auipc	a0,0x1
    1088:	f9c50513          	addi	a0,a0,-100 # 2020 <malloc+0x7e6>
    108c:	6fa000ef          	jal	1786 <printf>
      exit(1);
    1090:	4505                	li	a0,1
    1092:	294000ef          	jal	1326 <exit>
      exec("sh", argv);
    1096:	00001597          	auipc	a1,0x1
    109a:	00a58593          	addi	a1,a1,10 # 20a0 <argv>
    109e:	00001517          	auipc	a0,0x1
    10a2:	f9a50513          	addi	a0,a0,-102 # 2038 <malloc+0x7fe>
    10a6:	2b8000ef          	jal	135e <exec>
      printf("init: exec sh failed\n");
    10aa:	00001517          	auipc	a0,0x1
    10ae:	f9650513          	addi	a0,a0,-106 # 2040 <malloc+0x806>
    10b2:	6d4000ef          	jal	1786 <printf>
      exit(1);
    10b6:	4505                	li	a0,1
    10b8:	26e000ef          	jal	1326 <exit>

00000000000010bc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    10bc:	1141                	addi	sp,sp,-16
    10be:	e406                	sd	ra,8(sp)
    10c0:	e022                	sd	s0,0(sp)
    10c2:	0800                	addi	s0,sp,16
  extern int main();
  main();
    10c4:	f3dff0ef          	jal	1000 <main>
  exit(0);
    10c8:	4501                	li	a0,0
    10ca:	25c000ef          	jal	1326 <exit>

00000000000010ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    10ce:	1141                	addi	sp,sp,-16
    10d0:	e422                	sd	s0,8(sp)
    10d2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10d4:	87aa                	mv	a5,a0
    10d6:	0585                	addi	a1,a1,1
    10d8:	0785                	addi	a5,a5,1
    10da:	fff5c703          	lbu	a4,-1(a1)
    10de:	fee78fa3          	sb	a4,-1(a5)
    10e2:	fb75                	bnez	a4,10d6 <strcpy+0x8>
    ;
  return os;
}
    10e4:	6422                	ld	s0,8(sp)
    10e6:	0141                	addi	sp,sp,16
    10e8:	8082                	ret

00000000000010ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10ea:	1141                	addi	sp,sp,-16
    10ec:	e422                	sd	s0,8(sp)
    10ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    10f0:	00054783          	lbu	a5,0(a0)
    10f4:	cb91                	beqz	a5,1108 <strcmp+0x1e>
    10f6:	0005c703          	lbu	a4,0(a1)
    10fa:	00f71763          	bne	a4,a5,1108 <strcmp+0x1e>
    p++, q++;
    10fe:	0505                	addi	a0,a0,1
    1100:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1102:	00054783          	lbu	a5,0(a0)
    1106:	fbe5                	bnez	a5,10f6 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1108:	0005c503          	lbu	a0,0(a1)
}
    110c:	40a7853b          	subw	a0,a5,a0
    1110:	6422                	ld	s0,8(sp)
    1112:	0141                	addi	sp,sp,16
    1114:	8082                	ret

0000000000001116 <strlen>:

uint
strlen(const char *s)
{
    1116:	1141                	addi	sp,sp,-16
    1118:	e422                	sd	s0,8(sp)
    111a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    111c:	00054783          	lbu	a5,0(a0)
    1120:	cf91                	beqz	a5,113c <strlen+0x26>
    1122:	0505                	addi	a0,a0,1
    1124:	87aa                	mv	a5,a0
    1126:	86be                	mv	a3,a5
    1128:	0785                	addi	a5,a5,1
    112a:	fff7c703          	lbu	a4,-1(a5)
    112e:	ff65                	bnez	a4,1126 <strlen+0x10>
    1130:	40a6853b          	subw	a0,a3,a0
    1134:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    1136:	6422                	ld	s0,8(sp)
    1138:	0141                	addi	sp,sp,16
    113a:	8082                	ret
  for(n = 0; s[n]; n++)
    113c:	4501                	li	a0,0
    113e:	bfe5                	j	1136 <strlen+0x20>

0000000000001140 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1140:	1141                	addi	sp,sp,-16
    1142:	e422                	sd	s0,8(sp)
    1144:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1146:	ca19                	beqz	a2,115c <memset+0x1c>
    1148:	87aa                	mv	a5,a0
    114a:	1602                	slli	a2,a2,0x20
    114c:	9201                	srli	a2,a2,0x20
    114e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1152:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1156:	0785                	addi	a5,a5,1
    1158:	fee79de3          	bne	a5,a4,1152 <memset+0x12>
  }
  return dst;
}
    115c:	6422                	ld	s0,8(sp)
    115e:	0141                	addi	sp,sp,16
    1160:	8082                	ret

0000000000001162 <strchr>:

char*
strchr(const char *s, char c)
{
    1162:	1141                	addi	sp,sp,-16
    1164:	e422                	sd	s0,8(sp)
    1166:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1168:	00054783          	lbu	a5,0(a0)
    116c:	cb99                	beqz	a5,1182 <strchr+0x20>
    if(*s == c)
    116e:	00f58763          	beq	a1,a5,117c <strchr+0x1a>
  for(; *s; s++)
    1172:	0505                	addi	a0,a0,1
    1174:	00054783          	lbu	a5,0(a0)
    1178:	fbfd                	bnez	a5,116e <strchr+0xc>
      return (char*)s;
  return 0;
    117a:	4501                	li	a0,0
}
    117c:	6422                	ld	s0,8(sp)
    117e:	0141                	addi	sp,sp,16
    1180:	8082                	ret
  return 0;
    1182:	4501                	li	a0,0
    1184:	bfe5                	j	117c <strchr+0x1a>

0000000000001186 <gets>:

char*
gets(char *buf, int max)
{
    1186:	711d                	addi	sp,sp,-96
    1188:	ec86                	sd	ra,88(sp)
    118a:	e8a2                	sd	s0,80(sp)
    118c:	e4a6                	sd	s1,72(sp)
    118e:	e0ca                	sd	s2,64(sp)
    1190:	fc4e                	sd	s3,56(sp)
    1192:	f852                	sd	s4,48(sp)
    1194:	f456                	sd	s5,40(sp)
    1196:	f05a                	sd	s6,32(sp)
    1198:	ec5e                	sd	s7,24(sp)
    119a:	1080                	addi	s0,sp,96
    119c:	8baa                	mv	s7,a0
    119e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11a0:	892a                	mv	s2,a0
    11a2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    11a4:	4aa9                	li	s5,10
    11a6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    11a8:	89a6                	mv	s3,s1
    11aa:	2485                	addiw	s1,s1,1
    11ac:	0344d663          	bge	s1,s4,11d8 <gets+0x52>
    cc = read(0, &c, 1);
    11b0:	4605                	li	a2,1
    11b2:	faf40593          	addi	a1,s0,-81
    11b6:	4501                	li	a0,0
    11b8:	186000ef          	jal	133e <read>
    if(cc < 1)
    11bc:	00a05e63          	blez	a0,11d8 <gets+0x52>
    buf[i++] = c;
    11c0:	faf44783          	lbu	a5,-81(s0)
    11c4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    11c8:	01578763          	beq	a5,s5,11d6 <gets+0x50>
    11cc:	0905                	addi	s2,s2,1
    11ce:	fd679de3          	bne	a5,s6,11a8 <gets+0x22>
    buf[i++] = c;
    11d2:	89a6                	mv	s3,s1
    11d4:	a011                	j	11d8 <gets+0x52>
    11d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    11d8:	99de                	add	s3,s3,s7
    11da:	00098023          	sb	zero,0(s3)
  return buf;
}
    11de:	855e                	mv	a0,s7
    11e0:	60e6                	ld	ra,88(sp)
    11e2:	6446                	ld	s0,80(sp)
    11e4:	64a6                	ld	s1,72(sp)
    11e6:	6906                	ld	s2,64(sp)
    11e8:	79e2                	ld	s3,56(sp)
    11ea:	7a42                	ld	s4,48(sp)
    11ec:	7aa2                	ld	s5,40(sp)
    11ee:	7b02                	ld	s6,32(sp)
    11f0:	6be2                	ld	s7,24(sp)
    11f2:	6125                	addi	sp,sp,96
    11f4:	8082                	ret

00000000000011f6 <stat>:

int
stat(const char *n, struct stat *st)
{
    11f6:	1101                	addi	sp,sp,-32
    11f8:	ec06                	sd	ra,24(sp)
    11fa:	e822                	sd	s0,16(sp)
    11fc:	e04a                	sd	s2,0(sp)
    11fe:	1000                	addi	s0,sp,32
    1200:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1202:	4581                	li	a1,0
    1204:	162000ef          	jal	1366 <open>
  if(fd < 0)
    1208:	02054263          	bltz	a0,122c <stat+0x36>
    120c:	e426                	sd	s1,8(sp)
    120e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1210:	85ca                	mv	a1,s2
    1212:	16c000ef          	jal	137e <fstat>
    1216:	892a                	mv	s2,a0
  close(fd);
    1218:	8526                	mv	a0,s1
    121a:	134000ef          	jal	134e <close>
  return r;
    121e:	64a2                	ld	s1,8(sp)
}
    1220:	854a                	mv	a0,s2
    1222:	60e2                	ld	ra,24(sp)
    1224:	6442                	ld	s0,16(sp)
    1226:	6902                	ld	s2,0(sp)
    1228:	6105                	addi	sp,sp,32
    122a:	8082                	ret
    return -1;
    122c:	597d                	li	s2,-1
    122e:	bfcd                	j	1220 <stat+0x2a>

0000000000001230 <atoi>:

int
atoi(const char *s)
{
    1230:	1141                	addi	sp,sp,-16
    1232:	e422                	sd	s0,8(sp)
    1234:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1236:	00054683          	lbu	a3,0(a0)
    123a:	fd06879b          	addiw	a5,a3,-48
    123e:	0ff7f793          	zext.b	a5,a5
    1242:	4625                	li	a2,9
    1244:	02f66863          	bltu	a2,a5,1274 <atoi+0x44>
    1248:	872a                	mv	a4,a0
  n = 0;
    124a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    124c:	0705                	addi	a4,a4,1
    124e:	0025179b          	slliw	a5,a0,0x2
    1252:	9fa9                	addw	a5,a5,a0
    1254:	0017979b          	slliw	a5,a5,0x1
    1258:	9fb5                	addw	a5,a5,a3
    125a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    125e:	00074683          	lbu	a3,0(a4)
    1262:	fd06879b          	addiw	a5,a3,-48
    1266:	0ff7f793          	zext.b	a5,a5
    126a:	fef671e3          	bgeu	a2,a5,124c <atoi+0x1c>
  return n;
}
    126e:	6422                	ld	s0,8(sp)
    1270:	0141                	addi	sp,sp,16
    1272:	8082                	ret
  n = 0;
    1274:	4501                	li	a0,0
    1276:	bfe5                	j	126e <atoi+0x3e>

0000000000001278 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1278:	1141                	addi	sp,sp,-16
    127a:	e422                	sd	s0,8(sp)
    127c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    127e:	02b57463          	bgeu	a0,a1,12a6 <memmove+0x2e>
    while(n-- > 0)
    1282:	00c05f63          	blez	a2,12a0 <memmove+0x28>
    1286:	1602                	slli	a2,a2,0x20
    1288:	9201                	srli	a2,a2,0x20
    128a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    128e:	872a                	mv	a4,a0
      *dst++ = *src++;
    1290:	0585                	addi	a1,a1,1
    1292:	0705                	addi	a4,a4,1
    1294:	fff5c683          	lbu	a3,-1(a1)
    1298:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    129c:	fef71ae3          	bne	a4,a5,1290 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    12a0:	6422                	ld	s0,8(sp)
    12a2:	0141                	addi	sp,sp,16
    12a4:	8082                	ret
    dst += n;
    12a6:	00c50733          	add	a4,a0,a2
    src += n;
    12aa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    12ac:	fec05ae3          	blez	a2,12a0 <memmove+0x28>
    12b0:	fff6079b          	addiw	a5,a2,-1
    12b4:	1782                	slli	a5,a5,0x20
    12b6:	9381                	srli	a5,a5,0x20
    12b8:	fff7c793          	not	a5,a5
    12bc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    12be:	15fd                	addi	a1,a1,-1
    12c0:	177d                	addi	a4,a4,-1
    12c2:	0005c683          	lbu	a3,0(a1)
    12c6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    12ca:	fee79ae3          	bne	a5,a4,12be <memmove+0x46>
    12ce:	bfc9                	j	12a0 <memmove+0x28>

00000000000012d0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    12d0:	1141                	addi	sp,sp,-16
    12d2:	e422                	sd	s0,8(sp)
    12d4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    12d6:	ca05                	beqz	a2,1306 <memcmp+0x36>
    12d8:	fff6069b          	addiw	a3,a2,-1
    12dc:	1682                	slli	a3,a3,0x20
    12de:	9281                	srli	a3,a3,0x20
    12e0:	0685                	addi	a3,a3,1
    12e2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    12e4:	00054783          	lbu	a5,0(a0)
    12e8:	0005c703          	lbu	a4,0(a1)
    12ec:	00e79863          	bne	a5,a4,12fc <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    12f0:	0505                	addi	a0,a0,1
    p2++;
    12f2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    12f4:	fed518e3          	bne	a0,a3,12e4 <memcmp+0x14>
  }
  return 0;
    12f8:	4501                	li	a0,0
    12fa:	a019                	j	1300 <memcmp+0x30>
      return *p1 - *p2;
    12fc:	40e7853b          	subw	a0,a5,a4
}
    1300:	6422                	ld	s0,8(sp)
    1302:	0141                	addi	sp,sp,16
    1304:	8082                	ret
  return 0;
    1306:	4501                	li	a0,0
    1308:	bfe5                	j	1300 <memcmp+0x30>

000000000000130a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    130a:	1141                	addi	sp,sp,-16
    130c:	e406                	sd	ra,8(sp)
    130e:	e022                	sd	s0,0(sp)
    1310:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1312:	f67ff0ef          	jal	1278 <memmove>
}
    1316:	60a2                	ld	ra,8(sp)
    1318:	6402                	ld	s0,0(sp)
    131a:	0141                	addi	sp,sp,16
    131c:	8082                	ret

000000000000131e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    131e:	4885                	li	a7,1
 ecall
    1320:	00000073          	ecall
 ret
    1324:	8082                	ret

0000000000001326 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1326:	4889                	li	a7,2
 ecall
    1328:	00000073          	ecall
 ret
    132c:	8082                	ret

000000000000132e <wait>:
.global wait
wait:
 li a7, SYS_wait
    132e:	488d                	li	a7,3
 ecall
    1330:	00000073          	ecall
 ret
    1334:	8082                	ret

0000000000001336 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1336:	4891                	li	a7,4
 ecall
    1338:	00000073          	ecall
 ret
    133c:	8082                	ret

000000000000133e <read>:
.global read
read:
 li a7, SYS_read
    133e:	4895                	li	a7,5
 ecall
    1340:	00000073          	ecall
 ret
    1344:	8082                	ret

0000000000001346 <write>:
.global write
write:
 li a7, SYS_write
    1346:	48c1                	li	a7,16
 ecall
    1348:	00000073          	ecall
 ret
    134c:	8082                	ret

000000000000134e <close>:
.global close
close:
 li a7, SYS_close
    134e:	48d5                	li	a7,21
 ecall
    1350:	00000073          	ecall
 ret
    1354:	8082                	ret

0000000000001356 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1356:	4899                	li	a7,6
 ecall
    1358:	00000073          	ecall
 ret
    135c:	8082                	ret

000000000000135e <exec>:
.global exec
exec:
 li a7, SYS_exec
    135e:	489d                	li	a7,7
 ecall
    1360:	00000073          	ecall
 ret
    1364:	8082                	ret

0000000000001366 <open>:
.global open
open:
 li a7, SYS_open
    1366:	48bd                	li	a7,15
 ecall
    1368:	00000073          	ecall
 ret
    136c:	8082                	ret

000000000000136e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    136e:	48c5                	li	a7,17
 ecall
    1370:	00000073          	ecall
 ret
    1374:	8082                	ret

0000000000001376 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1376:	48c9                	li	a7,18
 ecall
    1378:	00000073          	ecall
 ret
    137c:	8082                	ret

000000000000137e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    137e:	48a1                	li	a7,8
 ecall
    1380:	00000073          	ecall
 ret
    1384:	8082                	ret

0000000000001386 <link>:
.global link
link:
 li a7, SYS_link
    1386:	48cd                	li	a7,19
 ecall
    1388:	00000073          	ecall
 ret
    138c:	8082                	ret

000000000000138e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    138e:	48d1                	li	a7,20
 ecall
    1390:	00000073          	ecall
 ret
    1394:	8082                	ret

0000000000001396 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1396:	48a5                	li	a7,9
 ecall
    1398:	00000073          	ecall
 ret
    139c:	8082                	ret

000000000000139e <dup>:
.global dup
dup:
 li a7, SYS_dup
    139e:	48a9                	li	a7,10
 ecall
    13a0:	00000073          	ecall
 ret
    13a4:	8082                	ret

00000000000013a6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    13a6:	48ad                	li	a7,11
 ecall
    13a8:	00000073          	ecall
 ret
    13ac:	8082                	ret

00000000000013ae <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    13ae:	48b1                	li	a7,12
 ecall
    13b0:	00000073          	ecall
 ret
    13b4:	8082                	ret

00000000000013b6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    13b6:	48b5                	li	a7,13
 ecall
    13b8:	00000073          	ecall
 ret
    13bc:	8082                	ret

00000000000013be <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    13be:	48b9                	li	a7,14
 ecall
    13c0:	00000073          	ecall
 ret
    13c4:	8082                	ret

00000000000013c6 <cps>:
.global cps
cps:
 li a7, SYS_cps
    13c6:	48d9                	li	a7,22
 ecall
    13c8:	00000073          	ecall
 ret
    13cc:	8082                	ret

00000000000013ce <signal>:
.global signal
signal:
 li a7, SYS_signal
    13ce:	48dd                	li	a7,23
 ecall
    13d0:	00000073          	ecall
 ret
    13d4:	8082                	ret

00000000000013d6 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    13d6:	48e1                	li	a7,24
 ecall
    13d8:	00000073          	ecall
 ret
    13dc:	8082                	ret

00000000000013de <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    13de:	48e5                	li	a7,25
 ecall
    13e0:	00000073          	ecall
 ret
    13e4:	8082                	ret

00000000000013e6 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    13e6:	48e9                	li	a7,26
 ecall
    13e8:	00000073          	ecall
 ret
    13ec:	8082                	ret

00000000000013ee <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    13ee:	48ed                	li	a7,27
 ecall
    13f0:	00000073          	ecall
 ret
    13f4:	8082                	ret

00000000000013f6 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    13f6:	48f1                	li	a7,28
 ecall
    13f8:	00000073          	ecall
 ret
    13fc:	8082                	ret

00000000000013fe <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    13fe:	48f5                	li	a7,29
 ecall
    1400:	00000073          	ecall
 ret
    1404:	8082                	ret

0000000000001406 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1406:	48f9                	li	a7,30
 ecall
    1408:	00000073          	ecall
 ret
    140c:	8082                	ret

000000000000140e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    140e:	1101                	addi	sp,sp,-32
    1410:	ec06                	sd	ra,24(sp)
    1412:	e822                	sd	s0,16(sp)
    1414:	1000                	addi	s0,sp,32
    1416:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    141a:	4605                	li	a2,1
    141c:	fef40593          	addi	a1,s0,-17
    1420:	f27ff0ef          	jal	1346 <write>
}
    1424:	60e2                	ld	ra,24(sp)
    1426:	6442                	ld	s0,16(sp)
    1428:	6105                	addi	sp,sp,32
    142a:	8082                	ret

000000000000142c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    142c:	7139                	addi	sp,sp,-64
    142e:	fc06                	sd	ra,56(sp)
    1430:	f822                	sd	s0,48(sp)
    1432:	f426                	sd	s1,40(sp)
    1434:	0080                	addi	s0,sp,64
    1436:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1438:	c299                	beqz	a3,143e <printint+0x12>
    143a:	0805c963          	bltz	a1,14cc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    143e:	2581                	sext.w	a1,a1
  neg = 0;
    1440:	4881                	li	a7,0
    1442:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1446:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1448:	2601                	sext.w	a2,a2
    144a:	00001517          	auipc	a0,0x1
    144e:	c3650513          	addi	a0,a0,-970 # 2080 <digits>
    1452:	883a                	mv	a6,a4
    1454:	2705                	addiw	a4,a4,1
    1456:	02c5f7bb          	remuw	a5,a1,a2
    145a:	1782                	slli	a5,a5,0x20
    145c:	9381                	srli	a5,a5,0x20
    145e:	97aa                	add	a5,a5,a0
    1460:	0007c783          	lbu	a5,0(a5)
    1464:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1468:	0005879b          	sext.w	a5,a1
    146c:	02c5d5bb          	divuw	a1,a1,a2
    1470:	0685                	addi	a3,a3,1
    1472:	fec7f0e3          	bgeu	a5,a2,1452 <printint+0x26>
  if(neg)
    1476:	00088c63          	beqz	a7,148e <printint+0x62>
    buf[i++] = '-';
    147a:	fd070793          	addi	a5,a4,-48
    147e:	00878733          	add	a4,a5,s0
    1482:	02d00793          	li	a5,45
    1486:	fef70823          	sb	a5,-16(a4)
    148a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    148e:	02e05a63          	blez	a4,14c2 <printint+0x96>
    1492:	f04a                	sd	s2,32(sp)
    1494:	ec4e                	sd	s3,24(sp)
    1496:	fc040793          	addi	a5,s0,-64
    149a:	00e78933          	add	s2,a5,a4
    149e:	fff78993          	addi	s3,a5,-1
    14a2:	99ba                	add	s3,s3,a4
    14a4:	377d                	addiw	a4,a4,-1
    14a6:	1702                	slli	a4,a4,0x20
    14a8:	9301                	srli	a4,a4,0x20
    14aa:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    14ae:	fff94583          	lbu	a1,-1(s2)
    14b2:	8526                	mv	a0,s1
    14b4:	f5bff0ef          	jal	140e <putc>
  while(--i >= 0)
    14b8:	197d                	addi	s2,s2,-1
    14ba:	ff391ae3          	bne	s2,s3,14ae <printint+0x82>
    14be:	7902                	ld	s2,32(sp)
    14c0:	69e2                	ld	s3,24(sp)
}
    14c2:	70e2                	ld	ra,56(sp)
    14c4:	7442                	ld	s0,48(sp)
    14c6:	74a2                	ld	s1,40(sp)
    14c8:	6121                	addi	sp,sp,64
    14ca:	8082                	ret
    x = -xx;
    14cc:	40b005bb          	negw	a1,a1
    neg = 1;
    14d0:	4885                	li	a7,1
    x = -xx;
    14d2:	bf85                	j	1442 <printint+0x16>

00000000000014d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    14d4:	711d                	addi	sp,sp,-96
    14d6:	ec86                	sd	ra,88(sp)
    14d8:	e8a2                	sd	s0,80(sp)
    14da:	e0ca                	sd	s2,64(sp)
    14dc:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    14de:	0005c903          	lbu	s2,0(a1)
    14e2:	26090863          	beqz	s2,1752 <vprintf+0x27e>
    14e6:	e4a6                	sd	s1,72(sp)
    14e8:	fc4e                	sd	s3,56(sp)
    14ea:	f852                	sd	s4,48(sp)
    14ec:	f456                	sd	s5,40(sp)
    14ee:	f05a                	sd	s6,32(sp)
    14f0:	ec5e                	sd	s7,24(sp)
    14f2:	e862                	sd	s8,16(sp)
    14f4:	e466                	sd	s9,8(sp)
    14f6:	8b2a                	mv	s6,a0
    14f8:	8a2e                	mv	s4,a1
    14fa:	8bb2                	mv	s7,a2
  state = 0;
    14fc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    14fe:	4481                	li	s1,0
    1500:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1502:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1506:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    150a:	06c00c93          	li	s9,108
    150e:	a005                	j	152e <vprintf+0x5a>
        putc(fd, c0);
    1510:	85ca                	mv	a1,s2
    1512:	855a                	mv	a0,s6
    1514:	efbff0ef          	jal	140e <putc>
    1518:	a019                	j	151e <vprintf+0x4a>
    } else if(state == '%'){
    151a:	03598263          	beq	s3,s5,153e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    151e:	2485                	addiw	s1,s1,1
    1520:	8726                	mv	a4,s1
    1522:	009a07b3          	add	a5,s4,s1
    1526:	0007c903          	lbu	s2,0(a5)
    152a:	20090c63          	beqz	s2,1742 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    152e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1532:	fe0994e3          	bnez	s3,151a <vprintf+0x46>
      if(c0 == '%'){
    1536:	fd579de3          	bne	a5,s5,1510 <vprintf+0x3c>
        state = '%';
    153a:	89be                	mv	s3,a5
    153c:	b7cd                	j	151e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    153e:	00ea06b3          	add	a3,s4,a4
    1542:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1546:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1548:	c681                	beqz	a3,1550 <vprintf+0x7c>
    154a:	9752                	add	a4,a4,s4
    154c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1550:	03878f63          	beq	a5,s8,158e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1554:	05978963          	beq	a5,s9,15a6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1558:	07500713          	li	a4,117
    155c:	0ee78363          	beq	a5,a4,1642 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1560:	07800713          	li	a4,120
    1564:	12e78563          	beq	a5,a4,168e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1568:	07000713          	li	a4,112
    156c:	14e78a63          	beq	a5,a4,16c0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1570:	07300713          	li	a4,115
    1574:	18e78a63          	beq	a5,a4,1708 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1578:	02500713          	li	a4,37
    157c:	04e79563          	bne	a5,a4,15c6 <vprintf+0xf2>
        putc(fd, '%');
    1580:	02500593          	li	a1,37
    1584:	855a                	mv	a0,s6
    1586:	e89ff0ef          	jal	140e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    158a:	4981                	li	s3,0
    158c:	bf49                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    158e:	008b8913          	addi	s2,s7,8
    1592:	4685                	li	a3,1
    1594:	4629                	li	a2,10
    1596:	000ba583          	lw	a1,0(s7)
    159a:	855a                	mv	a0,s6
    159c:	e91ff0ef          	jal	142c <printint>
    15a0:	8bca                	mv	s7,s2
      state = 0;
    15a2:	4981                	li	s3,0
    15a4:	bfad                	j	151e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    15a6:	06400793          	li	a5,100
    15aa:	02f68963          	beq	a3,a5,15dc <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15ae:	06c00793          	li	a5,108
    15b2:	04f68263          	beq	a3,a5,15f6 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    15b6:	07500793          	li	a5,117
    15ba:	0af68063          	beq	a3,a5,165a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    15be:	07800793          	li	a5,120
    15c2:	0ef68263          	beq	a3,a5,16a6 <vprintf+0x1d2>
        putc(fd, '%');
    15c6:	02500593          	li	a1,37
    15ca:	855a                	mv	a0,s6
    15cc:	e43ff0ef          	jal	140e <putc>
        putc(fd, c0);
    15d0:	85ca                	mv	a1,s2
    15d2:	855a                	mv	a0,s6
    15d4:	e3bff0ef          	jal	140e <putc>
      state = 0;
    15d8:	4981                	li	s3,0
    15da:	b791                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15dc:	008b8913          	addi	s2,s7,8
    15e0:	4685                	li	a3,1
    15e2:	4629                	li	a2,10
    15e4:	000ba583          	lw	a1,0(s7)
    15e8:	855a                	mv	a0,s6
    15ea:	e43ff0ef          	jal	142c <printint>
        i += 1;
    15ee:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    15f0:	8bca                	mv	s7,s2
      state = 0;
    15f2:	4981                	li	s3,0
        i += 1;
    15f4:	b72d                	j	151e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15f6:	06400793          	li	a5,100
    15fa:	02f60763          	beq	a2,a5,1628 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    15fe:	07500793          	li	a5,117
    1602:	06f60963          	beq	a2,a5,1674 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1606:	07800793          	li	a5,120
    160a:	faf61ee3          	bne	a2,a5,15c6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    160e:	008b8913          	addi	s2,s7,8
    1612:	4681                	li	a3,0
    1614:	4641                	li	a2,16
    1616:	000ba583          	lw	a1,0(s7)
    161a:	855a                	mv	a0,s6
    161c:	e11ff0ef          	jal	142c <printint>
        i += 2;
    1620:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1622:	8bca                	mv	s7,s2
      state = 0;
    1624:	4981                	li	s3,0
        i += 2;
    1626:	bde5                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1628:	008b8913          	addi	s2,s7,8
    162c:	4685                	li	a3,1
    162e:	4629                	li	a2,10
    1630:	000ba583          	lw	a1,0(s7)
    1634:	855a                	mv	a0,s6
    1636:	df7ff0ef          	jal	142c <printint>
        i += 2;
    163a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    163c:	8bca                	mv	s7,s2
      state = 0;
    163e:	4981                	li	s3,0
        i += 2;
    1640:	bdf9                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1642:	008b8913          	addi	s2,s7,8
    1646:	4681                	li	a3,0
    1648:	4629                	li	a2,10
    164a:	000ba583          	lw	a1,0(s7)
    164e:	855a                	mv	a0,s6
    1650:	dddff0ef          	jal	142c <printint>
    1654:	8bca                	mv	s7,s2
      state = 0;
    1656:	4981                	li	s3,0
    1658:	b5d9                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    165a:	008b8913          	addi	s2,s7,8
    165e:	4681                	li	a3,0
    1660:	4629                	li	a2,10
    1662:	000ba583          	lw	a1,0(s7)
    1666:	855a                	mv	a0,s6
    1668:	dc5ff0ef          	jal	142c <printint>
        i += 1;
    166c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    166e:	8bca                	mv	s7,s2
      state = 0;
    1670:	4981                	li	s3,0
        i += 1;
    1672:	b575                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1674:	008b8913          	addi	s2,s7,8
    1678:	4681                	li	a3,0
    167a:	4629                	li	a2,10
    167c:	000ba583          	lw	a1,0(s7)
    1680:	855a                	mv	a0,s6
    1682:	dabff0ef          	jal	142c <printint>
        i += 2;
    1686:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1688:	8bca                	mv	s7,s2
      state = 0;
    168a:	4981                	li	s3,0
        i += 2;
    168c:	bd49                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    168e:	008b8913          	addi	s2,s7,8
    1692:	4681                	li	a3,0
    1694:	4641                	li	a2,16
    1696:	000ba583          	lw	a1,0(s7)
    169a:	855a                	mv	a0,s6
    169c:	d91ff0ef          	jal	142c <printint>
    16a0:	8bca                	mv	s7,s2
      state = 0;
    16a2:	4981                	li	s3,0
    16a4:	bdad                	j	151e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    16a6:	008b8913          	addi	s2,s7,8
    16aa:	4681                	li	a3,0
    16ac:	4641                	li	a2,16
    16ae:	000ba583          	lw	a1,0(s7)
    16b2:	855a                	mv	a0,s6
    16b4:	d79ff0ef          	jal	142c <printint>
        i += 1;
    16b8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    16ba:	8bca                	mv	s7,s2
      state = 0;
    16bc:	4981                	li	s3,0
        i += 1;
    16be:	b585                	j	151e <vprintf+0x4a>
    16c0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    16c2:	008b8d13          	addi	s10,s7,8
    16c6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    16ca:	03000593          	li	a1,48
    16ce:	855a                	mv	a0,s6
    16d0:	d3fff0ef          	jal	140e <putc>
  putc(fd, 'x');
    16d4:	07800593          	li	a1,120
    16d8:	855a                	mv	a0,s6
    16da:	d35ff0ef          	jal	140e <putc>
    16de:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    16e0:	00001b97          	auipc	s7,0x1
    16e4:	9a0b8b93          	addi	s7,s7,-1632 # 2080 <digits>
    16e8:	03c9d793          	srli	a5,s3,0x3c
    16ec:	97de                	add	a5,a5,s7
    16ee:	0007c583          	lbu	a1,0(a5)
    16f2:	855a                	mv	a0,s6
    16f4:	d1bff0ef          	jal	140e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    16f8:	0992                	slli	s3,s3,0x4
    16fa:	397d                	addiw	s2,s2,-1
    16fc:	fe0916e3          	bnez	s2,16e8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1700:	8bea                	mv	s7,s10
      state = 0;
    1702:	4981                	li	s3,0
    1704:	6d02                	ld	s10,0(sp)
    1706:	bd21                	j	151e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1708:	008b8993          	addi	s3,s7,8
    170c:	000bb903          	ld	s2,0(s7)
    1710:	00090f63          	beqz	s2,172e <vprintf+0x25a>
        for(; *s; s++)
    1714:	00094583          	lbu	a1,0(s2)
    1718:	c195                	beqz	a1,173c <vprintf+0x268>
          putc(fd, *s);
    171a:	855a                	mv	a0,s6
    171c:	cf3ff0ef          	jal	140e <putc>
        for(; *s; s++)
    1720:	0905                	addi	s2,s2,1
    1722:	00094583          	lbu	a1,0(s2)
    1726:	f9f5                	bnez	a1,171a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1728:	8bce                	mv	s7,s3
      state = 0;
    172a:	4981                	li	s3,0
    172c:	bbcd                	j	151e <vprintf+0x4a>
          s = "(null)";
    172e:	00001917          	auipc	s2,0x1
    1732:	94a90913          	addi	s2,s2,-1718 # 2078 <malloc+0x83e>
        for(; *s; s++)
    1736:	02800593          	li	a1,40
    173a:	b7c5                	j	171a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    173c:	8bce                	mv	s7,s3
      state = 0;
    173e:	4981                	li	s3,0
    1740:	bbf9                	j	151e <vprintf+0x4a>
    1742:	64a6                	ld	s1,72(sp)
    1744:	79e2                	ld	s3,56(sp)
    1746:	7a42                	ld	s4,48(sp)
    1748:	7aa2                	ld	s5,40(sp)
    174a:	7b02                	ld	s6,32(sp)
    174c:	6be2                	ld	s7,24(sp)
    174e:	6c42                	ld	s8,16(sp)
    1750:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1752:	60e6                	ld	ra,88(sp)
    1754:	6446                	ld	s0,80(sp)
    1756:	6906                	ld	s2,64(sp)
    1758:	6125                	addi	sp,sp,96
    175a:	8082                	ret

000000000000175c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    175c:	715d                	addi	sp,sp,-80
    175e:	ec06                	sd	ra,24(sp)
    1760:	e822                	sd	s0,16(sp)
    1762:	1000                	addi	s0,sp,32
    1764:	e010                	sd	a2,0(s0)
    1766:	e414                	sd	a3,8(s0)
    1768:	e818                	sd	a4,16(s0)
    176a:	ec1c                	sd	a5,24(s0)
    176c:	03043023          	sd	a6,32(s0)
    1770:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1774:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1778:	8622                	mv	a2,s0
    177a:	d5bff0ef          	jal	14d4 <vprintf>
}
    177e:	60e2                	ld	ra,24(sp)
    1780:	6442                	ld	s0,16(sp)
    1782:	6161                	addi	sp,sp,80
    1784:	8082                	ret

0000000000001786 <printf>:

void
printf(const char *fmt, ...)
{
    1786:	711d                	addi	sp,sp,-96
    1788:	ec06                	sd	ra,24(sp)
    178a:	e822                	sd	s0,16(sp)
    178c:	1000                	addi	s0,sp,32
    178e:	e40c                	sd	a1,8(s0)
    1790:	e810                	sd	a2,16(s0)
    1792:	ec14                	sd	a3,24(s0)
    1794:	f018                	sd	a4,32(s0)
    1796:	f41c                	sd	a5,40(s0)
    1798:	03043823          	sd	a6,48(s0)
    179c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    17a0:	00840613          	addi	a2,s0,8
    17a4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    17a8:	85aa                	mv	a1,a0
    17aa:	4505                	li	a0,1
    17ac:	d29ff0ef          	jal	14d4 <vprintf>
}
    17b0:	60e2                	ld	ra,24(sp)
    17b2:	6442                	ld	s0,16(sp)
    17b4:	6125                	addi	sp,sp,96
    17b6:	8082                	ret

00000000000017b8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17b8:	1141                	addi	sp,sp,-16
    17ba:	e422                	sd	s0,8(sp)
    17bc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17be:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17c2:	00001797          	auipc	a5,0x1
    17c6:	8ee7b783          	ld	a5,-1810(a5) # 20b0 <freep>
    17ca:	a02d                	j	17f4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    17cc:	4618                	lw	a4,8(a2)
    17ce:	9f2d                	addw	a4,a4,a1
    17d0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    17d4:	6398                	ld	a4,0(a5)
    17d6:	6310                	ld	a2,0(a4)
    17d8:	a83d                	j	1816 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    17da:	ff852703          	lw	a4,-8(a0)
    17de:	9f31                	addw	a4,a4,a2
    17e0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    17e2:	ff053683          	ld	a3,-16(a0)
    17e6:	a091                	j	182a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17e8:	6398                	ld	a4,0(a5)
    17ea:	00e7e463          	bltu	a5,a4,17f2 <free+0x3a>
    17ee:	00e6ea63          	bltu	a3,a4,1802 <free+0x4a>
{
    17f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17f4:	fed7fae3          	bgeu	a5,a3,17e8 <free+0x30>
    17f8:	6398                	ld	a4,0(a5)
    17fa:	00e6e463          	bltu	a3,a4,1802 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17fe:	fee7eae3          	bltu	a5,a4,17f2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1802:	ff852583          	lw	a1,-8(a0)
    1806:	6390                	ld	a2,0(a5)
    1808:	02059813          	slli	a6,a1,0x20
    180c:	01c85713          	srli	a4,a6,0x1c
    1810:	9736                	add	a4,a4,a3
    1812:	fae60de3          	beq	a2,a4,17cc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1816:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    181a:	4790                	lw	a2,8(a5)
    181c:	02061593          	slli	a1,a2,0x20
    1820:	01c5d713          	srli	a4,a1,0x1c
    1824:	973e                	add	a4,a4,a5
    1826:	fae68ae3          	beq	a3,a4,17da <free+0x22>
    p->s.ptr = bp->s.ptr;
    182a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    182c:	00001717          	auipc	a4,0x1
    1830:	88f73223          	sd	a5,-1916(a4) # 20b0 <freep>
}
    1834:	6422                	ld	s0,8(sp)
    1836:	0141                	addi	sp,sp,16
    1838:	8082                	ret

000000000000183a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    183a:	7139                	addi	sp,sp,-64
    183c:	fc06                	sd	ra,56(sp)
    183e:	f822                	sd	s0,48(sp)
    1840:	f426                	sd	s1,40(sp)
    1842:	ec4e                	sd	s3,24(sp)
    1844:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1846:	02051493          	slli	s1,a0,0x20
    184a:	9081                	srli	s1,s1,0x20
    184c:	04bd                	addi	s1,s1,15
    184e:	8091                	srli	s1,s1,0x4
    1850:	0014899b          	addiw	s3,s1,1
    1854:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1856:	00001517          	auipc	a0,0x1
    185a:	85a53503          	ld	a0,-1958(a0) # 20b0 <freep>
    185e:	c915                	beqz	a0,1892 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1862:	4798                	lw	a4,8(a5)
    1864:	08977a63          	bgeu	a4,s1,18f8 <malloc+0xbe>
    1868:	f04a                	sd	s2,32(sp)
    186a:	e852                	sd	s4,16(sp)
    186c:	e456                	sd	s5,8(sp)
    186e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1870:	8a4e                	mv	s4,s3
    1872:	0009871b          	sext.w	a4,s3
    1876:	6685                	lui	a3,0x1
    1878:	00d77363          	bgeu	a4,a3,187e <malloc+0x44>
    187c:	6a05                	lui	s4,0x1
    187e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1882:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1886:	00001917          	auipc	s2,0x1
    188a:	82a90913          	addi	s2,s2,-2006 # 20b0 <freep>
  if(p == (char*)-1)
    188e:	5afd                	li	s5,-1
    1890:	a081                	j	18d0 <malloc+0x96>
    1892:	f04a                	sd	s2,32(sp)
    1894:	e852                	sd	s4,16(sp)
    1896:	e456                	sd	s5,8(sp)
    1898:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    189a:	00001797          	auipc	a5,0x1
    189e:	82678793          	addi	a5,a5,-2010 # 20c0 <base>
    18a2:	00001717          	auipc	a4,0x1
    18a6:	80f73723          	sd	a5,-2034(a4) # 20b0 <freep>
    18aa:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    18ac:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    18b0:	b7c1                	j	1870 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    18b2:	6398                	ld	a4,0(a5)
    18b4:	e118                	sd	a4,0(a0)
    18b6:	a8a9                	j	1910 <malloc+0xd6>
  hp->s.size = nu;
    18b8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    18bc:	0541                	addi	a0,a0,16
    18be:	efbff0ef          	jal	17b8 <free>
  return freep;
    18c2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    18c6:	c12d                	beqz	a0,1928 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18c8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    18ca:	4798                	lw	a4,8(a5)
    18cc:	02977263          	bgeu	a4,s1,18f0 <malloc+0xb6>
    if(p == freep)
    18d0:	00093703          	ld	a4,0(s2)
    18d4:	853e                	mv	a0,a5
    18d6:	fef719e3          	bne	a4,a5,18c8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    18da:	8552                	mv	a0,s4
    18dc:	ad3ff0ef          	jal	13ae <sbrk>
  if(p == (char*)-1)
    18e0:	fd551ce3          	bne	a0,s5,18b8 <malloc+0x7e>
        return 0;
    18e4:	4501                	li	a0,0
    18e6:	7902                	ld	s2,32(sp)
    18e8:	6a42                	ld	s4,16(sp)
    18ea:	6aa2                	ld	s5,8(sp)
    18ec:	6b02                	ld	s6,0(sp)
    18ee:	a03d                	j	191c <malloc+0xe2>
    18f0:	7902                	ld	s2,32(sp)
    18f2:	6a42                	ld	s4,16(sp)
    18f4:	6aa2                	ld	s5,8(sp)
    18f6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    18f8:	fae48de3          	beq	s1,a4,18b2 <malloc+0x78>
        p->s.size -= nunits;
    18fc:	4137073b          	subw	a4,a4,s3
    1900:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1902:	02071693          	slli	a3,a4,0x20
    1906:	01c6d713          	srli	a4,a3,0x1c
    190a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    190c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1910:	00000717          	auipc	a4,0x0
    1914:	7aa73023          	sd	a0,1952(a4) # 20b0 <freep>
      return (void*)(p + 1);
    1918:	01078513          	addi	a0,a5,16
  }
}
    191c:	70e2                	ld	ra,56(sp)
    191e:	7442                	ld	s0,48(sp)
    1920:	74a2                	ld	s1,40(sp)
    1922:	69e2                	ld	s3,24(sp)
    1924:	6121                	addi	sp,sp,64
    1926:	8082                	ret
    1928:	7902                	ld	s2,32(sp)
    192a:	6a42                	ld	s4,16(sp)
    192c:	6aa2                	ld	s5,8(sp)
    192e:	6b02                	ld	s6,0(sp)
    1930:	b7f5                	j	191c <malloc+0xe2>
	...
