Return-Path: <kvm+bounces-39446-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D1DDA470DF
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:21:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id DBBA67AA48F
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:20:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7DF8018DB2F;
	Thu, 27 Feb 2025 01:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iIgqryt8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6BC189B84;
	Thu, 27 Feb 2025 01:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619157; cv=none; b=fufvWw/Lc8VXDyOh6SWR1xCX+pO5+bRrMLYphlKi8HEipr4IRWh8Bsn4hg5U3UdI2trorKEECvTo4VOBNy2syrM4d2XOzw4mtdpQ+lUF7pwbKhgBNF/LDjq5sxneII8fUTQGuWPEpn6QJbrhfE8x34otVaK+s7fKDcBedAMVBwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619157; c=relaxed/simple;
	bh=xCkNm4JnyBb3SmxvO8+ccf3merznB8vgaoOvBZJQoco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuUyR30NsJqiQR1aNte2PNEZfDcNABcCviu5nr1cY/5ByCf5ZwCPucYyZf9mfTgbeEatf6yfTRCTVUvDDZ7HafR39wG7uL6kvCE7Y1aWnWN0hb3/ruiG/PTApNWGJYf8hdqS0h5b8tjMQMiEV+5JZK+dozN4zfsoUZkRBtcxuT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iIgqryt8; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619156; x=1772155156;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xCkNm4JnyBb3SmxvO8+ccf3merznB8vgaoOvBZJQoco=;
  b=iIgqryt8uvaSa016I5QJXbJ0wzoX7+4n5HXTum4O8lfKUH9+S/onflbJ
   X3LC+42lS4YM2yzma3B9pSApIRUggb4tAcnY8xWI+ns0ZkZmOuC8aGqfr
   U2eiPL4JknhJu0p+auRq8/oc8N+R5STfgj1olXpKE9+HlCNinFnVcOx+2
   MHstIKZ9pe5b80C0rbaJxRMuj1TI+ahElh2nNyh51LB4tHaCUYkx9vnNa
   kBrKjA7sHyBurFNsM8Me7vwxArwvltYXZyEx3+DB9+mh3NNBPb96KGjAx
   PFvBtnnWw1gbLNkOL7bFKrathOo9PhpDHzWIRrGXr3FsyE1PF+CkOw+Ys
   A==;
X-CSE-ConnectionGUID: QnqcxewQTSKgg/dDyl2crQ==
X-CSE-MsgGUID: 7ZzVTap/Th+QHFKY/qHMMg==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959622"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959622"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:16 -0800
X-CSE-ConnectionGUID: IRsI8NVSTW+rxyv86KxjxQ==
X-CSE-MsgGUID: uXl6nllRSwCSktPIGUQclg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674897"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:12 -0800
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
Subject: [PATCH v2 08/20] KVM: TDX: Implement callbacks for MSR operations
Date: Thu, 27 Feb 2025 09:20:09 +0800
Message-ID: <20250227012021.1778144-9-binbin.wu@linux.intel.com>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
References: <20250227012021.1778144-1-binbin.wu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Add functions to implement MSR related callbacks, .set_msr(), .get_msr(),
and .has_emulated_msr(), for preparation of handling hypercalls from TDX
guest for PV RDMSR and WRMSR.  Ignore KVM_REQ_MSR_FILTER_CHANGED for TDX.

There are three classes of MSR virtualization for TDX.
- Non-configurable: TDX module directly virtualizes it. VMM can't configure
  it, the value set by KVM_SET_MSRS is ignored.
- Configurable: TDX module directly virtualizes it. VMM can configure it at
  VM creation time.  The value set by KVM_SET_MSRS is used.
- #VE case: TDX guest would issue TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR}>
  and VMM handles the MSR hypercall. The value set by KVM_SET_MSRS is used.

For the MSRs belonging to the #VE case, the TDX module injects #VE to the
TDX guest upon RDMSR or WRMSR.  The exact list of such MSRs is defined in
TDX Module ABI Spec.

Upon #VE, the TDX guest may call TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR}>,
which are defined in GHCI (Guest-Host Communication Interface) so that the
host VMM (e.g. KVM) can virtualize the MSRs.

TDX doesn't allow VMM to configure interception of MSR accesses.  Ignore
KVM_REQ_MSR_FILTER_CHANGED for TDX guest.  If the userspace has set any
MSR filters, it will be applied when handling
TDG.VP.VMCALL<INSTRUCTION.{WRMSR,RDMSR}> in a later patch.

Suggested-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
---
TDX "the rest" v2:
- Typo fix in changelog. (Kai)
  https://lore.kernel.org/kvm/34ed02a6aedc7dcb35df9ce639e427e4d1a61f72.camel@intel.com

TDX "the rest" v1:
- Renamed from "KVM: TDX: Implement callbacks for MSR operations for TDX"
  to "KVM: TDX: Implement callbacks for MSR operations"
- Update changelog.
- Remove the @write parameter of tdx_has_emulated_msr(), check whether the
  MSR is readonly or not in tdx_set_msr(). (Sean)
  https://lore.kernel.org/kvm/Zg1yPIV6cVJrwGxX@google.com/
- Change the code align with the patten "make the happy path the
  not-taken path". (Sean)
- Open code the handling for an emulated KVM MSR MSR_KVM_POLL_CONTROL,
  and let others go through the default statement. (Sean)
- Split macro KVM_MAX_MCE_BANKS move to a separate patch. (Sean)
- Add comments in vt_msr_filter_changed().
- Add Suggested-by tag.
---
 arch/x86/kvm/vmx/main.c    | 50 +++++++++++++++++++++++++---
 arch/x86/kvm/vmx/tdx.c     | 67 ++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h |  6 ++++
 3 files changed, 119 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index d383f4510c15..463de3add3bd 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -193,6 +193,48 @@ static int vt_handle_exit(struct kvm_vcpu *vcpu,
 	return vmx_handle_exit(vcpu, fastpath);
 }
 
+static int vt_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_set_msr(vcpu, msr_info);
+
+	return vmx_set_msr(vcpu, msr_info);
+}
+
+/*
+ * The kvm parameter can be NULL (module initialization, or invocation before
+ * VM creation). Be sure to check the kvm parameter before using it.
+ */
+static bool vt_has_emulated_msr(struct kvm *kvm, u32 index)
+{
+	if (kvm && is_td(kvm))
+		return tdx_has_emulated_msr(index);
+
+	return vmx_has_emulated_msr(kvm, index);
+}
+
+static int vt_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
+{
+	if (unlikely(is_td_vcpu(vcpu)))
+		return tdx_get_msr(vcpu, msr_info);
+
+	return vmx_get_msr(vcpu, msr_info);
+}
+
+static void vt_msr_filter_changed(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * TDX doesn't allow VMM to configure interception of MSR accesses.
+	 * TDX guest requests MSR accesses by calling TDVMCALL.  The MSR
+	 * filters will be applied when handling the TDVMCALL for RDMSR/WRMSR
+	 * if the userspace has set any.
+	 */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_msr_filter_changed(vcpu);
+}
+
 #ifdef CONFIG_KVM_SMM
 static int vt_smi_allowed(struct kvm_vcpu *vcpu, bool for_injection)
 {
@@ -516,7 +558,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.disable_virtualization_cpu = vt_disable_virtualization_cpu,
 	.emergency_disable_virtualization_cpu = vmx_emergency_disable_virtualization_cpu,
 
-	.has_emulated_msr = vmx_has_emulated_msr,
+	.has_emulated_msr = vt_has_emulated_msr,
 
 	.vm_size = sizeof(struct kvm_vmx),
 
@@ -535,8 +577,8 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 
 	.update_exception_bitmap = vmx_update_exception_bitmap,
 	.get_feature_msr = vmx_get_feature_msr,
-	.get_msr = vmx_get_msr,
-	.set_msr = vmx_set_msr,
+	.get_msr = vt_get_msr,
+	.set_msr = vt_set_msr,
 	.get_segment_base = vmx_get_segment_base,
 	.get_segment = vmx_get_segment,
 	.set_segment = vmx_set_segment,
@@ -643,7 +685,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.apic_init_signal_blocked = vt_apic_init_signal_blocked,
 	.migrate_timers = vmx_migrate_timers,
 
-	.msr_filter_changed = vmx_msr_filter_changed,
+	.msr_filter_changed = vt_msr_filter_changed,
 	.complete_emulated_msr = kvm_complete_insn_gp,
 
 	.vcpu_deliver_sipi_vector = kvm_vcpu_deliver_sipi_vector,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 30f0ceeed7d2..5b556af0f139 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2002,6 +2002,73 @@ void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	*error_code = 0;
 }
 
+bool tdx_has_emulated_msr(u32 index)
+{
+	switch (index) {
+	case MSR_IA32_UCODE_REV:
+	case MSR_IA32_ARCH_CAPABILITIES:
+	case MSR_IA32_POWER_CTL:
+	case MSR_IA32_CR_PAT:
+	case MSR_IA32_TSC_DEADLINE:
+	case MSR_IA32_MISC_ENABLE:
+	case MSR_PLATFORM_INFO:
+	case MSR_MISC_FEATURES_ENABLES:
+	case MSR_IA32_APICBASE:
+	case MSR_EFER:
+	case MSR_IA32_MCG_CAP:
+	case MSR_IA32_MCG_STATUS:
+	case MSR_IA32_MCG_CTL:
+	case MSR_IA32_MCG_EXT_CTL:
+	case MSR_IA32_MC0_CTL ... MSR_IA32_MCx_CTL(KVM_MAX_MCE_BANKS) - 1:
+	case MSR_IA32_MC0_CTL2 ... MSR_IA32_MCx_CTL2(KVM_MAX_MCE_BANKS) - 1:
+		/* MSR_IA32_MCx_{CTL, STATUS, ADDR, MISC, CTL2} */
+	case MSR_KVM_POLL_CONTROL:
+		return true;
+	case APIC_BASE_MSR ... APIC_BASE_MSR + 0xff:
+		/*
+		 * x2APIC registers that are virtualized by the CPU can't be
+		 * emulated, KVM doesn't have access to the virtual APIC page.
+		 */
+		switch (index) {
+		case X2APIC_MSR(APIC_TASKPRI):
+		case X2APIC_MSR(APIC_PROCPRI):
+		case X2APIC_MSR(APIC_EOI):
+		case X2APIC_MSR(APIC_ISR) ... X2APIC_MSR(APIC_ISR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_TMR) ... X2APIC_MSR(APIC_TMR + APIC_ISR_NR):
+		case X2APIC_MSR(APIC_IRR) ... X2APIC_MSR(APIC_IRR + APIC_ISR_NR):
+			return false;
+		default:
+			return true;
+		}
+	default:
+		return false;
+	}
+}
+
+static bool tdx_is_read_only_msr(u32 index)
+{
+	return  index == MSR_IA32_APICBASE || index == MSR_EFER;
+}
+
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (!tdx_has_emulated_msr(msr->index))
+		return 1;
+
+	return kvm_get_msr_common(vcpu, msr);
+}
+
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr)
+{
+	if (tdx_is_read_only_msr(msr->index))
+		return 1;
+
+	if (!tdx_has_emulated_msr(msr->index))
+		return 1;
+
+	return kvm_set_msr_common(vcpu, msr);
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sys_info_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index e5d0c8a03566..19f770b0fc81 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -145,6 +145,9 @@ void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 void tdx_inject_nmi(struct kvm_vcpu *vcpu);
 void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 		u64 *info1, u64 *info2, u32 *intr_info, u32 *error_code);
+bool tdx_has_emulated_msr(u32 index);
+int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
+int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr);
 
 int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp);
 
@@ -188,6 +191,9 @@ static inline void tdx_deliver_interrupt(struct kvm_lapic *apic, int delivery_mo
 static inline void tdx_inject_nmi(struct kvm_vcpu *vcpu) {}
 static inline void tdx_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason, u64 *info1,
 				     u64 *info2, u32 *intr_info, u32 *error_code) {}
+static inline bool tdx_has_emulated_msr(u32 index) { return false; }
+static inline int tdx_get_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
+static inline int tdx_set_msr(struct kvm_vcpu *vcpu, struct msr_data *msr) { return 1; }
 
 static inline int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp) { return -EOPNOTSUPP; }
 
-- 
2.46.0


