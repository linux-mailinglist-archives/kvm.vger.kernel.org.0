Return-Path: <kvm+bounces-54229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5632AB1D505
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:43:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8A79E3B53BD
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:43:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48D08261586;
	Thu,  7 Aug 2025 09:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EaV1Q8iC"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016EF25C81E;
	Thu,  7 Aug 2025 09:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559773; cv=none; b=DOMjHGqu6Lc3GICMwyMFosLJ6PVmRAGrat3IpOCdepxHgxGqVKZO7RW3v5VWdKWLELkpprVj6uPxTYinF0qLCqK/YiM74anWIs+e9fLpca9h9HIqah8RaF06z3Z12c0Jq2XnP33Q1teQt7QWLZXrARuQbh6n+GpfMnuGiQtutk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559773; c=relaxed/simple;
	bh=jSnn+GYLn4HvlfUl5zRC+7Nu0/pnbmXsYvkVtIWX8Fk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fQt2fEcsWJ5ZLKpf2kue4tI2wN+lloBoLWdN4860ZuBtgR1cGcZXvKoio347/o6hAOeWeLhDuubJKnag2gfNB0AFeQPp42ddIpo3n+vIiJeXp20D9K1U3NgZnF8HZqf4R0RuVOKLk93aaFpyKZIrot7Funwm0Y2daEwrhaJ5qIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EaV1Q8iC; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559772; x=1786095772;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jSnn+GYLn4HvlfUl5zRC+7Nu0/pnbmXsYvkVtIWX8Fk=;
  b=EaV1Q8iCU8Nc1nhBB4SlFidMc6MO2nH9YdmksUXbI9COEXoLpk4dD2BC
   +Q4MgWgzXrkrGuOhnvFnpQjk/9trC/kL2YHNjWWXSssShr1sYgjuUTBEK
   e2RBl0uFkvLJSSRtQR7iYCHvqVeKP8AuBBt2caJ57fZLA1B+MId9kKqXD
   Mw+Y6MLR7zmJ1kROA1Zg9gj6V9Mz69JFeOWqLbMSbBJhJUejhdlyUmIPg
   gBC6UUALn3sa4c5brZYaAPE13nR5DnILb368x4vT0TXDr6XP+AtCLeEe1
   YDQLhWGheiOkX5Md/6Osiflif59vBK82WbxLTXgezceDuzCZ4jLi3NE8m
   A==;
X-CSE-ConnectionGUID: BF2oaSX5Qc2INOcb3GA/xg==
X-CSE-MsgGUID: kH05Cg+DSzSMTS/ri1q5XQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68265924"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68265924"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:51 -0700
X-CSE-ConnectionGUID: pcDJG5E2RjSNB55VP2QIfQ==
X-CSE-MsgGUID: NWNA9I7kS4WLaZ75O26l0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="196006809"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:43 -0700
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
Subject: [RFC PATCH v2 04/23] KVM: TDX: Introduce tdx_clear_folio() to clear huge pages
Date: Thu,  7 Aug 2025 17:42:14 +0800
Message-ID: <20250807094214.4495-1-yan.y.zhao@intel.com>
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

After removing or reclaiming a guest private page or a control page from a
TD, zero the physical page using movdir64b(), enabling the kernel to reuse
the pages.

Introduce the function tdx_clear_folio() to zero out physical memory using
movdir64b(), starting from the page at "start_idx" within a "folio" and
spanning "npages" contiguous PFNs.

Convert tdx_clear_page() to be a helper function to facilitate the
zeroing of 4KB pages.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Add tdx_clear_folio().
- Drop inner loop _tdx_clear_page() and move __mb() outside of the loop.
  (Rick)
- Use C99-style definition of variables inside a for loop.
- Note: [1] also changes tdx_clear_page(). RFC v2 is not based on [1] now.

[1] https://lore.kernel.org/all/20250724130354.79392-2-adrian.hunter@intel.com

RFC v1:
- split out, let tdx_clear_page() accept level.
---
 arch/x86/kvm/vmx/tdx.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 8eaf8431c5f1..4fabefb27135 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -277,18 +277,21 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void tdx_clear_page(struct page *page)
+static void tdx_clear_folio(struct folio *folio, unsigned long start_idx,
+			    unsigned long npages)
 {
 	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
-	void *dest = page_to_virt(page);
-	unsigned long i;
 
 	/*
 	 * The page could have been poisoned.  MOVDIR64B also clears
 	 * the poison bit so the kernel can safely use the page again.
 	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
-		movdir64b(dest + i, zero_page);
+	for (unsigned long j = 0; j < npages; j++) {
+		void *dest = page_to_virt(folio_page(folio, start_idx + j));
+
+		for (unsigned long i = 0; i < PAGE_SIZE; i += 64)
+			movdir64b(dest + i, zero_page);
+	}
 	/*
 	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
 	 * from seeing potentially poisoned cache.
@@ -296,6 +299,13 @@ static void tdx_clear_page(struct page *page)
 	__mb();
 }
 
+static inline void tdx_clear_page(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	tdx_clear_folio(folio, folio_page_idx(folio, page), 1);
+}
+
 static void tdx_no_vcpus_enter_start(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1736,7 +1746,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return -EIO;
 	}
-	tdx_clear_page(page);
+	tdx_clear_folio(folio, folio_page_idx(folio, page), KVM_PAGES_PER_HPAGE(level));
 	tdx_pamt_put(page, level);
 	tdx_unpin(kvm, page);
 	return 0;
-- 
2.43.2


