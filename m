Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28FDB81DB4
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730916AbfHENoI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:44:08 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50790 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730843AbfHENoH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:44:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565012646; x=1596548646;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rYqdqmbhyParRf1rxKTJipYcEMdVmlpMM4qaFK3AdsI=;
  b=LxpaNQgU6ppQmDGd2hO2cEHuICL0XnfQcLozT9QHVGUbm7uVavMbqles
   zDVFu+pI5W/p5Ngu+XJW2p0/TdVuJEmlBIApMJjU24kLH98q5K9IHunC0
   ftAiPj/S+ETuEpw2HLfrZwFHJPFbEXfV0cvwgGeaAXAPfkQOw8moe3myP
   dQ7hMLriR6EzYpZI52p6Sm0gcYbcpcOS+HQFPqFLqprfULDq0tcF18q1U
   /fpVszbK3MFin1IhKPbfuP7mysiRv8djQy0Ytd38+wNzazfW+k5EKPsgh
   0eKoG8EHqOkzG0j1hQKi8jGQ7NvZDAEb5UOtKGokqjmLKYdIN/8yBgDQJ
   A==;
IronPort-SDR: Syh3bpPmL0PYE8CJo5fZub0erLrUrtPmJ1dRSte0S4RFS1Yl6wjvjlzEaUrwATLkiQW9g+wYSz
 6HFEjzX/HZVY+iKQy/co6+39xliC8X1fYHf0QVgpb3wt28n09QLJKBC5bMhp9PmRtyH1H8DTLp
 41Um92pP8Wus/oFevtSy6ANtTS3hOkaflvYYB6vw4xz8uuDMAcmZne1pShqCpEfyUfdKdK+KIy
 t437EFA4+Bg2holJEXODL64y6PsfmXAyLJDAWa9+bzlCH54csidei7Lsl79+yCWMZoaJYUoCoh
 MWY=
X-IronPort-AV: E=Sophos;i="5.64,350,1559491200"; 
   d="scan'208";a="221493506"
Received: from mail-sn1nam01lp2054.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.54])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2019 21:44:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6hE68Su/nLiRyNygRrZgtsyb4f/HvWYsRH9Fo/LE02V8UikownFDggKDOZSOclOKCzGzt7DBxNEa9bUrgvbFOpmv5n8eAeSpvWKhmdtD/vg2OUccjiTbJArYVBWQtIzYdwN9DCHVcu9yCFf6UTf4Ev4Tk79qek0DniZKVgIo6c/ueOPpLDpF2UXwVBHr7TOfaJNVl484x9vh5hZrkXmkGbIHtMLgHwmk7dI09xCanRY7sr8PyaqcvMr2Uzgg9MhH3whuWjT5KDQji4XGW0Cu2TXwRBDJovEiGfyMtnnExurszERzMm/JM28mec77S6ym600rI7rnSXvl6osOcePmg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SncVMPGIQmheGw4JwKgUVwVW86o02vHhw8i+MhdGPeM=;
 b=oABtqWLIT3ZBXvUv2S+OFncGj7LCXpX+TxPAUybExP2okL4X77Xb5CNNMxxOPlAEG+A8ZU3z9D9DUhxCml1JLq8tI6r9xlZfCjZOPMnJBWvUjXS465mzkcAEqg//HM5fr0NOIj35X8CZWxo3mZNYON/+Hipby2Bwz34NhUdxsm99OT4aHrbQpiNTLTlWFMvfhjcYsR5W3HLiCJwNT57Y76Sm3GATxVOS/QD8OeDBmYOaJ+oDTe62m8RZDdVzJoOAfCMtFqqK1sL/tsEaAVbE6iP8fqy5X0fnMKFLVKjuya5T8FKWBLumlr9yKXsTJE2hD+Hkpy0RIiAxyMrZm6Cb1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SncVMPGIQmheGw4JwKgUVwVW86o02vHhw8i+MhdGPeM=;
 b=xyqTGLQpGW+fs1pGTpPBLMr24g9mWICDb2WoG6f4FV4Xo3YpJ1sVUNHAIJnJcXtwBN2uZ3mAaX9Q+fjQYfmY+yYtBYse4pz9lmUlTnxbEIk0Aks44DnGJs+gZuQODV5JBUdXSthqeWH/2XAxN/g9k+ipBb53Rw3s2Oe8n8o8Tnc=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6159.namprd04.prod.outlook.com (20.178.249.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Mon, 5 Aug 2019 13:44:04 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 13:44:04 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v3 14/19] RISC-V: KVM: Add timer functionality
Thread-Topic: [PATCH v3 14/19] RISC-V: KVM: Add timer functionality
Thread-Index: AQHVS5PYt0OBGR24YU2ojAYLq9YdDg==
Date:   Mon, 5 Aug 2019 13:44:03 +0000
Message-ID: <20190805134201.2814-15-anup.patel@wdc.com>
References: <20190805134201.2814-1-anup.patel@wdc.com>
In-Reply-To: <20190805134201.2814-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0087.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:54::27) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d90169f-0b3c-4a4a-b431-08d719aafaa9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6159;
x-ms-traffictypediagnostic: MN2PR04MB6159:
x-microsoft-antispam-prvs: <MN2PR04MB6159C0DB49F9D7D05C08C8398DDA0@MN2PR04MB6159.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(66556008)(66476007)(71190400001)(71200400001)(110136005)(54906003)(66946007)(66446008)(64756008)(86362001)(5660300002)(102836004)(52116002)(55236004)(14454004)(99286004)(386003)(78486014)(316002)(256004)(14444005)(6506007)(76176011)(2616005)(6486002)(8676002)(9456002)(8936002)(36756003)(3846002)(6116002)(6512007)(4326008)(2906002)(476003)(305945005)(44832011)(81156014)(81166006)(26005)(186003)(486006)(11346002)(25786009)(7736002)(1076003)(50226002)(478600001)(68736007)(446003)(53936002)(66066001)(6436002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6159;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lpe/tlR4zLLrWZtOP4On+SsmwoowYSzFm2upy2meXS0eczk1rMAvdkk8gDOF2WygTwU10dhC7xJY7vfXGgf4dGBTSiDlkRg8epCLuQoH21YGtHi5Rev5zGpgY43yQ8m/5U2/9HT6gDlVrZ/GciF+RWL+M3GuQsyH5isjqXuc7dbCTDfJPJnDKIXJih5hAjq8fsuha6qvE5ztZwcmHlcNw/3U4kdAoQrZgYOfkBszYoqum9xdNaC6LUhbxi4X0KE88wkFzlUjG/0idn2Lw7eeV4FBCPs8omxJjrlCT50bNw6kopGYB/q8PxZ09EX2wJJlLqHNu2nrMdvZMs4/Bfke3A81kRwvCH0rz7nDrsQR3cGeDiAABIRQC4uGEEEqUQnI7gomnhMc7DOM4Tow9ik+v8xeAMqhqsZYme1N5BamGUE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d90169f-0b3c-4a4a-b431-08d719aafaa9
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 13:44:03.9543
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6159
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The RISC-V hypervisor specification doesn't have any virtual timer
feature.

Due to this, the guest VCPU timer will be programmed via SBI calls.
The host will use a separate hrtimer event for each guest VCPU to
provide timer functionality. We inject a virtual timer interrupt to
the guest VCPU whenever the guest VCPU hrtimer event expires.

The following features are not supported yet and will be added in
future:
1. A time offset to adjust guest time from host time
2. A saved next event in guest vcpu for vm migration

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h       |   4 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  32 +++++++
 arch/riscv/kvm/Makefile                 |   2 +-
 arch/riscv/kvm/vcpu.c                   |   6 ++
 arch/riscv/kvm/vcpu_timer.c             | 106 ++++++++++++++++++++++++
 drivers/clocksource/timer-riscv.c       |   8 ++
 include/clocksource/timer-riscv.h       |  16 ++++
 7 files changed, 173 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 include/clocksource/timer-riscv.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index d6ee69023a83..cd43618461fd 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -12,6 +12,7 @@
 #include <linux/types.h>
 #include <linux/kvm.h>
 #include <linux/kvm_types.h>
+#include <asm/kvm_vcpu_timer.h>
=20
 #ifdef CONFIG_64BIT
 #define KVM_MAX_VCPUS			(1U << 16)
@@ -167,6 +168,9 @@ struct kvm_vcpu_arch {
 	unsigned long irqs_pending;
 	unsigned long irqs_pending_mask;
=20
+	/* VCPU Timer */
+	struct kvm_vcpu_timer timer;
+
 	/* MMIO instruction details */
 	struct kvm_mmio_decode mmio_decode;
=20
diff --git a/arch/riscv/include/asm/kvm_vcpu_timer.h b/arch/riscv/include/a=
sm/kvm_vcpu_timer.h
new file mode 100644
index 000000000000..df67ea86988e
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -0,0 +1,32 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __KVM_VCPU_RISCV_TIMER_H
+#define __KVM_VCPU_RISCV_TIMER_H
+
+#include <linux/hrtimer.h>
+
+#define VCPU_TIMER_PROGRAM_THRESHOLD_NS		1000
+
+struct kvm_vcpu_timer {
+	bool init_done;
+	/* Check if the timer is programmed */
+	bool is_set;
+	struct hrtimer hrt;
+	/* Mult & Shift values to get nanosec from cycles */
+	u32 mult;
+	u32 shift;
+};
+
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
+				    unsigned long ncycles);
+
+#endif
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index c0f57f26c13d..3e0c7558320d 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,6 +9,6 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs :=3D $(common-objs-y)
=20
 kvm-objs +=3D main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o
+kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
=20
 obj-$(CONFIG_KVM)	+=3D kvm.o
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 1cba8d3af63a..b78ac2aecca2 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -53,6 +53,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
=20
+	kvm_riscv_vcpu_timer_reset(vcpu);
+
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
@@ -107,6 +109,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	cntx->hstatus |=3D HSTATUS_SP2P;
 	cntx->hstatus |=3D HSTATUS_SPV;
=20
+	/* Setup VCPU timer */
+	kvm_riscv_vcpu_timer_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
=20
@@ -115,6 +120,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
=20
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_timer_deinit(vcpu);
 	kvm_riscv_stage2_flush_cache(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
new file mode 100644
index 000000000000..a45ca06e1aa6
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -0,0 +1,106 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <clocksource/timer-riscv.h>
+#include <asm/csr.h>
+#include <asm/kvm_vcpu_timer.h>
+
+static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer =
*h)
+{
+	struct kvm_vcpu_timer *t =3D container_of(h, struct kvm_vcpu_timer, hrt);
+	struct kvm_vcpu *vcpu =3D container_of(t, struct kvm_vcpu, arch.timer);
+
+	t->is_set =3D false;
+	kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_TIMER);
+
+	return HRTIMER_NORESTART;
+}
+
+static u64 kvm_riscv_delta_cycles2ns(u64 cycles, struct kvm_vcpu_timer *t)
+{
+	unsigned long flags;
+	u64 cycles_now, cycles_delta, delta_ns;
+
+	local_irq_save(flags);
+	cycles_now =3D get_cycles64();
+	if (cycles_now < cycles)
+		cycles_delta =3D cycles - cycles_now;
+	else
+		cycles_delta =3D 0;
+	delta_ns =3D (cycles_delta * t->mult) >> t->shift;
+	local_irq_restore(flags);
+
+	return delta_ns;
+}
+
+static int kvm_riscv_vcpu_timer_cancel(struct kvm_vcpu_timer *t)
+{
+	if (!t->init_done || !t->is_set)
+		return -EINVAL;
+
+	hrtimer_cancel(&t->hrt);
+	t->is_set =3D false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu,
+				    unsigned long ncycles)
+{
+	struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
+	u64 delta_ns =3D kvm_riscv_delta_cycles2ns(ncycles, t);
+
+	if (!t->init_done)
+		return -EINVAL;
+
+	kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_TIMER);
+
+	if (delta_ns > VCPU_TIMER_PROGRAM_THRESHOLD_NS) {
+		hrtimer_start(&t->hrt, ktime_add_ns(ktime_get(), delta_ns),
+				HRTIMER_MODE_ABS);
+		t->is_set =3D true;
+	} else
+		kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_TIMER);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
+
+	if (t->init_done)
+		return -EINVAL;
+
+	hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_ABS);
+	t->hrt.function =3D kvm_riscv_vcpu_hrtimer_expired;
+	t->init_done =3D true;
+	t->is_set =3D false;
+
+	riscv_cs_get_mult_shift(&t->mult, &t->shift);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu)
+{
+	int ret;
+
+	ret =3D kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+	vcpu->arch.timer.init_done =3D false;
+
+	return ret;
+}
+
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu)
+{
+	return kvm_riscv_vcpu_timer_cancel(&vcpu->arch.timer);
+}
diff --git a/drivers/clocksource/timer-riscv.c b/drivers/clocksource/timer-=
riscv.c
index 09e031176bc6..7c595203aa5c 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -8,6 +8,7 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
+#include <linux/module.h>
 #include <linux/sched_clock.h>
 #include <asm/smp.h>
 #include <asm/sbi.h>
@@ -80,6 +81,13 @@ static int riscv_timer_dying_cpu(unsigned int cpu)
 	return 0;
 }
=20
+void riscv_cs_get_mult_shift(u32 *mult, u32 *shift)
+{
+	*mult =3D riscv_clocksource.mult;
+	*shift =3D riscv_clocksource.shift;
+}
+EXPORT_SYMBOL_GPL(riscv_cs_get_mult_shift);
+
 /* called directly from the low-level interrupt handler */
 void riscv_timer_interrupt(void)
 {
diff --git a/include/clocksource/timer-riscv.h b/include/clocksource/timer-=
riscv.h
new file mode 100644
index 000000000000..e94e4feecbe8
--- /dev/null
+++ b/include/clocksource/timer-riscv.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/*
+ * Copyright (C) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *	Atish Patra <atish.patra@wdc.com>
+ */
+
+#ifndef __TIMER_RISCV_H
+#define __TIMER_RISCV_H
+
+#include <linux/types.h>
+
+void riscv_cs_get_mult_shift(u32 *mult, u32 *shift);
+
+#endif
--=20
2.17.1

