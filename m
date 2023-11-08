Return-Path: <kvm+bounces-1108-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 5A4467E4E17
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 01:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id BC215B21551
	for <lists+kvm@lfdr.de>; Wed,  8 Nov 2023 00:32:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 898A0D29E;
	Wed,  8 Nov 2023 00:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Syp0sL31"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D90FCA6F
	for <kvm@vger.kernel.org>; Wed,  8 Nov 2023 00:32:01 +0000 (UTC)
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 295F4199E
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 16:32:00 -0800 (PST)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-5af592fed43so74641037b3.2
        for <kvm@vger.kernel.org>; Tue, 07 Nov 2023 16:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699403520; x=1700008320; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=694GN2yhKF8CrRVn5s3EqhYau/KZr9xDvX1ZDohDyv0=;
        b=Syp0sL31YLpOc/hFnopDkEgW6HeDPFFnq4boVIw6hL9Qy35bcCXtIgK8eV6TvSUjGP
         uPtapynzbQyakDWARLHRbsiawMraCM/rnBCuIayeGojOc2CTG900BMGNy7bIBM2Gm/c4
         ufPSLBd5JBkHM8V/y+FeiM869Qoh4LKcJ7qcq28sTwD6wCBZFVZgamvJqkQw0VLBTQz2
         u2HNybCPjG8h+F+o7U6JX9agm4jaHUuRFTa+RpPAc3mmP4nEDp/kGj5cqIQud0MMw9fN
         Qg6VKQX/2/odGU7YjzrEisSjjqTABl1EWVpB2Q/+Zd6PzKl/Rg42o2OMKYeOc/mbEm+5
         9GkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699403520; x=1700008320;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=694GN2yhKF8CrRVn5s3EqhYau/KZr9xDvX1ZDohDyv0=;
        b=OoVqE//mTACQArJODTpmwsOhDzglzKxLApviYqfXGbqQjUmlTXCUI3GOkHK1hbKyNZ
         zhYxHEiJ1Erx1d1430a2js8kssK04pjjxKJxDucMhrlFdC/moAnYPI7l+kjDZjMcDyoi
         nQJq8+pqnspeLOpCpROFiVmyZqPLYOxihDkx68JT42GVoH0MYR8aubqaaFLHBmJU7OnG
         OhCb7XJfpmpxno7RDRM0XWbyNtFJxYRLKsNxRaLzp/Tr6t7yAPNw8YsRW7KXtnHSHfxT
         P3R3j8XC9MK6kRnQynwWGIV9VlIMfRGLnSRDbnLuxl/MKr/eoXfQcQV87kWZI2I/degO
         rSWQ==
X-Gm-Message-State: AOJu0YzghNFo24Emod1duP4v2s31hxlBaO53xkXidqyhIraljAgSATVG
	4xHR1WbvrSSe+i0iCBo78izwSu6/ZMM=
X-Google-Smtp-Source: AGHT+IH1A3kK5hDcQh/ShzUyxBZkRIs3Y4YH8rWv6hCkghiliOQWrqcnbdaqZTFnJEPKP14s5nejlCCYGbc=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a0d:ebca:0:b0:5a7:acc1:5142 with SMTP id
 u193-20020a0debca000000b005a7acc15142mr4020ywe.8.1699403519923; Tue, 07 Nov
 2023 16:31:59 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  7 Nov 2023 16:31:26 -0800
In-Reply-To: <20231108003135.546002-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231108003135.546002-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231108003135.546002-11-seanjc@google.com>
Subject: [PATCH v7 10/19] KVM: selftests: Test Intel PMU architectural events
 on fixed counters
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

From: Jinrong Liang <cloudliang@tencent.com>

Extend the PMU counters test to validate architectural events using fixed
counters.  The core logic is largely the same, the biggest difference
being that if a fixed counter exists, its associated event is available
(the SDM doesn't explicitly state this to be true, but it's KVM's ABI and
letting software program a fixed counter that doesn't actually count would
be quite bizarre).

Note, fixed counters rely on PERF_GLOBAL_CTRL.

Reviewed-by: Jim Mattson <jmattson@google.com>
Co-developed-by: Like Xu <likexu@tencent.com>
Signed-off-by: Like Xu <likexu@tencent.com>
Signed-off-by: Jinrong Liang <cloudliang@tencent.com>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 .../selftests/kvm/x86_64/pmu_counters_test.c  | 54 +++++++++++++++----
 1 file changed, 45 insertions(+), 9 deletions(-)

diff --git a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
index 5b8687bb4639..9cd308417aeb 100644
--- a/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
+++ b/tools/testing/selftests/kvm/x86_64/pmu_counters_test.c
@@ -150,26 +150,46 @@ static void __guest_test_arch_event(uint8_t idx, struct kvm_x86_pmu_feature even
 	guest_assert_event_count(idx, event, pmc, pmc_msr);
 }
 
+#define X86_PMU_FEATURE_NULL						\
+({									\
+	struct kvm_x86_pmu_feature feature = {};			\
+									\
+	feature;							\
+})
+
+static bool pmu_is_null_feature(struct kvm_x86_pmu_feature event)
+{
+	return !(*(u64 *)&event);
+}
+
 static void guest_test_arch_event(uint8_t idx)
 {
 	const struct {
 		struct kvm_x86_pmu_feature gp_event;
+		struct kvm_x86_pmu_feature fixed_event;
 	} intel_event_to_feature[] = {
-		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES },
-		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED },
-		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES },
-		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES },
-		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES },
-		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED },
-		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED },
-		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS },
+		[INTEL_ARCH_CPU_CYCLES_INDEX]		 = { X86_PMU_FEATURE_CPU_CYCLES, X86_PMU_FEATURE_CPU_CYCLES_FIXED },
+		[INTEL_ARCH_INSTRUCTIONS_RETIRED_INDEX]	 = { X86_PMU_FEATURE_INSNS_RETIRED, X86_PMU_FEATURE_INSNS_RETIRED_FIXED },
+		/*
+		 * Note, the fixed counter for reference cycles is NOT the same
+		 * as the general purpose architectural event.  The fixed counter
+		 * explicitly counts at the same frequency as the TSC, whereas
+		 * the GP event counts at a fixed, but uarch specific, frequency.
+		 * Bundle them here for simplicity.
+		 */
+		[INTEL_ARCH_REFERENCE_CYCLES_INDEX]	 = { X86_PMU_FEATURE_REFERENCE_CYCLES, X86_PMU_FEATURE_REFERENCE_TSC_CYCLES_FIXED },
+		[INTEL_ARCH_LLC_REFERENCES_INDEX]	 = { X86_PMU_FEATURE_LLC_REFERENCES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_LLC_MISSES_INDEX]		 = { X86_PMU_FEATURE_LLC_MISSES, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_RETIRED_INDEX]	 = { X86_PMU_FEATURE_BRANCH_INSNS_RETIRED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_BRANCHES_MISPREDICTED_INDEX] = { X86_PMU_FEATURE_BRANCHES_MISPREDICTED, X86_PMU_FEATURE_NULL },
+		[INTEL_ARCH_TOPDOWN_SLOTS_INDEX]	 = { X86_PMU_FEATURE_TOPDOWN_SLOTS, X86_PMU_FEATURE_TOPDOWN_SLOTS_FIXED },
 	};
 
 	uint32_t nr_gp_counters = this_cpu_property(X86_PROPERTY_PMU_NR_GP_COUNTERS);
 	uint32_t pmu_version = guest_get_pmu_version();
 	/* PERF_GLOBAL_CTRL exists only for Architectural PMU Version 2+. */
 	bool guest_has_perf_global_ctrl = pmu_version >= 2;
-	struct kvm_x86_pmu_feature gp_event;
+	struct kvm_x86_pmu_feature gp_event, fixed_event;
 	uint32_t base_pmc_msr;
 	unsigned int i;
 
@@ -199,6 +219,22 @@ static void guest_test_arch_event(uint8_t idx)
 		__guest_test_arch_event(idx, gp_event, i, base_pmc_msr + i,
 					MSR_P6_EVNTSEL0 + i, eventsel);
 	}
+
+	if (!guest_has_perf_global_ctrl)
+		return;
+
+	fixed_event = intel_event_to_feature[idx].fixed_event;
+	if (pmu_is_null_feature(fixed_event) || !this_pmu_has(fixed_event))
+		return;
+
+	i = fixed_event.f.bit;
+
+	wrmsr(MSR_CORE_PERF_FIXED_CTR_CTRL, FIXED_PMC_CTRL(i, FIXED_PMC_KERNEL));
+
+	__guest_test_arch_event(idx, fixed_event, FIXED_PMC_RDPMC_BASE + i,
+				MSR_CORE_PERF_FIXED_CTR0 + i,
+				MSR_CORE_PERF_GLOBAL_CTRL,
+				FIXED_PMC_GLOBAL_CTRL_ENABLE(i));
 }
 
 static void guest_test_arch_events(void)
-- 
2.42.0.869.gea05f2083d-goog


