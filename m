Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C7423D6E86
	for <lists+kvm@lfdr.de>; Tue, 27 Jul 2021 07:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235414AbhG0F7S (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 27 Jul 2021 01:59:18 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:33290 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235328AbhG0F7J (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 27 Jul 2021 01:59:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1627365549; x=1658901549;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=2WQyPGrOc0YLKRfuBS1LSmGdRVjD2/yNF1oPBOu8nV4=;
  b=qUKJ0DeIGxnre1mP10d2x4bBbrxTk58dz+P1PFFOe2FjOpNLHyV3Vrvm
   YnqCvj0b9Y6ip5TZ0nboPZeyeyKRearZEleNgHBbvjIBXj2HvYi26EvdV
   3c6ZMh9xuiiluHMPRlsd+N4C3ASUW86FhidYPULPZoyOoFuBM7v13DUao
   12U3Wk8JKxnNGrGmubNUvUexT2dKaKBfsTiUMG0PmOz1BMcUrRNUlz2Qi
   Eo/9kYX7MIChoXQ+1gS4MyfhIkgC9w+OM+eXV5iXvO7Np88p7Wpx6kRFY
   bZfK8m3P3XA6r5cyOVL27A/Q0vxBRIRg8yNhc7ySGo9TZnISM4AbDFbHc
   w==;
X-IronPort-AV: E=Sophos;i="5.84,272,1620662400"; 
   d="scan'208";a="180386120"
Received: from mail-mw2nam10lp2104.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.104])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jul 2021 13:59:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NxDGWIlCaxYrOoy/qTE3tYxsVFOX3jnHKddFwNTPqhh/pEfjgBWt9etIEYwEwAyAntoRuWEVVHUavvPjZZzKTTbZKnYjRcCG4mcZdVaneskXR4im8jguOMJWWMEI1fb0QxCO+ejIdgIX0itObCiPplJjxuXvQRR6ZBNOBZglH/XjVCiUeOJZriU9hwLs+gVMU0FcxgsZEZpx0iDJ6VIq/vX6nK/CzHKsPcIpGokl/BS9HUg6n/Shpl3kH98yncNGiaS4sKOkGrFT09c526IO8cXZvCDt60oV85WalzzCHrXQTn2rTT/9x21ToZDE207Jyg1momgGOOvnvyRnBh2KRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3s1/7pJ0sVgc26M1jvbwxHoaoopIPAcng8ZlZYWYrVc=;
 b=fMaLSob0mldDSJP3JdJrvJnBD3WpoWiE887HhkLl3SCD55DXKI4qghQWwOenEIVb6dL9gEhorPAbdrR3eUOQZKUuUKOcflZkshA1fM4O/zZ7XlSUWd9fpDwAebtkZzuv+MdTUEiCMNxg53gctfVP+xRQZO0yfT3I2++gQFo19AChJQdaRtgHtR3fjGyw82XAm3UVwgaCx1oOUT8wFl/abXeyQhI11m3Qobb5/dEUE8pfOwPs6Cr1zn2GoVQTWx/f5FnfxwGIJ+dytY2XOJkesMzMFYKUi/MJAjlj3N+puz4lIhOsDfFqbcWABdHwjB54htg3ROb8ScSrsenWV6op4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3s1/7pJ0sVgc26M1jvbwxHoaoopIPAcng8ZlZYWYrVc=;
 b=T4VwF7W9/9J0AYVhRAsVOINlQ7edOj06v4xvF6E6Y21ZnmMkIIeKsKhp3tlFy7tvz4zUpsGU758oeXbQRUCmmWJ7YFqwEhnu2jEZ/OhIJNyZVFMVOc35/pXJW69D8R3e+W3SZNXFaG6e9ourpWEDYJHc0pQhb/5mabZJlSu65MU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7747.namprd04.prod.outlook.com (2603:10b6:5:35b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26; Tue, 27 Jul
 2021 05:59:06 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::a153:b7f8:c87f:89f8%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 05:59:06 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v8 5/8] riscv: Add PLIC device emulation
Date:   Tue, 27 Jul 2021 11:28:22 +0530
Message-Id: <20210727055825.2742954-6-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210727055825.2742954-1-anup.patel@wdc.com>
References: <20210727055825.2742954-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::12) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.171.179.229) by MAXPR0101CA0050.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.25 via Frontend Transport; Tue, 27 Jul 2021 05:59:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 19349e24-33ef-4b40-6765-08d950c3a49f
X-MS-TrafficTypeDiagnostic: CO6PR04MB7747:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB774748D66C1A46AB197B54A38DE99@CO6PR04MB7747.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UmS/gdcqUwliEIqMACsBjjW7/wE1MmlXGuvP2ebWIXUDqaOywhekRa3p82LYd2zvqNDVQCOfNVfVT8iOGk+XYt00m5bzwoL6k/05QbHxeZfIF7nbeyKMQB88sxlf4Z6itVq0+kIsNnMNhmjCXDAT7juylU3LaomgryNyDSqUxybMR6AaEOwmnTYfQpIP7vb5d3Eba6dXHEJSrJrPAUT1vZisgpCmWMD5O+rA8NF1N94gBieXQexPBPqlXYCETYFCYW7cbfUTtX00+81bEcZLxr7br8L0+eGKY//YH++TUxYApRVqZarL2frGoHe9CDp7QHp4ACFsHZlrYDeO2NwsnP3gsnXuQtcz3n8KHVOYf2X51MjVvOPlIapHEMdvnB9NWpEFkv1hjA1Ea6WZqbNyWFFPYs7cYpKxLV1RaMFEwlL7ArwCaTehkA5XwyWvkhlofCzUUZjrteUstWOUYWDfLEq2FSsN2l2BX1WvbT+V1kBxGha4nOaHdt/pnk064EVXnpWef6wbw34pDDdVtCV0y8fQ8kg/gDhn769HnuAIiXVGlbgg5FLGVr6JNvETHnVglLlUJmpXTtsD6CnHGQ3g9GCHlPsH9g1dW6FJmn1FSqQwxPZ8FEkuCD/riXaumBOx+Ji24ic3mGuXG0LxlPijJ055GLMCAJ0HeRNcIwRyTJn3jrlcGyk2fUP5+mzoo+Nb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(396003)(136003)(39860400002)(366004)(6666004)(86362001)(6916009)(478600001)(2906002)(2616005)(26005)(8936002)(30864003)(52116002)(1076003)(186003)(44832011)(8676002)(956004)(55016002)(7696005)(54906003)(316002)(66556008)(66946007)(66476007)(8886007)(38100700002)(5660300002)(4326008)(83380400001)(38350700002)(36756003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jbfGdD7hO0YyAbrXoxJ7NIgicu3QtS5O3tuLFdLXdyd7xts5ttOxAH70zEuP?=
 =?us-ascii?Q?Uvkh63juSZgZhV5VuIv52hyGjIxbwPy+y3MaAxyJZwOR3zZ+opX2f/QOqUs0?=
 =?us-ascii?Q?NXeb6Y/OjrBognasZfvHc1lmtsY3q1aQ9HYwkVksB4d8aJh3JlwnSVOIlL0j?=
 =?us-ascii?Q?AnXIGeKz2uPWSDqhBc+klzlKkQ1EGmo+YmnWm3l53medsK/K7zZMvPPvUeO0?=
 =?us-ascii?Q?jm7nLZm3JSVOBj/WgPCqlWyWBKxXKq81UOXQBc823CIIC0nyrsdq6IeSIvuh?=
 =?us-ascii?Q?bWON2pR9pw6OtG3TblLDPeErEwOPP5qEumSMpaKkMKt0RqnN4G6M0FTpe/2T?=
 =?us-ascii?Q?F4de086rAKgXwkzfNDWEt/yEdkT8Q2VanxBFqXsTmb/+2knlvF73MXC1aK/D?=
 =?us-ascii?Q?Xzrdu13Xzy0CsowOLW7RBCPS2/7WPfyZnZ72oPOqEMzXL81yOgbp0DEEgRne?=
 =?us-ascii?Q?kc9R7ifydvJ+9DCSAnYLbYmtaz47nR7xUi8RYPXfVfbZdNAgDBHr4Rig4w2z?=
 =?us-ascii?Q?sCC1rEEMfOZR1ZPUovrmwWCbK2D21YWRwWUlAiz8dMlh64aFaeSzE/Ps/hlA?=
 =?us-ascii?Q?9MbP1Ef7XCZvro3UOBStdw2HVQC92gyLCMAmXxt2ZM8y/T2pajDUcnnYcsYS?=
 =?us-ascii?Q?NV3KiArFrixS07ZuHaAXGrAioLqiKLiqwh+q1Y1+s0eDAfMCK1gDYP6BHRRD?=
 =?us-ascii?Q?0BWSpX2qG+lZD5m4+I9YF5anK33eSsvMMAh4hJM8Ec0MDKjT41MUuojHZruW?=
 =?us-ascii?Q?x45yil7V6+7hF7F89yERtHpk0xcNM41091ViTUsO4vY4ZaNZuEk1HX+KvJKm?=
 =?us-ascii?Q?khgdoefgcc5A1lb3Mkxc7B9M41WIJQ8wigdVBzclLfqy+CYlw26NNh3OUpTY?=
 =?us-ascii?Q?7yG+c35ErD7/48CNs75JcVFDlbXhWNK0XAXKDmGcYblhxIpGbDVRKNS468Jh?=
 =?us-ascii?Q?tNya2s5o+bWCsULFXLRCFxsWY6tXSplwobLyjpPsLD6rkYIN4kSIFdwYghgP?=
 =?us-ascii?Q?Z875L+GXG+xTZWv99QNJ509ml+/vjnpZMlms1AhXj+1LttfzFo+pq8BwCa7g?=
 =?us-ascii?Q?6BhKphsSPQ87YGhKeIBvUcKnzgI+DR99DeEGlU9qVYaWrgOVnk/QxoewVCSx?=
 =?us-ascii?Q?Zf32T3UgF+n0THLSUcd3wonGfNOpt5m+pbU98sYvxr1fZRtc1guttNITgesD?=
 =?us-ascii?Q?D3tu0V8GN7dFpyZNm51m07sv7uLmNQOXI4KQx9927n4K61kWYLdJYD9tH+7Z?=
 =?us-ascii?Q?OFXku+EMGVmsfCPoFoqf+0mg5EXMeEA8FN6quqY8iiJ1rjwA5l/IoKTwgB9V?=
 =?us-ascii?Q?BkTfo4zmWIAYHO0fgdQmQsRU?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19349e24-33ef-4b40-6765-08d950c3a49f
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 05:59:06.1714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mz3COc9RcjoUqFUV8n8g7C5gwtTloocEqnF7NHI1CmUGC8F7N6iI4k1+tUZW3AdujDsN25SPWQwCAWfiMuHktA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7747
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

