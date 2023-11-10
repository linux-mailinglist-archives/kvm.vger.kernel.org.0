Return-Path: <kvm+bounces-1439-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BE5A77E7777
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3434AB21118
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 326501877;
	Fri, 10 Nov 2023 02:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IkP870qs"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60FB017E6
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:06 +0000 (UTC)
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E822144BA
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:05 -0800 (PST)
Received: by mail-pg1-x549.google.com with SMTP id 41be03b00d2f7-5abf640f19aso1695235a12.2
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583345; x=1700188145; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=GlkhPPn6nZDv6bOYLVvOscI4P+zXzeSQiIG/AC/sj/I=;
        b=IkP870qs9jvQWXsGaSfIGhMqIvwEzm9LPvVJ0ueQ0zIJRvteHxeza5xHsitorBxpyK
         xM/4yD2/lR4Uf/d9bmoij0J+wkYrNYB+S0Ot2HL4lWDhVGWbFVQqNIz6CGEvXpU+61iG
         esZ9dqXBteQljUtz4higRq0J22RddRevrEix4F6Yd2wekSAlJg2EUFC3q5l9M4qJtV+H
         hqj0iVk4s5nWfVJEWnMCjdh+9sx3M+WkF92+Qbdh8VuL+YeO+IAABkV12fy4EHJmx3F7
         5uVxfp+kEc5z3L9p269CD4LWR3e3Kb4l0wLzwT/3q1g/42qQQex3xC77vRyNYHJ0T7JM
         B/JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583345; x=1700188145;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GlkhPPn6nZDv6bOYLVvOscI4P+zXzeSQiIG/AC/sj/I=;
        b=onuoojX6O0iAed9I6HNg+nv6k8hX8bE0xXXA3LIUC3NcD1mxKkaPlnElKDryMjIOVK
         Upg5gKenDQ7au8IhA9M0hW60gN6U93MVG7ZE5s1f/e5l+iezIgmO3BxRhIauigs0vLaK
         +UO0DLVeY2sWdxBkZ3ahx6dVcYQXmYH06nS7yMpvNYBpczVHlgriqgFzyxTnZsRiy6w3
         7iXBRtkCz3oY1a54D2tE2mq2N8hy6lWZka1j4DzbtUHpQ8Z/YdNCB1wZ/LdzzJpeof1k
         ssFXGSh5bmfvDgqQxTZtsG7DGEASpKxpTpfnjAWKqDgSfmgu/53d91khJSOK0oohWlsT
         jNKA==
X-Gm-Message-State: AOJu0Yzz9d4bomXMQnimkauN4lN09DLM1Io7jMgpA+34EZS7Edw5kTd4
	tzURUSzVFUAiImuzE/+qI+RbkU8HLuM=
X-Google-Smtp-Source: AGHT+IEN6+OgyXbLfjlEOgo7Ie4q6e8D88WD1mennCFfHp0tDEnQffxSo3K/M1KYKqn2aUYg1UiSCMpPjMM=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a17:903:1389:b0:1cc:cc77:73ba with SMTP id
 jx9-20020a170903138900b001cccc7773bamr839603plb.8.1699583345452; Thu, 09 Nov
 2023 18:29:05 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:49 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-3-seanjc@google.com>
Subject: [PATCH 02/10] KVM: x86/pmu: Add common define to capture fixed
 counters offset
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Add a common define to "officially" solidify KVM's split of counters,
i.e. to commit to using bits 31:0 to track general purpose counters and
bits 63:32 to track fixed counters (which only Intel supports).  KVM
already bleeds this behavior all over common PMU code, and adding a KVM-
defined macro allows clarifying that the value is a _base_, as oppposed to
the _flag_ that is used to access fixed PMCs via RDPMC (which perf
confusingly calls INTEL_PMC_FIXED_RDPMC_BASE).

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c           |  8 ++++----
 arch/x86/kvm/pmu.h           |  4 +++-
 arch/x86/kvm/vmx/pmu_intel.c | 12 ++++++------
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index b52bab7dc422..714fa6dd912e 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -67,7 +67,7 @@ static const struct x86_cpu_id vmx_pebs_pdist_cpu[] = {
  *        all perf counters (both gp and fixed). The mapping relationship
  *        between pmc and perf counters is as the following:
  *        * Intel: [0 .. KVM_INTEL_PMC_MAX_GENERIC-1] <=> gp counters
- *                 [INTEL_PMC_IDX_FIXED .. INTEL_PMC_IDX_FIXED + 2] <=> fixed
+ *                 [KVM_FIXED_PMC_BASE_IDX .. KVM_FIXED_PMC_BASE_IDX + 2] <=> fixed
  *        * AMD:   [0 .. AMD64_NUM_COUNTERS-1] and, for families 15H
  *          and later, [0 .. AMD64_NUM_COUNTERS_CORE-1] <=> gp counters
  */
@@ -411,7 +411,7 @@ static bool is_gp_event_allowed(struct kvm_x86_pmu_event_filter *f,
 static bool is_fixed_event_allowed(struct kvm_x86_pmu_event_filter *filter,
 				   int idx)
 {
-	int fixed_idx = idx - INTEL_PMC_IDX_FIXED;
+	int fixed_idx = idx - KVM_FIXED_PMC_BASE_IDX;
 
 	if (filter->action == KVM_PMU_EVENT_DENY &&
 	    test_bit(fixed_idx, (ulong *)&filter->fixed_counter_bitmap))
@@ -465,7 +465,7 @@ static void reprogram_counter(struct kvm_pmc *pmc)
 
 	if (pmc_is_fixed(pmc)) {
 		fixed_ctr_ctrl = fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-						  pmc->idx - INTEL_PMC_IDX_FIXED);
+						  pmc->idx - KVM_FIXED_PMC_BASE_IDX);
 		if (fixed_ctr_ctrl & 0x1)
 			eventsel |= ARCH_PERFMON_EVENTSEL_OS;
 		if (fixed_ctr_ctrl & 0x2)
@@ -831,7 +831,7 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 		select_user = config & ARCH_PERFMON_EVENTSEL_USR;
 	} else {
 		config = fixed_ctrl_field(pmc_to_pmu(pmc)->fixed_ctr_ctrl,
-					  pmc->idx - INTEL_PMC_IDX_FIXED);
+					  pmc->idx - KVM_FIXED_PMC_BASE_IDX);
 		select_os = config & 0x1;
 		select_user = config & 0x2;
 	}
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index 87ecf22f5b25..7ffa4f1dedb0 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -18,6 +18,8 @@
 #define VMWARE_BACKDOOR_PMC_REAL_TIME		0x10001
 #define VMWARE_BACKDOOR_PMC_APPARENT_TIME	0x10002
 
+#define KVM_FIXED_PMC_BASE_IDX INTEL_PMC_IDX_FIXED
+
 struct kvm_pmu_ops {
 	struct kvm_pmc *(*pmc_idx_to_pmc)(struct kvm_pmu *pmu, int pmc_idx);
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
@@ -130,7 +132,7 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 
 	if (pmc_is_fixed(pmc))
 		return fixed_ctrl_field(pmu->fixed_ctr_ctrl,
-					pmc->idx - INTEL_PMC_IDX_FIXED) & 0x3;
+					pmc->idx - KVM_FIXED_PMC_BASE_IDX) & 0x3;
 
 	return pmc->eventsel & ARCH_PERFMON_EVENTSEL_ENABLE;
 }
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 0d2fd9fdcf4b..61252bb733c4 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -42,18 +42,18 @@ static void reprogram_fixed_counters(struct kvm_pmu *pmu, u64 data)
 
 		pmc = get_fixed_pmc(pmu, MSR_CORE_PERF_FIXED_CTR0 + i);
 
-		__set_bit(INTEL_PMC_IDX_FIXED + i, pmu->pmc_in_use);
+		__set_bit(KVM_FIXED_PMC_BASE_IDX + i, pmu->pmc_in_use);
 		kvm_pmu_request_counter_reprogram(pmc);
 	}
 }
 
 static struct kvm_pmc *intel_pmc_idx_to_pmc(struct kvm_pmu *pmu, int pmc_idx)
 {
-	if (pmc_idx < INTEL_PMC_IDX_FIXED) {
+	if (pmc_idx < KVM_FIXED_PMC_BASE_IDX) {
 		return get_gp_pmc(pmu, MSR_P6_EVNTSEL0 + pmc_idx,
 				  MSR_P6_EVNTSEL0);
 	} else {
-		u32 idx = pmc_idx - INTEL_PMC_IDX_FIXED;
+		u32 idx = pmc_idx - KVM_FIXED_PMC_BASE_IDX;
 
 		return get_fixed_pmc(pmu, idx + MSR_CORE_PERF_FIXED_CTR0);
 	}
@@ -508,7 +508,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 	for (i = 0; i < pmu->nr_arch_fixed_counters; i++)
 		pmu->fixed_ctr_ctrl_mask &= ~(0xbull << (i * 4));
 	counter_mask = ~(((1ull << pmu->nr_arch_gp_counters) - 1) |
-		(((1ull << pmu->nr_arch_fixed_counters) - 1) << INTEL_PMC_IDX_FIXED));
+		(((1ull << pmu->nr_arch_fixed_counters) - 1) << KVM_FIXED_PMC_BASE_IDX));
 	pmu->global_ctrl_mask = counter_mask;
 
 	/*
@@ -552,7 +552,7 @@ static void intel_pmu_refresh(struct kvm_vcpu *vcpu)
 			pmu->reserved_bits &= ~ICL_EVENTSEL_ADAPTIVE;
 			for (i = 0; i < pmu->nr_arch_fixed_counters; i++) {
 				pmu->fixed_ctr_ctrl_mask &=
-					~(1ULL << (INTEL_PMC_IDX_FIXED + i * 4));
+					~(1ULL << (KVM_FIXED_PMC_BASE_IDX + i * 4));
 			}
 			pmu->pebs_data_cfg_mask = ~0xff00000full;
 		} else {
@@ -578,7 +578,7 @@ static void intel_pmu_init(struct kvm_vcpu *vcpu)
 	for (i = 0; i < KVM_PMC_MAX_FIXED; i++) {
 		pmu->fixed_counters[i].type = KVM_PMC_FIXED;
 		pmu->fixed_counters[i].vcpu = vcpu;
-		pmu->fixed_counters[i].idx = i + INTEL_PMC_IDX_FIXED;
+		pmu->fixed_counters[i].idx = i + KVM_FIXED_PMC_BASE_IDX;
 		pmu->fixed_counters[i].current_config = 0;
 		pmu->fixed_counters[i].eventsel = intel_get_fixed_pmc_eventsel(i);
 	}
-- 
2.42.0.869.gea05f2083d-goog


