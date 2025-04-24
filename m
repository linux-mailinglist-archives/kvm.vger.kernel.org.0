Return-Path: <kvm+bounces-44036-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 090E7A99F44
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 05:08:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 16F853B90C9
	for <lists+kvm@lfdr.de>; Thu, 24 Apr 2025 03:07:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFB6E1AF0CE;
	Thu, 24 Apr 2025 03:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YfMDGrZm"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 919181A0BFD;
	Thu, 24 Apr 2025 03:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745464047; cv=none; b=cTu3q5HQVATaZLLg+aumpyBu/q8rrZUDOnaxM/28xDWOdkX9w3GcizPXyv0XfcCav+MXLyDwhZ6ng+egq6h5L96ZR0chAqRETr5Nfn6U8QzpMyHGy35pn270VudwqEyboy5u/CiyZag3rquMV5dl1/9ynQA9R9qeV7pPPnBOxsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745464047; c=relaxed/simple;
	bh=7ektOoGTPqcZ1dKY9HISpf5rtY/A8ic7EDQP03OWPzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TumhN2leNCM+QRevXPEBXeM+srDHJDlO7WfZiYXENsprJaHJ3/UoUuu66mHtYnVxHqoIonrssoN+vtVYXh/nR0gpRaMQUBV0GixbLuXDX5/MIsdKaeNgM9NIQefhfUx5TMm5ITAZ9X273VzDx4tcGBT/xNnRyTRlcVoXH0mliho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YfMDGrZm; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1745464045; x=1777000045;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=7ektOoGTPqcZ1dKY9HISpf5rtY/A8ic7EDQP03OWPzg=;
  b=YfMDGrZmjNBzQ02Wk6kJYwIHtYc/IdPmXGKSqND8g52ptBbD+HqubVcy
   Fnwu8mmTEP9MlxYX1NvsRxttpvGegFE9JoJmpWxe/VyLpL7f2D63qIQ6X
   /71Zc0UYMt7H7GKsJ8+Iw+f0lI+XIcDxDpxaaiK0c4bvdFVSPgfh9nQAK
   mQMZh3lJlqdiORYCCRP9tsBg+bI8WJWO9/aambuCL+f6EPNQhYiDe9+nv
   OeqSdez4SIPf5UlxNlDQOMv/IIflJE/nh3FSoMIKSyeY9L+azsna9kyQI
   H9O0IebEL4gbdOGOzViAIP9OHBd03qDUHAbfNMbTpi5X20iqKTIZ/cvVO
   w==;
X-CSE-ConnectionGUID: ftMy253SSYC0rHgNuy9P/Q==
X-CSE-MsgGUID: /Q29S5ogRXC4ckS6bEHCAQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11412"; a="64491265"
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="64491265"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:25 -0700
X-CSE-ConnectionGUID: F5TtEDQJSD6S02a55wRMsw==
X-CSE-MsgGUID: bpJ1Z5gpTSGa7S71cgzqWA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,233,1739865600"; 
   d="scan'208";a="136564803"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2025 20:07:19 -0700
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com
Cc: linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org,
	x86@kernel.org,
	rick.p.edgecombe@intel.com,
	dave.hansen@intel.com,
	kirill.shutemov@intel.com,
	tabba@google.com,
	ackerleytng@google.com,
	quic_eberman@quicinc.com,
	michael.roth@amd.com,
	david@redhat.com,
	vannapurve@google.com,
	vbabka@suse.cz,
	jroedel@suse.de,
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
	Yan Zhao <yan.y.zhao@intel.com>
Subject: [RFC PATCH 06/21] KVM: TDX: Assert the reclaimed pages were mapped as expected
Date: Thu, 24 Apr 2025 11:05:32 +0800
Message-ID: <20250424030532.32756-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250424030033.32635-1-yan.y.zhao@intel.com>
References: <20250424030033.32635-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Xiaoyao Li <xiaoyao.li@intel.com>

Provide level information to tdx_reclaim_page() to enable it to verify that
the reclaimed pages were mapped at the expected level in the S-EPT.

[Yan: split patch, wrote patch log]

Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Signed-off-by: Isaku Yamahata <isaku.yamahata@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 1186085795ac..69f3140928b5 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -325,7 +325,7 @@ static void tdx_no_vcpus_enter_stop(struct kvm *kvm)
 }
 
 /* TDH.PHYMEM.PAGE.RECLAIM is allowed only when destroying the TD. */
-static int __tdx_reclaim_page(struct page *page)
+static int __tdx_reclaim_page(struct page *page, int level)
 {
 	u64 err, tdx_pt, tdx_owner, tdx_size;
 
@@ -340,16 +340,18 @@ static int __tdx_reclaim_page(struct page *page)
 		pr_tdx_error_3(TDH_PHYMEM_PAGE_RECLAIM, err, tdx_pt, tdx_owner, tdx_size);
 		return -EIO;
 	}
+
+	WARN_ON_ONCE(tdx_size != pg_level_to_tdx_sept_level(level));
 	return 0;
 }
 
-static int tdx_reclaim_page(struct page *page)
+static int tdx_reclaim_page(struct page *page, int level)
 {
 	int r;
 
-	r = __tdx_reclaim_page(page);
+	r = __tdx_reclaim_page(page, level);
 	if (!r)
-		tdx_clear_page(page, PG_LEVEL_4K);
+		tdx_clear_page(page, level);
 	return r;
 }
 
@@ -364,7 +366,7 @@ static void tdx_reclaim_control_page(struct page *ctrl_page)
 	 * Leak the page if the kernel failed to reclaim the page.
 	 * The kernel cannot use it safely anymore.
 	 */
-	if (tdx_reclaim_page(ctrl_page))
+	if (tdx_reclaim_page(ctrl_page, PG_LEVEL_4K))
 		return;
 
 	__free_page(ctrl_page);
@@ -583,7 +585,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	if (!kvm_tdx->td.tdr_page)
 		return;
 
-	if (__tdx_reclaim_page(kvm_tdx->td.tdr_page))
+	if (__tdx_reclaim_page(kvm_tdx->td.tdr_page, PG_LEVEL_4K))
 		return;
 
 	/*
@@ -1791,7 +1793,7 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * The HKID assigned to this TD was already freed and cache was
 	 * already flushed. We don't have to flush again.
 	 */
-	return tdx_reclaim_page(virt_to_page(private_spt));
+	return tdx_reclaim_page(virt_to_page(private_spt), PG_LEVEL_4K);
 }
 
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-- 
2.43.2


