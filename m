Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43C9A417582
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345444AbhIXNZT (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344885AbhIXNYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:52 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E6FC08EAF1
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:17 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id h4-20020a05620a244400b004334ede5036so31806808qkn.13
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F9WSvqQOfeqKzN2mfHECw3MDDtOFEm1amOCByz9riQE=;
        b=JRSKYLTOLSlmbQC3xeCnfYXH/BoVevCDKh9zuwXD8mBoe2ClKe1e/8DarBLh1KSTEL
         /SWP7ZB1s+omW/axGl+xSpdjcvqr9Mg9Yhu0b5to+SHqSoroNuCbXF9/kLlXJP64rFY7
         PHyphaJQYjA0v3AH/APFk1cse6NCxyDfKg8biAiG9a6lNpflN77vnneb/ZDBjkDlY3+n
         57bNJdFXgPfV7PMBIfylZoPIVLNcfBsAMVoocxyhLH4iWhYBYa7Zv4S51fFolY8H2EnP
         vSWKfmqN0jWKuB05qpa2axsQ6HoAviNloRqaokrucxkdlLXeGtmBnk0M2QzXMGkDzbRv
         Posg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F9WSvqQOfeqKzN2mfHECw3MDDtOFEm1amOCByz9riQE=;
        b=byV1fQTtVakqnOov/UblJxHzBRB91NtZKP2FL52ioBJ+TD3+8XjILPYwz3OaAvIcww
         lSNy2Fi3DfFq7Vm2dDgP0MvA4od6wE8ksCnwS6szXcZnGA0eD4PhD811/UJeUsDjiCS5
         FWipCLSXxC18nAmtvEluD8kZuZz0mKo4C7HHgjdAPsscEozSlm6WSVMYs3cNRzhjgmlF
         jp64H+TRjuo07SFqaFXlQE0GvzH5r1o3u3BaYGghxotuxQ0y1IWTluhV63PLgRe5IBOL
         vCkRy0YG39AvEa0PlD0D0CQrUdCITfEbLJ0w6d7Kzp4wA18wbJhxnNK02GwQ9Fdq+kIj
         JQ0Q==
X-Gm-Message-State: AOAM531juP659/U9oX9lgsd9BiyI5CTWaFZnSi2DXhtF3OguIzJRGnAV
        fR8VBpb9lQRoIwsgiEXzVQo5LGTonw==
X-Google-Smtp-Source: ABdhPJzUWtZc/ZGxRp4tbOMCu9NgC5hX7NyatmZoJbF1+qyb4Xq+KhMmWovyMdQyBstF4WdRB2SBHxWS9A==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:6214:1427:: with SMTP id
 o7mr427893qvx.45.1632488056707; Fri, 24 Sep 2021 05:54:16 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:36 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-8-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 07/30] KVM: arm64: COCCI: add_ctxt.cocci
 use_ctxt.cocci: reduce scope of functions to kvm_cpu_ctxt
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
the kvm_cpu_ctxt. Reduce their scope.

This applies the semantic patches with the following commands:
spatch --sp-file cocci_refactor/add_ctxt.cocci --dir arch/arm64/kvm/hyp --ignore arch/arm64/kvm/hyp/nvhe/debug-sr.c --ignore arch/arm64/kvm/hyp/vhe/debug-sr.c --include-headers --in-place
spatch --sp-file cocci_refactor/use_ctxt.cocci  --dir arch/arm64/kvm/hyp --include-headers  --in-place
spatch --sp-file cocci_refactor/use_ctxt.cocci  --dir arch/arm64/kvm/hyp --include-headers  --in-place

This patch adds variables that may be unused. These will be
removed at the end of this patch series.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/hyp/aarch32.c               | 18 +++---
 arch/arm64/kvm/hyp/exception.c             | 60 ++++++++++--------
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h | 18 +++---
 arch/arm64/kvm/hyp/include/hyp/switch.h    | 20 ++++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 31 +++++-----
 arch/arm64/kvm/hyp/nvhe/switch.c           |  5 ++
 arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c   | 13 ++--
 arch/arm64/kvm/hyp/vgic-v3-sr.c            | 71 +++++++++++++++-------
 arch/arm64/kvm/hyp/vhe/switch.c            |  7 +++
 arch/arm64/kvm/hyp/vhe/sysreg-sr.c         |  2 +
 10 files changed, 155 insertions(+), 90 deletions(-)

diff --git a/arch/arm64/kvm/hyp/aarch32.c b/arch/arm64/kvm/hyp/aarch32.c
index f98cbe2626a1..27ebfff023ff 100644
--- a/arch/arm64/kvm/hyp/aarch32.c
+++ b/arch/arm64/kvm/hyp/aarch32.c
@@ -46,6 +46,7 @@ static const unsigned short cc_map[16] = {
  */
 bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 {
+	const struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	unsigned long cpsr;
 	u32 cpsr_cond;
 	int cond;
@@ -59,7 +60,7 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
 	if (cond == 0xE)
 		return true;
 
-	cpsr = *vcpu_cpsr(vcpu);
+	cpsr = *ctxt_cpsr(vcpu_ctxt);
 
 	if (cond < 0) {
 		/* This can happen in Thumb mode: examine IT state. */
@@ -93,10 +94,10 @@ bool kvm_condition_valid32(const struct kvm_vcpu *vcpu)
  *
  * IT[7:0] -> CPSR[26:25],CPSR[15:10]
  */
-static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
+static void kvm_adjust_itstate(struct kvm_cpu_context *vcpu_ctxt)
 {
 	unsigned long itbits, cond;
-	unsigned long cpsr = *vcpu_cpsr(vcpu);
+	unsigned long cpsr = *ctxt_cpsr(vcpu_ctxt);
 	bool is_arm = !(cpsr & PSR_AA32_T_BIT);
 
 	if (is_arm || !(cpsr & PSR_AA32_IT_MASK))
@@ -116,7 +117,7 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
 	cpsr |= cond << 13;
 	cpsr |= (itbits & 0x1c) << (10 - 2);
 	cpsr |= (itbits & 0x3) << 25;
-	*vcpu_cpsr(vcpu) = cpsr;
+	*ctxt_cpsr(vcpu_ctxt) = cpsr;
 }
 
 /**
@@ -125,16 +126,17 @@ static void kvm_adjust_itstate(struct kvm_vcpu *vcpu)
  */
 void kvm_skip_instr32(struct kvm_vcpu *vcpu)
 {
-	u32 pc = *vcpu_pc(vcpu);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u32 pc = *ctxt_pc(vcpu_ctxt);
 	bool is_thumb;
 
-	is_thumb = !!(*vcpu_cpsr(vcpu) & PSR_AA32_T_BIT);
+	is_thumb = !!(*ctxt_cpsr(vcpu_ctxt) & PSR_AA32_T_BIT);
 	if (is_thumb && !kvm_vcpu_trap_il_is32bit(vcpu))
 		pc += 2;
 	else
 		pc += 4;
 
-	*vcpu_pc(vcpu) = pc;
+	*ctxt_pc(vcpu_ctxt) = pc;
 
-	kvm_adjust_itstate(vcpu);
+	kvm_adjust_itstate(vcpu_ctxt);
 }
diff --git a/arch/arm64/kvm/hyp/exception.c b/arch/arm64/kvm/hyp/exception.c
index 643c5844f684..e23b9cedb043 100644
--- a/arch/arm64/kvm/hyp/exception.c
+++ b/arch/arm64/kvm/hyp/exception.c
@@ -99,13 +99,14 @@ static void __vcpu_write_spsr_und(struct kvm_vcpu *vcpu, u64 val)
  * Here we manipulate the fields in order of the AArch64 SPSR_ELx layout, from
  * MSB to LSB.
  */
-static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
+static void enter_exception64(struct kvm_cpu_context *vcpu_ctxt,
+			      unsigned long target_mode,
 			      enum exception_type type)
 {
 	unsigned long sctlr, vbar, old, new, mode;
 	u64 exc_offset;
 
-	mode = *vcpu_cpsr(vcpu) & (PSR_MODE_MASK | PSR_MODE32_BIT);
+	mode = *ctxt_cpsr(vcpu_ctxt) & (PSR_MODE_MASK | PSR_MODE32_BIT);
 
 	if      (mode == target_mode)
 		exc_offset = CURRENT_EL_SP_ELx_VECTOR;
@@ -118,18 +119,18 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 
 	switch (target_mode) {
 	case PSR_MODE_EL1h:
-		vbar = __vcpu_read_sys_reg(vcpu, VBAR_EL1);
-		sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
-		__vcpu_write_sys_reg(vcpu, *vcpu_pc(vcpu), ELR_EL1);
+		vbar = __ctxt_read_sys_reg(vcpu_ctxt, VBAR_EL1);
+		sctlr = __ctxt_read_sys_reg(vcpu_ctxt, SCTLR_EL1);
+		__ctxt_write_sys_reg(vcpu_ctxt, *ctxt_pc(vcpu_ctxt), ELR_EL1);
 		break;
 	default:
 		/* Don't do that */
 		BUG();
 	}
 
-	*vcpu_pc(vcpu) = vbar + exc_offset + type;
+	*ctxt_pc(vcpu_ctxt) = vbar + exc_offset + type;
 
-	old = *vcpu_cpsr(vcpu);
+	old = *ctxt_cpsr(vcpu_ctxt);
 	new = 0;
 
 	new |= (old & PSR_N_BIT);
@@ -172,8 +173,8 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
 
 	new |= target_mode;
 
-	*vcpu_cpsr(vcpu) = new;
-	__vcpu_write_spsr(vcpu, old);
+	*ctxt_cpsr(vcpu_ctxt) = new;
+	__ctxt_write_spsr(vcpu_ctxt, old);
 }
 
 /*
@@ -194,12 +195,13 @@ static void enter_exception64(struct kvm_vcpu *vcpu, unsigned long target_mode,
  * Here we manipulate the fields in order of the AArch32 SPSR_ELx layout, from
  * MSB to LSB.
  */
-static unsigned long get_except32_cpsr(struct kvm_vcpu *vcpu, u32 mode)
+static unsigned long get_except32_cpsr(struct kvm_cpu_context *vcpu_ctxt,
+				       u32 mode)
 {
-	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	u32 sctlr = __ctxt_read_sys_reg(vcpu_ctxt, SCTLR_EL1);
 	unsigned long old, new;
 
-	old = *vcpu_cpsr(vcpu);
+	old = *ctxt_cpsr(vcpu_ctxt);
 	new = 0;
 
 	new |= (old & PSR_AA32_N_BIT);
@@ -288,27 +290,28 @@ static const u8 return_offsets[8][2] = {
 	[7] = { 4, 4 },		/* FIQ, unused */
 };
 
-static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
+static void enter_exception32(struct kvm_cpu_context *vcpu_ctxt, u32 mode,
+			      u32 vect_offset)
 {
-	unsigned long spsr = *vcpu_cpsr(vcpu);
+	unsigned long spsr = *ctxt_cpsr(vcpu_ctxt);
 	bool is_thumb = (spsr & PSR_AA32_T_BIT);
-	u32 sctlr = __vcpu_read_sys_reg(vcpu, SCTLR_EL1);
+	u32 sctlr = __ctxt_read_sys_reg(vcpu_ctxt, SCTLR_EL1);
 	u32 return_address;
 
-	*vcpu_cpsr(vcpu) = get_except32_cpsr(vcpu, mode);
-	return_address   = *vcpu_pc(vcpu);
+	*ctxt_cpsr(vcpu_ctxt) = get_except32_cpsr(vcpu_ctxt, mode);
+	return_address   = *ctxt_pc(vcpu_ctxt);
 	return_address  += return_offsets[vect_offset >> 2][is_thumb];
 
 	/* KVM only enters the ABT and UND modes, so only deal with those */
 	switch(mode) {
 	case PSR_AA32_MODE_ABT:
-		__vcpu_write_spsr_abt(vcpu, host_spsr_to_spsr32(spsr));
-		vcpu_gp_regs(vcpu)->compat_lr_abt = return_address;
+		__ctxt_write_spsr_abt(vcpu_ctxt, host_spsr_to_spsr32(spsr));
+		ctxt_gp_regs(vcpu_ctxt)->compat_lr_abt = return_address;
 		break;
 
 	case PSR_AA32_MODE_UND:
-		__vcpu_write_spsr_und(vcpu, host_spsr_to_spsr32(spsr));
-		vcpu_gp_regs(vcpu)->compat_lr_und = return_address;
+		__ctxt_write_spsr_und(vcpu_ctxt, host_spsr_to_spsr32(spsr));
+		ctxt_gp_regs(vcpu_ctxt)->compat_lr_und = return_address;
 		break;
 	}
 
@@ -316,23 +319,24 @@ static void enter_exception32(struct kvm_vcpu *vcpu, u32 mode, u32 vect_offset)
 	if (sctlr & (1 << 13))
 		vect_offset += 0xffff0000;
 	else /* always have security exceptions */
-		vect_offset += __vcpu_read_sys_reg(vcpu, VBAR_EL1);
+		vect_offset += __ctxt_read_sys_reg(vcpu_ctxt, VBAR_EL1);
 
-	*vcpu_pc(vcpu) = vect_offset;
+	*ctxt_pc(vcpu_ctxt) = vect_offset;
 }
 
 static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (vcpu_el1_is_32bit(vcpu)) {
 		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
 		case KVM_ARM64_EXCEPT_AA32_UND:
-			enter_exception32(vcpu, PSR_AA32_MODE_UND, 4);
+			enter_exception32(vcpu_ctxt, PSR_AA32_MODE_UND, 4);
 			break;
 		case KVM_ARM64_EXCEPT_AA32_IABT:
-			enter_exception32(vcpu, PSR_AA32_MODE_ABT, 12);
+			enter_exception32(vcpu_ctxt, PSR_AA32_MODE_ABT, 12);
 			break;
 		case KVM_ARM64_EXCEPT_AA32_DABT:
-			enter_exception32(vcpu, PSR_AA32_MODE_ABT, 16);
+			enter_exception32(vcpu_ctxt, PSR_AA32_MODE_ABT, 16);
 			break;
 		default:
 			/* Err... */
@@ -342,7 +346,8 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
 		switch (vcpu->arch.flags & KVM_ARM64_EXCEPT_MASK) {
 		case (KVM_ARM64_EXCEPT_AA64_ELx_SYNC |
 		      KVM_ARM64_EXCEPT_AA64_EL1):
-			enter_exception64(vcpu, PSR_MODE_EL1h, except_type_sync);
+			enter_exception64(vcpu_ctxt, PSR_MODE_EL1h,
+					  except_type_sync);
 			break;
 		default:
 			/*
@@ -361,6 +366,7 @@ static void kvm_inject_exception(struct kvm_vcpu *vcpu)
  */
 void __kvm_adjust_pc(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (vcpu->arch.flags & KVM_ARM64_PENDING_EXCEPTION) {
 		kvm_inject_exception(vcpu);
 		vcpu->arch.flags &= ~(KVM_ARM64_PENDING_EXCEPTION |
diff --git a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
index 4fdfeabefeb4..20dde9dbc11b 100644
--- a/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
+++ b/arch/arm64/kvm/hyp/include/hyp/adjust_pc.h
@@ -15,15 +15,16 @@
 
 static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
-	if (vcpu_mode_is_32bit(vcpu)) {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
 		kvm_skip_instr32(vcpu);
 	} else {
-		*vcpu_pc(vcpu) += 4;
-		*vcpu_cpsr(vcpu) &= ~PSR_BTYPE_MASK;
+		*ctxt_pc(vcpu_ctxt) += 4;
+		*ctxt_cpsr(vcpu_ctxt) &= ~PSR_BTYPE_MASK;
 	}
 
 	/* advance the singlestep state machine */
-	*vcpu_cpsr(vcpu) &= ~DBG_SPSR_SS;
+	*ctxt_cpsr(vcpu_ctxt) &= ~DBG_SPSR_SS;
 }
 
 /*
@@ -32,13 +33,14 @@ static inline void kvm_skip_instr(struct kvm_vcpu *vcpu)
  */
 static inline void __kvm_skip_instr(struct kvm_vcpu *vcpu)
 {
-	*vcpu_pc(vcpu) = read_sysreg_el2(SYS_ELR);
-	vcpu_gp_regs(vcpu)->pstate = read_sysreg_el2(SYS_SPSR);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	*ctxt_pc(vcpu_ctxt) = read_sysreg_el2(SYS_ELR);
+	ctxt_gp_regs(vcpu_ctxt)->pstate = read_sysreg_el2(SYS_SPSR);
 
 	kvm_skip_instr(vcpu);
 
-	write_sysreg_el2(vcpu_gp_regs(vcpu)->pstate, SYS_SPSR);
-	write_sysreg_el2(*vcpu_pc(vcpu), SYS_ELR);
+	write_sysreg_el2(ctxt_gp_regs(vcpu_ctxt)->pstate, SYS_SPSR);
+	write_sysreg_el2(*ctxt_pc(vcpu_ctxt), SYS_ELR);
 }
 
 /*
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index 9fa9cf71eefa..41c553a7b5dd 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -54,14 +54,16 @@ static inline bool update_fp_enabled(struct kvm_vcpu *vcpu)
 /* Save the 32-bit only FPSIMD system register state */
 static inline void __fpsimd_save_fpexc32(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	__vcpu_sys_reg(vcpu, FPEXC32_EL2) = read_sysreg(fpexc32_el2);
+	ctxt_sys_reg(vcpu_ctxt, FPEXC32_EL2) = read_sysreg(fpexc32_el2);
 }
 
 static inline void __activate_traps_fpsimd32(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	/*
 	 * We are about to set CPTR_EL2.TFP to trap all floating point
 	 * register accesses to EL2, however, the ARM ARM clearly states that
@@ -215,15 +217,17 @@ static inline void __hyp_sve_save_host(struct kvm_vcpu *vcpu)
 
 static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    &vcpu_fp_regs(vcpu)->fpsr);
-	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
+			    &ctxt_fp_regs(vcpu_ctxt)->fpsr);
+	write_sysreg_el1(ctxt_sys_reg(vcpu_ctxt, ZCR_EL1), SYS_ZCR);
 }
 
 /* Check for an FPSIMD/SVE trap and handle as appropriate */
 static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	bool sve_guest, sve_host;
 	u8 esr_ec;
 	u64 reg;
@@ -276,11 +280,12 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
 	else
-		__fpsimd_restore_state(vcpu_fp_regs(vcpu));
+		__fpsimd_restore_state(ctxt_fp_regs(vcpu_ctxt));
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
-		write_sysreg(__vcpu_sys_reg(vcpu, FPEXC32_EL2), fpexc32_el2);
+		write_sysreg(ctxt_sys_reg(vcpu_ctxt, FPEXC32_EL2),
+			     fpexc32_el2);
 
 	vcpu->arch.flags |= KVM_ARM64_FP_ENABLED;
 
@@ -289,9 +294,10 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 
 static inline bool handle_tx2_tvm(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
 	int rt = kvm_vcpu_sys_get_rt(vcpu);
-	u64 val = vcpu_get_reg(vcpu, rt);
+	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	/*
 	 * The normal sysreg handling code expects to see the traps,
@@ -382,6 +388,7 @@ DECLARE_PER_CPU(struct kvm_cpu_context, kvm_hyp_ctxt);
 
 static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *ctxt;
 	u64 val;
 
@@ -412,6 +419,7 @@ static inline bool __hyp_handle_ptrauth(struct kvm_vcpu *vcpu)
  */
 static inline bool fixup_guest_exit(struct kvm_vcpu *vcpu, u64 *exit_code)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (ARM_EXCEPTION_CODE(*exit_code) != ARM_EXCEPTION_IRQ)
 		vcpu->arch.fault.esr_el2 = read_sysreg_el2(SYS_ESR);
 
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index 9451206f512e..c2668b85b67e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -158,36 +158,39 @@ static inline void __sysreg_restore_el2_return_state(struct kvm_cpu_context *ctx
 
 static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	*vcpu_spsr_abt(vcpu) = read_sysreg(spsr_abt);
-	*vcpu_spsr_und(vcpu) = read_sysreg(spsr_und);
-	*vcpu_spsr_irq(vcpu) = read_sysreg(spsr_irq);
-	*vcpu_spsr_fiq(vcpu) = read_sysreg(spsr_fiq);
+	*ctxt_spsr_abt(vcpu_ctxt) = read_sysreg(spsr_abt);
+	*ctxt_spsr_und(vcpu_ctxt) = read_sysreg(spsr_und);
+	*ctxt_spsr_irq(vcpu_ctxt) = read_sysreg(spsr_irq);
+	*ctxt_spsr_fiq(vcpu_ctxt) = read_sysreg(spsr_fiq);
 
-	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
-	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
+	ctxt_sys_reg(vcpu_ctxt, DACR32_EL2) = read_sysreg(dacr32_el2);
+	ctxt_sys_reg(vcpu_ctxt, IFSR32_EL2) = read_sysreg(ifsr32_el2);
 
 	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
-		__vcpu_sys_reg(vcpu, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
+		ctxt_sys_reg(vcpu_ctxt, DBGVCR32_EL2) = read_sysreg(dbgvcr32_el2);
 }
 
 static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	write_sysreg(*vcpu_spsr_abt(vcpu), spsr_abt);
-	write_sysreg(*vcpu_spsr_und(vcpu), spsr_und);
-	write_sysreg(*vcpu_spsr_irq(vcpu), spsr_irq);
-	write_sysreg(*vcpu_spsr_fiq(vcpu), spsr_fiq);
+	write_sysreg(*ctxt_spsr_abt(vcpu_ctxt), spsr_abt);
+	write_sysreg(*ctxt_spsr_und(vcpu_ctxt), spsr_und);
+	write_sysreg(*ctxt_spsr_irq(vcpu_ctxt), spsr_irq);
+	write_sysreg(*ctxt_spsr_fiq(vcpu_ctxt), spsr_fiq);
 
-	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
-	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
+	write_sysreg(ctxt_sys_reg(vcpu_ctxt, DACR32_EL2), dacr32_el2);
+	write_sysreg(ctxt_sys_reg(vcpu_ctxt, IFSR32_EL2), ifsr32_el2);
 
 	if (has_vhe() || vcpu->arch.flags & KVM_ARM64_DEBUG_DIRTY)
-		write_sysreg(__vcpu_sys_reg(vcpu, DBGVCR32_EL2), dbgvcr32_el2);
+		write_sysreg(ctxt_sys_reg(vcpu_ctxt, DBGVCR32_EL2),
+		             dbgvcr32_el2);
 }
 
 #endif /* __ARM64_KVM_HYP_SYSREG_SR_H__ */
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index 9296d7108f93..d5780acab6c2 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -36,6 +36,7 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val;
 
 	___activate_traps(vcpu);
@@ -68,6 +69,7 @@ static void __activate_traps(struct kvm_vcpu *vcpu)
 
 static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	extern char __kvm_hyp_host_vector[];
 	u64 mdcr_el2, cptr;
 
@@ -168,6 +170,7 @@ static void __pmu_switch_to_host(struct kvm_cpu_context *host_ctxt)
 /* Switch to the guest for legacy non-VHE systems */
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	bool pmu_switch_needed;
@@ -267,9 +270,11 @@ void __noreturn hyp_panic(void)
 	u64 par = read_sysreg_par();
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
+	struct kvm_cpu_context *vcpu_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	vcpu = host_ctxt->__hyp_running_vcpu;
+	vcpu_ctxt = &vcpu_ctxt(vcpu);
 
 	if (vcpu) {
 		__timer_disable_traps();
diff --git a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
index 87a54375bd6e..8dbc39026cc5 100644
--- a/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
+++ b/arch/arm64/kvm/hyp/vgic-v2-cpuif-proxy.c
@@ -15,9 +15,9 @@
 #include <asm/kvm_hyp.h>
 #include <asm/kvm_mmu.h>
 
-static bool __is_be(struct kvm_vcpu *vcpu)
+static bool __is_be(struct kvm_cpu_context *vcpu_ctxt)
 {
-	if (vcpu_mode_is_32bit(vcpu))
+	if (ctxt_mode_is_32bit(vcpu_ctxt))
 		return !!(read_sysreg_el2(SYS_SPSR) & PSR_AA32_E_BIT);
 
 	return !!(read_sysreg(SCTLR_EL1) & SCTLR_ELx_EE);
@@ -36,6 +36,7 @@ static bool __is_be(struct kvm_vcpu *vcpu)
  */
 int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm *kvm = kern_hyp_va(vcpu->kvm);
 	struct vgic_dist *vgic = &kvm->arch.vgic;
 	phys_addr_t fault_ipa;
@@ -68,19 +69,19 @@ int __vgic_v2_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	addr += fault_ipa - vgic->vgic_cpu_base;
 
 	if (kvm_vcpu_dabt_iswrite(vcpu)) {
-		u32 data = vcpu_get_reg(vcpu, rd);
-		if (__is_be(vcpu)) {
+		u32 data = ctxt_get_reg(vcpu_ctxt, rd);
+		if (__is_be(vcpu_ctxt)) {
 			/* guest pre-swabbed data, undo this for writel() */
 			data = __kvm_swab32(data);
 		}
 		writel_relaxed(data, addr);
 	} else {
 		u32 data = readl_relaxed(addr);
-		if (__is_be(vcpu)) {
+		if (__is_be(vcpu_ctxt)) {
 			/* guest expects swabbed data */
 			data = __kvm_swab32(data);
 		}
-		vcpu_set_reg(vcpu, rd, data);
+		ctxt_set_reg(vcpu_ctxt, rd, data);
 	}
 
 	__kvm_skip_instr(vcpu);
diff --git a/arch/arm64/kvm/hyp/vgic-v3-sr.c b/arch/arm64/kvm/hyp/vgic-v3-sr.c
index 39f8f7f9227c..bdb03b8e50ab 100644
--- a/arch/arm64/kvm/hyp/vgic-v3-sr.c
+++ b/arch/arm64/kvm/hyp/vgic-v3-sr.c
@@ -473,6 +473,7 @@ static int __vgic_v3_bpr_min(void)
 
 static int __vgic_v3_get_group(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 esr = kvm_vcpu_get_esr(vcpu);
 	u8 crm = (esr & ESR_ELx_SYS64_ISS_CRM_MASK) >> ESR_ELx_SYS64_ISS_CRM_SHIFT;
 
@@ -673,6 +674,7 @@ static int __vgic_v3_clear_highest_active_priority(void)
 
 static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 lr_val;
 	u8 lr_prio, pmr;
 	int lr, grp;
@@ -700,11 +702,11 @@ static void __vgic_v3_read_iar(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 		lr_val |= ICH_LR_ACTIVE_BIT;
 	__gic_v3_set_lr(lr_val, lr);
 	__vgic_v3_set_active_priority(lr_prio, vmcr, grp);
-	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
+	ctxt_set_reg(vcpu_ctxt, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
 	return;
 
 spurious:
-	vcpu_set_reg(vcpu, rt, ICC_IAR1_EL1_SPURIOUS);
+	ctxt_set_reg(vcpu_ctxt, rt, ICC_IAR1_EL1_SPURIOUS);
 }
 
 static void __vgic_v3_clear_active_lr(int lr, u64 lr_val)
@@ -731,7 +733,8 @@ static void __vgic_v3_bump_eoicount(void)
 
 static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u32 vid = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u32 vid = ctxt_get_reg(vcpu_ctxt, rt);
 	u64 lr_val;
 	int lr;
 
@@ -754,7 +757,8 @@ static void __vgic_v3_write_dir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u32 vid = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u32 vid = ctxt_get_reg(vcpu_ctxt, rt);
 	u64 lr_val;
 	u8 lr_prio, act_prio;
 	int lr, grp;
@@ -791,17 +795,20 @@ static void __vgic_v3_write_eoir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	ctxt_set_reg(vcpu_ctxt, rt, !!(vmcr & ICH_VMCR_ENG0_MASK));
 }
 
 static void __vgic_v3_read_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vcpu_set_reg(vcpu, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	ctxt_set_reg(vcpu_ctxt, rt, !!(vmcr & ICH_VMCR_ENG1_MASK));
 }
 
 static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u64 val = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	if (val & 1)
 		vmcr |= ICH_VMCR_ENG0_MASK;
@@ -813,7 +820,8 @@ static void __vgic_v3_write_igrpen0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u64 val = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	if (val & 1)
 		vmcr |= ICH_VMCR_ENG1_MASK;
@@ -825,17 +833,20 @@ static void __vgic_v3_write_igrpen1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr0(vmcr));
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	ctxt_set_reg(vcpu_ctxt, rt, __vgic_v3_get_bpr0(vmcr));
 }
 
 static void __vgic_v3_read_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	vcpu_set_reg(vcpu, rt, __vgic_v3_get_bpr1(vmcr));
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	ctxt_set_reg(vcpu_ctxt, rt, __vgic_v3_get_bpr1(vmcr));
 }
 
 static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u64 val = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 	u8 bpr_min = __vgic_v3_bpr_min() - 1;
 
 	/* Enforce BPR limiting */
@@ -852,7 +863,8 @@ static void __vgic_v3_write_bpr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u64 val = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u64 val = ctxt_get_reg(vcpu_ctxt, rt);
 	u8 bpr_min = __vgic_v3_bpr_min();
 
 	if (vmcr & ICH_VMCR_CBPR_MASK)
@@ -872,6 +884,7 @@ static void __vgic_v3_write_bpr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val;
 
 	if (!__vgic_v3_get_group(vcpu))
@@ -879,12 +892,13 @@ static void __vgic_v3_read_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 	else
 		val = __vgic_v3_read_ap1rn(n);
 
-	vcpu_set_reg(vcpu, rt, val);
+	ctxt_set_reg(vcpu_ctxt, rt, val);
 }
 
 static void __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 {
-	u32 val = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	if (!__vgic_v3_get_group(vcpu))
 		__vgic_v3_write_ap0rn(val, n);
@@ -895,47 +909,56 @@ static void __vgic_v3_write_apxrn(struct kvm_vcpu *vcpu, int rt, int n)
 static void __vgic_v3_read_apxr0(struct kvm_vcpu *vcpu,
 					    u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 0);
 }
 
 static void __vgic_v3_read_apxr1(struct kvm_vcpu *vcpu,
 					    u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 1);
 }
 
 static void __vgic_v3_read_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 2);
 }
 
 static void __vgic_v3_read_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_read_apxrn(vcpu, rt, 3);
 }
 
 static void __vgic_v3_write_apxr0(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 0);
 }
 
 static void __vgic_v3_write_apxr1(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 1);
 }
 
 static void __vgic_v3_write_apxr2(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 2);
 }
 
 static void __vgic_v3_write_apxr3(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__vgic_v3_write_apxrn(vcpu, rt, 3);
 }
 
 static void __vgic_v3_read_hppir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 lr_val;
 	int lr, lr_grp, grp;
 
@@ -950,19 +973,21 @@ static void __vgic_v3_read_hppir(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 		lr_val = ICC_IAR1_EL1_SPURIOUS;
 
 spurious:
-	vcpu_set_reg(vcpu, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
+	ctxt_set_reg(vcpu_ctxt, rt, lr_val & ICH_LR_VIRTUAL_ID_MASK);
 }
 
 static void __vgic_v3_read_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	vmcr &= ICH_VMCR_PMR_MASK;
 	vmcr >>= ICH_VMCR_PMR_SHIFT;
-	vcpu_set_reg(vcpu, rt, vmcr);
+	ctxt_set_reg(vcpu_ctxt, rt, vmcr);
 }
 
 static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u32 val = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	val <<= ICH_VMCR_PMR_SHIFT;
 	val &= ICH_VMCR_PMR_MASK;
@@ -974,12 +999,14 @@ static void __vgic_v3_write_pmr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 static void __vgic_v3_read_rpr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 val = __vgic_v3_get_highest_active_priority();
-	vcpu_set_reg(vcpu, rt, val);
+	ctxt_set_reg(vcpu_ctxt, rt, val);
 }
 
 static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u32 vtr, val;
 
 	vtr = read_gicreg(ICH_VTR_EL2);
@@ -996,12 +1023,13 @@ static void __vgic_v3_read_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 	/* CBPR */
 	val |= (vmcr & ICH_VMCR_CBPR_MASK) >> ICH_VMCR_CBPR_SHIFT;
 
-	vcpu_set_reg(vcpu, rt, val);
+	ctxt_set_reg(vcpu_ctxt, rt, val);
 }
 
 static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 {
-	u32 val = vcpu_get_reg(vcpu, rt);
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
+	u32 val = ctxt_get_reg(vcpu_ctxt, rt);
 
 	if (val & ICC_CTLR_EL1_CBPR_MASK)
 		vmcr |= ICH_VMCR_CBPR_MASK;
@@ -1018,6 +1046,7 @@ static void __vgic_v3_write_ctlr(struct kvm_vcpu *vcpu, u32 vmcr, int rt)
 
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int rt;
 	u32 esr;
 	u32 vmcr;
@@ -1026,7 +1055,7 @@ int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu)
 	u32 sysreg;
 
 	esr = kvm_vcpu_get_esr(vcpu);
-	if (vcpu_mode_is_32bit(vcpu)) {
+	if (ctxt_mode_is_32bit(vcpu_ctxt)) {
 		if (!kvm_condition_valid(vcpu)) {
 			__kvm_skip_instr(vcpu);
 			return 1;
diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
index b3229924d243..c2e443202f8e 100644
--- a/arch/arm64/kvm/hyp/vhe/switch.c
+++ b/arch/arm64/kvm/hyp/vhe/switch.c
@@ -33,6 +33,7 @@ DEFINE_PER_CPU(unsigned long, kvm_hyp_vector);
 
 static void __activate_traps(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	u64 val;
 
 	___activate_traps(vcpu);
@@ -68,6 +69,7 @@ NOKPROBE_SYMBOL(__activate_traps);
 
 static void __deactivate_traps(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	extern char vectors[];	/* kernel exception vectors */
 
 	___deactivate_traps(vcpu);
@@ -88,6 +90,7 @@ NOKPROBE_SYMBOL(__deactivate_traps);
 
 void activate_traps_vhe_load(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	__activate_traps_common(vcpu);
 }
 
@@ -107,6 +110,7 @@ void deactivate_traps_vhe_put(void)
 /* Switch to the guest for VHE systems running in EL2 */
 static int __kvm_vcpu_run_vhe(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_cpu_context *guest_ctxt;
 	u64 exit_code;
@@ -160,6 +164,7 @@ NOKPROBE_SYMBOL(__kvm_vcpu_run_vhe);
 
 int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	int ret;
 
 	local_daif_mask();
@@ -197,9 +202,11 @@ static void __hyp_call_panic(u64 spsr, u64 elr, u64 par)
 {
 	struct kvm_cpu_context *host_ctxt;
 	struct kvm_vcpu *vcpu;
+	struct kvm_cpu_context *vcpu_ctxt;
 
 	host_ctxt = &this_cpu_ptr(&kvm_host_data)->host_ctxt;
 	vcpu = host_ctxt->__hyp_running_vcpu;
+	vcpu_ctxt = &vcpu_ctxt(vcpu);
 
 	__deactivate_traps(vcpu);
 	sysreg_restore_host_state_vhe(host_ctxt);
diff --git a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
index 2a0b8c88d74f..37f56b4743d0 100644
--- a/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
+++ b/arch/arm64/kvm/hyp/vhe/sysreg-sr.c
@@ -63,6 +63,7 @@ NOKPROBE_SYMBOL(sysreg_restore_guest_state_vhe);
  */
 void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
@@ -97,6 +98,7 @@ void kvm_vcpu_load_sysregs_vhe(struct kvm_vcpu *vcpu)
  */
 void kvm_vcpu_put_sysregs_vhe(struct kvm_vcpu *vcpu)
 {
+	struct kvm_cpu_context *vcpu_ctxt = &vcpu_ctxt(vcpu);
 	struct kvm_cpu_context *guest_ctxt = &vcpu->arch.ctxt;
 	struct kvm_cpu_context *host_ctxt;
 
-- 
2.33.0.685.g46640cef36-goog

