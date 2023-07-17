Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64C027559AC
	for <lists+kvm@lfdr.de>; Mon, 17 Jul 2023 04:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbjGQCgS (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Sun, 16 Jul 2023 22:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbjGQCgR (ORCPT <rfc822;kvm@vger.kernel.org>);
        Sun, 16 Jul 2023 22:36:17 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11olkn2010.outbound.protection.outlook.com [40.92.20.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6BB10F0;
        Sun, 16 Jul 2023 19:36:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lBY4HuzdT615LweZlmuHZY+Y2nvkS7bH1gstmgKv/vokGY7oDt8HINIKAhH9VG9JnR96nIQTZwyo0XR81J0uqzEpwiRs1ICg6fNIuMNjqzOGaphvpeaKW8boOy8yuhEXM+qW4qfhzMV54qhIbOzFlHvgPfe4da4gH2n8tXpNm81n6fQSJdaWJvDSJbx3LLYbDl+FF09wlrvncDcSJ+BvSPCPSHQiBquD2ZHMyNl+wCZuulwZb5y4oJZWTcfkdPkn4jXrSelgrFMST5B9vG5QMDfckrk/VoSYQelwpwN5cz7mcfwXYd2TQAdIUqtyzGRneselXEm6RhSgeW3aUCT75g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CLmLg46o1YQxVeGfjfXlACDRDxeQ7Q12Mrdimgl5NSI=;
 b=cILbO58QoPnSCTA11d6lGMuS5Cljpnv5fYLwwKzc3Q8UJvuyuWiYYMI5NjF3O52RCrTCJFXOCZk/sr1LIaqL+ozwQNOItku9iZOzdSyaB6wGqyEMqYtxRK7AbV4ZJszm3eXiAByfPrJpDrQv4ckG9gt0ZOfAdFaGqUAaBjJ8lMpodNe8oi0uARryr/2sGuznmPUY+R5hxNqYsWFYAdv0J2K7SVnGECsF6b586mTwHyPKxCqKV1p/xerL5HJv3TWF+iUjXtlLBvIBO10PrclSy2wPRvg8CLNOuWNKfikZW64onMksxvQZJxJYm++2H94VTAzi4cO6ugvEhaTgvpGnxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CLmLg46o1YQxVeGfjfXlACDRDxeQ7Q12Mrdimgl5NSI=;
 b=aAS/9p11KI8uRXlD8Rle8xnEzfZY54xY0Ww2R0jlv0gaLW/Y4gZH6/vE+qxDNRWRA9BnBCHLx/1iAsFLV0lLFGudnnKYbBLs+SRBrTl+XQ67Q0AAGE4kCJHoe76Uixwk3Wt32KmPZDMGIyF8/ap29wXtm3eHlVgsOz8oG0PZe9+moMDPNooM5obNkO3oL7rewc0aOeP3yI5td/uwTBUOivEfZce/T0lwv3+zuNQaRpRq+Oc6tNpGGT1l6gYwrCP5q/JbbhV2Fp0nS52SnEPOCpQhqg2iszWlFhLW+9PbuUA3MwqEDaEGlmrTAgKp3YMpvbi+w30z9JyX+2qJ8J4yjQ==
Received: from BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
 by PH0PR03MB6512.namprd03.prod.outlook.com (2603:10b6:510:be::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.32; Mon, 17 Jul
 2023 02:36:00 +0000
Received: from BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0]) by BYAPR03MB4133.namprd03.prod.outlook.com
 ([fe80::d952:a79b:d824:3b0%4]) with mapi id 15.20.6588.031; Mon, 17 Jul 2023
 02:35:59 +0000
From:   Wang Jianchao <jianchwa@outlook.com>
To:     seanjc@google.com, tglx@linutronix.de, mingo@redhat.com,
        bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
        hpa@zytor.com, kvm@vger.kernel.org
Cc:     arkinjob@outlook.com, zhi.wang.linux@gmail.com,
        xiaoyao.li@intel.com, linux-kernel@vger.kernel.org
Subject: [RFC V3 5/6] KVM: X86: add lazy tscdeadline support to reduce vm-exit of msr-write
Date:   Mon, 17 Jul 2023 10:35:22 +0800
Message-ID: <BYAPR03MB41331F04C79E84B97ECEF455CD3BA@BYAPR03MB4133.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
References: <1689561323-3695-1-git-send-email-jianchwa@outlook.com>
Content-Type: text/plain
X-TMN:  [LwVuwDQmTUFbJ/JDPhURsiTrOojjlz1ueSsEVx6CujQ=]
X-ClientProxiedBy: SI2P153CA0023.APCP153.PROD.OUTLOOK.COM (2603:1096:4:190::6)
 To BYAPR03MB4133.namprd03.prod.outlook.com (2603:10b6:a03:7d::19)
X-Microsoft-Original-Message-ID: <1689561323-3695-6-git-send-email-jianchwa@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR03MB4133:EE_|PH0PR03MB6512:EE_
X-MS-Office365-Filtering-Correlation-Id: 8052e5ed-8608-4d6b-2b38-08db866e8e12
X-MS-Exchange-SLBlob-MailProps: Cq7lScuPrnqpUrHVo6HYXI9uowj33ZBSFpMPz0Bw/9HYrli5PnUwkdf9+wJ6Toedb0ymRgmcsofRb36E90APTaMPN5i66LURLudtbeGRZiSiRj2bpBg09CnvB00Zr1wSDRQbZEQrOQukL0PX7awevx8EjwFBX4qDH04nfFSzhSoSBbLoqUmUzXzBTacfYk4ENWcyULphhxSfeur0T6xXvLNvIVwgG7BHtW+lpuujRKcEZF37GEDkESF6w3HFEwRIxucrjoV5qgr4pOiXjKgLOyJIiE30lKWwFMI+jE+fY3ulim/pxcaEJCiXSt5AfZM+I05skT+tr26jHJhioBugoqN6WzO5kv4Ab1GcgsyJlXb6hfR7g4UYyESbQ+N69ATkrRoQKKYm6xuCFi7lTHgp3dOBvQdbQSyXkcpnVA7EkHiHd4eXNo28UTGgf8JlhaLjqr7djUHfFOUzCbvLCcw8ub2mlwVCtF8mS8718qPMQoNy8EV4OrTE0BSihBrICbTdEoH/3AEeSR4eajqH0OxXJLmbmbtoxB8LBicxM2WVG1PhFbiSoEUWdcLppNhWOCS5rgS6x39Zv1Oa0wVmT+KNWXw6R1MQZYX14EVKZB+7u7gnZa5yt/jxCsW+jsdTzrTkPT0Ww7ra29yIqc7BPI6KVxlMR9oH4y+XIq75xgDC27tjNIGrU94YEXmugbqWvBAMmXnG4pdC7/FyBOweSRmY7Rz5NKCsvQciarfqSmkg07MDYCMU0jB7Af0wg6HpgZCdjxp/nbQ1y88=
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VUotJz9tzG26UqjDyFI2d50uc9gwCKCdnz23f17Jr6fFBUn6l4VCZPJBpk3spVMK89LhLwysd4Hnz72upXaiEbeBxQTqxVnFQdbykYV3kCrcupx9ZfYRbDwppa3A9jySZOvBAAf58uAvN2wSDYyh4W3YvXqwjubPAHdjhQtGCKuqMPDxwgmzVUqIdE00ELlZdH1LlHdPUJMMtRMG0tM/vGdHTRjUN/x5LiYgl3w7QRMqeyVUTlZHf60I5CcGA37dFPeIfMBVcRR1gB5UFxg6R8pNHBAsVZ57xB4cpRGt5NPApqvs7OlEqK/ovD1AzHzcBbOyJuHQ1NMYwFA0lfB8z8x3hE0akk838lH/LZWIB7D0S3oYnlgUfgrrJ7KhwXBQ+ZJwr5Ejkg9eZ1V7st2TGZpvIfwZWgdOtKLz92AlFWXYEkeXe18UzLvFydrcOzaoZUytlQhaILAuY/sa+LxCe0cIyOvtC92AqjG2CifmrJwcjQGg5I6dIcmBHLo/09N1CK/AyS0b5iCd3tYRbSp6mycxn3DVr9k36QAQ6kcndiNUAy4/+sW4/miIOUEbKqpE
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xUOBRpIBfgyUtESyaLc7ZCXAyybTnSHF8txHImu912T5N6Ydpo7NJehRVdNR?=
 =?us-ascii?Q?aCfvTGb2s/Y1IVcQ9mkCQmT4ssCxiXFy8PWp2ERHAzFy4HYrThcKn08OzNaM?=
 =?us-ascii?Q?Ggc+3Tmxfm//qq22Yh1vz3sB/6fK7xvMn6SJPi3SToUaY40R2bMeOFnmfj2/?=
 =?us-ascii?Q?6NuB8BwQiWSLUTfbPyRwpw3f5K/VfdXQx/jwYg9UEfr68ILY8j6UUiUVw3Ax?=
 =?us-ascii?Q?ndkVyMrfhhlOne9qn8LliXnYrUgfzEnTWYfH0dOhAYQlWsOcggmMbNeVX8Gk?=
 =?us-ascii?Q?Ya0EPwdjMJUI0Ac/RlB1S7XSm2Vu3x2LQgIJh0GgNEoowmarjkIMeAKi8zsY?=
 =?us-ascii?Q?F6ky88SEFpe4tkbSo9JG/h3/FByVyy+VquF70JtUL+vGEN85Ae7VzYHuJwLq?=
 =?us-ascii?Q?sfgf1YkB3dNTkwCbg3NsPyohS7ZKeWdQrvO+Q0oZE0B5lxZeCZYnF88Fr0+V?=
 =?us-ascii?Q?sn5vcSSg3MQcAJJorg+0pb6uZbRHewx/kODWst3YpFOhCNuL3eXrxEwCFTLG?=
 =?us-ascii?Q?+n7S3NM7RvKa/l0BBO5JP6E0O+4RTtA072cPdcGT4BHYIhtmZlGIYPiHkR88?=
 =?us-ascii?Q?K0JfZ/VxBMvTuTFgtuXViSb0HC/J376iUEKspAIaqsYtjDI4Wh5YYdjyIjVK?=
 =?us-ascii?Q?htqNFTNtU7quTsPz4ygeBHq+e8BUSqXTH1GQyOIT5bQ2dixi5f3Xf/OrukcE?=
 =?us-ascii?Q?gabsBCqLc74npYK5pQ6YB/hoKjf1u/ORJK+RDxGFAE3NSF6E5/THb34nY69T?=
 =?us-ascii?Q?qXo27dTxFlNrUgX5QGjdlYiodLHodEups89gpt7GzdpSNl7TLh+fcrs7+RiY?=
 =?us-ascii?Q?uo2DGURelcBEVOJi8L+UeBeOj3LbJXT6t5H3swdgubpchW8UOr3gAIAI4bXB?=
 =?us-ascii?Q?5QY7eHTRhNFQBa9zCREGEtwlaM+AbRovfumNke/CvISuBzzQQNxDuH7itJOd?=
 =?us-ascii?Q?YiVBJClpCn338ipSZhRc9eUiVomlOIQG5Lo2YIXiCTe1CZpwwsGbmypvCB2l?=
 =?us-ascii?Q?OUylGr9nw5M9fJHSodR04UX2K+0MYIZZW3ZAjAlOJt/BG60Y2Qi72VhUfNia?=
 =?us-ascii?Q?OUt834JPJ1SUYclJtYWjQ/rzypQ6ANDFQZIqFejYR9Xp82JAqrcCM0asImMF?=
 =?us-ascii?Q?pvK3QfwwBWuz3aGITv/lvY9/vYeXi9B2xXJHgz5iV6SOZn6mwttql2qbCCDP?=
 =?us-ascii?Q?xOZBPa+95Iqe6S1U5xXaIgTXajeGK6oPdxigB1FU/Rp+Xz1zRLd3sBGia6c?=
 =?us-ascii?Q?=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8052e5ed-8608-4d6b-2b38-08db866e8e12
X-MS-Exchange-CrossTenant-AuthSource: BYAPR03MB4133.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jul 2023 02:35:59.3404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR03MB6512
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This patch adds the main logic of lazy_tscdeadline of host side.
There are 3 operations:
 - UPDATE, when the guest update msr of tsc deadline, we need to
   update the value of 'armed' field of kvm_lazy_tscdeadline
 - KICK, when the hv or sw timer is fired, we need to check the
   'pending' field to decide whether to re-arm timer or inject
   local timer vector. The sw timer is not in vcpu context, so a
   new kvm req is added to handle the kick in vcpu context.
 - CLEAR, this is a bit tricky. We need to clear the 'armed' field
   properly otherwise the guestOS can be hung.

The scenerios need to do CLEAR:
 - convert between period & onshot and tscdeadline
 - mask the lapic timer
 - tscdeadline value has expired before we arm the timer

Here is the test result of netperf TCP_RR on loopback,
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

The vm-exit caused by writing msr of tsc-deadline is reduced by 70%

Signed-off-by: Li Shujin <arkinjob@outlook.com>
Signed-off-by: Wang Jianchao <jianchwa@outlook.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/lapic.c            | 93 +++++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/lapic.h            |  3 +-
 arch/x86/kvm/x86.c              |  3 ++
 4 files changed, 90 insertions(+), 10 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index b036874..b217ae7 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -113,6 +113,7 @@
 	KVM_ARCH_REQ_FLAGS(31, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
 #define KVM_REQ_HV_TLB_FLUSH \
 	KVM_ARCH_REQ_FLAGS(32, KVM_REQUEST_WAIT | KVM_REQUEST_NO_WAKEUP)
+#define KVM_REQ_LAZY_TSCDEADLINE			KVM_ARCH_REQ(33)
 
 #define CR0_RESERVED_BITS                                               \
 	(~(unsigned long)(X86_CR0_PE | X86_CR0_MP | X86_CR0_EM | X86_CR0_TS \
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 71da41e..781516f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -1720,6 +1720,54 @@ void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu)
 	vcpu->arch.lazy_tscdeadline.guest = NULL;
 }
 
+static void kvm_lazy_tscdeadline_update(struct kvm_vcpu *vcpu, u64 tsc)
+{
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+
+	if (!(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+	    return;
+
+	hlt->guest->armed = tsc;
+	hlt->cached_armed = tsc;
+}
+
+bool kvm_lazy_tscdeadline_kick(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+	u64 next;
+	bool ret = false;
+
+	if (!hlt->cached_armed ||
+	    !(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+	    return ret;
+
+	next = hlt->guest->pending;
+	if (next && next > hlt->guest->armed) {
+		kvm_set_lapic_tscdeadline_msr(vcpu, next);
+		ret = true;
+	} else {
+		hlt->guest->armed = 0;
+		hlt->cached_armed = 0;
+	}
+
+	return ret;
+}
+
+void kvm_lazy_tscdeadline_clear(struct kvm_vcpu *vcpu)
+{
+	struct kvm_host_lazy_tscdeadline *hlt = &vcpu->arch.lazy_tscdeadline;
+
+	if (!hlt->cached_armed ||
+	    !(hlt->msr_val & KVM_MSR_ENABLED) ||
+	    !hlt->guest)
+	    return;
+
+	hlt->guest->armed = 0;
+	hlt->cached_armed = 0;
+}
+
 static void update_divide_count(struct kvm_lapic *apic)
 {
 	u32 tmp1, tmp2, tdcr;
@@ -1765,8 +1813,12 @@ static void cancel_apic_timer(struct kvm_lapic *apic)
 
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
@@ -1775,10 +1827,14 @@ static void apic_update_lvtt(struct kvm_lapic *apic)
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
@@ -1966,8 +2022,15 @@ static void start_sw_tscdeadline(struct kvm_lapic *apic)
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
@@ -2145,6 +2208,9 @@ static bool start_hv_timer(struct kvm_lapic *apic)
 		}
 	}
 
+	if (apic_lvtt_tscdeadline(apic) && expired)
+		kvm_lazy_tscdeadline_clear(vcpu);
+
 	trace_kvm_hv_timer_state(vcpu->vcpu_id, ktimer->hv_timer_in_use);
 
 	return true;
@@ -2189,8 +2255,12 @@ void kvm_lapic_expired_hv_timer(struct kvm_vcpu *vcpu)
 	if (!apic->lapic_timer.hv_timer_in_use)
 		goto out;
 	WARN_ON(kvm_vcpu_is_blocking(vcpu));
-	apic_timer_expired(apic, false);
-	cancel_hv_timer(apic);
+
+	if (!apic_lvtt_tscdeadline(apic) ||
+	    !kvm_lazy_tscdeadline_kick(vcpu)) {
+		apic_timer_expired(apic, false);
+		cancel_hv_timer(apic);
+	}
 
 	if (apic_lvtt_period(apic) && apic->lapic_timer.period) {
 		advance_periodic_target_expiration(apic);
@@ -2522,6 +2592,7 @@ void kvm_set_lapic_tscdeadline_msr(struct kvm_vcpu *vcpu, u64 data)
 
 	hrtimer_cancel(&apic->lapic_timer.timer);
 	apic->lapic_timer.tscdeadline = data;
+	kvm_lazy_tscdeadline_update(vcpu, data);
 	start_apic_timer(apic);
 }
 
@@ -2802,15 +2873,19 @@ static enum hrtimer_restart apic_timer_fn(struct hrtimer *data)
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
index 51b9d5b..0387a02 100644
--- a/arch/x86/kvm/lapic.h
+++ b/arch/x86/kvm/lapic.h
@@ -280,5 +280,6 @@ static inline u8 kvm_xapic_id(struct kvm_lapic *apic)
 
 int kvm_lazy_tscdeadline_init(struct kvm_vcpu *vcpu);
 void kvm_lazy_tscdeadline_exit(struct kvm_vcpu *vcpu);
-
+void kvm_lazy_tscdeadline_clear(struct kvm_vcpu *vcpu);
+bool kvm_lazy_tscdeadline_kick(struct kvm_vcpu *vcpu);
 #endif
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 7225fc9..26f0ef3 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3879,6 +3879,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			return 1;
 
 		if (!(data & KVM_MSR_ENABLED)) {
+			kvm_lazy_tscdeadline_clear(vcpu);
 			kvm_lazy_tscdeadline_exit(vcpu);
 		} else {
 			kvm_lazy_tscdeadline_exit(vcpu);
@@ -10584,6 +10585,8 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		}
 		if (kvm_check_request(KVM_REQ_STEAL_UPDATE, vcpu))
 			record_steal_time(vcpu);
+		if (kvm_check_request(KVM_REQ_LAZY_TSCDEADLINE, vcpu))
+			kvm_lazy_tscdeadline_kick(vcpu);
 #ifdef CONFIG_KVM_SMM
 		if (kvm_check_request(KVM_REQ_SMI, vcpu))
 			process_smi(vcpu);
-- 
2.7.4

