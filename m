Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04287D969E
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405539AbfJPQLT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:11:19 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:20440 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389848AbfJPQLT (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242278; x=1602778278;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9NLEpTSd3DwNRGX9knupUtmamLnIu1b4sMYIQufjAl8=;
  b=g2bSYGx4N6zquG6D3bd1sk7wkG1etIkvYYS+j2Ip3qKFOq8GzsX38xpR
   jb85dFnxFK6Q+sdR5vXFmrjOW5hSkgnE85h5yWFLQNOi90Z9j+CEdd9fi
   CfuQmHsE3FxChCQoMl9s/9Cve3HxDLev3HfjqKpdMy73bc3YsecpAGlG2
   WQSRUHf/IzCc7Urk8WNbqwbg/m5pxQuPl6zLmuaF+SK2RJJrm15Q0HLgb
   shiPdys/+whsn4xw3vqgWi24oRLuFUmNZOIjmp2S7go46im+U5VIIHD2T
   83a6OBGbv80nGLQCockNQKjtGY9uNFHUpQb63CQFwk2GyjeuaIEPqZtkG
   g==;
IronPort-SDR: BclVir97FPUcUGuzcOP61b+bsbrxfq0KdN6ksr+YOaL9pmp4NTCjEYleCF21nQHDlO9dslsTto
 1kfgfsCIxLE5aH4qvs5TMjca3WfBgkX/4Qb9QD8V90vPhw33uaP1kSDzW0WIeTIZFLmb90orRU
 BZ75gmB1p69o9egpDt5aFYmk8JWK50ULxW/x3TqZ5smG/xlWk5MTfliCU30jRhUwmoNpmg/YIu
 p4239Dv9TdRg7pzG4ChOvH7NfpVVYdknZTL0sPdaG37b5SWJjD0CjsDQD5P6zB/gkec523DkmW
 PGo=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="120681143"
Received: from mail-dm3nam03lp2053.outbound.protection.outlook.com (HELO NAM03-DM3-obe.outbound.protection.outlook.com) ([104.47.41.53])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:11:17 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nsIFi1TZsVXdSXcJ6uv7/YQ/UNBJ7dzCdLJJ/lBJqDksmIn+jwQG/+KkTrgEqjHh7Xq7vE3CqT83cesClaKiYpnEPpFz+8wx1yPxFKyvCQq4ZgZyNIz5g+15f6uaJlV+jC7tXAabViAXch2P3KZidecXgc4a+uSO4cLUU0FcCCX7oQhS554MWqKbcO/fgFVBpuOpH/dfCdKpcsdiZ0rkjEkzApFyYU3a4yXrOb8+S5dkfUBmP6ULXLoI4Ng9e8QK2AmNraguZA7Yg8NuYL90LFi5ShL+1g320Go2KZnaDvgwI1aFty9nSSyekcpZqKJN5myXOjV8sluOdymj/kJmgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6xgJ8z9NIBNFJ1HtOFxZsecF3MsJjCzCurmB/BMjEQ=;
 b=QpqJoPSjsacIRvJ8CMIwgxyxRhv7LSf3poJJQ0Ttyyd+NhzE2RXDkiA/gp9V0tylng65JI9W+0VS8QNRpSfn6yGUtcHclRHk3vLPs+MeJe1Sn7bSBaJTZxu1adLz2/y2wkIwfjb8PKLi62GO7hrPYPLZaRTE1lHvzEfjZ9hyrVMSRwrYAemjQQV2WBC89RAjmCWX58SM9G5Q+2pCa1F2uEfbTuKDRxH4WLkidaYZ5uo4oPc6jlAHp4dKrBicsVqef9yebfVzZ+HLnKno+YJH8vjaXdM7zuIHL/Awl6Zr8dTTzxfOI89SKu3jP75qsVCQ7bCO8/mc9X5w6vtvGx9rnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/6xgJ8z9NIBNFJ1HtOFxZsecF3MsJjCzCurmB/BMjEQ=;
 b=AmsCPERPW4YbCvj7Ozkvo2LMUCnOBZbO1aXdL1AZ1SbB2ZnW2NNMWS+hMmCmC0yDDQhD56vZ8hu0U9gHrB+WGTFznfybJTd+hmKLDZvu4wuh1QjkWaU8ExD454YsfpyZWOQQ698FNEUjeZkMgptblg4gvvMW8PVpbBnJWzER24s=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6397.namprd04.prod.outlook.com (52.132.170.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Wed, 16 Oct 2019 16:11:16 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:11:16 +0000
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
Subject: [PATCH v9 16/22] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [PATCH v9 16/22] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVhDxWJ0VHJHr1IES4nRmWNu2w7w==
Date:   Wed, 16 Oct 2019 16:11:16 +0000
Message-ID: <20191016160649.24622-17-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 74847ac9-1634-46a3-99e9-08d7525378b8
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB6397:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB63973759AB49C285C40466C68D920@MN2PR04MB6397.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(346002)(396003)(376002)(39860400002)(136003)(199004)(189003)(71190400001)(71200400001)(66556008)(66476007)(66446008)(64756008)(66946007)(6116002)(3846002)(14444005)(66066001)(76176011)(52116002)(256004)(99286004)(25786009)(7416002)(14454004)(4326008)(478600001)(7736002)(8676002)(305945005)(110136005)(476003)(54906003)(86362001)(2616005)(11346002)(446003)(316002)(102836004)(81166006)(486006)(55236004)(44832011)(5660300002)(50226002)(26005)(9456002)(186003)(8936002)(36756003)(1076003)(6436002)(6512007)(2906002)(6486002)(386003)(81156014)(6506007);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6397;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FqIA5KhPQQcZ0XE18pAuArJwRzk35DNNZz7OBCW5FyBvql+++1+VVIMvfokVgeYz1IfN3T141KY3+PmAm7ljInwAbfJEOvqLtf4/Y4ltXdsmhlUqHD5CVIIDCfu0j0cLkHOqyNi1ZU+Uu7eyZMW85saNEsBpMX//b23zgtntrA9pZeiXvINPxVvkaatNfGlc0RjhKLO5hak64vODVwZlyaCfCrYcJD0x7ZbEP785IKOKvOtn8HKSfmHF9Z8rLmpMLtY4QjDiLKKo1PaCgKqB0eLHVDq14CuQnjqY8i6WlDntpv8s4HDBMNicZfq8IG03kIk0XMi54N6dwCqvneCT6JQzv9EshGGcTLbvWwgkW03h55bmmEi6/zJY2j1AhRfi9Xn7L3hpp7pCISmVh9UaZugHEipoSEJT2smmvLGntd4=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74847ac9-1634-46a3-99e9-08d7525378b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:11:16.1159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2n/fj7+OlxJDYlFC3cLPWOgwb5Ykd32K7R0xiX5tRqeGAKTscJar9k25YvG6wybi9oDj9t+yjSplKm2H9Q3PcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB6397
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
 arch/riscv/kvm/vcpu_sbi.c         | 107 ++++++++++++++++++++++++++++++
 4 files changed, 114 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 8c7f947b31b6..58cb6789f502 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -250,4 +250,6 @@ bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcp=
u, unsigned long mask);
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
index 000000000000..3d0c33c94daf
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,107 @@
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
+	case SBI_EXT_0_1_SET_TIMER:
+#if __riscv_xlen =3D=3D 32
+		next_cycle =3D ((u64)cp->a1 << 32) | (u64)cp->a0;
+#else
+		next_cycle =3D (u64)cp->a0;
+#endif
+		kvm_riscv_vcpu_timer_next_event(vcpu, next_cycle);
+		break;
+	case SBI_EXT_0_1_CLEAR_IPI:
+		kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
+		break;
+	case SBI_EXT_0_1_SEND_IPI:
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
+	case SBI_EXT_0_1_SHUTDOWN:
+		kvm_sbi_system_shutdown(vcpu, run, KVM_SYSTEM_EVENT_SHUTDOWN);
+		next_sepc =3D false;
+		ret =3D 0;
+		break;
+	case SBI_EXT_0_1_REMOTE_FENCE_I:
+		sbi_remote_fence_i(NULL);
+		break;
+	/*
+	 * TODO: There should be a way to call remote hfence.bvma.
+	 * Preferred method is now a SBI call. Until then, just flush
+	 * all tlbs.
+	 */
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA:
+		/* TODO: Parse vma range. */
+		sbi_remote_sfence_vma(NULL, 0, 0);
+		break;
+	case SBI_EXT_0_1_REMOTE_SFENCE_VMA_ASID:
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
+	if (next_sepc)
+		cp->sepc +=3D 4;
+
+	return ret;
+}
--=20
2.17.1

