Return-Path: <kvm+bounces-41366-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 868D6A66A9F
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 07:37:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A4F6A17B724
	for <lists+kvm@lfdr.de>; Tue, 18 Mar 2025 06:36:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C4C11EF36D;
	Tue, 18 Mar 2025 06:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FolztEcG"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6381DE8AE;
	Tue, 18 Mar 2025 06:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742279754; cv=none; b=BEfV6i3rYOwrPOUjVUZX1S88WfazRMvtA6YYX+GVQNWc9QfWfEbYf20hosjCJpYoAQ33XunHSduKBX04N5/WVD+VIOE+Pnrpx6DsJBxkrsxdhBsPm6hf/8kqsow7CjpbGiOqet9XXtEIHZXw4Fzhlso4mZvER4+JD10A3Xe+w7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742279754; c=relaxed/simple;
	bh=OIHwUnwim2gr3yi30KLSirjJ0fvA3hBLPCKL43Xd89w=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dQ8R9fyEDREJCtCa0n3YG7bkECKT8HnHuU1rdD8ZSKCgHLTKL5n4GTV0ipMXUto+gSvfdL31AOnJUHLwJNz5AwCttuiEDIEK8kAAbjT8wh2PL8W5abv3E6kJSzqvy9k2Qg8JsiwHpY9g4Odul46UUkN+HLbq4XzEIdelhgSQI7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FolztEcG; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742279753; x=1773815753;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=OIHwUnwim2gr3yi30KLSirjJ0fvA3hBLPCKL43Xd89w=;
  b=FolztEcG39/Gr9Stx5dgF7FOzbbGrSBkVbWJ9tOuDrQg2QMufFk8I4yy
   LuOoxBqc17YLTiiBMRWGbNxx5GPzm2w3QlJo7+wS/HJyRouClnIvlxUZC
   6mfU5bG+H4stxyW4Lye1qMJUP+YOoqVJLIuGIVbi8BKeGFA9+cYCyLzOq
   PCYcwZnOiueIM+gpwTcVCwwDfdwXU1e5JN9fQIehQPxzuThE6wqaRj9wr
   MMnUbAsHMtZ/2E/yJD+0ck06pXm+MEb4naHGYNdlQtjUz33RhSjdbhB6K
   libCInqKYWwF1Xssgniu9ena/o3boR332mhi21f/UJ54KTsFVRqyeM7p6
   A==;
X-CSE-ConnectionGUID: zrrjZzyBT1aqi654QPajXg==
X-CSE-MsgGUID: U8PrkX+PRFqHlvS6TAxLZQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="53613419"
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="53613419"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:51 -0700
X-CSE-ConnectionGUID: 4dZ+5XKCSgiEC1ya+0vvzA==
X-CSE-MsgGUID: /XT9HwEgS4+2vJ7TqepWdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,256,1736841600"; 
   d="scan'208";a="153147549"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.125.109.119])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 23:35:49 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 18 Mar 2025 00:35:09 -0600
Subject: [PATCH v2 4/4] KVM: VMX: Clean up and macrofy x86_ops
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250318-vverma7-cleanup_x86_ops-v2-4-701e82d6b779@intel.com>
References: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
In-Reply-To: <20250318-vverma7-cleanup_x86_ops-v2-0-701e82d6b779@intel.com>
To: Sean Christopherson <seanjc@google.com>, 
 Paolo Bonzini <pbonzini@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
 Binbin Wu <binbin.wu@linxu.intel.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.15-dev-c25d1
X-Developer-Signature: v=1; a=openpgp-sha256; l=15645;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=OIHwUnwim2gr3yi30KLSirjJ0fvA3hBLPCKL43Xd89w=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDOk3RZxbTl/fo3nyUXkax/N7usfvi1/d3RWVl2jEWvH+j
 wfjr2CDjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAExkpxkjw8wjeW527Fvqrnrc
 eH41PLVx75E5P6fO8v4Ys8+PRSjn9Q1Ghmt5SvLS7Bstbr89O9lrD8NC9qD/fX1uIme9m3ouVMQ
 78gIA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Eliminate a lot of stub definitions by using macros to define the TDX vs
non-TDX versions of various x86_ops. Moving the x86_ops wrappers under
CONFIG_KVM_INTEL_TDX also allows nearly all of vmx/main.c to go under a
single #ifdef, eliminating trampolines in the generated code, and almost
all of the stubs.

For example, with CONFIG_KVM_INTEL_TDX=n, before this cleanup,
vt_refresh_apicv_exec_ctrl() would produce:

0000000000036490 <vt_refresh_apicv_exec_ctrl>:
   36490:       f3 0f 1e fa             endbr64
   36494:       e8 00 00 00 00          call   36499 <vt_refresh_apicv_exec_ctrl+0x9>
                        36495: R_X86_64_PLT32   __fentry__-0x4
   36499:       e9 00 00 00 00          jmp    3649e <vt_refresh_apicv_exec_ctrl+0xe>
                        3649a: R_X86_64_PLT32   vmx_refresh_apicv_exec_ctrl-0x4
   3649e:       66 90                   xchg   %ax,%ax

After this patch, this is completely eliminated.

Based on a patch by Sean Christopherson <seanjc@google.com>

Link: https://lore.kernel.org/kvm/Z6v9yjWLNTU6X90d@google.com/
Cc: Sean Christopherson <seanjc@google.com>
Cc: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 arch/x86/kvm/vmx/tdx.h     |   2 +-
 arch/x86/kvm/vmx/x86_ops.h |  67 +---------------
 arch/x86/kvm/vmx/main.c    | 192 +++++++++++++++++++++++----------------------
 3 files changed, 101 insertions(+), 160 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 8f8070d0f55e..b43d7a7c8f1c 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -5,7 +5,7 @@
 #include "tdx_arch.h"
 #include "tdx_errno.h"
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 #include "common.h"
 
 int tdx_bringup(void);
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 97fcbcb0a503..e628318fc3fc 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -122,7 +122,7 @@ void vmx_cancel_hv_timer(struct kvm_vcpu *vcpu);
 #endif
 void vmx_setup_mce(struct kvm_vcpu *vcpu);
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 void tdx_disable_virtualization_cpu(void);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
@@ -165,71 +165,6 @@ void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
 int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn);
-#else
-static inline void tdx_disable_virtualization_cpu(void) {}
-static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
-static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
-static inline void tdx_vm_destroy(struct kvm *kvm) {}
-static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
-
-static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
-static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
-static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
-static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
-static inline int tdx_vcpu_pre_run(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
-static inline fastpath_t tdx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
-{
-	return EXIT_FASTPATH_NONE;
-}
-static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
-static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
-static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
-static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
-		enum exit_fastpath_completion fastpath) { return 0; }
-
-static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
-					 int trig_mode, int vector) {}
-static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
-static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
-				     u64 *info2, u32 *intr_info, u32 *error_code) {}
-static inline bool tdx_has_emulated_msr(u32 index) { return false; }
-static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
-static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
-
-static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
-
-static inline int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
-					    enum pg_level level,
-					    void *private_spt)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
-					    enum pg_level level,
-					    void *private_spt)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
-					    enum pg_level level,
-					    kvm_pfn_t pfn)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-					       enum pg_level level,
-					       kvm_pfn_t pfn)
-{
-	return -EOPNOTSUPP;
-}
-
-static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
-static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
-static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
-static inline int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn) { return 0; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index a1388adffa1e..218078ba039f 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -10,9 +10,8 @@
 #include "tdx.h"
 #include "tdx_arch.h"
 
-#ifdef CONFIG_INTEL_TDX_HOST
+#ifdef CONFIG_KVM_INTEL_TDX
 static_assert(offsetof(struct vcpu_vmx, vt) == offsetof(struct vcpu_tdx, vt));
-#endif
 
 static void vt_disable_virtualization_cpu(void)
 {
@@ -880,6 +879,13 @@ static int vt_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	return 0;
 }
 
+#define vt_op(name) vt_##name
+#define vt_op_tdx_only(name) vt_##name
+#else /* CONFIG_KVM_INTEL_TDX */
+#define vt_op(name) vmx_##name
+#define vt_op_tdx_only(name) NULL
+#endif /* CONFIG_KVM_INTEL_TDX */
+
 #define VMX_REQUIRED_APICV_INHIBITS				\
 	(BIT(APICV_INHIBIT_REASON_DISABLED) |			\
 	 BIT(APICV_INHIBIT_REASON_ABSENT) |			\
@@ -897,113 +903,113 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.hardware_unsetup = vmx_hardware_unsetup,
 
 	.enable_virtualization_cpu = vmx_enable_virtualization_cpu,
-	.disable_virtualization_cpu = vt_disable_virtualization_cpu,
+	.disable_virtualization_cpu = vt_op(disable_virtualization_cpu),
 	.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
 
-	.has_emulated_msr = vt_has_emulated_msr,
+	.has_emulated_msr = vt_op(has_emulated_msr),
 
 	.vm_size = sizeof(struct kvm_vmx),
 
-	.vm_init = vt_vm_init,
-	.vm_pre_destroy = vt_vm_pre_destroy,
-	.vm_destroy = vt_vm_destroy,
+	.vm_init = vt_op(vm_init),
+	.vm_destroy = vt_op(vm_destroy),
+	.vm_pre_destroy = vt_op_tdx_only(vm_pre_destroy),
 
-	.vcpu_precreate = vt_vcpu_precreate,
-	.vcpu_create = vt_vcpu_create,
-	.vcpu_free = vt_vcpu_free,
-	.vcpu_reset = vt_vcpu_reset,
+	.vcpu_precreate = vt_op(vcpu_precreate),
+	.vcpu_create = vt_op(vcpu_create),
+	.vcpu_free = vt_op(vcpu_free),
+	.vcpu_reset = vt_op(vcpu_reset),
 
-	.prepare_switch_to_guest = vt_prepare_switch_to_guest,
-	.vcpu_load = vt_vcpu_load,
-	.vcpu_put = vt_vcpu_put,
+	.prepare_switch_to_guest = vt_op(prepare_switch_to_guest),
+	.vcpu_load = vt_op(vcpu_load),
+	.vcpu_put = vt_op(vcpu_put),
 
-	.update_exception_bitmap = vt_update_exception_bitmap,
+	.update_exception_bitmap = vt_op(update_exception_bitmap),
 	.get_feature_msr = vmx_get_feature_msr,
-	.get_msr = vt_get_msr,
-	.set_msr = vt_set_msr,
+	.get_msr = vt_op(get_msr),
+	.set_msr = vt_op(set_msr),
 
-	.get_segment_base = vt_get_segment_base,
-	.get_segment = vt_get_segment,
-	.set_segment = vt_set_segment,
-	.get_cpl = vt_get_cpl,
-	.get_cpl_no_cache = vt_get_cpl_no_cache,
-	.get_cs_db_l_bits = vt_get_cs_db_l_bits,
-	.is_valid_cr0 = vt_is_valid_cr0,
-	.set_cr0 = vt_set_cr0,
-	.is_valid_cr4 = vt_is_valid_cr4,
-	.set_cr4 = vt_set_cr4,
-	.set_efer = vt_set_efer,
-	.get_idt = vt_get_idt,
-	.set_idt = vt_set_idt,
-	.get_gdt = vt_get_gdt,
-	.set_gdt = vt_set_gdt,
-	.set_dr6 = vt_set_dr6,
-	.set_dr7 = vt_set_dr7,
-	.sync_dirty_debug_regs = vt_sync_dirty_debug_regs,
-	.cache_reg = vt_cache_reg,
-	.get_rflags = vt_get_rflags,
-	.set_rflags = vt_set_rflags,
-	.get_if_flag = vt_get_if_flag,
+	.get_segment_base = vt_op(get_segment_base),
+	.get_segment = vt_op(get_segment),
+	.set_segment = vt_op(set_segment),
+	.get_cpl = vt_op(get_cpl),
+	.get_cpl_no_cache = vt_op(get_cpl_no_cache),
+	.get_cs_db_l_bits = vt_op(get_cs_db_l_bits),
+	.is_valid_cr0 = vt_op(is_valid_cr0),
+	.set_cr0 = vt_op(set_cr0),
+	.is_valid_cr4 = vt_op(is_valid_cr4),
+	.set_cr4 = vt_op(set_cr4),
+	.set_efer = vt_op(set_efer),
+	.get_idt = vt_op(get_idt),
+	.set_idt = vt_op(set_idt),
+	.get_gdt = vt_op(get_gdt),
+	.set_gdt = vt_op(set_gdt),
+	.set_dr6 = vt_op(set_dr6),
+	.set_dr7 = vt_op(set_dr7),
+	.sync_dirty_debug_regs = vt_op(sync_dirty_debug_regs),
+	.cache_reg = vt_op(cache_reg),
+	.get_rflags = vt_op(get_rflags),
+	.set_rflags = vt_op(set_rflags),
+	.get_if_flag = vt_op(get_if_flag),
 
-	.flush_tlb_all = vt_flush_tlb_all,
-	.flush_tlb_current = vt_flush_tlb_current,
-	.flush_tlb_gva = vt_flush_tlb_gva,
-	.flush_tlb_guest = vt_flush_tlb_guest,
+	.flush_tlb_all = vt_op(flush_tlb_all),
+	.flush_tlb_current = vt_op(flush_tlb_current),
+	.flush_tlb_gva = vt_op(flush_tlb_gva),
+	.flush_tlb_guest = vt_op(flush_tlb_guest),
 
-	.vcpu_pre_run = vt_vcpu_pre_run,
-	.vcpu_run = vt_vcpu_run,
-	.handle_exit = vt_handle_exit,
+	.vcpu_pre_run = vt_op(vcpu_pre_run),
+	.vcpu_run = vt_op(vcpu_run),
+	.handle_exit = vt_op(handle_exit),
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
-	.set_interrupt_shadow = vt_set_interrupt_shadow,
-	.get_interrupt_shadow = vt_get_interrupt_shadow,
-	.patch_hypercall = vt_patch_hypercall,
-	.inject_irq = vt_inject_irq,
-	.inject_nmi = vt_inject_nmi,
-	.inject_exception = vt_inject_exception,
-	.cancel_injection = vt_cancel_injection,
-	.interrupt_allowed = vt_interrupt_allowed,
-	.nmi_allowed = vt_nmi_allowed,
-	.get_nmi_mask = vt_get_nmi_mask,
-	.set_nmi_mask = vt_set_nmi_mask,
-	.enable_nmi_window = vt_enable_nmi_window,
-	.enable_irq_window = vt_enable_irq_window,
-	.update_cr8_intercept = vt_update_cr8_intercept,
+	.set_interrupt_shadow = vt_op(set_interrupt_shadow),
+	.get_interrupt_shadow = vt_op(get_interrupt_shadow),
+	.patch_hypercall = vt_op(patch_hypercall),
+	.inject_irq = vt_op(inject_irq),
+	.inject_nmi = vt_op(inject_nmi),
+	.inject_exception = vt_op(inject_exception),
+	.cancel_injection = vt_op(cancel_injection),
+	.interrupt_allowed = vt_op(interrupt_allowed),
+	.nmi_allowed = vt_op(nmi_allowed),
+	.get_nmi_mask = vt_op(get_nmi_mask),
+	.set_nmi_mask = vt_op(set_nmi_mask),
+	.enable_nmi_window = vt_op(enable_nmi_window),
+	.enable_irq_window = vt_op(enable_irq_window),
+	.update_cr8_intercept = vt_op(update_cr8_intercept),
 
 	.x2apic_icr_is_split = false,
-	.set_virtual_apic_mode = vt_set_virtual_apic_mode,
-	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
-	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
-	.load_eoi_exitmap = vt_load_eoi_exitmap,
+	.set_virtual_apic_mode = vt_op(set_virtual_apic_mode),
+	.set_apic_access_page_addr = vt_op(set_apic_access_page_addr),
+	.refresh_apicv_exec_ctrl = vt_op(refresh_apicv_exec_ctrl),
+	.load_eoi_exitmap = vt_op(load_eoi_exitmap),
 	.apicv_pre_state_restore = pi_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
-	.hwapic_isr_update = vt_hwapic_isr_update,
-	.sync_pir_to_irr = vt_sync_pir_to_irr,
-	.deliver_interrupt = vt_deliver_interrupt,
+	.hwapic_isr_update = vt_op(hwapic_isr_update),
+	.sync_pir_to_irr = vt_op(sync_pir_to_irr),
+	.deliver_interrupt = vt_op(deliver_interrupt),
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
 
-	.set_tss_addr = vt_set_tss_addr,
-	.set_identity_map_addr = vt_set_identity_map_addr,
+	.set_tss_addr = vt_op(set_tss_addr),
+	.set_identity_map_addr = vt_op(set_identity_map_addr),
 	.get_mt_mask = vmx_get_mt_mask,
 
-	.get_exit_info = vt_get_exit_info,
-	.get_entry_info = vt_get_entry_info,
+	.get_exit_info = vt_op(get_exit_info),
+	.get_entry_info = vt_op(get_entry_info),
 
-	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
+	.vcpu_after_set_cpuid = vt_op(vcpu_after_set_cpuid),
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-	.get_l2_tsc_offset = vt_get_l2_tsc_offset,
-	.get_l2_tsc_multiplier = vt_get_l2_tsc_multiplier,
-	.write_tsc_offset = vt_write_tsc_offset,
-	.write_tsc_multiplier = vt_write_tsc_multiplier,
+	.get_l2_tsc_offset = vt_op(get_l2_tsc_offset),
+	.get_l2_tsc_multiplier = vt_op(get_l2_tsc_multiplier),
+	.write_tsc_offset = vt_op(write_tsc_offset),
+	.write_tsc_multiplier = vt_op(write_tsc_multiplier),
 
-	.load_mmu_pgd = vt_load_mmu_pgd,
+	.load_mmu_pgd = vt_op(load_mmu_pgd),
 
 	.check_intercept = vmx_check_intercept,
 	.handle_exit_irqoff = vmx_handle_exit_irqoff,
 
-	.update_cpu_dirty_logging = vt_update_cpu_dirty_logging,
+	.update_cpu_dirty_logging = vt_op(update_cpu_dirty_logging),
 
 	.nested_ops = &vmx_nested_ops,
 
@@ -1011,38 +1017,38 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.pi_start_assignment = vmx_pi_start_assignment,
 
 #ifdef CONFIG_X86_64
-	.set_hv_timer = vt_set_hv_timer,
-	.cancel_hv_timer = vt_cancel_hv_timer,
+	.set_hv_timer = vt_op(set_hv_timer),
+	.cancel_hv_timer = vt_op(cancel_hv_timer),
 #endif
 
-	.setup_mce = vt_setup_mce,
+	.setup_mce = vt_op(setup_mce),
 
 #ifdef CONFIG_KVM_SMM
-	.smi_allowed = vt_smi_allowed,
-	.enter_smm = vt_enter_smm,
-	.leave_smm = vt_leave_smm,
-	.enable_smi_window = vt_enable_smi_window,
+	.smi_allowed = vt_op(smi_allowed),
+	.enter_smm = vt_op(enter_smm),
+	.leave_smm = vt_op(leave_smm),
+	.enable_smi_window = vt_op(enable_smi_window),
 #endif
 
-	.check_emulate_instruction = vt_check_emulate_instruction,
-	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
+	.check_emulate_instruction = vt_op(check_emulate_instruction),
+	.apic_init_signal_blocked = vt_op(apic_init_signal_blocked),
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vt_msr_filter_changed,
-	.complete_emulated_msr = vt_complete_emulated_msr,
+	.msr_filter_changed = vt_op(msr_filter_changed),
+	.complete_emulated_msr = vt_op(complete_emulated_msr),
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
 
 	.get_untagged_addr = vmx_get_untagged_addr,
 
-	.mem_enc_ioctl = vt_mem_enc_ioctl,
-	.vcpu_mem_enc_ioctl = vt_vcpu_mem_enc_ioctl,
+	.mem_enc_ioctl = vt_op_tdx_only(mem_enc_ioctl),
+	.vcpu_mem_enc_ioctl = vt_op_tdx_only(vcpu_mem_enc_ioctl),
 
-	.private_max_mapping_level = vt_gmem_private_max_mapping_level
+	.private_max_mapping_level = vt_op_tdx_only(gmem_private_max_mapping_level)
 };
 
 struct kvm_x86_init_ops vt_init_ops __initdata = {
-	.hardware_setup = vt_hardware_setup,
+	.hardware_setup = vt_op(hardware_setup),
 	.handle_intel_pt_intr = NULL,
 
 	.runtime_ops = &vt_x86_ops,

-- 
2.48.1


