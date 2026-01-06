Return-Path: <kvm+bounces-67124-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B6756CF7F67
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:06:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CF14B30FB139
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B8B0B332EB4;
	Tue,  6 Jan 2026 10:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Xw5kvUe8"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633A23328FE;
	Tue,  6 Jan 2026 10:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695082; cv=none; b=L5dw8aIUfjSQdsgyZTgRbW0l7Ye5xJ9ta9H6clrYhNfPN/FzBSpEEj8JGrpkJQb/FC7V0BDd/jmoCYzVPp1lD31FKff9BpMUfgpFfmFagkqb28EGiSLhzA7pWhv48/2v6JNAq8A/UzkPBbMYjPufKILIy0ciPNN9IDYSN0IQM1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695082; c=relaxed/simple;
	bh=K1PS7q8ByM2DlBU5Cu9E4tGzbXH+BzETyF184ZFRjWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tbOpAZBh/TAlfCN++yUq/FsSQ9MJgkhYwOMMoRRUct08P44R23JqFqmS04KHuUjHbDvx32KBfMe1XszI9Tsia4I1dm4Sqj9bcrCUBu4pr2kO1ScKqezSuSPt2oe0+g3xJZlz61cKYEr0lJGnm/liHNLxevZwKdmXbhUvAnVKlAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Xw5kvUe8; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695079; x=1799231079;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=K1PS7q8ByM2DlBU5Cu9E4tGzbXH+BzETyF184ZFRjWE=;
  b=Xw5kvUe8Ptx8RDVBXghxDvn51zQDbIwhRpHx/kAKJbtud24ESY+OL7ut
   7kFkLPInMITLPCbOQNHGsFMufyd8h5eyPVHEvZMZyJcQJeHbqvLyiR0ll
   Xxi039WuiOeq8SIBE2v2p6un4jMaI/42/8PKhBLXWqGHyFY72RVrFA2Pq
   G29RZ4qnJx3VSF+gqxHWYKzI41fgKIn2EJH3R9Hxmj84ggm7oNpQmUZ6a
   Iu4+LMwH0omCxBhvZbEcvHUAZuD0n6h6le7CdnYvo6JFP8c1WVdi7rd6+
   ZoKVYWIsaKfnoTg4DcAXTPEY/asMDy6K0XcQLZNmCcLb5LkD6PNH3/yt0
   w==;
X-CSE-ConnectionGUID: S1FCbjAGRBu13KckS9laaw==
X-CSE-MsgGUID: l6QIxleaTJudnBeqFvJS1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80427378"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80427378"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:38 -0800
X-CSE-ConnectionGUID: Sc7zStDwTAqazYquWwHc8A==
X-CSE-MsgGUID: n8Xq9WzmRjKbIgVNyMFhHg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202681591"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:24:33 -0800
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
Subject: [PATCH v3 15/24] KVM: x86: Split cross-boundary mirror leafs for KVM_SET_MEMORY_ATTRIBUTES
Date: Tue,  6 Jan 2026 18:22:36 +0800
Message-ID: <20260106102236.25177-1-yan.y.zhao@intel.com>
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

In TDX, private page tables require precise zapping because faulting back
the zapped mappings necessitates the guest's re-acceptance. Therefore,
before performing a zap for the private-to-shared conversion, rather than
zapping a huge leaf entry that crosses the boundary of the GFN range to be
zapped, split the leaf entry to ensure GFNs outside the conversion range
are not affected.

Invoke kvm_split_cross_boundary_leafs() in
kvm_arch_pre_set_memory_attributes() to split the huge leafs that cross
GFN range boundary before calling kvm_unmap_gfn_range() to zap the GFN
range that will be converted to shared. Only update flush status if zaps
are performed.

Unlike kvm_unmap_gfn_range(), which cannot fail,
kvm_split_cross_boundary_leafs() may fail due to memory allocation for
splitting. Update kvm_handle_gfn_range() to propagate the error back to
kvm_vm_set_mem_attributes(), which can then fail the ioctl
KVM_SET_MEMORY_ATTRIBUTES.

The downside of current implementation is that though
kvm_split_cross_boundary_leafs() is invoked before kvm_unmap_gfn_range()
for each GFN range, the entire conversion range may consist of several GFN
ranges. If an out-of-memory error occurs during the splitting of a GFN
range, some previous GFN ranges may have been successfully split and
zapped, even though their page attributes remain unchanged due to the
splitting failure.

If it's necessary, a patch can be arranged to divide a single invocation of
"kvm_handle_gfn_range(kvm, &pre_set_range)" into two, e.g.,

kvm_handle_gfn_range(kvm, &pre_set_range_prepare_and_split)
kvm_handle_gfn_range(kvm, &pre_set_range_unmap),

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Do not return flush status from kvm_split_cross_boundary_leafs(), so
  TLB is flushed only if zaps are perfomed.

RFC v2:
- update kvm_split_boundary_leafs() to kvm_split_cross_boundary_leafs() and
  invoke it only for priate-to-shared conversion.

RFC v1:
- new patch.
---
 arch/x86/kvm/mmu/mmu.c | 10 ++++++++--
 virt/kvm/kvm_main.c    | 13 +++++++++----
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1b180279aacd..35a6e37bfc68 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -8015,10 +8015,16 @@ int kvm_arch_pre_set_memory_attributes(struct kvm *kvm,
 	}
 
 	/* Unmap the old attribute page. */
-	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE)
+	if (range->arg.attributes & KVM_MEMORY_ATTRIBUTE_PRIVATE) {
 		range->attr_filter = KVM_FILTER_SHARED;
-	else
+	} else {
+		int ret;
+
 		range->attr_filter = KVM_FILTER_PRIVATE;
+		ret = kvm_split_cross_boundary_leafs(kvm, range, false);
+		if (ret)
+			return ret;
+	}
 
 	return kvm_unmap_gfn_range(kvm, range);
 }
diff --git a/virt/kvm/kvm_main.c b/virt/kvm/kvm_main.c
index 471f798dba2d..f3b0d7f8dcfd 100644
--- a/virt/kvm/kvm_main.c
+++ b/virt/kvm/kvm_main.c
@@ -2502,8 +2502,8 @@ bool kvm_range_has_vm_memory_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 	return true;
 }
 
-static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
-						 struct kvm_mmu_notifier_range *range)
+static __always_inline int kvm_handle_gfn_range(struct kvm *kvm,
+						struct kvm_mmu_notifier_range *range)
 {
 	struct kvm_gfn_range gfn_range;
 	struct kvm_memory_slot *slot;
@@ -2557,6 +2557,8 @@ static __always_inline void kvm_handle_gfn_range(struct kvm *kvm,
 
 	if (found_memslot)
 		KVM_MMU_UNLOCK(kvm);
+
+	return ret < 0 ? ret : 0;
 }
 
 static int kvm_pre_set_memory_attributes(struct kvm *kvm,
@@ -2625,7 +2627,9 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		cond_resched();
 	}
 
-	kvm_handle_gfn_range(kvm, &pre_set_range);
+	r = kvm_handle_gfn_range(kvm, &pre_set_range);
+	if (r)
+		goto out_unlock;
 
 	for (i = start; i < end; i++) {
 		r = xa_err(xa_store(&kvm->mem_attr_array, i, entry,
@@ -2634,7 +2638,8 @@ static int kvm_vm_set_mem_attributes(struct kvm *kvm, gfn_t start, gfn_t end,
 		cond_resched();
 	}
 
-	kvm_handle_gfn_range(kvm, &post_set_range);
+	r = kvm_handle_gfn_range(kvm, &post_set_range);
+	KVM_BUG_ON(r, kvm);
 
 out_unlock:
 	mutex_unlock(&kvm->slots_lock);
-- 
2.43.2


