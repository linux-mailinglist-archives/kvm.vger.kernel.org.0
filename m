Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E6045298F
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:23:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbhKPF0J (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:26:09 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:41820 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbhKPFZI (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:25:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040132; x=1668576132;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6FrTStNMxTRY47/1Ij2gs/5E/CKxoyuoM0DWklz+UDs=;
  b=VVhNZwp7xyF00mDLoUXlXFDJgibeO34+vn1GobBj+P1sy+XdSruDCDUm
   F82z+LPtobd7gupX58lto7FNSyW1xudimnDILSrconTk2l6rx/MJTT8le
   kS+d4EicsPXhGmOc7Fql5q8VfOwaefGXiTu/qlpVUEODbudCCgmWvLpDl
   +xhc/fx7D7yujoAqv3srhGhhCpwHPUzXWhKTxXcpw3PvTc00n55T4y96D
   9eeSVu5d5cZjg7pr3IsspCzfeS+mQ3N0VsXya67fQdCIn9mk/ziCFthMK
   I9VAwS2CUohU46ZS+76SzfojNEoOchyvNCRhZvZXej73sHTGLLQ8k/LHg
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="289638115"
Received: from mail-bn8nam08lp2049.outbound.protection.outlook.com (HELO NAM04-BN8-obe.outbound.protection.outlook.com) ([104.47.74.49])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XCQeTYbfQXpwFyRTIk5m69vn7H7ckJCjMWYRC7Qj3W2xdd3PXKjmDV5Fc1yRYJ3oxSdxnfORF9DccIEU0v7Qt05arh1ma1MHlc0YbPN8z7DB6IrODPrG1SaVSuowkO+FdKnpUHm07qJIW+dOZI9MfjYMCGVaXjLXdm5CnHqq9Hwo1Yo2Qsr6M9+fqprFVa747TphDbQ3Wi8gu5J/bMn6fqdP6XZe5Km/KCfCic1eT6Kcnsz5+08BaoOdFuJ60DHbfADFIM7UYO/tWhmVBg0ckWtfGRc/doZnKzLo5wWLQ/r61nqnj3PeFTbVD5Re7uGg9y9V3ZTZcu0kJHx3kzlbJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3krzvL1P4iHszJTI9Twne3Ks+88rdkKSDc0SpTwrRo=;
 b=XWvj96i3RgVPt96XdZQWe6WExGlk+vFFtT0Y7no+qH7rTiRx6fEflrn2T6Yp2TmTSaMVJzCU/2xiT98WsRAg/dpE6Qsq1/MVYewy6KkLj6oPdTPsFK+lvBZ87d4Kw06azo2/aSGzy0RjgSgr97yv4Q2CAaYTfqQ62sKoofX7Ry/ypWnK26NDTPSppaAxc+VLJdcWDr4DFkRjjTeoljBN2Djlh+Tu4OXmSO2DVc+0wXPxsl7EWnD2COMhcviB6kbt9m7neOPMXXs2py1Pgd8NyWu3O6dK1jybCo8J8gpR5gNQo3KwTFgdP0Y9TqkB08djFtIhSerpAjdvW4WN5YdO0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3krzvL1P4iHszJTI9Twne3Ks+88rdkKSDc0SpTwrRo=;
 b=UNjwCj0Y6+idWHpgecXM5bEn2BZn43tVbM1y8hjyvlyGQfILz6F5rpiXQYuWkwX3FjWTEMpSO81kt0u/nBFuxFXQHKf58pJpi9q5Z/1HEwoKLKbmP+jlrtYI1WaLuG67krl15eN13efzmlveUsmBzQ6v9kQH+X0tXEYGCMi11Bg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8347.namprd04.prod.outlook.com (2603:10b6:303:136::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.15; Tue, 16 Nov
 2021 05:22:06 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:06 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v10 kvmtool 2/8] riscv: Initial skeletal support
Date:   Tue, 16 Nov 2021 10:51:24 +0530
Message-Id: <20211116052130.173679-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116052130.173679-1-anup.patel@wdc.com>
References: <20211116052130.173679-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:22:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 803ed891-3cae-4635-b366-08d9a8c107ff
X-MS-TrafficTypeDiagnostic: CO6PR04MB8347:
X-Microsoft-Antispam-PRVS: <CO6PR04MB834768D50176E49E0527EBD08D999@CO6PR04MB8347.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6kpnxxu3aOaVw8Y1ESYbAZOQIzPgMSyWp9ppht4lKSjLK6hKgzcC63TxXgqSZ+umU4lHbj5n3acLa806USXs5/JSP+dMrWQDcj6oVd5DZLFcGd7C8z9tP6vTDb6vGs7uKJNWmNE0QAEKGDePXzq6876T6++5pWGJLy37N4RG6o4ur+1VreTjsOLclMqIi9u74M3oZJUsvbabRnpxSWCJbRIhpBYqbhXGcDYiEiyFxar2rwJLM/uUwuhogAUdBFKIBeOukzKX6Ec7Kzy0zk+fgUttN6PSk9YNPPi0RQWYL3ahyjoW5dBjYRa3EJKXMBJXyRGBKtFISLBjFbEjgyU6OaDVI6PWIo742Lkeadt/W5/RqL8Mw9ttdTOfA6eXBZ5/iJubhXDpx6AswAHVPj03+6sxF076ZdTQ4GHMoumcz7gInB7BEf2Hk5bOCaH8ViL6UWU4YBB+N4nGPwu8irC/ScYnthU2rz4S8tjoS7uySm36RaNPGpx5Z8EGeQBrSmKPgpYMeE531droiLVEW3HM3cTVVzPD27pWXSG+7pKgkxGQvE+7V6esF/koCrhxRGXYkRMxXTuwax7CEyb/o+GZUwPauP4XTUjZ/WTn5IkxqvCyqhLg5JKFEmzJn31e0XjjUxfCW/T+j7l1rxhGxJi/67KyOGviKg1Kl7v85jFDKLbNfW81ZjSoxBMd+nSFPl62kOrZDpR95C/bfY2BfztPxA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(55016002)(186003)(4326008)(54906003)(956004)(6666004)(1076003)(2616005)(26005)(38350700002)(508600001)(86362001)(38100700002)(82960400001)(36756003)(52116002)(7696005)(8676002)(66556008)(2906002)(8936002)(83380400001)(5660300002)(316002)(66476007)(66946007)(8886007)(30864003)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JL+3Q7j6/hSlXZqm9mRpF9ZWbPDxko36QLtlx8Zcg9h4sucrSnpJUIj1KPXw?=
 =?us-ascii?Q?hNDtk0V7M+cTSalzhvhn7d8ytT8uVn5APNkDRxL8Z+NgjhHbGMWUn8b+BUPS?=
 =?us-ascii?Q?kfM68//2CM7J51gTzjvE4DiOgPlW+QhxmZnRqi+TPXvid6UnmfI66rIBO/QB?=
 =?us-ascii?Q?UXJbsEqlWSONyse5NdqBQXkT1qnwXb7F77+3LD2xEUJhxOgyKpqHXG7aV0Nk?=
 =?us-ascii?Q?S1DdNMw5YHANzfhlO6LVoEwqehMrmM59YLRELCQKEk6PS3NqGBmZrn29IRWR?=
 =?us-ascii?Q?MW3eOWUsJ9hhy646r2gWvjqgv/DhKKNZdoKXXmB8hS8PdO/WtR9Ioe6cI+/8?=
 =?us-ascii?Q?rf6j+16ABjTTRtZQTbyb+OQQVxJJN59ol7ytqfAuT4pOaNAjS3BuSojgFm4Z?=
 =?us-ascii?Q?sfkAFAHYL5UZwojDO5bVFn2uRPY15qO6ph1b9GMQDW1yQwdYzR3SfDNaTKQM?=
 =?us-ascii?Q?4qpNhB2Gp0Qgy/iOZsNm23q9wxaM/RAkR0p56hmI/3lbQvE8T9uieEcGTMl/?=
 =?us-ascii?Q?JThmrXiVC4kH9rjAxK/0RJWchCMFxmm/02Qs75SOBZUOsVAIpE1Cdwjwf5z1?=
 =?us-ascii?Q?Rysh88IsRnpo/liw/Cdt0hn4Y4pXYHbjfbl3mbtEfyyh3pTBxHpPasQcpX63?=
 =?us-ascii?Q?GYR/3cJQxUEwL2oKYXU95aBrfKW3WzlQiAuBXiwBqQv0ECUZup/njnSxUTcG?=
 =?us-ascii?Q?CyGVsL8NNt0ZaF1oVbDUxgrxALUJETjH26PzUGlWp0IpKwBtm39VYrBVupFg?=
 =?us-ascii?Q?JSNR7jOJit4zXBMBeHogAlG/vTA5sPv1KSS40mcwaecyozU1hJCsZ4jOgzrp?=
 =?us-ascii?Q?ExWzP1Y1Am+J7hvaAl0Ar0yyGiIzqhkJo8R9aVWUUbVcb7DYWPlpLu0P02Jr?=
 =?us-ascii?Q?5dibMF1QPU5uboTFuPYF6AdxuE1c0cldDgaWTM6XMA1Joc+VouFFN8OzX25m?=
 =?us-ascii?Q?kfi1n+pyZvFzUVFlSqWpSO4sHoHxqMT+w8c/2OqAACjSBQzYCfGS3l8Ft3IZ?=
 =?us-ascii?Q?wZS3HuY1ZBzz9w1gAQXgyo/VvFNBm/QHnF5JFxP3SFaIm3xEEgVYH/B0uCMw?=
 =?us-ascii?Q?8aIrQJCVCjHyyLyICxcDNEkSlY2RpZF5L6F+rqz+IkokBUBJGzCmYasR0MKq?=
 =?us-ascii?Q?u83g3Pn5qfa7cN9I41h4NFWR03bs8OF2k/0WY2PinCxTivqLZGIGUcc1g09l?=
 =?us-ascii?Q?Jc16gU3uLgX4zAMZgLkfkwiw8avR9bC3bNJiQc+ZZWR4gyqI4+6AT0XoNSNU?=
 =?us-ascii?Q?4z0VAfgXkegGi82PvAmxBjsE7ux1szjizTkHHH6cAVwX20ZSEybYmjvcc2RL?=
 =?us-ascii?Q?CgTxheHdcFXPKVCippDf0y3yexMByK00y9GgBv5CY6KSxcg9q36yMgOtwmwV?=
 =?us-ascii?Q?tg9HjBAx40uBjfuLX+TLJAcZ1Pb3zn8wCCkjDVIgyFE7+V3e36BQEVs33iBk?=
 =?us-ascii?Q?a7VGeI+rfqc6cyyd2R/XTQw29AETOMm91tkfoKVsD7CQMLc5fu588hMi8yzn?=
 =?us-ascii?Q?SaOSyClgX89SkJIEVRI4rvaGtIMFV9pEcECBRRfXS8Ndle2pe9nKVRfpw15s?=
 =?us-ascii?Q?kMAoyO6kSS6m6GE/Us4sOw5Ib4WIx7JQ/bW3qFu9dbTz4NeaotND0VBDFrJx?=
 =?us-ascii?Q?CUyzcBEbX/utaFPdIX8aW8I=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 803ed891-3cae-4635-b366-08d9a8c107ff
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:06.7073
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lGwt9IyPkifVnawEFuO50Ibn7Xb3Kjmum3xPCydKqxPChuHyJgiiu4GhacJOPDlcwIOu7gFqwJybWWrE8s+ORg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8347
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
 riscv/include/kvm/kvm-arch.h        |  68 +++++++++++++++
 riscv/include/kvm/kvm-config-arch.h |   9 ++
 riscv/include/kvm/kvm-cpu-arch.h    |  47 ++++++++++
 riscv/ioport.c                      |   7 ++
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
index 0000000..01d88ed
--- /dev/null
+++ b/riscv/include/kvm/kvm-arch.h
@@ -0,0 +1,68 @@
+#ifndef KVM__KVM_ARCH_H
+#define KVM__KVM_ARCH_H
+
+#include <stdbool.h>
+#include <linux/const.h>
+#include <linux/sizes.h>
+#include <linux/types.h>
+
+#define MAX_PAGE_SIZE		SZ_4K
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

