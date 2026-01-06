Return-Path: <kvm+bounces-67115-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C589CF7C5D
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:24:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A4852304D48D
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:23:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 70E7032573E;
	Tue,  6 Jan 2026 10:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RncWkF2F"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F93A309F19;
	Tue,  6 Jan 2026 10:22:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694972; cv=none; b=CJBHawR6kEvYCN07xR+c/TRMfhtDPsSD9dqBJFCadRekg+B4SlGbPi6HqdPwZyzTMX6RxLBE7a1SDtjkPn9ZyY73zw8UUDCPh+kynn0sGOvuJ/AubWlIXFcofPeJQfFQyX5Daa8SZv8S7M0Cu05mEU7iB312trymTkndf2p1/b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694972; c=relaxed/simple;
	bh=vDwN3h48oxVtbZG2Fhg72RtCLukqpxS4T1TL6g+eqw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNWAkWkN3i4eJnnDwqn81OimTVrQaCnSNZ/zRgYi/xQuuKuXNwHfby4nD6oVsnx5hkddX7A5uOhn4X5+4xAs0HtMC4gT/b53oh0Rm43vO7glO3wTQEWi39T7omsSa6vQeklsOIo2PD1i6flj5JHXIj+s94IlR2bRSRTwNsx/zOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RncWkF2F; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694963; x=1799230963;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vDwN3h48oxVtbZG2Fhg72RtCLukqpxS4T1TL6g+eqw0=;
  b=RncWkF2FMOTtpjCC8FWTrpwnLgouY0QuV3aPOOueDbF1QOzwkuvLBze8
   Z4OQ9hkYDGtWj/ctnR+TjDHAgRuKUjYMiPJRJF1UDcZM88I5TtQ2Zsx2V
   amH/1LcG4MatuWUySKCkSG6uVXHQmvOdP3r9Qr7xbD39B0JBlgkPmaJtp
   qsM7QGMFQnA7HopbWb+ueVMlubxuKlpSSSEFOSa6B45GK3uGAdTz6kEvS
   F7EaSmpHtYRwrqukzPGybWcruerN0lr5c5YQJbuMrxTYT/nrhsKAqVQDI
   YRqIM/GMdlParFrupSyFv6vTKj66t6sf/tyoIIOKVbdqbzmDHNGA7/dFF
   A==;
X-CSE-ConnectionGUID: OvIGolOVS1a4K0Mhal2fJA==
X-CSE-MsgGUID: 9vSfBLiXTXGmnE67a8uHOw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="80176839"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="80176839"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:43 -0800
X-CSE-ConnectionGUID: CJVlXTmUT92JzZDWqT1ODg==
X-CSE-MsgGUID: QaTzNb7uRFaE4BHRwl7jWQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="203085160"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:22:37 -0800
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
Subject: [PATCH v3 07/24] KVM: x86/tdp_mmu: Introduce split_external_spte() under write mmu_lock
Date: Tue,  6 Jan 2026 18:20:40 +0800
Message-ID: <20260106102040.25041-1-yan.y.zhao@intel.com>
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

Introduce kvm_x86_ops.split_external_spte() and wrap it in a helper
function split_external_spte(). Invoke the helper function
split_external_spte() in tdp_mmu_set_spte() to propagate splitting
transitions from the mirror page table to the external page table under
write mmu_lock.

Introduce a new valid transition case for splitting and document all valid
transitions of the mirror page table under write mmu_lock in
tdp_mmu_set_spte().

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Rename split_external_spt() to split_external_spte().

- Pass in param "old_mirror_spte" to hook kvm_x86_ops.set_external_spte().
  This is in aligned with the parameter change in hook
  kvm_x86_ops.set_external_spte() in Sean's cleanup series, and also allows
  future DPAMT patches to acquire guest private PFN from the old mirror
  spte.

- Rename param "external_spt" to "new_external_spt" in hook
  kvm_x86_ops.set_external_spte() to indicate this is a new page table page
  for the external page table.

- Drop declaration of get_external_spt() by moving split_external_spte()
  after get_external_spt() but before set_external_spte_present() and
  tdp_mmu_set_spte(). (Kai)

- split_external_spte --> split_external_spte() (Kai)

RFC v2:
- Removed the KVM_BUG_ON() in split_external_spt(). (Rick)
- Add a comment for the KVM_BUG_ON() in tdp_mmu_set_spte(). (Rick)
- Use kvm_x86_call() instead of static_call(). (Binbin)

RFC v1:
- Split patch.
- Dropped invoking hook zap_private_spte and kvm_flush_remote_tlbs() in KVM
  MMU core.
---
 arch/x86/include/asm/kvm-x86-ops.h |  1 +
 arch/x86/include/asm/kvm_host.h    |  4 ++++
 arch/x86/kvm/mmu/tdp_mmu.c         | 29 +++++++++++++++++++++++++----
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/kvm-x86-ops.h b/arch/x86/include/asm/kvm-x86-ops.h
index 58c5c9b082ca..84fa8689b45c 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,6 +98,7 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP_OPTIONAL(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(split_external_spte)
 KVM_X86_OP_OPTIONAL(alloc_external_fault_cache)
 KVM_X86_OP_OPTIONAL(topup_external_fault_cache)
 KVM_X86_OP_OPTIONAL(free_external_fault_cache)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 7818da148a8c..56089d6b9b51 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1848,6 +1848,10 @@ struct kvm_x86_ops {
 	void (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				     u64 mirror_spte);
 
+	/* Split a huge mapping into smaller mappings in external page table */
+	int (*split_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				   u64 old_mirror_spte, void *new_external_spt);
+
 	/* Allocation a pages from the external page cache. */
 	void *(*alloc_external_fault_cache)(struct kvm_vcpu *vcpu);
 
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index dfa56554f9e0..977914b2627f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -508,6 +508,19 @@ static void *get_external_spt(gfn_t gfn, u64 new_spte, int level)
 	return NULL;
 }
 
+static int split_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+			       u64 new_spte, int level)
+{
+	void *new_external_spt = get_external_spt(gfn, new_spte, level);
+	int ret;
+
+	KVM_BUG_ON(!new_external_spt, kvm);
+
+	ret = kvm_x86_call(split_external_spte)(kvm, gfn, level, old_spte,
+						new_external_spt);
+	return ret;
+}
+
 static int __must_check set_external_spte_present(struct kvm *kvm, tdp_ptep_t sptep,
 						 gfn_t gfn, u64 old_spte,
 						 u64 new_spte, int level)
@@ -758,12 +771,20 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
 	handle_changed_spte(kvm, as_id, gfn, old_spte, new_spte, level, false);
 
 	/*
-	 * Users that do non-atomic setting of PTEs don't operate on mirror
-	 * roots, so don't handle it and bug the VM if it's seen.
+	 * Propagate changes of SPTE to the external page table under write
+	 * mmu_lock.
+	 * Current valid transitions:
+	 * - present leaf to !present.
+	 * - present non-leaf to !present.
+	 * - present leaf to present non-leaf (splitting)
 	 */
 	if (is_mirror_sptep(sptep)) {
-		KVM_BUG_ON(is_shadow_present_pte(new_spte), kvm);
-		remove_external_spte(kvm, gfn, old_spte, level);
+		if (!is_shadow_present_pte(new_spte))
+			remove_external_spte(kvm, gfn, old_spte, level);
+		else if (is_last_spte(old_spte, level) && !is_last_spte(new_spte, level))
+			split_external_spte(kvm, gfn, old_spte, new_spte, level);
+		else
+			KVM_BUG_ON(1, kvm);
 	}
 
 	return old_spte;
-- 
2.43.2


