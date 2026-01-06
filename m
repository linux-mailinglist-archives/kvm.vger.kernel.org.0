Return-Path: <kvm+bounces-67112-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id E9E1FCF7C36
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:22:32 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 601033048BB1
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:22:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C84325711;
	Tue,  6 Jan 2026 10:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mYZb2lrb"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BD0B30FC2C;
	Tue,  6 Jan 2026 10:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694921; cv=none; b=tfw52aTdNOvwd2fNDrhSZo3f2AVz1bruIA1Erkmtr4UjyWdAWRs0+pt6wIv83L+3rRNTHom5RAg5t7+TN467QFbQJj64y2U+PGs9lwCdJIRJvSKq/M4j3850h2w1wLlu6DAAnxG4gHlDtBWWP4NVuBpIH6Tf3GGu7iFZmYiZz+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694921; c=relaxed/simple;
	bh=TD3vbmKUAbYlJ5uvNxw6IXr6XmjZjncu6ecmm3SuGdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QRf0A3ubu/TStjlQJhUoc6sYLvvzCg4EGMU37thItGfJyG47hQPfyjaoFaA/eWQ3BLPaWXsVytd7DYJATu/z/DGSVj/BPHrZZpHuLK+2kceb9DGBAdn3f8ryyMuYAatvqjlGmOzouLj+R3n3YpvDk3l4yswRW8DWxS4M7catG+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mYZb2lrb; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694919; x=1799230919;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TD3vbmKUAbYlJ5uvNxw6IXr6XmjZjncu6ecmm3SuGdM=;
  b=mYZb2lrbOEjCEyOLodcy4WOPkfw+co1dNe0PpCdV+znfWuab8GURz7cQ
   JMW8FALA6c0ZklPhHcCvoKzLGyRZrGBr8RbsoMRFitPHEcSc0EBba/2Ip
   KaZ1m/pTMDJJ3BjY5Q5UM3c/x4lyoPJ5vj6sEip+KtBDorLrvqJUJtg28
   ePeNdN8NjJ9t+u2Rr5/PjmflkyXqmmwuq98BUyyvtX3bmLM6FHkhqPBuS
   nDFwc9OivP/aofmdU1FbbYfUzZguV2o312jvkWA+Q9ReOtvG2rwUeJqiP
   bM8RXHPyf9XQ7EOnNIjJTcJ7Vk13SD+55h485rwkm1ioG8SbEzYGsPLMZ
   Q==;
X-CSE-ConnectionGUID: 5OXZJOaSTemW1AkQtAD23A==
X-CSE-MsgGUID: 4vx1exgiRRS7yXVEC0SNfw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80176783"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80176783"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:21:57 -0800
X-CSE-ConnectionGUID: KY4/a46VQ/O7NKpDj/vKpA==
X-CSE-MsgGUID: X/4wZK5/TYay5eNqVT01qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207096754"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:21:51 -0800
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
Subject: [PATCH v3 04/24] x86/tdx: Introduce tdx_quirk_reset_folio() to reset private huge pages
Date: Tue,  6 Jan 2026 18:19:54 +0800
Message-ID: <20260106101955.24967-1-yan.y.zhao@intel.com>
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

After removing or reclaiming a guest private page or a control page from a
TD, zero the physical page using movdir64b() to enable the kernel to reuse
the pages. This is needed for systems with the X86_BUG_TDX_PW_MCE erratum.

Introduce the function tdx_quirk_reset_folio() to invoke
tdx_quirk_reset_paddr() to convert pages in a huge folio from private back
to normal. The pages start from the page at "start_idx" within a "folio",
spanning "npages" contiguous PFNs.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v3:
- Rebased to Sean's cleanup series.
- tdx_clear_folio() --> tdx_quirk_reset_folio().

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
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      |  3 ++-
 arch/x86/virt/vmx/tdx/tdx.c | 11 +++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7f72fd07f4e5..669dd6d99821 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -147,6 +147,8 @@ static inline bool tdx_supports_demote_nointerrupt(const struct tdx_sys_info *sy
 }
 
 void tdx_quirk_reset_page(struct page *page);
+void tdx_quirk_reset_folio(struct folio *folio, unsigned long start_idx,
+			   unsigned long npages);
 
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b369f90dbafa..5b499593edff 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1902,7 +1902,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (TDX_BUG_ON(err, TDH_PHYMEM_PAGE_WBINVD, kvm))
 		return;
 
-	tdx_quirk_reset_page(page);
+	tdx_quirk_reset_folio(folio, folio_page_idx(folio, page),
+			      KVM_PAGES_PER_HPAGE(level));
 	tdx_pamt_put(page);
 }
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index b57e00c71384..20708f56b1a0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -800,6 +800,17 @@ static void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 	mb();
 }
 
+void tdx_quirk_reset_folio(struct folio *folio, unsigned long start_idx,
+			   unsigned long npages)
+{
+	if (WARN_ON_ONCE(start_idx + npages > folio_nr_pages(folio)))
+		return;
+
+	tdx_quirk_reset_paddr(page_to_phys(folio_page(folio, start_idx)),
+			      npages << PAGE_SHIFT);
+}
+EXPORT_SYMBOL_GPL(tdx_quirk_reset_folio);
+
 void tdx_quirk_reset_page(struct page *page)
 {
 	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
-- 
2.43.2


