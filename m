Return-Path: <kvm+bounces-44046-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 470D6A99F5F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:10:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D172D3A4C84
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 528631A0BFD;
	Thu, 24 Apr 2025 03:10:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Mo9dpWki"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F6E1A7AF7;
	Thu, 24 Apr 2025 03:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464210; cv=none; b=LcOZE8QFWvSu1umpCZE7OWv+UppK1LUHoJHDf9Feiou+SqRHWNGS4UWGAVAV41d0JzGsyNMnTZJx9q6kWf3COmWxYNazBdi1M7EOBtjxdXGcj+H06lXgMCo4OaLrdx8TqLPsan2cUV3RSHrHDvzo6fCsNL06QAhpmnWv+SZLPME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464210; c=relaxed/simple;
	bh=zFnyPwzoJYit0t/0dszQ5iB4piLEtR7Lb01bHjsRmB8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tfGR0bCpkswM8cayaV5+xocPAhNOn9D47vHxgT2h5EEMDDBKsYOj9X8jIEg0apY0SJx8ogi6fG0mBSzbVyxSSt5aDxHX0U5KPvs/b+C48wloHlkqgbFop/1qN03hshwaPIkk6+dxSeAd75tkXi2BP6EmT1XSEJhpIxdlKprOkxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Mo9dpWki; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464209; x=1777000209;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zFnyPwzoJYit0t/0dszQ5iB4piLEtR7Lb01bHjsRmB8=;
  b=Mo9dpWkiAE+dWh+Q2pqfaXy76WN9jd9X/3KNk+SPwZEIE99F92NSQjb4
   E8fUbpp64+S2woIQHkAFNbo9I63U8geKdnD2jzk6ZSVCzNPJ0mMAe0uXT
   gZ+r3mkQ03ALyJ0+gzpSIrzUhM/d7TBKIc/XYAzAD4w/by3HzMHssWexQ
   7xM/d9gf9ewsiosJDjk2Ls2c5Q/ficgw4/nUTUwcEI817REusjiBO+QPY
   C1QvwIBZoNFBOAJxsZqir1MZQ7YHrT7W4/taq045cCuhtC91xbB6naJCc
   y6FshpgAjD1aDSmkAUDtUIKuhx/ouZ8uTjShCwRHxhFURFO2Od+4LGHCQ
   Q==;
X-CSE-ConnectionGUID: eTleJ/sjSQyip5fTH/5IzQ==
X-CSE-MsgGUID: 8VfeT0bwTd+xDal13n7LQw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47094573"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47094573"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:08 -0700
X-CSE-ConnectionGUID: vM1tSbwKR/2THgoiFeulkg==
X-CSE-MsgGUID: 3p5fTlWnTEeNOHyae2cQeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132332111"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:02 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
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
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 16/21] KVM: x86/mmu: Introduce kvm_split_boundary_leafs() to split boundary leafs
Date: Thu, 24 Apr 2025 11:08:16 +0800
Message-ID: <20250424030816.470-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Introduce kvm_split_boundary_leafs() to manage the splitting of boundary
leafs within the mirror root.

Before zapping a specific GFN range in the mirror root, split any huge leaf
that intersects with the boundary of the GFN range to ensure that the
subsequent zap operation does not impact any GFN outside the specified
range. This is crucial for the mirror root as the private page table
requires the guest's ACCEPT operation after faulting back a GFN.

This function should be called while kvm->mmu_lock is held for writing. The
kvm->mmu_lock is temporarily released to allocate memory for sp for split.
The only expected error is -ENOMEM.

Opportunistically, WARN in tdp_mmu_zap_leafs() if zapping a huge leaf in
the mirror root affects a GFN outside the specified range.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/mmu/mmu.c     |  21 +++++++
 arch/x86/kvm/mmu/tdp_mmu.c | 116 ++++++++++++++++++++++++++++++++++++-
 arch/x86/kvm/mmu/tdp_mmu.h |   1 +
 include/linux/kvm_host.h   |   1 +
 4 files changed, 136 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 0e227199d73e..0d49c69b6b55 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1640,6 +1640,27 @@ static bool __kvm_rmap_zap_gfn_range(struct kvm *kvm,
 				 start, end - 1, can_yield, true, flush);
 }
 
+/*
+ * Split large leafs at the boundary of the specified range for the mirror root
+ *
+ * Return value:
+ * 0 : success, no flush is required;
+ * 1 : success, flush is required;
+ * <0: failure.
+ */
+int kvm_split_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	bool ret = 0;
+
+	lockdep_assert_once(kvm->mmu_invalidate_in_progress ||
+			    lockdep_is_held(&kvm->slots_lock));
+
+	if (tdp_mmu_enabled)
+		ret = kvm_tdp_mmu_gfn_range_split_boundary(kvm, range);
+
+	return ret;
+}
+
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool flush = false;
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 0f683753a7bb..d3fba5d11ea2 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -324,6 +324,8 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				u64 old_spte, u64 new_spte, int level,
 				bool shared);
 
+static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
+				   struct kvm_mmu_page *sp, bool shared);
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror);
 static void *get_external_spt(gfn_t gfn, u64 new_spte, int level);
 
@@ -962,6 +964,19 @@ bool kvm_tdp_mmu_zap_sp(struct kvm *kvm, struct kvm_mmu_page *sp)
 	return true;
 }
 
+static inline bool iter_split_required(struct kvm *kvm, struct kvm_mmu_page *root,
+				       struct tdp_iter *iter, gfn_t start, gfn_t end)
+{
+	if (!is_mirror_sp(root) || !is_large_pte(iter->old_spte))
+		return false;
+
+	/* Fully contained, no need to split */
+	if (iter->gfn >= start && iter->gfn + KVM_PAGES_PER_HPAGE(iter->level) <= end)
+		return false;
+
+	return true;
+}
+
 /*
  * If can_yield is true, will release the MMU lock and reschedule if the
  * scheduler needs the CPU or there is contention on the MMU lock. If this
@@ -991,6 +1006,8 @@ static bool tdp_mmu_zap_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
 		    !is_last_spte(iter.old_spte, iter.level))
 			continue;
 
+		WARN_ON_ONCE(iter_split_required(kvm, root, &iter, start, end));
+
 		tdp_mmu_iter_set_spte(kvm, &iter, SHADOW_NONPRESENT_VALUE);
 
 		/*
@@ -1246,9 +1263,6 @@ static int tdp_mmu_link_sp(struct kvm *kvm, struct tdp_iter *iter,
 	return 0;
 }
 
-static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
-				   struct kvm_mmu_page *sp, bool shared);
-
 /*
  * Handle a TDP page fault (NPT/EPT violation/misconfiguration) by installing
  * page tables and SPTEs to translate the faulting guest physical address.
@@ -1341,6 +1355,102 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 	return ret;
 }
 
+/*
+ * Split large leafs at the boundary of the specified range for the mirror root
+ */
+static int tdp_mmu_split_boundary_leafs(struct kvm *kvm, struct kvm_mmu_page *root,
+					gfn_t start, gfn_t end, bool can_yield, bool *flush)
+{
+	struct kvm_mmu_page *sp = NULL;
+	struct tdp_iter iter;
+
+	WARN_ON_ONCE(!can_yield);
+
+	if (!is_mirror_sp(root))
+		return 0;
+
+	end = min(end, tdp_mmu_max_gfn_exclusive());
+
+	lockdep_assert_held_write(&kvm->mmu_lock);
+
+	rcu_read_lock();
+
+	for_each_tdp_pte_min_level(iter, kvm, root, PG_LEVEL_4K, start, end) {
+retry:
+		if (can_yield &&
+		    tdp_mmu_iter_cond_resched(kvm, &iter, *flush, false)) {
+			*flush = false;
+			continue;
+		}
+
+		if (!is_shadow_present_pte(iter.old_spte) ||
+		    !is_last_spte(iter.old_spte, iter.level) ||
+		    !iter_split_required(kvm, root, &iter, start, end))
+			continue;
+
+		if (!sp) {
+			rcu_read_unlock();
+
+			write_unlock(&kvm->mmu_lock);
+
+			sp = tdp_mmu_alloc_sp_for_split(true);
+
+			write_lock(&kvm->mmu_lock);
+
+			if (!sp) {
+				trace_kvm_mmu_split_huge_page(iter.gfn, iter.old_spte,
+							      iter.level, -ENOMEM);
+				return -ENOMEM;
+			}
+			rcu_read_lock();
+
+			iter.yielded = true;
+			continue;
+		}
+		tdp_mmu_init_child_sp(sp, &iter);
+
+		if (tdp_mmu_split_huge_page(kvm, &iter, sp, false))
+			goto retry;
+
+		sp = NULL;
+		/*
+		 * Set yielded in case after splitting to a lower level,
+		 * the new iter requires furter splitting.
+		 */
+		iter.yielded = true;
+		*flush = true;
+	}
+
+	rcu_read_unlock();
+
+	/* Leave it here though it should be impossible for the mirror root */
+	if (sp)
+		tdp_mmu_free_sp(sp);
+	return 0;
+}
+
+int kvm_tdp_mmu_gfn_range_split_boundary(struct kvm *kvm, struct kvm_gfn_range *range)
+{
+	enum kvm_tdp_mmu_root_types types;
+	struct kvm_mmu_page *root;
+	bool flush = false;
+	int ret;
+
+	types = kvm_gfn_range_filter_to_root_types(kvm, range->attr_filter) | KVM_INVALID_ROOTS;
+
+	__for_each_tdp_mmu_root_yield_safe(kvm, root, range->slot->as_id, types) {
+		ret = tdp_mmu_split_boundary_leafs(kvm, root, range->start, range->end,
+						   range->may_block, &flush);
+		if (ret < 0) {
+			if (flush)
+				kvm_flush_remote_tlbs(kvm);
+
+			return ret;
+		}
+	}
+	return flush;
+}
+
 /* Used by mmu notifier via kvm_unmap_gfn_range() */
 bool kvm_tdp_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range,
 				 bool flush)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.h b/arch/x86/kvm/mmu/tdp_mmu.h
index 52acf99d40a0..806a21d4f0e3 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.h
+++ b/arch/x86/kvm/mmu/tdp_mmu.h
@@ -69,6 +69,7 @@ void kvm_tdp_mmu_zap_all(struct kvm *kvm);
 void kvm_tdp_mmu_invalidate_roots(struct kvm *kvm,
 				  enum kvm_tdp_mmu_root_types root_types);
 void kvm_tdp_mmu_zap_invalidated_roots(struct kvm *kvm, bool shared);
+int kvm_tdp_mmu_gfn_range_split_boundary(struct kvm *kvm, struct kvm_gfn_range *range);
 
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault);
 
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 655d36e1f4db..19d7a577e7ed 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -272,6 +272,7 @@ struct kvm_gfn_range {
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_split_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range);
 #endif
 
 enum {
-- 
2.43.2


