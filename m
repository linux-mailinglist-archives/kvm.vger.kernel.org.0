Return-Path: <kvm+bounces-1507-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CB3717E86B7
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:55:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDCC41C20754
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:55:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 52A793D996;
	Fri, 10 Nov 2023 23:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="v+gxPXRy"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4AB3C084
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:38 +0000 (UTC)
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6A3C3C39
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:35 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-d9ab7badadeso3314701276.1
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660535; x=1700265335; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=uF0rSYh2e8K6oYM2L+VYggQrVkUAjq3E8kTRdlqplS0=;
        b=v+gxPXRyC0cRLZkPhFrce2GX4kdBq+2jQUFIzKNj8pC+ZaUvcpOEwieGGcdbd+VD53
         M8oLYclztZxdy7IgVe1bWFC/umP0ko4hw25EgSStlEfnUA857i0GCSs+phb3IEE+xDJ0
         MIZCVmmnutbpHDlfRTKkenfJax8SXP2OAE2csus5UII0r6awr1PCAV8K/8TROZGdpcl2
         YPEK6GVujoefvUlt6JmOZG6JrBsc6KI/PhBYxMaJ/5h8Mvoj7VODeeFihnazoGlwAvQ9
         AATFLKEMCavXgN0bfwpJ2XGWnUaWJB9HVU9icMbUXD4MLnxQUc9eM5+oTdWLbstFXlmq
         LnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660535; x=1700265335;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uF0rSYh2e8K6oYM2L+VYggQrVkUAjq3E8kTRdlqplS0=;
        b=P7Fthlu1eHJdcSK6BARpR2mMcoeIdQIZbK67wgLQGr0KSxl2MVXIbLqKJ16Jz37cqI
         XE9GN7s0soO3nw2xztVI9FHlBcVyEjvbi93kpSgMcCHHkEyNzpjxT1/cQ/gEAzfTTytX
         p364AvZ2sim5k++D73kZ5wWjLri+KkhIfPJTz4En/J5p1H5nQnLGyit7HKYPYYUpE4Ut
         nz3nA9zJM6PsvEEskOuOQwu6DLCPENk9kKfCTEmaxbGVFhguG96+BI/hdizwDCe8Md/X
         oEi6ZzRlv/JeU6mroGrta+fTQnuq3NA2KZGeEjl7b3wXPvC7SuIHSESIqoL2385x/Q+q
         vgKw==
X-Gm-Message-State: AOJu0Yw+azlT57EJz+LS++Wn6mP4zWQ+XtiHhzvFsmP2wEkuRFdt4Asl
	ExXm52T9Qguwp42xk9Iez1Wb6TbIimo=
X-Google-Smtp-Source: AGHT+IHVNvhZqMCVh1N5IT8tN+FYPPIrl7Hcm8PpdcCEanGGoMPUqDg50bAeWQ2eqkrThOfa+V3zAclcF7U=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:9e8c:0:b0:d9a:520f:1988 with SMTP id
 p12-20020a259e8c000000b00d9a520f1988mr18798ybq.4.1699660535230; Fri, 10 Nov
 2023 15:55:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:20 -0800
In-Reply-To: <20231110235528.1561679-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-2-seanjc@google.com>
Subject: [PATCH 1/9] KVM: x86: Rename "governed features" helpers to use "guest_cpu_cap"
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

As the first step toward replacing KVM's so-called "governed features"
framework with a more comprehensive, less poorly named implementation,
replace the "kvm_governed_feature" function prefix with "guest_cpu_cap"
and rename guest_can_use() to guest_cpu_cap_has().

The "guest_cpu_cap" naming scheme mirrors that of "kvm_cpu_cap", and
provides a more clear distinction between guest capabilities, which are
KVM controlled (heh, or one might say "governed"), and guest CPUID, which
with few exceptions is fully userspace controlled.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c      |  2 +-
 arch/x86/kvm/cpuid.h      | 12 ++++++------
 arch/x86/kvm/mmu/mmu.c    |  4 ++--
 arch/x86/kvm/svm/nested.c | 22 +++++++++++-----------
 arch/x86/kvm/svm/svm.c    | 26 +++++++++++++-------------
 arch/x86/kvm/svm/svm.h    |  4 ++--
 arch/x86/kvm/vmx/nested.c |  6 +++---
 arch/x86/kvm/vmx/vmx.c    | 14 +++++++-------
 arch/x86/kvm/x86.c        |  4 ++--
 9 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index dda6fc4cfae8..4f464187b063 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -345,7 +345,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
 				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
 	if (allow_gbpages)
-		kvm_governed_feature_set(vcpu, X86_FEATURE_GBPAGES);
+		guest_cpu_cap_set(vcpu, X86_FEATURE_GBPAGES);
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
 	if (best && apic) {
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index 0b90532b6e26..245416ffa34c 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -254,7 +254,7 @@ static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
 	return kvm_governed_feature_index(x86_feature) >= 0;
 }
 
-static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
+static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
 						     unsigned int x86_feature)
 {
 	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
@@ -263,15 +263,15 @@ static __always_inline void kvm_governed_feature_set(struct kvm_vcpu *vcpu,
 		  vcpu->arch.governed_features.enabled);
 }
 
-static __always_inline void kvm_governed_feature_check_and_set(struct kvm_vcpu *vcpu,
-							       unsigned int x86_feature)
+static __always_inline void guest_cpu_cap_check_and_set(struct kvm_vcpu *vcpu,
+							unsigned int x86_feature)
 {
 	if (kvm_cpu_cap_has(x86_feature) && guest_cpuid_has(vcpu, x86_feature))
-		kvm_governed_feature_set(vcpu, x86_feature);
+		guest_cpu_cap_set(vcpu, x86_feature);
 }
 
-static __always_inline bool guest_can_use(struct kvm_vcpu *vcpu,
-					  unsigned int x86_feature)
+static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
+					      unsigned int x86_feature)
 {
 	BUILD_BUG_ON(!kvm_is_governed_feature(x86_feature));
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b0f01d605617..cfed824587b9 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4801,7 +4801,7 @@ static void reset_guest_rsvds_bits_mask(struct kvm_vcpu *vcpu,
 	__reset_rsvds_bits_mask(&context->guest_rsvd_check,
 				vcpu->arch.reserved_gpa_bits,
 				context->cpu_role.base.level, is_efer_nx(context),
-				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
+				guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES),
 				is_cr4_pse(context),
 				guest_cpuid_is_amd_or_hygon(vcpu));
 }
@@ -4878,7 +4878,7 @@ static void reset_shadow_zero_bits_mask(struct kvm_vcpu *vcpu,
 	__reset_rsvds_bits_mask(shadow_zero_check, reserved_hpa_bits(),
 				context->root_role.level,
 				context->root_role.efer_nx,
-				guest_can_use(vcpu, X86_FEATURE_GBPAGES),
+				guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES),
 				is_pse, is_amd);
 
 	if (!shadow_me_mask)
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 3fea8c47679e..ea0895262b12 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -107,7 +107,7 @@ static void nested_svm_uninit_mmu_context(struct kvm_vcpu *vcpu)
 
 static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 {
-	if (!guest_can_use(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
+	if (!guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_V_VMSAVE_VMLOAD))
 		return true;
 
 	if (!nested_npt_enabled(svm))
@@ -603,7 +603,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb_mark_dirty(vmcb02, VMCB_DR);
 	}
 
-	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
+	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		/*
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
@@ -660,7 +660,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * exit_int_info, exit_int_info_err, next_rip, insn_len, insn_bytes.
 	 */
 
-	if (guest_can_use(vcpu, X86_FEATURE_VGIF) &&
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VGIF) &&
 	    (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK))
 		int_ctl_vmcb12_bits |= (V_GIF_MASK | V_GIF_ENABLE_MASK);
 	else
@@ -698,7 +698,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	vmcb02->control.tsc_offset = vcpu->arch.tsc_offset;
 
-	if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR) &&
 	    svm->tsc_ratio_msr != kvm_caps.default_tsc_scaling_ratio)
 		nested_svm_update_tsc_ratio_msr(vcpu);
 
@@ -719,7 +719,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 	 * what a nrips=0 CPU would do (L1 is responsible for advancing RIP
 	 * prior to injecting the event).
 	 */
-	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = svm->nested.ctl.next_rip;
 	else if (boot_cpu_has(X86_FEATURE_NRIPS))
 		vmcb02->control.next_rip    = vmcb12_rip;
@@ -729,7 +729,7 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 		svm->soft_int_injected = true;
 		svm->soft_int_csbase = vmcb12_csbase;
 		svm->soft_int_old_rip = vmcb12_rip;
-		if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 			svm->soft_int_next_rip = svm->nested.ctl.next_rip;
 		else
 			svm->soft_int_next_rip = vmcb12_rip;
@@ -737,18 +737,18 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 
 	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
 					      LBR_CTL_ENABLE_MASK;
-	if (guest_can_use(vcpu, X86_FEATURE_LBRV))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV))
 		vmcb02->control.virt_ext  |=
 			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
 		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
 
-	if (guest_can_use(vcpu, X86_FEATURE_PAUSEFILTER))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
 		pause_count12 = svm->nested.ctl.pause_filter_count;
 	else
 		pause_count12 = 0;
-	if (guest_can_use(vcpu, X86_FEATURE_PFTHRESHOLD))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PFTHRESHOLD))
 		pause_thresh12 = svm->nested.ctl.pause_filter_thresh;
 	else
 		pause_thresh12 = 0;
@@ -1035,7 +1035,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (vmcb12->control.exit_code != SVM_EXIT_ERR)
 		nested_save_pending_event_to_vmcb12(svm, vmcb12);
 
-	if (guest_can_use(vcpu, X86_FEATURE_NRIPS))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_NRIPS))
 		vmcb12->control.next_rip  = vmcb02->control.next_rip;
 
 	vmcb12->control.int_ctl           = svm->nested.ctl.int_ctl;
@@ -1074,7 +1074,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	if (!nested_exit_on_intr(svm))
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
-	if (unlikely(guest_can_use(vcpu, X86_FEATURE_LBRV) &&
+	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
 		svm_update_lbrv(vcpu);
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 1855a6d7c976..8a99a73b6ee5 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1046,7 +1046,7 @@ void svm_update_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
 	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
-			    (is_guest_mode(vcpu) && guest_can_use(vcpu, X86_FEATURE_LBRV) &&
+			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
 			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
 
 	if (enable_lbrv == current_enable_lbrv)
@@ -2835,7 +2835,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	switch (msr_info->index) {
 	case MSR_AMD64_TSC_RATIO:
 		if (!msr_info->host_initiated &&
-		    !guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR))
 			return 1;
 		msr_info->data = svm->tsc_ratio_msr;
 		break;
@@ -2985,7 +2985,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 	switch (ecx) {
 	case MSR_AMD64_TSC_RATIO:
 
-		if (!guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR)) {
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR)) {
 
 			if (!msr->host_initiated)
 				return 1;
@@ -3007,7 +3007,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 
 		svm->tsc_ratio_msr = data;
 
-		if (guest_can_use(vcpu, X86_FEATURE_TSCRATEMSR) &&
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSCRATEMSR) &&
 		    is_guest_mode(vcpu))
 			nested_svm_update_tsc_ratio_msr(vcpu);
 
@@ -4318,11 +4318,11 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
 	    boot_cpu_has(X86_FEATURE_XSAVES) &&
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
-		kvm_governed_feature_set(vcpu, X86_FEATURE_XSAVES);
+		guest_cpu_cap_set(vcpu, X86_FEATURE_XSAVES);
 
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_NRIPS);
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_LBRV);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_NRIPS);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_TSCRATEMSR);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_LBRV);
 
 	/*
 	 * Intercept VMLOAD if the vCPU mode is Intel in order to emulate that
@@ -4330,12 +4330,12 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * SVM on Intel is bonkers and extremely unlikely to work).
 	 */
 	if (!guest_cpuid_is_intel(vcpu))
-		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
+		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_V_VMSAVE_VMLOAD);
 
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VGIF);
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VNMI);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PAUSEFILTER);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_PFTHRESHOLD);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VGIF);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VNMI);
 
 	svm_recalc_instruction_intercepts(vcpu, svm);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index be67ab7fdd10..e49af42b4a33 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -443,7 +443,7 @@ static inline bool svm_is_intercept(struct vcpu_svm *svm, int bit)
 
 static inline bool nested_vgif_enabled(struct vcpu_svm *svm)
 {
-	return guest_can_use(&svm->vcpu, X86_FEATURE_VGIF) &&
+	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VGIF) &&
 	       (svm->nested.ctl.int_ctl & V_GIF_ENABLE_MASK);
 }
 
@@ -495,7 +495,7 @@ static inline bool nested_npt_enabled(struct vcpu_svm *svm)
 
 static inline bool nested_vnmi_enabled(struct vcpu_svm *svm)
 {
-	return guest_can_use(&svm->vcpu, X86_FEATURE_VNMI) &&
+	return guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_VNMI) &&
 	       (svm->nested.ctl.int_ctl & V_NMI_ENABLE_MASK);
 }
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index c5ec0ef51ff7..4750d1696d58 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -6426,7 +6426,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 	vmx = to_vmx(vcpu);
 	vmcs12 = get_vmcs12(vcpu);
 
-	if (guest_can_use(vcpu, X86_FEATURE_VMX) &&
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX) &&
 	    (vmx->nested.vmxon || vmx->nested.smm.vmxon)) {
 		kvm_state.hdr.vmx.vmxon_pa = vmx->nested.vmxon_ptr;
 		kvm_state.hdr.vmx.vmcs12_pa = vmx->nested.current_vmptr;
@@ -6567,7 +6567,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		if (kvm_state->flags & ~KVM_STATE_NESTED_EVMCS)
 			return -EINVAL;
 	} else {
-		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 			return -EINVAL;
 
 		if (!page_address_valid(vcpu, kvm_state->hdr.vmx.vmxon_pa))
@@ -6601,7 +6601,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 
 	if ((kvm_state->flags & KVM_STATE_NESTED_EVMCS) &&
-	    (!guest_can_use(vcpu, X86_FEATURE_VMX) ||
+	    (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX) ||
 	     !vmx->nested.enlightened_vmcs_enabled))
 			return -EINVAL;
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index be20a60047b1..6328f0d47c64 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -2050,7 +2050,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
 		break;
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
-		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 			return 1;
 		if (vmx_get_vmx_msr(&vmx->nested.msrs, msr_info->index,
 				    &msr_info->data))
@@ -2358,7 +2358,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case KVM_FIRST_EMULATED_VMX_MSR ... KVM_LAST_EMULATED_VMX_MSR:
 		if (!msr_info->host_initiated)
 			return 1; /* they are read-only */
-		if (!guest_can_use(vcpu, X86_FEATURE_VMX))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 			return 1;
 		return vmx_set_vmx_msr(vcpu, msr_index, data);
 	case MSR_IA32_RTIT_CTL:
@@ -4567,7 +4567,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 												\
 	if (cpu_has_vmx_##name()) {								\
 		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
-			__enabled = guest_can_use(__vcpu, X86_FEATURE_##feat_name);		\
+			__enabled = guest_cpu_cap_has(__vcpu, X86_FEATURE_##feat_name);		\
 		else										\
 			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
 		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
@@ -7757,9 +7757,9 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 */
 	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
 	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
-		kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_XSAVES);
+		guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_XSAVES);
 
-	kvm_governed_feature_check_and_set(vcpu, X86_FEATURE_VMX);
+	guest_cpu_cap_check_and_set(vcpu, X86_FEATURE_VMX);
 
 	vmx_setup_uret_msrs(vmx);
 
@@ -7767,7 +7767,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		vmcs_set_secondary_exec_control(vmx,
 						vmx_secondary_exec_control(vmx));
 
-	if (guest_can_use(vcpu, X86_FEATURE_VMX))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 		vmx->msr_ia32_feature_control_valid_bits |=
 			FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX;
@@ -7776,7 +7776,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 			~(FEAT_CTL_VMX_ENABLED_INSIDE_SMX |
 			  FEAT_CTL_VMX_ENABLED_OUTSIDE_SMX);
 
-	if (guest_can_use(vcpu, X86_FEATURE_VMX))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_VMX))
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 2c924075f6f1..04a77b764a36 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -1025,7 +1025,7 @@ void kvm_load_guest_xsave_state(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, vcpu->arch.xcr0);
 
-		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, vcpu->arch.ia32_xss);
 	}
@@ -1056,7 +1056,7 @@ void kvm_load_host_xsave_state(struct kvm_vcpu *vcpu)
 		if (vcpu->arch.xcr0 != host_xcr0)
 			xsetbv(XCR_XFEATURE_ENABLED_MASK, host_xcr0);
 
-		if (guest_can_use(vcpu, X86_FEATURE_XSAVES) &&
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES) &&
 		    vcpu->arch.ia32_xss != host_xss)
 			wrmsrl(MSR_IA32_XSS, host_xss);
 	}
-- 
2.42.0.869.gea05f2083d-goog


