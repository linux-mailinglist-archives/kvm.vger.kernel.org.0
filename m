Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE655417581
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345078AbhIXNZM (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344963AbhIXNYw (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:52 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04006C08EAEF
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:16 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id s14-20020adff80e000000b001601b124f50so7999077wrp.5
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=GNJXCwSAbei7X+d2zrSyKPjr3s2IaQgd3QwFYy/hAIU=;
        b=FgWbPgZcipmM7hDQfUPsPO0ieDHPnx6Sh8kB3YNh80tJE+M54GZgHyARNdv3SkWMP9
         FSzi0J6f9EIJPfjbRf1AFSSOW1Jo+/pz6JNlawA8iXeg5Fp9pgKDq/hCIO6xw1A4rWop
         5Q/QA+HIOhZ9eNuVlB0g2c3HSZX9DjA6BCPGN8x+H/jI/mqgI8+MrF0sHOhjfaag8B0b
         1E8Vfe1o34gnJVeKjdcqGdedCnwx9+69P0v2p9mdnzUuHO9uu1/r3/fEA9dhtQGc2nZM
         6tkk2EPfnh1zCzD55dDl/i7LIDH7jHzhKj2v3/lcj8EjKNnCO4AHNo0s09MGfzgAvGuD
         Pi4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=GNJXCwSAbei7X+d2zrSyKPjr3s2IaQgd3QwFYy/hAIU=;
        b=rSCHu57IblGfi7G0GGAQhTfv0lUbS8y1Wyv+xaQRa/dDn+1sHZnq3p4KVZsO0BIoWo
         YKoX0UDojzCTCtryD/CpGY590wzIZcr/t521aWkoOCPkLSVXPhfKGjl/E8qJhb0aEEKg
         FDgE4YMURCrBTALqEV2AZbzHyCaSpPBsRMuyy6D8YGCTDczN9YdhVzYaMnzxZ8Z9gRFj
         zPEweCnN4epnnVz9MXdHEw8mv3sKCMm2ydDGmqBb0iXz8vz8dtBc71jfCPkbyi9odqMr
         F8xUOBevV5QwV8G8co8tc6ytZ7MnPn1orXV9aa6LmjBD7ROteajRvyxwgtIZLrvDfu3d
         /HHg==
X-Gm-Message-State: AOAM530aAPSPUjlJmnSKyjxSU2/8Gn22N7p1nSUCHKf0rr6XARf/ouKU
        ZBOuj7vsvLFdGTgiNg7tqpKPI1t01g==
X-Google-Smtp-Source: ABdhPJyoJ4ezBcFbxEorS+BChh9gJ7Ip4MIZRiUmXZuwwPnp+ovEAnjm0lg/pp1rPexQj9d9ps3gIy+HdA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a05:600c:896:: with SMTP id
 l22mr1903656wmp.173.1632488054622; Fri, 24 Sep 2021 05:54:14 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:35 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-7-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 06/30] KVM: arm64: COCCI: use_ctxt_access.cocci: use
 kvm_cpu_context accessors
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

Some parts of the code access vcpu->arch.ctxt directly instead of
using existing accessors. Refactor to use the existing accessors
to make the code more consistent and to simplify future patches.

This applies the semantic patch with the following command:

spatch --sp-file cocci_refactor/use_ctxt_access.cocci --dir arch/arm64/kvm/ --include-headers --in-place

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/kvm/fpsimd.c                    |  2 +-
 arch/arm64/kvm/guest.c                     | 28 +++++++++++-----------
 arch/arm64/kvm/hyp/include/hyp/switch.h    |  4 ++--
 arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h | 16 ++++++-------
 arch/arm64/kvm/reset.c                     | 10 ++++----
 5 files changed, 30 insertions(+), 30 deletions(-)

diff --git a/arch/arm64/kvm/fpsimd.c b/arch/arm64/kvm/fpsimd.c
index 5621020b28de..db135588236a 100644
--- a/arch/arm64/kvm/fpsimd.c
+++ b/arch/arm64/kvm/fpsimd.c
@@ -97,7 +97,7 @@ void kvm_arch_vcpu_ctxsync_fp(struct kvm_vcpu *vcpu)
 	WARN_ON_ONCE(!irqs_disabled());
 
 	if (vcpu->arch.flags & KVM_ARM64_FP_ENABLED) {
-		fpsimd_bind_state_to_cpu(&vcpu->arch.ctxt.fp_regs,
+		fpsimd_bind_state_to_cpu(vcpu_fp_regs(vcpu),
 					 vcpu->arch.sve_state,
 					 vcpu->arch.sve_max_vl);
 
diff --git a/arch/arm64/kvm/guest.c b/arch/arm64/kvm/guest.c
index 5cb4a1cd5603..c4429307a164 100644
--- a/arch/arm64/kvm/guest.c
+++ b/arch/arm64/kvm/guest.c
@@ -116,49 +116,49 @@ static void *core_reg_addr(struct kvm_vcpu *vcpu, const struct kvm_one_reg *reg)
 	     KVM_REG_ARM_CORE_REG(regs.regs[30]):
 		off -= KVM_REG_ARM_CORE_REG(regs.regs[0]);
 		off /= 2;
-		return &vcpu->arch.ctxt.regs.regs[off];
+		return &vcpu_gp_regs(vcpu)->regs[off];
 
 	case KVM_REG_ARM_CORE_REG(regs.sp):
-		return &vcpu->arch.ctxt.regs.sp;
+		return &vcpu_gp_regs(vcpu)->sp;
 
 	case KVM_REG_ARM_CORE_REG(regs.pc):
-		return &vcpu->arch.ctxt.regs.pc;
+		return &vcpu_gp_regs(vcpu)->pc;
 
 	case KVM_REG_ARM_CORE_REG(regs.pstate):
-		return &vcpu->arch.ctxt.regs.pstate;
+		return &vcpu_gp_regs(vcpu)->pstate;
 
 	case KVM_REG_ARM_CORE_REG(sp_el1):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, SP_EL1);
+		return &__vcpu_sys_reg(vcpu, SP_EL1);
 
 	case KVM_REG_ARM_CORE_REG(elr_el1):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, ELR_EL1);
+		return &__vcpu_sys_reg(vcpu, ELR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_EL1]):
-		return __ctxt_sys_reg(&vcpu->arch.ctxt, SPSR_EL1);
+		return &__vcpu_sys_reg(vcpu, SPSR_EL1);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_ABT]):
-		return &vcpu->arch.ctxt.spsr_abt;
+		return vcpu_spsr_abt(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_UND]):
-		return &vcpu->arch.ctxt.spsr_und;
+		return vcpu_spsr_und(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_IRQ]):
-		return &vcpu->arch.ctxt.spsr_irq;
+		return vcpu_spsr_irq(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(spsr[KVM_SPSR_FIQ]):
-		return &vcpu->arch.ctxt.spsr_fiq;
+		return vcpu_spsr_fiq(vcpu);
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]) ...
 	     KVM_REG_ARM_CORE_REG(fp_regs.vregs[31]):
 		off -= KVM_REG_ARM_CORE_REG(fp_regs.vregs[0]);
 		off /= 4;
-		return &vcpu->arch.ctxt.fp_regs.vregs[off];
+		return &vcpu_fp_regs(vcpu)->vregs[off];
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpsr):
-		return &vcpu->arch.ctxt.fp_regs.fpsr;
+		return &vcpu_fp_regs(vcpu)->fpsr;
 
 	case KVM_REG_ARM_CORE_REG(fp_regs.fpcr):
-		return &vcpu->arch.ctxt.fp_regs.fpcr;
+		return &vcpu_fp_regs(vcpu)->fpcr;
 
 	default:
 		return NULL;
diff --git a/arch/arm64/kvm/hyp/include/hyp/switch.h b/arch/arm64/kvm/hyp/include/hyp/switch.h
index e4a2f295a394..9fa9cf71eefa 100644
--- a/arch/arm64/kvm/hyp/include/hyp/switch.h
+++ b/arch/arm64/kvm/hyp/include/hyp/switch.h
@@ -217,7 +217,7 @@ static inline void __hyp_sve_restore_guest(struct kvm_vcpu *vcpu)
 {
 	sve_cond_update_zcr_vq(vcpu_sve_max_vq(vcpu) - 1, SYS_ZCR_EL2);
 	__sve_restore_state(vcpu_sve_pffr(vcpu),
-			    &vcpu->arch.ctxt.fp_regs.fpsr);
+			    &vcpu_fp_regs(vcpu)->fpsr);
 	write_sysreg_el1(__vcpu_sys_reg(vcpu, ZCR_EL1), SYS_ZCR);
 }
 
@@ -276,7 +276,7 @@ static inline bool __hyp_handle_fpsimd(struct kvm_vcpu *vcpu)
 	if (sve_guest)
 		__hyp_sve_restore_guest(vcpu);
 	else
-		__fpsimd_restore_state(&vcpu->arch.ctxt.fp_regs);
+		__fpsimd_restore_state(vcpu_fp_regs(vcpu));
 
 	/* Skip restoring fpexc32 for AArch64 guests */
 	if (!(read_sysreg(hcr_el2) & HCR_RW))
diff --git a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
index cce43bfe158f..9451206f512e 100644
--- a/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
+++ b/arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h
@@ -161,10 +161,10 @@ static inline void __sysreg32_save_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	vcpu->arch.ctxt.spsr_abt = read_sysreg(spsr_abt);
-	vcpu->arch.ctxt.spsr_und = read_sysreg(spsr_und);
-	vcpu->arch.ctxt.spsr_irq = read_sysreg(spsr_irq);
-	vcpu->arch.ctxt.spsr_fiq = read_sysreg(spsr_fiq);
+	*vcpu_spsr_abt(vcpu) = read_sysreg(spsr_abt);
+	*vcpu_spsr_und(vcpu) = read_sysreg(spsr_und);
+	*vcpu_spsr_irq(vcpu) = read_sysreg(spsr_irq);
+	*vcpu_spsr_fiq(vcpu) = read_sysreg(spsr_fiq);
 
 	__vcpu_sys_reg(vcpu, DACR32_EL2) = read_sysreg(dacr32_el2);
 	__vcpu_sys_reg(vcpu, IFSR32_EL2) = read_sysreg(ifsr32_el2);
@@ -178,10 +178,10 @@ static inline void __sysreg32_restore_state(struct kvm_vcpu *vcpu)
 	if (!vcpu_el1_is_32bit(vcpu))
 		return;
 
-	write_sysreg(vcpu->arch.ctxt.spsr_abt, spsr_abt);
-	write_sysreg(vcpu->arch.ctxt.spsr_und, spsr_und);
-	write_sysreg(vcpu->arch.ctxt.spsr_irq, spsr_irq);
-	write_sysreg(vcpu->arch.ctxt.spsr_fiq, spsr_fiq);
+	write_sysreg(*vcpu_spsr_abt(vcpu), spsr_abt);
+	write_sysreg(*vcpu_spsr_und(vcpu), spsr_und);
+	write_sysreg(*vcpu_spsr_irq(vcpu), spsr_irq);
+	write_sysreg(*vcpu_spsr_fiq(vcpu), spsr_fiq);
 
 	write_sysreg(__vcpu_sys_reg(vcpu, DACR32_EL2), dacr32_el2);
 	write_sysreg(__vcpu_sys_reg(vcpu, IFSR32_EL2), ifsr32_el2);
diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
index d37ebee085cf..ab1ef5313a3e 100644
--- a/arch/arm64/kvm/reset.c
+++ b/arch/arm64/kvm/reset.c
@@ -258,11 +258,11 @@ int kvm_reset_vcpu(struct kvm_vcpu *vcpu)
 
 	/* Reset core registers */
 	memset(vcpu_gp_regs(vcpu), 0, sizeof(*vcpu_gp_regs(vcpu)));
-	memset(&vcpu->arch.ctxt.fp_regs, 0, sizeof(vcpu->arch.ctxt.fp_regs));
-	vcpu->arch.ctxt.spsr_abt = 0;
-	vcpu->arch.ctxt.spsr_und = 0;
-	vcpu->arch.ctxt.spsr_irq = 0;
-	vcpu->arch.ctxt.spsr_fiq = 0;
+	memset(vcpu_fp_regs(vcpu), 0, sizeof(*vcpu_fp_regs(vcpu)));
+	*vcpu_spsr_abt(vcpu) = 0;
+	*vcpu_spsr_und(vcpu) = 0;
+	*vcpu_spsr_irq(vcpu) = 0;
+	*vcpu_spsr_fiq(vcpu) = 0;
 	vcpu_gp_regs(vcpu)->pstate = pstate;
 
 	/* Reset system registers */
-- 
2.33.0.685.g46640cef36-goog

