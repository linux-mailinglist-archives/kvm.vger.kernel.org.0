Return-Path: <kvm+bounces-29846-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 42B839B30A1
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 13:44:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EE1611F2115F
	for <lists+kvm@lfdr.de>; Mon, 28 Oct 2024 12:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 744241DE3AD;
	Mon, 28 Oct 2024 12:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Lj0PLHMx"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A09731DB928;
	Mon, 28 Oct 2024 12:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730119324; cv=none; b=C0cEHbliFB7FysBE2+Ipe+pa16e8dDqi/w+BZHs+OWQEA346RhZSxhgu4H/AlJuua/pHTwxeLKimzA9Nj+rb0jZU+Kt/twWCiAsTlSx4gzRPmknfUlaT6O3Zg1SMryrf903JwF02m9W8gciMp1y1jCjne4nM7ixIdyz4qf8EJsg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730119324; c=relaxed/simple;
	bh=ABw0Iwtci0YbpGCDFcIVRoTXAdbHHIpdCy45me/TrPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MjeIo539hQz+mAXjpppAT6gPAQjDgwPy3rLCy/SDLvWm475q8ygH/+Wq6Jdm0xrKfp6s6cviaxLflRQ9wFMFJeH6et17tnZNGF034+midR0fdDzQcQo3gRSsjbUmtSgsiRTGixmdGodNV9QOJQ52pkCaBeFGMvJyBFWNsMS2ixA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Lj0PLHMx; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730119323; x=1761655323;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ABw0Iwtci0YbpGCDFcIVRoTXAdbHHIpdCy45me/TrPo=;
  b=Lj0PLHMxfjokHNxG4+DmgzdKKFCk1bPAF6AqvJThS+6u/cfWXVNDb2Ci
   pQSIQW/toRJCIG7lHVEvCod7WUXF7vwQ6Zn/SAcdVGGiqCP71p60e4nRJ
   E5Q1fVqh+8n0Lc1TuY1PdVHPCMpWX2gCoRoc0Ysu7dHFqBphVD9KKYWek
   f5Im7Wo00QFcxFFODUpkkWw7mqNKrjpbJpvFGayLo/UrN3/QH3vEi/qQ2
   likI89tgYsq1+Ald6hGZ5d2s7Ksu8wVmOlOUuxtyLfiwgXTGlYG4Bn2DT
   nFyHgqZHDQRlDNQ7pYtjdYw0uSet0lAMdhet2dUrlIoGNeC8b7A0ypnEN
   A==;
X-CSE-ConnectionGUID: +EfKZGilS4KPyMop9lcN0w==
X-CSE-MsgGUID: ioqMaLKwRECycv90sCZK2A==
X-IronPort-AV: E=McAfee;i="6700,10204,11238"; a="32575335"
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="32575335"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:42:02 -0700
X-CSE-ConnectionGUID: 66w5aZ4qTGOKVEEqOSbLbQ==
X-CSE-MsgGUID: IOy+vvxyQyGJElHyBj9r8g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,239,1725346800"; 
   d="scan'208";a="82420951"
Received: from gargmani-mobl1.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.169])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Oct 2024 05:41:58 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	tglx@linutronix.de,
	bp@alien8.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	dan.j.williams@intel.com,
	seanjc@google.com,
	pbonzini@redhat.com
Cc: x86@kernel.org,
	linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	adrian.hunter@intel.com,
	nik.borisov@suse.com,
	kai.huang@intel.com
Subject: [PATCH v6 09/10] x86/virt/tdx: Require the module to assert it has the NO_RBP_MOD mitigation
Date: Tue, 29 Oct 2024 01:41:11 +1300
Message-ID: <ee60708b0da775e50c49a8c569f27a96770edf64.1730118186.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <cover.1730118186.git.kai.huang@intel.com>
References: <cover.1730118186.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Old TDX modules can clobber RBP in the TDH.VP.ENTER SEAMCALL.  However
RBP is used as frame pointer in the x86_64 calling convention, and
clobbering RBP could result in bad things like being unable to unwind
the stack if any non-maskable exceptions (NMI, #MC etc) happens in that
gap.

A new "NO_RBP_MOD" feature was introduced to more recent TDX modules to
not clobber RBP.  This feature is reported in the TDX_FEATURES0 global
metadata field via bit 18.

Don't initialize the TDX module if this feature is not supported [1].

Note the bit definitions of TDX_FEATURES0 are not auto-generated in
tdx_global_metadata.h.  Manually define a macro for it in "tdx.h".

Link: https://lore.kernel.org/all/fc0e8ab7-86d4-4428-be31-82e1ece6dd21@intel.com/ [1]
Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
---
 arch/x86/virt/vmx/tdx/tdx.c | 17 +++++++++++++++++
 arch/x86/virt/vmx/tdx/tdx.h |  4 ++++
 2 files changed, 21 insertions(+)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 9acb12c75e9b..9bc827a6cee8 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -326,6 +326,18 @@ static int init_tdx_sys_info(struct tdx_sys_info *sysinfo)
 	return 0;
 }
 
+static int check_features(struct tdx_sys_info *sysinfo)
+{
+	u64 tdx_features0 = sysinfo->features.tdx_features0;
+
+	if (!(tdx_features0 & TDX_FEATURES0_NO_RBP_MOD)) {
+		pr_err("frame pointer (RBP) clobber bug present, upgrade TDX module\n");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 /* Calculate the actual TDMR size */
 static int tdmr_size_single(u16 max_reserved_per_tdmr)
 {
@@ -1109,6 +1121,11 @@ static int init_tdx_module(void)
 	if (ret)
 		return ret;
 
+	/* Check whether the kernel can support this module */
+	ret = check_features(&sysinfo);
+	if (ret)
+		return ret;
+
 	/*
 	 * To keep things simple, assume that all TDX-protected memory
 	 * will come from the page allocator.  Make sure all pages in the
diff --git a/arch/x86/virt/vmx/tdx/tdx.h b/arch/x86/virt/vmx/tdx/tdx.h
index 0128b963b723..c8be00f6b15a 100644
--- a/arch/x86/virt/vmx/tdx/tdx.h
+++ b/arch/x86/virt/vmx/tdx/tdx.h
@@ -5,6 +5,7 @@
 #include <linux/types.h>
 #include <linux/compiler_attributes.h>
 #include <linux/stddef.h>
+#include <linux/bits.h>
 #include "tdx_global_metadata.h"
 
 /*
@@ -54,6 +55,9 @@ struct tdmr_info {
 	DECLARE_FLEX_ARRAY(struct tdmr_reserved_area, reserved_areas);
 } __packed __aligned(TDMR_INFO_ALIGNMENT);
 
+/* Bit definitions of TDX_FEATURES0 metadata field */
+#define TDX_FEATURES0_NO_RBP_MOD	BIT(18)
+
 /*
  * Do not put any hardware-defined TDX structure representations below
  * this comment!
-- 
2.46.2


