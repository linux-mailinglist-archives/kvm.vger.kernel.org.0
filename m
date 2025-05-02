Return-Path: <kvm+bounces-45229-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 098D1AA72FB
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 15:12:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 7C6A97B4260
	for <lists+kvm@lfdr.de>; Fri,  2 May 2025 13:10:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DA98254B1F;
	Fri,  2 May 2025 13:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lmUQ5Ows"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A068255E37;
	Fri,  2 May 2025 13:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746191333; cv=none; b=Nq5/g5aAC6tlCyy84TmS6Ct/v3n7sDw0CTz/2py3T7R6bb/2zYVgPCxcKy28YxKY1ExnNX3g1pMtRC8638G8qopjqxWm35ivhjG8dF3oWLQcGQjuHRNIXmk0xmaVZ6yfBKunKEHmhWP07YlziaFJO9C+v5CVDvBxlN395NkOy+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746191333; c=relaxed/simple;
	bh=j5Y6GYyeSlhNDi2dLeXJ+8OeWOwUzdTAtd6KqruAJps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zlh89EZ0Y03cShev8aVoKVt6XFrC7YU3fE6NCkVb/lwm2F9rg5dY3EXcD/kL2hsK70mDIp9tatRO22TrRjk5Av4+EUzpkel3gWYyDtbyHX32Y/nhH6zLxz6ha5a6zTI5D25sYJ1OpCG2wSCFMNIDMMIYC7IwCF7rMympgbl4mxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.helo=mgamail.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lmUQ5Ows; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.helo=mgamail.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1746191332; x=1777727332;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=j5Y6GYyeSlhNDi2dLeXJ+8OeWOwUzdTAtd6KqruAJps=;
  b=lmUQ5OwslejGX+aJN4uHYO25g77foDFUdO6aZyvHZEzeLpgQpEL1rDTl
   G7LDea95EDJrqKINHa7164wbahifp2yKX1HE+kgnZU+7xqFIbBAkYKUE4
   eKzxG7SGqO0gPl9GvJ9bftELW3OOQ3NImVTGgDAXCpUMMQiLaTkOHpJDK
   Fd5vxyazLcJEXGpNCihTbyOlMKsHYWkW+9H9YD7QX7xm1MEHmXTOCJl6f
   A3e6ApGw0sTn0wrGNkI5mi+qqzaicCZG2jX3n10Yd3mS9q9+nSCYRm+F3
   Dz91rOhecfCkDu0MtfrwhfHNtUeyv3f58UNxurFSXFTOSoYwmP5lb6MR6
   A==;
X-CSE-ConnectionGUID: 6SHVNk1kQo+n0HfVBjBgHA==
X-CSE-MsgGUID: erRWX5CHTN2/zhKQeg10pw==
X-IronPort-AV: E=McAfee;i="6700,10204,11421"; a="58495273"
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="58495273"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2025 06:08:51 -0700
X-CSE-ConnectionGUID: 0Z/06JEGRTaayqBgyOFGwg==
X-CSE-MsgGUID: 695OBPPCQACgw1ezPztR6w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.15,256,1739865600"; 
   d="scan'208";a="138657788"
Received: from black.fi.intel.com ([10.237.72.28])
  by fmviesa003.fm.intel.com with ESMTP; 02 May 2025 06:08:41 -0700
Received: by black.fi.intel.com (Postfix, from userid 1000)
	id 656B2325; Fri, 02 May 2025 16:08:36 +0300 (EEST)
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
Subject: [RFC, PATCH 07/12] KVM: TDX: Allocate PAMT memory in tdx_td_vcpu_init()
Date: Fri,  2 May 2025 16:08:23 +0300
Message-ID: <20250502130828.4071412-8-kirill.shutemov@linux.intel.com>
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

Allocate PAMT memory for TDH.VP.CREATE and TDH.VP.ADDCX.

PAMT memory that is associated with pages successfully added to the TD
with TDH.VP.ADDCX will be removed in tdx_reclaim_page() on
tdx_reclaim_control_page().

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 59bbae2df485..18c4ae00cd8d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -2983,7 +2983,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	int ret, i;
 	u64 err;
 
-	page = alloc_page(GFP_KERNEL);
+	page = tdx_alloc_page();
 	if (!page)
 		return -ENOMEM;
 	tdx->vp.tdvpr_page = page;
@@ -2996,7 +2996,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 	}
 
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		page = alloc_page(GFP_KERNEL);
+		page = tdx_alloc_page();
 		if (!page) {
 			ret = -ENOMEM;
 			goto free_tdcx;
@@ -3020,7 +3020,7 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 			 * method, but the rest are freed here.
 			 */
 			for (; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-				__free_page(tdx->vp.tdcx_pages[i]);
+				tdx_free_page(tdx->vp.tdcx_pages[i]);
 				tdx->vp.tdcx_pages[i] = NULL;
 			}
 			return -EIO;
@@ -3039,16 +3039,15 @@ static int tdx_td_vcpu_init(struct kvm_vcpu *vcpu, u64 vcpu_rcx)
 
 free_tdcx:
 	for (i = 0; i < kvm_tdx->td.tdcx_nr_pages; i++) {
-		if (tdx->vp.tdcx_pages[i])
-			__free_page(tdx->vp.tdcx_pages[i]);
+		tdx_free_page(tdx->vp.tdcx_pages[i]);
 		tdx->vp.tdcx_pages[i] = NULL;
 	}
 	kfree(tdx->vp.tdcx_pages);
 	tdx->vp.tdcx_pages = NULL;
 
 free_tdvpr:
-	if (tdx->vp.tdvpr_page)
-		__free_page(tdx->vp.tdvpr_page);
+	tdx_free_page(tdx->vp.tdvpr_page);
+
 	tdx->vp.tdvpr_page = 0;
 
 	return ret;
-- 
2.47.2


