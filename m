Return-Path: <kvm+bounces-17397-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2452F8C5E82
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 03:00:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BCFEF1F22504
	for <lists+kvm@lfdr.de>; Wed, 15 May 2024 01:00:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6452A13AF2;
	Wed, 15 May 2024 01:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HdA5UoLg"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD6963D5;
	Wed, 15 May 2024 01:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715734806; cv=none; b=XIMFTvwmJmrwo5E9thpGqs9Lx7cEOD5AA5jyyaqSeOvSCJTM7sjBkO1NZ1wp3Ozmpes4eIassZifuG/+XnygzGBMBxsUv4GFKOn8TdNiupLVd3+4BCdB9M6SLBul2wKHZ5y/AarWhMnfjcuFsGUBRLnqnVLY3uuDW7OUnteCeRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715734806; c=relaxed/simple;
	bh=v6Cuz4zx2wjPGlGh14VUElcDcI+9AmfYj5Tp5b9rlU8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Gu3eYArLO+EW/j+0jPlOvUnbdvCL82fZ4FwtPw4LxJMMZ4tbNOgIlSmIFJyTODhcICo+nF2bi2nbPrX3EmtZqnuAPZ0SZJCSKiIk29jAxDTz7YiUDZ91YaD6PmwNfy8vSm4i/ZYJtMxJuNEvISUkGN21mtv2AZ5fZBkecagAvdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HdA5UoLg; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715734805; x=1747270805;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v6Cuz4zx2wjPGlGh14VUElcDcI+9AmfYj5Tp5b9rlU8=;
  b=HdA5UoLgQMGvRLAevm/KcR0Utgh3n3L+8mPLcEu3ge/7dke4D2TvxjhN
   7hCdOHVCAHO8bjtEPNRy7yyO4ewk2rZ8ukY8bZL4qMFir7jj5ly56yAeF
   h1dDeW6XI/Xa6UP1liP2xGATGJJxLKfLZVkCHxU8cPBTfOecBt2S3TE9U
   J+aeuvC8uYeEh5PiBfCZsFYka7UmN/cHHVaaK32hzyLQBI1anrfokvnFQ
   gejJAbSB6FNqdrclE+xWTSOvlCQ/CphcyNEvLiO8IBSN1wPHwulLBGjGt
   XgnbuRxYLbI0uMljrh053N0UFozJifsgn9wA9kIlNh/WqRi4iXp2R6GE+
   A==;
X-CSE-ConnectionGUID: p5VVk2WYSwGHh7zTb+AW6g==
X-CSE-MsgGUID: BKKy142LTn2ESNJbs6qfxQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11073"; a="11613937"
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="11613937"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:03 -0700
X-CSE-ConnectionGUID: KkRdh+qpQ4GfL6f/kt9Bug==
X-CSE-MsgGUID: TU/ohH1tRra8vedU9iOw9Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,160,1712646000"; 
   d="scan'208";a="30942719"
Received: from oyildiz-mobl1.amr.corp.intel.com (HELO rpedgeco-desk4.intel.com) ([10.209.51.34])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 May 2024 18:00:02 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	isaku.yamahata@gmail.com,
	erdemaktas@google.com,
	sagis@google.com,
	yan.y.zhao@intel.com,
	dmatlack@google.com,
	rick.p.edgecombe@intel.com
Subject: [PATCH 03/16] KVM: x86/tdp_mmu: Add a helper function to walk down the TDP MMU
Date: Tue, 14 May 2024 17:59:39 -0700
Message-Id: <20240515005952.3410568-4-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
References: <20240515005952.3410568-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Export a function to walk down the TDP without modifying it.

Future changes will support pre-populating TDX private memory. In order to
implement this KVM will need to check if a given GFN is already
pre-populated in the mirrored EPT, and verify the populated private memory
PFN matches the current one.[1]

There is already a TDP MMU walker, kvm_tdp_mmu_get_walk() for use within
the KVM MMU that almost does what is required. However, to make sense of
the results, MMU internal PTE helpers are needed. Refactor the code to
provide a helper that can be used outside of the KVM MMU code.

Refactoring the KVM page fault handler to support this lookup usage was
also considered, but it was an awkward fit.

Link: https://lore.kernel.org/kvm/ZfBkle1eZFfjPI8l@google.com/ [1]
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
This helper will be used in the future change that implements
KVM_TDX_INIT_MEM_REGION. Please refer to the following commit for the
usage:
https://github.com/intel/tdx/commit/2832c6d87a4e6a46828b193173550e80b31240d4

TDX MMU Part 1:
 - New patch
---
 arch/x86/kvm/mmu.h         |  3 +++
 arch/x86/kvm/mmu/tdp_mmu.c | 37 +++++++++++++++++++++++++++++++++----
 2 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu.h b/arch/x86/kvm/mmu.h
index dc80e72e4848..3c7a88400cbb 100644
--- a/arch/x86/kvm/mmu.h
+++ b/arch/x86/kvm/mmu.h
@@ -275,6 +275,9 @@ extern bool tdp_mmu_enabled;
 #define tdp_mmu_enabled false
 #endif
 
+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
+				     kvm_pfn_t *pfn);
+
 static inline bool kvm_memslots_have_rmaps(struct kvm *kvm)
 {
 	return !tdp_mmu_enabled || kvm_shadow_root_allocated(kvm);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 1259dd63defc..1086e3b2aa5c 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -1772,16 +1772,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
  *
  * Must be called between kvm_tdp_mmu_walk_lockless_{begin,end}.
  */
-int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
-			 int *root_level)
+static int __kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+				  bool is_private)
 {
 	struct tdp_iter iter;
 	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
-	*root_level = vcpu->arch.mmu->root_role.level;
-
 	tdp_mmu_for_each_pte(iter, mmu, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
@@ -1790,6 +1788,37 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 	return leaf;
 }
 
+int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
+			 int *root_level)
+{
+	*root_level = vcpu->arch.mmu->root_role.level;
+
+	return __kvm_tdp_mmu_get_walk(vcpu, addr, sptes, false);
+}
+
+int kvm_tdp_mmu_get_walk_private_pfn(struct kvm_vcpu *vcpu, u64 gpa,
+				     kvm_pfn_t *pfn)
+{
+	u64 sptes[PT64_ROOT_MAX_LEVEL + 1], spte;
+	int leaf;
+
+	lockdep_assert_held(&vcpu->kvm->mmu_lock);
+
+	rcu_read_lock();
+	leaf = __kvm_tdp_mmu_get_walk(vcpu, gpa, sptes, true);
+	rcu_read_unlock();
+	if (leaf < 0)
+		return -ENOENT;
+
+	spte = sptes[leaf];
+	if (!(is_shadow_present_pte(spte) && is_last_spte(spte, leaf)))
+		return -ENOENT;
+
+	*pfn = spte_to_pfn(spte);
+	return leaf;
+}
+EXPORT_SYMBOL_GPL(kvm_tdp_mmu_get_walk_private_pfn);
+
 /*
  * Returns the last level spte pointer of the shadow page walk for the given
  * gpa, and sets *spte to the spte value. This spte may be non-preset. If no
-- 
2.34.1


