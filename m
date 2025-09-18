Return-Path: <kvm+bounces-58067-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AED34B875EC
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:26:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3DAE31C83B61
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D8B31FEF2;
	Thu, 18 Sep 2025 23:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eG2uBSmr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E1031A7F6;
	Thu, 18 Sep 2025 23:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237791; cv=none; b=sgZWg4yW94j2BQn8fxh1cCJtjcFbsDQsJw2eOlmpqrSmuSr03FbqjyQonbscniBfw9sWrg5dFkzuER5HEe3jmTVBa22+67lOlvtwL6ARkMiO4uRNLvZPq1tChOQxVV20XUaCxeYBaKEL2nlftNro7PGOQCddP1K8se8T6eEZxCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237791; c=relaxed/simple;
	bh=8Yt1i1dR3oMbSMiPFMyoXISnbfUwDrssxYf/LLeI4OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o/8RQvXaIu1CF+u65++HGZ3lvjfoTaq21+mAdk1vXdwyCPSKyFCpHWbRBiJSHKC6y3ag/5dgFqr7ZZr36w+jKAphoBPkSq8SL6C+1in4rDkrtybxbG0l0c98jVpXTa4NHUeJbLoS10qsUGtd0gSD/zkXr91H52mJ441l2ZUXWlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eG2uBSmr; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237790; x=1789773790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Yt1i1dR3oMbSMiPFMyoXISnbfUwDrssxYf/LLeI4OM=;
  b=eG2uBSmrpVoW1KBg2MPjUbE6x5x965NTXuS0nhQD0JTOQK6aYJnICFzg
   Ll9OCk+pOkNMWu2WR8wxSywxGVd1d0xSJkz3vvCSu2f6qUkEDyyg1s5tc
   p8tIhOM/STuOO886vZ8Lm3304fpBuEF2zOhX01jal3ZXFhNPBMXmh9KTb
   yFkOwnEzb85qqwLdaDvZffszo/f+HArmfyGAkNvNx3LOb9/vqoKvQpU8h
   mPu9qICPTr0sPo2UDNUFCjQUuTghXaW4nRyKWOr+MafuuMarru1N0X0eB
   uReRUiHq1ZILCSHl6KoyN7nD9YKdOmPvn5mkC20XhpXEuq4tv4jEos2bk
   A==;
X-CSE-ConnectionGUID: nnYgelaSQ0iZ1CnyfcTlcg==
X-CSE-MsgGUID: 162HeudgTS+Dze4Y8vE+Tg==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735457"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735457"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:06 -0700
X-CSE-ConnectionGUID: eb60TL+RTyG5gDfICxgHMg==
X-CSE-MsgGUID: TnABuP7yTzuHXuYbO2OeQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491458"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:05 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kas@kernel.org,
	bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	vannapurve@google.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 13/16] KVM: TDX: Handle PAMT allocation in fault path
Date: Thu, 18 Sep 2025 16:22:21 -0700
Message-ID: <20250918232224.2202592-14-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Install PAMT pages for TDX call backs called during the fault path.

There are two distinct cases when the kernel needs to allocate PAMT memory
in the fault path: for SEPT page tables in tdx_sept_link_private_spt() and
for leaf pages in tdx_sept_set_private_spte().

These code paths run in atomic context. Previous changes have made the
fault path top up the per-VCPU pool for memory allocations. Use it to do
tdx_pamt_get/put() for the fault path operations.

In the generic MMU these ops are inside functions that don’t always
operate from the vCPU contexts (for example zap paths), which means they
don’t have a struct kvm_vcpu handy. But for TDX they are always in a vCPU
context. Since the pool of pre-allocated pages is on the vCPU, use
kvm_get_running_vcpu() to get the vCPU. In case a new path appears where
this is not the  case, leave some KVM_BUG_ON()’s.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Use new pre-allocation method
 - Updated log
 - Some extra safety around kvm_get_running_vcpu()
---
 arch/x86/kvm/vmx/tdx.c | 45 +++++++++++++++++++++++++++++++++++++-----
 1 file changed, 40 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b274d350165c..a55a95558557 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -836,6 +836,7 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(vcpu->kvm);
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	struct page *page;
 	int i;
 
 	/*
@@ -862,6 +863,9 @@ void tdx_vcpu_free(struct kvm_vcpu *vcpu)
 		tdx->vp.tdvpr_page = 0;
 	}
 
+	while ((page = get_tdx_prealloc_page(&tdx->prealloc)))
+		__free_page(page);
+
 	tdx->state = VCPU_TD_STATE_UNINITIALIZED;
 }
 
@@ -1665,13 +1669,23 @@ static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
 static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, kvm_pfn_t pfn)
 {
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
 	struct page *page = pfn_to_page(pfn);
+	int ret;
+
+	if (KVM_BUG_ON(!vcpu, kvm))
+		return -EINVAL;
 
 	/* TODO: handle large pages. */
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
+	ret = tdx_pamt_get(page, &tdx->prealloc);
+	if (ret)
+		return ret;
+
 	/*
 	 * Because guest_memfd doesn't support page migration with
 	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
@@ -1687,10 +1701,16 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	 * barrier in tdx_td_finalize().
 	 */
 	smp_rmb();
-	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
-		return tdx_mem_page_aug(kvm, gfn, level, page);
 
-	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
+		ret = tdx_mem_page_aug(kvm, gfn, level, page);
+	else
+		ret = tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+
+	if (ret)
+		tdx_pamt_put(page);
+
+	return ret;
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1747,17 +1767,30 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
-	gpa_t gpa = gfn_to_gpa(gfn);
+	struct kvm_vcpu *vcpu = kvm_get_running_vcpu();
 	struct page *page = virt_to_page(private_spt);
+	struct vcpu_tdx *tdx = to_tdx(vcpu);
+	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
+	int ret;
+
+	if (KVM_BUG_ON(!vcpu, kvm))
+		return -EINVAL;
+
+	ret = tdx_pamt_get(page, &tdx->prealloc);
+	if (ret)
+		return ret;
 
 	err = tdh_mem_sept_add(&to_kvm_tdx(kvm)->td, gpa, tdx_level, page, &entry,
 			       &level_state);
-	if (unlikely(IS_TDX_OPERAND_BUSY(err)))
+	if (unlikely(IS_TDX_OPERAND_BUSY(err))) {
+		tdx_pamt_put(page);
 		return -EBUSY;
+	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_SEPT_ADD, err, entry, level_state);
+		tdx_pamt_put(page);
 		return -EIO;
 	}
 
@@ -2966,6 +2999,8 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	int ret, i;
 	u64 err;
 
+	INIT_LIST_HEAD(&tdx->prealloc.page_list);
+
 	page = tdx_alloc_page();
 	if (!page)
 		return -ENOMEM;
-- 
2.51.0


