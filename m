Return-Path: <kvm+bounces-44034-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 46396A99F3F
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:07:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7DBB544047E
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:07:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D46031A9B23;
	Thu, 24 Apr 2025 03:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="RuJ+Dhvr"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539AE1A9B4C;
	Thu, 24 Apr 2025 03:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464016; cv=none; b=Iy6m7cslFC7J6N/Jax9HiE7p1ZY9Ddx+fnMdYoFGJ6TqiD2oXvX/zFOGNIeTyh7nKXUj9ukQKcFRLRvb248iE9N4EvdtDdfYEWDoNi9VnAAwhmNhKfush6L5gngS9MW9IoqSRIileJ9jOGaAcqOHkUcbkSmSAVYVMafmpw2y3AU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464016; c=relaxed/simple;
	bh=zUoEGTV7CtbON5kzif0B6VFvh4REdWFltvHUnWkDjoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXvk/R3hPcBOWQlPlsDAZclIBY9iX1uGnGTGmx7bz65EeUP7IdaLGZSwe7WgNk8UL0Ye1pwZkkNC760VZm0goquElJxU5wStaD5ora4JuAKExFArk8yVS0yR/NWQXKlcnFTdcvy7wZvtgI1d/A1cff+ZU0NP5IL3LCMkGWAqnCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=RuJ+Dhvr; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464014; x=1777000014;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zUoEGTV7CtbON5kzif0B6VFvh4REdWFltvHUnWkDjoQ=;
  b=RuJ+DhvrSSnTKA4Lof6rcsAv2Xczr2ORvb0A5m4FU5NLBDju/Ve/MaTy
   PwGQu32TeORlVxbjZ7jMTKJTNLF9NVKsqxDzcVNzvefC9cL8GvKrSSP5V
   i6Ob4GYdceufEukcKsK05F511e3S9MJ0Ri/kp/sZLeQQjcZZigxLNoJ+S
   i88e8I9cYXQJfkcVZoRKjDc9p2OvjcrqhRSiHn2j/BjzmdSVDoBFxNlXG
   VFD0pTcJHHcGWcPQuMccT4/XiOc01d4yw9oVgqzwQX+uOrloShqUUCChd
   c7HVEQcwrQjva3ZhehN3TpomOkwWzHPOS+utiPhKOcxl8uT9omDf6wWnG
   A==;
X-CSE-ConnectionGUID: ns3j+rD4RlSwiIxC2gAkgQ==
X-CSE-MsgGUID: qX7l1IauRC+62l39RSFcvQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="49744063"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="49744063"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:53 -0700
X-CSE-ConnectionGUID: H3QIfJ8yRE2Qx4Mk+5X37Q==
X-CSE-MsgGUID: uNEBgIpMQridtUVyLe6U5w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="132374405"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:06:47 -0700
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
Subject: [RFC PATCH 04/21] KVM: TDX: Enforce 4KB mapping level during TD build Time
Date: Thu, 24 Apr 2025 11:05:00 +0800
Message-ID: <20250424030500.32720-1-yan.y.zhao@intel.com>
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

During the TD build phase (i.e., before the TD becomes RUNNABLE), enforce a
4KB mapping level both in the S-EPT managed by the TDX module and the
mirror page table managed by KVM.

During this phase, TD's memory is added via tdh_mem_page_add(), which only
accepts 4KB granularity. Therefore, return PG_LEVEL_4K in TDX's
.private_max_mapping_level hook to ensure KVM maps at the 4KB level in the
mirror page table. Meanwhile, iterate over each 4KB page of a large gmem
backend page in tdx_gmem_post_populate() and invoke tdh_mem_page_add() to
map at the 4KB level in the S-EPT.

Still allow huge pages in gmem backend during TD build time. Based on [1],
which gmem series allows 2MB TPH and non-in-place conversion, pass in
region.nr_pages to kvm_gmem_populate() in tdx_vcpu_init_mem_region(). This
enables kvm_gmem_populate() to allocate huge pages from the gmem backend
when the remaining nr_pages, GFN alignment, and page private/shared
attribute permit.  KVM is then able to promote the initial 4K mapping to
huge after TD is RUNNABLE.

Disallow any private huge pages during TD build time. Use BUG_ON() in
tdx_mem_page_record_premap_cnt() and tdx_is_sept_zap_err_due_to_premap() to
assert the mapping level is 4KB.

Opportunistically, remove unused parameters in
tdx_mem_page_record_premap_cnt().

Link: https://lore.kernel.org/all/20241212063635.712877-1-michael.roth@amd.com [1]
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 45 ++++++++++++++++++++++++++++--------------
 1 file changed, 30 insertions(+), 15 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 98cde20f14da..03885cb2869b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1530,14 +1530,16 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
  * The counter has to be zero on KVM_TDX_FINALIZE_VM, to ensure that there
  * are no half-initialized shared EPT pages.
  */
-static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, gfn_t gfn,
-					  enum pg_level level, kvm_pfn_t pfn)
+static int tdx_mem_page_record_premap_cnt(struct kvm *kvm, enum pg_level level)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 
 	if (KVM_BUG_ON(kvm->arch.pre_fault_allowed, kvm))
 		return -EINVAL;
 
+	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
+		return -EINVAL;
+
 	/* nr_premapped will be decreased when tdh_mem_page_add() is called. */
 	atomic64_inc(&kvm_tdx->nr_premapped);
 	return 0;
@@ -1571,7 +1573,7 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (likely(kvm_tdx->state == TD_STATE_RUNNABLE))
 		return tdx_mem_page_aug(kvm, gfn, level, page);
 
-	return tdx_mem_page_record_premap_cnt(kvm, gfn, level, pfn);
+	return tdx_mem_page_record_premap_cnt(kvm, level);
 }
 
 static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
@@ -1666,7 +1668,7 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 static int tdx_is_sept_zap_err_due_to_premap(struct kvm_tdx *kvm_tdx, u64 err,
 					     u64 entry, int level)
 {
-	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE)
+	if (!err || kvm_tdx->state == TD_STATE_RUNNABLE || level > PG_LEVEL_4K)
 		return false;
 
 	if (err != (TDX_EPT_ENTRY_STATE_INCORRECT | TDX_OPERAND_ID_RCX))
@@ -3052,8 +3054,8 @@ struct tdx_gmem_post_populate_arg {
 	__u32 flags;
 };
 
-static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
-				  void __user *src, int order, void *_arg)
+static int tdx_gmem_post_populate_4k(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				     void __user *src, void *_arg)
 {
 	u64 error_code = PFERR_GUEST_FINAL_MASK | PFERR_PRIVATE_ACCESS;
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -3120,6 +3122,21 @@ static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
 	return ret;
 }
 
+static int tdx_gmem_post_populate(struct kvm *kvm, gfn_t gfn, kvm_pfn_t pfn,
+				  void __user *src, int order, void *_arg)
+{
+	unsigned long i, npages = 1 << order;
+	int ret;
+
+	for (i = 0; i < npages; i++) {
+		ret = tdx_gmem_post_populate_4k(kvm, gfn + i, pfn + i,
+						src + i * PAGE_SIZE, _arg);
+		if (ret)
+			return ret;
+	}
+	return 0;
+}
+
 static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *cmd)
 {
 	struct vcpu_tdx *tdx = to_tdx(vcpu);
@@ -3166,20 +3183,15 @@ static int tdx_vcpu_init_mem_region(struct kvm_vcpu *vcpu, struct kvm_tdx_cmd *c
 		};
 		gmem_ret = kvm_gmem_populate(kvm, gpa_to_gfn(region.gpa),
 					     u64_to_user_ptr(region.source_addr),
-					     1, tdx_gmem_post_populate, &arg);
+					     region.nr_pages, tdx_gmem_post_populate, &arg);
 		if (gmem_ret < 0) {
 			ret = gmem_ret;
 			break;
 		}
 
-		if (gmem_ret != 1) {
-			ret = -EIO;
-			break;
-		}
-
-		region.source_addr += PAGE_SIZE;
-		region.gpa += PAGE_SIZE;
-		region.nr_pages--;
+		region.source_addr += PAGE_SIZE * gmem_ret;
+		region.gpa += PAGE_SIZE * gmem_ret;
+		region.nr_pages -= gmem_ret;
 
 		cond_resched();
 	}
@@ -3224,6 +3236,9 @@ int tdx_vcpu_ioctl(struct kvm_vcpu *vcpu, void __user *argp)
 
 int tdx_gmem_private_max_mapping_level(struct kvm *kvm, kvm_pfn_t pfn)
 {
+	if (unlikely(to_kvm_tdx(kvm)->state != TD_STATE_RUNNABLE))
+		return PG_LEVEL_4K;
+
 	return PG_LEVEL_4K;
 }
 
-- 
2.43.2


