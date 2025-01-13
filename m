Return-Path: <kvm+bounces-35263-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 18180A0AD58
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 03:14:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 381091884B0D
	for <lists+kvm@lfdr.de>; Mon, 13 Jan 2025 02:14:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1732585947;
	Mon, 13 Jan 2025 02:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="b5UIqp0o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 559A585260;
	Mon, 13 Jan 2025 02:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736734447; cv=none; b=pfv+HSjcfffxIQvTM6hV/Td2R39lFCnmL/LNEYa45+AuojIx1Y5E3BY+FpefhLeezxuR0VK8KZ3ZHCyzhiG4w/yEc67AKR3SGgJcYdos59zJU65ULqFN5Skzdc2SapkTmxl3XkaVuBbqCvrOtIG49nPWKYP4JxXgrfuBaYKG8EU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736734447; c=relaxed/simple;
	bh=fSS+3wCmxy194LJIkPkwm+250byWmhWkyg6/QZ2Kofw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXpmvYTyKTBH784pd/C+Cybm1HJyspEo8096uSRSgxmvmtaobRroLfHoUWcOwFqubNuuvEaREYEh3lDZ0svr7zxtSVxPWZ0Looni430Dm3NGOuQS+CN5PuU6R4avszQMMMyvbyGwo1Pv4MyzB9xNbMiujOVJrb74MuffFI/ujjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=b5UIqp0o; arc=none smtp.client-ip=198.175.65.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1736734445; x=1768270445;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fSS+3wCmxy194LJIkPkwm+250byWmhWkyg6/QZ2Kofw=;
  b=b5UIqp0o+p1IAv3cWFSqzDjznmyoxuT/FnT/uq3Saa3+aXzeIcrI7+Em
   VO9DE9MHQGRf521EeBH/2gbGQJxZkahbFQndjWUPq5a+di459o0ozp7Tg
   aYYDOCLEID65UoM2SMBvGoqDBbdmBXUVJt010BngJamWMp8ZXlR3sGYaU
   N3i0yFZqxJL6Qxgd7A6hJ+GknlsK7aYCg9NChiRNnIicjqpwQjRkidptg
   V/2g8GyXy786MiFrR10+0Tl80AYMlSqbc9UY7AnpFXLt4QzRXvmS21dCb
   +kHAzkMY/V7VrD3ehcJOK/qvkgc0qZD14cjEm9+po3lOJCFC9ucdbQkE5
   A==;
X-CSE-ConnectionGUID: /B30AeQdRj2XbeM78atU+A==
X-CSE-MsgGUID: tKzpDerfQWuDxVm7E2f1dg==
X-IronPort-AV: E=McAfee;i="6700,10204,11313"; a="36996175"
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="36996175"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:14:05 -0800
X-CSE-ConnectionGUID: h+IocwMlRgKw31HiqiKZ2w==
X-CSE-MsgGUID: LCzFuU9aRquYlfLfJOmL9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,310,1728975600"; 
   d="scan'208";a="104896531"
Received: from yzhao56-desk.sh.intel.com ([10.239.159.62])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2025 18:13:59 -0800
From: Yan Zhao <yan.y.zhao@intel.com>
To: pbonzini@redhat.com,
	seanjc@google.com,
	kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	kai.huang@intel.com,
	adrian.hunter@intel.com,
	reinette.chatre@intel.com,
	xiaoyao.li@intel.com,
	tony.lindgren@intel.com,
	binbin.wu@linux.intel.com,
	dmatlack@google.com,
	isaku.yamahata@intel.com,
	isaku.yamahata@gmail.com
Subject: [PATCH 6/7] fixup! KVM: TDX: Implement hooks to propagate changes of TDP MMU mirror page table
Date: Mon, 13 Jan 2025 10:13:12 +0800
Message-ID: <20250113021312.18976-1-yan.y.zhao@intel.com>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20250113020925.18789-1-yan.y.zhao@intel.com>
References: <20250113020925.18789-1-yan.y.zhao@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove the retry loop for tdh_phymem_page_wbinvd_hkid().

tdh_phymem_page_wbinvd_hkid() just acquires the lock on the PAMT entry of
the page to be wbinvd, so it's not expected to encounter TDX_OPERAND_BUSY.

Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
 arch/x86/kvm/vmx/tdx.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 4fb9faca5db2..baabae95504b 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1712,14 +1712,7 @@ static int tdx_sept_drop_private_spte(struct kvm *kvm, gfn_t gfn,
 		return -EIO;
 	}
 
-	do {
-		/*
-		 * TDX_OPERAND_BUSY can happen on locking PAMT entry.  Because
-		 * this page was removed above, other thread shouldn't be
-		 * repeatedly operating on this page.  Just retry loop.
-		 */
-		err = tdh_phymem_page_wbinvd_hkid(hpa, (u16)kvm_tdx->hkid);
-	} while (unlikely(err == (TDX_OPERAND_BUSY | TDX_OPERAND_ID_RCX)));
+	err = tdh_phymem_page_wbinvd_hkid(hpa, (u16)kvm_tdx->hkid);
 
 	if (KVM_BUG_ON(err, kvm)) {
 		pr_tdx_error(TDH_PHYMEM_PAGE_WBINVD, err);
-- 
2.43.2


