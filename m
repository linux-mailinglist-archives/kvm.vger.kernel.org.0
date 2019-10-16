Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38D7ED9673
	for <lists+kvm@lfdr.de>; Wed, 16 Oct 2019 18:09:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393396AbfJPQJK (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Oct 2019 12:09:10 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:54417 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391855AbfJPQJK (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Oct 2019 12:09:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1571242149; x=1602778149;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=+oqaNY779LopVzP6YLWqGfnO65O8xDASgSX1YjpOiEc=;
  b=ShS3lJMm1auwEuDZgH/+B+y9i2WfY8GE6t6tcPb+E1qBLekEQABpqWdQ
   bWzlOay8Jo9eEH5Qq7xvcWXmQXFk3IeFh59r4Rp7z5RtU+bfNGK8+gtTz
   boJ2qdcAypRj+xd8cc/J0LJGaE/3XETos0I2WB8ANKuI6MJPwsUVXFYHX
   mxsCViGcNFRPLecD9vXIJR2boOEGgG/WSL7VPvfsD6aF0e9sg2ptvw42e
   qpiC95AvgZXXH6kOQHHegN5pqeUG2px7A3U6XKah4mEQEYgP2DUyDAgnn
   QYE5ZbJVfeR06iWssmto85rkGOU4nEG8Tbule/SF4VfkXVZ0HcJzIGqwx
   A==;
IronPort-SDR: wO+iPYL96NWQgH0hYRIDbbGTYdvh1Rc4mOzN5muspZ7hmL/7IPC2I/ZYU0uAHpfdKmMzqypmjA
 vkvr9yNDfRBEThk9ggbwb5qZo2qGShcfiejQuJBOZ1RNEJ1TaBlaAI2p6NNAHET37jnCSJtObp
 bKj/JzrYZudN8+6GJsA3nzmBI+D4Hb7n7cDs50mreTO5RH23ZorDYJNqGZoX8Jbbcs4IiUqTQ5
 Qv0BsKUr8li9OA0sdk9XRc1WAlaRFlswyewFlbfYkmsThZzwv4iK69cUq1CPPlCnDw2WqCYpLg
 zZM=
X-IronPort-AV: E=Sophos;i="5.67,304,1566835200"; 
   d="scan'208";a="227736989"
Received: from mail-by2nam05lp2050.outbound.protection.outlook.com (HELO NAM05-BY2-obe.outbound.protection.outlook.com) ([104.47.50.50])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2019 00:09:08 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aKGr1+NA9R2lwaOkSd0/RTGqqADSqZFYJxDBmxDOLypiEZV2qBsO0HTU2qBoAWgLDp5mfdDm0Fi7ER0bL7+1U0tA7dE3GwiDSlNvJd1X/47cKBzsckX1bbwR6L3Gw0P9m9jHx5Ih5Hy3vKK8kgcNAjQMhPN15Qomydj0FkVTUWpFXHm6IuiIg4EdqzTmfweSP1dVD80lTCuP8pLI29uXnAmrrylvC2GzexXv1SNBYEHxynOEpiG8gMNbNUvWpCcoiUJhw/R3XfPa499slaUjiG3h6a/ebkVq2xZ/14G8c2qdfa1bFUZw5wSevWW2T0tTFtX+c7G1k+JdFqjqlvGbRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBN5H1wGZIBd1foN5Q518VyknVzs0t4H8VFR3UZYA+4=;
 b=Oyzpsdb7O8XfybjxIICGeIT5Ewe4qAPYAHNbwIVsJJ1Vzu0hTwHIO7GrMHkuj28a6HTsH4kcj7j/0KAJ+uwiDVaQOXf7q/+VhOPWIQXeNr4XOjFp7ZvSY0pNQuQj800xPfQYPCjYcnk9jzTPUsHPEfTRdIGIj7Bjdt6XYC/K0SaiSDE7Po/G+WkblI/4Y0GKdwF+6vqe2t5+DAZs2vPLucLD2v5ZY3XFbwIhg3qdBOJlsH/Zx0PvWjI8iNiINPZ4AWh5w40EhxFPqKWklh3BYxkdf+o9Pbi+xmAuwJVMpmBgmWgV5vxAkoin9E1D5SThEZSG6a7KETPXDu3G7BWOug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OBN5H1wGZIBd1foN5Q518VyknVzs0t4H8VFR3UZYA+4=;
 b=VEO9qPECtaoDfNJWnSm1HLOy96HQDoh43Lkzty9vfwEPeOSvrNAdtHRorgfIjY1lbRBGhFAOuD+8NEHKMFgTlZsOZSShvhShpXFc+5WKWI0zspyIE1j5BfkWVU+7f0lRfsViR77INwPQQYjBSpFnYdF7Iv+zXfQApCKmmeoU45Q=
Received: from MN2PR04MB6061.namprd04.prod.outlook.com (20.178.246.15) by
 MN2PR04MB7038.namprd04.prod.outlook.com (10.186.146.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Wed, 16 Oct 2019 16:09:07 +0000
Received: from MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a]) by MN2PR04MB6061.namprd04.prod.outlook.com
 ([fe80::1454:87a:13b0:d3a%7]) with mapi id 15.20.2347.023; Wed, 16 Oct 2019
 16:09:07 +0000
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
Subject: [PATCH v9 05/22] RISC-V: KVM: Implement VCPU interrupts and requests
 handling
Thread-Topic: [PATCH v9 05/22] RISC-V: KVM: Implement VCPU interrupts and
 requests handling
Thread-Index: AQHVhDwJAhrT/aRhH06sEoTbrx8GsA==
Date:   Wed, 16 Oct 2019 16:09:07 +0000
Message-ID: <20191016160649.24622-6-anup.patel@wdc.com>
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
x-ms-office365-filtering-correlation-id: 0ec1968d-f16e-4618-1f3a-08d752532c3f
x-ms-office365-filtering-ht: Tenant
x-ms-traffictypediagnostic: MN2PR04MB7038:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR04MB7038E68F9F5FB2CF211C6D518D920@MN2PR04MB7038.namprd04.prod.outlook.com>
wdcipoutbound: EOP-TRUE
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 0192E812EC
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(366004)(376002)(396003)(136003)(346002)(39860400002)(199004)(189003)(102836004)(44832011)(486006)(2616005)(476003)(386003)(25786009)(446003)(52116002)(99286004)(186003)(76176011)(55236004)(66066001)(26005)(6506007)(5660300002)(36756003)(11346002)(64756008)(6436002)(66946007)(66446008)(66476007)(66556008)(30864003)(86362001)(6486002)(4326008)(6512007)(1076003)(305945005)(14454004)(256004)(7736002)(7416002)(478600001)(6116002)(71190400001)(3846002)(54906003)(110136005)(2906002)(316002)(71200400001)(8936002)(9456002)(50226002)(81156014)(81166006)(8676002)(14444005);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR04MB7038;H:MN2PR04MB6061.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: y1jM3X4d4ldthiVxF5iIDHZ3Ba4RARvbfoeS8KNzHYXFpVz7Y+jozqfdOgEem4TfPwEmLakwXtHS8ur2QbVu8lNt/6//1eYjKEKEn636xAqmsTnGNGGt//cu6jizqqLHBACzg6It1sFvR3oOBOwDjZy6hulyrEnEyWep6GH4bDOMZ0H8zxROavZP0molVaNFzSK8D+Mu/dn/DQl7s/V7njdkGE4YXVqLOuze1t8fswbx+sz9b/Q61WBdK4g3lnulWpmsuJK+Eds93jRQUj8aHep86lY8XhM4dJC2OGJ87mzKaUet7Cc9PWNPjb8XSJ/2ooXk0Q/V32+lhYzI1bzqKmogA7n6CNRsBpMgYL+bKPefE5EkGtdPE3Pbd+rzap4l0IbXmb0jtUs/OJOg4Lbr2S6ZLWw0H8N049WZazu3Etc=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ec1968d-f16e-4618-1f3a-08d752532c3f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Oct 2019 16:09:07.6650
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0CzPv0xFLPDU0i0swnLdWixEi2rqNDzlLDrq5MGrjkfi8zYTmYlcMROUddH9oS+aXwOKpLCgv5lxu01SFq6usw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR04MB7038
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
 arch/riscv/include/asm/kvm_host.h |  26 ++++
 arch/riscv/include/uapi/asm/kvm.h |   3 +
 arch/riscv/kvm/main.c             |   8 ++
 arch/riscv/kvm/vcpu.c             | 192 ++++++++++++++++++++++++++++--
 4 files changed, 216 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm=
_host.h
index dab32c9c3470..c0d7d4fc7d58 100644
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
@@ -135,6 +150,9 @@ static inline void kvm_arch_vcpu_uninit(struct kvm_vcpu=
 *vcpu) {}
 static inline void kvm_arch_sched_in(struct kvm_vcpu *vcpu, int cpu) {}
 static inline void kvm_arch_vcpu_block_finish(struct kvm_vcpu *vcpu) {}
=20
+int kvm_riscv_setup_vsip(void);
+void kvm_riscv_cleanup_vsip(void);
+
 void kvm_riscv_stage2_flush_cache(struct kvm_vcpu *vcpu);
 int kvm_riscv_stage2_alloc_pgd(struct kvm *kvm);
 void kvm_riscv_stage2_free_pgd(struct kvm *kvm);
@@ -146,4 +164,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct =
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
diff --git a/arch/riscv/kvm/main.c b/arch/riscv/kvm/main.c
index e1ffe6d42f39..d088247843c5 100644
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
@@ -59,11 +61,17 @@ void kvm_arch_hardware_disable(void)
=20
 int kvm_arch_init(void *opaque)
 {
+	int ret;
+
 	if (!riscv_isa_extension_available(NULL, h)) {
 		kvm_info("hypervisor extension not available\n");
 		return -ENODEV;
 	}
=20
+	ret =3D kvm_riscv_setup_vsip();
+	if (ret)
+		return ret;
+
 	kvm_info("hypervisor extension available\n");
=20
 	return 0;
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index 8272b05d6ce4..9107469279a7 100644
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
@@ -40,6 +41,8 @@ struct kvm_stats_debugfs_item debugfs_entries[] =3D {
 				 riscv_isa_extension_mask(s) | \
 				 riscv_isa_extension_mask(u))
=20
+static unsigned long __percpu *vsip_shadow;
+
 static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 {
 	struct kvm_vcpu_csr *csr =3D &vcpu->arch.guest_csr;
@@ -50,6 +53,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
=20
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
=20
 struct kvm_vcpu *kvm_arch_vcpu_create(struct kvm *kvm, unsigned int id)
@@ -116,8 +122,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
=20
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_S_TIMER);
 }
=20
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -130,20 +135,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
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
@@ -164,7 +167,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, =
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
@@ -213,18 +230,111 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vc=
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
+
+	/* Guest can directly update VSIP software interrupt bits */
+	if (vcpu->arch.guest_csr.vsip ^ READ_ONCE(vcpu->arch.irqs_pending)) {
+		if (vcpu->arch.guest_csr.vsip & (1UL << IRQ_S_SOFT))
+			kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_S_SOFT);
+		else
+			kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_S_SOFT);
+	}
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
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long ma=
sk)
+{
+	return (READ_ONCE(vcpu->arch.irqs_pending) &
+		vcpu->arch.guest_csr.vsie & mask) ? true : false;
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
@@ -248,7 +358,51 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
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
+	unsigned long *vsip =3D raw_cpu_ptr(vsip_shadow);
+
+	if (*vsip !=3D csr->vsip) {
+		csr_write(CSR_VSIP, csr->vsip);
+		*vsip =3D csr->vsip;
+	}
+}
+
+int kvm_riscv_setup_vsip(void)
+{
+	vsip_shadow =3D alloc_percpu(unsigned long);
+	if (!vsip_shadow)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void kvm_riscv_cleanup_vsip(void)
+{
+	free_percpu(vsip_shadow);
 }
=20
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
@@ -311,6 +465,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, str=
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
@@ -334,6 +497,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, stru=
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

