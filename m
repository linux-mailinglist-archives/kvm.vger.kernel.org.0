Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399071BB7A1
	for <lists+kvm@lfdr.de>; Tue, 28 Apr 2020 09:34:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726633AbgD1HeP (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Tue, 28 Apr 2020 03:34:15 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:57207 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726598AbgD1HeO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Tue, 28 Apr 2020 03:34:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1588059307; x=1619595307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=orhhgRyoa02LjIvR3XtL2MJ43uN6vtE2UBOosEtdmjo=;
  b=prT7ApIWnUN4SwpLTAlBYANuOppdcpOW1fUnGiTyJSRI/5XPAFsqGe2I
   UGzNgD+TQ5PmE46pjIQDfkjj6xgJvZEMirZG/ogULZu+vNG+KEehDS14j
   e4VKPlNVX4c5+ajitga69vmhoSrrKrfR0V5pQwAP61a/cHKtLL0vfPSlw
   P1vM1p9sdIVvFajLOiUigQ8lpYYwU++324W5zwNyj8fYmFvIf5dTRHzdF
   q4rKqIme89Ckouj2aYhvVipDRXeopUzNjA15afY/2A5i+aBEaRJ8sQMRp
   9FY/nQXTPX2DL7DyYvRnACRPbqUhKhUmygfrtkB+v/VLK3qngo/CbyQnf
   w==;
IronPort-SDR: VCyb44hgSvKd/Y8gpwA3MdmUjmXRt1jcekaz6v+TRFntkd9uMqkU4w94UgZgxUy5j+Y3QUiFzx
 i1YwWhUImR7xx0FS7eXx6eLBb0LatdTrOKUEgP3aoEkGCc4ZAroAMfB1twSNEuRT/QeY02pR3y
 +peUX7CuNmJ/B+ZqGIt6izOllrmegMWar5zjGvsOOQ1cEEX2Ug3GRg7cRJbKxx6jsIpClKgMn9
 U3AsSCj8o7XdqYGSfPCCdrzyn/PmmYV4e7CGn6jOe5Bw2u08MRReHxP4GCDqzU+ivd8Y73yDzf
 bgU=
X-IronPort-AV: E=Sophos;i="5.73,327,1583164800"; 
   d="scan'208";a="238865829"
Received: from mail-dm6nam11lp2170.outbound.protection.outlook.com (HELO NAM11-DM6-obe.outbound.protection.outlook.com) ([104.47.57.170])
  by ob1.hgst.iphmx.com with ESMTP; 28 Apr 2020 15:35:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UedenP2fBARNIhfWyfz5LB6M5fUJXYVtD/o+U7r+ox3/5GPpDBAZzUDC1oZ1FwVqaCYItBcTcYslAAHFRPc9r/uB0mwMQ6AmM0549YPnUOMORSOXVXR0bFBkHOkWt8ORxR6WSqr+xhfEz74cx2tgYoaPNubdN1JfafEWNnONzTkTyvX3J+YkoDRbQpm0vtMwSgyW2PTnJ5dZozim0t6t0K7XosFM1VRyu4crDxp7IO+lG63SyC+Qm34Z8CQQinixKEkI1QzGnLrTW7A6a00+wvsrrSIGUTPMjXCVnVqPTl4xfnbsRa4Ys9/EJJFv8zZnYJHSQII5Og+BG2bkTBomnA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDqSsNJv8zjd6+lLd/CrSzuJXo8fAeZqBByMKVZBOvw=;
 b=GqTv8D1P2vl63Agl6ON9NJ+qtMqt5CokF/eNMKGLmY1xOh/a1aTSURWgcNv+OPQMubJ51S0FcxbqIo4b4+ZaUkiENYZLgfPYBczutj/QzM4R4HT1rXI1gqDoeN5SlR8U4xC+xlbnY8nkZ1YL+TjCn8wPUt1zNsPWuBH2oPoR8aIvkQZswq300kX5HdNnoSfUpsJs7wPpEajNdOkEB0P2Y/g0UVBTbXnqOuZ6scSR+1R8jxw61oHXH49J4VOPEoMw+DwnWI6dilpx0feiludAryXSqcmgRJPq5CyzSH500SPk0ZYGKyLSERYWMAFFYBZgNAMQWN2D8gLYYTJ6XRymIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qDqSsNJv8zjd6+lLd/CrSzuJXo8fAeZqBByMKVZBOvw=;
 b=yu4NDIY5+njx/M2aNJoScdjl5KLDl4YEO6BnU8UwtBerX4lLTHn2V7NGsyhAGDirXJfBs0jYhZCIyg0riYbAYBsx2DPyVLMrsc76RvxcgD10QqiBfKKESjngtk16ItCa7MBxkqF81bP4a6SEreHWv0W8OKJFNdLnt+wC+dKgFo0=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM6PR04MB5929.namprd04.prod.outlook.com (2603:10b6:5:170::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Tue, 28 Apr
 2020 07:34:11 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::f8b3:c124:482b:52e0%5]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 07:34:11 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Palmer Dabbelt <palmer@dabbelt.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     Alexander Graf <graf@amazon.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
        linux-kernel@vger.kernel.org, Anup Patel <anup.patel@wdc.com>
Subject: [PATCH v12 04/17] RISC-V: KVM: Implement VCPU interrupts and requests handling
Date:   Tue, 28 Apr 2020 13:02:59 +0530
Message-Id: <20200428073312.324684-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200428073312.324684-1-anup.patel@wdc.com>
References: <20200428073312.324684-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:49::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (106.51.31.156) by MAXPR01CA0073.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:49::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2958.19 via Frontend Transport; Tue, 28 Apr 2020 07:34:06 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [106.51.31.156]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a973c9fb-1d6f-4797-a9d4-08d7eb468b70
X-MS-TrafficTypeDiagnostic: DM6PR04MB5929:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR04MB592926848DCED69223EE5C438DAC0@DM6PR04MB5929.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:1751;
X-Forefront-PRVS: 0387D64A71
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(39860400002)(366004)(376002)(1076003)(66946007)(2906002)(5660300002)(66556008)(66476007)(7416002)(86362001)(478600001)(55236004)(55016002)(186003)(8936002)(316002)(4326008)(7696005)(36756003)(956004)(110136005)(8886007)(2616005)(6666004)(26005)(16526019)(54906003)(44832011)(52116002)(81156014)(1006002)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BmkZgLufOkfABfeTO6Y/VNc09p8QoUg23QsnaKGAlcgKXrNJoKslkV9Ap/SD8ejZu/b+Spau12V+3Uupar+GlpKS/NxAvGlgNVAH5j89uRExGnOYth38scgrFoF4bZn9o3bwwDmtoctgLhc8nHmUkzETJhH1n/tvKGhY8KEoaz5d3Eo5YGA+m+4BRr+0IX0cg16QW7B4nAPXRXSmDe1Iz4QCEHGP7jpHC2FGQIby7ca+luaL1IrWtnUX9lgt9/IqDOb9Rxc1bIOB+IkzPjSulRYJ2oxKcQVb1N+fYRpmOOV1jk9yg9Fla+GzW/xqr4xV+mtNvAaZ4O9C943rgxHChoEiHubTrhsYWeYuD38jYShNTEkPuBhLh3zIiy4oxtnhsf2tYaEROoUQN/H04TxO4xpp9DG+JfJRa4CCsWeXEXr2apZkI3OfCJqfTlF9JHNU
X-MS-Exchange-AntiSpam-MessageData: +dF0HCcdoWMorRxzez2qGSZvb8o252fLve+UQ7LidxaIVLGNaaF2U6ZCuUx1AbecbgV41qTavAQH3MwnwgCNk3yWpp68WECmtCOTvJW4HqSq50BIKyOkBw5FRBpo0j6YI1pVNlMyL/cDSY99MAgOAYHbYUoBo5eTxDEJIsLTQRyHJ4g/3wQQrBcS7l2nIEEWamccDfHhc2es2JGs+b2QBJLqzbP6tkILKSVG78i8GjL/OiTVhsv6jzsXu0lrsvHnT/4jHon70mxoEEQ7jjFXY9nOfF9rW65QwXBOQ0/n4V9VmgCubo4iVvdodjWUpjRVRvqxnO7Lk+6s7iZ/zvCw3rkoJ4omB0vH6BtAydKhcaV/mO975jyDzR6ffCtzpWZxdKG5A1nkjKHH4AtnqqAFJVDsaLG7prMf+EI0vUDkqace9iBG0cW3L7Y0WRPj23H5ecWKxQ8/LO45zDOHSSA8KQODzoZ7564ybtck/otxd2iFLd6cst44qKaEz6IvUz14WHmP/+cIBrdjfu1isdDBf0/SkcvypXANzwx8GHPlayB+46LISGNXrQVZ1nNJgtK1dQXOVJxIEYKu3f11jW2RckhfgLkYth4Yfe79JZWYFD9rOhhxYOoPAWo8Q7sZF1ur1YBMKrV5cM8dajrEaIIBgI3y5PmGw7EO+aQR69Kkxlu7e/GzGEEL8Uo4C9xaOKSiVchn43o/eG9Guu9csO4qJzL4OpzOtVLQt9kL55Q7hHpAur4zmrjw1cR+7WO+2aTVSUEj6raN3uJBQkXumQZhNsochG0Ud+PxDymAuupQxek=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a973c9fb-1d6f-4797-a9d4-08d7eb468b70
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Apr 2020 07:34:11.7747
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IQk0KAQZ2IlCHUJIW7MiziFNUioQuv4v7359FvwGeXx8RZCgtVa/p9+GLeYiDKUN/AjRyvnd//MxKEoUH03XdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR04MB5929
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

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 51bdd6fe05c7..822b580d96a9 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -130,6 +130,21 @@ struct kvm_vcpu_arch {
 	/* CPU CSR context upon Guest VCPU reset */
 	struct kvm_vcpu_csr guest_reset_csr;
 
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
 
@@ -154,4 +169,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
 static inline void __kvm_riscv_switch_to(struct kvm_vcpu_arch *vcpu_arch) {}
 
+int kvm_riscv_vcpu_set_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq);
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu);
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask);
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu);
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu);
+
 #endif /* __RISCV_KVM_HOST_H__ */
diff --git a/arch/riscv/include/uapi/asm/kvm.h b/arch/riscv/include/uapi/asm/kvm.h
index d15875818b6e..6dbc056d58ba 100644
--- a/arch/riscv/include/uapi/asm/kvm.h
+++ b/arch/riscv/include/uapi/asm/kvm.h
@@ -18,6 +18,9 @@
 
 #define KVM_COALESCED_MMIO_PAGE_OFFSET 1
 
+#define KVM_INTERRUPT_SET	-1U
+#define KVM_INTERRUPT_UNSET	-2U
+
 /* for KVM_GET_REGS and KVM_SET_REGS */
 struct kvm_regs {
 };
diff --git a/arch/riscv/kvm/vcpu.c b/arch/riscv/kvm/vcpu.c
index c37745bd3dbd..97585aeec207 100644
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
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
@@ -97,8 +101,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -111,20 +114,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
 int kvm_arch_vcpu_runnable(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return (kvm_riscv_vcpu_has_interrupts(vcpu, -1UL) &&
+		!vcpu->arch.power_off && !vcpu->arch.pause);
 }
 
 int kvm_arch_vcpu_should_kick(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_vcpu_exiting_guest_mode(vcpu) == IN_GUEST_MODE;
 }
 
 bool kvm_arch_vcpu_in_kernel(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return false;
+	return (vcpu->arch.guest_context.sstatus & SR_SPP) ? true : false;
 }
 
 bool kvm_arch_has_vcpu_debugfs(void)
@@ -145,7 +146,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
 long kvm_arch_vcpu_async_ioctl(struct file *filp,
 			       unsigned int ioctl, unsigned long arg)
 {
-	/* TODO; */
+	struct kvm_vcpu *vcpu = filp->private_data;
+	void __user *argp = (void __user *)arg;
+
+	if (ioctl == KVM_INTERRUPT) {
+		struct kvm_interrupt irq;
+
+		if (copy_from_user(&irq, argp, sizeof(irq)))
+			return -EFAULT;
+
+		if (irq.irq == KVM_INTERRUPT_SET)
+			return kvm_riscv_vcpu_set_interrupt(vcpu, IRQ_VS_EXT);
+		else
+			return kvm_riscv_vcpu_unset_interrupt(vcpu, IRQ_VS_EXT);
+	}
+
 	return -ENOIOCTLCMD;
 }
 
@@ -194,18 +209,121 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
 	return -EINVAL;
 }
 
+void kvm_riscv_vcpu_flush_interrupts(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+	unsigned long mask, val;
+
+	if (READ_ONCE(vcpu->arch.irqs_pending_mask)) {
+		mask = xchg_acquire(&vcpu->arch.irqs_pending_mask, 0);
+		val = READ_ONCE(vcpu->arch.irqs_pending) & mask;
+
+		csr->hvip &= ~mask;
+		csr->hvip |= val;
+	}
+}
+
+void kvm_riscv_vcpu_sync_interrupts(struct kvm_vcpu *vcpu)
+{
+	unsigned long hvip;
+	struct kvm_vcpu_arch *v = &vcpu->arch;
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	/* Read current HVIP and HIE CSRs */
+	hvip = csr_read(CSR_HVIP);
+	csr->hie = csr_read(CSR_HIE);
+
+	/* Sync-up HVIP.VSSIP bit changes does by Guest */
+	if ((csr->hvip ^ hvip) & (1UL << IRQ_VS_SOFT)) {
+		if (hvip & (1UL << IRQ_VS_SOFT)) {
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
+	if (irq != IRQ_VS_SOFT &&
+	    irq != IRQ_VS_TIMER &&
+	    irq != IRQ_VS_EXT)
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
+int kvm_riscv_vcpu_unset_interrupt(struct kvm_vcpu *vcpu, unsigned int irq)
+{
+	if (irq != IRQ_VS_SOFT &&
+	    irq != IRQ_VS_TIMER &&
+	    irq != IRQ_VS_EXT)
+		return -EINVAL;
+
+	clear_bit(irq, &vcpu->arch.irqs_pending);
+	smp_mb__before_atomic();
+	set_bit(irq, &vcpu->arch.irqs_pending_mask);
+
+	return 0;
+}
+
+bool kvm_riscv_vcpu_has_interrupts(struct kvm_vcpu *vcpu, unsigned long mask)
+{
+	return (READ_ONCE(vcpu->arch.irqs_pending) &
+		vcpu->arch.guest_csr.hie & mask) ? true : false;
+}
+
+void kvm_riscv_vcpu_power_off(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.power_off = true;
+	kvm_make_request(KVM_REQ_SLEEP, vcpu);
+	kvm_vcpu_kick(vcpu);
+}
+
+void kvm_riscv_vcpu_power_on(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.power_off = false;
+	kvm_vcpu_wake_up(vcpu);
+}
+
 int kvm_arch_vcpu_ioctl_get_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	/* TODO: */
+	if (vcpu->arch.power_off)
+		mp_state->mp_state = KVM_MP_STATE_STOPPED;
+	else
+		mp_state->mp_state = KVM_MP_STATE_RUNNABLE;
+
 	return 0;
 }
 
 int kvm_arch_vcpu_ioctl_set_mpstate(struct kvm_vcpu *vcpu,
 				    struct kvm_mp_state *mp_state)
 {
-	/* TODO: */
-	return 0;
+	int ret = 0;
+
+	switch (mp_state->mp_state) {
+	case KVM_MP_STATE_RUNNABLE:
+		vcpu->arch.power_off = false;
+		break;
+	case KVM_MP_STATE_STOPPED:
+		kvm_riscv_vcpu_power_off(vcpu);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
 }
 
 int kvm_arch_vcpu_ioctl_set_guest_debug(struct kvm_vcpu *vcpu,
@@ -229,7 +347,33 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct swait_queue_head *wq = kvm_arch_vcpu_wq(vcpu);
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
+static void kvm_riscv_update_hvip(struct kvm_vcpu *vcpu)
+{
+	struct kvm_vcpu_csr *csr = &vcpu->arch.guest_csr;
+
+	csr_write(CSR_HVIP, csr->hvip);
 }
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
@@ -292,6 +436,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		srcu_read_unlock(&vcpu->kvm->srcu, vcpu->arch.srcu_idx);
 		smp_mb__after_srcu_read_unlock();
 
+		/*
+		 * We might have got VCPU interrupts updated asynchronously
+		 * so update it in HW.
+		 */
+		kvm_riscv_vcpu_flush_interrupts(vcpu);
+
+		/* Update HVIP CSR for current CPU */
+		kvm_riscv_update_hvip(vcpu);
+
 		if (ret <= 0 ||
 		    kvm_request_pending(vcpu)) {
 			vcpu->mode = OUTSIDE_GUEST_MODE;
@@ -319,6 +472,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu, struct kvm_run *run)
 		trap.htval = csr_read(CSR_HTVAL);
 		trap.htinst = csr_read(CSR_HTINST);
 
+		/* Syncup interrupts state with HW */
+		kvm_riscv_vcpu_sync_interrupts(vcpu);
+
 		/*
 		 * We may have taken a host interrupt in VS/VU-mode (i.e.
 		 * while executing the guest). This interrupt is still
-- 
2.25.1

