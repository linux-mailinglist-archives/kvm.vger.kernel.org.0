Return-Path: <kvm+bounces-67111-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 155F6CF7C6F
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:25:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1990A30EA72E
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:21:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD74631D375;
	Tue,  6 Jan 2026 10:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ilsSavRP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 383D531B815;
	Tue,  6 Jan 2026 10:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694893; cv=none; b=PrGHwpEqhR8x9ZXsRq0aYda7/KvMEHgg6b8xRNK+UILEN6AWKOnMRmYroHxf0zontpBjc6irPpCG3oa6bq67DyVOeya0b/82eFR/LhATuewToDpa99KTjMtvu237PNVQ+sTNTt2sQ7l6rDldjN0DOeRJ8gncu5io12NM6gt5C0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694893; c=relaxed/simple;
	bh=lSTvIOoBAb312grAY0t9vB2+io+mhlIu8uMBcqc4VsE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U2nptPKAWCdpttEFQWTKUz9M9T+b+iHI1kdiUlEEhscs3LIjcYu75lYP3KwkPGfG+rn/EAlKhcBnS9CjJEZ4K7SmLLLNeMKqHgxOQYKgurXHNmmxzDz7/hKVzH0emA43kOIqi9cTWzsni1YJ87FyOgVcrisatfFwPETPtCFiCn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ilsSavRP; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694892; x=1799230892;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lSTvIOoBAb312grAY0t9vB2+io+mhlIu8uMBcqc4VsE=;
  b=ilsSavRPnw/VjsIL0NGenCy2W38LBnABWZNW23/omkeQagjdygeDJpoh
   MjxLNyV0NqYC+yssy7Et+32XilvTwT4RdbDNMsSZ9tiu9OaiRLsrMNK53
   zAfR3DK3I2VbG5P/QNu+20yK8RWoHrHhGDMk6L8eIJrpOZvAeNno/7kEb
   amK9xRdOFd5rSq2sAYChPmvNbg01H87jZ0PtfFMsadxnGBTnp45aDHnvZ
   22Sja2cxyrgcvCa0EI4B4Et4fGzlNrrnNys5LPen1NNgI1wGv2Arpk6s+
   7Hvzf8KSLYa7nNqPvCNPfrQEMobk/ggLUSMZrXoh7xdIot3rXQUGuTB0T
   w==;
X-CSE-ConnectionGUID: zv2NkZpjSHK+2zmofhYLBA==
X-CSE-MsgGUID: CPZVYXh6Q62mqjfpBrlAhQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80176769"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80176769"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:21:31 -0800
X-CSE-ConnectionGUID: pUPkMj12StKxw0NSEJ4VDA==
X-CSE-MsgGUID: E3a4nazKSUC65/TzDE2pzA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207096709"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:21:25 -0800
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
Subject: [PATCH v3 03/24] x86/tdx: Enhance tdh_phymem_page_wbinvd_hkid() to invalidate huge pages
Date: Tue,  6 Jan 2026 18:19:29 +0800
Message-ID: <20260106101929.24937-1-yan.y.zhao@intel.com>
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
v3:
- nth_page() --> folio_page(). (Kai, Dave)
- Rebased on top of Sean's cleanup series.

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
 arch/x86/kvm/vmx/tdx.c      |  5 ++++-
 arch/x86/virt/vmx/tdx/tdx.c | 19 +++++++++++++++----
 3 files changed, 21 insertions(+), 7 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d1891e099d42..7f72fd07f4e5 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -264,8 +264,8 @@ u64 tdh_mem_track(struct tdx_td *tdr);
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
index 2f03c51515b9..b369f90dbafa 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1857,6 +1857,7 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(spte_to_pfn(mirror_spte));
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct folio *folio = page_folio(page);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
@@ -1895,7 +1896,9 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_REMOVE, entry, level_state, kvm))
 		return;
 
-	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, page);
+	err = tdh_phymem_page_wbinvd_hkid((u16)kvm_tdx->hkid, folio,
+					  folio_page_idx(folio, page),
+					  KVM_PAGES_PER_HPAGE(level));
 	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c3f4457816c8..b57e00c71384 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2046,13 +2046,24 @@ u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_tdr);
 
-u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
+u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct folio *folio,
+				unsigned long start_idx, unsigned long npages)
 {
-	struct tdx_module_args args = {};
+	u64 err;
 
-	args.rcx = mk_keyed_paddr(hkid, page);
+	if (start_idx + npages > folio_nr_pages(folio))
+		return TDX_OPERAND_INVALID;
 
-	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+	for (unsigned long i = 0; i < npages; i++) {
+		struct page *p = folio_page(folio, start_idx + i);
+		struct tdx_module_args args = {};
+
+		args.rcx = mk_keyed_paddr(hkid, p);
+		err = seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
+		if (err)
+			break;
+	}
+	return err;
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
 
-- 
2.43.2


