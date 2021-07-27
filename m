Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3CF3D6E53
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:55:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235408AbhG0Fz3 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:55:29 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33012 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233553AbhG0Fz0 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:55:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365326; x=1658901326;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=KzWrvMPcHrjjXaiW9rDDO3uWi8sESd6o3TsZ4U1kGzE=;
  b=MVFEg6Vw/R37YORUU3p+g7cWzDLTUCyDSfZpb3NOPki2NyK0V0ptSGZm
   1Np3lZkUaJiBOqgys+4DoJ4xp5RNPNQcARbOPPiSge1X4DYn+kvTGVHAE
   Wvk0KZJwbagLGqbn9VjE/3cqzg5o12aWQSEJnngForq9UUsKg8D2qr7cB
   TQLvQY6kk2X8DpTYfAUP7Ium7vDgQxBE/ZeeQ+pzQe96SaOdQWZ/6g1EL
   GWmSKnS6Zb/YPla9MzIRvkxmGaPdtSmrMfDdiJHGRsJSQskkUzMo9F22S
   2vwDw/ASq/r1BIrUjTf+tW3JJqZFE0Ym89ZKoW1EFz+yXZx/jzK0yoXRS
   w==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180385860"
Received: from mail-mw2nam12lp2048.outbound.protection.outlook.com (HELO NAM12-MW2-obe.outbound.protection.outlook.com) ([104.47.66.48])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:55:25 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K/5UT6hflWdJQHU+mL+IELDCZ+7e9tOrb7q2bK5l4cD3yE1H4c8Z67dHvT9bo3qUDkoOH62Olj0pFXGSlpGUJHSZ4WFX1kB5oW6PAg3qrNLC0XPSlqt+32gvlEPSG7avIfDfA41oP3VvI1hvQ1AnnA7aDVEezRzE8tPdzbFKZ9yvcsnoywXofRPqYJPc82pZiyEa6oQ3DAGTNLcpwpYiQfVX53swouVm+rNlY2nv2KkuBevMWI+6QIt+/29FFvcFvBhvac0jzKHMsmGK70YGxKBTxl8vtm8IB9gjGKNkSZLDg4Q9Q9I6kJ4K1kvOu9p4czRrnZe/YpwuF2/QJjea6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuxfbXicBcuzsompwC8Adu5Y9HM9HtVSxJp8jwA+w8o=;
 b=i2Uu4LG8d4qKfYgNPrJh3WSj8hvhPvbGnzDReiXvps322Npr5Jpbc6zzbGxmXEa4Y2g7Y2gTjN1gJYmzg14CKyGBzS507qttN2GKKhMpXfrZf66RpW+yjbKKvf/BQ5klqvv6vyJUrbmLmiriC2SD7UOv229yHLHUrnTFlNOdemzjveiHW+3tcypeYx5TYQdu88nQJR/3skomym8fcZ/sp4eNcdWzkFxWYh7rZu9PAfGau2UL0CgpV4pPKeEiIvitHpwSwFPaSU7sBMc5urmnVc44gNIpDv/hDCfeW/saxoxeXv871riZ/+OL962UKbHedeu5ip1N+X3zvHp+5UN9sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tuxfbXicBcuzsompwC8Adu5Y9HM9HtVSxJp8jwA+w8o=;
 b=B/PCujkRIQ5pQ6WH+CQbd0d3ADMnrxsij7v5maWEvH+il7Jw2tAE65/Eja9bD3YZil0l14LvlvmS2EezMzuJ1rG4tD2Cg67bt9+UT2hV0yQmYtzGF9yAdqh4S4fW2hvwCeZWaTercULZ3J42Z0X68oVHGkN2ds9mxyGu+k8jggw=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.29; Tue, 27 Jul
 2021 05:55:25 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:55:25 +0000
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
Subject: [PATCH v19 02/17] RISC-V: Add initial skeletal KVM support
Date:   Tue, 27 Jul 2021 11:24:35 +0530
Message-Id: <20210727055450.2742868-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055450.2742868-1-anup.patel@wdc.com>
References: <20210727055450.2742868-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:22::16) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MA1PR0101CA0030.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:22::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 05:55:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 59a3a761-bd8c-42f2-69dc-08d950c3212f
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB837783041F45EDA37025DAC58DE99@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:214;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o5oK6RPXTriauwymoREjveBgDJWe0vA1ecP/HyP0ek1ygfeEDLmGBHGjBRGEJAvkHdBVMaZ0lK7ggIqVu3wUIb3m1Mb8ei59gYcd68Lr4dfsH396cvFEkeIcLaINpk/M7C5IprzJmDyv09+MZDfzw312u1bP1oRRhEaEbpLZAQ8/laZAI19rtw+McPUE+hugcd5f7lUTrGOTGQ49r0sb6wEeWK7M5Rjv8Gvy8T0g8QKk2Q98kijE0skPj9gcFCJ+FQyUbhC+8FsMw3+/eHEuqGruEuYZkJxYtKuHBmtJ+1d5mHYdB7W3sC9I4JJR49h9zjHThRBPkh36FEeCh7BwWrMOIG8LxgV2sQExtkFgfpHt5RSAitiMzzrhkLUpe6f9hY9KFt+UE2Gm4bN5aGOvJL70tR7JR26pjHMbws50dWWHa6WhMscBQnKrkgb/XL/k4AMXnIo7Mvj4uRWoH7j6E6OrbvrQAiG13I8z5T1nGhlgl68FVCEZM8dyqqEE09d0UDaWDSu3pb1TDTUp8ebxeziGn5yEPYv219IhYhmADkgUn0+1gllHlpFGrqwu7aIsk+CPwDd7gPhesCqqC/C54yX9i4ObqJFA0nl5DwkuZcA03tcUHzuZ5bJQDBHQ8SaSkKK4L8PEORg/wJD+dr6lquwtx8U8rWnxg/HlQp1gLSCOaBOp5873faJBn0fPS14YSqSvk7g6jp6cmEwDws3NgA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(52116002)(26005)(66946007)(54906003)(5660300002)(6666004)(956004)(2616005)(8936002)(186003)(38100700002)(316002)(36756003)(508600001)(8886007)(7416002)(66476007)(2906002)(1076003)(110136005)(86362001)(30864003)(44832011)(83380400001)(8676002)(4326008)(66556008)(55016002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?z6LvYzkKi/6r58dM3NMd2y2UcJemEVdYnPYkC6QALvLILzwra/8BOATKEQAP?=
 =?us-ascii?Q?YFpPBeSU9SdqvGzmwmX+90i9lAY+D1okYrzTWwOrb10oVObXufUKzihSEpdZ?=
 =?us-ascii?Q?h+bCtgP83k4Wg0SPprjjGlKNUpu/Hp6uBpHLyRs3WYJfAXteoJ0PR3aLc36i?=
 =?us-ascii?Q?WP8X+5z7+CPal0v8wtso5/lQZ5lTUwJqB4v/LBO2CbQ+iN7usjTVZVNNNomz?=
 =?us-ascii?Q?1LdPlr0+uHb+QU3i2CtJuzdZ9TTaFT7BZWEGeKO3MMjNWmA/UDR7yEkbwbhQ?=
 =?us-ascii?Q?vFmjrS0+S9y0E3MEqXWWJCxCXMuYrF2kcf3Ae2IlHRD/cPaKOFJw8MWhU/7l?=
 =?us-ascii?Q?6RvAWa2tAsa3/DRpc7FtzUb6j/1tooqWT2j5Lb6oXIQ/Ajx+JeLVqhM0Kp7u?=
 =?us-ascii?Q?F2BEUF3+Gt7gM8two7KnrtEAC3KK83Ay9iuTAlq984AzW0jG9wvkRbpF3Rbf?=
 =?us-ascii?Q?yMEMScchUflsCPOgEF+VLJ1n4OVWmsaF9NcJ0Csg4bLdzjQeqcl85g85GU/2?=
 =?us-ascii?Q?OtBJmSZoDC9SblWTHeLjGbkQ3S5zgi5pWZ2V1umE3sSUR1s5XpwoV8PBC5FM?=
 =?us-ascii?Q?J/OfCqdbhdkPktavV/YyXK+doLH92I7JUlt13bhpfueAXqG3Q5yx8wZ1BK+4?=
 =?us-ascii?Q?rvUyQ5vWxpGjphGvXislzVr0Z+qZkBHheY/EvcXFUmxEDBCX0zeANUETatco?=
 =?us-ascii?Q?3gOWCj99RNBzZLkUNGmHFxp8soVlFlJvzHeIcdy2/SIbL5CmjrGxSo+MnX2j?=
 =?us-ascii?Q?sipzNtUEes1tulcbzaHbOJ76lHDQdDGxGWlhzwOML4AFIhDU6BKR1iakl9mp?=
 =?us-ascii?Q?TM4nEo4rOcgjwon9Y0hbgsFttEQ3mhPGoaYxVW+7bdZZWyESZjdWREh7/nhp?=
 =?us-ascii?Q?CgbJCPbZY1dc3GCOLEI6P7Jkjr/6VCX4QSA+6Y/6IuJcbu4ytKUZEjdFGHj7?=
 =?us-ascii?Q?E6QJvGkwSaGPiHMmzc5oCG9wXMpufgO0gmQAABa/q4xvtfPZ/wGsAYqE8YVT?=
 =?us-ascii?Q?Qd6pBJmEDfOc4urJqVWaVfhyhR6zx3lJwZ+UBy3zWpZKJHvdgAzDXDY6I2js?=
 =?us-ascii?Q?x6r/DXV8+S7oGRAYTBecUVXcR3ntoOrxjW97IAmgukB4KWks1WAUoGWE05Qb?=
 =?us-ascii?Q?XH+/DDMTuxSXCjjuSBRe3Kj32jnIV3knKOmcT0GJX9re79j0jAVE2pcG282g?=
 =?us-ascii?Q?BJBmqfzjjp3wbGRDQ/dc9kJ1NqmXqYewBxAx8Qhfk7lZy2pbltx3rA+l9/rN?=
 =?us-ascii?Q?xLovk6X9GGP2lEwD2miWrY+8TfKFSGNCnRBWWCL/17hj5chCTPyF6Ub/nwvw?=
 =?us-ascii?Q?doAUATswIrrSVtHhq4cT4zhv?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59a3a761-bd8c-42f2-69dc-08d950c3212f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:55:25.6868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YFgZnxKO+SiGwLdazrjYcYJlW9gv9MEpO4zVnwAZVZ3gnzHRCpN4NZnEPpVEXG/tAvdR61R56b4EBoHyls63SA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
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
 arch/riscv/Kconfig                 |   1 +
 arch/riscv/Makefile                |   1 +
 arch/riscv/include/asm/kvm_host.h  |  84 ++++++++
 arch/riscv/include/asm/kvm_types.h |   7 +
 arch/riscv/include/uapi/asm/kvm.h  |  47 +++++
 arch/riscv/kvm/Kconfig             |  33 +++
 arch/riscv/kvm/Makefile            |  13 ++
 arch/riscv/kvm/main.c              |  95 +++++++++
 arch/riscv/kvm/mmu.c               |  80 ++++++++
 arch/riscv/kvm/vcpu.c              | 316 +++++++++++++++++++++++++++++
 arch/riscv/kvm/vcpu_exit.c         |  35 ++++
 arch/riscv/kvm/vm.c                |  94 +++++++++
 12 files changed, 806 insertions(+)
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
index d8943a25a9af..14cf1ac1bcc7 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -553,4 +553,5 @@ source "kernel/power/Kconfig"
 
 endmenu
 
+source "arch/riscv/kvm/Kconfig"
 source "drivers/firmware/Kconfig"
diff --git a/arch/riscv/Makefile b/arch/riscv/Makefile
index bc74afdbf31e..414852ac21c5 100644
--- a/arch/riscv/Makefile
+++ b/arch/riscv/Makefile
@@ -100,6 +100,7 @@ endif
 head-y := arch/riscv/kernel/head.o
 
 core-$(CONFIG_RISCV_ERRATA_ALTERNATIVE) += arch/riscv/errata/
+core-$(CONFIG_KVM) += arch/riscv/kvm/
 
 libs-y += arch/riscv/lib/
 libs-$(CONFIG_EFI_STUB) += $(objtree)/drivers/firmware/efi/libstub/lib.a
diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
new file mode 100644
index 000000000000..08a8f53bf814
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -0,0 +1,84 @@
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
+#define KVM_HALT_POLL_NS_DEFAULT	500000
+
+#define KVM_VCPU_MAX_FEATURES		0
+
+#define KVM_REQ_SLEEP \
+	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
+
+struct kvm_vm_stat {
+	struct kvm_vm_stat_generic generic;
+};
+
+struct kvm_vcpu_stat {
+	struct kvm_vcpu_stat_generic generic;
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
index 000000000000..4732094391bf
--- /dev/null
+++ b/arch/riscv/kvm/Makefile
@@ -0,0 +1,13 @@
+# SPDX-License-Identifier: GPL-2.0
+#
+# Makefile for RISC-V KVM support
+#
+
+ccflags-y += -I $(srctree)/$(src)
+
+KVM := ../../../virt/kvm
+
+obj-$(CONFIG_KVM) += kvm.o
+
+kvm-y += $(KVM)/kvm_main.o $(KVM)/coalesced_mmio.o $(KVM)/binary_stats.o \
+	 main.o vm.o mmu.o vcpu.o vcpu_exit.o
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
index 000000000000..abfd2b22fa8e
--- /dev/null
+++ b/arch/riscv/kvm/mmu.c
@@ -0,0 +1,80 @@
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
index 000000000000..299442c4a988
--- /dev/null
+++ b/arch/riscv/kvm/vcpu.c
@@ -0,0 +1,316 @@
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
+const struct _kvm_stats_desc kvm_vcpu_stats_desc[] = {
+	KVM_GENERIC_VCPU_STATS(),
+	STATS_DESC_COUNTER(VCPU, ecall_exit_stat),
+	STATS_DESC_COUNTER(VCPU, wfi_exit_stat),
+	STATS_DESC_COUNTER(VCPU, mmio_exit_user),
+	STATS_DESC_COUNTER(VCPU, mmio_exit_kernel),
+	STATS_DESC_COUNTER(VCPU, exits)
+};
+static_assert(ARRAY_SIZE(kvm_vcpu_stats_desc) ==
+		sizeof(struct kvm_vcpu_stat) / sizeof(u64));
+
+const struct kvm_stats_header kvm_vcpu_stats_header = {
+	.name_size = KVM_STATS_NAME_SIZE,
+	.num_desc = ARRAY_SIZE(kvm_vcpu_stats_desc),
+	.id_offset = sizeof(struct kvm_stats_header),
+	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE,
+	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE +
+		       sizeof(kvm_vcpu_stats_desc),
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
index 000000000000..6b90ccdbd9c5
--- /dev/null
+++ b/arch/riscv/kvm/vm.c
@@ -0,0 +1,94 @@
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
+const struct _kvm_stats_desc kvm_vm_stats_desc[] = {
+	KVM_GENERIC_VM_STATS()
+};
+static_assert(ARRAY_SIZE(kvm_vm_stats_desc) ==
+		sizeof(struct kvm_vm_stat) / sizeof(u64));
+
+const struct kvm_stats_header kvm_vm_stats_header = {
+	.name_size = KVM_STATS_NAME_SIZE,
+	.num_desc = ARRAY_SIZE(kvm_vm_stats_desc),
+	.id_offset =  sizeof(struct kvm_stats_header),
+	.desc_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE,
+	.data_offset = sizeof(struct kvm_stats_header) + KVM_STATS_NAME_SIZE +
+		       sizeof(kvm_vm_stats_desc),
+};
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

