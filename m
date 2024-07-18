Return-Path: <kvm+bounces-21891-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EE5C935302
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 23:15:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 504BF1C20AAC
	for <lists+kvm@lfdr.de>; Thu, 18 Jul 2024 21:15:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0D83149018;
	Thu, 18 Jul 2024 21:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CnIfGK+P"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DB01482F6;
	Thu, 18 Jul 2024 21:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337173; cv=none; b=lm7hCQXtTZngYCCkXRExfXE24rJOVznDZ6WlDy9gFO46LtouL4cV70fHpnnb0DsJd+6hecRDjKPXop0QA7HyYwKh5nhpVxUJBg/JgeAdfRklve+ZcB5aYeY3qWDFj6//Sq7XuaTR608yEVq2rZ5je2CKiBeXGrR0mYV/fZHAC4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337173; c=relaxed/simple;
	bh=GIqmXeHXZ5jjeqhd6Kt07dWbmumlLDA3CxsAU3bJBSQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=jIAQONqk9C40hIYQazqSO+EG6yfKvRRNqAp96rNnWOgB70HZ+QGcOp4xmQjQeWEmu/hfB/bwGy7DKae7df7Akm+snDEc/rW/VTGpbv3P2f88Ce+E8bALMB7abFzkWpucO66UQEfqJApxnYk681DsLGtEyn06cAOH1ztT3WF/EZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CnIfGK+P; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721337171; x=1752873171;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GIqmXeHXZ5jjeqhd6Kt07dWbmumlLDA3CxsAU3bJBSQ=;
  b=CnIfGK+PaBbUBw+uzoA7h0Wmy1kSIG3SsBYZLytcIlsDNXk3AAiQjwnV
   XS3XHSoeu3lrVjGessygoYpMDcpgl+SlasA9GjCx1qzQLGkSh8LH2LXeJ
   6L5ravOVpuJrV+VOT4irdrDsnE7rVL9qDSPukXW1709AxStyI6XU5F96o
   Xtt3SqH5+Z/tjgPd+1D/XnPOfZsN+gCChJSvUyyM/AtoUTyQDJ9qAiSwH
   zsyCW/yQ3Sv2E7xzenh4PV+ncGlnqmhQW6Gzck4nP9z5Hg1WyBcSDlK/F
   L/CrIBSPAEuB1AB4314zDaB9ce+Z7caDRFwB5C9oz9Ua8T8TmavM5qzJk
   A==;
X-CSE-ConnectionGUID: oJUruyzvTQeFrcA7bLOlFQ==
X-CSE-MsgGUID: lFT+0npfQ/O5LoUdzTLT4A==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22697441"
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="22697441"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:48 -0700
X-CSE-ConnectionGUID: hgBd8u5ERiyUAczeDEccAQ==
X-CSE-MsgGUID: SHdXR4xoTrGPetcTVI0rnw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,218,1716274800"; 
   d="scan'208";a="55760407"
Received: from ccbilbre-mobl3.amr.corp.intel.com (HELO rpedgeco-desk4..) ([10.124.223.76])
  by ORVIESA003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jul 2024 14:12:47 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: seanjc@google.com,
	pbonzini@redhat.com,
	kvm@vger.kernel.org
Cc: kai.huang@intel.com,
	dmatlack@google.com,
	erdemaktas@google.com,
	isaku.yamahata@gmail.com,
	linux-kernel@vger.kernel.org,
	sagis@google.com,
	yan.y.zhao@intel.com,
	rick.p.edgecombe@intel.com,
	Isaku Yamahata <isaku.yamahata@intel.com>
Subject: [PATCH v4 11/18] KVM: x86/tdp_mmu: Take root in tdp_mmu_for_each_pte()
Date: Thu, 18 Jul 2024 14:12:23 -0700
Message-Id: <20240718211230.1492011-12-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
References: <20240718211230.1492011-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Isaku Yamahata <isaku.yamahata@intel.com>

Take the root as an argument of tdp_mmu_for_each_pte() instead of looking
it up in the mmu. With no other purpose of passing the mmu, drop it.

Future changes will want to change which root is used based on the context
of the MMU operation. So change the callers to pass in the root currently
used, mmu->root.hpa in a preparatory patch to make the later one smaller
and easier to review.

Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Split from "KVM: x86/mmu: Support GFN direct mask" (Paolo)
---
 arch/x86/kvm/mmu/tdp_mmu.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 2e7e6e3137c6..19bd891702a9 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -694,8 +694,8 @@ static inline void tdp_mmu_iter_set_spte(struct kvm *kvm, struct tdp_iter *iter,
 			continue;					\
 		else
 
-#define tdp_mmu_for_each_pte(_iter, _kvm, _mmu, _start, _end)		\
-	for_each_tdp_pte(_iter, _kvm, root_to_sp(_mmu->root.hpa), _start, _end)
+#define tdp_mmu_for_each_pte(_iter, _kvm, _root, _start, _end)	\
+	for_each_tdp_pte(_iter, _kvm, _root, _start, _end)
 
 /*
  * Yield if the MMU lock is contended or this thread needs to return control
@@ -1117,8 +1117,8 @@ static int tdp_mmu_split_huge_page(struct kvm *kvm, struct tdp_iter *iter,
  */
 int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 {
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	struct kvm *kvm = vcpu->kvm;
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
 	struct kvm_mmu_page *sp;
 	int ret = RET_PF_RETRY;
@@ -1129,7 +1129,7 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 	rcu_read_lock();
 
-	tdp_mmu_for_each_pte(iter, kvm, mmu, fault->gfn, fault->gfn + 1) {
+	tdp_mmu_for_each_pte(iter, kvm, root, fault->gfn, fault->gfn + 1) {
 		int r;
 
 		if (fault->nx_huge_page_workaround_enabled)
@@ -1788,14 +1788,14 @@ bool kvm_tdp_mmu_write_protect_gfn(struct kvm *kvm,
 int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 			 int *root_level)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	gfn_t gfn = addr >> PAGE_SHIFT;
 	int leaf = -1;
 
 	*root_level = vcpu->arch.mmu->root_role.level;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		leaf = iter.level;
 		sptes[leaf] = iter.old_spte;
 	}
@@ -1817,11 +1817,11 @@ int kvm_tdp_mmu_get_walk(struct kvm_vcpu *vcpu, u64 addr, u64 *sptes,
 u64 *kvm_tdp_mmu_fast_pf_get_last_sptep(struct kvm_vcpu *vcpu, gfn_t gfn,
 					u64 *spte)
 {
+	struct kvm_mmu_page *root = root_to_sp(vcpu->arch.mmu->root.hpa);
 	struct tdp_iter iter;
-	struct kvm_mmu *mmu = vcpu->arch.mmu;
 	tdp_ptep_t sptep = NULL;
 
-	tdp_mmu_for_each_pte(iter, vcpu->kvm, mmu, gfn, gfn + 1) {
+	tdp_mmu_for_each_pte(iter, vcpu->kvm, root, gfn, gfn + 1) {
 		*spte = iter.old_spte;
 		sptep = iter.sptep;
 	}
-- 
2.34.1


