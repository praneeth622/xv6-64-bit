
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
    1000:	7179                	addi	sp,sp,-48
    1002:	f406                	sd	ra,40(sp)
    1004:	f022                	sd	s0,32(sp)
    1006:	ec26                	sd	s1,24(sp)
    1008:	e84a                	sd	s2,16(sp)
    100a:	e44e                	sd	s3,8(sp)
    100c:	e052                	sd	s4,0(sp)
    100e:	1800                	addi	s0,sp,48
    1010:	892a                	mv	s2,a0
    1012:	89ae                	mv	s3,a1
    1014:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
    1016:	02e00a13          	li	s4,46
    if(matchhere(re, text))
    101a:	85a6                	mv	a1,s1
    101c:	854e                	mv	a0,s3
    101e:	02c000ef          	jal	104a <matchhere>
    1022:	e919                	bnez	a0,1038 <matchstar+0x38>
  }while(*text!='\0' && (*text++==c || c=='.'));
    1024:	0004c783          	lbu	a5,0(s1)
    1028:	cb89                	beqz	a5,103a <matchstar+0x3a>
    102a:	0485                	addi	s1,s1,1
    102c:	2781                	sext.w	a5,a5
    102e:	ff2786e3          	beq	a5,s2,101a <matchstar+0x1a>
    1032:	ff4904e3          	beq	s2,s4,101a <matchstar+0x1a>
    1036:	a011                	j	103a <matchstar+0x3a>
      return 1;
    1038:	4505                	li	a0,1
  return 0;
}
    103a:	70a2                	ld	ra,40(sp)
    103c:	7402                	ld	s0,32(sp)
    103e:	64e2                	ld	s1,24(sp)
    1040:	6942                	ld	s2,16(sp)
    1042:	69a2                	ld	s3,8(sp)
    1044:	6a02                	ld	s4,0(sp)
    1046:	6145                	addi	sp,sp,48
    1048:	8082                	ret

000000000000104a <matchhere>:
  if(re[0] == '\0')
    104a:	00054703          	lbu	a4,0(a0)
    104e:	c73d                	beqz	a4,10bc <matchhere+0x72>
{
    1050:	1141                	addi	sp,sp,-16
    1052:	e406                	sd	ra,8(sp)
    1054:	e022                	sd	s0,0(sp)
    1056:	0800                	addi	s0,sp,16
    1058:	87aa                	mv	a5,a0
  if(re[1] == '*')
    105a:	00154683          	lbu	a3,1(a0)
    105e:	02a00613          	li	a2,42
    1062:	02c68563          	beq	a3,a2,108c <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
    1066:	02400613          	li	a2,36
    106a:	02c70863          	beq	a4,a2,109a <matchhere+0x50>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    106e:	0005c683          	lbu	a3,0(a1)
  return 0;
    1072:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    1074:	ca81                	beqz	a3,1084 <matchhere+0x3a>
    1076:	02e00613          	li	a2,46
    107a:	02c70b63          	beq	a4,a2,10b0 <matchhere+0x66>
  return 0;
    107e:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    1080:	02d70863          	beq	a4,a3,10b0 <matchhere+0x66>
}
    1084:	60a2                	ld	ra,8(sp)
    1086:	6402                	ld	s0,0(sp)
    1088:	0141                	addi	sp,sp,16
    108a:	8082                	ret
    return matchstar(re[0], re+2, text);
    108c:	862e                	mv	a2,a1
    108e:	00250593          	addi	a1,a0,2
    1092:	853a                	mv	a0,a4
    1094:	f6dff0ef          	jal	1000 <matchstar>
    1098:	b7f5                	j	1084 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
    109a:	c691                	beqz	a3,10a6 <matchhere+0x5c>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
    109c:	0005c683          	lbu	a3,0(a1)
    10a0:	fef9                	bnez	a3,107e <matchhere+0x34>
  return 0;
    10a2:	4501                	li	a0,0
    10a4:	b7c5                	j	1084 <matchhere+0x3a>
    return *text == '\0';
    10a6:	0005c503          	lbu	a0,0(a1)
    10aa:	00153513          	seqz	a0,a0
    10ae:	bfd9                	j	1084 <matchhere+0x3a>
    return matchhere(re+1, text+1);
    10b0:	0585                	addi	a1,a1,1
    10b2:	00178513          	addi	a0,a5,1
    10b6:	f95ff0ef          	jal	104a <matchhere>
    10ba:	b7e9                	j	1084 <matchhere+0x3a>
    return 1;
    10bc:	4505                	li	a0,1
}
    10be:	8082                	ret

00000000000010c0 <match>:
{
    10c0:	1101                	addi	sp,sp,-32
    10c2:	ec06                	sd	ra,24(sp)
    10c4:	e822                	sd	s0,16(sp)
    10c6:	e426                	sd	s1,8(sp)
    10c8:	e04a                	sd	s2,0(sp)
    10ca:	1000                	addi	s0,sp,32
    10cc:	892a                	mv	s2,a0
    10ce:	84ae                	mv	s1,a1
  if(re[0] == '^')
    10d0:	00054703          	lbu	a4,0(a0)
    10d4:	05e00793          	li	a5,94
    10d8:	00f70c63          	beq	a4,a5,10f0 <match+0x30>
    if(matchhere(re, text))
    10dc:	85a6                	mv	a1,s1
    10de:	854a                	mv	a0,s2
    10e0:	f6bff0ef          	jal	104a <matchhere>
    10e4:	e911                	bnez	a0,10f8 <match+0x38>
  }while(*text++ != '\0');
    10e6:	0485                	addi	s1,s1,1
    10e8:	fff4c783          	lbu	a5,-1(s1)
    10ec:	fbe5                	bnez	a5,10dc <match+0x1c>
    10ee:	a031                	j	10fa <match+0x3a>
    return matchhere(re+1, text);
    10f0:	0505                	addi	a0,a0,1
    10f2:	f59ff0ef          	jal	104a <matchhere>
    10f6:	a011                	j	10fa <match+0x3a>
      return 1;
    10f8:	4505                	li	a0,1
}
    10fa:	60e2                	ld	ra,24(sp)
    10fc:	6442                	ld	s0,16(sp)
    10fe:	64a2                	ld	s1,8(sp)
    1100:	6902                	ld	s2,0(sp)
    1102:	6105                	addi	sp,sp,32
    1104:	8082                	ret

0000000000001106 <grep>:
{
    1106:	715d                	addi	sp,sp,-80
    1108:	e486                	sd	ra,72(sp)
    110a:	e0a2                	sd	s0,64(sp)
    110c:	fc26                	sd	s1,56(sp)
    110e:	f84a                	sd	s2,48(sp)
    1110:	f44e                	sd	s3,40(sp)
    1112:	f052                	sd	s4,32(sp)
    1114:	ec56                	sd	s5,24(sp)
    1116:	e85a                	sd	s6,16(sp)
    1118:	e45e                	sd	s7,8(sp)
    111a:	e062                	sd	s8,0(sp)
    111c:	0880                	addi	s0,sp,80
    111e:	89aa                	mv	s3,a0
    1120:	8b2e                	mv	s6,a1
  m = 0;
    1122:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    1124:	3ff00b93          	li	s7,1023
    1128:	00001a97          	auipc	s5,0x1
    112c:	f48a8a93          	addi	s5,s5,-184 # 2070 <buf>
    1130:	a835                	j	116c <grep+0x66>
      p = q+1;
    1132:	00148913          	addi	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
    1136:	45a9                	li	a1,10
    1138:	854a                	mv	a0,s2
    113a:	1c6000ef          	jal	1300 <strchr>
    113e:	84aa                	mv	s1,a0
    1140:	c505                	beqz	a0,1168 <grep+0x62>
      *q = 0;
    1142:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
    1146:	85ca                	mv	a1,s2
    1148:	854e                	mv	a0,s3
    114a:	f77ff0ef          	jal	10c0 <match>
    114e:	d175                	beqz	a0,1132 <grep+0x2c>
        *q = '\n';
    1150:	47a9                	li	a5,10
    1152:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
    1156:	00148613          	addi	a2,s1,1
    115a:	4126063b          	subw	a2,a2,s2
    115e:	85ca                	mv	a1,s2
    1160:	4505                	li	a0,1
    1162:	382000ef          	jal	14e4 <write>
    1166:	b7f1                	j	1132 <grep+0x2c>
    if(m > 0){
    1168:	03404563          	bgtz	s4,1192 <grep+0x8c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
    116c:	414b863b          	subw	a2,s7,s4
    1170:	014a85b3          	add	a1,s5,s4
    1174:	855a                	mv	a0,s6
    1176:	366000ef          	jal	14dc <read>
    117a:	02a05963          	blez	a0,11ac <grep+0xa6>
    m += n;
    117e:	00aa0c3b          	addw	s8,s4,a0
    1182:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
    1186:	014a87b3          	add	a5,s5,s4
    118a:	00078023          	sb	zero,0(a5)
    p = buf;
    118e:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
    1190:	b75d                	j	1136 <grep+0x30>
      m -= p - buf;
    1192:	00001517          	auipc	a0,0x1
    1196:	ede50513          	addi	a0,a0,-290 # 2070 <buf>
    119a:	40a90a33          	sub	s4,s2,a0
    119e:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
    11a2:	8652                	mv	a2,s4
    11a4:	85ca                	mv	a1,s2
    11a6:	270000ef          	jal	1416 <memmove>
    11aa:	b7c9                	j	116c <grep+0x66>
}
    11ac:	60a6                	ld	ra,72(sp)
    11ae:	6406                	ld	s0,64(sp)
    11b0:	74e2                	ld	s1,56(sp)
    11b2:	7942                	ld	s2,48(sp)
    11b4:	79a2                	ld	s3,40(sp)
    11b6:	7a02                	ld	s4,32(sp)
    11b8:	6ae2                	ld	s5,24(sp)
    11ba:	6b42                	ld	s6,16(sp)
    11bc:	6ba2                	ld	s7,8(sp)
    11be:	6c02                	ld	s8,0(sp)
    11c0:	6161                	addi	sp,sp,80
    11c2:	8082                	ret

00000000000011c4 <main>:
{
    11c4:	7179                	addi	sp,sp,-48
    11c6:	f406                	sd	ra,40(sp)
    11c8:	f022                	sd	s0,32(sp)
    11ca:	ec26                	sd	s1,24(sp)
    11cc:	e84a                	sd	s2,16(sp)
    11ce:	e44e                	sd	s3,8(sp)
    11d0:	e052                	sd	s4,0(sp)
    11d2:	1800                	addi	s0,sp,48
  if(argc <= 1){
    11d4:	4785                	li	a5,1
    11d6:	04a7d663          	bge	a5,a0,1222 <main+0x5e>
  pattern = argv[1];
    11da:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
    11de:	4789                	li	a5,2
    11e0:	04a7db63          	bge	a5,a0,1236 <main+0x72>
    11e4:	01058913          	addi	s2,a1,16
    11e8:	ffd5099b          	addiw	s3,a0,-3
    11ec:	02099793          	slli	a5,s3,0x20
    11f0:	01d7d993          	srli	s3,a5,0x1d
    11f4:	05e1                	addi	a1,a1,24
    11f6:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], O_RDONLY)) < 0){
    11f8:	4581                	li	a1,0
    11fa:	00093503          	ld	a0,0(s2)
    11fe:	306000ef          	jal	1504 <open>
    1202:	84aa                	mv	s1,a0
    1204:	04054063          	bltz	a0,1244 <main+0x80>
    grep(pattern, fd);
    1208:	85aa                	mv	a1,a0
    120a:	8552                	mv	a0,s4
    120c:	efbff0ef          	jal	1106 <grep>
    close(fd);
    1210:	8526                	mv	a0,s1
    1212:	2da000ef          	jal	14ec <close>
  for(i = 2; i < argc; i++){
    1216:	0921                	addi	s2,s2,8
    1218:	ff3910e3          	bne	s2,s3,11f8 <main+0x34>
  exit(0);
    121c:	4501                	li	a0,0
    121e:	2a6000ef          	jal	14c4 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
    1222:	00001597          	auipc	a1,0x1
    1226:	dde58593          	addi	a1,a1,-546 # 2000 <malloc+0x628>
    122a:	4509                	li	a0,2
    122c:	6ce000ef          	jal	18fa <fprintf>
    exit(1);
    1230:	4505                	li	a0,1
    1232:	292000ef          	jal	14c4 <exit>
    grep(pattern, 0);
    1236:	4581                	li	a1,0
    1238:	8552                	mv	a0,s4
    123a:	ecdff0ef          	jal	1106 <grep>
    exit(0);
    123e:	4501                	li	a0,0
    1240:	284000ef          	jal	14c4 <exit>
      printf("grep: cannot open %s\n", argv[i]);
    1244:	00093583          	ld	a1,0(s2)
    1248:	00001517          	auipc	a0,0x1
    124c:	dd850513          	addi	a0,a0,-552 # 2020 <malloc+0x648>
    1250:	6d4000ef          	jal	1924 <printf>
      exit(1);
    1254:	4505                	li	a0,1
    1256:	26e000ef          	jal	14c4 <exit>

000000000000125a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    125a:	1141                	addi	sp,sp,-16
    125c:	e406                	sd	ra,8(sp)
    125e:	e022                	sd	s0,0(sp)
    1260:	0800                	addi	s0,sp,16
  extern int main();
  main();
    1262:	f63ff0ef          	jal	11c4 <main>
  exit(0);
    1266:	4501                	li	a0,0
    1268:	25c000ef          	jal	14c4 <exit>

000000000000126c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    126c:	1141                	addi	sp,sp,-16
    126e:	e422                	sd	s0,8(sp)
    1270:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    1272:	87aa                	mv	a5,a0
    1274:	0585                	addi	a1,a1,1
    1276:	0785                	addi	a5,a5,1
    1278:	fff5c703          	lbu	a4,-1(a1)
    127c:	fee78fa3          	sb	a4,-1(a5)
    1280:	fb75                	bnez	a4,1274 <strcpy+0x8>
    ;
  return os;
}
    1282:	6422                	ld	s0,8(sp)
    1284:	0141                	addi	sp,sp,16
    1286:	8082                	ret

0000000000001288 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1288:	1141                	addi	sp,sp,-16
    128a:	e422                	sd	s0,8(sp)
    128c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    128e:	00054783          	lbu	a5,0(a0)
    1292:	cb91                	beqz	a5,12a6 <strcmp+0x1e>
    1294:	0005c703          	lbu	a4,0(a1)
    1298:	00f71763          	bne	a4,a5,12a6 <strcmp+0x1e>
    p++, q++;
    129c:	0505                	addi	a0,a0,1
    129e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    12a0:	00054783          	lbu	a5,0(a0)
    12a4:	fbe5                	bnez	a5,1294 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    12a6:	0005c503          	lbu	a0,0(a1)
}
    12aa:	40a7853b          	subw	a0,a5,a0
    12ae:	6422                	ld	s0,8(sp)
    12b0:	0141                	addi	sp,sp,16
    12b2:	8082                	ret

00000000000012b4 <strlen>:

uint
strlen(const char *s)
{
    12b4:	1141                	addi	sp,sp,-16
    12b6:	e422                	sd	s0,8(sp)
    12b8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    12ba:	00054783          	lbu	a5,0(a0)
    12be:	cf91                	beqz	a5,12da <strlen+0x26>
    12c0:	0505                	addi	a0,a0,1
    12c2:	87aa                	mv	a5,a0
    12c4:	86be                	mv	a3,a5
    12c6:	0785                	addi	a5,a5,1
    12c8:	fff7c703          	lbu	a4,-1(a5)
    12cc:	ff65                	bnez	a4,12c4 <strlen+0x10>
    12ce:	40a6853b          	subw	a0,a3,a0
    12d2:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    12d4:	6422                	ld	s0,8(sp)
    12d6:	0141                	addi	sp,sp,16
    12d8:	8082                	ret
  for(n = 0; s[n]; n++)
    12da:	4501                	li	a0,0
    12dc:	bfe5                	j	12d4 <strlen+0x20>

00000000000012de <memset>:

void*
memset(void *dst, int c, uint n)
{
    12de:	1141                	addi	sp,sp,-16
    12e0:	e422                	sd	s0,8(sp)
    12e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    12e4:	ca19                	beqz	a2,12fa <memset+0x1c>
    12e6:	87aa                	mv	a5,a0
    12e8:	1602                	slli	a2,a2,0x20
    12ea:	9201                	srli	a2,a2,0x20
    12ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    12f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    12f4:	0785                	addi	a5,a5,1
    12f6:	fee79de3          	bne	a5,a4,12f0 <memset+0x12>
  }
  return dst;
}
    12fa:	6422                	ld	s0,8(sp)
    12fc:	0141                	addi	sp,sp,16
    12fe:	8082                	ret

0000000000001300 <strchr>:

char*
strchr(const char *s, char c)
{
    1300:	1141                	addi	sp,sp,-16
    1302:	e422                	sd	s0,8(sp)
    1304:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1306:	00054783          	lbu	a5,0(a0)
    130a:	cb99                	beqz	a5,1320 <strchr+0x20>
    if(*s == c)
    130c:	00f58763          	beq	a1,a5,131a <strchr+0x1a>
  for(; *s; s++)
    1310:	0505                	addi	a0,a0,1
    1312:	00054783          	lbu	a5,0(a0)
    1316:	fbfd                	bnez	a5,130c <strchr+0xc>
      return (char*)s;
  return 0;
    1318:	4501                	li	a0,0
}
    131a:	6422                	ld	s0,8(sp)
    131c:	0141                	addi	sp,sp,16
    131e:	8082                	ret
  return 0;
    1320:	4501                	li	a0,0
    1322:	bfe5                	j	131a <strchr+0x1a>

0000000000001324 <gets>:

char*
gets(char *buf, int max)
{
    1324:	711d                	addi	sp,sp,-96
    1326:	ec86                	sd	ra,88(sp)
    1328:	e8a2                	sd	s0,80(sp)
    132a:	e4a6                	sd	s1,72(sp)
    132c:	e0ca                	sd	s2,64(sp)
    132e:	fc4e                	sd	s3,56(sp)
    1330:	f852                	sd	s4,48(sp)
    1332:	f456                	sd	s5,40(sp)
    1334:	f05a                	sd	s6,32(sp)
    1336:	ec5e                	sd	s7,24(sp)
    1338:	1080                	addi	s0,sp,96
    133a:	8baa                	mv	s7,a0
    133c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    133e:	892a                	mv	s2,a0
    1340:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1342:	4aa9                	li	s5,10
    1344:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1346:	89a6                	mv	s3,s1
    1348:	2485                	addiw	s1,s1,1
    134a:	0344d663          	bge	s1,s4,1376 <gets+0x52>
    cc = read(0, &c, 1);
    134e:	4605                	li	a2,1
    1350:	faf40593          	addi	a1,s0,-81
    1354:	4501                	li	a0,0
    1356:	186000ef          	jal	14dc <read>
    if(cc < 1)
    135a:	00a05e63          	blez	a0,1376 <gets+0x52>
    buf[i++] = c;
    135e:	faf44783          	lbu	a5,-81(s0)
    1362:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1366:	01578763          	beq	a5,s5,1374 <gets+0x50>
    136a:	0905                	addi	s2,s2,1
    136c:	fd679de3          	bne	a5,s6,1346 <gets+0x22>
    buf[i++] = c;
    1370:	89a6                	mv	s3,s1
    1372:	a011                	j	1376 <gets+0x52>
    1374:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1376:	99de                	add	s3,s3,s7
    1378:	00098023          	sb	zero,0(s3)
  return buf;
}
    137c:	855e                	mv	a0,s7
    137e:	60e6                	ld	ra,88(sp)
    1380:	6446                	ld	s0,80(sp)
    1382:	64a6                	ld	s1,72(sp)
    1384:	6906                	ld	s2,64(sp)
    1386:	79e2                	ld	s3,56(sp)
    1388:	7a42                	ld	s4,48(sp)
    138a:	7aa2                	ld	s5,40(sp)
    138c:	7b02                	ld	s6,32(sp)
    138e:	6be2                	ld	s7,24(sp)
    1390:	6125                	addi	sp,sp,96
    1392:	8082                	ret

0000000000001394 <stat>:

int
stat(const char *n, struct stat *st)
{
    1394:	1101                	addi	sp,sp,-32
    1396:	ec06                	sd	ra,24(sp)
    1398:	e822                	sd	s0,16(sp)
    139a:	e04a                	sd	s2,0(sp)
    139c:	1000                	addi	s0,sp,32
    139e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    13a0:	4581                	li	a1,0
    13a2:	162000ef          	jal	1504 <open>
  if(fd < 0)
    13a6:	02054263          	bltz	a0,13ca <stat+0x36>
    13aa:	e426                	sd	s1,8(sp)
    13ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    13ae:	85ca                	mv	a1,s2
    13b0:	16c000ef          	jal	151c <fstat>
    13b4:	892a                	mv	s2,a0
  close(fd);
    13b6:	8526                	mv	a0,s1
    13b8:	134000ef          	jal	14ec <close>
  return r;
    13bc:	64a2                	ld	s1,8(sp)
}
    13be:	854a                	mv	a0,s2
    13c0:	60e2                	ld	ra,24(sp)
    13c2:	6442                	ld	s0,16(sp)
    13c4:	6902                	ld	s2,0(sp)
    13c6:	6105                	addi	sp,sp,32
    13c8:	8082                	ret
    return -1;
    13ca:	597d                	li	s2,-1
    13cc:	bfcd                	j	13be <stat+0x2a>

00000000000013ce <atoi>:

int
atoi(const char *s)
{
    13ce:	1141                	addi	sp,sp,-16
    13d0:	e422                	sd	s0,8(sp)
    13d2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    13d4:	00054683          	lbu	a3,0(a0)
    13d8:	fd06879b          	addiw	a5,a3,-48
    13dc:	0ff7f793          	zext.b	a5,a5
    13e0:	4625                	li	a2,9
    13e2:	02f66863          	bltu	a2,a5,1412 <atoi+0x44>
    13e6:	872a                	mv	a4,a0
  n = 0;
    13e8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    13ea:	0705                	addi	a4,a4,1
    13ec:	0025179b          	slliw	a5,a0,0x2
    13f0:	9fa9                	addw	a5,a5,a0
    13f2:	0017979b          	slliw	a5,a5,0x1
    13f6:	9fb5                	addw	a5,a5,a3
    13f8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    13fc:	00074683          	lbu	a3,0(a4)
    1400:	fd06879b          	addiw	a5,a3,-48
    1404:	0ff7f793          	zext.b	a5,a5
    1408:	fef671e3          	bgeu	a2,a5,13ea <atoi+0x1c>
  return n;
}
    140c:	6422                	ld	s0,8(sp)
    140e:	0141                	addi	sp,sp,16
    1410:	8082                	ret
  n = 0;
    1412:	4501                	li	a0,0
    1414:	bfe5                	j	140c <atoi+0x3e>

0000000000001416 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1416:	1141                	addi	sp,sp,-16
    1418:	e422                	sd	s0,8(sp)
    141a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    141c:	02b57463          	bgeu	a0,a1,1444 <memmove+0x2e>
    while(n-- > 0)
    1420:	00c05f63          	blez	a2,143e <memmove+0x28>
    1424:	1602                	slli	a2,a2,0x20
    1426:	9201                	srli	a2,a2,0x20
    1428:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    142c:	872a                	mv	a4,a0
      *dst++ = *src++;
    142e:	0585                	addi	a1,a1,1
    1430:	0705                	addi	a4,a4,1
    1432:	fff5c683          	lbu	a3,-1(a1)
    1436:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    143a:	fef71ae3          	bne	a4,a5,142e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    143e:	6422                	ld	s0,8(sp)
    1440:	0141                	addi	sp,sp,16
    1442:	8082                	ret
    dst += n;
    1444:	00c50733          	add	a4,a0,a2
    src += n;
    1448:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    144a:	fec05ae3          	blez	a2,143e <memmove+0x28>
    144e:	fff6079b          	addiw	a5,a2,-1
    1452:	1782                	slli	a5,a5,0x20
    1454:	9381                	srli	a5,a5,0x20
    1456:	fff7c793          	not	a5,a5
    145a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    145c:	15fd                	addi	a1,a1,-1
    145e:	177d                	addi	a4,a4,-1
    1460:	0005c683          	lbu	a3,0(a1)
    1464:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1468:	fee79ae3          	bne	a5,a4,145c <memmove+0x46>
    146c:	bfc9                	j	143e <memmove+0x28>

000000000000146e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    146e:	1141                	addi	sp,sp,-16
    1470:	e422                	sd	s0,8(sp)
    1472:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1474:	ca05                	beqz	a2,14a4 <memcmp+0x36>
    1476:	fff6069b          	addiw	a3,a2,-1
    147a:	1682                	slli	a3,a3,0x20
    147c:	9281                	srli	a3,a3,0x20
    147e:	0685                	addi	a3,a3,1
    1480:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1482:	00054783          	lbu	a5,0(a0)
    1486:	0005c703          	lbu	a4,0(a1)
    148a:	00e79863          	bne	a5,a4,149a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    148e:	0505                	addi	a0,a0,1
    p2++;
    1490:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1492:	fed518e3          	bne	a0,a3,1482 <memcmp+0x14>
  }
  return 0;
    1496:	4501                	li	a0,0
    1498:	a019                	j	149e <memcmp+0x30>
      return *p1 - *p2;
    149a:	40e7853b          	subw	a0,a5,a4
}
    149e:	6422                	ld	s0,8(sp)
    14a0:	0141                	addi	sp,sp,16
    14a2:	8082                	ret
  return 0;
    14a4:	4501                	li	a0,0
    14a6:	bfe5                	j	149e <memcmp+0x30>

00000000000014a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    14a8:	1141                	addi	sp,sp,-16
    14aa:	e406                	sd	ra,8(sp)
    14ac:	e022                	sd	s0,0(sp)
    14ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    14b0:	f67ff0ef          	jal	1416 <memmove>
}
    14b4:	60a2                	ld	ra,8(sp)
    14b6:	6402                	ld	s0,0(sp)
    14b8:	0141                	addi	sp,sp,16
    14ba:	8082                	ret

00000000000014bc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    14bc:	4885                	li	a7,1
 ecall
    14be:	00000073          	ecall
 ret
    14c2:	8082                	ret

00000000000014c4 <exit>:
.global exit
exit:
 li a7, SYS_exit
    14c4:	4889                	li	a7,2
 ecall
    14c6:	00000073          	ecall
 ret
    14ca:	8082                	ret

00000000000014cc <wait>:
.global wait
wait:
 li a7, SYS_wait
    14cc:	488d                	li	a7,3
 ecall
    14ce:	00000073          	ecall
 ret
    14d2:	8082                	ret

00000000000014d4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    14d4:	4891                	li	a7,4
 ecall
    14d6:	00000073          	ecall
 ret
    14da:	8082                	ret

00000000000014dc <read>:
.global read
read:
 li a7, SYS_read
    14dc:	4895                	li	a7,5
 ecall
    14de:	00000073          	ecall
 ret
    14e2:	8082                	ret

00000000000014e4 <write>:
.global write
write:
 li a7, SYS_write
    14e4:	48c1                	li	a7,16
 ecall
    14e6:	00000073          	ecall
 ret
    14ea:	8082                	ret

00000000000014ec <close>:
.global close
close:
 li a7, SYS_close
    14ec:	48d5                	li	a7,21
 ecall
    14ee:	00000073          	ecall
 ret
    14f2:	8082                	ret

00000000000014f4 <kill>:
.global kill
kill:
 li a7, SYS_kill
    14f4:	4899                	li	a7,6
 ecall
    14f6:	00000073          	ecall
 ret
    14fa:	8082                	ret

00000000000014fc <exec>:
.global exec
exec:
 li a7, SYS_exec
    14fc:	489d                	li	a7,7
 ecall
    14fe:	00000073          	ecall
 ret
    1502:	8082                	ret

0000000000001504 <open>:
.global open
open:
 li a7, SYS_open
    1504:	48bd                	li	a7,15
 ecall
    1506:	00000073          	ecall
 ret
    150a:	8082                	ret

000000000000150c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    150c:	48c5                	li	a7,17
 ecall
    150e:	00000073          	ecall
 ret
    1512:	8082                	ret

0000000000001514 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1514:	48c9                	li	a7,18
 ecall
    1516:	00000073          	ecall
 ret
    151a:	8082                	ret

000000000000151c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    151c:	48a1                	li	a7,8
 ecall
    151e:	00000073          	ecall
 ret
    1522:	8082                	ret

0000000000001524 <link>:
.global link
link:
 li a7, SYS_link
    1524:	48cd                	li	a7,19
 ecall
    1526:	00000073          	ecall
 ret
    152a:	8082                	ret

000000000000152c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    152c:	48d1                	li	a7,20
 ecall
    152e:	00000073          	ecall
 ret
    1532:	8082                	ret

0000000000001534 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1534:	48a5                	li	a7,9
 ecall
    1536:	00000073          	ecall
 ret
    153a:	8082                	ret

000000000000153c <dup>:
.global dup
dup:
 li a7, SYS_dup
    153c:	48a9                	li	a7,10
 ecall
    153e:	00000073          	ecall
 ret
    1542:	8082                	ret

0000000000001544 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1544:	48ad                	li	a7,11
 ecall
    1546:	00000073          	ecall
 ret
    154a:	8082                	ret

000000000000154c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    154c:	48b1                	li	a7,12
 ecall
    154e:	00000073          	ecall
 ret
    1552:	8082                	ret

0000000000001554 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1554:	48b5                	li	a7,13
 ecall
    1556:	00000073          	ecall
 ret
    155a:	8082                	ret

000000000000155c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    155c:	48b9                	li	a7,14
 ecall
    155e:	00000073          	ecall
 ret
    1562:	8082                	ret

0000000000001564 <cps>:
.global cps
cps:
 li a7, SYS_cps
    1564:	48d9                	li	a7,22
 ecall
    1566:	00000073          	ecall
 ret
    156a:	8082                	ret

000000000000156c <signal>:
.global signal
signal:
 li a7, SYS_signal
    156c:	48dd                	li	a7,23
 ecall
    156e:	00000073          	ecall
 ret
    1572:	8082                	ret

0000000000001574 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1574:	48e1                	li	a7,24
 ecall
    1576:	00000073          	ecall
 ret
    157a:	8082                	ret

000000000000157c <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    157c:	48e5                	li	a7,25
 ecall
    157e:	00000073          	ecall
 ret
    1582:	8082                	ret

0000000000001584 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1584:	48e9                	li	a7,26
 ecall
    1586:	00000073          	ecall
 ret
    158a:	8082                	ret

000000000000158c <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    158c:	48ed                	li	a7,27
 ecall
    158e:	00000073          	ecall
 ret
    1592:	8082                	ret

0000000000001594 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1594:	48f1                	li	a7,28
 ecall
    1596:	00000073          	ecall
 ret
    159a:	8082                	ret

000000000000159c <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    159c:	48f5                	li	a7,29
 ecall
    159e:	00000073          	ecall
 ret
    15a2:	8082                	ret

00000000000015a4 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    15a4:	48f9                	li	a7,30
 ecall
    15a6:	00000073          	ecall
 ret
    15aa:	8082                	ret

00000000000015ac <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    15ac:	1101                	addi	sp,sp,-32
    15ae:	ec06                	sd	ra,24(sp)
    15b0:	e822                	sd	s0,16(sp)
    15b2:	1000                	addi	s0,sp,32
    15b4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    15b8:	4605                	li	a2,1
    15ba:	fef40593          	addi	a1,s0,-17
    15be:	f27ff0ef          	jal	14e4 <write>
}
    15c2:	60e2                	ld	ra,24(sp)
    15c4:	6442                	ld	s0,16(sp)
    15c6:	6105                	addi	sp,sp,32
    15c8:	8082                	ret

00000000000015ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    15ca:	7139                	addi	sp,sp,-64
    15cc:	fc06                	sd	ra,56(sp)
    15ce:	f822                	sd	s0,48(sp)
    15d0:	f426                	sd	s1,40(sp)
    15d2:	0080                	addi	s0,sp,64
    15d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    15d6:	c299                	beqz	a3,15dc <printint+0x12>
    15d8:	0805c963          	bltz	a1,166a <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    15dc:	2581                	sext.w	a1,a1
  neg = 0;
    15de:	4881                	li	a7,0
    15e0:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    15e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    15e6:	2601                	sext.w	a2,a2
    15e8:	00001517          	auipc	a0,0x1
    15ec:	a5850513          	addi	a0,a0,-1448 # 2040 <digits>
    15f0:	883a                	mv	a6,a4
    15f2:	2705                	addiw	a4,a4,1
    15f4:	02c5f7bb          	remuw	a5,a1,a2
    15f8:	1782                	slli	a5,a5,0x20
    15fa:	9381                	srli	a5,a5,0x20
    15fc:	97aa                	add	a5,a5,a0
    15fe:	0007c783          	lbu	a5,0(a5)
    1602:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1606:	0005879b          	sext.w	a5,a1
    160a:	02c5d5bb          	divuw	a1,a1,a2
    160e:	0685                	addi	a3,a3,1
    1610:	fec7f0e3          	bgeu	a5,a2,15f0 <printint+0x26>
  if(neg)
    1614:	00088c63          	beqz	a7,162c <printint+0x62>
    buf[i++] = '-';
    1618:	fd070793          	addi	a5,a4,-48
    161c:	00878733          	add	a4,a5,s0
    1620:	02d00793          	li	a5,45
    1624:	fef70823          	sb	a5,-16(a4)
    1628:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    162c:	02e05a63          	blez	a4,1660 <printint+0x96>
    1630:	f04a                	sd	s2,32(sp)
    1632:	ec4e                	sd	s3,24(sp)
    1634:	fc040793          	addi	a5,s0,-64
    1638:	00e78933          	add	s2,a5,a4
    163c:	fff78993          	addi	s3,a5,-1
    1640:	99ba                	add	s3,s3,a4
    1642:	377d                	addiw	a4,a4,-1
    1644:	1702                	slli	a4,a4,0x20
    1646:	9301                	srli	a4,a4,0x20
    1648:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    164c:	fff94583          	lbu	a1,-1(s2)
    1650:	8526                	mv	a0,s1
    1652:	f5bff0ef          	jal	15ac <putc>
  while(--i >= 0)
    1656:	197d                	addi	s2,s2,-1
    1658:	ff391ae3          	bne	s2,s3,164c <printint+0x82>
    165c:	7902                	ld	s2,32(sp)
    165e:	69e2                	ld	s3,24(sp)
}
    1660:	70e2                	ld	ra,56(sp)
    1662:	7442                	ld	s0,48(sp)
    1664:	74a2                	ld	s1,40(sp)
    1666:	6121                	addi	sp,sp,64
    1668:	8082                	ret
    x = -xx;
    166a:	40b005bb          	negw	a1,a1
    neg = 1;
    166e:	4885                	li	a7,1
    x = -xx;
    1670:	bf85                	j	15e0 <printint+0x16>

0000000000001672 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1672:	711d                	addi	sp,sp,-96
    1674:	ec86                	sd	ra,88(sp)
    1676:	e8a2                	sd	s0,80(sp)
    1678:	e0ca                	sd	s2,64(sp)
    167a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    167c:	0005c903          	lbu	s2,0(a1)
    1680:	26090863          	beqz	s2,18f0 <vprintf+0x27e>
    1684:	e4a6                	sd	s1,72(sp)
    1686:	fc4e                	sd	s3,56(sp)
    1688:	f852                	sd	s4,48(sp)
    168a:	f456                	sd	s5,40(sp)
    168c:	f05a                	sd	s6,32(sp)
    168e:	ec5e                	sd	s7,24(sp)
    1690:	e862                	sd	s8,16(sp)
    1692:	e466                	sd	s9,8(sp)
    1694:	8b2a                	mv	s6,a0
    1696:	8a2e                	mv	s4,a1
    1698:	8bb2                	mv	s7,a2
  state = 0;
    169a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    169c:	4481                	li	s1,0
    169e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    16a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    16a4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    16a8:	06c00c93          	li	s9,108
    16ac:	a005                	j	16cc <vprintf+0x5a>
        putc(fd, c0);
    16ae:	85ca                	mv	a1,s2
    16b0:	855a                	mv	a0,s6
    16b2:	efbff0ef          	jal	15ac <putc>
    16b6:	a019                	j	16bc <vprintf+0x4a>
    } else if(state == '%'){
    16b8:	03598263          	beq	s3,s5,16dc <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    16bc:	2485                	addiw	s1,s1,1
    16be:	8726                	mv	a4,s1
    16c0:	009a07b3          	add	a5,s4,s1
    16c4:	0007c903          	lbu	s2,0(a5)
    16c8:	20090c63          	beqz	s2,18e0 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    16cc:	0009079b          	sext.w	a5,s2
    if(state == 0){
    16d0:	fe0994e3          	bnez	s3,16b8 <vprintf+0x46>
      if(c0 == '%'){
    16d4:	fd579de3          	bne	a5,s5,16ae <vprintf+0x3c>
        state = '%';
    16d8:	89be                	mv	s3,a5
    16da:	b7cd                	j	16bc <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    16dc:	00ea06b3          	add	a3,s4,a4
    16e0:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    16e4:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    16e6:	c681                	beqz	a3,16ee <vprintf+0x7c>
    16e8:	9752                	add	a4,a4,s4
    16ea:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    16ee:	03878f63          	beq	a5,s8,172c <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    16f2:	05978963          	beq	a5,s9,1744 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    16f6:	07500713          	li	a4,117
    16fa:	0ee78363          	beq	a5,a4,17e0 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    16fe:	07800713          	li	a4,120
    1702:	12e78563          	beq	a5,a4,182c <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1706:	07000713          	li	a4,112
    170a:	14e78a63          	beq	a5,a4,185e <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    170e:	07300713          	li	a4,115
    1712:	18e78a63          	beq	a5,a4,18a6 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1716:	02500713          	li	a4,37
    171a:	04e79563          	bne	a5,a4,1764 <vprintf+0xf2>
        putc(fd, '%');
    171e:	02500593          	li	a1,37
    1722:	855a                	mv	a0,s6
    1724:	e89ff0ef          	jal	15ac <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1728:	4981                	li	s3,0
    172a:	bf49                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    172c:	008b8913          	addi	s2,s7,8
    1730:	4685                	li	a3,1
    1732:	4629                	li	a2,10
    1734:	000ba583          	lw	a1,0(s7)
    1738:	855a                	mv	a0,s6
    173a:	e91ff0ef          	jal	15ca <printint>
    173e:	8bca                	mv	s7,s2
      state = 0;
    1740:	4981                	li	s3,0
    1742:	bfad                	j	16bc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1744:	06400793          	li	a5,100
    1748:	02f68963          	beq	a3,a5,177a <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    174c:	06c00793          	li	a5,108
    1750:	04f68263          	beq	a3,a5,1794 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1754:	07500793          	li	a5,117
    1758:	0af68063          	beq	a3,a5,17f8 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    175c:	07800793          	li	a5,120
    1760:	0ef68263          	beq	a3,a5,1844 <vprintf+0x1d2>
        putc(fd, '%');
    1764:	02500593          	li	a1,37
    1768:	855a                	mv	a0,s6
    176a:	e43ff0ef          	jal	15ac <putc>
        putc(fd, c0);
    176e:	85ca                	mv	a1,s2
    1770:	855a                	mv	a0,s6
    1772:	e3bff0ef          	jal	15ac <putc>
      state = 0;
    1776:	4981                	li	s3,0
    1778:	b791                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    177a:	008b8913          	addi	s2,s7,8
    177e:	4685                	li	a3,1
    1780:	4629                	li	a2,10
    1782:	000ba583          	lw	a1,0(s7)
    1786:	855a                	mv	a0,s6
    1788:	e43ff0ef          	jal	15ca <printint>
        i += 1;
    178c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    178e:	8bca                	mv	s7,s2
      state = 0;
    1790:	4981                	li	s3,0
        i += 1;
    1792:	b72d                	j	16bc <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1794:	06400793          	li	a5,100
    1798:	02f60763          	beq	a2,a5,17c6 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    179c:	07500793          	li	a5,117
    17a0:	06f60963          	beq	a2,a5,1812 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    17a4:	07800793          	li	a5,120
    17a8:	faf61ee3          	bne	a2,a5,1764 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    17ac:	008b8913          	addi	s2,s7,8
    17b0:	4681                	li	a3,0
    17b2:	4641                	li	a2,16
    17b4:	000ba583          	lw	a1,0(s7)
    17b8:	855a                	mv	a0,s6
    17ba:	e11ff0ef          	jal	15ca <printint>
        i += 2;
    17be:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    17c0:	8bca                	mv	s7,s2
      state = 0;
    17c2:	4981                	li	s3,0
        i += 2;
    17c4:	bde5                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    17c6:	008b8913          	addi	s2,s7,8
    17ca:	4685                	li	a3,1
    17cc:	4629                	li	a2,10
    17ce:	000ba583          	lw	a1,0(s7)
    17d2:	855a                	mv	a0,s6
    17d4:	df7ff0ef          	jal	15ca <printint>
        i += 2;
    17d8:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    17da:	8bca                	mv	s7,s2
      state = 0;
    17dc:	4981                	li	s3,0
        i += 2;
    17de:	bdf9                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    17e0:	008b8913          	addi	s2,s7,8
    17e4:	4681                	li	a3,0
    17e6:	4629                	li	a2,10
    17e8:	000ba583          	lw	a1,0(s7)
    17ec:	855a                	mv	a0,s6
    17ee:	dddff0ef          	jal	15ca <printint>
    17f2:	8bca                	mv	s7,s2
      state = 0;
    17f4:	4981                	li	s3,0
    17f6:	b5d9                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    17f8:	008b8913          	addi	s2,s7,8
    17fc:	4681                	li	a3,0
    17fe:	4629                	li	a2,10
    1800:	000ba583          	lw	a1,0(s7)
    1804:	855a                	mv	a0,s6
    1806:	dc5ff0ef          	jal	15ca <printint>
        i += 1;
    180a:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    180c:	8bca                	mv	s7,s2
      state = 0;
    180e:	4981                	li	s3,0
        i += 1;
    1810:	b575                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1812:	008b8913          	addi	s2,s7,8
    1816:	4681                	li	a3,0
    1818:	4629                	li	a2,10
    181a:	000ba583          	lw	a1,0(s7)
    181e:	855a                	mv	a0,s6
    1820:	dabff0ef          	jal	15ca <printint>
        i += 2;
    1824:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1826:	8bca                	mv	s7,s2
      state = 0;
    1828:	4981                	li	s3,0
        i += 2;
    182a:	bd49                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    182c:	008b8913          	addi	s2,s7,8
    1830:	4681                	li	a3,0
    1832:	4641                	li	a2,16
    1834:	000ba583          	lw	a1,0(s7)
    1838:	855a                	mv	a0,s6
    183a:	d91ff0ef          	jal	15ca <printint>
    183e:	8bca                	mv	s7,s2
      state = 0;
    1840:	4981                	li	s3,0
    1842:	bdad                	j	16bc <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1844:	008b8913          	addi	s2,s7,8
    1848:	4681                	li	a3,0
    184a:	4641                	li	a2,16
    184c:	000ba583          	lw	a1,0(s7)
    1850:	855a                	mv	a0,s6
    1852:	d79ff0ef          	jal	15ca <printint>
        i += 1;
    1856:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1858:	8bca                	mv	s7,s2
      state = 0;
    185a:	4981                	li	s3,0
        i += 1;
    185c:	b585                	j	16bc <vprintf+0x4a>
    185e:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1860:	008b8d13          	addi	s10,s7,8
    1864:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1868:	03000593          	li	a1,48
    186c:	855a                	mv	a0,s6
    186e:	d3fff0ef          	jal	15ac <putc>
  putc(fd, 'x');
    1872:	07800593          	li	a1,120
    1876:	855a                	mv	a0,s6
    1878:	d35ff0ef          	jal	15ac <putc>
    187c:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    187e:	00000b97          	auipc	s7,0x0
    1882:	7c2b8b93          	addi	s7,s7,1986 # 2040 <digits>
    1886:	03c9d793          	srli	a5,s3,0x3c
    188a:	97de                	add	a5,a5,s7
    188c:	0007c583          	lbu	a1,0(a5)
    1890:	855a                	mv	a0,s6
    1892:	d1bff0ef          	jal	15ac <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1896:	0992                	slli	s3,s3,0x4
    1898:	397d                	addiw	s2,s2,-1
    189a:	fe0916e3          	bnez	s2,1886 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    189e:	8bea                	mv	s7,s10
      state = 0;
    18a0:	4981                	li	s3,0
    18a2:	6d02                	ld	s10,0(sp)
    18a4:	bd21                	j	16bc <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    18a6:	008b8993          	addi	s3,s7,8
    18aa:	000bb903          	ld	s2,0(s7)
    18ae:	00090f63          	beqz	s2,18cc <vprintf+0x25a>
        for(; *s; s++)
    18b2:	00094583          	lbu	a1,0(s2)
    18b6:	c195                	beqz	a1,18da <vprintf+0x268>
          putc(fd, *s);
    18b8:	855a                	mv	a0,s6
    18ba:	cf3ff0ef          	jal	15ac <putc>
        for(; *s; s++)
    18be:	0905                	addi	s2,s2,1
    18c0:	00094583          	lbu	a1,0(s2)
    18c4:	f9f5                	bnez	a1,18b8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    18c6:	8bce                	mv	s7,s3
      state = 0;
    18c8:	4981                	li	s3,0
    18ca:	bbcd                	j	16bc <vprintf+0x4a>
          s = "(null)";
    18cc:	00000917          	auipc	s2,0x0
    18d0:	76c90913          	addi	s2,s2,1900 # 2038 <malloc+0x660>
        for(; *s; s++)
    18d4:	02800593          	li	a1,40
    18d8:	b7c5                	j	18b8 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    18da:	8bce                	mv	s7,s3
      state = 0;
    18dc:	4981                	li	s3,0
    18de:	bbf9                	j	16bc <vprintf+0x4a>
    18e0:	64a6                	ld	s1,72(sp)
    18e2:	79e2                	ld	s3,56(sp)
    18e4:	7a42                	ld	s4,48(sp)
    18e6:	7aa2                	ld	s5,40(sp)
    18e8:	7b02                	ld	s6,32(sp)
    18ea:	6be2                	ld	s7,24(sp)
    18ec:	6c42                	ld	s8,16(sp)
    18ee:	6ca2                	ld	s9,8(sp)
    }
  }
}
    18f0:	60e6                	ld	ra,88(sp)
    18f2:	6446                	ld	s0,80(sp)
    18f4:	6906                	ld	s2,64(sp)
    18f6:	6125                	addi	sp,sp,96
    18f8:	8082                	ret

00000000000018fa <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    18fa:	715d                	addi	sp,sp,-80
    18fc:	ec06                	sd	ra,24(sp)
    18fe:	e822                	sd	s0,16(sp)
    1900:	1000                	addi	s0,sp,32
    1902:	e010                	sd	a2,0(s0)
    1904:	e414                	sd	a3,8(s0)
    1906:	e818                	sd	a4,16(s0)
    1908:	ec1c                	sd	a5,24(s0)
    190a:	03043023          	sd	a6,32(s0)
    190e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1912:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1916:	8622                	mv	a2,s0
    1918:	d5bff0ef          	jal	1672 <vprintf>
}
    191c:	60e2                	ld	ra,24(sp)
    191e:	6442                	ld	s0,16(sp)
    1920:	6161                	addi	sp,sp,80
    1922:	8082                	ret

0000000000001924 <printf>:

void
printf(const char *fmt, ...)
{
    1924:	711d                	addi	sp,sp,-96
    1926:	ec06                	sd	ra,24(sp)
    1928:	e822                	sd	s0,16(sp)
    192a:	1000                	addi	s0,sp,32
    192c:	e40c                	sd	a1,8(s0)
    192e:	e810                	sd	a2,16(s0)
    1930:	ec14                	sd	a3,24(s0)
    1932:	f018                	sd	a4,32(s0)
    1934:	f41c                	sd	a5,40(s0)
    1936:	03043823          	sd	a6,48(s0)
    193a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    193e:	00840613          	addi	a2,s0,8
    1942:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1946:	85aa                	mv	a1,a0
    1948:	4505                	li	a0,1
    194a:	d29ff0ef          	jal	1672 <vprintf>
}
    194e:	60e2                	ld	ra,24(sp)
    1950:	6442                	ld	s0,16(sp)
    1952:	6125                	addi	sp,sp,96
    1954:	8082                	ret

0000000000001956 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1956:	1141                	addi	sp,sp,-16
    1958:	e422                	sd	s0,8(sp)
    195a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    195c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1960:	00000797          	auipc	a5,0x0
    1964:	7007b783          	ld	a5,1792(a5) # 2060 <freep>
    1968:	a02d                	j	1992 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    196a:	4618                	lw	a4,8(a2)
    196c:	9f2d                	addw	a4,a4,a1
    196e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1972:	6398                	ld	a4,0(a5)
    1974:	6310                	ld	a2,0(a4)
    1976:	a83d                	j	19b4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1978:	ff852703          	lw	a4,-8(a0)
    197c:	9f31                	addw	a4,a4,a2
    197e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1980:	ff053683          	ld	a3,-16(a0)
    1984:	a091                	j	19c8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1986:	6398                	ld	a4,0(a5)
    1988:	00e7e463          	bltu	a5,a4,1990 <free+0x3a>
    198c:	00e6ea63          	bltu	a3,a4,19a0 <free+0x4a>
{
    1990:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1992:	fed7fae3          	bgeu	a5,a3,1986 <free+0x30>
    1996:	6398                	ld	a4,0(a5)
    1998:	00e6e463          	bltu	a3,a4,19a0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    199c:	fee7eae3          	bltu	a5,a4,1990 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    19a0:	ff852583          	lw	a1,-8(a0)
    19a4:	6390                	ld	a2,0(a5)
    19a6:	02059813          	slli	a6,a1,0x20
    19aa:	01c85713          	srli	a4,a6,0x1c
    19ae:	9736                	add	a4,a4,a3
    19b0:	fae60de3          	beq	a2,a4,196a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    19b4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    19b8:	4790                	lw	a2,8(a5)
    19ba:	02061593          	slli	a1,a2,0x20
    19be:	01c5d713          	srli	a4,a1,0x1c
    19c2:	973e                	add	a4,a4,a5
    19c4:	fae68ae3          	beq	a3,a4,1978 <free+0x22>
    p->s.ptr = bp->s.ptr;
    19c8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    19ca:	00000717          	auipc	a4,0x0
    19ce:	68f73b23          	sd	a5,1686(a4) # 2060 <freep>
}
    19d2:	6422                	ld	s0,8(sp)
    19d4:	0141                	addi	sp,sp,16
    19d6:	8082                	ret

00000000000019d8 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    19d8:	7139                	addi	sp,sp,-64
    19da:	fc06                	sd	ra,56(sp)
    19dc:	f822                	sd	s0,48(sp)
    19de:	f426                	sd	s1,40(sp)
    19e0:	ec4e                	sd	s3,24(sp)
    19e2:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    19e4:	02051493          	slli	s1,a0,0x20
    19e8:	9081                	srli	s1,s1,0x20
    19ea:	04bd                	addi	s1,s1,15
    19ec:	8091                	srli	s1,s1,0x4
    19ee:	0014899b          	addiw	s3,s1,1
    19f2:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    19f4:	00000517          	auipc	a0,0x0
    19f8:	66c53503          	ld	a0,1644(a0) # 2060 <freep>
    19fc:	c915                	beqz	a0,1a30 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    19fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1a00:	4798                	lw	a4,8(a5)
    1a02:	08977a63          	bgeu	a4,s1,1a96 <malloc+0xbe>
    1a06:	f04a                	sd	s2,32(sp)
    1a08:	e852                	sd	s4,16(sp)
    1a0a:	e456                	sd	s5,8(sp)
    1a0c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1a0e:	8a4e                	mv	s4,s3
    1a10:	0009871b          	sext.w	a4,s3
    1a14:	6685                	lui	a3,0x1
    1a16:	00d77363          	bgeu	a4,a3,1a1c <malloc+0x44>
    1a1a:	6a05                	lui	s4,0x1
    1a1c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1a20:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1a24:	00000917          	auipc	s2,0x0
    1a28:	63c90913          	addi	s2,s2,1596 # 2060 <freep>
  if(p == (char*)-1)
    1a2c:	5afd                	li	s5,-1
    1a2e:	a081                	j	1a6e <malloc+0x96>
    1a30:	f04a                	sd	s2,32(sp)
    1a32:	e852                	sd	s4,16(sp)
    1a34:	e456                	sd	s5,8(sp)
    1a36:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1a38:	00001797          	auipc	a5,0x1
    1a3c:	a3878793          	addi	a5,a5,-1480 # 2470 <base>
    1a40:	00000717          	auipc	a4,0x0
    1a44:	62f73023          	sd	a5,1568(a4) # 2060 <freep>
    1a48:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1a4a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1a4e:	b7c1                	j	1a0e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1a50:	6398                	ld	a4,0(a5)
    1a52:	e118                	sd	a4,0(a0)
    1a54:	a8a9                	j	1aae <malloc+0xd6>
  hp->s.size = nu;
    1a56:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1a5a:	0541                	addi	a0,a0,16
    1a5c:	efbff0ef          	jal	1956 <free>
  return freep;
    1a60:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1a64:	c12d                	beqz	a0,1ac6 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1a66:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1a68:	4798                	lw	a4,8(a5)
    1a6a:	02977263          	bgeu	a4,s1,1a8e <malloc+0xb6>
    if(p == freep)
    1a6e:	00093703          	ld	a4,0(s2)
    1a72:	853e                	mv	a0,a5
    1a74:	fef719e3          	bne	a4,a5,1a66 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    1a78:	8552                	mv	a0,s4
    1a7a:	ad3ff0ef          	jal	154c <sbrk>
  if(p == (char*)-1)
    1a7e:	fd551ce3          	bne	a0,s5,1a56 <malloc+0x7e>
        return 0;
    1a82:	4501                	li	a0,0
    1a84:	7902                	ld	s2,32(sp)
    1a86:	6a42                	ld	s4,16(sp)
    1a88:	6aa2                	ld	s5,8(sp)
    1a8a:	6b02                	ld	s6,0(sp)
    1a8c:	a03d                	j	1aba <malloc+0xe2>
    1a8e:	7902                	ld	s2,32(sp)
    1a90:	6a42                	ld	s4,16(sp)
    1a92:	6aa2                	ld	s5,8(sp)
    1a94:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1a96:	fae48de3          	beq	s1,a4,1a50 <malloc+0x78>
        p->s.size -= nunits;
    1a9a:	4137073b          	subw	a4,a4,s3
    1a9e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1aa0:	02071693          	slli	a3,a4,0x20
    1aa4:	01c6d713          	srli	a4,a3,0x1c
    1aa8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1aaa:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1aae:	00000717          	auipc	a4,0x0
    1ab2:	5aa73923          	sd	a0,1458(a4) # 2060 <freep>
      return (void*)(p + 1);
    1ab6:	01078513          	addi	a0,a5,16
  }
}
    1aba:	70e2                	ld	ra,56(sp)
    1abc:	7442                	ld	s0,48(sp)
    1abe:	74a2                	ld	s1,40(sp)
    1ac0:	69e2                	ld	s3,24(sp)
    1ac2:	6121                	addi	sp,sp,64
    1ac4:	8082                	ret
    1ac6:	7902                	ld	s2,32(sp)
    1ac8:	6a42                	ld	s4,16(sp)
    1aca:	6aa2                	ld	s5,8(sp)
    1acc:	6b02                	ld	s6,0(sp)
    1ace:	b7f5                	j	1aba <malloc+0xe2>
	...
