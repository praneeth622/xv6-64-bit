
user/_thread_test:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <thread_function>:
    char buf[20];
    itoa(num, buf);
    print_safe(buf);
}
*/
void thread_function(void *arg) {
    1000:	1141                	addi	sp,sp,-16
    1002:	e406                	sd	ra,8(sp)
    1004:	e022                	sd	s0,0(sp)
    1006:	0800                	addi	s0,sp,16
    // int *value = (int*)arg;
    
    printf("Thread starting\n");
    1008:	00001517          	auipc	a0,0x1
    100c:	ff850513          	addi	a0,a0,-8 # 2000 <malloc+0x7b6>
    1010:	786000ef          	jal	1796 <printf>
    print_safe("Thread after sleep, value: ");
    print_int(*value);
    print_safe("\n");
    
    thread_exit((void*)0);*/
}
    1014:	60a2                	ld	ra,8(sp)
    1016:	6402                	ld	s0,0(sp)
    1018:	0141                	addi	sp,sp,16
    101a:	8082                	ret

000000000000101c <main>:

int main(int argc, char *argv[]) {
    101c:	1101                	addi	sp,sp,-32
    101e:	ec06                	sd	ra,24(sp)
    1020:	e822                	sd	s0,16(sp)
    1022:	1000                	addi	s0,sp,32
    //initlock(&printlock, "print");  // Modified to match xv6 initlock signature

    int *arg = malloc(sizeof(int));
    1024:	4511                	li	a0,4
    1026:	025000ef          	jal	184a <malloc>
    if(arg == 0) {
    102a:	c939                	beqz	a0,1080 <main+0x64>
    102c:	e426                	sd	s1,8(sp)
    102e:	e04a                	sd	s2,0(sp)
    1030:	84aa                	mv	s1,a0
        printf("Failed to allocate memory\n");
        exit(1);
    }
    
    *arg = 42;
    1032:	02a00793          	li	a5,42
    1036:	c11c                	sw	a5,0(a0)
    void *stack = malloc(2048 + 16);
    1038:	6505                	lui	a0,0x1
    103a:	81050513          	addi	a0,a0,-2032 # 810 <thread_function-0x7f0>
    103e:	00d000ef          	jal	184a <malloc>
    1042:	892a                	mv	s2,a0
    if(stack == 0) {
    1044:	c929                	beqz	a0,1096 <main+0x7a>
        exit(1);
    }
    
    uint64 stack_top = (((uint64)stack + 2048 + 15) & ~15);
    
    printf("Main: Creating thread\n");
    1046:	00001517          	auipc	a0,0x1
    104a:	01250513          	addi	a0,a0,18 # 2058 <malloc+0x80e>
    104e:	748000ef          	jal	1796 <printf>
    printf("Thread creation success\n");
    1052:	00001517          	auipc	a0,0x1
    1056:	01e50513          	addi	a0,a0,30 # 2070 <malloc+0x826>
    105a:	73c000ef          	jal	1796 <printf>
    uint64 stack_top = (((uint64)stack + 2048 + 15) & ~15);
    105e:	6585                	lui	a1,0x1
    1060:	80f58593          	addi	a1,a1,-2033 # 80f <thread_function-0x7f1>
    1064:	95ca                	add	a1,a1,s2
    int pid = thread_create(thread_function, (void*)stack_top, (uint64)arg);
    1066:	8626                	mv	a2,s1
    1068:	99c1                	andi	a1,a1,-16
    106a:	00000517          	auipc	a0,0x0
    106e:	f9650513          	addi	a0,a0,-106 # 1000 <thread_function>
    1072:	394000ef          	jal	1406 <thread_create>
    if(pid < 0) {
    1076:	02054c63          	bltz	a0,10ae <main+0x92>
    
    free(arg);
    free(stack);  // Added missing stack deallocation

    */
    exit(0);
    107a:	4501                	li	a0,0
    107c:	2ba000ef          	jal	1336 <exit>
    1080:	e426                	sd	s1,8(sp)
    1082:	e04a                	sd	s2,0(sp)
        printf("Failed to allocate memory\n");
    1084:	00001517          	auipc	a0,0x1
    1088:	f9450513          	addi	a0,a0,-108 # 2018 <malloc+0x7ce>
    108c:	70a000ef          	jal	1796 <printf>
        exit(1);
    1090:	4505                	li	a0,1
    1092:	2a4000ef          	jal	1336 <exit>
        printf("Failed to allocate stack\n");
    1096:	00001517          	auipc	a0,0x1
    109a:	fa250513          	addi	a0,a0,-94 # 2038 <malloc+0x7ee>
    109e:	6f8000ef          	jal	1796 <printf>
        free(arg);
    10a2:	8526                	mv	a0,s1
    10a4:	724000ef          	jal	17c8 <free>
        exit(1);
    10a8:	4505                	li	a0,1
    10aa:	28c000ef          	jal	1336 <exit>
        printf("Failed to allocate stack\n");
    10ae:	00001517          	auipc	a0,0x1
    10b2:	f8a50513          	addi	a0,a0,-118 # 2038 <malloc+0x7ee>
    10b6:	6e0000ef          	jal	1796 <printf>
        free(arg);
    10ba:	8526                	mv	a0,s1
    10bc:	70c000ef          	jal	17c8 <free>
        free(stack);  // Added missing stack deallocation
    10c0:	854a                	mv	a0,s2
    10c2:	706000ef          	jal	17c8 <free>
        exit(1);
    10c6:	4505                	li	a0,1
    10c8:	26e000ef          	jal	1336 <exit>

00000000000010cc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    10cc:	1141                	addi	sp,sp,-16
    10ce:	e406                	sd	ra,8(sp)
    10d0:	e022                	sd	s0,0(sp)
    10d2:	0800                	addi	s0,sp,16
  extern int main();
  main();
    10d4:	f49ff0ef          	jal	101c <main>
  exit(0);
    10d8:	4501                	li	a0,0
    10da:	25c000ef          	jal	1336 <exit>

00000000000010de <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    10de:	1141                	addi	sp,sp,-16
    10e0:	e422                	sd	s0,8(sp)
    10e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    10e4:	87aa                	mv	a5,a0
    10e6:	0585                	addi	a1,a1,1
    10e8:	0785                	addi	a5,a5,1
    10ea:	fff5c703          	lbu	a4,-1(a1)
    10ee:	fee78fa3          	sb	a4,-1(a5)
    10f2:	fb75                	bnez	a4,10e6 <strcpy+0x8>
    ;
  return os;
}
    10f4:	6422                	ld	s0,8(sp)
    10f6:	0141                	addi	sp,sp,16
    10f8:	8082                	ret

00000000000010fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
    10fa:	1141                	addi	sp,sp,-16
    10fc:	e422                	sd	s0,8(sp)
    10fe:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1100:	00054783          	lbu	a5,0(a0)
    1104:	cb91                	beqz	a5,1118 <strcmp+0x1e>
    1106:	0005c703          	lbu	a4,0(a1)
    110a:	00f71763          	bne	a4,a5,1118 <strcmp+0x1e>
    p++, q++;
    110e:	0505                	addi	a0,a0,1
    1110:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1112:	00054783          	lbu	a5,0(a0)
    1116:	fbe5                	bnez	a5,1106 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1118:	0005c503          	lbu	a0,0(a1)
}
    111c:	40a7853b          	subw	a0,a5,a0
    1120:	6422                	ld	s0,8(sp)
    1122:	0141                	addi	sp,sp,16
    1124:	8082                	ret

0000000000001126 <strlen>:

uint
strlen(const char *s)
{
    1126:	1141                	addi	sp,sp,-16
    1128:	e422                	sd	s0,8(sp)
    112a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    112c:	00054783          	lbu	a5,0(a0)
    1130:	cf91                	beqz	a5,114c <strlen+0x26>
    1132:	0505                	addi	a0,a0,1
    1134:	87aa                	mv	a5,a0
    1136:	86be                	mv	a3,a5
    1138:	0785                	addi	a5,a5,1
    113a:	fff7c703          	lbu	a4,-1(a5)
    113e:	ff65                	bnez	a4,1136 <strlen+0x10>
    1140:	40a6853b          	subw	a0,a3,a0
    1144:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    1146:	6422                	ld	s0,8(sp)
    1148:	0141                	addi	sp,sp,16
    114a:	8082                	ret
  for(n = 0; s[n]; n++)
    114c:	4501                	li	a0,0
    114e:	bfe5                	j	1146 <strlen+0x20>

0000000000001150 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1150:	1141                	addi	sp,sp,-16
    1152:	e422                	sd	s0,8(sp)
    1154:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1156:	ca19                	beqz	a2,116c <memset+0x1c>
    1158:	87aa                	mv	a5,a0
    115a:	1602                	slli	a2,a2,0x20
    115c:	9201                	srli	a2,a2,0x20
    115e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1162:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1166:	0785                	addi	a5,a5,1
    1168:	fee79de3          	bne	a5,a4,1162 <memset+0x12>
  }
  return dst;
}
    116c:	6422                	ld	s0,8(sp)
    116e:	0141                	addi	sp,sp,16
    1170:	8082                	ret

0000000000001172 <strchr>:

char*
strchr(const char *s, char c)
{
    1172:	1141                	addi	sp,sp,-16
    1174:	e422                	sd	s0,8(sp)
    1176:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1178:	00054783          	lbu	a5,0(a0)
    117c:	cb99                	beqz	a5,1192 <strchr+0x20>
    if(*s == c)
    117e:	00f58763          	beq	a1,a5,118c <strchr+0x1a>
  for(; *s; s++)
    1182:	0505                	addi	a0,a0,1
    1184:	00054783          	lbu	a5,0(a0)
    1188:	fbfd                	bnez	a5,117e <strchr+0xc>
      return (char*)s;
  return 0;
    118a:	4501                	li	a0,0
}
    118c:	6422                	ld	s0,8(sp)
    118e:	0141                	addi	sp,sp,16
    1190:	8082                	ret
  return 0;
    1192:	4501                	li	a0,0
    1194:	bfe5                	j	118c <strchr+0x1a>

0000000000001196 <gets>:

char*
gets(char *buf, int max)
{
    1196:	711d                	addi	sp,sp,-96
    1198:	ec86                	sd	ra,88(sp)
    119a:	e8a2                	sd	s0,80(sp)
    119c:	e4a6                	sd	s1,72(sp)
    119e:	e0ca                	sd	s2,64(sp)
    11a0:	fc4e                	sd	s3,56(sp)
    11a2:	f852                	sd	s4,48(sp)
    11a4:	f456                	sd	s5,40(sp)
    11a6:	f05a                	sd	s6,32(sp)
    11a8:	ec5e                	sd	s7,24(sp)
    11aa:	1080                	addi	s0,sp,96
    11ac:	8baa                	mv	s7,a0
    11ae:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    11b0:	892a                	mv	s2,a0
    11b2:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    11b4:	4aa9                	li	s5,10
    11b6:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    11b8:	89a6                	mv	s3,s1
    11ba:	2485                	addiw	s1,s1,1
    11bc:	0344d663          	bge	s1,s4,11e8 <gets+0x52>
    cc = read(0, &c, 1);
    11c0:	4605                	li	a2,1
    11c2:	faf40593          	addi	a1,s0,-81
    11c6:	4501                	li	a0,0
    11c8:	186000ef          	jal	134e <read>
    if(cc < 1)
    11cc:	00a05e63          	blez	a0,11e8 <gets+0x52>
    buf[i++] = c;
    11d0:	faf44783          	lbu	a5,-81(s0)
    11d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    11d8:	01578763          	beq	a5,s5,11e6 <gets+0x50>
    11dc:	0905                	addi	s2,s2,1
    11de:	fd679de3          	bne	a5,s6,11b8 <gets+0x22>
    buf[i++] = c;
    11e2:	89a6                	mv	s3,s1
    11e4:	a011                	j	11e8 <gets+0x52>
    11e6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    11e8:	99de                	add	s3,s3,s7
    11ea:	00098023          	sb	zero,0(s3)
  return buf;
}
    11ee:	855e                	mv	a0,s7
    11f0:	60e6                	ld	ra,88(sp)
    11f2:	6446                	ld	s0,80(sp)
    11f4:	64a6                	ld	s1,72(sp)
    11f6:	6906                	ld	s2,64(sp)
    11f8:	79e2                	ld	s3,56(sp)
    11fa:	7a42                	ld	s4,48(sp)
    11fc:	7aa2                	ld	s5,40(sp)
    11fe:	7b02                	ld	s6,32(sp)
    1200:	6be2                	ld	s7,24(sp)
    1202:	6125                	addi	sp,sp,96
    1204:	8082                	ret

0000000000001206 <stat>:

int
stat(const char *n, struct stat *st)
{
    1206:	1101                	addi	sp,sp,-32
    1208:	ec06                	sd	ra,24(sp)
    120a:	e822                	sd	s0,16(sp)
    120c:	e04a                	sd	s2,0(sp)
    120e:	1000                	addi	s0,sp,32
    1210:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1212:	4581                	li	a1,0
    1214:	162000ef          	jal	1376 <open>
  if(fd < 0)
    1218:	02054263          	bltz	a0,123c <stat+0x36>
    121c:	e426                	sd	s1,8(sp)
    121e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1220:	85ca                	mv	a1,s2
    1222:	16c000ef          	jal	138e <fstat>
    1226:	892a                	mv	s2,a0
  close(fd);
    1228:	8526                	mv	a0,s1
    122a:	134000ef          	jal	135e <close>
  return r;
    122e:	64a2                	ld	s1,8(sp)
}
    1230:	854a                	mv	a0,s2
    1232:	60e2                	ld	ra,24(sp)
    1234:	6442                	ld	s0,16(sp)
    1236:	6902                	ld	s2,0(sp)
    1238:	6105                	addi	sp,sp,32
    123a:	8082                	ret
    return -1;
    123c:	597d                	li	s2,-1
    123e:	bfcd                	j	1230 <stat+0x2a>

0000000000001240 <atoi>:

int
atoi(const char *s)
{
    1240:	1141                	addi	sp,sp,-16
    1242:	e422                	sd	s0,8(sp)
    1244:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1246:	00054683          	lbu	a3,0(a0)
    124a:	fd06879b          	addiw	a5,a3,-48
    124e:	0ff7f793          	zext.b	a5,a5
    1252:	4625                	li	a2,9
    1254:	02f66863          	bltu	a2,a5,1284 <atoi+0x44>
    1258:	872a                	mv	a4,a0
  n = 0;
    125a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    125c:	0705                	addi	a4,a4,1
    125e:	0025179b          	slliw	a5,a0,0x2
    1262:	9fa9                	addw	a5,a5,a0
    1264:	0017979b          	slliw	a5,a5,0x1
    1268:	9fb5                	addw	a5,a5,a3
    126a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    126e:	00074683          	lbu	a3,0(a4)
    1272:	fd06879b          	addiw	a5,a3,-48
    1276:	0ff7f793          	zext.b	a5,a5
    127a:	fef671e3          	bgeu	a2,a5,125c <atoi+0x1c>
  return n;
}
    127e:	6422                	ld	s0,8(sp)
    1280:	0141                	addi	sp,sp,16
    1282:	8082                	ret
  n = 0;
    1284:	4501                	li	a0,0
    1286:	bfe5                	j	127e <atoi+0x3e>

0000000000001288 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1288:	1141                	addi	sp,sp,-16
    128a:	e422                	sd	s0,8(sp)
    128c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    128e:	02b57463          	bgeu	a0,a1,12b6 <memmove+0x2e>
    while(n-- > 0)
    1292:	00c05f63          	blez	a2,12b0 <memmove+0x28>
    1296:	1602                	slli	a2,a2,0x20
    1298:	9201                	srli	a2,a2,0x20
    129a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    129e:	872a                	mv	a4,a0
      *dst++ = *src++;
    12a0:	0585                	addi	a1,a1,1
    12a2:	0705                	addi	a4,a4,1
    12a4:	fff5c683          	lbu	a3,-1(a1)
    12a8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    12ac:	fef71ae3          	bne	a4,a5,12a0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    12b0:	6422                	ld	s0,8(sp)
    12b2:	0141                	addi	sp,sp,16
    12b4:	8082                	ret
    dst += n;
    12b6:	00c50733          	add	a4,a0,a2
    src += n;
    12ba:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    12bc:	fec05ae3          	blez	a2,12b0 <memmove+0x28>
    12c0:	fff6079b          	addiw	a5,a2,-1
    12c4:	1782                	slli	a5,a5,0x20
    12c6:	9381                	srli	a5,a5,0x20
    12c8:	fff7c793          	not	a5,a5
    12cc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    12ce:	15fd                	addi	a1,a1,-1
    12d0:	177d                	addi	a4,a4,-1
    12d2:	0005c683          	lbu	a3,0(a1)
    12d6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    12da:	fee79ae3          	bne	a5,a4,12ce <memmove+0x46>
    12de:	bfc9                	j	12b0 <memmove+0x28>

00000000000012e0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    12e0:	1141                	addi	sp,sp,-16
    12e2:	e422                	sd	s0,8(sp)
    12e4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    12e6:	ca05                	beqz	a2,1316 <memcmp+0x36>
    12e8:	fff6069b          	addiw	a3,a2,-1
    12ec:	1682                	slli	a3,a3,0x20
    12ee:	9281                	srli	a3,a3,0x20
    12f0:	0685                	addi	a3,a3,1
    12f2:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    12f4:	00054783          	lbu	a5,0(a0)
    12f8:	0005c703          	lbu	a4,0(a1)
    12fc:	00e79863          	bne	a5,a4,130c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1300:	0505                	addi	a0,a0,1
    p2++;
    1302:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1304:	fed518e3          	bne	a0,a3,12f4 <memcmp+0x14>
  }
  return 0;
    1308:	4501                	li	a0,0
    130a:	a019                	j	1310 <memcmp+0x30>
      return *p1 - *p2;
    130c:	40e7853b          	subw	a0,a5,a4
}
    1310:	6422                	ld	s0,8(sp)
    1312:	0141                	addi	sp,sp,16
    1314:	8082                	ret
  return 0;
    1316:	4501                	li	a0,0
    1318:	bfe5                	j	1310 <memcmp+0x30>

000000000000131a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    131a:	1141                	addi	sp,sp,-16
    131c:	e406                	sd	ra,8(sp)
    131e:	e022                	sd	s0,0(sp)
    1320:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1322:	f67ff0ef          	jal	1288 <memmove>
}
    1326:	60a2                	ld	ra,8(sp)
    1328:	6402                	ld	s0,0(sp)
    132a:	0141                	addi	sp,sp,16
    132c:	8082                	ret

000000000000132e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    132e:	4885                	li	a7,1
 ecall
    1330:	00000073          	ecall
 ret
    1334:	8082                	ret

0000000000001336 <exit>:
.global exit
exit:
 li a7, SYS_exit
    1336:	4889                	li	a7,2
 ecall
    1338:	00000073          	ecall
 ret
    133c:	8082                	ret

000000000000133e <wait>:
.global wait
wait:
 li a7, SYS_wait
    133e:	488d                	li	a7,3
 ecall
    1340:	00000073          	ecall
 ret
    1344:	8082                	ret

0000000000001346 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1346:	4891                	li	a7,4
 ecall
    1348:	00000073          	ecall
 ret
    134c:	8082                	ret

000000000000134e <read>:
.global read
read:
 li a7, SYS_read
    134e:	4895                	li	a7,5
 ecall
    1350:	00000073          	ecall
 ret
    1354:	8082                	ret

0000000000001356 <write>:
.global write
write:
 li a7, SYS_write
    1356:	48c1                	li	a7,16
 ecall
    1358:	00000073          	ecall
 ret
    135c:	8082                	ret

000000000000135e <close>:
.global close
close:
 li a7, SYS_close
    135e:	48d5                	li	a7,21
 ecall
    1360:	00000073          	ecall
 ret
    1364:	8082                	ret

0000000000001366 <kill>:
.global kill
kill:
 li a7, SYS_kill
    1366:	4899                	li	a7,6
 ecall
    1368:	00000073          	ecall
 ret
    136c:	8082                	ret

000000000000136e <exec>:
.global exec
exec:
 li a7, SYS_exec
    136e:	489d                	li	a7,7
 ecall
    1370:	00000073          	ecall
 ret
    1374:	8082                	ret

0000000000001376 <open>:
.global open
open:
 li a7, SYS_open
    1376:	48bd                	li	a7,15
 ecall
    1378:	00000073          	ecall
 ret
    137c:	8082                	ret

000000000000137e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    137e:	48c5                	li	a7,17
 ecall
    1380:	00000073          	ecall
 ret
    1384:	8082                	ret

0000000000001386 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1386:	48c9                	li	a7,18
 ecall
    1388:	00000073          	ecall
 ret
    138c:	8082                	ret

000000000000138e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    138e:	48a1                	li	a7,8
 ecall
    1390:	00000073          	ecall
 ret
    1394:	8082                	ret

0000000000001396 <link>:
.global link
link:
 li a7, SYS_link
    1396:	48cd                	li	a7,19
 ecall
    1398:	00000073          	ecall
 ret
    139c:	8082                	ret

000000000000139e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    139e:	48d1                	li	a7,20
 ecall
    13a0:	00000073          	ecall
 ret
    13a4:	8082                	ret

00000000000013a6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    13a6:	48a5                	li	a7,9
 ecall
    13a8:	00000073          	ecall
 ret
    13ac:	8082                	ret

00000000000013ae <dup>:
.global dup
dup:
 li a7, SYS_dup
    13ae:	48a9                	li	a7,10
 ecall
    13b0:	00000073          	ecall
 ret
    13b4:	8082                	ret

00000000000013b6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    13b6:	48ad                	li	a7,11
 ecall
    13b8:	00000073          	ecall
 ret
    13bc:	8082                	ret

00000000000013be <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    13be:	48b1                	li	a7,12
 ecall
    13c0:	00000073          	ecall
 ret
    13c4:	8082                	ret

00000000000013c6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    13c6:	48b5                	li	a7,13
 ecall
    13c8:	00000073          	ecall
 ret
    13cc:	8082                	ret

00000000000013ce <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    13ce:	48b9                	li	a7,14
 ecall
    13d0:	00000073          	ecall
 ret
    13d4:	8082                	ret

00000000000013d6 <cps>:
.global cps
cps:
 li a7, SYS_cps
    13d6:	48d9                	li	a7,22
 ecall
    13d8:	00000073          	ecall
 ret
    13dc:	8082                	ret

00000000000013de <signal>:
.global signal
signal:
 li a7, SYS_signal
    13de:	48dd                	li	a7,23
 ecall
    13e0:	00000073          	ecall
 ret
    13e4:	8082                	ret

00000000000013e6 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    13e6:	48e1                	li	a7,24
 ecall
    13e8:	00000073          	ecall
 ret
    13ec:	8082                	ret

00000000000013ee <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    13ee:	48e5                	li	a7,25
 ecall
    13f0:	00000073          	ecall
 ret
    13f4:	8082                	ret

00000000000013f6 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    13f6:	48e9                	li	a7,26
 ecall
    13f8:	00000073          	ecall
 ret
    13fc:	8082                	ret

00000000000013fe <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    13fe:	48ed                	li	a7,27
 ecall
    1400:	00000073          	ecall
 ret
    1404:	8082                	ret

0000000000001406 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1406:	48f1                	li	a7,28
 ecall
    1408:	00000073          	ecall
 ret
    140c:	8082                	ret

000000000000140e <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    140e:	48f5                	li	a7,29
 ecall
    1410:	00000073          	ecall
 ret
    1414:	8082                	ret

0000000000001416 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1416:	48f9                	li	a7,30
 ecall
    1418:	00000073          	ecall
 ret
    141c:	8082                	ret

000000000000141e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    141e:	1101                	addi	sp,sp,-32
    1420:	ec06                	sd	ra,24(sp)
    1422:	e822                	sd	s0,16(sp)
    1424:	1000                	addi	s0,sp,32
    1426:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    142a:	4605                	li	a2,1
    142c:	fef40593          	addi	a1,s0,-17
    1430:	f27ff0ef          	jal	1356 <write>
}
    1434:	60e2                	ld	ra,24(sp)
    1436:	6442                	ld	s0,16(sp)
    1438:	6105                	addi	sp,sp,32
    143a:	8082                	ret

000000000000143c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    143c:	7139                	addi	sp,sp,-64
    143e:	fc06                	sd	ra,56(sp)
    1440:	f822                	sd	s0,48(sp)
    1442:	f426                	sd	s1,40(sp)
    1444:	0080                	addi	s0,sp,64
    1446:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1448:	c299                	beqz	a3,144e <printint+0x12>
    144a:	0805c963          	bltz	a1,14dc <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    144e:	2581                	sext.w	a1,a1
  neg = 0;
    1450:	4881                	li	a7,0
    1452:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1456:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1458:	2601                	sext.w	a2,a2
    145a:	00001517          	auipc	a0,0x1
    145e:	c3e50513          	addi	a0,a0,-962 # 2098 <digits>
    1462:	883a                	mv	a6,a4
    1464:	2705                	addiw	a4,a4,1
    1466:	02c5f7bb          	remuw	a5,a1,a2
    146a:	1782                	slli	a5,a5,0x20
    146c:	9381                	srli	a5,a5,0x20
    146e:	97aa                	add	a5,a5,a0
    1470:	0007c783          	lbu	a5,0(a5)
    1474:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1478:	0005879b          	sext.w	a5,a1
    147c:	02c5d5bb          	divuw	a1,a1,a2
    1480:	0685                	addi	a3,a3,1
    1482:	fec7f0e3          	bgeu	a5,a2,1462 <printint+0x26>
  if(neg)
    1486:	00088c63          	beqz	a7,149e <printint+0x62>
    buf[i++] = '-';
    148a:	fd070793          	addi	a5,a4,-48
    148e:	00878733          	add	a4,a5,s0
    1492:	02d00793          	li	a5,45
    1496:	fef70823          	sb	a5,-16(a4)
    149a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    149e:	02e05a63          	blez	a4,14d2 <printint+0x96>
    14a2:	f04a                	sd	s2,32(sp)
    14a4:	ec4e                	sd	s3,24(sp)
    14a6:	fc040793          	addi	a5,s0,-64
    14aa:	00e78933          	add	s2,a5,a4
    14ae:	fff78993          	addi	s3,a5,-1
    14b2:	99ba                	add	s3,s3,a4
    14b4:	377d                	addiw	a4,a4,-1
    14b6:	1702                	slli	a4,a4,0x20
    14b8:	9301                	srli	a4,a4,0x20
    14ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    14be:	fff94583          	lbu	a1,-1(s2)
    14c2:	8526                	mv	a0,s1
    14c4:	f5bff0ef          	jal	141e <putc>
  while(--i >= 0)
    14c8:	197d                	addi	s2,s2,-1
    14ca:	ff391ae3          	bne	s2,s3,14be <printint+0x82>
    14ce:	7902                	ld	s2,32(sp)
    14d0:	69e2                	ld	s3,24(sp)
}
    14d2:	70e2                	ld	ra,56(sp)
    14d4:	7442                	ld	s0,48(sp)
    14d6:	74a2                	ld	s1,40(sp)
    14d8:	6121                	addi	sp,sp,64
    14da:	8082                	ret
    x = -xx;
    14dc:	40b005bb          	negw	a1,a1
    neg = 1;
    14e0:	4885                	li	a7,1
    x = -xx;
    14e2:	bf85                	j	1452 <printint+0x16>

00000000000014e4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    14e4:	711d                	addi	sp,sp,-96
    14e6:	ec86                	sd	ra,88(sp)
    14e8:	e8a2                	sd	s0,80(sp)
    14ea:	e0ca                	sd	s2,64(sp)
    14ec:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    14ee:	0005c903          	lbu	s2,0(a1)
    14f2:	26090863          	beqz	s2,1762 <vprintf+0x27e>
    14f6:	e4a6                	sd	s1,72(sp)
    14f8:	fc4e                	sd	s3,56(sp)
    14fa:	f852                	sd	s4,48(sp)
    14fc:	f456                	sd	s5,40(sp)
    14fe:	f05a                	sd	s6,32(sp)
    1500:	ec5e                	sd	s7,24(sp)
    1502:	e862                	sd	s8,16(sp)
    1504:	e466                	sd	s9,8(sp)
    1506:	8b2a                	mv	s6,a0
    1508:	8a2e                	mv	s4,a1
    150a:	8bb2                	mv	s7,a2
  state = 0;
    150c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    150e:	4481                	li	s1,0
    1510:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1512:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1516:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    151a:	06c00c93          	li	s9,108
    151e:	a005                	j	153e <vprintf+0x5a>
        putc(fd, c0);
    1520:	85ca                	mv	a1,s2
    1522:	855a                	mv	a0,s6
    1524:	efbff0ef          	jal	141e <putc>
    1528:	a019                	j	152e <vprintf+0x4a>
    } else if(state == '%'){
    152a:	03598263          	beq	s3,s5,154e <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    152e:	2485                	addiw	s1,s1,1
    1530:	8726                	mv	a4,s1
    1532:	009a07b3          	add	a5,s4,s1
    1536:	0007c903          	lbu	s2,0(a5)
    153a:	20090c63          	beqz	s2,1752 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    153e:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1542:	fe0994e3          	bnez	s3,152a <vprintf+0x46>
      if(c0 == '%'){
    1546:	fd579de3          	bne	a5,s5,1520 <vprintf+0x3c>
        state = '%';
    154a:	89be                	mv	s3,a5
    154c:	b7cd                	j	152e <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    154e:	00ea06b3          	add	a3,s4,a4
    1552:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1556:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1558:	c681                	beqz	a3,1560 <vprintf+0x7c>
    155a:	9752                	add	a4,a4,s4
    155c:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1560:	03878f63          	beq	a5,s8,159e <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1564:	05978963          	beq	a5,s9,15b6 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1568:	07500713          	li	a4,117
    156c:	0ee78363          	beq	a5,a4,1652 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1570:	07800713          	li	a4,120
    1574:	12e78563          	beq	a5,a4,169e <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1578:	07000713          	li	a4,112
    157c:	14e78a63          	beq	a5,a4,16d0 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1580:	07300713          	li	a4,115
    1584:	18e78a63          	beq	a5,a4,1718 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1588:	02500713          	li	a4,37
    158c:	04e79563          	bne	a5,a4,15d6 <vprintf+0xf2>
        putc(fd, '%');
    1590:	02500593          	li	a1,37
    1594:	855a                	mv	a0,s6
    1596:	e89ff0ef          	jal	141e <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    159a:	4981                	li	s3,0
    159c:	bf49                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    159e:	008b8913          	addi	s2,s7,8
    15a2:	4685                	li	a3,1
    15a4:	4629                	li	a2,10
    15a6:	000ba583          	lw	a1,0(s7)
    15aa:	855a                	mv	a0,s6
    15ac:	e91ff0ef          	jal	143c <printint>
    15b0:	8bca                	mv	s7,s2
      state = 0;
    15b2:	4981                	li	s3,0
    15b4:	bfad                	j	152e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    15b6:	06400793          	li	a5,100
    15ba:	02f68963          	beq	a3,a5,15ec <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    15be:	06c00793          	li	a5,108
    15c2:	04f68263          	beq	a3,a5,1606 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    15c6:	07500793          	li	a5,117
    15ca:	0af68063          	beq	a3,a5,166a <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    15ce:	07800793          	li	a5,120
    15d2:	0ef68263          	beq	a3,a5,16b6 <vprintf+0x1d2>
        putc(fd, '%');
    15d6:	02500593          	li	a1,37
    15da:	855a                	mv	a0,s6
    15dc:	e43ff0ef          	jal	141e <putc>
        putc(fd, c0);
    15e0:	85ca                	mv	a1,s2
    15e2:	855a                	mv	a0,s6
    15e4:	e3bff0ef          	jal	141e <putc>
      state = 0;
    15e8:	4981                	li	s3,0
    15ea:	b791                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    15ec:	008b8913          	addi	s2,s7,8
    15f0:	4685                	li	a3,1
    15f2:	4629                	li	a2,10
    15f4:	000ba583          	lw	a1,0(s7)
    15f8:	855a                	mv	a0,s6
    15fa:	e43ff0ef          	jal	143c <printint>
        i += 1;
    15fe:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1600:	8bca                	mv	s7,s2
      state = 0;
    1602:	4981                	li	s3,0
        i += 1;
    1604:	b72d                	j	152e <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1606:	06400793          	li	a5,100
    160a:	02f60763          	beq	a2,a5,1638 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    160e:	07500793          	li	a5,117
    1612:	06f60963          	beq	a2,a5,1684 <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1616:	07800793          	li	a5,120
    161a:	faf61ee3          	bne	a2,a5,15d6 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    161e:	008b8913          	addi	s2,s7,8
    1622:	4681                	li	a3,0
    1624:	4641                	li	a2,16
    1626:	000ba583          	lw	a1,0(s7)
    162a:	855a                	mv	a0,s6
    162c:	e11ff0ef          	jal	143c <printint>
        i += 2;
    1630:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1632:	8bca                	mv	s7,s2
      state = 0;
    1634:	4981                	li	s3,0
        i += 2;
    1636:	bde5                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1638:	008b8913          	addi	s2,s7,8
    163c:	4685                	li	a3,1
    163e:	4629                	li	a2,10
    1640:	000ba583          	lw	a1,0(s7)
    1644:	855a                	mv	a0,s6
    1646:	df7ff0ef          	jal	143c <printint>
        i += 2;
    164a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    164c:	8bca                	mv	s7,s2
      state = 0;
    164e:	4981                	li	s3,0
        i += 2;
    1650:	bdf9                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1652:	008b8913          	addi	s2,s7,8
    1656:	4681                	li	a3,0
    1658:	4629                	li	a2,10
    165a:	000ba583          	lw	a1,0(s7)
    165e:	855a                	mv	a0,s6
    1660:	dddff0ef          	jal	143c <printint>
    1664:	8bca                	mv	s7,s2
      state = 0;
    1666:	4981                	li	s3,0
    1668:	b5d9                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    166a:	008b8913          	addi	s2,s7,8
    166e:	4681                	li	a3,0
    1670:	4629                	li	a2,10
    1672:	000ba583          	lw	a1,0(s7)
    1676:	855a                	mv	a0,s6
    1678:	dc5ff0ef          	jal	143c <printint>
        i += 1;
    167c:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    167e:	8bca                	mv	s7,s2
      state = 0;
    1680:	4981                	li	s3,0
        i += 1;
    1682:	b575                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1684:	008b8913          	addi	s2,s7,8
    1688:	4681                	li	a3,0
    168a:	4629                	li	a2,10
    168c:	000ba583          	lw	a1,0(s7)
    1690:	855a                	mv	a0,s6
    1692:	dabff0ef          	jal	143c <printint>
        i += 2;
    1696:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1698:	8bca                	mv	s7,s2
      state = 0;
    169a:	4981                	li	s3,0
        i += 2;
    169c:	bd49                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    169e:	008b8913          	addi	s2,s7,8
    16a2:	4681                	li	a3,0
    16a4:	4641                	li	a2,16
    16a6:	000ba583          	lw	a1,0(s7)
    16aa:	855a                	mv	a0,s6
    16ac:	d91ff0ef          	jal	143c <printint>
    16b0:	8bca                	mv	s7,s2
      state = 0;
    16b2:	4981                	li	s3,0
    16b4:	bdad                	j	152e <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    16b6:	008b8913          	addi	s2,s7,8
    16ba:	4681                	li	a3,0
    16bc:	4641                	li	a2,16
    16be:	000ba583          	lw	a1,0(s7)
    16c2:	855a                	mv	a0,s6
    16c4:	d79ff0ef          	jal	143c <printint>
        i += 1;
    16c8:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    16ca:	8bca                	mv	s7,s2
      state = 0;
    16cc:	4981                	li	s3,0
        i += 1;
    16ce:	b585                	j	152e <vprintf+0x4a>
    16d0:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    16d2:	008b8d13          	addi	s10,s7,8
    16d6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    16da:	03000593          	li	a1,48
    16de:	855a                	mv	a0,s6
    16e0:	d3fff0ef          	jal	141e <putc>
  putc(fd, 'x');
    16e4:	07800593          	li	a1,120
    16e8:	855a                	mv	a0,s6
    16ea:	d35ff0ef          	jal	141e <putc>
    16ee:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    16f0:	00001b97          	auipc	s7,0x1
    16f4:	9a8b8b93          	addi	s7,s7,-1624 # 2098 <digits>
    16f8:	03c9d793          	srli	a5,s3,0x3c
    16fc:	97de                	add	a5,a5,s7
    16fe:	0007c583          	lbu	a1,0(a5)
    1702:	855a                	mv	a0,s6
    1704:	d1bff0ef          	jal	141e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1708:	0992                	slli	s3,s3,0x4
    170a:	397d                	addiw	s2,s2,-1
    170c:	fe0916e3          	bnez	s2,16f8 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1710:	8bea                	mv	s7,s10
      state = 0;
    1712:	4981                	li	s3,0
    1714:	6d02                	ld	s10,0(sp)
    1716:	bd21                	j	152e <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1718:	008b8993          	addi	s3,s7,8
    171c:	000bb903          	ld	s2,0(s7)
    1720:	00090f63          	beqz	s2,173e <vprintf+0x25a>
        for(; *s; s++)
    1724:	00094583          	lbu	a1,0(s2)
    1728:	c195                	beqz	a1,174c <vprintf+0x268>
          putc(fd, *s);
    172a:	855a                	mv	a0,s6
    172c:	cf3ff0ef          	jal	141e <putc>
        for(; *s; s++)
    1730:	0905                	addi	s2,s2,1
    1732:	00094583          	lbu	a1,0(s2)
    1736:	f9f5                	bnez	a1,172a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1738:	8bce                	mv	s7,s3
      state = 0;
    173a:	4981                	li	s3,0
    173c:	bbcd                	j	152e <vprintf+0x4a>
          s = "(null)";
    173e:	00001917          	auipc	s2,0x1
    1742:	95290913          	addi	s2,s2,-1710 # 2090 <malloc+0x846>
        for(; *s; s++)
    1746:	02800593          	li	a1,40
    174a:	b7c5                	j	172a <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    174c:	8bce                	mv	s7,s3
      state = 0;
    174e:	4981                	li	s3,0
    1750:	bbf9                	j	152e <vprintf+0x4a>
    1752:	64a6                	ld	s1,72(sp)
    1754:	79e2                	ld	s3,56(sp)
    1756:	7a42                	ld	s4,48(sp)
    1758:	7aa2                	ld	s5,40(sp)
    175a:	7b02                	ld	s6,32(sp)
    175c:	6be2                	ld	s7,24(sp)
    175e:	6c42                	ld	s8,16(sp)
    1760:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1762:	60e6                	ld	ra,88(sp)
    1764:	6446                	ld	s0,80(sp)
    1766:	6906                	ld	s2,64(sp)
    1768:	6125                	addi	sp,sp,96
    176a:	8082                	ret

000000000000176c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    176c:	715d                	addi	sp,sp,-80
    176e:	ec06                	sd	ra,24(sp)
    1770:	e822                	sd	s0,16(sp)
    1772:	1000                	addi	s0,sp,32
    1774:	e010                	sd	a2,0(s0)
    1776:	e414                	sd	a3,8(s0)
    1778:	e818                	sd	a4,16(s0)
    177a:	ec1c                	sd	a5,24(s0)
    177c:	03043023          	sd	a6,32(s0)
    1780:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1784:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1788:	8622                	mv	a2,s0
    178a:	d5bff0ef          	jal	14e4 <vprintf>
}
    178e:	60e2                	ld	ra,24(sp)
    1790:	6442                	ld	s0,16(sp)
    1792:	6161                	addi	sp,sp,80
    1794:	8082                	ret

0000000000001796 <printf>:

void
printf(const char *fmt, ...)
{
    1796:	711d                	addi	sp,sp,-96
    1798:	ec06                	sd	ra,24(sp)
    179a:	e822                	sd	s0,16(sp)
    179c:	1000                	addi	s0,sp,32
    179e:	e40c                	sd	a1,8(s0)
    17a0:	e810                	sd	a2,16(s0)
    17a2:	ec14                	sd	a3,24(s0)
    17a4:	f018                	sd	a4,32(s0)
    17a6:	f41c                	sd	a5,40(s0)
    17a8:	03043823          	sd	a6,48(s0)
    17ac:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    17b0:	00840613          	addi	a2,s0,8
    17b4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    17b8:	85aa                	mv	a1,a0
    17ba:	4505                	li	a0,1
    17bc:	d29ff0ef          	jal	14e4 <vprintf>
}
    17c0:	60e2                	ld	ra,24(sp)
    17c2:	6442                	ld	s0,16(sp)
    17c4:	6125                	addi	sp,sp,96
    17c6:	8082                	ret

00000000000017c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    17c8:	1141                	addi	sp,sp,-16
    17ca:	e422                	sd	s0,8(sp)
    17cc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    17ce:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    17d2:	00001797          	auipc	a5,0x1
    17d6:	8de7b783          	ld	a5,-1826(a5) # 20b0 <freep>
    17da:	a02d                	j	1804 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    17dc:	4618                	lw	a4,8(a2)
    17de:	9f2d                	addw	a4,a4,a1
    17e0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    17e4:	6398                	ld	a4,0(a5)
    17e6:	6310                	ld	a2,0(a4)
    17e8:	a83d                	j	1826 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    17ea:	ff852703          	lw	a4,-8(a0)
    17ee:	9f31                	addw	a4,a4,a2
    17f0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    17f2:	ff053683          	ld	a3,-16(a0)
    17f6:	a091                	j	183a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    17f8:	6398                	ld	a4,0(a5)
    17fa:	00e7e463          	bltu	a5,a4,1802 <free+0x3a>
    17fe:	00e6ea63          	bltu	a3,a4,1812 <free+0x4a>
{
    1802:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1804:	fed7fae3          	bgeu	a5,a3,17f8 <free+0x30>
    1808:	6398                	ld	a4,0(a5)
    180a:	00e6e463          	bltu	a3,a4,1812 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    180e:	fee7eae3          	bltu	a5,a4,1802 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1812:	ff852583          	lw	a1,-8(a0)
    1816:	6390                	ld	a2,0(a5)
    1818:	02059813          	slli	a6,a1,0x20
    181c:	01c85713          	srli	a4,a6,0x1c
    1820:	9736                	add	a4,a4,a3
    1822:	fae60de3          	beq	a2,a4,17dc <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1826:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    182a:	4790                	lw	a2,8(a5)
    182c:	02061593          	slli	a1,a2,0x20
    1830:	01c5d713          	srli	a4,a1,0x1c
    1834:	973e                	add	a4,a4,a5
    1836:	fae68ae3          	beq	a3,a4,17ea <free+0x22>
    p->s.ptr = bp->s.ptr;
    183a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    183c:	00001717          	auipc	a4,0x1
    1840:	86f73a23          	sd	a5,-1932(a4) # 20b0 <freep>
}
    1844:	6422                	ld	s0,8(sp)
    1846:	0141                	addi	sp,sp,16
    1848:	8082                	ret

000000000000184a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    184a:	7139                	addi	sp,sp,-64
    184c:	fc06                	sd	ra,56(sp)
    184e:	f822                	sd	s0,48(sp)
    1850:	f426                	sd	s1,40(sp)
    1852:	ec4e                	sd	s3,24(sp)
    1854:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1856:	02051493          	slli	s1,a0,0x20
    185a:	9081                	srli	s1,s1,0x20
    185c:	04bd                	addi	s1,s1,15
    185e:	8091                	srli	s1,s1,0x4
    1860:	0014899b          	addiw	s3,s1,1
    1864:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1866:	00001517          	auipc	a0,0x1
    186a:	84a53503          	ld	a0,-1974(a0) # 20b0 <freep>
    186e:	c915                	beqz	a0,18a2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1870:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1872:	4798                	lw	a4,8(a5)
    1874:	08977a63          	bgeu	a4,s1,1908 <malloc+0xbe>
    1878:	f04a                	sd	s2,32(sp)
    187a:	e852                	sd	s4,16(sp)
    187c:	e456                	sd	s5,8(sp)
    187e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1880:	8a4e                	mv	s4,s3
    1882:	0009871b          	sext.w	a4,s3
    1886:	6685                	lui	a3,0x1
    1888:	00d77363          	bgeu	a4,a3,188e <malloc+0x44>
    188c:	6a05                	lui	s4,0x1
    188e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1892:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1896:	00001917          	auipc	s2,0x1
    189a:	81a90913          	addi	s2,s2,-2022 # 20b0 <freep>
  if(p == (char*)-1)
    189e:	5afd                	li	s5,-1
    18a0:	a081                	j	18e0 <malloc+0x96>
    18a2:	f04a                	sd	s2,32(sp)
    18a4:	e852                	sd	s4,16(sp)
    18a6:	e456                	sd	s5,8(sp)
    18a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    18aa:	00001797          	auipc	a5,0x1
    18ae:	81678793          	addi	a5,a5,-2026 # 20c0 <base>
    18b2:	00000717          	auipc	a4,0x0
    18b6:	7ef73f23          	sd	a5,2046(a4) # 20b0 <freep>
    18ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    18bc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    18c0:	b7c1                	j	1880 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    18c2:	6398                	ld	a4,0(a5)
    18c4:	e118                	sd	a4,0(a0)
    18c6:	a8a9                	j	1920 <malloc+0xd6>
  hp->s.size = nu;
    18c8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    18cc:	0541                	addi	a0,a0,16
    18ce:	efbff0ef          	jal	17c8 <free>
  return freep;
    18d2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    18d6:	c12d                	beqz	a0,1938 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    18d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    18da:	4798                	lw	a4,8(a5)
    18dc:	02977263          	bgeu	a4,s1,1900 <malloc+0xb6>
    if(p == freep)
    18e0:	00093703          	ld	a4,0(s2)
    18e4:	853e                	mv	a0,a5
    18e6:	fef719e3          	bne	a4,a5,18d8 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    18ea:	8552                	mv	a0,s4
    18ec:	ad3ff0ef          	jal	13be <sbrk>
  if(p == (char*)-1)
    18f0:	fd551ce3          	bne	a0,s5,18c8 <malloc+0x7e>
        return 0;
    18f4:	4501                	li	a0,0
    18f6:	7902                	ld	s2,32(sp)
    18f8:	6a42                	ld	s4,16(sp)
    18fa:	6aa2                	ld	s5,8(sp)
    18fc:	6b02                	ld	s6,0(sp)
    18fe:	a03d                	j	192c <malloc+0xe2>
    1900:	7902                	ld	s2,32(sp)
    1902:	6a42                	ld	s4,16(sp)
    1904:	6aa2                	ld	s5,8(sp)
    1906:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1908:	fae48de3          	beq	s1,a4,18c2 <malloc+0x78>
        p->s.size -= nunits;
    190c:	4137073b          	subw	a4,a4,s3
    1910:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1912:	02071693          	slli	a3,a4,0x20
    1916:	01c6d713          	srli	a4,a3,0x1c
    191a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    191c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1920:	00000717          	auipc	a4,0x0
    1924:	78a73823          	sd	a0,1936(a4) # 20b0 <freep>
      return (void*)(p + 1);
    1928:	01078513          	addi	a0,a5,16
  }
}
    192c:	70e2                	ld	ra,56(sp)
    192e:	7442                	ld	s0,48(sp)
    1930:	74a2                	ld	s1,40(sp)
    1932:	69e2                	ld	s3,24(sp)
    1934:	6121                	addi	sp,sp,64
    1936:	8082                	ret
    1938:	7902                	ld	s2,32(sp)
    193a:	6a42                	ld	s4,16(sp)
    193c:	6aa2                	ld	s5,8(sp)
    193e:	6b02                	ld	s6,0(sp)
    1940:	b7f5                	j	192c <malloc+0xe2>
	...
