Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D73412A5B8
	for <lists+kvm@lfdr.de>; Wed, 25 Dec 2019 04:00:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbfLYDAl (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 24 Dec 2019 22:00:41 -0500
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:18614 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbfLYDAl (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 24 Dec 2019 22:00:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577242849; x=1608778849;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Z1KQCJU7OqrmIu8kb2t7FriYvpjXbdmCGzYQCEfjYAY=;
  b=aEP0wFkJdHUjOdfFZx5tOg1BQp21EKWuyfo8WyedI7wXl+rKJmpbl7TA
   wK4IVnaoPw+OIJF8Ql/LUbAoKxS/qtlhYXL0B/PBubj/aS/shKTqgfw1S
   Ds1gCDQpRQhvKyOs8c6/0kTM8tOwNgHxlDftiCBPv42a+pdbuk4O1dO3l
   7S0+9nkG4Bg9qp5vorGg6uYUiYD6xaJuche3X6ws/UWWKqeecElr6G/aR
   QcYw0zhGyLnI23E3gM+qoyfGurY992Or9no5L9+8ACf/FYur6UDNx9cCL
   sJQRc8ppWzF0HhsL2XBkalOBiteJrP4pxOSllC7cve6Rkxpof208herwT
   w==;
IronPort-SDR: NJ5S9sABdAMGpcdMb5n49CRYg2kkV8Lm7Wke5xGr4i2Svkbxq5GtZx9mMWPTLa4n3cvsokmc3u
 9C06byaEukTLaaSRxjwYzAo/tPKu2pL3/Oyx5eSqdhbGRd9bphUMbJyKym6EEGFaOcnerLxnRJ
 ec3+Er6A//tQGFqHhoEQlrQfK/tdA1+yh5YQqbcH/rZrGDydCZs3fZ2CEDPXVDcBQ+ruTEGII7
 LPV4KTrY9MKmDSaLfiaAsS4JgelIvoG6sos1kLdgTc+sl5qP4Jcuc6nJ7Mjr7WoWjg0zMhCHuw
 R4s=
X-IronPort-AV: E=Sophos;i="5.69,353,1571673600"; 
   d="scan'208";a="227751809"
Received: from mail-dm6nam11lp2169.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.169])
  by ob1.hgst.iphmx.com with ESMTP; 25 Dec 2019 11:00:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NoQDgCbioUfVKGEsVI9MXndbY7L0dW+JcFKMjrqXhVmVEPZ5m0B7dfGuAtZSfhaayViM1Wrhyhfn7r5ktLlyND4JblskVdqwkXQpC15G2YwAmvglooKnjvb79OnR/xdl3Bs2whFLSu6prMlcmV2cMkh6qgLf5dWMnEJyhSWoHfjY3MhUL9I5eZfKu6yCkWWTkZFRERp2H6xJBrDgADZdrxZhYU7BV2sxEBDMutet1dIZYPPyy8RP5Sk8Idi9Bw5dnWQD0uFPHZ3OGCFQhNZ/KlVchHIhxnHdgXJwURj6TK71sYrhssDmBHxBfgjbY3DO6liSEw9+oVshEquK59XUsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QtRrVZcguk/w81Ouv/LVIlRAFQD0WcN63iWf9vW9Zo=;
 b=WEL/kw0nTdTqVZVowG6WoseK8HYmRJmm9JOKPt1E6D99LnxWKtfzNUfArnBiZ6iuxUJyyWv7+OWpF14tvSch2uBxGjVgJGFay/CHTI8oad1RFkDoPYADhWOEiWVt1kJWPz/q0RtcODV2rAyWLgNY6JVfhzNqxEtn5IN1KvOT/14SOI9Ei8yM/c8AYCt8s2y4Dxn6k8aSsehvQkiINfgFoD/mx9nlYj2WhCN2E5bwMCvtnQIq/LChfd8E+krS/pwzcgQFiPIrVvqapnTduaOND+htfJNgl3Aetde+KKk1wXUMTc0moRFQhmze6yNw6vjP4i+pY5/CRmzrs7o0cWWhzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1QtRrVZcguk/w81Ouv/LVIlRAFQD0WcN63iWf9vW9Zo=;
 b=G3026v8SFt1Ri3Aw3qckt+6SttVmKRbySbteitWYtfr698hoNbvPOCUiEFyjjcOE5oXhN7NRYjIgBbkpeO095ovAcfOI9rHqWirgoLyk6/rW6WKwa5R2GSybAezfvzqj1zxv/pcrwAuED2viKEAG/Iu7B+4yTrMLg2EXNJWo7UE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5597.namprd04.prod.outlook.com (20.179.22.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.11; Wed, 25 Dec 2019 03:00:31 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Wed, 25 Dec 2019
 03:00:31 +0000
Received: from wdc.com (106.51.19.73) by MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Wed, 25 Dec 2019 03:00:29 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH 5/8] riscv: Add PLIC device emulation
Thread-Topic: [kvmtool RFC PATCH 5/8] riscv: Add PLIC device emulation
Thread-Index: AQHVus94YrC0lLHbe0yijyK7/5iGxw==
Date:   Wed, 25 Dec 2019 03:00:31 +0000
Message-ID: <20191225025945.108466-6-anup.patel@wdc.com>
References: <20191225025945.108466-1-anup.patel@wdc.com>
In-Reply-To: <20191225025945.108466-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0084.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::26) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.19.73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e4b671c8-1b20-4c67-1530-08d788e69ab4
x-ms-traffictypediagnostic: MN2PR04MB5597:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB5597A9F3087DCEB6F7E3DA0F8D280@MN2PR04MB5597.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02622CEF0A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(199004)(189003)(5660300002)(86362001)(2906002)(4326008)(54906003)(81156014)(81166006)(66946007)(8676002)(1076003)(6916009)(8886007)(71200400001)(44832011)(6666004)(66556008)(64756008)(1006002)(66446008)(52116002)(66476007)(55236004)(7696005)(16526019)(186003)(316002)(26005)(55016002)(956004)(2616005)(36756003)(478600001)(30864003)(8936002)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5597;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MZx2TfkU45wN2KIwTES949QN9j5GUw2ZfDLU276lZQez1UqL0x4u4PNozXDbThGqjVIIRZ2XqISXJRkjBEz0QRDJZduVOEMqMjc1zTX1kWYCRR4E5nKFubIoFmjmhLe9N4rTMiXEkNV/sohlD9l7A0eIskYdtNaAKFVUCOvJLmJG2ne6WKHu4GmCd5Bviybq+wQE41ifJF8NPHb54S2hwQWPEQvZIfEUp5LnF9N4kHDf5siNk0frfrKpDNVDgssVEbG7veK3yc9OoN4/3fgU5eLst5zqJZumePpCC/ZAct9mUol4w865SBY8lr/j8J38GlBt1aLdDoswdWL3CKTKUNUd2whatZ4fK7fiUTZohrxoAbyqPfzqkX0GAX+2kaAbibANwHmYaRXgwhuEqOAnNceZ3qYd6NIqoLJB1aUle09wkULGB8MvaBQs64CVQdm2rqNLsva989uQth/2ITnVgusFDM+lTSzaTv3t4eHl7xvlXzaqGgawYlfNYFbtMvpC
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4b671c8-1b20-4c67-1530-08d788e69ab4
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Dec 2019 03:00:31.7951
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xcupOhQ8OsFzN6fO8FiOK8rJZ8ZYQubRo1wuA6Sn98cbhe5CppaSK0Y/M308D1O11SN8PZn5S2+e1j6XSq3G9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5597
Sender: kvm-owner@vger.kernel.org
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
 riscv/plic.c                 | 508 +++++++++++++++++++++++++++++++++++
 4 files changed, 513 insertions(+), 2 deletions(-)
 create mode 100644 riscv/plic.c

diff --git a/Makefile b/Makefile
index 972fa63..3220ad3 100644
--- a/Makefile
+++ b/Makefile
@@ -200,6 +200,7 @@ ifeq ($(ARCH),riscv)
 	OBJS		+=3D riscv/irq.o
 	OBJS		+=3D riscv/kvm.o
 	OBJS		+=3D riscv/kvm-cpu.o
+	OBJS		+=3D riscv/plic.o
=20
 	ARCH_WANT_LIBFDT :=3D y
 endif
diff --git a/riscv/include/kvm/kvm-arch.h b/riscv/include/kvm/kvm-arch.h
index b3ec2d6..b1af70f 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -70,4 +70,6 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_a=
ddr)
=20
 enum irq_type;
=20
+void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge);
+
 #endif /* KVM__KVM_ARCH_H */
diff --git a/riscv/irq.c b/riscv/irq.c
index 8e605ef..78a582d 100644
--- a/riscv/irq.c
+++ b/riscv/irq.c
@@ -4,10 +4,10 @@
=20
 void kvm__irq_line(struct kvm *kvm, int irq, int level)
 {
-	/* TODO: */
+	plic__irq_trig(kvm, irq, level, false);
 }
=20
 void kvm__irq_trigger(struct kvm *kvm, int irq)
 {
-	/* TODO: */
+	plic__irq_trig(kvm, irq, 1, true);
 }
diff --git a/riscv/plic.c b/riscv/plic.c
new file mode 100644
index 0000000..93bfbc5
--- /dev/null
+++ b/riscv/plic.c
@@ -0,0 +1,508 @@
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
+ * Global interrupt sources are assigned small unsigned integer identifier=
s,
+ * beginning at the value 1.  An interrupt ID of 0 is reserved to mean no
+ * interrupt.  Interrupt identifiers are also used to break ties when two =
or
+ * more interrupt sources have the same assigned priority. Smaller values =
of
+ * interrupt ID take precedence over larger values of interrupt ID.
+ *
+ * While the RISC-V supervisor spec doesn't define the maximum number of
+ * devices supported by the PLIC, the largest number supported by devices
+ * marked as 'riscv,plic0' (which is the only device type this driver supp=
orts,
+ * and is the only extant PLIC as of now) is 1024.  As mentioned above, de=
vice
+ * 0 is defined to be non-existant so this device really only supports 102=
3
+ * devices.
+ */
+
+#define MAX_DEVICES	1024
+#define MAX_CONTEXTS	15872
+
+/*
+ * The PLIC consists of memory-mapped control registers, with a memory map=
 as
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
+ * Each hart context has a vector of interupt enable bits associated with =
it.
+ * There's one bit for each interrupt source.
+ */
+#define ENABLE_BASE		0x2000
+#define ENABLE_PER_HART		0x80
+
+/*
+ * Each hart context has a set of control registers associated with it.  R=
ight
+ * now there's only two: a source priority threshold over which the hart w=
ill
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
+	u8 best_irq_prio =3D 0;
+	u32 i, j, irq, best_irq =3D 0;
+
+	for (i =3D 0; i < s->num_irq_word; i++) {
+		if (!c->irq_pending[i])
+			continue;
+
+		for (j =3D 0; j < 32; j++) {
+			irq =3D i * 32 + j;
+			if ((s->num_irq <=3D irq) ||
+			    !(c->irq_pending[i] & (1 << j)) ||
+			    (c->irq_claimed[i] & (1 << j)))
+				continue;
+
+			if (!best_irq ||
+			    (best_irq_prio < c->irq_pending_priority[irq])) {
+				best_irq =3D irq;
+				best_irq_prio =3D c->irq_pending_priority[irq];
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
+	u32 best_irq =3D __plic_context_best_pending_irq(s, c);
+	u32 virq =3D (best_irq) ? KVM_INTERRUPT_SET : KVM_INTERRUPT_UNSET;
+
+	if (ioctl(c->vcpu->vcpu_fd, KVM_INTERRUPT, &virq) < 0)
+		pr_warning("KVM_INTERRUPT failed");
+}
+
+/* Note: Must be called with c->irq_lock held */
+static u32 __plic_context_irq_claim(struct plic_state *s,
+				    struct plic_context *c)
+{
+	u32 virq =3D KVM_INTERRUPT_UNSET;
+	u32 best_irq =3D __plic_context_best_pending_irq(s, c);
+	u32 best_irq_word =3D best_irq / 32;
+	u32 best_irq_mask =3D (1 << (best_irq % 32));
+
+	if (ioctl(c->vcpu->vcpu_fd, KVM_INTERRUPT, &virq) < 0)
+		pr_warning("KVM_INTERRUPT failed");
+
+	if (best_irq) {
+		if (c->irq_autoclear[best_irq_word] & best_irq_mask) {
+			c->irq_pending[best_irq_word] &=3D ~best_irq_mask;
+			c->irq_pending_priority[best_irq] =3D 0;
+			c->irq_claimed[best_irq_word] &=3D ~best_irq_mask;
+			c->irq_autoclear[best_irq_word] &=3D ~best_irq_mask;
+		} else
+			c->irq_claimed[best_irq_word] |=3D best_irq_mask;
+	}
+
+	__plic_context_irq_update(s, c);
+
+	return best_irq;
+}
+
+void plic__irq_trig(struct kvm *kvm, int irq, int level, bool edge)
+{
+	bool irq_marked =3D false;
+	u8 i, irq_prio, irq_word;
+	u32 irq_mask;
+	struct plic_context *c =3D NULL;
+	struct plic_state *s =3D &plic;
+
+	if (!s->ready)
+		return;
+
+	if (irq <=3D 0 || s->num_irq <=3D (u32)irq)
+		goto done;
+
+	mutex_lock(&s->irq_lock);
+
+	irq_prio =3D s->irq_priority[irq];
+	irq_word =3D irq / 32;
+	irq_mask =3D 1 << (irq % 32);
+
+	if (level)
+		s->irq_level[irq_word] |=3D irq_mask;
+	else
+		s->irq_level[irq_word] &=3D ~irq_mask;
+
+	/*
+	 * Note: PLIC interrupts are level-triggered. As of now,
+	 * there is no notion of edge-triggered interrupts. To
+	 * handle this we auto-clear edge-triggered interrupts
+	 * when PLIC context CLAIM register is read.
+	 */
+	for (i =3D 0; i < s->num_context; i++) {
+		c =3D &s->contexts[i];
+
+		mutex_lock(&c->irq_lock);
+		if (c->irq_enable[irq_word] & irq_mask) {
+			if (level) {
+				c->irq_pending[irq_word] |=3D irq_mask;
+				c->irq_pending_priority[irq] =3D irq_prio;
+				if (edge)
+					c->irq_autoclear[irq_word] |=3D irq_mask;
+			} else {
+				c->irq_pending[irq_word] &=3D ~irq_mask;
+				c->irq_pending_priority[irq] =3D 0;
+				c->irq_claimed[irq_word] &=3D ~irq_mask;
+				c->irq_autoclear[irq_word] &=3D ~irq_mask;
+			}
+			__plic_context_irq_update(s, c);
+			irq_marked =3D true;
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
+	u32 irq =3D (offset >> 2);
+
+	if (irq =3D=3D 0 || irq >=3D s->num_irq)
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
+	u32 val, irq =3D (offset >> 2);
+
+	if (irq =3D=3D 0 || irq >=3D s->num_irq)
+		return;
+
+	mutex_lock(&s->irq_lock);
+	val =3D ioport__read32(data);
+	val &=3D ((1 << PRIORITY_PER_ID) - 1);
+	s->irq_priority[irq] =3D val;
+	mutex_unlock(&s->irq_lock);
+}
+
+static void plic__context_enable_read(struct plic_state *s,
+				      struct plic_context *c,
+				      u64 offset, void *data)
+{
+	u32 irq_word =3D offset >> 2;
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
+	u32 irq_word =3D offset >> 2;
+	u32 old_val, new_val, xor_val;
+
+	if (s->num_irq_word < irq_word)
+		return;
+
+	mutex_lock(&s->irq_lock);
+
+	mutex_lock(&c->irq_lock);
+
+	old_val =3D c->irq_enable[irq_word];
+	new_val =3D ioport__read32(data);
+
+	if (irq_word =3D=3D 0)
+		new_val &=3D ~0x1;
+
+	c->irq_enable[irq_word] =3D new_val;
+
+	xor_val =3D old_val ^ new_val;
+	for (i =3D 0; i < 32; i++) {
+		irq =3D irq_word * 32 + i;
+		irq_mask =3D 1 << i;
+		irq_prio =3D s->irq_priority[irq];
+		if (!(xor_val & irq_mask))
+			continue;
+		if ((new_val & irq_mask) &&
+		    (s->irq_level[irq_word] & irq_mask)) {
+			c->irq_pending[irq_word] |=3D irq_mask;
+			c->irq_pending_priority[irq] =3D irq_prio;
+		} else if (!(new_val & irq_mask)) {
+			c->irq_pending[irq_word] &=3D ~irq_mask;
+			c->irq_pending_priority[irq] =3D 0;
+			c->irq_claimed[irq_word] &=3D ~irq_mask;
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
+	bool irq_update =3D false;
+
+	mutex_lock(&c->irq_lock);
+
+	switch (offset) {
+	case CONTEXT_THRESHOLD:
+		val =3D ioport__read32(data);
+		val &=3D ((1 << PRIORITY_PER_ID) - 1);
+		if (val <=3D s->max_prio)
+			c->irq_priority_threshold =3D val;
+		else
+			irq_update =3D true;
+		break;
+	case CONTEXT_CLAIM:
+		break;
+	default:
+		irq_update =3D true;
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
+	struct plic_state *s =3D ptr;
+
+	if (len !=3D 4)
+		die("plic: invalid len=3D%d", len);
+
+	addr &=3D ~0x3;
+	addr -=3D RISCV_PLIC;
+
+	if (is_write) {
+		if (PRIORITY_BASE <=3D addr && addr < ENABLE_BASE) {
+			plic__priority_write(s, addr, data);
+		} else if (ENABLE_BASE <=3D addr && addr < CONTEXT_BASE) {
+			cntx =3D (addr - ENABLE_BASE) / ENABLE_PER_HART;
+			addr -=3D cntx * ENABLE_PER_HART + ENABLE_BASE;
+			if (cntx < s->num_context)
+				plic__context_enable_write(s,
+							   &s->contexts[cntx],
+							   addr, data);
+		} else if (CONTEXT_BASE <=3D addr && addr < REG_SIZE) {
+			cntx =3D (addr - CONTEXT_BASE) / CONTEXT_PER_HART;
+			addr -=3D cntx * CONTEXT_PER_HART + CONTEXT_BASE;
+			if (cntx < s->num_context)
+				plic__context_write(s, &s->contexts[cntx],
+						    addr, data);
+		}
+	} else {
+		if (PRIORITY_BASE <=3D addr && addr < ENABLE_BASE) {
+			plic__priority_read(s, addr, data);
+		} else if (ENABLE_BASE <=3D addr && addr < CONTEXT_BASE) {
+			cntx =3D (addr - ENABLE_BASE) / ENABLE_PER_HART;
+			addr -=3D cntx * ENABLE_PER_HART + ENABLE_BASE;
+			if (cntx < s->num_context)
+				plic__context_enable_read(s,
+							  &s->contexts[cntx],
+							  addr, data);
+		} else if (CONTEXT_BASE <=3D addr && addr < REG_SIZE) {
+			cntx =3D (addr - CONTEXT_BASE) / CONTEXT_PER_HART;
+			addr -=3D cntx * CONTEXT_PER_HART + CONTEXT_BASE;
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
+	struct plic_context *c;
+
+	plic.kvm =3D kvm;
+	plic.dev_hdr =3D (struct device_header) {
+		.bus_type	=3D DEVICE_BUS_MMIO,
+	};
+
+	plic.num_irq =3D MAX_DEVICES;
+	plic.num_irq_word =3D plic.num_irq / 32;
+	if ((plic.num_irq_word * 32) < plic.num_irq)
+		plic.num_irq_word++;
+	plic.max_prio =3D (1UL << PRIORITY_PER_ID) - 1;
+
+	plic.num_context =3D kvm->nrcpus * 2;
+	plic.contexts =3D calloc(plic.num_context, sizeof(struct plic_context));
+	if (!plic.contexts)
+		return -ENOMEM;
+	for (i =3D 0; i < plic.num_context; i++) {
+		c =3D &plic.contexts[i];
+		c->s =3D &plic;
+		c->num =3D i;
+		c->vcpu =3D kvm->cpus[i / 2];
+		mutex_init(&c->irq_lock);
+	}
+
+	mutex_init(&plic.irq_lock);
+
+	kvm__register_mmio(kvm, RISCV_PLIC, RISCV_PLIC_SIZE,
+			   false, plic__mmio_callback, &plic);
+
+	device__register(&plic.dev_hdr);
+
+	plic.ready =3D true;
+
+	return 0;
+
+}
+dev_init(plic__init);
+
+static int plic__exit(struct kvm *kvm)
+{
+	plic.ready =3D false;
+	kvm__deregister_mmio(kvm, RISCV_PLIC);
+	free(plic.contexts);
+
+	return 0;
+}
+dev_exit(plic__exit);
--=20
2.17.1

