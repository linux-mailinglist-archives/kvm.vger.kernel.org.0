Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E5B452990
	for <lists+kvm@lfdr.de>; Tue, 16 Nov 2021 06:24:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbhKPF0v (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 16 Nov 2021 00:26:51 -0500
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46798 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233913AbhKPFZe (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 16 Nov 2021 00:25:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1637040157; x=1668576157;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cU5iFsNghp3YYJSRkTl+8K6LdZd9Li8eykQzonfR3aI=;
  b=pCDNEC2YkiferMEjR1wIVBMWspDPZZ0ESbZucndU+Ds8LNTxWKmk7xva
   OdjfaQSZ2L7v2YMckOhtBCP4oIqXTtg1I7g0vCXT7jmCgkpnps50E2AsD
   M5BB90mbCVzvOjCLYNzVHNTKJ2s8TIAF7DlyaLcOw3uCUoXLwLNUiu67r
   nyqylUDzfiv1mN/XqCWy1BRFmar1CzeIyUcoLJd3LjFDLU2Rhi4C93dwY
   lLkbzdl4n9zxB5iGBmm+w1cgZUd/3h2ZrJ+3K2IuGGSoLETv/LQXvfJ84
   Q1NyIHbp6uVxEv1Gm8KkfxYjpI3tsCw4iaM2MJzmcqebKg18GspJoy7Ko
   Q==;
X-IronPort-AV: E=Sophos;i="5.87,237,1631548800"; 
   d="scan'208";a="297516496"
Received: from mail-bn1nam07lp2041.outbound.protection.outlook.com (HELO NAM02-BN1-obe.outbound.protection.outlook.com) ([104.47.51.41])
  by ob1.hgst.iphmx.com with ESMTP; 16 Nov 2021 13:22:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Hz/7K0cl9MqcSnDQoO99EQLHO6NY7mNkaa0qnVbYfzIX7ScaVRyZbvYVezZxcBoG8lYI5hMHSjPmQDeFypsbzQ8kWFokKS42b9wRyC483rMA2MHYM4Jk0fW0dWqmoMbQFsLapz32m+iIsh3FbhfcACJDOyc9scBnKNZqxRE8z4N+gWYLWIVYwqWYsncKyuriZIF3Rx4luYbBM/oRJq9atpGdWznR3w8m+N9LeCaRffTgES+TQJNz4oj9kDyYemW8YFvHbhL7evQgo3cEqCwtddqO6xBZBXP691a2uwcWzsuIE5amq2rZih3+t6/2mJc6t6TC7dEYRNpyPXRjwrLb6w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vY0/KUfcZ9KJKxeirkntOfpIVJjhGbaNW2NYckuSGbg=;
 b=FWPJNK2QQm+KKuwg6a5oPxqk9yRF8HMQrRT9v8wMCw9dm1nKcanUfZxSCVxZ4rHVLw3KzdjeQA9nATkFbF4UBzcxtruJSgECqpYfG+2GQzLCKnnAqFONLmFJUuhFkfAuaP2xRZQ/OogDqf3WzYA+AxXa/h1loSFOF+vtZV/7N5Q2+9wanl3GZ4naxOwwkC/YzgtJMHtKbqEtD3GQZAY1wUltFpE6zOQ64RtDw13ZUyfCwG/iVMnV1mHvOpfkzY3mujlUO0EcVLVyTEpSur2nVUK3OZJwzUwWZfyAp2X364m8/9C1OiP3tvcixqVDpGBSku+wNs3KfuUVLs99ekXyow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vY0/KUfcZ9KJKxeirkntOfpIVJjhGbaNW2NYckuSGbg=;
 b=RqRKoMLIOD401QiCcsoeU1KVN6j6MGwWq1LKzl2sOqDw3/0VU2SHUKDkY+qV56y4z1Puu1QAQzMKjRSPB0NZFagpSx8sU9RyClTy5v76nQHai59ecVWmqrDFIyJaM4wq6N3oZCOxoob07hBTVE49XgQTruvOvA9UTN2M4zKCq3Q=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7843.namprd04.prod.outlook.com (2603:10b6:5:35f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.17; Tue, 16 Nov
 2021 05:22:16 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::8100:4308:5b21:8d97%9]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 05:22:16 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>, julien.thierry.kdev@gmail.com,
        maz@kernel.org
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atishp@atishpatra.org>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>,
        Vincent Chen <vincent.chen@sifive.com>
Subject: [PATCH v10 kvmtool 5/8] riscv: Add PLIC device emulation
Date:   Tue, 16 Nov 2021 10:51:27 +0530
Message-Id: <20211116052130.173679-6-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211116052130.173679-1-anup.patel@wdc.com>
References: <20211116052130.173679-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:71::36) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (223.182.253.112) by MA1PR01CA0166.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:71::36) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.25 via Frontend Transport; Tue, 16 Nov 2021 05:22:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7cf93e8-3f65-4027-2d41-08d9a8c10d8a
X-MS-TrafficTypeDiagnostic: CO6PR04MB7843:
X-Microsoft-Antispam-PRVS: <CO6PR04MB78437819DBC580FC645684038D999@CO6PR04MB7843.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qWJ9NJvEjXfPgb4kRb0lAHyYgKRWAGPJ5NqcsZ8Df1wab7KOy4sF7rNCsUvmgCVax6OSZbvLfXOZKvEfQ5isyQq4e4MwYDbuGVt7AqU1hgb3m0VLH+by7zwsV2M7YeMQowCnGv7LsyCbcP6FiqyQdpm0rVXF2nFK0Z66S28gQNi4MjLTliWK9HhDkvMSNAB8h5r2KC2haRMIMVEGVoPo0DtgyBGn5zcvPQSQJ/3bKllahJcqFAjeYNoCM0qWS6TkA4PzcTXcbF0S4+dGbsSFvfQaErs/ypGK4rEw6h3x+CE21/umjVLNeNBX9yLP31ynbJsACfNYRsDgP1FCoOsS1oO0hU2UcLiyPvLOIzRPaEuhh+RVnu1BAA3qQuerhGf0mwKmICYHuz0Y+IV29Q0KBqCKdJIA0Msl1ONwjStld77MymgeRib/fQX69aR1oFBe3WMJK8FIQANdxKgh2CysxBbVTNLmCPkb1AmZcjyD9h0zXd7SjykfsTBddsnvD/lsxf95NbWE9zObKNZi4HWDVlYoYp0oi7EDXGu5yzXoxGY+axNf0+wpMM06BiVS+TJb6Q7ZdBMwzHS2dHQVoTeQG5/01hTEEd5jyVNNuRy1iZ0pDw8LO3jlEwAXtASFVg1cw7+Grxdhhfz55H2q3LM8kAYPNIHlQUjtc6nhA5V2lkO0+T/L+3pzck62Pu1oFYYZSXsdLbR9tLI82nIkfaPs3Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7696005)(4326008)(52116002)(66556008)(8936002)(30864003)(66946007)(83380400001)(6666004)(186003)(86362001)(8676002)(82960400001)(2616005)(66476007)(8886007)(38350700002)(36756003)(44832011)(38100700002)(956004)(26005)(1076003)(55016002)(54906003)(5660300002)(2906002)(316002)(508600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?P5qIwyoMZv8RVKMiGdJX5plm0ejr8FFT0ZqCUb2Mh/IghZIdN8yDqIpaKTja?=
 =?us-ascii?Q?sjEZaaJv+4/QOQtzy6VwymuTKCUILrXaszPc9fwxo6WozyTaYhEtiayGhQ5n?=
 =?us-ascii?Q?gDwSVateHNSc2U4JIKlug9JkRlfrq4c/TWwT/UoZRLtGK8VYo8CCRrxRAU2E?=
 =?us-ascii?Q?jBDJH7t/Rv9CRD739o+yA2Wd6mW9KSPoHt69UgaXZhwf+EAllamUqE4n8Qkj?=
 =?us-ascii?Q?p/ZFfjINmOI+mQgl7PPhKOpygiQ6vjgn4wgqSPixN69JTd5mqs6jhGcHZPVv?=
 =?us-ascii?Q?cG/rT4tEhXWjRMxetr9lcNgzVbj8vH6gHi5R6eKGqtUnImUPjn+Y/OV6uLeu?=
 =?us-ascii?Q?4e6/Uv02U7rbSk/T2m98DgfC98lzH5jyyllSGEl0JDxPAAEaHDZm5c+NPSLG?=
 =?us-ascii?Q?ohUue7KG8SDazazMrrjzdiDvmS8cSbg2f1yTLDslxb+NhORmk+guaVy7/D+z?=
 =?us-ascii?Q?KJiMJ96zJ7dwH5/9Tj8KH0vSfPchn6GV1AiwrQl75KESrXxbPqLit/cvVlvH?=
 =?us-ascii?Q?ysnYDDtxJaPrd2hw38TJlhT041WgZMhYLsu3J1lvonsqJO8lf32jkbuC3XvO?=
 =?us-ascii?Q?+qtXEXAgmgjxfCl1HW1wz6EarlX/B2ttZxnuFWWe7QEVh99L9To+CnuRmT/r?=
 =?us-ascii?Q?96GWWKVhwTirThcy2sSGRElNw1NLILLXKZO+OIf/3l8WNlPH6y2QB0lA7EVp?=
 =?us-ascii?Q?PaO/fimfBHwTX3MJ3nlcvh1d1255TmZsIdxtU1us4Bn6adOJ+tYIAnDWgyyx?=
 =?us-ascii?Q?7LcGXbchoPhdcgu5GGoYoK5pYoPyhk/xTwA1pz+B9LV3nXnlzH2ITXLRH0fw?=
 =?us-ascii?Q?vouaL34d0JI27C354FW1fYqR7uxGbcxtv5R/O156mdNS/dvS+7WVJa1iGfuI?=
 =?us-ascii?Q?vUAikJU3ZrWkSVfQ9EZt2uv+YPPBxf+EOpC6KDmnBbEmOgTkBAU0yoiAwFpq?=
 =?us-ascii?Q?XhyaufFpbneZAxekL9wTc3w8F9S154pfQFk99m1lMjf8WwdwlH1hZ9hkxhVI?=
 =?us-ascii?Q?9zzU59pRTD4kpMroXz3UNOLF75PM62mD3+4TmSIV7m3HaJEbbjb05/f/9moE?=
 =?us-ascii?Q?bIEsGC7AF3+Cw2VrS3YoD0uYpLARSYb4ejRu/XWGZuGnZta3GHzhpVKkTlVU?=
 =?us-ascii?Q?mF2c+WK37do8ZX3xkXG7OSDvUsPAmn8rFxZGkSng4VQTrhcPbYKEQyuTBnJq?=
 =?us-ascii?Q?ZOVwVK+KsXZ6JcJTjaYUAVk3cnbEDiEOD8+o0QX5ktV2Zl3OkG2kauVP3DvT?=
 =?us-ascii?Q?prn+EYXNeLGLHOKrmnVhKcRqID68kr5YZOy/2XEb/Q5Us1ZfG/1SGT9ND1hO?=
 =?us-ascii?Q?Tq+15NaNdFIBSwYx22qseapyIfQz5jnQh/3bm1uil/asoF/VtlKskQOrTMKl?=
 =?us-ascii?Q?X6QB1utx2RhoqVhPGLkiNzPbXWPViQoJVbUvS0GliUwkJFRM+N9Bsm1pku3u?=
 =?us-ascii?Q?k0ypGLq1y8LZjTSVVsFw3TidElIPmI5VMID+WXGC4wFJeXyDh2Y+i5Tdamry?=
 =?us-ascii?Q?I4zAPZ1KaqGB4d3x/M+w10sNOYpm78cecyuDI4jwMvDgPonnY35EoLYgAAQy?=
 =?us-ascii?Q?ioLM9mRxpUxYTiYfCVLs+NTRFx+hYl1l1lxJBgrT5l1rVtZl3HimQEnLG9Na?=
 =?us-ascii?Q?gfwChol4qBQDg37lNQazQDE=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7cf93e8-3f65-4027-2d41-08d9a8c10d8a
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Nov 2021 05:22:16.0024
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DeMP9bRFejH8flwsPOpZscm0hM0uHN3cOFQasKE8seGxXGzcwpcN+ATIv6HOqjeuSvoL5XZIqwLyD1GbgtxmOw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7843
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

The PLIC (platform level interrupt controller) manages peripheral
interrupts in RISC-V world. The per-CPU interrupts are managed
using CPU CSRs hence virtualized in-kernel by KVM RISC-V.

This patch adds PLIC device emulation for KVMTOOL RISC-V.

Signed-off-by: Vincent Chen <vincent.chen@sifive.com>
[For PLIC context CLAIM register emulation]
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 Makefile                     |   1 +
 riscv/include/kvm/kvm-arch.h |   2 +
 riscv/irq.c                  |   4 +-
 riscv/plic.c                 | 518 +++++++++++++++++++++++++++++++++++
 4 files changed, 523 insertions(+), 2 deletions(-)
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
index 300538d..25b80b3 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -80,4 +80,6 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_addr)
 
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
index 0000000..d71226e
--- /dev/null
+++ b/riscv/plic.c
@@ -0,0 +1,518 @@
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
+		val = ioport__read32(data);
+		if (val < plic.num_irq) {
+			c->irq_claimed[val / 32] &= ~(1 << (val % 32));
+			irq_update = true;
+		}
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

