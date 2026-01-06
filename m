Return-Path: <kvm+bounces-67117-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 4D3B8CF7F04
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:01:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 7AC2230019D3
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:01:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B118332D435;
	Tue,  6 Jan 2026 10:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LOb9WAiy"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527EC309F19;
	Tue,  6 Jan 2026 10:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694993; cv=none; b=U6wlKk5c2fEPyOf5KMy4t0m14ESUHITElY2Uz8E1SGI1SR3CXBINtAkqICdIRCzCqxNcMvcpIAsP3qF4tFg2CRntSEjhJeMRcEYliAt4AhttKSVAFiJg1s9WCla4YpJB3Ij2Ggvb1E008CtPrw1Um96bj+JVoeK7JpEQp9HBjT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694993; c=relaxed/simple;
	bh=hU+1lBfPRw+55UuvRNPjJw1DjBSK19bueoWEonOZS1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqTK3zNnKJ4L/87gp2ckCqzhAsIQ8wLC0weEaxk4J7HnBKy1JZKPBbFkpIiUBkw1L+Qwg37A3sACGamCQmxjYPPa00Q1xzGQ0lGhpLvlY+vLyhH/LOOHfCAM0WEQGglMCIVeRp8+Cueudidvo96LTcV9m5YBcxCgC5T0uvbiKV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LOb9WAiy; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694992; x=1799230992;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=hU+1lBfPRw+55UuvRNPjJw1DjBSK19bueoWEonOZS1Y=;
  b=LOb9WAiysTgaH6jXO3uDwHe7yp2PPgvR/e6ldCyKh+FVbKCIJIkzK3Sg
   hm0k5oManHq6Ed5Zo2ZNkAuyHOIqHhJ88UE7z8v31mmPjwHNK0JgQ2gpi
   KnjbUNfPqRf0wh0MG03FYk+PoNrs3AJbBajfRgMGfk50VQKjhjY9PwblV
   EcjKqZHH8M5V/Ky1y2LcgdRMgaDUZ4jaMp4oypOe5uTHpYujI4QJekMD8
   hbo3DE2CA+mJi/J8ThvB4hgGCwVI5ikH2/kxoE6IhzuG6x9xwHC0bmT9Z
   Otr/1cZwB/dXCTkA0O4vItIrMWAD3Vv9zt2oKLSWBgxvqqs+/NKC4P+BA
   A==;
X-CSE-ConnectionGUID: 7jnqZsrJQYOfOZCIHtmSHA==
X-CSE-MsgGUID: rHDftlT5QnS0W1FJWSZAug==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72689564"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72689564"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:11 -0800
X-CSE-ConnectionGUID: h1TlaHITShCLs+g8Doza7g==
X-CSE-MsgGUID: p/ac4WuaRKCehoEo7ec8mA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="201847465"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:23:06 -0800
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
Subject: [PATCH v3 09/24] KVM: x86: Reject splitting huge pages under shared mmu_lock in TDX
Date: Tue,  6 Jan 2026 18:21:08 +0800
Message-ID: <20260106102108.25074-1-yan.y.zhao@intel.com>
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

Allow propagating SPTE splitting changes from the mirror page table to the
external page table in the fault path under shared mmu_lock, while
rejecting this splitting request in TDX's implementation of
kvm_x86_ops.split_external_spte().

Allow tdp_mmu_split_huge_page() to be invoked for the mirror page table in
the fault path by removing the KVM_BUG_ON() immediately before it.

set_external_spte_present() is invoked in the fault path under shared
mmu_lock to propagate transitions from the mirror page table to the
external page table when the target SPTE is present. Add "splitting" as a
valid transition case in set_external_spte_present() and invoke the helper
split_external_spte() to perform the propagation.

Pass shared mmu_lock information to kvm_x86_ops.split_external_spte() and
reject the splitting request in TDX's implementation of
kvm_x86_ops.split_external_spte() when under shared mmu_lock.

This is because TDX requires different handling for splitting under shared
versus exclusive mmu_lock: under shared mmu_lock, TDX cannot kick off all
vCPUs to avoid BUSY errors from DEMOTE. Since the current TDX module
(i.e., without feature NON-BLOCKING-RESIZE) requires BLOCK/TRACK/kicking
off vCPUs to be invoked before each DEMOTE, if a BUSY error occurs from
DEMOTE, TDX must call UNBLOCK before returning the error to the KVM MMU
core to roll back the old SPTE and retry. However, UNBLOCK itself may also
fail due to contentions.

Rejecting splitting of private huge pages under shared mmu_lock in TDX
rather than using KVM_BUG_ON() in the KVM MMU core allows for splitting
under shared mmu_lock once the TDX module supports the NON-BLOCKING-RESIZE
feature, keeping the KVM MMU core framework stable across TDX module
implementation changes.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Rebased on top of Sean's cleanup series.
- split_external_spte --> kvm_x86_ops.split_external_spte(). (Kai)

RFC v2:
- WARN_ON_ONCE() and return error in tdx_sept_split_private_spt() if it's
  invoked under shared mmu_lock. (rather than increase the next fault's
  max_level in current vCPU via tdx->violation_gfn_start/end and
  tdx->violation_request_level).
- TODO: Perform the real implementation of demote under shared mmu_lock
        when new version of TDX module supporting non-blocking demote is
        available.

RFC v1:
- New patch.
---
 arch/x86/include/asm/kvm_host.h |  3 +-
 arch/x86/kvm/mmu/tdp_mmu.c      | 51 +++++++++++++++++++++------------
 arch/x86/kvm/vmx/tdx.c          |  9 +++++-
 3 files changed, 42 insertions(+), 21 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 56089d6b9b51..315ffb23e9d8 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1850,7 +1850,8 @@ struct kvm_x86_ops {
 
 	/* Split a huge mapping into smaller mappings in external page table */
 	int (*split_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				   u64 old_mirror_spte, void *new_external_spt);
+				   u64 old_mirror_spte, void *new_external_spt,
+				   bool mmu_lock_shared);
 
 	/* Allocation a pages from the external page cache. */
 	void *(*alloc_external_fault_cache)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 977914b2627f..9b45ffb8585f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -509,7 +509,7 @@ static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
 }
 
 static int split_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
-			       u64 new_spte, int level)
+			       u64 new_spte, int level, bool shared)
 {
 	void *new_external_spt = get_external_spt(gfn, new_spte, level);
 	int ret;
@@ -517,7 +517,7 @@ static int split_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	KVM_BUG_ON(!new_external_spt, kvm);
 
 	ret = kvm_x86_call(split_external_spte)(kvm, gfn, level, old_spte,
-						new_external_spt);
+						new_external_spt, shared);
 	return ret;
 }
 
@@ -527,10 +527,20 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 {
 	bool was_present = is_shadow_present_pte(old_spte);
 	bool is_present = is_shadow_present_pte(new_spte);
+	bool was_leaf = was_present && is_last_spte(old_spte, level);
 	bool is_leaf = is_present && is_last_spte(new_spte, level);
 	int ret = 0;
 
-	KVM_BUG_ON(was_present, kvm);
+	/*
+	 * The caller __tdp_mmu_set_spte_atomic() has ensured new_spte must be
+	 * present.
+	 *
+	 * Current valid transitions:
+	 * - leaf to non-leaf (demote)
+	 * - !present to present leaf
+	 * - !present to present non-leaf
+	 */
+	KVM_BUG_ON(!(!was_present || (was_leaf && !is_leaf)), kvm);
 
 	lockdep_assert_held(&kvm->mmu_lock);
 	/*
@@ -541,18 +551,24 @@ static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sp
 	if (!try_cmpxchg64(rcu_dereference(sptep), &old_spte, FROZEN_SPTE))
 		return -EBUSY;
 
-	/*
-	 * Use different call to either set up middle level
-	 * external page table, or leaf.
-	 */
-	if (is_leaf) {
-		ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
-	} else {
-		void *external_spt = get_external_spt(gfn, new_spte, level);
+	if (!was_present) {
+		/*
+		 * Use different call to either set up middle level external
+		 * page table, or leaf.
+		 */
+		if (is_leaf) {
+			ret = kvm_x86_call(set_external_spte)(kvm, gfn, level, new_spte);
+		} else {
+			void *external_spt = get_external_spt(gfn, new_spte, level);
 
-		KVM_BUG_ON(!external_spt, kvm);
-		ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
+			KVM_BUG_ON(!external_spt, kvm);
+			ret = kvm_x86_call(link_external_spt)(kvm, gfn, level, external_spt);
+		}
+	} else if (was_leaf && !is_leaf) {
+		/* splitting */
+		ret = split_external_spte(kvm, gfn, old_spte, new_spte, level, true);
 	}
+
 	if (ret)
 		__kvm_tdp_mmu_write_spte(sptep, old_spte);
 	else
@@ -782,7 +798,7 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 		if (!is_shadow_present_pte(new_spte))
 			remove_external_spte(kvm, gfn, old_spte, level);
 		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
-			split_external_spte(kvm, gfn, old_spte, new_spte, level);
+			split_external_spte(kvm, gfn, old_spte, new_spte, level, false);
 		else
 			KVM_BUG_ON(1, kvm);
 	}
@@ -1331,13 +1347,10 @@ int kvm_tdp_mmu_map(struct kvm_vcpu *vcpu, struct kvm_page_fault *fault)
 
 		sp->nx_huge_page_disallowed = fault->huge_page_disallowed;
 
-		if (is_shadow_present_pte(iter.old_spte)) {
-			/* Don't support large page for mirrored roots (TDX) */
-			KVM_BUG_ON(is_mirror_sptep(iter.sptep), vcpu->kvm);
+		if (is_shadow_present_pte(iter.old_spte))
 			r = tdp_mmu_split_huge_page(kvm, &iter, sp, true);
-		} else {
+		else
 			r = tdp_mmu_link_sp(kvm, &iter, sp, true);
-		}
 
 		/*
 		 * Force the guest to retry if installing an upper level SPTE
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index b41793402769..1e29722abb36 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1926,7 +1926,8 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
  * BUSY.
  */
 static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level level,
-				       u64 old_mirror_spte, void *new_private_spt)
+				       u64 old_mirror_spte, void *new_private_spt,
+				       bool mmu_lock_shared)
 {
 	struct page *new_sept_page = virt_to_page(new_private_spt);
 	int tdx_level = pg_level_to_tdx_sept_level(level);
@@ -1938,6 +1939,12 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 		       level != PG_LEVEL_2M, kvm))
 		return -EIO;
 
+	if (WARN_ON_ONCE(mmu_lock_shared)) {
+		pr_warn_once("Splitting of GFN %llx level %d under shared lock occurs when KVM does not support it yet\n",
+			     gfn, level);
+		return -EOPNOTSUPP;
+	}
+
 	err = tdh_do_no_vcpus(tdh_mem_range_block, kvm, &kvm_tdx->td, gpa,
 			      tdx_level, &entry, &level_state);
 	if (TDX_BUG_ON_2(err, TDH_MEM_RANGE_BLOCK, entry, level_state, kvm))
-- 
2.43.2


