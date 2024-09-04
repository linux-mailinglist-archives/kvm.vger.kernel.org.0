Return-Path: <kvm+bounces-25827-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1B93B96AF1E
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 05:20:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3EA631C23E78
	for <lists+kvm@lfdr.de>; Wed,  4 Sep 2024 03:20:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 946D91448C5;
	Wed,  4 Sep 2024 03:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TeFJRspa"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D2D13C690;
	Wed,  4 Sep 2024 03:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725419686; cv=none; b=ZnqwI/bwv+Yswny9QP/Pz469EXpiJ70pEi+KrLT6j29HK8ygTIGLr78pHptT2/Z3t7bRe8ow7VYZ9UgcOHtUWKHxZdiXhiowwHh+0y0CFObzZJUHGloxiNTG9+SHO9zVmT0FV31CKbAQjYNv0lphOYIHhZkLhbyKpwU0Cyn4dxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725419686; c=relaxed/simple;
	bh=vzF4jMsbdAIEM7uSpTc8OouvMuhn8wUK+hjt+NiEOh8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=nAmlW3/ZVe1GXGX6TNMfNaYydAMdc6j+2r1NIwVnmvnr0lL0oUBTPb9iObgkay4gB+KtNax9HXN/mFaoXJA/4pOh/aWzySqgE8d0wFW8XDz16iu+1zshZE4ZciSJjVCaJSipfTB0bBHjp7BDzcHUdGPrR6DvwGOFGm7qU0V9090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TeFJRspa; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725419684; x=1756955684;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vzF4jMsbdAIEM7uSpTc8OouvMuhn8wUK+hjt+NiEOh8=;
  b=TeFJRspau6/wIQ2ANrsDRsAwjldhQsBeu+MWh2iR9ZjAQcjo7SUo4WW0
   mFekPkK3BxcS1zwbSauXMRqcwItypJIanhg6LXwk35NkSkLq9XaTW3ihj
   Tqqe+MpOXS4UZ3rOkXYmViow265zoNvPzGm1vZ5ZxZj8bGdoD6zSnWIdJ
   J5sNp8sntlq0ZDZaXD8PjOi2Hj6VDS0eENHg06bzeESjY9OkKQyOot7bo
   PyTTvdDygm5j196AXfUTWqsFf83FnWtbF1aat8O2MsDYr08UcrUD6zRJB
   8tbDujWSzgPgIipxCUDmR1ww/wLQVR+KANemjKu94ZGfRrfm/fNa5liBI
   A==;
X-CSE-ConnectionGUID: KnxubGoJTHmLUcYw/erxEQ==
X-CSE-MsgGUID: 2KcFK8EpQgGjub3maeC+3Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11184"; a="23564710"
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="23564710"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:10 -0700
X-CSE-ConnectionGUID: 6deKK6LdQDCausr+tjEUfg==
X-CSE-MsgGUID: vQVCmvHSQWGkmWYvSDlc9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,200,1719903600"; 
   d="scan'208";a="65106350"
Received: from dgramcko-desk.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.221.153])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 20:08:10 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	isaku.yamahata@gmail.com,
	yan.y.zhao@intel.com,
	nik.borisov@suse.com,
	rick.p.edgecombe@intel.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] KVM: TDX: Premap initial guest memory
Date: Tue,  3 Sep 2024 20:07:46 -0700
Message-Id: <20240904030751.117579-17-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
References: <20240904030751.117579-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Update TDX's hook of set_external_spte() to record pre-mapping cnt instead
of doing nothing and returning when TD is not finalized.

TDX uses ioctl KVM_TDX_INIT_MEM_REGION to initialize its initial guest
memory. This ioctl calls kvm_gmem_populate() to get guest pages and in
tdx_gmem_post_populate(), it will
(1) Map page table pages into KVM mirror page table and private EPT.
(2) Map guest pages into KVM mirror page table. In the propagation hook,
    just record pre-mapping cnt without mapping the guest page into private
    EPT.
(3) Map guest pages into private EPT and decrease pre-mapping cnt.

Do not map guest pages into private EPT directly in step (2), because TDX
requires TDH.MEM.PAGE.ADD() to add a guest page before TD is finalized,
which copies page content from a source page from user to target guest page
to be added. However, source page is not available via common interface
kvm_tdp_map_page() in step (2).

Therefore, just pre-map the guest page into KVM mirror page table and
record the pre-mapping cnt in TDX's propagation hook. The pre-mapping cnt
would be decreased in ioctl KVM_TDX_INIT_MEM_REGION when the guest page is
mapped into private EPT.

Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
TDX MMU part 2 v1:
 - Update the code comment and patch log according to latest gmem update.
   https://lore.kernel.org/kvm/CABgObfa=a3cKcKJHQRrCs-3Ty8ppSRou=dhi6Q+KdZnom0Zegw@mail.gmail.com/
 - Rename tdx_mem_page_add() to tdx_mem_page_record_premap_cnt() to avoid
   confusion.
 - Change the patch title to "KVM: TDX: Premap initial guest memory".
 - Rename KVM_MEMORY_MAPPING => KVM_MAP_MEMORY (Sean)
 - Drop issueing TDH.MEM.PAGE.ADD() on KVM_MAP_MEMORY(), defer it to
   KVM_TDX_INIT_MEM_REGION. (Sean)
 - Added nr_premapped to track the number of premapped pages
 - Drop tdx_post_mmu_map_page().

v19:
 - Switched to use KVM_MEMORY_MAPPING
 - Dropped measurement extension
 - updated commit message. private_page_add() => set_private_spte()
---
 arch/x86/kvm/vmx/tdx.c | 40 +++++++++++++++++++++++++++++++++-------
 arch/x86/kvm/vmx/tdx.h |  2 +-
 2 files changed, 34 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 59b627b45475..435112562954 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -488,6 +488,34 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+/*
+ * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to get guest pages and
+ * tdx_gmem_post_populate() to premap page table pages into private EPT.
+ * Mapping guest pages into private EPT before TD is finalized should use a
+ * seamcall TDH.MEM.PAGE.ADD(), which copies page content from a source page
+ * from user to target guest pages to be added. This source page is not
+ * available via common interface kvm_tdp_map_page(). So, currently,
+ * kvm_tdp_map_page() only premaps guest pages into KVM mirrored root.
+ * A counter nr_premapped is increased here to record status. The counter will
+ * be decreased after TDH.MEM.PAGE.ADD() is called after the kvm_tdp_map_page()
+ * in tdx_gmem_post_populate().
+ */
+static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
+					  enum pg_level level, kvm_pfn_t pfn)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+
+	/* Returning error here to let TDP MMU bail out early. */
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm)) {
+		tdx_unpin(kvm, pfn);
+		return -EINVAL;
+	}
+
+	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
+	atomic64_inc(&kvm_tdx->nr_premapped);
+	return 0;
+}
+
 int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, kvm_pfn_t pfn)
 {
@@ -510,11 +538,7 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(is_td_finalized(kvm_tdx)))
 		return tdx_mem_page_aug(kvm, gfn, level, pfn);
 
-	/*
-	 * TODO: KVM_MAP_MEMORY support to populate before finalize comes
-	 * here for the initial memory.
-	 */
-	return 0;
+	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -546,10 +570,12 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (unlikely(!is_td_finalized(kvm_tdx) &&
 		     err == (TDX_EPT_WALK_FAILED | TDX_OPERAND_ID_RCX))) {
 		/*
-		 * This page was mapped with KVM_MAP_MEMORY, but
-		 * KVM_TDX_INIT_MEM_REGION is not issued yet.
+		 * Page is mapped by KVM_TDX_INIT_MEM_REGION, but hasn't called
+		 * tdh_mem_page_add().
 		 */
 		if (!is_last_spte(entry, level) || !(entry & VMX_EPT_RWX_MASK)) {
+			WARN_ON_ONCE(!atomic64_read(&kvm_tdx->nr_premapped));
+			atomic64_dec(&kvm_tdx->nr_premapped);
 			tdx_unpin(kvm, pfn);
 			return 0;
 		}
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 66540c57ed61..25a4aaede2ba 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -26,7 +26,7 @@ struct kvm_tdx {
 
 	u64 tsc_offset;
 
-	/* For KVM_MAP_MEMORY and KVM_TDX_INIT_MEM_REGION. */
+	/* For KVM_TDX_INIT_MEM_REGION. */
 	atomic64_t nr_premapped;
 
 	struct kvm_cpuid2 *cpuid;
-- 
2.34.1


