Return-Path: <kvm+bounces-45221-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CF203AA72EA
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:10:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9714E169799
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:09:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B86255F3C;
	Fri,  2 May 2025 13:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aKivw+jW"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A3F1254869;
	Fri,  2 May 2025 13:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191324; cv=none; b=tQ7U8heDc/tYq2gvOxSbgNYM7vjLIo/o4BoJZ/0iKGyLfTCqCa47u2DonzOjwHjql2H9d3PO9z7gJ5va0NPe1Al2J87GBInbYT89ppEaQ3TW15MwqtmV9DDW/SRvRdYpXkDHmeIdDs1GwGGFJJAJIFuUph9hvb/x1yCltymv2ek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191324; c=relaxed/simple;
	bh=C9kO+sFs+Azqq39AMtBkkj6l8k1vV7yvPw74WxauvEg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBiVc8AiBppe6SkfikGB4b+Ov7EKJpDXxxdff3/6HfHcH9+6MkiqIOcOVFNW37PGsVxTbssRDauQiW8kYnyhui2l425W903tG+ocfRDpx9ao1U/fgKSMLDIEcnm/9eDaeIsW7biapQf64yhFH1MXqdavFr4o/xinlFaSd9Kg+t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aKivw+jW; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191323; x=1777727323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=C9kO+sFs+Azqq39AMtBkkj6l8k1vV7yvPw74WxauvEg=;
  b=aKivw+jW++XQodfH2R/kFVrrAn8tp6F94uZQPAlon3RMIEq78YT6Zykl
   Yqwnems8cQvEzmmqxr41+tyLITOWennJ1lnmGeQwULfZEZP6GK2PLBtJY
   i777EI6VX9dNrX3sbgBIRwutnAVDq9O2kU4QHgk7bbLlnl6ed83wh4IBa
   PiO7G85jJ/pFGbDvGUWVZnCKhS7gXvy18BVfNe6abkpXXGXOg7XXgp7qI
   jLpiXalQwaeRMzghNmdK/Z9siNZXfxOqRX+PKCKAKrupBFlj3+lGuWG4Z
   47gx1zK13Ep8+1E6YNQk78iptNn5ipLUqbcFTXRcyJ8GPU6Z9azLLfzFm
   w==;
X-CSE-ConnectionGUID: VBE3TFEvQb6wQ5nHj2brxg==
X-CSE-MsgGUID: m7dDWvx1REavZRfwjYB7rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="58495260"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="58495260"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:41 -0700
X-CSE-ConnectionGUID: A3EKNsEKT5qkuyTiGC645w==
X-CSE-MsgGUID: fMDb+YDqRMO63jByr9l2rw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="138657776"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa003.fm.intel.com with ESMTP; 02 May 2025 06:08:37 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 0E6DA9F; Fri, 02 May 2025 16:08:36 +0300 (EEST)
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
Subject: [RFC, PATCH 01/12] x86/virt/tdx: Allocate page bitmap for Dynamic PAMT
Date: Fri,  2 May 2025 16:08:17 +0300
Message-ID: <20250502130828.4071412-2-kirill.shutemov@linux.intel.com>
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

The Physical Address Metadata Table (PAMT) holds TDX metadata for
physical memory and must be allocated by the kernel during TDX module
initialization.

The exact size of the required PAMT memory is determined by the TDX
module and may vary between TDX module versions, but currently it is
approximately 0.4% of the system memory. This is a significant
commitment, especially if it is not known upfront whether the machine
will run any TDX guests.

The Dynamic PAMT feature reduces static PAMT allocations. PAMT_1G and
PAMT_2M levels are still allocated on TDX module initialization, but the
PAMT_4K level is allocated dynamically, reducing static allocations to
approximately 0.004% of the system memory.

With Dynamic PAMT, the kernel no longer needs to allocate PAMT_4K on
boot, but instead must allocate a page bitmap. The TDX module determines
how many bits per page need to be allocated (currently it is 1).

Allocate the bitmap if the kernel boots on a machine with Dynamic PAMT.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/include/asm/tdx.h                  |  5 +++++
 arch/x86/include/asm/tdx_global_metadata.h  |  1 +
 arch/x86/virt/vmx/tdx/tdx.c                 | 23 ++++++++++++++++++++-
 arch/x86/virt/vmx/tdx/tdx_global_metadata.c |  3 +++
 4 files changed, 31 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index 26ffc792e673..9701876d4e16 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -125,6 +125,11 @@ int tdx_enable(void);
 const char *tdx_dump_mce_info(struct mce *m);
 const struct tdx_sys_info *tdx_get_sysinfo(void);
 
+static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
+{
+	return false; /* To be enabled when kernel is ready */
+}
+
 int tdx_guest_keyid_alloc(void);
 u32 tdx_get_nr_guest_keyids(void);
 void tdx_guest_keyid_free(unsigned int keyid);
diff --git a/arch/x86/include/asm/tdx_global_metadata.h b/arch/x86/include/asm/tdx_global_metadata.h
index 060a2ad744bf..5eb808b23997 100644
--- a/arch/x86/include/asm/tdx_global_metadata.h
+++ b/arch/x86/include/asm/tdx_global_metadata.h
@@ -15,6 +15,7 @@ struct tdx_sys_info_tdmr {
 	u16 pamt_4k_entry_size;
 	u16 pamt_2m_entry_size;
 	u16 pamt_1g_entry_size;
+	u8  pamt_page_bitmap_entry_bits;
 };
 
 struct tdx_sys_info_td_ctrl {
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index f5e2a937c1e7..c8bfd765e451 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -470,6 +470,18 @@ static unsigned long tdmr_get_pamt_sz(struct tdmr_info *tdmr, int pgsz,
 	return pamt_sz;
 }
 
+static unsigned long tdmr_get_pamt_bitmap_sz(struct tdmr_info *tdmr)
+{
+	unsigned long pamt_sz, nr_pamt_entries;
+	int bits_per_entry;
+
+	bits_per_entry = tdx_sysinfo.tdmr.pamt_page_bitmap_entry_bits;
+	nr_pamt_entries = tdmr->size >> PAGE_SHIFT;
+	pamt_sz = DIV_ROUND_UP(nr_pamt_entries * bits_per_entry, BITS_PER_BYTE);
+
+	return ALIGN(pamt_sz, PAGE_SIZE);
+}
+
 /*
  * Locate a NUMA node which should hold the allocation of the @tdmr
  * PAMT.  This node will have some memory covered by the TDMR.  The
@@ -522,7 +534,16 @@ static int tdmr_set_up_pamt(struct tdmr_info *tdmr,
 	 * and the total PAMT size.
 	 */
 	tdmr_pamt_size = 0;
-	for (pgsz = TDX_PS_4K; pgsz < TDX_PS_NR; pgsz++) {
+	pgsz = TDX_PS_4K;
+
+	/* With Dynamic PAMT, PAMT_4K is replaced with a bitmap */
+	if (tdx_supports_dynamic_pamt(&tdx_sysinfo)) {
+		pamt_size[pgsz] = tdmr_get_pamt_bitmap_sz(tdmr);
+		tdmr_pamt_size += pamt_size[pgsz];
+		pgsz++;
+	}
+
+	for (; pgsz < TDX_PS_NR; pgsz++) {
 		pamt_size[pgsz] = tdmr_get_pamt_sz(tdmr, pgsz,
 					pamt_entry_size[pgsz]);
 		tdmr_pamt_size += pamt_size[pgsz];
diff --git a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
index 13ad2663488b..683925bcc9eb 100644
--- a/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
+++ b/arch/x86/virt/vmx/tdx/tdx_global_metadata.c
@@ -33,6 +33,9 @@ static int get_tdx_sys_info_tdmr(struct tdx_sys_info_tdmr *sysinfo_tdmr)
 		sysinfo_tdmr->pamt_2m_entry_size = val;
 	if (!ret && !(ret = read_sys_metadata_field(0x9100000100000012, &val)))
 		sysinfo_tdmr->pamt_1g_entry_size = val;
+	if (!ret && tdx_supports_dynamic_pamt(&tdx_sysinfo) &&
+	    !(ret = read_sys_metadata_field(0x9100000100000013, &val)))
+		sysinfo_tdmr->pamt_page_bitmap_entry_bits = val;
 
 	return ret;
 }
-- 
2.47.2


