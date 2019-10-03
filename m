Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF3C97C7
	for <lists+kvm@lfdr.de>; Thu,  3 Oct 2019 07:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728663AbfJCFId (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 3 Oct 2019 01:08:33 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:17107 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728743AbfJCFIc (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 3 Oct 2019 01:08:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1570079311; x=1601615311;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=chyHVHdLNxHU0jjESCfhKItyhD0599h36b9f1bjABYI=;
  b=YsE3X/GR0NWT1heABtWrMbAohgZE2+aYCPUf/bws+iyJf4OY54xAjD1u
   A4Qxn5AMhLFX4c1DtfcpGj26cfRXNUpAwyN31MF07XfZF2N2jsEJaKN7k
   UnFE6no+xSgCAGRhKtoKy1I4yluju1pQSlzIa4wY94969jhuvl3/YPCzp
   SMY0w+Fp1zx7yNLqPmXJzc9UidoOqsA8tisWii+AP27dRb/wMredF3cEe
   wckxesQRvexpwtJcOOhCnXiaX7YxOQdpHiD6zpvgtu8MvnCUDEagzVinF
   xFccZ6iEKoUwS8shNoVZuhCOHFKtd4tdawUH78rdXdYrh29G49yxJcRoR
   w==;
IronPort-SDR: 9Cd5rdxt8Vix2firFmz0kHz3vCnPDZDX2UUgRCMRYoaPfJx14paDAaYXtH/PNLxeno6cwxGAXM
 hiLn1kaYkZ7O5Ve8sLIGPyEIqvk8u66sh3Nsoyko7SFFUIzyue6LdY9GGqGIbpqM9Iq4A0IPOU
 1vm2hia0wLEKjlErjzak/U0WeMndBLYptilS4lUmHM9aP8rVjMUhG+f367otbh0H3kV4Nhmsl4
 BAVIRrSS+4QDb1y8TCoZQ28WbmuSS7C1Vq4bz181cGBwEQNhgdsMbF7hB0cMxFIyfrTlySH9K9
 eOM=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="119691066"
Received: from mail-bl2nam02lp2059.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.59])
  by ob1.hgst.iphmx.com with ESMTP; 03 Oct 2019 13:08:30 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bPN/53jzTkLMAZZ4B9oG/P/tBAafarNUuUH901Zsp4zoOk98lQ9U48gWnAf7sFqR09Y7rttzi9/LbDjeNx2IdsoZBa//qfmz+T+DNZPvo5oNMOVv0Zws+5A8x9cGXJZULpBu1jTK3GimGHPluwmF6fFzRKY8BX4F33p9DSLZTH+h5//J2+VftsZaSoOzu5ZGMXVnHk2Lg6/AQtl9lmzWqlCi2iipFhJopGr6DbJgPYU8T9TI7PmiaC9S/6/m8o72yZQ8DE5QjEerL+Rnl6TL6GYkYYS7oW3wXOEDn3jgIDCtY2NF+2zHn5qMhJIhmNHs9GDhYoMEFT0nyTDse5lRRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eApuqBdCdV8lBrrYRfY6ko039/9vakJe9V5+6COdNxM=;
 b=QeQTt4CzLKHheiufPqIguDgcPFISAC5HW/c/ad0Ep6uWcvEzMdItadCj2rJHM2L0CJ8CZeT9rDMDDI5pijRoTqxz2odnge6DBB62dieMH8yXuyKDUWQZwtvBjqeVHDI1vEU+bYCVHgFRXMvUcrp2KL91xCPwrC/j0J9FYT6anQZphM0siRZInFv38B43Eg0mh/AR8WkH+X4UbW3jgxxiwHmSYqTXtaUwBk3zA06IdERx/QSAhBa++kkPaSOkPxHS17r2J9WgzZyM7FWdqZWHKv999M+bm+J6+WEIslCvm/jlo/juZPwuxxAuNHe7UXMrZYvs9ZMF/7ACjqLFN7znlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eApuqBdCdV8lBrrYRfY6ko039/9vakJe9V5+6COdNxM=;
 b=HXD6XL1aHRYXNiy+6rexQMwGB3KbMIUU2lidkfMvUh1k697jqs2sHZLIoex1Qw1uefbsoa0xWKmotLrAVTbHLhXS7PlpRCy6iOd6SkFtntF2MZElRFSAsMNkjhZsC+6TWBYgnhpDnZsPcTjP38NAM2uvkuVh+xHts/6w+6sG58s=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5568.namprd04.prod.outlook.com (20.178.249.85) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.17; Thu, 3 Oct 2019 05:08:29 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2305.023; Thu, 3 Oct 2019
 05:08:29 +0000
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
Subject: [PATCH v8 16/19] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [PATCH v8 16/19] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVeaiYYctt3VF8ZkWdNhItg8ZmYQ==
Date:   Thu, 3 Oct 2019 05:08:29 +0000
Message-ID: <20191003050558.9031-17-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 6b4f7ecb-de24-4ee5-47b7-08d747bfba56
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB5568:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB556837DB931256540D5C4BC08D9F0@MN2PR04MB5568.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 01792087B6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(376002)(39850400004)(136003)(366004)(199004)(189003)(71200400001)(6436002)(316002)(2616005)(6486002)(71190400001)(6512007)(110136005)(14444005)(86362001)(36756003)(54906003)(256004)(6506007)(386003)(6116002)(1076003)(5660300002)(7416002)(2906002)(81166006)(81156014)(25786009)(476003)(3846002)(478600001)(7736002)(446003)(11346002)(8676002)(186003)(66476007)(64756008)(66556008)(99286004)(305945005)(66446008)(50226002)(26005)(14454004)(66066001)(8936002)(102836004)(44832011)(76176011)(52116002)(4326008)(66946007)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5568;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H7ZeQkC3NyvGFN9iGeGTXC1hc7ceB7yhNKxwO77/kQS3kTDLJx+QAAayXBuJYgZg8G13Nqk+/YFcMwtrgR1oisYe1l8T9McoNq5vWDoCNrhrS0t7eoXg/YWQIQCS17qpkt7VQX+Np7HCEHmEw4DSK4zevDdahRLdiq0ll+wRm9NERCc5qAuG1qLUvC3WDK24kdvfnvLdW9yzXN07ogx3JY0q7gjXrE1bkyp9wlH6TSE7yX4ARoav97RH/bu9K8kp6FltGox3+8+9Dmbxp6xG2Z3CeCCnWZPIjF/+6ankRW0je8iuU86YsV0Yq9LD4AZ9zlxsBFIw0RS2/0pBsZIpfo5vxb+EazC3t011M9k5x89JOZLi6E2iy3Zc6ft8vibzfbK6AHtdEXdZVjclh15PYmUNdOT97Dw3J11NwIDZBj4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b4f7ecb-de24-4ee5-47b7-08d747bfba56
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Oct 2019 05:08:29.0464
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: T1lKL7c734Q/Ib4UjQeN+wCvq3F+aVhEI3TGM9ibjIXrRCtjIuiWgSDRPl8hChI0R9IVP89/KD04O571xNsnfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5568
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
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/riscv/include/asm/kvm_host.h |   2 +
 arch/riscv/kvm/Makefile           |   2 +-
 arch/riscv/kvm/vcpu_exit.c        |   4 ++
 arch/riscv/kvm/vcpu_sbi.c         | 106 ++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 928c67828b1b..74ccd8d00ec5 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -250,4 +250,6 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu=
);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
=20
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run);
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
index 7507b859246b..0e9b0ffa169d 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -587,6 +587,10 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
 		    (vcpu->arch.guest_context.hstatus & HSTATUS_STL))
 			ret =3D stage2_page_fault(vcpu, run, scause, stval);
 		break;
+	case EXC_SUPERVISOR_SYSCALL:
+		if (vcpu->arch.guest_context.hstatus & HSTATUS_SPV)
+			ret =3D kvm_riscv_vcpu_sbi_ecall(vcpu, run);
+		break;
 	default:
 		break;
 	};
diff --git a/arch/riscv/kvm/vcpu_sbi.c b/arch/riscv/kvm/vcpu_sbi.c
new file mode 100644
index 000000000000..88fa0faa3545
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,106 @@
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
+#include <asm/sbi.h>
+#include <asm/kvm_vcpu_timer.h>
+
+#define SBI_VERSION_MAJOR			0
+#define SBI_VERSION_MINOR			1
+
+static void kvm_sbi_system_shutdown(struct kvm_vcpu *vcpu,
+				    struct kvm_run *run, u32 type)
+{
+	int i;
+	struct kvm_vcpu *tmp;
+
+	kvm_for_each_vcpu(i, tmp, vcpu->kvm)
+		tmp->arch.power_off =3D true;
+	kvm_make_all_cpus_request(vcpu->kvm, KVM_REQ_SLEEP);
+
+	memset(&run->system_event, 0, sizeof(run->system_event));
+	run->system_event.type =3D type;
+	run->exit_reason =3D KVM_EXIT_SYSTEM_EVENT;
+}
+
+int kvm_riscv_vcpu_sbi_ecall(struct kvm_vcpu *vcpu, struct kvm_run *run)
+{
+	int i, ret =3D 1;
+	u64 next_cycle;
+	struct kvm_vcpu *rvcpu;
+	bool next_sepc =3D true;
+	ulong hmask, ut_scause =3D 0;
+	struct kvm_cpu_context *cp =3D &vcpu->arch.guest_context;
+
+	if (!cp)
+		return -EINVAL;
+
+	switch (cp->a7) {
+	case SBI_SET_TIMER:
+#if __riscv_xlen =3D=3D 32
+		next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle =3D (u64)cp->a0;
+#endif
+		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_CLEAR_IPI:
+		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
+		break;
+	case SBI_SEND_IPI:
+		hmask =3D kvm_riscv_vcpu_unpriv_read(vcpu, false, cp->a0,
+						   &ut_scause);
+		if (ut_scause) {
+			kvm_riscv_vcpu_trap_redirect(vcpu, ut_scause,
+						     cp->a0);
+			next_sepc =3D false;
+		} else {
+			for_each_set_bit(i, &hmask, BITS_PER_LONG) {
+				rvcpu =3D kvm_get_vcpu_by_id(vcpu->kvm, i);
+				kvm_riscv_vcpu_set_interrupt(rvcpu, IRQ_S_SOFT);
+			}
+		}
+		break;
+	case SBI_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		ret =3D 0;
+		break;
+	case SBI_REMOTE_FENCE_I:
+		sbi_remote_fence_i(NULL);
+		break;
+	/*
+	 * TODO: There should be a way to call remote hfence.bvma.
+	 * Preferred method is now a SBI call. Until then, just flush
+	 * all tlbs.
+	 */
+	case SBI_REMOTE_SFENCE_VMA:
+		/* TODO: Parse vma range. */
+		sbi_remote_sfence_vma(NULL, 0, 0);
+		break;
+	case SBI_REMOTE_SFENCE_VMA_ASID:
+		/* TODO: Parse vma range for given ASID */
+		sbi_remote_sfence_vma(NULL, 0, 0);
+		break;
+	default:
+		/*
+		 * For now, just return error to Guest.
+		 * TODO: In-future, we will route unsupported SBI calls
+		 * to user-space.
+		 */
+		cp->a0 =3D -ENOTSUPP;
+		break;
+	};
+
+	if (ret > 0)
+		cp->sepc +=3D 4;
+
+	return ret;
+}
--=20
2.17.1

