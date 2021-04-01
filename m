Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF20351B5A
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237050AbhDASHw (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:07:52 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:24325 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234807AbhDASDw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 14:03:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617300232; x=1648836232;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2WQyPGrOc0YLKRfuBS1LSmGdRVjD2/yNF1oPBOu8nV4=;
  b=cQTvTfdooD1r6fI6j+UOTSI2ldMK56XhRCV6UVMhFBECMYGlmh43DPWD
   gnHEhKODz3QR3a6cPVC4PU74alOGUxwJzTLM0L68Lowe+FfzcLFYixdj6
   ZwhlPgkhml15BuJu4OfjbA/FWdRrAu8y+UDgwYp6gDn9vWTIbLFYrBnxb
   /vuJ6ZJZ+aydHP205eR/oF+MReYCUy+d4NgXnZjMKnE3ji6gWiYndLWdz
   Aj10c8OmvmcxW+IOohVc7E41dsVIHVbJG/BCUwPRCmoXgfyId9xai9N6W
   BTa5QS+H8wXQU7BNnjfFGSyAl1Nc5Zh66RDOGH7GWFewRoV6Gmuum32Go
   Q==;
IronPort-SDR: qhNumzhlZ6zoYNETn1G40FcbI5f42Gv4+o2ZJYgbeL6heFf1tsEZ0swjmFXTEnlGmjv9B+FBCF
 EU9JjHwF4IZ4BkT2jDFsAEunhgZJeqIHAMKij4mHwqJElBVbElHZDNGO3ziuzSDZHQj1uXTXB7
 LcNy+ONcEFwDeP8wH8UUvPzpXmO5C62cdMytyAhGfurAcOPs9usK+UvRfLyrJ/GB74LPIYGhmw
 CXbcJoK6p3PdxKS1QgalSxuGAZBM0dotLw1aclfq+mI0FQuCJEJ3GhSZhqSU9kJMrjXxcLbLuO
 Dho=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="168041936"
Received: from mail-bn8nam11lp2176.outbound.protection.outlook.com (HELO NAM11-BN8-obe.outbound.protection.outlook.com) ([104.47.58.176])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:42:28 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Caam+ghZOAIvnxD3ckjL+exmY9yzv3L9NyqNgmGQsZMD1IL+KRIFvrQipoRtbicI6Q5lqOg7IksVtF+VKMQVmAqhbhAQP8BimTUOz5U6DskIVTENXp4EdtyBG6HOqfnqxDDnVHbsJ1V5SW+QLqv645rCfSQ3Zswh1gDLnZ/ZlUN0YpKSFjdZydYbGZaul1xzqBmWhf4ZtblNJWyI+fp1B13IDPNmfIOHnzbFt7UHll2I46VZrKOIwTU8s0Wdu8i/7JbLcIiqAjxdHl3r95ngF6hlUMTqiHdKXZhhz0V0OQ65FElxczAAbl1PwSaFPC1LF76ArKI6G1/LkJIAP3SAlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3s1/7pJ0sVgc26M1jvbwxHoaoopIPAcng8ZlZYWYrVc=;
 b=AIfunJLrOz2Awol30zhFHNZcvbKyYbxkHMRIFmDwJuU1qPHl+Gry0hyECvMmzIA3wfOYduf/TEqXZO1Hk4UxXn40EEzTmneI3au6/H8QmexBm72zv88RKSW5klFTkLj5l6DsrbFmcytjTjD44+WeH1USQQOpXF1Jdz46Lkem8c5B6itysCUyov6EYr3XXfKEATKGsCoXmIKmMGyFWN6fewOdpV+bkeVVWsIZV/Y8yaptLzwIEGuH3MB2Emn9zmY2eNI9XtFXBTt4ZhWe37Hpq7KscwQJGpylQLHousR5R1sp0zLEBrCj5onKWf31AzaLMG8b8FwHV9IElx9qhQgUxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3s1/7pJ0sVgc26M1jvbwxHoaoopIPAcng8ZlZYWYrVc=;
 b=ivqi6G4uO06Z6v0/V3gbV2ph+H3HJoGHrkssuXSPP7fq7l1aMxeG2zg7Bib5M97EDAMlVgIzaYeb8qRPa4KUtE+4iEngkt2BBbp17e24cbWXQTP1se3M5uJDRKPDrQ3hroGUrkHgYCHb6L46IXp4ZMUNygALG0flIRyXSKAQVzc=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB6493.namprd04.prod.outlook.com (2603:10b6:5:1bf::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Thu, 1 Apr
 2021 13:42:27 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:42:26 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v7 5/8] riscv: Add PLIC device emulation
Date:   Thu,  1 Apr 2021 19:10:53 +0530
Message-Id: <20210401134056.384038-6-anup.patel@wdc.com>
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
Received: from wdc.com (122.179.112.210) by MAXPR0101CA0019.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Thu, 1 Apr 2021 13:42:18 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6f69d7d0-7a3e-45a0-806d-08d8f513fccb
X-MS-TrafficTypeDiagnostic: DM6PR04MB6493:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB649371AD43EE2C822C45701B8D7B9@DM6PR04MB6493.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7nyAtlEvU7U1qqgGb1ElONZQ+9VMJTFLZTiIubN6s/9U9+Hsmu7PvX2QfF3ztlQhYpNBk6uSV7DmEQCifEoPFUFqqXhjFpt1bAQlyQY7pGaG/k/3qa0UPA5iYSXRck2wjez1D9n/LC2NPmc0sPUbQQO5yQMR0bN81mBfvSKzqe00TQaQDpDv7AWoAqrPbVbknsEcPkOoXM1JETz5BolvdAO8bLeAK8Xexu3g10gXknMLnOaGeqhTZnTwDO28BfoPzqZJsiV2qsEtHhmVSpLSmwbxlDgcK7/OZ6QR/moo8f/6qEL1hgbBSK5xien9p7CBlkXfjfWNPsJSJWdW6IvyzVWmdhZylC7x7t0ZefnyImKiRdwcIBkrMYg3nmXleIiZj2PBEEPBtfBGuhfVJFs+t5g1J1kGFCotL3EBkFv91v6U+rlfrXBo78EVZaTkSBSkFkcVVm91tvV1DgR+fP7BgGK/qaculPip3/1cr4RwSYP2zqgWBQKZIBGGFHPZlihPZvZFOr9LkUWC4IcZLqCGluwTrHQnEmfYfxyYaBmqZCjAmP7e3qoRSI/lLIBWH6p0bdhlxNERelglReshgIA7zeQtoQTYHWjuMB6kQwd2SCpm8Qe5RT6X5vEYusuwarBnafEtbSZjnbZlFbs2nZ2XMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(478600001)(26005)(66476007)(186003)(16526019)(30864003)(8886007)(6916009)(66556008)(8936002)(316002)(66946007)(8676002)(5660300002)(38100700001)(52116002)(7696005)(44832011)(956004)(83380400001)(2906002)(6666004)(54906003)(86362001)(55016002)(2616005)(4326008)(1076003)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Y9Hv0CcqBRBxRluBEuGK3ObPUBAnGC+t3I7gj9PUrgrAUJqX5xI0y5mfolgz?=
 =?us-ascii?Q?RGTDgQ+/ByLWibhA5OY7sU1R8W1gWFJtpToPFraWDPjn0J29u5cPz8HwPGVr?=
 =?us-ascii?Q?BxtbkUc/iC1+7TlL80+RxpudBsyE+TOPhR13y4TL1Ke8svgZWTTMxC8JuyI+?=
 =?us-ascii?Q?LsKlpy5alhG+oZZ+ZRwwBOV/8+WfyjXBZTJSGya0UKdS2lDPCSqK2Uz2Hs00?=
 =?us-ascii?Q?BBNHI7iL4DCqckPuIJ3L8EFhGVLqRcoGOfBlDYyU8tki0CoZRNlRU4Qe2D1T?=
 =?us-ascii?Q?vMXcVkP2s2gXtTlZxKyQovDI5dzVCUOl6Ns+BLGJ3r7tRYw7CXOYcxnTJsVD?=
 =?us-ascii?Q?jvr/pRNpAgjUkNNHkRv0gZiRJRncSjGuCKeSfGfFgOS9KtKA7BVFTP74NpHP?=
 =?us-ascii?Q?7VNu4b+Zz94n0iBADFLSNSqqqmtNIENwwapS6n+YZrJHimIMXj57x/McGiWt?=
 =?us-ascii?Q?IgkMJB40FPu/0UFWQirasVGrFxhaZvaXXwTpaRxT89E4nZUshU9RypGH+x2+?=
 =?us-ascii?Q?dkafJ8hqVTUEcyhVivXspxc5qW14phzAkx8xW37AMXNyR8kZH1KpwPTKAhyo?=
 =?us-ascii?Q?JKgQl00NDVQsN0SSwDW0pZEgXK//6qqzxpZlxgZXt5nh3rwcvppZdf5E5bt2?=
 =?us-ascii?Q?qsx0K58/Huc76xDjoKRqFhc0ei/hPXmDztBBRmTqdcFcbOe2kJk3GajraKub?=
 =?us-ascii?Q?5oWE8yWMHi3CcYstCkbvetrDIb+b/iZl5GMh1n1ZUUf4cHFJIZMe7o3rHO+m?=
 =?us-ascii?Q?g+bpuMye0Pm9yqeT45Wc+ByXEAiN1m+FTta/RwFniLG4T/u7gfCZpeS0rre3?=
 =?us-ascii?Q?0phwFvB5hTHkv6g2zCisyS81GrYS+MFP7HWzqYGGTlNvYk+HegqSSa8C3pca?=
 =?us-ascii?Q?8EIza35pypa5iTP7iPrbOgVM1th5MdOWCaQfzkKL+qlS5CVw07wx3oOwK6gS?=
 =?us-ascii?Q?tIFlnCec6pRTpKydxuKJhvT6lhYkaIrOOCJjET1A9zpHtzprpklWhaRk2jnJ?=
 =?us-ascii?Q?xYi2N8CHeN5sTHUnI0ij6qPAp0QHJjkXNwO30Bs6eVoHH3WbLu5PSojjpSIh?=
 =?us-ascii?Q?oXqvubKSxLDOanxgxknexGwAQRR8K8Za/T69y/xFnjyqAxfXQa4y4Zzblx4M?=
 =?us-ascii?Q?ANja7suVCKVnne1tS1mEF8uR2JFUBVUoPOyVtjsB+iPLOfOHJ9CeqfSsI7TZ?=
 =?us-ascii?Q?3HBG/NhZfrQ0YQjb87r7riZz6mhLgZa30K25O8WJSWVxSpPNLXstxFE1c0h1?=
 =?us-ascii?Q?aJBRj3+DPukz/GHrUV7L5c3vUWe3rT2d9bPNIZ18D/Z3FzpP9ILzb4aPZ7K9?=
 =?us-ascii?Q?tgn9Dk/4o31TA1+dU0iQWdXw?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f69d7d0-7a3e-45a0-806d-08d8f513fccb
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:42:26.8693
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rVPvgOiHiEFfc9H7tbWn9Epu2tYbh2TT9W69k+w941MaqWY2j7608UjS5AEDQ2SCaIUYMG79I7KjzIxMfnU/UQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB6493
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PLIC (platform level interrupt controller) manages peripheral
interrupts in RISC-V world. The per-CPU interrupts are managed
using CPU CSRs hence virtualized in-kernel by KVM RISC-V.

This patch adds PLIC device emulation for KVMTOOL RISC-V.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Makefile                     |   1 +
 riscv/include/kvm/kvm-arch.h |   2 +
 riscv/irq.c                  |   4 +-
 riscv/plic.c                 | 513 +++++++++++++++++++++++++++++++++++
 4 files changed, 518 insertions(+), 2 deletions(-)
 create mode 100644 riscv/plic.c

diff --git a/Makefile b/Makefile
index 817f45c..eacf766 100644
--- a/Makefile
+++ b/Makefile
@@ -203,6 +203,7 @@ ifeq ($(ARCH),riscv)
 	OBJS		+= riscv/irq.o
 	OBJS		+= riscv/kvm.o
 	OBJS		+= riscv/kvm-cpu.o
+	OBJS		+= riscv/plic.o
 	ifeq ($(RISCV_XLEN),32)
 		CFLAGS	+= -mabi=ilp32d -march=rv32gc
 	endif
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index 26816f4..bb6d99d 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -76,4 +76,6 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
 
 enum irq_type;
 
+void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/irq.c b/riscv/irq.c
index 8e605ef..78a582d 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -4,10 +4,10 @@
 
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
-	/* TODO: */
+	plic__irq_trig(kvm, irq, level, false);
 }
 
 void kvm__irq_trigger(struct kvm *kvm, int irq)
 {
-	/* TODO: */
+	plic__irq_trig(kvm, irq, 1, true);
 }
diff --git a/riscv/plic.c b/riscv/plic.c
new file mode 100644
index 0000000..1faa1d5
--- /dev/null
+++ b/riscv/plic.c
@@ -0,0 +1,513 @@
+
+#include "kvm/devices.h"
+#include "kvm/ioeventfd.h"
+#include "kvm/ioport.h"
+#include "kvm/kvm.h"
+#include "kvm/kvm-cpu.h"
+#include "kvm/irq.h"
+#include "kvm/mutex.h"
+
+#include <linux/byteorder.h>
+#include <linux/kernel.h>
+#include <linux/kvm.h>
+#include <linux/sizes.h>
+
+/*
+ * From the RISC-V Privlidged Spec v1.10:
+ *
+ * Global interrupt sources are assigned small unsigned integer identifiers,
+ * beginning at the value 1.  An interrupt ID of 0 is reserved to mean no
+ * interrupt.  Interrupt identifiers are also used to break ties when two or
+ * more interrupt sources have the same assigned priority. Smaller values of
+ * interrupt ID take precedence over larger values of interrupt ID.
+ *
+ * While the RISC-V supervisor spec doesn't define the maximum number of
+ * devices supported by the PLIC, the largest number supported by devices
+ * marked as 'riscv,plic0' (which is the only device type this driver supports,
+ * and is the only extant PLIC as of now) is 1024.  As mentioned above, device
+ * 0 is defined to be non-existant so this device really only supports 1023
+ * devices.
+ */
+
+#define MAX_DEVICES	1024
+#define MAX_CONTEXTS	15872
+
+/*
+ * The PLIC consists of memory-mapped control registers, with a memory map as
+ * follows:
+ *
+ * base + 0x000000: Reserved (interrupt source 0 does not exist)
+ * base + 0x000004: Interrupt source 1 priority
+ * base + 0x000008: Interrupt source 2 priority
+ * ...
+ * base + 0x000FFC: Interrupt source 1023 priority
+ * base + 0x001000: Pending 0
+ * base + 0x001FFF: Pending
+ * base + 0x002000: Enable bits for sources 0-31 on context 0
+ * base + 0x002004: Enable bits for sources 32-63 on context 0
+ * ...
+ * base + 0x0020FC: Enable bits for sources 992-1023 on context 0
+ * base + 0x002080: Enable bits for sources 0-31 on context 1
+ * ...
+ * base + 0x002100: Enable bits for sources 0-31 on context 2
+ * ...
+ * base + 0x1F1F80: Enable bits for sources 992-1023 on context 15871
+ * base + 0x1F1F84: Reserved
+ * ...		    (higher context IDs would fit here, but wouldn't fit
+ *		     inside the per-context priority vector)
+ * base + 0x1FFFFC: Reserved
+ * base + 0x200000: Priority threshold for context 0
+ * base + 0x200004: Claim/complete for context 0
+ * base + 0x200008: Reserved
+ * ...
+ * base + 0x200FFC: Reserved
+ * base + 0x201000: Priority threshold for context 1
+ * base + 0x201004: Claim/complete for context 1
+ * ...
+ * base + 0xFFE000: Priority threshold for context 15871
+ * base + 0xFFE004: Claim/complete for context 15871
+ * base + 0xFFE008: Reserved
+ * ...
+ * base + 0xFFFFFC: Reserved
+ */
+
+/* Each interrupt source has a priority register associated with it. */
+#define PRIORITY_BASE		0
+#define PRIORITY_PER_ID		4
+
+/*
+ * Each hart context has a vector of interupt enable bits associated with it.
+ * There's one bit for each interrupt source.
+ */
+#define ENABLE_BASE		0x2000
+#define ENABLE_PER_HART		0x80
+
+/*
+ * Each hart context has a set of control registers associated with it.  Right
+ * now there's only two: a source priority threshold over which the hart will
+ * take an interrupt, and a register to claim interrupts.
+ */
+#define CONTEXT_BASE		0x200000
+#define CONTEXT_PER_HART	0x1000
+#define CONTEXT_THRESHOLD	0
+#define CONTEXT_CLAIM		4
+
+#define REG_SIZE		0x1000000
+
+struct plic_state;
+
+struct plic_context {
+	/* State to which this belongs */
+	struct plic_state *s;
+
+	/* Static Configuration */
+	u32 num;
+	struct kvm_cpu *vcpu;
+
+	/* Local IRQ state */
+	struct mutex irq_lock;
+	u8 irq_priority_threshold;
+	u32 irq_enable[MAX_DEVICES/32];
+	u32 irq_pending[MAX_DEVICES/32];
+	u8 irq_pending_priority[MAX_DEVICES];
+	u32 irq_claimed[MAX_DEVICES/32];
+	u32 irq_autoclear[MAX_DEVICES/32];
+};
+
+struct plic_state {
+	bool ready;
+	struct kvm *kvm;
+	struct device_header dev_hdr;
+
+	/* Static Configuration */
+	u32 num_irq;
+	u32 num_irq_word;
+	u32 max_prio;
+
+	/* Context Array */
+	u32 num_context;
+	struct plic_context *contexts;
+
+	/* Global IRQ state */
+	struct mutex irq_lock;
+	u8 irq_priority[MAX_DEVICES];
+	u32 irq_level[MAX_DEVICES/32];
+};
+
+static struct plic_state plic;
+
+/* Note: Must be called with c->irq_lock held */
+static u32 __plic_context_best_pending_irq(struct plic_state *s,
+					   struct plic_context *c)
+{
+	u8 best_irq_prio = 0;
+	u32 i, j, irq, best_irq = 0;
+
+	for (i = 0; i < s->num_irq_word; i++) {
+		if (!c->irq_pending[i])
+			continue;
+
+		for (j = 0; j < 32; j++) {
+			irq = i * 32 + j;
+			if ((s->num_irq <= irq) ||
+			    !(c->irq_pending[i] & (1 << j)) ||
+			    (c->irq_claimed[i] & (1 << j)))
+				continue;
+
+			if (!best_irq ||
+			    (best_irq_prio < c->irq_pending_priority[irq])) {
+				best_irq = irq;
+				best_irq_prio = c->irq_pending_priority[irq];
+			}
+		}
+	}
+
+	return best_irq;
+}
+
+/* Note: Must be called with c->irq_lock held */
+static void __plic_context_irq_update(struct plic_state *s,
+				      struct plic_context *c)
+{
+	u32 best_irq = __plic_context_best_pending_irq(s, c);
+	u32 virq = (best_irq) ? KVM_INTERRUPT_SET : KVM_INTERRUPT_UNSET;
+
+	if (ioctl(c->vcpu->vcpu_fd, KVM_INTERRUPT, &virq) < 0)
+		pr_warning("KVM_INTERRUPT failed");
+}
+
+/* Note: Must be called with c->irq_lock held */
+static u32 __plic_context_irq_claim(struct plic_state *s,
+				    struct plic_context *c)
+{
+	u32 virq = KVM_INTERRUPT_UNSET;
+	u32 best_irq = __plic_context_best_pending_irq(s, c);
+	u32 best_irq_word = best_irq / 32;
+	u32 best_irq_mask = (1 << (best_irq % 32));
+
+	if (ioctl(c->vcpu->vcpu_fd, KVM_INTERRUPT, &virq) < 0)
+		pr_warning("KVM_INTERRUPT failed");
+
+	if (best_irq) {
+		if (c->irq_autoclear[best_irq_word] & best_irq_mask) {
+			c->irq_pending[best_irq_word] &= ~best_irq_mask;
+			c->irq_pending_priority[best_irq] = 0;
+			c->irq_claimed[best_irq_word] &= ~best_irq_mask;
+			c->irq_autoclear[best_irq_word] &= ~best_irq_mask;
+		} else
+			c->irq_claimed[best_irq_word] |= best_irq_mask;
+	}
+
+	__plic_context_irq_update(s, c);
+
+	return best_irq;
+}
+
+void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge)
+{
+	bool irq_marked = false;
+	u8 i, irq_prio, irq_word;
+	u32 irq_mask;
+	struct plic_context *c = NULL;
+	struct plic_state *s = &plic;
+
+	if (!s->ready)
+		return;
+
+	if (irq <= 0 || s->num_irq <= (u32)irq)
+		goto done;
+
+	mutex_lock(&s->irq_lock);
+
+	irq_prio = s->irq_priority[irq];
+	irq_word = irq / 32;
+	irq_mask = 1 << (irq % 32);
+
+	if (level)
+		s->irq_level[irq_word] |= irq_mask;
+	else
+		s->irq_level[irq_word] &= ~irq_mask;
+
+	/*
+	 * Note: PLIC interrupts are level-triggered. As of now,
+	 * there is no notion of edge-triggered interrupts. To
+	 * handle this we auto-clear edge-triggered interrupts
+	 * when PLIC context CLAIM register is read.
+	 */
+	for (i = 0; i < s->num_context; i++) {
+		c = &s->contexts[i];
+
+		mutex_lock(&c->irq_lock);
+		if (c->irq_enable[irq_word] & irq_mask) {
+			if (level) {
+				c->irq_pending[irq_word] |= irq_mask;
+				c->irq_pending_priority[irq] = irq_prio;
+				if (edge)
+					c->irq_autoclear[irq_word] |= irq_mask;
+			} else {
+				c->irq_pending[irq_word] &= ~irq_mask;
+				c->irq_pending_priority[irq] = 0;
+				c->irq_claimed[irq_word] &= ~irq_mask;
+				c->irq_autoclear[irq_word] &= ~irq_mask;
+			}
+			__plic_context_irq_update(s, c);
+			irq_marked = true;
+		}
+		mutex_unlock(&c->irq_lock);
+
+		if (irq_marked)
+			break;
+	}
+
+done:
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__priority_read(struct plic_state *s,
+				u64 offset, void *data)
+{
+	u32 irq = (offset >> 2);
+
+	if (irq == 0 || irq >= s->num_irq)
+		return;
+
+	mutex_lock(&s->irq_lock);
+	ioport__write32(data, s->irq_priority[irq]);
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__priority_write(struct plic_state *s,
+				 u64 offset, void *data)
+{
+	u32 val, irq = (offset >> 2);
+
+	if (irq == 0 || irq >= s->num_irq)
+		return;
+
+	mutex_lock(&s->irq_lock);
+	val = ioport__read32(data);
+	val &= ((1 << PRIORITY_PER_ID) - 1);
+	s->irq_priority[irq] = val;
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__context_enable_read(struct plic_state *s,
+				      struct plic_context *c,
+				      u64 offset, void *data)
+{
+	u32 irq_word = offset >> 2;
+
+	if (s->num_irq_word < irq_word)
+		return;
+
+	mutex_lock(&c->irq_lock);
+	ioport__write32(data, c->irq_enable[irq_word]);
+	mutex_unlock(&c->irq_lock);
+}
+
+static void plic__context_enable_write(struct plic_state *s,
+				       struct plic_context *c,
+				       u64 offset, void *data)
+{
+	u8 irq_prio;
+	u32 i, irq, irq_mask;
+	u32 irq_word = offset >> 2;
+	u32 old_val, new_val, xor_val;
+
+	if (s->num_irq_word < irq_word)
+		return;
+
+	mutex_lock(&s->irq_lock);
+
+	mutex_lock(&c->irq_lock);
+
+	old_val = c->irq_enable[irq_word];
+	new_val = ioport__read32(data);
+
+	if (irq_word == 0)
+		new_val &= ~0x1;
+
+	c->irq_enable[irq_word] = new_val;
+
+	xor_val = old_val ^ new_val;
+	for (i = 0; i < 32; i++) {
+		irq = irq_word * 32 + i;
+		irq_mask = 1 << i;
+		irq_prio = s->irq_priority[irq];
+		if (!(xor_val & irq_mask))
+			continue;
+		if ((new_val & irq_mask) &&
+		    (s->irq_level[irq_word] & irq_mask)) {
+			c->irq_pending[irq_word] |= irq_mask;
+			c->irq_pending_priority[irq] = irq_prio;
+		} else if (!(new_val & irq_mask)) {
+			c->irq_pending[irq_word] &= ~irq_mask;
+			c->irq_pending_priority[irq] = 0;
+			c->irq_claimed[irq_word] &= ~irq_mask;
+		}
+	}
+
+	__plic_context_irq_update(s, c);
+
+	mutex_unlock(&c->irq_lock);
+
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__context_read(struct plic_state *s,
+			       struct plic_context *c,
+			       u64 offset, void *data)
+{
+	mutex_lock(&c->irq_lock);
+
+	switch (offset) {
+	case CONTEXT_THRESHOLD:
+		ioport__write32(data, c->irq_priority_threshold);
+		break;
+	case CONTEXT_CLAIM:
+		ioport__write32(data, __plic_context_irq_claim(s, c));
+		break;
+	default:
+		break;
+	};
+
+	mutex_unlock(&c->irq_lock);
+}
+
+static void plic__context_write(struct plic_state *s,
+				struct plic_context *c,
+				u64 offset, void *data)
+{
+	u32 val;
+	bool irq_update = false;
+
+	mutex_lock(&c->irq_lock);
+
+	switch (offset) {
+	case CONTEXT_THRESHOLD:
+		val = ioport__read32(data);
+		val &= ((1 << PRIORITY_PER_ID) - 1);
+		if (val <= s->max_prio)
+			c->irq_priority_threshold = val;
+		else
+			irq_update = true;
+		break;
+	case CONTEXT_CLAIM:
+		break;
+	default:
+		irq_update = true;
+		break;
+	};
+
+	if (irq_update)
+		__plic_context_irq_update(s, c);
+
+	mutex_unlock(&c->irq_lock);
+}
+
+static void plic__mmio_callback(struct kvm_cpu *vcpu,
+				u64 addr, u8 *data, u32 len,
+				u8 is_write, void *ptr)
+{
+	u32 cntx;
+	struct plic_state *s = ptr;
+
+	if (len != 4)
+		die("plic: invalid len=%d", len);
+
+	addr &= ~0x3;
+	addr -= RISCV_PLIC;
+
+	if (is_write) {
+		if (PRIORITY_BASE <= addr && addr < ENABLE_BASE) {
+			plic__priority_write(s, addr, data);
+		} else if (ENABLE_BASE <= addr && addr < CONTEXT_BASE) {
+			cntx = (addr - ENABLE_BASE) / ENABLE_PER_HART;
+			addr -= cntx * ENABLE_PER_HART + ENABLE_BASE;
+			if (cntx < s->num_context)
+				plic__context_enable_write(s,
+							   &s->contexts[cntx],
+							   addr, data);
+		} else if (CONTEXT_BASE <= addr && addr < REG_SIZE) {
+			cntx = (addr - CONTEXT_BASE) / CONTEXT_PER_HART;
+			addr -= cntx * CONTEXT_PER_HART + CONTEXT_BASE;
+			if (cntx < s->num_context)
+				plic__context_write(s, &s->contexts[cntx],
+						    addr, data);
+		}
+	} else {
+		if (PRIORITY_BASE <= addr && addr < ENABLE_BASE) {
+			plic__priority_read(s, addr, data);
+		} else if (ENABLE_BASE <= addr && addr < CONTEXT_BASE) {
+			cntx = (addr - ENABLE_BASE) / ENABLE_PER_HART;
+			addr -= cntx * ENABLE_PER_HART + ENABLE_BASE;
+			if (cntx < s->num_context)
+				plic__context_enable_read(s,
+							  &s->contexts[cntx],
+							  addr, data);
+		} else if (CONTEXT_BASE <= addr && addr < REG_SIZE) {
+			cntx = (addr - CONTEXT_BASE) / CONTEXT_PER_HART;
+			addr -= cntx * CONTEXT_PER_HART + CONTEXT_BASE;
+			if (cntx < s->num_context)
+				plic__context_read(s, &s->contexts[cntx],
+						   addr, data);
+		}
+	}
+}
+
+static int plic__init(struct kvm *kvm)
+{
+	u32 i;
+	int ret;
+	struct plic_context *c;
+
+	plic.kvm = kvm;
+	plic.dev_hdr = (struct device_header) {
+		.bus_type	= DEVICE_BUS_MMIO,
+	};
+
+	plic.num_irq = MAX_DEVICES;
+	plic.num_irq_word = plic.num_irq / 32;
+	if ((plic.num_irq_word * 32) < plic.num_irq)
+		plic.num_irq_word++;
+	plic.max_prio = (1UL << PRIORITY_PER_ID) - 1;
+
+	plic.num_context = kvm->nrcpus * 2;
+	plic.contexts = calloc(plic.num_context, sizeof(struct plic_context));
+	if (!plic.contexts)
+		return -ENOMEM;
+	for (i = 0; i < plic.num_context; i++) {
+		c = &plic.contexts[i];
+		c->s = &plic;
+		c->num = i;
+		c->vcpu = kvm->cpus[i / 2];
+		mutex_init(&c->irq_lock);
+	}
+
+	mutex_init(&plic.irq_lock);
+
+	ret = kvm__register_mmio(kvm, RISCV_PLIC, RISCV_PLIC_SIZE,
+				 false, plic__mmio_callback, &plic);
+	if (ret)
+		return ret;
+
+	ret = device__register(&plic.dev_hdr);
+	if (ret)
+		return ret;
+
+	plic.ready = true;
+
+	return 0;
+
+}
+dev_init(plic__init);
+
+static int plic__exit(struct kvm *kvm)
+{
+	plic.ready = false;
+	kvm__deregister_mmio(kvm, RISCV_PLIC);
+	free(plic.contexts);
+
+	return 0;
+}
+dev_exit(plic__exit);
-- 
2.25.1

