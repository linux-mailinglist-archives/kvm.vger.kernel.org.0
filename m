Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B033417591
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345963AbhIXNZp (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346079AbhIXNZB (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:25:01 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7A43C0612AB
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:50 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id e8-20020a0cf348000000b0037a350958f2so30929693qvm.7
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ah9gXDd6fJvOzz9kx2O2leuWRmK2UF+FaL+3WFxvTJ8=;
        b=VWQcPIt1vlcNarP43ow3DnD94RzA9qM31BLx/7ufU7rLlWKPLscbJUa1hwytIvKECH
         KyGv1/cyYZsNUp9XXYgMuaT4w7wRqyZE7Xvr9gKadfTjAGm2B3nnm29Lrhl4Hc93kE0D
         +ntHaq8stYGqAO/6okY/E+mBNRenkNvqh244JfNr3K1Rc2gURhFJjsUO3h5RHXIHv1b4
         8rkalsaPpIIU8Yd5QdW9R93ZSOemAGnVlhMTDGw+ZPnykoTrW8jBQ4FokcJo3BvXf2xL
         hJEk/ZFdtu2bW35QN2sNABKsx62NpxxXmJsrGk8eO6dl3UOR2lzX34pgJUTeLH59Smjp
         Lr4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ah9gXDd6fJvOzz9kx2O2leuWRmK2UF+FaL+3WFxvTJ8=;
        b=aCwgpau1gQr2y3rexaV0OX/JGIGj0+nyUXiGHivIFrMgdxQ99aYkuf7rzNOFWF3uPr
         o6V4y+WMBzZTiwvRHf4HFQi5yZCWWMU7qFzcMQayTLwzWsYR68EpqaScLdy1zRoHaS+T
         Vj/IM1xS/3cUx7mPRi3IBiFQT91pl2vO2XlaCbvSnIipkam+H7Q0bHn1U7qqikHWAAOE
         bmTsfeOScE3dAmDpxMYRFYXuoRsngBwCoDvUy/ON+MvxkCliLwPlAT6iBhMHUJnj88Bk
         PDTdWv+Q3JUbck/8zviFYPjaJrGn1n7ArY2Yx620WsPw2JoMRcGc7lLUUfoLeHT4hNa6
         3YsA==
X-Gm-Message-State: AOAM531FGTMswtEI1qRx8J34qXmu6IB/YJrrFzlOd0Hdl3CqBJbD2U6g
        pQ3yLfitC6NcyDdOi3i0WCbeph5b9w==
X-Google-Smtp-Source: ABdhPJx0MGh1esHygyGmugyNFtFbLjJ17xcPDf/Zl3jsEQ9VM2CtXd7GdNQW4w6TBVnK0kcjEDJ2MCAADA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a0c:914f:: with SMTP id q73mr9847672qvq.39.1632488089835;
 Fri, 24 Sep 2021 05:54:49 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:52 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-24-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 23/30] KVM: arm64: COCCI: remove_unused.cocci: remove
 unused ctxt and hypstate variables
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

These local variables were added aggressively. Remove the ones
that ended up not being used. Also, some of the added variables
are missing a new line after their definition. Insert that for
the remaining ones.

This applies the semantic patch with the following command:
spatch --sp-file cocci_refactor/remove_unused.cocci --dir arch/arm64/kvm/hyp --in-place --include-headers --force-diff

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/exception.c             | 5 -----
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 9 ++++-----
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 2 ++
 arch/arm64/kvm/hyp/nvhe/switch.c           | 1 -
 arch/arm64/kvm/hyp/vhe/switch.c            | 3 ---
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         | 3 ---
 6 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index a08806efe031..bb0bc1f5568c 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -59,31 +59,26 @@ static void __ctxt_write_spsr_und(struct kvm_cpu_context *vcpu_ctxt, u64 val)
 
 static inline u64 __vcpu_read_sys_reg(const struct kvm_vcpu *vcpu, int reg)
 {
-	const struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	return __ctxt_read_sys_reg(&vcpu_ctxt(vcpu), reg);
 }
 
 static inline void __vcpu_write_sys_reg(struct kvm_vcpu *vcpu, u64 val, int reg)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_sys_reg(&vcpu_ctxt(vcpu), val, reg);
 }
 
 static void __vcpu_write_spsr(struct kvm_vcpu *vcpu, u64 val)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_spsr(&vcpu_ctxt(vcpu), val);
 }
 
 static void __vcpu_write_spsr_abt(struct kvm_vcpu *vcpu, u64 val)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_spsr_abt(&vcpu_ctxt(vcpu), val);
 }
 
 static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	__ctxt_write_spsr_und(&vcpu_ctxt(vcpu), val);
 }
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 44e76993a9b4..433601f79b94 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -37,6 +37,7 @@ extern struct exception_table_entry __stop___kvm_ex_table;
 static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
+
 	/*
 	 * When the system doesn't support FP/SIMD, we cannot rely on
 	 * the _TIF_FOREIGN_FPSTATE flag. However, we always inject an
@@ -55,8 +56,8 @@ static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
@@ -65,8 +66,6 @@ static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 
 static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	/*
 	 * We are about to set CPTR_EL2.TFP to trap all floating point
 	 * register accesses to EL2, however, the ARM ARM clearly states that
@@ -220,8 +219,8 @@ static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
 			    &ctxt_fp_regs(vcpu_ctxt)->fpsr);
@@ -395,7 +394,6 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *ctxt;
 	u64 val;
 
@@ -428,6 +426,7 @@ static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, struct vgic_dist *vgi
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		hyp_state_fault(vcpu_hyps).esr_el2 = read_sysreg_el2(SYS_ESR);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index df9cd2177e71..b750ff40a604 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -160,6 +160,7 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
@@ -179,6 +180,7 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
 	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index d9a69e66158c..b90ec8db5864 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -37,7 +37,6 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val;
 
 	___activate_traps(vcpu_hyps);
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index 5039910a7c80..7f926016cebe 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -34,7 +34,6 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val;
 
 	___activate_traps(vcpu_hyps);
@@ -168,8 +167,6 @@ NOKPROBE_SYMBOL(__kvm_vcpu_run_vhe);
 
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int ret;
 
 	local_daif_mask();
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 1571c144e9b0..1ded8be83c5a 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -64,7 +64,6 @@ NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
@@ -99,8 +98,6 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 {
-	struct vcpu_hyp_state *vcpu_hyps = &hyp_state(vcpu);
-	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-- 
2.33.0.685.g46640cef36-goog

