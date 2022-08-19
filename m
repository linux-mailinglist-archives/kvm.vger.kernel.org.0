Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D64B6599A87
	for <lists+kvm@lfdr.de>; Fri, 19 Aug 2022 13:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348743AbiHSLKX (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 19 Aug 2022 07:10:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348739AbiHSLKW (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 19 Aug 2022 07:10:22 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8596CFBA7C
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:21 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id t11-20020a17090a510b00b001fac77e9d1fso4531229pjh.5
        for <kvm@vger.kernel.org>; Fri, 19 Aug 2022 04:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=0MZlk0Zl6DlrLN5tLUqz8/7rurpIDa5GeSRgHPEqdmk=;
        b=FI3HHuBX4/sOQQGF2vBCG3QWvVUPTB21jpl+7+QjpG8aRzx57hFhXkjWM+hfa3ubMr
         SacFwO3fTy0TmKkF9hXedc+QwLV3EXomzpKM7tSp8bSYSu0H/K85Myo/c/CR4EVz3yi5
         zUGyD5Ok+a9iQ9tzFb6XXoEHZXt6YyfTPqiLY8Gh9apxrfL4dyjUiz8Kpn1/dFdFUskb
         wBKBCRxsMxk0h4QtYnL5ri/ltiwH0qW36xCCUAiPVyyv39Z1TsH69UB4orp+HNm775sD
         up5P38I2rHkSzJBJZ1+YDlaUV6M6GR2LCe9KYE1sP1qI0xbQURF6NLMeUs6i9QTugdqR
         +LUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=0MZlk0Zl6DlrLN5tLUqz8/7rurpIDa5GeSRgHPEqdmk=;
        b=qY63RPbyq8CSaEB4Uwhj+OjtudVg0GaRzI67iKecEB5uJcYfXIWSQH4wxqq7F4X8I7
         SZN+Y2SwoPcs1uY19kbj4SewVPfhC5bqR2vgCHELPujrE73mU3b+bpGSYKjCRLrEMN5R
         RirtFGQhRheQFbPUg7swrfEhN6EKocafUqOx1XXSThONnyP/3BxW4gIN4+fUgTe18kjr
         WW44RXUdUhmZe4iYVBExj8V7CkLyW4ttIL1b+U21HDp+fS2lLRe/fKWNu8M8N0slYgUZ
         AKUQY61rzfxJ8wue6U2o6kWMP4OvlYS7nJW2nac38rDkhZ/BlzW56jo2slfE5JPFY7Y6
         Fy5g==
X-Gm-Message-State: ACgBeo0aoZEHVDvzeJlMRyQduGE32lDCHx1l/O9XYfk6k8bYBe92iiFV
        vf9z1W8jKblOfAjXFXbac/I=
X-Google-Smtp-Source: AA6agR4a7lH29xNqzAHUjCwfAI/STHfyNaw+OGCcMswGZOpy9d4Tt5lqV8R9avXm0bo+uli/urWqJQ==
X-Received: by 2002:a17:903:22c1:b0:16e:fbcc:f298 with SMTP id y1-20020a17090322c100b0016efbccf298mr7241943plg.2.1660907420993;
        Fri, 19 Aug 2022 04:10:20 -0700 (PDT)
Received: from localhost.localdomain ([103.7.29.32])
        by smtp.gmail.com with ESMTPSA id jd7-20020a170903260700b0016bfbd99f64sm2957778plb.118.2022.08.19.04.10.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Aug 2022 04:10:20 -0700 (PDT)
From:   Like Xu <like.xu.linux@gmail.com>
X-Google-Original-From: Like Xu <likexu@tencent.com>
To:     Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     kvm@vger.kernel.org
Subject: [kvm-unit-tests PATCH v3 13/13] x86/pmu: Update testcases to cover AMD PMU
Date:   Fri, 19 Aug 2022 19:09:39 +0800
Message-Id: <20220819110939.78013-14-likexu@tencent.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819110939.78013-1-likexu@tencent.com>
References: <20220819110939.78013-1-likexu@tencent.com>
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

From: Like Xu <likexu@tencent.com>

AMD core PMU before Zen4 did not have version numbers, there were
no fixed counters, it had a hard-coded number of generic counters,
bit-width, and only hardware events common across amd generations
(starting with K7) were added to amd_gp_events[] table.

All above differences are instantiated at the detection step, and it
also covers the K7 PMU registers, which is consistent with bare-metal.

Signed-off-by: Like Xu <likexu@tencent.com>
---
 lib/x86/msr.h       | 17 ++++++++++++
 lib/x86/processor.h | 32 ++++++++++++++++++++--
 x86/pmu.c           | 67 ++++++++++++++++++++++++++++++++++++++++-----
 3 files changed, 106 insertions(+), 10 deletions(-)

diff --git a/lib/x86/msr.h b/lib/x86/msr.h
index 252e041..5f16a58 100644
--- a/lib/x86/msr.h
+++ b/lib/x86/msr.h
@@ -130,6 +130,23 @@
 #define MSR_AMD64_IBSDCPHYSAD		0xc0011039
 #define MSR_AMD64_IBSCTL		0xc001103a
 
+/* Fam 15h MSRs */
+#define MSR_F15H_PERF_CTL              0xc0010200
+#define MSR_F15H_PERF_CTL0             MSR_F15H_PERF_CTL
+#define MSR_F15H_PERF_CTL1             (MSR_F15H_PERF_CTL + 2)
+#define MSR_F15H_PERF_CTL2             (MSR_F15H_PERF_CTL + 4)
+#define MSR_F15H_PERF_CTL3             (MSR_F15H_PERF_CTL + 6)
+#define MSR_F15H_PERF_CTL4             (MSR_F15H_PERF_CTL + 8)
+#define MSR_F15H_PERF_CTL5             (MSR_F15H_PERF_CTL + 10)
+
+#define MSR_F15H_PERF_CTR              0xc0010201
+#define MSR_F15H_PERF_CTR0             MSR_F15H_PERF_CTR
+#define MSR_F15H_PERF_CTR1             (MSR_F15H_PERF_CTR + 2)
+#define MSR_F15H_PERF_CTR2             (MSR_F15H_PERF_CTR + 4)
+#define MSR_F15H_PERF_CTR3             (MSR_F15H_PERF_CTR + 6)
+#define MSR_F15H_PERF_CTR4             (MSR_F15H_PERF_CTR + 8)
+#define MSR_F15H_PERF_CTR5             (MSR_F15H_PERF_CTR + 10)
+
 /* Fam 10h MSRs */
 #define MSR_FAM10H_MMIO_CONF_BASE	0xc0010058
 #define FAM10H_MMIO_CONF_ENABLE		(1<<0)
diff --git a/lib/x86/processor.h b/lib/x86/processor.h
index 0324220..10bca27 100644
--- a/lib/x86/processor.h
+++ b/lib/x86/processor.h
@@ -793,6 +793,9 @@ static inline void flush_tlb(void)
 
 static inline u8 pmu_version(void)
 {
+	if (!is_intel())
+		return 0;
+
 	return cpuid(10).a & 0xff;
 }
 
@@ -806,19 +809,39 @@ static inline bool this_cpu_has_perf_global_ctrl(void)
 	return pmu_version() > 1;
 }
 
+#define AMD64_NUM_COUNTERS                             4
+#define AMD64_NUM_COUNTERS_CORE                                6
+
+static inline bool has_amd_perfctr_core(void)
+{
+	return cpuid(0x80000001).c & BIT_ULL(23);
+}
+
 static inline u8 pmu_nr_gp_counters(void)
 {
-	return (cpuid(10).a >> 8) & 0xff;
+	if (is_intel()) {
+		return (cpuid(10).a >> 8) & 0xff;
+	} else if (!has_amd_perfctr_core()) {
+		return AMD64_NUM_COUNTERS;
+	}
+
+	return AMD64_NUM_COUNTERS_CORE;
 }
 
 static inline u8 pmu_gp_counter_width(void)
 {
-	return (cpuid(10).a >> 16) & 0xff;
+	if (is_intel())
+		return (cpuid(10).a >> 16) & 0xff;
+	else
+		return 48;
 }
 
 static inline u8 pmu_gp_counter_mask_length(void)
 {
-	return (cpuid(10).a >> 24) & 0xff;
+	if (is_intel())
+		return (cpuid(10).a >> 24) & 0xff;
+	else
+		return pmu_nr_gp_counters();
 }
 
 static inline u8 pmu_nr_fixed_counters(void)
@@ -843,6 +866,9 @@ static inline u8 pmu_fixed_counter_width(void)
 
 static inline bool pmu_gp_counter_is_available(int i)
 {
+	if (!is_intel())
+		return i < pmu_nr_gp_counters();
+
 	/* CPUID.0xA.EBX bit is '1 if they counter is NOT available. */
 	return !(cpuid(10).b & BIT(i));
 }
diff --git a/x86/pmu.c b/x86/pmu.c
index 0706cb1..b6ab10c 100644
--- a/x86/pmu.c
+++ b/x86/pmu.c
@@ -62,6 +62,11 @@ struct pmu_event {
 	{"fixed 1", MSR_CORE_PERF_FIXED_CTR0, 10*N, 10.2*N},
 	{"fixed 2", MSR_CORE_PERF_FIXED_CTR0 + 1, 1*N, 30*N},
 	{"fixed 3", MSR_CORE_PERF_FIXED_CTR0 + 2, 0.1*N, 30*N}
+}, amd_gp_events[] = {
+	{"core cycles", 0x0076, 1*N, 50*N},
+	{"instructions", 0x00c0, 10*N, 10.2*N},
+	{"branches", 0x00c2, 1*N, 1.1*N},
+	{"branch misses", 0x00c3, 0, 0.1*N},
 };
 
 #define PMU_CAP_FW_WRITES	(1ULL << 13)
@@ -105,14 +110,24 @@ static bool check_irq(void)
 
 static bool is_gp(pmu_counter_t *evt)
 {
+	if (!is_intel())
+		return true;
+
 	return evt->ctr < MSR_CORE_PERF_FIXED_CTR0 ||
 		evt->ctr >= MSR_IA32_PMC0;
 }
 
 static int event_to_global_idx(pmu_counter_t *cnt)
 {
-	return cnt->ctr - (is_gp(cnt) ? gp_counter_base :
-		(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
+	if (is_intel())
+		return cnt->ctr - (is_gp(cnt) ? gp_counter_base :
+			(MSR_CORE_PERF_FIXED_CTR0 - FIXED_CNT_INDEX));
+
+	if (gp_counter_base == MSR_F15H_PERF_CTR0) {
+		return (cnt->ctr - gp_counter_base) / 2;
+	} else {
+		return cnt->ctr - gp_counter_base;
+	}
 }
 
 static struct pmu_event* get_counter_event(pmu_counter_t *cnt)
@@ -150,11 +165,17 @@ static void global_disable(pmu_counter_t *cnt)
 
 static inline uint32_t get_gp_counter_msr(unsigned int i)
 {
+	if (gp_counter_base == MSR_F15H_PERF_CTR0)
+		return gp_counter_base + 2 * i;
+
 	return gp_counter_base + i;
 }
 
 static inline uint32_t get_gp_select_msr(unsigned int i)
 {
+	if (gp_select_base == MSR_F15H_PERF_CTL0)
+		return gp_select_base + 2 * i;
+
 	return gp_select_base + i;
 }
 
@@ -334,6 +355,9 @@ static void check_counter_overflow(void)
 			cnt.count &= (1ull << pmu_gp_counter_width()) - 1;
 
 		if (i == nr_gp_counters) {
+			if (!is_intel())
+				break;
+
 			cnt.ctr = fixed_events[0].unit_sel;
 			__measure(&cnt, 0);
 			count = cnt.count;
@@ -494,7 +518,7 @@ static void check_running_counter_wrmsr(void)
 static void check_emulated_instr(void)
 {
 	uint64_t status, instr_start, brnch_start;
-	unsigned int branch_idx = 5;
+	unsigned int branch_idx = is_intel() ? 5 : 2;
 	pmu_counter_t brnch_cnt = {
 		.ctr = get_gp_counter_msr(0),
 		/* branch instructions */
@@ -695,13 +719,35 @@ static bool detect_intel_pmu(void)
 	return true;
 }
 
-static bool pmu_is_detected(void)
+static void amd_switch_to_non_perfctr_core(void)
 {
-	if (!is_intel()) {
-		report_skip("AMD PMU is not supported.");
+	gp_counter_base = MSR_K7_PERFCTR0;
+	gp_select_base = MSR_K7_EVNTSEL0;
+	nr_gp_counters = AMD64_NUM_COUNTERS;
+}
+
+static bool detect_amd_pmu(void)
+{
+	if (!has_amd_perfctr_core()) {
+		report_skip("Missing perfctr_core, unsupported AMD PMU.");
 		return false;
 	}
 
+	nr_gp_counters = pmu_nr_gp_counters();
+	gp_events_size = sizeof(amd_gp_events)/sizeof(amd_gp_events[0]);
+	gp_events = (PMU_EVENTS_ARRAY_t *)amd_gp_events;
+	gp_counter_base = MSR_F15H_PERF_CTR0;
+	gp_select_base = MSR_F15H_PERF_CTL0;
+
+	report_prefix_push("AMD");
+	return true;
+}
+
+static bool pmu_is_detected(void)
+{
+	if (!is_intel())
+		return detect_amd_pmu();
+
 	return detect_intel_pmu();
 }
 
@@ -714,7 +760,8 @@ int main(int ac, char **av)
 	if (!pmu_is_detected())
 		return report_summary();
 
-	set_ref_cycle_expectations();
+	if (is_intel())
+		set_ref_cycle_expectations();
 
 	printf("PMU version:         %d\n", pmu_version());
 	printf("GP counters:         %d\n", nr_gp_counters);
@@ -736,5 +783,11 @@ int main(int ac, char **av)
 		report_prefix_pop();
 	}
 
+	if (!is_intel()) {
+		report_prefix_push("K7");
+		amd_switch_to_non_perfctr_core();
+		check_counters();
+	}
+
 	return report_summary();
 }
-- 
2.37.2

