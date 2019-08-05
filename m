Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B0981D8E
	for <lists+kvm@lfdr.de>; Mon,  5 Aug 2019 15:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730300AbfHENnQ (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 5 Aug 2019 09:43:16 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:56694 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729788AbfHENnP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 5 Aug 2019 09:43:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1565012595; x=1596548595;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=fNJltIwYdr8ijCREeGRBCZssuq5vdqD2HAF1dRLQsCk=;
  b=iE+mn3FJGHKTfdC7hqt3GsXrmebeXIiOvPdDmmYMHiwm2mkXQSJy2BVD
   QYxj3uItxD1wkgZ9I23aRrdiglha3z0jn1HJwBUmZvSzzTKsRlsdpBL0W
   6uI1zolXvSD9iQSP1P7zgbupz5MNcRPZeOm1V0WQczZ/Bxmh4ob6S2Yz2
   MvSXJzX4Lzv+lyIStP3H6m+UfapKGH8LVWtJDHtXRZRRYBDyPhup2/YZu
   sNHCNu0cyDVHbSVb0u1wxdplcRiOZYSe3s6grqWn4QrXM8L2QCXsayb9S
   /8TxzIu0u16zKB1twMzmFt1jnCvKdbjUXFGale0tl4osNykpOu/ZbWDV5
   Q==;
IronPort-SDR: KuA9dASWIH2t5Ai3BoVJA+UHG5F7M2ryQWC3gHU/A0YRXjBwCFgf7yJlSSGiFE0PoK73Wd1YnV
 naUGiRNawIb9qSFprc+PmAiIq9vVkwjD1ht52dWiEf8S0maw6oW86UQwI1sNyypJxV4b11w207
 MM4+TyoKl/nGvZhA4JciUxO//Jh6nDRjcsIOItlfJJOutc4RmSqrbKN77PtJXSwyVEsJyp1LgT
 9SvKEAjt6ozPlelQ2HlZcPR6XzlTJ1dFZBclroK8ktQFPdjJKKY64qP7yDzbG0mzSGMt6ka03e
 B4g=
X-IronPort-AV: E=Sophos;i="5.64,350,1559491200"; 
   d="scan'208";a="115017190"
Received: from mail-by2nam05lp2058.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.58])
  by ob1.hgst.iphmx.com with ESMTP; 05 Aug 2019 21:43:13 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VTRNTCwv7hwXWJx2TeHDlkR//+Fz04sb1vl/w48IuXZfksB9OFbfuT6luVAGfv/0Il5+QoMa9VLjggOH+WycbQXRe3/vb+mki2Bhs1ssP3+MsfOjJBJdYq7pUxRvlRVx7bLhK3fPlx01B5ArgfRqCyMzIq1q7swyfReUDBKIEH/ZTQ6YTYQ+lnSzsuQ6yM9NOV3hUxIa14pZ+l77fk3Y/dg/A0T3O7iGegIcFHUTUmRK1NGS2LBIKTH5ZM2599Y9ITIMNgid0pPjzZ7smv+jSWUafJe0Dphms5Xkf/E7flfUKzjYFr8ea6iYT4zLPWETHnfdYcADmQ8BwBOBryijaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tbIuVwLba6skLriTQzypUiplH93H5O2y73OFxIxT2M=;
 b=aDHF+xWGiNr4WvFfFw3UD/rIbfg3ngPBetCpBLoZJuer9ck8xzbfGA9xnKY0fkqxeDZH8pndY7kYwUveQ9Y1SokfgVpU9zarF2lSA2LxfGhJnOVFxSM+KTjEkzI8nbYoF09MIlg3AoB7O8cUJb9mikeEXf30keHkZfO/VSu2ixlf2EDcttoTM8a6DnMBDxlijJ5vO0+T3ReQsa1VO3zdIt1ZTL/nWDnTnbXFG/WRQX1Y9G3XDAJqJ3b+LmCQq7Qf5mbEVVQQNrAmbTHg6SR8nFYtTPJoBUkOrKfQuX4Ii4lNDicjSEdvix8pLuLPH3PNZiff6PMt8irm0l8eQ81sag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+tbIuVwLba6skLriTQzypUiplH93H5O2y73OFxIxT2M=;
 b=k95FyzsjAfrY1dp7jp+PHdoQ4rwzVjJR9mqaXvuA/YgPzf/bHyKdSpwIpi6Ywme5++IGPBV2J113dQrBAolNcCjT1K8AonJOY5rA6GSDT0EBcamvpYkjsbdUn2hvDqGVXqE4R2iLvZgVCicXq4o3CPohFtWKO6FruqVqC436iBc=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB6159.namprd04.prod.outlook.com (20.178.249.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2136.17; Mon, 5 Aug 2019 13:43:12 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.018; Mon, 5 Aug 2019
 13:43:12 +0000
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
Subject: [PATCH v3 06/19] RISC-V: KVM: Implement VCPU interrupts and requests
 handling
Thread-Topic: [PATCH v3 06/19] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
Thread-Index: AQHVS5O5VLfG1lcyN0eiG8Evb5/Bsg==
Date:   Mon, 5 Aug 2019 13:43:12 +0000
Message-ID: <20190805134201.2814-7-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 72979dfd-3a5a-4475-74be-08d719aadbac
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB6159;
x-ms-traffictypediagnostic: MN2PR04MB6159:
x-microsoft-antispam-prvs: <MN2PR04MB6159DE19E56B61A42CC7AED48DDA0@MN2PR04MB6159.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:747;
x-forefront-prvs: 01208B1E18
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(366004)(396003)(376002)(346002)(189003)(199004)(66556008)(66476007)(71190400001)(71200400001)(110136005)(54906003)(66946007)(66446008)(64756008)(86362001)(5660300002)(102836004)(52116002)(55236004)(14454004)(99286004)(386003)(78486014)(316002)(256004)(14444005)(6506007)(76176011)(2616005)(6486002)(8676002)(9456002)(8936002)(36756003)(3846002)(6116002)(6512007)(4326008)(2906002)(476003)(305945005)(44832011)(81156014)(81166006)(26005)(186003)(486006)(11346002)(25786009)(7736002)(1076003)(50226002)(478600001)(68736007)(446003)(53936002)(66066001)(6436002)(7416002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB6159;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: IoR8epqylu2z5us2nIv9Sy0J1H145huoYVPS8pJA9Zp8Ti82ODxlMiTTEA1tm88T/sLn9Rf4bD1KJQiBNW5So8kW4BuyOeJZPA+JEqk5OJSultkDsi9qn8vVjxDGUIUcMlkQRspsRf0kAnhNPpDI+yCU+y7q+aYiQyETH20wicVr8GxcAwvdfwPZTh/crxD/hDyAcU07gLkXjtks0769/QK9Yk/qmkoRXw6GrJ98FCwTrbWd2QPVygqel4pkbVTpi2Ux5lO7rksFpsafpQyjus2Gcoh7JA1T9sZLWaZP9O6n0Pago24DLHXLQdxiPCCXbsuWK2lI4GblTFcM78yBx5galGNxFq+MyaQO5tnObRrB1JPgx6/rAdB008IzZ13W2h3FjqMQJIwGhuaBExDUTGRYMux6ZE5RlP4Nss48Z1o=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72979dfd-3a5a-4475-74be-08d719aadbac
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2019 13:43:12.1379
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

This patch implements VCPU interrupts and requests which are both
asynchronous events.

The VCPU interrupts can be set/unset using KVM_INTERRUPT ioctl from
user-space. In future, the in-kernel IRQCHIP emulation will use
kvm_riscv_vcpu_set_interrupt() and kvm_riscv_vcpu_unset_interrupt()
functions to set/unset VCPU interrupts.

Important VCPU requests implemented by this patch are:
KVM_REQ_SLEEP       - set whenever VCPU itself goes to sleep state
KVM_REQ_VCPU_RESET  - set whenever VCPU reset is requested

The WFI trap-n-emulate (added later) will use KVM_REQ_SLEEP request
and kvm_riscv_vcpu_has_interrupt() function.

The KVM_REQ_VCPU_RESET request will be used by SBI emulation (added
later) to power-up a VCPU in power-off state. The user-space can use
the GET_MPSTATE/SET_MPSTATE ioctls to get/set power state of a VCPU.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h |  23 ++++
 arch/riscv/include/uapi/asm/kvm.h |   3 +
 arch/riscv/kvm/main.c             |   2 +
 arch/riscv/kvm/vcpu.c             | 169 +++++++++++++++++++++++++++---
 4 files changed, 184 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index dab32c9c3470..04804f14f760 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -122,6 +122,21 @@ struct kvm_vcpu_arch {
 	/* CPU CSR context upon Guest VCPU reset */
 	struct kvm_vcpu_csr guest_reset_csr;
=20
+	/*
+	 * VCPU interrupts
+	 *
+	 * We have a lockless approach for tracking pending VCPU interrupts
+	 * implemented using atomic bitops. The irqs_pending bitmap represent
+	 * pending interrupts whereas irqs_pending_mask represent bits changed
+	 * in irqs_pending. Our approach is modeled around multiple producer
+	 * and single consumer problem where the consumer is the VCPU itself.
+	 */
+	unsigned long irqs_pending;
+	unsigned long irqs_pending_mask;
+
+	/* VCPU power-off state */
+	bool power_off;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
=20
@@ -146,4 +161,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
=20
 static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) =
{}
=20
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
);
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
+bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/as=
m/kvm.h
index d15875818b6e..6dbc056d58ba 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -18,6 +18,9 @@
=20
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
=20
+#define KVM_INTERRUPT_SET	-1U
+#define KVM_INTERRUPT_UNSET	-2U
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 };
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index a26a68df7cfc..f4a7a3c67f8e 100644
--- a/arch/riscv/kvm/main.c
+++ b/arch/riscv/kvm/main.c
@@ -48,6 +48,8 @@ int kvm_arch_hardware_enable(void)
 	hideleg |=3D SIE_SEIE;
 	csr_write(CSR_HIDELEG, hideleg);
=20
+	csr_write(CSR_VSIP, 0);
+
 	return 0;
 }
=20
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index ff08d138f7c3..455b0f40832b 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -40,6 +40,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
 				 RISCV_ISA_EXT_s | \
 				 RISCV_ISA_EXT_u)
=20
+static DEFINE_PER_CPU(unsigned long, vsip_shadow);
+
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
@@ -50,6 +52,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
=20
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
@@ -116,8 +121,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return READ_ONCE(vcpu->arch.irqs_pending) & (1UL << IRQ_S_TIMER);
 }
=20
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -130,20 +134,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
=20
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return (kvm_riscv_vcpu_has_interrupt(vcpu) &&
+		!vcpu->arch.power_off && !vcpu->arch.pause);
 }
=20
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_vcpu_exiting_guest_mode(vcpu) =3D=3D IN_GUEST_MODE;
 }
=20
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return false;
+	return (vcpu->arch.guest_context.sstatus & SR_SPP) ? true : false;
 }
=20
 bool kvm_arch_has_vcpu_debugfs(void)
@@ -164,7 +166,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, =
struct vm_fault *vmf)
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
-	/* TODO; */
+	struct kvm_vcpu *vcpu =3D filp->private_data;
+	void __user *argp =3D (void __user *)arg;
+
+	if (ioctl =3D=3D KVM_INTERRUPT) {
+		struct kvm_interrupt irq;
+
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			return -EFAULT;
+
+		if (irq.irq =3D=3D KVM_INTERRUPT_SET)
+			return kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_EXT);
+		else
+			return kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_EXT);
+	}
+
 	return -ENOIOCTLCMD;
 }
=20
@@ -213,18 +229,103 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vc=
pu, struct kvm_regs *regs)
 	return -EINVAL;
 }
=20
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	unsigned long mask, val;
+
+	if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
+		mask =3D xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
+		val =3D READ_ONCE(vcpu->arch.irqs_pending) & mask;
+
+		csr->vsip &=3D ~mask;
+		csr->vsip |=3D val;
+	}
+}
+
+void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.guest_csr.vsip =3D csr_read(CSR_VSIP);
+	vcpu->arch.guest_csr.vsie =3D csr_read(CSR_VSIE);
+}
+
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
+{
+	if (irq !=3D IRQ_S_SOFT &&
+	    irq !=3D IRQ_S_TIMER &&
+	    irq !=3D IRQ_S_EXT)
+		return -EINVAL;
+
+	set_bit(irq, &vcpu->arch.irqs_pending);
+	smp_mb__before_atomic();
+	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+
+	kvm_vcpu_kick(vcpu);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
)
+{
+	if (irq !=3D IRQ_S_SOFT &&
+	    irq !=3D IRQ_S_TIMER &&
+	    irq !=3D IRQ_S_EXT)
+		return -EINVAL;
+
+	clear_bit(irq, &vcpu->arch.irqs_pending);
+	smp_mb__before_atomic();
+	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+
+	return 0;
+}
+
+bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	return (READ_ONCE(vcpu->arch.irqs_pending) &
+		vcpu->arch.guest_csr.vsie) ? true : false;
+}
+
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.power_off =3D true;
+	kvm_make_request(KVM_REQ_SLEEP, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.power_off =3D false;
+	kvm_vcpu_wake_up(vcpu);
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	/* TODO: */
+	if (vcpu->arch.power_off)
+		mp_state->mp_state =3D KVM_MP_STATE_STOPPED;
+	else
+		mp_state->mp_state =3D KVM_MP_STATE_RUNNABLE;
+
 	return 0;
 }
=20
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	/* TODO: */
-	return 0;
+	int ret =3D 0;
+
+	switch (mp_state->mp_state) {
+	case KVM_MP_STATE_RUNNABLE:
+		vcpu->arch.power_off =3D false;
+		break;
+	case KVM_MP_STATE_STOPPED:
+		kvm_riscv_vcpu_power_off(vcpu);
+		break;
+	default:
+		ret =3D -EINVAL;
+	}
+
+	return ret;
 }
=20
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
@@ -248,7 +349,37 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
=20
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct swait_queue_head *wq =3D kvm_arch_vcpu_wq(vcpu);
+
+	if (kvm_request_pending(vcpu)) {
+		if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
+			swait_event_interruptible_exclusive(*wq,
+						((!vcpu->arch.power_off) &&
+						(!vcpu->arch.pause)));
+
+			if (vcpu->arch.power_off || vcpu->arch.pause) {
+				/*
+				 * Awaken to handle a signal, request to
+				 * sleep again later.
+				 */
+				kvm_make_request(KVM_REQ_SLEEP, vcpu);
+			}
+		}
+
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_riscv_reset_vcpu(vcpu);
+	}
+}
+
+static void kvm_riscv_update_vsip(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+	unsigned long *vsip =3D this_cpu_ptr(&vsip_shadow);
+
+	if (*vsip !=3D csr->vsip) {
+		csr_write(CSR_VSIP, csr->vsip);
+		*vsip =3D csr->vsip;
+	}
 }
=20
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
@@ -311,6 +442,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
 		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
 		smp_mb__after_srcu_read_unlock();
=20
+		/*
+		 * We might have got VCPU interrupts updated asynchronously
+		 * so update it in HW.
+		 */
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+
+		/* Update VSIP CSR for current CPU */
+		kvm_riscv_update_vsip(vcpu);
+
 		if (ret <=3D 0 ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode =3D OUTSIDE_GUEST_MODE;
@@ -334,6 +474,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		scause =3D csr_read(CSR_SCAUSE);
 		stval =3D csr_read(CSR_STVAL);
=20
+		/* Syncup interrupts state with HW */
+		kvm_riscv_vcpu_sync_interrupts(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in VS/VU-mode (i.e.
 		 * while executing the guest). This interrupt is still
--=20
2.17.1

