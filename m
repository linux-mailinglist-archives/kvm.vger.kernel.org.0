Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A724351B2F
	for <lists+kvm@lfdr.de>; Thu,  1 Apr 2021 20:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234956AbhDASGm (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 1 Apr 2021 14:06:42 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:2744 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234474AbhDAR6z (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 1 Apr 2021 13:58:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1617299935; x=1648835935;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YQu/45vqrKNnTYl3XmZYZaaUL21Gp0hiOzCx2GVaEDc=;
  b=NI//HRHgdm36ywlemckoLpm7zRmV6NRjm8JIpXoVJvX7uFEJo2yuPt5X
   CG5Pu3p67/QPaIuMof004rZCOgteC2mKG6NPFmNTQZt1w62QcjWu8lm2v
   322vddhS1ww7f2OZaVPT4IfI9W0bW01C8+E7xfzbx9xk/UxH2+YNdpQGx
   c50dOgC8rg/Y5YErnmQzTeYOIfPL6eJCgdPIcoB4uDUWNtWdYFHeSAczV
   6wwkiaBQE8U25maL9jTXqTcPYO5Us5FiSVCNm7jYuYroW+5SuJQP7MB/M
   wXERwg5qCCsciJ/ooIJDYXLr9QPb0Q/p4Tg3srRQ77TRhmfvQ4taW6Oqn
   w==;
IronPort-SDR: OL5pCc32wTOFv+CRrtTrDDKVytQ8sCUxkMgUvtaPhDN7yhKqjhvBJfatlDJd4An82Lst+MH5qv
 RcQtH9KR1+Yrv1Ap1Jn/9RyMzOnzQ8fATDCVG4wzSqvqdbBUaMI2Q6Yu3OUap7SHUEq0olnNl5
 l8XasJd73owjWe8UH1o2W16fuMFM4kAaMP7ncgARjUW0XaExRMqpZaMD/ax3lcTSXe5XfiVTa7
 IQM3Qq6XAyPfBMACdhmoi1XVaPlK8chsPHDRtodhJlLH4xK0MjVaROx5lNJyPvivEZvqVj87+W
 gvQ=
X-IronPort-AV: E=Sophos;i="5.81,296,1610380800"; 
   d="scan'208";a="274387065"
Received: from mail-bl2nam02lp2052.outbound.protection.outlook.com (HELO NAM02-BL2-obe.outbound.protection.outlook.com) ([104.47.38.52])
  by ob1.hgst.iphmx.com with ESMTP; 01 Apr 2021 21:36:14 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BPh1XMmwWu7Ow7I1i7bRxsSwRAqAYpZBceh/olNJENOERt14SbJ7HrzxBkm/H5CvRQ3nAIOMy2DBlyLTzVFmMgCUz6fIzMUw4fMgjoMkUrkmTpNvtPoeS1+zayKup2xaGRmvXgLgFRQ3h0/+WQlWqTEFWAZm/oO8Gp1gRbwtATNXHyJHuieRUg252CQl3M3qT7TcJd8Tu6EePGtdQ+mmop2w2h8LLFWrE8BvP7ficCZIKx0ZHYCdGeeWS1yqSvIl+J0iGn+LYsaohyahu08khF/sFQZK5jRZ1rtldns9KJ+UmKU1ODptO1SJ2roJMtJMbI989U30e/cLLD7d7UmRDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4vav1z1qijZPG01QjBobin+8ypy1a5bFCmlChAVKcg=;
 b=RcV20/i1sFvRHz0b3y9OJnrWKrJN0xKksIalLV0KykkVa0Yiisae99lF8c1VJGFfOr4kn0+ibhgO6TWZaHCsI9OjDX3FR5bonDXd1aiIQAbDUgRuTgPJyexLsVHHxSD5sJWJjZbg6+lDGqx2pjkLygceesJhrb0U4/2FL3ZQT5OUhNnmzK7+35N2Fna4Ieug8alpevDrDL0eDW8/1g0wgfp/+JA6TumjdvCUTdzGbYQ4rSK/UlYqylj/aCg3Cu9OtyZtrTKifHVYLXzqEKLjvNSNLyhHYulFOtFU+qshafgwLt3P8CHUZKVNURdQVPvZuBgm/gJLg9b/BDCmJ9uJ2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z4vav1z1qijZPG01QjBobin+8ypy1a5bFCmlChAVKcg=;
 b=ZBgwsoUAwNSkAiWqpJt/rwPVabgvs7UFrcWaDs1oJkGdZJKLIuZaBPaLDU35G7Q0esibDRetZzwGjrHtayespdkRcEcaTzgj0fB3kT53GeHOq/77EAi/5Vn8URFOdeRBpnEIntVG06mT6ioSMfRT2TpVktBEca0p94aZbHi9mLU=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR0401MB3624.namprd04.prod.outlook.com (2603:10b6:4:78::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.30; Thu, 1 Apr
 2021 13:36:12 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::38c0:cc46:192b:1868%7]) with mapi id 15.20.3977.033; Thu, 1 Apr 2021
 13:36:12 +0000
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
Subject: [PATCH v17 04/17] RISC-V: KVM: Implement VCPU interrupts and requests handling
Date:   Thu,  1 Apr 2021 19:04:22 +0530
Message-Id: <20210401133435.383959-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210401133435.383959-1-anup.patel@wdc.com>
References: <20210401133435.383959-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [122.179.112.210]
X-ClientProxiedBy: MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:1::20) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (122.179.112.210) by MA1PR01CA0104.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:1::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Thu, 1 Apr 2021 13:36:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e56bf2f7-fa64-4f93-a2ee-08d8f5131d7b
X-MS-TrafficTypeDiagnostic: DM5PR0401MB3624:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR0401MB3624FFEEF0FBBA231E4FC09C8D7B9@DM5PR0401MB3624.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4PgcTzatSU411L6kRBdanC0/wxJzBAqhmxHfCKYHx8ElLPULYfEwmxgmYIluIENKm3bZxiqq7X4h3h8JpjcA2J7vsYT8/hDK83kX1cPC+BKFQMkQHOtGz5MoJFKqD1FEcT0V/+hDSs6ieV9d0XVnPViWRvJDWMFvVifeBJ4CtAwHaxWCger01ZQfHSjFc9r6JcTqVDpcFS9jt9O5vNoqa4Z+N4jmagJ1bR8y+rXWgDVkAU5FUu5UOj2dKdkceWe++/LpP+cM3NamX8gjsJbi9KBfCl+9Q2AitDhzvBAvQUj1VMJn/1IHYk9W4LU4WVArC9jwrYF1wZRrzZzKGJ3zzUkLjxpCJ/qym/X90VbIj8SkXCNRHMmM+AcxpTbjdWdbtn37icG8pDUp+mMN8P6SbSNrynJtrWAq16PMQ38X80gVjbv2RtXG/p44tB2M9t/ahN4YsdJ8zxgqWmCXVtZZSlf+rHSORQYY68iGOTBPjvm9KEhaPV8fxhzSvfFyjPUVq0zgt+MsKemHNNDFvvDJPD173xwIgmY4VPnBnxAgSco4ifBZCk5tW+2rYk+RVbDu+wSrtpAJ3euKNAh5SyD/iU/l0fglIowPY41vdJbK/clAkKSr5kE+xtFl7mTT2/JZQgoSQ2b7ZRhKXMHQ0P9/YA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(346002)(39860400002)(376002)(366004)(1076003)(36756003)(8676002)(66476007)(478600001)(66946007)(52116002)(8936002)(6666004)(2906002)(66556008)(110136005)(316002)(54906003)(16526019)(186003)(7696005)(5660300002)(2616005)(956004)(55016002)(83380400001)(7416002)(4326008)(38100700001)(86362001)(26005)(8886007)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?E/TxEOXoob96iXNL/EKgsWzcR0idUtcrnC7Dssx0ijqqB7oCPVIcqznI0WI1?=
 =?us-ascii?Q?y6razGrGB9YS4+GrOBmUSU0AFBKKqgfNcvG7nDDnQ6M79tWqqC7Jd7BJ9k27?=
 =?us-ascii?Q?1yW9s89LALvQO/F0uhU+PinL0z2hFR/3Pn9nYb5YswDNgqj4zEBvHauXFQqC?=
 =?us-ascii?Q?yOVLBNdl4vs2fCT97QiTbCQiw/nCSLRf/1ULnS/5r8MZ9B4ol6Oxgoh//1YO?=
 =?us-ascii?Q?FQnw+WsQ1j661CAFUWnKH7MoUDn55E5mv/2PZwYluMpJq6jfIc/mMstyTdRL?=
 =?us-ascii?Q?ZpIH64qKywz1u+AmfILRP20T8wpu8/Zccp/c0XqbHonVCjhWesgoVGumVwoI?=
 =?us-ascii?Q?RTh6YTebuV+7i0NNboNqgg0qM08bqZn1HT+4Ebc76jpey8uZHVR5IqS+NYrh?=
 =?us-ascii?Q?iz/pi6vxZxJJah3TXExfsFHRyTFAmTUrfCORq4W8SuaqbGBt1HZwriMMzuej?=
 =?us-ascii?Q?wUvVL4B1Q5jfyChga2Gacy0DYw/cieLHVAzUf+AxvqTINMlDgePGWmeGORj0?=
 =?us-ascii?Q?kPCOB6IV3dlAoH0Q0bQ+hK3Gckzqgz0lPMX9bXzHBbNilWaFiDIAKt5v0fEt?=
 =?us-ascii?Q?/mKyw+pyvky/D1CEc2OPR+t3ZkMLz/OakMhKBI78Pbd0kA7duOqHTOa+63tF?=
 =?us-ascii?Q?PAtXDZplbf39LZFtLwY2Nnoz6NADJGAxvEDQGAqDRHfCbDAIt75oSJFd3u3y?=
 =?us-ascii?Q?npk7nCVc3PaNI+my316SPvFzCM/4jUFFiAHkNIh7f3153CtRN+9Na8+odUUg?=
 =?us-ascii?Q?fBPUiCDrDTLTE5by1bukyABN5feSH+b9/1svN5YBqMklr3ATOmEk9Rvirphp?=
 =?us-ascii?Q?s0NVxH+Xy9rJ0vRk3+f3HPlSm02t8SoMMRxyhh0OB/6uQVEVseNc9Owd+nZy?=
 =?us-ascii?Q?FIs92vkIfrSkwisMzy2NeFmxNSQyZwtKmQqoGvWRCyWK22S96fRXTlQUH/ma?=
 =?us-ascii?Q?vcp5ZfzbX61X1MLZws5nbtXGfvBn901fqjf872G444aJRQZ7D+OlKXbHG1TJ?=
 =?us-ascii?Q?9FGlY7/zNueW2Su/sKIuUCunBB/2fq2STBFXicMCXD134162MwrfIr2qWZ79?=
 =?us-ascii?Q?EquHHKY0/gxsQ5ESTbJCAJAjDWFMKmeCFZLNs9pX2LRxkFSQyV+yco5+smtF?=
 =?us-ascii?Q?pknVhb/bapYK7KYNRHlGIH298BmYUPXKN/esnfE8jAiXyz4F+z9zoHXDnYxG?=
 =?us-ascii?Q?z7Zw6Dea/BSSlmOxfgLh2dI13cC8pqUJ+ev0MPtW2xKIPa5RrvMN9lVZ+IQD?=
 =?us-ascii?Q?8mRIW5DkOOptLjxRNnuMIypNSPBCGRHPA6JseuggBSGHbfmtfPWeIskjBUkD?=
 =?us-ascii?Q?BHLbGFv0uyKj7Q4JA1QRuzPrbVwIVkiYz3R3X6CK+9W6cQ=3D=3D?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e56bf2f7-fa64-4f93-a2ee-08d8f5131d7b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Apr 2021 13:36:12.3139
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fISc/XL5BY4gwkuqRP5X8SjAAmhukqb+ITPEBcpcJW1ddIeCOYZeyxEI69YOTia8ld0ewYxJ1pDMqedNUUqjGw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR0401MB3624
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
index 2796a4211508..1bf660b1a9d8 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -132,6 +132,21 @@ struct kvm_vcpu_arch {
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
 
@@ -156,4 +171,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
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
index d87f56126df6..ae85a5d9b979 100644
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
 
 vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
@@ -135,7 +136,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
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
 
@@ -184,18 +199,121 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
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
@@ -219,7 +337,33 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
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
@@ -283,6 +427,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
@@ -310,6 +463,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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

