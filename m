Return-Path: <kvm+bounces-38973-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 71684A41603
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 08:11:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BB2291889DA5
	for <lists+kvm@lfdr.de>; Mon, 24 Feb 2025 07:11:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A3092405F8;
	Mon, 24 Feb 2025 07:11:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P30AgQgV"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 365AF1A072C;
	Mon, 24 Feb 2025 07:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740381072; cv=none; b=B8boLGsssdQC/1/QhrAnR+27ueBwCdfS0zIBIjJ8m0xvt+vXdpVyhIRuYEezj0BMVL6TRm1ZaRV1x08HV1oWi2f8zH2rUDophqpSNuy4A3fWmJE4ytuXpXh2XYqydTLZe89nX3KtKSEn0M8tN97waKwSpFJvHYaJv0wTxGYFYbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740381072; c=relaxed/simple;
	bh=FWFFpNZsKlibN+WX6V9zp3fTUq0OUIIXOt61vIr0x2c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iTV0wedTm2g2vQSZEqdCKebiMSc6I6Hhf/bVmICpAIDacYUq8E0MFWi/hQo8KL008at60NCncXWjFuyQtRI/PCIHdL/C7iXDCECx2RlMM8Jg8DhfnfTD0bZo2QQfuqByCmHHTJDoYhaPrU1/ccdAALQIkBiBJ6W/S2IL/vrZTJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P30AgQgV; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1740381068; x=1771917068;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=FWFFpNZsKlibN+WX6V9zp3fTUq0OUIIXOt61vIr0x2c=;
  b=P30AgQgV2EOSdjP+6IZ82MrBArkmX6S4wv8GOMJ7VsqgwRfLqEhO85Y5
   WDujmoVLyejqhuMnWI4aM/0adIRoUeyqhLKB6peWAQDJH64CFjwNGER8J
   PlGNLGqvFhwDPpOd8nWAR0gkZpV6u8ayAiAKgGqB1tBZ4l5BKep/oFyVi
   NMa1nvRKqj2ctxJrxRbniR0ztDcxCxkxF/MSj+3Nm/8ibyrVuL/eE/mHv
   /AMyOKnz0U1Q8aWXMrpJKX5MWxnSOtsRqtC6AN4maIa9+36ojbL/Jg72S
   g1lqpAOxjJqXbiNumUrtzoCIMmGUS9XJNJqgHJBTX2fcz+hcX2olctsR6
   Q==;
X-CSE-ConnectionGUID: o6KafWZNRTOgOykxCHca6w==
X-CSE-MsgGUID: L9/JtzWtTEyh5/9M33NF+g==
X-IronPort-AV: E=McAfee;i="6700,10204,11354"; a="40831674"
X-IronPort-AV: E=Sophos;i="6.13,309,1732608000"; 
   d="scan'208";a="40831674"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:11:01 -0800
X-CSE-ConnectionGUID: UvIP/3KjRw2mb4tUISjo3w==
X-CSE-MsgGUID: HDoRFvktRb+7FqwsLyoixQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="116465386"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2025 23:10:59 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	kevin.tian@intel.com,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 2/3] KVM: x86: Introduce Intel specific quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT
Date: Mon, 24 Feb 2025 15:09:45 +0800
Message-ID: <20250224070946.31482-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250224070716.31360-1-yan.y.zhao@intel.com>
References: <20250224070716.31360-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce a Intel specific quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT to have
KVM ignore guest PAT when this quirk is enabled.

KVM is able to safely honor guest PAT on Intel platforms when CPU feature
self-snoop is supported. However, KVM honoring guest PAT was reverted after
commit 9d70f3fec144 ("Revert "KVM: VMX: Always honor guest PAT on CPUs that
support self-snoop""), due to UC access on certain Intel platforms being
very slow [1]. Honoring guest PAT on those platforms may break some old
guests that accidentally specify PAT as UC. Those old guests may never
expect the slowness since KVM always forces WB previously. See [2].

So, introduce an Intel specific quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT.
KVM enables the quirk on all Intel platforms by default to avoid breaking
old unmodifiable guests. Newer userspace can disable this quirk to turn on
honoring guest PAT.

The quirk is only valid on Intel's platforms and is absent on AMD's
platforms as KVM always honors guest PAT when running on AMD.

Suggested-by: Paolo Bonzini <pbonzini@redhat.com>
Suggested-by: Sean Christopherson <seanjc@google.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Link: https://lore.kernel.org/all/Ztl9NWCOupNfVaCA@yzhao56-desk.sh.intel.com # [1]
Link: https://lore.kernel.org/all/87jzfutmfc.fsf@redhat.com # [2]
---
 Documentation/virt/kvm/api.rst  | 28 +++++++++++++++++++++++
 arch/x86/include/uapi/asm/kvm.h |  1 +
 arch/x86/kvm/mmu.h              |  2 +-
 arch/x86/kvm/mmu/mmu.c          | 14 +++++++-----
 arch/x86/kvm/vmx/vmx.c          | 39 +++++++++++++++++++++++++++------
 arch/x86/kvm/x86.c              |  2 +-
 6 files changed, 72 insertions(+), 14 deletions(-)

diff --git a/Documentation/virt/kvm/api.rst b/Documentation/virt/kvm/api.rst
index d5363d88fa52..c22211c2f54c 100644
--- a/Documentation/virt/kvm/api.rst
+++ b/Documentation/virt/kvm/api.rst
@@ -8164,6 +8164,34 @@ KVM_X86_QUIRK_STUFF_FEATURE_MSRS    By default, at vCPU creation, KVM sets the
                                     and 0x489), as KVM does now allow them to
                                     be set by userspace (KVM sets them based on
                                     guest CPUID, for safety purposes).
+
+KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT  By default, on Intel platforms, KVM ignores
+                                    guest PAT and forces the effective memory
+                                    type to WB in EPT.  The quirk has no effect
+                                    when KVM runs on Intel platforms which are
+                                    incapable of safely honoring guest PAT
+                                    (i.e., without CPU feature self-snoop, KVM
+                                    always ignores guest PAT and forces
+                                    effective memory type to WB) or when a VM
+                                    has assigned non-coherent DMA devices (KVM
+                                    always honors guest PAT with assigned
+                                    non-coherent DMA devices). On certain Intel
+                                    Xeon platforms (e.g. ICX, SPR), though
+                                    self-snoop feature is supported, UC is slow
+                                    enough to cause issues with some older
+                                    guests (e.g. an old version of bochs driver
+                                    uses ioremap() instead of ioremap_wc() to
+                                    map the video RAM, causing wayland desktop
+                                    to fail to start correctly). To prevent
+                                    breaking older guest software, KVM enables
+                                    the quirk by default on Intel platforms.
+                                    Userspace can disable the quirk to honor
+                                    guest PAT when there is no older
+                                    unmodifiable guest software that relies on
+                                    KVM to force memory type to WB.  Note, the
+                                    quirk is not visible on AMD's platforms,
+                                    i.e., KVM always honors guest PAT when
+                                    running on AMD.
 =================================== ============================================
 
 7.32 KVM_CAP_MAX_VCPU_ID
diff --git a/arch/x86/include/uapi/asm/kvm.h b/arch/x86/include/uapi/asm/kvm.h
index 89cc7a18ef45..db55a70e173c 100644
--- a/arch/x86/include/uapi/asm/kvm.h
+++ b/arch/x86/include/uapi/asm/kvm.h
@@ -441,6 +441,7 @@ struct kvm_sync_regs {
 #define KVM_X86_QUIRK_MWAIT_NEVER_UD_FAULTS	(1 << 6)
 #define KVM_X86_QUIRK_SLOT_ZAP_ALL		(1 << 7)
 #define KVM_X86_QUIRK_STUFF_FEATURE_MSRS	(1 << 8)
+#define KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT	(1 << 9)
 
 #define KVM_STATE_NESTED_FORMAT_VMX	0
 #define KVM_STATE_NESTED_FORMAT_SVM	1
diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index 47e64a3c4ce3..f999c15d8d3e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -232,7 +232,7 @@ static inline u8 permission_fault(struct kvm_vcpu *vcpu, struct kvm_mmu *mmu,
 	return -(u32)fault & errcode;
 }
 
-bool kvm_mmu_may_ignore_guest_pat(void);
+bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm);
 
 int kvm_mmu_post_init_vm(struct kvm *kvm);
 void kvm_mmu_pre_destroy_vm(struct kvm *kvm);
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index e6eb3a262f8d..28d0b73bf685 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4663,17 +4663,21 @@ static int kvm_tdp_mmu_page_fault(struct kvm_vcpu *vcpu,
 }
 #endif
 
-bool kvm_mmu_may_ignore_guest_pat(void)
+bool kvm_mmu_may_ignore_guest_pat(struct kvm *kvm)
 {
 	/*
 	 * When EPT is enabled (shadow_memtype_mask is non-zero), and the VM
 	 * has non-coherent DMA (DMA doesn't snoop CPU caches), KVM's ABI is to
 	 * honor the memtype from the guest's PAT so that guest accesses to
 	 * memory that is DMA'd aren't cached against the guest's wishes.  As a
-	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA,
-	 * KVM _always_ ignores guest PAT (when EPT is enabled).
-	 */
-	return shadow_memtype_mask;
+	 * result, KVM _may_ ignore guest PAT, whereas without non-coherent DMA.
+	 * KVM _always_ ignores guest PAT, when EPT is enabled and when quirk
+	 * KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is enabled or the CPU lacks the
+	 * ability to safely honor guest PAT.
+	 */
+	return shadow_memtype_mask &&
+	       (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT) ||
+		!static_cpu_has(X86_FEATURE_SELFSNOOP));
 }
 
 int kvm_tdp_page_fault(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 486fbdb4365c..9fb884175bfd 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -7599,6 +7599,34 @@ int vmx_vm_init(struct kvm *kvm)
 	return 0;
 }
 
+/*
+ * Ignore guest PAT when the CPU doesn't support self-snoop to safely honor
+ * guest PAT, or quirk KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is turned on.  Always
+ * honor guest PAT when there's non-coherent DMA device attached.
+ *
+ * Honoring guest PAT means letting the guest control memory types.
+ * - On Intel CPUs that lack self-snoop feature, honoring guest PAT may result
+ *   in unexpected behavior. So always ignore guest PAT on those CPUs.
+ *
+ * - KVM's ABI is to trust the guest for attached non-coherent DMA devices to
+ *   function correctly (non-coherent DMA devices need the guest to flush CPU
+ *   caches properly). So honoring guest PAT to avoid breaking existing ABI.
+ *
+ * - On certain Intel CPUs (e.g. SPR, ICX), though self-snoop feature is
+ *   supported, UC is slow enough to cause issues with some older guests (e.g.
+ *   an old version of bochs driver uses ioremap() instead of ioremap_wc() to
+ *   map the video RAM, causing wayland desktop to fail to get started
+ *   correctly). To avoid breaking those old guests that rely on KVM to force
+ *   memory type to WB, only honoring guest PAT when quirk
+ *   KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT is disabled.
+ */
+static inline bool vmx_ignore_guest_pat(struct kvm *kvm)
+{
+	return !kvm_arch_has_noncoherent_dma(kvm) &&
+	       (kvm_check_has_quirk(kvm, KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT) ||
+		!static_cpu_has(X86_FEATURE_SELFSNOOP));
+}
+
 u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 {
 	/*
@@ -7608,13 +7636,8 @@ u8 vmx_get_mt_mask(struct kvm_vcpu *vcpu, gfn_t gfn, bool is_mmio)
 	if (is_mmio)
 		return MTRR_TYPE_UNCACHABLE << VMX_EPT_MT_EPTE_SHIFT;
 
-	/*
-	 * Force WB and ignore guest PAT if the VM does NOT have a non-coherent
-	 * device attached.  Letting the guest control memory types on Intel
-	 * CPUs may result in unexpected behavior, and so KVM's ABI is to trust
-	 * the guest to behave only as a last resort.
-	 */
-	if (!kvm_arch_has_noncoherent_dma(vcpu->kvm))
+	/* Force WB if ignoring guest PAT */
+	if (vmx_ignore_guest_pat(vcpu->kvm))
 		return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT) | VMX_EPT_IPAT_BIT;
 
 	return (MTRR_TYPE_WRBACK << VMX_EPT_MT_EPTE_SHIFT);
@@ -8498,6 +8521,8 @@ __init int vmx_hardware_setup(void)
 			return r;
 	}
 
+	kvm_caps.supported_quirks |= KVM_X86_QUIRK_EPT_IGNORE_GUEST_PAT;
+
 	vmx_set_cpu_caps();
 
 	r = alloc_kvm_area();
diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 4f1b73620c6a..8ae96449e6e2 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -13550,7 +13550,7 @@ static void kvm_noncoherent_dma_assignment_start_or_stop(struct kvm *kvm)
 	 * (or last) non-coherent device is (un)registered to so that new SPTEs
 	 * with the correct "ignore guest PAT" setting are created.
 	 */
-	if (kvm_mmu_may_ignore_guest_pat())
+	if (kvm_mmu_may_ignore_guest_pat(kvm))
 		kvm_zap_gfn_range(kvm, gpa_to_gfn(0), gpa_to_gfn(~0ULL));
 }
 
-- 
2.43.2


