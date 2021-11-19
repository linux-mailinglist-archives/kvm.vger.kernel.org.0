Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2A9456F00
	for <lists+kvm@lfdr.de>; Fri, 19 Nov 2021 13:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235343AbhKSMs5 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Nov 2021 07:48:57 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59245 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235316AbhKSMsy (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Nov 2021 07:48:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637325953; x=1668861953;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=6FrTStNMxTRY47/1Ij2gs/5E/CKxoyuoM0DWklz+UDs=;
  b=IJBZZRoCBCOJ7qpkF4gIOTYf/Ux/NzS8mqsbwIvvksmSILYm8m2/0hsc
   KSvCg93EEdidQZb4raMkvr8q8PDfpq1349kxcYuSX04OjvSvUyAg+xOKs
   S0tfQnRBJ/Bah8Q1i4NLAxME7vZKEIz8TouQou8FlgIBJQdkPlYV8oruY
   90VRUuox7mZZem0amqAX1XfrJm+TZXeZfdxzurNY+m/R/FmYGDqsdqO6a
   J5IFIuyiKUyC18N0awp3sjVarc3yskhGLMC7Z8h2mRuN2RzIPxH/gb5Es
   h1AhAu/EmswiLwAHS0lmA+2BMYaCJt+BYXzLURgEamPZ0kxLg1BMxCBbD
   A==;
X-IronPort-AV: E=Sophos;i="5.87,247,1631548800"; 
   d="scan'208";a="290021294"
Received: from mail-dm6nam08lp2049.outbound.protection.outlook.com (HELO NAM04-DM6-obe.outbound.protection.outlook.com) ([104.47.73.49])
  by ob1.hgst.iphmx.com with ESMTP; 19 Nov 2021 20:45:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Epmrzd/KCC7mePNmOObVH6+IqdJi/8pyeXtDtpZISUF40pt1TGjQ13B5FPilvA4G25Bt8Cw89IAfD9bvPUUvT6uyewW76GfnjxfNep+Zs/+gFMPOAwcjabffag5f/fNLnZY4op2WKkEKgi66ht1Yj/4STZm/pXu1+pJCxIxUcfwwkBEcV74iP/COUPxyRsl1NAFAtcYL0L+SQ9XoEmU6PdMwqnRCqiis4bvIgfFo1WWXgeshStVnTKfJ+z9eqeU9iB3CZjx5m24ASej1QHtVvKLApyFatHEfbYuNaZgWeXl1d/9ANzQsQTZEDGq9pqRyugBmCSAgysg6LYGDlgVPNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3krzvL1P4iHszJTI9Twne3Ks+88rdkKSDc0SpTwrRo=;
 b=BczqcM3C+TNBa82t/B1CMk/yyGeU4fdh1dt+x8i7k0vs9/L+nGjIAjXVmFovwzMjukWZwrCIKOwPnuhePyEVeVP/8BRfphOggYlHptz8FIi0m/1tTjUhFQrbV2vd7jCFbNG85uXvkp2nQc/FHPmfPDsfTqkNXNUI0fQ2Qi8DieuSHU8jFPoCZInMF71SvsIG+1rGxP7xR7zsugpm79bk2stHb7RHpNyKBgKJU9KHTj2FtpTTie3Ao8cg6UEZIeUGp8MtsEB5khxfm0bv8Mf8iFvBNcWYIqwy2o9IIIO3/L2027V2hmFjctgYd3pJKOZNl+RTkvCvPV9BtMCPFPEJTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3krzvL1P4iHszJTI9Twne3Ks+88rdkKSDc0SpTwrRo=;
 b=Umj3gMUICwVD37ndB8eO1hLuTDXnoE6soLsB5nCQx6eFb+HGSkv3PyoXXKIlEmsHTviCsadBcgW4pzr/+k8CBKOs8GjooLnEA/VJTqf62Mr54VtVGxD4RHkuS6XTQJYWJkwBGb/i5+ZsJ5lusmuiLQQF8YEKDJRN0Bky2gsnFuk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB8377.namprd04.prod.outlook.com (2603:10b6:303:140::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.26; Fri, 19 Nov
 2021 12:45:50 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%8]) with mapi id 15.20.4713.022; Fri, 19 Nov 2021
 12:45:50 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v11 kvmtool 2/8] riscv: Initial skeletal support
Date:   Fri, 19 Nov 2021 18:15:09 +0530
Message-Id: <20211119124515.89439-3-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211119124515.89439-1-anup.patel@wdc.com>
References: <20211119124515.89439-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25)
 To CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.171.140.195) by MA1PR01CA0085.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21 via Frontend Transport; Fri, 19 Nov 2021 12:45:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56617952-81c2-4bb0-7e8d-08d9ab5a8449
X-MS-TrafficTypeDiagnostic: CO6PR04MB8377:
X-Microsoft-Antispam-PRVS: <CO6PR04MB83775A48C197C23F8EF7415F8D9C9@CO6PR04MB8377.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:416;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KmeSSMp2cOPFS9fOvha16TYIDCvj+eHV/9mx3IV4wrGvD8/wlDshWNRlc5YujYyraXu8h6YIkAt2osqZE8rTR81TNANcBEx3X4hmsjdGBLcs28i+ICJeF8+qq0TmVj0isagCC6Da+oBrLY1aKYo0/Wh0XuV5BuhrCuzqR2u2faixTvlE+x6f5DdPMFg/xbi2ITTyUF+Beotg6ZQAhJTjtE2byLvy/zWBOrL+SFWvRszNJvtL0TyvAO4RE6THFiGMOl7eWPNnNx5cDQkZJ2euBI/ANlGDKtKda0SVUb0fiRxl0igtU2vi7pXyWB5XWdaZlEzhutlWB/SSfvNDd35r2S+rZ+78oCFX8cK7BtgIzqhOdggcsJDnIJzA1z5oxPEWgPR4k50j19LZ4k2PlPfeW6J+1Nzr9AFqE0JT7zY1EeHulLgMvfy8XdfgXDlU/wCkal8LdBI1qyBzGr9TXHaFcTiWcFtIHfgRe1XZrnqsNX2ZWLv8CrRCkk+d0uQuxivCSaxuBzJFVv1J7z2tcmBgaa17iPdexv4R4Tgo4zm0wThUq+5Q1D8EDPcfIgntALWHCrXK3jSqW6XK3le4EWQr6Jo8mq5bdIOBc30zyud41mbLesgk7YJ/PpvU14ZcsIHhsUJlIkrVMq9CTU5VNRLjXoa8E4TD2xG7gYa1+9EuW4wCGY8GFoswhrArpdeemRVnzl8uMHsKcbJcOHK8eEiNUQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(6666004)(1076003)(54906003)(66946007)(508600001)(8676002)(55016002)(186003)(82960400001)(2616005)(956004)(7696005)(36756003)(2906002)(4326008)(5660300002)(26005)(30864003)(316002)(66476007)(66556008)(8886007)(83380400001)(38350700002)(52116002)(44832011)(8936002)(38100700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QnjRPM2QPHZAloSuQPEHHzdTQMVJDrRhifKivuzsOY7ITrJST+Jhu4qaGQmV?=
 =?us-ascii?Q?tr1xGpYIIz25Cai1cCltzbkl7KFHaQS13fBOAo7yfvIqZKphRjYgx+tDudvN?=
 =?us-ascii?Q?zaw2izTSsFrt/w6Ahr/33ifNQGfHDyqTJvTzJBbhV/zPWW6Dewz+ZHMGntVP?=
 =?us-ascii?Q?AcfGPQVeT163BrCRvPrPlSRtwb7WAteDtHrpd420DfVi2CddlF5lAAypAKtJ?=
 =?us-ascii?Q?9JbLGextrocvSJKks+Dot7bQd+VtOOazhSGkLLIXECzuuw22E8UcqBrNFjFl?=
 =?us-ascii?Q?BKUfY+MI2iccOw+XrtSQ2IqTpum1m2KRfdBiXwYvm9A/dFxOALcKPA20MmM1?=
 =?us-ascii?Q?0XWX6MECmg7mEXZCMDZyVncCW2Pi5uDO3LfG6fO5O2YVRe+5kO8W0b2ETvZY?=
 =?us-ascii?Q?cRyAWKRDNURKbbd3LXv/43NL8dE5LKiLDu4O65XkEoVzfTE6upg1cdX1lYyk?=
 =?us-ascii?Q?fDeE3SJqF9aCmmW77q37ihkufnfPG+RvbgfSxG565kfVFy3dIBBWDX8UHN1t?=
 =?us-ascii?Q?Ul+5GrC1FtDCAv8bt8d6kMD78K2W9fglCYycWpa6CAeqvdZvscj1cdLbx26M?=
 =?us-ascii?Q?+if3+bTKVXsTr5X9GDSHu64GdiAGTPloZjFWTGVbcumkYeGwYbOYpuHdq2xe?=
 =?us-ascii?Q?wq1j1wbvJsh5U2a21+7co+MpVZMdxqcAErZhZiln+H433hcA0+SVY+WS5VDc?=
 =?us-ascii?Q?Eg4y8NDf5Bbx4GuYSSFu5C9jduSHqvyHkihnYxvatGdYUKgtu8dMGZK6XEPI?=
 =?us-ascii?Q?hMTgpH28H1wby69iFKoyj5eI45/NDJm0X7wuqLScriuVcP0fBerLgzu9itHj?=
 =?us-ascii?Q?61RobmJsjUqaDw273tZ34oS6wYE3IpWFlYdShfZHoEB6aqxXDaSfPinaNG++?=
 =?us-ascii?Q?C0wJpFWpYPdMa8bbI/hosn5JoJ0auguLrPhO0uqvj52s38nZAeOZ8cdF48he?=
 =?us-ascii?Q?J4X8I+UXXEvbMLfjqwPsrXfZ2neUktj/Naq0nGciHylA3CsSVw5aTX8R77vy?=
 =?us-ascii?Q?i9Pat/sPh08EFsT/3Scgxz0rh8JHAF52cV0dEUbV56YjC2yx3fveCEtkp2JH?=
 =?us-ascii?Q?+3hFwYDOtFsXCxobIIPE1rnHLehHqbZ7Eq38BeL6kpHXb34HBBpzKwQrz26Q?=
 =?us-ascii?Q?IRwK6/DZxmmJhSkOE3KQUfNEuiSZ5qs+stGYC6HV9GRoANPlQwg9ongPf0be?=
 =?us-ascii?Q?Tvz/O/prc3MU8pm11TUCm6TR3lBSBfc6VLx5iYCCw0TE9hCf5d5shmmNulAq?=
 =?us-ascii?Q?15Qf8UTLRFhbhNTDx9LKDKQ9ZwyIQibYsFHfVvreQrmr+o3wfDQFL+Fm+nCq?=
 =?us-ascii?Q?GZ8/gGsDvvhTCeE0JGlZoFz+Uizb9Oyi+H66IurwCUv5RJcLOM3QvCVDCqB0?=
 =?us-ascii?Q?LUBw6xZnNh/NWxK7BpEgD7wSNyZyzzREhnuC9LQgSr2OZzqDdMyvk/DLrbhm?=
 =?us-ascii?Q?QjZJzx/P92gJ/N7sUMvlwl3fJvaC9o9WLGEZNncwh5ZA3zY9AZRCgupkbFL2?=
 =?us-ascii?Q?5vIP+hPGjq3TGlRC4UArxUHYvrHWE/2un5+VnXJ5+uxG4kgEtcsKunLCWlmM?=
 =?us-ascii?Q?QMY0imBS2jhhVN/Uol203+PaDBcXNpENCpO2tnNDOZqZVjxvNpkdovYSJibU?=
 =?us-ascii?Q?4cDUjsFe042qVJvK2JxihhY=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56617952-81c2-4bb0-7e8d-08d9ab5a8449
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Nov 2021 12:45:50.6004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcgCPgB8SE4EE28xkjmAd78vSx6+9MFqVaKj1UkSe2jhQ5yN62nhc/gsJ0DLDT2jMFGCDBxEFeQuZJjNX5xMOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB8377
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

