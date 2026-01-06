Return-Path: <kvm+bounces-67109-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDAECF7C01
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:20:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8F2A4301E14A
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:20:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DFDA131B101;
	Tue,  6 Jan 2026 10:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="GEzcZ4Ql"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9E230FC17;
	Tue,  6 Jan 2026 10:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694832; cv=none; b=eT2sih6rKS9YFZPGczM7Pmh3LB3479t1k/3+pN4uRQNTlprcewqNh+6Eig7qnV5SMM9mjOgeXeSGJQ74yQbIHiF3nylGCFsDUPwRAfZok18CUfR164+CdE1yP/hRE6JYIDzMeRlmvv8NhAwiVBKRM/w7M0x1ZO/qITaQjdaTEtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694832; c=relaxed/simple;
	bh=SJnwT2+Fn1GNcltb62bdu3hbUsMYH6Vi3i6Pskn9TCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jmvmw9/l3X/NbdPehHdd8N4CzFnDC5G6CsRxmwU/zsHkwM9QntyqthvPa0CA1kO8meHJFosrWfOKeejxZtUQdq49Ue5E01250gH0jgrnYGRWgF7Tqm+YDiHhEsZfW5TWO7TOwz/tn2uKSZCm9/3835lblXyByznHaNhlkim0fJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=GEzcZ4Ql; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694830; x=1799230830;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SJnwT2+Fn1GNcltb62bdu3hbUsMYH6Vi3i6Pskn9TCI=;
  b=GEzcZ4QlMk85uAVeZD93nH+XkTfoTt1FTijLgFkmwybz6cW5q46PhoFA
   8Gtz05atNG2ERe6p34LoULiB/XzyVPoGYVBUi2AQfvh+6NOaOaxg0ot1z
   6gkHCHPefQ5s3m9w1g4lUG+ZjeCXfJiug+L74iWQqxysPi+tsNkRmDNAi
   lZn2QQ6CJJgH814Xb7LFzvCTyPv5oPrSUIjewvPFcJP0gmJvcXUucKR2/
   f7qCtihL81LJ5QqLJ/Zz/qMLP9+3hvwGpsOXTwqOrSJ2AuxKLHcJUBX09
   HRu+MApiitJqeP9i1RYrPLe6BLlynNBoy0ERIgMveMBTxnI744p2IQEFR
   w==;
X-CSE-ConnectionGUID: c9ygREiORqKRwWG3hK8/ig==
X-CSE-MsgGUID: 1c53AvZSRNa5lrKwPlZxlw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68966493"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68966493"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:20:29 -0800
X-CSE-ConnectionGUID: OPdlHDoqSu24Yb+daN2jWA==
X-CSE-MsgGUID: AbZ71cBdRhSYdwXVBD8ufQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207175059"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:20:24 -0800
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
Subject: [PATCH v3 01/24] x86/tdx: Enhance tdh_mem_page_aug() to support huge pages
Date: Tue,  6 Jan 2026 18:18:26 +0800
Message-ID: <20260106101826.24870-1-yan.y.zhao@intel.com>
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

Enhance the SEAMCALL wrapper tdh_mem_page_aug() to support huge pages.

The SEAMCALL TDH_MEM_PAGE_AUG currently supports adding physical memory to
the S-EPT up to 2MB in size.

While keeping the "level" parameter in the tdh_mem_page_aug() wrapper to
allow callers to specify the physical memory size, introduce the parameters
"folio" and "start_idx" to specify the physical memory starting from the
page at "start_idx" within the "folio". The specified physical memory must
be fully contained within a single folio.

Invoke tdx_clflush_page() for each 4KB segment of the physical memory being
added. tdx_clflush_page() performs CLFLUSH operations conservatively to
prevent dirty cache lines from writing back later and corrupting TD memory.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- nth_page() --> folio_page(). (Kai, Dave)
- Rebased on top of DPAMT v4.

RFC v2:
- Refine patch log. (Rick)
- Removed the level checking. (Kirill, Chao Gao)
- Use "folio", and "start_idx" rather than "page".
- Return TDX_OPERAND_INVALID if the specified physical memory is not
  contained within a single folio.
- Use PTE_SHIFT to replace the 9 in "1 << (level * 9)" (Kirill)
- Use C99-style definition of variables inside a loop. (Nikolay Borisov)

RFC v1:
- Rebased to new tdh_mem_page_aug() with "struct page *" as param.
- Check folio, folio_page_idx.
---
 arch/x86/include/asm/tdx.h  |  3 ++-
 arch/x86/kvm/vmx/tdx.c      |  5 +++--
 arch/x86/virt/vmx/tdx/tdx.c | 13 ++++++++++---
 3 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 8c0c548f9735..f92850789193 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -235,7 +235,8 @@ u64 tdh_mng_addcx(struct tdx_td *td, struct page *tdcs_page);
 u64 tdh_mem_page_add(struct tdx_td *td, u64 gpa, struct page *page, struct page *source, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_sept_add(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page);
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2);
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct folio *folio,
+		     unsigned long start_idx, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mem_range_block(struct tdx_td *td, u64 gpa, int level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 98ff84bc83f2..2f03c51515b9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1679,12 +1679,13 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct page *page = pfn_to_page(pfn);
+	struct folio *folio = page_folio(page);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 entry, level_state;
 	u64 err;
 
-	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, page, &entry, &level_state);
-
+	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, folio,
+			       folio_page_idx(folio, page), &entry, &level_state);
 	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
 		return -EBUSY;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b0b33f606c11..41ce18619ffc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1743,16 +1743,23 @@ u64 tdh_vp_addcx(struct tdx_vp *vp, struct page *tdcx_page)
 }
 EXPORT_SYMBOL_GPL(tdh_vp_addcx);
 
-u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct page *page, u64 *ext_err1, u64 *ext_err2)
+u64 tdh_mem_page_aug(struct tdx_td *td, u64 gpa, int level, struct folio *folio,
+		     unsigned long start_idx, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
 		.rcx = gpa | level,
 		.rdx = tdx_tdr_pa(td),
-		.r8 = page_to_phys(page),
+		.r8 = page_to_phys(folio_page(folio, start_idx)),
 	};
+	unsigned long npages = 1 << (level * PTE_SHIFT);
 	u64 ret;
 
-	tdx_clflush_page(page);
+	if (start_idx + npages > folio_nr_pages(folio))
+		return TDX_OPERAND_INVALID;
+
+	for (int i = 0; i < npages; i++)
+		tdx_clflush_page(folio_page(folio, start_idx + i));
+
 	ret = seamcall_ret(TDH_MEM_PAGE_AUG, &args);
 
 	*ext_err1 = args.rcx;
-- 
2.43.2


