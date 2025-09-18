Return-Path: <kvm+bounces-58065-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE1EEB875DD
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:25:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 85B941C84733
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BDF4131CA69;
	Thu, 18 Sep 2025 23:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O6JnYW5a"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE102FF650;
	Thu, 18 Sep 2025 23:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237789; cv=none; b=LOaBCdyEfC4eOqosi0Ric8xWHhjjjIPnI90qpUrLyXGWgZV00/5LjQ0zZAFjmIOj7cO6s67RLyt6wuJByV35hi4wAYt59W87DK8VHiF27ihfP1tP4kMTvnzcTBe5ziCoAHZErVRu8pdMiLWxgy93JOczbyCbNvTMR8EeWOl8xN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237789; c=relaxed/simple;
	bh=kSOvdQwxFMWACuUBaeNSxKEatdu/jckibsmXgrsPeYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HqrbnPq/UYsen1s629jfYaW/Cv6OcLd8t3pgCerJ0WPAY/ByCuiMMFNvnfYTgzxqu7BhSu8N61qaxR34eilxL1VB1Kz0tJmylLD3VFZcUfJdjZFV67pW7g3WZftkajpsk5Dp47o38ph4lXJfI9KBrY/+M81HE2J10pItArtqE2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O6JnYW5a; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237786; x=1789773786;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kSOvdQwxFMWACuUBaeNSxKEatdu/jckibsmXgrsPeYY=;
  b=O6JnYW5ardBuitbOexR4tsLdmvHtvLRIUkd2NkwOW3m46r2TLK1fpu+h
   uaEV/jppaUnZn1BEIsVKPRbxEz9NG9nrqOzCjWYk7sMAMf4p8eDoCSe6D
   V4Bl8fDXPMrE1x61DequIJw9JKVICdhT1LUOguydiuMoBF4qRsgvzEPsv
   gnD/ynN+c4FOvWb4WqJ58C5QsiDIrwVK1zK7CJHjsB40cLGo5y/hRLsFH
   6TUKySd9DnROQO6hcsKsfF1r3Eo5UIdIQHuU+oq0YbYa3lVSbEVParXm+
   ZkT+CLKlNwJc2XMwa3oZWYJVv9AC/q5I5HyFH0UEDKFdONtRNBPkwRNQF
   A==;
X-CSE-ConnectionGUID: mF4QeEXnQcGO/RyBafQycQ==
X-CSE-MsgGUID: O6T+v9esQlKkOME+os/GmA==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735425"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735425"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:04 -0700
X-CSE-ConnectionGUID: 9P0nw3o5SMq/r57ZUv9xbQ==
X-CSE-MsgGUID: KtGxemzQTJSgRijgC6Pa/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491429"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:03 -0700
From: Rick Edgecombe <rick.p.edgecombe@intel.com>
To: kas@kernel.org,
	bp@alien8.de,
	chao.gao@intel.com,
	dave.hansen@linux.intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	kvm@vger.kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	mingo@redhat.com,
	pbonzini@redhat.com,
	seanjc@google.com,
	tglx@linutronix.de,
	x86@kernel.org,
	yan.y.zhao@intel.com,
	vannapurve@google.com
Cc: rick.p.edgecombe@intel.com,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCH v3 09/16] KVM: TDX: Allocate PAMT memory for TD control structures
Date: Thu, 18 Sep 2025 16:22:17 -0700
Message-ID: <20250918232224.2202592-10-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

TDX TD control structures are provided to the TDX module at 4KB page size
and require PAMT backing. This means for Dynamic PAMT they need to also
have 4KB backings installed.

Previous changes introduced tdx_alloc_page()/tdx_free_page() that can
allocate a page and automatically handle the DPAMT maintenance. Use them
for vCPU control structures instead of alloc_page()/__free_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[update log]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Write log. Rename from “KVM: TDX: Allocate PAMT memory in __tdx_td_init()”
---
 arch/x86/kvm/vmx/tdx.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a952c7b6a22d..40c2730ea2ac 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2482,7 +2482,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 	atomic_inc(&nr_configured_hkid);
 
-	tdr_page = alloc_page(GFP_KERNEL);
+	tdr_page = tdx_alloc_page();
 	if (!tdr_page)
 		goto free_hkid;
 
@@ -2495,7 +2495,7 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 		goto free_tdr;
 
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		tdcs_pages[i] = alloc_page(GFP_KERNEL);
+		tdcs_pages[i] = tdx_alloc_page();
 		if (!tdcs_pages[i])
 			goto free_tdcs;
 	}
@@ -2616,10 +2616,8 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 teardown:
 	/* Only free pages not yet added, so start at 'i' */
 	for (; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		if (tdcs_pages[i]) {
-			__free_page(tdcs_pages[i]);
-			tdcs_pages[i] = NULL;
-		}
+		tdx_free_page(tdcs_pages[i]);
+		tdcs_pages[i] = NULL;
 	}
 	if (!kvm_tdx->td.tdcs_pages)
 		kfree(tdcs_pages);
@@ -2635,15 +2633,13 @@ static int __tdx_td_init(struct kvm *kvm, struct td_params *td_params,
 
 free_tdcs:
 	for (i = 0; i < kvm_tdx->td.tdcs_nr_pages; i++) {
-		if (tdcs_pages[i])
-			__free_page(tdcs_pages[i]);
+		tdx_free_page(tdcs_pages[i]);
 	}
 	kfree(tdcs_pages);
 	kvm_tdx->td.tdcs_pages = NULL;
 
 free_tdr:
-	if (tdr_page)
-		__free_page(tdr_page);
+	tdx_free_page(tdr_page);
 	kvm_tdx->td.tdr_page = 0;
 
 free_hkid:
-- 
2.51.0


