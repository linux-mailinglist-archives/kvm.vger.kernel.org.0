Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE63714A401
	for <lists+kvm@lfdr.de>; Mon, 27 Jan 2020 13:36:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730628AbgA0MgX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Jan 2020 07:36:23 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:45051 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730592AbgA0MgX (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Jan 2020 07:36:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1580128583; x=1611664583;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=mXQm9fHlPzQPfc3v6Ou/kSJDyTBK0xjM3+G8gk0FyU8=;
  b=QXv205LUa58eYOXi461kAL4qY4U3Bb1UFtU9g+8Ra1FUqu/GL5d5hH/p
   zprLHtfFqo/dK8VDLWw7NbNrOBpvgQjoa+RGAooSM2rB/oXbjYatNjAc4
   dtO7LwyhFmqCNeJDFXhMbXJrURH/wZoYdbGtRfBZSwNU4To5/8cVGjmMX
   Z8wAxjO9YSGzelFahNoWzF/+4frIjaGIkoND5xZScd7eEd+wceFFdkV1l
   stGL8P8lVa2L3qfXx2HN0T26uERmyGg6WV0UWS5bABYYyDqlX2Oib6sJi
   dxDO3qUU2clm6x1SVEuKscEIUd4SqmtlWOrXiggziedosf24jHmDMYv9H
   g==;
IronPort-SDR: orMtFF0tCEWkuWBNO+GpD5o8jZfPl1yQNjYUJxBCJmq1hcWTWOI11yT+dPIgVCxJAo3ccxrL+I
 g3r6VoYAbyE1DxvXoBXroy8S2GufIUSci1OINJIR73AAevOI8ML4Z4EmBv/7Bh3527R7O+kJv/
 4wpMJMc3YuPwYJzo8bBvOgq5fTzmiufbNPmWbm/iFYnGpFxXelRBl9lcXUPSVXSTox30yXC2cR
 DHeW5glN6p+4XQrxMF4jl0TdeZ8iTaxhF8rIV/+YhZACCP1RRfsF4Ls0dAMgSgZlaY5ebFJQzG
 bng=
X-IronPort-AV: E=Sophos;i="5.70,369,1574092800"; 
   d="scan'208";a="129052175"
Received: from mail-mw2nam10lp2105.outbound.protection.outlook.com (HELO NAM10-MW2-obe.outbound.protection.outlook.com) ([104.47.55.105])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2020 20:36:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DpJP7VtQhqPlPNvezyUXbHq7eYxuKxy0oZuHSBX2iUvcJJzi71EPdq9M6/baPyDKKXhig5hehzh/TQ7I5LoknJIbbls9b/2L9QKSrZ4eXubG7TyX7FNVzbWEWUDw7KwrrnAFWlBzXe9NAYApV9paNQQneHsvpoa1IGuNVJ+QauV1kTyKhXsIB8+usL6OroVPxZwPQjo4eqCzcLE8Xq8WqGKjm+Bfydun7bGlrReQteF6KOjLVUTCWF8apeHzIdj9shWa7NRZGh7zk+wpq0mfl1+7qAVJAdAJTM7uHMU0eNlzVakCuBKGi2nPVkQiHQavgZaXrgK4lElQK2QtEZcI7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffemmaPVOVQWjIjsun6JbRQFCSHmPX7mFYYYa++F8ho=;
 b=Pn0jKOGfUNcd/yIUJbRCILQPDo/y46BVh0nHFaYfg41Q096xCU7ayxQxA5pOktGdrzQt6wye41tPOGkpMbLdzShZro2MyIdBuvTP/rtR0d2tU1WHXno/HTx/aGR1G4uVUjUNddFiEo1qlYxS7ajuLs9tH203ZEccythifTia0xgQWFGSm6W/oW2IsMKColmlzLGzEMsUoZK/v5NSGdBXjam2AAGbFfxZLA0a78gyb0gimYaI0UZetTeZ0rVviEZ/MYHIfw0RYDpDnQuoFZYueRkTNpXimjNgImRGu50RwbogjqWUdLx3ohHdMF+D9bQXocIw/CA95LCMlCW6JuIpSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ffemmaPVOVQWjIjsun6JbRQFCSHmPX7mFYYYa++F8ho=;
 b=uGkk2bDOPSqJlSOckq0UUBT1ANk4GJkdBjunotC6/nB83V63fcVWrHmi51VYyLoiDQR/0HlSvUY8wDidrZzX0d1zuplea7ICDxO/RDH2i9R+HTXSEI/fioQPNDgcb55e5weCTayqfu22sCkazKYo5Jp7zglgamo1B9t6C41/nv4=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6816.namprd04.prod.outlook.com (10.186.145.79) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.22; Mon, 27 Jan 2020 12:36:20 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2665.017; Mon, 27 Jan 2020
 12:36:19 +0000
Received: from wdc.com (49.207.48.168) by MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Mon, 27 Jan 2020 12:36:16 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Will Deacon <will.deacon@arm.com>
CC:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [kvmtool RFC PATCH v2 5/8] riscv: Add PLIC device emulation
Thread-Topic: [kvmtool RFC PATCH v2 5/8] riscv: Add PLIC device emulation
Thread-Index: AQHV1Q5g9SYVZEpdG02tbZzC3ZhFJA==
Date:   Mon, 27 Jan 2020 12:36:19 +0000
Message-ID: <20200127123527.106825-6-anup.patel@wdc.com>
References: <20200127123527.106825-1-anup.patel@wdc.com>
In-Reply-To: <20200127123527.106825-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0095.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::11) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.48.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a51e55cf-286e-439b-5891-08d7a325826c
x-ms-traffictypediagnostic: MN2PR04MB6816:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB681672397006B08A7A7320A28D0B0@MN2PR04MB6816.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02951C14DC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(39860400002)(396003)(366004)(346002)(376002)(189003)(199004)(44832011)(5660300002)(2906002)(55236004)(54906003)(86362001)(7696005)(4326008)(55016002)(478600001)(2616005)(81156014)(956004)(8676002)(52116002)(81166006)(1076003)(8886007)(8936002)(71200400001)(66946007)(26005)(1006002)(66476007)(6916009)(66556008)(30864003)(64756008)(16526019)(316002)(66446008)(36756003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6816;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QZZhX9s+7v2fklnh3n2NVn5HrtMchTSmWv6tCN0LxHpiVpZb2FhbhgH78aCAB3FI9nS5/1QenDcgD6TLBv7Fdy/vY6izhgq3KFTwYZVZp+3w7MlcUXikVTpc6B4OP5VehCQYqXFiTgQsA3agCixbEWOw85DjLNfzXmPzzHazcoU4R0HOWrIv7yKltpQS4Xuj+l+fUIz9U7P/cO2suYx/zCMMqp3k8HDzCyxRyGvVbLBuMhthIYxkkFH5wqaq9e61scMmC32SPKoKoiFMeH+BHy8lbpJBsoJaa/s7T83bq5lmnddfASRH28+e+d2nQSv0Bi+zmA/CHWFO4Dt93sGdNM+nL/KrCsdK7PdoHOPILQ2LMR3+lnEUi4uK5xI7Ny8ZJo1fII8MoUi2Rr1gR5cgg3RuQpLukIBfI1y8KeHS49zGBEVNrle/ge8AhbbNxYAv
x-ms-exchange-antispam-messagedata: 5kwPAFlKCsR8HdPuUbhBnRdbzY2DRyWLpU4Bf22IyWEMi/PeuJBRPOEG5xHrYx0ixf/dWgRWAuOovuCa9KjSB3UsaV/y3dUJQ/crxQiqUIJDadwDFbSMVybf/nDHAjfUD62ckGPsEypu+X50e3mB7Q==
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a51e55cf-286e-439b-5891-08d7a325826c
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2020 12:36:19.6199
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o2d6Mc9FB1qS6X0YlSSaM1rCiBPqHEVG9G7eq45lPUL1dEnwHqlsVD8j3T8ZLCew/hhZrxCxITFgH37mBFMWEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6816
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
index 6f64f55..20e9f09 100644
--- a/riscv/include/kvm/kvm-arch.h
+++ b/riscv/include/kvm/kvm-arch.h
@@ -76,4 +76,6 @@ static inline bool riscv_addr_in_ioport_region(u64 phys_a=
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

