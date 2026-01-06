Return-Path: <kvm+bounces-67133-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F354DCF7D1D
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:37:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 5517530570B0
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:36:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E3CE03396F7;
	Tue,  6 Jan 2026 10:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MVNqwDR+"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD39C338F20;
	Tue,  6 Jan 2026 10:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695205; cv=none; b=TC8mvyih3puFYQ4xc3aodoY30gZ1WQx8toKzn6brKDGvQoZC1ptxDt1wD60wHX6TyR0TC/85/W6bBr0XYSXuGpVA8Q3ZitfDW14k7tRLFFpNQXCMvv6o/iD6WIVYikEQakdx9yoa6utdQYSZ5NH15e/ouA0GTDVh89BpQ8l7Tdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695205; c=relaxed/simple;
	bh=YYc8jq3ziucShY612xow5a0Yb1+0Aezs5WAQqRXW4Vg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ksey/Q6f2cBgJcL2BIc4ParQu1unkLKTrm9XPzSn+fF3Ux2DbUFv7XFfk6k/3azsHVpnGO4gWr2swyHYyx192Fg0sSMjFh+7D4ZWY2J287kV8CCULIXqSrtIlMzG/j1VShsFUMZxROVDO8Ltpc4aSBFz4zNOzz/JB5rqTkhuSDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=fail smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MVNqwDR+; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695203; x=1799231203;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=YYc8jq3ziucShY612xow5a0Yb1+0Aezs5WAQqRXW4Vg=;
  b=MVNqwDR+4ZS/o14ePw1p6zqjqB2otIDlIJreNgbbEdAsx1nKyJzW+xsF
   BA+V2efVRtY2eaP8lbtYiWSwxGgEr0mRaSnaiJlUwR+HthN2ny6oHsOCH
   qheWHLdpBtOMgsv5TMP6FLol6z9RGCB5fXVekcVwQzYGCmThpu/nIIePD
   Y6x0NUDwILGffueIuL+PMT0VxCctoVjqAP3SEnPgUavr1oLwbuPgHZcAB
   yty8hOOSCR9SelGtqTYkv1R2bxoKNE5kj18AIyvflkblZV8YT+AyWRpgj
   iy9zkg1kaoTkA9+olk619l8knwZeNrenojHW16+TIqToBBO00ByETBVSj
   w==;
X-CSE-ConnectionGUID: VDvLM4bgT3mAPk6WxwNnNA==
X-CSE-MsgGUID: CDQB46uXRhCcn3I9+CASgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72918910"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72918910"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:26:43 -0800
X-CSE-ConnectionGUID: yuEL0qJhTqu3LnNW0rb7EA==
X-CSE-MsgGUID: cwZArffdRZaBZDf22k8q9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207665147"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:26:36 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kas@kernel.org,
	tabba@google.com,
	ackerleytng@google.com,
	michael.roth@amd.com,
	david@kernel.org,
	vannapurve@google.com,
	sagis@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	nik.borisov@suse.com,
	pgonda@google.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	francescolavra.fl@gmail.com,
	jgross@suse.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	kai.huang@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	chao.gao@intel.com,
	yan.y.zhao@intel.com
Subject: [PATCH v3 24/24] KVM: TDX: Turn on PG_LEVEL_2M
Date: Tue,  6 Jan 2026 18:24:40 +0800
Message-ID: <20260106102440.25328-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20260106101646.24809-1-yan.y.zhao@intel.com>
References: <20260106101646.24809-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Turn on PG_LEVEL_2M in tdx_gmem_private_max_mapping_level() when TDX huge
page is enabled and TD is RUNNABLE.

Introduce a module parameter named "tdx_huge_page" for kvm-intel.ko to
enable/disable TDX huge page. Turn TDX huge page off if the TDX module does
not support TDX_FEATURES0.ENHANCED_DEMOTE_INTERRUPTIBILITY.

Force page size to 4KB during TD build time to simplify code design, since
- tdh_mem_page_add() only adds private pages at 4KB.
- The amount of initial memory pages is usually limited (e.g. ~4MB in a
  typical linux TD).

Update the warnings and KVM_BUG_ON() info to match the conditions when 2MB
mappings are permitted.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Introduce the module param enable_tdx_huge_page and disable to toggle TDX
  huge page support.
- Disable TDX huge page if TDX module does not support
  TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY. (Kai).
- Explain why not allow 2M before TD is RUNNABLE in patch log.(Kai)
- Add comment to explain the relationship between returning PG_LEVEL_2M
  and guest accept level. (Kai)
- Dropped some KVM_BUG_ON()s due to rebasing. Updated KVM_BUG_ON()s on
  mapping levels to take into account of enable_tdx_huge_page.

RFC v2:
- Merged RFC v1's patch 4 (forcing PG_LEVEL_4K before TD runnable) with
  patch 9 (allowing PG_LEVEL_2M after TD runnable).
---
 arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0054a9de867c..8149e89b5549 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -54,6 +54,8 @@
 
 bool enable_tdx __ro_after_init;
 module_param_named(tdx, enable_tdx, bool, 0444);
+static bool __read_mostly enable_tdx_huge_page = true;
+module_param_named(tdx_huge_page, enable_tdx_huge_page, bool, 0444);
 
 #define TDX_SHARED_BIT_PWL_5 gpa_to_gfn(BIT_ULL(51))
 #define TDX_SHARED_BIT_PWL_4 gpa_to_gfn(BIT_ULL(47))
@@ -1773,8 +1775,12 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!vcpu, kvm))
 		return -EINVAL;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+	/*
+	 * Large page is not supported before TD runnable or TDX huge page is
+	 * not enabled.
+	 */
+	if (KVM_BUG_ON(((!enable_tdx_huge_page || kvm_tdx->state != TD_STATE_RUNNABLE) &&
+			level != PG_LEVEL_4K), kvm))
 		return -EIO;
 
 	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
@@ -1937,9 +1943,12 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	 */
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
 		return;
-
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+	/*
+	 * Large page is not supported before TD runnable or TDX huge page is
+	 * not enabled.
+	 */
+	if (KVM_BUG_ON(((!enable_tdx_huge_page || kvm_tdx->state != TD_STATE_RUNNABLE) &&
+			level != PG_LEVEL_4K), kvm))
 		return;
 
 	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
@@ -3556,12 +3565,34 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
+/*
+ * For private pages:
+ *
+ * Force KVM to map at 4KB level when !enable_tdx_huge_page (e.g., due to
+ * incompatible TDX module) or before TD state is RUNNABLE.
+ *
+ * Always allow KVM to map at 2MB level in other cases, though KVM may still map
+ * the page at 4KB (i.e., passing in PG_LEVEL_4K to AUG) due to
+ * (1) the backend folio is 4KB,
+ * (2) disallow_lpage restrictions:
+ *     - mixed private/shared pages in the 2MB range
+ *     - level misalignment due to slot base_gfn, slot size, and ugfn
+ *     - guest_inhibit bit set due to guest's 4KB accept level
+ * (3) page merging is disallowed (e.g., when part of a 2MB range has been
+ *     mapped at 4KB level during TD build time).
+ */
 int tdx_gmem_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn, bool is_private)
 {
 	if (!is_private)
 		return 0;
 
-	return PG_LEVEL_4K;
+	if (!enable_tdx_huge_page)
+		return PG_LEVEL_4K;
+
+	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
+		return PG_LEVEL_4K;
+
+	return PG_LEVEL_2M;
 }
 
 static int tdx_online_cpu(unsigned int cpu)
@@ -3747,6 +3778,8 @@ static int __init __tdx_bringup(void)
 	if (misc_cg_set_capacity(MISC_CG_RES_TDX, tdx_get_nr_guest_keyids()))
 		goto get_sysinfo_err;
 
+	if (enable_tdx_huge_page && !tdx_supports_demote_nointerrupt(tdx_sysinfo))
+		enable_tdx_huge_page = false;
 	/*
 	 * Leave hardware virtualization enabled after TDX is enabled
 	 * successfully.  TDX CPU hotplug depends on this.
-- 
2.43.2


