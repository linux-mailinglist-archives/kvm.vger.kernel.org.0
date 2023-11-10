Return-Path: <kvm+bounces-1444-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C8A247E7781
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 03:29:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EEEA5B21207
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 02:29:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4CFB5259;
	Fri, 10 Nov 2023 02:29:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ndZG/dY7"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B838E4A23
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 02:29:15 +0000 (UTC)
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8AA4780
	for <kvm@vger.kernel.org>; Thu,  9 Nov 2023 18:29:15 -0800 (PST)
Received: by mail-pf1-x44a.google.com with SMTP id d2e1a72fcca58-6bd5730bef9so1612504b3a.1
        for <kvm@vger.kernel.org>; Thu, 09 Nov 2023 18:29:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699583355; x=1700188155; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=np39bj4y47m/snfejc8OQRZHu9kCDIS45raWJG/evqc=;
        b=ndZG/dY7wMUxt8tGo3ttdYofPMeGx3SlMgrfzrv82zRLbHvIwz7Kpcig5n88g2mmy2
         rUhgyN+L6qOiEAce5ICuoPgL43XSYNOAxQ6AelcgXLqk0Q5I04hNSR8x4N5gBO1rCc4f
         gK0KoCLeof2faF0AMJaiCDEyUH2npZDnEldsacUYF6/MzuxJ1qmiSUbjdKUhR1PSAcjo
         x9eXNRpjiPJxioZ7zGJMtRuXvhE41EPTr9Gsvhw30gEBfQT5Gh2M9nYO3A/MRMROQPNj
         pSWz3ztNo5qDYzgKT/2x1y2xMsphFVrkM7vicB7Dbq+uOZEYprdUidYNtTUsclkH3+wC
         CXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699583355; x=1700188155;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=np39bj4y47m/snfejc8OQRZHu9kCDIS45raWJG/evqc=;
        b=HQGi3mPlfqGlzm99olRYXlTr9koVUKjO+FGbDvVxl3TvJMNrr1ZYlbkqBkpUZRGBh1
         WiL2vUoR2HBwfifizJpxSAABl9KAWcaicwHDXYzQUY7N/ncH0uAapiwBU369z6AuqGLM
         zXaUH0tqlKAKl/55FVh3mNt4y06j/YbvWj2ONyaye+7jNZCbyZQAw0uUDzZkb3cDYyUY
         bg/bga7UBDLV0tMB3XuzmI+kp07BfghTWhS7aCMtz/DfB83B7aLEFzdgTjriwl8FxPzy
         3GaoU2KHBRg1jl6rhe5bOeRZpSchYV3Lcd0GSZqoIdXnvMiN2hOxi+Ca23NSBLM3dLAn
         K+Mw==
X-Gm-Message-State: AOJu0Yz8l+fvcDN55jIBf14dOclbWQKCoXtLS/yW9f0bxNsUB+eBvcne
	1Vuh6bdwr8dq0u7VPlqUEQSLWPxBUYc=
X-Google-Smtp-Source: AGHT+IHFAHHN1XHjo3fceIzvJRl7LtTpp6+aRpgDzmT4RzXKGGE6Nx//CNMXJPpbSGYwJOo6JudAIEevVnw=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a05:6a00:a09:b0:6c3:9efc:6747 with SMTP id
 p9-20020a056a000a0900b006c39efc6747mr437017pfh.3.1699583354700; Thu, 09 Nov
 2023 18:29:14 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Thu,  9 Nov 2023 18:28:54 -0800
In-Reply-To: <20231110022857.1273836-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110022857.1273836-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110022857.1273836-8-seanjc@google.com>
Subject: [PATCH 07/10] KVM: x86/pmu: Snapshot event selectors that KVM
 emulates in software
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Konstantin Khorenko <khorenko@virtuozzo.com>, Jim Mattson <jmattson@google.com>
Content-Type: text/plain; charset="UTF-8"

Snapshot the event selectors for the events that KVM emulates in software,
which is currently instructions retired and branch instructions retired.
The event selectors a tied to the underlying CPU, i.e. are constant for a
given platform even though perf doesn't manage the mappings as such.

Getting the event selectors from perf isn't exactly cheap, especially if
mitigations are enabled, as at least one indirect call is involved.

Snapshot the values in KVM instead of optimizing perf as working with the
raw event selectors will be required if KVM ever wants to emulate events
that aren't part of perf's uABI, i.e. that don't have an "enum perf_hw_id"
entry.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/pmu.c        | 17 ++++++++---------
 arch/x86/kvm/pmu.h        | 13 ++++++++++++-
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/x86.c        |  6 +++---
 4 files changed, 24 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/pmu.c b/arch/x86/kvm/pmu.c
index 488d21024a92..45cb8b2a024b 100644
--- a/arch/x86/kvm/pmu.c
+++ b/arch/x86/kvm/pmu.c
@@ -29,6 +29,9 @@
 struct x86_pmu_capability __read_mostly kvm_pmu_cap;
 EXPORT_SYMBOL_GPL(kvm_pmu_cap);
 
+struct kvm_pmu_emulated_event_selectors __read_mostly kvm_pmu_eventsel;
+EXPORT_SYMBOL_GPL(kvm_pmu_eventsel);
+
 /* Precise Distribution of Instructions Retired (PDIR) */
 static const struct x86_cpu_id vmx_pebs_pdir_cpu[] = {
 	X86_MATCH_INTEL_FAM6_MODEL(ICELAKE_D, NULL),
@@ -809,13 +812,6 @@ static void kvm_pmu_incr_counter(struct kvm_pmc *pmc)
 	kvm_pmu_request_counter_reprogram(pmc);
 }
 
-static inline bool eventsel_match_perf_hw_id(struct kvm_pmc *pmc,
-	unsigned int perf_hw_id)
-{
-	return !((pmc->eventsel ^ perf_get_hw_event_config(perf_hw_id)) &
-		AMD64_RAW_EVENT_MASK_NB);
-}
-
 static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 {
 	bool select_os, select_user;
@@ -835,7 +831,7 @@ static inline bool cpl_is_matched(struct kvm_pmc *pmc)
 	return (static_call(kvm_x86_get_cpl)(pmc->vcpu) == 0) ? select_os : select_user;
 }
 
-void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel)
 {
 	DECLARE_BITMAP(bitmap, X86_PMC_IDX_MAX);
 	struct kvm_pmu *pmu = vcpu_to_pmu(vcpu);
@@ -855,7 +851,10 @@ void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id)
 			continue;
 
 		/* Ignore checks for edge detect, pin control, invert and CMASK bits */
-		if (eventsel_match_perf_hw_id(pmc, perf_hw_id) && cpl_is_matched(pmc))
+		if ((pmc->eventsel ^ eventsel) & AMD64_RAW_EVENT_MASK_NB)
+			continue;
+
+		if (cpl_is_matched(pmc))
 			kvm_pmu_incr_counter(pmc);
 	}
 }
diff --git a/arch/x86/kvm/pmu.h b/arch/x86/kvm/pmu.h
index cb62a4e44849..9dc5f549c98c 100644
--- a/arch/x86/kvm/pmu.h
+++ b/arch/x86/kvm/pmu.h
@@ -22,6 +22,11 @@
 
 #define KVM_FIXED_PMC_BASE_IDX INTEL_PMC_IDX_FIXED
 
+struct kvm_pmu_emulated_event_selectors {
+	u64 INSTRUCTIONS_RETIRED;
+	u64 BRANCH_INSTRUCTIONS_RETIRED;
+};
+
 struct kvm_pmu_ops {
 	struct kvm_pmc *(*rdpmc_ecx_to_pmc)(struct kvm_vcpu *vcpu,
 		unsigned int idx, u64 *mask);
@@ -171,6 +176,7 @@ static inline bool pmc_speculative_in_use(struct kvm_pmc *pmc)
 }
 
 extern struct x86_pmu_capability kvm_pmu_cap;
+extern struct kvm_pmu_emulated_event_selectors kvm_pmu_eventsel;
 
 static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 {
@@ -212,6 +218,11 @@ static inline void kvm_init_pmu_capability(const struct kvm_pmu_ops *pmu_ops)
 					  pmu_ops->MAX_NR_GP_COUNTERS);
 	kvm_pmu_cap.num_counters_fixed = min(kvm_pmu_cap.num_counters_fixed,
 					     KVM_PMC_MAX_FIXED);
+
+	kvm_pmu_eventsel.INSTRUCTIONS_RETIRED =
+		perf_get_hw_event_config(PERF_COUNT_HW_INSTRUCTIONS);
+	kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED =
+		perf_get_hw_event_config(PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
 }
 
 static inline void kvm_pmu_request_counter_reprogram(struct kvm_pmc *pmc)
@@ -259,7 +270,7 @@ void kvm_pmu_init(struct kvm_vcpu *vcpu);
 void kvm_pmu_cleanup(struct kvm_vcpu *vcpu);
 void kvm_pmu_destroy(struct kvm_vcpu *vcpu);
 int kvm_vm_ioctl_set_pmu_event_filter(struct kvm *kvm, void __user *argp);
-void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 perf_hw_id);
+void kvm_pmu_trigger_event(struct kvm_vcpu *vcpu, u64 eventsel);
 
 bool is_vmware_backdoor_pmc(u32 pmc_idx);
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..cf985085467b 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -3564,7 +3564,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		return 1;
 	}
 
-	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
+	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
 
 	if (CC(evmptrld_status == EVMPTRLD_VMFAIL))
 		return nested_vmx_failInvalid(vcpu);
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index efbf52a9dc83..9d9b5f9e4b28 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8839,7 +8839,7 @@ int kvm_skip_emulated_instruction(struct kvm_vcpu *vcpu)
 	if (unlikely(!r))
 		return 0;
 
-	kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
+	kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
 
 	/*
 	 * rflags is the old, "raw" value of the flags.  The new value has
@@ -9152,9 +9152,9 @@ int x86_emulate_instruction(struct kvm_vcpu *vcpu, gpa_t cr2_or_gpa,
 		 */
 		if (!ctxt->have_exception ||
 		    exception_type(ctxt->exception.vector) == EXCPT_TRAP) {
-			kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_INSTRUCTIONS);
+			kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.INSTRUCTIONS_RETIRED);
 			if (ctxt->is_branch)
-				kvm_pmu_trigger_event(vcpu, PERF_COUNT_HW_BRANCH_INSTRUCTIONS);
+				kvm_pmu_trigger_event(vcpu, kvm_pmu_eventsel.BRANCH_INSTRUCTIONS_RETIRED);
 			kvm_rip_write(vcpu, ctxt->eip);
 			if (r && (ctxt->tf || (vcpu->guest_debug & KVM_GUESTDBG_SINGLESTEP)))
 				r = kvm_vcpu_do_singlestep(vcpu);
-- 
2.42.0.869.gea05f2083d-goog


