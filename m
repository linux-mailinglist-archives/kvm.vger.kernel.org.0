Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 694FB7EDFE
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:49:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390431AbfHBHst (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:48:49 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:39501 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728272AbfHBHss (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:48:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732150; x=1596268150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=e+kyewE4ROqForPiiZc8CPhe7KiF+cZH3jJVEnqVXRI=;
  b=jLZ0FlvtWIQFP3Y5NpPZ0ii8JGscOkjI+bfXhynn3zNv/jkBHUstDCMh
   I3inh+McoKZjDrspWFRJDmxeqkR9sgnUTqDd+4YGKrO6rRklibbIjgdQh
   OMia4ub2vKy8wRF3bl0YS7eW1Y1k7piCa51EXjed487z0pB0TqUb4gHCi
   Vc/4k0nQlVLZVwx0dciJs81VOcjyU0ySv1dTFKW/14/ZbpNDfPWMiFQy3
   3Ba7sVy34v5jzQyl/N4GvNTfQAPh+Zw3yUluzjMkDHl44ATAWK0LmVPgY
   IbBzvXAZqTYiifaxMdkpQ4RA0xpDgLHumxTQlqPSKp1bryuuGmvua5YOa
   Q==;
IronPort-SDR: cg9TLFefsjcZpCPxuMI3aJKNlnQzq80hsq8lsgzKXmDsKwA0lX/09JJDBz6kVDJG620SXJQ/AG
 R7PeIC3C+QOI3J9gqX55Ac9nTxE+0gwceDAEXLkL08r5Q8XXW9NfEeojP2ouf3EMDgaD1Ggh92
 ivMw8N63OPVBNb92m9i07Zk+8Q+Be0TvvPSfKRLzOcYRGCf/iXvjgwZoLXshzMC75aznBQN7Xb
 zinzexgWmuwOcSkbvXJLi3wfc2mo4h4Mpro3u5ALtyOLbliKpL1qFNrIe/yG/ra5EboXwqOJ5Y
 nB0=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="215006741"
Received: from mail-co1nam04lp2053.outbound.protection.outlook.com (HELO NAM04-CO1-obe.outbound.protection.outlook.com) ([104.47.45.53])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:49:06 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/fiI4dbAAI0HiAZkXi8RddvM1JyzhbxyD4p48Bbgp0KOJpMkVJUhCgsQN0HlwT99Sq4wMGtDbyqUpmde9XdYNANuYD4tQUJ9ry/y252e8rawTuNa1meQ3FVOaScU6IpTrnm3jjdb0w2LWDwD+t+Tg/GqrjpQwUkZikm6xYsqif3SL0+VkPOdvitE9ROBdga36le3u05hLgKWjXpmnV0oGLdQ/KyhcXHeSkGH/MfJhBHU+GuwEgUWlz/BQ8Ga/PIdTZw0KHneJldLsLqP+JdPXZt3Qp3cGPrpbMAgmYtWbAnyCRkcGsZEUqT+pwIBOvzmJ7Z11tnFR8M17TNKWTlgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAZsNAz9rX57qDjhaI5L4DRsQiSpZbIU43MbFP/PU9Y=;
 b=U8711IQ9GWhWZXFLEI7bMOfL+h/nKyam/EJbOk3n+g8Zyn53W96q4rh4d4tR0HKHBL3gM0Lff3z7YzgddSHbqVX39MixKrPGAWofPf2rYNzuWJ4KYu6uvocsa0H9iHGRlCXoQPh5OkTkamEm3Ee0AcFy/CtgjWFmQJbxHcLK+BvKnsk/9KhK0WGkBWmwXvigCXdIPLvoMGp+6dhSQi1f3h07EcV/krNitMRE0zcNNItF3YrrgoBvxbBnEoYujPMhPBHbNAavwNE5ghYcIAUjh+c68B0J/FoZ5t3AV4H40+9cbQgYawmXBBxrYOQ6j7B+IuBFZg6Jzzbup4N+xXPXjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mAZsNAz9rX57qDjhaI5L4DRsQiSpZbIU43MbFP/PU9Y=;
 b=G31vd5bVu+s4CIlj7GvhbHrjspp8kLSJWvrLcxoSng4RSOtU5cm97BBWupsE3xVCHUgd8g5HvF+FsWnBF9jo+PpPSF5Uma5Gi33A+Y15Jjq6lFxC/e7ef4E/TBMS2Ze71menV/cWR2uawG7wk8USXN1lJxKDKr2JRlaSC4wsT2M=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6208.namprd04.prod.outlook.com (20.178.248.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.16; Fri, 2 Aug 2019 07:48:44 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:48:43 +0000
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
Subject: [RFC PATCH v2 17/19] RISC-V: KVM: Add SBI v0.1 support
Thread-Topic: [RFC PATCH v2 17/19] RISC-V: KVM: Add SBI v0.1 support
Thread-Index: AQHVSQa1Rkael+9fmkqpDsQP+NHgHA==
Date:   Fri, 2 Aug 2019 07:48:43 +0000
Message-ID: <20190802074620.115029-18-anup.patel@wdc.com>
References: <20190802074620.115029-1-anup.patel@wdc.com>
In-Reply-To: <20190802074620.115029-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PN1PR01CA0111.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00::27)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.161]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 39164e97-db5d-484d-2fa4-08d7171dd768
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6208;
x-ms-traffictypediagnostic: MN2PR04MB6208:
x-microsoft-antispam-prvs: <MN2PR04MB6208DF6452150581318979A28DD90@MN2PR04MB6208.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(136003)(39860400002)(396003)(376002)(346002)(199004)(189003)(99286004)(7736002)(305945005)(9456002)(50226002)(2906002)(8936002)(14444005)(256004)(3846002)(14454004)(86362001)(5660300002)(6116002)(478600001)(53936002)(316002)(66446008)(64756008)(66476007)(66946007)(66556008)(6512007)(68736007)(81166006)(81156014)(102836004)(55236004)(76176011)(71190400001)(386003)(25786009)(6506007)(54906003)(71200400001)(110136005)(78486014)(476003)(8676002)(446003)(44832011)(66066001)(6436002)(52116002)(2616005)(1076003)(186003)(7416002)(486006)(36756003)(6486002)(4326008)(26005)(11346002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6208;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XBQVS2+Ui03vLUWcdxb/x/OhRJ379YWE2zqBGWFNFPab59VTBCQEg6jFgmEq5Nxr/INLEJ83joeclqvAUd5yC+ck4w74qLC3yXSw7DMplBRXvbmTQVi1BUP1FM4cGznl6j2+P2OO1Jnbd2NmfUfjL74fXOa8Ee+pyaqfsaUaiwMZnslA06XPsjJXhzrPVLv7YHXUIVBaPoHJG6v7DFeXHcyc15mM8x6gedvFak+Fh4jlfGg6JFhE2qzec+brok3AWYCT1nAEoGtIP/0417Es+ExsMOW1Ln3WPonjqljURU0Ld6b/PvWfR3sniUjkC+sLsRqnpaQG+gSrzJLlA2wrLSbDuHnI1/8vINF6AygkppVHhSpT/cso68Ds41I+OA7FCRXIl+RtHJX+h6Jh3D/ZvyE5D7Uig4Q64q7kPaCA46w=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39164e97-db5d-484d-2fa4-08d7171dd768
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:48:43.3353
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
 arch/riscv/kvm/vcpu_sbi.c         | 119 ++++++++++++++++++++++++++++++
 4 files changed, 125 insertions(+), 1 deletion(-)
 create mode 100644 arch/riscv/kvm/vcpu_sbi.c

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 08990ecd2260..edd9e6d2e811 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -223,4 +223,6 @@ bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu=
);
 void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
 void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
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
index f4ddf357ded8..96565fa19771 100644
--- a/arch/riscv/kvm/vcpu_exit.c
+++ b/arch/riscv/kvm/vcpu_exit.c
@@ -532,6 +532,9 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct k=
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
index 000000000000..5793202eb514
--- /dev/null
+++ b/arch/riscv/kvm/vcpu_sbi.c
@@ -0,0 +1,119 @@
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
+/* TODO: Handle traps due to unpriv load and redirect it back to VS-mode *=
/
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
+	/*
+	 * TODO: There should be a way to call remote hfence.bvma.
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

