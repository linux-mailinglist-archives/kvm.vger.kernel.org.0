Return-Path: <kvm+bounces-37801-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C0AF4A301EC
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 04:00:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 17C56188C860
	for <lists+kvm@lfdr.de>; Tue, 11 Feb 2025 03:00:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BFD851EDA05;
	Tue, 11 Feb 2025 02:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HFTfiN7v"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DE621EC00C;
	Tue, 11 Feb 2025 02:57:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739242660; cv=none; b=meTio8JGX2UA0pu3j5hTZYevqKvIHVhwSxAweFT+iTAuTo0we7OP27kH2cr8bcFTSOwMwakCSBM4A6N9aaiUXjpLX+aAbgvP/4AYU2Pch/6n0ugdjELmWp9x0X21WHrg90g7+oUEYgf6gQ2yOs0xSNQues/UIj9PSpUGpaSAAOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739242660; c=relaxed/simple;
	bh=Eo6QmxxMj20Ub3bIv+3BwVFJRTNMIrqVGW7awgARe3Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bw9OO7euH9tgWMexKeR+vK6XCIXVEwU8RsfpN/NlTJNy9gJUraKEdTKzpF07VreAl8Fun5CqjINeK0hupAFGcT/oP73b/Rt2lvtohQYEQC4Cy9GfHB0x+J8Kum6y5SvDseMBGSY/XluSfF0OMGbAMM4dCEjGmI4TOcB+gCOGGew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HFTfiN7v; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1739242659; x=1770778659;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Eo6QmxxMj20Ub3bIv+3BwVFJRTNMIrqVGW7awgARe3Q=;
  b=HFTfiN7vrQ4p3pU2whr2eGBqwYK3GM8e6uvChEtxEwSre+7OMWHHjnmW
   QGiuhXwqDiYL8ZxrTVs1hhUtY/RtIKqAaG/Bk1awc0boBjhgjY1Y5TXkp
   7DuJ41bJHbTgXpLYOEXMMm8yZVFmIko8ssU4g1ozUIBNCqrgalpGXE1A5
   Q9UCdsfNNhZlm6GtQWJMll7RjCCEqSFnO4YwpXFmFgxuVLeNN7y6wRfAE
   EDYL1QuoBgt4GbbN75WlrWzFvvUovT3HOYLSlTUW3PfSZcCgbsEraTopV
   UR9cH4h/N8lFMOpmlP09k2XnfviPwShZhfz3nGoV89DSMpAmbE0IhP57S
   Q==;
X-CSE-ConnectionGUID: VVle9C7OS8KivjfwXjCFVw==
X-CSE-MsgGUID: gsr85lSjRvSdkCBLgh3Jfw==
X-IronPort-AV: E=McAfee;i="6700,10204,11341"; a="43612491"
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="43612491"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:39 -0800
X-CSE-ConnectionGUID: RCFyn/ciRaWjnpxgtKlvoQ==
X-CSE-MsgGUID: 4Jfnm6y1QdWjZ71wqNWFvA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,276,1732608000"; 
   d="scan'208";a="112355379"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2025 18:57:35 -0800
From: Binbin Wu <binbin.wu@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	linux-kernel@vger.kernel.org,
	binbin.wu@linux.intel.com
Subject: [PATCH v2 14/17] KVM: VMX: Move emulation_required to struct vcpu_vt
Date: Tue, 11 Feb 2025 10:58:25 +0800
Message-ID: <20250211025828.3072076-15-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
References: <20250211025828.3072076-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Move emulation_required from struct vcpu_vmx to struct vcpu_vt so that
vmx_handle_exit_irqoff() can be reused by TDX code.

No functional change intended.

Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX interrupts v2:
- New added.
---
 arch/x86/kvm/vmx/common.h |  1 +
 arch/x86/kvm/vmx/nested.c |  2 +-
 arch/x86/kvm/vmx/vmx.c    | 20 ++++++++++----------
 arch/x86/kvm/vmx/vmx.h    |  1 -
 4 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kvm/vmx/common.h b/arch/x86/kvm/vmx/common.h
index 079aeca65e2c..f26f7b1acbca 100644
--- a/arch/x86/kvm/vmx/common.h
+++ b/arch/x86/kvm/vmx/common.h
@@ -48,6 +48,7 @@ struct vcpu_vt {
 	 * hardware.
 	 */
 	bool		guest_state_loaded;
+	bool		emulation_required;
 
 #ifdef CONFIG_X86_64
 	u64		msr_host_kernel_gs_base;
diff --git a/arch/x86/kvm/vmx/nested.c b/arch/x86/kvm/vmx/nested.c
index 3add9f1073ff..8ae608a1e66c 100644
--- a/arch/x86/kvm/vmx/nested.c
+++ b/arch/x86/kvm/vmx/nested.c
@@ -4794,7 +4794,7 @@ static void load_vmcs12_host_state(struct kvm_vcpu *vcpu,
 				vmcs12->vm_exit_msr_load_count))
 		nested_vmx_abort(vcpu, VMX_ABORT_LOAD_HOST_MSR_FAIL);
 
-	to_vmx(vcpu)->emulation_required = vmx_emulation_required(vcpu);
+	to_vt(vcpu)->emulation_required = vmx_emulation_required(vcpu);
 }
 
 static inline u64 nested_vmx_get_vmcs01_guest_efer(struct vcpu_vmx *vmx)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index cb6043e29ef9..012649688e46 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -1584,7 +1584,7 @@ void vmx_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
 	vmcs_writel(GUEST_RFLAGS, rflags);
 
 	if ((old_rflags ^ vmx->rflags) & X86_EFLAGS_VM)
-		vmx->emulation_required = vmx_emulation_required(vcpu);
+		vmx->vt.emulation_required = vmx_emulation_required(vcpu);
 }
 
 bool vmx_get_if_flag(struct kvm_vcpu *vcpu)
@@ -1866,7 +1866,7 @@ void vmx_inject_exception(struct kvm_vcpu *vcpu)
 		return;
 	}
 
-	WARN_ON_ONCE(vmx->emulation_required);
+	WARN_ON_ONCE(vmx->vt.emulation_required);
 
 	if (kvm_exception_is_soft(ex->vector)) {
 		vmcs_write32(VM_ENTRY_INSTRUCTION_LEN,
@@ -3395,7 +3395,7 @@ void vmx_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
 	}
 
 	/* depends on vcpu->arch.cr0 to be set to a new value */
-	vmx->emulation_required = vmx_emulation_required(vcpu);
+	vmx->vt.emulation_required = vmx_emulation_required(vcpu);
 }
 
 static int vmx_get_max_ept_level(void)
@@ -3658,7 +3658,7 @@ void vmx_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var, int seg)
 {
 	__vmx_set_segment(vcpu, var, seg);
 
-	to_vmx(vcpu)->emulation_required = vmx_emulation_required(vcpu);
+	to_vmx(vcpu)->vt.emulation_required = vmx_emulation_required(vcpu);
 }
 
 void vmx_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
@@ -5798,7 +5798,7 @@ static bool vmx_emulation_required_with_pending_exception(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	return vmx->emulation_required && !vmx->rmode.vm86_active &&
+	return vmx->vt.emulation_required && !vmx->rmode.vm86_active &&
 	       (kvm_is_exception_pending(vcpu) || vcpu->arch.exception.injected);
 }
 
@@ -5811,7 +5811,7 @@ static int handle_invalid_guest_state(struct kvm_vcpu *vcpu)
 	intr_window_requested = exec_controls_get(vmx) &
 				CPU_BASED_INTR_WINDOW_EXITING;
 
-	while (vmx->emulation_required && count-- != 0) {
+	while (vmx->vt.emulation_required && count-- != 0) {
 		if (intr_window_requested && !vmx_interrupt_blocked(vcpu))
 			return handle_interrupt_window(&vmx->vcpu);
 
@@ -6458,7 +6458,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 		 * the least awful solution for the userspace case without
 		 * risking false positives.
 		 */
-		if (vmx->emulation_required) {
+		if (vmx->vt.emulation_required) {
 			nested_vmx_vmexit(vcpu, EXIT_REASON_TRIPLE_FAULT, 0, 0);
 			return 1;
 		}
@@ -6468,7 +6468,7 @@ static int __vmx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t exit_fastpath)
 	}
 
 	/* If guest state is invalid, start emulating.  L2 is handled above. */
-	if (vmx->emulation_required)
+	if (vmx->vt.emulation_required)
 		return handle_invalid_guest_state(vcpu);
 
 	if (exit_reason.failed_vmentry) {
@@ -6961,7 +6961,7 @@ void vmx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
 {
 	struct vcpu_vmx *vmx = to_vmx(vcpu);
 
-	if (vmx->emulation_required)
+	if (vmx->vt.emulation_required)
 		return;
 
 	if (vmx_get_exit_reason(vcpu).basic == EXIT_REASON_EXTERNAL_INTERRUPT)
@@ -7284,7 +7284,7 @@ fastpath_t vmx_vcpu_run(struct kvm_vcpu *vcpu, bool force_immediate_exit)
 	 * start emulation until we arrive back to a valid state.  Synthesize a
 	 * consistency check VM-Exit due to invalid guest state and bail.
 	 */
-	if (unlikely(vmx->emulation_required)) {
+	if (unlikely(vmx->vt.emulation_required)) {
 		vmx->fail = 0;
 
 		vmx->vt.exit_reason.full = EXIT_REASON_INVALID_STATE;
diff --git a/arch/x86/kvm/vmx/vmx.h b/arch/x86/kvm/vmx/vmx.h
index e635199901e2..6d1e40ecc024 100644
--- a/arch/x86/kvm/vmx/vmx.h
+++ b/arch/x86/kvm/vmx/vmx.h
@@ -263,7 +263,6 @@ struct vcpu_vmx {
 		} seg[8];
 	} segment_cache;
 	int vpid;
-	bool emulation_required;
 
 	/* Support for a guest hypervisor (nested VMX) */
 	struct nested_vmx nested;
-- 
2.46.0


