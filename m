Return-Path: <kvm+bounces-67113-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 47CD2CF7C3F
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 01E5A30519C3
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:22:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0F11325720;
	Tue,  6 Jan 2026 10:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dxasiABb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532E021C173;
	Tue,  6 Jan 2026 10:22:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694937; cv=none; b=uCsjXCwY5W4wThlzO+8rLqJ4ZhKhkkxpvi+iM+cdxlwYwTIacgzk5C0IlEqww+U7iyP5gX68oShWZ8jNbb7PEoxH6XmkqTGCj1LQsp4sI68MmXIHWBfW4EaGFICKoT4eCKRPJj1gQGmv1Rjy1aZ3yyRDpJ5dYwxKeCOZ3mwyCzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694937; c=relaxed/simple;
	bh=wlA5WQWsZy00SaoZfWNiyVC6pqw7wJhR3jJQHkZ5xuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8+g2UgufYyEjTzN9k8EIzcIThbe3Iq2L/mMaGOvwNv/TJDAWJOu0DgXclcnqvRLZGdSo8qIRWW6Y/CP3TqeSdAKSoOyM9fbSRWy4pKo0DrAFYcCk7AoNRnewYtXIWIRfcpJSRdCbsTDSqWLp6yFK/++EJzNNF0E+2suJx9HCC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dxasiABb; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694934; x=1799230934;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wlA5WQWsZy00SaoZfWNiyVC6pqw7wJhR3jJQHkZ5xuo=;
  b=dxasiABbr+XoG6qFcgvbrffkY8MXh7bk466PZU47esBR+PI/x0QibIRP
   ZFLSroTdatIeb9LMwugjxcRh1EKNTqhJiJ7Ff4Ys/1+Br/ewn69oJBwtw
   NI35Pj7IChaECrjjgYAu6H2BPF0vRvr+RfEoabOfVTlVDYi4jSOvz39JD
   7YWI+gWrjCxcJIlpRLGOrkHfixA/sxk8XGSLsiSjMkZ459+isnq4d2P3Q
   eJiqH+Qjc1Kl6W+6IlrW8RuhcbB8Oy8iXyczXoA+m5jQae1c62K0Jvg0X
   TasD4HEWy+fmrFCi85pKeMe9+8sGr1GX3w5DxvJkFRZ6HWtgURYCDz4Sc
   Q==;
X-CSE-ConnectionGUID: z2cvSkkCQzSf14wElncnLA==
X-CSE-MsgGUID: S/BbEwH/Q2uysRkVims8rQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68966605"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68966605"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:13 -0800
X-CSE-ConnectionGUID: 9gNpH/mdQ2OT4VERLTrVLA==
X-CSE-MsgGUID: CUOGTDXPTL2a7nhA0dGSMA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207175309"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:07 -0800
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
Subject: [PATCH v3 05/24] x86/virt/tdx: Enhance tdh_phymem_page_reclaim() to support huge pages
Date: Tue,  6 Jan 2026 18:20:09 +0800
Message-ID: <20260106102009.25006-1-yan.y.zhao@intel.com>
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

Enhance the SEAMCALL wrapper tdh_phymem_page_reclaim() to support huge
pages by introducing new parameters: "folio", "start_idx", and "npages".
These parameters specify the physical memory to be reclaimed, starting from
the page at "start_idx" within a folio and spanning "npages" contiguous
PFNs. The specified memory must be entirely contained within a
single folio. Return TDX_SW_ERROR if the size of the reclaimed memory does
not match the specified size.

On the KVM side, introduce tdx_reclaim_folio() to invoke
tdh_phymem_page_reclaim() for reclaiming huge guest private pages. The
"reset" parameter in tdx_reclaim_folio() specifies whether
tdx_quirk_reset_folio() should be subsequently invoked within
tdx_reclaim_folio().  To facilitate reclaiming of 4KB pages, keep function
tdx_reclaim_page() and make it a helper for reclaiming normal TDX control
pages, and introduce a new helper tdx_reclaim_page_noreset() for reclaiming
the TDR page.

Opportunistically, rename rcx, rdx, r8 to tdx_pt, tdx_owner, tdx_size in
tdx_reclaim_folio() to improve readability.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Rebased to Sean's cleanup series. Dropped invoking tdx_reclaim_folio()
  in tdx_sept_remove_private_spte() due to no reclaiming is required in
  that path.
  However, keep introducing tdx_reclaim_folio() as it will be needed when
  the patches of removing guest private memory after releasing HKID are
  merged.
- tdx_reclaim_page_noclear() --> tdx_reclaim_page_noreset() and invoke
  tdx_quirk_reset_folio() instead in tdx_reclaim_folio() due to rebase.
- Check mismatch between the request size and the reclaimed size, and
  return TDX_SW_ERROR only after a successful TDH_PHYMEM_PAGE_RECLAIM.
  (Binbin)

RFC v2:
- Introduce new params "folio", "start_idx" and "npages" to wrapper
  tdh_phymem_page_reclaim().
- Move the checking of return size from KVM to x86/virt and return error.
- Rename tdx_reclaim_page() to tdx_reclaim_folio().
- Add two helper functions tdx_reclaim_page() tdx_reclaim_page_noclear()
  to faciliate the reclaiming of 4KB pages.

RFC v1:
- Rebased and split patch.
---
 arch/x86/include/asm/tdx.h  |  3 ++-
 arch/x86/kvm/vmx/tdx.c      | 27 +++++++++++++++++----------
 arch/x86/virt/vmx/tdx/tdx.c | 12 ++++++++++--
 3 files changed, 29 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 669dd6d99821..abe484045132 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -261,7 +261,8 @@ u64 tdh_mng_init(struct tdx_td *td, u64 td_params, u64 *extended_err);
 u64 tdh_vp_init(struct tdx_vp *vp, u64 initial_rcx, u32 x2apicid);
 u64 tdh_vp_rd(struct tdx_vp *vp, u64 field, u64 *data);
 u64 tdh_vp_wr(struct tdx_vp *vp, u64 field, u64 data, u64 mask);
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
+u64 tdh_phymem_page_reclaim(struct folio *folio, unsigned long start_idx, unsigned long npages,
+			    u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size);
 u64 tdh_mem_track(struct tdx_td *tdr);
 u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_phymem_cache_wb(bool resume);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 5b499593edff..405afd2a56b7 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -318,33 +318,40 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 })
 
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
-static int __tdx_reclaim_page(struct page *page)
+static int tdx_reclaim_folio(struct folio *folio, unsigned long start_idx,
+			     unsigned long npages, bool reset)
 {
-	u64 err, rcx, rdx, r8;
+	u64 err, tdx_pt, tdx_owner, tdx_size;
 
-	err = tdh_phymem_page_reclaim(page, &rcx, &rdx, &r8);
+	err = tdh_phymem_page_reclaim(folio, start_idx, npages, &tdx_pt,
+				      &tdx_owner, &tdx_size);
 
 	/*
 	 * No need to check for TDX_OPERAND_BUSY; all TD pages are freed
 	 * before the HKID is released and control pages have also been
 	 * released at this point, so there is no possibility of contention.
 	 */
-	if (TDX_BUG_ON_3(err, TDH_PHYMEM_PAGE_RECLAIM, rcx, rdx, r8, NULL))
+	if (TDX_BUG_ON_3(err, TDH_PHYMEM_PAGE_RECLAIM, tdx_pt, tdx_owner, tdx_size, NULL))
 		return -EIO;
 
+	if (reset)
+		tdx_quirk_reset_folio(folio, start_idx, npages);
 	return 0;
 }
 
 static int tdx_reclaim_page(struct page *page)
 {
-	int r;
+	struct folio *folio = page_folio(page);
 
-	r = __tdx_reclaim_page(page);
-	if (!r)
-		tdx_quirk_reset_page(page);
-	return r;
+	return tdx_reclaim_folio(folio, folio_page_idx(folio, page), 1, true);
 }
 
+static int tdx_reclaim_page_noreset(struct page *page)
+{
+	struct folio *folio = page_folio(page);
+
+	return tdx_reclaim_folio(folio, folio_page_idx(folio, page), 1, false);
+}
 
 /*
  * Reclaim the TD control page(s) which are crypto-protected by TDX guest's
@@ -583,7 +590,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	if (!kvm_tdx->td.tdr_page)
 		return;
 
-	if (__tdx_reclaim_page(kvm_tdx->td.tdr_page))
+	if (tdx_reclaim_page_noreset(kvm_tdx->td.tdr_page))
 		return;
 
 	/*
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 20708f56b1a0..c12665389b67 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1993,19 +1993,27 @@ EXPORT_SYMBOL_GPL(tdh_vp_init);
  * So despite the names, they must be interpted specially as described by the spec. Return
  * them only for error reporting purposes.
  */
-u64 tdh_phymem_page_reclaim(struct page *page, u64 *tdx_pt, u64 *tdx_owner, u64 *tdx_size)
+u64 tdh_phymem_page_reclaim(struct folio *folio, unsigned long start_idx,
+			    unsigned long npages, u64 *tdx_pt, u64 *tdx_owner,
+			    u64 *tdx_size)
 {
 	struct tdx_module_args args = {
-		.rcx = page_to_phys(page),
+		.rcx = page_to_phys(folio_page(folio, start_idx)),
 	};
 	u64 ret;
 
+	if (start_idx + npages > folio_nr_pages(folio))
+		return TDX_OPERAND_INVALID;
+
 	ret = seamcall_ret(TDH_PHYMEM_PAGE_RECLAIM, &args);
 
 	*tdx_pt = args.rcx;
 	*tdx_owner = args.rdx;
 	*tdx_size = args.r8;
 
+	if (!ret && npages != (1 << (*tdx_size) * PTE_SHIFT))
+		return TDX_SW_ERROR;
+
 	return ret;
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_reclaim);
-- 
2.43.2


