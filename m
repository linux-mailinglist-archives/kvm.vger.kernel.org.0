Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80BAB78B07
	for <lists+kvm@lfdr.de>; Mon, 29 Jul 2019 13:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387891AbfG2L45 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 29 Jul 2019 07:56:57 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:26912 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387853AbfG2L45 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 29 Jul 2019 07:56:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564401416; x=1595937416;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=aLB1BfTfKuxJNVzFxRln4I/cmLmHDRHmCnWQI7hJAw0=;
  b=ZkEFpieyjj+KEFQE2wktT3+g5CHum7aAy76T40LwGcJnEMRh94XWOipw
   SrJhAaKuX5Cc9+7m/OcG86zAT5lGE4BTsdCDA8QshdZfSZO5+zj9S7n+1
   z49nXBk0h37SRo+fuX/1pc4hSh+Rp1q1Voru3Hv+unyMDOTKQ6pxLTmNv
   h/+fA+c2Ka0384OUFtc8K5Kj1SwhL4/k5fBG2EMCwkQdrh0AGlgrwzAtQ
   CwzuScIMaLcQ1I8tWcK26gJIzX+c2SWgEcKpFuOr+dAQdMY4eouI64vOv
   Fef/OjZ1Gb5qMzzwYmXpVgQUagPGFHYLGrMA4/vPl5W/AZaIFAkGJQIIe
   w==;
IronPort-SDR: wXb12YM6RDUdK3BcVt4nirA/q/OFFx1YixwVlEsGZKuxxbtWLg2s+APhtSVNenWAdrmLfCsvD9
 wVNvMlkClwU5JvVl921qbb0P0hsr+kFcrQypKR2yA3CN8k4+IP3s2xtyhpvs2rrhb2BWdzEf+e
 WZnN+tGh8J1W3IcUmxIZubM8ti8k0e9k/hWce8Bgyiij5peiwMmSEr8X5bZZu4BPAhp4r9ci4l
 7zAqIT1OHJS5XYs9fFRR4istXsntHN4eKhUcg4c0APNZQqUmYUuO10y/Z42qc3ESXOf6y6FhRj
 2ts=
X-IronPort-AV: E=Sophos;i="5.64,322,1559491200"; 
   d="scan'208";a="114381574"
Received: from mail-by2nam01lp2053.outbound.protection.outlook.com (HELO NAM01-BY2-obe.outbound.protection.outlook.com) ([104.47.34.53])
  by ob1.hgst.iphmx.com with ESMTP; 29 Jul 2019 19:56:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aecmcPgbdAyvAU8+oD/Ji3Pyj3r7GQw6T1rKJwyBMOed7nroLq2/OYmcQkp+UNobaQDTlhBTQfWo2UGueqDdJz22beJILleEwDzBf4gsm0UrnsfRWNhGLSzJga0jA7iTiR++ez43Mpb/jnQgb6u3wU/aQDgE6ZNrCN3S5kEYUarBTcfrLE22T/zOYbQ6xv6jbxgfuG5i9GT5woX26mpiz8MFSmc07xOpxdgmKf8k7EomE1nv6p11nhrfBo5wRVbkLlbgfh82nw3+9knQaVpinqAfQJinhBsLyyXlbWRd8mYRRNLdL+Xwei1iDyWL15yLpNntr/uUyJPH68i9JDvVwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlcvlZeH45M8QdFmuudg+23ZuWKr3B0TfQzWEKFC9mI=;
 b=DmaLpHwtglzwYu4obUm2Iv52NUjJEmVt5435vcWnHddigmX0MQRVJxQmG89VXt8AP3MT4gCU8U1mSfSz/5z501ZzxgqBRRYDnVSUYeny22DE1cMa0OY/eMGvjRSKFXp55ZxQzzB5ezxQTR4dwwID9jk/Igj0elgfG48wHylRMM+uZnu6pTQQOppbgzh0kAVZlnrtdpuH2dEfLs5Shdkw/noJsD6Zxbi+burMgo/xkVvSJvyCkXn+trf7QdszeNjnYunhsyuae+qJmGT1j1bDErOnMSFXydemDlaezJ6eY7nnUsAy7fR77vbXMt/hc/aXlsoXg7ahxHbDVMhGUhh+IQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rlcvlZeH45M8QdFmuudg+23ZuWKr3B0TfQzWEKFC9mI=;
 b=Q3GDrM11qWDsOPBPkYct2TZTaf5NSsNvH0nNzo+uqGznNujrPFP5fh5SUwerx4tAcWFt8DhEFD+FqS41PqZ/0zCXUwDncRs77raf0DQeAAe6auNDvcSKaNkFzn1nlI39ao7//H2rDHDkMKjANYyGW7XvPALGBT8Ox7kFVcHl0sE=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5678.namprd04.prod.outlook.com (20.179.21.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 11:56:53 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 11:56:53 +0000
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
Subject: [RFC PATCH 05/16] RISC-V: KVM: Implement VCPU interrupts and requests
 handling
Thread-Topic: [RFC PATCH 05/16] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
Thread-Index: AQHVRgS2tKwUvYEsWk2qg6zYTK9XKg==
Date:   Mon, 29 Jul 2019 11:56:53 +0000
Message-ID: <20190729115544.17895-6-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: ed7fbf68-b92b-4c7d-d096-08d7141bd8b0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR04MB5678;
x-ms-traffictypediagnostic: MN2PR04MB5678:
x-microsoft-antispam-prvs: <MN2PR04MB567837B6F3AEE860FA5E79AA8DDD0@MN2PR04MB5678.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(136003)(366004)(396003)(346002)(199004)(189003)(7416002)(52116002)(6436002)(6486002)(7736002)(476003)(2616005)(2906002)(5660300002)(66066001)(4326008)(446003)(68736007)(11346002)(81156014)(81166006)(14454004)(53936002)(26005)(186003)(78486014)(99286004)(36756003)(44832011)(486006)(305945005)(8676002)(54906003)(110136005)(25786009)(8936002)(478600001)(76176011)(102836004)(71200400001)(6512007)(1076003)(66446008)(64756008)(66946007)(256004)(55236004)(316002)(9456002)(86362001)(66476007)(50226002)(66556008)(6506007)(386003)(71190400001)(14444005)(6116002)(3846002);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5678;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: i+ezUaeC/6xJm0SQt1ZXIp59VAKroCIg5fQneJmXVv3g5saz1mvY+sek8jdgyHnewJxC/cqfguweX3u2w5bBn8TFDyHka2gW9t/19cKGgH9dcWraZfb3TrGAshuPI+CsFsKGfdUuYqW0+hv8era+54bumB6C0RNSlG3H8bHiCPi/mTEuQYE840Z9YD1reXY+ZQXo1Yi/jRBQ5y/IcslyFy7jSPC9sukMlnQQQedBfk91XmYby3mamJ+BGYYA6lOE03LP4/lnr/LMr1qEpFqkWAakHXPu4/kYE04hTGCd+4i9iEWoBWe1ydncMw6DBFJ8e/iBcVMzvzIN4jXNCMrR/eEqZfkddsjcJ2eZO/PvLT6qXDTGyodnvdBCKX5s3NJbjRxX5tNlM5KJMsoCJ/DKlvst6Lh9wXa3MYLlKnBQD8Y=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed7fbf68-b92b-4c7d-d096-08d7141bd8b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 11:56:53.2391
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5678
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
KVM_REQ_IRQ_PENDING - set whenever some VCPU interrupt pending
KVM_REQ_SLEEP       - set whenever VCPU itself goes to sleep state
KVM_REQ_VCPU_RESET  - set whenever VCPU reset is requested

The WFI trap-n-emulate (added later) will use KVM_REQ_SLEEP request
and kvm_riscv_vcpu_has_interrupt() function.

The KVM_REQ_VCPU_RESET request will be used by SBI emulation (added
later) to power-up a VCPU in power-off state. The user-space can use
the GET_MPSTATE/SET_MPSTATE ioctls to get/set power state of a VCPU.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arch/riscv/include/asm/kvm_host.h |  13 +++
 arch/riscv/include/uapi/asm/kvm.h |   3 +
 arch/riscv/kvm/vcpu.c             | 174 +++++++++++++++++++++++++++---
 3 files changed, 177 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 244eabe62710..aa89f1922da1 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -125,6 +125,13 @@ struct kvm_vcpu_arch {
 	/* CPU CSR context upon Guest VCPU reset */
 	struct kvm_vcpu_csr guest_reset_csr;
=20
+	/* VCPU interrupts */
+	raw_spinlock_t irqs_lock;
+	unsigned long irqs_pending;
+
+	/* VCPU power-off state */
+	bool power_off;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
 };
@@ -146,6 +153,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
=20
 static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) =
{}
=20
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
);
+bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
+
 void kvm_riscv_halt_guest(struct kvm *kvm);
 void kvm_riscv_resume_guest(struct kvm *kvm);
=20
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
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 1ae806f28c0e..c6f57caa95f0 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -42,6 +42,7 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
=20
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
+	unsigned long f;
 	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
 	struct kvm_vcpu_csr *reset_csr =3D &vcpu->arch.guest_reset_csr;
 	struct kvm_cpu_context *cntx =3D &vcpu->arch.guest_context;
@@ -50,6 +51,10 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_lock, f);
+	vcpu->arch.irqs_pending =3D 0;
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_lock, f);
 }
=20
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
@@ -103,6 +108,9 @@ int kvm_arch_vcpu_init(struct kvm_vcpu *vcpu)
 	cntx->hstatus |=3D HSTATUS_SP2P;
 	cntx->hstatus |=3D HSTATUS_SPV;
=20
+	/* Setup VCPU irqs lock */
+	raw_spin_lock_init(&vcpu->arch.irqs_lock);
+
 	/* Setup reset state of HEDELEG and HIDELEG CSRs */
 	csr =3D &vcpu->arch.guest_reset_csr;
 	csr->hedeleg =3D 0;
@@ -131,8 +139,15 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	int ret;
+	unsigned long f, irqs;
+
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_lock, f);
+	irqs =3D vcpu->arch.irqs_pending & vcpu->arch.guest_csr.vsie;
+	ret =3D (irqs & (1UL << IRQ_S_TIMER)) ? 1 : 0;
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_lock, f);
+
+	return ret;
 }
=20
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -145,20 +160,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
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
@@ -179,7 +192,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, =
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
@@ -228,18 +255,113 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vc=
pu, struct kvm_regs *regs)
 	return -EINVAL;
 }
=20
+static void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
+{
+	unsigned long f;
+
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_lock, f);
+	if (vcpu->arch.irqs_pending ^ vcpu->arch.guest_csr.vsip) {
+		csr_write(CSR_VSIP, vcpu->arch.irqs_pending);
+		vcpu->arch.guest_csr.vsip =3D vcpu->arch.irqs_pending;
+	}
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_lock, f);
+}
+
+static void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.guest_csr.vsip =3D csr_read(CSR_VSIP);
+	vcpu->arch.guest_csr.vsie =3D csr_read(CSR_VSIE);
+}
+
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
+{
+	unsigned long f;
+
+	if (irq !=3D IRQ_S_SOFT &&
+	    irq !=3D IRQ_S_TIMER &&
+	    irq !=3D IRQ_S_EXT)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_lock, f);
+	vcpu->arch.irqs_pending |=3D (1UL << irq);
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_lock, f);
+
+	kvm_make_request(KVM_REQ_IRQ_PENDING, vcpu);
+	kvm_vcpu_kick(vcpu);
+
+	return 0;
+}
+
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
)
+{
+	unsigned long f;
+
+	if (irq !=3D IRQ_S_SOFT &&
+	    irq !=3D IRQ_S_TIMER &&
+	    irq !=3D IRQ_S_EXT)
+		return -EINVAL;
+
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_lock, f);
+	vcpu->arch.irqs_pending &=3D ~(1UL << irq);
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_lock, f);
+
+	return 0;
+}
+
+bool kvm_riscv_vcpu_has_interrupt(struct kvm_vcpu *vcpu)
+{
+	bool ret =3D false;
+	unsigned long f;
+
+	raw_spin_lock_irqsave(&vcpu->arch.irqs_lock, f);
+	if (vcpu->arch.irqs_pending & vcpu->arch.guest_csr.vsie)
+		ret =3D true;
+	raw_spin_unlock_irqrestore(&vcpu->arch.irqs_lock, f);
+
+	return ret;
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
@@ -263,8 +385,25 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
=20
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
+	struct swait_queue_head *wq =3D kvm_arch_vcpu_wq(vcpu);
+
 	if (kvm_request_pending(vcpu)) {
-		/* TODO: */
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
=20
 		/*
 		 * Clear IRQ_PENDING requests that were made to guarantee
@@ -317,6 +456,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
 			run->exit_reason =3D KVM_EXIT_INTR;
 		}
=20
+		/*
+		 * We might have got VCPU interrupts updated asynchronously
+		 * so update it in HW.
+		 */
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+
 		/*
 		 * Ensure we set mode to IN_GUEST_MODE after we disable
 		 * interrupts and before the final VCPU requests check.
@@ -347,6 +492,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
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

