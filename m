Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B75B91841FD
	for <lists+kvm@lfdr.de>; Fri, 13 Mar 2020 08:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726736AbgCMH7R (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 13 Mar 2020 03:59:17 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:9494 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726328AbgCMH7R (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 13 Mar 2020 03:59:17 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1584086356; x=1615622356;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=8N0OUhOiyjad3q5liHiwfmJheW19P5lSLo1HZQrOcpY=;
  b=WW+8au8Ct8Z32hqBsurZejLClsmqT/p1W7GG08PgKRVYY61T31CLV+9H
   7Nd+BuBee6KyaL8PB1JVzvX5CDhObz5gEhFKps1BshZNa9Od/MkE/y7Qa
   Oxj+BnJmjTYUNadBEIwwZX+bGMbi9h0t06Dj3WJN3SzoN+KnNRvTepciv
   i9L45+car84qzvTdu/mNuyzXWOGP+Ly/vMwF1w2mVCXgyLpFTUBydzJ0h
   HyMvhSVjvB4cCweJx+4qbYoQLdIRSfqSgZ480PXRgl2QUfpkO0/OJ16uZ
   KXwT9chb1AToQUQUq6ZtnChW5DbvQviBZsZ2SZGaVOnPr/wV6KNlVcoAU
   g==;
IronPort-SDR: MlVNX9pvAt6lXJadf95Rv0DhtTv47YJUw9RvctNOH2K7rmDoA6WYjCCy6mJWJcm+8ke5OP41tQ
 vruSBIkhD5aKBPPyTmqsPrSci34fGF48oP7RQgV00d4zO/JFvnn7D5lBq6lXqYkM2kcWbIPUDA
 GaLbB8KrM6zgtR1/ZzIfgTsETrblxSkLx2C7BoU/WPWhrTr5PErKglFrATH1hlNZ3yxibd0nol
 NQVx55XQre8/7tjPY+1/gzO0B6ZxG5YgYPU/fFh1q2ZDsBjLAbO6NIaqURRgs8Nnhz7aariwNA
 d/Q=
X-IronPort-AV: E=Sophos;i="5.70,547,1574092800"; 
   d="scan'208";a="132827939"
Received: from mail-bn7nam10lp2107.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.107])
  by ob1.hgst.iphmx.com with ESMTP; 13 Mar 2020 15:59:15 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lx3heKZzHLsnGJWgD/IbrBdRzaaA5O9H6cYhWseZxWMfFhZOwmXYlUyoAGb0sgVRbWzDGG6FX+7vZvJTxB/RHAn1QQb28l3lpVgh8CFOTRsL+btASAwgIYTzrerW8p7e9kiYT/TgsLlDZf/vb2az9gzN/48rS/gWWhgQESEIILzy9LXWSw94rFwyah93CmHdwV5DSePCaLS3SobNGsqxWksjF3GgFMxZRYlRjubtI39E54BkHDReh5IFwoVCrYsI2Nr9aRmk88FyF6Cd5VL4Ky2c+UKowDzMGsizqn+NzwKr7yK5FGufmg7Jdj+GKHFm1j1s9i+OEJoHU+CyD+SSrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgAbgWUDX0y3CP5SgSa51Sz/Xj7CmdE3QtZSGl21j28=;
 b=TBEMa75zrBZNvQrrnFElZnnmKxzZjXVXuA9LInIo88eouvcme1mM6HiF1CE9Ousz2vyrHHgAibO/tm3ieVuo5zuDmsbSmheMrnItIWybCQUNI3bfEl/p0HXtK5QdIgrqah/thYguHmDczxk1Ovo7/XDhboTsEJapZlU8nnG0GFr2SVETYsknziB8aP2BdgnA6o39T/S8aGu3ccgUq5wLbwe05WIHmcEdsCXGjhqf9P86tcCR7pLtSHblcjJ2nIjBRw/YPBfcBypLG4IsjnmLuGTZPpSGk0bzdQUCCBjJuAZGdyI+BzPeLIiLf6b8Pq4jAIPgKOaSL1pyZAQrdsAFJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgAbgWUDX0y3CP5SgSa51Sz/Xj7CmdE3QtZSGl21j28=;
 b=lK9vc8ihcgV8HrOjdMFcbewxoPeDsQJHgGt7oWe0K9E9dKW2cjykhT6+VUGvZSK7vTPXNUSqJnwV2DuEH5EZhZFp4CgdHwBxOue3TTxxqZfrX6rgsbs5VuBT3PTntPdJOuWFasPhL6IUfKiDhT1AMuGW3XylLGGfNGXYOlGOcaU=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB6319.namprd04.prod.outlook.com (2603:10b6:208:1aa::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.16; Fri, 13 Mar
 2020 07:59:13 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2814.018; Fri, 13 Mar 2020
 07:59:13 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 15/20] RISC-V: KVM: Add timer functionality
Date:   Fri, 13 Mar 2020 13:21:26 +0530
Message-Id: <20200313075131.69837-16-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200313075131.69837-1-anup.patel@wdc.com>
References: <20200313075131.69837-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:20::19) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (1.39.129.91) by MA1PR0101CA0057.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:20::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.14 via Frontend Transport; Fri, 13 Mar 2020 07:59:07 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [1.39.129.91]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 0eb08fc4-c350-44bf-f330-08d7c7246b46
X-MS-TrafficTypeDiagnostic: MN2PR04MB6319:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB63199A7B68FCD6C203491BC48DFA0@MN2PR04MB6319.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:862;
X-Forefront-PRVS: 034119E4F6
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(396003)(136003)(346002)(366004)(376002)(199004)(1006002)(478600001)(2616005)(956004)(8886007)(8936002)(7416002)(36756003)(81156014)(16526019)(81166006)(1076003)(55016002)(186003)(52116002)(86362001)(26005)(44832011)(7696005)(8676002)(54906003)(5660300002)(4326008)(66556008)(30864003)(316002)(6666004)(66476007)(110136005)(66946007)(2906002)(36456003)(42976004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6319;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Wq3IYrLoFfYthh60a6NbJpLj6ESbg1SJWe5tti5QUanNi/RENpwPJjrwtyLU1S0KqP1fpqIrkb2DJHgaum0wjCPBfCONbBQRuCVUCVztwy6CX5Gsq54X4qIEPULvNCeg2sDUh3dneNR7hFmq3fHZJlSHPlPZhkmXGlxlvqD/009mjC0PfTIIytGutMMPZpgc1fuVMWuAxzjKX9YoVzPthsLX2g6iHaBygLX02JwEMmqrOY4pC9fI66L8y5Li32HvMagr3EubZxTDqkPct9JbkgbmETn2WnWfW9Wdy+WLXcKRwczWsu4e7hnhlfFcQaZrZu92YrT3IytDILavEwH0UcpN3psmeyyVDIcOoVn4qywK0FHOe25EbYTkHVVOw2+pg6W/ezKGTrnJ2qPcgj1RpjdpC+FHi1In4q+EFHjl1k3fBF0GzIcABkPvrfMMm6EXfMLBI9Qf1qFqUVG5y+5Rkg4UjM0uswkkqPJK21xs0WG7H3NYP7oW4Kdawt1K4g0JsBaKJEL1KNgmJv1GlWY9aQ==
X-MS-Exchange-AntiSpam-MessageData: wuoMAbTDIkxq2ftM5U9d9nqO6T5fSMgmFycb6HEXUBZpbZptqVBwVa8zpiIOJKIYA8aUbYcdnDlhFDTBmw6aQv2b5yarifB0T7Tqp8B5F2IW8vwRqWpOjpYbQFmYAH5BwjgJ51DBfCbOpLiMefye2w==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0eb08fc4-c350-44bf-f330-08d7c7246b46
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2020 07:59:13.6742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rIQS94JGZX7YmSW/OXXIpl9mGuupH6ydAwkb09QlUSSRCYHyFo0S4DrmkMithNBy5gakmnMubuzTi8lv3E4+AA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6319
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The RISC-V hypervisor specification doesn't have any virtual timer
feature.

Due to this, the guest VCPU timer will be programmed via SBI calls.
The host will use a separate hrtimer event for each guest VCPU to
provide timer functionality. We inject a virtual timer interrupt to
the guest VCPU whenever the guest VCPU hrtimer event expires.

This patch adds guest VCPU timer implementation along with ONE_REG
interface to access VCPU timer state from user space.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 arch/riscv/include/asm/kvm_host.h       |   7 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  44 +++++
 arch/riscv/include/uapi/asm/kvm.h       |  17 ++
 arch/riscv/kvm/Makefile                 |   2 +-
 arch/riscv/kvm/vcpu.c                   |  14 ++
 arch/riscv/kvm/vcpu_timer.c             | 225 ++++++++++++++++++++++++
 arch/riscv/kvm/vm.c                     |   2 +-
 drivers/clocksource/timer-riscv.c       |   8 +
 include/clocksource/timer-riscv.h       |  16 ++
 9 files changed, 333 insertions(+), 2 deletions(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 include/clocksource/timer-riscv.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index cc0b09918431..b547f79c2e49 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/kvm_vcpu_timer.h>
 
 #ifdef CONFIG_64BIT
 #define KVM_MAX_VCPUS			(1U << 16)
@@ -64,6 +65,9 @@ struct kvm_arch {
 	/* stage2 page table */
 	pgd_t *pgd;
 	phys_addr_t pgd_phys;
+
+	/* Guest Timer */
+	struct kvm_guest_timer timer;
 };
 
 struct kvm_mmio_decode {
@@ -168,6 +172,9 @@ struct kvm_vcpu_arch {
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
 
+	/* VCPU Timer */
+	struct kvm_vcpu_timer timer;
+
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
 
diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/asm/kvm_vcpu_timer.h
new file mode 100644
index 000000000000..375281eb49e0
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -0,0 +1,44 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_TIMER_H
+#define __KVM_VCPU_RISCV_TIMER_H
+
+#include <linux/hrtimer.h>
+
+struct kvm_guest_timer {
+	/* Mult & Shift values to get nanoseconds from cycles */
+	u32 nsec_mult;
+	u32 nsec_shift;
+	/* Time delta value */
+	u64 time_delta;
+};
+
+struct kvm_vcpu_timer {
+	/* Flag for whether init is done */
+	bool init_done;
+	/* Flag for whether timer event is configured */
+	bool next_set;
+	/* Next timer event cycles */
+	u64 next_cycles;
+	/* Underlying hrtimer instance */
+	struct hrtimer hrt;
+};
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles);
+int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg);
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu);
+int kvm_riscv_guest_timer_init(struct kvm *kvm);
+
+#endif
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index 3a20327242f1..8f15eee35a1e 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -73,6 +73,18 @@ struct kvm_riscv_csr {
 	unsigned long satp;
 };
 
+/* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_timer {
+	u64 frequency;
+	u64 time;
+	u64 compare;
+	u64 state;
+};
+
+/* Possible states for kvm_riscv_timer */
+#define KVM_RISCV_TIMER_STATE_OFF	0
+#define KVM_RISCV_TIMER_STATE_ON	1
+
 #define KVM_REG_SIZE(id)		\
 	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
 
@@ -95,6 +107,11 @@ struct kvm_riscv_csr {
 #define KVM_REG_RISCV_CSR_REG(name)	\
 		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
 
+/* Timer registers are mapped as type 4 */
+#define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_TIMER_REG(name)	\
+		(offsetof(struct kvm_riscv_timer, name) / sizeof(u64))
+
 #endif
 
 #endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index c0f57f26c13d..3e0c7558320d 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,6 +9,6 @@ ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs := $(common-objs-y)
 
 kvm-objs += main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs += vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
 
 obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 186458eddcfc..f6986c603c9b 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -51,6 +51,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
 
+	kvm_riscv_vcpu_timer_reset(vcpu);
+
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
@@ -78,6 +80,9 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
 	cntx->hstatus |= HSTATUS_SP2P;
 	cntx->hstatus |= HSTATUS_SPV;
 
+	/* Setup VCPU timer */
+	kvm_riscv_vcpu_timer_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
 
@@ -95,6 +100,9 @@ void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
 
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	/* Cleanup VCPU timer */
+	kvm_riscv_vcpu_timer_deinit(vcpu);
+
 	/* Flush the pages pre-allocated for Stage2 page table mappings */
 	kvm_riscv_stage2_flush_cache(vcpu);
 }
@@ -345,6 +353,8 @@ static int kvm_riscv_vcpu_set_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_set_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_set_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_set_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -358,6 +368,8 @@ static int kvm_riscv_vcpu_get_reg(struct kvm_vcpu *vcpu,
 		return kvm_riscv_vcpu_get_reg_core(vcpu, reg);
 	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_CSR)
 		return kvm_riscv_vcpu_get_reg_csr(vcpu, reg);
+	else if ((reg->id & KVM_REG_RISCV_TYPE_MASK) == KVM_REG_RISCV_TIMER)
+		return kvm_riscv_vcpu_get_reg_timer(vcpu, reg);
 
 	return -EINVAL;
 }
@@ -590,6 +602,8 @@ void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
 
 	kvm_riscv_stage2_update_hgatp(vcpu);
 
+	kvm_riscv_vcpu_timer_restore(vcpu);
+
 	vcpu->cpu = cpu;
 }
 
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
new file mode 100644
index 000000000000..5fb9fe378800
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -0,0 +1,225 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <linux/uaccess.h>
+#include <clocksource/timer-riscv.h>
+#include <asm/csr.h>
+#include <asm/delay.h>
+#include <asm/kvm_vcpu_timer.h>
+
+static u64 kvm_riscv_current_cycles(struct kvm_guest_timer *gt)
+{
+	return get_cycles64() + gt->time_delta;
+}
+
+static u64 kvm_riscv_delta_cycles2ns(u64 cycles,
+				     struct kvm_guest_timer *gt,
+				     struct kvm_vcpu_timer *t)
+{
+	unsigned long flags;
+	u64 cycles_now, cycles_delta, delta_ns;
+
+	local_irq_save(flags);
+	cycles_now = kvm_riscv_current_cycles(gt);
+	if (cycles_now < cycles)
+		cycles_delta = cycles - cycles_now;
+	else
+		cycles_delta = 0;
+	delta_ns = (cycles_delta * gt->nsec_mult) >> gt->nsec_shift;
+	local_irq_restore(flags);
+
+	return delta_ns;
+}
+
+static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer *h)
+{
+	u64 delta_ns;
+	struct kvm_vcpu_timer *t = container_of(h, struct kvm_vcpu_timer, hrt);
+	struct kvm_vcpu *vcpu = container_of(t, struct kvm_vcpu, arch.timer);
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+	if (kvm_riscv_current_cycles(gt) < t->next_cycles) {
+		delta_ns = kvm_riscv_delta_cycles2ns(t->next_cycles, gt, t);
+		hrtimer_forward_now(&t->hrt, ktime_set(0, delta_ns));
+		return HRTIMER_RESTART;
+	}
+
+	t->next_set = false;
+	kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_TIMER);
+
+	return HRTIMER_NORESTART;
+}
+
+static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
+{
+	if (!t->init_done || !t->next_set)
+		return -EINVAL;
+
+	hrtimer_cancel(&t->hrt);
+	t->next_set = false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 delta_ns;
+
+	if (!t->init_done)
+		return -EINVAL;
+
+	kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_TIMER);
+
+	delta_ns = kvm_riscv_delta_cycles2ns(ncycles, gt, t);
+	t->next_cycles = ncycles;
+	hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
+	t->next_set = true;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_get_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_TIMER);
+	u64 reg_val;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
+		return -EINVAL;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_TIMER_REG(frequency):
+		reg_val = riscv_timebase;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(time):
+		reg_val = kvm_riscv_current_cycles(gt);
+		break;
+	case KVM_REG_RISCV_TIMER_REG(compare):
+		reg_val = t->next_cycles;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(state):
+		reg_val = (t->next_set) ? KVM_RISCV_TIMER_STATE_ON :
+					  KVM_RISCV_TIMER_STATE_OFF;
+		break;
+	default:
+		return -EINVAL;
+	};
+
+	if (copy_to_user(uaddr, &reg_val, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_set_reg_timer(struct kvm_vcpu *vcpu,
+				 const struct kvm_one_reg *reg)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+	u64 __user *uaddr = (u64 __user *)(unsigned long)reg->addr;
+	unsigned long reg_num = reg->id & ~(KVM_REG_ARCH_MASK |
+					    KVM_REG_SIZE_MASK |
+					    KVM_REG_RISCV_TIMER);
+	u64 reg_val;
+	int ret = 0;
+
+	if (KVM_REG_SIZE(reg->id) != sizeof(u64))
+		return -EINVAL;
+	if (reg_num >= sizeof(struct kvm_riscv_timer) / sizeof(u64))
+		return -EINVAL;
+
+	if (copy_from_user(&reg_val, uaddr, KVM_REG_SIZE(reg->id)))
+		return -EFAULT;
+
+	switch (reg_num) {
+	case KVM_REG_RISCV_TIMER_REG(frequency):
+		ret = -ENOTSUPP;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(time):
+		gt->time_delta = reg_val - get_cycles64();
+		break;
+	case KVM_REG_RISCV_TIMER_REG(compare):
+		t->next_cycles = reg_val;
+		break;
+	case KVM_REG_RISCV_TIMER_REG(state):
+		if (reg_val == KVM_RISCV_TIMER_STATE_ON)
+			ret = kvm_riscv_vcpu_timer_next_event(vcpu, reg_val);
+		else
+			ret = kvm_riscv_vcpu_timer_cancel(t);
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	};
+
+	return ret;
+}
+
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_timer *t = &vcpu->arch.timer;
+
+	if (t->init_done)
+		return -EINVAL;
+
+	hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	t->hrt.function = kvm_riscv_vcpu_hrtimer_expired;
+	t->init_done = true;
+	t->next_set = false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	ret = kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+	vcpu->arch.timer.init_done = false;
+
+	return ret;
+}
+
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu)
+{
+	return kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+}
+
+void kvm_riscv_vcpu_timer_restore(struct kvm_vcpu *vcpu)
+{
+	struct kvm_guest_timer *gt = &vcpu->kvm->arch.timer;
+
+#ifdef CONFIG_64BIT
+	csr_write(CSR_HTIMEDELTA, gt->time_delta);
+#else
+	csr_write(CSR_HTIMEDELTA, (u32)(gt->time_delta));
+	csr_write(CSR_HTIMEDELTAH, (u32)(gt->time_delta >> 32));
+#endif
+}
+
+int kvm_riscv_guest_timer_init(struct kvm *kvm)
+{
+	struct kvm_guest_timer *gt = &kvm->arch.timer;
+
+	riscv_cs_get_mult_shift(&gt->nsec_mult, &gt->nsec_shift);
+	gt->time_delta = -get_cycles64();
+
+	return 0;
+}
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
index fd84b4d914dc..4f2498198cb5 100644
--- a/arch/riscv/kvm/vm.c
+++ b/arch/riscv/kvm/vm.c
@@ -32,7 +32,7 @@ int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
 		return r;
 	}
 
-	return 0;
+	return kvm_riscv_guest_timer_init(kvm);
 }
 
 void kvm_arch_destroy_vm(struct kvm *kvm)
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-riscv.c
index c4f15c4068c0..ab6605c33d7b 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -12,6 +12,7 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
+#include <linux/module.h>
 #include <linux/sched_clock.h>
 #include <linux/io-64-nonatomic-lo-hi.h>
 #include <asm/smp.h>
@@ -86,6 +87,13 @@ static int riscv_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
 
+void riscv_cs_get_mult_shift(u32 *mult, u32 *shift)
+{
+	*mult = riscv_clocksource.mult;
+	*shift = riscv_clocksource.shift;
+}
+EXPORT_SYMBOL_GPL(riscv_cs_get_mult_shift);
+
 /* called directly from the low-level interrupt handler */
 void riscv_timer_interrupt(void)
 {
diff --git a/include/clocksource/timer-riscv.h b/include/clocksource/timer-riscv.h
new file mode 100644
index 000000000000..e94e4feecbe8
--- /dev/null
+++ b/include/clocksource/timer-riscv.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __TIMER_RISCV_H
+#define __TIMER_RISCV_H
+
+#include <linux/types.h>
+
+void riscv_cs_get_mult_shift(u32 *mult, u32 *shift);
+
+#endif
-- 
2.17.1

