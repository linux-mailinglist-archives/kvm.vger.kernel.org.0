Return-Path: <kvm+bounces-16795-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 545198BDB5A
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 08:24:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D5A381F22009
	for <lists+kvm@lfdr.de>; Tue,  7 May 2024 06:24:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A75873528;
	Tue,  7 May 2024 06:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RXjWKWOC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234506F07E;
	Tue,  7 May 2024 06:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715062941; cv=none; b=S8A2w4A3Q7OTwdzVTbq8YJdGNZJppxftIAsQzElVf3XqIAxzncraF+aZCjpu0ib8pav6hQMisE2y2KsuKN7fTRKgXmljN2VhjzIKy2+WFgnGHbkR7HkBmJbznop9ClNun0SEgWGLlIVCx0UD/9xJ4m4LDmBeZzGHGjal2w4Hong=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715062941; c=relaxed/simple;
	bh=VNRR4fx4YmPYaR7+Cgk91GS1CDvBbw1zKYy24fWdEs4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=IopaWhFGc5zEN/iCBPwDmorReUmCTNI6MEZJK1TL8JcSArimzbmwe/MgclX6Pdhm+3U8Sku2LIcqJd63vUCOrw/Wpt793Ye80I31yjHQL31SQXACgw2fZWPKnE4h65aiE5K1sIS0GHyy+hJ1qaRKEzvuUMliPWroSI3RGDUSjfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RXjWKWOC; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715062940; x=1746598940;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=VNRR4fx4YmPYaR7+Cgk91GS1CDvBbw1zKYy24fWdEs4=;
  b=RXjWKWOCnkNVGO02M8loVB3fzcKnd+I6ncMSMRNHqrfV8tAVO9PVJ2gT
   dBx4PiSe2NwtKbVEqVfePuxJg0PxPf/0u872x3PwIAYQ7l77pBgjjy8Hm
   ThOrHgnpoDHwcid4FOfcQG754pw9mwIYTvp64FLOvEaNX9g916CfMLz3f
   0s9S45iyXM1XFT44Ne02vGwfDO1yxMX4/dwUj617mzVAA4Y9z6KA4I1Pl
   nzO47soLevEBo5xpIqLXUOfI32VfbXnafj+ig15RsKbd6n+5riMX0SWa4
   XVNsjeQDxJTKMxlDy55mus2qYDQhH4sq9hAlxW8mFKHLHFx4nez0u3WI8
   A==;
X-CSE-ConnectionGUID: 16a3ubdyRHO9QYTA++w5Vg==
X-CSE-MsgGUID: CSAaFozYRTGl0eTMWsgSeA==
X-IronPort-AV: E=McAfee;i="6600,9927,11065"; a="11376138"
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="11376138"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:22:19 -0700
X-CSE-ConnectionGUID: vZ4DaZevSs2y/SHiQir9dA==
X-CSE-MsgGUID: 3vFs5M/fS6yR8m5yKpRQbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,260,1708416000"; 
   d="scan'208";a="28930445"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2024 23:22:14 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	x86@kernel.org,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	kevin.tian@intel.com
Cc: iommu@lists.linux.dev,
	pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	hpa@zytor.com,
	corbet@lwn.net,
	joro@8bytes.org,
	will@kernel.org,
	robin.murphy@arm.com,
	baolu.lu@linux.intel.com,
	yi.l.liu@intel.com,
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [PATCH 4/5] vfio/type1: Flush CPU caches on DMA pages in non-coherent domains
Date: Tue,  7 May 2024 14:21:38 +0800
Message-Id: <20240507062138.20465-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20240507061802.20184-1-yan.y.zhao@intel.com>
References: <20240507061802.20184-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>

Flush CPU cache on DMA pages before mapping them into the first
non-coherent domain (domain that does not enforce cache coherency, i.e. CPU
caches are not force-snooped) and after unmapping them from the last
domain.

Devices attached to non-coherent domains can execute non-coherent DMAs
(DMAs that lack CPU cache snooping) to access physical memory with CPU
caches bypassed.

Such a scenario could be exploited by a malicious guest, allowing them to
access stale host data in memory rather than the data initialized by the
host (e.g., zeros) in the cache, thus posing a risk of information leakage
attack.

Furthermore, the host kernel (e.g. a ksm thread) might encounter
inconsistent data between the CPU cache and memory (left by a malicious
guest) after a page is unpinned for DMA but before it's recycled.

Therefore, it is required to flush the CPU cache before a page is
accessible to non-coherent DMAs and after the page is inaccessible to
non-coherent DMAs.

However, the CPU cache is not flushed immediately when the page is unmapped
from the last non-coherent domain. Instead, the flushing is performed
lazily, right before the page is unpinned.
Take the following example to illustrate the process. The CPU cache is
flushed right before step 2 and step 5.
1. A page is mapped into a coherent domain.
2. The page is mapped into a non-coherent domain.
3. The page is unmapped from the non-coherent domain e.g.due to hot-unplug.
4. The page is unmapped from the coherent domain.
5. The page is unpinned.

Reasons for adopting this lazily flushing design include:
- There're several unmap paths and only one unpin path. Lazily flush before
  unpin wipes out the inconsistency between cache and physical memory
  before a page is globally visible and produces code that is simpler, more
  maintainable and easier to backport.
- Avoid dividing a large unmap range into several smaller ones or
  allocating additional memory to hold IOVA to HPA relationship.

Reported-by: Jason Gunthorpe <jgg@nvidia.com>
Closes: https://lore.kernel.org/lkml/20240109002220.GA439767@nvidia.com
Fixes: 73fa0d10d077 ("vfio: Type1 IOMMU implementation")
Cc: Alex Williamson <alex.williamson@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 drivers/vfio/vfio_iommu_type1.c | 51 +++++++++++++++++++++++++++++++++
 1 file changed, 51 insertions(+)

diff --git a/drivers/vfio/vfio_iommu_type1.c b/drivers/vfio/vfio_iommu_type1.c
index b5c15fe8f9fc..ce873f4220bf 100644
--- a/drivers/vfio/vfio_iommu_type1.c
+++ b/drivers/vfio/vfio_iommu_type1.c
@@ -74,6 +74,7 @@ struct vfio_iommu {
 	bool			v2;
 	bool			nesting;
 	bool			dirty_page_tracking;
+	bool			has_noncoherent_domain;
 	struct list_head	emulated_iommu_groups;
 };
 
@@ -99,6 +100,7 @@ struct vfio_dma {
 	unsigned long		*bitmap;
 	struct mm_struct	*mm;
 	size_t			locked_vm;
+	bool			cache_flush_required; /* For noncoherent domain */
 };
 
 struct vfio_batch {
@@ -716,6 +718,9 @@ static long vfio_unpin_pages_remote(struct vfio_dma *dma, dma_addr_t iova,
 	long unlocked = 0, locked = 0;
 	long i;
 
+	if (dma->cache_flush_required)
+		arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT, npage << PAGE_SHIFT);
+
 	for (i = 0; i < npage; i++, iova += PAGE_SIZE) {
 		if (put_pfn(pfn++, dma->prot)) {
 			unlocked++;
@@ -1099,6 +1104,8 @@ static long vfio_unmap_unpin(struct vfio_iommu *iommu, struct vfio_dma *dma,
 					    &iotlb_gather);
 	}
 
+	dma->cache_flush_required = false;
+
 	if (do_accounting) {
 		vfio_lock_acct(dma, -unlocked, true);
 		return 0;
@@ -1120,6 +1127,21 @@ static void vfio_remove_dma(struct vfio_iommu *iommu, struct vfio_dma *dma)
 	iommu->dma_avail++;
 }
 
+static void vfio_update_noncoherent_domain_state(struct vfio_iommu *iommu)
+{
+	struct vfio_domain *domain;
+	bool has_noncoherent = false;
+
+	list_for_each_entry(domain, &iommu->domain_list, next) {
+		if (domain->enforce_cache_coherency)
+			continue;
+
+		has_noncoherent = true;
+		break;
+	}
+	iommu->has_noncoherent_domain = has_noncoherent;
+}
+
 static void vfio_update_pgsize_bitmap(struct vfio_iommu *iommu)
 {
 	struct vfio_domain *domain;
@@ -1455,6 +1477,12 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 
 	vfio_batch_init(&batch);
 
+	/*
+	 * Record necessity to flush CPU cache to make sure CPU cache is flushed
+	 * for both pin & map and unmap & unpin (for unwind) paths.
+	 */
+	dma->cache_flush_required = iommu->has_noncoherent_domain;
+
 	while (size) {
 		/* Pin a contiguous chunk of memory */
 		npage = vfio_pin_pages_remote(dma, vaddr + dma->size,
@@ -1466,6 +1494,10 @@ static int vfio_pin_map_dma(struct vfio_iommu *iommu, struct vfio_dma *dma,
 			break;
 		}
 
+		if (dma->cache_flush_required)
+			arch_clean_nonsnoop_dma(pfn << PAGE_SHIFT,
+						npage << PAGE_SHIFT);
+
 		/* Map it! */
 		ret = vfio_iommu_map(iommu, iova + dma->size, pfn, npage,
 				     dma->prot);
@@ -1683,9 +1715,14 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 	for (; n; n = rb_next(n)) {
 		struct vfio_dma *dma;
 		dma_addr_t iova;
+		bool cache_flush_required;
 
 		dma = rb_entry(n, struct vfio_dma, node);
 		iova = dma->iova;
+		cache_flush_required = !domain->enforce_cache_coherency &&
+				       !dma->cache_flush_required;
+		if (cache_flush_required)
+			dma->cache_flush_required = true;
 
 		while (iova < dma->iova + dma->size) {
 			phys_addr_t phys;
@@ -1737,6 +1774,9 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 				size = npage << PAGE_SHIFT;
 			}
 
+			if (cache_flush_required)
+				arch_clean_nonsnoop_dma(phys, size);
+
 			ret = iommu_map(domain->domain, iova, phys, size,
 					dma->prot | IOMMU_CACHE,
 					GFP_KERNEL_ACCOUNT);
@@ -1801,6 +1841,7 @@ static int vfio_iommu_replay(struct vfio_iommu *iommu,
 			vfio_unpin_pages_remote(dma, iova, phys >> PAGE_SHIFT,
 						size >> PAGE_SHIFT, true);
 		}
+		dma->cache_flush_required = false;
 	}
 
 	vfio_batch_fini(&batch);
@@ -1828,6 +1869,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
 	if (!pages)
 		return;
 
+	if (!domain->enforce_cache_coherency)
+		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
+
 	list_for_each_entry(region, regions, list) {
 		start = ALIGN(region->start, PAGE_SIZE * 2);
 		if (start >= region->end || (region->end - start < PAGE_SIZE * 2))
@@ -1847,6 +1891,9 @@ static void vfio_test_domain_fgsp(struct vfio_domain *domain, struct list_head *
 		break;
 	}
 
+	if (!domain->enforce_cache_coherency)
+		arch_clean_nonsnoop_dma(page_to_phys(pages), PAGE_SIZE * 2);
+
 	__free_pages(pages, order);
 }
 
@@ -2308,6 +2355,8 @@ static int vfio_iommu_type1_attach_group(void *iommu_data,
 
 	list_add(&domain->next, &iommu->domain_list);
 	vfio_update_pgsize_bitmap(iommu);
+	if (!domain->enforce_cache_coherency)
+		vfio_update_noncoherent_domain_state(iommu);
 done:
 	/* Delete the old one and insert new iova list */
 	vfio_iommu_iova_insert_copy(iommu, &iova_copy);
@@ -2508,6 +2557,8 @@ static void vfio_iommu_type1_detach_group(void *iommu_data,
 			}
 			iommu_domain_free(domain->domain);
 			list_del(&domain->next);
+			if (!domain->enforce_cache_coherency)
+				vfio_update_noncoherent_domain_state(iommu);
 			kfree(domain);
 			vfio_iommu_aper_expand(iommu, &iova_copy);
 			vfio_update_pgsize_bitmap(iommu);
-- 
2.17.1


