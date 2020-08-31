Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB85E25797F
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:39:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727814AbgHaMjc (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:39:32 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:41578 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgHaMbW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:31:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877082; x=1630413082;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ghaX9Nnm/6B7rrBrZrSFoUPU/fyLdU7mNpiGcNxY/i4=;
  b=QE2kk277oAzkgXbNqATIwMuDuk4HQFyszm4TDDxKEovm6SbXHZf1Qrwh
   1Z5JSQJPvhbpiDcjKcLQFH6vYjxPAb4qNMc2KFIAPrNhfaez+Vt2Yme5T
   a7lzNktSxD/Tg6LgrsuU6ZvtJR/VbnvWjSlL2yr1cqgx6yv74E5q/5Uov
   mQG+e+3iJbyb3d+L+lyMyOsBy8kj3Eul9rFsil9NesCFiXq69We82s3dz
   l/Qoj86VQ7y8R9eXJWkmmMvxQudyCfEgEh4DteO3fXiP1uY2w9pmInpta
   Uc45Ctq2T4K9G4/juJ2CFQWdLXd18Gr6sfW+/TsAxlppG+CwTSetvpr7U
   A==;
IronPort-SDR: AdJHITKgrrcvOSIkKIa/dKfdw2Iv3GUzCDD/u6bLNnzq7iwxTD6mM885w+G2mFqJRdNlMD+34H
 Aa+W0YTgBf49mlS9OyeptuhckjigNKlKBQ4pe+HK7fR+zuTQQtARJ2uQbkJGodMJtUHHXwCAcY
 CK6oa2adC7vm54dnnNHiBZ6jE5vgD7AzkVKfVaPUX121FkaI24ugc1sNfA/1EvAGoWLVLpQ8EJ
 ABLLbUoCWW6LCexNyjXfa4LD/sgZYeN/dLLLX+qDDDddEcKtUUW19VBk36ZRa26WduCGsUMi6i
 ekA=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="150559625"
Received: from mail-dm6nam12lp2176.outbound.protection.outlook.com (HELO NAM12-DM6-obe.outbound.protection.outlook.com) ([104.47.59.176])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:31:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hxj8DtfqYAFjMbXT7bP7SGTs0zirkOzqdEpzW2H9PzOFsMNm1mITgEq9SWXdZDZXKoRtwxyae++kZM1h03hZ62DxB+5OShxgvtm30UzQfZ3vnxF3Fn0rmxHzxZoBqo9ud/1sFeKPOGcNn0EI4BFNOu5Lu1jDZhFpXOY06Mb0QeOFG9b0iCWt4mZxXCdvb8hSAvppaHFXasLAhMcRyDGg+wpIaeQNxIUgK5Edz/LlT8byDQMzrLGvD3O9qp/G5xlsAMzHXlF9alZ0Ubs9hB93LgrWnI4JgmBoxavwtKuRB6cGqAfEYyeArLsbcEx+L+A5Zu2WkUEi2jzly0vK+wIeDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PR3zdpZMW6sNSMOOUCyFGCFvMiMQ3H5DUeMJO75MuX0=;
 b=egpONq83Tde46l2+/T2H6r4FlTtNmFFR1M38hnuorqr+bbB53t2s0oySvdd3UPipC2z9F9u09/0aUJ5Meaczje7Yv31dBsyDOsysYs2mZ/Wy8DP+7Th4hEn8TIMFIqzLkeBN5MI3lg7XkwD9kQuuLyj1VBSXbIPL3Rr+mAD4yB0lyFC4joakELsNcu/i9uTIPxCZkaNyJhAw8YKN4GtXA8GTbCQm0wIt0wOwXPyaVbKXloJ+N6CUAQXWAmp7l8YseqVFh1wCMFrQEVqhG7OrWZkBTZO2Eqoo6pCITSZcz9nJcyYcpTRA0JykVEAELgaLWrI2PfrxI89r5ALuMFcWDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PR3zdpZMW6sNSMOOUCyFGCFvMiMQ3H5DUeMJO75MuX0=;
 b=IRCZd4zcHXTQPzb2gMKcsvgiabb60Ayq/PNtIgcnrigWxbhWlpArcCmxNpFW87yYjmeCOLTSOX61lsNzOzS6Qq5fXoxxDPLQiuqhMLiASs+YEFICduAFVqLaw1Lry4dGhygY1gDoAaRkNH6tM7QBUOmpfrEv57fFdVCiMCfqU+w=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6092.namprd04.prod.outlook.com (2603:10b6:5:12b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Mon, 31 Aug
 2020 12:31:19 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:31:19 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v14 08/17] RISC-V: KVM: Handle WFI exits for VCPU
Date:   Mon, 31 Aug 2020 18:00:06 +0530
Message-Id: <20200831123015.336047-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200831123015.336047-1-anup.patel@wdc.com>
References: <20200831123015.336047-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:1a::32) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:31:15 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7eaee48f-b41e-4399-0ff1-08d84da9c340
X-MS-TrafficTypeDiagnostic: DM6PR04MB6092:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB60926E2315EB0B2A178013488D510@DM6PR04MB6092.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YrdJI0uyod98pd18AKVVUkKn4Qo3OtxPBlYNH94ajKTce/QDD7dHYue799Uth5Oy0SpvfED4uBEfXMaYOcCvgxXKBg/9ctPP+9QJShYS3vdla40jT49mHdI5Kr6oHx9iQ4+xZtvfidjf/ra9uK37COhFaJNevE3u9455pj4dvMmhvFF++6iWHKqVpv1eyBd4Ih8j9YUxEAmL+v5Iv5lauco9eqk+K8yusnD8FQbCpXVUuANKF+gVJcvxy8V+id5kqTBP53J8yoKys7cMyFWjLB4+JyFj3lpDwiZbr8FYMeAoGzqSozR87fyZDn6gOxmRgcKfcnXRUhyKeaXkC9WTFg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(44832011)(6666004)(52116002)(8676002)(86362001)(36756003)(478600001)(6486002)(7416002)(110136005)(8936002)(54906003)(83380400001)(66946007)(1076003)(66556008)(2906002)(26005)(186003)(66476007)(956004)(316002)(16576012)(4326008)(5660300002)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: /285DchtIytjs+GxZ7hK+cDRJkjH0BWDoZLwfVu6QHt1BkF/2QGmKRcLb0x+p5KqcNJeH04KE0wHxmlKpeVmvEDpdOs3sNi7yHjWxms7HN5Uh88eNl2blWbWnORhYPnty0/Pc0CQxHhDxWNFqK0NMGsLMSglHXCm1lIIZyKzUWd2e39Pcu5Iegj2jpjdMxrGbgL1Ii0OFFI3mpEUwNXVPK6XGc2FZhZ1hTZ0knxqKb0M/Zq3SIdr2RMllbNnXZWSe/dptiqmDPM77IxfYecDTcekYlk5vEbhChoUOPAAIVgpKdo4FGwpv5dTvNc1o1ds3zRdjNq5v6tP6lB9oiLMJ5q6cSN9yTgJl7vljMwqmJuLstJ61f1qDTURS9Z7udbsmYhK4qPQqwUK+Dhvnqvw4V5462DbeIy6qlm0bez5GOzCMdlQxHqI9uOSgzsXpMXlG3DeAiIbhaY5AEQY2jfGEw0qqQ2lKMSmwMqd0JgxOINkDz+fNKL0yoS78fEuhQlHtB1Ri/ob+YaxND8d1ZZZHEQmBopd4M+hJDAhQj7sz/1umHuf3ArVq6J6HiqIR9fXjeERYMvVCsA6IgA/kFRUT/9RehWbWzryjPPzH7soIVhIVvAerY7F+w1pKmHwqlSCwQs2pM81UB0bjRYkJ78C/A==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7eaee48f-b41e-4399-0ff1-08d84da9c340
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:31:19.5451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hvXeonAJoa9POzUgHhBVeDg0xSNUcahFs0UJxIHRCArWD9xPz33teTYWrfVpx+PUGdp3RB/puJKaWi5tReQw6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6092
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We get illegal instruction trap whenever Guest/VM executes WFI
instruction.

This patch handles WFI trap by blocking the trapped VCPU using
kvm_vcpu_block() API. The blocked VCPU will be automatically
resumed whenever a VCPU interrupt is injected from user-space
or from in-kernel IRQCHIP emulation.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/kvm/vcpu_exit.c | 76 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 9a0d2a57ced5..1324b95d3044 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -12,6 +12,13 @@
 #include <linux/kvm_host.h>
 #include <asm/csr.h>
 
+#define INSN_OPCODE_MASK	0x007c
+#define INSN_OPCODE_SHIFT	2
+#define INSN_OPCODE_SYSTEM	28
+
+#define INSN_MASK_WFI		0xffffff00
+#define INSN_MATCH_WFI		0x10500000
+
 #define INSN_MATCH_LB		0x3
 #define INSN_MASK_LB		0x707f
 #define INSN_MATCH_LH		0x1003
@@ -116,6 +123,71 @@
 				 (s32)(((insn) >> 7) & 0x1f))
 #define MASK_FUNCT3		0x7000
 
+static int truly_illegal_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	struct kvm_cpu_trap utrap = { 0 };
+
+	/* Redirect trap to Guest VCPU */
+	utrap.sepc = vcpu->arch.guest_context.sepc;
+	utrap.scause = EXC_INST_ILLEGAL;
+	utrap.stval = insn;
+	kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+
+	return 1;
+}
+
+static int system_opcode_insn(struct kvm_vcpu *vcpu,
+			      struct kvm_run *run,
+			      ulong insn)
+{
+	if ((insn & INSN_MASK_WFI) == INSN_MATCH_WFI) {
+		vcpu->stat.wfi_exit_stat++;
+		if (!kvm_arch_vcpu_runnable(vcpu)) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			kvm_vcpu_block(vcpu);
+			vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+			kvm_clear_request(KVM_REQ_UNHALT, vcpu);
+		}
+		vcpu->arch.guest_context.sepc += INSN_LEN(insn);
+		return 1;
+	}
+
+	return truly_illegal_insn(vcpu, run, insn);
+}
+
+static int virtual_inst_fault(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			      struct kvm_cpu_trap *trap)
+{
+	unsigned long insn = trap->stval;
+	struct kvm_cpu_trap utrap = { 0 };
+	struct kvm_cpu_context *ct;
+
+	if (unlikely(INSN_IS_16BIT(insn))) {
+		if (insn == 0) {
+			ct = &vcpu->arch.guest_context;
+			insn = kvm_riscv_vcpu_unpriv_read(vcpu, true,
+							  ct->sepc,
+							  &utrap);
+			if (utrap.scause) {
+				utrap.sepc = ct->sepc;
+				kvm_riscv_vcpu_trap_redirect(vcpu, &utrap);
+				return 1;
+			}
+		}
+		if (INSN_IS_16BIT(insn))
+			return truly_illegal_insn(vcpu, run, insn);
+	}
+
+	switch ((insn & INSN_OPCODE_MASK) >> INSN_OPCODE_SHIFT) {
+	case INSN_OPCODE_SYSTEM:
+		return system_opcode_insn(vcpu, run, insn);
+	default:
+		return truly_illegal_insn(vcpu, run, insn);
+	}
+}
+
 static int emulate_load(struct kvm_vcpu *vcpu, struct kvm_run *run,
 			unsigned long fault_addr, unsigned long htinst)
 {
@@ -596,6 +668,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 	ret = -EFAULT;
 	run->exit_reason = KVM_EXIT_UNKNOWN;
 	switch (trap->scause) {
+	case EXC_VIRTUAL_INST_FAULT:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret = virtual_inst_fault(vcpu, run, trap);
+		break;
 	case EXC_INST_GUEST_PAGE_FAULT:
 	case EXC_LOAD_GUEST_PAGE_FAULT:
 	case EXC_STORE_GUEST_PAGE_FAULT:
-- 
2.25.1

