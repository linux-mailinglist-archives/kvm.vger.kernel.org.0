Return-Path: <kvm+bounces-44039-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C549A99F51
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:09:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40B4C444AD0
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:09:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2166E7E0E4;
	Thu, 24 Apr 2025 03:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="bw1l5zGo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2ED81A5BB6;
	Thu, 24 Apr 2025 03:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464093; cv=none; b=T5KpDBylJWMBov7/ZHVdXe7zqMMyaTMYG/7izVpUKxgkKQvWO7QEfPU7+NPEODFu96OzQZK8XphVYN0AD9pwLFU56eWdg2YRuiiuzex++MBJ8zZlURHb3K4aQCe/hWtu/oG6q7k1kr2wPbTX/drMTkiw+9cCzkq9IdghJ5+6lR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464093; c=relaxed/simple;
	bh=IvoZ7f1lzU/Zua0NPlbyv12w9naPuRAYg+vQY+s9wIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kas97bEa15DEh5jkVyUUT2RoWflBF49YLrw77lIFmcaLfiK/XyvRmt+7KZ4iQHEF2xDnM7FRiZTUF7IZp3AP8ZmmdpcT4iwXQv1sv0ljJMoVxfVg5ZznFAKDUCsiu/zifbOO12rWKqlSJYuo/0PERMXBF9GknAmzcrMfeSKzBp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=bw1l5zGo; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464091; x=1777000091;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=IvoZ7f1lzU/Zua0NPlbyv12w9naPuRAYg+vQY+s9wIk=;
  b=bw1l5zGoKton1GY69C+qwLFjgkJq5UylOtlV04+L/s/0RKBoD5e278a6
   uRUi8YC/pXCEzGeMxfs8gIRIZAQj5iW7h2eKDxvGoznQsS1Xmlqea3w4h
   +irj99S/ntXjDRcBs0ys0np6yVxG2pHuLWmdxK7/e9OrDytYYvYMYlXMb
   A0KyyWSKh19RiCWHqhAoTzoVOnkf232Bm3VwpY1dom8mLp7hzPjEQpbTf
   ybgZFLS0HF83BUqG5BfD+4aqyUoEiPDAjO8uHSmDrnlgQQu6tHv2oRDpU
   l23Lvw8t6dOdcxzlvp5SsYF3xNrmr3XP9cD4ge9vF6PukmQYpRvaDcKeO
   A==;
X-CSE-ConnectionGUID: GR/6bcmvT9aCDnP524STFg==
X-CSE-MsgGUID: LcD20epGT3qmXhuDAz5f7g==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47255797"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47255797"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:08:11 -0700
X-CSE-ConnectionGUID: VrgZupqPR/StjIsi8CHuEA==
X-CSE-MsgGUID: si6CPoGPRR++tVQytCzVxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132222609"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:08:05 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
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
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 09/21] KVM: TDX: Enable 2MB mapping size after TD is RUNNABLE
Date: Thu, 24 Apr 2025 11:06:18 +0800
Message-ID: <20250424030618.352-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Allow TDX's .private_max_mapping_level hook to return 2MB after the TD is
RUNNABLE, enabling KVM to map TDX private pages at the 2MB level. Remove
TODOs and adjust KVM_BUG_ON()s accordingly.

Note: Instead of placing this patch at the tail of the series, it's
positioned here to show the code changes for basic mapping of private huge
pages (i.e., transitioning from non-present to present).

However, since this patch also allows KVM to trigger the merging of small
entries into a huge leaf entry or the splitting of a huge leaf entry into
small entries, errors are expected if any of these operations are triggered
due to the current lack of splitting/merging support.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index e23dce59fc72..6b3a8f3e6c9c 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1561,10 +1561,6 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	struct page *page = pfn_to_page(pfn);
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
-
 	/*
 	 * Because guest_memfd doesn't support page migration with
 	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
@@ -1612,8 +1608,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+	if (KVM_BUG_ON(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
@@ -1714,8 +1709,8 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
 	u64 err, entry, level_state;
 
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
+	/* Before TD runnable, large page is not supported */
+	WARN_ON_ONCE(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K);
 
 	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 
@@ -1817,6 +1812,9 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct page *page = pfn_to_page(pfn);
 	int ret;
 
+	WARN_ON_ONCE(folio_page_idx(page_folio(page), page) + KVM_PAGES_PER_HPAGE(level) >
+		     folio_nr_pages(page_folio(page)));
+
 	/*
 	 * HKID is released after all private pages have been removed, and set
 	 * before any might be populated. Warn if zapping is attempted when
@@ -3265,7 +3263,7 @@ int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
 		return PG_LEVEL_4K;
 
-	return PG_LEVEL_4K;
+	return PG_LEVEL_2M;
 }
 
 static int tdx_online_cpu(unsigned int cpu)
-- 
2.43.2


