Return-Path: <kvm+bounces-68303-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 601EFD3030A
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 12:14:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 346BF300B03D
	for <lists+kvm@lfdr.de>; Fri, 16 Jan 2026 11:14:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9216369970;
	Fri, 16 Jan 2026 11:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RzkhG8Cl"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF99332D45B;
	Fri, 16 Jan 2026 11:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768562050; cv=none; b=uidyeIV2q+IjljP+Bx7l2HWN9NkQwujThA7X4akgLQ7v4gL6bUy5AxeZtY/HbxhYJ8/BSZ4HkbGO0fx+z+HilJ+iGTj05bUe8VtX294ExEEdJ3e9jlDz/wmAOFkYd+1OtMsUEXu6YzNi3D4PyDKwQKEz4M797h9Q0P34Iciv6ZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768562050; c=relaxed/simple;
	bh=0SRLvn1v5u7eTbuUJ05A/prO4E/QbcRKaOudyYKH0FM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=E4l03ppe/DWguYrouJRnSf/BSZu+TzHdEgNhDGgt/P4m9NqPxyhfeoO0qdb6YPq5uIG7Tm3K7ngATJ+OYWDtUxj9nRLsVoJHD5hoHQrECvylqt9orGv5rlaTAoILimQMFy0XlVQKC7fRDSY3Caf/uLj5o6acjgtTJ4/RmA5ipJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RzkhG8Cl; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1768562048; x=1800098048;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0SRLvn1v5u7eTbuUJ05A/prO4E/QbcRKaOudyYKH0FM=;
  b=RzkhG8ClSEujVTbhVE35xTJYiSkVcBtue6eYCqdEPI+O2yxvr2/eAvRC
   OoVDqS2Pp2AVPzkwkuCpAOupdeT4fWNeF/ED/x2MDCF0o8CC5Q2yOOmfB
   wRVnJRqmuU1UAmrrosh+lCPBzW2iu99oRxxLp8AkfUCE8MGiBfQjfOJIm
   54p7z/9rVnoIQ/A47o14A2qjCLK8xCwJp0TtkAvRGIkMor2E3kkZG9do7
   r80QaRRapuCRuYG95vW2tH5jYfLvsNVahUOVeqMs65QjNWrvzRk8G2801
   38oqdBTN+VUgbugM2GYHMKwTMHaT3knZRSIFT1DlFKKAU7DFdB7R5oc7Y
   g==;
X-CSE-ConnectionGUID: EiEDjw9jR5umsoW9nHD9WQ==
X-CSE-MsgGUID: RQ50ua+URjOgRDp/qWSOtw==
X-IronPort-AV: E=McAfee;i="6800,10657,11672"; a="69930638"
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="69930638"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:14:08 -0800
X-CSE-ConnectionGUID: EolNQg6USFuQBa0DkCMuow==
X-CSE-MsgGUID: If0ItoI+QHC6rHFKmUK5Bg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,230,1763452800"; 
   d="scan'208";a="209713435"
Received: from fpallare-mobl4.ger.corp.intel.com (HELO fdugast-desk.home) ([10.245.245.100])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jan 2026 03:13:59 -0800
From: Francois Dugast <francois.dugast@intel.com>
To: intel-xe@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org,
	Matthew Brost <matthew.brost@intel.com>,
	Zi Yan <ziy@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	adhavan Srinivasan <maddy@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Felix Kuehling <Felix.Kuehling@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Lyude Paul <lyude@redhat.com>,
	Danilo Krummrich <dakr@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Leon Romanovsky <leon@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Balbir Singh <balbirs@nvidia.com>,
	linuxppc-dev@lists.ozlabs.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	amd-gfx@lists.freedesktop.org,
	nouveau@lists.freedesktop.org,
	linux-mm@kvack.org,
	linux-cxl@vger.kernel.org,
	Francois Dugast <francois.dugast@intel.com>
Subject: [PATCH v6 1/5] mm/zone_device: Reinitialize large zone device private folios
Date: Fri, 16 Jan 2026 12:10:16 +0100
Message-ID: <20260116111325.1736137-2-francois.dugast@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260116111325.1736137-1-francois.dugast@intel.com>
References: <20260116111325.1736137-1-francois.dugast@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Matthew Brost <matthew.brost@intel.com>

Reinitialize metadata for large zone device private folios in
zone_device_page_init prior to creating a higher-order zone device
private folio. This step is necessary when the folio’s order changes
dynamically between zone_device_page_init calls to avoid building a
corrupt folio. As part of the metadata reinitialization, the dev_pagemap
must be passed in from the caller because the pgmap stored in the folio
page may have been overwritten with a compound head.

Without this fix, individual pages could have invalid pgmap fields and
flags (with PG_locked being notably problematic) due to prior different
order allocations, which can, and will, result in kernel crashes.

Cc: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: adhavan Srinivasan <maddy@linux.ibm.com>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: David Airlie <airlied@gmail.com>
Cc: Simona Vetter <simona@ffwll.ch>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Maxime Ripard <mripard@kernel.org>
Cc: Thomas Zimmermann <tzimmermann@suse.de>
Cc: Lyude Paul <lyude@redhat.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leon@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: linuxppc-dev@lists.ozlabs.org
Cc: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: nouveau@lists.freedesktop.org
Cc: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org
Fixes: d245f9b4ab80 ("mm/zone_device: support large zone device private folios")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Francois Dugast <francois.dugast@intel.com>

---

The latest revision updates the commit message to explain what is broken
prior to this patch and also restructures the patch so it applies, and
works, on both the 6.19 branches and drm-tip, the latter in which includes
patches for the next kernel release PR. Intel CI passes on both the 6.19
branches and drm-tip at point of the first patch in this series and the
last (drm-tip only given subsequent patches in the series require in
patches drm-tip but not present 6.19).
---
 arch/powerpc/kvm/book3s_hv_uvmem.c       |  2 +-
 drivers/gpu/drm/amd/amdkfd/kfd_migrate.c |  2 +-
 drivers/gpu/drm/drm_pagemap.c            |  2 +-
 drivers/gpu/drm/nouveau/nouveau_dmem.c   |  2 +-
 include/linux/memremap.h                 |  9 ++++--
 lib/test_hmm.c                           |  4 ++-
 mm/memremap.c                            | 35 +++++++++++++++++++++++-
 7 files changed, 47 insertions(+), 9 deletions(-)

diff --git a/arch/powerpc/kvm/book3s_hv_uvmem.c b/arch/powerpc/kvm/book3s_hv_uvmem.c
index e5000bef90f2..7cf9310de0ec 100644
--- a/arch/powerpc/kvm/book3s_hv_uvmem.c
+++ b/arch/powerpc/kvm/book3s_hv_uvmem.c
@@ -723,7 +723,7 @@ static struct page *kvmppc_uvmem_get_page(unsigned long gpa, struct kvm *kvm)
 
 	dpage = pfn_to_page(uvmem_pfn);
 	dpage->zone_device_data = pvt;
-	zone_device_page_init(dpage, 0);
+	zone_device_page_init(dpage, &kvmppc_uvmem_pgmap, 0);
 	return dpage;
 out_clear:
 	spin_lock(&kvmppc_uvmem_bitmap_lock);
diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
index af53e796ea1b..6ada7b4af7c6 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_migrate.c
@@ -217,7 +217,7 @@ svm_migrate_get_vram_page(struct svm_range *prange, unsigned long pfn)
 	page = pfn_to_page(pfn);
 	svm_range_bo_ref(prange->svm_bo);
 	page->zone_device_data = prange->svm_bo;
-	zone_device_page_init(page, 0);
+	zone_device_page_init(page, page_pgmap(page), 0);
 }
 
 static void
diff --git a/drivers/gpu/drm/drm_pagemap.c b/drivers/gpu/drm/drm_pagemap.c
index 03ee39a761a4..38eca94f01a1 100644
--- a/drivers/gpu/drm/drm_pagemap.c
+++ b/drivers/gpu/drm/drm_pagemap.c
@@ -201,7 +201,7 @@ static void drm_pagemap_get_devmem_page(struct page *page,
 					struct drm_pagemap_zdd *zdd)
 {
 	page->zone_device_data = drm_pagemap_zdd_get(zdd);
-	zone_device_page_init(page, 0);
+	zone_device_page_init(page, page_pgmap(page), 0);
 }
 
 /**
diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nouveau/nouveau_dmem.c
index 58071652679d..3d8031296eed 100644
--- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
+++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
@@ -425,7 +425,7 @@ nouveau_dmem_page_alloc_locked(struct nouveau_drm *drm, bool is_large)
 			order = ilog2(DMEM_CHUNK_NPAGES);
 	}
 
-	zone_device_folio_init(folio, order);
+	zone_device_folio_init(folio, page_pgmap(folio_page(folio, 0)), order);
 	return page;
 }
 
diff --git a/include/linux/memremap.h b/include/linux/memremap.h
index 713ec0435b48..e3c2ccf872a8 100644
--- a/include/linux/memremap.h
+++ b/include/linux/memremap.h
@@ -224,7 +224,8 @@ static inline bool is_fsdax_page(const struct page *page)
 }
 
 #ifdef CONFIG_ZONE_DEVICE
-void zone_device_page_init(struct page *page, unsigned int order);
+void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
+			   unsigned int order);
 void *memremap_pages(struct dev_pagemap *pgmap, int nid);
 void memunmap_pages(struct dev_pagemap *pgmap);
 void *devm_memremap_pages(struct device *dev, struct dev_pagemap *pgmap);
@@ -234,9 +235,11 @@ bool pgmap_pfn_valid(struct dev_pagemap *pgmap, unsigned long pfn);
 
 unsigned long memremap_compat_align(void);
 
-static inline void zone_device_folio_init(struct folio *folio, unsigned int order)
+static inline void zone_device_folio_init(struct folio *folio,
+					  struct dev_pagemap *pgmap,
+					  unsigned int order)
 {
-	zone_device_page_init(&folio->page, order);
+	zone_device_page_init(&folio->page, pgmap, order);
 	if (order)
 		folio_set_large_rmappable(folio);
 }
diff --git a/lib/test_hmm.c b/lib/test_hmm.c
index 8af169d3873a..455a6862ae50 100644
--- a/lib/test_hmm.c
+++ b/lib/test_hmm.c
@@ -662,7 +662,9 @@ static struct page *dmirror_devmem_alloc_page(struct dmirror *dmirror,
 			goto error;
 	}
 
-	zone_device_folio_init(page_folio(dpage), order);
+	zone_device_folio_init(page_folio(dpage),
+			       page_pgmap(folio_page(page_folio(dpage), 0)),
+			       order);
 	dpage->zone_device_data = rpage;
 	return dpage;
 
diff --git a/mm/memremap.c b/mm/memremap.c
index 63c6ab4fdf08..ac7be07e3361 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -477,10 +477,43 @@ void free_zone_device_folio(struct folio *folio)
 	}
 }
 
-void zone_device_page_init(struct page *page, unsigned int order)
+void zone_device_page_init(struct page *page, struct dev_pagemap *pgmap,
+			   unsigned int order)
 {
+	struct page *new_page = page;
+	unsigned int i;
+
 	VM_WARN_ON_ONCE(order > MAX_ORDER_NR_PAGES);
 
+	for (i = 0; i < (1UL << order); ++i, ++new_page) {
+		struct folio *new_folio = (struct folio *)new_page;
+
+		/*
+		 * new_page could have been part of previous higher order folio
+		 * which encodes the order, in page + 1, in the flags bits. We
+		 * blindly clear bits which could have set my order field here,
+		 * including page head.
+		 */
+		new_page->flags.f &= ~0xffUL;	/* Clear possible order, page head */
+
+#ifdef NR_PAGES_IN_LARGE_FOLIO
+		/*
+		 * This pointer math looks odd, but new_page could have been
+		 * part of a previous higher order folio, which sets _nr_pages
+		 * in page + 1 (new_page). Therefore, we use pointer casting to
+		 * correctly locate the _nr_pages bits within new_page which
+		 * could have modified by previous higher order folio.
+		 */
+		((struct folio *)(new_page - 1))->_nr_pages = 0;
+#endif
+
+		new_folio->mapping = NULL;
+		new_folio->pgmap = pgmap;	/* Also clear compound head */
+		new_folio->share = 0;   /* fsdax only, unused for device private */
+		VM_WARN_ON_FOLIO(folio_ref_count(new_folio), new_folio);
+		VM_WARN_ON_FOLIO(!folio_is_zone_device(new_folio), new_folio);
+	}
+
 	/*
 	 * Drivers shouldn't be allocating pages after calling
 	 * memunmap_pages().
-- 
2.43.0


