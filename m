Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93E4C2F78A1
	for <lists+kvm@lfdr.de>; Fri, 15 Jan 2021 13:21:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbhAOMUp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 15 Jan 2021 07:20:45 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:11507 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbhAOMUo (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 15 Jan 2021 07:20:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1610713244; x=1642249244;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=cLNORs4VrSfT1WFyVmW0i3WYt/PjIBEmw4+g9G2Hipg=;
  b=ZGJQUOnJpN7AVLjTe9AiOiWZLk/uHnjeYePlIZkJRDiZwWpXJgOfcfOo
   SqaVpu3l5qDUONDPhkDYMY7csf2046KX+vZ9pPEBe2WIqezfqiY4UD0jg
   2L7TA7afHyCAvFuAug5qhkflKkGdmOtuAB1STN53dM3Jsw0CwTITUqvVl
   bwuyZRJkb1yp6ekasfpEBHS7eQvny6rHkfrXdCLjm3v5E/ZEi84pT6MyT
   2TvwjfTWGLxkAiXMpz9v0hKYJniRdkWSA6Ha1gr7G++OkBaOXaskB8x70
   +qBfbR4+K04OHWYJsF538it+QjdDnJsfYZcIFrJnTIu2ic8IYZMInwMnL
   w==;
IronPort-SDR: lX3pur69o8CdWTytIE/mQJR7kyBps025HX6uJNqQHeF+8OiMUQfCcYfLE7ry+ggalSA6XjJUtv
 MYKEoPsQ5tqM5s41Olmpef6QfL8IkeAobA+6jRJ256L0d1P2F7/wPYQoqJT3uRAPr1M0qSGsUJ
 1vjoidRFfKr/YT/4TUJFzpWIigP+iCBux1xmXGP4hbJUS27xP9HxDJSIDo+fXhQNrmlPSpoSr4
 ztDPmUExnFiRsIHnj2rwsXa3S9w5SjrRQNTpvr1R9a3QXQPIMGCFrziyIAQMN4gi3Crtnkg6rQ
 IwQ=
X-IronPort-AV: E=Sophos;i="5.79,349,1602518400"; 
   d="scan'208";a="161949530"
Received: from mail-bl2nam02lp2057.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.57])
  by ob1.hgst.iphmx.com with ESMTP; 15 Jan 2021 20:19:37 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ADG5TIZ2MaoD+MpluMZEDdcRAxuoK1dXQaSOADfSCwn/JcvEFBrDXuK72EaPRHp8W4ZcCWyRmiK4sDha2EcUGZ4HsgVQmKCOLH9kiDbPVRt7VUgztJAHV0YtmGp7boDrLNjxcnYwKoM3zB5+5nat5uG/tus1kG0/Egfa9hyHKiuGtuS4wFYO72DbiBPAVtio+6tOs0xYR7+IgL9mNT48VX3+a+ZPXbeMszIQYbIhG+t7K1xHpuRVS90sVORHWDZ47i+rK+6iLEsSymFtIz8EA3vXe70ozhimnVbAju92a0w53C0vVKJYDtHQOoGhYb2LhPmzfje70MjSiDKnVgtTMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O++J6HONI/ml1r5F6UkME5uIgzWd8QoktrozR3g/8Ww=;
 b=aGAzJz93ead1iLfAR0XMtJAzoNpExgd6VTwXKU55H4r+RcEcYer3MWeHc27SGJx6VCEFTxIxYRurpT7cds3UKR6cPVIQMBiPd5243VdGk7ggIm7IYk/k3PoygOc756ITZE6pAZcCX0riO8eB+gpPEhg4ST0f41VUpmhXeqNL3lLzpparmZh4XKEDLZ5rSsp0A5BUdtLzZoKO+A4/QNgK8kjR4J7BcF/bYyEXWAGWQMphDozv3Y/In5GrJYWzfspHsbj46Ip9V1lpDTKp1PjEZtE207p/FmVkgGaBKrzPHqRocDcAnxEiLkvaiVSKDeUagr03cOvzcuNiECP/G+DkbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O++J6HONI/ml1r5F6UkME5uIgzWd8QoktrozR3g/8Ww=;
 b=fgkmeydrkYKFh+XmrC0V1vJDjO1W4ys161OvkJ37tcjsuGMR3lro1CiBLRM8n28zJQyzHPeHpTVUbtkGleWNqtbApMQBFnYfRYAlFjvRrCoS6HdQRx01H6mevICLn86Heottf8vhpXW3+OMCzTF09frTRCbljmmQRtIzMWb1h+g=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB3769.namprd04.prod.outlook.com (2603:10b6:3:fc::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 12:19:35 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::2513:b200:bdc8:b97%5]) with mapi id 15.20.3742.012; Fri, 15 Jan 2021
 12:19:35 +0000
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
Subject: [PATCH v16 04/17] RISC-V: KVM: Implement VCPU interrupts and requests handling
Date:   Fri, 15 Jan 2021 17:48:33 +0530
Message-Id: <20210115121846.114528-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210115121846.114528-1-anup.patel@wdc.com>
References: <20210115121846.114528-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.167.152.18]
X-ClientProxiedBy: MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:c::34) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.167.152.18) by MAXPR0101CA0024.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:c::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 12:19:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 6d71f46d-cfad-4573-5800-08d8b94fd252
X-MS-TrafficTypeDiagnostic: DM5PR04MB3769:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB3769A3FFDEEC42550EA68B6A8DA70@DM5PR04MB3769.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zQQFgAU6EUEeJMd6+K60JNWOWAtalvsy2ybBMGKXVWhtHkBjIA4PuHCNsd21viboUCenYR91K0q5iNGNy9M80YcTRD+pP6g2ri1aoQX0HRnMCf3VMFYBv8LKpTPzNOUrgag6+YQ4YEfwxPZ+7xYZA2CssisfS6GltJ4u9aGXFwfxipMn4ifDz3ys4u2GVmYqoOYbtp6LCt10NDLQy9IsXdphmNNI3+DrQJCKl9t/wjRTnCuiWlgb78ZKOlgyZRmdXQBJ9GDCAL8YaLWQZ72qB+9D7g6R44Fr7KDBhr/FiO4+ZotfgRhWKq7XPrLmr2W8FPLc8fKLaDY3ytoNK15CIYIIYXmP0W+oMD+/AKA87EyuPZq8zsTJMPsrEjWK+qvO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(366004)(376002)(396003)(66476007)(55016002)(7696005)(54906003)(66946007)(110136005)(956004)(5660300002)(2616005)(186003)(52116002)(44832011)(478600001)(66556008)(8936002)(26005)(86362001)(2906002)(83380400001)(7416002)(16526019)(8676002)(316002)(4326008)(36756003)(8886007)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?rSPMBhpb7Ghv2ljjKERbyrv3x0PxWzZ0gO03NYGQUXATxAh5uQU+QyHQLIKN?=
 =?us-ascii?Q?VnXCvqYiDYarnqWhEUIc2MHfbgjSwTDOQEk0fomEDZX6eR29Rdml+gSBhPF7?=
 =?us-ascii?Q?JXON0VwF+eEAxX/1hdlzluq8K1UzdVR20utG+fbho/ErIV02tLhbNU1MMOTt?=
 =?us-ascii?Q?obti9w1bqobqEAwXx/npg/GqGjzIUbQEpuQ2GumkPqxTTov0Ew5H7ZscX227?=
 =?us-ascii?Q?dQFK0W3tUxfLWFKfjHyfByXY17maqXDo/Jyh0lgr8LHOwWRhtus+iKs7gm4V?=
 =?us-ascii?Q?E+M1bjidyMKGyaBpOTGK4DNVV0QygEYtpwKafOL26609M8UdcuRq5C7ah0+5?=
 =?us-ascii?Q?DWkTmIukA8tSxbsyQAHrxFXgVVoySIQIgwPKRRvnjcQtJeJHpxiHsun1pT0/?=
 =?us-ascii?Q?yvNlWG96KZqL3bC4uRbmjVX2co/t8Rm3Meg9oKl6Wi9J4MYtm3dD/+qunsVq?=
 =?us-ascii?Q?NCfO6GlVEdrsqtHRpHXbfGpckZuCJZmxRcE1VWhfjbloHJVYfx76GpN8vApD?=
 =?us-ascii?Q?zTCKxsyb7SLvRcXuH+PA50sAnxOq751ppB3tw/xROcF45KOHr4z4/ltJ17VZ?=
 =?us-ascii?Q?4IRDiFJ3Vii/4uPdarIHy719bdaK9/PvCq7ehDnil1lauGXmdeTIB1igGtey?=
 =?us-ascii?Q?mbIidcjJPcDiBj84V04lrvvT4A5Z2qhThnlVGi2eor4f/MWm9KN+FM5vHo7H?=
 =?us-ascii?Q?/4CrhhmPVOBKT/Vfsdpw4oMtbjgAP30m9aOxuHNXvH8GZerSYrFGu6lEoJJ4?=
 =?us-ascii?Q?rMzPKyWD0P77ggMAKyoxHWz1CaJ5ulmrm75D3LPhnM+hTKNxgnftuC9CrJuF?=
 =?us-ascii?Q?YcXXs+9Qw+2ZV/L0wySrmQxBuQW9krvS/MhbfvA8LPKJibwejkZ+OJ3SuHv0?=
 =?us-ascii?Q?R6O2yfZiOBbcA9wJ0h4MIeNAlW92YPrZtALkqSSehTdmfl0XSAmJN/kBbTlE?=
 =?us-ascii?Q?/DcLGds1T02B9r3mezpgpomiYYuRFJWsyI5m7L1WQV5YIS6VTmnDY+wUFQMC?=
 =?us-ascii?Q?bm0i?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d71f46d-cfad-4573-5800-08d8b94fd252
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 12:19:35.8369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LawJh8IqJr2rdLKdRCMW+i5+m/5c3t87mlhlhIhX+gaEOnqouK3WObDWH+fE9ybdvE13xO4MbtwoCaxMcAqpEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB3769
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
index 43e85523a07e..8829bed4517f 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -133,6 +133,21 @@ struct kvm_vcpu_arch {
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
 
@@ -157,4 +172,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
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
index 984d041a3e3b..3d3d703713c6 100644
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
index 84deeddbffbe..7acb2e622597 100644
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
@@ -54,6 +55,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
@@ -102,8 +106,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -116,20 +119,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
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
@@ -150,7 +151,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
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
 
@@ -199,18 +214,121 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
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
@@ -234,7 +352,33 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
 static void kvm_riscv_check_vcpu_requests(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
+	struct rcuwait *wait = kvm_arch_vcpu_get_wait(vcpu);
+
+	if (kvm_request_pending(vcpu)) {
+		if (kvm_check_request(KVM_REQ_SLEEP, vcpu)) {
+			rcuwait_wait_event(wait,
+				(!vcpu->arch.power_off) && (!vcpu->arch.pause),
+				TASK_INTERRUPTIBLE);
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
 
 int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
@@ -298,6 +442,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
@@ -325,6 +478,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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

