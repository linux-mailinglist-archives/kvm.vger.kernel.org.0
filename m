Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28020A8CA7
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2019 21:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387572AbfIDQPq (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 4 Sep 2019 12:15:46 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:2705 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732834AbfIDQPp (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 4 Sep 2019 12:15:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567613745; x=1599149745;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=GuaoUcPxECkPDvcLincTIzCUQeGav2SvV0dMP6ef+b4=;
  b=kOu+m/UIl7vNX9lNoqBzahSch5JYSvk8Ec2HkTjfi0np0CmbMmJC1ETo
   8/5tcwUXqoQVCqxS9/9mS9dkpIkJz/OwImXZ9e+p/NhIUTZLqdnfG6Bfe
   j5cEnlllMdze3mkZDEslQAUzWR/St/nZ39oGBqyma8zSsDIQ145yKF9er
   iw/CS0EfmeMqT1Odv1KC0sjgu2cL/UHSBGYojaj4ZLHB6AC6l4maSfJMi
   ow/cmZaIwkQMmGcjkQ0qocSjzOoZB0RbbIV/wjpd3aSflsBd9wZTj3KB8
   Nx39XGah2oIW3tR1SN9ewTdqtXrpJJASAXi2OVadLiD1zscvtWqLhG2bv
   Q==;
IronPort-SDR: N454GvhJevouzjG8zrK0smpoSswVko3nE3TeIJUYRAFQZP1wrX1U5cbHGI6pyK/nTjoNsgiD+A
 UUjPqp5XzouIBKPs8Pd8lGO+xLXPyUi6jzNzXxOsFg7UPyUwasZM3nXoxqOIl2pOWBOo9zUGHu
 m26HQ40Tjy0kO/+Pcjt9FNnmfyrdXcuPgXHS5i9L3Wg7O0iCm49Y9yu1omocm7a7MkIDv3nkEO
 B+CJEa4m2Ru5FlDujfoNxgCTanldnZM6j3fba7Tm3FkbYQV1TRc3T5eVYf/jfTy3kL0KmyHsXu
 PpQ=
X-IronPort-AV: E=Sophos;i="5.64,467,1559491200"; 
   d="scan'208";a="118324012"
Received: from mail-sn1nam01lp2055.outbound.protection.outlook.com (HELO NAM01-SN1-obe.outbound.protection.outlook.com) ([104.47.32.55])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 00:15:44 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jD41dhNPIq3TUGvm5fkQ8kXZlhw1KZD3Ih6+FROO3jG/emFOzoHnYELwhLlQO+Fsy78vwr79j4Evs5ytivTsgARGOcPjYa2rq9IznlxBcS8h4kmHnHpakwBrdBmP3Yt+xqVtMUoHlTGv8GqH5K0gaS2r8eHOa0MVUJb0AhnOqnv9AgE4E5qV06D13EUXNt2SmhynbTbdhZ0zpTHQkoLguyOUoREOT61ZyCyV4N5e/ORJ7weAFaOD2PNmjgPWkMQpOV3AyPCwS3ZzcnwNE8faFqcxW+Ys+zBUTk6V1GJjYQdpbSg9LTs5quQnroAd61Bt3wwatW2muOij1KHL7EhiAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cd+AoVUBONB2YYkkFWixPU7NV/HVL05Y1NQwEeyicWs=;
 b=EKlotY/6Ly76ZW56Ww7Tt30YpglaHNRWXoH8BBV3qkmyH57v65txBw/vju8EMJnLNhAh0NGqZ5FufKJdgsgrUl9NV++ZefFm+pelddRcfP0FSPBYyueDsUJv8YZeIsPqD2OG0MTR/RWqnZ2TOa0yKgI5F+QjdMaLCiCmddWFEm63aPnZAL2lI+eGpSPfIRug8ksBCUblNGsIFgcqCwqyvBzubck3/SL04s36zw2p22r6kHSt5QxOmGDxyHae8VyhmUx7kmCN3Y1DA3Ya5CWAk9ndeK4y/4CkRJqzVWDUdHrEeucFqKN19ecKMvvmNm53GSni1R6zx1EcCxufA9ZiOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cd+AoVUBONB2YYkkFWixPU7NV/HVL05Y1NQwEeyicWs=;
 b=ew3kdiOCwvNQOjyrnZ4iDCbwHS99iZMsSq/z+s3tkXOY0F0M8Vazj5E0OsABISE7U/cOeb9FfKdIyPk3oBRFMGuU7fFafCIo1hdcLDT+A5DB9p0DbAn4J76yrnnAeV5DVaF1cZFHHJ2473xadRyWcPxyzut97sDfr+z8ogjBJIY=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5504.namprd04.prod.outlook.com (20.178.247.210) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Wed, 4 Sep 2019 16:15:42 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::e1a5:8de2:c3b1:3fb0%7]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 16:15:42 +0000
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
Subject: [PATCH v7 15/21] RISC-V: KVM: Add timer functionality
Thread-Topic: [PATCH v7 15/21] RISC-V: KVM: Add timer functionality
Thread-Index: AQHVYzv/E9p3TaAvDkWZRJsDYSPecA==
Date:   Wed, 4 Sep 2019 16:15:42 +0000
Message-ID: <20190904161245.111924-17-anup.patel@wdc.com>
References: <20190904161245.111924-1-anup.patel@wdc.com>
In-Reply-To: <20190904161245.111924-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0084.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::24)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [49.207.53.222]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9c01d45-4c63-432b-ce71-08d73153222c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5504;
x-ms-traffictypediagnostic: MN2PR04MB5504:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB55043B9F82107B65AFAD362F8DB80@MN2PR04MB5504.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(136003)(396003)(346002)(366004)(39860400002)(199004)(189003)(66556008)(66446008)(7416002)(7736002)(8676002)(478600001)(25786009)(386003)(66946007)(99286004)(256004)(14444005)(50226002)(14454004)(66476007)(64756008)(6506007)(6512007)(102836004)(6436002)(8936002)(54906003)(6116002)(3846002)(486006)(26005)(55236004)(86362001)(1076003)(53936002)(476003)(316002)(71200400001)(71190400001)(81156014)(76176011)(52116002)(305945005)(5660300002)(6486002)(36756003)(186003)(11346002)(2616005)(66066001)(44832011)(4326008)(2906002)(446003)(81166006)(110136005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5504;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: p7TJNEDBK9BGr0enlnb0h7fDp95oF5kk/OIp06PkPoJOutdMVi5IH+x2+VxVwCFboaXFrTUE1Ho+tZNuxScMGfn5AdcX+0mXBH/gleXxXxMYhgpy5/x4uxRQChvgJ453F64nqlgg/d6UycrZz8tLKp125RbES8mZav453ml7gTPePokCpfo7US9pTwgUgqwEDQRQfr3ghM7MXfLokhN853JTQezVaqp1E4JlSsJV15V1TJN71ykif+QpExUFQ3xL413nSYMI5DEQWrul0UDhlysiakU1u72L5SKw1eXfeyT4FXQciAZe9edttC105IHLR5XkJd6Acu5E+0pHDL08al46HQsBNYNgnlJGt977rxtoXvmnM3cI7UgIsLaZwxHmEx0h/t/w2NARg26PGOFzcHRKbC70Ito4y5DgfK0Wqas=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9c01d45-4c63-432b-ce71-08d73153222c
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 16:15:42.3242
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 99djGn6vfbgQ9Wn3vh3h8NWlIp+2BO9yI5r2eCw+5T9c78tjpY3gOdOOr22P0yL4v/loO1LNgQjQV4LXLHFz/w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5504
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
index 66158c0b90e6..7c270ba5e4b4 100644
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

