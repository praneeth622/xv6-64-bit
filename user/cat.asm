
user/_cat:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <cat>:

char buf[512];

void
cat(int fd)
{
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	e84a                	sd	s2,16(sp)
    100a:	e44e                	sd	s3,8(sp)
    100c:	1800                	addi	s0,sp,48
    100e:	89aa                	mv	s3,a0
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
    1010:	00001917          	auipc	s2,0x1
    1014:	07090913          	addi	s2,s2,112 # 2080 <buf>
    1018:	20000613          	li	a2,512
    101c:	85ca                	mv	a1,s2
    101e:	854e                	mv	a0,s3
    1020:	34c000ef          	jal	136c <read>
    1024:	84aa                	mv	s1,a0
    1026:	02a05363          	blez	a0,104c <cat+0x4c>
    if (write(1, buf, n) != n) {
    102a:	8626                	mv	a2,s1
    102c:	85ca                	mv	a1,s2
    102e:	4505                	li	a0,1
    1030:	344000ef          	jal	1374 <write>
    1034:	fe9502e3          	beq	a0,s1,1018 <cat+0x18>
      fprintf(2, "cat: write error\n");
    1038:	00001597          	auipc	a1,0x1
    103c:	fc858593          	addi	a1,a1,-56 # 2000 <malloc+0x798>
    1040:	4509                	li	a0,2
    1042:	748000ef          	jal	178a <fprintf>
      exit(1);
    1046:	4505                	li	a0,1
    1048:	30c000ef          	jal	1354 <exit>
    }
  }
  if(n < 0){
    104c:	00054963          	bltz	a0,105e <cat+0x5e>
    fprintf(2, "cat: read error\n");
    exit(1);
  }
}
    1050:	70a2                	ld	ra,40(sp)
    1052:	7402                	ld	s0,32(sp)
    1054:	64e2                	ld	s1,24(sp)
    1056:	6942                	ld	s2,16(sp)
    1058:	69a2                	ld	s3,8(sp)
    105a:	6145                	addi	sp,sp,48
    105c:	8082                	ret
    fprintf(2, "cat: read error\n");
    105e:	00001597          	auipc	a1,0x1
    1062:	fba58593          	addi	a1,a1,-70 # 2018 <malloc+0x7b0>
    1066:	4509                	li	a0,2
    1068:	722000ef          	jal	178a <fprintf>
    exit(1);
    106c:	4505                	li	a0,1
    106e:	2e6000ef          	jal	1354 <exit>

0000000000001072 <main>:

int
main(int argc, char *argv[])
{
    1072:	7179                	addi	sp,sp,-48
    1074:	f406                	sd	ra,40(sp)
    1076:	f022                	sd	s0,32(sp)
    1078:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
    107a:	4785                	li	a5,1
    107c:	04a7d263          	bge	a5,a0,10c0 <main+0x4e>
    1080:	ec26                	sd	s1,24(sp)
    1082:	e84a                	sd	s2,16(sp)
    1084:	e44e                	sd	s3,8(sp)
    1086:	00858913          	addi	s2,a1,8
    108a:	ffe5099b          	addiw	s3,a0,-2
    108e:	02099793          	slli	a5,s3,0x20
    1092:	01d7d993          	srli	s3,a5,0x1d
    1096:	05c1                	addi	a1,a1,16
    1098:	99ae                	add	s3,s3,a1
    cat(0);
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
    109a:	4581                	li	a1,0
    109c:	00093503          	ld	a0,0(s2)
    10a0:	2f4000ef          	jal	1394 <open>
    10a4:	84aa                	mv	s1,a0
    10a6:	02054663          	bltz	a0,10d2 <main+0x60>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
      exit(1);
    }
    cat(fd);
    10aa:	f57ff0ef          	jal	1000 <cat>
    close(fd);
    10ae:	8526                	mv	a0,s1
    10b0:	2cc000ef          	jal	137c <close>
  for(i = 1; i < argc; i++){
    10b4:	0921                	addi	s2,s2,8
    10b6:	ff3912e3          	bne	s2,s3,109a <main+0x28>
  }
  exit(0);
    10ba:	4501                	li	a0,0
    10bc:	298000ef          	jal	1354 <exit>
    10c0:	ec26                	sd	s1,24(sp)
    10c2:	e84a                	sd	s2,16(sp)
    10c4:	e44e                	sd	s3,8(sp)
    cat(0);
    10c6:	4501                	li	a0,0
    10c8:	f39ff0ef          	jal	1000 <cat>
    exit(0);
    10cc:	4501                	li	a0,0
    10ce:	286000ef          	jal	1354 <exit>
      fprintf(2, "cat: cannot open %s\n", argv[i]);
    10d2:	00093603          	ld	a2,0(s2)
    10d6:	00001597          	auipc	a1,0x1
    10da:	f5a58593          	addi	a1,a1,-166 # 2030 <malloc+0x7c8>
    10de:	4509                	li	a0,2
    10e0:	6aa000ef          	jal	178a <fprintf>
      exit(1);
    10e4:	4505                	li	a0,1
    10e6:	26e000ef          	jal	1354 <exit>

00000000000010ea <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    10ea:	1141                	addi	sp,sp,-16
    10ec:	e406                	sd	ra,8(sp)
    10ee:	e022                	sd	s0,0(sp)
    10f0:	0800                	addi	s0,sp,16
  extern int main();
  main();
    10f2:	f81ff0ef          	jal	1072 <main>
  exit(0);
    10f6:	4501                	li	a0,0
    10f8:	25c000ef          	jal	1354 <exit>

00000000000010fc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    10fc:	1141                	addi	sp,sp,-16
    10fe:	e422                	sd	s0,8(sp)
    1100:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1102:	87aa                	mv	a5,a0
    1104:	0585                	addi	a1,a1,1
    1106:	0785                	addi	a5,a5,1
    1108:	fff5c703          	lbu	a4,-1(a1)
    110c:	fee78fa3          	sb	a4,-1(a5)
    1110:	fb75                	bnez	a4,1104 <strcpy+0x8>
    ;
  return os;
}
    1112:	6422                	ld	s0,8(sp)
    1114:	0141                	addi	sp,sp,16
    1116:	8082                	ret

0000000000001118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1118:	1141                	addi	sp,sp,-16
    111a:	e422                	sd	s0,8(sp)
    111c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    111e:	00054783          	lbu	a5,0(a0)
    1122:	cb91                	beqz	a5,1136 <strcmp+0x1e>
    1124:	0005c703          	lbu	a4,0(a1)
    1128:	00f71763          	bne	a4,a5,1136 <strcmp+0x1e>
    p++, q++;
    112c:	0505                	addi	a0,a0,1
    112e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1130:	00054783          	lbu	a5,0(a0)
    1134:	fbe5                	bnez	a5,1124 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1136:	0005c503          	lbu	a0,0(a1)
}
    113a:	40a7853b          	subw	a0,a5,a0
    113e:	6422                	ld	s0,8(sp)
    1140:	0141                	addi	sp,sp,16
    1142:	8082                	ret

0000000000001144 <strlen>:

uint
strlen(const char *s)
{
    1144:	1141                	addi	sp,sp,-16
    1146:	e422                	sd	s0,8(sp)
    1148:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    114a:	00054783          	lbu	a5,0(a0)
    114e:	cf91                	beqz	a5,116a <strlen+0x26>
    1150:	0505                	addi	a0,a0,1
    1152:	87aa                	mv	a5,a0
    1154:	86be                	mv	a3,a5
    1156:	0785                	addi	a5,a5,1
    1158:	fff7c703          	lbu	a4,-1(a5)
    115c:	ff65                	bnez	a4,1154 <strlen+0x10>
    115e:	40a6853b          	subw	a0,a3,a0
    1162:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    1164:	6422                	ld	s0,8(sp)
    1166:	0141                	addi	sp,sp,16
    1168:	8082                	ret
  for(n = 0; s[n]; n++)
    116a:	4501                	li	a0,0
    116c:	bfe5                	j	1164 <strlen+0x20>

000000000000116e <memset>:

void*
memset(void *dst, int c, uint n)
{
    116e:	1141                	addi	sp,sp,-16
    1170:	e422                	sd	s0,8(sp)
    1172:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1174:	ca19                	beqz	a2,118a <memset+0x1c>
    1176:	87aa                	mv	a5,a0
    1178:	1602                	slli	a2,a2,0x20
    117a:	9201                	srli	a2,a2,0x20
    117c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1180:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1184:	0785                	addi	a5,a5,1
    1186:	fee79de3          	bne	a5,a4,1180 <memset+0x12>
  }
  return dst;
}
    118a:	6422                	ld	s0,8(sp)
    118c:	0141                	addi	sp,sp,16
    118e:	8082                	ret

0000000000001190 <strchr>:

char*
strchr(const char *s, char c)
{
    1190:	1141                	addi	sp,sp,-16
    1192:	e422                	sd	s0,8(sp)
    1194:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1196:	00054783          	lbu	a5,0(a0)
    119a:	cb99                	beqz	a5,11b0 <strchr+0x20>
    if(*s == c)
    119c:	00f58763          	beq	a1,a5,11aa <strchr+0x1a>
  for(; *s; s++)
    11a0:	0505                	addi	a0,a0,1
    11a2:	00054783          	lbu	a5,0(a0)
    11a6:	fbfd                	bnez	a5,119c <strchr+0xc>
      return (char*)s;
  return 0;
    11a8:	4501                	li	a0,0
}
    11aa:	6422                	ld	s0,8(sp)
    11ac:	0141                	addi	sp,sp,16
    11ae:	8082                	ret
  return 0;
    11b0:	4501                	li	a0,0
    11b2:	bfe5                	j	11aa <strchr+0x1a>

00000000000011b4 <gets>:

char*
gets(char *buf, int max)
{
    11b4:	711d                	addi	sp,sp,-96
    11b6:	ec86                	sd	ra,88(sp)
    11b8:	e8a2                	sd	s0,80(sp)
    11ba:	e4a6                	sd	s1,72(sp)
    11bc:	e0ca                	sd	s2,64(sp)
    11be:	fc4e                	sd	s3,56(sp)
    11c0:	f852                	sd	s4,48(sp)
    11c2:	f456                	sd	s5,40(sp)
    11c4:	f05a                	sd	s6,32(sp)
    11c6:	ec5e                	sd	s7,24(sp)
    11c8:	1080                	addi	s0,sp,96
    11ca:	8baa                	mv	s7,a0
    11cc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11ce:	892a                	mv	s2,a0
    11d0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    11d2:	4aa9                	li	s5,10
    11d4:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    11d6:	89a6                	mv	s3,s1
    11d8:	2485                	addiw	s1,s1,1
    11da:	0344d663          	bge	s1,s4,1206 <gets+0x52>
    cc = read(0, &c, 1);
    11de:	4605                	li	a2,1
    11e0:	faf40593          	addi	a1,s0,-81
    11e4:	4501                	li	a0,0
    11e6:	186000ef          	jal	136c <read>
    if(cc < 1)
    11ea:	00a05e63          	blez	a0,1206 <gets+0x52>
    buf[i++] = c;
    11ee:	faf44783          	lbu	a5,-81(s0)
    11f2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    11f6:	01578763          	beq	a5,s5,1204 <gets+0x50>
    11fa:	0905                	addi	s2,s2,1
    11fc:	fd679de3          	bne	a5,s6,11d6 <gets+0x22>
    buf[i++] = c;
    1200:	89a6                	mv	s3,s1
    1202:	a011                	j	1206 <gets+0x52>
    1204:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1206:	99de                	add	s3,s3,s7
    1208:	00098023          	sb	zero,0(s3)
  return buf;
}
    120c:	855e                	mv	a0,s7
    120e:	60e6                	ld	ra,88(sp)
    1210:	6446                	ld	s0,80(sp)
    1212:	64a6                	ld	s1,72(sp)
    1214:	6906                	ld	s2,64(sp)
    1216:	79e2                	ld	s3,56(sp)
    1218:	7a42                	ld	s4,48(sp)
    121a:	7aa2                	ld	s5,40(sp)
    121c:	7b02                	ld	s6,32(sp)
    121e:	6be2                	ld	s7,24(sp)
    1220:	6125                	addi	sp,sp,96
    1222:	8082                	ret

0000000000001224 <stat>:

int
stat(const char *n, struct stat *st)
{
    1224:	1101                	addi	sp,sp,-32
    1226:	ec06                	sd	ra,24(sp)
    1228:	e822                	sd	s0,16(sp)
    122a:	e04a                	sd	s2,0(sp)
    122c:	1000                	addi	s0,sp,32
    122e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1230:	4581                	li	a1,0
    1232:	162000ef          	jal	1394 <open>
  if(fd < 0)
    1236:	02054263          	bltz	a0,125a <stat+0x36>
    123a:	e426                	sd	s1,8(sp)
    123c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    123e:	85ca                	mv	a1,s2
    1240:	16c000ef          	jal	13ac <fstat>
    1244:	892a                	mv	s2,a0
  close(fd);
    1246:	8526                	mv	a0,s1
    1248:	134000ef          	jal	137c <close>
  return r;
    124c:	64a2                	ld	s1,8(sp)
}
    124e:	854a                	mv	a0,s2
    1250:	60e2                	ld	ra,24(sp)
    1252:	6442                	ld	s0,16(sp)
    1254:	6902                	ld	s2,0(sp)
    1256:	6105                	addi	sp,sp,32
    1258:	8082                	ret
    return -1;
    125a:	597d                	li	s2,-1
    125c:	bfcd                	j	124e <stat+0x2a>

000000000000125e <atoi>:

int
atoi(const char *s)
{
    125e:	1141                	addi	sp,sp,-16
    1260:	e422                	sd	s0,8(sp)
    1262:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1264:	00054683          	lbu	a3,0(a0)
    1268:	fd06879b          	addiw	a5,a3,-48
    126c:	0ff7f793          	zext.b	a5,a5
    1270:	4625                	li	a2,9
    1272:	02f66863          	bltu	a2,a5,12a2 <atoi+0x44>
    1276:	872a                	mv	a4,a0
  n = 0;
    1278:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    127a:	0705                	addi	a4,a4,1
    127c:	0025179b          	slliw	a5,a0,0x2
    1280:	9fa9                	addw	a5,a5,a0
    1282:	0017979b          	slliw	a5,a5,0x1
    1286:	9fb5                	addw	a5,a5,a3
    1288:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    128c:	00074683          	lbu	a3,0(a4)
    1290:	fd06879b          	addiw	a5,a3,-48
    1294:	0ff7f793          	zext.b	a5,a5
    1298:	fef671e3          	bgeu	a2,a5,127a <atoi+0x1c>
  return n;
}
    129c:	6422                	ld	s0,8(sp)
    129e:	0141                	addi	sp,sp,16
    12a0:	8082                	ret
  n = 0;
    12a2:	4501                	li	a0,0
    12a4:	bfe5                	j	129c <atoi+0x3e>

00000000000012a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    12a6:	1141                	addi	sp,sp,-16
    12a8:	e422                	sd	s0,8(sp)
    12aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    12ac:	02b57463          	bgeu	a0,a1,12d4 <memmove+0x2e>
    while(n-- > 0)
    12b0:	00c05f63          	blez	a2,12ce <memmove+0x28>
    12b4:	1602                	slli	a2,a2,0x20
    12b6:	9201                	srli	a2,a2,0x20
    12b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    12bc:	872a                	mv	a4,a0
      *dst++ = *src++;
    12be:	0585                	addi	a1,a1,1
    12c0:	0705                	addi	a4,a4,1
    12c2:	fff5c683          	lbu	a3,-1(a1)
    12c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    12ca:	fef71ae3          	bne	a4,a5,12be <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    12ce:	6422                	ld	s0,8(sp)
    12d0:	0141                	addi	sp,sp,16
    12d2:	8082                	ret
    dst += n;
    12d4:	00c50733          	add	a4,a0,a2
    src += n;
    12d8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    12da:	fec05ae3          	blez	a2,12ce <memmove+0x28>
    12de:	fff6079b          	addiw	a5,a2,-1
    12e2:	1782                	slli	a5,a5,0x20
    12e4:	9381                	srli	a5,a5,0x20
    12e6:	fff7c793          	not	a5,a5
    12ea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    12ec:	15fd                	addi	a1,a1,-1
    12ee:	177d                	addi	a4,a4,-1
    12f0:	0005c683          	lbu	a3,0(a1)
    12f4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    12f8:	fee79ae3          	bne	a5,a4,12ec <memmove+0x46>
    12fc:	bfc9                	j	12ce <memmove+0x28>

00000000000012fe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    12fe:	1141                	addi	sp,sp,-16
    1300:	e422                	sd	s0,8(sp)
    1302:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1304:	ca05                	beqz	a2,1334 <memcmp+0x36>
    1306:	fff6069b          	addiw	a3,a2,-1
    130a:	1682                	slli	a3,a3,0x20
    130c:	9281                	srli	a3,a3,0x20
    130e:	0685                	addi	a3,a3,1
    1310:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1312:	00054783          	lbu	a5,0(a0)
    1316:	0005c703          	lbu	a4,0(a1)
    131a:	00e79863          	bne	a5,a4,132a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    131e:	0505                	addi	a0,a0,1
    p2++;
    1320:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1322:	fed518e3          	bne	a0,a3,1312 <memcmp+0x14>
  }
  return 0;
    1326:	4501                	li	a0,0
    1328:	a019                	j	132e <memcmp+0x30>
      return *p1 - *p2;
    132a:	40e7853b          	subw	a0,a5,a4
}
    132e:	6422                	ld	s0,8(sp)
    1330:	0141                	addi	sp,sp,16
    1332:	8082                	ret
  return 0;
    1334:	4501                	li	a0,0
    1336:	bfe5                	j	132e <memcmp+0x30>

0000000000001338 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1338:	1141                	addi	sp,sp,-16
    133a:	e406                	sd	ra,8(sp)
    133c:	e022                	sd	s0,0(sp)
    133e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1340:	f67ff0ef          	jal	12a6 <memmove>
}
    1344:	60a2                	ld	ra,8(sp)
    1346:	6402                	ld	s0,0(sp)
    1348:	0141                	addi	sp,sp,16
    134a:	8082                	ret

000000000000134c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    134c:	4885                	li	a7,1
 ecall
    134e:	00000073          	ecall
 ret
    1352:	8082                	ret

0000000000001354 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1354:	4889                	li	a7,2
 ecall
    1356:	00000073          	ecall
 ret
    135a:	8082                	ret

000000000000135c <wait>:
.global wait
wait:
 li a7, SYS_wait
    135c:	488d                	li	a7,3
 ecall
    135e:	00000073          	ecall
 ret
    1362:	8082                	ret

0000000000001364 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1364:	4891                	li	a7,4
 ecall
    1366:	00000073          	ecall
 ret
    136a:	8082                	ret

000000000000136c <read>:
.global read
read:
 li a7, SYS_read
    136c:	4895                	li	a7,5
 ecall
    136e:	00000073          	ecall
 ret
    1372:	8082                	ret

0000000000001374 <write>:
.global write
write:
 li a7, SYS_write
    1374:	48c1                	li	a7,16
 ecall
    1376:	00000073          	ecall
 ret
    137a:	8082                	ret

000000000000137c <close>:
.global close
close:
 li a7, SYS_close
    137c:	48d5                	li	a7,21
 ecall
    137e:	00000073          	ecall
 ret
    1382:	8082                	ret

0000000000001384 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1384:	4899                	li	a7,6
 ecall
    1386:	00000073          	ecall
 ret
    138a:	8082                	ret

000000000000138c <exec>:
.global exec
exec:
 li a7, SYS_exec
    138c:	489d                	li	a7,7
 ecall
    138e:	00000073          	ecall
 ret
    1392:	8082                	ret

0000000000001394 <open>:
.global open
open:
 li a7, SYS_open
    1394:	48bd                	li	a7,15
 ecall
    1396:	00000073          	ecall
 ret
    139a:	8082                	ret

000000000000139c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    139c:	48c5                	li	a7,17
 ecall
    139e:	00000073          	ecall
 ret
    13a2:	8082                	ret

00000000000013a4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    13a4:	48c9                	li	a7,18
 ecall
    13a6:	00000073          	ecall
 ret
    13aa:	8082                	ret

00000000000013ac <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    13ac:	48a1                	li	a7,8
 ecall
    13ae:	00000073          	ecall
 ret
    13b2:	8082                	ret

00000000000013b4 <link>:
.global link
link:
 li a7, SYS_link
    13b4:	48cd                	li	a7,19
 ecall
    13b6:	00000073          	ecall
 ret
    13ba:	8082                	ret

00000000000013bc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    13bc:	48d1                	li	a7,20
 ecall
    13be:	00000073          	ecall
 ret
    13c2:	8082                	ret

00000000000013c4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    13c4:	48a5                	li	a7,9
 ecall
    13c6:	00000073          	ecall
 ret
    13ca:	8082                	ret

00000000000013cc <dup>:
.global dup
dup:
 li a7, SYS_dup
    13cc:	48a9                	li	a7,10
 ecall
    13ce:	00000073          	ecall
 ret
    13d2:	8082                	ret

00000000000013d4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    13d4:	48ad                	li	a7,11
 ecall
    13d6:	00000073          	ecall
 ret
    13da:	8082                	ret

00000000000013dc <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    13dc:	48b1                	li	a7,12
 ecall
    13de:	00000073          	ecall
 ret
    13e2:	8082                	ret

00000000000013e4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    13e4:	48b5                	li	a7,13
 ecall
    13e6:	00000073          	ecall
 ret
    13ea:	8082                	ret

00000000000013ec <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    13ec:	48b9                	li	a7,14
 ecall
    13ee:	00000073          	ecall
 ret
    13f2:	8082                	ret

00000000000013f4 <cps>:
.global cps
cps:
 li a7, SYS_cps
    13f4:	48d9                	li	a7,22
 ecall
    13f6:	00000073          	ecall
 ret
    13fa:	8082                	ret

00000000000013fc <signal>:
.global signal
signal:
 li a7, SYS_signal
    13fc:	48dd                	li	a7,23
 ecall
    13fe:	00000073          	ecall
 ret
    1402:	8082                	ret

0000000000001404 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1404:	48e1                	li	a7,24
 ecall
    1406:	00000073          	ecall
 ret
    140a:	8082                	ret

000000000000140c <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    140c:	48e5                	li	a7,25
 ecall
    140e:	00000073          	ecall
 ret
    1412:	8082                	ret

0000000000001414 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1414:	48e9                	li	a7,26
 ecall
    1416:	00000073          	ecall
 ret
    141a:	8082                	ret

000000000000141c <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    141c:	48ed                	li	a7,27
 ecall
    141e:	00000073          	ecall
 ret
    1422:	8082                	ret

0000000000001424 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1424:	48f1                	li	a7,28
 ecall
    1426:	00000073          	ecall
 ret
    142a:	8082                	ret

000000000000142c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    142c:	48f5                	li	a7,29
 ecall
    142e:	00000073          	ecall
 ret
    1432:	8082                	ret

0000000000001434 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1434:	48f9                	li	a7,30
 ecall
    1436:	00000073          	ecall
 ret
    143a:	8082                	ret

000000000000143c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    143c:	1101                	addi	sp,sp,-32
    143e:	ec06                	sd	ra,24(sp)
    1440:	e822                	sd	s0,16(sp)
    1442:	1000                	addi	s0,sp,32
    1444:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1448:	4605                	li	a2,1
    144a:	fef40593          	addi	a1,s0,-17
    144e:	f27ff0ef          	jal	1374 <write>
}
    1452:	60e2                	ld	ra,24(sp)
    1454:	6442                	ld	s0,16(sp)
    1456:	6105                	addi	sp,sp,32
    1458:	8082                	ret

000000000000145a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    145a:	7139                	addi	sp,sp,-64
    145c:	fc06                	sd	ra,56(sp)
    145e:	f822                	sd	s0,48(sp)
    1460:	f426                	sd	s1,40(sp)
    1462:	0080                	addi	s0,sp,64
    1464:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1466:	c299                	beqz	a3,146c <printint+0x12>
    1468:	0805c963          	bltz	a1,14fa <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    146c:	2581                	sext.w	a1,a1
  neg = 0;
    146e:	4881                	li	a7,0
    1470:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1474:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1476:	2601                	sext.w	a2,a2
    1478:	00001517          	auipc	a0,0x1
    147c:	bd850513          	addi	a0,a0,-1064 # 2050 <digits>
    1480:	883a                	mv	a6,a4
    1482:	2705                	addiw	a4,a4,1
    1484:	02c5f7bb          	remuw	a5,a1,a2
    1488:	1782                	slli	a5,a5,0x20
    148a:	9381                	srli	a5,a5,0x20
    148c:	97aa                	add	a5,a5,a0
    148e:	0007c783          	lbu	a5,0(a5)
    1492:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1496:	0005879b          	sext.w	a5,a1
    149a:	02c5d5bb          	divuw	a1,a1,a2
    149e:	0685                	addi	a3,a3,1
    14a0:	fec7f0e3          	bgeu	a5,a2,1480 <printint+0x26>
  if(neg)
    14a4:	00088c63          	beqz	a7,14bc <printint+0x62>
    buf[i++] = '-';
    14a8:	fd070793          	addi	a5,a4,-48
    14ac:	00878733          	add	a4,a5,s0
    14b0:	02d00793          	li	a5,45
    14b4:	fef70823          	sb	a5,-16(a4)
    14b8:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    14bc:	02e05a63          	blez	a4,14f0 <printint+0x96>
    14c0:	f04a                	sd	s2,32(sp)
    14c2:	ec4e                	sd	s3,24(sp)
    14c4:	fc040793          	addi	a5,s0,-64
    14c8:	00e78933          	add	s2,a5,a4
    14cc:	fff78993          	addi	s3,a5,-1
    14d0:	99ba                	add	s3,s3,a4
    14d2:	377d                	addiw	a4,a4,-1
    14d4:	1702                	slli	a4,a4,0x20
    14d6:	9301                	srli	a4,a4,0x20
    14d8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    14dc:	fff94583          	lbu	a1,-1(s2)
    14e0:	8526                	mv	a0,s1
    14e2:	f5bff0ef          	jal	143c <putc>
  while(--i >= 0)
    14e6:	197d                	addi	s2,s2,-1
    14e8:	ff391ae3          	bne	s2,s3,14dc <printint+0x82>
    14ec:	7902                	ld	s2,32(sp)
    14ee:	69e2                	ld	s3,24(sp)
}
    14f0:	70e2                	ld	ra,56(sp)
    14f2:	7442                	ld	s0,48(sp)
    14f4:	74a2                	ld	s1,40(sp)
    14f6:	6121                	addi	sp,sp,64
    14f8:	8082                	ret
    x = -xx;
    14fa:	40b005bb          	negw	a1,a1
    neg = 1;
    14fe:	4885                	li	a7,1
    x = -xx;
    1500:	bf85                	j	1470 <printint+0x16>

0000000000001502 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1502:	711d                	addi	sp,sp,-96
    1504:	ec86                	sd	ra,88(sp)
    1506:	e8a2                	sd	s0,80(sp)
    1508:	e0ca                	sd	s2,64(sp)
    150a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    150c:	0005c903          	lbu	s2,0(a1)
    1510:	26090863          	beqz	s2,1780 <vprintf+0x27e>
    1514:	e4a6                	sd	s1,72(sp)
    1516:	fc4e                	sd	s3,56(sp)
    1518:	f852                	sd	s4,48(sp)
    151a:	f456                	sd	s5,40(sp)
    151c:	f05a                	sd	s6,32(sp)
    151e:	ec5e                	sd	s7,24(sp)
    1520:	e862                	sd	s8,16(sp)
    1522:	e466                	sd	s9,8(sp)
    1524:	8b2a                	mv	s6,a0
    1526:	8a2e                	mv	s4,a1
    1528:	8bb2                	mv	s7,a2
  state = 0;
    152a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    152c:	4481                	li	s1,0
    152e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1530:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1534:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1538:	06c00c93          	li	s9,108
    153c:	a005                	j	155c <vprintf+0x5a>
        putc(fd, c0);
    153e:	85ca                	mv	a1,s2
    1540:	855a                	mv	a0,s6
    1542:	efbff0ef          	jal	143c <putc>
    1546:	a019                	j	154c <vprintf+0x4a>
    } else if(state == '%'){
    1548:	03598263          	beq	s3,s5,156c <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    154c:	2485                	addiw	s1,s1,1
    154e:	8726                	mv	a4,s1
    1550:	009a07b3          	add	a5,s4,s1
    1554:	0007c903          	lbu	s2,0(a5)
    1558:	20090c63          	beqz	s2,1770 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    155c:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1560:	fe0994e3          	bnez	s3,1548 <vprintf+0x46>
      if(c0 == '%'){
    1564:	fd579de3          	bne	a5,s5,153e <vprintf+0x3c>
        state = '%';
    1568:	89be                	mv	s3,a5
    156a:	b7cd                	j	154c <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    156c:	00ea06b3          	add	a3,s4,a4
    1570:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1574:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1576:	c681                	beqz	a3,157e <vprintf+0x7c>
    1578:	9752                	add	a4,a4,s4
    157a:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    157e:	03878f63          	beq	a5,s8,15bc <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1582:	05978963          	beq	a5,s9,15d4 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1586:	07500713          	li	a4,117
    158a:	0ee78363          	beq	a5,a4,1670 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    158e:	07800713          	li	a4,120
    1592:	12e78563          	beq	a5,a4,16bc <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1596:	07000713          	li	a4,112
    159a:	14e78a63          	beq	a5,a4,16ee <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    159e:	07300713          	li	a4,115
    15a2:	18e78a63          	beq	a5,a4,1736 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    15a6:	02500713          	li	a4,37
    15aa:	04e79563          	bne	a5,a4,15f4 <vprintf+0xf2>
        putc(fd, '%');
    15ae:	02500593          	li	a1,37
    15b2:	855a                	mv	a0,s6
    15b4:	e89ff0ef          	jal	143c <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    15b8:	4981                	li	s3,0
    15ba:	bf49                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    15bc:	008b8913          	addi	s2,s7,8
    15c0:	4685                	li	a3,1
    15c2:	4629                	li	a2,10
    15c4:	000ba583          	lw	a1,0(s7)
    15c8:	855a                	mv	a0,s6
    15ca:	e91ff0ef          	jal	145a <printint>
    15ce:	8bca                	mv	s7,s2
      state = 0;
    15d0:	4981                	li	s3,0
    15d2:	bfad                	j	154c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    15d4:	06400793          	li	a5,100
    15d8:	02f68963          	beq	a3,a5,160a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15dc:	06c00793          	li	a5,108
    15e0:	04f68263          	beq	a3,a5,1624 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    15e4:	07500793          	li	a5,117
    15e8:	0af68063          	beq	a3,a5,1688 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    15ec:	07800793          	li	a5,120
    15f0:	0ef68263          	beq	a3,a5,16d4 <vprintf+0x1d2>
        putc(fd, '%');
    15f4:	02500593          	li	a1,37
    15f8:	855a                	mv	a0,s6
    15fa:	e43ff0ef          	jal	143c <putc>
        putc(fd, c0);
    15fe:	85ca                	mv	a1,s2
    1600:	855a                	mv	a0,s6
    1602:	e3bff0ef          	jal	143c <putc>
      state = 0;
    1606:	4981                	li	s3,0
    1608:	b791                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    160a:	008b8913          	addi	s2,s7,8
    160e:	4685                	li	a3,1
    1610:	4629                	li	a2,10
    1612:	000ba583          	lw	a1,0(s7)
    1616:	855a                	mv	a0,s6
    1618:	e43ff0ef          	jal	145a <printint>
        i += 1;
    161c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    161e:	8bca                	mv	s7,s2
      state = 0;
    1620:	4981                	li	s3,0
        i += 1;
    1622:	b72d                	j	154c <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1624:	06400793          	li	a5,100
    1628:	02f60763          	beq	a2,a5,1656 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    162c:	07500793          	li	a5,117
    1630:	06f60963          	beq	a2,a5,16a2 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1634:	07800793          	li	a5,120
    1638:	faf61ee3          	bne	a2,a5,15f4 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    163c:	008b8913          	addi	s2,s7,8
    1640:	4681                	li	a3,0
    1642:	4641                	li	a2,16
    1644:	000ba583          	lw	a1,0(s7)
    1648:	855a                	mv	a0,s6
    164a:	e11ff0ef          	jal	145a <printint>
        i += 2;
    164e:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1650:	8bca                	mv	s7,s2
      state = 0;
    1652:	4981                	li	s3,0
        i += 2;
    1654:	bde5                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1656:	008b8913          	addi	s2,s7,8
    165a:	4685                	li	a3,1
    165c:	4629                	li	a2,10
    165e:	000ba583          	lw	a1,0(s7)
    1662:	855a                	mv	a0,s6
    1664:	df7ff0ef          	jal	145a <printint>
        i += 2;
    1668:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    166a:	8bca                	mv	s7,s2
      state = 0;
    166c:	4981                	li	s3,0
        i += 2;
    166e:	bdf9                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1670:	008b8913          	addi	s2,s7,8
    1674:	4681                	li	a3,0
    1676:	4629                	li	a2,10
    1678:	000ba583          	lw	a1,0(s7)
    167c:	855a                	mv	a0,s6
    167e:	dddff0ef          	jal	145a <printint>
    1682:	8bca                	mv	s7,s2
      state = 0;
    1684:	4981                	li	s3,0
    1686:	b5d9                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1688:	008b8913          	addi	s2,s7,8
    168c:	4681                	li	a3,0
    168e:	4629                	li	a2,10
    1690:	000ba583          	lw	a1,0(s7)
    1694:	855a                	mv	a0,s6
    1696:	dc5ff0ef          	jal	145a <printint>
        i += 1;
    169a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    169c:	8bca                	mv	s7,s2
      state = 0;
    169e:	4981                	li	s3,0
        i += 1;
    16a0:	b575                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    16a2:	008b8913          	addi	s2,s7,8
    16a6:	4681                	li	a3,0
    16a8:	4629                	li	a2,10
    16aa:	000ba583          	lw	a1,0(s7)
    16ae:	855a                	mv	a0,s6
    16b0:	dabff0ef          	jal	145a <printint>
        i += 2;
    16b4:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    16b6:	8bca                	mv	s7,s2
      state = 0;
    16b8:	4981                	li	s3,0
        i += 2;
    16ba:	bd49                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    16bc:	008b8913          	addi	s2,s7,8
    16c0:	4681                	li	a3,0
    16c2:	4641                	li	a2,16
    16c4:	000ba583          	lw	a1,0(s7)
    16c8:	855a                	mv	a0,s6
    16ca:	d91ff0ef          	jal	145a <printint>
    16ce:	8bca                	mv	s7,s2
      state = 0;
    16d0:	4981                	li	s3,0
    16d2:	bdad                	j	154c <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    16d4:	008b8913          	addi	s2,s7,8
    16d8:	4681                	li	a3,0
    16da:	4641                	li	a2,16
    16dc:	000ba583          	lw	a1,0(s7)
    16e0:	855a                	mv	a0,s6
    16e2:	d79ff0ef          	jal	145a <printint>
        i += 1;
    16e6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    16e8:	8bca                	mv	s7,s2
      state = 0;
    16ea:	4981                	li	s3,0
        i += 1;
    16ec:	b585                	j	154c <vprintf+0x4a>
    16ee:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    16f0:	008b8d13          	addi	s10,s7,8
    16f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    16f8:	03000593          	li	a1,48
    16fc:	855a                	mv	a0,s6
    16fe:	d3fff0ef          	jal	143c <putc>
  putc(fd, 'x');
    1702:	07800593          	li	a1,120
    1706:	855a                	mv	a0,s6
    1708:	d35ff0ef          	jal	143c <putc>
    170c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    170e:	00001b97          	auipc	s7,0x1
    1712:	942b8b93          	addi	s7,s7,-1726 # 2050 <digits>
    1716:	03c9d793          	srli	a5,s3,0x3c
    171a:	97de                	add	a5,a5,s7
    171c:	0007c583          	lbu	a1,0(a5)
    1720:	855a                	mv	a0,s6
    1722:	d1bff0ef          	jal	143c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1726:	0992                	slli	s3,s3,0x4
    1728:	397d                	addiw	s2,s2,-1
    172a:	fe0916e3          	bnez	s2,1716 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    172e:	8bea                	mv	s7,s10
      state = 0;
    1730:	4981                	li	s3,0
    1732:	6d02                	ld	s10,0(sp)
    1734:	bd21                	j	154c <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1736:	008b8993          	addi	s3,s7,8
    173a:	000bb903          	ld	s2,0(s7)
    173e:	00090f63          	beqz	s2,175c <vprintf+0x25a>
        for(; *s; s++)
    1742:	00094583          	lbu	a1,0(s2)
    1746:	c195                	beqz	a1,176a <vprintf+0x268>
          putc(fd, *s);
    1748:	855a                	mv	a0,s6
    174a:	cf3ff0ef          	jal	143c <putc>
        for(; *s; s++)
    174e:	0905                	addi	s2,s2,1
    1750:	00094583          	lbu	a1,0(s2)
    1754:	f9f5                	bnez	a1,1748 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1756:	8bce                	mv	s7,s3
      state = 0;
    1758:	4981                	li	s3,0
    175a:	bbcd                	j	154c <vprintf+0x4a>
          s = "(null)";
    175c:	00001917          	auipc	s2,0x1
    1760:	8ec90913          	addi	s2,s2,-1812 # 2048 <malloc+0x7e0>
        for(; *s; s++)
    1764:	02800593          	li	a1,40
    1768:	b7c5                	j	1748 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    176a:	8bce                	mv	s7,s3
      state = 0;
    176c:	4981                	li	s3,0
    176e:	bbf9                	j	154c <vprintf+0x4a>
    1770:	64a6                	ld	s1,72(sp)
    1772:	79e2                	ld	s3,56(sp)
    1774:	7a42                	ld	s4,48(sp)
    1776:	7aa2                	ld	s5,40(sp)
    1778:	7b02                	ld	s6,32(sp)
    177a:	6be2                	ld	s7,24(sp)
    177c:	6c42                	ld	s8,16(sp)
    177e:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1780:	60e6                	ld	ra,88(sp)
    1782:	6446                	ld	s0,80(sp)
    1784:	6906                	ld	s2,64(sp)
    1786:	6125                	addi	sp,sp,96
    1788:	8082                	ret

000000000000178a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    178a:	715d                	addi	sp,sp,-80
    178c:	ec06                	sd	ra,24(sp)
    178e:	e822                	sd	s0,16(sp)
    1790:	1000                	addi	s0,sp,32
    1792:	e010                	sd	a2,0(s0)
    1794:	e414                	sd	a3,8(s0)
    1796:	e818                	sd	a4,16(s0)
    1798:	ec1c                	sd	a5,24(s0)
    179a:	03043023          	sd	a6,32(s0)
    179e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    17a2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    17a6:	8622                	mv	a2,s0
    17a8:	d5bff0ef          	jal	1502 <vprintf>
}
    17ac:	60e2                	ld	ra,24(sp)
    17ae:	6442                	ld	s0,16(sp)
    17b0:	6161                	addi	sp,sp,80
    17b2:	8082                	ret

00000000000017b4 <printf>:

void
printf(const char *fmt, ...)
{
    17b4:	711d                	addi	sp,sp,-96
    17b6:	ec06                	sd	ra,24(sp)
    17b8:	e822                	sd	s0,16(sp)
    17ba:	1000                	addi	s0,sp,32
    17bc:	e40c                	sd	a1,8(s0)
    17be:	e810                	sd	a2,16(s0)
    17c0:	ec14                	sd	a3,24(s0)
    17c2:	f018                	sd	a4,32(s0)
    17c4:	f41c                	sd	a5,40(s0)
    17c6:	03043823          	sd	a6,48(s0)
    17ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    17ce:	00840613          	addi	a2,s0,8
    17d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    17d6:	85aa                	mv	a1,a0
    17d8:	4505                	li	a0,1
    17da:	d29ff0ef          	jal	1502 <vprintf>
}
    17de:	60e2                	ld	ra,24(sp)
    17e0:	6442                	ld	s0,16(sp)
    17e2:	6125                	addi	sp,sp,96
    17e4:	8082                	ret

00000000000017e6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17e6:	1141                	addi	sp,sp,-16
    17e8:	e422                	sd	s0,8(sp)
    17ea:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17ec:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17f0:	00001797          	auipc	a5,0x1
    17f4:	8807b783          	ld	a5,-1920(a5) # 2070 <freep>
    17f8:	a02d                	j	1822 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    17fa:	4618                	lw	a4,8(a2)
    17fc:	9f2d                	addw	a4,a4,a1
    17fe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1802:	6398                	ld	a4,0(a5)
    1804:	6310                	ld	a2,0(a4)
    1806:	a83d                	j	1844 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1808:	ff852703          	lw	a4,-8(a0)
    180c:	9f31                	addw	a4,a4,a2
    180e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1810:	ff053683          	ld	a3,-16(a0)
    1814:	a091                	j	1858 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1816:	6398                	ld	a4,0(a5)
    1818:	00e7e463          	bltu	a5,a4,1820 <free+0x3a>
    181c:	00e6ea63          	bltu	a3,a4,1830 <free+0x4a>
{
    1820:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1822:	fed7fae3          	bgeu	a5,a3,1816 <free+0x30>
    1826:	6398                	ld	a4,0(a5)
    1828:	00e6e463          	bltu	a3,a4,1830 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    182c:	fee7eae3          	bltu	a5,a4,1820 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1830:	ff852583          	lw	a1,-8(a0)
    1834:	6390                	ld	a2,0(a5)
    1836:	02059813          	slli	a6,a1,0x20
    183a:	01c85713          	srli	a4,a6,0x1c
    183e:	9736                	add	a4,a4,a3
    1840:	fae60de3          	beq	a2,a4,17fa <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1844:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1848:	4790                	lw	a2,8(a5)
    184a:	02061593          	slli	a1,a2,0x20
    184e:	01c5d713          	srli	a4,a1,0x1c
    1852:	973e                	add	a4,a4,a5
    1854:	fae68ae3          	beq	a3,a4,1808 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1858:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    185a:	00001717          	auipc	a4,0x1
    185e:	80f73b23          	sd	a5,-2026(a4) # 2070 <freep>
}
    1862:	6422                	ld	s0,8(sp)
    1864:	0141                	addi	sp,sp,16
    1866:	8082                	ret

0000000000001868 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1868:	7139                	addi	sp,sp,-64
    186a:	fc06                	sd	ra,56(sp)
    186c:	f822                	sd	s0,48(sp)
    186e:	f426                	sd	s1,40(sp)
    1870:	ec4e                	sd	s3,24(sp)
    1872:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1874:	02051493          	slli	s1,a0,0x20
    1878:	9081                	srli	s1,s1,0x20
    187a:	04bd                	addi	s1,s1,15
    187c:	8091                	srli	s1,s1,0x4
    187e:	0014899b          	addiw	s3,s1,1
    1882:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1884:	00000517          	auipc	a0,0x0
    1888:	7ec53503          	ld	a0,2028(a0) # 2070 <freep>
    188c:	c915                	beqz	a0,18c0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    188e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1890:	4798                	lw	a4,8(a5)
    1892:	08977a63          	bgeu	a4,s1,1926 <malloc+0xbe>
    1896:	f04a                	sd	s2,32(sp)
    1898:	e852                	sd	s4,16(sp)
    189a:	e456                	sd	s5,8(sp)
    189c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    189e:	8a4e                	mv	s4,s3
    18a0:	0009871b          	sext.w	a4,s3
    18a4:	6685                	lui	a3,0x1
    18a6:	00d77363          	bgeu	a4,a3,18ac <malloc+0x44>
    18aa:	6a05                	lui	s4,0x1
    18ac:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    18b0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    18b4:	00000917          	auipc	s2,0x0
    18b8:	7bc90913          	addi	s2,s2,1980 # 2070 <freep>
  if(p == (char*)-1)
    18bc:	5afd                	li	s5,-1
    18be:	a081                	j	18fe <malloc+0x96>
    18c0:	f04a                	sd	s2,32(sp)
    18c2:	e852                	sd	s4,16(sp)
    18c4:	e456                	sd	s5,8(sp)
    18c6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    18c8:	00001797          	auipc	a5,0x1
    18cc:	9b878793          	addi	a5,a5,-1608 # 2280 <base>
    18d0:	00000717          	auipc	a4,0x0
    18d4:	7af73023          	sd	a5,1952(a4) # 2070 <freep>
    18d8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    18da:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    18de:	b7c1                	j	189e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    18e0:	6398                	ld	a4,0(a5)
    18e2:	e118                	sd	a4,0(a0)
    18e4:	a8a9                	j	193e <malloc+0xd6>
  hp->s.size = nu;
    18e6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    18ea:	0541                	addi	a0,a0,16
    18ec:	efbff0ef          	jal	17e6 <free>
  return freep;
    18f0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    18f4:	c12d                	beqz	a0,1956 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18f6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    18f8:	4798                	lw	a4,8(a5)
    18fa:	02977263          	bgeu	a4,s1,191e <malloc+0xb6>
    if(p == freep)
    18fe:	00093703          	ld	a4,0(s2)
    1902:	853e                	mv	a0,a5
    1904:	fef719e3          	bne	a4,a5,18f6 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1908:	8552                	mv	a0,s4
    190a:	ad3ff0ef          	jal	13dc <sbrk>
  if(p == (char*)-1)
    190e:	fd551ce3          	bne	a0,s5,18e6 <malloc+0x7e>
        return 0;
    1912:	4501                	li	a0,0
    1914:	7902                	ld	s2,32(sp)
    1916:	6a42                	ld	s4,16(sp)
    1918:	6aa2                	ld	s5,8(sp)
    191a:	6b02                	ld	s6,0(sp)
    191c:	a03d                	j	194a <malloc+0xe2>
    191e:	7902                	ld	s2,32(sp)
    1920:	6a42                	ld	s4,16(sp)
    1922:	6aa2                	ld	s5,8(sp)
    1924:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1926:	fae48de3          	beq	s1,a4,18e0 <malloc+0x78>
        p->s.size -= nunits;
    192a:	4137073b          	subw	a4,a4,s3
    192e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1930:	02071693          	slli	a3,a4,0x20
    1934:	01c6d713          	srli	a4,a3,0x1c
    1938:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    193a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    193e:	00000717          	auipc	a4,0x0
    1942:	72a73923          	sd	a0,1842(a4) # 2070 <freep>
      return (void*)(p + 1);
    1946:	01078513          	addi	a0,a5,16
  }
}
    194a:	70e2                	ld	ra,56(sp)
    194c:	7442                	ld	s0,48(sp)
    194e:	74a2                	ld	s1,40(sp)
    1950:	69e2                	ld	s3,24(sp)
    1952:	6121                	addi	sp,sp,64
    1954:	8082                	ret
    1956:	7902                	ld	s2,32(sp)
    1958:	6a42                	ld	s4,16(sp)
    195a:	6aa2                	ld	s5,8(sp)
    195c:	6b02                	ld	s6,0(sp)
    195e:	b7f5                	j	194a <malloc+0xe2>
	...
