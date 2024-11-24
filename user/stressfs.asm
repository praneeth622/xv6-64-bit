
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
    1000:	dd010113          	addi	sp,sp,-560
    1004:	22113423          	sd	ra,552(sp)
    1008:	22813023          	sd	s0,544(sp)
    100c:	20913c23          	sd	s1,536(sp)
    1010:	21213823          	sd	s2,528(sp)
    1014:	1c00                	addi	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
    1016:	00001797          	auipc	a5,0x1
    101a:	01a78793          	addi	a5,a5,26 # 2030 <malloc+0x7da>
    101e:	6398                	ld	a4,0(a5)
    1020:	fce43823          	sd	a4,-48(s0)
    1024:	0087d783          	lhu	a5,8(a5)
    1028:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
    102c:	00001517          	auipc	a0,0x1
    1030:	fd450513          	addi	a0,a0,-44 # 2000 <malloc+0x7aa>
    1034:	76e000ef          	jal	17a2 <printf>
  memset(data, 'a', sizeof(data));
    1038:	20000613          	li	a2,512
    103c:	06100593          	li	a1,97
    1040:	dd040513          	addi	a0,s0,-560
    1044:	118000ef          	jal	115c <memset>

  for(i = 0; i < 4; i++)
    1048:	4481                	li	s1,0
    104a:	4911                	li	s2,4
    if(fork() > 0)
    104c:	2ee000ef          	jal	133a <fork>
    1050:	00a04563          	bgtz	a0,105a <main+0x5a>
  for(i = 0; i < 4; i++)
    1054:	2485                	addiw	s1,s1,1
    1056:	ff249be3          	bne	s1,s2,104c <main+0x4c>
      break;

  printf("write %d\n", i);
    105a:	85a6                	mv	a1,s1
    105c:	00001517          	auipc	a0,0x1
    1060:	fbc50513          	addi	a0,a0,-68 # 2018 <malloc+0x7c2>
    1064:	73e000ef          	jal	17a2 <printf>

  path[8] += i;
    1068:	fd844783          	lbu	a5,-40(s0)
    106c:	9fa5                	addw	a5,a5,s1
    106e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
    1072:	20200593          	li	a1,514
    1076:	fd040513          	addi	a0,s0,-48
    107a:	308000ef          	jal	1382 <open>
    107e:	892a                	mv	s2,a0
    1080:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
    1082:	20000613          	li	a2,512
    1086:	dd040593          	addi	a1,s0,-560
    108a:	854a                	mv	a0,s2
    108c:	2d6000ef          	jal	1362 <write>
  for(i = 0; i < 20; i++)
    1090:	34fd                	addiw	s1,s1,-1
    1092:	f8e5                	bnez	s1,1082 <main+0x82>
  close(fd);
    1094:	854a                	mv	a0,s2
    1096:	2d4000ef          	jal	136a <close>

  printf("read\n");
    109a:	00001517          	auipc	a0,0x1
    109e:	f8e50513          	addi	a0,a0,-114 # 2028 <malloc+0x7d2>
    10a2:	700000ef          	jal	17a2 <printf>

  fd = open(path, O_RDONLY);
    10a6:	4581                	li	a1,0
    10a8:	fd040513          	addi	a0,s0,-48
    10ac:	2d6000ef          	jal	1382 <open>
    10b0:	892a                	mv	s2,a0
    10b2:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
    10b4:	20000613          	li	a2,512
    10b8:	dd040593          	addi	a1,s0,-560
    10bc:	854a                	mv	a0,s2
    10be:	29c000ef          	jal	135a <read>
  for (i = 0; i < 20; i++)
    10c2:	34fd                	addiw	s1,s1,-1
    10c4:	f8e5                	bnez	s1,10b4 <main+0xb4>
  close(fd);
    10c6:	854a                	mv	a0,s2
    10c8:	2a2000ef          	jal	136a <close>

  wait(0);
    10cc:	4501                	li	a0,0
    10ce:	27c000ef          	jal	134a <wait>

  exit(0);
    10d2:	4501                	li	a0,0
    10d4:	26e000ef          	jal	1342 <exit>

00000000000010d8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    10d8:	1141                	addi	sp,sp,-16
    10da:	e406                	sd	ra,8(sp)
    10dc:	e022                	sd	s0,0(sp)
    10de:	0800                	addi	s0,sp,16
  extern int main();
  main();
    10e0:	f21ff0ef          	jal	1000 <main>
  exit(0);
    10e4:	4501                	li	a0,0
    10e6:	25c000ef          	jal	1342 <exit>

00000000000010ea <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    10ea:	1141                	addi	sp,sp,-16
    10ec:	e422                	sd	s0,8(sp)
    10ee:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10f0:	87aa                	mv	a5,a0
    10f2:	0585                	addi	a1,a1,1
    10f4:	0785                	addi	a5,a5,1
    10f6:	fff5c703          	lbu	a4,-1(a1)
    10fa:	fee78fa3          	sb	a4,-1(a5)
    10fe:	fb75                	bnez	a4,10f2 <strcpy+0x8>
    ;
  return os;
}
    1100:	6422                	ld	s0,8(sp)
    1102:	0141                	addi	sp,sp,16
    1104:	8082                	ret

0000000000001106 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1106:	1141                	addi	sp,sp,-16
    1108:	e422                	sd	s0,8(sp)
    110a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    110c:	00054783          	lbu	a5,0(a0)
    1110:	cb91                	beqz	a5,1124 <strcmp+0x1e>
    1112:	0005c703          	lbu	a4,0(a1)
    1116:	00f71763          	bne	a4,a5,1124 <strcmp+0x1e>
    p++, q++;
    111a:	0505                	addi	a0,a0,1
    111c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    111e:	00054783          	lbu	a5,0(a0)
    1122:	fbe5                	bnez	a5,1112 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1124:	0005c503          	lbu	a0,0(a1)
}
    1128:	40a7853b          	subw	a0,a5,a0
    112c:	6422                	ld	s0,8(sp)
    112e:	0141                	addi	sp,sp,16
    1130:	8082                	ret

0000000000001132 <strlen>:

uint
strlen(const char *s)
{
    1132:	1141                	addi	sp,sp,-16
    1134:	e422                	sd	s0,8(sp)
    1136:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1138:	00054783          	lbu	a5,0(a0)
    113c:	cf91                	beqz	a5,1158 <strlen+0x26>
    113e:	0505                	addi	a0,a0,1
    1140:	87aa                	mv	a5,a0
    1142:	86be                	mv	a3,a5
    1144:	0785                	addi	a5,a5,1
    1146:	fff7c703          	lbu	a4,-1(a5)
    114a:	ff65                	bnez	a4,1142 <strlen+0x10>
    114c:	40a6853b          	subw	a0,a3,a0
    1150:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    1152:	6422                	ld	s0,8(sp)
    1154:	0141                	addi	sp,sp,16
    1156:	8082                	ret
  for(n = 0; s[n]; n++)
    1158:	4501                	li	a0,0
    115a:	bfe5                	j	1152 <strlen+0x20>

000000000000115c <memset>:

void*
memset(void *dst, int c, uint n)
{
    115c:	1141                	addi	sp,sp,-16
    115e:	e422                	sd	s0,8(sp)
    1160:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1162:	ca19                	beqz	a2,1178 <memset+0x1c>
    1164:	87aa                	mv	a5,a0
    1166:	1602                	slli	a2,a2,0x20
    1168:	9201                	srli	a2,a2,0x20
    116a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    116e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1172:	0785                	addi	a5,a5,1
    1174:	fee79de3          	bne	a5,a4,116e <memset+0x12>
  }
  return dst;
}
    1178:	6422                	ld	s0,8(sp)
    117a:	0141                	addi	sp,sp,16
    117c:	8082                	ret

000000000000117e <strchr>:

char*
strchr(const char *s, char c)
{
    117e:	1141                	addi	sp,sp,-16
    1180:	e422                	sd	s0,8(sp)
    1182:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1184:	00054783          	lbu	a5,0(a0)
    1188:	cb99                	beqz	a5,119e <strchr+0x20>
    if(*s == c)
    118a:	00f58763          	beq	a1,a5,1198 <strchr+0x1a>
  for(; *s; s++)
    118e:	0505                	addi	a0,a0,1
    1190:	00054783          	lbu	a5,0(a0)
    1194:	fbfd                	bnez	a5,118a <strchr+0xc>
      return (char*)s;
  return 0;
    1196:	4501                	li	a0,0
}
    1198:	6422                	ld	s0,8(sp)
    119a:	0141                	addi	sp,sp,16
    119c:	8082                	ret
  return 0;
    119e:	4501                	li	a0,0
    11a0:	bfe5                	j	1198 <strchr+0x1a>

00000000000011a2 <gets>:

char*
gets(char *buf, int max)
{
    11a2:	711d                	addi	sp,sp,-96
    11a4:	ec86                	sd	ra,88(sp)
    11a6:	e8a2                	sd	s0,80(sp)
    11a8:	e4a6                	sd	s1,72(sp)
    11aa:	e0ca                	sd	s2,64(sp)
    11ac:	fc4e                	sd	s3,56(sp)
    11ae:	f852                	sd	s4,48(sp)
    11b0:	f456                	sd	s5,40(sp)
    11b2:	f05a                	sd	s6,32(sp)
    11b4:	ec5e                	sd	s7,24(sp)
    11b6:	1080                	addi	s0,sp,96
    11b8:	8baa                	mv	s7,a0
    11ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11bc:	892a                	mv	s2,a0
    11be:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    11c0:	4aa9                	li	s5,10
    11c2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    11c4:	89a6                	mv	s3,s1
    11c6:	2485                	addiw	s1,s1,1
    11c8:	0344d663          	bge	s1,s4,11f4 <gets+0x52>
    cc = read(0, &c, 1);
    11cc:	4605                	li	a2,1
    11ce:	faf40593          	addi	a1,s0,-81
    11d2:	4501                	li	a0,0
    11d4:	186000ef          	jal	135a <read>
    if(cc < 1)
    11d8:	00a05e63          	blez	a0,11f4 <gets+0x52>
    buf[i++] = c;
    11dc:	faf44783          	lbu	a5,-81(s0)
    11e0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    11e4:	01578763          	beq	a5,s5,11f2 <gets+0x50>
    11e8:	0905                	addi	s2,s2,1
    11ea:	fd679de3          	bne	a5,s6,11c4 <gets+0x22>
    buf[i++] = c;
    11ee:	89a6                	mv	s3,s1
    11f0:	a011                	j	11f4 <gets+0x52>
    11f2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    11f4:	99de                	add	s3,s3,s7
    11f6:	00098023          	sb	zero,0(s3)
  return buf;
}
    11fa:	855e                	mv	a0,s7
    11fc:	60e6                	ld	ra,88(sp)
    11fe:	6446                	ld	s0,80(sp)
    1200:	64a6                	ld	s1,72(sp)
    1202:	6906                	ld	s2,64(sp)
    1204:	79e2                	ld	s3,56(sp)
    1206:	7a42                	ld	s4,48(sp)
    1208:	7aa2                	ld	s5,40(sp)
    120a:	7b02                	ld	s6,32(sp)
    120c:	6be2                	ld	s7,24(sp)
    120e:	6125                	addi	sp,sp,96
    1210:	8082                	ret

0000000000001212 <stat>:

int
stat(const char *n, struct stat *st)
{
    1212:	1101                	addi	sp,sp,-32
    1214:	ec06                	sd	ra,24(sp)
    1216:	e822                	sd	s0,16(sp)
    1218:	e04a                	sd	s2,0(sp)
    121a:	1000                	addi	s0,sp,32
    121c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    121e:	4581                	li	a1,0
    1220:	162000ef          	jal	1382 <open>
  if(fd < 0)
    1224:	02054263          	bltz	a0,1248 <stat+0x36>
    1228:	e426                	sd	s1,8(sp)
    122a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    122c:	85ca                	mv	a1,s2
    122e:	16c000ef          	jal	139a <fstat>
    1232:	892a                	mv	s2,a0
  close(fd);
    1234:	8526                	mv	a0,s1
    1236:	134000ef          	jal	136a <close>
  return r;
    123a:	64a2                	ld	s1,8(sp)
}
    123c:	854a                	mv	a0,s2
    123e:	60e2                	ld	ra,24(sp)
    1240:	6442                	ld	s0,16(sp)
    1242:	6902                	ld	s2,0(sp)
    1244:	6105                	addi	sp,sp,32
    1246:	8082                	ret
    return -1;
    1248:	597d                	li	s2,-1
    124a:	bfcd                	j	123c <stat+0x2a>

000000000000124c <atoi>:

int
atoi(const char *s)
{
    124c:	1141                	addi	sp,sp,-16
    124e:	e422                	sd	s0,8(sp)
    1250:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1252:	00054683          	lbu	a3,0(a0)
    1256:	fd06879b          	addiw	a5,a3,-48
    125a:	0ff7f793          	zext.b	a5,a5
    125e:	4625                	li	a2,9
    1260:	02f66863          	bltu	a2,a5,1290 <atoi+0x44>
    1264:	872a                	mv	a4,a0
  n = 0;
    1266:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    1268:	0705                	addi	a4,a4,1
    126a:	0025179b          	slliw	a5,a0,0x2
    126e:	9fa9                	addw	a5,a5,a0
    1270:	0017979b          	slliw	a5,a5,0x1
    1274:	9fb5                	addw	a5,a5,a3
    1276:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    127a:	00074683          	lbu	a3,0(a4)
    127e:	fd06879b          	addiw	a5,a3,-48
    1282:	0ff7f793          	zext.b	a5,a5
    1286:	fef671e3          	bgeu	a2,a5,1268 <atoi+0x1c>
  return n;
}
    128a:	6422                	ld	s0,8(sp)
    128c:	0141                	addi	sp,sp,16
    128e:	8082                	ret
  n = 0;
    1290:	4501                	li	a0,0
    1292:	bfe5                	j	128a <atoi+0x3e>

0000000000001294 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1294:	1141                	addi	sp,sp,-16
    1296:	e422                	sd	s0,8(sp)
    1298:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    129a:	02b57463          	bgeu	a0,a1,12c2 <memmove+0x2e>
    while(n-- > 0)
    129e:	00c05f63          	blez	a2,12bc <memmove+0x28>
    12a2:	1602                	slli	a2,a2,0x20
    12a4:	9201                	srli	a2,a2,0x20
    12a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    12aa:	872a                	mv	a4,a0
      *dst++ = *src++;
    12ac:	0585                	addi	a1,a1,1
    12ae:	0705                	addi	a4,a4,1
    12b0:	fff5c683          	lbu	a3,-1(a1)
    12b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    12b8:	fef71ae3          	bne	a4,a5,12ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    12bc:	6422                	ld	s0,8(sp)
    12be:	0141                	addi	sp,sp,16
    12c0:	8082                	ret
    dst += n;
    12c2:	00c50733          	add	a4,a0,a2
    src += n;
    12c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    12c8:	fec05ae3          	blez	a2,12bc <memmove+0x28>
    12cc:	fff6079b          	addiw	a5,a2,-1
    12d0:	1782                	slli	a5,a5,0x20
    12d2:	9381                	srli	a5,a5,0x20
    12d4:	fff7c793          	not	a5,a5
    12d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    12da:	15fd                	addi	a1,a1,-1
    12dc:	177d                	addi	a4,a4,-1
    12de:	0005c683          	lbu	a3,0(a1)
    12e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    12e6:	fee79ae3          	bne	a5,a4,12da <memmove+0x46>
    12ea:	bfc9                	j	12bc <memmove+0x28>

00000000000012ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    12ec:	1141                	addi	sp,sp,-16
    12ee:	e422                	sd	s0,8(sp)
    12f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    12f2:	ca05                	beqz	a2,1322 <memcmp+0x36>
    12f4:	fff6069b          	addiw	a3,a2,-1
    12f8:	1682                	slli	a3,a3,0x20
    12fa:	9281                	srli	a3,a3,0x20
    12fc:	0685                	addi	a3,a3,1
    12fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1300:	00054783          	lbu	a5,0(a0)
    1304:	0005c703          	lbu	a4,0(a1)
    1308:	00e79863          	bne	a5,a4,1318 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    130c:	0505                	addi	a0,a0,1
    p2++;
    130e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1310:	fed518e3          	bne	a0,a3,1300 <memcmp+0x14>
  }
  return 0;
    1314:	4501                	li	a0,0
    1316:	a019                	j	131c <memcmp+0x30>
      return *p1 - *p2;
    1318:	40e7853b          	subw	a0,a5,a4
}
    131c:	6422                	ld	s0,8(sp)
    131e:	0141                	addi	sp,sp,16
    1320:	8082                	ret
  return 0;
    1322:	4501                	li	a0,0
    1324:	bfe5                	j	131c <memcmp+0x30>

0000000000001326 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1326:	1141                	addi	sp,sp,-16
    1328:	e406                	sd	ra,8(sp)
    132a:	e022                	sd	s0,0(sp)
    132c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    132e:	f67ff0ef          	jal	1294 <memmove>
}
    1332:	60a2                	ld	ra,8(sp)
    1334:	6402                	ld	s0,0(sp)
    1336:	0141                	addi	sp,sp,16
    1338:	8082                	ret

000000000000133a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    133a:	4885                	li	a7,1
 ecall
    133c:	00000073          	ecall
 ret
    1340:	8082                	ret

0000000000001342 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1342:	4889                	li	a7,2
 ecall
    1344:	00000073          	ecall
 ret
    1348:	8082                	ret

000000000000134a <wait>:
.global wait
wait:
 li a7, SYS_wait
    134a:	488d                	li	a7,3
 ecall
    134c:	00000073          	ecall
 ret
    1350:	8082                	ret

0000000000001352 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1352:	4891                	li	a7,4
 ecall
    1354:	00000073          	ecall
 ret
    1358:	8082                	ret

000000000000135a <read>:
.global read
read:
 li a7, SYS_read
    135a:	4895                	li	a7,5
 ecall
    135c:	00000073          	ecall
 ret
    1360:	8082                	ret

0000000000001362 <write>:
.global write
write:
 li a7, SYS_write
    1362:	48c1                	li	a7,16
 ecall
    1364:	00000073          	ecall
 ret
    1368:	8082                	ret

000000000000136a <close>:
.global close
close:
 li a7, SYS_close
    136a:	48d5                	li	a7,21
 ecall
    136c:	00000073          	ecall
 ret
    1370:	8082                	ret

0000000000001372 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1372:	4899                	li	a7,6
 ecall
    1374:	00000073          	ecall
 ret
    1378:	8082                	ret

000000000000137a <exec>:
.global exec
exec:
 li a7, SYS_exec
    137a:	489d                	li	a7,7
 ecall
    137c:	00000073          	ecall
 ret
    1380:	8082                	ret

0000000000001382 <open>:
.global open
open:
 li a7, SYS_open
    1382:	48bd                	li	a7,15
 ecall
    1384:	00000073          	ecall
 ret
    1388:	8082                	ret

000000000000138a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    138a:	48c5                	li	a7,17
 ecall
    138c:	00000073          	ecall
 ret
    1390:	8082                	ret

0000000000001392 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1392:	48c9                	li	a7,18
 ecall
    1394:	00000073          	ecall
 ret
    1398:	8082                	ret

000000000000139a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    139a:	48a1                	li	a7,8
 ecall
    139c:	00000073          	ecall
 ret
    13a0:	8082                	ret

00000000000013a2 <link>:
.global link
link:
 li a7, SYS_link
    13a2:	48cd                	li	a7,19
 ecall
    13a4:	00000073          	ecall
 ret
    13a8:	8082                	ret

00000000000013aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    13aa:	48d1                	li	a7,20
 ecall
    13ac:	00000073          	ecall
 ret
    13b0:	8082                	ret

00000000000013b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    13b2:	48a5                	li	a7,9
 ecall
    13b4:	00000073          	ecall
 ret
    13b8:	8082                	ret

00000000000013ba <dup>:
.global dup
dup:
 li a7, SYS_dup
    13ba:	48a9                	li	a7,10
 ecall
    13bc:	00000073          	ecall
 ret
    13c0:	8082                	ret

00000000000013c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    13c2:	48ad                	li	a7,11
 ecall
    13c4:	00000073          	ecall
 ret
    13c8:	8082                	ret

00000000000013ca <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    13ca:	48b1                	li	a7,12
 ecall
    13cc:	00000073          	ecall
 ret
    13d0:	8082                	ret

00000000000013d2 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    13d2:	48b5                	li	a7,13
 ecall
    13d4:	00000073          	ecall
 ret
    13d8:	8082                	ret

00000000000013da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    13da:	48b9                	li	a7,14
 ecall
    13dc:	00000073          	ecall
 ret
    13e0:	8082                	ret

00000000000013e2 <cps>:
.global cps
cps:
 li a7, SYS_cps
    13e2:	48d9                	li	a7,22
 ecall
    13e4:	00000073          	ecall
 ret
    13e8:	8082                	ret

00000000000013ea <signal>:
.global signal
signal:
 li a7, SYS_signal
    13ea:	48dd                	li	a7,23
 ecall
    13ec:	00000073          	ecall
 ret
    13f0:	8082                	ret

00000000000013f2 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    13f2:	48e1                	li	a7,24
 ecall
    13f4:	00000073          	ecall
 ret
    13f8:	8082                	ret

00000000000013fa <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    13fa:	48e5                	li	a7,25
 ecall
    13fc:	00000073          	ecall
 ret
    1400:	8082                	ret

0000000000001402 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1402:	48e9                	li	a7,26
 ecall
    1404:	00000073          	ecall
 ret
    1408:	8082                	ret

000000000000140a <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    140a:	48ed                	li	a7,27
 ecall
    140c:	00000073          	ecall
 ret
    1410:	8082                	ret

0000000000001412 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1412:	48f1                	li	a7,28
 ecall
    1414:	00000073          	ecall
 ret
    1418:	8082                	ret

000000000000141a <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    141a:	48f5                	li	a7,29
 ecall
    141c:	00000073          	ecall
 ret
    1420:	8082                	ret

0000000000001422 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1422:	48f9                	li	a7,30
 ecall
    1424:	00000073          	ecall
 ret
    1428:	8082                	ret

000000000000142a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    142a:	1101                	addi	sp,sp,-32
    142c:	ec06                	sd	ra,24(sp)
    142e:	e822                	sd	s0,16(sp)
    1430:	1000                	addi	s0,sp,32
    1432:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1436:	4605                	li	a2,1
    1438:	fef40593          	addi	a1,s0,-17
    143c:	f27ff0ef          	jal	1362 <write>
}
    1440:	60e2                	ld	ra,24(sp)
    1442:	6442                	ld	s0,16(sp)
    1444:	6105                	addi	sp,sp,32
    1446:	8082                	ret

0000000000001448 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1448:	7139                	addi	sp,sp,-64
    144a:	fc06                	sd	ra,56(sp)
    144c:	f822                	sd	s0,48(sp)
    144e:	f426                	sd	s1,40(sp)
    1450:	0080                	addi	s0,sp,64
    1452:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1454:	c299                	beqz	a3,145a <printint+0x12>
    1456:	0805c963          	bltz	a1,14e8 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    145a:	2581                	sext.w	a1,a1
  neg = 0;
    145c:	4881                	li	a7,0
    145e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1462:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1464:	2601                	sext.w	a2,a2
    1466:	00001517          	auipc	a0,0x1
    146a:	be250513          	addi	a0,a0,-1054 # 2048 <digits>
    146e:	883a                	mv	a6,a4
    1470:	2705                	addiw	a4,a4,1
    1472:	02c5f7bb          	remuw	a5,a1,a2
    1476:	1782                	slli	a5,a5,0x20
    1478:	9381                	srli	a5,a5,0x20
    147a:	97aa                	add	a5,a5,a0
    147c:	0007c783          	lbu	a5,0(a5)
    1480:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1484:	0005879b          	sext.w	a5,a1
    1488:	02c5d5bb          	divuw	a1,a1,a2
    148c:	0685                	addi	a3,a3,1
    148e:	fec7f0e3          	bgeu	a5,a2,146e <printint+0x26>
  if(neg)
    1492:	00088c63          	beqz	a7,14aa <printint+0x62>
    buf[i++] = '-';
    1496:	fd070793          	addi	a5,a4,-48
    149a:	00878733          	add	a4,a5,s0
    149e:	02d00793          	li	a5,45
    14a2:	fef70823          	sb	a5,-16(a4)
    14a6:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    14aa:	02e05a63          	blez	a4,14de <printint+0x96>
    14ae:	f04a                	sd	s2,32(sp)
    14b0:	ec4e                	sd	s3,24(sp)
    14b2:	fc040793          	addi	a5,s0,-64
    14b6:	00e78933          	add	s2,a5,a4
    14ba:	fff78993          	addi	s3,a5,-1
    14be:	99ba                	add	s3,s3,a4
    14c0:	377d                	addiw	a4,a4,-1
    14c2:	1702                	slli	a4,a4,0x20
    14c4:	9301                	srli	a4,a4,0x20
    14c6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    14ca:	fff94583          	lbu	a1,-1(s2)
    14ce:	8526                	mv	a0,s1
    14d0:	f5bff0ef          	jal	142a <putc>
  while(--i >= 0)
    14d4:	197d                	addi	s2,s2,-1
    14d6:	ff391ae3          	bne	s2,s3,14ca <printint+0x82>
    14da:	7902                	ld	s2,32(sp)
    14dc:	69e2                	ld	s3,24(sp)
}
    14de:	70e2                	ld	ra,56(sp)
    14e0:	7442                	ld	s0,48(sp)
    14e2:	74a2                	ld	s1,40(sp)
    14e4:	6121                	addi	sp,sp,64
    14e6:	8082                	ret
    x = -xx;
    14e8:	40b005bb          	negw	a1,a1
    neg = 1;
    14ec:	4885                	li	a7,1
    x = -xx;
    14ee:	bf85                	j	145e <printint+0x16>

00000000000014f0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    14f0:	711d                	addi	sp,sp,-96
    14f2:	ec86                	sd	ra,88(sp)
    14f4:	e8a2                	sd	s0,80(sp)
    14f6:	e0ca                	sd	s2,64(sp)
    14f8:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    14fa:	0005c903          	lbu	s2,0(a1)
    14fe:	26090863          	beqz	s2,176e <vprintf+0x27e>
    1502:	e4a6                	sd	s1,72(sp)
    1504:	fc4e                	sd	s3,56(sp)
    1506:	f852                	sd	s4,48(sp)
    1508:	f456                	sd	s5,40(sp)
    150a:	f05a                	sd	s6,32(sp)
    150c:	ec5e                	sd	s7,24(sp)
    150e:	e862                	sd	s8,16(sp)
    1510:	e466                	sd	s9,8(sp)
    1512:	8b2a                	mv	s6,a0
    1514:	8a2e                	mv	s4,a1
    1516:	8bb2                	mv	s7,a2
  state = 0;
    1518:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    151a:	4481                	li	s1,0
    151c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    151e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1522:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1526:	06c00c93          	li	s9,108
    152a:	a005                	j	154a <vprintf+0x5a>
        putc(fd, c0);
    152c:	85ca                	mv	a1,s2
    152e:	855a                	mv	a0,s6
    1530:	efbff0ef          	jal	142a <putc>
    1534:	a019                	j	153a <vprintf+0x4a>
    } else if(state == '%'){
    1536:	03598263          	beq	s3,s5,155a <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    153a:	2485                	addiw	s1,s1,1
    153c:	8726                	mv	a4,s1
    153e:	009a07b3          	add	a5,s4,s1
    1542:	0007c903          	lbu	s2,0(a5)
    1546:	20090c63          	beqz	s2,175e <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    154a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    154e:	fe0994e3          	bnez	s3,1536 <vprintf+0x46>
      if(c0 == '%'){
    1552:	fd579de3          	bne	a5,s5,152c <vprintf+0x3c>
        state = '%';
    1556:	89be                	mv	s3,a5
    1558:	b7cd                	j	153a <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    155a:	00ea06b3          	add	a3,s4,a4
    155e:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1562:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1564:	c681                	beqz	a3,156c <vprintf+0x7c>
    1566:	9752                	add	a4,a4,s4
    1568:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    156c:	03878f63          	beq	a5,s8,15aa <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1570:	05978963          	beq	a5,s9,15c2 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1574:	07500713          	li	a4,117
    1578:	0ee78363          	beq	a5,a4,165e <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    157c:	07800713          	li	a4,120
    1580:	12e78563          	beq	a5,a4,16aa <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1584:	07000713          	li	a4,112
    1588:	14e78a63          	beq	a5,a4,16dc <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    158c:	07300713          	li	a4,115
    1590:	18e78a63          	beq	a5,a4,1724 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1594:	02500713          	li	a4,37
    1598:	04e79563          	bne	a5,a4,15e2 <vprintf+0xf2>
        putc(fd, '%');
    159c:	02500593          	li	a1,37
    15a0:	855a                	mv	a0,s6
    15a2:	e89ff0ef          	jal	142a <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    15a6:	4981                	li	s3,0
    15a8:	bf49                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    15aa:	008b8913          	addi	s2,s7,8
    15ae:	4685                	li	a3,1
    15b0:	4629                	li	a2,10
    15b2:	000ba583          	lw	a1,0(s7)
    15b6:	855a                	mv	a0,s6
    15b8:	e91ff0ef          	jal	1448 <printint>
    15bc:	8bca                	mv	s7,s2
      state = 0;
    15be:	4981                	li	s3,0
    15c0:	bfad                	j	153a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    15c2:	06400793          	li	a5,100
    15c6:	02f68963          	beq	a3,a5,15f8 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15ca:	06c00793          	li	a5,108
    15ce:	04f68263          	beq	a3,a5,1612 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    15d2:	07500793          	li	a5,117
    15d6:	0af68063          	beq	a3,a5,1676 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    15da:	07800793          	li	a5,120
    15de:	0ef68263          	beq	a3,a5,16c2 <vprintf+0x1d2>
        putc(fd, '%');
    15e2:	02500593          	li	a1,37
    15e6:	855a                	mv	a0,s6
    15e8:	e43ff0ef          	jal	142a <putc>
        putc(fd, c0);
    15ec:	85ca                	mv	a1,s2
    15ee:	855a                	mv	a0,s6
    15f0:	e3bff0ef          	jal	142a <putc>
      state = 0;
    15f4:	4981                	li	s3,0
    15f6:	b791                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15f8:	008b8913          	addi	s2,s7,8
    15fc:	4685                	li	a3,1
    15fe:	4629                	li	a2,10
    1600:	000ba583          	lw	a1,0(s7)
    1604:	855a                	mv	a0,s6
    1606:	e43ff0ef          	jal	1448 <printint>
        i += 1;
    160a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    160c:	8bca                	mv	s7,s2
      state = 0;
    160e:	4981                	li	s3,0
        i += 1;
    1610:	b72d                	j	153a <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1612:	06400793          	li	a5,100
    1616:	02f60763          	beq	a2,a5,1644 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    161a:	07500793          	li	a5,117
    161e:	06f60963          	beq	a2,a5,1690 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1622:	07800793          	li	a5,120
    1626:	faf61ee3          	bne	a2,a5,15e2 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    162a:	008b8913          	addi	s2,s7,8
    162e:	4681                	li	a3,0
    1630:	4641                	li	a2,16
    1632:	000ba583          	lw	a1,0(s7)
    1636:	855a                	mv	a0,s6
    1638:	e11ff0ef          	jal	1448 <printint>
        i += 2;
    163c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    163e:	8bca                	mv	s7,s2
      state = 0;
    1640:	4981                	li	s3,0
        i += 2;
    1642:	bde5                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1644:	008b8913          	addi	s2,s7,8
    1648:	4685                	li	a3,1
    164a:	4629                	li	a2,10
    164c:	000ba583          	lw	a1,0(s7)
    1650:	855a                	mv	a0,s6
    1652:	df7ff0ef          	jal	1448 <printint>
        i += 2;
    1656:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1658:	8bca                	mv	s7,s2
      state = 0;
    165a:	4981                	li	s3,0
        i += 2;
    165c:	bdf9                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    165e:	008b8913          	addi	s2,s7,8
    1662:	4681                	li	a3,0
    1664:	4629                	li	a2,10
    1666:	000ba583          	lw	a1,0(s7)
    166a:	855a                	mv	a0,s6
    166c:	dddff0ef          	jal	1448 <printint>
    1670:	8bca                	mv	s7,s2
      state = 0;
    1672:	4981                	li	s3,0
    1674:	b5d9                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1676:	008b8913          	addi	s2,s7,8
    167a:	4681                	li	a3,0
    167c:	4629                	li	a2,10
    167e:	000ba583          	lw	a1,0(s7)
    1682:	855a                	mv	a0,s6
    1684:	dc5ff0ef          	jal	1448 <printint>
        i += 1;
    1688:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    168a:	8bca                	mv	s7,s2
      state = 0;
    168c:	4981                	li	s3,0
        i += 1;
    168e:	b575                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1690:	008b8913          	addi	s2,s7,8
    1694:	4681                	li	a3,0
    1696:	4629                	li	a2,10
    1698:	000ba583          	lw	a1,0(s7)
    169c:	855a                	mv	a0,s6
    169e:	dabff0ef          	jal	1448 <printint>
        i += 2;
    16a2:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    16a4:	8bca                	mv	s7,s2
      state = 0;
    16a6:	4981                	li	s3,0
        i += 2;
    16a8:	bd49                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    16aa:	008b8913          	addi	s2,s7,8
    16ae:	4681                	li	a3,0
    16b0:	4641                	li	a2,16
    16b2:	000ba583          	lw	a1,0(s7)
    16b6:	855a                	mv	a0,s6
    16b8:	d91ff0ef          	jal	1448 <printint>
    16bc:	8bca                	mv	s7,s2
      state = 0;
    16be:	4981                	li	s3,0
    16c0:	bdad                	j	153a <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    16c2:	008b8913          	addi	s2,s7,8
    16c6:	4681                	li	a3,0
    16c8:	4641                	li	a2,16
    16ca:	000ba583          	lw	a1,0(s7)
    16ce:	855a                	mv	a0,s6
    16d0:	d79ff0ef          	jal	1448 <printint>
        i += 1;
    16d4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    16d6:	8bca                	mv	s7,s2
      state = 0;
    16d8:	4981                	li	s3,0
        i += 1;
    16da:	b585                	j	153a <vprintf+0x4a>
    16dc:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    16de:	008b8d13          	addi	s10,s7,8
    16e2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    16e6:	03000593          	li	a1,48
    16ea:	855a                	mv	a0,s6
    16ec:	d3fff0ef          	jal	142a <putc>
  putc(fd, 'x');
    16f0:	07800593          	li	a1,120
    16f4:	855a                	mv	a0,s6
    16f6:	d35ff0ef          	jal	142a <putc>
    16fa:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    16fc:	00001b97          	auipc	s7,0x1
    1700:	94cb8b93          	addi	s7,s7,-1716 # 2048 <digits>
    1704:	03c9d793          	srli	a5,s3,0x3c
    1708:	97de                	add	a5,a5,s7
    170a:	0007c583          	lbu	a1,0(a5)
    170e:	855a                	mv	a0,s6
    1710:	d1bff0ef          	jal	142a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1714:	0992                	slli	s3,s3,0x4
    1716:	397d                	addiw	s2,s2,-1
    1718:	fe0916e3          	bnez	s2,1704 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    171c:	8bea                	mv	s7,s10
      state = 0;
    171e:	4981                	li	s3,0
    1720:	6d02                	ld	s10,0(sp)
    1722:	bd21                	j	153a <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1724:	008b8993          	addi	s3,s7,8
    1728:	000bb903          	ld	s2,0(s7)
    172c:	00090f63          	beqz	s2,174a <vprintf+0x25a>
        for(; *s; s++)
    1730:	00094583          	lbu	a1,0(s2)
    1734:	c195                	beqz	a1,1758 <vprintf+0x268>
          putc(fd, *s);
    1736:	855a                	mv	a0,s6
    1738:	cf3ff0ef          	jal	142a <putc>
        for(; *s; s++)
    173c:	0905                	addi	s2,s2,1
    173e:	00094583          	lbu	a1,0(s2)
    1742:	f9f5                	bnez	a1,1736 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1744:	8bce                	mv	s7,s3
      state = 0;
    1746:	4981                	li	s3,0
    1748:	bbcd                	j	153a <vprintf+0x4a>
          s = "(null)";
    174a:	00001917          	auipc	s2,0x1
    174e:	8f690913          	addi	s2,s2,-1802 # 2040 <malloc+0x7ea>
        for(; *s; s++)
    1752:	02800593          	li	a1,40
    1756:	b7c5                	j	1736 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1758:	8bce                	mv	s7,s3
      state = 0;
    175a:	4981                	li	s3,0
    175c:	bbf9                	j	153a <vprintf+0x4a>
    175e:	64a6                	ld	s1,72(sp)
    1760:	79e2                	ld	s3,56(sp)
    1762:	7a42                	ld	s4,48(sp)
    1764:	7aa2                	ld	s5,40(sp)
    1766:	7b02                	ld	s6,32(sp)
    1768:	6be2                	ld	s7,24(sp)
    176a:	6c42                	ld	s8,16(sp)
    176c:	6ca2                	ld	s9,8(sp)
    }
  }
}
    176e:	60e6                	ld	ra,88(sp)
    1770:	6446                	ld	s0,80(sp)
    1772:	6906                	ld	s2,64(sp)
    1774:	6125                	addi	sp,sp,96
    1776:	8082                	ret

0000000000001778 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1778:	715d                	addi	sp,sp,-80
    177a:	ec06                	sd	ra,24(sp)
    177c:	e822                	sd	s0,16(sp)
    177e:	1000                	addi	s0,sp,32
    1780:	e010                	sd	a2,0(s0)
    1782:	e414                	sd	a3,8(s0)
    1784:	e818                	sd	a4,16(s0)
    1786:	ec1c                	sd	a5,24(s0)
    1788:	03043023          	sd	a6,32(s0)
    178c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1794:	8622                	mv	a2,s0
    1796:	d5bff0ef          	jal	14f0 <vprintf>
}
    179a:	60e2                	ld	ra,24(sp)
    179c:	6442                	ld	s0,16(sp)
    179e:	6161                	addi	sp,sp,80
    17a0:	8082                	ret

00000000000017a2 <printf>:

void
printf(const char *fmt, ...)
{
    17a2:	711d                	addi	sp,sp,-96
    17a4:	ec06                	sd	ra,24(sp)
    17a6:	e822                	sd	s0,16(sp)
    17a8:	1000                	addi	s0,sp,32
    17aa:	e40c                	sd	a1,8(s0)
    17ac:	e810                	sd	a2,16(s0)
    17ae:	ec14                	sd	a3,24(s0)
    17b0:	f018                	sd	a4,32(s0)
    17b2:	f41c                	sd	a5,40(s0)
    17b4:	03043823          	sd	a6,48(s0)
    17b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    17bc:	00840613          	addi	a2,s0,8
    17c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    17c4:	85aa                	mv	a1,a0
    17c6:	4505                	li	a0,1
    17c8:	d29ff0ef          	jal	14f0 <vprintf>
}
    17cc:	60e2                	ld	ra,24(sp)
    17ce:	6442                	ld	s0,16(sp)
    17d0:	6125                	addi	sp,sp,96
    17d2:	8082                	ret

00000000000017d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17d4:	1141                	addi	sp,sp,-16
    17d6:	e422                	sd	s0,8(sp)
    17d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17de:	00001797          	auipc	a5,0x1
    17e2:	8827b783          	ld	a5,-1918(a5) # 2060 <freep>
    17e6:	a02d                	j	1810 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    17e8:	4618                	lw	a4,8(a2)
    17ea:	9f2d                	addw	a4,a4,a1
    17ec:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    17f0:	6398                	ld	a4,0(a5)
    17f2:	6310                	ld	a2,0(a4)
    17f4:	a83d                	j	1832 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    17f6:	ff852703          	lw	a4,-8(a0)
    17fa:	9f31                	addw	a4,a4,a2
    17fc:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    17fe:	ff053683          	ld	a3,-16(a0)
    1802:	a091                	j	1846 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1804:	6398                	ld	a4,0(a5)
    1806:	00e7e463          	bltu	a5,a4,180e <free+0x3a>
    180a:	00e6ea63          	bltu	a3,a4,181e <free+0x4a>
{
    180e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1810:	fed7fae3          	bgeu	a5,a3,1804 <free+0x30>
    1814:	6398                	ld	a4,0(a5)
    1816:	00e6e463          	bltu	a3,a4,181e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    181a:	fee7eae3          	bltu	a5,a4,180e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    181e:	ff852583          	lw	a1,-8(a0)
    1822:	6390                	ld	a2,0(a5)
    1824:	02059813          	slli	a6,a1,0x20
    1828:	01c85713          	srli	a4,a6,0x1c
    182c:	9736                	add	a4,a4,a3
    182e:	fae60de3          	beq	a2,a4,17e8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1832:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1836:	4790                	lw	a2,8(a5)
    1838:	02061593          	slli	a1,a2,0x20
    183c:	01c5d713          	srli	a4,a1,0x1c
    1840:	973e                	add	a4,a4,a5
    1842:	fae68ae3          	beq	a3,a4,17f6 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1846:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1848:	00001717          	auipc	a4,0x1
    184c:	80f73c23          	sd	a5,-2024(a4) # 2060 <freep>
}
    1850:	6422                	ld	s0,8(sp)
    1852:	0141                	addi	sp,sp,16
    1854:	8082                	ret

0000000000001856 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1856:	7139                	addi	sp,sp,-64
    1858:	fc06                	sd	ra,56(sp)
    185a:	f822                	sd	s0,48(sp)
    185c:	f426                	sd	s1,40(sp)
    185e:	ec4e                	sd	s3,24(sp)
    1860:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1862:	02051493          	slli	s1,a0,0x20
    1866:	9081                	srli	s1,s1,0x20
    1868:	04bd                	addi	s1,s1,15
    186a:	8091                	srli	s1,s1,0x4
    186c:	0014899b          	addiw	s3,s1,1
    1870:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1872:	00000517          	auipc	a0,0x0
    1876:	7ee53503          	ld	a0,2030(a0) # 2060 <freep>
    187a:	c915                	beqz	a0,18ae <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    187c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    187e:	4798                	lw	a4,8(a5)
    1880:	08977a63          	bgeu	a4,s1,1914 <malloc+0xbe>
    1884:	f04a                	sd	s2,32(sp)
    1886:	e852                	sd	s4,16(sp)
    1888:	e456                	sd	s5,8(sp)
    188a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    188c:	8a4e                	mv	s4,s3
    188e:	0009871b          	sext.w	a4,s3
    1892:	6685                	lui	a3,0x1
    1894:	00d77363          	bgeu	a4,a3,189a <malloc+0x44>
    1898:	6a05                	lui	s4,0x1
    189a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    189e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    18a2:	00000917          	auipc	s2,0x0
    18a6:	7be90913          	addi	s2,s2,1982 # 2060 <freep>
  if(p == (char*)-1)
    18aa:	5afd                	li	s5,-1
    18ac:	a081                	j	18ec <malloc+0x96>
    18ae:	f04a                	sd	s2,32(sp)
    18b0:	e852                	sd	s4,16(sp)
    18b2:	e456                	sd	s5,8(sp)
    18b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    18b6:	00000797          	auipc	a5,0x0
    18ba:	7ba78793          	addi	a5,a5,1978 # 2070 <base>
    18be:	00000717          	auipc	a4,0x0
    18c2:	7af73123          	sd	a5,1954(a4) # 2060 <freep>
    18c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    18c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    18cc:	b7c1                	j	188c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    18ce:	6398                	ld	a4,0(a5)
    18d0:	e118                	sd	a4,0(a0)
    18d2:	a8a9                	j	192c <malloc+0xd6>
  hp->s.size = nu;
    18d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    18d8:	0541                	addi	a0,a0,16
    18da:	efbff0ef          	jal	17d4 <free>
  return freep;
    18de:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    18e2:	c12d                	beqz	a0,1944 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    18e6:	4798                	lw	a4,8(a5)
    18e8:	02977263          	bgeu	a4,s1,190c <malloc+0xb6>
    if(p == freep)
    18ec:	00093703          	ld	a4,0(s2)
    18f0:	853e                	mv	a0,a5
    18f2:	fef719e3          	bne	a4,a5,18e4 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    18f6:	8552                	mv	a0,s4
    18f8:	ad3ff0ef          	jal	13ca <sbrk>
  if(p == (char*)-1)
    18fc:	fd551ce3          	bne	a0,s5,18d4 <malloc+0x7e>
        return 0;
    1900:	4501                	li	a0,0
    1902:	7902                	ld	s2,32(sp)
    1904:	6a42                	ld	s4,16(sp)
    1906:	6aa2                	ld	s5,8(sp)
    1908:	6b02                	ld	s6,0(sp)
    190a:	a03d                	j	1938 <malloc+0xe2>
    190c:	7902                	ld	s2,32(sp)
    190e:	6a42                	ld	s4,16(sp)
    1910:	6aa2                	ld	s5,8(sp)
    1912:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1914:	fae48de3          	beq	s1,a4,18ce <malloc+0x78>
        p->s.size -= nunits;
    1918:	4137073b          	subw	a4,a4,s3
    191c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    191e:	02071693          	slli	a3,a4,0x20
    1922:	01c6d713          	srli	a4,a3,0x1c
    1926:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1928:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    192c:	00000717          	auipc	a4,0x0
    1930:	72a73a23          	sd	a0,1844(a4) # 2060 <freep>
      return (void*)(p + 1);
    1934:	01078513          	addi	a0,a5,16
  }
}
    1938:	70e2                	ld	ra,56(sp)
    193a:	7442                	ld	s0,48(sp)
    193c:	74a2                	ld	s1,40(sp)
    193e:	69e2                	ld	s3,24(sp)
    1940:	6121                	addi	sp,sp,64
    1942:	8082                	ret
    1944:	7902                	ld	s2,32(sp)
    1946:	6a42                	ld	s4,16(sp)
    1948:	6aa2                	ld	s5,8(sp)
    194a:	6b02                	ld	s6,0(sp)
    194c:	b7f5                	j	1938 <malloc+0xe2>
	...
