Return-Path: <kvm+bounces-48762-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 40138AD2691
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:16:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 37E853B1637
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:16:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7322225402;
	Mon,  9 Jun 2025 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="CS3BF/T4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2427221D594;
	Mon,  9 Jun 2025 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496444; cv=none; b=iYCkGRVjSvtLr2rtAe6eQ0I0xAOsqaxRQzpBRefBc0bxbImP5KNHleXaqo11tyyLAx894+xpcRaFyj35eKrbP52OumVak9BV4oc0Oq4Lmff84gRjsrdOIlHeHPfEw6jRiVG6FpFaJw6XIHSnFoKpgcYDRNb1IoV5Vz7U/mTN1fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496444; c=relaxed/simple;
	bh=aauiztrJkeorvpMvNPHFkfjpUArGlWOFlPdcvLg8G64=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aGw8F7F1AeodkwQCj+q8f6bK7Mr/dhpfcqiKouc/j5odHzVk2AYkjlhSW/iRYda9clk5o+93OZgo8Xf+c8mzlRy/uRDio0H0NTvoMV1lY4aEkto6BsqdOh83yCgr6YIgghoJWVI04ONT5xOTK+CI50LOjiPRdOGIzXoCdpJBi5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=CS3BF/T4; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496442; x=1781032442;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aauiztrJkeorvpMvNPHFkfjpUArGlWOFlPdcvLg8G64=;
  b=CS3BF/T4enq+dt6H+1r1nl0tX8w6adZ03VwPJZrayEh6G8tiKUnhs66x
   ZIkdKp2Wq7x31aVg/oHX7i0QmFVlLqmw/jY5S3hbYyksJwn4bU2Rg8Ac2
   2jOzALt4tosG1TKASarJtI55Rn2WvNvW3gbAlurd8pKPgj5C1/vRCmkUF
   TOe7wnFhDWl2ltAN0R/gZqiwCEr5RMvkfCmo1vI0wIRQLcsN0xj049KdI
   svifWguTdB3pbybS1FPM1Xw6pEK7M6W+N0rM0vqqJo+0MX8MKccV0tg0P
   Xz39ESjooTDHSaJDuagoK0o8VrADgCS8MCc6drefcLd0ZMBrZcMbrVDsv
   g==;
X-CSE-ConnectionGUID: 8gcHbl93Rq66r0BN50v7fg==
X-CSE-MsgGUID: K5w/QFYwQ5239vjfyikCPA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681808"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681808"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:14:00 -0700
X-CSE-ConnectionGUID: vy5boMulSEeNzGdk2TDGRA==
X-CSE-MsgGUID: ha8OKAo1SWyFNWZapjfE5A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174195"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 510B4A0C; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 07/12] KVM: TDX: Preallocate PAMT pages to be used in page fault path
Date: Mon,  9 Jun 2025 22:13:35 +0300
Message-ID: <20250609191340.2051741-8-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Preallocate a page to be used in the link_external_spt() and
set_external_spte() paths.

In the worst-case scenario, handling a page fault might require a
tdx_nr_pamt_pages() pages for each page table level.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/kvm_host.h | 2 ++
 arch/x86/include/asm/tdx.h      | 2 ++
 arch/x86/kvm/mmu/mmu.c          | 7 +++++++
 arch/x86/virt/vmx/tdx/tdx.c     | 3 ++-
 4 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 330cdcbed1a6..02dbbf848182 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -849,6 +849,8 @@ struct kvm_vcpu_arch {
 	 */
 	struct kvm_mmu_memory_cache mmu_external_spt_cache;
 
+	struct kvm_mmu_memory_cache pamt_page_cache;
+
 	/*
 	 * QEMU userspace and the guest each have their own FPU state.
 	 * In vcpu_run, we switch between the user and guest FPU contexts.
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index d9a77147412f..47092eb13eb3 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -115,6 +115,7 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+int tdx_nr_pamt_pages(void);
 struct page *tdx_alloc_page(void);
 void tdx_free_page(struct page *page);
 
@@ -188,6 +189,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
+static inline int tdx_nr_pamt_pages(void) { return 0; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index cbc84c6abc2e..d99bb27b5b01 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -616,6 +616,12 @@ static int mmu_topup_memory_caches(struct kvm_vcpu *vcpu, bool maybe_indirect)
 		if (r)
 			return r;
 	}
+
+	r = kvm_mmu_topup_memory_cache(&vcpu->arch.pamt_page_cache,
+				       tdx_nr_pamt_pages() * PT64_ROOT_MAX_LEVEL);
+	if (r)
+		return r;
+
 	return kvm_mmu_topup_memory_cache(&vcpu->arch.mmu_page_header_cache,
 					  PT64_ROOT_MAX_LEVEL);
 }
@@ -626,6 +632,7 @@ static void mmu_free_memory_caches(struct kvm_vcpu *vcpu)
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadow_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_shadowed_info_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_external_spt_cache);
+	kvm_mmu_free_memory_cache(&vcpu->arch.pamt_page_cache);
 	kvm_mmu_free_memory_cache(&vcpu->arch.mmu_page_header_cache);
 }
 
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c514c60e8c8d..4f9eaba4af4a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2001,13 +2001,14 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
 
-static int tdx_nr_pamt_pages(void)
+int tdx_nr_pamt_pages(void)
 {
 	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
 		return 0;
 
 	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
 }
+EXPORT_SYMBOL_GPL(tdx_nr_pamt_pages);
 
 static u64 tdh_phymem_pamt_add(unsigned long hpa,
 			       struct list_head *pamt_pages)
-- 
2.47.2


