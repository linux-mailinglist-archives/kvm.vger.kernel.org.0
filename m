Return-Path: <kvm+bounces-67110-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 33DE5CF7C0F
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:20:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B273230376A0
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:20:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87D9632549B;
	Tue,  6 Jan 2026 10:20:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fmEou+Eh"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 204DE30AADB;
	Tue,  6 Jan 2026 10:20:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767694854; cv=none; b=Fc4FCl+eTjVJu/qAM1lh8TKS/M4woMLKFPW8wRdIKX86nnGL/uFFFlSQFeIjMCWJWdPIuIWv4FhkUSMvNJvAz+rFl6MzpxSGvKkro6beOjS3TpqncwXqyjbx087W/a5WAg9TxPTK35gXgdTHFALQEayRQ1dwDvdksZwtSskuRAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767694854; c=relaxed/simple;
	bh=6Am863RFtojr3rdLOq5FNSVmKnQdzK9+NgRhicWj3OM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1dkC3zJFqSyX8umTv9pXvJ4DxHC8DJnbn2ZnfSDqefVFBgzSPnwnz393mGM47p+xFDzxcFCdLh96qnAyz6R7pLkT9jZoG5suKQzSNkht2ENLAJh8r5cKmKD6Ga3L4Dp2NPAiDaAOAtNesAw78hgJgMXtJJ9hoQgMvY+ZLmYhbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fmEou+Eh; arc=none smtp.client-ip=192.198.163.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767694853; x=1799230853;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6Am863RFtojr3rdLOq5FNSVmKnQdzK9+NgRhicWj3OM=;
  b=fmEou+EhrA/XAtsyneOLn+AMghHDw7YaQj8aLDpbzrpT0bkwTlINDOhn
   niElOQLtd2thX+NxCWwC37rH5pm2TbuUKaczgH7LR4jElFtE2M1roJqI1
   GrwM9BksJNwjYW+ybH3f/9e7Tq8BI2MaPR98fs7CnG/njxL7EiGMOLT4J
   kEkGB/dGFzHOQtwviyq4MQBqSK3AU8cLdX7QUqlYLt7oqoyIKoyaLEuHB
   lYt7t1tywiojH8HKvTjuaX4jzsAdm40J+0LHMROcnFOft3vo4Ffz0lSfD
   1CoNj23C9A8vr7FBbXWjbUifX2Rd40oITa8oPXan2tK5gwZ2j3A/XSzjG
   Q==;
X-CSE-ConnectionGUID: Kzk6pH0BT/6/3QbANBAxfA==
X-CSE-MsgGUID: 5Rsotw0ySk24gEPtZEdynQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="68966501"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="68966501"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa111.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:20:52 -0800
X-CSE-ConnectionGUID: OpNIBQYLRDqPgzcspmiMlg==
X-CSE-MsgGUID: L3pJgn2qQwqEddiUuDHYxg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="207175087"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:20:47 -0800
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
Subject: [PATCH v3 02/24] x86/virt/tdx: Add SEAMCALL wrapper tdh_mem_page_demote()
Date: Tue,  6 Jan 2026 18:18:49 +0800
Message-ID: <20260106101849.24889-1-yan.y.zhao@intel.com>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

Introduce SEAMCALL wrapper tdh_mem_page_demote() to invoke
TDH_MEM_PAGE_DEMOTE, which splits a 2MB or a 1GB mapping in S-EPT into
512 4KB or 2MB mappings respectively.

SEAMCALL TDH_MEM_PAGE_DEMOTE walks the S-EPT to locate the huge mapping to
split and add a new S-EPT page to hold the 512 smaller mappings.

Parameters "gpa" and "level" specify the huge mapping to split, and
parameter "new_sept_page" specifies the 4KB page to be added as the S-EPT
page. Invoke tdx_clflush_page() before adding the new S-EPT page
conservatively to prevent dirty cache lines from writing back later and
corrupting TD memory.

tdh_mem_page_demote() may fail, e.g., due to S-EPT walk error. Callers must
check function return value and can retrieve the extended error info from
the output parameters "ext_err1", and "ext_err2".

The TDX module has many internal locks. To avoid staying in SEAM mode for
too long, SEAMCALLs return a BUSY error code to the kernel instead of
spinning on the locks. Depending on the specific SEAMCALL, the caller may
need to handle this error in specific ways (e.g., retry). Therefore, return
the SEAMCALL error code directly to the caller without attempting to handle
it in the core kernel.

Enable tdh_mem_page_demote() only on TDX modules that support feature
TDX_FEATURES0.ENHANCE_DEMOTE_INTERRUPTIBILITY, which does not return error
TDX_INTERRUPTED_RESTARTABLE on basic TDX (i.e., without TD partition) [2].

This is because error TDX_INTERRUPTED_RESTARTABLE is difficult to handle.
The TDX module provides no guaranteed maximum retry count to ensure forward
progress of the demotion. Interrupt storms could then result in a DoS if
host simply retries endlessly for TDX_INTERRUPTED_RESTARTABLE. Disabling
interrupts before invoking the SEAMCALL also doesn't work because NMIs can
also trigger TDX_INTERRUPTED_RESTARTABLE. Therefore, the tradeoff for basic
TDX is to disable the TDX_INTERRUPTED_RESTARTABLE error given the
reasonable execution time for demotion. [1]

Link: https://lore.kernel.org/kvm/99f5585d759328db973403be0713f68e492b492a.camel@intel.com [1]
Link: https://lore.kernel.org/all/fbf04b09f13bc2ce004ac97ee9c1f2c965f44fdf.camel@intel.com [2]
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Use a var name that clearly tell that the page is used as a page table
  page. (Binbin).
- Check if TDX module supports feature ENHANCE_DEMOTE_INTERRUPTIBILITY.
  (Kai).

RFC v2:
- Refine the patch log (Rick).
- Do not handle TDX_INTERRUPTED_RESTARTABLE as the new TDX modules in
  planning do not check interrupts for basic TDX.

RFC v1:
- Rebased and split patch. Updated patch log.
---
 arch/x86/include/asm/tdx.h  |  8 ++++++++
 arch/x86/virt/vmx/tdx/tdx.c | 24 ++++++++++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  1 +
 3 files changed, 33 insertions(+)

diff --git a/arch/x86/include/asm/tdx.h b/arch/x86/include/asm/tdx.h
index f92850789193..d1891e099d42 100644
--- a/arch/x86/include/asm/tdx.h
+++ b/arch/x86/include/asm/tdx.h
@@ -15,6 +15,7 @@
 /* Bit definitions of TDX_FEATURES0 metadata field */
 #define TDX_FEATURES0_NO_RBP_MOD		BIT_ULL(18)
 #define TDX_FEATURES0_DYNAMIC_PAMT		BIT_ULL(36)
+#define TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY	BIT_ULL(51)
 
 #ifndef __ASSEMBLER__
 
@@ -140,6 +141,11 @@ static inline bool tdx_supports_dynamic_pamt(const struct tdx_sys_info *sysinfo)
 	return sysinfo->features.tdx_features0 & TDX_FEATURES0_DYNAMIC_PAMT;
 }
 
+static inline bool tdx_supports_demote_nointerrupt(const struct tdx_sys_info *sysinfo)
+{
+	return sysinfo->features.tdx_features0 & TDX_FEATURES0_ENHANCE_DEMOTE_INTERRUPTIBILITY;
+}
+
 void tdx_quirk_reset_page(struct page *page);
 
 int tdx_guest_keyid_alloc(void);
@@ -242,6 +248,8 @@ u64 tdh_mng_key_config(struct tdx_td *td);
 u64 tdh_mng_create(struct tdx_td *td, u16 hkid);
 u64 tdh_vp_create(struct tdx_td *td, struct tdx_vp *vp);
 u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data);
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
+			u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_extend(struct tdx_td *td, u64 gpa, u64 *ext_err1, u64 *ext_err2);
 u64 tdh_mr_finalize(struct tdx_td *td);
 u64 tdh_vp_flush(struct tdx_vp *vp);
diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 41ce18619ffc..c3f4457816c8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -1837,6 +1837,30 @@ u64 tdh_mng_rd(struct tdx_td *td, u64 field, u64 *data)
 }
 EXPORT_SYMBOL_GPL(tdh_mng_rd);
 
+u64 tdh_mem_page_demote(struct tdx_td *td, u64 gpa, int level, struct page *new_sept_page,
+			u64 *ext_err1, u64 *ext_err2)
+{
+	struct tdx_module_args args = {
+		.rcx = gpa | level,
+		.rdx = tdx_tdr_pa(td),
+		.r8 = page_to_phys(new_sept_page),
+	};
+	u64 ret;
+
+	if (!tdx_supports_demote_nointerrupt(&tdx_sysinfo))
+		return TDX_SW_ERROR;
+
+	/* Flush the new S-EPT page to be added */
+	tdx_clflush_page(new_sept_page);
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


