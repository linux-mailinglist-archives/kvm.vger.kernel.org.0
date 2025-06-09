Return-Path: <kvm+bounces-48761-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A24A1AD2689
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 21:16:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 536163B33EF
	for <lists+kvm@lfdr.de>; Mon,  9 Jun 2025 19:15:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46EBD224AE4;
	Mon,  9 Jun 2025 19:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FB6oOYKt"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 407EB22172B;
	Mon,  9 Jun 2025 19:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749496443; cv=none; b=RJeZxOXpTrHyMYcdFcL101GTuDoGdKMDIf/iP3JP/qJCt/3iKsjMUIb7LXTYkccc7rjLTUmeGaMMVDk1jU5SPPZyXp2e/0R80xVj32nf+q+vnTYUaoz+pwSm9nIHJLQo14z4vzf6ldDWvHbV6pDIm8q0HbsjKREX6MtiS6YiGfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749496443; c=relaxed/simple;
	bh=u3lmhKal89dtBVTIGgcT29cm7/94nRSPPgh1/WsBV+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBFIjYeV+yy1lsC5c5MD4Q/CW5s3qlkqq//nuWXaNNo8nPeYcbJ6/vvS+rnktZj5gIbkj33BuLb8cDa2YjSwA3SPI6qyFEvq+HumiE+wZq6Kf3yCXiI/djUr117rrIJNPc10OlkI8iQLwaAAABfWVYBZevW0zZmX5ubnJDcJPVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FB6oOYKt; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1749496441; x=1781032441;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=u3lmhKal89dtBVTIGgcT29cm7/94nRSPPgh1/WsBV+E=;
  b=FB6oOYKtMxXZzbXCXoXLvPRHZCsiKPNHO80gdqIt8w0bpXMxvIL6gPo6
   412elJdrhGJYNlBJ0o6qCz9f9D6qoOp3x4qCyYDIYJBc5REISN4eyD13K
   4YGDmiKQwjSTxdevk4NUptPYR1n6/Ixvg3tKy7/me0J1Z6b5dAQMXs9Gh
   asVMr6m5rnHESqFFRcpdYg+ORw+3ub1hGdzBhB8TX8d6hS8ZUxdcB9gB0
   osMZvIkRkIkcQEA/RbJQKPYcLQoecVC5PW0blUXTQog8FFpdJdlG90Iw6
   ZO8fzjCQj6KoD6v3N25m1vioL5M0M0GfYn2orfV/7LDA4nRq0wP4RaYka
   w==;
X-CSE-ConnectionGUID: 72rtDwQeSkC/QeusAovSsQ==
X-CSE-MsgGUID: WhWEE223RMOra83FaWbpWA==
X-IronPort-AV: E=McAfee;i="6800,10657,11459"; a="51681796"
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="51681796"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2025 12:14:00 -0700
X-CSE-ConnectionGUID: Wz46xy/GRjWvuiwx4+4Tvw==
X-CSE-MsgGUID: pkpBkGgeS6quvNIqDLH6/w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.16,223,1744095600"; 
   d="scan'208";a="147174193"
Received: from black.fi.intel.com ([10.237.72.28])
  by orviesa007.jf.intel.com with ESMTP; 09 Jun 2025 12:13:56 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 66C62286; Mon, 09 Jun 2025 22:13:49 +0300 (EEST)
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	dave.hansen@linux.intel.com
Cc: rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	kai.huang@intel.com,
	yan.y.zhao@intel.com,
	chao.gao@intel.com,
	tglx@linutronix.de,
	mingo@redhat.com,
	bp@alien8.de,
	kvm@vger.kernel.org,
	x86@kernel.org,
	linux-coco@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	"Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: [PATCHv2 09/12] KVM: TDX: Reclaim PAMT memory
Date: Mon,  9 Jun 2025 22:13:37 +0300
Message-ID: <20250609191340.2051741-10-kirill.shutemov@linux.intel.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
References: <20250609191340.2051741-1-kirill.shutemov@linux.intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
---
 arch/x86/kvm/vmx/tdx.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index bc9bc393f866..0aed7e73cd6b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -353,7 +353,7 @@ static void tdx_reclaim_control_page(struct page *ctrl_page)
 	if (tdx_reclaim_page(ctrl_page))
 		return;
 
-	__free_page(ctrl_page);
+	tdx_free_page(ctrl_page);
 }
 
 struct tdx_flush_vp_arg {
@@ -584,7 +584,7 @@ static void tdx_reclaim_td_control_pages(struct kvm *kvm)
 	}
 	tdx_clear_page(kvm_tdx->td.tdr_page);
 
-	__free_page(kvm_tdx->td.tdr_page);
+	tdx_free_page(kvm_tdx->td.tdr_page);
 	kvm_tdx->td.tdr_page = NULL;
 }
 
@@ -1635,6 +1635,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 	tdx_clear_page(page);
+	tdx_pamt_put(page, level);
 	tdx_unpin(kvm, page);
 	return 0;
 }
@@ -1724,6 +1725,7 @@ static int tdx_sept_zap_private_spte(struct kvm *kvm, gfn_t gfn,
 	if (tdx_is_sept_zap_err_due_to_premap(kvm_tdx, err, entry, level) &&
 	    !KVM_BUG_ON(!atomic64_read(&kvm_tdx->nr_premapped), kvm)) {
 		atomic64_dec(&kvm_tdx->nr_premapped);
+		tdx_pamt_put(page, level);
 		tdx_unpin(kvm, page);
 		return 0;
 	}
@@ -1788,6 +1790,8 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 			      enum pg_level level, void *private_spt)
 {
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
+	struct page *page = virt_to_page(private_spt);
+	int ret;
 
 	/*
 	 * free_external_spt() is only called after hkid is freed when TD is
@@ -1804,7 +1808,12 @@ int tdx_sept_free_private_spt(struct kvm *kvm, gfn_t gfn,
 	 * The HKID assigned to this TD was already freed and cache was
 	 * already flushed. We don't have to flush again.
 	 */
-	return tdx_reclaim_page(virt_to_page(private_spt));
+	ret = tdx_reclaim_page(virt_to_page(private_spt));
+	if (ret)
+		return ret;
+
+	tdx_pamt_put(page, PG_LEVEL_4K);
+	return 0;
 }
 
 int tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
-- 
2.47.2


