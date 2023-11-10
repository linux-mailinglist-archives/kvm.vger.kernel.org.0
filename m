Return-Path: <kvm+bounces-1515-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 080F27E86C5
	for <lists+kvm@lfdr.de>; Sat, 11 Nov 2023 00:56:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 694B3B20B52
	for <lists+kvm@lfdr.de>; Fri, 10 Nov 2023 23:56:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E02E63FB0B;
	Fri, 10 Nov 2023 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MpR78KHf"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E032A3E49F
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 23:55:57 +0000 (UTC)
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F194446BB
	for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:49 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-d9cb79eb417so3166633276.2
        for <kvm@vger.kernel.org>; Fri, 10 Nov 2023 15:55:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1699660549; x=1700265349; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:from:to:cc:subject:date:message-id:reply-to;
        bh=j17vU8KgGm8WRGzkEgSoBujhtusUeBTSFdUxzK6wwuY=;
        b=MpR78KHfK7yxKUvlTS7vhDzUdVxxrirVaMSpzteT9mo8fdJ8QiK5/8Oip7rtBnPGB6
         ivHCi7t+5AY9cm6bNMUjh9HpgWlS6bJoEoadb8xnhUrP0QfTRmJFRBmCJFQg49B1ijht
         lzhIb3dPPF3+s5sGZt9hNH/n4sBAR5Cav/sIT9y7ltpByDCQdp4rxcW58vobNFiz+evk
         ed+PaZcrXED1xUXBLa9LYK602yGlV94yJnqW13UBx3qpXNL+OlOEREVNN7nFhkiH9MoT
         gVN3ivxYUaj5NrVYldcEN6vOOhBnvAqtitM+3dNgn6pNPRinZ7+KjKMJGzlVvXr1Z5Pb
         m9LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699660549; x=1700265349;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:reply-to:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j17vU8KgGm8WRGzkEgSoBujhtusUeBTSFdUxzK6wwuY=;
        b=pgG5cNn9eT7dIJM/YVy/9smux4z5ce3RvZxP0yNTiLSpiL7j9BkPRKLGwCUyu2sLRP
         8Hvf2wcYGWAkUy3GnlNaHsN9o0s2vwd+EGeGSIq9wGezo1Y4JhHSgzarJZhlybvNY0Zq
         YQTGkHxg+pLgtJpDGvz6vd8TU2LTxRkKTcxAOYux5fUnj8SVRV9VJf1VXGopjXXLyqFx
         XxWTb+znHSwyEYQcEEEEBCFu5T1uVTSYuGg8nQjcBWKfzyOIb1+qEufL5pufefDlpwOu
         5EKlFbigsqzaWXryVlu6EUZXPtYUZ0FlKxMOOuCnc7dmC/bbrFBHmJyBK+AfXDPo4OHM
         ycGA==
X-Gm-Message-State: AOJu0YyqM/UckdBEXV3MdMMC2XBgBgUghwFIxnCcQENwrSADqytme/km
	sgCC4rkIVKb5OwVvGdY9KCOCb+ZJ2Aw=
X-Google-Smtp-Source: AGHT+IFyVUBu5XPhvd3PDcenJn1xtZxfr3L2NmKc81k79CyE5d9X18QR9aHjGrW3eMVBmOf5ipKBHq+EQhE=
X-Received: from zagreus.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5c37])
 (user=seanjc job=sendgmr) by 2002:a25:aad4:0:b0:d9a:6007:223a with SMTP id
 t78-20020a25aad4000000b00d9a6007223amr13342ybi.8.1699660549241; Fri, 10 Nov
 2023 15:55:49 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date: Fri, 10 Nov 2023 15:55:27 -0800
In-Reply-To: <20231110235528.1561679-1-seanjc@google.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20231110235528.1561679-1-seanjc@google.com>
X-Mailer: git-send-email 2.42.0.869.gea05f2083d-goog
Message-ID: <20231110235528.1561679-9-seanjc@google.com>
Subject: [PATCH 8/9] KVM: x86: Replace all guest CPUID feature queries with
 cpu_caps check
From: Sean Christopherson <seanjc@google.com>
To: Sean Christopherson <seanjc@google.com>, Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Maxim Levitsky <mlevitsk@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Switch all queries of guest features from guest CPUID to guest
capabilities, i.e. replace all calls to guest_cpuid_has() with calls to
guest_cpu_cap_has(), and drop guest_cpuid_has() and its helper
guest_cpuid_get_register().

Opportunistically drop the unused guest_cpuid_clear(), as there should be
no circumstance in which KVM needs to _clear_ a guest CPUID feature now
that everything is tracked via cpu_caps.  E.g. KVM may need to _change_
a feature to emulate dynamic CPUID flags, but KVM should never need to
clear a feature in guest CPUID to prevent it from being used by the guest.

Delete the last remnants of the governed features framework, as the lone
holdout was vmx_adjust_secondary_exec_control()'s divergent behavior for
governed vs. ungoverned features.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/cpuid.c             |  4 +-
 arch/x86/kvm/cpuid.h             | 70 ++++----------------------------
 arch/x86/kvm/governed_features.h | 21 ----------
 arch/x86/kvm/lapic.c             |  2 +-
 arch/x86/kvm/mtrr.c              |  2 +-
 arch/x86/kvm/smm.c               | 10 ++---
 arch/x86/kvm/svm/pmu.c           |  8 ++--
 arch/x86/kvm/svm/sev.c           |  4 +-
 arch/x86/kvm/svm/svm.c           | 20 ++++-----
 arch/x86/kvm/vmx/nested.c        | 12 +++---
 arch/x86/kvm/vmx/pmu_intel.c     |  4 +-
 arch/x86/kvm/vmx/sgx.c           | 14 +++----
 arch/x86/kvm/vmx/vmx.c           | 47 ++++++++++-----------
 arch/x86/kvm/vmx/vmx.h           |  2 +-
 arch/x86/kvm/x86.c               | 68 +++++++++++++++----------------
 15 files changed, 104 insertions(+), 184 deletions(-)
 delete mode 100644 arch/x86/kvm/governed_features.h

diff --git a/arch/x86/kvm/cpuid.c b/arch/x86/kvm/cpuid.c
index 37a991439fe6..6407e5c45f20 100644
--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -396,7 +396,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * and can install smaller shadow pages if the host lacks 1GiB support.
 	 */
 	allow_gbpages = tdp_enabled ? boot_cpu_has(X86_FEATURE_GBPAGES) :
-				      guest_cpuid_has(vcpu, X86_FEATURE_GBPAGES);
+				      guest_cpu_cap_has(vcpu, X86_FEATURE_GBPAGES);
 	guest_cpu_cap_change(vcpu, X86_FEATURE_GBPAGES, allow_gbpages);
 
 	best = kvm_find_cpuid_entry(vcpu, 1);
@@ -419,7 +419,7 @@ static void kvm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	kvm_pmu_refresh(vcpu);
 	vcpu->arch.cr4_guest_rsvd_bits =
-	    __cr4_reserved_bits(guest_cpuid_has, vcpu);
+	    __cr4_reserved_bits(guest_cpu_cap_has, vcpu);
 
 	kvm_hv_set_cpuid(vcpu, kvm_cpuid_has_hyperv(vcpu->arch.cpuid_entries,
 						    vcpu->arch.cpuid_nent));
diff --git a/arch/x86/kvm/cpuid.h b/arch/x86/kvm/cpuid.h
index bebf94a69630..98694dfe062e 100644
--- a/arch/x86/kvm/cpuid.h
+++ b/arch/x86/kvm/cpuid.h
@@ -72,41 +72,6 @@ static __always_inline void cpuid_entry_override(struct kvm_cpuid_entry2 *entry,
 	*reg = kvm_cpu_caps[leaf];
 }
 
-static __always_inline u32 *guest_cpuid_get_register(struct kvm_vcpu *vcpu,
-						     unsigned int x86_feature)
-{
-	const struct cpuid_reg cpuid = x86_feature_cpuid(x86_feature);
-	struct kvm_cpuid_entry2 *entry;
-
-	entry = kvm_find_cpuid_entry_index(vcpu, cpuid.function, cpuid.index);
-	if (!entry)
-		return NULL;
-
-	return __cpuid_entry_get_reg(entry, cpuid.reg);
-}
-
-static __always_inline bool guest_cpuid_has(struct kvm_vcpu *vcpu,
-					    unsigned int x86_feature)
-{
-	u32 *reg;
-
-	reg = guest_cpuid_get_register(vcpu, x86_feature);
-	if (!reg)
-		return false;
-
-	return *reg & __feature_bit(x86_feature);
-}
-
-static __always_inline void guest_cpuid_clear(struct kvm_vcpu *vcpu,
-					      unsigned int x86_feature)
-{
-	u32 *reg;
-
-	reg = guest_cpuid_get_register(vcpu, x86_feature);
-	if (reg)
-		*reg &= ~__feature_bit(x86_feature);
-}
-
 static inline bool guest_cpuid_is_amd_or_hygon(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpuid_entry2 *best;
@@ -218,27 +183,6 @@ static __always_inline bool guest_pv_has(struct kvm_vcpu *vcpu,
 	return vcpu->arch.pv_cpuid.features & (1u << kvm_feature);
 }
 
-enum kvm_governed_features {
-#define KVM_GOVERNED_FEATURE(x) KVM_GOVERNED_##x,
-#include "governed_features.h"
-	KVM_NR_GOVERNED_FEATURES
-};
-
-static __always_inline int kvm_governed_feature_index(unsigned int x86_feature)
-{
-	switch (x86_feature) {
-#define KVM_GOVERNED_FEATURE(x) case x: return KVM_GOVERNED_##x;
-#include "governed_features.h"
-	default:
-		return -1;
-	}
-}
-
-static __always_inline bool kvm_is_governed_feature(unsigned int x86_feature)
-{
-	return kvm_governed_feature_index(x86_feature) >= 0;
-}
-
 static __always_inline void guest_cpu_cap_set(struct kvm_vcpu *vcpu,
 					      unsigned int x86_feature)
 {
@@ -285,17 +229,17 @@ static __always_inline bool guest_cpu_cap_has(struct kvm_vcpu *vcpu,
 
 static inline bool guest_has_spec_ctrl_msr(struct kvm_vcpu *vcpu)
 {
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_STIBP) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBRS) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_SSBD));
+	return (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_STIBP) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBRS) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_SSBD));
 }
 
 static inline bool guest_has_pred_cmd_msr(struct kvm_vcpu *vcpu)
 {
-	return (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB) ||
-		guest_cpuid_has(vcpu, X86_FEATURE_SBPB));
+	return (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBPB) ||
+		guest_cpu_cap_has(vcpu, X86_FEATURE_SBPB));
 }
 
 #endif
diff --git a/arch/x86/kvm/governed_features.h b/arch/x86/kvm/governed_features.h
deleted file mode 100644
index 423a73395c10..000000000000
--- a/arch/x86/kvm/governed_features.h
+++ /dev/null
@@ -1,21 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-#if !defined(KVM_GOVERNED_FEATURE) || defined(KVM_GOVERNED_X86_FEATURE)
-BUILD_BUG()
-#endif
-
-#define KVM_GOVERNED_X86_FEATURE(x) KVM_GOVERNED_FEATURE(X86_FEATURE_##x)
-
-KVM_GOVERNED_X86_FEATURE(GBPAGES)
-KVM_GOVERNED_X86_FEATURE(XSAVES)
-KVM_GOVERNED_X86_FEATURE(VMX)
-KVM_GOVERNED_X86_FEATURE(NRIPS)
-KVM_GOVERNED_X86_FEATURE(TSCRATEMSR)
-KVM_GOVERNED_X86_FEATURE(V_VMSAVE_VMLOAD)
-KVM_GOVERNED_X86_FEATURE(LBRV)
-KVM_GOVERNED_X86_FEATURE(PAUSEFILTER)
-KVM_GOVERNED_X86_FEATURE(PFTHRESHOLD)
-KVM_GOVERNED_X86_FEATURE(VGIF)
-KVM_GOVERNED_X86_FEATURE(VNMI)
-
-#undef KVM_GOVERNED_X86_FEATURE
-#undef KVM_GOVERNED_FEATURE
diff --git a/arch/x86/kvm/lapic.c b/arch/x86/kvm/lapic.c
index 245b20973cae..f5fab29c827f 100644
--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -584,7 +584,7 @@ void kvm_apic_set_version(struct kvm_vcpu *vcpu)
 	 * version first and level-triggered interrupts never get EOIed in
 	 * IOAPIC.
 	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) &&
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) &&
 	    !ioapic_in_kernel(vcpu->kvm))
 		v |= APIC_LVR_DIRECTED_EOI;
 	kvm_lapic_set_reg(apic, APIC_LVR, v);
diff --git a/arch/x86/kvm/mtrr.c b/arch/x86/kvm/mtrr.c
index a67c28a56417..9e8cb38ae1db 100644
--- a/arch/x86/kvm/mtrr.c
+++ b/arch/x86/kvm/mtrr.c
@@ -128,7 +128,7 @@ static u8 mtrr_disabled_type(struct kvm_vcpu *vcpu)
 	 * enable MTRRs and it is obviously undesirable to run the
 	 * guest entirely with UC memory and we use WB.
 	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_MTRR))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_MTRR))
 		return MTRR_TYPE_UNCACHABLE;
 	else
 		return MTRR_TYPE_WRBACK;
diff --git a/arch/x86/kvm/smm.c b/arch/x86/kvm/smm.c
index dc3d95fdca7d..3ca4154d9fa0 100644
--- a/arch/x86/kvm/smm.c
+++ b/arch/x86/kvm/smm.c
@@ -290,7 +290,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
 	memset(smram.bytes, 0, sizeof(smram.bytes));
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		enter_smm_save_state_64(vcpu, &smram.smram64);
 	else
 #endif
@@ -360,7 +360,7 @@ void enter_smm(struct kvm_vcpu *vcpu)
 	kvm_set_segment(vcpu, &ds, VCPU_SREG_SS);
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		if (static_call(kvm_x86_set_efer)(vcpu, 0))
 			goto error;
 #endif
@@ -593,7 +593,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 	 * supports long mode.
 	 */
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM)) {
 		struct kvm_segment cs_desc;
 		unsigned long cr4;
 
@@ -616,7 +616,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 		kvm_set_cr0(vcpu, cr0 & ~(X86_CR0_PG | X86_CR0_PE));
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM)) {
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM)) {
 		unsigned long cr4, efer;
 
 		/* Clear CR4.PAE before clearing EFER.LME. */
@@ -639,7 +639,7 @@ int emulator_leave_smm(struct x86_emulate_ctxt *ctxt)
 		return X86EMUL_UNHANDLEABLE;
 
 #ifdef CONFIG_X86_64
-	if (guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return rsm_load_state_64(ctxt, &smram.smram64);
 	else
 #endif
diff --git a/arch/x86/kvm/svm/pmu.c b/arch/x86/kvm/svm/pmu.c
index 373ff6a6687b..16d396a31c16 100644
--- a/arch/x86/kvm/svm/pmu.c
+++ b/arch/x86/kvm/svm/pmu.c
@@ -46,7 +46,7 @@ static inline struct kvm_pmc *get_gp_pmc_amd(struct kvm_pmu *pmu, u32 msr,
 
 	switch (msr) {
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE))
 			return NULL;
 		/*
 		 * Each PMU counter has a pair of CTL and CTR MSRs. CTLn
@@ -113,7 +113,7 @@ static bool amd_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 	case MSR_K7_EVNTSEL0 ... MSR_K7_PERFCTR3:
 		return pmu->version > 0;
 	case MSR_F15H_PERF_CTL0 ... MSR_F15H_PERF_CTR5:
-		return guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE);
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE);
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_CTL:
 	case MSR_AMD64_PERF_CNTR_GLOBAL_STATUS_CLR:
@@ -184,7 +184,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 	union cpuid_0x80000022_ebx ebx;
 
 	pmu->version = 1;
-	if (guest_cpuid_has(vcpu, X86_FEATURE_PERFMON_V2)) {
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PERFMON_V2)) {
 		pmu->version = 2;
 		/*
 		 * Note, PERFMON_V2 is also in 0x80000022.0x0, i.e. the guest
@@ -194,7 +194,7 @@ static void amd_pmu_refresh(struct kvm_vcpu *vcpu)
 			     x86_feature_cpuid(X86_FEATURE_PERFMON_V2).index);
 		ebx.full = kvm_find_cpuid_entry_index(vcpu, 0x80000022, 0)->ebx;
 		pmu->nr_arch_gp_counters = ebx.split.num_core_pmc;
-	} else if (guest_cpuid_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
+	} else if (guest_cpu_cap_has(vcpu, X86_FEATURE_PERFCTR_CORE)) {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS_CORE;
 	} else {
 		pmu->nr_arch_gp_counters = AMD64_NUM_COUNTERS;
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index 4900c078045a..05008d33ae63 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -2967,8 +2967,8 @@ static void sev_es_vcpu_after_set_cpuid(struct vcpu_svm *svm)
 	struct kvm_vcpu *vcpu = &svm->vcpu;
 
 	if (boot_cpu_has(X86_FEATURE_V_TSC_AUX)) {
-		bool v_tsc_aux = guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
-				 guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+		bool v_tsc_aux = guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) ||
+				 guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID);
 
 		set_msr_interception(vcpu, svm->msrpm, MSR_TSC_AUX, v_tsc_aux, v_tsc_aux);
 	}
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 5827328e30f1..9e3a9191dac1 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -1185,14 +1185,14 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu,
 	 */
 	if (kvm_cpu_cap_has(X86_FEATURE_INVPCID)) {
 		if (!npt_enabled ||
-		    !guest_cpuid_has(&svm->vcpu, X86_FEATURE_INVPCID))
+		    !guest_cpu_cap_has(&svm->vcpu, X86_FEATURE_INVPCID))
 			svm_set_intercept(svm, INTERCEPT_INVPCID);
 		else
 			svm_clr_intercept(svm, INTERCEPT_INVPCID);
 	}
 
 	if (kvm_cpu_cap_has(X86_FEATURE_RDTSCP)) {
-		if (guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP))
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP))
 			svm_clr_intercept(svm, INTERCEPT_RDTSCP);
 		else
 			svm_set_intercept(svm, INTERCEPT_RDTSCP);
@@ -2905,7 +2905,7 @@ static int svm_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_VIRT_SSBD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_VIRT_SSBD))
 			return 1;
 
 		msr_info->data = svm->virt_spec_ctrl;
@@ -3052,7 +3052,7 @@ static int svm_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
 		break;
 	case MSR_AMD64_VIRT_SPEC_CTRL:
 		if (!msr->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_VIRT_SSBD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_VIRT_SSBD))
 			return 1;
 
 		if (data & ~SPEC_CTRL_SSBD)
@@ -3224,7 +3224,7 @@ static int invpcid_interception(struct kvm_vcpu *vcpu)
 	unsigned long type;
 	gva_t gva;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -4318,7 +4318,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	guest_cpu_cap_change(vcpu, X86_FEATURE_XSAVES,
 			     boot_cpu_has(X86_FEATURE_XSAVE) &&
 			     boot_cpu_has(X86_FEATURE_XSAVES) &&
-			     guest_cpuid_has(vcpu, X86_FEATURE_XSAVE));
+			     guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE));
 
 	guest_cpu_cap_restrict(vcpu, X86_FEATURE_NRIPS);
 	guest_cpu_cap_restrict(vcpu, X86_FEATURE_TSCRATEMSR);
@@ -4345,7 +4345,7 @@ static void svm_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
 		set_msr_interception(vcpu, svm->msrpm, MSR_IA32_FLUSH_CMD, 0,
-				     !!guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+				     !!guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
 	if (sev_guest(vcpu->kvm))
 		sev_vcpu_after_set_cpuid(svm);
@@ -4602,7 +4602,7 @@ static int svm_enter_smm(struct kvm_vcpu *vcpu, union kvm_smram *smram)
 	 * responsible for ensuring nested SVM and SMIs are mutually exclusive.
 	 */
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return 1;
 
 	smram->smram64.svm_guest_flag = 1;
@@ -4649,14 +4649,14 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 
 	const struct kvm_smram_state_64 *smram64 = &smram->smram64;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return 0;
 
 	/* Non-zero if SMI arrived while vCPU was in guest mode. */
 	if (!smram64->svm_guest_flag)
 		return 0;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SVM))
 		return 1;
 
 	if (!(smram64->efer & EFER_SVME))
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 4750d1696d58..f046813e34c1 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2005,7 +2005,7 @@ static enum nested_evmptrld_status nested_vmx_handle_enlightened_vmptrld(
 	bool evmcs_gpa_changed = false;
 	u64 evmcs_gpa;
 
-	if (likely(!guest_cpuid_has_evmcs(vcpu)))
+	if (likely(!guest_cpu_cap_has_evmcs(vcpu)))
 		return EVMPTRLD_DISABLED;
 
 	evmcs_gpa = nested_get_evmptr(vcpu);
@@ -2888,7 +2888,7 @@ static int nested_vmx_check_controls(struct kvm_vcpu *vcpu,
 	    nested_check_vm_entry_controls(vcpu, vmcs12))
 		return -EINVAL;
 
-	if (guest_cpuid_has_evmcs(vcpu))
+	if (guest_cpu_cap_has_evmcs(vcpu))
 		return nested_evmcs_check_controls(vmcs12);
 
 	return 0;
@@ -3170,7 +3170,7 @@ static bool nested_get_evmcs_page(struct kvm_vcpu *vcpu)
 	 * L2 was running), map it here to make sure vmcs12 changes are
 	 * properly reflected.
 	 */
-	if (guest_cpuid_has_evmcs(vcpu) &&
+	if (guest_cpu_cap_has_evmcs(vcpu) &&
 	    vmx->nested.hv_evmcs_vmptr == EVMPTR_MAP_PENDING) {
 		enum nested_evmptrld_status evmptrld_status =
 			nested_vmx_handle_enlightened_vmptrld(vcpu, false);
@@ -4814,7 +4814,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	 * doesn't isolate different VMCSs, i.e. in this case, doesn't provide
 	 * separate modes for L2 vs L1.
 	 */
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL))
 		indirect_branch_prediction_barrier();
 
 	/* Update any VMCS fields that might have changed while L2 ran */
@@ -5302,7 +5302,7 @@ static int handle_vmclear(struct kvm_vcpu *vcpu)
 	 * state. It is possible that the area will stay mapped as
 	 * vmx->nested.hv_evmcs but this shouldn't be a problem.
 	 */
-	if (likely(!guest_cpuid_has_evmcs(vcpu) ||
+	if (likely(!guest_cpu_cap_has_evmcs(vcpu) ||
 		   !evmptr_is_valid(nested_get_evmptr(vcpu)))) {
 		if (vmptr == vmx->nested.current_vmptr)
 			nested_release_vmcs12(vcpu);
@@ -6092,7 +6092,7 @@ static bool nested_vmx_exit_handled_encls(struct kvm_vcpu *vcpu,
 {
 	u32 encls_leaf;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SGX) ||
 	    !nested_cpu_has2(vmcs12, SECONDARY_EXEC_ENCLS_EXITING))
 		return false;
 
diff --git a/arch/x86/kvm/vmx/pmu_intel.c b/arch/x86/kvm/vmx/pmu_intel.c
index 820d3e1f6b4f..98d579c0ce28 100644
--- a/arch/x86/kvm/vmx/pmu_intel.c
+++ b/arch/x86/kvm/vmx/pmu_intel.c
@@ -160,7 +160,7 @@ static struct kvm_pmc *intel_rdpmc_ecx_to_pmc(struct kvm_vcpu *vcpu,
 
 static inline u64 vcpu_get_perf_capabilities(struct kvm_vcpu *vcpu)
 {
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
 		return 0;
 
 	return vcpu->arch.perf_capabilities;
@@ -210,7 +210,7 @@ static bool intel_is_valid_msr(struct kvm_vcpu *vcpu, u32 msr)
 		ret = vcpu_get_perf_capabilities(vcpu) & PERF_CAP_PEBS_FORMAT;
 		break;
 	case MSR_IA32_DS_AREA:
-		ret = guest_cpuid_has(vcpu, X86_FEATURE_DS);
+		ret = guest_cpu_cap_has(vcpu, X86_FEATURE_DS);
 		break;
 	case MSR_PEBS_DATA_CFG:
 		perf_capabilities = vcpu_get_perf_capabilities(vcpu);
diff --git a/arch/x86/kvm/vmx/sgx.c b/arch/x86/kvm/vmx/sgx.c
index 3e822e582497..9616b4ac0662 100644
--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -122,7 +122,7 @@ static int sgx_inject_fault(struct kvm_vcpu *vcpu, gva_t gva, int trapnr)
 	 * likely than a bad userspace address.
 	 */
 	if ((trapnr == PF_VECTOR || !boot_cpu_has(X86_FEATURE_SGX2)) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_SGX2)) {
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2)) {
 		memset(&ex, 0, sizeof(ex));
 		ex.vector = PF_VECTOR;
 		ex.error_code = PFERR_PRESENT_MASK | PFERR_WRITE_MASK |
@@ -365,7 +365,7 @@ static inline bool encls_leaf_enabled_in_guest(struct kvm_vcpu *vcpu, u32 leaf)
 		return true;
 
 	if (leaf >= EAUG && leaf <= EMODT)
-		return guest_cpuid_has(vcpu, X86_FEATURE_SGX2);
+		return guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2);
 
 	return false;
 }
@@ -381,8 +381,8 @@ int handle_encls(struct kvm_vcpu *vcpu)
 {
 	u32 leaf = (u32)kvm_rax_read(vcpu);
 
-	if (!enable_sgx || !guest_cpuid_has(vcpu, X86_FEATURE_SGX) ||
-	    !guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
+	if (!enable_sgx || !guest_cpu_cap_has(vcpu, X86_FEATURE_SGX) ||
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_SGX1)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 	} else if (!encls_leaf_enabled_in_guest(vcpu, leaf) ||
 		   !sgx_enabled_in_guest_bios(vcpu) || !is_paging(vcpu)) {
@@ -479,15 +479,15 @@ void vmx_write_encls_bitmap(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 	if (!cpu_has_vmx_encls_vmexit())
 		return;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX) &&
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX) &&
 	    sgx_enabled_in_guest_bios(vcpu)) {
-		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX1)) {
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX1)) {
 			bitmap &= ~GENMASK_ULL(ETRACK, ECREATE);
 			if (sgx_intercept_encls_ecreate(vcpu))
 				bitmap |= (1 << ECREATE);
 		}
 
-		if (guest_cpuid_has(vcpu, X86_FEATURE_SGX2))
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX2))
 			bitmap &= ~GENMASK_ULL(EMODT, EAUG);
 
 		/*
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 5a056ad1ae55..815692dc0aff 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1874,8 +1874,8 @@ static void vmx_setup_uret_msrs(struct vcpu_vmx *vmx)
 	vmx_setup_uret_msr(vmx, MSR_EFER, update_transition_efer(vmx));
 
 	vmx_setup_uret_msr(vmx, MSR_TSC_AUX,
-			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
-			   guest_cpuid_has(&vmx->vcpu, X86_FEATURE_RDPID));
+			   guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_RDTSCP) ||
+			   guest_cpu_cap_has(&vmx->vcpu, X86_FEATURE_RDPID));
 
 	/*
 	 * hle=0, rtm=0, tsx_ctrl=1 can be found with some combinations of new
@@ -2028,7 +2028,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
+		     !guest_cpu_cap_has(vcpu, X86_FEATURE_MPX)))
 			return 1;
 		msr_info->data = vmcs_read64(GUEST_BNDCFGS);
 		break;
@@ -2044,7 +2044,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_SGXLEPUBKEYHASH0 ... MSR_IA32_SGXLEPUBKEYHASH3:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC))
 			return 1;
 		msr_info->data = to_vmx(vcpu)->msr_ia32_sgxlepubkeyhash
 			[msr_info->index - MSR_IA32_SGXLEPUBKEYHASH0];
@@ -2062,7 +2062,7 @@ static int vmx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * sanity checking and refuse to boot. Filter all unsupported
 		 * features out.
 		 */
-		if (!msr_info->host_initiated && guest_cpuid_has_evmcs(vcpu))
+		if (!msr_info->host_initiated && guest_cpu_cap_has_evmcs(vcpu))
 			nested_evmcs_filter_control_msr(vcpu, msr_info->index,
 							&msr_info->data);
 		break;
@@ -2131,7 +2131,7 @@ static u64 nested_vmx_truncate_sysenter_addr(struct kvm_vcpu *vcpu,
 						    u64 data)
 {
 #ifdef CONFIG_X86_64
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return (u32)data;
 #endif
 	return (unsigned long)data;
@@ -2142,7 +2142,7 @@ static u64 vmx_get_supported_debugctl(struct kvm_vcpu *vcpu, bool host_initiated
 	u64 debugctl = 0;
 
 	if (boot_cpu_has(X86_FEATURE_BUS_LOCK_DETECT) &&
-	    (host_initiated || guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
+	    (host_initiated || guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT)))
 		debugctl |= DEBUGCTLMSR_BUS_LOCK_DETECT;
 
 	if ((kvm_caps.supported_perf_cap & PMU_CAP_LBR_FMT) &&
@@ -2246,7 +2246,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	case MSR_IA32_BNDCFGS:
 		if (!kvm_mpx_supported() ||
 		    (!msr_info->host_initiated &&
-		     !guest_cpuid_has(vcpu, X86_FEATURE_MPX)))
+		     !guest_cpu_cap_has(vcpu, X86_FEATURE_MPX)))
 			return 1;
 		if (is_noncanonical_address(data & PAGE_MASK, vcpu) ||
 		    (data & MSR_IA32_BNDCFGS_RSVD))
@@ -2348,7 +2348,7 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		 * behavior, but it's close enough.
 		 */
 		if (!msr_info->host_initiated &&
-		    (!guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC) ||
+		    (!guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC) ||
 		    ((vmx->msr_ia32_feature_control & FEAT_CTL_LOCKED) &&
 		    !(vmx->msr_ia32_feature_control & FEAT_CTL_SGX_LC_ENABLED))))
 			return 1;
@@ -2434,9 +2434,9 @@ static int vmx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((data & PERF_CAP_PEBS_MASK) !=
 			    (kvm_caps.supported_perf_cap & PERF_CAP_PEBS_MASK))
 				return 1;
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_DS))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_DS))
 				return 1;
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_DTES64))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_DTES64))
 				return 1;
 			if (!cpuid_model_is_consistent(vcpu))
 				return 1;
@@ -4566,10 +4566,7 @@ vmx_adjust_secondary_exec_control(struct vcpu_vmx *vmx, u32 *exec_control,
 	bool __enabled;										\
 												\
 	if (cpu_has_vmx_##name()) {								\
-		if (kvm_is_governed_feature(X86_FEATURE_##feat_name))				\
-			__enabled = guest_cpu_cap_has(__vcpu, X86_FEATURE_##feat_name);		\
-		else										\
-			__enabled = guest_cpuid_has(__vcpu, X86_FEATURE_##feat_name);		\
+		__enabled = guest_cpu_cap_has(__vcpu, X86_FEATURE_##feat_name);			\
 		vmx_adjust_secondary_exec_control(vmx, exec_control, SECONDARY_EXEC_##ctrl_name,\
 						  __enabled, exiting);				\
 	}											\
@@ -4644,8 +4641,8 @@ static u32 vmx_secondary_exec_control(struct vcpu_vmx *vmx)
 	 */
 	if (cpu_has_vmx_rdtscp()) {
 		bool rdpid_or_rdtscp_enabled =
-			guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) ||
-			guest_cpuid_has(vcpu, X86_FEATURE_RDPID);
+			guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) ||
+			guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID);
 
 		vmx_adjust_secondary_exec_control(vmx, &exec_control,
 						  SECONDARY_EXEC_ENABLE_RDTSCP,
@@ -5947,7 +5944,7 @@ static int handle_invpcid(struct kvm_vcpu *vcpu)
 	} operand;
 	int gpr_index;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_INVPCID)) {
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_INVPCID)) {
 		kvm_queue_exception(vcpu, UD_VECTOR);
 		return 1;
 	}
@@ -7756,7 +7753,7 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 	 * set if and only if XSAVE is supported.
 	 */
 	if (boot_cpu_has(X86_FEATURE_XSAVE) &&
-	    guest_cpuid_has(vcpu, X86_FEATURE_XSAVE))
+	    guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVE))
 		guest_cpu_cap_restrict(vcpu, X86_FEATURE_XSAVES);
 	else
 		guest_cpu_cap_clear(vcpu, X86_FEATURE_XSAVES);
@@ -7782,21 +7779,21 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 		nested_vmx_cr_fixed1_bits_update(vcpu);
 
 	if (boot_cpu_has(X86_FEATURE_INTEL_PT) &&
-			guest_cpuid_has(vcpu, X86_FEATURE_INTEL_PT))
+			guest_cpu_cap_has(vcpu, X86_FEATURE_INTEL_PT))
 		update_intel_pt_cfg(vcpu);
 
 	if (boot_cpu_has(X86_FEATURE_RTM)) {
 		struct vmx_uret_msr *msr;
 		msr = vmx_find_uret_msr(vmx, MSR_IA32_TSX_CTRL);
 		if (msr) {
-			bool enabled = guest_cpuid_has(vcpu, X86_FEATURE_RTM);
+			bool enabled = guest_cpu_cap_has(vcpu, X86_FEATURE_RTM);
 			vmx_set_guest_uret_msr(vmx, msr, enabled ? 0 : TSX_CTRL_RTM_DISABLE);
 		}
 	}
 
 	if (kvm_cpu_cap_has(X86_FEATURE_XFD))
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_XFD_ERR, MSR_TYPE_R,
-					  !guest_cpuid_has(vcpu, X86_FEATURE_XFD));
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD));
 
 	if (boot_cpu_has(X86_FEATURE_IBPB))
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_PRED_CMD, MSR_TYPE_W,
@@ -7804,17 +7801,17 @@ static void vmx_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
 
 	if (boot_cpu_has(X86_FEATURE_FLUSH_L1D))
 		vmx_set_intercept_for_msr(vcpu, MSR_IA32_FLUSH_CMD, MSR_TYPE_W,
-					  !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D));
+					  !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D));
 
 	set_cr4_guest_host_mask(vmx);
 
 	vmx_write_encls_bitmap(vcpu, NULL);
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX))
 		vmx->msr_ia32_feature_control_valid_bits |= FEAT_CTL_SGX_ENABLED;
 	else
 		vmx->msr_ia32_feature_control_valid_bits &= ~FEAT_CTL_SGX_ENABLED;
 
-	if (guest_cpuid_has(vcpu, X86_FEATURE_SGX_LC))
+	if (guest_cpu_cap_has(vcpu, X86_FEATURE_SGX_LC))
 		vmx->msr_ia32_feature_control_valid_bits |=
 			FEAT_CTL_SGX_LC_ENABLED;
 	else
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index c2130d2c8e24..edca0a4276fb 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -745,7 +745,7 @@ static inline bool vmx_can_use_ipiv(struct kvm_vcpu *vcpu)
 	return  lapic_in_kernel(vcpu) && enable_ipiv;
 }
 
-static inline bool guest_cpuid_has_evmcs(struct kvm_vcpu *vcpu)
+static inline bool guest_cpu_cap_has_evmcs(struct kvm_vcpu *vcpu)
 {
 	/*
 	 * eVMCS is exposed to the guest if Hyper-V is enabled in CPUID and
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 04a77b764a36..a6b8f844a5bc 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -487,7 +487,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	enum lapic_mode old_mode = kvm_get_apic_mode(vcpu);
 	enum lapic_mode new_mode = kvm_apic_mode(msr_info->data);
 	u64 reserved_bits = kvm_vcpu_reserved_gpa_bits_raw(vcpu) | 0x2ff |
-		(guest_cpuid_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
+		(guest_cpu_cap_has(vcpu, X86_FEATURE_X2APIC) ? 0 : X2APIC_ENABLE);
 
 	if ((msr_info->data & reserved_bits) != 0 || new_mode == LAPIC_MODE_INVALID)
 		return 1;
@@ -1362,10 +1362,10 @@ static u64 kvm_dr6_fixed(struct kvm_vcpu *vcpu)
 {
 	u64 fixed = DR6_FIXED_1;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_RTM))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_RTM))
 		fixed |= DR6_RTM;
 
-	if (!guest_cpuid_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
+	if (!guest_cpu_cap_has(vcpu, X86_FEATURE_BUS_LOCK_DETECT))
 		fixed |= DR6_BUS_LOCK;
 	return fixed;
 }
@@ -1721,20 +1721,20 @@ static int do_get_msr_feature(struct kvm_vcpu *vcpu, unsigned index, u64 *data)
 
 static bool __kvm_valid_efer(struct kvm_vcpu *vcpu, u64 efer)
 {
-	if (efer & EFER_AUTOIBRS && !guest_cpuid_has(vcpu, X86_FEATURE_AUTOIBRS))
+	if (efer & EFER_AUTOIBRS && !guest_cpu_cap_has(vcpu, X86_FEATURE_AUTOIBRS))
 		return false;
 
-	if (efer & EFER_FFXSR && !guest_cpuid_has(vcpu, X86_FEATURE_FXSR_OPT))
+	if (efer & EFER_FFXSR && !guest_cpu_cap_has(vcpu, X86_FEATURE_FXSR_OPT))
 		return false;
 
-	if (efer & EFER_SVME && !guest_cpuid_has(vcpu, X86_FEATURE_SVM))
+	if (efer & EFER_SVME && !guest_cpu_cap_has(vcpu, X86_FEATURE_SVM))
 		return false;
 
 	if (efer & (EFER_LME | EFER_LMA) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_LM))
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_LM))
 		return false;
 
-	if (efer & EFER_NX && !guest_cpuid_has(vcpu, X86_FEATURE_NX))
+	if (efer & EFER_NX && !guest_cpu_cap_has(vcpu, X86_FEATURE_NX))
 		return false;
 
 	return true;
@@ -1872,8 +1872,8 @@ static int __kvm_set_msr(struct kvm_vcpu *vcpu, u32 index, u64 data,
 			return 1;
 
 		if (!host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 
 		/*
@@ -1929,8 +1929,8 @@ int __kvm_get_msr(struct kvm_vcpu *vcpu, u32 index, u64 *data,
 			return 1;
 
 		if (!host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDTSCP) &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_RDPID))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDTSCP) &&
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_RDPID))
 			return 1;
 		break;
 	}
@@ -2122,7 +2122,7 @@ EXPORT_SYMBOL_GPL(kvm_handle_invalid_op);
 static int kvm_emulate_monitor_mwait(struct kvm_vcpu *vcpu, const char *insn)
 {
 	if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS) &&
-	    !guest_cpuid_has(vcpu, X86_FEATURE_MWAIT))
+	    !guest_cpu_cap_has(vcpu, X86_FEATURE_MWAIT))
 		return kvm_handle_invalid_op(vcpu);
 
 	pr_warn_once("%s instruction emulated as NOP!\n", insn);
@@ -3761,11 +3761,11 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 			if ((!guest_has_pred_cmd_msr(vcpu)))
 				return 1;
 
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
-			    !guest_cpuid_has(vcpu, X86_FEATURE_AMD_IBPB))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SPEC_CTRL) &&
+			    !guest_cpu_cap_has(vcpu, X86_FEATURE_AMD_IBPB))
 				reserved_bits |= PRED_CMD_IBPB;
 
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_SBPB))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_SBPB))
 				reserved_bits |= PRED_CMD_SBPB;
 		}
 
@@ -3786,7 +3786,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	}
 	case MSR_IA32_FLUSH_CMD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_FLUSH_L1D))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_FLUSH_L1D))
 			return 1;
 
 		if (!boot_cpu_has(X86_FEATURE_FLUSH_L1D) || (data & ~L1D_FLUSH))
@@ -3837,7 +3837,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_set_lapic_tscdeadline_msr(vcpu, data);
 		break;
 	case MSR_IA32_TSC_ADJUST:
-		if (guest_cpuid_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
+		if (guest_cpu_cap_has(vcpu, X86_FEATURE_TSC_ADJUST)) {
 			if (!msr_info->host_initiated) {
 				s64 adj = data - vcpu->arch.ia32_tsc_adjust_msr;
 				adjust_tsc_offset_guest(vcpu, adj);
@@ -3864,7 +3864,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 
 		if (!kvm_check_has_quirk(vcpu->kvm, KVM_X86_QUIRK_MISC_ENABLE_NO_MWAIT) &&
 		    ((old_val ^ data)  & MSR_IA32_MISC_ENABLE_MWAIT)) {
-			if (!guest_cpuid_has(vcpu, X86_FEATURE_XMM3))
+			if (!guest_cpu_cap_has(vcpu, X86_FEATURE_XMM3))
 				return 1;
 			vcpu->arch.ia32_misc_enable_msr = data;
 			kvm_update_cpuid_runtime(vcpu);
@@ -3892,7 +3892,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_XSS:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		/*
 		 * KVM supports exposing PT to the guest, but does not support
@@ -4039,12 +4039,12 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		kvm_pr_unimpl_wrmsr(vcpu, msr, data);
 		break;
 	case MSR_AMD64_OSVW_ID_LENGTH:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		vcpu->arch.osvw.length = data;
 		break;
 	case MSR_AMD64_OSVW_STATUS:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		vcpu->arch.osvw.status = data;
 		break;
@@ -4065,7 +4065,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #ifdef CONFIG_X86_64
 	case MSR_IA32_XFD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		if (data & ~kvm_guest_supported_xfd(vcpu))
@@ -4075,7 +4075,7 @@ int kvm_set_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		if (data & ~kvm_guest_supported_xfd(vcpu))
@@ -4199,13 +4199,13 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		break;
 	case MSR_IA32_ARCH_CAPABILITIES:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_ARCH_CAPABILITIES))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_ARCH_CAPABILITIES))
 			return 1;
 		msr_info->data = vcpu->arch.arch_capabilities;
 		break;
 	case MSR_IA32_PERF_CAPABILITIES:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_PDCM))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_PDCM))
 			return 1;
 		msr_info->data = vcpu->arch.perf_capabilities;
 		break;
@@ -4361,7 +4361,7 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 				   msr_info->host_initiated);
 	case MSR_IA32_XSS:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XSAVES))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XSAVES))
 			return 1;
 		msr_info->data = vcpu->arch.ia32_xss;
 		break;
@@ -4404,12 +4404,12 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 		msr_info->data = 0xbe702111;
 		break;
 	case MSR_AMD64_OSVW_ID_LENGTH:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		msr_info->data = vcpu->arch.osvw.length;
 		break;
 	case MSR_AMD64_OSVW_STATUS:
-		if (!guest_cpuid_has(vcpu, X86_FEATURE_OSVW))
+		if (!guest_cpu_cap_has(vcpu, X86_FEATURE_OSVW))
 			return 1;
 		msr_info->data = vcpu->arch.osvw.status;
 		break;
@@ -4428,14 +4428,14 @@ int kvm_get_msr_common(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 #ifdef CONFIG_X86_64
 	case MSR_IA32_XFD:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		msr_info->data = vcpu->arch.guest_fpu.fpstate->xfd;
 		break;
 	case MSR_IA32_XFD_ERR:
 		if (!msr_info->host_initiated &&
-		    !guest_cpuid_has(vcpu, X86_FEATURE_XFD))
+		    !guest_cpu_cap_has(vcpu, X86_FEATURE_XFD))
 			return 1;
 
 		msr_info->data = vcpu->arch.guest_fpu.xfd_err;
@@ -8368,17 +8368,17 @@ static bool emulator_get_cpuid(struct x86_emulate_ctxt *ctxt,
 
 static bool emulator_guest_has_movbe(struct x86_emulate_ctxt *ctxt)
 {
-	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_MOVBE);
+	return guest_cpu_cap_has(emul_to_vcpu(ctxt), X86_FEATURE_MOVBE);
 }
 
 static bool emulator_guest_has_fxsr(struct x86_emulate_ctxt *ctxt)
 {
-	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
+	return guest_cpu_cap_has(emul_to_vcpu(ctxt), X86_FEATURE_FXSR);
 }
 
 static bool emulator_guest_has_rdpid(struct x86_emulate_ctxt *ctxt)
 {
-	return guest_cpuid_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
+	return guest_cpu_cap_has(emul_to_vcpu(ctxt), X86_FEATURE_RDPID);
 }
 
 static ulong emulator_read_gpr(struct x86_emulate_ctxt *ctxt, unsigned reg)
-- 
2.42.0.869.gea05f2083d-goog


