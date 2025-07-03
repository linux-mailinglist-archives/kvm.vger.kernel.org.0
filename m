Return-Path: <kvm+bounces-51482-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA2FAF72AD
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 13:41:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0C9443AA45E
	for <lists+kvm@lfdr.de>; Thu,  3 Jul 2025 11:41:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16EE52E543B;
	Thu,  3 Jul 2025 11:41:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LHpVJeIo"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41762E5417;
	Thu,  3 Jul 2025 11:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751542871; cv=none; b=igGIrb0UF4vynnL1IEaJZeKUTRkhzwkIu0j1WgaMwWEOeemXpeQRxn3W0z+mJmbVX03g5NcrvqcV2/Z1zRWjiKCK2IiCdltX6rst4Rs12TnYjQW4OrKG7734OuRxyJm2YkuVerHh7mTf6E0SkEdVbTXcCtef8BLyl5S4x8jOZps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751542871; c=relaxed/simple;
	bh=QvE1SkOi6tcReIT37C25WBczhr93pNig4GOrXwUinyM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XliGjGyPAOxN/2mzJ/wBIfiaRGJUXjtoO3thvgVh9BD00JLQt1MXEQrBsdNDX6hgxkGitXRgs251E1gHmnSlbzh+LWKhOAx8FzjtiY3as4l5r9xk9u0Np5N5xN/QV87DVNZdzZuacCYLXyjk9iW10IccFvCHnoT20L8T1qqvaWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LHpVJeIo; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1751542870; x=1783078870;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QvE1SkOi6tcReIT37C25WBczhr93pNig4GOrXwUinyM=;
  b=LHpVJeIo26Eod9sMuj/sy7T7HllZWFWw6vva+eUdLhzvfhrTmmAUezGv
   OuHrHv5MkDTFNwkBwOL4gm/BzcbNl50Huixj4iptmQuhuyP/wHTmlDWTa
   HK8WkAyfeW3HOaF0h7lqdT1Y238VWEKNbV15twColKR+gClPB6qgKpsQT
   gf3vdMZazb5l2gkYdMM4BE3NPeW39P3wdoaSwTu8+YlFXknivHPsxa1Fs
   I/BjEgHQVPDavVFdxWP+Hdnv7nY4e0yDgpFj9ZcTjy4RiXcqkezb5o9E9
   dC85chyf2+tQeePD7XEolj4h+xTU69atlQk8mAE48dKQwrhqhht4IudKz
   A==;
X-CSE-ConnectionGUID: roJ6jET8RIWpc1br/Mzx5A==
X-CSE-MsgGUID: 0+74Fqs0TWmM/V8VsaUxSw==
X-IronPort-AV: E=McAfee;i="6800,10657,11482"; a="53983763"
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="53983763"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 04:41:10 -0700
X-CSE-ConnectionGUID: dHUhRsLBSyOj7mUBYH5Drw==
X-CSE-MsgGUID: /9wiZon6TsWug3ZTz4WjJA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,284,1744095600"; 
   d="scan'208";a="155096166"
Received: from johunt-mobl9.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.86])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2025 04:41:04 -0700
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
Subject: [PATCH 1/2] x86/tdx: Eliminate duplicate code in tdx_clear_page()
Date: Thu,  3 Jul 2025 14:40:37 +0300
Message-ID: <20250703114038.99270-2-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250703114038.99270-1-adrian.hunter@intel.com>
References: <20250703114038.99270-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

tdx_clear_page() and reset_tdx_pages() duplicate the TDX page clearing
logic.  Keep the tdx_clear_page() prototype but call reset_tdx_pages() for
the implementation.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/kvm/vmx/tdx.c      | 19 -------------------
 arch/x86/virt/vmx/tdx/tdx.c |  6 ++++++
 3 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 7ddef3a69866..e94eb0711bf1 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -131,6 +131,8 @@ int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
 
+void tdx_clear_page(struct page *page);
+
 struct tdx_td {
 	/* TD root structure: */
 	struct page *tdr_page;
diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a08e7055d1db..098e4ee574bb 100644
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
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c7a9a087ccaf..17a7a599facd 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -654,6 +654,12 @@ static void reset_tdx_pages(unsigned long base, unsigned long size)
 	mb();
 }
 
+void tdx_clear_page(struct page *page)
+{
+	reset_tdx_pages(page_to_phys(page), PAGE_SIZE);
+}
+EXPORT_SYMBOL_GPL(tdx_clear_page);
+
 static void tdmr_reset_pamt(struct tdmr_info *tdmr)
 {
 	tdmr_do_pamt_func(tdmr, reset_tdx_pages);
-- 
2.48.1


