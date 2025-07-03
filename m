Return-Path: <kvm+bounces-51499-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F0034AF7C9C
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 17:42:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0CBB21BC2079
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 15:38:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E9FB22157E;
	Thu,  3 Jul 2025 15:37:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YiouNkfX"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F1BE15C0;
	Thu,  3 Jul 2025 15:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751557057; cv=none; b=GitUZk0Zl1aSfW6T1TlZpH+PzGG9hMopBPDxX/CXuvbx9hc93CNyCl6gRSiPazqV4YaPPUzkbmJLlkdo/RC+h91DOq9/lOEWiGvWK1g//RM6I76LJLKw6sWHk1ADKj/ovCTH0SXakqdGNX1MVk6JV7uqF/OWlFEqRrfWUD7LBwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751557057; c=relaxed/simple;
	bh=2ZYiW9QKD/NNQXX4mTs5dc+Ov1mBPfARjMAo7zKsIJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvVrGHcCJKAoMNLhNHW83QRIvDyQEt2ruUBO+Mz51k24ThO1LDE16pFCiole7ANmKro7O4+tYtV34zI82caHKNqThyvZMDxkNF9jp2vQMmf2eTBAbmqWdIaTeGSaFoF1Asm7I4Ge5GY/DAI9qLkNLmw6OovXsStEEQu/O/DtpUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YiouNkfX; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751557057; x=1783093057;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2ZYiW9QKD/NNQXX4mTs5dc+Ov1mBPfARjMAo7zKsIJc=;
  b=YiouNkfX6neK5AOxjGt4v0UVuG6ngpGfEhmOMSiN0DgcXcXfZqzrOYGa
   6SFoACkLsJHi8J3BQdl+EMYNMh2a9UdVIlbT5sKXavrt2fC+3lvEuLoYQ
   Ei4atBksnajNVuS5WTM7cJoEXTStLNMfCEOv7APeVeLFdQBWXAQbTc51K
   bP5WMch8ig5Px15fEq3IS8e/hkNA2eHaKLWyrln3sMED3F+d95l16MYiF
   tyak5HCGyrTHZfZ4OuKlb7nZ1Z0kQHgg3LtnTA/yohyXIokjwTNVnGp7d
   oHO+4HrBMiEuwOrgls5Gx7bRRG/uyq8ZkQYf+VgPm1tEVb9VEVabMnwOB
   g==;
X-CSE-ConnectionGUID: BCPN44LNSRGwf4BZeRI8kQ==
X-CSE-MsgGUID: RLo4haxEQGydO6p6XhTDsw==
X-IronPort-AV: E=McAfee;i="6800,10657,11483"; a="76436672"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="76436672"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:37:36 -0700
X-CSE-ConnectionGUID: JehsTHjLSkm0b3aoPdXJPQ==
X-CSE-MsgGUID: J8mRqbpURguS7di2CeBU3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="178065105"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 08:37:30 -0700
From: Adrian Hunter <adrian.hunter@intel.com>
To: Dave Hansen <dave.hansen@linux.intel.com>,
	pbonzini@redhat.com,
	seanjc@google.com,
	vannapurve@google.com
Cc: Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	x86@kernel.org,
	H Peter Anvin <hpa@zytor.com>,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kirill.shutemov@linux.intel.com,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V2 1/2] x86/tdx: Eliminate duplicate code in tdx_clear_page()
Date: Thu,  3 Jul 2025 18:37:11 +0300
Message-ID: <20250703153712.155600-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250703153712.155600-1-adrian.hunter@intel.com>
References: <20250703153712.155600-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
logic.  Rename reset_tdx_pages() to tdx_quirk_reset_paddr() and use it
in place of tdx_clear_page().

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V2:

	Rename reset_tdx_pages() to tdx_quirk_reset_paddr()
	Call tdx_quirk_reset_paddr() directly


 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 25 +++----------------------
 arch/x86/virt/vmx/tdx/tdx.c |  5 +++--
 3 files changed, 8 insertions(+), 24 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a69866..f66328404724 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+void tdx_quirk_reset_paddr(unsigned long base, unsigned long size);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a08e7055d1db..031e36665757 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -276,25 +276,6 @@ static inline void tdx_disassociate_vp(struct kvm_vcpu *vcpu)
 	vcpu->cpu = -1;
 }
 
-static void tdx_clear_page(struct page *page)
-{
-	const void *zero_page = (const void *) page_to_virt(ZERO_PAGE(0));
-	void *dest = page_to_virt(page);
-	unsigned long i;
-
-	/*
-	 * The page could have been poisoned.  MOVDIR64B also clears
-	 * the poison bit so the kernel can safely use the page again.
-	 */
-	for (i = 0; i < PAGE_SIZE; i += 64)
-		movdir64b(dest + i, zero_page);
-	/*
-	 * MOVDIR64B store uses WC buffer.  Prevent following memory reads
-	 * from seeing potentially poisoned cache.
-	 */
-	__mb();
-}
-
 static void tdx_no_vcpus_enter_start(struct kvm *kvm)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
@@ -340,7 +321,7 @@ static int tdx_reclaim_page(struct page *page)
 
 	r = __tdx_reclaim_page(page);
 	if (!r)
-		tdx_clear_page(page);
+		tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
 	return r;
 }
 
@@ -589,7 +570,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return;
 	}
-	tdx_clear_page(kvm_tdx->td.tdr_page);
+	tdx_quirk_reset_paddr(page_to_phys(kvm_tdx->td.tdr_page), PAGE_SIZE);
 
 	__free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
@@ -1689,7 +1670,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
 		return -EIO;
 	}
-	tdx_clear_page(page);
+	tdx_quirk_reset_paddr(page_to_phys(page), PAGE_SIZE);
 	tdx_unpin(kvm, page);
 	return 0;
 }
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..14d93ed05bd2 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -637,7 +637,7 @@ static int tdmrs_set_up_pamt_all(struct tdmr_info_list *tdmr_list,
  * clear these pages.  Note this function doesn't flush cache of
  * these TDX private pages.  The caller should make sure of that.
  */
-static void reset_tdx_pages(unsigned long base, unsigned long size)
+void tdx_quirk_reset_paddr(unsigned long base, unsigned long size)
 {
 	const void *zero_page = (const void *)page_address(ZERO_PAGE(0));
 	unsigned long phys, end;
@@ -653,10 +653,11 @@ static void reset_tdx_pages(unsigned long base, unsigned long size)
 	 */
 	mb();
 }
+EXPORT_SYMBOL_GPL(tdx_quirk_reset_paddr);
 
 static void tdmr_reset_pamt(struct tdmr_info *tdmr)
 {
-	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
+	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
 static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
-- 
2.48.1


