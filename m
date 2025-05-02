Return-Path: <kvm+bounces-45220-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3212CAA72E8
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7359F1700DF
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:09:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 01C81255E2A;
	Fri,  2 May 2025 13:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZV6fTgoc"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81B36254876;
	Fri,  2 May 2025 13:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191324; cv=none; b=lF0ABKiZbP8MJfFphSU7X7xTtlX5eNsCimBc8KSDjlPkc/QsBuVigCwDpJa8FXXhEKWtOcSkqER24pP24u112JyP0Ucm8vn0n5RmNciWLPwWTGpS55W5dk13d96vQYkBAflY2VMQIhDSgiIezaeOjT8n8X/Ra9ty+XDyCEXwiDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191324; c=relaxed/simple;
	bh=Mxg5gZR5NtpEeMPs/+XTRuULzQ14JvabH1BZykostAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SrSn4d7vNFKjyuGLKq27MCcMRfqAhPhduSxFdsumtch1M/1gbjpW0G7/+KCNOfCoBGzb09W24AM0KL132JE8LsI82ybWY0TvQ334bjSR2li74uRyaVoaZEJnM1oGCWU/97ChvGzfxq/tLR7N2Y9zofBiHENSlTPfpubdauo1NRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZV6fTgoc; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191322; x=1777727322;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Mxg5gZR5NtpEeMPs/+XTRuULzQ14JvabH1BZykostAY=;
  b=ZV6fTgocLjTo74Yq+G7gyPNOB/s8awKiJTqiyT2OqquHRlCkHnOHbuTx
   BUtdxSTxhgCG31krLS8aOLFHpmVNuu1RfkYWTKKUFePHBggCXgMHJLlof
   t/3qcGrIOrwsatuPeIwNvxXfwCwlApYzl9g35zsLEeKsbGhJ0+F+ZsS0Y
   XRuA8q55SLf9mc6mpvUCDg9rOojCvLjeuhOY/OGwF9/r2+5gGv1vkvdAj
   O1LHZMCrCKUxaaC5znfM/r0CW9AllkiGAh1/bX+f0qF9Gi/Hz8oFfbAiF
   kgL1FqCipUSzM2YjysPHwp8Plqr+iGe73iq6Umnohnhf5Xl+kZKWq4D2W
   Q==;
X-CSE-ConnectionGUID: lK0rZVdHT1Wt0o08ZGtiTA==
X-CSE-MsgGUID: M3KAOI5hRjOTOI3dzHybSA==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="48012952"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="48012952"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:40 -0700
X-CSE-ConnectionGUID: bKCrRft4Td2TwOs2mpn5LQ==
X-CSE-MsgGUID: G6KG1unLTdKZdFp4ECvWwg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="157871062"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa002.fm.intel.com with ESMTP; 02 May 2025 06:08:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 2A6241AE; Fri, 02 May 2025 16:08:36 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [RFC, PATCH 03/12] x86/virt/tdx: Add wrappers for TDH.PHYMEM.PAMT.ADD/REMOVE
Date: Fri,  2 May 2025 16:08:19 +0300
Message-ID: <20250502130828.4071412-4-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
References: <20250502130828.4071412-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On a system with Dynamic PAMT enabled, the kernel must allocate memory
for PAMT_4K as needed and reclaim it when it is no longer in use.

The TDX module requires space to store 16 bytes of metadata per page or
8k for every 2M range of physical memory. The TDX module takes this 8k
of memory as a pair of 4k pages. These pages do not need to be contiguous.

The number of pages needed to cover 2M range can grow if size of PAMT
entry increases. tdx_nr_pamt_pages() reports needed number of pages.

TDH.PHYMEM.PAMT.ADD populates PAMT_4K for a given HPA. The kernel must
provide addresses for two pages, covering a 2M range starting from HPA.

TDH.PHYMEM.PAMT.REMOVE withdraws PAMT_4K memory for a given HPA,
returning the addresses of the pages used for PAMT_4K before the call.

Add wrappers for these SEAMCALLs.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/tdx.h  |  9 ++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 45 +++++++++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  2 ++
 3 files changed, 56 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 9701876d4e16..a134cf3ecd17 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -130,6 +130,11 @@ static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
 	return false; /* To be enabled when kernel is ready */
 }
 
+static inline int tdx_nr_pamt_pages(const struct tdx_sys_info *sysinfo)
+{
+	return sysinfo->tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
+}
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
@@ -197,6 +202,9 @@ u64 tdh_mem_page_remove(struct tdx_td *td, u64 gpa, u64 level, u64 *ext_err1, u6
 u64 tdh_phymem_cache_wb(bool resume);
 u64 tdh_phymem_page_wbinvd_tdr(struct tdx_td *td);
 u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page);
+u64 tdh_phymem_pamt_add(unsigned long hpa, struct list_head *pamt_pages);
+u64 tdh_phymem_pamt_remove(unsigned long hpa, struct list_head *pamt_pages);
+
 #else
 static inline void tdx_init(void) { }
 static inline int tdx_cpu_enable(void) { return -ENODEV; }
@@ -204,6 +212,7 @@ static inline int tdx_enable(void)  { return -ENODEV; }
 static inline u32 tdx_get_nr_guest_keyids(void) { return 0; }
 static inline const char *tdx_dump_mce_info(struct mce *m) { return NULL; }
 static inline const struct tdx_sys_info *tdx_get_sysinfo(void) { return NULL; }
+static inline int tdx_nr_pamt_pages(const struct tdx_sys_info *sysinfo) { return 0; }
 #endif	/* CONFIG_INTEL_TDX_HOST */
 
 #endif /* !__ASSEMBLER__ */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 00e07a0c908a..29defdb7f6bc 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1999,3 +1999,48 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 	return seamcall(TDH_PHYMEM_PAGE_WBINVD, &args);
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
+
+u64 tdh_phymem_pamt_add(unsigned long hpa, struct list_head *pamt_pages)
+{
+	struct tdx_module_args args = {
+		.rcx = hpa,
+	};
+	struct page *page;
+	u64 *p;
+
+	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
+
+	p = &args.rdx;
+	list_for_each_entry(page, pamt_pages, lru) {
+		*p = page_to_phys(page);
+		p++;
+	}
+
+	return seamcall(TDH_PHYMEM_PAMT_ADD, &args);
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_pamt_add);
+
+u64 tdh_phymem_pamt_remove(unsigned long hpa, struct list_head *pamt_pages)
+{
+	struct tdx_module_args args = {
+		.rcx = hpa,
+	};
+	struct page *page;
+	u64 *p, ret;
+
+	WARN_ON_ONCE(!IS_ALIGNED(hpa & PAGE_MASK, PMD_SIZE));
+
+	ret = seamcall_ret(TDH_PHYMEM_PAMT_REMOVE, &args);
+	if (ret)
+		return ret;
+
+	p = &args.rdx;
+	for (int i = 0; i < tdx_nr_pamt_pages(&tdx_sysinfo); i++) {
+		page = phys_to_page(*p);
+		list_add(&page->lru, pamt_pages);
+		p++;
+	}
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_phymem_pamt_remove);
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 82bb82be8567..46c4214b79fb 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -46,6 +46,8 @@
 #define TDH_PHYMEM_PAGE_WBINVD		41
 #define TDH_VP_WR			43
 #define TDH_SYS_CONFIG			45
+#define TDH_PHYMEM_PAMT_ADD		58
+#define TDH_PHYMEM_PAMT_REMOVE		59
 
 /*
  * SEAMCALL leaf:
-- 
2.47.2


