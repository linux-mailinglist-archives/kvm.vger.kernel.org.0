Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AC6E78B24
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:58:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387969AbfG2L6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:58:00 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:55413 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388031AbfG2L56 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564401478; x=1595937478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=P6cjCLR4eUG2EJMspJYXY/8LwrM2eLc8uGW3DsDB3p0=;
  b=eI8E5fRk2GSvZ6TxOZw0YlAGQ6sDmHklZjSOf0N5I4TYqH+Uukv+/S0N
   //9F2oRhQpKrGoyu039fV/MnKBp9jRaiKRqzmKByQGfkDOERBDtEDrpEu
   7cJ9UGw0D+ou06Lk2qyWil0T7c+2kP0b3Y8lZKlBo+i1VCSQEUGz51/+0
   mxuopiArQzMlrWTP3OTYLBxhA2e3MwDMW7Oxel2JyDfWe0nqSFglLY9pN
   ImwQhDLcf91r4C8cmLysR61gU8xmwgg7POZ6yDoHNFO6UMstHAMsO3rou
   8bJipKvbhbVC+55b7uaY0avN48wDHQ53263Ikm2yrSOKSg7Sr32u5MQmk
   Q==;
IronPort-SDR: Vd+k4cxo7+rtfaNYKIRFU4DmDJdYg5hgHpBZUyRmJpxVlvyYRM9QhEDB54izVk2VyB4muDeaYC
 tRx61Uf/guknKMvWDRvIodf4nWKHkxaKIVpX5WA0qpmy/KAfzScGWFJwV2lf/xPrrgCWnp+Mas
 4vNbG5t+C692B5Q/2OLfIaDu9dZNHI17XyeTiz4QyesPsw78XzGAty7vD/WjfPibchsH+j854Y
 DiJl5E90Ufnk+k8di9EJKFJYm+Pwx++SRhSukBmjflNniUjtHam5ytIec+RV50vxncs0IutPhh
 C04=
X-IronPort-AV: E=Sophos;i="5.64,322,1559491200"; 
   d="scan'208";a="115974028"
Received: from mail-bn3nam04lp2056.outbound.protection.outlook.com (HELO NAM04-BN3-obe.outbound.protection.outlook.com) ([104.47.46.56])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2019 19:57:56 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrH/nSPU7F3/+RsVnoZ4ndNH0rj4Hh9/iVohZYciDkxCtvB3yeE0zY852/fz8j7HcADbDlSFSJbcAhfPvER9LGXbtoV+BLo370dKxXRv5XPXxYzXkORCRIsP4JJv2vfOgeS17Y7tzfRt/Kqvizf/ToRfFaf5xOgvs+qEmENvsSXLPl1R/dnfZFRtLMswX5RU/70Y0MN6nVFvpmG13RsTyfzdO00FMmZqqHjlFAB0eb7H1cCwXSt26bBDRyDDBO+a9K86IIg+eEKmgeKXs8Ps5j+/JmtSDyuqxujTW/FFGUQHThSU3HRusM3skjRg3dUPJZICNOkoXkqE1aNkXW0UCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBmZ/fHeN4BkJC8/R7Fe/4MK2SNUWwUMXdIvKaCDSxI=;
 b=bfwdSEK/7vrIIAk4RYaOrgE/8PQxUsmiLnkULpwojWoyldf1Rn9iw4tQfwU+qJOHG59dPNsr09sTSxnIEasuiC7zA92z/+ZEwViasiM6Ur3BgDvYE8gXuaSywn35FA5lVoL6C11JSGctsPmQaD1LjxzcOP1N989mgmHV/4TwcYgk+cv17vY4PRl+eAODrp9e1UF1BaW9ytaWbz5IA/XXfXm4nx2ieQi5MqlwLo0hV2IiTg2qgHnhNe7HNUMTiQOyBLPeRVKfOczQTUEO4FWL8PVcoDqVDtAWTkCYCYd3jL4nZr/m7ay2vGLGX9tnzsUXpXSWR3N4/sCHYADJ+ULN7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eBmZ/fHeN4BkJC8/R7Fe/4MK2SNUWwUMXdIvKaCDSxI=;
 b=FQ+OOalDUJA3UwIzFTvQ4xNRnTD0pJk872OVoNZnQ2F5BhEGVotDsEYmlEchJPfYQ7omxyBiy2K04+drZw4Ka8r1XxMjuXWZK2w0WQjlk0nLUwWtCTZjSprgKUSese0MNkg6jUClOK20vCPrjaSSFcY7s5YfVoji9pujX8qGwGY=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6208.namprd04.prod.outlook.com (20.178.248.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.13; Mon, 29 Jul 2019 11:57:54 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 11:57:54 +0000
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
Subject: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [RFC PATCH 15/16] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVRgTbYdvVLL9QvUubgRD/usDWHg==
Date:   Mon, 29 Jul 2019 11:57:54 +0000
Message-ID: <20190729115544.17895-16-anup.patel@wdc.com>
References: <20190729115544.17895-1-anup.patel@wdc.com>
In-Reply-To: <20190729115544.17895-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0116.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::32)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.23.101]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9750a1bf-8e95-4089-e894-08d7141bfd65
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6208;
x-ms-traffictypediagnostic: MN2PR04MB6208:
x-microsoft-antispam-prvs: <MN2PR04MB6208D86F98F5CB6A79501D188DDD0@MN2PR04MB6208.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(6116002)(71190400001)(76176011)(71200400001)(7416002)(11346002)(7736002)(99286004)(446003)(2616005)(2906002)(476003)(256004)(54906003)(78486014)(3846002)(110136005)(316002)(53936002)(25786009)(4326008)(305945005)(486006)(14444005)(44832011)(66066001)(5660300002)(478600001)(68736007)(14454004)(66556008)(66476007)(64756008)(66446008)(6436002)(186003)(6512007)(1076003)(26005)(81166006)(81156014)(8676002)(6486002)(50226002)(8936002)(55236004)(86362001)(9456002)(52116002)(386003)(6506007)(36756003)(102836004)(66946007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6208;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lb7T201sNJ8ix9rQf9V9E6wDoZiqInBUFqS1S/THR6yjpSGHemxnqx45WUiVbv7EdXzowLYZGWgpHfUkg5xFqujKBh5guYqMn8hK3j6Q8UV/Z1rngFqgy6lmoICBbXxhAiQxef8e8plnLgxlFpARIvrUOFvdQs6oaxc2SZoKCxB/2pxt5tomsP4giwraDoGf9Ml4A24irSW46BeSDiQ+H6Ht8SJr5FyG44DD9yUTpaJAvPIrwRm1+uuQzR84u/Znp8dgw1QgyC0YXzeWoShjOls1c9rkZSqngXrCAMUyYDMF6vlT5wvNfwMXeH5zrrTReeEM78o9YXpTfyCz1dUQfX19bIF0ZqJAdl/fqq/nO18DtMGonjW1KHWvjBmvE6bS+Mvp3EEujmie26r7ExSu1Uwk704dkqCld2VqhCxQOUw=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9750a1bf-8e95-4089-e894-08d7141bfd65
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 11:57:54.6500
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6208
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

From: Atish Patra <atish.patra@wdc.com>

The KVM host kernel running in HS-mode needs to handle SBI calls coming
from guest kernel running in VS-mode.

This patch adds SBI v0.1 support in KVM RISC-V. All the SBI calls are
implemented correctly except remote tlb flushes. For remote TLB flushes,
we are doing full TLB flush and this will be optimized in future.

Signed-off-by: Atish Patra <atish.patra@wdc.com>
Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h |   2 +
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu_exit.c        |   3 +
 arch/riscv/kvm/vcpu_sbi.c         | 118 ++++++++++++++++++++++++++++++
 4 files changed, 124 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 1bb4befa89da..22a62ffc09f5 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -227,4 +227,6 @@ void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
 void kvm_riscv_halt_guest(struct kvm *kvm);
 void kvm_riscv_resume_guest(struct kvm *kvm);
=20
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/kvm/Makefile b/arch/riscv/kvm/Makefile
index 3e0c7558320d..b56dc1650d2c 100644
--- a/arch/riscv/kvm/Makefile
+++ b/arch/riscv/kvm/Makefile
@@ -9,6 +9,6 @@ ccflags-y :=3D -Ivirt/kvm -Iarch/riscv/kvm
 kvm-objs :=3D $(common-objs-y)
=20
 kvm-objs +=3D main.o vm.o vmid.o tlb.o mmu.o
-kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o
+kvm-objs +=3D vcpu.o vcpu_exit.o vcpu_switch.o vcpu_timer.o vcpu_sbi.o
=20
 obj-$(CONFIG_KVM)	+=3D kvm.o
diff --git a/arch/riscv/kvm/vcpu_exit.c b/arch/riscv/kvm/vcpu_exit.c
index 2d09640c98b2..003e43facdfc 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -531,6 +531,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct k=
vm_run *run,
 		    (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
 			ret =3D stage2_page_fault(vcpu, run, scause, stval);
 		break;
+	case EXC_SUPERVISOR_SYSCALL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu);
 	default:
 		break;
 	};
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
new file mode 100644
index 000000000000..8dfdbf744378
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,118 @@
+// SPDX-License-Identifier: GPL-2.0
+/**
+ * Copyright (c) 2019 Western Digital Corporation or its affiliates.
+ *
+ * Authors:
+ *     Atish Patra <atish.patra@wdc.com>
+ */
+
+#include <linux/errno.h>
+#include <linux/err.h>
+#include <linux/kvm_host.h>
+#include <asm/csr.h>
+#include <asm/kvm_vcpu_timer.h>
+
+#define SBI_VERSION_MAJOR			0
+#define SBI_VERSION_MINOR			1
+
+static unsigned long kvm_sbi_unpriv_load(const unsigned long *addr,
+					 struct kvm_vcpu *vcpu)
+{
+	unsigned long flags, val;
+	unsigned long __hstatus, __sstatus;
+
+	local_irq_save(flags);
+	__hstatus =3D csr_read(CSR_HSTATUS);
+	__sstatus =3D csr_read(CSR_SSTATUS);
+	csr_write(CSR_HSTATUS, vcpu->arch.guest_context.hstatus | HSTATUS_SPRV);
+	csr_write(CSR_SSTATUS, vcpu->arch.guest_context.sstatus);
+	val =3D *addr;
+	csr_write(CSR_HSTATUS, __hstatus);
+	csr_write(CSR_SSTATUS, __sstatus);
+	local_irq_restore(flags);
+
+	return val;
+}
+
+static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off =3D true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&vcpu->run->system_event, 0, sizeof(vcpu->run->system_event));
+	vcpu->run->system_event.type =3D type;
+	vcpu->run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+}
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu)
+{
+	int ret =3D 1;
+	u64 next_cycle;
+	int vcpuid;
+	struct kvm_vcpu *remote_vcpu;
+	ulong dhart_mask;
+	struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
+
+	if (!cp)
+		return -EINVAL;
+	switch (cp->a7) {
+	case SBI_SET_TIMER:
+#if __riscv_xlen =3D=3D 32
+		next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle =3D (u64)cp->a0;
+#endif
+		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_CONSOLE_PUTCHAR:
+		/* Not implemented */
+		cp->a0 =3D -ENOTSUPP;
+		break;
+	case SBI_CONSOLE_GETCHAR:
+		/* Not implemented */
+		cp->a0 =3D -ENOTSUPP;
+		break;
+	case SBI_CLEAR_IPI:
+		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
+		break;
+	case SBI_SEND_IPI:
+		dhart_mask =3D kvm_sbi_unpriv_load((unsigned long *)cp->a0, vcpu);
+		for_each_set_bit(vcpuid, &dhart_mask, BITS_PER_LONG) {
+			remote_vcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, vcpuid);
+			kvm_riscv_vcpu_set_interrupt(remote_vcpu, IRQ_S_SOFT);
+		}
+		break;
+	case SBI_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, KVM_SYSTEM_EVENT_SHUTDOWN);
+		ret =3D 0;
+		break;
+	case SBI_REMOTE_FENCE_I:
+		sbi_remote_fence_i(NULL);
+		break;
+
+	/*TODO:There should be a way to call remote hfence.bvma.
+	 * Preferred method is now a SBI call. Until then, just flush
+	 * all tlbs.
+	 */
+	case SBI_REMOTE_SFENCE_VMA:
+		/*TODO: Parse vma range.*/
+		sbi_remote_sfence_vma(NULL, 0, 0);
+		break;
+	case SBI_REMOTE_SFENCE_VMA_ASID:
+		/*TODO: Parse vma range for given ASID */
+		sbi_remote_sfence_vma(NULL, 0, 0);
+		break;
+	default:
+		cp->a0 =3D ENOTSUPP;
+		break;
+	};
+
+	if (ret >=3D 0)
+		cp->sepc +=3D 4;
+
+	return ret;
+}
--=20
2.17.1

