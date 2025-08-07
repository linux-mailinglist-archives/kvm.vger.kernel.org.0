Return-Path: <kvm+bounces-54228-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id D9A98B1D503
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:42:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 5EF604E2391
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:42:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E8CFF25D8F0;
	Thu,  7 Aug 2025 09:42:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="SAjIkUg7"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75CCA25C81E;
	Thu,  7 Aug 2025 09:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559763; cv=none; b=YswgWzAL5mzcY8ARXx0Vk0AoMoDk4duQD/VATw2RLmtwdfAIb1W9HGtAdnvQ9UEAa9SaAm8ojb1+HdN1DUM5QcGWwm50PMZ+pz0QZnYx0y0KuP8NyvT2XYHvO2kdeWX4paboUNAcBAWt2VpnJevkbj7nE5H7/yP/HfnLWpXCvc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559763; c=relaxed/simple;
	bh=t+MrK6mfE0QPRfAE2r5NfyC2QMdtrKMhhbwhHH5xoGQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceDtvkI8aln4b2KJdjjpTfewZ7yPHSXoBRoUCiSeZrIC1xiDD0liVNNjEoFPyUJH5zeNw2n9Jl7vzVFxCxpgm5raoXNQt6B5yFOx/Nw1WrLOSSvl/IHSR7l5lsO9UyMLaTfguqNJMArjslz6AJw8FjgmoknehXVMe5wkmJkeSWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=SAjIkUg7; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559758; x=1786095758;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=t+MrK6mfE0QPRfAE2r5NfyC2QMdtrKMhhbwhHH5xoGQ=;
  b=SAjIkUg79q5FEZm09Ovu8bhl2sr/fCGdVJW+TGVku4QBwl/zji0S1unx
   OplWdlKfucOz1JcgXZ9ZvfXVv2JStFZXBZ+pvpqr0emBqVqvCoWFW9ABt
   xJ+Lvr7Hx12VC+THN/jWwyijKSiZjFki7wvSafZJ+DyLYGzc15Zj1DQ6l
   1Knwtshn4ot3dhJS+Rxg9nAMsVGtr4OeNJ4TVJ4tWzoT+NthRfRw7E3J1
   hQQd/3M4UI8SiXtuq5tNls/dIdYaJtw5KNaFr4vDtZFoQlPIm8Q3X/lbQ
   0k8D8g7sOlTSTQMvrwCfJMgacfB0cX6GdxmXUhpHfHwNILIDul+VzJ8wJ
   A==;
X-CSE-ConnectionGUID: UkOR/edGSV6JdPgYT/bFdw==
X-CSE-MsgGUID: /t7oQ6pnQ6iDCL9wOS3xzw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68265919"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68265919"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:38 -0700
X-CSE-ConnectionGUID: qinrAFE6S8ekD5R16y/vSw==
X-CSE-MsgGUID: aLeTdWKpTvmsSGyyLkjWzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="196006801"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:30 -0700
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
Subject: [RFC PATCH v2 03/23] x86/tdx: Enhance tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Date: Thu,  7 Aug 2025 17:42:02 +0800
Message-ID: <20250807094202.4481-1-yan.y.zhao@intel.com>
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

After removing a TD's private page, the TDX module does not write back and
invalidate cache lines associated with the page and its keyID (i.e., the
TD's guest keyID). The SEAMCALL wrapper tdh_phymem_page_wbinvd_hkid()
enables the caller to provide the TD's guest keyID and physical memory
address to invoke the SEAMCALL TDH_PHYMEM_PAGE_WBINVD to perform cache line
invalidation.

Enhance the SEAMCALL wrapper tdh_phymem_page_wbinvd_hkid() to support cache
line invalidation for huge pages by introducing the parameters "folio",
"start_idx", and "npages". These parameters specify the physical memory
starting from the page at "start_idx" within a "folio" and spanning
"npages" contiguous PFNs. Return TDX_OPERAND_INVALID if the specified
memory is not entirely contained within a single folio.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Enhance tdh_phymem_page_wbinvd_hkid() to invalidate multiple pages
  directly, rather than looping within KVM, following Dave's suggestion:
  "Don't wrap the wrappers." (Rick).

RFC v1:
- Split patch
- Aded a helper tdx_wbinvd_page() in TDX, which accepts param
  "struct page *".
---
 arch/x86/include/asm/tdx.h  |  4 ++--
 arch/x86/kvm/vmx/tdx.c      |  6 ++++--
 arch/x86/virt/vmx/tdx/tdx.c | 17 ++++++++++++++---
 3 files changed, 20 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d2cf48e273d5..a125bb20a28a 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -194,8 +194,8 @@ u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
-
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
+				unsigned long start_idx, unsigned long npages);
 void tdx_meminfo(struct seq_file *m);
 #else
 static inline void tdx_init(void) { }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 0a2b183899d8..8eaf8431c5f1 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1694,6 +1694,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct folio *folio = page_folio(page);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
@@ -1728,8 +1729,9 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
-
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, folio,
+					  folio_page_idx(folio, page),
+					  KVM_PAGES_PER_HPAGE(level));
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return -EIO;
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index d941f083f741..64219c659844 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2030,13 +2030,24 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
 
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
+				unsigned long start_idx, unsigned long npages)
 {
+	struct page *start = folio_page(folio, start_idx);
 	struct tdx_module_args args = {};
+	u64 err;
+
+	if (start_idx + npages > folio_nr_pages(folio))
+		return TDX_OPERAND_INVALID;
 
-	args.rcx = mk_keyed_paddr(hkid, page);
+	for (unsigned long i = 0; i < npages; i++) {
+		args.rcx = mk_keyed_paddr(hkid, nth_page(start, i));
 
-	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+		err = seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+		if (err)
+			break;
+	}
+	return err;
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
 
-- 
2.43.2


