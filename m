Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05D264DBBEF
	for <lists+kvm@lfdr.de>; Thu, 17 Mar 2022 01:56:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240868AbiCQA6A (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Wed, 16 Mar 2022 20:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354895AbiCQA55 (ORCPT <rfc822;kvm@vger.kernel.org>);
        Wed, 16 Mar 2022 20:57:57 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768E21ADB0
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 17:56:41 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id x5-20020a637c05000000b003817f40e072so885887pgc.17
        for <kvm@vger.kernel.org>; Wed, 16 Mar 2022 17:56:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=SfRZ2nJezeRkn8Q7eug5nt9PRgEWCVYeYSijk8DC2dM=;
        b=V5bCzuMRvj+qRCG4E6WF48LadjBU4M7IHLR67q5kMZthAjuMGDLJFtFtKoaZtWb2wm
         DMA7sQwH50JHjD6Gwe0cmC1aIUbpWcoWabQiXHC5k7mHWSKaOo4ZP3ESypcZpelKT9Yx
         4WVecX7AFkNYa/6AVQv2mYASSLxH32FqjNR07ZZSRBBSvDwjXClmAa3z0Gbz3joQ1zx0
         2YphMidAfA9MRwsVvwhqzK12v1MkO3XWdi4UMfF/ZyTdunhbJcBT7zKRuIwXAKjy311A
         s4PyFqADv9pvBZy8Ucp3iYyHBQgjWm53QZacFjvc8jOgmLWtGRrlvYyATbm+vYeJ3ktS
         Ndsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=SfRZ2nJezeRkn8Q7eug5nt9PRgEWCVYeYSijk8DC2dM=;
        b=CQP3O9Nho4sy3oh5iXK9E12QgCk3WK+dBjVHQGhubocr0D6Tb6SRDub7VObktn3sOt
         GZQnukJZ6goo/rhLOwNZJQ69avDlZYWIfcp8MHCeIxaQw/nY1S1uWzX0CYm6maHli5EI
         remD+fdZ3IYGPy7vbwyLNbuUZ3nHRCVhD0L8/8w80aO+NXDVoRW0xTGKIVas7WahUhs6
         SoiwiCUMARjV3d515nN6PCvM/kMelYQlnQwO7JmFk804BeBrH/1Bqg8Kcb2g9rfefmBt
         K6UXMJ6wxUhQ0Gv9hvSBqX/JawYMs01RPFS15foYje7Lb275/w5JEVgk5ucKE0LZraEt
         cSxQ==
X-Gm-Message-State: AOAM531vKeW42umDjNuzIXi5E6irFTypb9nlgRPMCKHa9EVwvzw+vf1q
        k6a/ADBmlbdLWRz0xHO4iNSCexUSut5YIhgOT2DQm9y4kXhsQwqPT5r8c64f5jkuCZS2MUEVhCl
        /nmJx3A2XPakhl0m6YpwAidJNXjTNxCPOifl4lpeAoxWIuUkFumKDYGQyhwEtOv81OQINi0M=
X-Google-Smtp-Source: ABdhPJx0f/Orl6ssEd7UHpXnCPHRVu7z03nPQzsQ2YsGzy1C46oijjKvFmRZzU3PoVc67pFIkFTwxP29//QVCwSYUg==
X-Received: from jgzg.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:1acf])
 (user=jingzhangos job=sendgmr) by 2002:a17:90b:e81:b0:1c6:5a9c:5afa with SMTP
 id fv1-20020a17090b0e8100b001c65a9c5afamr219683pjb.1.1647478600405; Wed, 16
 Mar 2022 17:56:40 -0700 (PDT)
Date:   Thu, 17 Mar 2022 00:56:29 +0000
In-Reply-To: <20220317005630.3666572-1-jingzhangos@google.com>
Message-Id: <20220317005630.3666572-2-jingzhangos@google.com>
Mime-Version: 1.0
References: <20220317005630.3666572-1-jingzhangos@google.com>
X-Mailer: git-send-email 2.35.1.723.g4982287a31-goog
Subject: [PATCH v1 1/2] KVM: arm64: Add arch specific exit reasons
From:   Jing Zhang <jingzhangos@google.com>
To:     KVM <kvm@vger.kernel.org>, KVMARM <kvmarm@lists.cs.columbia.edu>,
        Marc Zyngier <maz@kernel.org>, Will Deacon <will@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>,
        David Matlack <dmatlack@google.com>,
        Sean Christopherson <seanjc@google.com>,
        Oliver Upton <oupton@google.com>,
        Reiji Watanabe <reijiw@google.com>,
        Ricardo Koller <ricarkol@google.com>,
        Raghavendra Rao Ananta <rananta@google.com>
Cc:     Jing Zhang <jingzhangos@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Arch specific exit reasons have been available for other architectures.
Add arch specific exit reason support for ARM64, which would be used in
KVM stats for monitoring VCPU status.

Signed-off-by: Jing Zhang <jingzhangos@google.com>
---
 arch/arm64/include/asm/kvm_emulate.h |  5 +++
 arch/arm64/include/asm/kvm_host.h    | 33 +++++++++++++++
 arch/arm64/kvm/handle_exit.c         | 62 +++++++++++++++++++++++++---
 arch/arm64/kvm/mmu.c                 |  4 ++
 arch/arm64/kvm/sys_regs.c            |  6 +++
 5 files changed, 105 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_emulate.h b/arch/arm64/include/asm/kvm_emulate.h
index d62405ce3e6d..f73c8d900642 100644
--- a/arch/arm64/include/asm/kvm_emulate.h
+++ b/arch/arm64/include/asm/kvm_emulate.h
@@ -321,6 +321,11 @@ static inline bool kvm_vcpu_trap_is_iabt(const struct kvm_vcpu *vcpu)
 	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_IABT_LOW;
 }
 
+static inline bool kvm_vcpu_trap_is_dabt(const struct kvm_vcpu *vcpu)
+{
+	return kvm_vcpu_trap_get_class(vcpu) == ESR_ELx_EC_DABT_LOW;
+}
+
 static inline bool kvm_vcpu_trap_is_exec_fault(const struct kvm_vcpu *vcpu)
 {
 	return kvm_vcpu_trap_is_iabt(vcpu) && !kvm_vcpu_abt_iss1tw(vcpu);
diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
index 76f795b628f1..daa68b053bdc 100644
--- a/arch/arm64/include/asm/kvm_host.h
+++ b/arch/arm64/include/asm/kvm_host.h
@@ -282,6 +282,36 @@ struct vcpu_reset_state {
 	bool		reset;
 };
 
+enum arm_exit_reason {
+	ARM_EXIT_UNKNOWN,
+	ARM_EXIT_IRQ,
+	ARM_EXIT_EL1_SERROR,
+	ARM_EXIT_HYP_GONE,
+	ARM_EXIT_IL,
+	ARM_EXIT_WFI,
+	ARM_EXIT_WFE,
+	ARM_EXIT_CP15_32,
+	ARM_EXIT_CP15_64,
+	ARM_EXIT_CP14_32,
+	ARM_EXIT_CP14_LS,
+	ARM_EXIT_CP14_64,
+	ARM_EXIT_HVC32,
+	ARM_EXIT_SMC32,
+	ARM_EXIT_HVC64,
+	ARM_EXIT_SMC64,
+	ARM_EXIT_SYS64,
+	ARM_EXIT_SVE,
+	ARM_EXIT_IABT_LOW,
+	ARM_EXIT_DABT_LOW,
+	ARM_EXIT_SOFTSTP_LOW,
+	ARM_EXIT_WATCHPT_LOW,
+	ARM_EXIT_BREAKPT_LOW,
+	ARM_EXIT_BKPT32,
+	ARM_EXIT_BRK64,
+	ARM_EXIT_FP_ASIMD,
+	ARM_EXIT_PAC,
+};
+
 struct kvm_vcpu_arch {
 	struct kvm_cpu_context ctxt;
 	void *sve_state;
@@ -382,6 +412,9 @@ struct kvm_vcpu_arch {
 		u64 last_steal;
 		gpa_t base;
 	} steal;
+
+	/* Arch specific exit reason */
+	enum arm_exit_reason exit_reason;
 };
 
 /* Pointer to the vcpu's SVE FFR for sve_{save,load}_state() */
diff --git a/arch/arm64/kvm/handle_exit.c b/arch/arm64/kvm/handle_exit.c
index e3140abd2e2e..cee0edaacded 100644
--- a/arch/arm64/kvm/handle_exit.c
+++ b/arch/arm64/kvm/handle_exit.c
@@ -49,6 +49,18 @@ static int handle_hvc(struct kvm_vcpu *vcpu)
 	return ret;
 }
 
+static int handle_hvc32(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_HVC32;
+	return handle_hvc(vcpu);
+}
+
+static int handle_hvc64(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_HVC64;
+	return handle_hvc(vcpu);
+}
+
 static int handle_smc(struct kvm_vcpu *vcpu)
 {
 	/*
@@ -64,12 +76,25 @@ static int handle_smc(struct kvm_vcpu *vcpu)
 	return 1;
 }
 
+static int handle_smc32(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_SMC32;
+	return handle_smc(vcpu);
+}
+
+static int handle_smc64(struct kvm_vcpu *vcpu)
+{
+	vcpu->arch.exit_reason = ARM_EXIT_SMC64;
+	return handle_smc(vcpu);
+}
+
 /*
  * Guest access to FP/ASIMD registers are routed to this handler only
  * when the system doesn't support FP/ASIMD.
  */
 static int handle_no_fpsimd(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_FP_ASIMD;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -91,11 +116,13 @@ static int kvm_handle_wfx(struct kvm_vcpu *vcpu)
 	if (kvm_vcpu_get_esr(vcpu) & ESR_ELx_WFx_ISS_WFE) {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), true);
 		vcpu->stat.wfe_exit_stat++;
+		vcpu->arch.exit_reason = ARM_EXIT_WFE;
 		kvm_vcpu_on_spin(vcpu, vcpu_mode_priv(vcpu));
 	} else {
 		trace_kvm_wfx_arm64(*vcpu_pc(vcpu), false);
 		vcpu->stat.wfi_exit_stat++;
 		kvm_vcpu_wfi(vcpu);
+		vcpu->arch.exit_reason = ARM_EXIT_WFI;
 	}
 
 	kvm_incr_pc(vcpu);
@@ -118,12 +145,29 @@ static int kvm_handle_guest_debug(struct kvm_vcpu *vcpu)
 {
 	struct kvm_run *run = vcpu->run;
 	u32 esr = kvm_vcpu_get_esr(vcpu);
+	u8 esr_ec = ESR_ELx_EC(esr);
 
 	run->exit_reason = KVM_EXIT_DEBUG;
 	run->debug.arch.hsr = esr;
 
-	if (ESR_ELx_EC(esr) == ESR_ELx_EC_WATCHPT_LOW)
+	switch (esr_ec) {
+	case ESR_ELx_EC_SOFTSTP_LOW:
+		vcpu->arch.exit_reason = ARM_EXIT_SOFTSTP_LOW;
+		break;
+	case ESR_ELx_EC_WATCHPT_LOW:
 		run->debug.arch.far = vcpu->arch.fault.far_el2;
+		vcpu->arch.exit_reason = ARM_EXIT_WATCHPT_LOW;
+		break;
+	case ESR_ELx_EC_BREAKPT_LOW:
+		vcpu->arch.exit_reason = ARM_EXIT_BREAKPT_LOW;
+		break;
+	case ESR_ELx_EC_BKPT32:
+		vcpu->arch.exit_reason = ARM_EXIT_BKPT32;
+		break;
+	case ESR_ELx_EC_BRK64:
+		vcpu->arch.exit_reason = ARM_EXIT_BRK64;
+		break;
+	}
 
 	return 0;
 }
@@ -135,6 +179,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
 	kvm_pr_unimpl("Unknown exception class: esr: %#08x -- %s\n",
 		      esr, esr_get_class_string(esr));
 
+	vcpu->arch.exit_reason = ARM_EXIT_UNKNOWN;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -145,6 +190,7 @@ static int kvm_handle_unknown_ec(struct kvm_vcpu *vcpu)
  */
 static int handle_sve(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_SVE;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -156,6 +202,7 @@ static int handle_sve(struct kvm_vcpu *vcpu)
  */
 static int kvm_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_PAC;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -168,10 +215,10 @@ static exit_handle_fn arm_exit_handlers[] = {
 	[ESR_ELx_EC_CP14_MR]	= kvm_handle_cp14_32,
 	[ESR_ELx_EC_CP14_LS]	= kvm_handle_cp14_load_store,
 	[ESR_ELx_EC_CP14_64]	= kvm_handle_cp14_64,
-	[ESR_ELx_EC_HVC32]	= handle_hvc,
-	[ESR_ELx_EC_SMC32]	= handle_smc,
-	[ESR_ELx_EC_HVC64]	= handle_hvc,
-	[ESR_ELx_EC_SMC64]	= handle_smc,
+	[ESR_ELx_EC_HVC32]	= handle_hvc32,
+	[ESR_ELx_EC_SMC32]	= handle_smc32,
+	[ESR_ELx_EC_HVC64]	= handle_hvc64,
+	[ESR_ELx_EC_SMC64]	= handle_smc64,
 	[ESR_ELx_EC_SYS64]	= kvm_handle_sys_reg,
 	[ESR_ELx_EC_SVE]	= handle_sve,
 	[ESR_ELx_EC_IABT_LOW]	= kvm_handle_guest_abort,
@@ -240,8 +287,10 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 
 	switch (exception_index) {
 	case ARM_EXCEPTION_IRQ:
+		vcpu->arch.exit_reason = ARM_EXIT_IRQ;
 		return 1;
 	case ARM_EXCEPTION_EL1_SERROR:
+		vcpu->arch.exit_reason = ARM_EXIT_EL1_SERROR;
 		return 1;
 	case ARM_EXCEPTION_TRAP:
 		return handle_trap_exceptions(vcpu);
@@ -250,6 +299,7 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 * EL2 has been reset to the hyp-stub. This happens when a guest
 		 * is pre-empted by kvm_reboot()'s shutdown call.
 		 */
+		vcpu->arch.exit_reason = ARM_EXIT_HYP_GONE;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return 0;
 	case ARM_EXCEPTION_IL:
@@ -257,11 +307,13 @@ int handle_exit(struct kvm_vcpu *vcpu, int exception_index)
 		 * We attempted an illegal exception return.  Guest state must
 		 * have been corrupted somehow.  Give up.
 		 */
+		vcpu->arch.exit_reason = ARM_EXIT_IL;
 		run->exit_reason = KVM_EXIT_FAIL_ENTRY;
 		return -EINVAL;
 	default:
 		kvm_pr_unimpl("Unsupported exception type: %d",
 			      exception_index);
+		vcpu->arch.exit_reason = ARM_EXIT_UNKNOWN;
 		run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
 		return 0;
 	}
diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 1623abc56af2..657babe7857c 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -1333,6 +1333,10 @@ int kvm_handle_guest_abort(struct kvm_vcpu *vcpu)
 
 	fault_ipa = kvm_vcpu_get_fault_ipa(vcpu);
 	is_iabt = kvm_vcpu_trap_is_iabt(vcpu);
+	if (is_iabt)
+		vcpu->arch.exit_reason = ARM_EXIT_IABT_LOW;
+	else if (kvm_vcpu_trap_is_dabt(vcpu))
+		vcpu->arch.exit_reason = ARM_EXIT_DABT_LOW;
 
 	/* Synchronous External Abort? */
 	if (kvm_vcpu_abt_issea(vcpu)) {
diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
index dd34b5ab51d4..156b6213b17d 100644
--- a/arch/arm64/kvm/sys_regs.c
+++ b/arch/arm64/kvm/sys_regs.c
@@ -2205,6 +2205,7 @@ static int check_sysreg_table(const struct sys_reg_desc *table, unsigned int n,
 
 int kvm_handle_cp14_load_store(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_LS;
 	kvm_inject_undefined(vcpu);
 	return 1;
 }
@@ -2372,21 +2373,25 @@ static int kvm_handle_cp_32(struct kvm_vcpu *vcpu,
 
 int kvm_handle_cp15_64(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP15_64;
 	return kvm_handle_cp_64(vcpu, cp15_64_regs, ARRAY_SIZE(cp15_64_regs));
 }
 
 int kvm_handle_cp15_32(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP15_32;
 	return kvm_handle_cp_32(vcpu, cp15_regs, ARRAY_SIZE(cp15_regs));
 }
 
 int kvm_handle_cp14_64(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_64;
 	return kvm_handle_cp_64(vcpu, cp14_64_regs, ARRAY_SIZE(cp14_64_regs));
 }
 
 int kvm_handle_cp14_32(struct kvm_vcpu *vcpu)
 {
+	vcpu->arch.exit_reason = ARM_EXIT_CP14_32;
 	return kvm_handle_cp_32(vcpu, cp14_regs, ARRAY_SIZE(cp14_regs));
 }
 
@@ -2444,6 +2449,7 @@ int kvm_handle_sys_reg(struct kvm_vcpu *vcpu)
 	int ret;
 
 	trace_kvm_handle_sys_reg(esr);
+	vcpu->arch.exit_reason = ARM_EXIT_SYS64;
 
 	params = esr_sys64_to_params(esr);
 	params.regval = vcpu_get_reg(vcpu, Rt);
-- 
2.35.1.723.g4982287a31-goog

