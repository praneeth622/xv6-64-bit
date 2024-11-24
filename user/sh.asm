
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000001000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
    1000:	1101                	addi	sp,sp,-32
    1002:	ec06                	sd	ra,24(sp)
    1004:	e822                	sd	s0,16(sp)
    1006:	e426                	sd	s1,8(sp)
    1008:	e04a                	sd	s2,0(sp)
    100a:	1000                	addi	s0,sp,32
    100c:	84aa                	mv	s1,a0
    100e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
    1010:	4609                	li	a2,2
    1012:	00002597          	auipc	a1,0x2
    1016:	fee58593          	addi	a1,a1,-18 # 3000 <malloc+0xef0>
    101a:	4509                	li	a0,2
    101c:	401000ef          	jal	1c1c <write>
  memset(buf, 0, nbuf);
    1020:	864a                	mv	a2,s2
    1022:	4581                	li	a1,0
    1024:	8526                	mv	a0,s1
    1026:	1f1000ef          	jal	1a16 <memset>
  gets(buf, nbuf);
    102a:	85ca                	mv	a1,s2
    102c:	8526                	mv	a0,s1
    102e:	22f000ef          	jal	1a5c <gets>
  if(buf[0] == 0) // EOF
    1032:	0004c503          	lbu	a0,0(s1)
    1036:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
    103a:	40a00533          	neg	a0,a0
    103e:	60e2                	ld	ra,24(sp)
    1040:	6442                	ld	s0,16(sp)
    1042:	64a2                	ld	s1,8(sp)
    1044:	6902                	ld	s2,0(sp)
    1046:	6105                	addi	sp,sp,32
    1048:	8082                	ret

000000000000104a <panic>:
  exit(0);
}

void
panic(char *s)
{
    104a:	1141                	addi	sp,sp,-16
    104c:	e406                	sd	ra,8(sp)
    104e:	e022                	sd	s0,0(sp)
    1050:	0800                	addi	s0,sp,16
    1052:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
    1054:	00002597          	auipc	a1,0x2
    1058:	fbc58593          	addi	a1,a1,-68 # 3010 <malloc+0xf00>
    105c:	4509                	li	a0,2
    105e:	7d5000ef          	jal	2032 <fprintf>
  exit(1);
    1062:	4505                	li	a0,1
    1064:	399000ef          	jal	1bfc <exit>

0000000000001068 <fork1>:
}

int
fork1(void)
{
    1068:	1141                	addi	sp,sp,-16
    106a:	e406                	sd	ra,8(sp)
    106c:	e022                	sd	s0,0(sp)
    106e:	0800                	addi	s0,sp,16
  int pid;

  pid = fork();
    1070:	385000ef          	jal	1bf4 <fork>
  if(pid == -1)
    1074:	57fd                	li	a5,-1
    1076:	00f50663          	beq	a0,a5,1082 <fork1+0x1a>
    panic("fork");
  return pid;
}
    107a:	60a2                	ld	ra,8(sp)
    107c:	6402                	ld	s0,0(sp)
    107e:	0141                	addi	sp,sp,16
    1080:	8082                	ret
    panic("fork");
    1082:	00002517          	auipc	a0,0x2
    1086:	f9650513          	addi	a0,a0,-106 # 3018 <malloc+0xf08>
    108a:	fc1ff0ef          	jal	104a <panic>

000000000000108e <runcmd>:
{
    108e:	7179                	addi	sp,sp,-48
    1090:	f406                	sd	ra,40(sp)
    1092:	f022                	sd	s0,32(sp)
    1094:	1800                	addi	s0,sp,48
  if(cmd == 0)
    1096:	c115                	beqz	a0,10ba <runcmd+0x2c>
    1098:	ec26                	sd	s1,24(sp)
    109a:	84aa                	mv	s1,a0
  switch(cmd->type){
    109c:	4118                	lw	a4,0(a0)
    109e:	4795                	li	a5,5
    10a0:	02e7e163          	bltu	a5,a4,10c2 <runcmd+0x34>
    10a4:	00056783          	lwu	a5,0(a0)
    10a8:	078a                	slli	a5,a5,0x2
    10aa:	00002717          	auipc	a4,0x2
    10ae:	06e70713          	addi	a4,a4,110 # 3118 <malloc+0x1008>
    10b2:	97ba                	add	a5,a5,a4
    10b4:	439c                	lw	a5,0(a5)
    10b6:	97ba                	add	a5,a5,a4
    10b8:	8782                	jr	a5
    10ba:	ec26                	sd	s1,24(sp)
    exit(1);
    10bc:	4505                	li	a0,1
    10be:	33f000ef          	jal	1bfc <exit>
    panic("runcmd");
    10c2:	00002517          	auipc	a0,0x2
    10c6:	f5e50513          	addi	a0,a0,-162 # 3020 <malloc+0xf10>
    10ca:	f81ff0ef          	jal	104a <panic>
    if(ecmd->argv[0] == 0)
    10ce:	6508                	ld	a0,8(a0)
    10d0:	c105                	beqz	a0,10f0 <runcmd+0x62>
    exec(ecmd->argv[0], ecmd->argv);
    10d2:	00848593          	addi	a1,s1,8
    10d6:	35f000ef          	jal	1c34 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
    10da:	6490                	ld	a2,8(s1)
    10dc:	00002597          	auipc	a1,0x2
    10e0:	f4c58593          	addi	a1,a1,-180 # 3028 <malloc+0xf18>
    10e4:	4509                	li	a0,2
    10e6:	74d000ef          	jal	2032 <fprintf>
  exit(0);
    10ea:	4501                	li	a0,0
    10ec:	311000ef          	jal	1bfc <exit>
      exit(1);
    10f0:	4505                	li	a0,1
    10f2:	30b000ef          	jal	1bfc <exit>
    close(rcmd->fd);
    10f6:	5148                	lw	a0,36(a0)
    10f8:	32d000ef          	jal	1c24 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
    10fc:	508c                	lw	a1,32(s1)
    10fe:	6888                	ld	a0,16(s1)
    1100:	33d000ef          	jal	1c3c <open>
    1104:	00054563          	bltz	a0,110e <runcmd+0x80>
    runcmd(rcmd->cmd);
    1108:	6488                	ld	a0,8(s1)
    110a:	f85ff0ef          	jal	108e <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
    110e:	6890                	ld	a2,16(s1)
    1110:	00002597          	auipc	a1,0x2
    1114:	f2858593          	addi	a1,a1,-216 # 3038 <malloc+0xf28>
    1118:	4509                	li	a0,2
    111a:	719000ef          	jal	2032 <fprintf>
      exit(1);
    111e:	4505                	li	a0,1
    1120:	2dd000ef          	jal	1bfc <exit>
    if(fork1() == 0)
    1124:	f45ff0ef          	jal	1068 <fork1>
    1128:	e501                	bnez	a0,1130 <runcmd+0xa2>
      runcmd(lcmd->left);
    112a:	6488                	ld	a0,8(s1)
    112c:	f63ff0ef          	jal	108e <runcmd>
    wait(0);
    1130:	4501                	li	a0,0
    1132:	2d3000ef          	jal	1c04 <wait>
    runcmd(lcmd->right);
    1136:	6888                	ld	a0,16(s1)
    1138:	f57ff0ef          	jal	108e <runcmd>
    if(pipe(p) < 0)
    113c:	fd840513          	addi	a0,s0,-40
    1140:	2cd000ef          	jal	1c0c <pipe>
    1144:	02054763          	bltz	a0,1172 <runcmd+0xe4>
    if(fork1() == 0){
    1148:	f21ff0ef          	jal	1068 <fork1>
    114c:	e90d                	bnez	a0,117e <runcmd+0xf0>
      close(1);
    114e:	4505                	li	a0,1
    1150:	2d5000ef          	jal	1c24 <close>
      dup(p[1]);
    1154:	fdc42503          	lw	a0,-36(s0)
    1158:	31d000ef          	jal	1c74 <dup>
      close(p[0]);
    115c:	fd842503          	lw	a0,-40(s0)
    1160:	2c5000ef          	jal	1c24 <close>
      close(p[1]);
    1164:	fdc42503          	lw	a0,-36(s0)
    1168:	2bd000ef          	jal	1c24 <close>
      runcmd(pcmd->left);
    116c:	6488                	ld	a0,8(s1)
    116e:	f21ff0ef          	jal	108e <runcmd>
      panic("pipe");
    1172:	00002517          	auipc	a0,0x2
    1176:	ed650513          	addi	a0,a0,-298 # 3048 <malloc+0xf38>
    117a:	ed1ff0ef          	jal	104a <panic>
    if(fork1() == 0){
    117e:	eebff0ef          	jal	1068 <fork1>
    1182:	e115                	bnez	a0,11a6 <runcmd+0x118>
      close(0);
    1184:	2a1000ef          	jal	1c24 <close>
      dup(p[0]);
    1188:	fd842503          	lw	a0,-40(s0)
    118c:	2e9000ef          	jal	1c74 <dup>
      close(p[0]);
    1190:	fd842503          	lw	a0,-40(s0)
    1194:	291000ef          	jal	1c24 <close>
      close(p[1]);
    1198:	fdc42503          	lw	a0,-36(s0)
    119c:	289000ef          	jal	1c24 <close>
      runcmd(pcmd->right);
    11a0:	6888                	ld	a0,16(s1)
    11a2:	eedff0ef          	jal	108e <runcmd>
    close(p[0]);
    11a6:	fd842503          	lw	a0,-40(s0)
    11aa:	27b000ef          	jal	1c24 <close>
    close(p[1]);
    11ae:	fdc42503          	lw	a0,-36(s0)
    11b2:	273000ef          	jal	1c24 <close>
    wait(0);
    11b6:	4501                	li	a0,0
    11b8:	24d000ef          	jal	1c04 <wait>
    wait(0);
    11bc:	4501                	li	a0,0
    11be:	247000ef          	jal	1c04 <wait>
    break;
    11c2:	b725                	j	10ea <runcmd+0x5c>
    if(fork1() == 0)
    11c4:	ea5ff0ef          	jal	1068 <fork1>
    11c8:	f20511e3          	bnez	a0,10ea <runcmd+0x5c>
      runcmd(bcmd->cmd);
    11cc:	6488                	ld	a0,8(s1)
    11ce:	ec1ff0ef          	jal	108e <runcmd>

00000000000011d2 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
    11d2:	1101                	addi	sp,sp,-32
    11d4:	ec06                	sd	ra,24(sp)
    11d6:	e822                	sd	s0,16(sp)
    11d8:	e426                	sd	s1,8(sp)
    11da:	1000                	addi	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    11dc:	0a800513          	li	a0,168
    11e0:	731000ef          	jal	2110 <malloc>
    11e4:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    11e6:	0a800613          	li	a2,168
    11ea:	4581                	li	a1,0
    11ec:	02b000ef          	jal	1a16 <memset>
  cmd->type = EXEC;
    11f0:	4785                	li	a5,1
    11f2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
    11f4:	8526                	mv	a0,s1
    11f6:	60e2                	ld	ra,24(sp)
    11f8:	6442                	ld	s0,16(sp)
    11fa:	64a2                	ld	s1,8(sp)
    11fc:	6105                	addi	sp,sp,32
    11fe:	8082                	ret

0000000000001200 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
    1200:	7139                	addi	sp,sp,-64
    1202:	fc06                	sd	ra,56(sp)
    1204:	f822                	sd	s0,48(sp)
    1206:	f426                	sd	s1,40(sp)
    1208:	f04a                	sd	s2,32(sp)
    120a:	ec4e                	sd	s3,24(sp)
    120c:	e852                	sd	s4,16(sp)
    120e:	e456                	sd	s5,8(sp)
    1210:	e05a                	sd	s6,0(sp)
    1212:	0080                	addi	s0,sp,64
    1214:	8b2a                	mv	s6,a0
    1216:	8aae                	mv	s5,a1
    1218:	8a32                	mv	s4,a2
    121a:	89b6                	mv	s3,a3
    121c:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
    121e:	02800513          	li	a0,40
    1222:	6ef000ef          	jal	2110 <malloc>
    1226:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    1228:	02800613          	li	a2,40
    122c:	4581                	li	a1,0
    122e:	7e8000ef          	jal	1a16 <memset>
  cmd->type = REDIR;
    1232:	4789                	li	a5,2
    1234:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
    1236:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
    123a:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
    123e:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
    1242:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
    1246:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
    124a:	8526                	mv	a0,s1
    124c:	70e2                	ld	ra,56(sp)
    124e:	7442                	ld	s0,48(sp)
    1250:	74a2                	ld	s1,40(sp)
    1252:	7902                	ld	s2,32(sp)
    1254:	69e2                	ld	s3,24(sp)
    1256:	6a42                	ld	s4,16(sp)
    1258:	6aa2                	ld	s5,8(sp)
    125a:	6b02                	ld	s6,0(sp)
    125c:	6121                	addi	sp,sp,64
    125e:	8082                	ret

0000000000001260 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
    1260:	7179                	addi	sp,sp,-48
    1262:	f406                	sd	ra,40(sp)
    1264:	f022                	sd	s0,32(sp)
    1266:	ec26                	sd	s1,24(sp)
    1268:	e84a                	sd	s2,16(sp)
    126a:	e44e                	sd	s3,8(sp)
    126c:	1800                	addi	s0,sp,48
    126e:	89aa                	mv	s3,a0
    1270:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
    1272:	4561                	li	a0,24
    1274:	69d000ef          	jal	2110 <malloc>
    1278:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    127a:	4661                	li	a2,24
    127c:	4581                	li	a1,0
    127e:	798000ef          	jal	1a16 <memset>
  cmd->type = PIPE;
    1282:	478d                	li	a5,3
    1284:	c09c                	sw	a5,0(s1)
  cmd->left = left;
    1286:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
    128a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
    128e:	8526                	mv	a0,s1
    1290:	70a2                	ld	ra,40(sp)
    1292:	7402                	ld	s0,32(sp)
    1294:	64e2                	ld	s1,24(sp)
    1296:	6942                	ld	s2,16(sp)
    1298:	69a2                	ld	s3,8(sp)
    129a:	6145                	addi	sp,sp,48
    129c:	8082                	ret

000000000000129e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
    129e:	7179                	addi	sp,sp,-48
    12a0:	f406                	sd	ra,40(sp)
    12a2:	f022                	sd	s0,32(sp)
    12a4:	ec26                	sd	s1,24(sp)
    12a6:	e84a                	sd	s2,16(sp)
    12a8:	e44e                	sd	s3,8(sp)
    12aa:	1800                	addi	s0,sp,48
    12ac:	89aa                	mv	s3,a0
    12ae:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    12b0:	4561                	li	a0,24
    12b2:	65f000ef          	jal	2110 <malloc>
    12b6:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    12b8:	4661                	li	a2,24
    12ba:	4581                	li	a1,0
    12bc:	75a000ef          	jal	1a16 <memset>
  cmd->type = LIST;
    12c0:	4791                	li	a5,4
    12c2:	c09c                	sw	a5,0(s1)
  cmd->left = left;
    12c4:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
    12c8:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
    12cc:	8526                	mv	a0,s1
    12ce:	70a2                	ld	ra,40(sp)
    12d0:	7402                	ld	s0,32(sp)
    12d2:	64e2                	ld	s1,24(sp)
    12d4:	6942                	ld	s2,16(sp)
    12d6:	69a2                	ld	s3,8(sp)
    12d8:	6145                	addi	sp,sp,48
    12da:	8082                	ret

00000000000012dc <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
    12dc:	1101                	addi	sp,sp,-32
    12de:	ec06                	sd	ra,24(sp)
    12e0:	e822                	sd	s0,16(sp)
    12e2:	e426                	sd	s1,8(sp)
    12e4:	e04a                	sd	s2,0(sp)
    12e6:	1000                	addi	s0,sp,32
    12e8:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
    12ea:	4541                	li	a0,16
    12ec:	625000ef          	jal	2110 <malloc>
    12f0:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
    12f2:	4641                	li	a2,16
    12f4:	4581                	li	a1,0
    12f6:	720000ef          	jal	1a16 <memset>
  cmd->type = BACK;
    12fa:	4795                	li	a5,5
    12fc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
    12fe:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
    1302:	8526                	mv	a0,s1
    1304:	60e2                	ld	ra,24(sp)
    1306:	6442                	ld	s0,16(sp)
    1308:	64a2                	ld	s1,8(sp)
    130a:	6902                	ld	s2,0(sp)
    130c:	6105                	addi	sp,sp,32
    130e:	8082                	ret

0000000000001310 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
    1310:	7139                	addi	sp,sp,-64
    1312:	fc06                	sd	ra,56(sp)
    1314:	f822                	sd	s0,48(sp)
    1316:	f426                	sd	s1,40(sp)
    1318:	f04a                	sd	s2,32(sp)
    131a:	ec4e                	sd	s3,24(sp)
    131c:	e852                	sd	s4,16(sp)
    131e:	e456                	sd	s5,8(sp)
    1320:	e05a                	sd	s6,0(sp)
    1322:	0080                	addi	s0,sp,64
    1324:	8a2a                	mv	s4,a0
    1326:	892e                	mv	s2,a1
    1328:	8ab2                	mv	s5,a2
    132a:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
    132c:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
    132e:	00002997          	auipc	s3,0x2
    1332:	e3a98993          	addi	s3,s3,-454 # 3168 <whitespace>
    1336:	00b4fc63          	bgeu	s1,a1,134e <gettoken+0x3e>
    133a:	0004c583          	lbu	a1,0(s1)
    133e:	854e                	mv	a0,s3
    1340:	6f8000ef          	jal	1a38 <strchr>
    1344:	c509                	beqz	a0,134e <gettoken+0x3e>
    s++;
    1346:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
    1348:	fe9919e3          	bne	s2,s1,133a <gettoken+0x2a>
    134c:	84ca                	mv	s1,s2
  if(q)
    134e:	000a8463          	beqz	s5,1356 <gettoken+0x46>
    *q = s;
    1352:	009ab023          	sd	s1,0(s5)
  ret = *s;
    1356:	0004c783          	lbu	a5,0(s1)
    135a:	00078a9b          	sext.w	s5,a5
  switch(*s){
    135e:	03c00713          	li	a4,60
    1362:	06f76463          	bltu	a4,a5,13ca <gettoken+0xba>
    1366:	03a00713          	li	a4,58
    136a:	00f76e63          	bltu	a4,a5,1386 <gettoken+0x76>
    136e:	cf89                	beqz	a5,1388 <gettoken+0x78>
    1370:	02600713          	li	a4,38
    1374:	00e78963          	beq	a5,a4,1386 <gettoken+0x76>
    1378:	fd87879b          	addiw	a5,a5,-40
    137c:	0ff7f793          	zext.b	a5,a5
    1380:	4705                	li	a4,1
    1382:	06f76b63          	bltu	a4,a5,13f8 <gettoken+0xe8>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
    1386:	0485                	addi	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
    1388:	000b0463          	beqz	s6,1390 <gettoken+0x80>
    *eq = s;
    138c:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
    1390:	00002997          	auipc	s3,0x2
    1394:	dd898993          	addi	s3,s3,-552 # 3168 <whitespace>
    1398:	0124fc63          	bgeu	s1,s2,13b0 <gettoken+0xa0>
    139c:	0004c583          	lbu	a1,0(s1)
    13a0:	854e                	mv	a0,s3
    13a2:	696000ef          	jal	1a38 <strchr>
    13a6:	c509                	beqz	a0,13b0 <gettoken+0xa0>
    s++;
    13a8:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
    13aa:	fe9919e3          	bne	s2,s1,139c <gettoken+0x8c>
    13ae:	84ca                	mv	s1,s2
  *ps = s;
    13b0:	009a3023          	sd	s1,0(s4)
  return ret;
}
    13b4:	8556                	mv	a0,s5
    13b6:	70e2                	ld	ra,56(sp)
    13b8:	7442                	ld	s0,48(sp)
    13ba:	74a2                	ld	s1,40(sp)
    13bc:	7902                	ld	s2,32(sp)
    13be:	69e2                	ld	s3,24(sp)
    13c0:	6a42                	ld	s4,16(sp)
    13c2:	6aa2                	ld	s5,8(sp)
    13c4:	6b02                	ld	s6,0(sp)
    13c6:	6121                	addi	sp,sp,64
    13c8:	8082                	ret
  switch(*s){
    13ca:	03e00713          	li	a4,62
    13ce:	02e79163          	bne	a5,a4,13f0 <gettoken+0xe0>
    s++;
    13d2:	00148693          	addi	a3,s1,1
    if(*s == '>'){
    13d6:	0014c703          	lbu	a4,1(s1)
    13da:	03e00793          	li	a5,62
      s++;
    13de:	0489                	addi	s1,s1,2
      ret = '+';
    13e0:	02b00a93          	li	s5,43
    if(*s == '>'){
    13e4:	faf702e3          	beq	a4,a5,1388 <gettoken+0x78>
    s++;
    13e8:	84b6                	mv	s1,a3
  ret = *s;
    13ea:	03e00a93          	li	s5,62
    13ee:	bf69                	j	1388 <gettoken+0x78>
  switch(*s){
    13f0:	07c00713          	li	a4,124
    13f4:	f8e789e3          	beq	a5,a4,1386 <gettoken+0x76>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    13f8:	00002997          	auipc	s3,0x2
    13fc:	d7098993          	addi	s3,s3,-656 # 3168 <whitespace>
    1400:	00002a97          	auipc	s5,0x2
    1404:	d60a8a93          	addi	s5,s5,-672 # 3160 <symbols>
    1408:	0324fd63          	bgeu	s1,s2,1442 <gettoken+0x132>
    140c:	0004c583          	lbu	a1,0(s1)
    1410:	854e                	mv	a0,s3
    1412:	626000ef          	jal	1a38 <strchr>
    1416:	e11d                	bnez	a0,143c <gettoken+0x12c>
    1418:	0004c583          	lbu	a1,0(s1)
    141c:	8556                	mv	a0,s5
    141e:	61a000ef          	jal	1a38 <strchr>
    1422:	e911                	bnez	a0,1436 <gettoken+0x126>
      s++;
    1424:	0485                	addi	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
    1426:	fe9913e3          	bne	s2,s1,140c <gettoken+0xfc>
  if(eq)
    142a:	84ca                	mv	s1,s2
    ret = 'a';
    142c:	06100a93          	li	s5,97
  if(eq)
    1430:	f40b1ee3          	bnez	s6,138c <gettoken+0x7c>
    1434:	bfb5                	j	13b0 <gettoken+0xa0>
    ret = 'a';
    1436:	06100a93          	li	s5,97
    143a:	b7b9                	j	1388 <gettoken+0x78>
    143c:	06100a93          	li	s5,97
    1440:	b7a1                	j	1388 <gettoken+0x78>
    1442:	06100a93          	li	s5,97
  if(eq)
    1446:	f40b13e3          	bnez	s6,138c <gettoken+0x7c>
    144a:	b79d                	j	13b0 <gettoken+0xa0>

000000000000144c <peek>:

int
peek(char **ps, char *es, char *toks)
{
    144c:	7139                	addi	sp,sp,-64
    144e:	fc06                	sd	ra,56(sp)
    1450:	f822                	sd	s0,48(sp)
    1452:	f426                	sd	s1,40(sp)
    1454:	f04a                	sd	s2,32(sp)
    1456:	ec4e                	sd	s3,24(sp)
    1458:	e852                	sd	s4,16(sp)
    145a:	e456                	sd	s5,8(sp)
    145c:	0080                	addi	s0,sp,64
    145e:	8a2a                	mv	s4,a0
    1460:	892e                	mv	s2,a1
    1462:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
    1464:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
    1466:	00002997          	auipc	s3,0x2
    146a:	d0298993          	addi	s3,s3,-766 # 3168 <whitespace>
    146e:	00b4fc63          	bgeu	s1,a1,1486 <peek+0x3a>
    1472:	0004c583          	lbu	a1,0(s1)
    1476:	854e                	mv	a0,s3
    1478:	5c0000ef          	jal	1a38 <strchr>
    147c:	c509                	beqz	a0,1486 <peek+0x3a>
    s++;
    147e:	0485                	addi	s1,s1,1
  while(s < es && strchr(whitespace, *s))
    1480:	fe9919e3          	bne	s2,s1,1472 <peek+0x26>
    1484:	84ca                	mv	s1,s2
  *ps = s;
    1486:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
    148a:	0004c583          	lbu	a1,0(s1)
    148e:	4501                	li	a0,0
    1490:	e991                	bnez	a1,14a4 <peek+0x58>
}
    1492:	70e2                	ld	ra,56(sp)
    1494:	7442                	ld	s0,48(sp)
    1496:	74a2                	ld	s1,40(sp)
    1498:	7902                	ld	s2,32(sp)
    149a:	69e2                	ld	s3,24(sp)
    149c:	6a42                	ld	s4,16(sp)
    149e:	6aa2                	ld	s5,8(sp)
    14a0:	6121                	addi	sp,sp,64
    14a2:	8082                	ret
  return *s && strchr(toks, *s);
    14a4:	8556                	mv	a0,s5
    14a6:	592000ef          	jal	1a38 <strchr>
    14aa:	00a03533          	snez	a0,a0
    14ae:	b7d5                	j	1492 <peek+0x46>

00000000000014b0 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
    14b0:	711d                	addi	sp,sp,-96
    14b2:	ec86                	sd	ra,88(sp)
    14b4:	e8a2                	sd	s0,80(sp)
    14b6:	e4a6                	sd	s1,72(sp)
    14b8:	e0ca                	sd	s2,64(sp)
    14ba:	fc4e                	sd	s3,56(sp)
    14bc:	f852                	sd	s4,48(sp)
    14be:	f456                	sd	s5,40(sp)
    14c0:	f05a                	sd	s6,32(sp)
    14c2:	ec5e                	sd	s7,24(sp)
    14c4:	1080                	addi	s0,sp,96
    14c6:	8a2a                	mv	s4,a0
    14c8:	89ae                	mv	s3,a1
    14ca:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
    14cc:	00002a97          	auipc	s5,0x2
    14d0:	ba4a8a93          	addi	s5,s5,-1116 # 3070 <malloc+0xf60>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
    14d4:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
    14d8:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
    14dc:	a00d                	j	14fe <parseredirs+0x4e>
      panic("missing file for redirection");
    14de:	00002517          	auipc	a0,0x2
    14e2:	b7250513          	addi	a0,a0,-1166 # 3050 <malloc+0xf40>
    14e6:	b65ff0ef          	jal	104a <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
    14ea:	4701                	li	a4,0
    14ec:	4681                	li	a3,0
    14ee:	fa043603          	ld	a2,-96(s0)
    14f2:	fa843583          	ld	a1,-88(s0)
    14f6:	8552                	mv	a0,s4
    14f8:	d09ff0ef          	jal	1200 <redircmd>
    14fc:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
    14fe:	8656                	mv	a2,s5
    1500:	85ca                	mv	a1,s2
    1502:	854e                	mv	a0,s3
    1504:	f49ff0ef          	jal	144c <peek>
    1508:	c525                	beqz	a0,1570 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
    150a:	4681                	li	a3,0
    150c:	4601                	li	a2,0
    150e:	85ca                	mv	a1,s2
    1510:	854e                	mv	a0,s3
    1512:	dffff0ef          	jal	1310 <gettoken>
    1516:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
    1518:	fa040693          	addi	a3,s0,-96
    151c:	fa840613          	addi	a2,s0,-88
    1520:	85ca                	mv	a1,s2
    1522:	854e                	mv	a0,s3
    1524:	dedff0ef          	jal	1310 <gettoken>
    1528:	fb651be3          	bne	a0,s6,14de <parseredirs+0x2e>
    switch(tok){
    152c:	fb748fe3          	beq	s1,s7,14ea <parseredirs+0x3a>
    1530:	03e00793          	li	a5,62
    1534:	02f48263          	beq	s1,a5,1558 <parseredirs+0xa8>
    1538:	02b00793          	li	a5,43
    153c:	fcf491e3          	bne	s1,a5,14fe <parseredirs+0x4e>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
    1540:	4705                	li	a4,1
    1542:	20100693          	li	a3,513
    1546:	fa043603          	ld	a2,-96(s0)
    154a:	fa843583          	ld	a1,-88(s0)
    154e:	8552                	mv	a0,s4
    1550:	cb1ff0ef          	jal	1200 <redircmd>
    1554:	8a2a                	mv	s4,a0
      break;
    1556:	b765                	j	14fe <parseredirs+0x4e>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
    1558:	4705                	li	a4,1
    155a:	60100693          	li	a3,1537
    155e:	fa043603          	ld	a2,-96(s0)
    1562:	fa843583          	ld	a1,-88(s0)
    1566:	8552                	mv	a0,s4
    1568:	c99ff0ef          	jal	1200 <redircmd>
    156c:	8a2a                	mv	s4,a0
      break;
    156e:	bf41                	j	14fe <parseredirs+0x4e>
    }
  }
  return cmd;
}
    1570:	8552                	mv	a0,s4
    1572:	60e6                	ld	ra,88(sp)
    1574:	6446                	ld	s0,80(sp)
    1576:	64a6                	ld	s1,72(sp)
    1578:	6906                	ld	s2,64(sp)
    157a:	79e2                	ld	s3,56(sp)
    157c:	7a42                	ld	s4,48(sp)
    157e:	7aa2                	ld	s5,40(sp)
    1580:	7b02                	ld	s6,32(sp)
    1582:	6be2                	ld	s7,24(sp)
    1584:	6125                	addi	sp,sp,96
    1586:	8082                	ret

0000000000001588 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
    1588:	7159                	addi	sp,sp,-112
    158a:	f486                	sd	ra,104(sp)
    158c:	f0a2                	sd	s0,96(sp)
    158e:	eca6                	sd	s1,88(sp)
    1590:	e0d2                	sd	s4,64(sp)
    1592:	fc56                	sd	s5,56(sp)
    1594:	1880                	addi	s0,sp,112
    1596:	8a2a                	mv	s4,a0
    1598:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
    159a:	00002617          	auipc	a2,0x2
    159e:	ade60613          	addi	a2,a2,-1314 # 3078 <malloc+0xf68>
    15a2:	eabff0ef          	jal	144c <peek>
    15a6:	e915                	bnez	a0,15da <parseexec+0x52>
    15a8:	e8ca                	sd	s2,80(sp)
    15aa:	e4ce                	sd	s3,72(sp)
    15ac:	f85a                	sd	s6,48(sp)
    15ae:	f45e                	sd	s7,40(sp)
    15b0:	f062                	sd	s8,32(sp)
    15b2:	ec66                	sd	s9,24(sp)
    15b4:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
    15b6:	c1dff0ef          	jal	11d2 <execcmd>
    15ba:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
    15bc:	8656                	mv	a2,s5
    15be:	85d2                	mv	a1,s4
    15c0:	ef1ff0ef          	jal	14b0 <parseredirs>
    15c4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
    15c6:	008c0913          	addi	s2,s8,8
    15ca:	00002b17          	auipc	s6,0x2
    15ce:	aceb0b13          	addi	s6,s6,-1330 # 3098 <malloc+0xf88>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
    15d2:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
    15d6:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
    15d8:	a815                	j	160c <parseexec+0x84>
    return parseblock(ps, es);
    15da:	85d6                	mv	a1,s5
    15dc:	8552                	mv	a0,s4
    15de:	170000ef          	jal	174e <parseblock>
    15e2:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
    15e4:	8526                	mv	a0,s1
    15e6:	70a6                	ld	ra,104(sp)
    15e8:	7406                	ld	s0,96(sp)
    15ea:	64e6                	ld	s1,88(sp)
    15ec:	6a06                	ld	s4,64(sp)
    15ee:	7ae2                	ld	s5,56(sp)
    15f0:	6165                	addi	sp,sp,112
    15f2:	8082                	ret
      panic("syntax");
    15f4:	00002517          	auipc	a0,0x2
    15f8:	a8c50513          	addi	a0,a0,-1396 # 3080 <malloc+0xf70>
    15fc:	a4fff0ef          	jal	104a <panic>
    ret = parseredirs(ret, ps, es);
    1600:	8656                	mv	a2,s5
    1602:	85d2                	mv	a1,s4
    1604:	8526                	mv	a0,s1
    1606:	eabff0ef          	jal	14b0 <parseredirs>
    160a:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
    160c:	865a                	mv	a2,s6
    160e:	85d6                	mv	a1,s5
    1610:	8552                	mv	a0,s4
    1612:	e3bff0ef          	jal	144c <peek>
    1616:	ed15                	bnez	a0,1652 <parseexec+0xca>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
    1618:	f9040693          	addi	a3,s0,-112
    161c:	f9840613          	addi	a2,s0,-104
    1620:	85d6                	mv	a1,s5
    1622:	8552                	mv	a0,s4
    1624:	cedff0ef          	jal	1310 <gettoken>
    1628:	c50d                	beqz	a0,1652 <parseexec+0xca>
    if(tok != 'a')
    162a:	fd9515e3          	bne	a0,s9,15f4 <parseexec+0x6c>
    cmd->argv[argc] = q;
    162e:	f9843783          	ld	a5,-104(s0)
    1632:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
    1636:	f9043783          	ld	a5,-112(s0)
    163a:	04f93823          	sd	a5,80(s2)
    argc++;
    163e:	2985                	addiw	s3,s3,1
    if(argc >= MAXARGS)
    1640:	0921                	addi	s2,s2,8
    1642:	fb799fe3          	bne	s3,s7,1600 <parseexec+0x78>
      panic("too many args");
    1646:	00002517          	auipc	a0,0x2
    164a:	a4250513          	addi	a0,a0,-1470 # 3088 <malloc+0xf78>
    164e:	9fdff0ef          	jal	104a <panic>
  cmd->argv[argc] = 0;
    1652:	098e                	slli	s3,s3,0x3
    1654:	9c4e                	add	s8,s8,s3
    1656:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
    165a:	040c3c23          	sd	zero,88(s8)
    165e:	6946                	ld	s2,80(sp)
    1660:	69a6                	ld	s3,72(sp)
    1662:	7b42                	ld	s6,48(sp)
    1664:	7ba2                	ld	s7,40(sp)
    1666:	7c02                	ld	s8,32(sp)
    1668:	6ce2                	ld	s9,24(sp)
  return ret;
    166a:	bfad                	j	15e4 <parseexec+0x5c>

000000000000166c <parsepipe>:
{
    166c:	7179                	addi	sp,sp,-48
    166e:	f406                	sd	ra,40(sp)
    1670:	f022                	sd	s0,32(sp)
    1672:	ec26                	sd	s1,24(sp)
    1674:	e84a                	sd	s2,16(sp)
    1676:	e44e                	sd	s3,8(sp)
    1678:	1800                	addi	s0,sp,48
    167a:	892a                	mv	s2,a0
    167c:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
    167e:	f0bff0ef          	jal	1588 <parseexec>
    1682:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
    1684:	00002617          	auipc	a2,0x2
    1688:	a1c60613          	addi	a2,a2,-1508 # 30a0 <malloc+0xf90>
    168c:	85ce                	mv	a1,s3
    168e:	854a                	mv	a0,s2
    1690:	dbdff0ef          	jal	144c <peek>
    1694:	e909                	bnez	a0,16a6 <parsepipe+0x3a>
}
    1696:	8526                	mv	a0,s1
    1698:	70a2                	ld	ra,40(sp)
    169a:	7402                	ld	s0,32(sp)
    169c:	64e2                	ld	s1,24(sp)
    169e:	6942                	ld	s2,16(sp)
    16a0:	69a2                	ld	s3,8(sp)
    16a2:	6145                	addi	sp,sp,48
    16a4:	8082                	ret
    gettoken(ps, es, 0, 0);
    16a6:	4681                	li	a3,0
    16a8:	4601                	li	a2,0
    16aa:	85ce                	mv	a1,s3
    16ac:	854a                	mv	a0,s2
    16ae:	c63ff0ef          	jal	1310 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
    16b2:	85ce                	mv	a1,s3
    16b4:	854a                	mv	a0,s2
    16b6:	fb7ff0ef          	jal	166c <parsepipe>
    16ba:	85aa                	mv	a1,a0
    16bc:	8526                	mv	a0,s1
    16be:	ba3ff0ef          	jal	1260 <pipecmd>
    16c2:	84aa                	mv	s1,a0
  return cmd;
    16c4:	bfc9                	j	1696 <parsepipe+0x2a>

00000000000016c6 <parseline>:
{
    16c6:	7179                	addi	sp,sp,-48
    16c8:	f406                	sd	ra,40(sp)
    16ca:	f022                	sd	s0,32(sp)
    16cc:	ec26                	sd	s1,24(sp)
    16ce:	e84a                	sd	s2,16(sp)
    16d0:	e44e                	sd	s3,8(sp)
    16d2:	e052                	sd	s4,0(sp)
    16d4:	1800                	addi	s0,sp,48
    16d6:	892a                	mv	s2,a0
    16d8:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
    16da:	f93ff0ef          	jal	166c <parsepipe>
    16de:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
    16e0:	00002a17          	auipc	s4,0x2
    16e4:	9c8a0a13          	addi	s4,s4,-1592 # 30a8 <malloc+0xf98>
    16e8:	a819                	j	16fe <parseline+0x38>
    gettoken(ps, es, 0, 0);
    16ea:	4681                	li	a3,0
    16ec:	4601                	li	a2,0
    16ee:	85ce                	mv	a1,s3
    16f0:	854a                	mv	a0,s2
    16f2:	c1fff0ef          	jal	1310 <gettoken>
    cmd = backcmd(cmd);
    16f6:	8526                	mv	a0,s1
    16f8:	be5ff0ef          	jal	12dc <backcmd>
    16fc:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
    16fe:	8652                	mv	a2,s4
    1700:	85ce                	mv	a1,s3
    1702:	854a                	mv	a0,s2
    1704:	d49ff0ef          	jal	144c <peek>
    1708:	f16d                	bnez	a0,16ea <parseline+0x24>
  if(peek(ps, es, ";")){
    170a:	00002617          	auipc	a2,0x2
    170e:	9a660613          	addi	a2,a2,-1626 # 30b0 <malloc+0xfa0>
    1712:	85ce                	mv	a1,s3
    1714:	854a                	mv	a0,s2
    1716:	d37ff0ef          	jal	144c <peek>
    171a:	e911                	bnez	a0,172e <parseline+0x68>
}
    171c:	8526                	mv	a0,s1
    171e:	70a2                	ld	ra,40(sp)
    1720:	7402                	ld	s0,32(sp)
    1722:	64e2                	ld	s1,24(sp)
    1724:	6942                	ld	s2,16(sp)
    1726:	69a2                	ld	s3,8(sp)
    1728:	6a02                	ld	s4,0(sp)
    172a:	6145                	addi	sp,sp,48
    172c:	8082                	ret
    gettoken(ps, es, 0, 0);
    172e:	4681                	li	a3,0
    1730:	4601                	li	a2,0
    1732:	85ce                	mv	a1,s3
    1734:	854a                	mv	a0,s2
    1736:	bdbff0ef          	jal	1310 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
    173a:	85ce                	mv	a1,s3
    173c:	854a                	mv	a0,s2
    173e:	f89ff0ef          	jal	16c6 <parseline>
    1742:	85aa                	mv	a1,a0
    1744:	8526                	mv	a0,s1
    1746:	b59ff0ef          	jal	129e <listcmd>
    174a:	84aa                	mv	s1,a0
  return cmd;
    174c:	bfc1                	j	171c <parseline+0x56>

000000000000174e <parseblock>:
{
    174e:	7179                	addi	sp,sp,-48
    1750:	f406                	sd	ra,40(sp)
    1752:	f022                	sd	s0,32(sp)
    1754:	ec26                	sd	s1,24(sp)
    1756:	e84a                	sd	s2,16(sp)
    1758:	e44e                	sd	s3,8(sp)
    175a:	1800                	addi	s0,sp,48
    175c:	84aa                	mv	s1,a0
    175e:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
    1760:	00002617          	auipc	a2,0x2
    1764:	91860613          	addi	a2,a2,-1768 # 3078 <malloc+0xf68>
    1768:	ce5ff0ef          	jal	144c <peek>
    176c:	c539                	beqz	a0,17ba <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
    176e:	4681                	li	a3,0
    1770:	4601                	li	a2,0
    1772:	85ca                	mv	a1,s2
    1774:	8526                	mv	a0,s1
    1776:	b9bff0ef          	jal	1310 <gettoken>
  cmd = parseline(ps, es);
    177a:	85ca                	mv	a1,s2
    177c:	8526                	mv	a0,s1
    177e:	f49ff0ef          	jal	16c6 <parseline>
    1782:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
    1784:	00002617          	auipc	a2,0x2
    1788:	94460613          	addi	a2,a2,-1724 # 30c8 <malloc+0xfb8>
    178c:	85ca                	mv	a1,s2
    178e:	8526                	mv	a0,s1
    1790:	cbdff0ef          	jal	144c <peek>
    1794:	c90d                	beqz	a0,17c6 <parseblock+0x78>
  gettoken(ps, es, 0, 0);
    1796:	4681                	li	a3,0
    1798:	4601                	li	a2,0
    179a:	85ca                	mv	a1,s2
    179c:	8526                	mv	a0,s1
    179e:	b73ff0ef          	jal	1310 <gettoken>
  cmd = parseredirs(cmd, ps, es);
    17a2:	864a                	mv	a2,s2
    17a4:	85a6                	mv	a1,s1
    17a6:	854e                	mv	a0,s3
    17a8:	d09ff0ef          	jal	14b0 <parseredirs>
}
    17ac:	70a2                	ld	ra,40(sp)
    17ae:	7402                	ld	s0,32(sp)
    17b0:	64e2                	ld	s1,24(sp)
    17b2:	6942                	ld	s2,16(sp)
    17b4:	69a2                	ld	s3,8(sp)
    17b6:	6145                	addi	sp,sp,48
    17b8:	8082                	ret
    panic("parseblock");
    17ba:	00002517          	auipc	a0,0x2
    17be:	8fe50513          	addi	a0,a0,-1794 # 30b8 <malloc+0xfa8>
    17c2:	889ff0ef          	jal	104a <panic>
    panic("syntax - missing )");
    17c6:	00002517          	auipc	a0,0x2
    17ca:	90a50513          	addi	a0,a0,-1782 # 30d0 <malloc+0xfc0>
    17ce:	87dff0ef          	jal	104a <panic>

00000000000017d2 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
    17d2:	1101                	addi	sp,sp,-32
    17d4:	ec06                	sd	ra,24(sp)
    17d6:	e822                	sd	s0,16(sp)
    17d8:	e426                	sd	s1,8(sp)
    17da:	1000                	addi	s0,sp,32
    17dc:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
    17de:	c131                	beqz	a0,1822 <nulterminate+0x50>
    return 0;

  switch(cmd->type){
    17e0:	4118                	lw	a4,0(a0)
    17e2:	4795                	li	a5,5
    17e4:	02e7ef63          	bltu	a5,a4,1822 <nulterminate+0x50>
    17e8:	00056783          	lwu	a5,0(a0)
    17ec:	078a                	slli	a5,a5,0x2
    17ee:	00002717          	auipc	a4,0x2
    17f2:	94270713          	addi	a4,a4,-1726 # 3130 <malloc+0x1020>
    17f6:	97ba                	add	a5,a5,a4
    17f8:	439c                	lw	a5,0(a5)
    17fa:	97ba                	add	a5,a5,a4
    17fc:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
    17fe:	651c                	ld	a5,8(a0)
    1800:	c38d                	beqz	a5,1822 <nulterminate+0x50>
    1802:	01050793          	addi	a5,a0,16
      *ecmd->eargv[i] = 0;
    1806:	67b8                	ld	a4,72(a5)
    1808:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
    180c:	07a1                	addi	a5,a5,8
    180e:	ff87b703          	ld	a4,-8(a5)
    1812:	fb75                	bnez	a4,1806 <nulterminate+0x34>
    1814:	a039                	j	1822 <nulterminate+0x50>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
    1816:	6508                	ld	a0,8(a0)
    1818:	fbbff0ef          	jal	17d2 <nulterminate>
    *rcmd->efile = 0;
    181c:	6c9c                	ld	a5,24(s1)
    181e:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
    1822:	8526                	mv	a0,s1
    1824:	60e2                	ld	ra,24(sp)
    1826:	6442                	ld	s0,16(sp)
    1828:	64a2                	ld	s1,8(sp)
    182a:	6105                	addi	sp,sp,32
    182c:	8082                	ret
    nulterminate(pcmd->left);
    182e:	6508                	ld	a0,8(a0)
    1830:	fa3ff0ef          	jal	17d2 <nulterminate>
    nulterminate(pcmd->right);
    1834:	6888                	ld	a0,16(s1)
    1836:	f9dff0ef          	jal	17d2 <nulterminate>
    break;
    183a:	b7e5                	j	1822 <nulterminate+0x50>
    nulterminate(lcmd->left);
    183c:	6508                	ld	a0,8(a0)
    183e:	f95ff0ef          	jal	17d2 <nulterminate>
    nulterminate(lcmd->right);
    1842:	6888                	ld	a0,16(s1)
    1844:	f8fff0ef          	jal	17d2 <nulterminate>
    break;
    1848:	bfe9                	j	1822 <nulterminate+0x50>
    nulterminate(bcmd->cmd);
    184a:	6508                	ld	a0,8(a0)
    184c:	f87ff0ef          	jal	17d2 <nulterminate>
    break;
    1850:	bfc9                	j	1822 <nulterminate+0x50>

0000000000001852 <parsecmd>:
{
    1852:	7179                	addi	sp,sp,-48
    1854:	f406                	sd	ra,40(sp)
    1856:	f022                	sd	s0,32(sp)
    1858:	ec26                	sd	s1,24(sp)
    185a:	e84a                	sd	s2,16(sp)
    185c:	1800                	addi	s0,sp,48
    185e:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
    1862:	84aa                	mv	s1,a0
    1864:	188000ef          	jal	19ec <strlen>
    1868:	1502                	slli	a0,a0,0x20
    186a:	9101                	srli	a0,a0,0x20
    186c:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
    186e:	85a6                	mv	a1,s1
    1870:	fd840513          	addi	a0,s0,-40
    1874:	e53ff0ef          	jal	16c6 <parseline>
    1878:	892a                	mv	s2,a0
  peek(&s, es, "");
    187a:	00001617          	auipc	a2,0x1
    187e:	78e60613          	addi	a2,a2,1934 # 3008 <malloc+0xef8>
    1882:	85a6                	mv	a1,s1
    1884:	fd840513          	addi	a0,s0,-40
    1888:	bc5ff0ef          	jal	144c <peek>
  if(s != es){
    188c:	fd843603          	ld	a2,-40(s0)
    1890:	00961c63          	bne	a2,s1,18a8 <parsecmd+0x56>
  nulterminate(cmd);
    1894:	854a                	mv	a0,s2
    1896:	f3dff0ef          	jal	17d2 <nulterminate>
}
    189a:	854a                	mv	a0,s2
    189c:	70a2                	ld	ra,40(sp)
    189e:	7402                	ld	s0,32(sp)
    18a0:	64e2                	ld	s1,24(sp)
    18a2:	6942                	ld	s2,16(sp)
    18a4:	6145                	addi	sp,sp,48
    18a6:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
    18a8:	00002597          	auipc	a1,0x2
    18ac:	84058593          	addi	a1,a1,-1984 # 30e8 <malloc+0xfd8>
    18b0:	4509                	li	a0,2
    18b2:	780000ef          	jal	2032 <fprintf>
    panic("syntax");
    18b6:	00001517          	auipc	a0,0x1
    18ba:	7ca50513          	addi	a0,a0,1994 # 3080 <malloc+0xf70>
    18be:	f8cff0ef          	jal	104a <panic>

00000000000018c2 <main>:
{
    18c2:	7179                	addi	sp,sp,-48
    18c4:	f406                	sd	ra,40(sp)
    18c6:	f022                	sd	s0,32(sp)
    18c8:	ec26                	sd	s1,24(sp)
    18ca:	e84a                	sd	s2,16(sp)
    18cc:	e44e                	sd	s3,8(sp)
    18ce:	e052                	sd	s4,0(sp)
    18d0:	1800                	addi	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
    18d2:	00002497          	auipc	s1,0x2
    18d6:	82648493          	addi	s1,s1,-2010 # 30f8 <malloc+0xfe8>
    18da:	4589                	li	a1,2
    18dc:	8526                	mv	a0,s1
    18de:	35e000ef          	jal	1c3c <open>
    18e2:	00054763          	bltz	a0,18f0 <main+0x2e>
    if(fd >= 3){
    18e6:	4789                	li	a5,2
    18e8:	fea7d9e3          	bge	a5,a0,18da <main+0x18>
      close(fd);
    18ec:	338000ef          	jal	1c24 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
    18f0:	00002497          	auipc	s1,0x2
    18f4:	89048493          	addi	s1,s1,-1904 # 3180 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    18f8:	06300913          	li	s2,99
    18fc:	02000993          	li	s3,32
    1900:	a039                	j	190e <main+0x4c>
    if(fork1() == 0)
    1902:	f66ff0ef          	jal	1068 <fork1>
    1906:	c93d                	beqz	a0,197c <main+0xba>
    wait(0);
    1908:	4501                	li	a0,0
    190a:	2fa000ef          	jal	1c04 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
    190e:	06400593          	li	a1,100
    1912:	8526                	mv	a0,s1
    1914:	eecff0ef          	jal	1000 <getcmd>
    1918:	06054a63          	bltz	a0,198c <main+0xca>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
    191c:	0004c783          	lbu	a5,0(s1)
    1920:	ff2791e3          	bne	a5,s2,1902 <main+0x40>
    1924:	0014c703          	lbu	a4,1(s1)
    1928:	06400793          	li	a5,100
    192c:	fcf71be3          	bne	a4,a5,1902 <main+0x40>
    1930:	0024c783          	lbu	a5,2(s1)
    1934:	fd3797e3          	bne	a5,s3,1902 <main+0x40>
      buf[strlen(buf)-1] = 0;  // chop \n
    1938:	00002a17          	auipc	s4,0x2
    193c:	848a0a13          	addi	s4,s4,-1976 # 3180 <buf.0>
    1940:	8552                	mv	a0,s4
    1942:	0aa000ef          	jal	19ec <strlen>
    1946:	fff5079b          	addiw	a5,a0,-1
    194a:	1782                	slli	a5,a5,0x20
    194c:	9381                	srli	a5,a5,0x20
    194e:	9a3e                	add	s4,s4,a5
    1950:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
    1954:	00002517          	auipc	a0,0x2
    1958:	82f50513          	addi	a0,a0,-2001 # 3183 <buf.0+0x3>
    195c:	310000ef          	jal	1c6c <chdir>
    1960:	fa0557e3          	bgez	a0,190e <main+0x4c>
        fprintf(2, "cannot cd %s\n", buf+3);
    1964:	00002617          	auipc	a2,0x2
    1968:	81f60613          	addi	a2,a2,-2017 # 3183 <buf.0+0x3>
    196c:	00001597          	auipc	a1,0x1
    1970:	79458593          	addi	a1,a1,1940 # 3100 <malloc+0xff0>
    1974:	4509                	li	a0,2
    1976:	6bc000ef          	jal	2032 <fprintf>
    197a:	bf51                	j	190e <main+0x4c>
      runcmd(parsecmd(buf));
    197c:	00002517          	auipc	a0,0x2
    1980:	80450513          	addi	a0,a0,-2044 # 3180 <buf.0>
    1984:	ecfff0ef          	jal	1852 <parsecmd>
    1988:	f06ff0ef          	jal	108e <runcmd>
  exit(0);
    198c:	4501                	li	a0,0
    198e:	26e000ef          	jal	1bfc <exit>

0000000000001992 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
    1992:	1141                	addi	sp,sp,-16
    1994:	e406                	sd	ra,8(sp)
    1996:	e022                	sd	s0,0(sp)
    1998:	0800                	addi	s0,sp,16
  extern int main();
  main();
    199a:	f29ff0ef          	jal	18c2 <main>
  exit(0);
    199e:	4501                	li	a0,0
    19a0:	25c000ef          	jal	1bfc <exit>

00000000000019a4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    19a4:	1141                	addi	sp,sp,-16
    19a6:	e422                	sd	s0,8(sp)
    19a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    19aa:	87aa                	mv	a5,a0
    19ac:	0585                	addi	a1,a1,1
    19ae:	0785                	addi	a5,a5,1
    19b0:	fff5c703          	lbu	a4,-1(a1)
    19b4:	fee78fa3          	sb	a4,-1(a5)
    19b8:	fb75                	bnez	a4,19ac <strcpy+0x8>
    ;
  return os;
}
    19ba:	6422                	ld	s0,8(sp)
    19bc:	0141                	addi	sp,sp,16
    19be:	8082                	ret

00000000000019c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    19c0:	1141                	addi	sp,sp,-16
    19c2:	e422                	sd	s0,8(sp)
    19c4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    19c6:	00054783          	lbu	a5,0(a0)
    19ca:	cb91                	beqz	a5,19de <strcmp+0x1e>
    19cc:	0005c703          	lbu	a4,0(a1)
    19d0:	00f71763          	bne	a4,a5,19de <strcmp+0x1e>
    p++, q++;
    19d4:	0505                	addi	a0,a0,1
    19d6:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    19d8:	00054783          	lbu	a5,0(a0)
    19dc:	fbe5                	bnez	a5,19cc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    19de:	0005c503          	lbu	a0,0(a1)
}
    19e2:	40a7853b          	subw	a0,a5,a0
    19e6:	6422                	ld	s0,8(sp)
    19e8:	0141                	addi	sp,sp,16
    19ea:	8082                	ret

00000000000019ec <strlen>:

uint
strlen(const char *s)
{
    19ec:	1141                	addi	sp,sp,-16
    19ee:	e422                	sd	s0,8(sp)
    19f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    19f2:	00054783          	lbu	a5,0(a0)
    19f6:	cf91                	beqz	a5,1a12 <strlen+0x26>
    19f8:	0505                	addi	a0,a0,1
    19fa:	87aa                	mv	a5,a0
    19fc:	86be                	mv	a3,a5
    19fe:	0785                	addi	a5,a5,1
    1a00:	fff7c703          	lbu	a4,-1(a5)
    1a04:	ff65                	bnez	a4,19fc <strlen+0x10>
    1a06:	40a6853b          	subw	a0,a3,a0
    1a0a:	2505                	addiw	a0,a0,1
    ;
  return n;
}
    1a0c:	6422                	ld	s0,8(sp)
    1a0e:	0141                	addi	sp,sp,16
    1a10:	8082                	ret
  for(n = 0; s[n]; n++)
    1a12:	4501                	li	a0,0
    1a14:	bfe5                	j	1a0c <strlen+0x20>

0000000000001a16 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1a16:	1141                	addi	sp,sp,-16
    1a18:	e422                	sd	s0,8(sp)
    1a1a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    1a1c:	ca19                	beqz	a2,1a32 <memset+0x1c>
    1a1e:	87aa                	mv	a5,a0
    1a20:	1602                	slli	a2,a2,0x20
    1a22:	9201                	srli	a2,a2,0x20
    1a24:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1a28:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    1a2c:	0785                	addi	a5,a5,1
    1a2e:	fee79de3          	bne	a5,a4,1a28 <memset+0x12>
  }
  return dst;
}
    1a32:	6422                	ld	s0,8(sp)
    1a34:	0141                	addi	sp,sp,16
    1a36:	8082                	ret

0000000000001a38 <strchr>:

char*
strchr(const char *s, char c)
{
    1a38:	1141                	addi	sp,sp,-16
    1a3a:	e422                	sd	s0,8(sp)
    1a3c:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1a3e:	00054783          	lbu	a5,0(a0)
    1a42:	cb99                	beqz	a5,1a58 <strchr+0x20>
    if(*s == c)
    1a44:	00f58763          	beq	a1,a5,1a52 <strchr+0x1a>
  for(; *s; s++)
    1a48:	0505                	addi	a0,a0,1
    1a4a:	00054783          	lbu	a5,0(a0)
    1a4e:	fbfd                	bnez	a5,1a44 <strchr+0xc>
      return (char*)s;
  return 0;
    1a50:	4501                	li	a0,0
}
    1a52:	6422                	ld	s0,8(sp)
    1a54:	0141                	addi	sp,sp,16
    1a56:	8082                	ret
  return 0;
    1a58:	4501                	li	a0,0
    1a5a:	bfe5                	j	1a52 <strchr+0x1a>

0000000000001a5c <gets>:

char*
gets(char *buf, int max)
{
    1a5c:	711d                	addi	sp,sp,-96
    1a5e:	ec86                	sd	ra,88(sp)
    1a60:	e8a2                	sd	s0,80(sp)
    1a62:	e4a6                	sd	s1,72(sp)
    1a64:	e0ca                	sd	s2,64(sp)
    1a66:	fc4e                	sd	s3,56(sp)
    1a68:	f852                	sd	s4,48(sp)
    1a6a:	f456                	sd	s5,40(sp)
    1a6c:	f05a                	sd	s6,32(sp)
    1a6e:	ec5e                	sd	s7,24(sp)
    1a70:	1080                	addi	s0,sp,96
    1a72:	8baa                	mv	s7,a0
    1a74:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1a76:	892a                	mv	s2,a0
    1a78:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    1a7a:	4aa9                	li	s5,10
    1a7c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    1a7e:	89a6                	mv	s3,s1
    1a80:	2485                	addiw	s1,s1,1
    1a82:	0344d663          	bge	s1,s4,1aae <gets+0x52>
    cc = read(0, &c, 1);
    1a86:	4605                	li	a2,1
    1a88:	faf40593          	addi	a1,s0,-81
    1a8c:	4501                	li	a0,0
    1a8e:	186000ef          	jal	1c14 <read>
    if(cc < 1)
    1a92:	00a05e63          	blez	a0,1aae <gets+0x52>
    buf[i++] = c;
    1a96:	faf44783          	lbu	a5,-81(s0)
    1a9a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    1a9e:	01578763          	beq	a5,s5,1aac <gets+0x50>
    1aa2:	0905                	addi	s2,s2,1
    1aa4:	fd679de3          	bne	a5,s6,1a7e <gets+0x22>
    buf[i++] = c;
    1aa8:	89a6                	mv	s3,s1
    1aaa:	a011                	j	1aae <gets+0x52>
    1aac:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    1aae:	99de                	add	s3,s3,s7
    1ab0:	00098023          	sb	zero,0(s3)
  return buf;
}
    1ab4:	855e                	mv	a0,s7
    1ab6:	60e6                	ld	ra,88(sp)
    1ab8:	6446                	ld	s0,80(sp)
    1aba:	64a6                	ld	s1,72(sp)
    1abc:	6906                	ld	s2,64(sp)
    1abe:	79e2                	ld	s3,56(sp)
    1ac0:	7a42                	ld	s4,48(sp)
    1ac2:	7aa2                	ld	s5,40(sp)
    1ac4:	7b02                	ld	s6,32(sp)
    1ac6:	6be2                	ld	s7,24(sp)
    1ac8:	6125                	addi	sp,sp,96
    1aca:	8082                	ret

0000000000001acc <stat>:

int
stat(const char *n, struct stat *st)
{
    1acc:	1101                	addi	sp,sp,-32
    1ace:	ec06                	sd	ra,24(sp)
    1ad0:	e822                	sd	s0,16(sp)
    1ad2:	e04a                	sd	s2,0(sp)
    1ad4:	1000                	addi	s0,sp,32
    1ad6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1ad8:	4581                	li	a1,0
    1ada:	162000ef          	jal	1c3c <open>
  if(fd < 0)
    1ade:	02054263          	bltz	a0,1b02 <stat+0x36>
    1ae2:	e426                	sd	s1,8(sp)
    1ae4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1ae6:	85ca                	mv	a1,s2
    1ae8:	16c000ef          	jal	1c54 <fstat>
    1aec:	892a                	mv	s2,a0
  close(fd);
    1aee:	8526                	mv	a0,s1
    1af0:	134000ef          	jal	1c24 <close>
  return r;
    1af4:	64a2                	ld	s1,8(sp)
}
    1af6:	854a                	mv	a0,s2
    1af8:	60e2                	ld	ra,24(sp)
    1afa:	6442                	ld	s0,16(sp)
    1afc:	6902                	ld	s2,0(sp)
    1afe:	6105                	addi	sp,sp,32
    1b00:	8082                	ret
    return -1;
    1b02:	597d                	li	s2,-1
    1b04:	bfcd                	j	1af6 <stat+0x2a>

0000000000001b06 <atoi>:

int
atoi(const char *s)
{
    1b06:	1141                	addi	sp,sp,-16
    1b08:	e422                	sd	s0,8(sp)
    1b0a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1b0c:	00054683          	lbu	a3,0(a0)
    1b10:	fd06879b          	addiw	a5,a3,-48
    1b14:	0ff7f793          	zext.b	a5,a5
    1b18:	4625                	li	a2,9
    1b1a:	02f66863          	bltu	a2,a5,1b4a <atoi+0x44>
    1b1e:	872a                	mv	a4,a0
  n = 0;
    1b20:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    1b22:	0705                	addi	a4,a4,1
    1b24:	0025179b          	slliw	a5,a0,0x2
    1b28:	9fa9                	addw	a5,a5,a0
    1b2a:	0017979b          	slliw	a5,a5,0x1
    1b2e:	9fb5                	addw	a5,a5,a3
    1b30:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1b34:	00074683          	lbu	a3,0(a4)
    1b38:	fd06879b          	addiw	a5,a3,-48
    1b3c:	0ff7f793          	zext.b	a5,a5
    1b40:	fef671e3          	bgeu	a2,a5,1b22 <atoi+0x1c>
  return n;
}
    1b44:	6422                	ld	s0,8(sp)
    1b46:	0141                	addi	sp,sp,16
    1b48:	8082                	ret
  n = 0;
    1b4a:	4501                	li	a0,0
    1b4c:	bfe5                	j	1b44 <atoi+0x3e>

0000000000001b4e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1b4e:	1141                	addi	sp,sp,-16
    1b50:	e422                	sd	s0,8(sp)
    1b52:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1b54:	02b57463          	bgeu	a0,a1,1b7c <memmove+0x2e>
    while(n-- > 0)
    1b58:	00c05f63          	blez	a2,1b76 <memmove+0x28>
    1b5c:	1602                	slli	a2,a2,0x20
    1b5e:	9201                	srli	a2,a2,0x20
    1b60:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    1b64:	872a                	mv	a4,a0
      *dst++ = *src++;
    1b66:	0585                	addi	a1,a1,1
    1b68:	0705                	addi	a4,a4,1
    1b6a:	fff5c683          	lbu	a3,-1(a1)
    1b6e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    1b72:	fef71ae3          	bne	a4,a5,1b66 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    1b76:	6422                	ld	s0,8(sp)
    1b78:	0141                	addi	sp,sp,16
    1b7a:	8082                	ret
    dst += n;
    1b7c:	00c50733          	add	a4,a0,a2
    src += n;
    1b80:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    1b82:	fec05ae3          	blez	a2,1b76 <memmove+0x28>
    1b86:	fff6079b          	addiw	a5,a2,-1
    1b8a:	1782                	slli	a5,a5,0x20
    1b8c:	9381                	srli	a5,a5,0x20
    1b8e:	fff7c793          	not	a5,a5
    1b92:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    1b94:	15fd                	addi	a1,a1,-1
    1b96:	177d                	addi	a4,a4,-1
    1b98:	0005c683          	lbu	a3,0(a1)
    1b9c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    1ba0:	fee79ae3          	bne	a5,a4,1b94 <memmove+0x46>
    1ba4:	bfc9                	j	1b76 <memmove+0x28>

0000000000001ba6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    1ba6:	1141                	addi	sp,sp,-16
    1ba8:	e422                	sd	s0,8(sp)
    1baa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    1bac:	ca05                	beqz	a2,1bdc <memcmp+0x36>
    1bae:	fff6069b          	addiw	a3,a2,-1
    1bb2:	1682                	slli	a3,a3,0x20
    1bb4:	9281                	srli	a3,a3,0x20
    1bb6:	0685                	addi	a3,a3,1
    1bb8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    1bba:	00054783          	lbu	a5,0(a0)
    1bbe:	0005c703          	lbu	a4,0(a1)
    1bc2:	00e79863          	bne	a5,a4,1bd2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    1bc6:	0505                	addi	a0,a0,1
    p2++;
    1bc8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    1bca:	fed518e3          	bne	a0,a3,1bba <memcmp+0x14>
  }
  return 0;
    1bce:	4501                	li	a0,0
    1bd0:	a019                	j	1bd6 <memcmp+0x30>
      return *p1 - *p2;
    1bd2:	40e7853b          	subw	a0,a5,a4
}
    1bd6:	6422                	ld	s0,8(sp)
    1bd8:	0141                	addi	sp,sp,16
    1bda:	8082                	ret
  return 0;
    1bdc:	4501                	li	a0,0
    1bde:	bfe5                	j	1bd6 <memcmp+0x30>

0000000000001be0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1be0:	1141                	addi	sp,sp,-16
    1be2:	e406                	sd	ra,8(sp)
    1be4:	e022                	sd	s0,0(sp)
    1be6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    1be8:	f67ff0ef          	jal	1b4e <memmove>
}
    1bec:	60a2                	ld	ra,8(sp)
    1bee:	6402                	ld	s0,0(sp)
    1bf0:	0141                	addi	sp,sp,16
    1bf2:	8082                	ret

0000000000001bf4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1bf4:	4885                	li	a7,1
 ecall
    1bf6:	00000073          	ecall
 ret
    1bfa:	8082                	ret

0000000000001bfc <exit>:
.global exit
exit:
 li a7, SYS_exit
    1bfc:	4889                	li	a7,2
 ecall
    1bfe:	00000073          	ecall
 ret
    1c02:	8082                	ret

0000000000001c04 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1c04:	488d                	li	a7,3
 ecall
    1c06:	00000073          	ecall
 ret
    1c0a:	8082                	ret

0000000000001c0c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    1c0c:	4891                	li	a7,4
 ecall
    1c0e:	00000073          	ecall
 ret
    1c12:	8082                	ret

0000000000001c14 <read>:
.global read
read:
 li a7, SYS_read
    1c14:	4895                	li	a7,5
 ecall
    1c16:	00000073          	ecall
 ret
    1c1a:	8082                	ret

0000000000001c1c <write>:
.global write
write:
 li a7, SYS_write
    1c1c:	48c1                	li	a7,16
 ecall
    1c1e:	00000073          	ecall
 ret
    1c22:	8082                	ret

0000000000001c24 <close>:
.global close
close:
 li a7, SYS_close
    1c24:	48d5                	li	a7,21
 ecall
    1c26:	00000073          	ecall
 ret
    1c2a:	8082                	ret

0000000000001c2c <kill>:
.global kill
kill:
 li a7, SYS_kill
    1c2c:	4899                	li	a7,6
 ecall
    1c2e:	00000073          	ecall
 ret
    1c32:	8082                	ret

0000000000001c34 <exec>:
.global exec
exec:
 li a7, SYS_exec
    1c34:	489d                	li	a7,7
 ecall
    1c36:	00000073          	ecall
 ret
    1c3a:	8082                	ret

0000000000001c3c <open>:
.global open
open:
 li a7, SYS_open
    1c3c:	48bd                	li	a7,15
 ecall
    1c3e:	00000073          	ecall
 ret
    1c42:	8082                	ret

0000000000001c44 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    1c44:	48c5                	li	a7,17
 ecall
    1c46:	00000073          	ecall
 ret
    1c4a:	8082                	ret

0000000000001c4c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    1c4c:	48c9                	li	a7,18
 ecall
    1c4e:	00000073          	ecall
 ret
    1c52:	8082                	ret

0000000000001c54 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    1c54:	48a1                	li	a7,8
 ecall
    1c56:	00000073          	ecall
 ret
    1c5a:	8082                	ret

0000000000001c5c <link>:
.global link
link:
 li a7, SYS_link
    1c5c:	48cd                	li	a7,19
 ecall
    1c5e:	00000073          	ecall
 ret
    1c62:	8082                	ret

0000000000001c64 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    1c64:	48d1                	li	a7,20
 ecall
    1c66:	00000073          	ecall
 ret
    1c6a:	8082                	ret

0000000000001c6c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1c6c:	48a5                	li	a7,9
 ecall
    1c6e:	00000073          	ecall
 ret
    1c72:	8082                	ret

0000000000001c74 <dup>:
.global dup
dup:
 li a7, SYS_dup
    1c74:	48a9                	li	a7,10
 ecall
    1c76:	00000073          	ecall
 ret
    1c7a:	8082                	ret

0000000000001c7c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1c7c:	48ad                	li	a7,11
 ecall
    1c7e:	00000073          	ecall
 ret
    1c82:	8082                	ret

0000000000001c84 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    1c84:	48b1                	li	a7,12
 ecall
    1c86:	00000073          	ecall
 ret
    1c8a:	8082                	ret

0000000000001c8c <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    1c8c:	48b5                	li	a7,13
 ecall
    1c8e:	00000073          	ecall
 ret
    1c92:	8082                	ret

0000000000001c94 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1c94:	48b9                	li	a7,14
 ecall
    1c96:	00000073          	ecall
 ret
    1c9a:	8082                	ret

0000000000001c9c <cps>:
.global cps
cps:
 li a7, SYS_cps
    1c9c:	48d9                	li	a7,22
 ecall
    1c9e:	00000073          	ecall
 ret
    1ca2:	8082                	ret

0000000000001ca4 <signal>:
.global signal
signal:
 li a7, SYS_signal
    1ca4:	48dd                	li	a7,23
 ecall
    1ca6:	00000073          	ecall
 ret
    1caa:	8082                	ret

0000000000001cac <msgget>:
.global msgget
msgget:
 li a7, SYS_msgget
    1cac:	48e1                	li	a7,24
 ecall
    1cae:	00000073          	ecall
 ret
    1cb2:	8082                	ret

0000000000001cb4 <msgsnd>:
.global msgsnd
msgsnd:
 li a7, SYS_msgsnd
    1cb4:	48e5                	li	a7,25
 ecall
    1cb6:	00000073          	ecall
 ret
    1cba:	8082                	ret

0000000000001cbc <msgrcv>:
.global msgrcv
msgrcv:
 li a7, SYS_msgrcv
    1cbc:	48e9                	li	a7,26
 ecall
    1cbe:	00000073          	ecall
 ret
    1cc2:	8082                	ret

0000000000001cc4 <msgctl>:
.global msgctl
msgctl:
 li a7, SYS_msgctl
    1cc4:	48ed                	li	a7,27
 ecall
    1cc6:	00000073          	ecall
 ret
    1cca:	8082                	ret

0000000000001ccc <thread_create>:
.global thread_create
thread_create:
 li a7, SYS_thread_create
    1ccc:	48f1                	li	a7,28
 ecall
    1cce:	00000073          	ecall
 ret
    1cd2:	8082                	ret

0000000000001cd4 <thread_exit>:
.global thread_exit
thread_exit:
 li a7, SYS_thread_exit
    1cd4:	48f5                	li	a7,29
 ecall
    1cd6:	00000073          	ecall
 ret
    1cda:	8082                	ret

0000000000001cdc <thread_join>:
.global thread_join
thread_join:
 li a7, SYS_thread_join
    1cdc:	48f9                	li	a7,30
 ecall
    1cde:	00000073          	ecall
 ret
    1ce2:	8082                	ret

0000000000001ce4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1ce4:	1101                	addi	sp,sp,-32
    1ce6:	ec06                	sd	ra,24(sp)
    1ce8:	e822                	sd	s0,16(sp)
    1cea:	1000                	addi	s0,sp,32
    1cec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1cf0:	4605                	li	a2,1
    1cf2:	fef40593          	addi	a1,s0,-17
    1cf6:	f27ff0ef          	jal	1c1c <write>
}
    1cfa:	60e2                	ld	ra,24(sp)
    1cfc:	6442                	ld	s0,16(sp)
    1cfe:	6105                	addi	sp,sp,32
    1d00:	8082                	ret

0000000000001d02 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    1d02:	7139                	addi	sp,sp,-64
    1d04:	fc06                	sd	ra,56(sp)
    1d06:	f822                	sd	s0,48(sp)
    1d08:	f426                	sd	s1,40(sp)
    1d0a:	0080                	addi	s0,sp,64
    1d0c:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1d0e:	c299                	beqz	a3,1d14 <printint+0x12>
    1d10:	0805c963          	bltz	a1,1da2 <printint+0xa0>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    1d14:	2581                	sext.w	a1,a1
  neg = 0;
    1d16:	4881                	li	a7,0
    1d18:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    1d1c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1d1e:	2601                	sext.w	a2,a2
    1d20:	00001517          	auipc	a0,0x1
    1d24:	42850513          	addi	a0,a0,1064 # 3148 <digits>
    1d28:	883a                	mv	a6,a4
    1d2a:	2705                	addiw	a4,a4,1
    1d2c:	02c5f7bb          	remuw	a5,a1,a2
    1d30:	1782                	slli	a5,a5,0x20
    1d32:	9381                	srli	a5,a5,0x20
    1d34:	97aa                	add	a5,a5,a0
    1d36:	0007c783          	lbu	a5,0(a5)
    1d3a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1d3e:	0005879b          	sext.w	a5,a1
    1d42:	02c5d5bb          	divuw	a1,a1,a2
    1d46:	0685                	addi	a3,a3,1
    1d48:	fec7f0e3          	bgeu	a5,a2,1d28 <printint+0x26>
  if(neg)
    1d4c:	00088c63          	beqz	a7,1d64 <printint+0x62>
    buf[i++] = '-';
    1d50:	fd070793          	addi	a5,a4,-48
    1d54:	00878733          	add	a4,a5,s0
    1d58:	02d00793          	li	a5,45
    1d5c:	fef70823          	sb	a5,-16(a4)
    1d60:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    1d64:	02e05a63          	blez	a4,1d98 <printint+0x96>
    1d68:	f04a                	sd	s2,32(sp)
    1d6a:	ec4e                	sd	s3,24(sp)
    1d6c:	fc040793          	addi	a5,s0,-64
    1d70:	00e78933          	add	s2,a5,a4
    1d74:	fff78993          	addi	s3,a5,-1
    1d78:	99ba                	add	s3,s3,a4
    1d7a:	377d                	addiw	a4,a4,-1
    1d7c:	1702                	slli	a4,a4,0x20
    1d7e:	9301                	srli	a4,a4,0x20
    1d80:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1d84:	fff94583          	lbu	a1,-1(s2)
    1d88:	8526                	mv	a0,s1
    1d8a:	f5bff0ef          	jal	1ce4 <putc>
  while(--i >= 0)
    1d8e:	197d                	addi	s2,s2,-1
    1d90:	ff391ae3          	bne	s2,s3,1d84 <printint+0x82>
    1d94:	7902                	ld	s2,32(sp)
    1d96:	69e2                	ld	s3,24(sp)
}
    1d98:	70e2                	ld	ra,56(sp)
    1d9a:	7442                	ld	s0,48(sp)
    1d9c:	74a2                	ld	s1,40(sp)
    1d9e:	6121                	addi	sp,sp,64
    1da0:	8082                	ret
    x = -xx;
    1da2:	40b005bb          	negw	a1,a1
    neg = 1;
    1da6:	4885                	li	a7,1
    x = -xx;
    1da8:	bf85                	j	1d18 <printint+0x16>

0000000000001daa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1daa:	711d                	addi	sp,sp,-96
    1dac:	ec86                	sd	ra,88(sp)
    1dae:	e8a2                	sd	s0,80(sp)
    1db0:	e0ca                	sd	s2,64(sp)
    1db2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1db4:	0005c903          	lbu	s2,0(a1)
    1db8:	26090863          	beqz	s2,2028 <vprintf+0x27e>
    1dbc:	e4a6                	sd	s1,72(sp)
    1dbe:	fc4e                	sd	s3,56(sp)
    1dc0:	f852                	sd	s4,48(sp)
    1dc2:	f456                	sd	s5,40(sp)
    1dc4:	f05a                	sd	s6,32(sp)
    1dc6:	ec5e                	sd	s7,24(sp)
    1dc8:	e862                	sd	s8,16(sp)
    1dca:	e466                	sd	s9,8(sp)
    1dcc:	8b2a                	mv	s6,a0
    1dce:	8a2e                	mv	s4,a1
    1dd0:	8bb2                	mv	s7,a2
  state = 0;
    1dd2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1dd4:	4481                	li	s1,0
    1dd6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1dd8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1ddc:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1de0:	06c00c93          	li	s9,108
    1de4:	a005                	j	1e04 <vprintf+0x5a>
        putc(fd, c0);
    1de6:	85ca                	mv	a1,s2
    1de8:	855a                	mv	a0,s6
    1dea:	efbff0ef          	jal	1ce4 <putc>
    1dee:	a019                	j	1df4 <vprintf+0x4a>
    } else if(state == '%'){
    1df0:	03598263          	beq	s3,s5,1e14 <vprintf+0x6a>
  for(i = 0; fmt[i]; i++){
    1df4:	2485                	addiw	s1,s1,1
    1df6:	8726                	mv	a4,s1
    1df8:	009a07b3          	add	a5,s4,s1
    1dfc:	0007c903          	lbu	s2,0(a5)
    1e00:	20090c63          	beqz	s2,2018 <vprintf+0x26e>
    c0 = fmt[i] & 0xff;
    1e04:	0009079b          	sext.w	a5,s2
    if(state == 0){
    1e08:	fe0994e3          	bnez	s3,1df0 <vprintf+0x46>
      if(c0 == '%'){
    1e0c:	fd579de3          	bne	a5,s5,1de6 <vprintf+0x3c>
        state = '%';
    1e10:	89be                	mv	s3,a5
    1e12:	b7cd                	j	1df4 <vprintf+0x4a>
      if(c0) c1 = fmt[i+1] & 0xff;
    1e14:	00ea06b3          	add	a3,s4,a4
    1e18:	0016c683          	lbu	a3,1(a3)
      c1 = c2 = 0;
    1e1c:	8636                	mv	a2,a3
      if(c1) c2 = fmt[i+2] & 0xff;
    1e1e:	c681                	beqz	a3,1e26 <vprintf+0x7c>
    1e20:	9752                	add	a4,a4,s4
    1e22:	00274603          	lbu	a2,2(a4)
      if(c0 == 'd'){
    1e26:	03878f63          	beq	a5,s8,1e64 <vprintf+0xba>
      } else if(c0 == 'l' && c1 == 'd'){
    1e2a:	05978963          	beq	a5,s9,1e7c <vprintf+0xd2>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if(c0 == 'u'){
    1e2e:	07500713          	li	a4,117
    1e32:	0ee78363          	beq	a5,a4,1f18 <vprintf+0x16e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if(c0 == 'x'){
    1e36:	07800713          	li	a4,120
    1e3a:	12e78563          	beq	a5,a4,1f64 <vprintf+0x1ba>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if(c0 == 'p'){
    1e3e:	07000713          	li	a4,112
    1e42:	14e78a63          	beq	a5,a4,1f96 <vprintf+0x1ec>
        printptr(fd, va_arg(ap, uint64));
      } else if(c0 == 's'){
    1e46:	07300713          	li	a4,115
    1e4a:	18e78a63          	beq	a5,a4,1fde <vprintf+0x234>
        if((s = va_arg(ap, char*)) == 0)
          s = "(null)";
        for(; *s; s++)
          putc(fd, *s);
      } else if(c0 == '%'){
    1e4e:	02500713          	li	a4,37
    1e52:	04e79563          	bne	a5,a4,1e9c <vprintf+0xf2>
        putc(fd, '%');
    1e56:	02500593          	li	a1,37
    1e5a:	855a                	mv	a0,s6
    1e5c:	e89ff0ef          	jal	1ce4 <putc>
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
#endif
      state = 0;
    1e60:	4981                	li	s3,0
    1e62:	bf49                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 1);
    1e64:	008b8913          	addi	s2,s7,8
    1e68:	4685                	li	a3,1
    1e6a:	4629                	li	a2,10
    1e6c:	000ba583          	lw	a1,0(s7)
    1e70:	855a                	mv	a0,s6
    1e72:	e91ff0ef          	jal	1d02 <printint>
    1e76:	8bca                	mv	s7,s2
      state = 0;
    1e78:	4981                	li	s3,0
    1e7a:	bfad                	j	1df4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'd'){
    1e7c:	06400793          	li	a5,100
    1e80:	02f68963          	beq	a3,a5,1eb2 <vprintf+0x108>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1e84:	06c00793          	li	a5,108
    1e88:	04f68263          	beq	a3,a5,1ecc <vprintf+0x122>
      } else if(c0 == 'l' && c1 == 'u'){
    1e8c:	07500793          	li	a5,117
    1e90:	0af68063          	beq	a3,a5,1f30 <vprintf+0x186>
      } else if(c0 == 'l' && c1 == 'x'){
    1e94:	07800793          	li	a5,120
    1e98:	0ef68263          	beq	a3,a5,1f7c <vprintf+0x1d2>
        putc(fd, '%');
    1e9c:	02500593          	li	a1,37
    1ea0:	855a                	mv	a0,s6
    1ea2:	e43ff0ef          	jal	1ce4 <putc>
        putc(fd, c0);
    1ea6:	85ca                	mv	a1,s2
    1ea8:	855a                	mv	a0,s6
    1eaa:	e3bff0ef          	jal	1ce4 <putc>
      state = 0;
    1eae:	4981                	li	s3,0
    1eb0:	b791                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1eb2:	008b8913          	addi	s2,s7,8
    1eb6:	4685                	li	a3,1
    1eb8:	4629                	li	a2,10
    1eba:	000ba583          	lw	a1,0(s7)
    1ebe:	855a                	mv	a0,s6
    1ec0:	e43ff0ef          	jal	1d02 <printint>
        i += 1;
    1ec4:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1ec6:	8bca                	mv	s7,s2
      state = 0;
    1ec8:	4981                	li	s3,0
        i += 1;
    1eca:	b72d                	j	1df4 <vprintf+0x4a>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1ecc:	06400793          	li	a5,100
    1ed0:	02f60763          	beq	a2,a5,1efe <vprintf+0x154>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1ed4:	07500793          	li	a5,117
    1ed8:	06f60963          	beq	a2,a5,1f4a <vprintf+0x1a0>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1edc:	07800793          	li	a5,120
    1ee0:	faf61ee3          	bne	a2,a5,1e9c <vprintf+0xf2>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1ee4:	008b8913          	addi	s2,s7,8
    1ee8:	4681                	li	a3,0
    1eea:	4641                	li	a2,16
    1eec:	000ba583          	lw	a1,0(s7)
    1ef0:	855a                	mv	a0,s6
    1ef2:	e11ff0ef          	jal	1d02 <printint>
        i += 2;
    1ef6:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1ef8:	8bca                	mv	s7,s2
      state = 0;
    1efa:	4981                	li	s3,0
        i += 2;
    1efc:	bde5                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1efe:	008b8913          	addi	s2,s7,8
    1f02:	4685                	li	a3,1
    1f04:	4629                	li	a2,10
    1f06:	000ba583          	lw	a1,0(s7)
    1f0a:	855a                	mv	a0,s6
    1f0c:	df7ff0ef          	jal	1d02 <printint>
        i += 2;
    1f10:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1f12:	8bca                	mv	s7,s2
      state = 0;
    1f14:	4981                	li	s3,0
        i += 2;
    1f16:	bdf9                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 10, 0);
    1f18:	008b8913          	addi	s2,s7,8
    1f1c:	4681                	li	a3,0
    1f1e:	4629                	li	a2,10
    1f20:	000ba583          	lw	a1,0(s7)
    1f24:	855a                	mv	a0,s6
    1f26:	dddff0ef          	jal	1d02 <printint>
    1f2a:	8bca                	mv	s7,s2
      state = 0;
    1f2c:	4981                	li	s3,0
    1f2e:	b5d9                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1f30:	008b8913          	addi	s2,s7,8
    1f34:	4681                	li	a3,0
    1f36:	4629                	li	a2,10
    1f38:	000ba583          	lw	a1,0(s7)
    1f3c:	855a                	mv	a0,s6
    1f3e:	dc5ff0ef          	jal	1d02 <printint>
        i += 1;
    1f42:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1f44:	8bca                	mv	s7,s2
      state = 0;
    1f46:	4981                	li	s3,0
        i += 1;
    1f48:	b575                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1f4a:	008b8913          	addi	s2,s7,8
    1f4e:	4681                	li	a3,0
    1f50:	4629                	li	a2,10
    1f52:	000ba583          	lw	a1,0(s7)
    1f56:	855a                	mv	a0,s6
    1f58:	dabff0ef          	jal	1d02 <printint>
        i += 2;
    1f5c:	2489                	addiw	s1,s1,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1f5e:	8bca                	mv	s7,s2
      state = 0;
    1f60:	4981                	li	s3,0
        i += 2;
    1f62:	bd49                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, int), 16, 0);
    1f64:	008b8913          	addi	s2,s7,8
    1f68:	4681                	li	a3,0
    1f6a:	4641                	li	a2,16
    1f6c:	000ba583          	lw	a1,0(s7)
    1f70:	855a                	mv	a0,s6
    1f72:	d91ff0ef          	jal	1d02 <printint>
    1f76:	8bca                	mv	s7,s2
      state = 0;
    1f78:	4981                	li	s3,0
    1f7a:	bdad                	j	1df4 <vprintf+0x4a>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1f7c:	008b8913          	addi	s2,s7,8
    1f80:	4681                	li	a3,0
    1f82:	4641                	li	a2,16
    1f84:	000ba583          	lw	a1,0(s7)
    1f88:	855a                	mv	a0,s6
    1f8a:	d79ff0ef          	jal	1d02 <printint>
        i += 1;
    1f8e:	2485                	addiw	s1,s1,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1f90:	8bca                	mv	s7,s2
      state = 0;
    1f92:	4981                	li	s3,0
        i += 1;
    1f94:	b585                	j	1df4 <vprintf+0x4a>
    1f96:	e06a                	sd	s10,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1f98:	008b8d13          	addi	s10,s7,8
    1f9c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1fa0:	03000593          	li	a1,48
    1fa4:	855a                	mv	a0,s6
    1fa6:	d3fff0ef          	jal	1ce4 <putc>
  putc(fd, 'x');
    1faa:	07800593          	li	a1,120
    1fae:	855a                	mv	a0,s6
    1fb0:	d35ff0ef          	jal	1ce4 <putc>
    1fb4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1fb6:	00001b97          	auipc	s7,0x1
    1fba:	192b8b93          	addi	s7,s7,402 # 3148 <digits>
    1fbe:	03c9d793          	srli	a5,s3,0x3c
    1fc2:	97de                	add	a5,a5,s7
    1fc4:	0007c583          	lbu	a1,0(a5)
    1fc8:	855a                	mv	a0,s6
    1fca:	d1bff0ef          	jal	1ce4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1fce:	0992                	slli	s3,s3,0x4
    1fd0:	397d                	addiw	s2,s2,-1
    1fd2:	fe0916e3          	bnez	s2,1fbe <vprintf+0x214>
        printptr(fd, va_arg(ap, uint64));
    1fd6:	8bea                	mv	s7,s10
      state = 0;
    1fd8:	4981                	li	s3,0
    1fda:	6d02                	ld	s10,0(sp)
    1fdc:	bd21                	j	1df4 <vprintf+0x4a>
        if((s = va_arg(ap, char*)) == 0)
    1fde:	008b8993          	addi	s3,s7,8
    1fe2:	000bb903          	ld	s2,0(s7)
    1fe6:	00090f63          	beqz	s2,2004 <vprintf+0x25a>
        for(; *s; s++)
    1fea:	00094583          	lbu	a1,0(s2)
    1fee:	c195                	beqz	a1,2012 <vprintf+0x268>
          putc(fd, *s);
    1ff0:	855a                	mv	a0,s6
    1ff2:	cf3ff0ef          	jal	1ce4 <putc>
        for(; *s; s++)
    1ff6:	0905                	addi	s2,s2,1
    1ff8:	00094583          	lbu	a1,0(s2)
    1ffc:	f9f5                	bnez	a1,1ff0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    1ffe:	8bce                	mv	s7,s3
      state = 0;
    2000:	4981                	li	s3,0
    2002:	bbcd                	j	1df4 <vprintf+0x4a>
          s = "(null)";
    2004:	00001917          	auipc	s2,0x1
    2008:	10c90913          	addi	s2,s2,268 # 3110 <malloc+0x1000>
        for(; *s; s++)
    200c:	02800593          	li	a1,40
    2010:	b7c5                	j	1ff0 <vprintf+0x246>
        if((s = va_arg(ap, char*)) == 0)
    2012:	8bce                	mv	s7,s3
      state = 0;
    2014:	4981                	li	s3,0
    2016:	bbf9                	j	1df4 <vprintf+0x4a>
    2018:	64a6                	ld	s1,72(sp)
    201a:	79e2                	ld	s3,56(sp)
    201c:	7a42                	ld	s4,48(sp)
    201e:	7aa2                	ld	s5,40(sp)
    2020:	7b02                	ld	s6,32(sp)
    2022:	6be2                	ld	s7,24(sp)
    2024:	6c42                	ld	s8,16(sp)
    2026:	6ca2                	ld	s9,8(sp)
    }
  }
}
    2028:	60e6                	ld	ra,88(sp)
    202a:	6446                	ld	s0,80(sp)
    202c:	6906                	ld	s2,64(sp)
    202e:	6125                	addi	sp,sp,96
    2030:	8082                	ret

0000000000002032 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    2032:	715d                	addi	sp,sp,-80
    2034:	ec06                	sd	ra,24(sp)
    2036:	e822                	sd	s0,16(sp)
    2038:	1000                	addi	s0,sp,32
    203a:	e010                	sd	a2,0(s0)
    203c:	e414                	sd	a3,8(s0)
    203e:	e818                	sd	a4,16(s0)
    2040:	ec1c                	sd	a5,24(s0)
    2042:	03043023          	sd	a6,32(s0)
    2046:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    204a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    204e:	8622                	mv	a2,s0
    2050:	d5bff0ef          	jal	1daa <vprintf>
}
    2054:	60e2                	ld	ra,24(sp)
    2056:	6442                	ld	s0,16(sp)
    2058:	6161                	addi	sp,sp,80
    205a:	8082                	ret

000000000000205c <printf>:

void
printf(const char *fmt, ...)
{
    205c:	711d                	addi	sp,sp,-96
    205e:	ec06                	sd	ra,24(sp)
    2060:	e822                	sd	s0,16(sp)
    2062:	1000                	addi	s0,sp,32
    2064:	e40c                	sd	a1,8(s0)
    2066:	e810                	sd	a2,16(s0)
    2068:	ec14                	sd	a3,24(s0)
    206a:	f018                	sd	a4,32(s0)
    206c:	f41c                	sd	a5,40(s0)
    206e:	03043823          	sd	a6,48(s0)
    2072:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    2076:	00840613          	addi	a2,s0,8
    207a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    207e:	85aa                	mv	a1,a0
    2080:	4505                	li	a0,1
    2082:	d29ff0ef          	jal	1daa <vprintf>
}
    2086:	60e2                	ld	ra,24(sp)
    2088:	6442                	ld	s0,16(sp)
    208a:	6125                	addi	sp,sp,96
    208c:	8082                	ret

000000000000208e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    208e:	1141                	addi	sp,sp,-16
    2090:	e422                	sd	s0,8(sp)
    2092:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    2094:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    2098:	00001797          	auipc	a5,0x1
    209c:	0d87b783          	ld	a5,216(a5) # 3170 <freep>
    20a0:	a02d                	j	20ca <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    20a2:	4618                	lw	a4,8(a2)
    20a4:	9f2d                	addw	a4,a4,a1
    20a6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    20aa:	6398                	ld	a4,0(a5)
    20ac:	6310                	ld	a2,0(a4)
    20ae:	a83d                	j	20ec <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    20b0:	ff852703          	lw	a4,-8(a0)
    20b4:	9f31                	addw	a4,a4,a2
    20b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    20b8:	ff053683          	ld	a3,-16(a0)
    20bc:	a091                	j	2100 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    20be:	6398                	ld	a4,0(a5)
    20c0:	00e7e463          	bltu	a5,a4,20c8 <free+0x3a>
    20c4:	00e6ea63          	bltu	a3,a4,20d8 <free+0x4a>
{
    20c8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    20ca:	fed7fae3          	bgeu	a5,a3,20be <free+0x30>
    20ce:	6398                	ld	a4,0(a5)
    20d0:	00e6e463          	bltu	a3,a4,20d8 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    20d4:	fee7eae3          	bltu	a5,a4,20c8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    20d8:	ff852583          	lw	a1,-8(a0)
    20dc:	6390                	ld	a2,0(a5)
    20de:	02059813          	slli	a6,a1,0x20
    20e2:	01c85713          	srli	a4,a6,0x1c
    20e6:	9736                	add	a4,a4,a3
    20e8:	fae60de3          	beq	a2,a4,20a2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    20ec:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    20f0:	4790                	lw	a2,8(a5)
    20f2:	02061593          	slli	a1,a2,0x20
    20f6:	01c5d713          	srli	a4,a1,0x1c
    20fa:	973e                	add	a4,a4,a5
    20fc:	fae68ae3          	beq	a3,a4,20b0 <free+0x22>
    p->s.ptr = bp->s.ptr;
    2100:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    2102:	00001717          	auipc	a4,0x1
    2106:	06f73723          	sd	a5,110(a4) # 3170 <freep>
}
    210a:	6422                	ld	s0,8(sp)
    210c:	0141                	addi	sp,sp,16
    210e:	8082                	ret

0000000000002110 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    2110:	7139                	addi	sp,sp,-64
    2112:	fc06                	sd	ra,56(sp)
    2114:	f822                	sd	s0,48(sp)
    2116:	f426                	sd	s1,40(sp)
    2118:	ec4e                	sd	s3,24(sp)
    211a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    211c:	02051493          	slli	s1,a0,0x20
    2120:	9081                	srli	s1,s1,0x20
    2122:	04bd                	addi	s1,s1,15
    2124:	8091                	srli	s1,s1,0x4
    2126:	0014899b          	addiw	s3,s1,1
    212a:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    212c:	00001517          	auipc	a0,0x1
    2130:	04453503          	ld	a0,68(a0) # 3170 <freep>
    2134:	c915                	beqz	a0,2168 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    2136:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    2138:	4798                	lw	a4,8(a5)
    213a:	08977a63          	bgeu	a4,s1,21ce <malloc+0xbe>
    213e:	f04a                	sd	s2,32(sp)
    2140:	e852                	sd	s4,16(sp)
    2142:	e456                	sd	s5,8(sp)
    2144:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    2146:	8a4e                	mv	s4,s3
    2148:	0009871b          	sext.w	a4,s3
    214c:	6685                	lui	a3,0x1
    214e:	00d77363          	bgeu	a4,a3,2154 <malloc+0x44>
    2152:	6a05                	lui	s4,0x1
    2154:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    2158:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    215c:	00001917          	auipc	s2,0x1
    2160:	01490913          	addi	s2,s2,20 # 3170 <freep>
  if(p == (char*)-1)
    2164:	5afd                	li	s5,-1
    2166:	a081                	j	21a6 <malloc+0x96>
    2168:	f04a                	sd	s2,32(sp)
    216a:	e852                	sd	s4,16(sp)
    216c:	e456                	sd	s5,8(sp)
    216e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    2170:	00001797          	auipc	a5,0x1
    2174:	07878793          	addi	a5,a5,120 # 31e8 <base>
    2178:	00001717          	auipc	a4,0x1
    217c:	fef73c23          	sd	a5,-8(a4) # 3170 <freep>
    2180:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    2182:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    2186:	b7c1                	j	2146 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    2188:	6398                	ld	a4,0(a5)
    218a:	e118                	sd	a4,0(a0)
    218c:	a8a9                	j	21e6 <malloc+0xd6>
  hp->s.size = nu;
    218e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    2192:	0541                	addi	a0,a0,16
    2194:	efbff0ef          	jal	208e <free>
  return freep;
    2198:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    219c:	c12d                	beqz	a0,21fe <malloc+0xee>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    219e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    21a0:	4798                	lw	a4,8(a5)
    21a2:	02977263          	bgeu	a4,s1,21c6 <malloc+0xb6>
    if(p == freep)
    21a6:	00093703          	ld	a4,0(s2)
    21aa:	853e                	mv	a0,a5
    21ac:	fef719e3          	bne	a4,a5,219e <malloc+0x8e>
  p = sbrk(nu * sizeof(Header));
    21b0:	8552                	mv	a0,s4
    21b2:	ad3ff0ef          	jal	1c84 <sbrk>
  if(p == (char*)-1)
    21b6:	fd551ce3          	bne	a0,s5,218e <malloc+0x7e>
        return 0;
    21ba:	4501                	li	a0,0
    21bc:	7902                	ld	s2,32(sp)
    21be:	6a42                	ld	s4,16(sp)
    21c0:	6aa2                	ld	s5,8(sp)
    21c2:	6b02                	ld	s6,0(sp)
    21c4:	a03d                	j	21f2 <malloc+0xe2>
    21c6:	7902                	ld	s2,32(sp)
    21c8:	6a42                	ld	s4,16(sp)
    21ca:	6aa2                	ld	s5,8(sp)
    21cc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    21ce:	fae48de3          	beq	s1,a4,2188 <malloc+0x78>
        p->s.size -= nunits;
    21d2:	4137073b          	subw	a4,a4,s3
    21d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
    21d8:	02071693          	slli	a3,a4,0x20
    21dc:	01c6d713          	srli	a4,a3,0x1c
    21e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    21e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    21e6:	00001717          	auipc	a4,0x1
    21ea:	f8a73523          	sd	a0,-118(a4) # 3170 <freep>
      return (void*)(p + 1);
    21ee:	01078513          	addi	a0,a5,16
  }
}
    21f2:	70e2                	ld	ra,56(sp)
    21f4:	7442                	ld	s0,48(sp)
    21f6:	74a2                	ld	s1,40(sp)
    21f8:	69e2                	ld	s3,24(sp)
    21fa:	6121                	addi	sp,sp,64
    21fc:	8082                	ret
    21fe:	7902                	ld	s2,32(sp)
    2200:	6a42                	ld	s4,16(sp)
    2202:	6aa2                	ld	s5,8(sp)
    2204:	6b02                	ld	s6,0(sp)
    2206:	b7f5                	j	21f2 <malloc+0xe2>
	...
