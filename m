Return-Path: <kvm+bounces-34735-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ACA11A050D3
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 03:32:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E58E1685C6
	for <lists+kvm@lfdr.de>; Wed,  8 Jan 2025 02:32:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 749601AAA2C;
	Wed,  8 Jan 2025 02:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="eZJ9eokF"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E2291AA795;
	Wed,  8 Jan 2025 02:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303371; cv=none; b=fJOUw6CDmuzigWrMmW4bITb7KGCeNI+WjS8WzJndJ5/+Am/1zwx9Um/IIk78k1w3S+RqSx6WXO4EL/IUQou3OpkoZ+/xmPS0aEEf2/Q3451i5Yry9UN47/8FCljnjE6sMZpg6HRIu8t1JK9bwI6ooqv/xViTVb5qL5/SwYMoEGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303371; c=relaxed/simple;
	bh=wVHrkI8pTk7m0SmAt5vONTuphWS7jc5OHQuJjOSNwbI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n3Gicfd3uqYlHs8RtAe6XCj+P3SMfZJpDNvFj7GOoRwtYntwk3t5tW24M6VMuYViiuuHB6EKgYTpiDcHJfzb7FYyabf8xyyWygy2UR50dLDNDN5Jhwd6MM/qzkx/LVTX068CjqeKEIjwOaeC5LR78I19inz8mx2fyvbdK8CmPx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=eZJ9eokF; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736303371; x=1767839371;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=wVHrkI8pTk7m0SmAt5vONTuphWS7jc5OHQuJjOSNwbI=;
  b=eZJ9eokF5biqXp7Psuwftgn7SuymIPdWcuqlFBohXOjLabhNTMKUNSv+
   PLB/kSsK/MehXlbjN78ogLTrVCENKrsSGle+eDxyjKFOi86VOpha3IITv
   XMrXKUgSqeGzb8NAyiWR2j5HbD2rNABtI7jw9D6n9ZuypT/BpVvuEuJEj
   TaQH6dqi2joquG7J/O4yqVclyyu7guZ+1JlmX2qGvLd5yRlkxklSQU9EG
   glFvU26LIDVjOcjim4+0g1n2B3dHWBExdsDDG0EerC0qt9+pKPmjTllqz
   wGWwVnWy+kR8MDCkBA0mh6R+PsY6xU8gDQzqbL1oQshs3vpFEa5oTLMGH
   g==;
X-CSE-ConnectionGUID: QjECWk3wRImeSg9TQKpcTw==
X-CSE-MsgGUID: jFWvoXMSSamDsKGlI19vSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11308"; a="47010654"
X-IronPort-AV: E=Sophos;i="6.12,296,1728975600"; 
   d="scan'208";a="47010654"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jan 2025 18:29:30 -0800
X-CSE-ConnectionGUID: 0kj8MQWETA+EgGm5i13+zw==
X-CSE-MsgGUID: YyKlmcGyQiKuexj+KBRfVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="103793902"
Received: from yilunxu-optiplex-7050.sh.intel.com ([10.239.159.165])
  by orviesa008.jf.intel.com with ESMTP; 07 Jan 2025 18:29:25 -0800
From: Xu Yilun <yilun.xu@linux.intel.com>
To: kvm@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-media@vger.kernel.org,
	linaro-mm-sig@lists.linaro.org,
	sumit.semwal@linaro.org,
	christian.koenig@amd.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	alex.williamson@redhat.com,
	jgg@nvidia.com,
	vivek.kasireddy@intel.com,
	dan.j.williams@intel.com,
	aik@amd.com
Cc: yilun.xu@intel.com,
	yilun.xu@linux.intel.com,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	lukas@wunner.de,
	yan.y.zhao@intel.com,
	daniel.vetter@ffwll.ch,
	leon@kernel.org,
	baolu.lu@linux.intel.com,
	zhenzhong.duan@intel.com,
	tao1.su@intel.com
Subject: [RFC PATCH 12/12] KVM: TDX: Implement TDX specific private MMIO map/unmap for SEPT
Date: Tue,  7 Jan 2025 22:27:19 +0800
Message-Id: <20250107142719.179636-13-yilun.xu@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250107142719.179636-1-yilun.xu@linux.intel.com>
References: <20250107142719.179636-1-yilun.xu@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Implement TDX specific private MMIO map/unmap in existing TDP MMU hooks.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>

---
TODO: This patch is still based on the earlier kvm-coco-queue version
(v6.13-rc2). Will follow up the latest SEAMCALL wrapper change. [1]

[1] https://lore.kernel.org/all/20250101074959.412696-1-pbonzini@redhat.com/
---
 arch/x86/include/asm/tdx.h  |  3 ++
 arch/x86/kvm/vmx/tdx.c      | 57 +++++++++++++++++++++++++++++++++++--
 arch/x86/virt/vmx/tdx/tdx.c | 52 +++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  3 ++
 4 files changed, 113 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 01409a59224d..7d158bbf79f4 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -151,6 +151,9 @@ u64 tdh_mem_page_remove(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(u64 tdr);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hpa, u64 hkid);
+u64 tdh_mmio_map(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx);
+u64 tdh_mmio_block(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
+u64 tdh_mmio_unmap(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx);
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 69ef9c967fbf..9b43a2ee2203 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1576,6 +1576,29 @@ static int tdx_mem_page_aug(struct kvm *kvm, gfn_t gfn,
 	return 0;
 }
 
+static int tdx_mmio_map(struct kvm *kvm, gfn_t gfn,
+			enum pg_level level, kvm_pfn_t pfn)
+{
+	int tdx_level = pg_level_to_tdx_sept_level(level);
+	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	hpa_t hpa = pfn_to_hpa(pfn);
+	gpa_t gpa = gfn_to_gpa(gfn);
+	u64 entry, level_state;
+	u64 err;
+
+	err = tdh_mmio_map(kvm_tdx->tdr_pa, gpa, tdx_level, hpa,
+			   &entry, &level_state);
+	if (unlikely(err & TDX_OPERAND_BUSY))
+		return -EBUSY;
+
+	if (KVM_BUG_ON(err, kvm)) {
+		pr_tdx_error_2(TDH_MMIO_MAP, err, entry, level_state);
+		return -EIO;
+	}
+
+	return 0;
+}
+
 /*
  * KVM_TDX_INIT_MEM_REGION calls kvm_gmem_populate() to get guest pages and
  * tdx_gmem_post_populate() to premap page table pages into private EPT.
@@ -1610,6 +1633,9 @@ int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(level != PG_LEVEL_4K, kvm))
 		return -EINVAL;
 
+	if (kvm_is_mmio_pfn(pfn))
+		return tdx_mmio_map(kvm, gfn, level, pfn);
+
 	/*
 	 * Because guest_memfd doesn't support page migration with
 	 * a_ops->migrate_folio (yet), no callback is triggered for KVM on page
@@ -1647,6 +1673,20 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(kvm_tdx), kvm))
 		return -EINVAL;
 
+	if (kvm_is_mmio_pfn(pfn)) {
+		do {
+			err = tdh_mmio_unmap(kvm_tdx->tdr_pa, gpa, tdx_level,
+					     &entry, &level_state);
+		} while (unlikely(err == TDX_ERROR_SEPT_BUSY));
+
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error_2(TDH_MMIO_UNMAP, err, entry, level_state);
+			return -EIO;
+		}
+
+		return 0;
+	}
+
 	do {
 		/*
 		 * When zapping private page, write lock is held. So no race
@@ -1715,7 +1755,7 @@ int tdx_sept_link_private_spt(struct kvm *kvm, gfn_t gfn,
 }
 
 static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
-				     enum pg_level level)
+				     enum pg_level level, kvm_pfn_t pfn)
 {
 	int tdx_level = pg_level_to_tdx_sept_level(level);
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -1725,6 +1765,19 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	/* For now large page isn't supported yet. */
 	WARN_ON_ONCE(level != PG_LEVEL_4K);
 
+	if (kvm_is_mmio_pfn(pfn)) {
+		err = tdh_mmio_block(kvm_tdx->tdr_pa, gpa, tdx_level,
+				     &entry, &level_state);
+		if (unlikely(err == TDX_ERROR_SEPT_BUSY))
+			return -EAGAIN;
+		if (KVM_BUG_ON(err, kvm)) {
+			pr_tdx_error_2(TDH_MMIO_BLOCK, err, entry, level_state);
+			return -EIO;
+		}
+
+		return 0;
+	}
+
 	err = tdh_mem_range_block(kvm_tdx->tdr_pa, gpa, tdx_level, &entry, &level_state);
 	if (unlikely(err == TDX_ERROR_SEPT_BUSY))
 		return -EAGAIN;
@@ -1816,7 +1869,7 @@ int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (KVM_BUG_ON(!is_hkid_assigned(to_kvm_tdx(kvm)), kvm))
 		return -EINVAL;
 
-	ret = tdx_sept_zap_private_spte(kvm, gfn, level);
+	ret = tdx_sept_zap_private_spte(kvm, gfn, level, pfn);
 	if (ret)
 		return ret;
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 57195cf0d832..3b2109877a39 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1951,3 +1951,55 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hpa, u64 hkid)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+u64 tdh_mmio_map(u64 tdr, u64 gpa, u64 level, u64 hpa, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+		.r8 = hpa,
+	};
+	u64 ret;
+
+	ret = tdx_seamcall_sept(TDH_MMIO_MAP, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mmio_map);
+
+u64 tdh_mmio_block(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+	u64 ret;
+
+	ret = tdx_seamcall_sept(TDH_MMIO_BLOCK, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mmio_block);
+
+u64 tdh_mmio_unmap(u64 tdr, u64 gpa, u64 level, u64 *rcx, u64 *rdx)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdr,
+	};
+	u64 ret;
+
+	ret = tdx_seamcall_sept(TDH_MMIO_UNMAP, &args);
+
+	*rcx = args.rcx;
+	*rdx = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mmio_unmap);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 58d5754dcb4d..a83a90a043a5 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -49,6 +49,9 @@
 #define TDH_VP_WR			43
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_SYS_CONFIG			45
+#define TDH_MMIO_MAP			158
+#define TDH_MMIO_BLOCK			159
+#define TDH_MMIO_UNMAP			160
 
 /*
  * SEAMCALL leaf:
-- 
2.25.1


