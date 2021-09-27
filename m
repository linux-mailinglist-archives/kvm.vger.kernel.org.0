Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30BB7419343
	for <lists+kvm@lfdr.de>; Mon, 27 Sep 2021 13:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234135AbhI0Lmu (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Mon, 27 Sep 2021 07:42:50 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:50713 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234112AbhI0Lmn (ORCPT <rfc822;kvm@vger.kernel.org>);
        Mon, 27 Sep 2021 07:42:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1632742866; x=1664278866;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=hko5XHbCXoex426z+rYgHaSj4go/BC5kXk1a2x9WDd4=;
  b=YCgV/CkqeqSpc0CSIh5HaXlxaNTXK7sCwwPORo8YKUOGfid0oR+IOlvj
   mylNmM2xaT8pBIIN/I5SYa8cPJfKBqLbb8cKBv7vU0jyia/TJZqQRx3fH
   ps8g7HbI5dQTmrSMiK+lZqh3HaV2JeX6XtG15pgdBT8dcTQDI7S66W+Bo
   3xgBgUrEXP21nzeYh3iTFjQvJce2j+dQ4ssuM5XLQ8Or24F83O2dA56Nq
   ik6teOVw07AbhJbUYN8mJquZRhoKAi3Y+mel3CJNdRRUrrAmdAUuZyRLG
   diN5RNlqmEt9LuBHERWkyT9Xo/CuykOaGum+mh6uUfDFnZiQQKwo9vCSY
   w==;
X-IronPort-AV: E=Sophos;i="5.85,326,1624291200"; 
   d="scan'208";a="292706446"
Received: from mail-bn8nam12lp2175.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.175])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2021 19:41:04 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jTo0EkFBe0Bl/glm9w5wLzAvFhC1xAljQuP5BSDjJADYilqIb3dIeG+H3KqcO2bFmtA2tVXza+B1QRrBQ7xhn2VesjkZnnMf1qos6oGaFjhPNiDC7osGXGc7GJ1OtXmIf/Ank6i7FBhb9MPFTcPhWX4NrJzugBWULMwRDc+kRptx+Xbin8oak8iIhfCI+TJwxmkqcg9eoixTfMJh8JNsDF5B1l7+wsQTnRYGr1ZpwTgbmhrt6S2ODuFg2hECyI4xv12io33vllZxmJ5wC/QWzqjigmT6juw7S1IIlsePE2IDthiRTOIht3y9bvyn+Al7z2QUVjXV5ye08mpHtbFaFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=RicHWbZzvSAFskLPSR7zpZxtAd+RF/3oowI6voR3YRU=;
 b=Nh8RIFYAZ/YjeYMbzeYvM7uixyZ6K7apt8F5KaiKN5dZSJmeQU3E8XHOKJekjH1UAPT3E+k4tdix/HtOx0FCBqLejanabmOqssCugBaiyOPdHK74onzZkI/hXtqN/T4VdTYjG6AUmVeHCWipqQa9kBt3pC6sgUdeoO+wOQku5IMFZTxia0hE0mxhYS1oEbnTi7F+JLguNkKlVVZI4NwFAB4MujWKja+Zx1DhyuD/pxPI4OMS0FC337VHEb4JS840ggm3JxxzvhO8nzQPv1sLnZM/TXvpxWDFXZM8zMzFfVJHbmsoh3lh1Mqp9n0G42MPE+HOQrKolAGcb1om9eQLZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RicHWbZzvSAFskLPSR7zpZxtAd+RF/3oowI6voR3YRU=;
 b=BjH8+QeEb5FV5Jl99xNSX6E3w2gyXiIUqq3EUp5/UaGVHgSXJMnXbU5tZimbMsup4AUNKKODClesn1TJY9/wpg/Dmm8I1yfLpDm3Oh6LQPjib/pcoHSPoo3ZKgie6T6gFDJRjO6cGWaXlmS+8G/8oOOUGYEND9NT1LMoNwVMQag=
Authentication-Results: dabbelt.com; dkim=none (message not signed)
 header.d=none;dabbelt.com; dmarc=none action=none header.from=wdc.com;
Received: from CO6PR04MB7812.namprd04.prod.outlook.com (2603:10b6:303:138::6)
 by CO6PR04MB7841.namprd04.prod.outlook.com (2603:10b6:5:358::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Mon, 27 Sep
 2021 11:41:03 +0000
Received: from CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b]) by CO6PR04MB7812.namprd04.prod.outlook.com
 ([fe80::6830:650b:8265:af0b%6]) with mapi id 15.20.4544.021; Mon, 27 Sep 2021
 11:41:02 +0000
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
Subject: [PATCH v20 04/17] RISC-V: KVM: Implement VCPU interrupts and requests handling
Date:   Mon, 27 Sep 2021 17:10:03 +0530
Message-Id: <20210927114016.1089328-5-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210927114016.1089328-1-anup.patel@wdc.com>
References: <20210927114016.1089328-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:a00:e::13) To CO6PR04MB7812.namprd04.prod.outlook.com
 (2603:10b6:303:138::6)
MIME-Version: 1.0
Received: from wdc.com (122.179.75.205) by MAXPR0101CA0051.INDPRD01.PROD.OUTLOOK.COM (2603:1096:a00:e::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13 via Frontend Transport; Mon, 27 Sep 2021 11:40:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2de0d84c-0166-4739-4d6d-08d981abaee8
X-MS-TrafficTypeDiagnostic: CO6PR04MB7841:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO6PR04MB7841091229D2243A8684C0158DA79@CO6PR04MB7841.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:3513;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: R/nRB4CQQIx/UPReUds37FPYCr7MSKiaTedrCBD9CKoDJyhtOaiiH9xGsu7nFBmWVDZmjesHTR0/nUiVFd85U3nO3WfjzOGj0Di2Mh8NsKzRUWIVRAtiajly0DluxpjrWKUObGEvlZzV5v0gvYRTz9yKyFqZVj3QqyuXMfNNQABmXnqDquQTm5BGD4srWY63F5OV+DqxwGarrHiGBsUwJjZY4epZz/W+yjceSMKiKOOZkVq7GDyGIyq3iGmX2UWnSl1ccnuqI9zmC/ARZlTxSD2YxF4Kp+MSNMM4bu3M2bM9gYWqRmHcQIGhPOEyA3wg9kGcLjWAQ/DvCvq6u6ur1Np3SqXDJb4TfjHJ51MPRKc1Oms2Mld/1OHs0O9GgCdkvvITb3t+o/C4RgaWmvs6Snf7YdzYK8uwS11aExGvpSnzsdmEG2cSJtmWtswD67hrM7vsnsYdxoypWtvjL9qKOrvMLJ6fIbblYSVbHMZCIhnQZmXXBMGIw/sQdYP6wkybKEildIqyBjLPSobNQ6rRJUAhgurcORMG8B+ugo6ZG6pSOv8yPP73BavH2b06sVpiE4HMTq8cMRdAKSpM4VOHJpU3ooWJsln+CvtPJfwI/dwWw1deVjrx2Ju8aZuKciUVF4mnNOvAM4UdXTVCpdjNToB/OvmueWWV5Y1vDmrtNwwRuk04rpx2IKfs/lKY2n/a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR04MB7812.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(54906003)(316002)(110136005)(5660300002)(1076003)(66556008)(83380400001)(66946007)(66476007)(36756003)(38100700002)(38350700002)(55016002)(86362001)(508600001)(44832011)(8886007)(6666004)(2906002)(8676002)(956004)(2616005)(7696005)(8936002)(7416002)(4326008)(26005)(52116002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?kUYBVIXer2qkKNGx/mMBPVyU6qnrmzdFRCQ1GQ7CMHu/NojS5goPiNI6jbBo?=
 =?us-ascii?Q?7ln/BoCB0dhx2bFtW7D9QqphS4lvd44he6zooUClFxxrPCCAAOIrIurbcn+N?=
 =?us-ascii?Q?haxzFzWeotg3NXxaosfq3Yww6oZJrPDo4jTXaWuA3WlqxHjV54s+tUGyjHUb?=
 =?us-ascii?Q?3gK7MmIkXmiWP5cLX4n+1TWnuykShuDDh9O48OJgEmJhQLiSVujyl90xVmoN?=
 =?us-ascii?Q?KVSbrsfg+6kHCfOkHDUvJFFAjNmqLpnhW6Ar3ZV8D/yYeSGOfzwh+A9QvMhK?=
 =?us-ascii?Q?sQd8faPMAuJDNWmgbtYwWLl3x2fwHPXLy5Pf+rxOWAxss5TBDKFXc0WT/UXb?=
 =?us-ascii?Q?dbU2kyLnUo/QSuPz/tBvdmsptKp8BG3UdhC8Y0ToiZaXQZ4+TBOW3zvcyo3U?=
 =?us-ascii?Q?QkuMIkF+mGUJ9xgs9ThuQTK5fEf5+bPgobB+YAv/dX/M/g9VgK/c/86vzNNT?=
 =?us-ascii?Q?ybSc3uE9pGCY+WFUyG3dxF9nj2UCmT9W0gI8TQkN1kp/ZfLoKIEMt4G+tpN5?=
 =?us-ascii?Q?/s3qutO8Pnsu/IVVfBRUOrBIQE2sHX0ib5DM8IsOoapP5zn/T6PP4nXZC3bP?=
 =?us-ascii?Q?yt8r13hAhqO9dy4X9hbHYR1XgCN/HYSkTsxGaJ0KwFauFMC/KbAWjloyNL2o?=
 =?us-ascii?Q?vByLYOaxj4Gw8uV23Fe8WyiAMqREY6sd6JlxnQR2I+0O07T2Vhrzz/0Lnzwf?=
 =?us-ascii?Q?QzUPnU1OMyHVrM3HLFMJLFL9O7x8s5REWndV8VwSZwxomsOhKPmA1SmT20G9?=
 =?us-ascii?Q?h1M/rtUYgusNz7B63PRuzG8zP8n8k8LMJaa3kMjHJRwubUoT5xVfNyz9k6ne?=
 =?us-ascii?Q?jwghGQLWl9EOvAEu2Sh8rQv2sAHxklz/jnU8Ggfpvqk+Re3sDqactLfXrq3V?=
 =?us-ascii?Q?fxT3wTwMXOtrgpctw5xUlMAVnGS9N8wv6f3cb6JiCcEOcfr0lFFU6OAib/FG?=
 =?us-ascii?Q?NLXst6zvEfohF9zu9DTXs3Kv/hYlMYcx6goeusXlHHeuiuCpQHZT1+DRKZmD?=
 =?us-ascii?Q?TAjPUMZu3FDZ0K/sRJcr4boX974+NELB1TqUOzTEpVgRc4Jz873j4eV4qpIO?=
 =?us-ascii?Q?ZnkS7af5LZJHTXkqHqjFavvl8yVwYGxYyCGTSYPzw5ZUTfDHQFDuIpFpWWD4?=
 =?us-ascii?Q?jVHPfj+ZNN4bTA1DYmq01pzhuxRVjVdTmTULF6GpwOs3LHE6nzEpADlznEyr?=
 =?us-ascii?Q?wN9VdL0xSrowNMVFZ2b+0h2XfobuGmUKrNwXtknnYMguT513gUALSQ4uQ/Ob?=
 =?us-ascii?Q?TK8SsoM8kVtMR9p9oll33+u6ZfYFImutLR+UalNS0TXj2/uDfUEnd+Sv51aR?=
 =?us-ascii?Q?cyvaY3QqqB4k9jaa5+42eIpG?=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2de0d84c-0166-4739-4d6d-08d981abaee8
X-MS-Exchange-CrossTenant-AuthSource: CO6PR04MB7812.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Sep 2021 11:41:02.7379
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZFS9Vo6CFKSXR+jCdgjbg2gZc+DDRwX2/K5txkUaedydw9uNdDD9auLIuPRGsfuic05JcrkP4ge0gL5IKQgtlg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR04MB7841
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
 arch/riscv/kvm/vcpu.c             | 184 +++++++++++++++++++++++++++---
 3 files changed, 197 insertions(+), 13 deletions(-)

diff --git a/arch/riscv/include/asm/kvm_host.h b/arch/riscv/include/asm/kvm_host.h
index 0db663cf74e4..e307528bbdbf 100644
--- a/arch/riscv/include/asm/kvm_host.h
+++ b/arch/riscv/include/asm/kvm_host.h
@@ -127,6 +127,21 @@ struct kvm_vcpu_arch {
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
 
@@ -150,4 +165,12 @@ int kvm_riscv_vcpu_exit(struct kvm_vcpu *vcpu, struct kvm_run *run,
 
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
index 7b45aa23fba3..3342c7305265 100644
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
@@ -57,6 +58,9 @@ static void kvm_riscv_reset_vcpu(struct kvm_vcpu *vcpu)
 	memcpy(csr, reset_csr, sizeof(*csr));
 
 	memcpy(cntx, reset_cntx, sizeof(*cntx));
+
+	WRITE_ONCE(vcpu->arch.irqs_pending, 0);
+	WRITE_ONCE(vcpu->arch.irqs_pending_mask, 0);
 }
 
 int kvm_arch_vcpu_precreate(struct kvm *kvm, unsigned int id)
@@ -100,8 +104,7 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 int kvm_cpu_has_pending_timer(struct kvm_vcpu *vcpu)
 {
-	/* TODO: */
-	return 0;
+	return kvm_riscv_vcpu_has_interrupts(vcpu, 1UL << IRQ_VS_TIMER);
 }
 
 void kvm_arch_vcpu_blocking(struct kvm_vcpu *vcpu)
@@ -114,20 +117,18 @@ void kvm_arch_vcpu_unblocking(struct kvm_vcpu *vcpu)
 
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
@@ -138,7 +139,21 @@ vm_fault_t kvm_arch_vcpu_fault(struct kvm_vcpu *vcpu, struct vm_fault *vmf)
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
 
@@ -187,18 +202,123 @@ int kvm_arch_vcpu_ioctl_set_regs(struct kvm_vcpu *vcpu, struct kvm_regs *regs)
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
+	/* Read current HVIP and VSIE CSRs */
+	csr->vsie = csr_read(CSR_VSIE);
+
+	/* Sync-up HVIP.VSSIP bit changes does by Guest */
+	hvip = csr_read(CSR_HVIP);
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
+	unsigned long ie = ((vcpu->arch.guest_csr.vsie & VSIP_VALID_MASK)
+			    << VSIP_TO_HVIP_SHIFT) & mask;
+
+	return (READ_ONCE(vcpu->arch.irqs_pending) & ie) ? true : false;
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
@@ -222,7 +342,33 @@ void kvm_arch_vcpu_put(struct kvm_vcpu *vcpu)
 
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
@@ -286,6 +432,15 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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
@@ -313,6 +468,9 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
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

