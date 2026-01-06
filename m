Return-Path: <kvm+bounces-67129-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id C6333CF7CC3
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:31:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 1100730E82D4
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:25:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AAE693370F4;
	Tue,  6 Jan 2026 10:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="OxzgK6lX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5714F336ECF;
	Tue,  6 Jan 2026 10:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695150; cv=none; b=aujKg3VSnIgnqBPO0vMpzwVw27stOnQw3VTVZOv8zfKXoriEvK6Gn8CCv9Bc3Nc5Xrjc8aLG06EGErmuCYuzFwvp9mabL3efAKvYlVsAkSeMcSjWWxb+WeFkketg09Pjvuonkl7DWow7S9wiwuNk5hMcFHEeI8QrQRGuyK9dWxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695150; c=relaxed/simple;
	bh=qwwpptGS42i0X5HRafBSLm3iF6+2BtZgb4c3EI3htcs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDC5u2/v4gZAjcMS0VQRiBFB6NcCN2G7T6dJl7I0Pa8zf6z7xCjhUe3pksaoDg3VM2RaYsQNoiGAaA8uXdjMVmS/SDa0tOKIfaKSXFPtC/nFi5a6j0lc0VP6SnFggcU/10Y0+aAVXBPsBCVenS8D38TFsdWUnjCCqLh28bL6sys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=OxzgK6lX; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695149; x=1799231149;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qwwpptGS42i0X5HRafBSLm3iF6+2BtZgb4c3EI3htcs=;
  b=OxzgK6lXUN5wLUwGOkyubGO1HtBdeWhrbfL4K0YBYNOZDb0sUWuhOYLn
   3NuZBxYbKj4/X66uzbeRHMlTcyfjF8oB+2wirt3I4b7wcdYj3+g1bFBSL
   hI6pnrV5K34jFjuDJYL6nHr3RyUzSbVzjS6QVogwzz00WPN/yM+oIQ0cb
   DAwV2JLFHMcjRd7Vpw9Pj/Tl+wkpxsjKX++2MLPEmRt5rq8fTMIbJ+pQs
   Dx8pQytu995ZhxGkIR3/6Q7EK/ZZJ9dJUrvLwI1jsgu/OIN1tI8IcL12L
   61rQzgTq2kzTIjNoAcM2XL09WRgFtifLatAtaK9SbUCM4RoiQpxq8JmE9
   w==;
X-CSE-ConnectionGUID: ZWVGWH7RTsKWgKi6ybVAKA==
X-CSE-MsgGUID: pA/FjI8xTpa/FG1rbm/cbQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72689752"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72689752"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:49 -0800
X-CSE-ConnectionGUID: vttwPh0gQLuiYzZAfynL2w==
X-CSE-MsgGUID: 4RoS58UBRvOnrxG9tFIIkg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202645207"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:43 -0800
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
Subject: [PATCH v3 20/24] KVM: TDX: Implement per-VM external cache for splitting in TDX
Date: Tue,  6 Jan 2026 18:23:45 +0800
Message-ID: <20260106102345.25261-1-yan.y.zhao@intel.com>
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

Implement the KVM x86 ops for per-VM external cache for splitting the
external page table in TDX.

Since the per-VM external cache for splitting the external page table is
intended to be invoked outside of vCPU threads, i.e., when the per-vCPU
external_fault_cache is not available, introduce a spinlock
prealloc_split_cache_lock in TDX to protect pages enqueuing/dequeuing
operations for the per-VM external split cache.

Cache topup in tdx_topup_vm_split_cache() manages page enqueuing with the
help of prealloc_split_cache_lock.

Cache dequeuing will be implemented in tdx_sept_split_private_spte() in
later patches, which will also hold prealloc_split_cache_lock.

Checking the need of topup in tdx_need_topup_vm_split_cache() does not hold
prealloc_split_cache_lock internally. When tdx_need_topup_vm_split_cache()
is invoked under write mmu_lock, there's no need for further acquiring
prealloc_split_cache_lock; when tdx_need_topup_vm_split_cache() is invoked
under read mmu_lock, it needs to be checked again after acquiring
prealloc_split_cache_lock for cache dequeuing.

Cache free does not hold prealloc_split_cache_lock because it's intended to
be called when there's no contention.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- new patch corresponds to DPAMT v4.
---
 arch/x86/kvm/vmx/tdx.c | 61 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86/kvm/vmx/tdx.h |  5 ++++
 2 files changed, 66 insertions(+)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index c1dc1aaae49d..40cca273d480 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -671,6 +671,9 @@ int tdx_vm_init(struct kvm *kvm)
 
 	kvm_tdx->state = TD_STATE_UNINITIALIZED;
 
+	INIT_LIST_HEAD(&kvm_tdx->prealloc_split_cache.page_list);
+	spin_lock_init(&kvm_tdx->prealloc_split_cache_lock);
+
 	return 0;
 }
 
@@ -1680,6 +1683,61 @@ static void tdx_free_external_fault_cache(struct kvm_vcpu *vcpu)
 		__free_page(page);
 }
 
+/*
+ * Need to prepare at least 2 pairs of PAMT pages (i.e., 4 PAMT pages) for
+ * splitting a S-EPT PG_LEVEL_2M mapping when Dynamic PAMT is enabled:
+ * - 1 pair for the new 4KB S-EPT page for splitting, which may be dequeued in
+ *   tdx_sept_split_private_spte() when there are no installed PAMT pages for
+ *   the 2MB physical range of the S-EPT page.
+ * - 1 pair for demoting guest private memory from 2MB to 4KB, which will be
+ *   dequeued in tdh_mem_page_demote().
+ */
+static int tdx_min_split_cache_sz(struct kvm *kvm, int level)
+{
+	KVM_BUG_ON(level != PG_LEVEL_2M, kvm);
+
+	if (!tdx_supports_dynamic_pamt(tdx_sysinfo))
+		return 0;
+
+	return tdx_dpamt_entry_pages() * 2;
+}
+
+static int tdx_topup_vm_split_cache(struct kvm *kvm, enum pg_level level)
+{
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct tdx_prealloc *prealloc = &kvm_tdx->prealloc_split_cache;
+	int cnt = tdx_min_split_cache_sz(kvm, level);
+
+	while (READ_ONCE(prealloc->cnt) < cnt) {
+		struct page *page = alloc_page(GFP_KERNEL);
+
+		if (!page)
+			return -ENOMEM;
+
+		spin_lock(&kvm_tdx->prealloc_split_cache_lock);
+		list_add(&page->lru, &prealloc->page_list);
+		prealloc->cnt++;
+		spin_unlock(&kvm_tdx->prealloc_split_cache_lock);
+	}
+
+	return 0;
+}
+
+static bool tdx_need_topup_vm_split_cache(struct kvm *kvm, enum pg_level level)
+{
+	struct tdx_prealloc *prealloc = &to_kvm_tdx(kvm)->prealloc_split_cache;
+
+	return prealloc->cnt < tdx_min_split_cache_sz(kvm, level);
+}
+
+static void tdx_free_vm_split_cache(struct kvm *kvm)
+{
+	struct page *page;
+
+	while ((page = get_tdx_prealloc_page(&to_kvm_tdx(kvm)->prealloc_split_cache)))
+		__free_page(page);
+}
+
 static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 			    enum pg_level level, kvm_pfn_t pfn)
 {
@@ -3804,4 +3862,7 @@ void __init tdx_hardware_setup(void)
 	vt_x86_ops.alloc_external_fault_cache = tdx_alloc_external_fault_cache;
 	vt_x86_ops.topup_external_fault_cache = tdx_topup_external_fault_cache;
 	vt_x86_ops.free_external_fault_cache = tdx_free_external_fault_cache;
+	vt_x86_ops.topup_external_per_vm_split_cache = tdx_topup_vm_split_cache;
+	vt_x86_ops.need_topup_external_per_vm_split_cache = tdx_need_topup_vm_split_cache;
+	vt_x86_ops.free_external_per_vm_split_cache = tdx_free_vm_split_cache;
 }
diff --git a/arch/x86/kvm/vmx/tdx.h b/arch/x86/kvm/vmx/tdx.h
index 43dd295b7fd6..034e3ddfb679 100644
--- a/arch/x86/kvm/vmx/tdx.h
+++ b/arch/x86/kvm/vmx/tdx.h
@@ -48,6 +48,11 @@ struct kvm_tdx {
 	 * Set/unset is protected with kvm->mmu_lock.
 	 */
 	bool wait_for_sept_zap;
+
+	/* The per-VM cache for splitting S-EPT */
+	struct tdx_prealloc prealloc_split_cache;
+	/* Protect page enqueuing/dequeuing in prealloc_split_cache */
+	spinlock_t prealloc_split_cache_lock;
 };
 
 /* TDX module vCPU states */
-- 
2.43.2


