Return-Path: <kvm+bounces-58068-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43521B875E9
	for <lists+kvm@lfdr.de>; Fri, 19 Sep 2025 01:26:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17BB85674D8
	for <lists+kvm@lfdr.de>; Thu, 18 Sep 2025 23:26:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14ED4320A02;
	Thu, 18 Sep 2025 23:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="huy3aIzD"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3971E31B807;
	Thu, 18 Sep 2025 23:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758237792; cv=none; b=QB9crAbyrWksvC5z2YfSz4RCYa7DH39CyrBXc1udk+Q+mDAT/g7YsM9l6nZWG+ccbPcCIaNK0/1NyH1mJ+VG+zsetDjO3F8Bm3P0dJ0pgIR3WqMTYSBiLwYJC0XJvJQdSe7cs3hjZxP+00RCUg/bzxqOmrya14akp+U07BBv0q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758237792; c=relaxed/simple;
	bh=zQa1gVvX8SKHt812l5UOOOq89JmBX88EN0t+rNXFQ8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tb1c8mOhsvurixnq/yAwgRuWR1cnABeQ+ExuQIY1UMNuOrswIXxzeB2r/S7xq4DP46bWMciUPh3BvYTC4aRO8Nu1ltvYr/xVY1mSI+nmgtWu384wQUtWq2336oLy6y/l9J8aRE+RCwKOUiLQl4hCABGSRJhS/qas2WK3Ec/bQUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=huy3aIzD; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1758237790; x=1789773790;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zQa1gVvX8SKHt812l5UOOOq89JmBX88EN0t+rNXFQ8I=;
  b=huy3aIzD3F1DpDiwwKpVf/hCv8m/PFeoxBaP+N3ySmp+p2VORglxmPIV
   UJVsovEShfcuGWCHCz74V9uTms8wrzHT5nDML359V4YOdeXddKjPcOt3V
   lolYvNQcuRSrvI2Oe07/MIt5c9iFgqIXXiDAquTzlpdmTMW7dw7pwq0vy
   igKx1ura76zjguOJVzcMujHuniWJex944+hgvJLIysfbFmGtH3bSMn8tX
   aRVRo9VfIbNIABA/vEA4SEqIBW9S4HAwJFllRQtzRIlXEuMYOIXVv/b8j
   AOgjK2Nj/dV1as/yAzYISjwAfJBf08pajHgw/A0d2yoS7rp1mIAJXGTml
   A==;
X-CSE-ConnectionGUID: B+gB6H/WRTeBfpSCU8RcEg==
X-CSE-MsgGUID: zVHua6/fTJmbiH32kp2ogA==
X-IronPort-AV: E=McAfee;i="6800,10657,11557"; a="60735465"
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="60735465"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:07 -0700
X-CSE-ConnectionGUID: p0lCZa9dT6+BFFSis1oS0Q==
X-CSE-MsgGUID: 7v03l9gJSzmBqS4+vAiHew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,276,1751266800"; 
   d="scan'208";a="176491472"
Received: from rpedgeco-desk.jf.intel.com ([10.88.27.139])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Sep 2025 16:23:05 -0700
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
Subject: [PATCH v3 14/16] KVM: TDX: Reclaim PAMT memory
Date: Thu, 18 Sep 2025 16:22:22 -0700
Message-ID: <20250918232224.2202592-15-rick.p.edgecombe@intel.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
References: <20250918232224.2202592-1-rick.p.edgecombe@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Call tdx_free_page() and tdx_pamt_put() on the paths that free TDX
pages.

The PAMT memory holds metadata for TDX-protected memory. With Dynamic
PAMT, PAMT_4K is allocated on demand. The kernel supplies the TDX module
with a few pages that cover 2M of host physical memory.

PAMT memory can be reclaimed when the last user is gone. It can happen
in a few code paths:

- On TDH.PHYMEM.PAGE.RECLAIM in tdx_reclaim_td_control_pages() and
  tdx_reclaim_page().

- On TDH.MEM.PAGE.REMOVE in tdx_sept_drop_private_spte().

- In tdx_sept_zap_private_spte() for pages that were in the queue to be
  added with TDH.MEM.PAGE.ADD, but it never happened due to an error.

- In tdx_sept_free_private_spt() for SEPT pages;

Add tdx_pamt_put() for memory that comes from guest_memfd and use
tdx_free_page() for the rest.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Minor log tweak]
Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
---
v3:
 - Minor log tweak to conform kvm/x86 style.
---
 arch/x86/kvm/vmx/tdx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index a55a95558557..9ee8f7f60acd 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -358,7 +358,7 @@ static void tdx_reclaim_control_page(struct page *ctrl_page)
 	if (tdx_reclaim_page(ctrl_page))
 		return;
 
-	__free_page(ctrl_page);
+	tdx_free_page(ctrl_page);
 }
 
 struct tdx_flush_vp_arg {
@@ -589,7 +589,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	}
 	tdx_clear_page(kvm_tdx->td.tdr_page);
 
-	__free_page(kvm_tdx->td.tdr_page);
+	tdx_free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
 }
 
@@ -1759,6 +1759,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 	tdx_clear_page(page);
+	tdx_pamt_put(page);
 	tdx_unpin(kvm, page);
 	return 0;
 }
@@ -1852,6 +1853,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
+		tdx_pamt_put(page);
 		tdx_unpin(kvm, page);
 		return 0;
 	}
@@ -1916,6 +1918,8 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 				     enum pg_level level, void *private_spt)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct page *page = virt_to_page(private_spt);
+	int ret;
 
 	/*
 	 * free_external_spt() is only called after hkid is freed when TD is
@@ -1932,7 +1936,12 @@ static int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * The HKID assigned to this TD was already freed and cache was
 	 * already flushed. We don't have to flush again.
 	 */
-	return tdx_reclaim_page(virt_to_page(private_spt));
+	ret = tdx_reclaim_page(virt_to_page(private_spt));
+	if (ret)
+		return ret;
+
+	tdx_pamt_put(page);
+	return 0;
 }
 
 static int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-- 
2.51.0


