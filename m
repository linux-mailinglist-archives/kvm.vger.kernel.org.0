Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64E7649F000
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344812AbiA1Axk (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:53:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344820AbiA1AxV (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:21 -0500
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15882C06173B
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:21 -0800 (PST)
Received: by mail-pl1-x649.google.com with SMTP id y3-20020a1709029b8300b0014c8bcb70a1so973454plp.3
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=KSdQd/HH6zg6Fen+iY/KfeFerxFepmAT3RGzM3Nml5A=;
        b=j1dFYBtKm8srVaFX4HS++T1WlxV27Kar2Gfkea24AUYnvMFXsdoO/3v6JhqQZg+HP5
         XqbM2kbaV4+b4FLFAXss+MeCCuXsH4gL5YZ7Sjkux8da+CvRXscmNA1g0AYegOZ7beGn
         cwGG5D9reBxSoELyzgCgwZFaf4bJl5iHrBS45Bh+7J1l9Nieueycb5qy1Y2pmOT4HsO9
         HkhQswdeQWabbSzX6Ak1ysgLK4F3y4RaZL1c0zTIE92XJ9fyWm8x58kDRKtAbdayz/px
         SWalyoMRQxn74tcbhKkjcr5adkVdKQS42CsH7FwLu97ErcekCWwlQMnuLiBBYqNx/60i
         aCtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=KSdQd/HH6zg6Fen+iY/KfeFerxFepmAT3RGzM3Nml5A=;
        b=IsOX8NFCcEK9bR8C9+igJXQK+rd2VTEf/nck1Uax+iyXpKnfkxMPKu9psmo+hF3Slv
         US8pcAUEFdpI63ksI9MVX3PFSqJW4waYs7kcKKDPeCkS9N41T5mQofTgOErSWqg3OBXW
         sxaJsg6xp9Bhy5Fnaa/Gw/Xbc1qZCRM5Dtnh4Ybp+YrG9uM9rr/eNDuiNYs44v6xNCwU
         pFas/4mGbBrJ6t2x4tDeAOJtOrFII7cQinoWOyefGyx3qKiqGyu6VkH2ELg9wnmdnsEl
         7b+hBZ/eJYwao3JnhiQ8439XK21MQOpCuXJTFcWjh3giDSUXL83E/1FE9n+nFRXuLvVC
         T8cA==
X-Gm-Message-State: AOAM532OSrRREJ+2SO9oYvfO2QztYquUOQ3upGJtiCUrdNBBLiptFxzE
        sh/Gsh6+j8uIF6jbdAocSvpP38y/D0k=
X-Google-Smtp-Source: ABdhPJyIpiKDjPqYuHV7zw86jsDrJ8JfHnUBFjC64kM/2NIlptvuJpbvVTVZsfl2LJhU9ioMUC3GycgSmGM=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:90a:e2ca:: with SMTP id
 fr10mr7015733pjb.51.1643331200616; Thu, 27 Jan 2022 16:53:20 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:50 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-5-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 04/22] KVM: x86: Rename kvm_x86_ops pointers to align w/
 preferred vendor names
From:   Sean Christopherson <seanjc@google.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Sean Christopherson <seanjc@google.com>,
        Vitaly Kuznetsov <vkuznets@redhat.com>,
        Wanpeng Li <wanpengli@tencent.com>,
        Jim Mattson <jmattson@google.com>,
        Joerg Roedel <joro@8bytes.org>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Like Xu <like.xu.linux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <kvm.vger.kernel.org>
X-Mailing-List: kvm@vger.kernel.org

Rename a variety of kvm_x86_op function pointers so that preferred name
for vendor implementations follows the pattern <vendor>_<function>, e.g.
rename .run() to .vcpu_run() to match {svm,vmx}_vcpu_run().  This will
allow vendor implementations to be wired up via the KVM_X86_OP macro.

In many cases, VMX and SVM "disagree" on the preferred name, though in
reality it's VMX and x86 that disagree as SVM blindly prepended _svm to
the kvm_x86_ops name.  Justification for using the VMX nomenclature:

  - set_{irq,nmi} => inject_{irq,nmi} because the helper is injecting an
    event that has already been "set" in e.g. the vIRR.  SVM's relevant
    VMCB field is even named event_inj, and KVM's stat is irq_injections.

  - prepare_guest_switch => prepare_switch_to_guest because the former is
    ambiguous, e.g. it could mean switching between multiple guests,
    switching from the guest to host, etc...

  - update_pi_irte => pi_update_irte to allow for matching match the rest
    of VMX's posted interrupt naming scheme, which is vmx_pi_<blah>().

  - start_assignment => pi_start_assignment to again follow VMX's posted
    interrupt naming scheme, and to provide context for what bit of code
    might care about an otherwise undescribed "assignment".

The "tlb_flush" => "flush_tlb" creates an inconsistency with respect to
Hyper-V's "tlb_remote_flush" hooks, but Hyper-V really is the one that's
wrong.  x86, VMX, and SVM all use flush_tlb, and even common KVM is on a
variant of the bandwagon with "kvm_flush_remote_tlbs", e.g. a more
appropriate name for the Hyper-V hooks would be flush_remote_tlbs.  Leave
that change for another time as the Hyper-V hooks always start as NULL,
i.e. the name doesn't matter for using kvm-x86-ops.h, and changing all
names requires an astounding amount of churn.

VMX and SVM function names are intentionally left as is to minimize the
diff.  Both VMX and SVM will need to rename even more functions in order
to fully utilize KVM_X86_OPS, i.e. an additional patch for each is
inevitable.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/include/asm/kvm-x86-ops.h | 20 +++++++++----------
 arch/x86/include/asm/kvm_host.h    | 20 +++++++++----------
 arch/x86/kvm/mmu/mmu.c             |  6 +++---
 arch/x86/kvm/svm/svm.c             | 18 ++++++++---------
 arch/x86/kvm/vmx/vmx.c             | 20 +++++++++----------
 arch/x86/kvm/x86.c                 | 31 ++++++++++++++----------------
 6 files changed, 56 insertions(+), 59 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index fd134c436029..a87632641a13 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -18,7 +18,7 @@ KVM_X86_OP(vm_destroy)
 KVM_X86_OP(vcpu_create)
 KVM_X86_OP(vcpu_free)
 KVM_X86_OP(vcpu_reset)
-KVM_X86_OP(prepare_guest_switch)
+KVM_X86_OP(prepare_switch_to_guest)
 KVM_X86_OP(vcpu_load)
 KVM_X86_OP(vcpu_put)
 KVM_X86_OP(update_exception_bitmap)
@@ -44,22 +44,22 @@ KVM_X86_OP(cache_reg)
 KVM_X86_OP(get_rflags)
 KVM_X86_OP(set_rflags)
 KVM_X86_OP(get_if_flag)
-KVM_X86_OP(tlb_flush_all)
-KVM_X86_OP(tlb_flush_current)
+KVM_X86_OP(flush_tlb_all)
+KVM_X86_OP(flush_tlb_current)
 KVM_X86_OP(tlb_remote_flush)
 KVM_X86_OP(tlb_remote_flush_with_range)
-KVM_X86_OP(tlb_flush_gva)
-KVM_X86_OP(tlb_flush_guest)
+KVM_X86_OP(flush_tlb_gva)
+KVM_X86_OP(flush_tlb_guest)
 KVM_X86_OP(vcpu_pre_run)
-KVM_X86_OP(run)
+KVM_X86_OP(vcpu_run)
 KVM_X86_OP(handle_exit)
 KVM_X86_OP(skip_emulated_instruction)
 KVM_X86_OP(update_emulated_instruction)
 KVM_X86_OP(set_interrupt_shadow)
 KVM_X86_OP(get_interrupt_shadow)
 KVM_X86_OP(patch_hypercall)
-KVM_X86_OP(set_irq)
-KVM_X86_OP(set_nmi)
+KVM_X86_OP(inject_irq)
+KVM_X86_OP(inject_nmi)
 KVM_X86_OP(queue_exception)
 KVM_X86_OP(cancel_injection)
 KVM_X86_OP(interrupt_allowed)
@@ -96,8 +96,8 @@ KVM_X86_OP(sched_in)
 KVM_X86_OP(update_cpu_dirty_logging)
 KVM_X86_OP(vcpu_blocking)
 KVM_X86_OP(vcpu_unblocking)
-KVM_X86_OP(update_pi_irte)
-KVM_X86_OP(start_assignment)
+KVM_X86_OP(pi_update_irte)
+KVM_X86_OP(pi_start_assignment)
 KVM_X86_OP(apicv_post_state_restore)
 KVM_X86_OP(dy_apicv_has_pending_interrupt)
 KVM_X86_OP(set_hv_timer)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index c895e94ffb80..91c0e4957bd0 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1330,7 +1330,7 @@ struct kvm_x86_ops {
 	void (*vcpu_free)(struct kvm_vcpu *vcpu);
 	void (*vcpu_reset)(struct kvm_vcpu *vcpu, bool init_event);
 
-	void (*prepare_guest_switch)(struct kvm_vcpu *vcpu);
+	void (*prepare_switch_to_guest)(struct kvm_vcpu *vcpu);
 	void (*vcpu_load)(struct kvm_vcpu *vcpu, int cpu);
 	void (*vcpu_put)(struct kvm_vcpu *vcpu);
 
@@ -1360,8 +1360,8 @@ struct kvm_x86_ops {
 	void (*set_rflags)(struct kvm_vcpu *vcpu, unsigned long rflags);
 	bool (*get_if_flag)(struct kvm_vcpu *vcpu);
 
-	void (*tlb_flush_all)(struct kvm_vcpu *vcpu);
-	void (*tlb_flush_current)(struct kvm_vcpu *vcpu);
+	void (*flush_tlb_all)(struct kvm_vcpu *vcpu);
+	void (*flush_tlb_current)(struct kvm_vcpu *vcpu);
 	int  (*tlb_remote_flush)(struct kvm *kvm);
 	int  (*tlb_remote_flush_with_range)(struct kvm *kvm,
 			struct kvm_tlb_range *range);
@@ -1372,16 +1372,16 @@ struct kvm_x86_ops {
 	 * Can potentially get non-canonical addresses through INVLPGs, which
 	 * the implementation may choose to ignore if appropriate.
 	 */
-	void (*tlb_flush_gva)(struct kvm_vcpu *vcpu, gva_t addr);
+	void (*flush_tlb_gva)(struct kvm_vcpu *vcpu, gva_t addr);
 
 	/*
 	 * Flush any TLB entries created by the guest.  Like tlb_flush_gva(),
 	 * does not need to flush GPA->HPA mappings.
 	 */
-	void (*tlb_flush_guest)(struct kvm_vcpu *vcpu);
+	void (*flush_tlb_guest)(struct kvm_vcpu *vcpu);
 
 	int (*vcpu_pre_run)(struct kvm_vcpu *vcpu);
-	enum exit_fastpath_completion (*run)(struct kvm_vcpu *vcpu);
+	enum exit_fastpath_completion (*vcpu_run)(struct kvm_vcpu *vcpu);
 	int (*handle_exit)(struct kvm_vcpu *vcpu,
 		enum exit_fastpath_completion exit_fastpath);
 	int (*skip_emulated_instruction)(struct kvm_vcpu *vcpu);
@@ -1390,8 +1390,8 @@ struct kvm_x86_ops {
 	u32 (*get_interrupt_shadow)(struct kvm_vcpu *vcpu);
 	void (*patch_hypercall)(struct kvm_vcpu *vcpu,
 				unsigned char *hypercall_addr);
-	void (*set_irq)(struct kvm_vcpu *vcpu);
-	void (*set_nmi)(struct kvm_vcpu *vcpu);
+	void (*inject_irq)(struct kvm_vcpu *vcpu);
+	void (*inject_nmi)(struct kvm_vcpu *vcpu);
 	void (*queue_exception)(struct kvm_vcpu *vcpu);
 	void (*cancel_injection)(struct kvm_vcpu *vcpu);
 	int (*interrupt_allowed)(struct kvm_vcpu *vcpu, bool for_injection);
@@ -1458,9 +1458,9 @@ struct kvm_x86_ops {
 	void (*vcpu_blocking)(struct kvm_vcpu *vcpu);
 	void (*vcpu_unblocking)(struct kvm_vcpu *vcpu);
 
-	int (*update_pi_irte)(struct kvm *kvm, unsigned int host_irq,
+	int (*pi_update_irte)(struct kvm *kvm, unsigned int host_irq,
 			      uint32_t guest_irq, bool set);
-	void (*start_assignment)(struct kvm *kvm);
+	void (*pi_start_assignment)(struct kvm *kvm);
 	void (*apicv_post_state_restore)(struct kvm_vcpu *vcpu);
 	bool (*dy_apicv_has_pending_interrupt)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b29fc88b51b4..9f1b4711d5ea 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -5097,7 +5097,7 @@ int kvm_mmu_load(struct kvm_vcpu *vcpu)
 	kvm_mmu_sync_roots(vcpu);
 
 	kvm_mmu_load_pgd(vcpu);
-	static_call(kvm_x86_tlb_flush_current)(vcpu);
+	static_call(kvm_x86_flush_tlb_current)(vcpu);
 out:
 	return r;
 }
@@ -5357,7 +5357,7 @@ void kvm_mmu_invalidate_gva(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 		if (is_noncanonical_address(gva, vcpu))
 			return;
 
-		static_call(kvm_x86_tlb_flush_gva)(vcpu, gva);
+		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
 	}
 
 	if (!mmu->invlpg)
@@ -5413,7 +5413,7 @@ void kvm_mmu_invpcid_gva(struct kvm_vcpu *vcpu, gva_t gva, unsigned long pcid)
 	}
 
 	if (tlb_flush)
-		static_call(kvm_x86_tlb_flush_gva)(vcpu, gva);
+		static_call(kvm_x86_flush_tlb_gva)(vcpu, gva);
 
 	++vcpu->stat.invlpg;
 
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 75d277067141..991d3e628c60 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -4472,7 +4472,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.vm_init = svm_vm_init,
 	.vm_destroy = svm_vm_destroy,
 
-	.prepare_guest_switch = svm_prepare_guest_switch,
+	.prepare_switch_to_guest = svm_prepare_guest_switch,
 	.vcpu_load = svm_vcpu_load,
 	.vcpu_put = svm_vcpu_put,
 	.vcpu_blocking = avic_vcpu_blocking,
@@ -4503,21 +4503,21 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 	.set_rflags = svm_set_rflags,
 	.get_if_flag = svm_get_if_flag,
 
-	.tlb_flush_all = svm_flush_tlb,
-	.tlb_flush_current = svm_flush_tlb,
-	.tlb_flush_gva = svm_flush_tlb_gva,
-	.tlb_flush_guest = svm_flush_tlb,
+	.flush_tlb_all = svm_flush_tlb,
+	.flush_tlb_current = svm_flush_tlb,
+	.flush_tlb_gva = svm_flush_tlb_gva,
+	.flush_tlb_guest = svm_flush_tlb,
 
 	.vcpu_pre_run = svm_vcpu_pre_run,
-	.run = svm_vcpu_run,
+	.vcpu_run = svm_vcpu_run,
 	.handle_exit = handle_exit,
 	.skip_emulated_instruction = skip_emulated_instruction,
 	.update_emulated_instruction = NULL,
 	.set_interrupt_shadow = svm_set_interrupt_shadow,
 	.get_interrupt_shadow = svm_get_interrupt_shadow,
 	.patch_hypercall = svm_patch_hypercall,
-	.set_irq = svm_set_irq,
-	.set_nmi = svm_inject_nmi,
+	.inject_irq = svm_set_irq,
+	.inject_nmi = svm_inject_nmi,
 	.queue_exception = svm_queue_exception,
 	.cancel_injection = svm_cancel_injection,
 	.interrupt_allowed = svm_interrupt_allowed,
@@ -4564,7 +4564,7 @@ static struct kvm_x86_ops svm_x86_ops __initdata = {
 
 	.deliver_interrupt = svm_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = svm_dy_apicv_has_pending_interrupt,
-	.update_pi_irte = svm_update_pi_irte,
+	.pi_update_irte = svm_update_pi_irte,
 	.setup_mce = svm_setup_mce,
 
 	.smi_allowed = svm_smi_allowed,
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 97d6edbd25a0..1d2d850b124b 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7719,7 +7719,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.vcpu_free = vmx_free_vcpu,
 	.vcpu_reset = vmx_vcpu_reset,
 
-	.prepare_guest_switch = vmx_prepare_switch_to_guest,
+	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
 	.vcpu_put = vmx_vcpu_put,
 
@@ -7747,21 +7747,21 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.set_rflags = vmx_set_rflags,
 	.get_if_flag = vmx_get_if_flag,
 
-	.tlb_flush_all = vmx_flush_tlb_all,
-	.tlb_flush_current = vmx_flush_tlb_current,
-	.tlb_flush_gva = vmx_flush_tlb_gva,
-	.tlb_flush_guest = vmx_flush_tlb_guest,
+	.flush_tlb_all = vmx_flush_tlb_all,
+	.flush_tlb_current = vmx_flush_tlb_current,
+	.flush_tlb_gva = vmx_flush_tlb_gva,
+	.flush_tlb_guest = vmx_flush_tlb_guest,
 
 	.vcpu_pre_run = vmx_vcpu_pre_run,
-	.run = vmx_vcpu_run,
+	.vcpu_run = vmx_vcpu_run,
 	.handle_exit = vmx_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vmx_set_interrupt_shadow,
 	.get_interrupt_shadow = vmx_get_interrupt_shadow,
 	.patch_hypercall = vmx_patch_hypercall,
-	.set_irq = vmx_inject_irq,
-	.set_nmi = vmx_inject_nmi,
+	.inject_irq = vmx_inject_irq,
+	.inject_nmi = vmx_inject_nmi,
 	.queue_exception = vmx_queue_exception,
 	.cancel_injection = vmx_cancel_injection,
 	.interrupt_allowed = vmx_interrupt_allowed,
@@ -7814,8 +7814,8 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
-	.update_pi_irte = pi_update_irte,
-	.start_assignment = vmx_pi_start_assignment,
+	.pi_update_irte = pi_update_irte,
+	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
 	.set_hv_timer = vmx_set_hv_timer,
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index a2821c46dfa4..cc14f79c446c 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3264,7 +3264,7 @@ static void kvmclock_reset(struct kvm_vcpu *vcpu)
 static void kvm_vcpu_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	static_call(kvm_x86_tlb_flush_all)(vcpu);
+	static_call(kvm_x86_flush_tlb_all)(vcpu);
 }
 
 static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
@@ -3282,14 +3282,14 @@ static void kvm_vcpu_flush_tlb_guest(struct kvm_vcpu *vcpu)
 		kvm_mmu_sync_prev_roots(vcpu);
 	}
 
-	static_call(kvm_x86_tlb_flush_guest)(vcpu);
+	static_call(kvm_x86_flush_tlb_guest)(vcpu);
 }
 
 
 static inline void kvm_vcpu_flush_tlb_current(struct kvm_vcpu *vcpu)
 {
 	++vcpu->stat.tlb_flush;
-	static_call(kvm_x86_tlb_flush_current)(vcpu);
+	static_call(kvm_x86_flush_tlb_current)(vcpu);
 }
 
 /*
@@ -9283,10 +9283,10 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 	 */
 	else if (!vcpu->arch.exception.pending) {
 		if (vcpu->arch.nmi_injected) {
-			static_call(kvm_x86_set_nmi)(vcpu);
+			static_call(kvm_x86_inject_nmi)(vcpu);
 			can_inject = false;
 		} else if (vcpu->arch.interrupt.injected) {
-			static_call(kvm_x86_set_irq)(vcpu);
+			static_call(kvm_x86_inject_irq)(vcpu);
 			can_inject = false;
 		}
 	}
@@ -9366,7 +9366,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 		if (r) {
 			--vcpu->arch.nmi_pending;
 			vcpu->arch.nmi_injected = true;
-			static_call(kvm_x86_set_nmi)(vcpu);
+			static_call(kvm_x86_inject_nmi)(vcpu);
 			can_inject = false;
 			WARN_ON(static_call(kvm_x86_nmi_allowed)(vcpu, true) < 0);
 		}
@@ -9380,7 +9380,7 @@ static int inject_pending_event(struct kvm_vcpu *vcpu, bool *req_immediate_exit)
 			goto out;
 		if (r) {
 			kvm_queue_interrupt(vcpu, kvm_cpu_get_interrupt(vcpu), false);
-			static_call(kvm_x86_set_irq)(vcpu);
+			static_call(kvm_x86_inject_irq)(vcpu);
 			WARN_ON(static_call(kvm_x86_interrupt_allowed)(vcpu, true) < 0);
 		}
 		if (kvm_cpu_has_injectable_intr(vcpu))
@@ -10005,7 +10005,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 
 	preempt_disable();
 
-	static_call(kvm_x86_prepare_guest_switch)(vcpu);
+	static_call(kvm_x86_prepare_switch_to_guest)(vcpu);
 
 	/*
 	 * Disable IRQs before setting IN_GUEST_MODE.  Posted interrupt
@@ -10082,7 +10082,7 @@ static int vcpu_enter_guest(struct kvm_vcpu *vcpu)
 		 */
 		WARN_ON_ONCE(kvm_apicv_activated(vcpu->kvm) != kvm_vcpu_apicv_active(vcpu));
 
-		exit_fastpath = static_call(kvm_x86_run)(vcpu);
+		exit_fastpath = static_call(kvm_x86_vcpu_run)(vcpu);
 		if (likely(exit_fastpath != EXIT_FASTPATH_REENTER_GUEST))
 			break;
 
@@ -10385,10 +10385,7 @@ static int complete_emulated_mmio(struct kvm_vcpu *vcpu)
 /* Swap (qemu) user FPU context for the guest FPU context. */
 static void kvm_load_guest_fpu(struct kvm_vcpu *vcpu)
 {
-	/*
-	 * Exclude PKRU from restore as restored separately in
-	 * kvm_x86_ops.run().
-	 */
+	/* Exclude PKRU, it's restored separately immediately after VM-Exit. */
 	fpu_swap_kvm_fpstate(&vcpu->arch.guest_fpu, true);
 	trace_kvm_fpu(1);
 }
@@ -12396,7 +12393,7 @@ bool kvm_arch_can_dequeue_async_page_present(struct kvm_vcpu *vcpu)
 void kvm_arch_start_assignment(struct kvm *kvm)
 {
 	if (atomic_inc_return(&kvm->arch.assigned_device_count) == 1)
-		static_call_cond(kvm_x86_start_assignment)(kvm);
+		static_call_cond(kvm_x86_pi_start_assignment)(kvm);
 }
 EXPORT_SYMBOL_GPL(kvm_arch_start_assignment);
 
@@ -12444,7 +12441,7 @@ int kvm_arch_irq_bypass_add_producer(struct irq_bypass_consumer *cons,
 
 	irqfd->producer = prod;
 	kvm_arch_start_assignment(irqfd->kvm);
-	ret = static_call(kvm_x86_update_pi_irte)(irqfd->kvm,
+	ret = static_call(kvm_x86_pi_update_irte)(irqfd->kvm,
 					 prod->irq, irqfd->gsi, 1);
 
 	if (ret)
@@ -12469,7 +12466,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 	 * when the irq is masked/disabled or the consumer side (KVM
 	 * int this case doesn't want to receive the interrupts.
 	*/
-	ret = static_call(kvm_x86_update_pi_irte)(irqfd->kvm, prod->irq, irqfd->gsi, 0);
+	ret = static_call(kvm_x86_pi_update_irte)(irqfd->kvm, prod->irq, irqfd->gsi, 0);
 	if (ret)
 		printk(KERN_INFO "irq bypass consumer (token %p) unregistration"
 		       " fails: %d\n", irqfd->consumer.token, ret);
@@ -12480,7 +12477,7 @@ void kvm_arch_irq_bypass_del_producer(struct irq_bypass_consumer *cons,
 int kvm_arch_update_irqfd_routing(struct kvm *kvm, unsigned int host_irq,
 				   uint32_t guest_irq, bool set)
 {
-	return static_call(kvm_x86_update_pi_irte)(kvm, host_irq, guest_irq, set);
+	return static_call(kvm_x86_pi_update_irte)(kvm, host_irq, guest_irq, set);
 }
 
 bool kvm_arch_irqfd_route_changed(struct kvm_kernel_irq_routing_entry *old,
-- 
2.35.0.rc0.227.g00780c9af4-goog

