Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3E1919945B
	for <lists+kvm@lfdr.de>; Tue, 31 Mar 2020 12:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730570AbgCaKyX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 31 Mar 2020 06:54:23 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:1550 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgCaKyV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 31 Mar 2020 06:54:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1585652061; x=1617188061;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version;
  bh=TTh2tUpitasHZX+jknLpdUbm1+r7aLDyvSq+JA4/y6s=;
  b=Z02E6LZKiSEBoIQe8XHFLjntIdiQFPSTLQL7J3IZLQr6F/9bCVKPBBPu
   fdep2VS5qFcqekRVIi5ns+Da69doOe0f3/yy3eSiODh/geQUsPIbm+mQz
   TqC55PKH14mi9ZvCU7j8s7Ke8gfcSwccZJQIbsEKMjxh6L08jmuTgKpBJ
   IuVWMjDrMEbkOjk5EuwDEv1DixFNoI+Svs63OHqT9G2fjg7PU09X5KOuC
   sGjue2JTflVhjg+/NZWmvmwT4+N5uN7lkhJo+USRZahvO3Vs4ZQ4TW53b
   qpl7Aj3alAfXkBj9EtY/oNY5F/JiP5mBjz/KcMO3ihI3VSs0lUO2OsA8r
   A==;
IronPort-SDR: Ob9wYPCWWEE4g7RgaaJXxUnYVYS3xlRV6U+drA/iZnYufryQ3cgsy7FzitPDodBCZ7HSSCeBtm
 CmuVmIsDl14cJGfczAQnfHFwfW5imbUQBL0d4NWjpVofvjdZk3FiO0HDiyjmse00nhEfzqLQ5q
 zupI1a5ICkReHp/hW743cHUBXZdnsYxgkss8BU/9/+ry00pk2JvoohwudXJ7ljLrpwzaPW+GsY
 JPa98TCAmZG/+JFKSpLtTcF0S5AXZj7QoPOSZ06mc8+z+OPMmK0aRbiHpoJqu2LuCLO2Lx4QLH
 eqw=
X-IronPort-AV: E=Sophos;i="5.72,327,1580745600"; 
   d="scan'208";a="138377129"
Received: from mail-mw2nam10lp2102.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.102])
  by ob1.hgst.iphmx.com with ESMTP; 31 Mar 2020 18:54:20 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cUXGTWL1ujuCiCqQ9tqbvxC1TGdqYCMI/fN1VIj8E0BYxsQLWXSDAvCsy3snTpyQM4HVV7VdnMNrBJ9z4tAdKeDX4Icqjaz5Pj6FamqUmOtcyrGAU2W4Hu8KbQPU9OeFLHfbympRTo03/aswoZFz3dcvZ2nxIZI/yvevk+bGiW+WI/QkC+XAi9ovqMu7tmyL5eGkB2Y3mcLZqZQVKYUikyDoQdvdNGGYv6Su/Z+bYurpUsdXHpzdzk8tidJTScpR0LiUBglFF/hBuTIlw80jFeidkCtpX7L2Jb40O+uISHqJvEdFT7p31jJP0U2pSlrorsqKXkImahxC5jlPUgf55w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulFCjO1Kcbymk9tyU/A6U0ka32hEdYFfq9Dla1rvetc=;
 b=DQ0GlfaGcuCDHbHtIzTHdO/+CTaAL+gsa0IflxrNpGr6YsVy+ZaxINmQQBYdohskIFXgPVuNSeaj7NKceWG3ceUbssuDXkoCYwp75oIUSW7EoN0aDRaon4WLZzDfOG9PzlAu+/PCYddQCx0wAXcYCFxd/lpiw9KHPxXlx86DJcQTzvWawnxUWuKO1HPd6HqhOLuB2uaAKXpv6x7krhxcm6flbKKcRJeLMxslQdRGzbEck6unhXgPfe9PGt4tqwR1B6YH6UJfAEUXu3NUy+XC72FBQaLAdIySXlsQcC290AiQcNp9jp5hL8iKdU6MTVSV1XRWDFdSzg1Q+fqCd3AvPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ulFCjO1Kcbymk9tyU/A6U0ka32hEdYFfq9Dla1rvetc=;
 b=x48doU49o47BVPgJz9hiRhC+Y2mhJ4alJa+QxZ3zZz06HqyOrKfbjo8vqtSQXk3BHmVHOT+EFBVw0sB5btummIWmgPLi7Xe2dfsw2hSKDTu2U1ic2iyLxMH7RzGucFiCkCSsVDWPRZF3hts7n3BIfA6Cul39bIEA6drBEEF5OJ8=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
 by MN2PR04MB7088.namprd04.prod.outlook.com (2603:10b6:208:1e1::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20; Tue, 31 Mar
 2020 10:54:18 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::159d:10c9:f6df:64c8%6]) with mapi id 15.20.2856.019; Tue, 31 Mar 2020
 10:54:18 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v3 2/8] riscv: Initial skeletal support
Date:   Tue, 31 Mar 2020 16:23:27 +0530
Message-Id: <20200331105333.52296-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200331105333.52296-1-anup.patel@wdc.com>
References: <20200331105333.52296-1-anup.patel@wdc.com>
Content-Type: text/plain
X-ClientProxiedBy: BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:19::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (49.207.59.117) by BM1PR0101CA0049.INDPRD01.PROD.OUTLOOK.COM (2603:1096:b00:19::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.20 via Frontend Transport; Tue, 31 Mar 2020 10:54:10 +0000
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [49.207.59.117]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: ce570380-5f1b-4003-d2b1-08d7d561d973
X-MS-TrafficTypeDiagnostic: MN2PR04MB7088:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR04MB70885949506187976FBE48C78DC80@MN2PR04MB7088.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-Forefront-PRVS: 0359162B6D
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR04MB6061.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(8886007)(1006002)(6666004)(2906002)(478600001)(316002)(7696005)(52116002)(36756003)(6916009)(54906003)(16526019)(81156014)(8676002)(186003)(2616005)(81166006)(1076003)(8936002)(55016002)(44832011)(5660300002)(956004)(66946007)(66556008)(86362001)(30864003)(26005)(4326008)(66476007)(55236004);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MP+sLkCVej8zwm7OznBPybk42OsZ5OYxe7TDe0zYROlotU7hEgyZAI5jSjpajzZLAgfTIsZCxB5erMAXCw19hkexd+HZrcLwCByuhj7kMMqN04rFHs/w4dyB8cxi/0735dthMUH4N4pH6KqpivDPswSXFcFYUEGLZymkTx3bJ9KMuACad7UXLb3JoRGPRNKqmMEevD72N0qvBdipjOFQ/MutcZYOEYiApH0m571BN/IV7wgTj1siF4ZPcbhh/lQ0rbDbd5zEH1QQ9WGohW1N34pggK5WJLg/Y5tFCYpXMqU3MGQi+dv/V6G3OvXojFK9xla+zWg4nWefsuytJxGs7rk5HoICUJ7KrEOaPnm5q/GXxgN2uc3ttdH5/HUfkM90TRsaMI96Zd6JOo9zXmAvRL9q7OUMZSETGISYgAz2It/JpZTF74jbdNY3/KBBqJJS
X-MS-Exchange-AntiSpam-MessageData: WtREoltHc0lVK6MRXDqiIb+qh8Qeg/Snff6V/IQtr90Pw61ns+rPFhMNlELx1u3oHLLw2+25BsAOmz+Gep9TEUOpOk2yy7g8UX2y5ut6tolyhxdoq2Jd+ZCqnFdAELcSJTAYEUi4y7XMIFV+mpqDsA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce570380-5f1b-4003-d2b1-08d7d561d973
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2020 10:54:18.3255
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UcL1qNAEfRvGq8KaMfBJ6MtrMyjEUZxyod2CC6zl5q3lkFJdkZxDvsnMHwGqBJ7s0RZFX8T4buDyabIyhL2A/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7088
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds initial skeletal KVMTOOL RISC-V support which
just compiles for RV32 and RV64 host.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 INSTALL                             |   7 +-
 Makefile                            |  21 ++++-
 riscv/include/asm/kvm.h             | 127 ++++++++++++++++++++++++++++
 riscv/include/kvm/barrier.h         |  14 +++
 riscv/include/kvm/fdt-arch.h        |   4 +
 riscv/include/kvm/kvm-arch.h        |  64 ++++++++++++++
 riscv/include/kvm/kvm-config-arch.h |   9 ++
 riscv/include/kvm/kvm-cpu-arch.h    |  47 ++++++++++
 riscv/ioport.c                      |  11 +++
 riscv/irq.c                         |  13 +++
 riscv/kvm-cpu.c                     |  64 ++++++++++++++
 riscv/kvm.c                         |  61 +++++++++++++
 util/update_headers.sh              |   2 +-
 13 files changed, 439 insertions(+), 5 deletions(-)
 create mode 100644 riscv/include/asm/kvm.h
 create mode 100644 riscv/include/kvm/barrier.h
 create mode 100644 riscv/include/kvm/fdt-arch.h
 create mode 100644 riscv/include/kvm/kvm-arch.h
 create mode 100644 riscv/include/kvm/kvm-config-arch.h
 create mode 100644 riscv/include/kvm/kvm-cpu-arch.h
 create mode 100644 riscv/ioport.c
 create mode 100644 riscv/irq.c
 create mode 100644 riscv/kvm-cpu.c
 create mode 100644 riscv/kvm.c

diff --git a/INSTALL b/INSTALL
index ca8e022..951b123 100644
--- a/INSTALL
+++ b/INSTALL
@@ -26,8 +26,8 @@ For Fedora based systems:
 For OpenSUSE based systems:
 	# zypper install glibc-devel-static
 
-Architectures which require device tree (PowerPC, ARM, ARM64) also require
-libfdt.
+Architectures which require device tree (PowerPC, ARM, ARM64, RISC-V) also
+require libfdt.
 	deb: $ sudo apt-get install libfdt-dev
 	Fedora: # yum install libfdt-devel
 	OpenSUSE: # zypper install libfdt1-devel
@@ -64,6 +64,7 @@ to the Linux name of the architecture. Architectures supported:
 - arm
 - arm64
 - mips
+- riscv
 If ARCH is not provided, the target architecture will be automatically
 determined by running "uname -m" on your host, resulting in a native build.
 
@@ -81,7 +82,7 @@ On multiarch system you should be able to install those be appending
 the architecture name after the package (example for ARM64):
 $ sudo apt-get install libfdt-dev:arm64
 
-PowerPC and ARM/ARM64 require libfdt to be installed. If you cannot use
+PowerPC, ARM/ARM64 and RISC-V require libfdt to be installed. If you cannot use
 precompiled mulitarch packages, you could either copy the required header and
 library files from an installed target system into the SYSROOT (you will need
 /usr/include/*fdt*.h and /usr/lib64/libfdt-v.v.v.so and its symlinks), or you
diff --git a/Makefile b/Makefile
index 3862112..a557991 100644
--- a/Makefile
+++ b/Makefile
@@ -106,7 +106,8 @@ OBJS	+= hw/i8042.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
-	  -e s/armv.*/arm/ -e s/aarch64.*/arm64/ -e s/mips64/mips/)
+	  -e s/armv.*/arm/ -e s/aarch64.*/arm64/ -e s/mips64/mips/ \
+	  -e s/riscv64/riscv/ -e s/riscv32/riscv/)
 
 ifeq ($(ARCH),i386)
 	ARCH         := x86
@@ -190,6 +191,24 @@ ifeq ($(ARCH),mips)
 	OBJS		+= mips/kvm.o
 	OBJS		+= mips/kvm-cpu.o
 endif
+
+# RISC-V (RV32 and RV64)
+ifeq ($(ARCH),riscv)
+	DEFINES		+= -DCONFIG_RISCV
+	ARCH_INCLUDE	:= riscv/include
+	OBJS		+= riscv/ioport.o
+	OBJS		+= riscv/irq.o
+	OBJS		+= riscv/kvm.o
+	OBJS		+= riscv/kvm-cpu.o
+	ifeq ($(RISCV_XLEN),32)
+		CFLAGS	+= -mabi=ilp32d -march=rv32gc
+	endif
+	ifeq ($(RISCV_XLEN),64)
+		CFLAGS	+= -mabi=lp64d -march=rv64gc
+	endif
+
+	ARCH_WANT_LIBFDT := y
+endif
 ###
 
 ifeq (,$(ARCH_INCLUDE))
diff --git a/riscv/include/asm/kvm.h b/riscv/include/asm/kvm.h
new file mode 100644
index 0000000..f4274c2
--- /dev/null
+++ b/riscv/include/asm/kvm.h
@@ -0,0 +1,127 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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
+#define KVM_INTERRUPT_SET	-1U
+#define KVM_INTERRUPT_UNSET	-2U
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
+/* for KVM_GET_SREGS and KVM_SET_SREGS */
+struct kvm_sregs {
+};
+
+/* CONFIG registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_config {
+	unsigned long isa;
+};
+
+/* CORE registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_core {
+	struct user_regs_struct regs;
+	unsigned long mode;
+};
+
+/* Possible privilege modes for kvm_riscv_core */
+#define KVM_RISCV_MODE_S	1
+#define KVM_RISCV_MODE_U	0
+
+/* CSR registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_csr {
+	unsigned long sstatus;
+	unsigned long sie;
+	unsigned long stvec;
+	unsigned long sscratch;
+	unsigned long sepc;
+	unsigned long scause;
+	unsigned long stval;
+	unsigned long sip;
+	unsigned long satp;
+};
+
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
+#define KVM_REG_SIZE(id)		\
+	(1U << (((id) & KVM_REG_SIZE_MASK) >> KVM_REG_SIZE_SHIFT))
+
+/* If you need to interpret the index values, here is the key: */
+#define KVM_REG_RISCV_TYPE_MASK		0x00000000FF000000
+#define KVM_REG_RISCV_TYPE_SHIFT	24
+
+/* Config registers are mapped as type 1 */
+#define KVM_REG_RISCV_CONFIG		(0x01 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CONFIG_REG(name)	\
+	(offsetof(struct kvm_riscv_config, name) / sizeof(unsigned long))
+
+/* Core registers are mapped as type 2 */
+#define KVM_REG_RISCV_CORE		(0x02 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CORE_REG(name)	\
+		(offsetof(struct kvm_riscv_core, name) / sizeof(unsigned long))
+
+/* Control and status registers are mapped as type 3 */
+#define KVM_REG_RISCV_CSR		(0x03 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_CSR_REG(name)	\
+		(offsetof(struct kvm_riscv_csr, name) / sizeof(unsigned long))
+
+/* Timer registers are mapped as type 4 */
+#define KVM_REG_RISCV_TIMER		(0x04 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_TIMER_REG(name)	\
+		(offsetof(struct kvm_riscv_timer, name) / sizeof(u64))
+
+/* F extension registers are mapped as type 5 */
+#define KVM_REG_RISCV_FP_F		(0x05 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_F_REG(name)	\
+		(offsetof(struct __riscv_f_ext_state, name) / sizeof(u32))
+
+/* D extension registers are mapped as type 6 */
+#define KVM_REG_RISCV_FP_D		(0x06 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_D_REG(name)	\
+		(offsetof(struct __riscv_d_ext_state, name) / sizeof(u64))
+
+#endif
+
+#endif /* __LINUX_KVM_RISCV_H */
diff --git a/riscv/include/kvm/barrier.h b/riscv/include/kvm/barrier.h
new file mode 100644
index 0000000..235f610
--- /dev/null
+++ b/riscv/include/kvm/barrier.h
@@ -0,0 +1,14 @@
+#ifndef KVM__KVM_BARRIER_H
+#define KVM__KVM_BARRIER_H
+
+#define nop()		__asm__ __volatile__ ("nop")
+
+#define RISCV_FENCE(p, s) \
+	__asm__ __volatile__ ("fence " #p "," #s : : : "memory")
+
+/* These barriers need to enforce ordering on both devices or memory. */
+#define mb()		RISCV_FENCE(iorw,iorw)
+#define rmb()		RISCV_FENCE(ir,ir)
+#define wmb()		RISCV_FENCE(ow,ow)
+
+#endif /* KVM__KVM_BARRIER_H */
diff --git a/riscv/include/kvm/fdt-arch.h b/riscv/include/kvm/fdt-arch.h
new file mode 100644
index 0000000..9450fc5
--- /dev/null
+++ b/riscv/include/kvm/fdt-arch.h
@@ -0,0 +1,4 @@
+#ifndef KVM__KVM_FDT_H
+#define KVM__KVM_FDT_H
+
+#endif /* KVM__KVM_FDT_H */
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
new file mode 100644
index 0000000..6ab93cb
--- /dev/null
+++ b/riscv/include/kvm/kvm-arch.h
@@ -0,0 +1,64 @@
+#ifndef KVM__KVM_ARCH_H
+#define KVM__KVM_ARCH_H
+
+#include <stdbool.h>
+#include <linux/const.h>
+#include <linux/sizes.h>
+#include <linux/types.h>
+
+#define RISCV_IOPORT		0x00000000ULL
+#define RISCV_IOPORT_SIZE	SZ_64K
+#define RISCV_PLIC		0x0c000000ULL
+#define RISCV_PLIC_SIZE		SZ_64M
+#define RISCV_MMIO		0x10000000ULL
+#define RISCV_MMIO_SIZE		SZ_512M
+#define RISCV_PCI		0x30000000ULL
+/*
+ * KVMTOOL emulates legacy PCI config space with 24bits device address
+ * so 16M is sufficient but we reserve 256M to keep it future ready for
+ * PCIe config space with 28bits device address.
+ */
+#define RISCV_PCI_CFG_SIZE	SZ_256M
+#define RISCV_PCI_MMIO_SIZE	SZ_1G
+#define RISCV_PCI_SIZE		(RISCV_PCI_CFG_SIZE + RISCV_PCI_MMIO_SIZE)
+
+#define RISCV_RAM		0x80000000ULL
+
+#define RISCV_LOMAP_MAX_MEMORY	((1ULL << 32) - RISCV_RAM)
+#define RISCV_HIMAP_MAX_MEMORY	((1ULL << 40) - RISCV_RAM)
+
+#if __riscv_xlen == 64
+#define RISCV_MAX_MEMORY(kvm)	RISCV_HIMAP_MAX_MEMORY
+#elif __riscv_xlen == 32
+#define RISCV_MAX_MEMORY(kvm)	RISCV_LOMAP_MAX_MEMORY
+#endif
+
+#define KVM_IOPORT_AREA		RISCV_IOPORT
+#define KVM_PCI_CFG_AREA	RISCV_PCI
+#define KVM_PCI_MMIO_AREA	(KVM_PCI_CFG_AREA + RISCV_PCI_CFG_SIZE)
+#define KVM_VIRTIO_MMIO_AREA	RISCV_MMIO
+
+#define KVM_IOEVENTFD_HAS_PIO	0
+
+#define KVM_IRQ_OFFSET		0
+
+#define KVM_VM_TYPE		0
+
+#define VIRTIO_DEFAULT_TRANS(kvm)	VIRTIO_MMIO
+
+#define VIRTIO_RING_ENDIAN	VIRTIO_ENDIAN_LE
+
+struct kvm;
+
+struct kvm_arch {
+};
+
+static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
+{
+	u64 limit = KVM_IOPORT_AREA + RISCV_IOPORT_SIZE;
+	return phys_addr >= KVM_IOPORT_AREA && phys_addr < limit;
+}
+
+enum irq_type;
+
+#endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/include/kvm/kvm-config-arch.h b/riscv/include/kvm/kvm-config-arch.h
new file mode 100644
index 0000000..60c7333
--- /dev/null
+++ b/riscv/include/kvm/kvm-config-arch.h
@@ -0,0 +1,9 @@
+#ifndef KVM__KVM_CONFIG_ARCH_H
+#define KVM__KVM_CONFIG_ARCH_H
+
+#include "kvm/parse-options.h"
+
+struct kvm_config_arch {
+};
+
+#endif /* KVM__KVM_CONFIG_ARCH_H */
diff --git a/riscv/include/kvm/kvm-cpu-arch.h b/riscv/include/kvm/kvm-cpu-arch.h
new file mode 100644
index 0000000..ae6ae0a
--- /dev/null
+++ b/riscv/include/kvm/kvm-cpu-arch.h
@@ -0,0 +1,47 @@
+#ifndef KVM__KVM_CPU_ARCH_H
+#define KVM__KVM_CPU_ARCH_H
+
+#include <linux/kvm.h>
+#include <pthread.h>
+#include <stdbool.h>
+
+#include "kvm/kvm.h"
+
+struct kvm_cpu {
+	pthread_t	thread;
+
+	unsigned long   cpu_id;
+
+	struct kvm	*kvm;
+	int		vcpu_fd;
+	struct kvm_run	*kvm_run;
+	struct kvm_cpu_task	*task;
+
+	u8		is_running;
+	u8		paused;
+	u8		needs_nmi;
+
+	struct kvm_coalesced_mmio_ring	*ring;
+};
+
+static inline bool kvm_cpu__emulate_io(struct kvm_cpu *vcpu, u16 port,
+				       void *data, int direction,
+				       int size, u32 count)
+{
+	return false;
+}
+
+static inline bool kvm_cpu__emulate_mmio(struct kvm_cpu *vcpu, u64 phys_addr,
+					 u8 *data, u32 len, u8 is_write)
+{
+	if (riscv_addr_in_ioport_region(phys_addr)) {
+		int direction = is_write ? KVM_EXIT_IO_OUT : KVM_EXIT_IO_IN;
+		u16 port = (phys_addr - KVM_IOPORT_AREA) & USHRT_MAX;
+
+		return kvm__emulate_io(vcpu, port, data, direction, len, 1);
+	}
+
+	return kvm__emulate_mmio(vcpu, phys_addr, data, len, is_write);
+}
+
+#endif /* KVM__KVM_CPU_ARCH_H */
diff --git a/riscv/ioport.c b/riscv/ioport.c
new file mode 100644
index 0000000..bdd30b6
--- /dev/null
+++ b/riscv/ioport.c
@@ -0,0 +1,11 @@
+#include "kvm/ioport.h"
+#include "kvm/irq.h"
+
+void ioport__setup_arch(struct kvm *kvm)
+{
+}
+
+void ioport__map_irq(u8 *irq)
+{
+	*irq = irq__alloc_line();
+}
diff --git a/riscv/irq.c b/riscv/irq.c
new file mode 100644
index 0000000..8e605ef
--- /dev/null
+++ b/riscv/irq.c
@@ -0,0 +1,13 @@
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/irq.h"
+
+void kvm__irq_line(struct kvm *kvm, int irq, int level)
+{
+	/* TODO: */
+}
+
+void kvm__irq_trigger(struct kvm *kvm, int irq)
+{
+	/* TODO: */
+}
diff --git a/riscv/kvm-cpu.c b/riscv/kvm-cpu.c
new file mode 100644
index 0000000..e4b8fa5
--- /dev/null
+++ b/riscv/kvm-cpu.c
@@ -0,0 +1,64 @@
+#include "kvm/kvm-cpu.h"
+#include "kvm/kvm.h"
+#include "kvm/virtio.h"
+#include "kvm/term.h"
+
+#include <asm/ptrace.h>
+
+static int debug_fd;
+
+void kvm_cpu__set_debug_fd(int fd)
+{
+	debug_fd = fd;
+}
+
+int kvm_cpu__get_debug_fd(void)
+{
+	return debug_fd;
+}
+
+struct kvm_cpu *kvm_cpu__arch_init(struct kvm *kvm, unsigned long cpu_id)
+{
+	/* TODO: */
+	return NULL;
+}
+
+void kvm_cpu__arch_nmi(struct kvm_cpu *cpu)
+{
+}
+
+void kvm_cpu__delete(struct kvm_cpu *vcpu)
+{
+	/* TODO: */
+}
+
+bool kvm_cpu__handle_exit(struct kvm_cpu *vcpu)
+{
+	/* TODO: */
+	return false;
+}
+
+void kvm_cpu__show_page_tables(struct kvm_cpu *vcpu)
+{
+	/* TODO: */
+}
+
+void kvm_cpu__reset_vcpu(struct kvm_cpu *vcpu)
+{
+	/* TODO: */
+}
+
+int kvm_cpu__get_endianness(struct kvm_cpu *vcpu)
+{
+	return VIRTIO_ENDIAN_LE;
+}
+
+void kvm_cpu__show_code(struct kvm_cpu *vcpu)
+{
+	/* TODO: */
+}
+
+void kvm_cpu__show_registers(struct kvm_cpu *vcpu)
+{
+	/* TODO: */
+}
diff --git a/riscv/kvm.c b/riscv/kvm.c
new file mode 100644
index 0000000..e816ef5
--- /dev/null
+++ b/riscv/kvm.c
@@ -0,0 +1,61 @@
+#include "kvm/kvm.h"
+#include "kvm/util.h"
+#include "kvm/fdt.h"
+
+#include <linux/kernel.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+struct kvm_ext kvm_req_ext[] = {
+	{ DEFINE_KVM_EXT(KVM_CAP_ONE_REG) },
+	{ 0, 0 },
+};
+
+bool kvm__arch_cpu_supports_vm(void)
+{
+	/* The KVM capability check is enough. */
+	return true;
+}
+
+void kvm__init_ram(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm__arch_delete_ram(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm__arch_read_term(struct kvm *kvm)
+{
+	/* TODO: */
+}
+
+void kvm__arch_set_cmdline(char *cmdline, bool video)
+{
+	/* TODO: */
+}
+
+void kvm__arch_init(struct kvm *kvm, const char *hugetlbfs_path, u64 ram_size)
+{
+	/* TODO: */
+}
+
+bool kvm__arch_load_kernel_image(struct kvm *kvm, int fd_kernel, int fd_initrd,
+				 const char *kernel_cmdline)
+{
+	/* TODO: */
+	return true;
+}
+
+bool kvm__load_firmware(struct kvm *kvm, const char *firmware_filename)
+{
+	/* TODO: Firmware loading to be supported later. */
+	return false;
+}
+
+int kvm__arch_setup_firmware(struct kvm *kvm)
+{
+	return 0;
+}
diff --git a/util/update_headers.sh b/util/update_headers.sh
index bf87ef6..78eba1f 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -36,7 +36,7 @@ copy_optional_arch () {
 	fi
 }
 
-for arch in arm arm64 mips powerpc x86
+for arch in arm arm64 mips powerpc riscv x86
 do
 	case "$arch" in
 		arm) KVMTOOL_PATH=arm/aarch32 ;;
-- 
2.17.1

