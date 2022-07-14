Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AADC57445C
	for <lists+kvm@lfdr.de>; Thu, 14 Jul 2022 07:12:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233529AbiGNFMX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 14 Jul 2022 01:12:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232896AbiGNFMO (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 14 Jul 2022 01:12:14 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1A0DF9
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 22:12:12 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id j1-20020a17090aeb0100b001ef777a7befso5503544pjz.0
        for <kvm@vger.kernel.org>; Wed, 13 Jul 2022 22:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgLiDAoYPcyypxhVX2l7GXZojd0Jyq/z4Rx4mAw3tsQ=;
        b=m3KM/rmFzvvLB01H+2/fkgsJFvy24PbwNLddwsE/idDO6/3Oh9cZ1cV58Uvp0cdUjE
         tzbkgrpMdB1W88srKe228Z+wFk96QgiaH9VGzEV86we3Mc8KLxghb8OYbux9zisL34lX
         k/nLg1U0q972N9wBh2WzxQ4D0DU0x7KGRyaUz6Kw+Uln7AY4+oTItovDvSSayDw7CfZH
         2EliZU6jTdAjjFtq6dyrLsVx8ybWrKkPCJsn8HLFzcjl1swjz83SBzoZ3vixFIsxJ67D
         tilNu51jm2z29ixLiBYT9uzs13N3IUKzTUB7JymGtkkaCso2IqSlar2SVsQNenXCHLTo
         DIdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VgLiDAoYPcyypxhVX2l7GXZojd0Jyq/z4Rx4mAw3tsQ=;
        b=lumBdAboGYhI/SuSkPt4ntPlCdDBK14wJjlU3cumOxMyUkqxSjiLP82LLOJeknM8/I
         vq+yZ/SX0KWxD/1u6ri4phNOJh2Wz9JcpC4l11Kh7UmiawBEUJqpsbQh2vB5pj1aDlXe
         FAHc3xwdlK5u6vR+ytKwZQyhtrMXF/AtVjRtDES+Ea5J4sDKUBoDXEED1wkDkYGNE1LN
         tzTO/QsZR7pR4hcjRK5j6RnQqC7FKCLn7Yu5r2xMJWLg/6DHtDvnS6SnHii8UF5GV37c
         sLCdK+z1X1FVytDavapAuZnbJlJA99uYNXNbxUg1Hd7WaDHpbG2Qzi8NhjeV0aCkYKmY
         32/Q==
X-Gm-Message-State: AJIora+BaoAN0eEiWLBIApNezMTtdbTWESzovQj0z3JSanHaWuT6NdJO
        zWVgWhPof9zagjZUtTEE3AICEyohBC0+hk5XWWM=
X-Google-Smtp-Source: AGRyM1ukdksMdqEQjf8gs+xueyVQb03Kl01AXQ+Ri+j8lpAYKHsFW+TisB7XjBMhtrkeSFr7+JR8Mw==
X-Received: by 2002:a17:90b:3cf:b0:1ef:8a69:9ad1 with SMTP id go15-20020a17090b03cf00b001ef8a699ad1mr7836177pjb.114.1657775531624;
        Wed, 13 Jul 2022 22:12:11 -0700 (PDT)
Received: from localhost.localdomain ([47.246.98.188])
        by smtp.gmail.com with ESMTPSA id x89-20020a17090a6c6200b001e2f892b352sm2538925pjj.45.2022.07.13.22.12.09
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 13 Jul 2022 22:12:11 -0700 (PDT)
From:   SU Hang <darcysail@gmail.com>
X-Google-Original-From: SU Hang <darcy.sh@antgroup.com>
To:     darcy.sh@antgroup.com, pbonzini@redhat.com, kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH] x86: amd: pmu: test performance counter on AMD
Date:   Thu, 14 Jul 2022 13:12:06 +0800
Message-Id: <20220714051206.19070-1-darcy.sh@antgroup.com>
X-Mailer: git-send-email 2.32.1 (Apple Git-133)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

This test adds performance counter test for AMD CPU, it tests old
performance legacy 4 counters [1] since Family 6(that is AMD K7 CPU),
and new 6 counters [2] since Family 21 (15H).

And because AMD doesn't have some MSRs(e.g. MSR_CORE_PERF_GLOBAL_STATUS)
and fixed counters as Intel, simply disable corresponding statements
or cases.

Another thing worth mentioning is, AMD perf counter doesn't support
select 'reference cycle', disable it too.

> refs[1]: MSRC001_000[4...7] [Performance Event Counter [3:0]] (Core::X86::Msr::PERF_LEGACY_CTR)
> refs[2]: MSRC001_020[1...B] [Performance Event Counter [5:0]] (Core::X86::Msr::PERF_CTR)

Signed-off-by: SU Hang <darcy.sh@antgroup.com>
---
 lib/x86/msr.h |  23 +++++
 x86/pmu.c     | 251 ++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 223 insertions(+), 51 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index fa1c0c8..a8aa907 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -129,6 +129,29 @@
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
 
+/* Fam 15h MSRs */
+#define MSR_F15H_PERF_CTL		0xc0010200
+#define MSR_F15H_PERF_CTL0		MSR_F15H_PERF_CTL
+#define MSR_F15H_PERF_CTL1		(MSR_F15H_PERF_CTL + 2)
+#define MSR_F15H_PERF_CTL2		(MSR_F15H_PERF_CTL + 4)
+#define MSR_F15H_PERF_CTL3		(MSR_F15H_PERF_CTL + 6)
+#define MSR_F15H_PERF_CTL4		(MSR_F15H_PERF_CTL + 8)
+#define MSR_F15H_PERF_CTL5		(MSR_F15H_PERF_CTL + 10)
+
+#define MSR_F15H_PERF_CTR		0xc0010201
+#define MSR_F15H_PERF_CTR0		MSR_F15H_PERF_CTR
+#define MSR_F15H_PERF_CTR1		(MSR_F15H_PERF_CTR + 2)
+#define MSR_F15H_PERF_CTR2		(MSR_F15H_PERF_CTR + 4)
+#define MSR_F15H_PERF_CTR3		(MSR_F15H_PERF_CTR + 6)
+#define MSR_F15H_PERF_CTR4		(MSR_F15H_PERF_CTR + 8)
+#define MSR_F15H_PERF_CTR5		(MSR_F15H_PERF_CTR + 10)
+
+#define MSR_F15H_NB_PERF_CTL		0xc0010240
+#define MSR_F15H_NB_PERF_CTR		0xc0010241
+#define MSR_F15H_PTSC			0xc0010280
+#define MSR_F15H_IC_CFG			0xc0011021
+#define MSR_F15H_EX_CFG			0xc001102c
+
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
diff --git a/x86/pmu.c b/x86/pmu.c
index a46bdbf..dcb462d 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -83,7 +83,9 @@ struct pmu_event {
 	uint32_t unit_sel;
 	int min;
 	int max;
-} gp_events[] = {
+} * gp_events;
+
+struct pmu_event intel_gp_event[] = {
 	{"core cycles", 0x003c, 1*N, 50*N},
 	{"instructions", 0x00c0, 10*N, 10.2*N},
 	{"ref cycles", 0x013c, 1*N, 30*N},
@@ -91,16 +93,26 @@ struct pmu_event {
 	{"llc misses", 0x412e, 1, 1*N},
 	{"branches", 0x00c4, 1*N, 1.1*N},
 	{"branch misses", 0x00c5, 0, 0.1*N},
-}, fixed_events[] = {
+};
+struct pmu_event amd_gp_event[] = {
+	{ "core cycles", 0x0076, 1 * N, 50 * N },
+	{ "instructions", 0x00c0, 10 * N, 10.9 * N },
+	{ "llc references", 0x028f, 1, 5 * N },
+	{ "branches", 0x00c2, 1 * N, 1.1 * N },
+	{ "branch misses", 0x00c3, 0, 0.1 * N },
+};
+struct pmu_event fixed_events[] = {
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
 	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
 };
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
-static u64 gp_counter_base = MSR_IA32_PERFCTR0;
+static u64 gp_counter_base;
 
 static int num_counters;
+static int num_gp_event;
+static bool is_intel_chip;
 
 char *buf;
 
@@ -134,6 +146,9 @@ static bool check_irq(void)
 
 static bool is_gp(pmu_counter_t *evt)
 {
+	/* MSR_F15H_PERF_CTR == 0xc0010201
+	 * MSR_K7_PERFCTR0   == 0xc0010004
+	 * both happened to greater than MSR_IA32_PMC0. */
 	return evt->ctr < MSR_CORE_PERF_FIXED_CTR0 ||
 		evt->ctr >= MSR_IA32_PMC0;
 }
@@ -149,7 +164,8 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 	if (is_gp(cnt)) {
 		int i;
 
-		for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
+		for (i = 0; i < num_gp_event; i++)
+
 			if (gp_events[i].unit_sel == (cnt->config & 0xffff))
 				return &gp_events[i];
 	} else
@@ -161,6 +177,8 @@ static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
 static void global_enable(pmu_counter_t *cnt)
 {
 	cnt->idx = event_to_global_idx(cnt);
+	if (!is_intel_chip)
+		return;
 
 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) |
 			(1ull << cnt->idx));
@@ -168,6 +186,8 @@ static void global_enable(pmu_counter_t *cnt)
 
 static void global_disable(pmu_counter_t *cnt)
 {
+	if (!is_intel_chip)
+		return;
 	wrmsr(MSR_CORE_PERF_GLOBAL_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_CTRL) &
 			~(1ull << cnt->idx));
 }
@@ -176,14 +196,19 @@ static void global_disable(pmu_counter_t *cnt)
 static void start_event(pmu_counter_t *evt)
 {
     wrmsr(evt->ctr, evt->count);
-    if (is_gp(evt))
-	    wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
-			    evt->config | EVNTSEL_EN);
-    else {
+	if (is_gp(evt)) {
+		uint64_t sel;
+		if (is_intel_chip)
+			sel = MSR_P6_EVNTSEL0;
+		else if (gp_counter_base == MSR_F15H_PERF_CTR)
+			sel = MSR_F15H_PERF_CTL;
+		else
+			sel = MSR_K7_EVNTSEL0;
+		wrmsr(sel + event_to_global_idx(evt), evt->config | EVNTSEL_EN);
+	} else {
 	    uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
 	    int shift = (evt->ctr - MSR_CORE_PERF_FIXED_CTR0) * 4;
 	    uint32_t usrospmi = 0;
-
 	    if (evt->config & EVNTSEL_OS)
 		    usrospmi |= (1 << 0);
 	    if (evt->config & EVNTSEL_USR)
@@ -200,10 +225,16 @@ static void start_event(pmu_counter_t *evt)
 static void stop_event(pmu_counter_t *evt)
 {
 	global_disable(evt);
-	if (is_gp(evt))
-		wrmsr(MSR_P6_EVNTSEL0 + event_to_global_idx(evt),
-				evt->config & ~EVNTSEL_EN);
-	else {
+	if (is_gp(evt)) {
+		uint64_t sel;
+		if (is_intel_chip)
+			sel = MSR_P6_EVNTSEL0;
+		else if (gp_counter_base == MSR_F15H_PERF_CTR)
+			sel = MSR_F15H_PERF_CTL;
+		else
+			sel = MSR_K7_EVNTSEL0;
+		wrmsr(sel + event_to_global_idx(evt), evt->config & ~EVNTSEL_EN);
+	} else {
 		uint32_t ctrl = rdmsr(MSR_CORE_PERF_FIXED_CTR_CTRL);
 		int shift = (evt->ctr - MSR_CORE_PERF_FIXED_CTR0) * 4;
 		wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, ctrl & ~(0xf << shift));
@@ -241,10 +272,16 @@ static void check_gp_counter(struct pmu_event *evt)
 	};
 	int i;
 
-	for (i = 0; i < num_counters; i++, cnt.ctr++) {
+	for (i = 0; i < num_counters; i++) {
 		cnt.count = 0;
 		measure(&cnt, 1);
 		report(verify_event(cnt.count, evt), "%s-%d", evt->name, i);
+		if (gp_counter_base == MSR_F15H_PERF_CTR)
+			/* The counter MSRs are interleaved with the event select MSRs,
+			 * since Family 15H. */
+			cnt.ctr += 2;
+		else
+			cnt.ctr++;
 	}
 }
 
@@ -252,7 +289,7 @@ static void check_gp_counters(void)
 {
 	int i;
 
-	for (i = 0; i < sizeof(gp_events)/sizeof(gp_events[0]); i++)
+	for (i = 0; i < num_gp_event; i++)
 		if (!(ebx.full & (1 << i)))
 			check_gp_counter(&gp_events[i]);
 		else
@@ -288,7 +325,12 @@ static void check_counters_many(void)
 		cnt[n].count = 0;
 		cnt[n].ctr = gp_counter_base + n;
 		cnt[n].config = EVNTSEL_OS | EVNTSEL_USR |
-			gp_events[i % ARRAY_SIZE(gp_events)].unit_sel;
+				gp_events[i % num_gp_event].unit_sel;
+
+		if (gp_counter_base == MSR_F15H_PERF_CTR)
+			/* The counter MSRs are interleaved with the event select MSRs,
+			 * since Family 15H. */
+			cnt[i].ctr += n;
 		n++;
 	}
 	for (i = 0; i < edx.split.num_counters_fixed; i++) {
@@ -311,6 +353,7 @@ static void check_counter_overflow(void)
 {
 	uint64_t count;
 	int i;
+	int loop_times;
 	pmu_counter_t cnt = {
 		.ctr = gp_counter_base,
 		.config = EVNTSEL_OS | EVNTSEL_USR | gp_events[1].unit_sel /* instructions */,
@@ -319,18 +362,34 @@ static void check_counter_overflow(void)
 	measure(&cnt, 1);
 	count = cnt.count;
 
-	/* clear status before test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	if (is_intel_chip)
+		/* clear status before test */
+		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+		      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
 
 	report_prefix_push("overflow");
 
-	for (i = 0; i < num_counters + 1; i++, cnt.ctr++) {
+	if (is_intel_chip)
+		loop_times = num_counters + 1;
+	else
+		/* AMD CPU doesn't have fixed counters. */
+		loop_times = num_counters;
+	for (i = 0; i < loop_times; i++) {
 		uint64_t status;
 		int idx;
 
-		cnt.count = 1 - count;
-		if (gp_counter_base == MSR_IA32_PMC0)
+		if (is_intel_chip) {
+			cnt.count = 1 - count;
+			if (gp_counter_base == MSR_IA32_PMC0)
+				cnt.count &= (1ull << eax.split.bit_width) - 1;
+		} else {
+			/* KVM fails to accurate count on AMD CPU,
+			 * due to instructions in hypervisor when set
+			 * AMD64_EVENTSEL_GUESTONLY bit?
+			 */
+			cnt.count = 1 - count * 0.5;
 			cnt.count &= (1ull << eax.split.bit_width) - 1;
+		}
 
 		if (i == num_counters) {
 			cnt.ctr = fixed_events[0].unit_sel;
@@ -343,13 +402,21 @@ static void check_counter_overflow(void)
 			cnt.config &= ~EVNTSEL_INT;
 		idx = event_to_global_idx(&cnt);
 		measure(&cnt, 1);
-		report(cnt.count == 1, "cntr-%d", i);
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-		report(status & (1ull << idx), "status-%d", i);
-		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
-		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-		report(!(status & (1ull << idx)), "status clear-%d", i);
+		if (is_intel_chip) {
+			report(cnt.count == 1, "cntr-%d", i);
+			status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+			report(status & (1ull << idx), "status-%d", i);
+			wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL, status);
+			status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+			report(!(status & (1ull << idx)), "status clear-%d", i);
+		}
 		report(check_irq() == (i % 2), "irq-%d", i);
+		if (gp_counter_base == MSR_F15H_PERF_CTR)
+			/* The counter MSRs are interleaved with the event select MSRs,
+			 * since Family 15H. */
+			cnt.ctr += 2;
+		else
+			cnt.ctr++;
 	}
 
 	report_prefix_pop();
@@ -381,9 +448,13 @@ static void do_rdpmc_fast(void *ptr)
 
 static void check_rdpmc(void)
 {
-	uint64_t val = 0xff0123456789ull;
 	bool exc;
 	int i;
+	uint64_t val;
+	if (is_intel_chip)
+		val = 0xff0123456789ull;
+	else
+		val = 0xffff0123456789ull;
 
 	report_prefix_push("rdpmc");
 
@@ -406,7 +477,10 @@ static void check_rdpmc(void)
 		/* Mask according to the number of supported bits */
 		x &= (1ull << eax.split.bit_width) - 1;
 
-		wrmsr(gp_counter_base + i, val);
+		if (gp_counter_base == MSR_F15H_PERF_CTR)
+			wrmsr(gp_counter_base + i * 2, val);
+		else
+			wrmsr(gp_counter_base + i, val);
 		report(rdpmc(i) == x, "cntr-%d", i);
 
 		exc = test_for_exception(GP_VECTOR, do_rdpmc_fast, &cnt);
@@ -453,9 +527,10 @@ static void check_running_counter_wrmsr(void)
 	stop_event(&evt);
 	report(evt.count < gp_events[1].min, "cntr");
 
-	/* clear status before overflow test */
-	wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
-	      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
+	if (is_intel_chip)
+		/* clear status before overflow test */
+		wrmsr(MSR_CORE_PERF_GLOBAL_OVF_CTRL,
+		      rdmsr(MSR_CORE_PERF_GLOBAL_STATUS));
 
 	evt.count = 0;
 	start_event(&evt);
@@ -468,8 +543,10 @@ static void check_running_counter_wrmsr(void)
 
 	loop();
 	stop_event(&evt);
-	status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
-	report(status & 1, "status");
+	if (is_intel_chip) {
+		status = rdmsr(MSR_CORE_PERF_GLOBAL_STATUS);
+		report(status & 1, "status");
+	}
 
 	report_prefix_pop();
 }
@@ -605,6 +682,45 @@ static void  check_gp_counters_write_width(void)
 	}
 }
 
+static void check_amd_gp_counters_write_width(void)
+{
+	u64 val_64 = 0xffffff0123456789ull;
+	u64 val_32 = val_64 & ((1ull << 32) - 1);
+	u64 val_max_width = val_64 & ((1ull << eax.split.bit_width) - 1);
+	int i;
+
+	/* There are 4 legacy counters, and 6 core PerfMon counters,
+	 * select the less one. */
+	int legacy_num_counter = 4;
+	for (i = 0; i < legacy_num_counter; i++) {
+		wrmsr(MSR_K7_PERFCTR0 + i, val_32);
+		assert(rdmsr(MSR_K7_PERFCTR0 + i) == val_32);
+		assert(rdmsr(MSR_F15H_PERF_CTR + 2 * i) == val_32);
+
+		wrmsr(MSR_K7_PERFCTR0 + i, val_max_width);
+		assert(rdmsr(MSR_K7_PERFCTR0 + i) == val_max_width);
+		assert(rdmsr(MSR_F15H_PERF_CTR + 2 * i) == val_max_width);
+
+		wrmsr(MSR_K7_PERFCTR0 + i, val_64);
+		assert(rdmsr(MSR_K7_PERFCTR0 + i) == val_max_width);
+		assert(rdmsr(MSR_F15H_PERF_CTR + 2 * i) == val_max_width);
+	}
+
+	for (i = 0; i < legacy_num_counter; i++) {
+		wrmsr(MSR_F15H_PERF_CTR + 2 * i, val_32);
+		assert(rdmsr(MSR_K7_PERFCTR0 + i) == val_32);
+		assert(rdmsr(MSR_F15H_PERF_CTR + 2 * i) == val_32);
+
+		wrmsr(MSR_F15H_PERF_CTR + 2 * i, val_max_width);
+		assert(rdmsr(MSR_K7_PERFCTR0 + i) == val_max_width);
+		assert(rdmsr(MSR_F15H_PERF_CTR + 2 * i) == val_max_width);
+
+		wrmsr(MSR_F15H_PERF_CTR + 2 * i, val_64);
+		assert(rdmsr(MSR_K7_PERFCTR0 + i) == val_max_width);
+		assert(rdmsr(MSR_F15H_PERF_CTR + 2 * i) == val_max_width);
+	}
+}
+
 /*
  * Per the SDM, reference cycles are currently implemented using the
  * core crystal clock, TSC, or bus clock. Calibrate to the TSC
@@ -655,27 +771,47 @@ static void set_ref_cycle_expectations(void)
 
 int main(int ac, char **av)
 {
-	struct cpuid id = cpuid(10);
-
-	setup_vm();
-	handle_irq(PC_VECTOR, cnt_overflow);
-	buf = malloc(N*64);
+	struct cpuid id;
+	is_intel_chip = is_intel();
+	if (is_intel_chip) {
+		id = cpuid(10);
+		eax.full = id.a;
+		ebx.full = id.b;
+		edx.full = id.d;
+		gp_counter_base = MSR_IA32_PERFCTR0;
+		gp_events = (struct pmu_event *)&intel_gp_event;
+		num_gp_event = ARRAY_SIZE(intel_gp_event);
+		if (!eax.split.version_id) {
+			printf("No pmu is detected!\n");
+			return report_summary();
+		}
 
-	eax.full = id.a;
-	ebx.full = id.b;
-	edx.full = id.d;
+		if (eax.split.version_id == 1) {
+			printf("PMU version 1 is not supported\n");
+			return report_summary();
+		}
+	} else {
+		gp_counter_base = MSR_K7_PERFCTR0;
+		gp_events = (struct pmu_event *)&amd_gp_event;
+		num_gp_event = ARRAY_SIZE(amd_gp_event);
+		id = cpuid(1);
+		/* Performance-monitoring supported from K7 and later. */
+		if (((id.a & 0xf00) >> 8) < 6) {
+			printf("No pmu is detected!\n");
+			return report_summary();
+		}
 
-	if (!eax.split.version_id) {
-		printf("No pmu is detected!\n");
-		return report_summary();
+		edx.split.num_counters_fixed = 0;
+		eax.split.num_counters = 4;
+		eax.split.bit_width = 48;
 	}
 
-	if (eax.split.version_id == 1) {
-		printf("PMU version 1 is not supported\n");
-		return report_summary();
-	}
+	setup_vm();
+	handle_irq(PC_VECTOR, cnt_overflow);
+	buf = malloc(N * 64);
 
-	set_ref_cycle_expectations();
+	if (is_intel_chip)
+		set_ref_cycle_expectations();
 
 	printf("PMU version:         %d\n", eax.split.version_id);
 	printf("GP counters:         %d\n", eax.split.num_counters);
@@ -693,7 +829,20 @@ int main(int ac, char **av)
 	} else {
 		check_counters();
 
-		if (rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
+		if (!is_intel_chip) {
+			id = raw_cpuid(0x80000001, 0);
+			if (id.c & (1 << 23))
+				/* support core perfmon */
+				gp_counter_base = MSR_F15H_PERF_CTR;
+
+			eax.split.num_counters = 6;
+			num_counters = eax.split.num_counters;
+			report_prefix_push("core perf");
+			check_counters();
+			check_amd_gp_counters_write_width();
+		}
+
+		if (is_intel_chip && rdmsr(MSR_IA32_PERF_CAPABILITIES) & PMU_CAP_FW_WRITES) {
 			gp_counter_base = MSR_IA32_PMC0;
 			report_prefix_push("full-width writes");
 			check_counters();
-- 
2.32.1 (Apple Git-133)

