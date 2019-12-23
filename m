Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C94212955E
	for <lists+kvm@lfdr.de>; Mon, 23 Dec 2019 12:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfLWLgP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 23 Dec 2019 06:36:15 -0500
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:54948 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726691AbfLWLgP (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 23 Dec 2019 06:36:15 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1577100973; x=1608636973;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=rImaFEsO4/cTEDsrpmUcUXoGskp8VukKGO2CENf7hfU=;
  b=fcUqd5PJjk7EuviPAiEr1nLn0njNRAXsJsemc+Y1UHXHrJSGHW1peskI
   blMopvcNC7qXZT/i4nRKeNNxU2vQgetgnoMs6uThr8J2pmfyDk2LGZgT/
   6vLcF6Be/L/VefbbGU8lASyV4yMvAkUaZ2Mjafu5wnMS6O0rhaOlbCSTv
   eoheyAWxxDpkh6V7zc8zGdcm4CbrHj5cOlt7eDsjaILlMLjL35tI/qPk0
   8N624NbRjDhONi8XnY98HQqpLJAX1ZVKpGvWvrseW8eBLIvSVXfgMm5ir
   z3EgEx40rfKIHwlo89Gcy3q18QuefR3KTuxmbLVgrmMVAR6v2LeYRpC/t
   w==;
IronPort-SDR: sGxJ/FW5W95A3mB6XWsOfLCzMAHGxMfkEIHPdleVJNSBTzK8id3egxXMovyYSZi2egWGAGDpuP
 CTwVH+hL1S0pu12ot6QayOP6puDCof2vo+hL/r/WJAb6UCD+2EbsemSvlqOcK7rgwCLmNNxlpQ
 upujnbUktoA8g2E2aLZpTnnvGOrFHTPcbmPCsA+0hZCbJ/LxtF0tuoPRnqLGbI5NmAR002taF4
 +f/eQqSSXG/w4wzvj4ow8MexOs9yBpQX0koZ4S7zImQtWkxIV6apkYSvUQpm3KBFb1jlsMLOuj
 xMQ=
X-IronPort-AV: E=Sophos;i="5.69,347,1571673600"; 
   d="scan'208";a="125956126"
Received: from mail-bn7nam10lp2105.outbound.protection.outlook.com (HELO NAM10-BN7-obe.outbound.protection.outlook.com) ([104.47.70.105])
  by ob1.hgst.iphmx.com with ESMTP; 23 Dec 2019 19:36:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BalS1xKOmNi4ePVewyHnFtvv3EMI6qdiwMUhQOzwuNjcFUfHxU38Tnc96zlXxfV7kgAQZHjJxhrRQcpc85DBSHB97zVlXeD31ulOwwXMuBNC8IGjxHTHE+DzCE1uad+IJWB7ZxePhkbWEdN1ZRvK6pyutjgbB1hfF3Hu3tyF7Clw931G54IIQOQLJI3Ly8iAPwfCUkAmfREZYNCEGtUWyShqw38KufWCt7XbUJfKBbkkHq4+k1nf0rZBTICDcq5g4eBx76XDkC1tUkpqTZSslG1991x0P0bZCjXtagL7QItO37aXkSD/ypnsuSoYSYmYEqrz0Ft2p2ph6F1MutdIbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvNRCrCgke5WD0TnY7dYW+Ja/QOqMJ9iwFfBOGz5U8s=;
 b=Ng0Pc52peGVS6exUD0kGcOdbRhLckfpueIpui5nfXXGIAb8iYbOzbiPbqKq+W8gYLcXJXojbLbOItB/rJ62uydNx/OMprATtk1yQozmbhIv1saGywdICgdi5kdTvqnYO70tgcSbEpbybRh66+TUkp1ULpyqqr7HE+UAsPZhGad7Tw42IWWBlhGk5uEtdgCrra+Au7AboeZB5nHInf7sFWA2pFRwtfGoU2Ya0o/W+4mbFpEWmnPMzYdtMtFShPKAYJljHv2frzyLQUxOOMyGst1RxLx4aCpNhRwDGA8Oo6JVKyHECXEvH6MVRXD6VT7+hgjaFYOYdg7jevNfBVzGf2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EvNRCrCgke5WD0TnY7dYW+Ja/QOqMJ9iwFfBOGz5U8s=;
 b=s7Go/iOH7Ljr+XH/oSA0dLHL5YKyEU2UGQ6OzXwxA1JGdYcByJJcDZKkrdZAx4OGw7m/R0Ar5vetid1W89Dz5jBtmgig8fX+yzK8yHImvTTltogZKaop1Fs2WvEGe0HTsg8yhfS2chNBC+f35a7zjkqPSJb8Yvk9xw7BzblQRIo=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7072.namprd04.prod.outlook.com (10.186.146.20) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2559.15; Mon, 23 Dec 2019 11:36:10 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::a9a0:3ffa:371f:ad89%7]) with mapi id 15.20.2559.017; Mon, 23 Dec 2019
 11:36:10 +0000
Received: from wdc.com (106.51.20.238) by MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 23 Dec 2019 11:36:05 +0000
From:   Anup Patel <Anup.Patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Radim K <rkrcmar@redhat.com>
CC:     Alexander Graf <graf@amazon.com>,
        Atish Patra <Atish.Patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Anup Patel <anup@brainfault.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "kvm-riscv@lists.infradead.org" <kvm-riscv@lists.infradead.org>,
        "linux-riscv@lists.infradead.org" <linux-riscv@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anup Patel <Anup.Patel@wdc.com>
Subject: [PATCH v10 06/19] RISC-V: KVM: Implement VCPU interrupts and requests
 handling
Thread-Topic: [PATCH v10 06/19] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
Thread-Index: AQHVuYUslzLNkMdBiUOsRkelWHGXJw==
Date:   Mon, 23 Dec 2019 11:36:10 +0000
Message-ID: <20191223113443.68969-7-anup.patel@wdc.com>
References: <20191223113443.68969-1-anup.patel@wdc.com>
In-Reply-To: <20191223113443.68969-1-anup.patel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MA1PR01CA0077.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00::17)
 To MN2PR04MB6061.namprd04.prod.outlook.com (2603:10b6:208:d8::15)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Anup.Patel@wdc.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [106.51.20.238]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 42f343a4-81c5-462c-ab11-08d7879c4eca
x-ms-traffictypediagnostic: MN2PR04MB7072:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7072D405F73BE9B6622ACE548D2E0@MN2PR04MB7072.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:1751;
x-forefront-prvs: 0260457E99
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(199004)(189003)(8886007)(478600001)(52116002)(316002)(16526019)(2906002)(8936002)(1076003)(7696005)(36756003)(66946007)(66476007)(86362001)(66446008)(26005)(64756008)(66556008)(4326008)(5660300002)(8676002)(186003)(7416002)(81156014)(2616005)(956004)(71200400001)(55016002)(44832011)(55236004)(81166006)(1006002)(54906003)(110136005)(6666004)(32040200004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7072;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tSIlT+WPr/IAu0GP/F54jfEtyYigGI4u2yiDXwtZreGmX4me8nYLoHaUHebVy9n9FslRuuOkrpkwrAk1werLTBPWEkqe27+uwWy+yys6kHJBGGCjcghFYI2mccbuaRiugx7Kdf3R8J4aRrZooUzQKMyKaPS3NSySUuVmJCZaUTYoVy7w0Bjbpoz1x4s2/pbdhFJNvky77G8jKMNt2AzKGFL4YRrSvTteHmPPkkSQeGeFS4P5JRgwIC2v7BYSVTMqD2OKXTy1z6Tl5RPctmtGt25RnkTxuqCZJVrJR4Uu4FU2sdhrMvRJJXJbzT49EHmXrcsdy51r11A2Am5akMvlXRssveMHQRq9ADPUCdEwaYDZDCAxWGB8NcJx0mBRNIBoQrc4plAOT9qEo/HZMGi0ND68F6tlCCilb2vvZMp1/yuC4Vp/LIsxvZUMJrclUUqPZOKv2tHlxqPNBDeYFumOceKoPFSoieuEiXBrR5zQFSr67deEyWGvN9eVPSOIAxGA
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 42f343a4-81c5-462c-ab11-08d7879c4eca
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Dec 2019 11:36:10.5775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X+Vzt6kBQyRg6qbVGMYxl9eTbgNVy4/W8SIsBomkm28hXWz/vaBWDaPgi+WXX2St1VgWYWG8RF2qcZKoboORow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7072
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
Acked-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alexander Graf <graf@amazon.com>
---
 arch/riscv/include/asm/kvm_host.h |  23 ++++
 arch/riscv/include/uapi/asm/kvm.h |   3 +
 arch/riscv/kvm/vcpu.c             | 182 +++++++++++++++++++++++++++---
 3 files changed, 195 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index 297431660be6..94ae81220ac6 100644
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
@@ -147,4 +162,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
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
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long ma=
sk);
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
index cf8ca8d4a9ea..989f2be83c19 100644
--- a/arch/riscv/kvm/vcpu.c
+++ b/arch/riscv/kvm/vcpu.c
@@ -11,6 +11,7 @@
 #include <linux/err.h>
 #include <linux/kdebug.h>
 #include <linux/module.h>
+#include <linux/percpu.h>
 #include <linux/uaccess.h>
 #include <linux/vmalloc.h>
 #include <linux/sched/signal.h>
@@ -50,6 +51,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
=20
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
@@ -116,8 +120,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
 }
=20
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -130,20 +133,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
=20
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
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
@@ -164,7 +165,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, =
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
+			return kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
+		else
+			return kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
+	}
+
 	return -ENOIOCTLCMD;
 }
=20
@@ -213,18 +228,121 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vc=
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
+		csr->hip &=3D ~mask;
+		csr->hip |=3D val;
+	}
+}
+
+void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
+{
+	unsigned long hip;
+	struct kvm_vcpu_arch *v =3D &vcpu->arch;
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+
+	/* Read current HIP and HIE CSRs */
+	hip =3D csr_read(CSR_HIP);
+	csr->hie =3D csr_read(CSR_HIE);
+
+	/* Sync-up HIP.VSSIP bit changes does by Guest */
+	if ((csr->hip ^ hip) & (1UL << IRQ_VS_SOFT)) {
+		if (hip & (1UL << IRQ_VS_SOFT)) {
+			if (!test_and_set_bit(IRQ_VS_SOFT,
+					      &v->irqs_pending_mask))
+				set_bit(IRQ_VS_SOFT, &v->irqs_pending);
+		} else {
+			if (!test_and_set_bit(IRQ_VS_SOFT,
+					      &v->irqs_pending_mask))
+				clear_bit(IRQ_VS_SOFT, &v->irqs_pending);
+		}
+	}
+}
+
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
+{
+	if (irq !=3D IRQ_VS_SOFT &&
+	    irq !=3D IRQ_VS_TIMER &&
+	    irq !=3D IRQ_VS_EXT)
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
+	if (irq !=3D IRQ_VS_SOFT &&
+	    irq !=3D IRQ_VS_TIMER &&
+	    irq !=3D IRQ_VS_EXT)
+		return -EINVAL;
+
+	clear_bit(irq, &vcpu->arch.irqs_pending);
+	smp_mb__before_atomic();
+	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+
+	return 0;
+}
+
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long ma=
sk)
+{
+	return (READ_ONCE(vcpu->arch.irqs_pending) &
+		vcpu->arch.guest_csr.hie & mask) ? true : false;
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
@@ -248,7 +366,33 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
+static void kvm_riscv_update_hip(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
+
+	csr_write(CSR_HIP, csr->hip);
 }
=20
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
@@ -311,6 +455,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
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
+		/* Update HIP CSR for current CPU */
+		kvm_riscv_update_hip(vcpu);
+
 		if (ret <=3D 0 ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode =3D OUTSIDE_GUEST_MODE;
@@ -337,6 +490,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
ct kvm_run *run)
 		htval =3D csr_read(CSR_HTVAL);
 		htinst =3D csr_read(CSR_HTINST);
=20
+		/* Syncup interrupts state with HW */
+		kvm_riscv_vcpu_sync_interrupts(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in VS/VU-mode (i.e.
 		 * while executing the guest). This interrupt is still
--=20
2.17.1

