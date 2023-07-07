Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E1A874AB20
	for <lists+kvm@lfdr.de>; Fri,  7 Jul 2023 08:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbjGGGct (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 7 Jul 2023 02:32:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjGGGcr (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 7 Jul 2023 02:32:47 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04olkn2029.outbound.protection.outlook.com [40.92.46.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B3EF1FC7;
        Thu,  6 Jul 2023 23:32:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JMbdoBG1l9w8An3Q4Gxd2iCZ9ZLu/lfqE/ZUhNbZ3KluGJpIbZOp5xmqxW3Vj/QdSXKRJLARDboYUG2R9QOei3KDWUXSbuMoLO/7Jo0o94pxofKE45itSo9D+LPGs+g+uUYDTre5PWYYdIa1lJJzwS1cxwtCIO/zhrQhjQ5pUCs8VmBTd5/P6y4x7cK83bj3BJuXmcZTNq3sF+9scLFYe65pRUiwa3HL+1i7CYQN70ZGinrdH040C8QFrU5hgscAAC9sEq9DXoA6usvoGL1afjXJqGZR25iP2+aZg+Y+npiN+BdBj6KMfmikZNSlsW4IXzdtPJg/YC7JI344i1uyqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chGnkZflC8iekcTM3+anSczdX6seyNvZF211+zivXAA=;
 b=YPPH9+24rdm3IBYbLgNpO9OwNmLRdqRiAVnCESlygfeywWclQDSiw7rXAtoI1PXs4Mvqy4njJLVZRxdCeI1kaFvEhNc4o41NXaE74eTHM+mLN8jynGFTwToH5ttaixIYJXJgn8sgbZujVM4UzdRcGSbkA4HwbXNSaPPXWVK6qtW/jKnZvn+m3MikY1EKsiEnWNxPkIMoWlj03xtn9AlkZcHHGDSDTXoZV50IE6IX+33AS38k/HgdtylnGY0dU7mtYXLxex/PptqMzicE9Vd6ba6s9VqLL2zqxpImHOmJ7dM3GbN1obu2DU/gBVPMXzIz/AsZIgVYpNz5uOQoOmzXLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chGnkZflC8iekcTM3+anSczdX6seyNvZF211+zivXAA=;
 b=Atr+FGnZEfK8VsDznDqjt4F8fJ5Z2tjr7JA/XMtMRIjZCJ4IYqmPExF/NQXcS+txIBAOOvEC2dfcxma/gDtbTFRa0XoXWbENAhXg7QW1kt/OX+taczL9jxOt2f1jyiIch+CPJjvS47dZAP6mMjAUmB4f+y0idPzsJm0PAKbtFGqByr6HUpxESzihvSYfJxkXES+ZjO2SMFCKOs4KOyEd+Hl/VSD5sUndoCLEWmbQUOF2mKzoPT63rTqScIemk/IotSc63VynwPca/ouPs+fPsRzg0cDAZe3LoctNjOCITVTZve2KkryVKE7y42SM5IeECUqQiZ+220KnipcFUQNYBA==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by SA1PR03MB6468.namprd03.prod.outlook.com (2603:10b6:806:1c3::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.17; Fri, 7 Jul
 2023 06:32:43 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::5e99:a4d4:416:c671%4]) with mapi id 15.20.6565.016; Fri, 7 Jul 2023
 06:32:43 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, linux-kernel@vger.kernel.org
Subject: [RFC 3/3] KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
Date:   Fri,  7 Jul 2023 14:31:26 +0800
Message-ID: <BYAPR03MB413350F93EFB171AAA4CF5BDCD2DA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-TMN:  [tmPf+in8sly8IM4urL5ru7ni7soCAPSt]
X-ClientProxiedBy: SI2PR02CA0034.apcprd02.prod.outlook.com
 (2603:1096:4:195::9) To BYAPR03MB4133.namprd03.prod.outlook.com
 (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1688711486-23514-1-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|SA1PR03MB6468:EE_
X-MS-Office365-Filtering-Correlation-Id: b0da8da8-871f-452e-df00-08db7eb3f7a1
X-MS-Exchange-SLBlob-MailProps: 7qh87CJt6y36AGtJtE3eAQUqDJjjc43RNUZB9V7r9a/Uv4TPyBBhGHRclG0DEvMg6majAMDNKhzFYV9TxW04HtJXACnWRjGDg9C6ClSXkk9leAtqdVW8fOMBvAHUjQ9F+OPPA3F8BnrGlFkxpSDa+zL3UQKiLE29WqFBbi44cuxBrI+aJQfteoigu9yfkqLp3pPYI57FLJgQuEY6dB+OvBrUGW0ut+m6NDT2O4Jcbozu2O8PmStj1iRbqOCZB2DtHwqYUqzCuNV8XRKPbzxwrkhqF7msWvfvgq5ZE6CWfvydDfVxtTY4a8wNhV9a3oOJqX/XSDLjDeEQEOPS4XrKBdcRJAvK1xjE/UGIxLsxSt2GcmOlpnLNLRW9JjDlIG4AOYZ3sd2FnD0xm7tu4s62ttEs3snfRrOfHd/W3iA4QB3qiRvnatdB8UBzdeBYudHOmgKEpmj3XWZCpF6EIPymZDefeXt0a8wdCSS1x2mVK/7ZkhIhOPS7y/ug0r028RBtIBRgI0fM3l24G0CZRc+ZJ2haQ/BUOec3LAUfT6SOGU+rV0yWPUHzPAdOgqJm6jvQB3QcFwGb7fgnBQdU0feRmIoOio26Xw9EU1Jt90X1Of2x2hlinzcZzPVApDG/oKYqlCJww2vSnzpy3CDWDxqwR8osKBsW/BTI6SPQ2txWPA4Pw0zEBfCq6Hz/r9tMOnygz7y7d7dqufLET9V8wXzVCmODk77S+Gq4wfOAp3qppDqwvdLOfrzAAVdfD0D079Xj
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x83PGeGfcCWomRONsCXYZ8K7cBePk1bUBcy7ClUdeZNAWLoh/Q2vNsjib2e5ylc5LNWJWbpJ59NohN3OsGRSRO/9ksfIU1WpyHBjy9wcPontRpSTgKKOnfxOyU1yxC4o6rpe78X0QihKuojM2ChnLntMnzNnjXbQ9H98LeHBlxsnQQcLeW53l6NQfu8VZ3U6f/0F26zKUXF+iaW0sLVxrLJz65/KKkqbsTaA/CHMCSVd15v0WQsrms02zVWBG9YDimyc0Ia6lOYaz95yiYaRNSadKqiZ5ohJ9IJJ1uygnrkhRb4HPGFtPvvLE+SvthIm0zqfNG9xX5zGwnqkU2bShCMZmciHX/zOdrqv7LSYUUcKcw5uB3HGw/XTYu95loJmwOmkH7Bef72fNhn0gM1p+BLNq4WYT8blDTGUdarYwi0+LIv2MMszHZ2ndt+ePFwRb0i/g4sxovnqTFX+zFCW1UE6dWKV1Jqb42Qfvj5xfyzS9CotB9O2VbseYWu8C0kS+eXBKQdJEHu+W1Ec2JXORa2ujws0ER14D9tJPwYojkdKGfwVMCB0TktCiQXPg2wk
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?I4EHEKNQD0Y3LNRIahnOsbIBhZ6QytwNNZBwPTfYdwwWSfpCEXb0UAwJzgBc?=
 =?us-ascii?Q?8b6PrzqqtnfUQRFySVIh5Ie06lE/h5uRYL/5eL3CDRsRYl55D7vV2pHYSHN1?=
 =?us-ascii?Q?xDajwFlLCqJhpRRR4e3J68pHQ7cloZMF40N7vsxAVd/nxWngE6uQZlIRR6Ne?=
 =?us-ascii?Q?iTcR9rn1HiOJ+l2qMAOJkU+vy5O9WTW5un1bjbgZ/zAKNeGhWRh/DwZb8LZw?=
 =?us-ascii?Q?o+KUgLdUh9Y795L7mdndhKOgkwIhEMV8ZDyXBy6AxGIYohTPLmK0QDZ/DxSH?=
 =?us-ascii?Q?DDmsSMh/Orv+hIxeIYvqC2kr9Jx3MbVFXYbuETG0yrvR+fAsfc5rSHri4uti?=
 =?us-ascii?Q?ou2Ej6XcxaWNQE5ANe/mPMMcjW8+BQJ06miEP86hSs7o+NGTOrvPyxrIzKlG?=
 =?us-ascii?Q?SjMDBjSEWhdfXu2HFAFYvosvQYKvoX7B6nsTAUsTCmycXjDUoFTIeJRE1evj?=
 =?us-ascii?Q?EjCGWYBlaH2WRUUNKzdAFSKuKyhcOG68kj3apJgH+ZTLSpwlIgxYkVVpcCDU?=
 =?us-ascii?Q?ZiCFZ2VMgHOpLihyOKTARYyIC9895KqPgWBEquksaoFLOnYGU4jtTtjV6GRF?=
 =?us-ascii?Q?cmk8XAbPz5CpO+e/S3jrS4uShYx0ZbNO/HMFoDttzYssk1DhzvuBW2PhBJ5+?=
 =?us-ascii?Q?PMQ10bip/sRsadkGZf+ZVlpVT8E3rnCjuY30WYgsKtgAtMmHDKIDZm7noW/I?=
 =?us-ascii?Q?cyki3gZvGqPZHY2LG1Rrp6jI7NSp3T5nmyOyiqqVg63C2ZDBqPdQFC6g2jRD?=
 =?us-ascii?Q?XbqE5rbcMoeh4La59CAWfH76gzXnuw+PIHkBQZkZSkpwiFQEWfsuWhan9syo?=
 =?us-ascii?Q?8aT9sQJG2n2dYhybMvQsECKkFfqKW+SWr+kd7HpGgYrYmKUJm8qs0VVW0U7M?=
 =?us-ascii?Q?LEhPpz0kxhC7tP/4tl3DRD0ngvB2Xe19TOXWhAzOLApFMD92s7dTlGWcanem?=
 =?us-ascii?Q?Cm09JHimXSOdEVF5w/CfWpapAtybW0q8XpNNfkiNySrh/KlqqoL/4Cy5AKq2?=
 =?us-ascii?Q?sKRvRGeqEmRAxnXlypKoS1seijU8Uz2FZgTChA0UZCHVPALusqaDkqmp08tD?=
 =?us-ascii?Q?87I6mRWZ69uO/R/SkhblyPH7UEKR6P38IlJvYNj6538Fm+SQnbqRlbCRB6Qe?=
 =?us-ascii?Q?hlVPc5dwiXmvGJvlzwJUZsqQQ1SSHLDOw9R7DY7zFERGdJ0KCJK3Cb+aJ9Bx?=
 =?us-ascii?Q?nmrvoBVd/PjzWbUhYqPRvIGBYIUa7EFyXhAAmZ+zZHTCzuYVd1gahbt44a0?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0da8da8-871f-452e-df00-08db7eb3f7a1
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jul 2023 06:32:43.0767
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR03MB6468
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Everytime guest write msr of MSR_IA32_TSC_DEADLINE, a vm-exit occurs
and host side handle it. However, a lot of the vm-exit is unnecessary
because the timer is often over-written before it expires. This patch
add a new pv feature, namely, lazy tscdeadline, as following,

v : write to msr of tsc deadline
| : timer armed by tsc deadline

         v v v v v        | | | | |
--------------------------------------->  Time

The timer armed by msr write is over-written before expires

         v v v v v        |       |
--------------------------------------->  Time
                          '- arm -'

The 1st timer is responsible for arming the next timer.
When an armed timer is expired, it will check pending and  arm a new timer.

                         Close               Open
--------------------------------------------------------
VM-Exit
             sum         12617503            5815737
            intr      0% 37023            0% 33002
           cpuid      0% 1                0% 0
            halt     19% 2503932         47% 2780683
       msr-write     79% 10046340        51% 2966824
           pause      0% 90               0% 84
   ept-violation      0% 584              0% 336
   ept-misconfig      0% 0                0% 2
preemption-timer      0% 29518            0% 34800
-------------------------------------------------------
MSR-Write
            sum          10046455            2966864
        apic-icr     25% 2533498         93% 2781235
    tsc-deadline     74% 7512945          6% 185629

The vm-exit caused by msr-write is reduced by 70% at least

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/asm/kvm_host.h |  12 +++-
 arch/x86/kernel/apic/apic.c     |  47 ++++++++++++++-
 arch/x86/kvm/cpuid.c            |   1 +
 arch/x86/kvm/lapic.c            | 128 +++++++++++++++++++++++++++++++++++++---
 arch/x86/kvm/lapic.h            |   4 ++
 arch/x86/kvm/x86.c              |  17 +++++-
 6 files changed, 195 insertions(+), 14 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6edb1ac..6b20609 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_LAZY_TSCDEADLINE			KVM_ARCH_REQ(33)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
@@ -713,6 +714,13 @@ struct kvm_queued_exception {
 	bool has_payload;
 };
 
+struct kvm_host_lazy_tscdeadline {
+	u64 msr_val;
+	u64 cached_armed;
+	struct page *page;
+	struct kvm_lazy_tscdeadline *guest;
+};
+
 struct kvm_vcpu_arch {
 	/*
 	 * rip and regs accesses must go through
@@ -944,9 +952,7 @@ struct kvm_vcpu_arch {
 		struct gfn_to_hva_cache data;
 	} pv_eoi;
 
-	struct {
-		u64 msr_val;
-	} lazy_tscdeadline;
+	struct kvm_host_lazy_tscdeadline lazy_tscdeadline;
 
 	u64 msr_kvm_poll_control;
 
diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 7705571..0fe1215 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,7 +62,10 @@
 #include <asm/intel-family.h>
 #include <asm/irq_regs.h>
 #include <asm/cpu.h>
+#include <linux/kvm_para.h>
 
+DECLARE_PER_CPU_DECRYPTED(struct kvm_lazy_tscdeadline, kvm_lazy_tscdeadline);
+ 
 unsigned int num_processors;
 
 unsigned disabled_cpus;
@@ -492,6 +495,43 @@ static int lapic_next_deadline(unsigned long delta,
 	return 0;
 }
 
+static int kvm_lapic_next_deadline(unsigned long delta,
+			       struct clock_event_device *evt)
+{
+	struct kvm_lazy_tscdeadline *lazy_tscddl = this_cpu_ptr(&kvm_lazy_tscdeadline);
+	u64 tsc;
+
+	/* This MSR is special and need a special fence: */
+	weak_wrmsr_fence();
+
+	tsc =  rdtsc() + (((u64) delta) * TSC_DIVISOR);
+
+	/*
+	 *  v : write to msr of tsc deadline
+	 *  | : timer armed by tsc deadline
+	 *
+	 *          v v v v v        | | | | |
+	 * --------------------------------------->  Time
+	 * 
+	 * The timer armed by msr write is over-written before expires
+	 *
+	 *          v v v v v        |       |
+	 * --------------------------------------->  Time
+	 *                           '- arm -' 
+	 *
+	 * The 1st timer is responsible for arming the next timer.
+	 *  - armed, the time has been armed on host side by msr-write
+	 *  - pending, the next expires time set by guest side
+	 *  When timer of 'armed' is expired, it will check pending and
+	 *  arm a new timer.
+	 */
+	lazy_tscddl->pending = tsc;
+	if (!lazy_tscddl->armed || tsc < lazy_tscddl->armed)
+		wrmsrl(MSR_IA32_TSC_DEADLINE, tsc);
+
+	return 0;
+}
+
 static int lapic_timer_shutdown(struct clock_event_device *evt)
 {
 	unsigned int v;
@@ -636,7 +676,12 @@ static void setup_APIC_timer(void)
 		levt->name = "lapic-deadline";
 		levt->features &= ~(CLOCK_EVT_FEAT_PERIODIC |
 				    CLOCK_EVT_FEAT_DUMMY);
-		levt->set_next_event = lapic_next_deadline;
+		if (kvm_para_available() &&
+		    kvm_para_has_feature(KVM_FEATURE_LAZY_TSCDEADLINE)) {
+			levt->set_next_event = kvm_lapic_next_deadline;
+		} else {
+			levt->set_next_event = lapic_next_deadline;
+		}
 		clockevents_config_and_register(levt,
 						tsc_khz * (1000 / TSC_DIVISOR),
 						0xF, ~0UL);
diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 0c9660a..5a12601 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1118,6 +1118,7 @@ static inline int __do_cpuid_func(struct kvm_cpuid_array *array, u32 function)
 			     (1 << KVM_FEATURE_PV_SEND_IPI) |
 			     (1 << KVM_FEATURE_POLL_CONTROL) |
 			     (1 << KVM_FEATURE_PV_SCHED_YIELD) |
+			     (1 << KVM_FEATURE_LAZY_TSCDEADLINE) |
 			     (1 << KVM_FEATURE_ASYNC_PF_INT);
 
 		if (sched_info_on())
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 3c300a1..9d137c8 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1681,6 +1681,94 @@ static int apic_mmio_read(struct kvm_vcpu *vcpu, struct kvm_io_device *this,
 	return 0;
 }
 
+int kvm_lazy_tscdeadline_init(struct kvm_vcpu *vcpu)
+{
+	struct kvm_memory_slot *slot;
+	struct kvm_memslots *slots;
+	struct page *page;
+	kvm_pfn_t pfn;
+	gfn_t gfn;
+	void *hva;
+	u64 msr;
+
+	slots = kvm_memslots(vcpu->kvm);
+	msr = vcpu->arch.lazy_tscdeadline.msr_val;
+	gfn = msr >> PAGE_SHIFT;
+	slot = __gfn_to_memslot(slots, gfn);
+	pfn = gfn_to_pfn_memslot(slot, gfn);
+
+	if (!pfn_valid(pfn))
+		return -EINVAL;
+
+	page = pfn_to_page(pfn);
+	hva = kmap(page);
+	if (!hva)
+		return -EFAULT;
+
+	hva += offset_in_page(msr - KVM_MSR_ENABLED);
+	get_page(page);
+	vcpu->arch.lazy_tscdeadline.page = page;
+	vcpu->arch.lazy_tscdeadline.guest = hva;
+
+	return 0;
+}
+
+void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu)
+{
+	if (vcpu->arch.lazy_tscdeadline.page) {
+		kunmap((void *)vcpu->arch.lazy_tscdeadline.guest);
+		put_page(vcpu->arch.lazy_tscdeadline.page);
+	}
+
+	vcpu->arch.lazy_tscdeadline.cached_armed = 0;
+	vcpu->arch.lazy_tscdeadline.page = NULL;
+	vcpu->arch.lazy_tscdeadline.guest = NULL;
+}
+
+static void kvm_lazy_tscdeadline_update(struct kvm_vcpu *vcpu, u64 tsc)
+{
+	struct kvm_host_lazy_tscdeadline *host = &vcpu->arch.lazy_tscdeadline;
+
+	if (!(host->msr_val & KVM_MSR_ENABLED) ||
+	    !host->guest)
+	    return;
+
+	host->guest->armed = tsc;
+	host->cached_armed = tsc;
+}
+
+void kvm_lazy_tscdeadline_kick(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *host = &vcpu->arch.lazy_tscdeadline;
+	u64 next;
+
+	if (!host->cached_armed ||
+	    !(host->msr_val & KVM_MSR_ENABLED) ||
+	    !host->guest)
+	    return;
+
+	next = host->guest->pending;
+	if (next && next > host->guest->armed) {
+		kvm_set_lapic_tscdeadline_msr(vcpu, next);
+	} else {
+		host->guest->armed = 0;
+		host->cached_armed = 0;
+	}
+}
+
+void kvm_lazy_tscdeadline_clear(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *host = &vcpu->arch.lazy_tscdeadline;
+
+	if (!host->cached_armed ||
+	    !(host->msr_val & KVM_MSR_ENABLED) ||
+	    !host->guest)
+	    return;
+
+	host->guest->armed = 0;
+	host->cached_armed = 0;
+}
+
 static void update_divide_count(struct kvm_lapic *apic)
 {
 	u32 tmp1, tmp2, tdcr;
@@ -1726,8 +1814,12 @@ static void cancel_apic_timer(struct kvm_lapic *apic)
 
 static void apic_update_lvtt(struct kvm_lapic *apic)
 {
-	u32 timer_mode = kvm_lapic_get_reg(apic, APIC_LVTT) &
-			apic->lapic_timer.timer_mode_mask;
+	u32 reg, timer_mode;
+	bool clear;
+
+	reg = kvm_lapic_get_reg(apic, APIC_LVTT);
+	clear = !!(reg & APIC_LVT_MASKED);
+	timer_mode = reg & apic->lapic_timer.timer_mode_mask;
 
 	if (apic->lapic_timer.timer_mode != timer_mode) {
 		if (apic_lvtt_tscdeadline(apic) != (timer_mode ==
@@ -1736,10 +1828,14 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
 			kvm_lapic_set_reg(apic, APIC_TMICT, 0);
 			apic->lapic_timer.period = 0;
 			apic->lapic_timer.tscdeadline = 0;
+			clear = true;
 		}
 		apic->lapic_timer.timer_mode = timer_mode;
 		limit_periodic_timer_frequency(apic);
 	}
+
+	if (clear)
+		kvm_lazy_tscdeadline_clear(apic->vcpu);
 }
 
 /*
@@ -1927,8 +2023,15 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
 		expire = ktime_add_ns(now, ns);
 		expire = ktime_sub_ns(expire, ktimer->timer_advance_ns);
 		hrtimer_start(&ktimer->timer, expire, HRTIMER_MODE_ABS_HARD);
-	} else
+	} else {
 		apic_timer_expired(apic, false);
+		/*
+		 * If the current pending tscdeadline has been expired, we need
+		 * to clear the armed_tscddl otherwise guest will skip following
+		 * msr wtite and clock event hangs
+		 */
+		kvm_lazy_tscdeadline_clear(vcpu);
+	}
 
 	local_irq_restore(flags);
 }
@@ -2100,9 +2203,11 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 		 */
 		if (atomic_read(&ktimer->pending)) {
 			cancel_hv_timer(apic);
+			kvm_lazy_tscdeadline_clear(vcpu);
 		} else if (expired) {
 			apic_timer_expired(apic, false);
 			cancel_hv_timer(apic);
+			kvm_lazy_tscdeadline_clear(vcpu);
 		}
 	}
 
@@ -2153,7 +2258,9 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	apic_timer_expired(apic, false);
 	cancel_hv_timer(apic);
 
-	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
+	if (apic_lvtt_tscdeadline(apic)) {
+		kvm_lazy_tscdeadline_kick(vcpu);
+	} else if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
 		restart_apic_timer(apic);
 	}
@@ -2483,6 +2590,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	apic->lapic_timer.tscdeadline = data;
+	kvm_lazy_tscdeadline_update(vcpu, data);
 	start_apic_timer(apic);
 }
 
@@ -2762,15 +2870,19 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
 {
 	struct kvm_timer *ktimer = container_of(data, struct kvm_timer, timer);
 	struct kvm_lapic *apic = container_of(ktimer, struct kvm_lapic, lapic_timer);
+	enum hrtimer_restart ret = HRTIMER_NORESTART;
 
 	apic_timer_expired(apic, true);
 
-	if (lapic_is_periodic(apic)) {
+	if (apic_lvtt_tscdeadline(apic)) {
+		kvm_make_request(KVM_REQ_LAZY_TSCDEADLINE, apic->vcpu);
+	} else if (lapic_is_periodic(apic)) {
 		advance_periodic_target_expiration(apic);
 		hrtimer_add_expires_ns(&ktimer->timer, ktimer->period);
-		return HRTIMER_RESTART;
-	} else
-		return HRTIMER_NORESTART;
+		ret = HRTIMER_RESTART;
+	}
+
+	return ret;
 }
 
 int kvm_create_lapic(struct kvm_vcpu *vcpu, int timer_advance_ns)
diff --git a/arch/x86/kvm/lapic.h b/arch/x86/kvm/lapic.h
index 0a0ea4b..30a8cf1 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -278,4 +278,8 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 	return kvm_lapic_get_reg(apic, APIC_ID) >> 24;
 }
 
+void kvm_lazy_tscdeadline_clear(struct kvm_vcpu *vcpu);
+void kvm_lazy_tscdeadline_kick(struct kvm_vcpu *vcpu);
+int kvm_lazy_tscdeadline_init(struct kvm_vcpu *vcpu);
+void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 15c265a..8270bd5 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3873,8 +3873,17 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_KVM_LAZY_TSCDEADLINE:
 		if (!guest_pv_has(vcpu, KVM_FEATURE_LAZY_TSCDEADLINE))
 			return 1;
-
-		vcpu->arch.lazy_tscdeadline.msr_val = data;
+ 
+		if (!(data & KVM_MSR_ENABLED)) {
+			kvm_lazy_tscdeadline_clear(vcpu);
+			kvm_lazy_tscdeadline_exit(vcpu);
+		} else {
+			vcpu->arch.lazy_tscdeadline.msr_val = data;
+			if (kvm_lazy_tscdeadline_init(vcpu)) {
+				vcpu->arch.lazy_tscdeadline.msr_val = 0;
+				return 1;
+			}
+		}
 
 		break;
 	case MSR_IA32_MCG_CTL:
@@ -10576,6 +10585,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
+		if (kvm_check_request(KVM_REQ_LAZY_TSCDEADLINE, vcpu))
+			kvm_lazy_tscdeadline_kick(vcpu);
 #ifdef CONFIG_KVM_SMM
 		if (kvm_check_request(KVM_REQ_SMI, vcpu))
 			process_smi(vcpu);
@@ -11965,6 +11976,8 @@ void kvm_arch_vcpu_destroy(struct kvm_vcpu *vcpu)
 
 	kvmclock_reset(vcpu);
 
+	kvm_lazy_tscdeadline_exit(vcpu);
+
 	static_call(kvm_x86_vcpu_free)(vcpu);
 
 	kmem_cache_free(x86_emulator_cache, vcpu->arch.emulate_ctxt);
-- 
2.7.4

