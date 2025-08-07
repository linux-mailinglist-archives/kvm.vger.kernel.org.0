Return-Path: <kvm+bounces-54227-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 82707B1D501
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 11:42:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2A212189D872
	for <lists+kvm@lfdr.de>; Thu,  7 Aug 2025 09:42:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F19725F963;
	Thu,  7 Aug 2025 09:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XydS9wYj"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1081A25C809;
	Thu,  7 Aug 2025 09:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754559747; cv=none; b=so5W7CDijadKZBlUCpG79uQwr/2OyI0kCZ+Jr3KD7IGkT3fUYo08kjELDa8bJwlCv35CW8AjukA+DD8JLRnE59foT6WyXJKJiEyGj352M75wtxY9FfTssOjF3rlNWQttbsqwn8Rw0CW/8qwThBSa5b46tKL/y4Lr9vYKusjyuFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754559747; c=relaxed/simple;
	bh=zyEO6n0gnlxYdZIi3BXqGgo1jHQMcqdnKJqky34e+Es=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OgAaaGeAv1diaEu9I7vJGa1Y37jsJ8n/lfNZhs0mx21fJBpWeDrG3X9KsL0sb3NvEcqrvvEdtuSe3ejabbJxU+k/bZHVsgvDIQ+VSKo7Uhrz7j3IGaUTrdX+zudKCd3oPJQn1/q0o2qO8f3YCjWbrmIhSQxZ9b0Qxgggu1b0510=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XydS9wYj; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1754559746; x=1786095746;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zyEO6n0gnlxYdZIi3BXqGgo1jHQMcqdnKJqky34e+Es=;
  b=XydS9wYjxpvFGxZoE5tTPrNINo6ToXuO+AcqawvxvIh6x2h40iA0Ijki
   VepTJ1/OWkcld4cIzS8fjVhnom7NGdSQEG2VziLV9CiNztmrY92KXRTa3
   wwJdKPij9BPq+Ad+VdZT1dagFTA3dAOvMITcJYYHffbXt5OhYgSjRVwii
   zBqNb30+PaXlt+X5P/cJ1TgOazGWFnAFM9Fc8BohBhDsidFMhljk0Ks++
   5DBGeaV3lLrbr/IrySF5wflBniExHGqjjGhoSXABUne66U3I3WojQNvzI
   1uffAqC2pS8E0ZN/kPx44b954pfZFmMk1DJzGb0hSx7lyUhXyS9NTbYTV
   g==;
X-CSE-ConnectionGUID: 6728gB+0S9yZIhldehjbhw==
X-CSE-MsgGUID: v3MmTArzTUGjiFvF5uAwvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11514"; a="68265907"
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="68265907"
Received: from orviesa002.jf.intel.com ([10.64.159.142])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:25 -0700
X-CSE-ConnectionGUID: 1d/7JSEIRjm+V5IQ7Y4LWQ==
X-CSE-MsgGUID: OPTsPJ8YSTGhBBXo2iBe9w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.17,271,1747724400"; 
   d="scan'208";a="196006783"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Aug 2025 02:42:18 -0700
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
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
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
	yan.y.zhao@intel.com
Subject: [RFC PATCH v2 02/23] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()
Date: Thu,  7 Aug 2025 17:41:49 +0800
Message-ID: <20250807094149.4467-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250807093950.4395-1-yan.y.zhao@intel.com>
References: <20250807093950.4395-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce SEAMCALL wrapper tdh_mem_page_demote() to invoke the SEAMCALL
TDH_MEM_PAGE_DEMOTE, which demotes a huge leaf entry to a non-leaf entry
in the S-EPT.

SEAMCALL TDH_MEM_PAGE_DEMOTE supports the demotion of 2MB or 1GB huge leaf
entries.

The "gpa" and "level" parameters enable the SEAMCALL TDH_MEM_PAGE_DEMOTE to
walk the S-EPT for the huge leaf entry that needs to be demoted.

The "page" parameter specifies a 4KB page that will be used in the demotion
operation to be added as a page table page in the S-EPT.

Invoke tdx_clflush_page() on the 4KB page being added as a page table page.
This function performs CLFLUSH operations on certain TDX-capable platforms,
or conservatively on all TDX-capable platforms, to prevent dirty cache
lines from writing back later and corrupting TD memory.

tdh_mem_page_demote() may fail. Callers can check function return value and
retrieve extended error info from the function output parameters "ext_err1"
and "ext_err2". e.g., due to S-EPT walk error or arriving interrupts.

The TDX module has many internal locks. To avoid staying in SEAM mode for
too long, SEAMCALLs return a BUSY error code to the kernel instead of
spinning on the locks. Depending on the specific SEAMCALL, the caller may
need to handle this error in specific ways (e.g., retry). Therefore, return
the SEAMCALL error code directly to the caller without attempting to handle
it in the core kernel.

Do not handle TDX_INTERRUPTED_RESTARTABLE because SEAMCALL
TDH_MEM_PAGE_DEMOTE does not check interrupts (including NMIs) for basic
TDX (with or without Dynamic PAMT).

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
RFC v2:
- Refine the patch log (Rick).
- Do not handle TDX_INTERRUPTED_RESTARTABLE as the new TDX modules in
  planning do not check interrupts for basic TDX.

RFC v1:
- Rebased and split patch. Updated patch log.
---
 arch/x86/include/asm/tdx.h  |  2 ++
 arch/x86/virt/vmx/tdx/tdx.c | 20 ++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f968b736871a..d2cf48e273d5 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -178,6 +178,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
+			u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_finalize(struct tdx_td *td);
 u64 tdh_vp_flush(struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 580f14f64822..d941f083f741 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1825,6 +1825,26 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *page,
+			u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = page_to_phys(page),
+	};
+	u64 ret;
+
+	tdx_clflush_page(page);
+	ret = seamcall_ret(TDH_MEM_PAGE_DEMOTE, &args);
+
+	*ext_err1 = args.rcx;
+	*ext_err2 = args.rdx;
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(tdh_mem_page_demote);
+
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2)
 {
 	struct tdx_module_args args = {
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 096c78a1d438..a6c0fa53ece9 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -24,6 +24,7 @@
 #define TDH_MNG_KEY_CONFIG		8
 #define TDH_MNG_CREATE			9
 #define TDH_MNG_RD			11
+#define TDH_MEM_PAGE_DEMOTE		15
 #define TDH_MR_EXTEND			16
 #define TDH_MR_FINALIZE			17
 #define TDH_VP_FLUSH			18
-- 
2.43.2


