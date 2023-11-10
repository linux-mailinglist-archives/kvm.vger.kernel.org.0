Return-Path: <kvm+bounces-1412-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C34487E771D
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:13:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7EDD91C20CFC
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:13:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EC601C3A;
	Fri, 10 Nov 2023 02:13:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QShtZQss"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAE51852
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:13:20 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E608C449A
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:13:19 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9ab79816a9so1958131276.3
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699582398; x=1700187198; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=rhicNGhqq5fztpWLcEppgCSeLbp+B1utXe2pu96crUY=;
        b=QShtZQss5ZMQEkFgfxVqnAZ6tK+XqK5FtxOwS+bbHxp7x9039XAD8O2cpGyNLnmwBq
         fVQWpy6TIW6vvGkAJ85tgCDHkCJ1kRwrHP+mLaLBsI5OVZpD29BL7NaGoTHBdPx12YmR
         oJ5B2DJMy1TDUxj3FZ+zCUEpV1X3PA/NBKkSKUo4fJUWuR18tcoJlYbdIPYHWeRoJeQG
         HT/OiUblrV38LOb7u1ik4MqrLrcIhPlwzK9HEQbbWulLhHK1rOdHRYFQZ5K6UIDPRURi
         rQd6InUeQtKWF2jsgEz4X59/zpXdfm11zQcH+Jn04Y8ZNW9z4Fk/1Ipx5hMYIooWxkth
         A7ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699582398; x=1700187198;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rhicNGhqq5fztpWLcEppgCSeLbp+B1utXe2pu96crUY=;
        b=dpPo5wTbaS7VgJI+sT06njJLDtoVXerWdJiRwmiK6T7CM/w0X4U3oOLrBbMglQX/9g
         +AzT62/fheoEncQac+v/lDG+K3OHw45yrxL+4BPJSbkuir1Fby3UGL4ke1pP9CsTX+lC
         GREKWPBSMWPTB9o7ud5EQKOzWujgRxybs9bHSUtAGyGNkMGhUwn8jV54dE59lXVyxDww
         FcZ2I5pdCQMPx5KkkSbkrbe2573GNeZ+twBKdAyLOnbWm4n03rKZiIMsHyVMOjbTmQee
         wMWoi9SsVYvplh28WLIOHZwuOYF7CR/Ysw9V0zxbHwaIqXLC/N3O0F/Jt0727zNq2IY+
         Nfcw==
X-Gm-Message-State: AOJu0Yxhlc5hCU8oAMK3PayCD6gn2LVDsnNksBbPOJ9Zsf0BPbNY+Cma
	g38LWrXBYqxv6b/r4fZM8d99U8Bn+18=
X-Google-Smtp-Source: AGHT+IGCXDiHWVwjETF/f/ul/XmyTlRl6YEVHm954WDiLpmdCatrwW0Nxm68rtk/KxJmMp9ndUIiZmG2mzI=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a5b:b4d:0:b0:d9a:d272:ee58 with SMTP id
 b13-20020a5b0b4d000000b00d9ad272ee58mr180101ybr.9.1699582398699; Thu, 09 Nov
 2023 18:13:18 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:12:43 -0800
In-Reply-To: <20231110021306.1269082-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110021306.1269082-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110021306.1269082-4-seanjc@google.com>
Subject: [PATCH v8 03/26] KVM: x86/pmu: Remove KVM's enumeration of Intel's
 architectural encodings
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Drop KVM's enumeration of Intel's architectural event encodings, and
instead open code the three encodings (of which only two are real) that
KVM uses to emulate fixed counters.  Now that KVM doesn't incorrectly
enforce the availability of architectural encodings, there is no reason
for KVM to ever care about the encodings themselves, at least not in the
current format of an array indexed by the encoding's position in CPUID.

Opportunistically add a comment to explain why KVM cares about eventsel
values for fixed counters.

Suggested-by: Jim Mattson <jmattson@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/pmu_intel.c | 72 ++++++++++++------------------------
 1 file changed, 23 insertions(+), 49 deletions(-)

diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 7737ee2fc62f..c4f2c6a268e7 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -22,52 +22,6 @@
 
 #define MSR_PMC_FULL_WIDTH_BIT      (MSR_IA32_PMC0 - MSR_IA32_PERFCTR0)
 
-enum intel_pmu_architectural_events {
-	/*
-	 * The order of the architectural events matters as support for each
-	 * event is enumerated via CPUID using the index of the event.
-	 */
-	INTEL_ARCH_CPU_CYCLES,
-	INTEL_ARCH_INSTRUCTIONS_RETIRED,
-	INTEL_ARCH_REFERENCE_CYCLES,
-	INTEL_ARCH_LLC_REFERENCES,
-	INTEL_ARCH_LLC_MISSES,
-	INTEL_ARCH_BRANCHES_RETIRED,
-	INTEL_ARCH_BRANCHES_MISPREDICTED,
-
-	NR_REAL_INTEL_ARCH_EVENTS,
-
-	/*
-	 * Pseudo-architectural event used to implement IA32_FIXED_CTR2, a.k.a.
-	 * TSC reference cycles.  The architectural reference cycles event may
-	 * or may not actually use the TSC as the reference, e.g. might use the
-	 * core crystal clock or the bus clock (yeah, "architectural").
-	 */
-	PSEUDO_ARCH_REFERENCE_CYCLES = NR_REAL_INTEL_ARCH_EVENTS,
-	NR_INTEL_ARCH_EVENTS,
-};
-
-static struct {
-	u8 eventsel;
-	u8 unit_mask;
-} const intel_arch_events[] = {
-	[INTEL_ARCH_CPU_CYCLES]			= { 0x3c, 0x00 },
-	[INTEL_ARCH_INSTRUCTIONS_RETIRED]	= { 0xc0, 0x00 },
-	[INTEL_ARCH_REFERENCE_CYCLES]		= { 0x3c, 0x01 },
-	[INTEL_ARCH_LLC_REFERENCES]		= { 0x2e, 0x4f },
-	[INTEL_ARCH_LLC_MISSES]			= { 0x2e, 0x41 },
-	[INTEL_ARCH_BRANCHES_RETIRED]		= { 0xc4, 0x00 },
-	[INTEL_ARCH_BRANCHES_MISPREDICTED]	= { 0xc5, 0x00 },
-	[PSEUDO_ARCH_REFERENCE_CYCLES]		= { 0x00, 0x03 },
-};
-
-/* mapping between fixed pmc index and intel_arch_events array */
-static int fixed_pmc_events[] = {
-	[0] = INTEL_ARCH_INSTRUCTIONS_RETIRED,
-	[1] = INTEL_ARCH_CPU_CYCLES,
-	[2] = PSEUDO_ARCH_REFERENCE_CYCLES,
-};
-
 static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 {
 	struct kvm_pmc *pmc;
@@ -442,8 +396,29 @@ static int intel_pmu_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	return 0;
 }
 
+/*
+ * Map fixed counter events to architectural general purpose event encodings.
+ * Perf doesn't provide APIs to allow KVM to directly program a fixed counter,
+ * and so KVM instead programs the architectural event to effectively request
+ * the fixed counter.  Perf isn't guaranteed to use a fixed counter and may
+ * instead program the encoding into a general purpose counter, e.g. if a
+ * different perf_event is already utilizing the requested counter, but the end
+ * result is the same (ignoring the fact that using a general purpose counter
+ * will likely exacerbate counter contention).
+ *
+ * Note, reference cycles is counted using a perf-defined "psuedo-encoding",
+ * as there is no architectural general purpose encoding for reference cycles.
+ */
 static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 {
+	const struct {
+		u8 eventsel;
+		u8 unit_mask;
+	} fixed_pmc_events[] = {
+		[0] = { 0xc0, 0x00 }, /* Instruction Retired / PERF_COUNT_HW_INSTRUCTIONS. */
+		[1] = { 0x3c, 0x00 }, /* CPU Cycles/ PERF_COUNT_HW_CPU_CYCLES. */
+		[2] = { 0x00, 0x03 }, /* Reference Cycles / PERF_COUNT_HW_REF_CPU_CYCLES*/
+	};
 	int i;
 
 	BUILD_BUG_ON(ARRAY_SIZE(fixed_pmc_events) != KVM_PMC_MAX_FIXED);
@@ -451,10 +426,9 @@ static void setup_fixed_pmc_eventsel(struct kvm_pmu *pmu)
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 		int index = array_index_nospec(i, KVM_PMC_MAX_FIXED);
 		struct kvm_pmc *pmc = &pmu->fixed_counters[index];
-		u32 event = fixed_pmc_events[index];
 
-		pmc->eventsel = (intel_arch_events[event].unit_mask << 8) |
-				 intel_arch_events[event].eventsel;
+		pmc->eventsel = (fixed_pmc_events[index].unit_mask << 8) |
+				 fixed_pmc_events[index].eventsel;
 	}
 }
 
-- 
2.42.0.869.gea05f2083d-goog


