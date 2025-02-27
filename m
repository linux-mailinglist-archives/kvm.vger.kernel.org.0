Return-Path: <kvm+bounces-39450-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D74ECA470E3
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 02:22:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E51F83A9A41
	for <lists+kvm@lfdr.de>; Thu, 27 Feb 2025 01:22:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9688F1ACECE;
	Thu, 27 Feb 2025 01:19:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LAvRnsKi"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9661ABEAC;
	Thu, 27 Feb 2025 01:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740619170; cv=none; b=h3X93zZQ6643SeFmLxQ9oBUw7v+5BU75TnHdHufFpNGfaWnZxxqKEomyEYE5QT7gE+Qt6+irjYg0tngrm2aFfqKOFkut+T/PUuOzRB+qyzK2Oea29fvQo8yiZlOCfKyP/HrtshvUY0IT2idie4BG6C0BR6n6ijCC8CdiFEOK7tQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740619170; c=relaxed/simple;
	bh=MMd4x+ve8cCyfIEcQz0SDKFYVbOKm7OQ9khPYc920ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Owmzn8jrSDnab41nq5RYDE0ChuddKSQ8/gBWHHn4KoTGuzPDmQcJ/gOEd/lDsH3a3T0PpKeIowlxgmzRHo4Y5CDePPwXD6foeECEvcHQVw+YKGISZPNyM5gOFAIwj6kHEiPx6KG+Bv5OHQiNXeIS7T9WPbOzJuYLPmDkH9uIkO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LAvRnsKi; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740619169; x=1772155169;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MMd4x+ve8cCyfIEcQz0SDKFYVbOKm7OQ9khPYc920ic=;
  b=LAvRnsKiDJWS6nU5Rvs0zvuCAhNgk8Ejwwq2YUyBYEH4al3drDnVXowq
   M8x0rSN92MNvotrrsep6e+eaV8/lVazCefhxNUXsxqnzMD/ceGvyK5WnX
   7fw9BWuP0VmI1khmKVscm42r4/S8mIRGKXOl+MZzwICBKT6EdN9wA6ErL
   xbJp/r9vfE7TIGKnojlf7BSTgAAZIQ09FEZNYQZFYoaQnI3fKkQGzIgRy
   ESLf46isDy0WZ9FLcRs+GH02Ide/AaGY7vSM1+fbgSp2+ZgU/9/DueqfP
   LHDpuvaho9SMMa8BDQ78cIFtKjuoWQVCIXiYS3+4he3l+DBipxDS4ijA4
   g==;
X-CSE-ConnectionGUID: iw/nia+GRgmu/5mD0Ma6fw==
X-CSE-MsgGUID: vLH5g8uSS5G26454yEQ+Qw==
X-IronPort-AV: E=McAfee;i="6700,10204,11357"; a="63959637"
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="63959637"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:29 -0800
X-CSE-ConnectionGUID: JdwNei5QTY+9s+SmsYZgtw==
X-CSE-MsgGUID: Ljg26MCmRBqZVl+fm8mvdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.13,318,1732608000"; 
   d="scan'208";a="116674909"
Received: from litbin-desktop.sh.intel.com ([10.239.156.93])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Feb 2025 17:19:25 -0800
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
Subject: [PATCH v2 12/20] KVM: TDX: Add methods to ignore accesses to CPU state
Date: Thu, 27 Feb 2025 09:20:13 +0800
Message-ID: <20250227012021.1778144-13-binbin.wu@linux.intel.com>
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

TDX protects TDX guest state from VMM.  Implement access methods for TDX
guest state to ignore them or return zero.  Because those methods can be
called by kvm ioctls to set/get cpu registers, they don't have KVM_BUG_ON.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Co-developed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Binbin Wu <binbin.wu@linux.intel.com>
---
TDX "the rest" v2:
- Discard the mistakenly introduced change.
  https://lore.kernel.org/kvm/67dd44fb-0211-4435-a294-b9f00dc681d8@linux.intel.com
- Drop tdx_cache_reg() (Adrian, Sean)

TDX "the rest" v1:
- Dropped KVM_BUG_ON() in vt_sync_dirty_debug_regs(). (Rick)
  Since the KVM_BUG_ON() is removed, change the changlog accordingly.
---
 arch/x86/kvm/vmx/main.c | 307 ++++++++++++++++++++++++++++++++++++----
 1 file changed, 278 insertions(+), 29 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 7f3be1b65ce1..b76f39cc56fb 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -335,6 +335,214 @@ static void vt_deliver_interrupt(struct kvm_lapic *apic, int delivery_mode,
 	vmx_deliver_interrupt(apic, delivery_mode, trig_mode, vector);
 }
 
+static void vt_vcpu_after_set_cpuid(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_vcpu_after_set_cpuid(vcpu);
+}
+
+static void vt_update_exception_bitmap(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_update_exception_bitmap(vcpu);
+}
+
+static u64 vt_get_segment_base(struct kvm_vcpu *vcpu, int seg)
+{
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_segment_base(vcpu, seg);
+}
+
+static void vt_get_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
+			      int seg)
+{
+	if (is_td_vcpu(vcpu)) {
+		memset(var, 0, sizeof(*var));
+		return;
+	}
+
+	vmx_get_segment(vcpu, var, seg);
+}
+
+static void vt_set_segment(struct kvm_vcpu *vcpu, struct kvm_segment *var,
+			      int seg)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_segment(vcpu, var, seg);
+}
+
+static int vt_get_cpl(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_cpl(vcpu);
+}
+
+static int vt_get_cpl_no_cache(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_cpl_no_cache(vcpu);
+}
+
+static void vt_get_cs_db_l_bits(struct kvm_vcpu *vcpu, int *db, int *l)
+{
+	if (is_td_vcpu(vcpu)) {
+		*db = 0;
+		*l = 0;
+		return;
+	}
+
+	vmx_get_cs_db_l_bits(vcpu, db, l);
+}
+
+static bool vt_is_valid_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_is_valid_cr0(vcpu, cr0);
+}
+
+static void vt_set_cr0(struct kvm_vcpu *vcpu, unsigned long cr0)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_cr0(vcpu, cr0);
+}
+
+static bool vt_is_valid_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	if (is_td_vcpu(vcpu))
+		return true;
+
+	return vmx_is_valid_cr4(vcpu, cr4);
+}
+
+static void vt_set_cr4(struct kvm_vcpu *vcpu, unsigned long cr4)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_cr4(vcpu, cr4);
+}
+
+static int vt_set_efer(struct kvm_vcpu *vcpu, u64 efer)
+{
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_set_efer(vcpu, efer);
+}
+
+static void vt_get_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	if (is_td_vcpu(vcpu)) {
+		memset(dt, 0, sizeof(*dt));
+		return;
+	}
+
+	vmx_get_idt(vcpu, dt);
+}
+
+static void vt_set_idt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_idt(vcpu, dt);
+}
+
+static void vt_get_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	if (is_td_vcpu(vcpu)) {
+		memset(dt, 0, sizeof(*dt));
+		return;
+	}
+
+	vmx_get_gdt(vcpu, dt);
+}
+
+static void vt_set_gdt(struct kvm_vcpu *vcpu, struct desc_ptr *dt)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_gdt(vcpu, dt);
+}
+
+static void vt_set_dr6(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_dr6(vcpu, val);
+}
+
+static void vt_set_dr7(struct kvm_vcpu *vcpu, unsigned long val)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_dr7(vcpu, val);
+}
+
+static void vt_sync_dirty_debug_regs(struct kvm_vcpu *vcpu)
+{
+	/*
+	 * MOV-DR exiting is always cleared for TD guest, even in debug mode.
+	 * Thus KVM_DEBUGREG_WONT_EXIT can never be set and it should never
+	 * reach here for TD vcpu.
+	 */
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_sync_dirty_debug_regs(vcpu);
+}
+
+static void vt_cache_reg(struct kvm_vcpu *vcpu, enum kvm_reg reg)
+{
+	if (WARN_ON_ONCE(is_td_vcpu(vcpu)))
+		return;
+
+	vmx_cache_reg(vcpu, reg);
+}
+
+static unsigned long vt_get_rflags(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return 0;
+
+	return vmx_get_rflags(vcpu);
+}
+
+static void vt_set_rflags(struct kvm_vcpu *vcpu, unsigned long rflags)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_set_rflags(vcpu, rflags);
+}
+
+static bool vt_get_if_flag(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return false;
+
+	return vmx_get_if_flag(vcpu);
+}
+
 static void vt_flush_tlb_all(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu)) {
@@ -457,6 +665,14 @@ static void vt_inject_irq(struct kvm_vcpu *vcpu, bool reinjected)
 	vmx_inject_irq(vcpu, reinjected);
 }
 
+static void vt_inject_exception(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_inject_exception(vcpu);
+}
+
 static void vt_cancel_injection(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -504,6 +720,14 @@ static void vt_get_exit_info(struct kvm_vcpu *vcpu, u32 *reason,
 	vmx_get_exit_info(vcpu, reason, info1, info2, intr_info, error_code);
 }
 
+static void vt_update_cr8_intercept(struct kvm_vcpu *vcpu, int tpr, int irr)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_update_cr8_intercept(vcpu, tpr, irr);
+}
+
 static void vt_set_apic_access_page_addr(struct kvm_vcpu *vcpu)
 {
 	if (is_td_vcpu(vcpu))
@@ -522,6 +746,30 @@ static void vt_refresh_apicv_exec_ctrl(struct kvm_vcpu *vcpu)
 	vmx_refresh_apicv_exec_ctrl(vcpu);
 }
 
+static void vt_load_eoi_exitmap(struct kvm_vcpu *vcpu, u64 *eoi_exit_bitmap)
+{
+	if (is_td_vcpu(vcpu))
+		return;
+
+	vmx_load_eoi_exitmap(vcpu, eoi_exit_bitmap);
+}
+
+static int vt_set_tss_addr(struct kvm *kvm, unsigned int addr)
+{
+	if (is_td(kvm))
+		return 0;
+
+	return vmx_set_tss_addr(kvm, addr);
+}
+
+static int vt_set_identity_map_addr(struct kvm *kvm, u64 ident_addr)
+{
+	if (is_td(kvm))
+		return 0;
+
+	return vmx_set_identity_map_addr(kvm, ident_addr);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -583,32 +831,33 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vcpu_load = vt_vcpu_load,
 	.vcpu_put = vt_vcpu_put,
 
-	.update_exception_bitmap = vmx_update_exception_bitmap,
+	.update_exception_bitmap = vt_update_exception_bitmap,
 	.get_feature_msr = vmx_get_feature_msr,
 	.get_msr = vt_get_msr,
 	.set_msr = vt_set_msr,
-	.get_segment_base = vmx_get_segment_base,
-	.get_segment = vmx_get_segment,
-	.set_segment = vmx_set_segment,
-	.get_cpl = vmx_get_cpl,
-	.get_cpl_no_cache = vmx_get_cpl_no_cache,
-	.get_cs_db_l_bits = vmx_get_cs_db_l_bits,
-	.is_valid_cr0 = vmx_is_valid_cr0,
-	.set_cr0 = vmx_set_cr0,
-	.is_valid_cr4 = vmx_is_valid_cr4,
-	.set_cr4 = vmx_set_cr4,
-	.set_efer = vmx_set_efer,
-	.get_idt = vmx_get_idt,
-	.set_idt = vmx_set_idt,
-	.get_gdt = vmx_get_gdt,
-	.set_gdt = vmx_set_gdt,
-	.set_dr6 = vmx_set_dr6,
-	.set_dr7 = vmx_set_dr7,
-	.sync_dirty_debug_regs = vmx_sync_dirty_debug_regs,
-	.cache_reg = vmx_cache_reg,
-	.get_rflags = vmx_get_rflags,
-	.set_rflags = vmx_set_rflags,
-	.get_if_flag = vmx_get_if_flag,
+
+	.get_segment_base = vt_get_segment_base,
+	.get_segment = vt_get_segment,
+	.set_segment = vt_set_segment,
+	.get_cpl = vt_get_cpl,
+	.get_cpl_no_cache = vt_get_cpl_no_cache,
+	.get_cs_db_l_bits = vt_get_cs_db_l_bits,
+	.is_valid_cr0 = vt_is_valid_cr0,
+	.set_cr0 = vt_set_cr0,
+	.is_valid_cr4 = vt_is_valid_cr4,
+	.set_cr4 = vt_set_cr4,
+	.set_efer = vt_set_efer,
+	.get_idt = vt_get_idt,
+	.set_idt = vt_set_idt,
+	.get_gdt = vt_get_gdt,
+	.set_gdt = vt_set_gdt,
+	.set_dr6 = vt_set_dr6,
+	.set_dr7 = vt_set_dr7,
+	.sync_dirty_debug_regs = vt_sync_dirty_debug_regs,
+	.cache_reg = vt_cache_reg,
+	.get_rflags = vt_get_rflags,
+	.set_rflags = vt_set_rflags,
+	.get_if_flag = vt_get_if_flag,
 
 	.flush_tlb_all = vt_flush_tlb_all,
 	.flush_tlb_current = vt_flush_tlb_current,
@@ -625,7 +874,7 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.patch_hypercall = vmx_patch_hypercall,
 	.inject_irq = vt_inject_irq,
 	.inject_nmi = vt_inject_nmi,
-	.inject_exception = vmx_inject_exception,
+	.inject_exception = vt_inject_exception,
 	.cancel_injection = vt_cancel_injection,
 	.interrupt_allowed = vt_interrupt_allowed,
 	.nmi_allowed = vt_nmi_allowed,
@@ -633,13 +882,13 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.set_nmi_mask = vt_set_nmi_mask,
 	.enable_nmi_window = vt_enable_nmi_window,
 	.enable_irq_window = vt_enable_irq_window,
-	.update_cr8_intercept = vmx_update_cr8_intercept,
+	.update_cr8_intercept = vt_update_cr8_intercept,
 
 	.x2apic_icr_is_split = false,
 	.set_virtual_apic_mode = vt_set_virtual_apic_mode,
 	.set_apic_access_page_addr = vt_set_apic_access_page_addr,
 	.refresh_apicv_exec_ctrl = vt_refresh_apicv_exec_ctrl,
-	.load_eoi_exitmap = vmx_load_eoi_exitmap,
+	.load_eoi_exitmap = vt_load_eoi_exitmap,
 	.apicv_pre_state_restore = vt_apicv_pre_state_restore,
 	.required_apicv_inhibits = VMX_REQUIRED_APICV_INHIBITS,
 	.hwapic_isr_update = vt_hwapic_isr_update,
@@ -647,14 +896,14 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.deliver_interrupt = vt_deliver_interrupt,
 	.dy_apicv_has_pending_interrupt = pi_has_pending_interrupt,
 
-	.set_tss_addr = vmx_set_tss_addr,
-	.set_identity_map_addr = vmx_set_identity_map_addr,
+	.set_tss_addr = vt_set_tss_addr,
+	.set_identity_map_addr = vt_set_identity_map_addr,
 	.get_mt_mask = vmx_get_mt_mask,
 
 	.get_exit_info = vt_get_exit_info,
 	.get_entry_info = vt_get_entry_info,
 
-	.vcpu_after_set_cpuid = vmx_vcpu_after_set_cpuid,
+	.vcpu_after_set_cpuid = vt_vcpu_after_set_cpuid,
 
 	.has_wbinvd_exit = cpu_has_vmx_wbinvd_exit,
 
-- 
2.46.0


