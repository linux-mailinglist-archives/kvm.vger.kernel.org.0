Return-Path: <kvm+bounces-44050-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7CE9A99F69
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:12:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C92185A7CFD
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:11:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 068261ACEDF;
	Thu, 24 Apr 2025 03:11:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iNetuRKf"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8623B1993A3;
	Thu, 24 Apr 2025 03:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464267; cv=none; b=I+447rpcPrAmbOumRPINO4fDaCERWqLDJG9UtzyhuTfA1ufpxXVD1wp1ywXrEIqbfdiviTY4BBIOq3SMA9r51B9VZlJNOifUYhPaWim5Vms7qP2zkPriXviqx+kaEqmoLFBWv8CkiuQPewGD+U91ZgSXcuDR/yRMUuqWyGGiP1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464267; c=relaxed/simple;
	bh=KQ0IZorEd99CDzJ/21afqi23lH32j+k2CrdlE2GhN60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nK+l217FkXAABHDNuQv/bMLbK6m+br2L0ozSuqTLtWsm273MO1G21rtDUmtM1EYbp5EbNSKf7AKSHO1SiEHMdXT2nO4DdKhFhjgxlvx40z870deevU+mrG3UYGnfMO2davSqah7Giol78NoVhuU12VqcBAUAn6cJznubp2UiaZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iNetuRKf; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464265; x=1777000265;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=KQ0IZorEd99CDzJ/21afqi23lH32j+k2CrdlE2GhN60=;
  b=iNetuRKfmJHfU7GhMepS3/ruQxgoZZ1WmAUeXOG+DtnAvYryPihfBcj3
   chIcA8niZ7WUJM6vN7iuuWspzwByXwKABsoN0pBmCFhfi2K+felGqhfV/
   GANOSwD6QCgoWlGIuiM8tEHQf6oRo0na87Qg8Gl/WZiRBZJFlseKPY0cp
   zVPA6a/YGLsQqX5kX2EDggljwAla3ycN9tTwCQNATNWFBm/ie97rM3pO4
   /CoH986b7cXRVxl4oD1qboxIMwjO0C/oInGSP9sU7Qt6m4R3PPodQk186
   QZYuB9X1EZN5bzfmEdcNuR9GSucJGdEpUfJ27tz0Pe7vpBTqwtPEYt8gY
   Q==;
X-CSE-ConnectionGUID: 9jrgX/ecTWetDANwaT500A==
X-CSE-MsgGUID: LhLzoUnBR+CyWH3S1tkVDA==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="64491609"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="64491609"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:11:05 -0700
X-CSE-ConnectionGUID: g6vhGtK4Qk+rxzC5xAVa6g==
X-CSE-MsgGUID: FiSsbsygRha3ONBGu8KRgg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="136565616"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:10:59 -0700
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
Subject: [RFC PATCH 20/21] KVM: x86: Force a prefetch fault's max mapping level to 4KB for TDX
Date: Thu, 24 Apr 2025 11:09:13 +0800
Message-ID: <20250424030913.535-1-yan.y.zhao@intel.com>
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

Introduce a "prefetch" parameter to the private_max_mapping_level hook and
enforce the max mapping level of a prefetch fault for private memory to be
4KB. This is a preparation to enable the ignoring huge page splitting in
the fault path.

If a prefetch fault results in a 2MB huge leaf in the mirror page table,
there may not be a vCPU available to accept the corresponding 2MB huge leaf
in the S-EPT if the TD is not configured to receive #VE for page
acceptance. Consequently, if a vCPU accepts the page at 4KB level, it will
trigger an EPT violation to split the 2MB huge leaf generated by the
prefetch fault.

Since handling the BUSY error from SEAMCALLs for huge page splitting is
more comprehensive in the fault path, which is with kvm->mmu_lock held for
reading, force the max mapping level of a prefetch fault of private memory
to be 4KB to prevent potential splitting.

Since prefetch faults for private memory are uncommon after the TD's build
time, enforcing a 4KB mapping level is unlikely to cause any performance
degradation. The max mapping level is already set to 4KB during the TD's
build phase.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/include/asm/kvm_host.h | 3 ++-
 arch/x86/kvm/mmu/mmu.c          | 7 ++++---
 arch/x86/kvm/svm/sev.c          | 3 ++-
 arch/x86/kvm/svm/svm.h          | 5 +++--
 arch/x86/kvm/vmx/main.c         | 5 +++--
 arch/x86/kvm/vmx/tdx.c          | 5 +++--
 arch/x86/kvm/vmx/x86_ops.h      | 4 ++--
 7 files changed, 19 insertions(+), 13 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6962a8a424ef..5167458742bf 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -1900,7 +1900,8 @@ struct kvm_x86_ops {
 	void *(*alloc_apic_backing_page)(struct kvm_vcpu *vcpu);
 	int (*gmem_prepare)(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 	void (*gmem_invalidate)(kvm_pfn_t start, kvm_pfn_t end);
-	int (*private_max_mapping_level)(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn);
+	int (*private_max_mapping_level)(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn,
+					 bool prefetch);
 };
 
 struct kvm_x86_nested_ops {
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 1a34e43bd349..94a557e010d3 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -4488,7 +4488,7 @@ static inline u8 kvm_max_level_for_order(int order)
 }
 
 static u8 kvm_max_private_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn,
-					u8 max_level, int gmem_order)
+					u8 max_level, int gmem_order, bool prefetch)
 {
 	u8 req_max_level;
 
@@ -4499,7 +4499,7 @@ static u8 kvm_max_private_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gf
 	if (max_level == PG_LEVEL_4K)
 		return PG_LEVEL_4K;
 
-	req_max_level = kvm_x86_call(private_max_mapping_level)(vcpu, pfn, gfn);
+	req_max_level = kvm_x86_call(private_max_mapping_level)(vcpu, pfn, gfn, prefetch);
 	if (req_max_level)
 		max_level = min(max_level, req_max_level);
 
@@ -4532,7 +4532,8 @@ static int kvm_mmu_faultin_pfn_private(struct kvm_vcpu *vcpu,
 
 	fault->map_writable = !(fault->slot->flags & KVM_MEM_READONLY);
 	fault->max_level = kvm_max_private_mapping_level(vcpu, fault->pfn, fault->gfn,
-							 fault->max_level, max_order);
+							 fault->max_level, max_order,
+							 fault->prefetch);
 
 	return RET_PF_CONTINUE;
 }
diff --git a/arch/x86/kvm/svm/sev.c b/arch/x86/kvm/svm/sev.c
index dc6cdf9fa1ba..7a9c44ad5b91 100644
--- a/arch/x86/kvm/svm/sev.c
+++ b/arch/x86/kvm/svm/sev.c
@@ -4910,7 +4910,8 @@ void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end)
 	}
 }
 
-int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
+int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn,
+				  bool prefetch)
 {
 	int level, rc;
 	bool assigned;
diff --git a/arch/x86/kvm/svm/svm.h b/arch/x86/kvm/svm/svm.h
index 1a9738b6ae37..272a8404e1c0 100644
--- a/arch/x86/kvm/svm/svm.h
+++ b/arch/x86/kvm/svm/svm.h
@@ -782,7 +782,7 @@ void sev_handle_rmp_fault(struct kvm_vcpu *vcpu, gpa_t gpa, u64 error_code);
 void sev_snp_init_protected_guest_state(struct kvm_vcpu *vcpu);
 int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, int max_order);
 void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end);
-int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn);
+int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn, bool prefetch);
 #else
 static inline struct page *snp_safe_alloc_page_node(int node, gfp_t gfp)
 {
@@ -809,7 +809,8 @@ static inline int sev_gmem_prepare(struct kvm *kvm, kvm_pfn_t pfn, gfn_t gfn, in
 	return 0;
 }
 static inline void sev_gmem_invalidate(kvm_pfn_t start, kvm_pfn_t end) {}
-static inline int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
+static inline int sev_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
+						gfn_t gfn, bool prefetch)
 {
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/main.c b/arch/x86/kvm/vmx/main.c
index 16c0c31dd066..82689ad8bc18 100644
--- a/arch/x86/kvm/vmx/main.c
+++ b/arch/x86/kvm/vmx/main.c
@@ -881,10 +881,11 @@ static int vt_vcpu_mem_enc_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return tdx_vcpu_ioctl(vcpu, argp);
 }
 
-static int vt_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
+static int vt_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
+					     gfn_t gfn, bool prefetch)
 {
 	if (is_td(vcpu->kvm))
-		return tdx_gmem_private_max_mapping_level(vcpu, pfn, gfn);
+		return tdx_gmem_private_max_mapping_level(vcpu, pfn, gfn, prefetch);
 
 	return 0;
 }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4386e1a0323e..e24d1cbcc762 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -3332,11 +3332,12 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 	return ret;
 }
 
-int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn)
+int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn,
+				       gfn_t gfn, bool prefetch)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
 
-	if (unlikely(to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE))
+	if (unlikely((to_kvm_tdx(vcpu->kvm)->state != TD_STATE_RUNNABLE) || prefetch))
 		return PG_LEVEL_4K;
 
 	if (gfn >= tdx->violation_gfn_start && gfn < tdx->violation_gfn_end)
diff --git a/arch/x86/kvm/vmx/x86_ops.h b/arch/x86/kvm/vmx/x86_ops.h
index df7d4cd1436c..0619e9390e5d 100644
--- a/arch/x86/kvm/vmx/x86_ops.h
+++ b/arch/x86/kvm/vmx/x86_ops.h
@@ -164,7 +164,7 @@ int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn, enum pg_level level,
 void tdx_flush_tlb_current(struct kvm_vcpu *vcpu);
 void tdx_flush_tlb_all(struct kvm_vcpu *vcpu);
 void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level);
-int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn);
+int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn, bool prefetch);
 #else
 static inline void tdx_disable_virtualization_cpu(void) {}
 static inline int tdx_vm_init(struct kvm *kvm) { return -EOPNOTSUPP; }
@@ -236,7 +236,7 @@ static inline int tdx_sept_split_private_spt(struct kvm *kvm, gfn_t gfn,
 static inline void tdx_flush_tlb_current(struct kvm_vcpu *vcpu) {}
 static inline void tdx_flush_tlb_all(struct kvm_vcpu *vcpu) {}
 static inline void tdx_load_mmu_pgd(struct kvm_vcpu *vcpu, hpa_t root_hpa, int root_level) {}
-static inline int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn) { return 0; }
+static inline int tdx_gmem_private_max_mapping_level(struct kvm_vcpu *vcpu, kvm_pfn_t pfn, gfn_t gfn, bool prefetch) { return 0; }
 #endif
 
 #endif /* __KVM_X86_VMX_X86_OPS_H */
-- 
2.43.2


