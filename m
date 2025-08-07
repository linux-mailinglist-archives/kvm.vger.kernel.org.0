Return-Path: <kvm+bounces-54248-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C435B1D53F
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:49:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 212A5189AE11
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:48:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84DF02222C0;
	Thu,  7 Aug 2025 09:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="dOAyoipS"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA9D376F1;
	Thu,  7 Aug 2025 09:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754560026; cv=none; b=hlSjFN3x+oNjHoZ9d1M/wKN/2oGvkQl9A1KVaILhnXVHF709/NpMyqc2j8m4kQkGCnPkCAUKytnwpRD5HHql6J4Qehr3g0vG6MLFG6aFIfTpefXhrolN5ctELAduL8b6PteMcVDxaU3+kLUGTzLS314lEHF+gHAVZNoSoX6qREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754560026; c=relaxed/simple;
	bh=QohJ+OL8OcCcI8Wjtg+1wD2yGPeRKILdN4re2iF+VXY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SlE7pt0Wt+Jpamy4yNqpsA1B3YWB6KYmIOkD1yWxNaNykvRWwYRJWabiK4h70Nx7P7BzqrKXuKsbEDAOoaVuQ07Js6AhbfTMiflcAT6K1W5g1XS15T/hXuFaKwIJ+Ka9ngbJslEt440TFAuDxcG1iFNyWlEwwD5s6BSoU4hw+gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=dOAyoipS; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754560025; x=1786096025;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QohJ+OL8OcCcI8Wjtg+1wD2yGPeRKILdN4re2iF+VXY=;
  b=dOAyoipST73t0zTfPhGj87eOzlPj4nn2BIyYfKIk7hpRMnFlTMXGFHu7
   fjnDOQXwxlw9pOYZnVDl0+5uIfGV4Dv6oag/aP3UdJ0Nzbi8jmgYFqyif
   /rzoD1oT5+p3x9tb7K1eAC7gY5xnzlEIqFwLwAmBMNLpe/PI/YpGPssh4
   y0JNV1O77IEGFVSP5o1CZX0GyKomICi7Lf1C4QjAnOSzU04XjvaO3eU2w
   Kp95yHkYhAdY25U6+tBr19NF0QVHRmn5HqCT9oZyjQd/Z+t4jHkCe2/o2
   2zzl5z/lSiPRKscdIvGqePY9ZfYuZmtU57dqVUN1Nk4nLjR8HhLW2+ig8
   w==;
X-CSE-ConnectionGUID: z0R/RCpuQRKt2KjNt7k/ug==
X-CSE-MsgGUID: acg1tVAaSvSmaTHVoVtSDg==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="55925643"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="55925643"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:47:04 -0700
X-CSE-ConnectionGUID: a7qmAyM3RtaXgAOttRiJWA==
X-CSE-MsgGUID: wwcGpd2WSJKyst8Z3C5Iew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="188698545"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:46:58 -0700
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
Subject: [RFC PATCH v2 23/23] KVM: TDX: Turn on PG_LEVEL_2M after TD is RUNNABLE
Date: Thu,  7 Aug 2025 17:46:28 +0800
Message-ID: <20250807094628.4790-1-yan.y.zhao@intel.com>
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

Turn on PG_LEVEL_2M in tdx_gmem_private_max_mapping_level() when TD is
RUNNABLE.

Update the warnings and KVM_BUG_ON() info elsewhere to match that 2MB
mappings are permitted after TD is RUNNABLE.

Opportunistically, remove the unused params "gfn" and "pfn" in
tdx_mem_page_record_premap_cnt().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Merged RFC v1's patch 4 (forcing PG_LEVEL_4K before TD runnable) with
  patch 9 (allowing PG_LEVEL_2M after TD runnable).
---
 arch/x86/kvm/vmx/tdx.c | 29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 6e061d659639..a3e1ac044ee9 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1633,12 +1633,11 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
  * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
  * are no half-initialized shared EPT pages.
  */
-static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
-					  enum pg_level level, kvm_pfn_t pfn)
+static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, enum pg_level level)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
-	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
+	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed || level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
 	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
@@ -1667,10 +1666,6 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (ret)
 		return ret;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
-		return -EINVAL;
-
 	/*
 	 * Read 'pre_fault_allowed' before 'kvm_tdx->state'; see matching
 	 * barrier in tdx_td_finalize().
@@ -1680,7 +1675,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
 		ret = tdx_mem_page_aug(kvm, gfn, level, page);
 	else
-		ret = tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+		ret = tdx_mem_page_record_premap_cnt(kvm, level);
 
 	if (ret)
 		tdx_pamt_put(page, level);
@@ -1697,8 +1692,8 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
 
-	/* TODO: handle large pages. */
-	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+	/* Large page is not supported before TD runnable,*/
+	if (KVM_BUG_ON(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
@@ -1791,7 +1786,7 @@ static int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
 					     u64 entry, int level)
 {
-	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
+	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE || level > PG_LEVEL_4K)
 		return false;
 
 	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
@@ -1811,8 +1806,8 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	gpa_t gpa = gfn_to_gpa(gfn) & KVM_HPAGE_MASK(level);
 	u64 err, entry, level_state;
 
-	/* For now large page isn't supported yet. */
-	WARN_ON_ONCE(level != PG_LEVEL_4K);
+	/* Large page is not supported before TD runnable,*/
+	WARN_ON_ONCE(kvm_tdx->state != TD_STATE_RUNNABLE && level != PG_LEVEL_4K);
 
 	err = tdh_mem_range_block(&kvm_tdx->td, gpa, tdx_level, &entry, &level_state);
 
@@ -1993,6 +1988,9 @@ static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	struct folio *folio = page_folio(page);
 	int ret;
 
+	WARN_ON_ONCE(folio_page_idx(folio, page) + KVM_PAGES_PER_HPAGE(level) >
+		     folio_nr_pages(folio));
+
 	if (!is_hkid_assigned(to_kvm_tdx(kvm))) {
 		KVM_BUG_ON(!kvm->vm_dead, kvm);
 
@@ -3470,7 +3468,10 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 
 int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
-	return PG_LEVEL_4K;
+	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
+		return PG_LEVEL_4K;
+
+	return PG_LEVEL_2M;
 }
 
 static int tdx_online_cpu(unsigned int cpu)
-- 
2.43.2


