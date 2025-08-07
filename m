Return-Path: <kvm+bounces-54237-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CD50CB1D515
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:45:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 761F23B8534
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6932026B75A;
	Thu,  7 Aug 2025 09:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Jay0/hbC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B201E26B2CE;
	Thu,  7 Aug 2025 09:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559878; cv=none; b=VpMVcBIjwMBsf/6Biwp82mkJJgKm5KyiYdkaVkk02zfm2swPZaLfB52rfWxBr7aXSFqwIuPs/zHNuax2X48gtMxwXe6gtfsL9OtIcF9bfS/pecsFDrjf3D6Rw9SwL4Brr6lZevQpQNRgyafI256OCT8S7hl7UBCMW2MWiir1Ftc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559878; c=relaxed/simple;
	bh=5RNFIrPP5XzHyKCSnzobCR/z+UGV3ABaLHWPmFrnD0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uQ8CqryfANHUfPmyz4c7uhUUQY82E7Clcu/T1zUaKeO/WrGpHlY9VTy4XDWK4fqBHIqwvJPIy74h/mCBAqzQunXM2r5Xp0OyVph0IXjj11bRTNoPXRxxE7tL5TmH2fGqU9ryfKI6SHhLJlvpSJ5bPxsjPno1juJd40lVvgV+NyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Jay0/hbC; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559877; x=1786095877;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5RNFIrPP5XzHyKCSnzobCR/z+UGV3ABaLHWPmFrnD0w=;
  b=Jay0/hbCV6LC/ZPQfXeAD0oWwQvETgSgj4SSwDnoOpSKki7CztI8Mwo2
   NteaEZ5d9+T/UwCfqUS6g7wVZxCl4c4fbocEYlYZpAVQzdjk6UAz/kp7u
   3OenvM6m++WJv7ddhFDwCoLJZBlxX3wZMig86Z94zMq4A4TlnllRUsZ/O
   2+I57LzMqPpKgDJ1i8/xLtwSfyIgfOtcGJCHZ190G6/SOowei/KT+SwyY
   N+U0ojS9pLpafIA4bLl0pKbglvWvEhrYc6hWt6ZGTVgqVRXbmiWkfA/uy
   jvxllhenFqrLM4T4GoJHIBa/oiKqHpZrmGEeeSQPXb/c5wHNayhLmChqO
   g==;
X-CSE-ConnectionGUID: 8QMpyqr/Skioo7+jJs24gw==
X-CSE-MsgGUID: WE4tR743R6uWaCKaS+MkOQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="67157530"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="67157530"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:34 -0700
X-CSE-ConnectionGUID: e4lj1YgLT8isfDe7j7ddtQ==
X-CSE-MsgGUID: 2tX2hBu7Q2GWKB0nMXa6Fg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="202196374"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:44:28 -0700
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
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	thomas.lendacky@amd.com,
	pgonda@google.com,
	zhiquan1.li@intel.com,
	fan.du@intel.com,
	jun.miao@intel.com,
	ira.weiny@intel.com,
	isaku.yamahata@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@linux.intel.com,
	chao.p.peng@intel.com,
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 12/23] KVM: x86/mmu: Introduce kvm_split_cross_boundary_leafs()
Date: Thu,  7 Aug 2025 17:43:58 +0800
Message-ID: <20250807094358.4607-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
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
zapping the range in the mirror root. This ensures that the subsequent zap
operation does not affect any GFNs outside the specified range. This is
crucial for the mirror root, as the private page table requires the guest's
ACCEPT operation after a GFN faults back.

The core of kvm_split_cross_boundary_leafs() leverages the main logic from
tdp_mmu_split_huge_pages_root(). It traverses the specified root and splits
huge leaf entries if they cross the range boundary. When splitting is
necessary, kvm->mmu_lock is temporarily released for memory allocation,
which means returning -ENOMEM is possible.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Rename the API to kvm_split_cross_boundary_leafs().
- Make the API to be usable for direct roots or under shared mmu_lock.
- Leverage the main logic from tdp_mmu_split_huge_pages_root(). (Rick)

RFC v1:
- Split patch.
- introduced API kvm_split_boundary_leafs(), refined the logic and
  simplified the code.
---
 arch/x86/kvm/mmu/mmu.c     | 27 +++++++++++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 68 ++++++++++++++++++++++++++++++++++++--
 arch/x86/kvm/mmu/tdp_mmu.h |  3 ++
 include/linux/kvm_host.h   |  2 ++
 4 files changed, 97 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 9182192daa3a..13910ae05f76 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1647,6 +1647,33 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				 start, end - 1, can_yield, true, flush);
 }
 
+/*
+ * Split large leafs crossing the boundary of the specified range
+ *
+ * Return value:
+ * 0 : success, no flush is required;
+ * 1 : success, flush is required;
+ * <0: failure.
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
+		ret = kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(kvm, range, shared);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(kvm_split_cross_boundary_leafs);
+
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index ce49cc850ed5..62a09a9655c3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1574,10 +1574,17 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
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
+					 bool only_cross_bounday, bool *flush)
 {
 	struct kvm_mmu_page *sp = NULL;
 	struct tdp_iter iter;
@@ -1589,6 +1596,13 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 * level into one lower level. For example, if we encounter a 1GB page
 	 * we split it into 512 2MB pages.
 	 *
+	 * When only_cross_bounday is true, just split huge pages above the
+	 * target level into one lower level if the huge pages cross the start
+	 * or end boundary.
+	 *
+	 * No need to update @flush for !only_cross_bounday cases, which rely
+	 * on the callers to do the TLB flush in the end.
+	 *
 	 * Since the TDP iterator uses a pre-order traversal, we are guaranteed
 	 * to visit an SPTE before ever visiting its children, which means we
 	 * will correctly recursively split huge pages that are more than one
@@ -1597,12 +1611,19 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 	 */
 	for_each_tdp_pte_min_level(iter, kvm, root, target_level + 1, start, end) {
 retry:
-		if (tdp_mmu_iter_cond_resched(kvm, &iter, false, shared))
+		if (tdp_mmu_iter_cond_resched(kvm, &iter, *flush, shared)) {
+			if (only_cross_bounday)
+				*flush = false;
 			continue;
+		}
 
 		if (!is_shadow_present_pte(iter.old_spte) || !is_large_pte(iter.old_spte))
 			continue;
 
+		if (only_cross_bounday &&
+		    !iter_cross_boundary(&iter, start, end))
+			continue;
+
 		if (!sp) {
 			rcu_read_unlock();
 
@@ -1637,6 +1658,8 @@ static int tdp_mmu_split_huge_pages_root(struct kvm *kvm,
 			goto retry;
 
 		sp = NULL;
+		if (only_cross_bounday)
+			*flush = true;
 	}
 
 	rcu_read_unlock();
@@ -1663,10 +1686,12 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 {
 	struct kvm_mmu_page *root;
 	int r = 0;
+	bool flush = false;
 
 	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
 	for_each_valid_tdp_mmu_root_yield_safe(kvm, root, slot->as_id) {
-		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level, shared);
+		r = tdp_mmu_split_huge_pages_root(kvm, root, start, end, target_level,
+						  shared, false, &flush);
 		if (r) {
 			kvm_tdp_mmu_put_root(kvm, root);
 			break;
@@ -1674,6 +1699,43 @@ void kvm_tdp_mmu_try_split_huge_pages(struct kvm *kvm,
 	}
 }
 
+/*
+ * Split large leafs which cross the specified boundary
+ */
+static int tdp_mmu_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
+					      gfn_t start, gfn_t end, bool shared,
+					      bool *flush)
+{
+	return tdp_mmu_split_huge_pages_root(kvm, root, start, end, PG_LEVEL_4K,
+					     shared, true, flush);
+}
+
+int kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(struct kvm *kvm,
+						     struct kvm_gfn_range *range,
+						     bool shared)
+{
+	enum kvm_tdp_mmu_root_types types;
+	struct kvm_mmu_page *root;
+	bool flush = false;
+	int ret;
+
+	kvm_lockdep_assert_mmu_lock_held(kvm, shared);
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter);
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types) {
+		ret = tdp_mmu_split_cross_boundary_leafs(kvm, root, range->start,
+							 range->end, shared, &flush);
+		if (ret < 0) {
+			if (flush)
+				kvm_flush_remote_tlbs(kvm);
+
+			kvm_tdp_mmu_put_root(kvm, root);
+			return ret;
+		}
+	}
+	return flush;
+}
+
 static bool tdp_mmu_need_write_protect(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
 	/*
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 52acf99d40a0..332d47cce714 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -69,6 +69,9 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 				  enum kvm_tdp_mmu_root_types root_types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
+int kvm_tdp_mmu_gfn_range_split_cross_boundary_leafs(struct kvm *kvm,
+						     struct kvm_gfn_range *range,
+						     bool shared);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index fb79d2b7decd..6137b76341e1 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -273,6 +273,8 @@ struct kvm_gfn_range {
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
+				   bool shared);
 #endif
 
 enum {
-- 
2.43.2


