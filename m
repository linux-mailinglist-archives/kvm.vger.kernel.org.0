Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 063D7417584
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344675AbhIXNZW (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345179AbhIXNYx (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:53 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2BBEC08EAF5
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:21 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id 7-20020ac85907000000b002a5391eff67so29559726qty.1
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=lLmYOVVwQKylUxYkkgcoQlIWOLYAg3wcffUYq5oEXuI=;
        b=kSDphT8+qk55V3xuhrjRp8h5TfZj8CnkbcVSNA8w4aeBCDoeMdnQg+fEymrm8an3xI
         JewOYNffyi4CuCvMlyKo3p+hem8ueUED7VVUID334/B8Jki+1iiytVTP8WNX0kYNLQHx
         DJMnE6L81oanerU6qdFbCV5yd278p4yl7gPATCgpFV0QXoKq3Ymewem9kh6AEJ64F4Lf
         cnnFxYNRkWqtu4cEfN95oB0Nzb+pdAr5SQ+yigDfG3ukatKznd+LIitIlS6vx7ngn5E7
         sy2bqidVOpaWWXDmV4+TbfVqbQM2Q88Rp3iY7kzSWYDHV+hSbtXMEmFM5XJZnOMDqVyj
         I7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lLmYOVVwQKylUxYkkgcoQlIWOLYAg3wcffUYq5oEXuI=;
        b=g1P4Wv22/TnGxsNiIn0XZfo8II2+8K+oSIm9nhfH+i4N2C2qA1vnqiZckEVE89DYmD
         +r4jyF8Ap8lBKVwgs6eLSrmra1I705owgMkUUUpkwaqSMydV+CMslR+cU2523eMOGjPd
         EXf58MkLkawYo6TwZq5M+JElSfpAJ5Pzuik66HG92GF2SW2Gr5OM+8Scswwdwxh1TNSz
         NG1G3Dzd0CuqGX2+ar5FWVlUHBwlOPJ0T+S6Oh3MWe6oonxqpi/mUS6qoDpYUoZH2c/O
         IwEimdvEP9kLWfEhqvzp0mGmwpxPzPY2jUGcbGxyIq1DST6+foNKPFmKDYCaZOOL4Uip
         0+Pw==
X-Gm-Message-State: AOAM533QG4g5B2JcbEqXRzeJI9FzjMS2g6SkNdkvbpizxumwi3dma3vG
        6bb7VEQfViRVXEsfK4NuFWd1E608Pg==
X-Google-Smtp-Source: ABdhPJwGkJ9wje6r9ZhTac8v8zFhECkCuGAOQ8vY17+yczUgDJXFv6d6aj6qxPJ9dKyb1gz9iQSd80BDxQ==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:e68:: with SMTP id
 jz8mr1703156qvb.21.1632488061042; Fri, 24 Sep 2021 05:54:21 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:38 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-10-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 09/30] KVM: arm64: COCCI: vcpu_hyp_accessors.cocci: use
 accessors for hypervisor state vcpu variables
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

To simplify future refactoring, ensure that all access to the
hypervisor state related fields in vcpu use the accessors created
previously in this patch series, rather than by dereferencing the
vcpu directly.

The semantic patch is applied with the following command:
spatch --sp-file cocci_refactor/vcpu_hyp_accessors.cocci --dir arch/arm64 --include-headers --in-place

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h       | 52 +++++++++++-----------
 arch/arm64/kvm/arm.c                       |  2 +-
 arch/arm64/kvm/debug.c                     | 28 ++++++------
 arch/arm64/kvm/fpsimd.c                    | 20 ++++-----
 arch/arm64/kvm/guest.c                     |  2 +-
 arch/arm64/kvm/handle_exit.c               |  2 +-
 arch/arm64/kvm/hyp/exception.c             | 12 ++---
 arch/arm64/kvm/hyp/include/hyp/debug-sr.h  |  6 +--
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 32 ++++++-------
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |  4 +-
 arch/arm64/kvm/hyp/nvhe/debug-sr.c         |  8 ++--
 arch/arm64/kvm/hyp/nvhe/switch.c           |  4 +-
 arch/arm64/kvm/hyp/vhe/switch.c            |  2 +-
 arch/arm64/kvm/inject_fault.c              | 10 ++---
 arch/arm64/kvm/reset.c                     |  6 +--
 arch/arm64/kvm/sys_regs.c                  |  4 +-
 16 files changed, 97 insertions(+), 97 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index ad6e53cef1a4..7d09a9356d89 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -43,23 +43,23 @@ void kvm_inject_pabt(struct kvm_vcpu *vcpu, unsigned long addr);
 
 static __always_inline bool vcpu_el1_is_32bit(struct kvm_vcpu *vcpu)
 {
-	return !(vcpu->arch.hcr_el2 & HCR_RW);
+	return !(vcpu_hcr_el2(vcpu) & HCR_RW);
 }
 
 static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 = HCR_GUEST_FLAGS;
+	vcpu_hcr_el2(vcpu) = HCR_GUEST_FLAGS;
 	if (is_kernel_in_hyp_mode())
-		vcpu->arch.hcr_el2 |= HCR_E2H;
+		vcpu_hcr_el2(vcpu) |= HCR_E2H;
 	if (cpus_have_const_cap(ARM64_HAS_RAS_EXTN)) {
 		/* route synchronous external abort exceptions to EL2 */
-		vcpu->arch.hcr_el2 |= HCR_TEA;
+		vcpu_hcr_el2(vcpu) |= HCR_TEA;
 		/* trap error record accesses */
-		vcpu->arch.hcr_el2 |= HCR_TERR;
+		vcpu_hcr_el2(vcpu) |= HCR_TERR;
 	}
 
 	if (cpus_have_const_cap(ARM64_HAS_STAGE2_FWB)) {
-		vcpu->arch.hcr_el2 |= HCR_FWB;
+		vcpu_hcr_el2(vcpu) |= HCR_FWB;
 	} else {
 		/*
 		 * For non-FWB CPUs, we trap VM ops (HCR_EL2.TVM) until M+C
@@ -67,11 +67,11 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 		 * MMU gets turned on and do the necessary cache maintenance
 		 * then.
 		 */
-		vcpu->arch.hcr_el2 |= HCR_TVM;
+		vcpu_hcr_el2(vcpu) |= HCR_TVM;
 	}
 
 	if (test_bit(KVM_ARM_VCPU_EL1_32BIT, vcpu->arch.features))
-		vcpu->arch.hcr_el2 &= ~HCR_RW;
+		vcpu_hcr_el2(vcpu) &= ~HCR_RW;
 
 	/*
 	 * TID3: trap feature register accesses that we virtualise.
@@ -79,52 +79,52 @@ static inline void vcpu_reset_hcr(struct kvm_vcpu *vcpu)
 	 * are currently virtualised.
 	 */
 	if (!vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID3;
+		vcpu_hcr_el2(vcpu) |= HCR_TID3;
 
 	if (cpus_have_const_cap(ARM64_MISMATCHED_CACHE_TYPE) ||
 	    vcpu_el1_is_32bit(vcpu))
-		vcpu->arch.hcr_el2 |= HCR_TID2;
+		vcpu_hcr_el2(vcpu) |= HCR_TID2;
 }
 
 static inline unsigned long *vcpu_hcr(struct kvm_vcpu *vcpu)
 {
-	return (unsigned long *)&vcpu->arch.hcr_el2;
+	return (unsigned long *)&vcpu_hcr_el2(vcpu);
 }
 
 static inline void vcpu_clear_wfx_traps(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 &= ~HCR_TWE;
+	vcpu_hcr_el2(vcpu) &= ~HCR_TWE;
 	if (atomic_read(&vcpu->arch.vgic_cpu.vgic_v3.its_vpe.vlpi_count) ||
 	    vcpu->kvm->arch.vgic.nassgireq)
-		vcpu->arch.hcr_el2 &= ~HCR_TWI;
-	else
-		vcpu->arch.hcr_el2 |= HCR_TWI;
+		vcpu_hcr_el2(vcpu) &= ~HCR_TWI;
+		else
+			vcpu_hcr_el2(vcpu) |= HCR_TWI;
 }
 
 static inline void vcpu_set_wfx_traps(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 |= HCR_TWE;
-	vcpu->arch.hcr_el2 |= HCR_TWI;
+	vcpu_hcr_el2(vcpu) |= HCR_TWE;
+	vcpu_hcr_el2(vcpu) |= HCR_TWI;
 }
 
 static inline void vcpu_ptrauth_enable(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 |= (HCR_API | HCR_APK);
+	vcpu_hcr_el2(vcpu) |= (HCR_API | HCR_APK);
 }
 
 static inline void vcpu_ptrauth_disable(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.hcr_el2 &= ~(HCR_API | HCR_APK);
+	vcpu_hcr_el2(vcpu) &= ~(HCR_API | HCR_APK);
 }
 
 static inline unsigned long vcpu_get_vsesr(struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.vsesr_el2;
+	return vcpu_vsesr_el2(vcpu);
 }
 
 static inline void vcpu_set_vsesr(struct kvm_vcpu *vcpu, u64 vsesr)
 {
-	vcpu->arch.vsesr_el2 = vsesr;
+	vcpu_vsesr_el2(vcpu) = vsesr;
 }
 
 static __always_inline unsigned long *ctxt_pc(const struct kvm_cpu_context *ctxt)
@@ -254,7 +254,7 @@ static inline bool vcpu_mode_priv(const struct kvm_vcpu *vcpu)
 
 static __always_inline u32 kvm_vcpu_get_esr(const struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.fault.esr_el2;
+	return vcpu_fault(vcpu).esr_el2;
 }
 
 static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
@@ -269,17 +269,17 @@ static __always_inline int kvm_vcpu_get_condition(const struct kvm_vcpu *vcpu)
 
 static __always_inline unsigned long kvm_vcpu_get_hfar(const struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.fault.far_el2;
+	return vcpu_fault(vcpu).far_el2;
 }
 
 static __always_inline phys_addr_t kvm_vcpu_get_fault_ipa(const struct kvm_vcpu *vcpu)
 {
-	return ((phys_addr_t)vcpu->arch.fault.hpfar_el2 & HPFAR_MASK) << 8;
+	return ((phys_addr_t) vcpu_fault(vcpu).hpfar_el2 & HPFAR_MASK) << 8;
 }
 
 static inline u64 kvm_vcpu_get_disr(const struct kvm_vcpu *vcpu)
 {
-	return vcpu->arch.fault.disr_el1;
+	return vcpu_fault(vcpu).disr_el1;
 }
 
 static inline u32 kvm_vcpu_hvc_get_imm(const struct kvm_vcpu *vcpu)
@@ -493,7 +493,7 @@ static inline unsigned long vcpu_data_host_to_guest(struct kvm_vcpu *vcpu,
 
 static __always_inline void kvm_incr_pc(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.flags |= KVM_ARM64_INCREMENT_PC;
+	vcpu_flags(vcpu) |= KVM_ARM64_INCREMENT_PC;
 }
 
 static inline bool vcpu_has_feature(struct kvm_vcpu *vcpu, int feature)
diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
index e720148232a0..5f0e2f9821ec 100644
--- a/arch/arm64/kvm/arm.c
+++ b/arch/arm64/kvm/arm.c
@@ -907,7 +907,7 @@ int kvm_arch_vcpu_ioctl_run(struct kvm_vcpu *vcpu)
 	 * the vcpu state. Note that this relies on __kvm_adjust_pc()
 	 * being preempt-safe on VHE.
 	 */
-	if (unlikely(vcpu->arch.flags & (KVM_ARM64_PENDING_EXCEPTION |
+	if (unlikely(vcpu_flags(vcpu) & (KVM_ARM64_PENDING_EXCEPTION |
 					 KVM_ARM64_INCREMENT_PC)))
 		kvm_call_hyp(__kvm_adjust_pc, vcpu);
 
diff --git a/arch/arm64/kvm/debug.c b/arch/arm64/kvm/debug.c
index d5e79d7ee6e9..e7a5956fe648 100644
--- a/arch/arm64/kvm/debug.c
+++ b/arch/arm64/kvm/debug.c
@@ -87,8 +87,8 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 * This also clears MDCR_EL2_E2PB_MASK and MDCR_EL2_E2TB_MASK
 	 * to disable guest access to the profiling and trace buffers
 	 */
-	vcpu->arch.mdcr_el2 = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
-	vcpu->arch.mdcr_el2 |= (MDCR_EL2_TPM |
+	vcpu_mdcr_el2(vcpu) = __this_cpu_read(mdcr_el2) & MDCR_EL2_HPMN_MASK;
+	vcpu_mdcr_el2(vcpu) |= (MDCR_EL2_TPM |
 				MDCR_EL2_TPMS |
 				MDCR_EL2_TTRF |
 				MDCR_EL2_TPMCR |
@@ -98,7 +98,7 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	/* Is the VM being debugged by userspace? */
 	if (vcpu->guest_debug)
 		/* Route all software debug exceptions to EL2 */
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDE;
+		vcpu_mdcr_el2(vcpu) |= MDCR_EL2_TDE;
 
 	/*
 	 * Trap debug register access when one of the following is true:
@@ -107,10 +107,10 @@ static void kvm_arm_setup_mdcr_el2(struct kvm_vcpu *vcpu)
 	 *  - The guest is not using debug (KVM_ARM64_DEBUG_DIRTY is clear).
 	 */
 	if ((vcpu->guest_debug & KVM_GUESTDBG_USE_HW) ||
-	    !(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
-		vcpu->arch.mdcr_el2 |= MDCR_EL2_TDA;
+	    !(vcpu_flags(vcpu) & KVM_ARM64_DEBUG_DIRTY))
+		vcpu_mdcr_el2(vcpu) |= MDCR_EL2_TDA;
 
-	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu->arch.mdcr_el2);
+	trace_kvm_arm_set_dreg32("MDCR_EL2", vcpu_mdcr_el2(vcpu));
 }
 
 /**
@@ -154,7 +154,7 @@ void kvm_arm_reset_debug_ptr(struct kvm_vcpu *vcpu)
 
 void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 {
-	unsigned long mdscr, orig_mdcr_el2 = vcpu->arch.mdcr_el2;
+	unsigned long mdscr, orig_mdcr_el2 = vcpu_mdcr_el2(vcpu);
 
 	trace_kvm_arm_setup_debug(vcpu, vcpu->guest_debug);
 
@@ -214,7 +214,7 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 			vcpu_write_sys_reg(vcpu, mdscr, MDSCR_EL1);
 
 			vcpu->arch.debug_ptr = &vcpu->arch.external_debug_state;
-			vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+			vcpu_flags(vcpu) |= KVM_ARM64_DEBUG_DIRTY;
 
 			trace_kvm_arm_set_regset("BKPTS", get_num_brps(),
 						&vcpu->arch.debug_ptr->dbg_bcr[0],
@@ -231,11 +231,11 @@ void kvm_arm_setup_debug(struct kvm_vcpu *vcpu)
 
 	/* If KDE or MDE are set, perform a full save/restore cycle. */
 	if (vcpu_read_sys_reg(vcpu, MDSCR_EL1) & (DBG_MDSCR_KDE | DBG_MDSCR_MDE))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu_flags(vcpu) |= KVM_ARM64_DEBUG_DIRTY;
 
 	/* Write mdcr_el2 changes since vcpu_load on VHE systems */
-	if (has_vhe() && orig_mdcr_el2 != vcpu->arch.mdcr_el2)
-		write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	if (has_vhe() && orig_mdcr_el2 != vcpu_mdcr_el2(vcpu))
+		write_sysreg(vcpu_mdcr_el2(vcpu), mdcr_el2);
 
 	trace_kvm_arm_set_dreg32("MDSCR_EL1", vcpu_read_sys_reg(vcpu, MDSCR_EL1));
 }
@@ -280,16 +280,16 @@ void kvm_arch_vcpu_load_debug_state_flags(struct kvm_vcpu *vcpu)
 	 */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_PMSVER_SHIFT) &&
 	    !(read_sysreg_s(SYS_PMBIDR_EL1) & BIT(SYS_PMBIDR_EL1_P_SHIFT)))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_STATE_SAVE_SPE;
+		vcpu_flags(vcpu) |= KVM_ARM64_DEBUG_STATE_SAVE_SPE;
 
 	/* Check if we have TRBE implemented and available at the host */
 	if (cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_TRBE_SHIFT) &&
 	    !(read_sysreg_s(SYS_TRBIDR_EL1) & TRBIDR_PROG))
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_STATE_SAVE_TRBE;
+		vcpu_flags(vcpu) |= KVM_ARM64_DEBUG_STATE_SAVE_TRBE;
 }
 
 void kvm_arch_vcpu_put_debug_state_flags(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.flags &= ~(KVM_ARM64_DEBUG_STATE_SAVE_SPE |
+	vcpu_flags(vcpu) &= ~(KVM_ARM64_DEBUG_STATE_SAVE_SPE |
 			      KVM_ARM64_DEBUG_STATE_SAVE_TRBE);
 }
diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index db135588236a..1871a267e2ed 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -74,16 +74,16 @@ void kvm_arch_vcpu_load_fp(struct kvm_vcpu *vcpu)
 {
 	BUG_ON(!current->mm);
 
-	vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
-			      KVM_ARM64_HOST_SVE_IN_USE |
-			      KVM_ARM64_HOST_SVE_ENABLED);
-	vcpu->arch.flags |= KVM_ARM64_FP_HOST;
+	vcpu_flags(vcpu) &= ~(KVM_ARM64_FP_ENABLED |
+		              KVM_ARM64_HOST_SVE_IN_USE |
+		              KVM_ARM64_HOST_SVE_ENABLED);
+	vcpu_flags(vcpu) |= KVM_ARM64_FP_HOST;
 
 	if (test_thread_flag(TIF_SVE))
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_IN_USE;
+		vcpu_flags(vcpu) |= KVM_ARM64_HOST_SVE_IN_USE;
 
 	if (read_sysreg(cpacr_el1) & CPACR_EL1_ZEN_EL0EN)
-		vcpu->arch.flags |= KVM_ARM64_HOST_SVE_ENABLED;
+		vcpu_flags(vcpu) |= KVM_ARM64_HOST_SVE_ENABLED;
 }
 
 /*
@@ -96,7 +96,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 {
 	WARN_ON_ONCE(!irqs_disabled());
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+	if (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED) {
 		fpsimd_bind_state_to_cpu(vcpu_fp_regs(vcpu),
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl);
@@ -120,7 +120,7 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 
 	local_irq_save(flags);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
+	if (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED) {
 		if (guest_has_sve) {
 			__vcpu_sys_reg(vcpu, ZCR_EL1) = read_sysreg_el1(SYS_ZCR);
 
@@ -139,14 +139,14 @@ void kvm_arch_vcpu_put_fp(struct kvm_vcpu *vcpu)
 		 * for EL0.  To avoid spurious traps, restore the trap state
 		 * seen by kvm_arch_vcpu_load_fp():
 		 */
-		if (vcpu->arch.flags & KVM_ARM64_HOST_SVE_ENABLED)
+		if (vcpu_flags(vcpu) & KVM_ARM64_HOST_SVE_ENABLED)
 			sysreg_clear_set(CPACR_EL1, 0, CPACR_EL1_ZEN_EL0EN);
 		else
 			sysreg_clear_set(CPACR_EL1, CPACR_EL1_ZEN_EL0EN, 0);
 	}
 
 	update_thread_flag(TIF_SVE,
-			   vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE);
+			   vcpu_flags(vcpu) & KVM_ARM64_HOST_SVE_IN_USE);
 
 	local_irq_restore(flags);
 }
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index c4429307a164..fc63e55db2f0 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -782,7 +782,7 @@ int kvm_arch_vcpu_ioctl_set_sregs(struct kvm_vcpu *vcpu,
 int __kvm_arm_vcpu_get_events(struct kvm_vcpu *vcpu,
 			      struct kvm_vcpu_events *events)
 {
-	events->exception.serror_pending = !!(vcpu->arch.hcr_el2 & HCR_VSE);
+	events->exception.serror_pending = !!(vcpu_hcr_el2(vcpu) & HCR_VSE);
 	events->exception.serror_has_esr = cpus_have_const_cap(ARM64_HAS_RAS_EXTN);
 
 	if (events->exception.serror_pending && events->exception.serror_has_esr)
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index 6f48336b1d86..22e9f03fe901 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -126,7 +126,7 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 
 	switch (ESR_ELx_EC(esr)) {
 	case ESR_ELx_EC_WATCHPT_LOW:
-		run->debug.arch.far = vcpu->arch.fault.far_el2;
+		run->debug.arch.far = vcpu_fault(vcpu).far_el2;
 		fallthrough;
 	case ESR_ELx_EC_SOFTSTP_LOW:
 	case ESR_ELx_EC_BREAKPT_LOW:
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index e23b9cedb043..4514e345c26f 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -328,7 +328,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (vcpu_el1_is_32bit(vcpu)) {
-		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
+		switch (vcpu_flags(vcpu) & KVM_ARM64_EXCEPT_MASK) {
 		case KVM_ARM64_EXCEPT_AA32_UND:
 			enter_exception32(vcpu_ctxt, PSR_AA32_MODE_UND, 4);
 			break;
@@ -343,7 +343,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 			break;
 		}
 	} else {
-		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
+		switch (vcpu_flags(vcpu) & KVM_ARM64_EXCEPT_MASK) {
 		case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
 		      KVM_ARM64_EXCEPT_AA64_EL1):
 			enter_exception64(vcpu_ctxt, PSR_MODE_EL1h,
@@ -367,12 +367,12 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 {
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
-	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
+	if (vcpu_flags(vcpu) & KVM_ARM64_PENDING_EXCEPTION) {
 		kvm_inject_exception(vcpu);
-		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
+		vcpu_flags(vcpu) &= ~(KVM_ARM64_PENDING_EXCEPTION |
 				      KVM_ARM64_EXCEPT_MASK);
-	} else 	if (vcpu->arch.flags & KVM_ARM64_INCREMENT_PC) {
+	} else 	if (vcpu_flags(vcpu) & KVM_ARM64_INCREMENT_PC) {
 		kvm_skip_instr(vcpu);
-		vcpu->arch.flags &= ~KVM_ARM64_INCREMENT_PC;
+		vcpu_flags(vcpu) &= ~KVM_ARM64_INCREMENT_PC;
 	}
 }
diff --git a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
index 4ebe9f558f3a..55735782d7e3 100644
--- a/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/debug-sr.h
@@ -132,7 +132,7 @@ static inline void __debug_switch_to_guest_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+	if (!(vcpu_flags(vcpu) & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
@@ -151,7 +151,7 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	struct kvm_guest_debug_arch *host_dbg;
 	struct kvm_guest_debug_arch *guest_dbg;
 
-	if (!(vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY))
+	if (!(vcpu_flags(vcpu) & KVM_ARM64_DEBUG_DIRTY))
 		return;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
@@ -162,7 +162,7 @@ static inline void __debug_switch_to_host_common(struct kvm_vcpu *vcpu)
 	__debug_save_state(guest_dbg, guest_ctxt);
 	__debug_restore_state(host_dbg, host_ctxt);
 
-	vcpu->arch.flags &= ~KVM_ARM64_DEBUG_DIRTY;
+	vcpu_flags(vcpu) &= ~KVM_ARM64_DEBUG_DIRTY;
 }
 
 #endif /* __ARM64_KVM_HYP_DEBUG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 41c553a7b5dd..370a8fb827be 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -45,10 +45,10 @@ static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 	 */
 	if (!system_supports_fpsimd() ||
 	    vcpu->arch.host_thread_info->flags & _TIF_FOREIGN_FPSTATE)
-		vcpu->arch.flags &= ~(KVM_ARM64_FP_ENABLED |
+		vcpu_flags(vcpu) &= ~(KVM_ARM64_FP_ENABLED |
 				      KVM_ARM64_FP_HOST);
 
-	return !!(vcpu->arch.flags & KVM_ARM64_FP_ENABLED);
+	return !!(vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED);
 }
 
 /* Save the 32-bit only FPSIMD system register state */
@@ -94,7 +94,7 @@ static inline void __activate_traps_common(struct kvm_vcpu *vcpu)
 		write_sysreg(0, pmselr_el0);
 		write_sysreg(ARMV8_PMU_USERENR_MASK, pmuserenr_el0);
 	}
-	write_sysreg(vcpu->arch.mdcr_el2, mdcr_el2);
+	write_sysreg(vcpu_mdcr_el2(vcpu), mdcr_el2);
 }
 
 static inline void __deactivate_traps_common(void)
@@ -106,7 +106,7 @@ static inline void __deactivate_traps_common(void)
 
 static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 {
-	u64 hcr = vcpu->arch.hcr_el2;
+	u64 hcr = vcpu_hcr_el2(vcpu);
 
 	if (cpus_have_final_cap(ARM64_WORKAROUND_CAVIUM_TX2_219_TVM))
 		hcr |= HCR_TVM;
@@ -114,7 +114,7 @@ static inline void ___activate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(hcr, hcr_el2);
 
 	if (cpus_have_final_cap(ARM64_HAS_RAS_EXTN) && (hcr & HCR_VSE))
-		write_sysreg_s(vcpu->arch.vsesr_el2, SYS_VSESR_EL2);
+		write_sysreg_s(vcpu_vsesr_el2(vcpu), SYS_VSESR_EL2);
 }
 
 static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
@@ -125,9 +125,9 @@ static inline void ___deactivate_traps(struct kvm_vcpu *vcpu)
 	 * the crucial bit is "On taking a vSError interrupt,
 	 * HCR_EL2.VSE is cleared to 0."
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_VSE) {
-		vcpu->arch.hcr_el2 &= ~HCR_VSE;
-		vcpu->arch.hcr_el2 |= read_sysreg(hcr_el2) & HCR_VSE;
+	if (vcpu_hcr_el2(vcpu) & HCR_VSE) {
+		vcpu_hcr_el2(vcpu) &= ~HCR_VSE;
+		vcpu_hcr_el2(vcpu) |= read_sysreg(hcr_el2) & HCR_VSE;
 	}
 }
 
@@ -196,13 +196,13 @@ static inline bool __populate_fault_info(struct kvm_vcpu *vcpu)
 	u8 ec;
 	u64 esr;
 
-	esr = vcpu->arch.fault.esr_el2;
+	esr = vcpu_fault(vcpu).esr_el2;
 	ec = ESR_ELx_EC(esr);
 
 	if (ec != ESR_ELx_EC_DABT_LOW && ec != ESR_ELx_EC_IABT_LOW)
 		return true;
 
-	return __get_fault_info(esr, &vcpu->arch.fault);
+	return __get_fault_info(esr, &vcpu_fault(vcpu));
 }
 
 static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
@@ -237,7 +237,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 	if (system_supports_sve()) {
 		sve_guest = vcpu_has_sve(vcpu);
-		sve_host = vcpu->arch.flags & KVM_ARM64_HOST_SVE_IN_USE;
+		sve_host = vcpu_flags(vcpu) & KVM_ARM64_HOST_SVE_IN_USE;
 	} else {
 		sve_guest = false;
 		sve_host = false;
@@ -268,13 +268,13 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	}
 	isb();
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_HOST) {
+	if (vcpu_flags(vcpu) & KVM_ARM64_FP_HOST) {
 		if (sve_host)
 			__hyp_sve_save_host(vcpu);
 		else
 			__fpsimd_save_state(vcpu->arch.host_fpsimd_state);
 
-		vcpu->arch.flags &= ~KVM_ARM64_FP_HOST;
+		vcpu_flags(vcpu) &= ~KVM_ARM64_FP_HOST;
 	}
 
 	if (sve_guest)
@@ -287,7 +287,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 		write_sysreg(ctxt_sys_reg(vcpu_ctxt, FPEXC32_EL2),
 			     fpexc32_el2);
 
-	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
+	vcpu_flags(vcpu) |= KVM_ARM64_FP_ENABLED;
 
 	return true;
 }
@@ -303,7 +303,7 @@ static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 	 * The normal sysreg handling code expects to see the traps,
 	 * let's not do anything here.
 	 */
-	if (vcpu->arch.hcr_el2 & HCR_TVM)
+	if (vcpu_hcr_el2(vcpu) & HCR_TVM)
 		return false;
 
 	switch (sysreg) {
@@ -421,7 +421,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
-		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
+		vcpu_fault(vcpu).esr_el2 = read_sysreg_el2(SYS_ESR);
 
 	if (ARM_SERROR_PENDING(*exit_code)) {
 		u8 esr_ec = kvm_vcpu_trap_get_class(vcpu);
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index c2668b85b67e..d49985e825cd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -170,7 +170,7 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	ctxt_sys_reg(vcpu_ctxt, DACR32_EL2) = read_sysreg(dacr32_el2);
 	ctxt_sys_reg(vcpu_ctxt, IFSR32_EL2) = read_sysreg(ifsr32_el2);
 
-	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu_flags(vcpu) & KVM_ARM64_DEBUG_DIRTY)
 		ctxt_sys_reg(vcpu_ctxt, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
 }
 
@@ -188,7 +188,7 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	write_sysreg(ctxt_sys_reg(vcpu_ctxt, DACR32_EL2), dacr32_el2);
 	write_sysreg(ctxt_sys_reg(vcpu_ctxt, IFSR32_EL2), ifsr32_el2);
 
-	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
+	if (has_vhe() || vcpu_flags(vcpu) & KVM_ARM64_DEBUG_DIRTY)
 		write_sysreg(ctxt_sys_reg(vcpu_ctxt, DBGVCR32_EL2),
 		             dbgvcr32_el2);
 }
diff --git a/arch/arm64/kvm/hyp/nvhe/debug-sr.c b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
index 7d3f25868cae..934737478d64 100644
--- a/arch/arm64/kvm/hyp/nvhe/debug-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/debug-sr.c
@@ -84,10 +84,10 @@ static void __debug_restore_trace(u64 trfcr_el1)
 void __debug_save_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
 	/* Disable and flush SPE data generation */
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
+	if (vcpu_flags(vcpu) & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
 		__debug_save_spe(&vcpu->arch.host_debug_state.pmscr_el1);
 	/* Disable and flush Self-Hosted Trace generation */
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
+	if (vcpu_flags(vcpu) & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
 		__debug_save_trace(&vcpu->arch.host_debug_state.trfcr_el1);
 }
 
@@ -98,9 +98,9 @@ void __debug_switch_to_guest(struct kvm_vcpu *vcpu)
 
 void __debug_restore_host_buffers_nvhe(struct kvm_vcpu *vcpu)
 {
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
+	if (vcpu_flags(vcpu) & KVM_ARM64_DEBUG_STATE_SAVE_SPE)
 		__debug_restore_spe(vcpu->arch.host_debug_state.pmscr_el1);
-	if (vcpu->arch.flags & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
+	if (vcpu_flags(vcpu) & KVM_ARM64_DEBUG_STATE_SAVE_TRBE)
 		__debug_restore_trace(vcpu->arch.host_debug_state.trfcr_el1);
 }
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d5780acab6c2..ac7529305717 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -104,7 +104,7 @@ static void __deactivate_traps(struct kvm_vcpu *vcpu)
 	write_sysreg(this_cpu_ptr(&kvm_init_params)->hcr_el2, hcr_el2);
 
 	cptr = CPTR_EL2_DEFAULT;
-	if (vcpu_has_sve(vcpu) && (vcpu->arch.flags & KVM_ARM64_FP_ENABLED))
+	if (vcpu_has_sve(vcpu) && (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED))
 		cptr |= CPTR_EL2_TZ;
 
 	write_sysreg(cptr, cptr_el2);
@@ -241,7 +241,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_restore_state_nvhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
+	if (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index c2e443202f8e..0113d442bc95 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -153,7 +153,7 @@ static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 
 	sysreg_restore_host_state_vhe(host_ctxt);
 
-	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED)
+	if (vcpu_flags(vcpu) & KVM_ARM64_FP_ENABLED)
 		__fpsimd_save_fpexc32(vcpu);
 
 	__debug_switch_to_host(vcpu);
diff --git a/arch/arm64/kvm/inject_fault.c b/arch/arm64/kvm/inject_fault.c
index b47df73e98d7..867e8856bdcd 100644
--- a/arch/arm64/kvm/inject_fault.c
+++ b/arch/arm64/kvm/inject_fault.c
@@ -20,7 +20,7 @@ static void inject_abt64(struct kvm_vcpu *vcpu, bool is_iabt, unsigned long addr
 	bool is_aarch32 = vcpu_mode_is_32bit(vcpu);
 	u32 esr = 0;
 
-	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
+	vcpu_flags(vcpu) |= (KVM_ARM64_EXCEPT_AA64_EL1		|
 			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
 			     KVM_ARM64_PENDING_EXCEPTION);
 
@@ -52,7 +52,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 {
 	u32 esr = (ESR_ELx_EC_UNKNOWN << ESR_ELx_EC_SHIFT);
 
-	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA64_EL1		|
+	vcpu_flags(vcpu) |= (KVM_ARM64_EXCEPT_AA64_EL1		|
 			     KVM_ARM64_EXCEPT_AA64_ELx_SYNC	|
 			     KVM_ARM64_PENDING_EXCEPTION);
 
@@ -73,7 +73,7 @@ static void inject_undef64(struct kvm_vcpu *vcpu)
 
 static void inject_undef32(struct kvm_vcpu *vcpu)
 {
-	vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_UND |
+	vcpu_flags(vcpu) |= (KVM_ARM64_EXCEPT_AA32_UND |
 			     KVM_ARM64_PENDING_EXCEPTION);
 }
 
@@ -97,13 +97,13 @@ static void inject_abt32(struct kvm_vcpu *vcpu, bool is_pabt, u32 addr)
 	far = vcpu_read_sys_reg(vcpu, FAR_EL1);
 
 	if (is_pabt) {
-		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_IABT |
+		vcpu_flags(vcpu) |= (KVM_ARM64_EXCEPT_AA32_IABT |
 				     KVM_ARM64_PENDING_EXCEPTION);
 		far &= GENMASK(31, 0);
 		far |= (u64)addr << 32;
 		vcpu_write_sys_reg(vcpu, fsr, IFSR32_EL2);
 	} else { /* !iabt */
-		vcpu->arch.flags |= (KVM_ARM64_EXCEPT_AA32_DABT |
+		vcpu_flags(vcpu) |= (KVM_ARM64_EXCEPT_AA32_DABT |
 				     KVM_ARM64_PENDING_EXCEPTION);
 		far &= GENMASK(63, 32);
 		far |= addr;
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index ab1ef5313a3e..f94b5b07d2cf 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -81,7 +81,7 @@ static int kvm_vcpu_enable_sve(struct kvm_vcpu *vcpu)
 	 * KVM_REG_ARM64_SVE_VLS.  Allocation is deferred until
 	 * kvm_arm_vcpu_finalize(), which freezes the configuration.
 	 */
-	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_SVE;
+	vcpu_flags(vcpu) |= KVM_ARM64_GUEST_HAS_SVE;
 
 	return 0;
 }
@@ -111,7 +111,7 @@ static int kvm_vcpu_finalize_sve(struct kvm_vcpu *vcpu)
 		return -ENOMEM;
 
 	vcpu->arch.sve_state = buf;
-	vcpu->arch.flags |= KVM_ARM64_VCPU_SVE_FINALIZED;
+	vcpu_flags(vcpu) |= KVM_ARM64_VCPU_SVE_FINALIZED;
 	return 0;
 }
 
@@ -162,7 +162,7 @@ static int kvm_vcpu_enable_ptrauth(struct kvm_vcpu *vcpu)
 	    !system_has_full_ptr_auth())
 		return -EINVAL;
 
-	vcpu->arch.flags |= KVM_ARM64_GUEST_HAS_PTRAUTH;
+	vcpu_flags(vcpu) |= KVM_ARM64_GUEST_HAS_PTRAUTH;
 	return 0;
 }
 
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index 1a7968ad078c..8fb57e83e9ec 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -348,7 +348,7 @@ static bool trap_debug_regs(struct kvm_vcpu *vcpu,
 {
 	if (p->is_write) {
 		vcpu_write_sys_reg(vcpu, p->regval, r->reg);
-		vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+		vcpu_flags(vcpu) |= KVM_ARM64_DEBUG_DIRTY;
 	} else {
 		p->regval = vcpu_read_sys_reg(vcpu, r->reg);
 	}
@@ -381,7 +381,7 @@ static void reg_to_dbg(struct kvm_vcpu *vcpu,
 	val |= (p->regval & (mask >> shift)) << shift;
 	*dbg_reg = val;
 
-	vcpu->arch.flags |= KVM_ARM64_DEBUG_DIRTY;
+	vcpu_flags(vcpu) |= KVM_ARM64_DEBUG_DIRTY;
 }
 
 static void dbg_to_reg(struct kvm_vcpu *vcpu,
-- 
2.33.0.685.g46640cef36-goog

