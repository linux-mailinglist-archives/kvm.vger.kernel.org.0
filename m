Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0163941757F
	for <lists+kvm@lfdr.de>; Fri, 24 Sep 2021 15:23:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345666AbhIXNY7 (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Fri, 24 Sep 2021 09:24:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344575AbhIXNYv (ORCPT <rfc822;kvm@vger.kernel.org>);
        Fri, 24 Sep 2021 09:24:51 -0400
Received: from mail-ed1-x54a.google.com (mail-ed1-x54a.google.com [IPv6:2a00:1450:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062F6C08EAEC
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:12 -0700 (PDT)
Received: by mail-ed1-x54a.google.com with SMTP id h15-20020aa7de0f000000b003d02f9592d6so10071206edv.17
        for <kvm@vger.kernel.org>; Fri, 24 Sep 2021 05:54:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=NDvJPFQrogpAsPTwpI9wbd6GY9uLrhdDShc06jG7Kb4=;
        b=ofmwdIYsCOT3dwUKE9fs1S0wlAahS1/K44MZDjnE5gAUoqkmdR2JLYgcKHIfptReIX
         dndQywZVRlFuQ3eOGRYinLFu/MngUVLE+8LX51SRkzUM7CBa6Rel5x8axNZa4uL1zp2U
         wJ0d3vM7NVwH6J3XmsmRgs8W0rTFnsn3wb9mC3nhOrcNH1NR5ZUwDA9tPRh1JDDH4f7l
         zQvYCm3Kkr3QWGWjZ1LC7iqi68tZn7ouspyCGugcVjLxryYO+CyIMSNqEVdSrV7xuY4w
         ABuCGZ9OVVMOUxX2tJIa+3AE5Tc9C+idHAo8MF2y4xXovo527JFfadzqGEw6vk6+5pL5
         tqKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=NDvJPFQrogpAsPTwpI9wbd6GY9uLrhdDShc06jG7Kb4=;
        b=5YxiuwLMqUJDOygUm/vPlHJNU/BCkApCLkcAnEKSQDmPKPsoA+yY//AeUH7B+74gpS
         Tusu70khNihtkiwwMQjs/aHtINgIQnR3NTOw3icYlTWVQ3J23OPUsBx+FzPEgkhcVEBs
         yNmwpEhLdNAGyyb+SZcxsAb2P0Ak41114rU5hobv7Mv74vYBa0Er7LHvU/GSOYzzncum
         btXURQbfshDVtvn6J4APJ7vJGaZ1B8Fbp8Q54HVQ79iZw6rA9a86G4TlIyTHN9Q7mHsd
         VQvgVFizTMYtp+ITsP8ST0gkFlJffay6lYU1EnRpRUV8sMahB3xxv05EsYQbRbsR/Myp
         MUcQ==
X-Gm-Message-State: AOAM530OvmzgdC7O5G0mlBuwDJvbtR57bslbMjduvKWZ55qIqJNy5j36
        zlYaaGmPLnvj6+k4JLVnOkajzIgpqQ==
X-Google-Smtp-Source: ABdhPJxKKemydyBQbjYJSypMRsSre41xZtGQ0H5ytHahnnYcVhn4lCAlWI7RlpAOylFBNu1TXAL96enMEA==
X-Received: from tabba.c.googlers.com ([fda3:e722:ac3:cc00:28:9cb1:c0a8:482])
 (user=tabba job=sendgmr) by 2002:a50:e10d:: with SMTP id h13mr4772015edl.77.1632488050517;
 Fri, 24 Sep 2021 05:54:10 -0700 (PDT)
Date:   Fri, 24 Sep 2021 13:53:33 +0100
In-Reply-To: <20210924125359.2587041-1-tabba@google.com>
Message-Id: <20210924125359.2587041-5-tabba@google.com>
Mime-Version: 1.0
References: <20210924125359.2587041-1-tabba@google.com>
X-Mailer: git-send-email 2.33.0.685.g46640cef36-goog
Subject: [RFC PATCH v1 04/30] KVM: arm64: remove unused parameters and asm offsets
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

Remove unused vcpu function parameters and asm-offset definitions.

Cleaner code and simplifies future refactoring.

Signed-off-by: Fuad Tabba <tabba@google.com>
---
 arch/arm64/include/asm/kvm_hyp.h   | 4 ++--
 arch/arm64/kernel/asm-offsets.c    | 1 -
 arch/arm64/kvm/hyp/nvhe/switch.c   | 6 +++---
 arch/arm64/kvm/hyp/nvhe/timer-sr.c | 4 ++--
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/arm64/include/asm/kvm_hyp.h b/arch/arm64/include/asm/kvm_hyp.h
index 9d60b3006efc..2e2b60a1b6c7 100644
--- a/arch/arm64/include/asm/kvm_hyp.h
+++ b/arch/arm64/include/asm/kvm_hyp.h
@@ -66,8 +66,8 @@ void __vgic_v3_restore_aprs(struct vgic_v3_cpu_if *cpu_if);
 int __vgic_v3_perform_cpuif_access(struct kvm_vcpu *vcpu);
 
 #ifdef __KVM_NVHE_HYPERVISOR__
-void __timer_enable_traps(struct kvm_vcpu *vcpu);
-void __timer_disable_traps(struct kvm_vcpu *vcpu);
+void __timer_enable_traps(void);
+void __timer_disable_traps(void);
 #endif
 
 #ifdef __KVM_NVHE_HYPERVISOR__
diff --git a/arch/arm64/kernel/asm-offsets.c b/arch/arm64/kernel/asm-offsets.c
index 0cb34ccb6e73..c2cc3a2813e6 100644
--- a/arch/arm64/kernel/asm-offsets.c
+++ b/arch/arm64/kernel/asm-offsets.c
@@ -109,7 +109,6 @@ int main(void)
   DEFINE(VCPU_CONTEXT,		offsetof(struct kvm_vcpu, arch.ctxt));
   DEFINE(VCPU_FAULT_DISR,	offsetof(struct kvm_vcpu, arch.fault.disr_el1));
   DEFINE(VCPU_WORKAROUND_FLAGS,	offsetof(struct kvm_vcpu, arch.workaround_flags));
-  DEFINE(VCPU_HCR_EL2,		offsetof(struct kvm_vcpu, arch.hcr_el2));
   DEFINE(CPU_USER_PT_REGS,	offsetof(struct kvm_cpu_context, regs));
   DEFINE(CPU_APIAKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIAKEYLO_EL1]));
   DEFINE(CPU_APIBKEYLO_EL1,	offsetof(struct kvm_cpu_context, sys_regs[APIBKEYLO_EL1]));
diff --git a/arch/arm64/kvm/hyp/nvhe/switch.c b/arch/arm64/kvm/hyp/nvhe/switch.c
index f7af9688c1f7..9296d7108f93 100644
--- a/arch/arm64/kvm/hyp/nvhe/switch.c
+++ b/arch/arm64/kvm/hyp/nvhe/switch.c
@@ -217,7 +217,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 	__activate_traps(vcpu);
 
 	__hyp_vgic_restore_state(vcpu);
-	__timer_enable_traps(vcpu);
+	__timer_enable_traps();
 
 	__debug_switch_to_guest(vcpu);
 
@@ -230,7 +230,7 @@ int __kvm_vcpu_run(struct kvm_vcpu *vcpu)
 
 	__sysreg_save_state_nvhe(guest_ctxt);
 	__sysreg32_save_state(vcpu);
-	__timer_disable_traps(vcpu);
+	__timer_disable_traps();
 	__hyp_vgic_save_state(vcpu);
 
 	__deactivate_traps(vcpu);
@@ -272,7 +272,7 @@ void __noreturn hyp_panic(void)
 	vcpu = host_ctxt->__hyp_running_vcpu;
 
 	if (vcpu) {
-		__timer_disable_traps(vcpu);
+		__timer_disable_traps();
 		__deactivate_traps(vcpu);
 		__load_host_stage2();
 		__sysreg_restore_state_nvhe(host_ctxt);
diff --git a/arch/arm64/kvm/hyp/nvhe/timer-sr.c b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
index 9072e71693ba..7b2a23ccdb0a 100644
--- a/arch/arm64/kvm/hyp/nvhe/timer-sr.c
+++ b/arch/arm64/kvm/hyp/nvhe/timer-sr.c
@@ -19,7 +19,7 @@ void __kvm_timer_set_cntvoff(u64 cntvoff)
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
-void __timer_disable_traps(struct kvm_vcpu *vcpu)
+void __timer_disable_traps(void)
 {
 	u64 val;
 
@@ -33,7 +33,7 @@ void __timer_disable_traps(struct kvm_vcpu *vcpu)
  * Should only be called on non-VHE systems.
  * VHE systems use EL2 timers and configure EL1 timers in kvm_timer_init_vhe().
  */
-void __timer_enable_traps(struct kvm_vcpu *vcpu)
+void __timer_enable_traps(void)
 {
 	u64 val;
 
-- 
2.33.0.685.g46640cef36-goog

