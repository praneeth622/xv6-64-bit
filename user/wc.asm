
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
    1000:	7119                	addi	sp,sp,-128
    1002:	fc86                	sd	ra,120(sp)
    1004:	f8a2                	sd	s0,112(sp)
    1006:	f4a6                	sd	s1,104(sp)
    1008:	f0ca                	sd	s2,96(sp)
    100a:	ecce                	sd	s3,88(sp)
    100c:	e8d2                	sd	s4,80(sp)
    100e:	e4d6                	sd	s5,72(sp)
    1010:	e0da                	sd	s6,64(sp)
    1012:	fc5e                	sd	s7,56(sp)
    1014:	f862                	sd	s8,48(sp)
    1016:	f466                	sd	s9,40(sp)
    1018:	f06a                	sd	s10,32(sp)
    101a:	ec6e                	sd	s11,24(sp)
    101c:	0100                	addi	s0,sp,128
    101e:	f8a43423          	sd	a0,-120(s0)
    1022:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
    1026:	4901                	li	s2,0
  l = w = c = 0;
    1028:	4d01                	li	s10,0
    102a:	4c81                	li	s9,0
    102c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
    102e:	00001d97          	auipc	s11,0x1
    1032:	052d8d93          	addi	s11,s11,82 # 2080 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
    1036:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
    1038:	00001a17          	auipc	s4,0x1
    103c:	fc8a0a13          	addi	s4,s4,-56 # 2000 <malloc+0x726>
        inword = 0;
    1040:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1042:	a035                	j	106e <wc+0x6e>
      if(strchr(" \r\t\n\v", buf[i]))
    1044:	8552                	mv	a0,s4
    1046:	1bc000ef          	jal	1202 <strchr>
    104a:	c919                	beqz	a0,1060 <wc+0x60>
        inword = 0;
    104c:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
    104e:	0485                	addi	s1,s1,1
    1050:	01348d63          	beq	s1,s3,106a <wc+0x6a>
      if(buf[i] == '\n')
    1054:	0004c583          	lbu	a1,0(s1)
    1058:	ff5596e3          	bne	a1,s5,1044 <wc+0x44>
        l++;
    105c:	2c05                	addiw	s8,s8,1
    105e:	b7dd                	j	1044 <wc+0x44>
      else if(!inword){
    1060:	fe0917e3          	bnez	s2,104e <wc+0x4e>
        w++;
    1064:	2c85                	addiw	s9,s9,1
        inword = 1;
    1066:	4905                	li	s2,1
    1068:	b7dd                	j	104e <wc+0x4e>
    106a:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
    106e:	20000613          	li	a2,512
    1072:	85ee                	mv	a1,s11
    1074:	f8843503          	ld	a0,-120(s0)
    1078:	366000ef          	jal	13de <read>
    107c:	8b2a                	mv	s6,a0
    107e:	00a05963          	blez	a0,1090 <wc+0x90>
    for(i=0; i<n; i++){
    1082:	00001497          	auipc	s1,0x1
    1086:	ffe48493          	addi	s1,s1,-2 # 2080 <buf>
    108a:	009509b3          	add	s3,a0,s1
    108e:	b7d9                	j	1054 <wc+0x54>
      }
    }
  }
  if(n < 0){
    1090:	02054c63          	bltz	a0,10c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
    1094:	f8043703          	ld	a4,-128(s0)
    1098:	86ea                	mv	a3,s10
    109a:	8666                	mv	a2,s9
    109c:	85e2                	mv	a1,s8
    109e:	00001517          	auipc	a0,0x1
    10a2:	f8250513          	addi	a0,a0,-126 # 2020 <malloc+0x746>
    10a6:	780000ef          	jal	1826 <printf>
}
    10aa:	70e6                	ld	ra,120(sp)
    10ac:	7446                	ld	s0,112(sp)
    10ae:	74a6                	ld	s1,104(sp)
    10b0:	7906                	ld	s2,96(sp)
    10b2:	69e6                	ld	s3,88(sp)
    10b4:	6a46                	ld	s4,80(sp)
    10b6:	6aa6                	ld	s5,72(sp)
    10b8:	6b06                	ld	s6,64(sp)
    10ba:	7be2                	ld	s7,56(sp)
    10bc:	7c42                	ld	s8,48(sp)
    10be:	7ca2                	ld	s9,40(sp)
    10c0:	7d02                	ld	s10,32(sp)
    10c2:	6de2                	ld	s11,24(sp)
    10c4:	6109                	addi	sp,sp,128
    10c6:	8082                	ret
    printf("wc: read error\n");
    10c8:	00001517          	auipc	a0,0x1
    10cc:	f4850513          	addi	a0,a0,-184 # 2010 <malloc+0x736>
    10d0:	756000ef          	jal	1826 <printf>
    exit(1);
    10d4:	4505                	li	a0,1
    10d6:	2f0000ef          	jal	13c6 <exit>

00000000000010da <main>:

int
main(int argc, char *argv[])
{
    10da:	7179                	addi	sp,sp,-48
    10dc:	f406                	sd	ra,40(sp)
    10de:	f022                	sd	s0,32(sp)
    10e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
    10e2:	4785                	li	a5,1
    10e4:	04a7d463          	bge	a5,a0,112c <main+0x52>
    10e8:	ec26                	sd	s1,24(sp)
    10ea:	e84a                	sd	s2,16(sp)
    10ec:	e44e                	sd	s3,8(sp)
    10ee:	00858913          	addi	s2,a1,8
    10f2:	ffe5099b          	addiw	s3,a0,-2
    10f6:	02099793          	slli	a5,s3,0x20
    10fa:	01d7d993          	srli	s3,a5,0x1d
    10fe:	05c1                	addi	a1,a1,16
    1100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
    1102:	4581                	li	a1,0
    1104:	00093503          	ld	a0,0(s2)
    1108:	2fe000ef          	jal	1406 <open>
    110c:	84aa                	mv	s1,a0
    110e:	02054c63          	bltz	a0,1146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
    1112:	00093583          	ld	a1,0(s2)
    1116:	eebff0ef          	jal	1000 <wc>
    close(fd);
    111a:	8526                	mv	a0,s1
    111c:	2d2000ef          	jal	13ee <close>
  for(i = 1; i < argc; i++){
    1120:	0921                	addi	s2,s2,8
    1122:	ff3910e3          	bne	s2,s3,1102 <main+0x28>
  }
  exit(0);
    1126:	4501                	li	a0,0
    1128:	29e000ef          	jal	13c6 <exit>
    112c:	ec26                	sd	s1,24(sp)
    112e:	e84a                	sd	s2,16(sp)
    1130:	e44e                	sd	s3,8(sp)
    wc(0, "");
    1132:	00001597          	auipc	a1,0x1
    1136:	ed658593          	addi	a1,a1,-298 # 2008 <malloc+0x72e>
    113a:	4501                	li	a0,0
    113c:	ec5ff0ef          	jal	1000 <wc>
    exit(0);
    1140:	4501                	li	a0,0
    1142:	284000ef          	jal	13c6 <exit>
      printf("wc: cannot open %s\n", argv[i]);
    1146:	00093583          	ld	a1,0(s2)
    114a:	00001517          	auipc	a0,0x1
    114e:	ee650513          	addi	a0,a0,-282 # 2030 <malloc+0x756>
    1152:	6d4000ef          	jal	1826 <printf>
      exit(1);
    1156:	4505                	li	a0,1
    1158:	26e000ef          	jal	13c6 <exit>

000000000000115c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    115c:	1141                	addi	sp,sp,-16
    115e:	e406                	sd	ra,8(sp)
    1160:	e022                	sd	s0,0(sp)
    1162:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1164:	f77ff0ef          	jal	10da <main>
  exit(0);
    1168:	4501                	li	a0,0
    116a:	25c000ef          	jal	13c6 <exit>

000000000000116e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    116e:	1141                	addi	sp,sp,-16
    1170:	e422                	sd	s0,8(sp)
    1172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1174:	87aa                	mv	a5,a0
    1176:	0585                	addi	a1,a1,1
    1178:	0785                	addi	a5,a5,1
    117a:	fff5c703          	lbu	a4,-1(a1)
    117e:	fee78fa3          	sb	a4,-1(a5)
    1182:	fb75                	bnez	a4,1176 <strcpy+0x8>
    ;
  return os;
}
    1184:	6422                	ld	s0,8(sp)
    1186:	0141                	addi	sp,sp,16
    1188:	8082                	ret

000000000000118a <strcmp>:

int
strcmp(const char *p, const char *q)
{
    118a:	1141                	addi	sp,sp,-16
    118c:	e422                	sd	s0,8(sp)
    118e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1190:	00054783          	lbu	a5,0(a0)
    1194:	cb91                	beqz	a5,11a8 <strcmp+0x1e>
    1196:	0005c703          	lbu	a4,0(a1)
    119a:	00f71763          	bne	a4,a5,11a8 <strcmp+0x1e>
    p++, q++;
    119e:	0505                	addi	a0,a0,1
    11a0:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    11a2:	00054783          	lbu	a5,0(a0)
    11a6:	fbe5                	bnez	a5,1196 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    11a8:	0005c503          	lbu	a0,0(a1)
}
    11ac:	40a7853b          	subw	a0,a5,a0
    11b0:	6422                	ld	s0,8(sp)
    11b2:	0141                	addi	sp,sp,16
    11b4:	8082                	ret

00000000000011b6 <strlen>:

uint
strlen(const char *s)
{
    11b6:	1141                	addi	sp,sp,-16
    11b8:	e422                	sd	s0,8(sp)
    11ba:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    11bc:	00054783          	lbu	a5,0(a0)
    11c0:	cf91                	beqz	a5,11dc <strlen+0x26>
    11c2:	0505                	addi	a0,a0,1
    11c4:	87aa                	mv	a5,a0
    11c6:	86be                	mv	a3,a5
    11c8:	0785                	addi	a5,a5,1
    11ca:	fff7c703          	lbu	a4,-1(a5)
    11ce:	ff65                	bnez	a4,11c6 <strlen+0x10>
    11d0:	40a6853b          	subw	a0,a3,a0
    11d4:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    11d6:	6422                	ld	s0,8(sp)
    11d8:	0141                	addi	sp,sp,16
    11da:	8082                	ret
  for(n = 0; s[n]; n++)
    11dc:	4501                	li	a0,0
    11de:	bfe5                	j	11d6 <strlen+0x20>

00000000000011e0 <memset>:

void*
memset(void *dst, int c, uint n)
{
    11e0:	1141                	addi	sp,sp,-16
    11e2:	e422                	sd	s0,8(sp)
    11e4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    11e6:	ca19                	beqz	a2,11fc <memset+0x1c>
    11e8:	87aa                	mv	a5,a0
    11ea:	1602                	slli	a2,a2,0x20
    11ec:	9201                	srli	a2,a2,0x20
    11ee:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    11f2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    11f6:	0785                	addi	a5,a5,1
    11f8:	fee79de3          	bne	a5,a4,11f2 <memset+0x12>
  }
  return dst;
}
    11fc:	6422                	ld	s0,8(sp)
    11fe:	0141                	addi	sp,sp,16
    1200:	8082                	ret

0000000000001202 <strchr>:

char*
strchr(const char *s, char c)
{
    1202:	1141                	addi	sp,sp,-16
    1204:	e422                	sd	s0,8(sp)
    1206:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1208:	00054783          	lbu	a5,0(a0)
    120c:	cb99                	beqz	a5,1222 <strchr+0x20>
    if(*s == c)
    120e:	00f58763          	beq	a1,a5,121c <strchr+0x1a>
  for(; *s; s++)
    1212:	0505                	addi	a0,a0,1
    1214:	00054783          	lbu	a5,0(a0)
    1218:	fbfd                	bnez	a5,120e <strchr+0xc>
      return (char*)s;
  return 0;
    121a:	4501                	li	a0,0
}
    121c:	6422                	ld	s0,8(sp)
    121e:	0141                	addi	sp,sp,16
    1220:	8082                	ret
  return 0;
    1222:	4501                	li	a0,0
    1224:	bfe5                	j	121c <strchr+0x1a>

0000000000001226 <gets>:

char*
gets(char *buf, int max)
{
    1226:	711d                	addi	sp,sp,-96
    1228:	ec86                	sd	ra,88(sp)
    122a:	e8a2                	sd	s0,80(sp)
    122c:	e4a6                	sd	s1,72(sp)
    122e:	e0ca                	sd	s2,64(sp)
    1230:	fc4e                	sd	s3,56(sp)
    1232:	f852                	sd	s4,48(sp)
    1234:	f456                	sd	s5,40(sp)
    1236:	f05a                	sd	s6,32(sp)
    1238:	ec5e                	sd	s7,24(sp)
    123a:	1080                	addi	s0,sp,96
    123c:	8baa                	mv	s7,a0
    123e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1240:	892a                	mv	s2,a0
    1242:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1244:	4aa9                	li	s5,10
    1246:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1248:	89a6                	mv	s3,s1
    124a:	2485                	addiw	s1,s1,1
    124c:	0344d663          	bge	s1,s4,1278 <gets+0x52>
    cc = read(0, &c, 1);
    1250:	4605                	li	a2,1
    1252:	faf40593          	addi	a1,s0,-81
    1256:	4501                	li	a0,0
    1258:	186000ef          	jal	13de <read>
    if(cc < 1)
    125c:	00a05e63          	blez	a0,1278 <gets+0x52>
    buf[i++] = c;
    1260:	faf44783          	lbu	a5,-81(s0)
    1264:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1268:	01578763          	beq	a5,s5,1276 <gets+0x50>
    126c:	0905                	addi	s2,s2,1
    126e:	fd679de3          	bne	a5,s6,1248 <gets+0x22>
    buf[i++] = c;
    1272:	89a6                	mv	s3,s1
    1274:	a011                	j	1278 <gets+0x52>
    1276:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1278:	99de                	add	s3,s3,s7
    127a:	00098023          	sb	zero,0(s3)
  return buf;
}
    127e:	855e                	mv	a0,s7
    1280:	60e6                	ld	ra,88(sp)
    1282:	6446                	ld	s0,80(sp)
    1284:	64a6                	ld	s1,72(sp)
    1286:	6906                	ld	s2,64(sp)
    1288:	79e2                	ld	s3,56(sp)
    128a:	7a42                	ld	s4,48(sp)
    128c:	7aa2                	ld	s5,40(sp)
    128e:	7b02                	ld	s6,32(sp)
    1290:	6be2                	ld	s7,24(sp)
    1292:	6125                	addi	sp,sp,96
    1294:	8082                	ret

0000000000001296 <stat>:

int
stat(const char *n, struct stat *st)
{
    1296:	1101                	addi	sp,sp,-32
    1298:	ec06                	sd	ra,24(sp)
    129a:	e822                	sd	s0,16(sp)
    129c:	e04a                	sd	s2,0(sp)
    129e:	1000                	addi	s0,sp,32
    12a0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    12a2:	4581                	li	a1,0
    12a4:	162000ef          	jal	1406 <open>
  if(fd < 0)
    12a8:	02054263          	bltz	a0,12cc <stat+0x36>
    12ac:	e426                	sd	s1,8(sp)
    12ae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    12b0:	85ca                	mv	a1,s2
    12b2:	16c000ef          	jal	141e <fstat>
    12b6:	892a                	mv	s2,a0
  close(fd);
    12b8:	8526                	mv	a0,s1
    12ba:	134000ef          	jal	13ee <close>
  return r;
    12be:	64a2                	ld	s1,8(sp)
}
    12c0:	854a                	mv	a0,s2
    12c2:	60e2                	ld	ra,24(sp)
    12c4:	6442                	ld	s0,16(sp)
    12c6:	6902                	ld	s2,0(sp)
    12c8:	6105                	addi	sp,sp,32
    12ca:	8082                	ret
    return -1;
    12cc:	597d                	li	s2,-1
    12ce:	bfcd                	j	12c0 <stat+0x2a>

00000000000012d0 <atoi>:

int
atoi(const char *s)
{
    12d0:	1141                	addi	sp,sp,-16
    12d2:	e422                	sd	s0,8(sp)
    12d4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    12d6:	00054683          	lbu	a3,0(a0)
    12da:	fd06879b          	addiw	a5,a3,-48
    12de:	0ff7f793          	zext.b	a5,a5
    12e2:	4625                	li	a2,9
    12e4:	02f66863          	bltu	a2,a5,1314 <atoi+0x44>
    12e8:	872a                	mv	a4,a0
  n = 0;
    12ea:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    12ec:	0705                	addi	a4,a4,1
    12ee:	0025179b          	slliw	a5,a0,0x2
    12f2:	9fa9                	addw	a5,a5,a0
    12f4:	0017979b          	slliw	a5,a5,0x1
    12f8:	9fb5                	addw	a5,a5,a3
    12fa:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    12fe:	00074683          	lbu	a3,0(a4)
    1302:	fd06879b          	addiw	a5,a3,-48
    1306:	0ff7f793          	zext.b	a5,a5
    130a:	fef671e3          	bgeu	a2,a5,12ec <atoi+0x1c>
  return n;
}
    130e:	6422                	ld	s0,8(sp)
    1310:	0141                	addi	sp,sp,16
    1312:	8082                	ret
  n = 0;
    1314:	4501                	li	a0,0
    1316:	bfe5                	j	130e <atoi+0x3e>

0000000000001318 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1318:	1141                	addi	sp,sp,-16
    131a:	e422                	sd	s0,8(sp)
    131c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    131e:	02b57463          	bgeu	a0,a1,1346 <memmove+0x2e>
    while(n-- > 0)
    1322:	00c05f63          	blez	a2,1340 <memmove+0x28>
    1326:	1602                	slli	a2,a2,0x20
    1328:	9201                	srli	a2,a2,0x20
    132a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    132e:	872a                	mv	a4,a0
      *dst++ = *src++;
    1330:	0585                	addi	a1,a1,1
    1332:	0705                	addi	a4,a4,1
    1334:	fff5c683          	lbu	a3,-1(a1)
    1338:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    133c:	fef71ae3          	bne	a4,a5,1330 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1340:	6422                	ld	s0,8(sp)
    1342:	0141                	addi	sp,sp,16
    1344:	8082                	ret
    dst += n;
    1346:	00c50733          	add	a4,a0,a2
    src += n;
    134a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    134c:	fec05ae3          	blez	a2,1340 <memmove+0x28>
    1350:	fff6079b          	addiw	a5,a2,-1
    1354:	1782                	slli	a5,a5,0x20
    1356:	9381                	srli	a5,a5,0x20
    1358:	fff7c793          	not	a5,a5
    135c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    135e:	15fd                	addi	a1,a1,-1
    1360:	177d                	addi	a4,a4,-1
    1362:	0005c683          	lbu	a3,0(a1)
    1366:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    136a:	fee79ae3          	bne	a5,a4,135e <memmove+0x46>
    136e:	bfc9                	j	1340 <memmove+0x28>

0000000000001370 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1370:	1141                	addi	sp,sp,-16
    1372:	e422                	sd	s0,8(sp)
    1374:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1376:	ca05                	beqz	a2,13a6 <memcmp+0x36>
    1378:	fff6069b          	addiw	a3,a2,-1
    137c:	1682                	slli	a3,a3,0x20
    137e:	9281                	srli	a3,a3,0x20
    1380:	0685                	addi	a3,a3,1
    1382:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1384:	00054783          	lbu	a5,0(a0)
    1388:	0005c703          	lbu	a4,0(a1)
    138c:	00e79863          	bne	a5,a4,139c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1390:	0505                	addi	a0,a0,1
    p2++;
    1392:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1394:	fed518e3          	bne	a0,a3,1384 <memcmp+0x14>
  }
  return 0;
    1398:	4501                	li	a0,0
    139a:	a019                	j	13a0 <memcmp+0x30>
      return *p1 - *p2;
    139c:	40e7853b          	subw	a0,a5,a4
}
    13a0:	6422                	ld	s0,8(sp)
    13a2:	0141                	addi	sp,sp,16
    13a4:	8082                	ret
  return 0;
    13a6:	4501                	li	a0,0
    13a8:	bfe5                	j	13a0 <memcmp+0x30>

00000000000013aa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    13aa:	1141                	addi	sp,sp,-16
    13ac:	e406                	sd	ra,8(sp)
    13ae:	e022                	sd	s0,0(sp)
    13b0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    13b2:	f67ff0ef          	jal	1318 <memmove>
}
    13b6:	60a2                	ld	ra,8(sp)
    13b8:	6402                	ld	s0,0(sp)
    13ba:	0141                	addi	sp,sp,16
    13bc:	8082                	ret

00000000000013be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    13be:	4885                	li	a7,1
 ecall
    13c0:	00000073          	ecall
 ret
    13c4:	8082                	ret

00000000000013c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
    13c6:	4889                	li	a7,2
 ecall
    13c8:	00000073          	ecall
 ret
    13cc:	8082                	ret

00000000000013ce <wait>:
.global wait
wait:
 li a7, SYS_wait
    13ce:	488d                	li	a7,3
 ecall
    13d0:	00000073          	ecall
 ret
    13d4:	8082                	ret

00000000000013d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    13d6:	4891                	li	a7,4
 ecall
    13d8:	00000073          	ecall
 ret
    13dc:	8082                	ret

00000000000013de <read>:
.global read
read:
 li a7, SYS_read
    13de:	4895                	li	a7,5
 ecall
    13e0:	00000073          	ecall
 ret
    13e4:	8082                	ret

00000000000013e6 <write>:
.global write
write:
 li a7, SYS_write
    13e6:	48c1                	li	a7,16
 ecall
    13e8:	00000073          	ecall
 ret
    13ec:	8082                	ret

00000000000013ee <close>:
.global close
close:
 li a7, SYS_close
    13ee:	48d5                	li	a7,21
 ecall
    13f0:	00000073          	ecall
 ret
    13f4:	8082                	ret

00000000000013f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
    13f6:	4899                	li	a7,6
 ecall
    13f8:	00000073          	ecall
 ret
    13fc:	8082                	ret

00000000000013fe <exec>:
.global exec
exec:
 li a7, SYS_exec
    13fe:	489d                	li	a7,7
 ecall
    1400:	00000073          	ecall
 ret
    1404:	8082                	ret

0000000000001406 <open>:
.global open
open:
 li a7, SYS_open
    1406:	48bd                	li	a7,15
 ecall
    1408:	00000073          	ecall
 ret
    140c:	8082                	ret

000000000000140e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    140e:	48c5                	li	a7,17
 ecall
    1410:	00000073          	ecall
 ret
    1414:	8082                	ret

0000000000001416 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1416:	48c9                	li	a7,18
 ecall
    1418:	00000073          	ecall
 ret
    141c:	8082                	ret

000000000000141e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    141e:	48a1                	li	a7,8
 ecall
    1420:	00000073          	ecall
 ret
    1424:	8082                	ret

0000000000001426 <link>:
.global link
link:
 li a7, SYS_link
    1426:	48cd                	li	a7,19
 ecall
    1428:	00000073          	ecall
 ret
    142c:	8082                	ret

000000000000142e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    142e:	48d1                	li	a7,20
 ecall
    1430:	00000073          	ecall
 ret
    1434:	8082                	ret

0000000000001436 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1436:	48a5                	li	a7,9
 ecall
    1438:	00000073          	ecall
 ret
    143c:	8082                	ret

000000000000143e <dup>:
.global dup
dup:
 li a7, SYS_dup
    143e:	48a9                	li	a7,10
 ecall
    1440:	00000073          	ecall
 ret
    1444:	8082                	ret

0000000000001446 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1446:	48ad                	li	a7,11
 ecall
    1448:	00000073          	ecall
 ret
    144c:	8082                	ret

000000000000144e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    144e:	48b1                	li	a7,12
 ecall
    1450:	00000073          	ecall
 ret
    1454:	8082                	ret

0000000000001456 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1456:	48b5                	li	a7,13
 ecall
    1458:	00000073          	ecall
 ret
    145c:	8082                	ret

000000000000145e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    145e:	48b9                	li	a7,14
 ecall
    1460:	00000073          	ecall
 ret
    1464:	8082                	ret

0000000000001466 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1466:	48d9                	li	a7,22
 ecall
    1468:	00000073          	ecall
 ret
    146c:	8082                	ret

000000000000146e <signal>:
.global signal
signal:
 li a7, SYS_signal
    146e:	48dd                	li	a7,23
 ecall
    1470:	00000073          	ecall
 ret
    1474:	8082                	ret

0000000000001476 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1476:	48e1                	li	a7,24
 ecall
    1478:	00000073          	ecall
 ret
    147c:	8082                	ret

000000000000147e <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    147e:	48e5                	li	a7,25
 ecall
    1480:	00000073          	ecall
 ret
    1484:	8082                	ret

0000000000001486 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1486:	48e9                	li	a7,26
 ecall
    1488:	00000073          	ecall
 ret
    148c:	8082                	ret

000000000000148e <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    148e:	48ed                	li	a7,27
 ecall
    1490:	00000073          	ecall
 ret
    1494:	8082                	ret

0000000000001496 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1496:	48f1                	li	a7,28
 ecall
    1498:	00000073          	ecall
 ret
    149c:	8082                	ret

000000000000149e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    149e:	48f5                	li	a7,29
 ecall
    14a0:	00000073          	ecall
 ret
    14a4:	8082                	ret

00000000000014a6 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    14a6:	48f9                	li	a7,30
 ecall
    14a8:	00000073          	ecall
 ret
    14ac:	8082                	ret

00000000000014ae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    14ae:	1101                	addi	sp,sp,-32
    14b0:	ec06                	sd	ra,24(sp)
    14b2:	e822                	sd	s0,16(sp)
    14b4:	1000                	addi	s0,sp,32
    14b6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    14ba:	4605                	li	a2,1
    14bc:	fef40593          	addi	a1,s0,-17
    14c0:	f27ff0ef          	jal	13e6 <write>
}
    14c4:	60e2                	ld	ra,24(sp)
    14c6:	6442                	ld	s0,16(sp)
    14c8:	6105                	addi	sp,sp,32
    14ca:	8082                	ret

00000000000014cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    14cc:	7139                	addi	sp,sp,-64
    14ce:	fc06                	sd	ra,56(sp)
    14d0:	f822                	sd	s0,48(sp)
    14d2:	f426                	sd	s1,40(sp)
    14d4:	0080                	addi	s0,sp,64
    14d6:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    14d8:	c299                	beqz	a3,14de <printint+0x12>
    14da:	0805c963          	bltz	a1,156c <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    14de:	2581                	sext.w	a1,a1
  neg = 0;
    14e0:	4881                	li	a7,0
    14e2:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    14e6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    14e8:	2601                	sext.w	a2,a2
    14ea:	00001517          	auipc	a0,0x1
    14ee:	b6650513          	addi	a0,a0,-1178 # 2050 <digits>
    14f2:	883a                	mv	a6,a4
    14f4:	2705                	addiw	a4,a4,1
    14f6:	02c5f7bb          	remuw	a5,a1,a2
    14fa:	1782                	slli	a5,a5,0x20
    14fc:	9381                	srli	a5,a5,0x20
    14fe:	97aa                	add	a5,a5,a0
    1500:	0007c783          	lbu	a5,0(a5)
    1504:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1508:	0005879b          	sext.w	a5,a1
    150c:	02c5d5bb          	divuw	a1,a1,a2
    1510:	0685                	addi	a3,a3,1
    1512:	fec7f0e3          	bgeu	a5,a2,14f2 <printint+0x26>
  if(neg)
    1516:	00088c63          	beqz	a7,152e <printint+0x62>
    buf[i++] = '-';
    151a:	fd070793          	addi	a5,a4,-48
    151e:	00878733          	add	a4,a5,s0
    1522:	02d00793          	li	a5,45
    1526:	fef70823          	sb	a5,-16(a4)
    152a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    152e:	02e05a63          	blez	a4,1562 <printint+0x96>
    1532:	f04a                	sd	s2,32(sp)
    1534:	ec4e                	sd	s3,24(sp)
    1536:	fc040793          	addi	a5,s0,-64
    153a:	00e78933          	add	s2,a5,a4
    153e:	fff78993          	addi	s3,a5,-1
    1542:	99ba                	add	s3,s3,a4
    1544:	377d                	addiw	a4,a4,-1
    1546:	1702                	slli	a4,a4,0x20
    1548:	9301                	srli	a4,a4,0x20
    154a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    154e:	fff94583          	lbu	a1,-1(s2)
    1552:	8526                	mv	a0,s1
    1554:	f5bff0ef          	jal	14ae <putc>
  while(--i >= 0)
    1558:	197d                	addi	s2,s2,-1
    155a:	ff391ae3          	bne	s2,s3,154e <printint+0x82>
    155e:	7902                	ld	s2,32(sp)
    1560:	69e2                	ld	s3,24(sp)
}
    1562:	70e2                	ld	ra,56(sp)
    1564:	7442                	ld	s0,48(sp)
    1566:	74a2                	ld	s1,40(sp)
    1568:	6121                	addi	sp,sp,64
    156a:	8082                	ret
    x = -xx;
    156c:	40b005bb          	negw	a1,a1
    neg = 1;
    1570:	4885                	li	a7,1
    x = -xx;
    1572:	bf85                	j	14e2 <printint+0x16>

0000000000001574 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1574:	711d                	addi	sp,sp,-96
    1576:	ec86                	sd	ra,88(sp)
    1578:	e8a2                	sd	s0,80(sp)
    157a:	e0ca                	sd	s2,64(sp)
    157c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    157e:	0005c903          	lbu	s2,0(a1)
    1582:	26090863          	beqz	s2,17f2 <vprintf+0x27e>
    1586:	e4a6                	sd	s1,72(sp)
    1588:	fc4e                	sd	s3,56(sp)
    158a:	f852                	sd	s4,48(sp)
    158c:	f456                	sd	s5,40(sp)
    158e:	f05a                	sd	s6,32(sp)
    1590:	ec5e                	sd	s7,24(sp)
    1592:	e862                	sd	s8,16(sp)
    1594:	e466                	sd	s9,8(sp)
    1596:	8b2a                	mv	s6,a0
    1598:	8a2e                	mv	s4,a1
    159a:	8bb2                	mv	s7,a2
  state = 0;
    159c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    159e:	4481                	li	s1,0
    15a0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    15a2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    15a6:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    15aa:	06c00c93          	li	s9,108
    15ae:	a005                	j	15ce <vprintf+0x5a>
        putc(fd, c0);
    15b0:	85ca                	mv	a1,s2
    15b2:	855a                	mv	a0,s6
    15b4:	efbff0ef          	jal	14ae <putc>
    15b8:	a019                	j	15be <vprintf+0x4a>
    } else if(state == '%'){
    15ba:	03598263          	beq	s3,s5,15de <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    15be:	2485                	addiw	s1,s1,1
    15c0:	8726                	mv	a4,s1
    15c2:	009a07b3          	add	a5,s4,s1
    15c6:	0007c903          	lbu	s2,0(a5)
    15ca:	20090c63          	beqz	s2,17e2 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    15ce:	0009079b          	sext.w	a5,s2
    if(state == 0){
    15d2:	fe0994e3          	bnez	s3,15ba <vprintf+0x46>
      if(c0 == '%'){
    15d6:	fd579de3          	bne	a5,s5,15b0 <vprintf+0x3c>
        state = '%';
    15da:	89be                	mv	s3,a5
    15dc:	b7cd                	j	15be <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    15de:	00ea06b3          	add	a3,s4,a4
    15e2:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    15e6:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    15e8:	c681                	beqz	a3,15f0 <vprintf+0x7c>
    15ea:	9752                	add	a4,a4,s4
    15ec:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    15f0:	03878f63          	beq	a5,s8,162e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    15f4:	05978963          	beq	a5,s9,1646 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    15f8:	07500713          	li	a4,117
    15fc:	0ee78363          	beq	a5,a4,16e2 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1600:	07800713          	li	a4,120
    1604:	12e78563          	beq	a5,a4,172e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1608:	07000713          	li	a4,112
    160c:	14e78a63          	beq	a5,a4,1760 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1610:	07300713          	li	a4,115
    1614:	18e78a63          	beq	a5,a4,17a8 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1618:	02500713          	li	a4,37
    161c:	04e79563          	bne	a5,a4,1666 <vprintf+0xf2>
        putc(fd, '%');
    1620:	02500593          	li	a1,37
    1624:	855a                	mv	a0,s6
    1626:	e89ff0ef          	jal	14ae <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    162a:	4981                	li	s3,0
    162c:	bf49                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    162e:	008b8913          	addi	s2,s7,8
    1632:	4685                	li	a3,1
    1634:	4629                	li	a2,10
    1636:	000ba583          	lw	a1,0(s7)
    163a:	855a                	mv	a0,s6
    163c:	e91ff0ef          	jal	14cc <printint>
    1640:	8bca                	mv	s7,s2
      state = 0;
    1642:	4981                	li	s3,0
    1644:	bfad                	j	15be <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1646:	06400793          	li	a5,100
    164a:	02f68963          	beq	a3,a5,167c <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    164e:	06c00793          	li	a5,108
    1652:	04f68263          	beq	a3,a5,1696 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1656:	07500793          	li	a5,117
    165a:	0af68063          	beq	a3,a5,16fa <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    165e:	07800793          	li	a5,120
    1662:	0ef68263          	beq	a3,a5,1746 <vprintf+0x1d2>
        putc(fd, '%');
    1666:	02500593          	li	a1,37
    166a:	855a                	mv	a0,s6
    166c:	e43ff0ef          	jal	14ae <putc>
        putc(fd, c0);
    1670:	85ca                	mv	a1,s2
    1672:	855a                	mv	a0,s6
    1674:	e3bff0ef          	jal	14ae <putc>
      state = 0;
    1678:	4981                	li	s3,0
    167a:	b791                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    167c:	008b8913          	addi	s2,s7,8
    1680:	4685                	li	a3,1
    1682:	4629                	li	a2,10
    1684:	000ba583          	lw	a1,0(s7)
    1688:	855a                	mv	a0,s6
    168a:	e43ff0ef          	jal	14cc <printint>
        i += 1;
    168e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1690:	8bca                	mv	s7,s2
      state = 0;
    1692:	4981                	li	s3,0
        i += 1;
    1694:	b72d                	j	15be <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1696:	06400793          	li	a5,100
    169a:	02f60763          	beq	a2,a5,16c8 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    169e:	07500793          	li	a5,117
    16a2:	06f60963          	beq	a2,a5,1714 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    16a6:	07800793          	li	a5,120
    16aa:	faf61ee3          	bne	a2,a5,1666 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    16ae:	008b8913          	addi	s2,s7,8
    16b2:	4681                	li	a3,0
    16b4:	4641                	li	a2,16
    16b6:	000ba583          	lw	a1,0(s7)
    16ba:	855a                	mv	a0,s6
    16bc:	e11ff0ef          	jal	14cc <printint>
        i += 2;
    16c0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    16c2:	8bca                	mv	s7,s2
      state = 0;
    16c4:	4981                	li	s3,0
        i += 2;
    16c6:	bde5                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    16c8:	008b8913          	addi	s2,s7,8
    16cc:	4685                	li	a3,1
    16ce:	4629                	li	a2,10
    16d0:	000ba583          	lw	a1,0(s7)
    16d4:	855a                	mv	a0,s6
    16d6:	df7ff0ef          	jal	14cc <printint>
        i += 2;
    16da:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    16dc:	8bca                	mv	s7,s2
      state = 0;
    16de:	4981                	li	s3,0
        i += 2;
    16e0:	bdf9                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    16e2:	008b8913          	addi	s2,s7,8
    16e6:	4681                	li	a3,0
    16e8:	4629                	li	a2,10
    16ea:	000ba583          	lw	a1,0(s7)
    16ee:	855a                	mv	a0,s6
    16f0:	dddff0ef          	jal	14cc <printint>
    16f4:	8bca                	mv	s7,s2
      state = 0;
    16f6:	4981                	li	s3,0
    16f8:	b5d9                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    16fa:	008b8913          	addi	s2,s7,8
    16fe:	4681                	li	a3,0
    1700:	4629                	li	a2,10
    1702:	000ba583          	lw	a1,0(s7)
    1706:	855a                	mv	a0,s6
    1708:	dc5ff0ef          	jal	14cc <printint>
        i += 1;
    170c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    170e:	8bca                	mv	s7,s2
      state = 0;
    1710:	4981                	li	s3,0
        i += 1;
    1712:	b575                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1714:	008b8913          	addi	s2,s7,8
    1718:	4681                	li	a3,0
    171a:	4629                	li	a2,10
    171c:	000ba583          	lw	a1,0(s7)
    1720:	855a                	mv	a0,s6
    1722:	dabff0ef          	jal	14cc <printint>
        i += 2;
    1726:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1728:	8bca                	mv	s7,s2
      state = 0;
    172a:	4981                	li	s3,0
        i += 2;
    172c:	bd49                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    172e:	008b8913          	addi	s2,s7,8
    1732:	4681                	li	a3,0
    1734:	4641                	li	a2,16
    1736:	000ba583          	lw	a1,0(s7)
    173a:	855a                	mv	a0,s6
    173c:	d91ff0ef          	jal	14cc <printint>
    1740:	8bca                	mv	s7,s2
      state = 0;
    1742:	4981                	li	s3,0
    1744:	bdad                	j	15be <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1746:	008b8913          	addi	s2,s7,8
    174a:	4681                	li	a3,0
    174c:	4641                	li	a2,16
    174e:	000ba583          	lw	a1,0(s7)
    1752:	855a                	mv	a0,s6
    1754:	d79ff0ef          	jal	14cc <printint>
        i += 1;
    1758:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    175a:	8bca                	mv	s7,s2
      state = 0;
    175c:	4981                	li	s3,0
        i += 1;
    175e:	b585                	j	15be <vprintf+0x4a>
    1760:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1762:	008b8d13          	addi	s10,s7,8
    1766:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    176a:	03000593          	li	a1,48
    176e:	855a                	mv	a0,s6
    1770:	d3fff0ef          	jal	14ae <putc>
  putc(fd, 'x');
    1774:	07800593          	li	a1,120
    1778:	855a                	mv	a0,s6
    177a:	d35ff0ef          	jal	14ae <putc>
    177e:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1780:	00001b97          	auipc	s7,0x1
    1784:	8d0b8b93          	addi	s7,s7,-1840 # 2050 <digits>
    1788:	03c9d793          	srli	a5,s3,0x3c
    178c:	97de                	add	a5,a5,s7
    178e:	0007c583          	lbu	a1,0(a5)
    1792:	855a                	mv	a0,s6
    1794:	d1bff0ef          	jal	14ae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1798:	0992                	slli	s3,s3,0x4
    179a:	397d                	addiw	s2,s2,-1
    179c:	fe0916e3          	bnez	s2,1788 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    17a0:	8bea                	mv	s7,s10
      state = 0;
    17a2:	4981                	li	s3,0
    17a4:	6d02                	ld	s10,0(sp)
    17a6:	bd21                	j	15be <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    17a8:	008b8993          	addi	s3,s7,8
    17ac:	000bb903          	ld	s2,0(s7)
    17b0:	00090f63          	beqz	s2,17ce <vprintf+0x25a>
        for(; *s; s++)
    17b4:	00094583          	lbu	a1,0(s2)
    17b8:	c195                	beqz	a1,17dc <vprintf+0x268>
          putc(fd, *s);
    17ba:	855a                	mv	a0,s6
    17bc:	cf3ff0ef          	jal	14ae <putc>
        for(; *s; s++)
    17c0:	0905                	addi	s2,s2,1
    17c2:	00094583          	lbu	a1,0(s2)
    17c6:	f9f5                	bnez	a1,17ba <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    17c8:	8bce                	mv	s7,s3
      state = 0;
    17ca:	4981                	li	s3,0
    17cc:	bbcd                	j	15be <vprintf+0x4a>
          s = "(null)";
    17ce:	00001917          	auipc	s2,0x1
    17d2:	87a90913          	addi	s2,s2,-1926 # 2048 <malloc+0x76e>
        for(; *s; s++)
    17d6:	02800593          	li	a1,40
    17da:	b7c5                	j	17ba <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    17dc:	8bce                	mv	s7,s3
      state = 0;
    17de:	4981                	li	s3,0
    17e0:	bbf9                	j	15be <vprintf+0x4a>
    17e2:	64a6                	ld	s1,72(sp)
    17e4:	79e2                	ld	s3,56(sp)
    17e6:	7a42                	ld	s4,48(sp)
    17e8:	7aa2                	ld	s5,40(sp)
    17ea:	7b02                	ld	s6,32(sp)
    17ec:	6be2                	ld	s7,24(sp)
    17ee:	6c42                	ld	s8,16(sp)
    17f0:	6ca2                	ld	s9,8(sp)
    }
  }
}
    17f2:	60e6                	ld	ra,88(sp)
    17f4:	6446                	ld	s0,80(sp)
    17f6:	6906                	ld	s2,64(sp)
    17f8:	6125                	addi	sp,sp,96
    17fa:	8082                	ret

00000000000017fc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    17fc:	715d                	addi	sp,sp,-80
    17fe:	ec06                	sd	ra,24(sp)
    1800:	e822                	sd	s0,16(sp)
    1802:	1000                	addi	s0,sp,32
    1804:	e010                	sd	a2,0(s0)
    1806:	e414                	sd	a3,8(s0)
    1808:	e818                	sd	a4,16(s0)
    180a:	ec1c                	sd	a5,24(s0)
    180c:	03043023          	sd	a6,32(s0)
    1810:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1814:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1818:	8622                	mv	a2,s0
    181a:	d5bff0ef          	jal	1574 <vprintf>
}
    181e:	60e2                	ld	ra,24(sp)
    1820:	6442                	ld	s0,16(sp)
    1822:	6161                	addi	sp,sp,80
    1824:	8082                	ret

0000000000001826 <printf>:

void
printf(const char *fmt, ...)
{
    1826:	711d                	addi	sp,sp,-96
    1828:	ec06                	sd	ra,24(sp)
    182a:	e822                	sd	s0,16(sp)
    182c:	1000                	addi	s0,sp,32
    182e:	e40c                	sd	a1,8(s0)
    1830:	e810                	sd	a2,16(s0)
    1832:	ec14                	sd	a3,24(s0)
    1834:	f018                	sd	a4,32(s0)
    1836:	f41c                	sd	a5,40(s0)
    1838:	03043823          	sd	a6,48(s0)
    183c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1840:	00840613          	addi	a2,s0,8
    1844:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1848:	85aa                	mv	a1,a0
    184a:	4505                	li	a0,1
    184c:	d29ff0ef          	jal	1574 <vprintf>
}
    1850:	60e2                	ld	ra,24(sp)
    1852:	6442                	ld	s0,16(sp)
    1854:	6125                	addi	sp,sp,96
    1856:	8082                	ret

0000000000001858 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1858:	1141                	addi	sp,sp,-16
    185a:	e422                	sd	s0,8(sp)
    185c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    185e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1862:	00001797          	auipc	a5,0x1
    1866:	80e7b783          	ld	a5,-2034(a5) # 2070 <freep>
    186a:	a02d                	j	1894 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    186c:	4618                	lw	a4,8(a2)
    186e:	9f2d                	addw	a4,a4,a1
    1870:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1874:	6398                	ld	a4,0(a5)
    1876:	6310                	ld	a2,0(a4)
    1878:	a83d                	j	18b6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    187a:	ff852703          	lw	a4,-8(a0)
    187e:	9f31                	addw	a4,a4,a2
    1880:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1882:	ff053683          	ld	a3,-16(a0)
    1886:	a091                	j	18ca <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1888:	6398                	ld	a4,0(a5)
    188a:	00e7e463          	bltu	a5,a4,1892 <free+0x3a>
    188e:	00e6ea63          	bltu	a3,a4,18a2 <free+0x4a>
{
    1892:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1894:	fed7fae3          	bgeu	a5,a3,1888 <free+0x30>
    1898:	6398                	ld	a4,0(a5)
    189a:	00e6e463          	bltu	a3,a4,18a2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    189e:	fee7eae3          	bltu	a5,a4,1892 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    18a2:	ff852583          	lw	a1,-8(a0)
    18a6:	6390                	ld	a2,0(a5)
    18a8:	02059813          	slli	a6,a1,0x20
    18ac:	01c85713          	srli	a4,a6,0x1c
    18b0:	9736                	add	a4,a4,a3
    18b2:	fae60de3          	beq	a2,a4,186c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    18b6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    18ba:	4790                	lw	a2,8(a5)
    18bc:	02061593          	slli	a1,a2,0x20
    18c0:	01c5d713          	srli	a4,a1,0x1c
    18c4:	973e                	add	a4,a4,a5
    18c6:	fae68ae3          	beq	a3,a4,187a <free+0x22>
    p->s.ptr = bp->s.ptr;
    18ca:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    18cc:	00000717          	auipc	a4,0x0
    18d0:	7af73223          	sd	a5,1956(a4) # 2070 <freep>
}
    18d4:	6422                	ld	s0,8(sp)
    18d6:	0141                	addi	sp,sp,16
    18d8:	8082                	ret

00000000000018da <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    18da:	7139                	addi	sp,sp,-64
    18dc:	fc06                	sd	ra,56(sp)
    18de:	f822                	sd	s0,48(sp)
    18e0:	f426                	sd	s1,40(sp)
    18e2:	ec4e                	sd	s3,24(sp)
    18e4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    18e6:	02051493          	slli	s1,a0,0x20
    18ea:	9081                	srli	s1,s1,0x20
    18ec:	04bd                	addi	s1,s1,15
    18ee:	8091                	srli	s1,s1,0x4
    18f0:	0014899b          	addiw	s3,s1,1
    18f4:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    18f6:	00000517          	auipc	a0,0x0
    18fa:	77a53503          	ld	a0,1914(a0) # 2070 <freep>
    18fe:	c915                	beqz	a0,1932 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1900:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1902:	4798                	lw	a4,8(a5)
    1904:	08977a63          	bgeu	a4,s1,1998 <malloc+0xbe>
    1908:	f04a                	sd	s2,32(sp)
    190a:	e852                	sd	s4,16(sp)
    190c:	e456                	sd	s5,8(sp)
    190e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1910:	8a4e                	mv	s4,s3
    1912:	0009871b          	sext.w	a4,s3
    1916:	6685                	lui	a3,0x1
    1918:	00d77363          	bgeu	a4,a3,191e <malloc+0x44>
    191c:	6a05                	lui	s4,0x1
    191e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1922:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1926:	00000917          	auipc	s2,0x0
    192a:	74a90913          	addi	s2,s2,1866 # 2070 <freep>
  if(p == (char*)-1)
    192e:	5afd                	li	s5,-1
    1930:	a081                	j	1970 <malloc+0x96>
    1932:	f04a                	sd	s2,32(sp)
    1934:	e852                	sd	s4,16(sp)
    1936:	e456                	sd	s5,8(sp)
    1938:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    193a:	00001797          	auipc	a5,0x1
    193e:	94678793          	addi	a5,a5,-1722 # 2280 <base>
    1942:	00000717          	auipc	a4,0x0
    1946:	72f73723          	sd	a5,1838(a4) # 2070 <freep>
    194a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    194c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1950:	b7c1                	j	1910 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1952:	6398                	ld	a4,0(a5)
    1954:	e118                	sd	a4,0(a0)
    1956:	a8a9                	j	19b0 <malloc+0xd6>
  hp->s.size = nu;
    1958:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    195c:	0541                	addi	a0,a0,16
    195e:	efbff0ef          	jal	1858 <free>
  return freep;
    1962:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1966:	c12d                	beqz	a0,19c8 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1968:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    196a:	4798                	lw	a4,8(a5)
    196c:	02977263          	bgeu	a4,s1,1990 <malloc+0xb6>
    if(p == freep)
    1970:	00093703          	ld	a4,0(s2)
    1974:	853e                	mv	a0,a5
    1976:	fef719e3          	bne	a4,a5,1968 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    197a:	8552                	mv	a0,s4
    197c:	ad3ff0ef          	jal	144e <sbrk>
  if(p == (char*)-1)
    1980:	fd551ce3          	bne	a0,s5,1958 <malloc+0x7e>
        return 0;
    1984:	4501                	li	a0,0
    1986:	7902                	ld	s2,32(sp)
    1988:	6a42                	ld	s4,16(sp)
    198a:	6aa2                	ld	s5,8(sp)
    198c:	6b02                	ld	s6,0(sp)
    198e:	a03d                	j	19bc <malloc+0xe2>
    1990:	7902                	ld	s2,32(sp)
    1992:	6a42                	ld	s4,16(sp)
    1994:	6aa2                	ld	s5,8(sp)
    1996:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1998:	fae48de3          	beq	s1,a4,1952 <malloc+0x78>
        p->s.size -= nunits;
    199c:	4137073b          	subw	a4,a4,s3
    19a0:	c798                	sw	a4,8(a5)
        p += p->s.size;
    19a2:	02071693          	slli	a3,a4,0x20
    19a6:	01c6d713          	srli	a4,a3,0x1c
    19aa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    19ac:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    19b0:	00000717          	auipc	a4,0x0
    19b4:	6ca73023          	sd	a0,1728(a4) # 2070 <freep>
      return (void*)(p + 1);
    19b8:	01078513          	addi	a0,a5,16
  }
}
    19bc:	70e2                	ld	ra,56(sp)
    19be:	7442                	ld	s0,48(sp)
    19c0:	74a2                	ld	s1,40(sp)
    19c2:	69e2                	ld	s3,24(sp)
    19c4:	6121                	addi	sp,sp,64
    19c6:	8082                	ret
    19c8:	7902                	ld	s2,32(sp)
    19ca:	6a42                	ld	s4,16(sp)
    19cc:	6aa2                	ld	s5,8(sp)
    19ce:	6b02                	ld	s6,0(sp)
    19d0:	b7f5                	j	19bc <malloc+0xe2>
	...
