Return-Path: <kvm+bounces-44045-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CFF07A99F5E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:10:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DB585443075
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:10:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0C731B043E;
	Thu, 24 Apr 2025 03:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="n/uyED3j"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E801A8403;
	Thu, 24 Apr 2025 03:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464194; cv=none; b=f6jR8pLgsPNrRZapgqV2KO5GGTsZrsafEL1mFsV9hwgHDMueKITheW/fuGgx9mu4Uk5Y9gZgus2AjIXcJOlVV6EsFjcP6P1Ncbc5oFGs3AytiLcgHryAhejHxMpEKi13NP+38ktMklsH6WiXRCrVzIiiJi+Gr3SC4Kke1imjEOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464194; c=relaxed/simple;
	bh=qr8R2w6kZvkrXLX0gPUtharRm6O22EdtyjIo9EYurQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ywc89bWCL+iE9TJwvMkTzjdxDLzpLx1SW1L02mwA8/Fy40IT+Ml3P2reW2i3VlDilxJ7T0ASKDLK1MqTDGiViK9xWjAeT5VcA34qq+AgmHFz059n+LG4UUOXml2hW1jLcNy/HWEkljrPK5R4FivAg4U8AGDd6jTe1uW4e+QUJvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=n/uyED3j; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464193; x=1777000193;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qr8R2w6kZvkrXLX0gPUtharRm6O22EdtyjIo9EYurQA=;
  b=n/uyED3jjWGHCNs43O1qklrNLmK3KYCQcgzi63WpcKGmAmA95QZqC740
   yTQZw0giLY2nMnQsC4oHKPsRKys5EIFIj8oHCn5C98kuKeWhwgB5qYErX
   5/7qyPb0Y+zRI9E/I8G5jT+DlpTiGizAxuwEBjIIHO0M2F/rca8Y4gn2t
   BTfI8XsxF0L6edHHsdHZL/T02l8qe7QdZMtyoiKa/hFsQGc9M2FQFpT9O
   dpWNvmr020ijWDvoa3FMPOQmzbXgxnhh0U/bk5ojoPYWSgxTVs338Ne2D
   Ph4hQ7VcK3kPSV3E0r5jOCxZhOMmSS2trK4UFV+0us0bNZQda3UmpoNF3
   A==;
X-CSE-ConnectionGUID: YirhUrqbSmKxMO3m3/H+gA==
X-CSE-MsgGUID: mEtmqdrdRnqI2zXwDCmkrw==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="47094550"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="47094550"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:52 -0700
X-CSE-ConnectionGUID: W5a7VQJlS3qfZSigki88gA==
X-CSE-MsgGUID: yIWcFq/MTuOfr2a1U89ZEA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132332091"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:09:46 -0700
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
Subject: [RFC PATCH 15/21] KVM: TDX: Support huge page splitting with exclusive kvm->mmu_lock
Date: Thu, 24 Apr 2025 11:08:00 +0800
Message-ID: <20250424030800.452-1-yan.y.zhao@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

Implement the split_external_spt hook to support huge page splitting for
TDX when kvm->mmu_lock is held for writing.

Invoke tdh_mem_range_block(), tdh_mem_track(), kicking off vCPUs,
tdh_mem_page_demote() in sequence. Since kvm->mmu_lock is held for writing,
simply kick off vCPUs on tdx_operand_busy() to ensure the second SEAMCALL
invocation succeeds.

TDX module may return TDX_INTERRUPTED_RESTARTABLE when there is a pending
interrupt on the host side during tdh_mem_page_demote(). Retry indefinitely
on this error, as with exclusive kvm->mmu_lock the pending interrupt is for
host only.

[Yan: Split patch for exclusive mmu_lock only, handled busy error ]

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/main.c      |  1 +
 arch/x86/kvm/vmx/tdx.c       | 45 ++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx_errno.h |  1 +
 arch/x86/kvm/vmx/x86_ops.h   |  9 ++++++++
 4 files changed, 56 insertions(+)

diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index ae8540576821..16c0c31dd066 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -62,6 +62,7 @@ static __init int vt_hardware_setup(void)
 		vt_x86_ops.set_external_spte = tdx_sept_set_private_spte;
 		vt_x86_ops.free_external_spt = tdx_sept_free_private_spt;
 		vt_x86_ops.remove_external_spte = tdx_sept_remove_private_spte;
+		vt_x86_ops.split_external_spt = tdx_sept_split_private_spt;
 		vt_x86_ops.protected_apic_has_interrupt = tdx_protected_apic_has_interrupt;
 	}
 
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index dd63a634e633..4386e1a0323e 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1806,6 +1806,51 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	return tdx_reclaim_page(virt_to_page(private_spt), PG_LEVEL_4K);
 }
 
+static int tdx_spte_demote_private_spte(struct kvm *kvm, gfn_t gfn,
+					enum pg_level level, struct page *page)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 err, entry, level_state;
+
+	do {
+		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
+					  &entry, &level_state);
+	} while (err == TDX_INTERRUPTED_RESTARTABLE);
+
+	if (unlikely(tdx_operand_busy(err))) {
+		tdx_no_vcpus_enter_start(kvm);
+		err = tdh_mem_page_demote(&kvm_tdx->td, gpa, tdx_level, page,
+					  &entry, &level_state);
+		tdx_no_vcpus_enter_stop(kvm);
+	}
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MEM_PAGE_DEMOTE, err, entry, level_state);
+		return -EIO;
+	}
+	return 0;
+}
+
+int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			       void *private_spt)
+{
+	struct page *page = virt_to_page(private_spt);
+	int ret;
+
+	if (KVM_BUG_ON(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE || level != PG_LEVEL_2M, kvm))
+		return -EINVAL;
+
+	ret = tdx_sept_zap_private_spte(kvm, gfn, level, page);
+	if (ret <= 0)
+		return ret;
+
+	tdx_track(kvm);
+
+	return tdx_spte_demote_private_spte(kvm, gfn, level, page);
+}
+
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn)
 {
diff --git a/arch/x86/kvm/vmx/tdx_errno.h b/arch/x86/kvm/vmx/tdx_errno.h
index 6ff4672c4181..33589e7fa1e1 100644
--- a/arch/x86/kvm/vmx/tdx_errno.h
+++ b/arch/x86/kvm/vmx/tdx_errno.h
@@ -14,6 +14,7 @@
 #define TDX_NON_RECOVERABLE_TD_NON_ACCESSIBLE	0x6000000500000000ULL
 #define TDX_NON_RECOVERABLE_TD_WRONG_APIC_MODE	0x6000000700000000ULL
 #define TDX_INTERRUPTED_RESUMABLE		0x8000000300000000ULL
+#define TDX_INTERRUPTED_RESTARTABLE		0x8000000400000000ULL
 #define TDX_OPERAND_INVALID			0xC000010000000000ULL
 #define TDX_OPERAND_BUSY			0x8000020000000000ULL
 #define TDX_PREVIOUS_TLB_EPOCH_BUSY		0x8000020100000000ULL
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index 7c183da7c4d4..df7d4cd1436c 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -158,6 +158,8 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, kvm_pfn_t pfn);
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 				 enum pg_level level, kvm_pfn_t pfn);
+int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
+			       void *private_spt);
 
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
@@ -224,6 +226,13 @@ static inline int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	return -EOPNOTSUPP;
 }
 
+static inline int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
+					     enum pg_level level,
+					     void *private_spt)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
-- 
2.43.2


