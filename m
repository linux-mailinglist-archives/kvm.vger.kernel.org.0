Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AF8C97C0
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:08:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728531AbfJCFIM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:08:12 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:22556 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728055AbfJCFIM (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:08:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079292; x=1601615292;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lOJAywCHTuOrxDJOG+3ZaH/TCwB411tVPRgTGN6Xj4Y=;
  b=PhxL/L3ptZoX028pJoZmQQffD39P5ouLvrSk6C5J0BjHcolxoDJa19tu
   /nbVBD6/pYEEDw7fw4QsgBm9e+d0jw0JIdFZKrttEWjecKKISbsR8mtgG
   7Bbd9s/ktIm5tBFY5kzQAo8yA7gOKgDt2Lm5gbNwDmX8iqpFpXjguGaXp
   OMEO03LIJf7g5N+O0LROKj/HE90JHc24gp5+A457Y6RiSzmDzojmwP5bJ
   mnx/IIbRtUnMwKkrI1ioFvMFaSgS6RR4cch4+7sEIP6CLrgl/dfCLNUrH
   WIvtYazjx2e6/GlMGT30jh/3HCT2A6oTHx/i86ARoQeUFw4+PIJiAARRl
   g==;
IronPort-SDR: Hq10t2d+V90LaLYoaGZ0cVaEPJv++MWJt0EmkeLyc52Fmx9H9d6B7dfJ189Cx/ohZRySNou3YS
 6nIFM4QaIRyrSibPmjbpOE4vjZ/UKVZ8IBltuLrDalLdl772FXg8IYNqnEJOtcZV/xW4DrJ8J9
 7aiEF85DcDWawB7VncYPMYuQi8SDDwi38AcU3ySr5R+j3QH5u3rtwGaFm/NfopS3L1qwnLaOum
 9w8pm7bHhiZDL9ZLJaLwL8nzwTlGMsyxAi3j5Hb0QnrGS0FlZItyJVpZlCs/+OGChfPtbZqub8
 +5Y=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="121261265"
Received: from mail-co1nam05lp2052.outbound.protection.outlook.com (HELO NAM05-CO1-obe.outbound.protection.outlook.com) ([104.47.48.52])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:08:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z5QkATmwIepfoE57hP4OuxteV0vHTne0Ze6DXOK4/HqTZcWlTqav6t7ozNu5W2hjUFs2FFrHoe+ZT9oxMPoYhgO08LIR+A3ZCCG11HhuoJr4CDE7s9YKVw/9pGeEg2AJLCJo5yK7wP0topPIptEUSzs1rE/6bl+iWA+wKzd05uPxMkhnQd1fy962kzclnTGbmrZ2qFdD/bFG3VPqWjwLwCFQK7Z8TEBbBbjIuJ5uWKnJCrQUiAg6lwe8QefRxhjTSGV9b/pbXa71c86ZEwRHax/81XXdWTtGW+xkCf6lSJ1Gf9pfYl/fEo2Tie0+6hXNEcRgk3ZxFwBOMe6O5A1sRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv0pNyEq0essSb6JkldgDaPmXnUQriI+W5YmGG8s2gA=;
 b=VgdLx0H0475+vN4MLgFOAjvoYgu4Qj4A0U2MJSm88odk+x13tIafUYMkLPwBVwYn6aWezY63bQetFr1pRi3TYyc/cc82SJN9l/MfCo1oWtKFg2wggyXRtbdcvUbVeeDN3H45qndFdVM0zdz1c3IP2T2dxt/V4EFOz0O9js7BGF6RoJnxZCMu6u66mzftHGQMtmloWyStbMkW30OxW/7jCU3+3UuLEAl6E3QpG2JAdACMn+7pwSFY3pxkEIS6X8CUh309QmKOKg7U2ciDQJ08qq8AzcNXO3opouWgLbyITASs7KiQ2z/fO95+cHicnm6uzEMj+ON88mZF6/PlPvziYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uv0pNyEq0essSb6JkldgDaPmXnUQriI+W5YmGG8s2gA=;
 b=DcFBP7opGkG+I10BaghtzQdtr7rtPTpYA7iba6HcVuRz0/sgJOxMdaVnFroFAMaEJLLYGMo7z6cY4AdvFDFa1jM9kmM6aA4Q91DhKw2EJA4gT3pBn7VpcPA/7EXz2z2XEYzH3Gzzt/81X+fTxXGG39wnig8V9pnXyts2oIeha6M=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6272.namprd04.prod.outlook.com (20.178.248.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 3 Oct 2019 05:08:08 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:08:08 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@sifive.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Daniel Lezcano <daniel.lezcano@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@infradead.org>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v8 13/19] RISC-V: KVM: Add timer functionality
Thread-Topic: [PATCH v8 13/19] RISC-V: KVM: Add timer functionality
Thread-Index: AQHVeaiLAuoxqOOF8EGJxcrPYc3oaA==
Date:   Thu, 3 Oct 2019 05:08:08 +0000
Message-ID: <20191003050558.9031-14-anup.patel@wdc.com>
References: <20191003050558.9031-1-anup.patel@wdc.com>
In-Reply-To: <20191003050558.9031-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BMXPR01CA0030.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:b00:c::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [111.235.74.37]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f519fe5b-5afd-4bb3-af69-08d747bfae2a
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6272:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB62725AA1E65DCDED26D5DA3F8D9F0@MN2PR04MB6272.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(376002)(346002)(366004)(396003)(39860400002)(189003)(199004)(6512007)(6486002)(81166006)(81156014)(8936002)(6116002)(3846002)(8676002)(50226002)(2906002)(110136005)(66066001)(6436002)(316002)(66476007)(66556008)(7416002)(66446008)(36756003)(1076003)(5660300002)(54906003)(7736002)(305945005)(76176011)(25786009)(52116002)(256004)(14444005)(71190400001)(86362001)(99286004)(71200400001)(2616005)(446003)(14454004)(476003)(102836004)(186003)(26005)(11346002)(44832011)(6506007)(486006)(478600001)(4326008)(66946007)(386003)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6272;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +PNY7gkXIhjMr99u6xSDEWpysGx9Obda8L7gonjOFiIS5RHdIC4lF5QBcvJRIA28TEXq3fPb1kUQTpewh+JLSJN5lmmoE6xoZGc6nmaat0x3LndpU9j1bFBw2BDrjpLNI/tJ8JT4XFLYrU1xJuBCZO1laMRckNx7oBYknBZW7WBbjvN4RfmLBL0pWLMaClboXRTAXaKuzaG3B1FYZS0osmF3ChVdmUmN90zeeB+TY919WhRxckqGFdz/0V4zq6cG7CWdHw0QFkBucW8xYoASFonxTMoEgaaBVs82sjGyP1C0Yta39xh5YxCGTtTrc8XiFsjQb8EpOGFW+4LrSyNC8gCx2cQu7q4eud9k6hBrrDW8zUp7ZzcIhv0tuI6gZxtfXqcrhYfz4tl0L8JuIglAsGNN+gUwHoD9CtjyYKM4EA0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f519fe5b-5afd-4bb3-af69-08d747bfae2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:08:08.6081
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LlnQXbKDEerEuu1zI1kbNhFfJCuarJrlvfEQjB3ck4wsjtuMuQOWdG2a3k5ip6cpyfpDmVLfHrO0VjLvMwQheQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6272
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
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h       |   4 +
 arch/riscv/include/asm/kvm_vcpu_timer.h |  30 +++++++
 arch/riscv/kvm/Makefile                 |   2 +-
 arch/riscv/kvm/vcpu.c                   |   6 ++
 arch/riscv/kvm/vcpu_timer.c             | 113 ++++++++++++++++++++++++
 drivers/clocksource/timer-riscv.c       |   8 ++
 include/clocksource/timer-riscv.h       |  16 ++++
 7 files changed, 178 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 include/clocksource/timer-riscv.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 79ceb2aa8ae6..9179ff019235 100644
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
@@ -168,6 +169,9 @@ struct kvm_vcpu_arch {
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
index 000000000000..6f904d49e27e
--- /dev/null
+++ b/arch/riscv/include/asm/kvm_vcpu_timer.h
@@ -0,0 +1,30 @@
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
+struct kvm_vcpu_timer {
+	bool init_done;
+	/* Check if the timer is programmed */
+	bool next_set;
+	u64 next_cycles;
+	struct hrtimer hrt;
+	/* Mult & Shift values to get nanosec from cycles */
+	u32 mult;
+	u32 shift;
+};
+
+int kvm_riscv_vcpu_timer_init(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_deinit(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_reset(struct kvm_vcpu *vcpu);
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles);
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
index 12bd837f564a..2ca913f00570 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -54,6 +54,8 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
=20
+	kvm_riscv_vcpu_timer_reset(vcpu);
+
 	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
 	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
@@ -108,6 +110,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	cntx->hstatus |=3D HSTATUS_SP2P;
 	cntx->hstatus |=3D HSTATUS_SPV;
=20
+	/* Setup VCPU timer */
+	kvm_riscv_vcpu_timer_init(vcpu);
+
 	/* Reset VCPU */
 	kvm_riscv_reset_vcpu(vcpu);
=20
@@ -116,6 +121,7 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
=20
 void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 {
+	kvm_riscv_vcpu_timer_deinit(vcpu);
 	kvm_riscv_stage2_flush_cache(vcpu);
 	kmem_cache_free(kvm_vcpu_cache, vcpu);
 }
diff --git a/arch/riscv/kvm/vcpu_timer.c b/arch/riscv/kvm/vcpu_timer.c
new file mode 100644
index 000000000000..9ffdd6ff8d6e
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -0,0 +1,113 @@
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
+#define VCPU_TIMER_PROGRAM_THRESHOLD_NS		1000
+
+static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer =
*h)
+{
+	struct kvm_vcpu_timer *t =3D container_of(h, struct kvm_vcpu_timer, hrt);
+	struct kvm_vcpu *vcpu =3D container_of(t, struct kvm_vcpu, arch.timer);
+
+	t->next_set =3D false;
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
+	if (!t->init_done || !t->next_set)
+		return -EINVAL;
+
+	hrtimer_cancel(&t->hrt);
+	t->next_set =3D false;
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_timer_next_event(struct kvm_vcpu *vcpu, u64 ncycles)
+{
+	struct kvm_vcpu_timer *t =3D &vcpu->arch.timer;
+	u64 delta_ns =3D kvm_riscv_delta_cycles2ns(ncycles, t);
+
+	if (!t->init_done)
+		return -EINVAL;
+
+	if (t->next_set) {
+		hrtimer_cancel(&t->hrt);
+		t->next_set =3D false;
+	}
+
+	kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_TIMER);
+
+	if (delta_ns > VCPU_TIMER_PROGRAM_THRESHOLD_NS) {
+		hrtimer_start(&t->hrt, ktime_add_ns(ktime_get(), delta_ns),
+			      HRTIMER_MODE_ABS);
+		t->next_cycles =3D ncycles;
+		t->next_set =3D true;
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
+	t->next_set =3D false;
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
index 470c7ef02ea4..a48036459f3c 100644
--- a/drivers/clocksource/timer-riscv.c
+++ b/drivers/clocksource/timer-riscv.c
@@ -12,6 +12,7 @@
 #include <linux/cpu.h>
 #include <linux/delay.h>
 #include <linux/irq.h>
+#include <linux/module.h>
 #include <linux/sched_clock.h>
 #include <asm/smp.h>
 #include <asm/sbi.h>
@@ -71,6 +72,13 @@ static int riscv_timer_dying_cpu(unsigned int cpu)
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

