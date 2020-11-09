Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC992AB747
	for <lists+kvm@lfdr.de>; Mon,  9 Nov 2020 12:38:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729508AbgKILhy (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 9 Nov 2020 06:37:54 -0500
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:28161 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729961AbgKILhx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 9 Nov 2020 06:37:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1604921874; x=1636457874;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=/0T5Ki2Lj1DFnjbgmjys4xMNGjRVHw8B2nUHI9CqhtM=;
  b=YnhYnaR7tiIcpiKPxmoLTzGZiOh7rj38zKxgvorwwqwLHpNnbMgdMlgm
   sQ2qld8EfvBNbqy7o7YSezqj2jbufO4pGDTl2J6vn2yQzKykoX+jgmgRt
   TIFp6mEG5Zlfq0MDf5CjTUIl37WY4/PuaD5cvw49iZiOKZw0SapBsE/g4
   5ESpLYDCFNEip7PuRKdlXI9J9EuB32CEFnfPvJsSeP+c3Lt/escos4NSl
   sIV3jijgPxg1a+o/BjeCtd8GHAClPLekznSt/68zheKxF0qRO20Kgab9p
   RyOrLWc6kAUBLtwZ+COL+pQ0Ya2wJWVCS6MMiIN6gEm+LGcfri+JQ3IxM
   Q==;
IronPort-SDR: YRS0ZF4anhDrLRVVQd3IdWbnWn1vuerVUUt6CjrDB47lpUXd1z4w5qtsjInRHKoMTYZg6rpXRs
 jXnraWfms52KCeMP7dvz0s3zIUID2eLpQXYjzetiqRzuFnHIOBOzjb2BG8Xr8YFpk4ZXsjZZ+l
 PIub3sqqISq6suI63P/HJ5BE9CTywi8sYTLvX7BtiTf5tHX+T+etPQEm9AjfAszJ6rFDUCz0z9
 ygn6x6Z307gP8/kQx1Yh8biggxa/6FQ9HViZaCyUnWMZEYKvrNjvR2PgpTZ3QbVy5VqNL2cdeJ
 3aw=
X-IronPort-AV: E=Sophos;i="5.77,463,1596470400"; 
   d="scan'208";a="153383060"
Received: from mail-dm6nam10lp2109.outbound.protection.outlook.com (HELO NAM10-DM6-obe.outbound.protection.outlook.com) ([104.47.58.109])
  by ob1.hgst.iphmx.com with ESMTP; 09 Nov 2020 19:37:53 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gc/pdrcGdV2dj5V8UCgSfPHFkCyC7qCi1LHCl6lglVQ88BBKxVj+qaYxclMbXMfE/I+USIAQmBOlZd6dc1SOAO4WfOHn6hZh8O0yfUMYanevmhv6xRXAaXCbtpakZ6Qaq4PvwX2O0z67nD9MBgKDQGFraJ0d6/dDv+SB+K2av37f+gH9BgG6BClOYX9hL+IXbCx27R4Y6jp1espEhJo08DK37QieSMD8L/1KeYN5MPgEORMk1OkyVprina5EcCwFvOO6t86bSSem8SXR0ASM7wQB28dcWUP8uTUM1n/Yf+VAy0ereiFvOuvukpSvy8D1Z8HlRmbQG6/Ns6gwcExUFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGmImHprEx3Lq9WiCNm9xR5RxDS+H3xDJZW2fdOX5Ho=;
 b=WU0CDkvp6+AZNBXGln5cH9o8x/M4fVBfgloDxGGZ8GedXvCD/TRQdWfs51u6cQmlPuYa/7nAIlSJTscXhiL9wDP1SHCgCqfZHfhEMq/nhyDmmUeRL6oW9p+ZsFiEGshDlkEp+0fZMfLshM/7kGA7tTVWG8dnoNtQvHpm94R8b3sRbVUHNHLFBtt6BnKynM+LE068J+mCjIT1uWDSqcQ1axoBoI1qmlV8bGWTeoGL2FdIM/4RvaeVebHCD3/wLwRvQsb5Zhm5qZmgSCEZWSvQSSRUMJUJxnw9ZVZ0t+xGiqrYQRj6QO9HFx4PmsKOp8Fb3h3Uh8MUuFI6FnwKf7SD5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eGmImHprEx3Lq9WiCNm9xR5RxDS+H3xDJZW2fdOX5Ho=;
 b=JAgZleN/rg+aNJjArFngKNtMuJdMO4bgu/G9maOk+tTcCrgAZx/OOL8xRhL1N4BZMxJlMq48va5FLWfxGtH6JGV/OgdnoyVJvujUIC11JmimnRso8VGHIK5juCfMAFH8bdA44J9yCgXbE5wGYYJIL5zuVznDP6X+raMmCpFcDXE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5961.namprd04.prod.outlook.com (2603:10b6:5:126::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21; Mon, 9 Nov
 2020 11:37:51 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::d035:e2c6:c11:51dd%6]) with mapi id 15.20.3541.025; Mon, 9 Nov 2020
 11:37:51 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v5 5/8] riscv: Add PLIC device emulation
Date:   Mon,  9 Nov 2020 17:06:52 +0530
Message-Id: <20201109113655.3733700-6-anup.patel@wdc.com>
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
Received: from wdc.com (122.171.188.68) by MA1PR01CA0094.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.21 via Frontend Transport; Mon, 9 Nov 2020 11:37:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 59656cb0-cf51-4791-07fa-08d884a3e42e
X-MS-TrafficTypeDiagnostic: DM6PR04MB5961:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB59615383C111F281DAA228C68DEA0@DM6PR04MB5961.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3F34fRFzyDaxVYCF/s3Ov7+IJQGlKlnasD27mbYeGUDLBEwq262zl90Y34t/MAd05JNrANZFfcDPYRh3t/lR/lP/yNH5Z6WkeQU+iH0W6VuSfn7Mw+Cq0PN1dZaB/75SNbyKTd8GnP1heTCBly6/oJ5Bei3L4idjeObGc9lh1l3aPDaYAgP0NP72gTdYHmH0mX5CDmRU1j/DnKV06wJcFDuqhQbYQHEP2aBVKC9aBS2LSmpaLqYDeXeXwVt2j7qtoaFHLPqO2HyrtUGhT1q3lpOWMLu9Mm/GnCEuah3NCB5WxIiT0X5Oj5NmfnsHhtIF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(8936002)(8676002)(30864003)(86362001)(956004)(2616005)(44832011)(55016002)(66946007)(2906002)(83380400001)(6666004)(4326008)(66556008)(478600001)(316002)(7696005)(6916009)(66476007)(1076003)(5660300002)(26005)(16526019)(186003)(36756003)(52116002)(8886007)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: H1mRt6poJvLlHQcVGIivUsU2p54qtzeM3dbLo2z9iU6aWGBYbqY/2r/bzsZxaAt5aR8jSQfsqAsYnjcVPCIWANiKLsJ4NPLBwjGiIJ9PKnIDr7s6LIn/4f0Uvl72sBziaAhl5de5hv0i/Vm7VLFqsQuCvbhdHHpVLMMHsuBQS+y7e1EmjKcgMKvokohRWwzUHZDF6wsdiKJOp/NZMctfn5wNCHe3cCvXKf8VHTyfm9glJZV0oBbtSRvlKKw2P9nXPcYcrMn51pWV8B2dExQglBQKY5dR1jXKnlEaeCtZVmz4BAV75j7a0vWHbByWta0FD6e2ZFddQPco08O6wUHl7aNJ6YQctAtDK57neT5LwmuNUwnhN2ltO2EhVucmURyRueYS9YQvrBnpeDep+kK+iA6AgJxJGlJlUxpwK2iEgQvLzIcc2wNuCOH6Kvtqu7WBQD7DRZjtxC8947u4h0QtuBG+upQu+OkVDw8LaYJZeLD3Xa+CgpuyLIlLwjtidt5n96FtOjxllfVykzfV9dzxWUMTSWj5Ut1N9D2MLa066Ha+et5Eq9W1S2gIfvM+3hOYD88OhaRDCsXyNka3dmzLGJy/BZJHhx/VwzbA/9OJyFcCA/soOXlpMmE7KIGnYmV0Ycgits7U3HC9UNHpeRiyuQ==
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59656cb0-cf51-4791-07fa-08d884a3e42e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Nov 2020 11:37:51.7331
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CYmknkHugOtUOIgutyAm5noT7LdQdhApG/E3SKIyGrGTP21NuNXHPaN0NU/vMz5ofwUtQ1A4oxLvI/jWbijzqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5961
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
index 1782cb7..e2dd39d 100644
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

