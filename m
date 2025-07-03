Return-Path: <kvm+bounces-51369-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E44B2AF6A50
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 08:29:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 16E3E176259
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 06:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3049629293D;
	Thu,  3 Jul 2025 06:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="P6tbZnjA"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16B5B291C25;
	Thu,  3 Jul 2025 06:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524164; cv=none; b=WzQGmCvLgFpjAYS3oG1c7HWY4PahDWklVI8Z/9Lw3lnlaWiUpfa0M3dFMKPgtFFeB/LAurI5FucayDpc4BknQ2IbiFeGQt/dwUEjHE/tIJZFZPsJ1KGpoks2Ayh2Vrg9L4MCTqNaowgkbOGfzDdXiTMkI8qncfO6Htbe6uApAVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524164; c=relaxed/simple;
	bh=XFuDlrr2UJ+oulH4ssl40unO/f2SggKOd/4xvSNL/SI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=iUHNyBBM1es4TYGNmUCLpc26Jpv63lvvyEukQfZKsDj2NBGrwjWETqZrcDe93dJvCbhlqKsJRL6YriNQlSbkFcFcXNjeBbpA2dMPhEAdETVaQ5NZhgBzo71gopoQaAAdc3927mVW0Ihiiyag6mvaM8Ijqv8pxoarhGnwhPmicDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=P6tbZnjA; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751524163; x=1783060163;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=XFuDlrr2UJ+oulH4ssl40unO/f2SggKOd/4xvSNL/SI=;
  b=P6tbZnjAAx2yIMI02zucFugpMFYNW4Lq+TRF4QCdQzAjnD+pPy3iMYUK
   AlLCRKj1yEA4CPo9fC0nq4N+9PlwpfSoX/PHjNgjUMnwIqLgIZLzF1GEp
   /RPSsyrChTcvCoMk1wMYwMaPBgt3cvYhk7S2YaIhb4TuxcIMvsZ+3dKB3
   xafuxYeOa/dHoakMGhAS1fCEtlxeiS86h2edhUyIJhZwwFNudoBtxoqwI
   v8L03kXOdSDXzBj0/u/o7/1+DaH9ij+QkjBv2R6doVH/MZzG/QlcCo/vE
   L524siTO9qks08aOwDDYPdqzINIGaFXbhOuvyHgQb1V1k6hyYEaLkNhOH
   A==;
X-CSE-ConnectionGUID: fJpb43xvT7SaVkKDvI8y4A==
X-CSE-MsgGUID: 1PylTQUNS9qr/oterHVDgA==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53949835"
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="53949835"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:29:22 -0700
X-CSE-ConnectionGUID: RV0Z01BaQoCKnvMk4H13Xw==
X-CSE-MsgGUID: 652LQVcnQRKffS2NB9+87Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,283,1744095600"; 
   d="scan'208";a="158643671"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jul 2025 23:29:17 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	ira.weiny@intel.com,
	michael.roth@amd.com,
	vannapurve@google.com,
	david@redhat.com,
	ackerleytng@google.com,
	tabba@google.com,
	chao.p.peng@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH] KVM: TDX: Decouple TDX init mem region from kvm_gmem_populate()
Date: Thu,  3 Jul 2025 14:26:41 +0800
Message-ID: <20250703062641.3247-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rather than invoking kvm_gmem_populate(), allow tdx_vcpu_init_mem_region()
to use open code to populate the initial memory region into the mirror page
table, and add the region to S-EPT.

Background
===
Sean initially suggested TDX to populate initial memory region in a 4-step
way [1]. Paolo refactored guest_memfd and introduced kvm_gmem_populate()
interface [2] to help TDX populate init memory region.

tdx_vcpu_init_mem_region
    guard(mutex)(&kvm->slots_lock)
    kvm_gmem_populate
        filemap_invalidate_lock(file->f_mapping)
            __kvm_gmem_get_pfn      //1. get private PFN
            post_populate           //tdx_gmem_post_populate
                get_user_pages_fast //2. get source page
                kvm_tdp_map_page    //3. map private PFN to mirror root
                tdh_mem_page_add    //4. add private PFN to S-EPT and copy
                                         source page to it.

kvm_gmem_populate() helps TDX to "get private PFN" in step 1. Its file
invalidate lock also helps ensure the private PFN remains valid when
tdh_mem_page_add() is invoked in TDX's post_populate hook.

Though TDX does not need the folio prepration code, kvm_gmem_populate()
helps on sharing common code between SEV-SNP and TDX.

Problem
===
(1)
In Michael's series "KVM: gmem: 2MB THP support and preparedness tracking
changes" [4], kvm_gmem_get_pfn() was modified to rely on the filemap
invalidation lock for protecting its preparedness tracking. Similarly, the
in-place conversion version of guest_memfd series by Ackerly also requires
kvm_gmem_get_pfn() to acquire filemap invalidation lock [5].

kvm_gmem_get_pfn
    filemap_invalidate_lock_shared(file_inode(file)->i_mapping);

However, since kvm_gmem_get_pfn() is called by kvm_tdp_map_page(), which is
in turn invoked within kvm_gmem_populate() in TDX, a deadlock occurs on the
filemap invalidation lock.

(2)
Moreover, in step 2, get_user_pages_fast() may acquire mm->mmap_lock,
resulting in the following lock sequence in tdx_vcpu_init_mem_region():
- filemap invalidation lock --> mm->mmap_lock

However, in future code, the shared filemap invalidation lock will be held
in kvm_gmem_fault_shared() (see [6]), leading to the lock sequence:
- mm->mmap_lock --> filemap invalidation lock

This creates an AB-BA deadlock issue.

These two issues should still present in Michael Roth's code [7], [8].

Proposal
===
To prevent deadlock and the AB-BA issue, this patch enables TDX to populate
the initial memory region independently of kvm_gmem_populate(). The revised
sequence in tdx_vcpu_init_mem_region() is as follows:

tdx_vcpu_init_mem_region
    guard(mutex)(&kvm->slots_lock)
    tdx_init_mem_populate
        get_user_pages_fast //1. get source page
        kvm_tdp_map_page    //2. map private PFN to mirror root
        read_lock(&kvm->mmu_lock);
        kvm_tdp_mmu_gpa_is_mapped // 3. check if the gpa is mapped in the
                                        mirror root and return the mapped
                                        private PFN.
        tdh_mem_page_add    //4. add private PFN to S-EPT and copy source
                                 page to it
        read_unlock(&kvm->mmu_lock);

The original step 1 "get private PFN" is now integrated in the new step 3
"check if the gpa is mapped in the mirror root and return the mapped
private PFN".

With the protection of slots_lock, the read mmu_lock ensures the private
PFN added by tdh_mem_page_add() is the same one mapped in the mirror page
table. Addiontionally, before the TD state becomes TD_STATE_RUNNABLE, the
only permitted map level is 4KB, preventing any potential merging or
splitting in the mirror root under the read mmu_lock.

So, this approach should work for TDX. It still follows the spirit in
Sean's suggestion [1], where mapping the private PFN to mirror root and
adding it to the S-EPT with initial content from the source page are
executed in separate steps.

Discussions
===
The introduction of kvm_gmem_populate() was intended to make it usable by
both TDX and SEV-SNP [3], which is why Paolo provided the vendor hook
post_populate for both.

a) TDX keeps using kvm_gmem_populate().
   Pros: - keep the status quo
         - share common code between SEV-SNP and TDX, though TDX does not
           need to prepare folios.
   Cons: - we need to explore solutions to the locking issues, e.g. the
           proposal at [11].
         - PFN is faulted in twice for each GFN:
           one in __kvm_gmem_get_pfn(), another in kvm_gmem_get_pfn().

b) Michael suggested introducing some variant of
   kvm_tdp_map_page()/kvm_mmu_do_page_fault() to avoid invoking
   kvm_gmem_get_pfn() in the kvm_gmem_populate() path. [10].
   Pro:  - TDX can still invoke kvm_gmem_populate().
           can share common code between SEV-SNP and TDX.
   Cons: - only TDX needs this variant.
         - can't fix the 2nd AB-BA lock issue.

c) Change in this patch
   Pro: greater flexibility. Simplify the implementation for both SEV-SNP
        and TDX.
   Con: undermine the purpose of sharing common code.
        kvm_gmem_populate() may only be usable by SEV-SNP in future.

Link: https://lore.kernel.org/kvm/Ze-TJh0BBOWm9spT@google.com [1]
Link: https://lore.kernel.org/lkml/20240404185034.3184582-10-pbonzini@redhat.com [2]
Link: https://lore.kernel.org/lkml/20240404185034.3184582-1-pbonzini@redhat.com [3]
Link: https://lore.kernel.org/lkml/20241212063635.712877-4-michael.roth@amd.com [4]
Link: https://lore.kernel.org/all/b784326e9ccae6a08388f1bf39db70a2204bdc51.1747264138.git.ackerleytng@google.com [5]
Link: https://lore.kernel.org/all/20250430165655.605595-9-tabba@google.com [6]
Link: https://github.com/mdroth/linux/commits/mmap-swprot-v10-snp0-wip2 [7]
Link: https://lore.kernel.org/kvm/20250613005400.3694904-1-michael.roth@amd.com [8]
Link: https://lore.kernel.org/lkml/20250613151939.z5ztzrtibr6xatql@amd.com [9]
Link: https://lore.kernel.org/lkml/20250613180418.bo4vqveigxsq2ouu@amd.com [10]
Link: https://lore.kernel.org/lkml/aErK25Oo5VJna40z@yzhao56-desk.sh.intel.com [11]

Suggested-by: Vishal Annapurve <vannapurve@google.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
This is an RFC patch. Will split it later.
---
 arch/x86/kvm/mmu.h         |  3 +-
 arch/x86/kvm/mmu/tdp_mmu.c |  6 ++-
 arch/x86/kvm/vmx/tdx.c     | 96 ++++++++++++++------------------------
 3 files changed, 42 insertions(+), 63 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index b4b6860ab971..b122255c7d4e 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -257,7 +257,8 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa);
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, gpa_t gpa, int level,
+			       kvm_pfn_t *pfn);
 int kvm_tdp_map_page(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code, u8 *level);
 
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 7f3d7229b2c1..bb95c95f6531 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1934,7 +1934,8 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, root);
 }
 
-bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
+bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, gpa_t gpa, int level,
+			       kvm_pfn_t *pfn)
 {
 	struct kvm *kvm = vcpu->kvm;
 	bool is_direct = kvm_is_addr_direct(kvm, gpa);
@@ -1947,10 +1948,11 @@ bool kvm_tdp_mmu_gpa_is_mapped(struct kvm_vcpu *vcpu, u64 gpa)
 	rcu_read_lock();
 	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, root_to_sp(root));
 	rcu_read_unlock();
-	if (leaf < 0)
+	if (leaf < 0 || leaf != level)
 		return false;
 
 	spte = sptes[leaf];
+	*pfn = spte_to_pfn(spte);
 	return is_shadow_present_pte(spte) && is_last_spte(spte, leaf);
 }
 EXPORT_SYMBOL_GPL(kvm_tdp_mmu_gpa_is_mapped);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b952bc673271..f3c2bb3554c3 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1521,9 +1521,9 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 }
 
 /*
- * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to map guest pages; the
- * callback tdx_gmem_post_populate() then maps pages into private memory.
- * through the a seamcall TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
+ * KVM_TDX_INIT_MEM_REGION calls tdx_init_mem_populate() to first map guest
+ * pages into mirror page table and then maps pages into private memory through
+ * the a SEAMCALL TDH.MEM.PAGE.ADD().  The SEAMCALL also requires the
  * private EPT structures for the page to have been built before, which is
  * done via kvm_tdp_map_page(). nr_premapped counts the number of pages that
  * were added to the EPT structures but not added with TDH.MEM.PAGE.ADD().
@@ -3047,23 +3047,17 @@ void tdx_vcpu_reset(struct kvm_vcpu *vcpu, bool init_event)
 	WARN_ON_ONCE(init_event);
 }
 
-struct tdx_gmem_post_populate_arg {
-	struct kvm_vcpu *vcpu;
-	__u32 flags;
-};
-
-static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, int order, void *_arg)
+static int tdx_init_mem_populate(struct kvm_vcpu *vcpu, gpa_t gpa,
+				 void __user *src, __u32 flags)
 {
 	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
-	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
-	struct tdx_gmem_post_populate_arg *arg = _arg;
-	struct kvm_vcpu *vcpu = arg->vcpu;
-	gpa_t gpa = gfn_to_gpa(gfn);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
+	struct kvm *kvm = vcpu->kvm;
 	u8 level = PG_LEVEL_4K;
 	struct page *src_page;
 	int ret, i;
 	u64 err, entry, level_state;
+	kvm_pfn_t pfn;
 
 	/*
 	 * Get the source page if it has been faulted in. Return failure if the
@@ -3079,38 +3073,33 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	if (ret < 0)
 		goto out;
 
-	/*
-	 * The private mem cannot be zapped after kvm_tdp_map_page()
-	 * because all paths are covered by slots_lock and the
-	 * filemap invalidate lock.  Check that they are indeed enough.
-	 */
-	if (IS_ENABLED(CONFIG_KVM_PROVE_MMU)) {
-		scoped_guard(read_lock, &kvm->mmu_lock) {
-			if (KVM_BUG_ON(!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa), kvm)) {
-				ret = -EIO;
-				goto out;
-			}
-		}
-	}
+	KVM_BUG_ON(level != PG_LEVEL_4K, kvm);
 
-	ret = 0;
-	err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
-			       src_page, &entry, &level_state);
-	if (err) {
-		ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
-		goto out;
-	}
+	scoped_guard(read_lock, &kvm->mmu_lock) {
+		if (!kvm_tdp_mmu_gpa_is_mapped(vcpu, gpa, level, &pfn)) {
+			ret = -EIO;
+			goto out;
+		}
 
-	if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
-		atomic64_dec(&kvm_tdx->nr_premapped);
+		ret = 0;
+		err = tdh_mem_page_add(&kvm_tdx->td, gpa, pfn_to_page(pfn),
+				       src_page, &entry, &level_state);
+		if (err) {
+			ret = unlikely(tdx_operand_busy(err)) ? -EBUSY : -EIO;
+			goto out;
+		}
 
-	if (arg->flags & KVM_TDX_MEASURE_MEMORY_REGION) {
-		for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
-			err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
-					    &level_state);
-			if (err) {
-				ret = -EIO;
-				break;
+		if (!KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm))
+			atomic64_dec(&kvm_tdx->nr_premapped);
+
+		if (flags & KVM_TDX_MEASURE_MEMORY_REGION) {
+			for (i = 0; i < PAGE_SIZE; i += TDX_EXTENDMR_CHUNKSIZE) {
+				err = tdh_mr_extend(&kvm_tdx->td, gpa + i, &entry,
+						    &level_state);
+				if (err) {
+					ret = -EIO;
+					break;
+				}
 			}
 		}
 	}
@@ -3126,8 +3115,6 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 	struct kvm *kvm = vcpu->kvm;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct kvm_tdx_init_mem_region region;
-	struct tdx_gmem_post_populate_arg arg;
-	long gmem_ret;
 	int ret;
 
 	if (tdx->state != VCPU_TD_STATE_INITIALIZED)
@@ -3160,22 +3147,11 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 			break;
 		}
 
-		arg = (struct tdx_gmem_post_populate_arg) {
-			.vcpu = vcpu,
-			.flags = cmd->flags,
-		};
-		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
-					     u64_to_user_ptr(region.source_addr),
-					     1, tdx_gmem_post_populate, &arg);
-		if (gmem_ret < 0) {
-			ret = gmem_ret;
-			break;
-		}
-
-		if (gmem_ret != 1) {
-			ret = -EIO;
+		ret = tdx_init_mem_populate(vcpu, region.gpa,
+					    u64_to_user_ptr(region.source_addr),
+					    cmd->flags);
+		if (ret)
 			break;
-		}
 
 		region.source_addr += PAGE_SIZE;
 		region.gpa += PAGE_SIZE;
-- 
2.43.2


