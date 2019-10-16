Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18F21D9692
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:11:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405309AbfJPQKx (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:10:53 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:14434 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405299AbfJPQKx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:10:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242253; x=1602778253;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=s/FezfmeDvloVwFW2CBOqXqTQy2cR+yRjRdY7cVGHvQ=;
  b=meg76JBqgoEsZrjifjKKwSpiLY65X1SBdvBwRblMKoUbKnnux4LTzJ3j
   2MyChb/Fh4zvNBGb5ntWbCGQRupuu2VO1uAfnmI+QqGLzS6T5+NzoI+M6
   bFB2HmtRu5iycGp/C7/HFeOZHR6EioRl0GohmHYUnKOEn3QtT5cnEcwBt
   abBXXIUYKWinNBjJgEaB9zJJR6XXaJUJB3+i+eN053k8D74I5f1Bjwq1/
   EGtooWiLcxwCxC6dMBgng8KFKFiwGv6KkZVI0uo+24blcu2OTV7umxOai
   rYWxOvT+90MO0YR4hjuTpWkm6DPNFeDmFAG7Z2LFQYIQesWWcOtMNEzAn
   g==;
IronPort-SDR: TzJ4l1j9iiMf+qjelN9RXgEe8rhpykDgRpSurYLwLxoot3x9a7OzO6FrMnHV3PV2FZ3oeMUATJ
 1ChjGnGcuhhD4HhxZezL5mHuNnT/LHwpeVbpAgN14JQJeOgndK2OOf29qSOiBg2HgdSoyFNIS8
 OJFyGtSEoWtvIqnYlNwOtNf4CaaEmIsaFhTNhQRNUztozfC5Oe4Iaqln+lZWl9XbfuNFNc+0oh
 sQI25jzKaznbIromSWEXd+QnLbxhNn/3eWYaix8Lb1W/FYVwYX9RwgqCcT3XFhHyXpwUwrbaBp
 qDM=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="121448324"
Received: from mail-dm3nam03lp2050.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.50])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:10:51 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HpVs6fKDuUNvCBvnIrZU7vFJ2aEDR/aMSh9cxzsM3U4oizd7oeVpPh2j95IdZvhM7u+H65wTs7z+piGvO064sWNf2/2AVBLmfpQkAnXTQZg7qBw4Dume1GiHKAFeQrBcxeW/mx/RyBGlpWh60ic0UUxg0oUXn2eeohpmn2+1lfd6UbrzNozRfdO/XErjh7Pz5xYFPkw1xpBQhgAUWCnllFqyKXK4n/rI7pSSvq+nYoxhUs+uKW9ExuWmxQL49x0M+QLD3yiiolPTTTQjXjboGU9Y94NJoaf2n2nXesHEZUUxWaeRhRjwpHO9+L5J+XfJu9HKwLH4XOQG6d73LWtz2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlvej/j+g2n4bhw6H+t5klqmTXvwIXZ5KSNtxzH1RRE=;
 b=EBZlIOh9m6qbLAeBO0UlV9N316TqG3DuIND1IxkbjtpCPVpSFSVyULvpoQQrjsgnYbtwQ6Kyy7bSNCtwI7D+MFIxOSwTG8q6ooeD20jXdMkFhQDNzA91L1qAz7E3KGehX5wVhsd52Gf+C7RTH+CzB4Foj0dK6hffQzSnsR8xnHqP8D293ovxeR2qpcIZO+lWKvEgeFGpH6A/yu9Qelqvccdb+xPE48hiUt1EIQyKB9+Mwx5RDqfPOs7ZQvZgUG3ZpmdGZSCOR7kRC+tyQRJrvgXKGVoELyjS2+LqHWfs0zobYtm8qngXi//15j3a2RYdIeFeNeXc/+ZSkeQySiHY6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlvej/j+g2n4bhw6H+t5klqmTXvwIXZ5KSNtxzH1RRE=;
 b=VmIWZa0xFRffU2afPdOeYG2IqHAqe6PMlrPL1SLk5B1IgcGW13CuahoQNZ4Ljj/h9PyW/QuM4swuP07HWyZ86g/6Go48PFRv9apASPScESb2Eyrdyjg/G15aZ+ybqDf45+mXHw0SkCNqIeLdJJLcRvBxTl7ur7ybp16zk/Ergtw=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6397.namprd04.prod.outlook.com (52.132.170.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 16 Oct 2019 16:10:50 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:10:50 +0000
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
Subject: [PATCH v9 13/22] RISC-V: KVM: Add timer functionality
Thread-Topic: [PATCH v9 13/22] RISC-V: KVM: Add timer functionality
Thread-Index: AQHVhDxG0eY7JsU8T0+9hRpUt4ALdw==
Date:   Wed, 16 Oct 2019 16:10:49 +0000
Message-ID: <20191016160649.24622-14-anup.patel@wdc.com>
References: <20191016160649.24622-1-anup.patel@wdc.com>
In-Reply-To: <20191016160649.24622-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MAXPR01CA0098.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:5d::16) To MN2PR04MB6061.namprd04.prod.outlook.com
 (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.27.162]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f4556bcb-2fab-46bc-ad61-08d752536918
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB63975D134CF7808E1773E1148D920@MN2PR04MB6397.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(199004)(189003)(71190400001)(71200400001)(66556008)(66476007)(66446008)(64756008)(66946007)(6116002)(3846002)(14444005)(66066001)(76176011)(52116002)(256004)(99286004)(25786009)(7416002)(14454004)(4326008)(478600001)(7736002)(8676002)(305945005)(110136005)(476003)(54906003)(86362001)(2616005)(11346002)(446003)(316002)(102836004)(81166006)(486006)(55236004)(44832011)(5660300002)(50226002)(26005)(9456002)(186003)(8936002)(36756003)(1076003)(6436002)(6512007)(2906002)(6486002)(386003)(81156014)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6397;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: quHogZHhviH2FdAtYYhkhSnAvbdjT9F3HDnw1EWhEC3ZHyox/lQSY6HBF5aD7ez5R4fhbdPOeiIdgJ/opMnfbWVB2Kk2fGwX/2bl/7IbN0I2z6TttLWabXYAaZrCH/oURmOqvb7j3Df5tybI+ra8jtOx9mVA/NDBdnXkHptzMemmqBM8lADYnqdvWfavTlh8ntVsnoVSSPzT67XD3k7AAva5kTYYse/3mjWA6w9c6EtNouVKftY0+tcku4VIWhBDbLbvSBJEoCgOYyBuCBLQp2ejLD6BYYMhLOXpxgPgPfvFCe1m78jYcwfT9cQaTajOKhENAVLxh3GFtgwchINc7d8EmXmGJa9iKDTO72Gq8q4win7nK6/JRjIPmgx+bfLCeK4SFeDR4olawBZHAttJZDGDQvy14N7ItoHid1DpYSI=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f4556bcb-2fab-46bc-ad61-08d752536918
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:10:49.9650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1xGL86eDChrSzvoTh3fRmcDeBJPq+sxUSt3m70g3HYDH2JjUpLjmdzXCdEgzdjRhI6FHjfb6TbGeDiAfxnUhZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6397
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
 arch/riscv/kvm/vcpu_timer.c             | 110 ++++++++++++++++++++++++
 drivers/clocksource/timer-riscv.c       |   8 ++
 include/clocksource/timer-riscv.h       |  16 ++++
 7 files changed, 175 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/include/asm/kvm_vcpu_timer.h
 create mode 100644 arch/riscv/kvm/vcpu_timer.c
 create mode 100644 include/clocksource/timer-riscv.h

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index b1493c6cbe83..0ef0aac8143e 100644
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
index 36957802fed4..f9c5ef98becf 100644
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
index 000000000000..4ff5d666f60d
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_timer.c
@@ -0,0 +1,110 @@
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
+static enum hrtimer_restart kvm_riscv_vcpu_hrtimer_expired(struct hrtimer =
*h)
+{
+	u64 delta_ns;
+	struct kvm_vcpu_timer *t =3D container_of(h, struct kvm_vcpu_timer, hrt);
+	struct kvm_vcpu *vcpu =3D container_of(t, struct kvm_vcpu, arch.timer);
+
+	if (get_cycles64() < t->next_cycles) {
+		delta_ns =3D kvm_riscv_delta_cycles2ns(t->next_cycles, t);
+		hrtimer_forward_now(&t->hrt, ktime_set(0, delta_ns));
+		return HRTIMER_RESTART;
+	}
+
+	t->next_set =3D false;
+	kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_TIMER);
+
+	return HRTIMER_NORESTART;
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
+	kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_TIMER);
+
+	delta_ns =3D kvm_riscv_delta_cycles2ns(ncycles, t);
+	t->next_cycles =3D ncycles;
+	hrtimer_start(&t->hrt, ktime_set(0, delta_ns), HRTIMER_MODE_REL);
+	t->next_set =3D true;
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
+	hrtimer_init(&t->hrt, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
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

