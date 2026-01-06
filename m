Return-Path: <kvm+bounces-67123-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4403CF7C63
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:25:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 7D4233048937
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:24:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 534183314DF;
	Tue,  6 Jan 2026 10:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kauFI1zN"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7CC330D58;
	Tue,  6 Jan 2026 10:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695068; cv=none; b=teDiJs68bh5oghQaveXZNH+YY+o3gLeAt+IcG8MGyXDezO5CZasZz8cdSAOb1Gosa+Syvbjml3z+l4pcI0vCee1lKD/mWlBUhReAwAH5z9efq242HuV7k+ItTJl01TYylYVh5wA89bLhvxgwE02I3FiHu+CywSZof6W8we8regM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695068; c=relaxed/simple;
	bh=ffK1vQpvyzKmlUzz2zxoihkeD9nVSu7GIDcTNxPg6ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAHKvustFRbaL8I9p4wmhGHZTjSXJyNn4FxneBVZ2ulEw2lkgZcymxTYocaSf1gWxZyVv6EhEb0wH2fjjsSH64dF/1z3TG8e3NX08qZWW3KT2c/6x9dnayvVFrjGQxtbmBaEbqGI73PQ47yrcc5sPA/B1pDg+b61bBJS4LulHKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kauFI1zN; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695065; x=1799231065;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ffK1vQpvyzKmlUzz2zxoihkeD9nVSu7GIDcTNxPg6ZM=;
  b=kauFI1zNy553EM7fgpVzVUwd5nzJw/faJZIBs9lji7LKrWgQfje0TrBG
   +iOxsAMCBtUsKJmILH4bTl46m2HouIEN8CBo+98aCSrORd6XSO048lQrL
   m81fjugU62C5vu6yKlgi9ym/FrAq2A1mVMufS6GrAUEfgI3W+J6XZsQSY
   80OMkEvVCqbzIgsvbHbtHlr7gi7BwhhTskIGnfjPJVjcdjVsLq4gX5OE9
   IIScZ2UpvG8X3B3tHf38QXaQwGGtbDYlTOleQK/vQyfUYS+56zPpRJBZK
   SwxY95pHJyN8uaW+JzSNG+5d0tOoR3sbfxjDYWCisBjIleHhhSkWXe0/t
   w==;
X-CSE-ConnectionGUID: vEFYgxLjSNGz8nDdPRziUA==
X-CSE-MsgGUID: 9i6Dut6LQmW8CQxLaUvLIA==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80427348"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80427348"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:24 -0800
X-CSE-ConnectionGUID: qZCS4Z+ISYiXm6jdpoxKCg==
X-CSE-MsgGUID: qw4VeN+7TxSY9JjDNSm1xg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202681573"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:19 -0800
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
Subject: [PATCH v3 14/24] KVM: Change the return type of gfn_handler_t() from bool to int
Date: Tue,  6 Jan 2026 18:22:22 +0800
Message-ID: <20260106102222.25160-1-yan.y.zhao@intel.com>
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

Modify the return type of gfn_handler_t() from bool to int. A negative
return value indicates failure, while a return value of 1 signifies success
with a flush required, and 0 denotes success without a flush required.

This adjustment prepares for a later change that will enable
kvm_pre_set_memory_attributes() to fail.

No functional changes expected.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Rebased.

RFC v2:
- No change

RFC v1:
- New patch.
---
 arch/arm64/kvm/mmu.c             |  8 ++++----
 arch/loongarch/kvm/mmu.c         |  8 ++++----
 arch/mips/kvm/mmu.c              |  6 +++---
 arch/powerpc/kvm/book3s.c        |  4 ++--
 arch/powerpc/kvm/e500_mmu_host.c |  8 ++++----
 arch/riscv/kvm/mmu.c             | 12 ++++++------
 arch/x86/kvm/mmu/mmu.c           | 20 ++++++++++----------
 include/linux/kvm_host.h         | 12 ++++++------
 virt/kvm/kvm_main.c              | 24 ++++++++++++++++--------
 9 files changed, 55 insertions(+), 47 deletions(-)

diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
index 5ab0cfa08343..c39d3ef577f8 100644
--- a/arch/arm64/kvm/mmu.c
+++ b/arch/arm64/kvm/mmu.c
@@ -2221,12 +2221,12 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.mmu.pgt)
-		return false;
+		return 0;
 
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
@@ -2237,12 +2237,12 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	 */
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	u64 size = (range->end - range->start) << PAGE_SHIFT;
 
 	if (!kvm->arch.mmu.pgt)
-		return false;
+		return 0;
 
 	return KVM_PGT_FN(kvm_pgtable_stage2_test_clear_young)(kvm->arch.mmu.pgt,
 						   range->start << PAGE_SHIFT,
diff --git a/arch/loongarch/kvm/mmu.c b/arch/loongarch/kvm/mmu.c
index a7fa458e3360..06fa060878c9 100644
--- a/arch/loongarch/kvm/mmu.c
+++ b/arch/loongarch/kvm/mmu.c
@@ -511,7 +511,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 			range->end << PAGE_SHIFT, &ctx);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_ptw_ctx ctx;
 
@@ -523,15 +523,15 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 				range->end << PAGE_SHIFT, &ctx);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	gpa_t gpa = range->start << PAGE_SHIFT;
 	kvm_pte_t *ptep = kvm_populate_gpa(kvm, NULL, gpa, 0);
 
 	if (ptep && kvm_pte_present(NULL, ptep) && kvm_pte_young(*ptep))
-		return true;
+		return 1;
 
-	return false;
+	return 0;
 }
 
 /*
diff --git a/arch/mips/kvm/mmu.c b/arch/mips/kvm/mmu.c
index d2c3b6b41f18..c26cc89c8e98 100644
--- a/arch/mips/kvm/mmu.c
+++ b/arch/mips/kvm/mmu.c
@@ -444,18 +444,18 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return true;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	return kvm_mips_mkold_gpa_pt(kvm, range->start, range->end);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	gpa_t gpa = range->start << PAGE_SHIFT;
 	pte_t *gpa_pte = kvm_mips_pte_for_gpa(kvm, NULL, gpa);
 
 	if (!gpa_pte)
-		return false;
+		return 0;
 	return pte_young(*gpa_pte);
 }
 
diff --git a/arch/powerpc/kvm/book3s.c b/arch/powerpc/kvm/book3s.c
index d79c5d1098c0..9bf6e1cf64f1 100644
--- a/arch/powerpc/kvm/book3s.c
+++ b/arch/powerpc/kvm/book3s.c
@@ -886,12 +886,12 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm->arch.kvm_ops->unmap_gfn_range(kvm, range);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	return kvm->arch.kvm_ops->age_gfn(kvm, range);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	return kvm->arch.kvm_ops->test_age_gfn(kvm, range);
 }
diff --git a/arch/powerpc/kvm/e500_mmu_host.c b/arch/powerpc/kvm/e500_mmu_host.c
index 06caf8bbbe2b..dd5411ee242e 100644
--- a/arch/powerpc/kvm/e500_mmu_host.c
+++ b/arch/powerpc/kvm/e500_mmu_host.c
@@ -697,16 +697,16 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return kvm_e500_mmu_unmap_gfn(kvm, range);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return false;
+	return 0;
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	/* XXX could be more clever ;) */
-	return false;
+	return 0;
 }
 
 /*****************************************/
diff --git a/arch/riscv/kvm/mmu.c b/arch/riscv/kvm/mmu.c
index 4ab06697bfc0..aa163d2ef7d5 100644
--- a/arch/riscv/kvm/mmu.c
+++ b/arch/riscv/kvm/mmu.c
@@ -259,7 +259,7 @@ bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 	return false;
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	pte_t *ptep;
 	u32 ptep_level = 0;
@@ -267,7 +267,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	struct kvm_gstage gstage;
 
 	if (!kvm->arch.pgd)
-		return false;
+		return 0;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
@@ -277,12 +277,12 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	gstage.pgd = kvm->arch.pgd;
 	if (!kvm_riscv_gstage_get_leaf(&gstage, range->start << PAGE_SHIFT,
 				       &ptep, &ptep_level))
-		return false;
+		return 0;
 
 	return ptep_test_and_clear_young(NULL, 0, ptep);
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	pte_t *ptep;
 	u32 ptep_level = 0;
@@ -290,7 +290,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	struct kvm_gstage gstage;
 
 	if (!kvm->arch.pgd)
-		return false;
+		return 0;
 
 	WARN_ON(size != PAGE_SIZE && size != PMD_SIZE && size != PUD_SIZE);
 
@@ -300,7 +300,7 @@ bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	gstage.pgd = kvm->arch.pgd;
 	if (!kvm_riscv_gstage_get_leaf(&gstage, range->start << PAGE_SHIFT,
 				       &ptep, &ptep_level))
-		return false;
+		return 0;
 
 	return pte_young(ptep_get(ptep));
 }
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 029f2f272ffc..1b180279aacd 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -1810,7 +1810,7 @@ static bool kvm_may_have_shadow_mmu_sptes(struct kvm *kvm)
 	return !tdp_mmu_enabled || READ_ONCE(kvm->arch.indirect_shadow_pages);
 }
 
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
@@ -1823,7 +1823,7 @@ bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 	return young;
 }
 
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	bool young = false;
 
@@ -7962,8 +7962,8 @@ static void hugepage_set_mixed(struct kvm_memory_slot *slot, gfn_t gfn,
 	lpage_info_slot(gfn, slot, level)->disallow_lpage |= KVM_LPAGE_MIXED_FLAG;
 }
 
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
-					struct kvm_gfn_range *range)
+int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+				       struct kvm_gfn_range *range)
 {
 	struct kvm_memory_slot *slot = range->slot;
 	int level;
@@ -7980,10 +7980,10 @@ bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	 * a hugepage can be used for affected ranges.
 	 */
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
-		return false;
+		return 0;
 
 	if (WARN_ON_ONCE(range->end <= range->start))
-		return false;
+		return 0;
 
 	/*
 	 * If the head and tail pages of the range currently allow a hugepage,
@@ -8042,8 +8042,8 @@ static bool hugepage_has_attrs(struct kvm *kvm, struct kvm_memory_slot *slot,
 	return true;
 }
 
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range)
+int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
+					struct kvm_gfn_range *range)
 {
 	unsigned long attrs = range->arg.attributes;
 	struct kvm_memory_slot *slot = range->slot;
@@ -8059,7 +8059,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 	 * SHARED may now allow hugepages.
 	 */
 	if (WARN_ON_ONCE(!kvm_arch_has_private_mem(kvm)))
-		return false;
+		return 0;
 
 	/*
 	 * The sequence matters here: upper levels consume the result of lower
@@ -8106,7 +8106,7 @@ bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 				hugepage_set_mixed(slot, gfn, level);
 		}
 	}
-	return false;
+	return 0;
 }
 
 void kvm_mmu_init_memslot_memory_attributes(struct kvm *kvm,
diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index e563bb22c481..6f3d29db0505 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -273,8 +273,8 @@ struct kvm_gfn_range {
 	bool lockless;
 };
 bool kvm_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
-bool kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_test_age_gfn(struct kvm *kvm, struct kvm_gfn_range *range);
 int kvm_split_cross_boundary_leafs(struct kvm *kvm, struct kvm_gfn_range *range,
 				   bool shared);
 #endif
@@ -734,10 +734,10 @@ static inline bool kvm_arch_has_private_mem(struct kvm *kvm)
 extern bool vm_memory_attributes;
 bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 				     unsigned long mask, unsigned long attrs);
-bool kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
+				       struct kvm_gfn_range *range);
+int kvm_arch_post_set_memory_attributes(struct kvm *kvm,
 					struct kvm_gfn_range *range);
-bool kvm_arch_post_set_memory_attributes(struct kvm *kvm,
-					 struct kvm_gfn_range *range);
 #else
 #define vm_memory_attributes false
 #endif /* CONFIG_KVM_VM_MEMORY_ATTRIBUTES */
@@ -1568,7 +1568,7 @@ void *kvm_mmu_memory_cache_alloc(struct kvm_mmu_memory_cache *mc);
 void kvm_mmu_invalidate_begin(struct kvm *kvm);
 void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end);
 void kvm_mmu_invalidate_end(struct kvm *kvm);
-bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
+int kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range);
 
 long kvm_arch_dev_ioctl(struct file *filp,
 			unsigned int ioctl, unsigned long arg);
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index feeef7747099..471f798dba2d 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -517,7 +517,7 @@ static inline struct kvm *mmu_notifier_to_kvm(struct mmu_notifier *mn)
 	return container_of(mn, struct kvm, mmu_notifier);
 }
 
-typedef bool (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
+typedef int (*gfn_handler_t)(struct kvm *kvm, struct kvm_gfn_range *range);
 
 typedef void (*on_lock_fn_t)(struct kvm *kvm);
 
@@ -601,6 +601,7 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 		kvm_for_each_memslot_in_hva_range(node, slots,
 						  range->start, range->end - 1) {
 			unsigned long hva_start, hva_end;
+			int ret;
 
 			slot = container_of(node, struct kvm_memory_slot, hva_node[slots->node_idx]);
 			hva_start = max_t(unsigned long, range->start, slot->userspace_addr);
@@ -641,7 +642,9 @@ static __always_inline kvm_mn_ret_t kvm_handle_hva_range(struct kvm *kvm,
 						goto mmu_unlock;
 				}
 			}
-			r.ret |= range->handler(kvm, &gfn_range);
+			ret = range->handler(kvm, &gfn_range);
+			WARN_ON_ONCE(ret < 0);
+			r.ret |= ret;
 		}
 	}
 
@@ -727,7 +730,7 @@ void kvm_mmu_invalidate_range_add(struct kvm *kvm, gfn_t start, gfn_t end)
 	}
 }
 
-bool kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
+int kvm_mmu_unmap_gfn_range(struct kvm *kvm, struct kvm_gfn_range *range)
 {
 	kvm_mmu_invalidate_range_add(kvm, range->start, range->end);
 	return kvm_unmap_gfn_range(kvm, range);
@@ -2507,7 +2510,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 	struct kvm_memslots *slots;
 	struct kvm_memslot_iter iter;
 	bool found_memslot = false;
-	bool ret = false;
+	bool flush = false;
+	int ret = 0;
 	int i;
 
 	gfn_range.arg = range->arg;
@@ -2540,19 +2544,23 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 					range->on_lock(kvm);
 			}
 
-			ret |= range->handler(kvm, &gfn_range);
+			ret = range->handler(kvm, &gfn_range);
+			if (ret < 0)
+				goto err;
+			flush |= ret;
 		}
 	}
 
-	if (range->flush_on_ret && ret)
+err:
+	if (range->flush_on_ret && flush)
 		kvm_flush_remote_tlbs(kvm);
 
 	if (found_memslot)
 		KVM_MMU_UNLOCK(kvm);
 }
 
-static bool kvm_pre_set_memory_attributes(struct kvm *kvm,
-					  struct kvm_gfn_range *range)
+static int kvm_pre_set_memory_attributes(struct kvm *kvm,
+					 struct kvm_gfn_range *range)
 {
 	/*
 	 * Unconditionally add the range to the invalidation set, regardless of
-- 
2.43.2


