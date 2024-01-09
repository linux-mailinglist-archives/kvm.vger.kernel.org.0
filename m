Return-Path: <kvm+bounces-5921-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2410582906C
	for <lists+kvm@lfdr.de>; Wed, 10 Jan 2024 00:03:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AAC25288AC1
	for <lists+kvm@lfdr.de>; Tue,  9 Jan 2024 23:03:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E46A3F8CE;
	Tue,  9 Jan 2024 23:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tmLNOqQM"
X-Original-To: kvm@vger.kernel.org
Received: from mail-pg1-f202.google.com (mail-pg1-f202.google.com [209.85.215.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E85B3E48E
	for <kvm@vger.kernel.org>; Tue,  9 Jan 2024 23:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--seanjc.bounces.google.com
Received: by mail-pg1-f202.google.com with SMTP id 41be03b00d2f7-5cd61dccd77so1473518a12.3
        for <kvm@vger.kernel.org>; Tue, 09 Jan 2024 15:02:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1704841377; x=1705446177; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=HsoPw14+SR4y1nfwaUCspMsfITq+8rVX8VzUMdYGdzk=;
        b=tmLNOqQMRC/MuQzqnbjhsoPjImfUUfWsE/MpvXNyny9vbsGzaLzZAdSE8rsGoo6Zm3
         nQQlU1ILKyBGpA9O8k/nEE7DgSAul9qYUDgiMppm81GmUqPFAfTdpnDXmTT8bBSGg+Ah
         pNYnJQ2Ul+vjC0EjtXrki12YV4Pj7p19YOiPS61+iFZH2+T7F2bH1mb2OG55ZLVngyhY
         RXReUyUjgGwBJfco+CnwrPx4HCuqu36J3k3N+BzKXyzwzeCp56esd0Foh90Vy+MRkC24
         Nz/cH7BtOMCNwiXeAxUv5FN1mXCEh4umxbssS/wqtQ1mnEMohkMrYajs7HFudCVPGvG1
         hrpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704841377; x=1705446177;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HsoPw14+SR4y1nfwaUCspMsfITq+8rVX8VzUMdYGdzk=;
        b=kfU2QU+GEAY2VA/m//ByKSXBwlU5Te7g7OrFGZRijWhO0q9fpsfd5KEK6ZxqSVpdaA
         QsiZTwu7v2591/OOtVz8KdyKPjgD8A8L7Xmo/koPTwH+YsIvxux65REN//XqQaaq9Eiv
         yn5NnVx6uNbR9iSD0YULh0M5k5V9JAbn/Ov7on5quhCE/aZS6TOzvh8had8XxpepkoOb
         7n7cr3GMXL+gkYcOo6AxycYbwJ4PTBLrNtWG56KX2mx6BCuFNrM0Uavvkm4qcgpiJota
         3b//PsQn4d8Lkgff5LPYQkOM/vFQDDIxONhSgm/il0kNtIkgBzPJQNP2mUNmuAc0+61s
         uUbQ==
X-Gm-Message-State: AOJu0YxEn9xlmRkNJ0+egoFoJ+IAe2CYLWZ8tpePtrCYyfz9cngQu9vo
	3Of1Yw0bMxQg3wQ1/Q+Dl6j8/J3nvlJDVqW5Kg==
X-Google-Smtp-Source: AGHT+IF7BS6Wu9kwMCDADAn53whFpasanfpkx1w0pa3GTzCM8McjwS4p8hRYSr5n2VOX3f9R/bUAgLZ8dcY=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a02:50d:b0:5ce:5301:f42 with SMTP id
 bx13-20020a056a02050d00b005ce53010f42mr182pgb.4.1704841376753; Tue, 09 Jan
 2024 15:02:56 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Tue,  9 Jan 2024 15:02:22 -0800
In-Reply-To: <20240109230250.424295-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20240109230250.424295-1-seanjc@google.com>
X-Mailer: git-send-email 2.43.0.472.g3155946c3a-goog
Message-ID: <20240109230250.424295-3-seanjc@google.com>
Subject: [PATCH v10 02/29] KVM: x86/pmu: Allow programming events that match
 unsupported arch events
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Kan Liang <kan.liang@linux.intel.com>, Dapeng Mi <dapeng1.mi@linux.intel.com>, 
	Jim Mattson <jmattson@google.com>, Jinrong Liang <cloudliang@tencent.com>, 
	Aaron Lewis <aaronlewis@google.com>, Like Xu <likexu@tencent.com>
Content-Type: text/plain; charset="UTF-8"

Remove KVM's bogus restriction that the guest can't program an event whose
encoding matches an unsupported architectural event.  The enumeration of
an architectural event only says that if a CPU supports an architectural
event, then the event can be programmed using the architectural encoding.
The enumeration does NOT say anything about the encoding when the CPU
doesn't report support the architectural event.

Preventing the guest from counting events whose encoding happens to match
an architectural event breaks existing functionality whenever Intel adds
an architectural encoding that was *ever* used for a CPU that doesn't
enumerate support for the architectural event, even if the encoding is for
the exact same event!

E.g. the architectural encoding for Top-Down Slots is 0x01a4.  Broadwell
CPUs, which do not support the Top-Down Slots architectural event, 0x01a4
is a valid, model-specific event.  Denying guest usage of 0x01a4 if/when
KVM adds support for Top-Down slots would break any Broadwell-based guest.

Reported-by: Kan Liang <kan.liang@linux.intel.com>
Closes: https://lore.kernel.org/all/2004baa6-b494-462c-a11f-8104ea152c6a@linux.intel.com
Fixes: a21864486f7e ("KVM: x86/pmu: Fix available_event_types check for REF_CPU_CYCLES event")
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-pmu-ops.h |  1 -
 arch/x86/kvm/pmu.c                     |  1 -
 arch/x86/kvm/pmu.h                     |  1 -
 arch/x86/kvm/svm/pmu.c                 |  6 ----
 arch/x86/kvm/vmx/pmu_intel.c           | 38 --------------------------
 5 files changed, 47 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-pmu-ops.h b/arch/x86/include/asm/kvm-x86-pmu-ops.h
index 058bc636356a..d7eebee4450c 100644
--- a/arch/x86/include/asm/kvm-x86-pmu-ops.h
+++ b/arch/x86/include/asm/kvm-x86-pmu-ops.h
@@ -12,7 +12,6 @@ BUILD_BUG_ON(1)
  * a NULL definition, for example if "static_call_cond()" will be used
  * at the call sites.
  */
-KVM_X86_PMU_OP(hw_event_available)
 KVM_X86_PMU_OP(pmc_idx_to_pmc)
 KVM_X86_PMU_OP(rdpmc_ecx_to_pmc)
 KVM_X86_PMU_OP(msr_idx_to_pmc)
diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 87cc6c8809ad..30945fea6988 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -441,7 +441,6 @@ static bool check_pmu_event_filter(struct kvm_pmc *pmc)
 static bool pmc_event_is_allowed(struct kvm_pmc *pmc)
 {
 	return pmc_is_globally_enabled(pmc) && pmc_speculative_in_use(pmc) &&
-	       static_call(kvm_x86_pmu_hw_event_available)(pmc) &&
 	       check_pmu_event_filter(pmc);
 }
 
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 7caeb3d8d4fd..87ecf22f5b25 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -19,7 +19,6 @@
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
 struct kvm_pmu_ops {
-	bool (*hw_event_available)(struct kvm_pmc *pmc);
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index b6a7ad4d6914..1475d47c821c 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -73,11 +73,6 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 	return amd_pmc_idx_to_pmc(pmu, idx);
 }
 
-static bool amd_hw_event_available(struct kvm_pmc *pmc)
-{
-	return true;
-}
-
 static bool amd_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -233,7 +228,6 @@ static void amd_pmu_init(struct kvm_vcpu *vcpu)
 }
 
 struct kvm_pmu_ops amd_pmu_ops __initdata = {
-	.hw_event_available = amd_hw_event_available,
 	.pmc_idx_to_pmc = amd_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = amd_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = amd_msr_idx_to_pmc,
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 8207f8c03585..1a7d021a6c7b 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -101,43 +101,6 @@ static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 	}
 }
 
-static bool intel_hw_event_available(struct kvm_pmc *pmc)
-{
-	struct kvm_pmu *pmu = pmc_to_pmu(pmc);
-	u8 event_select = pmc->eventsel & ARCH_PERFMON_EVENTSEL_EVENT;
-	u8 unit_mask = (pmc->eventsel & ARCH_PERFMON_EVENTSEL_UMASK) >> 8;
-	int i;
-
-	/*
-	 * Fixed counters are always available if KVM reaches this point.  If a
-	 * fixed counter is unsupported in hardware or guest CPUID, KVM doesn't
-	 * allow the counter's corresponding MSR to be written.  KVM does use
-	 * architectural events to program fixed counters, as the interface to
-	 * perf doesn't allow requesting a specific fixed counter, e.g. perf
-	 * may (sadly) back a guest fixed PMC with a general purposed counter.
-	 * But if _hardware_ doesn't support the associated event, KVM simply
-	 * doesn't enumerate support for the fixed counter.
-	 */
-	if (pmc_is_fixed(pmc))
-		return true;
-
-	BUILD_BUG_ON(ARRAY_SIZE(intel_arch_events) != NR_INTEL_ARCH_EVENTS);
-
-	/*
-	 * Disallow events reported as unavailable in guest CPUID.  Note, this
-	 * doesn't apply to pseudo-architectural events (see above).
-	 */
-	for (i = 0; i < NR_REAL_INTEL_ARCH_EVENTS; i++) {
-		if (intel_arch_events[i].eventsel != event_select ||
-		    intel_arch_events[i].unit_mask != unit_mask)
-			continue;
-
-		return pmu->available_event_types & BIT(i);
-	}
-
-	return true;
-}
-
 static bool intel_is_valid_rdpmc_ecx(struct kvm_vcpu *vcpu, unsigned int idx)
 {
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -780,7 +743,6 @@ void intel_pmu_cross_mapped_check(struct kvm_pmu *pmu)
 }
 
 struct kvm_pmu_ops intel_pmu_ops __initdata = {
-	.hw_event_available = intel_hw_event_available,
 	.pmc_idx_to_pmc = intel_pmc_idx_to_pmc,
 	.rdpmc_ecx_to_pmc = intel_rdpmc_ecx_to_pmc,
 	.msr_idx_to_pmc = intel_msr_idx_to_pmc,
-- 
2.43.0.472.g3155946c3a-goog


