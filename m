Return-Path: <kvm+bounces-67130-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F6C4CF7C8D
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:27:00 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id A14013052ECD
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:26:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 40EDE33859E;
	Tue,  6 Jan 2026 10:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VRQXSKPP"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC61337107;
	Tue,  6 Jan 2026 10:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695169; cv=none; b=m/vH2nw3kRsQNVdkhNS4AgX+96YubgjjUOjXDDVJfR9SFl5lWasMozct/S4EJwwlte4uW39xG6Wdj0qCCpxZeX9GoPxZoNXQzEsra0y5BvJ0dK637W+xF8L8YU0nxaHNlVemvMnXQSvY9s185f9lYIzFJWgaGHgZfHj7ly+OMWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695169; c=relaxed/simple;
	bh=R27r6drBHtR2cNmPgR2j0SPZdUkZTBJSOvlRidBaYAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ACcLs2QGtasb6QbJMRbmfD32r3bRk77EEAaZfI62XeINgBCOdCNjn0IrNH2UtmHqMC/3JzXGhJI7O43ZgphIRznX/NMQC7pKbMkAcUDtO69ZadRYeqpwn5YKfRgg7+kstTQtDs4oJjBRpM0NldeJJ2ZP8uZAIIU7QU+vWzXu6ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VRQXSKPP; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695166; x=1799231166;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R27r6drBHtR2cNmPgR2j0SPZdUkZTBJSOvlRidBaYAw=;
  b=VRQXSKPP3Blo1IVhvKX0h4VE/BloGSGMPrp/kC0+57d8SD0eSRkVG891
   ug1zA9zptUCLfC4tvxd7Co62sne+RBjes8dTWgUpLz9QOyE00KppgKvSM
   npFGk4wwvvJVV/3Srn2UyUOM8RbBE6fONjKfc4erzx9NvvuMVCMXKXkqd
   ar3pyT/J3tYthdM5mgGvKArR54cg1qZk7P1T/oDhfo0AArzLz7CZmNkge
   gE6ws25XnVis3Z3Dc/+t0lE8RQKY0TfCgJVf/SAshi4FQxlqO6J9RXF4J
   CVpgos6LO8ivXqlQPXMSg5jShCFmRd7s3iy5U+XQnC9DyQ1I2LYYc1mXn
   Q==;
X-CSE-ConnectionGUID: c/on4LnXRlypGZ6e6JDk7Q==
X-CSE-MsgGUID: ImHWuJLXSBCZusC5sFp3Ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="72689775"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="72689775"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:26:03 -0800
X-CSE-ConnectionGUID: GuqRtoQNTKSR1m7jxF5IIQ==
X-CSE-MsgGUID: VmDl0HO7TI++hNzksiTqUw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202645252"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:57 -0800
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
Subject: [PATCH v3 21/24] KVM: TDX: Add/Remove DPAMT pages for the new S-EPT page for splitting
Date: Tue,  6 Jan 2026 18:23:59 +0800
Message-ID: <20260106102359.25278-1-yan.y.zhao@intel.com>
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

From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>

Splitting a huge S-EPT mapping requires the host to provide a new 4KB page,
which will be added as the S-EPT page to hold smaller mappings after the
splitting. Install Dynamic PAMT page pair for the new S-EPT page before
passing the S-EPT page to tdh_mem_page_demote(); Uninstall and free the
Dynamic PAMT page pair when tdh_mem_page_demote() fails.

When Dynamic PAMT is enabled and when there's no installed pair for the 2MB
physical range containing the new S-EPT page, tdx_pamt_get() dequeues a
pair of preallocated pages from the per-VM prealloc_split_cache and
installs them as the Dynamic PAMT page pair. Hold prealloc_split_cache_lock
when dequeuing from the per-VM prealloc_split_cache.

After tdh_mem_page_demote() fails, tdx_pamt_put() uninstalls and frees the
Dynamic PAMT page pair for the new S-EPT page if Dynamic PAMT is enabled,
and the new S-EPT page is the last page in 2MB physical range requiring the
Dynamic PAMT page pair.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Co-developed-by: Yan Zhao <yan.y.zhao@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- Split out as a new patch.
- Add KVM_BUG_ON() after tdx_pamt_get() fails. (Vishal)
---
 arch/x86/kvm/vmx/tdx.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 40cca273d480..ec47bd799274 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1996,6 +1996,7 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 	struct kvm_tdx *kvm_tdx = to_kvm_tdx(kvm);
 	gpa_t gpa = gfn_to_gpa(gfn);
 	u64 err, entry, level_state;
+	int ret;
 
 	if (KVM_BUG_ON(kvm_tdx->state != TD_STATE_RUNNABLE ||
 		       level != PG_LEVEL_2M, kvm))
@@ -2014,10 +2015,18 @@ static int tdx_sept_split_private_spte(struct kvm *kvm, gfn_t gfn, enum pg_level
 
 	tdx_track(kvm);
 
+	spin_lock(&kvm_tdx->prealloc_split_cache_lock);
+	ret = tdx_pamt_get(new_sept_page, &kvm_tdx->prealloc_split_cache);
+	spin_unlock(&kvm_tdx->prealloc_split_cache_lock);
+	if (KVM_BUG_ON(ret, kvm))
+		return -EIO;
+
 	err = tdh_do_no_vcpus(tdh_mem_page_demote, kvm, &kvm_tdx->td, gpa,
 			      tdx_level, new_sept_page, &entry, &level_state);
-	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm))
+	if (TDX_BUG_ON_2(err, TDH_MEM_PAGE_DEMOTE, entry, level_state, kvm)) {
+		tdx_pamt_put(new_sept_page);
 		return -EIO;
+	}
 
 	return 0;
 }
-- 
2.43.2


