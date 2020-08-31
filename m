Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10DC257940
	for <lists+kvm@lfdr.de>; Mon, 31 Aug 2020 14:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgHaMbM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 31 Aug 2020 08:31:12 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:55064 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbgHaMaz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 31 Aug 2020 08:30:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598877054; x=1630413054;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=9gRS+4jS5aVoUZxDQ4ZwO/BnHcl7Ltsaqp7/3+AccLU=;
  b=TumOrk/fw1shh0cYUlXJvVQsWyg5ud8OFq8mmMoLDEoTvPlT+tfMQVTH
   fKIZeWM/h1itGOAEVWrsE0op3aX2BKBGYfQjEojE4tHT9QjNAB8C+cLjP
   1SATDZTFTUrDMrd+uytqwMS2W6Dk4A7vLyX97LPcjDBkY0RDAmZ9NGQyw
   qSI0vd9PAdNHfZmfk6PE5Q/occoEKgKxrecBNeA+k4Kx4u2DQBY/m6KF5
   6ry0cy2S1Bo/KfXibHNSsOEfjKtDzA35n3Bft+Ih9XFKFYpHnBei5+wHc
   QTDUxo18I3S6Mc2XFE1vfpMEzKO7NH+WXEnM5fjw+RnMpnzGspLJW1DwB
   A==;
IronPort-SDR: WWCKA656tpagc9hCWbqleG7w3DVVVgjWSWEltPRDfoODGU29PcdvVJFZTby6pH7Ojr+jbMvMiu
 CRkZ3a3Gav2QFH7GC9j2XnFM4B/HzU1KZ1RlkGOA72DiU8uhVLUaw0UneBSKlOpXb9HNRBldXc
 FyHi8w4XnT+5bN9Hd+AgQpcu14twiXeJ5R/9BzuJwohygOzmIDncZ/WhZ2dZ5ch8QhC9hqqchs
 IUd7PbYweRg74DQeV5icA+kO6qVSp4oielTVAURwuml0YaA2xyIieqCy+2DRKPdI/g+foKpYYv
 W2g=
X-IronPort-AV: E=Sophos;i="5.76,375,1592841600"; 
   d="scan'208";a="146216616"
Received: from mail-co1nam11lp2175.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.175])
  by ob1.hgst.iphmx.com with ESMTP; 31 Aug 2020 20:30:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fNwp80iw6ZBhUIJ11V9CZ61Lxwv9pttOoIzAH2lhcfy7bLIBG6xl7h+p0tlS13GTAlWpfrtZyIgRPsnrbcUijvWoFRz+bGPnuq8VxYRGzG5wZY87TXmb1k3FY9rmsjnsvfVX/DJLS0KRazoaolWJ0xyki9W9MJY/pny/Kb+zwBt+OfXJxIwS8N/IgY1mrTlQb5s/kTFKGu4ExNdAJ36tLhmB14aVeHeo/4wyAClxj08rCmLWqDt9S65AgvH7Ljy7WGRPv477PPSICRJ3ePy07hV4PzkaNcB8SQAzTNCRR4WFdHndrtPQhfNZTp0ABR2GY9/7Axoz+AjwF75dRfRnFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUGotECkW2MLOMkrD0SkPVR7vsz4gSdQYmpU4YzL58A=;
 b=bhAxkMUwo59fKaPfX6QlZQnlksJ/TsV1g4KIGwrL5QUEKYVx1sPzUJxcq5m5NfFEShv44U+gNKNzhT3XqoyXm6R15NuNu2UrNdnaD8EjFll4DDujhpYNchR7myXUi/uuua04fGlNEfuwOIHJ9gdlvJ23XUbp5NLtOyqI8B7VFEI2zpERhnm/vt9OPi7NGM15TY+i7+OowDI7wuMM93go81VAdHTb268obIDFsdAbHca1Q9HnVvoNiyL7epLiVR9/P9gZjUiwVf4r6ZiHQ3VOKMTFK2BRqH+hJhMXCDAgiYb0gO+cf64kyak8yLgrw0SM/U+D9zpKmLpKI56hgn+Hlw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fUGotECkW2MLOMkrD0SkPVR7vsz4gSdQYmpU4YzL58A=;
 b=gqGP++4nnG6OmO9Y2MmR35N244Erl3FLg8W6VC7faJrDS+oW1DVKa52AJBnG+6bcMIgBtiy5nu2SA02Mk8fbgQFJ+5AMOi3l88XfmYPqceTbLyi4v090cZ8WfBoC34puFzp/KupAqC6Lg5JamAWeK3Xa0lAVCVKV59USC4Px5lE=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6124.namprd04.prod.outlook.com (2603:10b6:5:122::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.24; Mon, 31 Aug
 2020 12:30:50 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::607a:44ed:1477:83e%7]) with mapi id 15.20.3326.025; Mon, 31 Aug 2020
 12:30:50 +0000
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
Subject: [PATCH v14 02/17] RISC-V: Add initial skeletal KVM support
Date:   Mon, 31 Aug 2020 18:00:00 +0530
Message-Id: <20200831123015.336047-3-anup.patel@wdc.com>
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
Received: from 255.255.255.255 (255.255.255.255) by BM1PR0101CA0046.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:1a::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19 via Frontend Transport; Mon, 31 Aug 2020 12:30:45 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.192]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 88f3b439-2a07-46dd-9cee-08d84da9b1a8
X-MS-TrafficTypeDiagnostic: DM6PR04MB6124:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB61240E6276FA064B098C64988D510@DM6PR04MB6124.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:214;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: blJsbN5ru4bAgkNMvaR1N/pf4MLV3xreHfCV4ii8y7SnXA63wYsElJGLl+d2KWzX81dMbW+in4tcE01dYpJR+vCsvdrKHrWVI7IxeJJQ255kT190wy2ZT5VHBKQgpCTDfFjZ5Vf8Fbr6GpeDLJBEEsz5hCLU+miDBINDt07/PaupO0FhD7iW5fA6RJMRZ7t3VVZzVLvxL5Ba5r5v3bV3x2cR45bl5zyJHKrmLk4duGMN9t4XVYojuFY5CPOoC4duwOr3kwgZtqvOhO0DB0MNNempn25sJdALYCyK6B0Hk8jtOslxJpq9f4mZ61a6+PqdOPxVF5j64YTC2vYEo2YQZA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(136003)(366004)(346002)(396003)(8676002)(8936002)(478600001)(52116002)(86362001)(1076003)(54906003)(7416002)(30864003)(110136005)(6486002)(66556008)(36756003)(5660300002)(66476007)(4326008)(2906002)(66946007)(2616005)(6666004)(26005)(956004)(316002)(83380400001)(16576012)(186003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: RlQYB2Jp+9a6qpGoxOX3WqJGwagS9unLFQJmVVrHnslr8M1RhXv+HE7QzhlXV4KXcjXN7rfeqMDVjTL9mdPz1ITEhA25zNEYscnTbMsGJgfhM+b6NJZmGe4iDTahB5ONqEixaLGnBO1PW8oAOJTxr/PEv8zFw1Wv3aE/jJbfGORkw/ux6MkE2dJ1VOLqfw0mfZJwEPq0ndfL+JrAxGHT6uf28l7AeG1TDfVex5xqyEjQ8qm8ly4KZMuskg+u4jQqHpwL20tewdmb3+DH2cxwWUcYRxTdNw8uniZ50bcu//dnZY4s8AcE9oxlV6sIz+hxuIGl6IWlBYjU+0blVwSyBpD+2vaGRe17bFtak6xdH9r+nhFPmyEWq6HIRwi7cC/5bUsRZAig1woM03QD4vbM6PFTZ0KZUe3MWWclOKqHd6xrGh8TXmQ4V1PnXAdxsiK3sAI6CNf9CnQkjjSEoBHrArhyO7hfFuXUGMTxCpLApRQuYT95Z2q81/5qR+SXkyFH6jzzAqckxNX0/LMd8f6tYJcTdCUbkr8eqfELVeBASRDwWDNEuBsoSBkjFOD85c7/bHlvUGfuvpNUxOL53BNvExduiNgw/uh2rHvyeS9y3WpXkwVXLCR7ZfOnjTgjfPNPhMlyS++NAymrKULkAvM8kQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88f3b439-2a07-46dd-9cee-08d84da9b1a8
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Aug 2020 12:30:50.2671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bZgUYoN+3RbkXrjISb2i3vhISbgckd1Pr/0MGBRcOK0RI2q6v1lAa8YDOu1IGb98QbTW8mGYzdugBPAHLiyoxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6124
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds initial skeletal KVM RISC-V support which has:
1. A simple implementation of arch specific VM functions
   except kvm_vm_ioctl_get_dirty_log() which will implemeted
   in-future as part of stage2 page loging.
2. Stubs of required arch specific VCPU functions except
   kvm_arch_vcpu_ioctl_run() which is semi-complete and
   extended by subsequent patches.
3. Stubs for required arch specific stage2 MMU functions.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/Kconfig                 |   2 +
 arch/riscv/Makefile                |   2 +
 arch/riscv/include/asm/kvm_host.h  |  91 ++++++++
 arch/riscv/include/asm/kvm_types.h |   7 +
 arch/riscv/include/uapi/asm/kvm.h  |  47 +++++
 arch/riscv/kvm/Kconfig             |  33 +++
 arch/riscv/kvm/Makefile            |  13 ++
 arch/riscv/kvm/main.c              |  95 +++++++++
 arch/riscv/kvm/mmu.c               |  86 ++++++++
 arch/riscv/kvm/vcpu.c              | 326 +++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c         |  35 ++++
 arch/riscv/kvm/vm.c                |  79 +++++++
 12 files changed, 816 insertions(+)
 create mode 100644 arch/riscv/include/asm/kvm_host.h
 create mode 100644 arch/riscv/include/asm/kvm_types.h
 create mode 100644 arch/riscv/include/uapi/asm/kvm.h
 create mode 100644 arch/riscv/kvm/Kconfig
 create mode 100644 arch/riscv/kvm/Makefile
 create mode 100644 arch/riscv/kvm/main.c
 create mode 100644 arch/riscv/kvm/mmu.c
 create mode 100644 arch/riscv/kvm/vcpu.c
 create mode 100644 arch/riscv/kvm/vcpu_exit.c
 create mode 100644 arch/riscv/kvm/vm.c

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index a8f20141f506..277ccd38d942 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -413,3 +413,5 @@ menu "Power management options"
 source "kernel/power/Kconfig"
 
 endmenu
+
+source "arch/riscv/kvm/Kconfig"
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index fb6e37db836d..fc189284b245 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -79,6 +79,8 @@ head-y := arch/riscv/kernel/head.o
 
 core-y += arch/riscv/
 
+core-$(CONFIG_KVM) += arch/riscv/kvm/
+
 libs-y += arch/riscv/lib/
 
 PHONY += vdso_install
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
new file mode 100644
index 000000000000..fdd63bafb714
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -0,0 +1,91 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __RISCV_KVM_HOST_H__
+#define __RISCV_KVM_HOST_H__
+
+#include <linux/types.h>
+#include <linux/kvm.h>
+#include <linux/kvm_types.h>
+
+#ifdef CONFIG_64BIT
+#define KVM_MAX_VCPUS			(1U << 16)
+#else
+#define KVM_MAX_VCPUS			(1U << 9)
+#endif
+
+#define KVM_USER_MEM_SLOTS		512
+#define KVM_HALT_POLL_NS_DEFAULT	500000
+
+#define KVM_VCPU_MAX_FEATURES		0
+
+#define KVM_REQ_SLEEP \
+	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+
+struct kvm_vm_stat {
+	ulong remote_tlb_flush;
+};
+
+struct kvm_vcpu_stat {
+	u64 halt_successful_poll;
+	u64 halt_attempted_poll;
+	u64 halt_poll_success_ns;
+	u64 halt_poll_fail_ns;
+	u64 halt_poll_invalid;
+	u64 halt_wakeup;
+	u64 ecall_exit_stat;
+	u64 wfi_exit_stat;
+	u64 mmio_exit_user;
+	u64 mmio_exit_kernel;
+	u64 exits;
+};
+
+struct kvm_arch_memory_slot {
+};
+
+struct kvm_arch {
+	/* stage2 page table */
+	pgd_t *pgd;
+	phys_addr_t pgd_phys;
+};
+
+struct kvm_cpu_trap {
+	unsigned long sepc;
+	unsigned long scause;
+	unsigned long stval;
+	unsigned long htval;
+	unsigned long htinst;
+};
+
+struct kvm_vcpu_arch {
+	/* Don't run the VCPU (blocked) */
+	bool pause;
+
+	/* SRCU lock index for in-kernel run loop */
+	int srcu_idx;
+};
+
+static inline void kvm_arch_hardware_unsetup(void) {}
+static inline void kvm_arch_sync_events(struct kvm *kvm) {}
+static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu *vcpu) {}
+static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
+static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
+
+void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
+int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
+void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
+void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu);
+
+int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run);
+int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			struct kvm_cpu_trap *trap);
+
+static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
+
+#endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/asm/kvm_types.h b/arch/riscv/include/asm/kvm_types.h
new file mode 100644
index 000000000000..e476b404eb67
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_types.h
@@ -0,0 +1,7 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+#ifndef _ASM_RISCV_KVM_TYPES_H
+#define _ASM_RISCV_KVM_TYPES_H
+
+#define KVM_ARCH_NR_OBJS_PER_MEMORY_CACHE 40
+
+#endif /* _ASM_RISCV_KVM_TYPES_H */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
new file mode 100644
index 000000000000..984d041a3e3b
--- /dev/null
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -0,0 +1,47 @@
+/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#ifndef __LINUX_KVM_RISCV_H
+#define __LINUX_KVM_RISCV_H
+
+#ifndef __ASSEMBLY__
+
+#include <linux/types.h>
+#include <asm/ptrace.h>
+
+#define __KVM_HAVE_READONLY_MEM
+
+#define KVM_COALESCED_MMIO_PAGE_OFFSET 1
+
+/* for KVM_GET_REGS and KVM_SET_REGS */
+struct kvm_regs {
+};
+
+/* for KVM_GET_FPU and KVM_SET_FPU */
+struct kvm_fpu {
+};
+
+/* KVM Debug exit structure */
+struct kvm_debug_exit_arch {
+};
+
+/* for KVM_SET_GUEST_DEBUG */
+struct kvm_guest_debug_arch {
+};
+
+/* definition of registers in kvm_run */
+struct kvm_sync_regs {
+};
+
+/* dummy definition */
+struct kvm_sregs {
+};
+
+#endif
+
+#endif /* __LINUX_KVM_RISCV_H */
diff --git a/arch/riscv/kvm/Kconfig b/arch/riscv/kvm/Kconfig
new file mode 100644
index 000000000000..88edd477b3a8
--- /dev/null
+++ b/arch/riscv/kvm/Kconfig
@@ -0,0 +1,33 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# KVM configuration
+#
+
+source "virt/kvm/Kconfig"
+
+menuconfig VIRTUALIZATION
+	bool "Virtualization"
+	help
+	  Say Y here to get to see options for using your Linux host to run
+	  other operating systems inside virtual machines (guests).
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and
+	  disabled.
+
+if VIRTUALIZATION
+
+config KVM
+	tristate "Kernel-based Virtual Machine (KVM) support (EXPERIMENTAL)"
+	depends on RISCV_SBI && MMU
+	select PREEMPT_NOTIFIERS
+	select ANON_INODES
+	select KVM_MMIO
+	select HAVE_KVM_VCPU_ASYNC_IOCTL
+	select SRCU
+	help
+	  Support hosting virtualized guest machines.
+
+	  If unsure, say N.
+
+endif # VIRTUALIZATION
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
new file mode 100644
index 000000000000..37b5a59d4f4f
--- /dev/null
+++ b/arch/riscv/kvm/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+# Makefile for RISC-V KVM support
+#
+
+common-objs-y = $(addprefix ../../../virt/kvm/, kvm_main.o coalesced_mmio.o)
+
+ccflags-y := -Ivirt/kvm -Iarch/riscv/kvm
+
+kvm-objs := $(common-objs-y)
+
+kvm-objs += main.o vm.o mmu.o vcpu.o vcpu_exit.o
+
+obj-$(CONFIG_KVM)	+= kvm.o
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
new file mode 100644
index 000000000000..47926f0c175d
--- /dev/null
+++ b/arch/riscv/kvm/main.c
@@ -0,0 +1,95 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/hwcap.h>
+#include <asm/sbi.h>
+
+long kvm_arch_dev_ioctl(struct file *filp,
+			unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_check_processor_compat(void *opaque)
+{
+	return 0;
+}
+
+int kvm_arch_hardware_setup(void *opaque)
+{
+	return 0;
+}
+
+int kvm_arch_hardware_enable(void)
+{
+	unsigned long hideleg, hedeleg;
+
+	hedeleg = 0;
+	hedeleg |= (1UL << EXC_INST_MISALIGNED);
+	hedeleg |= (1UL << EXC_BREAKPOINT);
+	hedeleg |= (1UL << EXC_SYSCALL);
+	hedeleg |= (1UL << EXC_INST_PAGE_FAULT);
+	hedeleg |= (1UL << EXC_LOAD_PAGE_FAULT);
+	hedeleg |= (1UL << EXC_STORE_PAGE_FAULT);
+	csr_write(CSR_HEDELEG, hedeleg);
+
+	hideleg = 0;
+	hideleg |= (1UL << IRQ_VS_SOFT);
+	hideleg |= (1UL << IRQ_VS_TIMER);
+	hideleg |= (1UL << IRQ_VS_EXT);
+	csr_write(CSR_HIDELEG, hideleg);
+
+	csr_write(CSR_HCOUNTEREN, -1UL);
+
+	csr_write(CSR_HVIP, 0);
+
+	return 0;
+}
+
+void kvm_arch_hardware_disable(void)
+{
+	csr_write(CSR_HEDELEG, 0);
+	csr_write(CSR_HIDELEG, 0);
+}
+
+int kvm_arch_init(void *opaque)
+{
+	if (!riscv_isa_extension_available(NULL, h)) {
+		kvm_info("hypervisor extension not available\n");
+		return -ENODEV;
+	}
+
+	if (sbi_spec_is_0_1()) {
+		kvm_info("require SBI v0.2 or higher\n");
+		return -ENODEV;
+	}
+
+	if (sbi_probe_extension(SBI_EXT_RFENCE) <= 0) {
+		kvm_info("require SBI RFENCE extension\n");
+		return -ENODEV;
+	}
+
+	kvm_info("hypervisor extension available\n");
+
+	return 0;
+}
+
+void kvm_arch_exit(void)
+{
+}
+
+static int riscv_kvm_init(void)
+{
+	return kvm_init(NULL, sizeof(struct kvm_vcpu), 0, THIS_MODULE);
+}
+module_init(riscv_kvm_init);
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
new file mode 100644
index 000000000000..ec13507e8a18
--- /dev/null
+++ b/arch/riscv/kvm/mmu.c
@@ -0,0 +1,86 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/hugetlb.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/kvm_host.h>
+#include <linux/sched/signal.h>
+#include <asm/page.h>
+#include <asm/pgtable.h>
+
+void kvm_arch_sync_dirty_log(struct kvm *kvm, struct kvm_memory_slot *memslot)
+{
+}
+
+void kvm_arch_free_memslot(struct kvm *kvm, struct kvm_memory_slot *free)
+{
+}
+
+int kvm_arch_create_memslot(struct kvm *kvm, struct kvm_memory_slot *slot,
+			    unsigned long npages)
+{
+	return 0;
+}
+
+void kvm_arch_memslots_updated(struct kvm *kvm, u64 gen)
+{
+}
+
+void kvm_arch_flush_shadow_all(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm_arch_flush_shadow_memslot(struct kvm *kvm,
+				   struct kvm_memory_slot *slot)
+{
+}
+
+void kvm_arch_commit_memory_region(struct kvm *kvm,
+				const struct kvm_userspace_memory_region *mem,
+				struct kvm_memory_slot *old,
+				const struct kvm_memory_slot *new,
+				enum kvm_mr_change change)
+{
+	/* TODO: */
+}
+
+int kvm_arch_prepare_memory_region(struct kvm *kvm,
+				struct kvm_memory_slot *memslot,
+				const struct kvm_userspace_memory_region *mem,
+				enum kvm_mr_change change)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_riscv_stage2_free_pgd(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm_riscv_stage2_update_hgatp(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
new file mode 100644
index 000000000000..8d8d140a0caf
--- /dev/null
+++ b/arch/riscv/kvm/vcpu.c
@@ -0,0 +1,326 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/bitops.h>
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kdebug.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/vmalloc.h>
+#include <linux/sched/signal.h>
+#include <linux/fs.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/delay.h>
+#include <asm/hwcap.h>
+
+struct kvm_stats_debugfs_item debugfs_entries[] = {
+	VCPU_STAT("halt_successful_poll", halt_successful_poll),
+	VCPU_STAT("halt_attempted_poll", halt_attempted_poll),
+	VCPU_STAT("halt_poll_success_ns", halt_poll_success_ns),
+	VCPU_STAT("halt_poll_fail_ns", halt_poll_fail_ns),
+	VCPU_STAT("halt_poll_invalid", halt_poll_invalid),
+	VCPU_STAT("halt_wakeup", halt_wakeup),
+	VCPU_STAT("ecall_exit_stat", ecall_exit_stat),
+	VCPU_STAT("wfi_exit_stat", wfi_exit_stat),
+	VCPU_STAT("mmio_exit_user", mmio_exit_user),
+	VCPU_STAT("mmio_exit_kernel", mmio_exit_kernel),
+	VCPU_STAT("exits", exits),
+	{ NULL }
+};
+
+int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
+{
+	return 0;
+}
+
+int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_setup(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
+{
+}
+
+void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
+{
+}
+
+int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return 0;
+}
+
+bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+	return false;
+}
+
+bool kvm_arch_has_vcpu_debugfs(void)
+{
+	return false;
+}
+
+int kvm_arch_create_vcpu_debugfs(struct kvm_vcpu *vcpu)
+{
+	return 0;
+}
+
+vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
+{
+	return VM_FAULT_SIGBUS;
+}
+
+long kvm_arch_vcpu_async_ioctl(struct file *filp,
+			       unsigned int ioctl, unsigned long arg)
+{
+	/* TODO; */
+	return -ENOIOCTLCMD;
+}
+
+long kvm_arch_vcpu_ioctl(struct file *filp,
+			 unsigned int ioctl, unsigned long arg)
+{
+	/* TODO: */
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
+				  struct kvm_sregs *sregs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_fpu(struct kvm_vcpu *vcpu, struct kvm_fpu *fpu)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_translate(struct kvm_vcpu *vcpu,
+				  struct kvm_translation *tr)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
+{
+	return -EINVAL;
+}
+
+int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
+				    struct kvm_mp_state *mp_state)
+{
+	/* TODO: */
+	return 0;
+}
+
+int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
+					struct kvm_guest_debug *dbg)
+{
+	/* TODO; To be implemented later. */
+	return -EINVAL;
+}
+
+void kvm_arch_vcpu_load(struct kvm_vcpu *vcpu, int cpu)
+{
+	/* TODO: */
+
+	kvm_riscv_stage2_update_hgatp(vcpu);
+}
+
+void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
+{
+	int ret;
+	struct kvm_cpu_trap trap;
+	struct kvm_run *run = vcpu->run;
+
+	vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+	/* Process MMIO value returned from user-space */
+	if (run->exit_reason == KVM_EXIT_MMIO) {
+		ret = kvm_riscv_vcpu_mmio_return(vcpu, vcpu->run);
+		if (ret) {
+			srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+			return ret;
+		}
+	}
+
+	if (run->immediate_exit) {
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+		return -EINTR;
+	}
+
+	vcpu_load(vcpu);
+
+	kvm_sigset_activate(vcpu);
+
+	ret = 1;
+	run->exit_reason = KVM_EXIT_UNKNOWN;
+	while (ret > 0) {
+		/* Check conditions before entering the guest */
+		cond_resched();
+
+		kvm_riscv_check_vcpu_requests(vcpu);
+
+		preempt_disable();
+
+		local_irq_disable();
+
+		/*
+		 * Exit if we have a signal pending so that we can deliver
+		 * the signal to user space.
+		 */
+		if (signal_pending(current)) {
+			ret = -EINTR;
+			run->exit_reason = KVM_EXIT_INTR;
+		}
+
+		/*
+		 * Ensure we set mode to IN_GUEST_MODE after we disable
+		 * interrupts and before the final VCPU requests check.
+		 * See the comment in kvm_vcpu_exiting_guest_mode() and
+		 * Documentation/virtual/kvm/vcpu-requests.rst
+		 */
+		vcpu->mode = IN_GUEST_MODE;
+
+		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+		smp_mb__after_srcu_read_unlock();
+
+		if (ret <= 0 ||
+		    kvm_request_pending(vcpu)) {
+			vcpu->mode = OUTSIDE_GUEST_MODE;
+			local_irq_enable();
+			preempt_enable();
+			vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+			continue;
+		}
+
+		guest_enter_irqoff();
+
+		__kvm_riscv_switch_to(&vcpu->arch);
+
+		vcpu->mode = OUTSIDE_GUEST_MODE;
+		vcpu->stat.exits++;
+
+		/*
+		 * Save SCAUSE, STVAL, HTVAL, and HTINST because we might
+		 * get an interrupt between __kvm_riscv_switch_to() and
+		 * local_irq_enable() which can potentially change CSRs.
+		 */
+		trap.sepc = 0;
+		trap.scause = csr_read(CSR_SCAUSE);
+		trap.stval = csr_read(CSR_STVAL);
+		trap.htval = csr_read(CSR_HTVAL);
+		trap.htinst = csr_read(CSR_HTINST);
+
+		/*
+		 * We may have taken a host interrupt in VS/VU-mode (i.e.
+		 * while executing the guest). This interrupt is still
+		 * pending, as we haven't serviced it yet!
+		 *
+		 * We're now back in HS-mode with interrupts disabled
+		 * so enabling the interrupts now will have the effect
+		 * of taking the interrupt again, in HS-mode this time.
+		 */
+		local_irq_enable();
+
+		/*
+		 * We do local_irq_enable() before calling guest_exit() so
+		 * that if a timer interrupt hits while running the guest
+		 * we account that tick as being spent in the guest. We
+		 * enable preemption after calling guest_exit() so that if
+		 * we get preempted we make sure ticks after that is not
+		 * counted as guest time.
+		 */
+		guest_exit();
+
+		preempt_enable();
+
+		vcpu->arch.srcu_idx = srcu_read_lock(&vcpu->kvm->srcu);
+
+		ret = kvm_riscv_vcpu_exit(vcpu, run, &trap);
+	}
+
+	kvm_sigset_deactivate(vcpu);
+
+	vcpu_put(vcpu);
+
+	srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
+
+	return ret;
+}
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
new file mode 100644
index 000000000000..4484e9200fe4
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -0,0 +1,35 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+
+/**
+ * kvm_riscv_vcpu_mmio_return -- Handle MMIO loads after user space emulation
+ *			     or in-kernel IO emulation
+ *
+ * @vcpu: The VCPU pointer
+ * @run:  The VCPU run struct containing the mmio data
+ */
+int kvm_riscv_vcpu_mmio_return(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	/* TODO: */
+	return 0;
+}
+
+/*
+ * Return > 0 to return to guest, < 0 on error, 0 (and set exit_reason) on
+ * proper exit to userspace.
+ */
+int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
+			struct kvm_cpu_trap *trap)
+{
+	/* TODO: */
+	return 0;
+}
diff --git a/arch/riscv/kvm/vm.c b/arch/riscv/kvm/vm.c
new file mode 100644
index 000000000000..d6776b4819bb
--- /dev/null
+++ b/arch/riscv/kvm/vm.c
@@ -0,0 +1,79 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Anup Patel <anup.patel@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/module.h>
+#include <linux/uaccess.h>
+#include <linux/kvm_host.h>
+
+int kvm_vm_ioctl_get_dirty_log(struct kvm *kvm, struct kvm_dirty_log *log)
+{
+	/* TODO: To be added later. */
+	return -EOPNOTSUPP;
+}
+
+int kvm_arch_init_vm(struct kvm *kvm, unsigned long type)
+{
+	int r;
+
+	r = kvm_riscv_stage2_alloc_pgd(kvm);
+	if (r)
+		return r;
+
+	return 0;
+}
+
+void kvm_arch_destroy_vm(struct kvm *kvm)
+{
+	int i;
+
+	for (i = 0; i < KVM_MAX_VCPUS; ++i) {
+		if (kvm->vcpus[i]) {
+			kvm_arch_vcpu_destroy(kvm->vcpus[i]);
+			kvm->vcpus[i] = NULL;
+		}
+	}
+}
+
+int kvm_vm_ioctl_check_extension(struct kvm *kvm, long ext)
+{
+	int r;
+
+	switch (ext) {
+	case KVM_CAP_DEVICE_CTRL:
+	case KVM_CAP_USER_MEMORY:
+	case KVM_CAP_DESTROY_MEMORY_REGION_WORKS:
+	case KVM_CAP_ONE_REG:
+	case KVM_CAP_READONLY_MEM:
+	case KVM_CAP_MP_STATE:
+	case KVM_CAP_IMMEDIATE_EXIT:
+		r = 1;
+		break;
+	case KVM_CAP_NR_VCPUS:
+		r = num_online_cpus();
+		break;
+	case KVM_CAP_MAX_VCPUS:
+		r = KVM_MAX_VCPUS;
+		break;
+	case KVM_CAP_NR_MEMSLOTS:
+		r = KVM_USER_MEM_SLOTS;
+		break;
+	default:
+		r = 0;
+		break;
+	}
+
+	return r;
+}
+
+long kvm_arch_vm_ioctl(struct file *filp,
+		       unsigned int ioctl, unsigned long arg)
+{
+	return -EINVAL;
+}
-- 
2.25.1

