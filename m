Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CCD21B1DC
	for <lists+kvm@lfdr.de>; Fri, 10 Jul 2020 11:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727972AbgGJJBI (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 10 Jul 2020 05:01:08 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:6017 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726496AbgGJJBH (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 10 Jul 2020 05:01:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1594371666; x=1625907666;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=1yJNVc5F5ocDUnVzKDAoiFjtAHcMgx1NxHiuyVmJjIw=;
  b=Q2sTbIWtiYRZqZ6vSI7iewUKnM61zYUwoq3iFcdQC7JkVryptpoQ821E
   azL/7MBezLeCN6i6ZJ41gRZLY0BZFXQiD37z9E8JX/lzOIMKj4JgI7Rz1
   oryCMh7CCm+c4lW+924czMgrHRdWP6Gl8aGS0wAKOeNNEVqtjyxAJBWp/
   WarJCq5VegdSxMmFVXOTH5muDwzrRpwRcyKS6a+U4FeW76IHbP0QhPBoQ
   7A5w1bj2wdwhKVAN0+dlDPoeTMKABXPeyxvJ13XLp5Zuj++1qFdsHQoV4
   pOY6r9vzWNEjNDB/SzK+9H6IIkcBp6Kzx13bmevdgol9EKL9UIgip1S+Y
   Q==;
IronPort-SDR: Ia3zdilR+p8wUA9YrzmStyjgbX4Zh525fWGZDePa9mhHMIQXe/0jz5oe7yv7g69TndNHiklnKm
 HxUreJurRbCYTnFhHRYhi1bd8J9D0aS8jVPPu9w3j9XR2rBBXhYkI3ZkydGKCiD6OZxAXDBDBZ
 JleqxMoS0BWysnSZZhn1ZkZpCOd7KUVtnAuCLiCjPEvesSzIeQiy9gzDMn3kqTLkx4+ku4oM+w
 VcYDZlcNHgJRhCsUrQGiSFyA7mCSZBdNVQE5fUP+Lc4IhK1uGg+qw3HV5v4r0JUwD2k1MKp6Qk
 s/A=
X-IronPort-AV: E=Sophos;i="5.75,335,1589212800"; 
   d="scan'208";a="142124232"
Received: from mail-bn8nam12lp2174.outbound.protection.outlook.com (HELO NAM12-BN8-obe.outbound.protection.outlook.com) ([104.47.55.174])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jul 2020 17:01:05 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hR+rjyYA+MoZZC0/QmaGynWb57E6W0papnoIH80ycbLvJm0jQtMwZ9ibE3OKki+sxVHdozpwjCYmOysrdY74rvUrO6EUZBAieMnGF9QVaAK0kp+30JetLHcjUUIYKVwGQh2Q6zX5rAzPjcDCZQtl4UuWSi3/29H6ZDpE8HrhCll+VJiU2X/gbdr7hnK0nuL/bwqpWI6uTJeIl3/xuM2zcRrsoam0qqOOH7pzSS1OnlJ5H1pOq30X1aziEOBuN0hCyHsNU06P1Uq9V9aa68nIxpFXP4NUZ4A42/7mmoFJFr+Hg03T6WsBar4Vl1+9PBhqwL7/Fq0d+A/widGGofYV3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sM6xoNCkuode0NTqCUyKLHzwkeQud7yZAilxdSRMLvQ=;
 b=n6H9sFpajD21j9ndxM9I2EecypYfhkHM0DJp8WFASeUQrNlzldJOsREKXQ9jVJG5U4iOfyPK6eMO4UVf6gaN7+ieBsKCa/0d3EvR1hdpn4UQDMhjeDIlZl2eiqIJhOfxi0OzaM3hNAErnKrfK1UCyc5S6tmVpWQ4abd/TDlcmkOoGc6G993CDWdHMLE+QTSMcDGcVI/P5TvHfeh8A1TuD/P6FW0FwkD2RYq84VZ9TXLKcbFHChh8oHd/il0F0tdsDh9gOqI8IpOem3aUATpH/1NRpp4bJ5Umr93XBD0ZxvkxQROH+1d9Dn9I5/C4YIF6pDmjLzLOkuFPXxqWa/7wQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=wdc.com; dmarc=pass action=none header.from=wdc.com; dkim=pass
 header.d=wdc.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sM6xoNCkuode0NTqCUyKLHzwkeQud7yZAilxdSRMLvQ=;
 b=u3E1iQLovn1LqySV4pzkzcbd9elApdF9gTqoFt/rB9o6fSPT6j8i7Gqj368gh2PIIScSkdwK49lO0OvUUcyr/4mClVYRB8/SF77CO+8RKyruRwU2J65AHy3V67a01MzMfs4CKfrA4mW19HzD4V/edugNE1bh1AqNEsiTmRS3kHE=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=wdc.com;
Received: from DM6PR04MB6201.namprd04.prod.outlook.com (2603:10b6:5:127::32)
 by DM5PR04MB0346.namprd04.prod.outlook.com (2603:10b6:3:6f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.21; Fri, 10 Jul 2020 09:01:04 +0000
Received: from DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5]) by DM6PR04MB6201.namprd04.prod.outlook.com
 ([fe80::e0a4:aa82:1847:dea5%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 09:01:04 +0000
From:   Anup Patel <anup.patel@wdc.com>
To:     Will Deacon <will@kernel.org>
Cc:     Paolo Bonzini <pbonzini@redhat.com>,
        Atish Patra <atish.patra@wdc.com>,
        Alistair Francis <Alistair.Francis@wdc.com>,
        Anup Patel <anup@brainfault.org>, kvm@vger.kernel.org,
        kvm-riscv@lists.infradead.org, Anup Patel <anup.patel@wdc.com>
Subject: [RFC PATCH v4 1/8] update_headers: Sync-up ABI headers with Linux-5.8-rc4
Date:   Fri, 10 Jul 2020 14:30:28 +0530
Message-Id: <20200710090035.123941-2-anup.patel@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200710090035.123941-1-anup.patel@wdc.com>
References: <20200710090035.123941-1-anup.patel@wdc.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM
 (2603:1096:c00:c::15) To DM6PR04MB6201.namprd04.prod.outlook.com
 (2603:10b6:5:127::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from wdc.com (103.15.57.207) by PN1PR0101CA0029.INDPRD01.PROD.OUTLOOK.COM (2603:1096:c00:c::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 09:01:00 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [103.15.57.207]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: da6dad3a-8af8-4161-dcf4-08d824afc639
X-MS-TrafficTypeDiagnostic: DM5PR04MB0346:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR04MB0346D7C230244F0B082A92098D650@DM5PR04MB0346.namprd04.prod.outlook.com>
WDCIPOUTBOUND: EOP-TRUE
X-MS-Oob-TLC-OOBClassifiers: OLM:224;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P/7q5rxl65gBYn0a5mu9DqHnZGJaDzV/QlrwW0/aBUWm+Cb8vhgIMefYGK4er4Q5Gnu3ZCn5OQZO+WdTgCunmza5zl0piA0kHjz0jwFE0LiA+NIijw+hOBmo7KPYfvWZwQQyz+6VWSCg2lYmnDWeOB56wmX7l0Fmr8DDM+onsvQAxDzqiQm5hjh2giFERHlYZ4LYOF9DeB6Bu4bEgp++caNr9UAszxPLQ4Bl3In1rCpplbUKsa/VfbbOvgSuFv+docQHPiADQEIrEKSIv0IkrdrMLB+nnGeHrnPw5JM9ihpnlVmWp4MvYrfiQDvzXHo2
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR04MB6201.namprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(346002)(136003)(366004)(376002)(39860400002)(66476007)(186003)(66556008)(16526019)(6666004)(30864003)(52116002)(8886007)(1076003)(6916009)(86362001)(7696005)(36756003)(26005)(66946007)(4326008)(5660300002)(8936002)(956004)(2906002)(2616005)(83380400001)(55016002)(478600001)(316002)(44832011)(8676002)(54906003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: I9TywHXzsyXiZhJ4M4W5yGCkvC0Fnjsn8fMpxT7ZydoKD7v3on+w8VaVJ1fsO+r42gb1dzROZHSwOfz1UhEgo7zQfDoTVi1CpDe9sR48jt4UMKjgTkimiWk4owZIzUDYUPJ85on1pUxyXZB4FsXHhMNNmJK/BbmG5+NSv/raHhs0ntG6XEICPTj8dIIl6iGyeF4m0VrTcqFS7jN3a5JiaJKmWDFXaLDu1UQ+y9re4iGVCEPDEErmOIPF+e9DvgvKg5ebWk9Y8tAZKsefyBWh5ealPjbAFjLbea+JTdYOQql0Hgdoc76iJ01sCQc81E2JRERVCZBiAvpTQ0tdYLuLiI0LY5OeNlnhz5c50FZk/ajAGbfD7E8DogF60FSb0X6WSrO4lLOkSmwCvZpt0edX0unhvz2IDs26ZIo8AQ3YXit1t6K97S7dFGSOE+HhUu6tmnJOBbMOfj/BE0dMiA11ubU8/nDOp5XahDI8RAlxESs=
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da6dad3a-8af8-4161-dcf4-08d824afc639
X-MS-Exchange-CrossTenant-AuthSource: DM6PR04MB6201.namprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 09:01:03.8421
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sGOvE6e0xKjUdk7BVnX+qEdHfAih7NZel2GkFG01yzHbk36I7e3EgzyxIczu3B+SdKt6vEl2Oue1QX9/Vq5M3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR04MB0346
Sender: kvm-owner@vger.kernel.org
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

We sync-up all ABI headers with Linux-5.8-rc4. This will allow
us to use ONE_REG interface for KVMTOOL RISC-V port.

Signed-off-by: Anup Patel <anup.patel@wdc.com>
---
 arm/aarch64/include/asm/kvm.h | 21 ++++++--
 include/linux/kvm.h           | 95 +++++++++++++++++++++++++++++++++--
 powerpc/include/asm/kvm.h     |  3 ++
 x86/include/asm/kvm.h         | 21 +++++++-
 4 files changed, 131 insertions(+), 9 deletions(-)

diff --git a/arm/aarch64/include/asm/kvm.h b/arm/aarch64/include/asm/kvm.h
index 9a50771..ba85bb2 100644
--- a/arm/aarch64/include/asm/kvm.h
+++ b/arm/aarch64/include/asm/kvm.h
@@ -164,8 +164,9 @@ struct kvm_vcpu_events {
 	struct {
 		__u8 serror_pending;
 		__u8 serror_has_esr;
+		__u8 ext_dabt_pending;
 		/* Align it to 8 bytes */
-		__u8 pad[6];
+		__u8 pad[5];
 		__u64 serror_esr;
 	} exception;
 	__u32 reserved[12];
@@ -219,10 +220,18 @@ struct kvm_vcpu_events {
 #define KVM_REG_ARM_PTIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 2, 2)
 #define KVM_REG_ARM_PTIMER_CNT		ARM64_SYS_REG(3, 3, 14, 0, 1)
 
-/* EL0 Virtual Timer Registers */
+/*
+ * EL0 Virtual Timer Registers
+ *
+ * WARNING:
+ *      KVM_REG_ARM_TIMER_CVAL and KVM_REG_ARM_TIMER_CNT are not defined
+ *      with the appropriate register encodings.  Their values have been
+ *      accidentally swapped.  As this is set API, the definitions here
+ *      must be used, rather than ones derived from the encodings.
+ */
 #define KVM_REG_ARM_TIMER_CTL		ARM64_SYS_REG(3, 3, 14, 3, 1)
-#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 #define KVM_REG_ARM_TIMER_CVAL		ARM64_SYS_REG(3, 3, 14, 0, 2)
+#define KVM_REG_ARM_TIMER_CNT		ARM64_SYS_REG(3, 3, 14, 3, 2)
 
 /* KVM-as-firmware specific pseudo-registers */
 #define KVM_REG_ARM_FW			(0x0014 << KVM_REG_ARM_COPROC_SHIFT)
@@ -323,10 +332,14 @@ struct kvm_vcpu_events {
 #define KVM_ARM_VCPU_TIMER_CTRL		1
 #define   KVM_ARM_VCPU_TIMER_IRQ_VTIMER		0
 #define   KVM_ARM_VCPU_TIMER_IRQ_PTIMER		1
+#define KVM_ARM_VCPU_PVTIME_CTRL	2
+#define   KVM_ARM_VCPU_PVTIME_IPA	0
 
 /* KVM_IRQ_LINE irq field index values */
+#define KVM_ARM_IRQ_VCPU2_SHIFT		28
+#define KVM_ARM_IRQ_VCPU2_MASK		0xf
 #define KVM_ARM_IRQ_TYPE_SHIFT		24
-#define KVM_ARM_IRQ_TYPE_MASK		0xff
+#define KVM_ARM_IRQ_TYPE_MASK		0xf
 #define KVM_ARM_IRQ_VCPU_SHIFT		16
 #define KVM_ARM_IRQ_VCPU_MASK		0xff
 #define KVM_ARM_IRQ_NUM_SHIFT		0
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index 5e3f12d..10ea1ce 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -116,7 +116,7 @@ struct kvm_irq_level {
 	 * ACPI gsi notion of irq.
 	 * For IA-64 (APIC model) IOAPIC0: irq 0-23; IOAPIC1: irq 24-47..
 	 * For X86 (standard AT mode) PIC0/1: irq 0-15. IOAPIC0: 0-23..
-	 * For ARM: See Documentation/virt/kvm/api.txt
+	 * For ARM: See Documentation/virt/kvm/api.rst
 	 */
 	union {
 		__u32 irq;
@@ -188,10 +188,13 @@ struct kvm_s390_cmma_log {
 struct kvm_hyperv_exit {
 #define KVM_EXIT_HYPERV_SYNIC          1
 #define KVM_EXIT_HYPERV_HCALL          2
+#define KVM_EXIT_HYPERV_SYNDBG         3
 	__u32 type;
+	__u32 pad1;
 	union {
 		struct {
 			__u32 msr;
+			__u32 pad2;
 			__u64 control;
 			__u64 evt_page;
 			__u64 msg_page;
@@ -201,6 +204,15 @@ struct kvm_hyperv_exit {
 			__u64 result;
 			__u64 params[2];
 		} hcall;
+		struct {
+			__u32 msr;
+			__u32 pad2;
+			__u64 control;
+			__u64 status;
+			__u64 send_page;
+			__u64 recv_page;
+			__u64 pending_page;
+		} syndbg;
 	} u;
 };
 
@@ -235,6 +247,8 @@ struct kvm_hyperv_exit {
 #define KVM_EXIT_S390_STSI        25
 #define KVM_EXIT_IOAPIC_EOI       26
 #define KVM_EXIT_HYPERV           27
+#define KVM_EXIT_ARM_NISV         28
+#define KVM_EXIT_RISCV_SBI        28
 
 /* For KVM_EXIT_INTERNAL_ERROR */
 /* Emulate instruction failed. */
@@ -243,6 +257,8 @@ struct kvm_hyperv_exit {
 #define KVM_INTERNAL_ERROR_SIMUL_EX	2
 /* Encounter unexpected vm-exit due to delivery event. */
 #define KVM_INTERNAL_ERROR_DELIVERY_EV	3
+/* Encounter unexpected vm-exit reason */
+#define KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON	4
 
 /* for KVM_RUN, returned by mmap(vcpu_fd, offset=0) */
 struct kvm_run {
@@ -392,6 +408,18 @@ struct kvm_run {
 		} eoi;
 		/* KVM_EXIT_HYPERV */
 		struct kvm_hyperv_exit hyperv;
+		/* KVM_EXIT_ARM_NISV */
+		struct {
+			__u64 esr_iss;
+			__u64 fault_ipa;
+		} arm_nisv;
+		/* KVM_EXIT_RISCV_SBI */
+		struct {
+			unsigned long extension_id;
+			unsigned long function_id;
+			unsigned long args[6];
+			unsigned long ret[2];
+		} riscv_sbi;
 		/* Fix the size of the union. */
 		char padding[256];
 	};
@@ -466,12 +494,17 @@ struct kvm_s390_mem_op {
 	__u32 size;		/* amount of bytes */
 	__u32 op;		/* type of operation */
 	__u64 buf;		/* buffer in userspace */
-	__u8 ar;		/* the access register number */
-	__u8 reserved[31];	/* should be set to 0 */
+	union {
+		__u8 ar;	/* the access register number */
+		__u32 sida_offset; /* offset into the sida */
+		__u8 reserved[32]; /* should be set to 0 */
+	};
 };
 /* types for kvm_s390_mem_op->op */
 #define KVM_S390_MEMOP_LOGICAL_READ	0
 #define KVM_S390_MEMOP_LOGICAL_WRITE	1
+#define KVM_S390_MEMOP_SIDA_READ	2
+#define KVM_S390_MEMOP_SIDA_WRITE	3
 /* flags for kvm_s390_mem_op->flags */
 #define KVM_S390_MEMOP_F_CHECK_ONLY		(1ULL << 0)
 #define KVM_S390_MEMOP_F_INJECT_EXCEPTION	(1ULL << 1)
@@ -996,6 +1029,16 @@ struct kvm_ppc_resize_hpt {
 #define KVM_CAP_ARM_PTRAUTH_ADDRESS 171
 #define KVM_CAP_ARM_PTRAUTH_GENERIC 172
 #define KVM_CAP_PMU_EVENT_FILTER 173
+#define KVM_CAP_ARM_IRQ_LINE_LAYOUT_2 174
+#define KVM_CAP_HYPERV_DIRECT_TLBFLUSH 175
+#define KVM_CAP_PPC_GUEST_DEBUG_SSTEP 176
+#define KVM_CAP_ARM_NISV_TO_USER 177
+#define KVM_CAP_ARM_INJECT_EXT_DABT 178
+#define KVM_CAP_S390_VCPU_RESETS 179
+#define KVM_CAP_S390_PROTECTED 180
+#define KVM_CAP_PPC_SECURE_GUEST 181
+#define KVM_CAP_HALT_POLL 182
+#define KVM_CAP_ASYNC_PF_INT 183
 
 #ifdef KVM_CAP_IRQ_ROUTING
 
@@ -1086,7 +1129,7 @@ struct kvm_xen_hvm_config {
  *
  * KVM_IRQFD_FLAG_RESAMPLE indicates resamplefd is valid and specifies
  * the irqfd to operate in resampling mode for level triggered interrupt
- * emulation.  See Documentation/virt/kvm/api.txt.
+ * emulation.  See Documentation/virt/kvm/api.rst.
  */
 #define KVM_IRQFD_FLAG_RESAMPLE (1 << 1)
 
@@ -1142,6 +1185,7 @@ struct kvm_dirty_tlb {
 #define KVM_REG_S390		0x5000000000000000ULL
 #define KVM_REG_ARM64		0x6000000000000000ULL
 #define KVM_REG_MIPS		0x7000000000000000ULL
+#define KVM_REG_RISCV		0x8000000000000000ULL
 
 #define KVM_REG_SIZE_SHIFT	52
 #define KVM_REG_SIZE_MASK	0x00f0000000000000ULL
@@ -1222,6 +1266,8 @@ enum kvm_device_type {
 #define KVM_DEV_TYPE_ARM_VGIC_ITS	KVM_DEV_TYPE_ARM_VGIC_ITS
 	KVM_DEV_TYPE_XIVE,
 #define KVM_DEV_TYPE_XIVE		KVM_DEV_TYPE_XIVE
+	KVM_DEV_TYPE_ARM_PV_TIME,
+#define KVM_DEV_TYPE_ARM_PV_TIME	KVM_DEV_TYPE_ARM_PV_TIME
 	KVM_DEV_TYPE_MAX,
 };
 
@@ -1332,6 +1378,7 @@ struct kvm_s390_ucas_mapping {
 #define KVM_PPC_GET_CPU_CHAR	  _IOR(KVMIO,  0xb1, struct kvm_ppc_cpu_char)
 /* Available with KVM_CAP_PMU_EVENT_FILTER */
 #define KVM_SET_PMU_EVENT_FILTER  _IOW(KVMIO,  0xb2, struct kvm_pmu_event_filter)
+#define KVM_PPC_SVM_OFF		  _IO(KVMIO,  0xb3)
 
 /* ioctl for vm fd */
 #define KVM_CREATE_DEVICE	  _IOWR(KVMIO,  0xe0, struct kvm_create_device)
@@ -1456,6 +1503,43 @@ struct kvm_enc_region {
 /* Available with KVM_CAP_ARM_SVE */
 #define KVM_ARM_VCPU_FINALIZE	  _IOW(KVMIO,  0xc2, int)
 
+/* Available with  KVM_CAP_S390_VCPU_RESETS */
+#define KVM_S390_NORMAL_RESET	_IO(KVMIO,   0xc3)
+#define KVM_S390_CLEAR_RESET	_IO(KVMIO,   0xc4)
+
+struct kvm_s390_pv_sec_parm {
+	__u64 origin;
+	__u64 length;
+};
+
+struct kvm_s390_pv_unp {
+	__u64 addr;
+	__u64 size;
+	__u64 tweak;
+};
+
+enum pv_cmd_id {
+	KVM_PV_ENABLE,
+	KVM_PV_DISABLE,
+	KVM_PV_SET_SEC_PARMS,
+	KVM_PV_UNPACK,
+	KVM_PV_VERIFY,
+	KVM_PV_PREP_RESET,
+	KVM_PV_UNSHARE_ALL,
+};
+
+struct kvm_pv_cmd {
+	__u32 cmd;	/* Command to be executed */
+	__u16 rc;	/* Ultravisor return code */
+	__u16 rrc;	/* Ultravisor return reason code */
+	__u64 data;	/* Data or address */
+	__u32 flags;    /* flags for future extensions. Must be 0 for now */
+	__u32 reserved[3];
+};
+
+/* Available with KVM_CAP_S390_PROTECTED */
+#define KVM_S390_PV_COMMAND		_IOWR(KVMIO, 0xc5, struct kvm_pv_cmd)
+
 /* Secure Encrypted Virtualization command */
 enum sev_cmd_id {
 	/* Guest initialization commands */
@@ -1606,4 +1690,7 @@ struct kvm_hyperv_eventfd {
 #define KVM_HYPERV_CONN_ID_MASK		0x00ffffff
 #define KVM_HYPERV_EVENTFD_DEASSIGN	(1 << 0)
 
+#define KVM_DIRTY_LOG_MANUAL_PROTECT_ENABLE    (1 << 0)
+#define KVM_DIRTY_LOG_INITIALLY_SET            (1 << 1)
+
 #endif /* __LINUX_KVM_H */
diff --git a/powerpc/include/asm/kvm.h b/powerpc/include/asm/kvm.h
index b0f72de..264e266 100644
--- a/powerpc/include/asm/kvm.h
+++ b/powerpc/include/asm/kvm.h
@@ -667,6 +667,8 @@ struct kvm_ppc_cpu_char {
 
 /* PPC64 eXternal Interrupt Controller Specification */
 #define KVM_DEV_XICS_GRP_SOURCES	1	/* 64-bit source attributes */
+#define KVM_DEV_XICS_GRP_CTRL		2
+#define   KVM_DEV_XICS_NR_SERVERS	1
 
 /* Layout of 64-bit source attribute values */
 #define  KVM_XICS_DESTINATION_SHIFT	0
@@ -683,6 +685,7 @@ struct kvm_ppc_cpu_char {
 #define KVM_DEV_XIVE_GRP_CTRL		1
 #define   KVM_DEV_XIVE_RESET		1
 #define   KVM_DEV_XIVE_EQ_SYNC		2
+#define   KVM_DEV_XIVE_NR_SERVERS	3
 #define KVM_DEV_XIVE_GRP_SOURCE		2	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_SOURCE_CONFIG	3	/* 64-bit source identifier */
 #define KVM_DEV_XIVE_GRP_EQ_CONFIG	4	/* 64-bit EQ identifier */
diff --git a/x86/include/asm/kvm.h b/x86/include/asm/kvm.h
index 503d3f4..17c5a03 100644
--- a/x86/include/asm/kvm.h
+++ b/x86/include/asm/kvm.h
@@ -385,31 +385,48 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT (1 << 4)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
-#define KVM_STATE_NESTED_FORMAT_SVM	1	/* unused */
+#define KVM_STATE_NESTED_FORMAT_SVM	1
 
 #define KVM_STATE_NESTED_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_RUN_PENDING	0x00000002
 #define KVM_STATE_NESTED_EVMCS		0x00000004
+#define KVM_STATE_NESTED_MTF_PENDING	0x00000008
+#define KVM_STATE_NESTED_GIF_SET	0x00000100
 
 #define KVM_STATE_NESTED_SMM_GUEST_MODE	0x00000001
 #define KVM_STATE_NESTED_SMM_VMXON	0x00000002
 
 #define KVM_STATE_NESTED_VMX_VMCS_SIZE	0x1000
 
+#define KVM_STATE_NESTED_SVM_VMCB_SIZE	0x1000
+
+#define KVM_STATE_VMX_PREEMPTION_TIMER_DEADLINE	0x00000001
+
 struct kvm_vmx_nested_state_data {
 	__u8 vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 	__u8 shadow_vmcs12[KVM_STATE_NESTED_VMX_VMCS_SIZE];
 };
 
 struct kvm_vmx_nested_state_hdr {
+	__u32 flags;
 	__u64 vmxon_pa;
 	__u64 vmcs12_pa;
+	__u64 preemption_timer_deadline;
 
 	struct {
 		__u16 flags;
 	} smm;
 };
 
+struct kvm_svm_nested_state_data {
+	/* Save area only used if KVM_STATE_NESTED_RUN_PENDING.  */
+	__u8 vmcb12[KVM_STATE_NESTED_SVM_VMCB_SIZE];
+};
+
+struct kvm_svm_nested_state_hdr {
+	__u64 vmcb_pa;
+};
+
 /* for KVM_CAP_NESTED_STATE */
 struct kvm_nested_state {
 	__u16 flags;
@@ -418,6 +435,7 @@ struct kvm_nested_state {
 
 	union {
 		struct kvm_vmx_nested_state_hdr vmx;
+		struct kvm_svm_nested_state_hdr svm;
 
 		/* Pad the header to 128 bytes.  */
 		__u8 pad[120];
@@ -430,6 +448,7 @@ struct kvm_nested_state {
 	 */
 	union {
 		struct kvm_vmx_nested_state_data vmx[0];
+		struct kvm_svm_nested_state_data svm[0];
 	} data;
 };
 
-- 
2.25.1

