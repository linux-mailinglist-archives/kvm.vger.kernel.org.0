Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4585A41936E
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234306AbhI0Loq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:44:46 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:8740 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234053AbhI0Lob (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:44:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742974; x=1664278974;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=+z4VyqNMDh68rsrg5YDCrOjN16jgzs4QX071Yspmc7s=;
  b=DvEVthULt/NwMc9UlZ4CeEAawm7NGYh5qKid5d2MDgMjyZ3SF7V1WWvF
   y+4/hdV2YVDsX4wAOEoXwnEue2AZYIU9yQumWF6Sfkb321ayDu1v3hcWy
   BnzDlagQlSJN/cBOZy5pVBJVxWr88mP/LfzaWsbUdfGp2CNTjxIutxQPo
   2WeSnRaAkxougO3k+3LnAgaZ7nc89S2EPhtcpXFOBnqF6kr5/CaRi/8N3
   GJ1lawfZMxjC5cj0o2e1BoOuKupu6A8KlJBw0wsFiQlfqjSNSp+LWiTWO
   DtMu9jzIXdZFLHEXyHjkuCl4n/TYBbIrOlZPcyPAUSWbAbHzeTejs6mdO
   w==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="284861962"
Received: from mail-dm6nam10lp2105.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.105])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:42:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AsXbfC9B3T+PI3mOhNNk8sUzmz7EPgy30I/CmRQT5lCkzcJ99ETgvfTiJQP0AdOoXxu79VCD6QsG1rdXVZqEOzRhiG0UQoLCTZcP6HXMZ4hNNc9wfN5TVNnMvZIOz79YzgCzIP5SQ5s5w7YuVNh7hJ7AJlaVTSlP6Uv5UtMtJHSIyBlFaqxkAfANBfySFjJBjKaf7/2JEQNVL8APPh9pXkel4tndI9Cy9U2eBgTMbKetK2FwBXFLTF+Udnq6GwhPsZD/d0gAcNZ0lfa6VmlTlb/7mEItgY7OgLZutXvdj20o1Q6awTV0FBdcajJcFi4RD4MADMtgQggGXRZSoIfL0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=nYxooHB67uEiqk8rm2bx7Jss/vz5cqsnLFSU757edUU=;
 b=B4va3kT6NtlMEPpNgkT7Qrp5P9ybPZSvZ8sHXJYKBLlLmgLaLWfsEZ6mJs7xY5sGjXTQeo5e4otBZStz+z8bhSneDajsMupj8Tu9UNYjaRtSWITOlvNfLEhU2sPQ/1ig3/6VaXC5569LH3kiGCJnYun2IrciipqfVpJa9+42sURPWGVIM78Hnl3xIuJtaMIzWIAQwbTJb1PKAtbpPwj1d5w2h32h2dRfcHLOr5IpqmVBrKHB5o+vzwimFYrupGn/anJhzH+5SfYVrHplqQ7ytB+W9+cpFEtY3xaRZo3NCkI4YwjJz6B5wh9RGKoGXwFtvvR9ilmD7lOrJfjQUbU63w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nYxooHB67uEiqk8rm2bx7Jss/vz5cqsnLFSU757edUU=;
 b=Hj++PPjVPTgtk1CzUXvdu7oz4NM7PgIUzyO+rb675Xv9At5DmuTzfFp06peBMm/hkNuQFXOA54s5ISh/JuGNWy62Rit24CDWqRIxlVG/QtT0sKhvN11KbNY0tLvI0pd5A7pR/qO5tQnj7Dxzs5vw6s5ovDzejqxV2uNmZn4MDJw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO1PR04MB8236.namprd04.prod.outlook.com (2603:10b6:303:163::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14; Mon, 27 Sep
 2021 11:42:52 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:42:52 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v9 2/8] riscv: Initial skeletal support
Date:   Mon, 27 Sep 2021 17:12:21 +0530
Message-Id: <20210927114227.1089403-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114227.1089403-1-anup.patel@wdc.com>
References: <20210927114227.1089403-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a01:d::14) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MA1PR01CA0173.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a01:d::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.14 via Frontend Transport; Mon, 27 Sep 2021 11:42:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6e03d676-6a2d-49be-0908-08d981abf02f
X-MS-TrafficTypeDiagnostic: CO1PR04MB8236:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR04MB8236D138B6C01F8D87DB3A748DA79@CO1PR04MB8236.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dd0vwt+P3itCzdcc4ioiY3/dFhs5rXjcbJtWZyCZaQms3j9B+lfF2nTYUSIlaIFU/dvkDD2CLofWovryagtwWDQJReFzioYhQqxwvqy1S5bEvMjJNhvS6bXXQ4i+atqpO8fgTpVzfgo/n9LZ+dkcOA4bvj+ytBzqlMZntH41544InFqyTmil+Ssu/0/fC9f/h7oZOtZTwdF/PGZt3QJrYfDeRRhZkb+YfX5o9l9KjGXH2UEt3apXs0f/Cp6lkeAjlZWSrFvoZxIXY5YeegPcu4wOKJpHOCiEE5haMWg3NXhJfXFIywrFfxy9622dkCFpFgVqA8bwQ9Ah02zLxnbYARtMrgBshfG69aMOMSGBB0xCt9SA2hKNIYQyOIHL2z/88pj35frRMnHt7C1UZQrYEjj2Fc1VMw6/bj2o7X5l1lJdRwY/hRLV47yI/2AdDaaTxgWIvCoqlL6rjk4gkxhsuL3sRB6XX5gMWj6FSHZiOpXFJtx1RCKHvkcfJiLMGqi8PW+FSAFMkZn+X1k256QA2sfB4wjsw6m4NxUA1xn5ekVEHOrSNgNLH7JxquJ5lrq8d7tLoQJlOSfRZVyLjRH93Wvzmrs7h39EyypdtPiJlkgaWUkSLpu9c46iTnGeNnw+2QpMIqJhdyrwn4dPDo5RIhF0LCCKcmnHIWFdIeX2xT2z7q3uge4itoDcon75sD4v
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(316002)(66946007)(44832011)(38100700002)(54906003)(186003)(55016002)(38350700002)(8936002)(508600001)(7696005)(6666004)(1076003)(36756003)(66476007)(66556008)(4326008)(2616005)(5660300002)(86362001)(2906002)(8676002)(8886007)(52116002)(26005)(83380400001)(30864003)(956004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?g6F+1E13rP0uCN4rmtR75SnqFBBdjJX4Ud5BPcy7HQlTDegQp0fpa9Qp9pJW?=
 =?us-ascii?Q?e+kyLf8fUf6VBFRUECaRBUXCjSNAPSPJuEWHI/LGgFt857ZlXjy3Gl5SMZeh?=
 =?us-ascii?Q?24/HANbia3qQrLYrcjZpuqqFDgGklxjnZqk4lzwB7a2vGHYI6kJ5OORIVU+E?=
 =?us-ascii?Q?vlHVsd0JBvkkAyAAhbz7leUU9MSqyNRZMbA+ex439OK+hKjCj/jt1AtcGdgT?=
 =?us-ascii?Q?BG3WiTKZmVVbPCG0XCf2DVh1Iuqagdbl2EBLUGKi9gggssY/2Pq8GripjjjO?=
 =?us-ascii?Q?26nYicQNxebo7Mz1HJtiDuHMzMoXdi8e0BJGmZ2pVUgA7ALOhBidMIwLHJI6?=
 =?us-ascii?Q?5zNT6idF4G4Rl2t5s49UQe9dE31wyk5OJQQ74DCq2r4sZS0LwSOU1v59jpib?=
 =?us-ascii?Q?9EdeESBn6si4B9OzQFEjlZbMu0u4N5vBXXzpibovwpLcol0DrSAgn8U2QHd0?=
 =?us-ascii?Q?R+bqCQ7EH32RQCCJWQdyNCV3Ifp+p7Kf3DW+l37aJ1M8sfn7x//t5HM0g4qL?=
 =?us-ascii?Q?F0vJNnT+8FhjcJJt+qnllPaU/ISGAN4ZBIVwYt4e5usqkIb7EuxVj9GYXdmQ?=
 =?us-ascii?Q?2li+CIQeSnj/VG8QyddVkm3bu35Qyc45iIJ45A+AjJcvrca0b5GPObxf6Dj6?=
 =?us-ascii?Q?EcHN6lXP1xjrYjEoHu/CazL5vQM6EO2tv/HW2SBXkIP9KpN6Ik0yGV/g4ySG?=
 =?us-ascii?Q?1OjyiEzKTxvxM931/c6u//vClT6CtLG9Vh1bTQJVx/wdoFlLk9+obMCLuJOg?=
 =?us-ascii?Q?fj7h0MAi9jXiYRPPCxx5P5cSvAPSJtaDMYZzDPZNNK1R9mBmponhEv6ASFbM?=
 =?us-ascii?Q?iYosnXUO2GXgeRKU+gChYQ0nP8XN+2IN2gXipCsv5dP+2Z7KbaqIxnD6S1w3?=
 =?us-ascii?Q?gzRg+VwvwgCiLejWUb87Nt6mP6cm42bBQ+Aepm+pb1XmC45hoPz07qMntqX3?=
 =?us-ascii?Q?RX35ngT1ylwbxxbHCNVXcRFfiWwWQ/S8VkaqiwjPfi/vwzWbMTDr3wTZ2AUd?=
 =?us-ascii?Q?/kqkNsTtKPM0Hnm00Mm24Q0+JTbFVMNY3qMATXYnKdBD6z0U4ZHCmOUL1JVS?=
 =?us-ascii?Q?aMn7xkqTOY9PWW1rqfTP3Ochcg2MkimoCAFUk61isGbsKKwrZ8lF2+jjUopu?=
 =?us-ascii?Q?M8BZCFGgCYdyPsaciWo6/+VpDb82eodM7bKZKdA+GKs3qcFIe8+3KlZWfqbA?=
 =?us-ascii?Q?QYMlisr45k10Z1ijbwawd0Sn5gXq0IYyewHuZTJG26d6UySEshth+vr4f98w?=
 =?us-ascii?Q?XrkW5o6jvhaGfbw6+Vb8c9qBmLg0EOdkIbgu9ZdOZQNjCX1XyLBWBcndkEfG?=
 =?us-ascii?Q?HbUJChCzq8tliytGlhS6FwEx?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e03d676-6a2d-49be-0908-08d981abf02f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:42:52.0014
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uhgMXUadDjlOVX+6PZFr+FE8/kJBo4NlWo6DqJINl07zb7rkYHUcIt0p5vBt1Ni9tKLauBIvv1yda+rqqdjilA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR04MB8236
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds initial skeletal KVMTOOL RISC-V support which
just compiles for RV32 and RV64 host.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 INSTALL                             |   7 +-
 Makefile                            |  21 ++++-
 riscv/include/asm/kvm.h             | 128 ++++++++++++++++++++++++++++
 riscv/include/kvm/barrier.h         |  14 +++
 riscv/include/kvm/fdt-arch.h        |   4 +
 riscv/include/kvm/kvm-arch.h        |  66 ++++++++++++++
 riscv/include/kvm/kvm-config-arch.h |   9 ++
 riscv/include/kvm/kvm-cpu-arch.h    |  47 ++++++++++
 riscv/ioport.c                      |   7 ++
 riscv/irq.c                         |  13 +++
 riscv/kvm-cpu.c                     |  64 ++++++++++++++
 riscv/kvm.c                         |  61 +++++++++++++
 util/update_headers.sh              |   2 +-
 13 files changed, 438 insertions(+), 5 deletions(-)
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
index bb7ad3e..817f45c 100644
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
index 0000000..f808ad1
--- /dev/null
+++ b/riscv/include/asm/kvm.h
@@ -0,0 +1,128 @@
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
+	unsigned long scounteren;
+};
+
+/* TIMER registers for KVM_GET_ONE_REG and KVM_SET_ONE_REG */
+struct kvm_riscv_timer {
+	__u64 frequency;
+	__u64 time;
+	__u64 compare;
+	__u64 state;
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
+		(offsetof(struct kvm_riscv_timer, name) / sizeof(__u64))
+
+/* F extension registers are mapped as type 5 */
+#define KVM_REG_RISCV_FP_F		(0x05 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_F_REG(name)	\
+		(offsetof(struct __riscv_f_ext_state, name) / sizeof(__u32))
+
+/* D extension registers are mapped as type 6 */
+#define KVM_REG_RISCV_FP_D		(0x06 << KVM_REG_RISCV_TYPE_SHIFT)
+#define KVM_REG_RISCV_FP_D_REG(name)	\
+		(offsetof(struct __riscv_d_ext_state, name) / sizeof(__u64))
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
index 0000000..469fe4f
--- /dev/null
+++ b/riscv/include/kvm/kvm-arch.h
@@ -0,0 +1,66 @@
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
+#define ARCH_HAS_PCI_EXP	1
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
index 0000000..24092c9
--- /dev/null
+++ b/riscv/ioport.c
@@ -0,0 +1,7 @@
+#include "kvm/ioport.h"
+#include "kvm/irq.h"
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

