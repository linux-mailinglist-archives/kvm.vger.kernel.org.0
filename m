Return-Path: <kvm-owner@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88AA049F00F
	for <lists+kvm@lfdr.de>; Fri, 28 Jan 2022 01:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345163AbiA1AyC (ORCPT <rfc822;lists+kvm@lfdr.de>);
        Thu, 27 Jan 2022 19:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344925AbiA1Axu (ORCPT <rfc822;kvm@vger.kernel.org>);
        Thu, 27 Jan 2022 19:53:50 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E981FC061777
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:35 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id t1-20020a6564c1000000b002e7f31cf59fso2373716pgv.14
        for <kvm@vger.kernel.org>; Thu, 27 Jan 2022 16:53:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=reply-to:date:in-reply-to:message-id:mime-version:references
         :subject:from:to:cc;
        bh=61ZTgbq8+LvvTurQO/m+o8EgN1H5z8zbSRJ+o6lgAxg=;
        b=lgUPWVx6n2ZzmYGReVtlBLHVhwO7qWarF5fWR7/aAE8wzBHyTLVqxgK/NsopFA5t5d
         7o7jAjC+sDm0SBslGzOi2VjhvuVPv6op9hff2iHDCDxRO2V6MdPXYT9Iy7+J2u5CzS9W
         rbn0LXjpQnVpCZx/4xyoxaUKKHPSO9q8YyNv1R4pXgbeeopQTPoVTN3PHNVYZJBHqGyd
         olQj9MKfvh6Z76Yw2zjs2UJ8bk8EtRdyi7l6ZtXfIRl8FPFuoOpuHy1df0R3PpiJD3BY
         4dR7SqOx/MVDTFTGG2WtiOq4qVrbxMEPV/igSdG3CgEBHF+NPZ9NsE7mJ1W9W7C1KOFS
         Ci6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:reply-to:date:in-reply-to:message-id
         :mime-version:references:subject:from:to:cc;
        bh=61ZTgbq8+LvvTurQO/m+o8EgN1H5z8zbSRJ+o6lgAxg=;
        b=Cgu5Az3WD4ZQMfrpEatVUJzkemHmPnLyVptG5geH1+4X3rfItaKFQkg8Cdsk6fdmoS
         a4es+51+9sht/xhnu0eH8xLNlZ9+XNcoPzOy8emB8pxAyi34ypt0eK+TQ8ucLlJ/N/gg
         chMJyQ9PGa67fRDfRK3JZjC/KJtl+ouI6fpQti7r986RzQfhHWfloQ0K+FPY3NzT+ic0
         5Gwwa2JYFrsm3nna+7T5xfR56soX5gqLgIaklEW3VhNzkW5B7bQWV4WzcQy0ACj3u7PR
         OGyAPEI4A0Ut3hcclE9nX2MR8kKLjjSI8ICX0S0r4uxtxYJ1R56//Ie1tPiUtrtVcd/5
         g2gw==
X-Gm-Message-State: AOAM530R8kU6COhn9DajU81WGd4GfplLQH/EgogRs7pa5qHbfuyokhgh
        FQ7s9HextOCZz0KS7c3CdFwboimj7Qo=
X-Google-Smtp-Source: ABdhPJwliaWPKPh4iu4vXjLBu+BdyUwfcUpwuzg17xE83xBOpd/dI7Wfo4fv1pLYSlMAWLnkIZWrVc+oOtc=
X-Received: from seanjc.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:3e5])
 (user=seanjc job=sendgmr) by 2002:a17:902:b58c:: with SMTP id
 a12mr5675354pls.91.1643331215434; Thu, 27 Jan 2022 16:53:35 -0800 (PST)
Reply-To: Sean Christopherson <seanjc@google.com>
Date:   Fri, 28 Jan 2022 00:51:59 +0000
In-Reply-To: <20220128005208.4008533-1-seanjc@google.com>
Message-Id: <20220128005208.4008533-14-seanjc@google.com>
Mime-Version: 1.0
References: <20220128005208.4008533-1-seanjc@google.com>
X-Mailer: git-send-email 2.35.0.rc0.227.g00780c9af4-goog
Subject: [PATCH 13/22] KVM: VMX: Rename VMX functions to conform to
 kvm_x86_ops names
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

Massage VMX's implementation names for kvm_x86_ops to maximize use of
kvm-x86-ops.h.  Leave cpu_has_vmx_wbinvd_exit() as-is to preserve the
cpu_has_vmx_*() pattern used for querying VMCS capabilities.  Keep
pi_has_pending_interrupt() as vmx_dy_apicv_has_pending_interrupt() does
a poor job of describing exactly what is being checked in VMX land.

No functional change intended.

Signed-off-by: Sean Christopherson <seanjc@google.com>
---
 arch/x86/kvm/vmx/posted_intr.c |  6 +++---
 arch/x86/kvm/vmx/posted_intr.h |  4 ++--
 arch/x86/kvm/vmx/vmx.c         | 26 +++++++++++++-------------
 3 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/arch/x86/kvm/vmx/posted_intr.c b/arch/x86/kvm/vmx/posted_intr.c
index aa1fe9085d77..3834bb30ce54 100644
--- a/arch/x86/kvm/vmx/posted_intr.c
+++ b/arch/x86/kvm/vmx/posted_intr.c
@@ -244,7 +244,7 @@ void vmx_pi_start_assignment(struct kvm *kvm)
 }
 
 /*
- * pi_update_irte - set IRTE for Posted-Interrupts
+ * vmx_pi_update_irte - set IRTE for Posted-Interrupts
  *
  * @kvm: kvm
  * @host_irq: host irq of the interrupt
@@ -252,8 +252,8 @@ void vmx_pi_start_assignment(struct kvm *kvm)
  * @set: set or unset PI
  * returns 0 on success, < 0 on failure
  */
-int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
-		   bool set)
+int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
+		       uint32_t guest_irq, bool set)
 {
 	struct kvm_kernel_irq_routing_entry *e;
 	struct kvm_irq_routing_table *irq_rt;
diff --git a/arch/x86/kvm/vmx/posted_intr.h b/arch/x86/kvm/vmx/posted_intr.h
index eb14e76b84ef..9a45d5c9f116 100644
--- a/arch/x86/kvm/vmx/posted_intr.h
+++ b/arch/x86/kvm/vmx/posted_intr.h
@@ -97,8 +97,8 @@ void vmx_vcpu_pi_put(struct kvm_vcpu *vcpu);
 void pi_wakeup_handler(void);
 void __init pi_init_cpu(int cpu);
 bool pi_has_pending_interrupt(struct kvm_vcpu *vcpu);
-int pi_update_irte(struct kvm *kvm, unsigned int host_irq, uint32_t guest_irq,
-		   bool set);
+int vmx_pi_update_irte(struct kvm *kvm, unsigned int host_irq,
+		       uint32_t guest_irq, bool set);
 void vmx_pi_start_assignment(struct kvm *kvm);
 
 #endif /* __KVM_X86_VMX_POSTED_INTR_H */
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index de66786396bd..2138f7439a19 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -541,7 +541,7 @@ static inline bool cpu_need_virtualize_apic_accesses(struct kvm_vcpu *vcpu)
 	return flexpriority_enabled && lapic_in_kernel(vcpu);
 }
 
-static inline bool report_flexpriority(void)
+static inline bool vmx_cpu_has_accelerated_tpr(void)
 {
 	return flexpriority_enabled;
 }
@@ -2341,7 +2341,7 @@ static int kvm_cpu_vmxon(u64 vmxon_pointer)
 	return -EFAULT;
 }
 
-static int hardware_enable(void)
+static int vmx_hardware_enable(void)
 {
 	int cpu = raw_smp_processor_id();
 	u64 phys_addr = __pa(per_cpu(vmxarea, cpu));
@@ -2382,7 +2382,7 @@ static void vmclear_local_loaded_vmcss(void)
 		__loaded_vmcs_clear(v);
 }
 
-static void hardware_disable(void)
+static void vmx_hardware_disable(void)
 {
 	vmclear_local_loaded_vmcss();
 
@@ -6967,7 +6967,7 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu)
 	return vmx_exit_handlers_fastpath(vcpu);
 }
 
-static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
+static void vmx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
@@ -6978,7 +6978,7 @@ static void vmx_free_vcpu(struct kvm_vcpu *vcpu)
 	free_loaded_vmcs(vmx->loaded_vmcs);
 }
 
-static int vmx_create_vcpu(struct kvm_vcpu *vcpu)
+static int vmx_vcpu_create(struct kvm_vcpu *vcpu)
 {
 	struct vmx_uret_msr *tsx_ctrl;
 	struct vcpu_vmx *vmx;
@@ -7682,7 +7682,7 @@ static void vmx_migrate_timers(struct kvm_vcpu *vcpu)
 	}
 }
 
-static void hardware_unsetup(void)
+static void vmx_hardware_unsetup(void)
 {
 	kvm_set_posted_intr_wakeup_handler(NULL);
 
@@ -7705,18 +7705,18 @@ static bool vmx_check_apicv_inhibit_reasons(ulong bit)
 static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.name = "kvm_intel",
 
-	.hardware_unsetup = hardware_unsetup,
+	.hardware_unsetup = vmx_hardware_unsetup,
 
-	.hardware_enable = hardware_enable,
-	.hardware_disable = hardware_disable,
-	.cpu_has_accelerated_tpr = report_flexpriority,
+	.hardware_enable = vmx_hardware_enable,
+	.hardware_disable = vmx_hardware_disable,
+	.cpu_has_accelerated_tpr = vmx_cpu_has_accelerated_tpr,
 	.has_emulated_msr = vmx_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
 	.vm_init = vmx_vm_init,
 
-	.vcpu_create = vmx_create_vcpu,
-	.vcpu_free = vmx_free_vcpu,
+	.vcpu_create = vmx_vcpu_create,
+	.vcpu_free = vmx_vcpu_free,
 	.vcpu_reset = vmx_vcpu_reset,
 
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
@@ -7814,7 +7814,7 @@ static struct kvm_x86_ops vmx_x86_ops __initdata = {
 	.pmu_ops = &intel_pmu_ops,
 	.nested_ops = &vmx_nested_ops,
 
-	.pi_update_irte = pi_update_irte,
+	.pi_update_irte = vmx_pi_update_irte,
 	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
-- 
2.35.0.rc0.227.g00780c9af4-goog

