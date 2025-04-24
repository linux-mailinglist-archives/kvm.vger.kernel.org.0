Return-Path: <kvm+bounces-44030-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC98EA99F33
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:06:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 475CC5A2BC8
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:05:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 358B21A3BC0;
	Thu, 24 Apr 2025 03:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SKyecKyl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 418D41993A3;
	Thu, 24 Apr 2025 03:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745463968; cv=none; b=VWtcdACuYS+2YvrGmWR7U+PG/tVVbCZd5Lwcz5ge3XPgyuNVQ4pCKOYwo4VRMQSWX/KdhAjLIhfZ7Wf9HlKm8JXxu3TM9BIdZPegtX7EmcIXJ42ZHVOU9xobDgVaDEfGOoxbF+rHDUmAkwNYyoiYMM+QIQYM6L2AYXZT4QKpcuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745463968; c=relaxed/simple;
	bh=Dvee4y2IFBKwQ8aW9OgsHqByB5xXTcri8l/jb/m8SI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADJbSvFHYwVLhKFgSpJlfE+R7/jopchJyEfS+qJ2HKhwCmpE1Th0SjY3pYS1T88jYEhBEfMoYB9cz67I2nw1zhTTLwzHhUtPhkO2K2bmFpSXBu+L93hJDa28MsaHT5AOC7fP5QpQ4ujomSwqu8AfJQ5xREU3cVCZ3jI+d7FMoFA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SKyecKyl; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745463963; x=1776999963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Dvee4y2IFBKwQ8aW9OgsHqByB5xXTcri8l/jb/m8SI8=;
  b=SKyecKylehvFoGeqb4WBZK86y+XsAkyUnSS8bzFl0ESVVttmuWg/vK0v
   a7+IF/DgNkUOkQ6BHlXSLhjiNOJQnC3KkCEI+tn35B093+KzXZBmlcSbZ
   LhBBe5v+tO6AxYpjPF8T0cnO+o0YIg1lkAca0VLkBtoUOX72cAq29zBSk
   iSlp+cdSDPGaE4ryixP0jhCNKGS6JlfcytkPYoMeaYhK9/31BxHV7Rb9g
   CElHlkgiJdCUJ9B8o3rGNEoYmQHkFiSSRIQpBgEchdd8tEYczOMamOcUh
   jMfZHTZpY2aQMwccYZZgY3bau50dflTCcCE5jBp810qdsyq3tQ1wMraoM
   g==;
X-CSE-ConnectionGUID: HsmXA67VRhiVYqbFsyVxaw==
X-CSE-MsgGUID: jtp0hmwAT6i40ATco8MN/Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="46951742"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="46951742"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:02 -0700
X-CSE-ConnectionGUID: wUMoAc29RtSGiuRhK9xnrw==
X-CSE-MsgGUID: a+IuH2Z+Re2SX46a1GLZNw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="163458017"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:05:56 -0700
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
Subject: [RFC PATCH 01/21] KVM: gmem: Allocate 2M huge page from guest_memfd backend
Date: Thu, 24 Apr 2025 11:04:06 +0800
Message-ID: <20250424030406.32670-1-yan.y.zhao@intel.com>
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

Allocate 2M huge pages from the guest_memfd's filemap when the max_order is
greater than or equal to PMD_ORDER.

Introduce a helper function, kvm_gmem_get_max_order(), to assist
kvm_gmem_populate() and kvm_gmem_get_pfn() in obtaining a max_order, based
on the alignment of GFN/index, range size and the consistency of page
attributes.

Pass in the max_order to __kvm_gmem_get_pfn(), which invokes
kvm_gmem_get_folio() to allocate a 2M huge page from gmem filemap if the
max_order is >= PMD_ORDER. __kvm_gmem_get_pfn() then updates the max_order
if the order of the allocated page is smaller than the requestd order.

Note:!!
This patch just serves as an glue layer on top of Michael Roth's series[1],
showing TDX's basic assumptions to the guest_memfd, i.e..
guest_memfd allocates private huge pages whenever alignment of GFN/index,
range size and the consistency of page attributes allow it.

As Dave mentioned at [2],
"Probably a good idea to focus on the long-term use case where we
have in-place conversion support, and only allow truncation in hugepage
(e.g., 2 MiB) size; conversion shared<->private could still be done on 4
KiB granularity as for hugetlb.",
"In general, I think our time is better spent
working on the real deal than on interim solutions that should not be
called "THP support",

Please don't spend much time on reviewing this patch, as it would propably
be gone or appear in another form after guest_memfd's solution based on
hugetlb for in-place-conversion is available.

Link: https://lore.kernel.org/all/20241212063635.712877-1-michael.roth@amd.com [1]
Link: https://lore.kernel.org/all/7c86c45c-17e4-4e9b-8d80-44fdfd37f38b@redhat.com [2]

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 virt/kvm/guest_memfd.c | 153 +++++++++++++++--------------------------
 1 file changed, 56 insertions(+), 97 deletions(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 5cd3b66063dc..4bb140e7f30d 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -265,36 +265,6 @@ static int kvm_gmem_prepare_folio(struct kvm *kvm, struct file *file,
 	return r;
 }
 
-static struct folio *kvm_gmem_get_huge_folio(struct inode *inode, pgoff_t index,
-					     unsigned int order)
-{
-	pgoff_t npages = 1UL << order;
-	pgoff_t huge_index = round_down(index, npages);
-	struct address_space *mapping  = inode->i_mapping;
-	gfp_t gfp = mapping_gfp_mask(mapping) | __GFP_NOWARN;
-	loff_t size = i_size_read(inode);
-	struct folio *folio;
-
-	/* Make sure hugepages would be fully-contained by inode */
-	if ((huge_index + npages) * PAGE_SIZE > size)
-		return NULL;
-
-	if (filemap_range_has_page(mapping, (loff_t)huge_index << PAGE_SHIFT,
-				   (loff_t)(huge_index + npages - 1) << PAGE_SHIFT))
-		return NULL;
-
-	folio = filemap_alloc_folio(gfp, order);
-	if (!folio)
-		return NULL;
-
-	if (filemap_add_folio(mapping, folio, huge_index, gfp)) {
-		folio_put(folio);
-		return NULL;
-	}
-
-	return folio;
-}
-
 /*
  * Returns a locked folio on success.  The caller is responsible for
  * setting the up-to-date flag before the memory is mapped into the guest.
@@ -304,14 +274,19 @@ static struct folio *kvm_gmem_get_huge_folio(struct inode *inode, pgoff_t index,
  * Ignore accessed, referenced, and dirty flags.  The memory is
  * unevictable and there is no storage to write back to.
  */
-static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index)
+static struct folio *kvm_gmem_get_folio(struct inode *inode, pgoff_t index, int max_order)
 {
 	struct folio *folio = NULL;
 
-	if (gmem_2m_enabled)
-		folio = kvm_gmem_get_huge_folio(inode, index, PMD_ORDER);
+	if (max_order >= PMD_ORDER) {
+		fgf_t fgp_flags = FGP_LOCK | FGP_ACCESSED | FGP_CREAT;
 
-	if (!folio)
+		fgp_flags |= fgf_set_order(1U << (PAGE_SHIFT + PMD_ORDER));
+		folio = __filemap_get_folio(inode->i_mapping, index, fgp_flags,
+					    mapping_gfp_mask(inode->i_mapping));
+	}
+
+	if (!folio || IS_ERR(folio))
 		folio = filemap_grab_folio(inode->i_mapping, index);
 
 	return folio;
@@ -402,49 +377,11 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
 
 static long kvm_gmem_allocate(struct inode *inode, loff_t offset, loff_t len)
 {
-	struct address_space *mapping = inode->i_mapping;
-	pgoff_t start, index, end;
-	int r;
-
-	/* Dedicated guest is immutable by default. */
-	if (offset + len > i_size_read(inode))
-		return -EINVAL;
-
-	filemap_invalidate_lock_shared(mapping);
-
-	start = offset >> PAGE_SHIFT;
-	end = (offset + len) >> PAGE_SHIFT;
-
-	r = 0;
-	for (index = start; index < end; ) {
-		struct folio *folio;
-
-		if (signal_pending(current)) {
-			r = -EINTR;
-			break;
-		}
-
-		folio = kvm_gmem_get_folio(inode, index);
-		if (IS_ERR(folio)) {
-			r = PTR_ERR(folio);
-			break;
-		}
-
-		index = folio_next_index(folio);
-
-		folio_unlock(folio);
-		folio_put(folio);
-
-		/* 64-bit only, wrapping the index should be impossible. */
-		if (WARN_ON_ONCE(!index))
-			break;
-
-		cond_resched();
-	}
-
-	filemap_invalidate_unlock_shared(mapping);
-
-	return r;
+	/*
+	 * Skip supporting allocate for now. This can be added easiler after
+	 * __kvm_gmem_get_pfn() is settled down.
+	 */
+	return -EOPNOTSUPP;
 }
 
 static long kvm_gmem_fallocate(struct file *file, int mode, loff_t offset,
@@ -853,7 +790,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	    huge_index + (1ull << *max_order) > slot->gmem.pgoff + slot->npages)
 		*max_order = 0;
 
-	folio = kvm_gmem_get_folio(file_inode(file), index);
+	folio = kvm_gmem_get_folio(file_inode(file), index, *max_order);
 	if (IS_ERR(folio))
 		return folio;
 
@@ -869,6 +806,40 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	return folio;
 }
 
+static int kvm_gmem_get_max_order(struct kvm *kvm, struct kvm_memory_slot *slot,
+				  gfn_t gfn, pgoff_t index, long npages, int *max_order)
+{
+	int ret = 0;
+	int order = 0;
+	/*
+	 * The max order shouldn't extend beyond the GFN range being
+	 * populated in this iteration, so set max_order accordingly.
+	 * __kvm_gmem_get_pfn() will then further adjust the order to
+	 * one that is contained by the backing memslot/folio.
+	 */
+	order = 0;
+
+	while (IS_ALIGNED(gfn, 1 << (order + 1)) && (npages >= (1 << (order + 1))))
+		order++;
+
+	order = min(order, PMD_ORDER);
+
+	while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << order),
+						KVM_MEMORY_ATTRIBUTE_PRIVATE,
+						KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
+		if (!order) {
+			ret = -ENOENT;
+			return ret;
+		}
+		order--;
+	}
+
+	WARN_ON(!IS_ALIGNED(index, 1 << order) || (npages < (1 << order)));
+
+	*max_order = order;
+	return ret;
+}
+
 int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 		     gfn_t gfn, kvm_pfn_t *pfn, struct page **page,
 		     int *max_order)
@@ -882,15 +853,8 @@ int kvm_gmem_get_pfn(struct kvm *kvm, struct kvm_memory_slot *slot,
 	if (!file)
 		return -EFAULT;
 
-	/*
-	 * The caller might pass a NULL 'max_order', but internally this
-	 * function needs to be aware of any order limitations set by
-	 * __kvm_gmem_get_pfn() so the scope of preparation operations can
-	 * be limited to the corresponding range. The initial order can be
-	 * arbitrarily large, but gmem doesn't currently support anything
-	 * greater than PMD_ORDER so use that for now.
-	 */
-	max_order_local = PMD_ORDER;
+	kvm_gmem_get_max_order(kvm, slot, gfn, index, slot->npages - (gfn - slot->base_gfn),
+			       &max_order_local);
 
 	folio = __kvm_gmem_get_pfn(file, slot, index, pfn, &max_order_local);
 	if (IS_ERR(folio)) {
@@ -953,6 +917,11 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			break;
 		}
 
+		ret = kvm_gmem_get_max_order(kvm, slot, gfn, kvm_gmem_get_index(slot, gfn),
+					     npages - i, &max_order);
+		if (ret)
+			break;
+
 		folio = __kvm_gmem_get_pfn(file, slot, index, &pfn, &max_order);
 		if (IS_ERR(folio)) {
 			ret = PTR_ERR(folio);
@@ -967,17 +936,8 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 		}
 
 		folio_unlock(folio);
-		WARN_ON(!IS_ALIGNED(gfn, 1 << max_order) ||
-			(npages - i) < (1 << max_order));
 
 		ret = -EINVAL;
-		while (!kvm_range_has_memory_attributes(kvm, gfn, gfn + (1 << max_order),
-							KVM_MEMORY_ATTRIBUTE_PRIVATE,
-							KVM_MEMORY_ATTRIBUTE_PRIVATE)) {
-			if (!max_order)
-				goto put_folio_and_exit;
-			max_order--;
-		}
 
 		p = src ? src + i * PAGE_SIZE : NULL;
 		ret = post_populate(kvm, gfn, pfn, p, max_order, opaque);
@@ -986,7 +946,6 @@ long kvm_gmem_populate(struct kvm *kvm, gfn_t start_gfn, void __user *src, long
 			kvm_gmem_mark_prepared(file, index, max_order);
 		}
 
-put_folio_and_exit:
 		folio_put(folio);
 		if (ret)
 			break;
-- 
2.43.2


