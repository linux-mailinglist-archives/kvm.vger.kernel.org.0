Return-Path: <kvm+bounces-67119-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5EB96CF7F6D
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:06:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5623A312E2C5
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC10B325714;
	Tue,  6 Jan 2026 10:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MdkG+6ot"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428DD309F19;
	Tue,  6 Jan 2026 10:23:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695023; cv=none; b=r/qcXtzL1/lCCuRKgNgFRr9vK1/CuJpI+q2b4KdCLz6/usXMY1pfBZ/+9OteSPSageenDYTmwzDAsxIQwMwOPvdkigbwNv1EGNQt0PpKqHTbBDNVKgnnUEN+f9PxKm9wgLwV6NjT5JCBJrWCU6eZVkjPaf4enYxN/kOTFy5qfj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695023; c=relaxed/simple;
	bh=qPi5NNUsFtXM1wM0hk0GwsQeRaWC08JCvXyAMTr4kZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H5nheW2lefQOWisD3SCnHAOLRIh5A2S7DX2D1FkidRVurc7ppiSntFy1DGpErVCPhfonhkC9h41D/i6JDzPuQDeYphwZg3DzY5EYOgVhlTY0y8UNgf4iQRqB4jTpBZIYTj9f7ph8+IhUkIin1vVGEYB1QZXr1ef4NrUlXtMsxb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MdkG+6ot; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695021; x=1799231021;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qPi5NNUsFtXM1wM0hk0GwsQeRaWC08JCvXyAMTr4kZk=;
  b=MdkG+6otB+zYo4l2wYlvTBUU4Hfh5OnECv7MPTgNvVoHc0/whKqgZIhQ
   uN1T0FwEiTVUVD20SzSnHdFQrTaeUUoN9XhLGtinmE7nEc7102hg+ZKDU
   /ak4Y5r2cvNKDiN4bWPRSH/Ry+8RzhhdNxk40uFzmQzdbCkivLdLVaT+f
   pJgofbuW1QeS/YuoVLYzMGgEvmcsDc/xEY+aEN0URj84lEMgAAL0pgiVX
   lahtNaB7+SKnESM6XGAbtXPj1YGIM7v4ej4aZCiFt6NGMm3Qdn9zuysUY
   W/OH2zpiBg0NLV6P0ud3/5K8QAnSFHz9FFYOjzFrfCAtNRxKMJQTdXPQ5
   Q==;
X-CSE-ConnectionGUID: +4wv+gAKSrWA8gwefXJ1Vw==
X-CSE-MsgGUID: Qz1ngfAaRGufrjnFORzRFA==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72689605"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72689605"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:40 -0800
X-CSE-ConnectionGUID: rdQB6kYKQfqOGdw88F91sg==
X-CSE-MsgGUID: CayaJQcORwO8iAxi3+LWQA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="201847530"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:34 -0800
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
Subject: [PATCH v3 11/24] KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
Date: Tue,  6 Jan 2026 18:21:36 +0800
Message-ID: <20260106102136.25108-1-yan.y.zhao@intel.com>
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

Introduce kvm_split_cross_boundary_leafs() to split huge leaf entries that
cross the boundary of a specified range.

Splitting huge leaf entries that cross the boundary is essential before
zapping a specified range in the mirror root. This ensures that the
subsequent zap operation does not affect any GFNs outside the specified
range, which is crucial for the mirror root, as the private page table
requires the guest's ACCEPT operation after faulting back.

While the core of kvm_split_cross_boundary_leafs() leverages the main logic
of tdp_mmu_split_huge_pages_root(), the former only splits huge leaf
entries when their mapping ranges cross the specified range boundary. When
splitting is necessary, kvm->mmu_lock may be temporarily released for
memory allocation, meaning returning -ENOMEM is possible.

Since tdp_mmu_split_huge_pages_root() is originally invoked by dirty page
tracking related functions that flush TLB unconditionally at the end,
tdp_mmu_split_huge_pages_root() doesn't flush TLB before it temporarily
releases mmu_lock.

Do not enhance tdp_mmu_split_huge_pages_root() to return split or flush
status for kvm_split_cross_boundary_leafs(). This is because the status
could be inaccurate when multiple threads are trying to split the same
memory range concurrently, e.g., if kvm_split_cross_boundary_leafs()
returns split/flush as false, it doesn't mean there're no splits in the
specified range, since splits could have occurred in other threads due to
temporary release of mmu_lock.

Therefore, callers of kvm_split_cross_boundary_leafs() need to determine
how/when to flush TLB according to the use cases:

- If the split is triggered in a fault path for TDX, the hardware shouldn't
  have cached the old huge translation. Therefore, no need to flush TLB.

- If the split is triggered by zaps in guest_memfd punch hole or page
  conversion, it can delay the TLB flush until after zaps.

- If the use case relies on pure split status (e.g., splitting for PML),
  flush TLB unconditionally. (Just hypothetical. No such use case currently
  exists for kvm_split_cross_boundary_leafs()).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- s/only_cross_bounday/only_cross_boundary. (Kai)
- Do not return flush status and have the callers to determine how/when to
  flush TLB.
- Always pass "flush" as false to tdp_mmu_iter_cond_resched(). (Kai)
- Added a default implementation for kvm_split_boundary_leafs() for non-x86
  platforms.
- Removed middle level function tdp_mmu_split_cross_boundary_leafs().
- Use EXPORT_SYMBOL_FOR_KVM_INTERNAL().

RFC v2:
- Rename the API to kvm_split_cross_boundary_leafs().
- Make the API to be usable for direct roots or under shared mmu_lock.
- Leverage the main logic from tdp_mmu_split_huge_pages_root(). (Rick)

RFC v1:
- Split patch.
- introduced API kvm_split_boundary_leafs(), refined the logic and
  simplified the code.
---
 arch/x86/kvm/mmu/mmu.c     | 34 ++++++++++++++++++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 42 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |  3 +++
 include/linux/kvm_host.h   |  2 ++
 virt/kvm/kvm_main.c        |  7 +++++++
 5 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index b4f2e3ced716..f40af7ac75b3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1644,6 +1644,40 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				 start, end - 1, can_yield, true, flush);
 }
 
+/*
+ * Split large leafs crossing the boundary of the specified range.
+ * Only support TDP MMU. Do nothing if !tdp_mmu_enabled.
+ *
+ * This API does not flush TLB. Callers need to determine how/when to flush TLB
+ * according to their use cases, e.g.,
+ * - No need to flush TLB. e.g., if it's in a fault path or TLB flush has been
+ *   ensured.
+ * - Delay the TLB flush until after zaps if the split is invoked for precise
+ *   zapping.
+ * - Unconditionally flush TLB if a use case relies on pure split status (e.g.,
+ *   splitting for PML).
+ *
+ * Return value: 0 : success;  <0: failure
+ */
+int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
+				   bool shared)
+{
+	bool ret = 0;
+
+	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
+			    lockdep_is_held(&kvm->slots_lock) ||
+			    srcu_read_lock_held(&kvm->srcu));
+
+	if (!range->may_block)
+		return -EOPNOTSUPP;
+
+	if (tdp_mmu_enabled)
+		ret = kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(kvm, range,
+								       shared);
+	return ret;
+}
+EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_split_cross_boundary_leafs);
+
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 074209d91ec3..b984027343b7 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1600,10 +1600,17 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
 	return ret;
 }
 
+static bool iter_cross_boundary(struct tdp_iter *iter, gfn_t start, gfn_t end)
+{
+	return !(iter->gfn >= start &&
+		 (iter->gfn + KVM_PAGES_PER_HPAGE(iter->level)) <= end);
+}
+
 static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 					 struct kvm_mmu_page *root,
 					 gfn_t start, gfn_t end,
-					 int target_level, bool shared)
+					 int target_level, bool shared,
+					 bool only_cross_boundary)
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct tdp_iter iter;
@@ -1615,6 +1622,10 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level into one lower level. For example, if we encounter a 1GB page
 	 * we split it into 512 2MB pages.
 	 *
+	 * When only_cross_boundary is true, just split huge pages above the
+	 * target level into one lower level if the huge pages cross the start
+	 * or end boundary.
+	 *
 	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
 	 * to visit an SPTE before ever visiting its children, which means we
 	 * will correctly recursively split huge pages that are more than one
@@ -1629,6 +1640,10 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
 			continue;
 
+		if (only_cross_boundary &&
+		    !iter_cross_boundary(&iter, start, end))
+			continue;
+
 		if (!sp) {
 			rcu_read_unlock();
 
@@ -1692,12 +1707,35 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id) {
-		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level, shared);
+		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level,
+						  shared, false);
+		if (r) {
+			kvm_tdp_mmu_put_root(kvm, root);
+			break;
+		}
+	}
+}
+
+int kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(struct kvm *kvm,
+						     struct kvm_gfn_range *range,
+						     bool shared)
+{
+	enum kvm_tdp_mmu_root_types types;
+	struct kvm_mmu_page *root;
+	int r = 0;
+
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter);
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types) {
+		r = tdp_mmu_split_huge_pages_root(kvm, root, range->start, range->end,
+						  PG_LEVEL_4K, shared, true);
 		if (r) {
 			kvm_tdp_mmu_put_root(kvm, root);
 			break;
 		}
 	}
+	return r;
 }
 
 static bool tdp_mmu_need_write_protect(struct kvm *kvm, struct kvm_mmu_page *sp)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index bd62977c9199..c20b1416e4b2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -70,6 +70,9 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 				  enum kvm_tdp_mmu_root_types root_types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
+int kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(struct kvm *kvm,
+						     struct kvm_gfn_range *range,
+						     bool shared);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 8144d27e6c12..e563bb22c481 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -275,6 +275,8 @@ struct kvm_gfn_range {
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
+				   bool shared);
 #endif
 
 enum {
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 1d7ab2324d10..feeef7747099 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -910,6 +910,13 @@ static int kvm_init_mmu_notifier(struct kvm *kvm)
 	return mmu_notifier_register(&kvm->mmu_notifier, current->mm);
 }
 
+int __weak kvm_split_cross_boundary_leafs(struct kvm *kvm,
+					  struct kvm_gfn_range *range,
+					  bool shared)
+{
+	return 0;
+}
+
 #else  /* !CONFIG_KVM_GENERIC_MMU_NOTIFIER */
 
 static int kvm_init_mmu_notifier(struct kvm *kvm)
-- 
2.43.2


