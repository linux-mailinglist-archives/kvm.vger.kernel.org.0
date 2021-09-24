Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB713417587
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345371AbhIXNZ1 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344780AbhIXNYz (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:55 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC8CC08EAFE
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:28 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id l9-20020adfc789000000b00160111fd4e8so7980656wrg.17
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rk3i6cMxfEloSO2uDCLcRGjjlI1NB6fkfB9BEPfgUdo=;
        b=G8Y/sw0GQZ9Ra9Rgq2GzZpX2BdysDUEE0gmSOnfZAHAaQlZl7Tm7mOztV63Slfq2ZG
         x67Hw5t941WzbpjFLbI3pJgRX7+hd0i8LfMFNdodT321JuulQVmnQyTfGFryVwllHmFG
         1vXBiGtE8lTNYUQRKRh3ucYwytau/zU07sTgng/OEmVb/yKk6fK32yXmVVNdAMX3nIVY
         bxDohiBC3hqUkkOoDQ/FlGSkyUPRE37m0TcmDzC1hOCUYHJPS0Hu/iWubM5XjF2G8SLX
         0c2eNWMayqjeA2N2yrVkrQADnSUfxxLQaXfW3YkPV+65CLA4XF4jfo9AYqbpw1B5NBX9
         ex/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rk3i6cMxfEloSO2uDCLcRGjjlI1NB6fkfB9BEPfgUdo=;
        b=6tNBNFtktOJ5NzmF6laaeDPfXURLV0oogJ/uqAyQOBgE9OuNKy095IlXZQHAYyyV4s
         eTUA5lYPJgTLTaoKuWDbasoU2EkkpnncURFbvEpJbrSLW0wz9OABV4ed6ngAFGPfX1Bz
         q4wrLJVqgzDY1cicYwxEgSTN6+8HeukfPO4rW980iYhRdfpJgY6QKzbREoFzbcQb9tQw
         PUcHhvKKqAr5/60xTvQXHGWRBCy2u4jKdaeauTT8erXptQuXB2/JW20rua9j6dMHzkwG
         VhNXONewgHEPEBM7NAOs3ilK/TPG9XxwLcyrnzRj+h2/kp+qgr8R/OSRTg2/gVlMfad2
         8pDA==
X-Gm-Message-State: AOAM530LnctpnxFOgdNKH5ONcqwS9PKX7dt3f9mHWulxQoMd+BgC55js
        uwwzX0nDdZw2iWEHa0+rW7MtkCZ9sw==
X-Google-Smtp-Source: ABdhPJwEEm2A93CZhB3pUAiv6FWHfC7StwWuqqHbyJROswwWrTmU0101uCP6/VUst3ROn1eX+iAVc70wlQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a5d:58d0:: with SMTP id o16mr11711045wrf.392.1632488067286;
 Fri, 24 Sep 2021 05:54:27 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:41 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-13-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 12/30] KVM: arm64: COCCI: add_hypstate.cocci
 use_hypstate.cocci: Reduce scope of functions to hyp_state
From:   Fuad Tabba <tabba@google.com>
To:     kvmarm@lists.cs.columbia.edu
Cc:     maz@kernel.org, will@kernel.org, james.morse@arm.com,
        alexandru.elisei@arm.com, suzuki.poulose@arm.com,
        mark.rutland@arm.com, christoffer.dall@arm.com, drjones@redhat.com,
        qperret@google.com, kvm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, kernel-team@android.com,
        tabba@google.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Many functions don't need access to the vcpu structure, but only
the hyp_state. Reduce their scope.

This applies the semantic patches with the following commands:
FILES="$(find arch/arm64/kvm/hyp -name "*.[ch]" ! -name "debug-sr*") arch/arm64/include/asm/kvm_hyp.h"
spatch --sp-file cocci_refactor/add_hypstate.cocci $FILES --in-place
spatch --sp-file cocci_refactor/use_hypstate.cocci $FILES --in-place

This patch adds variables that may be unused. These will be
removed at the end of this patch series.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h           |  2 +-
 arch/arm64/kvm/hyp/aarch32.c               |  2 +
 arch/arm64/kvm/hyp/exception.c             | 19 +++++---
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h |  2 +
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 54 +++++++++++++---------
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  6 ++-
 arch/arm64/kvm/hyp/nvhe/switch.c           | 21 +++++----
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   |  1 +
 arch/arm64/kvm/hyp/vgic-v3-sr.c            | 29 ++++++++++++
 arch/arm64/kvm/hyp/vhe/switch.c            | 25 +++++-----
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |  4 +-
 11 files changed, 112 insertions(+), 53 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 2e2b60a1b6c7..2737e05a16b2 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -94,7 +94,7 @@ void __sve_save_state(void *sve_pffr, u32 *fpsr);
 void __sve_restore_state(void *sve_pffr, u32 *fpsr);
 
 #ifndef __KVM_NVHE_HYPERVISOR__
-void activate_traps_vhe_load(struct kvm_vcpu *vcpu);
+void activate_traps_vhe_load(struct vcpu_hyp_state *vcpu_hyps);
 void deactivate_traps_vhe_put(void);
 #endif
 
diff --git a/arch/arm64/kvm/hyp/aarch32.c b/arch/arm64/kvm/hyp/aarch32.c
index 27ebfff023ff..2d45e13d1b12 100644
--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -46,6 +46,7 @@ static const unsigned short cc_map[16] = {
  */
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 {
+	const struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	const struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	unsigned long cpsr;
 	u32 cpsr_cond;
@@ -126,6 +127,7 @@ static void kvm_adjust_itstate(struct kvm_cpu_context *vcpu_ctxt)
  */
 void kvm_skip_instr32(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 pc = *ctxt_pc(vcpu_ctxt);
 	bool is_thumb;
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 4514e345c26f..d4c2905b595d 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -59,26 +59,31 @@ static void __ctxt_write_spsr_und(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 
 static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
+	const struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	return __ctxt_read_sys_reg(&vcpu_ctxt(vcpu), reg);
 }
 
 static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_sys_reg(&vcpu_ctxt(vcpu), val, reg);
 }
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
 }
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
 }
 
 static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
 }
 
@@ -326,9 +331,10 @@ static void enter_exception32(struct kvm_cpu_context *vcpu_ctxt, u32 mode,
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (vcpu_el1_is_32bit(vcpu)) {
-		switch (vcpu_flags(vcpu) & KVM_ARM64_EXCEPT_MASK) {
+		switch (hyp_state_flags(vcpu_hyps) & KVM_ARM64_EXCEPT_MASK) {
 		case KVM_ARM64_EXCEPT_AA32_UND:
 			enter_exception32(vcpu_ctxt, PSR_AA32_MODE_UND, 4);
 			break;
@@ -343,7 +349,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 			break;
 		}
 	} else {
-		switch (vcpu_flags(vcpu) & KVM_ARM64_EXCEPT_MASK) {
+		switch (hyp_state_flags(vcpu_hyps) & KVM_ARM64_EXCEPT_MASK) {
 		case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
 		      KVM_ARM64_EXCEPT_AA64_EL1):
 			enter_exception64(vcpu_ctxt, PSR_MODE_EL1h,
@@ -366,13 +372,14 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  */
 void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	if (vcpu_flags(vcpu) & KVM_ARM64_PENDING_EXCEPTION) {
+	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_PENDING_EXCEPTION) {
 		kvm_inject_exception(vcpu);
-		vcpu_flags(vcpu) &= ~(KVM_ARM64_PENDING_EXCEPTION |
+		hyp_state_flags(vcpu_hyps) &= ~(KVM_ARM64_PENDING_EXCEPTION |
 				      KVM_ARM64_EXCEPT_MASK);
-	} else 	if (vcpu_flags(vcpu) & KVM_ARM64_INCREMENT_PC) {
+	} else 	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_INCREMENT_PC) {
 		kvm_skip_instr(vcpu);
-		vcpu_flags(vcpu) &= ~KVM_ARM64_INCREMENT_PC;
+		hyp_state_flags(vcpu_hyps) &= ~KVM_ARM64_INCREMENT_PC;
 	}
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 20dde9dbc11b..9bbe452a461a 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -15,6 +15,7 @@
 
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
 		kvm_skip_instr32(vcpu);
@@ -33,6 +34,7 @@ static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
  */
 static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	*ctxt_pc(vcpu_ctxt) = read_sysreg_el2(SYS_ELR);
 	ctxt_gp_regs(vcpu_ctxt)->pstate = read_sysreg_el2(SYS_SPSR);
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 370a8fb827be..5ee8aac86fdc 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -36,6 +36,7 @@ extern struct exception_table_entry __stop___kvm_ex_table;
 /* Check whether the FP regs were dirtied while in the host-side run loop: */
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	/*
 	 * When the system doesn't support FP/SIMD, we cannot rely on
 	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
@@ -45,15 +46,16 @@ static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 	 */
 	if (!system_supports_fpsimd() ||
 	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
-		vcpu_flags(vcpu) &= ~(KVM_ARM64_FP_ENABLED |
+		hyp_state_flags(vcpu_hyps) &= ~(KVM_ARM64_FP_ENABLED |
 				      KVM_ARM64_FP_HOST);
 
-	return !!(vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED);
+	return !!(hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED);
 }
 
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
@@ -63,6 +65,7 @@ static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 
 static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	/*
 	 * We are about to set CPTR_EL2.TFP to trap all floating point
@@ -79,7 +82,7 @@ static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 	}
 }
 
-static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
+static inline void __activate_traps_common(struct vcpu_hyp_state *vcpu_hyps)
 {
 	/* Trap on AArch32 cp15 c15 (impdef sysregs) accesses (EL1 or EL0) */
 	write_sysreg(1 << 15, hstr_el2);
@@ -94,7 +97,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(0, pmselr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
-	write_sysreg(vcpu_mdcr_el2(vcpu), mdcr_el2);
+	write_sysreg(hyp_state_mdcr_el2(vcpu_hyps), mdcr_el2);
 }
 
 static inline void __deactivate_traps_common(void)
@@ -104,9 +107,9 @@ static inline void __deactivate_traps_common(void)
 		write_sysreg(0, pmuserenr_el0);
 }
 
-static inline void ___activate_traps(struct kvm_vcpu *vcpu)
+static inline void ___activate_traps(struct vcpu_hyp_state *vcpu_hyps)
 {
-	u64 hcr = vcpu_hcr_el2(vcpu);
+	u64 hcr = hyp_state_hcr_el2(vcpu_hyps);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
@@ -114,10 +117,10 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(hcr, hcr_el2);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
-		write_sysreg_s(vcpu_vsesr_el2(vcpu), SYS_VSESR_EL2);
+		write_sysreg_s(hyp_state_vsesr_el2(vcpu_hyps), SYS_VSESR_EL2);
 }
 
-static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
+static inline void ___deactivate_traps(struct vcpu_hyp_state *vcpu_hyps)
 {
 	/*
 	 * If we pended a virtual abort, preserve it until it gets
@@ -125,9 +128,9 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
 	 */
-	if (vcpu_hcr_el2(vcpu) & HCR_VSE) {
-		vcpu_hcr_el2(vcpu) &= ~HCR_VSE;
-		vcpu_hcr_el2(vcpu) |= read_sysreg(hcr_el2) & HCR_VSE;
+	if (hyp_state_hcr_el2(vcpu_hyps) & HCR_VSE) {
+		hyp_state_hcr_el2(vcpu_hyps) &= ~HCR_VSE;
+		hyp_state_hcr_el2(vcpu_hyps) |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
 }
 
@@ -191,18 +194,18 @@ static inline bool __get_fault_info(u64 esr, struct kvm_vcpu_fault_info *fault)
 	return true;
 }
 
-static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
+static inline bool __populate_fault_info(struct vcpu_hyp_state *vcpu_hyps)
 {
 	u8 ec;
 	u64 esr;
 
-	esr = vcpu_fault(vcpu).esr_el2;
+	esr = hyp_state_fault(vcpu_hyps).esr_el2;
 	ec = ESR_ELx_EC(esr);
 
 	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
 		return true;
 
-	return __get_fault_info(esr, &vcpu_fault(vcpu));
+	return __get_fault_info(esr, &hyp_state_fault(vcpu_hyps));
 }
 
 static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
@@ -217,6 +220,7 @@ static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
@@ -227,6 +231,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
 static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	bool sve_guest, sve_host;
 	u8 esr_ec;
@@ -236,8 +241,8 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		return false;
 
 	if (system_supports_sve()) {
-		sve_guest = vcpu_has_sve(vcpu);
-		sve_host = vcpu_flags(vcpu) & KVM_ARM64_HOST_SVE_IN_USE;
+		sve_guest = hyp_state_has_sve(vcpu_hyps);
+		sve_host = hyp_state_flags(vcpu_hyps) & KVM_ARM64_HOST_SVE_IN_USE;
 	} else {
 		sve_guest = false;
 		sve_host = false;
@@ -268,13 +273,13 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	}
 	isb();
 
-	if (vcpu_flags(vcpu) & KVM_ARM64_FP_HOST) {
+	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_HOST) {
 		if (sve_host)
 			__hyp_sve_save_host(vcpu);
 		else
 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 
-		vcpu_flags(vcpu) &= ~KVM_ARM64_FP_HOST;
+		hyp_state_flags(vcpu_hyps) &= ~KVM_ARM64_FP_HOST;
 	}
 
 	if (sve_guest)
@@ -287,13 +292,14 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		write_sysreg(ctxt_sys_reg(vcpu_ctxt, FPEXC32_EL2),
 			     fpexc32_el2);
 
-	vcpu_flags(vcpu) |= KVM_ARM64_FP_ENABLED;
+	hyp_state_flags(vcpu_hyps) |= KVM_ARM64_FP_ENABLED;
 
 	return true;
 }
 
 static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
 	int rt = kvm_vcpu_sys_get_rt(vcpu);
@@ -303,7 +309,7 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	 * The normal sysreg handling code expects to see the traps,
 	 * let's not do anything here.
 	 */
-	if (vcpu_hcr_el2(vcpu) & HCR_TVM)
+	if (hyp_state_hcr_el2(vcpu_hyps) & HCR_TVM)
 		return false;
 
 	switch (sysreg) {
@@ -388,11 +394,12 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 
 static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *ctxt;
 	u64 val;
 
-	if (!vcpu_has_ptrauth(vcpu) ||
+	if (!hyp_state_has_ptrauth(vcpu_hyps) ||
 	    !esr_is_ptrauth_trap(kvm_vcpu_get_esr(vcpu)))
 		return false;
 
@@ -419,9 +426,10 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
-		vcpu_fault(vcpu).esr_el2 = read_sysreg_el2(SYS_ESR);
+		hyp_state_fault(vcpu_hyps).esr_el2 = read_sysreg_el2(SYS_ESR);
 
 	if (ARM_SERROR_PENDING(*exit_code)) {
 		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
@@ -465,7 +473,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 	if (__hyp_handle_ptrauth(vcpu))
 		goto guest;
 
-	if (!__populate_fault_info(vcpu))
+	if (!__populate_fault_info(vcpu_hyps))
 		goto guest;
 
 	if (static_branch_unlikely(&vgic_v2_cpuif_trap)) {
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index d49985e825cd..7bc8b34b65b2 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -158,6 +158,7 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 
 static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
@@ -170,12 +171,13 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	ctxt_sys_reg(vcpu_ctxt, DACR32_EL2) = read_sysreg(dacr32_el2);
 	ctxt_sys_reg(vcpu_ctxt, IFSR32_EL2) = read_sysreg(ifsr32_el2);
 
-	if (has_vhe() || vcpu_flags(vcpu) & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || hyp_state_flags(vcpu_hyps) & KVM_ARM64_DEBUG_DIRTY)
 		ctxt_sys_reg(vcpu_ctxt, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
 }
 
 static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
@@ -188,7 +190,7 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(ctxt_sys_reg(vcpu_ctxt, DACR32_EL2), dacr32_el2);
 	write_sysreg(ctxt_sys_reg(vcpu_ctxt, IFSR32_EL2), ifsr32_el2);
 
-	if (has_vhe() || vcpu_flags(vcpu) & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || hyp_state_flags(vcpu_hyps) & KVM_ARM64_DEBUG_DIRTY)
 		write_sysreg(ctxt_sys_reg(vcpu_ctxt, DBGVCR32_EL2),
 		             dbgvcr32_el2);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index ac7529305717..d9326085387b 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -36,11 +36,12 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val;
 
-	___activate_traps(vcpu);
-	__activate_traps_common(vcpu);
+	___activate_traps(vcpu_hyps);
+	__activate_traps_common(vcpu_hyps);
 
 	val = CPTR_EL2_DEFAULT;
 	val |= CPTR_EL2_TTA | CPTR_EL2_TAM;
@@ -67,13 +68,12 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void __deactivate_traps(struct kvm_vcpu *vcpu)
+static void __deactivate_traps(struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	extern char __kvm_hyp_host_vector[];
 	u64 mdcr_el2, cptr;
 
-	___deactivate_traps(vcpu);
+	___deactivate_traps(vcpu_hyps);
 
 	mdcr_el2 = read_sysreg(mdcr_el2);
 
@@ -104,7 +104,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
 	cptr = CPTR_EL2_DEFAULT;
-	if (vcpu_has_sve(vcpu) && (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED))
+	if (hyp_state_has_sve(vcpu_hyps) && (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED))
 		cptr |= CPTR_EL2_TZ;
 
 	write_sysreg(cptr, cptr_el2);
@@ -170,6 +170,7 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -236,12 +237,12 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__timer_disable_traps();
 	__hyp_vgic_save_state(vcpu);
 
-	__deactivate_traps(vcpu);
+	__deactivate_traps(vcpu_hyps);
 	__load_host_stage2();
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED)
+	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
@@ -270,15 +271,17 @@ void __noreturn hyp_panic(void)
 	u64 par = read_sysreg_par();
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
+	struct vcpu_hyp_state *vcpu_hyps;
 	struct kvm_cpu_context *vcpu_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	vcpu = host_ctxt->__hyp_running_vcpu;
+	vcpu_hyps = &hyp_state(vcpu);
 	vcpu_ctxt = &vcpu_ctxt(vcpu);
 
 	if (vcpu) {
 		__timer_disable_traps();
-		__deactivate_traps(vcpu);
+		__deactivate_traps(vcpu_hyps);
 		__load_host_stage2();
 		__sysreg_restore_state_nvhe(host_ctxt);
 	}
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 8dbc39026cc5..84304d6d455a 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -36,6 +36,7 @@ static bool __is_be(struct kvm_cpu_context *vcpu_ctxt)
  */
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index bdb03b8e50ab..725b2976e7c2 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -473,6 +473,7 @@ static int __vgic_v3_bpr_min(void)
 
 static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 esr = kvm_vcpu_get_esr(vcpu);
 	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
@@ -674,6 +675,7 @@ static int __vgic_v3_clear_highest_active_priority(void)
 
 static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 lr_val;
 	u8 lr_prio, pmr;
@@ -733,6 +735,7 @@ static void __vgic_v3_bump_eoicount(void)
 
 static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 vid = ctxt_get_reg(vcpu_ctxt, rt);
 	u64 lr_val;
@@ -757,6 +760,7 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 vid = ctxt_get_reg(vcpu_ctxt, rt);
 	u64 lr_val;
@@ -795,18 +799,21 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
 }
 
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
 }
 
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 
@@ -820,6 +827,7 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 
@@ -833,18 +841,21 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, __vgic_v3_get_bpr0(vmcr));
 }
 
 static void __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	ctxt_set_reg(vcpu_ctxt, rt, __vgic_v3_get_bpr1(vmcr));
 }
 
 static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 	u8 bpr_min = __vgic_v3_bpr_min() - 1;
@@ -863,6 +874,7 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 	u8 bpr_min = __vgic_v3_bpr_min();
@@ -884,6 +896,7 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val;
 
@@ -897,6 +910,7 @@ static void __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 
 static void __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
@@ -909,6 +923,7 @@ static void __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 static void __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
 					    u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 0);
 }
@@ -916,48 +931,56 @@ static void __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
 static void __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
 					    u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 1);
 }
 
 static void __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 2);
 }
 
 static void __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 3);
 }
 
 static void __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 0);
 }
 
 static void __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 1);
 }
 
 static void __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 2);
 }
 
 static void __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 3);
 }
 
 static void __vgic_v3_read_hppir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 lr_val;
 	int lr, lr_grp, grp;
@@ -978,6 +1001,7 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	vmcr &= ICH_VMCR_PMR_MASK;
 	vmcr >>= ICH_VMCR_PMR_SHIFT;
@@ -986,6 +1010,7 @@ static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
@@ -999,6 +1024,7 @@ static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_rpr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = __vgic_v3_get_highest_active_priority();
 	ctxt_set_reg(vcpu_ctxt, rt, val);
@@ -1006,6 +1032,7 @@ static void __vgic_v3_read_rpr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 vtr, val;
 
@@ -1028,6 +1055,7 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
@@ -1046,6 +1074,7 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int rt;
 	u32 esr;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 0113d442bc95..c9da0d1c7e72 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -33,10 +33,11 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val;
 
-	___activate_traps(vcpu);
+	___activate_traps(vcpu_hyps);
 
 	val = read_sysreg(cpacr_el1);
 	val |= CPACR_EL1_TTA;
@@ -54,7 +55,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 	val |= CPTR_EL2_TAM;
 
 	if (update_fp_enabled(vcpu)) {
-		if (vcpu_has_sve(vcpu))
+		if (hyp_state_has_sve(vcpu_hyps))
 			val |= CPACR_EL1_ZEN;
 	} else {
 		val &= ~CPACR_EL1_FPEN;
@@ -67,12 +68,11 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 }
 NOKPROBE_SYMBOL(__activate_traps);
 
-static void __deactivate_traps(struct kvm_vcpu *vcpu)
+static void __deactivate_traps(struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	extern char vectors[];	/* kernel exception vectors */
 
-	___deactivate_traps(vcpu);
+	___deactivate_traps(vcpu_hyps);
 
 	write_sysreg(HCR_HOST_VHE_FLAGS, hcr_el2);
 
@@ -88,10 +88,9 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 }
 NOKPROBE_SYMBOL(__deactivate_traps);
 
-void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
+void activate_traps_vhe_load(struct vcpu_hyp_state *vcpu_hyps)
 {
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	__activate_traps_common(vcpu);
+	__activate_traps_common(vcpu_hyps);
 }
 
 void deactivate_traps_vhe_put(void)
@@ -110,6 +109,7 @@ void deactivate_traps_vhe_put(void)
 /* Switch to the guest for VHE systems running in EL2 */
 static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
@@ -149,11 +149,11 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_save_guest_state_vhe(guest_ctxt);
 
-	__deactivate_traps(vcpu);
+	__deactivate_traps(vcpu_hyps);
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED)
+	if (hyp_state_flags(vcpu_hyps) & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
@@ -164,6 +164,7 @@ NOKPROBE_SYMBOL(__kvm_vcpu_run_vhe);
 
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int ret;
 
@@ -202,13 +203,15 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
+	struct vcpu_hyp_state *vcpu_hyps;
 	struct kvm_cpu_context *vcpu_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	vcpu = host_ctxt->__hyp_running_vcpu;
+	vcpu_hyps = &hyp_state(vcpu);
 	vcpu_ctxt = &vcpu_ctxt(vcpu);
 
-	__deactivate_traps(vcpu);
+	__deactivate_traps(vcpu_hyps);
 	sysreg_restore_host_state_vhe(host_ctxt);
 
 	panic("HYP panic:\nPS:%08llx PC:%016llx ESR:%08llx\nFAR:%016llx HPFAR:%016llx PAR:%016llx\nVCPU:%p\n",
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 37f56b4743d0..1571c144e9b0 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -63,6 +63,7 @@ NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
  */
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
@@ -82,7 +83,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 
 	vcpu->arch.sysregs_loaded_on_cpu = true;
 
-	activate_traps_vhe_load(vcpu);
+	activate_traps_vhe_load(vcpu_hyps);
 }
 
 /**
@@ -98,6 +99,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 {
+	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
-- 
2.33.0.685.g46640cef36-goog

