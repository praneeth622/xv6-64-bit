
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
    1000:	711d                	addi	sp,sp,-96
    1002:	ec86                	sd	ra,88(sp)
    1004:	e8a2                	sd	s0,80(sp)
    1006:	e4a6                	sd	s1,72(sp)
    1008:	e0ca                	sd	s2,64(sp)
    100a:	fc4e                	sd	s3,56(sp)
    100c:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    100e:	00008797          	auipc	a5,0x8
    1012:	38a78793          	addi	a5,a5,906 # 9398 <malloc+0x3404>
    1016:	638c                	ld	a1,0(a5)
    1018:	6790                	ld	a2,8(a5)
    101a:	6b94                	ld	a3,16(a5)
    101c:	6f98                	ld	a4,24(a5)
    101e:	739c                	ld	a5,32(a5)
    1020:	fab43423          	sd	a1,-88(s0)
    1024:	fac43823          	sd	a2,-80(s0)
    1028:	fad43c23          	sd	a3,-72(s0)
    102c:	fce43023          	sd	a4,-64(s0)
    1030:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1034:	fa840493          	addi	s1,s0,-88
    1038:	fd040993          	addi	s3,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
    103c:	0004b903          	ld	s2,0(s1)
    1040:	20100593          	li	a1,513
    1044:	854a                	mv	a0,s2
    1046:	27b040ef          	jal	5ac0 <open>
    if(fd >= 0){
    104a:	00055c63          	bgez	a0,1062 <copyinstr1+0x62>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    104e:	04a1                	addi	s1,s1,8
    1050:	ff3496e3          	bne	s1,s3,103c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
    1054:	60e6                	ld	ra,88(sp)
    1056:	6446                	ld	s0,80(sp)
    1058:	64a6                	ld	s1,72(sp)
    105a:	6906                	ld	s2,64(sp)
    105c:	79e2                	ld	s3,56(sp)
    105e:	6125                	addi	sp,sp,96
    1060:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
    1062:	862a                	mv	a2,a0
    1064:	85ca                	mv	a1,s2
    1066:	00006517          	auipc	a0,0x6
    106a:	f9a50513          	addi	a0,a0,-102 # 7000 <malloc+0x106c>
    106e:	673040ef          	jal	5ee0 <printf>
      exit(1);
    1072:	4505                	li	a0,1
    1074:	20d040ef          	jal	5a80 <exit>

0000000000001078 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
    1078:	0000a797          	auipc	a5,0xa
    107c:	92078793          	addi	a5,a5,-1760 # a998 <uninit>
    1080:	0000c697          	auipc	a3,0xc
    1084:	02868693          	addi	a3,a3,40 # d0a8 <buf>
    if(uninit[i] != '\0'){
    1088:	0007c703          	lbu	a4,0(a5)
    108c:	e709                	bnez	a4,1096 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
    108e:	0785                	addi	a5,a5,1
    1090:	fed79ce3          	bne	a5,a3,1088 <bsstest+0x10>
    1094:	8082                	ret
{
    1096:	1141                	addi	sp,sp,-16
    1098:	e406                	sd	ra,8(sp)
    109a:	e022                	sd	s0,0(sp)
    109c:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
    109e:	85aa                	mv	a1,a0
    10a0:	00006517          	auipc	a0,0x6
    10a4:	f8050513          	addi	a0,a0,-128 # 7020 <malloc+0x108c>
    10a8:	639040ef          	jal	5ee0 <printf>
      exit(1);
    10ac:	4505                	li	a0,1
    10ae:	1d3040ef          	jal	5a80 <exit>

00000000000010b2 <opentest>:
{
    10b2:	1101                	addi	sp,sp,-32
    10b4:	ec06                	sd	ra,24(sp)
    10b6:	e822                	sd	s0,16(sp)
    10b8:	e426                	sd	s1,8(sp)
    10ba:	1000                	addi	s0,sp,32
    10bc:	84aa                	mv	s1,a0
  fd = open("echo", 0);
    10be:	4581                	li	a1,0
    10c0:	00006517          	auipc	a0,0x6
    10c4:	f7850513          	addi	a0,a0,-136 # 7038 <malloc+0x10a4>
    10c8:	1f9040ef          	jal	5ac0 <open>
  if(fd < 0){
    10cc:	02054263          	bltz	a0,10f0 <opentest+0x3e>
  close(fd);
    10d0:	1d9040ef          	jal	5aa8 <close>
  fd = open("doesnotexist", 0);
    10d4:	4581                	li	a1,0
    10d6:	00006517          	auipc	a0,0x6
    10da:	f8250513          	addi	a0,a0,-126 # 7058 <malloc+0x10c4>
    10de:	1e3040ef          	jal	5ac0 <open>
  if(fd >= 0){
    10e2:	02055163          	bgez	a0,1104 <opentest+0x52>
}
    10e6:	60e2                	ld	ra,24(sp)
    10e8:	6442                	ld	s0,16(sp)
    10ea:	64a2                	ld	s1,8(sp)
    10ec:	6105                	addi	sp,sp,32
    10ee:	8082                	ret
    printf("%s: open echo failed!\n", s);
    10f0:	85a6                	mv	a1,s1
    10f2:	00006517          	auipc	a0,0x6
    10f6:	f4e50513          	addi	a0,a0,-178 # 7040 <malloc+0x10ac>
    10fa:	5e7040ef          	jal	5ee0 <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	181040ef          	jal	5a80 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
    1104:	85a6                	mv	a1,s1
    1106:	00006517          	auipc	a0,0x6
    110a:	f6250513          	addi	a0,a0,-158 # 7068 <malloc+0x10d4>
    110e:	5d3040ef          	jal	5ee0 <printf>
    exit(1);
    1112:	4505                	li	a0,1
    1114:	16d040ef          	jal	5a80 <exit>

0000000000001118 <truncate2>:
{
    1118:	7179                	addi	sp,sp,-48
    111a:	f406                	sd	ra,40(sp)
    111c:	f022                	sd	s0,32(sp)
    111e:	ec26                	sd	s1,24(sp)
    1120:	e84a                	sd	s2,16(sp)
    1122:	e44e                	sd	s3,8(sp)
    1124:	1800                	addi	s0,sp,48
    1126:	89aa                	mv	s3,a0
  unlink("truncfile");
    1128:	00006517          	auipc	a0,0x6
    112c:	f6850513          	addi	a0,a0,-152 # 7090 <malloc+0x10fc>
    1130:	1a1040ef          	jal	5ad0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
    1134:	60100593          	li	a1,1537
    1138:	00006517          	auipc	a0,0x6
    113c:	f5850513          	addi	a0,a0,-168 # 7090 <malloc+0x10fc>
    1140:	181040ef          	jal	5ac0 <open>
    1144:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
    1146:	4611                	li	a2,4
    1148:	00006597          	auipc	a1,0x6
    114c:	f5858593          	addi	a1,a1,-168 # 70a0 <malloc+0x110c>
    1150:	151040ef          	jal	5aa0 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
    1154:	40100593          	li	a1,1025
    1158:	00006517          	auipc	a0,0x6
    115c:	f3850513          	addi	a0,a0,-200 # 7090 <malloc+0x10fc>
    1160:	161040ef          	jal	5ac0 <open>
    1164:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
    1166:	4605                	li	a2,1
    1168:	00006597          	auipc	a1,0x6
    116c:	f4058593          	addi	a1,a1,-192 # 70a8 <malloc+0x1114>
    1170:	8526                	mv	a0,s1
    1172:	12f040ef          	jal	5aa0 <write>
  if(n != -1){
    1176:	57fd                	li	a5,-1
    1178:	02f51563          	bne	a0,a5,11a2 <truncate2+0x8a>
  unlink("truncfile");
    117c:	00006517          	auipc	a0,0x6
    1180:	f1450513          	addi	a0,a0,-236 # 7090 <malloc+0x10fc>
    1184:	14d040ef          	jal	5ad0 <unlink>
  close(fd1);
    1188:	8526                	mv	a0,s1
    118a:	11f040ef          	jal	5aa8 <close>
  close(fd2);
    118e:	854a                	mv	a0,s2
    1190:	119040ef          	jal	5aa8 <close>
}
    1194:	70a2                	ld	ra,40(sp)
    1196:	7402                	ld	s0,32(sp)
    1198:	64e2                	ld	s1,24(sp)
    119a:	6942                	ld	s2,16(sp)
    119c:	69a2                	ld	s3,8(sp)
    119e:	6145                	addi	sp,sp,48
    11a0:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
    11a2:	862a                	mv	a2,a0
    11a4:	85ce                	mv	a1,s3
    11a6:	00006517          	auipc	a0,0x6
    11aa:	f0a50513          	addi	a0,a0,-246 # 70b0 <malloc+0x111c>
    11ae:	533040ef          	jal	5ee0 <printf>
    exit(1);
    11b2:	4505                	li	a0,1
    11b4:	0cd040ef          	jal	5a80 <exit>

00000000000011b8 <createtest>:
{
    11b8:	7179                	addi	sp,sp,-48
    11ba:	f406                	sd	ra,40(sp)
    11bc:	f022                	sd	s0,32(sp)
    11be:	ec26                	sd	s1,24(sp)
    11c0:	e84a                	sd	s2,16(sp)
    11c2:	1800                	addi	s0,sp,48
  name[0] = 'a';
    11c4:	06100793          	li	a5,97
    11c8:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
    11cc:	fc040d23          	sb	zero,-38(s0)
    11d0:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    11d4:	06400913          	li	s2,100
    name[1] = '0' + i;
    11d8:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
    11dc:	20200593          	li	a1,514
    11e0:	fd840513          	addi	a0,s0,-40
    11e4:	0dd040ef          	jal	5ac0 <open>
    close(fd);
    11e8:	0c1040ef          	jal	5aa8 <close>
  for(i = 0; i < N; i++){
    11ec:	2485                	addiw	s1,s1,1
    11ee:	0ff4f493          	zext.b	s1,s1
    11f2:	ff2493e3          	bne	s1,s2,11d8 <createtest+0x20>
  name[0] = 'a';
    11f6:	06100793          	li	a5,97
    11fa:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
    11fe:	fc040d23          	sb	zero,-38(s0)
    1202:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
    1206:	06400913          	li	s2,100
    name[1] = '0' + i;
    120a:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
    120e:	fd840513          	addi	a0,s0,-40
    1212:	0bf040ef          	jal	5ad0 <unlink>
  for(i = 0; i < N; i++){
    1216:	2485                	addiw	s1,s1,1
    1218:	0ff4f493          	zext.b	s1,s1
    121c:	ff2497e3          	bne	s1,s2,120a <createtest+0x52>
}
    1220:	70a2                	ld	ra,40(sp)
    1222:	7402                	ld	s0,32(sp)
    1224:	64e2                	ld	s1,24(sp)
    1226:	6942                	ld	s2,16(sp)
    1228:	6145                	addi	sp,sp,48
    122a:	8082                	ret

000000000000122c <bigwrite>:
{
    122c:	715d                	addi	sp,sp,-80
    122e:	e486                	sd	ra,72(sp)
    1230:	e0a2                	sd	s0,64(sp)
    1232:	fc26                	sd	s1,56(sp)
    1234:	f84a                	sd	s2,48(sp)
    1236:	f44e                	sd	s3,40(sp)
    1238:	f052                	sd	s4,32(sp)
    123a:	ec56                	sd	s5,24(sp)
    123c:	e85a                	sd	s6,16(sp)
    123e:	e45e                	sd	s7,8(sp)
    1240:	0880                	addi	s0,sp,80
    1242:	8baa                	mv	s7,a0
  unlink("bigwrite");
    1244:	00006517          	auipc	a0,0x6
    1248:	e9450513          	addi	a0,a0,-364 # 70d8 <malloc+0x1144>
    124c:	085040ef          	jal	5ad0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    1250:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
    1254:	00006a97          	auipc	s5,0x6
    1258:	e84a8a93          	addi	s5,s5,-380 # 70d8 <malloc+0x1144>
      int cc = write(fd, buf, sz);
    125c:	0000ca17          	auipc	s4,0xc
    1260:	e4ca0a13          	addi	s4,s4,-436 # d0a8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    1264:	6b0d                	lui	s6,0x3
    1266:	1c9b0b13          	addi	s6,s6,457 # 31c9 <sbrkbasic+0xf5>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    126a:	20200593          	li	a1,514
    126e:	8556                	mv	a0,s5
    1270:	051040ef          	jal	5ac0 <open>
    1274:	892a                	mv	s2,a0
    if(fd < 0){
    1276:	04054563          	bltz	a0,12c0 <bigwrite+0x94>
      int cc = write(fd, buf, sz);
    127a:	8626                	mv	a2,s1
    127c:	85d2                	mv	a1,s4
    127e:	023040ef          	jal	5aa0 <write>
    1282:	89aa                	mv	s3,a0
      if(cc != sz){
    1284:	04a49863          	bne	s1,a0,12d4 <bigwrite+0xa8>
      int cc = write(fd, buf, sz);
    1288:	8626                	mv	a2,s1
    128a:	85d2                	mv	a1,s4
    128c:	854a                	mv	a0,s2
    128e:	013040ef          	jal	5aa0 <write>
      if(cc != sz){
    1292:	04951263          	bne	a0,s1,12d6 <bigwrite+0xaa>
    close(fd);
    1296:	854a                	mv	a0,s2
    1298:	011040ef          	jal	5aa8 <close>
    unlink("bigwrite");
    129c:	8556                	mv	a0,s5
    129e:	033040ef          	jal	5ad0 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
    12a2:	1d74849b          	addiw	s1,s1,471
    12a6:	fd6492e3          	bne	s1,s6,126a <bigwrite+0x3e>
}
    12aa:	60a6                	ld	ra,72(sp)
    12ac:	6406                	ld	s0,64(sp)
    12ae:	74e2                	ld	s1,56(sp)
    12b0:	7942                	ld	s2,48(sp)
    12b2:	79a2                	ld	s3,40(sp)
    12b4:	7a02                	ld	s4,32(sp)
    12b6:	6ae2                	ld	s5,24(sp)
    12b8:	6b42                	ld	s6,16(sp)
    12ba:	6ba2                	ld	s7,8(sp)
    12bc:	6161                	addi	sp,sp,80
    12be:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
    12c0:	85de                	mv	a1,s7
    12c2:	00006517          	auipc	a0,0x6
    12c6:	e2650513          	addi	a0,a0,-474 # 70e8 <malloc+0x1154>
    12ca:	417040ef          	jal	5ee0 <printf>
      exit(1);
    12ce:	4505                	li	a0,1
    12d0:	7b0040ef          	jal	5a80 <exit>
      if(cc != sz){
    12d4:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
    12d6:	86aa                	mv	a3,a0
    12d8:	864e                	mv	a2,s3
    12da:	85de                	mv	a1,s7
    12dc:	00006517          	auipc	a0,0x6
    12e0:	e2c50513          	addi	a0,a0,-468 # 7108 <malloc+0x1174>
    12e4:	3fd040ef          	jal	5ee0 <printf>
        exit(1);
    12e8:	4505                	li	a0,1
    12ea:	796040ef          	jal	5a80 <exit>

00000000000012ee <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
    12ee:	7179                	addi	sp,sp,-48
    12f0:	f406                	sd	ra,40(sp)
    12f2:	f022                	sd	s0,32(sp)
    12f4:	ec26                	sd	s1,24(sp)
    12f6:	e84a                	sd	s2,16(sp)
    12f8:	e44e                	sd	s3,8(sp)
    12fa:	e052                	sd	s4,0(sp)
    12fc:	1800                	addi	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
    12fe:	00006517          	auipc	a0,0x6
    1302:	e2250513          	addi	a0,a0,-478 # 7120 <malloc+0x118c>
    1306:	7ca040ef          	jal	5ad0 <unlink>
    130a:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
    130e:	00006997          	auipc	s3,0x6
    1312:	e1298993          	addi	s3,s3,-494 # 7120 <malloc+0x118c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
    1316:	5a7d                	li	s4,-1
    1318:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    131c:	20100593          	li	a1,513
    1320:	854e                	mv	a0,s3
    1322:	79e040ef          	jal	5ac0 <open>
    1326:	84aa                	mv	s1,a0
    if(fd < 0){
    1328:	04054d63          	bltz	a0,1382 <badwrite+0x94>
    write(fd, (char*)0xffffffffffL, 1);
    132c:	4605                	li	a2,1
    132e:	85d2                	mv	a1,s4
    1330:	770040ef          	jal	5aa0 <write>
    close(fd);
    1334:	8526                	mv	a0,s1
    1336:	772040ef          	jal	5aa8 <close>
    unlink("junk");
    133a:	854e                	mv	a0,s3
    133c:	794040ef          	jal	5ad0 <unlink>
  for(int i = 0; i < assumed_free; i++){
    1340:	397d                	addiw	s2,s2,-1
    1342:	fc091de3          	bnez	s2,131c <badwrite+0x2e>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
    1346:	20100593          	li	a1,513
    134a:	00006517          	auipc	a0,0x6
    134e:	dd650513          	addi	a0,a0,-554 # 7120 <malloc+0x118c>
    1352:	76e040ef          	jal	5ac0 <open>
    1356:	84aa                	mv	s1,a0
  if(fd < 0){
    1358:	02054e63          	bltz	a0,1394 <badwrite+0xa6>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
    135c:	4605                	li	a2,1
    135e:	00006597          	auipc	a1,0x6
    1362:	d4a58593          	addi	a1,a1,-694 # 70a8 <malloc+0x1114>
    1366:	73a040ef          	jal	5aa0 <write>
    136a:	4785                	li	a5,1
    136c:	02f50d63          	beq	a0,a5,13a6 <badwrite+0xb8>
    printf("write failed\n");
    1370:	00006517          	auipc	a0,0x6
    1374:	dd050513          	addi	a0,a0,-560 # 7140 <malloc+0x11ac>
    1378:	369040ef          	jal	5ee0 <printf>
    exit(1);
    137c:	4505                	li	a0,1
    137e:	702040ef          	jal	5a80 <exit>
      printf("open junk failed\n");
    1382:	00006517          	auipc	a0,0x6
    1386:	da650513          	addi	a0,a0,-602 # 7128 <malloc+0x1194>
    138a:	357040ef          	jal	5ee0 <printf>
      exit(1);
    138e:	4505                	li	a0,1
    1390:	6f0040ef          	jal	5a80 <exit>
    printf("open junk failed\n");
    1394:	00006517          	auipc	a0,0x6
    1398:	d9450513          	addi	a0,a0,-620 # 7128 <malloc+0x1194>
    139c:	345040ef          	jal	5ee0 <printf>
    exit(1);
    13a0:	4505                	li	a0,1
    13a2:	6de040ef          	jal	5a80 <exit>
  }
  close(fd);
    13a6:	8526                	mv	a0,s1
    13a8:	700040ef          	jal	5aa8 <close>
  unlink("junk");
    13ac:	00006517          	auipc	a0,0x6
    13b0:	d7450513          	addi	a0,a0,-652 # 7120 <malloc+0x118c>
    13b4:	71c040ef          	jal	5ad0 <unlink>

  exit(0);
    13b8:	4501                	li	a0,0
    13ba:	6c6040ef          	jal	5a80 <exit>

00000000000013be <outofinodes>:
  }
}

void
outofinodes(char *s)
{
    13be:	715d                	addi	sp,sp,-80
    13c0:	e486                	sd	ra,72(sp)
    13c2:	e0a2                	sd	s0,64(sp)
    13c4:	fc26                	sd	s1,56(sp)
    13c6:	f84a                	sd	s2,48(sp)
    13c8:	f44e                	sd	s3,40(sp)
    13ca:	0880                	addi	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
    13cc:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
    13ce:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    13d2:	40000993          	li	s3,1024
    name[0] = 'z';
    13d6:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
    13da:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
    13de:	41f4d71b          	sraiw	a4,s1,0x1f
    13e2:	01b7571b          	srliw	a4,a4,0x1b
    13e6:	009707bb          	addw	a5,a4,s1
    13ea:	4057d69b          	sraiw	a3,a5,0x5
    13ee:	0306869b          	addiw	a3,a3,48
    13f2:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
    13f6:	8bfd                	andi	a5,a5,31
    13f8:	9f99                	subw	a5,a5,a4
    13fa:	0307879b          	addiw	a5,a5,48
    13fe:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
    1402:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
    1406:	fb040513          	addi	a0,s0,-80
    140a:	6c6040ef          	jal	5ad0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    140e:	60200593          	li	a1,1538
    1412:	fb040513          	addi	a0,s0,-80
    1416:	6aa040ef          	jal	5ac0 <open>
    if(fd < 0){
    141a:	00054763          	bltz	a0,1428 <outofinodes+0x6a>
      // failure is eventually expected.
      break;
    }
    close(fd);
    141e:	68a040ef          	jal	5aa8 <close>
  for(int i = 0; i < nzz; i++){
    1422:	2485                	addiw	s1,s1,1
    1424:	fb3499e3          	bne	s1,s3,13d6 <outofinodes+0x18>
    1428:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
    142a:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    142e:	40000993          	li	s3,1024
    name[0] = 'z';
    1432:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
    1436:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
    143a:	41f4d71b          	sraiw	a4,s1,0x1f
    143e:	01b7571b          	srliw	a4,a4,0x1b
    1442:	009707bb          	addw	a5,a4,s1
    1446:	4057d69b          	sraiw	a3,a5,0x5
    144a:	0306869b          	addiw	a3,a3,48
    144e:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
    1452:	8bfd                	andi	a5,a5,31
    1454:	9f99                	subw	a5,a5,a4
    1456:	0307879b          	addiw	a5,a5,48
    145a:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
    145e:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
    1462:	fb040513          	addi	a0,s0,-80
    1466:	66a040ef          	jal	5ad0 <unlink>
  for(int i = 0; i < nzz; i++){
    146a:	2485                	addiw	s1,s1,1
    146c:	fd3493e3          	bne	s1,s3,1432 <outofinodes+0x74>
  }
}
    1470:	60a6                	ld	ra,72(sp)
    1472:	6406                	ld	s0,64(sp)
    1474:	74e2                	ld	s1,56(sp)
    1476:	7942                	ld	s2,48(sp)
    1478:	79a2                	ld	s3,40(sp)
    147a:	6161                	addi	sp,sp,80
    147c:	8082                	ret

000000000000147e <copyin>:
{
    147e:	7159                	addi	sp,sp,-112
    1480:	f486                	sd	ra,104(sp)
    1482:	f0a2                	sd	s0,96(sp)
    1484:	eca6                	sd	s1,88(sp)
    1486:	e8ca                	sd	s2,80(sp)
    1488:	e4ce                	sd	s3,72(sp)
    148a:	e0d2                	sd	s4,64(sp)
    148c:	fc56                	sd	s5,56(sp)
    148e:	1880                	addi	s0,sp,112
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1490:	00008797          	auipc	a5,0x8
    1494:	f0878793          	addi	a5,a5,-248 # 9398 <malloc+0x3404>
    1498:	638c                	ld	a1,0(a5)
    149a:	6790                	ld	a2,8(a5)
    149c:	6b94                	ld	a3,16(a5)
    149e:	6f98                	ld	a4,24(a5)
    14a0:	739c                	ld	a5,32(a5)
    14a2:	f8b43c23          	sd	a1,-104(s0)
    14a6:	fac43023          	sd	a2,-96(s0)
    14aa:	fad43423          	sd	a3,-88(s0)
    14ae:	fae43823          	sd	a4,-80(s0)
    14b2:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    14b6:	f9840913          	addi	s2,s0,-104
    14ba:	fc040a93          	addi	s5,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
    14be:	00006a17          	auipc	s4,0x6
    14c2:	c92a0a13          	addi	s4,s4,-878 # 7150 <malloc+0x11bc>
    uint64 addr = addrs[ai];
    14c6:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
    14ca:	20100593          	li	a1,513
    14ce:	8552                	mv	a0,s4
    14d0:	5f0040ef          	jal	5ac0 <open>
    14d4:	84aa                	mv	s1,a0
    if(fd < 0){
    14d6:	06054763          	bltz	a0,1544 <copyin+0xc6>
    int n = write(fd, (void*)addr, 8192);
    14da:	6609                	lui	a2,0x2
    14dc:	85ce                	mv	a1,s3
    14de:	5c2040ef          	jal	5aa0 <write>
    if(n >= 0){
    14e2:	06055a63          	bgez	a0,1556 <copyin+0xd8>
    close(fd);
    14e6:	8526                	mv	a0,s1
    14e8:	5c0040ef          	jal	5aa8 <close>
    unlink("copyin1");
    14ec:	8552                	mv	a0,s4
    14ee:	5e2040ef          	jal	5ad0 <unlink>
    n = write(1, (char*)addr, 8192);
    14f2:	6609                	lui	a2,0x2
    14f4:	85ce                	mv	a1,s3
    14f6:	4505                	li	a0,1
    14f8:	5a8040ef          	jal	5aa0 <write>
    if(n > 0){
    14fc:	06a04863          	bgtz	a0,156c <copyin+0xee>
    if(pipe(fds) < 0){
    1500:	f9040513          	addi	a0,s0,-112
    1504:	58c040ef          	jal	5a90 <pipe>
    1508:	06054d63          	bltz	a0,1582 <copyin+0x104>
    n = write(fds[1], (char*)addr, 8192);
    150c:	6609                	lui	a2,0x2
    150e:	85ce                	mv	a1,s3
    1510:	f9442503          	lw	a0,-108(s0)
    1514:	58c040ef          	jal	5aa0 <write>
    if(n > 0){
    1518:	06a04e63          	bgtz	a0,1594 <copyin+0x116>
    close(fds[0]);
    151c:	f9042503          	lw	a0,-112(s0)
    1520:	588040ef          	jal	5aa8 <close>
    close(fds[1]);
    1524:	f9442503          	lw	a0,-108(s0)
    1528:	580040ef          	jal	5aa8 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    152c:	0921                	addi	s2,s2,8
    152e:	f9591ce3          	bne	s2,s5,14c6 <copyin+0x48>
}
    1532:	70a6                	ld	ra,104(sp)
    1534:	7406                	ld	s0,96(sp)
    1536:	64e6                	ld	s1,88(sp)
    1538:	6946                	ld	s2,80(sp)
    153a:	69a6                	ld	s3,72(sp)
    153c:	6a06                	ld	s4,64(sp)
    153e:	7ae2                	ld	s5,56(sp)
    1540:	6165                	addi	sp,sp,112
    1542:	8082                	ret
      printf("open(copyin1) failed\n");
    1544:	00006517          	auipc	a0,0x6
    1548:	c1450513          	addi	a0,a0,-1004 # 7158 <malloc+0x11c4>
    154c:	195040ef          	jal	5ee0 <printf>
      exit(1);
    1550:	4505                	li	a0,1
    1552:	52e040ef          	jal	5a80 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
    1556:	862a                	mv	a2,a0
    1558:	85ce                	mv	a1,s3
    155a:	00006517          	auipc	a0,0x6
    155e:	c1650513          	addi	a0,a0,-1002 # 7170 <malloc+0x11dc>
    1562:	17f040ef          	jal	5ee0 <printf>
      exit(1);
    1566:	4505                	li	a0,1
    1568:	518040ef          	jal	5a80 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
    156c:	862a                	mv	a2,a0
    156e:	85ce                	mv	a1,s3
    1570:	00006517          	auipc	a0,0x6
    1574:	c3050513          	addi	a0,a0,-976 # 71a0 <malloc+0x120c>
    1578:	169040ef          	jal	5ee0 <printf>
      exit(1);
    157c:	4505                	li	a0,1
    157e:	502040ef          	jal	5a80 <exit>
      printf("pipe() failed\n");
    1582:	00006517          	auipc	a0,0x6
    1586:	c4e50513          	addi	a0,a0,-946 # 71d0 <malloc+0x123c>
    158a:	157040ef          	jal	5ee0 <printf>
      exit(1);
    158e:	4505                	li	a0,1
    1590:	4f0040ef          	jal	5a80 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
    1594:	862a                	mv	a2,a0
    1596:	85ce                	mv	a1,s3
    1598:	00006517          	auipc	a0,0x6
    159c:	c4850513          	addi	a0,a0,-952 # 71e0 <malloc+0x124c>
    15a0:	141040ef          	jal	5ee0 <printf>
      exit(1);
    15a4:	4505                	li	a0,1
    15a6:	4da040ef          	jal	5a80 <exit>

00000000000015aa <copyout>:
{
    15aa:	7119                	addi	sp,sp,-128
    15ac:	fc86                	sd	ra,120(sp)
    15ae:	f8a2                	sd	s0,112(sp)
    15b0:	f4a6                	sd	s1,104(sp)
    15b2:	f0ca                	sd	s2,96(sp)
    15b4:	ecce                	sd	s3,88(sp)
    15b6:	e8d2                	sd	s4,80(sp)
    15b8:	e4d6                	sd	s5,72(sp)
    15ba:	e0da                	sd	s6,64(sp)
    15bc:	0100                	addi	s0,sp,128
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    15be:	00008797          	auipc	a5,0x8
    15c2:	dda78793          	addi	a5,a5,-550 # 9398 <malloc+0x3404>
    15c6:	7788                	ld	a0,40(a5)
    15c8:	7b8c                	ld	a1,48(a5)
    15ca:	7f90                	ld	a2,56(a5)
    15cc:	63b4                	ld	a3,64(a5)
    15ce:	67b8                	ld	a4,72(a5)
    15d0:	6bbc                	ld	a5,80(a5)
    15d2:	f8a43823          	sd	a0,-112(s0)
    15d6:	f8b43c23          	sd	a1,-104(s0)
    15da:	fac43023          	sd	a2,-96(s0)
    15de:	fad43423          	sd	a3,-88(s0)
    15e2:	fae43823          	sd	a4,-80(s0)
    15e6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    15ea:	f9040913          	addi	s2,s0,-112
    15ee:	fc040b13          	addi	s6,s0,-64
    int fd = open("README", 0);
    15f2:	00006a17          	auipc	s4,0x6
    15f6:	c1ea0a13          	addi	s4,s4,-994 # 7210 <malloc+0x127c>
    n = write(fds[1], "x", 1);
    15fa:	00006a97          	auipc	s5,0x6
    15fe:	aaea8a93          	addi	s5,s5,-1362 # 70a8 <malloc+0x1114>
    uint64 addr = addrs[ai];
    1602:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	4b6040ef          	jal	5ac0 <open>
    160e:	84aa                	mv	s1,a0
    if(fd < 0){
    1610:	06054763          	bltz	a0,167e <copyout+0xd4>
    int n = read(fd, (void*)addr, 8192);
    1614:	6609                	lui	a2,0x2
    1616:	85ce                	mv	a1,s3
    1618:	480040ef          	jal	5a98 <read>
    if(n > 0){
    161c:	06a04a63          	bgtz	a0,1690 <copyout+0xe6>
    close(fd);
    1620:	8526                	mv	a0,s1
    1622:	486040ef          	jal	5aa8 <close>
    if(pipe(fds) < 0){
    1626:	f8840513          	addi	a0,s0,-120
    162a:	466040ef          	jal	5a90 <pipe>
    162e:	06054c63          	bltz	a0,16a6 <copyout+0xfc>
    n = write(fds[1], "x", 1);
    1632:	4605                	li	a2,1
    1634:	85d6                	mv	a1,s5
    1636:	f8c42503          	lw	a0,-116(s0)
    163a:	466040ef          	jal	5aa0 <write>
    if(n != 1){
    163e:	4785                	li	a5,1
    1640:	06f51c63          	bne	a0,a5,16b8 <copyout+0x10e>
    n = read(fds[0], (void*)addr, 8192);
    1644:	6609                	lui	a2,0x2
    1646:	85ce                	mv	a1,s3
    1648:	f8842503          	lw	a0,-120(s0)
    164c:	44c040ef          	jal	5a98 <read>
    if(n > 0){
    1650:	06a04d63          	bgtz	a0,16ca <copyout+0x120>
    close(fds[0]);
    1654:	f8842503          	lw	a0,-120(s0)
    1658:	450040ef          	jal	5aa8 <close>
    close(fds[1]);
    165c:	f8c42503          	lw	a0,-116(s0)
    1660:	448040ef          	jal	5aa8 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1664:	0921                	addi	s2,s2,8
    1666:	f9691ee3          	bne	s2,s6,1602 <copyout+0x58>
}
    166a:	70e6                	ld	ra,120(sp)
    166c:	7446                	ld	s0,112(sp)
    166e:	74a6                	ld	s1,104(sp)
    1670:	7906                	ld	s2,96(sp)
    1672:	69e6                	ld	s3,88(sp)
    1674:	6a46                	ld	s4,80(sp)
    1676:	6aa6                	ld	s5,72(sp)
    1678:	6b06                	ld	s6,64(sp)
    167a:	6109                	addi	sp,sp,128
    167c:	8082                	ret
      printf("open(README) failed\n");
    167e:	00006517          	auipc	a0,0x6
    1682:	b9a50513          	addi	a0,a0,-1126 # 7218 <malloc+0x1284>
    1686:	05b040ef          	jal	5ee0 <printf>
      exit(1);
    168a:	4505                	li	a0,1
    168c:	3f4040ef          	jal	5a80 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
    1690:	862a                	mv	a2,a0
    1692:	85ce                	mv	a1,s3
    1694:	00006517          	auipc	a0,0x6
    1698:	b9c50513          	addi	a0,a0,-1124 # 7230 <malloc+0x129c>
    169c:	045040ef          	jal	5ee0 <printf>
      exit(1);
    16a0:	4505                	li	a0,1
    16a2:	3de040ef          	jal	5a80 <exit>
      printf("pipe() failed\n");
    16a6:	00006517          	auipc	a0,0x6
    16aa:	b2a50513          	addi	a0,a0,-1238 # 71d0 <malloc+0x123c>
    16ae:	033040ef          	jal	5ee0 <printf>
      exit(1);
    16b2:	4505                	li	a0,1
    16b4:	3cc040ef          	jal	5a80 <exit>
      printf("pipe write failed\n");
    16b8:	00006517          	auipc	a0,0x6
    16bc:	ba850513          	addi	a0,a0,-1112 # 7260 <malloc+0x12cc>
    16c0:	021040ef          	jal	5ee0 <printf>
      exit(1);
    16c4:	4505                	li	a0,1
    16c6:	3ba040ef          	jal	5a80 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
    16ca:	862a                	mv	a2,a0
    16cc:	85ce                	mv	a1,s3
    16ce:	00006517          	auipc	a0,0x6
    16d2:	baa50513          	addi	a0,a0,-1110 # 7278 <malloc+0x12e4>
    16d6:	00b040ef          	jal	5ee0 <printf>
      exit(1);
    16da:	4505                	li	a0,1
    16dc:	3a4040ef          	jal	5a80 <exit>

00000000000016e0 <truncate1>:
{
    16e0:	711d                	addi	sp,sp,-96
    16e2:	ec86                	sd	ra,88(sp)
    16e4:	e8a2                	sd	s0,80(sp)
    16e6:	e4a6                	sd	s1,72(sp)
    16e8:	e0ca                	sd	s2,64(sp)
    16ea:	fc4e                	sd	s3,56(sp)
    16ec:	f852                	sd	s4,48(sp)
    16ee:	f456                	sd	s5,40(sp)
    16f0:	1080                	addi	s0,sp,96
    16f2:	8aaa                	mv	s5,a0
  unlink("truncfile");
    16f4:	00006517          	auipc	a0,0x6
    16f8:	99c50513          	addi	a0,a0,-1636 # 7090 <malloc+0x10fc>
    16fc:	3d4040ef          	jal	5ad0 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1700:	60100593          	li	a1,1537
    1704:	00006517          	auipc	a0,0x6
    1708:	98c50513          	addi	a0,a0,-1652 # 7090 <malloc+0x10fc>
    170c:	3b4040ef          	jal	5ac0 <open>
    1710:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
    1712:	4611                	li	a2,4
    1714:	00006597          	auipc	a1,0x6
    1718:	98c58593          	addi	a1,a1,-1652 # 70a0 <malloc+0x110c>
    171c:	384040ef          	jal	5aa0 <write>
  close(fd1);
    1720:	8526                	mv	a0,s1
    1722:	386040ef          	jal	5aa8 <close>
  int fd2 = open("truncfile", O_RDONLY);
    1726:	4581                	li	a1,0
    1728:	00006517          	auipc	a0,0x6
    172c:	96850513          	addi	a0,a0,-1688 # 7090 <malloc+0x10fc>
    1730:	390040ef          	jal	5ac0 <open>
    1734:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
    1736:	02000613          	li	a2,32
    173a:	fa040593          	addi	a1,s0,-96
    173e:	35a040ef          	jal	5a98 <read>
  if(n != 4){
    1742:	4791                	li	a5,4
    1744:	0af51863          	bne	a0,a5,17f4 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
    1748:	40100593          	li	a1,1025
    174c:	00006517          	auipc	a0,0x6
    1750:	94450513          	addi	a0,a0,-1724 # 7090 <malloc+0x10fc>
    1754:	36c040ef          	jal	5ac0 <open>
    1758:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
    175a:	4581                	li	a1,0
    175c:	00006517          	auipc	a0,0x6
    1760:	93450513          	addi	a0,a0,-1740 # 7090 <malloc+0x10fc>
    1764:	35c040ef          	jal	5ac0 <open>
    1768:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
    176a:	02000613          	li	a2,32
    176e:	fa040593          	addi	a1,s0,-96
    1772:	326040ef          	jal	5a98 <read>
    1776:	8a2a                	mv	s4,a0
  if(n != 0){
    1778:	e949                	bnez	a0,180a <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
    177a:	02000613          	li	a2,32
    177e:	fa040593          	addi	a1,s0,-96
    1782:	8526                	mv	a0,s1
    1784:	314040ef          	jal	5a98 <read>
    1788:	8a2a                	mv	s4,a0
  if(n != 0){
    178a:	e155                	bnez	a0,182e <truncate1+0x14e>
  write(fd1, "abcdef", 6);
    178c:	4619                	li	a2,6
    178e:	00006597          	auipc	a1,0x6
    1792:	b7a58593          	addi	a1,a1,-1158 # 7308 <malloc+0x1374>
    1796:	854e                	mv	a0,s3
    1798:	308040ef          	jal	5aa0 <write>
  n = read(fd3, buf, sizeof(buf));
    179c:	02000613          	li	a2,32
    17a0:	fa040593          	addi	a1,s0,-96
    17a4:	854a                	mv	a0,s2
    17a6:	2f2040ef          	jal	5a98 <read>
  if(n != 6){
    17aa:	4799                	li	a5,6
    17ac:	0af51363          	bne	a0,a5,1852 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
    17b0:	02000613          	li	a2,32
    17b4:	fa040593          	addi	a1,s0,-96
    17b8:	8526                	mv	a0,s1
    17ba:	2de040ef          	jal	5a98 <read>
  if(n != 2){
    17be:	4789                	li	a5,2
    17c0:	0af51463          	bne	a0,a5,1868 <truncate1+0x188>
  unlink("truncfile");
    17c4:	00006517          	auipc	a0,0x6
    17c8:	8cc50513          	addi	a0,a0,-1844 # 7090 <malloc+0x10fc>
    17cc:	304040ef          	jal	5ad0 <unlink>
  close(fd1);
    17d0:	854e                	mv	a0,s3
    17d2:	2d6040ef          	jal	5aa8 <close>
  close(fd2);
    17d6:	8526                	mv	a0,s1
    17d8:	2d0040ef          	jal	5aa8 <close>
  close(fd3);
    17dc:	854a                	mv	a0,s2
    17de:	2ca040ef          	jal	5aa8 <close>
}
    17e2:	60e6                	ld	ra,88(sp)
    17e4:	6446                	ld	s0,80(sp)
    17e6:	64a6                	ld	s1,72(sp)
    17e8:	6906                	ld	s2,64(sp)
    17ea:	79e2                	ld	s3,56(sp)
    17ec:	7a42                	ld	s4,48(sp)
    17ee:	7aa2                	ld	s5,40(sp)
    17f0:	6125                	addi	sp,sp,96
    17f2:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
    17f4:	862a                	mv	a2,a0
    17f6:	85d6                	mv	a1,s5
    17f8:	00006517          	auipc	a0,0x6
    17fc:	ab050513          	addi	a0,a0,-1360 # 72a8 <malloc+0x1314>
    1800:	6e0040ef          	jal	5ee0 <printf>
    exit(1);
    1804:	4505                	li	a0,1
    1806:	27a040ef          	jal	5a80 <exit>
    printf("aaa fd3=%d\n", fd3);
    180a:	85ca                	mv	a1,s2
    180c:	00006517          	auipc	a0,0x6
    1810:	abc50513          	addi	a0,a0,-1348 # 72c8 <malloc+0x1334>
    1814:	6cc040ef          	jal	5ee0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
    1818:	8652                	mv	a2,s4
    181a:	85d6                	mv	a1,s5
    181c:	00006517          	auipc	a0,0x6
    1820:	abc50513          	addi	a0,a0,-1348 # 72d8 <malloc+0x1344>
    1824:	6bc040ef          	jal	5ee0 <printf>
    exit(1);
    1828:	4505                	li	a0,1
    182a:	256040ef          	jal	5a80 <exit>
    printf("bbb fd2=%d\n", fd2);
    182e:	85a6                	mv	a1,s1
    1830:	00006517          	auipc	a0,0x6
    1834:	ac850513          	addi	a0,a0,-1336 # 72f8 <malloc+0x1364>
    1838:	6a8040ef          	jal	5ee0 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
    183c:	8652                	mv	a2,s4
    183e:	85d6                	mv	a1,s5
    1840:	00006517          	auipc	a0,0x6
    1844:	a9850513          	addi	a0,a0,-1384 # 72d8 <malloc+0x1344>
    1848:	698040ef          	jal	5ee0 <printf>
    exit(1);
    184c:	4505                	li	a0,1
    184e:	232040ef          	jal	5a80 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
    1852:	862a                	mv	a2,a0
    1854:	85d6                	mv	a1,s5
    1856:	00006517          	auipc	a0,0x6
    185a:	aba50513          	addi	a0,a0,-1350 # 7310 <malloc+0x137c>
    185e:	682040ef          	jal	5ee0 <printf>
    exit(1);
    1862:	4505                	li	a0,1
    1864:	21c040ef          	jal	5a80 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
    1868:	862a                	mv	a2,a0
    186a:	85d6                	mv	a1,s5
    186c:	00006517          	auipc	a0,0x6
    1870:	ac450513          	addi	a0,a0,-1340 # 7330 <malloc+0x139c>
    1874:	66c040ef          	jal	5ee0 <printf>
    exit(1);
    1878:	4505                	li	a0,1
    187a:	206040ef          	jal	5a80 <exit>

000000000000187e <writetest>:
{
    187e:	7139                	addi	sp,sp,-64
    1880:	fc06                	sd	ra,56(sp)
    1882:	f822                	sd	s0,48(sp)
    1884:	f426                	sd	s1,40(sp)
    1886:	f04a                	sd	s2,32(sp)
    1888:	ec4e                	sd	s3,24(sp)
    188a:	e852                	sd	s4,16(sp)
    188c:	e456                	sd	s5,8(sp)
    188e:	e05a                	sd	s6,0(sp)
    1890:	0080                	addi	s0,sp,64
    1892:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
    1894:	20200593          	li	a1,514
    1898:	00006517          	auipc	a0,0x6
    189c:	ab850513          	addi	a0,a0,-1352 # 7350 <malloc+0x13bc>
    18a0:	220040ef          	jal	5ac0 <open>
  if(fd < 0){
    18a4:	08054f63          	bltz	a0,1942 <writetest+0xc4>
    18a8:	892a                	mv	s2,a0
    18aa:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    18ac:	00006997          	auipc	s3,0x6
    18b0:	acc98993          	addi	s3,s3,-1332 # 7378 <malloc+0x13e4>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    18b4:	00006a97          	auipc	s5,0x6
    18b8:	afca8a93          	addi	s5,s5,-1284 # 73b0 <malloc+0x141c>
  for(i = 0; i < N; i++){
    18bc:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
    18c0:	4629                	li	a2,10
    18c2:	85ce                	mv	a1,s3
    18c4:	854a                	mv	a0,s2
    18c6:	1da040ef          	jal	5aa0 <write>
    18ca:	47a9                	li	a5,10
    18cc:	08f51563          	bne	a0,a5,1956 <writetest+0xd8>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
    18d0:	4629                	li	a2,10
    18d2:	85d6                	mv	a1,s5
    18d4:	854a                	mv	a0,s2
    18d6:	1ca040ef          	jal	5aa0 <write>
    18da:	47a9                	li	a5,10
    18dc:	08f51863          	bne	a0,a5,196c <writetest+0xee>
  for(i = 0; i < N; i++){
    18e0:	2485                	addiw	s1,s1,1
    18e2:	fd449fe3          	bne	s1,s4,18c0 <writetest+0x42>
  close(fd);
    18e6:	854a                	mv	a0,s2
    18e8:	1c0040ef          	jal	5aa8 <close>
  fd = open("small", O_RDONLY);
    18ec:	4581                	li	a1,0
    18ee:	00006517          	auipc	a0,0x6
    18f2:	a6250513          	addi	a0,a0,-1438 # 7350 <malloc+0x13bc>
    18f6:	1ca040ef          	jal	5ac0 <open>
    18fa:	84aa                	mv	s1,a0
  if(fd < 0){
    18fc:	08054363          	bltz	a0,1982 <writetest+0x104>
  i = read(fd, buf, N*SZ*2);
    1900:	7d000613          	li	a2,2000
    1904:	0000b597          	auipc	a1,0xb
    1908:	7a458593          	addi	a1,a1,1956 # d0a8 <buf>
    190c:	18c040ef          	jal	5a98 <read>
  if(i != N*SZ*2){
    1910:	7d000793          	li	a5,2000
    1914:	08f51163          	bne	a0,a5,1996 <writetest+0x118>
  close(fd);
    1918:	8526                	mv	a0,s1
    191a:	18e040ef          	jal	5aa8 <close>
  if(unlink("small") < 0){
    191e:	00006517          	auipc	a0,0x6
    1922:	a3250513          	addi	a0,a0,-1486 # 7350 <malloc+0x13bc>
    1926:	1aa040ef          	jal	5ad0 <unlink>
    192a:	08054063          	bltz	a0,19aa <writetest+0x12c>
}
    192e:	70e2                	ld	ra,56(sp)
    1930:	7442                	ld	s0,48(sp)
    1932:	74a2                	ld	s1,40(sp)
    1934:	7902                	ld	s2,32(sp)
    1936:	69e2                	ld	s3,24(sp)
    1938:	6a42                	ld	s4,16(sp)
    193a:	6aa2                	ld	s5,8(sp)
    193c:	6b02                	ld	s6,0(sp)
    193e:	6121                	addi	sp,sp,64
    1940:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    1942:	85da                	mv	a1,s6
    1944:	00006517          	auipc	a0,0x6
    1948:	a1450513          	addi	a0,a0,-1516 # 7358 <malloc+0x13c4>
    194c:	594040ef          	jal	5ee0 <printf>
    exit(1);
    1950:	4505                	li	a0,1
    1952:	12e040ef          	jal	5a80 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
    1956:	8626                	mv	a2,s1
    1958:	85da                	mv	a1,s6
    195a:	00006517          	auipc	a0,0x6
    195e:	a2e50513          	addi	a0,a0,-1490 # 7388 <malloc+0x13f4>
    1962:	57e040ef          	jal	5ee0 <printf>
      exit(1);
    1966:	4505                	li	a0,1
    1968:	118040ef          	jal	5a80 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
    196c:	8626                	mv	a2,s1
    196e:	85da                	mv	a1,s6
    1970:	00006517          	auipc	a0,0x6
    1974:	a5050513          	addi	a0,a0,-1456 # 73c0 <malloc+0x142c>
    1978:	568040ef          	jal	5ee0 <printf>
      exit(1);
    197c:	4505                	li	a0,1
    197e:	102040ef          	jal	5a80 <exit>
    printf("%s: error: open small failed!\n", s);
    1982:	85da                	mv	a1,s6
    1984:	00006517          	auipc	a0,0x6
    1988:	a6450513          	addi	a0,a0,-1436 # 73e8 <malloc+0x1454>
    198c:	554040ef          	jal	5ee0 <printf>
    exit(1);
    1990:	4505                	li	a0,1
    1992:	0ee040ef          	jal	5a80 <exit>
    printf("%s: read failed\n", s);
    1996:	85da                	mv	a1,s6
    1998:	00006517          	auipc	a0,0x6
    199c:	a7050513          	addi	a0,a0,-1424 # 7408 <malloc+0x1474>
    19a0:	540040ef          	jal	5ee0 <printf>
    exit(1);
    19a4:	4505                	li	a0,1
    19a6:	0da040ef          	jal	5a80 <exit>
    printf("%s: unlink small failed\n", s);
    19aa:	85da                	mv	a1,s6
    19ac:	00006517          	auipc	a0,0x6
    19b0:	a7450513          	addi	a0,a0,-1420 # 7420 <malloc+0x148c>
    19b4:	52c040ef          	jal	5ee0 <printf>
    exit(1);
    19b8:	4505                	li	a0,1
    19ba:	0c6040ef          	jal	5a80 <exit>

00000000000019be <writebig>:
{
    19be:	7139                	addi	sp,sp,-64
    19c0:	fc06                	sd	ra,56(sp)
    19c2:	f822                	sd	s0,48(sp)
    19c4:	f426                	sd	s1,40(sp)
    19c6:	f04a                	sd	s2,32(sp)
    19c8:	ec4e                	sd	s3,24(sp)
    19ca:	e852                	sd	s4,16(sp)
    19cc:	e456                	sd	s5,8(sp)
    19ce:	0080                	addi	s0,sp,64
    19d0:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    19d2:	20200593          	li	a1,514
    19d6:	00006517          	auipc	a0,0x6
    19da:	a6a50513          	addi	a0,a0,-1430 # 7440 <malloc+0x14ac>
    19de:	0e2040ef          	jal	5ac0 <open>
    19e2:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    19e4:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    19e6:	0000b917          	auipc	s2,0xb
    19ea:	6c290913          	addi	s2,s2,1730 # d0a8 <buf>
  for(i = 0; i < MAXFILE; i++){
    19ee:	10c00a13          	li	s4,268
  if(fd < 0){
    19f2:	06054463          	bltz	a0,1a5a <writebig+0x9c>
    ((int*)buf)[0] = i;
    19f6:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    19fa:	40000613          	li	a2,1024
    19fe:	85ca                	mv	a1,s2
    1a00:	854e                	mv	a0,s3
    1a02:	09e040ef          	jal	5aa0 <write>
    1a06:	40000793          	li	a5,1024
    1a0a:	06f51263          	bne	a0,a5,1a6e <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
    1a0e:	2485                	addiw	s1,s1,1
    1a10:	ff4493e3          	bne	s1,s4,19f6 <writebig+0x38>
  close(fd);
    1a14:	854e                	mv	a0,s3
    1a16:	092040ef          	jal	5aa8 <close>
  fd = open("big", O_RDONLY);
    1a1a:	4581                	li	a1,0
    1a1c:	00006517          	auipc	a0,0x6
    1a20:	a2450513          	addi	a0,a0,-1500 # 7440 <malloc+0x14ac>
    1a24:	09c040ef          	jal	5ac0 <open>
    1a28:	89aa                	mv	s3,a0
  n = 0;
    1a2a:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    1a2c:	0000b917          	auipc	s2,0xb
    1a30:	67c90913          	addi	s2,s2,1660 # d0a8 <buf>
  if(fd < 0){
    1a34:	04054863          	bltz	a0,1a84 <writebig+0xc6>
    i = read(fd, buf, BSIZE);
    1a38:	40000613          	li	a2,1024
    1a3c:	85ca                	mv	a1,s2
    1a3e:	854e                	mv	a0,s3
    1a40:	058040ef          	jal	5a98 <read>
    if(i == 0){
    1a44:	c931                	beqz	a0,1a98 <writebig+0xda>
    } else if(i != BSIZE){
    1a46:	40000793          	li	a5,1024
    1a4a:	08f51a63          	bne	a0,a5,1ade <writebig+0x120>
    if(((int*)buf)[0] != n){
    1a4e:	00092683          	lw	a3,0(s2)
    1a52:	0a969163          	bne	a3,s1,1af4 <writebig+0x136>
    n++;
    1a56:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    1a58:	b7c5                	j	1a38 <writebig+0x7a>
    printf("%s: error: creat big failed!\n", s);
    1a5a:	85d6                	mv	a1,s5
    1a5c:	00006517          	auipc	a0,0x6
    1a60:	9ec50513          	addi	a0,a0,-1556 # 7448 <malloc+0x14b4>
    1a64:	47c040ef          	jal	5ee0 <printf>
    exit(1);
    1a68:	4505                	li	a0,1
    1a6a:	016040ef          	jal	5a80 <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
    1a6e:	8626                	mv	a2,s1
    1a70:	85d6                	mv	a1,s5
    1a72:	00006517          	auipc	a0,0x6
    1a76:	9f650513          	addi	a0,a0,-1546 # 7468 <malloc+0x14d4>
    1a7a:	466040ef          	jal	5ee0 <printf>
      exit(1);
    1a7e:	4505                	li	a0,1
    1a80:	000040ef          	jal	5a80 <exit>
    printf("%s: error: open big failed!\n", s);
    1a84:	85d6                	mv	a1,s5
    1a86:	00006517          	auipc	a0,0x6
    1a8a:	a0a50513          	addi	a0,a0,-1526 # 7490 <malloc+0x14fc>
    1a8e:	452040ef          	jal	5ee0 <printf>
    exit(1);
    1a92:	4505                	li	a0,1
    1a94:	7ed030ef          	jal	5a80 <exit>
      if(n != MAXFILE){
    1a98:	10c00793          	li	a5,268
    1a9c:	02f49663          	bne	s1,a5,1ac8 <writebig+0x10a>
  close(fd);
    1aa0:	854e                	mv	a0,s3
    1aa2:	006040ef          	jal	5aa8 <close>
  if(unlink("big") < 0){
    1aa6:	00006517          	auipc	a0,0x6
    1aaa:	99a50513          	addi	a0,a0,-1638 # 7440 <malloc+0x14ac>
    1aae:	022040ef          	jal	5ad0 <unlink>
    1ab2:	04054c63          	bltz	a0,1b0a <writebig+0x14c>
}
    1ab6:	70e2                	ld	ra,56(sp)
    1ab8:	7442                	ld	s0,48(sp)
    1aba:	74a2                	ld	s1,40(sp)
    1abc:	7902                	ld	s2,32(sp)
    1abe:	69e2                	ld	s3,24(sp)
    1ac0:	6a42                	ld	s4,16(sp)
    1ac2:	6aa2                	ld	s5,8(sp)
    1ac4:	6121                	addi	sp,sp,64
    1ac6:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
    1ac8:	8626                	mv	a2,s1
    1aca:	85d6                	mv	a1,s5
    1acc:	00006517          	auipc	a0,0x6
    1ad0:	9e450513          	addi	a0,a0,-1564 # 74b0 <malloc+0x151c>
    1ad4:	40c040ef          	jal	5ee0 <printf>
        exit(1);
    1ad8:	4505                	li	a0,1
    1ada:	7a7030ef          	jal	5a80 <exit>
      printf("%s: read failed %d\n", s, i);
    1ade:	862a                	mv	a2,a0
    1ae0:	85d6                	mv	a1,s5
    1ae2:	00006517          	auipc	a0,0x6
    1ae6:	9f650513          	addi	a0,a0,-1546 # 74d8 <malloc+0x1544>
    1aea:	3f6040ef          	jal	5ee0 <printf>
      exit(1);
    1aee:	4505                	li	a0,1
    1af0:	791030ef          	jal	5a80 <exit>
      printf("%s: read content of block %d is %d\n", s,
    1af4:	8626                	mv	a2,s1
    1af6:	85d6                	mv	a1,s5
    1af8:	00006517          	auipc	a0,0x6
    1afc:	9f850513          	addi	a0,a0,-1544 # 74f0 <malloc+0x155c>
    1b00:	3e0040ef          	jal	5ee0 <printf>
      exit(1);
    1b04:	4505                	li	a0,1
    1b06:	77b030ef          	jal	5a80 <exit>
    printf("%s: unlink big failed\n", s);
    1b0a:	85d6                	mv	a1,s5
    1b0c:	00006517          	auipc	a0,0x6
    1b10:	a0c50513          	addi	a0,a0,-1524 # 7518 <malloc+0x1584>
    1b14:	3cc040ef          	jal	5ee0 <printf>
    exit(1);
    1b18:	4505                	li	a0,1
    1b1a:	767030ef          	jal	5a80 <exit>

0000000000001b1e <unlinkread>:
{
    1b1e:	7179                	addi	sp,sp,-48
    1b20:	f406                	sd	ra,40(sp)
    1b22:	f022                	sd	s0,32(sp)
    1b24:	ec26                	sd	s1,24(sp)
    1b26:	e84a                	sd	s2,16(sp)
    1b28:	e44e                	sd	s3,8(sp)
    1b2a:	1800                	addi	s0,sp,48
    1b2c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    1b2e:	20200593          	li	a1,514
    1b32:	00006517          	auipc	a0,0x6
    1b36:	9fe50513          	addi	a0,a0,-1538 # 7530 <malloc+0x159c>
    1b3a:	787030ef          	jal	5ac0 <open>
  if(fd < 0){
    1b3e:	0a054f63          	bltz	a0,1bfc <unlinkread+0xde>
    1b42:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    1b44:	4615                	li	a2,5
    1b46:	00006597          	auipc	a1,0x6
    1b4a:	a1a58593          	addi	a1,a1,-1510 # 7560 <malloc+0x15cc>
    1b4e:	753030ef          	jal	5aa0 <write>
  close(fd);
    1b52:	8526                	mv	a0,s1
    1b54:	755030ef          	jal	5aa8 <close>
  fd = open("unlinkread", O_RDWR);
    1b58:	4589                	li	a1,2
    1b5a:	00006517          	auipc	a0,0x6
    1b5e:	9d650513          	addi	a0,a0,-1578 # 7530 <malloc+0x159c>
    1b62:	75f030ef          	jal	5ac0 <open>
    1b66:	84aa                	mv	s1,a0
  if(fd < 0){
    1b68:	0a054463          	bltz	a0,1c10 <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
    1b6c:	00006517          	auipc	a0,0x6
    1b70:	9c450513          	addi	a0,a0,-1596 # 7530 <malloc+0x159c>
    1b74:	75d030ef          	jal	5ad0 <unlink>
    1b78:	e555                	bnez	a0,1c24 <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    1b7a:	20200593          	li	a1,514
    1b7e:	00006517          	auipc	a0,0x6
    1b82:	9b250513          	addi	a0,a0,-1614 # 7530 <malloc+0x159c>
    1b86:	73b030ef          	jal	5ac0 <open>
    1b8a:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1b8c:	460d                	li	a2,3
    1b8e:	00006597          	auipc	a1,0x6
    1b92:	a1a58593          	addi	a1,a1,-1510 # 75a8 <malloc+0x1614>
    1b96:	70b030ef          	jal	5aa0 <write>
  close(fd1);
    1b9a:	854a                	mv	a0,s2
    1b9c:	70d030ef          	jal	5aa8 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1ba0:	660d                	lui	a2,0x3
    1ba2:	0000b597          	auipc	a1,0xb
    1ba6:	50658593          	addi	a1,a1,1286 # d0a8 <buf>
    1baa:	8526                	mv	a0,s1
    1bac:	6ed030ef          	jal	5a98 <read>
    1bb0:	4795                	li	a5,5
    1bb2:	08f51363          	bne	a0,a5,1c38 <unlinkread+0x11a>
  if(buf[0] != 'h'){
    1bb6:	0000b717          	auipc	a4,0xb
    1bba:	4f274703          	lbu	a4,1266(a4) # d0a8 <buf>
    1bbe:	06800793          	li	a5,104
    1bc2:	08f71563          	bne	a4,a5,1c4c <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
    1bc6:	4629                	li	a2,10
    1bc8:	0000b597          	auipc	a1,0xb
    1bcc:	4e058593          	addi	a1,a1,1248 # d0a8 <buf>
    1bd0:	8526                	mv	a0,s1
    1bd2:	6cf030ef          	jal	5aa0 <write>
    1bd6:	47a9                	li	a5,10
    1bd8:	08f51463          	bne	a0,a5,1c60 <unlinkread+0x142>
  close(fd);
    1bdc:	8526                	mv	a0,s1
    1bde:	6cb030ef          	jal	5aa8 <close>
  unlink("unlinkread");
    1be2:	00006517          	auipc	a0,0x6
    1be6:	94e50513          	addi	a0,a0,-1714 # 7530 <malloc+0x159c>
    1bea:	6e7030ef          	jal	5ad0 <unlink>
}
    1bee:	70a2                	ld	ra,40(sp)
    1bf0:	7402                	ld	s0,32(sp)
    1bf2:	64e2                	ld	s1,24(sp)
    1bf4:	6942                	ld	s2,16(sp)
    1bf6:	69a2                	ld	s3,8(sp)
    1bf8:	6145                	addi	sp,sp,48
    1bfa:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    1bfc:	85ce                	mv	a1,s3
    1bfe:	00006517          	auipc	a0,0x6
    1c02:	94250513          	addi	a0,a0,-1726 # 7540 <malloc+0x15ac>
    1c06:	2da040ef          	jal	5ee0 <printf>
    exit(1);
    1c0a:	4505                	li	a0,1
    1c0c:	675030ef          	jal	5a80 <exit>
    printf("%s: open unlinkread failed\n", s);
    1c10:	85ce                	mv	a1,s3
    1c12:	00006517          	auipc	a0,0x6
    1c16:	95650513          	addi	a0,a0,-1706 # 7568 <malloc+0x15d4>
    1c1a:	2c6040ef          	jal	5ee0 <printf>
    exit(1);
    1c1e:	4505                	li	a0,1
    1c20:	661030ef          	jal	5a80 <exit>
    printf("%s: unlink unlinkread failed\n", s);
    1c24:	85ce                	mv	a1,s3
    1c26:	00006517          	auipc	a0,0x6
    1c2a:	96250513          	addi	a0,a0,-1694 # 7588 <malloc+0x15f4>
    1c2e:	2b2040ef          	jal	5ee0 <printf>
    exit(1);
    1c32:	4505                	li	a0,1
    1c34:	64d030ef          	jal	5a80 <exit>
    printf("%s: unlinkread read failed", s);
    1c38:	85ce                	mv	a1,s3
    1c3a:	00006517          	auipc	a0,0x6
    1c3e:	97650513          	addi	a0,a0,-1674 # 75b0 <malloc+0x161c>
    1c42:	29e040ef          	jal	5ee0 <printf>
    exit(1);
    1c46:	4505                	li	a0,1
    1c48:	639030ef          	jal	5a80 <exit>
    printf("%s: unlinkread wrong data\n", s);
    1c4c:	85ce                	mv	a1,s3
    1c4e:	00006517          	auipc	a0,0x6
    1c52:	98250513          	addi	a0,a0,-1662 # 75d0 <malloc+0x163c>
    1c56:	28a040ef          	jal	5ee0 <printf>
    exit(1);
    1c5a:	4505                	li	a0,1
    1c5c:	625030ef          	jal	5a80 <exit>
    printf("%s: unlinkread write failed\n", s);
    1c60:	85ce                	mv	a1,s3
    1c62:	00006517          	auipc	a0,0x6
    1c66:	98e50513          	addi	a0,a0,-1650 # 75f0 <malloc+0x165c>
    1c6a:	276040ef          	jal	5ee0 <printf>
    exit(1);
    1c6e:	4505                	li	a0,1
    1c70:	611030ef          	jal	5a80 <exit>

0000000000001c74 <linktest>:
{
    1c74:	1101                	addi	sp,sp,-32
    1c76:	ec06                	sd	ra,24(sp)
    1c78:	e822                	sd	s0,16(sp)
    1c7a:	e426                	sd	s1,8(sp)
    1c7c:	e04a                	sd	s2,0(sp)
    1c7e:	1000                	addi	s0,sp,32
    1c80:	892a                	mv	s2,a0
  unlink("lf1");
    1c82:	00006517          	auipc	a0,0x6
    1c86:	98e50513          	addi	a0,a0,-1650 # 7610 <malloc+0x167c>
    1c8a:	647030ef          	jal	5ad0 <unlink>
  unlink("lf2");
    1c8e:	00006517          	auipc	a0,0x6
    1c92:	98a50513          	addi	a0,a0,-1654 # 7618 <malloc+0x1684>
    1c96:	63b030ef          	jal	5ad0 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    1c9a:	20200593          	li	a1,514
    1c9e:	00006517          	auipc	a0,0x6
    1ca2:	97250513          	addi	a0,a0,-1678 # 7610 <malloc+0x167c>
    1ca6:	61b030ef          	jal	5ac0 <open>
  if(fd < 0){
    1caa:	0c054f63          	bltz	a0,1d88 <linktest+0x114>
    1cae:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    1cb0:	4615                	li	a2,5
    1cb2:	00006597          	auipc	a1,0x6
    1cb6:	8ae58593          	addi	a1,a1,-1874 # 7560 <malloc+0x15cc>
    1cba:	5e7030ef          	jal	5aa0 <write>
    1cbe:	4795                	li	a5,5
    1cc0:	0cf51e63          	bne	a0,a5,1d9c <linktest+0x128>
  close(fd);
    1cc4:	8526                	mv	a0,s1
    1cc6:	5e3030ef          	jal	5aa8 <close>
  if(link("lf1", "lf2") < 0){
    1cca:	00006597          	auipc	a1,0x6
    1cce:	94e58593          	addi	a1,a1,-1714 # 7618 <malloc+0x1684>
    1cd2:	00006517          	auipc	a0,0x6
    1cd6:	93e50513          	addi	a0,a0,-1730 # 7610 <malloc+0x167c>
    1cda:	607030ef          	jal	5ae0 <link>
    1cde:	0c054963          	bltz	a0,1db0 <linktest+0x13c>
  unlink("lf1");
    1ce2:	00006517          	auipc	a0,0x6
    1ce6:	92e50513          	addi	a0,a0,-1746 # 7610 <malloc+0x167c>
    1cea:	5e7030ef          	jal	5ad0 <unlink>
  if(open("lf1", 0) >= 0){
    1cee:	4581                	li	a1,0
    1cf0:	00006517          	auipc	a0,0x6
    1cf4:	92050513          	addi	a0,a0,-1760 # 7610 <malloc+0x167c>
    1cf8:	5c9030ef          	jal	5ac0 <open>
    1cfc:	0c055463          	bgez	a0,1dc4 <linktest+0x150>
  fd = open("lf2", 0);
    1d00:	4581                	li	a1,0
    1d02:	00006517          	auipc	a0,0x6
    1d06:	91650513          	addi	a0,a0,-1770 # 7618 <malloc+0x1684>
    1d0a:	5b7030ef          	jal	5ac0 <open>
    1d0e:	84aa                	mv	s1,a0
  if(fd < 0){
    1d10:	0c054463          	bltz	a0,1dd8 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
    1d14:	660d                	lui	a2,0x3
    1d16:	0000b597          	auipc	a1,0xb
    1d1a:	39258593          	addi	a1,a1,914 # d0a8 <buf>
    1d1e:	57b030ef          	jal	5a98 <read>
    1d22:	4795                	li	a5,5
    1d24:	0cf51463          	bne	a0,a5,1dec <linktest+0x178>
  close(fd);
    1d28:	8526                	mv	a0,s1
    1d2a:	57f030ef          	jal	5aa8 <close>
  if(link("lf2", "lf2") >= 0){
    1d2e:	00006597          	auipc	a1,0x6
    1d32:	8ea58593          	addi	a1,a1,-1814 # 7618 <malloc+0x1684>
    1d36:	852e                	mv	a0,a1
    1d38:	5a9030ef          	jal	5ae0 <link>
    1d3c:	0c055263          	bgez	a0,1e00 <linktest+0x18c>
  unlink("lf2");
    1d40:	00006517          	auipc	a0,0x6
    1d44:	8d850513          	addi	a0,a0,-1832 # 7618 <malloc+0x1684>
    1d48:	589030ef          	jal	5ad0 <unlink>
  if(link("lf2", "lf1") >= 0){
    1d4c:	00006597          	auipc	a1,0x6
    1d50:	8c458593          	addi	a1,a1,-1852 # 7610 <malloc+0x167c>
    1d54:	00006517          	auipc	a0,0x6
    1d58:	8c450513          	addi	a0,a0,-1852 # 7618 <malloc+0x1684>
    1d5c:	585030ef          	jal	5ae0 <link>
    1d60:	0a055a63          	bgez	a0,1e14 <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
    1d64:	00006597          	auipc	a1,0x6
    1d68:	8ac58593          	addi	a1,a1,-1876 # 7610 <malloc+0x167c>
    1d6c:	00006517          	auipc	a0,0x6
    1d70:	9b450513          	addi	a0,a0,-1612 # 7720 <malloc+0x178c>
    1d74:	56d030ef          	jal	5ae0 <link>
    1d78:	0a055863          	bgez	a0,1e28 <linktest+0x1b4>
}
    1d7c:	60e2                	ld	ra,24(sp)
    1d7e:	6442                	ld	s0,16(sp)
    1d80:	64a2                	ld	s1,8(sp)
    1d82:	6902                	ld	s2,0(sp)
    1d84:	6105                	addi	sp,sp,32
    1d86:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1d88:	85ca                	mv	a1,s2
    1d8a:	00006517          	auipc	a0,0x6
    1d8e:	89650513          	addi	a0,a0,-1898 # 7620 <malloc+0x168c>
    1d92:	14e040ef          	jal	5ee0 <printf>
    exit(1);
    1d96:	4505                	li	a0,1
    1d98:	4e9030ef          	jal	5a80 <exit>
    printf("%s: write lf1 failed\n", s);
    1d9c:	85ca                	mv	a1,s2
    1d9e:	00006517          	auipc	a0,0x6
    1da2:	89a50513          	addi	a0,a0,-1894 # 7638 <malloc+0x16a4>
    1da6:	13a040ef          	jal	5ee0 <printf>
    exit(1);
    1daa:	4505                	li	a0,1
    1dac:	4d5030ef          	jal	5a80 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    1db0:	85ca                	mv	a1,s2
    1db2:	00006517          	auipc	a0,0x6
    1db6:	89e50513          	addi	a0,a0,-1890 # 7650 <malloc+0x16bc>
    1dba:	126040ef          	jal	5ee0 <printf>
    exit(1);
    1dbe:	4505                	li	a0,1
    1dc0:	4c1030ef          	jal	5a80 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1dc4:	85ca                	mv	a1,s2
    1dc6:	00006517          	auipc	a0,0x6
    1dca:	8aa50513          	addi	a0,a0,-1878 # 7670 <malloc+0x16dc>
    1dce:	112040ef          	jal	5ee0 <printf>
    exit(1);
    1dd2:	4505                	li	a0,1
    1dd4:	4ad030ef          	jal	5a80 <exit>
    printf("%s: open lf2 failed\n", s);
    1dd8:	85ca                	mv	a1,s2
    1dda:	00006517          	auipc	a0,0x6
    1dde:	8c650513          	addi	a0,a0,-1850 # 76a0 <malloc+0x170c>
    1de2:	0fe040ef          	jal	5ee0 <printf>
    exit(1);
    1de6:	4505                	li	a0,1
    1de8:	499030ef          	jal	5a80 <exit>
    printf("%s: read lf2 failed\n", s);
    1dec:	85ca                	mv	a1,s2
    1dee:	00006517          	auipc	a0,0x6
    1df2:	8ca50513          	addi	a0,a0,-1846 # 76b8 <malloc+0x1724>
    1df6:	0ea040ef          	jal	5ee0 <printf>
    exit(1);
    1dfa:	4505                	li	a0,1
    1dfc:	485030ef          	jal	5a80 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    1e00:	85ca                	mv	a1,s2
    1e02:	00006517          	auipc	a0,0x6
    1e06:	8ce50513          	addi	a0,a0,-1842 # 76d0 <malloc+0x173c>
    1e0a:	0d6040ef          	jal	5ee0 <printf>
    exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	471030ef          	jal	5a80 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1e14:	85ca                	mv	a1,s2
    1e16:	00006517          	auipc	a0,0x6
    1e1a:	8e250513          	addi	a0,a0,-1822 # 76f8 <malloc+0x1764>
    1e1e:	0c2040ef          	jal	5ee0 <printf>
    exit(1);
    1e22:	4505                	li	a0,1
    1e24:	45d030ef          	jal	5a80 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1e28:	85ca                	mv	a1,s2
    1e2a:	00006517          	auipc	a0,0x6
    1e2e:	8fe50513          	addi	a0,a0,-1794 # 7728 <malloc+0x1794>
    1e32:	0ae040ef          	jal	5ee0 <printf>
    exit(1);
    1e36:	4505                	li	a0,1
    1e38:	449030ef          	jal	5a80 <exit>

0000000000001e3c <validatetest>:
{
    1e3c:	7139                	addi	sp,sp,-64
    1e3e:	fc06                	sd	ra,56(sp)
    1e40:	f822                	sd	s0,48(sp)
    1e42:	f426                	sd	s1,40(sp)
    1e44:	f04a                	sd	s2,32(sp)
    1e46:	ec4e                	sd	s3,24(sp)
    1e48:	e852                	sd	s4,16(sp)
    1e4a:	e456                	sd	s5,8(sp)
    1e4c:	e05a                	sd	s6,0(sp)
    1e4e:	0080                	addi	s0,sp,64
    1e50:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1e52:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1e54:	00006997          	auipc	s3,0x6
    1e58:	8f498993          	addi	s3,s3,-1804 # 7748 <malloc+0x17b4>
    1e5c:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1e5e:	6a85                	lui	s5,0x1
    1e60:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1e64:	85a6                	mv	a1,s1
    1e66:	854e                	mv	a0,s3
    1e68:	479030ef          	jal	5ae0 <link>
    1e6c:	01251f63          	bne	a0,s2,1e8a <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1e70:	94d6                	add	s1,s1,s5
    1e72:	ff4499e3          	bne	s1,s4,1e64 <validatetest+0x28>
}
    1e76:	70e2                	ld	ra,56(sp)
    1e78:	7442                	ld	s0,48(sp)
    1e7a:	74a2                	ld	s1,40(sp)
    1e7c:	7902                	ld	s2,32(sp)
    1e7e:	69e2                	ld	s3,24(sp)
    1e80:	6a42                	ld	s4,16(sp)
    1e82:	6aa2                	ld	s5,8(sp)
    1e84:	6b02                	ld	s6,0(sp)
    1e86:	6121                	addi	sp,sp,64
    1e88:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1e8a:	85da                	mv	a1,s6
    1e8c:	00006517          	auipc	a0,0x6
    1e90:	8cc50513          	addi	a0,a0,-1844 # 7758 <malloc+0x17c4>
    1e94:	04c040ef          	jal	5ee0 <printf>
      exit(1);
    1e98:	4505                	li	a0,1
    1e9a:	3e7030ef          	jal	5a80 <exit>

0000000000001e9e <bigdir>:
{
    1e9e:	715d                	addi	sp,sp,-80
    1ea0:	e486                	sd	ra,72(sp)
    1ea2:	e0a2                	sd	s0,64(sp)
    1ea4:	fc26                	sd	s1,56(sp)
    1ea6:	f84a                	sd	s2,48(sp)
    1ea8:	f44e                	sd	s3,40(sp)
    1eaa:	f052                	sd	s4,32(sp)
    1eac:	ec56                	sd	s5,24(sp)
    1eae:	e85a                	sd	s6,16(sp)
    1eb0:	0880                	addi	s0,sp,80
    1eb2:	89aa                	mv	s3,a0
  unlink("bd");
    1eb4:	00006517          	auipc	a0,0x6
    1eb8:	8c450513          	addi	a0,a0,-1852 # 7778 <malloc+0x17e4>
    1ebc:	415030ef          	jal	5ad0 <unlink>
  fd = open("bd", O_CREATE);
    1ec0:	20000593          	li	a1,512
    1ec4:	00006517          	auipc	a0,0x6
    1ec8:	8b450513          	addi	a0,a0,-1868 # 7778 <malloc+0x17e4>
    1ecc:	3f5030ef          	jal	5ac0 <open>
  if(fd < 0){
    1ed0:	0c054163          	bltz	a0,1f92 <bigdir+0xf4>
  close(fd);
    1ed4:	3d5030ef          	jal	5aa8 <close>
  for(i = 0; i < N; i++){
    1ed8:	4901                	li	s2,0
    name[0] = 'x';
    1eda:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    1ede:	00006a17          	auipc	s4,0x6
    1ee2:	89aa0a13          	addi	s4,s4,-1894 # 7778 <malloc+0x17e4>
  for(i = 0; i < N; i++){
    1ee6:	1f400b13          	li	s6,500
    name[0] = 'x';
    1eea:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    1eee:	41f9571b          	sraiw	a4,s2,0x1f
    1ef2:	01a7571b          	srliw	a4,a4,0x1a
    1ef6:	012707bb          	addw	a5,a4,s2
    1efa:	4067d69b          	sraiw	a3,a5,0x6
    1efe:	0306869b          	addiw	a3,a3,48
    1f02:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1f06:	03f7f793          	andi	a5,a5,63
    1f0a:	9f99                	subw	a5,a5,a4
    1f0c:	0307879b          	addiw	a5,a5,48
    1f10:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1f14:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1f18:	fb040593          	addi	a1,s0,-80
    1f1c:	8552                	mv	a0,s4
    1f1e:	3c3030ef          	jal	5ae0 <link>
    1f22:	84aa                	mv	s1,a0
    1f24:	e149                	bnez	a0,1fa6 <bigdir+0x108>
  for(i = 0; i < N; i++){
    1f26:	2905                	addiw	s2,s2,1
    1f28:	fd6911e3          	bne	s2,s6,1eea <bigdir+0x4c>
  unlink("bd");
    1f2c:	00006517          	auipc	a0,0x6
    1f30:	84c50513          	addi	a0,a0,-1972 # 7778 <malloc+0x17e4>
    1f34:	39d030ef          	jal	5ad0 <unlink>
    name[0] = 'x';
    1f38:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1f3c:	1f400a13          	li	s4,500
    name[0] = 'x';
    1f40:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1f44:	41f4d71b          	sraiw	a4,s1,0x1f
    1f48:	01a7571b          	srliw	a4,a4,0x1a
    1f4c:	009707bb          	addw	a5,a4,s1
    1f50:	4067d69b          	sraiw	a3,a5,0x6
    1f54:	0306869b          	addiw	a3,a3,48
    1f58:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1f5c:	03f7f793          	andi	a5,a5,63
    1f60:	9f99                	subw	a5,a5,a4
    1f62:	0307879b          	addiw	a5,a5,48
    1f66:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1f6a:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1f6e:	fb040513          	addi	a0,s0,-80
    1f72:	35f030ef          	jal	5ad0 <unlink>
    1f76:	e529                	bnez	a0,1fc0 <bigdir+0x122>
  for(i = 0; i < N; i++){
    1f78:	2485                	addiw	s1,s1,1
    1f7a:	fd4493e3          	bne	s1,s4,1f40 <bigdir+0xa2>
}
    1f7e:	60a6                	ld	ra,72(sp)
    1f80:	6406                	ld	s0,64(sp)
    1f82:	74e2                	ld	s1,56(sp)
    1f84:	7942                	ld	s2,48(sp)
    1f86:	79a2                	ld	s3,40(sp)
    1f88:	7a02                	ld	s4,32(sp)
    1f8a:	6ae2                	ld	s5,24(sp)
    1f8c:	6b42                	ld	s6,16(sp)
    1f8e:	6161                	addi	sp,sp,80
    1f90:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    1f92:	85ce                	mv	a1,s3
    1f94:	00005517          	auipc	a0,0x5
    1f98:	7ec50513          	addi	a0,a0,2028 # 7780 <malloc+0x17ec>
    1f9c:	745030ef          	jal	5ee0 <printf>
    exit(1);
    1fa0:	4505                	li	a0,1
    1fa2:	2df030ef          	jal	5a80 <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1fa6:	fb040693          	addi	a3,s0,-80
    1faa:	864a                	mv	a2,s2
    1fac:	85ce                	mv	a1,s3
    1fae:	00005517          	auipc	a0,0x5
    1fb2:	7f250513          	addi	a0,a0,2034 # 77a0 <malloc+0x180c>
    1fb6:	72b030ef          	jal	5ee0 <printf>
      exit(1);
    1fba:	4505                	li	a0,1
    1fbc:	2c5030ef          	jal	5a80 <exit>
      printf("%s: bigdir unlink failed", s);
    1fc0:	85ce                	mv	a1,s3
    1fc2:	00006517          	auipc	a0,0x6
    1fc6:	80650513          	addi	a0,a0,-2042 # 77c8 <malloc+0x1834>
    1fca:	717030ef          	jal	5ee0 <printf>
      exit(1);
    1fce:	4505                	li	a0,1
    1fd0:	2b1030ef          	jal	5a80 <exit>

0000000000001fd4 <pgbug>:
{
    1fd4:	7179                	addi	sp,sp,-48
    1fd6:	f406                	sd	ra,40(sp)
    1fd8:	f022                	sd	s0,32(sp)
    1fda:	ec26                	sd	s1,24(sp)
    1fdc:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1fde:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1fe2:	00007497          	auipc	s1,0x7
    1fe6:	44e48493          	addi	s1,s1,1102 # 9430 <big>
    1fea:	fd840593          	addi	a1,s0,-40
    1fee:	6088                	ld	a0,0(s1)
    1ff0:	2c9030ef          	jal	5ab8 <exec>
  pipe(big);
    1ff4:	6088                	ld	a0,0(s1)
    1ff6:	29b030ef          	jal	5a90 <pipe>
  exit(0);
    1ffa:	4501                	li	a0,0
    1ffc:	285030ef          	jal	5a80 <exit>

0000000000002000 <badarg>:
{
    2000:	7139                	addi	sp,sp,-64
    2002:	fc06                	sd	ra,56(sp)
    2004:	f822                	sd	s0,48(sp)
    2006:	f426                	sd	s1,40(sp)
    2008:	f04a                	sd	s2,32(sp)
    200a:	ec4e                	sd	s3,24(sp)
    200c:	0080                	addi	s0,sp,64
    200e:	64b1                	lui	s1,0xc
    2010:	35048493          	addi	s1,s1,848 # c350 <uninit+0x19b8>
    argv[0] = (char*)0xffffffff;
    2014:	597d                	li	s2,-1
    2016:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    201a:	00005997          	auipc	s3,0x5
    201e:	01e98993          	addi	s3,s3,30 # 7038 <malloc+0x10a4>
    argv[0] = (char*)0xffffffff;
    2022:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    2026:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    202a:	fc040593          	addi	a1,s0,-64
    202e:	854e                	mv	a0,s3
    2030:	289030ef          	jal	5ab8 <exec>
  for(int i = 0; i < 50000; i++){
    2034:	34fd                	addiw	s1,s1,-1
    2036:	f4f5                	bnez	s1,2022 <badarg+0x22>
  exit(0);
    2038:	4501                	li	a0,0
    203a:	247030ef          	jal	5a80 <exit>

000000000000203e <copyinstr2>:
{
    203e:	7155                	addi	sp,sp,-208
    2040:	e586                	sd	ra,200(sp)
    2042:	e1a2                	sd	s0,192(sp)
    2044:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    2046:	f6840793          	addi	a5,s0,-152
    204a:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    204e:	07800713          	li	a4,120
    2052:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    2056:	0785                	addi	a5,a5,1
    2058:	fed79de3          	bne	a5,a3,2052 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    205c:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    2060:	f6840513          	addi	a0,s0,-152
    2064:	26d030ef          	jal	5ad0 <unlink>
  if(ret != -1){
    2068:	57fd                	li	a5,-1
    206a:	0cf51263          	bne	a0,a5,212e <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    206e:	20100593          	li	a1,513
    2072:	f6840513          	addi	a0,s0,-152
    2076:	24b030ef          	jal	5ac0 <open>
  if(fd != -1){
    207a:	57fd                	li	a5,-1
    207c:	0cf51563          	bne	a0,a5,2146 <copyinstr2+0x108>
  ret = link(b, b);
    2080:	f6840593          	addi	a1,s0,-152
    2084:	852e                	mv	a0,a1
    2086:	25b030ef          	jal	5ae0 <link>
  if(ret != -1){
    208a:	57fd                	li	a5,-1
    208c:	0cf51963          	bne	a0,a5,215e <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    2090:	00007797          	auipc	a5,0x7
    2094:	88878793          	addi	a5,a5,-1912 # 8918 <malloc+0x2984>
    2098:	f4f43c23          	sd	a5,-168(s0)
    209c:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    20a0:	f5840593          	addi	a1,s0,-168
    20a4:	f6840513          	addi	a0,s0,-152
    20a8:	211030ef          	jal	5ab8 <exec>
  if(ret != -1){
    20ac:	57fd                	li	a5,-1
    20ae:	0cf51563          	bne	a0,a5,2178 <copyinstr2+0x13a>
  int pid = fork();
    20b2:	1c7030ef          	jal	5a78 <fork>
  if(pid < 0){
    20b6:	0c054d63          	bltz	a0,2190 <copyinstr2+0x152>
  if(pid == 0){
    20ba:	0e051863          	bnez	a0,21aa <copyinstr2+0x16c>
    20be:	00008797          	auipc	a5,0x8
    20c2:	8d278793          	addi	a5,a5,-1838 # 9990 <big.0>
    20c6:	00009697          	auipc	a3,0x9
    20ca:	8ca68693          	addi	a3,a3,-1846 # a990 <big.0+0x1000>
      big[i] = 'x';
    20ce:	07800713          	li	a4,120
    20d2:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    20d6:	0785                	addi	a5,a5,1
    20d8:	fed79de3          	bne	a5,a3,20d2 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    20dc:	00009797          	auipc	a5,0x9
    20e0:	8a078a23          	sb	zero,-1868(a5) # a990 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    20e4:	00007797          	auipc	a5,0x7
    20e8:	2b478793          	addi	a5,a5,692 # 9398 <malloc+0x3404>
    20ec:	6fb0                	ld	a2,88(a5)
    20ee:	73b4                	ld	a3,96(a5)
    20f0:	77b8                	ld	a4,104(a5)
    20f2:	7bbc                	ld	a5,112(a5)
    20f4:	f2c43823          	sd	a2,-208(s0)
    20f8:	f2d43c23          	sd	a3,-200(s0)
    20fc:	f4e43023          	sd	a4,-192(s0)
    2100:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    2104:	f3040593          	addi	a1,s0,-208
    2108:	00005517          	auipc	a0,0x5
    210c:	f3050513          	addi	a0,a0,-208 # 7038 <malloc+0x10a4>
    2110:	1a9030ef          	jal	5ab8 <exec>
    if(ret != -1){
    2114:	57fd                	li	a5,-1
    2116:	08f50663          	beq	a0,a5,21a2 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    211a:	55fd                	li	a1,-1
    211c:	00005517          	auipc	a0,0x5
    2120:	75450513          	addi	a0,a0,1876 # 7870 <malloc+0x18dc>
    2124:	5bd030ef          	jal	5ee0 <printf>
      exit(1);
    2128:	4505                	li	a0,1
    212a:	157030ef          	jal	5a80 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    212e:	862a                	mv	a2,a0
    2130:	f6840593          	addi	a1,s0,-152
    2134:	00005517          	auipc	a0,0x5
    2138:	6b450513          	addi	a0,a0,1716 # 77e8 <malloc+0x1854>
    213c:	5a5030ef          	jal	5ee0 <printf>
    exit(1);
    2140:	4505                	li	a0,1
    2142:	13f030ef          	jal	5a80 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2146:	862a                	mv	a2,a0
    2148:	f6840593          	addi	a1,s0,-152
    214c:	00005517          	auipc	a0,0x5
    2150:	6bc50513          	addi	a0,a0,1724 # 7808 <malloc+0x1874>
    2154:	58d030ef          	jal	5ee0 <printf>
    exit(1);
    2158:	4505                	li	a0,1
    215a:	127030ef          	jal	5a80 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    215e:	86aa                	mv	a3,a0
    2160:	f6840613          	addi	a2,s0,-152
    2164:	85b2                	mv	a1,a2
    2166:	00005517          	auipc	a0,0x5
    216a:	6c250513          	addi	a0,a0,1730 # 7828 <malloc+0x1894>
    216e:	573030ef          	jal	5ee0 <printf>
    exit(1);
    2172:	4505                	li	a0,1
    2174:	10d030ef          	jal	5a80 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2178:	567d                	li	a2,-1
    217a:	f6840593          	addi	a1,s0,-152
    217e:	00005517          	auipc	a0,0x5
    2182:	6d250513          	addi	a0,a0,1746 # 7850 <malloc+0x18bc>
    2186:	55b030ef          	jal	5ee0 <printf>
    exit(1);
    218a:	4505                	li	a0,1
    218c:	0f5030ef          	jal	5a80 <exit>
    printf("fork failed\n");
    2190:	00007517          	auipc	a0,0x7
    2194:	ca850513          	addi	a0,a0,-856 # 8e38 <malloc+0x2ea4>
    2198:	549030ef          	jal	5ee0 <printf>
    exit(1);
    219c:	4505                	li	a0,1
    219e:	0e3030ef          	jal	5a80 <exit>
    exit(747); // OK
    21a2:	2eb00513          	li	a0,747
    21a6:	0db030ef          	jal	5a80 <exit>
  int st = 0;
    21aa:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    21ae:	f5440513          	addi	a0,s0,-172
    21b2:	0d7030ef          	jal	5a88 <wait>
  if(st != 747){
    21b6:	f5442703          	lw	a4,-172(s0)
    21ba:	2eb00793          	li	a5,747
    21be:	00f71663          	bne	a4,a5,21ca <copyinstr2+0x18c>
}
    21c2:	60ae                	ld	ra,200(sp)
    21c4:	640e                	ld	s0,192(sp)
    21c6:	6169                	addi	sp,sp,208
    21c8:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    21ca:	00005517          	auipc	a0,0x5
    21ce:	6ce50513          	addi	a0,a0,1742 # 7898 <malloc+0x1904>
    21d2:	50f030ef          	jal	5ee0 <printf>
    exit(1);
    21d6:	4505                	li	a0,1
    21d8:	0a9030ef          	jal	5a80 <exit>

00000000000021dc <truncate3>:
{
    21dc:	7159                	addi	sp,sp,-112
    21de:	f486                	sd	ra,104(sp)
    21e0:	f0a2                	sd	s0,96(sp)
    21e2:	e8ca                	sd	s2,80(sp)
    21e4:	1880                	addi	s0,sp,112
    21e6:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    21e8:	60100593          	li	a1,1537
    21ec:	00005517          	auipc	a0,0x5
    21f0:	ea450513          	addi	a0,a0,-348 # 7090 <malloc+0x10fc>
    21f4:	0cd030ef          	jal	5ac0 <open>
    21f8:	0b1030ef          	jal	5aa8 <close>
  pid = fork();
    21fc:	07d030ef          	jal	5a78 <fork>
  if(pid < 0){
    2200:	06054663          	bltz	a0,226c <truncate3+0x90>
  if(pid == 0){
    2204:	e55d                	bnez	a0,22b2 <truncate3+0xd6>
    2206:	eca6                	sd	s1,88(sp)
    2208:	e4ce                	sd	s3,72(sp)
    220a:	e0d2                	sd	s4,64(sp)
    220c:	fc56                	sd	s5,56(sp)
    220e:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    2212:	00005a17          	auipc	s4,0x5
    2216:	e7ea0a13          	addi	s4,s4,-386 # 7090 <malloc+0x10fc>
      int n = write(fd, "1234567890", 10);
    221a:	00005a97          	auipc	s5,0x5
    221e:	6dea8a93          	addi	s5,s5,1758 # 78f8 <malloc+0x1964>
      int fd = open("truncfile", O_WRONLY);
    2222:	4585                	li	a1,1
    2224:	8552                	mv	a0,s4
    2226:	09b030ef          	jal	5ac0 <open>
    222a:	84aa                	mv	s1,a0
      if(fd < 0){
    222c:	04054e63          	bltz	a0,2288 <truncate3+0xac>
      int n = write(fd, "1234567890", 10);
    2230:	4629                	li	a2,10
    2232:	85d6                	mv	a1,s5
    2234:	06d030ef          	jal	5aa0 <write>
      if(n != 10){
    2238:	47a9                	li	a5,10
    223a:	06f51163          	bne	a0,a5,229c <truncate3+0xc0>
      close(fd);
    223e:	8526                	mv	a0,s1
    2240:	069030ef          	jal	5aa8 <close>
      fd = open("truncfile", O_RDONLY);
    2244:	4581                	li	a1,0
    2246:	8552                	mv	a0,s4
    2248:	079030ef          	jal	5ac0 <open>
    224c:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    224e:	02000613          	li	a2,32
    2252:	f9840593          	addi	a1,s0,-104
    2256:	043030ef          	jal	5a98 <read>
      close(fd);
    225a:	8526                	mv	a0,s1
    225c:	04d030ef          	jal	5aa8 <close>
    for(int i = 0; i < 100; i++){
    2260:	39fd                	addiw	s3,s3,-1
    2262:	fc0990e3          	bnez	s3,2222 <truncate3+0x46>
    exit(0);
    2266:	4501                	li	a0,0
    2268:	019030ef          	jal	5a80 <exit>
    226c:	eca6                	sd	s1,88(sp)
    226e:	e4ce                	sd	s3,72(sp)
    2270:	e0d2                	sd	s4,64(sp)
    2272:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    2274:	85ca                	mv	a1,s2
    2276:	00005517          	auipc	a0,0x5
    227a:	65250513          	addi	a0,a0,1618 # 78c8 <malloc+0x1934>
    227e:	463030ef          	jal	5ee0 <printf>
    exit(1);
    2282:	4505                	li	a0,1
    2284:	7fc030ef          	jal	5a80 <exit>
        printf("%s: open failed\n", s);
    2288:	85ca                	mv	a1,s2
    228a:	00005517          	auipc	a0,0x5
    228e:	65650513          	addi	a0,a0,1622 # 78e0 <malloc+0x194c>
    2292:	44f030ef          	jal	5ee0 <printf>
        exit(1);
    2296:	4505                	li	a0,1
    2298:	7e8030ef          	jal	5a80 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    229c:	862a                	mv	a2,a0
    229e:	85ca                	mv	a1,s2
    22a0:	00005517          	auipc	a0,0x5
    22a4:	66850513          	addi	a0,a0,1640 # 7908 <malloc+0x1974>
    22a8:	439030ef          	jal	5ee0 <printf>
        exit(1);
    22ac:	4505                	li	a0,1
    22ae:	7d2030ef          	jal	5a80 <exit>
    22b2:	eca6                	sd	s1,88(sp)
    22b4:	e4ce                	sd	s3,72(sp)
    22b6:	e0d2                	sd	s4,64(sp)
    22b8:	fc56                	sd	s5,56(sp)
    22ba:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    22be:	00005a17          	auipc	s4,0x5
    22c2:	dd2a0a13          	addi	s4,s4,-558 # 7090 <malloc+0x10fc>
    int n = write(fd, "xxx", 3);
    22c6:	00005a97          	auipc	s5,0x5
    22ca:	662a8a93          	addi	s5,s5,1634 # 7928 <malloc+0x1994>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    22ce:	60100593          	li	a1,1537
    22d2:	8552                	mv	a0,s4
    22d4:	7ec030ef          	jal	5ac0 <open>
    22d8:	84aa                	mv	s1,a0
    if(fd < 0){
    22da:	02054d63          	bltz	a0,2314 <truncate3+0x138>
    int n = write(fd, "xxx", 3);
    22de:	460d                	li	a2,3
    22e0:	85d6                	mv	a1,s5
    22e2:	7be030ef          	jal	5aa0 <write>
    if(n != 3){
    22e6:	478d                	li	a5,3
    22e8:	04f51063          	bne	a0,a5,2328 <truncate3+0x14c>
    close(fd);
    22ec:	8526                	mv	a0,s1
    22ee:	7ba030ef          	jal	5aa8 <close>
  for(int i = 0; i < 150; i++){
    22f2:	39fd                	addiw	s3,s3,-1
    22f4:	fc099de3          	bnez	s3,22ce <truncate3+0xf2>
  wait(&xstatus);
    22f8:	fbc40513          	addi	a0,s0,-68
    22fc:	78c030ef          	jal	5a88 <wait>
  unlink("truncfile");
    2300:	00005517          	auipc	a0,0x5
    2304:	d9050513          	addi	a0,a0,-624 # 7090 <malloc+0x10fc>
    2308:	7c8030ef          	jal	5ad0 <unlink>
  exit(xstatus);
    230c:	fbc42503          	lw	a0,-68(s0)
    2310:	770030ef          	jal	5a80 <exit>
      printf("%s: open failed\n", s);
    2314:	85ca                	mv	a1,s2
    2316:	00005517          	auipc	a0,0x5
    231a:	5ca50513          	addi	a0,a0,1482 # 78e0 <malloc+0x194c>
    231e:	3c3030ef          	jal	5ee0 <printf>
      exit(1);
    2322:	4505                	li	a0,1
    2324:	75c030ef          	jal	5a80 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    2328:	862a                	mv	a2,a0
    232a:	85ca                	mv	a1,s2
    232c:	00005517          	auipc	a0,0x5
    2330:	60450513          	addi	a0,a0,1540 # 7930 <malloc+0x199c>
    2334:	3ad030ef          	jal	5ee0 <printf>
      exit(1);
    2338:	4505                	li	a0,1
    233a:	746030ef          	jal	5a80 <exit>

000000000000233e <exectest>:
{
    233e:	715d                	addi	sp,sp,-80
    2340:	e486                	sd	ra,72(sp)
    2342:	e0a2                	sd	s0,64(sp)
    2344:	f84a                	sd	s2,48(sp)
    2346:	0880                	addi	s0,sp,80
    2348:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    234a:	00005797          	auipc	a5,0x5
    234e:	cee78793          	addi	a5,a5,-786 # 7038 <malloc+0x10a4>
    2352:	fcf43023          	sd	a5,-64(s0)
    2356:	00005797          	auipc	a5,0x5
    235a:	5fa78793          	addi	a5,a5,1530 # 7950 <malloc+0x19bc>
    235e:	fcf43423          	sd	a5,-56(s0)
    2362:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    2366:	00005517          	auipc	a0,0x5
    236a:	5f250513          	addi	a0,a0,1522 # 7958 <malloc+0x19c4>
    236e:	762030ef          	jal	5ad0 <unlink>
  pid = fork();
    2372:	706030ef          	jal	5a78 <fork>
  if(pid < 0) {
    2376:	02054f63          	bltz	a0,23b4 <exectest+0x76>
    237a:	fc26                	sd	s1,56(sp)
    237c:	84aa                	mv	s1,a0
  if(pid == 0) {
    237e:	e935                	bnez	a0,23f2 <exectest+0xb4>
    close(1);
    2380:	4505                	li	a0,1
    2382:	726030ef          	jal	5aa8 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    2386:	20100593          	li	a1,513
    238a:	00005517          	auipc	a0,0x5
    238e:	5ce50513          	addi	a0,a0,1486 # 7958 <malloc+0x19c4>
    2392:	72e030ef          	jal	5ac0 <open>
    if(fd < 0) {
    2396:	02054a63          	bltz	a0,23ca <exectest+0x8c>
    if(fd != 1) {
    239a:	4785                	li	a5,1
    239c:	04f50163          	beq	a0,a5,23de <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    23a0:	85ca                	mv	a1,s2
    23a2:	00005517          	auipc	a0,0x5
    23a6:	5d650513          	addi	a0,a0,1494 # 7978 <malloc+0x19e4>
    23aa:	337030ef          	jal	5ee0 <printf>
      exit(1);
    23ae:	4505                	li	a0,1
    23b0:	6d0030ef          	jal	5a80 <exit>
    23b4:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    23b6:	85ca                	mv	a1,s2
    23b8:	00005517          	auipc	a0,0x5
    23bc:	51050513          	addi	a0,a0,1296 # 78c8 <malloc+0x1934>
    23c0:	321030ef          	jal	5ee0 <printf>
     exit(1);
    23c4:	4505                	li	a0,1
    23c6:	6ba030ef          	jal	5a80 <exit>
      printf("%s: create failed\n", s);
    23ca:	85ca                	mv	a1,s2
    23cc:	00005517          	auipc	a0,0x5
    23d0:	59450513          	addi	a0,a0,1428 # 7960 <malloc+0x19cc>
    23d4:	30d030ef          	jal	5ee0 <printf>
      exit(1);
    23d8:	4505                	li	a0,1
    23da:	6a6030ef          	jal	5a80 <exit>
    if(exec("echo", echoargv) < 0){
    23de:	fc040593          	addi	a1,s0,-64
    23e2:	00005517          	auipc	a0,0x5
    23e6:	c5650513          	addi	a0,a0,-938 # 7038 <malloc+0x10a4>
    23ea:	6ce030ef          	jal	5ab8 <exec>
    23ee:	00054d63          	bltz	a0,2408 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    23f2:	fdc40513          	addi	a0,s0,-36
    23f6:	692030ef          	jal	5a88 <wait>
    23fa:	02951163          	bne	a0,s1,241c <exectest+0xde>
  if(xstatus != 0)
    23fe:	fdc42503          	lw	a0,-36(s0)
    2402:	c50d                	beqz	a0,242c <exectest+0xee>
    exit(xstatus);
    2404:	67c030ef          	jal	5a80 <exit>
      printf("%s: exec echo failed\n", s);
    2408:	85ca                	mv	a1,s2
    240a:	00005517          	auipc	a0,0x5
    240e:	57e50513          	addi	a0,a0,1406 # 7988 <malloc+0x19f4>
    2412:	2cf030ef          	jal	5ee0 <printf>
      exit(1);
    2416:	4505                	li	a0,1
    2418:	668030ef          	jal	5a80 <exit>
    printf("%s: wait failed!\n", s);
    241c:	85ca                	mv	a1,s2
    241e:	00005517          	auipc	a0,0x5
    2422:	58250513          	addi	a0,a0,1410 # 79a0 <malloc+0x1a0c>
    2426:	2bb030ef          	jal	5ee0 <printf>
    242a:	bfd1                	j	23fe <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    242c:	4581                	li	a1,0
    242e:	00005517          	auipc	a0,0x5
    2432:	52a50513          	addi	a0,a0,1322 # 7958 <malloc+0x19c4>
    2436:	68a030ef          	jal	5ac0 <open>
  if(fd < 0) {
    243a:	02054463          	bltz	a0,2462 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    243e:	4609                	li	a2,2
    2440:	fb840593          	addi	a1,s0,-72
    2444:	654030ef          	jal	5a98 <read>
    2448:	4789                	li	a5,2
    244a:	02f50663          	beq	a0,a5,2476 <exectest+0x138>
    printf("%s: read failed\n", s);
    244e:	85ca                	mv	a1,s2
    2450:	00005517          	auipc	a0,0x5
    2454:	fb850513          	addi	a0,a0,-72 # 7408 <malloc+0x1474>
    2458:	289030ef          	jal	5ee0 <printf>
    exit(1);
    245c:	4505                	li	a0,1
    245e:	622030ef          	jal	5a80 <exit>
    printf("%s: open failed\n", s);
    2462:	85ca                	mv	a1,s2
    2464:	00005517          	auipc	a0,0x5
    2468:	47c50513          	addi	a0,a0,1148 # 78e0 <malloc+0x194c>
    246c:	275030ef          	jal	5ee0 <printf>
    exit(1);
    2470:	4505                	li	a0,1
    2472:	60e030ef          	jal	5a80 <exit>
  unlink("echo-ok");
    2476:	00005517          	auipc	a0,0x5
    247a:	4e250513          	addi	a0,a0,1250 # 7958 <malloc+0x19c4>
    247e:	652030ef          	jal	5ad0 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    2482:	fb844703          	lbu	a4,-72(s0)
    2486:	04f00793          	li	a5,79
    248a:	00f71863          	bne	a4,a5,249a <exectest+0x15c>
    248e:	fb944703          	lbu	a4,-71(s0)
    2492:	04b00793          	li	a5,75
    2496:	00f70c63          	beq	a4,a5,24ae <exectest+0x170>
    printf("%s: wrong output\n", s);
    249a:	85ca                	mv	a1,s2
    249c:	00005517          	auipc	a0,0x5
    24a0:	51c50513          	addi	a0,a0,1308 # 79b8 <malloc+0x1a24>
    24a4:	23d030ef          	jal	5ee0 <printf>
    exit(1);
    24a8:	4505                	li	a0,1
    24aa:	5d6030ef          	jal	5a80 <exit>
    exit(0);
    24ae:	4501                	li	a0,0
    24b0:	5d0030ef          	jal	5a80 <exit>

00000000000024b4 <pipe1>:
{
    24b4:	711d                	addi	sp,sp,-96
    24b6:	ec86                	sd	ra,88(sp)
    24b8:	e8a2                	sd	s0,80(sp)
    24ba:	fc4e                	sd	s3,56(sp)
    24bc:	1080                	addi	s0,sp,96
    24be:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    24c0:	fa840513          	addi	a0,s0,-88
    24c4:	5cc030ef          	jal	5a90 <pipe>
    24c8:	e92d                	bnez	a0,253a <pipe1+0x86>
    24ca:	e4a6                	sd	s1,72(sp)
    24cc:	f852                	sd	s4,48(sp)
    24ce:	84aa                	mv	s1,a0
  pid = fork();
    24d0:	5a8030ef          	jal	5a78 <fork>
    24d4:	8a2a                	mv	s4,a0
  if(pid == 0){
    24d6:	c151                	beqz	a0,255a <pipe1+0xa6>
  } else if(pid > 0){
    24d8:	14a05e63          	blez	a0,2634 <pipe1+0x180>
    24dc:	e0ca                	sd	s2,64(sp)
    24de:	f456                	sd	s5,40(sp)
    close(fds[1]);
    24e0:	fac42503          	lw	a0,-84(s0)
    24e4:	5c4030ef          	jal	5aa8 <close>
    total = 0;
    24e8:	8a26                	mv	s4,s1
    cc = 1;
    24ea:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    24ec:	0000ba97          	auipc	s5,0xb
    24f0:	bbca8a93          	addi	s5,s5,-1092 # d0a8 <buf>
    24f4:	864a                	mv	a2,s2
    24f6:	85d6                	mv	a1,s5
    24f8:	fa842503          	lw	a0,-88(s0)
    24fc:	59c030ef          	jal	5a98 <read>
    2500:	0ea05a63          	blez	a0,25f4 <pipe1+0x140>
      for(i = 0; i < n; i++){
    2504:	0000b717          	auipc	a4,0xb
    2508:	ba470713          	addi	a4,a4,-1116 # d0a8 <buf>
    250c:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    2510:	00074683          	lbu	a3,0(a4)
    2514:	0ff4f793          	zext.b	a5,s1
    2518:	2485                	addiw	s1,s1,1
    251a:	0af69d63          	bne	a3,a5,25d4 <pipe1+0x120>
      for(i = 0; i < n; i++){
    251e:	0705                	addi	a4,a4,1
    2520:	fec498e3          	bne	s1,a2,2510 <pipe1+0x5c>
      total += n;
    2524:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    2528:	0019179b          	slliw	a5,s2,0x1
    252c:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    2530:	670d                	lui	a4,0x3
    2532:	fd2771e3          	bgeu	a4,s2,24f4 <pipe1+0x40>
        cc = sizeof(buf);
    2536:	690d                	lui	s2,0x3
    2538:	bf75                	j	24f4 <pipe1+0x40>
    253a:	e4a6                	sd	s1,72(sp)
    253c:	e0ca                	sd	s2,64(sp)
    253e:	f852                	sd	s4,48(sp)
    2540:	f456                	sd	s5,40(sp)
    2542:	f05a                	sd	s6,32(sp)
    2544:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    2546:	85ce                	mv	a1,s3
    2548:	00005517          	auipc	a0,0x5
    254c:	48850513          	addi	a0,a0,1160 # 79d0 <malloc+0x1a3c>
    2550:	191030ef          	jal	5ee0 <printf>
    exit(1);
    2554:	4505                	li	a0,1
    2556:	52a030ef          	jal	5a80 <exit>
    255a:	e0ca                	sd	s2,64(sp)
    255c:	f456                	sd	s5,40(sp)
    255e:	f05a                	sd	s6,32(sp)
    2560:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    2562:	fa842503          	lw	a0,-88(s0)
    2566:	542030ef          	jal	5aa8 <close>
    for(n = 0; n < N; n++){
    256a:	0000bb17          	auipc	s6,0xb
    256e:	b3eb0b13          	addi	s6,s6,-1218 # d0a8 <buf>
    2572:	416004bb          	negw	s1,s6
    2576:	0ff4f493          	zext.b	s1,s1
    257a:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    257e:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    2580:	6a85                	lui	s5,0x1
    2582:	42da8a93          	addi	s5,s5,1069 # 142d <outofinodes+0x6f>
{
    2586:	87da                	mv	a5,s6
        buf[i] = seq++;
    2588:	0097873b          	addw	a4,a5,s1
    258c:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    2590:	0785                	addi	a5,a5,1
    2592:	ff279be3          	bne	a5,s2,2588 <pipe1+0xd4>
    2596:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    259a:	40900613          	li	a2,1033
    259e:	85de                	mv	a1,s7
    25a0:	fac42503          	lw	a0,-84(s0)
    25a4:	4fc030ef          	jal	5aa0 <write>
    25a8:	40900793          	li	a5,1033
    25ac:	00f51a63          	bne	a0,a5,25c0 <pipe1+0x10c>
    for(n = 0; n < N; n++){
    25b0:	24a5                	addiw	s1,s1,9
    25b2:	0ff4f493          	zext.b	s1,s1
    25b6:	fd5a18e3          	bne	s4,s5,2586 <pipe1+0xd2>
    exit(0);
    25ba:	4501                	li	a0,0
    25bc:	4c4030ef          	jal	5a80 <exit>
        printf("%s: pipe1 oops 1\n", s);
    25c0:	85ce                	mv	a1,s3
    25c2:	00005517          	auipc	a0,0x5
    25c6:	42650513          	addi	a0,a0,1062 # 79e8 <malloc+0x1a54>
    25ca:	117030ef          	jal	5ee0 <printf>
        exit(1);
    25ce:	4505                	li	a0,1
    25d0:	4b0030ef          	jal	5a80 <exit>
          printf("%s: pipe1 oops 2\n", s);
    25d4:	85ce                	mv	a1,s3
    25d6:	00005517          	auipc	a0,0x5
    25da:	42a50513          	addi	a0,a0,1066 # 7a00 <malloc+0x1a6c>
    25de:	103030ef          	jal	5ee0 <printf>
          return;
    25e2:	64a6                	ld	s1,72(sp)
    25e4:	6906                	ld	s2,64(sp)
    25e6:	7a42                	ld	s4,48(sp)
    25e8:	7aa2                	ld	s5,40(sp)
}
    25ea:	60e6                	ld	ra,88(sp)
    25ec:	6446                	ld	s0,80(sp)
    25ee:	79e2                	ld	s3,56(sp)
    25f0:	6125                	addi	sp,sp,96
    25f2:	8082                	ret
    if(total != N * SZ){
    25f4:	6785                	lui	a5,0x1
    25f6:	42d78793          	addi	a5,a5,1069 # 142d <outofinodes+0x6f>
    25fa:	00fa0f63          	beq	s4,a5,2618 <pipe1+0x164>
    25fe:	f05a                	sd	s6,32(sp)
    2600:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    2602:	8652                	mv	a2,s4
    2604:	85ce                	mv	a1,s3
    2606:	00005517          	auipc	a0,0x5
    260a:	41250513          	addi	a0,a0,1042 # 7a18 <malloc+0x1a84>
    260e:	0d3030ef          	jal	5ee0 <printf>
      exit(1);
    2612:	4505                	li	a0,1
    2614:	46c030ef          	jal	5a80 <exit>
    2618:	f05a                	sd	s6,32(sp)
    261a:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    261c:	fa842503          	lw	a0,-88(s0)
    2620:	488030ef          	jal	5aa8 <close>
    wait(&xstatus);
    2624:	fa440513          	addi	a0,s0,-92
    2628:	460030ef          	jal	5a88 <wait>
    exit(xstatus);
    262c:	fa442503          	lw	a0,-92(s0)
    2630:	450030ef          	jal	5a80 <exit>
    2634:	e0ca                	sd	s2,64(sp)
    2636:	f456                	sd	s5,40(sp)
    2638:	f05a                	sd	s6,32(sp)
    263a:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    263c:	85ce                	mv	a1,s3
    263e:	00005517          	auipc	a0,0x5
    2642:	3fa50513          	addi	a0,a0,1018 # 7a38 <malloc+0x1aa4>
    2646:	09b030ef          	jal	5ee0 <printf>
    exit(1);
    264a:	4505                	li	a0,1
    264c:	434030ef          	jal	5a80 <exit>

0000000000002650 <exitwait>:
{
    2650:	7139                	addi	sp,sp,-64
    2652:	fc06                	sd	ra,56(sp)
    2654:	f822                	sd	s0,48(sp)
    2656:	f426                	sd	s1,40(sp)
    2658:	f04a                	sd	s2,32(sp)
    265a:	ec4e                	sd	s3,24(sp)
    265c:	e852                	sd	s4,16(sp)
    265e:	0080                	addi	s0,sp,64
    2660:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    2662:	4901                	li	s2,0
    2664:	06400993          	li	s3,100
    pid = fork();
    2668:	410030ef          	jal	5a78 <fork>
    266c:	84aa                	mv	s1,a0
    if(pid < 0){
    266e:	02054863          	bltz	a0,269e <exitwait+0x4e>
    if(pid){
    2672:	c525                	beqz	a0,26da <exitwait+0x8a>
      if(wait(&xstate) != pid){
    2674:	fcc40513          	addi	a0,s0,-52
    2678:	410030ef          	jal	5a88 <wait>
    267c:	02951b63          	bne	a0,s1,26b2 <exitwait+0x62>
      if(i != xstate) {
    2680:	fcc42783          	lw	a5,-52(s0)
    2684:	05279163          	bne	a5,s2,26c6 <exitwait+0x76>
  for(i = 0; i < 100; i++){
    2688:	2905                	addiw	s2,s2,1 # 3001 <rwsbrk+0x33>
    268a:	fd391fe3          	bne	s2,s3,2668 <exitwait+0x18>
}
    268e:	70e2                	ld	ra,56(sp)
    2690:	7442                	ld	s0,48(sp)
    2692:	74a2                	ld	s1,40(sp)
    2694:	7902                	ld	s2,32(sp)
    2696:	69e2                	ld	s3,24(sp)
    2698:	6a42                	ld	s4,16(sp)
    269a:	6121                	addi	sp,sp,64
    269c:	8082                	ret
      printf("%s: fork failed\n", s);
    269e:	85d2                	mv	a1,s4
    26a0:	00005517          	auipc	a0,0x5
    26a4:	22850513          	addi	a0,a0,552 # 78c8 <malloc+0x1934>
    26a8:	039030ef          	jal	5ee0 <printf>
      exit(1);
    26ac:	4505                	li	a0,1
    26ae:	3d2030ef          	jal	5a80 <exit>
        printf("%s: wait wrong pid\n", s);
    26b2:	85d2                	mv	a1,s4
    26b4:	00005517          	auipc	a0,0x5
    26b8:	39c50513          	addi	a0,a0,924 # 7a50 <malloc+0x1abc>
    26bc:	025030ef          	jal	5ee0 <printf>
        exit(1);
    26c0:	4505                	li	a0,1
    26c2:	3be030ef          	jal	5a80 <exit>
        printf("%s: wait wrong exit status\n", s);
    26c6:	85d2                	mv	a1,s4
    26c8:	00005517          	auipc	a0,0x5
    26cc:	3a050513          	addi	a0,a0,928 # 7a68 <malloc+0x1ad4>
    26d0:	011030ef          	jal	5ee0 <printf>
        exit(1);
    26d4:	4505                	li	a0,1
    26d6:	3aa030ef          	jal	5a80 <exit>
      exit(i);
    26da:	854a                	mv	a0,s2
    26dc:	3a4030ef          	jal	5a80 <exit>

00000000000026e0 <twochildren>:
{
    26e0:	1101                	addi	sp,sp,-32
    26e2:	ec06                	sd	ra,24(sp)
    26e4:	e822                	sd	s0,16(sp)
    26e6:	e426                	sd	s1,8(sp)
    26e8:	e04a                	sd	s2,0(sp)
    26ea:	1000                	addi	s0,sp,32
    26ec:	892a                	mv	s2,a0
    26ee:	3e800493          	li	s1,1000
    int pid1 = fork();
    26f2:	386030ef          	jal	5a78 <fork>
    if(pid1 < 0){
    26f6:	02054663          	bltz	a0,2722 <twochildren+0x42>
    if(pid1 == 0){
    26fa:	cd15                	beqz	a0,2736 <twochildren+0x56>
      int pid2 = fork();
    26fc:	37c030ef          	jal	5a78 <fork>
      if(pid2 < 0){
    2700:	02054d63          	bltz	a0,273a <twochildren+0x5a>
      if(pid2 == 0){
    2704:	c529                	beqz	a0,274e <twochildren+0x6e>
        wait(0);
    2706:	4501                	li	a0,0
    2708:	380030ef          	jal	5a88 <wait>
        wait(0);
    270c:	4501                	li	a0,0
    270e:	37a030ef          	jal	5a88 <wait>
  for(int i = 0; i < 1000; i++){
    2712:	34fd                	addiw	s1,s1,-1
    2714:	fcf9                	bnez	s1,26f2 <twochildren+0x12>
}
    2716:	60e2                	ld	ra,24(sp)
    2718:	6442                	ld	s0,16(sp)
    271a:	64a2                	ld	s1,8(sp)
    271c:	6902                	ld	s2,0(sp)
    271e:	6105                	addi	sp,sp,32
    2720:	8082                	ret
      printf("%s: fork failed\n", s);
    2722:	85ca                	mv	a1,s2
    2724:	00005517          	auipc	a0,0x5
    2728:	1a450513          	addi	a0,a0,420 # 78c8 <malloc+0x1934>
    272c:	7b4030ef          	jal	5ee0 <printf>
      exit(1);
    2730:	4505                	li	a0,1
    2732:	34e030ef          	jal	5a80 <exit>
      exit(0);
    2736:	34a030ef          	jal	5a80 <exit>
        printf("%s: fork failed\n", s);
    273a:	85ca                	mv	a1,s2
    273c:	00005517          	auipc	a0,0x5
    2740:	18c50513          	addi	a0,a0,396 # 78c8 <malloc+0x1934>
    2744:	79c030ef          	jal	5ee0 <printf>
        exit(1);
    2748:	4505                	li	a0,1
    274a:	336030ef          	jal	5a80 <exit>
        exit(0);
    274e:	332030ef          	jal	5a80 <exit>

0000000000002752 <forkfork>:
{
    2752:	7179                	addi	sp,sp,-48
    2754:	f406                	sd	ra,40(sp)
    2756:	f022                	sd	s0,32(sp)
    2758:	ec26                	sd	s1,24(sp)
    275a:	1800                	addi	s0,sp,48
    275c:	84aa                	mv	s1,a0
    int pid = fork();
    275e:	31a030ef          	jal	5a78 <fork>
    if(pid < 0){
    2762:	02054b63          	bltz	a0,2798 <forkfork+0x46>
    if(pid == 0){
    2766:	c139                	beqz	a0,27ac <forkfork+0x5a>
    int pid = fork();
    2768:	310030ef          	jal	5a78 <fork>
    if(pid < 0){
    276c:	02054663          	bltz	a0,2798 <forkfork+0x46>
    if(pid == 0){
    2770:	cd15                	beqz	a0,27ac <forkfork+0x5a>
    wait(&xstatus);
    2772:	fdc40513          	addi	a0,s0,-36
    2776:	312030ef          	jal	5a88 <wait>
    if(xstatus != 0) {
    277a:	fdc42783          	lw	a5,-36(s0)
    277e:	ebb9                	bnez	a5,27d4 <forkfork+0x82>
    wait(&xstatus);
    2780:	fdc40513          	addi	a0,s0,-36
    2784:	304030ef          	jal	5a88 <wait>
    if(xstatus != 0) {
    2788:	fdc42783          	lw	a5,-36(s0)
    278c:	e7a1                	bnez	a5,27d4 <forkfork+0x82>
}
    278e:	70a2                	ld	ra,40(sp)
    2790:	7402                	ld	s0,32(sp)
    2792:	64e2                	ld	s1,24(sp)
    2794:	6145                	addi	sp,sp,48
    2796:	8082                	ret
      printf("%s: fork failed", s);
    2798:	85a6                	mv	a1,s1
    279a:	00005517          	auipc	a0,0x5
    279e:	2ee50513          	addi	a0,a0,750 # 7a88 <malloc+0x1af4>
    27a2:	73e030ef          	jal	5ee0 <printf>
      exit(1);
    27a6:	4505                	li	a0,1
    27a8:	2d8030ef          	jal	5a80 <exit>
{
    27ac:	0c800493          	li	s1,200
        int pid1 = fork();
    27b0:	2c8030ef          	jal	5a78 <fork>
        if(pid1 < 0){
    27b4:	00054b63          	bltz	a0,27ca <forkfork+0x78>
        if(pid1 == 0){
    27b8:	cd01                	beqz	a0,27d0 <forkfork+0x7e>
        wait(0);
    27ba:	4501                	li	a0,0
    27bc:	2cc030ef          	jal	5a88 <wait>
      for(int j = 0; j < 200; j++){
    27c0:	34fd                	addiw	s1,s1,-1
    27c2:	f4fd                	bnez	s1,27b0 <forkfork+0x5e>
      exit(0);
    27c4:	4501                	li	a0,0
    27c6:	2ba030ef          	jal	5a80 <exit>
          exit(1);
    27ca:	4505                	li	a0,1
    27cc:	2b4030ef          	jal	5a80 <exit>
          exit(0);
    27d0:	2b0030ef          	jal	5a80 <exit>
      printf("%s: fork in child failed", s);
    27d4:	85a6                	mv	a1,s1
    27d6:	00005517          	auipc	a0,0x5
    27da:	2c250513          	addi	a0,a0,706 # 7a98 <malloc+0x1b04>
    27de:	702030ef          	jal	5ee0 <printf>
      exit(1);
    27e2:	4505                	li	a0,1
    27e4:	29c030ef          	jal	5a80 <exit>

00000000000027e8 <reparent2>:
{
    27e8:	1101                	addi	sp,sp,-32
    27ea:	ec06                	sd	ra,24(sp)
    27ec:	e822                	sd	s0,16(sp)
    27ee:	e426                	sd	s1,8(sp)
    27f0:	1000                	addi	s0,sp,32
    27f2:	32000493          	li	s1,800
    int pid1 = fork();
    27f6:	282030ef          	jal	5a78 <fork>
    if(pid1 < 0){
    27fa:	00054b63          	bltz	a0,2810 <reparent2+0x28>
    if(pid1 == 0){
    27fe:	c115                	beqz	a0,2822 <reparent2+0x3a>
    wait(0);
    2800:	4501                	li	a0,0
    2802:	286030ef          	jal	5a88 <wait>
  for(int i = 0; i < 800; i++){
    2806:	34fd                	addiw	s1,s1,-1
    2808:	f4fd                	bnez	s1,27f6 <reparent2+0xe>
  exit(0);
    280a:	4501                	li	a0,0
    280c:	274030ef          	jal	5a80 <exit>
      printf("fork failed\n");
    2810:	00006517          	auipc	a0,0x6
    2814:	62850513          	addi	a0,a0,1576 # 8e38 <malloc+0x2ea4>
    2818:	6c8030ef          	jal	5ee0 <printf>
      exit(1);
    281c:	4505                	li	a0,1
    281e:	262030ef          	jal	5a80 <exit>
      fork();
    2822:	256030ef          	jal	5a78 <fork>
      fork();
    2826:	252030ef          	jal	5a78 <fork>
      exit(0);
    282a:	4501                	li	a0,0
    282c:	254030ef          	jal	5a80 <exit>

0000000000002830 <createdelete>:
{
    2830:	7175                	addi	sp,sp,-144
    2832:	e506                	sd	ra,136(sp)
    2834:	e122                	sd	s0,128(sp)
    2836:	fca6                	sd	s1,120(sp)
    2838:	f8ca                	sd	s2,112(sp)
    283a:	f4ce                	sd	s3,104(sp)
    283c:	f0d2                	sd	s4,96(sp)
    283e:	ecd6                	sd	s5,88(sp)
    2840:	e8da                	sd	s6,80(sp)
    2842:	e4de                	sd	s7,72(sp)
    2844:	e0e2                	sd	s8,64(sp)
    2846:	fc66                	sd	s9,56(sp)
    2848:	0900                	addi	s0,sp,144
    284a:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    284c:	4901                	li	s2,0
    284e:	4991                	li	s3,4
    pid = fork();
    2850:	228030ef          	jal	5a78 <fork>
    2854:	84aa                	mv	s1,a0
    if(pid < 0){
    2856:	02054d63          	bltz	a0,2890 <createdelete+0x60>
    if(pid == 0){
    285a:	c529                	beqz	a0,28a4 <createdelete+0x74>
  for(pi = 0; pi < NCHILD; pi++){
    285c:	2905                	addiw	s2,s2,1
    285e:	ff3919e3          	bne	s2,s3,2850 <createdelete+0x20>
    2862:	4491                	li	s1,4
    wait(&xstatus);
    2864:	f7c40513          	addi	a0,s0,-132
    2868:	220030ef          	jal	5a88 <wait>
    if(xstatus != 0)
    286c:	f7c42903          	lw	s2,-132(s0)
    2870:	0a091e63          	bnez	s2,292c <createdelete+0xfc>
  for(pi = 0; pi < NCHILD; pi++){
    2874:	34fd                	addiw	s1,s1,-1
    2876:	f4fd                	bnez	s1,2864 <createdelete+0x34>
  name[0] = name[1] = name[2] = 0;
    2878:	f8040123          	sb	zero,-126(s0)
    287c:	03000993          	li	s3,48
    2880:	5a7d                	li	s4,-1
    2882:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    2886:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2888:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    288a:	07400a93          	li	s5,116
    288e:	aa39                	j	29ac <createdelete+0x17c>
      printf("%s: fork failed\n", s);
    2890:	85e6                	mv	a1,s9
    2892:	00005517          	auipc	a0,0x5
    2896:	03650513          	addi	a0,a0,54 # 78c8 <malloc+0x1934>
    289a:	646030ef          	jal	5ee0 <printf>
      exit(1);
    289e:	4505                	li	a0,1
    28a0:	1e0030ef          	jal	5a80 <exit>
      name[0] = 'p' + pi;
    28a4:	0709091b          	addiw	s2,s2,112
    28a8:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    28ac:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    28b0:	4951                	li	s2,20
    28b2:	a831                	j	28ce <createdelete+0x9e>
          printf("%s: create failed\n", s);
    28b4:	85e6                	mv	a1,s9
    28b6:	00005517          	auipc	a0,0x5
    28ba:	0aa50513          	addi	a0,a0,170 # 7960 <malloc+0x19cc>
    28be:	622030ef          	jal	5ee0 <printf>
          exit(1);
    28c2:	4505                	li	a0,1
    28c4:	1bc030ef          	jal	5a80 <exit>
      for(i = 0; i < N; i++){
    28c8:	2485                	addiw	s1,s1,1
    28ca:	05248e63          	beq	s1,s2,2926 <createdelete+0xf6>
        name[1] = '0' + i;
    28ce:	0304879b          	addiw	a5,s1,48
    28d2:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    28d6:	20200593          	li	a1,514
    28da:	f8040513          	addi	a0,s0,-128
    28de:	1e2030ef          	jal	5ac0 <open>
        if(fd < 0){
    28e2:	fc0549e3          	bltz	a0,28b4 <createdelete+0x84>
        close(fd);
    28e6:	1c2030ef          	jal	5aa8 <close>
        if(i > 0 && (i % 2 ) == 0){
    28ea:	10905063          	blez	s1,29ea <createdelete+0x1ba>
    28ee:	0014f793          	andi	a5,s1,1
    28f2:	fbf9                	bnez	a5,28c8 <createdelete+0x98>
          name[1] = '0' + (i / 2);
    28f4:	01f4d79b          	srliw	a5,s1,0x1f
    28f8:	9fa5                	addw	a5,a5,s1
    28fa:	4017d79b          	sraiw	a5,a5,0x1
    28fe:	0307879b          	addiw	a5,a5,48
    2902:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    2906:	f8040513          	addi	a0,s0,-128
    290a:	1c6030ef          	jal	5ad0 <unlink>
    290e:	fa055de3          	bgez	a0,28c8 <createdelete+0x98>
            printf("%s: unlink failed\n", s);
    2912:	85e6                	mv	a1,s9
    2914:	00005517          	auipc	a0,0x5
    2918:	1a450513          	addi	a0,a0,420 # 7ab8 <malloc+0x1b24>
    291c:	5c4030ef          	jal	5ee0 <printf>
            exit(1);
    2920:	4505                	li	a0,1
    2922:	15e030ef          	jal	5a80 <exit>
      exit(0);
    2926:	4501                	li	a0,0
    2928:	158030ef          	jal	5a80 <exit>
      exit(1);
    292c:	4505                	li	a0,1
    292e:	152030ef          	jal	5a80 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    2932:	f8040613          	addi	a2,s0,-128
    2936:	85e6                	mv	a1,s9
    2938:	00005517          	auipc	a0,0x5
    293c:	19850513          	addi	a0,a0,408 # 7ad0 <malloc+0x1b3c>
    2940:	5a0030ef          	jal	5ee0 <printf>
        exit(1);
    2944:	4505                	li	a0,1
    2946:	13a030ef          	jal	5a80 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    294a:	034bfb63          	bgeu	s7,s4,2980 <createdelete+0x150>
      if(fd >= 0)
    294e:	02055663          	bgez	a0,297a <createdelete+0x14a>
    for(pi = 0; pi < NCHILD; pi++){
    2952:	2485                	addiw	s1,s1,1
    2954:	0ff4f493          	zext.b	s1,s1
    2958:	05548263          	beq	s1,s5,299c <createdelete+0x16c>
      name[0] = 'p' + pi;
    295c:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    2960:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    2964:	4581                	li	a1,0
    2966:	f8040513          	addi	a0,s0,-128
    296a:	156030ef          	jal	5ac0 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    296e:	00090463          	beqz	s2,2976 <createdelete+0x146>
    2972:	fd2b5ce3          	bge	s6,s2,294a <createdelete+0x11a>
    2976:	fa054ee3          	bltz	a0,2932 <createdelete+0x102>
        close(fd);
    297a:	12e030ef          	jal	5aa8 <close>
    297e:	bfd1                	j	2952 <createdelete+0x122>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    2980:	fc0549e3          	bltz	a0,2952 <createdelete+0x122>
        printf("%s: oops createdelete %s did exist\n", s, name);
    2984:	f8040613          	addi	a2,s0,-128
    2988:	85e6                	mv	a1,s9
    298a:	00005517          	auipc	a0,0x5
    298e:	16e50513          	addi	a0,a0,366 # 7af8 <malloc+0x1b64>
    2992:	54e030ef          	jal	5ee0 <printf>
        exit(1);
    2996:	4505                	li	a0,1
    2998:	0e8030ef          	jal	5a80 <exit>
  for(i = 0; i < N; i++){
    299c:	2905                	addiw	s2,s2,1
    299e:	2a05                	addiw	s4,s4,1
    29a0:	2985                	addiw	s3,s3,1
    29a2:	0ff9f993          	zext.b	s3,s3
    29a6:	47d1                	li	a5,20
    29a8:	02f90863          	beq	s2,a5,29d8 <createdelete+0x1a8>
    for(pi = 0; pi < NCHILD; pi++){
    29ac:	84e2                	mv	s1,s8
    29ae:	b77d                	j	295c <createdelete+0x12c>
  for(i = 0; i < N; i++){
    29b0:	2905                	addiw	s2,s2,1
    29b2:	0ff97913          	zext.b	s2,s2
    29b6:	03490c63          	beq	s2,s4,29ee <createdelete+0x1be>
  name[0] = name[1] = name[2] = 0;
    29ba:	84d6                	mv	s1,s5
      name[0] = 'p' + pi;
    29bc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    29c0:	f92400a3          	sb	s2,-127(s0)
      unlink(name);
    29c4:	f8040513          	addi	a0,s0,-128
    29c8:	108030ef          	jal	5ad0 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    29cc:	2485                	addiw	s1,s1,1
    29ce:	0ff4f493          	zext.b	s1,s1
    29d2:	ff3495e3          	bne	s1,s3,29bc <createdelete+0x18c>
    29d6:	bfe9                	j	29b0 <createdelete+0x180>
    29d8:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    29dc:	07000a93          	li	s5,112
    for(pi = 0; pi < NCHILD; pi++){
    29e0:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    29e4:	04400a13          	li	s4,68
    29e8:	bfc9                	j	29ba <createdelete+0x18a>
      for(i = 0; i < N; i++){
    29ea:	2485                	addiw	s1,s1,1
    29ec:	b5cd                	j	28ce <createdelete+0x9e>
}
    29ee:	60aa                	ld	ra,136(sp)
    29f0:	640a                	ld	s0,128(sp)
    29f2:	74e6                	ld	s1,120(sp)
    29f4:	7946                	ld	s2,112(sp)
    29f6:	79a6                	ld	s3,104(sp)
    29f8:	7a06                	ld	s4,96(sp)
    29fa:	6ae6                	ld	s5,88(sp)
    29fc:	6b46                	ld	s6,80(sp)
    29fe:	6ba6                	ld	s7,72(sp)
    2a00:	6c06                	ld	s8,64(sp)
    2a02:	7ce2                	ld	s9,56(sp)
    2a04:	6149                	addi	sp,sp,144
    2a06:	8082                	ret

0000000000002a08 <linkunlink>:
{
    2a08:	711d                	addi	sp,sp,-96
    2a0a:	ec86                	sd	ra,88(sp)
    2a0c:	e8a2                	sd	s0,80(sp)
    2a0e:	e4a6                	sd	s1,72(sp)
    2a10:	e0ca                	sd	s2,64(sp)
    2a12:	fc4e                	sd	s3,56(sp)
    2a14:	f852                	sd	s4,48(sp)
    2a16:	f456                	sd	s5,40(sp)
    2a18:	f05a                	sd	s6,32(sp)
    2a1a:	ec5e                	sd	s7,24(sp)
    2a1c:	e862                	sd	s8,16(sp)
    2a1e:	e466                	sd	s9,8(sp)
    2a20:	1080                	addi	s0,sp,96
    2a22:	84aa                	mv	s1,a0
  unlink("x");
    2a24:	00004517          	auipc	a0,0x4
    2a28:	68450513          	addi	a0,a0,1668 # 70a8 <malloc+0x1114>
    2a2c:	0a4030ef          	jal	5ad0 <unlink>
  pid = fork();
    2a30:	048030ef          	jal	5a78 <fork>
  if(pid < 0){
    2a34:	02054b63          	bltz	a0,2a6a <linkunlink+0x62>
    2a38:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    2a3a:	06100913          	li	s2,97
    2a3e:	c111                	beqz	a0,2a42 <linkunlink+0x3a>
    2a40:	4905                	li	s2,1
    2a42:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2a46:	41c65a37          	lui	s4,0x41c65
    2a4a:	e6da0a1b          	addiw	s4,s4,-403 # 41c64e6d <base+0x41c54dc5>
    2a4e:	698d                	lui	s3,0x3
    2a50:	0399899b          	addiw	s3,s3,57 # 3039 <rwsbrk+0x6b>
    if((x % 3) == 0){
    2a54:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    2a56:	4b85                	li	s7,1
      unlink("x");
    2a58:	00004b17          	auipc	s6,0x4
    2a5c:	650b0b13          	addi	s6,s6,1616 # 70a8 <malloc+0x1114>
      link("cat", "x");
    2a60:	00005c17          	auipc	s8,0x5
    2a64:	0c0c0c13          	addi	s8,s8,192 # 7b20 <malloc+0x1b8c>
    2a68:	a025                	j	2a90 <linkunlink+0x88>
    printf("%s: fork failed\n", s);
    2a6a:	85a6                	mv	a1,s1
    2a6c:	00005517          	auipc	a0,0x5
    2a70:	e5c50513          	addi	a0,a0,-420 # 78c8 <malloc+0x1934>
    2a74:	46c030ef          	jal	5ee0 <printf>
    exit(1);
    2a78:	4505                	li	a0,1
    2a7a:	006030ef          	jal	5a80 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2a7e:	20200593          	li	a1,514
    2a82:	855a                	mv	a0,s6
    2a84:	03c030ef          	jal	5ac0 <open>
    2a88:	020030ef          	jal	5aa8 <close>
  for(i = 0; i < 100; i++){
    2a8c:	34fd                	addiw	s1,s1,-1
    2a8e:	c495                	beqz	s1,2aba <linkunlink+0xb2>
    x = x * 1103515245 + 12345;
    2a90:	034907bb          	mulw	a5,s2,s4
    2a94:	013787bb          	addw	a5,a5,s3
    2a98:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2a9c:	0357f7bb          	remuw	a5,a5,s5
    2aa0:	2781                	sext.w	a5,a5
    2aa2:	dff1                	beqz	a5,2a7e <linkunlink+0x76>
    } else if((x % 3) == 1){
    2aa4:	01778663          	beq	a5,s7,2ab0 <linkunlink+0xa8>
      unlink("x");
    2aa8:	855a                	mv	a0,s6
    2aaa:	026030ef          	jal	5ad0 <unlink>
    2aae:	bff9                	j	2a8c <linkunlink+0x84>
      link("cat", "x");
    2ab0:	85da                	mv	a1,s6
    2ab2:	8562                	mv	a0,s8
    2ab4:	02c030ef          	jal	5ae0 <link>
    2ab8:	bfd1                	j	2a8c <linkunlink+0x84>
  if(pid)
    2aba:	020c8263          	beqz	s9,2ade <linkunlink+0xd6>
    wait(0);
    2abe:	4501                	li	a0,0
    2ac0:	7c9020ef          	jal	5a88 <wait>
}
    2ac4:	60e6                	ld	ra,88(sp)
    2ac6:	6446                	ld	s0,80(sp)
    2ac8:	64a6                	ld	s1,72(sp)
    2aca:	6906                	ld	s2,64(sp)
    2acc:	79e2                	ld	s3,56(sp)
    2ace:	7a42                	ld	s4,48(sp)
    2ad0:	7aa2                	ld	s5,40(sp)
    2ad2:	7b02                	ld	s6,32(sp)
    2ad4:	6be2                	ld	s7,24(sp)
    2ad6:	6c42                	ld	s8,16(sp)
    2ad8:	6ca2                	ld	s9,8(sp)
    2ada:	6125                	addi	sp,sp,96
    2adc:	8082                	ret
    exit(0);
    2ade:	4501                	li	a0,0
    2ae0:	7a1020ef          	jal	5a80 <exit>

0000000000002ae4 <forktest>:
{
    2ae4:	7179                	addi	sp,sp,-48
    2ae6:	f406                	sd	ra,40(sp)
    2ae8:	f022                	sd	s0,32(sp)
    2aea:	ec26                	sd	s1,24(sp)
    2aec:	e84a                	sd	s2,16(sp)
    2aee:	e44e                	sd	s3,8(sp)
    2af0:	1800                	addi	s0,sp,48
    2af2:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    2af4:	4481                	li	s1,0
    2af6:	3e800913          	li	s2,1000
    pid = fork();
    2afa:	77f020ef          	jal	5a78 <fork>
    if(pid < 0)
    2afe:	06054063          	bltz	a0,2b5e <forktest+0x7a>
    if(pid == 0)
    2b02:	cd11                	beqz	a0,2b1e <forktest+0x3a>
  for(n=0; n<N; n++){
    2b04:	2485                	addiw	s1,s1,1
    2b06:	ff249ae3          	bne	s1,s2,2afa <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    2b0a:	85ce                	mv	a1,s3
    2b0c:	00005517          	auipc	a0,0x5
    2b10:	06450513          	addi	a0,a0,100 # 7b70 <malloc+0x1bdc>
    2b14:	3cc030ef          	jal	5ee0 <printf>
    exit(1);
    2b18:	4505                	li	a0,1
    2b1a:	767020ef          	jal	5a80 <exit>
      exit(0);
    2b1e:	763020ef          	jal	5a80 <exit>
    printf("%s: no fork at all!\n", s);
    2b22:	85ce                	mv	a1,s3
    2b24:	00005517          	auipc	a0,0x5
    2b28:	00450513          	addi	a0,a0,4 # 7b28 <malloc+0x1b94>
    2b2c:	3b4030ef          	jal	5ee0 <printf>
    exit(1);
    2b30:	4505                	li	a0,1
    2b32:	74f020ef          	jal	5a80 <exit>
      printf("%s: wait stopped early\n", s);
    2b36:	85ce                	mv	a1,s3
    2b38:	00005517          	auipc	a0,0x5
    2b3c:	00850513          	addi	a0,a0,8 # 7b40 <malloc+0x1bac>
    2b40:	3a0030ef          	jal	5ee0 <printf>
      exit(1);
    2b44:	4505                	li	a0,1
    2b46:	73b020ef          	jal	5a80 <exit>
    printf("%s: wait got too many\n", s);
    2b4a:	85ce                	mv	a1,s3
    2b4c:	00005517          	auipc	a0,0x5
    2b50:	00c50513          	addi	a0,a0,12 # 7b58 <malloc+0x1bc4>
    2b54:	38c030ef          	jal	5ee0 <printf>
    exit(1);
    2b58:	4505                	li	a0,1
    2b5a:	727020ef          	jal	5a80 <exit>
  if (n == 0) {
    2b5e:	d0f1                	beqz	s1,2b22 <forktest+0x3e>
  for(; n > 0; n--){
    2b60:	00905963          	blez	s1,2b72 <forktest+0x8e>
    if(wait(0) < 0){
    2b64:	4501                	li	a0,0
    2b66:	723020ef          	jal	5a88 <wait>
    2b6a:	fc0546e3          	bltz	a0,2b36 <forktest+0x52>
  for(; n > 0; n--){
    2b6e:	34fd                	addiw	s1,s1,-1
    2b70:	f8f5                	bnez	s1,2b64 <forktest+0x80>
  if(wait(0) != -1){
    2b72:	4501                	li	a0,0
    2b74:	715020ef          	jal	5a88 <wait>
    2b78:	57fd                	li	a5,-1
    2b7a:	fcf518e3          	bne	a0,a5,2b4a <forktest+0x66>
}
    2b7e:	70a2                	ld	ra,40(sp)
    2b80:	7402                	ld	s0,32(sp)
    2b82:	64e2                	ld	s1,24(sp)
    2b84:	6942                	ld	s2,16(sp)
    2b86:	69a2                	ld	s3,8(sp)
    2b88:	6145                	addi	sp,sp,48
    2b8a:	8082                	ret

0000000000002b8c <kernmem>:
{
    2b8c:	715d                	addi	sp,sp,-80
    2b8e:	e486                	sd	ra,72(sp)
    2b90:	e0a2                	sd	s0,64(sp)
    2b92:	fc26                	sd	s1,56(sp)
    2b94:	f84a                	sd	s2,48(sp)
    2b96:	f44e                	sd	s3,40(sp)
    2b98:	f052                	sd	s4,32(sp)
    2b9a:	ec56                	sd	s5,24(sp)
    2b9c:	0880                	addi	s0,sp,80
    2b9e:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2ba0:	4485                	li	s1,1
    2ba2:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    2ba4:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2ba6:	69b1                	lui	s3,0xc
    2ba8:	35098993          	addi	s3,s3,848 # c350 <uninit+0x19b8>
    2bac:	1003d937          	lui	s2,0x1003d
    2bb0:	090e                	slli	s2,s2,0x3
    2bb2:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002d3d8>
    pid = fork();
    2bb6:	6c3020ef          	jal	5a78 <fork>
    if(pid < 0){
    2bba:	02054763          	bltz	a0,2be8 <kernmem+0x5c>
    if(pid == 0){
    2bbe:	cd1d                	beqz	a0,2bfc <kernmem+0x70>
    wait(&xstatus);
    2bc0:	fbc40513          	addi	a0,s0,-68
    2bc4:	6c5020ef          	jal	5a88 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2bc8:	fbc42783          	lw	a5,-68(s0)
    2bcc:	05479563          	bne	a5,s4,2c16 <kernmem+0x8a>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2bd0:	94ce                	add	s1,s1,s3
    2bd2:	ff2492e3          	bne	s1,s2,2bb6 <kernmem+0x2a>
}
    2bd6:	60a6                	ld	ra,72(sp)
    2bd8:	6406                	ld	s0,64(sp)
    2bda:	74e2                	ld	s1,56(sp)
    2bdc:	7942                	ld	s2,48(sp)
    2bde:	79a2                	ld	s3,40(sp)
    2be0:	7a02                	ld	s4,32(sp)
    2be2:	6ae2                	ld	s5,24(sp)
    2be4:	6161                	addi	sp,sp,80
    2be6:	8082                	ret
      printf("%s: fork failed\n", s);
    2be8:	85d6                	mv	a1,s5
    2bea:	00005517          	auipc	a0,0x5
    2bee:	cde50513          	addi	a0,a0,-802 # 78c8 <malloc+0x1934>
    2bf2:	2ee030ef          	jal	5ee0 <printf>
      exit(1);
    2bf6:	4505                	li	a0,1
    2bf8:	689020ef          	jal	5a80 <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    2bfc:	0004c683          	lbu	a3,0(s1)
    2c00:	8626                	mv	a2,s1
    2c02:	85d6                	mv	a1,s5
    2c04:	00005517          	auipc	a0,0x5
    2c08:	f9450513          	addi	a0,a0,-108 # 7b98 <malloc+0x1c04>
    2c0c:	2d4030ef          	jal	5ee0 <printf>
      exit(1);
    2c10:	4505                	li	a0,1
    2c12:	66f020ef          	jal	5a80 <exit>
      exit(1);
    2c16:	4505                	li	a0,1
    2c18:	669020ef          	jal	5a80 <exit>

0000000000002c1c <MAXVAplus>:
{
    2c1c:	7179                	addi	sp,sp,-48
    2c1e:	f406                	sd	ra,40(sp)
    2c20:	f022                	sd	s0,32(sp)
    2c22:	1800                	addi	s0,sp,48
  volatile uint64 a = MAXVA;
    2c24:	4785                	li	a5,1
    2c26:	179a                	slli	a5,a5,0x26
    2c28:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2c2c:	fd843783          	ld	a5,-40(s0)
    2c30:	cf85                	beqz	a5,2c68 <MAXVAplus+0x4c>
    2c32:	ec26                	sd	s1,24(sp)
    2c34:	e84a                	sd	s2,16(sp)
    2c36:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    2c38:	54fd                	li	s1,-1
    pid = fork();
    2c3a:	63f020ef          	jal	5a78 <fork>
    if(pid < 0){
    2c3e:	02054963          	bltz	a0,2c70 <MAXVAplus+0x54>
    if(pid == 0){
    2c42:	c129                	beqz	a0,2c84 <MAXVAplus+0x68>
    wait(&xstatus);
    2c44:	fd440513          	addi	a0,s0,-44
    2c48:	641020ef          	jal	5a88 <wait>
    if(xstatus != -1)  // did kernel kill child?
    2c4c:	fd442783          	lw	a5,-44(s0)
    2c50:	04979c63          	bne	a5,s1,2ca8 <MAXVAplus+0x8c>
  for( ; a != 0; a <<= 1){
    2c54:	fd843783          	ld	a5,-40(s0)
    2c58:	0786                	slli	a5,a5,0x1
    2c5a:	fcf43c23          	sd	a5,-40(s0)
    2c5e:	fd843783          	ld	a5,-40(s0)
    2c62:	ffe1                	bnez	a5,2c3a <MAXVAplus+0x1e>
    2c64:	64e2                	ld	s1,24(sp)
    2c66:	6942                	ld	s2,16(sp)
}
    2c68:	70a2                	ld	ra,40(sp)
    2c6a:	7402                	ld	s0,32(sp)
    2c6c:	6145                	addi	sp,sp,48
    2c6e:	8082                	ret
      printf("%s: fork failed\n", s);
    2c70:	85ca                	mv	a1,s2
    2c72:	00005517          	auipc	a0,0x5
    2c76:	c5650513          	addi	a0,a0,-938 # 78c8 <malloc+0x1934>
    2c7a:	266030ef          	jal	5ee0 <printf>
      exit(1);
    2c7e:	4505                	li	a0,1
    2c80:	601020ef          	jal	5a80 <exit>
      *(char*)a = 99;
    2c84:	fd843783          	ld	a5,-40(s0)
    2c88:	06300713          	li	a4,99
    2c8c:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    2c90:	fd843603          	ld	a2,-40(s0)
    2c94:	85ca                	mv	a1,s2
    2c96:	00005517          	auipc	a0,0x5
    2c9a:	f2250513          	addi	a0,a0,-222 # 7bb8 <malloc+0x1c24>
    2c9e:	242030ef          	jal	5ee0 <printf>
      exit(1);
    2ca2:	4505                	li	a0,1
    2ca4:	5dd020ef          	jal	5a80 <exit>
      exit(1);
    2ca8:	4505                	li	a0,1
    2caa:	5d7020ef          	jal	5a80 <exit>

0000000000002cae <stacktest>:
{
    2cae:	7179                	addi	sp,sp,-48
    2cb0:	f406                	sd	ra,40(sp)
    2cb2:	f022                	sd	s0,32(sp)
    2cb4:	ec26                	sd	s1,24(sp)
    2cb6:	1800                	addi	s0,sp,48
    2cb8:	84aa                	mv	s1,a0
  pid = fork();
    2cba:	5bf020ef          	jal	5a78 <fork>
  if(pid == 0) {
    2cbe:	cd11                	beqz	a0,2cda <stacktest+0x2c>
  } else if(pid < 0){
    2cc0:	02054c63          	bltz	a0,2cf8 <stacktest+0x4a>
  wait(&xstatus);
    2cc4:	fdc40513          	addi	a0,s0,-36
    2cc8:	5c1020ef          	jal	5a88 <wait>
  if(xstatus == -1)  // kernel killed child?
    2ccc:	fdc42503          	lw	a0,-36(s0)
    2cd0:	57fd                	li	a5,-1
    2cd2:	02f50d63          	beq	a0,a5,2d0c <stacktest+0x5e>
    exit(xstatus);
    2cd6:	5ab020ef          	jal	5a80 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    2cda:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    2cdc:	77fd                	lui	a5,0xfffff
    2cde:	97ba                	add	a5,a5,a4
    2ce0:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffeef58>
    2ce4:	85a6                	mv	a1,s1
    2ce6:	00005517          	auipc	a0,0x5
    2cea:	eea50513          	addi	a0,a0,-278 # 7bd0 <malloc+0x1c3c>
    2cee:	1f2030ef          	jal	5ee0 <printf>
    exit(1);
    2cf2:	4505                	li	a0,1
    2cf4:	58d020ef          	jal	5a80 <exit>
    printf("%s: fork failed\n", s);
    2cf8:	85a6                	mv	a1,s1
    2cfa:	00005517          	auipc	a0,0x5
    2cfe:	bce50513          	addi	a0,a0,-1074 # 78c8 <malloc+0x1934>
    2d02:	1de030ef          	jal	5ee0 <printf>
    exit(1);
    2d06:	4505                	li	a0,1
    2d08:	579020ef          	jal	5a80 <exit>
    exit(0);
    2d0c:	4501                	li	a0,0
    2d0e:	573020ef          	jal	5a80 <exit>

0000000000002d12 <nowrite>:
{
    2d12:	7159                	addi	sp,sp,-112
    2d14:	f486                	sd	ra,104(sp)
    2d16:	f0a2                	sd	s0,96(sp)
    2d18:	eca6                	sd	s1,88(sp)
    2d1a:	e8ca                	sd	s2,80(sp)
    2d1c:	e4ce                	sd	s3,72(sp)
    2d1e:	1880                	addi	s0,sp,112
    2d20:	89aa                	mv	s3,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    2d22:	00006797          	auipc	a5,0x6
    2d26:	67678793          	addi	a5,a5,1654 # 9398 <malloc+0x3404>
    2d2a:	7788                	ld	a0,40(a5)
    2d2c:	7b8c                	ld	a1,48(a5)
    2d2e:	7f90                	ld	a2,56(a5)
    2d30:	63b4                	ld	a3,64(a5)
    2d32:	67b8                	ld	a4,72(a5)
    2d34:	6bbc                	ld	a5,80(a5)
    2d36:	f8a43c23          	sd	a0,-104(s0)
    2d3a:	fab43023          	sd	a1,-96(s0)
    2d3e:	fac43423          	sd	a2,-88(s0)
    2d42:	fad43823          	sd	a3,-80(s0)
    2d46:	fae43c23          	sd	a4,-72(s0)
    2d4a:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    2d4e:	4481                	li	s1,0
    2d50:	4919                	li	s2,6
    pid = fork();
    2d52:	527020ef          	jal	5a78 <fork>
    if(pid == 0) {
    2d56:	c105                	beqz	a0,2d76 <nowrite+0x64>
    } else if(pid < 0){
    2d58:	04054263          	bltz	a0,2d9c <nowrite+0x8a>
    wait(&xstatus);
    2d5c:	fcc40513          	addi	a0,s0,-52
    2d60:	529020ef          	jal	5a88 <wait>
    if(xstatus == 0){
    2d64:	fcc42783          	lw	a5,-52(s0)
    2d68:	c7a1                	beqz	a5,2db0 <nowrite+0x9e>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    2d6a:	2485                	addiw	s1,s1,1
    2d6c:	ff2493e3          	bne	s1,s2,2d52 <nowrite+0x40>
  exit(0);
    2d70:	4501                	li	a0,0
    2d72:	50f020ef          	jal	5a80 <exit>
      volatile int *addr = (int *) addrs[ai];
    2d76:	048e                	slli	s1,s1,0x3
    2d78:	fd048793          	addi	a5,s1,-48
    2d7c:	008784b3          	add	s1,a5,s0
    2d80:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    2d84:	47a9                	li	a5,10
    2d86:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    2d88:	85ce                	mv	a1,s3
    2d8a:	00005517          	auipc	a0,0x5
    2d8e:	e6e50513          	addi	a0,a0,-402 # 7bf8 <malloc+0x1c64>
    2d92:	14e030ef          	jal	5ee0 <printf>
      exit(0);
    2d96:	4501                	li	a0,0
    2d98:	4e9020ef          	jal	5a80 <exit>
      printf("%s: fork failed\n", s);
    2d9c:	85ce                	mv	a1,s3
    2d9e:	00005517          	auipc	a0,0x5
    2da2:	b2a50513          	addi	a0,a0,-1238 # 78c8 <malloc+0x1934>
    2da6:	13a030ef          	jal	5ee0 <printf>
      exit(1);
    2daa:	4505                	li	a0,1
    2dac:	4d5020ef          	jal	5a80 <exit>
      exit(1);
    2db0:	4505                	li	a0,1
    2db2:	4cf020ef          	jal	5a80 <exit>

0000000000002db6 <manywrites>:
{
    2db6:	711d                	addi	sp,sp,-96
    2db8:	ec86                	sd	ra,88(sp)
    2dba:	e8a2                	sd	s0,80(sp)
    2dbc:	e4a6                	sd	s1,72(sp)
    2dbe:	e0ca                	sd	s2,64(sp)
    2dc0:	fc4e                	sd	s3,56(sp)
    2dc2:	f456                	sd	s5,40(sp)
    2dc4:	1080                	addi	s0,sp,96
    2dc6:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    2dc8:	4981                	li	s3,0
    2dca:	4911                	li	s2,4
    int pid = fork();
    2dcc:	4ad020ef          	jal	5a78 <fork>
    2dd0:	84aa                	mv	s1,a0
    if(pid < 0){
    2dd2:	02054963          	bltz	a0,2e04 <manywrites+0x4e>
    if(pid == 0){
    2dd6:	c139                	beqz	a0,2e1c <manywrites+0x66>
  for(int ci = 0; ci < nchildren; ci++){
    2dd8:	2985                	addiw	s3,s3,1
    2dda:	ff2999e3          	bne	s3,s2,2dcc <manywrites+0x16>
    2dde:	f852                	sd	s4,48(sp)
    2de0:	f05a                	sd	s6,32(sp)
    2de2:	ec5e                	sd	s7,24(sp)
    2de4:	4491                	li	s1,4
    int st = 0;
    2de6:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2dea:	fa840513          	addi	a0,s0,-88
    2dee:	49b020ef          	jal	5a88 <wait>
    if(st != 0)
    2df2:	fa842503          	lw	a0,-88(s0)
    2df6:	0c051863          	bnez	a0,2ec6 <manywrites+0x110>
  for(int ci = 0; ci < nchildren; ci++){
    2dfa:	34fd                	addiw	s1,s1,-1
    2dfc:	f4ed                	bnez	s1,2de6 <manywrites+0x30>
  exit(0);
    2dfe:	4501                	li	a0,0
    2e00:	481020ef          	jal	5a80 <exit>
    2e04:	f852                	sd	s4,48(sp)
    2e06:	f05a                	sd	s6,32(sp)
    2e08:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    2e0a:	00006517          	auipc	a0,0x6
    2e0e:	02e50513          	addi	a0,a0,46 # 8e38 <malloc+0x2ea4>
    2e12:	0ce030ef          	jal	5ee0 <printf>
      exit(1);
    2e16:	4505                	li	a0,1
    2e18:	469020ef          	jal	5a80 <exit>
    2e1c:	f852                	sd	s4,48(sp)
    2e1e:	f05a                	sd	s6,32(sp)
    2e20:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    2e22:	06200793          	li	a5,98
    2e26:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2e2a:	0619879b          	addiw	a5,s3,97
    2e2e:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2e32:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    2e36:	fa840513          	addi	a0,s0,-88
    2e3a:	497020ef          	jal	5ad0 <unlink>
    2e3e:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    2e40:	0000ab17          	auipc	s6,0xa
    2e44:	268b0b13          	addi	s6,s6,616 # d0a8 <buf>
        for(int i = 0; i < ci+1; i++){
    2e48:	8a26                	mv	s4,s1
    2e4a:	0209c863          	bltz	s3,2e7a <manywrites+0xc4>
          int fd = open(name, O_CREATE | O_RDWR);
    2e4e:	20200593          	li	a1,514
    2e52:	fa840513          	addi	a0,s0,-88
    2e56:	46b020ef          	jal	5ac0 <open>
    2e5a:	892a                	mv	s2,a0
          if(fd < 0){
    2e5c:	02054d63          	bltz	a0,2e96 <manywrites+0xe0>
          int cc = write(fd, buf, sz);
    2e60:	660d                	lui	a2,0x3
    2e62:	85da                	mv	a1,s6
    2e64:	43d020ef          	jal	5aa0 <write>
          if(cc != sz){
    2e68:	678d                	lui	a5,0x3
    2e6a:	04f51263          	bne	a0,a5,2eae <manywrites+0xf8>
          close(fd);
    2e6e:	854a                	mv	a0,s2
    2e70:	439020ef          	jal	5aa8 <close>
        for(int i = 0; i < ci+1; i++){
    2e74:	2a05                	addiw	s4,s4,1
    2e76:	fd49dce3          	bge	s3,s4,2e4e <manywrites+0x98>
        unlink(name);
    2e7a:	fa840513          	addi	a0,s0,-88
    2e7e:	453020ef          	jal	5ad0 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    2e82:	3bfd                	addiw	s7,s7,-1
    2e84:	fc0b92e3          	bnez	s7,2e48 <manywrites+0x92>
      unlink(name);
    2e88:	fa840513          	addi	a0,s0,-88
    2e8c:	445020ef          	jal	5ad0 <unlink>
      exit(0);
    2e90:	4501                	li	a0,0
    2e92:	3ef020ef          	jal	5a80 <exit>
            printf("%s: cannot create %s\n", s, name);
    2e96:	fa840613          	addi	a2,s0,-88
    2e9a:	85d6                	mv	a1,s5
    2e9c:	00005517          	auipc	a0,0x5
    2ea0:	d7c50513          	addi	a0,a0,-644 # 7c18 <malloc+0x1c84>
    2ea4:	03c030ef          	jal	5ee0 <printf>
            exit(1);
    2ea8:	4505                	li	a0,1
    2eaa:	3d7020ef          	jal	5a80 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2eae:	86aa                	mv	a3,a0
    2eb0:	660d                	lui	a2,0x3
    2eb2:	85d6                	mv	a1,s5
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	25450513          	addi	a0,a0,596 # 7108 <malloc+0x1174>
    2ebc:	024030ef          	jal	5ee0 <printf>
            exit(1);
    2ec0:	4505                	li	a0,1
    2ec2:	3bf020ef          	jal	5a80 <exit>
      exit(st);
    2ec6:	3bb020ef          	jal	5a80 <exit>

0000000000002eca <copyinstr3>:
{
    2eca:	7179                	addi	sp,sp,-48
    2ecc:	f406                	sd	ra,40(sp)
    2ece:	f022                	sd	s0,32(sp)
    2ed0:	ec26                	sd	s1,24(sp)
    2ed2:	1800                	addi	s0,sp,48
  sbrk(8192);
    2ed4:	6509                	lui	a0,0x2
    2ed6:	433020ef          	jal	5b08 <sbrk>
  uint64 top = (uint64) sbrk(0);
    2eda:	4501                	li	a0,0
    2edc:	42d020ef          	jal	5b08 <sbrk>
  if((top % PGSIZE) != 0){
    2ee0:	03451793          	slli	a5,a0,0x34
    2ee4:	e7bd                	bnez	a5,2f52 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    2ee6:	4501                	li	a0,0
    2ee8:	421020ef          	jal	5b08 <sbrk>
  if(top % PGSIZE){
    2eec:	03451793          	slli	a5,a0,0x34
    2ef0:	ebad                	bnez	a5,2f62 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    2ef2:	fff50493          	addi	s1,a0,-1 # 1fff <pgbug+0x2b>
  *b = 'x';
    2ef6:	07800793          	li	a5,120
    2efa:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2efe:	8526                	mv	a0,s1
    2f00:	3d1020ef          	jal	5ad0 <unlink>
  if(ret != -1){
    2f04:	57fd                	li	a5,-1
    2f06:	06f51763          	bne	a0,a5,2f74 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    2f0a:	20100593          	li	a1,513
    2f0e:	8526                	mv	a0,s1
    2f10:	3b1020ef          	jal	5ac0 <open>
  if(fd != -1){
    2f14:	57fd                	li	a5,-1
    2f16:	06f51a63          	bne	a0,a5,2f8a <copyinstr3+0xc0>
  ret = link(b, b);
    2f1a:	85a6                	mv	a1,s1
    2f1c:	8526                	mv	a0,s1
    2f1e:	3c3020ef          	jal	5ae0 <link>
  if(ret != -1){
    2f22:	57fd                	li	a5,-1
    2f24:	06f51e63          	bne	a0,a5,2fa0 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    2f28:	00006797          	auipc	a5,0x6
    2f2c:	9f078793          	addi	a5,a5,-1552 # 8918 <malloc+0x2984>
    2f30:	fcf43823          	sd	a5,-48(s0)
    2f34:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    2f38:	fd040593          	addi	a1,s0,-48
    2f3c:	8526                	mv	a0,s1
    2f3e:	37b020ef          	jal	5ab8 <exec>
  if(ret != -1){
    2f42:	57fd                	li	a5,-1
    2f44:	06f51a63          	bne	a0,a5,2fb8 <copyinstr3+0xee>
}
    2f48:	70a2                	ld	ra,40(sp)
    2f4a:	7402                	ld	s0,32(sp)
    2f4c:	64e2                	ld	s1,24(sp)
    2f4e:	6145                	addi	sp,sp,48
    2f50:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2f52:	0347d513          	srli	a0,a5,0x34
    2f56:	6785                	lui	a5,0x1
    2f58:	40a7853b          	subw	a0,a5,a0
    2f5c:	3ad020ef          	jal	5b08 <sbrk>
    2f60:	b759                	j	2ee6 <copyinstr3+0x1c>
    printf("oops\n");
    2f62:	00005517          	auipc	a0,0x5
    2f66:	cce50513          	addi	a0,a0,-818 # 7c30 <malloc+0x1c9c>
    2f6a:	777020ef          	jal	5ee0 <printf>
    exit(1);
    2f6e:	4505                	li	a0,1
    2f70:	311020ef          	jal	5a80 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2f74:	862a                	mv	a2,a0
    2f76:	85a6                	mv	a1,s1
    2f78:	00005517          	auipc	a0,0x5
    2f7c:	87050513          	addi	a0,a0,-1936 # 77e8 <malloc+0x1854>
    2f80:	761020ef          	jal	5ee0 <printf>
    exit(1);
    2f84:	4505                	li	a0,1
    2f86:	2fb020ef          	jal	5a80 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2f8a:	862a                	mv	a2,a0
    2f8c:	85a6                	mv	a1,s1
    2f8e:	00005517          	auipc	a0,0x5
    2f92:	87a50513          	addi	a0,a0,-1926 # 7808 <malloc+0x1874>
    2f96:	74b020ef          	jal	5ee0 <printf>
    exit(1);
    2f9a:	4505                	li	a0,1
    2f9c:	2e5020ef          	jal	5a80 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    2fa0:	86aa                	mv	a3,a0
    2fa2:	8626                	mv	a2,s1
    2fa4:	85a6                	mv	a1,s1
    2fa6:	00005517          	auipc	a0,0x5
    2faa:	88250513          	addi	a0,a0,-1918 # 7828 <malloc+0x1894>
    2fae:	733020ef          	jal	5ee0 <printf>
    exit(1);
    2fb2:	4505                	li	a0,1
    2fb4:	2cd020ef          	jal	5a80 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    2fb8:	567d                	li	a2,-1
    2fba:	85a6                	mv	a1,s1
    2fbc:	00005517          	auipc	a0,0x5
    2fc0:	89450513          	addi	a0,a0,-1900 # 7850 <malloc+0x18bc>
    2fc4:	71d020ef          	jal	5ee0 <printf>
    exit(1);
    2fc8:	4505                	li	a0,1
    2fca:	2b7020ef          	jal	5a80 <exit>

0000000000002fce <rwsbrk>:
{
    2fce:	1101                	addi	sp,sp,-32
    2fd0:	ec06                	sd	ra,24(sp)
    2fd2:	e822                	sd	s0,16(sp)
    2fd4:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2fd6:	6509                	lui	a0,0x2
    2fd8:	331020ef          	jal	5b08 <sbrk>
  if(a == 0xffffffffffffffffLL) {
    2fdc:	57fd                	li	a5,-1
    2fde:	04f50a63          	beq	a0,a5,3032 <rwsbrk+0x64>
    2fe2:	e426                	sd	s1,8(sp)
    2fe4:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    2fe6:	7579                	lui	a0,0xffffe
    2fe8:	321020ef          	jal	5b08 <sbrk>
    2fec:	57fd                	li	a5,-1
    2fee:	04f50d63          	beq	a0,a5,3048 <rwsbrk+0x7a>
    2ff2:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    2ff4:	20100593          	li	a1,513
    2ff8:	00005517          	auipc	a0,0x5
    2ffc:	c7850513          	addi	a0,a0,-904 # 7c70 <malloc+0x1cdc>
    3000:	2c1020ef          	jal	5ac0 <open>
    3004:	892a                	mv	s2,a0
  if(fd < 0){
    3006:	04054b63          	bltz	a0,305c <rwsbrk+0x8e>
  n = write(fd, (void*)(a+4096), 1024);
    300a:	6785                	lui	a5,0x1
    300c:	94be                	add	s1,s1,a5
    300e:	40000613          	li	a2,1024
    3012:	85a6                	mv	a1,s1
    3014:	28d020ef          	jal	5aa0 <write>
    3018:	862a                	mv	a2,a0
  if(n >= 0){
    301a:	04054a63          	bltz	a0,306e <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+4096, n);
    301e:	85a6                	mv	a1,s1
    3020:	00005517          	auipc	a0,0x5
    3024:	c7050513          	addi	a0,a0,-912 # 7c90 <malloc+0x1cfc>
    3028:	6b9020ef          	jal	5ee0 <printf>
    exit(1);
    302c:	4505                	li	a0,1
    302e:	253020ef          	jal	5a80 <exit>
    3032:	e426                	sd	s1,8(sp)
    3034:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    3036:	00005517          	auipc	a0,0x5
    303a:	c0250513          	addi	a0,a0,-1022 # 7c38 <malloc+0x1ca4>
    303e:	6a3020ef          	jal	5ee0 <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	23d020ef          	jal	5a80 <exit>
    3048:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    304a:	00005517          	auipc	a0,0x5
    304e:	c0650513          	addi	a0,a0,-1018 # 7c50 <malloc+0x1cbc>
    3052:	68f020ef          	jal	5ee0 <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	229020ef          	jal	5a80 <exit>
    printf("open(rwsbrk) failed\n");
    305c:	00005517          	auipc	a0,0x5
    3060:	c1c50513          	addi	a0,a0,-996 # 7c78 <malloc+0x1ce4>
    3064:	67d020ef          	jal	5ee0 <printf>
    exit(1);
    3068:	4505                	li	a0,1
    306a:	217020ef          	jal	5a80 <exit>
  close(fd);
    306e:	854a                	mv	a0,s2
    3070:	239020ef          	jal	5aa8 <close>
  unlink("rwsbrk");
    3074:	00005517          	auipc	a0,0x5
    3078:	bfc50513          	addi	a0,a0,-1028 # 7c70 <malloc+0x1cdc>
    307c:	255020ef          	jal	5ad0 <unlink>
  fd = open("README", O_RDONLY);
    3080:	4581                	li	a1,0
    3082:	00004517          	auipc	a0,0x4
    3086:	18e50513          	addi	a0,a0,398 # 7210 <malloc+0x127c>
    308a:	237020ef          	jal	5ac0 <open>
    308e:	892a                	mv	s2,a0
  if(fd < 0){
    3090:	02054363          	bltz	a0,30b6 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+4096), 10);
    3094:	4629                	li	a2,10
    3096:	85a6                	mv	a1,s1
    3098:	201020ef          	jal	5a98 <read>
    309c:	862a                	mv	a2,a0
  if(n >= 0){
    309e:	02054563          	bltz	a0,30c8 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+4096, n);
    30a2:	85a6                	mv	a1,s1
    30a4:	00005517          	auipc	a0,0x5
    30a8:	c1c50513          	addi	a0,a0,-996 # 7cc0 <malloc+0x1d2c>
    30ac:	635020ef          	jal	5ee0 <printf>
    exit(1);
    30b0:	4505                	li	a0,1
    30b2:	1cf020ef          	jal	5a80 <exit>
    printf("open(rwsbrk) failed\n");
    30b6:	00005517          	auipc	a0,0x5
    30ba:	bc250513          	addi	a0,a0,-1086 # 7c78 <malloc+0x1ce4>
    30be:	623020ef          	jal	5ee0 <printf>
    exit(1);
    30c2:	4505                	li	a0,1
    30c4:	1bd020ef          	jal	5a80 <exit>
  close(fd);
    30c8:	854a                	mv	a0,s2
    30ca:	1df020ef          	jal	5aa8 <close>
  exit(0);
    30ce:	4501                	li	a0,0
    30d0:	1b1020ef          	jal	5a80 <exit>

00000000000030d4 <sbrkbasic>:
{
    30d4:	7139                	addi	sp,sp,-64
    30d6:	fc06                	sd	ra,56(sp)
    30d8:	f822                	sd	s0,48(sp)
    30da:	ec4e                	sd	s3,24(sp)
    30dc:	0080                	addi	s0,sp,64
    30de:	89aa                	mv	s3,a0
  pid = fork();
    30e0:	199020ef          	jal	5a78 <fork>
  if(pid < 0){
    30e4:	02054b63          	bltz	a0,311a <sbrkbasic+0x46>
  if(pid == 0){
    30e8:	e939                	bnez	a0,313e <sbrkbasic+0x6a>
    a = sbrk(TOOMUCH);
    30ea:	40000537          	lui	a0,0x40000
    30ee:	21b020ef          	jal	5b08 <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    30f2:	57fd                	li	a5,-1
    30f4:	02f50f63          	beq	a0,a5,3132 <sbrkbasic+0x5e>
    30f8:	f426                	sd	s1,40(sp)
    30fa:	f04a                	sd	s2,32(sp)
    30fc:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    30fe:	400007b7          	lui	a5,0x40000
    3102:	97aa                	add	a5,a5,a0
      *b = 99;
    3104:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    3108:	6705                	lui	a4,0x1
      *b = 99;
    310a:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3ffeff58>
    for(b = a; b < a+TOOMUCH; b += 4096){
    310e:	953a                	add	a0,a0,a4
    3110:	fef51de3          	bne	a0,a5,310a <sbrkbasic+0x36>
    exit(1);
    3114:	4505                	li	a0,1
    3116:	16b020ef          	jal	5a80 <exit>
    311a:	f426                	sd	s1,40(sp)
    311c:	f04a                	sd	s2,32(sp)
    311e:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    3120:	00005517          	auipc	a0,0x5
    3124:	bc850513          	addi	a0,a0,-1080 # 7ce8 <malloc+0x1d54>
    3128:	5b9020ef          	jal	5ee0 <printf>
    exit(1);
    312c:	4505                	li	a0,1
    312e:	153020ef          	jal	5a80 <exit>
    3132:	f426                	sd	s1,40(sp)
    3134:	f04a                	sd	s2,32(sp)
    3136:	e852                	sd	s4,16(sp)
      exit(0);
    3138:	4501                	li	a0,0
    313a:	147020ef          	jal	5a80 <exit>
  wait(&xstatus);
    313e:	fcc40513          	addi	a0,s0,-52
    3142:	147020ef          	jal	5a88 <wait>
  if(xstatus == 1){
    3146:	fcc42703          	lw	a4,-52(s0)
    314a:	4785                	li	a5,1
    314c:	00f70e63          	beq	a4,a5,3168 <sbrkbasic+0x94>
    3150:	f426                	sd	s1,40(sp)
    3152:	f04a                	sd	s2,32(sp)
    3154:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    3156:	4501                	li	a0,0
    3158:	1b1020ef          	jal	5b08 <sbrk>
    315c:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    315e:	4901                	li	s2,0
    3160:	6a05                	lui	s4,0x1
    3162:	388a0a13          	addi	s4,s4,904 # 1388 <badwrite+0x9a>
    3166:	a839                	j	3184 <sbrkbasic+0xb0>
    3168:	f426                	sd	s1,40(sp)
    316a:	f04a                	sd	s2,32(sp)
    316c:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    316e:	85ce                	mv	a1,s3
    3170:	00005517          	auipc	a0,0x5
    3174:	b9850513          	addi	a0,a0,-1128 # 7d08 <malloc+0x1d74>
    3178:	569020ef          	jal	5ee0 <printf>
    exit(1);
    317c:	4505                	li	a0,1
    317e:	103020ef          	jal	5a80 <exit>
    3182:	84be                	mv	s1,a5
    b = sbrk(1);
    3184:	4505                	li	a0,1
    3186:	183020ef          	jal	5b08 <sbrk>
    if(b != a){
    318a:	04951263          	bne	a0,s1,31ce <sbrkbasic+0xfa>
    *b = 1;
    318e:	4785                	li	a5,1
    3190:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    3194:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    3198:	2905                	addiw	s2,s2,1
    319a:	ff4914e3          	bne	s2,s4,3182 <sbrkbasic+0xae>
  pid = fork();
    319e:	0db020ef          	jal	5a78 <fork>
    31a2:	892a                	mv	s2,a0
  if(pid < 0){
    31a4:	04054263          	bltz	a0,31e8 <sbrkbasic+0x114>
  c = sbrk(1);
    31a8:	4505                	li	a0,1
    31aa:	15f020ef          	jal	5b08 <sbrk>
  c = sbrk(1);
    31ae:	4505                	li	a0,1
    31b0:	159020ef          	jal	5b08 <sbrk>
  if(c != a + 1){
    31b4:	0489                	addi	s1,s1,2
    31b6:	04a48363          	beq	s1,a0,31fc <sbrkbasic+0x128>
    printf("%s: sbrk test failed post-fork\n", s);
    31ba:	85ce                	mv	a1,s3
    31bc:	00005517          	auipc	a0,0x5
    31c0:	bac50513          	addi	a0,a0,-1108 # 7d68 <malloc+0x1dd4>
    31c4:	51d020ef          	jal	5ee0 <printf>
    exit(1);
    31c8:	4505                	li	a0,1
    31ca:	0b7020ef          	jal	5a80 <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    31ce:	872a                	mv	a4,a0
    31d0:	86a6                	mv	a3,s1
    31d2:	864a                	mv	a2,s2
    31d4:	85ce                	mv	a1,s3
    31d6:	00005517          	auipc	a0,0x5
    31da:	b5250513          	addi	a0,a0,-1198 # 7d28 <malloc+0x1d94>
    31de:	503020ef          	jal	5ee0 <printf>
      exit(1);
    31e2:	4505                	li	a0,1
    31e4:	09d020ef          	jal	5a80 <exit>
    printf("%s: sbrk test fork failed\n", s);
    31e8:	85ce                	mv	a1,s3
    31ea:	00005517          	auipc	a0,0x5
    31ee:	b5e50513          	addi	a0,a0,-1186 # 7d48 <malloc+0x1db4>
    31f2:	4ef020ef          	jal	5ee0 <printf>
    exit(1);
    31f6:	4505                	li	a0,1
    31f8:	089020ef          	jal	5a80 <exit>
  if(pid == 0)
    31fc:	00091563          	bnez	s2,3206 <sbrkbasic+0x132>
    exit(0);
    3200:	4501                	li	a0,0
    3202:	07f020ef          	jal	5a80 <exit>
  wait(&xstatus);
    3206:	fcc40513          	addi	a0,s0,-52
    320a:	07f020ef          	jal	5a88 <wait>
  exit(xstatus);
    320e:	fcc42503          	lw	a0,-52(s0)
    3212:	06f020ef          	jal	5a80 <exit>

0000000000003216 <sbrkmuch>:
{
    3216:	7179                	addi	sp,sp,-48
    3218:	f406                	sd	ra,40(sp)
    321a:	f022                	sd	s0,32(sp)
    321c:	ec26                	sd	s1,24(sp)
    321e:	e84a                	sd	s2,16(sp)
    3220:	e44e                	sd	s3,8(sp)
    3222:	e052                	sd	s4,0(sp)
    3224:	1800                	addi	s0,sp,48
    3226:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    3228:	4501                	li	a0,0
    322a:	0df020ef          	jal	5b08 <sbrk>
    322e:	892a                	mv	s2,a0
  a = sbrk(0);
    3230:	4501                	li	a0,0
    3232:	0d7020ef          	jal	5b08 <sbrk>
    3236:	84aa                	mv	s1,a0
  p = sbrk(amt);
    3238:	06400537          	lui	a0,0x6400
    323c:	9d05                	subw	a0,a0,s1
    323e:	0cb020ef          	jal	5b08 <sbrk>
  if (p != a) {
    3242:	0aa49463          	bne	s1,a0,32ea <sbrkmuch+0xd4>
  char *eee = sbrk(0);
    3246:	4501                	li	a0,0
    3248:	0c1020ef          	jal	5b08 <sbrk>
    324c:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    324e:	00a4f963          	bgeu	s1,a0,3260 <sbrkmuch+0x4a>
    *pp = 1;
    3252:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    3254:	6705                	lui	a4,0x1
    *pp = 1;
    3256:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    325a:	94ba                	add	s1,s1,a4
    325c:	fef4ede3          	bltu	s1,a5,3256 <sbrkmuch+0x40>
  *lastaddr = 99;
    3260:	064007b7          	lui	a5,0x6400
    3264:	06300713          	li	a4,99
    3268:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63eff57>
  a = sbrk(0);
    326c:	4501                	li	a0,0
    326e:	09b020ef          	jal	5b08 <sbrk>
    3272:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    3274:	757d                	lui	a0,0xfffff
    3276:	093020ef          	jal	5b08 <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    327a:	57fd                	li	a5,-1
    327c:	08f50163          	beq	a0,a5,32fe <sbrkmuch+0xe8>
  c = sbrk(0);
    3280:	4501                	li	a0,0
    3282:	087020ef          	jal	5b08 <sbrk>
  if(c != a - PGSIZE){
    3286:	77fd                	lui	a5,0xfffff
    3288:	97a6                	add	a5,a5,s1
    328a:	08f51463          	bne	a0,a5,3312 <sbrkmuch+0xfc>
  a = sbrk(0);
    328e:	4501                	li	a0,0
    3290:	079020ef          	jal	5b08 <sbrk>
    3294:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    3296:	6505                	lui	a0,0x1
    3298:	071020ef          	jal	5b08 <sbrk>
    329c:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    329e:	08a49663          	bne	s1,a0,332a <sbrkmuch+0x114>
    32a2:	4501                	li	a0,0
    32a4:	065020ef          	jal	5b08 <sbrk>
    32a8:	6785                	lui	a5,0x1
    32aa:	97a6                	add	a5,a5,s1
    32ac:	06f51f63          	bne	a0,a5,332a <sbrkmuch+0x114>
  if(*lastaddr == 99){
    32b0:	064007b7          	lui	a5,0x6400
    32b4:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63eff57>
    32b8:	06300793          	li	a5,99
    32bc:	08f70363          	beq	a4,a5,3342 <sbrkmuch+0x12c>
  a = sbrk(0);
    32c0:	4501                	li	a0,0
    32c2:	047020ef          	jal	5b08 <sbrk>
    32c6:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    32c8:	4501                	li	a0,0
    32ca:	03f020ef          	jal	5b08 <sbrk>
    32ce:	40a9053b          	subw	a0,s2,a0
    32d2:	037020ef          	jal	5b08 <sbrk>
  if(c != a){
    32d6:	08a49063          	bne	s1,a0,3356 <sbrkmuch+0x140>
}
    32da:	70a2                	ld	ra,40(sp)
    32dc:	7402                	ld	s0,32(sp)
    32de:	64e2                	ld	s1,24(sp)
    32e0:	6942                	ld	s2,16(sp)
    32e2:	69a2                	ld	s3,8(sp)
    32e4:	6a02                	ld	s4,0(sp)
    32e6:	6145                	addi	sp,sp,48
    32e8:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    32ea:	85ce                	mv	a1,s3
    32ec:	00005517          	auipc	a0,0x5
    32f0:	a9c50513          	addi	a0,a0,-1380 # 7d88 <malloc+0x1df4>
    32f4:	3ed020ef          	jal	5ee0 <printf>
    exit(1);
    32f8:	4505                	li	a0,1
    32fa:	786020ef          	jal	5a80 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    32fe:	85ce                	mv	a1,s3
    3300:	00005517          	auipc	a0,0x5
    3304:	ad050513          	addi	a0,a0,-1328 # 7dd0 <malloc+0x1e3c>
    3308:	3d9020ef          	jal	5ee0 <printf>
    exit(1);
    330c:	4505                	li	a0,1
    330e:	772020ef          	jal	5a80 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    3312:	86aa                	mv	a3,a0
    3314:	8626                	mv	a2,s1
    3316:	85ce                	mv	a1,s3
    3318:	00005517          	auipc	a0,0x5
    331c:	ad850513          	addi	a0,a0,-1320 # 7df0 <malloc+0x1e5c>
    3320:	3c1020ef          	jal	5ee0 <printf>
    exit(1);
    3324:	4505                	li	a0,1
    3326:	75a020ef          	jal	5a80 <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    332a:	86d2                	mv	a3,s4
    332c:	8626                	mv	a2,s1
    332e:	85ce                	mv	a1,s3
    3330:	00005517          	auipc	a0,0x5
    3334:	b0050513          	addi	a0,a0,-1280 # 7e30 <malloc+0x1e9c>
    3338:	3a9020ef          	jal	5ee0 <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	742020ef          	jal	5a80 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    3342:	85ce                	mv	a1,s3
    3344:	00005517          	auipc	a0,0x5
    3348:	b1c50513          	addi	a0,a0,-1252 # 7e60 <malloc+0x1ecc>
    334c:	395020ef          	jal	5ee0 <printf>
    exit(1);
    3350:	4505                	li	a0,1
    3352:	72e020ef          	jal	5a80 <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    3356:	86aa                	mv	a3,a0
    3358:	8626                	mv	a2,s1
    335a:	85ce                	mv	a1,s3
    335c:	00005517          	auipc	a0,0x5
    3360:	b3c50513          	addi	a0,a0,-1220 # 7e98 <malloc+0x1f04>
    3364:	37d020ef          	jal	5ee0 <printf>
    exit(1);
    3368:	4505                	li	a0,1
    336a:	716020ef          	jal	5a80 <exit>

000000000000336e <sbrkarg>:
{
    336e:	7179                	addi	sp,sp,-48
    3370:	f406                	sd	ra,40(sp)
    3372:	f022                	sd	s0,32(sp)
    3374:	ec26                	sd	s1,24(sp)
    3376:	e84a                	sd	s2,16(sp)
    3378:	e44e                	sd	s3,8(sp)
    337a:	1800                	addi	s0,sp,48
    337c:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    337e:	6505                	lui	a0,0x1
    3380:	788020ef          	jal	5b08 <sbrk>
    3384:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    3386:	20100593          	li	a1,513
    338a:	00005517          	auipc	a0,0x5
    338e:	b3650513          	addi	a0,a0,-1226 # 7ec0 <malloc+0x1f2c>
    3392:	72e020ef          	jal	5ac0 <open>
    3396:	84aa                	mv	s1,a0
  unlink("sbrk");
    3398:	00005517          	auipc	a0,0x5
    339c:	b2850513          	addi	a0,a0,-1240 # 7ec0 <malloc+0x1f2c>
    33a0:	730020ef          	jal	5ad0 <unlink>
  if(fd < 0)  {
    33a4:	0204c963          	bltz	s1,33d6 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    33a8:	6605                	lui	a2,0x1
    33aa:	85ca                	mv	a1,s2
    33ac:	8526                	mv	a0,s1
    33ae:	6f2020ef          	jal	5aa0 <write>
    33b2:	02054c63          	bltz	a0,33ea <sbrkarg+0x7c>
  close(fd);
    33b6:	8526                	mv	a0,s1
    33b8:	6f0020ef          	jal	5aa8 <close>
  a = sbrk(PGSIZE);
    33bc:	6505                	lui	a0,0x1
    33be:	74a020ef          	jal	5b08 <sbrk>
  if(pipe((int *) a) != 0){
    33c2:	6ce020ef          	jal	5a90 <pipe>
    33c6:	ed05                	bnez	a0,33fe <sbrkarg+0x90>
}
    33c8:	70a2                	ld	ra,40(sp)
    33ca:	7402                	ld	s0,32(sp)
    33cc:	64e2                	ld	s1,24(sp)
    33ce:	6942                	ld	s2,16(sp)
    33d0:	69a2                	ld	s3,8(sp)
    33d2:	6145                	addi	sp,sp,48
    33d4:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    33d6:	85ce                	mv	a1,s3
    33d8:	00005517          	auipc	a0,0x5
    33dc:	af050513          	addi	a0,a0,-1296 # 7ec8 <malloc+0x1f34>
    33e0:	301020ef          	jal	5ee0 <printf>
    exit(1);
    33e4:	4505                	li	a0,1
    33e6:	69a020ef          	jal	5a80 <exit>
    printf("%s: write sbrk failed\n", s);
    33ea:	85ce                	mv	a1,s3
    33ec:	00005517          	auipc	a0,0x5
    33f0:	af450513          	addi	a0,a0,-1292 # 7ee0 <malloc+0x1f4c>
    33f4:	2ed020ef          	jal	5ee0 <printf>
    exit(1);
    33f8:	4505                	li	a0,1
    33fa:	686020ef          	jal	5a80 <exit>
    printf("%s: pipe() failed\n", s);
    33fe:	85ce                	mv	a1,s3
    3400:	00004517          	auipc	a0,0x4
    3404:	5d050513          	addi	a0,a0,1488 # 79d0 <malloc+0x1a3c>
    3408:	2d9020ef          	jal	5ee0 <printf>
    exit(1);
    340c:	4505                	li	a0,1
    340e:	672020ef          	jal	5a80 <exit>

0000000000003412 <argptest>:
{
    3412:	1101                	addi	sp,sp,-32
    3414:	ec06                	sd	ra,24(sp)
    3416:	e822                	sd	s0,16(sp)
    3418:	e426                	sd	s1,8(sp)
    341a:	e04a                	sd	s2,0(sp)
    341c:	1000                	addi	s0,sp,32
    341e:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    3420:	4581                	li	a1,0
    3422:	00005517          	auipc	a0,0x5
    3426:	ad650513          	addi	a0,a0,-1322 # 7ef8 <malloc+0x1f64>
    342a:	696020ef          	jal	5ac0 <open>
  if (fd < 0) {
    342e:	02054563          	bltz	a0,3458 <argptest+0x46>
    3432:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    3434:	4501                	li	a0,0
    3436:	6d2020ef          	jal	5b08 <sbrk>
    343a:	567d                	li	a2,-1
    343c:	fff50593          	addi	a1,a0,-1
    3440:	8526                	mv	a0,s1
    3442:	656020ef          	jal	5a98 <read>
  close(fd);
    3446:	8526                	mv	a0,s1
    3448:	660020ef          	jal	5aa8 <close>
}
    344c:	60e2                	ld	ra,24(sp)
    344e:	6442                	ld	s0,16(sp)
    3450:	64a2                	ld	s1,8(sp)
    3452:	6902                	ld	s2,0(sp)
    3454:	6105                	addi	sp,sp,32
    3456:	8082                	ret
    printf("%s: open failed\n", s);
    3458:	85ca                	mv	a1,s2
    345a:	00004517          	auipc	a0,0x4
    345e:	48650513          	addi	a0,a0,1158 # 78e0 <malloc+0x194c>
    3462:	27f020ef          	jal	5ee0 <printf>
    exit(1);
    3466:	4505                	li	a0,1
    3468:	618020ef          	jal	5a80 <exit>

000000000000346c <sbrkbugs>:
{
    346c:	1141                	addi	sp,sp,-16
    346e:	e406                	sd	ra,8(sp)
    3470:	e022                	sd	s0,0(sp)
    3472:	0800                	addi	s0,sp,16
  int pid = fork();
    3474:	604020ef          	jal	5a78 <fork>
  if(pid < 0){
    3478:	00054c63          	bltz	a0,3490 <sbrkbugs+0x24>
  if(pid == 0){
    347c:	e11d                	bnez	a0,34a2 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    347e:	68a020ef          	jal	5b08 <sbrk>
    sbrk(-sz);
    3482:	40a0053b          	negw	a0,a0
    3486:	682020ef          	jal	5b08 <sbrk>
    exit(0);
    348a:	4501                	li	a0,0
    348c:	5f4020ef          	jal	5a80 <exit>
    printf("fork failed\n");
    3490:	00006517          	auipc	a0,0x6
    3494:	9a850513          	addi	a0,a0,-1624 # 8e38 <malloc+0x2ea4>
    3498:	249020ef          	jal	5ee0 <printf>
    exit(1);
    349c:	4505                	li	a0,1
    349e:	5e2020ef          	jal	5a80 <exit>
  wait(0);
    34a2:	4501                	li	a0,0
    34a4:	5e4020ef          	jal	5a88 <wait>
  pid = fork();
    34a8:	5d0020ef          	jal	5a78 <fork>
  if(pid < 0){
    34ac:	00054f63          	bltz	a0,34ca <sbrkbugs+0x5e>
  if(pid == 0){
    34b0:	e515                	bnez	a0,34dc <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    34b2:	656020ef          	jal	5b08 <sbrk>
    sbrk(-(sz - 3500));
    34b6:	6785                	lui	a5,0x1
    34b8:	dac7879b          	addiw	a5,a5,-596 # dac <copyinstr1-0x254>
    34bc:	40a7853b          	subw	a0,a5,a0
    34c0:	648020ef          	jal	5b08 <sbrk>
    exit(0);
    34c4:	4501                	li	a0,0
    34c6:	5ba020ef          	jal	5a80 <exit>
    printf("fork failed\n");
    34ca:	00006517          	auipc	a0,0x6
    34ce:	96e50513          	addi	a0,a0,-1682 # 8e38 <malloc+0x2ea4>
    34d2:	20f020ef          	jal	5ee0 <printf>
    exit(1);
    34d6:	4505                	li	a0,1
    34d8:	5a8020ef          	jal	5a80 <exit>
  wait(0);
    34dc:	4501                	li	a0,0
    34de:	5aa020ef          	jal	5a88 <wait>
  pid = fork();
    34e2:	596020ef          	jal	5a78 <fork>
  if(pid < 0){
    34e6:	02054263          	bltz	a0,350a <sbrkbugs+0x9e>
  if(pid == 0){
    34ea:	e90d                	bnez	a0,351c <sbrkbugs+0xb0>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    34ec:	61c020ef          	jal	5b08 <sbrk>
    34f0:	67ad                	lui	a5,0xb
    34f2:	8007879b          	addiw	a5,a5,-2048 # a800 <big.0+0xe70>
    34f6:	40a7853b          	subw	a0,a5,a0
    34fa:	60e020ef          	jal	5b08 <sbrk>
    sbrk(-10);
    34fe:	5559                	li	a0,-10
    3500:	608020ef          	jal	5b08 <sbrk>
    exit(0);
    3504:	4501                	li	a0,0
    3506:	57a020ef          	jal	5a80 <exit>
    printf("fork failed\n");
    350a:	00006517          	auipc	a0,0x6
    350e:	92e50513          	addi	a0,a0,-1746 # 8e38 <malloc+0x2ea4>
    3512:	1cf020ef          	jal	5ee0 <printf>
    exit(1);
    3516:	4505                	li	a0,1
    3518:	568020ef          	jal	5a80 <exit>
  wait(0);
    351c:	4501                	li	a0,0
    351e:	56a020ef          	jal	5a88 <wait>
  exit(0);
    3522:	4501                	li	a0,0
    3524:	55c020ef          	jal	5a80 <exit>

0000000000003528 <sbrklast>:
{
    3528:	7179                	addi	sp,sp,-48
    352a:	f406                	sd	ra,40(sp)
    352c:	f022                	sd	s0,32(sp)
    352e:	ec26                	sd	s1,24(sp)
    3530:	e84a                	sd	s2,16(sp)
    3532:	e44e                	sd	s3,8(sp)
    3534:	e052                	sd	s4,0(sp)
    3536:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    3538:	4501                	li	a0,0
    353a:	5ce020ef          	jal	5b08 <sbrk>
  if((top % 4096) != 0)
    353e:	03451793          	slli	a5,a0,0x34
    3542:	ebad                	bnez	a5,35b4 <sbrklast+0x8c>
  sbrk(4096);
    3544:	6505                	lui	a0,0x1
    3546:	5c2020ef          	jal	5b08 <sbrk>
  sbrk(10);
    354a:	4529                	li	a0,10
    354c:	5bc020ef          	jal	5b08 <sbrk>
  sbrk(-20);
    3550:	5531                	li	a0,-20
    3552:	5b6020ef          	jal	5b08 <sbrk>
  top = (uint64) sbrk(0);
    3556:	4501                	li	a0,0
    3558:	5b0020ef          	jal	5b08 <sbrk>
    355c:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    355e:	fc050913          	addi	s2,a0,-64 # fc0 <copyinstr1-0x40>
  p[0] = 'x';
    3562:	07800a13          	li	s4,120
    3566:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    356a:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    356e:	20200593          	li	a1,514
    3572:	854a                	mv	a0,s2
    3574:	54c020ef          	jal	5ac0 <open>
    3578:	89aa                	mv	s3,a0
  write(fd, p, 1);
    357a:	4605                	li	a2,1
    357c:	85ca                	mv	a1,s2
    357e:	522020ef          	jal	5aa0 <write>
  close(fd);
    3582:	854e                	mv	a0,s3
    3584:	524020ef          	jal	5aa8 <close>
  fd = open(p, O_RDWR);
    3588:	4589                	li	a1,2
    358a:	854a                	mv	a0,s2
    358c:	534020ef          	jal	5ac0 <open>
  p[0] = '\0';
    3590:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    3594:	4605                	li	a2,1
    3596:	85ca                	mv	a1,s2
    3598:	500020ef          	jal	5a98 <read>
  if(p[0] != 'x')
    359c:	fc04c783          	lbu	a5,-64(s1)
    35a0:	03479263          	bne	a5,s4,35c4 <sbrklast+0x9c>
}
    35a4:	70a2                	ld	ra,40(sp)
    35a6:	7402                	ld	s0,32(sp)
    35a8:	64e2                	ld	s1,24(sp)
    35aa:	6942                	ld	s2,16(sp)
    35ac:	69a2                	ld	s3,8(sp)
    35ae:	6a02                	ld	s4,0(sp)
    35b0:	6145                	addi	sp,sp,48
    35b2:	8082                	ret
    sbrk(4096 - (top % 4096));
    35b4:	0347d513          	srli	a0,a5,0x34
    35b8:	6785                	lui	a5,0x1
    35ba:	40a7853b          	subw	a0,a5,a0
    35be:	54a020ef          	jal	5b08 <sbrk>
    35c2:	b749                	j	3544 <sbrklast+0x1c>
    exit(1);
    35c4:	4505                	li	a0,1
    35c6:	4ba020ef          	jal	5a80 <exit>

00000000000035ca <sbrk8000>:
{
    35ca:	1141                	addi	sp,sp,-16
    35cc:	e406                	sd	ra,8(sp)
    35ce:	e022                	sd	s0,0(sp)
    35d0:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    35d2:	80000537          	lui	a0,0x80000
    35d6:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7ffeff5c>
    35d8:	530020ef          	jal	5b08 <sbrk>
  volatile char *top = sbrk(0);
    35dc:	4501                	li	a0,0
    35de:	52a020ef          	jal	5b08 <sbrk>
  *(top-1) = *(top-1) + 1;
    35e2:	fff54783          	lbu	a5,-1(a0)
    35e6:	2785                	addiw	a5,a5,1 # 1001 <copyinstr1+0x1>
    35e8:	0ff7f793          	zext.b	a5,a5
    35ec:	fef50fa3          	sb	a5,-1(a0)
}
    35f0:	60a2                	ld	ra,8(sp)
    35f2:	6402                	ld	s0,0(sp)
    35f4:	0141                	addi	sp,sp,16
    35f6:	8082                	ret

00000000000035f8 <execout>:
{
    35f8:	715d                	addi	sp,sp,-80
    35fa:	e486                	sd	ra,72(sp)
    35fc:	e0a2                	sd	s0,64(sp)
    35fe:	fc26                	sd	s1,56(sp)
    3600:	f84a                	sd	s2,48(sp)
    3602:	f44e                	sd	s3,40(sp)
    3604:	f052                	sd	s4,32(sp)
    3606:	0880                	addi	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    3608:	4901                	li	s2,0
    360a:	49bd                	li	s3,15
    int pid = fork();
    360c:	46c020ef          	jal	5a78 <fork>
    3610:	84aa                	mv	s1,a0
    if(pid < 0){
    3612:	00054c63          	bltz	a0,362a <execout+0x32>
    } else if(pid == 0){
    3616:	c11d                	beqz	a0,363c <execout+0x44>
      wait((int*)0);
    3618:	4501                	li	a0,0
    361a:	46e020ef          	jal	5a88 <wait>
  for(int avail = 0; avail < 15; avail++){
    361e:	2905                	addiw	s2,s2,1
    3620:	ff3916e3          	bne	s2,s3,360c <execout+0x14>
  exit(0);
    3624:	4501                	li	a0,0
    3626:	45a020ef          	jal	5a80 <exit>
      printf("fork failed\n");
    362a:	00006517          	auipc	a0,0x6
    362e:	80e50513          	addi	a0,a0,-2034 # 8e38 <malloc+0x2ea4>
    3632:	0af020ef          	jal	5ee0 <printf>
      exit(1);
    3636:	4505                	li	a0,1
    3638:	448020ef          	jal	5a80 <exit>
        if(a == 0xffffffffffffffffLL)
    363c:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    363e:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    3640:	6505                	lui	a0,0x1
    3642:	4c6020ef          	jal	5b08 <sbrk>
        if(a == 0xffffffffffffffffLL)
    3646:	01350763          	beq	a0,s3,3654 <execout+0x5c>
        *(char*)(a + 4096 - 1) = 1;
    364a:	6785                	lui	a5,0x1
    364c:	97aa                	add	a5,a5,a0
    364e:	ff478fa3          	sb	s4,-1(a5) # fff <copyinstr1-0x1>
      while(1){
    3652:	b7fd                	j	3640 <execout+0x48>
      for(int i = 0; i < avail; i++)
    3654:	01205863          	blez	s2,3664 <execout+0x6c>
        sbrk(-4096);
    3658:	757d                	lui	a0,0xfffff
    365a:	4ae020ef          	jal	5b08 <sbrk>
      for(int i = 0; i < avail; i++)
    365e:	2485                	addiw	s1,s1,1
    3660:	ff249ce3          	bne	s1,s2,3658 <execout+0x60>
      close(1);
    3664:	4505                	li	a0,1
    3666:	442020ef          	jal	5aa8 <close>
      char *args[] = { "echo", "x", 0 };
    366a:	00004517          	auipc	a0,0x4
    366e:	9ce50513          	addi	a0,a0,-1586 # 7038 <malloc+0x10a4>
    3672:	faa43c23          	sd	a0,-72(s0)
    3676:	00004797          	auipc	a5,0x4
    367a:	a3278793          	addi	a5,a5,-1486 # 70a8 <malloc+0x1114>
    367e:	fcf43023          	sd	a5,-64(s0)
    3682:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    3686:	fb840593          	addi	a1,s0,-72
    368a:	42e020ef          	jal	5ab8 <exec>
      exit(0);
    368e:	4501                	li	a0,0
    3690:	3f0020ef          	jal	5a80 <exit>

0000000000003694 <fourteen>:
{
    3694:	1101                	addi	sp,sp,-32
    3696:	ec06                	sd	ra,24(sp)
    3698:	e822                	sd	s0,16(sp)
    369a:	e426                	sd	s1,8(sp)
    369c:	1000                	addi	s0,sp,32
    369e:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    36a0:	00005517          	auipc	a0,0x5
    36a4:	a3050513          	addi	a0,a0,-1488 # 80d0 <malloc+0x213c>
    36a8:	440020ef          	jal	5ae8 <mkdir>
    36ac:	e555                	bnez	a0,3758 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    36ae:	00005517          	auipc	a0,0x5
    36b2:	87a50513          	addi	a0,a0,-1926 # 7f28 <malloc+0x1f94>
    36b6:	432020ef          	jal	5ae8 <mkdir>
    36ba:	e94d                	bnez	a0,376c <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    36bc:	20000593          	li	a1,512
    36c0:	00005517          	auipc	a0,0x5
    36c4:	8c050513          	addi	a0,a0,-1856 # 7f80 <malloc+0x1fec>
    36c8:	3f8020ef          	jal	5ac0 <open>
  if(fd < 0){
    36cc:	0a054a63          	bltz	a0,3780 <fourteen+0xec>
  close(fd);
    36d0:	3d8020ef          	jal	5aa8 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    36d4:	4581                	li	a1,0
    36d6:	00005517          	auipc	a0,0x5
    36da:	92250513          	addi	a0,a0,-1758 # 7ff8 <malloc+0x2064>
    36de:	3e2020ef          	jal	5ac0 <open>
  if(fd < 0){
    36e2:	0a054963          	bltz	a0,3794 <fourteen+0x100>
  close(fd);
    36e6:	3c2020ef          	jal	5aa8 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    36ea:	00005517          	auipc	a0,0x5
    36ee:	97e50513          	addi	a0,a0,-1666 # 8068 <malloc+0x20d4>
    36f2:	3f6020ef          	jal	5ae8 <mkdir>
    36f6:	c94d                	beqz	a0,37a8 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    36f8:	00005517          	auipc	a0,0x5
    36fc:	9c850513          	addi	a0,a0,-1592 # 80c0 <malloc+0x212c>
    3700:	3e8020ef          	jal	5ae8 <mkdir>
    3704:	cd45                	beqz	a0,37bc <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    3706:	00005517          	auipc	a0,0x5
    370a:	9ba50513          	addi	a0,a0,-1606 # 80c0 <malloc+0x212c>
    370e:	3c2020ef          	jal	5ad0 <unlink>
  unlink("12345678901234/12345678901234");
    3712:	00005517          	auipc	a0,0x5
    3716:	95650513          	addi	a0,a0,-1706 # 8068 <malloc+0x20d4>
    371a:	3b6020ef          	jal	5ad0 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    371e:	00005517          	auipc	a0,0x5
    3722:	8da50513          	addi	a0,a0,-1830 # 7ff8 <malloc+0x2064>
    3726:	3aa020ef          	jal	5ad0 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    372a:	00005517          	auipc	a0,0x5
    372e:	85650513          	addi	a0,a0,-1962 # 7f80 <malloc+0x1fec>
    3732:	39e020ef          	jal	5ad0 <unlink>
  unlink("12345678901234/123456789012345");
    3736:	00004517          	auipc	a0,0x4
    373a:	7f250513          	addi	a0,a0,2034 # 7f28 <malloc+0x1f94>
    373e:	392020ef          	jal	5ad0 <unlink>
  unlink("12345678901234");
    3742:	00005517          	auipc	a0,0x5
    3746:	98e50513          	addi	a0,a0,-1650 # 80d0 <malloc+0x213c>
    374a:	386020ef          	jal	5ad0 <unlink>
}
    374e:	60e2                	ld	ra,24(sp)
    3750:	6442                	ld	s0,16(sp)
    3752:	64a2                	ld	s1,8(sp)
    3754:	6105                	addi	sp,sp,32
    3756:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    3758:	85a6                	mv	a1,s1
    375a:	00004517          	auipc	a0,0x4
    375e:	7a650513          	addi	a0,a0,1958 # 7f00 <malloc+0x1f6c>
    3762:	77e020ef          	jal	5ee0 <printf>
    exit(1);
    3766:	4505                	li	a0,1
    3768:	318020ef          	jal	5a80 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    376c:	85a6                	mv	a1,s1
    376e:	00004517          	auipc	a0,0x4
    3772:	7da50513          	addi	a0,a0,2010 # 7f48 <malloc+0x1fb4>
    3776:	76a020ef          	jal	5ee0 <printf>
    exit(1);
    377a:	4505                	li	a0,1
    377c:	304020ef          	jal	5a80 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    3780:	85a6                	mv	a1,s1
    3782:	00005517          	auipc	a0,0x5
    3786:	82e50513          	addi	a0,a0,-2002 # 7fb0 <malloc+0x201c>
    378a:	756020ef          	jal	5ee0 <printf>
    exit(1);
    378e:	4505                	li	a0,1
    3790:	2f0020ef          	jal	5a80 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    3794:	85a6                	mv	a1,s1
    3796:	00005517          	auipc	a0,0x5
    379a:	89250513          	addi	a0,a0,-1902 # 8028 <malloc+0x2094>
    379e:	742020ef          	jal	5ee0 <printf>
    exit(1);
    37a2:	4505                	li	a0,1
    37a4:	2dc020ef          	jal	5a80 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    37a8:	85a6                	mv	a1,s1
    37aa:	00005517          	auipc	a0,0x5
    37ae:	8de50513          	addi	a0,a0,-1826 # 8088 <malloc+0x20f4>
    37b2:	72e020ef          	jal	5ee0 <printf>
    exit(1);
    37b6:	4505                	li	a0,1
    37b8:	2c8020ef          	jal	5a80 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    37bc:	85a6                	mv	a1,s1
    37be:	00005517          	auipc	a0,0x5
    37c2:	92250513          	addi	a0,a0,-1758 # 80e0 <malloc+0x214c>
    37c6:	71a020ef          	jal	5ee0 <printf>
    exit(1);
    37ca:	4505                	li	a0,1
    37cc:	2b4020ef          	jal	5a80 <exit>

00000000000037d0 <diskfull>:
{
    37d0:	b8010113          	addi	sp,sp,-1152
    37d4:	46113c23          	sd	ra,1144(sp)
    37d8:	46813823          	sd	s0,1136(sp)
    37dc:	46913423          	sd	s1,1128(sp)
    37e0:	47213023          	sd	s2,1120(sp)
    37e4:	45313c23          	sd	s3,1112(sp)
    37e8:	45413823          	sd	s4,1104(sp)
    37ec:	45513423          	sd	s5,1096(sp)
    37f0:	45613023          	sd	s6,1088(sp)
    37f4:	43713c23          	sd	s7,1080(sp)
    37f8:	43813823          	sd	s8,1072(sp)
    37fc:	43913423          	sd	s9,1064(sp)
    3800:	48010413          	addi	s0,sp,1152
    3804:	8caa                	mv	s9,a0
  unlink("diskfulldir");
    3806:	00005517          	auipc	a0,0x5
    380a:	91250513          	addi	a0,a0,-1774 # 8118 <malloc+0x2184>
    380e:	2c2020ef          	jal	5ad0 <unlink>
    3812:	03000993          	li	s3,48
    name[0] = 'b';
    3816:	06200b13          	li	s6,98
    name[1] = 'i';
    381a:	06900a93          	li	s5,105
    name[2] = 'g';
    381e:	06700a13          	li	s4,103
    3822:	10c00b93          	li	s7,268
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    3826:	07f00c13          	li	s8,127
    382a:	aab9                	j	3988 <diskfull+0x1b8>
      printf("%s: could not create file %s\n", s, name);
    382c:	b8040613          	addi	a2,s0,-1152
    3830:	85e6                	mv	a1,s9
    3832:	00005517          	auipc	a0,0x5
    3836:	8f650513          	addi	a0,a0,-1802 # 8128 <malloc+0x2194>
    383a:	6a6020ef          	jal	5ee0 <printf>
      break;
    383e:	a039                	j	384c <diskfull+0x7c>
        close(fd);
    3840:	854a                	mv	a0,s2
    3842:	266020ef          	jal	5aa8 <close>
    close(fd);
    3846:	854a                	mv	a0,s2
    3848:	260020ef          	jal	5aa8 <close>
  for(int i = 0; i < nzz; i++){
    384c:	4481                	li	s1,0
    name[0] = 'z';
    384e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    3852:	08000993          	li	s3,128
    name[0] = 'z';
    3856:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    385a:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    385e:	41f4d71b          	sraiw	a4,s1,0x1f
    3862:	01b7571b          	srliw	a4,a4,0x1b
    3866:	009707bb          	addw	a5,a4,s1
    386a:	4057d69b          	sraiw	a3,a5,0x5
    386e:	0306869b          	addiw	a3,a3,48
    3872:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    3876:	8bfd                	andi	a5,a5,31
    3878:	9f99                	subw	a5,a5,a4
    387a:	0307879b          	addiw	a5,a5,48
    387e:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    3882:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3886:	ba040513          	addi	a0,s0,-1120
    388a:	246020ef          	jal	5ad0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    388e:	60200593          	li	a1,1538
    3892:	ba040513          	addi	a0,s0,-1120
    3896:	22a020ef          	jal	5ac0 <open>
    if(fd < 0)
    389a:	00054763          	bltz	a0,38a8 <diskfull+0xd8>
    close(fd);
    389e:	20a020ef          	jal	5aa8 <close>
  for(int i = 0; i < nzz; i++){
    38a2:	2485                	addiw	s1,s1,1
    38a4:	fb3499e3          	bne	s1,s3,3856 <diskfull+0x86>
  if(mkdir("diskfulldir") == 0)
    38a8:	00005517          	auipc	a0,0x5
    38ac:	87050513          	addi	a0,a0,-1936 # 8118 <malloc+0x2184>
    38b0:	238020ef          	jal	5ae8 <mkdir>
    38b4:	12050063          	beqz	a0,39d4 <diskfull+0x204>
  unlink("diskfulldir");
    38b8:	00005517          	auipc	a0,0x5
    38bc:	86050513          	addi	a0,a0,-1952 # 8118 <malloc+0x2184>
    38c0:	210020ef          	jal	5ad0 <unlink>
  for(int i = 0; i < nzz; i++){
    38c4:	4481                	li	s1,0
    name[0] = 'z';
    38c6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    38ca:	08000993          	li	s3,128
    name[0] = 'z';
    38ce:	bb240023          	sb	s2,-1120(s0)
    name[1] = 'z';
    38d2:	bb2400a3          	sb	s2,-1119(s0)
    name[2] = '0' + (i / 32);
    38d6:	41f4d71b          	sraiw	a4,s1,0x1f
    38da:	01b7571b          	srliw	a4,a4,0x1b
    38de:	009707bb          	addw	a5,a4,s1
    38e2:	4057d69b          	sraiw	a3,a5,0x5
    38e6:	0306869b          	addiw	a3,a3,48
    38ea:	bad40123          	sb	a3,-1118(s0)
    name[3] = '0' + (i % 32);
    38ee:	8bfd                	andi	a5,a5,31
    38f0:	9f99                	subw	a5,a5,a4
    38f2:	0307879b          	addiw	a5,a5,48
    38f6:	baf401a3          	sb	a5,-1117(s0)
    name[4] = '\0';
    38fa:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    38fe:	ba040513          	addi	a0,s0,-1120
    3902:	1ce020ef          	jal	5ad0 <unlink>
  for(int i = 0; i < nzz; i++){
    3906:	2485                	addiw	s1,s1,1
    3908:	fd3493e3          	bne	s1,s3,38ce <diskfull+0xfe>
    390c:	03000493          	li	s1,48
    name[0] = 'b';
    3910:	06200a93          	li	s5,98
    name[1] = 'i';
    3914:	06900a13          	li	s4,105
    name[2] = 'g';
    3918:	06700993          	li	s3,103
  for(int i = 0; '0' + i < 0177; i++){
    391c:	07f00913          	li	s2,127
    name[0] = 'b';
    3920:	bb540023          	sb	s5,-1120(s0)
    name[1] = 'i';
    3924:	bb4400a3          	sb	s4,-1119(s0)
    name[2] = 'g';
    3928:	bb340123          	sb	s3,-1118(s0)
    name[3] = '0' + i;
    392c:	ba9401a3          	sb	s1,-1117(s0)
    name[4] = '\0';
    3930:	ba040223          	sb	zero,-1116(s0)
    unlink(name);
    3934:	ba040513          	addi	a0,s0,-1120
    3938:	198020ef          	jal	5ad0 <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    393c:	2485                	addiw	s1,s1,1
    393e:	0ff4f493          	zext.b	s1,s1
    3942:	fd249fe3          	bne	s1,s2,3920 <diskfull+0x150>
}
    3946:	47813083          	ld	ra,1144(sp)
    394a:	47013403          	ld	s0,1136(sp)
    394e:	46813483          	ld	s1,1128(sp)
    3952:	46013903          	ld	s2,1120(sp)
    3956:	45813983          	ld	s3,1112(sp)
    395a:	45013a03          	ld	s4,1104(sp)
    395e:	44813a83          	ld	s5,1096(sp)
    3962:	44013b03          	ld	s6,1088(sp)
    3966:	43813b83          	ld	s7,1080(sp)
    396a:	43013c03          	ld	s8,1072(sp)
    396e:	42813c83          	ld	s9,1064(sp)
    3972:	48010113          	addi	sp,sp,1152
    3976:	8082                	ret
    close(fd);
    3978:	854a                	mv	a0,s2
    397a:	12e020ef          	jal	5aa8 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    397e:	2985                	addiw	s3,s3,1
    3980:	0ff9f993          	zext.b	s3,s3
    3984:	ed8984e3          	beq	s3,s8,384c <diskfull+0x7c>
    name[0] = 'b';
    3988:	b9640023          	sb	s6,-1152(s0)
    name[1] = 'i';
    398c:	b95400a3          	sb	s5,-1151(s0)
    name[2] = 'g';
    3990:	b9440123          	sb	s4,-1150(s0)
    name[3] = '0' + fi;
    3994:	b93401a3          	sb	s3,-1149(s0)
    name[4] = '\0';
    3998:	b8040223          	sb	zero,-1148(s0)
    unlink(name);
    399c:	b8040513          	addi	a0,s0,-1152
    39a0:	130020ef          	jal	5ad0 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    39a4:	60200593          	li	a1,1538
    39a8:	b8040513          	addi	a0,s0,-1152
    39ac:	114020ef          	jal	5ac0 <open>
    39b0:	892a                	mv	s2,a0
    if(fd < 0){
    39b2:	e6054de3          	bltz	a0,382c <diskfull+0x5c>
    39b6:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    39b8:	40000613          	li	a2,1024
    39bc:	ba040593          	addi	a1,s0,-1120
    39c0:	854a                	mv	a0,s2
    39c2:	0de020ef          	jal	5aa0 <write>
    39c6:	40000793          	li	a5,1024
    39ca:	e6f51be3          	bne	a0,a5,3840 <diskfull+0x70>
    for(int i = 0; i < MAXFILE; i++){
    39ce:	34fd                	addiw	s1,s1,-1
    39d0:	f4e5                	bnez	s1,39b8 <diskfull+0x1e8>
    39d2:	b75d                	j	3978 <diskfull+0x1a8>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    39d4:	85e6                	mv	a1,s9
    39d6:	00004517          	auipc	a0,0x4
    39da:	77250513          	addi	a0,a0,1906 # 8148 <malloc+0x21b4>
    39de:	502020ef          	jal	5ee0 <printf>
    39e2:	bdd9                	j	38b8 <diskfull+0xe8>

00000000000039e4 <iputtest>:
{
    39e4:	1101                	addi	sp,sp,-32
    39e6:	ec06                	sd	ra,24(sp)
    39e8:	e822                	sd	s0,16(sp)
    39ea:	e426                	sd	s1,8(sp)
    39ec:	1000                	addi	s0,sp,32
    39ee:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    39f0:	00004517          	auipc	a0,0x4
    39f4:	78850513          	addi	a0,a0,1928 # 8178 <malloc+0x21e4>
    39f8:	0f0020ef          	jal	5ae8 <mkdir>
    39fc:	02054f63          	bltz	a0,3a3a <iputtest+0x56>
  if(chdir("iputdir") < 0){
    3a00:	00004517          	auipc	a0,0x4
    3a04:	77850513          	addi	a0,a0,1912 # 8178 <malloc+0x21e4>
    3a08:	0e8020ef          	jal	5af0 <chdir>
    3a0c:	04054163          	bltz	a0,3a4e <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    3a10:	00004517          	auipc	a0,0x4
    3a14:	7a850513          	addi	a0,a0,1960 # 81b8 <malloc+0x2224>
    3a18:	0b8020ef          	jal	5ad0 <unlink>
    3a1c:	04054363          	bltz	a0,3a62 <iputtest+0x7e>
  if(chdir("/") < 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	7c850513          	addi	a0,a0,1992 # 81e8 <malloc+0x2254>
    3a28:	0c8020ef          	jal	5af0 <chdir>
    3a2c:	04054563          	bltz	a0,3a76 <iputtest+0x92>
}
    3a30:	60e2                	ld	ra,24(sp)
    3a32:	6442                	ld	s0,16(sp)
    3a34:	64a2                	ld	s1,8(sp)
    3a36:	6105                	addi	sp,sp,32
    3a38:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3a3a:	85a6                	mv	a1,s1
    3a3c:	00004517          	auipc	a0,0x4
    3a40:	74450513          	addi	a0,a0,1860 # 8180 <malloc+0x21ec>
    3a44:	49c020ef          	jal	5ee0 <printf>
    exit(1);
    3a48:	4505                	li	a0,1
    3a4a:	036020ef          	jal	5a80 <exit>
    printf("%s: chdir iputdir failed\n", s);
    3a4e:	85a6                	mv	a1,s1
    3a50:	00004517          	auipc	a0,0x4
    3a54:	74850513          	addi	a0,a0,1864 # 8198 <malloc+0x2204>
    3a58:	488020ef          	jal	5ee0 <printf>
    exit(1);
    3a5c:	4505                	li	a0,1
    3a5e:	022020ef          	jal	5a80 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    3a62:	85a6                	mv	a1,s1
    3a64:	00004517          	auipc	a0,0x4
    3a68:	76450513          	addi	a0,a0,1892 # 81c8 <malloc+0x2234>
    3a6c:	474020ef          	jal	5ee0 <printf>
    exit(1);
    3a70:	4505                	li	a0,1
    3a72:	00e020ef          	jal	5a80 <exit>
    printf("%s: chdir / failed\n", s);
    3a76:	85a6                	mv	a1,s1
    3a78:	00004517          	auipc	a0,0x4
    3a7c:	77850513          	addi	a0,a0,1912 # 81f0 <malloc+0x225c>
    3a80:	460020ef          	jal	5ee0 <printf>
    exit(1);
    3a84:	4505                	li	a0,1
    3a86:	7fb010ef          	jal	5a80 <exit>

0000000000003a8a <exitiputtest>:
{
    3a8a:	7179                	addi	sp,sp,-48
    3a8c:	f406                	sd	ra,40(sp)
    3a8e:	f022                	sd	s0,32(sp)
    3a90:	ec26                	sd	s1,24(sp)
    3a92:	1800                	addi	s0,sp,48
    3a94:	84aa                	mv	s1,a0
  pid = fork();
    3a96:	7e3010ef          	jal	5a78 <fork>
  if(pid < 0){
    3a9a:	02054e63          	bltz	a0,3ad6 <exitiputtest+0x4c>
  if(pid == 0){
    3a9e:	e541                	bnez	a0,3b26 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    3aa0:	00004517          	auipc	a0,0x4
    3aa4:	6d850513          	addi	a0,a0,1752 # 8178 <malloc+0x21e4>
    3aa8:	040020ef          	jal	5ae8 <mkdir>
    3aac:	02054f63          	bltz	a0,3aea <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    3ab0:	00004517          	auipc	a0,0x4
    3ab4:	6c850513          	addi	a0,a0,1736 # 8178 <malloc+0x21e4>
    3ab8:	038020ef          	jal	5af0 <chdir>
    3abc:	04054163          	bltz	a0,3afe <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    3ac0:	00004517          	auipc	a0,0x4
    3ac4:	6f850513          	addi	a0,a0,1784 # 81b8 <malloc+0x2224>
    3ac8:	008020ef          	jal	5ad0 <unlink>
    3acc:	04054363          	bltz	a0,3b12 <exitiputtest+0x88>
    exit(0);
    3ad0:	4501                	li	a0,0
    3ad2:	7af010ef          	jal	5a80 <exit>
    printf("%s: fork failed\n", s);
    3ad6:	85a6                	mv	a1,s1
    3ad8:	00004517          	auipc	a0,0x4
    3adc:	df050513          	addi	a0,a0,-528 # 78c8 <malloc+0x1934>
    3ae0:	400020ef          	jal	5ee0 <printf>
    exit(1);
    3ae4:	4505                	li	a0,1
    3ae6:	79b010ef          	jal	5a80 <exit>
      printf("%s: mkdir failed\n", s);
    3aea:	85a6                	mv	a1,s1
    3aec:	00004517          	auipc	a0,0x4
    3af0:	69450513          	addi	a0,a0,1684 # 8180 <malloc+0x21ec>
    3af4:	3ec020ef          	jal	5ee0 <printf>
      exit(1);
    3af8:	4505                	li	a0,1
    3afa:	787010ef          	jal	5a80 <exit>
      printf("%s: child chdir failed\n", s);
    3afe:	85a6                	mv	a1,s1
    3b00:	00004517          	auipc	a0,0x4
    3b04:	70850513          	addi	a0,a0,1800 # 8208 <malloc+0x2274>
    3b08:	3d8020ef          	jal	5ee0 <printf>
      exit(1);
    3b0c:	4505                	li	a0,1
    3b0e:	773010ef          	jal	5a80 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    3b12:	85a6                	mv	a1,s1
    3b14:	00004517          	auipc	a0,0x4
    3b18:	6b450513          	addi	a0,a0,1716 # 81c8 <malloc+0x2234>
    3b1c:	3c4020ef          	jal	5ee0 <printf>
      exit(1);
    3b20:	4505                	li	a0,1
    3b22:	75f010ef          	jal	5a80 <exit>
  wait(&xstatus);
    3b26:	fdc40513          	addi	a0,s0,-36
    3b2a:	75f010ef          	jal	5a88 <wait>
  exit(xstatus);
    3b2e:	fdc42503          	lw	a0,-36(s0)
    3b32:	74f010ef          	jal	5a80 <exit>

0000000000003b36 <dirtest>:
{
    3b36:	1101                	addi	sp,sp,-32
    3b38:	ec06                	sd	ra,24(sp)
    3b3a:	e822                	sd	s0,16(sp)
    3b3c:	e426                	sd	s1,8(sp)
    3b3e:	1000                	addi	s0,sp,32
    3b40:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3b42:	00004517          	auipc	a0,0x4
    3b46:	6de50513          	addi	a0,a0,1758 # 8220 <malloc+0x228c>
    3b4a:	79f010ef          	jal	5ae8 <mkdir>
    3b4e:	02054f63          	bltz	a0,3b8c <dirtest+0x56>
  if(chdir("dir0") < 0){
    3b52:	00004517          	auipc	a0,0x4
    3b56:	6ce50513          	addi	a0,a0,1742 # 8220 <malloc+0x228c>
    3b5a:	797010ef          	jal	5af0 <chdir>
    3b5e:	04054163          	bltz	a0,3ba0 <dirtest+0x6a>
  if(chdir("..") < 0){
    3b62:	00004517          	auipc	a0,0x4
    3b66:	6de50513          	addi	a0,a0,1758 # 8240 <malloc+0x22ac>
    3b6a:	787010ef          	jal	5af0 <chdir>
    3b6e:	04054363          	bltz	a0,3bb4 <dirtest+0x7e>
  if(unlink("dir0") < 0){
    3b72:	00004517          	auipc	a0,0x4
    3b76:	6ae50513          	addi	a0,a0,1710 # 8220 <malloc+0x228c>
    3b7a:	757010ef          	jal	5ad0 <unlink>
    3b7e:	04054563          	bltz	a0,3bc8 <dirtest+0x92>
}
    3b82:	60e2                	ld	ra,24(sp)
    3b84:	6442                	ld	s0,16(sp)
    3b86:	64a2                	ld	s1,8(sp)
    3b88:	6105                	addi	sp,sp,32
    3b8a:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3b8c:	85a6                	mv	a1,s1
    3b8e:	00004517          	auipc	a0,0x4
    3b92:	5f250513          	addi	a0,a0,1522 # 8180 <malloc+0x21ec>
    3b96:	34a020ef          	jal	5ee0 <printf>
    exit(1);
    3b9a:	4505                	li	a0,1
    3b9c:	6e5010ef          	jal	5a80 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3ba0:	85a6                	mv	a1,s1
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	68650513          	addi	a0,a0,1670 # 8228 <malloc+0x2294>
    3baa:	336020ef          	jal	5ee0 <printf>
    exit(1);
    3bae:	4505                	li	a0,1
    3bb0:	6d1010ef          	jal	5a80 <exit>
    printf("%s: chdir .. failed\n", s);
    3bb4:	85a6                	mv	a1,s1
    3bb6:	00004517          	auipc	a0,0x4
    3bba:	69250513          	addi	a0,a0,1682 # 8248 <malloc+0x22b4>
    3bbe:	322020ef          	jal	5ee0 <printf>
    exit(1);
    3bc2:	4505                	li	a0,1
    3bc4:	6bd010ef          	jal	5a80 <exit>
    printf("%s: unlink dir0 failed\n", s);
    3bc8:	85a6                	mv	a1,s1
    3bca:	00004517          	auipc	a0,0x4
    3bce:	69650513          	addi	a0,a0,1686 # 8260 <malloc+0x22cc>
    3bd2:	30e020ef          	jal	5ee0 <printf>
    exit(1);
    3bd6:	4505                	li	a0,1
    3bd8:	6a9010ef          	jal	5a80 <exit>

0000000000003bdc <subdir>:
{
    3bdc:	1101                	addi	sp,sp,-32
    3bde:	ec06                	sd	ra,24(sp)
    3be0:	e822                	sd	s0,16(sp)
    3be2:	e426                	sd	s1,8(sp)
    3be4:	e04a                	sd	s2,0(sp)
    3be6:	1000                	addi	s0,sp,32
    3be8:	892a                	mv	s2,a0
  unlink("ff");
    3bea:	00004517          	auipc	a0,0x4
    3bee:	7be50513          	addi	a0,a0,1982 # 83a8 <malloc+0x2414>
    3bf2:	6df010ef          	jal	5ad0 <unlink>
  if(mkdir("dd") != 0){
    3bf6:	00004517          	auipc	a0,0x4
    3bfa:	68250513          	addi	a0,a0,1666 # 8278 <malloc+0x22e4>
    3bfe:	6eb010ef          	jal	5ae8 <mkdir>
    3c02:	2e051263          	bnez	a0,3ee6 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    3c06:	20200593          	li	a1,514
    3c0a:	00004517          	auipc	a0,0x4
    3c0e:	68e50513          	addi	a0,a0,1678 # 8298 <malloc+0x2304>
    3c12:	6af010ef          	jal	5ac0 <open>
    3c16:	84aa                	mv	s1,a0
  if(fd < 0){
    3c18:	2e054163          	bltz	a0,3efa <subdir+0x31e>
  write(fd, "ff", 2);
    3c1c:	4609                	li	a2,2
    3c1e:	00004597          	auipc	a1,0x4
    3c22:	78a58593          	addi	a1,a1,1930 # 83a8 <malloc+0x2414>
    3c26:	67b010ef          	jal	5aa0 <write>
  close(fd);
    3c2a:	8526                	mv	a0,s1
    3c2c:	67d010ef          	jal	5aa8 <close>
  if(unlink("dd") >= 0){
    3c30:	00004517          	auipc	a0,0x4
    3c34:	64850513          	addi	a0,a0,1608 # 8278 <malloc+0x22e4>
    3c38:	699010ef          	jal	5ad0 <unlink>
    3c3c:	2c055963          	bgez	a0,3f0e <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    3c40:	00004517          	auipc	a0,0x4
    3c44:	6b050513          	addi	a0,a0,1712 # 82f0 <malloc+0x235c>
    3c48:	6a1010ef          	jal	5ae8 <mkdir>
    3c4c:	2c051b63          	bnez	a0,3f22 <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    3c50:	20200593          	li	a1,514
    3c54:	00004517          	auipc	a0,0x4
    3c58:	6c450513          	addi	a0,a0,1732 # 8318 <malloc+0x2384>
    3c5c:	665010ef          	jal	5ac0 <open>
    3c60:	84aa                	mv	s1,a0
  if(fd < 0){
    3c62:	2c054a63          	bltz	a0,3f36 <subdir+0x35a>
  write(fd, "FF", 2);
    3c66:	4609                	li	a2,2
    3c68:	00004597          	auipc	a1,0x4
    3c6c:	6e058593          	addi	a1,a1,1760 # 8348 <malloc+0x23b4>
    3c70:	631010ef          	jal	5aa0 <write>
  close(fd);
    3c74:	8526                	mv	a0,s1
    3c76:	633010ef          	jal	5aa8 <close>
  fd = open("dd/dd/../ff", 0);
    3c7a:	4581                	li	a1,0
    3c7c:	00004517          	auipc	a0,0x4
    3c80:	6d450513          	addi	a0,a0,1748 # 8350 <malloc+0x23bc>
    3c84:	63d010ef          	jal	5ac0 <open>
    3c88:	84aa                	mv	s1,a0
  if(fd < 0){
    3c8a:	2c054063          	bltz	a0,3f4a <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    3c8e:	660d                	lui	a2,0x3
    3c90:	00009597          	auipc	a1,0x9
    3c94:	41858593          	addi	a1,a1,1048 # d0a8 <buf>
    3c98:	601010ef          	jal	5a98 <read>
  if(cc != 2 || buf[0] != 'f'){
    3c9c:	4789                	li	a5,2
    3c9e:	2cf51063          	bne	a0,a5,3f5e <subdir+0x382>
    3ca2:	00009717          	auipc	a4,0x9
    3ca6:	40674703          	lbu	a4,1030(a4) # d0a8 <buf>
    3caa:	06600793          	li	a5,102
    3cae:	2af71863          	bne	a4,a5,3f5e <subdir+0x382>
  close(fd);
    3cb2:	8526                	mv	a0,s1
    3cb4:	5f5010ef          	jal	5aa8 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    3cb8:	00004597          	auipc	a1,0x4
    3cbc:	6e858593          	addi	a1,a1,1768 # 83a0 <malloc+0x240c>
    3cc0:	00004517          	auipc	a0,0x4
    3cc4:	65850513          	addi	a0,a0,1624 # 8318 <malloc+0x2384>
    3cc8:	619010ef          	jal	5ae0 <link>
    3ccc:	2a051363          	bnez	a0,3f72 <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    3cd0:	00004517          	auipc	a0,0x4
    3cd4:	64850513          	addi	a0,a0,1608 # 8318 <malloc+0x2384>
    3cd8:	5f9010ef          	jal	5ad0 <unlink>
    3cdc:	2a051563          	bnez	a0,3f86 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3ce0:	4581                	li	a1,0
    3ce2:	00004517          	auipc	a0,0x4
    3ce6:	63650513          	addi	a0,a0,1590 # 8318 <malloc+0x2384>
    3cea:	5d7010ef          	jal	5ac0 <open>
    3cee:	2a055663          	bgez	a0,3f9a <subdir+0x3be>
  if(chdir("dd") != 0){
    3cf2:	00004517          	auipc	a0,0x4
    3cf6:	58650513          	addi	a0,a0,1414 # 8278 <malloc+0x22e4>
    3cfa:	5f7010ef          	jal	5af0 <chdir>
    3cfe:	2a051863          	bnez	a0,3fae <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    3d02:	00004517          	auipc	a0,0x4
    3d06:	73650513          	addi	a0,a0,1846 # 8438 <malloc+0x24a4>
    3d0a:	5e7010ef          	jal	5af0 <chdir>
    3d0e:	2a051a63          	bnez	a0,3fc2 <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    3d12:	00004517          	auipc	a0,0x4
    3d16:	75650513          	addi	a0,a0,1878 # 8468 <malloc+0x24d4>
    3d1a:	5d7010ef          	jal	5af0 <chdir>
    3d1e:	2a051c63          	bnez	a0,3fd6 <subdir+0x3fa>
  if(chdir("./..") != 0){
    3d22:	00004517          	auipc	a0,0x4
    3d26:	77e50513          	addi	a0,a0,1918 # 84a0 <malloc+0x250c>
    3d2a:	5c7010ef          	jal	5af0 <chdir>
    3d2e:	2a051e63          	bnez	a0,3fea <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    3d32:	4581                	li	a1,0
    3d34:	00004517          	auipc	a0,0x4
    3d38:	66c50513          	addi	a0,a0,1644 # 83a0 <malloc+0x240c>
    3d3c:	585010ef          	jal	5ac0 <open>
    3d40:	84aa                	mv	s1,a0
  if(fd < 0){
    3d42:	2a054e63          	bltz	a0,3ffe <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    3d46:	660d                	lui	a2,0x3
    3d48:	00009597          	auipc	a1,0x9
    3d4c:	36058593          	addi	a1,a1,864 # d0a8 <buf>
    3d50:	549010ef          	jal	5a98 <read>
    3d54:	4789                	li	a5,2
    3d56:	2af51e63          	bne	a0,a5,4012 <subdir+0x436>
  close(fd);
    3d5a:	8526                	mv	a0,s1
    3d5c:	54d010ef          	jal	5aa8 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    3d60:	4581                	li	a1,0
    3d62:	00004517          	auipc	a0,0x4
    3d66:	5b650513          	addi	a0,a0,1462 # 8318 <malloc+0x2384>
    3d6a:	557010ef          	jal	5ac0 <open>
    3d6e:	2a055c63          	bgez	a0,4026 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    3d72:	20200593          	li	a1,514
    3d76:	00004517          	auipc	a0,0x4
    3d7a:	7ba50513          	addi	a0,a0,1978 # 8530 <malloc+0x259c>
    3d7e:	543010ef          	jal	5ac0 <open>
    3d82:	2a055c63          	bgez	a0,403a <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    3d86:	20200593          	li	a1,514
    3d8a:	00004517          	auipc	a0,0x4
    3d8e:	7d650513          	addi	a0,a0,2006 # 8560 <malloc+0x25cc>
    3d92:	52f010ef          	jal	5ac0 <open>
    3d96:	2a055c63          	bgez	a0,404e <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    3d9a:	20000593          	li	a1,512
    3d9e:	00004517          	auipc	a0,0x4
    3da2:	4da50513          	addi	a0,a0,1242 # 8278 <malloc+0x22e4>
    3da6:	51b010ef          	jal	5ac0 <open>
    3daa:	2a055c63          	bgez	a0,4062 <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    3dae:	4589                	li	a1,2
    3db0:	00004517          	auipc	a0,0x4
    3db4:	4c850513          	addi	a0,a0,1224 # 8278 <malloc+0x22e4>
    3db8:	509010ef          	jal	5ac0 <open>
    3dbc:	2a055d63          	bgez	a0,4076 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    3dc0:	4585                	li	a1,1
    3dc2:	00004517          	auipc	a0,0x4
    3dc6:	4b650513          	addi	a0,a0,1206 # 8278 <malloc+0x22e4>
    3dca:	4f7010ef          	jal	5ac0 <open>
    3dce:	2a055e63          	bgez	a0,408a <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3dd2:	00005597          	auipc	a1,0x5
    3dd6:	81e58593          	addi	a1,a1,-2018 # 85f0 <malloc+0x265c>
    3dda:	00004517          	auipc	a0,0x4
    3dde:	75650513          	addi	a0,a0,1878 # 8530 <malloc+0x259c>
    3de2:	4ff010ef          	jal	5ae0 <link>
    3de6:	2a050c63          	beqz	a0,409e <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3dea:	00005597          	auipc	a1,0x5
    3dee:	80658593          	addi	a1,a1,-2042 # 85f0 <malloc+0x265c>
    3df2:	00004517          	auipc	a0,0x4
    3df6:	76e50513          	addi	a0,a0,1902 # 8560 <malloc+0x25cc>
    3dfa:	4e7010ef          	jal	5ae0 <link>
    3dfe:	2a050a63          	beqz	a0,40b2 <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    3e02:	00004597          	auipc	a1,0x4
    3e06:	59e58593          	addi	a1,a1,1438 # 83a0 <malloc+0x240c>
    3e0a:	00004517          	auipc	a0,0x4
    3e0e:	48e50513          	addi	a0,a0,1166 # 8298 <malloc+0x2304>
    3e12:	4cf010ef          	jal	5ae0 <link>
    3e16:	2a050863          	beqz	a0,40c6 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    3e1a:	00004517          	auipc	a0,0x4
    3e1e:	71650513          	addi	a0,a0,1814 # 8530 <malloc+0x259c>
    3e22:	4c7010ef          	jal	5ae8 <mkdir>
    3e26:	2a050a63          	beqz	a0,40da <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    3e2a:	00004517          	auipc	a0,0x4
    3e2e:	73650513          	addi	a0,a0,1846 # 8560 <malloc+0x25cc>
    3e32:	4b7010ef          	jal	5ae8 <mkdir>
    3e36:	2a050c63          	beqz	a0,40ee <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    3e3a:	00004517          	auipc	a0,0x4
    3e3e:	56650513          	addi	a0,a0,1382 # 83a0 <malloc+0x240c>
    3e42:	4a7010ef          	jal	5ae8 <mkdir>
    3e46:	2a050e63          	beqz	a0,4102 <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    3e4a:	00004517          	auipc	a0,0x4
    3e4e:	71650513          	addi	a0,a0,1814 # 8560 <malloc+0x25cc>
    3e52:	47f010ef          	jal	5ad0 <unlink>
    3e56:	2c050063          	beqz	a0,4116 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    3e5a:	00004517          	auipc	a0,0x4
    3e5e:	6d650513          	addi	a0,a0,1750 # 8530 <malloc+0x259c>
    3e62:	46f010ef          	jal	5ad0 <unlink>
    3e66:	2c050263          	beqz	a0,412a <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    3e6a:	00004517          	auipc	a0,0x4
    3e6e:	42e50513          	addi	a0,a0,1070 # 8298 <malloc+0x2304>
    3e72:	47f010ef          	jal	5af0 <chdir>
    3e76:	2c050463          	beqz	a0,413e <subdir+0x562>
  if(chdir("dd/xx") == 0){
    3e7a:	00005517          	auipc	a0,0x5
    3e7e:	8c650513          	addi	a0,a0,-1850 # 8740 <malloc+0x27ac>
    3e82:	46f010ef          	jal	5af0 <chdir>
    3e86:	2c050663          	beqz	a0,4152 <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    3e8a:	00004517          	auipc	a0,0x4
    3e8e:	51650513          	addi	a0,a0,1302 # 83a0 <malloc+0x240c>
    3e92:	43f010ef          	jal	5ad0 <unlink>
    3e96:	2c051863          	bnez	a0,4166 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    3e9a:	00004517          	auipc	a0,0x4
    3e9e:	3fe50513          	addi	a0,a0,1022 # 8298 <malloc+0x2304>
    3ea2:	42f010ef          	jal	5ad0 <unlink>
    3ea6:	2c051a63          	bnez	a0,417a <subdir+0x59e>
  if(unlink("dd") == 0){
    3eaa:	00004517          	auipc	a0,0x4
    3eae:	3ce50513          	addi	a0,a0,974 # 8278 <malloc+0x22e4>
    3eb2:	41f010ef          	jal	5ad0 <unlink>
    3eb6:	2c050c63          	beqz	a0,418e <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    3eba:	00005517          	auipc	a0,0x5
    3ebe:	8f650513          	addi	a0,a0,-1802 # 87b0 <malloc+0x281c>
    3ec2:	40f010ef          	jal	5ad0 <unlink>
    3ec6:	2c054e63          	bltz	a0,41a2 <subdir+0x5c6>
  if(unlink("dd") < 0){
    3eca:	00004517          	auipc	a0,0x4
    3ece:	3ae50513          	addi	a0,a0,942 # 8278 <malloc+0x22e4>
    3ed2:	3ff010ef          	jal	5ad0 <unlink>
    3ed6:	2e054063          	bltz	a0,41b6 <subdir+0x5da>
}
    3eda:	60e2                	ld	ra,24(sp)
    3edc:	6442                	ld	s0,16(sp)
    3ede:	64a2                	ld	s1,8(sp)
    3ee0:	6902                	ld	s2,0(sp)
    3ee2:	6105                	addi	sp,sp,32
    3ee4:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3ee6:	85ca                	mv	a1,s2
    3ee8:	00004517          	auipc	a0,0x4
    3eec:	39850513          	addi	a0,a0,920 # 8280 <malloc+0x22ec>
    3ef0:	7f1010ef          	jal	5ee0 <printf>
    exit(1);
    3ef4:	4505                	li	a0,1
    3ef6:	38b010ef          	jal	5a80 <exit>
    printf("%s: create dd/ff failed\n", s);
    3efa:	85ca                	mv	a1,s2
    3efc:	00004517          	auipc	a0,0x4
    3f00:	3a450513          	addi	a0,a0,932 # 82a0 <malloc+0x230c>
    3f04:	7dd010ef          	jal	5ee0 <printf>
    exit(1);
    3f08:	4505                	li	a0,1
    3f0a:	377010ef          	jal	5a80 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3f0e:	85ca                	mv	a1,s2
    3f10:	00004517          	auipc	a0,0x4
    3f14:	3b050513          	addi	a0,a0,944 # 82c0 <malloc+0x232c>
    3f18:	7c9010ef          	jal	5ee0 <printf>
    exit(1);
    3f1c:	4505                	li	a0,1
    3f1e:	363010ef          	jal	5a80 <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    3f22:	85ca                	mv	a1,s2
    3f24:	00004517          	auipc	a0,0x4
    3f28:	3d450513          	addi	a0,a0,980 # 82f8 <malloc+0x2364>
    3f2c:	7b5010ef          	jal	5ee0 <printf>
    exit(1);
    3f30:	4505                	li	a0,1
    3f32:	34f010ef          	jal	5a80 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3f36:	85ca                	mv	a1,s2
    3f38:	00004517          	auipc	a0,0x4
    3f3c:	3f050513          	addi	a0,a0,1008 # 8328 <malloc+0x2394>
    3f40:	7a1010ef          	jal	5ee0 <printf>
    exit(1);
    3f44:	4505                	li	a0,1
    3f46:	33b010ef          	jal	5a80 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3f4a:	85ca                	mv	a1,s2
    3f4c:	00004517          	auipc	a0,0x4
    3f50:	41450513          	addi	a0,a0,1044 # 8360 <malloc+0x23cc>
    3f54:	78d010ef          	jal	5ee0 <printf>
    exit(1);
    3f58:	4505                	li	a0,1
    3f5a:	327010ef          	jal	5a80 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3f5e:	85ca                	mv	a1,s2
    3f60:	00004517          	auipc	a0,0x4
    3f64:	42050513          	addi	a0,a0,1056 # 8380 <malloc+0x23ec>
    3f68:	779010ef          	jal	5ee0 <printf>
    exit(1);
    3f6c:	4505                	li	a0,1
    3f6e:	313010ef          	jal	5a80 <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    3f72:	85ca                	mv	a1,s2
    3f74:	00004517          	auipc	a0,0x4
    3f78:	43c50513          	addi	a0,a0,1084 # 83b0 <malloc+0x241c>
    3f7c:	765010ef          	jal	5ee0 <printf>
    exit(1);
    3f80:	4505                	li	a0,1
    3f82:	2ff010ef          	jal	5a80 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3f86:	85ca                	mv	a1,s2
    3f88:	00004517          	auipc	a0,0x4
    3f8c:	45050513          	addi	a0,a0,1104 # 83d8 <malloc+0x2444>
    3f90:	751010ef          	jal	5ee0 <printf>
    exit(1);
    3f94:	4505                	li	a0,1
    3f96:	2eb010ef          	jal	5a80 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3f9a:	85ca                	mv	a1,s2
    3f9c:	00004517          	auipc	a0,0x4
    3fa0:	45c50513          	addi	a0,a0,1116 # 83f8 <malloc+0x2464>
    3fa4:	73d010ef          	jal	5ee0 <printf>
    exit(1);
    3fa8:	4505                	li	a0,1
    3faa:	2d7010ef          	jal	5a80 <exit>
    printf("%s: chdir dd failed\n", s);
    3fae:	85ca                	mv	a1,s2
    3fb0:	00004517          	auipc	a0,0x4
    3fb4:	47050513          	addi	a0,a0,1136 # 8420 <malloc+0x248c>
    3fb8:	729010ef          	jal	5ee0 <printf>
    exit(1);
    3fbc:	4505                	li	a0,1
    3fbe:	2c3010ef          	jal	5a80 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3fc2:	85ca                	mv	a1,s2
    3fc4:	00004517          	auipc	a0,0x4
    3fc8:	48450513          	addi	a0,a0,1156 # 8448 <malloc+0x24b4>
    3fcc:	715010ef          	jal	5ee0 <printf>
    exit(1);
    3fd0:	4505                	li	a0,1
    3fd2:	2af010ef          	jal	5a80 <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    3fd6:	85ca                	mv	a1,s2
    3fd8:	00004517          	auipc	a0,0x4
    3fdc:	4a050513          	addi	a0,a0,1184 # 8478 <malloc+0x24e4>
    3fe0:	701010ef          	jal	5ee0 <printf>
    exit(1);
    3fe4:	4505                	li	a0,1
    3fe6:	29b010ef          	jal	5a80 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3fea:	85ca                	mv	a1,s2
    3fec:	00004517          	auipc	a0,0x4
    3ff0:	4bc50513          	addi	a0,a0,1212 # 84a8 <malloc+0x2514>
    3ff4:	6ed010ef          	jal	5ee0 <printf>
    exit(1);
    3ff8:	4505                	li	a0,1
    3ffa:	287010ef          	jal	5a80 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3ffe:	85ca                	mv	a1,s2
    4000:	00004517          	auipc	a0,0x4
    4004:	4c050513          	addi	a0,a0,1216 # 84c0 <malloc+0x252c>
    4008:	6d9010ef          	jal	5ee0 <printf>
    exit(1);
    400c:	4505                	li	a0,1
    400e:	273010ef          	jal	5a80 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    4012:	85ca                	mv	a1,s2
    4014:	00004517          	auipc	a0,0x4
    4018:	4cc50513          	addi	a0,a0,1228 # 84e0 <malloc+0x254c>
    401c:	6c5010ef          	jal	5ee0 <printf>
    exit(1);
    4020:	4505                	li	a0,1
    4022:	25f010ef          	jal	5a80 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    4026:	85ca                	mv	a1,s2
    4028:	00004517          	auipc	a0,0x4
    402c:	4d850513          	addi	a0,a0,1240 # 8500 <malloc+0x256c>
    4030:	6b1010ef          	jal	5ee0 <printf>
    exit(1);
    4034:	4505                	li	a0,1
    4036:	24b010ef          	jal	5a80 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    403a:	85ca                	mv	a1,s2
    403c:	00004517          	auipc	a0,0x4
    4040:	50450513          	addi	a0,a0,1284 # 8540 <malloc+0x25ac>
    4044:	69d010ef          	jal	5ee0 <printf>
    exit(1);
    4048:	4505                	li	a0,1
    404a:	237010ef          	jal	5a80 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    404e:	85ca                	mv	a1,s2
    4050:	00004517          	auipc	a0,0x4
    4054:	52050513          	addi	a0,a0,1312 # 8570 <malloc+0x25dc>
    4058:	689010ef          	jal	5ee0 <printf>
    exit(1);
    405c:	4505                	li	a0,1
    405e:	223010ef          	jal	5a80 <exit>
    printf("%s: create dd succeeded!\n", s);
    4062:	85ca                	mv	a1,s2
    4064:	00004517          	auipc	a0,0x4
    4068:	52c50513          	addi	a0,a0,1324 # 8590 <malloc+0x25fc>
    406c:	675010ef          	jal	5ee0 <printf>
    exit(1);
    4070:	4505                	li	a0,1
    4072:	20f010ef          	jal	5a80 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    4076:	85ca                	mv	a1,s2
    4078:	00004517          	auipc	a0,0x4
    407c:	53850513          	addi	a0,a0,1336 # 85b0 <malloc+0x261c>
    4080:	661010ef          	jal	5ee0 <printf>
    exit(1);
    4084:	4505                	li	a0,1
    4086:	1fb010ef          	jal	5a80 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    408a:	85ca                	mv	a1,s2
    408c:	00004517          	auipc	a0,0x4
    4090:	54450513          	addi	a0,a0,1348 # 85d0 <malloc+0x263c>
    4094:	64d010ef          	jal	5ee0 <printf>
    exit(1);
    4098:	4505                	li	a0,1
    409a:	1e7010ef          	jal	5a80 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    409e:	85ca                	mv	a1,s2
    40a0:	00004517          	auipc	a0,0x4
    40a4:	56050513          	addi	a0,a0,1376 # 8600 <malloc+0x266c>
    40a8:	639010ef          	jal	5ee0 <printf>
    exit(1);
    40ac:	4505                	li	a0,1
    40ae:	1d3010ef          	jal	5a80 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    40b2:	85ca                	mv	a1,s2
    40b4:	00004517          	auipc	a0,0x4
    40b8:	57450513          	addi	a0,a0,1396 # 8628 <malloc+0x2694>
    40bc:	625010ef          	jal	5ee0 <printf>
    exit(1);
    40c0:	4505                	li	a0,1
    40c2:	1bf010ef          	jal	5a80 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    40c6:	85ca                	mv	a1,s2
    40c8:	00004517          	auipc	a0,0x4
    40cc:	58850513          	addi	a0,a0,1416 # 8650 <malloc+0x26bc>
    40d0:	611010ef          	jal	5ee0 <printf>
    exit(1);
    40d4:	4505                	li	a0,1
    40d6:	1ab010ef          	jal	5a80 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    40da:	85ca                	mv	a1,s2
    40dc:	00004517          	auipc	a0,0x4
    40e0:	59c50513          	addi	a0,a0,1436 # 8678 <malloc+0x26e4>
    40e4:	5fd010ef          	jal	5ee0 <printf>
    exit(1);
    40e8:	4505                	li	a0,1
    40ea:	197010ef          	jal	5a80 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    40ee:	85ca                	mv	a1,s2
    40f0:	00004517          	auipc	a0,0x4
    40f4:	5a850513          	addi	a0,a0,1448 # 8698 <malloc+0x2704>
    40f8:	5e9010ef          	jal	5ee0 <printf>
    exit(1);
    40fc:	4505                	li	a0,1
    40fe:	183010ef          	jal	5a80 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    4102:	85ca                	mv	a1,s2
    4104:	00004517          	auipc	a0,0x4
    4108:	5b450513          	addi	a0,a0,1460 # 86b8 <malloc+0x2724>
    410c:	5d5010ef          	jal	5ee0 <printf>
    exit(1);
    4110:	4505                	li	a0,1
    4112:	16f010ef          	jal	5a80 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    4116:	85ca                	mv	a1,s2
    4118:	00004517          	auipc	a0,0x4
    411c:	5c850513          	addi	a0,a0,1480 # 86e0 <malloc+0x274c>
    4120:	5c1010ef          	jal	5ee0 <printf>
    exit(1);
    4124:	4505                	li	a0,1
    4126:	15b010ef          	jal	5a80 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    412a:	85ca                	mv	a1,s2
    412c:	00004517          	auipc	a0,0x4
    4130:	5d450513          	addi	a0,a0,1492 # 8700 <malloc+0x276c>
    4134:	5ad010ef          	jal	5ee0 <printf>
    exit(1);
    4138:	4505                	li	a0,1
    413a:	147010ef          	jal	5a80 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    413e:	85ca                	mv	a1,s2
    4140:	00004517          	auipc	a0,0x4
    4144:	5e050513          	addi	a0,a0,1504 # 8720 <malloc+0x278c>
    4148:	599010ef          	jal	5ee0 <printf>
    exit(1);
    414c:	4505                	li	a0,1
    414e:	133010ef          	jal	5a80 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    4152:	85ca                	mv	a1,s2
    4154:	00004517          	auipc	a0,0x4
    4158:	5f450513          	addi	a0,a0,1524 # 8748 <malloc+0x27b4>
    415c:	585010ef          	jal	5ee0 <printf>
    exit(1);
    4160:	4505                	li	a0,1
    4162:	11f010ef          	jal	5a80 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    4166:	85ca                	mv	a1,s2
    4168:	00004517          	auipc	a0,0x4
    416c:	27050513          	addi	a0,a0,624 # 83d8 <malloc+0x2444>
    4170:	571010ef          	jal	5ee0 <printf>
    exit(1);
    4174:	4505                	li	a0,1
    4176:	10b010ef          	jal	5a80 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    417a:	85ca                	mv	a1,s2
    417c:	00004517          	auipc	a0,0x4
    4180:	5ec50513          	addi	a0,a0,1516 # 8768 <malloc+0x27d4>
    4184:	55d010ef          	jal	5ee0 <printf>
    exit(1);
    4188:	4505                	li	a0,1
    418a:	0f7010ef          	jal	5a80 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    418e:	85ca                	mv	a1,s2
    4190:	00004517          	auipc	a0,0x4
    4194:	5f850513          	addi	a0,a0,1528 # 8788 <malloc+0x27f4>
    4198:	549010ef          	jal	5ee0 <printf>
    exit(1);
    419c:	4505                	li	a0,1
    419e:	0e3010ef          	jal	5a80 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    41a2:	85ca                	mv	a1,s2
    41a4:	00004517          	auipc	a0,0x4
    41a8:	61450513          	addi	a0,a0,1556 # 87b8 <malloc+0x2824>
    41ac:	535010ef          	jal	5ee0 <printf>
    exit(1);
    41b0:	4505                	li	a0,1
    41b2:	0cf010ef          	jal	5a80 <exit>
    printf("%s: unlink dd failed\n", s);
    41b6:	85ca                	mv	a1,s2
    41b8:	00004517          	auipc	a0,0x4
    41bc:	62050513          	addi	a0,a0,1568 # 87d8 <malloc+0x2844>
    41c0:	521010ef          	jal	5ee0 <printf>
    exit(1);
    41c4:	4505                	li	a0,1
    41c6:	0bb010ef          	jal	5a80 <exit>

00000000000041ca <rmdot>:
{
    41ca:	1101                	addi	sp,sp,-32
    41cc:	ec06                	sd	ra,24(sp)
    41ce:	e822                	sd	s0,16(sp)
    41d0:	e426                	sd	s1,8(sp)
    41d2:	1000                	addi	s0,sp,32
    41d4:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    41d6:	00004517          	auipc	a0,0x4
    41da:	61a50513          	addi	a0,a0,1562 # 87f0 <malloc+0x285c>
    41de:	10b010ef          	jal	5ae8 <mkdir>
    41e2:	e53d                	bnez	a0,4250 <rmdot+0x86>
  if(chdir("dots") != 0){
    41e4:	00004517          	auipc	a0,0x4
    41e8:	60c50513          	addi	a0,a0,1548 # 87f0 <malloc+0x285c>
    41ec:	105010ef          	jal	5af0 <chdir>
    41f0:	e935                	bnez	a0,4264 <rmdot+0x9a>
  if(unlink(".") == 0){
    41f2:	00003517          	auipc	a0,0x3
    41f6:	52e50513          	addi	a0,a0,1326 # 7720 <malloc+0x178c>
    41fa:	0d7010ef          	jal	5ad0 <unlink>
    41fe:	cd2d                	beqz	a0,4278 <rmdot+0xae>
  if(unlink("..") == 0){
    4200:	00004517          	auipc	a0,0x4
    4204:	04050513          	addi	a0,a0,64 # 8240 <malloc+0x22ac>
    4208:	0c9010ef          	jal	5ad0 <unlink>
    420c:	c141                	beqz	a0,428c <rmdot+0xc2>
  if(chdir("/") != 0){
    420e:	00004517          	auipc	a0,0x4
    4212:	fda50513          	addi	a0,a0,-38 # 81e8 <malloc+0x2254>
    4216:	0db010ef          	jal	5af0 <chdir>
    421a:	e159                	bnez	a0,42a0 <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    421c:	00004517          	auipc	a0,0x4
    4220:	63c50513          	addi	a0,a0,1596 # 8858 <malloc+0x28c4>
    4224:	0ad010ef          	jal	5ad0 <unlink>
    4228:	c551                	beqz	a0,42b4 <rmdot+0xea>
  if(unlink("dots/..") == 0){
    422a:	00004517          	auipc	a0,0x4
    422e:	65650513          	addi	a0,a0,1622 # 8880 <malloc+0x28ec>
    4232:	09f010ef          	jal	5ad0 <unlink>
    4236:	c949                	beqz	a0,42c8 <rmdot+0xfe>
  if(unlink("dots") != 0){
    4238:	00004517          	auipc	a0,0x4
    423c:	5b850513          	addi	a0,a0,1464 # 87f0 <malloc+0x285c>
    4240:	091010ef          	jal	5ad0 <unlink>
    4244:	ed41                	bnez	a0,42dc <rmdot+0x112>
}
    4246:	60e2                	ld	ra,24(sp)
    4248:	6442                	ld	s0,16(sp)
    424a:	64a2                	ld	s1,8(sp)
    424c:	6105                	addi	sp,sp,32
    424e:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    4250:	85a6                	mv	a1,s1
    4252:	00004517          	auipc	a0,0x4
    4256:	5a650513          	addi	a0,a0,1446 # 87f8 <malloc+0x2864>
    425a:	487010ef          	jal	5ee0 <printf>
    exit(1);
    425e:	4505                	li	a0,1
    4260:	021010ef          	jal	5a80 <exit>
    printf("%s: chdir dots failed\n", s);
    4264:	85a6                	mv	a1,s1
    4266:	00004517          	auipc	a0,0x4
    426a:	5aa50513          	addi	a0,a0,1450 # 8810 <malloc+0x287c>
    426e:	473010ef          	jal	5ee0 <printf>
    exit(1);
    4272:	4505                	li	a0,1
    4274:	00d010ef          	jal	5a80 <exit>
    printf("%s: rm . worked!\n", s);
    4278:	85a6                	mv	a1,s1
    427a:	00004517          	auipc	a0,0x4
    427e:	5ae50513          	addi	a0,a0,1454 # 8828 <malloc+0x2894>
    4282:	45f010ef          	jal	5ee0 <printf>
    exit(1);
    4286:	4505                	li	a0,1
    4288:	7f8010ef          	jal	5a80 <exit>
    printf("%s: rm .. worked!\n", s);
    428c:	85a6                	mv	a1,s1
    428e:	00004517          	auipc	a0,0x4
    4292:	5b250513          	addi	a0,a0,1458 # 8840 <malloc+0x28ac>
    4296:	44b010ef          	jal	5ee0 <printf>
    exit(1);
    429a:	4505                	li	a0,1
    429c:	7e4010ef          	jal	5a80 <exit>
    printf("%s: chdir / failed\n", s);
    42a0:	85a6                	mv	a1,s1
    42a2:	00004517          	auipc	a0,0x4
    42a6:	f4e50513          	addi	a0,a0,-178 # 81f0 <malloc+0x225c>
    42aa:	437010ef          	jal	5ee0 <printf>
    exit(1);
    42ae:	4505                	li	a0,1
    42b0:	7d0010ef          	jal	5a80 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    42b4:	85a6                	mv	a1,s1
    42b6:	00004517          	auipc	a0,0x4
    42ba:	5aa50513          	addi	a0,a0,1450 # 8860 <malloc+0x28cc>
    42be:	423010ef          	jal	5ee0 <printf>
    exit(1);
    42c2:	4505                	li	a0,1
    42c4:	7bc010ef          	jal	5a80 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    42c8:	85a6                	mv	a1,s1
    42ca:	00004517          	auipc	a0,0x4
    42ce:	5be50513          	addi	a0,a0,1470 # 8888 <malloc+0x28f4>
    42d2:	40f010ef          	jal	5ee0 <printf>
    exit(1);
    42d6:	4505                	li	a0,1
    42d8:	7a8010ef          	jal	5a80 <exit>
    printf("%s: unlink dots failed!\n", s);
    42dc:	85a6                	mv	a1,s1
    42de:	00004517          	auipc	a0,0x4
    42e2:	5ca50513          	addi	a0,a0,1482 # 88a8 <malloc+0x2914>
    42e6:	3fb010ef          	jal	5ee0 <printf>
    exit(1);
    42ea:	4505                	li	a0,1
    42ec:	794010ef          	jal	5a80 <exit>

00000000000042f0 <dirfile>:
{
    42f0:	1101                	addi	sp,sp,-32
    42f2:	ec06                	sd	ra,24(sp)
    42f4:	e822                	sd	s0,16(sp)
    42f6:	e426                	sd	s1,8(sp)
    42f8:	e04a                	sd	s2,0(sp)
    42fa:	1000                	addi	s0,sp,32
    42fc:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    42fe:	20000593          	li	a1,512
    4302:	00004517          	auipc	a0,0x4
    4306:	5c650513          	addi	a0,a0,1478 # 88c8 <malloc+0x2934>
    430a:	7b6010ef          	jal	5ac0 <open>
  if(fd < 0){
    430e:	0c054563          	bltz	a0,43d8 <dirfile+0xe8>
  close(fd);
    4312:	796010ef          	jal	5aa8 <close>
  if(chdir("dirfile") == 0){
    4316:	00004517          	auipc	a0,0x4
    431a:	5b250513          	addi	a0,a0,1458 # 88c8 <malloc+0x2934>
    431e:	7d2010ef          	jal	5af0 <chdir>
    4322:	c569                	beqz	a0,43ec <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    4324:	4581                	li	a1,0
    4326:	00004517          	auipc	a0,0x4
    432a:	5ea50513          	addi	a0,a0,1514 # 8910 <malloc+0x297c>
    432e:	792010ef          	jal	5ac0 <open>
  if(fd >= 0){
    4332:	0c055763          	bgez	a0,4400 <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    4336:	20000593          	li	a1,512
    433a:	00004517          	auipc	a0,0x4
    433e:	5d650513          	addi	a0,a0,1494 # 8910 <malloc+0x297c>
    4342:	77e010ef          	jal	5ac0 <open>
  if(fd >= 0){
    4346:	0c055763          	bgez	a0,4414 <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    434a:	00004517          	auipc	a0,0x4
    434e:	5c650513          	addi	a0,a0,1478 # 8910 <malloc+0x297c>
    4352:	796010ef          	jal	5ae8 <mkdir>
    4356:	0c050963          	beqz	a0,4428 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    435a:	00004517          	auipc	a0,0x4
    435e:	5b650513          	addi	a0,a0,1462 # 8910 <malloc+0x297c>
    4362:	76e010ef          	jal	5ad0 <unlink>
    4366:	0c050b63          	beqz	a0,443c <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    436a:	00004597          	auipc	a1,0x4
    436e:	5a658593          	addi	a1,a1,1446 # 8910 <malloc+0x297c>
    4372:	00003517          	auipc	a0,0x3
    4376:	e9e50513          	addi	a0,a0,-354 # 7210 <malloc+0x127c>
    437a:	766010ef          	jal	5ae0 <link>
    437e:	0c050963          	beqz	a0,4450 <dirfile+0x160>
  if(unlink("dirfile") != 0){
    4382:	00004517          	auipc	a0,0x4
    4386:	54650513          	addi	a0,a0,1350 # 88c8 <malloc+0x2934>
    438a:	746010ef          	jal	5ad0 <unlink>
    438e:	0c051b63          	bnez	a0,4464 <dirfile+0x174>
  fd = open(".", O_RDWR);
    4392:	4589                	li	a1,2
    4394:	00003517          	auipc	a0,0x3
    4398:	38c50513          	addi	a0,a0,908 # 7720 <malloc+0x178c>
    439c:	724010ef          	jal	5ac0 <open>
  if(fd >= 0){
    43a0:	0c055c63          	bgez	a0,4478 <dirfile+0x188>
  fd = open(".", 0);
    43a4:	4581                	li	a1,0
    43a6:	00003517          	auipc	a0,0x3
    43aa:	37a50513          	addi	a0,a0,890 # 7720 <malloc+0x178c>
    43ae:	712010ef          	jal	5ac0 <open>
    43b2:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    43b4:	4605                	li	a2,1
    43b6:	00003597          	auipc	a1,0x3
    43ba:	cf258593          	addi	a1,a1,-782 # 70a8 <malloc+0x1114>
    43be:	6e2010ef          	jal	5aa0 <write>
    43c2:	0ca04563          	bgtz	a0,448c <dirfile+0x19c>
  close(fd);
    43c6:	8526                	mv	a0,s1
    43c8:	6e0010ef          	jal	5aa8 <close>
}
    43cc:	60e2                	ld	ra,24(sp)
    43ce:	6442                	ld	s0,16(sp)
    43d0:	64a2                	ld	s1,8(sp)
    43d2:	6902                	ld	s2,0(sp)
    43d4:	6105                	addi	sp,sp,32
    43d6:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    43d8:	85ca                	mv	a1,s2
    43da:	00004517          	auipc	a0,0x4
    43de:	4f650513          	addi	a0,a0,1270 # 88d0 <malloc+0x293c>
    43e2:	2ff010ef          	jal	5ee0 <printf>
    exit(1);
    43e6:	4505                	li	a0,1
    43e8:	698010ef          	jal	5a80 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    43ec:	85ca                	mv	a1,s2
    43ee:	00004517          	auipc	a0,0x4
    43f2:	50250513          	addi	a0,a0,1282 # 88f0 <malloc+0x295c>
    43f6:	2eb010ef          	jal	5ee0 <printf>
    exit(1);
    43fa:	4505                	li	a0,1
    43fc:	684010ef          	jal	5a80 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4400:	85ca                	mv	a1,s2
    4402:	00004517          	auipc	a0,0x4
    4406:	51e50513          	addi	a0,a0,1310 # 8920 <malloc+0x298c>
    440a:	2d7010ef          	jal	5ee0 <printf>
    exit(1);
    440e:	4505                	li	a0,1
    4410:	670010ef          	jal	5a80 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    4414:	85ca                	mv	a1,s2
    4416:	00004517          	auipc	a0,0x4
    441a:	50a50513          	addi	a0,a0,1290 # 8920 <malloc+0x298c>
    441e:	2c3010ef          	jal	5ee0 <printf>
    exit(1);
    4422:	4505                	li	a0,1
    4424:	65c010ef          	jal	5a80 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    4428:	85ca                	mv	a1,s2
    442a:	00004517          	auipc	a0,0x4
    442e:	51e50513          	addi	a0,a0,1310 # 8948 <malloc+0x29b4>
    4432:	2af010ef          	jal	5ee0 <printf>
    exit(1);
    4436:	4505                	li	a0,1
    4438:	648010ef          	jal	5a80 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    443c:	85ca                	mv	a1,s2
    443e:	00004517          	auipc	a0,0x4
    4442:	53250513          	addi	a0,a0,1330 # 8970 <malloc+0x29dc>
    4446:	29b010ef          	jal	5ee0 <printf>
    exit(1);
    444a:	4505                	li	a0,1
    444c:	634010ef          	jal	5a80 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    4450:	85ca                	mv	a1,s2
    4452:	00004517          	auipc	a0,0x4
    4456:	54650513          	addi	a0,a0,1350 # 8998 <malloc+0x2a04>
    445a:	287010ef          	jal	5ee0 <printf>
    exit(1);
    445e:	4505                	li	a0,1
    4460:	620010ef          	jal	5a80 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4464:	85ca                	mv	a1,s2
    4466:	00004517          	auipc	a0,0x4
    446a:	55a50513          	addi	a0,a0,1370 # 89c0 <malloc+0x2a2c>
    446e:	273010ef          	jal	5ee0 <printf>
    exit(1);
    4472:	4505                	li	a0,1
    4474:	60c010ef          	jal	5a80 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4478:	85ca                	mv	a1,s2
    447a:	00004517          	auipc	a0,0x4
    447e:	56650513          	addi	a0,a0,1382 # 89e0 <malloc+0x2a4c>
    4482:	25f010ef          	jal	5ee0 <printf>
    exit(1);
    4486:	4505                	li	a0,1
    4488:	5f8010ef          	jal	5a80 <exit>
    printf("%s: write . succeeded!\n", s);
    448c:	85ca                	mv	a1,s2
    448e:	00004517          	auipc	a0,0x4
    4492:	57a50513          	addi	a0,a0,1402 # 8a08 <malloc+0x2a74>
    4496:	24b010ef          	jal	5ee0 <printf>
    exit(1);
    449a:	4505                	li	a0,1
    449c:	5e4010ef          	jal	5a80 <exit>

00000000000044a0 <iref>:
{
    44a0:	7139                	addi	sp,sp,-64
    44a2:	fc06                	sd	ra,56(sp)
    44a4:	f822                	sd	s0,48(sp)
    44a6:	f426                	sd	s1,40(sp)
    44a8:	f04a                	sd	s2,32(sp)
    44aa:	ec4e                	sd	s3,24(sp)
    44ac:	e852                	sd	s4,16(sp)
    44ae:	e456                	sd	s5,8(sp)
    44b0:	e05a                	sd	s6,0(sp)
    44b2:	0080                	addi	s0,sp,64
    44b4:	8b2a                	mv	s6,a0
    44b6:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    44ba:	00004a17          	auipc	s4,0x4
    44be:	566a0a13          	addi	s4,s4,1382 # 8a20 <malloc+0x2a8c>
    mkdir("");
    44c2:	00004497          	auipc	s1,0x4
    44c6:	06648493          	addi	s1,s1,102 # 8528 <malloc+0x2594>
    link("README", "");
    44ca:	00003a97          	auipc	s5,0x3
    44ce:	d46a8a93          	addi	s5,s5,-698 # 7210 <malloc+0x127c>
    fd = open("xx", O_CREATE);
    44d2:	00004997          	auipc	s3,0x4
    44d6:	44698993          	addi	s3,s3,1094 # 8918 <malloc+0x2984>
    44da:	a835                	j	4516 <iref+0x76>
      printf("%s: mkdir irefd failed\n", s);
    44dc:	85da                	mv	a1,s6
    44de:	00004517          	auipc	a0,0x4
    44e2:	54a50513          	addi	a0,a0,1354 # 8a28 <malloc+0x2a94>
    44e6:	1fb010ef          	jal	5ee0 <printf>
      exit(1);
    44ea:	4505                	li	a0,1
    44ec:	594010ef          	jal	5a80 <exit>
      printf("%s: chdir irefd failed\n", s);
    44f0:	85da                	mv	a1,s6
    44f2:	00004517          	auipc	a0,0x4
    44f6:	54e50513          	addi	a0,a0,1358 # 8a40 <malloc+0x2aac>
    44fa:	1e7010ef          	jal	5ee0 <printf>
      exit(1);
    44fe:	4505                	li	a0,1
    4500:	580010ef          	jal	5a80 <exit>
      close(fd);
    4504:	5a4010ef          	jal	5aa8 <close>
    4508:	a82d                	j	4542 <iref+0xa2>
    unlink("xx");
    450a:	854e                	mv	a0,s3
    450c:	5c4010ef          	jal	5ad0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4510:	397d                	addiw	s2,s2,-1
    4512:	04090263          	beqz	s2,4556 <iref+0xb6>
    if(mkdir("irefd") != 0){
    4516:	8552                	mv	a0,s4
    4518:	5d0010ef          	jal	5ae8 <mkdir>
    451c:	f161                	bnez	a0,44dc <iref+0x3c>
    if(chdir("irefd") != 0){
    451e:	8552                	mv	a0,s4
    4520:	5d0010ef          	jal	5af0 <chdir>
    4524:	f571                	bnez	a0,44f0 <iref+0x50>
    mkdir("");
    4526:	8526                	mv	a0,s1
    4528:	5c0010ef          	jal	5ae8 <mkdir>
    link("README", "");
    452c:	85a6                	mv	a1,s1
    452e:	8556                	mv	a0,s5
    4530:	5b0010ef          	jal	5ae0 <link>
    fd = open("", O_CREATE);
    4534:	20000593          	li	a1,512
    4538:	8526                	mv	a0,s1
    453a:	586010ef          	jal	5ac0 <open>
    if(fd >= 0)
    453e:	fc0553e3          	bgez	a0,4504 <iref+0x64>
    fd = open("xx", O_CREATE);
    4542:	20000593          	li	a1,512
    4546:	854e                	mv	a0,s3
    4548:	578010ef          	jal	5ac0 <open>
    if(fd >= 0)
    454c:	fa054fe3          	bltz	a0,450a <iref+0x6a>
      close(fd);
    4550:	558010ef          	jal	5aa8 <close>
    4554:	bf5d                	j	450a <iref+0x6a>
    4556:	03300493          	li	s1,51
    chdir("..");
    455a:	00004997          	auipc	s3,0x4
    455e:	ce698993          	addi	s3,s3,-794 # 8240 <malloc+0x22ac>
    unlink("irefd");
    4562:	00004917          	auipc	s2,0x4
    4566:	4be90913          	addi	s2,s2,1214 # 8a20 <malloc+0x2a8c>
    chdir("..");
    456a:	854e                	mv	a0,s3
    456c:	584010ef          	jal	5af0 <chdir>
    unlink("irefd");
    4570:	854a                	mv	a0,s2
    4572:	55e010ef          	jal	5ad0 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    4576:	34fd                	addiw	s1,s1,-1
    4578:	f8ed                	bnez	s1,456a <iref+0xca>
  chdir("/");
    457a:	00004517          	auipc	a0,0x4
    457e:	c6e50513          	addi	a0,a0,-914 # 81e8 <malloc+0x2254>
    4582:	56e010ef          	jal	5af0 <chdir>
}
    4586:	70e2                	ld	ra,56(sp)
    4588:	7442                	ld	s0,48(sp)
    458a:	74a2                	ld	s1,40(sp)
    458c:	7902                	ld	s2,32(sp)
    458e:	69e2                	ld	s3,24(sp)
    4590:	6a42                	ld	s4,16(sp)
    4592:	6aa2                	ld	s5,8(sp)
    4594:	6b02                	ld	s6,0(sp)
    4596:	6121                	addi	sp,sp,64
    4598:	8082                	ret

000000000000459a <openiputtest>:
{
    459a:	7179                	addi	sp,sp,-48
    459c:	f406                	sd	ra,40(sp)
    459e:	f022                	sd	s0,32(sp)
    45a0:	ec26                	sd	s1,24(sp)
    45a2:	1800                	addi	s0,sp,48
    45a4:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    45a6:	00004517          	auipc	a0,0x4
    45aa:	4b250513          	addi	a0,a0,1202 # 8a58 <malloc+0x2ac4>
    45ae:	53a010ef          	jal	5ae8 <mkdir>
    45b2:	02054a63          	bltz	a0,45e6 <openiputtest+0x4c>
  pid = fork();
    45b6:	4c2010ef          	jal	5a78 <fork>
  if(pid < 0){
    45ba:	04054063          	bltz	a0,45fa <openiputtest+0x60>
  if(pid == 0){
    45be:	e939                	bnez	a0,4614 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    45c0:	4589                	li	a1,2
    45c2:	00004517          	auipc	a0,0x4
    45c6:	49650513          	addi	a0,a0,1174 # 8a58 <malloc+0x2ac4>
    45ca:	4f6010ef          	jal	5ac0 <open>
    if(fd >= 0){
    45ce:	04054063          	bltz	a0,460e <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    45d2:	85a6                	mv	a1,s1
    45d4:	00004517          	auipc	a0,0x4
    45d8:	4a450513          	addi	a0,a0,1188 # 8a78 <malloc+0x2ae4>
    45dc:	105010ef          	jal	5ee0 <printf>
      exit(1);
    45e0:	4505                	li	a0,1
    45e2:	49e010ef          	jal	5a80 <exit>
    printf("%s: mkdir oidir failed\n", s);
    45e6:	85a6                	mv	a1,s1
    45e8:	00004517          	auipc	a0,0x4
    45ec:	47850513          	addi	a0,a0,1144 # 8a60 <malloc+0x2acc>
    45f0:	0f1010ef          	jal	5ee0 <printf>
    exit(1);
    45f4:	4505                	li	a0,1
    45f6:	48a010ef          	jal	5a80 <exit>
    printf("%s: fork failed\n", s);
    45fa:	85a6                	mv	a1,s1
    45fc:	00003517          	auipc	a0,0x3
    4600:	2cc50513          	addi	a0,a0,716 # 78c8 <malloc+0x1934>
    4604:	0dd010ef          	jal	5ee0 <printf>
    exit(1);
    4608:	4505                	li	a0,1
    460a:	476010ef          	jal	5a80 <exit>
    exit(0);
    460e:	4501                	li	a0,0
    4610:	470010ef          	jal	5a80 <exit>
  sleep(1);
    4614:	4505                	li	a0,1
    4616:	4fa010ef          	jal	5b10 <sleep>
  if(unlink("oidir") != 0){
    461a:	00004517          	auipc	a0,0x4
    461e:	43e50513          	addi	a0,a0,1086 # 8a58 <malloc+0x2ac4>
    4622:	4ae010ef          	jal	5ad0 <unlink>
    4626:	c919                	beqz	a0,463c <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    4628:	85a6                	mv	a1,s1
    462a:	00003517          	auipc	a0,0x3
    462e:	48e50513          	addi	a0,a0,1166 # 7ab8 <malloc+0x1b24>
    4632:	0af010ef          	jal	5ee0 <printf>
    exit(1);
    4636:	4505                	li	a0,1
    4638:	448010ef          	jal	5a80 <exit>
  wait(&xstatus);
    463c:	fdc40513          	addi	a0,s0,-36
    4640:	448010ef          	jal	5a88 <wait>
  exit(xstatus);
    4644:	fdc42503          	lw	a0,-36(s0)
    4648:	438010ef          	jal	5a80 <exit>

000000000000464c <forkforkfork>:
{
    464c:	1101                	addi	sp,sp,-32
    464e:	ec06                	sd	ra,24(sp)
    4650:	e822                	sd	s0,16(sp)
    4652:	e426                	sd	s1,8(sp)
    4654:	1000                	addi	s0,sp,32
    4656:	84aa                	mv	s1,a0
  unlink("stopforking");
    4658:	00004517          	auipc	a0,0x4
    465c:	44850513          	addi	a0,a0,1096 # 8aa0 <malloc+0x2b0c>
    4660:	470010ef          	jal	5ad0 <unlink>
  int pid = fork();
    4664:	414010ef          	jal	5a78 <fork>
  if(pid < 0){
    4668:	02054b63          	bltz	a0,469e <forkforkfork+0x52>
  if(pid == 0){
    466c:	c139                	beqz	a0,46b2 <forkforkfork+0x66>
  sleep(20); // two seconds
    466e:	4551                	li	a0,20
    4670:	4a0010ef          	jal	5b10 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    4674:	20200593          	li	a1,514
    4678:	00004517          	auipc	a0,0x4
    467c:	42850513          	addi	a0,a0,1064 # 8aa0 <malloc+0x2b0c>
    4680:	440010ef          	jal	5ac0 <open>
    4684:	424010ef          	jal	5aa8 <close>
  wait(0);
    4688:	4501                	li	a0,0
    468a:	3fe010ef          	jal	5a88 <wait>
  sleep(10); // one second
    468e:	4529                	li	a0,10
    4690:	480010ef          	jal	5b10 <sleep>
}
    4694:	60e2                	ld	ra,24(sp)
    4696:	6442                	ld	s0,16(sp)
    4698:	64a2                	ld	s1,8(sp)
    469a:	6105                	addi	sp,sp,32
    469c:	8082                	ret
    printf("%s: fork failed", s);
    469e:	85a6                	mv	a1,s1
    46a0:	00003517          	auipc	a0,0x3
    46a4:	3e850513          	addi	a0,a0,1000 # 7a88 <malloc+0x1af4>
    46a8:	039010ef          	jal	5ee0 <printf>
    exit(1);
    46ac:	4505                	li	a0,1
    46ae:	3d2010ef          	jal	5a80 <exit>
      int fd = open("stopforking", 0);
    46b2:	00004497          	auipc	s1,0x4
    46b6:	3ee48493          	addi	s1,s1,1006 # 8aa0 <malloc+0x2b0c>
    46ba:	4581                	li	a1,0
    46bc:	8526                	mv	a0,s1
    46be:	402010ef          	jal	5ac0 <open>
      if(fd >= 0){
    46c2:	02055163          	bgez	a0,46e4 <forkforkfork+0x98>
      if(fork() < 0){
    46c6:	3b2010ef          	jal	5a78 <fork>
    46ca:	fe0558e3          	bgez	a0,46ba <forkforkfork+0x6e>
        close(open("stopforking", O_CREATE|O_RDWR));
    46ce:	20200593          	li	a1,514
    46d2:	00004517          	auipc	a0,0x4
    46d6:	3ce50513          	addi	a0,a0,974 # 8aa0 <malloc+0x2b0c>
    46da:	3e6010ef          	jal	5ac0 <open>
    46de:	3ca010ef          	jal	5aa8 <close>
    46e2:	bfe1                	j	46ba <forkforkfork+0x6e>
        exit(0);
    46e4:	4501                	li	a0,0
    46e6:	39a010ef          	jal	5a80 <exit>

00000000000046ea <killstatus>:
{
    46ea:	7139                	addi	sp,sp,-64
    46ec:	fc06                	sd	ra,56(sp)
    46ee:	f822                	sd	s0,48(sp)
    46f0:	f426                	sd	s1,40(sp)
    46f2:	f04a                	sd	s2,32(sp)
    46f4:	ec4e                	sd	s3,24(sp)
    46f6:	e852                	sd	s4,16(sp)
    46f8:	0080                	addi	s0,sp,64
    46fa:	8a2a                	mv	s4,a0
    46fc:	06400913          	li	s2,100
    if(xst != -1) {
    4700:	59fd                	li	s3,-1
    int pid1 = fork();
    4702:	376010ef          	jal	5a78 <fork>
    4706:	84aa                	mv	s1,a0
    if(pid1 < 0){
    4708:	02054763          	bltz	a0,4736 <killstatus+0x4c>
    if(pid1 == 0){
    470c:	cd1d                	beqz	a0,474a <killstatus+0x60>
    sleep(1);
    470e:	4505                	li	a0,1
    4710:	400010ef          	jal	5b10 <sleep>
    kill(pid1);
    4714:	8526                	mv	a0,s1
    4716:	39a010ef          	jal	5ab0 <kill>
    wait(&xst);
    471a:	fcc40513          	addi	a0,s0,-52
    471e:	36a010ef          	jal	5a88 <wait>
    if(xst != -1) {
    4722:	fcc42783          	lw	a5,-52(s0)
    4726:	03379563          	bne	a5,s3,4750 <killstatus+0x66>
  for(int i = 0; i < 100; i++){
    472a:	397d                	addiw	s2,s2,-1
    472c:	fc091be3          	bnez	s2,4702 <killstatus+0x18>
  exit(0);
    4730:	4501                	li	a0,0
    4732:	34e010ef          	jal	5a80 <exit>
      printf("%s: fork failed\n", s);
    4736:	85d2                	mv	a1,s4
    4738:	00003517          	auipc	a0,0x3
    473c:	19050513          	addi	a0,a0,400 # 78c8 <malloc+0x1934>
    4740:	7a0010ef          	jal	5ee0 <printf>
      exit(1);
    4744:	4505                	li	a0,1
    4746:	33a010ef          	jal	5a80 <exit>
        getpid();
    474a:	3b6010ef          	jal	5b00 <getpid>
      while(1) {
    474e:	bff5                	j	474a <killstatus+0x60>
       printf("%s: status should be -1\n", s);
    4750:	85d2                	mv	a1,s4
    4752:	00004517          	auipc	a0,0x4
    4756:	35e50513          	addi	a0,a0,862 # 8ab0 <malloc+0x2b1c>
    475a:	786010ef          	jal	5ee0 <printf>
       exit(1);
    475e:	4505                	li	a0,1
    4760:	320010ef          	jal	5a80 <exit>

0000000000004764 <preempt>:
{
    4764:	7139                	addi	sp,sp,-64
    4766:	fc06                	sd	ra,56(sp)
    4768:	f822                	sd	s0,48(sp)
    476a:	f426                	sd	s1,40(sp)
    476c:	f04a                	sd	s2,32(sp)
    476e:	ec4e                	sd	s3,24(sp)
    4770:	e852                	sd	s4,16(sp)
    4772:	0080                	addi	s0,sp,64
    4774:	892a                	mv	s2,a0
  pid1 = fork();
    4776:	302010ef          	jal	5a78 <fork>
  if(pid1 < 0) {
    477a:	00054563          	bltz	a0,4784 <preempt+0x20>
    477e:	84aa                	mv	s1,a0
  if(pid1 == 0)
    4780:	ed01                	bnez	a0,4798 <preempt+0x34>
    for(;;)
    4782:	a001                	j	4782 <preempt+0x1e>
    printf("%s: fork failed", s);
    4784:	85ca                	mv	a1,s2
    4786:	00003517          	auipc	a0,0x3
    478a:	30250513          	addi	a0,a0,770 # 7a88 <malloc+0x1af4>
    478e:	752010ef          	jal	5ee0 <printf>
    exit(1);
    4792:	4505                	li	a0,1
    4794:	2ec010ef          	jal	5a80 <exit>
  pid2 = fork();
    4798:	2e0010ef          	jal	5a78 <fork>
    479c:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    479e:	00054463          	bltz	a0,47a6 <preempt+0x42>
  if(pid2 == 0)
    47a2:	ed01                	bnez	a0,47ba <preempt+0x56>
    for(;;)
    47a4:	a001                	j	47a4 <preempt+0x40>
    printf("%s: fork failed\n", s);
    47a6:	85ca                	mv	a1,s2
    47a8:	00003517          	auipc	a0,0x3
    47ac:	12050513          	addi	a0,a0,288 # 78c8 <malloc+0x1934>
    47b0:	730010ef          	jal	5ee0 <printf>
    exit(1);
    47b4:	4505                	li	a0,1
    47b6:	2ca010ef          	jal	5a80 <exit>
  pipe(pfds);
    47ba:	fc840513          	addi	a0,s0,-56
    47be:	2d2010ef          	jal	5a90 <pipe>
  pid3 = fork();
    47c2:	2b6010ef          	jal	5a78 <fork>
    47c6:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    47c8:	02054863          	bltz	a0,47f8 <preempt+0x94>
  if(pid3 == 0){
    47cc:	e921                	bnez	a0,481c <preempt+0xb8>
    close(pfds[0]);
    47ce:	fc842503          	lw	a0,-56(s0)
    47d2:	2d6010ef          	jal	5aa8 <close>
    if(write(pfds[1], "x", 1) != 1)
    47d6:	4605                	li	a2,1
    47d8:	00003597          	auipc	a1,0x3
    47dc:	8d058593          	addi	a1,a1,-1840 # 70a8 <malloc+0x1114>
    47e0:	fcc42503          	lw	a0,-52(s0)
    47e4:	2bc010ef          	jal	5aa0 <write>
    47e8:	4785                	li	a5,1
    47ea:	02f51163          	bne	a0,a5,480c <preempt+0xa8>
    close(pfds[1]);
    47ee:	fcc42503          	lw	a0,-52(s0)
    47f2:	2b6010ef          	jal	5aa8 <close>
    for(;;)
    47f6:	a001                	j	47f6 <preempt+0x92>
     printf("%s: fork failed\n", s);
    47f8:	85ca                	mv	a1,s2
    47fa:	00003517          	auipc	a0,0x3
    47fe:	0ce50513          	addi	a0,a0,206 # 78c8 <malloc+0x1934>
    4802:	6de010ef          	jal	5ee0 <printf>
     exit(1);
    4806:	4505                	li	a0,1
    4808:	278010ef          	jal	5a80 <exit>
      printf("%s: preempt write error", s);
    480c:	85ca                	mv	a1,s2
    480e:	00004517          	auipc	a0,0x4
    4812:	2c250513          	addi	a0,a0,706 # 8ad0 <malloc+0x2b3c>
    4816:	6ca010ef          	jal	5ee0 <printf>
    481a:	bfd1                	j	47ee <preempt+0x8a>
  close(pfds[1]);
    481c:	fcc42503          	lw	a0,-52(s0)
    4820:	288010ef          	jal	5aa8 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    4824:	660d                	lui	a2,0x3
    4826:	00009597          	auipc	a1,0x9
    482a:	88258593          	addi	a1,a1,-1918 # d0a8 <buf>
    482e:	fc842503          	lw	a0,-56(s0)
    4832:	266010ef          	jal	5a98 <read>
    4836:	4785                	li	a5,1
    4838:	02f50163          	beq	a0,a5,485a <preempt+0xf6>
    printf("%s: preempt read error", s);
    483c:	85ca                	mv	a1,s2
    483e:	00004517          	auipc	a0,0x4
    4842:	2aa50513          	addi	a0,a0,682 # 8ae8 <malloc+0x2b54>
    4846:	69a010ef          	jal	5ee0 <printf>
}
    484a:	70e2                	ld	ra,56(sp)
    484c:	7442                	ld	s0,48(sp)
    484e:	74a2                	ld	s1,40(sp)
    4850:	7902                	ld	s2,32(sp)
    4852:	69e2                	ld	s3,24(sp)
    4854:	6a42                	ld	s4,16(sp)
    4856:	6121                	addi	sp,sp,64
    4858:	8082                	ret
  close(pfds[0]);
    485a:	fc842503          	lw	a0,-56(s0)
    485e:	24a010ef          	jal	5aa8 <close>
  printf("kill... ");
    4862:	00004517          	auipc	a0,0x4
    4866:	29e50513          	addi	a0,a0,670 # 8b00 <malloc+0x2b6c>
    486a:	676010ef          	jal	5ee0 <printf>
  kill(pid1);
    486e:	8526                	mv	a0,s1
    4870:	240010ef          	jal	5ab0 <kill>
  kill(pid2);
    4874:	854e                	mv	a0,s3
    4876:	23a010ef          	jal	5ab0 <kill>
  kill(pid3);
    487a:	8552                	mv	a0,s4
    487c:	234010ef          	jal	5ab0 <kill>
  printf("wait... ");
    4880:	00004517          	auipc	a0,0x4
    4884:	29050513          	addi	a0,a0,656 # 8b10 <malloc+0x2b7c>
    4888:	658010ef          	jal	5ee0 <printf>
  wait(0);
    488c:	4501                	li	a0,0
    488e:	1fa010ef          	jal	5a88 <wait>
  wait(0);
    4892:	4501                	li	a0,0
    4894:	1f4010ef          	jal	5a88 <wait>
  wait(0);
    4898:	4501                	li	a0,0
    489a:	1ee010ef          	jal	5a88 <wait>
    489e:	b775                	j	484a <preempt+0xe6>

00000000000048a0 <reparent>:
{
    48a0:	7179                	addi	sp,sp,-48
    48a2:	f406                	sd	ra,40(sp)
    48a4:	f022                	sd	s0,32(sp)
    48a6:	ec26                	sd	s1,24(sp)
    48a8:	e84a                	sd	s2,16(sp)
    48aa:	e44e                	sd	s3,8(sp)
    48ac:	e052                	sd	s4,0(sp)
    48ae:	1800                	addi	s0,sp,48
    48b0:	89aa                	mv	s3,a0
  int master_pid = getpid();
    48b2:	24e010ef          	jal	5b00 <getpid>
    48b6:	8a2a                	mv	s4,a0
    48b8:	0c800913          	li	s2,200
    int pid = fork();
    48bc:	1bc010ef          	jal	5a78 <fork>
    48c0:	84aa                	mv	s1,a0
    if(pid < 0){
    48c2:	00054e63          	bltz	a0,48de <reparent+0x3e>
    if(pid){
    48c6:	c121                	beqz	a0,4906 <reparent+0x66>
      if(wait(0) != pid){
    48c8:	4501                	li	a0,0
    48ca:	1be010ef          	jal	5a88 <wait>
    48ce:	02951263          	bne	a0,s1,48f2 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    48d2:	397d                	addiw	s2,s2,-1
    48d4:	fe0914e3          	bnez	s2,48bc <reparent+0x1c>
  exit(0);
    48d8:	4501                	li	a0,0
    48da:	1a6010ef          	jal	5a80 <exit>
      printf("%s: fork failed\n", s);
    48de:	85ce                	mv	a1,s3
    48e0:	00003517          	auipc	a0,0x3
    48e4:	fe850513          	addi	a0,a0,-24 # 78c8 <malloc+0x1934>
    48e8:	5f8010ef          	jal	5ee0 <printf>
      exit(1);
    48ec:	4505                	li	a0,1
    48ee:	192010ef          	jal	5a80 <exit>
        printf("%s: wait wrong pid\n", s);
    48f2:	85ce                	mv	a1,s3
    48f4:	00003517          	auipc	a0,0x3
    48f8:	15c50513          	addi	a0,a0,348 # 7a50 <malloc+0x1abc>
    48fc:	5e4010ef          	jal	5ee0 <printf>
        exit(1);
    4900:	4505                	li	a0,1
    4902:	17e010ef          	jal	5a80 <exit>
      int pid2 = fork();
    4906:	172010ef          	jal	5a78 <fork>
      if(pid2 < 0){
    490a:	00054563          	bltz	a0,4914 <reparent+0x74>
      exit(0);
    490e:	4501                	li	a0,0
    4910:	170010ef          	jal	5a80 <exit>
        kill(master_pid);
    4914:	8552                	mv	a0,s4
    4916:	19a010ef          	jal	5ab0 <kill>
        exit(1);
    491a:	4505                	li	a0,1
    491c:	164010ef          	jal	5a80 <exit>

0000000000004920 <sbrkfail>:
{
    4920:	7119                	addi	sp,sp,-128
    4922:	fc86                	sd	ra,120(sp)
    4924:	f8a2                	sd	s0,112(sp)
    4926:	f4a6                	sd	s1,104(sp)
    4928:	f0ca                	sd	s2,96(sp)
    492a:	ecce                	sd	s3,88(sp)
    492c:	e8d2                	sd	s4,80(sp)
    492e:	e4d6                	sd	s5,72(sp)
    4930:	0100                	addi	s0,sp,128
    4932:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4934:	fb040513          	addi	a0,s0,-80
    4938:	158010ef          	jal	5a90 <pipe>
    493c:	e901                	bnez	a0,494c <sbrkfail+0x2c>
    493e:	f8040493          	addi	s1,s0,-128
    4942:	fa840993          	addi	s3,s0,-88
    4946:	8926                	mv	s2,s1
    if(pids[i] != -1)
    4948:	5a7d                	li	s4,-1
    494a:	a0a1                	j	4992 <sbrkfail+0x72>
    printf("%s: pipe() failed\n", s);
    494c:	85d6                	mv	a1,s5
    494e:	00003517          	auipc	a0,0x3
    4952:	08250513          	addi	a0,a0,130 # 79d0 <malloc+0x1a3c>
    4956:	58a010ef          	jal	5ee0 <printf>
    exit(1);
    495a:	4505                	li	a0,1
    495c:	124010ef          	jal	5a80 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    4960:	1a8010ef          	jal	5b08 <sbrk>
    4964:	064007b7          	lui	a5,0x6400
    4968:	40a7853b          	subw	a0,a5,a0
    496c:	19c010ef          	jal	5b08 <sbrk>
      write(fds[1], "x", 1);
    4970:	4605                	li	a2,1
    4972:	00002597          	auipc	a1,0x2
    4976:	73658593          	addi	a1,a1,1846 # 70a8 <malloc+0x1114>
    497a:	fb442503          	lw	a0,-76(s0)
    497e:	122010ef          	jal	5aa0 <write>
      for(;;) sleep(1000);
    4982:	3e800513          	li	a0,1000
    4986:	18a010ef          	jal	5b10 <sleep>
    498a:	bfe5                	j	4982 <sbrkfail+0x62>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    498c:	0911                	addi	s2,s2,4
    498e:	03390163          	beq	s2,s3,49b0 <sbrkfail+0x90>
    if((pids[i] = fork()) == 0){
    4992:	0e6010ef          	jal	5a78 <fork>
    4996:	00a92023          	sw	a0,0(s2)
    499a:	d179                	beqz	a0,4960 <sbrkfail+0x40>
    if(pids[i] != -1)
    499c:	ff4508e3          	beq	a0,s4,498c <sbrkfail+0x6c>
      read(fds[0], &scratch, 1);
    49a0:	4605                	li	a2,1
    49a2:	faf40593          	addi	a1,s0,-81
    49a6:	fb042503          	lw	a0,-80(s0)
    49aa:	0ee010ef          	jal	5a98 <read>
    49ae:	bff9                	j	498c <sbrkfail+0x6c>
  c = sbrk(PGSIZE);
    49b0:	6505                	lui	a0,0x1
    49b2:	156010ef          	jal	5b08 <sbrk>
    49b6:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    49b8:	597d                	li	s2,-1
    49ba:	a021                	j	49c2 <sbrkfail+0xa2>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    49bc:	0491                	addi	s1,s1,4
    49be:	01348b63          	beq	s1,s3,49d4 <sbrkfail+0xb4>
    if(pids[i] == -1)
    49c2:	4088                	lw	a0,0(s1)
    49c4:	ff250ce3          	beq	a0,s2,49bc <sbrkfail+0x9c>
    kill(pids[i]);
    49c8:	0e8010ef          	jal	5ab0 <kill>
    wait(0);
    49cc:	4501                	li	a0,0
    49ce:	0ba010ef          	jal	5a88 <wait>
    49d2:	b7ed                	j	49bc <sbrkfail+0x9c>
  if(c == (char*)0xffffffffffffffffL){
    49d4:	57fd                	li	a5,-1
    49d6:	02fa0d63          	beq	s4,a5,4a10 <sbrkfail+0xf0>
  pid = fork();
    49da:	09e010ef          	jal	5a78 <fork>
    49de:	84aa                	mv	s1,a0
  if(pid < 0){
    49e0:	04054263          	bltz	a0,4a24 <sbrkfail+0x104>
  if(pid == 0){
    49e4:	c931                	beqz	a0,4a38 <sbrkfail+0x118>
  wait(&xstatus);
    49e6:	fbc40513          	addi	a0,s0,-68
    49ea:	09e010ef          	jal	5a88 <wait>
  if(xstatus != -1 && xstatus != 2)
    49ee:	fbc42783          	lw	a5,-68(s0)
    49f2:	577d                	li	a4,-1
    49f4:	00e78563          	beq	a5,a4,49fe <sbrkfail+0xde>
    49f8:	4709                	li	a4,2
    49fa:	06e79d63          	bne	a5,a4,4a74 <sbrkfail+0x154>
}
    49fe:	70e6                	ld	ra,120(sp)
    4a00:	7446                	ld	s0,112(sp)
    4a02:	74a6                	ld	s1,104(sp)
    4a04:	7906                	ld	s2,96(sp)
    4a06:	69e6                	ld	s3,88(sp)
    4a08:	6a46                	ld	s4,80(sp)
    4a0a:	6aa6                	ld	s5,72(sp)
    4a0c:	6109                	addi	sp,sp,128
    4a0e:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    4a10:	85d6                	mv	a1,s5
    4a12:	00004517          	auipc	a0,0x4
    4a16:	10e50513          	addi	a0,a0,270 # 8b20 <malloc+0x2b8c>
    4a1a:	4c6010ef          	jal	5ee0 <printf>
    exit(1);
    4a1e:	4505                	li	a0,1
    4a20:	060010ef          	jal	5a80 <exit>
    printf("%s: fork failed\n", s);
    4a24:	85d6                	mv	a1,s5
    4a26:	00003517          	auipc	a0,0x3
    4a2a:	ea250513          	addi	a0,a0,-350 # 78c8 <malloc+0x1934>
    4a2e:	4b2010ef          	jal	5ee0 <printf>
    exit(1);
    4a32:	4505                	li	a0,1
    4a34:	04c010ef          	jal	5a80 <exit>
    a = sbrk(0);
    4a38:	4501                	li	a0,0
    4a3a:	0ce010ef          	jal	5b08 <sbrk>
    4a3e:	892a                	mv	s2,a0
    sbrk(10*BIG);
    4a40:	3e800537          	lui	a0,0x3e800
    4a44:	0c4010ef          	jal	5b08 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4a48:	87ca                	mv	a5,s2
    4a4a:	3e800737          	lui	a4,0x3e800
    4a4e:	993a                	add	s2,s2,a4
    4a50:	6705                	lui	a4,0x1
      n += *(a+i);
    4a52:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63eff58>
    4a56:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    4a58:	97ba                	add	a5,a5,a4
    4a5a:	fef91ce3          	bne	s2,a5,4a52 <sbrkfail+0x132>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    4a5e:	8626                	mv	a2,s1
    4a60:	85d6                	mv	a1,s5
    4a62:	00004517          	auipc	a0,0x4
    4a66:	0de50513          	addi	a0,a0,222 # 8b40 <malloc+0x2bac>
    4a6a:	476010ef          	jal	5ee0 <printf>
    exit(1);
    4a6e:	4505                	li	a0,1
    4a70:	010010ef          	jal	5a80 <exit>
    exit(1);
    4a74:	4505                	li	a0,1
    4a76:	00a010ef          	jal	5a80 <exit>

0000000000004a7a <mem>:
{
    4a7a:	7139                	addi	sp,sp,-64
    4a7c:	fc06                	sd	ra,56(sp)
    4a7e:	f822                	sd	s0,48(sp)
    4a80:	f426                	sd	s1,40(sp)
    4a82:	f04a                	sd	s2,32(sp)
    4a84:	ec4e                	sd	s3,24(sp)
    4a86:	0080                	addi	s0,sp,64
    4a88:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4a8a:	7ef000ef          	jal	5a78 <fork>
    m1 = 0;
    4a8e:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4a90:	6909                	lui	s2,0x2
    4a92:	71190913          	addi	s2,s2,1809 # 2711 <twochildren+0x31>
  if((pid = fork()) == 0){
    4a96:	cd11                	beqz	a0,4ab2 <mem+0x38>
    wait(&xstatus);
    4a98:	fcc40513          	addi	a0,s0,-52
    4a9c:	7ed000ef          	jal	5a88 <wait>
    if(xstatus == -1){
    4aa0:	fcc42503          	lw	a0,-52(s0)
    4aa4:	57fd                	li	a5,-1
    4aa6:	04f50363          	beq	a0,a5,4aec <mem+0x72>
    exit(xstatus);
    4aaa:	7d7000ef          	jal	5a80 <exit>
      *(char**)m2 = m1;
    4aae:	e104                	sd	s1,0(a0)
      m1 = m2;
    4ab0:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4ab2:	854a                	mv	a0,s2
    4ab4:	4e0010ef          	jal	5f94 <malloc>
    4ab8:	f97d                	bnez	a0,4aae <mem+0x34>
    while(m1){
    4aba:	c491                	beqz	s1,4ac6 <mem+0x4c>
      m2 = *(char**)m1;
    4abc:	8526                	mv	a0,s1
    4abe:	6084                	ld	s1,0(s1)
      free(m1);
    4ac0:	452010ef          	jal	5f12 <free>
    while(m1){
    4ac4:	fce5                	bnez	s1,4abc <mem+0x42>
    m1 = malloc(1024*20);
    4ac6:	6515                	lui	a0,0x5
    4ac8:	4cc010ef          	jal	5f94 <malloc>
    if(m1 == 0){
    4acc:	c511                	beqz	a0,4ad8 <mem+0x5e>
    free(m1);
    4ace:	444010ef          	jal	5f12 <free>
    exit(0);
    4ad2:	4501                	li	a0,0
    4ad4:	7ad000ef          	jal	5a80 <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    4ad8:	85ce                	mv	a1,s3
    4ada:	00004517          	auipc	a0,0x4
    4ade:	09650513          	addi	a0,a0,150 # 8b70 <malloc+0x2bdc>
    4ae2:	3fe010ef          	jal	5ee0 <printf>
      exit(1);
    4ae6:	4505                	li	a0,1
    4ae8:	799000ef          	jal	5a80 <exit>
      exit(0);
    4aec:	4501                	li	a0,0
    4aee:	793000ef          	jal	5a80 <exit>

0000000000004af2 <sharedfd>:
{
    4af2:	7159                	addi	sp,sp,-112
    4af4:	f486                	sd	ra,104(sp)
    4af6:	f0a2                	sd	s0,96(sp)
    4af8:	e0d2                	sd	s4,64(sp)
    4afa:	1880                	addi	s0,sp,112
    4afc:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4afe:	00004517          	auipc	a0,0x4
    4b02:	09250513          	addi	a0,a0,146 # 8b90 <malloc+0x2bfc>
    4b06:	7cb000ef          	jal	5ad0 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4b0a:	20200593          	li	a1,514
    4b0e:	00004517          	auipc	a0,0x4
    4b12:	08250513          	addi	a0,a0,130 # 8b90 <malloc+0x2bfc>
    4b16:	7ab000ef          	jal	5ac0 <open>
  if(fd < 0){
    4b1a:	04054863          	bltz	a0,4b6a <sharedfd+0x78>
    4b1e:	eca6                	sd	s1,88(sp)
    4b20:	e8ca                	sd	s2,80(sp)
    4b22:	e4ce                	sd	s3,72(sp)
    4b24:	fc56                	sd	s5,56(sp)
    4b26:	f85a                	sd	s6,48(sp)
    4b28:	f45e                	sd	s7,40(sp)
    4b2a:	892a                	mv	s2,a0
  pid = fork();
    4b2c:	74d000ef          	jal	5a78 <fork>
    4b30:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4b32:	07000593          	li	a1,112
    4b36:	e119                	bnez	a0,4b3c <sharedfd+0x4a>
    4b38:	06300593          	li	a1,99
    4b3c:	4629                	li	a2,10
    4b3e:	fa040513          	addi	a0,s0,-96
    4b42:	559000ef          	jal	589a <memset>
    4b46:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4b4a:	4629                	li	a2,10
    4b4c:	fa040593          	addi	a1,s0,-96
    4b50:	854a                	mv	a0,s2
    4b52:	74f000ef          	jal	5aa0 <write>
    4b56:	47a9                	li	a5,10
    4b58:	02f51963          	bne	a0,a5,4b8a <sharedfd+0x98>
  for(i = 0; i < N; i++){
    4b5c:	34fd                	addiw	s1,s1,-1
    4b5e:	f4f5                	bnez	s1,4b4a <sharedfd+0x58>
  if(pid == 0) {
    4b60:	02099f63          	bnez	s3,4b9e <sharedfd+0xac>
    exit(0);
    4b64:	4501                	li	a0,0
    4b66:	71b000ef          	jal	5a80 <exit>
    4b6a:	eca6                	sd	s1,88(sp)
    4b6c:	e8ca                	sd	s2,80(sp)
    4b6e:	e4ce                	sd	s3,72(sp)
    4b70:	fc56                	sd	s5,56(sp)
    4b72:	f85a                	sd	s6,48(sp)
    4b74:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4b76:	85d2                	mv	a1,s4
    4b78:	00004517          	auipc	a0,0x4
    4b7c:	02850513          	addi	a0,a0,40 # 8ba0 <malloc+0x2c0c>
    4b80:	360010ef          	jal	5ee0 <printf>
    exit(1);
    4b84:	4505                	li	a0,1
    4b86:	6fb000ef          	jal	5a80 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b8a:	85d2                	mv	a1,s4
    4b8c:	00004517          	auipc	a0,0x4
    4b90:	03c50513          	addi	a0,a0,60 # 8bc8 <malloc+0x2c34>
    4b94:	34c010ef          	jal	5ee0 <printf>
      exit(1);
    4b98:	4505                	li	a0,1
    4b9a:	6e7000ef          	jal	5a80 <exit>
    wait(&xstatus);
    4b9e:	f9c40513          	addi	a0,s0,-100
    4ba2:	6e7000ef          	jal	5a88 <wait>
    if(xstatus != 0)
    4ba6:	f9c42983          	lw	s3,-100(s0)
    4baa:	00098563          	beqz	s3,4bb4 <sharedfd+0xc2>
      exit(xstatus);
    4bae:	854e                	mv	a0,s3
    4bb0:	6d1000ef          	jal	5a80 <exit>
  close(fd);
    4bb4:	854a                	mv	a0,s2
    4bb6:	6f3000ef          	jal	5aa8 <close>
  fd = open("sharedfd", 0);
    4bba:	4581                	li	a1,0
    4bbc:	00004517          	auipc	a0,0x4
    4bc0:	fd450513          	addi	a0,a0,-44 # 8b90 <malloc+0x2bfc>
    4bc4:	6fd000ef          	jal	5ac0 <open>
    4bc8:	8baa                	mv	s7,a0
  nc = np = 0;
    4bca:	8ace                	mv	s5,s3
  if(fd < 0){
    4bcc:	02054363          	bltz	a0,4bf2 <sharedfd+0x100>
    4bd0:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    4bd4:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4bd8:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4bdc:	4629                	li	a2,10
    4bde:	fa040593          	addi	a1,s0,-96
    4be2:	855e                	mv	a0,s7
    4be4:	6b5000ef          	jal	5a98 <read>
    4be8:	02a05b63          	blez	a0,4c1e <sharedfd+0x12c>
    4bec:	fa040793          	addi	a5,s0,-96
    4bf0:	a839                	j	4c0e <sharedfd+0x11c>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bf2:	85d2                	mv	a1,s4
    4bf4:	00004517          	auipc	a0,0x4
    4bf8:	ff450513          	addi	a0,a0,-12 # 8be8 <malloc+0x2c54>
    4bfc:	2e4010ef          	jal	5ee0 <printf>
    exit(1);
    4c00:	4505                	li	a0,1
    4c02:	67f000ef          	jal	5a80 <exit>
        nc++;
    4c06:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4c08:	0785                	addi	a5,a5,1
    4c0a:	fd2789e3          	beq	a5,s2,4bdc <sharedfd+0xea>
      if(buf[i] == 'c')
    4c0e:	0007c703          	lbu	a4,0(a5)
    4c12:	fe970ae3          	beq	a4,s1,4c06 <sharedfd+0x114>
      if(buf[i] == 'p')
    4c16:	ff6719e3          	bne	a4,s6,4c08 <sharedfd+0x116>
        np++;
    4c1a:	2a85                	addiw	s5,s5,1
    4c1c:	b7f5                	j	4c08 <sharedfd+0x116>
  close(fd);
    4c1e:	855e                	mv	a0,s7
    4c20:	689000ef          	jal	5aa8 <close>
  unlink("sharedfd");
    4c24:	00004517          	auipc	a0,0x4
    4c28:	f6c50513          	addi	a0,a0,-148 # 8b90 <malloc+0x2bfc>
    4c2c:	6a5000ef          	jal	5ad0 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c30:	6789                	lui	a5,0x2
    4c32:	71078793          	addi	a5,a5,1808 # 2710 <twochildren+0x30>
    4c36:	00f99763          	bne	s3,a5,4c44 <sharedfd+0x152>
    4c3a:	6789                	lui	a5,0x2
    4c3c:	71078793          	addi	a5,a5,1808 # 2710 <twochildren+0x30>
    4c40:	00fa8c63          	beq	s5,a5,4c58 <sharedfd+0x166>
    printf("%s: nc/np test fails\n", s);
    4c44:	85d2                	mv	a1,s4
    4c46:	00004517          	auipc	a0,0x4
    4c4a:	fca50513          	addi	a0,a0,-54 # 8c10 <malloc+0x2c7c>
    4c4e:	292010ef          	jal	5ee0 <printf>
    exit(1);
    4c52:	4505                	li	a0,1
    4c54:	62d000ef          	jal	5a80 <exit>
    exit(0);
    4c58:	4501                	li	a0,0
    4c5a:	627000ef          	jal	5a80 <exit>

0000000000004c5e <fourfiles>:
{
    4c5e:	7135                	addi	sp,sp,-160
    4c60:	ed06                	sd	ra,152(sp)
    4c62:	e922                	sd	s0,144(sp)
    4c64:	e526                	sd	s1,136(sp)
    4c66:	e14a                	sd	s2,128(sp)
    4c68:	fcce                	sd	s3,120(sp)
    4c6a:	f8d2                	sd	s4,112(sp)
    4c6c:	f4d6                	sd	s5,104(sp)
    4c6e:	f0da                	sd	s6,96(sp)
    4c70:	ecde                	sd	s7,88(sp)
    4c72:	e8e2                	sd	s8,80(sp)
    4c74:	e4e6                	sd	s9,72(sp)
    4c76:	e0ea                	sd	s10,64(sp)
    4c78:	fc6e                	sd	s11,56(sp)
    4c7a:	1100                	addi	s0,sp,160
    4c7c:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4c7e:	00004797          	auipc	a5,0x4
    4c82:	faa78793          	addi	a5,a5,-86 # 8c28 <malloc+0x2c94>
    4c86:	f6f43823          	sd	a5,-144(s0)
    4c8a:	00004797          	auipc	a5,0x4
    4c8e:	fa678793          	addi	a5,a5,-90 # 8c30 <malloc+0x2c9c>
    4c92:	f6f43c23          	sd	a5,-136(s0)
    4c96:	00004797          	auipc	a5,0x4
    4c9a:	fa278793          	addi	a5,a5,-94 # 8c38 <malloc+0x2ca4>
    4c9e:	f8f43023          	sd	a5,-128(s0)
    4ca2:	00004797          	auipc	a5,0x4
    4ca6:	f9e78793          	addi	a5,a5,-98 # 8c40 <malloc+0x2cac>
    4caa:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4cae:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4cb2:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4cb4:	4481                	li	s1,0
    4cb6:	4a11                	li	s4,4
    fname = names[pi];
    4cb8:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4cbc:	854e                	mv	a0,s3
    4cbe:	613000ef          	jal	5ad0 <unlink>
    pid = fork();
    4cc2:	5b7000ef          	jal	5a78 <fork>
    if(pid < 0){
    4cc6:	02054e63          	bltz	a0,4d02 <fourfiles+0xa4>
    if(pid == 0){
    4cca:	c531                	beqz	a0,4d16 <fourfiles+0xb8>
  for(pi = 0; pi < NCHILD; pi++){
    4ccc:	2485                	addiw	s1,s1,1
    4cce:	0921                	addi	s2,s2,8
    4cd0:	ff4494e3          	bne	s1,s4,4cb8 <fourfiles+0x5a>
    4cd4:	4491                	li	s1,4
    wait(&xstatus);
    4cd6:	f6c40513          	addi	a0,s0,-148
    4cda:	5af000ef          	jal	5a88 <wait>
    if(xstatus != 0)
    4cde:	f6c42a83          	lw	s5,-148(s0)
    4ce2:	0a0a9463          	bnez	s5,4d8a <fourfiles+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    4ce6:	34fd                	addiw	s1,s1,-1
    4ce8:	f4fd                	bnez	s1,4cd6 <fourfiles+0x78>
    4cea:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4cee:	00008a17          	auipc	s4,0x8
    4cf2:	3baa0a13          	addi	s4,s4,954 # d0a8 <buf>
    if(total != N*SZ){
    4cf6:	6d05                	lui	s10,0x1
    4cf8:	770d0d13          	addi	s10,s10,1904 # 1770 <truncate1+0x90>
  for(i = 0; i < NCHILD; i++){
    4cfc:	03400d93          	li	s11,52
    4d00:	a0ed                	j	4dea <fourfiles+0x18c>
      printf("%s: fork failed\n", s);
    4d02:	85e6                	mv	a1,s9
    4d04:	00003517          	auipc	a0,0x3
    4d08:	bc450513          	addi	a0,a0,-1084 # 78c8 <malloc+0x1934>
    4d0c:	1d4010ef          	jal	5ee0 <printf>
      exit(1);
    4d10:	4505                	li	a0,1
    4d12:	56f000ef          	jal	5a80 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d16:	20200593          	li	a1,514
    4d1a:	854e                	mv	a0,s3
    4d1c:	5a5000ef          	jal	5ac0 <open>
    4d20:	892a                	mv	s2,a0
      if(fd < 0){
    4d22:	04054163          	bltz	a0,4d64 <fourfiles+0x106>
      memset(buf, '0'+pi, SZ);
    4d26:	1f400613          	li	a2,500
    4d2a:	0304859b          	addiw	a1,s1,48
    4d2e:	00008517          	auipc	a0,0x8
    4d32:	37a50513          	addi	a0,a0,890 # d0a8 <buf>
    4d36:	365000ef          	jal	589a <memset>
    4d3a:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d3c:	00008997          	auipc	s3,0x8
    4d40:	36c98993          	addi	s3,s3,876 # d0a8 <buf>
    4d44:	1f400613          	li	a2,500
    4d48:	85ce                	mv	a1,s3
    4d4a:	854a                	mv	a0,s2
    4d4c:	555000ef          	jal	5aa0 <write>
    4d50:	85aa                	mv	a1,a0
    4d52:	1f400793          	li	a5,500
    4d56:	02f51163          	bne	a0,a5,4d78 <fourfiles+0x11a>
      for(i = 0; i < N; i++){
    4d5a:	34fd                	addiw	s1,s1,-1
    4d5c:	f4e5                	bnez	s1,4d44 <fourfiles+0xe6>
      exit(0);
    4d5e:	4501                	li	a0,0
    4d60:	521000ef          	jal	5a80 <exit>
        printf("%s: create failed\n", s);
    4d64:	85e6                	mv	a1,s9
    4d66:	00003517          	auipc	a0,0x3
    4d6a:	bfa50513          	addi	a0,a0,-1030 # 7960 <malloc+0x19cc>
    4d6e:	172010ef          	jal	5ee0 <printf>
        exit(1);
    4d72:	4505                	li	a0,1
    4d74:	50d000ef          	jal	5a80 <exit>
          printf("write failed %d\n", n);
    4d78:	00004517          	auipc	a0,0x4
    4d7c:	ed050513          	addi	a0,a0,-304 # 8c48 <malloc+0x2cb4>
    4d80:	160010ef          	jal	5ee0 <printf>
          exit(1);
    4d84:	4505                	li	a0,1
    4d86:	4fb000ef          	jal	5a80 <exit>
      exit(xstatus);
    4d8a:	8556                	mv	a0,s5
    4d8c:	4f5000ef          	jal	5a80 <exit>
          printf("%s: wrong char\n", s);
    4d90:	85e6                	mv	a1,s9
    4d92:	00004517          	auipc	a0,0x4
    4d96:	ece50513          	addi	a0,a0,-306 # 8c60 <malloc+0x2ccc>
    4d9a:	146010ef          	jal	5ee0 <printf>
          exit(1);
    4d9e:	4505                	li	a0,1
    4da0:	4e1000ef          	jal	5a80 <exit>
      total += n;
    4da4:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4da8:	660d                	lui	a2,0x3
    4daa:	85d2                	mv	a1,s4
    4dac:	854e                	mv	a0,s3
    4dae:	4eb000ef          	jal	5a98 <read>
    4db2:	02a05063          	blez	a0,4dd2 <fourfiles+0x174>
    4db6:	00008797          	auipc	a5,0x8
    4dba:	2f278793          	addi	a5,a5,754 # d0a8 <buf>
    4dbe:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4dc2:	0007c703          	lbu	a4,0(a5)
    4dc6:	fc9715e3          	bne	a4,s1,4d90 <fourfiles+0x132>
      for(j = 0; j < n; j++){
    4dca:	0785                	addi	a5,a5,1
    4dcc:	fed79be3          	bne	a5,a3,4dc2 <fourfiles+0x164>
    4dd0:	bfd1                	j	4da4 <fourfiles+0x146>
    close(fd);
    4dd2:	854e                	mv	a0,s3
    4dd4:	4d5000ef          	jal	5aa8 <close>
    if(total != N*SZ){
    4dd8:	03a91463          	bne	s2,s10,4e00 <fourfiles+0x1a2>
    unlink(fname);
    4ddc:	8562                	mv	a0,s8
    4dde:	4f3000ef          	jal	5ad0 <unlink>
  for(i = 0; i < NCHILD; i++){
    4de2:	0ba1                	addi	s7,s7,8
    4de4:	2b05                	addiw	s6,s6,1
    4de6:	03bb0763          	beq	s6,s11,4e14 <fourfiles+0x1b6>
    fname = names[i];
    4dea:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4dee:	4581                	li	a1,0
    4df0:	8562                	mv	a0,s8
    4df2:	4cf000ef          	jal	5ac0 <open>
    4df6:	89aa                	mv	s3,a0
    total = 0;
    4df8:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4dfa:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4dfe:	b76d                	j	4da8 <fourfiles+0x14a>
      printf("wrong length %d\n", total);
    4e00:	85ca                	mv	a1,s2
    4e02:	00004517          	auipc	a0,0x4
    4e06:	e6e50513          	addi	a0,a0,-402 # 8c70 <malloc+0x2cdc>
    4e0a:	0d6010ef          	jal	5ee0 <printf>
      exit(1);
    4e0e:	4505                	li	a0,1
    4e10:	471000ef          	jal	5a80 <exit>
}
    4e14:	60ea                	ld	ra,152(sp)
    4e16:	644a                	ld	s0,144(sp)
    4e18:	64aa                	ld	s1,136(sp)
    4e1a:	690a                	ld	s2,128(sp)
    4e1c:	79e6                	ld	s3,120(sp)
    4e1e:	7a46                	ld	s4,112(sp)
    4e20:	7aa6                	ld	s5,104(sp)
    4e22:	7b06                	ld	s6,96(sp)
    4e24:	6be6                	ld	s7,88(sp)
    4e26:	6c46                	ld	s8,80(sp)
    4e28:	6ca6                	ld	s9,72(sp)
    4e2a:	6d06                	ld	s10,64(sp)
    4e2c:	7de2                	ld	s11,56(sp)
    4e2e:	610d                	addi	sp,sp,160
    4e30:	8082                	ret

0000000000004e32 <concreate>:
{
    4e32:	7135                	addi	sp,sp,-160
    4e34:	ed06                	sd	ra,152(sp)
    4e36:	e922                	sd	s0,144(sp)
    4e38:	e526                	sd	s1,136(sp)
    4e3a:	e14a                	sd	s2,128(sp)
    4e3c:	fcce                	sd	s3,120(sp)
    4e3e:	f8d2                	sd	s4,112(sp)
    4e40:	f4d6                	sd	s5,104(sp)
    4e42:	f0da                	sd	s6,96(sp)
    4e44:	ecde                	sd	s7,88(sp)
    4e46:	1100                	addi	s0,sp,160
    4e48:	89aa                	mv	s3,a0
  file[0] = 'C';
    4e4a:	04300793          	li	a5,67
    4e4e:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4e52:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4e56:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4e58:	4b0d                	li	s6,3
    4e5a:	4a85                	li	s5,1
      link("C0", file);
    4e5c:	00004b97          	auipc	s7,0x4
    4e60:	e2cb8b93          	addi	s7,s7,-468 # 8c88 <malloc+0x2cf4>
  for(i = 0; i < N; i++){
    4e64:	02800a13          	li	s4,40
    4e68:	a41d                	j	508e <concreate+0x25c>
      link("C0", file);
    4e6a:	fa840593          	addi	a1,s0,-88
    4e6e:	855e                	mv	a0,s7
    4e70:	471000ef          	jal	5ae0 <link>
    if(pid == 0) {
    4e74:	a411                	j	5078 <concreate+0x246>
    } else if(pid == 0 && (i % 5) == 1){
    4e76:	4795                	li	a5,5
    4e78:	02f9693b          	remw	s2,s2,a5
    4e7c:	4785                	li	a5,1
    4e7e:	02f90563          	beq	s2,a5,4ea8 <concreate+0x76>
      fd = open(file, O_CREATE | O_RDWR);
    4e82:	20200593          	li	a1,514
    4e86:	fa840513          	addi	a0,s0,-88
    4e8a:	437000ef          	jal	5ac0 <open>
      if(fd < 0){
    4e8e:	1e055063          	bgez	a0,506e <concreate+0x23c>
        printf("concreate create %s failed\n", file);
    4e92:	fa840593          	addi	a1,s0,-88
    4e96:	00004517          	auipc	a0,0x4
    4e9a:	dfa50513          	addi	a0,a0,-518 # 8c90 <malloc+0x2cfc>
    4e9e:	042010ef          	jal	5ee0 <printf>
        exit(1);
    4ea2:	4505                	li	a0,1
    4ea4:	3dd000ef          	jal	5a80 <exit>
      link("C0", file);
    4ea8:	fa840593          	addi	a1,s0,-88
    4eac:	00004517          	auipc	a0,0x4
    4eb0:	ddc50513          	addi	a0,a0,-548 # 8c88 <malloc+0x2cf4>
    4eb4:	42d000ef          	jal	5ae0 <link>
      exit(0);
    4eb8:	4501                	li	a0,0
    4eba:	3c7000ef          	jal	5a80 <exit>
        exit(1);
    4ebe:	4505                	li	a0,1
    4ec0:	3c1000ef          	jal	5a80 <exit>
  memset(fa, 0, sizeof(fa));
    4ec4:	02800613          	li	a2,40
    4ec8:	4581                	li	a1,0
    4eca:	f8040513          	addi	a0,s0,-128
    4ece:	1cd000ef          	jal	589a <memset>
  fd = open(".", 0);
    4ed2:	4581                	li	a1,0
    4ed4:	00003517          	auipc	a0,0x3
    4ed8:	84c50513          	addi	a0,a0,-1972 # 7720 <malloc+0x178c>
    4edc:	3e5000ef          	jal	5ac0 <open>
    4ee0:	892a                	mv	s2,a0
  n = 0;
    4ee2:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4ee4:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4ee8:	02700b13          	li	s6,39
      fa[i] = 1;
    4eec:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4eee:	4641                	li	a2,16
    4ef0:	f7040593          	addi	a1,s0,-144
    4ef4:	854a                	mv	a0,s2
    4ef6:	3a3000ef          	jal	5a98 <read>
    4efa:	06a05a63          	blez	a0,4f6e <concreate+0x13c>
    if(de.inum == 0)
    4efe:	f7045783          	lhu	a5,-144(s0)
    4f02:	d7f5                	beqz	a5,4eee <concreate+0xbc>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f04:	f7244783          	lbu	a5,-142(s0)
    4f08:	ff4793e3          	bne	a5,s4,4eee <concreate+0xbc>
    4f0c:	f7444783          	lbu	a5,-140(s0)
    4f10:	fff9                	bnez	a5,4eee <concreate+0xbc>
      i = de.name[1] - '0';
    4f12:	f7344783          	lbu	a5,-141(s0)
    4f16:	fd07879b          	addiw	a5,a5,-48
    4f1a:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4f1e:	02eb6063          	bltu	s6,a4,4f3e <concreate+0x10c>
      if(fa[i]){
    4f22:	fb070793          	addi	a5,a4,-80 # fb0 <copyinstr1-0x50>
    4f26:	97a2                	add	a5,a5,s0
    4f28:	fd07c783          	lbu	a5,-48(a5)
    4f2c:	e78d                	bnez	a5,4f56 <concreate+0x124>
      fa[i] = 1;
    4f2e:	fb070793          	addi	a5,a4,-80
    4f32:	00878733          	add	a4,a5,s0
    4f36:	fd770823          	sb	s7,-48(a4)
      n++;
    4f3a:	2a85                	addiw	s5,s5,1
    4f3c:	bf4d                	j	4eee <concreate+0xbc>
        printf("%s: concreate weird file %s\n", s, de.name);
    4f3e:	f7240613          	addi	a2,s0,-142
    4f42:	85ce                	mv	a1,s3
    4f44:	00004517          	auipc	a0,0x4
    4f48:	d6c50513          	addi	a0,a0,-660 # 8cb0 <malloc+0x2d1c>
    4f4c:	795000ef          	jal	5ee0 <printf>
        exit(1);
    4f50:	4505                	li	a0,1
    4f52:	32f000ef          	jal	5a80 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    4f56:	f7240613          	addi	a2,s0,-142
    4f5a:	85ce                	mv	a1,s3
    4f5c:	00004517          	auipc	a0,0x4
    4f60:	d7450513          	addi	a0,a0,-652 # 8cd0 <malloc+0x2d3c>
    4f64:	77d000ef          	jal	5ee0 <printf>
        exit(1);
    4f68:	4505                	li	a0,1
    4f6a:	317000ef          	jal	5a80 <exit>
  close(fd);
    4f6e:	854a                	mv	a0,s2
    4f70:	339000ef          	jal	5aa8 <close>
  if(n != N){
    4f74:	02800793          	li	a5,40
    4f78:	00fa9763          	bne	s5,a5,4f86 <concreate+0x154>
    if(((i % 3) == 0 && pid == 0) ||
    4f7c:	4a8d                	li	s5,3
    4f7e:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    4f80:	02800a13          	li	s4,40
    4f84:	a079                	j	5012 <concreate+0x1e0>
    printf("%s: concreate not enough files in directory listing\n", s);
    4f86:	85ce                	mv	a1,s3
    4f88:	00004517          	auipc	a0,0x4
    4f8c:	d7050513          	addi	a0,a0,-656 # 8cf8 <malloc+0x2d64>
    4f90:	751000ef          	jal	5ee0 <printf>
    exit(1);
    4f94:	4505                	li	a0,1
    4f96:	2eb000ef          	jal	5a80 <exit>
      printf("%s: fork failed\n", s);
    4f9a:	85ce                	mv	a1,s3
    4f9c:	00003517          	auipc	a0,0x3
    4fa0:	92c50513          	addi	a0,a0,-1748 # 78c8 <malloc+0x1934>
    4fa4:	73d000ef          	jal	5ee0 <printf>
      exit(1);
    4fa8:	4505                	li	a0,1
    4faa:	2d7000ef          	jal	5a80 <exit>
      close(open(file, 0));
    4fae:	4581                	li	a1,0
    4fb0:	fa840513          	addi	a0,s0,-88
    4fb4:	30d000ef          	jal	5ac0 <open>
    4fb8:	2f1000ef          	jal	5aa8 <close>
      close(open(file, 0));
    4fbc:	4581                	li	a1,0
    4fbe:	fa840513          	addi	a0,s0,-88
    4fc2:	2ff000ef          	jal	5ac0 <open>
    4fc6:	2e3000ef          	jal	5aa8 <close>
      close(open(file, 0));
    4fca:	4581                	li	a1,0
    4fcc:	fa840513          	addi	a0,s0,-88
    4fd0:	2f1000ef          	jal	5ac0 <open>
    4fd4:	2d5000ef          	jal	5aa8 <close>
      close(open(file, 0));
    4fd8:	4581                	li	a1,0
    4fda:	fa840513          	addi	a0,s0,-88
    4fde:	2e3000ef          	jal	5ac0 <open>
    4fe2:	2c7000ef          	jal	5aa8 <close>
      close(open(file, 0));
    4fe6:	4581                	li	a1,0
    4fe8:	fa840513          	addi	a0,s0,-88
    4fec:	2d5000ef          	jal	5ac0 <open>
    4ff0:	2b9000ef          	jal	5aa8 <close>
      close(open(file, 0));
    4ff4:	4581                	li	a1,0
    4ff6:	fa840513          	addi	a0,s0,-88
    4ffa:	2c7000ef          	jal	5ac0 <open>
    4ffe:	2ab000ef          	jal	5aa8 <close>
    if(pid == 0)
    5002:	06090363          	beqz	s2,5068 <concreate+0x236>
      wait(0);
    5006:	4501                	li	a0,0
    5008:	281000ef          	jal	5a88 <wait>
  for(i = 0; i < N; i++){
    500c:	2485                	addiw	s1,s1,1
    500e:	0b448963          	beq	s1,s4,50c0 <concreate+0x28e>
    file[1] = '0' + i;
    5012:	0304879b          	addiw	a5,s1,48
    5016:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    501a:	25f000ef          	jal	5a78 <fork>
    501e:	892a                	mv	s2,a0
    if(pid < 0){
    5020:	f6054de3          	bltz	a0,4f9a <concreate+0x168>
    if(((i % 3) == 0 && pid == 0) ||
    5024:	0354e73b          	remw	a4,s1,s5
    5028:	00a767b3          	or	a5,a4,a0
    502c:	2781                	sext.w	a5,a5
    502e:	d3c1                	beqz	a5,4fae <concreate+0x17c>
    5030:	01671363          	bne	a4,s6,5036 <concreate+0x204>
       ((i % 3) == 1 && pid != 0)){
    5034:	fd2d                	bnez	a0,4fae <concreate+0x17c>
      unlink(file);
    5036:	fa840513          	addi	a0,s0,-88
    503a:	297000ef          	jal	5ad0 <unlink>
      unlink(file);
    503e:	fa840513          	addi	a0,s0,-88
    5042:	28f000ef          	jal	5ad0 <unlink>
      unlink(file);
    5046:	fa840513          	addi	a0,s0,-88
    504a:	287000ef          	jal	5ad0 <unlink>
      unlink(file);
    504e:	fa840513          	addi	a0,s0,-88
    5052:	27f000ef          	jal	5ad0 <unlink>
      unlink(file);
    5056:	fa840513          	addi	a0,s0,-88
    505a:	277000ef          	jal	5ad0 <unlink>
      unlink(file);
    505e:	fa840513          	addi	a0,s0,-88
    5062:	26f000ef          	jal	5ad0 <unlink>
    5066:	bf71                	j	5002 <concreate+0x1d0>
      exit(0);
    5068:	4501                	li	a0,0
    506a:	217000ef          	jal	5a80 <exit>
      close(fd);
    506e:	23b000ef          	jal	5aa8 <close>
    if(pid == 0) {
    5072:	b599                	j	4eb8 <concreate+0x86>
      close(fd);
    5074:	235000ef          	jal	5aa8 <close>
      wait(&xstatus);
    5078:	f6c40513          	addi	a0,s0,-148
    507c:	20d000ef          	jal	5a88 <wait>
      if(xstatus != 0)
    5080:	f6c42483          	lw	s1,-148(s0)
    5084:	e2049de3          	bnez	s1,4ebe <concreate+0x8c>
  for(i = 0; i < N; i++){
    5088:	2905                	addiw	s2,s2,1
    508a:	e3490de3          	beq	s2,s4,4ec4 <concreate+0x92>
    file[1] = '0' + i;
    508e:	0309079b          	addiw	a5,s2,48
    5092:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    5096:	fa840513          	addi	a0,s0,-88
    509a:	237000ef          	jal	5ad0 <unlink>
    pid = fork();
    509e:	1db000ef          	jal	5a78 <fork>
    if(pid && (i % 3) == 1){
    50a2:	dc050ae3          	beqz	a0,4e76 <concreate+0x44>
    50a6:	036967bb          	remw	a5,s2,s6
    50aa:	dd5780e3          	beq	a5,s5,4e6a <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    50ae:	20200593          	li	a1,514
    50b2:	fa840513          	addi	a0,s0,-88
    50b6:	20b000ef          	jal	5ac0 <open>
      if(fd < 0){
    50ba:	fa055de3          	bgez	a0,5074 <concreate+0x242>
    50be:	bbd1                	j	4e92 <concreate+0x60>
}
    50c0:	60ea                	ld	ra,152(sp)
    50c2:	644a                	ld	s0,144(sp)
    50c4:	64aa                	ld	s1,136(sp)
    50c6:	690a                	ld	s2,128(sp)
    50c8:	79e6                	ld	s3,120(sp)
    50ca:	7a46                	ld	s4,112(sp)
    50cc:	7aa6                	ld	s5,104(sp)
    50ce:	7b06                	ld	s6,96(sp)
    50d0:	6be6                	ld	s7,88(sp)
    50d2:	610d                	addi	sp,sp,160
    50d4:	8082                	ret

00000000000050d6 <bigfile>:
{
    50d6:	7139                	addi	sp,sp,-64
    50d8:	fc06                	sd	ra,56(sp)
    50da:	f822                	sd	s0,48(sp)
    50dc:	f426                	sd	s1,40(sp)
    50de:	f04a                	sd	s2,32(sp)
    50e0:	ec4e                	sd	s3,24(sp)
    50e2:	e852                	sd	s4,16(sp)
    50e4:	e456                	sd	s5,8(sp)
    50e6:	0080                	addi	s0,sp,64
    50e8:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    50ea:	00004517          	auipc	a0,0x4
    50ee:	c4650513          	addi	a0,a0,-954 # 8d30 <malloc+0x2d9c>
    50f2:	1df000ef          	jal	5ad0 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    50f6:	20200593          	li	a1,514
    50fa:	00004517          	auipc	a0,0x4
    50fe:	c3650513          	addi	a0,a0,-970 # 8d30 <malloc+0x2d9c>
    5102:	1bf000ef          	jal	5ac0 <open>
    5106:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5108:	4481                	li	s1,0
    memset(buf, i, SZ);
    510a:	00008917          	auipc	s2,0x8
    510e:	f9e90913          	addi	s2,s2,-98 # d0a8 <buf>
  for(i = 0; i < N; i++){
    5112:	4a51                	li	s4,20
  if(fd < 0){
    5114:	08054663          	bltz	a0,51a0 <bigfile+0xca>
    memset(buf, i, SZ);
    5118:	25800613          	li	a2,600
    511c:	85a6                	mv	a1,s1
    511e:	854a                	mv	a0,s2
    5120:	77a000ef          	jal	589a <memset>
    if(write(fd, buf, SZ) != SZ){
    5124:	25800613          	li	a2,600
    5128:	85ca                	mv	a1,s2
    512a:	854e                	mv	a0,s3
    512c:	175000ef          	jal	5aa0 <write>
    5130:	25800793          	li	a5,600
    5134:	08f51063          	bne	a0,a5,51b4 <bigfile+0xde>
  for(i = 0; i < N; i++){
    5138:	2485                	addiw	s1,s1,1
    513a:	fd449fe3          	bne	s1,s4,5118 <bigfile+0x42>
  close(fd);
    513e:	854e                	mv	a0,s3
    5140:	169000ef          	jal	5aa8 <close>
  fd = open("bigfile.dat", 0);
    5144:	4581                	li	a1,0
    5146:	00004517          	auipc	a0,0x4
    514a:	bea50513          	addi	a0,a0,-1046 # 8d30 <malloc+0x2d9c>
    514e:	173000ef          	jal	5ac0 <open>
    5152:	8a2a                	mv	s4,a0
  total = 0;
    5154:	4981                	li	s3,0
  for(i = 0; ; i++){
    5156:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    5158:	00008917          	auipc	s2,0x8
    515c:	f5090913          	addi	s2,s2,-176 # d0a8 <buf>
  if(fd < 0){
    5160:	06054463          	bltz	a0,51c8 <bigfile+0xf2>
    cc = read(fd, buf, SZ/2);
    5164:	12c00613          	li	a2,300
    5168:	85ca                	mv	a1,s2
    516a:	8552                	mv	a0,s4
    516c:	12d000ef          	jal	5a98 <read>
    if(cc < 0){
    5170:	06054663          	bltz	a0,51dc <bigfile+0x106>
    if(cc == 0)
    5174:	c155                	beqz	a0,5218 <bigfile+0x142>
    if(cc != SZ/2){
    5176:	12c00793          	li	a5,300
    517a:	06f51b63          	bne	a0,a5,51f0 <bigfile+0x11a>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    517e:	01f4d79b          	srliw	a5,s1,0x1f
    5182:	9fa5                	addw	a5,a5,s1
    5184:	4017d79b          	sraiw	a5,a5,0x1
    5188:	00094703          	lbu	a4,0(s2)
    518c:	06f71c63          	bne	a4,a5,5204 <bigfile+0x12e>
    5190:	12b94703          	lbu	a4,299(s2)
    5194:	06f71863          	bne	a4,a5,5204 <bigfile+0x12e>
    total += cc;
    5198:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    519c:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    519e:	b7d9                	j	5164 <bigfile+0x8e>
    printf("%s: cannot create bigfile", s);
    51a0:	85d6                	mv	a1,s5
    51a2:	00004517          	auipc	a0,0x4
    51a6:	b9e50513          	addi	a0,a0,-1122 # 8d40 <malloc+0x2dac>
    51aa:	537000ef          	jal	5ee0 <printf>
    exit(1);
    51ae:	4505                	li	a0,1
    51b0:	0d1000ef          	jal	5a80 <exit>
      printf("%s: write bigfile failed\n", s);
    51b4:	85d6                	mv	a1,s5
    51b6:	00004517          	auipc	a0,0x4
    51ba:	baa50513          	addi	a0,a0,-1110 # 8d60 <malloc+0x2dcc>
    51be:	523000ef          	jal	5ee0 <printf>
      exit(1);
    51c2:	4505                	li	a0,1
    51c4:	0bd000ef          	jal	5a80 <exit>
    printf("%s: cannot open bigfile\n", s);
    51c8:	85d6                	mv	a1,s5
    51ca:	00004517          	auipc	a0,0x4
    51ce:	bb650513          	addi	a0,a0,-1098 # 8d80 <malloc+0x2dec>
    51d2:	50f000ef          	jal	5ee0 <printf>
    exit(1);
    51d6:	4505                	li	a0,1
    51d8:	0a9000ef          	jal	5a80 <exit>
      printf("%s: read bigfile failed\n", s);
    51dc:	85d6                	mv	a1,s5
    51de:	00004517          	auipc	a0,0x4
    51e2:	bc250513          	addi	a0,a0,-1086 # 8da0 <malloc+0x2e0c>
    51e6:	4fb000ef          	jal	5ee0 <printf>
      exit(1);
    51ea:	4505                	li	a0,1
    51ec:	095000ef          	jal	5a80 <exit>
      printf("%s: short read bigfile\n", s);
    51f0:	85d6                	mv	a1,s5
    51f2:	00004517          	auipc	a0,0x4
    51f6:	bce50513          	addi	a0,a0,-1074 # 8dc0 <malloc+0x2e2c>
    51fa:	4e7000ef          	jal	5ee0 <printf>
      exit(1);
    51fe:	4505                	li	a0,1
    5200:	081000ef          	jal	5a80 <exit>
      printf("%s: read bigfile wrong data\n", s);
    5204:	85d6                	mv	a1,s5
    5206:	00004517          	auipc	a0,0x4
    520a:	bd250513          	addi	a0,a0,-1070 # 8dd8 <malloc+0x2e44>
    520e:	4d3000ef          	jal	5ee0 <printf>
      exit(1);
    5212:	4505                	li	a0,1
    5214:	06d000ef          	jal	5a80 <exit>
  close(fd);
    5218:	8552                	mv	a0,s4
    521a:	08f000ef          	jal	5aa8 <close>
  if(total != N*SZ){
    521e:	678d                	lui	a5,0x3
    5220:	ee078793          	addi	a5,a5,-288 # 2ee0 <copyinstr3+0x16>
    5224:	02f99163          	bne	s3,a5,5246 <bigfile+0x170>
  unlink("bigfile.dat");
    5228:	00004517          	auipc	a0,0x4
    522c:	b0850513          	addi	a0,a0,-1272 # 8d30 <malloc+0x2d9c>
    5230:	0a1000ef          	jal	5ad0 <unlink>
}
    5234:	70e2                	ld	ra,56(sp)
    5236:	7442                	ld	s0,48(sp)
    5238:	74a2                	ld	s1,40(sp)
    523a:	7902                	ld	s2,32(sp)
    523c:	69e2                	ld	s3,24(sp)
    523e:	6a42                	ld	s4,16(sp)
    5240:	6aa2                	ld	s5,8(sp)
    5242:	6121                	addi	sp,sp,64
    5244:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    5246:	85d6                	mv	a1,s5
    5248:	00004517          	auipc	a0,0x4
    524c:	bb050513          	addi	a0,a0,-1104 # 8df8 <malloc+0x2e64>
    5250:	491000ef          	jal	5ee0 <printf>
    exit(1);
    5254:	4505                	li	a0,1
    5256:	02b000ef          	jal	5a80 <exit>

000000000000525a <bigargtest>:
{
    525a:	7121                	addi	sp,sp,-448
    525c:	ff06                	sd	ra,440(sp)
    525e:	fb22                	sd	s0,432(sp)
    5260:	f726                	sd	s1,424(sp)
    5262:	0380                	addi	s0,sp,448
    5264:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    5266:	00004517          	auipc	a0,0x4
    526a:	bb250513          	addi	a0,a0,-1102 # 8e18 <malloc+0x2e84>
    526e:	063000ef          	jal	5ad0 <unlink>
  pid = fork();
    5272:	007000ef          	jal	5a78 <fork>
  if(pid == 0){
    5276:	c915                	beqz	a0,52aa <bigargtest+0x50>
  } else if(pid < 0){
    5278:	08054a63          	bltz	a0,530c <bigargtest+0xb2>
  wait(&xstatus);
    527c:	fdc40513          	addi	a0,s0,-36
    5280:	009000ef          	jal	5a88 <wait>
  if(xstatus != 0)
    5284:	fdc42503          	lw	a0,-36(s0)
    5288:	ed41                	bnez	a0,5320 <bigargtest+0xc6>
  fd = open("bigarg-ok", 0);
    528a:	4581                	li	a1,0
    528c:	00004517          	auipc	a0,0x4
    5290:	b8c50513          	addi	a0,a0,-1140 # 8e18 <malloc+0x2e84>
    5294:	02d000ef          	jal	5ac0 <open>
  if(fd < 0){
    5298:	08054663          	bltz	a0,5324 <bigargtest+0xca>
  close(fd);
    529c:	00d000ef          	jal	5aa8 <close>
}
    52a0:	70fa                	ld	ra,440(sp)
    52a2:	745a                	ld	s0,432(sp)
    52a4:	74ba                	ld	s1,424(sp)
    52a6:	6139                	addi	sp,sp,448
    52a8:	8082                	ret
    memset(big, ' ', sizeof(big));
    52aa:	19000613          	li	a2,400
    52ae:	02000593          	li	a1,32
    52b2:	e4840513          	addi	a0,s0,-440
    52b6:	5e4000ef          	jal	589a <memset>
    big[sizeof(big)-1] = '\0';
    52ba:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    52be:	00004797          	auipc	a5,0x4
    52c2:	5d278793          	addi	a5,a5,1490 # 9890 <args.1>
    52c6:	00004697          	auipc	a3,0x4
    52ca:	6c268693          	addi	a3,a3,1730 # 9988 <args.1+0xf8>
      args[i] = big;
    52ce:	e4840713          	addi	a4,s0,-440
    52d2:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    52d4:	07a1                	addi	a5,a5,8
    52d6:	fed79ee3          	bne	a5,a3,52d2 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    52da:	00004597          	auipc	a1,0x4
    52de:	5b658593          	addi	a1,a1,1462 # 9890 <args.1>
    52e2:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    52e6:	00002517          	auipc	a0,0x2
    52ea:	d5250513          	addi	a0,a0,-686 # 7038 <malloc+0x10a4>
    52ee:	7ca000ef          	jal	5ab8 <exec>
    fd = open("bigarg-ok", O_CREATE);
    52f2:	20000593          	li	a1,512
    52f6:	00004517          	auipc	a0,0x4
    52fa:	b2250513          	addi	a0,a0,-1246 # 8e18 <malloc+0x2e84>
    52fe:	7c2000ef          	jal	5ac0 <open>
    close(fd);
    5302:	7a6000ef          	jal	5aa8 <close>
    exit(0);
    5306:	4501                	li	a0,0
    5308:	778000ef          	jal	5a80 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    530c:	85a6                	mv	a1,s1
    530e:	00004517          	auipc	a0,0x4
    5312:	b1a50513          	addi	a0,a0,-1254 # 8e28 <malloc+0x2e94>
    5316:	3cb000ef          	jal	5ee0 <printf>
    exit(1);
    531a:	4505                	li	a0,1
    531c:	764000ef          	jal	5a80 <exit>
    exit(xstatus);
    5320:	760000ef          	jal	5a80 <exit>
    printf("%s: bigarg test failed!\n", s);
    5324:	85a6                	mv	a1,s1
    5326:	00004517          	auipc	a0,0x4
    532a:	b2250513          	addi	a0,a0,-1246 # 8e48 <malloc+0x2eb4>
    532e:	3b3000ef          	jal	5ee0 <printf>
    exit(1);
    5332:	4505                	li	a0,1
    5334:	74c000ef          	jal	5a80 <exit>

0000000000005338 <fsfull>:
{
    5338:	7135                	addi	sp,sp,-160
    533a:	ed06                	sd	ra,152(sp)
    533c:	e922                	sd	s0,144(sp)
    533e:	e526                	sd	s1,136(sp)
    5340:	e14a                	sd	s2,128(sp)
    5342:	fcce                	sd	s3,120(sp)
    5344:	f8d2                	sd	s4,112(sp)
    5346:	f4d6                	sd	s5,104(sp)
    5348:	f0da                	sd	s6,96(sp)
    534a:	ecde                	sd	s7,88(sp)
    534c:	e8e2                	sd	s8,80(sp)
    534e:	e4e6                	sd	s9,72(sp)
    5350:	e0ea                	sd	s10,64(sp)
    5352:	1100                	addi	s0,sp,160
  printf("fsfull test\n");
    5354:	00004517          	auipc	a0,0x4
    5358:	b1450513          	addi	a0,a0,-1260 # 8e68 <malloc+0x2ed4>
    535c:	385000ef          	jal	5ee0 <printf>
  for(nfiles = 0; ; nfiles++){
    5360:	4481                	li	s1,0
    name[0] = 'f';
    5362:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    5366:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    536a:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    536e:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5370:	00004c97          	auipc	s9,0x4
    5374:	b08c8c93          	addi	s9,s9,-1272 # 8e78 <malloc+0x2ee4>
    name[0] = 'f';
    5378:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    537c:	0384c7bb          	divw	a5,s1,s8
    5380:	0307879b          	addiw	a5,a5,48
    5384:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5388:	0384e7bb          	remw	a5,s1,s8
    538c:	0377c7bb          	divw	a5,a5,s7
    5390:	0307879b          	addiw	a5,a5,48
    5394:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5398:	0374e7bb          	remw	a5,s1,s7
    539c:	0367c7bb          	divw	a5,a5,s6
    53a0:	0307879b          	addiw	a5,a5,48
    53a4:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    53a8:	0364e7bb          	remw	a5,s1,s6
    53ac:	0307879b          	addiw	a5,a5,48
    53b0:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    53b4:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    53b8:	f6040593          	addi	a1,s0,-160
    53bc:	8566                	mv	a0,s9
    53be:	323000ef          	jal	5ee0 <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    53c2:	20200593          	li	a1,514
    53c6:	f6040513          	addi	a0,s0,-160
    53ca:	6f6000ef          	jal	5ac0 <open>
    53ce:	892a                	mv	s2,a0
    if(fd < 0){
    53d0:	08055f63          	bgez	a0,546e <fsfull+0x136>
      printf("open %s failed\n", name);
    53d4:	f6040593          	addi	a1,s0,-160
    53d8:	00004517          	auipc	a0,0x4
    53dc:	ab050513          	addi	a0,a0,-1360 # 8e88 <malloc+0x2ef4>
    53e0:	301000ef          	jal	5ee0 <printf>
  while(nfiles >= 0){
    53e4:	0604c163          	bltz	s1,5446 <fsfull+0x10e>
    name[0] = 'f';
    53e8:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    53ec:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    53f0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    53f4:	4929                	li	s2,10
  while(nfiles >= 0){
    53f6:	5afd                	li	s5,-1
    name[0] = 'f';
    53f8:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    53fc:	0344c7bb          	divw	a5,s1,s4
    5400:	0307879b          	addiw	a5,a5,48
    5404:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    5408:	0344e7bb          	remw	a5,s1,s4
    540c:	0337c7bb          	divw	a5,a5,s3
    5410:	0307879b          	addiw	a5,a5,48
    5414:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    5418:	0334e7bb          	remw	a5,s1,s3
    541c:	0327c7bb          	divw	a5,a5,s2
    5420:	0307879b          	addiw	a5,a5,48
    5424:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    5428:	0324e7bb          	remw	a5,s1,s2
    542c:	0307879b          	addiw	a5,a5,48
    5430:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5434:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    5438:	f6040513          	addi	a0,s0,-160
    543c:	694000ef          	jal	5ad0 <unlink>
    nfiles--;
    5440:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    5442:	fb549be3          	bne	s1,s5,53f8 <fsfull+0xc0>
  printf("fsfull test finished\n");
    5446:	00004517          	auipc	a0,0x4
    544a:	a6250513          	addi	a0,a0,-1438 # 8ea8 <malloc+0x2f14>
    544e:	293000ef          	jal	5ee0 <printf>
}
    5452:	60ea                	ld	ra,152(sp)
    5454:	644a                	ld	s0,144(sp)
    5456:	64aa                	ld	s1,136(sp)
    5458:	690a                	ld	s2,128(sp)
    545a:	79e6                	ld	s3,120(sp)
    545c:	7a46                	ld	s4,112(sp)
    545e:	7aa6                	ld	s5,104(sp)
    5460:	7b06                	ld	s6,96(sp)
    5462:	6be6                	ld	s7,88(sp)
    5464:	6c46                	ld	s8,80(sp)
    5466:	6ca6                	ld	s9,72(sp)
    5468:	6d06                	ld	s10,64(sp)
    546a:	610d                	addi	sp,sp,160
    546c:	8082                	ret
    int total = 0;
    546e:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    5470:	00008a97          	auipc	s5,0x8
    5474:	c38a8a93          	addi	s5,s5,-968 # d0a8 <buf>
      if(cc < BSIZE)
    5478:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    547c:	40000613          	li	a2,1024
    5480:	85d6                	mv	a1,s5
    5482:	854a                	mv	a0,s2
    5484:	61c000ef          	jal	5aa0 <write>
      if(cc < BSIZE)
    5488:	00aa5563          	bge	s4,a0,5492 <fsfull+0x15a>
      total += cc;
    548c:	00a989bb          	addw	s3,s3,a0
    while(1){
    5490:	b7f5                	j	547c <fsfull+0x144>
    printf("wrote %d bytes\n", total);
    5492:	85ce                	mv	a1,s3
    5494:	00004517          	auipc	a0,0x4
    5498:	a0450513          	addi	a0,a0,-1532 # 8e98 <malloc+0x2f04>
    549c:	245000ef          	jal	5ee0 <printf>
    close(fd);
    54a0:	854a                	mv	a0,s2
    54a2:	606000ef          	jal	5aa8 <close>
    if(total == 0)
    54a6:	f2098fe3          	beqz	s3,53e4 <fsfull+0xac>
  for(nfiles = 0; ; nfiles++){
    54aa:	2485                	addiw	s1,s1,1
    54ac:	b5f1                	j	5378 <fsfull+0x40>

00000000000054ae <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    54ae:	7179                	addi	sp,sp,-48
    54b0:	f406                	sd	ra,40(sp)
    54b2:	f022                	sd	s0,32(sp)
    54b4:	ec26                	sd	s1,24(sp)
    54b6:	e84a                	sd	s2,16(sp)
    54b8:	1800                	addi	s0,sp,48
    54ba:	84aa                	mv	s1,a0
    54bc:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    54be:	00004517          	auipc	a0,0x4
    54c2:	a0250513          	addi	a0,a0,-1534 # 8ec0 <malloc+0x2f2c>
    54c6:	21b000ef          	jal	5ee0 <printf>
  if((pid = fork()) < 0) {
    54ca:	5ae000ef          	jal	5a78 <fork>
    54ce:	02054a63          	bltz	a0,5502 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    54d2:	c129                	beqz	a0,5514 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    54d4:	fdc40513          	addi	a0,s0,-36
    54d8:	5b0000ef          	jal	5a88 <wait>
    if(xstatus != 0) 
    54dc:	fdc42783          	lw	a5,-36(s0)
    54e0:	cf9d                	beqz	a5,551e <run+0x70>
      printf("FAILED\n");
    54e2:	00004517          	auipc	a0,0x4
    54e6:	a0650513          	addi	a0,a0,-1530 # 8ee8 <malloc+0x2f54>
    54ea:	1f7000ef          	jal	5ee0 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    54ee:	fdc42503          	lw	a0,-36(s0)
  }
}
    54f2:	00153513          	seqz	a0,a0
    54f6:	70a2                	ld	ra,40(sp)
    54f8:	7402                	ld	s0,32(sp)
    54fa:	64e2                	ld	s1,24(sp)
    54fc:	6942                	ld	s2,16(sp)
    54fe:	6145                	addi	sp,sp,48
    5500:	8082                	ret
    printf("runtest: fork error\n");
    5502:	00004517          	auipc	a0,0x4
    5506:	9ce50513          	addi	a0,a0,-1586 # 8ed0 <malloc+0x2f3c>
    550a:	1d7000ef          	jal	5ee0 <printf>
    exit(1);
    550e:	4505                	li	a0,1
    5510:	570000ef          	jal	5a80 <exit>
    f(s);
    5514:	854a                	mv	a0,s2
    5516:	9482                	jalr	s1
    exit(0);
    5518:	4501                	li	a0,0
    551a:	566000ef          	jal	5a80 <exit>
      printf("OK\n");
    551e:	00004517          	auipc	a0,0x4
    5522:	9d250513          	addi	a0,a0,-1582 # 8ef0 <malloc+0x2f5c>
    5526:	1bb000ef          	jal	5ee0 <printf>
    552a:	b7d1                	j	54ee <run+0x40>

000000000000552c <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    552c:	7139                	addi	sp,sp,-64
    552e:	fc06                	sd	ra,56(sp)
    5530:	f822                	sd	s0,48(sp)
    5532:	f04a                	sd	s2,32(sp)
    5534:	0080                	addi	s0,sp,64
  for (struct test *t = tests; t->s != 0; t++) {
    5536:	00853903          	ld	s2,8(a0)
    553a:	06090463          	beqz	s2,55a2 <runtests+0x76>
    553e:	f426                	sd	s1,40(sp)
    5540:	ec4e                	sd	s3,24(sp)
    5542:	e852                	sd	s4,16(sp)
    5544:	e456                	sd	s5,8(sp)
    5546:	84aa                	mv	s1,a0
    5548:	89ae                	mv	s3,a1
    554a:	8a32                	mv	s4,a2
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      if(!run(t->f, t->s)){
        if(continuous != 2){
    554c:	4a89                	li	s5,2
    554e:	a031                	j	555a <runtests+0x2e>
  for (struct test *t = tests; t->s != 0; t++) {
    5550:	04c1                	addi	s1,s1,16
    5552:	0084b903          	ld	s2,8(s1)
    5556:	02090c63          	beqz	s2,558e <runtests+0x62>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    555a:	00098763          	beqz	s3,5568 <runtests+0x3c>
    555e:	85ce                	mv	a1,s3
    5560:	854a                	mv	a0,s2
    5562:	2e2000ef          	jal	5844 <strcmp>
    5566:	f56d                	bnez	a0,5550 <runtests+0x24>
      if(!run(t->f, t->s)){
    5568:	85ca                	mv	a1,s2
    556a:	6088                	ld	a0,0(s1)
    556c:	f43ff0ef          	jal	54ae <run>
    5570:	f165                	bnez	a0,5550 <runtests+0x24>
        if(continuous != 2){
    5572:	fd5a0fe3          	beq	s4,s5,5550 <runtests+0x24>
          printf("SOME TESTS FAILED\n");
    5576:	00004517          	auipc	a0,0x4
    557a:	98250513          	addi	a0,a0,-1662 # 8ef8 <malloc+0x2f64>
    557e:	163000ef          	jal	5ee0 <printf>
          return 1;
    5582:	4505                	li	a0,1
    5584:	74a2                	ld	s1,40(sp)
    5586:	69e2                	ld	s3,24(sp)
    5588:	6a42                	ld	s4,16(sp)
    558a:	6aa2                	ld	s5,8(sp)
    558c:	a031                	j	5598 <runtests+0x6c>
        }
      }
    }
  }
  return 0;
    558e:	4501                	li	a0,0
    5590:	74a2                	ld	s1,40(sp)
    5592:	69e2                	ld	s3,24(sp)
    5594:	6a42                	ld	s4,16(sp)
    5596:	6aa2                	ld	s5,8(sp)
}
    5598:	70e2                	ld	ra,56(sp)
    559a:	7442                	ld	s0,48(sp)
    559c:	7902                	ld	s2,32(sp)
    559e:	6121                	addi	sp,sp,64
    55a0:	8082                	ret
  return 0;
    55a2:	4501                	li	a0,0
    55a4:	bfd5                	j	5598 <runtests+0x6c>

00000000000055a6 <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    55a6:	7139                	addi	sp,sp,-64
    55a8:	fc06                	sd	ra,56(sp)
    55aa:	f822                	sd	s0,48(sp)
    55ac:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    55ae:	fc840513          	addi	a0,s0,-56
    55b2:	4de000ef          	jal	5a90 <pipe>
    55b6:	04054e63          	bltz	a0,5612 <countfree+0x6c>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    55ba:	4be000ef          	jal	5a78 <fork>

  if(pid < 0){
    55be:	06054663          	bltz	a0,562a <countfree+0x84>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    55c2:	e159                	bnez	a0,5648 <countfree+0xa2>
    55c4:	f426                	sd	s1,40(sp)
    55c6:	f04a                	sd	s2,32(sp)
    55c8:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    55ca:	fc842503          	lw	a0,-56(s0)
    55ce:	4da000ef          	jal	5aa8 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    55d2:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    55d4:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    55d6:	00002997          	auipc	s3,0x2
    55da:	ad298993          	addi	s3,s3,-1326 # 70a8 <malloc+0x1114>
      uint64 a = (uint64) sbrk(4096);
    55de:	6505                	lui	a0,0x1
    55e0:	528000ef          	jal	5b08 <sbrk>
      if(a == 0xffffffffffffffff){
    55e4:	05250f63          	beq	a0,s2,5642 <countfree+0x9c>
      *(char *)(a + 4096 - 1) = 1;
    55e8:	6785                	lui	a5,0x1
    55ea:	97aa                	add	a5,a5,a0
    55ec:	fe978fa3          	sb	s1,-1(a5) # fff <copyinstr1-0x1>
      if(write(fds[1], "x", 1) != 1){
    55f0:	8626                	mv	a2,s1
    55f2:	85ce                	mv	a1,s3
    55f4:	fcc42503          	lw	a0,-52(s0)
    55f8:	4a8000ef          	jal	5aa0 <write>
    55fc:	fe9501e3          	beq	a0,s1,55de <countfree+0x38>
        printf("write() failed in countfree()\n");
    5600:	00004517          	auipc	a0,0x4
    5604:	95050513          	addi	a0,a0,-1712 # 8f50 <malloc+0x2fbc>
    5608:	0d9000ef          	jal	5ee0 <printf>
        exit(1);
    560c:	4505                	li	a0,1
    560e:	472000ef          	jal	5a80 <exit>
    5612:	f426                	sd	s1,40(sp)
    5614:	f04a                	sd	s2,32(sp)
    5616:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    5618:	00004517          	auipc	a0,0x4
    561c:	8f850513          	addi	a0,a0,-1800 # 8f10 <malloc+0x2f7c>
    5620:	0c1000ef          	jal	5ee0 <printf>
    exit(1);
    5624:	4505                	li	a0,1
    5626:	45a000ef          	jal	5a80 <exit>
    562a:	f426                	sd	s1,40(sp)
    562c:	f04a                	sd	s2,32(sp)
    562e:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    5630:	00004517          	auipc	a0,0x4
    5634:	90050513          	addi	a0,a0,-1792 # 8f30 <malloc+0x2f9c>
    5638:	0a9000ef          	jal	5ee0 <printf>
    exit(1);
    563c:	4505                	li	a0,1
    563e:	442000ef          	jal	5a80 <exit>
      }
    }

    exit(0);
    5642:	4501                	li	a0,0
    5644:	43c000ef          	jal	5a80 <exit>
    5648:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    564a:	fcc42503          	lw	a0,-52(s0)
    564e:	45a000ef          	jal	5aa8 <close>

  int n = 0;
    5652:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    5654:	4605                	li	a2,1
    5656:	fc740593          	addi	a1,s0,-57
    565a:	fc842503          	lw	a0,-56(s0)
    565e:	43a000ef          	jal	5a98 <read>
    if(cc < 0){
    5662:	00054563          	bltz	a0,566c <countfree+0xc6>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5666:	cd11                	beqz	a0,5682 <countfree+0xdc>
      break;
    n += 1;
    5668:	2485                	addiw	s1,s1,1
  while(1){
    566a:	b7ed                	j	5654 <countfree+0xae>
    566c:	f04a                	sd	s2,32(sp)
    566e:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    5670:	00004517          	auipc	a0,0x4
    5674:	90050513          	addi	a0,a0,-1792 # 8f70 <malloc+0x2fdc>
    5678:	069000ef          	jal	5ee0 <printf>
      exit(1);
    567c:	4505                	li	a0,1
    567e:	402000ef          	jal	5a80 <exit>
  }

  close(fds[0]);
    5682:	fc842503          	lw	a0,-56(s0)
    5686:	422000ef          	jal	5aa8 <close>
  wait((int*)0);
    568a:	4501                	li	a0,0
    568c:	3fc000ef          	jal	5a88 <wait>
  
  return n;
}
    5690:	8526                	mv	a0,s1
    5692:	74a2                	ld	s1,40(sp)
    5694:	70e2                	ld	ra,56(sp)
    5696:	7442                	ld	s0,48(sp)
    5698:	6121                	addi	sp,sp,64
    569a:	8082                	ret

000000000000569c <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    569c:	711d                	addi	sp,sp,-96
    569e:	ec86                	sd	ra,88(sp)
    56a0:	e8a2                	sd	s0,80(sp)
    56a2:	e4a6                	sd	s1,72(sp)
    56a4:	e0ca                	sd	s2,64(sp)
    56a6:	fc4e                	sd	s3,56(sp)
    56a8:	f852                	sd	s4,48(sp)
    56aa:	f456                	sd	s5,40(sp)
    56ac:	f05a                	sd	s6,32(sp)
    56ae:	ec5e                	sd	s7,24(sp)
    56b0:	e862                	sd	s8,16(sp)
    56b2:	e466                	sd	s9,8(sp)
    56b4:	e06a                	sd	s10,0(sp)
    56b6:	1080                	addi	s0,sp,96
    56b8:	8aaa                	mv	s5,a0
    56ba:	892e                	mv	s2,a1
    56bc:	89b2                	mv	s3,a2
  do {
    printf("usertests starting\n");
    56be:	00004b97          	auipc	s7,0x4
    56c2:	8d2b8b93          	addi	s7,s7,-1838 # 8f90 <malloc+0x2ffc>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone, continuous)) {
    56c6:	00004b17          	auipc	s6,0x4
    56ca:	d7ab0b13          	addi	s6,s6,-646 # 9440 <quicktests>
      if(continuous != 2) {
    56ce:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone, continuous)) {
    56d0:	00004c17          	auipc	s8,0x4
    56d4:	140c0c13          	addi	s8,s8,320 # 9810 <slowtests>
        printf("usertests slow tests starting\n");
    56d8:	00004d17          	auipc	s10,0x4
    56dc:	8d0d0d13          	addi	s10,s10,-1840 # 8fa8 <malloc+0x3014>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    56e0:	00004c97          	auipc	s9,0x4
    56e4:	8e8c8c93          	addi	s9,s9,-1816 # 8fc8 <malloc+0x3034>
    56e8:	a819                	j	56fe <drivetests+0x62>
        printf("usertests slow tests starting\n");
    56ea:	856a                	mv	a0,s10
    56ec:	7f4000ef          	jal	5ee0 <printf>
    56f0:	a80d                	j	5722 <drivetests+0x86>
    if((free1 = countfree()) < free0) {
    56f2:	eb5ff0ef          	jal	55a6 <countfree>
    56f6:	04954063          	blt	a0,s1,5736 <drivetests+0x9a>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    56fa:	04090963          	beqz	s2,574c <drivetests+0xb0>
    printf("usertests starting\n");
    56fe:	855e                	mv	a0,s7
    5700:	7e0000ef          	jal	5ee0 <printf>
    int free0 = countfree();
    5704:	ea3ff0ef          	jal	55a6 <countfree>
    5708:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone, continuous)) {
    570a:	864a                	mv	a2,s2
    570c:	85ce                	mv	a1,s3
    570e:	855a                	mv	a0,s6
    5710:	e1dff0ef          	jal	552c <runtests>
    5714:	c119                	beqz	a0,571a <drivetests+0x7e>
      if(continuous != 2) {
    5716:	03491963          	bne	s2,s4,5748 <drivetests+0xac>
    if(!quick) {
    571a:	fc0a9ce3          	bnez	s5,56f2 <drivetests+0x56>
      if (justone == 0)
    571e:	fc0986e3          	beqz	s3,56ea <drivetests+0x4e>
      if (runtests(slowtests, justone, continuous)) {
    5722:	864a                	mv	a2,s2
    5724:	85ce                	mv	a1,s3
    5726:	8562                	mv	a0,s8
    5728:	e05ff0ef          	jal	552c <runtests>
    572c:	d179                	beqz	a0,56f2 <drivetests+0x56>
        if(continuous != 2) {
    572e:	fd4902e3          	beq	s2,s4,56f2 <drivetests+0x56>
          return 1;
    5732:	4505                	li	a0,1
    5734:	a829                	j	574e <drivetests+0xb2>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5736:	8626                	mv	a2,s1
    5738:	85aa                	mv	a1,a0
    573a:	8566                	mv	a0,s9
    573c:	7a4000ef          	jal	5ee0 <printf>
      if(continuous != 2) {
    5740:	fb490fe3          	beq	s2,s4,56fe <drivetests+0x62>
        return 1;
    5744:	4505                	li	a0,1
    5746:	a021                	j	574e <drivetests+0xb2>
        return 1;
    5748:	4505                	li	a0,1
    574a:	a011                	j	574e <drivetests+0xb2>
  return 0;
    574c:	854a                	mv	a0,s2
}
    574e:	60e6                	ld	ra,88(sp)
    5750:	6446                	ld	s0,80(sp)
    5752:	64a6                	ld	s1,72(sp)
    5754:	6906                	ld	s2,64(sp)
    5756:	79e2                	ld	s3,56(sp)
    5758:	7a42                	ld	s4,48(sp)
    575a:	7aa2                	ld	s5,40(sp)
    575c:	7b02                	ld	s6,32(sp)
    575e:	6be2                	ld	s7,24(sp)
    5760:	6c42                	ld	s8,16(sp)
    5762:	6ca2                	ld	s9,8(sp)
    5764:	6d02                	ld	s10,0(sp)
    5766:	6125                	addi	sp,sp,96
    5768:	8082                	ret

000000000000576a <main>:

int
main(int argc, char *argv[])
{
    576a:	1101                	addi	sp,sp,-32
    576c:	ec06                	sd	ra,24(sp)
    576e:	e822                	sd	s0,16(sp)
    5770:	e426                	sd	s1,8(sp)
    5772:	e04a                	sd	s2,0(sp)
    5774:	1000                	addi	s0,sp,32
    5776:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5778:	4789                	li	a5,2
    577a:	00f50f63          	beq	a0,a5,5798 <main+0x2e>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    577e:	4785                	li	a5,1
    5780:	06a7c063          	blt	a5,a0,57e0 <main+0x76>
  char *justone = 0;
    5784:	4901                	li	s2,0
  int quick = 0;
    5786:	4501                	li	a0,0
  int continuous = 0;
    5788:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    578a:	864a                	mv	a2,s2
    578c:	f11ff0ef          	jal	569c <drivetests>
    5790:	c935                	beqz	a0,5804 <main+0x9a>
    exit(1);
    5792:	4505                	li	a0,1
    5794:	2ec000ef          	jal	5a80 <exit>
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    5798:	0085b903          	ld	s2,8(a1)
    579c:	00004597          	auipc	a1,0x4
    57a0:	85c58593          	addi	a1,a1,-1956 # 8ff8 <malloc+0x3064>
    57a4:	854a                	mv	a0,s2
    57a6:	09e000ef          	jal	5844 <strcmp>
    57aa:	85aa                	mv	a1,a0
    57ac:	c139                	beqz	a0,57f2 <main+0x88>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    57ae:	00004597          	auipc	a1,0x4
    57b2:	85258593          	addi	a1,a1,-1966 # 9000 <malloc+0x306c>
    57b6:	854a                	mv	a0,s2
    57b8:	08c000ef          	jal	5844 <strcmp>
    57bc:	cd15                	beqz	a0,57f8 <main+0x8e>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    57be:	00004597          	auipc	a1,0x4
    57c2:	84a58593          	addi	a1,a1,-1974 # 9008 <malloc+0x3074>
    57c6:	854a                	mv	a0,s2
    57c8:	07c000ef          	jal	5844 <strcmp>
    57cc:	c90d                	beqz	a0,57fe <main+0x94>
  } else if(argc == 2 && argv[1][0] != '-'){
    57ce:	00094703          	lbu	a4,0(s2)
    57d2:	02d00793          	li	a5,45
    57d6:	00f70563          	beq	a4,a5,57e0 <main+0x76>
  int quick = 0;
    57da:	4501                	li	a0,0
  int continuous = 0;
    57dc:	4581                	li	a1,0
    57de:	b775                	j	578a <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    57e0:	00004517          	auipc	a0,0x4
    57e4:	83050513          	addi	a0,a0,-2000 # 9010 <malloc+0x307c>
    57e8:	6f8000ef          	jal	5ee0 <printf>
    exit(1);
    57ec:	4505                	li	a0,1
    57ee:	292000ef          	jal	5a80 <exit>
  char *justone = 0;
    57f2:	4901                	li	s2,0
    quick = 1;
    57f4:	4505                	li	a0,1
    57f6:	bf51                	j	578a <main+0x20>
  char *justone = 0;
    57f8:	4901                	li	s2,0
    continuous = 1;
    57fa:	4585                	li	a1,1
    57fc:	b779                	j	578a <main+0x20>
    continuous = 2;
    57fe:	85a6                	mv	a1,s1
  char *justone = 0;
    5800:	4901                	li	s2,0
    5802:	b761                	j	578a <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    5804:	00004517          	auipc	a0,0x4
    5808:	83c50513          	addi	a0,a0,-1988 # 9040 <malloc+0x30ac>
    580c:	6d4000ef          	jal	5ee0 <printf>
  exit(0);
    5810:	4501                	li	a0,0
    5812:	26e000ef          	jal	5a80 <exit>

0000000000005816 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    5816:	1141                	addi	sp,sp,-16
    5818:	e406                	sd	ra,8(sp)
    581a:	e022                	sd	s0,0(sp)
    581c:	0800                	addi	s0,sp,16
  extern int main();
  main();
    581e:	f4dff0ef          	jal	576a <main>
  exit(0);
    5822:	4501                	li	a0,0
    5824:	25c000ef          	jal	5a80 <exit>

0000000000005828 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5828:	1141                	addi	sp,sp,-16
    582a:	e422                	sd	s0,8(sp)
    582c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    582e:	87aa                	mv	a5,a0
    5830:	0585                	addi	a1,a1,1
    5832:	0785                	addi	a5,a5,1
    5834:	fff5c703          	lbu	a4,-1(a1)
    5838:	fee78fa3          	sb	a4,-1(a5)
    583c:	fb75                	bnez	a4,5830 <strcpy+0x8>
    ;
  return os;
}
    583e:	6422                	ld	s0,8(sp)
    5840:	0141                	addi	sp,sp,16
    5842:	8082                	ret

0000000000005844 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    5844:	1141                	addi	sp,sp,-16
    5846:	e422                	sd	s0,8(sp)
    5848:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    584a:	00054783          	lbu	a5,0(a0)
    584e:	cb91                	beqz	a5,5862 <strcmp+0x1e>
    5850:	0005c703          	lbu	a4,0(a1)
    5854:	00f71763          	bne	a4,a5,5862 <strcmp+0x1e>
    p++, q++;
    5858:	0505                	addi	a0,a0,1
    585a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    585c:	00054783          	lbu	a5,0(a0)
    5860:	fbe5                	bnez	a5,5850 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    5862:	0005c503          	lbu	a0,0(a1)
}
    5866:	40a7853b          	subw	a0,a5,a0
    586a:	6422                	ld	s0,8(sp)
    586c:	0141                	addi	sp,sp,16
    586e:	8082                	ret

0000000000005870 <strlen>:

uint
strlen(const char *s)
{
    5870:	1141                	addi	sp,sp,-16
    5872:	e422                	sd	s0,8(sp)
    5874:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    5876:	00054783          	lbu	a5,0(a0)
    587a:	cf91                	beqz	a5,5896 <strlen+0x26>
    587c:	0505                	addi	a0,a0,1
    587e:	87aa                	mv	a5,a0
    5880:	86be                	mv	a3,a5
    5882:	0785                	addi	a5,a5,1
    5884:	fff7c703          	lbu	a4,-1(a5)
    5888:	ff65                	bnez	a4,5880 <strlen+0x10>
    588a:	40a6853b          	subw	a0,a3,a0
    588e:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    5890:	6422                	ld	s0,8(sp)
    5892:	0141                	addi	sp,sp,16
    5894:	8082                	ret
  for(n = 0; s[n]; n++)
    5896:	4501                	li	a0,0
    5898:	bfe5                	j	5890 <strlen+0x20>

000000000000589a <memset>:

void*
memset(void *dst, int c, uint n)
{
    589a:	1141                	addi	sp,sp,-16
    589c:	e422                	sd	s0,8(sp)
    589e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    58a0:	ca19                	beqz	a2,58b6 <memset+0x1c>
    58a2:	87aa                	mv	a5,a0
    58a4:	1602                	slli	a2,a2,0x20
    58a6:	9201                	srli	a2,a2,0x20
    58a8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    58ac:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    58b0:	0785                	addi	a5,a5,1
    58b2:	fee79de3          	bne	a5,a4,58ac <memset+0x12>
  }
  return dst;
}
    58b6:	6422                	ld	s0,8(sp)
    58b8:	0141                	addi	sp,sp,16
    58ba:	8082                	ret

00000000000058bc <strchr>:

char*
strchr(const char *s, char c)
{
    58bc:	1141                	addi	sp,sp,-16
    58be:	e422                	sd	s0,8(sp)
    58c0:	0800                	addi	s0,sp,16
  for(; *s; s++)
    58c2:	00054783          	lbu	a5,0(a0)
    58c6:	cb99                	beqz	a5,58dc <strchr+0x20>
    if(*s == c)
    58c8:	00f58763          	beq	a1,a5,58d6 <strchr+0x1a>
  for(; *s; s++)
    58cc:	0505                	addi	a0,a0,1
    58ce:	00054783          	lbu	a5,0(a0)
    58d2:	fbfd                	bnez	a5,58c8 <strchr+0xc>
      return (char*)s;
  return 0;
    58d4:	4501                	li	a0,0
}
    58d6:	6422                	ld	s0,8(sp)
    58d8:	0141                	addi	sp,sp,16
    58da:	8082                	ret
  return 0;
    58dc:	4501                	li	a0,0
    58de:	bfe5                	j	58d6 <strchr+0x1a>

00000000000058e0 <gets>:

char*
gets(char *buf, int max)
{
    58e0:	711d                	addi	sp,sp,-96
    58e2:	ec86                	sd	ra,88(sp)
    58e4:	e8a2                	sd	s0,80(sp)
    58e6:	e4a6                	sd	s1,72(sp)
    58e8:	e0ca                	sd	s2,64(sp)
    58ea:	fc4e                	sd	s3,56(sp)
    58ec:	f852                	sd	s4,48(sp)
    58ee:	f456                	sd	s5,40(sp)
    58f0:	f05a                	sd	s6,32(sp)
    58f2:	ec5e                	sd	s7,24(sp)
    58f4:	1080                	addi	s0,sp,96
    58f6:	8baa                	mv	s7,a0
    58f8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    58fa:	892a                	mv	s2,a0
    58fc:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    58fe:	4aa9                	li	s5,10
    5900:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5902:	89a6                	mv	s3,s1
    5904:	2485                	addiw	s1,s1,1
    5906:	0344d663          	bge	s1,s4,5932 <gets+0x52>
    cc = read(0, &c, 1);
    590a:	4605                	li	a2,1
    590c:	faf40593          	addi	a1,s0,-81
    5910:	4501                	li	a0,0
    5912:	186000ef          	jal	5a98 <read>
    if(cc < 1)
    5916:	00a05e63          	blez	a0,5932 <gets+0x52>
    buf[i++] = c;
    591a:	faf44783          	lbu	a5,-81(s0)
    591e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5922:	01578763          	beq	a5,s5,5930 <gets+0x50>
    5926:	0905                	addi	s2,s2,1
    5928:	fd679de3          	bne	a5,s6,5902 <gets+0x22>
    buf[i++] = c;
    592c:	89a6                	mv	s3,s1
    592e:	a011                	j	5932 <gets+0x52>
    5930:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5932:	99de                	add	s3,s3,s7
    5934:	00098023          	sb	zero,0(s3)
  return buf;
}
    5938:	855e                	mv	a0,s7
    593a:	60e6                	ld	ra,88(sp)
    593c:	6446                	ld	s0,80(sp)
    593e:	64a6                	ld	s1,72(sp)
    5940:	6906                	ld	s2,64(sp)
    5942:	79e2                	ld	s3,56(sp)
    5944:	7a42                	ld	s4,48(sp)
    5946:	7aa2                	ld	s5,40(sp)
    5948:	7b02                	ld	s6,32(sp)
    594a:	6be2                	ld	s7,24(sp)
    594c:	6125                	addi	sp,sp,96
    594e:	8082                	ret

0000000000005950 <stat>:

int
stat(const char *n, struct stat *st)
{
    5950:	1101                	addi	sp,sp,-32
    5952:	ec06                	sd	ra,24(sp)
    5954:	e822                	sd	s0,16(sp)
    5956:	e04a                	sd	s2,0(sp)
    5958:	1000                	addi	s0,sp,32
    595a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    595c:	4581                	li	a1,0
    595e:	162000ef          	jal	5ac0 <open>
  if(fd < 0)
    5962:	02054263          	bltz	a0,5986 <stat+0x36>
    5966:	e426                	sd	s1,8(sp)
    5968:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    596a:	85ca                	mv	a1,s2
    596c:	16c000ef          	jal	5ad8 <fstat>
    5970:	892a                	mv	s2,a0
  close(fd);
    5972:	8526                	mv	a0,s1
    5974:	134000ef          	jal	5aa8 <close>
  return r;
    5978:	64a2                	ld	s1,8(sp)
}
    597a:	854a                	mv	a0,s2
    597c:	60e2                	ld	ra,24(sp)
    597e:	6442                	ld	s0,16(sp)
    5980:	6902                	ld	s2,0(sp)
    5982:	6105                	addi	sp,sp,32
    5984:	8082                	ret
    return -1;
    5986:	597d                	li	s2,-1
    5988:	bfcd                	j	597a <stat+0x2a>

000000000000598a <atoi>:

int
atoi(const char *s)
{
    598a:	1141                	addi	sp,sp,-16
    598c:	e422                	sd	s0,8(sp)
    598e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    5990:	00054683          	lbu	a3,0(a0)
    5994:	fd06879b          	addiw	a5,a3,-48
    5998:	0ff7f793          	zext.b	a5,a5
    599c:	4625                	li	a2,9
    599e:	02f66863          	bltu	a2,a5,59ce <atoi+0x44>
    59a2:	872a                	mv	a4,a0
  n = 0;
    59a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    59a6:	0705                	addi	a4,a4,1
    59a8:	0025179b          	slliw	a5,a0,0x2
    59ac:	9fa9                	addw	a5,a5,a0
    59ae:	0017979b          	slliw	a5,a5,0x1
    59b2:	9fb5                	addw	a5,a5,a3
    59b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    59b8:	00074683          	lbu	a3,0(a4)
    59bc:	fd06879b          	addiw	a5,a3,-48
    59c0:	0ff7f793          	zext.b	a5,a5
    59c4:	fef671e3          	bgeu	a2,a5,59a6 <atoi+0x1c>
  return n;
}
    59c8:	6422                	ld	s0,8(sp)
    59ca:	0141                	addi	sp,sp,16
    59cc:	8082                	ret
  n = 0;
    59ce:	4501                	li	a0,0
    59d0:	bfe5                	j	59c8 <atoi+0x3e>

00000000000059d2 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    59d2:	1141                	addi	sp,sp,-16
    59d4:	e422                	sd	s0,8(sp)
    59d6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    59d8:	02b57463          	bgeu	a0,a1,5a00 <memmove+0x2e>
    while(n-- > 0)
    59dc:	00c05f63          	blez	a2,59fa <memmove+0x28>
    59e0:	1602                	slli	a2,a2,0x20
    59e2:	9201                	srli	a2,a2,0x20
    59e4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    59e8:	872a                	mv	a4,a0
      *dst++ = *src++;
    59ea:	0585                	addi	a1,a1,1
    59ec:	0705                	addi	a4,a4,1
    59ee:	fff5c683          	lbu	a3,-1(a1)
    59f2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    59f6:	fef71ae3          	bne	a4,a5,59ea <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    59fa:	6422                	ld	s0,8(sp)
    59fc:	0141                	addi	sp,sp,16
    59fe:	8082                	ret
    dst += n;
    5a00:	00c50733          	add	a4,a0,a2
    src += n;
    5a04:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5a06:	fec05ae3          	blez	a2,59fa <memmove+0x28>
    5a0a:	fff6079b          	addiw	a5,a2,-1 # 2fff <rwsbrk+0x31>
    5a0e:	1782                	slli	a5,a5,0x20
    5a10:	9381                	srli	a5,a5,0x20
    5a12:	fff7c793          	not	a5,a5
    5a16:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5a18:	15fd                	addi	a1,a1,-1
    5a1a:	177d                	addi	a4,a4,-1
    5a1c:	0005c683          	lbu	a3,0(a1)
    5a20:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5a24:	fee79ae3          	bne	a5,a4,5a18 <memmove+0x46>
    5a28:	bfc9                	j	59fa <memmove+0x28>

0000000000005a2a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5a2a:	1141                	addi	sp,sp,-16
    5a2c:	e422                	sd	s0,8(sp)
    5a2e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5a30:	ca05                	beqz	a2,5a60 <memcmp+0x36>
    5a32:	fff6069b          	addiw	a3,a2,-1
    5a36:	1682                	slli	a3,a3,0x20
    5a38:	9281                	srli	a3,a3,0x20
    5a3a:	0685                	addi	a3,a3,1
    5a3c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5a3e:	00054783          	lbu	a5,0(a0)
    5a42:	0005c703          	lbu	a4,0(a1)
    5a46:	00e79863          	bne	a5,a4,5a56 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5a4a:	0505                	addi	a0,a0,1
    p2++;
    5a4c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    5a4e:	fed518e3          	bne	a0,a3,5a3e <memcmp+0x14>
  }
  return 0;
    5a52:	4501                	li	a0,0
    5a54:	a019                	j	5a5a <memcmp+0x30>
      return *p1 - *p2;
    5a56:	40e7853b          	subw	a0,a5,a4
}
    5a5a:	6422                	ld	s0,8(sp)
    5a5c:	0141                	addi	sp,sp,16
    5a5e:	8082                	ret
  return 0;
    5a60:	4501                	li	a0,0
    5a62:	bfe5                	j	5a5a <memcmp+0x30>

0000000000005a64 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5a64:	1141                	addi	sp,sp,-16
    5a66:	e406                	sd	ra,8(sp)
    5a68:	e022                	sd	s0,0(sp)
    5a6a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    5a6c:	f67ff0ef          	jal	59d2 <memmove>
}
    5a70:	60a2                	ld	ra,8(sp)
    5a72:	6402                	ld	s0,0(sp)
    5a74:	0141                	addi	sp,sp,16
    5a76:	8082                	ret

0000000000005a78 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5a78:	4885                	li	a7,1
 ecall
    5a7a:	00000073          	ecall
 ret
    5a7e:	8082                	ret

0000000000005a80 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5a80:	4889                	li	a7,2
 ecall
    5a82:	00000073          	ecall
 ret
    5a86:	8082                	ret

0000000000005a88 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5a88:	488d                	li	a7,3
 ecall
    5a8a:	00000073          	ecall
 ret
    5a8e:	8082                	ret

0000000000005a90 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5a90:	4891                	li	a7,4
 ecall
    5a92:	00000073          	ecall
 ret
    5a96:	8082                	ret

0000000000005a98 <read>:
.global read
read:
 li a7, SYS_read
    5a98:	4895                	li	a7,5
 ecall
    5a9a:	00000073          	ecall
 ret
    5a9e:	8082                	ret

0000000000005aa0 <write>:
.global write
write:
 li a7, SYS_write
    5aa0:	48c1                	li	a7,16
 ecall
    5aa2:	00000073          	ecall
 ret
    5aa6:	8082                	ret

0000000000005aa8 <close>:
.global close
close:
 li a7, SYS_close
    5aa8:	48d5                	li	a7,21
 ecall
    5aaa:	00000073          	ecall
 ret
    5aae:	8082                	ret

0000000000005ab0 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5ab0:	4899                	li	a7,6
 ecall
    5ab2:	00000073          	ecall
 ret
    5ab6:	8082                	ret

0000000000005ab8 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5ab8:	489d                	li	a7,7
 ecall
    5aba:	00000073          	ecall
 ret
    5abe:	8082                	ret

0000000000005ac0 <open>:
.global open
open:
 li a7, SYS_open
    5ac0:	48bd                	li	a7,15
 ecall
    5ac2:	00000073          	ecall
 ret
    5ac6:	8082                	ret

0000000000005ac8 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5ac8:	48c5                	li	a7,17
 ecall
    5aca:	00000073          	ecall
 ret
    5ace:	8082                	ret

0000000000005ad0 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5ad0:	48c9                	li	a7,18
 ecall
    5ad2:	00000073          	ecall
 ret
    5ad6:	8082                	ret

0000000000005ad8 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5ad8:	48a1                	li	a7,8
 ecall
    5ada:	00000073          	ecall
 ret
    5ade:	8082                	ret

0000000000005ae0 <link>:
.global link
link:
 li a7, SYS_link
    5ae0:	48cd                	li	a7,19
 ecall
    5ae2:	00000073          	ecall
 ret
    5ae6:	8082                	ret

0000000000005ae8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5ae8:	48d1                	li	a7,20
 ecall
    5aea:	00000073          	ecall
 ret
    5aee:	8082                	ret

0000000000005af0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5af0:	48a5                	li	a7,9
 ecall
    5af2:	00000073          	ecall
 ret
    5af6:	8082                	ret

0000000000005af8 <dup>:
.global dup
dup:
 li a7, SYS_dup
    5af8:	48a9                	li	a7,10
 ecall
    5afa:	00000073          	ecall
 ret
    5afe:	8082                	ret

0000000000005b00 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5b00:	48ad                	li	a7,11
 ecall
    5b02:	00000073          	ecall
 ret
    5b06:	8082                	ret

0000000000005b08 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5b08:	48b1                	li	a7,12
 ecall
    5b0a:	00000073          	ecall
 ret
    5b0e:	8082                	ret

0000000000005b10 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5b10:	48b5                	li	a7,13
 ecall
    5b12:	00000073          	ecall
 ret
    5b16:	8082                	ret

0000000000005b18 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5b18:	48b9                	li	a7,14
 ecall
    5b1a:	00000073          	ecall
 ret
    5b1e:	8082                	ret

0000000000005b20 <cps>:
.global cps
cps:
 li a7, SYS_cps
    5b20:	48d9                	li	a7,22
 ecall
    5b22:	00000073          	ecall
 ret
    5b26:	8082                	ret

0000000000005b28 <signal>:
.global signal
signal:
 li a7, SYS_signal
    5b28:	48dd                	li	a7,23
 ecall
    5b2a:	00000073          	ecall
 ret
    5b2e:	8082                	ret

0000000000005b30 <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    5b30:	48e1                	li	a7,24
 ecall
    5b32:	00000073          	ecall
 ret
    5b36:	8082                	ret

0000000000005b38 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    5b38:	48e5                	li	a7,25
 ecall
    5b3a:	00000073          	ecall
 ret
    5b3e:	8082                	ret

0000000000005b40 <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    5b40:	48e9                	li	a7,26
 ecall
    5b42:	00000073          	ecall
 ret
    5b46:	8082                	ret

0000000000005b48 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    5b48:	48ed                	li	a7,27
 ecall
    5b4a:	00000073          	ecall
 ret
    5b4e:	8082                	ret

0000000000005b50 <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    5b50:	48f1                	li	a7,28
 ecall
    5b52:	00000073          	ecall
 ret
    5b56:	8082                	ret

0000000000005b58 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    5b58:	48f5                	li	a7,29
 ecall
    5b5a:	00000073          	ecall
 ret
    5b5e:	8082                	ret

0000000000005b60 <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    5b60:	48f9                	li	a7,30
 ecall
    5b62:	00000073          	ecall
 ret
    5b66:	8082                	ret

0000000000005b68 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5b68:	1101                	addi	sp,sp,-32
    5b6a:	ec06                	sd	ra,24(sp)
    5b6c:	e822                	sd	s0,16(sp)
    5b6e:	1000                	addi	s0,sp,32
    5b70:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5b74:	4605                	li	a2,1
    5b76:	fef40593          	addi	a1,s0,-17
    5b7a:	f27ff0ef          	jal	5aa0 <write>
}
    5b7e:	60e2                	ld	ra,24(sp)
    5b80:	6442                	ld	s0,16(sp)
    5b82:	6105                	addi	sp,sp,32
    5b84:	8082                	ret

0000000000005b86 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5b86:	7139                	addi	sp,sp,-64
    5b88:	fc06                	sd	ra,56(sp)
    5b8a:	f822                	sd	s0,48(sp)
    5b8c:	f426                	sd	s1,40(sp)
    5b8e:	0080                	addi	s0,sp,64
    5b90:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5b92:	c299                	beqz	a3,5b98 <printint+0x12>
    5b94:	0805c963          	bltz	a1,5c26 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5b98:	2581                	sext.w	a1,a1
  neg = 0;
    5b9a:	4881                	li	a7,0
    5b9c:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    5ba0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5ba2:	2601                	sext.w	a2,a2
    5ba4:	00004517          	auipc	a0,0x4
    5ba8:	86c50513          	addi	a0,a0,-1940 # 9410 <digits>
    5bac:	883a                	mv	a6,a4
    5bae:	2705                	addiw	a4,a4,1
    5bb0:	02c5f7bb          	remuw	a5,a1,a2
    5bb4:	1782                	slli	a5,a5,0x20
    5bb6:	9381                	srli	a5,a5,0x20
    5bb8:	97aa                	add	a5,a5,a0
    5bba:	0007c783          	lbu	a5,0(a5)
    5bbe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5bc2:	0005879b          	sext.w	a5,a1
    5bc6:	02c5d5bb          	divuw	a1,a1,a2
    5bca:	0685                	addi	a3,a3,1
    5bcc:	fec7f0e3          	bgeu	a5,a2,5bac <printint+0x26>
  if(neg)
    5bd0:	00088c63          	beqz	a7,5be8 <printint+0x62>
    buf[i++] = '-';
    5bd4:	fd070793          	addi	a5,a4,-48
    5bd8:	00878733          	add	a4,a5,s0
    5bdc:	02d00793          	li	a5,45
    5be0:	fef70823          	sb	a5,-16(a4)
    5be4:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    5be8:	02e05a63          	blez	a4,5c1c <printint+0x96>
    5bec:	f04a                	sd	s2,32(sp)
    5bee:	ec4e                	sd	s3,24(sp)
    5bf0:	fc040793          	addi	a5,s0,-64
    5bf4:	00e78933          	add	s2,a5,a4
    5bf8:	fff78993          	addi	s3,a5,-1
    5bfc:	99ba                	add	s3,s3,a4
    5bfe:	377d                	addiw	a4,a4,-1
    5c00:	1702                	slli	a4,a4,0x20
    5c02:	9301                	srli	a4,a4,0x20
    5c04:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5c08:	fff94583          	lbu	a1,-1(s2)
    5c0c:	8526                	mv	a0,s1
    5c0e:	f5bff0ef          	jal	5b68 <putc>
  while(--i >= 0)
    5c12:	197d                	addi	s2,s2,-1
    5c14:	ff391ae3          	bne	s2,s3,5c08 <printint+0x82>
    5c18:	7902                	ld	s2,32(sp)
    5c1a:	69e2                	ld	s3,24(sp)
}
    5c1c:	70e2                	ld	ra,56(sp)
    5c1e:	7442                	ld	s0,48(sp)
    5c20:	74a2                	ld	s1,40(sp)
    5c22:	6121                	addi	sp,sp,64
    5c24:	8082                	ret
    x = -xx;
    5c26:	40b005bb          	negw	a1,a1
    neg = 1;
    5c2a:	4885                	li	a7,1
    x = -xx;
    5c2c:	bf85                	j	5b9c <printint+0x16>

0000000000005c2e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5c2e:	711d                	addi	sp,sp,-96
    5c30:	ec86                	sd	ra,88(sp)
    5c32:	e8a2                	sd	s0,80(sp)
    5c34:	e0ca                	sd	s2,64(sp)
    5c36:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5c38:	0005c903          	lbu	s2,0(a1)
    5c3c:	26090863          	beqz	s2,5eac <vprintf+0x27e>
    5c40:	e4a6                	sd	s1,72(sp)
    5c42:	fc4e                	sd	s3,56(sp)
    5c44:	f852                	sd	s4,48(sp)
    5c46:	f456                	sd	s5,40(sp)
    5c48:	f05a                	sd	s6,32(sp)
    5c4a:	ec5e                	sd	s7,24(sp)
    5c4c:	e862                	sd	s8,16(sp)
    5c4e:	e466                	sd	s9,8(sp)
    5c50:	8b2a                	mv	s6,a0
    5c52:	8a2e                	mv	s4,a1
    5c54:	8bb2                	mv	s7,a2
  state = 0;
    5c56:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    5c58:	4481                	li	s1,0
    5c5a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    5c5c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    5c60:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    5c64:	06c00c93          	li	s9,108
    5c68:	a005                	j	5c88 <vprintf+0x5a>
        putc(fd, c0);
    5c6a:	85ca                	mv	a1,s2
    5c6c:	855a                	mv	a0,s6
    5c6e:	efbff0ef          	jal	5b68 <putc>
    5c72:	a019                	j	5c78 <vprintf+0x4a>
    } else if(state == '%'){
    5c74:	03598263          	beq	s3,s5,5c98 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    5c78:	2485                	addiw	s1,s1,1
    5c7a:	8726                	mv	a4,s1
    5c7c:	009a07b3          	add	a5,s4,s1
    5c80:	0007c903          	lbu	s2,0(a5)
    5c84:	20090c63          	beqz	s2,5e9c <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    5c88:	0009079b          	sext.w	a5,s2
    if(state == 0){
    5c8c:	fe0994e3          	bnez	s3,5c74 <vprintf+0x46>
      if(c0 == '%'){
    5c90:	fd579de3          	bne	a5,s5,5c6a <vprintf+0x3c>
        state = '%';
    5c94:	89be                	mv	s3,a5
    5c96:	b7cd                	j	5c78 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    5c98:	00ea06b3          	add	a3,s4,a4
    5c9c:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    5ca0:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    5ca2:	c681                	beqz	a3,5caa <vprintf+0x7c>
    5ca4:	9752                	add	a4,a4,s4
    5ca6:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    5caa:	03878f63          	beq	a5,s8,5ce8 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    5cae:	05978963          	beq	a5,s9,5d00 <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    5cb2:	07500713          	li	a4,117
    5cb6:	0ee78363          	beq	a5,a4,5d9c <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    5cba:	07800713          	li	a4,120
    5cbe:	12e78563          	beq	a5,a4,5de8 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    5cc2:	07000713          	li	a4,112
    5cc6:	14e78a63          	beq	a5,a4,5e1a <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    5cca:	07300713          	li	a4,115
    5cce:	18e78a63          	beq	a5,a4,5e62 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    5cd2:	02500713          	li	a4,37
    5cd6:	04e79563          	bne	a5,a4,5d20 <vprintf+0xf2>
        putc(fd, '%');
    5cda:	02500593          	li	a1,37
    5cde:	855a                	mv	a0,s6
    5ce0:	e89ff0ef          	jal	5b68 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    5ce4:	4981                	li	s3,0
    5ce6:	bf49                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    5ce8:	008b8913          	addi	s2,s7,8
    5cec:	4685                	li	a3,1
    5cee:	4629                	li	a2,10
    5cf0:	000ba583          	lw	a1,0(s7)
    5cf4:	855a                	mv	a0,s6
    5cf6:	e91ff0ef          	jal	5b86 <printint>
    5cfa:	8bca                	mv	s7,s2
      state = 0;
    5cfc:	4981                	li	s3,0
    5cfe:	bfad                	j	5c78 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    5d00:	06400793          	li	a5,100
    5d04:	02f68963          	beq	a3,a5,5d36 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5d08:	06c00793          	li	a5,108
    5d0c:	04f68263          	beq	a3,a5,5d50 <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    5d10:	07500793          	li	a5,117
    5d14:	0af68063          	beq	a3,a5,5db4 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    5d18:	07800793          	li	a5,120
    5d1c:	0ef68263          	beq	a3,a5,5e00 <vprintf+0x1d2>
        putc(fd, '%');
    5d20:	02500593          	li	a1,37
    5d24:	855a                	mv	a0,s6
    5d26:	e43ff0ef          	jal	5b68 <putc>
        putc(fd, c0);
    5d2a:	85ca                	mv	a1,s2
    5d2c:	855a                	mv	a0,s6
    5d2e:	e3bff0ef          	jal	5b68 <putc>
      state = 0;
    5d32:	4981                	li	s3,0
    5d34:	b791                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5d36:	008b8913          	addi	s2,s7,8
    5d3a:	4685                	li	a3,1
    5d3c:	4629                	li	a2,10
    5d3e:	000ba583          	lw	a1,0(s7)
    5d42:	855a                	mv	a0,s6
    5d44:	e43ff0ef          	jal	5b86 <printint>
        i += 1;
    5d48:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    5d4a:	8bca                	mv	s7,s2
      state = 0;
    5d4c:	4981                	li	s3,0
        i += 1;
    5d4e:	b72d                	j	5c78 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    5d50:	06400793          	li	a5,100
    5d54:	02f60763          	beq	a2,a5,5d82 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    5d58:	07500793          	li	a5,117
    5d5c:	06f60963          	beq	a2,a5,5dce <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    5d60:	07800793          	li	a5,120
    5d64:	faf61ee3          	bne	a2,a5,5d20 <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5d68:	008b8913          	addi	s2,s7,8
    5d6c:	4681                	li	a3,0
    5d6e:	4641                	li	a2,16
    5d70:	000ba583          	lw	a1,0(s7)
    5d74:	855a                	mv	a0,s6
    5d76:	e11ff0ef          	jal	5b86 <printint>
        i += 2;
    5d7a:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5d7c:	8bca                	mv	s7,s2
      state = 0;
    5d7e:	4981                	li	s3,0
        i += 2;
    5d80:	bde5                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5d82:	008b8913          	addi	s2,s7,8
    5d86:	4685                	li	a3,1
    5d88:	4629                	li	a2,10
    5d8a:	000ba583          	lw	a1,0(s7)
    5d8e:	855a                	mv	a0,s6
    5d90:	df7ff0ef          	jal	5b86 <printint>
        i += 2;
    5d94:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5d96:	8bca                	mv	s7,s2
      state = 0;
    5d98:	4981                	li	s3,0
        i += 2;
    5d9a:	bdf9                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    5d9c:	008b8913          	addi	s2,s7,8
    5da0:	4681                	li	a3,0
    5da2:	4629                	li	a2,10
    5da4:	000ba583          	lw	a1,0(s7)
    5da8:	855a                	mv	a0,s6
    5daa:	dddff0ef          	jal	5b86 <printint>
    5dae:	8bca                	mv	s7,s2
      state = 0;
    5db0:	4981                	li	s3,0
    5db2:	b5d9                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5db4:	008b8913          	addi	s2,s7,8
    5db8:	4681                	li	a3,0
    5dba:	4629                	li	a2,10
    5dbc:	000ba583          	lw	a1,0(s7)
    5dc0:	855a                	mv	a0,s6
    5dc2:	dc5ff0ef          	jal	5b86 <printint>
        i += 1;
    5dc6:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dc8:	8bca                	mv	s7,s2
      state = 0;
    5dca:	4981                	li	s3,0
        i += 1;
    5dcc:	b575                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5dce:	008b8913          	addi	s2,s7,8
    5dd2:	4681                	li	a3,0
    5dd4:	4629                	li	a2,10
    5dd6:	000ba583          	lw	a1,0(s7)
    5dda:	855a                	mv	a0,s6
    5ddc:	dabff0ef          	jal	5b86 <printint>
        i += 2;
    5de0:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5de2:	8bca                	mv	s7,s2
      state = 0;
    5de4:	4981                	li	s3,0
        i += 2;
    5de6:	bd49                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    5de8:	008b8913          	addi	s2,s7,8
    5dec:	4681                	li	a3,0
    5dee:	4641                	li	a2,16
    5df0:	000ba583          	lw	a1,0(s7)
    5df4:	855a                	mv	a0,s6
    5df6:	d91ff0ef          	jal	5b86 <printint>
    5dfa:	8bca                	mv	s7,s2
      state = 0;
    5dfc:	4981                	li	s3,0
    5dfe:	bdad                	j	5c78 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5e00:	008b8913          	addi	s2,s7,8
    5e04:	4681                	li	a3,0
    5e06:	4641                	li	a2,16
    5e08:	000ba583          	lw	a1,0(s7)
    5e0c:	855a                	mv	a0,s6
    5e0e:	d79ff0ef          	jal	5b86 <printint>
        i += 1;
    5e12:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    5e14:	8bca                	mv	s7,s2
      state = 0;
    5e16:	4981                	li	s3,0
        i += 1;
    5e18:	b585                	j	5c78 <vprintf+0x4a>
    5e1a:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5e1c:	008b8d13          	addi	s10,s7,8
    5e20:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5e24:	03000593          	li	a1,48
    5e28:	855a                	mv	a0,s6
    5e2a:	d3fff0ef          	jal	5b68 <putc>
  putc(fd, 'x');
    5e2e:	07800593          	li	a1,120
    5e32:	855a                	mv	a0,s6
    5e34:	d35ff0ef          	jal	5b68 <putc>
    5e38:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5e3a:	00003b97          	auipc	s7,0x3
    5e3e:	5d6b8b93          	addi	s7,s7,1494 # 9410 <digits>
    5e42:	03c9d793          	srli	a5,s3,0x3c
    5e46:	97de                	add	a5,a5,s7
    5e48:	0007c583          	lbu	a1,0(a5)
    5e4c:	855a                	mv	a0,s6
    5e4e:	d1bff0ef          	jal	5b68 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5e52:	0992                	slli	s3,s3,0x4
    5e54:	397d                	addiw	s2,s2,-1
    5e56:	fe0916e3          	bnez	s2,5e42 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    5e5a:	8bea                	mv	s7,s10
      state = 0;
    5e5c:	4981                	li	s3,0
    5e5e:	6d02                	ld	s10,0(sp)
    5e60:	bd21                	j	5c78 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    5e62:	008b8993          	addi	s3,s7,8
    5e66:	000bb903          	ld	s2,0(s7)
    5e6a:	00090f63          	beqz	s2,5e88 <vprintf+0x25a>
        for(; *s; s++)
    5e6e:	00094583          	lbu	a1,0(s2)
    5e72:	c195                	beqz	a1,5e96 <vprintf+0x268>
          putc(fd, *s);
    5e74:	855a                	mv	a0,s6
    5e76:	cf3ff0ef          	jal	5b68 <putc>
        for(; *s; s++)
    5e7a:	0905                	addi	s2,s2,1
    5e7c:	00094583          	lbu	a1,0(s2)
    5e80:	f9f5                	bnez	a1,5e74 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    5e82:	8bce                	mv	s7,s3
      state = 0;
    5e84:	4981                	li	s3,0
    5e86:	bbcd                	j	5c78 <vprintf+0x4a>
          s = "(null)";
    5e88:	00003917          	auipc	s2,0x3
    5e8c:	50890913          	addi	s2,s2,1288 # 9390 <malloc+0x33fc>
        for(; *s; s++)
    5e90:	02800593          	li	a1,40
    5e94:	b7c5                	j	5e74 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    5e96:	8bce                	mv	s7,s3
      state = 0;
    5e98:	4981                	li	s3,0
    5e9a:	bbf9                	j	5c78 <vprintf+0x4a>
    5e9c:	64a6                	ld	s1,72(sp)
    5e9e:	79e2                	ld	s3,56(sp)
    5ea0:	7a42                	ld	s4,48(sp)
    5ea2:	7aa2                	ld	s5,40(sp)
    5ea4:	7b02                	ld	s6,32(sp)
    5ea6:	6be2                	ld	s7,24(sp)
    5ea8:	6c42                	ld	s8,16(sp)
    5eaa:	6ca2                	ld	s9,8(sp)
    }
  }
}
    5eac:	60e6                	ld	ra,88(sp)
    5eae:	6446                	ld	s0,80(sp)
    5eb0:	6906                	ld	s2,64(sp)
    5eb2:	6125                	addi	sp,sp,96
    5eb4:	8082                	ret

0000000000005eb6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5eb6:	715d                	addi	sp,sp,-80
    5eb8:	ec06                	sd	ra,24(sp)
    5eba:	e822                	sd	s0,16(sp)
    5ebc:	1000                	addi	s0,sp,32
    5ebe:	e010                	sd	a2,0(s0)
    5ec0:	e414                	sd	a3,8(s0)
    5ec2:	e818                	sd	a4,16(s0)
    5ec4:	ec1c                	sd	a5,24(s0)
    5ec6:	03043023          	sd	a6,32(s0)
    5eca:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5ece:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5ed2:	8622                	mv	a2,s0
    5ed4:	d5bff0ef          	jal	5c2e <vprintf>
}
    5ed8:	60e2                	ld	ra,24(sp)
    5eda:	6442                	ld	s0,16(sp)
    5edc:	6161                	addi	sp,sp,80
    5ede:	8082                	ret

0000000000005ee0 <printf>:

void
printf(const char *fmt, ...)
{
    5ee0:	711d                	addi	sp,sp,-96
    5ee2:	ec06                	sd	ra,24(sp)
    5ee4:	e822                	sd	s0,16(sp)
    5ee6:	1000                	addi	s0,sp,32
    5ee8:	e40c                	sd	a1,8(s0)
    5eea:	e810                	sd	a2,16(s0)
    5eec:	ec14                	sd	a3,24(s0)
    5eee:	f018                	sd	a4,32(s0)
    5ef0:	f41c                	sd	a5,40(s0)
    5ef2:	03043823          	sd	a6,48(s0)
    5ef6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5efa:	00840613          	addi	a2,s0,8
    5efe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5f02:	85aa                	mv	a1,a0
    5f04:	4505                	li	a0,1
    5f06:	d29ff0ef          	jal	5c2e <vprintf>
}
    5f0a:	60e2                	ld	ra,24(sp)
    5f0c:	6442                	ld	s0,16(sp)
    5f0e:	6125                	addi	sp,sp,96
    5f10:	8082                	ret

0000000000005f12 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5f12:	1141                	addi	sp,sp,-16
    5f14:	e422                	sd	s0,8(sp)
    5f16:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5f18:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f1c:	00004797          	auipc	a5,0x4
    5f20:	9647b783          	ld	a5,-1692(a5) # 9880 <freep>
    5f24:	a02d                	j	5f4e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5f26:	4618                	lw	a4,8(a2)
    5f28:	9f2d                	addw	a4,a4,a1
    5f2a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5f2e:	6398                	ld	a4,0(a5)
    5f30:	6310                	ld	a2,0(a4)
    5f32:	a83d                	j	5f70 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5f34:	ff852703          	lw	a4,-8(a0)
    5f38:	9f31                	addw	a4,a4,a2
    5f3a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5f3c:	ff053683          	ld	a3,-16(a0)
    5f40:	a091                	j	5f84 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f42:	6398                	ld	a4,0(a5)
    5f44:	00e7e463          	bltu	a5,a4,5f4c <free+0x3a>
    5f48:	00e6ea63          	bltu	a3,a4,5f5c <free+0x4a>
{
    5f4c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5f4e:	fed7fae3          	bgeu	a5,a3,5f42 <free+0x30>
    5f52:	6398                	ld	a4,0(a5)
    5f54:	00e6e463          	bltu	a3,a4,5f5c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5f58:	fee7eae3          	bltu	a5,a4,5f4c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    5f5c:	ff852583          	lw	a1,-8(a0)
    5f60:	6390                	ld	a2,0(a5)
    5f62:	02059813          	slli	a6,a1,0x20
    5f66:	01c85713          	srli	a4,a6,0x1c
    5f6a:	9736                	add	a4,a4,a3
    5f6c:	fae60de3          	beq	a2,a4,5f26 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    5f70:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    5f74:	4790                	lw	a2,8(a5)
    5f76:	02061593          	slli	a1,a2,0x20
    5f7a:	01c5d713          	srli	a4,a1,0x1c
    5f7e:	973e                	add	a4,a4,a5
    5f80:	fae68ae3          	beq	a3,a4,5f34 <free+0x22>
    p->s.ptr = bp->s.ptr;
    5f84:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5f86:	00004717          	auipc	a4,0x4
    5f8a:	8ef73d23          	sd	a5,-1798(a4) # 9880 <freep>
}
    5f8e:	6422                	ld	s0,8(sp)
    5f90:	0141                	addi	sp,sp,16
    5f92:	8082                	ret

0000000000005f94 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5f94:	7139                	addi	sp,sp,-64
    5f96:	fc06                	sd	ra,56(sp)
    5f98:	f822                	sd	s0,48(sp)
    5f9a:	f426                	sd	s1,40(sp)
    5f9c:	ec4e                	sd	s3,24(sp)
    5f9e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    5fa0:	02051493          	slli	s1,a0,0x20
    5fa4:	9081                	srli	s1,s1,0x20
    5fa6:	04bd                	addi	s1,s1,15
    5fa8:	8091                	srli	s1,s1,0x4
    5faa:	0014899b          	addiw	s3,s1,1
    5fae:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    5fb0:	00004517          	auipc	a0,0x4
    5fb4:	8d053503          	ld	a0,-1840(a0) # 9880 <freep>
    5fb8:	c915                	beqz	a0,5fec <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    5fba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    5fbc:	4798                	lw	a4,8(a5)
    5fbe:	08977a63          	bgeu	a4,s1,6052 <malloc+0xbe>
    5fc2:	f04a                	sd	s2,32(sp)
    5fc4:	e852                	sd	s4,16(sp)
    5fc6:	e456                	sd	s5,8(sp)
    5fc8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    5fca:	8a4e                	mv	s4,s3
    5fcc:	0009871b          	sext.w	a4,s3
    5fd0:	6685                	lui	a3,0x1
    5fd2:	00d77363          	bgeu	a4,a3,5fd8 <malloc+0x44>
    5fd6:	6a05                	lui	s4,0x1
    5fd8:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5fdc:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    5fe0:	00004917          	auipc	s2,0x4
    5fe4:	8a090913          	addi	s2,s2,-1888 # 9880 <freep>
  if(p == (char*)-1)
    5fe8:	5afd                	li	s5,-1
    5fea:	a081                	j	602a <malloc+0x96>
    5fec:	f04a                	sd	s2,32(sp)
    5fee:	e852                	sd	s4,16(sp)
    5ff0:	e456                	sd	s5,8(sp)
    5ff2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5ff4:	0000a797          	auipc	a5,0xa
    5ff8:	0b478793          	addi	a5,a5,180 # 100a8 <base>
    5ffc:	00004717          	auipc	a4,0x4
    6000:	88f73223          	sd	a5,-1916(a4) # 9880 <freep>
    6004:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    6006:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    600a:	b7c1                	j	5fca <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    600c:	6398                	ld	a4,0(a5)
    600e:	e118                	sd	a4,0(a0)
    6010:	a8a9                	j	606a <malloc+0xd6>
  hp->s.size = nu;
    6012:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    6016:	0541                	addi	a0,a0,16
    6018:	efbff0ef          	jal	5f12 <free>
  return freep;
    601c:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    6020:	c12d                	beqz	a0,6082 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    6022:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    6024:	4798                	lw	a4,8(a5)
    6026:	02977263          	bgeu	a4,s1,604a <malloc+0xb6>
    if(p == freep)
    602a:	00093703          	ld	a4,0(s2)
    602e:	853e                	mv	a0,a5
    6030:	fef719e3          	bne	a4,a5,6022 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    6034:	8552                	mv	a0,s4
    6036:	ad3ff0ef          	jal	5b08 <sbrk>
  if(p == (char*)-1)
    603a:	fd551ce3          	bne	a0,s5,6012 <malloc+0x7e>
        return 0;
    603e:	4501                	li	a0,0
    6040:	7902                	ld	s2,32(sp)
    6042:	6a42                	ld	s4,16(sp)
    6044:	6aa2                	ld	s5,8(sp)
    6046:	6b02                	ld	s6,0(sp)
    6048:	a03d                	j	6076 <malloc+0xe2>
    604a:	7902                	ld	s2,32(sp)
    604c:	6a42                	ld	s4,16(sp)
    604e:	6aa2                	ld	s5,8(sp)
    6050:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    6052:	fae48de3          	beq	s1,a4,600c <malloc+0x78>
        p->s.size -= nunits;
    6056:	4137073b          	subw	a4,a4,s3
    605a:	c798                	sw	a4,8(a5)
        p += p->s.size;
    605c:	02071693          	slli	a3,a4,0x20
    6060:	01c6d713          	srli	a4,a3,0x1c
    6064:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    6066:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    606a:	00004717          	auipc	a4,0x4
    606e:	80a73b23          	sd	a0,-2026(a4) # 9880 <freep>
      return (void*)(p + 1);
    6072:	01078513          	addi	a0,a5,16
  }
}
    6076:	70e2                	ld	ra,56(sp)
    6078:	7442                	ld	s0,48(sp)
    607a:	74a2                	ld	s1,40(sp)
    607c:	69e2                	ld	s3,24(sp)
    607e:	6121                	addi	sp,sp,64
    6080:	8082                	ret
    6082:	7902                	ld	s2,32(sp)
    6084:	6a42                	ld	s4,16(sp)
    6086:	6aa2                	ld	s5,8(sp)
    6088:	6b02                	ld	s6,0(sp)
    608a:	b7f5                	j	6076 <malloc+0xe2>
	...
