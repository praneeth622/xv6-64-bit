
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
    1000:	1141                	addi	sp,sp,-16
    1002:	e422                	sd	s0,8(sp)
    1004:	0800                	addi	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
    1006:	611c                	ld	a5,0(a0)
    1008:	80000737          	lui	a4,0x80000
    100c:	ffe74713          	xori	a4,a4,-2
    1010:	02e7f7b3          	remu	a5,a5,a4
    1014:	0785                	addi	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
    1016:	66fd                	lui	a3,0x1f
    1018:	31d68693          	addi	a3,a3,797 # 1f31d <base+0x1bb85>
    101c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
    1020:	6611                	lui	a2,0x4
    1022:	1a760613          	addi	a2,a2,423 # 41a7 <base+0xa0f>
    1026:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
    102a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
    102e:	76fd                	lui	a3,0xfffff
    1030:	4ec68693          	addi	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffbd54>
    1034:	02d787b3          	mul	a5,a5,a3
    1038:	97ba                	add	a5,a5,a4
    if (x < 0)
    103a:	0007c963          	bltz	a5,104c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
    103e:	17fd                	addi	a5,a5,-1
    *ctx = x;
    1040:	e11c                	sd	a5,0(a0)
    return (x);
}
    1042:	0007851b          	sext.w	a0,a5
    1046:	6422                	ld	s0,8(sp)
    1048:	0141                	addi	sp,sp,16
    104a:	8082                	ret
        x += 0x7fffffff;
    104c:	80000737          	lui	a4,0x80000
    1050:	fff74713          	not	a4,a4
    1054:	97ba                	add	a5,a5,a4
    1056:	b7e5                	j	103e <do_rand+0x3e>

0000000000001058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
    1058:	1141                	addi	sp,sp,-16
    105a:	e406                	sd	ra,8(sp)
    105c:	e022                	sd	s0,0(sp)
    105e:	0800                	addi	s0,sp,16
    return (do_rand(&rand_next));
    1060:	00002517          	auipc	a0,0x2
    1064:	33050513          	addi	a0,a0,816 # 3390 <rand_next>
    1068:	f99ff0ef          	jal	1000 <do_rand>
}
    106c:	60a2                	ld	ra,8(sp)
    106e:	6402                	ld	s0,0(sp)
    1070:	0141                	addi	sp,sp,16
    1072:	8082                	ret

0000000000001074 <go>:

void
go(int which_child)
{
    1074:	7119                	addi	sp,sp,-128
    1076:	fc86                	sd	ra,120(sp)
    1078:	f8a2                	sd	s0,112(sp)
    107a:	f4a6                	sd	s1,104(sp)
    107c:	e4d6                	sd	s5,72(sp)
    107e:	0100                	addi	s0,sp,128
    1080:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
    1082:	4501                	li	a0,0
    1084:	353000ef          	jal	1bd6 <sbrk>
    1088:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
    108a:	00002517          	auipc	a0,0x2
    108e:	f7650513          	addi	a0,a0,-138 # 3000 <malloc+0xf9e>
    1092:	325000ef          	jal	1bb6 <mkdir>
  if(chdir("grindir") != 0){
    1096:	00002517          	auipc	a0,0x2
    109a:	f6a50513          	addi	a0,a0,-150 # 3000 <malloc+0xf9e>
    109e:	321000ef          	jal	1bbe <chdir>
    10a2:	cd19                	beqz	a0,10c0 <go+0x4c>
    10a4:	f0ca                	sd	s2,96(sp)
    10a6:	ecce                	sd	s3,88(sp)
    10a8:	e8d2                	sd	s4,80(sp)
    10aa:	e0da                	sd	s6,64(sp)
    10ac:	fc5e                	sd	s7,56(sp)
    printf("grind: chdir grindir failed\n");
    10ae:	00002517          	auipc	a0,0x2
    10b2:	f5a50513          	addi	a0,a0,-166 # 3008 <malloc+0xfa6>
    10b6:	6f9000ef          	jal	1fae <printf>
    exit(1);
    10ba:	4505                	li	a0,1
    10bc:	293000ef          	jal	1b4e <exit>
    10c0:	f0ca                	sd	s2,96(sp)
    10c2:	ecce                	sd	s3,88(sp)
    10c4:	e8d2                	sd	s4,80(sp)
    10c6:	e0da                	sd	s6,64(sp)
    10c8:	fc5e                	sd	s7,56(sp)
  }
  chdir("/");
    10ca:	00002517          	auipc	a0,0x2
    10ce:	f6650513          	addi	a0,a0,-154 # 3030 <malloc+0xfce>
    10d2:	2ed000ef          	jal	1bbe <chdir>
    10d6:	00002997          	auipc	s3,0x2
    10da:	f6a98993          	addi	s3,s3,-150 # 3040 <malloc+0xfde>
    10de:	c489                	beqz	s1,10e8 <go+0x74>
    10e0:	00002997          	auipc	s3,0x2
    10e4:	f5898993          	addi	s3,s3,-168 # 3038 <malloc+0xfd6>
  uint64 iters = 0;
    10e8:	4481                	li	s1,0
  int fd = -1;
    10ea:	5a7d                	li	s4,-1
    10ec:	00002917          	auipc	s2,0x2
    10f0:	22490913          	addi	s2,s2,548 # 3310 <malloc+0x12ae>
    10f4:	a819                	j	110a <go+0x96>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
    10f6:	20200593          	li	a1,514
    10fa:	00002517          	auipc	a0,0x2
    10fe:	f4e50513          	addi	a0,a0,-178 # 3048 <malloc+0xfe6>
    1102:	28d000ef          	jal	1b8e <open>
    1106:	271000ef          	jal	1b76 <close>
    iters++;
    110a:	0485                	addi	s1,s1,1
    if((iters % 500) == 0)
    110c:	1f400793          	li	a5,500
    1110:	02f4f7b3          	remu	a5,s1,a5
    1114:	e791                	bnez	a5,1120 <go+0xac>
      write(1, which_child?"B":"A", 1);
    1116:	4605                	li	a2,1
    1118:	85ce                	mv	a1,s3
    111a:	4505                	li	a0,1
    111c:	253000ef          	jal	1b6e <write>
    int what = rand() % 23;
    1120:	f39ff0ef          	jal	1058 <rand>
    1124:	47dd                	li	a5,23
    1126:	02f5653b          	remw	a0,a0,a5
    112a:	0005071b          	sext.w	a4,a0
    112e:	47d9                	li	a5,22
    1130:	fce7ede3          	bltu	a5,a4,110a <go+0x96>
    1134:	02051793          	slli	a5,a0,0x20
    1138:	01e7d513          	srli	a0,a5,0x1e
    113c:	954a                	add	a0,a0,s2
    113e:	411c                	lw	a5,0(a0)
    1140:	97ca                	add	a5,a5,s2
    1142:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
    1144:	20200593          	li	a1,514
    1148:	00002517          	auipc	a0,0x2
    114c:	f1050513          	addi	a0,a0,-240 # 3058 <malloc+0xff6>
    1150:	23f000ef          	jal	1b8e <open>
    1154:	223000ef          	jal	1b76 <close>
    1158:	bf4d                	j	110a <go+0x96>
    } else if(what == 3){
      unlink("grindir/../a");
    115a:	00002517          	auipc	a0,0x2
    115e:	eee50513          	addi	a0,a0,-274 # 3048 <malloc+0xfe6>
    1162:	23d000ef          	jal	1b9e <unlink>
    1166:	b755                	j	110a <go+0x96>
    } else if(what == 4){
      if(chdir("grindir") != 0){
    1168:	00002517          	auipc	a0,0x2
    116c:	e9850513          	addi	a0,a0,-360 # 3000 <malloc+0xf9e>
    1170:	24f000ef          	jal	1bbe <chdir>
    1174:	ed11                	bnez	a0,1190 <go+0x11c>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
    1176:	00002517          	auipc	a0,0x2
    117a:	efa50513          	addi	a0,a0,-262 # 3070 <malloc+0x100e>
    117e:	221000ef          	jal	1b9e <unlink>
      chdir("/");
    1182:	00002517          	auipc	a0,0x2
    1186:	eae50513          	addi	a0,a0,-338 # 3030 <malloc+0xfce>
    118a:	235000ef          	jal	1bbe <chdir>
    118e:	bfb5                	j	110a <go+0x96>
        printf("grind: chdir grindir failed\n");
    1190:	00002517          	auipc	a0,0x2
    1194:	e7850513          	addi	a0,a0,-392 # 3008 <malloc+0xfa6>
    1198:	617000ef          	jal	1fae <printf>
        exit(1);
    119c:	4505                	li	a0,1
    119e:	1b1000ef          	jal	1b4e <exit>
    } else if(what == 5){
      close(fd);
    11a2:	8552                	mv	a0,s4
    11a4:	1d3000ef          	jal	1b76 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
    11a8:	20200593          	li	a1,514
    11ac:	00002517          	auipc	a0,0x2
    11b0:	ecc50513          	addi	a0,a0,-308 # 3078 <malloc+0x1016>
    11b4:	1db000ef          	jal	1b8e <open>
    11b8:	8a2a                	mv	s4,a0
    11ba:	bf81                	j	110a <go+0x96>
    } else if(what == 6){
      close(fd);
    11bc:	8552                	mv	a0,s4
    11be:	1b9000ef          	jal	1b76 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
    11c2:	20200593          	li	a1,514
    11c6:	00002517          	auipc	a0,0x2
    11ca:	ec250513          	addi	a0,a0,-318 # 3088 <malloc+0x1026>
    11ce:	1c1000ef          	jal	1b8e <open>
    11d2:	8a2a                	mv	s4,a0
    11d4:	bf1d                	j	110a <go+0x96>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
    11d6:	3e700613          	li	a2,999
    11da:	00002597          	auipc	a1,0x2
    11de:	1d658593          	addi	a1,a1,470 # 33b0 <buf.0>
    11e2:	8552                	mv	a0,s4
    11e4:	18b000ef          	jal	1b6e <write>
    11e8:	b70d                	j	110a <go+0x96>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
    11ea:	3e700613          	li	a2,999
    11ee:	00002597          	auipc	a1,0x2
    11f2:	1c258593          	addi	a1,a1,450 # 33b0 <buf.0>
    11f6:	8552                	mv	a0,s4
    11f8:	16f000ef          	jal	1b66 <read>
    11fc:	b739                	j	110a <go+0x96>
    } else if(what == 9){
      mkdir("grindir/../a");
    11fe:	00002517          	auipc	a0,0x2
    1202:	e4a50513          	addi	a0,a0,-438 # 3048 <malloc+0xfe6>
    1206:	1b1000ef          	jal	1bb6 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
    120a:	20200593          	li	a1,514
    120e:	00002517          	auipc	a0,0x2
    1212:	e9250513          	addi	a0,a0,-366 # 30a0 <malloc+0x103e>
    1216:	179000ef          	jal	1b8e <open>
    121a:	15d000ef          	jal	1b76 <close>
      unlink("a/a");
    121e:	00002517          	auipc	a0,0x2
    1222:	e9250513          	addi	a0,a0,-366 # 30b0 <malloc+0x104e>
    1226:	179000ef          	jal	1b9e <unlink>
    122a:	b5c5                	j	110a <go+0x96>
    } else if(what == 10){
      mkdir("/../b");
    122c:	00002517          	auipc	a0,0x2
    1230:	e8c50513          	addi	a0,a0,-372 # 30b8 <malloc+0x1056>
    1234:	183000ef          	jal	1bb6 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
    1238:	20200593          	li	a1,514
    123c:	00002517          	auipc	a0,0x2
    1240:	e8450513          	addi	a0,a0,-380 # 30c0 <malloc+0x105e>
    1244:	14b000ef          	jal	1b8e <open>
    1248:	12f000ef          	jal	1b76 <close>
      unlink("b/b");
    124c:	00002517          	auipc	a0,0x2
    1250:	e8450513          	addi	a0,a0,-380 # 30d0 <malloc+0x106e>
    1254:	14b000ef          	jal	1b9e <unlink>
    1258:	bd4d                	j	110a <go+0x96>
    } else if(what == 11){
      unlink("b");
    125a:	00002517          	auipc	a0,0x2
    125e:	e7e50513          	addi	a0,a0,-386 # 30d8 <malloc+0x1076>
    1262:	13d000ef          	jal	1b9e <unlink>
      link("../grindir/./../a", "../b");
    1266:	00002597          	auipc	a1,0x2
    126a:	e0a58593          	addi	a1,a1,-502 # 3070 <malloc+0x100e>
    126e:	00002517          	auipc	a0,0x2
    1272:	e7250513          	addi	a0,a0,-398 # 30e0 <malloc+0x107e>
    1276:	139000ef          	jal	1bae <link>
    127a:	bd41                	j	110a <go+0x96>
    } else if(what == 12){
      unlink("../grindir/../a");
    127c:	00002517          	auipc	a0,0x2
    1280:	e7c50513          	addi	a0,a0,-388 # 30f8 <malloc+0x1096>
    1284:	11b000ef          	jal	1b9e <unlink>
      link(".././b", "/grindir/../a");
    1288:	00002597          	auipc	a1,0x2
    128c:	df058593          	addi	a1,a1,-528 # 3078 <malloc+0x1016>
    1290:	00002517          	auipc	a0,0x2
    1294:	e7850513          	addi	a0,a0,-392 # 3108 <malloc+0x10a6>
    1298:	117000ef          	jal	1bae <link>
    129c:	b5bd                	j	110a <go+0x96>
    } else if(what == 13){
      int pid = fork();
    129e:	0a9000ef          	jal	1b46 <fork>
      if(pid == 0){
    12a2:	c519                	beqz	a0,12b0 <go+0x23c>
        exit(0);
      } else if(pid < 0){
    12a4:	00054863          	bltz	a0,12b4 <go+0x240>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    12a8:	4501                	li	a0,0
    12aa:	0ad000ef          	jal	1b56 <wait>
    12ae:	bdb1                	j	110a <go+0x96>
        exit(0);
    12b0:	09f000ef          	jal	1b4e <exit>
        printf("grind: fork failed\n");
    12b4:	00002517          	auipc	a0,0x2
    12b8:	e5c50513          	addi	a0,a0,-420 # 3110 <malloc+0x10ae>
    12bc:	4f3000ef          	jal	1fae <printf>
        exit(1);
    12c0:	4505                	li	a0,1
    12c2:	08d000ef          	jal	1b4e <exit>
    } else if(what == 14){
      int pid = fork();
    12c6:	081000ef          	jal	1b46 <fork>
      if(pid == 0){
    12ca:	c519                	beqz	a0,12d8 <go+0x264>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
    12cc:	00054d63          	bltz	a0,12e6 <go+0x272>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    12d0:	4501                	li	a0,0
    12d2:	085000ef          	jal	1b56 <wait>
    12d6:	bd15                	j	110a <go+0x96>
        fork();
    12d8:	06f000ef          	jal	1b46 <fork>
        fork();
    12dc:	06b000ef          	jal	1b46 <fork>
        exit(0);
    12e0:	4501                	li	a0,0
    12e2:	06d000ef          	jal	1b4e <exit>
        printf("grind: fork failed\n");
    12e6:	00002517          	auipc	a0,0x2
    12ea:	e2a50513          	addi	a0,a0,-470 # 3110 <malloc+0x10ae>
    12ee:	4c1000ef          	jal	1fae <printf>
        exit(1);
    12f2:	4505                	li	a0,1
    12f4:	05b000ef          	jal	1b4e <exit>
    } else if(what == 15){
      sbrk(6011);
    12f8:	6505                	lui	a0,0x1
    12fa:	77b50513          	addi	a0,a0,1915 # 177b <go+0x707>
    12fe:	0d9000ef          	jal	1bd6 <sbrk>
    1302:	b521                	j	110a <go+0x96>
    } else if(what == 16){
      if(sbrk(0) > break0)
    1304:	4501                	li	a0,0
    1306:	0d1000ef          	jal	1bd6 <sbrk>
    130a:	e0aaf0e3          	bgeu	s5,a0,110a <go+0x96>
        sbrk(-(sbrk(0) - break0));
    130e:	4501                	li	a0,0
    1310:	0c7000ef          	jal	1bd6 <sbrk>
    1314:	40aa853b          	subw	a0,s5,a0
    1318:	0bf000ef          	jal	1bd6 <sbrk>
    131c:	b3fd                	j	110a <go+0x96>
    } else if(what == 17){
      int pid = fork();
    131e:	029000ef          	jal	1b46 <fork>
    1322:	8b2a                	mv	s6,a0
      if(pid == 0){
    1324:	c10d                	beqz	a0,1346 <go+0x2d2>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
    1326:	02054d63          	bltz	a0,1360 <go+0x2ec>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
    132a:	00002517          	auipc	a0,0x2
    132e:	e0650513          	addi	a0,a0,-506 # 3130 <malloc+0x10ce>
    1332:	08d000ef          	jal	1bbe <chdir>
    1336:	ed15                	bnez	a0,1372 <go+0x2fe>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
    1338:	855a                	mv	a0,s6
    133a:	045000ef          	jal	1b7e <kill>
      wait(0);
    133e:	4501                	li	a0,0
    1340:	017000ef          	jal	1b56 <wait>
    1344:	b3d9                	j	110a <go+0x96>
        close(open("a", O_CREATE|O_RDWR));
    1346:	20200593          	li	a1,514
    134a:	00002517          	auipc	a0,0x2
    134e:	dde50513          	addi	a0,a0,-546 # 3128 <malloc+0x10c6>
    1352:	03d000ef          	jal	1b8e <open>
    1356:	021000ef          	jal	1b76 <close>
        exit(0);
    135a:	4501                	li	a0,0
    135c:	7f2000ef          	jal	1b4e <exit>
        printf("grind: fork failed\n");
    1360:	00002517          	auipc	a0,0x2
    1364:	db050513          	addi	a0,a0,-592 # 3110 <malloc+0x10ae>
    1368:	447000ef          	jal	1fae <printf>
        exit(1);
    136c:	4505                	li	a0,1
    136e:	7e0000ef          	jal	1b4e <exit>
        printf("grind: chdir failed\n");
    1372:	00002517          	auipc	a0,0x2
    1376:	dce50513          	addi	a0,a0,-562 # 3140 <malloc+0x10de>
    137a:	435000ef          	jal	1fae <printf>
        exit(1);
    137e:	4505                	li	a0,1
    1380:	7ce000ef          	jal	1b4e <exit>
    } else if(what == 18){
      int pid = fork();
    1384:	7c2000ef          	jal	1b46 <fork>
      if(pid == 0){
    1388:	c519                	beqz	a0,1396 <go+0x322>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
    138a:	00054d63          	bltz	a0,13a4 <go+0x330>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    138e:	4501                	li	a0,0
    1390:	7c6000ef          	jal	1b56 <wait>
    1394:	bb9d                	j	110a <go+0x96>
        kill(getpid());
    1396:	039000ef          	jal	1bce <getpid>
    139a:	7e4000ef          	jal	1b7e <kill>
        exit(0);
    139e:	4501                	li	a0,0
    13a0:	7ae000ef          	jal	1b4e <exit>
        printf("grind: fork failed\n");
    13a4:	00002517          	auipc	a0,0x2
    13a8:	d6c50513          	addi	a0,a0,-660 # 3110 <malloc+0x10ae>
    13ac:	403000ef          	jal	1fae <printf>
        exit(1);
    13b0:	4505                	li	a0,1
    13b2:	79c000ef          	jal	1b4e <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
    13b6:	f9840513          	addi	a0,s0,-104
    13ba:	7a4000ef          	jal	1b5e <pipe>
    13be:	02054363          	bltz	a0,13e4 <go+0x370>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
    13c2:	784000ef          	jal	1b46 <fork>
      if(pid == 0){
    13c6:	c905                	beqz	a0,13f6 <go+0x382>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
    13c8:	08054263          	bltz	a0,144c <go+0x3d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
    13cc:	f9842503          	lw	a0,-104(s0)
    13d0:	7a6000ef          	jal	1b76 <close>
      close(fds[1]);
    13d4:	f9c42503          	lw	a0,-100(s0)
    13d8:	79e000ef          	jal	1b76 <close>
      wait(0);
    13dc:	4501                	li	a0,0
    13de:	778000ef          	jal	1b56 <wait>
    13e2:	b325                	j	110a <go+0x96>
        printf("grind: pipe failed\n");
    13e4:	00002517          	auipc	a0,0x2
    13e8:	d7450513          	addi	a0,a0,-652 # 3158 <malloc+0x10f6>
    13ec:	3c3000ef          	jal	1fae <printf>
        exit(1);
    13f0:	4505                	li	a0,1
    13f2:	75c000ef          	jal	1b4e <exit>
        fork();
    13f6:	750000ef          	jal	1b46 <fork>
        fork();
    13fa:	74c000ef          	jal	1b46 <fork>
        if(write(fds[1], "x", 1) != 1)
    13fe:	4605                	li	a2,1
    1400:	00002597          	auipc	a1,0x2
    1404:	d7058593          	addi	a1,a1,-656 # 3170 <malloc+0x110e>
    1408:	f9c42503          	lw	a0,-100(s0)
    140c:	762000ef          	jal	1b6e <write>
    1410:	4785                	li	a5,1
    1412:	00f51f63          	bne	a0,a5,1430 <go+0x3bc>
        if(read(fds[0], &c, 1) != 1)
    1416:	4605                	li	a2,1
    1418:	f9040593          	addi	a1,s0,-112
    141c:	f9842503          	lw	a0,-104(s0)
    1420:	746000ef          	jal	1b66 <read>
    1424:	4785                	li	a5,1
    1426:	00f51c63          	bne	a0,a5,143e <go+0x3ca>
        exit(0);
    142a:	4501                	li	a0,0
    142c:	722000ef          	jal	1b4e <exit>
          printf("grind: pipe write failed\n");
    1430:	00002517          	auipc	a0,0x2
    1434:	d4850513          	addi	a0,a0,-696 # 3178 <malloc+0x1116>
    1438:	377000ef          	jal	1fae <printf>
    143c:	bfe9                	j	1416 <go+0x3a2>
          printf("grind: pipe read failed\n");
    143e:	00002517          	auipc	a0,0x2
    1442:	d5a50513          	addi	a0,a0,-678 # 3198 <malloc+0x1136>
    1446:	369000ef          	jal	1fae <printf>
    144a:	b7c5                	j	142a <go+0x3b6>
        printf("grind: fork failed\n");
    144c:	00002517          	auipc	a0,0x2
    1450:	cc450513          	addi	a0,a0,-828 # 3110 <malloc+0x10ae>
    1454:	35b000ef          	jal	1fae <printf>
        exit(1);
    1458:	4505                	li	a0,1
    145a:	6f4000ef          	jal	1b4e <exit>
    } else if(what == 20){
      int pid = fork();
    145e:	6e8000ef          	jal	1b46 <fork>
      if(pid == 0){
    1462:	c519                	beqz	a0,1470 <go+0x3fc>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
    1464:	04054f63          	bltz	a0,14c2 <go+0x44e>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
    1468:	4501                	li	a0,0
    146a:	6ec000ef          	jal	1b56 <wait>
    146e:	b971                	j	110a <go+0x96>
        unlink("a");
    1470:	00002517          	auipc	a0,0x2
    1474:	cb850513          	addi	a0,a0,-840 # 3128 <malloc+0x10c6>
    1478:	726000ef          	jal	1b9e <unlink>
        mkdir("a");
    147c:	00002517          	auipc	a0,0x2
    1480:	cac50513          	addi	a0,a0,-852 # 3128 <malloc+0x10c6>
    1484:	732000ef          	jal	1bb6 <mkdir>
        chdir("a");
    1488:	00002517          	auipc	a0,0x2
    148c:	ca050513          	addi	a0,a0,-864 # 3128 <malloc+0x10c6>
    1490:	72e000ef          	jal	1bbe <chdir>
        unlink("../a");
    1494:	00002517          	auipc	a0,0x2
    1498:	d2450513          	addi	a0,a0,-732 # 31b8 <malloc+0x1156>
    149c:	702000ef          	jal	1b9e <unlink>
        fd = open("x", O_CREATE|O_RDWR);
    14a0:	20200593          	li	a1,514
    14a4:	00002517          	auipc	a0,0x2
    14a8:	ccc50513          	addi	a0,a0,-820 # 3170 <malloc+0x110e>
    14ac:	6e2000ef          	jal	1b8e <open>
        unlink("x");
    14b0:	00002517          	auipc	a0,0x2
    14b4:	cc050513          	addi	a0,a0,-832 # 3170 <malloc+0x110e>
    14b8:	6e6000ef          	jal	1b9e <unlink>
        exit(0);
    14bc:	4501                	li	a0,0
    14be:	690000ef          	jal	1b4e <exit>
        printf("grind: fork failed\n");
    14c2:	00002517          	auipc	a0,0x2
    14c6:	c4e50513          	addi	a0,a0,-946 # 3110 <malloc+0x10ae>
    14ca:	2e5000ef          	jal	1fae <printf>
        exit(1);
    14ce:	4505                	li	a0,1
    14d0:	67e000ef          	jal	1b4e <exit>
    } else if(what == 21){
      unlink("c");
    14d4:	00002517          	auipc	a0,0x2
    14d8:	cec50513          	addi	a0,a0,-788 # 31c0 <malloc+0x115e>
    14dc:	6c2000ef          	jal	1b9e <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
    14e0:	20200593          	li	a1,514
    14e4:	00002517          	auipc	a0,0x2
    14e8:	cdc50513          	addi	a0,a0,-804 # 31c0 <malloc+0x115e>
    14ec:	6a2000ef          	jal	1b8e <open>
    14f0:	8b2a                	mv	s6,a0
      if(fd1 < 0){
    14f2:	04054763          	bltz	a0,1540 <go+0x4cc>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
    14f6:	4605                	li	a2,1
    14f8:	00002597          	auipc	a1,0x2
    14fc:	c7858593          	addi	a1,a1,-904 # 3170 <malloc+0x110e>
    1500:	66e000ef          	jal	1b6e <write>
    1504:	4785                	li	a5,1
    1506:	04f51663          	bne	a0,a5,1552 <go+0x4de>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
    150a:	f9840593          	addi	a1,s0,-104
    150e:	855a                	mv	a0,s6
    1510:	696000ef          	jal	1ba6 <fstat>
    1514:	e921                	bnez	a0,1564 <go+0x4f0>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
    1516:	fa843583          	ld	a1,-88(s0)
    151a:	4785                	li	a5,1
    151c:	04f59d63          	bne	a1,a5,1576 <go+0x502>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
    1520:	f9c42583          	lw	a1,-100(s0)
    1524:	0c800793          	li	a5,200
    1528:	06b7e163          	bltu	a5,a1,158a <go+0x516>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
    152c:	855a                	mv	a0,s6
    152e:	648000ef          	jal	1b76 <close>
      unlink("c");
    1532:	00002517          	auipc	a0,0x2
    1536:	c8e50513          	addi	a0,a0,-882 # 31c0 <malloc+0x115e>
    153a:	664000ef          	jal	1b9e <unlink>
    153e:	b6f1                	j	110a <go+0x96>
        printf("grind: create c failed\n");
    1540:	00002517          	auipc	a0,0x2
    1544:	c8850513          	addi	a0,a0,-888 # 31c8 <malloc+0x1166>
    1548:	267000ef          	jal	1fae <printf>
        exit(1);
    154c:	4505                	li	a0,1
    154e:	600000ef          	jal	1b4e <exit>
        printf("grind: write c failed\n");
    1552:	00002517          	auipc	a0,0x2
    1556:	c8e50513          	addi	a0,a0,-882 # 31e0 <malloc+0x117e>
    155a:	255000ef          	jal	1fae <printf>
        exit(1);
    155e:	4505                	li	a0,1
    1560:	5ee000ef          	jal	1b4e <exit>
        printf("grind: fstat failed\n");
    1564:	00002517          	auipc	a0,0x2
    1568:	c9450513          	addi	a0,a0,-876 # 31f8 <malloc+0x1196>
    156c:	243000ef          	jal	1fae <printf>
        exit(1);
    1570:	4505                	li	a0,1
    1572:	5dc000ef          	jal	1b4e <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
    1576:	2581                	sext.w	a1,a1
    1578:	00002517          	auipc	a0,0x2
    157c:	c9850513          	addi	a0,a0,-872 # 3210 <malloc+0x11ae>
    1580:	22f000ef          	jal	1fae <printf>
        exit(1);
    1584:	4505                	li	a0,1
    1586:	5c8000ef          	jal	1b4e <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
    158a:	00002517          	auipc	a0,0x2
    158e:	cae50513          	addi	a0,a0,-850 # 3238 <malloc+0x11d6>
    1592:	21d000ef          	jal	1fae <printf>
        exit(1);
    1596:	4505                	li	a0,1
    1598:	5b6000ef          	jal	1b4e <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
    159c:	f8840513          	addi	a0,s0,-120
    15a0:	5be000ef          	jal	1b5e <pipe>
    15a4:	0a054563          	bltz	a0,164e <go+0x5da>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
    15a8:	f9040513          	addi	a0,s0,-112
    15ac:	5b2000ef          	jal	1b5e <pipe>
    15b0:	0a054963          	bltz	a0,1662 <go+0x5ee>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
    15b4:	592000ef          	jal	1b46 <fork>
      if(pid1 == 0){
    15b8:	cd5d                	beqz	a0,1676 <go+0x602>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
    15ba:	14054263          	bltz	a0,16fe <go+0x68a>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
    15be:	588000ef          	jal	1b46 <fork>
      if(pid2 == 0){
    15c2:	14050863          	beqz	a0,1712 <go+0x69e>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
    15c6:	1e054663          	bltz	a0,17b2 <go+0x73e>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
    15ca:	f8842503          	lw	a0,-120(s0)
    15ce:	5a8000ef          	jal	1b76 <close>
      close(aa[1]);
    15d2:	f8c42503          	lw	a0,-116(s0)
    15d6:	5a0000ef          	jal	1b76 <close>
      close(bb[1]);
    15da:	f9442503          	lw	a0,-108(s0)
    15de:	598000ef          	jal	1b76 <close>
      char buf[4] = { 0, 0, 0, 0 };
    15e2:	f8042023          	sw	zero,-128(s0)
      read(bb[0], buf+0, 1);
    15e6:	4605                	li	a2,1
    15e8:	f8040593          	addi	a1,s0,-128
    15ec:	f9042503          	lw	a0,-112(s0)
    15f0:	576000ef          	jal	1b66 <read>
      read(bb[0], buf+1, 1);
    15f4:	4605                	li	a2,1
    15f6:	f8140593          	addi	a1,s0,-127
    15fa:	f9042503          	lw	a0,-112(s0)
    15fe:	568000ef          	jal	1b66 <read>
      read(bb[0], buf+2, 1);
    1602:	4605                	li	a2,1
    1604:	f8240593          	addi	a1,s0,-126
    1608:	f9042503          	lw	a0,-112(s0)
    160c:	55a000ef          	jal	1b66 <read>
      close(bb[0]);
    1610:	f9042503          	lw	a0,-112(s0)
    1614:	562000ef          	jal	1b76 <close>
      int st1, st2;
      wait(&st1);
    1618:	f8440513          	addi	a0,s0,-124
    161c:	53a000ef          	jal	1b56 <wait>
      wait(&st2);
    1620:	f9840513          	addi	a0,s0,-104
    1624:	532000ef          	jal	1b56 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
    1628:	f8442783          	lw	a5,-124(s0)
    162c:	f9842b83          	lw	s7,-104(s0)
    1630:	0177eb33          	or	s6,a5,s7
    1634:	180b1963          	bnez	s6,17c6 <go+0x752>
    1638:	00002597          	auipc	a1,0x2
    163c:	ca058593          	addi	a1,a1,-864 # 32d8 <malloc+0x1276>
    1640:	f8040513          	addi	a0,s0,-128
    1644:	2ce000ef          	jal	1912 <strcmp>
    1648:	ac0501e3          	beqz	a0,110a <go+0x96>
    164c:	aab5                	j	17c8 <go+0x754>
        fprintf(2, "grind: pipe failed\n");
    164e:	00002597          	auipc	a1,0x2
    1652:	b0a58593          	addi	a1,a1,-1270 # 3158 <malloc+0x10f6>
    1656:	4509                	li	a0,2
    1658:	12d000ef          	jal	1f84 <fprintf>
        exit(1);
    165c:	4505                	li	a0,1
    165e:	4f0000ef          	jal	1b4e <exit>
        fprintf(2, "grind: pipe failed\n");
    1662:	00002597          	auipc	a1,0x2
    1666:	af658593          	addi	a1,a1,-1290 # 3158 <malloc+0x10f6>
    166a:	4509                	li	a0,2
    166c:	119000ef          	jal	1f84 <fprintf>
        exit(1);
    1670:	4505                	li	a0,1
    1672:	4dc000ef          	jal	1b4e <exit>
        close(bb[0]);
    1676:	f9042503          	lw	a0,-112(s0)
    167a:	4fc000ef          	jal	1b76 <close>
        close(bb[1]);
    167e:	f9442503          	lw	a0,-108(s0)
    1682:	4f4000ef          	jal	1b76 <close>
        close(aa[0]);
    1686:	f8842503          	lw	a0,-120(s0)
    168a:	4ec000ef          	jal	1b76 <close>
        close(1);
    168e:	4505                	li	a0,1
    1690:	4e6000ef          	jal	1b76 <close>
        if(dup(aa[1]) != 1){
    1694:	f8c42503          	lw	a0,-116(s0)
    1698:	52e000ef          	jal	1bc6 <dup>
    169c:	4785                	li	a5,1
    169e:	00f50c63          	beq	a0,a5,16b6 <go+0x642>
          fprintf(2, "grind: dup failed\n");
    16a2:	00002597          	auipc	a1,0x2
    16a6:	bbe58593          	addi	a1,a1,-1090 # 3260 <malloc+0x11fe>
    16aa:	4509                	li	a0,2
    16ac:	0d9000ef          	jal	1f84 <fprintf>
          exit(1);
    16b0:	4505                	li	a0,1
    16b2:	49c000ef          	jal	1b4e <exit>
        close(aa[1]);
    16b6:	f8c42503          	lw	a0,-116(s0)
    16ba:	4bc000ef          	jal	1b76 <close>
        char *args[3] = { "echo", "hi", 0 };
    16be:	00002797          	auipc	a5,0x2
    16c2:	bba78793          	addi	a5,a5,-1094 # 3278 <malloc+0x1216>
    16c6:	f8f43c23          	sd	a5,-104(s0)
    16ca:	00002797          	auipc	a5,0x2
    16ce:	bb678793          	addi	a5,a5,-1098 # 3280 <malloc+0x121e>
    16d2:	faf43023          	sd	a5,-96(s0)
    16d6:	fa043423          	sd	zero,-88(s0)
        exec("grindir/../echo", args);
    16da:	f9840593          	addi	a1,s0,-104
    16de:	00002517          	auipc	a0,0x2
    16e2:	baa50513          	addi	a0,a0,-1110 # 3288 <malloc+0x1226>
    16e6:	4a0000ef          	jal	1b86 <exec>
        fprintf(2, "grind: echo: not found\n");
    16ea:	00002597          	auipc	a1,0x2
    16ee:	bae58593          	addi	a1,a1,-1106 # 3298 <malloc+0x1236>
    16f2:	4509                	li	a0,2
    16f4:	091000ef          	jal	1f84 <fprintf>
        exit(2);
    16f8:	4509                	li	a0,2
    16fa:	454000ef          	jal	1b4e <exit>
        fprintf(2, "grind: fork failed\n");
    16fe:	00002597          	auipc	a1,0x2
    1702:	a1258593          	addi	a1,a1,-1518 # 3110 <malloc+0x10ae>
    1706:	4509                	li	a0,2
    1708:	07d000ef          	jal	1f84 <fprintf>
        exit(3);
    170c:	450d                	li	a0,3
    170e:	440000ef          	jal	1b4e <exit>
        close(aa[1]);
    1712:	f8c42503          	lw	a0,-116(s0)
    1716:	460000ef          	jal	1b76 <close>
        close(bb[0]);
    171a:	f9042503          	lw	a0,-112(s0)
    171e:	458000ef          	jal	1b76 <close>
        close(0);
    1722:	4501                	li	a0,0
    1724:	452000ef          	jal	1b76 <close>
        if(dup(aa[0]) != 0){
    1728:	f8842503          	lw	a0,-120(s0)
    172c:	49a000ef          	jal	1bc6 <dup>
    1730:	c919                	beqz	a0,1746 <go+0x6d2>
          fprintf(2, "grind: dup failed\n");
    1732:	00002597          	auipc	a1,0x2
    1736:	b2e58593          	addi	a1,a1,-1234 # 3260 <malloc+0x11fe>
    173a:	4509                	li	a0,2
    173c:	049000ef          	jal	1f84 <fprintf>
          exit(4);
    1740:	4511                	li	a0,4
    1742:	40c000ef          	jal	1b4e <exit>
        close(aa[0]);
    1746:	f8842503          	lw	a0,-120(s0)
    174a:	42c000ef          	jal	1b76 <close>
        close(1);
    174e:	4505                	li	a0,1
    1750:	426000ef          	jal	1b76 <close>
        if(dup(bb[1]) != 1){
    1754:	f9442503          	lw	a0,-108(s0)
    1758:	46e000ef          	jal	1bc6 <dup>
    175c:	4785                	li	a5,1
    175e:	00f50c63          	beq	a0,a5,1776 <go+0x702>
          fprintf(2, "grind: dup failed\n");
    1762:	00002597          	auipc	a1,0x2
    1766:	afe58593          	addi	a1,a1,-1282 # 3260 <malloc+0x11fe>
    176a:	4509                	li	a0,2
    176c:	019000ef          	jal	1f84 <fprintf>
          exit(5);
    1770:	4515                	li	a0,5
    1772:	3dc000ef          	jal	1b4e <exit>
        close(bb[1]);
    1776:	f9442503          	lw	a0,-108(s0)
    177a:	3fc000ef          	jal	1b76 <close>
        char *args[2] = { "cat", 0 };
    177e:	00002797          	auipc	a5,0x2
    1782:	b3278793          	addi	a5,a5,-1230 # 32b0 <malloc+0x124e>
    1786:	f8f43c23          	sd	a5,-104(s0)
    178a:	fa043023          	sd	zero,-96(s0)
        exec("/cat", args);
    178e:	f9840593          	addi	a1,s0,-104
    1792:	00002517          	auipc	a0,0x2
    1796:	b2650513          	addi	a0,a0,-1242 # 32b8 <malloc+0x1256>
    179a:	3ec000ef          	jal	1b86 <exec>
        fprintf(2, "grind: cat: not found\n");
    179e:	00002597          	auipc	a1,0x2
    17a2:	b2258593          	addi	a1,a1,-1246 # 32c0 <malloc+0x125e>
    17a6:	4509                	li	a0,2
    17a8:	7dc000ef          	jal	1f84 <fprintf>
        exit(6);
    17ac:	4519                	li	a0,6
    17ae:	3a0000ef          	jal	1b4e <exit>
        fprintf(2, "grind: fork failed\n");
    17b2:	00002597          	auipc	a1,0x2
    17b6:	95e58593          	addi	a1,a1,-1698 # 3110 <malloc+0x10ae>
    17ba:	4509                	li	a0,2
    17bc:	7c8000ef          	jal	1f84 <fprintf>
        exit(7);
    17c0:	451d                	li	a0,7
    17c2:	38c000ef          	jal	1b4e <exit>
    17c6:	8b3e                	mv	s6,a5
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
    17c8:	f8040693          	addi	a3,s0,-128
    17cc:	865e                	mv	a2,s7
    17ce:	85da                	mv	a1,s6
    17d0:	00002517          	auipc	a0,0x2
    17d4:	b1050513          	addi	a0,a0,-1264 # 32e0 <malloc+0x127e>
    17d8:	7d6000ef          	jal	1fae <printf>
        exit(1);
    17dc:	4505                	li	a0,1
    17de:	370000ef          	jal	1b4e <exit>

00000000000017e2 <iter>:
  }
}

void
iter()
{
    17e2:	7179                	addi	sp,sp,-48
    17e4:	f406                	sd	ra,40(sp)
    17e6:	f022                	sd	s0,32(sp)
    17e8:	1800                	addi	s0,sp,48
  unlink("a");
    17ea:	00002517          	auipc	a0,0x2
    17ee:	93e50513          	addi	a0,a0,-1730 # 3128 <malloc+0x10c6>
    17f2:	3ac000ef          	jal	1b9e <unlink>
  unlink("b");
    17f6:	00002517          	auipc	a0,0x2
    17fa:	8e250513          	addi	a0,a0,-1822 # 30d8 <malloc+0x1076>
    17fe:	3a0000ef          	jal	1b9e <unlink>
  
  int pid1 = fork();
    1802:	344000ef          	jal	1b46 <fork>
  if(pid1 < 0){
    1806:	02054163          	bltz	a0,1828 <iter+0x46>
    180a:	ec26                	sd	s1,24(sp)
    180c:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
    180e:	e905                	bnez	a0,183e <iter+0x5c>
    1810:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
    1812:	00002717          	auipc	a4,0x2
    1816:	b7e70713          	addi	a4,a4,-1154 # 3390 <rand_next>
    181a:	631c                	ld	a5,0(a4)
    181c:	01f7c793          	xori	a5,a5,31
    1820:	e31c                	sd	a5,0(a4)
    go(0);
    1822:	4501                	li	a0,0
    1824:	851ff0ef          	jal	1074 <go>
    1828:	ec26                	sd	s1,24(sp)
    182a:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
    182c:	00002517          	auipc	a0,0x2
    1830:	8e450513          	addi	a0,a0,-1820 # 3110 <malloc+0x10ae>
    1834:	77a000ef          	jal	1fae <printf>
    exit(1);
    1838:	4505                	li	a0,1
    183a:	314000ef          	jal	1b4e <exit>
    183e:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
    1840:	306000ef          	jal	1b46 <fork>
    1844:	892a                	mv	s2,a0
  if(pid2 < 0){
    1846:	02054063          	bltz	a0,1866 <iter+0x84>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
    184a:	e51d                	bnez	a0,1878 <iter+0x96>
    rand_next ^= 7177;
    184c:	00002697          	auipc	a3,0x2
    1850:	b4468693          	addi	a3,a3,-1212 # 3390 <rand_next>
    1854:	629c                	ld	a5,0(a3)
    1856:	6709                	lui	a4,0x2
    1858:	c0970713          	addi	a4,a4,-1015 # 1c09 <msgsnd+0x3>
    185c:	8fb9                	xor	a5,a5,a4
    185e:	e29c                	sd	a5,0(a3)
    go(1);
    1860:	4505                	li	a0,1
    1862:	813ff0ef          	jal	1074 <go>
    printf("grind: fork failed\n");
    1866:	00002517          	auipc	a0,0x2
    186a:	8aa50513          	addi	a0,a0,-1878 # 3110 <malloc+0x10ae>
    186e:	740000ef          	jal	1fae <printf>
    exit(1);
    1872:	4505                	li	a0,1
    1874:	2da000ef          	jal	1b4e <exit>
    exit(0);
  }

  int st1 = -1;
    1878:	57fd                	li	a5,-1
    187a:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
    187e:	fdc40513          	addi	a0,s0,-36
    1882:	2d4000ef          	jal	1b56 <wait>
  if(st1 != 0){
    1886:	fdc42783          	lw	a5,-36(s0)
    188a:	eb99                	bnez	a5,18a0 <iter+0xbe>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
    188c:	57fd                	li	a5,-1
    188e:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
    1892:	fd840513          	addi	a0,s0,-40
    1896:	2c0000ef          	jal	1b56 <wait>

  exit(0);
    189a:	4501                	li	a0,0
    189c:	2b2000ef          	jal	1b4e <exit>
    kill(pid1);
    18a0:	8526                	mv	a0,s1
    18a2:	2dc000ef          	jal	1b7e <kill>
    kill(pid2);
    18a6:	854a                	mv	a0,s2
    18a8:	2d6000ef          	jal	1b7e <kill>
    18ac:	b7c5                	j	188c <iter+0xaa>

00000000000018ae <main>:
}

int
main()
{
    18ae:	1101                	addi	sp,sp,-32
    18b0:	ec06                	sd	ra,24(sp)
    18b2:	e822                	sd	s0,16(sp)
    18b4:	e426                	sd	s1,8(sp)
    18b6:	1000                	addi	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
    18b8:	00002497          	auipc	s1,0x2
    18bc:	ad848493          	addi	s1,s1,-1320 # 3390 <rand_next>
    18c0:	a809                	j	18d2 <main+0x24>
      iter();
    18c2:	f21ff0ef          	jal	17e2 <iter>
    sleep(20);
    18c6:	4551                	li	a0,20
    18c8:	316000ef          	jal	1bde <sleep>
    rand_next += 1;
    18cc:	609c                	ld	a5,0(s1)
    18ce:	0785                	addi	a5,a5,1
    18d0:	e09c                	sd	a5,0(s1)
    int pid = fork();
    18d2:	274000ef          	jal	1b46 <fork>
    if(pid == 0){
    18d6:	d575                	beqz	a0,18c2 <main+0x14>
    if(pid > 0){
    18d8:	fea057e3          	blez	a0,18c6 <main+0x18>
      wait(0);
    18dc:	4501                	li	a0,0
    18de:	278000ef          	jal	1b56 <wait>
    18e2:	b7d5                	j	18c6 <main+0x18>

00000000000018e4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    18e4:	1141                	addi	sp,sp,-16
    18e6:	e406                	sd	ra,8(sp)
    18e8:	e022                	sd	s0,0(sp)
    18ea:	0800                	addi	s0,sp,16
  extern int main();
  main();
    18ec:	fc3ff0ef          	jal	18ae <main>
  exit(0);
    18f0:	4501                	li	a0,0
    18f2:	25c000ef          	jal	1b4e <exit>

00000000000018f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    18f6:	1141                	addi	sp,sp,-16
    18f8:	e422                	sd	s0,8(sp)
    18fa:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    18fc:	87aa                	mv	a5,a0
    18fe:	0585                	addi	a1,a1,1
    1900:	0785                	addi	a5,a5,1
    1902:	fff5c703          	lbu	a4,-1(a1)
    1906:	fee78fa3          	sb	a4,-1(a5)
    190a:	fb75                	bnez	a4,18fe <strcpy+0x8>
    ;
  return os;
}
    190c:	6422                	ld	s0,8(sp)
    190e:	0141                	addi	sp,sp,16
    1910:	8082                	ret

0000000000001912 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    1912:	1141                	addi	sp,sp,-16
    1914:	e422                	sd	s0,8(sp)
    1916:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    1918:	00054783          	lbu	a5,0(a0)
    191c:	cb91                	beqz	a5,1930 <strcmp+0x1e>
    191e:	0005c703          	lbu	a4,0(a1)
    1922:	00f71763          	bne	a4,a5,1930 <strcmp+0x1e>
    p++, q++;
    1926:	0505                	addi	a0,a0,1
    1928:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    192a:	00054783          	lbu	a5,0(a0)
    192e:	fbe5                	bnez	a5,191e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    1930:	0005c503          	lbu	a0,0(a1)
}
    1934:	40a7853b          	subw	a0,a5,a0
    1938:	6422                	ld	s0,8(sp)
    193a:	0141                	addi	sp,sp,16
    193c:	8082                	ret

000000000000193e <strlen>:

uint
strlen(const char *s)
{
    193e:	1141                	addi	sp,sp,-16
    1940:	e422                	sd	s0,8(sp)
    1942:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1944:	00054783          	lbu	a5,0(a0)
    1948:	cf91                	beqz	a5,1964 <strlen+0x26>
    194a:	0505                	addi	a0,a0,1
    194c:	87aa                	mv	a5,a0
    194e:	86be                	mv	a3,a5
    1950:	0785                	addi	a5,a5,1
    1952:	fff7c703          	lbu	a4,-1(a5)
    1956:	ff65                	bnez	a4,194e <strlen+0x10>
    1958:	40a6853b          	subw	a0,a3,a0
    195c:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    195e:	6422                	ld	s0,8(sp)
    1960:	0141                	addi	sp,sp,16
    1962:	8082                	ret
  for(n = 0; s[n]; n++)
    1964:	4501                	li	a0,0
    1966:	bfe5                	j	195e <strlen+0x20>

0000000000001968 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1968:	1141                	addi	sp,sp,-16
    196a:	e422                	sd	s0,8(sp)
    196c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    196e:	ca19                	beqz	a2,1984 <memset+0x1c>
    1970:	87aa                	mv	a5,a0
    1972:	1602                	slli	a2,a2,0x20
    1974:	9201                	srli	a2,a2,0x20
    1976:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    197a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    197e:	0785                	addi	a5,a5,1
    1980:	fee79de3          	bne	a5,a4,197a <memset+0x12>
  }
  return dst;
}
    1984:	6422                	ld	s0,8(sp)
    1986:	0141                	addi	sp,sp,16
    1988:	8082                	ret

000000000000198a <strchr>:

char*
strchr(const char *s, char c)
{
    198a:	1141                	addi	sp,sp,-16
    198c:	e422                	sd	s0,8(sp)
    198e:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1990:	00054783          	lbu	a5,0(a0)
    1994:	cb99                	beqz	a5,19aa <strchr+0x20>
    if(*s == c)
    1996:	00f58763          	beq	a1,a5,19a4 <strchr+0x1a>
  for(; *s; s++)
    199a:	0505                	addi	a0,a0,1
    199c:	00054783          	lbu	a5,0(a0)
    19a0:	fbfd                	bnez	a5,1996 <strchr+0xc>
      return (char*)s;
  return 0;
    19a2:	4501                	li	a0,0
}
    19a4:	6422                	ld	s0,8(sp)
    19a6:	0141                	addi	sp,sp,16
    19a8:	8082                	ret
  return 0;
    19aa:	4501                	li	a0,0
    19ac:	bfe5                	j	19a4 <strchr+0x1a>

00000000000019ae <gets>:

char*
gets(char *buf, int max)
{
    19ae:	711d                	addi	sp,sp,-96
    19b0:	ec86                	sd	ra,88(sp)
    19b2:	e8a2                	sd	s0,80(sp)
    19b4:	e4a6                	sd	s1,72(sp)
    19b6:	e0ca                	sd	s2,64(sp)
    19b8:	fc4e                	sd	s3,56(sp)
    19ba:	f852                	sd	s4,48(sp)
    19bc:	f456                	sd	s5,40(sp)
    19be:	f05a                	sd	s6,32(sp)
    19c0:	ec5e                	sd	s7,24(sp)
    19c2:	1080                	addi	s0,sp,96
    19c4:	8baa                	mv	s7,a0
    19c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    19c8:	892a                	mv	s2,a0
    19ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    19cc:	4aa9                	li	s5,10
    19ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    19d0:	89a6                	mv	s3,s1
    19d2:	2485                	addiw	s1,s1,1
    19d4:	0344d663          	bge	s1,s4,1a00 <gets+0x52>
    cc = read(0, &c, 1);
    19d8:	4605                	li	a2,1
    19da:	faf40593          	addi	a1,s0,-81
    19de:	4501                	li	a0,0
    19e0:	186000ef          	jal	1b66 <read>
    if(cc < 1)
    19e4:	00a05e63          	blez	a0,1a00 <gets+0x52>
    buf[i++] = c;
    19e8:	faf44783          	lbu	a5,-81(s0)
    19ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    19f0:	01578763          	beq	a5,s5,19fe <gets+0x50>
    19f4:	0905                	addi	s2,s2,1
    19f6:	fd679de3          	bne	a5,s6,19d0 <gets+0x22>
    buf[i++] = c;
    19fa:	89a6                	mv	s3,s1
    19fc:	a011                	j	1a00 <gets+0x52>
    19fe:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1a00:	99de                	add	s3,s3,s7
    1a02:	00098023          	sb	zero,0(s3)
  return buf;
}
    1a06:	855e                	mv	a0,s7
    1a08:	60e6                	ld	ra,88(sp)
    1a0a:	6446                	ld	s0,80(sp)
    1a0c:	64a6                	ld	s1,72(sp)
    1a0e:	6906                	ld	s2,64(sp)
    1a10:	79e2                	ld	s3,56(sp)
    1a12:	7a42                	ld	s4,48(sp)
    1a14:	7aa2                	ld	s5,40(sp)
    1a16:	7b02                	ld	s6,32(sp)
    1a18:	6be2                	ld	s7,24(sp)
    1a1a:	6125                	addi	sp,sp,96
    1a1c:	8082                	ret

0000000000001a1e <stat>:

int
stat(const char *n, struct stat *st)
{
    1a1e:	1101                	addi	sp,sp,-32
    1a20:	ec06                	sd	ra,24(sp)
    1a22:	e822                	sd	s0,16(sp)
    1a24:	e04a                	sd	s2,0(sp)
    1a26:	1000                	addi	s0,sp,32
    1a28:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1a2a:	4581                	li	a1,0
    1a2c:	162000ef          	jal	1b8e <open>
  if(fd < 0)
    1a30:	02054263          	bltz	a0,1a54 <stat+0x36>
    1a34:	e426                	sd	s1,8(sp)
    1a36:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1a38:	85ca                	mv	a1,s2
    1a3a:	16c000ef          	jal	1ba6 <fstat>
    1a3e:	892a                	mv	s2,a0
  close(fd);
    1a40:	8526                	mv	a0,s1
    1a42:	134000ef          	jal	1b76 <close>
  return r;
    1a46:	64a2                	ld	s1,8(sp)
}
    1a48:	854a                	mv	a0,s2
    1a4a:	60e2                	ld	ra,24(sp)
    1a4c:	6442                	ld	s0,16(sp)
    1a4e:	6902                	ld	s2,0(sp)
    1a50:	6105                	addi	sp,sp,32
    1a52:	8082                	ret
    return -1;
    1a54:	597d                	li	s2,-1
    1a56:	bfcd                	j	1a48 <stat+0x2a>

0000000000001a58 <atoi>:

int
atoi(const char *s)
{
    1a58:	1141                	addi	sp,sp,-16
    1a5a:	e422                	sd	s0,8(sp)
    1a5c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1a5e:	00054683          	lbu	a3,0(a0)
    1a62:	fd06879b          	addiw	a5,a3,-48
    1a66:	0ff7f793          	zext.b	a5,a5
    1a6a:	4625                	li	a2,9
    1a6c:	02f66863          	bltu	a2,a5,1a9c <atoi+0x44>
    1a70:	872a                	mv	a4,a0
  n = 0;
    1a72:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    1a74:	0705                	addi	a4,a4,1
    1a76:	0025179b          	slliw	a5,a0,0x2
    1a7a:	9fa9                	addw	a5,a5,a0
    1a7c:	0017979b          	slliw	a5,a5,0x1
    1a80:	9fb5                	addw	a5,a5,a3
    1a82:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1a86:	00074683          	lbu	a3,0(a4)
    1a8a:	fd06879b          	addiw	a5,a3,-48
    1a8e:	0ff7f793          	zext.b	a5,a5
    1a92:	fef671e3          	bgeu	a2,a5,1a74 <atoi+0x1c>
  return n;
}
    1a96:	6422                	ld	s0,8(sp)
    1a98:	0141                	addi	sp,sp,16
    1a9a:	8082                	ret
  n = 0;
    1a9c:	4501                	li	a0,0
    1a9e:	bfe5                	j	1a96 <atoi+0x3e>

0000000000001aa0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1aa0:	1141                	addi	sp,sp,-16
    1aa2:	e422                	sd	s0,8(sp)
    1aa4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1aa6:	02b57463          	bgeu	a0,a1,1ace <memmove+0x2e>
    while(n-- > 0)
    1aaa:	00c05f63          	blez	a2,1ac8 <memmove+0x28>
    1aae:	1602                	slli	a2,a2,0x20
    1ab0:	9201                	srli	a2,a2,0x20
    1ab2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1ab6:	872a                	mv	a4,a0
      *dst++ = *src++;
    1ab8:	0585                	addi	a1,a1,1
    1aba:	0705                	addi	a4,a4,1
    1abc:	fff5c683          	lbu	a3,-1(a1)
    1ac0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1ac4:	fef71ae3          	bne	a4,a5,1ab8 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1ac8:	6422                	ld	s0,8(sp)
    1aca:	0141                	addi	sp,sp,16
    1acc:	8082                	ret
    dst += n;
    1ace:	00c50733          	add	a4,a0,a2
    src += n;
    1ad2:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1ad4:	fec05ae3          	blez	a2,1ac8 <memmove+0x28>
    1ad8:	fff6079b          	addiw	a5,a2,-1
    1adc:	1782                	slli	a5,a5,0x20
    1ade:	9381                	srli	a5,a5,0x20
    1ae0:	fff7c793          	not	a5,a5
    1ae4:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1ae6:	15fd                	addi	a1,a1,-1
    1ae8:	177d                	addi	a4,a4,-1
    1aea:	0005c683          	lbu	a3,0(a1)
    1aee:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1af2:	fee79ae3          	bne	a5,a4,1ae6 <memmove+0x46>
    1af6:	bfc9                	j	1ac8 <memmove+0x28>

0000000000001af8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1af8:	1141                	addi	sp,sp,-16
    1afa:	e422                	sd	s0,8(sp)
    1afc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1afe:	ca05                	beqz	a2,1b2e <memcmp+0x36>
    1b00:	fff6069b          	addiw	a3,a2,-1
    1b04:	1682                	slli	a3,a3,0x20
    1b06:	9281                	srli	a3,a3,0x20
    1b08:	0685                	addi	a3,a3,1
    1b0a:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1b0c:	00054783          	lbu	a5,0(a0)
    1b10:	0005c703          	lbu	a4,0(a1)
    1b14:	00e79863          	bne	a5,a4,1b24 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1b18:	0505                	addi	a0,a0,1
    p2++;
    1b1a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1b1c:	fed518e3          	bne	a0,a3,1b0c <memcmp+0x14>
  }
  return 0;
    1b20:	4501                	li	a0,0
    1b22:	a019                	j	1b28 <memcmp+0x30>
      return *p1 - *p2;
    1b24:	40e7853b          	subw	a0,a5,a4
}
    1b28:	6422                	ld	s0,8(sp)
    1b2a:	0141                	addi	sp,sp,16
    1b2c:	8082                	ret
  return 0;
    1b2e:	4501                	li	a0,0
    1b30:	bfe5                	j	1b28 <memcmp+0x30>

0000000000001b32 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1b32:	1141                	addi	sp,sp,-16
    1b34:	e406                	sd	ra,8(sp)
    1b36:	e022                	sd	s0,0(sp)
    1b38:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1b3a:	f67ff0ef          	jal	1aa0 <memmove>
}
    1b3e:	60a2                	ld	ra,8(sp)
    1b40:	6402                	ld	s0,0(sp)
    1b42:	0141                	addi	sp,sp,16
    1b44:	8082                	ret

0000000000001b46 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1b46:	4885                	li	a7,1
 ecall
    1b48:	00000073          	ecall
 ret
    1b4c:	8082                	ret

0000000000001b4e <exit>:
.global exit
exit:
 li a7, SYS_exit
    1b4e:	4889                	li	a7,2
 ecall
    1b50:	00000073          	ecall
 ret
    1b54:	8082                	ret

0000000000001b56 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1b56:	488d                	li	a7,3
 ecall
    1b58:	00000073          	ecall
 ret
    1b5c:	8082                	ret

0000000000001b5e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1b5e:	4891                	li	a7,4
 ecall
    1b60:	00000073          	ecall
 ret
    1b64:	8082                	ret

0000000000001b66 <read>:
.global read
read:
 li a7, SYS_read
    1b66:	4895                	li	a7,5
 ecall
    1b68:	00000073          	ecall
 ret
    1b6c:	8082                	ret

0000000000001b6e <write>:
.global write
write:
 li a7, SYS_write
    1b6e:	48c1                	li	a7,16
 ecall
    1b70:	00000073          	ecall
 ret
    1b74:	8082                	ret

0000000000001b76 <close>:
.global close
close:
 li a7, SYS_close
    1b76:	48d5                	li	a7,21
 ecall
    1b78:	00000073          	ecall
 ret
    1b7c:	8082                	ret

0000000000001b7e <kill>:
.global kill
kill:
 li a7, SYS_kill
    1b7e:	4899                	li	a7,6
 ecall
    1b80:	00000073          	ecall
 ret
    1b84:	8082                	ret

0000000000001b86 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1b86:	489d                	li	a7,7
 ecall
    1b88:	00000073          	ecall
 ret
    1b8c:	8082                	ret

0000000000001b8e <open>:
.global open
open:
 li a7, SYS_open
    1b8e:	48bd                	li	a7,15
 ecall
    1b90:	00000073          	ecall
 ret
    1b94:	8082                	ret

0000000000001b96 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1b96:	48c5                	li	a7,17
 ecall
    1b98:	00000073          	ecall
 ret
    1b9c:	8082                	ret

0000000000001b9e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1b9e:	48c9                	li	a7,18
 ecall
    1ba0:	00000073          	ecall
 ret
    1ba4:	8082                	ret

0000000000001ba6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1ba6:	48a1                	li	a7,8
 ecall
    1ba8:	00000073          	ecall
 ret
    1bac:	8082                	ret

0000000000001bae <link>:
.global link
link:
 li a7, SYS_link
    1bae:	48cd                	li	a7,19
 ecall
    1bb0:	00000073          	ecall
 ret
    1bb4:	8082                	ret

0000000000001bb6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1bb6:	48d1                	li	a7,20
 ecall
    1bb8:	00000073          	ecall
 ret
    1bbc:	8082                	ret

0000000000001bbe <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1bbe:	48a5                	li	a7,9
 ecall
    1bc0:	00000073          	ecall
 ret
    1bc4:	8082                	ret

0000000000001bc6 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1bc6:	48a9                	li	a7,10
 ecall
    1bc8:	00000073          	ecall
 ret
    1bcc:	8082                	ret

0000000000001bce <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1bce:	48ad                	li	a7,11
 ecall
    1bd0:	00000073          	ecall
 ret
    1bd4:	8082                	ret

0000000000001bd6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1bd6:	48b1                	li	a7,12
 ecall
    1bd8:	00000073          	ecall
 ret
    1bdc:	8082                	ret

0000000000001bde <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1bde:	48b5                	li	a7,13
 ecall
    1be0:	00000073          	ecall
 ret
    1be4:	8082                	ret

0000000000001be6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1be6:	48b9                	li	a7,14
 ecall
    1be8:	00000073          	ecall
 ret
    1bec:	8082                	ret

0000000000001bee <cps>:
.global cps
cps:
 li a7, SYS_cps
    1bee:	48d9                	li	a7,22
 ecall
    1bf0:	00000073          	ecall
 ret
    1bf4:	8082                	ret

0000000000001bf6 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1bf6:	48dd                	li	a7,23
 ecall
    1bf8:	00000073          	ecall
 ret
    1bfc:	8082                	ret

0000000000001bfe <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1bfe:	48e1                	li	a7,24
 ecall
    1c00:	00000073          	ecall
 ret
    1c04:	8082                	ret

0000000000001c06 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1c06:	48e5                	li	a7,25
 ecall
    1c08:	00000073          	ecall
 ret
    1c0c:	8082                	ret

0000000000001c0e <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1c0e:	48e9                	li	a7,26
 ecall
    1c10:	00000073          	ecall
 ret
    1c14:	8082                	ret

0000000000001c16 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    1c16:	48ed                	li	a7,27
 ecall
    1c18:	00000073          	ecall
 ret
    1c1c:	8082                	ret

0000000000001c1e <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1c1e:	48f1                	li	a7,28
 ecall
    1c20:	00000073          	ecall
 ret
    1c24:	8082                	ret

0000000000001c26 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    1c26:	48f5                	li	a7,29
 ecall
    1c28:	00000073          	ecall
 ret
    1c2c:	8082                	ret

0000000000001c2e <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1c2e:	48f9                	li	a7,30
 ecall
    1c30:	00000073          	ecall
 ret
    1c34:	8082                	ret

0000000000001c36 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1c36:	1101                	addi	sp,sp,-32
    1c38:	ec06                	sd	ra,24(sp)
    1c3a:	e822                	sd	s0,16(sp)
    1c3c:	1000                	addi	s0,sp,32
    1c3e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1c42:	4605                	li	a2,1
    1c44:	fef40593          	addi	a1,s0,-17
    1c48:	f27ff0ef          	jal	1b6e <write>
}
    1c4c:	60e2                	ld	ra,24(sp)
    1c4e:	6442                	ld	s0,16(sp)
    1c50:	6105                	addi	sp,sp,32
    1c52:	8082                	ret

0000000000001c54 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1c54:	7139                	addi	sp,sp,-64
    1c56:	fc06                	sd	ra,56(sp)
    1c58:	f822                	sd	s0,48(sp)
    1c5a:	f426                	sd	s1,40(sp)
    1c5c:	0080                	addi	s0,sp,64
    1c5e:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1c60:	c299                	beqz	a3,1c66 <printint+0x12>
    1c62:	0805c963          	bltz	a1,1cf4 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1c66:	2581                	sext.w	a1,a1
  neg = 0;
    1c68:	4881                	li	a7,0
    1c6a:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1c6e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1c70:	2601                	sext.w	a2,a2
    1c72:	00001517          	auipc	a0,0x1
    1c76:	6fe50513          	addi	a0,a0,1790 # 3370 <digits>
    1c7a:	883a                	mv	a6,a4
    1c7c:	2705                	addiw	a4,a4,1
    1c7e:	02c5f7bb          	remuw	a5,a1,a2
    1c82:	1782                	slli	a5,a5,0x20
    1c84:	9381                	srli	a5,a5,0x20
    1c86:	97aa                	add	a5,a5,a0
    1c88:	0007c783          	lbu	a5,0(a5)
    1c8c:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1c90:	0005879b          	sext.w	a5,a1
    1c94:	02c5d5bb          	divuw	a1,a1,a2
    1c98:	0685                	addi	a3,a3,1
    1c9a:	fec7f0e3          	bgeu	a5,a2,1c7a <printint+0x26>
  if(neg)
    1c9e:	00088c63          	beqz	a7,1cb6 <printint+0x62>
    buf[i++] = '-';
    1ca2:	fd070793          	addi	a5,a4,-48
    1ca6:	00878733          	add	a4,a5,s0
    1caa:	02d00793          	li	a5,45
    1cae:	fef70823          	sb	a5,-16(a4)
    1cb2:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1cb6:	02e05a63          	blez	a4,1cea <printint+0x96>
    1cba:	f04a                	sd	s2,32(sp)
    1cbc:	ec4e                	sd	s3,24(sp)
    1cbe:	fc040793          	addi	a5,s0,-64
    1cc2:	00e78933          	add	s2,a5,a4
    1cc6:	fff78993          	addi	s3,a5,-1
    1cca:	99ba                	add	s3,s3,a4
    1ccc:	377d                	addiw	a4,a4,-1
    1cce:	1702                	slli	a4,a4,0x20
    1cd0:	9301                	srli	a4,a4,0x20
    1cd2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1cd6:	fff94583          	lbu	a1,-1(s2)
    1cda:	8526                	mv	a0,s1
    1cdc:	f5bff0ef          	jal	1c36 <putc>
  while(--i >= 0)
    1ce0:	197d                	addi	s2,s2,-1
    1ce2:	ff391ae3          	bne	s2,s3,1cd6 <printint+0x82>
    1ce6:	7902                	ld	s2,32(sp)
    1ce8:	69e2                	ld	s3,24(sp)
}
    1cea:	70e2                	ld	ra,56(sp)
    1cec:	7442                	ld	s0,48(sp)
    1cee:	74a2                	ld	s1,40(sp)
    1cf0:	6121                	addi	sp,sp,64
    1cf2:	8082                	ret
    x = -xx;
    1cf4:	40b005bb          	negw	a1,a1
    neg = 1;
    1cf8:	4885                	li	a7,1
    x = -xx;
    1cfa:	bf85                	j	1c6a <printint+0x16>

0000000000001cfc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1cfc:	711d                	addi	sp,sp,-96
    1cfe:	ec86                	sd	ra,88(sp)
    1d00:	e8a2                	sd	s0,80(sp)
    1d02:	e0ca                	sd	s2,64(sp)
    1d04:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1d06:	0005c903          	lbu	s2,0(a1)
    1d0a:	26090863          	beqz	s2,1f7a <vprintf+0x27e>
    1d0e:	e4a6                	sd	s1,72(sp)
    1d10:	fc4e                	sd	s3,56(sp)
    1d12:	f852                	sd	s4,48(sp)
    1d14:	f456                	sd	s5,40(sp)
    1d16:	f05a                	sd	s6,32(sp)
    1d18:	ec5e                	sd	s7,24(sp)
    1d1a:	e862                	sd	s8,16(sp)
    1d1c:	e466                	sd	s9,8(sp)
    1d1e:	8b2a                	mv	s6,a0
    1d20:	8a2e                	mv	s4,a1
    1d22:	8bb2                	mv	s7,a2
  state = 0;
    1d24:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1d26:	4481                	li	s1,0
    1d28:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1d2a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1d2e:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1d32:	06c00c93          	li	s9,108
    1d36:	a005                	j	1d56 <vprintf+0x5a>
        putc(fd, c0);
    1d38:	85ca                	mv	a1,s2
    1d3a:	855a                	mv	a0,s6
    1d3c:	efbff0ef          	jal	1c36 <putc>
    1d40:	a019                	j	1d46 <vprintf+0x4a>
    } else if(state == '%'){
    1d42:	03598263          	beq	s3,s5,1d66 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    1d46:	2485                	addiw	s1,s1,1
    1d48:	8726                	mv	a4,s1
    1d4a:	009a07b3          	add	a5,s4,s1
    1d4e:	0007c903          	lbu	s2,0(a5)
    1d52:	20090c63          	beqz	s2,1f6a <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    1d56:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1d5a:	fe0994e3          	bnez	s3,1d42 <vprintf+0x46>
      if(c0 == '%'){
    1d5e:	fd579de3          	bne	a5,s5,1d38 <vprintf+0x3c>
        state = '%';
    1d62:	89be                	mv	s3,a5
    1d64:	b7cd                	j	1d46 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    1d66:	00ea06b3          	add	a3,s4,a4
    1d6a:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1d6e:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1d70:	c681                	beqz	a3,1d78 <vprintf+0x7c>
    1d72:	9752                	add	a4,a4,s4
    1d74:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1d78:	03878f63          	beq	a5,s8,1db6 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1d7c:	05978963          	beq	a5,s9,1dce <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1d80:	07500713          	li	a4,117
    1d84:	0ee78363          	beq	a5,a4,1e6a <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1d88:	07800713          	li	a4,120
    1d8c:	12e78563          	beq	a5,a4,1eb6 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1d90:	07000713          	li	a4,112
    1d94:	14e78a63          	beq	a5,a4,1ee8 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1d98:	07300713          	li	a4,115
    1d9c:	18e78a63          	beq	a5,a4,1f30 <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1da0:	02500713          	li	a4,37
    1da4:	04e79563          	bne	a5,a4,1dee <vprintf+0xf2>
        putc(fd, '%');
    1da8:	02500593          	li	a1,37
    1dac:	855a                	mv	a0,s6
    1dae:	e89ff0ef          	jal	1c36 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1db2:	4981                	li	s3,0
    1db4:	bf49                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1db6:	008b8913          	addi	s2,s7,8
    1dba:	4685                	li	a3,1
    1dbc:	4629                	li	a2,10
    1dbe:	000ba583          	lw	a1,0(s7)
    1dc2:	855a                	mv	a0,s6
    1dc4:	e91ff0ef          	jal	1c54 <printint>
    1dc8:	8bca                	mv	s7,s2
      state = 0;
    1dca:	4981                	li	s3,0
    1dcc:	bfad                	j	1d46 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1dce:	06400793          	li	a5,100
    1dd2:	02f68963          	beq	a3,a5,1e04 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1dd6:	06c00793          	li	a5,108
    1dda:	04f68263          	beq	a3,a5,1e1e <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1dde:	07500793          	li	a5,117
    1de2:	0af68063          	beq	a3,a5,1e82 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1de6:	07800793          	li	a5,120
    1dea:	0ef68263          	beq	a3,a5,1ece <vprintf+0x1d2>
        putc(fd, '%');
    1dee:	02500593          	li	a1,37
    1df2:	855a                	mv	a0,s6
    1df4:	e43ff0ef          	jal	1c36 <putc>
        putc(fd, c0);
    1df8:	85ca                	mv	a1,s2
    1dfa:	855a                	mv	a0,s6
    1dfc:	e3bff0ef          	jal	1c36 <putc>
      state = 0;
    1e00:	4981                	li	s3,0
    1e02:	b791                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1e04:	008b8913          	addi	s2,s7,8
    1e08:	4685                	li	a3,1
    1e0a:	4629                	li	a2,10
    1e0c:	000ba583          	lw	a1,0(s7)
    1e10:	855a                	mv	a0,s6
    1e12:	e43ff0ef          	jal	1c54 <printint>
        i += 1;
    1e16:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1e18:	8bca                	mv	s7,s2
      state = 0;
    1e1a:	4981                	li	s3,0
        i += 1;
    1e1c:	b72d                	j	1d46 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1e1e:	06400793          	li	a5,100
    1e22:	02f60763          	beq	a2,a5,1e50 <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1e26:	07500793          	li	a5,117
    1e2a:	06f60963          	beq	a2,a5,1e9c <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1e2e:	07800793          	li	a5,120
    1e32:	faf61ee3          	bne	a2,a5,1dee <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1e36:	008b8913          	addi	s2,s7,8
    1e3a:	4681                	li	a3,0
    1e3c:	4641                	li	a2,16
    1e3e:	000ba583          	lw	a1,0(s7)
    1e42:	855a                	mv	a0,s6
    1e44:	e11ff0ef          	jal	1c54 <printint>
        i += 2;
    1e48:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1e4a:	8bca                	mv	s7,s2
      state = 0;
    1e4c:	4981                	li	s3,0
        i += 2;
    1e4e:	bde5                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1e50:	008b8913          	addi	s2,s7,8
    1e54:	4685                	li	a3,1
    1e56:	4629                	li	a2,10
    1e58:	000ba583          	lw	a1,0(s7)
    1e5c:	855a                	mv	a0,s6
    1e5e:	df7ff0ef          	jal	1c54 <printint>
        i += 2;
    1e62:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1e64:	8bca                	mv	s7,s2
      state = 0;
    1e66:	4981                	li	s3,0
        i += 2;
    1e68:	bdf9                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1e6a:	008b8913          	addi	s2,s7,8
    1e6e:	4681                	li	a3,0
    1e70:	4629                	li	a2,10
    1e72:	000ba583          	lw	a1,0(s7)
    1e76:	855a                	mv	a0,s6
    1e78:	dddff0ef          	jal	1c54 <printint>
    1e7c:	8bca                	mv	s7,s2
      state = 0;
    1e7e:	4981                	li	s3,0
    1e80:	b5d9                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1e82:	008b8913          	addi	s2,s7,8
    1e86:	4681                	li	a3,0
    1e88:	4629                	li	a2,10
    1e8a:	000ba583          	lw	a1,0(s7)
    1e8e:	855a                	mv	a0,s6
    1e90:	dc5ff0ef          	jal	1c54 <printint>
        i += 1;
    1e94:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1e96:	8bca                	mv	s7,s2
      state = 0;
    1e98:	4981                	li	s3,0
        i += 1;
    1e9a:	b575                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1e9c:	008b8913          	addi	s2,s7,8
    1ea0:	4681                	li	a3,0
    1ea2:	4629                	li	a2,10
    1ea4:	000ba583          	lw	a1,0(s7)
    1ea8:	855a                	mv	a0,s6
    1eaa:	dabff0ef          	jal	1c54 <printint>
        i += 2;
    1eae:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1eb0:	8bca                	mv	s7,s2
      state = 0;
    1eb2:	4981                	li	s3,0
        i += 2;
    1eb4:	bd49                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1eb6:	008b8913          	addi	s2,s7,8
    1eba:	4681                	li	a3,0
    1ebc:	4641                	li	a2,16
    1ebe:	000ba583          	lw	a1,0(s7)
    1ec2:	855a                	mv	a0,s6
    1ec4:	d91ff0ef          	jal	1c54 <printint>
    1ec8:	8bca                	mv	s7,s2
      state = 0;
    1eca:	4981                	li	s3,0
    1ecc:	bdad                	j	1d46 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1ece:	008b8913          	addi	s2,s7,8
    1ed2:	4681                	li	a3,0
    1ed4:	4641                	li	a2,16
    1ed6:	000ba583          	lw	a1,0(s7)
    1eda:	855a                	mv	a0,s6
    1edc:	d79ff0ef          	jal	1c54 <printint>
        i += 1;
    1ee0:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1ee2:	8bca                	mv	s7,s2
      state = 0;
    1ee4:	4981                	li	s3,0
        i += 1;
    1ee6:	b585                	j	1d46 <vprintf+0x4a>
    1ee8:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1eea:	008b8d13          	addi	s10,s7,8
    1eee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1ef2:	03000593          	li	a1,48
    1ef6:	855a                	mv	a0,s6
    1ef8:	d3fff0ef          	jal	1c36 <putc>
  putc(fd, 'x');
    1efc:	07800593          	li	a1,120
    1f00:	855a                	mv	a0,s6
    1f02:	d35ff0ef          	jal	1c36 <putc>
    1f06:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1f08:	00001b97          	auipc	s7,0x1
    1f0c:	468b8b93          	addi	s7,s7,1128 # 3370 <digits>
    1f10:	03c9d793          	srli	a5,s3,0x3c
    1f14:	97de                	add	a5,a5,s7
    1f16:	0007c583          	lbu	a1,0(a5)
    1f1a:	855a                	mv	a0,s6
    1f1c:	d1bff0ef          	jal	1c36 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1f20:	0992                	slli	s3,s3,0x4
    1f22:	397d                	addiw	s2,s2,-1
    1f24:	fe0916e3          	bnez	s2,1f10 <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1f28:	8bea                	mv	s7,s10
      state = 0;
    1f2a:	4981                	li	s3,0
    1f2c:	6d02                	ld	s10,0(sp)
    1f2e:	bd21                	j	1d46 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1f30:	008b8993          	addi	s3,s7,8
    1f34:	000bb903          	ld	s2,0(s7)
    1f38:	00090f63          	beqz	s2,1f56 <vprintf+0x25a>
        for(; *s; s++)
    1f3c:	00094583          	lbu	a1,0(s2)
    1f40:	c195                	beqz	a1,1f64 <vprintf+0x268>
          putc(fd, *s);
    1f42:	855a                	mv	a0,s6
    1f44:	cf3ff0ef          	jal	1c36 <putc>
        for(; *s; s++)
    1f48:	0905                	addi	s2,s2,1
    1f4a:	00094583          	lbu	a1,0(s2)
    1f4e:	f9f5                	bnez	a1,1f42 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1f50:	8bce                	mv	s7,s3
      state = 0;
    1f52:	4981                	li	s3,0
    1f54:	bbcd                	j	1d46 <vprintf+0x4a>
          s = "(null)";
    1f56:	00001917          	auipc	s2,0x1
    1f5a:	3b290913          	addi	s2,s2,946 # 3308 <malloc+0x12a6>
        for(; *s; s++)
    1f5e:	02800593          	li	a1,40
    1f62:	b7c5                	j	1f42 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1f64:	8bce                	mv	s7,s3
      state = 0;
    1f66:	4981                	li	s3,0
    1f68:	bbf9                	j	1d46 <vprintf+0x4a>
    1f6a:	64a6                	ld	s1,72(sp)
    1f6c:	79e2                	ld	s3,56(sp)
    1f6e:	7a42                	ld	s4,48(sp)
    1f70:	7aa2                	ld	s5,40(sp)
    1f72:	7b02                	ld	s6,32(sp)
    1f74:	6be2                	ld	s7,24(sp)
    1f76:	6c42                	ld	s8,16(sp)
    1f78:	6ca2                	ld	s9,8(sp)
    }
  }
}
    1f7a:	60e6                	ld	ra,88(sp)
    1f7c:	6446                	ld	s0,80(sp)
    1f7e:	6906                	ld	s2,64(sp)
    1f80:	6125                	addi	sp,sp,96
    1f82:	8082                	ret

0000000000001f84 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1f84:	715d                	addi	sp,sp,-80
    1f86:	ec06                	sd	ra,24(sp)
    1f88:	e822                	sd	s0,16(sp)
    1f8a:	1000                	addi	s0,sp,32
    1f8c:	e010                	sd	a2,0(s0)
    1f8e:	e414                	sd	a3,8(s0)
    1f90:	e818                	sd	a4,16(s0)
    1f92:	ec1c                	sd	a5,24(s0)
    1f94:	03043023          	sd	a6,32(s0)
    1f98:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1f9c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1fa0:	8622                	mv	a2,s0
    1fa2:	d5bff0ef          	jal	1cfc <vprintf>
}
    1fa6:	60e2                	ld	ra,24(sp)
    1fa8:	6442                	ld	s0,16(sp)
    1faa:	6161                	addi	sp,sp,80
    1fac:	8082                	ret

0000000000001fae <printf>:

void
printf(const char *fmt, ...)
{
    1fae:	711d                	addi	sp,sp,-96
    1fb0:	ec06                	sd	ra,24(sp)
    1fb2:	e822                	sd	s0,16(sp)
    1fb4:	1000                	addi	s0,sp,32
    1fb6:	e40c                	sd	a1,8(s0)
    1fb8:	e810                	sd	a2,16(s0)
    1fba:	ec14                	sd	a3,24(s0)
    1fbc:	f018                	sd	a4,32(s0)
    1fbe:	f41c                	sd	a5,40(s0)
    1fc0:	03043823          	sd	a6,48(s0)
    1fc4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1fc8:	00840613          	addi	a2,s0,8
    1fcc:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1fd0:	85aa                	mv	a1,a0
    1fd2:	4505                	li	a0,1
    1fd4:	d29ff0ef          	jal	1cfc <vprintf>
}
    1fd8:	60e2                	ld	ra,24(sp)
    1fda:	6442                	ld	s0,16(sp)
    1fdc:	6125                	addi	sp,sp,96
    1fde:	8082                	ret

0000000000001fe0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1fe0:	1141                	addi	sp,sp,-16
    1fe2:	e422                	sd	s0,8(sp)
    1fe4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1fe6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1fea:	00001797          	auipc	a5,0x1
    1fee:	3b67b783          	ld	a5,950(a5) # 33a0 <freep>
    1ff2:	a02d                	j	201c <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    1ff4:	4618                	lw	a4,8(a2)
    1ff6:	9f2d                	addw	a4,a4,a1
    1ff8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1ffc:	6398                	ld	a4,0(a5)
    1ffe:	6310                	ld	a2,0(a4)
    2000:	a83d                	j	203e <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    2002:	ff852703          	lw	a4,-8(a0)
    2006:	9f31                	addw	a4,a4,a2
    2008:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    200a:	ff053683          	ld	a3,-16(a0)
    200e:	a091                	j	2052 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2010:	6398                	ld	a4,0(a5)
    2012:	00e7e463          	bltu	a5,a4,201a <free+0x3a>
    2016:	00e6ea63          	bltu	a3,a4,202a <free+0x4a>
{
    201a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    201c:	fed7fae3          	bgeu	a5,a3,2010 <free+0x30>
    2020:	6398                	ld	a4,0(a5)
    2022:	00e6e463          	bltu	a3,a4,202a <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    2026:	fee7eae3          	bltu	a5,a4,201a <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    202a:	ff852583          	lw	a1,-8(a0)
    202e:	6390                	ld	a2,0(a5)
    2030:	02059813          	slli	a6,a1,0x20
    2034:	01c85713          	srli	a4,a6,0x1c
    2038:	9736                	add	a4,a4,a3
    203a:	fae60de3          	beq	a2,a4,1ff4 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    203e:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    2042:	4790                	lw	a2,8(a5)
    2044:	02061593          	slli	a1,a2,0x20
    2048:	01c5d713          	srli	a4,a1,0x1c
    204c:	973e                	add	a4,a4,a5
    204e:	fae68ae3          	beq	a3,a4,2002 <free+0x22>
    p->s.ptr = bp->s.ptr;
    2052:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    2054:	00001717          	auipc	a4,0x1
    2058:	34f73623          	sd	a5,844(a4) # 33a0 <freep>
}
    205c:	6422                	ld	s0,8(sp)
    205e:	0141                	addi	sp,sp,16
    2060:	8082                	ret

0000000000002062 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    2062:	7139                	addi	sp,sp,-64
    2064:	fc06                	sd	ra,56(sp)
    2066:	f822                	sd	s0,48(sp)
    2068:	f426                	sd	s1,40(sp)
    206a:	ec4e                	sd	s3,24(sp)
    206c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    206e:	02051493          	slli	s1,a0,0x20
    2072:	9081                	srli	s1,s1,0x20
    2074:	04bd                	addi	s1,s1,15
    2076:	8091                	srli	s1,s1,0x4
    2078:	0014899b          	addiw	s3,s1,1
    207c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    207e:	00001517          	auipc	a0,0x1
    2082:	32253503          	ld	a0,802(a0) # 33a0 <freep>
    2086:	c915                	beqz	a0,20ba <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2088:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    208a:	4798                	lw	a4,8(a5)
    208c:	08977a63          	bgeu	a4,s1,2120 <malloc+0xbe>
    2090:	f04a                	sd	s2,32(sp)
    2092:	e852                	sd	s4,16(sp)
    2094:	e456                	sd	s5,8(sp)
    2096:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    2098:	8a4e                	mv	s4,s3
    209a:	0009871b          	sext.w	a4,s3
    209e:	6685                	lui	a3,0x1
    20a0:	00d77363          	bgeu	a4,a3,20a6 <malloc+0x44>
    20a4:	6a05                	lui	s4,0x1
    20a6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    20aa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    20ae:	00001917          	auipc	s2,0x1
    20b2:	2f290913          	addi	s2,s2,754 # 33a0 <freep>
  if(p == (char*)-1)
    20b6:	5afd                	li	s5,-1
    20b8:	a081                	j	20f8 <malloc+0x96>
    20ba:	f04a                	sd	s2,32(sp)
    20bc:	e852                	sd	s4,16(sp)
    20be:	e456                	sd	s5,8(sp)
    20c0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    20c2:	00001797          	auipc	a5,0x1
    20c6:	6d678793          	addi	a5,a5,1750 # 3798 <base>
    20ca:	00001717          	auipc	a4,0x1
    20ce:	2cf73b23          	sd	a5,726(a4) # 33a0 <freep>
    20d2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    20d4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    20d8:	b7c1                	j	2098 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    20da:	6398                	ld	a4,0(a5)
    20dc:	e118                	sd	a4,0(a0)
    20de:	a8a9                	j	2138 <malloc+0xd6>
  hp->s.size = nu;
    20e0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    20e4:	0541                	addi	a0,a0,16
    20e6:	efbff0ef          	jal	1fe0 <free>
  return freep;
    20ea:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    20ee:	c12d                	beqz	a0,2150 <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    20f0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    20f2:	4798                	lw	a4,8(a5)
    20f4:	02977263          	bgeu	a4,s1,2118 <malloc+0xb6>
    if(p == freep)
    20f8:	00093703          	ld	a4,0(s2)
    20fc:	853e                	mv	a0,a5
    20fe:	fef719e3          	bne	a4,a5,20f0 <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    2102:	8552                	mv	a0,s4
    2104:	ad3ff0ef          	jal	1bd6 <sbrk>
  if(p == (char*)-1)
    2108:	fd551ce3          	bne	a0,s5,20e0 <malloc+0x7e>
        return 0;
    210c:	4501                	li	a0,0
    210e:	7902                	ld	s2,32(sp)
    2110:	6a42                	ld	s4,16(sp)
    2112:	6aa2                	ld	s5,8(sp)
    2114:	6b02                	ld	s6,0(sp)
    2116:	a03d                	j	2144 <malloc+0xe2>
    2118:	7902                	ld	s2,32(sp)
    211a:	6a42                	ld	s4,16(sp)
    211c:	6aa2                	ld	s5,8(sp)
    211e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    2120:	fae48de3          	beq	s1,a4,20da <malloc+0x78>
        p->s.size -= nunits;
    2124:	4137073b          	subw	a4,a4,s3
    2128:	c798                	sw	a4,8(a5)
        p += p->s.size;
    212a:	02071693          	slli	a3,a4,0x20
    212e:	01c6d713          	srli	a4,a3,0x1c
    2132:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    2134:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    2138:	00001717          	auipc	a4,0x1
    213c:	26a73423          	sd	a0,616(a4) # 33a0 <freep>
      return (void*)(p + 1);
    2140:	01078513          	addi	a0,a5,16
  }
}
    2144:	70e2                	ld	ra,56(sp)
    2146:	7442                	ld	s0,48(sp)
    2148:	74a2                	ld	s1,40(sp)
    214a:	69e2                	ld	s3,24(sp)
    214c:	6121                	addi	sp,sp,64
    214e:	8082                	ret
    2150:	7902                	ld	s2,32(sp)
    2152:	6a42                	ld	s4,16(sp)
    2154:	6aa2                	ld	s5,8(sp)
    2156:	6b02                	ld	s6,0(sp)
    2158:	b7f5                	j	2144 <malloc+0xe2>
	...
