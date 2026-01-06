Return-Path: <kvm+bounces-67126-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 40BA7CF7F01
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 12:01:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id CEC48301FA52
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 11:01:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7CD933439F;
	Tue,  6 Jan 2026 10:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="FcJ6LkEU"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E244633343F;
	Tue,  6 Jan 2026 10:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695109; cv=none; b=Vyv/lqQVNnm4/6B9RQSN+wYrKDJvblcj/jqL1u8ndftOIBX+iOndHWLfxhTGPetwTUVw691/84NSe1FxZV9o1meAwuc7J6WCYPhCPyz7lAF6l7cFEGGpB7CtVGgviG1HS29cggrNBlJKrxmgZX3UtqkEMDXTk9Ph0U+jBUyznb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695109; c=relaxed/simple;
	bh=9WemXhIcKEOzBmDaVfEziMNELHtArYfBszBdtuSN710=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gbPk44nJ9fUClM/xB2yF+GD2YolzeZKUpUrNX803FwmUfDH3NHtnZL3vm/36Rhp1edYJOHReXhIvWgl5LAM5V77AauP9iU2QG541Tae6rbeJJC7hlywgn70MIGMZjcRAV7LDThZpr+sGLZUQzPa2h/WrPiI1rIHdkVF5s0oWnfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=FcJ6LkEU; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695108; x=1799231108;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9WemXhIcKEOzBmDaVfEziMNELHtArYfBszBdtuSN710=;
  b=FcJ6LkEU+64qGNan8oSWoakP4Tjf0xku8aZGeR09oydtf8YcOiOGR9pc
   ahuu+CU/BQ3N2UU4RXFBvz41VuBekSCpg9/m5kMMXocgoR390YzWFR4Y4
   y2XI7sK3HIDmv/8HRMZKNocKrLXhAPP/hJOgqFDeRZAZgVR5uL9HTV29d
   p/y7tfLn/VkK1ZhEhWra0O3tHwBmOBd4Rf3c7xyYpbCE1LjROUQSOvRPE
   cKbXRb5jqvZCBCcrlSCwV7pCdqRE+/H5lh2e0Ydfbjp87p17hPs+Lk+JM
   ENm9u1EJu50CERYZqfRvM9OpNnWA7wt3bwog4tLGVgqGW0wvHTA1NMT2T
   g==;
X-CSE-ConnectionGUID: Qncxhx8mRZ6r8IMKS9Qi9A==
X-CSE-MsgGUID: clQP6uSmTiWTk0Sp3h6lWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="86645828"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="86645828"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:07 -0800
X-CSE-ConnectionGUID: 2QYusNpMSKGDujp5XjzsOQ==
X-CSE-MsgGUID: Y/hOs/sZRWmRzIvJaGe/zw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202246964"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:00 -0800
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
Subject: [PATCH v3 17/24] KVM: TDX: Get/Put DPAMT page pair only when mapping size is 4KB
Date: Tue,  6 Jan 2026 18:23:04 +0800
Message-ID: <20260106102304.25211-1-yan.y.zhao@intel.com>
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

Invoke tdx_pamt_{get/put}() to add/remove Dynamic PAMT page pair for guest
private memory only when the S-EPT mapping size is 4KB.

When the mapping size is greater than 4KB, static PAMT pages are used. No
need to install/uninstall extra PAMT pages dynamically.

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
[Yan: Move level checking to callers of tdx_pamt_{get/put}()]
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- new patch

  Checking for 4KB level was previously done inside tdx_pamt_{get/put}() in
  DPAMT v2 [1].

  Move the checking to callers of tdx_pamt_{get/put}() in KVM to avoid
  introducing an extra "level" parameter to tdx_pamt_{get/put}(). This is
  also because the callers that could have level > 4KB are limited in KVM,
  i.e., only inside tdx_sept_{set/remove}_private_spte().

[1] https://lore.kernel.org/all/20250609191340.2051741-5-kirill.shutemov@linux.intel.com
---
 arch/x86/kvm/vmx/tdx.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kvm/vmx/tdx.c b/arch/x86/kvm/vmx/tdx.c
index 712aaa3d45b7..c1dc1aaae49d 100644
--- a/arch/x86/kvm/vmx/tdx.c
+++ b/arch/x86/kvm/vmx/tdx.c
@@ -1722,9 +1722,11 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	WARN_ON_ONCE(!is_shadow_present_pte(mirror_spte) ||
 		     (mirror_spte & VMX_EPT_RWX_MASK) != VMX_EPT_RWX_MASK);
 
-	ret = tdx_pamt_get(page, &tdx->prealloc);
-	if (ret)
-		return ret;
+	if (level == PG_LEVEL_4K) {
+		ret = tdx_pamt_get(page, &tdx->prealloc);
+		if (ret)
+			return ret;
+	}
 
 	/*
 	 * Ensure pre_fault_allowed is read by kvm_arch_vcpu_pre_fault_memory()
@@ -1743,7 +1745,7 @@ static int tdx_sept_set_private_spte(struct kvm *kvm, gfn_t gfn,
 	else
 		ret = tdx_mem_page_add(kvm, gfn, level, pfn);
 
-	if (ret)
+	if (ret && level == PG_LEVEL_4K)
 		tdx_pamt_put(page);
 
 	return ret;
@@ -1911,7 +1913,9 @@ static void tdx_sept_remove_private_spte(struct kvm *kvm, gfn_t gfn,
 
 	tdx_quirk_reset_folio(folio, folio_page_idx(folio, page),
 			      KVM_PAGES_PER_HPAGE(level));
-	tdx_pamt_put(page);
+
+	if (level == PG_LEVEL_4K)
+		tdx_pamt_put(page);
 }
 
 /*
-- 
2.43.2


