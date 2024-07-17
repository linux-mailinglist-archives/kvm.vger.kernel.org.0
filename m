Return-Path: <kvm+bounces-21751-lists+kvm=lfdr.de@vger.kernel.org>
X-Original-To: lists+kvm@lfdr.de
Delivered-To: lists+kvm@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1633D9335B9
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 05:42:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 3AA0B1C2297F
	for <lists+kvm@lfdr.de>; Wed, 17 Jul 2024 03:42:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C6E0D1C287;
	Wed, 17 Jul 2024 03:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZqGVdW2o"
X-Original-To: kvm@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 693CB6FC5;
	Wed, 17 Jul 2024 03:41:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721187663; cv=none; b=q7pEkCaY+dPzKjSwk5/SdNax8lpgnlDGWIyuB43kqDdVvX0Mt7A9a9PmZKwsQuJrkW8eeZizNwSod+gy7dQiXsl3xmR1vjmcllN7kVLuH27WHTMtmj9rpY5pum2uT3xPcUIVshbbiYvhTfLI2nOZUFs0GLiQTmLwYh/NJaJ60UQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721187663; c=relaxed/simple;
	bh=zkpzPQBW+wdkw7+sGa7f8TPFwfRx7djCUEW7k3GcdvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GR0PbfAf7/SHkzqTVchnVjAJdIS6OEuEhhHGBfbwJqb13fN3c9fTT0Z84ywzk32cY5V+/iNCEeBENSYQYuf5LXJeW6jpOIF6dQpi5sEzDXzRZwNcuxRKJT+Gb1mFq2ADfh/Uq6OVkz1O7S+FclgbeOwg5mXEdy91OiCuioDPXV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZqGVdW2o; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721187661; x=1752723661;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zkpzPQBW+wdkw7+sGa7f8TPFwfRx7djCUEW7k3GcdvA=;
  b=ZqGVdW2oA2MXYQQX8B6VovKXApCnAprzSKWIDqPx1OLGBE8tOEYlQ91i
   5uSORMcVgYpCMLSJgRaeqILr1/0y3U2uBvvjRq8Itm8/anBpW4S8gK/XR
   3N1teAoFZT2ezqIpOHooanwiKRgI5R0SdKeWZ32Y4mXnZ22YAlKeayv+v
   m72YzDdAvFHJCQihcFTxwJFXYO7PSZHL023sM7hG8KMbVj/Lj3kLBSisA
   1xUP1Ne9/fDeim/WmQNv6RPtidi2krhyvDXeprDh/VDJbK4T14UtiNb/Z
   oQuc5EWlR8y2FSGJnOtw1H3Rm1Ou8o3hm3Tw/KuF7MSURVAUrfIawWVHD
   w==;
X-CSE-ConnectionGUID: JSnaBXvXRHyRZSmRsycyqA==
X-CSE-MsgGUID: d10l9H7PRuOhoHxMBHX/oQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11135"; a="18512406"
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="18512406"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:53 -0700
X-CSE-ConnectionGUID: jmg1LbMrQPyzEqZ1SkAeGw==
X-CSE-MsgGUID: +SodeNgaRzuaXflU9ago+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,213,1716274800"; 
   d="scan'208";a="54566729"
Received: from rfrazer-mobl3.amr.corp.intel.com (HELO khuang2-desk.gar.corp.intel.com) ([10.124.222.184])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jul 2024 20:40:50 -0700
From: Kai Huang <kai.huang@intel.com>
To: dave.hansen@intel.com,
	kirill.shutemov@linux.intel.com,
	bp@alien8.de,
	tglx@linutronix.de,
	peterz@infradead.org,
	mingo@redhat.com,
	hpa@zytor.com,
	seanjc@google.com,
	pbonzini@redhat.com,
	dan.j.williams@intel.com
Cc: x86@kernel.org,
	kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	rick.p.edgecombe@intel.com,
	isaku.yamahata@intel.com,
	chao.gao@intel.com,
	binbin.wu@linux.intel.com,
	kai.huang@intel.com
Subject: [PATCH v2 05/10] x86/virt/tdx: Move field mapping table of getting TDMR info to function local
Date: Wed, 17 Jul 2024 15:40:12 +1200
Message-ID: <5fae6d65a9fe68ac85799164866c25305c7a93be.1721186590.git.kai.huang@intel.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1721186590.git.kai.huang@intel.com>
References: <cover.1721186590.git.kai.huang@intel.com>
Precedence: bulk
X-Mailing-List: kvm@vger.kernel.org
List-Id: <kvm.vger.kernel.org>
List-Subscribe: <mailto:kvm+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:kvm+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For now the kernel only reads "TD Memory Region" (TDMR) related global
metadata fields to a 'struct tdx_tdmr_sysinfo' for initializing the TDX
module.  The kernel populates the relevant metadata fields into the
structure using a "field mapping table" of metadata field IDs and the
structure members.

Currently the scope of this "field mapping table" is the entire C file.
Future changes will need to read more global metadata fields that will
be organized in other structures and use this kind of field mapping
tables for other structures too.

Move the field mapping table to the function local to limit its scope so
that the same name can also be used by other functions.

Signed-off-by: Kai Huang <kai.huang@intel.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
---

v1 -> v2:
 - Added Nikolay's tag.

---
 arch/x86/virt/vmx/tdx/tdx.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/arch/x86/virt/vmx/tdx/tdx.c b/arch/x86/virt/vmx/tdx/tdx.c
index 50d49c539e63..86c47db64e42 100644
--- a/arch/x86/virt/vmx/tdx/tdx.c
+++ b/arch/x86/virt/vmx/tdx/tdx.c
@@ -322,17 +322,17 @@ static int stbuf_read_sysmd_multi(const struct field_mapping *fields,
 #define TD_SYSINFO_MAP_TDMR_INFO(_field_id, _member)	\
 	TD_SYSINFO_MAP(_field_id, struct tdx_tdmr_sysinfo, _member)
 
-/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
-static const struct field_mapping fields[] = {
-	TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
-	TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
-	TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
-	TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
-	TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
-};
-
 static int get_tdx_tdmr_sysinfo(struct tdx_tdmr_sysinfo *tdmr_sysinfo)
 {
+	/* Map TD_SYSINFO fields into 'struct tdx_tdmr_sysinfo': */
+	static const struct field_mapping fields[] = {
+		TD_SYSINFO_MAP_TDMR_INFO(MAX_TDMRS,		max_tdmrs),
+		TD_SYSINFO_MAP_TDMR_INFO(MAX_RESERVED_PER_TDMR, max_reserved_per_tdmr),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_4K_ENTRY_SIZE,    pamt_entry_size[TDX_PS_4K]),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_2M_ENTRY_SIZE,    pamt_entry_size[TDX_PS_2M]),
+		TD_SYSINFO_MAP_TDMR_INFO(PAMT_1G_ENTRY_SIZE,    pamt_entry_size[TDX_PS_1G]),
+	};
+
 	/* Populate 'tdmr_sysinfo' fields using the mapping structure above: */
 	return stbuf_read_sysmd_multi(fields, ARRAY_SIZE(fields), tdmr_sysinfo);
 }
-- 
2.45.2


