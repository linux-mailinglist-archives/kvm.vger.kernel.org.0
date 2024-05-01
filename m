Return-Path: <kvm+bounces-16373-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDF458B909E
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 22:30:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 94775283206
	for <lists+kvm@lfdr.de>; Wed,  1 May 2024 20:30:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 04F501649B3;
	Wed,  1 May 2024 20:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bMw1ymiY"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 462271635BA
	for <kvm@vger.kernel.org>; Wed,  1 May 2024 20:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714595398; cv=none; b=IBYBwPaoyyzk1FL34Hm7jpGhMrisrwcW8RC8KAjmE3k7AKFVBrApfwjXI/D0NtyZkUQZiD3F1Job6OIdvYnUKfr61nadjcKkWtbq7ADcLc089iut8WUJqRVL/cZzo1mdGUYuWP7J47L2MqjJx8T8xHJEEET7hs4mx9a1SjxKCQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714595398; c=relaxed/simple;
	bh=SbhFBeoV06cdqFskMS8LP/LYQlIS+U/5J5aRWoNcANA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=p9wYshtknx3Xyf7RYi9rCPwAou6bngoLvahT7F+Z7TYfZL2rE/EJTkUcVdC9vafEzNEVwJ1gf0BldRLR3tqgagQW3Fpb//dpWnpGWS2VFSr3YQecWpFvb67fZVx06g5wb7dkuV+kLMXD3BF0yNpwfpefy0Ypc/q5xTCL5SDQL1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bMw1ymiY; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714595395; x=1746131395;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SbhFBeoV06cdqFskMS8LP/LYQlIS+U/5J5aRWoNcANA=;
  b=bMw1ymiYEjH8w8UbOpeqUVlJw/L90nnIPDrw3l7UGs4hyP3LwkITCpQp
   62AA4OrAdBs45lGchOueUYFjHGeSNQlRxf9Ie4hHNvD+d80eoJsz/fWw6
   E0tdRYrPnh9igyIPEwnBNWHJREXr5v2fRQ2EgqFWK5i/rLikotsaL9enx
   Lpj+tUM3f4UvfUyxJdo/ZYmVWgDW5JwFO5UKMajzgxZyWq8A0jOqbEfWv
   EQ6vCPOxKLTqOeMwS3UsUigjPOix2jYS6ix24Ivej15WlNSNBuuOFZ+V5
   9iXSJGmqctFsExi9Rj75bMFEB2quph0loPbLUgAS0WE5uFLrFO2GyNduh
   g==;
X-CSE-ConnectionGUID: Q2h/l9hASlqDbl8ryUipGg==
X-CSE-MsgGUID: nquKuBsfRxSesfkyE3HFSw==
X-IronPort-AV: E=McAfee;i="6600,9927,11061"; a="10472610"
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="10472610"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:29:52 -0700
X-CSE-ConnectionGUID: j3MFCtwHQaOfm9hJtTC8GQ==
X-CSE-MsgGUID: rWHuSSHITP+VK9y7bExJ3w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,246,1708416000"; 
   d="scan'208";a="26890447"
Received: from otc-tsn-4.jf.intel.com ([10.23.153.135])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 May 2024 13:29:52 -0700
From: Kishen Maloor <kishen.maloor@intel.com>
To: kvm@vger.kernel.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	mlevitsk@redhat.com,
	zheyuma97@gmail.com
Cc: Kishen Maloor <kishen.maloor@intel.com>
Subject: [PATCH v3 1/2] KVM: x86: nSVM/nVMX: Move nested_run_pending to kvm_vcpu_arch
Date: Wed,  1 May 2024 16:29:33 -0400
Message-Id: <20240501202934.1365061-2-kishen.maloor@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20240501202934.1365061-1-kishen.maloor@intel.com>
References: <20240501202934.1365061-1-kishen.maloor@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nested_run_pending is used in SVM/VMX code to signify
that a nested VM-Entry has been initiated but not yet performed,
and a nested VM-Exit cannot be injected. nested_run_pending is
presently stored in vendor structs and its usage is replicated
in vendor code.

This change merely moves nested_run_pending into kvm_vcpu_arch
so that it may also be operated upon by common x86 code.
The RSM emulation is one such case.

Signed-off-by: Kishen Maloor <kishen.maloor@intel.com>
---
 arch/x86/include/asm/kvm_host.h |  1 +
 arch/x86/kvm/svm/nested.c       | 14 +++++------
 arch/x86/kvm/svm/svm.c          | 12 +++++-----
 arch/x86/kvm/svm/svm.h          |  4 ----
 arch/x86/kvm/vmx/nested.c       | 42 ++++++++++++++++-----------------
 arch/x86/kvm/vmx/vmx.c          | 14 +++++------
 arch/x86/kvm/vmx/vmx.h          |  3 ---
 7 files changed, 42 insertions(+), 48 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6efd1497b026..f2c9e3813800 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -770,6 +770,7 @@ struct kvm_vcpu_arch {
 	u64 ia32_misc_enable_msr;
 	u64 smbase;
 	u64 smi_count;
+	bool nested_run_pending;
 	bool at_instruction_boundary;
 	bool tpr_access_reporting;
 	bool xfd_no_write_intercept;
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 55b9a6d96bcf..ab8c8c9e1e46 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -901,7 +901,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 	if (!npt_enabled)
 		vmcb01->save.cr3 = kvm_read_cr3(vcpu);
 
-	svm->nested.nested_run_pending = 1;
+	vcpu->arch.nested_run_pending = 1;
 
 	if (enter_svm_guest_mode(vcpu, vmcb12_gpa, vmcb12, true))
 		goto out_exit_err;
@@ -910,7 +910,7 @@ int nested_svm_vmrun(struct kvm_vcpu *vcpu)
 		goto out;
 
 out_exit_err:
-	svm->nested.nested_run_pending = 0;
+	vcpu->arch.nested_run_pending = 0;
 	svm->nmi_l1_to_l2 = false;
 	svm->soft_int_injected = false;
 
@@ -985,7 +985,7 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 	/* Exit Guest-Mode */
 	leave_guest_mode(vcpu);
 	svm->nested.vmcb12_gpa = 0;
-	WARN_ON_ONCE(svm->nested.nested_run_pending);
+	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
 
 	kvm_clear_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu);
 
@@ -1231,7 +1231,7 @@ void svm_leave_nested(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	if (is_guest_mode(vcpu)) {
-		svm->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 		svm->nested.vmcb12_gpa = INVALID_GPA;
 
 		leave_guest_mode(vcpu);
@@ -1427,7 +1427,7 @@ static int svm_check_nested_events(struct kvm_vcpu *vcpu)
 	 * previously injected event, the pending exception occurred while said
 	 * event was being delivered and thus needs to be handled.
 	 */
-	bool block_nested_exceptions = svm->nested.nested_run_pending;
+	bool block_nested_exceptions = vcpu->arch.nested_run_pending;
 	/*
 	 * New events (not exceptions) are only recognized at instruction
 	 * boundaries.  If an event needs reinjection, then KVM is handling a
@@ -1604,7 +1604,7 @@ static int svm_get_nested_state(struct kvm_vcpu *vcpu,
 		kvm_state.size += KVM_STATE_NESTED_SVM_VMCB_SIZE;
 		kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
-		if (svm->nested.nested_run_pending)
+		if (vcpu->arch.nested_run_pending)
 			kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
 	}
 
@@ -1743,7 +1743,7 @@ static int svm_set_nested_state(struct kvm_vcpu *vcpu,
 
 	svm_set_gif(svm, !!(kvm_state->flags & KVM_STATE_NESTED_GIF_SET));
 
-	svm->nested.nested_run_pending =
+	vcpu->arch.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
 	svm->nested.vmcb12_gpa = kvm_state->hdr.svm.vmcb_pa;
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9aaf83c8d57d..debc53b73ea3 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -3750,7 +3750,7 @@ bool svm_nmi_blocked(struct kvm_vcpu *vcpu)
 static int svm_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (svm->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	if (svm_nmi_blocked(vcpu))
@@ -3792,7 +3792,7 @@ static int svm_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	if (svm->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	if (svm_interrupt_blocked(vcpu))
@@ -4215,11 +4215,11 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu,
 		nested_sync_control_from_vmcb02(svm);
 
 		/* Track VMRUNs that have made past consistency checking */
-		if (svm->nested.nested_run_pending &&
+		if (vcpu->arch.nested_run_pending &&
 		    svm->vmcb->control.exit_code != SVM_EXIT_ERR)
                         ++vcpu->stat.nested_run;
 
-		svm->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 	}
 
 	svm->vmcb->control.tlb_ctl = TLB_CONTROL_DO_NOTHING;
@@ -4581,7 +4581,7 @@ bool svm_smi_blocked(struct kvm_vcpu *vcpu)
 static int svm_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	if (svm->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	if (svm_smi_blocked(vcpu))
@@ -4699,7 +4699,7 @@ static int svm_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 	if (ret)
 		goto unmap_save;
 
-	svm->nested.nested_run_pending = 1;
+	vcpu->arch.nested_run_pending = 1;
 
 unmap_save:
 	kvm_vcpu_unmap(vcpu, &map_save, true);
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 33878efdebc8..b78e7c562cea 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -165,10 +165,6 @@ struct svm_nested_state {
 	/* These are the merged vectors */
 	u32 *msrpm;
 
-	/* A VMRUN has started but has not yet been performed, so
-	 * we cannot inject a nested vmexit yet.  */
-	bool nested_run_pending;
-
 	/* cache for control fields of the guest */
 	struct vmcb_ctrl_area_cached ctl;
 
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index d05ddf751491..5510d3667eb8 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -2188,7 +2188,7 @@ static void vmx_start_preemption_timer(struct kvm_vcpu *vcpu,
 
 static u64 nested_vmx_calc_efer(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 {
-	if (vmx->nested.nested_run_pending &&
+	if (vmx->vcpu.arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER))
 		return vmcs12->guest_ia32_efer;
 	else if (vmcs12->vm_entry_controls & VM_ENTRY_IA32E_MODE)
@@ -2422,7 +2422,7 @@ static void prepare_vmcs02_early(struct vcpu_vmx *vmx, struct loaded_vmcs *vmcs0
 	/*
 	 * Interrupt/Exception Fields
 	 */
-	if (vmx->nested.nested_run_pending) {
+	if (vmx->vcpu.arch.nested_run_pending) {
 		vmcs_write32(VM_ENTRY_INTR_INFO_FIELD,
 			     vmcs12->vm_entry_intr_info_field);
 		vmcs_write32(VM_ENTRY_EXCEPTION_ERROR_CODE,
@@ -2503,7 +2503,7 @@ static void prepare_vmcs02_rare(struct vcpu_vmx *vmx, struct vmcs12 *vmcs12)
 			vmcs_write64(GUEST_PDPTR3, vmcs12->guest_pdptr3);
 		}
 
-		if (kvm_mpx_supported() && vmx->nested.nested_run_pending &&
+		if (kvm_mpx_supported() && vmx->vcpu.arch.nested_run_pending &&
 		    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS))
 			vmcs_write64(GUEST_BNDCFGS, vmcs12->guest_bndcfgs);
 	}
@@ -2583,7 +2583,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 			!(evmcs->hv_clean_fields & HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1);
 	}
 
-	if (vmx->nested.nested_run_pending &&
+	if (vmx->vcpu.arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS)) {
 		kvm_set_dr(vcpu, 7, vmcs12->guest_dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmcs12->guest_ia32_debugctl);
@@ -2591,7 +2591,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 		kvm_set_dr(vcpu, 7, vcpu->arch.dr7);
 		vmcs_write64(GUEST_IA32_DEBUGCTL, vmx->nested.pre_vmenter_debugctl);
 	}
-	if (kvm_mpx_supported() && (!vmx->nested.nested_run_pending ||
+	if (kvm_mpx_supported() && (!vmx->vcpu.arch.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmcs_write64(GUEST_BNDCFGS, vmx->nested.pre_vmenter_bndcfgs);
 	vmx_set_rflags(vcpu, vmcs12->guest_rflags);
@@ -2604,7 +2604,7 @@ static int prepare_vmcs02(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12,
 	vcpu->arch.cr0_guest_owned_bits &= ~vmcs12->cr0_guest_host_mask;
 	vmcs_writel(CR0_GUEST_HOST_MASK, ~vcpu->arch.cr0_guest_owned_bits);
 
-	if (vmx->nested.nested_run_pending &&
+	if (vmx->vcpu.arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_PAT)) {
 		vmcs_write64(GUEST_IA32_PAT, vmcs12->guest_ia32_pat);
 		vcpu->arch.pat = vmcs12->guest_ia32_pat;
@@ -3101,7 +3101,7 @@ static int nested_vmx_check_guest_state(struct kvm_vcpu *vcpu,
 	 *   to bit 8 (LME) if bit 31 in the CR0 field (corresponding to
 	 *   CR0.PG) is 1.
 	 */
-	if (to_vmx(vcpu)->nested.nested_run_pending &&
+	if (vcpu->arch.nested_run_pending &&
 	    (vmcs12->vm_entry_controls & VM_ENTRY_LOAD_IA32_EFER)) {
 		if (CC(!kvm_valid_efer(vcpu, vmcs12->guest_ia32_efer)) ||
 		    CC(ia32e != !!(vmcs12->guest_ia32_efer & EFER_LMA)) ||
@@ -3456,11 +3456,11 @@ enum nvmx_vmentry_status nested_vmx_enter_non_root_mode(struct kvm_vcpu *vcpu,
 	if (!evaluate_pending_interrupts)
 		evaluate_pending_interrupts |= kvm_apic_has_pending_init_or_sipi(vcpu);
 
-	if (!vmx->nested.nested_run_pending ||
+	if (!vcpu->arch.nested_run_pending ||
 	    !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_DEBUG_CONTROLS))
 		vmx->nested.pre_vmenter_debugctl = vmcs_read64(GUEST_IA32_DEBUGCTL);
 	if (kvm_mpx_supported() &&
-	    (!vmx->nested.nested_run_pending ||
+	    (!vcpu->arch.nested_run_pending ||
 	     !(vmcs12->vm_entry_controls & VM_ENTRY_LOAD_BNDCFGS)))
 		vmx->nested.pre_vmenter_bndcfgs = vmcs_read64(GUEST_BNDCFGS);
 
@@ -3667,7 +3667,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	 * We're finally done with prerequisite checking, and can start with
 	 * the nested entry.
 	 */
-	vmx->nested.nested_run_pending = 1;
+	vcpu->arch.nested_run_pending = 1;
 	vmx->nested.has_preemption_timer_deadline = false;
 	status = nested_vmx_enter_non_root_mode(vcpu, true);
 	if (unlikely(status != NVMX_VMENTRY_SUCCESS))
@@ -3707,12 +3707,12 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 		    !nested_cpu_has(vmcs12, CPU_BASED_NMI_WINDOW_EXITING) &&
 		    !(nested_cpu_has(vmcs12, CPU_BASED_INTR_WINDOW_EXITING) &&
 		      (vmcs12->guest_rflags & X86_EFLAGS_IF))) {
-			vmx->nested.nested_run_pending = 0;
+			vcpu->arch.nested_run_pending = 0;
 			return kvm_emulate_halt_noskip(vcpu);
 		}
 		break;
 	case GUEST_ACTIVITY_WAIT_SIPI:
-		vmx->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 		vcpu->arch.mp_state = KVM_MP_STATE_INIT_RECEIVED;
 		break;
 	default:
@@ -3722,7 +3722,7 @@ static int nested_vmx_run(struct kvm_vcpu *vcpu, bool launch)
 	return 1;
 
 vmentry_failed:
-	vmx->nested.nested_run_pending = 0;
+	vcpu->arch.nested_run_pending = 0;
 	if (status == NVMX_VMENTRY_KVM_INTERNAL_ERROR)
 		return 0;
 	if (status == NVMX_VMENTRY_VMEXIT)
@@ -4104,7 +4104,7 @@ static int vmx_check_nested_events(struct kvm_vcpu *vcpu)
 	 * previously injected event, the pending exception occurred while said
 	 * event was being delivered and thus needs to be handled.
 	 */
-	bool block_nested_exceptions = vmx->nested.nested_run_pending;
+	bool block_nested_exceptions = vcpu->arch.nested_run_pending;
 	/*
 	 * New events (not exceptions) are only recognized at instruction
 	 * boundaries.  If an event needs reinjection, then KVM is handling a
@@ -4401,7 +4401,7 @@ static void sync_vmcs02_to_vmcs12(struct kvm_vcpu *vcpu, struct vmcs12 *vmcs12)
 
 	if (nested_cpu_has_preemption_timer(vmcs12) &&
 	    vmcs12->vm_exit_controls & VM_EXIT_SAVE_VMX_PREEMPTION_TIMER &&
-	    !vmx->nested.nested_run_pending)
+	    !vcpu->arch.nested_run_pending)
 		vmcs12->vmx_preemption_timer_value =
 			vmx_get_preemption_timer_value(vcpu);
 
@@ -4774,7 +4774,7 @@ void nested_vmx_vmexit(struct kvm_vcpu *vcpu, u32 vm_exit_reason,
 	vmx->nested.mtf_pending = false;
 
 	/* trying to cancel vmlaunch/vmresume is a bug */
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
 
 #ifdef CONFIG_KVM_HYPERV
 	if (kvm_check_request(KVM_REQ_GET_NESTED_STATE_PAGES, vcpu)) {
@@ -6397,7 +6397,7 @@ bool nested_vmx_reflect_vmexit(struct kvm_vcpu *vcpu)
 	unsigned long exit_qual;
 	u32 exit_intr_info;
 
-	WARN_ON_ONCE(vmx->nested.nested_run_pending);
+	WARN_ON_ONCE(vcpu->arch.nested_run_pending);
 
 	/*
 	 * Late nested VM-Fail shares the same flow as nested VM-Exit since KVM
@@ -6493,7 +6493,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 		if (is_guest_mode(vcpu)) {
 			kvm_state.flags |= KVM_STATE_NESTED_GUEST_MODE;
 
-			if (vmx->nested.nested_run_pending)
+			if (vcpu->arch.nested_run_pending)
 				kvm_state.flags |= KVM_STATE_NESTED_RUN_PENDING;
 
 			if (vmx->nested.mtf_pending)
@@ -6568,7 +6568,7 @@ static int vmx_get_nested_state(struct kvm_vcpu *vcpu,
 void vmx_leave_nested(struct kvm_vcpu *vcpu)
 {
 	if (is_guest_mode(vcpu)) {
-		to_vmx(vcpu)->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 		nested_vmx_vmexit(vcpu, -1, 0, 0);
 	}
 	free_nested(vcpu);
@@ -6705,7 +6705,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	if (!(kvm_state->flags & KVM_STATE_NESTED_GUEST_MODE))
 		return 0;
 
-	vmx->nested.nested_run_pending =
+	vcpu->arch.nested_run_pending =
 		!!(kvm_state->flags & KVM_STATE_NESTED_RUN_PENDING);
 
 	vmx->nested.mtf_pending =
@@ -6757,7 +6757,7 @@ static int vmx_set_nested_state(struct kvm_vcpu *vcpu,
 	return 0;
 
 error_guest_mode:
-	vmx->nested.nested_run_pending = 0;
+	vcpu->arch.nested_run_pending = 0;
 	return ret;
 }
 
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 22411f4aff53..e83439ecd956 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -5030,7 +5030,7 @@ bool vmx_nmi_blocked(struct kvm_vcpu *vcpu)
 
 static int vmx_nmi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
-	if (to_vmx(vcpu)->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	/* An NMI must not be injected into L2 if it's supposed to VM-Exit.  */
@@ -5052,7 +5052,7 @@ bool vmx_interrupt_blocked(struct kvm_vcpu *vcpu)
 
 static int vmx_interrupt_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
-	if (to_vmx(vcpu)->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 
 	/*
@@ -6446,7 +6446,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	 * invalid guest state should never happen as that means KVM knowingly
 	 * allowed a nested VM-Enter with an invalid vmcs12.  More below.
 	 */
-	if (KVM_BUG_ON(vmx->nested.nested_run_pending, vcpu->kvm))
+	if (KVM_BUG_ON(vcpu->arch.nested_run_pending, vcpu->kvm))
 		return -EIO;
 
 	if (is_guest_mode(vcpu)) {
@@ -7437,11 +7437,11 @@ static fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 		 * Track VMLAUNCH/VMRESUME that have made past guest state
 		 * checking.
 		 */
-		if (vmx->nested.nested_run_pending &&
+		if (vcpu->arch.nested_run_pending &&
 		    !vmx->exit_reason.failed_vmentry)
 			++vcpu->stat.nested_run;
 
-		vmx->nested.nested_run_pending = 0;
+		vcpu->arch.nested_run_pending = 0;
 	}
 
 	if (unlikely(vmx->fail))
@@ -8173,7 +8173,7 @@ static void vmx_setup_mce(struct kvm_vcpu *vcpu)
 static int vmx_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
 	/* we need a nested vmexit to enter SMM, postpone if run is pending */
-	if (to_vmx(vcpu)->nested.nested_run_pending)
+	if (vcpu->arch.nested_run_pending)
 		return -EBUSY;
 	return !is_smm(vcpu);
 }
@@ -8214,7 +8214,7 @@ static int vmx_leave_smm(struct kvm_vcpu *vcpu, const union kvm_smram *smram)
 		if (ret)
 			return ret;
 
-		vmx->nested.nested_run_pending = 1;
+		vcpu->arch.nested_run_pending = 1;
 		vmx->nested.smm.guest_mode = false;
 	}
 	return 0;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index 90f9e4434646..571ab070c2af 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -188,9 +188,6 @@ struct nested_vmx {
 	 */
 	bool enlightened_vmcs_enabled;
 
-	/* L2 must run next, and mustn't decide to exit to L1. */
-	bool nested_run_pending;
-
 	/* Pending MTF VM-exit into L1.  */
 	bool mtf_pending;
 
-- 
2.31.1


