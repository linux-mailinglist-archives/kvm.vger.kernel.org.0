Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED0D47EDD4
	for <lists+kvm@lfdr.de>; Fri,  2 Aug 2019 09:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390198AbfHBHrg (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 2 Aug 2019 03:47:36 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:64698 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390136AbfHBHrf (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 2 Aug 2019 03:47:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1564732055; x=1596268055;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=ao9lvfAsBUQHfJsvbsOCRKz1Wjg15Xbpx74VLdEZeCo=;
  b=r3WAlwZj7l/7QcuDWJoiEYtBoucsSDG2gotz8c2/e9Rfn95+c1mOI3DS
   ir6tHV3O5vf03PmMJa1CfMSsKT29N9FoiGYk/mw0B95k2ccFUI/Nkc5ah
   /yMgDyDWH7iq4DKX0q2hgI8SMqWesMu7uK/YW4Mg2ahB76kADsmGtLZW3
   mM8v71j97kyyZ66DBHnwkxSohQtIVs/afJQSxq06PaVX7KjN6J7RgZ2KC
   /DXOmVAGNYq47XwIRTih8z026XSj78DCXa9WGrbLie26nXCycOyueYW5F
   W79LQrjCkZtFp3JIf2qMHZS1+aaosEsY5YubsstcnWQXF7Pn09/KTDf5u
   w==;
IronPort-SDR: tUIVsHYWSzqVhXPXlki9X5vAqlbqLTBqMJvMtfY4PPjdQUjRGoDjS/cVeHj6a+sI48lvHBAZ+S
 2IMO4HpMMHStWAqBmr77jf87joJeYaGlXatjbSLrSvnQ70kXWtR/HR+VJvxVXVaX+2BnuGN51X
 n6deAgoyrWjWXaQUKuQ/IZyR6a5ab/09fCSv0yhifovbyMrxfHlJj1ca2k+y1kQNbJq3KdQTJ5
 CaH3Zg1wEC2y5U35KVI6WbpeVwr7+C28R8xhITnN3vrdxgZqtBsthgj+t9/eaItTcuT/Jj/Fjj
 xRw=
X-IronPort-AV: E=Sophos;i="5.64,337,1559491200"; 
   d="scan'208";a="116382469"
Received: from mail-cys01nam02lp2051.outbound.protection.outlook.com (HELO NAM02-CY1-obe.outbound.protection.outlook.com) ([104.47.37.51])
  by ob1.hgst.iphmx.com with ESMTP; 02 Aug 2019 15:47:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=acfnvcXz0xW3aYcrk2ZM+BlHLANveYBq72Lz5Oeap/UbpcK1OrVTjSXL2RAI4btJZeEFwbS/TNQ2kPqNaQi4CGSERZSgiN9Dqds35F48CnNIZH5DNmgZoRZAG9/nc4aJcEWsKsW3WfD+iAA0I3q61CYKhbXbnSBL8GXxNeEwDETc5qNLNz6pZUJfKWgalQtUs2AGdVw2ctSAAnizf2bOhbkvHj/62v2KGflRKDZdLWuTboeM86FQcoiz12YAp7vkloWdbvC1PdTlrCGsxyLcBWDe1nozjpsbfnCH3ozxOLpZb5rYTghmTz/FNy6nHW+VSxMnDdInZ41YKLS+LoiDKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uq8jqN6lrBvbC1UbqGyQZSZd0m4XW60F8UQRxfSqMJM=;
 b=kY9xiu8zm74WmBO5YFzXTGMbgBDLWxXtzdvnzfFEdyAvsXs1A5XDxX5MxfQXi9Y3NScAwcFQpuxCPtcKZo9hGWn8F/CPl8TuvbFEtjcV/Rd7+qNBtNrRinpWtA1aaQ2xmKn7epJ8nFt2JMklTwEUOwQzKEKfvR2TAooGqhInPEqxREC2rPUVB9gwpZ2x+kVBqfe2KpHIOqJ/aFO1psDN3qxtl/93zbMMl8z6aryVMsnODV/5t4OALi4MZwLRlHZ0u6Wj+P4VxgA+xP8eJqCRnuKRvIXqRfu4GDs14hr/lSyDS7qPuJVwKID44pmbxwpF1sxpcG4FLlWLGhQVk1qVjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=wdc.com;dmarc=pass action=none header.from=wdc.com;dkim=pass
 header.d=wdc.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Uq8jqN6lrBvbC1UbqGyQZSZd0m4XW60F8UQRxfSqMJM=;
 b=jic8gImc9zL10kcb67xnfV2jiG5GYPuleg/wADg7wOE+Z8jIVNnkQaQjd5LbYettD9PbMihv2NwD+g5JBLK6R3R5h33hZztvPZDBbF73i5C++y8jN4BLHldNXbhR5/yWGR8jiQhJUtSrLKy1A3posC/ODcPg7NZsv0K79XgnXT8=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB5566.namprd04.prod.outlook.com (20.178.248.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 07:47:31 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a815:e61a:b4aa:60c8%7]) with mapi id 15.20.2136.010; Fri, 2 Aug 2019
 07:47:31 +0000
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
Subject: [RFC PATCH v2 06/19] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
Thread-Topic: [RFC PATCH v2 06/19] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
Thread-Index: AQHVSQaK+6rSg7PDFUyWxfV7VraIlw==
Date:   Fri, 2 Aug 2019 07:47:31 +0000
Message-ID: <20190802074620.115029-7-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 030750f8-7644-40d4-9619-08d7171dac72
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(7168020)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MN2PR04MB5566;
x-ms-traffictypediagnostic: MN2PR04MB5566:
x-microsoft-antispam-prvs: <MN2PR04MB5566D3A1392D4C64239EA3EC8DD90@MN2PR04MB5566.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(979002)(4636009)(346002)(376002)(39850400004)(136003)(366004)(396003)(189003)(199004)(36756003)(14454004)(7736002)(54906003)(6116002)(102836004)(110136005)(71190400001)(446003)(4326008)(3846002)(5660300002)(52116002)(66066001)(2906002)(25786009)(6486002)(6506007)(386003)(55236004)(76176011)(316002)(53936002)(6436002)(305945005)(9456002)(81156014)(64756008)(66476007)(78486014)(86362001)(66556008)(66946007)(8936002)(11346002)(476003)(68736007)(81166006)(2616005)(478600001)(486006)(26005)(1076003)(99286004)(50226002)(14444005)(256004)(71200400001)(66446008)(186003)(6512007)(44832011)(8676002)(7416002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB5566;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /LggDvpP1CqwV9MGv3a/eirKvZL7V/bgdj8nEnW0GfNqgwssnoPNbifJUPjnPfmhoAonj2Xuawm01ZcC1oAJKJFj/RUI+9mNy9X4DNjvToprvP6fNJQGOVdnA7xvspuKLigEy9hSIfH/GqG46WTO/olzuJX2o94VhQV5po/nazj2uKP5TEDo6w99V9CF719FNONvEAkYtdFHK2wXAhW8HkDjl5cAV4KmvGC5I1cdKw9Gh4xH2jEZ+ydtIZnoDpRreFpK+LkebnolaDjzcKwn9tjjHnUuuZog8SA5MW4TawabjpMeNLWV9mLU3E1AOw7V1nxiadUPJkO4NfHqWkRwTOP+X/t8zg2Pfbu6BLaRYyJ6IIcfPyfDFwAZXfXY8++H5HU6ZFip6qPkAD89tA3WJAR3kT6pc/4I3+tsKkCdd34=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 030750f8-7644-40d4-9619-08d7171dac72
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 07:47:31.2924
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Anup.Patel@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB5566
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
 arch/riscv/include/asm/kvm_host.h |  18 +++-
 arch/riscv/include/uapi/asm/kvm.h |   3 +
 arch/riscv/kvm/vcpu.c             | 157 ++++++++++++++++++++++++++----
 3 files changed, 158 insertions(+), 20 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 7fda09327d39..a6d81e5eb064 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -26,8 +26,7 @@
=20
 #define KVM_REQ_SLEEP \
 	KVM_ARCH_REQ_FLAGS(0, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
-#define KVM_REQ_IRQ_PENDING		KVM_ARCH_REQ(1)
-#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(2)
+#define KVM_REQ_VCPU_RESET		KVM_ARCH_REQ(1)
=20
 struct kvm_vm_stat {
 	ulong remote_tlb_flush;
@@ -123,6 +122,13 @@ struct kvm_vcpu_arch {
 	/* CPU CSR context upon Guest VCPU reset */
 	struct kvm_vcpu_csr guest_reset_csr;
=20
+	/* VCPU interrupts */
+	unsigned long irqs_pending;
+	unsigned long irqs_pending_mask;
+
+	/* VCPU power-off state */
+	bool power_off;
+
 	/* Don't run the VCPU (blocked) */
 	bool pause;
 };
@@ -144,4 +150,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
kvm_run *run,
=20
 static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) =
{}
=20
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq=
);
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu, bool update_hw=
);
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
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 45af069c1665..8e1ebdf1ef15 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -50,6 +50,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
=20
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
@@ -116,8 +119,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return READ_ONCE(vcpu->arch.irqs_pending) & (1UL << IRQ_S_TIMER);
 }
=20
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -130,20 +132,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
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
@@ -164,7 +164,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, =
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
@@ -213,18 +227,105 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vc=
pu, struct kvm_regs *regs)
 	return -EINVAL;
 }
=20
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu, bool update_hw=
)
+{
+	unsigned long mask, val;
+
+	if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
+		mask =3D xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
+		val =3D READ_ONCE(vcpu->arch.irqs_pending) & mask;
+
+		vcpu->arch.guest_csr.vsip &=3D ~mask;
+		vcpu->arch.guest_csr.vsip |=3D val;
+
+		if (update_hw)
+			csr_write(CSR_VSIP, vcpu->arch.guest_csr.vsip);
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
@@ -248,14 +349,25 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
=20
-		/*
-		 * Clear IRQ_PENDING requests that were made to guarantee
-		 * that a VCPU sees new virtual interrupts.
-		 */
-		kvm_check_request(KVM_REQ_IRQ_PENDING, vcpu);
+		if (kvm_check_request(KVM_REQ_VCPU_RESET, vcpu))
+			kvm_riscv_reset_vcpu(vcpu);
 	}
 }
=20
@@ -310,6 +422,12 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
uct kvm_run *run)
 		 */
 		smp_store_mb(vcpu->mode, IN_GUEST_MODE);
=20
+		/*
+		 * We might have got VCPU interrupts updated asynchronously
+		 * so update it in HW.
+		 */
+		kvm_riscv_vcpu_flush_interrupts(vcpu, true);
+
 		if (ret <=3D 0 ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode =3D OUTSIDE_GUEST_MODE;
@@ -332,6 +450,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
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

