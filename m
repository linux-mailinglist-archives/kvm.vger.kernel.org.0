Return-Path: <kvm+bounces-55004-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 31B25B2C8E4
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 17:59:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2FA23563634
	for <lists+kvm@lfdr.de>; Tue, 19 Aug 2025 15:59:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 90ACF2C15A9;
	Tue, 19 Aug 2025 15:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="kk2qV+P4"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F417EAD7;
	Tue, 19 Aug 2025 15:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755619119; cv=none; b=nK94GTknYbZHt5VKQStmw3qOW0Vo4FcQxN+nA0Z8WA4cNu1FxsS/2ii9HHUm4JT2DF0wouyFbHsudrD4UoyeqhLNNGnX+ODXcp0mAXzUU0XRKjD/+ncDg2Z9IWzfYH9m2b5M+8WOehnA73Njl0sjgY6SyFhMgQQrqqbut79uiDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755619119; c=relaxed/simple;
	bh=MPrcO8lyQe7sgyWAVYrEtyh+5tZtOWdODgZDUjOWtcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pQjwtqMVfgIHoGJUU6iW5Z4E5OTUmT2xRABbCNkP6ydi1bD+rl2qdckR0u5f18wN/J7m4kwXSze/eFJPs9Wd4nRXqt37tL3vQJfBLXScYBERI/u008reSse36dUAyk/KFTIzQyrILIjfwaE97ooTXGF1wMw7zBVZY50K7mZuJC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=kk2qV+P4; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1755619118; x=1787155118;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MPrcO8lyQe7sgyWAVYrEtyh+5tZtOWdODgZDUjOWtcA=;
  b=kk2qV+P4NPQX6xERP4Nu/aGyfXjXfbrq69D4U9pstxUKlm4Zm8uDByiy
   U9vsRjUHgKtlSAZ0nUsgPsUeFFCrnNErCjIYutZdQ1b6lK23LatoAWHAI
   fog5dBBsSyjeVSV1gAjygT7nNBFsrAC+bYexWuFF6cV20XEZWtteNr4pa
   pxIE21UPgnF8ih1yDYiGS/ALwi/4hUWX7/xyxLR+Pf7ihB14xGpB8/DM1
   vRJn2k6VygO6sRZyYT3PoKkYKZfW9bjsfW0Oi8EEIgrVqLopn4CCcu4cB
   /DbTyVIC/YPSIfak6N+pwS7QC6TIdguVeZYM2MEt8f28CqfnZI8Vme9lc
   g==;
X-CSE-ConnectionGUID: o7m8bWmEQK2KftSImHMBJA==
X-CSE-MsgGUID: KKAMKrj5T/azgi++C1njvA==
X-IronPort-AV: E=McAfee;i="6800,10657,11527"; a="57780331"
X-IronPort-AV: E=Sophos;i="6.17,302,1747724400"; 
   d="scan'208";a="57780331"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:58:38 -0700
X-CSE-ConnectionGUID: Muoq7ySSTPm6WK18N8PQbA==
X-CSE-MsgGUID: n9fEDVw6Qty2yHUHLrS6NQ==
X-ExtLoop1: 1
Received: from cpetruta-mobl1.ger.corp.intel.com (HELO localhost.localdomain) ([10.245.244.66])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2025 08:58:31 -0700
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
	kas@kernel.org,
	kai.huang@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@linux.intel.com,
	binbin.wu@linux.intel.com,
	isaku.yamahata@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com
Subject: [PATCH V7 2/3] x86/tdx: Tidy reset_pamt functions
Date: Tue, 19 Aug 2025 18:58:10 +0300
Message-ID: <20250819155811.136099-3-adrian.hunter@intel.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250819155811.136099-1-adrian.hunter@intel.com>
References: <20250819155811.136099-1-adrian.hunter@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Organization: Intel Finland Oy, Registered Address: c/o Alberga Business Park, 6 krs, Bertel Jungin Aukio 5, 02600 Espoo, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Content-Transfer-Encoding: 8bit

tdx_quirk_reset_paddr() was renamed to reflect that, in fact, the clearing
is necessary only for hardware with a certain quirk.  That is dealt with in
a subsequent patch.

Rename reset_pamt functions to contain "quirk" to reflect the new
functionality, and remove the now misleading comment.

Reviewed-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Acked-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Binbin Wu <binbin.wu@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---


Changes in V7:

	Add Rick's Rev'd-by
	Add Kai's Ack
	Add Binbin's Rev'd-by

Changes in V6:

	None

Changes in V5:

	New patch


 arch/x86/virt/vmx/tdx/tdx.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index fc8d8e444f15..9e4638f68ba0 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -660,17 +660,17 @@ void tdx_quirk_reset_page(struct page *page)
 }
 EXPORT_SYMBOL_GPL(tdx_quirk_reset_page);
 
-static void tdmr_reset_pamt(struct tdmr_info *tdmr)
+static void tdmr_quirk_reset_pamt(struct tdmr_info *tdmr)
 {
 	tdmr_do_pamt_func(tdmr, tdx_quirk_reset_paddr);
 }
 
-static void tdmrs_reset_pamt_all(struct tdmr_info_list *tdmr_list)
+static void tdmrs_quirk_reset_pamt_all(struct tdmr_info_list *tdmr_list)
 {
 	int i;
 
 	for (i = 0; i < tdmr_list->nr_consumed_tdmrs; i++)
-		tdmr_reset_pamt(tdmr_entry(tdmr_list, i));
+		tdmr_quirk_reset_pamt(tdmr_entry(tdmr_list, i));
 }
 
 static unsigned long tdmrs_count_pamt_kb(struct tdmr_info_list *tdmr_list)
@@ -1142,15 +1142,7 @@ static int init_tdx_module(void)
 	 * to the kernel.
 	 */
 	wbinvd_on_all_cpus();
-	/*
-	 * According to the TDX hardware spec, if the platform
-	 * doesn't have the "partial write machine check"
-	 * erratum, any kernel read/write will never cause #MC
-	 * in kernel space, thus it's OK to not convert PAMTs
-	 * back to normal.  But do the conversion anyway here
-	 * as suggested by the TDX spec.
-	 */
-	tdmrs_reset_pamt_all(&tdx_tdmr_list);
+	tdmrs_quirk_reset_pamt_all(&tdx_tdmr_list);
 err_free_pamts:
 	tdmrs_free_pamt_all(&tdx_tdmr_list);
 err_free_tdmrs:
-- 
2.48.1


