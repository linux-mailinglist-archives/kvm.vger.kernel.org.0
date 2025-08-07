Return-Path: <kvm+bounces-54231-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 640D5B1D509
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:43:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B3F453AE900
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:43:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3AFE262FD0;
	Thu,  7 Aug 2025 09:43:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ese1OXRQ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61CA84431;
	Thu,  7 Aug 2025 09:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559800; cv=none; b=jSfqg3MxJD/UeuC23u8K+mnkCwPlTTGHTPm/uonBQxOgIkomPna3U+GQV1V+Htq0fqeSsk83lGejBRAXSLyxwQ+gzbdBaPWhTQbeostt2a3JVNYSIYBAPqWWgk0YQ2qiFOTrU0Kua6Ep/wAoqJAmMS+SmZYeNT3Zcj23bXjUDkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559800; c=relaxed/simple;
	bh=bsX6OyxOJY8p6MLgnbpL2Z3yYBFY4ROlLTzLA4z/2+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrOpOKBfOgGyOlF+ksuTIV4PKFlnvf6wMp8wLTyg8ZwxRgMLaizLMxHcQi+AKdvOqMIX69N/YrZtJcK4U0GcFON4gcr3qjE7FJpvJ5MpFW96R3g61Gio570Ed89L06e20SfExmSSEJEc1dKvkZgaFbkG3vAwRgtRvvyry3+H1rI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Ese1OXRQ; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559798; x=1786095798;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bsX6OyxOJY8p6MLgnbpL2Z3yYBFY4ROlLTzLA4z/2+0=;
  b=Ese1OXRQ8PWraJ738Zz5+3YI5FTkmIoVnIe6cF54tQRAwIEgnKX7MQjm
   09DQ75Sb0KdkeLDftlB92P7wh4hzp0OaKUQ+RhPzsYZQPigPQ2YrNPf0k
   v3fX566mqFf3tYaTTrmolvsXXWu9/Je9C3xHIW2YOoQB49Hn4Pym0hkht
   JTgJWq185n4PxEW8LhBvaSJOIt2Hgc/rqJSpZ9ICELuaSmV4tNyAu5Uqo
   bE6iuRDH5gOrgEmHc4QUxZitO1TmkCZjaJZiQtDhlUpX5EeUNl/emxySQ
   IqoXoesi7JF4sBlqL5MRA0UfyyGZutD03hqVds1h6dw0UjjekrwvA25MD
   g==;
X-CSE-ConnectionGUID: kfKDLpJ8RtW+iFVYj6y7mA==
X-CSE-MsgGUID: FPLHozQISHWsQiJ+6VWGwQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68265949"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68265949"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:18 -0700
X-CSE-ConnectionGUID: 9StIfcr5SlmKVnemlt5T/A==
X-CSE-MsgGUID: JGn8h/IYRRG3DQMNv7WaUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="196006857"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:10 -0700
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
Subject: [RFC PATCH v2 06/23] KVM: TDX: Do not hold page refcount on private guest pages
Date: Thu,  7 Aug 2025 17:42:41 +0800
Message-ID: <20250807094241.4523-1-yan.y.zhao@intel.com>
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

To enable guest_memfd to support in-place conversion between shared and
private memory [1], TDX is required not to hold refcount of the private
pages allocated from guest_memfd.

Due to that a folio only has a single refcount and the need to reliably
determine unexpected reference when converting any shared part to private,
guest_memfd [1] does not permit shared memory to be huge [2]. Consequently,
it must split private huge pages into 4KB shared pages. However, since
guest_memfd cannot distinguish between the speculative/transient refcounts
and the intentional refcount for TDX on private pages[3], failing to
release private page refcount in TDX could cause guest_memfd to
indefinitely wait on decreasing the refcount for the splitting.

Under normal conditions, not holding an extra page refcount in TDX is safe
because guest_memfd ensures pages are retained until its invalidation
notification to KVM MMU is completed. However, if there're bugs in KVM/TDX
module, not holding an extra refcount when a page is mapped in S-EPT could
result in a page being released from guest_memfd while still mapped in the
S-EPT.

Several approaches were considered to address this issue, including
- Attempting to modify the KVM unmap operation to return a failure, which
  was deemed too complex and potentially incorrect [4].
- Increasing the folio reference count only upon S-EPT zapping failure [5].
- Use page flags or page_ext to indicate a page is still used by TDX [6],
  which does not work for HVO (HugeTLB Vmemmap Optimization).
- Setting HWPOISON bit or leveraging folio_set_hugetlb_hwpoison() [7].

Due to the complexity or inappropriateness of these approaches, and the
fact that S-EPT zapping failure is currently only possible when there are
bugs in the KVM or TDX module, which is very rare in a production kernel, a
straightforward approach of simply not holding the page reference count in
TDX was chosen [8].

When S-EPT zapping errors occur, KVM_BUG_ON() is invoked to kick off all
vCPUs and mark the VM as dead. Although there is a potential window that a
private page mapped in the S-EPT could be reallocated and used outside the
VM, the loud warning from KVM_BUG_ON() should provide sufficient debug
information. To be robust against bugs, the user can enable panic_on_warn
as normal.

Link: https://lore.kernel.org/all/cover.1747264138.git.ackerleytng@google.com [1]
Link: https://youtu.be/UnBKahkAon4 [2]
Link: https://lore.kernel.org/all/CAGtprH_ypohFy9TOJ8Emm_roT4XbQUtLKZNFcM6Fr+fhTFkE0Q@mail.gmail.com [3]
Link: https://lore.kernel.org/all/aEEEJbTzlncbRaRA@yzhao56-desk.sh.intel.com [4]
Link: https://lore.kernel.org/all/aE%2Fq9VKkmaCcuwpU@yzhao56-desk.sh.intel.com [5]
Link: https://lore.kernel.org/all/aFkeBtuNBN1RrDAJ@yzhao56-desk.sh.intel.com [6]
Link: https://lore.kernel.org/all/diqzy0tikran.fsf@ackerleytng-ctop.c.googlers.com [7]
Link: https://lore.kernel.org/all/53ea5239f8ef9d8df9af593647243c10435fd219.camel@intel.com [8]
Suggested-by: Vishal Annapurve <vannapurve@google.com>
Suggested-by: Ackerley Tng <ackerleytng@google.com>
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- new in RFC v2.
- Rebased on DPAMT and shutdown optimization.
---
 arch/x86/kvm/vmx/tdx.c | 28 ++++------------------------
 1 file changed, 4 insertions(+), 24 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index facfe589e006..376287a2ddf4 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1600,11 +1600,6 @@ void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int pgd_level)
 	td_vmcs_write64(to_tdx(vcpu), SHARED_EPT_POINTER, root_hpa);
 }
 
-static void tdx_unpin(struct kvm *kvm, struct page *page)
-{
-	put_page(page);
-}
-
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 			    enum pg_level level, struct page *page)
 {
@@ -1617,14 +1612,11 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 
 	err = tdh_mem_page_aug(&kvm_tdx->td, gpa, tdx_level, folio,
 			       folio_page_idx(folio, page), &entry, &level_state);
-	if (unlikely(tdx_operand_busy(err))) {
-		tdx_unpin(kvm, page);
+	if (unlikely(tdx_operand_busy(err)))
 		return -EBUSY;
-	}
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error_2(TDH_MEM_PAGE_AUG, err, entry, level_state);
-		tdx_unpin(kvm, page);
 		return -EIO;
 	}
 
@@ -1679,16 +1671,6 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
-	/*
-	 * Because guest_memfd doesn't support page migration with
-	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
-	 * migration.  Until guest_memfd supports page migration, prevent page
-	 * migration.
-	 * TODO: Once guest_memfd introduces callback on page migration,
-	 * implement it and remove get_page/put_page().
-	 */
-	get_page(page);
-
 	/*
 	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
 	 * barrier in tdx_td_finalize().
@@ -1755,7 +1737,6 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	}
 	tdx_clear_folio(folio, folio_page_idx(folio, page), KVM_PAGES_PER_HPAGE(level));
 	tdx_pamt_put(page, level);
-	tdx_unpin(kvm, page);
 	return 0;
 }
 
@@ -1845,7 +1826,6 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
 		tdx_pamt_put(page, level);
-		tdx_unpin(kvm, page);
 		return 0;
 	}
 
@@ -1944,12 +1924,12 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
 		KVM_BUG_ON(!kvm->vm_dead, kvm);
+
 		ret = tdx_reclaim_folio(folio, folio_page_idx(folio, page),
 					KVM_PAGES_PER_HPAGE(level), false);
-		if (!ret) {
+		if (!ret)
 			tdx_pamt_put(page, level);
-			tdx_unpin(kvm, page);
-		}
+
 		return ret;
 	}
 
-- 
2.43.2


