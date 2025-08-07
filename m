Return-Path: <kvm+bounces-54234-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47D0FB1D511
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:44:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A1423B0934
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:44:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0A0925D53B;
	Thu,  7 Aug 2025 09:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="PnmeKIQO"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 617D7262FF6;
	Thu,  7 Aug 2025 09:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559838; cv=none; b=IsWpdOilgL5ehQQDeJOjtjXkQxda1/XsH21jlg5Hy8bCwzqKY5MQeuDVeOVu/B8hkm+R2O9GImX5BmulBNXpKXi5l9r7qHTLRolO2qQ6C/61yfZov2UDHMHIUqcB5jsAZLMlc4EF9favUh0vzvfNjL9H2qyk315EMfy3g00Iftc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559838; c=relaxed/simple;
	bh=m1hJL+zQ2XvhFZfjrdYUeUZ2yU6m5lCuGdL/Z7SEjto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8IueoaLBbEk018CY/goGOeaqDVx/Mk1S740nYUntrePo+zscXt+xYb0bDzlJY82qlPl+BHb07AcltiJhRg8TFV8Ohw5f50k6mCqHb3bgaa+rvP8kO17nP1XmZYrLg1LXUGhGJj9aEyWS38tCJxz8v6iJcUxUL7fiHmrr1YFcpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=PnmeKIQO; arc=none smtp.client-ip=192.198.163.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559836; x=1786095836;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=m1hJL+zQ2XvhFZfjrdYUeUZ2yU6m5lCuGdL/Z7SEjto=;
  b=PnmeKIQOkmmV8FYgRHJq3xDnROTdKIusKrs5jehhd8TrLFOBXb9qUrt3
   zvEPjY5hIQE5ibeItjBgUz9YBr4/rsfntgWvgjCZ7t2j8FcpAy63BpPs/
   Gj+VsdZrivSSFw5cXAt4s7c0NPEX5ySIl4wI8m8FQdDFfbS+bkdjrQGOd
   bE1Pql5AGDNu+CruPKFRTxGVhPZVUE/vx1oPDxl/PndRigozlMzVNOBtV
   eNR4FWq8a+exMXA7U1ekeLMR5Y2PO5p47jY+rPxMtwtzEqffY/cNs+e7a
   ivmJXUehssfehjrRCoILP7fmpAtnIo4wxwUdQe2RNm3kv2KK/9c9O8YdW
   w==;
X-CSE-ConnectionGUID: ux2SeQKsTouggpfHHU2PlA==
X-CSE-MsgGUID: FhGIVhAGQZSsDwSG5A50Vw==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="57023590"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="57023590"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa109.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:55 -0700
X-CSE-ConnectionGUID: JnHJhxnATtCAdUysmNQsrQ==
X-CSE-MsgGUID: zyQ0U6yhTt2TCm48nGZ/+Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="165815232"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:43:50 -0700
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
Subject: [RFC PATCH v2 09/23] KVM: x86/tdp_mmu: Add split_external_spt hook called during write mmu_lock
Date: Thu,  7 Aug 2025 17:43:20 +0800
Message-ID: <20250807094320.4565-1-yan.y.zhao@intel.com>
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

Introduce the split_external_spt hook and call it within tdp_mmu_set_spte()
for the mirror page table.

tdp_mmu_set_spte() is invoked for SPTE transitions under write mmu_lock.
For the mirror page table, in addition to the valid transitions from a
shadow-present entry to !shadow-present entry, introduce a new valid
transition case for splitting and propagate the transition to the external
page table via the hook split_external_spt.

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
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
index 18a5c3119e1a..7653a45ad5b2 100644
--- a/arch/x86/include/asm/kvm-x86-ops.h
+++ b/arch/x86/include/asm/kvm-x86-ops.h
@@ -98,6 +98,7 @@ KVM_X86_OP_OPTIONAL(link_external_spt)
 KVM_X86_OP_OPTIONAL(set_external_spte)
 KVM_X86_OP_OPTIONAL(free_external_spt)
 KVM_X86_OP_OPTIONAL(remove_external_spte)
+KVM_X86_OP_OPTIONAL(split_external_spt)
 KVM_X86_OP(has_wbinvd_exit)
 KVM_X86_OP(get_l2_tsc_offset)
 KVM_X86_OP(get_l2_tsc_multiplier)
diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 823d1aeef2a8..e431ce0e3180 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1839,6 +1839,10 @@ struct kvm_x86_ops {
 	int (*remove_external_spte)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 				    kvm_pfn_t pfn_for_gfn);
 
+	/* Split the external page table into smaller page tables */
+	int (*split_external_spt)(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+				  void *external_spt);
+
 	bool (*has_wbinvd_exit)(void);
 
 	u64 (*get_l2_tsc_offset)(struct kvm_vcpu *vcpu);
diff --git a/arch/x86/kvm/mmu/tdp_mmu.c b/arch/x86/kvm/mmu/tdp_mmu.c
index 46b9f276bb6d..a2c6e6e4773f 100644
--- a/arch/x86/kvm/mmu/tdp_mmu.c
+++ b/arch/x86/kvm/mmu/tdp_mmu.c
@@ -325,6 +325,7 @@ static void handle_changed_spte(struct kvm *kvm, int as_id, gfn_t gfn,
 				bool shared);
 
 static struct kvm_mmu_page *tdp_mmu_alloc_sp_for_split(bool mirror);
+static void *get_external_spt(gfn_t gfn, u64 new_spte, int level);
 
 static void tdp_account_mmu_page(struct kvm *kvm, struct kvm_mmu_page *sp)
 {
@@ -384,6 +385,18 @@ static void remove_external_spte(struct kvm *kvm, gfn_t gfn, u64 old_spte,
 	KVM_BUG_ON(ret, kvm);
 }
 
+static int split_external_spt(struct kvm *kvm, gfn_t gfn, u64 old_spte,
+			      u64 new_spte, int level)
+{
+	void *external_spt = get_external_spt(gfn, new_spte, level);
+	int ret;
+
+	KVM_BUG_ON(!external_spt, kvm);
+
+	ret = kvm_x86_call(split_external_spt)(kvm, gfn, level, external_spt);
+
+	return ret;
+}
 /**
  * handle_removed_pt() - handle a page table removed from the TDP structure
  *
@@ -765,12 +778,20 @@ static u64 tdp_mmu_set_spte(struct kvm *kvm, int as_id, tdp_ptep_t sptep,
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
+			split_external_spt(kvm, gfn, old_spte, new_spte, level);
+		else
+			KVM_BUG_ON(1, kvm);
 	}
 
 	return old_spte;
-- 
2.43.2


