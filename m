Return-Path: <kvm+bounces-64035-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A251C76D01
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 01:54:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 159534E4CFA
	for <lists+kvm@lfdr.de>; Fri, 21 Nov 2025 00:53:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C624029BD82;
	Fri, 21 Nov 2025 00:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="coSRxWQZ"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9902C28466C;
	Fri, 21 Nov 2025 00:51:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763686308; cv=none; b=OwBlVRYEOhbxOUXyXYTAHKYQIzYhqItQUTYoVfuCl0ogVMigCo3NrCnPFF+UbdE/EluI5qr3P4RvzigzaJIHvL+WZlxThNgifh2iBorKJ7fcG0hI24g1KKBgV4RMFqf3hGsxhpAsZkGJw1GsBzrlq6rmS13RojmqX88Vr+2YOlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763686308; c=relaxed/simple;
	bh=BAV6zyPj08q96elnfN2iTAOSp+aFaA7NGsbSLA1devU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KwiXk3ih+6+HBQlKNhn7zP/wDd/t8Mmq02srh0h/PvrMx1baEqwEYTGUB37vlFd+AtLBPiye8qnGuNKM7sIYkc4pvDpBqCxpqIJpH67mQik6j763fhffwEHhWW1YYBXQYzckKiifY13JAMcTKDcKWWC0ZRU22Cn77Hf4KpGLKgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=coSRxWQZ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1763686307; x=1795222307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=BAV6zyPj08q96elnfN2iTAOSp+aFaA7NGsbSLA1devU=;
  b=coSRxWQZz2jjP1NnD4o4AuvM7KivY1dIgDO4+DvvAFuy/tf8TAhOvHCw
   yutDvqP0GZSM5v5zpcnRAw1ClKpBha5DbpK9JrTMPh3yEVWY44AKae4+1
   s7TkD9IgqXgkmKxcOBmWAgC3eDXZhUgeMQWm4X3pMQnWIITQ5ARyLtCvc
   Dt/SXakv26UPs7+IbKRF1MCoIo24fLbXQ6U3al6nDg2GYNqXDEx27iqbo
   waCyYx7lpxL/1PLsqilG6qjFy+F8KmIe6CBqWWN8NmV0SzBNI8uyvduMt
   AJm6/zhts5vTapXYTEXoDaDyQNYd/pXRqaL0S0wBWfPo8TKmQsmnZYoUg
   Q==;
X-CSE-ConnectionGUID: ZeqT72JCTX2zOcMjwOIlDA==
X-CSE-MsgGUID: +MdV96sYT0y8oYZLqZ7I/Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11619"; a="64780766"
X-IronPort-AV: E=Sophos;i="6.20,214,1758610800"; 
   d="scan'208";a="64780766"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:44 -0800
X-CSE-ConnectionGUID: qHaPJ/irRyCcBP00J26smA==
X-CSE-MsgGUID: IC0oQILnTE2ubZ1inqYBww==
X-ExtLoop1: 1
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Nov 2025 16:51:43 -0800
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kas@kernel.org,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	vannapurve@google.com,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	xiaoyao.li@intel.com,
	binbin.wu@intel.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v4 07/16] x86/virt/tdx: Add tdx_alloc/free_page() helpers
Date: Thu, 20 Nov 2025 16:51:16 -0800
Message-ID: <20251121005125.417831-8-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
References: <20251121005125.417831-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Add helpers to use when allocating or preparing pages that need DPAMT
backing. Make them handle races internally for the case of multiple
callers trying operate on the same 2MB range simultaneously.

While the TDX initialization code in arch/x86 uses pages with 2MB
alignment, KVM will need to hand 4KB pages for it to use. Under DPAMT,
these pages will need DPAMT backing 4KB backing.

Add tdx_alloc_page() and tdx_free_page() to handle both page allocation
and DPAMT installation. Make them behave like normal alloc/free functions
where allocation can fail in the case of no memory, but free (with any
necessary DPAMT release) always succeeds. Do this so they can support the
existing TDX flows that require cleanups to succeed. Also create
tdx_pamt_put()/tdx_pamt_get() to handle installing DPAMT 4KB backing for
pages that are already allocated (such as external page tables, or S-EPT
pages).

Allocate the pages as GFP_KERNEL_ACCOUNT based on that the allocations
will be easily user triggerable.

Since the source of these pages is the page allocator, multiple TDs could
each get 4KB pages that are covered by the same 2MB range. When this
happens only one page pair needs to be installed to cover the 2MB range.
Similarly, when one page is freed, the DPAMT backing cannot be freed until
all TDX pages in the range are no longer in use. Have the helpers manage
these races internally.

So the requirements are that:

1. Free path cannot fail (i.e. no TDX module BUSY errors).
2. Allocation paths need to handle finding that DPAMT backing is already
   installed, and only return an error in the case of no memory, not in the
   case of losing races with other’s trying to operate on the same DPAMT
   range.
3. Free paths cannot fail, and also need to clean up the DPAMT backing
   when the last page in the 2MB range is no longer needed by TDX.

Previous changes allocated refcounts to be used to track how many 4KB
pages are in use by TDX for each 2MB region. So update those inside the
helpers and use them to decide when to actually install the DPAMT backing
pages.

tdx_pamt_put() needs to guarantee the DPAMT is installed before returning
so that racing threads don’t tell the TDX module to operate on the page
before it’s installed. Take a lock while adjusting the refcount and doing
the actual TDH.PHYMEM.PAMT.ADD/REMOVE to make sure these happen
atomically. The lock is heavyweight, but will be optimized in future
changes. Just do the simple solution before any complex improvements.

TDH.PHYMEM.PAMT.ADD/REMOVE take exclusive locks at the granularity each
2MB range. A simultaneous attempt to operate on the same 2MB region would
result in a BUSY error code returned from the SEAMCALL. Since the
invocation of SEAMCALLs are behind a lock, this won’t conflict.

Besides the contention between TDH.PHYMEM.PAMT.ADD/REMOVE, many other
SEAMCALLs take the same 2MB granularity locks as shared. This means any
attempt to operate on the page by the TDX module while simultaneously
doing PAMT.ADD/REMOVE will result in a BUSY error. This should not happen,
as the PAMT pages always has to be installed before giving the pages to
the TDX module anyway.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Add feedback, update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v4:
 - Update tdx_find_pamt_refcount() calls to pass PFN and rely on
   internal PMD bucket calculations. Based on changes in previous patch.
 - Pull calculation TDX DPAMT 2MB range arg into helper.
 - Fix alloc_pamt_array() doesn't zero array on allocation failure (Yan)
 - Move "prealloc" comment to future patch. (Kai)
 - Use union for dpamt page array. (Dave)
 - Use sizeof(*args_array) everywhere instead of sizeof(u64) in some
   places. (Dave)
 - Fix refcount inc/dec cases. (Xiaoyao)
 - Rearrange error handling in tdx_pamt_get()/tdx_pamt_put() to remove
   some indented lines.
 - Make alloc_pamt_array() use GFP_KERNEL_ACCOUNT like the pre-fault
   path does later.

v3:
 - Fix hard to follow iteration over struct members.
 - Simplify the code by removing the intermediate lists of pages.
 - Clear PAMT pages before freeing. (Adrian)
 - Rename tdx_nr_pamt_pages(). (Dave)
 - Add comments some comments, but thought the simpler code needed
   less. So not as much as seem to be requested. (Dave)
 - Fix asymmetry in which level of the add/remove helpers global lock is
   held.
 - Split out optimization.
 - Write log.
 - Flatten call hierarchies and adjust errors accordingly.
---
 arch/x86/include/asm/shared/tdx.h |   7 +
 arch/x86/include/asm/tdx.h        |   8 +-
 arch/x86/virt/vmx/tdx/tdx.c       | 258 ++++++++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h       |   2 +
 4 files changed, 274 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/shared/tdx.h b/arch/x86/include/asm/shared/tdx.h
index 6a1646fc2b2f..cc2f251cb791 100644
--- a/arch/x86/include/asm/shared/tdx.h
+++ b/arch/x86/include/asm/shared/tdx.h
@@ -145,6 +145,13 @@ struct tdx_module_args {
 	u64 rsi;
 };
 
+struct tdx_module_array_args {
+	union {
+		struct tdx_module_args args;
+		u64 args_array[sizeof(struct tdx_module_args) / sizeof(u64)];
+	};
+};
+
 /* Used to communicate with the TDX module */
 u64 __tdcall(u64 fn, struct tdx_module_args *args);
 u64 __tdcall_ret(u64 fn, struct tdx_module_args *args);
diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index cf51ccd16194..914213123d94 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -135,11 +135,17 @@ static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
 	return false; /* To be enabled when kernel is ready */
 }
 
+void tdx_quirk_reset_page(struct page *page);
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
-void tdx_quirk_reset_page(struct page *page);
+int tdx_pamt_get(struct page *page);
+void tdx_pamt_put(struct page *page);
+
+struct page *tdx_alloc_page(void);
+void tdx_free_page(struct page *page);
 
 struct tdx_td {
 	/* TD root structure: */
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index edf9182ed86d..745b308785d6 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2009,6 +2009,264 @@ u64 tdh_phymem_page_wbinvd_hkid(u64 hkid, struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdh_phymem_page_wbinvd_hkid);
 
+/* Number PAMT pages to be provided to TDX module per 2M region of PA */
+static int tdx_dpamt_entry_pages(void)
+{
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	return tdx_sysinfo.tdmr.pamt_4k_entry_size * PTRS_PER_PTE / PAGE_SIZE;
+}
+
+/*
+ * The TDX spec treats the registers like an array, as they are ordered
+ * in the struct. The array size is limited by the number or registers,
+ * so define the max size it could be for worst case allocations and sanity
+ * checking.
+ */
+#define MAX_TDX_ARG_SIZE(reg) (sizeof(struct tdx_module_args) - \
+			       offsetof(struct tdx_module_args, reg))
+#define TDX_ARG_INDEX(reg) (offsetof(struct tdx_module_args, reg) / \
+			    sizeof(u64))
+
+/*
+ * Treat struct the registers like an array that starts at RDX, per
+ * TDX spec. Do some sanitychecks, and return an indexable type.
+ */
+static u64 *dpamt_args_array_ptr(struct tdx_module_array_args *args)
+{
+	WARN_ON_ONCE(tdx_dpamt_entry_pages() > MAX_TDX_ARG_SIZE(rdx));
+
+	return &args->args_array[TDX_ARG_INDEX(rdx)];
+}
+
+static int alloc_pamt_array(u64 *pa_array)
+{
+	struct page *page;
+	int i;
+
+	for (i = 0; i < tdx_dpamt_entry_pages(); i++) {
+		page = alloc_page(GFP_KERNEL_ACCOUNT);
+		if (!page)
+			goto err;
+		pa_array[i] = page_to_phys(page);
+	}
+
+	return 0;
+err:
+	/*
+	 * Zero the rest of the array to help with
+	 * freeing in error paths.
+	 */
+	for (; i < tdx_dpamt_entry_pages(); i++)
+		pa_array[i] = 0;
+	return -ENOMEM;
+}
+
+static void free_pamt_array(u64 *pa_array)
+{
+	for (int i = 0; i < tdx_dpamt_entry_pages(); i++) {
+		if (!pa_array[i])
+			break;
+
+		/*
+		 * Reset pages unconditionally to cover cases
+		 * where they were passed to the TDX module.
+		 */
+		tdx_quirk_reset_paddr(pa_array[i], PAGE_SIZE);
+
+		__free_page(phys_to_page(pa_array[i]));
+	}
+}
+
+/*
+ * Calculate the arg needed for operating on the DPAMT backing for
+ * a given 4KB page.
+ */
+static u64 pamt_2mb_arg(struct page *page)
+{
+	unsigned long hpa_2mb = ALIGN_DOWN(page_to_phys(page), PMD_SIZE);
+
+	return hpa_2mb | TDX_PS_2M;
+}
+
+/*
+ * Add PAMT backing for the given page. Return's negative error code
+ * for kernel side error conditions (-ENOMEM) and 1 for TDX Module
+ * error. In the case of TDX module error, the return code is stored
+ * in tdx_err.
+ */
+static u64 tdh_phymem_pamt_add(struct page *page, u64 *pamt_pa_array)
+{
+	struct tdx_module_array_args args = {
+		.args.rcx = pamt_2mb_arg(page)
+	};
+	u64 *dpamt_arg_array = dpamt_args_array_ptr(&args);
+
+	/* Copy PAMT page PA's into the struct per the TDX ABI */
+	memcpy(dpamt_arg_array, pamt_pa_array,
+	       tdx_dpamt_entry_pages() * sizeof(*dpamt_arg_array));
+
+	return seamcall(TDH_PHYMEM_PAMT_ADD, &args.args);
+}
+
+/* Remove PAMT backing for the given page. */
+static u64 tdh_phymem_pamt_remove(struct page *page, u64 *pamt_pa_array)
+{
+	struct tdx_module_array_args args = {
+		.args.rcx = pamt_2mb_arg(page),
+	};
+	u64 *args_array = dpamt_args_array_ptr(&args);
+	u64 ret;
+
+	ret = seamcall_ret(TDH_PHYMEM_PAMT_REMOVE, &args.args);
+	if (ret)
+		return ret;
+
+	/* Copy PAMT page PA's out of the struct per the TDX ABI */
+	memcpy(pamt_pa_array, args_array,
+	       tdx_dpamt_entry_pages() * sizeof(*args_array));
+
+	return ret;
+}
+
+/* Serializes adding/removing PAMT memory */
+static DEFINE_SPINLOCK(pamt_lock);
+
+/* Bump PAMT refcount for the given page and allocate PAMT memory if needed */
+int tdx_pamt_get(struct page *page)
+{
+	u64 pamt_pa_array[MAX_TDX_ARG_SIZE(rdx)];
+	atomic_t *pamt_refcount;
+	u64 tdx_status;
+	int ret;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return 0;
+
+	ret = alloc_pamt_array(pamt_pa_array);
+	if (ret)
+		goto out_free;
+
+	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
+
+	scoped_guard(spinlock, &pamt_lock) {
+		/*
+		 * If the pamt page is already added (i.e. refcount >= 1),
+		 * then just increment the refcount.
+		 */
+		if (atomic_read(pamt_refcount)) {
+			atomic_inc(pamt_refcount);
+			goto out_free;
+		}
+
+		/* Try to add the pamt page and take the refcount 0->1. */
+
+		tdx_status = tdh_phymem_pamt_add(page, pamt_pa_array);
+		if (!IS_TDX_SUCCESS(tdx_status)) {
+			pr_err("TDH_PHYMEM_PAMT_ADD failed: %#llx\n", tdx_status);
+			goto out_free;
+		}
+
+		atomic_inc(pamt_refcount);
+	}
+
+	return ret;
+out_free:
+	/*
+	 * pamt_pa_array is populated or zeroed up to tdx_dpamt_entry_pages()
+	 * above. free_pamt_array() can handle either case.
+	 */
+	free_pamt_array(pamt_pa_array);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdx_pamt_get);
+
+/*
+ * Drop PAMT refcount for the given page and free PAMT memory if it is no
+ * longer needed.
+ */
+void tdx_pamt_put(struct page *page)
+{
+	u64 pamt_pa_array[MAX_TDX_ARG_SIZE(rdx)];
+	atomic_t *pamt_refcount;
+	u64 tdx_status;
+
+	if (!tdx_supports_dynamic_pamt(&tdx_sysinfo))
+		return;
+
+	pamt_refcount = tdx_find_pamt_refcount(page_to_pfn(page));
+
+	scoped_guard(spinlock, &pamt_lock) {
+		/*
+		 * If the there are more than 1 references on the pamt page,
+		 * don't remove it yet. Just decrement the refcount.
+		 */
+		if (atomic_read(pamt_refcount) > 1) {
+			atomic_dec(pamt_refcount);
+			return;
+		}
+
+		/* Try to remove the pamt page and take the refcount 1->0. */
+
+		tdx_status = tdh_phymem_pamt_remove(page, pamt_pa_array);
+		if (!IS_TDX_SUCCESS(tdx_status)) {
+			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
+
+			/*
+			 * Don't free pamt_pa_array as it could hold garbage
+			 * when tdh_phymem_pamt_remove() fails.
+			 */
+			return;
+		}
+
+		atomic_dec(pamt_refcount);
+	}
+
+	/*
+	 * pamt_pa_array is populated up to tdx_dpamt_entry_pages() by the TDX
+	 * module with pages, or remains zero inited. free_pamt_array() can
+	 * handle either case. Just pass it unconditionally.
+	 */
+	free_pamt_array(pamt_pa_array);
+}
+EXPORT_SYMBOL_GPL(tdx_pamt_put);
+
+/*
+ * Return a page that can be used as TDX private memory
+ * and obtain TDX protections.
+ */
+struct page *tdx_alloc_page(void)
+{
+	struct page *page;
+
+	page = alloc_page(GFP_KERNEL);
+	if (!page)
+		return NULL;
+
+	if (tdx_pamt_get(page)) {
+		__free_page(page);
+		return NULL;
+	}
+
+	return page;
+}
+EXPORT_SYMBOL_GPL(tdx_alloc_page);
+
+/*
+ * Free a page that was used as TDX private memory. After this,
+ * the page is no longer protected by TDX.
+ */
+void tdx_free_page(struct page *page)
+{
+	if (!page)
+		return;
+
+	tdx_pamt_put(page);
+	__free_page(page);
+}
+EXPORT_SYMBOL_GPL(tdx_free_page);
+
 #ifdef CONFIG_KEXEC_CORE
 void tdx_cpu_flush_cache_for_kexec(void)
 {
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
2.51.2


