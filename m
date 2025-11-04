Return-Path: <kvm+bounces-62024-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C03EFC32DD7
	for <lists+kvm@lfdr.de>; Tue, 04 Nov 2025 21:03:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BA2AF4232A0
	for <lists+kvm@lfdr.de>; Tue,  4 Nov 2025 20:02:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 617412FFDEC;
	Tue,  4 Nov 2025 20:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="hEVx6NHW"
X-Original-To: kvm@vger.kernel.org
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E7CF2E8B87
	for <kvm@vger.kernel.org>; Tue,  4 Nov 2025 20:00:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762286421; cv=none; b=gaDml2Pdd4Cy6SxOxbcbVZWoPoxZEaV90TOpu5Hm8JLlbGbC5lDuAcsfqfV6wfbYv3bJEeMj/xrNkM4P3poS3TsDRfm2uAvrPdhhjxCCFX+0ypfqahtpx6Bwq4JcMTOX/aF2YoeXd8kPUdIgwYCpjRf/OTsgromc0EyE5unKHE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762286421; c=relaxed/simple;
	bh=OBSn805QTzEfMF5BPVF8NQwusAf8CMO7gr9kFmd/rP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hBjFEOMSq8OAIKZVpLxtqVX7xtRqqG2vgx9IX/g9BwXDVWJfY4CkO5VRbFIX8P2k0s7HLcNBbArxQJyZ02CiHxF4eagmS0CBck4kyDE0qbf2c7xH+1LFvc9FwcF3BOF8VuKToZ5DSOpfYix9y6vZ5PDbMY8qZBFkgL2L2pNBbDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=hEVx6NHW; arc=none smtp.client-ip=91.218.175.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762286414;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+CHg00Q6HEbbpX3FKfbezh3vk+B9Fc0077GpZZwxD2E=;
	b=hEVx6NHW6VlYRYA8G6gaD7ZC9mTldKaF4VcghcQDvURSKHYKupGT+cZt+KHFYHONPWGxrP
	UnY3FpDwbnz7BRoajfxfEttePWFSFpBqvvfBja126OOHlUzAs21edMgIN9fEtVWIZwn69l
	GVTXJ2u6fYdcbZw34LO9TZ3HwxZb0AM=
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>,
	Jim Mattson <jmattson@google.com>,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yosry Ahmed <yosry.ahmed@linux.dev>
Subject: [PATCH 05/11] KVM: SVM: Rename vmcb->virt_ext to vmcb->misc_ctl2
Date: Tue,  4 Nov 2025 19:59:43 +0000
Message-ID: <20251104195949.3528411-6-yosry.ahmed@linux.dev>
In-Reply-To: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
References: <20251104195949.3528411-1-yosry.ahmed@linux.dev>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

'virt' is confusing in the VMCB because it is relative and ambiguous.
The 'virt_ext' field includes bits for LBR virtualization and
VMSAVE/VMLOAD virtualization, so it's just another miscellaneous control
field. Name it as such.

While at it, move the definitions of the bits below those for
'misc_ctl'.

Signed-off-by: Yosry Ahmed <yosry.ahmed@linux.dev>
---
 arch/x86/include/asm/svm.h                    |  7 ++---
 arch/x86/kvm/svm/nested.c                     | 28 +++++++++----------
 arch/x86/kvm/svm/svm.c                        | 22 +++++++--------
 arch/x86/kvm/svm/svm.h                        |  2 +-
 tools/testing/selftests/kvm/include/x86/svm.h |  8 +++---
 5 files changed, 33 insertions(+), 34 deletions(-)

diff --git a/arch/x86/include/asm/svm.h b/arch/x86/include/asm/svm.h
index ead275da9850e..5f3781587dd01 100644
--- a/arch/x86/include/asm/svm.h
+++ b/arch/x86/include/asm/svm.h
@@ -148,7 +148,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -219,9 +219,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define X2APIC_MODE_SHIFT 30
 #define X2APIC_MODE_MASK (1 << X2APIC_MODE_SHIFT)
 
-#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
-#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
-
 #define SVM_INTERRUPT_SHADOW_MASK	BIT_ULL(0)
 #define SVM_GUEST_INTERRUPT_MASK	BIT_ULL(1)
 
@@ -240,6 +237,8 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
 #define SVM_MISC_CTL_SEV_ES_ENABLE	BIT(2)
 
+#define SVM_MISC_CTL2_LBR_CTL_ENABLE		BIT_ULL(0)
+#define SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE	BIT_ULL(1)
 
 #define SVM_TSC_RATIO_RSVD	0xffffff0000000000ULL
 #define SVM_TSC_RATIO_MIN	0x0000000000000001ULL
diff --git a/arch/x86/kvm/svm/nested.c b/arch/x86/kvm/svm/nested.c
index 9e6b996753e4e..986e6382dc4fa 100644
--- a/arch/x86/kvm/svm/nested.c
+++ b/arch/x86/kvm/svm/nested.c
@@ -117,7 +117,7 @@ static bool nested_vmcb_needs_vls_intercept(struct vcpu_svm *svm)
 	if (!nested_npt_enabled(svm))
 		return true;
 
-	if (!(svm->nested.ctl.virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK))
+	if (!(svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE))
 		return true;
 
 	return false;
@@ -180,7 +180,7 @@ void recalc_intercepts(struct vcpu_svm *svm)
 		vmcb_set_intercept(c, INTERCEPT_VMLOAD);
 		vmcb_set_intercept(c, INTERCEPT_VMSAVE);
 	} else {
-		WARN_ON(!(c->virt_ext & VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK));
+		WARN_ON(!(c->misc_ctl2 & SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE));
 	}
 }
 
@@ -479,7 +479,7 @@ void __nested_copy_vmcb_control_to_cache(struct kvm_vcpu *vcpu,
 	to->event_inj_err       = from->event_inj_err;
 	to->next_rip            = from->next_rip;
 	to->nested_cr3          = from->nested_cr3;
-	to->virt_ext            = from->virt_ext;
+	to->misc_ctl2            = from->misc_ctl2;
 	to->pause_filter_count  = from->pause_filter_count;
 	to->pause_filter_thresh = from->pause_filter_thresh;
 
@@ -721,7 +721,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 	}
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		     (svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE))) {
 		/*
 		 * Reserved bits of DEBUGCTL are ignored.  Be consistent with
 		 * svm_set_msr's definition of reserved bits.
@@ -730,7 +730,7 @@ static void nested_vmcb02_prepare_save(struct vcpu_svm *svm, struct vmcb *vmcb12
 		vmcb02->save.dbgctl &= ~DEBUGCTL_RESERVED_BITS;
 		svm_update_lbrv(&svm->vcpu);
 
-	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
+	} else if (unlikely(vmcb01->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE)) {
 		svm_copy_lbrs(vmcb02, vmcb01);
 	}
 }
@@ -885,14 +885,14 @@ static void nested_vmcb02_prepare_control(struct vcpu_svm *svm,
 			svm->soft_int_next_rip = vmcb12_rip;
 	}
 
-	vmcb02->control.virt_ext            = vmcb01->control.virt_ext &
-					      LBR_CTL_ENABLE_MASK;
+	vmcb02->control.misc_ctl2 = vmcb01->control.misc_ctl2 &
+					       SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV))
-		vmcb02->control.virt_ext  |=
-			(svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK);
+		vmcb02->control.misc_ctl2 |=
+			(svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE);
 
 	if (!nested_vmcb_needs_vls_intercept(svm))
-		vmcb02->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		vmcb02->control.misc_ctl2 |= SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE;
 
 	if (guest_cpu_cap_has(vcpu, X86_FEATURE_PAUSEFILTER))
 		pause_count12 = svm->nested.ctl.pause_filter_count;
@@ -1241,10 +1241,10 @@ int nested_svm_vmexit(struct vcpu_svm *svm)
 		kvm_make_request(KVM_REQ_EVENT, &svm->vcpu);
 
 	if (unlikely(guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-		     (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK))) {
+		     (svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE))) {
 		svm_copy_lbrs(vmcb12, vmcb02);
 		svm_update_lbrv(vcpu);
-	} else if (unlikely(vmcb01->control.virt_ext & LBR_CTL_ENABLE_MASK)) {
+	} else if (unlikely(vmcb01->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE)) {
 		svm_copy_lbrs(vmcb01, vmcb02);
 		svm_update_lbrv(vcpu);
 	}
@@ -1746,8 +1746,8 @@ static void nested_copy_vmcb_cache_to_control(struct vmcb_control_area *dst,
 	dst->event_inj            = from->event_inj;
 	dst->event_inj_err        = from->event_inj_err;
 	dst->next_rip             = from->next_rip;
-	dst->nested_cr3           = from->nested_cr3;
-	dst->virt_ext              = from->virt_ext;
+	dst->nested_cr3		  = from->nested_cr3;
+	dst->misc_ctl2		  = from->misc_ctl2;
 	dst->pause_filter_count   = from->pause_filter_count;
 	dst->pause_filter_thresh  = from->pause_filter_thresh;
 	/* 'clean' and 'hv_enlightenments' are not changed by KVM */
diff --git a/arch/x86/kvm/svm/svm.c b/arch/x86/kvm/svm/svm.c
index 9ef7683fb2ff0..185f17ff2170b 100644
--- a/arch/x86/kvm/svm/svm.c
+++ b/arch/x86/kvm/svm/svm.c
@@ -705,7 +705,7 @@ void *svm_alloc_permissions_map(unsigned long size, gfp_t gfp_mask)
 
 static void svm_recalc_lbr_msr_intercepts(struct kvm_vcpu *vcpu)
 {
-	bool intercept = !(to_svm(vcpu)->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK);
+	bool intercept = !(to_svm(vcpu)->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE);
 
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHFROMIP, MSR_TYPE_RW, intercept);
 	svm_set_intercept_for_msr(vcpu, MSR_IA32_LASTBRANCHTOIP, MSR_TYPE_RW, intercept);
@@ -810,7 +810,7 @@ void svm_enable_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
 
-	svm->vmcb->control.virt_ext |= LBR_CTL_ENABLE_MASK;
+	svm->vmcb->control.misc_ctl2 |= SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/* Move the LBR msrs to the vmcb02 so that the guest can see them. */
@@ -823,7 +823,7 @@ static void svm_disable_lbrv(struct kvm_vcpu *vcpu)
 	struct vcpu_svm *svm = to_svm(vcpu);
 
 	KVM_BUG_ON(sev_es_guest(vcpu->kvm), vcpu->kvm);
-	svm->vmcb->control.virt_ext &= ~LBR_CTL_ENABLE_MASK;
+	svm->vmcb->control.misc_ctl2 &= ~SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	svm_recalc_lbr_msr_intercepts(vcpu);
 
 	/*
@@ -841,17 +841,17 @@ static struct vmcb *svm_get_lbr_vmcb(struct vcpu_svm *svm)
 	 * vmcb01.  If LBR virtualization is enabled and L1 is running VMs of
 	 * its own, the MSRs are moved between vmcb01 and vmcb02 as needed.
 	 */
-	return svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK ? svm->vmcb :
+	return svm->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE ? svm->vmcb :
 								   svm->vmcb01.ptr;
 }
 
 void svm_update_lbrv(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_svm *svm = to_svm(vcpu);
-	bool current_enable_lbrv = svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK;
+	bool current_enable_lbrv = svm->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE;
 	bool enable_lbrv = (svm_get_lbr_vmcb(svm)->save.dbgctl & DEBUGCTLMSR_LBR) ||
 			    (is_guest_mode(vcpu) && guest_cpu_cap_has(vcpu, X86_FEATURE_LBRV) &&
-			    (svm->nested.ctl.virt_ext & LBR_CTL_ENABLE_MASK));
+			    (svm->nested.ctl.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE));
 
 	if (enable_lbrv == current_enable_lbrv)
 		return;
@@ -1005,7 +1005,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 	if (guest_cpuid_is_intel_compatible(vcpu)) {
 		svm_set_intercept(svm, INTERCEPT_VMLOAD);
 		svm_set_intercept(svm, INTERCEPT_VMSAVE);
-		svm->vmcb->control.virt_ext &= ~VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+		svm->vmcb->control.misc_ctl2 &= ~SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE;
 	} else {
 		/*
 		 * If hardware supports Virtual VMLOAD VMSAVE then enable it
@@ -1014,7 +1014,7 @@ static void svm_recalc_instruction_intercepts(struct kvm_vcpu *vcpu)
 		if (vls) {
 			svm_clr_intercept(svm, INTERCEPT_VMLOAD);
 			svm_clr_intercept(svm, INTERCEPT_VMSAVE);
-			svm->vmcb->control.virt_ext |= VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK;
+			svm->vmcb->control.misc_ctl2 |= SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE;
 		}
 	}
 }
@@ -3286,7 +3286,7 @@ static void dump_vmcb(struct kvm_vcpu *vcpu)
 	pr_err("%-20s%016llx\n", "ghcb:", control->ghcb_gpa);
 	pr_err("%-20s%08x\n", "event_inj:", control->event_inj);
 	pr_err("%-20s%08x\n", "event_inj_err:", control->event_inj_err);
-	pr_err("%-20s%lld\n", "virt_ext:", control->virt_ext);
+	pr_err("%-20s%lld\n", "misc_ctl2:", control->misc_ctl2);
 	pr_err("%-20s%016llx\n", "next_rip:", control->next_rip);
 	pr_err("%-20s%016llx\n", "avic_backing_page:", control->avic_backing_page);
 	pr_err("%-20s%016llx\n", "avic_logical_id:", control->avic_logical_id);
@@ -4268,7 +4268,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	 * VM-Exit), as running with the host's DEBUGCTL can negatively affect
 	 * guest state and can even be fatal, e.g. due to Bus Lock Detect.
 	 */
-	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	if (!(svm->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE) &&
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(svm->vmcb->save.dbgctl);
 
@@ -4299,7 +4299,7 @@ static __no_kcsan fastpath_t svm_vcpu_run(struct kvm_vcpu *vcpu, u64 run_flags)
 	if (unlikely(svm->vmcb->control.exit_code == SVM_EXIT_NMI))
 		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
 
-	if (!(svm->vmcb->control.virt_ext & LBR_CTL_ENABLE_MASK) &&
+	if (!(svm->vmcb->control.misc_ctl2 & SVM_MISC_CTL2_LBR_CTL_ENABLE) &&
 	    vcpu->arch.host_debugctl != svm->vmcb->save.dbgctl)
 		update_debugctlmsr(vcpu->arch.host_debugctl);
 
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 980560a815868..26ba9472784eb 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -174,7 +174,7 @@ struct vmcb_ctrl_area_cached {
 	u32 event_inj_err;
 	u64 next_rip;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u64 bus_lock_rip;
 	union {
diff --git a/tools/testing/selftests/kvm/include/x86/svm.h b/tools/testing/selftests/kvm/include/x86/svm.h
index 5d2bcce34c019..a3f4eadffeb46 100644
--- a/tools/testing/selftests/kvm/include/x86/svm.h
+++ b/tools/testing/selftests/kvm/include/x86/svm.h
@@ -104,7 +104,7 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 	u32 event_inj;
 	u32 event_inj_err;
 	u64 nested_cr3;
-	u64 virt_ext;
+	u64 misc_ctl2;
 	u32 clean;
 	u32 reserved_5;
 	u64 next_rip;
@@ -156,9 +156,6 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define AVIC_ENABLE_SHIFT 31
 #define AVIC_ENABLE_MASK (1 << AVIC_ENABLE_SHIFT)
 
-#define LBR_CTL_ENABLE_MASK BIT_ULL(0)
-#define VIRTUAL_VMLOAD_VMSAVE_ENABLE_MASK BIT_ULL(1)
-
 #define SVM_INTERRUPT_SHADOW_MASK 1
 
 #define SVM_IOIO_STR_SHIFT 2
@@ -179,6 +176,9 @@ struct __attribute__ ((__packed__)) vmcb_control_area {
 #define SVM_MISC_CTL_CTL_NP_ENABLE	BIT(0)
 #define SVM_MISC_CTL_SEV_ENABLE		BIT(1)
 
+#define SVM_MISC_CTL2_LBR_CTL_ENABLE BIT_ULL(0)
+#define SVM_MISC_CTL2_V_VMLOAD_VMSAVE_ENABLE BIT_ULL(1)
+
 struct __attribute__ ((__packed__)) vmcb_seg {
 	u16 selector;
 	u16 attrib;
-- 
2.51.2.1026.g39e6a42477-goog


