Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0EA388579
	for <lists+kvm@lfdr.de>; Wed, 19 May 2021 05:37:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353131AbhESDi3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 18 May 2021 23:38:29 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26416 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353061AbhESDiR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 18 May 2021 23:38:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621395418; x=1652931418;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=4y2xZcJ2TbK/Wj9rIB3RIw2qVKz2HbfMfu6xkxnGLaM=;
  b=j2+URO2E5qyukoiCpC0SJsTW6Oxe8PJeZvTU9Y1OjSe64rzQj7k4hrQV
   6R/cZB2MmVQMHPnAwrIr42jljrc0bJLjRz6TK3U+haphPAJHGDhuP6y/0
   qYkhbxAoCGiC5jZs5Z/OZTYwqqirvRPylRObezSiDP+rzl90mSoKhcJ+B
   0YQBEHv8p8nfTKfJdtkmFBLaR//lv03jhPSTEwU9iCtWYkfKaFJGEiHUk
   zplbon/D0lRctYk7rlTeN+v8pXAnwX1Wy9ZQxCaWaQ0sRXShkmW2ZZwUv
   sD2YwA8X7l+xz5+yFSpjspVF1U8oCTFcv3aZhWrGvaQJD6jA/3gkS/kME
   g==;
IronPort-SDR: +kr7pIgu8WBBCJCu9n9fa4ajC6OeZRxUZ4s4hYscuYX0QA1uGQ3JhoODq6FTlarXWeyMNrBI7J
 q1AM88YpBUauauUVabH/KN0JeP0cYiBfDF8EQtA3u7VMF+xor+e0PUY9tFwdY9UU7ACj30DtfF
 ussjQoFbpa/M3VmCiANoszjj+taQo+XuXdyESeDYSGn8envl+LC5W60z5pWeOJT2OcQsNFDWrF
 aqpFkA++vo9XAIgHk43ELuvRchOMB/3UufUNZmh1seBMNB21xp5pJyEFuRD8AI1RzP8ce7B7jk
 gts=
X-IronPort-AV: E=Sophos;i="5.82,311,1613404800"; 
   d="scan'208";a="167950743"
Received: from mail-co1nam11lp2173.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.173])
  by ob1.hgst.iphmx.com with ESMTP; 19 May 2021 11:36:57 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ea+2qUAyMyleJt9iLBipb9mRRUfOk//tl5OBIOB/fRFWAhGRaVlYYngv0OENB4lRdtQfeuUnI4iIZ4BwNSKfWQRNgOqQ5chI6sh9Uq+yoXOKOqpxm99zOvoxxo57ELBQ+W0ajmrZBYVNswcNr4VBznA3REh5hN//e679BjOSNckco5vG0ducPx67csOtbG7sE5qGkaDBrQw8Bg4sq1OZUpvIMxWJFwPAtWiW/s/st2rpjrHOrHnxAUqWYgzv0FLQXi54/SP3skfRauvcJvQY8Vs0XsFTTx2hDMX8kanhDWMdST0W4ZyZty7ztkAnHujJKlqMSkzoiOgGFotRH3hiiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3QKKUNElwnkRGJK8s4pmxYrCQBboPB4H20b51wZizM=;
 b=EqT1ncUIYBZYW2WVqNKbiLu/ejSwAcnpwZHT+/QEaydo79WVQ6bbyi3DWMpJJUxqq5aF3llgMjlGb5VxjpGZpnYjN1/ZObTE2g+18lsH5GheRcupXzmvT4s8OlydwPUt0GUQP/k3F0yCxE/L99EP9tt2/aCYaM2tpViHcXj+u+go7gEcN34v4UX5W1cGtESs5bTPcOKZ/7uVfYwZGE8q4bNd6DKoBHEzrfDIB9zE4AJLXsrXWl2a4nit9BKSEkDxpQo7rNrCt4auJo9uuQPbsqCJYg/CtO6zwRln8BksqHZnogHv848yT8lNgmT/dEhTkrZDKYBj4qQzqt89v1spiQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r3QKKUNElwnkRGJK8s4pmxYrCQBboPB4H20b51wZizM=;
 b=oY/YZ6xvsBNNlscHXA9vB2S1EZYTXqxPQsmaLXngTMkE5slowv+mTEppJCIqDKDWDmJnLrXP3rCVfxNDWDv1QtAFwUTkbO+jCWfnklRlb24aXjEDTgkR9xFuM/NJbg+GiK6vGV3xa5sqXvNQOfxGMVmkYkt185hqF/QpbcjNHus=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7761.namprd04.prod.outlook.com (2603:10b6:5:35f::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Wed, 19 May
 2021 03:36:57 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::88a0:bf18:b01d:1a50%4]) with mapi id 15.20.4129.033; Wed, 19 May 2021
 03:36:57 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-staging@lists.linux.dev, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v18 08/18] RISC-V: KVM: Handle WFI exits for VCPU
Date:   Wed, 19 May 2021 09:05:43 +0530
Message-Id: <20210519033553.1110536-9-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210519033553.1110536-1-anup.patel@wdc.com>
References: <20210519033553.1110536-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.32.148]
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.32.148) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Wed, 19 May 2021 03:36:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7b677a9-5d1a-4a40-383a-08d91a775a34
X-MS-TrafficTypeDiagnostic: CO6PR04MB7761:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7761DCFCC865F7E05E2A51778D2B9@CO6PR04MB7761.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Y/fcU2nGZKQcBxczBdDEcZgsD+cpbkOsL12oOWBzywfETMibwHPy/rPsCWB+JzMu7Q9irIr89VeoUz6RXc+jkdoa/crgoi1HvjuNm8jwJu5QNWNlhZ15z8EMQ3TnHdvLgXcknoZKRDjRxkv3S4vLVO0rquRBaX/sPiu+k3RBhlS3cpfTH4pcVxKPxN3SNz83O1ivbkkYaTpGe6ONKngL51Lzv+vI9P8TLdqVmSHxWahE2pUowOCsH1nPVPmxiFhVJzFwKfY+gj0OXdIhkVK66wUttN/HpjahqdQtJGh3MChhbrXInX21wteTORaNc8wUvLw8gJBRiQn9i5Hz1j/ZxVYn75DjqOCP1CgrNnc9ggbWrhNUsGyXyFVFAk0VQdDU15XMXfZHOy4R49Wjg8lhDir1NxiIXAiwouMOlVAImtuHipDXbOLeWvdIRHjs+OEMuJJPMHAvkhc7PR2AD+wFPx2Ok1muExwnS62HuNXQ0fa/Z8u4+7rSQIZut5mQd7Zwk7I2mUPqkeVSb+cOr+n35hVzDGMo8i2ciTAejw2GkxlgwUyHhX1dtriX5E/4ckR2kMPWVjrW74nmnnoS6IfvduTanU0NLrC1RoVcuKg/vZxcyuMj6aXGw1IPxMC0qcli9kl7ijyVYVUeQoo9OX1UCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(376002)(39860400002)(346002)(316002)(38350700002)(55016002)(38100700002)(66476007)(66946007)(1076003)(2616005)(186003)(5660300002)(4326008)(26005)(8936002)(478600001)(86362001)(2906002)(52116002)(7696005)(16526019)(110136005)(83380400001)(8676002)(6666004)(66556008)(36756003)(7416002)(956004)(54906003)(44832011)(8886007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?fnZZjx7wl49ukcxtNNP3to6aQNa5Qw3lRnzmtNiypf3+GVFuu5GwCU0V56cx?=
 =?us-ascii?Q?mRx6CzVG6Pr66XTogDYIFgi1NywRDBXrebn8ttMxwoBIX4FMfSWkMQAfLu56?=
 =?us-ascii?Q?YpiCPvPN3jpz7yh71DrNOhuT89wkvifPrCy1dJ79W/EKyE5lqmkDXp9Qdogl?=
 =?us-ascii?Q?isgbEqIbNK5i8X2a89mQQRL+UH55rqiOxqrXWDOeTyNti8mfKIm9GAC90w3I?=
 =?us-ascii?Q?50qQQkYMO7Md8Q3Md5Uoyb4ipUDFG7m1uVlQthbDxiJIhEdBPUuc/wHiIbQu?=
 =?us-ascii?Q?MKKTh7l3PSncSi/tYzpGvfqnNmq7g5g6kzeV9EkcmFXkAidzByMvgWY92mIC?=
 =?us-ascii?Q?oBBFqV0UlzqYWQeQvGiJzepM7H6nPNZ/oo+9uVoif6AI5wJ8AjfzdpMEdMIQ?=
 =?us-ascii?Q?Ul5qARd6YgWC6WiyCZDlG7bxYLxykxL1FoOeQdlRcdbhhIjOfZTHvChj3kuv?=
 =?us-ascii?Q?ldAhtJrsqnGhK9oKC4p7RMBkivS8QVSWC44hrhCloS/uCzReWRcKBGgBKmPe?=
 =?us-ascii?Q?mQIbsIdwuBXs+B2czobi0XUGWCMEes+t9LxFfq0vL6p5OJ0Z4aH5osNaWuJu?=
 =?us-ascii?Q?n6maiXareOD2w5NqQUyObFmHCjynjo5iG6Nf82wl88qnxRW0zOvyODlkpexU?=
 =?us-ascii?Q?S6pLnEgp/VmnJ1hMfnLfPtkmE86OxVXtQVmVVALG/ylF51kTcedt9DB3/c/l?=
 =?us-ascii?Q?+HqDZMRayAmdVQHNelzDVjyf8ZH4arFCkREI29w7+RQ4r5EhotQUuO6cdGDc?=
 =?us-ascii?Q?02DZgMOXyzExbwRBNrlcsrn+eiaDZh4e84MOZQHiy+iIycrKarNamPo7nbVk?=
 =?us-ascii?Q?+26kczBH/xtTo1yY6WsBVfyht3TcjMTWyWE1ULZz+9WPfKBKqQ6xDN0Fw7P4?=
 =?us-ascii?Q?/9qtdJmL0OSZSWsOXznXR2iJNzy4S45/z3rqhxMT7NTVgefBmEVEWMz1M7iF?=
 =?us-ascii?Q?UzeYIn7D9pxBZLcdBTUGCoNCw2Xt5c1ttVjnuUQKlF9Zqnvt7O/QUuC/5oVC?=
 =?us-ascii?Q?dQdnRA5vgAJRGkZpqE+vycU14l75mEiPWp4U2Ves/3nH0r3I4aieIS2+qcY+?=
 =?us-ascii?Q?JQdFMb9BJa68iCxp+w78olR+eA1JgvXrzZvy8Jy59YU2v24AgllPvCHb8LV7?=
 =?us-ascii?Q?Pm/Lm4r11a4ux9BlmR0lpRlhxr5Cd9pu99B2ewRI2hZsM2VJhUXbMxHJAjke?=
 =?us-ascii?Q?JxDzKWvB/v4ikLAsalECYwR8TL7+I049GS1Zn/N5YcAVZhu3LcaoImVKnYDB?=
 =?us-ascii?Q?255eMtaldAKtF2aQED4pK4rQEskqj2APr9heTRqG2lP969yuSnpAOX4O90HR?=
 =?us-ascii?Q?yjtGNrM+SzDw8L7x1IqZL3Fw?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7b677a9-5d1a-4a40-383a-08d91a775a34
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 May 2021 03:36:56.9693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeXLzhzqzesI2RxHpmurEWptNAvdOBwulW/TDfBaZCAPwGZzZTa/Q5S87owb1if+cc0fLYdV7vWBU2B03g3n4Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7761
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
index 80ab07ff0313..34d9bd9da585 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -12,6 +12,13 @@
 #include <linux/kvm_host.h>
 #include <asm/kvm_csr.h>
 
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

