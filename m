Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DC17351B53
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236706AbhDASHd (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:33 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:26118 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237319AbhDASDj (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:03:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300220; x=1648836220;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=Qox8xPsCIJkgBVnKkGpnLbKkC1p9FSMW5BP6ZIK56dQ=;
  b=qzJi86/1dPRZK9rfOeyP+8bf0srGKjJQHBMYXymCAL9NtBUMy7Sgftpn
   oOz56VIshaHH1ckPhcfhIiLPr7SqTFhOti7brFAZkuLtKJoET2haYlQPD
   8DniCgb42hH++ppVh7FdRmCCDKzN7VYklgzLxkd05QoBChd7nfWwsKcaN
   0lRuwcwMYmTmS4E0vcTQ/4O1uaeoPUR/7iNbFwb/iBXZuU9eFc9NFfAIl
   7kISZnv+S7aZ24BWTSOSZ+4fl3M1WGCwrpRkwBVq653X5YQFHs2+GERWq
   Gh2OVzvRF1uENtucLn/267bXKqZBMgnEc+ETKjdvkFLNvWO6+BQR5KZZL
   g==;
IronPort-SDR: uXdTWedaqQ35KszQ5cTgnasPE8WYlTzkME8OBQsZG+IgNBb0VST5EG1fDAGqyP2FF77YKQGUqr
 eTQCRCTCktjgVjKqAjR3mMO5AVY1wPcvxOMtdsW7N0alAcJQa1yIpS0Gr4K13ghBkS/3Z366kD
 zZ54T+yzeFqHS4GICoNJZcpQkTw3IcV6Fn7hTc965P/fem/I/XnPuMjutFgOHKw1pqWEkyjUZ+
 jiAANVWDy/c8ERTfvDExSwenufO167EAk9Rxbc25v1id3VLJ4A0WsOFkGABSyK71PxiwM2qLd9
 ouw=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="164583164"
Received: from mail-bl2nam02lp2056.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.56])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:42:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k5+isCrZ6L6Yxzze87gBMkGZEbONM+hyQIZ30TLrUoxS6NblQ8g20+XahPjVlMMbgyT2Bh/ObPEZvCw/j1ueWP6eZRM3Kg0aYw6HkunqwQNCUa2DMLliEdxt3v39B5amQxVkJVpyLdU1oHWBqJPWHfFCpIbdlhhJ+b07ed7ccNU0iJEFex6Blqa15sEaldaJ5EJmbU3thEl1Yn7s/bbhVHsmuamjQsqJ4QS5vuFCVc7oqzO6Qle+uaBbmX92qbZOfG6WEMMQ/y2nsnsuaVmQu641uIlfHTcHbYECR+uJIYlhlN1p9zJl36sKO8lk3EBtfsEx+eUWveiMENZEfSEqcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6U9qsGP4P1CMLQlUSxIGXa3aZnjIzcyrsTnW6Z0dlk=;
 b=HY02OyOg9pKcXY639v29mCLjsPVBZ9yiDnBc+4xEx2oC7Fy4+V6ZORCfL7pQlbwthkx9jUUnwCTOrqGKCMjlMdCr94KYyAWUHgRnJRDnl81KeeXozVUrSy7xfgPk9uhKCjZm1fjg7l+2aOqMNdDIEtVIL7uDzpvflegjhkMTLeBxxXyLND3Ta/IMlY5DkmIshIESJvVm7lkq9OBvHiqzIhQJjIP3N2LJo+HNEOlEcQPwkzS93AtGVKG8x10WlS9Yx9kkUGLLZ5x4msDbeA0TOYFCNjbmSbyOsp29Kg/yvo3tTDDt0gRGJogEBL9DuA124BG3bmch2HsICjmwzmfHUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r6U9qsGP4P1CMLQlUSxIGXa3aZnjIzcyrsTnW6Z0dlk=;
 b=DDz+G++fsFExbho4vlnxf59d+4d095LSyZO7OfWJImcV6NGhEodz8C13TboqSG3eUNJtPMOjNck0OaFwSE8U10oaVEzrhQgBE8Dx7/XlINrcE1hLUxOnNiJR2hBy2akC1DofjoLMS9QRUKnQ8cpkak13v3F8pJf1na4jhZGcYDU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0218.namprd04.prod.outlook.com (2603:10b6:3:77::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3999.27; Thu, 1 Apr 2021 13:41:53 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:41:53 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 2/8] riscv: Initial skeletal support
Date:   Thu,  1 Apr 2021 19:10:50 +0530
Message-Id: <20210401134056.384038-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401134056.384038-1-anup.patel@wdc.com>
References: <20210401134056.384038-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::29) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:41:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b3c2cd5-8679-49de-79ac-08d8f513e892
X-MS-TrafficTypeDiagnostic: DM5PR04MB0218:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB0218BC8E1D168998AB977E4A8D7B9@DM5PR04MB0218.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /i8ODiGzc48LMekRpKfAj94gqDH4GhB3UJBM80H69orHAbP8Kil0kQpSF0PqzxzAZwhY1fL4ASm5cT+BfI8k9fMvihnxfK8h9VuMW5cQoea1jnasabL8kFxZAG/EnES8w+lhwXk5ka69BzacZxh1yJXQEjhD7/ji5Pj1a1+7P1E1eBWsUTHbOxD6nzWT9FGpQAqJYD4yghqWYLu7xEGY9/O0OWriVMi4Gpk/4A26t6EWY6XVCcgMbnc//+MdX1/G6vDBWjF8gJXmaOdUyARO3wBlK4kscYAoDNx3V5Ss7zhd39/7/OevEEnHv3/tbRax6APrENwmZaaNKk3wOH5ZtWb6o2Z2CnKpkt1tFiGIdTOAp/YZuDRLBLU/4jm8Ud+zfgcaUkaEldCXL9j2l7Z+gqLcXaR8d/CDoPtItewA+YcOt5av+B128Z7Ad+IVQhot7blTaQktlnBQnEZ4dc3IAE/TAluQuMlrAWZ0ZKpKC/rPrBoli30R74UYknkg4TmWofFt4l4J3y9p9SPWjgJPOAQTppY1WL6b9xwsuNagQkJhB2tjaq92tabO2m6WEh6qh2GJloMgbuft/L+1wZH7TNavef2pwVvzgVDizaTHohuSAt1wzFp8000kbELB3FkMYGlFHJ0qD0blrvUbThpNHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(38100700001)(8676002)(6666004)(316002)(36756003)(8886007)(86362001)(66946007)(2906002)(186003)(16526019)(44832011)(1076003)(54906003)(30864003)(2616005)(956004)(83380400001)(478600001)(66556008)(66476007)(7696005)(26005)(8936002)(5660300002)(4326008)(52116002)(55016002)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?UsWxygNBShpEf4eh7RJWfRIZFlYNZF+mVEHXFft0eVIw4xfQ+kZOZKbJxTI6?=
 =?us-ascii?Q?JG1z67E3QBn6GEGSniMPjnbQW027vzPgY2kXWvwGDTkDQgaaU1jdZXRuaGqj?=
 =?us-ascii?Q?5hPhGMk3RfUbFTQqaqY6/OZSlQ49T8yrPC2beYwfd0hpAunG0kwJVSsmUn8g?=
 =?us-ascii?Q?+H/g5SMrQEgcBO/E8vSKQlxZ+oDlFeltIy+EtdHNoUHWBV8ldo58fY3KvSbZ?=
 =?us-ascii?Q?XjweaQqS2M4qEsFyrQg8H6V4g/gHM393M6sQXqkEjowfKizJzNRqwrHWe0Pl?=
 =?us-ascii?Q?Jqah3RjpjC8WXQc0D1u9vdL2Q6sUDX6CE/oLH1QrEMQRGMOaS4oQbvV+XGG/?=
 =?us-ascii?Q?Isqc/ahDd28oMl76Kv7hKTFKAmhy610hT2S49dyh7fsFcoooMNmc92N6RYO/?=
 =?us-ascii?Q?fl1oxryDhp/tuKJl8T2PZsR9uaKJdlUi+SC4DTZz+yiyqJOJB7xhxB2zyWNE?=
 =?us-ascii?Q?i3x8yaqcSt1UN6m78bu/SJObT9TH1xRipfV13V+b6MtXZrC+esJJhJvcXvpq?=
 =?us-ascii?Q?gqBBOiZWqejhsR+jFCkqsaUH9uE9naowiak5v4CdWEhnX75MZN7IEQ6UlE4m?=
 =?us-ascii?Q?BLpWYiEpKKvDqpg18D2jn6OnPNniirBKXw6fHVvQ/W1Z8I1QnYjPrdbmYBE3?=
 =?us-ascii?Q?bt3J0+Q7x39aSUsGf48UxQMGibSJ1lKhttIEL4MZRtBzCCAVDD5JMDTCnIQm?=
 =?us-ascii?Q?w/xeW4w1nl/K2HT9F5u2ckf2WCuF1DTQEucZEqVuQX2/ETRRyAL06ZKnX8IO?=
 =?us-ascii?Q?zI5jDuFogpE8H1GXpRldQK97LpmoBS/IrxIxvw+0McaXHIMbr1Y1/TgbOgsg?=
 =?us-ascii?Q?yGllZ36FChAYFEkPC0jDPI0dhjGqoFAapI1CsMu+NupMb9BZpLjhQ5trdEkC?=
 =?us-ascii?Q?NAStmQ/ZrL2riPiWewIUxKAxbBfomVqgLxzRA0mPA/AklzA6xpKWauqrqqVg?=
 =?us-ascii?Q?n0/MgiN3lwglxTSyhVR0Fv/rhkl3mQS5SQI2MOPPhVxTfJSNvumgQWM7sdgj?=
 =?us-ascii?Q?rswpk0rsirb+E6V69S57jaLBINydfUB0cpq1rLeRvW5VezzFJQRmCh84T+ZU?=
 =?us-ascii?Q?poNyp15dPnR4EgUi7iTqthP3wY8+FdIlBQTLV0VPF0LXzC6wm/P2n93+MRTU?=
 =?us-ascii?Q?kNctKS4ny1kXE41loE1rcgsa6qAY0lZ4TAAyRXEPTzQaVZSiD2QR1fme2TRt?=
 =?us-ascii?Q?LVHGj5Dz0LWFf7pcMzkbD/eytrJ7TicIOEyyxUkxwosoCJ2yrUTxxCYOojbA?=
 =?us-ascii?Q?Epa7aVVbeDQrMEHKeNQj3lfKK3BmSX8sB4gw1vjTAj92ENBbSOJnhh+j5TgL?=
 =?us-ascii?Q?AyqER0WJiknIOJaVeMZJyJ7z?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b3c2cd5-8679-49de-79ac-08d8f513e892
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:41:53.1680
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TFA1NQnQWYPFvXC7XxoxfNnHPOJs8xf6y0dWXqOqW8YnB4eYDNZElqaqe6DvAaipOwHQL2vn6aSJ9OkXXOJdEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0218
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
 riscv/include/kvm/kvm-arch.h        |  64 ++++++++++++++
 riscv/include/kvm/kvm-config-arch.h |   9 ++
 riscv/include/kvm/kvm-cpu-arch.h    |  47 ++++++++++
 riscv/ioport.c                      |   7 ++
 riscv/irq.c                         |  13 +++
 riscv/kvm-cpu.c                     |  64 ++++++++++++++
 riscv/kvm.c                         |  61 +++++++++++++
 util/update_headers.sh              |   2 +-
 13 files changed, 436 insertions(+), 5 deletions(-)
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

