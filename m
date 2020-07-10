Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6756821B13C
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 10:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbgGJI1S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 04:27:18 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:48031 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgGJI1P (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 04:27:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594369634; x=1625905634;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YOQ+hPCpwSHRidOg5gq/99X9NqVQOChEel3RArp9LBk=;
  b=dggGeIUX+W/L6LdzyUSkqNCQQmco5/wb7vePcztsA0VUTcnr9rOmhFf/
   8ne8mnvjmZcnmbIxYfJ2jpLB141y4bcmZmSvuMiT9dYg9M350zqlABnsT
   TPJaMhe5exTnqKV+DpBo6a+bg5q4sSrkd4sWUGooAMLso+ld41RJL4MtX
   G0sMeWvogjHq+gfmscJbcYF/b2NEp79sakgD4bjCZuqpFOXTJEyJ6dmJd
   pbybWwbjnC5Wd697ZK9ElGbGZDX67ndb//OWwRgPQlRgs5L4A88A4o0YA
   c1pC4xiX+25q7A8N7pcV895G/LU52FK+QZs9kgA3dNlh420ZdjCJ09Ryh
   A==;
IronPort-SDR: 04HFJO0qRCNcV5+0KmMM7liXS3IZIns4A+Mpil/nhdvDB10NJBRhwq5PBJV6Bz1cd+o460tgTo
 JiLbL7GedO8oFps3ktj5hN/ryKLdJ3th82QjCRjUhhu769nsVglN3cw8dPYYrKmaYCbVYT9uBT
 sj6w7d+yhkzPn7QJB7nNmO3oaMS63UYTu6rRnSBQ0QC0QZulINIneXO+aNwlDXSArjHUkXxUGs
 TtOgVp510vpUu7EJ+fau9ZXU1vm2FqUXJNg8BcYvbGkIBQLVIWn5MoJzh0tjp+k1uP8gun4RlH
 dss=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="251355664"
Received: from mail-bn8nam11lp2170.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.170])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 16:27:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dmRWD+UklhsjKqCkvrNMs+badZx4dJ8aMQtHxT7xlkn8emvBQK//o1alCxZOW1CE9FsmjfueYqJnH9WhYXjzf8mk0KcIHnwhP1dMtPzivlYnFYUUTPewOgjKmw2KO8NfDdH1YFZ6BDgRnNSpmSUlCVgwGGiTDpLXM7kw9BSlXDxxRPJja/6RXlNcCgqm7I/aW/2qOXojbF4EMG5pFlqYM3Hj7xCC1reBF6obKa6I4xsbo+FehX8hJx9NQqoid6nw3EH9vkY7+1WLVFEKq4UjqLOex8YacIh43+/P6qfrxeX0h6wjhTSyQZ5uQeh96KIl7M56XLnT5GEwi5eJB33Bpg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrwZ2eJ3YiGc7ea+vchq5LweXbt4iL6y/tD5wAvRarA=;
 b=M/XqQRzp4fjfVZA48EdwK3fCYXllyk1yrPgz3EBCKk006mNdIv2fYiX0aQnnsFFEGXLtRLTmK6URH55jdHiQgAa3klBhOylI0LVhMy9vdCIJ8zT27SltdccDxTTyeNp8hy2Rpty2iUPcbpxrg8z1u/Y3xAxhTfoGvFFsJH/5PI+GoJt4uNf3OW1OnBDkZ1pv3VQ+o5mWe67Z7k+BULVtJN4tIBjeN5JJxmHQ7zB3yeQtIUIyXQnzhn/R9XLHcQAH9ar4oqsjzq9AG3kEj8bInTXTSBifZghbIePZseQaZ0TD213xQPuc0LrO3bnhH1Pxt835yj53YzT/2cXktTTZBw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vrwZ2eJ3YiGc7ea+vchq5LweXbt4iL6y/tD5wAvRarA=;
 b=aIwKKYKral4Iq7CjC3qEhyL1yDSnTiluIOhXwLHQ74twEUwLk80HZDiTAaFGYRFHOgmnaACedzA3CugSFz2sPTIC9T93JOI4dS0j/OT+Vj5NchdqMczT736O+IAHAg7GC5RSY5w3tiO/u2a53xxcHkaOhvI+zzdqJp1RHJkNRoQ=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0461.namprd04.prod.outlook.com (2603:10b6:3:ab::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Fri, 10 Jul
 2020 08:27:12 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 08:27:12 +0000
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
Subject: [PATCH v13 08/17] RISC-V: KVM: Handle WFI exits for VCPU
Date:   Fri, 10 Jul 2020 13:55:39 +0530
Message-Id: <20200710082548.123180-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710082548.123180-1-anup.patel@wdc.com>
References: <20200710082548.123180-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::21) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0035.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.20 via Frontend Transport; Fri, 10 Jul 2020 08:27:07 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6e64731f-2826-454e-02d3-08d824ab0b24
X-MS-TrafficTypeDiagnostic: DM5PR04MB0461:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB0461A2AB321923D36853C2658D650@DM5PR04MB0461.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 046060344D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2PKwaC7vuqO9pVbsJXppvGDx3S+1mLqWEqrB/Y8+RqR07eEvRdtncTQaAG8bJJeULVuQGMlSxfteTP32cjVpN11+lQDPpiajlGqM4ZMcloCuJIq8FnofWWGKOMj9rFWv98hlIt2j1tJ6jCiMLzfFBuwF3y5T02My8D20Y/nBVTuLCz/+qxzYDSSMUpayNgRu/natJvaGhrU7b6siZZntwVrs69dFM5maNyWZzHCMJB9ZHI/PE3OdPBPVxKYDmHwrzrXavQj5kFjG8D/qgJSmiF+zleIGzyMr/ZKlpGDsphyz4q+td1nPgTOrnpeaM86imcwn/7jS08KNXwTYvkyaYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(2906002)(316002)(83380400001)(110136005)(54906003)(7416002)(478600001)(6666004)(86362001)(8936002)(5660300002)(7696005)(4326008)(2616005)(26005)(956004)(52116002)(8886007)(8676002)(186003)(66946007)(66476007)(55016002)(36756003)(66556008)(44832011)(16526019)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 9Sg/3mHNQM7Bx1cop9Yv51P04mQy/t0KkytWoNvBZWIW3vk41xXdd3Cw8jUAOnieuvcRjlwpKUsT5ua+91vEBpsPHO4v6L3t6kbTIZQ7y7Rv+qO+Qqlhblsy7pHAZeTEI+ZSaaeKQEW1jN51rOQ8rD+abOtWhRz7AkFXilcHjNYn6hWS4D8lzX+sc1WtVZjOKbTUIKYJjTbccWoBwtxmVJYrgbV9Z0EyOfh+1mqI3nVYbuQiwvd3M7AfUxkUfrK7n3rSjdD68r10EAcnw9TtOommNKGTSchvsJefIyYkj8xFEgX287fb0tju5Ipiy3vy5VQtVznAESPsrhqVtN7eaG4PKUXwPZVdiX7uFl3DillsiWuKIrhne2UXpM/t7KD/MN/5K+dg71nmUXY3I/RJ8xjociDgdInj7CwA57etmVKdnvoACip0FxgqsEsAwNIbOYroXm55J4Lw+24eiMkLeaWrEOHwK0IO/QXt4IYzxZ8=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e64731f-2826-454e-02d3-08d824ab0b24
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 08:27:12.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZYPrOGL98Je+Wq3ibSxlPkNdcsFSqoCauRuxrae9wkjQ7uvObbpjh0qzS+UzZqjtbBY1CwtMaTJlmuGJsk/kkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0461
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
index 7fd603acd97a..6ef833e29e71 100644
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
@@ -565,6 +637,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
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

