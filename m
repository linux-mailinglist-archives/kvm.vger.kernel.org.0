Return-Path: <kvm+bounces-23910-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 63B1194F9F1
	for <lists+kvm@lfdr.de>; Tue, 13 Aug 2024 00:53:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D886B1F24857
	for <lists+kvm@lfdr.de>; Mon, 12 Aug 2024 22:53:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 98F5D1A01A9;
	Mon, 12 Aug 2024 22:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WfYJl4zj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B010D19DF70;
	Mon, 12 Aug 2024 22:48:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723502924; cv=none; b=c1Kd7hcsiCIrMmcSCK2m7rUFJ9XXQ/efTRDQ1LxvPrikJtx0yeyYH22uHaSVW5cvDn6HMlI8wYjTNqWOTa34LWI+bEvIgp3AzdXmds8Z48J6k9QhKr6P8kOjmxcEgKh+hxV1bWGAdYmII3Qh2PA6eRiZaly75vWTHAJ7SO5fRSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723502924; c=relaxed/simple;
	bh=YGleTpb6mmW/tsezi3q9ZjZv54BNdmNHXPDTlZ3oEC0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SK9IMWHHVDZ1EZQkOtF41TKU1AMrI+DHku5L+3Ouq7XegIOg9wIRGBKFUPo+T/NCuW3cI8IkeGDzVg3s09xkcknqkyPlMIdN/IucZ9JeUogC0IibLvGJbgjT+U4iusl89n7BUoGQpOiN0KNsMKqLPqOit634LmauREenRsnALDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WfYJl4zj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1723502922; x=1755038922;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YGleTpb6mmW/tsezi3q9ZjZv54BNdmNHXPDTlZ3oEC0=;
  b=WfYJl4zjT+470TEsU8XnH09yOcgv3UhI6tlDaf5Xh8V6pdOVmZo8bhAz
   oYw/i1L0WhqEdjYp0SyOm/ba5j48qUDwvXLj+KMluuX+AEBlFHUOX0NSO
   wZFC93ZovW/kfazRbKYLGpmqwHnMYvYNJBvT8PzYxMAU8WhLMAmd9FJy/
   4sV4B7Tbf80W0NPT/dU1ybIgFdX5nAHCgKex7TBNQX2Ke/4xTzXafl7kY
   z4h1MWwSbzTs2uR/I+hVWLR0XAYYL7c1IEFObwuTK1vDWYaZQue7UU94/
   ESQgtdaQGXoKjXrzCxWTk2hwHbbq/sIYlWkjecE1iIAxocCSOp7u2FpGH
   Q==;
X-CSE-ConnectionGUID: g5sR3GEVQe2TK6/dfk84EQ==
X-CSE-MsgGUID: 0Qr6qR/lShy9x7fEWwJ8Bw==
X-IronPort-AV: E=McAfee;i="6700,10204,11162"; a="33041440"
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="33041440"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:36 -0700
X-CSE-ConnectionGUID: IWA4nJpmTB+hmY4EPMaRDQ==
X-CSE-MsgGUID: ocSyheWqTIeg27GFZdFlkQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,284,1716274800"; 
   d="scan'208";a="59008432"
Received: from jdoman-desk1.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.222.53])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2024 15:48:36 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	isaku.yamahata@gmail.com,
	tony.lindgren@linux.intel.com,
	xiaoyao.li@intel.com,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH 17/25] KVM: TDX: create/free TDX vcpu structure
Date: Mon, 12 Aug 2024 15:48:12 -0700
Message-Id: <20240812224820.34826-18-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
References: <20240812224820.34826-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Implement vcpu related stubs for TDX for create, reset and free.

For now, create only the features that do not require the TDX SEAMCALL.
The TDX specific vcpu initialization will be handled by KVM_TDX_INIT_VCPU.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
uAPI breakout v1:
 - Dropped unnecessary WARN_ON_ONCE() in tdx_vcpu_create().
   WARN_ON_ONCE(vcpu->arch.cpuid_entries),
   WARN_ON_ONCE(vcpu->arch.cpuid_nent)
 - Use kvm_tdx instead of to_kvm_tdx() in tdx_vcpu_create() (Chao)

v19:
 - removed stale comment in tdx_vcpu_create().

v18:
 - update commit log to use create instead of allocate because the patch
   doesn't newly allocate memory for TDX vcpu.

v16:
 - Add AMX support as the KVM upstream supports it.
--
2.46.0
---
 arch/x86/kvm/vmx/main.c    | 44 ++++++++++++++++++++++++++++++++++----
 arch/x86/kvm/vmx/tdx.c     | 41 +++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/x86_ops.h | 10 +++++++++
 arch/x86/kvm/x86.c         |  2 ++
 4 files changed, 93 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index c079a5b057d8..d40de73d2bd3 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -72,6 +72,42 @@ static void vt_vm_free(struct kvm *kvm)
 		tdx_vm_free(kvm);
 }
 
+static int vt_vcpu_precreate(struct kvm *kvm)
+{
+	if (is_td(kvm))
+		return 0;
+
+	return vmx_vcpu_precreate(kvm);
+}
+
+static int vt_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu))
+		return tdx_vcpu_create(vcpu);
+
+	return vmx_vcpu_create(vcpu);
+}
+
+static void vt_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_free(vcpu);
+		return;
+	}
+
+	vmx_vcpu_free(vcpu);
+}
+
+static void vt_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+	if (is_td_vcpu(vcpu)) {
+		tdx_vcpu_reset(vcpu, init_event);
+		return;
+	}
+
+	vmx_vcpu_reset(vcpu, init_event);
+}
+
 static int vt_mem_enc_ioctl(struct kvm *kvm, void __user *argp)
 {
 	if (!is_td(kvm))
@@ -108,10 +144,10 @@ struct kvm_x86_ops vt_x86_ops __initdata = {
 	.vm_destroy = vt_vm_destroy,
 	.vm_free = vt_vm_free,
 
-	.vcpu_precreate = vmx_vcpu_precreate,
-	.vcpu_create = vmx_vcpu_create,
-	.vcpu_free = vmx_vcpu_free,
-	.vcpu_reset = vmx_vcpu_reset,
+	.vcpu_precreate = vt_vcpu_precreate,
+	.vcpu_create = vt_vcpu_create,
+	.vcpu_free = vt_vcpu_free,
+	.vcpu_reset = vt_vcpu_reset,
 
 	.prepare_switch_to_guest = vmx_prepare_switch_to_guest,
 	.vcpu_load = vmx_vcpu_load,
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 531e87983b90..18738cacbc87 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -377,6 +377,47 @@ int tdx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+int tdx_vcpu_create(struct kvm_vcpu *vcpu)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+
+	/* TDX only supports x2APIC, which requires an in-kernel local APIC. */
+	if (!vcpu->arch.apic)
+		return -EINVAL;
+
+	fpstate_set_confidential(&vcpu->arch.guest_fpu);
+
+	vcpu->arch.efer = EFER_SCE | EFER_LME | EFER_LMA | EFER_NX;
+
+	vcpu->arch.cr0_guest_owned_bits = -1ul;
+	vcpu->arch.cr4_guest_owned_bits = -1ul;
+
+	vcpu->arch.tsc_offset = kvm_tdx->tsc_offset;
+	vcpu->arch.l1_tsc_offset = vcpu->arch.tsc_offset;
+	vcpu->arch.guest_state_protected =
+		!(to_kvm_tdx(vcpu->kvm)->attributes & TDX_TD_ATTR_DEBUG);
+
+	if ((kvm_tdx->xfam & XFEATURE_MASK_XTILE) == XFEATURE_MASK_XTILE)
+		vcpu->arch.xfd_no_write_intercept = true;
+
+	return 0;
+}
+
+void tdx_vcpu_free(struct kvm_vcpu *vcpu)
+{
+	/* This is stub for now.  More logic will come. */
+}
+
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
+{
+
+	/* Ignore INIT silently because TDX doesn't support INIT event. */
+	if (init_event)
+		return;
+
+	/* This is stub for now. More logic will come here. */
+}
+
 static int tdx_get_capabilities(struct kvm_tdx_cmd *cmd)
 {
 	const struct tdx_sysinfo_td_conf *td_conf = &tdx_sysinfo->td_conf;
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 96c74880bd36..e1d3276b0f60 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -123,7 +123,12 @@ int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap);
 int tdx_vm_init(struct kvm *kvm);
 void tdx_mmu_release_hkid(struct kvm *kvm);
 void tdx_vm_free(struct kvm *kvm);
+
 int tdx_vm_ioctl(struct kvm *kvm, void __user *argp);
+
+int tdx_vcpu_create(struct kvm_vcpu *vcpu);
+void tdx_vcpu_free(struct kvm_vcpu *vcpu);
+void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event);
 #else
 static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 {
@@ -132,7 +137,12 @@ static inline int tdx_vm_enable_cap(struct kvm *kvm, struct kvm_enable_cap *cap)
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
 static inline void tdx_mmu_release_hkid(struct kvm *kvm) {}
 static inline void tdx_vm_free(struct kvm *kvm) {}
+
 static inline int tdx_vm_ioctl(struct kvm *kvm, void __user *argp) { return -EOPNOTSUPP; }
+
+static inline int tdx_vcpu_create(struct kvm_vcpu *vcpu) { return -EOPNOTSUPP; }
+static inline void tdx_vcpu_free(struct kvm_vcpu *vcpu) {}
+static inline void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event) {}
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index ce2ef63f30f2..9cee326f5e7a 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -488,6 +488,7 @@ int kvm_set_apic_base(struct kvm_vcpu *vcpu, struct msr_data *msr_info)
 	kvm_recalculate_apic_map(vcpu->kvm);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(kvm_set_apic_base);
 
 /*
  * Handle a fault on a hardware virtualization (VMX or SVM) instruction.
@@ -12630,6 +12631,7 @@ bool kvm_vcpu_is_reset_bsp(struct kvm_vcpu *vcpu)
 {
 	return vcpu->kvm->arch.bsp_vcpu_id == vcpu->vcpu_id;
 }
+EXPORT_SYMBOL_GPL(kvm_vcpu_is_reset_bsp);
 
 bool kvm_vcpu_is_bsp(struct kvm_vcpu *vcpu)
 {
-- 
2.34.1


