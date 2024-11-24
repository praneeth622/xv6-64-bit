
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <fmtname>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

char*
fmtname(char *path)
{
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	1800                	addi	s0,sp,48
    100a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
    100c:	2b6000ef          	jal	12c2 <strlen>
    1010:	02051793          	slli	a5,a0,0x20
    1014:	9381                	srli	a5,a5,0x20
    1016:	97a6                	add	a5,a5,s1
    1018:	02f00693          	li	a3,47
    101c:	0097e963          	bltu	a5,s1,102e <fmtname+0x2e>
    1020:	0007c703          	lbu	a4,0(a5)
    1024:	00d70563          	beq	a4,a3,102e <fmtname+0x2e>
    1028:	17fd                	addi	a5,a5,-1
    102a:	fe97fbe3          	bgeu	a5,s1,1020 <fmtname+0x20>
    ;
  p++;
    102e:	00178493          	addi	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
    1032:	8526                	mv	a0,s1
    1034:	28e000ef          	jal	12c2 <strlen>
    1038:	2501                	sext.w	a0,a0
    103a:	47b5                	li	a5,13
    103c:	00a7f863          	bgeu	a5,a0,104c <fmtname+0x4c>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
    1040:	8526                	mv	a0,s1
    1042:	70a2                	ld	ra,40(sp)
    1044:	7402                	ld	s0,32(sp)
    1046:	64e2                	ld	s1,24(sp)
    1048:	6145                	addi	sp,sp,48
    104a:	8082                	ret
    104c:	e84a                	sd	s2,16(sp)
    104e:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
    1050:	8526                	mv	a0,s1
    1052:	270000ef          	jal	12c2 <strlen>
    1056:	00001997          	auipc	s3,0x1
    105a:	03a98993          	addi	s3,s3,58 # 2090 <buf.0>
    105e:	0005061b          	sext.w	a2,a0
    1062:	85a6                	mv	a1,s1
    1064:	854e                	mv	a0,s3
    1066:	3be000ef          	jal	1424 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
    106a:	8526                	mv	a0,s1
    106c:	256000ef          	jal	12c2 <strlen>
    1070:	0005091b          	sext.w	s2,a0
    1074:	8526                	mv	a0,s1
    1076:	24c000ef          	jal	12c2 <strlen>
    107a:	1902                	slli	s2,s2,0x20
    107c:	02095913          	srli	s2,s2,0x20
    1080:	4639                	li	a2,14
    1082:	9e09                	subw	a2,a2,a0
    1084:	02000593          	li	a1,32
    1088:	01298533          	add	a0,s3,s2
    108c:	260000ef          	jal	12ec <memset>
  return buf;
    1090:	84ce                	mv	s1,s3
    1092:	6942                	ld	s2,16(sp)
    1094:	69a2                	ld	s3,8(sp)
    1096:	b76d                	j	1040 <fmtname+0x40>

0000000000001098 <ls>:

void
ls(char *path)
{
    1098:	d9010113          	addi	sp,sp,-624
    109c:	26113423          	sd	ra,616(sp)
    10a0:	26813023          	sd	s0,608(sp)
    10a4:	25213823          	sd	s2,592(sp)
    10a8:	1c80                	addi	s0,sp,624
    10aa:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, O_RDONLY)) < 0){
    10ac:	4581                	li	a1,0
    10ae:	464000ef          	jal	1512 <open>
    10b2:	06054363          	bltz	a0,1118 <ls+0x80>
    10b6:	24913c23          	sd	s1,600(sp)
    10ba:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
    10bc:	d9840593          	addi	a1,s0,-616
    10c0:	46a000ef          	jal	152a <fstat>
    10c4:	06054363          	bltz	a0,112a <ls+0x92>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
    10c8:	da041783          	lh	a5,-608(s0)
    10cc:	4705                	li	a4,1
    10ce:	06e78c63          	beq	a5,a4,1146 <ls+0xae>
    10d2:	37f9                	addiw	a5,a5,-2
    10d4:	17c2                	slli	a5,a5,0x30
    10d6:	93c1                	srli	a5,a5,0x30
    10d8:	02f76263          	bltu	a4,a5,10fc <ls+0x64>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %d\n", fmtname(path), st.type, st.ino, (int) st.size);
    10dc:	854a                	mv	a0,s2
    10de:	f23ff0ef          	jal	1000 <fmtname>
    10e2:	85aa                	mv	a1,a0
    10e4:	da842703          	lw	a4,-600(s0)
    10e8:	d9c42683          	lw	a3,-612(s0)
    10ec:	da041603          	lh	a2,-608(s0)
    10f0:	00001517          	auipc	a0,0x1
    10f4:	f4050513          	addi	a0,a0,-192 # 2030 <malloc+0x64a>
    10f8:	03b000ef          	jal	1932 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    }
    break;
  }
  close(fd);
    10fc:	8526                	mv	a0,s1
    10fe:	3fc000ef          	jal	14fa <close>
    1102:	25813483          	ld	s1,600(sp)
}
    1106:	26813083          	ld	ra,616(sp)
    110a:	26013403          	ld	s0,608(sp)
    110e:	25013903          	ld	s2,592(sp)
    1112:	27010113          	addi	sp,sp,624
    1116:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
    1118:	864a                	mv	a2,s2
    111a:	00001597          	auipc	a1,0x1
    111e:	ee658593          	addi	a1,a1,-282 # 2000 <malloc+0x61a>
    1122:	4509                	li	a0,2
    1124:	7e4000ef          	jal	1908 <fprintf>
    return;
    1128:	bff9                	j	1106 <ls+0x6e>
    fprintf(2, "ls: cannot stat %s\n", path);
    112a:	864a                	mv	a2,s2
    112c:	00001597          	auipc	a1,0x1
    1130:	eec58593          	addi	a1,a1,-276 # 2018 <malloc+0x632>
    1134:	4509                	li	a0,2
    1136:	7d2000ef          	jal	1908 <fprintf>
    close(fd);
    113a:	8526                	mv	a0,s1
    113c:	3be000ef          	jal	14fa <close>
    return;
    1140:	25813483          	ld	s1,600(sp)
    1144:	b7c9                	j	1106 <ls+0x6e>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
    1146:	854a                	mv	a0,s2
    1148:	17a000ef          	jal	12c2 <strlen>
    114c:	2541                	addiw	a0,a0,16
    114e:	20000793          	li	a5,512
    1152:	00a7f963          	bgeu	a5,a0,1164 <ls+0xcc>
      printf("ls: path too long\n");
    1156:	00001517          	auipc	a0,0x1
    115a:	eea50513          	addi	a0,a0,-278 # 2040 <malloc+0x65a>
    115e:	7d4000ef          	jal	1932 <printf>
      break;
    1162:	bf69                	j	10fc <ls+0x64>
    1164:	25313423          	sd	s3,584(sp)
    1168:	25413023          	sd	s4,576(sp)
    116c:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
    1170:	85ca                	mv	a1,s2
    1172:	dc040513          	addi	a0,s0,-576
    1176:	104000ef          	jal	127a <strcpy>
    p = buf+strlen(buf);
    117a:	dc040513          	addi	a0,s0,-576
    117e:	144000ef          	jal	12c2 <strlen>
    1182:	1502                	slli	a0,a0,0x20
    1184:	9101                	srli	a0,a0,0x20
    1186:	dc040793          	addi	a5,s0,-576
    118a:	00a78933          	add	s2,a5,a0
    *p++ = '/';
    118e:	00190993          	addi	s3,s2,1
    1192:	02f00793          	li	a5,47
    1196:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    119a:	00001a17          	auipc	s4,0x1
    119e:	e96a0a13          	addi	s4,s4,-362 # 2030 <malloc+0x64a>
        printf("ls: cannot stat %s\n", buf);
    11a2:	00001a97          	auipc	s5,0x1
    11a6:	e76a8a93          	addi	s5,s5,-394 # 2018 <malloc+0x632>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    11aa:	a031                	j	11b6 <ls+0x11e>
        printf("ls: cannot stat %s\n", buf);
    11ac:	dc040593          	addi	a1,s0,-576
    11b0:	8556                	mv	a0,s5
    11b2:	780000ef          	jal	1932 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
    11b6:	4641                	li	a2,16
    11b8:	db040593          	addi	a1,s0,-592
    11bc:	8526                	mv	a0,s1
    11be:	32c000ef          	jal	14ea <read>
    11c2:	47c1                	li	a5,16
    11c4:	04f51463          	bne	a0,a5,120c <ls+0x174>
      if(de.inum == 0)
    11c8:	db045783          	lhu	a5,-592(s0)
    11cc:	d7ed                	beqz	a5,11b6 <ls+0x11e>
      memmove(p, de.name, DIRSIZ);
    11ce:	4639                	li	a2,14
    11d0:	db240593          	addi	a1,s0,-590
    11d4:	854e                	mv	a0,s3
    11d6:	24e000ef          	jal	1424 <memmove>
      p[DIRSIZ] = 0;
    11da:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
    11de:	d9840593          	addi	a1,s0,-616
    11e2:	dc040513          	addi	a0,s0,-576
    11e6:	1bc000ef          	jal	13a2 <stat>
    11ea:	fc0541e3          	bltz	a0,11ac <ls+0x114>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, (int) st.size);
    11ee:	dc040513          	addi	a0,s0,-576
    11f2:	e0fff0ef          	jal	1000 <fmtname>
    11f6:	85aa                	mv	a1,a0
    11f8:	da842703          	lw	a4,-600(s0)
    11fc:	d9c42683          	lw	a3,-612(s0)
    1200:	da041603          	lh	a2,-608(s0)
    1204:	8552                	mv	a0,s4
    1206:	72c000ef          	jal	1932 <printf>
    120a:	b775                	j	11b6 <ls+0x11e>
    120c:	24813983          	ld	s3,584(sp)
    1210:	24013a03          	ld	s4,576(sp)
    1214:	23813a83          	ld	s5,568(sp)
    1218:	b5d5                	j	10fc <ls+0x64>

000000000000121a <main>:

int
main(int argc, char *argv[])
{
    121a:	1101                	addi	sp,sp,-32
    121c:	ec06                	sd	ra,24(sp)
    121e:	e822                	sd	s0,16(sp)
    1220:	1000                	addi	s0,sp,32
  int i;

  if(argc < 2){
    1222:	4785                	li	a5,1
    1224:	02a7d763          	bge	a5,a0,1252 <main+0x38>
    1228:	e426                	sd	s1,8(sp)
    122a:	e04a                	sd	s2,0(sp)
    122c:	00858493          	addi	s1,a1,8
    1230:	ffe5091b          	addiw	s2,a0,-2
    1234:	02091793          	slli	a5,s2,0x20
    1238:	01d7d913          	srli	s2,a5,0x1d
    123c:	05c1                	addi	a1,a1,16
    123e:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
    1240:	6088                	ld	a0,0(s1)
    1242:	e57ff0ef          	jal	1098 <ls>
  for(i=1; i<argc; i++)
    1246:	04a1                	addi	s1,s1,8
    1248:	ff249ce3          	bne	s1,s2,1240 <main+0x26>
  exit(0);
    124c:	4501                	li	a0,0
    124e:	284000ef          	jal	14d2 <exit>
    1252:	e426                	sd	s1,8(sp)
    1254:	e04a                	sd	s2,0(sp)
    ls(".");
    1256:	00001517          	auipc	a0,0x1
    125a:	e0250513          	addi	a0,a0,-510 # 2058 <malloc+0x672>
    125e:	e3bff0ef          	jal	1098 <ls>
    exit(0);
    1262:	4501                	li	a0,0
    1264:	26e000ef          	jal	14d2 <exit>

0000000000001268 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    1268:	1141                	addi	sp,sp,-16
    126a:	e406                	sd	ra,8(sp)
    126c:	e022                	sd	s0,0(sp)
    126e:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1270:	fabff0ef          	jal	121a <main>
  exit(0);
    1274:	4501                	li	a0,0
    1276:	25c000ef          	jal	14d2 <exit>

000000000000127a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    127a:	1141                	addi	sp,sp,-16
    127c:	e422                	sd	s0,8(sp)
    127e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1280:	87aa                	mv	a5,a0
    1282:	0585                	addi	a1,a1,1
    1284:	0785                	addi	a5,a5,1
    1286:	fff5c703          	lbu	a4,-1(a1)
    128a:	fee78fa3          	sb	a4,-1(a5)
    128e:	fb75                	bnez	a4,1282 <strcpy+0x8>
    ;
  return os;
}
    1290:	6422                	ld	s0,8(sp)
    1292:	0141                	addi	sp,sp,16
    1294:	8082                	ret

0000000000001296 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1296:	1141                	addi	sp,sp,-16
    1298:	e422                	sd	s0,8(sp)
    129a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    129c:	00054783          	lbu	a5,0(a0)
    12a0:	cb91                	beqz	a5,12b4 <strcmp+0x1e>
    12a2:	0005c703          	lbu	a4,0(a1)
    12a6:	00f71763          	bne	a4,a5,12b4 <strcmp+0x1e>
    p++, q++;
    12aa:	0505                	addi	a0,a0,1
    12ac:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    12ae:	00054783          	lbu	a5,0(a0)
    12b2:	fbe5                	bnez	a5,12a2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    12b4:	0005c503          	lbu	a0,0(a1)
}
    12b8:	40a7853b          	subw	a0,a5,a0
    12bc:	6422                	ld	s0,8(sp)
    12be:	0141                	addi	sp,sp,16
    12c0:	8082                	ret

00000000000012c2 <strlen>:

uint
strlen(const char *s)
{
    12c2:	1141                	addi	sp,sp,-16
    12c4:	e422                	sd	s0,8(sp)
    12c6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    12c8:	00054783          	lbu	a5,0(a0)
    12cc:	cf91                	beqz	a5,12e8 <strlen+0x26>
    12ce:	0505                	addi	a0,a0,1
    12d0:	87aa                	mv	a5,a0
    12d2:	86be                	mv	a3,a5
    12d4:	0785                	addi	a5,a5,1
    12d6:	fff7c703          	lbu	a4,-1(a5)
    12da:	ff65                	bnez	a4,12d2 <strlen+0x10>
    12dc:	40a6853b          	subw	a0,a3,a0
    12e0:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    12e2:	6422                	ld	s0,8(sp)
    12e4:	0141                	addi	sp,sp,16
    12e6:	8082                	ret
  for(n = 0; s[n]; n++)
    12e8:	4501                	li	a0,0
    12ea:	bfe5                	j	12e2 <strlen+0x20>

00000000000012ec <memset>:

void*
memset(void *dst, int c, uint n)
{
    12ec:	1141                	addi	sp,sp,-16
    12ee:	e422                	sd	s0,8(sp)
    12f0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    12f2:	ca19                	beqz	a2,1308 <memset+0x1c>
    12f4:	87aa                	mv	a5,a0
    12f6:	1602                	slli	a2,a2,0x20
    12f8:	9201                	srli	a2,a2,0x20
    12fa:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    12fe:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1302:	0785                	addi	a5,a5,1
    1304:	fee79de3          	bne	a5,a4,12fe <memset+0x12>
  }
  return dst;
}
    1308:	6422                	ld	s0,8(sp)
    130a:	0141                	addi	sp,sp,16
    130c:	8082                	ret

000000000000130e <strchr>:

char*
strchr(const char *s, char c)
{
    130e:	1141                	addi	sp,sp,-16
    1310:	e422                	sd	s0,8(sp)
    1312:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1314:	00054783          	lbu	a5,0(a0)
    1318:	cb99                	beqz	a5,132e <strchr+0x20>
    if(*s == c)
    131a:	00f58763          	beq	a1,a5,1328 <strchr+0x1a>
  for(; *s; s++)
    131e:	0505                	addi	a0,a0,1
    1320:	00054783          	lbu	a5,0(a0)
    1324:	fbfd                	bnez	a5,131a <strchr+0xc>
      return (char*)s;
  return 0;
    1326:	4501                	li	a0,0
}
    1328:	6422                	ld	s0,8(sp)
    132a:	0141                	addi	sp,sp,16
    132c:	8082                	ret
  return 0;
    132e:	4501                	li	a0,0
    1330:	bfe5                	j	1328 <strchr+0x1a>

0000000000001332 <gets>:

char*
gets(char *buf, int max)
{
    1332:	711d                	addi	sp,sp,-96
    1334:	ec86                	sd	ra,88(sp)
    1336:	e8a2                	sd	s0,80(sp)
    1338:	e4a6                	sd	s1,72(sp)
    133a:	e0ca                	sd	s2,64(sp)
    133c:	fc4e                	sd	s3,56(sp)
    133e:	f852                	sd	s4,48(sp)
    1340:	f456                	sd	s5,40(sp)
    1342:	f05a                	sd	s6,32(sp)
    1344:	ec5e                	sd	s7,24(sp)
    1346:	1080                	addi	s0,sp,96
    1348:	8baa                	mv	s7,a0
    134a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    134c:	892a                	mv	s2,a0
    134e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1350:	4aa9                	li	s5,10
    1352:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1354:	89a6                	mv	s3,s1
    1356:	2485                	addiw	s1,s1,1
    1358:	0344d663          	bge	s1,s4,1384 <gets+0x52>
    cc = read(0, &c, 1);
    135c:	4605                	li	a2,1
    135e:	faf40593          	addi	a1,s0,-81
    1362:	4501                	li	a0,0
    1364:	186000ef          	jal	14ea <read>
    if(cc < 1)
    1368:	00a05e63          	blez	a0,1384 <gets+0x52>
    buf[i++] = c;
    136c:	faf44783          	lbu	a5,-81(s0)
    1370:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1374:	01578763          	beq	a5,s5,1382 <gets+0x50>
    1378:	0905                	addi	s2,s2,1
    137a:	fd679de3          	bne	a5,s6,1354 <gets+0x22>
    buf[i++] = c;
    137e:	89a6                	mv	s3,s1
    1380:	a011                	j	1384 <gets+0x52>
    1382:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1384:	99de                	add	s3,s3,s7
    1386:	00098023          	sb	zero,0(s3)
  return buf;
}
    138a:	855e                	mv	a0,s7
    138c:	60e6                	ld	ra,88(sp)
    138e:	6446                	ld	s0,80(sp)
    1390:	64a6                	ld	s1,72(sp)
    1392:	6906                	ld	s2,64(sp)
    1394:	79e2                	ld	s3,56(sp)
    1396:	7a42                	ld	s4,48(sp)
    1398:	7aa2                	ld	s5,40(sp)
    139a:	7b02                	ld	s6,32(sp)
    139c:	6be2                	ld	s7,24(sp)
    139e:	6125                	addi	sp,sp,96
    13a0:	8082                	ret

00000000000013a2 <stat>:

int
stat(const char *n, struct stat *st)
{
    13a2:	1101                	addi	sp,sp,-32
    13a4:	ec06                	sd	ra,24(sp)
    13a6:	e822                	sd	s0,16(sp)
    13a8:	e04a                	sd	s2,0(sp)
    13aa:	1000                	addi	s0,sp,32
    13ac:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13ae:	4581                	li	a1,0
    13b0:	162000ef          	jal	1512 <open>
  if(fd < 0)
    13b4:	02054263          	bltz	a0,13d8 <stat+0x36>
    13b8:	e426                	sd	s1,8(sp)
    13ba:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    13bc:	85ca                	mv	a1,s2
    13be:	16c000ef          	jal	152a <fstat>
    13c2:	892a                	mv	s2,a0
  close(fd);
    13c4:	8526                	mv	a0,s1
    13c6:	134000ef          	jal	14fa <close>
  return r;
    13ca:	64a2                	ld	s1,8(sp)
}
    13cc:	854a                	mv	a0,s2
    13ce:	60e2                	ld	ra,24(sp)
    13d0:	6442                	ld	s0,16(sp)
    13d2:	6902                	ld	s2,0(sp)
    13d4:	6105                	addi	sp,sp,32
    13d6:	8082                	ret
    return -1;
    13d8:	597d                	li	s2,-1
    13da:	bfcd                	j	13cc <stat+0x2a>

00000000000013dc <atoi>:

int
atoi(const char *s)
{
    13dc:	1141                	addi	sp,sp,-16
    13de:	e422                	sd	s0,8(sp)
    13e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13e2:	00054683          	lbu	a3,0(a0)
    13e6:	fd06879b          	addiw	a5,a3,-48
    13ea:	0ff7f793          	zext.b	a5,a5
    13ee:	4625                	li	a2,9
    13f0:	02f66863          	bltu	a2,a5,1420 <atoi+0x44>
    13f4:	872a                	mv	a4,a0
  n = 0;
    13f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    13f8:	0705                	addi	a4,a4,1
    13fa:	0025179b          	slliw	a5,a0,0x2
    13fe:	9fa9                	addw	a5,a5,a0
    1400:	0017979b          	slliw	a5,a5,0x1
    1404:	9fb5                	addw	a5,a5,a3
    1406:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    140a:	00074683          	lbu	a3,0(a4)
    140e:	fd06879b          	addiw	a5,a3,-48
    1412:	0ff7f793          	zext.b	a5,a5
    1416:	fef671e3          	bgeu	a2,a5,13f8 <atoi+0x1c>
  return n;
}
    141a:	6422                	ld	s0,8(sp)
    141c:	0141                	addi	sp,sp,16
    141e:	8082                	ret
  n = 0;
    1420:	4501                	li	a0,0
    1422:	bfe5                	j	141a <atoi+0x3e>

0000000000001424 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1424:	1141                	addi	sp,sp,-16
    1426:	e422                	sd	s0,8(sp)
    1428:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    142a:	02b57463          	bgeu	a0,a1,1452 <memmove+0x2e>
    while(n-- > 0)
    142e:	00c05f63          	blez	a2,144c <memmove+0x28>
    1432:	1602                	slli	a2,a2,0x20
    1434:	9201                	srli	a2,a2,0x20
    1436:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    143a:	872a                	mv	a4,a0
      *dst++ = *src++;
    143c:	0585                	addi	a1,a1,1
    143e:	0705                	addi	a4,a4,1
    1440:	fff5c683          	lbu	a3,-1(a1)
    1444:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1448:	fef71ae3          	bne	a4,a5,143c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    144c:	6422                	ld	s0,8(sp)
    144e:	0141                	addi	sp,sp,16
    1450:	8082                	ret
    dst += n;
    1452:	00c50733          	add	a4,a0,a2
    src += n;
    1456:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1458:	fec05ae3          	blez	a2,144c <memmove+0x28>
    145c:	fff6079b          	addiw	a5,a2,-1
    1460:	1782                	slli	a5,a5,0x20
    1462:	9381                	srli	a5,a5,0x20
    1464:	fff7c793          	not	a5,a5
    1468:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    146a:	15fd                	addi	a1,a1,-1
    146c:	177d                	addi	a4,a4,-1
    146e:	0005c683          	lbu	a3,0(a1)
    1472:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1476:	fee79ae3          	bne	a5,a4,146a <memmove+0x46>
    147a:	bfc9                	j	144c <memmove+0x28>

000000000000147c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    147c:	1141                	addi	sp,sp,-16
    147e:	e422                	sd	s0,8(sp)
    1480:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1482:	ca05                	beqz	a2,14b2 <memcmp+0x36>
    1484:	fff6069b          	addiw	a3,a2,-1
    1488:	1682                	slli	a3,a3,0x20
    148a:	9281                	srli	a3,a3,0x20
    148c:	0685                	addi	a3,a3,1
    148e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1490:	00054783          	lbu	a5,0(a0)
    1494:	0005c703          	lbu	a4,0(a1)
    1498:	00e79863          	bne	a5,a4,14a8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    149c:	0505                	addi	a0,a0,1
    p2++;
    149e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    14a0:	fed518e3          	bne	a0,a3,1490 <memcmp+0x14>
  }
  return 0;
    14a4:	4501                	li	a0,0
    14a6:	a019                	j	14ac <memcmp+0x30>
      return *p1 - *p2;
    14a8:	40e7853b          	subw	a0,a5,a4
}
    14ac:	6422                	ld	s0,8(sp)
    14ae:	0141                	addi	sp,sp,16
    14b0:	8082                	ret
  return 0;
    14b2:	4501                	li	a0,0
    14b4:	bfe5                	j	14ac <memcmp+0x30>

00000000000014b6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    14b6:	1141                	addi	sp,sp,-16
    14b8:	e406                	sd	ra,8(sp)
    14ba:	e022                	sd	s0,0(sp)
    14bc:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    14be:	f67ff0ef          	jal	1424 <memmove>
}
    14c2:	60a2                	ld	ra,8(sp)
    14c4:	6402                	ld	s0,0(sp)
    14c6:	0141                	addi	sp,sp,16
    14c8:	8082                	ret

00000000000014ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    14ca:	4885                	li	a7,1
 ecall
    14cc:	00000073          	ecall
 ret
    14d0:	8082                	ret

00000000000014d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
    14d2:	4889                	li	a7,2
 ecall
    14d4:	00000073          	ecall
 ret
    14d8:	8082                	ret

00000000000014da <wait>:
.global wait
wait:
 li a7, SYS_wait
    14da:	488d                	li	a7,3
 ecall
    14dc:	00000073          	ecall
 ret
    14e0:	8082                	ret

00000000000014e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    14e2:	4891                	li	a7,4
 ecall
    14e4:	00000073          	ecall
 ret
    14e8:	8082                	ret

00000000000014ea <read>:
.global read
read:
 li a7, SYS_read
    14ea:	4895                	li	a7,5
 ecall
    14ec:	00000073          	ecall
 ret
    14f0:	8082                	ret

00000000000014f2 <write>:
.global write
write:
 li a7, SYS_write
    14f2:	48c1                	li	a7,16
 ecall
    14f4:	00000073          	ecall
 ret
    14f8:	8082                	ret

00000000000014fa <close>:
.global close
close:
 li a7, SYS_close
    14fa:	48d5                	li	a7,21
 ecall
    14fc:	00000073          	ecall
 ret
    1500:	8082                	ret

0000000000001502 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1502:	4899                	li	a7,6
 ecall
    1504:	00000073          	ecall
 ret
    1508:	8082                	ret

000000000000150a <exec>:
.global exec
exec:
 li a7, SYS_exec
    150a:	489d                	li	a7,7
 ecall
    150c:	00000073          	ecall
 ret
    1510:	8082                	ret

0000000000001512 <open>:
.global open
open:
 li a7, SYS_open
    1512:	48bd                	li	a7,15
 ecall
    1514:	00000073          	ecall
 ret
    1518:	8082                	ret

000000000000151a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    151a:	48c5                	li	a7,17
 ecall
    151c:	00000073          	ecall
 ret
    1520:	8082                	ret

0000000000001522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1522:	48c9                	li	a7,18
 ecall
    1524:	00000073          	ecall
 ret
    1528:	8082                	ret

000000000000152a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    152a:	48a1                	li	a7,8
 ecall
    152c:	00000073          	ecall
 ret
    1530:	8082                	ret

0000000000001532 <link>:
.global link
link:
 li a7, SYS_link
    1532:	48cd                	li	a7,19
 ecall
    1534:	00000073          	ecall
 ret
    1538:	8082                	ret

000000000000153a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    153a:	48d1                	li	a7,20
 ecall
    153c:	00000073          	ecall
 ret
    1540:	8082                	ret

0000000000001542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1542:	48a5                	li	a7,9
 ecall
    1544:	00000073          	ecall
 ret
    1548:	8082                	ret

000000000000154a <dup>:
.global dup
dup:
 li a7, SYS_dup
    154a:	48a9                	li	a7,10
 ecall
    154c:	00000073          	ecall
 ret
    1550:	8082                	ret

0000000000001552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1552:	48ad                	li	a7,11
 ecall
    1554:	00000073          	ecall
 ret
    1558:	8082                	ret

000000000000155a <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    155a:	48b1                	li	a7,12
 ecall
    155c:	00000073          	ecall
 ret
    1560:	8082                	ret

0000000000001562 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1562:	48b5                	li	a7,13
 ecall
    1564:	00000073          	ecall
 ret
    1568:	8082                	ret

000000000000156a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    156a:	48b9                	li	a7,14
 ecall
    156c:	00000073          	ecall
 ret
    1570:	8082                	ret

0000000000001572 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1572:	48d9                	li	a7,22
 ecall
    1574:	00000073          	ecall
 ret
    1578:	8082                	ret

000000000000157a <signal>:
.global signal
signal:
 li a7, SYS_signal
    157a:	48dd                	li	a7,23
 ecall
    157c:	00000073          	ecall
 ret
    1580:	8082                	ret

0000000000001582 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1582:	48e1                	li	a7,24
 ecall
    1584:	00000073          	ecall
 ret
    1588:	8082                	ret

000000000000158a <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    158a:	48e5                	li	a7,25
 ecall
    158c:	00000073          	ecall
 ret
    1590:	8082                	ret

0000000000001592 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1592:	48e9                	li	a7,26
 ecall
    1594:	00000073          	ecall
 ret
    1598:	8082                	ret

000000000000159a <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    159a:	48ed                	li	a7,27
 ecall
    159c:	00000073          	ecall
 ret
    15a0:	8082                	ret

00000000000015a2 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    15a2:	48f1                	li	a7,28
 ecall
    15a4:	00000073          	ecall
 ret
    15a8:	8082                	ret

00000000000015aa <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    15aa:	48f5                	li	a7,29
 ecall
    15ac:	00000073          	ecall
 ret
    15b0:	8082                	ret

00000000000015b2 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    15b2:	48f9                	li	a7,30
 ecall
    15b4:	00000073          	ecall
 ret
    15b8:	8082                	ret

00000000000015ba <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    15ba:	1101                	addi	sp,sp,-32
    15bc:	ec06                	sd	ra,24(sp)
    15be:	e822                	sd	s0,16(sp)
    15c0:	1000                	addi	s0,sp,32
    15c2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    15c6:	4605                	li	a2,1
    15c8:	fef40593          	addi	a1,s0,-17
    15cc:	f27ff0ef          	jal	14f2 <write>
}
    15d0:	60e2                	ld	ra,24(sp)
    15d2:	6442                	ld	s0,16(sp)
    15d4:	6105                	addi	sp,sp,32
    15d6:	8082                	ret

00000000000015d8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    15d8:	7139                	addi	sp,sp,-64
    15da:	fc06                	sd	ra,56(sp)
    15dc:	f822                	sd	s0,48(sp)
    15de:	f426                	sd	s1,40(sp)
    15e0:	0080                	addi	s0,sp,64
    15e2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    15e4:	c299                	beqz	a3,15ea <printint+0x12>
    15e6:	0805c963          	bltz	a1,1678 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    15ea:	2581                	sext.w	a1,a1
  neg = 0;
    15ec:	4881                	li	a7,0
    15ee:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    15f2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    15f4:	2601                	sext.w	a2,a2
    15f6:	00001517          	auipc	a0,0x1
    15fa:	a7250513          	addi	a0,a0,-1422 # 2068 <digits>
    15fe:	883a                	mv	a6,a4
    1600:	2705                	addiw	a4,a4,1
    1602:	02c5f7bb          	remuw	a5,a1,a2
    1606:	1782                	slli	a5,a5,0x20
    1608:	9381                	srli	a5,a5,0x20
    160a:	97aa                	add	a5,a5,a0
    160c:	0007c783          	lbu	a5,0(a5)
    1610:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1614:	0005879b          	sext.w	a5,a1
    1618:	02c5d5bb          	divuw	a1,a1,a2
    161c:	0685                	addi	a3,a3,1
    161e:	fec7f0e3          	bgeu	a5,a2,15fe <printint+0x26>
  if(neg)
    1622:	00088c63          	beqz	a7,163a <printint+0x62>
    buf[i++] = '-';
    1626:	fd070793          	addi	a5,a4,-48
    162a:	00878733          	add	a4,a5,s0
    162e:	02d00793          	li	a5,45
    1632:	fef70823          	sb	a5,-16(a4)
    1636:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    163a:	02e05a63          	blez	a4,166e <printint+0x96>
    163e:	f04a                	sd	s2,32(sp)
    1640:	ec4e                	sd	s3,24(sp)
    1642:	fc040793          	addi	a5,s0,-64
    1646:	00e78933          	add	s2,a5,a4
    164a:	fff78993          	addi	s3,a5,-1
    164e:	99ba                	add	s3,s3,a4
    1650:	377d                	addiw	a4,a4,-1
    1652:	1702                	slli	a4,a4,0x20
    1654:	9301                	srli	a4,a4,0x20
    1656:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    165a:	fff94583          	lbu	a1,-1(s2)
    165e:	8526                	mv	a0,s1
    1660:	f5bff0ef          	jal	15ba <putc>
  while(--i >= 0)
    1664:	197d                	addi	s2,s2,-1
    1666:	ff391ae3          	bne	s2,s3,165a <printint+0x82>
    166a:	7902                	ld	s2,32(sp)
    166c:	69e2                	ld	s3,24(sp)
}
    166e:	70e2                	ld	ra,56(sp)
    1670:	7442                	ld	s0,48(sp)
    1672:	74a2                	ld	s1,40(sp)
    1674:	6121                	addi	sp,sp,64
    1676:	8082                	ret
    x = -xx;
    1678:	40b005bb          	negw	a1,a1
    neg = 1;
    167c:	4885                	li	a7,1
    x = -xx;
    167e:	bf85                	j	15ee <printint+0x16>

0000000000001680 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1680:	711d                	addi	sp,sp,-96
    1682:	ec86                	sd	ra,88(sp)
    1684:	e8a2                	sd	s0,80(sp)
    1686:	e0ca                	sd	s2,64(sp)
    1688:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    168a:	0005c903          	lbu	s2,0(a1)
    168e:	26090863          	beqz	s2,18fe <vprintf+0x27e>
    1692:	e4a6                	sd	s1,72(sp)
    1694:	fc4e                	sd	s3,56(sp)
    1696:	f852                	sd	s4,48(sp)
    1698:	f456                	sd	s5,40(sp)
    169a:	f05a                	sd	s6,32(sp)
    169c:	ec5e                	sd	s7,24(sp)
    169e:	e862                	sd	s8,16(sp)
    16a0:	e466                	sd	s9,8(sp)
    16a2:	8b2a                	mv	s6,a0
    16a4:	8a2e                	mv	s4,a1
    16a6:	8bb2                	mv	s7,a2
  state = 0;
    16a8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    16aa:	4481                	li	s1,0
    16ac:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    16ae:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    16b2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    16b6:	06c00c93          	li	s9,108
    16ba:	a005                	j	16da <vprintf+0x5a>
        putc(fd, c0);
    16bc:	85ca                	mv	a1,s2
    16be:	855a                	mv	a0,s6
    16c0:	efbff0ef          	jal	15ba <putc>
    16c4:	a019                	j	16ca <vprintf+0x4a>
    } else if(state == '%'){
    16c6:	03598263          	beq	s3,s5,16ea <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    16ca:	2485                	addiw	s1,s1,1
    16cc:	8726                	mv	a4,s1
    16ce:	009a07b3          	add	a5,s4,s1
    16d2:	0007c903          	lbu	s2,0(a5)
    16d6:	20090c63          	beqz	s2,18ee <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    16da:	0009079b          	sext.w	a5,s2
    if(state == 0){
    16de:	fe0994e3          	bnez	s3,16c6 <vprintf+0x46>
      if(c0 == '%'){
    16e2:	fd579de3          	bne	a5,s5,16bc <vprintf+0x3c>
        state = '%';
    16e6:	89be                	mv	s3,a5
    16e8:	b7cd                	j	16ca <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    16ea:	00ea06b3          	add	a3,s4,a4
    16ee:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    16f2:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    16f4:	c681                	beqz	a3,16fc <vprintf+0x7c>
    16f6:	9752                	add	a4,a4,s4
    16f8:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    16fc:	03878f63          	beq	a5,s8,173a <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1700:	05978963          	beq	a5,s9,1752 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1704:	07500713          	li	a4,117
    1708:	0ee78363          	beq	a5,a4,17ee <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    170c:	07800713          	li	a4,120
    1710:	12e78563          	beq	a5,a4,183a <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1714:	07000713          	li	a4,112
    1718:	14e78a63          	beq	a5,a4,186c <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    171c:	07300713          	li	a4,115
    1720:	18e78a63          	beq	a5,a4,18b4 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1724:	02500713          	li	a4,37
    1728:	04e79563          	bne	a5,a4,1772 <vprintf+0xf2>
        putc(fd, '%');
    172c:	02500593          	li	a1,37
    1730:	855a                	mv	a0,s6
    1732:	e89ff0ef          	jal	15ba <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1736:	4981                	li	s3,0
    1738:	bf49                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    173a:	008b8913          	addi	s2,s7,8
    173e:	4685                	li	a3,1
    1740:	4629                	li	a2,10
    1742:	000ba583          	lw	a1,0(s7)
    1746:	855a                	mv	a0,s6
    1748:	e91ff0ef          	jal	15d8 <printint>
    174c:	8bca                	mv	s7,s2
      state = 0;
    174e:	4981                	li	s3,0
    1750:	bfad                	j	16ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1752:	06400793          	li	a5,100
    1756:	02f68963          	beq	a3,a5,1788 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    175a:	06c00793          	li	a5,108
    175e:	04f68263          	beq	a3,a5,17a2 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1762:	07500793          	li	a5,117
    1766:	0af68063          	beq	a3,a5,1806 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    176a:	07800793          	li	a5,120
    176e:	0ef68263          	beq	a3,a5,1852 <vprintf+0x1d2>
        putc(fd, '%');
    1772:	02500593          	li	a1,37
    1776:	855a                	mv	a0,s6
    1778:	e43ff0ef          	jal	15ba <putc>
        putc(fd, c0);
    177c:	85ca                	mv	a1,s2
    177e:	855a                	mv	a0,s6
    1780:	e3bff0ef          	jal	15ba <putc>
      state = 0;
    1784:	4981                	li	s3,0
    1786:	b791                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1788:	008b8913          	addi	s2,s7,8
    178c:	4685                	li	a3,1
    178e:	4629                	li	a2,10
    1790:	000ba583          	lw	a1,0(s7)
    1794:	855a                	mv	a0,s6
    1796:	e43ff0ef          	jal	15d8 <printint>
        i += 1;
    179a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    179c:	8bca                	mv	s7,s2
      state = 0;
    179e:	4981                	li	s3,0
        i += 1;
    17a0:	b72d                	j	16ca <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    17a2:	06400793          	li	a5,100
    17a6:	02f60763          	beq	a2,a5,17d4 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    17aa:	07500793          	li	a5,117
    17ae:	06f60963          	beq	a2,a5,1820 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    17b2:	07800793          	li	a5,120
    17b6:	faf61ee3          	bne	a2,a5,1772 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    17ba:	008b8913          	addi	s2,s7,8
    17be:	4681                	li	a3,0
    17c0:	4641                	li	a2,16
    17c2:	000ba583          	lw	a1,0(s7)
    17c6:	855a                	mv	a0,s6
    17c8:	e11ff0ef          	jal	15d8 <printint>
        i += 2;
    17cc:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    17ce:	8bca                	mv	s7,s2
      state = 0;
    17d0:	4981                	li	s3,0
        i += 2;
    17d2:	bde5                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    17d4:	008b8913          	addi	s2,s7,8
    17d8:	4685                	li	a3,1
    17da:	4629                	li	a2,10
    17dc:	000ba583          	lw	a1,0(s7)
    17e0:	855a                	mv	a0,s6
    17e2:	df7ff0ef          	jal	15d8 <printint>
        i += 2;
    17e6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    17e8:	8bca                	mv	s7,s2
      state = 0;
    17ea:	4981                	li	s3,0
        i += 2;
    17ec:	bdf9                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    17ee:	008b8913          	addi	s2,s7,8
    17f2:	4681                	li	a3,0
    17f4:	4629                	li	a2,10
    17f6:	000ba583          	lw	a1,0(s7)
    17fa:	855a                	mv	a0,s6
    17fc:	dddff0ef          	jal	15d8 <printint>
    1800:	8bca                	mv	s7,s2
      state = 0;
    1802:	4981                	li	s3,0
    1804:	b5d9                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1806:	008b8913          	addi	s2,s7,8
    180a:	4681                	li	a3,0
    180c:	4629                	li	a2,10
    180e:	000ba583          	lw	a1,0(s7)
    1812:	855a                	mv	a0,s6
    1814:	dc5ff0ef          	jal	15d8 <printint>
        i += 1;
    1818:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    181a:	8bca                	mv	s7,s2
      state = 0;
    181c:	4981                	li	s3,0
        i += 1;
    181e:	b575                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1820:	008b8913          	addi	s2,s7,8
    1824:	4681                	li	a3,0
    1826:	4629                	li	a2,10
    1828:	000ba583          	lw	a1,0(s7)
    182c:	855a                	mv	a0,s6
    182e:	dabff0ef          	jal	15d8 <printint>
        i += 2;
    1832:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1834:	8bca                	mv	s7,s2
      state = 0;
    1836:	4981                	li	s3,0
        i += 2;
    1838:	bd49                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    183a:	008b8913          	addi	s2,s7,8
    183e:	4681                	li	a3,0
    1840:	4641                	li	a2,16
    1842:	000ba583          	lw	a1,0(s7)
    1846:	855a                	mv	a0,s6
    1848:	d91ff0ef          	jal	15d8 <printint>
    184c:	8bca                	mv	s7,s2
      state = 0;
    184e:	4981                	li	s3,0
    1850:	bdad                	j	16ca <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1852:	008b8913          	addi	s2,s7,8
    1856:	4681                	li	a3,0
    1858:	4641                	li	a2,16
    185a:	000ba583          	lw	a1,0(s7)
    185e:	855a                	mv	a0,s6
    1860:	d79ff0ef          	jal	15d8 <printint>
        i += 1;
    1864:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1866:	8bca                	mv	s7,s2
      state = 0;
    1868:	4981                	li	s3,0
        i += 1;
    186a:	b585                	j	16ca <vprintf+0x4a>
    186c:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    186e:	008b8d13          	addi	s10,s7,8
    1872:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1876:	03000593          	li	a1,48
    187a:	855a                	mv	a0,s6
    187c:	d3fff0ef          	jal	15ba <putc>
  putc(fd, 'x');
    1880:	07800593          	li	a1,120
    1884:	855a                	mv	a0,s6
    1886:	d35ff0ef          	jal	15ba <putc>
    188a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    188c:	00000b97          	auipc	s7,0x0
    1890:	7dcb8b93          	addi	s7,s7,2012 # 2068 <digits>
    1894:	03c9d793          	srli	a5,s3,0x3c
    1898:	97de                	add	a5,a5,s7
    189a:	0007c583          	lbu	a1,0(a5)
    189e:	855a                	mv	a0,s6
    18a0:	d1bff0ef          	jal	15ba <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    18a4:	0992                	slli	s3,s3,0x4
    18a6:	397d                	addiw	s2,s2,-1
    18a8:	fe0916e3          	bnez	s2,1894 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    18ac:	8bea                	mv	s7,s10
      state = 0;
    18ae:	4981                	li	s3,0
    18b0:	6d02                	ld	s10,0(sp)
    18b2:	bd21                	j	16ca <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    18b4:	008b8993          	addi	s3,s7,8
    18b8:	000bb903          	ld	s2,0(s7)
    18bc:	00090f63          	beqz	s2,18da <vprintf+0x25a>
        for(; *s; s++)
    18c0:	00094583          	lbu	a1,0(s2)
    18c4:	c195                	beqz	a1,18e8 <vprintf+0x268>
          putc(fd, *s);
    18c6:	855a                	mv	a0,s6
    18c8:	cf3ff0ef          	jal	15ba <putc>
        for(; *s; s++)
    18cc:	0905                	addi	s2,s2,1
    18ce:	00094583          	lbu	a1,0(s2)
    18d2:	f9f5                	bnez	a1,18c6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    18d4:	8bce                	mv	s7,s3
      state = 0;
    18d6:	4981                	li	s3,0
    18d8:	bbcd                	j	16ca <vprintf+0x4a>
          s = "(null)";
    18da:	00000917          	auipc	s2,0x0
    18de:	78690913          	addi	s2,s2,1926 # 2060 <malloc+0x67a>
        for(; *s; s++)
    18e2:	02800593          	li	a1,40
    18e6:	b7c5                	j	18c6 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    18e8:	8bce                	mv	s7,s3
      state = 0;
    18ea:	4981                	li	s3,0
    18ec:	bbf9                	j	16ca <vprintf+0x4a>
    18ee:	64a6                	ld	s1,72(sp)
    18f0:	79e2                	ld	s3,56(sp)
    18f2:	7a42                	ld	s4,48(sp)
    18f4:	7aa2                	ld	s5,40(sp)
    18f6:	7b02                	ld	s6,32(sp)
    18f8:	6be2                	ld	s7,24(sp)
    18fa:	6c42                	ld	s8,16(sp)
    18fc:	6ca2                	ld	s9,8(sp)
    }
  }
}
    18fe:	60e6                	ld	ra,88(sp)
    1900:	6446                	ld	s0,80(sp)
    1902:	6906                	ld	s2,64(sp)
    1904:	6125                	addi	sp,sp,96
    1906:	8082                	ret

0000000000001908 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1908:	715d                	addi	sp,sp,-80
    190a:	ec06                	sd	ra,24(sp)
    190c:	e822                	sd	s0,16(sp)
    190e:	1000                	addi	s0,sp,32
    1910:	e010                	sd	a2,0(s0)
    1912:	e414                	sd	a3,8(s0)
    1914:	e818                	sd	a4,16(s0)
    1916:	ec1c                	sd	a5,24(s0)
    1918:	03043023          	sd	a6,32(s0)
    191c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1920:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1924:	8622                	mv	a2,s0
    1926:	d5bff0ef          	jal	1680 <vprintf>
}
    192a:	60e2                	ld	ra,24(sp)
    192c:	6442                	ld	s0,16(sp)
    192e:	6161                	addi	sp,sp,80
    1930:	8082                	ret

0000000000001932 <printf>:

void
printf(const char *fmt, ...)
{
    1932:	711d                	addi	sp,sp,-96
    1934:	ec06                	sd	ra,24(sp)
    1936:	e822                	sd	s0,16(sp)
    1938:	1000                	addi	s0,sp,32
    193a:	e40c                	sd	a1,8(s0)
    193c:	e810                	sd	a2,16(s0)
    193e:	ec14                	sd	a3,24(s0)
    1940:	f018                	sd	a4,32(s0)
    1942:	f41c                	sd	a5,40(s0)
    1944:	03043823          	sd	a6,48(s0)
    1948:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    194c:	00840613          	addi	a2,s0,8
    1950:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1954:	85aa                	mv	a1,a0
    1956:	4505                	li	a0,1
    1958:	d29ff0ef          	jal	1680 <vprintf>
}
    195c:	60e2                	ld	ra,24(sp)
    195e:	6442                	ld	s0,16(sp)
    1960:	6125                	addi	sp,sp,96
    1962:	8082                	ret

0000000000001964 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1964:	1141                	addi	sp,sp,-16
    1966:	e422                	sd	s0,8(sp)
    1968:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    196a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    196e:	00000797          	auipc	a5,0x0
    1972:	7127b783          	ld	a5,1810(a5) # 2080 <freep>
    1976:	a02d                	j	19a0 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1978:	4618                	lw	a4,8(a2)
    197a:	9f2d                	addw	a4,a4,a1
    197c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1980:	6398                	ld	a4,0(a5)
    1982:	6310                	ld	a2,0(a4)
    1984:	a83d                	j	19c2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1986:	ff852703          	lw	a4,-8(a0)
    198a:	9f31                	addw	a4,a4,a2
    198c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    198e:	ff053683          	ld	a3,-16(a0)
    1992:	a091                	j	19d6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1994:	6398                	ld	a4,0(a5)
    1996:	00e7e463          	bltu	a5,a4,199e <free+0x3a>
    199a:	00e6ea63          	bltu	a3,a4,19ae <free+0x4a>
{
    199e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    19a0:	fed7fae3          	bgeu	a5,a3,1994 <free+0x30>
    19a4:	6398                	ld	a4,0(a5)
    19a6:	00e6e463          	bltu	a3,a4,19ae <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    19aa:	fee7eae3          	bltu	a5,a4,199e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    19ae:	ff852583          	lw	a1,-8(a0)
    19b2:	6390                	ld	a2,0(a5)
    19b4:	02059813          	slli	a6,a1,0x20
    19b8:	01c85713          	srli	a4,a6,0x1c
    19bc:	9736                	add	a4,a4,a3
    19be:	fae60de3          	beq	a2,a4,1978 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    19c2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    19c6:	4790                	lw	a2,8(a5)
    19c8:	02061593          	slli	a1,a2,0x20
    19cc:	01c5d713          	srli	a4,a1,0x1c
    19d0:	973e                	add	a4,a4,a5
    19d2:	fae68ae3          	beq	a3,a4,1986 <free+0x22>
    p->s.ptr = bp->s.ptr;
    19d6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    19d8:	00000717          	auipc	a4,0x0
    19dc:	6af73423          	sd	a5,1704(a4) # 2080 <freep>
}
    19e0:	6422                	ld	s0,8(sp)
    19e2:	0141                	addi	sp,sp,16
    19e4:	8082                	ret

00000000000019e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    19e6:	7139                	addi	sp,sp,-64
    19e8:	fc06                	sd	ra,56(sp)
    19ea:	f822                	sd	s0,48(sp)
    19ec:	f426                	sd	s1,40(sp)
    19ee:	ec4e                	sd	s3,24(sp)
    19f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    19f2:	02051493          	slli	s1,a0,0x20
    19f6:	9081                	srli	s1,s1,0x20
    19f8:	04bd                	addi	s1,s1,15
    19fa:	8091                	srli	s1,s1,0x4
    19fc:	0014899b          	addiw	s3,s1,1
    1a00:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1a02:	00000517          	auipc	a0,0x0
    1a06:	67e53503          	ld	a0,1662(a0) # 2080 <freep>
    1a0a:	c915                	beqz	a0,1a3e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a0c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1a0e:	4798                	lw	a4,8(a5)
    1a10:	08977a63          	bgeu	a4,s1,1aa4 <malloc+0xbe>
    1a14:	f04a                	sd	s2,32(sp)
    1a16:	e852                	sd	s4,16(sp)
    1a18:	e456                	sd	s5,8(sp)
    1a1a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1a1c:	8a4e                	mv	s4,s3
    1a1e:	0009871b          	sext.w	a4,s3
    1a22:	6685                	lui	a3,0x1
    1a24:	00d77363          	bgeu	a4,a3,1a2a <malloc+0x44>
    1a28:	6a05                	lui	s4,0x1
    1a2a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1a2e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1a32:	00000917          	auipc	s2,0x0
    1a36:	64e90913          	addi	s2,s2,1614 # 2080 <freep>
  if(p == (char*)-1)
    1a3a:	5afd                	li	s5,-1
    1a3c:	a081                	j	1a7c <malloc+0x96>
    1a3e:	f04a                	sd	s2,32(sp)
    1a40:	e852                	sd	s4,16(sp)
    1a42:	e456                	sd	s5,8(sp)
    1a44:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1a46:	00000797          	auipc	a5,0x0
    1a4a:	65a78793          	addi	a5,a5,1626 # 20a0 <base>
    1a4e:	00000717          	auipc	a4,0x0
    1a52:	62f73923          	sd	a5,1586(a4) # 2080 <freep>
    1a56:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1a58:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1a5c:	b7c1                	j	1a1c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1a5e:	6398                	ld	a4,0(a5)
    1a60:	e118                	sd	a4,0(a0)
    1a62:	a8a9                	j	1abc <malloc+0xd6>
  hp->s.size = nu;
    1a64:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1a68:	0541                	addi	a0,a0,16
    1a6a:	efbff0ef          	jal	1964 <free>
  return freep;
    1a6e:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1a72:	c12d                	beqz	a0,1ad4 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a74:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1a76:	4798                	lw	a4,8(a5)
    1a78:	02977263          	bgeu	a4,s1,1a9c <malloc+0xb6>
    if(p == freep)
    1a7c:	00093703          	ld	a4,0(s2)
    1a80:	853e                	mv	a0,a5
    1a82:	fef719e3          	bne	a4,a5,1a74 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1a86:	8552                	mv	a0,s4
    1a88:	ad3ff0ef          	jal	155a <sbrk>
  if(p == (char*)-1)
    1a8c:	fd551ce3          	bne	a0,s5,1a64 <malloc+0x7e>
        return 0;
    1a90:	4501                	li	a0,0
    1a92:	7902                	ld	s2,32(sp)
    1a94:	6a42                	ld	s4,16(sp)
    1a96:	6aa2                	ld	s5,8(sp)
    1a98:	6b02                	ld	s6,0(sp)
    1a9a:	a03d                	j	1ac8 <malloc+0xe2>
    1a9c:	7902                	ld	s2,32(sp)
    1a9e:	6a42                	ld	s4,16(sp)
    1aa0:	6aa2                	ld	s5,8(sp)
    1aa2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1aa4:	fae48de3          	beq	s1,a4,1a5e <malloc+0x78>
        p->s.size -= nunits;
    1aa8:	4137073b          	subw	a4,a4,s3
    1aac:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1aae:	02071693          	slli	a3,a4,0x20
    1ab2:	01c6d713          	srli	a4,a3,0x1c
    1ab6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1ab8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1abc:	00000717          	auipc	a4,0x0
    1ac0:	5ca73223          	sd	a0,1476(a4) # 2080 <freep>
      return (void*)(p + 1);
    1ac4:	01078513          	addi	a0,a5,16
  }
}
    1ac8:	70e2                	ld	ra,56(sp)
    1aca:	7442                	ld	s0,48(sp)
    1acc:	74a2                	ld	s1,40(sp)
    1ace:	69e2                	ld	s3,24(sp)
    1ad0:	6121                	addi	sp,sp,64
    1ad2:	8082                	ret
    1ad4:	7902                	ld	s2,32(sp)
    1ad6:	6a42                	ld	s4,16(sp)
    1ad8:	6aa2                	ld	s5,8(sp)
    1ada:	6b02                	ld	s6,0(sp)
    1adc:	b7f5                	j	1ac8 <malloc+0xe2>
	...
