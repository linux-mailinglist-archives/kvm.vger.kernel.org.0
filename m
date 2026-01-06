Return-Path: <kvm+bounces-67127-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED9BDCF7D08
	for <lists+kvm@lfdr.de>; Tue, 06 Jan 2026 11:36:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B912430AB4B9
	for <lists+kvm@lfdr.de>; Tue,  6 Jan 2026 10:32:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 018E233509A;
	Tue,  6 Jan 2026 10:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MpWWpEoq"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C7CF31B101;
	Tue,  6 Jan 2026 10:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767695128; cv=none; b=Y9rpJepNs19e+spHxeHxoeXN/ZYP5nZbOeCV44TXCNo3Qs8WzGYtb36VkkgjMK2jcgr7lcBh2exGmnSSulljCJqdwLzzHSXMS3lg5kYdK8fORu6R1RGEcpZELeX30PRn/VBY7jBg/6dSAijzt1TjEjfeTuBKvWa5gnnBDb/fUaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767695128; c=relaxed/simple;
	bh=GFiw5N2oVRbxNS+8hGRru/HArobn9JpEsHC0envKVVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OTPgjg1ZwBKdzzkI7m+eOB2i87y1lvz2gTPoeBXcr+gtTpxURfKAgMwj6shc3BAndvQQipUjiGnpH9kwx9goC6rWBGghTky/IdnmVZaGjxO7Ww01RZp9RBeYyz4euifnXjktu2/sk2LSBylAIgse9tD11O+QvivU+dDnMAmcOTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MpWWpEoq; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1767695124; x=1799231124;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GFiw5N2oVRbxNS+8hGRru/HArobn9JpEsHC0envKVVQ=;
  b=MpWWpEoqfigS3OselD3xZtCOp5bvcnoO/mv0ej+PFYWb6R1OH0UVDzx4
   yuK/AJVMycHN3yLwywtgfuE5lhXwhW9SsBwNN/j0uR4CwrXd2hxiCg8Xm
   N5OOnFKCPPFV96RIefvkLKTuo1u2M+7cxEgs3kPAGDxLZ8aA16miTi9mD
   zocx5LOWN5QyWnxzPwdb92n/uyV6lfXiXVKpmBMFbWIoQi7MuQFg8KYH7
   D9AWlVz9qCZOaJiccYyXkZDZnJHdtnkhlgtBAY0Q59+32S6PtJgfTfK9O
   0N7TBX+h72492g2JZqEefH3iCPTYBokZnzROKt7C93cSx6zE4r00kYUQA
   g==;
X-CSE-ConnectionGUID: xjoP9fitQbq7G+EeyVGpug==
X-CSE-MsgGUID: /zkdPUbgQRO2GWBgTpZYXw==
X-IronPort-AV: E=McAfee;i="6800,10657,11662"; a="86645841"
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="86645841"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:21 -0800
X-CSE-ConnectionGUID: xGgCTDkEQ6Gp1MSB+4d6rQ==
X-CSE-MsgGUID: et/eJSCTTlysGA8yEqT+ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,204,1763452800"; 
   d="scan'208";a="202246988"
Received: from yzhao56-desk.sh.intel.com ([10.239.47.19])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jan 2026 02:25:14 -0800
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
Subject: [PATCH v3 18/24] x86/virt/tdx: Add loud warning when tdx_pamt_put() fails.
Date: Tue,  6 Jan 2026 18:23:18 +0800
Message-ID: <20260106102318.25227-1-yan.y.zhao@intel.com>
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

tdx_pamt_put() does not return any error to its caller when SEAMCALL
TDH_PHYMEM_PAMT_REMOVE fails. Though pamt_refcount for the failed 2MB
physical range is increased (so the DPAMT pages stay added), it will cause
that the 2MB physical range can only be mapped at 4KB level, i.e., later
SEAMCALL TDH_MEM_PAGE_AUG on the 2MB range at 2MB level will therefore fail
forever.

Since tdx_pamt_put() only fails when there are bugs in the host kernel or
in the TDX module, simply add a loud warning to aid debugging after such an
error occurs.

Link: https://lore.kernel.org/all/67d55b24ef1a80af615c3672e8436e0ac32e8efa.camel@intel.com
Suggested-by: Rick Edgecombe <rick.p.edgecombe@intel.com>
Signed-off-by: Yan Zhao <yan.y.zhao@intel.com>
---
v3:
- new patch
---
 arch/x86/virt/vmx/tdx/tdx.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index c12665389b67..76963c563906 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -2348,8 +2348,7 @@ void tdx_pamt_put(struct page *page)
 			 */
 			atomic_inc(pamt_refcount);
 
-			pr_err("TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
-
+			WARN_ONCE(1, "TDH_PHYMEM_PAMT_REMOVE failed: %#llx\n", tdx_status);
 			/*
 			 * Don't free pamt_pa_array as it could hold garbage
 			 * when tdh_phymem_pamt_remove() fails.
-- 
2.43.2


