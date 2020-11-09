Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893502AB744
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729883AbgKILhp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:37:45 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:38405 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729797AbgKILho (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:37:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921864; x=1636457864;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=gQ/pZiiVf1avEh3y4hyNF7j3z4JDgo6pqkUprWdlW40=;
  b=Irn1Y7awK0oj2pEC+HwZKgBE5HJlRwVIZr/+E/94d1w70kkNH+uA4Mwz
   eiKe+h1CBtIBMeiX1IXn/y5ctJv1XsORuGFxugwEYVw2OXO1HLazXBP25
   6d8eFTdShe7gCyjDKY9J3y7Jix3yEWrFmVe9Nr2pSPxjDqig5hWF3dMC3
   h69H0YGTCQNR6DwEtIE8Hg/yNZmw5qABKnqDFHtb+UebtnAxmsn6LUrDA
   0rcly/iwZLUUeKQUONCr77FTNdYLsk7CZp9oOJfDB1Mxzn++UtX/PvA7W
   vpypHrsxiKBjnmd2qP1WNQj5qAsQy1asF3nDZWrUCArSxTEQSKyFdcf+X
   w==;
IronPort-SDR: 2pMc9kzh1ITCEakaBIIMSpkiURSOBravijVU9XQz4Zz+Ll1QFbklbjKOq93b7R4OO0m/pZWRpm
 ZJssfVF5peo2E+pWEav1dUoknUvgGiOYAPaTVNyKx8YLles80DTvHfq8RXP0cupO58mJwnWJg1
 ScGz5PCdrQfgo1hBpvOyqUF4s0LNgC8DPmgBfXzoR4aGmKeC/6zKKQ0oB5J1L8DMO7ByNqZbGV
 x4EHMf+qMUIm5BehFFBe6b7shz/fxNYGzoeBSobMN+oLpOvAJr+vjPB0X5I1PZLtEteNWoeGcV
 Dfo=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="152081220"
Received: from mail-bn8nam08lp2049.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.49])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:37:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eaJrGotByOpN06Jn4EW7JMRvRAqlsoKWy13cKTmAO6pP3dOhmnEovGsWy8ZTemEMvZHJPM8nNuNULns/u8xegagmxsvVv3QSIbjKra5Eav697SNibbq03ZGQyHfvwX6WazkamvRggZhaKFIDBZ+3/vOaZQX5X/HqYEoMIftjZdgt7TiDDwCrUjU9Pt5CgiA+7IiCSr5+2l3O0gbKZu7hAUjV5S2PGS7njKJsuxCiLX7rtUjPt/UKPtJbI7UjCwXEd/jrNC0l4TaNVUxIi6WF5LxBQ8Z8KXohDQIpoMXIxxFkGXYPq8J4aOAO8+6unoMsoCpL17vtAxLuWyyxwWyLgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lH36t+ewqd0TqFqRziwe3VJR2WHQOYGl/vuwPZK+IEk=;
 b=miJOUUAUUiM8Sfd7k+TxAF4qYJkfUvPTYd/ie1nVOROFvar1UukquMcIkGH9mrD99BAZ0KoZmwrOu9Yk6fXV9DHtBEecwY24Y1eDmlHpR9MYHQBEqXvGI3vo1+tXTKVGOsRxgyS27meVQhVzb9PbAFvsYu/pSAEYr+hgHocvpEbWItkumNTSt2awJLnRTQqXTVlpQtJ+/N5U0FJGp92n21gMUJxTbTTQxJFbeGLiquOg8DjYlkROR9hvYM91pUU5ICDzi5twPgVJoWosbnqPhWYoUCJDU9mw1wQw19Z0Hgpl6k4iNgUzVr4AdaQsRO/kKTLKWo6LJ/mLzhaQm1vOug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lH36t+ewqd0TqFqRziwe3VJR2WHQOYGl/vuwPZK+IEk=;
 b=o0ulDrDyV9JP4/1/cLEP68vnBD8I/kSeAUWUB4A2k9BxFkSaaAI6pvRMpnoQqTBA5w8iXaH/KAmRDoC5ex7ukzeBXN1Y8rIjboB7gUvJLWinyhu9uSq/zldA3xrVqR4s5tvbCZxB+Rl3m4fo8sg9KPKnFmGBp1AmFRfbMVlVeb0=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB3866.namprd04.prod.outlook.com (2603:10b6:5:ad::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:37:42 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:37:42 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 2/8] riscv: Initial skeletal support
Date:   Mon,  9 Nov 2020 17:06:49 +0530
Message-Id: <20201109113655.3733700-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201109113655.3733700-1-anup.patel@wdc.com>
References: <20201109113655.3733700-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.171.188.68]
X-ClientProxiedBy: MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34)
 To DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1bec21c7-5089-46d9-b057-08d884a3de6a
X-MS-TrafficTypeDiagnostic: DM6PR04MB3866:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB38667C9AA0E54089021FB25A8DEA0@DM6PR04MB3866.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lda4z29u5sJNCmGhaGgjWDHYe7LK69H5dP6nXyyeHViautQPvH9PKryjd+f3xvsuyKy+ON1f/eM5A5On8m236ta//J8S73Bx9UYj1734+IOe+TSZVbqn8tq84hO1Qi0wqpDoELfukzDHIHeWS1CGtw39SG4fVC1voWO0euWS5MkA25WK9pUOTmEayomTxoDxqCKrtQ7lRsntzUspZVMW8AHpG2x8Q4h4Q0mYSuM2ypmbsp25AxGExi+rs2mMNt8yoIHwZ4UhPWrFPcmqlSKqAQ9u201fyRUzBmygYExTyLeMtE9xZ4e1xq0DCVM+fzk/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39860400002)(376002)(55016002)(83380400001)(6916009)(1076003)(44832011)(16526019)(186003)(316002)(26005)(8676002)(54906003)(5660300002)(52116002)(7696005)(956004)(30864003)(2616005)(478600001)(66476007)(66556008)(4326008)(66946007)(6666004)(2906002)(36756003)(86362001)(8886007)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 8wcq7KfAF/iH5yg/PPVOMtL74CAl7UQj8OqO66QG760+nNm9B3GPo+a96YQE3+Gk2kt7BTo7nAdTWNe+NRROe4zyE+8eVPIkbZqnQu32YS+7xdr+yrwy8gwk/6BoLG7bSZ7IRBAccqqEl0X9wt1W1YXnqnQl4QSCSYliSVWKBQ5yymuQZIfztEUtiikF5PYFuKUSPnx0Bws+uOzc1LjBNXcilx720zVe/5IDEKj0trPkrXCG0K+0Qzw0uYlQqvItcCKW8sv0dmdcYzMvCFLH/uHV650InzU2OpD3qh9kPN2EdRPCwMlWPcT9YEczylu38HHqNawJWq4NB7rZUGtDzv0BvpPVKcwyM26tTKVmX34TcRufnbJI2F2vuVr9gUMm54A4vmBrduJi3ZZn2/iflkjBH3KRXWYOyBg6jgOwFVJjeVgYkIVzzy0FexKj76BfBLf46OwNHqKBFNkeRGUkrkfqVbXid3m8Rgxw1AhYm04n9GjsG5pLd1Nx4Wf1r64mXgd7tXz6bKPejxtFTqf3KH0TZh0oAsHXWl4tKHMt+FzRdQAtMKoc6QtpOjX4EiFrhtI2RUZoxNZOw19xxdn2e9hLv3WY5jeOI7ol+AUHxRCjg+xcSjYxs42Yg9TGlIUZSWEidzkimFmr7oFUDZRNwA==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1bec21c7-5089-46d9-b057-08d884a3de6a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:37:42.2502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UApcIWTytzmtgiX1BJkNwNB5tiQg4KHs34+UYEeJhjHkVqQ96OpVDAIBa76cLLCDnvcMor4YhIoWHah4w0mTXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB3866
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
 riscv/ioport.c                      |  12 +++
 riscv/irq.c                         |  13 +++
 riscv/kvm-cpu.c                     |  64 ++++++++++++++
 riscv/kvm.c                         |  61 +++++++++++++
 util/update_headers.sh              |   2 +-
 13 files changed, 440 insertions(+), 5 deletions(-)
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
index 35bb118..1782cb7 100644
--- a/Makefile
+++ b/Makefile
@@ -105,7 +105,8 @@ OBJS	+= virtio/mmio.o
 
 # Translate uname -m into ARCH string
 ARCH ?= $(shell uname -m | sed -e s/i.86/i386/ -e s/ppc.*/powerpc/ \
-	  -e s/armv.*/arm/ -e s/aarch64.*/arm64/ -e s/mips64/mips/)
+	  -e s/armv.*/arm/ -e s/aarch64.*/arm64/ -e s/mips64/mips/ \
+	  -e s/riscv64/riscv/ -e s/riscv32/riscv/)
 
 ifeq ($(ARCH),i386)
 	ARCH         := x86
@@ -193,6 +194,24 @@ ifeq ($(ARCH),mips)
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
index 0000000..cebe362
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
+#define KVM_IRQ_OFFSET		1
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
index 0000000..2f0feb9
--- /dev/null
+++ b/riscv/ioport.c
@@ -0,0 +1,12 @@
+#include "kvm/ioport.h"
+#include "kvm/irq.h"
+
+int ioport__setup_arch(struct kvm *kvm)
+{
+	return 0;
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
index 049dfe4..5f9cd32 100755
--- a/util/update_headers.sh
+++ b/util/update_headers.sh
@@ -36,7 +36,7 @@ copy_optional_arch () {
 	fi
 }
 
-for arch in arm64 mips powerpc x86
+for arch in arm64 mips powerpc riscv x86
 do
 	case "$arch" in
 		arm64)	KVMTOOL_PATH=arm/aarch64
-- 
2.25.1

