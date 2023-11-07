Return-Path: <kvm+bounces-1014-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id BA0547E42D6
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 16:09:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD3221C20EBC
	for <lists+kvm@lfdr.de>; Tue,  7 Nov 2023 15:09:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8586E34CF1;
	Tue,  7 Nov 2023 15:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fxOspV4X"
X-Original-To: kvm@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB053A28D
	for <kvm@vger.kernel.org>; Tue,  7 Nov 2023 15:05:16 +0000 (UTC)
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD0459EF;
	Tue,  7 Nov 2023 07:01:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1699369317; x=1730905317;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Wz8JozwpePCPYvaTH7ehXkgs4uz9x2cWRIOr7bv3qak=;
  b=fxOspV4XUtCQ8kG+Xy/++8oV2ldeRikzQipZ0RNvmiRIk775+gY/WYQN
   k0brw4ZbdYy/xUylKxy0aYMR3Dh0uaVApMYqJSqlI+C6UjmBbqqgoXamN
   hKAw43saQ8NsmsQRqEunPLahGQ3KEjHB76TR4S1UTsL9rfSz2AmzrmOhs
   U1WrLWhUb5TLvoBkMxpog0b57yPJlnuE21Bi9eelc49oh39LN9BgATF/f
   FWHMwzD4xfcRSmj2+qbmlQv1YghJZ57OQuJd8/eFFLcijomAb5OnDnm6A
   CMPY5WebewTiHHz8PCQSUiCPISrc3gtDKVaDB1WzWL8IGYvez2tcKy7Ae
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10887"; a="2462543"
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="2462543"
Received: from fmviesa001.fm.intel.com ([10.60.135.141])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:23 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.03,284,1694761200"; 
   d="scan'208";a="10851533"
Received: from ls.sc.intel.com (HELO localhost) ([172.25.112.31])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2023 06:58:22 -0800
From: isaku.yamahata@intel.com
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com,
	Paolo Bonzini <pbonzini@redhat.com>,
	erdemaktas@google.com,
	Sean Christopherson <seanjc@google.com>,
	Sagi Shahar <sagis@google.com>,
	David Matlack <dmatlack@google.com>,
	Kai Huang <kai.huang@intel.com>,
	Zhi Wang <zhi.wang.linux@gmail.com>,
	chen.bo@intel.com,
	hang.yuan@intel.com,
	tina.zhang@intel.com
Subject: [PATCH v17 082/116] KVM: TDX: Add a place holder to handle TDX VM exit
Date: Tue,  7 Nov 2023 06:56:48 -0800
Message-Id: <a496a4074ed7c7a5f74fb070ab91492835e6aafb.1699368322.git.isaku.yamahata@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1699368322.git.isaku.yamahata@intel.com>
References: <cover.1699368322.git.isaku.yamahata@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Wire up handle_exit and handle_exit_irqoff methods and add a place holder
to handle VM exit.  Add helper functions to get exit info, exit
qualification, etc.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
 arch/x86/kvm/vmx/main.c    |  37 ++++++++++++-
 arch/x86/kvm/vmx/tdx.c     | 110 +++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  10 ++++
 3 files changed, 154 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ad3feb48d9ec..b8eba5fe4500 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -239,6 +239,25 @@ static bool vt_protected_apic_has_interrupt(struct kvm_vcpu *vcpu)
 	return tdx_protected_apic_has_interrupt(vcpu);
 }
 
+static int vt_handle_exit(struct kvm_vcpu *vcpu,
+			  enum exit_fastpath_completion fastpath)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_handle_exit(vcpu, fastpath);
+
+	return vmx_handle_exit(vcpu, fastpath);
+}
+
+static void vt_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_handle_exit_irqoff(vcpu);
+		return;
+	}
+
+	vmx_handle_exit_irqoff(vcpu);
+}
+
 static void vt_apicv_pre_state_restore(struct kvm_vcpu *vcpu)
 {
 	struct pi_desc *pi = vcpu_to_pi_desc(vcpu);
@@ -445,6 +464,18 @@ static void vt_request_immediate_exit(struct kvm_vcpu *vcpu)
 	vmx_request_immediate_exit(vcpu);
 }
 
+static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+			u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_get_exit_info(vcpu, reason, info1, info2, intr_info,
+				  error_code);
+		return;
+	}
+
+	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
+}
+
 static u8 vt_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	if (is_td_vcpu(vcpu))
@@ -540,7 +571,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.vcpu_pre_run = vt_vcpu_pre_run,
 	.vcpu_run = vt_vcpu_run,
-	.handle_exit = vmx_handle_exit,
+	.handle_exit = vt_handle_exit,
 	.skip_emulated_instruction = vmx_skip_emulated_instruction,
 	.update_emulated_instruction = vmx_update_emulated_instruction,
 	.set_interrupt_shadow = vt_set_interrupt_shadow,
@@ -575,7 +606,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_identity_map_addr = vmx_set_identity_map_addr,
 	.get_mt_mask = vt_get_mt_mask,
 
-	.get_exit_info = vmx_get_exit_info,
+	.get_exit_info = vt_get_exit_info,
 
 	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
 
@@ -589,7 +620,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.load_mmu_pgd = vt_load_mmu_pgd,
 
 	.check_intercept = vmx_check_intercept,
-	.handle_exit_irqoff = vmx_handle_exit_irqoff,
+	.handle_exit_irqoff = vt_handle_exit_irqoff,
 
 	.request_immediate_exit = vt_request_immediate_exit,
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8d21e902b34a..012cfcc2b7b1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -87,6 +87,26 @@ static __always_inline hpa_t set_hkid_to_hpa(hpa_t pa, u16 hkid)
 	return pa | ((hpa_t)hkid << boot_cpu_data.x86_phys_bits);
 }
 
+static __always_inline unsigned long tdexit_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rcx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_ext_exit_qual(struct kvm_vcpu *vcpu)
+{
+	return kvm_rdx_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_gpa(struct kvm_vcpu *vcpu)
+{
+	return kvm_r8_read(vcpu);
+}
+
+static __always_inline unsigned long tdexit_intr_info(struct kvm_vcpu *vcpu)
+{
+	return kvm_r9_read(vcpu);
+}
+
 static inline bool is_td_vcpu_created(struct vcpu_tdx *tdx)
 {
 	return tdx->tdvpr_pa;
@@ -811,6 +831,12 @@ static noinstr void tdx_vcpu_enter_exit(struct vcpu_tdx *tdx)
 	WARN_ON_ONCE(!kvm_rebooting &&
 		     (tdx->exit_reason.full & TDX_SW_ERROR) == TDX_SW_ERROR);
 
+	if ((u16)tdx->exit_reason.basic == EXIT_REASON_EXCEPTION_NMI &&
+	    is_nmi(tdexit_intr_info(vcpu))) {
+		kvm_before_interrupt(vcpu, KVM_HANDLING_NMI);
+		vmx_do_nmi_irqoff();
+		kvm_after_interrupt(vcpu);
+	}
 	guest_state_exit_irqoff();
 }
 
@@ -854,6 +880,25 @@ void tdx_inject_nmi(struct kvm_vcpu *vcpu)
 	td_management_write8(to_tdx(vcpu), TD_VCPU_PEND_NMI, 1);
 }
 
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	u16 exit_reason = tdx->exit_reason.basic;
+
+	if (exit_reason == EXIT_REASON_EXTERNAL_INTERRUPT)
+		vmx_handle_external_interrupt_irqoff(vcpu,
+						     tdexit_intr_info(vcpu));
+	else if (exit_reason == EXIT_REASON_EXCEPTION_NMI)
+		vmx_handle_exception_irqoff(vcpu, tdexit_intr_info(vcpu));
+}
+
+static int tdx_handle_triple_fault(struct kvm_vcpu *vcpu)
+{
+	vcpu->run->exit_reason = KVM_EXIT_SHUTDOWN;
+	vcpu->mmio_needed = 0;
+	return 0;
+}
+
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 {
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa & PAGE_MASK);
@@ -1216,6 +1261,71 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	__vmx_deliver_posted_interrupt(vcpu, &tdx->pi_desc, vector);
 }
 
+int tdx_handle_exit(struct kvm_vcpu *vcpu, fastpath_t fastpath)
+{
+	union tdx_exit_reason exit_reason = to_tdx(vcpu)->exit_reason;
+
+	/* See the comment of tdh_sept_seamcall(). */
+	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_SEPT)))
+		return 1;
+
+	/*
+	 * TDH.VP.ENTRY checks TD EPOCH which contend with TDH.MEM.TRACK and
+	 * vcpu TDH.VP.ENTER.
+	 */
+	if (unlikely(exit_reason.full == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_TD_EPOCH)))
+		return 1;
+
+	if (unlikely(exit_reason.full == TDX_SEAMCALL_UD)) {
+		kvm_spurious_fault();
+		/*
+		 * In the case of reboot or kexec, loop with TDH.VP.ENTER and
+		 * TDX_SEAMCALL_UD to avoid unnecessarily activity.
+		 */
+		return 1;
+	}
+
+	if (unlikely(exit_reason.non_recoverable || exit_reason.error)) {
+		if (unlikely(exit_reason.basic == EXIT_REASON_TRIPLE_FAULT))
+			return tdx_handle_triple_fault(vcpu);
+
+		kvm_pr_unimpl("TD exit 0x%llx, %d hkid 0x%x hkid pa 0x%llx\n",
+			      exit_reason.full, exit_reason.basic,
+			      to_kvm_tdx(vcpu->kvm)->hkid,
+			      set_hkid_to_hpa(0, to_kvm_tdx(vcpu->kvm)->hkid));
+		goto unhandled_exit;
+	}
+
+	WARN_ON_ONCE(fastpath != EXIT_FASTPATH_NONE);
+
+	switch (exit_reason.basic) {
+	default:
+		break;
+	}
+
+unhandled_exit:
+	vcpu->run->exit_reason = KVM_EXIT_INTERNAL_ERROR;
+	vcpu->run->internal.suberror = KVM_INTERNAL_ERROR_UNEXPECTED_EXIT_REASON;
+	vcpu->run->internal.ndata = 2;
+	vcpu->run->internal.data[0] = exit_reason.full;
+	vcpu->run->internal.data[1] = vcpu->arch.last_vmentry_cpu;
+	return 0;
+}
+
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code)
+{
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+
+	*reason = tdx->exit_reason.full;
+
+	*info1 = tdexit_exit_qual(vcpu);
+	*info2 = tdexit_ext_exit_qual(vcpu);
+
+	*intr_info = tdexit_intr_info(vcpu);
+	*error_code = 0;
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	struct kvm_tdx_capabilities __user *user_caps;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index c0ffb8dda750..8084a274b0ee 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -155,11 +155,16 @@ void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu);
 void tdx_vcpu_put(struct kvm_vcpu *vcpu);
 void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu);
 bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu);
+void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu);
+int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath);
 u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio);
 
 void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 			   int trig_mode, int vector);
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
+void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
+		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -192,11 +197,16 @@ static inline void tdx_prepare_switch_to_guest(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_put(struct kvm_vcpu *vcpu) {}
 static inline void tdx_vcpu_load(struct kvm_vcpu *vcpu, int cpu) {}
 static inline bool tdx_protected_apic_has_interrupt(struct kvm_vcpu *vcpu) { return false; }
+static inline void tdx_handle_exit_irqoff(struct kvm_vcpu *vcpu) {}
+static inline int tdx_handle_exit(struct kvm_vcpu *vcpu,
+		enum exit_fastpath_completion fastpath) { return 0; }
 static inline u8 tdx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio) { return 0; }
 
 static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 					 int trig_mode, int vector) {}
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
+static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
+				     u64 *info2, u32 *intr_info, u32 *error_code) {}
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.25.1


